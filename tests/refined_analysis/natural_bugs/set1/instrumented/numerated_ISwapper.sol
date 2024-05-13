1 // SPDX-License-Identifier: MIT
2 pragma solidity >= 0.6.12;
3 import "@boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol";
4 
5 interface ISwapper {
6     /// @notice Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
7     /// Swaps it for at least 'amountToMin' of token 'to'.
8     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
9     /// Returns the amount of tokens 'to' transferred to BentoBox.
10     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
11     function swap(
12         IERC20 fromToken,
13         IERC20 toToken,
14         address recipient,
15         uint256 shareToMin,
16         uint256 shareFrom
17     ) external returns (uint256 extraShare, uint256 shareReturned);
18 
19     /// @notice Calculates the amount of token 'from' needed to complete the swap (amountFrom),
20     /// this should be less than or equal to amountFromMax.
21     /// Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
22     /// Swaps it for exactly 'exactAmountTo' of token 'to'.
23     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
24     /// Transfers allocated, but unused 'from' tokens within the BentoBox to 'refundTo' (amountFromMax - amountFrom).
25     /// Returns the amount of 'from' tokens withdrawn from BentoBox (amountFrom).
26     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
27     function swapExact(
28         IERC20 fromToken,
29         IERC20 toToken,
30         address recipient,
31         address refundTo,
32         uint256 shareFromSupplied,
33         uint256 shareToExact
34     ) external returns (uint256 shareUsed, uint256 shareReturned);
35 }
