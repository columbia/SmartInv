1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IGatewayRouter } from "../Interfaces/IGatewayRouter.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { InvalidAmount } from "../Errors/GenericErrors.sol";
9 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
10 import { Validatable } from "../Helpers/Validatable.sol";
11 
12 /// @title Arbitrum Bridge Facet
13 /// @author Li.Finance (https://li.finance)
14 /// @notice Provides functionality for bridging through Arbitrum Bridge
15 /// @custom:version 1.0.0
16 contract ArbitrumBridgeFacet is
17     ILiFi,
18     ReentrancyGuard,
19     SwapperV2,
20     Validatable
21 {
22     /// Storage ///
23 
24     /// @notice The contract address of the gateway router on the source chain.
25     IGatewayRouter private immutable gatewayRouter;
26 
27     /// @notice The contract address of the inbox on the source chain.
28     IGatewayRouter private immutable inbox;
29 
30     /// Types ///
31 
32     /// @param maxSubmissionCost Max gas deducted from user's L2 balance to cover base submission fee.
33     /// @param maxGas Max gas deducted from user's L2 balance to cover L2 execution.
34     /// @param maxGasPrice price bid for L2 execution.
35     struct ArbitrumData {
36         uint256 maxSubmissionCost;
37         uint256 maxGas;
38         uint256 maxGasPrice;
39     }
40 
41     /// Constructor ///
42 
43     /// @notice Initialize the contract.
44     /// @param _gatewayRouter The contract address of the gateway router on the source chain.
45     /// @param _inbox The contract address of the inbox on the source chain.
46     constructor(IGatewayRouter _gatewayRouter, IGatewayRouter _inbox) {
47         gatewayRouter = _gatewayRouter;
48         inbox = _inbox;
49     }
50 
51     /// External Methods ///
52 
53     /// @notice Bridges tokens via Arbitrum Bridge
54     /// @param _bridgeData Data containing core information for bridging
55     /// @param _arbitrumData Data for gateway router address, asset id and amount
56     function startBridgeTokensViaArbitrumBridge(
57         ILiFi.BridgeData memory _bridgeData,
58         ArbitrumData calldata _arbitrumData
59     )
60         external
61         payable
62         nonReentrant
63         refundExcessNative(payable(msg.sender))
64         doesNotContainSourceSwaps(_bridgeData)
65         doesNotContainDestinationCalls(_bridgeData)
66         validateBridgeData(_bridgeData)
67     {
68         uint256 cost = _arbitrumData.maxSubmissionCost +
69             _arbitrumData.maxGas *
70             _arbitrumData.maxGasPrice;
71 
72         LibAsset.depositAsset(
73             _bridgeData.sendingAssetId,
74             _bridgeData.minAmount
75         );
76 
77         _startBridge(_bridgeData, _arbitrumData, cost);
78     }
79 
80     /// @notice Performs a swap before bridging via Arbitrum Bridge
81     /// @param _bridgeData Data containing core information for bridging
82     /// @param _swapData An array of swap related data for performing swaps before bridging
83     /// @param _arbitrumData Data for gateway router address, asset id and amount
84     function swapAndStartBridgeTokensViaArbitrumBridge(
85         ILiFi.BridgeData memory _bridgeData,
86         LibSwap.SwapData[] calldata _swapData,
87         ArbitrumData calldata _arbitrumData
88     )
89         external
90         payable
91         nonReentrant
92         refundExcessNative(payable(msg.sender))
93         containsSourceSwaps(_bridgeData)
94         doesNotContainDestinationCalls(_bridgeData)
95         validateBridgeData(_bridgeData)
96     {
97         uint256 cost = _arbitrumData.maxSubmissionCost +
98             _arbitrumData.maxGas *
99             _arbitrumData.maxGasPrice;
100 
101         _bridgeData.minAmount = _depositAndSwap(
102             _bridgeData.transactionId,
103             _bridgeData.minAmount,
104             _swapData,
105             payable(msg.sender),
106             cost
107         );
108 
109         _startBridge(_bridgeData, _arbitrumData, cost);
110     }
111 
112     /// Private Methods ///
113 
114     /// @dev Contains the business logic for the bridge via Arbitrum Bridge
115     /// @param _bridgeData Data containing core information for bridging
116     /// @param _arbitrumData Data for gateway router address, asset id and amount
117     /// @param _cost Additional amount of native asset for the fee
118     function _startBridge(
119         ILiFi.BridgeData memory _bridgeData,
120         ArbitrumData calldata _arbitrumData,
121         uint256 _cost
122     ) private {
123         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
124             inbox.unsafeCreateRetryableTicket{
125                 value: _bridgeData.minAmount + _cost
126             }(
127                 _bridgeData.receiver,
128                 _bridgeData.minAmount, // l2CallValue
129                 _arbitrumData.maxSubmissionCost,
130                 _bridgeData.receiver, // excessFeeRefundAddress
131                 _bridgeData.receiver, // callValueRefundAddress
132                 _arbitrumData.maxGas,
133                 _arbitrumData.maxGasPrice,
134                 ""
135             );
136         } else {
137             LibAsset.maxApproveERC20(
138                 IERC20(_bridgeData.sendingAssetId),
139                 gatewayRouter.getGateway(_bridgeData.sendingAssetId),
140                 _bridgeData.minAmount
141             );
142             gatewayRouter.outboundTransfer{ value: _cost }(
143                 _bridgeData.sendingAssetId,
144                 _bridgeData.receiver,
145                 _bridgeData.minAmount,
146                 _arbitrumData.maxGas,
147                 _arbitrumData.maxGasPrice,
148                 abi.encode(_arbitrumData.maxSubmissionCost, "")
149             );
150         }
151 
152         emit LiFiTransferStarted(_bridgeData);
153     }
154 }
