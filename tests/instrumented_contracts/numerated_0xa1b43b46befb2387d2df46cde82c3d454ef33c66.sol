1 pragma solidity ^0.4.8;
2 
3 contract TimeLockSend {
4     address sender;
5     address recipient;
6     uint256 created;
7     uint256 deadline;
8     
9     function TimeLockSend(address _sender, address _recipient, uint256 _deadline) payable {
10         if (msg.value <= 0) {
11             throw;
12         }
13         sender = _sender;
14         recipient = _recipient;
15         created = now;
16         deadline = _deadline;
17     }
18     
19     function withdraw() {
20         if (msg.sender == recipient) {
21             selfdestruct(recipient);
22         } else if (msg.sender == sender && now > deadline) {
23             selfdestruct(sender);
24         } else {
25             throw;
26         }
27     }
28     
29     function () {
30         throw;
31     }
32 }
33 
34 contract SafeSender {
35     address owner;
36     
37     event TimeLockSendCreated(
38         address indexed sender, 
39         address indexed recipient, 
40         uint256 deadline,
41         address safeSendAddress
42     );
43     
44     function SafeSender() {
45         owner = msg.sender;
46     }
47     
48     function safeSend(address recipient, uint256 timeLimit) payable returns (address) {
49         if (msg.value <= 0 || (now + timeLimit) <= now) {
50             throw;
51         }
52         uint256 deadline = now + timeLimit;
53         TimeLockSend newSend = (new TimeLockSend).value(msg.value)(msg.sender, recipient, deadline);
54         if (address(newSend) == address(0)) {
55             throw;
56         }
57         TimeLockSendCreated(
58             msg.sender,
59             recipient,
60             deadline,
61             address(newSend)
62         );
63         return address(newSend);
64     }
65     
66     function withdraw() {
67         if (msg.sender != owner) {
68             throw;
69         }
70         if (this.balance > 0 && !owner.send(this.balance)) {
71             throw;
72         }
73     }
74     
75     function () payable {
76         // why yes, thank you.
77     }
78 }