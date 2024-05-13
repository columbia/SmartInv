1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IConnextHandler } from "../Interfaces/IConnextHandler.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { InformationMismatch } from "../Errors/GenericErrors.sol";
9 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
10 import { Validatable } from "../Helpers/Validatable.sol";
11 
12 /// @title Amarok Facet
13 /// @author LI.FI (https://li.fi)
14 /// @notice Provides functionality for bridging through Connext Amarok
15 /// @custom:version 2.0.0
16 contract AmarokFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
17     /// Storage ///
18 
19     /// @notice The contract address of the connext handler on the source chain.
20     IConnextHandler private immutable connextHandler;
21 
22     /// @param callData The data to execute on the receiving chain. If no crosschain call is needed, then leave empty.
23     /// @param callTo The address of the contract on dest chain that will receive bridged funds and execute data
24     /// @param relayerFee The amount of relayer fee the tx called xcall with
25     /// @param slippageTol Maximum acceptable slippage in BPS. For example, a value of 30 means 0.3% slippage
26     /// @param delegate Destination delegate address
27     /// @param destChainDomainId The Amarok-specific domainId of the destination chain
28     /// @param payFeeWithSendingAsset Whether to pay the relayer fee with the sending asset or not
29     struct AmarokData {
30         bytes callData;
31         address callTo;
32         uint256 relayerFee;
33         uint256 slippageTol;
34         address delegate;
35         uint32 destChainDomainId;
36         bool payFeeWithSendingAsset;
37     }
38 
39     /// Constructor ///
40 
41     /// @notice Initialize the contract.
42     /// @param _connextHandler The contract address of the connext handler on the source chain.
43     constructor(IConnextHandler _connextHandler) {
44         connextHandler = _connextHandler;
45     }
46 
47     /// External Methods ///
48 
49     /// @notice Bridges tokens via Amarok
50     /// @param _bridgeData Data containing core information for bridging
51     /// @param _amarokData Data specific to bridge
52     function startBridgeTokensViaAmarok(
53         BridgeData calldata _bridgeData,
54         AmarokData calldata _amarokData
55     )
56         external
57         payable
58         nonReentrant
59         refundExcessNative(payable(msg.sender))
60         doesNotContainSourceSwaps(_bridgeData)
61         validateBridgeData(_bridgeData)
62         noNativeAsset(_bridgeData)
63     {
64         validateDestinationCallFlag(_bridgeData, _amarokData);
65 
66         LibAsset.depositAsset(
67             _bridgeData.sendingAssetId,
68             _bridgeData.minAmount
69         );
70 
71         _startBridge(_bridgeData, _amarokData);
72     }
73 
74     /// @notice Performs a swap before bridging via Amarok
75     /// @param _bridgeData The core information needed for bridging
76     /// @param _swapData An array of swap related data for performing swaps before bridging
77     /// @param _amarokData Data specific to Amarok
78     function swapAndStartBridgeTokensViaAmarok(
79         BridgeData memory _bridgeData,
80         LibSwap.SwapData[] calldata _swapData,
81         AmarokData calldata _amarokData
82     )
83         external
84         payable
85         nonReentrant
86         refundExcessNative(payable(msg.sender))
87         containsSourceSwaps(_bridgeData)
88         validateBridgeData(_bridgeData)
89         noNativeAsset(_bridgeData)
90     {
91         validateDestinationCallFlag(_bridgeData, _amarokData);
92 
93         _bridgeData.minAmount = _depositAndSwap(
94             _bridgeData.transactionId,
95             _bridgeData.minAmount,
96             _swapData,
97             payable(msg.sender),
98             _amarokData.relayerFee
99         );
100 
101         _startBridge(_bridgeData, _amarokData);
102     }
103 
104     /// Private Methods ///
105 
106     /// @dev Contains the business logic for the bridge via Amarok
107     /// @param _bridgeData The core information needed for bridging
108     /// @param _amarokData Data specific to Amarok
109     function _startBridge(
110         BridgeData memory _bridgeData,
111         AmarokData calldata _amarokData
112     ) private {
113         // give max approval for token to Amarok bridge, if not already
114         LibAsset.maxApproveERC20(
115             IERC20(_bridgeData.sendingAssetId),
116             address(connextHandler),
117             _bridgeData.minAmount
118         );
119 
120         // initiate bridge transaction
121         if (_amarokData.payFeeWithSendingAsset) {
122             connextHandler.xcall(
123                 _amarokData.destChainDomainId,
124                 _amarokData.callTo,
125                 _bridgeData.sendingAssetId,
126                 _amarokData.delegate,
127                 _bridgeData.minAmount - _amarokData.relayerFee,
128                 _amarokData.slippageTol,
129                 _amarokData.callData,
130                 _amarokData.relayerFee
131             );
132         } else {
133             connextHandler.xcall{ value: _amarokData.relayerFee }(
134                 _amarokData.destChainDomainId,
135                 _amarokData.callTo,
136                 _bridgeData.sendingAssetId,
137                 _amarokData.delegate,
138                 _bridgeData.minAmount,
139                 _amarokData.slippageTol,
140                 _amarokData.callData
141             );
142         }
143 
144         emit LiFiTransferStarted(_bridgeData);
145     }
146 
147     function validateDestinationCallFlag(
148         ILiFi.BridgeData memory _bridgeData,
149         AmarokData calldata _amarokData
150     ) private pure {
151         if (
152             (_amarokData.callData.length > 0) != _bridgeData.hasDestinationCall
153         ) {
154             revert InformationMismatch();
155         }
156     }
157 }
