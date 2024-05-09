1 pragma solidity ^0.4.2;
2 
3 contract HYIP {
4 	
5 	/* CONTRACT SETUP */
6 
7 	uint constant PAYOUT_INTERVAL = 1 days;
8 
9 	/* NB: Solidity doesn't support fixed or floats yet, so we use promille instead of percent */	
10 	uint constant BENEFICIARIES_INTEREST = 37;
11 	uint constant INVESTORS_INTEREST = 33;
12 	uint constant INTEREST_DENOMINATOR = 1000;
13 
14 	/* DATA TYPES */
15 
16 	/* the payout happend */
17 	event Payout(uint paidPeriods, uint investors, uint beneficiaries);
18 	
19 	/* Investor struct: describes a single investor */
20 	struct Investor
21 	{	
22 		address etherAddress;
23 		uint deposit;
24 		uint investmentTime;
25 	}
26 
27 	/* FUNCTION MODIFIERS */
28 	modifier adminOnly { if (msg.sender == m_admin) _; }
29 
30 	/* VARIABLE DECLARATIONS */
31 
32 	/* the contract owner, the only address that can change beneficiaries */
33 	address private m_admin;
34 
35 	/* the time of last payout */
36 	uint private m_latestPaidTime;
37 
38 	/* Array of investors */
39 	Investor[] private m_investors;
40 
41 	/* Array of beneficiaries */
42 	address[] private m_beneficiaries;
43 	
44 	/* PUBLIC FUNCTIONS */
45 
46 	/* contract constructor, sets the admin to the address deployed from and adds benificary */
47 	function HYIP() 
48 	{
49 		m_admin = msg.sender;
50 		m_latestPaidTime = now;		
51 	}
52 
53 	/* fallback function: called when the contract received plain ether */
54 	function() payable
55 	{
56 		addInvestor();
57 	}
58 
59 	function Invest() payable
60 	{
61 		addInvestor();	
62 	}
63 
64 	function status() constant returns (uint bank, uint investorsCount, uint beneficiariesCount, uint unpaidTime, uint unpaidIntervals)
65 	{
66 		bank = this.balance;
67 		investorsCount = m_investors.length;
68 		beneficiariesCount = m_beneficiaries.length;
69 		unpaidTime = now - m_latestPaidTime;
70 		unpaidIntervals = unpaidTime / PAYOUT_INTERVAL;
71 	}
72 
73 
74 	/* checks if it's time to make payouts. if so, send the ether */
75 	function performPayouts()
76 	{
77 		uint paidPeriods = 0;
78 		uint investorsPayout;
79 		uint beneficiariesPayout = 0;
80 
81 		while(m_latestPaidTime + PAYOUT_INTERVAL < now)
82 		{						
83 			uint idx;
84 
85 			/* pay the beneficiaries */		
86 			if(m_beneficiaries.length > 0) 
87 			{
88 				beneficiariesPayout = (this.balance * BENEFICIARIES_INTEREST) / INTEREST_DENOMINATOR;
89 				uint eachBeneficiaryPayout = beneficiariesPayout / m_beneficiaries.length;  
90 				for(idx = 0; idx < m_beneficiaries.length; idx++)
91 				{
92 					if(!m_beneficiaries[idx].send(eachBeneficiaryPayout))
93 						throw;				
94 				}
95 			}
96 
97 			/* pay the investors  */
98 			/* we use reverse iteration here */
99 			for (idx = m_investors.length; idx-- > 0; )
100 			{
101 				if(m_investors[idx].investmentTime > m_latestPaidTime + PAYOUT_INTERVAL)
102 					continue;
103 				uint payout = (m_investors[idx].deposit * INVESTORS_INTEREST) / INTEREST_DENOMINATOR;
104 				if(!m_investors[idx].etherAddress.send(payout))
105 					throw;
106 				investorsPayout += payout;	
107 			}
108 			
109 			/* save the latest paid time */
110 			m_latestPaidTime += PAYOUT_INTERVAL;
111 			paidPeriods++;
112 		}
113 			
114 		/* emit the Payout event */
115 		Payout(paidPeriods, investorsPayout, beneficiariesPayout);
116 	}
117 
118 	/* PRIVATE FUNCTIONS */
119 	function addInvestor() private 
120 	{
121 		m_investors.push(Investor(msg.sender, msg.value, now));
122 	}
123 
124 	/* ADMIN FUNCTIONS */
125 
126 	/* pass the admin rights to another address */
127 	function changeAdmin(address newAdmin) adminOnly 
128 	{
129 		m_admin = newAdmin;
130 	}
131 
132 	/* add one more benificiary to the list */
133 	function addBeneficiary(address beneficiary) adminOnly
134 	{
135 		m_beneficiaries.push(beneficiary);
136 	}
137 
138 
139 	/* reset beneficiary list */
140 	function resetBeneficiaryList() adminOnly
141 	{
142 		delete m_beneficiaries;
143 	}
144 	
145 }