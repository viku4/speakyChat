// import '/flutter_flow/flutter_flow_audio_player.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/flutter_flow/permissions_util.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:record/record.dart';
// import 'audiorec_b_s_model.dart';
// export 'audiorec_b_s_model.dart';
//
// class AudiorecBSWidget extends StatefulWidget {
//   const AudiorecBSWidget({
//     Key? key,
//     this.dirctRecording,
//   }) : super(key: key);
//
//   final bool? dirctRecording;
//
//   @override
//   _AudiorecBSWidgetState createState() => _AudiorecBSWidgetState();
// }
//
// class _AudiorecBSWidgetState extends State<AudiorecBSWidget> {
//   late AudiorecBSModel _model;
//
//   @override
//   void setState(VoidCallback callback) {
//     super.setState(callback);
//     _model.onUpdate();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => AudiorecBSModel());
//
//     // On component load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       if (widget.dirctRecording!) {
//         setState(() {
//           _model.isRecording = true;
//           _model.isShowPlayer = false;
//         });
//       } else {
//         return;
//       }
//
//       _model.audioRecorder1 ??= Record();
//       if (await _model.audioRecorder1!.hasPermission()) {
//         await _model.audioRecorder1!.start();
//       } else {
//         showSnackbar(
//           context,
//           'You have not provided permission to record audio.',
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _model.maybeDispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     context.watch<FFAppState>();
//
//     return Container(
//       decoration: BoxDecoration(
//         color: FlutterFlowTheme.of(context).primaryBackground,
//       ),
//       child: Padding(
//         padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_model.isRecording)
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding:
//                           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
//                       child: Container(
//                         width: 20.0,
//                         height: 20.0,
//                         decoration: BoxDecoration(
//                           color: FlutterFlowTheme.of(context).error,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: AlignmentDirectional(0.0, 0.0),
//                       child: Text(
//                         'REC',
//                         style: FlutterFlowTheme.of(context).bodyMedium.override(
//                               fontFamily: ' Comic Sans MS',
//                               color: FlutterFlowTheme.of(context).primary,
//                               fontWeight: FontWeight.bold,
//                               useGoogleFonts: false,
//                             ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             Stack(
//               children: [
//                 if (_model.isRecording)
//                   Lottie.asset(
//                     'assets/lottie_animations/Audio_Wave.json',
//                     width: 400.0,
//                     height: 108.0,
//                     fit: BoxFit.fill,
//                     animate: true,
//                   ),
//                 // if (_model.isShowPlayer)
//                   // Padding(
//                   //   padding:
//                   //       EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
//                   //   child: FlutterFlowAudioPlayer(
//                   //     audio: Audio.network(
//                   //       widget.dirctRecording!
//                   //           ? _model.recordingDirect!
//                   //           : _model.recording!,
//                   //       metas: Metas(
//                   //         id: 'sample3.mp3-438bebdd',
//                   //         title: 'audio',
//                   //       ),
//                   //     ),
//                   //     titleTextStyle: FlutterFlowTheme.of(context).titleLarge,
//                   //     playbackDurationTextStyle:
//                   //         FlutterFlowTheme.of(context).labelMedium,
//                   //     fillColor:
//                   //         FlutterFlowTheme.of(context).secondaryBackground,
//                   //     playbackButtonColor:
//                   //         FlutterFlowTheme.of(context).primaryBackground,
//                   //     activeTrackColor: FlutterFlowTheme.of(context).alternate,
//                   //     elevation: 4.0,
//                   //     playInBackground:
//                   //         PlayInBackground.disabledRestoreOnForeground,
//                   //   ),
//                   // ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   FFButtonWidget(
//                     onPressed: !_model.isRecording
//                         ? null
//                         : () async {
//                             Navigator.pop(context);
//                           },
//                     text: '',
//                     icon: Icon(
//                       Icons.delete,
//                       size: 15.0,
//                     ),
//                     options: FFButtonOptions(
//                       height: 40.0,
//                       padding:
//                           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
//                       iconPadding:
//                           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
//                       color: FlutterFlowTheme.of(context).error,
//                       textStyle:
//                           FlutterFlowTheme.of(context).titleMedium.override(
//                                 fontFamily: 'Readex Pro',
//                                 color: Colors.white,
//                                 fontSize: 16.0,
//                               ),
//                       elevation: 3.0,
//                       borderRadius: BorderRadius.circular(50.0),
//                       disabledTextColor:
//                           FlutterFlowTheme.of(context).primaryText,
//                     ),
//                   ),
//                   Stack(
//                     children: [
//                       if (!widget.dirctRecording!)
//                         FFButtonWidget(
//                           onPressed: !_model.isRecording
//                               ? null
//                               : () async {
//                                   _model.recording =
//                                       await _model.audioRecorder2?.stop();
//                                   setState(() {
//                                     _model.isRecording = false;
//                                     _model.isShowPlayer = true;
//                                   });
//
//                                   setState(() {});
//                                 },
//                           text: '',
//                           icon: Icon(
//                             Icons.pause_sharp,
//                             size: 15.0,
//                           ),
//                           options: FFButtonOptions(
//                             height: 40.0,
//                             padding: EdgeInsetsDirectional.fromSTEB(
//                                 0.0, 0.0, 0.0, 0.0),
//                             iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                 0.0, 0.0, 0.0, 0.0),
//                             color: Color(0xFFFF5963),
//                             textStyle: FlutterFlowTheme.of(context)
//                                 .titleMedium
//                                 .override(
//                                   fontFamily: 'Readex Pro',
//                                   color: Colors.white,
//                                 ),
//                             elevation: 3.0,
//                             borderRadius: BorderRadius.circular(50.0),
//                             disabledColor:
//                                 FlutterFlowTheme.of(context).primaryBackground,
//                             disabledTextColor:
//                                 FlutterFlowTheme.of(context).primaryText,
//                           ),
//                         ),
//                       if (widget.dirctRecording ?? true)
//                         FFButtonWidget(
//                           onPressed: !_model.isRecording
//                               ? null
//                               : () async {
//                                   _model.recordingDirect =
//                                       await _model.audioRecorder1?.stop();
//                                   setState(() {
//                                     _model.isRecording = false;
//                                     _model.isShowPlayer = true;
//                                   });
//
//                                   setState(() {});
//                                 },
//                           text: '',
//                           icon: Icon(
//                             Icons.pause_sharp,
//                             size: 15.0,
//                           ),
//                           options: FFButtonOptions(
//                             height: 40.0,
//                             padding: EdgeInsetsDirectional.fromSTEB(
//                                 0.0, 0.0, 0.0, 0.0),
//                             iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                 0.0, 0.0, 0.0, 0.0),
//                             color: Color(0xFFFF5963),
//                             textStyle: FlutterFlowTheme.of(context)
//                                 .titleMedium
//                                 .override(
//                                   fontFamily: 'Readex Pro',
//                                   color: Colors.white,
//                                 ),
//                             elevation: 3.0,
//                             borderRadius: BorderRadius.circular(50.0),
//                             disabledColor:
//                                 FlutterFlowTheme.of(context).primaryBackground,
//                             disabledTextColor:
//                                 FlutterFlowTheme.of(context).primaryText,
//                           ),
//                         ),
//                       if (!_model.isRecording)
//                         FFButtonWidget(
//                           onPressed: () async {
//                             await requestPermission(microphonePermission);
//                             if (await getPermissionStatus(
//                                 microphonePermission)) {
//                               setState(() {
//                                 _model.isRecording = true;
//                                 _model.isShowPlayer = false;
//                               });
//                               _model.audioRecorder2 ??= Record();
//                               if (await _model.audioRecorder2!
//                                   .hasPermission()) {
//                                 await _model.audioRecorder2!.start();
//                               } else {
//                                 showSnackbar(
//                                   context,
//                                   'You have not provided permission to record audio.',
//                                 );
//                               }
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     'Permission denied!',
//                                     style: TextStyle(
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                     ),
//                                   ),
//                                   duration: Duration(milliseconds: 4000),
//                                   backgroundColor:
//                                       FlutterFlowTheme.of(context).secondary,
//                                 ),
//                               );
//                             }
//                           },
//                           text: '',
//                           icon: Icon(
//                             Icons.play_arrow,
//                             size: 15.0,
//                           ),
//                           options: FFButtonOptions(
//                             height: 40.0,
//                             padding: EdgeInsetsDirectional.fromSTEB(
//                                 0.0, 0.0, 0.0, 0.0),
//                             iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                 0.0, 0.0, 0.0, 0.0),
//                             color: FlutterFlowTheme.of(context).primary,
//                             textStyle: FlutterFlowTheme.of(context)
//                                 .titleMedium
//                                 .override(
//                                   fontFamily: 'Readex Pro',
//                                   color: Colors.white,
//                                   fontSize: 18.0,
//                                 ),
//                             elevation: 3.0,
//                             borderRadius: BorderRadius.circular(50.0),
//                           ),
//                         ),
//                     ],
//                   ),
//                   FFButtonWidget(
//                     onPressed: !_model.isRecording
//                         ? null
//                         : () async {
//                             _model.stop = await _model.audioRecorder1?.stop();
//                             setState(() {
//                               _model.audiopath = _model.stop;
//                             });
//
//                             setState(() {});
//                           },
//                     text: '',
//                     icon: Icon(
//                       Icons.send,
//                       size: 15.0,
//                     ),
//                     options: FFButtonOptions(
//                       height: 40.0,
//                       padding:
//                           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
//                       iconPadding:
//                           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
//                       color: FlutterFlowTheme.of(context).success,
//                       textStyle:
//                           FlutterFlowTheme.of(context).titleMedium.override(
//                                 fontFamily: 'Readex Pro',
//                                 color: Colors.white,
//                                 fontSize: 16.0,
//                               ),
//                       elevation: 3.0,
//                       borderRadius: BorderRadius.circular(50.0),
//                       disabledTextColor:
//                           FlutterFlowTheme.of(context).primaryText,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
