1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IThorSwap } from "../Interfaces/IThorSwap.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { SwapperV2 } from "../Helpers/SwapperV2.sol";
8 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 import { LibSwap } from "../Libraries/LibSwap.sol";
11 
12 /// @title ThorSwap Facet
13 /// @author Li.Finance (https://li.finance)
14 /// @notice Provides functionality for bridging through ThorSwap
15 /// @custom:version 1.0.0
16 contract ThorSwapFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
17     address private immutable thorchainRouter;
18 
19     /// @notice The struct for the ThorSwap data.
20     /// @param vault The Thorchain vault address
21     /// @param memo The memo to send to Thorchain for the swap
22     /// @param expiration The expiration time for the swap
23     struct ThorSwapData {
24         address vault;
25         string memo;
26         uint256 expiration;
27     }
28 
29     /// @notice Initializes the ThorSwap contract
30     constructor(address _thorchainRouter) {
31         thorchainRouter = _thorchainRouter;
32     }
33 
34     /// @notice Bridge tokens to another chain via ThorSwap
35     /// @param _bridgeData The bridge data struct
36     /// @param _thorSwapData The ThorSwap data struct
37     function startBridgeTokensViaThorSwap(
38         ILiFi.BridgeData memory _bridgeData,
39         ThorSwapData calldata _thorSwapData
40     )
41         external
42         payable
43         nonReentrant
44         refundExcessNative(payable(msg.sender))
45         validateBridgeData(_bridgeData)
46         doesNotContainSourceSwaps(_bridgeData)
47         doesNotContainDestinationCalls(_bridgeData)
48     {
49         LibAsset.depositAsset(
50             _bridgeData.sendingAssetId,
51             _bridgeData.minAmount
52         );
53         _startBridge(_bridgeData, _thorSwapData);
54     }
55 
56     /// @notice Bridge tokens to another chain via ThorSwap
57     /// @param _bridgeData The bridge data struct
58     /// @param _swapData The swap data struct
59     /// @param _thorSwapData The ThorSwap data struct
60     function swapAndStartBridgeTokensViaThorSwap(
61         ILiFi.BridgeData memory _bridgeData,
62         LibSwap.SwapData[] calldata _swapData,
63         ThorSwapData calldata _thorSwapData
64     )
65         external
66         payable
67         nonReentrant
68         refundExcessNative(payable(msg.sender))
69         containsSourceSwaps(_bridgeData)
70         doesNotContainDestinationCalls(_bridgeData)
71         validateBridgeData(_bridgeData)
72     {
73         _bridgeData.minAmount = _depositAndSwap(
74             _bridgeData.transactionId,
75             _bridgeData.minAmount,
76             _swapData,
77             payable(msg.sender)
78         );
79         _startBridge(_bridgeData, _thorSwapData);
80     }
81 
82     /// @notice Bridge tokens to another chain via ThorSwap
83     /// @param _bridgeData The bridge data struct
84     /// @param _thorSwapData The thorSwap data struct for ThorSwap specicific data
85     function _startBridge(
86         ILiFi.BridgeData memory _bridgeData,
87         ThorSwapData calldata _thorSwapData
88     ) internal {
89         IERC20 sendingAssetId = IERC20(_bridgeData.sendingAssetId);
90         bool isNative = LibAsset.isNativeAsset(address(sendingAssetId));
91 
92         if (!isNative) {
93             LibAsset.maxApproveERC20(
94                 sendingAssetId,
95                 thorchainRouter,
96                 _bridgeData.minAmount
97             );
98         }
99         IThorSwap(thorchainRouter).depositWithExpiry{
100             value: isNative ? _bridgeData.minAmount : 0
101         }(
102             _thorSwapData.vault,
103             _bridgeData.sendingAssetId,
104             _bridgeData.minAmount,
105             _thorSwapData.memo,
106             _thorSwapData.expiration
107         );
108 
109         emit LiFiTransferStarted(_bridgeData);
110     }
111 }
