1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ICBridge } from "../Interfaces/ICBridge.sol";
5 import { CBridgeFacet } from "./CBridgeFacet.sol";
6 import { ILiFi } from "../Interfaces/ILiFi.sol";
7 import { ERC20, SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
8 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
9 import { LibDiamond } from "../Libraries/LibDiamond.sol";
10 import { ContractCallNotAllowed, ExternalCallFailed } from "../Errors/GenericErrors.sol";
11 import { LibUtil } from "../Libraries/LibUtil.sol";
12 import { TransferrableOwnership } from "../Helpers/TransferrableOwnership.sol";
13 
14 /// @title CBridge Facet Packed
15 /// @author LI.FI (https://li.fi)
16 /// @notice Provides functionality for bridging through CBridge
17 /// @custom:version 1.0.3
18 contract CBridgeFacetPacked is ILiFi, TransferrableOwnership {
19     using SafeTransferLib for ERC20;
20 
21     /// Storage ///
22 
23     /// @notice The contract address of the cbridge on the source chain.
24     ICBridge private immutable cBridge;
25 
26     /// Events ///
27 
28     event LiFiCBridgeTransfer(bytes8 _transactionId);
29 
30     event CBridgeRefund(
31         address indexed _assetAddress,
32         address indexed _to,
33         uint256 amount
34     );
35 
36     /// Constructor ///
37 
38     /// @notice Initialize the contract.
39     /// @param _cBridge The contract address of the cbridge on the source chain.
40     constructor(
41         ICBridge _cBridge,
42         address _owner
43     ) TransferrableOwnership(_owner) {
44         cBridge = _cBridge;
45     }
46 
47     /// External Methods ///
48 
49     /// @dev Only meant to be called outside of the context of the diamond
50     /// @notice Sets approval for the CBridge Router to spend the specified token
51     /// @param tokensToApprove The tokens to approve to the CBridge Router
52     function setApprovalForBridge(
53         address[] calldata tokensToApprove
54     ) external onlyOwner {
55         for (uint256 i; i < tokensToApprove.length; i++) {
56             // Give CBridge approval to bridge tokens
57             LibAsset.maxApproveERC20(
58                 IERC20(tokensToApprove[i]),
59                 address(cBridge),
60                 type(uint256).max
61             );
62         }
63     }
64 
65     // This is needed to receive native asset if a refund asset is a native asset
66     receive() external payable {}
67 
68     /// @notice Triggers a cBridge refund with calldata produced by cBridge API
69     /// @param _callTo The address to execute the calldata on
70     /// @param _callData The data to execute
71     /// @param _assetAddress Asset to be withdrawn
72     /// @param _to Address to withdraw to
73     /// @param _amount Amount of asset to withdraw
74     function triggerRefund(
75         address payable _callTo,
76         bytes calldata _callData,
77         address _assetAddress,
78         address _to,
79         uint256 _amount
80     ) external onlyOwner {
81         // make sure that callTo address is either of the cBridge addresses
82         if (address(cBridge) != _callTo) {
83             revert ContractCallNotAllowed();
84         }
85 
86         // call contract
87         bool success;
88         (success, ) = _callTo.call(_callData);
89         if (!success) {
90             revert ExternalCallFailed();
91         }
92 
93         // forward funds to _to address and emit event
94         address sendTo = (LibUtil.isZeroAddress(_to)) ? msg.sender : _to;
95         LibAsset.transferAsset(_assetAddress, payable(sendTo), _amount);
96         emit CBridgeRefund(_assetAddress, sendTo, _amount);
97     }
98 
99     /// @notice Bridges Native tokens via cBridge (packed)
100     /// No params, all data will be extracted from manually encoded callData
101     function startBridgeTokensViaCBridgeNativePacked() external payable {
102         cBridge.sendNative{ value: msg.value }(
103             address(bytes20(msg.data[12:32])), // receiver
104             msg.value, // amount
105             uint64(uint32(bytes4(msg.data[32:36]))), // destinationChainId
106             uint64(uint32(bytes4(msg.data[36:40]))), // nonce
107             uint32(bytes4(msg.data[40:44])) // maxSlippage
108         );
109 
110         emit LiFiCBridgeTransfer(bytes8(msg.data[4:12])); // transactionId
111     }
112 
113     /// @notice Bridges native tokens via cBridge
114     /// @param transactionId Custom transaction ID for tracking
115     /// @param receiver Receiving wallet address
116     /// @param destinationChainId Receiving chain
117     /// @param nonce A number input to guarantee uniqueness of transferId.
118     /// @param maxSlippage Destination swap minimal accepted amount
119     function startBridgeTokensViaCBridgeNativeMin(
120         bytes32 transactionId,
121         address receiver,
122         uint64 destinationChainId,
123         uint64 nonce,
124         uint32 maxSlippage
125     ) external payable {
126         cBridge.sendNative{ value: msg.value }(
127             receiver,
128             msg.value,
129             destinationChainId,
130             nonce,
131             maxSlippage
132         );
133 
134         emit LiFiCBridgeTransfer(bytes8(transactionId));
135     }
136 
137     /// @notice Bridges ERC20 tokens via cBridge
138     /// No params, all data will be extracted from manually encoded callData
139     function startBridgeTokensViaCBridgeERC20Packed() external {
140         address sendingAssetId = address(bytes20(msg.data[36:56]));
141         uint256 amount = uint256(uint128(bytes16(msg.data[56:72])));
142 
143         // Deposit assets
144         ERC20(sendingAssetId).safeTransferFrom(
145             msg.sender,
146             address(this),
147             amount
148         );
149 
150         // Bridge assets
151         // solhint-disable-next-line check-send-result
152         cBridge.send(
153             address(bytes20(msg.data[12:32])), // receiver
154             sendingAssetId, // sendingAssetId
155             amount, // amount
156             uint64(uint32(bytes4(msg.data[32:36]))), // destinationChainId
157             uint64(uint32(bytes4(msg.data[72:76]))), // nonce
158             uint32(bytes4(msg.data[76:80])) // maxSlippage
159         );
160 
161         emit LiFiCBridgeTransfer(bytes8(msg.data[4:12]));
162     }
163 
164     /// @notice Bridges ERC20 tokens via cBridge
165     /// @param transactionId Custom transaction ID for tracking
166     /// @param receiver Receiving wallet address
167     /// @param destinationChainId Receiving chain
168     /// @param sendingAssetId Address of the source asset to bridge
169     /// @param amount Amount of the source asset to bridge
170     /// @param nonce A number input to guarantee uniqueness of transferId
171     /// @param maxSlippage Destination swap minimal accepted amount
172     function startBridgeTokensViaCBridgeERC20Min(
173         bytes32 transactionId,
174         address receiver,
175         uint64 destinationChainId,
176         address sendingAssetId,
177         uint256 amount,
178         uint64 nonce,
179         uint32 maxSlippage
180     ) external {
181         // Deposit assets
182         ERC20(sendingAssetId).safeTransferFrom(
183             msg.sender,
184             address(this),
185             amount
186         );
187 
188         // Bridge assets
189         // solhint-disable-next-line check-send-result
190         cBridge.send(
191             receiver,
192             sendingAssetId,
193             amount,
194             destinationChainId,
195             nonce,
196             maxSlippage
197         );
198 
199         emit LiFiCBridgeTransfer(bytes8(transactionId));
200     }
201 
202     /// Encoder/Decoders ///
203 
204     /// @notice Encodes calldata for startBridgeTokensViaCBridgeNativePacked
205     /// @param transactionId Custom transaction ID for tracking
206     /// @param receiver Receiving wallet address
207     /// @param destinationChainId Receiving chain
208     /// @param nonce A number input to guarantee uniqueness of transferId.
209     /// @param maxSlippage Destination swap minimal accepted amount
210     function encode_startBridgeTokensViaCBridgeNativePacked(
211         bytes32 transactionId,
212         address receiver,
213         uint64 destinationChainId,
214         uint64 nonce,
215         uint32 maxSlippage
216     ) external pure returns (bytes memory) {
217         require(
218             destinationChainId <= type(uint32).max,
219             "destinationChainId value passed too big to fit in uint32"
220         );
221         require(
222             nonce <= type(uint32).max,
223             "nonce value passed too big to fit in uint32"
224         );
225 
226         return
227             bytes.concat(
228                 CBridgeFacetPacked
229                     .startBridgeTokensViaCBridgeNativePacked
230                     .selector,
231                 bytes8(transactionId),
232                 bytes20(receiver),
233                 bytes4(uint32(destinationChainId)),
234                 bytes4(uint32(nonce)),
235                 bytes4(maxSlippage)
236             );
237     }
238 
239     /// @notice Decodes calldata for startBridgeTokensViaCBridgeNativePacked
240     /// @param _data the calldata to decode
241     function decode_startBridgeTokensViaCBridgeNativePacked(
242         bytes calldata _data
243     )
244         external
245         pure
246         returns (BridgeData memory, CBridgeFacet.CBridgeData memory)
247     {
248         require(
249             _data.length >= 44,
250             "data passed in is not the correct length"
251         );
252 
253         BridgeData memory bridgeData;
254         CBridgeFacet.CBridgeData memory cBridgeData;
255 
256         bridgeData.transactionId = bytes32(bytes8(_data[4:12]));
257         bridgeData.receiver = address(bytes20(_data[12:32]));
258         bridgeData.destinationChainId = uint64(uint32(bytes4(_data[32:36])));
259         cBridgeData.nonce = uint64(uint32(bytes4(_data[36:40])));
260         cBridgeData.maxSlippage = uint32(bytes4(_data[40:44]));
261 
262         return (bridgeData, cBridgeData);
263     }
264 
265     /// @notice Encodes calldata for startBridgeTokensViaCBridgeERC20Packed
266     /// @param transactionId Custom transaction ID for tracking
267     /// @param receiver Receiving wallet address
268     /// @param destinationChainId Receiving chain
269     /// @param sendingAssetId Address of the source asset to bridge
270     /// @param minAmount Amount of the source asset to bridge
271     /// @param nonce A number input to guarantee uniqueness of transferId
272     /// @param maxSlippage Destination swap minimal accepted amount
273     function encode_startBridgeTokensViaCBridgeERC20Packed(
274         bytes32 transactionId,
275         address receiver,
276         uint64 destinationChainId,
277         address sendingAssetId,
278         uint256 minAmount,
279         uint64 nonce,
280         uint32 maxSlippage
281     ) external pure returns (bytes memory) {
282         require(
283             destinationChainId <= type(uint32).max,
284             "destinationChainId value passed too big to fit in uint32"
285         );
286         require(
287             minAmount <= type(uint128).max,
288             "amount value passed too big to fit in uint128"
289         );
290         require(
291             nonce <= type(uint32).max,
292             "nonce value passed too big to fit in uint32"
293         );
294 
295         return
296             bytes.concat(
297                 CBridgeFacetPacked
298                     .startBridgeTokensViaCBridgeERC20Packed
299                     .selector,
300                 bytes8(transactionId),
301                 bytes20(receiver),
302                 bytes4(uint32(destinationChainId)),
303                 bytes20(sendingAssetId),
304                 bytes16(uint128(minAmount)),
305                 bytes4(uint32(nonce)),
306                 bytes4(maxSlippage)
307             );
308     }
309 
310     function decode_startBridgeTokensViaCBridgeERC20Packed(
311         bytes calldata _data
312     )
313         external
314         pure
315         returns (BridgeData memory, CBridgeFacet.CBridgeData memory)
316     {
317         require(_data.length >= 80, "data passed is not the correct length");
318 
319         BridgeData memory bridgeData;
320         CBridgeFacet.CBridgeData memory cBridgeData;
321 
322         bridgeData.transactionId = bytes32(bytes8(_data[4:12]));
323         bridgeData.receiver = address(bytes20(_data[12:32]));
324         bridgeData.destinationChainId = uint64(uint32(bytes4(_data[32:36])));
325         bridgeData.sendingAssetId = address(bytes20(_data[36:56]));
326         bridgeData.minAmount = uint256(uint128(bytes16(_data[56:72])));
327         cBridgeData.nonce = uint64(uint32(bytes4(_data[72:76])));
328         cBridgeData.maxSlippage = uint32(bytes4(_data[76:80]));
329 
330         return (bridgeData, cBridgeData);
331     }
332 }
