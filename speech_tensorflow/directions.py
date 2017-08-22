#!/usr/bin/env python
#!/usr/bin/env PYTHONIOENCODING="utf-8" python
import tflearn
import pyaudio
import speech_data1 as speech_data
import numpy

speakers = ['move','left','right','stop']
batch=speech_data.wave_batch_generator(336,target=speech_data.Target.direction)
X,Y=next(batch)

number_classes=4 # Digits

# Classification
tflearn.init_graph(num_cores=8, gpu_memory_fraction=0.5)

net = tflearn.input_data(shape=[None, 50000])
net = tflearn.fully_connected(net, 64)
net = tflearn.dropout(net, 0.5)
net = tflearn.fully_connected(net, number_classes, activation='softmax')
net = tflearn.regression(net, optimizer='adam', loss='categorical_crossentropy')

model = tflearn.DNN(net)
model.fit(X, Y,n_epoch=50,show_metric=True,snapshot_step=100)
# Overfitting okay for now

demo_file = "test.wav"
#demo=speech_data.load_wav_file(speech_data.path + demo_file)
demo=speech_data.load_wav_file('/home/santosh/Documents/IEEE-Speech/tensorflow-speech-recognition/data/'+ demo_file)
result=model.predict([demo])
print(result)
result=numpy.argmax(result)
print("predicted digit for %s : result = %s "%(demo_file,speakers[result]))
