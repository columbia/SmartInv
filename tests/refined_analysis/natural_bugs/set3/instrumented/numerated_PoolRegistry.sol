1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/math/SafeMath.sol";
7 import "@openzeppelin/contracts/access/Ownable.sol";
8 import "@openzeppelin/contracts/access/AccessControl.sol";
9 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
10 import "../helper/BaseBoringBatchable.sol";
11 import "../interfaces/ISwap.sol";
12 import "../interfaces/ISwapGuarded.sol";
13 import "../interfaces/IMetaSwap.sol";
14 import "../interfaces/IPoolRegistry.sol";
15 import "../meta/MetaSwapDeposit.sol";
16 
17 /**
18  * @title PoolRegistry
19  * @notice This contract holds list of pools deployed.
20  */
21 contract PoolRegistry is
22     AccessControl,
23     ReentrancyGuard,
24     BaseBoringBatchable,
25     IPoolRegistry
26 {
27     using SafeMath for uint256;
28 
29     /// @notice Role responsible for managing pools.
30     bytes32 public constant SADDLE_MANAGER_ROLE =
31         keccak256("SADDLE_MANAGER_ROLE");
32     /// @notice Role responsible for managing community pools
33     bytes32 public constant COMMUNITY_MANAGER_ROLE =
34         keccak256("COMMUNITY_MANAGER_ROLE");
35     /// @notice Role that represents approved owners of pools.
36     /// owner of each pool must have this role if the pool is to be approved.
37     bytes32 public constant SADDLE_APPROVED_POOL_OWNER_ROLE =
38         keccak256("SADDLE_APPROVED_POOL_OWNER_ROLE");
39 
40     /// @inheritdoc IPoolRegistry
41     mapping(address => uint256) public override poolsIndexOfPlusOne;
42     /// @inheritdoc IPoolRegistry
43     mapping(bytes32 => uint256) public override poolsIndexOfNamePlusOne;
44 
45     PoolData[] private pools;
46     mapping(uint256 => address[]) private eligiblePairsMap;
47 
48     /**
49      * @notice Add a new registry entry to the master list.
50      * @param poolAddress address of the added pool
51      * @param index index of the added pool in the pools list
52      * @param poolData added pool data
53      */
54     event AddPool(
55         address indexed poolAddress,
56         uint256 index,
57         PoolData poolData
58     );
59 
60     /**
61      * @notice Add a new registry entry to the master list.
62      * @param poolAddress address of the added pool
63      * @param index index of the added pool in the pools list
64      * @param poolData added pool data
65      */
66     event AddCommunityPool(
67         address indexed poolAddress,
68         uint256 index,
69         PoolData poolData
70     );
71 
72     /**
73      * @notice Add a new registry entry to the master list.
74      * @param poolAddress address of the updated pool
75      * @param index index of the updated pool in the pools list
76      * @param poolData updated pool data
77      */
78     event UpdatePool(
79         address indexed poolAddress,
80         uint256 index,
81         PoolData poolData
82     );
83 
84     /**
85      * @notice Add a new registry entry to the master list.
86      * @param poolAddress address of the removed pool
87      * @param index index of the removed pool in the pools list
88      */
89     event RemovePool(address indexed poolAddress, uint256 index);
90 
91     /**
92      * @notice Deploy this contract and set appropriate roles
93      * @param admin address who should have the DEFAULT_ADMIN_ROLE
94      * @dev caller of this function will be set as the owner on deployment
95      */
96     constructor(address admin, address poolOwner) public payable {
97         require(admin != address(0), "admin == 0");
98         _setupRole(DEFAULT_ADMIN_ROLE, admin);
99         _setupRole(SADDLE_MANAGER_ROLE, msg.sender);
100         _setupRole(SADDLE_APPROVED_POOL_OWNER_ROLE, poolOwner);
101     }
102 
103     /// @inheritdoc IPoolRegistry
104     function addCommunityPool(PoolData memory data) external payable override {
105         require(
106             hasRole(COMMUNITY_MANAGER_ROLE, msg.sender),
107             "PR: Only managers can add pools"
108         );
109 
110         // Check token addresses
111         for (uint8 i = 0; i < data.tokens.length; i++) {
112             for (uint8 j = 0; j < i; j++) {
113                 eligiblePairsMap[
114                     uint160(address(data.tokens[i])) ^
115                         uint160(address(data.tokens[j]))
116                 ].push(data.poolAddress);
117             }
118         }
119 
120         // Check meta swap deposit address
121         if (data.metaSwapDepositAddress != address(0)) {
122             for (uint8 i = 0; i < data.underlyingTokens.length; i++) {
123                 // add combinations of tokens to eligible pairs map
124                 // i reprents the indexes of the underlying tokens of metaLPToken.
125                 // j represents the indexes of MetaSwap level tokens that are not metaLPToken.
126                 // Example: tokens = [sUSD, baseLPToken]
127                 //         underlyingTokens = [sUSD, DAI, USDC, USDT]
128                 // i represents index of [DAI, USDC, USDT] in underlyingTokens
129                 // j represents index of [sUSD] in underlyingTokens
130                 if (i > data.tokens.length.sub(2))
131                     for (uint256 j = 0; j < data.tokens.length - 1; j++) {
132                         eligiblePairsMap[
133                             uint160(address(data.underlyingTokens[i])) ^
134                                 uint160(address(data.underlyingTokens[j]))
135                         ].push(data.metaSwapDepositAddress);
136                     }
137             }
138         }
139 
140         pools.push(data);
141         poolsIndexOfPlusOne[data.poolAddress] = pools.length;
142         poolsIndexOfNamePlusOne[data.poolName] = pools.length;
143 
144         emit AddCommunityPool(data.poolAddress, pools.length - 1, data);
145     }
146 
147     /// @inheritdoc IPoolRegistry
148     function addPool(PoolInputData memory inputData)
149         external
150         payable
151         override
152         nonReentrant
153     {
154         require(
155             hasRole(SADDLE_MANAGER_ROLE, msg.sender),
156             "PR: Only managers can add pools"
157         );
158         require(inputData.poolAddress != address(0), "PR: poolAddress is 0");
159         require(
160             poolsIndexOfPlusOne[inputData.poolAddress] == 0,
161             "PR: Pool is already added"
162         );
163 
164         IERC20[] memory tokens = new IERC20[](8);
165         IERC20[] memory underlyingTokens = new IERC20[](8);
166 
167         PoolData memory data = PoolData(
168             inputData.poolAddress,
169             address(0),
170             inputData.typeOfAsset,
171             inputData.poolName,
172             inputData.targetAddress,
173             tokens,
174             underlyingTokens,
175             address(0),
176             inputData.metaSwapDepositAddress,
177             inputData.isSaddleApproved,
178             inputData.isRemoved,
179             inputData.isGuarded
180         );
181 
182         // Get lp token address
183         data.lpToken = inputData.isGuarded
184             ? _getSwapStorageGuarded(inputData.poolAddress).lpToken
185             : _getSwapStorage(inputData.poolAddress).lpToken;
186 
187         // Check token addresses
188         for (uint8 i = 0; i < 8; i++) {
189             try ISwap(inputData.poolAddress).getToken(i) returns (
190                 IERC20 token
191             ) {
192                 require(address(token) != address(0), "PR: token is 0");
193                 tokens[i] = token;
194                 // add combinations of tokens to eligible pairs map
195                 for (uint8 j = 0; j < i; j++) {
196                     eligiblePairsMap[
197                         uint160(address(tokens[i])) ^
198                             uint160(address(tokens[j]))
199                     ].push(inputData.poolAddress);
200                 }
201             } catch {
202                 assembly {
203                     mstore(tokens, sub(mload(tokens), sub(8, i)))
204                 }
205                 break;
206             }
207         }
208 
209         // Check meta swap deposit address
210         if (inputData.metaSwapDepositAddress != address(0)) {
211             // Get base pool address
212             data.basePoolAddress = address(
213                 MetaSwapDeposit(inputData.metaSwapDepositAddress).baseSwap()
214             );
215             require(
216                 poolsIndexOfPlusOne[data.basePoolAddress] > 0,
217                 "PR: base pool not found"
218             );
219 
220             // Get underlying tokens
221             for (uint8 i = 0; i < 8; i++) {
222                 try
223                     MetaSwapDeposit(inputData.metaSwapDepositAddress).getToken(
224                         i
225                     )
226                 returns (IERC20 token) {
227                     require(address(token) != address(0), "PR: token is 0");
228                     underlyingTokens[i] = token;
229                     // add combinations of tokens to eligible pairs map
230                     // i reprents the indexes of the underlying tokens of metaLPToken.
231                     // j represents the indexes of MetaSwap level tokens that are not metaLPToken.
232                     // Example: tokens = [sUSD, baseLPToken]
233                     //         underlyingTokens = [sUSD, DAI, USDC, USDT]
234                     // i represents index of [DAI, USDC, USDT] in underlyingTokens
235                     // j represents index of [sUSD] in underlyingTokens
236                     if (i > tokens.length.sub(2))
237                         for (uint256 j = 0; j < tokens.length - 1; j++) {
238                             eligiblePairsMap[
239                                 uint160(address(underlyingTokens[i])) ^
240                                     uint160(address(underlyingTokens[j]))
241                             ].push(inputData.metaSwapDepositAddress);
242                         }
243                 } catch {
244                     assembly {
245                         mstore(
246                             underlyingTokens,
247                             sub(mload(underlyingTokens), sub(8, i))
248                         )
249                     }
250                     break;
251                 }
252             }
253             require(
254                 address(
255                     MetaSwapDeposit(inputData.metaSwapDepositAddress).metaSwap()
256                 ) == inputData.poolAddress,
257                 "PR: metaSwap address mismatch"
258             );
259         } else {
260             assembly {
261                 mstore(underlyingTokens, sub(mload(underlyingTokens), 8))
262             }
263         }
264 
265         pools.push(data);
266         poolsIndexOfPlusOne[data.poolAddress] = pools.length;
267         poolsIndexOfNamePlusOne[data.poolName] = pools.length;
268 
269         emit AddPool(inputData.poolAddress, pools.length - 1, data);
270     }
271 
272     /// @inheritdoc IPoolRegistry
273     function approvePool(address poolAddress)
274         external
275         payable
276         override
277         managerOnly
278     {
279         uint256 poolIndex = poolsIndexOfPlusOne[poolAddress];
280         require(poolIndex > 0, "PR: Pool not found");
281 
282         PoolData storage poolData = pools[poolIndex];
283 
284         require(
285             poolData.poolAddress == poolAddress,
286             "PR: poolAddress mismatch"
287         );
288 
289         // Effect
290         poolData.isSaddleApproved = true;
291 
292         // Interaction
293         require(
294             hasRole(
295                 SADDLE_APPROVED_POOL_OWNER_ROLE,
296                 ISwap(poolAddress).owner()
297             ),
298             "Pool is not owned by saddle"
299         );
300 
301         emit UpdatePool(poolAddress, poolIndex, poolData);
302     }
303 
304     /// @inheritdoc IPoolRegistry
305     function updatePool(PoolData memory poolData)
306         external
307         payable
308         override
309         managerOnly
310     {
311         uint256 poolIndex = poolsIndexOfPlusOne[poolData.poolAddress];
312         require(poolIndex > 0, "PR: Pool not found");
313         poolIndex -= 1;
314 
315         pools[poolIndex] = poolData;
316 
317         emit UpdatePool(poolData.poolAddress, poolIndex, poolData);
318     }
319 
320     /// @inheritdoc IPoolRegistry
321     function removePool(address poolAddress)
322         external
323         payable
324         override
325         managerOnly
326     {
327         uint256 poolIndex = poolsIndexOfPlusOne[poolAddress];
328         require(poolIndex > 0, "PR: Pool not found");
329         poolIndex -= 1;
330 
331         pools[poolIndex].isRemoved = true;
332 
333         emit RemovePool(poolAddress, poolIndex);
334     }
335 
336     /// @inheritdoc IPoolRegistry
337     function getPoolDataAtIndex(uint256 index)
338         external
339         view
340         override
341         returns (PoolData memory)
342     {
343         require(index < pools.length, "PR: Index out of bounds");
344         return pools[index];
345     }
346 
347     /// @inheritdoc IPoolRegistry
348     function getPoolData(address poolAddress)
349         external
350         view
351         override
352         hasMatchingPool(poolAddress)
353         returns (PoolData memory)
354     {
355         return pools[poolsIndexOfPlusOne[poolAddress] - 1];
356     }
357 
358     /// @inheritdoc IPoolRegistry
359     function getPoolDataByName(bytes32 poolName)
360         external
361         view
362         override
363         returns (PoolData memory)
364     {
365         uint256 index = poolsIndexOfNamePlusOne[poolName];
366         require(index > 0, "PR: Pool not found");
367         return pools[index - 1];
368     }
369 
370     modifier hasMatchingPool(address poolAddress) {
371         require(
372             poolsIndexOfPlusOne[poolAddress] > 0,
373             "PR: No matching pool found"
374         );
375         _;
376     }
377 
378     modifier managerOnly() {
379         require(
380             hasRole(SADDLE_MANAGER_ROLE, msg.sender),
381             "PR: Caller is not saddle manager"
382         );
383         _;
384     }
385 
386     /// @inheritdoc IPoolRegistry
387     function getVirtualPrice(address poolAddress)
388         external
389         view
390         override
391         hasMatchingPool(poolAddress)
392         returns (uint256)
393     {
394         return ISwap(poolAddress).getVirtualPrice();
395     }
396 
397     /// @inheritdoc IPoolRegistry
398     function getA(address poolAddress)
399         external
400         view
401         override
402         hasMatchingPool(poolAddress)
403         returns (uint256)
404     {
405         return ISwap(poolAddress).getA();
406     }
407 
408     /// @inheritdoc IPoolRegistry
409     function getPaused(address poolAddress)
410         external
411         view
412         override
413         hasMatchingPool(poolAddress)
414         returns (bool)
415     {
416         return ISwap(poolAddress).paused();
417     }
418 
419     /// @inheritdoc IPoolRegistry
420     function getSwapStorage(address poolAddress)
421         external
422         view
423         override
424         hasMatchingPool(poolAddress)
425         returns (SwapStorageData memory swapStorageData)
426     {
427         swapStorageData = pools[poolsIndexOfPlusOne[poolAddress] - 1].isGuarded
428             ? _getSwapStorageGuarded(poolAddress)
429             : _getSwapStorage(poolAddress);
430     }
431 
432     function _getSwapStorage(address poolAddress)
433         internal
434         view
435         returns (SwapStorageData memory swapStorageData)
436     {
437         (
438             swapStorageData.initialA,
439             swapStorageData.futureA,
440             swapStorageData.initialATime,
441             swapStorageData.futureATime,
442             swapStorageData.swapFee,
443             swapStorageData.adminFee,
444             swapStorageData.lpToken
445         ) = ISwap(poolAddress).swapStorage();
446     }
447 
448     function _getSwapStorageGuarded(address poolAddress)
449         internal
450         view
451         returns (SwapStorageData memory swapStorageData)
452     {
453         (
454             swapStorageData.initialA,
455             swapStorageData.futureA,
456             swapStorageData.initialATime,
457             swapStorageData.futureATime,
458             swapStorageData.swapFee,
459             swapStorageData.adminFee,
460             ,
461             swapStorageData.lpToken
462         ) = ISwapGuarded(poolAddress).swapStorage();
463     }
464 
465     /// @inheritdoc IPoolRegistry
466     function getTokens(address poolAddress)
467         external
468         view
469         override
470         hasMatchingPool(poolAddress)
471         returns (IERC20[] memory tokens)
472     {
473         return pools[poolsIndexOfPlusOne[poolAddress] - 1].tokens;
474     }
475 
476     /// @inheritdoc IPoolRegistry
477     function getUnderlyingTokens(address poolAddress)
478         external
479         view
480         override
481         hasMatchingPool(poolAddress)
482         returns (IERC20[] memory underlyingTokens)
483     {
484         return pools[poolsIndexOfPlusOne[poolAddress] - 1].underlyingTokens;
485     }
486 
487     /// @inheritdoc IPoolRegistry
488     function getPoolsLength() external view override returns (uint256) {
489         return pools.length;
490     }
491 
492     /// @inheritdoc IPoolRegistry
493     function getEligiblePools(address from, address to)
494         external
495         view
496         override
497         returns (address[] memory eligiblePools)
498     {
499         require(
500             from != address(0) && from != to,
501             "PR: from and to cannot be the zero address"
502         );
503         return eligiblePairsMap[uint160(from) ^ uint160(to)];
504     }
505 
506     /// @inheritdoc IPoolRegistry
507     function getTokenBalances(address poolAddress)
508         external
509         view
510         override
511         hasMatchingPool(poolAddress)
512         returns (uint256[] memory balances)
513     {
514         return _getTokenBalances(poolAddress);
515     }
516 
517     function _getTokenBalances(address poolAddress)
518         internal
519         view
520         returns (uint256[] memory balances)
521     {
522         uint256 tokensLength = pools[poolsIndexOfPlusOne[poolAddress] - 1]
523             .tokens
524             .length;
525         balances = new uint256[](tokensLength);
526         for (uint8 i = 0; i < tokensLength; i++) {
527             balances[i] = ISwap(poolAddress).getTokenBalance(i);
528         }
529     }
530 
531     /// @inheritdoc IPoolRegistry
532     function getUnderlyingTokenBalances(address poolAddress)
533         external
534         view
535         override
536         hasMatchingPool(poolAddress)
537         returns (uint256[] memory balances)
538     {
539         uint256 poolIndex = poolsIndexOfPlusOne[poolAddress] - 1;
540         address basePoolAddress = pools[poolIndex].basePoolAddress;
541         uint256[] memory basePoolBalances = _getTokenBalances(basePoolAddress);
542         uint256 underlyingTokensLength = pools[poolIndex]
543             .underlyingTokens
544             .length;
545         uint256 metaLPTokenIndex = underlyingTokensLength -
546             basePoolBalances.length;
547         uint256 baseLPTokenBalance = ISwap(poolAddress).getTokenBalance(
548             uint8(metaLPTokenIndex)
549         );
550         uint256 baseLPTokenTotalSupply = LPToken(
551             pools[poolsIndexOfPlusOne[basePoolAddress] - 1].lpToken
552         ).totalSupply();
553 
554         balances = new uint256[](underlyingTokensLength);
555         for (uint8 i = 0; i < metaLPTokenIndex; i++) {
556             balances[i] = ISwap(poolAddress).getTokenBalance(i);
557         }
558         for (uint256 i = metaLPTokenIndex; i < underlyingTokensLength; i++) {
559             balances[i] = basePoolBalances[i - metaLPTokenIndex]
560                 .mul(baseLPTokenBalance)
561                 .div(baseLPTokenTotalSupply);
562         }
563     }
564 }
