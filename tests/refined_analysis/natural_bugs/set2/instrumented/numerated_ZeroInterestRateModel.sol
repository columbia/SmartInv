1 pragma solidity ^0.8.4;
2 
3 /**
4  * @title Compound's InterestRateModel which always returns 0
5  * @author Fei Protocol
6  */
7 contract ZeroInterestRateModel {
8     /// @notice Indicator that this is an InterestRateModel contract (for inspection)
9     bool public constant isInterestRateModel = true;
10 
11     /**
12      * @notice Calculates the current borrow interest rate per block
13      * @return The borrow rate per block (as a percentage, and scaled by 1e18)
14      */
15     function getBorrowRate(
16         uint256,
17         uint256,
18         uint256
19     ) external pure returns (uint256) {
20         return 0;
21     }
22 
23     /**
24      * @notice Calculates the current supply interest rate per block
25      * @return The supply rate per block (as a percentage, and scaled by 1e18)
26      */
27     function getSupplyRate(
28         uint256,
29         uint256,
30         uint256,
31         uint256
32     ) external pure returns (uint256) {
33         return 0;
34     }
35 }
