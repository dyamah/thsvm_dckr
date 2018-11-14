CUDA_VERSION = 9.0
CUDNN_VERSION = 7
PYTHON_VERSION = 3.6

DEVICE = cpu

DOCKER = docker
DOCKER_REPOSITORY = dyamah/thsvm_dckr
DOCKER_TAG = $(DEVICE)-cuda$(CUDA_VERSION)-cudnn$(CUDNN_VERSION)-python$(PYTHON_VERSION)
DOCKER_IMAGE = $(DOCKER_REPOSITORY):$(DOCKER_TAG)
DOCKER_FILE = Dockerfile
BUILD_ARGS = --build-arg CUDA_VERSION="$(CUDA_VERSION)" --build-arg CUDNN_VERSION="$(CUDNN_VERSION)" \
						--build-arg PYTHON_VERSION="$(PYTHON_VERSION)" --build-arg DEVICE="$(DEVICE)"
ROOT_DIR = /opt/project
PREFIX   = $(ROOT_DIR)/thundersvm
SVM_TRAIN = $(PREFIX)/build/bin/thundersvm-train
TEST_DATA = $(PREFIX)/dataset/test_dataset.txt
MODEL_FILE = test.model
SVM_PREDICT = $(PREFIX)/build/bin/thundersvm-predict

VOLUME_MOUNT = -v $(CURDIR)/$(MODEL_FILE):$(ROOT_DIR)/$(MODEL_FILE)

CHECK_TRAIN_COMMAND = $(SVM_TRAIN) -c 100 -g 0.5 $(TEST_DATA) $(MODEL_FILE)
CHECK_PREDICTION_COMMAND = $(SVM_PREDICT) $(TEST_DATA) $(MODEL_FILE) output

.PHONY: all
all: image test;

.PHONEY: image
image: $(DOCKER_FILE)
	$(DOCKER) build $(BUILD_ARGS) -t $(DOCKER_IMAGE) -f $(DOCKER_FILE) .

.PHONY: test
test: image
	$(DOCKER) run -it --rm $(DOCKER_IMAGE) /bin/bash -c "$(CHECK_TRAIN_COMMAND) && $(CHECK_PREDICTION_COMMAND)"
	@echo "Pass training/prediction on excutable binary"
	$(DOCKER) run -it --rm $(DOCKER_IMAGE) /bin/bash -c "python thundersvm.py"
	@echo "Pass training/prediction on thundersvmScikit"
