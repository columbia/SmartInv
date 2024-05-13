1 // SPDX-License-Identifier: MIT
2 pragma solidity >= 0.6.12;
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9 
10     function approve(address spender, uint256 amount) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15     /// @notice EIP 2612
16     function permit(
17         address owner,
18         address spender,
19         uint256 value,
20         uint256 deadline,
21         uint8 v,
22         bytes32 r,
23         bytes32 s
24     ) external;
25 }
26 interface ISwapperGeneric {
27     /// @notice Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
28     /// Swaps it for at least 'amountToMin' of token 'to'.
29     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
30     /// Returns the amount of tokens 'to' transferred to BentoBox.
31     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
32     function swap(
33         IERC20 fromToken,
34         IERC20 toToken,
35         address recipient,
36         uint256 shareToMin,
37         uint256 shareFrom
38     ) external returns (uint256 extraShare, uint256 shareReturned);
39 
40     /// @notice Calculates the amount of token 'from' needed to complete the swap (amountFrom),
41     /// this should be less than or equal to amountFromMax.
42     /// Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
43     /// Swaps it for exactly 'exactAmountTo' of token 'to'.
44     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
45     /// Transfers allocated, but unused 'from' tokens within the BentoBox to 'refundTo' (amountFromMax - amountFrom).
46     /// Returns the amount of 'from' tokens withdrawn from BentoBox (amountFrom).
47     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
48     function swapExact(
49         IERC20 fromToken,
50         IERC20 toToken,
51         address recipient,
52         address refundTo,
53         uint256 shareFromSupplied,
54         uint256 shareToExact
55     ) external returns (uint256 shareUsed, uint256 shareReturned);
56 }
