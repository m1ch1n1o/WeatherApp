# Weather App 

This project is a Weather App that provides information about the weather forecast based on the user's location.

## Features

- Two tabs are available:
  1. Current weather details
  2. Forecast for the next 5 days

- Information is retrieved from a free API provided by [OpenWeatherMap](http://openweathermap.org/api)
  - [Current weather API](https://openweathermap.org/current)
  - [5-day forecast API](https://openweathermap.org/forecast5)
  - The API also provides weather icons which should be utilized.

- Quality attention is given to UI/UX design for a better user experience.
  - Loading indicators are implemented for data loading processes.
  - Error handling is implemented to gracefully handle unexpected errors.
  - Additional content is blurred during loading to provide a cleaner interface.

## Current Weather

### Details Displayed:
- Location
- Temperature, Weather condition
- Cloudiness percentage
- Humidity
- Wind speed
- Wind direction

### Additional Functionality:
- Refresh button is provided in the top left corner for manual data refresh.
- Share button is provided in the top right corner to share weather details using UIActivityViewController.

## 5-Day Forecast

### Details Displayed:
- Forecast for the next 5 days, divided into 3-hour intervals.

### Additional Functionality:
- Refresh button is provided in the top left corner for manual data refresh.

## Loading Indicator

- Loading indicators are displayed on both tabs while data is being fetched.
- Refresh button acts as a reset button for the loading indicator when tapped.

## Error Handling

- In case of any errors, appropriate error messages are displayed.
- Other content is blurred during the loading process to maintain focus on the error message.

## Determining User Location

- CLLocationManager is used to determine the user's location.
- User permission is requested for location access.
- Proper handling is implemented for various permission scenarios and errors.

## Conclusion

This Weather App provides users with accurate weather information based on their location. It ensures a seamless experience with efficient data loading, error handling, and a clean user interface.
