1 pragma solidity ^0.5.16;
2 
3 /**
4  * @title Compound's InterestRateModel Interface
5  * @author Compound
6  */
7 contract InterestRateModel {
8     /// @notice Indicator that this is an InterestRateModel contract (for inspection)
9     bool public constant isInterestRateModel = true;
10 
11     /**
12      * @notice Calculates the current borrow interest rate per block
13      * @param cash The total amount of cash the market has
14      * @param borrows The total amount of borrows the market has outstanding
15      * @param reserves The total amnount of reserves the market has
16      * @return The borrow rate per block (as a percentage, and scaled by 1e18)
17      */
18     function getBorrowRate(
19         uint256 cash,
20         uint256 borrows,
21         uint256 reserves
22     ) external view returns (uint256);
23 
24     /**
25      * @notice Calculates the current supply interest rate per block
26      * @param cash The total amount of cash the market has
27      * @param borrows The total amount of borrows the market has outstanding
28      * @param reserves The total amnount of reserves the market has
29      * @param reserveFactorMantissa The current reserve factor the market has
30      * @return The supply rate per block (as a percentage, and scaled by 1e18)
31      */
32     function getSupplyRate(
33         uint256 cash,
34         uint256 borrows,
35         uint256 reserves,
36         uint256 reserveFactorMantissa
37     ) external view returns (uint256);
38 }
