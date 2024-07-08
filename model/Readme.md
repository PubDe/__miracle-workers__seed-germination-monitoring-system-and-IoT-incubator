
# TensorFlow Object Detection API Configuration

This document provides instructions for setting up and configuring the TensorFlow Object Detection API for detecting and counting Zea mays seeds.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Training the Model](#training-the-model)
- [Evaluating the Model](#evaluating-the-model)

## Prerequisites [with the versions we used]

- Python | 3.9.7
- TensorFlow | 2.10.1
- Protobuf | 3.19.6
- Protoc | 22.0
- CUDA (for GPU support) [we didn't used]

## Installation

### Clone the TensorFlow Models Repository to Tensorflow/model directory

```bash
git clone https://github.com/tensorflow/models.git

```

### Install the Object Detection API

We followed [this documentstion](https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/install.html) for installation.

## Training the Model

1. **Run the training script:**

```bash
python models/research/object_detection/model_main_tf2.py \
    --model_dir=path/to/model_dir \
    --pipeline_config_path=path/to/pipeline.config
```

## Evaluating the Model

1. **Run the evaluation script:**

```bash
python models/research/object_detection/model_main_tf2.py \
    --model_dir=path/to/model_dir \
    --pipeline_config_path=path/to/pipeline.config \
    --checkpoint_dir=path/to/checkpoint_dir
```


------------------PubDe-----------------
