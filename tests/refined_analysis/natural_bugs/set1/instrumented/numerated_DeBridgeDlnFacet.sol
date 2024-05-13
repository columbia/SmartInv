1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { LibDiamond } from "../Libraries/LibDiamond.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { LibSwap } from "../Libraries/LibSwap.sol";
8 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
9 import { SwapperV2 } from "../Helpers/SwapperV2.sol";
10 import { Validatable } from "../Helpers/Validatable.sol";
11 import { IDlnSource } from "../Interfaces/IDlnSource.sol";
12 
13 /// @title DeBridgeDLN Facet
14 /// @author LI.FI (https://li.fi)
15 /// @notice Provides functionality for bridging through DeBridge DLN
16 /// @custom:version 1.0.0
17 contract DeBridgeDlnFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
18     /// Storage ///
19 
20     address internal constant NON_EVM_ADDRESS =
21         0x11f111f111f111F111f111f111F111f111f111F1;
22     IDlnSource public immutable dlnSource;
23 
24     /// Types ///
25 
26     /// @param receivingAssetId The address of the asset to receive
27     /// @param receiver The address of the receiver
28     /// @param minAmountOut The minimum amount to receive on the destination chain
29     struct DeBridgeDlnData {
30         bytes receivingAssetId;
31         bytes receiver;
32         uint256 minAmountOut;
33     }
34 
35     /// Events ///
36 
37     event DlnOrderCreated(bytes32 indexed orderId);
38 
39     event BridgeToNonEVMChain(
40         bytes32 indexed transactionId,
41         uint256 indexed destinationChainId,
42         bytes receiver
43     );
44 
45     /// Constructor ///
46 
47     /// @notice Constructor for the contract.
48     /// @param _dlnSource The address of the DLN order creation contract
49     constructor(IDlnSource _dlnSource) {
50         dlnSource = _dlnSource;
51     }
52 
53     /// External Methods ///
54 
55     /// @notice Bridges tokens via DeBridgeDLN
56     /// @param _bridgeData The core information needed for bridging
57     /// @param _deBridgeDlnData Data specific to DeBridgeDLN
58     function startBridgeTokensViaDeBridgeDln(
59         ILiFi.BridgeData memory _bridgeData,
60         DeBridgeDlnData calldata _deBridgeDlnData
61     )
62         external
63         payable
64         nonReentrant
65         refundExcessNative(payable(msg.sender))
66         validateBridgeData(_bridgeData)
67         doesNotContainSourceSwaps(_bridgeData)
68         doesNotContainDestinationCalls(_bridgeData)
69     {
70         LibAsset.depositAsset(
71             _bridgeData.sendingAssetId,
72             _bridgeData.minAmount
73         );
74         _startBridge(
75             _bridgeData,
76             _deBridgeDlnData,
77             dlnSource.globalFixedNativeFee()
78         );
79     }
80 
81     /// @notice Performs a swap before bridging via DeBridgeDLN
82     /// @param _bridgeData The core information needed for bridging
83     /// @param _swapData An array of swap related data for performing swaps before bridging
84     /// @param _deBridgeDlnData Data specific to DeBridgeDLN
85     function swapAndStartBridgeTokensViaDeBridgeDln(
86         ILiFi.BridgeData memory _bridgeData,
87         LibSwap.SwapData[] calldata _swapData,
88         DeBridgeDlnData calldata _deBridgeDlnData
89     )
90         external
91         payable
92         nonReentrant
93         refundExcessNative(payable(msg.sender))
94         containsSourceSwaps(_bridgeData)
95         doesNotContainDestinationCalls(_bridgeData)
96         validateBridgeData(_bridgeData)
97     {
98         uint256 fee = dlnSource.globalFixedNativeFee();
99         address assetId = _bridgeData.sendingAssetId;
100         _bridgeData.minAmount = _depositAndSwap(
101             _bridgeData.transactionId,
102             _bridgeData.minAmount,
103             _swapData,
104             payable(msg.sender),
105             LibAsset.isNativeAsset(assetId) ? 0 : fee
106         );
107         _startBridge(_bridgeData, _deBridgeDlnData, fee);
108     }
109 
110     /// Internal Methods ///
111 
112     /// @dev Contains the business logic for the bridge via DeBridgeDLN
113     /// @param _bridgeData The core information needed for bridging
114     /// @param _deBridgeDlnData Data specific to DeBridgeDLN
115     function _startBridge(
116         ILiFi.BridgeData memory _bridgeData,
117         DeBridgeDlnData calldata _deBridgeDlnData,
118         uint256 _fee
119     ) internal {
120         IDlnSource.OrderCreation memory orderCreation = IDlnSource
121             .OrderCreation({
122                 giveTokenAddress: _bridgeData.sendingAssetId,
123                 giveAmount: _bridgeData.minAmount,
124                 takeTokenAddress: _deBridgeDlnData.receivingAssetId,
125                 takeAmount: _deBridgeDlnData.minAmountOut,
126                 takeChainId: _bridgeData.destinationChainId,
127                 receiverDst: _deBridgeDlnData.receiver,
128                 givePatchAuthoritySrc: _bridgeData.receiver,
129                 orderAuthorityAddressDst: _deBridgeDlnData.receiver,
130                 allowedTakerDst: "",
131                 externalCall: "",
132                 allowedCancelBeneficiarySrc: ""
133             });
134 
135         bytes32 orderId;
136         if (!LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
137             // Give the DLN Source approval to bridge tokens
138             LibAsset.maxApproveERC20(
139                 IERC20(_bridgeData.sendingAssetId),
140                 address(dlnSource),
141                 _bridgeData.minAmount
142             );
143 
144             orderId = dlnSource.createOrder{ value: _fee }(
145                 orderCreation,
146                 "",
147                 0,
148                 ""
149             );
150         } else {
151             orderCreation.giveAmount = orderCreation.giveAmount - _fee;
152             orderId = dlnSource.createOrder{ value: _bridgeData.minAmount }(
153                 orderCreation,
154                 "",
155                 0,
156                 ""
157             );
158         }
159 
160         emit DlnOrderCreated(orderId);
161 
162         if (_bridgeData.receiver == NON_EVM_ADDRESS) {
163             emit BridgeToNonEVMChain(
164                 _bridgeData.transactionId,
165                 _bridgeData.destinationChainId,
166                 _deBridgeDlnData.receiver
167             );
168         }
169 
170         emit LiFiTransferStarted(_bridgeData);
171     }
172 }
