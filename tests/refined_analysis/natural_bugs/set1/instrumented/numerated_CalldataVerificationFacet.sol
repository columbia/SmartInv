1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { LibSwap } from "../Libraries/LibSwap.sol";
6 import { AmarokFacet } from "./AmarokFacet.sol";
7 import { StargateFacet } from "./StargateFacet.sol";
8 import { CelerIMFacetBase, CelerIM } from "lifi/Helpers/CelerIMFacetBase.sol";
9 import { StandardizedCallFacet } from "lifi/Facets/StandardizedCallFacet.sol";
10 import { LibBytes } from "../Libraries/LibBytes.sol";
11 
12 /// @title Calldata Verification Facet
13 /// @author LI.FI (https://li.fi)
14 /// @notice Provides functionality for verifying calldata
15 /// @custom:version 1.1.1
16 contract CalldataVerificationFacet {
17     using LibBytes for bytes;
18 
19     /// @notice Extracts the bridge data from the calldata
20     /// @param data The calldata to extract the bridge data from
21     /// @return bridgeData The bridge data extracted from the calldata
22     function extractBridgeData(
23         bytes calldata data
24     ) external pure returns (ILiFi.BridgeData memory bridgeData) {
25         bridgeData = _extractBridgeData(data);
26     }
27 
28     /// @notice Extracts the swap data from the calldata
29     /// @param data The calldata to extract the swap data from
30     /// @return swapData The swap data extracted from the calldata
31     function extractSwapData(
32         bytes calldata data
33     ) external pure returns (LibSwap.SwapData[] memory swapData) {
34         swapData = _extractSwapData(data);
35     }
36 
37     /// @notice Extracts the bridge data and swap data from the calldata
38     /// @param data The calldata to extract the bridge data and swap data from
39     /// @return bridgeData The bridge data extracted from the calldata
40     /// @return swapData The swap data extracted from the calldata
41     function extractData(
42         bytes calldata data
43     )
44         external
45         pure
46         returns (
47             ILiFi.BridgeData memory bridgeData,
48             LibSwap.SwapData[] memory swapData
49         )
50     {
51         bridgeData = _extractBridgeData(data);
52         if (bridgeData.hasSourceSwaps) {
53             swapData = _extractSwapData(data);
54         }
55     }
56 
57     /// @notice Extracts the main parameters from the calldata
58     /// @param data The calldata to extract the main parameters from
59     /// @return bridge The bridge extracted from the calldata
60     /// @return sendingAssetId The sending asset id extracted from the calldata
61     /// @return receiver The receiver extracted from the calldata
62     /// @return amount The min amountfrom the calldata
63     /// @return destinationChainId The destination chain id extracted from the calldata
64     /// @return hasSourceSwaps Whether the calldata has source swaps
65     /// @return hasDestinationCall Whether the calldata has a destination call
66     function extractMainParameters(
67         bytes calldata data
68     )
69         public
70         pure
71         returns (
72             string memory bridge,
73             address sendingAssetId,
74             address receiver,
75             uint256 amount,
76             uint256 destinationChainId,
77             bool hasSourceSwaps,
78             bool hasDestinationCall
79         )
80     {
81         ILiFi.BridgeData memory bridgeData = _extractBridgeData(data);
82 
83         if (bridgeData.hasSourceSwaps) {
84             LibSwap.SwapData[] memory swapData = _extractSwapData(data);
85             sendingAssetId = swapData[0].sendingAssetId;
86             amount = swapData[0].fromAmount;
87         } else {
88             sendingAssetId = bridgeData.sendingAssetId;
89             amount = bridgeData.minAmount;
90         }
91 
92         return (
93             bridgeData.bridge,
94             sendingAssetId,
95             bridgeData.receiver,
96             amount,
97             bridgeData.destinationChainId,
98             bridgeData.hasSourceSwaps,
99             bridgeData.hasDestinationCall
100         );
101     }
102 
103     /// @notice Extracts the generic swap parameters from the calldata
104     /// @param data The calldata to extract the generic swap parameters from
105     /// @return sendingAssetId The sending asset id extracted from the calldata
106     /// @return amount The amount extracted from the calldata
107     /// @return receiver The receiver extracted from the calldata
108     /// @return receivingAssetId The receiving asset id extracted from the calldata
109     /// @return receivingAmount The receiving amount extracted from the calldata
110     function extractGenericSwapParameters(
111         bytes calldata data
112     )
113         public
114         pure
115         returns (
116             address sendingAssetId,
117             uint256 amount,
118             address receiver,
119             address receivingAssetId,
120             uint256 receivingAmount
121         )
122     {
123         LibSwap.SwapData[] memory swapData;
124         bytes memory callData = data;
125 
126         if (
127             bytes4(data[:4]) == StandardizedCallFacet.standardizedCall.selector
128         ) {
129             // standardizedCall
130             callData = abi.decode(data[4:], (bytes));
131         }
132         (, , , receiver, receivingAmount, swapData) = abi.decode(
133             callData.slice(4, callData.length - 4),
134             (bytes32, string, string, address, uint256, LibSwap.SwapData[])
135         );
136 
137         sendingAssetId = swapData[0].sendingAssetId;
138         amount = swapData[0].fromAmount;
139         receivingAssetId = swapData[swapData.length - 1].receivingAssetId;
140         return (
141             sendingAssetId,
142             amount,
143             receiver,
144             receivingAssetId,
145             receivingAmount
146         );
147     }
148 
149     /// @notice Validates the calldata
150     /// @param data The calldata to validate
151     /// @param bridge The bridge to validate or empty string to ignore
152     /// @param sendingAssetId The sending asset id to validate
153     ///        or 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF to ignore
154     /// @param receiver The receiver to validate
155     ///        or 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF to ignore
156     /// @param amount The amount to validate or type(uint256).max to ignore
157     /// @param destinationChainId The destination chain id to validate
158     ///        or type(uint256).max to ignore
159     /// @param hasSourceSwaps Whether the calldata has source swaps
160     /// @param hasDestinationCall Whether the calldata has a destination call
161     /// @return isValid Whether the calldata is validate
162     function validateCalldata(
163         bytes calldata data,
164         string calldata bridge,
165         address sendingAssetId,
166         address receiver,
167         uint256 amount,
168         uint256 destinationChainId,
169         bool hasSourceSwaps,
170         bool hasDestinationCall
171     ) external pure returns (bool isValid) {
172         ILiFi.BridgeData memory bridgeData;
173         (
174             bridgeData.bridge,
175             bridgeData.sendingAssetId,
176             bridgeData.receiver,
177             bridgeData.minAmount,
178             bridgeData.destinationChainId,
179             bridgeData.hasSourceSwaps,
180             bridgeData.hasDestinationCall
181         ) = extractMainParameters(data);
182         return
183             // Check bridge
184             (keccak256(abi.encodePacked(bridge)) ==
185                 keccak256(abi.encodePacked("")) ||
186                 keccak256(abi.encodePacked(bridgeData.bridge)) ==
187                 keccak256(abi.encodePacked(bridge))) &&
188             // Check sendingAssetId
189             (sendingAssetId == 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF ||
190                 bridgeData.sendingAssetId == sendingAssetId) &&
191             // Check receiver
192             (receiver == 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF ||
193                 bridgeData.receiver == receiver) &&
194             // Check amount
195             (amount == type(uint256).max || bridgeData.minAmount == amount) &&
196             // Check destinationChainId
197             (destinationChainId == type(uint256).max ||
198                 bridgeData.destinationChainId == destinationChainId) &&
199             // Check hasSourceSwaps
200             bridgeData.hasSourceSwaps == hasSourceSwaps &&
201             // Check hasDestinationCall
202             bridgeData.hasDestinationCall == hasDestinationCall;
203     }
204 
205     /// @notice Validates the destination calldata
206     /// @param data The calldata to validate
207     /// @param callTo The call to address to validate
208     /// @param dstCalldata The destination calldata to validate
209     /// @return isValid Whether the destination calldata is validate
210     function validateDestinationCalldata(
211         bytes calldata data,
212         bytes calldata callTo,
213         bytes calldata dstCalldata
214     ) external pure returns (bool isValid) {
215         bytes memory callData = data;
216 
217         // Handle standardizedCall
218         if (
219             bytes4(data[:4]) == StandardizedCallFacet.standardizedCall.selector
220         ) {
221             callData = abi.decode(data[4:], (bytes));
222         }
223 
224         bytes4 selector = abi.decode(callData, (bytes4));
225 
226         // Case: Amarok
227         if (selector == AmarokFacet.startBridgeTokensViaAmarok.selector) {
228             (, AmarokFacet.AmarokData memory amarokData) = abi.decode(
229                 callData.slice(4, callData.length - 4),
230                 (ILiFi.BridgeData, AmarokFacet.AmarokData)
231             );
232 
233             return
234                 keccak256(dstCalldata) == keccak256(amarokData.callData) &&
235                 abi.decode(callTo, (address)) == amarokData.callTo;
236         }
237         if (
238             selector == AmarokFacet.swapAndStartBridgeTokensViaAmarok.selector
239         ) {
240             (, , AmarokFacet.AmarokData memory amarokData) = abi.decode(
241                 callData.slice(4, callData.length - 4),
242                 (ILiFi.BridgeData, LibSwap.SwapData[], AmarokFacet.AmarokData)
243             );
244             return
245                 keccak256(dstCalldata) == keccak256(amarokData.callData) &&
246                 abi.decode(callTo, (address)) == amarokData.callTo;
247         }
248 
249         // Case: Stargate
250         if (selector == StargateFacet.startBridgeTokensViaStargate.selector) {
251             (, StargateFacet.StargateData memory stargateData) = abi.decode(
252                 callData.slice(4, callData.length - 4),
253                 (ILiFi.BridgeData, StargateFacet.StargateData)
254             );
255             return
256                 keccak256(dstCalldata) == keccak256(stargateData.callData) &&
257                 keccak256(callTo) == keccak256(stargateData.callTo);
258         }
259         if (
260             selector ==
261             StargateFacet.swapAndStartBridgeTokensViaStargate.selector
262         ) {
263             (, , StargateFacet.StargateData memory stargateData) = abi.decode(
264                 callData.slice(4, callData.length - 4),
265                 (
266                     ILiFi.BridgeData,
267                     LibSwap.SwapData[],
268                     StargateFacet.StargateData
269                 )
270             );
271             return
272                 keccak256(dstCalldata) == keccak256(stargateData.callData) &&
273                 keccak256(callTo) == keccak256(stargateData.callTo);
274         }
275         // Case: Celer
276         if (
277             selector == CelerIMFacetBase.startBridgeTokensViaCelerIM.selector
278         ) {
279             (, CelerIM.CelerIMData memory celerIMData) = abi.decode(
280                 callData.slice(4, callData.length - 4),
281                 (ILiFi.BridgeData, CelerIM.CelerIMData)
282             );
283             return
284                 keccak256(dstCalldata) == keccak256(celerIMData.callData) &&
285                 keccak256(callTo) == keccak256(celerIMData.callTo);
286         }
287         if (
288             selector ==
289             CelerIMFacetBase.swapAndStartBridgeTokensViaCelerIM.selector
290         ) {
291             (, , CelerIM.CelerIMData memory celerIMData) = abi.decode(
292                 callData.slice(4, callData.length - 4),
293                 (ILiFi.BridgeData, LibSwap.SwapData[], CelerIM.CelerIMData)
294             );
295             return
296                 keccak256(dstCalldata) == keccak256(celerIMData.callData) &&
297                 keccak256(callTo) == keccak256(celerIMData.callTo);
298         }
299 
300         // All other cases
301         return false;
302     }
303 
304     /// Internal Methods ///
305 
306     /// @notice Extracts the bridge data from the calldata
307     /// @param data The calldata to extract the bridge data from
308     /// @return bridgeData The bridge data extracted from the calldata
309     function _extractBridgeData(
310         bytes calldata data
311     ) internal pure returns (ILiFi.BridgeData memory bridgeData) {
312         if (
313             bytes4(data[:4]) == StandardizedCallFacet.standardizedCall.selector
314         ) {
315             // StandardizedCall
316             bytes memory unwrappedData = abi.decode(data[4:], (bytes));
317             bridgeData = abi.decode(
318                 unwrappedData.slice(4, unwrappedData.length - 4),
319                 (ILiFi.BridgeData)
320             );
321             return bridgeData;
322         }
323         // normal call
324         bridgeData = abi.decode(data[4:], (ILiFi.BridgeData));
325     }
326 
327     /// @notice Extracts the swap data from the calldata
328     /// @param data The calldata to extract the swap data from
329     /// @return swapData The swap data extracted from the calldata
330     function _extractSwapData(
331         bytes calldata data
332     ) internal pure returns (LibSwap.SwapData[] memory swapData) {
333         if (
334             bytes4(data[:4]) == StandardizedCallFacet.standardizedCall.selector
335         ) {
336             // standardizedCall
337             bytes memory unwrappedData = abi.decode(data[4:], (bytes));
338             (, swapData) = abi.decode(
339                 unwrappedData.slice(4, unwrappedData.length - 4),
340                 (ILiFi.BridgeData, LibSwap.SwapData[])
341             );
342             return swapData;
343         }
344         // normal call
345         (, swapData) = abi.decode(
346             data[4:],
347             (ILiFi.BridgeData, LibSwap.SwapData[])
348         );
349     }
350 }
