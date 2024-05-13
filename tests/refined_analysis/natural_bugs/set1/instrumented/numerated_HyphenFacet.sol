1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IHyphenRouter } from "../Interfaces/IHyphenRouter.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 
11 /// @title Hyphen Facet
12 /// @author LI.FI (https://li.fi)
13 /// @notice Provides functionality for bridging through Hyphen
14 /// @custom:version 1.0.0
15 contract HyphenFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
16     /// Storage ///
17 
18     /// @notice The contract address of the router on the source chain.
19     IHyphenRouter private immutable router;
20 
21     /// Constructor ///
22 
23     /// @notice Initialize the contract.
24     /// @param _router The contract address of the router on the source chain.
25     constructor(IHyphenRouter _router) {
26         router = _router;
27     }
28 
29     /// External Methods ///
30 
31     /// @notice Bridges tokens via Hyphen
32     /// @param _bridgeData the core information needed for bridging
33     function startBridgeTokensViaHyphen(
34         ILiFi.BridgeData memory _bridgeData
35     )
36         external
37         payable
38         nonReentrant
39         refundExcessNative(payable(msg.sender))
40         doesNotContainSourceSwaps(_bridgeData)
41         doesNotContainDestinationCalls(_bridgeData)
42         validateBridgeData(_bridgeData)
43     {
44         LibAsset.depositAsset(
45             _bridgeData.sendingAssetId,
46             _bridgeData.minAmount
47         );
48         _startBridge(_bridgeData);
49     }
50 
51     /// @notice Performs a swap before bridging via Hyphen
52     /// @param _bridgeData the core information needed for bridging
53     /// @param _swapData an array of swap related data for performing swaps before bridging
54     function swapAndStartBridgeTokensViaHyphen(
55         ILiFi.BridgeData memory _bridgeData,
56         LibSwap.SwapData[] calldata _swapData
57     )
58         external
59         payable
60         nonReentrant
61         refundExcessNative(payable(msg.sender))
62         containsSourceSwaps(_bridgeData)
63         doesNotContainDestinationCalls(_bridgeData)
64         validateBridgeData(_bridgeData)
65     {
66         _bridgeData.minAmount = _depositAndSwap(
67             _bridgeData.transactionId,
68             _bridgeData.minAmount,
69             _swapData,
70             payable(msg.sender)
71         );
72         _startBridge(_bridgeData);
73     }
74 
75     /// Private Methods ///
76 
77     /// @dev Contains the business logic for the bridge via Hyphen
78     /// @param _bridgeData the core information needed for bridging
79     function _startBridge(ILiFi.BridgeData memory _bridgeData) private {
80         if (!LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
81             // Give the Hyphen router approval to bridge tokens
82             LibAsset.maxApproveERC20(
83                 IERC20(_bridgeData.sendingAssetId),
84                 address(router),
85                 _bridgeData.minAmount
86             );
87 
88             router.depositErc20(
89                 _bridgeData.destinationChainId,
90                 _bridgeData.sendingAssetId,
91                 _bridgeData.receiver,
92                 _bridgeData.minAmount,
93                 "LIFI"
94             );
95         } else {
96             router.depositNative{ value: _bridgeData.minAmount }(
97                 _bridgeData.receiver,
98                 _bridgeData.destinationChainId,
99                 "LIFI"
100             );
101         }
102 
103         emit LiFiTransferStarted(_bridgeData);
104     }
105 }
