1 pragma solidity ^0.4.10;
2 
3 
4 contract Token { 
5     function transfer(address receiver, uint amount);
6 }
7 
8 
9 contract TemplateCrowdSale {
10     address public beneficiary;
11     uint public fundingGoal; 
12     uint public amountRaised; 
13     uint public deadline; 
14     uint public price;
15     uint public minAmount = 1 ether;
16     Token public tokenReward;
17     mapping(address => uint256) public balanceOf;
18     bool fundingGoalReached = false;
19     bool crowdsaleClosed = false;
20     
21     event GoalReached(address beneficiary, uint amountRaised);
22     event FundTransfer(address backer, uint amount, bool isContribution);
23 
24     /* data structure to hold information about campaign contributors */
25 
26     /*  at initialization, setup the owner */
27     function TemplateCrowdSale(
28         address ifSuccessfulSendTo,
29         uint fundingGoalInEthers,
30         uint durationInMinutes,
31         uint etherCostOf10000Token,
32         Token addressOfTokenUsedAsReward
33     ) {
34         beneficiary = ifSuccessfulSendTo;
35         fundingGoal = fundingGoalInEthers * 1 ether;
36         deadline = now + durationInMinutes * 1 minutes;
37         price = etherCostOf10000Token ;
38         tokenReward = Token(addressOfTokenUsedAsReward);
39     }
40 
41     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
42     function () payable {
43         if (crowdsaleClosed) {
44             revert();
45         }
46         uint amount = msg.value;
47         if (amount < minAmount) {
48             revert();
49         }
50         balanceOf[msg.sender] = amount;
51         amountRaised += amount;
52         tokenReward.transfer(msg.sender, amount*10000 / price);
53         FundTransfer(msg.sender, amount, true);
54     }
55 
56     modifier afterDeadline() { 
57         require(now >= deadline);
58         _;
59     }
60 
61     /* checks if the goal or time limit has been reached and ends the campaign */
62     function checkGoalReached() afterDeadline {
63         if (amountRaised >= fundingGoal) {
64             fundingGoalReached = true;
65             GoalReached(beneficiary, amountRaised);
66         }
67         crowdsaleClosed = true;
68     }
69 
70     function safeWithdrawal() afterDeadline {
71         if (!fundingGoalReached) {
72             uint amount = balanceOf[msg.sender];
73             balanceOf[msg.sender] = 0;
74             if (amount > 0) {
75                 if (msg.sender.send(amount)) {
76                     FundTransfer(msg.sender, amount, false);
77                 } else {
78                     balanceOf[msg.sender] = amount;
79                 }
80             }
81         }
82 
83         if (fundingGoalReached && beneficiary == msg.sender) {
84             if (beneficiary.send(amountRaised)) {
85                 FundTransfer(beneficiary, amountRaised, false);
86             } else {
87                 //If we fail to send the funds to beneficiary, unlock funders balance
88                 fundingGoalReached = false;
89             }
90         }
91     }
92 }