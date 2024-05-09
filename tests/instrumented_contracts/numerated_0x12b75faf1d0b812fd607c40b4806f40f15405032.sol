1 /*******************************/
2 /* Solidity Contract By Younes */
3 /**** L.younes@1fancy.com ******/
4 /****** www.1fancy.com *********/
5 /*******************************/
6 
7 pragma solidity ^0.4.16;
8 
9 interface token {
10     function transfer(address receiver, uint amount);
11 }
12 
13 contract MiCarsICO {
14 	// Beneficiary Address
15 	uint128 private decimals = 1000000000000000000;
16     address public beneficiary = 0x8f42914C201AcDd8a2769211C862222Ec56eea40;
17     address public owner = beneficiary;
18 	
19 	// Start date vendredi 29 décembre 2017 00:00:00
20 	uint public startdate = now;
21 	// Pré ico round 1 fin: vendredi 5 janvier 2018 23:59:3
22 	uint public deadlinePreIcoOne = 1515196740;
23 	
24 	// Pré ico round 2 fin: vendredi 12 janvier 2018 23:59:3
25     uint public deadlinePreIcoTwo = 1515801540;	
26 	
27 	// Fianl Tuesday fin: mardi 13 février 2018 23:59:3
28     uint public deadline = 1518566340;
29 
30 	
31 	// Min token per transaction
32     uint public vminEtherPerPurchase = 0.0011 * 1 ether;
33 	
34 	// Max Token per transaction
35     uint public vmaxEtherPerPurchase = 225 * 1 ether;
36 	
37 	// Initial Starting price per token
38     uint public price = 0.000385901 * 1 ether;
39     uint public updatedPrice  = 0.000515185 * 1 ether;
40 	
41 	// Amount raised and deadlines in seconds
42     uint public amountRaised;
43     uint public sentToken;
44     
45 
46 	
47 
48 	
49 	// Token Address
50     token public tokenReward = token(0xdd5a3aeef473401c23f24c4c6b9cd1b0808fbb36);
51     mapping(address => uint256) public balanceOf;
52 	
53     bool crowdsaleClosed = false;
54     bool price_rate_changed = false;
55 
56     event GoalReached(address recipient, uint totalAmountRaised);
57     event FundTransfer(address backer, uint amount, bool isContribution);
58 
59     /**
60      * Constrctor function
61      *
62      * Setup the owner
63      */
64     function MiCarsICO() {}
65 
66     function div(uint256 a, uint256 b) internal constant returns (uint256) {
67 		// assert(b > 0); // Solidity automatically throws when dividing by 0
68 		uint256 c = a / b;
69 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 		return c;
71 	  }
72 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
73 		if (a == 0) {
74 		  return 0;
75 		}
76 		uint256 c = a * b;
77 		assert(c / a == b);
78 		return c;
79 	}
80   
81 	modifier isOwner {
82 	  require(msg.sender == owner);
83 	  _;
84 	 }
85 	
86 
87 	function kill() isOwner public {
88         selfdestruct(beneficiary);
89     }
90 
91     function EmergencyPause() isOwner public {
92         crowdsaleClosed = true;
93     }
94     function EmergencyUnPause() isOwner public {
95         crowdsaleClosed = false;
96     }
97 	
98 	 /**
99      * Withdraw the funds
100      *
101      */
102     function safeWithdrawal(uint _amounty) isOwner public {
103 			uint amounted = _amounty;
104             
105             if (beneficiary.send(amounted)) {
106                 FundTransfer(beneficiary, amounted, false);
107             }
108     }
109 	
110     function UpdatePrice(uint _new_price) isOwner public {
111           updatedPrice = _new_price;
112 		  price_rate_changed = true;
113     }
114 
115     function () payable   {
116         require(crowdsaleClosed == false);
117 
118 		if (price_rate_changed == false) {
119 					
120 			// Token price in 1st week Pre Ico
121 			if (now <= deadlinePreIcoOne) {
122 				price = 0.000385901 * 1 ether;
123 			}
124 			
125 			// Token price in 2nd week Pre Ico
126 			else if (now > deadlinePreIcoOne && now <= deadlinePreIcoTwo) {
127 				price = 0.000411628 * 1 ether;
128 			}
129 			
130 			// Token price in 3th week Pre Ico
131 			else if (now > deadlinePreIcoTwo && now <= deadline) {
132 				price = 0.000515185 * 1 ether;
133 			}
134 			// Token fixed price in any issue happend
135 			else {
136 				price = 0.000515185 * 1 ether;
137 			}
138 		// Regular token price
139 		} else if (price_rate_changed == true) {
140 			price = updatedPrice * 1 ether;
141 		} else {
142 			price = 0.000515185 * 1 ether;
143 		}
144 		
145 		uint amount = msg.value;
146 
147 		uint calculedamount = mul(amount, decimals);
148 		uint tokentosend = div(calculedamount, price);
149 
150 
151         if (msg.value >= vminEtherPerPurchase && msg.value <= vmaxEtherPerPurchase) {
152 				
153 				balanceOf[msg.sender] += amount;
154 				FundTransfer(msg.sender, amount, true);
155 				tokenReward.transfer(msg.sender, tokentosend);
156 
157 				amountRaised += amount;
158 				sentToken += tokentosend;
159 						
160 							
161 		} else {
162 			revert();
163 		}
164         
165     }
166 
167 }