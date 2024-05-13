1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { IERC20, SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import { LibSwap } from "../Libraries/LibSwap.sol";
6 import { ContractCallNotAllowed, ExternalCallFailed, InvalidConfig, UnAuthorized, WithdrawFailed } from "../Errors/GenericErrors.sol";
7 import { LibAsset } from "../Libraries/LibAsset.sol";
8 import { LibUtil } from "../Libraries/LibUtil.sol";
9 import { ILiFi } from "../Interfaces/ILiFi.sol";
10 import { PeripheryRegistryFacet } from "../Facets/PeripheryRegistryFacet.sol";
11 import { IExecutor } from "../Interfaces/IExecutor.sol";
12 import { TransferrableOwnership } from "../Helpers/TransferrableOwnership.sol";
13 import { IMessageReceiverApp } from "celer-network/contracts/message/interfaces/IMessageReceiverApp.sol";
14 import { CelerIM } from "lifi/Helpers/CelerIMFacetBase.sol";
15 import { MessageSenderLib, MsgDataTypes, IMessageBus, IOriginalTokenVault, IPeggedTokenBridge, IOriginalTokenVaultV2, IPeggedTokenBridgeV2 } from "celer-network/contracts/message/libraries/MessageSenderLib.sol";
16 import { IBridge as ICBridge } from "celer-network/contracts/interfaces/IBridge.sol";
17 
18 /// @title RelayerCelerIM
19 /// @author LI.FI (https://li.fi)
20 /// @notice Relayer contract for CelerIM that forwards calls and handles refunds on src side and acts receiver on dest
21 /// @custom:version 2.0.0
22 contract RelayerCelerIM is ILiFi, TransferrableOwnership {
23     using SafeERC20 for IERC20;
24 
25     /// Storage ///
26 
27     IMessageBus public cBridgeMessageBus;
28     address public diamondAddress;
29 
30     /// Events ///
31 
32     event LogWithdraw(
33         address indexed _assetAddress,
34         address indexed _to,
35         uint256 amount
36     );
37 
38     /// Modifiers ///
39 
40     modifier onlyCBridgeMessageBus() {
41         if (msg.sender != address(cBridgeMessageBus)) revert UnAuthorized();
42         _;
43     }
44     modifier onlyDiamond() {
45         if (msg.sender != diamondAddress) revert UnAuthorized();
46         _;
47     }
48 
49     /// Constructor
50 
51     constructor(
52         address _cBridgeMessageBusAddress,
53         address _owner,
54         address _diamondAddress
55     ) TransferrableOwnership(_owner) {
56         owner = _owner;
57         cBridgeMessageBus = IMessageBus(_cBridgeMessageBusAddress);
58         diamondAddress = _diamondAddress;
59     }
60 
61     /// External Methods ///
62 
63     /**
64      * @notice Called by MessageBus to execute a message with an associated token transfer.
65      * The Receiver is guaranteed to have received the right amount of tokens before this function is called.
66      * @param * (unused) The address of the source app contract
67      * @param _token The address of the token that comes out of the bridge
68      * @param _amount The amount of tokens received at this contract through the cross-chain bridge.
69      * @param * (unused)  The source chain ID where the transfer is originated from
70      * @param _message Arbitrary message bytes originated from and encoded by the source app contract
71      * @param * (unused)  Address who called the MessageBus execution function
72      */
73     function executeMessageWithTransfer(
74         address,
75         address _token,
76         uint256 _amount,
77         uint64,
78         bytes calldata _message,
79         address
80     )
81         external
82         payable
83         onlyCBridgeMessageBus
84         returns (IMessageReceiverApp.ExecutionStatus)
85     {
86         // decode message
87         (
88             bytes32 transactionId,
89             LibSwap.SwapData[] memory swapData,
90             address receiver,
91             address refundAddress
92         ) = abi.decode(
93                 _message,
94                 (bytes32, LibSwap.SwapData[], address, address)
95             );
96 
97         _swapAndCompleteBridgeTokens(
98             transactionId,
99             swapData,
100             _token,
101             payable(receiver),
102             _amount,
103             refundAddress
104         );
105 
106         return IMessageReceiverApp.ExecutionStatus.Success;
107     }
108 
109     /**
110      * @notice Called by MessageBus to process refund of the original transfer from this contract.
111      * The contract is guaranteed to have received the refund before this function is called.
112      * @param _token The token address of the original transfer
113      * @param _amount The amount of the original transfer
114      * @param _message The same message associated with the original transfer
115      * @param * (unused) Address who called the MessageBus execution function
116      */
117     function executeMessageWithTransferRefund(
118         address _token,
119         uint256 _amount,
120         bytes calldata _message,
121         address
122     )
123         external
124         payable
125         onlyCBridgeMessageBus
126         returns (IMessageReceiverApp.ExecutionStatus)
127     {
128         (bytes32 transactionId, , , address refundAddress) = abi.decode(
129             _message,
130             (bytes32, LibSwap.SwapData[], address, address)
131         );
132 
133         // return funds to cBridgeData.refundAddress
134         LibAsset.transferAsset(_token, payable(refundAddress), _amount);
135 
136         emit LiFiTransferRecovered(
137             transactionId,
138             _token,
139             refundAddress,
140             _amount,
141             block.timestamp
142         );
143 
144         return IMessageReceiverApp.ExecutionStatus.Success;
145     }
146 
147     /**
148      * @notice Forwards a call to transfer tokens to cBridge (sent via this contract to ensure that potential refunds are sent here)
149      * @param _bridgeData the core information needed for bridging
150      * @param _celerIMData data specific to CelerIM
151      */
152     // solhint-disable-next-line code-complexity
153     function sendTokenTransfer(
154         ILiFi.BridgeData memory _bridgeData,
155         CelerIM.CelerIMData calldata _celerIMData
156     )
157         external
158         payable
159         onlyDiamond
160         returns (bytes32 transferId, address bridgeAddress)
161     {
162         // approve to and call correct bridge depending on BridgeSendType
163         // @dev copied and slightly adapted from Celer MessageSenderLib
164         if (_celerIMData.bridgeType == MsgDataTypes.BridgeSendType.Liquidity) {
165             bridgeAddress = cBridgeMessageBus.liquidityBridge();
166             if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
167                 // case: native asset bridging
168                 ICBridge(bridgeAddress).sendNative{
169                     value: _bridgeData.minAmount
170                 }(
171                     _bridgeData.receiver,
172                     _bridgeData.minAmount,
173                     uint64(_bridgeData.destinationChainId),
174                     _celerIMData.nonce,
175                     _celerIMData.maxSlippage
176                 );
177             } else {
178                 // case: ERC20 asset bridging
179                 LibAsset.maxApproveERC20(
180                     IERC20(_bridgeData.sendingAssetId),
181                     bridgeAddress,
182                     _bridgeData.minAmount
183                 );
184                 // solhint-disable-next-line check-send-result
185                 ICBridge(bridgeAddress).send(
186                     _bridgeData.receiver,
187                     _bridgeData.sendingAssetId,
188                     _bridgeData.minAmount,
189                     uint64(_bridgeData.destinationChainId),
190                     _celerIMData.nonce,
191                     _celerIMData.maxSlippage
192                 );
193             }
194             transferId = MessageSenderLib.computeLiqBridgeTransferId(
195                 _bridgeData.receiver,
196                 _bridgeData.sendingAssetId,
197                 _bridgeData.minAmount,
198                 uint64(_bridgeData.destinationChainId),
199                 _celerIMData.nonce
200             );
201         } else if (
202             _celerIMData.bridgeType == MsgDataTypes.BridgeSendType.PegDeposit
203         ) {
204             bridgeAddress = cBridgeMessageBus.pegVault();
205             LibAsset.maxApproveERC20(
206                 IERC20(_bridgeData.sendingAssetId),
207                 bridgeAddress,
208                 _bridgeData.minAmount
209             );
210             IOriginalTokenVault(bridgeAddress).deposit(
211                 _bridgeData.sendingAssetId,
212                 _bridgeData.minAmount,
213                 uint64(_bridgeData.destinationChainId),
214                 _bridgeData.receiver,
215                 _celerIMData.nonce
216             );
217             transferId = MessageSenderLib.computePegV1DepositId(
218                 _bridgeData.receiver,
219                 _bridgeData.sendingAssetId,
220                 _bridgeData.minAmount,
221                 uint64(_bridgeData.destinationChainId),
222                 _celerIMData.nonce
223             );
224         } else if (
225             _celerIMData.bridgeType == MsgDataTypes.BridgeSendType.PegBurn
226         ) {
227             bridgeAddress = cBridgeMessageBus.pegBridge();
228             LibAsset.maxApproveERC20(
229                 IERC20(_bridgeData.sendingAssetId),
230                 bridgeAddress,
231                 _bridgeData.minAmount
232             );
233             IPeggedTokenBridge(bridgeAddress).burn(
234                 _bridgeData.sendingAssetId,
235                 _bridgeData.minAmount,
236                 _bridgeData.receiver,
237                 _celerIMData.nonce
238             );
239             transferId = MessageSenderLib.computePegV1BurnId(
240                 _bridgeData.receiver,
241                 _bridgeData.sendingAssetId,
242                 _bridgeData.minAmount,
243                 _celerIMData.nonce
244             );
245         } else if (
246             _celerIMData.bridgeType == MsgDataTypes.BridgeSendType.PegV2Deposit
247         ) {
248             bridgeAddress = cBridgeMessageBus.pegVaultV2();
249             if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
250                 // case: native asset bridging
251                 transferId = IOriginalTokenVaultV2(bridgeAddress)
252                     .depositNative{ value: _bridgeData.minAmount }(
253                     _bridgeData.minAmount,
254                     uint64(_bridgeData.destinationChainId),
255                     _bridgeData.receiver,
256                     _celerIMData.nonce
257                 );
258             } else {
259                 // case: ERC20 bridging
260                 LibAsset.maxApproveERC20(
261                     IERC20(_bridgeData.sendingAssetId),
262                     bridgeAddress,
263                     _bridgeData.minAmount
264                 );
265                 transferId = IOriginalTokenVaultV2(bridgeAddress).deposit(
266                     _bridgeData.sendingAssetId,
267                     _bridgeData.minAmount,
268                     uint64(_bridgeData.destinationChainId),
269                     _bridgeData.receiver,
270                     _celerIMData.nonce
271                 );
272             }
273         } else if (
274             _celerIMData.bridgeType == MsgDataTypes.BridgeSendType.PegV2Burn
275         ) {
276             bridgeAddress = cBridgeMessageBus.pegBridgeV2();
277             LibAsset.maxApproveERC20(
278                 IERC20(_bridgeData.sendingAssetId),
279                 bridgeAddress,
280                 _bridgeData.minAmount
281             );
282             transferId = IPeggedTokenBridgeV2(bridgeAddress).burn(
283                 _bridgeData.sendingAssetId,
284                 _bridgeData.minAmount,
285                 uint64(_bridgeData.destinationChainId),
286                 _bridgeData.receiver,
287                 _celerIMData.nonce
288             );
289         } else if (
290             _celerIMData.bridgeType ==
291             MsgDataTypes.BridgeSendType.PegV2BurnFrom
292         ) {
293             bridgeAddress = cBridgeMessageBus.pegBridgeV2();
294             LibAsset.maxApproveERC20(
295                 IERC20(_bridgeData.sendingAssetId),
296                 bridgeAddress,
297                 _bridgeData.minAmount
298             );
299             transferId = IPeggedTokenBridgeV2(bridgeAddress).burnFrom(
300                 _bridgeData.sendingAssetId,
301                 _bridgeData.minAmount,
302                 uint64(_bridgeData.destinationChainId),
303                 _bridgeData.receiver,
304                 _celerIMData.nonce
305             );
306         } else {
307             revert InvalidConfig();
308         }
309     }
310 
311     /**
312      * @notice Forwards a call to the CBridge Messagebus
313      * @param _receiver The address of the destination app contract.
314      * @param _dstChainId The destination chain ID.
315      * @param _srcBridge The bridge contract to send the transfer with.
316      * @param _srcTransferId The transfer ID.
317      * @param _dstChainId The destination chain ID.
318      * @param _message Arbitrary message bytes to be decoded by the destination app contract.
319      */
320     function forwardSendMessageWithTransfer(
321         address _receiver,
322         uint256 _dstChainId,
323         address _srcBridge,
324         bytes32 _srcTransferId,
325         bytes calldata _message
326     ) external payable onlyDiamond {
327         cBridgeMessageBus.sendMessageWithTransfer{ value: msg.value }(
328             _receiver,
329             _dstChainId,
330             _srcBridge,
331             _srcTransferId,
332             _message
333         );
334     }
335 
336     // ------------------------------------------------------------------------------------------------
337 
338     /// Private Methods ///
339 
340     /// @notice Performs a swap before completing a cross-chain transaction
341     /// @param _transactionId the transaction id associated with the operation
342     /// @param _swapData array of data needed for swaps
343     /// @param assetId token received from the other chain
344     /// @param receiver address that will receive tokens in the end
345     /// @param amount amount of token
346     function _swapAndCompleteBridgeTokens(
347         bytes32 _transactionId,
348         LibSwap.SwapData[] memory _swapData,
349         address assetId,
350         address payable receiver,
351         uint256 amount,
352         address refundAddress
353     ) private {
354         bool success;
355         IExecutor executor = IExecutor(
356             PeripheryRegistryFacet(diamondAddress).getPeripheryContract(
357                 "Executor"
358             )
359         );
360         if (LibAsset.isNativeAsset(assetId)) {
361             try
362                 executor.swapAndCompleteBridgeTokens{ value: amount }(
363                     _transactionId,
364                     _swapData,
365                     assetId,
366                     receiver
367                 )
368             {
369                 success = true;
370             } catch {
371                 // solhint-disable-next-line avoid-low-level-calls
372                 (bool fundsSent, ) = refundAddress.call{ value: amount }("");
373                 if (!fundsSent) {
374                     revert ExternalCallFailed();
375                 }
376             }
377         } else {
378             IERC20 token = IERC20(assetId);
379             token.safeApprove(address(executor), 0);
380             token.safeIncreaseAllowance(address(executor), amount);
381 
382             try
383                 executor.swapAndCompleteBridgeTokens(
384                     _transactionId,
385                     _swapData,
386                     assetId,
387                     receiver
388                 )
389             {
390                 success = true;
391             } catch {
392                 token.safeTransfer(refundAddress, amount);
393             }
394             token.safeApprove(address(executor), 0);
395         }
396 
397         if (!success) {
398             emit LiFiTransferRecovered(
399                 _transactionId,
400                 assetId,
401                 refundAddress,
402                 amount,
403                 block.timestamp
404             );
405         }
406     }
407 
408     /// @notice Sends remaining token to given receiver address (for refund cases)
409     /// @param assetId Address of the token to be withdrawn
410     /// @param receiver Address that will receive tokens
411     /// @param amount Amount of tokens to be withdrawn
412     function withdraw(
413         address assetId,
414         address payable receiver,
415         uint256 amount
416     ) external onlyOwner {
417         if (LibAsset.isNativeAsset(assetId)) {
418             // solhint-disable-next-line avoid-low-level-calls
419             (bool success, ) = receiver.call{ value: amount }("");
420             if (!success) {
421                 revert WithdrawFailed();
422             }
423         } else {
424             IERC20(assetId).safeTransfer(receiver, amount);
425         }
426         emit LogWithdraw(assetId, receiver, amount);
427     }
428 
429     /// @notice Triggers a cBridge refund with calldata produced by cBridge API
430     /// @param _callTo The address to execute the calldata on
431     /// @param _callData The data to execute
432     /// @param _assetAddress Asset to be withdrawn
433     /// @param _to Address to withdraw to
434     /// @param _amount Amount of asset to withdraw
435     function triggerRefund(
436         address payable _callTo,
437         bytes calldata _callData,
438         address _assetAddress,
439         address _to,
440         uint256 _amount
441     ) external onlyOwner {
442         bool success;
443 
444         // make sure that callTo address is either of the cBridge addresses
445         if (
446             cBridgeMessageBus.liquidityBridge() != _callTo &&
447             cBridgeMessageBus.pegBridge() != _callTo &&
448             cBridgeMessageBus.pegBridgeV2() != _callTo &&
449             cBridgeMessageBus.pegVault() != _callTo &&
450             cBridgeMessageBus.pegVaultV2() != _callTo
451         ) {
452             revert ContractCallNotAllowed();
453         }
454 
455         // call contract
456         // solhint-disable-next-line avoid-low-level-calls
457         (success, ) = _callTo.call(_callData);
458 
459         // forward funds to _to address and emit event, if cBridge refund successful
460         if (success) {
461             address sendTo = (LibUtil.isZeroAddress(_to)) ? msg.sender : _to;
462             LibAsset.transferAsset(_assetAddress, payable(sendTo), _amount);
463             emit LogWithdraw(_assetAddress, sendTo, _amount);
464         } else {
465             revert WithdrawFailed();
466         }
467     }
468 
469     // required in order to receive native tokens from cBridge facet
470     // solhint-disable-next-line no-empty-blocks
471     receive() external payable {}
472 }
