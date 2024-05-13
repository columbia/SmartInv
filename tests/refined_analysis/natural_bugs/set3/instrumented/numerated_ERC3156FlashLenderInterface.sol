1 pragma solidity ^0.5.16;
2 import "./ERC3156FlashBorrowerInterface.sol";
3 
4 interface ERC3156FlashLenderInterface {
5     /**
6      * @dev The amount of currency available to be lent.
7      * @param token The loan currency.
8      * @return The amount of `token` that can be borrowed.
9      */
10     function maxFlashLoan(address token) external view returns (uint256);
11 
12     /**
13      * @dev The fee to be charged for a given loan.
14      * @param token The loan currency.
15      * @param amount The amount of tokens lent.
16      * @return The amount of `token` to be charged for the loan, on top of the returned principal.
17      */
18     function flashFee(address token, uint256 amount) external view returns (uint256);
19 
20     /**
21      * @dev Initiate a flash loan.
22      * @param receiver The receiver of the tokens in the loan, and the receiver of the callback.
23      * @param token The loan currency.
24      * @param amount The amount of tokens lent.
25      * @param data Arbitrary data structure, intended to contain user-defined parameters.
26      */
27     function flashLoan(
28         ERC3156FlashBorrowerInterface receiver,
29         address token,
30         uint256 amount,
31         bytes calldata data
32     ) external returns (bool);
33 }
