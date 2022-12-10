%Milestone1 scripts

%%
    sync_x = linspace(-1000, 1000);
    sync_pulse = sinc(sync_x);
    sync_pulse = rescale(sync_pulse, -1,1);

    plot(sync_x, sync_pulse)

%%
analyse_rec;

white_noise_recorded = simin;

IR2;

IR1;

