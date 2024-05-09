1 pragma solidity ^0.4.2;
2 contract token { function transfer(address receiver, uint amount){  } }
3 
4 contract Crowdsale {
5     address public beneficiary;
6     uint public fundingGoal; uint public amountRaised; uint public deadline; uint public price;
7     token public tokenReward;
8     mapping(address => uint256) public balanceOf;
9     bool fundingGoalReached = false;
10     event GoalReached(address beneficiary, uint amountRaised);
11     event FundTransfer(address backer, uint amount, bool isContribution);
12     bool crowdsaleClosed = false;
13 
14     /* data structure to hold information about campaign contributors */
15 
16     /*  at initialization, setup the owner */
17     function Crowdsale(
18         address ifSuccessfulSendTo,
19         uint fundingGoalInEthers,
20         uint durationInMinutes,
21         uint etherCostOfEachToken,
22         token addressOfTokenUsedAsReward
23     ) {
24         beneficiary = ifSuccessfulSendTo;
25         fundingGoal = fundingGoalInEthers * 1 ether;
26         deadline = now + durationInMinutes * 1 minutes;
27         price = etherCostOfEachToken * 1 ether;
28         tokenReward = token(addressOfTokenUsedAsReward);
29     }
30 
31     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
32     function () payable {
33         if (crowdsaleClosed) throw;
34         uint amount = msg.value;
35         balanceOf[msg.sender] = amount;
36         amountRaised += amount;
37         tokenReward.transfer(msg.sender, amount / price);
38         FundTransfer(msg.sender, amount, true);
39     }
40 
41     modifier afterDeadline() { if (now >= deadline) _; }
42 
43     /* checks if the goal or time limit has been reached and ends the campaign */
44     function checkGoalReached() afterDeadline {
45         if (amountRaised >= fundingGoal){
46             fundingGoalReached = true;
47             GoalReached(beneficiary, amountRaised);
48         }
49         crowdsaleClosed = true;
50     }
51 
52 
53     function safeWithdrawal() afterDeadline {
54         if (!fundingGoalReached) {
55             uint amount = balanceOf[msg.sender];
56             balanceOf[msg.sender] = 0;
57             if (amount > 0) {
58                 if (msg.sender.send(amount)) {
59                     FundTransfer(msg.sender, amount, false);
60                 } else {
61                     balanceOf[msg.sender] = amount;
62                 }
63             }
64         }
65 
66         if (fundingGoalReached && beneficiary == msg.sender) {
67             if (beneficiary.send(amountRaised)) {
68                 FundTransfer(beneficiary, amountRaised, false);
69             } else {
70                 //If we fail to send the funds to beneficiary, unlock funders balance
71                 fundingGoalReached = false;
72             }
73         }
74     }
75 }