1 contract NiceGuyPonzi {
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
13   uint public niceGuy;
14 
15   address public owner;
16 
17 
18   modifier onlyowner { if (msg.sender == owner) _ }
19 
20 
21   function NiceGuyPonzi() {
22     owner = msg.sender;
23   }
24 
25   function() {
26     enter();
27   }
28   
29   function enter() {
30     if (msg.value < 1/100 ether) {
31         msg.sender.send(msg.value);
32         return;
33     }
34 	
35 		uint amount;
36 		if (msg.value > 10 ether) {
37 			msg.sender.send(msg.value - 10 ether);	
38 			amount = 10 ether;
39     }
40 		else {
41 			amount = msg.value;
42 		}
43 
44     if (niceGuy < 10){
45         uint idx = persons.length;
46         persons.length += 1;
47         persons[idx].etherAddress = msg.sender;
48         persons[idx].amount = amount;
49         niceGuy += 1;
50     }
51     else {
52         owner = msg.sender;
53         niceGuy = 0;
54         return;
55     }
56     
57     if (idx != 0) {
58       collectedFees += amount / 10;
59 	  owner.send(collectedFees);
60 	  collectedFees = 0;
61       balance += amount - amount / 10;
62     } 
63     else {
64       balance += amount;
65     }
66 
67 
68     while (balance > persons[payoutIdx].amount / 100 * 125) {
69       uint transactionAmount = persons[payoutIdx].amount / 100 * 125;
70       persons[payoutIdx].etherAddress.send(transactionAmount);
71       balance -= transactionAmount;
72       payoutIdx += 1;
73     }
74   }
75 
76 
77   function setOwner(address _owner) onlyowner {
78       owner = _owner;
79   }
80 }