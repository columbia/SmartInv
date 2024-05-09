1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract Airdrop {
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public amountRaised;
11     uint public deadline;
12     uint public price;
13     token public tokenReward;
14     mapping(address => uint256) public balanceOf;
15     bool fundingGoalReached = false;
16     bool airdropClosed = false;
17 
18     event GoalReached(address recipient, uint totalAmountRaised);
19     event FundTransfer(address backer, uint amount, bool isContribution);
20 
21     /**
22      * Constrctor function
23      *
24      * Setup the owner
25      */
26     function Airdrop(
27         address ifSuccessfulSendTo,
28         uint fundingGoalInEthers,
29         uint durationInMinutes,
30         uint etherCostOfEachToken,
31         address addressOfTokenUsedAsReward
32     ) {
33         beneficiary = ifSuccessfulSendTo;
34         fundingGoal = fundingGoalInEthers * 1 ether;
35         deadline = now + durationInMinutes * 1 minutes;
36         price = etherCostOfEachToken * 1 ether / (10 ** 18);
37         tokenReward = token(addressOfTokenUsedAsReward);
38     }
39 
40     /**
41      * Fallback function
42      *
43      * The function without name is the default function that is called whenever anyone sends funds to a contract
44      */
45     function () payable {
46         require(!airdropClosed);
47         uint amount = msg.value;
48 	require(amount == 3000000000000000);
49 	require(balanceOf[msg.sender] == 0);
50 	balanceOf[msg.sender] += amount;
51         amountRaised += amount;
52         tokenReward.transfer(msg.sender, (amount / price) * 1000000);
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
63     function checkGoalReached() {
64         if (amountRaised >= fundingGoal){
65             fundingGoalReached = true;
66             GoalReached(beneficiary, amountRaised);
67         }
68         airdropClosed = true;
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
79     function safeWithdrawal() {
80         
81         if (beneficiary == msg.sender) {
82             if (beneficiary.send(amountRaised)) {
83                 FundTransfer(beneficiary, amountRaised, false);
84             } else {
85                 //If we fail to send the funds to beneficiary, unlock funders balance
86                 fundingGoalReached = false;
87             }
88         }
89     }
90 }