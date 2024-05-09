1 /// davidphan.eth
2 
3 pragma solidity ^0.4.0;
4 contract InternetWall {
5 
6     address owner;
7 
8     struct Message{
9         string message;
10         address from;
11         uint timestamp;
12     }
13     
14     Message[10] messages;
15     uint messagesIndex;
16     
17     uint postedMessages;
18 
19 
20     function InternetWall() {
21         owner = msg.sender;
22         messagesIndex = 0;
23         postedMessages = 0;
24     }
25     
26     function addMessage(string msgStr) payable {
27         Message memory newMsg;
28         newMsg.message = msgStr;
29         newMsg.from = msg.sender;
30         newMsg.timestamp = block.timestamp;
31         messages[messagesIndex] = newMsg;
32         messagesIndex += 1;
33         messagesIndex = messagesIndex % 10;
34         postedMessages++;
35     }
36     
37     function getMessagesCount() constant returns (uint) {
38         return messagesIndex;
39     }
40     
41     function getMessage(uint index) constant returns(string) {
42         assert(index < messagesIndex);
43         return messages[index].message;
44     }
45     function getMessageSender(uint index) constant returns(address) {
46         assert(index < messagesIndex);
47         return messages[index].from;
48     }
49     function getMessageTimestamp(uint index) constant returns(uint) {
50         assert(index < messagesIndex);
51         return messages[index].timestamp;
52     }
53     
54     function closeWall(){
55         assert(msg.sender == owner);
56         suicide(owner);
57     }
58     
59 }