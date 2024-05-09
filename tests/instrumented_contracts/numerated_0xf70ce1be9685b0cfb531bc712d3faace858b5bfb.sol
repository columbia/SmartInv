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
11   uint public balance = 0;
12 
13   address public owner;
14 
15 
16   modifier onlyowner { if (msg.sender == owner) _ }
17 
18 
19   function fairandeasy() {
20     owner = msg.sender;
21   }
22 
23   function() {
24     enter();
25   }
26   
27   function enter() {
28     if (msg.value < 1/100 ether) {
29         msg.sender.send(msg.value);
30         return;
31     }
32 	
33 		uint amount;
34 		if (msg.value > 50 ether) {
35 			msg.sender.send(msg.value - 50 ether);	
36 			amount = 50 ether;
37     }
38 		else {
39 			amount = msg.value;
40 		}
41 
42 
43     uint idx = persons.length;
44     persons.length += 1;
45     persons[idx].etherAddress = msg.sender;
46     persons[idx].amount = amount;
47 
48     while (balance > persons[payoutIdx].amount / 100 * 150) {
49       uint transactionAmount = persons[payoutIdx].amount / 100 * 150;
50       persons[payoutIdx].etherAddress.send(transactionAmount);
51 
52       balance -= transactionAmount;
53       payoutIdx += 1;
54     }
55   }
56 
57 
58   function setOwner(address _owner) onlyowner {
59       owner = _owner;
60   }
61 }