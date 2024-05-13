1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../external/Decimal.sol";
5 
6 contract MockBondingCurve {
7     bool public atScale;
8     bool public allocated;
9     Decimal.D256 public getCurrentPrice;
10 
11     constructor(bool _atScale, uint256 price) {
12         setScale(_atScale);
13         setCurrentPrice(price);
14     }
15 
16     function setScale(bool _atScale) public {
17         atScale = _atScale;
18     }
19 
20     function setCurrentPrice(uint256 price) public {
21         getCurrentPrice = Decimal.ratio(price, 100);
22     }
23 
24     function allocate() public payable {
25         allocated = true;
26     }
27 
28     function purchase(address, uint256) public payable returns (uint256 amountOut) {
29         return 1;
30     }
31 
32     function getAmountOut(uint256 amount) public pure returns (uint256) {
33         return 10 * amount;
34     }
35 
36     function getAverageUSDPrice(uint256) public view returns (Decimal.D256 memory) {
37         return getCurrentPrice;
38     }
39 }
