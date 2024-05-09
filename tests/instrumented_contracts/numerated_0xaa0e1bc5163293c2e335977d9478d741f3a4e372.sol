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
15     uint public deadline;
16     uint public price;
17     token public tokenReward;
18     mapping(address => uint256) public balanceOf;
19     bool fundingGoalReached = false;
20     bool crowdsaleClosed = false;
21 
22     event GoalReached(address recipient, uint totalAmountRaised);
23 
24     /**
25      * Constrctor function
26      *
27      * Setup the owner
28      */
29     function PornTokenV2Crowdsale(
30         address sendTo,
31         uint fundingGoalInEthers,
32         uint durationInMinutes,
33         address addressOfTokenUsedAsReward
34     ) {
35         beneficiary = sendTo;
36         fundingGoal = fundingGoalInEthers * 1 ether;
37         deadline = now + durationInMinutes * 1 minutes;
38         /* 0.00001337 x 1 ether in wei */
39         price = 13370000000000;
40         tokenReward = token(addressOfTokenUsedAsReward);
41     }
42 
43     /**
44      * Fallback function
45      *
46      * The function without name is the default function that is called whenever anyone sends funds to a contract
47      */
48     function () payable {
49         require(!crowdsaleClosed);
50         uint amount = msg.value;
51         if (amount > 0) {
52             balanceOf[msg.sender] += amount;
53             amountRaised += amount;
54             tokenReward.transfer(msg.sender, amount / price);
55             beneficiary.send(amount);
56         }
57     }
58 
59     modifier afterDeadline() { if (now >= deadline) _; }
60 
61     /**
62      * Check if goal was reached
63      *
64      * Checks if the goal or time limit has been reached and ends the campaign
65      */
66     function checkGoalReached() afterDeadline {
67         if (amountRaised >= fundingGoal){
68             fundingGoalReached = true;
69             GoalReached(beneficiary, amountRaised);
70         }
71         crowdsaleClosed = true;
72     }
73 
74 
75     /**
76      * Not Used
77      */
78     function safeWithdrawal() afterDeadline {
79         /* no implementation needed */
80     }
81 }