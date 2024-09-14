##################################
#
# Author : Sahith Aitha
# Creation Date : 8/31/2024
#
# Description : This is the python script that defines LSTM model and train the metrics to it.
##################################
import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
import matplotlib.pyplot as plt


def prepare_data(data, column_name='CPUUtilization', time_step=10):
    metric_data = data[[column_name]]
    scaler = MinMaxScaler(feature_range=(0, 1))
    normalized_data = scaler.fit_transform(metric_data)

    def create_sequences(data, time_step):
        X, Y = [], []
        for i in range(len(data) - time_step - 1):
            X.append(data[i:(i + time_step), 0])
            Y.append(data[i + time_step, 0])
        return np.array(X), np.array(Y)

    X, Y = create_sequences(normalized_data, time_step)

    X = X.reshape(X.shape[0], X.shape[1], 1)

    print("Shape of X:", X.shape)
    print("Shape of Y:", Y.shape)

    return X, Y, scaler


def build_lstm_model(time_step):
    #LSTM Model for analysis 
    model = Sequential()
    model.add(LSTM(50, return_sequences=True, input_shape=(time_step, 1)))
    model.add(LSTM(50, return_sequences=False))
    model.add(Dense(25))
    model.add(Dense(1))
    model.compile(optimizer='adam', loss='mean_squared_error')

    return model

def train_model(X, Y, time_step, epochs=20):
    # Split the data into training and testing sets
    train_size = int(len(X) * 0.8)
    test_size = len(X) - train_size
    X_train, X_test = X[0:train_size], X[train_size:len(X)]
    Y_train, Y_test = Y[0:train_size], Y[train_size:len(Y)]

    # Build the LSTM model
    model = build_lstm_model(time_step)

    # Train the model
    model.fit(X_train, Y_train, batch_size=1, epochs=epochs)

    print("Model training completed.")

    return model, X_train, X_test, Y_train, Y_test


def evaluate_and_predict(model, X_train, X_test, Y_train, Y_test, scaler, normalized_data, time_step):
    train_predict = model.predict(X_train)
    test_predict = model.predict(X_test)

    train_predict = scaler.inverse_transform(train_predict)
    test_predict = scaler.inverse_transform(test_predict)
    Y_train = scaler.inverse_transform([Y_train])
    Y_test = scaler.inverse_transform([Y_test])

    plt.figure(figsize=(12, 6))
    plt.plot(scaler.inverse_transform(normalized_data), label='Actual Data')
    plt.plot(range(time_step, train_size + time_step), train_predict, label='Training Predictions')
    plt.plot(range(train_size + time_step, len(normalized_data)), test_predict, label='Testing Predictions')
    plt.xlabel('Time Steps')
    plt.ylabel('EC2 Metrics')
    plt.legend()
    plt.show()

# Main method

if __name__ == "__main__":
    # File path to the CSV file
    file_path = 'ec2_metrics.csv'


    X, Y, scaler = prepare_data(data, column_name='CPUUtilization', time_step=10)

    model, X_train, X_test, Y_train, Y_test = train_model(X, Y, time_step=10, epochs=20)

    evaluate_and_predict(model, X_train, X_test, Y_train, Y_test, scaler, scaler.fit_transform(data[['CPUUtilization']]), time_step=10)

