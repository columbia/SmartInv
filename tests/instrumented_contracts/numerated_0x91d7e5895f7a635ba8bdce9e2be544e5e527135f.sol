1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public amountRaised;
11     uint public amountRemaining;
12     uint public deadline;
13     uint public price;
14     token public tokenReward;
15     bool crowdsaleClosed = false;
16     
17     event GoalReached(address recipient, uint totalAmountRaised);
18     event FundTransfer(address backer, uint amount, bool isContribution);
19 
20     /**
21      * Constructor function
22      *
23      * Setup the owner
24      */
25     function Crowdsale(
26         address ifSuccessfulSendTo,
27         address addressOfTokenUsedAsReward
28     ) public {
29         beneficiary = ifSuccessfulSendTo;
30         fundingGoal = 8334 * 1 ether;
31         deadline = 1533866400;
32         price = 100 szabo;
33         tokenReward = token(addressOfTokenUsedAsReward);
34     }
35 
36     /**
37      * Fallback function
38      *
39      * The function without name is the default function that is called whenever anyone sends funds to a contract
40      */
41     function () payable public {
42         require(!crowdsaleClosed);
43         uint amount = msg.value;
44         amountRaised += amount;
45         amountRemaining+= amount;
46         tokenReward.transfer(msg.sender, amount  * 6 /  price);
47        emit FundTransfer(msg.sender, amount, true);
48     }
49 
50     modifier afterDeadline() { if (now >= deadline) _; }
51 
52     /**
53      * Check if goal was reached
54      *
55      * Checks if the goal or time limit has been reached and ends the campaign
56      */
57     function checkGoalReached() public afterDeadline {
58         if (amountRaised >= fundingGoal){
59             emit GoalReached(beneficiary, amountRaised);
60         }
61         else
62         {
63 	        tokenReward.transfer(beneficiary, (fundingGoal-amountRaised)  * 6  /  price);
64         }
65         crowdsaleClosed = true;
66     }
67     /** 
68      * Withdraw the funds
69      *
70      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
71      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
72      * the amount they contributed.
73      */
74     function safeWithdrawal() public afterDeadline {
75         if (beneficiary == msg.sender) {
76             if (beneficiary.send(amountRemaining)) {
77                amountRemaining =0;
78                emit FundTransfer(beneficiary, amountRemaining, false);
79            }
80         }
81     }
82 }