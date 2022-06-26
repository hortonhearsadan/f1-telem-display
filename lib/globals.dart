library globals;

class PacketData {
  Map<String,dynamic> motionData = {};
  Map<String,dynamic> sessionData = {};
  Map<String,dynamic> lapData = {};
  Map<String,dynamic> eventData = {};
  Map<String,dynamic> participantsData = {};
  Map<String,dynamic> carSetupData = {};
  Map<String,dynamic> carTelemetryData = {};
  Map<String,dynamic> carStatusData = {};
  Map<String,dynamic> finalClassificationData = {};
  Map<String,dynamic> lobbyInfoData = {};

}

PacketData packetData = PacketData();