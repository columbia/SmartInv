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
13     mapping(address => uint256) public balanceOf;
14     bool fundingGoalReached = false;
15     bool crowdsaleClosed = false;
16 
17     event GoalReached(address recipient, uint totalAmountRaised);
18     event FundTransfer(address backer, uint amount, bool isContribution);
19 
20 function Crowdsale()
21 {
22     beneficiary = 0x9F73Cc683f06061510908b0C80A27cF63f3E75c9;
23     fundingGoal = 1 * 1 ether;
24     deadline = now + 1 * 1 days;
25 }
26     /**
27      * Fallback function
28      *
29      * The function without name is the default function that is called whenever anyone sends funds to a contract
30      */
31     function () payable {
32         require(!crowdsaleClosed);
33         uint amount = msg.value;
34         balanceOf[msg.sender] += amount;
35         amountRaised += amount;
36         FundTransfer(msg.sender, amount, true);
37     }
38 
39     modifier afterDeadline() { if (now >= deadline) _; }
40 
41     /**
42      * Check if goal was reached
43      *
44      * Checks if the goal or time limit has been reached and ends the campaign
45      */
46     function checkGoalReached() afterDeadline {
47         if (amountRaised >= fundingGoal){
48             fundingGoalReached = true;
49             GoalReached(beneficiary, amountRaised);
50         }
51         crowdsaleClosed = true;
52     }
53 
54 
55     /**
56      * Withdraw the funds
57      *
58      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
59      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
60      * the amount they contributed.
61      */
62     function safeWithdrawal() afterDeadline {
63         if (!fundingGoalReached) {
64             uint amount = balanceOf[msg.sender];
65             balanceOf[msg.sender] = 0;
66             if (amount > 0) {
67                 if (msg.sender.send(amount)) {
68                     FundTransfer(msg.sender, amount, false);
69                 } else {
70                     balanceOf[msg.sender] = amount;
71                 }
72             }
73         }
74 
75         if (fundingGoalReached && beneficiary == msg.sender) {
76             if (beneficiary.send(amountRaised)) {
77                 FundTransfer(beneficiary, amountRaised, false);
78             } else {
79                 //If we fail to send the funds to beneficiary, unlock funders balance
80                 fundingGoalReached = false;
81             }
82         }
83     }
84 }