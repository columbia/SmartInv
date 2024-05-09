1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.6;
4 pragma abicoder v2;
5  
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10  
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19  
20         return c;
21     }
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26  
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29  
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         // Solidity only automatically asserts when dividing by 0
37         require(b > 0, errorMessage);
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40  
41         return c;
42     }
43     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
44         return mod(a, b, "SafeMath: modulo by zero");
45     }
46  
47     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b != 0, errorMessage);
49         return a % b;
50     }
51 }
52  
53 
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56     function decimals() external view returns (uint8);
57     function symbol() external view returns (string memory);
58     function name() external view returns (string memory);
59     function getOwner() external view returns (address);
60     function balanceOf(address account) external view returns (uint256);
61     function transfer(address recipient, uint256 amount) external returns (bool);
62     function allowance(address _owner, address spender) external view returns (uint256);
63     function approve(address spender, uint256 amount) external returns (bool);
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 interface IWETH is IERC20 {
69     function deposit() external payable;
70     function withdraw(uint256 wad) external;
71 } 
72 
73 library WethUtils {
74     IWETH public constant weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
75 
76     function isWeth(address token) internal pure returns (bool) {
77         return address(weth) == token;
78     }
79 
80     function wrap(uint256 amount) internal {
81         weth.deposit{value: amount}();
82     }
83 
84     function unwrap(uint256 amount) internal {
85         weth.withdraw(amount);
86     }
87 
88     function transfer(address to, uint256 amount) internal {
89         weth.transfer(to, amount);
90     }
91 }
92 
93 interface IERC721Receiver {
94     /**
95      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
96      * by `operator` from `from`, this function is called.
97      *
98      * It must return its Solidity selector to confirm the token transfer.
99      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
100      *
101      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
102      */
103     function onERC721Received(
104         address operator,
105         address from,
106         uint256 tokenId,
107         bytes calldata data
108     ) external returns (bytes4);
109 }
110 
111 
112 abstract contract Auth {
113     address internal owner;
114     mapping (address => bool) internal authorizations;
115  
116     constructor(address _owner) {
117         owner = _owner;
118         authorizations[_owner] = true;
119     }
120  
121     /**
122      * Function modifier to require caller to be contract owner
123      */
124     modifier onlyOwner() {
125         require(isOwner(msg.sender), "!OWNER"); _;
126     }
127  
128     /**
129      * Function modifier to require caller to be authorized
130      */
131     modifier authorized() {
132         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
133     }
134  
135     /**
136      * Authorize address. Owner only
137      */
138     function authorize(address adr) public onlyOwner {
139         authorizations[adr] = true;
140     }
141  
142     /**
143      * Remove address' authorization. Owner only
144      */
145     function unauthorize(address adr) public onlyOwner {
146         authorizations[adr] = false;
147     }
148  
149     /**
150      * Check if address is owner
151      */
152     function isOwner(address account) public view returns (bool) {
153         return account == owner;
154     }
155  
156     /**
157      * Return address' authorization status
158      */
159     function isAuthorized(address adr) public view returns (bool) {
160         return authorizations[adr];
161     }
162  
163     /**
164      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
165      */
166     function transferOwnership(address payable adr) public onlyOwner {
167         owner = adr;
168         authorizations[adr] = true;
169         emit OwnershipTransferred(adr);
170     }
171  
172     event OwnershipTransferred(address owner);
173 }
174 
175 interface IERC165 {
176     /**
177      * @dev Returns true if this contract implements the interface defined by
178      * `interfaceId`. See the corresponding
179      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
180      * to learn more about how these ids are created.
181      *
182      * This function call must use less than 30 000 gas.
183      */
184     function supportsInterface(bytes4 interfaceId) external view returns (bool);
185 }
186 
187 interface IERC721 is IERC165 {
188     /**
189      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
192 
193     /**
194      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
195      */
196     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
197 
198     /**
199      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
200      */
201     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
202 
203     /**
204      * @dev Returns the number of tokens in ``owner``'s account.
205      */
206     function balanceOf(address owner) external view returns (uint256 balance);
207 
208     /**
209      * @dev Returns the owner of the `tokenId` token.
210      *
211      * Requirements:
212      *
213      * - `tokenId` must exist.
214      */
215     function ownerOf(uint256 tokenId) external view returns (address owner);
216 
217     /**
218      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
219      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
220      *
221      * Requirements:
222      *
223      * - `from` cannot be the zero address.
224      * - `to` cannot be the zero address.
225      * - `tokenId` token must exist and be owned by `from`.
226      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
227      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
228      *
229      * Emits a {Transfer} event.
230      */
231     function safeTransferFrom(address from, address to, uint256 tokenId) external;
232 
233     /**
234      * @dev Transfers `tokenId` token from `from` to `to`.
235      *
236      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(address from, address to, uint256 tokenId) external;
248 
249     /**
250      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
251      * The approval is cleared when the token is transferred.
252      *
253      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
254      *
255      * Requirements:
256      *
257      * - The caller must own the token or be an approved operator.
258      * - `tokenId` must exist.
259      *
260      * Emits an {Approval} event.
261      */
262     function approve(address to, uint256 tokenId) external;
263 
264     /**
265      * @dev Returns the account approved for `tokenId` token.
266      *
267      * Requirements:
268      *
269      * - `tokenId` must exist.
270      */
271     function getApproved(uint256 tokenId) external view returns (address operator);
272 
273     /**
274      * @dev Approve or remove `operator` as an operator for the caller.
275      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
276      *
277      * Requirements:
278      *
279      * - The `operator` cannot be the caller.
280      *
281      * Emits an {ApprovalForAll} event.
282      */
283     function setApprovalForAll(address operator, bool _approved) external;
284 
285     /**
286      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
287      *
288      * See {setApprovalForAll}
289      */
290     function isApprovedForAll(address owner, address operator) external view returns (bool);
291 
292     /**
293       * @dev Safely transfers `tokenId` token from `from` to `to`.
294       *
295       * Requirements:
296       *
297      * - `from` cannot be the zero address.
298      * - `to` cannot be the zero address.
299       * - `tokenId` token must exist and be owned by `from`.
300       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
301       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
302       *
303       * Emits a {Transfer} event.
304       */
305     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
306 }
307 interface IERC721Metadata is IERC721 {
308     function name() external view returns (string memory);
309     function symbol() external view returns (string memory);
310     function tokenURI(uint256 tokenId) external view returns (string memory);
311 }
312 
313 interface IERC721Enumerable is IERC721 {
314 
315     /**
316      * @dev Returns the total amount of tokens stored by the contract.
317      */
318     function totalSupply() external view returns (uint256);
319 
320     /**
321      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
322      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
323      */
324     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
325 
326     /**
327      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
328      * Use along with {totalSupply} to enumerate all tokens.
329      */
330     function tokenByIndex(uint256 index) external view returns (uint256);
331 }
332 
333 interface IPoolInitializer {
334     /// @notice Creates a new pool if it does not exist, then initializes if not initialized
335     /// @dev This method can be bundled with others via IMulticall for the first action (e.g. mint) performed against a pool
336     /// @param token0 The contract address of token0 of the pool
337     /// @param token1 The contract address of token1 of the pool
338     /// @param fee The fee amount of the v3 pool for the specified token pair
339     /// @param sqrtPriceX96 The initial square root price of the pool as a Q64.96 value
340     /// @return pool Returns the pool address based on the pair of tokens and fee, will return the newly created pool address if necessary
341     function createAndInitializePoolIfNecessary(
342         address token0,
343         address token1,
344         uint24 fee,
345         uint160 sqrtPriceX96
346     ) external payable returns (address pool);
347 }
348 
349 interface IERC721Permit is IERC721 {
350     /// @notice The permit typehash used in the permit signature
351     /// @return The typehash for the permit
352     function PERMIT_TYPEHASH() external pure returns (bytes32);
353 
354     /// @notice The domain separator used in the permit signature
355     /// @return The domain seperator used in encoding of permit signature
356     function DOMAIN_SEPARATOR() external view returns (bytes32);
357 
358     /// @notice Approve of a specific token ID for spending by spender via signature
359     /// @param spender The account that is being approved
360     /// @param tokenId The ID of the token that is being approved for spending
361     /// @param deadline The deadline timestamp by which the call must be mined for the approve to work
362     /// @param v Must produce valid secp256k1 signature from the holder along with `r` and `s`
363     /// @param r Must produce valid secp256k1 signature from the holder along with `v` and `s`
364     /// @param s Must produce valid secp256k1 signature from the holder along with `r` and `v`
365     function permit(
366         address spender,
367         uint256 tokenId,
368         uint256 deadline,
369         uint8 v,
370         bytes32 r,
371         bytes32 s
372     ) external payable;
373 }
374 
375 interface IPeripheryPayments {
376     /// @notice Unwraps the contract's WETH9 balance and sends it to recipient as ETH.
377     /// @dev The amountMinimum parameter prevents malicious contracts from stealing WETH9 from users.
378     /// @param amountMinimum The minimum amount of WETH9 to unwrap
379     /// @param recipient The address receiving ETH
380     function unwrapWETH9(uint256 amountMinimum, address recipient) external payable;
381 
382     /// @notice Refunds any ETH balance held by this contract to the `msg.sender`
383     /// @dev Useful for bundling with mint or increase liquidity that uses ether, or exact output swaps
384     /// that use ether for the input amount
385     function refundETH() external payable;
386 
387     /// @notice Transfers the full amount of a token held by this contract to recipient
388     /// @dev The amountMinimum parameter prevents malicious contracts from stealing the token from users
389     /// @param token The contract address of the token which will be transferred to `recipient`
390     /// @param amountMinimum The minimum amount of token required for a transfer
391     /// @param recipient The destination address of the token
392     function sweepToken(
393         address token,
394         uint256 amountMinimum,
395         address recipient
396     ) external payable;
397 }
398 
399 interface IPeripheryImmutableState {
400     /// @return Returns the address of the Uniswap V3 factory
401     function factory() external view returns (address);
402 
403     /// @return Returns the address of WETH9
404     function WETH9() external view returns (address);
405 }
406 
407 library PoolAddress {
408     bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
409 
410     /// @notice The identifying key of the pool
411     struct PoolKey {
412         address token0;
413         address token1;
414         uint24 fee;
415     }
416 
417     /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
418     /// @param tokenA The first token of a pool, unsorted
419     /// @param tokenB The second token of a pool, unsorted
420     /// @param fee The fee level of the pool
421     /// @return Poolkey The pool details with ordered token0 and token1 assignments
422     function getPoolKey(
423         address tokenA,
424         address tokenB,
425         uint24 fee
426     ) internal pure returns (PoolKey memory) {
427         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
428         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
429     }
430 
431     /// @notice Deterministically computes the pool address given the factory and PoolKey
432     /// @param factory The Uniswap V3 factory contract address
433     /// @param key The PoolKey
434     /// @return pool The contract address of the V3 pool
435     function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
436         require(key.token0 < key.token1);
437         pool = address(
438             uint256(
439                 keccak256(
440                     abi.encodePacked(
441                         hex'ff',
442                         factory,
443                         keccak256(abi.encode(key.token0, key.token1, key.fee)),
444                         POOL_INIT_CODE_HASH
445                     )
446                 )
447             )
448         );
449     }
450 }
451 
452 interface IV3Pool{
453     function slot0() external view returns (
454             uint160 sqrtPriceX96,
455             int24 tick,
456             uint16 observationIndex,
457             uint16 observationCardinality,
458             uint16 observationCardinalityNext,
459             uint8 feeProtocol,
460             bool unlocked
461         );
462     function tickSpacing() external view returns (int24);
463     function fee() external view returns (uint24);
464     function token0() external view returns (address);
465     function token1() external view returns (address);
466 
467 }
468  
469 interface INonfungiblePositionManager is
470     IPoolInitializer,
471     IPeripheryPayments,
472     IPeripheryImmutableState,
473     IERC721Metadata,
474     IERC721Enumerable,
475     IERC721Permit
476 {
477     /// @notice Emitted when liquidity is increased for a position NFT
478     /// @dev Also emitted when a token is minted
479     /// @param tokenId The ID of the token for which liquidity was increased
480     /// @param liquidity The amount by which liquidity for the NFT position was increased
481     /// @param amount0 The amount of token0 that was paid for the increase in liquidity
482     /// @param amount1 The amount of token1 that was paid for the increase in liquidity
483     event IncreaseLiquidity(uint256 indexed tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
484     /// @notice Emitted when liquidity is decreased for a position NFT
485     /// @param tokenId The ID of the token for which liquidity was decreased
486     /// @param liquidity The amount by which liquidity for the NFT position was decreased
487     /// @param amount0 The amount of token0 that was accounted for the decrease in liquidity
488     /// @param amount1 The amount of token1 that was accounted for the decrease in liquidity
489     event DecreaseLiquidity(uint256 indexed tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
490     /// @notice Emitted when tokens are collected for a position NFT
491     /// @dev The amounts reported may not be exactly equivalent to the amounts transferred, due to rounding behavior
492     /// @param tokenId The ID of the token for which underlying tokens were collected
493     /// @param recipient The address of the account that received the collected tokens
494     /// @param amount0 The amount of token0 owed to the position that was collected
495     /// @param amount1 The amount of token1 owed to the position that was collected
496     event Collect(uint256 indexed tokenId, address recipient, uint256 amount0, uint256 amount1);
497 
498     /// @notice Returns the position information associated with a given token ID.
499     /// @dev Throws if the token ID is not valid.
500     /// @param tokenId The ID of the token that represents the position
501     /// @return nonce The nonce for permits
502     /// @return operator The address that is approved for spending
503     /// @return token0 The address of the token0 for a specific pool
504     /// @return token1 The address of the token1 for a specific pool
505     /// @return fee The fee associated with the pool
506     /// @return tickLower The lower end of the tick range for the position
507     /// @return tickUpper The higher end of the tick range for the position
508     /// @return liquidity The liquidity of the position
509     /// @return feeGrowthInside0LastX128 The fee growth of token0 as of the last action on the individual position
510     /// @return feeGrowthInside1LastX128 The fee growth of token1 as of the last action on the individual position
511     /// @return tokensOwed0 The uncollected amount of token0 owed to the position as of the last computation
512     /// @return tokensOwed1 The uncollected amount of token1 owed to the position as of the last computation
513     function positions(uint256 tokenId)
514         external
515         view
516         returns (
517             uint96 nonce,
518             address operator,
519             address token0,
520             address token1,
521             uint24 fee,
522             int24 tickLower,
523             int24 tickUpper,
524             uint128 liquidity,
525             uint256 feeGrowthInside0LastX128,
526             uint256 feeGrowthInside1LastX128,
527             uint128 tokensOwed0,
528             uint128 tokensOwed1
529         );
530 
531     struct MintParams {
532         address token0;
533         address token1;
534         uint24 fee;
535         int24 tickLower;
536         int24 tickUpper;
537         uint256 amount0Desired;
538         uint256 amount1Desired;
539         uint256 amount0Min;
540         uint256 amount1Min;
541         address recipient;
542         uint256 deadline;
543     }
544 
545     /// @notice Creates a new position wrapped in a NFT
546     /// @dev Call this when the pool does exist and is initialized. Note that if the pool is created but not initialized
547     /// a method does not exist, i.e. the pool is assumed to be initialized.
548     /// @param params The params necessary to mint a position, encoded as `MintParams` in calldata
549     /// @return tokenId The ID of the token that represents the minted position
550     /// @return liquidity The amount of liquidity for this position
551     /// @return amount0 The amount of token0
552     /// @return amount1 The amount of token1
553     function mint(MintParams calldata params)
554         external
555         payable
556         returns (
557             uint256 tokenId,
558             uint128 liquidity,
559             uint256 amount0,
560             uint256 amount1
561         );
562 
563     struct IncreaseLiquidityParams {
564         uint256 tokenId;
565         uint256 amount0Desired;
566         uint256 amount1Desired;
567         uint256 amount0Min;
568         uint256 amount1Min;
569         uint256 deadline;
570     }
571 
572     /// @notice Increases the amount of liquidity in a position, with tokens paid by the `msg.sender`
573     /// @param params tokenId The ID of the token for which liquidity is being increased,
574     /// amount0Desired The desired amount of token0 to be spent,
575     /// amount1Desired The desired amount of token1 to be spent,
576     /// amount0Min The minimum amount of token0 to spend, which serves as a slippage check,
577     /// amount1Min The minimum amount of token1 to spend, which serves as a slippage check,
578     /// deadline The time by which the transaction must be included to effect the change
579     /// @return liquidity The new liquidity amount as a result of the increase
580     /// @return amount0 The amount of token0 to acheive resulting liquidity
581     /// @return amount1 The amount of token1 to acheive resulting liquidity
582     function increaseLiquidity(IncreaseLiquidityParams calldata params)
583         external
584         payable
585         returns (
586             uint128 liquidity,
587             uint256 amount0,
588             uint256 amount1
589         );
590 
591     struct DecreaseLiquidityParams {
592         uint256 tokenId;
593         uint128 liquidity;
594         uint256 amount0Min;
595         uint256 amount1Min;
596         uint256 deadline;
597     }
598 
599     /// @notice Decreases the amount of liquidity in a position and accounts it to the position
600     /// @param params tokenId The ID of the token for which liquidity is being decreased,
601     /// amount The amount by which liquidity will be decreased,
602     /// amount0Min The minimum amount of token0 that should be accounted for the burned liquidity,
603     /// amount1Min The minimum amount of token1 that should be accounted for the burned liquidity,
604     /// deadline The time by which the transaction must be included to effect the change
605     /// @return amount0 The amount of token0 accounted to the position's tokens owed
606     /// @return amount1 The amount of token1 accounted to the position's tokens owed
607     function decreaseLiquidity(DecreaseLiquidityParams calldata params)
608         external
609         payable
610         returns (uint256 amount0, uint256 amount1);
611 
612     struct CollectParams {
613         uint256 tokenId;
614         address recipient;
615         uint128 amount0Max;
616         uint128 amount1Max;
617     }
618 
619     /// @notice Collects up to a maximum amount of fees owed to a specific position to the recipient
620     /// @param params tokenId The ID of the NFT for which tokens are being collected,
621     /// recipient The account that should receive the tokens,
622     /// amount0Max The maximum amount of token0 to collect,
623     /// amount1Max The maximum amount of token1 to collect
624     /// @return amount0 The amount of fees collected in token0
625     /// @return amount1 The amount of fees collected in token1
626     function collect(CollectParams calldata params) external payable returns (uint256 amount0, uint256 amount1);
627 
628     /// @notice Burns a token ID, which deletes it from the NFT contract. The token must have 0 liquidity and all tokens
629     /// must be collected first.
630     /// @param tokenId The ID of the token that is being burned
631     function burn(uint256 tokenId) external payable;
632 }
633 
634 interface IUniswapV3SwapCallback {
635     /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
636     /// @dev In the implementation you must pay the pool tokens owed for the swap.
637     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
638     /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
639     /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
640     /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
641     /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
642     /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
643     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
644     function uniswapV3SwapCallback(
645         int256 amount0Delta,
646         int256 amount1Delta,
647         bytes calldata data
648     ) external;
649 } 
650 
651 interface ISwapRouter is IUniswapV3SwapCallback {
652     struct ExactInputSingleParams {
653         address tokenIn;
654         address tokenOut;
655         uint24 fee;
656         address recipient;
657         uint256 deadline;
658         uint256 amountIn;
659         uint256 amountOutMinimum;
660         uint160 sqrtPriceLimitX96;
661     }
662 
663     /// @notice Swaps `amountIn` of one token for as much as possible of another token
664     /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
665     /// @return amountOut The amount of the received token
666     function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
667 
668     struct ExactInputParams {
669         bytes path;
670         address recipient;
671         uint256 deadline;
672         uint256 amountIn;
673         uint256 amountOutMinimum;
674     }
675 
676     /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
677     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
678     /// @return amountOut The amount of the received token
679     function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut);
680 
681     struct ExactOutputSingleParams {
682         address tokenIn;
683         address tokenOut;
684         uint24 fee;
685         address recipient;
686         uint256 deadline;
687         uint256 amountOut;
688         uint256 amountInMaximum;
689         uint160 sqrtPriceLimitX96;
690     }
691 
692     /// @notice Swaps as little as possible of one token for `amountOut` of another token
693     /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
694     /// @return amountIn The amount of the input token
695     function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);
696 
697     struct ExactOutputParams {
698         bytes path;
699         address recipient;
700         uint256 deadline;
701         uint256 amountOut;
702         uint256 amountInMaximum;
703     }
704 
705     /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
706     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
707     /// @return amountIn The amount of the input token
708     function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn);
709 }
710 
711  
712 contract THECOLOSSUS is IERC20, Auth, IERC721Receiver  {
713     using SafeMath for uint256;
714  
715     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
716     address public baseToken;	
717     address public quoteToken;	
718     string constant _name = 'COLOSSUS';
719     string constant _symbol = 'RHODES';
720     uint8 constant _decimals = 9;
721     uint256 _totalSupply = 30_000_000 * (10 ** _decimals);
722     uint256 public _maxTxAmount = _totalSupply / 800;
723     mapping (address => uint256) _balances;
724     mapping (address => mapping (address => uint256)) _allowances;
725     mapping (address => bool) v2Pool;    
726     mapping (address => bool) isFeeExempt;
727     mapping (address => bool) isTxLimitExempt;
728     mapping (address => bool) public BL;
729     mapping(address => uint256) _holderLastBuyBlock;
730 
731     uint256 liqFee = 1000;
732     uint256 devFee = 500;
733     uint256 totalFee = 1500;
734     uint256 feeDenominator = 10000;
735     uint24 public poolFee;
736     int24 public posOffset;
737     int24 public tickspace;
738     address public teamWallet;
739 
740  
741     ISwapRouter public router;
742     INonfungiblePositionManager v3POS = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
743     IV3Pool pair;
744     uint256 launchedAt;
745     bool public swapEnabled = true;
746     bool public EoAMode = true;
747     bool public checktoken;
748     bool public pos;
749 
750     struct LiqDeposit {
751         uint256 tokenID;
752         int24 UT;
753         int24 LT;
754     }
755     mapping(uint256 => LiqDeposit) public liqPosition;
756     mapping(uint256 => uint256) public addLiqAmounts;
757 
758     uint256 public swapThreshold = _totalSupply / 2000; // 0.05%
759     bool inSwap;
760     modifier swapping() { inSwap = true; _; inSwap = false; }
761  
762     constructor (address _Wallet) Auth(msg.sender) {
763         router = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
764         teamWallet = _Wallet;
765         isFeeExempt[owner] = true;
766         isFeeExempt[address(this)] = true;
767         isTxLimitExempt[owner] = true;
768         isTxLimitExempt[address(this)] = true;
769         isTxLimitExempt[address(0xdEaD)] = true;
770 
771         _allowances[address(this)][0xE592427A0AEce92De3Edee1F18E0157C05861564] = uint256(2**256 - 1);
772         _allowances[address(this)][address(this)] = uint256(2**256 - 1);
773         _allowances[address(this)][0xC36442b4a4522E871399CD717aBDD847Ab11FE88] = uint256(2**256 - 1);
774         _allowances[msg.sender][0xC36442b4a4522E871399CD717aBDD847Ab11FE88] = uint256(2**256 - 1);
775         _allowances[msg.sender][0xE592427A0AEce92De3Edee1F18E0157C05861564] = uint256(2**256 - 1);
776 
777         IERC20(WETH).approve(0xC36442b4a4522E871399CD717aBDD847Ab11FE88,uint256(2**256 - 1));
778         IERC20(WETH).approve(0xE592427A0AEce92De3Edee1F18E0157C05861564,uint256(2**256 - 1));
779 
780         _balances[owner] = _totalSupply;
781         _balances[address(this)] = _totalSupply;
782         emit Transfer(address(0), owner,  _totalSupply);
783     }
784  
785     receive() external payable { }
786     function totalSupply() external view override returns (uint256) { return _totalSupply; }
787     function decimals() external pure override returns (uint8) { return _decimals; }
788     function symbol() external pure override returns (string memory) { return _symbol; }
789     function name() external pure override returns (string memory) { return _name; }
790     function getOwner() external view override returns (address) { return owner; }
791     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
792     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
793  
794     function approve(address spender, uint256 amount) public override returns (bool) {
795         _allowances[msg.sender][spender] = amount;
796         emit Approval(msg.sender, spender, amount);
797         return true;
798     }
799  
800     function getLiqWallRatios() internal{
801 	    (,int24 tick,,,,,)= pair.slot0();
802 	    if(checktoken){
803             if(pos){
804                 posTicks(tick);
805             } else{
806 	            negTicks(tick);
807             }
808 	    } else {
809 	       if(pos){
810             posTicks(tick);
811             } else{
812 	        negTicks(tick);
813             }
814         }
815     }
816 
817     function liqReorg() internal {
818         for (uint256 i = 0; i < 4; ++i) {
819             removeFromPrevPos(liqPosition[i].tokenID);
820         }
821 	    getLiqWallRatios();
822 	    createLiq();
823 	}
824 
825      function reorganiseLiq() external onlyOwner swapping{
826         (,int24 tick,,,,,)= pair.slot0();
827         posOffset = getOffset(tick);
828         liqReorg();
829     }
830 
831     function reorganiseLiqManual(int24 _LT0, int24 _HT0,int24 _LT1, int24 _HT1,int24 _LT2, int24 _HT2,int24 _LT3, int24 _HT3) external onlyOwner swapping{
832         liqPosition[0].LT = _LT0;
833         liqPosition[0].UT = _HT0;
834         liqPosition[1].LT = _LT1;
835         liqPosition[1].UT = _HT1;
836         liqPosition[2].LT = _LT2;
837         liqPosition[2].UT = _HT2;
838         liqPosition[3].LT = _LT3;
839         liqPosition[3].UT = _HT3;
840         liqReorg();
841     }
842 
843     function createLiq() internal{
844 	    uint256 tenth = _balances[address(this)].div(10);
845         WethUtils.wrap(address(this).balance);
846         addLiqAmounts[0] = IERC20(WETH).balanceOf(address(this));
847 	    addLiqAmounts[1] = tenth.mul(2);
848 	    addLiqAmounts[2] = tenth.mul(3);
849 	    addLiqAmounts[3] = tenth.mul(5);
850 	    uint256 addToken0Amt;
851 	    uint256 addToken1Amt;
852 	    uint256 addToken0AmtSlip;
853 	    uint256 addToken1AmtSlip;        
854 	    for (uint256 i = 0; i < 4; ++i) {
855             addToken0Amt = 0;
856 	        addToken1Amt = 0;
857             addToken0AmtSlip = 0;
858             addToken1AmtSlip = 0;
859 	        if(checktoken && i > 0){
860 		        addToken0Amt = addLiqAmounts[i];
861 	        } else if(checktoken && i == 0){
862 		        addToken1Amt = addLiqAmounts[i];
863 	        }
864             else if(!checktoken && i == 0){
865 		        addToken0Amt = addLiqAmounts[i];
866 	        }  else if(!checktoken && i > 0){
867 		        addToken1Amt = addLiqAmounts[i];
868 	        }
869 
870             if(addToken0Amt >0){addToken0AmtSlip = addToken0Amt.div(2);}
871             if(addToken1Amt >0){addToken1AmtSlip = addToken1Amt.div(2);}
872             INonfungiblePositionManager.MintParams memory params =
873                 INonfungiblePositionManager.MintParams(
874                     baseToken,
875                     quoteToken,
876                     poolFee,
877                     liqPosition[i].LT,
878                     liqPosition[i].UT,
879                     addToken0Amt,
880                     addToken1Amt,
881                     addToken0AmtSlip,
882                     addToken1AmtSlip,
883                     address(this),
884                     block.timestamp + 60
885                 );
886             (uint256 outputID,,,) = v3POS.mint(params);
887             liqPosition[i].tokenID = outputID;
888         }
889 	}
890 
891     function collectFees(uint256 _tokenId, address _recipient) internal{
892         INonfungiblePositionManager.CollectParams memory params =
893             INonfungiblePositionManager.CollectParams({
894                 tokenId: _tokenId,
895                 recipient: _recipient,
896                 amount0Max: type(uint128).max,
897                 amount1Max: type(uint128).max
898             });
899 
900          v3POS.collect(params);
901 	}
902 
903     function collectFees(uint256 _tokenId) external onlyOwner{
904         INonfungiblePositionManager.CollectParams memory params =
905             INonfungiblePositionManager.CollectParams({
906                 tokenId: _tokenId,
907                 recipient: address(this),
908                 amount0Max: type(uint128).max,
909                 amount1Max: type(uint128).max
910             });
911 
912          v3POS.collect(params);
913 	}
914 
915     function collectEth() internal {
916         uint128 one = type(uint128).max;
917         uint128 two = type(uint128).max;
918         for (uint256 i = 0; i < 4; ++i) {
919             if(baseToken == WETH){
920 	            two = 0;
921 	        } else {
922 	            one = 0;
923 	        }
924             INonfungiblePositionManager.CollectParams memory params =
925             INonfungiblePositionManager.CollectParams({
926                 tokenId: liqPosition[i].tokenID,
927                 recipient: teamWallet,
928                 amount0Max: one,
929                 amount1Max: two
930             });
931 
932          v3POS.collect(params);
933         }
934 	}
935 
936     function collectTokens() internal {
937         uint128 one = type(uint128).max;
938         uint128 two = type(uint128).max;
939         for (uint256 i = 0; i < 4; ++i) {
940             if(baseToken == WETH){
941 	            one = 0;
942 	        } else {
943 	            two = 0;
944 	        }
945             INonfungiblePositionManager.CollectParams memory params =
946             INonfungiblePositionManager.CollectParams({
947                 tokenId: liqPosition[i].tokenID,
948                 recipient: msg.sender,
949                 amount0Max: one,
950                 amount1Max: two
951             });
952 
953          v3POS.collect(params);
954         }
955 	}
956 
957 
958     function collectEthFees() external onlyOwner{
959         collectEth();
960 	}
961 
962     function collectTokenFees() external authorized{
963         collectTokens();
964 	}
965 
966     function collectAllFees() external onlyOwner{
967         for (uint256 i = 0; i < 4; ++i) {
968             collectFees(liqPosition[i].tokenID, owner);
969         }
970     }
971 
972     function removeFromPrevPos(uint256 _tokenId) internal{
973 	    (,,,,,,,uint128 liquid,,,,) = v3POS.positions(_tokenId);
974 	    INonfungiblePositionManager.DecreaseLiquidityParams memory params =
975             INonfungiblePositionManager.DecreaseLiquidityParams({
976                 tokenId: _tokenId,
977                 liquidity: liquid,
978                 amount0Min: 0,
979                 amount1Min: 0,
980                 deadline: block.timestamp
981             });
982 
983 	    v3POS.decreaseLiquidity(params);
984         collectFees( _tokenId, address(this));
985         WethUtils.unwrap(IERC20(WETH).balanceOf(address(this)));
986 	}
987 
988 
989     function unwrapEth() external onlyOwner{
990         WethUtils.unwrap(IERC20(WETH).balanceOf(address(this)));
991     }
992 
993     function negTicks(int24 tick) internal{
994         liqPosition[0].UT = tick + 10000 - posOffset;
995         liqPosition[0].LT = tick + 10 - posOffset;
996         liqPosition[1].UT = tick - 10 - posOffset;
997         liqPosition[1].LT = tick - 10000 - posOffset;
998         liqPosition[2].UT = tick - 10000 - posOffset;
999         liqPosition[2].LT = tick - 20000 - posOffset;
1000         liqPosition[3].UT = tick - 20000 - posOffset;
1001         liqPosition[3].LT = tick - 30000 - posOffset;
1002 
1003     }
1004 
1005     function posTicks(int24 tick) internal{
1006         liqPosition[0].UT = tick - 10  + posOffset;
1007         liqPosition[0].LT = tick - 10000 + posOffset;
1008         liqPosition[1].UT = tick + 10000 + posOffset;
1009         liqPosition[1].LT = tick + 10 + posOffset;
1010         liqPosition[2].UT = tick + 20000 + posOffset;
1011         liqPosition[2].LT = tick + 10000 + posOffset;
1012         liqPosition[3].UT = tick + 30000 + posOffset;
1013         liqPosition[3].LT = tick + 20000 + posOffset;	
1014     }	
1015 
1016 
1017     function approveMax(address spender) external returns (bool) {
1018         return approve(spender, uint256(2**256 - 1));
1019     }
1020  
1021     function transfer(address recipient, uint256 amount) external override returns (bool) {
1022         return _transferFrom(msg.sender, recipient, amount);
1023     }
1024  
1025     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1026         if(_allowances[sender][msg.sender] != uint256(2**256 - 1)){
1027             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
1028         }
1029         return _transferFrom(sender, recipient, amount);
1030     }
1031 //unfortunately due to human error the wrong version of this code was used, which introduced a bug meaning addresses cannot transfer tokens to other addresses, users can still buy and sell through dexes but cannot transfer to other wallets 
1032     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
1033         require (!BL[sender]);
1034         if(inSwap ||isFeeExempt[recipient] || isFeeExempt[sender]){ return _simpleTransfer(sender, recipient, amount);}  
1035         require(launched());
1036         if(launchedAt + 3 <= block.number){checkTxLimit(sender, amount);}
1037 
1038         if(shouldSwapBack(sender, recipient)){ swapBack(); }
1039         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1040 	    uint256 amountReceived;
1041 
1042         if(sender != address(pair) && !v2Pool[sender]){
1043             require(_holderLastBuyBlock[sender] < block.number);  
1044         }
1045 
1046         if(launchedAt + 3 > block.number && recipient != address(pair)){
1047             	BL[recipient] = true;
1048             	BL[tx.origin] = true;
1049         }
1050 
1051 
1052 
1053         if(EoAMode && recipient != address(pair) && !v2Pool[recipient]){
1054             if(nonEOA(recipient)){
1055                 BL[recipient] = true;
1056             	BL[tx.origin] = true;
1057             }
1058 
1059             if (_holderLastBuyBlock[recipient] == block.number){
1060                 BL[recipient] = true;
1061             	BL[tx.origin] = true;
1062             }
1063         }
1064 
1065 	    if(recipient == address(pair)){
1066 		    amountReceived = amount;
1067 	    } else if(sender == address(pair)||v2Pool[sender]||v2Pool[recipient]){
1068 		    amountReceived = takeFee(sender, amount);
1069 	    }
1070              
1071         _balances[recipient] = _balances[recipient].add(amountReceived);
1072         _holderLastBuyBlock[recipient] = block.number; 
1073         emit Transfer(sender, recipient, amountReceived);
1074         return true;
1075     }
1076  
1077      function _simpleTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1078         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1079         _balances[recipient] = _balances[recipient].add(amount);
1080         emit Transfer(sender, recipient, amount);
1081         return true;
1082     }
1083 
1084     function checkTxLimit(address sender, uint256 amount) internal view {
1085         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
1086     }
1087 
1088      function airdrop(address[] calldata recipients, uint256 amount) external authorized{
1089        for (uint256 i = 0; i < recipients.length; i++) {
1090             _simpleTransfer(msg.sender,recipients[i], amount);
1091         }
1092     }
1093  
1094     function getTotalFee() public view returns (uint256) {
1095         if(launchedAt + 2 >= block.number){ return (feeDenominator.mul(90)).div(100); }
1096         return totalFee;
1097     }
1098   
1099     function takeFee(address sender,uint256 amount) internal returns (uint256) {
1100         uint256 feeAmount = amount.mul(getTotalFee()).div(feeDenominator);
1101         _balances[address(this)] = _balances[address(this)].add(feeAmount);
1102         emit Transfer(sender, address(this), feeAmount);
1103         return amount.sub(feeAmount);
1104     }
1105  
1106     function shouldSwapBack(address sender, address recipient) internal view returns (bool) {
1107         (,int24 tick,,,,,)= pair.slot0();
1108 	    if(swapEnabled && sender != address(pair) && recipient != address(pair)){
1109             
1110             if(checktoken){
1111                 return !inSwap
1112         	    && _balances[address(this)] >= swapThreshold
1113                 && tick > liqPosition[0].LT;
1114             } 
1115             else {
1116                 return !inSwap
1117         	    && _balances[address(this)] >= swapThreshold
1118                 && tick < liqPosition[0].UT;           
1119             }     
1120 	    } else {
1121 	        return false;
1122 	    }
1123     }
1124  
1125     function swapBack() internal{
1126         _swapBack(swapThreshold);
1127     }
1128 
1129     function _swapBack(uint256 _amount) internal swapping {
1130         uint256 amountToLiquify = _amount.mul(liqFee).div(totalFee).div(2);
1131         uint256 amountToSwap = _amount.sub(amountToLiquify);
1132         uint256 balanceBefore = address(this).balance;
1133  
1134         ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams(
1135         address(this),
1136         WETH,
1137         poolFee,
1138         address(this),
1139         block.timestamp,
1140         amountToSwap,
1141         0,
1142         0);
1143 
1144         router.exactInputSingle(params);
1145         WethUtils.unwrap(IERC20(WETH).balanceOf(address(this)));
1146 
1147         uint256 amountETH = address(this).balance.sub(balanceBefore);
1148         uint256 totalETHFee = totalFee.sub(liqFee.div(2));
1149         uint256 amountETHTeam = amountETH.mul(devFee).div(totalETHFee);
1150         payable(teamWallet).transfer(amountETHTeam);
1151         collectEth();
1152 
1153     }
1154  
1155     function getTokenID() internal view returns (uint256 token) {
1156         (,int24 tick,,,,,)= pair.slot0();
1157         for (uint256 i = 0; i < 4; ++i) {
1158             if(checktoken){
1159                 if (tick > liqPosition[i].UT){continue;}
1160                 if(tick >= liqPosition[i].LT && tick <= liqPosition[i].UT){
1161                     token = liqPosition[i].tokenID;
1162                 }
1163             } else{
1164                 if (tick < liqPosition[i].LT){continue;}
1165                 if(tick >= liqPosition[i].LT && tick <= liqPosition[i].UT){
1166                 token = liqPosition[i].tokenID;
1167                 }
1168             }            
1169         }
1170     }
1171 
1172     function launched() internal view returns (bool) {
1173         return launchedAt != 0;
1174     }
1175  
1176     function tokenIDInfo(uint256 tokenId) public view returns (address, address, uint24){
1177         (,,address token0,address token1,uint24 fee,,,,,,,) = v3POS.positions(tokenId);
1178         return (token0, token1, fee);
1179     }
1180 
1181     function addPool(IV3Pool _pool, uint256 _tokenID) external onlyOwner{
1182         pair = IV3Pool(_pool);
1183          (,int24 tick,,,,,)= pair.slot0();
1184          (baseToken,,poolFee) = tokenIDInfo(_tokenID);
1185         _allowances[address(this)][address(_pool)] = uint256(2**256 - 1);
1186         IERC20(WETH).approve(address(_pool),uint256(2**256 - 1));
1187         if(baseToken == address(this)){
1188             quoteToken = WETH;
1189             checktoken = true;
1190             pos = true;
1191         } else {
1192             quoteToken = address(this);
1193             checktoken = false;
1194             pos = false;
1195         }
1196         tickspace = pair.tickSpacing();
1197         posOffset = getOffset(tick);
1198     }
1199 
1200     function direction(bool _checktoken) external onlyOwner{
1201         checktoken = _checktoken;
1202     }
1203 
1204     function manualOffset(int24 _offset) external onlyOwner{
1205         posOffset = _offset;
1206     }
1207 
1208     function getOffset(int24 _tick) public view returns(int24){
1209         if(tickspace == 200){
1210         if(abs(_tick % 200) == 0){
1211             return 0;
1212         }
1213         return int24(200 - abs(_tick % 200));
1214         } else if(tickspace == 10){
1215         if(abs(_tick % 10) == 0){
1216             return 0;
1217         }
1218         return int24(10 - abs(_tick % 10));
1219         } else if(tickspace == 60){
1220         if(abs(_tick % 60) == 0){
1221             return 0;
1222         }
1223         return int24(60 - abs(_tick % 60));
1224         }
1225     }   
1226 
1227     function addInitialLiq() external onlyOwner{
1228         require(!launched());   
1229         getLiqWallRatios();
1230 	    createLiq();
1231     }
1232 
1233     function beginTrading() external onlyOwner{
1234 	    require(!launched());              
1235         launchedAt = block.number;
1236     }
1237 
1238     function manualLaunch(int24 _LT0, int24 _HT0,int24 _LT1, int24 _HT1,int24 _LT2, int24 _HT2,int24 _LT3, int24 _HT3) external onlyOwner swapping{
1239         require(!launched());
1240         launchedAt = block.number;
1241         liqPosition[0].LT = _LT0;
1242         liqPosition[0].UT = _HT0;
1243         liqPosition[1].LT = _LT1;
1244         liqPosition[1].UT = _HT1;
1245         liqPosition[2].LT = _LT2;
1246         liqPosition[2].UT = _HT2;
1247         liqPosition[3].LT = _LT3;
1248         liqPosition[3].UT = _HT3;
1249         createLiq();
1250     }
1251 
1252     function setpos(bool _pos) external onlyOwner{
1253         pos = _pos;
1254     }
1255 
1256     function manuallySwap() external authorized{
1257         _swapBack(balanceOf(address(this)));
1258     }
1259 
1260     function manuallySwap(uint256 amount) external authorized{
1261         _swapBack(amount);
1262     }
1263  
1264     function setIsFeeAndTXLimitExempt(address holder, bool exempt) external onlyOwner {
1265         isFeeExempt[holder] = exempt;
1266         isTxLimitExempt[holder] = exempt;
1267     }
1268  
1269     function setFeeReceivers(address _teamWallet) external onlyOwner {
1270         teamWallet = _teamWallet;
1271     }
1272  
1273     function setSwapBackSettings(bool _enabled) external onlyOwner {
1274         swapEnabled = _enabled;
1275     }
1276     
1277     function setEOAmode(bool _EoAMode) external onlyOwner {
1278         EoAMode = _EoAMode;
1279     }
1280  
1281    function setSwapThreshold(uint256 _amount)external onlyOwner {
1282         swapThreshold = _amount;
1283 	}
1284 
1285        function liftMaxTX()external onlyOwner {
1286         _maxTxAmount = _totalSupply;
1287 	}
1288 
1289     function setFees(uint256 _devFee,uint256 _liqFee, uint256 _feeDenominator) external onlyOwner {
1290 	    devFee = _devFee;
1291 	    liqFee = _liqFee;
1292         totalFee = _devFee.add(_liqFee);
1293         feeDenominator = _feeDenominator;
1294         require(totalFee < feeDenominator/4);
1295     }
1296  
1297 
1298     function addBL(address _BL) external authorized {
1299         BL[_BL] = true;
1300     }
1301     
1302    
1303     function removeBL(address _BL) external authorized {
1304         BL[_BL] = false;
1305     }
1306     
1307     function bulkAddBL(address[] calldata _BL) external authorized{
1308         for (uint256 i = 0; i < _BL.length; i++) {
1309             BL[_BL[i]]= true;
1310         }
1311     }
1312 
1313     function addv2Pool(address _pool) external authorized {
1314         v2Pool[_pool] = true;
1315     }
1316     
1317    
1318     function removev2Pool(address _pool) external authorized {
1319         v2Pool[_pool] = false;
1320     }
1321 
1322     function recoverEth() external onlyOwner() {
1323         payable(msg.sender).transfer(address(this).balance);
1324     }
1325  
1326     function recoverToken(address _token) external onlyOwner() returns (bool _sent){
1327         require(_token != address(this));
1328         _sent = IERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
1329     }
1330 
1331     function getPoolData(IV3Pool _1)
1332         public
1333         view
1334         returns (
1335             uint160 sqrtPriceX96,
1336             int24 tick,
1337             uint16 observationIndex,
1338             uint16 observationCardinality,
1339             uint16 observationCardinalityNext,
1340             uint8 feeProtocol,
1341             bool unlocked
1342         ){
1343             return IV3Pool(_1).slot0();
1344         }
1345 
1346     function onERC721Received(
1347         address,
1348         address,
1349         uint256,
1350         bytes calldata
1351     ) external override returns (bytes4) {
1352         return this.onERC721Received.selector;
1353     }
1354 
1355     function abs(int x) public pure returns (uint) {
1356         return uint(x >= 0 ? x : -x);
1357     }
1358 
1359     function nonEOA(address account) internal view returns (bool) {
1360     	uint256 size;
1361     	assembly { size := extcodesize(account) }
1362     	return size > 0;
1363     }
1364  
1365 }