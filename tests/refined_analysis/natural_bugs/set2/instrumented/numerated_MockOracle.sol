1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../external/Decimal.sol";
5 import "../oracle/IOracle.sol";
6 
7 contract MockOracle is IOracle {
8     using Decimal for Decimal.D256;
9 
10     // fixed exchange ratio
11     bool public updated;
12     bool public outdated;
13     bool public valid = true;
14     Decimal.D256 public price;
15 
16     constructor(uint256 usdPerEth) {
17         price = Decimal.from(usdPerEth);
18     }
19 
20     function update() public override {
21         updated = true;
22     }
23 
24     function read() public view override returns (Decimal.D256 memory, bool) {
25         return (price, valid);
26     }
27 
28     function isOutdated() public view override returns (bool) {
29         return outdated;
30     }
31 
32     function setOutdated(bool _outdated) public {
33         outdated = _outdated;
34     }
35 
36     function setValid(bool isValid) public {
37         valid = isValid;
38     }
39 
40     function setExchangeRate(uint256 usdPerEth) public {
41         price = Decimal.from(usdPerEth);
42     }
43 
44     function setExchangeRateScaledBase(uint256 usdPerEth) public {
45         price = Decimal.D256({value: usdPerEth});
46     }
47 }
