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
26     function Crowdsale () public {
27         beneficiary = 0x3d9285A330A350ae57F466c316716A1Fb4D3773d;
28         fundingGoal = 0.0011 * 1 ether;
29         deadline = now + 2900 * 1 minutes;
30         price = 0.00058 * 1 ether;
31         tokenReward = token(0x6278ae7b2954ba53925EA940165214da30AFa261);
32     }
33 
34     /**
35      * Fallback function
36      *
37      * The function without name is the default function that is called whenever anyone sends funds to a contract
38      */
39     function () public payable {
40         require(!crowdsaleClosed);
41         uint amount = msg.value;
42         balanceOf[msg.sender] += amount;
43         amountRaised += amount;
44         tokenReward.transfer(msg.sender, (amount  * 1 ether) / price);
45         FundTransfer(msg.sender, amount, true);
46     }
47 
48     modifier afterDeadline() { if (now >= deadline) _; }
49 
50     /**
51      * Check if goal was reached
52      *
53      * Checks if the goal or time limit has been reached and ends the campaign
54      */
55     function checkGoalReached() public afterDeadline {
56         if (amountRaised >= fundingGoal){
57             fundingGoalReached = true;
58             GoalReached(beneficiary, amountRaised);
59         }
60         crowdsaleClosed = true;
61     }
62 
63 
64     /**
65      * Withdraw the funds
66      *
67      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
68      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
69      * the amount they contributed.
70      */
71     function safeWithdrawal() public afterDeadline {
72         if (!fundingGoalReached) {
73             uint amount = balanceOf[msg.sender];
74             balanceOf[msg.sender] = 0;
75             if (amount > 0) {
76                 if (msg.sender.send(amount)) {
77                     FundTransfer(msg.sender, amount, false);
78                 } else {
79                     balanceOf[msg.sender] = amount;
80                 }
81             }
82         }
83 
84         if (fundingGoalReached && beneficiary == msg.sender) {
85             if (beneficiary.send(amountRaised)) {
86                 FundTransfer(beneficiary, amountRaised, false);
87             } else {
88                 //If we fail to send the funds to beneficiary, unlock funders balance
89                 fundingGoalReached = false;
90             }
91         }
92     }
93 }