allSettings = {[1 1 0 0 1 1 1 0 1]};
progress = [300 100 0.5 1 60 60 1];
popSize = 1000;
pALS = [4 1 0.5];

for i = 1:length(allSettings) %settings
    settings = allSettings{i};
    name = num2str(settings);
    fileName = ['L-GADEALS/' name(~isspace(name)) '.xlsx'];
    writecell({popSize,30,'func',progress,settings,pALS}, fileName, 'Range', 'A35');
    writematrix(name, fileName, 'Range', 'A31');
    writematrix('LPSR (L-SHADE) and GADEALS', fileName, 'Range', 'S36');
    
    loop = 0;
    for funcNum = 1:30
        %nameFunc = ['f' num2str(funcNum) '.xlsx'];
        range = ['A' num2str(funcNum)];
            
            avgErr = 0;
            for p = 1:20
                err = AGA(popSize,30,funcNum,progress,...
                    settings,pALS);
                avgErr = avgErr + err;
            end
            avgErr = avgErr/p;
            loop = loop + 1;
            disp({avgErr funcNum loop num2str(settings)})
            params = {avgErr};
            writecell(params,fileName,'Range',range);
                   
    end
end