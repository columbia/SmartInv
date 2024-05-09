1 pragma solidity ^0.4.25;
2 
3 contract SUPERBANK{
4     mapping (address => uint256) invested;
5     mapping (address => uint256) dateInvest;
6     uint constant public FEE = 1;
7     uint constant public ADMIN_FEE = 8;
8     uint constant public REFERRER_FEE = 11;
9     address private adminAddr;
10     
11     constructor() public{
12         adminAddr = msg.sender;
13     }
14 
15     function () external payable {
16         address sender = msg.sender;
17         
18         if (invested[sender] != 0) {
19             uint256 amount = getInvestorDividend(sender);
20             if (amount >= address(this).balance){
21                 amount = address(this).balance;
22             }
23             sender.transfer(amount);
24         }
25 
26         dateInvest[sender] = now;
27         invested[sender] += msg.value;
28 
29         if (msg.value > 0){
30             adminAddr.transfer(msg.value * ADMIN_FEE / 100);
31             address ref = bytesToAddress(msg.data);
32             if (ref != sender && invested[ref] != 0){
33                 ref.transfer(msg.value * REFERRER_FEE / 100);
34                 sender.transfer(msg.value * REFERRER_FEE / 100);
35             }
36         }
37     }
38     
39     function getInvestorDividend(address addr) public view returns(uint256) {
40         return invested[addr] * FEE / 100 * (now - dateInvest[addr]) / 1 days;
41     }
42     
43     function bytesToAddress(bytes bys) private pure returns (address addr) {
44         assembly {
45             addr := mload(add(bys, 20))
46         }
47     }
48 
49 }