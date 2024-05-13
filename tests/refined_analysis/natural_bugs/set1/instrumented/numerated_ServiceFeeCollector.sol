1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.17;
3 
4 import { LibAsset } from "../Libraries/LibAsset.sol";
5 import { TransferrableOwnership } from "../Helpers/TransferrableOwnership.sol";
6 
7 /// @title Service Fee Collector
8 /// @author LI.FI (https://li.fi)
9 /// @notice Provides functionality for collecting service fees (gas/insurance)
10 /// @custom:version 1.0.1
11 contract ServiceFeeCollector is TransferrableOwnership {
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
24     event InsuranceFeesCollected(
25         address indexed token,
26         address indexed receiver,
27         uint256 feeAmount
28     );
29 
30     event FeesWithdrawn(
31         address indexed token,
32         address indexed to,
33         uint256 amount
34     );
35 
36     /// Constructor ///
37 
38     // solhint-disable-next-line no-empty-blocks
39     constructor(address _owner) TransferrableOwnership(_owner) {}
40 
41     /// External Methods ///
42 
43     /// @notice Collects insurance fees
44     /// @param tokenAddress The address of the token to collect
45     /// @param feeAmount The amount of fees to collect
46     /// @param receiver The address to insure
47     function collectTokenInsuranceFees(
48         address tokenAddress,
49         uint256 feeAmount,
50         address receiver
51     ) external {
52         LibAsset.depositAsset(tokenAddress, feeAmount);
53         emit InsuranceFeesCollected(tokenAddress, receiver, feeAmount);
54     }
55 
56     /// @notice Collects insurance fees in native token
57     /// @param receiver The address to insure
58     function collectNativeInsuranceFees(address receiver) external payable {
59         emit InsuranceFeesCollected(
60             LibAsset.NULL_ADDRESS,
61             receiver,
62             msg.value
63         );
64     }
65 
66     /// @notice Withdraws fees
67     /// @param tokenAddress The address of the token to withdraw fees for
68     function withdrawFees(address tokenAddress) external onlyOwner {
69         uint256 balance = LibAsset.getOwnBalance(tokenAddress);
70         LibAsset.transferAsset(tokenAddress, payable(msg.sender), balance);
71         emit FeesWithdrawn(tokenAddress, msg.sender, balance);
72     }
73 
74     /// @notice Batch withdraws fees
75     /// @param tokenAddresses The addresses of the tokens to withdraw fees for
76     function batchWithdrawFees(
77         address[] calldata tokenAddresses
78     ) external onlyOwner {
79         uint256 length = tokenAddresses.length;
80         uint256 balance;
81         for (uint256 i = 0; i < length; ) {
82             balance = LibAsset.getOwnBalance(tokenAddresses[i]);
83             LibAsset.transferAsset(
84                 tokenAddresses[i],
85                 payable(msg.sender),
86                 balance
87             );
88             emit FeesWithdrawn(tokenAddresses[i], msg.sender, balance);
89             unchecked {
90                 ++i;
91             }
92         }
93     }
94 }
