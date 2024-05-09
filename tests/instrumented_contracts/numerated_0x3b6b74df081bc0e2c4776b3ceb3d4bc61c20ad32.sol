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
11     bool public crowdsaleClosed = true;
12     bool public minimumTargetReached = false;
13 
14     // initialization
15     address public beneficiary = 0x35A9dd5a6b59eE5e28FC519802A468379573af39;/*ifSuccessfulSendTo*/
16     uint public price = 0.0015 ether;/*costOfEachToken*/
17     uint public minimumTarget = 10 * price;/*minimumTargetInTokens*/
18     uint public maximumTarget = 1000 * price;/*maximumTargetInTokens*/
19     uint public deadline =  now + 1440 * 1 minutes;/*durationInMinutes*/
20     token public tokenReward = token(0x2Fd8019ce2AAc3bf9DB18D851A57EFe1a6151BBF);/*addressOfTokenUsedAsReward*/
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
54             resAmount -= wAmount;
55         }
56     }
57 
58     // dev function for withdraw amount, which be reserved by minimumTarget (activate only if minimumTarget is reached)
59     function devResWithdrawal() {
60         if (!minimumTargetReached || !(beneficiary == msg.sender)) throw;
61         if (beneficiary.send(resAmount)) {
62             FundTransfer(beneficiary, resAmount, false);
63             resAmount -= resAmount;
64         }
65     }
66 
67     // dev function for close crowdsale  
68     function closeCrowdsale(bool closeType) {
69          if (beneficiary == msg.sender) {
70             crowdsaleClosed = closeType;
71          }
72     }
73 
74 
75     modifier afterDeadline() { if (now >= deadline) _; }
76 
77     // checks if the minimumTarget has been reached
78     function checkTargetReached() afterDeadline {
79         if (amountRaised >= minimumTarget) {
80             minimumTargetReached = true;
81         }
82     }
83 
84     // function for return non sold tokens to dev account after crowdsale
85     function returnTokens(uint tokensAmount) afterDeadline {
86         if (!crowdsaleClosed) throw;
87         if (beneficiary == msg.sender) {
88             tokenReward.transfer(beneficiary, tokensAmount);
89         }
90     }
91 
92     // return your funds after deadline if minimumTarget is not reached (activate if crowdsale close)
93     function safeWithdrawal() afterDeadline {
94         if (!crowdsaleClosed) throw;
95         if (!minimumTargetReached && crowdsaleClosed) {
96             uint amount = balanceOf[msg.sender];
97             balanceOf[msg.sender] = 0;
98             if (amount > 0) {
99                 if (msg.sender.send(amount)) {
100                     FundTransfer(msg.sender, amount, false);
101                     resAmount -= amount;
102                 } else {
103                     balanceOf[msg.sender] = amount;
104                 }
105             }
106         }
107     }
108 }