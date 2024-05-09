1 pragma solidity ^0.4.11;
2 
3 contract BLOCKCHAIN_DEPOSIT_BETA {
4 	
5 	/* CONTRACT SETUP */
6 
7 	uint constant PAYOUT_INTERVAL = 1 days;
8 
9 	/* NB: Solidity doesn't support fixed or floats yet, so we use promille instead of percent */	
10 	uint constant DEPONENT_INTEREST= 10;
11 	uint constant INTEREST_DENOMINATOR = 1000;
12 
13 	/* DATA TYPES */
14 
15 	/* the payout happend */
16 	event Payout(uint paidPeriods, uint depositors);
17 	
18 	/* Depositor struct: describes a single Depositor */
19 	struct Depositor
20 	{	
21 		address etherAddress;
22 		uint deposit;
23 		uint depositTime;
24 	}
25 
26 	/* FUNCTION MODIFIERS */
27 	modifier founderOnly { if (msg.sender == contract_founder) _; }
28 
29 	/* VARIABLE DECLARATIONS */
30 
31 	/* the contract founder*/
32 	address private contract_founder;
33 
34 	/* the time of last payout */
35 	uint private contract_latestPayoutTime;
36 
37 	/* Array of depositors */
38 	Depositor[] private contract_depositors;
39 
40 	
41 	/* PUBLIC FUNCTIONS */
42 
43 	/* contract constructor */
44 	function BLOCKCHAIN_DEPOSIT_BETA() 
45 	{
46 		contract_founder = msg.sender;
47 		contract_latestPayoutTime = now;		
48 	}
49 
50 	/* fallback function: called when the contract received plain ether */
51 	function() payable
52 	{
53 		addDepositor();
54 	}
55 
56 	function Make_Deposit() payable
57 	{
58 		addDepositor();	
59 	}
60 
61 	function status() constant returns (uint deposit_fond_sum, uint depositorsCount, uint unpaidTime, uint unpaidIntervals)
62 	{
63 		deposit_fond_sum = this.balance;
64 		depositorsCount = contract_depositors.length;
65 		unpaidTime = now - contract_latestPayoutTime;
66 		unpaidIntervals = unpaidTime / PAYOUT_INTERVAL;
67 	}
68 
69 
70 	/* checks if it's time to make payouts. if so, send the ether */
71 	function performPayouts()
72 	{
73 		uint paidPeriods = 0;
74 		uint depositorsDepositPayout;
75 
76 		while(contract_latestPayoutTime + PAYOUT_INTERVAL < now)
77 		{						
78 			uint idx;
79 
80 			/* pay the depositors  */
81 			/* we use reverse iteration here */
82 			for (idx = contract_depositors.length; idx-- > 0; )
83 			{
84 				if(contract_depositors[idx].depositTime > contract_latestPayoutTime + PAYOUT_INTERVAL)
85 					continue;
86 				uint payout = (contract_depositors[idx].deposit * DEPONENT_INTEREST) / INTEREST_DENOMINATOR;
87 				if(!contract_depositors[idx].etherAddress.send(payout))
88 					throw;
89 				depositorsDepositPayout += payout;	
90 			}
91 			
92 			/* save the latest paid time */
93 			contract_latestPayoutTime += PAYOUT_INTERVAL;
94 			paidPeriods++;
95 		}
96 			
97 		/* emit the Payout event */
98 		Payout(paidPeriods, depositorsDepositPayout);
99 	}
100 
101 	/* PRIVATE FUNCTIONS */
102 	function addDepositor() private 
103 	{
104 		contract_depositors.push(Depositor(msg.sender, msg.value, now));
105 	}
106 
107 	/* ADMIN FUNCTIONS */
108 
109 	/* pass the admin rights to another address */
110 	function changeFounderAddress(address newFounder) founderOnly 
111 	{
112 		contract_founder = newFounder;
113 	}
114 }