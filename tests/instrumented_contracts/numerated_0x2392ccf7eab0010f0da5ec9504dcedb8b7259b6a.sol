1 pragma solidity ^0.4.25;
2 
3 contract invest{
4     mapping (address => uint256) invested;
5     mapping (address => uint256) dateInvest;
6     uint constant public FEE = 3;
7     uint constant public ADMIN_FEE = 1;
8     uint constant public REFERRER_FEE = 1;
9     address private owner;
10     address private adminAddr;
11     bool private stopInvest;
12     
13     constructor() public {
14         owner = msg.sender;
15         adminAddr = msg.sender;
16         stopInvest = false;
17     }
18 
19     function () external payable {
20         address sender = msg.sender;
21         
22         require( !stopInvest, "invest stop" );
23         
24         if (invested[sender] != 0) {
25             uint256 amount = getInvestorDividend(sender);
26             if (amount >= address(this).balance){
27                 amount = address(this).balance;
28                 stopInvest = true;
29             }
30             sender.send(amount);
31         }
32 
33         dateInvest[sender] = now;
34         invested[sender] += msg.value;
35 
36         if (msg.value > 0){
37             address ref = bytesToAddress(msg.data);
38             adminAddr.send(msg.value * ADMIN_FEE / 100);
39             if (ref != sender && invested[ref] != 0){
40                 ref.send(msg.value * REFERRER_FEE / 100);
41             }
42         }
43     }
44     
45     function getInvestorDividend(address addr) public view returns(uint256) {
46         return invested[addr] * FEE / 100 * (now - dateInvest[addr]) / 1 days;
47     }
48     
49     function bytesToAddress(bytes bys) private pure returns (address addr) {
50         assembly {
51             addr := mload(add(bys, 20))
52         }
53     }
54     
55 }