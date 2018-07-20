% plot RL vs NL
% markers for NL indicate the amount of std in init.
% 1) markers for RL indicate the amount of corruption of label (all have the same type of initialization)
% 2) markers for RL indicate the size of initialization (but can have a
% constant amount of corruption first and then increase it later. Note that
% to indicate this increase in corruption in label we would need perhaps
% colors of dots increasing in darkness for more corrupted)
%%
markers = corruption_all_probs;
markers = std_inits_all;
%%%%RLs = 8:19;
% RLs = 62:73;
% train_all_losses_normalized(RLs) = train_all_losses_normalized_rand(RLs);
% test_all_losses_normalized(RLs) = test_all_losses_normalized_rand(RLs);
% train_all_errors_unnormalized(RLs) = train_all_errors_unnormalized_rand(RLs);
% gen_all_errors_unnormalized(RLs) = gen_all_errors_unnormalized_rand(RLs);
% 
% train_all_losses_unnormalized(RLs) = train_all_losses_unnormalized_rand(RLs);
% test_all_losses_unnormalized(RLs) = test_all_losses_unnormalized_rand(RLs);
%% test error vs train error 
fig0 = figure;
%lscatter(train_all_errors_unnormalized,gen_all_errors_unnormalized,markers)
lscatter(train_all_errors_unnormalized,gen_all_errors_unnormalized,markers)
xlim([-0.05,1])
xlabel('Train Error (Network Normalized)')
ylabel('Test Error (Network Normalized)')
%lsline
xlim([-0.05,1])
xlabel('Train Error (Network Normalized)')
ylabel('Test Error (Network Normalized)')
%% test error vs train loss (all normalized)
fig1 = figure;
lscatter(train_all_losses_normalized,gen_all_errors_normalized,markers)
%lscatter(all_train_errors,gen_all_errors_normalized,markers)
%lsline
%title('The weights of all models are normalized')
xlabel('Train Loss (Network Normalized)')
ylabel('Test Error (Network Normalized)')
%% IMPORTANT: test loss vs train loss (all normalized) - shows the linear correlation of the train loss and test loss
% fig2 = figure;
% lscatter(train_all_losses_normalized,test_all_losses_normalized,markers)
% %title('The weights of all models are normalized')
% xlabel('Train Loss (Network Normalized)')
% ylabel('Test Loss (Network Normalized)')
% hl = lsline;
% B = [ones(size(hl.XData(:))), hl.XData(:)]\hl.YData(:);
% Slope = B(2)
% Intercept = B(1)
% X = train_all_losses_normalized;y = test_all_losses_normalized;
% mdl = fitlm(X,y);
% RMSE = mdl.RMSE
% Rsquared_Ordinary = mdl.Rsquared.Ordinary
% Rsquared_adjusted = mdl.Rsquared
%
fig2 = figure;
lscatter(train_all_losses_normalized,test_all_losses_normalized,markers)
hold;
hl = lsline;
B = [ones(size(hl.XData(:))), hl.XData(:)]\hl.YData(:);
Slope = B(2)
Intercept = B(1)
X = train_all_losses_normalized;y = test_all_losses_normalized;
mdl = fitlm(X,y);
RMSE = mdl.RMSE
Rsquared_Ordinary = mdl.Rsquared.Ordinary
Rsquared_adjusted = mdl.Rsquared
xlabel('Train Loss (Network Normalized)')
ylabel('Test Loss (Network Normalized)')
%% IMPORTANT TEST ERROR CORRELATION: test error (unormalized) vs train loss (normalized)
fig3 = figure;
lscatter(train_all_losses_normalized,gen_all_errors_unnormalized,markers)
%lsline
%title('Train Loss vs Test Error')
xlabel('Train Loss (Network Normalized)')
ylabel('Test Error (Network Unnormalized)')
%% CONTROL1: test loss (unormalized) vs train loss (unnormalized)
fig5 = figure;
lscatter(train_all_losses_unnormalized,test_all_losses_unnormalized,markers)
title('Control 1: The weights of all models are unnormalized')
xlabel('Train Loss (Network Unnormalized)')
ylabel('Test Loss (Network Unnormalized)')
xlim([-2.5e-4,9e-3])
%% CONTROL2: test error (unormalized) vs train loss (unnormalized)
fig6 = figure;
lscatter(train_all_losses_unnormalized,gen_all_errors_unnormalized,markers)
%lsline
title('Control 2: The weights of all models are unnormalized')
xlabel('Train Loss (Network Unnormalized)')
ylabel('Test Error (Network Unnormalized)')
%% save
saveas(fig0,'test_error_vs_train_error_all_unnormalized');
saveas(fig0,'test_error_vs_train_error_all_unnormalized','pdf');
%
saveas(fig1,'test_error_vs_train_loss_all_normalized');
saveas(fig1,'test_error_vs_train_loss_all_normalized','pdf');
%
saveas(fig2,'important_test_loss_vs_train_loss_all_normalized');
saveas(fig2,'important_test_loss_vs_train_loss_all_normalized','pdf');
%
saveas(fig3,'important_test_error_vs_train_loss_unnormalized_vs_normalized');
saveas(fig3,'important_test_error_vs_train_loss_unnormalized_vs_normalized','pdf');
%
saveas(fig5,'control1_test_error_vs_train_loss_all_unnormalized');
saveas(fig5,'control1_test_error_vs_train_loss_all_unnormalized','pdf');
%
saveas(fig6,'control2_test_error_vs_train_loss_all_unnormalized');
saveas(fig6,'control2_test_error_vs_train_loss_all_unnormalized','pdf');