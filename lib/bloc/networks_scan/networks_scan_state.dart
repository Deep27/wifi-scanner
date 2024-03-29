import 'package:equatable/equatable.dart';
import 'package:wifi_scanner/model/scan_result.dart';

abstract class NetworksScanState extends Equatable {
  const NetworksScanState();
}

class InitialNetworksScanState extends NetworksScanState {
  @override
  List<Object> get props => [];
}

class ScanningNetworks extends NetworksScanState {
  @override
  List<Object> get props => [];
}

class ScanSuccess extends NetworksScanState {
  final List<ScanResult> scanResults;
  final int newInterval;

  ScanSuccess(this.scanResults, this.newInterval);

  @override
  List<Object> get props => [scanResults, newInterval];
}

class ScanError extends NetworksScanState {
  final String errorMessage;

  ScanError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
} 
