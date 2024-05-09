1 pragma solidity ^0.4.8;
2 
3 contract token { function transferFrom(address sender, address receiver, uint amount){  } }
4 
5 contract Crowdsale {
6     address public beneficiary;
7     address public tokenAdmin;
8     uint public fundingGoal; uint public amountRaised; uint public deadline; uint public price;
9     token public tokenReward;
10     mapping(address => uint256) public balanceOf;
11     bool fundingGoalReached = false;
12     event GoalReached(address beneficiary, uint amountRaised);
13     event FundTransfer(address backer, uint amount, bool isContribution);
14     bool public crowdsaleClosed = false;
15 
16     /* data structure to hold information about campaign contributors */
17 
18     /*  at initialization, setup the owner */
19     function Crowdsale() {
20         beneficiary = 0xDbe120fD820a0A4cc9E715f0cbD47d94f5c23638;
21         // Token admin address with total supply. Admin must approve transctions!
22         tokenAdmin = 0x934b1498F515E74C6Ec5524A53086e4A02a9F2b8;
23         // Finding goal in ether
24         fundingGoal = 1 * 1 ether;
25         // Length of sale in weeks
26         deadline = now + 5 * 1 weeks;
27         // Price of 1 token in ethers / decimals
28         price = 0.01 / 100 * 1 ether;
29         // Token used as reward address
30         tokenReward = token(0xb16dab600fc05702132602f4922c0e89e2985b9a);
31     }
32 
33     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
34     function () payable {
35         if (crowdsaleClosed) revert();
36         uint amount = msg.value;
37         balanceOf[msg.sender] = amount;
38         amountRaised += amount;
39         tokenReward.transferFrom(tokenAdmin, msg.sender, amount / price);
40         FundTransfer(msg.sender, amount, true);
41     }
42 
43     modifier afterDeadline() { if (now >= deadline) _; }
44 
45     /* checks if the goal or time limit has been reached and ends the campaign */
46     function checkGoalReached() afterDeadline {
47         if (amountRaised >= fundingGoal){
48             fundingGoalReached = true;
49             GoalReached(beneficiary, amountRaised);
50         }
51         crowdsaleClosed = true;
52     }
53 
54     function safeWithdrawal() afterDeadline {
55         if (beneficiary == msg.sender) {
56             if (beneficiary.send(amountRaised)) {
57                 FundTransfer(beneficiary, amountRaised, false);
58             }
59         }
60     }
61 }