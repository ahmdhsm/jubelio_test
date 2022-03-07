###  Requirements
- Flutter version 2.8.1
- Dart version 2.8.1

### How to run this project
- Clone this git repository
- Open console/terminal/cmd and got this project directory
- run this command to download dependency `flutter pub get`
- If everything work as expected run this command to running test on Cart Function `flutter test test/cart_test.dart` if using Linux/Mac or `flutter test test\cart_test.dart` if using Windows.
- Rn this command to running Widget Test `flutter test test/widget_test.dart` if using Linux/Mac or `flutter test test\widget_test.dart` if using Windows
- If no error happen, run this command `flutter run`
- If no error show, app should be displayed on emulator/phone.

### Project explanation
- To handle screen ratio, this app only run in `Potrait Mode`.
- If running on offline mode and data ever loaded, this app will only display 20 of item and cannot load more item.
- If running on offline mode and data never be loaded, this app will not show any data.
- If connected to internet, this app will display data based on `Elevania` pagination on `Elevania API Documentation`. Access it using `page` parameter.
- Search only work for data which displayed in list and can't search other data which not displayed in list.

### Project Structure
|Directory|Description|
|--|--|
| lib/config | To handle config and constant function |
| lib/page | To display page in this app |
| lib/service | To handle service in this app |

