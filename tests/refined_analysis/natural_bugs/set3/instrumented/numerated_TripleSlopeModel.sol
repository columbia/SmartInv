1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
5 
6 
7 contract TripleSlopeModel {
8     using SafeMath for uint;
9 
10     /// @dev Return the interest rate per second, using 1e18 as denom.
11     function getInterestRate(uint debt, uint floating) external pure returns (uint) {
12         uint total = debt.add(floating);
13         if (total == 0) return 0;
14 
15         uint utilization = debt.mul(10000).div(total);
16         if (utilization < 5000) {
17             // Less than 50% utilization - 10% APY
18             return uint(10e16) / 365 days;
19         } else if (utilization < 9500) {
20             // Between 50% and 95% - 10%-25% APY
21             return (10e16 + utilization.sub(5000).mul(15e16).div(4500)) / 365 days;
22         } else if (utilization < 10000) {
23             // Between 95% and 100% - 25%-100% APY
24             return (25e16 + utilization.sub(9500).mul(75e16).div(500)) / 365 days;
25         } else {
26             // Not possible, but just in case - 100% APY
27             return uint(100e16) / 365 days;
28         }
29     }
30 }
