1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { ISymbiosisMetaRouter } from "../Interfaces/ISymbiosisMetaRouter.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 
11 /// @title Symbiosis Facet
12 /// @author Symbiosis (https://symbiosis.finance)
13 /// @notice Provides functionality for bridging through Symbiosis Protocol
14 /// @custom:version 1.0.0
15 contract SymbiosisFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
16     /// Storage ///
17 
18     /// @notice The contract address of the Symbiosis router on the source chain
19     ISymbiosisMetaRouter private immutable symbiosisMetaRouter;
20     address private immutable symbiosisGateway;
21 
22     /// Types ///
23 
24     /// @notice The data specific to Symbiosis
25     /// @param firstSwapCalldata The calldata for the first swap
26     /// @param secondSwapCalldata The calldata for the second swap
27     /// @param intermediateToken The intermediate token used for swapping
28     /// @param firstDexRouter The router for the first swap
29     /// @param secondDexRouter The router for the second swap
30     /// @param approvedTokens The tokens approved for swapping
31     /// @param callTo The bridging entrypoint
32     /// @param callData The bridging calldata
33     struct SymbiosisData {
34         bytes firstSwapCalldata;
35         bytes secondSwapCalldata;
36         address intermediateToken;
37         address firstDexRouter;
38         address secondDexRouter;
39         address[] approvedTokens;
40         address callTo;
41         bytes callData;
42     }
43 
44     /// Constructor ///
45 
46     /// @notice Initialize the contract.
47     /// @param _symbiosisMetaRouter The contract address of the Symbiosis MetaRouter on the source chain.
48     /// @param _symbiosisGateway The contract address of the Symbiosis Gateway on the source chain.
49     constructor(
50         ISymbiosisMetaRouter _symbiosisMetaRouter,
51         address _symbiosisGateway
52     ) {
53         symbiosisMetaRouter = _symbiosisMetaRouter;
54         symbiosisGateway = _symbiosisGateway;
55     }
56 
57     /// External Methods ///
58 
59     /// @notice Bridges tokens via Symbiosis
60     /// @param _bridgeData The core information needed for bridging
61     /// @param _symbiosisData The data specific to Symbiosis
62     function startBridgeTokensViaSymbiosis(
63         ILiFi.BridgeData memory _bridgeData,
64         SymbiosisData calldata _symbiosisData
65     )
66         external
67         payable
68         nonReentrant
69         refundExcessNative(payable(msg.sender))
70         validateBridgeData(_bridgeData)
71         doesNotContainSourceSwaps(_bridgeData)
72         doesNotContainDestinationCalls(_bridgeData)
73     {
74         LibAsset.depositAsset(
75             _bridgeData.sendingAssetId,
76             _bridgeData.minAmount
77         );
78 
79         _startBridge(_bridgeData, _symbiosisData);
80     }
81 
82     /// Private Methods ///
83 
84     /// @notice Performs a swap before bridging via Symbiosis
85     /// @param _bridgeData The core information needed for bridging
86     /// @param _swapData An array of swap related data for performing swaps before bridging
87     /// @param _symbiosisData The data specific to Symbiosis
88     function swapAndStartBridgeTokensViaSymbiosis(
89         ILiFi.BridgeData memory _bridgeData,
90         LibSwap.SwapData[] calldata _swapData,
91         SymbiosisData calldata _symbiosisData
92     )
93         external
94         payable
95         nonReentrant
96         refundExcessNative(payable(msg.sender))
97         containsSourceSwaps(_bridgeData)
98         validateBridgeData(_bridgeData)
99     {
100         _bridgeData.minAmount = _depositAndSwap(
101             _bridgeData.transactionId,
102             _bridgeData.minAmount,
103             _swapData,
104             payable(msg.sender)
105         );
106 
107         _startBridge(_bridgeData, _symbiosisData);
108     }
109 
110     /// @dev Contains the business logic for the bridge via Symbiosis
111     /// @param _bridgeData the core information needed for bridging
112     /// @param _symbiosisData data specific to Symbiosis
113     function _startBridge(
114         ILiFi.BridgeData memory _bridgeData,
115         SymbiosisData calldata _symbiosisData
116     ) internal {
117         bool isNative = LibAsset.isNativeAsset(_bridgeData.sendingAssetId);
118         uint256 nativeAssetAmount;
119 
120         if (isNative) {
121             nativeAssetAmount = _bridgeData.minAmount;
122         } else {
123             LibAsset.maxApproveERC20(
124                 IERC20(_bridgeData.sendingAssetId),
125                 symbiosisGateway,
126                 _bridgeData.minAmount
127             );
128         }
129 
130         symbiosisMetaRouter.metaRoute{ value: nativeAssetAmount }(
131             ISymbiosisMetaRouter.MetaRouteTransaction(
132                 _symbiosisData.firstSwapCalldata,
133                 _symbiosisData.secondSwapCalldata,
134                 _symbiosisData.approvedTokens,
135                 _symbiosisData.firstDexRouter,
136                 _symbiosisData.secondDexRouter,
137                 _bridgeData.minAmount,
138                 isNative,
139                 _symbiosisData.callTo,
140                 _symbiosisData.callData
141             )
142         );
143 
144         emit LiFiTransferStarted(_bridgeData);
145     }
146 }
