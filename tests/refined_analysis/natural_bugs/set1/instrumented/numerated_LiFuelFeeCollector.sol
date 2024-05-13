1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.17;
3 
4 import { LibAsset } from "../Libraries/LibAsset.sol";
5 import { TransferrableOwnership } from "../Helpers/TransferrableOwnership.sol";
6 
7 /// @title LiFuelFeeCollector
8 /// @author LI.FI (https://li.fi)
9 /// @notice Provides functionality for collecting fees for LiFuel
10 /// @custom:version 1.0.1
11 contract LiFuelFeeCollector is TransferrableOwnership {
12     /// Errors ///
13     error TransferFailure();
14     error NotEnoughNativeForFees();
15 
16     /// Events ///
17     event GasFeesCollected(
18         address indexed token,
19         uint256 indexed chainId,
20         address indexed receiver,
21         uint256 feeAmount
22     );
23 
24     event FeesWithdrawn(
25         address indexed token,
26         address indexed to,
27         uint256 amount
28     );
29 
30     /// Constructor ///
31 
32     // solhint-disable-next-line no-empty-blocks
33     constructor(address _owner) TransferrableOwnership(_owner) {}
34 
35     /// External Methods ///
36 
37     /// @notice Collects gas fees
38     /// @param tokenAddress The address of the token to collect
39     /// @param feeAmount The amount of fees to collect
40     /// @param chainId The chain id of the destination chain
41     /// @param receiver The address to send gas to on the destination chain
42     function collectTokenGasFees(
43         address tokenAddress,
44         uint256 feeAmount,
45         uint256 chainId,
46         address receiver
47     ) external {
48         LibAsset.depositAsset(tokenAddress, feeAmount);
49         emit GasFeesCollected(tokenAddress, chainId, receiver, feeAmount);
50     }
51 
52     /// @notice Collects gas fees in native token
53     /// @param chainId The chain id of the destination chain
54     /// @param receiver The address to send gas to on destination chain
55     function collectNativeGasFees(
56         uint256 feeAmount,
57         uint256 chainId,
58         address receiver
59     ) external payable {
60         emit GasFeesCollected(
61             LibAsset.NULL_ADDRESS,
62             chainId,
63             receiver,
64             feeAmount
65         );
66         uint256 amountMinusFees = msg.value - feeAmount;
67         if (amountMinusFees > 0) {
68             (bool success, ) = msg.sender.call{ value: amountMinusFees }("");
69             if (!success) {
70                 revert TransferFailure();
71             }
72         }
73     }
74 
75     /// @notice Withdraws fees
76     /// @param tokenAddress The address of the token to withdraw fees for
77     function withdrawFees(address tokenAddress) external onlyOwner {
78         uint256 balance = LibAsset.getOwnBalance(tokenAddress);
79         LibAsset.transferAsset(tokenAddress, payable(msg.sender), balance);
80         emit FeesWithdrawn(tokenAddress, msg.sender, balance);
81     }
82 
83     /// @notice Batch withdraws fees
84     /// @param tokenAddresses The addresses of the tokens to withdraw fees for
85     function batchWithdrawFees(
86         address[] calldata tokenAddresses
87     ) external onlyOwner {
88         uint256 length = tokenAddresses.length;
89         uint256 balance;
90         for (uint256 i = 0; i < length; ) {
91             balance = LibAsset.getOwnBalance(tokenAddresses[i]);
92             LibAsset.transferAsset(
93                 tokenAddresses[i],
94                 payable(msg.sender),
95                 balance
96             );
97             emit FeesWithdrawn(tokenAddresses[i], msg.sender, balance);
98             unchecked {
99                 ++i;
100             }
101         }
102     }
103 }
