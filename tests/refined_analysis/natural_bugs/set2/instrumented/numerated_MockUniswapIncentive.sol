1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockIncentive.sol";
5 import "../external/Decimal.sol";
6 
7 contract MockUniswapIncentive is MockIncentive {
8     constructor(address core) MockIncentive(core) {}
9 
10     bool public isParity = false;
11     bool public isExempt = false;
12 
13     function incentivize(
14         address sender,
15         address recipient,
16         address,
17         uint256
18     ) public override {
19         if (!isExempt) {
20             super.incentivize(sender, recipient, address(0), 0);
21         }
22     }
23 
24     function isIncentiveParity() external view returns (bool) {
25         return isParity;
26     }
27 
28     function setIncentiveParity(bool _isParity) public {
29         isParity = _isParity;
30     }
31 
32     function isExemptAddress(address) public view returns (bool) {
33         return isExempt;
34     }
35 
36     function setExempt(bool exempt) public {
37         isExempt = exempt;
38     }
39 
40     function updateOracle() external pure returns (bool) {
41         return true;
42     }
43 
44     function setExemptAddress(address account, bool _isExempt) external {}
45 
46     function getBuyIncentive(uint256 amount)
47         external
48         pure
49         returns (
50             uint256,
51             uint32 weight,
52             Decimal.D256 memory initialDeviation,
53             Decimal.D256 memory finalDeviation
54         )
55     {
56         return ((amount * 10) / 100, weight, initialDeviation, finalDeviation);
57     }
58 
59     function getSellPenalty(uint256 amount)
60         external
61         pure
62         returns (
63             uint256,
64             Decimal.D256 memory initialDeviation,
65             Decimal.D256 memory finalDeviation
66         )
67     {
68         return ((amount * 10) / 100, initialDeviation, finalDeviation);
69     }
70 }
