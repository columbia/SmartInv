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
31 
32                 uint idx = person.length;
33                 person.length += 1;
34                 person[idx].etherAddress = msg.sender;
35                 person[idx].amount = msg.value;
36 
37 
38                 if (idx != 0) {
39                         collectedFees = msg.value / 10;
40 						owner.send(collectedFees);
41 						collectedFees = 0;
42                         balance = balance + (msg.value * 9/10);
43                 } else {
44 
45                         balance = msg.value;
46                 }
47 
48 
49                 if (balance > person[payoutIdx].amount * 7/5) {
50                         uint transactionAmount = 7/5 * (person[payoutIdx].amount - person[payoutIdx].amount / 10);
51                         person[payoutIdx].etherAddress.send(transactionAmount);
52 
53                         balance -= person[payoutIdx].amount * 7/5;
54                         payoutIdx += 1;
55                 }
56         }
57 
58 
59         function setOwner(address _owner) onlyowner {
60                 owner = _owner;
61         }
62 }