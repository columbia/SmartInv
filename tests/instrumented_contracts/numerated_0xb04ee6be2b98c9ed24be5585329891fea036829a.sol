1 pragma solidity ^0.4.11;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 
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
19     bool changePrice = false;
20 
21     event GoalReached(address recipient, uint totalAmountRaised);
22     event FundTransfer(address backer, uint amount, bool isContribution);
23     event ChangePrice(uint prices);
24     /**
25      * Constrctor function
26      *
27      * Setup the owner
28      */
29     function Crowdsale(
30         address ifSuccessfulSendTo,
31         uint fundingGoalInEthers,
32         uint durationInMinutes,
33         uint etherCostOfEachToken,
34         address addressOfTokenUsedAsReward
35     )public {
36         beneficiary = ifSuccessfulSendTo;
37         fundingGoal = fundingGoalInEthers * 1 finney;
38         deadline = now + durationInMinutes * 1 minutes;
39         price = etherCostOfEachToken * 1 finney;
40         tokenReward = token(addressOfTokenUsedAsReward);
41     }
42 
43 
44     function () public payable {
45         require(!crowdsaleClosed);
46         uint amount = msg.value;
47         balanceOf[msg.sender] += amount;
48         amountRaised += amount;
49         tokenReward.transfer(msg.sender, amount / price);
50         FundTransfer(msg.sender, amount, true);
51     }
52 
53     modifier afterDeadline() { if (now >= deadline) _; }
54 
55     /**
56      * Check if goal was reached
57      *
58      * Checks if the goal or time limit has been reached and ends the campaign
59      */
60     function checkGoalReached() public afterDeadline {
61         if (amountRaised >= fundingGoal){
62             fundingGoalReached = true;
63             GoalReached(beneficiary, amountRaised);
64         }
65         crowdsaleClosed = true;
66     }
67 
68     //transfer token to the owner of the contract (beneficiary)//afterDeadline
69         function transferToken(uint amount)public afterDeadline {  
70         if (beneficiary == msg.sender)
71         {            
72             tokenReward.transfer(msg.sender, amount);  
73             FundTransfer(msg.sender, amount, true);          
74         }
75        
76     }
77 
78 
79  
80     function safeWithdrawal()public afterDeadline {
81         if (!fundingGoalReached) {
82             uint amount = balanceOf[msg.sender];
83             balanceOf[msg.sender] = 0;
84             if (amount > 0) {
85                 if (msg.sender.send(amount)) {
86                     FundTransfer(msg.sender, amount, false);
87                 } else {
88                     balanceOf[msg.sender] = amount;
89                 }
90             }
91         }
92 
93         if (fundingGoalReached && beneficiary == msg.sender) {
94             if (beneficiary.send(amountRaised)) {
95                 FundTransfer(beneficiary, amountRaised, false);
96             } else {
97                 //If we fail to send the funds to beneficiary, unlock funders balance
98                 fundingGoalReached = false;
99             }
100         }
101     }
102     function checkPriceCrowdsale(uint newPrice1, uint newPrice2)public {
103         if (beneficiary == msg.sender) {          
104            price = (newPrice1 * 1 finney)+(newPrice2 * 1 szabo);
105            ChangePrice(price);
106            changePrice = true;
107         }
108 
109     }
110 }