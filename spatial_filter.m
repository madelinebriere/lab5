clear;
% Retrieve um values.
[u1, Fs1] = audioread('mic_1_4.wav');
[u2, Fs2] = audioread('mic_2_4.wav');
[u3, Fs3] = audioread('mic_3_4.wav');
[u4, Fs4] = audioread('mic_4_4.wav');
[so, Fss] = audioread('target.wav');

um = [u1, u2, u3, u4];
M = 4;

%% Part a
t1m = [682 621 573 543];
l1 = 1;
l2 = size(u1,1)-t1m(1,1);
y = zeros(l2-l1+1, 1);

for m = 1:M
    starti = l1 + t1m(1,m);
    endi = l2 + t1m(1,m);
    y(l1:l2) = y(l1:l2) + um(starti:endi,m);
end
disp 'Playing averaged signal. Press enter to continue.'
soundsc(y,Fss);
pause


%% Part b
t1 = -717;
t2 = -517;
l1 = 1;
l2 = size(u1,1)+t1;
U = zeros(l2-l1+1, (t2-t1+1)*M);
i = 1;
for m = 1:M
    u = um(:, m);
    for delay = t1:t2
        col = u(l1-delay:l2-delay,1);
        U(:, i) = col;
        i=i+1;
    end
end
Ut = transpose(U);
U1 = (Ut*U);
U2 = inv(U1);
U3 = U2*Ut;
s = so(l1:l2,1);
h = U3*s;

i = 1;
figure(1)
for m = 1:M
    starti = (t2 - t1 + 1)*(m-1)+1;
    endi = starti + 200;
    hm = h(starti:endi, :);
    [Hm,w]=freqz(hm,1);
    subplot(M, 1, i);
    plot(w,abs(Hm));
    name = ['M = ' num2str(M) '  Filter ' num2str(m) ' Frequency Response'];
    title(name)
    xlabel('\omega')
    ylabel('Amplitude')
    axis([0 3.5 0 2200])
    i = i+1;
end

v = zeros(l2-l1+1, 1);
for l = l1:l2
    curr = 0;
    for m = 1:M
        for delay = t1:t2
            u = um(l-delay, m);
            index = delay - t1 + 1; % min 1, max 201
            shifted = (t2 - t1 + 1)*(m-1)+index;
            curr = curr + h(shifted, 1)*u;
        end 
    end
    v(l,1) = curr;
end
disp 'Playing filtered, reconstructed signal.'
soundsc(v, Fss);

%% Part c
title = ['reconstructed-'  num2str(m)  '.wav'];
audiowrite(title, v, Fss);