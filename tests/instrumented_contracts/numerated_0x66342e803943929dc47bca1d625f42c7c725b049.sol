1 contract etherlist_top {
2 
3   // www.etherlist.top
4   
5   struct Participant {
6       address etherAddress;
7       uint amount;
8 	  uint paid;
9 	  uint lastPayment;
10   }
11 
12   Participant[] public participants;
13 
14   uint public payoutIdx = 0;
15   uint public collectedFees;
16   uint public balance;
17   uint public lastTimestamp = block.timestamp;
18   uint public rand_num = block.timestamp % participants.length;
19 
20   address public owner;
21 
22   modifier onlyowner { if (msg.sender == owner) _ }
23 
24   function etherlist_top() {
25     owner = msg.sender;
26 	balance = 0;
27 	collectedFees = 0;
28   }
29 
30   function() {
31     enter();
32   }
33   
34   function enter() {
35 
36   if(msg.value > 5000000000000000000){
37     msg.sender.send(msg.value);
38     return;
39   }
40 	   collectedFees += msg.value / 20;
41 	   balance += (msg.value - (msg.value / 20));
42 	   lastTimestamp = block.timestamp;
43 	   rand_num = (((lastTimestamp+balance) % participants.length) * block.difficulty + msg.value) % participants.length;
44 	   
45 	   uint i = 0;
46 	   uint i2 = rand_num;
47 	   while(i < participants.length){
48 	     if(balance > 0){
49 		if(participants.length - participants[i2].lastPayment > 3 || participants[i2].lastPayment == 0)
50 		 if(participants[i2].amount >= balance){
51 		   participants[i2].etherAddress.send(balance);
52 		   participants[i2].paid += balance;
53 		   participants[i2].lastPayment = participants.length +1;
54 		   balance = 0;
55 		   }
56 		   else{
57 		   participants[i2].etherAddress.send(participants[i2].amount);
58 		   balance -= participants[i2].amount;  
59 		   participants[i2].paid += participants[i2].amount;
60 		   participants[i2].lastPayment = participants.length +1;
61 		   }
62 		 }
63 		 else
64 		   break;
65 		
66 		 i2 += rand_num + 1;
67 		 if(i2 > participants.length)
68 		    i2 = i2 % participants.length;	   
69 	     i += 1;
70 	   }
71 
72 	   uint idx = participants.length;
73        participants.length += 1;
74        participants[idx].amount = msg.value;
75 	   participants[idx].etherAddress = msg.sender;
76 	   participants[idx].paid = 0;
77 	   participants[idx].lastPayment = 0;
78 	   
79        return;
80   }
81 
82   function collectFees() onlyowner {
83       if (collectedFees == 0) return;
84 
85       owner.send(collectedFees);
86       collectedFees = 0;
87   }
88   
89 
90   function setOwner(address _owner) onlyowner {
91       owner = _owner;
92   }
93 }