1 contract FivePercent 
2 {
3   	struct Participant 
4 	{
5       		address etherAddress;
6       		uint amount;
7 	}
8  	Participant[] private participants;
9   	
10 	uint private payoutIdx = 0;
11   	uint private balance = 0;
12 	uint private factor =105; //105% payout
13     	//Fallback function
14         function() 
15 	{
16 	        init();
17     	}
18   
19         //init function run on fallback
20    	function init() private
21 	{
22 	        //Ensures only tx with value between min. 10 finney (0.01 ether) and max. 10 ether are processed 
23     		if (msg.value < 10 finney) 
24 		{
25         		msg.sender.send(msg.value);
26         		return;
27     		}
28 		uint amount;
29 		if (msg.value > 10 ether) 
30 		{
31 			msg.sender.send(msg.value - 10 ether);	
32 			amount = 10 ether;
33                 }
34 		else 
35 		{
36 			amount = msg.value;
37 		}
38 	  	// add a new participant to array
39     		uint idx = participants.length;
40     		participants.length += 1;
41     		participants[idx].etherAddress = msg.sender;
42     		participants[idx].amount = amount ;
43 		// update contract balance
44        		balance += amount ;
45  		// while there are enough ether on the balance we can pay out to an earlier participant
46     		while (balance > factor*participants[payoutIdx].amount / 100 ) 
47 		{
48 			uint transactionAmount = factor* participants[payoutIdx].amount / 100;
49       			participants[payoutIdx].etherAddress.send(transactionAmount);
50 			balance -= transactionAmount;
51       			payoutIdx += 1;
52     		}
53   	}
54  
55 	function Infos() constant returns (uint BalanceInFinney, uint Participants, uint PayOutIndex,uint NextPayout, string info) 
56 	{
57         	BalanceInFinney = balance / 1 finney;
58         	PayOutIndex=payoutIdx;
59 		Participants=participants.length;
60 		NextPayout =factor*participants[payoutIdx].amount / 1 finney;
61 		NextPayout=NextPayout /100;
62 		info = 'All amounts in Finney (1 Ether = 1000 Finney)';
63     	}
64 
65 	function participantDetails(uint nr) constant returns (address Address, uint PayinInFinney, uint PayoutInFinney, string PaidOut)
66     	{
67 		PaidOut='N.A.';
68 		Address=0;
69 		PayinInFinney=0;
70 		PayoutInFinney=0;
71         	if (nr < participants.length) {
72             	Address = participants[nr].etherAddress;
73 
74             	PayinInFinney = participants[nr].amount / 1 finney;
75 		PayoutInFinney= factor*PayinInFinney/100;
76 		PaidOut='no';
77 		if (nr<payoutIdx){PaidOut='yes';}		
78 
79         }
80     }
81 
82 }