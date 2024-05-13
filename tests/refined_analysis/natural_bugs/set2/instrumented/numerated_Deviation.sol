1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {Constants} from "./../Constants.sol";
5 import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
6 
7 /// @title contract that determines whether or not a new value is within
8 /// an acceptable deviation threshold
9 /// @author Elliot Friedman, FEI Protocol
10 library Deviation {
11     using SafeCast for *;
12 
13     /// @notice event that is emitted when the threshold is changed
14     event DeviationThresholdUpdate(uint256 oldThreshold, uint256 newThreshold);
15 
16     /// @notice return the percent deviation between a and b in basis points terms
17     function calculateDeviationThresholdBasisPoints(int256 a, int256 b) internal pure returns (uint256) {
18         int256 delta = a - b;
19         int256 basisPoints = (delta * Constants.BP_INT) / a;
20 
21         return (basisPoints < 0 ? basisPoints * -1 : basisPoints).toUint256();
22     }
23 
24     /// @notice function to return whether or not the new price is within
25     /// the acceptable deviation threshold
26     function isWithinDeviationThreshold(
27         uint256 maxDeviationThresholdBasisPoints,
28         int256 oldValue,
29         int256 newValue
30     ) internal pure returns (bool) {
31         return maxDeviationThresholdBasisPoints >= calculateDeviationThresholdBasisPoints(oldValue, newValue);
32     }
33 }
