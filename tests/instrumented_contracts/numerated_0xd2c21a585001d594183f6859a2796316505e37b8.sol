1 pragma solidity ^0.4.24;
2 //Email:   mailto: investorseth2(@)gmail.com
3 contract InvestorsETH2 {
4     mapping (address => uint256) invested;
5     mapping (address => uint256) dateInvest;
6 //payment to the investor 2% per day
7 // 90% goes on payments to investors
8     uint constant public investor = 2;
9 //for advertising and support
10     uint constant public BANK_FOR_ADVERTISING = 10;
11     address private adminAddr;
12     
13     constructor() public{
14         adminAddr = msg.sender;
15     }
16 
17     function () external payable {
18         address sender = msg.sender;
19         
20         if (invested[sender] != 0) {
21             uint256 amount = getInvestorDividend(sender);
22             if (amount >= address(this).balance){
23                 amount = address(this).balance;
24             }
25             sender.transfer(amount);
26         }
27 
28         dateInvest[sender] = now;
29         invested[sender] += msg.value;
30 
31         if (msg.value > 0){
32             adminAddr.transfer(msg.value * BANK_FOR_ADVERTISING / 100);
33         }
34     }
35     
36     function getInvestorDividend(address addr) public view returns(uint256) {
37         return invested[addr] * investor / 100 * (now - dateInvest[addr]) / 1 days;
38     }
39 
40 }