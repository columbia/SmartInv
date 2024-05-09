1 contract BigRisk {
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
20   function BigRisk() {
21     owner = msg.sender;
22   }
23 
24   function() {
25     enter();
26   }
27   
28   function enter() {
29   
30   	uint amount;
31 	amount = msg.value;
32 	
33     if (amount % 100 ether != 0  ) {
34 	      msg.sender.send(amount);
35         return;
36 	}
37 
38 	uint idx = persons.length;
39     persons.length += 1;
40     persons[idx].etherAddress = msg.sender;
41     persons[idx].amount = amount;
42  
43     balance += amount;
44   
45     while (balance >= persons[payoutIdx].amount * 2) {
46       uint transactionAmount = persons[payoutIdx].amount * 2;
47       persons[payoutIdx].etherAddress.send(transactionAmount);
48       balance -= transactionAmount;
49       payoutIdx += 1;
50     }
51 
52   }
53 
54 
55   function setOwner(address _owner) onlyowner {
56       owner = _owner;
57   }
58 }