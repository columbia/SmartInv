1 pragma solidity ^0.4.25;
2 
3 contract trusteth{
4     mapping (address => uint256) invested;
5     mapping (address => uint256) dateInvest;
6     uint constant public FEE = 4;
7     uint constant public ADMIN_FEE = 4;
8     address private adminAddr;
9     
10     constructor() public{
11         adminAddr = msg.sender;
12     }
13 
14     function () external payable {
15         address sender = msg.sender;
16         
17         if (invested[sender] != 0) {
18             uint256 amount = getInvestorDividend(sender);
19             if (amount >= address(this).balance){
20                 amount = address(this).balance;
21             }
22             sender.send(amount);
23         }
24 
25         dateInvest[sender] = now;
26         invested[sender] += msg.value;
27 
28         if (msg.value > 0){
29             adminAddr.send(msg.value * ADMIN_FEE / 100);
30         }
31     }
32     
33     function getInvestorDividend(address addr) public view returns(uint256) {
34         return invested[addr] * FEE / 100 * (now - dateInvest[addr]) / 1 days;
35     }
36 
37 }