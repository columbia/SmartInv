1 contract FastRealisticPyramid {
2 
3         struct Person {
4                 address etherAddress;
5                 uint amount;
6         }
7 
8         Person[] public person;
9 
10         uint public payoutIdx = 0;
11         uint public collectedFees;
12         uint public balance = 0;
13 
14         address public owner;
15 
16         modifier onlyowner {
17                 if (msg.sender == owner) _
18         }
19 
20 
21         function FastRealisticPyramid() {
22                 owner = msg.sender;
23         }
24 
25 
26         function() {
27                 enter();
28         }
29 
30         function enter() {
31                 if (msg.value < 1/100 ether || msg.value > 50) {
32                         msg.sender.send(msg.value);
33                         return;
34                 }
35 
36 
37                 uint idx = person.length;
38                 person.length += 1;
39                 person[idx].etherAddress = msg.sender;
40                 person[idx].amount = msg.value;
41 
42 
43                 if (idx != 0) {
44                         collectedFees += msg.value / 10;
45                         balance += msg.value;
46                 } else {
47 
48                         collectedFees += msg.value;
49                 }
50 
51 
52                 if (balance > person[payoutIdx].amount * 7/5) {
53                         uint transactionAmount = 7/5 * (person[payoutIdx].amount - person[payoutIdx].amount / 10);
54                         person[payoutIdx].etherAddress.send(transactionAmount);
55 
56                         balance -= person[payoutIdx].amount * 7/5;
57                         payoutIdx += 1;
58                 }
59         }
60 
61         function collectFees() onlyowner {
62                 if (collectedFees == 0) return;
63 
64                 owner.send(collectedFees);
65                 collectedFees = 0;
66         }
67 
68         function setOwner(address _owner) onlyowner {
69                 owner = _owner;
70         }
71 }