//  the this is the function for getting the current location
import 'package:location/location.dart';

class LocationNow {
//  the values to be set
  late double? latitude;
  late double? longitude;

//  the various state
  static late bool _serviceEnable;
  late LocationData _Location_Values;
  late PermissionStatus _permission_status_now;

  Location location = Location();

  Future<void> Getcurrent_location() async {
    //   checking whether it is enable in the environment
    _serviceEnable = await location.serviceEnabled();
//  in here we check the status
    if (!_serviceEnable) {
      //   then we request it again
      _serviceEnable = await location.requestService();
      if (!_serviceEnable) {
        //   meaning the person has decided not to make use of it
        return;
      }
    }
    final LocationData value_staff = await location.getLocation();
    latitude = value_staff.latitude;
    longitude = value_staff.longitude;
    print(longitude);
    print(latitude);

//  move forward to get
  }
}
