1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { IAcrossSpokePool } from "../Interfaces/IAcrossSpokePool.sol";
5 import { TransferrableOwnership } from "../Helpers/TransferrableOwnership.sol";
6 import { AcrossFacet } from "./AcrossFacet.sol";
7 import { ILiFi } from "../Interfaces/ILiFi.sol";
8 import { ERC20, SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
9 import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
10 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
11 import { console2 } from "forge-std/console2.sol";
12 
13 /// @title AcrossFacetPacked
14 /// @author LI.FI (https://li.fi)
15 /// @notice Provides functionality for bridging through Across in a gas-optimized way
16 /// @custom:version 1.0.0
17 contract AcrossFacetPacked is ILiFi, TransferrableOwnership {
18     using SafeTransferLib for ERC20;
19 
20     bytes public constant ACROSS_REFERRER_DELIMITER = hex"d00dfeeddeadbeef";
21     uint8 private constant ACROSS_REFERRER_ADDRESS_LENGTH = 20;
22     uint256 private constant REFERRER_OFFSET = 28;
23 
24     /// Storage ///
25 
26     /// @notice The contract address of the cbridge on the source chain.
27     IAcrossSpokePool private immutable spokePool;
28 
29     /// @notice The WETH address on the current chain.
30     address private immutable wrappedNative;
31 
32     /// Events ///
33 
34     event LiFiAcrossTransfer(bytes8 _transactionId);
35     event CallExecutedAndFundsWithdrawn();
36 
37     /// Errors ///
38 
39     error WithdrawFailed();
40 
41     /// Constructor ///
42 
43     /// @notice Initialize the contract
44     /// @param _spokePool The contract address of the spoke pool on the source chain
45     /// @param _wrappedNative The address of the wrapped native token on the source chain
46     /// @param _owner The address of the contract owner
47     constructor(
48         IAcrossSpokePool _spokePool,
49         address _wrappedNative,
50         address _owner
51     ) TransferrableOwnership(_owner) {
52         spokePool = _spokePool;
53         wrappedNative = _wrappedNative;
54     }
55 
56     /// External Methods ///
57 
58     /// @dev Only meant to be called outside of the context of the diamond
59     /// @notice Sets approval for the Across spoke pool Router to spend the specified token
60     /// @param tokensToApprove The tokens to approve to the Across spoke pool
61     function setApprovalForBridge(
62         address[] calldata tokensToApprove
63     ) external onlyOwner {
64         for (uint256 i; i < tokensToApprove.length; i++) {
65             // Give Across spoke pool approval to pull tokens from this facet
66             LibAsset.maxApproveERC20(
67                 IERC20(tokensToApprove[i]),
68                 address(spokePool),
69                 type(uint256).max
70             );
71         }
72     }
73 
74     /// @notice Bridges native tokens via Across (packed implementation)
75     /// No params, all data will be extracted from manually encoded callData
76     function startBridgeTokensViaAcrossNativePacked() external payable {
77         // calculate end of calldata (and start of delimiter + referrer address)
78         uint256 calldataEndsAt = msg.data.length - REFERRER_OFFSET;
79 
80         // call Across spoke pool to bridge assets
81         spokePool.deposit{ value: msg.value }(
82             address(bytes20(msg.data[12:32])), // receiver
83             wrappedNative, // wrappedNative address
84             msg.value, // minAmount
85             uint64(uint32(bytes4(msg.data[32:36]))), // destinationChainId
86             int64(uint64(bytes8(msg.data[36:44]))), // int64 relayerFeePct
87             uint32(bytes4(msg.data[44:48])), // uint32 quoteTimestamp
88             msg.data[80:calldataEndsAt], // bytes message (due to variable length positioned at the end of the calldata)
89             uint256(bytes32(msg.data[48:80])) // uint256 maxCount
90         );
91 
92         emit LiFiAcrossTransfer(bytes8(msg.data[4:12]));
93     }
94 
95     /// @notice Bridges native tokens via Across (minimal implementation)
96     /// @param transactionId Custom transaction ID for tracking
97     /// @param receiver Receiving wallet address
98     /// @param destinationChainId Receiving chain
99     /// @param relayerFeePct The relayer fee in token percentage with 18 decimals
100     /// @param quoteTimestamp The timestamp associated with the suggested fee
101     /// @param message Arbitrary data that can be used to pass additional information to the recipient along with the tokens
102     /// @param maxCount Used to protect the depositor from frontrunning to guarantee their quote remains valid
103     function startBridgeTokensViaAcrossNativeMin(
104         bytes32 transactionId,
105         address receiver,
106         uint256 destinationChainId,
107         int64 relayerFeePct,
108         uint32 quoteTimestamp,
109         bytes calldata message,
110         uint256 maxCount
111     ) external payable {
112         // call Across spoke pool to bridge assets
113         spokePool.deposit{ value: msg.value }(
114             receiver,
115             wrappedNative,
116             msg.value,
117             destinationChainId,
118             relayerFeePct,
119             quoteTimestamp,
120             message,
121             maxCount
122         );
123 
124         emit LiFiAcrossTransfer(bytes8(transactionId));
125     }
126 
127     /// @notice Bridges ERC20 tokens via Across (packed implementation)
128     /// No params, all data will be extracted from manually encoded callData
129     function startBridgeTokensViaAcrossERC20Packed() external payable {
130         address sendingAssetId = address(bytes20(msg.data[32:52]));
131         uint256 minAmount = uint256(uint128(bytes16(msg.data[52:68])));
132 
133         // Deposit assets
134         ERC20(sendingAssetId).safeTransferFrom(
135             msg.sender,
136             address(this),
137             minAmount
138         );
139 
140         // calculate end of calldata (and start of delimiter + referrer address)
141         uint256 calldataEndsAt = msg.data.length - REFERRER_OFFSET;
142 
143         // call Across spoke pool to bridge assets
144         spokePool.deposit(
145             address(bytes20(msg.data[12:32])), // receiver
146             address(bytes20(msg.data[32:52])), // sendingAssetID
147             minAmount,
148             uint64(uint32(bytes4(msg.data[68:72]))), // destinationChainId
149             int64(uint64(bytes8(msg.data[72:80]))), // int64 relayerFeePct
150             uint32(bytes4(msg.data[80:84])), // uint32 quoteTimestamp
151             msg.data[116:calldataEndsAt], // bytes message (due to variable length positioned at the end of the calldata)
152             uint256(bytes32(msg.data[84:116])) // uint256 maxCount
153         );
154 
155         emit LiFiAcrossTransfer(bytes8(msg.data[4:12]));
156     }
157 
158     /// @notice Bridges ERC20 tokens via Across (minimal implementation)
159     /// @param transactionId Custom transaction ID for tracking
160     /// @param sendingAssetId The address of the asset/token to be bridged
161     /// @param minAmount The amount to be bridged
162     /// @param receiver Receiving wallet address
163     /// @param destinationChainId Receiving chain
164     /// @param relayerFeePct The relayer fee in token percentage with 18 decimals
165     /// @param quoteTimestamp The timestamp associated with the suggested fee
166     /// @param message Arbitrary data that can be used to pass additional information to the recipient along with the tokens
167     /// @param maxCount Used to protect the depositor from frontrunning to guarantee their quote remains valid
168     function startBridgeTokensViaAcrossERC20Min(
169         bytes32 transactionId,
170         address sendingAssetId,
171         uint256 minAmount,
172         address receiver,
173         uint64 destinationChainId,
174         int64 relayerFeePct,
175         uint32 quoteTimestamp,
176         bytes calldata message,
177         uint256 maxCount
178     ) external payable {
179         // Deposit assets
180         ERC20(sendingAssetId).safeTransferFrom(
181             msg.sender,
182             address(this),
183             minAmount
184         );
185 
186         // call Across spoke pool to bridge assets
187         spokePool.deposit(
188             receiver,
189             sendingAssetId,
190             minAmount,
191             destinationChainId,
192             relayerFeePct,
193             quoteTimestamp,
194             message,
195             maxCount
196         );
197 
198         emit LiFiAcrossTransfer(bytes8(transactionId));
199     }
200 
201     /// @notice Encodes calldata that can be used to call the native 'packed' function
202     /// @param transactionId Custom transaction ID for tracking
203     /// @param receiver Receiving wallet address
204     /// @param destinationChainId Receiving chain
205     /// @param relayerFeePct The relayer fee in token percentage with 18 decimals
206     /// @param quoteTimestamp The timestamp associated with the suggested fee
207     /// @param message Arbitrary data that can be used to pass additional information to the recipient along with the tokens
208     /// @param maxCount Used to protect the depositor from frontrunning to guarantee their quote remains valid
209     function encode_startBridgeTokensViaAcrossNativePacked(
210         bytes32 transactionId,
211         address receiver,
212         uint64 destinationChainId,
213         int64 relayerFeePct,
214         uint32 quoteTimestamp,
215         uint256 maxCount,
216         bytes calldata message
217     ) external pure returns (bytes memory) {
218         // there are already existing networks with chainIds outside uint32 range but since we not support either of them yet,
219         // we feel comfortable using this approach to save further gas
220         require(
221             destinationChainId <= type(uint32).max,
222             "destinationChainId value passed too big to fit in uint32"
223         );
224 
225         return
226             bytes.concat(
227                 AcrossFacetPacked
228                     .startBridgeTokensViaAcrossNativePacked
229                     .selector,
230                 bytes8(transactionId),
231                 bytes20(receiver),
232                 bytes4(uint32(destinationChainId)),
233                 bytes8(uint64(relayerFeePct)),
234                 bytes4(quoteTimestamp),
235                 bytes32(maxCount),
236                 message
237             );
238     }
239 
240     /// @notice Encodes calldata that can be used to call the ERC20 'packed' function
241     /// @param transactionId Custom transaction ID for tracking
242     /// @param receiver Receiving wallet address
243     /// @param sendingAssetId The address of the asset/token to be bridged
244     /// @param minAmount The amount to be bridged
245     /// @param destinationChainId Receiving chain
246     /// @param relayerFeePct The relayer fee in token percentage with 18 decimals
247     /// @param quoteTimestamp The timestamp associated with the suggested fee
248     /// @param message Arbitrary data that can be used to pass additional information to the recipient along with the tokens
249     /// @param maxCount Used to protect the depositor from frontrunning to guarantee their quote remains valid
250     function encode_startBridgeTokensViaAcrossERC20Packed(
251         bytes32 transactionId,
252         address receiver,
253         address sendingAssetId,
254         uint256 minAmount,
255         uint256 destinationChainId,
256         int64 relayerFeePct,
257         uint32 quoteTimestamp,
258         bytes calldata message,
259         uint256 maxCount
260     ) external pure returns (bytes memory) {
261         // there are already existing networks with chainIds outside uint32 range but since we not support either of them yet,
262         // we feel comfortable using this approach to save further gas
263         require(
264             destinationChainId <= type(uint32).max,
265             "destinationChainId value passed too big to fit in uint32"
266         );
267 
268         require(
269             minAmount <= type(uint128).max,
270             "minAmount value passed too big to fit in uint128"
271         );
272 
273         return
274             bytes.concat(
275                 AcrossFacetPacked
276                     .startBridgeTokensViaAcrossERC20Packed
277                     .selector,
278                 bytes8(transactionId),
279                 bytes20(receiver),
280                 bytes20(sendingAssetId),
281                 bytes16(uint128(minAmount)),
282                 bytes4(uint32(destinationChainId)),
283                 bytes8(uint64(relayerFeePct)),
284                 bytes4(uint32(quoteTimestamp)),
285                 bytes32(maxCount),
286                 message
287             );
288     }
289 
290     /// @notice Decodes calldata that is meant to be used for calling the native 'packed' function
291     /// @param data the calldata to be decoded
292     function decode_startBridgeTokensViaAcrossNativePacked(
293         bytes calldata data
294     )
295         external
296         pure
297         returns (
298             BridgeData memory bridgeData,
299             AcrossFacet.AcrossData memory acrossData
300         )
301     {
302         require(
303             data.length >= 108,
304             "invalid calldata (must have length > 108)"
305         );
306 
307         // calculate end of calldata (and start of delimiter + referrer address)
308         uint256 calldataEndsAt = data.length - REFERRER_OFFSET;
309 
310         // extract bridgeData
311         bridgeData.transactionId = bytes32(bytes8(data[4:12]));
312         bridgeData.receiver = address(bytes20(data[12:32]));
313         bridgeData.destinationChainId = uint64(uint32(bytes4(data[32:36])));
314 
315         // extract acrossData
316         acrossData.relayerFeePct = int64(uint64(bytes8(data[36:44])));
317         acrossData.quoteTimestamp = uint32(bytes4(data[44:48]));
318         acrossData.maxCount = uint256(bytes32(data[48:80]));
319         acrossData.message = data[80:calldataEndsAt];
320 
321         return (bridgeData, acrossData);
322     }
323 
324     /// @notice Decodes calldata that is meant to be used for calling the ERC20 'packed' function
325     /// @param data the calldata to be decoded
326     function decode_startBridgeTokensViaAcrossERC20Packed(
327         bytes calldata data
328     )
329         external
330         pure
331         returns (
332             BridgeData memory bridgeData,
333             AcrossFacet.AcrossData memory acrossData
334         )
335     {
336         require(
337             data.length >= 144,
338             "invalid calldata (must have length > 144)"
339         );
340 
341         // calculate end of calldata (and start of delimiter + referrer address)
342         uint256 calldataEndsAt = data.length - REFERRER_OFFSET;
343 
344         bridgeData.transactionId = bytes32(bytes8(data[4:12]));
345         bridgeData.receiver = address(bytes20(data[12:32]));
346         bridgeData.sendingAssetId = address(bytes20(data[32:52]));
347         bridgeData.minAmount = uint256(uint128(bytes16(data[52:68])));
348         bridgeData.destinationChainId = uint64(uint32(bytes4(data[68:72])));
349 
350         // extract acrossData
351         acrossData.relayerFeePct = int64(uint64(bytes8(data[72:80])));
352         acrossData.quoteTimestamp = uint32(bytes4(data[80:84]));
353         acrossData.maxCount = uint256(bytes32(data[84:116]));
354         acrossData.message = data[116:calldataEndsAt];
355 
356         return (bridgeData, acrossData);
357     }
358 
359     /// @notice Execute calldata and withdraw asset
360     /// @param _callTo The address to execute the calldata on
361     /// @param _callData The data to execute
362     /// @param _assetAddress Asset to be withdrawn
363     /// @param _to address to withdraw to
364     /// @param _amount amount of asset to withdraw
365     function executeCallAndWithdraw(
366         address _callTo,
367         bytes calldata _callData,
368         address _assetAddress,
369         address _to,
370         uint256 _amount
371     ) external onlyOwner {
372         // execute calldata
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, ) = _callTo.call(_callData);
375 
376         // check success of call
377         if (success) {
378             // call successful - withdraw the asset
379             LibAsset.transferAsset(_assetAddress, payable(_to), _amount);
380             emit CallExecutedAndFundsWithdrawn();
381         } else {
382             // call unsuccessful - revert
383             revert WithdrawFailed();
384         }
385     }
386 }
