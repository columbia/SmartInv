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
17 
18     event GoalReached(address recipient, uint totalAmountRaised);
19     event FundTransfer(address backer, uint amount, bool isContribution);
20 
21     /**
22      * Constructor function
23      *
24      * Setup the owner
25      */
26     function Crowdsale(
27         address ifSuccessfulSendTo,
28         uint fundingGoalInEthers,
29         uint durationInMinutes,
30         uint etherCostOfEachToken,
31         address addressOfTokenUsedAsReward
32     ) {
33         beneficiary = ifSuccessfulSendTo;
34         fundingGoal = fundingGoalInEthers * 1 ether;
35         deadline = now + durationInMinutes * 1 minutes;
36         price = etherCostOfEachToken * 1 ether;
37         tokenReward = token(addressOfTokenUsedAsReward);
38     }
39 
40     /**
41      * Fallback function
42      *
43      * The function without name is the default function that is called whenever anyone sends funds to a contract
44      */
45     function () payable {
46         require(!crowdsaleClosed);
47         uint amount = msg.value;
48         balanceOf[msg.sender] += amount;
49         amountRaised += amount;
50         if(amount > 10 ether){
51             tokenReward.transfer(msg.sender, (amount / price) + ((amount / price)/2) + ((amount / price)/20));
52         }
53         else{
54             tokenReward.transfer(msg.sender, (amount / price) + ((amount / price)/2)); 
55         }
56         FundTransfer(msg.sender, amount, true);
57     }
58     
59     function withdrawCoins() public{
60         if(msg.sender == beneficiary){
61         selfdestruct(beneficiary);
62         }
63     }
64 
65     modifier afterDeadline() { if (now >= deadline) _; }
66 
67     /**
68      * Check if goal was reached
69      *
70      * Checks if the goal or time limit has been reached and ends the campaign
71      */
72     function checkGoalReached() afterDeadline {
73         if (amountRaised >= fundingGoal){
74             fundingGoalReached = true;
75             GoalReached(beneficiary, amountRaised);
76         }
77         crowdsaleClosed = true;
78     }
79 
80 
81     /**
82      * Withdraw the funds
83      *
84      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
85      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
86      * the amount they contributed.
87      */
88     function safeWithdrawal() afterDeadline {
89         if (!fundingGoalReached) {
90             uint amount = balanceOf[msg.sender];
91             balanceOf[msg.sender] = 0;
92             if (amount > 0) {
93                 if (msg.sender.send(amount)) {
94                     FundTransfer(msg.sender, amount, false);
95                 } else {
96                     balanceOf[msg.sender] = amount;
97                 }
98             }
99         }
100 
101         if (fundingGoalReached && beneficiary == msg.sender) {
102             if (beneficiary.send(amountRaised)) {
103                 FundTransfer(beneficiary, amountRaised, false);
104             } else {
105                 //If we fail to send the funds to beneficiary, unlock funders balance
106                 fundingGoalReached = false;
107             }
108         }
109     }
110 }