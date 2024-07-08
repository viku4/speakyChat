// import '/auth/supabase_auth/auth_util.dart';
// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_expanded_image_view.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:octo_image/octo_image.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
// import 'chat_messages_model.dart';
// export 'chat_messages_model.dart';
//
// class ChatMessagesWidget extends StatefulWidget {
//   const ChatMessagesWidget({
//     Key? key,
//     required this.chatidRow,
//     required this.currChatTime,
//   }) : super(key: key);
//
//   final AChatMessagesInfoViewRow? chatidRow;
//   final DateTime? currChatTime;
//
//   @override
//   _ChatMessagesWidgetState createState() => _ChatMessagesWidgetState();
// }
//
// class _ChatMessagesWidgetState extends State<ChatMessagesWidget> {
//   late ChatMessagesModel _model;
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
//     _model = createModel(context, () => ChatMessagesModel());
//
//     // On component load action.
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       if (!((widget.chatidRow?.readAt == null) &&
//           (widget.chatidRow?.userId != currentUserUid))) {
//         return;
//       }
//       await AMessageReceiptsTable().update(
//         data: {
//           'read_at': supaSerialize<DateTime>(widget.currChatTime),
//         },
//         matchingRows: (rows) => rows.eq(
//           'message_id',
//           widget.chatidRow?.messageId,
//         ),
//       );
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
//     return Padding(
//       padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.chatidRow?.userId != currentUserUid)
//             Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Flexible(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           constraints: BoxConstraints(
//                             maxWidth: MediaQuery.sizeOf(context).width >= 1270.0
//                                 ? 370.0
//                                 : 280.0,
//                           ),
//                           decoration: BoxDecoration(
//                             color: FlutterFlowTheme.of(context)
//                                 .secondaryBackground,
//                             boxShadow: [
//                               BoxShadow(
//                                 blurRadius: 3.0,
//                                 color: Color(0x33000000),
//                                 offset: Offset(0.0, 1.0),
//                               )
//                             ],
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(0.0),
//                               bottomRight: Radius.circular(12.0),
//                               topLeft: Radius.circular(12.0),
//                               topRight: Radius.circular(12.0),
//                             ),
//                             border: Border.all(
//                               color: FlutterFlowTheme.of(context).alternate,
//                               width: 1.0,
//                             ),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 if (widget.chatidRow?.messageId != null)
//                                   Builder(
//                                     builder: (context) {
//                                       if (true) {
//                                         return Padding(
//                                           padding:
//                                               EdgeInsetsDirectional.fromSTEB(
//                                                   0.0, 5.0, 0.0, 0.0),
//                                           child: InkWell(
//                                             splashColor: Colors.transparent,
//                                             focusColor: Colors.transparent,
//                                             hoverColor: Colors.transparent,
//                                             highlightColor: Colors.transparent,
//                                             onTap: () async {
//                                               await Navigator.push(
//                                                 context,
//                                                 PageTransition(
//                                                   type: PageTransitionType.fade,
//                                                   child:
//                                                       FlutterFlowExpandedImageView(
//                                                     image: Image.network(
//                                                       'https://picsum.photos/seed/709/600',
//                                                       fit: BoxFit.contain,
//                                                     ),
//                                                     allowRotation: false,
//                                                     tag: 'imageTag1',
//                                                     useHeroAnimation: true,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             child: Hero(
//                                               tag: 'imageTag1',
//                                               transitionOnUserGestures: true,
//                                               child: ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8.0),
//                                                 child: Image.network(
//                                                   'https://picsum.photos/seed/709/600',
//                                                   width: 300.0,
//                                                   height: 200.0,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       } else {
//                                         return Container(
//                                           width: 300.0,
//                                           height: 300.0,
//                                           decoration: BoxDecoration(),
//                                           child: GridView(
//                                             padding: EdgeInsets.zero,
//                                             gridDelegate:
//                                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                               crossAxisCount: 2,
//                                               crossAxisSpacing: 10.0,
//                                               mainAxisSpacing: 10.0,
//                                               childAspectRatio: 1.0,
//                                             ),
//                                             shrinkWrap: true,
//                                             scrollDirection: Axis.vertical,
//                                             children: [
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8.0),
//                                                 child: Image.network(
//                                                   widget.chatidRow!.media[0],
//                                                   width: 300.0,
//                                                   height: 200.0,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8.0),
//                                                 child: Image.network(
//                                                   widget.chatidRow!.media[1],
//                                                   width: 300.0,
//                                                   height: 200.0,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8.0),
//                                                 child: Image.network(
//                                                   widget.chatidRow!.media[2],
//                                                   width: 300.0,
//                                                   height: 200.0,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                               Stack(
//                                                 children: [
//                                                   Builder(
//                                                     builder: (context) {
//                                                       final allImages = widget
//                                                               .chatidRow?.media
//                                                               ?.map((e) => e)
//                                                               .toList()
//                                                               ?.toList() ??
//                                                           [];
//                                                       return Stack(
//                                                         children: List.generate(
//                                                             allImages.length,
//                                                             (allImagesIndex) {
//                                                           final allImagesItem =
//                                                               allImages[
//                                                                   allImagesIndex];
//                                                           return Opacity(
//                                                             opacity: 0.2,
//                                                             child: InkWell(
//                                                               splashColor: Colors
//                                                                   .transparent,
//                                                               focusColor: Colors
//                                                                   .transparent,
//                                                               hoverColor: Colors
//                                                                   .transparent,
//                                                               highlightColor:
//                                                                   Colors
//                                                                       .transparent,
//                                                               onTap: () async {
//                                                                 await Navigator
//                                                                     .push(
//                                                                   context,
//                                                                   PageTransition(
//                                                                     type: PageTransitionType
//                                                                         .fade,
//                                                                     child:
//                                                                         FlutterFlowExpandedImageView(
//                                                                       image: Image
//                                                                           .network(
//                                                                         allImagesItem,
//                                                                         fit: BoxFit
//                                                                             .contain,
//                                                                       ),
//                                                                       allowRotation:
//                                                                           false,
//                                                                       tag:
//                                                                           allImagesItem,
//                                                                       useHeroAnimation:
//                                                                           true,
//                                                                     ),
//                                                                   ),
//                                                                 );
//                                                               },
//                                                               child: Hero(
//                                                                 tag:
//                                                                     allImagesItem,
//                                                                 transitionOnUserGestures:
//                                                                     true,
//                                                                 child:
//                                                                     ClipRRect(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               8.0),
//                                                                   child: Image
//                                                                       .network(
//                                                                     allImagesItem,
//                                                                     width:
//                                                                         300.0,
//                                                                     height:
//                                                                         200.0,
//                                                                     fit: BoxFit
//                                                                         .cover,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         }),
//                                                       );
//                                                     },
//                                                   ),
//                                                   Align(
//                                                     alignment:
//                                                         AlignmentDirectional(
//                                                             0.0, 0.0),
//                                                     child: Text(
//                                                       '+ ${(widget.chatidRow!.media.length - 3).toString()}',
//                                                       style:
//                                                           FlutterFlowTheme.of(
//                                                                   context)
//                                                               .bodyMedium
//                                                               .override(
//                                                                 fontFamily:
//                                                                     ' Comic Sans MS',
//                                                                 fontSize: 20.0,
//                                                                 useGoogleFonts:
//                                                                     false,
//                                                               ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 if (widget.chatidRow?.message != null &&
//                                     widget.chatidRow?.message != '')
//                                   Padding(
//                                     padding: EdgeInsets.all(4.0),
//                                     child: SelectionArea(
//                                         child: Text(
//                                       valueOrDefault<String>(
//                                         widget.chatidRow?.message,
//                                         'null',
//                                       ),
//                                       style: FlutterFlowTheme.of(context)
//                                           .labelMedium
//                                           .override(
//                                             fontFamily: 'Readex Pro',
//                                             color: FlutterFlowTheme.of(context)
//                                                 .secondaryText,
//                                           ),
//                                     )),
//                                   ),
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       dateTimeFormat(
//                                           'jm', widget.chatidRow!.createdAt!),
//                                       style: FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .override(
//                                             fontFamily: ' Comic Sans MS',
//                                             color: FlutterFlowTheme.of(context)
//                                                 .secondaryText,
//                                             fontSize: 10.0,
//                                             useGoogleFonts: false,
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(
//                               0.0, 4.0, 0.0, 0.0),
//                           child: Text(
//                             'Just Now',
//                             style: FlutterFlowTheme.of(context).labelSmall,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           if (widget.chatidRow?.userId == currentUserUid)
//             Align(
//               alignment: AlignmentDirectional(1.0, 0.0),
//               child: Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Flexible(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Container(
//                             constraints: BoxConstraints(
//                               maxWidth:
//                                   MediaQuery.sizeOf(context).width >= 1270.0
//                                       ? 390.0
//                                       : 300.0,
//                             ),
//                             decoration: BoxDecoration(
//                               color: FlutterFlowTheme.of(context).primary,
//                               boxShadow: [
//                                 BoxShadow(
//                                   blurRadius: 3.0,
//                                   color: Color(0x33000000),
//                                   offset: Offset(0.0, 1.0),
//                                 )
//                               ],
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(12.0),
//                                 bottomRight: Radius.circular(0.0),
//                                 topLeft: Radius.circular(12.0),
//                                 topRight: Radius.circular(12.0),
//                               ),
//                               border: Border.all(
//                                 color: FlutterFlowTheme.of(context).accent1,
//                               ),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   if (widget.chatidRow?.media?.first != '-')
//                                     Builder(
//                                       builder: (context) {
//                                         if (widget.chatidRow!.media.length <=
//                                             3) {
//                                           return Builder(
//                                             builder: (context) {
//                                               final noOFimages = widget
//                                                       .chatidRow?.media
//                                                       ?.map((e) => e)
//                                                       .toList()
//                                                       ?.toList() ??
//                                                   [];
//                                               return Column(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: List.generate(
//                                                     noOFimages.length,
//                                                     (noOFimagesIndex) {
//                                                   final noOFimagesItem =
//                                                       noOFimages[
//                                                           noOFimagesIndex];
//                                                   return Padding(
//                                                     padding:
//                                                         EdgeInsetsDirectional
//                                                             .fromSTEB(0.0, 5.0,
//                                                                 0.0, 0.0),
//                                                     child: InkWell(
//                                                       splashColor:
//                                                           Colors.transparent,
//                                                       focusColor:
//                                                           Colors.transparent,
//                                                       hoverColor:
//                                                           Colors.transparent,
//                                                       highlightColor:
//                                                           Colors.transparent,
//                                                       onTap: () async {
//                                                         await Navigator.push(
//                                                           context,
//                                                           PageTransition(
//                                                             type:
//                                                                 PageTransitionType
//                                                                     .fade,
//                                                             child:
//                                                                 FlutterFlowExpandedImageView(
//                                                               image:
//                                                                   CachedNetworkImage(
//                                                                 fadeInDuration:
//                                                                     Duration(
//                                                                         milliseconds:
//                                                                             200),
//                                                                 fadeOutDuration:
//                                                                     Duration(
//                                                                         milliseconds:
//                                                                             200),
//                                                                 imageUrl:
//                                                                     noOFimagesItem,
//                                                                 fit: BoxFit
//                                                                     .contain,
//                                                               ),
//                                                               allowRotation:
//                                                                   false,
//                                                               tag:
//                                                                   noOFimagesItem,
//                                                               useHeroAnimation:
//                                                                   true,
//                                                             ),
//                                                           ),
//                                                         );
//                                                       },
//                                                       child: Hero(
//                                                         tag: noOFimagesItem,
//                                                         transitionOnUserGestures:
//                                                             true,
//                                                         child: ClipRRect(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       8.0),
//                                                           child:
//                                                               CachedNetworkImage(
//                                                             fadeInDuration:
//                                                                 Duration(
//                                                                     milliseconds:
//                                                                         200),
//                                                             fadeOutDuration:
//                                                                 Duration(
//                                                                     milliseconds:
//                                                                         200),
//                                                             imageUrl:
//                                                                 noOFimagesItem,
//                                                             width: 300.0,
//                                                             height: 200.0,
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 }),
//                                               );
//                                             },
//                                           );
//                                         } else {
//                                           return Container(
//                                             width: 300.0,
//                                             height: 300.0,
//                                             decoration: BoxDecoration(),
//                                             child: GridView(
//                                               padding: EdgeInsets.zero,
//                                               gridDelegate:
//                                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                                 crossAxisCount: 2,
//                                                 crossAxisSpacing: 10.0,
//                                                 mainAxisSpacing: 10.0,
//                                                 childAspectRatio: 1.0,
//                                               ),
//                                               shrinkWrap: true,
//                                               scrollDirection: Axis.vertical,
//                                               children: [
//                                                 ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           8.0),
//                                                   child: Image.network(
//                                                     widget.chatidRow!.media[0],
//                                                     width: 300.0,
//                                                     height: 200.0,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                                 ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           8.0),
//                                                   child: Image.network(
//                                                     widget.chatidRow!.media[1],
//                                                     width: 300.0,
//                                                     height: 200.0,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                                 ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           8.0),
//                                                   child: Image.network(
//                                                     widget.chatidRow!.media[2],
//                                                     width: 300.0,
//                                                     height: 200.0,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                                 Stack(
//                                                   children: [
//                                                     Builder(
//                                                       builder: (context) {
//                                                         final allImages = widget
//                                                                 .chatidRow
//                                                                 ?.media
//                                                                 ?.map((e) => e)
//                                                                 .toList()
//                                                                 ?.toList() ??
//                                                             [];
//                                                         return Stack(
//                                                           children: List.generate(
//                                                               allImages.length,
//                                                               (allImagesIndex) {
//                                                             final allImagesItem =
//                                                                 allImages[
//                                                                     allImagesIndex];
//                                                             return Opacity(
//                                                               opacity: 0.2,
//                                                               child: InkWell(
//                                                                 splashColor: Colors
//                                                                     .transparent,
//                                                                 focusColor: Colors
//                                                                     .transparent,
//                                                                 hoverColor: Colors
//                                                                     .transparent,
//                                                                 highlightColor:
//                                                                     Colors
//                                                                         .transparent,
//                                                                 onTap:
//                                                                     () async {
//                                                                   await Navigator
//                                                                       .push(
//                                                                     context,
//                                                                     PageTransition(
//                                                                       type: PageTransitionType
//                                                                           .fade,
//                                                                       child:
//                                                                           FlutterFlowExpandedImageView(
//                                                                         image: Image
//                                                                             .network(
//                                                                           allImagesItem,
//                                                                           fit: BoxFit
//                                                                               .contain,
//                                                                         ),
//                                                                         allowRotation:
//                                                                             false,
//                                                                         tag:
//                                                                             allImagesItem,
//                                                                         useHeroAnimation:
//                                                                             true,
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                                 child: Hero(
//                                                                   tag:
//                                                                       allImagesItem,
//                                                                   transitionOnUserGestures:
//                                                                       true,
//                                                                   child:
//                                                                       ClipRRect(
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             8.0),
//                                                                     child: Image
//                                                                         .network(
//                                                                       allImagesItem,
//                                                                       width:
//                                                                           300.0,
//                                                                       height:
//                                                                           200.0,
//                                                                       fit: BoxFit
//                                                                           .cover,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           }),
//                                                         );
//                                                       },
//                                                     ),
//                                                     Align(
//                                                       alignment:
//                                                           AlignmentDirectional(
//                                                               0.0, 0.0),
//                                                       child: Text(
//                                                         '+ ${(widget.chatidRow!.media.length - 3).toString()}',
//                                                         style: FlutterFlowTheme
//                                                                 .of(context)
//                                                             .bodyMedium
//                                                             .override(
//                                                               fontFamily:
//                                                                   ' Comic Sans MS',
//                                                               fontSize: 20.0,
//                                                               useGoogleFonts:
//                                                                   false,
//                                                             ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         }
//                                       },
//                                     ),
//                                   Wrap(
//                                     spacing: 0.0,
//                                     runSpacing: 0.0,
//                                     alignment: WrapAlignment.start,
//                                     crossAxisAlignment:
//                                         WrapCrossAlignment.start,
//                                     direction: Axis.horizontal,
//                                     runAlignment: WrapAlignment.start,
//                                     verticalDirection: VerticalDirection.down,
//                                     clipBehavior: Clip.none,
//                                     children: [
//                                       if (widget.chatidRow?.message != null &&
//                                           widget.chatidRow?.message != '')
//                                         Padding(
//                                           padding: EdgeInsets.all(4.0),
//                                           child: SelectionArea(
//                                               child: Text(
//                                             valueOrDefault<String>(
//                                               widget.chatidRow?.message,
//                                               '-',
//                                             ),
//                                             style: FlutterFlowTheme.of(context)
//                                                 .labelMedium
//                                                 .override(
//                                                   fontFamily: 'Readex Pro',
//                                                   color: FlutterFlowTheme.of(
//                                                           context)
//                                                       .info,
//                                                 ),
//                                           )),
//                                         ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         dateTimeFormat(
//                                             'jm', widget.chatidRow!.createdAt!),
//                                         style: FlutterFlowTheme.of(context)
//                                             .bodyMedium
//                                             .override(
//                                               fontFamily: ' Comic Sans MS',
//                                               fontSize: 10.0,
//                                               useGoogleFonts: false,
//                                             ),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsetsDirectional.fromSTEB(
//                                             3.0, 0.0, 0.0, 0.0),
//                                         child: Builder(
//                                           builder: (context) {
//                                             if (widget.chatidRow?.readAt !=
//                                                 null) {
//                                               return Icon(
//                                                 Icons.done_all,
//                                                 color:
//                                                     FlutterFlowTheme.of(context)
//                                                         .primaryText,
//                                                 size: 10.0,
//                                               );
//                                             } else {
//                                               return Icon(
//                                                 Icons.done,
//                                                 color:
//                                                     FlutterFlowTheme.of(context)
//                                                         .secondaryBackground,
//                                                 size: 10.0,
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsetsDirectional.fromSTEB(
//                                 0.0, 4.0, 0.0, 0.0),
//                             child: Text(
//                               'Just Now',
//                               style: FlutterFlowTheme.of(context).labelSmall,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
