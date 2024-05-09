1 pragma solidity ^0.4.8;
2 
3 contract token {function transfer(address receiver, uint amount){ }}
4 
5 contract Crowdsale {
6     mapping(address => uint256) public balanceOf;
7 
8     uint public amountRaised; uint public tokensCounter; uint tokensForSending; uint public price;
9 
10     token public tokenReward = token(0x9bB7Eb467eB11193966e726f3397d27136E79eb2);
11     address public beneficiary = 0xA4047af02a2Fd8e6BB43Cfe8Ab25292aC52c73f4;
12     bool public crowdsaleClosed = true;
13     bool public admin = false;
14 
15     event FundTransfer(address backer, uint amount, bool isContribution);
16 
17 
18     function discount() returns (uint) {
19         if (amountRaised > 70000 ether) {
20             return 0.000000067 ether;
21         } else if (amountRaised > 30000 ether) {
22             return 0.000000050 ether;
23         } else if (amountRaised > 10000 ether) {
24             return 0.000000040 ether;
25         }
26         return 0.0000000333 ether;
27     }
28 
29     function allTimeDiscount(uint msg_value) returns (uint) {
30         if (msg_value >= 300 ether) {
31             return 80;
32         } else if (msg_value >= 100 ether) {
33             return 85;
34         }
35         return 100;
36     }
37 
38     function () payable {
39         uint amount = msg.value;
40         if (crowdsaleClosed || amount < 0.1 ether) throw;
41         price = discount();
42         balanceOf[msg.sender] += amount;
43         amountRaised += amount;
44         tokensForSending = amount / ((price * allTimeDiscount(amount)) / 100);
45         tokenReward.transfer(msg.sender, tokensForSending);
46         tokensCounter += tokensForSending;
47         FundTransfer(msg.sender, amount, true);
48         if (beneficiary.send(amount)) {
49             FundTransfer(beneficiary, amount, false);
50         }
51     }
52 
53     function closeCrowdsale(bool closeType){
54         if (beneficiary == msg.sender) {
55             crowdsaleClosed = closeType;
56         }
57         else {
58             throw;
59         }
60     }
61 
62     function getUnsoldTokensVal(uint val_) {
63         if (beneficiary == msg.sender) {
64             tokenReward.transfer(beneficiary, val_);
65         }
66         else {
67             throw;
68         }
69     }
70     
71     function checkAdmin() {
72         if (beneficiary == msg.sender) {
73             admin =  true;
74         }
75         else {
76             throw;
77         }
78     }
79 }