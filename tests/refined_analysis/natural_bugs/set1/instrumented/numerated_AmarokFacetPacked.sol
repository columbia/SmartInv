1 // // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { IConnextHandler } from "../Interfaces/IConnextHandler.sol";
5 import { ILiFi } from "../Interfaces/ILiFi.sol";
6 import { ERC20, SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
7 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
8 import { TransferrableOwnership } from "../Helpers/TransferrableOwnership.sol";
9 import { AmarokFacet } from "lifi/Facets/AmarokFacet.sol";
10 import { console2 } from "forge-std/console2.sol";
11 
12 /// @title AmarokFacetPacked
13 /// @author LI.FI (https://li.fi)
14 /// @notice Provides functionality for bridging through Amarok in a gas-optimized way
15 /// @custom:version 1.0.0
16 contract AmarokFacetPacked is ILiFi, TransferrableOwnership {
17     using SafeTransferLib for ERC20;
18 
19     /// Storage
20 
21     /// @notice The contract address of the connext handler on the source chain.
22     IConnextHandler private immutable connextHandler;
23 
24     /// Events ///
25 
26     event LiFiAmarokTransfer(bytes8 _transactionId);
27 
28     /// Constructor ///
29 
30     /// @notice Initialize the contract.
31     /// @param _connextHandler The contract address of the connext handler on the source chain.
32     /// @param _owner The contract owner to approve tokens.
33     constructor(
34         IConnextHandler _connextHandler,
35         address _owner
36     ) TransferrableOwnership(_owner) {
37         connextHandler = _connextHandler;
38     }
39 
40     /// External Methods ///
41 
42     /// @dev Only meant to be called outside of the context of the diamond
43     /// @notice Sets approval for the Amarok bridge to spend the specified token
44     /// @param tokensToApprove The tokens to approve to approve to the Amarok bridge
45     function setApprovalForBridge(
46         address[] calldata tokensToApprove
47     ) external onlyOwner {
48         uint256 numTokens = tokensToApprove.length;
49 
50         for (uint256 i; i < numTokens; i++) {
51             // Give Amarok approval to bridge tokens
52             LibAsset.maxApproveERC20(
53                 IERC20(tokensToApprove[i]),
54                 address(connextHandler),
55                 type(uint256).max
56             );
57         }
58     }
59 
60     /// @notice Bridges ERC20 tokens via Amarok
61     /// No params, all data will be extracted from manually encoded callData
62     function startBridgeTokensViaAmarokERC20PackedPayFeeWithAsset() external {
63         // extract parameters that are used multiple times in this function
64         address sendingAssetId = address(bytes20(msg.data[32:52]));
65         uint256 minAmount = uint256(uint128(bytes16(msg.data[52:68])));
66         address receiver = address(bytes20(msg.data[12:32]));
67         uint256 relayerFee = uint64(uint32(bytes4(msg.data[76:92])));
68 
69         // Deposit assets
70         ERC20(sendingAssetId).safeTransferFrom(
71             msg.sender,
72             address(this),
73             minAmount
74         );
75 
76         // call Amarok bridge
77         connextHandler.xcall(
78             uint32(bytes4(msg.data[68:72])), // _destChainDomainId
79             receiver, // _to
80             sendingAssetId,
81             receiver, // _delegate
82             minAmount - relayerFee,
83             uint256(uint128(uint64(uint32(bytes4(msg.data[72:76]))))), // slippageTol
84             "", // calldata (not required)
85             relayerFee
86         );
87 
88         emit LiFiAmarokTransfer(bytes8(msg.data[4:12]));
89     }
90 
91     function startBridgeTokensViaAmarokERC20PackedPayFeeWithNative()
92         external
93         payable
94     {
95         // extract parameters that are used multiple times in this function
96         address sendingAssetId = address(bytes20(msg.data[32:52]));
97         uint256 minAmount = uint256(uint128(bytes16(msg.data[52:68])));
98         address receiver = address(bytes20(msg.data[12:32]));
99 
100         // Deposit assets
101         ERC20(sendingAssetId).safeTransferFrom(
102             msg.sender,
103             address(this),
104             minAmount
105         );
106 
107         // call Amarok bridge
108         connextHandler.xcall{ value: msg.value }(
109             uint32(bytes4(msg.data[68:72])), // destChainDomainId
110             receiver, // _to
111             sendingAssetId,
112             receiver, // _delegate
113             minAmount,
114             uint256(uint128(uint64(uint32(bytes4(msg.data[72:76]))))), // slippageTol
115             "" // calldata (not required)
116         );
117 
118         emit LiFiAmarokTransfer(bytes8(msg.data[4:12]));
119     }
120 
121     /// @notice Bridges ERC20 tokens via Amarok
122     /// @param transactionId Custom transaction ID for tracking
123     /// @param receiver Receiving wallet address
124     /// @param sendingAssetId Address of the source asset to bridge
125     /// @param minAmount Amount of the source asset to bridge
126     /// @param destChainDomainId The Amarok-specific domainId of the destination chain
127     /// @param slippageTol Maximum acceptable slippage in BPS. For example, a value of 30 means 0.3% slippage
128     /// @param relayerFee The amount of relayer fee the tx called xcall with
129     function startBridgeTokensViaAmarokERC20MinPayFeeWithAsset(
130         bytes32 transactionId,
131         address receiver,
132         address sendingAssetId,
133         uint256 minAmount,
134         uint32 destChainDomainId,
135         uint256 slippageTol,
136         uint256 relayerFee
137     ) external {
138         // Deposit assets
139         ERC20(sendingAssetId).safeTransferFrom(
140             msg.sender,
141             address(this),
142             minAmount
143         );
144 
145         // Bridge assets
146         connextHandler.xcall(
147             destChainDomainId,
148             receiver, // _to
149             sendingAssetId,
150             receiver, // _delegate
151             minAmount - relayerFee,
152             slippageTol,
153             "", // calldata (not required)
154             relayerFee
155         );
156 
157         emit LiFiAmarokTransfer(bytes8(transactionId));
158     }
159 
160     /// @notice Bridges ERC20 tokens via Amarok
161     /// @param transactionId Custom transaction ID for tracking
162     /// @param receiver Receiving wallet address
163     /// @param sendingAssetId Address of the source asset to bridge
164     /// @param minAmount Amount of the source asset to bridge
165     /// @param destChainDomainId The Amarok-specific domainId of the destination chain
166     /// @param slippageTol Maximum acceptable slippage in BPS. For example, a value of 30 means 0.3% slippage
167     function startBridgeTokensViaAmarokERC20MinPayFeeWithNative(
168         bytes32 transactionId,
169         address receiver,
170         address sendingAssetId,
171         uint256 minAmount,
172         uint32 destChainDomainId,
173         uint256 slippageTol
174     ) external payable {
175         // Deposit assets
176         ERC20(sendingAssetId).safeTransferFrom(
177             msg.sender,
178             address(this),
179             minAmount
180         );
181 
182         // Bridge assets
183         connextHandler.xcall{ value: msg.value }(
184             destChainDomainId,
185             receiver, // _to
186             sendingAssetId,
187             receiver, // _delegate
188             minAmount,
189             slippageTol,
190             "" // calldata (not required)
191         );
192 
193         emit LiFiAmarokTransfer(bytes8(transactionId));
194     }
195 
196     /// @notice Encode call data to bridge ERC20 tokens via Amarok
197     /// @param transactionId Custom transaction ID for tracking
198     /// @param receiver Receiving wallet address
199     /// @param sendingAssetId Address of the source asset to bridge
200     /// @param minAmount Amount of the source asset to bridge
201     /// @param destChainDomainId The Amarok-specific domainId of the destination chain
202     /// @param slippageTol Max bps of original due to slippage (i.e. would be 9995 to tolerate .05% slippage)
203     /// @param relayerFee The amount of relayer fee the tx called xcall with
204     function encode_startBridgeTokensViaAmarokERC20PackedPayFeeWithAsset(
205         bytes32 transactionId,
206         address receiver,
207         address sendingAssetId,
208         uint256 minAmount,
209         uint32 destChainDomainId,
210         uint256 slippageTol,
211         uint256 relayerFee
212     ) external pure returns (bytes memory) {
213         require(
214             minAmount <= type(uint128).max,
215             "minAmount value passed too big to fit in uint128"
216         );
217         require(
218             slippageTol <= type(uint32).max,
219             "slippageTol value passed too big to fit in uint32"
220         );
221         require(
222             relayerFee <= type(uint128).max,
223             "relayerFee value passed too big to fit in uint128"
224         );
225 
226         return
227             bytes.concat(
228                 AmarokFacetPacked
229                     .startBridgeTokensViaAmarokERC20PackedPayFeeWithAsset
230                     .selector,
231                 bytes8(transactionId), // we only use 8 bytes of the 32bytes txId in order to save gas
232                 bytes20(receiver),
233                 bytes20(sendingAssetId),
234                 bytes16(uint128(minAmount)),
235                 bytes4(destChainDomainId),
236                 bytes4(uint32(slippageTol)),
237                 bytes16(uint128(relayerFee))
238             );
239     }
240 
241     /// @notice Encode call data to bridge ERC20 tokens via Amarok
242     /// @param transactionId Custom transaction ID for tracking
243     /// @param receiver Receiving wallet address
244     /// @param sendingAssetId Address of the source asset to bridge
245     /// @param minAmount Amount of the source asset to bridge
246     /// @param destChainDomainId The Amarok-specific domainId of the destination chain
247     /// @param slippageTol Max bps of original due to slippage (i.e. would be 9995 to tolerate .05% slippage)
248     function encode_startBridgeTokensViaAmarokERC20PackedPayFeeWithNative(
249         bytes32 transactionId,
250         address receiver,
251         address sendingAssetId,
252         uint256 minAmount,
253         uint32 destChainDomainId,
254         uint256 slippageTol
255     ) external pure returns (bytes memory) {
256         require(
257             minAmount <= type(uint128).max,
258             "minAmount value passed too big to fit in uint128"
259         );
260         require(
261             slippageTol <= type(uint32).max,
262             "slippageTol value passed too big to fit in uint32"
263         );
264 
265         return
266             bytes.concat(
267                 AmarokFacetPacked
268                     .startBridgeTokensViaAmarokERC20PackedPayFeeWithNative
269                     .selector,
270                 bytes8(transactionId), // we only use 8 bytes of the 32bytes txId in order to save gas
271                 bytes20(receiver),
272                 bytes20(sendingAssetId),
273                 bytes16(uint128(minAmount)),
274                 bytes4(destChainDomainId),
275                 bytes4(uint32(slippageTol))
276             );
277     }
278 
279     /// @notice Decodes calldata for startBridgeTokensViaAmarokERC20PackedPayFeeWithAsset
280     /// @param _data the calldata to decode
281     function decode_startBridgeTokensViaAmarokERC20PackedPayFeeWithAsset(
282         bytes calldata _data
283     )
284         external
285         pure
286         returns (BridgeData memory, AmarokFacet.AmarokData memory)
287     {
288         require(
289             _data.length >= 92,
290             "data passed in is not the correct length"
291         );
292 
293         BridgeData memory bridgeData;
294         AmarokFacet.AmarokData memory amarokData;
295 
296         uint32 destChainDomainId = uint32(bytes4(_data[68:72]));
297 
298         bridgeData.transactionId = bytes32(bytes8(_data[4:12]));
299         bridgeData.receiver = address(bytes20(_data[12:32]));
300         bridgeData.destinationChainId = getChainIdForDomain(destChainDomainId);
301         bridgeData.sendingAssetId = address(bytes20(_data[32:52]));
302         bridgeData.minAmount = uint256(uint128(bytes16(_data[52:68])));
303 
304         amarokData.callData = "";
305         amarokData.callTo = bridgeData.receiver;
306         amarokData.destChainDomainId = destChainDomainId;
307         amarokData.slippageTol = uint32(bytes4(_data[72:76]));
308         amarokData.relayerFee = uint256(uint128(bytes16(_data[76:92])));
309         amarokData.delegate = bridgeData.receiver;
310         amarokData.payFeeWithSendingAsset = true;
311 
312         return (bridgeData, amarokData);
313     }
314 
315     /// @notice Decodes calldata for startBridgeTokensViaAmarokERC20PackedPayFeeWithNative
316     /// @param _data the calldata to decode
317     function decode_startBridgeTokensViaAmarokERC20PackedPayFeeWithNative(
318         bytes calldata _data
319     )
320         external
321         pure
322         returns (BridgeData memory, AmarokFacet.AmarokData memory)
323     {
324         require(
325             _data.length >= 76,
326             "data passed in is not the correct length"
327         );
328 
329         BridgeData memory bridgeData;
330         AmarokFacet.AmarokData memory amarokData;
331 
332         uint32 destChainDomainId = uint32(bytes4(_data[68:72]));
333 
334         bridgeData.transactionId = bytes32(bytes8(_data[4:12]));
335         bridgeData.receiver = address(bytes20(_data[12:32]));
336         bridgeData.destinationChainId = getChainIdForDomain(destChainDomainId);
337         bridgeData.sendingAssetId = address(bytes20(_data[32:52]));
338         bridgeData.minAmount = uint256(uint128(bytes16(_data[52:68])));
339 
340         amarokData.callData = "";
341         amarokData.callTo = bridgeData.receiver;
342         amarokData.destChainDomainId = destChainDomainId;
343         amarokData.slippageTol = uint256(
344             uint128(uint32(bytes4(_data[72:76])))
345         );
346         amarokData.delegate = bridgeData.receiver;
347         amarokData.payFeeWithSendingAsset = false;
348 
349         return (bridgeData, amarokData);
350     }
351 
352     function getChainIdForDomain(
353         uint32 domainId
354     ) public pure returns (uint32 chainId) {
355         if (domainId == 6648936) return 1;
356         // ETH
357         else if (domainId == 1886350457) return 137;
358         // POL
359         else if (domainId == 6450786) return 56;
360         // BSC
361         else if (domainId == 1869640809) return 10;
362         // OPT
363         else if (domainId == 6778479) return 100;
364         // GNO/DAI
365         else if (domainId == 1634886255) return 42161;
366         // ARB
367         else if (domainId == 1818848877) return 59144; // LIN
368     }
369 }
