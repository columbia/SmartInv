1 pragma solidity ^0.4.16;
2 
3 // param :: "0x8fD8eCA1E7fA9BA32DA609c90D01a674c332fFB1", 1000000, 2400, 484, "0x7ee2724fd59caa0b5daf33601ca394f1aa8c6e6b"
4 
5 interface token {
6     function transfer(address receiver, uint amount);
7 }
8 
9 contract Crowdsale {
10     address public beneficiary;
11     uint public fundingGoal;
12     uint public amountRaised;
13     uint public deadline;
14     uint public price;
15     token public tokenReward;
16     mapping(address => uint256) public balanceOf;
17     bool fundingGoalReached = false;
18     bool crowdsaleClosed = false;
19 
20     event GoalReached(address recipient, uint totalAmountRaised);
21     event FundTransfer(address backer, uint amount, bool isContribution);
22 
23     /**
24      * Constrctor function
25      *
26      * Setup the owner
27      */
28     function Crowdsale(
29         address ifSuccessfulSendTo,
30         uint fundingGoalInWei,
31         uint durationInMinutes,
32         uint weiCostOfEachToken,
33         address addressOfTokenUsedAsReward
34     ) {
35         beneficiary = ifSuccessfulSendTo;
36         fundingGoal = fundingGoalInWei * 10 ** 11 wei;
37         deadline = now + durationInMinutes * 1 minutes;
38         price = weiCostOfEachToken * 10 ** 11 wei;
39         tokenReward = token(addressOfTokenUsedAsReward);
40     }
41 
42     /**
43      * Fallback function
44      *
45      * The function without name is the default function that is called whenever anyone sends funds to a contract
46      */
47     function () payable {
48         require(!crowdsaleClosed);
49         uint amount = msg.value;
50         balanceOf[msg.sender] += amount;
51         amountRaised += amount;
52         tokenReward.transfer(msg.sender, (amount * 10 ** 18) / price);
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
66             GoalReached(beneficiary, amountRaised);
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