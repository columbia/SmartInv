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
53             uint amountToSend = currentBalance;
54             currentBalance = 0;
55             beneficiary.send(amountToSend);
56         } else if (amount > 0) {
57             balanceOf[msg.sender] += amount;
58             amountRaised += amount;
59             currentBalance += amount;
60             tokenReward.transfer(msg.sender, (amount / price) * 1 ether);
61         }
62     }
63 
64     modifier afterDeadline() { if (now >= deadline) _; }
65 
66     /**
67      * Check if goal was reached
68      *
69      * Checks if the goal or time limit has been reached and ends the campaign
70      */
71     function checkGoalReached() afterDeadline {
72         if (amountRaised >= fundingGoal){
73             fundingGoalReached = true;
74             GoalReached(beneficiary, amountRaised);
75         }
76         crowdsaleClosed = true;
77     }
78 
79 
80     /**
81      * Not Used
82      */
83     function safeWithdrawal() afterDeadline {
84         /* no implementation needed */
85     }
86 }