minErr = zeros(1,30) + Inf;
filename = 'testdata.xlsx';
filename2 = 'populations.xlsx';
%writecell({'popSize' 'D' 'funcNum' 'progress' 'settings' 'incest' 'crossoverRange' 'avgErr'},filename,'Range','A1');
allSettings = {[1 0 0 0 0] [1 0 0 1 0 ] [0 1 0 1 0] [0 1 0 0 0]};
allProgress = {[40 40 0.35] [80 80 0.6]};
popSizes = 1000:1000:5000;
figure(1);
h = animatedline;
range = ['A' '2'];
parfor funcNum = 1:30
    %range = ['A' num2str(funcNum)+1];
    nameFunc = ['f' num2str(funcNum) '.xlsx']
    namePop = ['p' num2str(funcNum) '.xlsx']
    writecell({'popSize' 'D' 'funcNum' 'progress' 'settings' 'incest'...
        'crossoverRange' 'avgErr'},nameFunc,'Range','A1');
    for i = 1:length(allSettings) %settings
        settings = allSettings{i};
        for j = 1:length(allProgress) %progress
            progress = allProgress{j};
            for k = 1:length(popSizes) %population sizes
                popSize = popSizes(k);
                for incest = 1:4 %incest
                    for crossoverRange = 6:10 %crossover
                        
                        avgErr = 0;
                        for p = 1:3
                            [err,bestPop] = AGA(popSize,30,funcNum,progress,...
                                settings,incest*0.01,crossoverRange*0.1);
                            avgErr = avgErr + err;
                        end
                        avgErr = avgErr/10;
                        disp({avgErr funcNum})
                        figure(1)
                        addpoints(h,funcNum,avgErr/minErr(funcNum));
                        drawnow
                        if avgErr < minErr(funcNum)
                            minErr(funcNum) = avgErr;
                            params = {popSize,30,funcNum,num2str(progress),...
                                num2str(settings),incest*0.01,crossoverRange*0.1,...
                                avgErr};
                            writecell(params,nameFunc,'Range',range);
                            writematrix(bestPop,namePop,'Range',range);
                        end
                        
                    end
                end
            end
        end
    end
end