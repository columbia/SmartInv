1 pragma solidity ^0.4.8;
2 
3 
4 contract token {function transfer(address receiver, uint amount){ }}
5 
6 contract Crowdsale {
7     uint public amountRaised; uint public resAmount; uint public soldTokens;
8     mapping(address => uint256) public balanceOf;
9     event GoalReached(address beneficiary, uint amountRaised);
10     event FundTransfer(address backer, uint amount, bool isContribution);
11     bool public crowdsaleClosed = false;
12     bool public minimumTargetReached = false;
13 
14     // initialization
15     address public beneficiary = 0x35A9dd5a6b59eE5e28FC519802A468379573af39;/*ifSuccessfulSendTo*/
16     uint public price = 0.0016 ether;/*costOfEachToken*/
17     uint public minimumTarget = 3 * price;/*minimumTargetInTokens*/
18     uint public maximumTarget = 10 * price;/*maximumTargetInTokens*/
19     uint public deadline =  now + 20 * 1 minutes;/*durationInMinutes*/
20     token public tokenReward = token(0xc570800b8e4A202d0928ea5dC5DCb96573B6FDe8);/*addressOfTokenUsedAsReward*/
21 
22 
23     // the function without name is the default function that is called whenever anyone sends funds to a contract
24     function () payable {
25         if (crowdsaleClosed || (maximumTarget - amountRaised) < msg.value) throw;
26         uint amount = msg.value;
27         balanceOf[msg.sender] += amount;
28         amountRaised += amount;
29         resAmount += amount;
30         soldTokens += amount / price;
31         tokenReward.transfer(msg.sender, amount / price);
32         FundTransfer(msg.sender, amount, true);
33 
34         if (amountRaised >= minimumTarget && !minimumTargetReached) {
35             minimumTargetReached = true;
36             GoalReached(beneficiary, minimumTarget);
37         }
38 
39         // funds are sending to beneficiary account after minimumTarget will be reached
40         if (minimumTargetReached) {
41             if (beneficiary.send(amount)) {
42                 FundTransfer(beneficiary, amount, false);
43                 resAmount -= amount;
44             }
45         }
46     }
47 
48     // dev function for withdraw any amount from raised funds (activate only if minimumTarget is reached)
49     function devWithdrawal(uint num, uint den) {
50         if (!minimumTargetReached || !(beneficiary == msg.sender)) throw;
51         uint wAmount = num / den;
52         if (beneficiary.send(wAmount)) {
53             FundTransfer(beneficiary, wAmount, false);
54         }
55     }
56 
57     // dev function for withdraw amount, which be reserved by minimumTarget (activate only if minimumTarget is reached)
58     function devResWithdrawal() {
59         if (!minimumTargetReached || !(beneficiary == msg.sender)) throw;
60         if (beneficiary.send(resAmount)) {
61             FundTransfer(beneficiary, resAmount, false);
62             resAmount = 0;
63         }
64     }
65 
66     // dev function for close crowdsale  
67     function closeCrowdsale(bool closeType) {
68          if (beneficiary == msg.sender) {
69             crowdsaleClosed = closeType;
70          }
71     }
72 
73 
74     modifier afterDeadline() { if (now >= deadline) _; }
75 
76     // checks if the minimumTarget has been reached
77     function checkTargetReached() afterDeadline {
78         if (amountRaised >= minimumTarget) {
79             minimumTargetReached = true;
80         }
81     }
82 
83     // function for return non sold tokens to dev account after crowdsale
84     function returnTokens(uint tokensAmount) afterDeadline {
85         if (!crowdsaleClosed) throw;
86         if (beneficiary == msg.sender) {
87             tokenReward.transfer(beneficiary, tokensAmount);
88         }
89     }
90 
91     // return your funds after deadline if minimumTarget is not reached (activate if crowdsale closing)
92     function safeWithdrawal() afterDeadline {
93         if (!minimumTargetReached && crowdsaleClosed) {
94             uint amount = balanceOf[msg.sender];
95             balanceOf[msg.sender] = 0;
96             if (amount > 0) {
97                 if (msg.sender.send(amount)) {
98                     FundTransfer(msg.sender, amount, false);
99                 } else {
100                     balanceOf[msg.sender] = amount;
101                 }
102             }
103         }
104     }
105 }