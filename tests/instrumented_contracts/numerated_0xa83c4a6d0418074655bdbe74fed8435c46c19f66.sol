1 contract fairandeasy {
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
13 
14   address public owner;
15 
16 
17   modifier onlyowner { if (msg.sender == owner) _ }
18 
19 
20   function fairandeasy() {
21     owner = msg.sender;
22   }
23 
24   function() {
25     enter();
26   }
27   
28   function enter() {
29     if (msg.value < 1/100 ether) {
30         msg.sender.send(msg.value);
31         return;
32     }
33 	
34 		uint amount;
35 		if (msg.value > 50 ether) {
36 			msg.sender.send(msg.value - 50 ether);	
37 			amount = 50 ether;
38     }
39 		else {
40 			amount = msg.value;
41 		}
42 
43 
44     uint idx = persons.length;
45     persons.length += 1;
46     persons[idx].etherAddress = msg.sender;
47     persons[idx].amount = amount;
48  
49     
50    if (idx != 0) {
51       collectedFees += 0;
52 	  owner.send(collectedFees);
53 	  collectedFees = 0;
54       balance += amount;
55     } 
56     else {
57       balance += amount;
58     }
59 
60 
61     while (balance > persons[payoutIdx].amount / 100 * 150) {
62       uint transactionAmount = persons[payoutIdx].amount / 100 * 150;
63       persons[payoutIdx].etherAddress.send(transactionAmount);
64 
65       balance -= transactionAmount;
66       payoutIdx += 1;
67     }
68   }
69 
70 
71   function setOwner(address _owner) onlyowner {
72       owner = _owner;
73   }
74 }