1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { ISynapseRouter } from "../Interfaces/ISynapseRouter.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 
11 /// @title SynapseBridge Facet
12 /// @author LI.FI (https://li.fi)
13 /// @notice Provides functionality for bridging through SynapseBridge
14 /// @custom:version 1.0.0
15 contract SynapseBridgeFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
16     /// Storage ///
17 
18     address internal constant NETH_ADDRESS =
19         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
20 
21     /// @notice The contract address of the SynapseRouter on the source chain.
22     ISynapseRouter private immutable synapseRouter;
23 
24     /// Types ///
25 
26     /// @param originQuery Origin swap query. Empty struct indicates no swap is required.
27     /// @param destQuery Destination swap query. Empty struct indicates no swap is required.
28     struct SynapseData {
29         ISynapseRouter.SwapQuery originQuery;
30         ISynapseRouter.SwapQuery destQuery;
31     }
32 
33     /// Constructor ///
34 
35     /// @notice Initialize the contract.
36     /// @param _synapseRouter The contract address of the SynapseRouter on the source chain.
37     constructor(ISynapseRouter _synapseRouter) {
38         synapseRouter = _synapseRouter;
39     }
40 
41     /// External Methods ///
42 
43     /// @notice Bridges tokens via Synapse Bridge
44     /// @param _bridgeData the core information needed for bridging
45     /// @param _synapseData data specific to Synapse Bridge
46     function startBridgeTokensViaSynapseBridge(
47         ILiFi.BridgeData calldata _bridgeData,
48         SynapseData calldata _synapseData
49     )
50         external
51         payable
52         nonReentrant
53         refundExcessNative(payable(msg.sender))
54         validateBridgeData(_bridgeData)
55         doesNotContainSourceSwaps(_bridgeData)
56         doesNotContainDestinationCalls(_bridgeData)
57     {
58         LibAsset.depositAsset(
59             _bridgeData.sendingAssetId,
60             _bridgeData.minAmount
61         );
62 
63         _startBridge(_bridgeData, _synapseData);
64     }
65 
66     /// @notice Performs a swap before bridging via Synapse Bridge
67     /// @param _bridgeData the core information needed for bridging
68     /// @param _swapData an array of swap related data for performing swaps before bridging
69     /// @param _synapseData data specific to Synapse Bridge
70     function swapAndStartBridgeTokensViaSynapseBridge(
71         ILiFi.BridgeData memory _bridgeData,
72         LibSwap.SwapData[] calldata _swapData,
73         SynapseData calldata _synapseData
74     )
75         external
76         payable
77         nonReentrant
78         refundExcessNative(payable(msg.sender))
79         containsSourceSwaps(_bridgeData)
80         doesNotContainDestinationCalls(_bridgeData)
81         validateBridgeData(_bridgeData)
82     {
83         _bridgeData.minAmount = _depositAndSwap(
84             _bridgeData.transactionId,
85             _bridgeData.minAmount,
86             _swapData,
87             payable(msg.sender)
88         );
89 
90         _startBridge(_bridgeData, _synapseData);
91     }
92 
93     /// Internal Methods ///
94 
95     /// @dev Contains the business logic for the bridge via Synapse Bridge
96     /// @param _bridgeData the core information needed for bridging
97     /// @param _synapseData data specific to Synapse Bridge
98     function _startBridge(
99         ILiFi.BridgeData memory _bridgeData,
100         SynapseData calldata _synapseData
101     ) internal {
102         uint256 nativeAssetAmount;
103         address sendingAssetId = _bridgeData.sendingAssetId;
104 
105         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
106             nativeAssetAmount = _bridgeData.minAmount;
107             sendingAssetId = NETH_ADDRESS;
108         } else {
109             LibAsset.maxApproveERC20(
110                 IERC20(_bridgeData.sendingAssetId),
111                 address(synapseRouter),
112                 _bridgeData.minAmount
113             );
114         }
115 
116         synapseRouter.bridge{ value: nativeAssetAmount }(
117             _bridgeData.receiver,
118             _bridgeData.destinationChainId,
119             sendingAssetId,
120             _bridgeData.minAmount,
121             _synapseData.originQuery,
122             _synapseData.destQuery
123         );
124 
125         emit LiFiTransferStarted(_bridgeData);
126     }
127 }
