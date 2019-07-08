%[h] = ranksum (valor es do melhor, valores dos outros)

knnSeg1_AR06 = [0.990741, 0.997277, 0.994009, 0.980392, 0.991830];
knnSeg1_AR10 = [0.992375, 0.992375, 0.992375, 0.985294, 0.992919];

knnSeg2_AR04 = [0.993464, 0.996187, 0.993464, 0.989107, 0.994009];
knnSeg2_AR07 = [0.994009, 0.996732, 0.995098, 0.988562, 0.996187];
knnSeg2_AR09 = [0.991830, 0.996732, 0.995643, 0.991285, 0.995098];

knnSeg3_AR07 = [0.992157, 0.998039, 0.991285, 0.990196, 0.995643];
knnSeg3_AR10 = [0.994118, 0.998039, 0.989107, 0.996078, 0.995643];

knnSeg4_AR05 = [0.990196, 0.993464, 0.991830, 0.985294, 0.990196];
knnSeg4_AR06 = [0.987745, 0.991013, 0.994281, 0.978758, 0.993464];

knnSeg5_AR04 = [0.992239, 0.997141, 0.994281, 0.984069, 0.991013];
knnSeg5_AR10 = [0.992239, 0.996324, 0.993464, 0.991830, 0.994690];

%knnSeg1_AR06 = [0.9710; 0.9645; 0.9680; 0.9659; 0.9653; 0.9641; 0.9629; 0.9615; 0.9612; 0.9588; 0.9593; 0.9585; 0.9577; 0.9576; 0.9562; 0.9550; 0.9550; 0.9535; 0.9525; 0.9520];
%knnSeg1_AR10 = [0.9594; 0.9499; 0.9557; 0.9500; 0.9519; 0.9507; 0.9511; 0.9480; 0.9490; 0.9471; 0.9469; 0.9453; 0.9454; 0.9449; 0.9417; 0.9413; 0.9414; 0.9408; 0.9406; 0.9390];

[p, h] = ranksum(knnSeg3_AR10,knnSeg1_AR06, 'alpha',0.05);
fprintf('Seg1 - AR06: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg1_AR10, 'alpha',0.05);
fprintf('Seg1 - AR10: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg2_AR04, 'alpha',0.05);
fprintf('Seg2 - AR04: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg2_AR07, 'alpha',0.05);
fprintf('Seg2 - AR07: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg2_AR09, 'alpha',0.05);
fprintf('Seg2 - AR09: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg3_AR07, 'alpha',0.05);
fprintf('Seg3 - AR07: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg3_AR10, 'alpha',0.05);
fprintf('Seg3 - AR10: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg4_AR05, 'alpha',0.05);
fprintf('Seg4 - AR05: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg4_AR06, 'alpha',0.05);
fprintf('Seg4 - AR06: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg5_AR04, 'alpha',0.05);
fprintf('Seg5 - AR04: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR10,knnSeg5_AR10, 'alpha',0.05);
fprintf('Seg5 - AR10: [p]%3.9f  - [h]%i\n', p, h);

