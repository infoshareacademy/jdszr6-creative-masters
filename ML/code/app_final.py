from importlib.metadata import distribution
import os
import pandas as pd
from tkinter import *
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from xgboost import XGBClassifier
from sklearn.model_selection import KFold, cross_val_score
from time import time
from sklearn.preprocessing import LabelEncoder
from sklearn import preprocessing
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.metrics import make_scorer, accuracy_score
from category_encoders import OrdinalEncoder
import random
# import pycountry

# print(pycountry.countries)

data_filename = 'hotel_bookings.csv'

data_path = os.path.join(os.path.abspath(
    'Desktop/jdszr6-creative-masters/ML/data'), data_filename)


# folder_path = os.path.abspath('../Python/Project_Python/Data')

data_df = pd.read_csv(data_path)

data_df = data_df.drop(columns=["reservation_status_date", "hotel", "reservation_status",
                                "arrival_date_week_number", "reserved_room_type", "company"]).replace(" ", "_")


nan_replacements = {"children": 0.0, "agent": 0,
                    "country": "unknown", "total_guests": 0, "price_per_guest": 0}

data_df = data_df.fillna(nan_replacements)


# features = data_df.drop(
#     columns=["is_canceled"], axis=1).columns

# X = data_df[features]
# y = data_df["is_canceled"]

# Iwona
# X = pd.get_dummies(X, drop_first=True)

# Julita
# my_label_encoder = LabelEncoder()

# for el in data_df:
#     if data_df[el].dtype == object:
#         print(el)
#         my_label_encoder.fit(data_df[el])
#         tmp = my_label_encoder.transform(data_df[el]).reshape((-1, 1))
#         data_df[el] = pd.DataFrame(tmp)


# arrival_date_month = my_label_encoder.fit(data_df['arrival_date_month'])
# tmp = my_label_encoder.transform(
#     data_df['arrival_date_month']).reshape((-1, 1))
# data_df['arrival_date_month'] = pd.DataFrame(tmp)

# meal = my_label_encoder.fit(data_df['meal'])
# tmp = my_label_encoder.transform(
#     data_df['meal']).reshape((-1, 1))
# data_df['meal'] = pd.DataFrame(tmp)

# country = my_label_encoder.fit(data_df['country'])
# tmp = my_label_encoder.transform(
#     data_df['country']).reshape((-1, 1))
# data_df['country'] = pd.DataFrame(tmp)

# market_segment = my_label_encoder.fit(data_df['market_segment'])
# tmp = my_label_encoder.transform(
#     data_df['market_segment']).reshape((-1, 1))
# data_df['market_segment'] = pd.DataFrame(tmp)

# distribution_channel = my_label_encoder.fit(data_df['distribution_channel'])
# tmp = my_label_encoder.transform(
#     data_df['distribution_channel']).reshape((-1, 1))
# data_df['distribution_channel'] = pd.DataFrame(tmp)

# assigned_room_type = my_label_encoder.fit(data_df['assigned_room_type'])
# tmp = my_label_encoder.transform(
#     data_df['assigned_room_type']).reshape((-1, 1))
# data_df['assigned_room_type'] = pd.DataFrame(tmp)

# deposit_type = my_label_encoder.fit(data_df['deposit_type'])
# tmp = my_label_encoder.transform(
#     data_df['deposit_type']).reshape((-1, 1))
# data_df['deposit_type'] = pd.DataFrame(tmp)

# customer_type = my_label_encoder.fit(data_df['customer_type'])
# tmp = my_label_encoder.transform(
#     data_df['customer_type']).reshape((-1, 1))
# data_df['customer_type'] = pd.DataFrame(tmp)

# nowe
# for el in data_df:
#     my_label_encoder.fit(data_df[el])
#     tmp = my_label_encoder.transform(data_df[el]).reshape((-1, 1))
#     data_df[el] = pd.DataFrame(tmp)

# arrival_date_month
# meal
# country
# market_segment
# distribution_channel
# assigned_room_type
# deposit_type
# customer_type
# target = data_df.pop('is_canceled')
# le_is_canceled
# target = le_target.fit_transform(list(target))
# X = le_target.fit_transform(list(target))


y = data_df.pop('is_canceled')
# print(y)
# print(y.unique())


# le_lead_time = preprocessing.LabelEncoder()
# le_arrival_date_year = preprocessing.LabelEncoder()
# le_arrival_date_month = preprocessing.LabelEncoder()
# le_arrival_date_day_of_month = preprocessing.LabelEncoder()
# le_stays_in_weekend_nights = preprocessing.LabelEncoder()
# le_stays_in_week_nights = preprocessing.LabelEncoder()
# le_adults = preprocessing.LabelEncoder()
# le_children = preprocessing.LabelEncoder()
# le_babies = preprocessing.LabelEncoder()
# le_meal = preprocessing.LabelEncoder()
# le_country = preprocessing.LabelEncoder()
# le_market_segment = preprocessing.LabelEncoder()
# le_distribution_channel = preprocessing.LabelEncoder()
# le_is_repeated_guest = preprocessing.LabelEncoder()
# le_previous_cancellations = preprocessing.LabelEncoder()
# le_previous_bookings_not_canceled = preprocessing.LabelEncoder()
# le_assigned_room_type = preprocessing.LabelEncoder()
# le_booking_changes = preprocessing.LabelEncoder()
# le_deposit_type = preprocessing.LabelEncoder()
# le_agent = preprocessing.LabelEncoder()
# le_days_in_waiting_list = preprocessing.LabelEncoder()
# le_customer_type = preprocessing.LabelEncoder()
# le_adr = preprocessing.LabelEncoder()
# le_required_car_parking_spaces = preprocessing.LabelEncoder()
# le_total_of_special_requests = preprocessing.LabelEncoder()
# le_y = preprocessing.LabelEncoder()

le_lead_time = OrdinalEncoder()
le_arrival_date_year = OrdinalEncoder()
le_arrival_date_month = OrdinalEncoder()
le_arrival_date_day_of_month = OrdinalEncoder()
le_stays_in_weekend_nights = OrdinalEncoder()
le_stays_in_week_nights = OrdinalEncoder()
le_adults = OrdinalEncoder()
le_children = OrdinalEncoder()
le_babies = OrdinalEncoder()
le_meal = OrdinalEncoder()
le_country = OrdinalEncoder()
le_market_segment = OrdinalEncoder()
le_distribution_channel = OrdinalEncoder()
le_is_repeated_guest = OrdinalEncoder()
le_previous_cancellations = OrdinalEncoder()
le_previous_bookings_not_canceled = OrdinalEncoder()
le_assigned_room_type = OrdinalEncoder()
le_booking_changes = OrdinalEncoder()
le_deposit_type = OrdinalEncoder()
le_agent = OrdinalEncoder()
le_days_in_waiting_list = OrdinalEncoder()
le_customer_type = OrdinalEncoder()
le_adr = OrdinalEncoder()
le_required_car_parking_spaces = OrdinalEncoder()
le_total_of_special_requests = OrdinalEncoder()
le_y = OrdinalEncoder()

y = le_y.fit_transform(list(y))
# print(y)

data_df['lead_time'] = le_lead_time.fit_transform(
    list(data_df['lead_time']))
data_df['arrival_date_year'] = le_arrival_date_year.fit_transform(
    list(data_df['arrival_date_year']))
data_df['arrival_date_month'] = le_arrival_date_month.fit_transform(
    list(data_df['arrival_date_month']))
data_df['arrival_date_day_of_month'] = le_arrival_date_day_of_month.fit_transform(
    list(data_df['arrival_date_day_of_month']))
data_df['stays_in_weekend_nights'] = le_stays_in_weekend_nights.fit_transform(
    list(data_df['stays_in_weekend_nights']))
data_df['stays_in_week_nights'] = le_stays_in_week_nights.fit_transform(
    list(data_df['stays_in_week_nights']))
data_df['adults'] = le_adults.fit_transform(
    list(data_df['adults']))
data_df['children'] = le_children.fit_transform(
    list(data_df['children']))
data_df['babies'] = le_babies.fit_transform(
    list(data_df['babies']))
data_df['meal'] = le_meal.fit_transform(list(data_df['meal']))
data_df['country'] = le_country.fit_transform(
    list(data_df['country']))
data_df['market_segment'] = le_market_segment.fit_transform(
    list(data_df['market_segment']))
data_df['distribution_channel'] = le_distribution_channel.fit_transform(
    list(data_df['distribution_channel']))
data_df['is_repeated_guest'] = le_is_repeated_guest.fit_transform(
    list(data_df['is_repeated_guest']))
data_df['previous_cancellations'] = le_previous_cancellations.fit_transform(
    list(data_df['previous_cancellations']))
data_df['previous_bookings_not_canceled'] = le_previous_bookings_not_canceled.fit_transform(
    list(data_df['previous_bookings_not_canceled']))
data_df['assigned_room_type'] = le_assigned_room_type.fit_transform(
    list(data_df['assigned_room_type']))
data_df['booking_changes'] = le_booking_changes.fit_transform(
    list(data_df['booking_changes']))
data_df['deposit_type'] = le_deposit_type.fit_transform(
    list(data_df['deposit_type']))
data_df['agent'] = le_agent.fit_transform(
    list(data_df['agent']))
data_df['days_in_waiting_list'] = le_days_in_waiting_list.fit_transform(
    list(data_df['days_in_waiting_list']))
data_df['customer_type'] = le_customer_type.fit_transform(
    list(data_df['customer_type']))
data_df['adr'] = le_adr.fit_transform(list(data_df['adr']))
data_df['required_car_parking_spaces'] = le_required_car_parking_spaces.fit_transform(
    list(data_df['required_car_parking_spaces']))
data_df['total_of_special_requests'] = le_total_of_special_requests.fit_transform(
    list(data_df['total_of_special_requests']))

# print(data_df)

# print(data_df['arrival_date_month'].unique())

# data_df['lead_time'] = le_lead_time.fit_transform(list(data_df['lead_time']))

# lead_time
# arrival_date_year
# arrival_date_month
# arrival_date_day_of_month
# stays_in_weekend_nights
# stays_in_week_nights
# adults
# children
# babies
# meal
# country
# market_segment
# distribution_channel
# is_repeated_guest
# previous_cancellations
# previous_bookings_not_canceled
# assigned_room_type
# booking_changes
# deposit_type
# agent
# days_in_waiting_list
# customer_type
# adr
# required_car_parking_spaces
# total_of_special_requests


# le_origin = preprocessing.LabelEncoder()
# le_consignor = preprocessing.LabelEncoder()
# le_consignee = preprocessing.LabelEncoder()
# le_carrier = preprocessing.LabelEncoder()
# le_target = preprocessing.LabelEncoder()
# target = le_target.fit_transform(list(target))
# dataset['Origin'] = le_origin.fit_transform(list(dataset['Origin']))
# dataset['Consignor Code'] = le_consignor.fit_transform(list(dataset['Consignor Code']))
# dataset['Consignee Code'] = le_consignee.fit_transform(list(dataset['Consignee Code']))
# dataset['Carrier Code'] = le_carrier.fit_transform(list(dataset['Carrier Code']))

# print(data_df)

data_df.replace([np.inf, -np.inf], np.nan, inplace=True)
data_df.dropna(inplace=True)
data_df.drop(14969)
# X = data_df[features]
# print(X)
# print(X)

# print(data_df)

X_train, X_test, y_train, y_test = train_test_split(
    data_df, y, test_size=0.3, random_state=42)

model = RandomForestClassifier(random_state=42)
model.fit(X_train, y_train.values.ravel())

# Make a prediction on the test set.
predictions = model.predict(X_test)
predictions_proba = model.predict_proba(X_test)


# Print the accuracy score.
# print("Accuracy score: {}".format(accuracy_score(y_test, predictions)))
# print("predictions proba: {}".format(predictions_proba))

# print(data_df)
# print(y)


# output is_canceled = 0
# new_input = ['85', 2015, 'July',
#              '1', '0',
#              '2', '1', 0, 0, 'BB',
#              'PRT', 'Direct', 'Direct',
#              1, 0,
#              '2', 'C',
#              'No Deposit', 304, 6, 'Transient',
#              122, 1, 1,
#              2]

# output is_cancelled = 1
# new_input = ['85', 2015, 'July',
#              '1', '0',
#              '2', '2', 0, 0, 'BB',
#              'PRT', 'Online TA', 'TA/TO',
#              0, 0,
#              '0', 'A',
#              'No Deposit', 240, 0, 'Transient',
#              82, 0, 0,
#              1]

# output for test with missing data

# new_input = ['85', '2099', 'July',
#              '1', '0',
#              '2', '2', 1, 0, 'BB',
#              'PRT', 'Online', 'TA/TO',
#              0, 13,
#              '0', 'A',
#              'No sad fd Deposit bo nie ', 240, 0, 'Transient',
#              82, 0, 0,
#              1]

new_input = ['85', '2099', 'July',
             '1', '0',
             '2', '2', 1, 0, 'BB',
             'PRT', 'Online', 'TA/TO',
             0, 13,
             '0', 'A',
             'No sad fd Deposit bo nie ', 240, 0, 'Transient',
             82, 0, 0,
             1]


# arival_date_month
# meal
# country
# market_segment
# distribution_channel
# assigned_room_type
# deposit_type
# customer_type
# new_input = ['1']

# 85, 2015, July, 1, 0, 2, 2, 0, 0, BB, PRT, Online Ta, TA/TO, 0, 0, 0, A, No Deposit, 240, 0, Transient, 82, 0, 0, 1

# dobre 21:41 sobota
# fitted_new_input = np.array([le_lead_time.transform([new_input[0]])[0],
#                              le_arrival_date_year.transform([new_input[1]])[0],
#                              le_arrival_date_month.transform(
#                                  [new_input[2]])[0],
#                              le_arrival_date_day_of_month.transform([new_input[3]])[
#     0],
#     le_stays_in_weekend_nights.transform([new_input[4]])[
#     0],
#     le_stays_in_week_nights.transform(
#                                  [new_input[5]])[0],
#     le_adults.transform([new_input[6]])[0],
#     le_children.transform([new_input[7]])[0],
#     le_babies.transform([new_input[8]])[0],
#     le_meal.transform([new_input[9]])[0],
#     le_country.transform([new_input[10]])[0],
#     le_market_segment.transform([new_input[11]])[0],
#     le_distribution_channel.transform(
#                                  [new_input[12]])[0],
#     le_is_repeated_guest.transform(
#                                  [new_input[13]])[0],
#     le_previous_cancellations.transform(
#                                  [new_input[14]])[0],
#     le_previous_bookings_not_canceled.transform([new_input[15]])[
#     0],
#     le_assigned_room_type.transform(
#                                  [new_input[16]])[0],
#     le_deposit_type.transform([new_input[17]])[0],
#     le_agent.transform([new_input[18]])[0],
#     le_days_in_waiting_list.transform(
#                                  [new_input[19]])[0],
#     le_customer_type.transform([new_input[20]])[0],
#     le_adr.transform([new_input[21]])[0],
#     le_required_car_parking_spaces.transform([new_input[22]])[
#     0],
#     le_booking_changes.transform(
#                                  [new_input[23]])[0],
#     le_total_of_special_requests.transform([new_input[24]])[0]])


# new_predictions = model.predict(fitted_new_input.reshape(1, -1))
# new_predictions_proba = model.predict_proba(fitted_new_input.reshape(1, -1))
# end dobre 21:41

# print(data_df['meal'].unique())
# print(le_meal)
# print(le_deposit_type)
# print(new_predictions)
# print(new_predictions_proba)
# print(new_predictions_proba[0])
# print(y.inverse_transform(new_predictions))

# model.fit(X, y)

# new_input = ['lead_time', 'arrival_date_year', 'arrival_date_month',
#        'arrival_date_day_of_month', 'stays_in_weekend_nights',
#        'stays_in_week_nights', 'adults', 'children', 'babies', 'meal',
#        'country', 'market_segment', 'distribution_channel',
#        'is_repeated_guest', 'previous_cancellations',
#        'previous_bookings_not_canceled', 'assigned_room_type',
#        'booking_changes', 'deposit_type', 'agent', 'days_in_waiting_list',
#        'customer_type', 'adr', 'required_car_parking_spaces',
#        'total_of_special_requests']


# new_input = ["6408507648","6403601344","DKCPH","66565231"]
# fitted_new_input = np.array([le_consignor.transform([new_input[0]])[0],
#                                 le_consignee.transform([new_input[1]])[0],
#                                 le_origin.transform([new_input[2]])[0],
#                                 le_carrier.transform([new_input[3]])[0]])
# new_predictions = model.predict(fitted_new_input.reshape(1,-1))


# new_output_predict = model.predict(new_input)

# new_output_predict_proba = model.predict_proba(new_input)

# print(f"new_input: {new_input}, new_output_predict: {new_output_predict}, new_output_predict_proba: {new_output_predict_proba}")

# split = KFold(n_splits=4, shuffle=True, random_state=42)
# cv_results = cross_val_score(model, X, y, cv=split, scoring="accuracy")
# mean_score = round(np.mean(cv_results), 4)
# print(mean_score)

# new_input = [[2.12309797, -1.41131072]]

# models = [("RandomForest_Model", RandomForestClassifier(random_state=42)),
#           ("XGBBoost_Model", XGBClassifier(random_state=42, use_label_encoder=False, eval_metric="mlogloss", n_jobs=-1))]

# split = KFold(n_splits=4, shuffle=True, random_state=42)

# accuracy = []
# model_name = []

# for name, model in models:
#     start = time()
#     cv_results = cross_val_score(model, X, y, cv=split, scoring="accuracy")
#     mean_score = round(np.mean(cv_results), 4)
#     end = time()
#     cross_val_time = round(end-start, 4)
#     accuracy.append(mean_score)
#     model_name.append(name)
#     print(f"{name} accuracy score: {mean_score} cross_val_time: {cross_val_time}")


root = Tk()
root.title('Booking App')
root.geometry("400x400")
root.grid_columnconfigure((0, 1), weight=1)

# stare ML
# def get_args():
#     global number_of_special_requests_input, lead_time_input, parking_spaces_input, booking_changes_input
#     number_of_special_requests_input = special_requests.get()
#     lead_time_input = lead_time.get()
#     parking_spaces_input = number_of_carplaces.get()
#     booking_changes_input = booking_changes.get()
# check_fields()
# special_requests_calculation()
# lead_time_calculation()
# parking_spaces_calculation()
# booking_changes_calculation()
# calculate_risk(lead_time_percentage, special_request_percentage,
#                parking_spaces_percentage, booking_changes_percentage)
# print_per()
# end stare ML

# nowe DL


def get_args():
    global lead_time_input, arrival_date_year_input, arrival_date_month_input, arrival_date_day_of_month_input, stays_in_weekend_nights_input, stays_in_week_nights_input, adults_input, childrens_input, babies_input, meal_input, country_input, market_segment_input, distribution_channel_input, is_repeated_guest_input, previous_cancellations_input, previous_bookings_not_canceled_input, assigned_room_type_input, booking_changes_input, deposit_type_input, agent_input, days_in_waiting_list_input, customer_type_input, adr_input, required_car_parking_spaces_input, total_special_requests_input

    arrival_date_year_input = arrival_date_year.get()
    arrival_date_month_input = arrival_date_month.get()
    arrival_date_day_of_month_input = arrival_date_day_of_month.get()
    stays_in_week_nights_input = stays_in_week_nights.get()
    stays_in_weekend_nights_input = stays_in_weekend_nights.get()
    adults_input = adults.get()
    childrens_input = childrens.get()
    babies_input = babies.get()
    meal_input = meal.get()
    required_car_parking_spaces_input = required_car_parking_spaces.get()
    country_input = country.get()
    assigned_room_type_input = assigned_room_type.get()
    deposit_type_input = deposit_type.get()
    is_repeated_guest_input = is_repeated_guest.get()
    previous_bookings_not_canceled_input = previous_bookings_not_canceled.get()
    previous_cancellations_input = previous_cancellations.get()
    booking_changes_input = booking_changes.get()
    customer_type_input = customer_type.get()
    market_segment_input = market_segment.get()
    distribution_channel_input = distribution_channel.get()
    agent_input = agent.get()
    total_special_requests_input = total_special_requests.get()
    days_in_waiting_list_input = days_in_waiting_list.get()
    adr_input = adr.get()
    lead_time_input = lead_time.get()

    print(new_input)
    new_input[0] = lead_time_input
    new_input[1] = arrival_date_year_input
    new_input[2] = arrival_date_month_input
    new_input[3] = arrival_date_day_of_month_input
    new_input[4] = stays_in_weekend_nights_input
    new_input[5] = stays_in_week_nights_input
    new_input[6] = adults_input
    new_input[7] = int(childrens_input)
    new_input[8] = int(babies_input)
    new_input[9] = meal_input
    new_input[10] = country_input
    new_input[11] = market_segment_input
    new_input[12] = distribution_channel_input
    new_input[13] = int(is_repeated_guest_input)
    new_input[14] = int(previous_cancellations_input)
    new_input[15] = previous_bookings_not_canceled_input
    new_input[16] = assigned_room_type_input
    new_input[17] = deposit_type_input
    new_input[18] = int(agent_input)
    new_input[19] = int(days_in_waiting_list_input)
    new_input[20] = customer_type_input
    new_input[21] = int(adr_input)
    new_input[22] = int(required_car_parking_spaces_input)
    new_input[23] = int(booking_changes_input)
    new_input[24] = int(total_special_requests_input)

    # print(arrival_date_year_input)
    # print(new_input)
    calculate_risk(new_input)


def calculate_risk(input_array):
    global fitted_new_input, new_predictions, new_predictions_proba, advice_label, risk_label

    fitted_new_input = np.array([le_lead_time.transform([new_input[0]])[0],
                                 le_arrival_date_year.transform(
                                     [new_input[1]])[0],
                                 le_arrival_date_month.transform(
                                 [new_input[2]])[0],
                                 le_arrival_date_day_of_month.transform([new_input[3]])[
        0],
        le_stays_in_weekend_nights.transform([new_input[4]])[
        0],
        le_stays_in_week_nights.transform(
        [new_input[5]])[0],
        le_adults.transform([new_input[6]])[0],
        le_children.transform([new_input[7]])[0],
        le_babies.transform([new_input[8]])[0],
        le_meal.transform([new_input[9]])[0],
        le_country.transform([new_input[10]])[0],
        le_market_segment.transform([new_input[11]])[0],
        le_distribution_channel.transform(
        [new_input[12]])[0],
        le_is_repeated_guest.transform(
        [new_input[13]])[0],
        le_previous_cancellations.transform(
        [new_input[14]])[0],
        le_previous_bookings_not_canceled.transform([new_input[15]])[
        0],
        le_assigned_room_type.transform(
        [new_input[16]])[0],
        le_deposit_type.transform([new_input[17]])[0],
        le_agent.transform([new_input[18]])[0],
        le_days_in_waiting_list.transform(
        [new_input[19]])[0],
        le_customer_type.transform([new_input[20]])[0],
        le_adr.transform([new_input[21]])[0],
        le_required_car_parking_spaces.transform([new_input[22]])[
        0],
        le_booking_changes.transform(
        [new_input[23]])[0],
        le_total_of_special_requests.transform([new_input[24]])[0]])

    new_predictions = model.predict(fitted_new_input.reshape(1, -1))
    new_predictions_proba = model.predict_proba(
        fitted_new_input.reshape(1, -1))
    # print(new_predictions)
    # print(new_predictions_proba)

    predictions_percentage = round(new_predictions_proba[0][1] * 100)

    if predictions_percentage >= 50:
        advice_msg = 'Please call customer to confirm arrival at least 2 weeks before booked date.'
        risk_message_color = 'red'
    elif predictions_percentage >= 30:
        advice_msg = 'Advice msg2'
        risk_message_color = 'orange'
    else:
        advice_msg = 'You can mark this reservation as confirmed'
        risk_message_color = 'green'

    advice_label = Label(root, text=advice_msg,
                         foreground=risk_message_color, font=('Times', 24))
    advice_label.grid(row=30, column=1)

    risk_msg = f'There is {predictions_percentage}% probabilty this reservation will be canceled'
    risk_label = Label(root, text=risk_msg, foreground=risk_message_color)
    risk_label.grid(row=29, column=1)


def clear_widget(widget):
    widget['text'] = ""


def clear_input_fields():
    arrival_date_year.delete(0, 'end')
    arrival_date_month.delete(0, 'end')
    arrival_date_day_of_month.delete(0, 'end')
    stays_in_week_nights.delete(0, 'end')
    stays_in_weekend_nights.delete(0, 'end')
    adults.delete(0, 'end')
    childrens.delete(0, 'end')
    babies.delete(0, 'end')
    meal.delete(0, 'end')
    required_car_parking_spaces.delete(0, 'end')
    country.delete(0, 'end')
    assigned_room_type.delete(0, 'end')
    deposit_type.delete(0, 'end')
    is_repeated_guest.delete(0, 'end')
    previous_bookings_not_canceled.delete(0, 'end')
    previous_cancellations.delete(0, 'end')
    booking_changes.delete(0, 'end')
    customer_type.delete(0, 'end')
    market_segment.delete(0, 'end')
    distribution_channel.delete(0, 'end')
    agent.delete(0, 'end')
    total_special_requests.delete(0, 'end')
    days_in_waiting_list.delete(0, 'end')
    adr.delete(0, 'end')
    lead_time.delete(0, 'end')
    clear_widget(advice_label)
    clear_widget(risk_label)


def randomize_data():
    arrival_date_year_choices = [2017, 2018, 2019]
    arrival_date_month_choices = ['January', 'February', 'March', 'April', 'May',
                                  'June', 'July', 'August', 'September', 'October', 'November', 'December']
    meal_choices = ['BB', 'FB', 'HB', 'SC', 'Undefined']
    country_choices = ['GBR', 'PRT']
    market_segment_choices = ['Aviation', 'Complementary',
                              'Corporate', 'Direct', 'Groups', 'Offlina TA/TO', 'Online TA']
    distribution_channel_choices = ['Corporate', 'Direct', 'GDS', 'TA/TO']
    assigned_room_type_choices = ['A', 'B', 'C', 'D',
                                  'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'P']
    deposit_type_choices = ['No Deposit', 'Non Refund', 'Refundable']
    customer_type_choices = ['Transient',
                             'Group', 'Contract', 'Transient-Party']

    lead_time.insert(0, str(random.randint(0, 800)))
    arrival_date_year.insert(0, str(random.choice(arrival_date_year_choices)))
    arrival_date_month.insert(0, random.choice(arrival_date_month_choices))
    arrival_date_day_of_month.insert(0, str(random.randint(1, 31)))
    stays_in_weekend_nights.insert(0, str(random.randint(0, 8)))
    stays_in_week_nights.insert(0, str(random.randint(0, 11)))
    adults.insert(0, str(random.randint(0, 5)))
    childrens.insert(0, random.randint(0, 3))
    babies.insert(0, random.randint(0, 3))
    meal.insert(0, str(random.choice(meal_choices)))
    country.insert(0, random.choice(country_choices))
    market_segment.insert(0, random.choice(market_segment_choices))
    distribution_channel.insert(0, random.choice(distribution_channel_choices))
    is_repeated_guest.insert(0, random.randint(0, 1))
    previous_cancellations.insert(0, random.randint(0, 4))
    previous_bookings_not_canceled.insert(0, str(random.randint(0, 25)))
    assigned_room_type.insert(0, random.choice(assigned_room_type_choices))
    deposit_type.insert(0, random.choice(deposit_type_choices))
    agent.insert(0, random.randint(1, 1000))
    days_in_waiting_list.insert(0, random.randint(0, 500))
    customer_type.insert(0, random.choice(customer_type_choices))
    adr.insert(0, random.randint(1, 100))
    required_car_parking_spaces.insert(0, random.randint(0, 5))
    total_special_requests.insert(0, random.randint(0, 5))
    booking_changes.insert(0, random.randint(0, 5))
    # number_of_special_requests_input = special_requests.get()
    # lead_time_input = lead_time.get()
    # parking_spaces_input = required_car_parking_spaces.get()
    # booking_changes_input = booking_changes.get()
# end nowe DL


# nowa funkcja ML

# disp_tf = Entry(
#     root,
#     width=38,
#     font=('Arial', 14)
# )

# disp_tf.pack(pady=5)


# nowe DL
arrival_date_year_label = Label(root, text='Arrival Year:')
arrival_date_year = Entry(root)

arrival_date_month_label = Label(root, text='Arrival Month:')
arrival_date_month = Entry(root)

arrival_date_day_of_month_label = Label(root, text='Arrival Day of Month:')
arrival_date_day_of_month = Entry(root)

stays_in_week_nights_label = Label(root, text='Week Nights:')
stays_in_week_nights = Entry(root)

stays_in_weekend_nights_label = Label(root, text='Weekend Nights:')
stays_in_weekend_nights = Entry(root)

adults_label = Label(root, text='Adults:')
adults = Entry(root)

childrens_label = Label(root, text='Childrens:')
childrens = Entry(root)

babies_label = Label(root, text='Babies:')
babies = Entry(root)

meal_label = Label(root, text='Meal:')
meal = Entry(root)

required_car_parking_spaces_label = Label(root, text='Parking spaces:')
required_car_parking_spaces = Entry(root)

country_label = Label(root, text='Country:')
country = Entry(root)

assigned_room_type_label = Label(root, text='Room type:')
assigned_room_type = Entry(root)

deposit_type_label = Label(root, text='Deposit type:')
deposit_type = Entry(root)

is_repeated_guest_label = Label(root, text='Is repeated guest:')
is_repeated_guest = Entry(root)

previous_bookings_not_canceled_label = Label(
    root, text='Previous bookings not cancelled:')
previous_bookings_not_canceled = Entry(root)

previous_cancellations_label = Label(
    root, text='Previous cancelations:')
previous_cancellations = Entry(root)

booking_changes_label = Label(root, text='Number of booking changes:')
booking_changes = Entry(root)

customer_type_label = Label(root, text='Customer type:')
customer_type = Entry(root)

market_segment_label = Label(root, text='Market segment:')
market_segment = Entry(root)

distribution_channel_label = Label(root, text='Distribution channel:')
distribution_channel = Entry(root)

agent_label = Label(root, text='Distribution channel:')
agent = Entry(root)

total_special_requests_label = Label(root, text='Number of special requests:')
total_special_requests = Entry(root)

days_in_waiting_list_label = Label(root, text='Days in waiting list:')
days_in_waiting_list = Entry(root)

adr_label = Label(root, text='ADR:')
adr = Entry(root)

lead_time_label = Label(root, text='Lead time:')
lead_time = Entry(root)


submit_button = Button(root, text="Check risk",
                       command=get_args)

randomize_button = Button(root, text="Randomize", command=randomize_data)

clear_button = Button(root, text="Clear", command=clear_input_fields)

###########


# , , ,, ,, , , , number_of_special_requests_input, lead_time_input, parking_spaces_input, booking_changes_input


# lead_time_label = Label(root, text='Lead time:')
# lead_time = Entry(root)


# number_of_carplaces_label = Label(root, text='Required parking spaces:')
# number_of_carplaces = Entry(root)


# special_requests_label = Label(root, text='Number of special requests:')
# special_requests = Entry(root)

# booking_changes_label = Label(root, text='Number of booking changes:')
# booking_changes = Entry(root)
# end nowe DL

# stare ML
# number_of_carplaces_label = Label(root, text='Required parking spaces:')
# number_of_carplaces = Entry(root)

# lead_time_label = Label(root, text='Lead time:')
# lead_time = Entry(root)

# special_requests_label = Label(root, text='Number of special requests:')
# special_requests = Entry(root)

# booking_changes_label = Label(root, text='Number of booking changes:')
# booking_changes = Entry(root)
# end of stare ML


# submitButton = Button(root, text="Check rating",
#                       command=lambda: [check_cancelation_rate(), special_requests_calculation()])


# grid position
arrival_date_year_label.grid(row=1, column=0)
arrival_date_year.grid(row=1, column=1)

arrival_date_month_label.grid(row=2, column=0)
arrival_date_month.grid(row=2, column=1)

arrival_date_day_of_month_label.grid(row=3, column=0)
arrival_date_day_of_month.grid(row=3, column=1)

stays_in_week_nights_label.grid(row=4, column=0)
stays_in_week_nights.grid(row=4, column=1)

stays_in_weekend_nights_label.grid(row=5, column=0)
stays_in_weekend_nights.grid(row=5, column=1)

adults_label.grid(row=6, column=0)
adults.grid(row=6, column=1)

childrens_label.grid(row=7, column=0)
childrens.grid(row=7, column=1)

babies_label.grid(row=8, column=0)
babies.grid(row=8, column=1)

meal_label.grid(row=9, column=0)
meal.grid(row=9, column=1)

required_car_parking_spaces_label.grid(row=10, column=0)
required_car_parking_spaces.grid(row=10, column=1)

country_label.grid(row=11, column=0)
country.grid(row=11, column=1)

assigned_room_type_label.grid(row=12, column=0)
assigned_room_type.grid(row=12, column=1)

deposit_type_label.grid(row=13, column=0)
deposit_type.grid(row=13, column=1)

is_repeated_guest_label.grid(row=14, column=0)
is_repeated_guest.grid(row=14, column=1)

previous_bookings_not_canceled_label.grid(row=15, column=0)
previous_bookings_not_canceled.grid(row=15, column=1)

previous_cancellations_label.grid(row=16, column=0)
previous_cancellations.grid(row=16, column=1)

booking_changes_label.grid(row=17, column=0)
booking_changes.grid(row=17, column=1)

customer_type_label.grid(row=18, column=0)
customer_type.grid(row=18, column=1)

market_segment_label.grid(row=19, column=0)
market_segment.grid(row=19, column=1)

distribution_channel_label.grid(row=20, column=0)
distribution_channel.grid(row=20, column=1)

agent_label.grid(row=21, column=0)
agent.grid(row=21, column=1)

total_special_requests_label.grid(row=22, column=0)
total_special_requests.grid(row=22, column=1)

days_in_waiting_list_label.grid(row=23, column=0)
days_in_waiting_list.grid(row=23, column=1)

adr_label.grid(row=24, column=0)
adr.grid(row=24, column=1)

lead_time_label.grid(row=25, column=0)
lead_time.grid(row=25, column=1)


# number_of_carplaces_label.grid(row=5, column=0)
# number_of_carplaces.grid(row=5, column=1)

# booking_changes_label.grid(row=6, column=0)
# booking_changes.grid(row=6, column=1)

randomize_button.grid(row=26, column=1)
clear_button.grid(row=27, column=1)
submit_button.grid(row=28, column=1)

root.mainloop()
