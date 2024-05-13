1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IDeBridgeGate } from "../Interfaces/IDeBridgeGate.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { InformationMismatch, InvalidAmount } from "../Errors/GenericErrors.sol";
10 import { Validatable } from "../Helpers/Validatable.sol";
11 
12 /// @title DeBridge Facet
13 /// @author LI.FI (https://li.fi)
14 /// @notice Provides functionality for bridging through DeBridge Protocol
15 /// @custom:version 1.0.0
16 contract DeBridgeFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
17     /// Storage ///
18 
19     /// @notice The contract address of the DeBridge Gate on the source chain.
20     IDeBridgeGate private immutable deBridgeGate;
21 
22     /// Types ///
23 
24     /// @param executionFee Fee paid to the transaction executor.
25     /// @param flags Flags set specific flows for call data execution.
26     /// @param fallbackAddress Receiver of the tokens if the call fails.
27     /// @param data Message/Call data to be passed to the receiver
28     ///             on the destination chain during the external call execution.
29     struct SubmissionAutoParamsTo {
30         uint256 executionFee;
31         uint256 flags;
32         bytes fallbackAddress;
33         bytes data;
34     }
35 
36     /// @param nativeFee Native fee for the bridging when useAssetFee is false.
37     /// @param useAssetFee Use assets fee for pay protocol fix (work only for specials token)
38     /// @param referralCode Referral code.
39     /// @param autoParams Structure that enables passing arbitrary messages and call data.
40     struct DeBridgeData {
41         uint256 nativeFee;
42         bool useAssetFee;
43         uint32 referralCode;
44         SubmissionAutoParamsTo autoParams;
45     }
46 
47     /// Constructor ///
48 
49     /// @notice Initialize the contract.
50     /// @param _deBridgeGate The contract address of the DeBridgeGate on the source chain.
51     constructor(IDeBridgeGate _deBridgeGate) {
52         deBridgeGate = _deBridgeGate;
53     }
54 
55     /// External Methods ///
56 
57     /// @notice Bridges tokens via DeBridge
58     /// @param _bridgeData the core information needed for bridging
59     /// @param _deBridgeData data specific to DeBridge
60     function startBridgeTokensViaDeBridge(
61         ILiFi.BridgeData calldata _bridgeData,
62         DeBridgeData calldata _deBridgeData
63     )
64         external
65         payable
66         nonReentrant
67         refundExcessNative(payable(msg.sender))
68         validateBridgeData(_bridgeData)
69         doesNotContainSourceSwaps(_bridgeData)
70     {
71         validateDestinationCallFlag(_bridgeData, _deBridgeData);
72 
73         LibAsset.depositAsset(
74             _bridgeData.sendingAssetId,
75             _bridgeData.minAmount
76         );
77         _startBridge(_bridgeData, _deBridgeData);
78     }
79 
80     /// @notice Performs a swap before bridging via DeBridge
81     /// @param _bridgeData the core information needed for bridging
82     /// @param _swapData an array of swap related data for performing swaps before bridging
83     /// @param _deBridgeData data specific to DeBridge
84     function swapAndStartBridgeTokensViaDeBridge(
85         ILiFi.BridgeData memory _bridgeData,
86         LibSwap.SwapData[] calldata _swapData,
87         DeBridgeData calldata _deBridgeData
88     )
89         external
90         payable
91         nonReentrant
92         refundExcessNative(payable(msg.sender))
93         containsSourceSwaps(_bridgeData)
94         validateBridgeData(_bridgeData)
95     {
96         validateDestinationCallFlag(_bridgeData, _deBridgeData);
97 
98         _bridgeData.minAmount = _depositAndSwap(
99             _bridgeData.transactionId,
100             _bridgeData.minAmount,
101             _swapData,
102             payable(msg.sender),
103             _deBridgeData.nativeFee
104         );
105 
106         _startBridge(_bridgeData, _deBridgeData);
107     }
108 
109     /// Internal Methods ///
110 
111     /// @dev Contains the business logic for the bridge via DeBridge
112     /// @param _bridgeData the core information needed for bridging
113     /// @param _deBridgeData data specific to DeBridge
114     function _startBridge(
115         ILiFi.BridgeData memory _bridgeData,
116         DeBridgeData calldata _deBridgeData
117     ) internal {
118         IDeBridgeGate.ChainSupportInfo memory config = deBridgeGate
119             .getChainToConfig(_bridgeData.destinationChainId);
120         uint256 nativeFee = config.fixedNativeFee == 0
121             ? deBridgeGate.globalFixedNativeFee()
122             : config.fixedNativeFee;
123 
124         if (_deBridgeData.nativeFee != nativeFee) {
125             revert InvalidAmount();
126         }
127 
128         bool isNative = LibAsset.isNativeAsset(_bridgeData.sendingAssetId);
129         uint256 nativeAssetAmount = _deBridgeData.nativeFee;
130 
131         if (isNative) {
132             nativeAssetAmount += _bridgeData.minAmount;
133         } else {
134             LibAsset.maxApproveERC20(
135                 IERC20(_bridgeData.sendingAssetId),
136                 address(deBridgeGate),
137                 _bridgeData.minAmount
138             );
139         }
140 
141         // solhint-disable-next-line check-send-result
142         deBridgeGate.send{ value: nativeAssetAmount }(
143             _bridgeData.sendingAssetId,
144             _bridgeData.minAmount,
145             _bridgeData.destinationChainId,
146             abi.encodePacked(_bridgeData.receiver),
147             "",
148             _deBridgeData.useAssetFee,
149             _deBridgeData.referralCode,
150             abi.encode(_deBridgeData.autoParams)
151         );
152 
153         emit LiFiTransferStarted(_bridgeData);
154     }
155 
156     function validateDestinationCallFlag(
157         ILiFi.BridgeData memory _bridgeData,
158         DeBridgeData calldata _deBridgeData
159     ) private pure {
160         if (
161             (_deBridgeData.autoParams.data.length > 0) !=
162             _bridgeData.hasDestinationCall
163         ) {
164             revert InformationMismatch();
165         }
166     }
167 }
