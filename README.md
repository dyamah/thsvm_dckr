# thsvm_dckr

[thundersvm](https://github.com/Xtra-Computing/thundersvm) is a faster implementation for GPU device.
This project is to building a docker image for thundersvm and python environment. 

## Requirements

* Docker 18 CE or later
* GNU make

## How to Build images

**Quick Start** 

```shell
make DEVICE=gpu all
```

This make command create an image including thundersvm executable binaries based on nvidia CUDA-9.0 and CuDNN-7,  
python 3.6 environment and thundersvm python interfaces, and checking running binaries and python binding.  

If you want to create another CUDA, CuDNN or python version, you can pass the following variables to make:  

* CUDA_VERSION : The version of CUDA Libraries
* CUDNN_VERSION : The version of CuDNN tool kit
* PYTHON_VERSION : THe version of python

For example, the following make command will create a docker image including CUDA 9.1, CuDNN7 and python 3.7.       

```shell
make DEVICE=gpu CUDA_VERSION=9.1 CUDNN=7 PYTHON_VERSION=3.7 image
```

If you want an image without GPU environment, you can run a make command as follows: 


```shell
make DEVICE=cpu image
```

Have fun







