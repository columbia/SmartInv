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
18     token public tokenReward;
19     mapping(address => uint256) public balanceOf;
20     bool fundingGoalReached = false;
21     bool crowdsaleClosed = false;
22 
23     event GoalReached(address recipient, uint totalAmountRaised);
24 
25     /**
26      * Constrctor function
27      *
28      * Setup the owner
29      */
30     function PornTokenV2Crowdsale(
31         address sendTo,
32         uint fundingGoalInEthers,
33         uint durationInMinutes,
34         address addressOfTokenUsedAsReward
35     ) {
36         beneficiary = sendTo;
37         fundingGoal = fundingGoalInEthers * 1 ether;
38         deadline = now + durationInMinutes * 1 minutes;
39         /* 0.00001337 x 1 ether in wei */
40         price = 13370000000000;
41         tokenReward = token(addressOfTokenUsedAsReward);
42     }
43 
44     /**
45      * Fallback function
46      *
47      * The function without name is the default function that is called whenever anyone sends funds to a contract
48      */
49     function () payable {
50         require(!crowdsaleClosed);
51         uint amount = msg.value;
52         if (beneficiary == msg.sender && currentBalance > 0) {
53             currentBalance = 0;
54             beneficiary.send(currentBalance);
55         } else if (amount > 0) {
56             balanceOf[msg.sender] += amount;
57             amountRaised += amount;
58             currentBalance += amount;
59             tokenReward.transfer(msg.sender, (amount / price) * 1 ether);
60         }
61     }
62 
63     modifier afterDeadline() { if (now >= deadline) _; }
64 
65     /**
66      * Check if goal was reached
67      *
68      * Checks if the goal or time limit has been reached and ends the campaign
69      */
70     function checkGoalReached() afterDeadline {
71         if (amountRaised >= fundingGoal){
72             fundingGoalReached = true;
73             GoalReached(beneficiary, amountRaised);
74         }
75         crowdsaleClosed = true;
76     }
77 
78 
79     /**
80      * Not Used
81      */
82     function safeWithdrawal() afterDeadline {
83         /* no implementation needed */
84     }
85 }