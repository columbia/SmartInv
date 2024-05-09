1 pragma solidity ^0.4.23;
2 /*
3 
4 LIGO CrowdSale - Wave 1
5 
6 */
7 
8 // interface to represent the LIGO token contract, so we can call functions on it
9 interface ligoToken {
10     function transfer(address receiver, uint amount) external;
11     function balanceOf(address holder) external returns(uint); 
12 }
13 
14 contract Crowdsale {
15 	// Public visible variables
16     address public beneficiary;
17     uint public fundingGoal;
18     uint public startTime;
19     uint public deadline;
20     ligoToken public tokenReward;
21     uint public amountRaised;
22     uint public buyerCount = 0;
23     bool public fundingGoalReached = false;
24 	uint public withdrawlDeadline;
25     // bool public hasStarted = false; // not needed, automatically start wave 1 when deployed
26 	// public array of buyers
27     mapping(address => uint256) public balanceOf;
28     mapping(address => uint256) public fundedAmount;
29     mapping(uint => address) public buyers;
30 	// private variables
31     bool crowdsaleClosed = false;
32 	// crowdsale settings
33 	uint constant minContribution  = 20000000000000000; // 0.02 ETH
34 	uint constant maxContribution = 100 ether; 
35 	uint constant fundsOnHoldAfterDeadline = 30 days; //Escrow period
36 
37     event GoalReached(address recipient, uint totalAmountRaised);
38     event FundTransfer(address backer, uint amount, bool isContribution);
39 
40     /**
41      * Constructor function
42      *
43      * Setup the owner
44      */
45     constructor(
46         address ifSuccessfulSendTo,
47         uint fundingGoalInEthers,
48         uint startUnixTime,
49         uint durationInMinutes,
50         address addressOfTokenUsedAsReward
51     ) public {
52         beneficiary = ifSuccessfulSendTo;
53         fundingGoal = fundingGoalInEthers * 1 ether;
54         startTime = startUnixTime;
55         deadline = startTime + durationInMinutes * 1 minutes;
56 		withdrawlDeadline = deadline + fundsOnHoldAfterDeadline;
57         tokenReward = ligoToken(addressOfTokenUsedAsReward);
58     }
59 
60     /**
61      * Fallback function
62      *
63      * The function without name is the default function that is called whenever anyone sends funds to a contract
64      */
65     function () public payable {
66         require(!crowdsaleClosed);
67         require(!(now <= startTime));
68 		require(!(amountRaised >= fundingGoal)); // stop accepting payments when the goal is reached.
69 
70 		// get the total for this contributor so far
71         uint totalContribution = balanceOf[msg.sender];
72 		// if total > 0, this user already contributed
73 		bool exstingContributor = totalContribution > 0;
74 
75         uint amount = msg.value;
76         bool moreThanMinAmount = amount >= minContribution; //> 0.02 Ether
77         bool lessThanMaxTotalContribution = amount + totalContribution <= maxContribution; // < 100 Ether total, including this amount
78 
79         require(moreThanMinAmount);
80         require(lessThanMaxTotalContribution);
81 
82         if (lessThanMaxTotalContribution && moreThanMinAmount) {
83             // Add to buyer's balance
84             balanceOf[msg.sender] += amount;
85             // Add to tracking array
86             fundedAmount[msg.sender] += amount;
87             emit FundTransfer(msg.sender, amount, true);
88 			if (!exstingContributor) {
89 				// this is a new contributor, add to the count and the buyers array
90 				buyers[buyerCount] = msg.sender;
91 				buyerCount += 1;
92 			}
93             amountRaised += amount;
94 		}
95     }
96 
97     modifier afterDeadline() { if (now >= deadline) _; }
98     modifier afterWithdrawalDeadline() { if (now >= withdrawlDeadline) _; }
99 
100     /**
101      * Check if goal was reached
102      *
103      * Checks if the goal or time limit has been reached and ends the campaign
104      */
105     function checkGoalReached() public afterDeadline {
106 		if (beneficiary == msg.sender) {
107 			if (amountRaised >= fundingGoal){
108 				fundingGoalReached = true;
109 				emit GoalReached(beneficiary, amountRaised);
110 			}
111 			crowdsaleClosed = true;
112 		}
113     }
114 
115     /**
116      * returns contract's LIGO balance
117      */
118     function getContractTokenBalance() public constant returns (uint) {
119         return tokenReward.balanceOf(address(this));
120     }
121     
122     /**
123      * Withdraw the funds
124      *
125      * Checks to see if time limit has been reached, and if so, 
126      * sends the entire amount to the beneficiary, and send LIGO to buyers. 
127      */
128     function safeWithdrawal() public afterWithdrawalDeadline {
129 		
130 		// Only the beneficiery can withdraw from Wave 1
131 		if (beneficiary == msg.sender) {
132 
133 			// first send all the ETH to beneficiary
134             if (beneficiary.send(amountRaised)) {
135                 emit FundTransfer(beneficiary, amountRaised, false);
136             }
137 
138 			// Read amount of total LIGO in this contract
139 			uint totalTokens = tokenReward.balanceOf(address(this));
140 			uint remainingTokens = totalTokens;
141 
142 			// send the LIGO to each buyer
143 			for (uint i=0; i<buyerCount; i++) {
144 				address buyerId = buyers[i];
145 				uint amount = ((balanceOf[buyerId] * 500) * 125) / 100; //Modifier is 100->125% so divide by 100.
146 				// Make sure there are enough remaining tokens in the contract before trying to send
147 				if (remainingTokens >= amount) {
148 					tokenReward.transfer(buyerId, amount); 
149 					// subtract from the total
150 					remainingTokens -= amount;
151 					// clear out buyer's balance
152 					balanceOf[buyerId] = 0;
153 				}
154 			}
155 
156 			// send unsold tokens back to contract init wallet
157 			if (remainingTokens > 0) {
158 				tokenReward.transfer(beneficiary, remainingTokens);
159 			}
160         }
161     }
162 }