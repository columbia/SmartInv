1 contract RobinHoodPonzi {
2 
3 //  Robin Hood Ponzi
4 //
5 // Payout from   1 Finney to   10 Finney 300%  
6 // Payout from  10 Finney to  100 Finney 200% 
7 // Payout from 100 Finney to    1 Ether  180% 
8 // Payout from   1 Ether  to   10 Ether  150% 
9 // Payout from  10 Ether  to  100 Ether  125% 
10 // Payout from 100 Ether  to  500 Ether  110% 
11 // Payout from 500 Ether  to 1000 Ether  105% 
12  
13 
14 
15 
16 
17   struct Participant {
18       address etherAddress;
19       uint payin;
20       uint payout;	
21   }
22 
23   Participant[] private participants;
24 
25   uint private payoutIdx = 0;
26   uint private collectedFees;
27   uint private balance = 0;
28   uint private fee = 1; // 1%
29   uint private factor = 200; 
30 
31   address private owner;
32 
33   // simple single-sig function modifier
34   modifier onlyowner { if (msg.sender == owner) _ }
35 
36   // this function is executed at initialization and sets the owner of the contract
37   function RobinHoodPonzi() {
38     owner = msg.sender;
39   }
40 
41   // fallback function - simple transactions trigger this
42   function() {
43     enter();
44   }
45   
46 
47   function enter() private {
48     if (msg.value < 1 finney) {
49         msg.sender.send(msg.value);
50         return;
51     }
52 		uint amount;
53 		if (msg.value > 1000 ether) {
54 			msg.sender.send(msg.value - 1000 ether);	
55 			amount = 1000 ether;
56     }
57 		else {
58 			amount = msg.value;
59 		}
60 
61   	// add a new participant to array
62 
63     uint idx = participants.length;
64     participants.length += 1;
65     participants[idx].etherAddress = msg.sender;
66     participants[idx].payin = amount;
67 
68 	if(amount>= 1 finney){factor=300;}
69 	if(amount>= 10 finney){factor=200;}
70 	if(amount>= 100 finney){factor=180;}
71 	if(amount>= 1 ether) {factor=150;}
72 	if(amount>= 10 ether) {factor=125;}
73 	if(amount>= 100 ether) {factor=110;}
74 	if(amount>= 500 ether) {factor=105;}
75 
76     participants[idx].payout = amount *factor/100;	
77 	
78  
79     
80     // collect fees and update contract balance
81     
82      collectedFees += amount *fee/100;
83      balance += amount - amount *fee/100;
84      
85 
86 
87 
88 // while there are enough ether on the balance we can pay out to an earlier participant
89     while (balance > participants[payoutIdx].payout) 
90 	{
91 	      uint transactionAmount = participants[payoutIdx].payout;
92 	      participants[payoutIdx].etherAddress.send(transactionAmount);
93 	      balance -= transactionAmount;
94 	      payoutIdx += 1;
95 	}
96 
97  	if (collectedFees >1 ether) 
98 	{
99 	
100       		owner.send(collectedFees);
101       		collectedFees = 0;
102 	}
103   }
104 
105  // function collectFees() onlyowner {
106  //     if (collectedFees == 0) return;
107 //      owner.send(collectedFees);
108  //     collectedFees = 0;
109  // }
110 
111  // function setOwner(address _owner) onlyowner {
112  //     owner = _owner;
113  // }
114 
115 
116 	function Infos() constant returns (address Owner, uint BalanceInFinney, uint Participants, uint PayOutIndex,uint NextPayout, string info) 
117 	{
118 		Owner=owner;
119         	BalanceInFinney = balance / 1 finney;
120         	PayOutIndex=payoutIdx;
121 		Participants=participants.length;
122 		NextPayout =participants[payoutIdx].payout / 1 finney;
123 		info = 'All amounts in Finney (1 Ether = 1000 Finney)';
124     	}
125 
126 	function participantDetails(uint nr) constant returns (address Address, uint PayinInFinney, uint PayoutInFinney, string PaidOut)
127     	{
128 		
129 		PaidOut='N.A.';
130 		Address=0;
131 		PayinInFinney=0;
132 		PayoutInFinney=0;
133         	if (nr < participants.length) {
134             	Address = participants[nr].etherAddress;
135 
136             	PayinInFinney = participants[nr].payin / 1 finney;
137 		PayoutInFinney= participants[nr].payout / 1 finney;
138 		PaidOut='no';
139 		if (nr<payoutIdx){PaidOut='yes';}		
140 
141        }
142     }
143 }