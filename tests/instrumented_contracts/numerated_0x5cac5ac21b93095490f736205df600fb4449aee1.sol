1 pragma solidity ^0.4.11;
2 
3 contract token {function transfer(address receiver, uint amount){ }}
4 
5 contract FazBitsCrowdsale {
6     uint public amountRaised; uint public resAmount; uint public soldTokens;
7     mapping(address => uint256) public balanceOf;
8     event GoalReached(address beneficiary, uint amountRaised);
9     event FundTransfer(address backer, uint amount, bool isContribution);
10     bool public crowdsaleClosed = false;
11     bool public minimumTargetReached = false;
12 
13     // initialization
14     address public beneficiary = 0x89464d51Af1C6edb2E116c28798C9A06e574d299;/*ifSuccessfulSendTo*/
15     uint public price = 0.0015 ether;/*costOfEachToken*/
16     uint public minimumTarget = 100 * price;/*minimumTargetInTokens*/
17     uint public maximumTarget = 250000 * price;/*maximumTargetInTokens*/
18     uint public deadline =  now + 10080 * 1 minutes;/*durationInMinutes*/
19     token public tokenReward = token(0xD8a19038Ca6d75227Ad5a5d7ec335a111ad6E141);/*addressOfTokenUsedAsReward*/
20 
21 
22     // the function without name is the default function that is called whenever anyone sends funds to a contract
23     function () payable {
24         if (crowdsaleClosed || (maximumTarget - amountRaised) < msg.value) throw;
25         uint amount = msg.value;
26         balanceOf[msg.sender] += amount;
27         amountRaised += amount;
28         resAmount += amount;
29         soldTokens += amount / price;
30         tokenReward.transfer(msg.sender, amount / price);
31         FundTransfer(msg.sender, amount, true);
32 
33         if (amountRaised >= minimumTarget && !minimumTargetReached) {
34             minimumTargetReached = true;
35             GoalReached(beneficiary, minimumTarget);
36         }
37 
38         // funds are sending to beneficiary account after minimumTarget will be reached
39         if (minimumTargetReached) {
40             if (beneficiary.send(amount)) {
41                 FundTransfer(beneficiary, amount, false);
42                 resAmount -= amount;
43             }
44         }
45     }
46 
47     // dev function for withdraw any amount from raised funds (activate only if minimumTarget is reached)
48     function devWithdrawal(uint num, uint den) {
49         if (!minimumTargetReached || !(beneficiary == msg.sender)) throw;
50         uint wAmount = num / den;
51         if (beneficiary.send(wAmount)) {
52             FundTransfer(beneficiary, wAmount, false);
53         }
54     }
55 
56     // dev function for withdraw amount, which be reserved by minimumTarget (activate only if minimumTarget is reached)
57     function devResWithdrawal() {
58         if (!minimumTargetReached || !(beneficiary == msg.sender)) throw;
59         if (beneficiary.send(resAmount)) {
60             FundTransfer(beneficiary, resAmount, false);
61             resAmount = 0;
62         }
63     }
64 
65     // dev function for close crowdsale  
66     function closeCrowdsale(bool closeType) {
67          if (beneficiary == msg.sender) {
68             crowdsaleClosed = closeType;
69          }
70     }
71 
72 
73     modifier afterDeadline() { if (now >= deadline) _; }
74 
75     // checks if the minimumTarget has been reached
76     function checkTargetReached() afterDeadline {
77         if (amountRaised >= minimumTarget) {
78             minimumTargetReached = true;
79         }
80     }
81 
82     // function for return non sold tokens to dev account after crowdsale
83     function returnTokens(uint tokensAmount) afterDeadline {
84         if (!crowdsaleClosed) throw;
85         if (beneficiary == msg.sender) {
86             tokenReward.transfer(beneficiary, tokensAmount);
87         }
88     }
89 
90     // return your funds after deadline if minimumTarget is not reached (activate if crowdsale closing)
91     function safeWithdrawal() afterDeadline {
92         if (!minimumTargetReached && crowdsaleClosed) {
93             uint amount = balanceOf[msg.sender];
94             balanceOf[msg.sender] = 0;
95             if (amount > 0) {
96                 if (msg.sender.send(amount)) {
97                     FundTransfer(msg.sender, amount, false);
98                 } else {
99                     balanceOf[msg.sender] = amount;
100                 }
101             }
102         }
103     }
104 }