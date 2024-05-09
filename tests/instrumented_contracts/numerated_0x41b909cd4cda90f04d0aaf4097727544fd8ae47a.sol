1 pragma solidity ^0.4.19;
2 
3 /* taking ideas from OpenZeppelin, thanks */
4 contract SafeMath {
5     function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {
6         uint256 z = x + y;
7         assert((z >= x) && (z >= y));
8         return z;
9     }
10 
11     function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
12         assert(x >= y);
13         return x - y;
14     }
15 
16     function safeMin256(uint256 x, uint256 y) internal pure returns (uint256) {
17         return x < y ? x : y;
18     }
19 }
20 
21 contract XCTCrowdSale is SafeMath {
22     //crowdsale parameters
23     address public beneficiary;
24     uint256 public startBlock = 4969760;
25     uint256 public constant hardCap = 4000 ether; 
26     uint256 public amountRaised;
27 
28     function XCTCrowdSale(address _beneficiary) public {
29         beneficiary = _beneficiary;
30         amountRaised = 0;
31     }
32 
33     modifier inProgress() {
34       require(block.number >= startBlock);
35       require(amountRaised < hardCap);
36       _;
37     }
38 
39     //fund raising
40     function() public payable {
41         fundRaising();
42     }
43 
44     function fundRaising() public payable inProgress {
45         require(msg.value >= 15 ether && msg.value <= 50 ether);
46         uint256 contribution = safeMin256(msg.value, safeSub(hardCap, amountRaised));
47         amountRaised = safeAdd(amountRaised, contribution);
48 
49         //send to XChain Team
50         beneficiary.transfer(contribution);
51 
52         // Refund the msg.sender, in the case that not all of its ETH was used.
53         if (contribution != msg.value) {
54             uint256 overpay = safeSub(msg.value, contribution);
55             msg.sender.transfer(overpay);
56         }
57     }
58 }