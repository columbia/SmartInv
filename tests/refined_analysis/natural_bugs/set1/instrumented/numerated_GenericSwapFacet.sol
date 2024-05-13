1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { LibAsset } from "../Libraries/LibAsset.sol";
6 import { LibSwap } from "../Libraries/LibSwap.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 import { LibUtil } from "../Libraries/LibUtil.sol";
11 import { ContractCallNotAllowed, CumulativeSlippageTooHigh, NativeAssetTransferFailed } from "../Errors/GenericErrors.sol";
12 import { ERC20, SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
13 import { LibAllowList } from "../Libraries/LibAllowList.sol";
14 
15 /// @title GenericSwapFacet
16 /// @author LI.FI (https://li.fi)
17 /// @notice Provides functionality for swapping through any APPROVED DEX
18 /// @dev Can only execute calldata for APPROVED function selectors
19 /// @custom:version 2.0.0
20 contract GenericSwapFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
21     // using SafeERC20 for ERC20;
22     using SafeTransferLib for ERC20;
23 
24     /// External Methods ///
25 
26     /// @notice Performs a single swap from an ERC20 token to another ERC20 token
27     /// @param _transactionId the transaction id associated with the operation
28     /// @param _integrator the name of the integrator
29     /// @param _referrer the address of the referrer
30     /// @param _receiver the address to receive the swapped tokens into (also excess tokens)
31     /// @param _minAmountOut the minimum amount of the final asset to receive
32     /// @param _swapData an object containing swap related data to perform swaps before bridging
33     function swapTokensSingleERC20ToERC20(
34         bytes32 _transactionId,
35         string calldata _integrator,
36         string calldata _referrer,
37         address payable _receiver,
38         uint256 _minAmountOut,
39         LibSwap.SwapData calldata _swapData
40     ) external payable {
41         _depositAndSwapERC20(_swapData);
42 
43         address receivingAssetId = _swapData.receivingAssetId;
44         address sendingAssetId = _swapData.sendingAssetId;
45 
46         // get contract's balance (which will be sent in full to user)
47         uint256 amountReceived = ERC20(receivingAssetId).balanceOf(
48             address(this)
49         );
50 
51         // ensure that minAmountOut was received
52         if (amountReceived < _minAmountOut)
53             revert CumulativeSlippageTooHigh(_minAmountOut, amountReceived);
54 
55         // transfer funds to receiver
56         ERC20(receivingAssetId).safeTransfer(_receiver, amountReceived);
57 
58         // emit events (both required for tracking)
59         uint256 fromAmount = _swapData.fromAmount;
60         emit LibSwap.AssetSwapped(
61             _transactionId,
62             _swapData.callTo,
63             sendingAssetId,
64             receivingAssetId,
65             fromAmount,
66             amountReceived,
67             block.timestamp
68         );
69 
70         emit LiFiGenericSwapCompleted(
71             _transactionId,
72             _integrator,
73             _referrer,
74             _receiver,
75             sendingAssetId,
76             receivingAssetId,
77             fromAmount,
78             amountReceived
79         );
80     }
81 
82     /// @notice Performs a single swap from an ERC20 token to the network's native token
83     /// @param _transactionId the transaction id associated with the operation
84     /// @param _integrator the name of the integrator
85     /// @param _referrer the address of the referrer
86     /// @param _receiver the address to receive the swapped tokens into (also excess tokens)
87     /// @param _minAmountOut the minimum amount of the final asset to receive
88     /// @param _swapData an object containing swap related data to perform swaps before bridging
89     function swapTokensSingleERC20ToNative(
90         bytes32 _transactionId,
91         string calldata _integrator,
92         string calldata _referrer,
93         address payable _receiver,
94         uint256 _minAmountOut,
95         LibSwap.SwapData calldata _swapData
96     ) external payable {
97         _depositAndSwapERC20(_swapData);
98 
99         // get contract's balance (which will be sent in full to user)
100         uint256 amountReceived = address(this).balance;
101 
102         // ensure that minAmountOut was received
103         if (amountReceived < _minAmountOut)
104             revert CumulativeSlippageTooHigh(_minAmountOut, amountReceived);
105 
106         // transfer funds to receiver
107         // solhint-disable-next-line avoid-low-level-calls
108         (bool success, ) = _receiver.call{ value: amountReceived }("");
109         if (!success) revert NativeAssetTransferFailed();
110 
111         // emit events (both required for tracking)
112         address receivingAssetId = _swapData.receivingAssetId;
113         address sendingAssetId = _swapData.sendingAssetId;
114         uint256 fromAmount = _swapData.fromAmount;
115         emit LibSwap.AssetSwapped(
116             _transactionId,
117             _swapData.callTo,
118             sendingAssetId,
119             receivingAssetId,
120             fromAmount,
121             amountReceived,
122             block.timestamp
123         );
124 
125         emit LiFiGenericSwapCompleted(
126             _transactionId,
127             _integrator,
128             _referrer,
129             _receiver,
130             sendingAssetId,
131             receivingAssetId,
132             fromAmount,
133             amountReceived
134         );
135     }
136 
137     /// @notice Performs a single swap from the network's native token to ERC20 token
138     /// @param _transactionId the transaction id associated with the operation
139     /// @param _integrator the name of the integrator
140     /// @param _referrer the address of the referrer
141     /// @param _receiver the address to receive the swapped tokens into (also excess tokens)
142     /// @param _minAmountOut the minimum amount of the final asset to receive
143     /// @param _swapData an object containing swap related data to perform swaps before bridging
144     function swapTokensSingleNativeToERC20(
145         bytes32 _transactionId,
146         string calldata _integrator,
147         string calldata _referrer,
148         address payable _receiver,
149         uint256 _minAmountOut,
150         LibSwap.SwapData calldata _swapData
151     ) external payable {
152         address callTo = _swapData.callTo;
153         // ensure that contract (callTo) and function selector are whitelisted
154         if (
155             !(LibAllowList.contractIsAllowed(callTo) &&
156                 LibAllowList.selectorIsAllowed(bytes4(_swapData.callData[:4])))
157         ) revert ContractCallNotAllowed();
158 
159         // execute swap
160         // solhint-disable-next-line avoid-low-level-calls
161         (bool success, bytes memory res) = callTo.call{ value: msg.value }(
162             _swapData.callData
163         );
164         if (!success) {
165             string memory reason = LibUtil.getRevertMsg(res);
166             revert(reason);
167         }
168 
169         // get contract's balance (which will be sent in full to user)
170         address receivingAssetId = _swapData.receivingAssetId;
171         uint256 amountReceived = ERC20(receivingAssetId).balanceOf(
172             address(this)
173         );
174 
175         // ensure that minAmountOut was received
176         if (amountReceived < _minAmountOut)
177             revert CumulativeSlippageTooHigh(_minAmountOut, amountReceived);
178 
179         // transfer funds to receiver
180         ERC20(receivingAssetId).safeTransfer(_receiver, amountReceived);
181 
182         // emit events (both required for tracking)
183         address sendingAssetId = _swapData.sendingAssetId;
184         uint256 fromAmount = _swapData.fromAmount;
185         emit LibSwap.AssetSwapped(
186             _transactionId,
187             callTo,
188             sendingAssetId,
189             receivingAssetId,
190             fromAmount,
191             amountReceived,
192             block.timestamp
193         );
194 
195         emit LiFiGenericSwapCompleted(
196             _transactionId,
197             _integrator,
198             _referrer,
199             _receiver,
200             sendingAssetId,
201             receivingAssetId,
202             fromAmount,
203             amountReceived
204         );
205     }
206 
207     /// @notice Performs multiple swaps (of any kind) in one transaction
208     /// @param _transactionId the transaction id associated with the operation
209     /// @param _integrator the name of the integrator
210     /// @param _referrer the address of the referrer
211     /// @param _receiver the address to receive the swapped tokens into (also excess tokens)
212     /// @param _minAmountOut the minimum amount of the final asset to receive
213     /// @param _swapData an object containing swap related data to perform swaps before bridging
214     function swapTokensGeneric(
215         bytes32 _transactionId,
216         string calldata _integrator,
217         string calldata _referrer,
218         address payable _receiver,
219         uint256 _minAmountOut,
220         LibSwap.SwapData[] calldata _swapData
221     ) external payable nonReentrant refundExcessNative(_receiver) {
222         uint256 postSwapBalance = _depositAndSwap(
223             _transactionId,
224             _minAmountOut,
225             _swapData,
226             _receiver
227         );
228         address receivingAssetId = _swapData[_swapData.length - 1]
229             .receivingAssetId;
230         LibAsset.transferAsset(receivingAssetId, _receiver, postSwapBalance);
231 
232         emit LiFiGenericSwapCompleted(
233             _transactionId,
234             _integrator,
235             _referrer,
236             _receiver,
237             _swapData[0].sendingAssetId,
238             receivingAssetId,
239             _swapData[0].fromAmount,
240             postSwapBalance
241         );
242     }
243 
244     /// Internal helper methods ///
245 
246     function _depositAndSwapERC20(
247         LibSwap.SwapData calldata _swapData
248     ) private {
249         ERC20 sendingAsset = ERC20(_swapData.sendingAssetId);
250         uint256 fromAmount = _swapData.fromAmount;
251         // deposit funds
252         sendingAsset.safeTransferFrom(msg.sender, address(this), fromAmount);
253 
254         // ensure that contract (callTo) and function selector are whitelisted
255         address callTo = _swapData.callTo;
256         address approveTo = _swapData.approveTo;
257         if (
258             !(LibAllowList.contractIsAllowed(callTo) &&
259                 LibAllowList.selectorIsAllowed(bytes4(_swapData.callData[:4])))
260         ) revert ContractCallNotAllowed();
261 
262         // ensure that approveTo address is also whitelisted if it differs from callTo
263         if (approveTo != callTo && !LibAllowList.contractIsAllowed(approveTo))
264             revert ContractCallNotAllowed();
265 
266         // check if the current allowance is sufficient
267         uint256 currentAllowance = sendingAsset.allowance(
268             address(this),
269             approveTo
270         );
271 
272         // check if existing allowance is sufficient
273         if (currentAllowance < fromAmount) {
274             // check if is non-zero, set to 0 if not
275             if (currentAllowance != 0) sendingAsset.safeApprove(approveTo, 0);
276             // set allowance to uint max to avoid future approvals
277             sendingAsset.safeApprove(approveTo, type(uint256).max);
278         }
279 
280         // execute swap
281         // solhint-disable-next-line avoid-low-level-calls
282         (bool success, bytes memory res) = callTo.call(_swapData.callData);
283         if (!success) {
284             string memory reason = LibUtil.getRevertMsg(res);
285             revert(reason);
286         }
287     }
288 }
