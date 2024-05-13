1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { LibSwap } from "../Libraries/LibSwap.sol";
6 import { LibAsset } from "../Libraries/LibAsset.sol";
7 import { LibAllowList } from "../Libraries/LibAllowList.sol";
8 import { ContractCallNotAllowed, NoSwapDataProvided, CumulativeSlippageTooHigh } from "../Errors/GenericErrors.sol";
9 
10 /// @title Swapper
11 /// @author LI.FI (https://li.fi)
12 /// @notice Abstract contract to provide swap functionality
13 contract SwapperV2 is ILiFi {
14     /// Types ///
15 
16     /// @dev only used to get around "Stack Too Deep" errors
17     struct ReserveData {
18         bytes32 transactionId;
19         address payable leftoverReceiver;
20         uint256 nativeReserve;
21     }
22 
23     /// Modifiers ///
24 
25     /// @dev Sends any leftover balances back to the user
26     /// @notice Sends any leftover balances to the user
27     /// @param _swaps Swap data array
28     /// @param _leftoverReceiver Address to send leftover tokens to
29     /// @param _initialBalances Array of initial token balances
30     modifier noLeftovers(
31         LibSwap.SwapData[] calldata _swaps,
32         address payable _leftoverReceiver,
33         uint256[] memory _initialBalances
34     ) {
35         uint256 numSwaps = _swaps.length;
36         if (numSwaps != 1) {
37             address finalAsset = _swaps[numSwaps - 1].receivingAssetId;
38             uint256 curBalance;
39 
40             _;
41 
42             for (uint256 i = 0; i < numSwaps - 1; ) {
43                 address curAsset = _swaps[i].receivingAssetId;
44                 // Handle multi-to-one swaps
45                 if (curAsset != finalAsset) {
46                     curBalance =
47                         LibAsset.getOwnBalance(curAsset) -
48                         _initialBalances[i];
49                     if (curBalance > 0) {
50                         LibAsset.transferAsset(
51                             curAsset,
52                             _leftoverReceiver,
53                             curBalance
54                         );
55                     }
56                 }
57                 unchecked {
58                     ++i;
59                 }
60             }
61         } else {
62             _;
63         }
64     }
65 
66     /// @dev Sends any leftover balances back to the user reserving native tokens
67     /// @notice Sends any leftover balances to the user
68     /// @param _swaps Swap data array
69     /// @param _leftoverReceiver Address to send leftover tokens to
70     /// @param _initialBalances Array of initial token balances
71     modifier noLeftoversReserve(
72         LibSwap.SwapData[] calldata _swaps,
73         address payable _leftoverReceiver,
74         uint256[] memory _initialBalances,
75         uint256 _nativeReserve
76     ) {
77         uint256 numSwaps = _swaps.length;
78         if (numSwaps != 1) {
79             address finalAsset = _swaps[numSwaps - 1].receivingAssetId;
80             uint256 curBalance;
81 
82             _;
83 
84             for (uint256 i = 0; i < numSwaps - 1; ) {
85                 address curAsset = _swaps[i].receivingAssetId;
86                 // Handle multi-to-one swaps
87                 if (curAsset != finalAsset) {
88                     curBalance =
89                         LibAsset.getOwnBalance(curAsset) -
90                         _initialBalances[i];
91                     uint256 reserve = LibAsset.isNativeAsset(curAsset)
92                         ? _nativeReserve
93                         : 0;
94                     if (curBalance > 0) {
95                         LibAsset.transferAsset(
96                             curAsset,
97                             _leftoverReceiver,
98                             curBalance - reserve
99                         );
100                     }
101                 }
102                 unchecked {
103                     ++i;
104                 }
105             }
106         } else {
107             _;
108         }
109     }
110 
111     /// @dev Refunds any excess native asset sent to the contract after the main function
112     /// @notice Refunds any excess native asset sent to the contract after the main function
113     /// @param _refundReceiver Address to send refunds to
114     modifier refundExcessNative(address payable _refundReceiver) {
115         uint256 initialBalance = address(this).balance - msg.value;
116         _;
117         uint256 finalBalance = address(this).balance;
118 
119         if (finalBalance > initialBalance) {
120             LibAsset.transferAsset(
121                 LibAsset.NATIVE_ASSETID,
122                 _refundReceiver,
123                 finalBalance - initialBalance
124             );
125         }
126     }
127 
128     /// Internal Methods ///
129 
130     /// @dev Deposits value, executes swaps, and performs minimum amount check
131     /// @param _transactionId the transaction id associated with the operation
132     /// @param _minAmount the minimum amount of the final asset to receive
133     /// @param _swaps Array of data used to execute swaps
134     /// @param _leftoverReceiver The address to send leftover funds to
135     /// @return uint256 result of the swap
136     function _depositAndSwap(
137         bytes32 _transactionId,
138         uint256 _minAmount,
139         LibSwap.SwapData[] calldata _swaps,
140         address payable _leftoverReceiver
141     ) internal returns (uint256) {
142         uint256 numSwaps = _swaps.length;
143 
144         if (numSwaps == 0) {
145             revert NoSwapDataProvided();
146         }
147 
148         address finalTokenId = _swaps[numSwaps - 1].receivingAssetId;
149         uint256 initialBalance = LibAsset.getOwnBalance(finalTokenId);
150 
151         if (LibAsset.isNativeAsset(finalTokenId)) {
152             initialBalance -= msg.value;
153         }
154 
155         uint256[] memory initialBalances = _fetchBalances(_swaps);
156 
157         LibAsset.depositAssets(_swaps);
158         _executeSwaps(
159             _transactionId,
160             _swaps,
161             _leftoverReceiver,
162             initialBalances
163         );
164 
165         uint256 newBalance = LibAsset.getOwnBalance(finalTokenId) -
166             initialBalance;
167 
168         if (newBalance < _minAmount) {
169             revert CumulativeSlippageTooHigh(_minAmount, newBalance);
170         }
171 
172         return newBalance;
173     }
174 
175     /// @dev Deposits value, executes swaps, and performs minimum amount check and reserves native token for fees
176     /// @param _transactionId the transaction id associated with the operation
177     /// @param _minAmount the minimum amount of the final asset to receive
178     /// @param _swaps Array of data used to execute swaps
179     /// @param _leftoverReceiver The address to send leftover funds to
180     /// @param _nativeReserve Amount of native token to prevent from being swept back to the caller
181     function _depositAndSwap(
182         bytes32 _transactionId,
183         uint256 _minAmount,
184         LibSwap.SwapData[] calldata _swaps,
185         address payable _leftoverReceiver,
186         uint256 _nativeReserve
187     ) internal returns (uint256) {
188         uint256 numSwaps = _swaps.length;
189 
190         if (numSwaps == 0) {
191             revert NoSwapDataProvided();
192         }
193 
194         address finalTokenId = _swaps[numSwaps - 1].receivingAssetId;
195         uint256 initialBalance = LibAsset.getOwnBalance(finalTokenId);
196 
197         if (LibAsset.isNativeAsset(finalTokenId)) {
198             initialBalance -= msg.value;
199         }
200 
201         uint256[] memory initialBalances = _fetchBalances(_swaps);
202 
203         LibAsset.depositAssets(_swaps);
204         ReserveData memory rd = ReserveData(
205             _transactionId,
206             _leftoverReceiver,
207             _nativeReserve
208         );
209         _executeSwaps(rd, _swaps, initialBalances);
210 
211         uint256 newBalance = LibAsset.getOwnBalance(finalTokenId) -
212             initialBalance;
213 
214         if (LibAsset.isNativeAsset(finalTokenId)) {
215             newBalance -= _nativeReserve;
216         }
217 
218         if (newBalance < _minAmount) {
219             revert CumulativeSlippageTooHigh(_minAmount, newBalance);
220         }
221 
222         return newBalance;
223     }
224 
225     /// Private Methods ///
226 
227     /// @dev Executes swaps and checks that DEXs used are in the allowList
228     /// @param _transactionId the transaction id associated with the operation
229     /// @param _swaps Array of data used to execute swaps
230     /// @param _leftoverReceiver Address to send leftover tokens to
231     /// @param _initialBalances Array of initial balances
232     function _executeSwaps(
233         bytes32 _transactionId,
234         LibSwap.SwapData[] calldata _swaps,
235         address payable _leftoverReceiver,
236         uint256[] memory _initialBalances
237     ) internal noLeftovers(_swaps, _leftoverReceiver, _initialBalances) {
238         uint256 numSwaps = _swaps.length;
239         for (uint256 i = 0; i < numSwaps; ) {
240             LibSwap.SwapData calldata currentSwap = _swaps[i];
241 
242             if (
243                 !((LibAsset.isNativeAsset(currentSwap.sendingAssetId) ||
244                     LibAllowList.contractIsAllowed(currentSwap.approveTo)) &&
245                     LibAllowList.contractIsAllowed(currentSwap.callTo) &&
246                     LibAllowList.selectorIsAllowed(
247                         bytes4(currentSwap.callData[:4])
248                     ))
249             ) revert ContractCallNotAllowed();
250 
251             LibSwap.swap(_transactionId, currentSwap);
252 
253             unchecked {
254                 ++i;
255             }
256         }
257     }
258 
259     /// @dev Executes swaps and checks that DEXs used are in the allowList
260     /// @param _reserveData Data passed used to reserve native tokens
261     /// @param _swaps Array of data used to execute swaps
262     function _executeSwaps(
263         ReserveData memory _reserveData,
264         LibSwap.SwapData[] calldata _swaps,
265         uint256[] memory _initialBalances
266     )
267         internal
268         noLeftoversReserve(
269             _swaps,
270             _reserveData.leftoverReceiver,
271             _initialBalances,
272             _reserveData.nativeReserve
273         )
274     {
275         uint256 numSwaps = _swaps.length;
276         for (uint256 i = 0; i < numSwaps; ) {
277             LibSwap.SwapData calldata currentSwap = _swaps[i];
278 
279             if (
280                 !((LibAsset.isNativeAsset(currentSwap.sendingAssetId) ||
281                     LibAllowList.contractIsAllowed(currentSwap.approveTo)) &&
282                     LibAllowList.contractIsAllowed(currentSwap.callTo) &&
283                     LibAllowList.selectorIsAllowed(
284                         bytes4(currentSwap.callData[:4])
285                     ))
286             ) revert ContractCallNotAllowed();
287 
288             LibSwap.swap(_reserveData.transactionId, currentSwap);
289 
290             unchecked {
291                 ++i;
292             }
293         }
294     }
295 
296     /// @dev Fetches balances of tokens to be swapped before swapping.
297     /// @param _swaps Array of data used to execute swaps
298     /// @return uint256[] Array of token balances.
299     function _fetchBalances(
300         LibSwap.SwapData[] calldata _swaps
301     ) private view returns (uint256[] memory) {
302         uint256 numSwaps = _swaps.length;
303         uint256[] memory balances = new uint256[](numSwaps);
304         address asset;
305         for (uint256 i = 0; i < numSwaps; ) {
306             asset = _swaps[i].receivingAssetId;
307             balances[i] = LibAsset.getOwnBalance(asset);
308 
309             if (LibAsset.isNativeAsset(asset)) {
310                 balances[i] -= msg.value;
311             }
312 
313             unchecked {
314                 ++i;
315             }
316         }
317 
318         return balances;
319     }
320 }
