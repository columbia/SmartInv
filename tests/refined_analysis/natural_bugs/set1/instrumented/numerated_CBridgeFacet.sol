1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "../Libraries/LibDiamond.sol";
5 import { LibUtil } from "../Libraries/LibUtil.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { LibAccess } from "../Libraries/LibAccess.sol";
8 import { ILiFi } from "../Interfaces/ILiFi.sol";
9 import { ICBridge } from "../Interfaces/ICBridge.sol";
10 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
11 import { CannotBridgeToSameNetwork } from "../Errors/GenericErrors.sol";
12 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
13 import { Validatable } from "../Helpers/Validatable.sol";
14 import { ContractCallNotAllowed, ExternalCallFailed } from "../Errors/GenericErrors.sol";
15 
16 /// @title CBridge Facet
17 /// @author LI.FI (https://li.fi)
18 /// @notice Provides functionality for bridging through CBridge
19 /// @custom:version 1.0.0
20 contract CBridgeFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
21     /// Storage ///
22 
23     /// @notice The contract address of the cbridge on the source chain.
24     ICBridge private immutable cBridge;
25 
26     /// Types ///
27 
28     /// @param maxSlippage The max slippage accepted, given as percentage in point (pip).
29     /// @param nonce A number input to guarantee uniqueness of transferId.
30     ///              Can be timestamp in practice.
31     struct CBridgeData {
32         uint32 maxSlippage;
33         uint64 nonce;
34     }
35 
36     /// Events ///
37     event CBridgeRefund(
38         address indexed _assetAddress,
39         address indexed _to,
40         uint256 amount
41     );
42 
43     /// Constructor ///
44 
45     /// @notice Initialize the contract.
46     /// @param _cBridge The contract address of the cbridge on the source chain.
47     constructor(ICBridge _cBridge) {
48         cBridge = _cBridge;
49     }
50 
51     /// External Methods ///
52 
53     /// @notice Bridges tokens via CBridge
54     /// @param _bridgeData the core information needed for bridging
55     /// @param _cBridgeData data specific to CBridge
56     function startBridgeTokensViaCBridge(
57         ILiFi.BridgeData memory _bridgeData,
58         CBridgeData calldata _cBridgeData
59     )
60         external
61         payable
62         nonReentrant
63         refundExcessNative(payable(msg.sender))
64         doesNotContainSourceSwaps(_bridgeData)
65         doesNotContainDestinationCalls(_bridgeData)
66         validateBridgeData(_bridgeData)
67     {
68         LibAsset.depositAsset(
69             _bridgeData.sendingAssetId,
70             _bridgeData.minAmount
71         );
72         _startBridge(_bridgeData, _cBridgeData);
73     }
74 
75     /// @notice Performs a swap before bridging via CBridge
76     /// @param _bridgeData the core information needed for bridging
77     /// @param _swapData an array of swap related data for performing swaps before bridging
78     /// @param _cBridgeData data specific to CBridge
79     function swapAndStartBridgeTokensViaCBridge(
80         ILiFi.BridgeData memory _bridgeData,
81         LibSwap.SwapData[] calldata _swapData,
82         CBridgeData calldata _cBridgeData
83     )
84         external
85         payable
86         nonReentrant
87         refundExcessNative(payable(msg.sender))
88         containsSourceSwaps(_bridgeData)
89         doesNotContainDestinationCalls(_bridgeData)
90         validateBridgeData(_bridgeData)
91     {
92         _bridgeData.minAmount = _depositAndSwap(
93             _bridgeData.transactionId,
94             _bridgeData.minAmount,
95             _swapData,
96             payable(msg.sender)
97         );
98         _startBridge(_bridgeData, _cBridgeData);
99     }
100 
101     /// @notice Triggers a cBridge refund with calldata produced by cBridge API
102     /// @param _callTo The address to execute the calldata on
103     /// @param _callData The data to execute
104     /// @param _assetAddress Asset to be withdrawn
105     /// @param _to Address to withdraw to
106     /// @param _amount Amount of asset to withdraw
107     function triggerRefund(
108         address payable _callTo,
109         bytes calldata _callData,
110         address _assetAddress,
111         address _to,
112         uint256 _amount
113     ) external {
114         if (msg.sender != LibDiamond.contractOwner()) {
115             LibAccess.enforceAccessControl();
116         }
117 
118         // make sure that callTo address is either of the cBridge addresses
119         if (address(cBridge) != _callTo) {
120             revert ContractCallNotAllowed();
121         }
122 
123         // call contract
124         bool success;
125         (success, ) = _callTo.call(_callData);
126         if (!success) {
127             revert ExternalCallFailed();
128         }
129 
130         // forward funds to _to address and emit event
131         address sendTo = (LibUtil.isZeroAddress(_to)) ? msg.sender : _to;
132         LibAsset.transferAsset(_assetAddress, payable(sendTo), _amount);
133         emit CBridgeRefund(_assetAddress, sendTo, _amount);
134     }
135 
136     /// Private Methods ///
137 
138     /// @dev Contains the business logic for the bridge via CBridge
139     /// @param _bridgeData the core information needed for bridging
140     /// @param _cBridgeData data specific to CBridge
141     function _startBridge(
142         ILiFi.BridgeData memory _bridgeData,
143         CBridgeData calldata _cBridgeData
144     ) private {
145         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
146             cBridge.sendNative{ value: _bridgeData.minAmount }(
147                 _bridgeData.receiver,
148                 _bridgeData.minAmount,
149                 uint64(_bridgeData.destinationChainId),
150                 _cBridgeData.nonce,
151                 _cBridgeData.maxSlippage
152             );
153         } else {
154             // Give CBridge approval to bridge tokens
155             LibAsset.maxApproveERC20(
156                 IERC20(_bridgeData.sendingAssetId),
157                 address(cBridge),
158                 _bridgeData.minAmount
159             );
160             // solhint-disable check-send-result
161             cBridge.send(
162                 _bridgeData.receiver,
163                 _bridgeData.sendingAssetId,
164                 _bridgeData.minAmount,
165                 uint64(_bridgeData.destinationChainId),
166                 _cBridgeData.nonce,
167                 _cBridgeData.maxSlippage
168             );
169         }
170 
171         emit LiFiTransferStarted(_bridgeData);
172     }
173 }
