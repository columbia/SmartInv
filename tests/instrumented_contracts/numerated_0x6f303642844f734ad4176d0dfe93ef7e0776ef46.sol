1 pragma solidity ^0.4.11;
2 
3 contract token { function transfer(address, uint){  } }
4 
5 contract CrowdsaleWatch {
6     address public beneficiary;
7     uint public fundingGoal; uint public amountRaised; uint public deadline; uint public price;
8     token public tokenReward;
9     mapping(address => uint256) public balanceOf;
10     bool fundingGoalReached = false;
11     event GoalReached(address beneficiary, uint amountRaised);
12     event FundTransfer(address backer, uint amount, bool isContribution);
13     bool crowdsaleClosed = false;
14 
15     /* data structure to hold information about campaign contributors */
16 
17     /*  at initialization, setup the owner */
18     function CrowdsaleWatch(
19         address ifSuccessfulSendTo,
20         uint fundingGoalInEthers,
21         uint durationInMinutes,
22         uint etherCostOfEachToken,
23         token addressOfTokenUsedAsReward
24     ) {
25         beneficiary = ifSuccessfulSendTo;
26         fundingGoal = fundingGoalInEthers * 5000 ether;
27         deadline = now + durationInMinutes * 1 minutes;
28         price = etherCostOfEachToken * 5000000 wei;
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
46         if(amountRaised >= fundingGoal && !fundingGoalReached){
47             fundingGoalReached = true;
48             GoalReached(beneficiary, amountRaised);
49         }
50         crowdsaleClosed = true;
51     }
52 function safeWithdrawal() afterDeadline {
53         checkGoalReached();
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
75     
76     function tokenWithdraw(uint256 amount) afterDeadline {
77         if(beneficiary == msg.sender){
78             tokenReward.transfer(msg.sender, amount);
79         }
80     }
81 }