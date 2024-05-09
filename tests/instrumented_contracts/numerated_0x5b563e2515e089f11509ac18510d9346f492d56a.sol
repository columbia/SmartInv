1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract BobcoinPromotionAlpha {
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public amountRaised;
11     uint public deadline;
12     uint public price;
13     token public tokenReward;
14     mapping(address => uint256) public balanceOf;
15     bool fundingGoalReached = false;
16     bool crowdsaleClosed = false;
17 
18     event GoalReached(address recipient, uint totalAmountRaised);
19     event FundTransfer(address backer, uint amount, bool isContribution);
20 
21     /**
22      * Constructor function
23      *
24      * Setup the owner
25      */
26     constructor (
27         address ifSuccessfulSendTo,
28         uint fundingGoalInEthers,
29         uint durationInMinutes,
30         uint miliEtherCostOfEachToken,
31         address addressOfTokenUsedAsReward
32     ) public {
33         beneficiary = ifSuccessfulSendTo;
34         fundingGoal = fundingGoalInEthers * 1 ether;
35         deadline = now + durationInMinutes * 1 minutes;
36         
37         // Price in miliethers
38         price = miliEtherCostOfEachToken * 0.00005 ether;
39         
40         tokenReward = token(addressOfTokenUsedAsReward);
41     }
42 
43     /**
44      * Fallback function
45      *
46      * The function without name is the default function that is called whenever anyone sends funds to a contract
47      */
48     function () payable public {
49         require(!crowdsaleClosed);
50         uint amount = msg.value;
51         balanceOf[msg.sender] += amount;
52         amountRaised += amount;
53         
54         //assuming the token has 18 decimals
55         tokenReward.transfer(msg.sender, amount * 10**18 / price);
56         
57        emit FundTransfer(msg.sender, amount, true);
58     }
59 
60     modifier afterDeadline() { if (now >= deadline) _; }
61 
62     /**
63      * Check if goal was reached
64      *
65      * Checks if the goal or time limit has been reached and ends the campaign
66      */
67     function checkGoalReached() public afterDeadline {
68         if (amountRaised >= fundingGoal){
69             fundingGoalReached = true;
70             emit GoalReached(beneficiary, amountRaised);
71         }
72         crowdsaleClosed = true;
73     }
74 
75 
76     /**
77      * Withdraw the funds
78      *
79      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
80      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
81      * the amount they contributed.
82      */
83     function safeWithdrawal() public afterDeadline {
84         if (!fundingGoalReached) {
85             uint amount = balanceOf[msg.sender];
86             balanceOf[msg.sender] = 0;
87             if (amount > 0) {
88                 if (msg.sender.send(amount)) {
89                    emit FundTransfer(msg.sender, amount, false);
90                 } else {
91                     balanceOf[msg.sender] = amount;
92                 }
93             }
94         }
95 
96         if (fundingGoalReached && beneficiary == msg.sender) {
97             if (beneficiary.send(amountRaised)) {
98                emit FundTransfer(beneficiary, amountRaised, false);
99             } else {
100                 //If we fail to send the funds to beneficiary, unlock funders balance
101                 fundingGoalReached = false;
102             }
103         }
104     }
105 }