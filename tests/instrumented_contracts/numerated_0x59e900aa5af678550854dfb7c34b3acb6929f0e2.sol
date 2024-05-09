1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract CrowdsaleCryptoMindPreICO {
8     address public beneficiary;
9     uint public MaxToken;
10     uint public amountRaised;
11     uint public deadline;
12     uint public StartCrowdsale;
13     uint public price;
14     token public tokenReward;
15     mapping(address => uint256) public balanceOf;
16     bool fundingGoalReached = false;
17     bool crowdsaleClosed = false;
18     
19 
20     //event GoalReached(address beneficiary, uint amountRaised);
21     event FundTransfer(address backer, uint amount, bool isContribution);
22 
23     /**
24      * Constrctor function
25      *
26      * Setup the owner
27      */
28     function CrowdsaleCryptoMindPreICO() {
29         beneficiary = 0x41A2fe9687Ae815176166616D222B48DA6a36546;
30         MaxToken = 800 * 1 ether;
31         StartCrowdsale = 1510358400;
32         deadline = 1512086400;
33         price = 5000;
34         tokenReward = token(0xa7b67b22E0504D151E40d2782C8DB4a48DC202f6);
35     }
36 
37     /**
38      * Fallback function
39      *
40      * The function without name is the default function that is called whenever anyone sends funds to a contract
41      */
42     function () payable {
43         require(!crowdsaleClosed);
44         require(now > StartCrowdsale);
45         require(amountRaised + msg.value > amountRaised);
46         require(amountRaised + msg.value < MaxToken);
47         uint amount = msg.value;
48         balanceOf[msg.sender] += amount;
49         amountRaised += amount;
50         tokenReward.transfer(msg.sender, amount * price);
51         FundTransfer(msg.sender, amount, true);
52     }
53 
54     modifier afterDeadline() { if (now >= deadline) _; }
55 
56     /**
57      * Check if goal was reached
58      *
59      * Checks if the goal or time limit has been reached and ends the campaign
60      */
61     function checkGoalReached() afterDeadline {
62         fundingGoalReached = true;
63         crowdsaleClosed = true;
64     }
65 
66 
67     /**
68      * Withdraw the funds
69      *
70      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
71      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
72      * the amount they contributed.
73      */
74     function safeWithdrawal() afterDeadline {
75 
76         if (fundingGoalReached && beneficiary == msg.sender) {
77             if (beneficiary.send(amountRaised)) {
78                 FundTransfer(beneficiary, amountRaised, false);
79             } else {
80                 //If we fail to send the funds to beneficiary, unlock funders balance
81                 fundingGoalReached = false;
82             }
83         }
84     }
85 }