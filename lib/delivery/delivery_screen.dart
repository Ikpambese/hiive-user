import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiiveuser/delivery/ticket.dart';
import 'package:hiiveuser/global/global.dart';

import 'package:audioplayers/audioplayers.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

//
class _DeliveryPageState extends State<DeliveryPage>
    with TickerProviderStateMixin {
  // Add audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Add these animation controllers
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
  }

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int currentStep = 0;
  Map<String, String> deliveryData = {};
  List<Map<String, String>> chatHistory = [];

  final List<String> questions = [
    "What's the name of your package?",
    "What's the approximate weight of your package?",
    "Please describe your package briefly",
    "What's the destination address?",
    "What's your name (sender)?",
    "What's your phone number?",
    "What's the receiver's name?",
    "What's the receiver's phone number?",
    "What's the receiver's address?",
    "What's the receiver's alternate phone number? Enter yes to create the ticket",
  ];

  final List<String> fields = [
    'packageName',
    'packageWeight',
    'packageDescription',
    'packageDestination',
    'packageSenderName',
    'packageSenderPhone',
    'receiverName',
    'receiverPhone',
    'receiverAddress',
    'receiverAltPhone',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Hiive',
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Signatra',
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                child: sharedPreferences?.getString('photoUrl') == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString('photoUrl')!,
                        ),
                      ),
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: Colors.amber,
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    icon: Icon(Icons.local_shipping_outlined),
                    text: "New Delivery",
                  ),
                  Tab(
                    icon: Icon(Icons.history),
                    text: "History",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Chat Interface
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildChatInterface(),
                  ),
                  // History Tab
                  SlideTransition(
                    position: _slideAnimation,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('minordelivery')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text('No delivery history'));
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var doc = snapshot.data!.docs[index];
                            return _buildHistoryTile(
                              doc.data() as Map<String, dynamic>,
                              doc.id,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update the _buildChatInterface method
  Widget _buildChatInterface() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: chatHistory.length +
                    (currentStep < questions.length ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < chatHistory.length) {
                    return _buildAnimatedChatMessage(chatHistory[index]);
                  } else if (currentStep < questions.length &&
                      chatHistory.isEmpty) {
                    return _buildAnimatedChatMessage(
                        {'type': 'bot', 'message': questions[currentStep]});
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
        if (currentStep <= questions.length) _buildEnhancedInputArea(),
      ],
    );
  }

  Widget _buildAnimatedChatMessage(Map<String, String> message) {
    return SlideTransition(
      position: _slideAnimation,
      child: MouseRegion(
        onEnter: (_) => _scaleController.forward(),
        onExit: (_) => _scaleController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: _buildChatMessage(message),
        ),
      ),
    );
  }

  Widget _buildEnhancedInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: 'Type your answer...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: _handleSubmit,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Update the _buildChatMessage method to handle long messages better
  Widget _buildChatMessage(Map<String, String> message) {
    bool isBot = message['type'] == 'bot';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: const CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 15,
                child: Icon(Icons.support_agent, color: Colors.white, size: 20),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isBot ? Colors.white : Colors.amber.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isBot ? 0 : 20),
                  topRight: Radius.circular(isBot ? 20 : 0),
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: isBot ? Border.all(color: Colors.grey.shade200) : null,
              ),
              child: Text(
                message['message']!,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: isBot ? Colors.black87 : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Update _handleSubmit to include sound effects
  void _handleSubmit() {
    if (_inputController.text.isEmpty) {
      _audioPlayer.play(AssetSource('sounds/yes.wav'));
      setState(() {
        chatHistory.add({
          'type': 'bot',
          'message':
              '⚠️ Please provide a response. This field cannot be left blank.',
        });
      });
      _scrollToBottom();
      return;
    }

    String userInput = _inputController.text.trim();
    _audioPlayer.play(AssetSource('sounds/message_sent.mp3'));

    setState(() {
      chatHistory.add({
        'type': 'user',
        'message': userInput,
      });

      if (currentStep < questions.length) {
        deliveryData[fields[currentStep]] = userInput;
        currentStep++;

        if (currentStep < questions.length) {
          chatHistory.add({
            'type': 'bot',
            'message': questions[currentStep],
          });
        } else {
          // Add this confirmation message when all questions are answered
          chatHistory.add({
            'type': 'bot',
            'message':
                "Great! All information has been collected.\n\nPlease type 'yes' to create your delivery ticket or any other response to cancel.",
          });
        }
      } else if (userInput.toLowerCase() == 'yes') {
        _createDeliveryTicket();
      } else {
        chatHistory.add({
          'type': 'bot',
          'message':
              "❗ Please type 'yes' to confirm and create the delivery ticket, or provide a different response to cancel.",
        });
      }
    });

    _inputController.clear();
    _scrollToBottom();
  }

  void _createDeliveryTicket() {
    FirebaseFirestore.instance.collection('minordelivery').add({
      ...deliveryData,
      'status': 'Pending',
      'bill': 0.0,
      'timestamp': DateTime.now(),
      'userId': sharedPreferences!.getString('uid'), // Add user ID to ticket
    }).then((_) {
      setState(() {
        // Clear everything and start fresh
        chatHistory.clear();
        deliveryData.clear();
        currentStep = 0;

        // Show success message and start new chat
        chatHistory.add({
          'type': 'bot',
          'message':
              'Delivery ticket created successfully!\n\nLet\'s create a new delivery ticket!\n\n${questions[0]}',
        });
      });
    }).catchError((error) {
      setState(() {
        chatHistory.add({
          'type': 'bot',
          'message': 'Error creating ticket. Please try again.',
        });
      });
    });
  }

  Widget _buildHistoryTile(Map<String, dynamic> request, String docId) {
    // Only show tickets created by the current user
    String? currentUserId = sharedPreferences!.getString('uid');
    if (request['userId'] != currentUserId) {
      return const SizedBox.shrink();
    }

    return Dismissible(
      key: Key(docId),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content:
                  const Text("Are you sure you want to delete this ticket?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "DELETE",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        FirebaseFirestore.instance
            .collection('minordelivery')
            .doc(docId)
            .delete()
            .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error deleting ticket'),
              backgroundColor: Colors.red,
            ),
          );
        });
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.amber.withOpacity(0.2)),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_shipping, color: Colors.amber),
          ),
          title: Text(
            request['packageName']?.toString() ?? 'No name',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "To: ${request['receiverName']?.toString()}" ??
                        'No address',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    (request['timestamp'] as Timestamp?)
                            ?.toDate()
                            .toString()
                            .split('.')[0] ??
                        'N/A',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(request['status']?.toString()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              request['status']?.toString() ?? 'Pending',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          onTap: () => _showTrackingCard(request, docId),
        ),
      ),
    );
  }

  void _showTrackingCard(Map<String, dynamic> request, String docId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: TrackingCard(
            trackingId: docId,
            status: request['status']?.toString() ?? 'Pending',
            type: 'Package Delivery',
            departure: request['packageSenderName']?.toString() ?? 'N/A',
            sortingCenter: 'Processing',
            arrival: request['receiverName']?.toString() ?? 'N/A',
            departureTime: (request['timestamp'] as Timestamp?)
                    ?.toDate()
                    .toString()
                    .split('.')[0] ??
                'N/A',
            sortingCenterTime: 'Pending',
            arrivalTime: 'Pending',
            bill: (request['bill'] as num?)?.toDouble() ?? 0.0,
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class TexformWidget extends StatelessWidget {
  const TexformWidget({
    Key? key,
    required this.controller,
    required this.text,
    required this.hint,
  }) : super(key: key);

  final TextEditingController controller;
  final String text;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return text;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

Color _getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'in progress':
      return Colors.blue;
    case 'delivered':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
