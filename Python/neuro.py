#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 15 14:29:25 2021

@author: yahor
"""

import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.preprocessing.image import load_img, img_to_array
import matplotlib.pyplot as plt
mnist = keras.datasets.mnist
(train_data, train_label), (test_data, test_label) = mnist.load_data()
train_data, test_data = train_data / 255., test_data / 255.
model = keras.models.Sequential([
    keras.layers.Flatten(input_shape=(28, 28)),
    keras.layers.Dense(128, activation='relu'),
    keras.layers.Dropout(.2),
    keras.layers.Dense(10, activation="softmax")
])
model.compile(optimizer='adam',
              loss="sparse_categorical_crossentropy",
              metrics=['accuracy'])
model.fit(train_data, train_label, epochs=5)
def predict_image(model, filename):
    img = load_img(filename)
    img_array = img_to_array(img)
    img_array = tf.image.resize(img_array, (28, 28))
    img_array = np.resize(img_array, (28, 28))
    img = (np.expand_dims(img_array,0))
    return np.argmax(model.predict(img))
print(predict_image(model, '3.webp'))