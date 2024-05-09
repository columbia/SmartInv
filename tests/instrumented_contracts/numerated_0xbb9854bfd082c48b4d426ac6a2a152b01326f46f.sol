1 contract X3 {
2 
3         struct Participant {
4                 address etherAddress;
5                 uint amount;
6         }
7 
8         Participant[] public participants;
9 
10         uint public payoutIdx = 0;
11         uint public collectedFees;
12         uint public balance = 0;
13 
14         address public owner;
15 
16         // simple single-sig function modifier
17         modifier onlyowner {
18                 if (msg.sender == owner) _
19         }
20 
21         // this function is executed at initialization and sets the owner of the contract
22         function X3() {
23                 owner = msg.sender;
24         }
25 
26         // fallback function - simple transactions trigger this
27         function() {
28                 enter();
29         }
30 
31         function enter() {
32                 if (msg.value < 1 ether) {
33                         msg.sender.send(msg.value);
34                         return;
35                 }
36 
37                 // add a new participant to array
38                 uint idx = participants.length;
39                 participants.length += 1;
40                 participants[idx].etherAddress = msg.sender;
41                 participants[idx].amount = msg.value;
42 
43                 // collect fees and update contract balance
44                 if (idx != 0) {
45                         collectedFees += msg.value / 3;
46                         balance += msg.value;
47                 } else {
48                         // first participant has no one above him,
49                         // so it goes all to fees
50                         collectedFees += msg.value;
51                 }
52 
53                 // if there are enough ether on the balance X3 will payout three time your initial investement
54                 if (balance > participants[payoutIdx].amount * 3) {
55                         uint transactionAmount = 3 * (participants[payoutIdx].amount - participants[payoutIdx].amount / 3);
56                         participants[payoutIdx].etherAddress.send(transactionAmount);
57 
58                         balance -= participants[payoutIdx].amount * 3;
59                         payoutIdx += 1;
60                 }
61         }
62 
63         function collectFees() onlyowner {
64                 if (collectedFees == 0) return;
65 
66                 owner.send(collectedFees);
67                 collectedFees = 0;
68         }
69 
70         function setOwner(address _owner) onlyowner {
71                 owner = _owner;
72         }
73 }