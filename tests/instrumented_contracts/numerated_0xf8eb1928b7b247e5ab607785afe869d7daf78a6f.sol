1 pragma solidity ^0.4.8;
2 
3 contract token {function transfer(address receiver, uint amount){ }}
4 
5 contract Crowdsale {
6     mapping(address => uint256) public balanceOf;
7 
8     uint public amountRaised; uint public tokensCounter; uint tokensForSending;
9 
10     token public tokenReward = token(0x9bB7Eb467eB11193966e726f3397d27136E79eb2);
11     address public beneficiary = 0xA4047af02a2Fd8e6BB43Cfe8Ab25292aC52c73f4;
12     bool public crowdsaleClosed = true;
13     bool public admin = false;
14     uint public price = 0.0000000333 ether;
15 
16     event FundTransfer(address backer, uint amount, bool isContribution);
17 
18 
19     function () payable {
20         uint amount = msg.value;
21         if (crowdsaleClosed || amount < 0.1 ether) throw;
22         balanceOf[msg.sender] += amount;
23         amountRaised += amount;
24         tokensForSending = amount / price;
25         tokenReward.transfer(msg.sender, tokensForSending);
26         tokensCounter += tokensForSending;
27         FundTransfer(msg.sender, amount, true);
28         if (beneficiary.send(amount)) {
29             FundTransfer(beneficiary, amount, false);
30         }
31     }
32 
33     function closeCrowdsale(bool closeType){
34         if (beneficiary == msg.sender) {
35             crowdsaleClosed = closeType;
36         }
37         else {
38             throw;
39         }
40     }
41 
42     function getUnsoldTokensVal(uint val_) {
43         if (beneficiary == msg.sender) {
44             tokenReward.transfer(beneficiary, val_);
45         }
46         else {
47             throw;
48         }
49     }
50     
51     function checkAdmin() {
52         if (beneficiary == msg.sender) {
53             admin =  true;
54         }
55         else {
56             throw;
57         }
58     }
59 }