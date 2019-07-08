%[h] = ranksum (valor es do melhor, valores dos outros)

knnSeg1_AR06 = [0.962963, 0.979303, 0.977669, 0.966231, 0.968954];
knnSeg1_AR10 = [0.944989, 0.971678, 0.970044, 0.952614, 0.957516];

knnSeg2_AR04 = [0.975490, 0.985839, 0.979303, 0.968954, 0.979847];
knnSeg2_AR07 = [0.974946, 0.983115, 0.982571, 0.972767, 0.975490];
knnSeg2_AR09 = [0.965142, 0.976580, 0.973312, 0.966231, 0.965686];

knnSeg3_AR07 = [0.986275, 0.990196, 0.982571, 0.990196, 0.982571];
knnSeg3_AR10 = [0.984314, 0.992157, 0.976035, 0.980392, 0.976035];

knnSeg4_AR05 = [0.961601, 0.975490, 0.968137, 0.952614, 0.965686];
knnSeg4_AR06 = [0.964869, 0.976307, 0.975490, 0.952614, 0.963235];

knnSeg5_AR04 = [0.974673, 0.988154, 0.984069, 0.972631, 0.977941];
knnSeg5_AR10 = [0.955474, 0.979984, 0.970588, 0.959559, 0.971814];

%knnSeg1_AR06 = [0.9710; 0.9645; 0.9680; 0.9659; 0.9653; 0.9641; 0.9629; 0.9615; 0.9612; 0.9588; 0.9593; 0.9585; 0.9577; 0.9576; 0.9562; 0.9550; 0.9550; 0.9535; 0.9525; 0.9520];
%knnSeg1_AR10 = [0.9594; 0.9499; 0.9557; 0.9500; 0.9519; 0.9507; 0.9511; 0.9480; 0.9490; 0.9471; 0.9469; 0.9453; 0.9454; 0.9449; 0.9417; 0.9413; 0.9414; 0.9408; 0.9406; 0.9390];

[p, h] = ranksum(knnSeg3_AR07,knnSeg1_AR06);
fprintf('Seg1 - AR06: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg1_AR10);
fprintf('Seg1 - AR10: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg2_AR04);
fprintf('Seg2 - AR04: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg2_AR07);
fprintf('Seg2 - AR07: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg2_AR09);
fprintf('Seg2 - AR09: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg3_AR07);
fprintf('Seg3 - AR07: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg3_AR10);
fprintf('Seg3 - AR10: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg4_AR05);
fprintf('Seg4 - AR05: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg4_AR06);
fprintf('Seg4 - AR06: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg5_AR04);
fprintf('Seg5 - AR04: [p]%3.9f  - [h]%i\n', p, h);
[p, h] = ranksum(knnSeg3_AR07,knnSeg5_AR10);
fprintf('Seg5 - AR10: [p]%3.9f  - [h]%i\n', p, h);

