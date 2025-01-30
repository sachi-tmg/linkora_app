// import 'package:flutter/material.dart';
// import 'package:linkora_app/model/dashboard_model.dart';

// class PostCard extends StatefulWidget {
//   final Post post;

//   const PostCard({super.key, required this.post});

//   @override
//   // ignore: library_private_types_in_public_api
//   _PostCardState createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   late bool isLiked; // Local like state
//   late int likeCount; // Local like count

//   @override
//   void initState() {
//     super.initState();
//     isLiked = false; // Initialize as unliked
//     likeCount = widget.post.likes; // Initialize like count from the model
//   }

//   void _toggleLike() {
//     setState(() {
//       isLiked = !isLiked;
//       likeCount += isLiked ? 1 : -1; // Increment or decrement like count
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: const Color.fromARGB(255, 250, 250, 250),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: const EdgeInsets.only(bottom: 20.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Left side: Post details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     widget.post.title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                   const SizedBox(height: 8),
//                   // Content preview
//                   Text(
//                     widget.post.content,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 12),
//                   // Tags
//                   Wrap(
//                     spacing: 8,
//                     children: widget.post.tags.map((tag) {
//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.blue[50],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           tag,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 12),
//                   // Like button and count
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: _toggleLike,
//                         child: Icon(
//                           isLiked ? Icons.favorite : Icons.favorite_border,
//                           size: 20,
//                           color: isLiked ? Colors.red : Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         likeCount.toString(),
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),
//             // Right side: Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.asset(
//                 widget.post.imageUrl,
//                 width: 100,
//                 height: 100,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
