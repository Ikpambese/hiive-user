import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiiveuser/delivery/ticket.dart';
import 'package:hiiveuser/global/global.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import '../services/notification_service.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
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
    "What's the receiver's alternate phone number?",
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
        appBar: AppBar(
          title: const Text(
            'Hiive',
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Signatra',
              color: Colors.amber,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.amber),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10, top: 5),
              child: ClipOval(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: ClipOval(
                    child: Image.network(
                      sharedPreferences!.getString('photoUrl')!,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            // Chat Interface
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatHistory.length + 1,
                    itemBuilder: (context, index) {
                      if (index < chatHistory.length) {
                        return _buildChatMessage(chatHistory[index]);
                      } else if (currentStep < questions.length) {
                        return _buildBotMessage(questions[currentStep]);
                      } else if (currentStep == questions.length) {
                        return _buildSummaryMessage();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                if (currentStep <= questions.length) _buildInputArea(),
              ],
            ),
            // History Tab
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('minordelivery')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  final requests = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request =
                          requests[index].data() as Map<String, dynamic>;
                      return _buildHistoryTile(request, requests[index].id);
                    },
                  );
                }
                return const Center(child: Text('No delivery history found.'));
              },
            ),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.chat), text: "New Delivery"),
            Tab(icon: Icon(Icons.history), text: "History"),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(Map<String, String> message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: message['type'] == 'bot'
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message['type'] == 'bot'
                  ? Colors.blue[100]
                  : Colors.amber[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(message['message']!),
          ),
        ],
      ),
    );
  }

  Widget _buildBotMessage(String message) {
    return _buildChatMessage({'type': 'bot', 'message': message});
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: 'Type your answer...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _handleSubmit,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMessage() {
    String summary = "Here's a summary of your delivery request:\n\n";
    for (int i = 0; i < questions.length; i++) {
      summary += "${questions[i]}\n${deliveryData[fields[i]]}\n\n";
    }
    summary +=
        "\nWould you like to create this delivery ticket? (Type 'yes' to confirm)";
    return _buildBotMessage(summary);
  }

  void _handleSubmit() {
    if (_inputController.text.isEmpty) return;

    String userInput = _inputController.text.trim();

    // Check for duplicate answer
    if (deliveryData.containsValue(userInput)) {
      setState(() {
        chatHistory.add({
          'type': 'bot',
          'message':
              'This answer was already used. Please provide a different answer.',
        });
      });
      _inputController.clear();
      return;
    }

    setState(() {
      chatHistory.add({
        'type': 'user',
        'message': userInput,
      });

      if (currentStep < questions.length) {
        deliveryData[fields[currentStep]] = userInput;
        if (currentStep < questions.length - 1) {
          chatHistory.add({
            'type': 'bot',
            'message': questions[currentStep + 1],
          });
        }
        currentStep++;
      } else if (userInput.toLowerCase() == 'yes') {
        _createDeliveryTicket();
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
    }).then((_) {
      setState(() {
        // Clear everything and start fresh
        chatHistory.clear();
        deliveryData.clear();
        currentStep = 0;

        // Show success message and start new chat
        chatHistory.add({
          'type': 'bot',
          'message': 'Delivery ticket created successfully!\n\n' +
              'Let\'s create a new delivery ticket!\n\n' +
              questions[0],
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
      child: ListTile(
        title: Text(request['packageName']?.toString() ?? 'No name'),
        subtitle:
            Text(request['packageDestination']?.toString() ?? 'No address'),
        trailing: Text('₦${request['bill']?.toString() ?? '0'}'),
        onTap: () => _showTrackingCard(request, docId),
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
