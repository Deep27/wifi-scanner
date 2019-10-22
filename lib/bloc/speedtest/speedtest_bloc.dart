import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wifi_scanner/bloc/speedtest/speedtest_event.dart';
import 'package:wifi_scanner/bloc/speedtest/speedtest_state.dart';

class SpeedtestBloc extends Bloc<SpeedtestEvent, SpeedtestState> {
  @override
  SpeedtestState get initialState => InitialSpeedtestState();

  @override
  Stream<SpeedtestState> mapEventToState(SpeedtestEvent event) async* {
    if (event is StartSpeedtest) {

    }
  }
}
