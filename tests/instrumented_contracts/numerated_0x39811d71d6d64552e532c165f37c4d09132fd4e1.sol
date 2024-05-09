1 pragma solidity ^0.4.16;
2 
3 
4 interface token {
5     function transfer(address receiver, uint amount);
6 }
7 
8 contract Crowdsale {
9     address public beneficiary;
10     uint public fundingGoal;
11     uint public amountRaised;
12     uint public deadline;
13     uint public price;
14     token public tokenReward;
15     mapping(address => uint256) public balanceOf;
16     bool fundingGoalReached = false;
17     bool crowdsaleClosed = false;
18 
19     event GoalReached(address recipient, uint totalAmountRaised);
20     event FundTransfer(address backer, uint amount, bool isContribution);
21 
22     /**
23      * Constrctor function
24      *
25      * Setup the owner
26      */
27     function Crowdsale(
28         address ifSuccessfulSendTo,
29         uint fundingGoalInWei,
30         uint durationInMinutes,
31         uint weiCostOfEachToken,
32         address addressOfTokenUsedAsReward
33     ) {
34         beneficiary = ifSuccessfulSendTo;
35         fundingGoal = fundingGoalInWei * 10 ** 11 wei;
36         deadline = now + durationInMinutes * 1 minutes;
37         price = weiCostOfEachToken * 10 ** 11 wei;
38         tokenReward = token(addressOfTokenUsedAsReward);
39     }
40 
41     /**
42      * Fallback function
43      *
44      * The function without name is the default function that is called whenever anyone sends funds to a contract
45      */
46     function () payable {
47         require(!crowdsaleClosed);
48         uint amount = msg.value;
49         balanceOf[msg.sender] += amount;
50         amountRaised += amount;
51         tokenReward.transfer(msg.sender, (amount * 10 ** 18) / price);
52         FundTransfer(msg.sender, amount, true);
53     }
54 
55     modifier afterDeadline() { if (now >= deadline) _; }
56 
57     /**
58      * Check if goal was reached
59      *
60      * Checks if the goal or time limit has been reached and ends the campaign
61      */
62     function checkGoalReached() afterDeadline {
63         if (amountRaised >= fundingGoal){
64             fundingGoalReached = true;
65             GoalReached(beneficiary, amountRaised);
66         }
67         crowdsaleClosed = true;
68     }
69 
70 
71     /**
72      * Withdraw the funds
73      *
74      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
75      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
76      * the amount they contributed.
77      */
78     function safeWithdrawal() afterDeadline {
79         if (!fundingGoalReached) {
80             uint amount = balanceOf[msg.sender];
81             balanceOf[msg.sender] = 0;
82             if (amount > 0) {
83                 if (msg.sender.send(amount)) {
84                     FundTransfer(msg.sender, amount, false);
85                 } else {
86                     balanceOf[msg.sender] = amount;
87                 }
88             }
89         }
90 
91         if (fundingGoalReached && beneficiary == msg.sender) {
92             if (beneficiary.send(amountRaised)) {
93                 FundTransfer(beneficiary, amountRaised, false);
94             } else {
95                 //If we fail to send the funds to beneficiary, unlock funders balance
96                 fundingGoalReached = false;
97             }
98         }
99     }
100 }