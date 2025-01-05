import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:corsair_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  _CamScreenState createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine;
  int? uid;
  int? outheruid;

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final microPermission = resp[Permission.microphone];
    final cameraPermission = resp[Permission.camera];

    if (!microPermission!.isGranted || !cameraPermission!.isGranted) {
      throw Future.error("마이크 또는 카메라 권한이 없습니다");
    }
    if (engine == null) {
      engine = createAgoraRtcEngine();
      await engine!.initialize(
        RtcEngineContext(
            appId: APP_ID,
            channelProfile: ChannelProfileType.channelProfileLiveBroadcasting),
      );

      engine?.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print("채널에 입장하셨습니다 ${connection.channelId}");
            setState(() {
              uid = connection.localUid;
            });
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            print("채널에 나갔습니다");
            setState(() {
              uid = null;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteuid, int elapse) {
            print("상대가 채널에 입장하였습니다 $remoteuid");
            setState(() {
              outheruid = remoteuid;
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            print("상대가 채널에서 나갔습니다 $remoteUid");
            setState(() {
              outheruid = null;
            });
          },
        ),
      );
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      await engine!.enableVideo();

      await engine!.startPreview();

      await engine!.joinChannel(
        token: TEMP_TOKEN,
        channelId: CHANNEL_NAME,
        uid: 0,
        options: ChannelMediaOptions(),
      );
    }
    return true;
  }

  Widget renderLocalView() {
    if (uid != null) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return Center(child: Text(" No video here"));
    }
  }

  Widget renderRemoteView() {
    if (outheruid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine!,
          canvas: VideoCanvas(uid: 0),
          connection: const RtcConnection(channelId: CHANNEL_NAME),
        ),
      );
    } else {
      return Center(child: Text("No remote Data here"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LIVE"),
      ),
      body: FutureBuilder(
          future: init(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await init();
                      setState(() {});
                    },
                    child: Text("권한 재요청하기"),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        renderLocalView(),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.grey,
                            width: 120,
                            height: 160,
                            child: renderRemoteView(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (engine != null) {
                          await engine!.leaveChannel();
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text("채널 나가기"),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
