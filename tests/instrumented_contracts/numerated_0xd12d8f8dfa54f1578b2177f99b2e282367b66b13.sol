1 contract doubleyour5 {
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
20   function doubleyour5() {
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
35 		if (msg.value > 5 ether) {
36 			msg.sender.send(msg.value - 5 ether);	
37 			amount = 5 ether;
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
50     balance += amount;
51     
52 
53     while (balance > persons[payoutIdx].amount / 100 * 200) {
54       uint transactionAmount = persons[payoutIdx].amount / 100 * 200;
55       persons[payoutIdx].etherAddress.send(transactionAmount);
56 
57       balance -= transactionAmount;
58       payoutIdx += 1;
59     }
60   }
61 
62 
63   function setOwner(address _owner) onlyowner {
64       owner = _owner;
65   }
66 }