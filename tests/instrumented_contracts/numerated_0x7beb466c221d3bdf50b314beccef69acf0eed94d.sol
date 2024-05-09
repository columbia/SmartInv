1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public amountRaised;
11     uint public deadline;
12     uint public price;
13     token public tokenReward;
14     mapping(address => uint256) public balanceOf;
15     bool fundingGoalReached = false;
16     bool crowdsaleClosed = false;
17     // Release progress
18     uint public percent;
19     mapping(address => uint256) public percentOf;
20 
21     event GoalReached(address recipient, uint totalAmountRaised);
22     event FundTransfer(address backer, uint amount, bool isContribution);
23     event RewardToken(address backer, uint amount, uint percent);
24 
25     /**
26      * Constructor function
27      *
28      * Setup the owner
29      */
30     function Crowdsale(
31         address ifSuccessfulSendTo,
32         uint fundingGoalInEthers,
33         uint durationInMinutes,
34         uint weiCostOfEachToken,
35         address addressOfTokenUsedAsReward,
36         uint initPercent
37     ) {
38         beneficiary = ifSuccessfulSendTo;
39         fundingGoal = fundingGoalInEthers * 1 ether;
40         deadline = now + durationInMinutes * 1 minutes;
41         price = weiCostOfEachToken * 1 wei;
42         tokenReward = token(addressOfTokenUsedAsReward);
43         percent = initPercent;
44     }
45 
46     /**
47      * Fallback function
48      *
49      * The function without name is the default function that is called whenever anyone sends funds to a contract
50      */
51     function () payable {
52         if (crowdsaleClosed) {
53             uint amount2 = balanceOf[msg.sender];
54             uint rewardPercent = percent - percentOf[msg.sender];
55             require(amount2 > 0 && rewardPercent > 0);
56             percentOf[msg.sender] = percent;
57             // Release percent of reward token
58             uint rewardAmount2 = amount2 * 10**18 * rewardPercent / price / 100;
59             tokenReward.transfer(msg.sender, rewardAmount2);
60             RewardToken(msg.sender, rewardAmount2, rewardPercent);
61         } else {
62             uint amount = msg.value;
63             balanceOf[msg.sender] += amount;
64             amountRaised += amount;
65             percentOf[msg.sender] = percent;
66             // Release init percent of reward token
67             uint rewardAmount = amount * 10**18 * percent / price / 100;
68             tokenReward.transfer(msg.sender, rewardAmount);
69             FundTransfer(msg.sender, amount, true);
70             RewardToken(msg.sender, rewardAmount, percent);
71         }
72     }
73 
74     modifier afterDeadline() { if (now >= deadline) _; }
75 
76     /**
77      * Check if goal was reached
78      *
79      * Checks if the goal or time limit has been reached and ends the campaign
80      */
81     function checkGoalReached() afterDeadline {
82         if (amountRaised >= fundingGoal){
83             fundingGoalReached = true;
84             GoalReached(beneficiary, amountRaised);
85         }
86         crowdsaleClosed = true;
87     }
88 
89 
90     /**
91      * Withdraw the funds
92      *
93      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
94      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
95      * the amount they contributed.
96      */
97     function safeWithdrawal() afterDeadline {
98         require(crowdsaleClosed);
99 
100         if (!fundingGoalReached) {
101             uint amount = balanceOf[msg.sender];
102             balanceOf[msg.sender] = 0;
103             if (amount > 0) {
104                 if (msg.sender.send(amount)) {
105                     FundTransfer(msg.sender, amount, false);
106                 } else {
107                     balanceOf[msg.sender] = amount;
108                 }
109             }
110         }
111 
112         if (fundingGoalReached && beneficiary == msg.sender) {
113             if (beneficiary.send(amountRaised)) {
114                 FundTransfer(beneficiary, amountRaised, false);
115             } else {
116                 //If we fail to send the funds to beneficiary, unlock funders balance
117                 fundingGoalReached = false;
118             }
119         }
120     }
121     
122     /**
123      * Release 10% of reward token
124      *
125      * Release 10% of reward token when beneficiary call this function.
126      */
127     function releaseTenPercent() afterDeadline {
128         require(crowdsaleClosed);
129 
130         require(percent <= 90);
131         if (fundingGoalReached && beneficiary == msg.sender) {
132             percent += 10;
133         }
134     }
135 }