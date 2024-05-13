1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { IERC20, SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
6 import { LibSwap } from "../Libraries/LibSwap.sol";
7 import { LibAsset } from "../Libraries/LibAsset.sol";
8 import { ILiFi } from "../Interfaces/ILiFi.sol";
9 import { IExecutor } from "../Interfaces/IExecutor.sol";
10 import { TransferrableOwnership } from "../Helpers/TransferrableOwnership.sol";
11 import { ExternalCallFailed, UnAuthorized } from "../Errors/GenericErrors.sol";
12 
13 /// @title Receiver
14 /// @author LI.FI (https://li.fi)
15 /// @notice Arbitrary execution contract used for cross-chain swaps and message passing
16 /// @custom:version 2.0.2
17 contract Receiver is ILiFi, ReentrancyGuard, TransferrableOwnership {
18     using SafeERC20 for IERC20;
19 
20     /// Storage ///
21     address public sgRouter;
22     IExecutor public executor;
23     uint256 public recoverGas;
24     address public amarokRouter;
25 
26     /// Events ///
27     event StargateRouterSet(address indexed router);
28     event AmarokRouterSet(address indexed router);
29     event ExecutorSet(address indexed executor);
30     event RecoverGasSet(uint256 indexed recoverGas);
31 
32     /// Modifiers ///
33     modifier onlySGRouter() {
34         if (msg.sender != sgRouter) {
35             revert UnAuthorized();
36         }
37         _;
38     }
39     modifier onlyAmarokRouter() {
40         if (msg.sender != amarokRouter) {
41             revert UnAuthorized();
42         }
43         _;
44     }
45 
46     /// Constructor
47     constructor(
48         address _owner,
49         address _sgRouter,
50         address _amarokRouter,
51         address _executor,
52         uint256 _recoverGas
53     ) TransferrableOwnership(_owner) {
54         owner = _owner;
55         sgRouter = _sgRouter;
56         amarokRouter = _amarokRouter;
57         executor = IExecutor(_executor);
58         recoverGas = _recoverGas;
59         emit StargateRouterSet(_sgRouter);
60         emit AmarokRouterSet(_amarokRouter);
61         emit RecoverGasSet(_recoverGas);
62     }
63 
64     /// External Methods ///
65 
66     /// @notice Completes a cross-chain transaction with calldata via Amarok facet on the receiving chain.
67     /// @dev This function is called from Amarok Router.
68     /// @param _transferId The unique ID of this transaction (assigned by Amarok)
69     /// @param _amount the amount of bridged tokens
70     /// @param _asset the address of the bridged token
71     /// @param * (unused) the sender of the transaction
72     /// @param * (unused) the domain ID of the src chain
73     /// @param _callData The data to execute
74     function xReceive(
75         bytes32 _transferId,
76         uint256 _amount,
77         address _asset,
78         address,
79         uint32,
80         bytes memory _callData
81     ) external nonReentrant onlyAmarokRouter {
82         (LibSwap.SwapData[] memory swapData, address receiver) = abi.decode(
83             _callData,
84             (LibSwap.SwapData[], address)
85         );
86 
87         _swapAndCompleteBridgeTokens(
88             _transferId,
89             swapData,
90             _asset,
91             payable(receiver),
92             _amount,
93             false
94         );
95     }
96 
97     /// @notice Completes a cross-chain transaction on the receiving chain.
98     /// @dev This function is called from Stargate Router.
99     /// @param * (unused) The remote chainId sending the tokens
100     /// @param * (unused) The remote Bridge address
101     /// @param * (unused) Nonce
102     /// @param _token The token contract on the local chain
103     /// @param _amountLD The amount of tokens received through bridging
104     /// @param _payload The data to execute
105     function sgReceive(
106         uint16, // _srcChainId unused
107         bytes memory, // _srcAddress unused
108         uint256, // _nonce unused
109         address _token,
110         uint256 _amountLD,
111         bytes memory _payload
112     ) external nonReentrant onlySGRouter {
113         (
114             bytes32 transactionId,
115             LibSwap.SwapData[] memory swapData,
116             ,
117             address receiver
118         ) = abi.decode(
119                 _payload,
120                 (bytes32, LibSwap.SwapData[], address, address)
121             );
122 
123         _swapAndCompleteBridgeTokens(
124             transactionId,
125             swapData,
126             swapData.length > 0 ? swapData[0].sendingAssetId : _token, // If swapping assume sent token is the first token in swapData
127             payable(receiver),
128             _amountLD,
129             true
130         );
131     }
132 
133     /// @notice Performs a swap before completing a cross-chain transaction
134     /// @param _transactionId the transaction id associated with the operation
135     /// @param _swapData array of data needed for swaps
136     /// @param assetId token received from the other chain
137     /// @param receiver address that will receive tokens in the end
138     function swapAndCompleteBridgeTokens(
139         bytes32 _transactionId,
140         LibSwap.SwapData[] memory _swapData,
141         address assetId,
142         address payable receiver
143     ) external payable nonReentrant {
144         if (LibAsset.isNativeAsset(assetId)) {
145             _swapAndCompleteBridgeTokens(
146                 _transactionId,
147                 _swapData,
148                 assetId,
149                 receiver,
150                 msg.value,
151                 false
152             );
153         } else {
154             uint256 allowance = IERC20(assetId).allowance(
155                 msg.sender,
156                 address(this)
157             );
158             LibAsset.depositAsset(assetId, allowance);
159             _swapAndCompleteBridgeTokens(
160                 _transactionId,
161                 _swapData,
162                 assetId,
163                 receiver,
164                 allowance,
165                 false
166             );
167         }
168     }
169 
170     /// @notice Send remaining token to receiver
171     /// @param assetId token received from the other chain
172     /// @param receiver address that will receive tokens in the end
173     /// @param amount amount of token
174     function pullToken(
175         address assetId,
176         address payable receiver,
177         uint256 amount
178     ) external onlyOwner {
179         if (LibAsset.isNativeAsset(assetId)) {
180             // solhint-disable-next-line avoid-low-level-calls
181             (bool success, ) = receiver.call{ value: amount }("");
182             if (!success) revert ExternalCallFailed();
183         } else {
184             IERC20(assetId).safeTransfer(receiver, amount);
185         }
186     }
187 
188     /// Private Methods ///
189 
190     /// @notice Performs a swap before completing a cross-chain transaction
191     /// @param _transactionId the transaction id associated with the operation
192     /// @param _swapData array of data needed for swaps
193     /// @param assetId token received from the other chain
194     /// @param receiver address that will receive tokens in the end
195     /// @param amount amount of token
196     /// @param reserveRecoverGas whether we need a gas buffer to recover
197     function _swapAndCompleteBridgeTokens(
198         bytes32 _transactionId,
199         LibSwap.SwapData[] memory _swapData,
200         address assetId,
201         address payable receiver,
202         uint256 amount,
203         bool reserveRecoverGas
204     ) private {
205         uint256 _recoverGas = reserveRecoverGas ? recoverGas : 0;
206 
207         if (LibAsset.isNativeAsset(assetId)) {
208             // case 1: native asset
209             uint256 cacheGasLeft = gasleft();
210             if (reserveRecoverGas && cacheGasLeft < _recoverGas) {
211                 // case 1a: not enough gas left to execute calls
212                 // solhint-disable-next-line avoid-low-level-calls
213                 (bool success, ) = receiver.call{ value: amount }("");
214                 if (!success) revert ExternalCallFailed();
215 
216                 emit LiFiTransferRecovered(
217                     _transactionId,
218                     assetId,
219                     receiver,
220                     amount,
221                     block.timestamp
222                 );
223                 return;
224             }
225 
226             // case 1b: enough gas left to execute calls
227             // solhint-disable no-empty-blocks
228             try
229                 executor.swapAndCompleteBridgeTokens{
230                     value: amount,
231                     gas: cacheGasLeft - _recoverGas
232                 }(_transactionId, _swapData, assetId, receiver)
233             {} catch {
234                 // solhint-disable-next-line avoid-low-level-calls
235                 (bool success, ) = receiver.call{ value: amount }("");
236                 if (!success) revert ExternalCallFailed();
237 
238                 emit LiFiTransferRecovered(
239                     _transactionId,
240                     assetId,
241                     receiver,
242                     amount,
243                     block.timestamp
244                 );
245             }
246         } else {
247             // case 2: ERC20 asset
248             uint256 cacheGasLeft = gasleft();
249             IERC20 token = IERC20(assetId);
250             token.safeApprove(address(executor), 0);
251 
252             if (reserveRecoverGas && cacheGasLeft < _recoverGas) {
253                 // case 2a: not enough gas left to execute calls
254                 token.safeTransfer(receiver, amount);
255 
256                 emit LiFiTransferRecovered(
257                     _transactionId,
258                     assetId,
259                     receiver,
260                     amount,
261                     block.timestamp
262                 );
263                 return;
264             }
265 
266             // case 2b: enough gas left to execute calls
267             token.safeIncreaseAllowance(address(executor), amount);
268             try
269                 executor.swapAndCompleteBridgeTokens{
270                     gas: cacheGasLeft - _recoverGas
271                 }(_transactionId, _swapData, assetId, receiver)
272             {} catch {
273                 token.safeTransfer(receiver, amount);
274                 emit LiFiTransferRecovered(
275                     _transactionId,
276                     assetId,
277                     receiver,
278                     amount,
279                     block.timestamp
280                 );
281             }
282 
283             token.safeApprove(address(executor), 0);
284         }
285     }
286 
287     /// @notice Receive native asset directly.
288     /// @dev Some bridges may send native asset before execute external calls.
289     // solhint-disable-next-line no-empty-blocks
290     receive() external payable {}
291 }
