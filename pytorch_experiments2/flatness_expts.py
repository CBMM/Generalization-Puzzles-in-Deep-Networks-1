"""
training an image classifier so that it overfits
----------------------------

"""
import time
from datetime import date
import calendar

import os
import sys

current_directory = os.getcwd() #The method getcwd() returns current working directory of a process.
sys.path.append(current_directory)

import torch

from torch.autograd import Variable
import torch.optim as optim

import data_classification as data_class

import nn_models as nn_mdls
import training_algorithms as tr_alg
import save_to_matlab_format as save2matlab
import utils

from pdb import set_trace as st

import argparse

parser = argparse.ArgumentParser(description='PyTorch Example')
parser.add_argument('-cuda','--enable-cuda',action='store_true',
                    help='Enable cuda/gpu')
args = parser.parse_args()
if not torch.cuda.is_available() and args.enable_cuda:
    print('Cuda is enabled but the current system does not have cuda')
    sys.exit()

def main():
    ''' date parameters setup'''
    today_obj = date.today() # contains datetime.date(year, month, day); accessible via .day etc
    day = today_obj.day
    month = calendar.month_name[today_obj.month]
    start_time = time.time()
    ''' '''
    results_root = './test_runs_flatness'
    expt_path = 'flatness_debug2'
    matlab_file_name = f'flatness_{day}_{month}'
    ''' '''
    nb_epochs = 2
    batch_size = 4
    #batch_size_train,batch_size_test = batch_size,batch_size
    batch_size_train = batch_size
    batch_size_test = 512
    data_path = './data'
    num_workers = 2 # how many subprocesses to use for data loading. 0 means that the data will be loaded in the main process.
    ''' get (gau)normalized range [-1, 1]'''
    trainset,trainloader, testset,testloader, classes = data_class.get_cifer_data_processors(data_path,batch_size_train,batch_size_test,num_workers)
    ''' get NN '''
    ## conv params
    nb_filters1,nb_filters2 = 6, 18
    kernel_size1,kernel_size2 = 5,5
    ## fc params
    nb_units_fc1,nb_units_fc2,nb_units_fc3 = 120,84,len(classes)
    C,H,W = 3,32,32
    net = nn_mdls.BoixNet(C,H,W,nb_filters1,nb_filters2, kernel_size1,kernel_size2, nb_units_fc1,nb_units_fc2,nb_units_fc3)
    if args.enable_cuda:
        net.cuda()
    ''' Cross Entropy + Optmizer'''
    lr = 0.01
    momentum = 0
    criterion = torch.nn.CrossEntropyLoss()
    #loss = torch.nn.MSELoss(size_average=True)
    optimizer = optim.SGD(net.parameters(), lr=lr, momentum=momentum)
    ''' stats collector '''
    stats_collector = tr_alg.StatsCollector(net,None,None)
    ''' Train the Network '''
    # We simply have to loop over our data iterator, and feed the inputs to the network and optimize.
    #tr_alg.train_cifar(args, nb_epochs, trainloader,testloader, net,optimizer,criterion)
    error_criterion = tr_alg.error_criterion
    train_loss_epoch, train_error_epoch, test_loss_epoch, test_error_epoch = tr_alg.train_and_track_stats2(args, nb_epochs, trainloader,testloader, net,optimizer,criterion,error_criterion, stats_collector)
    seconds,minutes,hours = utils.report_times(start_time)
    print(f'Finished Training, hours={hours}')
    ''' Test the Network on the test data '''
    print(f'train_loss_epoch={train_loss_epoch} \ntrain_error_epoch={train_error_epoch} \ntest_loss_epoch={test_loss_epoch} \ntest_error_epoch={test_error_epoch}')
    ''' save results from experiment '''
    save2matlab.save2matlab_flatness_expt(results_root,expt_path,matlab_file_name, stats_collector)
    ''' save net model '''
    path = os.path.join(results_root,expt_path,'net')
    utils.save_entire_mdl(path,net)
    restored_net = utils.restore_entire_mdl(path)
    loss_restored,error_restored = tr_alg.evalaute_mdl_data_set(criterion,error_criterion,restored_net,testloader,args.enable_cuda)
    print(f'\nloss_restored={loss_restored},error_restored={error_restored}')

if __name__ == '__main__':
    main()
    print('\a')