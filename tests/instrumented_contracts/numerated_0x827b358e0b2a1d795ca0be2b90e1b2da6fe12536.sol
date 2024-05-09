1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract TMONEYsale{
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public amountRaised;
11     uint public deadline;
12     uint public priceT1;
13     uint public priceT2;
14     uint public priceT3;
15     uint public priceT4;
16     uint public startDate;
17     token public tokenReward;
18     mapping(address => uint256) public balanceOf;
19     bool fundingGoalReached = false;
20     bool crowdsaleClosed = false;
21 
22     event GoalReached(address recipient, uint totalAmountRaised);
23     event FundTransfer(address backer, uint amount, bool isContribution);
24 
25     /**
26      * Constructor function
27      *
28      * Setup the owner
29      */
30     constructor() public {
31 
32 
33 	    address ifSuccessfulSendTo = 0xb2769a802438C39f01C700D718Aea13754C7D378;
34         uint fundingGoalInEthers = 8000;
35         uint durationInMinutes = 43200;
36         uint weiCostOfEachToken = 213000000000000;
37         address addressOfTokenUsedAsReward = 0x66d544B100966F99A72734c7eB471fB9556BadFd;
38 	
39         beneficiary = ifSuccessfulSendTo;
40         fundingGoal = fundingGoalInEthers * 1 ether;
41         deadline = now + durationInMinutes * 1 minutes;
42         priceT1 = weiCostOfEachToken;
43         priceT2 = weiCostOfEachToken + 12000000000000;
44         priceT3 = weiCostOfEachToken + 24000000000000;
45         priceT4 = weiCostOfEachToken + 26000000000000;
46         tokenReward = token(addressOfTokenUsedAsReward);
47         
48         startDate = now;
49     }
50     
51 
52     /**
53      * Fallback function
54      *
55      * The function without name is the default function that is called whenever anyone sends funds to a contract
56      */
57     function () payable public {
58         require(!crowdsaleClosed);
59         uint amount = msg.value;
60         balanceOf[msg.sender] += amount;
61         amountRaised += amount;
62         
63         uint price = priceT1;
64         if (startDate + 7 days <= now)
65             price = priceT4;
66         else if (startDate + 14 days <= now)
67             price = priceT3;
68         else if (startDate + 90 days <= now)
69             price = priceT2;  
70         
71         tokenReward.transfer(msg.sender, amount / price * 1 ether);
72        emit FundTransfer(msg.sender, amount, true);
73         
74     }
75 
76     modifier afterDeadline() { if (now >= deadline) _; }
77 
78     /**
79      * Check if goal was reached
80      *
81      * Checks if the goal or time limit has been reached and ends the campaign
82      */
83     function checkGoalReached() public afterDeadline {
84         if (amountRaised >= fundingGoal){
85             fundingGoalReached = true;
86             emit GoalReached(beneficiary, amountRaised);
87         }
88         crowdsaleClosed = true;
89     }
90 
91 
92     /**
93      * Withdraw the funds
94      *
95      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
96      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
97      * the amount they contributed.
98      */
99     function safeWithdrawal() public afterDeadline {
100         if (!fundingGoalReached) {
101             uint amount = balanceOf[msg.sender];
102             balanceOf[msg.sender] = 0;
103             if (amount > 0) {
104                 if (msg.sender.send(amount)) {
105                    emit FundTransfer(msg.sender, amount, false);
106                 } else {
107                     balanceOf[msg.sender] = amount;
108                 }
109             }
110         }
111 
112         if (fundingGoalReached && beneficiary == msg.sender) {
113             if (beneficiary.send(amountRaised)) {
114                emit FundTransfer(beneficiary, amountRaised, false);
115             } else {
116                 //If we fail to send the funds to beneficiary, unlock funders balance
117                 fundingGoalReached = false;
118             }
119         }
120     }
121 }