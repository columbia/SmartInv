1 pragma solidity ^0.5.16;
2 
3 interface ERC3156FlashBorrowerInterface {
4     /**
5      * @dev Receive a flash loan.
6      * @param initiator The initiator of the loan.
7      * @param token The loan currency.
8      * @param amount The amount of tokens lent.
9      * @param fee The additional amount of tokens to repay.
10      * @param data Arbitrary data structure, intended to contain user-defined parameters.
11      * @return The keccak256 hash of "ERC3156FlashBorrower.onFlashLoan"
12      */
13     function onFlashLoan(
14         address initiator,
15         address token,
16         uint256 amount,
17         uint256 fee,
18         bytes calldata data
19     ) external returns (bytes32);
20 }
