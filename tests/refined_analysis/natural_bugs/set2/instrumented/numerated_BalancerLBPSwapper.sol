1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./manager/WeightedBalancerPoolManager.sol";
5 import "./IVault.sol";
6 import "../../utils/Timed.sol";
7 import "../../refs/OracleRef.sol";
8 import "../../core/TribeRoles.sol";
9 import "../IPCVSwapper.sol";
10 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
11 
12 /// @title BalancerLBPSwapper
13 /// @author Fei Protocol
14 /// @notice an auction contract which cyclically sells one token for another using Balancer LBP
15 contract BalancerLBPSwapper is IPCVSwapper, OracleRef, Timed, WeightedBalancerPoolManager {
16     using Decimal for Decimal.D256;
17     using SafeERC20 for IERC20;
18 
19     // ------------- Events -------------
20 
21     event WithdrawERC20(address indexed _caller, address indexed _token, address indexed _to, uint256 _amount);
22 
23     event ExitPool();
24 
25     event MinTokenSpentUpdate(uint256 oldMinTokenSpentBalance, uint256 newMinTokenSpentBalance);
26 
27     // ------------- Balancer State -------------
28     /// @notice the Balancer LBP used for swapping
29     IWeightedPool public pool;
30 
31     /// @notice the Balancer V2 Vault contract
32     IVault public vault;
33 
34     /// @notice the Balancer V2 Pool id of `pool`
35     bytes32 public pid;
36 
37     // Balancer constants for the weight changes
38     uint256 public immutable SMALL_PERCENT;
39     uint256 public immutable LARGE_PERCENT;
40 
41     // Balancer constants to memoize the target assets and weights from pool
42     IAsset[] private assets;
43     uint256[] private initialWeights;
44     uint256[] private endWeights;
45 
46     // ------------- Swapper State -------------
47 
48     /// @notice the token to be auctioned
49     address public immutable override tokenSpent;
50 
51     /// @notice the token to buy
52     address public immutable override tokenReceived;
53 
54     /// @notice the address to send `tokenReceived`
55     address public override tokenReceivingAddress;
56 
57     /// @notice the minimum amount of tokenSpent to kick off a new auction on swap()
58     uint256 public minTokenSpentBalance;
59 
60     struct OracleData {
61         address _oracle;
62         address _backupOracle;
63         // invert should be false if the oracle is reported in tokenSpent terms otherwise true
64         bool _invertOraclePrice;
65         // The decimalsNormalizer should be calculated as tokenSpent.decimals() - tokenReceived.decimals() if invert is false, otherwise reverse order
66         int256 _decimalsNormalizer;
67     }
68 
69     /**
70     @notice constructor for BalancerLBPSwapper
71     @param _core Core contract to reference
72     @param oracleData The parameters needed to initialize the OracleRef
73     @param _frequency minimum time between auctions and duration of auction
74     @param _weightSmall the small weight of weight changes (e.g. 5%)
75     @param _weightLarge the large weight of weight changes (e.g. 95%)
76     @param _tokenSpent the token to be auctioned
77     @param _tokenReceived the token to buy
78     @param _tokenReceivingAddress the address to send `tokenReceived`
79     @param _minTokenSpentBalance the minimum amount of tokenSpent to kick off a new auction on swap()
80      */
81     constructor(
82         address _core,
83         OracleData memory oracleData,
84         uint256 _frequency,
85         uint256 _weightSmall,
86         uint256 _weightLarge,
87         address _tokenSpent,
88         address _tokenReceived,
89         address _tokenReceivingAddress,
90         uint256 _minTokenSpentBalance
91     )
92         OracleRef(
93             _core,
94             oracleData._oracle,
95             oracleData._backupOracle,
96             oracleData._decimalsNormalizer,
97             oracleData._invertOraclePrice
98         )
99         Timed(_frequency)
100         WeightedBalancerPoolManager()
101     {
102         // weight changes
103         SMALL_PERCENT = _weightSmall;
104         LARGE_PERCENT = _weightLarge;
105         require(_weightSmall < _weightLarge, "BalancerLBPSwapper: bad weights");
106         require(_weightSmall + _weightLarge == 1e18, "BalancerLBPSwapper: weights not normalized");
107 
108         // tokenSpent and tokenReceived are immutable
109         tokenSpent = _tokenSpent;
110         tokenReceived = _tokenReceived;
111 
112         _setReceivingAddress(_tokenReceivingAddress);
113         _setMinTokenSpent(_minTokenSpentBalance);
114 
115         _setContractAdminRole(keccak256("SWAP_ADMIN_ROLE"));
116     }
117 
118     /**
119     @notice initialize Balancer LBP
120     Needs to be a separate method because this contract needs to be deployed and supplied
121     as the owner of the pool on construction.
122     Includes various checks to ensure the pool contract is correct and initialization can only be done once
123     @param _pool the Balancer LBP used for swapping
124     */
125     function init(IWeightedPool _pool) external {
126         require(address(pool) == address(0), "BalancerLBPSwapper: initialized");
127         _initTimed();
128 
129         pool = _pool;
130         IVault _vault = _pool.getVault();
131 
132         vault = _vault;
133 
134         // Check ownership
135         require(_pool.getOwner() == address(this), "BalancerLBPSwapper: contract not pool owner");
136 
137         // Check correct pool token components
138         bytes32 _pid = _pool.getPoolId();
139         pid = _pid;
140         (IERC20[] memory tokens, , ) = _vault.getPoolTokens(_pid);
141         require(tokens.length == 2, "BalancerLBPSwapper: pool does not have 2 tokens");
142         require(
143             tokenSpent == address(tokens[0]) || tokenSpent == address(tokens[1]),
144             "BalancerLBPSwapper: tokenSpent not in pool"
145         );
146         require(
147             tokenReceived == address(tokens[0]) || tokenReceived == address(tokens[1]),
148             "BalancerLBPSwapper: tokenReceived not in pool"
149         );
150 
151         // Set the asset array and target weights
152         assets = new IAsset[](2);
153         assets[0] = IAsset(address(tokens[0]));
154         assets[1] = IAsset(address(tokens[1]));
155 
156         bool tokenSpentAtIndex0 = tokenSpent == address(tokens[0]);
157         initialWeights = new uint256[](2);
158         endWeights = new uint256[](2);
159 
160         if (tokenSpentAtIndex0) {
161             initialWeights[0] = LARGE_PERCENT;
162             initialWeights[1] = SMALL_PERCENT;
163 
164             endWeights[0] = SMALL_PERCENT;
165             endWeights[1] = LARGE_PERCENT;
166         } else {
167             initialWeights[0] = SMALL_PERCENT;
168             initialWeights[1] = LARGE_PERCENT;
169 
170             endWeights[0] = LARGE_PERCENT;
171             endWeights[1] = SMALL_PERCENT;
172         }
173 
174         // Approve pool tokens for vault
175         _pool.approve(address(_vault), type(uint256).max);
176         IERC20(tokenSpent).approve(address(_vault), type(uint256).max);
177         IERC20(tokenReceived).approve(address(_vault), type(uint256).max);
178     }
179 
180     /**
181         @notice Swap algorithm
182         1. Withdraw existing LP tokens
183         2. Reset weights
184         3. Provide new liquidity
185         4. Trigger gradual weight change
186         5. Transfer remaining tokenReceived to tokenReceivingAddress
187         @dev assumes tokenSpent balance of contract exceeds minTokenSpentBalance to kick off a new auction
188     */
189     function swap() external override afterTime whenNotPaused onlyGovernorOrAdmin {
190         _swap();
191     }
192 
193     /**
194         @notice Force a swap() call, without waiting afterTime.
195         This should only be callable after init() call, when no
196         other swap is happening (call reverts if weight change
197         is in progress).
198     */
199     function forceSwap() external whenNotPaused onlyGovernor {
200         _swap();
201     }
202 
203     /// @notice exit LBP with all assets to this contract. The tokens can then be withdrawn via standard PCV deposit methods.
204     function exitPoolToSelf()
205         external
206         hasAnyOfThreeRoles(TribeRoles.GUARDIAN, TribeRoles.PCV_CONTROLLER, TribeRoles.SWAP_ADMIN_ROLE)
207     {
208         _exitPool();
209     }
210 
211     /// @notice redeeem all assets from LP pool
212     /// @param to destination for withdrawn tokens
213     function exitPool(address to) external onlyPCVController {
214         _exitPool();
215         _transferAll(tokenSpent, to);
216         _transferAll(tokenReceived, to);
217     }
218 
219     /// @notice withdraw ERC20 from the contract
220     /// @param token address of the ERC20 to send
221     /// @param to address destination of the ERC20
222     /// @param amount quantity of ERC20 to send
223     function withdrawERC20(
224         address token,
225         address to,
226         uint256 amount
227     ) public onlyPCVController {
228         IERC20(token).safeTransfer(to, amount);
229         emit WithdrawERC20(msg.sender, token, to, amount);
230     }
231 
232     /// @notice returns when the next auction ends
233     function swapEndTime() public view returns (uint256 endTime) {
234         (, endTime, ) = pool.getGradualWeightUpdateParams();
235     }
236 
237     /// @notice sets the minimum time between swaps
238     /// @param _frequency minimum time between swaps in seconds
239     function setSwapFrequency(uint256 _frequency) external onlyGovernorOrAdmin {
240         _setDuration(_frequency);
241     }
242 
243     /// @notice sets the minimum token spent balance
244     /// @param newMinTokenSpentBalance minimum amount of FEI to trigger a new auction
245     function setMinTokenSpent(uint256 newMinTokenSpentBalance) external onlyGovernorOrAdmin {
246         _setMinTokenSpent(newMinTokenSpentBalance);
247     }
248 
249     /// @notice Sets the address receiving swap's inbound tokens
250     /// @param newTokenReceivingAddress the address that will receive tokens
251     function setReceivingAddress(address newTokenReceivingAddress) external override onlyGovernorOrAdmin {
252         _setReceivingAddress(newTokenReceivingAddress);
253     }
254 
255     /// @notice return the amount of tokens needed to seed the next auction
256     function getTokensIn(uint256 spentTokenBalance)
257         external
258         view
259         returns (address[] memory tokens, uint256[] memory amountsIn)
260     {
261         tokens = new address[](2);
262         tokens[0] = address(assets[0]);
263         tokens[1] = address(assets[1]);
264 
265         return (tokens, _getTokensIn(spentTokenBalance));
266     }
267 
268     /**
269         @notice Swap algorithm
270         1. Withdraw existing LP tokens
271         2. Reset weights
272         3. Provide new liquidity
273         4. Trigger gradual weight change
274         5. Transfer remaining tokenReceived to tokenReceivingAddress
275         @dev assumes tokenSpent balance of contract exceeds minTokenSpentBalance to kick off a new auction
276     */
277     function _swap() internal {
278         (, , uint256 lastChangeBlock) = vault.getPoolTokens(pid);
279 
280         // Ensures no actor can change the pool contents earlier in the block
281         require(lastChangeBlock < block.number, "BalancerLBPSwapper: pool changed this block");
282 
283         uint256 bptTotal = pool.totalSupply();
284 
285         // Balancer locks a small amount of bptTotal after init, so 0 bpt means pool needs initializing
286         if (bptTotal == 0) {
287             _initializePool();
288             return;
289         }
290         require(swapEndTime() < block.timestamp, "BalancerLBPSwapper: weight update in progress");
291 
292         // 1. Withdraw existing LP tokens (if currently held)
293         _exitPool();
294 
295         // 2. Reset weights to LARGE_PERCENT:SMALL_PERCENT
296         // Using current block time triggers immediate weight reset
297         _updateWeightsGradually(pool, block.timestamp, block.timestamp, initialWeights);
298 
299         // 3. Provide new liquidity
300         uint256 spentTokenBalance = IERC20(tokenSpent).balanceOf(address(this));
301         require(spentTokenBalance > minTokenSpentBalance, "BalancerLBPSwapper: not enough for new swap");
302 
303         // uses exact tokens in encoding for deposit, supplying both tokens
304         // will use some of the previously withdrawn tokenReceived to seed the 1% required for new auction
305         uint256[] memory amountsIn = _getTokensIn(spentTokenBalance);
306         bytes memory userData = abi.encode(IWeightedPool.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT, amountsIn, 0);
307 
308         IVault.JoinPoolRequest memory joinRequest;
309         joinRequest.assets = assets;
310         joinRequest.maxAmountsIn = amountsIn;
311         joinRequest.userData = userData;
312         joinRequest.fromInternalBalance = false; // uses external balances because tokens are held by contract
313 
314         vault.joinPool(pid, address(this), payable(address(this)), joinRequest);
315 
316         // 4. Kick off new auction ending after `duration` seconds
317         _updateWeightsGradually(pool, block.timestamp, block.timestamp + duration, endWeights);
318         _initTimed(); // reset timer
319         // 5. Send remaining tokenReceived to target
320         _transferAll(tokenReceived, tokenReceivingAddress);
321     }
322 
323     function _exitPool() internal {
324         uint256 bptBalance = pool.balanceOf(address(this));
325         if (bptBalance != 0) {
326             IVault.ExitPoolRequest memory exitRequest;
327 
328             // Uses encoding for exact BPT IN withdrawal using all held BPT
329             bytes memory userData = abi.encode(IWeightedPool.ExitKind.EXACT_BPT_IN_FOR_TOKENS_OUT, bptBalance);
330 
331             exitRequest.assets = assets;
332             exitRequest.minAmountsOut = new uint256[](2); // 0 min
333             exitRequest.userData = userData;
334             exitRequest.toInternalBalance = false; // use external balances to be able to transfer out tokenReceived
335 
336             vault.exitPool(pid, address(this), payable(address(this)), exitRequest);
337             emit ExitPool();
338         }
339     }
340 
341     function _transferAll(address token, address to) internal {
342         IERC20 _token = IERC20(token);
343         _token.safeTransfer(to, _token.balanceOf(address(this)));
344     }
345 
346     function _setReceivingAddress(address newTokenReceivingAddress) internal {
347         require(newTokenReceivingAddress != address(0), "BalancerLBPSwapper: zero address");
348         address oldTokenReceivingAddress = tokenReceivingAddress;
349         tokenReceivingAddress = newTokenReceivingAddress;
350         emit UpdateReceivingAddress(oldTokenReceivingAddress, newTokenReceivingAddress);
351     }
352 
353     function _initializePool() internal {
354         // Balancer LBP initialization uses a unique JoinKind which only takes in amountsIn
355         uint256 spentTokenBalance = IERC20(tokenSpent).balanceOf(address(this));
356         require(spentTokenBalance >= minTokenSpentBalance, "BalancerLBPSwapper: not enough tokenSpent to init");
357 
358         uint256[] memory amountsIn = _getTokensIn(spentTokenBalance);
359         bytes memory userData = abi.encode(IWeightedPool.JoinKind.INIT, amountsIn);
360 
361         IVault.JoinPoolRequest memory joinRequest;
362         joinRequest.assets = assets;
363         joinRequest.maxAmountsIn = amountsIn;
364         joinRequest.userData = userData;
365         joinRequest.fromInternalBalance = false;
366 
367         vault.joinPool(pid, address(this), payable(address(this)), joinRequest);
368 
369         // Kick off the first auction
370         _updateWeightsGradually(pool, block.timestamp, block.timestamp + duration, endWeights);
371         _initTimed();
372 
373         _transferAll(tokenReceived, tokenReceivingAddress);
374     }
375 
376     function _getTokensIn(uint256 spentTokenBalance) internal view returns (uint256[] memory amountsIn) {
377         amountsIn = new uint256[](2);
378 
379         uint256 receivedTokenBalance = readOracle()
380             .mul(spentTokenBalance)
381             .mul(SMALL_PERCENT)
382             .div(LARGE_PERCENT)
383             .asUint256();
384 
385         if (address(assets[0]) == tokenSpent) {
386             amountsIn[0] = spentTokenBalance;
387             amountsIn[1] = receivedTokenBalance;
388         } else {
389             amountsIn[0] = receivedTokenBalance;
390             amountsIn[1] = spentTokenBalance;
391         }
392     }
393 
394     function _setMinTokenSpent(uint256 newMinTokenSpentBalance) internal {
395         uint256 oldMinTokenSpentBalance = minTokenSpentBalance;
396         minTokenSpentBalance = newMinTokenSpentBalance;
397         emit MinTokenSpentUpdate(oldMinTokenSpentBalance, newMinTokenSpentBalance);
398     }
399 }
