1 pragma solidity ^0.4.21;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public amountRaised;
11     uint public deadline;
12     uint public price;
13     token public tokenReward;
14     mapping(address => uint256) public balanceOf;
15     bool fundingGoalReached = false;
16     bool crowdsaleClosed = false;
17     uint public starttime;
18 
19     event GoalReached(address recipient, uint totalAmountRaised);
20     event FundTransfer(address backer, uint amount, bool isContribution);
21 
22     /**
23      * Constructor function
24      *
25      * Setup the owner
26      */
27     function Crowdsale(
28         address ifSuccessfulSendTo,
29         uint fundingGoalInEthers,
30         uint durationInMinutes,
31         uint weiCostOfEachToken,
32         address addressOfTokenUsedAsReward
33     ) public {
34         beneficiary = ifSuccessfulSendTo;
35         fundingGoal = fundingGoalInEthers * 1 ether;
36         deadline = now + durationInMinutes * 1 minutes;
37         price = weiCostOfEachToken;
38         tokenReward = token(addressOfTokenUsedAsReward);
39         starttime = now;
40     }
41 
42     /**
43      * Fallback function
44      *
45      * The function without name is the default function that is called whenever anyone sends funds to a contract
46      */
47     function () payable public {
48         require(!crowdsaleClosed);
49         uint amount = msg.value;
50         balanceOf[msg.sender] += amount;
51         amountRaised += amount;
52         if (now < (starttime + 1440 * 1 minutes))
53         {
54             tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 65 / 100));
55         }
56         else if (now < (starttime + 4320 * 1 minutes))
57         {
58             tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 75 / 100));
59         }
60         else if (now < (starttime + 10080 * 1 minutes))
61         {
62             tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 85 / 100));
63         }
64         else if (now < (starttime + 30240 * 1 minutes))
65         {
66             tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 90 / 100));
67         }
68         else
69         {
70             tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / price);
71         }
72        emit FundTransfer(msg.sender, amount, true);
73     }
74 
75     modifier afterDeadline() { if (now >= deadline) _; }
76 
77     /**
78      * Check if goal was reached
79      *
80      * Checks if the goal or time limit has been reached and ends the campaign
81      */
82     function checkGoalReached() public afterDeadline {
83         if (amountRaised >= fundingGoal){
84             fundingGoalReached = true;
85             emit GoalReached(beneficiary, amountRaised);
86         }
87         crowdsaleClosed = true;
88     }
89 
90 
91     /**
92      * Withdraw the funds
93      *
94      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
95      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
96      * the amount they contributed.
97      */
98     function safeWithdrawal() public afterDeadline {
99         if (!fundingGoalReached) {
100             uint amount = balanceOf[msg.sender];
101             balanceOf[msg.sender] = 0;
102             if (amount > 0) {
103                 if (msg.sender.send(amount)) {
104                    emit FundTransfer(msg.sender, amount, false);
105                 } else {
106                     balanceOf[msg.sender] = amount;
107                 }
108             }
109         }
110 
111         if (fundingGoalReached && beneficiary == msg.sender) {
112             if (beneficiary.send(amountRaised)) {
113                emit FundTransfer(beneficiary, amountRaised, false);
114             } else {
115                 //If we fail to send the funds to beneficiary, unlock funders balance
116                 fundingGoalReached = false;
117             }
118         }
119     }
120 }