1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibAsset } from "./LibAsset.sol";
5 import { LibUtil } from "./LibUtil.sol";
6 import { InvalidContract, NoSwapFromZeroBalance, InsufficientBalance } from "../Errors/GenericErrors.sol";
7 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 
9 library LibSwap {
10     struct SwapData {
11         address callTo;
12         address approveTo;
13         address sendingAssetId;
14         address receivingAssetId;
15         uint256 fromAmount;
16         bytes callData;
17         bool requiresDeposit;
18     }
19 
20     event AssetSwapped(
21         bytes32 transactionId,
22         address dex,
23         address fromAssetId,
24         address toAssetId,
25         uint256 fromAmount,
26         uint256 toAmount,
27         uint256 timestamp
28     );
29 
30     function swap(bytes32 transactionId, SwapData calldata _swap) internal {
31         if (!LibAsset.isContract(_swap.callTo)) revert InvalidContract();
32         uint256 fromAmount = _swap.fromAmount;
33         if (fromAmount == 0) revert NoSwapFromZeroBalance();
34         uint256 nativeValue = LibAsset.isNativeAsset(_swap.sendingAssetId)
35             ? _swap.fromAmount
36             : 0;
37         uint256 initialSendingAssetBalance = LibAsset.getOwnBalance(
38             _swap.sendingAssetId
39         );
40         uint256 initialReceivingAssetBalance = LibAsset.getOwnBalance(
41             _swap.receivingAssetId
42         );
43 
44         if (nativeValue == 0) {
45             LibAsset.maxApproveERC20(
46                 IERC20(_swap.sendingAssetId),
47                 _swap.approveTo,
48                 _swap.fromAmount
49             );
50         }
51 
52         if (initialSendingAssetBalance < _swap.fromAmount) {
53             revert InsufficientBalance(
54                 _swap.fromAmount,
55                 initialSendingAssetBalance
56             );
57         }
58 
59         // solhint-disable-next-line avoid-low-level-calls
60         (bool success, bytes memory res) = _swap.callTo.call{
61             value: nativeValue
62         }(_swap.callData);
63         if (!success) {
64             string memory reason = LibUtil.getRevertMsg(res);
65             revert(reason);
66         }
67 
68         uint256 newBalance = LibAsset.getOwnBalance(_swap.receivingAssetId);
69 
70         emit AssetSwapped(
71             transactionId,
72             _swap.callTo,
73             _swap.sendingAssetId,
74             _swap.receivingAssetId,
75             _swap.fromAmount,
76             newBalance > initialReceivingAssetBalance
77                 ? newBalance - initialReceivingAssetBalance
78                 : newBalance,
79             block.timestamp
80         );
81     }
82 }
