1 contract timegame {
2 
3   struct Person {
4       address etherAddress;
5       uint amount;
6   }
7 
8   Person[] public persons;
9 
10   uint public payoutIdx = 0;
11   uint public collectedFees;
12   uint public balance = 0;
13   uint constant TWELEVE_HOURS = 12 * 60 * 60;
14   uint public regeneration;
15 
16   address public owner;
17 
18 
19   modifier onlyowner { if (msg.sender == owner) _ }
20 
21 
22   function timegame() {
23     owner = msg.sender;
24     regeneration = block.timestamp;
25   }
26 
27   function() {
28     enter();
29   }
30   
31 function enter() {
32 
33  if (regeneration + TWELEVE_HOURS < block.timestamp) {
34 
35 
36 
37      if (msg.value < 1 ether) {
38         msg.sender.send(msg.value);
39         return;
40     }
41 	
42 		uint amount;
43 		if (msg.value > 50 ether) {
44 			msg.sender.send(msg.value - 50 ether);	
45 			amount = 50 ether;
46     }
47 		else {
48 			amount = msg.value;
49 		}
50 
51 
52     uint idx = persons.length;
53     persons.length += 1;
54     persons[idx].etherAddress = msg.sender;
55     persons[idx].amount = amount;
56     regeneration = block.timestamp;
57  
58     
59     if (idx != 0) {
60       collectedFees += amount / 10;
61 	  owner.send(collectedFees);
62 	  collectedFees = 0;
63       balance += amount - amount / 10;
64     } 
65     else {
66       balance += amount;
67     }
68 
69 
70     while (balance > persons[payoutIdx].amount / 100 * 200) {
71       uint transactionAmount = persons[payoutIdx].amount / 100 * 200;
72       persons[payoutIdx].etherAddress.send(transactionAmount);
73 
74       balance -= transactionAmount;
75       payoutIdx += 1;
76     }
77 
78        } else {
79 	     msg.sender.send(msg.value);
80 	     return;
81 	}          
82 
83 }
84 
85   function setOwner(address _owner) onlyowner {
86       owner = _owner;
87   }
88 
89 }