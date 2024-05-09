1 contract NanoPyramid {
2     
3     uint private pyramidMultiplier = 140;
4     uint private minAmount = 1 finney;
5     uint private maxAmount = 1 ether;
6     uint private fee = 2;
7     uint private collectedFees = 0;
8     uint private minFeePayout = 100 finney;
9     
10     address private owner;
11     
12     
13     function NanoPyramid() {
14         owner = msg.sender;
15     }
16     
17     modifier onlyowner { if (msg.sender == owner) _ }
18     
19     
20     struct Participant {
21         address etherAddress;
22         uint payout;
23     }
24     
25     Participant[] public participants;
26     
27     
28     uint public payoutOrder = 0;
29     uint public balance = 0;
30     
31     
32     function() {
33         enter();
34     }
35     
36     function enter() {
37         // Check if amount is too small
38         if (msg.value < minAmount) {
39             // Amount is too small, no need to think about refund
40             collectedFees += msg.value;
41             return;
42         }
43         
44         // Check if amount is too high
45         uint amount;
46         if (msg.value > maxAmount) {
47             uint amountToRefund =  msg.value - maxAmount;
48             if (amountToRefund >= minAmount) {
49             	if (!msg.sender.send(amountToRefund)) {
50             	    throw;
51             	}
52         	}
53             amount = maxAmount;
54         }
55         else {
56         	amount = msg.value;
57         }
58         
59         //Adds new address to the participant array
60         participants.push(Participant(
61             msg.sender, 
62             amount * pyramidMultiplier / 100
63         ));
64             
65         // Update fees and contract balance
66         balance += (amount * (100 - fee)) / 100;
67         collectedFees += (amount * fee) / 100;
68         
69         //Pays earlier participiants if balance sufficient
70         while (balance > participants[payoutOrder].payout) {
71             uint payoutToSend = participants[payoutOrder].payout;
72             participants[payoutOrder].etherAddress.send(payoutToSend);
73             balance -= payoutToSend;
74             payoutOrder += 1;
75         }
76         
77         // Collect fees
78         if (collectedFees >= minFeePayout) {
79             if (!owner.send(collectedFees)) {
80                 // Potentially sending money to a contract that
81                 // has a fallback function.  So instead, try
82                 // tranferring the funds with the call api.
83                 if (owner.call.gas(msg.gas).value(collectedFees)()) {
84                     collectedFees = 0;
85                 }
86             } else {
87                 collectedFees = 0;
88             }
89         }
90     }
91     
92     
93     function totalParticipants() constant returns (uint count) {
94         count = participants.length;
95     }
96 
97     function awaitingParticipants() constant returns (uint count) {
98         count = participants.length - payoutOrder;
99     }
100 
101     function outstandingBalance() constant returns (uint amount) {
102         uint payout = 0;
103         uint idx;
104         for (idx = payoutOrder; idx < participants.length; idx++) {
105             payout += participants[idx].payout;
106         }
107         amount = payout - balance;
108     }
109 
110 
111     function setOwner(address _owner) onlyowner {
112         owner = _owner;
113     }
114 }