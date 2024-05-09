1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
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
22      * Constrctor function
23      *
24      * Setup the owner
25      */
26     function Crowdsale(
27         address ifSuccessfulSendTo,
28         uint fundingGoalInEthers,
29         address addressOfTokenUsedAsReward
30     )  public{
31         beneficiary = ifSuccessfulSendTo;
32         fundingGoal = fundingGoalInEthers * 1 ether;
33         price =  (0.00001 ether)/100000  ;
34         tokenReward = token(addressOfTokenUsedAsReward);
35     }
36 
37     /**
38      * Fallback function
39      *
40      * The function without name is the default function that is called whenever anyone sends funds to a contract
41      */
42     function () payable public {
43         require(!crowdsaleClosed);
44         uint amount = msg.value;
45         balanceOf[msg.sender] += amount;
46         amountRaised += amount;
47         tokenReward.transfer(msg.sender, amount / price);
48         FundTransfer(msg.sender, amount, true);
49     }
50 
51     modifier afterDeadline() { if (now >= deadline) _; }
52 
53     /**
54      * Check if goal was reached
55      *
56      * Checks if the goal or time limit has been reached and ends the campaign
57      */
58     function checkGoalReached() afterDeadline public {
59         if (amountRaised >= fundingGoal){
60             fundingGoalReached = true;
61             GoalReached(beneficiary, amountRaised);
62         }
63         crowdsaleClosed = true;
64     }
65 
66 
67     /**
68      * Withdraw the funds
69      *
70      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
71      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
72      * the amount they contributed.
73      */
74     function safeWithdrawal() afterDeadline public {
75         if (!fundingGoalReached) {
76             uint amount = balanceOf[msg.sender];
77             balanceOf[msg.sender] = 0;
78             if (amount > 0) {
79                 if (msg.sender.send(amount)) {
80                     FundTransfer(msg.sender, amount, false);
81                 } else {
82                     balanceOf[msg.sender] = amount;
83                 }
84             }
85         }
86 
87         if (fundingGoalReached && beneficiary == msg.sender) {
88             if (beneficiary.send(amountRaised)) {
89                 FundTransfer(beneficiary, amountRaised, false);
90             } else {
91                 //If we fail to send the funds to beneficiary, unlock funders balance
92                 fundingGoalReached = false;
93             }
94         }
95     }
96 }