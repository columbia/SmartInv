1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
6 import { ERC20 } from "solmate/tokens/ERC20.sol";
7 import { ILiFi } from "../Interfaces/ILiFi.sol";
8 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
9 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
10 import { InvalidAmount, InformationMismatch } from "../Errors/GenericErrors.sol";
11 import { Validatable } from "../Helpers/Validatable.sol";
12 import { MessageSenderLib, MsgDataTypes, IMessageBus } from "celer-network/contracts/message/libraries/MessageSenderLib.sol";
13 import { RelayerCelerIM } from "lifi/Periphery/RelayerCelerIM.sol";
14 
15 interface CelerToken {
16     function canonical() external returns (address);
17 }
18 
19 interface CelerIM {
20     /// @param maxSlippage The max slippage accepted, given as percentage in point (pip).
21     /// @param nonce A number input to guarantee uniqueness of transferId. Can be timestamp in practice.
22     /// @param callTo The address of the contract to be called at destination.
23     /// @param callData The encoded calldata with below data
24     ///                 bytes32 transactionId,
25     ///                 LibSwap.SwapData[] memory swapData,
26     ///                 address receiver,
27     ///                 address refundAddress
28     /// @param messageBusFee The fee to be paid to CBridge message bus for relaying the message
29     /// @param bridgeType Defines the bridge operation type (must be one of the values of CBridge library MsgDataTypes.BridgeSendType)
30     struct CelerIMData {
31         uint32 maxSlippage;
32         uint64 nonce;
33         bytes callTo;
34         bytes callData;
35         uint256 messageBusFee;
36         MsgDataTypes.BridgeSendType bridgeType;
37     }
38 }
39 
40 /// @title CelerIM Facet Base
41 /// @author LI.FI (https://li.fi)
42 /// @notice Provides functionality for bridging tokens and data through CBridge
43 /// @notice Used to differentiate between contract instances for mutable and immutable diamond as these cannot be shared
44 /// @custom:version 2.0.0
45 abstract contract CelerIMFacetBase is
46     ILiFi,
47     ReentrancyGuard,
48     SwapperV2,
49     Validatable
50 {
51     /// Storage ///
52 
53     /// @dev The contract address of the cBridge Message Bus
54     IMessageBus private immutable cBridgeMessageBus;
55 
56     /// @dev The contract address of the RelayerCelerIM
57     RelayerCelerIM public immutable relayer;
58 
59     /// @dev The contract address of the Celer Flow USDC
60     address private immutable cfUSDC;
61 
62     /// Constructor ///
63 
64     /// @notice Initialize the contract.
65     /// @param _messageBus The contract address of the cBridge Message Bus
66     /// @param _relayerOwner The address that will become the owner of the RelayerCelerIM contract
67     /// @param _diamondAddress The address of the diamond contract that will be connected with the RelayerCelerIM
68     /// @param _cfUSDC The contract address of the Celer Flow USDC
69     constructor(
70         IMessageBus _messageBus,
71         address _relayerOwner,
72         address _diamondAddress,
73         address _cfUSDC
74     ) {
75         // deploy RelayerCelerIM
76         relayer = new RelayerCelerIM(
77             address(_messageBus),
78             _relayerOwner,
79             _diamondAddress
80         );
81 
82         // store arguments in variables
83         cBridgeMessageBus = _messageBus;
84         cfUSDC = _cfUSDC;
85     }
86 
87     /// External Methods ///
88 
89     /// @notice Bridges tokens via CBridge
90     /// @param _bridgeData The core information needed for bridging
91     /// @param _celerIMData Data specific to CelerIM
92     function startBridgeTokensViaCelerIM(
93         ILiFi.BridgeData memory _bridgeData,
94         CelerIM.CelerIMData calldata _celerIMData
95     )
96         external
97         payable
98         nonReentrant
99         refundExcessNative(payable(msg.sender))
100         doesNotContainSourceSwaps(_bridgeData)
101         validateBridgeData(_bridgeData)
102     {
103         validateDestinationCallFlag(_bridgeData, _celerIMData);
104         if (!LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
105             // Transfer ERC20 tokens directly to relayer
106             IERC20 asset = _getRightAsset(_bridgeData.sendingAssetId);
107 
108             // Deposit ERC20 token
109             uint256 prevBalance = asset.balanceOf(address(relayer));
110             SafeERC20.safeTransferFrom(
111                 asset,
112                 msg.sender,
113                 address(relayer),
114                 _bridgeData.minAmount
115             );
116 
117             if (
118                 asset.balanceOf(address(relayer)) - prevBalance !=
119                 _bridgeData.minAmount
120             ) {
121                 revert InvalidAmount();
122             }
123         }
124 
125         _startBridge(_bridgeData, _celerIMData);
126     }
127 
128     /// @notice Performs a swap before bridging via CBridge
129     /// @param _bridgeData The core information needed for bridging
130     /// @param _swapData An array of swap related data for performing swaps before bridging
131     /// @param _celerIMData Data specific to CelerIM
132     function swapAndStartBridgeTokensViaCelerIM(
133         ILiFi.BridgeData memory _bridgeData,
134         LibSwap.SwapData[] calldata _swapData,
135         CelerIM.CelerIMData calldata _celerIMData
136     )
137         external
138         payable
139         nonReentrant
140         refundExcessNative(payable(msg.sender))
141         containsSourceSwaps(_bridgeData)
142         validateBridgeData(_bridgeData)
143     {
144         validateDestinationCallFlag(_bridgeData, _celerIMData);
145 
146         _bridgeData.minAmount = _depositAndSwap(
147             _bridgeData.transactionId,
148             _bridgeData.minAmount,
149             _swapData,
150             payable(msg.sender),
151             _celerIMData.messageBusFee
152         );
153 
154         if (!LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
155             // Transfer ERC20 tokens directly to relayer
156             IERC20 asset = _getRightAsset(_bridgeData.sendingAssetId);
157 
158             // Deposit ERC20 token
159             uint256 prevBalance = asset.balanceOf(address(relayer));
160             SafeERC20.safeTransfer(
161                 asset,
162                 address(relayer),
163                 _bridgeData.minAmount
164             );
165 
166             if (
167                 asset.balanceOf(address(relayer)) - prevBalance !=
168                 _bridgeData.minAmount
169             ) {
170                 revert InvalidAmount();
171             }
172         }
173 
174         _startBridge(_bridgeData, _celerIMData);
175     }
176 
177     /// Private Methods ///
178 
179     /// @dev Contains the business logic for the bridge via CBridge
180     /// @param _bridgeData The core information needed for bridging
181     /// @param _celerIMData Data specific to CBridge
182     function _startBridge(
183         ILiFi.BridgeData memory _bridgeData,
184         CelerIM.CelerIMData calldata _celerIMData
185     ) private {
186         // Assuming messageBusFee is pre-calculated off-chain and available in _celerIMData
187         // Determine correct native asset amount to be forwarded (if so) and send funds to relayer
188         uint256 msgValue = LibAsset.isNativeAsset(_bridgeData.sendingAssetId)
189             ? _bridgeData.minAmount
190             : 0;
191 
192         // Check if transaction contains a destination call
193         if (!_bridgeData.hasDestinationCall) {
194             // Case 'no': Simple bridge transfer - Send to receiver
195             relayer.sendTokenTransfer{ value: msgValue }(
196                 _bridgeData,
197                 _celerIMData
198             );
199         } else {
200             // Case 'yes': Bridge + Destination call - Send to relayer
201 
202             // save address of original recipient
203             address receiver = _bridgeData.receiver;
204 
205             // Set relayer as a receiver
206             _bridgeData.receiver = address(relayer);
207 
208             // send token transfer
209             (bytes32 transferId, address bridgeAddress) = relayer
210                 .sendTokenTransfer{ value: msgValue }(
211                 _bridgeData,
212                 _celerIMData
213             );
214 
215             // Call message bus via relayer incl messageBusFee
216             relayer.forwardSendMessageWithTransfer{
217                 value: _celerIMData.messageBusFee
218             }(
219                 _bridgeData.receiver,
220                 uint64(_bridgeData.destinationChainId),
221                 bridgeAddress,
222                 transferId,
223                 _celerIMData.callData
224             );
225 
226             // Reset receiver of bridge data for event emission
227             _bridgeData.receiver = receiver;
228         }
229 
230         // emit LiFi event
231         emit LiFiTransferStarted(_bridgeData);
232     }
233 
234     /// @dev Get right asset to transfer to relayer.
235     /// @param _sendingAssetId The address of asset to bridge.
236     /// @return _asset The address of asset to transfer to relayer.
237     function _getRightAsset(
238         address _sendingAssetId
239     ) private returns (IERC20 _asset) {
240         if (_sendingAssetId == cfUSDC) {
241             // special case for cfUSDC token
242             _asset = IERC20(CelerToken(_sendingAssetId).canonical());
243         } else {
244             // any other ERC20 token
245             _asset = IERC20(_sendingAssetId);
246         }
247     }
248 
249     function validateDestinationCallFlag(
250         ILiFi.BridgeData memory _bridgeData,
251         CelerIM.CelerIMData calldata _celerIMData
252     ) private pure {
253         if (
254             (_celerIMData.callData.length > 0) !=
255             _bridgeData.hasDestinationCall
256         ) {
257             revert InformationMismatch();
258         }
259     }
260 }
