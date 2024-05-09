1 pragma solidity ^0.4.16;
2 
3 /**
4  * PornTokenV2 Crowd Sale
5  */
6 
7 interface token {
8     function transfer(address receiver, uint amount);
9 }
10 
11 contract PornTokenV2Crowdsale {
12     address public beneficiary;
13     uint public fundingGoal;
14     uint public amountRaised;
15     uint private currentBalance;
16     uint public deadline;
17     uint public price;
18     uint public initialTokenAmount;
19     uint public currentTokenAmount;
20     token public tokenReward;
21     mapping(address => uint256) public balanceOf;
22     bool fundingGoalReached = false;
23     bool crowdsaleClosed = false;
24 
25     event GoalReached(address recipient, uint totalAmountRaised);
26 
27     /**
28      * Constrctor function
29      *
30      * Setup the owner
31      */
32     function PornTokenV2Crowdsale(
33         address sendTo,
34         uint fundingGoalInEthers,
35         uint durationInMinutes,
36         address addressOfTokenUsedAsReward
37     ) {
38         beneficiary = sendTo;
39         fundingGoal = fundingGoalInEthers * 1 ether;
40         deadline = now + durationInMinutes * 1 minutes;
41         /* 0.00001337 x 1 ether in wei */
42         price = 13370000000000;
43         initialTokenAmount = 747943160;
44         currentTokenAmount = 747943160;
45         tokenReward = token(addressOfTokenUsedAsReward);
46     }
47 
48     /**
49      * Fallback function
50      *
51      * The function without name is the default function that is called whenever anyone sends funds to a contract
52      */
53     function () payable {
54         require(!crowdsaleClosed);
55         uint amount = msg.value;
56         if (amount > 0) {
57             balanceOf[msg.sender] += amount;
58             amountRaised += amount;
59             currentBalance += amount;
60             uint tokenAmount = amount / price;
61             currentTokenAmount -= tokenAmount;
62             tokenReward.transfer(msg.sender, tokenAmount * 1 ether);
63         }
64     }
65 
66     /**
67      * Bank tokens
68      *
69      * Deposit token sale proceeds to PornToken Account
70      */
71     function bank() public {
72         if (beneficiary == msg.sender && currentBalance > 0) {
73             uint amountToSend = currentBalance;
74             currentBalance = 0;
75             beneficiary.send(amountToSend);
76         }
77     }
78     
79     /**
80      * Withdraw unusold tokens
81      *
82      * Deposit unsold tokens to PornToken Account
83      */
84     function returnUnsold() public {
85         if (beneficiary == msg.sender) {
86             tokenReward.transfer(beneficiary, currentTokenAmount);
87         }
88     }
89     
90     /**
91      * Withdraw unusold tokens
92      *
93      * Deposit unsold tokens to PornToken Account 100k Safe
94      */
95     function returnUnsoldSafe() public {
96         if (beneficiary == msg.sender) {
97             uint tokenAmount = 100000;
98             tokenReward.transfer(beneficiary, tokenAmount);
99         }
100     }
101 
102     modifier afterDeadline() { if (now >= deadline) _; }
103 
104     /**
105      * Check if goal was reached
106      *
107      * Checks if the goal or time limit has been reached and ends the campaign
108      */
109     function checkGoalReached() afterDeadline {
110         if (amountRaised >= fundingGoal){
111             fundingGoalReached = true;
112             GoalReached(beneficiary, amountRaised);
113         }
114         crowdsaleClosed = true;
115     }
116 
117 
118 }