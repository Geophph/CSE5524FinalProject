target = imread('target.jpg');
modelR = 70;
modelC = 24;

modelCovMatrix = getCovMat(target,26, 255, modelR, modelC)

[holdi, holdj] = findInFrame(modelR, modelC, modelCovMatrix, target)

function [holdi,holdj] = findInFrame(modelR, modelC, modelCovMatrix, target)
    [row, col, colors] = size(target)
    minTot = Inf;
    for x = 1:row-modelR-1
        for y = 1:col-modelC-1
            a = getCovMat(target, x, y, modelR, modelC);
            dist = getCovMatDist(modelCovMatrix, a);
            if dist<minTot
                minTot = dist;
                holdi = x;
                holdj = y;
            end
        end
    end
    imshow(target)
    hold on;
    rectangle('position', [holdj holdi modelC-1 modelR-1], 'Edgecolor', 'g');
    hold off;
    fprintf("Selected Cordinates (% 10f, % 10f)\n", holdi, holdj);

end

function covMat = getCovMat(image, row, col, modelR, modelC)
    test = imcrop(image ,[col row modelC-1 modelR-1]);
    pixels = modelC*modelR;
    hold = zeros(pixels, 5);
    current = 1;
    for y = 1:modelC
        for x = 1:modelR
            hold(current,1) = y;
            hold(current,2) = x;
            hold(current,3) = test(x,y,1);
            hold(current,4) = test(x,y,2);
            hold(current,5) = test(x,y,3);
            current= current + 1;
        end
    end
    covMat = cov(hold,1);
end

function dist = getCovMatDist(C1,C2)
    dist = 0;
    genEig = eig(C1, C2);
    for i = 1:size(genEig)
        current = genEig(i);
        if current ~= 0
            current = log(current)^2;
            dist = dist+current;
        end
    end
    dist = sqrt(dist);
end