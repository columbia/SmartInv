1 pragma solidity ^0.4.11;
2 
3 contract token { function transfer(address receiver, uint amount){ receiver; amount; } }
4 
5 contract Crowdsale {
6     address public beneficiary;
7     uint public fundingGoal; uint public amountRaised; uint public deadline; uint public price;
8     token public tokenReward;
9     mapping(address => uint256) public balanceOf;
10     bool fundingGoalReached = false;
11     event GoalReached(address beneficiary, uint amountRaised);
12     event FundTransfer(address backer, uint amount, bool isContribution);
13     bool crowdsaleClosed = false;
14 
15     /* Data structure to hold information about campaign contributors */
16 
17     /*  At initialization, setup the owner */
18     function Crowdsale(
19         address ifSuccessfulSendTo,
20         uint fundingGoalInEthers,
21         uint durationInMinutes,
22         uint weiCostOfEachToken,
23         token addressOfTokenUsedAsReward
24     ) {
25         beneficiary = ifSuccessfulSendTo;
26         fundingGoal = fundingGoalInEthers * 1 ether;
27         deadline = now + durationInMinutes * 1 minutes;
28         price = weiCostOfEachToken * 1 wei;
29         tokenReward = token(addressOfTokenUsedAsReward);
30     }
31 
32     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
33     function () payable {
34         if (crowdsaleClosed) throw;
35         uint amount = msg.value;
36         balanceOf[msg.sender] = amount;
37         amountRaised += amount;
38         tokenReward.transfer(msg.sender, amount / price);
39         FundTransfer(msg.sender, amount, true);
40     }
41 
42     modifier afterDeadline() { if (now >= deadline) _; }
43 
44     /* checks if the goal or time limit has been reached and ends the campaign */
45     function checkGoalReached() afterDeadline {
46         if (amountRaised >= fundingGoal){
47             fundingGoalReached = true;
48             GoalReached(beneficiary, amountRaised);
49         }
50         crowdsaleClosed = true;
51     }
52 
53 
54     function safeWithdrawal() afterDeadline {
55         if (!fundingGoalReached) {
56             uint amount = balanceOf[msg.sender];
57             balanceOf[msg.sender] = 0;
58             if (amount > 0) {
59                 if (msg.sender.send(amount)) {
60                     FundTransfer(msg.sender, amount, false);
61                 } else {
62                     balanceOf[msg.sender] = amount;
63                 }
64             }
65         }
66 
67         if (fundingGoalReached && beneficiary == msg.sender) {
68             if (beneficiary.send(amountRaised)) {
69                 FundTransfer(beneficiary, amountRaised, false);
70             } else {
71                 //If we fail to send the funds to beneficiary, unlock funders balance
72                 fundingGoalReached = false;
73             }
74         }
75     }
76 }