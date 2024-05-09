1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract TestCrowdsaleCryptoMind {
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public MaxToken;
11     uint public amountRaised;
12     uint public deadline;
13     uint public StartCrowdsale;
14     uint public price;
15     token public tokenReward;
16     mapping(address => uint256) public balanceOf;
17     bool fundingGoalReached = false;
18     bool crowdsaleClosed = false;
19     
20 
21     //event GoalReached(address beneficiary, uint amountRaised);
22     event FundTransfer(address backer, uint amount, bool isContribution);
23 
24     /**
25      * Constrctor function
26      *
27      * Setup the owner
28      */
29     function TestCrowdsaleCryptoMind() {
30         beneficiary = 0x41A2fe9687Ae815176166616D222B48DA6a36546;
31         fundingGoal = 0.01 * 1 ether;
32         MaxToken = 300 * 1 ether;
33         StartCrowdsale = 1507766400;
34         deadline = 1508536800;
35         price = 1000;
36         tokenReward = token(0xbCBD4c956E765fEEce4F44ea6909A9301C6c4703);
37     }
38 
39     /**
40      * Fallback function
41      *
42      * The function without name is the default function that is called whenever anyone sends funds to a contract
43      */
44     function () payable {
45         require(!crowdsaleClosed);
46         require(now > StartCrowdsale);
47         require(amountRaised + msg.value > amountRaised);
48         require(amountRaised + msg.value < MaxToken);
49         uint amount = msg.value;
50         balanceOf[msg.sender] += amount;
51         amountRaised += amount;
52         tokenReward.transfer(msg.sender, amount * price);
53         FundTransfer(msg.sender, amount, true);
54     }
55 
56     modifier afterDeadline() { if (now >= deadline) _; }
57 
58     /**
59      * Check if goal was reached
60      *
61      * Checks if the goal or time limit has been reached and ends the campaign
62      */
63     function checkGoalReached() afterDeadline {
64         if (amountRaised >= fundingGoal){
65             fundingGoalReached = true;
66             //GoalReached(beneficiary, amountRaised);
67         }
68         crowdsaleClosed = true;
69     }
70 
71 
72     /**
73      * Withdraw the funds
74      *
75      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
76      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
77      * the amount they contributed.
78      */
79     function safeWithdrawal() afterDeadline {
80         if (!fundingGoalReached) {
81             uint amount = balanceOf[msg.sender];
82             balanceOf[msg.sender] = 0;
83             if (amount > 0) {
84                 if (msg.sender.send(amount)) {
85                     FundTransfer(msg.sender, amount, false);
86                 } else {
87                     balanceOf[msg.sender] = amount;
88                 }
89             }
90         }
91 
92         if (fundingGoalReached && beneficiary == msg.sender) {
93             if (beneficiary.send(amountRaised)) {
94                 FundTransfer(beneficiary, amountRaised, false);
95             } else {
96                 //If we fail to send the funds to beneficiary, unlock funders balance
97                 fundingGoalReached = false;
98             }
99         }
100     }
101 }