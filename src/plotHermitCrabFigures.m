function plotHermitCrabFigures(dpath)
% PLOTHERMITCRABFIGURES

arguments
    dpath {mustBeText, mustBeFolder} = fullfile("data");
end

% load the monitor calibration file
calibration_file = fullfile("data", "calibrations", "20161104_Dell1905fp_IP_calc.mat");
load(calibration_file, 'pol');

% open a new figure
figure(1);clf
set(gcf,'menubar','figure','color','w');

% iterate over data directories
for pp = [1 2 4 5]
    if pp==1, dname = '20200212_PaleHermitCrab2'; end %Pale polarization
    if pp==2, dname = '20200218_PurpleHermit_P';  end %Purple pol
    if pp==4, dname = '20200216_PaleHermit4_i';   end %Pale intensity   
    if pp==5, dname = '20200221_PurpleHermit_I';  end %Purple intensity
    datadir = fullfile(dpath,dname);
    assert(exist(datadir,'dir'), "The directory %s does not exist", datadir)
    flist = dir(datadir);
    fc=0; collatedH = [];collatedV = [];
    tuck=[]; stop = []; claw=[]; retreat = [];
    response=[]; Rtime=[]; Stime = []; Wtime = [];

    % Iterate over files in data directory
    for ff=1:size(flist,1)
        
        % Select the mat files containing response data
        [~,fname,fext] = fileparts(flist(ff).name);
        if size(flist(ff).name,2)>5 && strcmp(fext,'.mat')
            
            % Load experiment data file, 'C'
            file_to_load = fullfile(datadir,flist(ff).name);
            fprintf("loading %s \n", file_to_load);
            load(file_to_load, 'C');
            
            if isfield(C,'rawflash') && isfield(C,'scoreB')
                fc=fc+1;
                
                %Pull out flashes
                minf = min(C.rawflash(:,2));maxf = max(C.rawflash(:,2));
                midf = (maxf-minf)/2+minf;
                ind = C.rawflash(1:end-1,2)<midf & C.rawflash(2:end,2)>midf;
                ind = logical([0;ind]);
                C.flashtimes = C.rawflash(ind,1);
                %Remove flash markers <mintime apart
                fdiff = C.flashtimes(2:end)-C.flashtimes(1:end-1);
                ind=fdiff<1.5;
                ind=logical([0;ind]);
                C.flashtimes = C.flashtimes(ind==0);
                %Check for end marker
                inde = C.scoreB(:,2)==double('e');
                if sum(inde)>0
                    C.flashtimes = C.flashtimes(C.flashtimes<C.scoreB(inde,1));
                end
                %Make sure >80% of markers line up with data files
                dataflashes=C.exptstart;
                for tt=1:size(C.trial,2)
                    dataflashes= [dataflashes;C.trial(tt).start];
                    dataflashes= [dataflashes;C.trial(tt).maxloom];
                    dataflashes= [dataflashes;C.trial(tt).endloom];
                end
                dataflashes = sort(dataflashes-C.exptstart).*(24*60*60);
                yn=0;
                for ppp = 1:size(dataflashes,1)
                    minv = min(abs((C.flashtimes-C.flashtimes(1))-dataflashes(ppp)));
                    if minv<1, yn=yn+1; end
                end
                if yn<0.8*size(dataflashes,1)
                    yn=0;
                    for ppp = 1:size(dataflashes,1)
                        minv = min(abs((C.flashtimes-C.flashtimes(2))-dataflashes(ppp)));
                        if minv<1, yn=yn+1; end
                    end
                    if yn<0.8*size(dataflashes,1)
                
                    figure(4); clf;
                    plot(C.flashtimes-C.flashtimes(1))
                    hold on
                    plot(dataflashes)
                    hold off
                    [ff yn]
                    size(dataflashes)
                    disp('not enough markers synchronised')
                    error
                    end
                end
                %figure(44);
                %hold on
                %plot(dataflashes,ones(size(dataflashes)).*ff,'xg')
                %plot(dataflashes(2:3:end),ones(size(dataflashes(2:3:end))).*ff,'xb')
                %hold off
                C.vid.start = dataflashes(2:3:end)+C.flashtimes(1);
                C.vid.max = C.flashtimes(3:3:end)+C.flashtimes(1);
                C.vid.end = C.flashtimes(4:3:end)+C.flashtimes(1);
                
                %Response behaviours (whithin loom presentation only)
                
                for tt=1:size(C.playorder,1)
                    rr=0;Rt=nan;St=nan;Wt=nan; Tt=nan;
                    if size(C.playorder,1)>=tt && size(C.vid.start,1)>=tt
                        
                        ind = find(C.scoreB(:,1)>C.vid.start(tt)+0.5 & ...
                            C.scoreB(:,1)<C.vid.end(tt));
                        for ii=1:size(ind,1)
                            
                            switch C.scoreB(ind(ii),2)
                                case double('t')
                                    rr=1;
                                    Tt = C.scoreB(ind(ii),1)-C.vid.start(tt);
                                case double('r')
                                    rr=2;
                                    Rt = C.scoreB(ind(ii),1)-C.vid.start(tt);
                                case double('s')
                                    rr=3;
                                    St = C.scoreB(ind(ii),1)-C.vid.start(tt);
                                case double('w')
                                    Wt = C.scoreB(ind(ii),1)-C.vid.start(tt);
                                case double('x')
                                    rr=nan;
                            end
                            
                        end
                    end
                    response = [response;[C.loomRGB(C.playorder(tt),1),rr,tt]];
                    Rtime = [Rtime;Rt];Stime = [Stime;St];Wtime = [Wtime;Wt];
                end
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    yy=[];
    xx = unique(response(:,1));
    for X=1:size(xx,1)
        yy(X,1:3) = [mean(response(response(:,1)==xx(X),2),'omitnan'), ...
            std(response(response(:,1)==xx(X),2),'omitnan'), ...
            sum(~isnan(response(response(:,1)==xx(X),2)))];
        yy(X,4) = sum(response(response(:,1)==xx(X),2)>0);
    end
    yy(:,2) = yy(:,2)./sqrt(yy(:,3)); %Convert to SE
    
    
    %Look up degree of linear polairization (DoLP)
    dolp=interp1(pol.uint./255,pol.DoLP(:,2),xx);
   
    
    dolp_back=interp1(pol.uint./255,pol.DoLP(:,2),C.backRGB(1,1));
    if pp==4 || pp==5, dolp=xx; dolp_back = C.backRGB(1,1); end
    %Confidence intervals
    %[PHAT, PCI] = binofit(yy(:,4),yy(:,3));
    %Fit sigmoid curves
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    yyy=[];
    xxx = unique(response(:,3));
    for X=1:size(xxx,1)
        yyy(X,1:3) = [mean(response(response(:,3)==xxx(X),2),'omitnan'), ...
            std(response(response(:,3)==xxx(X),2),'omitnan'), ...
            sum(~isnan(response(response(:,3)==xxx(X),2)))];
        yyy(X,4) = sum(response(response(:,3)==xxx(X),2)>0);
    end
    yyy(:,2) = yyy(:,2)./sqrt(yyy(:,3)); %Convert to SE
    %Fit line to habituation data
    P=polyfit(xxx,yyy(:,4)./yyy(:,3),1);
    yv=polyval(P,[1 max(xxx)]);
    
    
    
    subplot(5,3,pp*3-2);
    dolp = dolp-dolp_back;
    plot([0 0],[0 1],'-k')
    hold on
    ind1=dolp>=0;
    ind2=dolp<=0;
    Psigm1=sigm_fit(dolp(ind1),yy(ind1,4)./yy(ind1,3),[0 nan nan nan]);
    Psigm2=sigm_fit(dolp(ind2),yy(ind2,4)./yy(ind2,3),[0 nan nan nan]);
    plot(dolp,yy(:,4)./yy(:,3),'ok','markersize',3,'markerfacecolor',[0.9 0.9 0.9])
    if pp==1 || pp==2
        plot([1 1].*Psigm1(3),[0 1],':r')
        text(0,0.9,...
            sprintf('%1.2f',Psigm1(3)),...
            'horizontalalignment','left','fontsize',9)
    end
    if pp>=3
        plot([1 1].*Psigm2(3),[0 1],':r')
        text(0,0.9,...
            sprintf('%1.2f',Psigm2(3)),...
            'horizontalalignment','right','fontsize',9)
    end
    nd=dolp<0.5;
    hold off
    set(gca,'xlim',[-0.5 0.5],'ylim',[0 1],'tickdir','out')
    %if pp==1, set(gca,'xticklabel',[]); end
     if pp==4 || pp==5
        set(gca,'xlim',[-0.06 0.06])
     end
    if pp==5
        xlabel('Weber contrast')
        ylabel('Response probability');
    end
    subplot(5,3,pp*3-1);
    plot([1 max(xxx)],yv,'-b')
    hold on
    plot(xxx,yyy(:,4)./yyy(:,3),'ok','markersize',3,'markerfacecolor',[0.9 0.9 0.9]);
    hold off
    set(gca,'xlim',[0 max(xxx)+1],'ylim',[0 1],'tickdir','out',...
        'yticklabel',[])
    text(0,0.1,sprintf('n=%1.0f-%1.0f',min(yyy(:,3)),max(yyy(:,3))),...
        'fontsize',9)
    if pp==5
        xlabel('Stimulus #');
        
    end
    
    subplot(5,3,pp*3);
    Rtime = Rtime(~isnan(Rtime));
    Stime = Stime(~isnan(Stime));
    Wtime = Wtime(~isnan(Wtime));
    interval=0.25;edges = [0:interval:10];
    
   %Make loom profile
   s=5;
   e = 0.5; % end set 'distance'
   drange = fliplr(e:...
       (s-e)/(3*30):s);
   ang = atan(1./drange);
   %Normalise to end size
   ang = ang-ang(1);
   ang = (ang./max(ang));
   ang = [ang,ones(1,60).*max(ang),zeros(1,150)];
   xang = (1:length(ang))./30;
   hold on
   N=histcounts(Wtime,edges);
   bar(edges(2:end)-interval/2,N,1,'facecolor','b')
   N=histcounts(Stime,edges);
   bar(edges(2:end)-interval/2,N,1,'facecolor','r')
   N=histcounts(Rtime,edges);
   bar(edges(2:end)-interval/2,-N,1,'facecolor','g')
   if pp==1
       plot(xang,ang.*45-90,'-k'); 
       set(gca,'ylim',[-115 70],'xticklabel',[])
   end
   if pp==2
       plot(xang,ang.*10-17,'-k');
       set(gca,'ylim',[-23 17])
   end
   if pp==4
       plot(xang,ang.*45-65,'-k');
       set(gca,'ylim',[-85 60])
   end
   if pp==5
       plot(xang,ang.*5-8,'-k');
       set(gca,'ylim',[-10 8])
       xlabel('Time (s)')
       ylabel('# of responses')
       
   end
   set(gca,'tickdir','out')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pagurus data
xlsfile = fullfile("data", "Pagurus", "PagurusResponseData.xlsx");
wksheet = 'Aggregated Data';

%load binary response data
binarydata = xlsread(xlsfile,wksheet,'AJ2:AR28');
size(binarydata)
for ll=1:size(binarydata,2)
    mloom(ll)=mean(binarydata(:,ll),'omitnan');
end
subplot(5,3,7);
polval = -0.4:0.1:0.4;
ind1=polval>=0;
ind2=polval<=0;
hold on
Psigm1=sigm_fit(polval(ind1),mloom(ind1),[0 nan nan nan]);
Psigm2=sigm_fit(polval(ind2),mloom(ind2),[0 nan nan nan]);
plot([0 0],[0 1],'-k')
plot([1 1].*Psigm2(3),[0 1],':r')
text(0,0.9,...
    sprintf('%1.2f',Psigm2(3)),...
    'horizontalalignment','right','fontsize',9)
    
  
plot(polval,mloom,'ok','markersize',3,'markerfacecolor',[0.9 0.9 0.9])
hold off
set(gca,'xlim', [-0.5, 0.5], 'ylim',[0 1],'box','on','tickdir','out')
xlabel('DoLP contrast'); 
%Presentation order
rawdata = xlsread(xlsfile,wksheet,'C2:T28');
for ll=1:9
    ind=rawdata(:,2*ll-1)>0;
    rawdata(ind,2*ll-1) = 1;
    mll(ll) = mean(rawdata(:,2*ll-1),'omitnan');
end
%Fit line to habituation data
P=polyfit(1:9,mll,1);
yv=polyval(P,[1 9]);
subplot(5,3,8);
hold on
plot([1 9],yv,'-b')
plot(1:9,mll,'ok','markersize',3,'markerfacecolor',[0.9 0.9 0.9]);
text(0,0.1,sprintf('n=%1.0f-%1.0f',size(rawdata,1)-1,size(rawdata,1)),...
    'fontsize',9)
hold off
set(gca,'xlim',[0 10],'ylim',[0 1],'tickdir','out',...
        'yticklabel',[],'box','on')



