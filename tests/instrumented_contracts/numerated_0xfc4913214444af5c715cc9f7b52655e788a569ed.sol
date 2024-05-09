1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.15;
4 
5 /* Icosa is a collection of Ethereum / PulseChain smart contracts that  *
6  * build upon the Hedron smart contract to provide additional functionality */
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 /**
109  * @dev Provides information about the current execution context, including the
110  * sender of the transaction and its data. While these are generally available
111  * via msg.sender and msg.data, they should not be accessed in such a direct
112  * manner, since when dealing with meta-transactions the account sending and
113  * paying for execution may not be the actual sender (as far as an application
114  * is concerned).
115  *
116  * This contract is only required for intermediate, library-like contracts.
117  */
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 
123     function _msgData() internal view virtual returns (bytes calldata) {
124         return msg.data;
125     }
126 }
127 
128 /**
129  * @dev Implementation of the {IERC20} interface.
130  *
131  * This implementation is agnostic to the way tokens are created. This means
132  * that a supply mechanism has to be added in a derived contract using {_mint}.
133  * For a generic mechanism see {ERC20PresetMinterPauser}.
134  *
135  * TIP: For a detailed writeup see our guide
136  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
137  * to implement supply mechanisms].
138  *
139  * We have followed general OpenZeppelin Contracts guidelines: functions revert
140  * instead returning `false` on failure. This behavior is nonetheless
141  * conventional and does not conflict with the expectations of ERC20
142  * applications.
143  *
144  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
145  * This allows applications to reconstruct the allowance for all accounts just
146  * by listening to said events. Other implementations of the EIP may not emit
147  * these events, as it isn't required by the specification.
148  *
149  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
150  * functions have been added to mitigate the well-known issues around setting
151  * allowances. See {IERC20-approve}.
152  */
153 contract ERC20 is Context, IERC20, IERC20Metadata {
154     mapping(address => uint256) private _balances;
155 
156     mapping(address => mapping(address => uint256)) private _allowances;
157 
158     uint256 private _totalSupply;
159 
160     string private _name;
161     string private _symbol;
162 
163     /**
164      * @dev Sets the values for {name} and {symbol}.
165      *
166      * The default value of {decimals} is 18. To select a different value for
167      * {decimals} you should overload it.
168      *
169      * All two of these values are immutable: they can only be set once during
170      * construction.
171      */
172     constructor(string memory name_, string memory symbol_) {
173         _name = name_;
174         _symbol = symbol_;
175     }
176 
177     /**
178      * @dev Returns the name of the token.
179      */
180     function name() public view virtual override returns (string memory) {
181         return _name;
182     }
183 
184     /**
185      * @dev Returns the symbol of the token, usually a shorter version of the
186      * name.
187      */
188     function symbol() public view virtual override returns (string memory) {
189         return _symbol;
190     }
191 
192     /**
193      * @dev Returns the number of decimals used to get its user representation.
194      * For example, if `decimals` equals `2`, a balance of `505` tokens should
195      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
196      *
197      * Tokens usually opt for a value of 18, imitating the relationship between
198      * Ether and Wei. This is the value {ERC20} uses, unless this function is
199      * overridden;
200      *
201      * NOTE: This information is only used for _display_ purposes: it in
202      * no way affects any of the arithmetic of the contract, including
203      * {IERC20-balanceOf} and {IERC20-transfer}.
204      */
205     function decimals() public view virtual override returns (uint8) {
206         return 18;
207     }
208 
209     /**
210      * @dev See {IERC20-totalSupply}.
211      */
212     function totalSupply() public view virtual override returns (uint256) {
213         return _totalSupply;
214     }
215 
216     /**
217      * @dev See {IERC20-balanceOf}.
218      */
219     function balanceOf(address account) public view virtual override returns (uint256) {
220         return _balances[account];
221     }
222 
223     /**
224      * @dev See {IERC20-transfer}.
225      *
226      * Requirements:
227      *
228      * - `to` cannot be the zero address.
229      * - the caller must have a balance of at least `amount`.
230      */
231     function transfer(address to, uint256 amount) public virtual override returns (bool) {
232         address owner = _msgSender();
233         _transfer(owner, to, amount);
234         return true;
235     }
236 
237     /**
238      * @dev See {IERC20-allowance}.
239      */
240     function allowance(address owner, address spender) public view virtual override returns (uint256) {
241         return _allowances[owner][spender];
242     }
243 
244     /**
245      * @dev See {IERC20-approve}.
246      *
247      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
248      * `transferFrom`. This is semantically equivalent to an infinite approval.
249      *
250      * Requirements:
251      *
252      * - `spender` cannot be the zero address.
253      */
254     function approve(address spender, uint256 amount) public virtual override returns (bool) {
255         address owner = _msgSender();
256         _approve(owner, spender, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-transferFrom}.
262      *
263      * Emits an {Approval} event indicating the updated allowance. This is not
264      * required by the EIP. See the note at the beginning of {ERC20}.
265      *
266      * NOTE: Does not update the allowance if the current allowance
267      * is the maximum `uint256`.
268      *
269      * Requirements:
270      *
271      * - `from` and `to` cannot be the zero address.
272      * - `from` must have a balance of at least `amount`.
273      * - the caller must have allowance for ``from``'s tokens of at least
274      * `amount`.
275      */
276     function transferFrom(
277         address from,
278         address to,
279         uint256 amount
280     ) public virtual override returns (bool) {
281         address spender = _msgSender();
282         _spendAllowance(from, spender, amount);
283         _transfer(from, to, amount);
284         return true;
285     }
286 
287     /**
288      * @dev Atomically increases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
300         address owner = _msgSender();
301         _approve(owner, spender, allowance(owner, spender) + addedValue);
302         return true;
303     }
304 
305     /**
306      * @dev Atomically decreases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      * - `spender` must have allowance for the caller of at least
317      * `subtractedValue`.
318      */
319     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
320         address owner = _msgSender();
321         uint256 currentAllowance = allowance(owner, spender);
322         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
323         unchecked {
324             _approve(owner, spender, currentAllowance - subtractedValue);
325         }
326 
327         return true;
328     }
329 
330     /**
331      * @dev Moves `amount` of tokens from `from` to `to`.
332      *
333      * This internal function is equivalent to {transfer}, and can be used to
334      * e.g. implement automatic token fees, slashing mechanisms, etc.
335      *
336      * Emits a {Transfer} event.
337      *
338      * Requirements:
339      *
340      * - `from` cannot be the zero address.
341      * - `to` cannot be the zero address.
342      * - `from` must have a balance of at least `amount`.
343      */
344     function _transfer(
345         address from,
346         address to,
347         uint256 amount
348     ) internal virtual {
349         require(from != address(0), "ERC20: transfer from the zero address");
350         require(to != address(0), "ERC20: transfer to the zero address");
351 
352         _beforeTokenTransfer(from, to, amount);
353 
354         uint256 fromBalance = _balances[from];
355         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
356         unchecked {
357             _balances[from] = fromBalance - amount;
358         }
359         _balances[to] += amount;
360 
361         emit Transfer(from, to, amount);
362 
363         _afterTokenTransfer(from, to, amount);
364     }
365 
366     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
367      * the total supply.
368      *
369      * Emits a {Transfer} event with `from` set to the zero address.
370      *
371      * Requirements:
372      *
373      * - `account` cannot be the zero address.
374      */
375     function _mint(address account, uint256 amount) internal virtual {
376         require(account != address(0), "ERC20: mint to the zero address");
377 
378         _beforeTokenTransfer(address(0), account, amount);
379 
380         _totalSupply += amount;
381         _balances[account] += amount;
382         emit Transfer(address(0), account, amount);
383 
384         _afterTokenTransfer(address(0), account, amount);
385     }
386 
387     /**
388      * @dev Destroys `amount` tokens from `account`, reducing the
389      * total supply.
390      *
391      * Emits a {Transfer} event with `to` set to the zero address.
392      *
393      * Requirements:
394      *
395      * - `account` cannot be the zero address.
396      * - `account` must have at least `amount` tokens.
397      */
398     function _burn(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: burn from the zero address");
400 
401         _beforeTokenTransfer(account, address(0), amount);
402 
403         uint256 accountBalance = _balances[account];
404         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
405         unchecked {
406             _balances[account] = accountBalance - amount;
407         }
408         _totalSupply -= amount;
409 
410         emit Transfer(account, address(0), amount);
411 
412         _afterTokenTransfer(account, address(0), amount);
413     }
414 
415     /**
416      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
417      *
418      * This internal function is equivalent to `approve`, and can be used to
419      * e.g. set automatic allowances for certain subsystems, etc.
420      *
421      * Emits an {Approval} event.
422      *
423      * Requirements:
424      *
425      * - `owner` cannot be the zero address.
426      * - `spender` cannot be the zero address.
427      */
428     function _approve(
429         address owner,
430         address spender,
431         uint256 amount
432     ) internal virtual {
433         require(owner != address(0), "ERC20: approve from the zero address");
434         require(spender != address(0), "ERC20: approve to the zero address");
435 
436         _allowances[owner][spender] = amount;
437         emit Approval(owner, spender, amount);
438     }
439 
440     /**
441      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
442      *
443      * Does not update the allowance amount in case of infinite allowance.
444      * Revert if not enough allowance is available.
445      *
446      * Might emit an {Approval} event.
447      */
448     function _spendAllowance(
449         address owner,
450         address spender,
451         uint256 amount
452     ) internal virtual {
453         uint256 currentAllowance = allowance(owner, spender);
454         if (currentAllowance != type(uint256).max) {
455             require(currentAllowance >= amount, "ERC20: insufficient allowance");
456             unchecked {
457                 _approve(owner, spender, currentAllowance - amount);
458             }
459         }
460     }
461 
462     /**
463      * @dev Hook that is called before any transfer of tokens. This includes
464      * minting and burning.
465      *
466      * Calling conditions:
467      *
468      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
469      * will be transferred to `to`.
470      * - when `from` is zero, `amount` tokens will be minted for `to`.
471      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
472      * - `from` and `to` are never both zero.
473      *
474      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
475      */
476     function _beforeTokenTransfer(
477         address from,
478         address to,
479         uint256 amount
480     ) internal virtual {}
481 
482     /**
483      * @dev Hook that is called after any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * has been transferred to `to`.
490      * - when `from` is zero, `amount` tokens have been minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _afterTokenTransfer(
497         address from,
498         address to,
499         uint256 amount
500     ) internal virtual {}
501 }
502 
503 /**
504  * @dev Contract module that helps prevent reentrant calls to a function.
505  *
506  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
507  * available, which can be applied to functions to make sure there are no nested
508  * (reentrant) calls to them.
509  *
510  * Note that because there is a single `nonReentrant` guard, functions marked as
511  * `nonReentrant` may not call one another. This can be worked around by making
512  * those functions `private`, and then adding `external` `nonReentrant` entry
513  * points to them.
514  *
515  * TIP: If you would like to learn more about reentrancy and alternative ways
516  * to protect against it, check out our blog post
517  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
518  */
519 abstract contract ReentrancyGuard {
520     // Booleans are more expensive than uint256 or any type that takes up a full
521     // word because each write operation emits an extra SLOAD to first read the
522     // slot's contents, replace the bits taken up by the boolean, and then write
523     // back. This is the compiler's defense against contract upgrades and
524     // pointer aliasing, and it cannot be disabled.
525 
526     // The values being non-zero value makes deployment a bit more expensive,
527     // but in exchange the refund on every call to nonReentrant will be lower in
528     // amount. Since refunds are capped to a percentage of the total
529     // transaction's gas, it is best to keep them low in cases like this one, to
530     // increase the likelihood of the full refund coming into effect.
531     uint256 private constant _NOT_ENTERED = 1;
532     uint256 private constant _ENTERED = 2;
533 
534     uint256 private _status;
535 
536     constructor() {
537         _status = _NOT_ENTERED;
538     }
539 
540     /**
541      * @dev Prevents a contract from calling itself, directly or indirectly.
542      * Calling a `nonReentrant` function from another `nonReentrant`
543      * function is not supported. It is possible to prevent this from happening
544      * by making the `nonReentrant` function external, and making it call a
545      * `private` function that does the actual work.
546      */
547     modifier nonReentrant() {
548         // On the first call to nonReentrant, _notEntered will be true
549         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
550 
551         // Any calls to nonReentrant after this point will fail
552         _status = _ENTERED;
553 
554         _;
555 
556         // By storing the original value once again, a refund is triggered (see
557         // https://eips.ethereum.org/EIPS/eip-2200)
558         _status = _NOT_ENTERED;
559     }
560 }
561 
562 /// @title Pool state that never changes
563 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
564 interface IUniswapV3PoolImmutables {
565     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
566     /// @return The contract address
567     function factory() external view returns (address);
568 
569     /// @notice The first of the two tokens of the pool, sorted by address
570     /// @return The token contract address
571     function token0() external view returns (address);
572 
573     /// @notice The second of the two tokens of the pool, sorted by address
574     /// @return The token contract address
575     function token1() external view returns (address);
576 
577     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
578     /// @return The fee
579     function fee() external view returns (uint24);
580 
581     /// @notice The pool tick spacing
582     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
583     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
584     /// This value is an int24 to avoid casting even though it is always positive.
585     /// @return The tick spacing
586     function tickSpacing() external view returns (int24);
587 
588     /// @notice The maximum amount of position liquidity that can use any tick in the range
589     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
590     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
591     /// @return The max amount of liquidity per tick
592     function maxLiquidityPerTick() external view returns (uint128);
593 }
594 
595 /// @title Pool state that can change
596 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
597 /// per transaction
598 interface IUniswapV3PoolState {
599     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
600     /// when accessed externally.
601     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
602     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
603     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
604     /// boundary.
605     /// observationIndex The index of the last oracle observation that was written,
606     /// observationCardinality The current maximum number of observations stored in the pool,
607     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
608     /// feeProtocol The protocol fee for both tokens of the pool.
609     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
610     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
611     /// unlocked Whether the pool is currently locked to reentrancy
612     function slot0()
613         external
614         view
615         returns (
616             uint160 sqrtPriceX96,
617             int24 tick,
618             uint16 observationIndex,
619             uint16 observationCardinality,
620             uint16 observationCardinalityNext,
621             uint8 feeProtocol,
622             bool unlocked
623         );
624 
625     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
626     /// @dev This value can overflow the uint256
627     function feeGrowthGlobal0X128() external view returns (uint256);
628 
629     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
630     /// @dev This value can overflow the uint256
631     function feeGrowthGlobal1X128() external view returns (uint256);
632 
633     /// @notice The amounts of token0 and token1 that are owed to the protocol
634     /// @dev Protocol fees will never exceed uint128 max in either token
635     function protocolFees() external view returns (uint128 token0, uint128 token1);
636 
637     /// @notice The currently in range liquidity available to the pool
638     /// @dev This value has no relationship to the total liquidity across all ticks
639     function liquidity() external view returns (uint128);
640 
641     /// @notice Look up information about a specific tick in the pool
642     /// @param tick The tick to look up
643     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
644     /// tick upper,
645     /// liquidityNet how much liquidity changes when the pool price crosses the tick,
646     /// feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
647     /// feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
648     /// tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
649     /// secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
650     /// secondsOutside the seconds spent on the other side of the tick from the current tick,
651     /// initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
652     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
653     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
654     /// a specific position.
655     function ticks(int24 tick)
656         external
657         view
658         returns (
659             uint128 liquidityGross,
660             int128 liquidityNet,
661             uint256 feeGrowthOutside0X128,
662             uint256 feeGrowthOutside1X128,
663             int56 tickCumulativeOutside,
664             uint160 secondsPerLiquidityOutsideX128,
665             uint32 secondsOutside,
666             bool initialized
667         );
668 
669     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
670     function tickBitmap(int16 wordPosition) external view returns (uint256);
671 
672     /// @notice Returns the information about a position by the position's key
673     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
674     /// @return _liquidity The amount of liquidity in the position,
675     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
676     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
677     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
678     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
679     function positions(bytes32 key)
680         external
681         view
682         returns (
683             uint128 _liquidity,
684             uint256 feeGrowthInside0LastX128,
685             uint256 feeGrowthInside1LastX128,
686             uint128 tokensOwed0,
687             uint128 tokensOwed1
688         );
689 
690     /// @notice Returns data about a specific observation index
691     /// @param index The element of the observations array to fetch
692     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
693     /// ago, rather than at a specific index in the array.
694     /// @return blockTimestamp The timestamp of the observation,
695     /// Returns tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
696     /// Returns secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
697     /// Returns initialized whether the observation has been initialized and the values are safe to use
698     function observations(uint256 index)
699         external
700         view
701         returns (
702             uint32 blockTimestamp,
703             int56 tickCumulative,
704             uint160 secondsPerLiquidityCumulativeX128,
705             bool initialized
706         );
707 }
708 
709 /// @title Pool state that is not stored
710 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
711 /// blockchain. The functions here may have variable gas costs.
712 interface IUniswapV3PoolDerivedState {
713     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
714     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
715     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
716     /// you must call it with secondsAgos = [3600, 0].
717     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
718     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
719     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
720     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
721     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
722     /// timestamp
723     function observe(uint32[] calldata secondsAgos)
724         external
725         view
726         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
727 
728     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
729     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
730     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
731     /// snapshot is taken and the second snapshot is taken.
732     /// @param tickLower The lower tick of the range
733     /// @param tickUpper The upper tick of the range
734     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
735     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
736     /// @return secondsInside The snapshot of seconds per liquidity for the range
737     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
738         external
739         view
740         returns (
741             int56 tickCumulativeInside,
742             uint160 secondsPerLiquidityInsideX128,
743             uint32 secondsInside
744         );
745 }
746 
747 /// @title Permissionless pool actions
748 /// @notice Contains pool methods that can be called by anyone
749 interface IUniswapV3PoolActions {
750     /// @notice Sets the initial price for the pool
751     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
752     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
753     function initialize(uint160 sqrtPriceX96) external;
754 
755     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
756     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
757     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
758     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
759     /// @param recipient The address for which the liquidity will be created
760     /// @param tickLower The lower tick of the position in which to add liquidity
761     /// @param tickUpper The upper tick of the position in which to add liquidity
762     /// @param amount The amount of liquidity to mint
763     /// @param data Any data that should be passed through to the callback
764     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
765     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
766     function mint(
767         address recipient,
768         int24 tickLower,
769         int24 tickUpper,
770         uint128 amount,
771         bytes calldata data
772     ) external returns (uint256 amount0, uint256 amount1);
773 
774     /// @notice Collects tokens owed to a position
775     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
776     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
777     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
778     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
779     /// @param recipient The address which should receive the fees collected
780     /// @param tickLower The lower tick of the position for which to collect fees
781     /// @param tickUpper The upper tick of the position for which to collect fees
782     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
783     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
784     /// @return amount0 The amount of fees collected in token0
785     /// @return amount1 The amount of fees collected in token1
786     function collect(
787         address recipient,
788         int24 tickLower,
789         int24 tickUpper,
790         uint128 amount0Requested,
791         uint128 amount1Requested
792     ) external returns (uint128 amount0, uint128 amount1);
793 
794     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
795     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
796     /// @dev Fees must be collected separately via a call to #collect
797     /// @param tickLower The lower tick of the position for which to burn liquidity
798     /// @param tickUpper The upper tick of the position for which to burn liquidity
799     /// @param amount How much liquidity to burn
800     /// @return amount0 The amount of token0 sent to the recipient
801     /// @return amount1 The amount of token1 sent to the recipient
802     function burn(
803         int24 tickLower,
804         int24 tickUpper,
805         uint128 amount
806     ) external returns (uint256 amount0, uint256 amount1);
807 
808     /// @notice Swap token0 for token1, or token1 for token0
809     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
810     /// @param recipient The address to receive the output of the swap
811     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
812     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
813     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
814     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
815     /// @param data Any data to be passed through to the callback
816     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
817     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
818     function swap(
819         address recipient,
820         bool zeroForOne,
821         int256 amountSpecified,
822         uint160 sqrtPriceLimitX96,
823         bytes calldata data
824     ) external returns (int256 amount0, int256 amount1);
825 
826     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
827     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
828     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
829     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
830     /// @param recipient The address which will receive the token0 and token1 amounts
831     /// @param amount0 The amount of token0 to send
832     /// @param amount1 The amount of token1 to send
833     /// @param data Any data to be passed through to the callback
834     function flash(
835         address recipient,
836         uint256 amount0,
837         uint256 amount1,
838         bytes calldata data
839     ) external;
840 
841     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
842     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
843     /// the input observationCardinalityNext.
844     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
845     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
846 }
847 
848 /// @title Permissioned pool actions
849 /// @notice Contains pool methods that may only be called by the factory owner
850 interface IUniswapV3PoolOwnerActions {
851     /// @notice Set the denominator of the protocol's % share of the fees
852     /// @param feeProtocol0 new protocol fee for token0 of the pool
853     /// @param feeProtocol1 new protocol fee for token1 of the pool
854     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
855 
856     /// @notice Collect the protocol fee accrued to the pool
857     /// @param recipient The address to which collected protocol fees should be sent
858     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
859     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
860     /// @return amount0 The protocol fee collected in token0
861     /// @return amount1 The protocol fee collected in token1
862     function collectProtocol(
863         address recipient,
864         uint128 amount0Requested,
865         uint128 amount1Requested
866     ) external returns (uint128 amount0, uint128 amount1);
867 }
868 
869 /// @title Events emitted by a pool
870 /// @notice Contains all events emitted by the pool
871 interface IUniswapV3PoolEvents {
872     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
873     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
874     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
875     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
876     event Initialize(uint160 sqrtPriceX96, int24 tick);
877 
878     /// @notice Emitted when liquidity is minted for a given position
879     /// @param sender The address that minted the liquidity
880     /// @param owner The owner of the position and recipient of any minted liquidity
881     /// @param tickLower The lower tick of the position
882     /// @param tickUpper The upper tick of the position
883     /// @param amount The amount of liquidity minted to the position range
884     /// @param amount0 How much token0 was required for the minted liquidity
885     /// @param amount1 How much token1 was required for the minted liquidity
886     event Mint(
887         address sender,
888         address indexed owner,
889         int24 indexed tickLower,
890         int24 indexed tickUpper,
891         uint128 amount,
892         uint256 amount0,
893         uint256 amount1
894     );
895 
896     /// @notice Emitted when fees are collected by the owner of a position
897     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
898     /// @param owner The owner of the position for which fees are collected
899     /// @param tickLower The lower tick of the position
900     /// @param tickUpper The upper tick of the position
901     /// @param amount0 The amount of token0 fees collected
902     /// @param amount1 The amount of token1 fees collected
903     event Collect(
904         address indexed owner,
905         address recipient,
906         int24 indexed tickLower,
907         int24 indexed tickUpper,
908         uint128 amount0,
909         uint128 amount1
910     );
911 
912     /// @notice Emitted when a position's liquidity is removed
913     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
914     /// @param owner The owner of the position for which liquidity is removed
915     /// @param tickLower The lower tick of the position
916     /// @param tickUpper The upper tick of the position
917     /// @param amount The amount of liquidity to remove
918     /// @param amount0 The amount of token0 withdrawn
919     /// @param amount1 The amount of token1 withdrawn
920     event Burn(
921         address indexed owner,
922         int24 indexed tickLower,
923         int24 indexed tickUpper,
924         uint128 amount,
925         uint256 amount0,
926         uint256 amount1
927     );
928 
929     /// @notice Emitted by the pool for any swaps between token0 and token1
930     /// @param sender The address that initiated the swap call, and that received the callback
931     /// @param recipient The address that received the output of the swap
932     /// @param amount0 The delta of the token0 balance of the pool
933     /// @param amount1 The delta of the token1 balance of the pool
934     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
935     /// @param liquidity The liquidity of the pool after the swap
936     /// @param tick The log base 1.0001 of price of the pool after the swap
937     event Swap(
938         address indexed sender,
939         address indexed recipient,
940         int256 amount0,
941         int256 amount1,
942         uint160 sqrtPriceX96,
943         uint128 liquidity,
944         int24 tick
945     );
946 
947     /// @notice Emitted by the pool for any flashes of token0/token1
948     /// @param sender The address that initiated the swap call, and that received the callback
949     /// @param recipient The address that received the tokens from flash
950     /// @param amount0 The amount of token0 that was flashed
951     /// @param amount1 The amount of token1 that was flashed
952     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
953     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
954     event Flash(
955         address indexed sender,
956         address indexed recipient,
957         uint256 amount0,
958         uint256 amount1,
959         uint256 paid0,
960         uint256 paid1
961     );
962 
963     /// @notice Emitted by the pool for increases to the number of observations that can be stored
964     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
965     /// just before a mint/swap/burn.
966     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
967     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
968     event IncreaseObservationCardinalityNext(
969         uint16 observationCardinalityNextOld,
970         uint16 observationCardinalityNextNew
971     );
972 
973     /// @notice Emitted when the protocol fee is changed by the pool
974     /// @param feeProtocol0Old The previous value of the token0 protocol fee
975     /// @param feeProtocol1Old The previous value of the token1 protocol fee
976     /// @param feeProtocol0New The updated value of the token0 protocol fee
977     /// @param feeProtocol1New The updated value of the token1 protocol fee
978     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
979 
980     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
981     /// @param sender The address that collects the protocol fees
982     /// @param recipient The address that receives the collected protocol fees
983     /// @param amount0 The amount of token0 protocol fees that is withdrawn
984     /// @param amount0 The amount of token1 protocol fees that is withdrawn
985     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
986 }
987 
988 /// @title The interface for a Uniswap V3 Pool
989 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
990 /// to the ERC20 specification
991 /// @dev The pool interface is broken up into many smaller pieces
992 interface IUniswapV3Pool is
993     IUniswapV3PoolImmutables,
994     IUniswapV3PoolState,
995     IUniswapV3PoolDerivedState,
996     IUniswapV3PoolActions,
997     IUniswapV3PoolOwnerActions,
998     IUniswapV3PoolEvents
999 {
1000 
1001 }
1002 
1003 /// @title FixedPoint96
1004 /// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
1005 /// @dev Used in SqrtPriceMath.sol
1006 library FixedPoint96 {
1007     uint8 internal constant RESOLUTION = 96;
1008     uint256 internal constant Q96 = 0x1000000000000000000000000;
1009 }
1010 
1011 interface IHEX {
1012     event Approval(
1013         address indexed owner,
1014         address indexed spender,
1015         uint256 value
1016     );
1017     event Claim(
1018         uint256 data0,
1019         uint256 data1,
1020         bytes20 indexed btcAddr,
1021         address indexed claimToAddr,
1022         address indexed referrerAddr
1023     );
1024     event ClaimAssist(
1025         uint256 data0,
1026         uint256 data1,
1027         uint256 data2,
1028         address indexed senderAddr
1029     );
1030     event DailyDataUpdate(uint256 data0, address indexed updaterAddr);
1031     event ShareRateChange(uint256 data0, uint40 indexed stakeId);
1032     event StakeEnd(
1033         uint256 data0,
1034         uint256 data1,
1035         address indexed stakerAddr,
1036         uint40 indexed stakeId
1037     );
1038     event StakeGoodAccounting(
1039         uint256 data0,
1040         uint256 data1,
1041         address indexed stakerAddr,
1042         uint40 indexed stakeId,
1043         address indexed senderAddr
1044     );
1045     event StakeStart(
1046         uint256 data0,
1047         address indexed stakerAddr,
1048         uint40 indexed stakeId
1049     );
1050     event Transfer(address indexed from, address indexed to, uint256 value);
1051     event XfLobbyEnter(
1052         uint256 data0,
1053         address indexed memberAddr,
1054         uint256 indexed entryId,
1055         address indexed referrerAddr
1056     );
1057     event XfLobbyExit(
1058         uint256 data0,
1059         address indexed memberAddr,
1060         uint256 indexed entryId,
1061         address indexed referrerAddr
1062     );
1063 
1064     fallback() external payable;
1065 
1066     function allocatedSupply() external view returns (uint256);
1067 
1068     function allowance(address owner, address spender)
1069         external
1070         view
1071         returns (uint256);
1072 
1073     function approve(address spender, uint256 amount) external returns (bool);
1074 
1075     function balanceOf(address account) external view returns (uint256);
1076 
1077     function btcAddressClaim(
1078         uint256 rawSatoshis,
1079         bytes32[] memory proof,
1080         address claimToAddr,
1081         bytes32 pubKeyX,
1082         bytes32 pubKeyY,
1083         uint8 claimFlags,
1084         uint8 v,
1085         bytes32 r,
1086         bytes32 s,
1087         uint256 autoStakeDays,
1088         address referrerAddr
1089     ) external returns (uint256);
1090 
1091     function btcAddressClaims(bytes20) external view returns (bool);
1092 
1093     function btcAddressIsClaimable(
1094         bytes20 btcAddr,
1095         uint256 rawSatoshis,
1096         bytes32[] memory proof
1097     ) external view returns (bool);
1098 
1099     function btcAddressIsValid(
1100         bytes20 btcAddr,
1101         uint256 rawSatoshis,
1102         bytes32[] memory proof
1103     ) external pure returns (bool);
1104 
1105     function claimMessageMatchesSignature(
1106         address claimToAddr,
1107         bytes32 claimParamHash,
1108         bytes32 pubKeyX,
1109         bytes32 pubKeyY,
1110         uint8 claimFlags,
1111         uint8 v,
1112         bytes32 r,
1113         bytes32 s
1114     ) external pure returns (bool);
1115 
1116     function currentDay() external view returns (uint256);
1117 
1118     function dailyData(uint256)
1119         external
1120         view
1121         returns (
1122             uint72 dayPayoutTotal,
1123             uint72 dayStakeSharesTotal,
1124             uint56 dayUnclaimedSatoshisTotal
1125         );
1126 
1127     function dailyDataRange(uint256 beginDay, uint256 endDay)
1128         external
1129         view
1130         returns (uint256[] memory list);
1131 
1132     function dailyDataUpdate(uint256 beforeDay) external;
1133 
1134     function decimals() external view returns (uint8);
1135 
1136     function decreaseAllowance(address spender, uint256 subtractedValue)
1137         external
1138         returns (bool);
1139 
1140     function globalInfo() external view returns (uint256[13] memory);
1141 
1142     function globals()
1143         external
1144         view
1145         returns (
1146             uint72 lockedHeartsTotal,
1147             uint72 nextStakeSharesTotal,
1148             uint40 shareRate,
1149             uint72 stakePenaltyTotal,
1150             uint16 dailyDataCount,
1151             uint72 stakeSharesTotal,
1152             uint40 latestStakeId,
1153             uint128 claimStats
1154         );
1155 
1156     function increaseAllowance(address spender, uint256 addedValue)
1157         external
1158         returns (bool);
1159 
1160     function merkleProofIsValid(bytes32 merkleLeaf, bytes32[] memory proof)
1161         external
1162         pure
1163         returns (bool);
1164 
1165     function name() external view returns (string memory);
1166 
1167     function pubKeyToBtcAddress(
1168         bytes32 pubKeyX,
1169         bytes32 pubKeyY,
1170         uint8 claimFlags
1171     ) external pure returns (bytes20);
1172 
1173     function pubKeyToEthAddress(bytes32 pubKeyX, bytes32 pubKeyY)
1174         external
1175         pure
1176         returns (address);
1177 
1178     function stakeCount(address stakerAddr) external view returns (uint256);
1179 
1180     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external;
1181 
1182     function stakeGoodAccounting(
1183         address stakerAddr,
1184         uint256 stakeIndex,
1185         uint40 stakeIdParam
1186     ) external;
1187 
1188     function stakeLists(address, uint256)
1189         external
1190         view
1191         returns (
1192             uint40 stakeId,
1193             uint72 stakedHearts,
1194             uint72 stakeShares,
1195             uint16 lockedDay,
1196             uint16 stakedDays,
1197             uint16 unlockedDay,
1198             bool isAutoStake
1199         );
1200 
1201     function stakeStart(uint256 newStakedHearts, uint256 newStakedDays)
1202         external;
1203 
1204     function symbol() external view returns (string memory);
1205 
1206     function totalSupply() external view returns (uint256);
1207 
1208     function transfer(address recipient, uint256 amount)
1209         external
1210         returns (bool);
1211 
1212     function transferFrom(
1213         address sender,
1214         address recipient,
1215         uint256 amount
1216     ) external returns (bool);
1217 
1218     function xfLobby(uint256) external view returns (uint256);
1219 
1220     function xfLobbyEnter(address referrerAddr) external payable;
1221 
1222     function xfLobbyEntry(address memberAddr, uint256 entryId)
1223         external
1224         view
1225         returns (uint256 rawAmount, address referrerAddr);
1226 
1227     function xfLobbyExit(uint256 enterDay, uint256 count) external;
1228 
1229     function xfLobbyFlush() external;
1230 
1231     function xfLobbyMembers(uint256, address)
1232         external
1233         view
1234         returns (uint40 headIndex, uint40 tailIndex);
1235 
1236     function xfLobbyPendingDays(address memberAddr)
1237         external
1238         view
1239         returns (uint256[2] memory words);
1240 
1241     function xfLobbyRange(uint256 beginDay, uint256 endDay)
1242         external
1243         view
1244         returns (uint256[] memory list);
1245 }
1246 
1247 struct HEXGlobals {
1248     uint72 lockedHeartsTotal;
1249     uint72 nextStakeSharesTotal;
1250     uint40 shareRate;
1251     uint72 stakePenaltyTotal;
1252     uint16 dailyDataCount;
1253     uint72 stakeSharesTotal;
1254     uint40 latestStakeId;
1255     uint128 claimStats;
1256 }
1257 
1258 struct HEXStake {
1259     uint40 stakeId;
1260     uint72 stakedHearts;
1261     uint72 stakeShares;
1262     uint16 lockedDay;
1263     uint16 stakedDays;
1264     uint16 unlockedDay;
1265     bool   isAutoStake;
1266 }
1267 
1268 struct HEXStakeMinimal {
1269     uint40 stakeId;
1270     uint72 stakeShares;
1271     uint16 lockedDay;
1272     uint16 stakedDays;
1273 }
1274 
1275 struct HDRNDailyData {
1276     uint72 dayMintedTotal;
1277     uint72 dayLoanedTotal;
1278     uint72 dayBurntTotal;
1279     uint32 dayInterestRate;
1280     uint8  dayMintMultiplier;
1281 }
1282 
1283 struct HDRNShareCache {
1284     HEXStakeMinimal _stake;
1285     uint256         _mintedDays;
1286     uint256         _launchBonus;
1287     uint256         _loanStart;
1288     uint256         _loanedDays;
1289     uint256         _interestRate;
1290     uint256         _paymentsMade;
1291     bool            _isLoaned;
1292 }
1293 
1294 struct StakeStore {
1295     uint64  stakeStart;
1296     uint64  capitalAdded;
1297     uint120 stakePoints;
1298     bool    isActive;
1299     uint80  payoutPreCapitalAddIcsa;
1300     uint80  payoutPreCapitalAddHdrn;
1301     uint80  stakeAmount;
1302     uint16  minStakeLength;
1303 }
1304 
1305 struct StakeCache {
1306     uint256 _stakeStart;
1307     uint256 _capitalAdded;
1308     uint256 _stakePoints;
1309     bool    _isActive;
1310     uint256 _payoutPreCapitalAddIcsa;
1311     uint256 _payoutPreCapitalAddHdrn;
1312     uint256 _stakeAmount;
1313     uint256 _minStakeLength;
1314 }
1315 
1316 interface IHedron {
1317     event Approval(
1318         address indexed owner,
1319         address indexed spender,
1320         uint256 value
1321     );
1322     event Claim(uint256 data, address indexed claimant, uint40 indexed stakeId);
1323     event LoanEnd(
1324         uint256 data,
1325         address indexed borrower,
1326         uint40 indexed stakeId
1327     );
1328     event LoanLiquidateBid(
1329         uint256 data,
1330         address indexed bidder,
1331         uint40 indexed stakeId,
1332         uint40 indexed liquidationId
1333     );
1334     event LoanLiquidateExit(
1335         uint256 data,
1336         address indexed liquidator,
1337         uint40 indexed stakeId,
1338         uint40 indexed liquidationId
1339     );
1340     event LoanLiquidateStart(
1341         uint256 data,
1342         address indexed borrower,
1343         uint40 indexed stakeId,
1344         uint40 indexed liquidationId
1345     );
1346     event LoanPayment(
1347         uint256 data,
1348         address indexed borrower,
1349         uint40 indexed stakeId
1350     );
1351     event LoanStart(
1352         uint256 data,
1353         address indexed borrower,
1354         uint40 indexed stakeId
1355     );
1356     event Mint(uint256 data, address indexed minter, uint40 indexed stakeId);
1357     event Transfer(address indexed from, address indexed to, uint256 value);
1358 
1359     function allowance(address owner, address spender)
1360         external
1361         view
1362         returns (uint256);
1363 
1364     function approve(address spender, uint256 amount) external returns (bool);
1365 
1366     function balanceOf(address account) external view returns (uint256);
1367 
1368     function calcLoanPayment(
1369         address borrower,
1370         uint256 hsiIndex,
1371         address hsiAddress
1372     ) external view returns (uint256, uint256);
1373 
1374     function calcLoanPayoff(
1375         address borrower,
1376         uint256 hsiIndex,
1377         address hsiAddress
1378     ) external view returns (uint256, uint256);
1379 
1380     function claimInstanced(
1381         uint256 hsiIndex,
1382         address hsiAddress,
1383         address hsiStarterAddress
1384     ) external;
1385 
1386     function claimNative(uint256 stakeIndex, uint40 stakeId)
1387         external
1388         returns (uint256);
1389 
1390     function currentDay() external view returns (uint256);
1391 
1392     function dailyDataList(uint256)
1393         external
1394         view
1395         returns (
1396             uint72 dayMintedTotal,
1397             uint72 dayLoanedTotal,
1398             uint72 dayBurntTotal,
1399             uint32 dayInterestRate,
1400             uint8 dayMintMultiplier
1401         );
1402 
1403     function decimals() external view returns (uint8);
1404 
1405     function decreaseAllowance(address spender, uint256 subtractedValue)
1406         external
1407         returns (bool);
1408 
1409     function hsim() external view returns (address);
1410 
1411     function increaseAllowance(address spender, uint256 addedValue)
1412         external
1413         returns (bool);
1414 
1415     function liquidationList(uint256)
1416         external
1417         view
1418         returns (
1419             uint256 liquidationStart,
1420             address hsiAddress,
1421             uint96 bidAmount,
1422             address liquidator,
1423             uint88 endOffset,
1424             bool isActive
1425         );
1426 
1427     function loanInstanced(uint256 hsiIndex, address hsiAddress)
1428         external
1429         returns (uint256);
1430 
1431     function loanLiquidate(
1432         address owner,
1433         uint256 hsiIndex,
1434         address hsiAddress
1435     ) external returns (uint256);
1436 
1437     function loanLiquidateBid(uint256 liquidationId, uint256 liquidationBid)
1438         external
1439         returns (uint256);
1440 
1441     function loanLiquidateExit(uint256 hsiIndex, uint256 liquidationId)
1442         external
1443         returns (address);
1444 
1445     function loanPayment(uint256 hsiIndex, address hsiAddress)
1446         external
1447         returns (uint256);
1448 
1449     function loanPayoff(uint256 hsiIndex, address hsiAddress)
1450         external
1451         returns (uint256);
1452 
1453     function loanedSupply() external view returns (uint256);
1454 
1455     function mintInstanced(uint256 hsiIndex, address hsiAddress)
1456         external
1457         returns (uint256);
1458 
1459     function mintNative(uint256 stakeIndex, uint40 stakeId)
1460         external
1461         returns (uint256);
1462 
1463     function name() external view returns (string memory);
1464 
1465     function proofOfBenevolence(uint256 amount) external;
1466 
1467     function shareList(uint256)
1468         external
1469         view
1470         returns (
1471             HEXStakeMinimal memory stake,
1472             uint16 mintedDays,
1473             uint8 launchBonus,
1474             uint16 loanStart,
1475             uint16 loanedDays,
1476             uint32 interestRate,
1477             uint8 paymentsMade,
1478             bool isLoaned
1479         );
1480 
1481     function symbol() external view returns (string memory);
1482 
1483     function totalSupply() external view returns (uint256);
1484 
1485     function transfer(address recipient, uint256 amount)
1486         external
1487         returns (bool);
1488 
1489     function transferFrom(
1490         address sender,
1491         address recipient,
1492         uint256 amount
1493     ) external returns (bool);
1494 }
1495 
1496 interface IHEXStakeInstance {
1497     function create(uint256 stakeLength) external;
1498 
1499     function destroy() external;
1500 
1501     function goodAccounting() external;
1502 
1503     function initialize(address hexAddress) external;
1504 
1505     function share()
1506         external
1507         view
1508         returns (
1509             HEXStakeMinimal memory stake,
1510             uint16 mintedDays,
1511             uint8 launchBonus,
1512             uint16 loanStart,
1513             uint16 loanedDays,
1514             uint32 interestRate,
1515             uint8 paymentsMade,
1516             bool isLoaned
1517         );
1518 
1519     function stakeDataFetch() external view returns (HEXStake memory);
1520 
1521     function update(HDRNShareCache memory _share) external;
1522 }
1523 
1524 library LibPart {
1525     bytes32 public constant TYPE_HASH = keccak256("Part(address account,uint96 value)");
1526 
1527     struct Part {
1528         address payable account;
1529         uint96 value;
1530     }
1531 
1532     function hash(Part memory part) internal pure returns (bytes32) {
1533         return keccak256(abi.encode(TYPE_HASH, part.account, part.value));
1534     }
1535 }
1536 
1537 abstract contract AbstractRoyalties {
1538     mapping (uint256 => LibPart.Part[]) internal royalties;
1539 
1540     function _saveRoyalties(uint256 id, LibPart.Part[] memory _royalties) internal {
1541         uint256 totalValue;
1542         for (uint i = 0; i < _royalties.length; i++) {
1543             require(_royalties[i].account != address(0x0), "Recipient should be present");
1544             require(_royalties[i].value != 0, "Royalty value should be positive");
1545             totalValue += _royalties[i].value;
1546             royalties[id].push(_royalties[i]);
1547         }
1548         require(totalValue < 10000, "Royalty total value should be < 10000");
1549         _onRoyaltiesSet(id, _royalties);
1550     }
1551 
1552     function _updateAccount(uint256 _id, address _from, address _to) internal {
1553         uint length = royalties[_id].length;
1554         for(uint i = 0; i < length; i++) {
1555             if (royalties[_id][i].account == _from) {
1556                 royalties[_id][i].account = payable(address(uint160(_to)));
1557             }
1558         }
1559     }
1560 
1561     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) virtual internal;
1562 }
1563 
1564 interface RoyaltiesV2 {
1565     event RoyaltiesSet(uint256 tokenId, LibPart.Part[] royalties);
1566 
1567     function getRaribleV2Royalties(uint256 id) external view returns (LibPart.Part[] memory);
1568 }
1569 
1570 contract RoyaltiesV2Impl is AbstractRoyalties, RoyaltiesV2 {
1571 
1572     function getRaribleV2Royalties(uint256 id) override external view returns (LibPart.Part[] memory) {
1573         return royalties[id];
1574     }
1575 
1576     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) override internal {
1577         emit RoyaltiesSet(id, _royalties);
1578     }
1579 }
1580 
1581 interface IHEXStakeInstanceManager {
1582     event Approval(
1583         address indexed owner,
1584         address indexed approved,
1585         uint256 indexed tokenId
1586     );
1587     event ApprovalForAll(
1588         address indexed owner,
1589         address indexed operator,
1590         bool approved
1591     );
1592     event HSIDetokenize(
1593         uint256 timestamp,
1594         uint256 indexed hsiTokenId,
1595         address indexed hsiAddress,
1596         address indexed staker
1597     );
1598     event HSIEnd(
1599         uint256 timestamp,
1600         address indexed hsiAddress,
1601         address indexed staker
1602     );
1603     event HSIStart(
1604         uint256 timestamp,
1605         address indexed hsiAddress,
1606         address indexed staker
1607     );
1608     event HSITokenize(
1609         uint256 timestamp,
1610         uint256 indexed hsiTokenId,
1611         address indexed hsiAddress,
1612         address indexed staker
1613     );
1614     event HSITransfer(
1615         uint256 timestamp,
1616         address indexed hsiAddress,
1617         address indexed oldStaker,
1618         address indexed newStaker
1619     );
1620     event RoyaltiesSet(uint256 tokenId, LibPart.Part[] royalties);
1621     event Transfer(
1622         address indexed from,
1623         address indexed to,
1624         uint256 indexed tokenId
1625     );
1626 
1627     function approve(address to, uint256 tokenId) external;
1628 
1629     function balanceOf(address owner) external view returns (uint256);
1630 
1631     function getApproved(uint256 tokenId) external view returns (address);
1632 
1633     function getRaribleV2Royalties(uint256 id)
1634         external
1635         view
1636         returns (LibPart.Part[] memory);
1637 
1638     function hexStakeDetokenize(uint256 tokenId) external returns (address);
1639 
1640     function hexStakeEnd(uint256 hsiIndex, address hsiAddress)
1641         external
1642         returns (uint256);
1643 
1644     function hexStakeStart(uint256 amount, uint256 length)
1645         external
1646         returns (address);
1647 
1648     function hexStakeTokenize(uint256 hsiIndex, address hsiAddress)
1649         external
1650         returns (uint256);
1651 
1652     function hsiCount(address user) external view returns (uint256);
1653 
1654     function hsiLists(address, uint256) external view returns (address);
1655 
1656     function hsiToken(uint256) external view returns (address);
1657 
1658     function hsiTransfer(
1659         address currentHolder,
1660         uint256 hsiIndex,
1661         address hsiAddress,
1662         address newHolder
1663     ) external;
1664 
1665     function hsiUpdate(
1666         address holder,
1667         uint256 hsiIndex,
1668         address hsiAddress,
1669         HDRNShareCache memory share
1670     ) external;
1671 
1672     function isApprovedForAll(address owner, address operator)
1673         external
1674         view
1675         returns (bool);
1676 
1677     function name() external view returns (string memory);
1678 
1679     function owner() external pure returns (address);
1680 
1681     function ownerOf(uint256 tokenId) external view returns (address);
1682 
1683     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1684         external
1685         view
1686         returns (address receiver, uint256 royaltyAmount);
1687 
1688     function safeTransferFrom(
1689         address from,
1690         address to,
1691         uint256 tokenId
1692     ) external;
1693 
1694     function safeTransferFrom(
1695         address from,
1696         address to,
1697         uint256 tokenId,
1698         bytes memory _data
1699     ) external;
1700 
1701     function setApprovalForAll(address operator, bool approved) external;
1702 
1703     function stakeCount(address user) external view returns (uint256);
1704 
1705     function stakeLists(address user, uint256 hsiIndex)
1706         external
1707         view
1708         returns (HEXStake memory);
1709 
1710     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1711 
1712     function symbol() external view returns (string memory);
1713 
1714     function tokenByIndex(uint256 index) external view returns (uint256);
1715 
1716     function tokenOfOwnerByIndex(address owner, uint256 index)
1717         external
1718         view
1719         returns (uint256);
1720 
1721     function tokenURI(uint256 tokenId) external view returns (string memory);
1722 
1723     function totalSupply() external view returns (uint256);
1724 
1725     function transferFrom(
1726         address from,
1727         address to,
1728         uint256 tokenId
1729     ) external;
1730 }
1731 
1732 /**
1733  * @dev Interface of the ERC165 standard, as defined in the
1734  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1735  *
1736  * Implementers can declare support of contract interfaces, which can then be
1737  * queried by others ({ERC165Checker}).
1738  *
1739  * For an implementation, see {ERC165}.
1740  */
1741 interface IERC165 {
1742     /**
1743      * @dev Returns true if this contract implements the interface defined by
1744      * `interfaceId`. See the corresponding
1745      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1746      * to learn more about how these ids are created.
1747      *
1748      * This function call must use less than 30 000 gas.
1749      */
1750     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1751 }
1752 
1753 /**
1754  * @dev Required interface of an ERC721 compliant contract.
1755  */
1756 interface IERC721 is IERC165 {
1757     /**
1758      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1759      */
1760     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1761 
1762     /**
1763      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1764      */
1765     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1766 
1767     /**
1768      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1769      */
1770     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1771 
1772     /**
1773      * @dev Returns the number of tokens in ``owner``'s account.
1774      */
1775     function balanceOf(address owner) external view returns (uint256 balance);
1776 
1777     /**
1778      * @dev Returns the owner of the `tokenId` token.
1779      *
1780      * Requirements:
1781      *
1782      * - `tokenId` must exist.
1783      */
1784     function ownerOf(uint256 tokenId) external view returns (address owner);
1785 
1786     /**
1787      * @dev Safely transfers `tokenId` token from `from` to `to`.
1788      *
1789      * Requirements:
1790      *
1791      * - `from` cannot be the zero address.
1792      * - `to` cannot be the zero address.
1793      * - `tokenId` token must exist and be owned by `from`.
1794      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1796      *
1797      * Emits a {Transfer} event.
1798      */
1799     function safeTransferFrom(
1800         address from,
1801         address to,
1802         uint256 tokenId,
1803         bytes calldata data
1804     ) external;
1805 
1806     /**
1807      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1808      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1809      *
1810      * Requirements:
1811      *
1812      * - `from` cannot be the zero address.
1813      * - `to` cannot be the zero address.
1814      * - `tokenId` token must exist and be owned by `from`.
1815      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1816      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1817      *
1818      * Emits a {Transfer} event.
1819      */
1820     function safeTransferFrom(
1821         address from,
1822         address to,
1823         uint256 tokenId
1824     ) external;
1825 
1826     /**
1827      * @dev Transfers `tokenId` token from `from` to `to`.
1828      *
1829      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1830      *
1831      * Requirements:
1832      *
1833      * - `from` cannot be the zero address.
1834      * - `to` cannot be the zero address.
1835      * - `tokenId` token must be owned by `from`.
1836      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1837      *
1838      * Emits a {Transfer} event.
1839      */
1840     function transferFrom(
1841         address from,
1842         address to,
1843         uint256 tokenId
1844     ) external;
1845 
1846     /**
1847      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1848      * The approval is cleared when the token is transferred.
1849      *
1850      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1851      *
1852      * Requirements:
1853      *
1854      * - The caller must own the token or be an approved operator.
1855      * - `tokenId` must exist.
1856      *
1857      * Emits an {Approval} event.
1858      */
1859     function approve(address to, uint256 tokenId) external;
1860 
1861     /**
1862      * @dev Approve or remove `operator` as an operator for the caller.
1863      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1864      *
1865      * Requirements:
1866      *
1867      * - The `operator` cannot be the caller.
1868      *
1869      * Emits an {ApprovalForAll} event.
1870      */
1871     function setApprovalForAll(address operator, bool _approved) external;
1872 
1873     /**
1874      * @dev Returns the account approved for `tokenId` token.
1875      *
1876      * Requirements:
1877      *
1878      * - `tokenId` must exist.
1879      */
1880     function getApproved(uint256 tokenId) external view returns (address operator);
1881 
1882     /**
1883      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1884      *
1885      * See {setApprovalForAll}
1886      */
1887     function isApprovedForAll(address owner, address operator) external view returns (bool);
1888 }
1889 
1890 /**
1891  * @title ERC721 token receiver interface
1892  * @dev Interface for any contract that wants to support safeTransfers
1893  * from ERC721 asset contracts.
1894  */
1895 interface IERC721Receiver {
1896     /**
1897      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1898      * by `operator` from `from`, this function is called.
1899      *
1900      * It must return its Solidity selector to confirm the token transfer.
1901      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1902      *
1903      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1904      */
1905     function onERC721Received(
1906         address operator,
1907         address from,
1908         uint256 tokenId,
1909         bytes calldata data
1910     ) external returns (bytes4);
1911 }
1912 
1913 /**
1914  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1915  * @dev See https://eips.ethereum.org/EIPS/eip-721
1916  */
1917 interface IERC721Metadata is IERC721 {
1918     /**
1919      * @dev Returns the token collection name.
1920      */
1921     function name() external view returns (string memory);
1922 
1923     /**
1924      * @dev Returns the token collection symbol.
1925      */
1926     function symbol() external view returns (string memory);
1927 
1928     /**
1929      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1930      */
1931     function tokenURI(uint256 tokenId) external view returns (string memory);
1932 }
1933 
1934 /**
1935  * @dev Collection of functions related to the address type
1936  */
1937 library Address {
1938     /**
1939      * @dev Returns true if `account` is a contract.
1940      *
1941      * [IMPORTANT]
1942      * ====
1943      * It is unsafe to assume that an address for which this function returns
1944      * false is an externally-owned account (EOA) and not a contract.
1945      *
1946      * Among others, `isContract` will return false for the following
1947      * types of addresses:
1948      *
1949      *  - an externally-owned account
1950      *  - a contract in construction
1951      *  - an address where a contract will be created
1952      *  - an address where a contract lived, but was destroyed
1953      * ====
1954      *
1955      * [IMPORTANT]
1956      * ====
1957      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1958      *
1959      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1960      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1961      * constructor.
1962      * ====
1963      */
1964     function isContract(address account) internal view returns (bool) {
1965         // This method relies on extcodesize/address.code.length, which returns 0
1966         // for contracts in construction, since the code is only stored at the end
1967         // of the constructor execution.
1968 
1969         return account.code.length > 0;
1970     }
1971 
1972     /**
1973      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1974      * `recipient`, forwarding all available gas and reverting on errors.
1975      *
1976      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1977      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1978      * imposed by `transfer`, making them unable to receive funds via
1979      * `transfer`. {sendValue} removes this limitation.
1980      *
1981      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1982      *
1983      * IMPORTANT: because control is transferred to `recipient`, care must be
1984      * taken to not create reentrancy vulnerabilities. Consider using
1985      * {ReentrancyGuard} or the
1986      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1987      */
1988     function sendValue(address payable recipient, uint256 amount) internal {
1989         require(address(this).balance >= amount, "Address: insufficient balance");
1990 
1991         (bool success, ) = recipient.call{value: amount}("");
1992         require(success, "Address: unable to send value, recipient may have reverted");
1993     }
1994 
1995     /**
1996      * @dev Performs a Solidity function call using a low level `call`. A
1997      * plain `call` is an unsafe replacement for a function call: use this
1998      * function instead.
1999      *
2000      * If `target` reverts with a revert reason, it is bubbled up by this
2001      * function (like regular Solidity function calls).
2002      *
2003      * Returns the raw returned data. To convert to the expected return value,
2004      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2005      *
2006      * Requirements:
2007      *
2008      * - `target` must be a contract.
2009      * - calling `target` with `data` must not revert.
2010      *
2011      * _Available since v3.1._
2012      */
2013     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2014         return functionCall(target, data, "Address: low-level call failed");
2015     }
2016 
2017     /**
2018      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2019      * `errorMessage` as a fallback revert reason when `target` reverts.
2020      *
2021      * _Available since v3.1._
2022      */
2023     function functionCall(
2024         address target,
2025         bytes memory data,
2026         string memory errorMessage
2027     ) internal returns (bytes memory) {
2028         return functionCallWithValue(target, data, 0, errorMessage);
2029     }
2030 
2031     /**
2032      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2033      * but also transferring `value` wei to `target`.
2034      *
2035      * Requirements:
2036      *
2037      * - the calling contract must have an ETH balance of at least `value`.
2038      * - the called Solidity function must be `payable`.
2039      *
2040      * _Available since v3.1._
2041      */
2042     function functionCallWithValue(
2043         address target,
2044         bytes memory data,
2045         uint256 value
2046     ) internal returns (bytes memory) {
2047         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2048     }
2049 
2050     /**
2051      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2052      * with `errorMessage` as a fallback revert reason when `target` reverts.
2053      *
2054      * _Available since v3.1._
2055      */
2056     function functionCallWithValue(
2057         address target,
2058         bytes memory data,
2059         uint256 value,
2060         string memory errorMessage
2061     ) internal returns (bytes memory) {
2062         require(address(this).balance >= value, "Address: insufficient balance for call");
2063         require(isContract(target), "Address: call to non-contract");
2064 
2065         (bool success, bytes memory returndata) = target.call{value: value}(data);
2066         return verifyCallResult(success, returndata, errorMessage);
2067     }
2068 
2069     /**
2070      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2071      * but performing a static call.
2072      *
2073      * _Available since v3.3._
2074      */
2075     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2076         return functionStaticCall(target, data, "Address: low-level static call failed");
2077     }
2078 
2079     /**
2080      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2081      * but performing a static call.
2082      *
2083      * _Available since v3.3._
2084      */
2085     function functionStaticCall(
2086         address target,
2087         bytes memory data,
2088         string memory errorMessage
2089     ) internal view returns (bytes memory) {
2090         require(isContract(target), "Address: static call to non-contract");
2091 
2092         (bool success, bytes memory returndata) = target.staticcall(data);
2093         return verifyCallResult(success, returndata, errorMessage);
2094     }
2095 
2096     /**
2097      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2098      * but performing a delegate call.
2099      *
2100      * _Available since v3.4._
2101      */
2102     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2103         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2104     }
2105 
2106     /**
2107      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2108      * but performing a delegate call.
2109      *
2110      * _Available since v3.4._
2111      */
2112     function functionDelegateCall(
2113         address target,
2114         bytes memory data,
2115         string memory errorMessage
2116     ) internal returns (bytes memory) {
2117         require(isContract(target), "Address: delegate call to non-contract");
2118 
2119         (bool success, bytes memory returndata) = target.delegatecall(data);
2120         return verifyCallResult(success, returndata, errorMessage);
2121     }
2122 
2123     /**
2124      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2125      * revert reason using the provided one.
2126      *
2127      * _Available since v4.3._
2128      */
2129     function verifyCallResult(
2130         bool success,
2131         bytes memory returndata,
2132         string memory errorMessage
2133     ) internal pure returns (bytes memory) {
2134         if (success) {
2135             return returndata;
2136         } else {
2137             // Look for revert reason and bubble it up if present
2138             if (returndata.length > 0) {
2139                 // The easiest way to bubble the revert reason is using memory via assembly
2140                 /// @solidity memory-safe-assembly
2141                 assembly {
2142                     let returndata_size := mload(returndata)
2143                     revert(add(32, returndata), returndata_size)
2144                 }
2145             } else {
2146                 revert(errorMessage);
2147             }
2148         }
2149     }
2150 }
2151 
2152 /**
2153  * @dev String operations.
2154  */
2155 library Strings {
2156     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2157     uint8 private constant _ADDRESS_LENGTH = 20;
2158 
2159     /**
2160      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2161      */
2162     function toString(uint256 value) internal pure returns (string memory) {
2163         // Inspired by OraclizeAPI's implementation - MIT licence
2164         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2165 
2166         if (value == 0) {
2167             return "0";
2168         }
2169         uint256 temp = value;
2170         uint256 digits;
2171         while (temp != 0) {
2172             digits++;
2173             temp /= 10;
2174         }
2175         bytes memory buffer = new bytes(digits);
2176         while (value != 0) {
2177             digits -= 1;
2178             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2179             value /= 10;
2180         }
2181         return string(buffer);
2182     }
2183 
2184     /**
2185      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2186      */
2187     function toHexString(uint256 value) internal pure returns (string memory) {
2188         if (value == 0) {
2189             return "0x00";
2190         }
2191         uint256 temp = value;
2192         uint256 length = 0;
2193         while (temp != 0) {
2194             length++;
2195             temp >>= 8;
2196         }
2197         return toHexString(value, length);
2198     }
2199 
2200     /**
2201      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2202      */
2203     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2204         bytes memory buffer = new bytes(2 * length + 2);
2205         buffer[0] = "0";
2206         buffer[1] = "x";
2207         for (uint256 i = 2 * length + 1; i > 1; --i) {
2208             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2209             value >>= 4;
2210         }
2211         require(value == 0, "Strings: hex length insufficient");
2212         return string(buffer);
2213     }
2214 
2215     /**
2216      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2217      */
2218     function toHexString(address addr) internal pure returns (string memory) {
2219         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2220     }
2221 }
2222 
2223 /**
2224  * @dev Implementation of the {IERC165} interface.
2225  *
2226  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2227  * for the additional interface id that will be supported. For example:
2228  *
2229  * ```solidity
2230  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2231  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2232  * }
2233  * ```
2234  *
2235  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2236  */
2237 abstract contract ERC165 is IERC165 {
2238     /**
2239      * @dev See {IERC165-supportsInterface}.
2240      */
2241     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2242         return interfaceId == type(IERC165).interfaceId;
2243     }
2244 }
2245 
2246 /**
2247  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2248  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2249  * {ERC721Enumerable}.
2250  */
2251 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2252     using Address for address;
2253     using Strings for uint256;
2254 
2255     // Token name
2256     string private _name;
2257 
2258     // Token symbol
2259     string private _symbol;
2260 
2261     // Mapping from token ID to owner address
2262     mapping(uint256 => address) private _owners;
2263 
2264     // Mapping owner address to token count
2265     mapping(address => uint256) private _balances;
2266 
2267     // Mapping from token ID to approved address
2268     mapping(uint256 => address) private _tokenApprovals;
2269 
2270     // Mapping from owner to operator approvals
2271     mapping(address => mapping(address => bool)) private _operatorApprovals;
2272 
2273     /**
2274      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2275      */
2276     constructor(string memory name_, string memory symbol_) {
2277         _name = name_;
2278         _symbol = symbol_;
2279     }
2280 
2281     /**
2282      * @dev See {IERC165-supportsInterface}.
2283      */
2284     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2285         return
2286             interfaceId == type(IERC721).interfaceId ||
2287             interfaceId == type(IERC721Metadata).interfaceId ||
2288             super.supportsInterface(interfaceId);
2289     }
2290 
2291     /**
2292      * @dev See {IERC721-balanceOf}.
2293      */
2294     function balanceOf(address owner) public view virtual override returns (uint256) {
2295         require(owner != address(0), "ERC721: address zero is not a valid owner");
2296         return _balances[owner];
2297     }
2298 
2299     /**
2300      * @dev See {IERC721-ownerOf}.
2301      */
2302     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2303         address owner = _owners[tokenId];
2304         require(owner != address(0), "ERC721: invalid token ID");
2305         return owner;
2306     }
2307 
2308     /**
2309      * @dev See {IERC721Metadata-name}.
2310      */
2311     function name() public view virtual override returns (string memory) {
2312         return _name;
2313     }
2314 
2315     /**
2316      * @dev See {IERC721Metadata-symbol}.
2317      */
2318     function symbol() public view virtual override returns (string memory) {
2319         return _symbol;
2320     }
2321 
2322     /**
2323      * @dev See {IERC721Metadata-tokenURI}.
2324      */
2325     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2326         _requireMinted(tokenId);
2327 
2328         string memory baseURI = _baseURI();
2329         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2330     }
2331 
2332     /**
2333      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2334      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2335      * by default, can be overridden in child contracts.
2336      */
2337     function _baseURI() internal view virtual returns (string memory) {
2338         return "";
2339     }
2340 
2341     /**
2342      * @dev See {IERC721-approve}.
2343      */
2344     function approve(address to, uint256 tokenId) public virtual override {
2345         address owner = ERC721.ownerOf(tokenId);
2346         require(to != owner, "ERC721: approval to current owner");
2347 
2348         require(
2349             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2350             "ERC721: approve caller is not token owner nor approved for all"
2351         );
2352 
2353         _approve(to, tokenId);
2354     }
2355 
2356     /**
2357      * @dev See {IERC721-getApproved}.
2358      */
2359     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2360         _requireMinted(tokenId);
2361 
2362         return _tokenApprovals[tokenId];
2363     }
2364 
2365     /**
2366      * @dev See {IERC721-setApprovalForAll}.
2367      */
2368     function setApprovalForAll(address operator, bool approved) public virtual override {
2369         _setApprovalForAll(_msgSender(), operator, approved);
2370     }
2371 
2372     /**
2373      * @dev See {IERC721-isApprovedForAll}.
2374      */
2375     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2376         return _operatorApprovals[owner][operator];
2377     }
2378 
2379     /**
2380      * @dev See {IERC721-transferFrom}.
2381      */
2382     function transferFrom(
2383         address from,
2384         address to,
2385         uint256 tokenId
2386     ) public virtual override {
2387         //solhint-disable-next-line max-line-length
2388         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2389 
2390         _transfer(from, to, tokenId);
2391     }
2392 
2393     /**
2394      * @dev See {IERC721-safeTransferFrom}.
2395      */
2396     function safeTransferFrom(
2397         address from,
2398         address to,
2399         uint256 tokenId
2400     ) public virtual override {
2401         safeTransferFrom(from, to, tokenId, "");
2402     }
2403 
2404     /**
2405      * @dev See {IERC721-safeTransferFrom}.
2406      */
2407     function safeTransferFrom(
2408         address from,
2409         address to,
2410         uint256 tokenId,
2411         bytes memory data
2412     ) public virtual override {
2413         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2414         _safeTransfer(from, to, tokenId, data);
2415     }
2416 
2417     /**
2418      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2419      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2420      *
2421      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2422      *
2423      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2424      * implement alternative mechanisms to perform token transfer, such as signature-based.
2425      *
2426      * Requirements:
2427      *
2428      * - `from` cannot be the zero address.
2429      * - `to` cannot be the zero address.
2430      * - `tokenId` token must exist and be owned by `from`.
2431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2432      *
2433      * Emits a {Transfer} event.
2434      */
2435     function _safeTransfer(
2436         address from,
2437         address to,
2438         uint256 tokenId,
2439         bytes memory data
2440     ) internal virtual {
2441         _transfer(from, to, tokenId);
2442         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2443     }
2444 
2445     /**
2446      * @dev Returns whether `tokenId` exists.
2447      *
2448      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2449      *
2450      * Tokens start existing when they are minted (`_mint`),
2451      * and stop existing when they are burned (`_burn`).
2452      */
2453     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2454         return _owners[tokenId] != address(0);
2455     }
2456 
2457     /**
2458      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2459      *
2460      * Requirements:
2461      *
2462      * - `tokenId` must exist.
2463      */
2464     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2465         address owner = ERC721.ownerOf(tokenId);
2466         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2467     }
2468 
2469     /**
2470      * @dev Safely mints `tokenId` and transfers it to `to`.
2471      *
2472      * Requirements:
2473      *
2474      * - `tokenId` must not exist.
2475      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2476      *
2477      * Emits a {Transfer} event.
2478      */
2479     function _safeMint(address to, uint256 tokenId) internal virtual {
2480         _safeMint(to, tokenId, "");
2481     }
2482 
2483     /**
2484      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2485      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2486      */
2487     function _safeMint(
2488         address to,
2489         uint256 tokenId,
2490         bytes memory data
2491     ) internal virtual {
2492         _mint(to, tokenId);
2493         require(
2494             _checkOnERC721Received(address(0), to, tokenId, data),
2495             "ERC721: transfer to non ERC721Receiver implementer"
2496         );
2497     }
2498 
2499     /**
2500      * @dev Mints `tokenId` and transfers it to `to`.
2501      *
2502      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2503      *
2504      * Requirements:
2505      *
2506      * - `tokenId` must not exist.
2507      * - `to` cannot be the zero address.
2508      *
2509      * Emits a {Transfer} event.
2510      */
2511     function _mint(address to, uint256 tokenId) internal virtual {
2512         require(to != address(0), "ERC721: mint to the zero address");
2513         require(!_exists(tokenId), "ERC721: token already minted");
2514 
2515         _beforeTokenTransfer(address(0), to, tokenId);
2516 
2517         _balances[to] += 1;
2518         _owners[tokenId] = to;
2519 
2520         emit Transfer(address(0), to, tokenId);
2521 
2522         _afterTokenTransfer(address(0), to, tokenId);
2523     }
2524 
2525     /**
2526      * @dev Destroys `tokenId`.
2527      * The approval is cleared when the token is burned.
2528      *
2529      * Requirements:
2530      *
2531      * - `tokenId` must exist.
2532      *
2533      * Emits a {Transfer} event.
2534      */
2535     function _burn(uint256 tokenId) internal virtual {
2536         address owner = ERC721.ownerOf(tokenId);
2537 
2538         _beforeTokenTransfer(owner, address(0), tokenId);
2539 
2540         // Clear approvals
2541         _approve(address(0), tokenId);
2542 
2543         _balances[owner] -= 1;
2544         delete _owners[tokenId];
2545 
2546         emit Transfer(owner, address(0), tokenId);
2547 
2548         _afterTokenTransfer(owner, address(0), tokenId);
2549     }
2550 
2551     /**
2552      * @dev Transfers `tokenId` from `from` to `to`.
2553      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2554      *
2555      * Requirements:
2556      *
2557      * - `to` cannot be the zero address.
2558      * - `tokenId` token must be owned by `from`.
2559      *
2560      * Emits a {Transfer} event.
2561      */
2562     function _transfer(
2563         address from,
2564         address to,
2565         uint256 tokenId
2566     ) internal virtual {
2567         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2568         require(to != address(0), "ERC721: transfer to the zero address");
2569 
2570         _beforeTokenTransfer(from, to, tokenId);
2571 
2572         // Clear approvals from the previous owner
2573         _approve(address(0), tokenId);
2574 
2575         _balances[from] -= 1;
2576         _balances[to] += 1;
2577         _owners[tokenId] = to;
2578 
2579         emit Transfer(from, to, tokenId);
2580 
2581         _afterTokenTransfer(from, to, tokenId);
2582     }
2583 
2584     /**
2585      * @dev Approve `to` to operate on `tokenId`
2586      *
2587      * Emits an {Approval} event.
2588      */
2589     function _approve(address to, uint256 tokenId) internal virtual {
2590         _tokenApprovals[tokenId] = to;
2591         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2592     }
2593 
2594     /**
2595      * @dev Approve `operator` to operate on all of `owner` tokens
2596      *
2597      * Emits an {ApprovalForAll} event.
2598      */
2599     function _setApprovalForAll(
2600         address owner,
2601         address operator,
2602         bool approved
2603     ) internal virtual {
2604         require(owner != operator, "ERC721: approve to caller");
2605         _operatorApprovals[owner][operator] = approved;
2606         emit ApprovalForAll(owner, operator, approved);
2607     }
2608 
2609     /**
2610      * @dev Reverts if the `tokenId` has not been minted yet.
2611      */
2612     function _requireMinted(uint256 tokenId) internal view virtual {
2613         require(_exists(tokenId), "ERC721: invalid token ID");
2614     }
2615 
2616     /**
2617      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2618      * The call is not executed if the target address is not a contract.
2619      *
2620      * @param from address representing the previous owner of the given token ID
2621      * @param to target address that will receive the tokens
2622      * @param tokenId uint256 ID of the token to be transferred
2623      * @param data bytes optional data to send along with the call
2624      * @return bool whether the call correctly returned the expected magic value
2625      */
2626     function _checkOnERC721Received(
2627         address from,
2628         address to,
2629         uint256 tokenId,
2630         bytes memory data
2631     ) private returns (bool) {
2632         if (to.isContract()) {
2633             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2634                 return retval == IERC721Receiver.onERC721Received.selector;
2635             } catch (bytes memory reason) {
2636                 if (reason.length == 0) {
2637                     revert("ERC721: transfer to non ERC721Receiver implementer");
2638                 } else {
2639                     /// @solidity memory-safe-assembly
2640                     assembly {
2641                         revert(add(32, reason), mload(reason))
2642                     }
2643                 }
2644             }
2645         } else {
2646             return true;
2647         }
2648     }
2649 
2650     /**
2651      * @dev Hook that is called before any token transfer. This includes minting
2652      * and burning.
2653      *
2654      * Calling conditions:
2655      *
2656      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2657      * transferred to `to`.
2658      * - When `from` is zero, `tokenId` will be minted for `to`.
2659      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2660      * - `from` and `to` are never both zero.
2661      *
2662      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2663      */
2664     function _beforeTokenTransfer(
2665         address from,
2666         address to,
2667         uint256 tokenId
2668     ) internal virtual {}
2669 
2670     /**
2671      * @dev Hook that is called after any transfer of tokens. This includes
2672      * minting and burning.
2673      *
2674      * Calling conditions:
2675      *
2676      * - when `from` and `to` are both non-zero.
2677      * - `from` and `to` are never both zero.
2678      *
2679      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2680      */
2681     function _afterTokenTransfer(
2682         address from,
2683         address to,
2684         uint256 tokenId
2685     ) internal virtual {}
2686 }
2687 
2688 /**
2689  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2690  * @dev See https://eips.ethereum.org/EIPS/eip-721
2691  */
2692 interface IERC721Enumerable is IERC721 {
2693     /**
2694      * @dev Returns the total amount of tokens stored by the contract.
2695      */
2696     function totalSupply() external view returns (uint256);
2697 
2698     /**
2699      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2700      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2701      */
2702     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
2703 
2704     /**
2705      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2706      * Use along with {totalSupply} to enumerate all tokens.
2707      */
2708     function tokenByIndex(uint256 index) external view returns (uint256);
2709 }
2710 
2711 /**
2712  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2713  * enumerability of all the token ids in the contract as well as all token ids owned by each
2714  * account.
2715  */
2716 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2717     // Mapping from owner to list of owned token IDs
2718     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2719 
2720     // Mapping from token ID to index of the owner tokens list
2721     mapping(uint256 => uint256) private _ownedTokensIndex;
2722 
2723     // Array with all token ids, used for enumeration
2724     uint256[] private _allTokens;
2725 
2726     // Mapping from token id to position in the allTokens array
2727     mapping(uint256 => uint256) private _allTokensIndex;
2728 
2729     /**
2730      * @dev See {IERC165-supportsInterface}.
2731      */
2732     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2733         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2734     }
2735 
2736     /**
2737      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2738      */
2739     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2740         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2741         return _ownedTokens[owner][index];
2742     }
2743 
2744     /**
2745      * @dev See {IERC721Enumerable-totalSupply}.
2746      */
2747     function totalSupply() public view virtual override returns (uint256) {
2748         return _allTokens.length;
2749     }
2750 
2751     /**
2752      * @dev See {IERC721Enumerable-tokenByIndex}.
2753      */
2754     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2755         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2756         return _allTokens[index];
2757     }
2758 
2759     /**
2760      * @dev Hook that is called before any token transfer. This includes minting
2761      * and burning.
2762      *
2763      * Calling conditions:
2764      *
2765      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2766      * transferred to `to`.
2767      * - When `from` is zero, `tokenId` will be minted for `to`.
2768      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2769      * - `from` cannot be the zero address.
2770      * - `to` cannot be the zero address.
2771      *
2772      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2773      */
2774     function _beforeTokenTransfer(
2775         address from,
2776         address to,
2777         uint256 tokenId
2778     ) internal virtual override {
2779         super._beforeTokenTransfer(from, to, tokenId);
2780 
2781         if (from == address(0)) {
2782             _addTokenToAllTokensEnumeration(tokenId);
2783         } else if (from != to) {
2784             _removeTokenFromOwnerEnumeration(from, tokenId);
2785         }
2786         if (to == address(0)) {
2787             _removeTokenFromAllTokensEnumeration(tokenId);
2788         } else if (to != from) {
2789             _addTokenToOwnerEnumeration(to, tokenId);
2790         }
2791     }
2792 
2793     /**
2794      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2795      * @param to address representing the new owner of the given token ID
2796      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2797      */
2798     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2799         uint256 length = ERC721.balanceOf(to);
2800         _ownedTokens[to][length] = tokenId;
2801         _ownedTokensIndex[tokenId] = length;
2802     }
2803 
2804     /**
2805      * @dev Private function to add a token to this extension's token tracking data structures.
2806      * @param tokenId uint256 ID of the token to be added to the tokens list
2807      */
2808     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2809         _allTokensIndex[tokenId] = _allTokens.length;
2810         _allTokens.push(tokenId);
2811     }
2812 
2813     /**
2814      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2815      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2816      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2817      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2818      * @param from address representing the previous owner of the given token ID
2819      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2820      */
2821     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2822         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2823         // then delete the last slot (swap and pop).
2824 
2825         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2826         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2827 
2828         // When the token to delete is the last token, the swap operation is unnecessary
2829         if (tokenIndex != lastTokenIndex) {
2830             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2831 
2832             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2833             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2834         }
2835 
2836         // This also deletes the contents at the last position of the array
2837         delete _ownedTokensIndex[tokenId];
2838         delete _ownedTokens[from][lastTokenIndex];
2839     }
2840 
2841     /**
2842      * @dev Private function to remove a token from this extension's token tracking data structures.
2843      * This has O(1) time complexity, but alters the order of the _allTokens array.
2844      * @param tokenId uint256 ID of the token to be removed from the tokens list
2845      */
2846     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2847         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2848         // then delete the last slot (swap and pop).
2849 
2850         uint256 lastTokenIndex = _allTokens.length - 1;
2851         uint256 tokenIndex = _allTokensIndex[tokenId];
2852 
2853         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2854         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2855         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2856         uint256 lastTokenId = _allTokens[lastTokenIndex];
2857 
2858         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2859         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2860 
2861         // This also deletes the contents at the last position of the array
2862         delete _allTokensIndex[tokenId];
2863         _allTokens.pop();
2864     }
2865 }
2866 
2867 /**
2868  * @title Counters
2869  * @author Matt Condon (@shrugs)
2870  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
2871  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
2872  *
2873  * Include with `using Counters for Counters.Counter;`
2874  */
2875 library Counters {
2876     struct Counter {
2877         // This variable should never be directly accessed by users of the library: interactions must be restricted to
2878         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
2879         // this feature: see https://github.com/ethereum/solidity/issues/4637
2880         uint256 _value; // default: 0
2881     }
2882 
2883     function current(Counter storage counter) internal view returns (uint256) {
2884         return counter._value;
2885     }
2886 
2887     function increment(Counter storage counter) internal {
2888         unchecked {
2889             counter._value += 1;
2890         }
2891     }
2892 
2893     function decrement(Counter storage counter) internal {
2894         uint256 value = counter._value;
2895         require(value > 0, "Counter: decrement overflow");
2896         unchecked {
2897             counter._value = value - 1;
2898         }
2899     }
2900 
2901     function reset(Counter storage counter) internal {
2902         counter._value = 0;
2903     }
2904 }
2905 
2906 library LibRoyaltiesV2 {
2907     /*
2908      * bytes4(keccak256('getRaribleV2Royalties(uint256)')) == 0xcad96cca
2909      */
2910     bytes4 constant _INTERFACE_ID_ROYALTIES = 0xcad96cca;
2911 }
2912 
2913 contract WeAreAllTheSA is ERC721, ERC721Enumerable, RoyaltiesV2Impl {
2914 
2915     using Counters for Counters.Counter;
2916 
2917     address private constant _hdrnFlowAddress = address(0xF447BE386164dADfB5d1e7622613f289F17024D8);
2918     bytes4  private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
2919     uint96  private constant _waatsaRoyaltyBasis = 369; // Rarible V2 royalty basis
2920     string  private constant _hostname = "https://api.icosa.pro/";
2921     string  private constant _endpoint = "/waatsa/";
2922 
2923     Counters.Counter private _tokenIds;
2924     address          private _creator;
2925 
2926     constructor() ERC721("We Are All the SA", "WAATSA")
2927     {
2928         /* _creator is not an admin key. It is set at contsruction to be a link
2929            to the parent contract. In this case Hedron */
2930         _creator = msg.sender;
2931     }
2932 
2933     function _baseURI(
2934     )
2935         internal
2936         view
2937         virtual
2938         override
2939         returns (string memory)
2940     {
2941         string memory chainid = Strings.toString(block.chainid);
2942         return string(abi.encodePacked(_hostname, chainid, _endpoint));
2943     }
2944 
2945     function _beforeTokenTransfer(
2946         address from,
2947         address to,
2948         uint256 tokenId
2949     )
2950         internal
2951         override(ERC721, ERC721Enumerable) 
2952     {
2953         super._beforeTokenTransfer(from, to, tokenId);
2954     }
2955 
2956     // Internal NFT Marketplace Glue
2957 
2958     /** @dev Sets the Rarible V2 royalties on a specific token
2959      *  @param tokenId Unique ID of the HSI NFT token.
2960      */
2961     function _setRoyalties(
2962         uint256 tokenId
2963     )
2964         internal
2965     {
2966         LibPart.Part[] memory _royalties = new LibPart.Part[](1);
2967         _royalties[0].value = _waatsaRoyaltyBasis;
2968         _royalties[0].account = payable(_hdrnFlowAddress);
2969         _saveRoyalties(tokenId, _royalties);
2970     }
2971 
2972     function mintStakeNft (address staker)
2973         external
2974         returns (uint256)
2975     {
2976         require(msg.sender == _creator,
2977             "WAATSA: NOT ICSA");
2978 
2979         _tokenIds.increment();
2980         uint256 newTokenId = _tokenIds.current();
2981 
2982         _setRoyalties(newTokenId);
2983 
2984         _mint(staker, newTokenId);
2985         return newTokenId;
2986     }
2987 
2988     function burnStakeNft (uint256 tokenId)
2989         external
2990     {
2991         require(msg.sender == _creator,
2992             "WAATSA: NOT ICSA");
2993 
2994         _burn(tokenId);
2995     }
2996 
2997     // External NFT Marketplace Glue
2998 
2999     /**
3000      * @dev Implements ERC2981 royalty functionality. We just read the royalty data from
3001      *      the Rarible V2 implementation. 
3002      * @param tokenId Unique ID of the HSI NFT token.
3003      * @param salePrice Price the HSI NFT token was sold for.
3004      * @return receiver address to send the royalties to as well as the royalty amount.
3005      */
3006     function royaltyInfo(
3007         uint256 tokenId,
3008         uint256 salePrice
3009     )
3010         external
3011         view
3012         returns (address receiver, uint256 royaltyAmount)
3013     {
3014         LibPart.Part[] memory _royalties = royalties[tokenId];
3015         
3016         if (_royalties.length > 0) {
3017             return (_royalties[0].account, (salePrice * _royalties[0].value) / 10000);
3018         }
3019 
3020         return (address(0), 0);
3021     }
3022 
3023     /**
3024      * @dev returns _hdrnFlowAddress, needed for some NFT marketplaces. This is not
3025      *       an admin key.
3026      * @return _hdrnFlowAddress
3027      */
3028     function owner(
3029     )
3030         external
3031         pure
3032         returns (address) 
3033     {
3034         return _hdrnFlowAddress;
3035     }
3036 
3037     /**
3038      * @dev Adds Rarible V2 and ERC2981 interface support.
3039      * @param interfaceId Unique contract interface identifier.
3040      * @return True if the interface is supported, false if not.
3041      */
3042     function supportsInterface(
3043         bytes4 interfaceId
3044     )
3045         public
3046         view
3047         virtual
3048         override(ERC721, ERC721Enumerable)
3049         returns (bool)
3050     {
3051         if (interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
3052             return true;
3053         }
3054 
3055         if (interfaceId == _INTERFACE_ID_ERC2981) {
3056             return true;
3057         }
3058 
3059         return super.supportsInterface(interfaceId);
3060     }
3061 
3062 }
3063 
3064 /// @title Math library for computing sqrt prices from ticks and vice versa
3065 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
3066 /// prices between 2**-128 and 2**128
3067 library TickMath {
3068     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
3069     int24 internal constant MIN_TICK = -887272;
3070     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
3071     int24 internal constant MAX_TICK = -MIN_TICK;
3072 
3073     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
3074     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
3075     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
3076     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
3077 
3078     /// @notice Calculates sqrt(1.0001^tick) * 2^96
3079     /// @dev Throws if |tick| > max tick
3080     /// @param tick The input tick for the above formula
3081     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
3082     /// at the given tick
3083     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
3084         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
3085         require(absTick <= uint256(int256(MAX_TICK)), 'T');
3086 
3087         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
3088         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
3089         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
3090         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
3091         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
3092         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
3093         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
3094         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
3095         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
3096         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
3097         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
3098         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
3099         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
3100         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
3101         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
3102         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
3103         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
3104         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
3105         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
3106         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
3107 
3108         if (tick > 0) ratio = type(uint256).max / ratio;
3109 
3110         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
3111         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
3112         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
3113         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
3114     }
3115 
3116     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
3117     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
3118     /// ever return.
3119     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
3120     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
3121     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
3122         // second inequality must be < because the price can never reach the price at the max tick
3123         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
3124         uint256 ratio = uint256(sqrtPriceX96) << 32;
3125 
3126         uint256 r = ratio;
3127         uint256 msb = 0;
3128 
3129         assembly {
3130             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
3131             msb := or(msb, f)
3132             r := shr(f, r)
3133         }
3134         assembly {
3135             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
3136             msb := or(msb, f)
3137             r := shr(f, r)
3138         }
3139         assembly {
3140             let f := shl(5, gt(r, 0xFFFFFFFF))
3141             msb := or(msb, f)
3142             r := shr(f, r)
3143         }
3144         assembly {
3145             let f := shl(4, gt(r, 0xFFFF))
3146             msb := or(msb, f)
3147             r := shr(f, r)
3148         }
3149         assembly {
3150             let f := shl(3, gt(r, 0xFF))
3151             msb := or(msb, f)
3152             r := shr(f, r)
3153         }
3154         assembly {
3155             let f := shl(2, gt(r, 0xF))
3156             msb := or(msb, f)
3157             r := shr(f, r)
3158         }
3159         assembly {
3160             let f := shl(1, gt(r, 0x3))
3161             msb := or(msb, f)
3162             r := shr(f, r)
3163         }
3164         assembly {
3165             let f := gt(r, 0x1)
3166             msb := or(msb, f)
3167         }
3168 
3169         if (msb >= 128) r = ratio >> (msb - 127);
3170         else r = ratio << (127 - msb);
3171 
3172         int256 log_2 = (int256(msb) - 128) << 64;
3173 
3174         assembly {
3175             r := shr(127, mul(r, r))
3176             let f := shr(128, r)
3177             log_2 := or(log_2, shl(63, f))
3178             r := shr(f, r)
3179         }
3180         assembly {
3181             r := shr(127, mul(r, r))
3182             let f := shr(128, r)
3183             log_2 := or(log_2, shl(62, f))
3184             r := shr(f, r)
3185         }
3186         assembly {
3187             r := shr(127, mul(r, r))
3188             let f := shr(128, r)
3189             log_2 := or(log_2, shl(61, f))
3190             r := shr(f, r)
3191         }
3192         assembly {
3193             r := shr(127, mul(r, r))
3194             let f := shr(128, r)
3195             log_2 := or(log_2, shl(60, f))
3196             r := shr(f, r)
3197         }
3198         assembly {
3199             r := shr(127, mul(r, r))
3200             let f := shr(128, r)
3201             log_2 := or(log_2, shl(59, f))
3202             r := shr(f, r)
3203         }
3204         assembly {
3205             r := shr(127, mul(r, r))
3206             let f := shr(128, r)
3207             log_2 := or(log_2, shl(58, f))
3208             r := shr(f, r)
3209         }
3210         assembly {
3211             r := shr(127, mul(r, r))
3212             let f := shr(128, r)
3213             log_2 := or(log_2, shl(57, f))
3214             r := shr(f, r)
3215         }
3216         assembly {
3217             r := shr(127, mul(r, r))
3218             let f := shr(128, r)
3219             log_2 := or(log_2, shl(56, f))
3220             r := shr(f, r)
3221         }
3222         assembly {
3223             r := shr(127, mul(r, r))
3224             let f := shr(128, r)
3225             log_2 := or(log_2, shl(55, f))
3226             r := shr(f, r)
3227         }
3228         assembly {
3229             r := shr(127, mul(r, r))
3230             let f := shr(128, r)
3231             log_2 := or(log_2, shl(54, f))
3232             r := shr(f, r)
3233         }
3234         assembly {
3235             r := shr(127, mul(r, r))
3236             let f := shr(128, r)
3237             log_2 := or(log_2, shl(53, f))
3238             r := shr(f, r)
3239         }
3240         assembly {
3241             r := shr(127, mul(r, r))
3242             let f := shr(128, r)
3243             log_2 := or(log_2, shl(52, f))
3244             r := shr(f, r)
3245         }
3246         assembly {
3247             r := shr(127, mul(r, r))
3248             let f := shr(128, r)
3249             log_2 := or(log_2, shl(51, f))
3250             r := shr(f, r)
3251         }
3252         assembly {
3253             r := shr(127, mul(r, r))
3254             let f := shr(128, r)
3255             log_2 := or(log_2, shl(50, f))
3256         }
3257 
3258         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
3259 
3260         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
3261         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
3262 
3263         tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
3264     }
3265 }
3266 
3267 /// @title Contains 512-bit math functions
3268 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
3269 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
3270 library FullMath {
3271     /// @notice Calculates floor(a├ùb├╖denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
3272     /// @param a The multiplicand
3273     /// @param b The multiplier
3274     /// @param denominator The divisor
3275     /// @return result The 256-bit result
3276     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
3277     function mulDiv(
3278         uint256 a,
3279         uint256 b,
3280         uint256 denominator
3281     ) internal pure returns (uint256 result) {
3282         unchecked {
3283         // 512-bit multiply [prod1 prod0] = a * b
3284         // Compute the product mod 2**256 and mod 2**256 - 1
3285         // then use the Chinese Remainder Theorem to reconstruct
3286         // the 512 bit result. The result is stored in two 256
3287         // variables such that product = prod1 * 2**256 + prod0
3288         uint256 prod0; // Least significant 256 bits of the product
3289         uint256 prod1; // Most significant 256 bits of the product
3290         assembly {
3291             let mm := mulmod(a, b, not(0))
3292             prod0 := mul(a, b)
3293             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
3294         }
3295 
3296         // Handle non-overflow cases, 256 by 256 division
3297         if (prod1 == 0) {
3298             require(denominator > 0);
3299             assembly {
3300                 result := div(prod0, denominator)
3301             }
3302             return result;
3303         }
3304 
3305         // Make sure the result is less than 2**256.
3306         // Also prevents denominator == 0
3307         require(denominator > prod1);
3308 
3309         ///////////////////////////////////////////////
3310         // 512 by 256 division.
3311         ///////////////////////////////////////////////
3312 
3313         // Make division exact by subtracting the remainder from [prod1 prod0]
3314         // Compute remainder using mulmod
3315         uint256 remainder;
3316         assembly {
3317             remainder := mulmod(a, b, denominator)
3318         }
3319         // Subtract 256 bit number from 512 bit number
3320         assembly {
3321             prod1 := sub(prod1, gt(remainder, prod0))
3322             prod0 := sub(prod0, remainder)
3323         }
3324 
3325         // Factor powers of two out of denominator
3326         // Compute largest power of two divisor of denominator.
3327         // Always >= 1.
3328         uint256 twos = uint256(-int256(denominator)) & denominator;
3329         // Divide denominator by power of two
3330         assembly {
3331             denominator := div(denominator, twos)
3332         }
3333 
3334         // Divide [prod1 prod0] by the factors of two
3335         assembly {
3336             prod0 := div(prod0, twos)
3337         }
3338         // Shift in bits from prod1 into prod0. For this we need
3339         // to flip `twos` such that it is 2**256 / twos.
3340         // If twos is zero, then it becomes one
3341         assembly {
3342             twos := add(div(sub(0, twos), twos), 1)
3343         }
3344         prod0 |= prod1 * twos;
3345 
3346         // Invert denominator mod 2**256
3347         // Now that denominator is an odd number, it has an inverse
3348         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
3349         // Compute the inverse by starting with a seed that is correct
3350         // correct for four bits. That is, denominator * inv = 1 mod 2**4
3351         uint256 inv = (3 * denominator) ^ 2;
3352         // Now use Newton-Raphson iteration to improve the precision.
3353         // Thanks to Hensel's lifting lemma, this also works in modular
3354         // arithmetic, doubling the correct bits in each step.
3355         inv *= 2 - denominator * inv; // inverse mod 2**8
3356         inv *= 2 - denominator * inv; // inverse mod 2**16
3357         inv *= 2 - denominator * inv; // inverse mod 2**32
3358         inv *= 2 - denominator * inv; // inverse mod 2**64
3359         inv *= 2 - denominator * inv; // inverse mod 2**128
3360         inv *= 2 - denominator * inv; // inverse mod 2**256
3361 
3362         // Because the division is now exact we can divide by multiplying
3363         // with the modular inverse of denominator. This will give us the
3364         // correct result modulo 2**256. Since the precoditions guarantee
3365         // that the outcome is less than 2**256, this is the final result.
3366         // We don't need to compute the high bits of the result and prod1
3367         // is no longer required.
3368         result = prod0 * inv;
3369         return result;
3370         }
3371     }
3372 
3373     /// @notice Calculates ceil(a├ùb├╖denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
3374     /// @param a The multiplicand
3375     /// @param b The multiplier
3376     /// @param denominator The divisor
3377     /// @return result The 256-bit result
3378     function mulDivRoundingUp(
3379         uint256 a,
3380         uint256 b,
3381         uint256 denominator
3382     ) internal pure returns (uint256 result) {
3383         unchecked {
3384         result = mulDiv(a, b, denominator);
3385         if (mulmod(a, b, denominator) > 0) {
3386             require(result < type(uint256).max);
3387             result++;
3388         }
3389         }
3390     }
3391 }
3392 
3393 contract Icosa is ERC20, ReentrancyGuard {
3394 
3395     IHEX    private _hx;
3396     IHedron private _hdrn;
3397     IHEXStakeInstanceManager private _hsim;
3398 
3399     // tunables
3400     uint8   private constant _stakeTypeHDRN         = 0;
3401     uint8   private constant _stakeTypeICSA         = 1;
3402     uint8   private constant _stakeTypeNFT          = 2;
3403     uint256 private constant _decimalResolution     = 1e18;
3404     uint16  private constant _icsaIntitialSeedDays  = 360;
3405     uint16  private constant _minStakeLengthDefault = 30;
3406     uint16  private constant _minStakeLengthSquid   = 90;
3407     uint16  private constant _minStakeLengthDolphin = 180;
3408     uint16  private constant _minStakeLengthShark   = 270;
3409     uint16  private constant _minStakeLengthWhale   = 360;
3410     uint8   private constant _stakeBonusDefault     = 0;
3411     uint8   private constant _stakeBonusSquid       = 5;
3412     uint8   private constant _stakeBonusDolphin     = 10;
3413     uint8   private constant _stakeBonusShark       = 15;
3414     uint8   private constant _stakeBonusWhale       = 20;
3415     uint8   private constant _twapInterval          = 15;
3416     uint8   private constant _waatsaEventLength     = 14;
3417 
3418     // address constants
3419     address         private constant _wethAddress     = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
3420     address         private constant _usdcAddress     = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
3421     address         private constant _hexAddress      = address(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39);
3422     address         private constant _hdrnAddress     = address(0x3819f64f282bf135d62168C1e513280dAF905e06);
3423     address         private constant _maxiAddress     = address(0x0d86EB9f43C57f6FF3BC9E23D8F9d82503f0e84b);
3424     address payable private constant _hdrnFlowAddress = payable(address(0xF447BE386164dADfB5d1e7622613f289F17024D8));
3425 
3426     // We Are All the SA
3427     WeAreAllTheSA               private _waatsa;
3428     mapping(address => address) private _uniswapPools;
3429     address                     public  waatsa;
3430 
3431     // informational
3432     uint256 public launchDay;
3433     uint256 public currentDay;
3434 
3435     // seed liquidity spread out over multiple days
3436     mapping(uint256 => uint256) public hdrnSeedLiquidity;
3437     mapping(uint256 => uint256) public icsaSeedLiquidity;
3438 
3439     // HDRN Staking
3440     mapping(uint256 => uint256)    public hdrnPoolPoints;
3441     mapping(uint256 => uint256)    public hdrnPoolPayout;
3442     mapping(address => StakeStore) public hdrnStakes;
3443     uint256                        public hdrnPoolPointsRemoved;
3444     uint256                        public hdrnPoolIcsaCollected;
3445     
3446     // ICSA Staking
3447     mapping(uint256 => uint256)    public icsaPoolPoints;
3448     mapping(uint256 => uint256)    public icsaPoolPayoutIcsa;
3449     mapping(uint256 => uint256)    public icsaPoolPayoutHdrn;
3450     mapping(address => StakeStore) public icsaStakes;
3451     uint256                        public icsaPoolPointsRemoved;
3452     uint256                        public icsaPoolIcsaCollected;
3453     uint256                        public icsaPoolHdrnCollected;
3454     uint256                        public icsaStakedSupply;
3455     
3456     // NFT Staking
3457     mapping(uint256 => uint256)    public nftPoolPoints;
3458     mapping(uint256 => uint256)    public nftPoolPayout;
3459     mapping(uint256 => StakeStore) public nftStakes;
3460     uint256                        public nftPoolPointsRemoved;
3461     uint256                        public nftPoolIcsaCollected;
3462 
3463     constructor()
3464         ERC20("Icosa", "ICSA")
3465     {
3466         _hx   = IHEX(payable(_hexAddress));
3467         _hdrn = IHedron(_hdrnAddress);
3468         _hsim = IHEXStakeInstanceManager(_hdrn.hsim());
3469 
3470         // get total amount of burnt HDRN
3471         launchDay = currentDay = _hdrn.currentDay();
3472         uint256 hdrnBurntTotal;
3473         for (uint256 i = 0; i <= currentDay; i++) {
3474             HDRNDailyData memory hdrn = _hdrnDailyDataLoad(i);
3475             hdrnBurntTotal += hdrn.dayBurntTotal;
3476         }
3477 
3478         // calculate and seed intitial ICSA liquidity
3479         HEXGlobals memory hx = _hexGlobalsLoad();
3480         uint256 icsaInitialSeedTotal = hdrnBurntTotal / hx.shareRate;
3481         uint256 seedEnd = currentDay + _icsaIntitialSeedDays + 1;
3482         for (uint256 i = currentDay + 1; i < seedEnd; i++) {
3483             icsaSeedLiquidity[i] = icsaInitialSeedTotal / _icsaIntitialSeedDays;
3484         }
3485 
3486         // set up proof of benevolence
3487         _hdrn.approve(_hdrnAddress, type(uint256).max);
3488 
3489         // initialize We Are All the SA
3490         waatsa = address(new WeAreAllTheSA());
3491         _waatsa = WeAreAllTheSA(waatsa);
3492 
3493         // fill uniswap mappings
3494         _uniswapPools[_wethAddress] = address(0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640); // WETH/USDC V3 0.05%
3495         _uniswapPools[_hexAddress]  = address(0x69D91B94f0AaF8e8A2586909fA77A5c2c89818d5); // HEX/USDC  V3 0.3%
3496         _uniswapPools[_hdrnAddress] = address(0xE859041c9C6D70177f83DE991B9d757E13CEA26E); // HDRN/USDC V3 1.0%
3497         _uniswapPools[_maxiAddress] = address(0xF5595d56ccB6Cb87a463C558cAD04f49Faa61149); // MAXI/USDC V3 1.0%
3498     }
3499 
3500     function decimals()
3501         public
3502         view
3503         virtual
3504         override
3505         returns (uint8) 
3506     {
3507         return 9;
3508     }
3509 
3510      event HSIBuyBack(
3511         uint256         price,
3512         address indexed seller,
3513         uint40  indexed stakeId
3514     );
3515 
3516     event HDRNStakeStart(
3517         uint256         data,
3518         address indexed staker
3519     );
3520 
3521     event HDRNStakeAddCapital(
3522         uint256         data,
3523         address indexed staker
3524     );
3525 
3526     event HDRNStakeEnd(
3527         uint256         data,
3528         address indexed staker
3529     );
3530 
3531     event HDRNStakingStats (
3532         uint256         data,
3533         uint256         payout,
3534         uint256 indexed stakeDay
3535     );
3536 
3537     event ICSAStakeStart(
3538         uint256         data,
3539         address indexed staker
3540     );
3541 
3542     event ICSAStakeAddCapital(
3543         uint256         data,
3544         address indexed staker
3545     );
3546 
3547     event ICSAStakeEnd(
3548         uint256         data0,
3549         uint256         data1,
3550         address indexed staker
3551     );
3552 
3553     event ICSAStakingStats (
3554         uint256         data,
3555         uint256         payoutIcsa,
3556         uint256         payoutHdrn,
3557         uint256 indexed stakeDay
3558     );
3559 
3560     event NFTStakeStart(
3561         uint256         data,
3562         address indexed staker,
3563         uint96  indexed nftId,
3564         address indexed tokenAddress
3565     );
3566 
3567     event NFTStakeEnd(
3568         uint256         data,
3569         address indexed staker,
3570         uint96  indexed nftId
3571     );
3572 
3573     event NFTStakingStats (
3574         uint256         data,
3575         uint256         payout,
3576         uint256 indexed stakeDay
3577     );
3578 
3579     /**
3580      * @dev Loads HEX global values from the HEX contract into a "Globals" object.
3581      * @return "HEXGlobals" object containing the global values returned by the HEX contract.
3582      */
3583     function _hexGlobalsLoad()
3584         internal
3585         view
3586         returns (HEXGlobals memory)
3587     {
3588         uint72  lockedHeartsTotal;
3589         uint72  nextStakeSharesTotal;
3590         uint40  shareRate;
3591         uint72  stakePenaltyTotal;
3592         uint16  dailyDataCount;
3593         uint72  stakeSharesTotal;
3594         uint40  latestStakeId;
3595         uint128 claimStats;
3596 
3597         (lockedHeartsTotal,
3598          nextStakeSharesTotal,
3599          shareRate,
3600          stakePenaltyTotal,
3601          dailyDataCount,
3602          stakeSharesTotal,
3603          latestStakeId,
3604          claimStats) = _hx.globals();
3605 
3606         return HEXGlobals(
3607             lockedHeartsTotal,
3608             nextStakeSharesTotal,
3609             shareRate,
3610             stakePenaltyTotal,
3611             dailyDataCount,
3612             stakeSharesTotal,
3613             latestStakeId,
3614             claimStats
3615         );
3616     }
3617 
3618     /**
3619      * @dev Loads Hedron daily values from the Hedron contract into a "HDRNDailyData" object.
3620      * @param hdrnDay The Hedron day to retrieve daily data for.
3621      * @return "HDRNDailyData" object containing the daily values returned by the Hedron contract.
3622      */
3623     function _hdrnDailyDataLoad(uint256 hdrnDay)
3624         internal
3625         view
3626         returns (HDRNDailyData memory)
3627     {
3628         uint72 dayMintedTotal;
3629         uint72 dayLoanedTotal;
3630         uint72 dayBurntTotal;
3631         uint32 dayInterestRate;
3632         uint8  dayMintMultiplier;
3633 
3634         (dayMintedTotal,
3635          dayLoanedTotal,
3636          dayBurntTotal,
3637          dayInterestRate,
3638          dayMintMultiplier
3639          ) = _hdrn.dailyDataList(hdrnDay);
3640 
3641         return HDRNDailyData(
3642             dayMintedTotal,
3643             dayLoanedTotal,
3644             dayBurntTotal,
3645             dayInterestRate,
3646             dayMintMultiplier
3647         );
3648     }
3649 
3650     /**
3651      * @dev Loads share data from a HEX stake instance (HSI) into a "HDRNShareCache" object.
3652      * @param hsi The HSI to load share data from.
3653      * @return "HDRNShareCache" object containing the share data of the HSI.
3654      */
3655     function _hsiLoad(
3656         IHEXStakeInstance hsi
3657     ) 
3658         internal
3659         view
3660         returns (HDRNShareCache memory)
3661     {
3662         HEXStakeMinimal memory stake;
3663 
3664         uint16 mintedDays;
3665         uint8  launchBonus;
3666         uint16 loanStart;
3667         uint16 loanedDays;
3668         uint32 interestRate;
3669         uint8  paymentsMade;
3670         bool   isLoaned;
3671 
3672         (stake,
3673          mintedDays,
3674          launchBonus,
3675          loanStart,
3676          loanedDays,
3677          interestRate,
3678          paymentsMade,
3679          isLoaned) = hsi.share();
3680 
3681         return HDRNShareCache(
3682             stake,
3683             mintedDays,
3684             launchBonus,
3685             loanStart,
3686             loanedDays,
3687             interestRate,
3688             paymentsMade,
3689             isLoaned
3690         );
3691     }
3692 
3693     /**
3694      * @dev Calculates the minimum stake length (in days) based on staker class.
3695      * @param stakerClass Number representing a stakes percentage of total supply
3696      * @return Calculated minimum stake length (in days).
3697      */
3698     function _calcMinStakeLength(
3699         uint256 stakerClass
3700     )
3701         internal
3702         pure
3703         returns (uint256)
3704     {
3705         uint256 minStakeLength = _minStakeLengthDefault;
3706 
3707         if (stakerClass >= (_decimalResolution / 100)) {
3708             minStakeLength = _minStakeLengthWhale;
3709         } else if (stakerClass >= (_decimalResolution / 1000)) {
3710             minStakeLength = _minStakeLengthShark;
3711         } else if (stakerClass >= (_decimalResolution / 10000)) {
3712             minStakeLength = _minStakeLengthDolphin;
3713         } else if (stakerClass >= (_decimalResolution / 100000)) {
3714             minStakeLength = _minStakeLengthSquid;
3715         }
3716 
3717         return minStakeLength;
3718     }
3719 
3720     /**
3721      * @dev Calculates the end stake bonus based on staker class (in days) and base payout.
3722      * @param stakerClass Number representing a stakes percentage of total supply
3723      * @param payout Base payout of the stake.
3724      * @return Amount of bonus tokens
3725      */
3726     function _calcStakeBonus(
3727         uint256 stakerClass,
3728         uint256 payout
3729     )
3730         internal
3731         pure
3732         returns (uint256)
3733     {
3734         uint256 bonus = payout;
3735 
3736         if (stakerClass >= (_decimalResolution / 100)) {
3737             bonus = (payout * (_stakeBonusWhale + _decimalResolution)) / _decimalResolution;
3738         } else if (stakerClass >= (_decimalResolution / 1000)) {
3739             bonus = (payout * (_stakeBonusShark + _decimalResolution)) / _decimalResolution;
3740         } else if (stakerClass >= (_decimalResolution / 10000)) {
3741             bonus = (payout * (_stakeBonusDolphin + _decimalResolution)) / _decimalResolution;
3742         } else if (stakerClass >= (_decimalResolution / 100000)) {
3743             bonus = (payout * (_stakeBonusSquid + _decimalResolution)) / _decimalResolution;
3744         }
3745 
3746         return (bonus - payout);
3747     }
3748 
3749     /**
3750      * @dev Calculates the end stake penalty based on time served.
3751      * @param minStakeDays Minimum stake length of the stake.
3752      * @param servedDays Number of days actually served.
3753      * @param amount Amount of tokens to caculate the penalty against.
3754      * @return The penalized payout and the penalty as separate values.
3755      */
3756     function _calcStakePenalty (
3757         uint256 minStakeDays,
3758         uint256 servedDays,
3759         uint256 amount
3760     )
3761         internal
3762         pure
3763         returns (uint256, uint256)
3764     {
3765         uint256 payout;
3766         uint256 penalty;
3767 
3768         if (servedDays > 0) {
3769             uint256 servedPercentage = (minStakeDays * _decimalResolution) / servedDays;
3770             payout = (amount * _decimalResolution) / servedPercentage;
3771             penalty = (amount - payout);
3772         }
3773         else {
3774             payout = 0;
3775             penalty = amount;
3776         }
3777 
3778         return (payout, penalty); 
3779     }
3780 
3781     /**
3782      * @dev Adds a new stake to the stake mappings.
3783      * @param stakeType Type of stake to add.
3784      * @param stakePoints Amount of points the stake has been allocated.
3785      * @param stakeAmount Amount of tokens staked.
3786      * @param tokenId Token ID of the stake NFT (WAATSA only).
3787      * @param staker Address of the staker (HDRN / ICSA stakes only).
3788      * @param minStakeLength Minimum length the stake must serve without penalties.
3789      */
3790     function _stakeAdd(
3791         uint8   stakeType,
3792         uint256 stakePoints,
3793         uint256 stakeAmount,
3794         uint256 tokenId,
3795         address staker,
3796         uint256 minStakeLength
3797     )
3798         internal
3799     {
3800         if (stakeType == _stakeTypeHDRN) {
3801             hdrnStakes[staker] =
3802                 StakeStore(
3803                     uint64(currentDay),
3804                     uint64(currentDay),
3805                     uint120(stakePoints),
3806                     true,
3807                     uint80(0),
3808                     uint80(0),
3809                     uint80(stakeAmount),
3810                     uint16(minStakeLength)
3811                 );
3812         } else if (stakeType == _stakeTypeICSA) {
3813             icsaStakes[staker] =
3814                 StakeStore(
3815                     uint64(currentDay),
3816                     uint64(currentDay),
3817                     uint120(stakePoints),
3818                     true,
3819                     uint80(0),
3820                     uint80(0),
3821                     uint80(stakeAmount),
3822                     uint16(minStakeLength)
3823                 );
3824         } else if (stakeType == _stakeTypeNFT) {
3825             nftStakes[tokenId] =
3826                 StakeStore(
3827                     uint64(currentDay),
3828                     uint64(currentDay),
3829                     uint120(stakePoints),
3830                     true,
3831                     uint80(0),
3832                     uint80(0),
3833                     uint80(stakeAmount),
3834                     uint16(minStakeLength)
3835                 );
3836         } else {
3837             revert();
3838         }
3839     }
3840 
3841     /**
3842      * @dev Loads values from a "StakeStore" object into a "StakeCache" object.
3843      * @param stakeStore "StakeStore" object to be loaded.
3844      * @param stake "StakeCache" object to be populated with storage data.
3845      */
3846     function _stakeLoad(
3847         StakeStore storage stakeStore,
3848         StakeCache memory  stake
3849     )
3850         internal
3851         view
3852     {
3853         stake._stakeStart              = stakeStore.stakeStart;
3854         stake._capitalAdded            = stakeStore.capitalAdded;
3855         stake._stakePoints             = stakeStore.stakePoints;
3856         stake._isActive                = stakeStore.isActive;
3857         stake._payoutPreCapitalAddIcsa = stakeStore.payoutPreCapitalAddIcsa;
3858         stake._payoutPreCapitalAddHdrn = stakeStore.payoutPreCapitalAddHdrn;
3859         stake._stakeAmount             = stakeStore.stakeAmount;
3860         stake._minStakeLength          = stakeStore.minStakeLength;
3861     }
3862 
3863     /**
3864      * @dev Updates a "StakeStore" object with values stored in a "StakeCache" object.
3865      * @param stakeStore "StakeStore" object to be updated.
3866      * @param stake "StakeCache" object with updated values.
3867      */
3868     function _stakeUpdate(
3869         StakeStore storage stakeStore,
3870         StakeCache memory  stake
3871     )
3872         internal
3873     {
3874         stakeStore.stakeStart              = uint64 (stake._stakeStart);
3875         stakeStore.capitalAdded            = uint64 (stake._capitalAdded);
3876         stakeStore.stakePoints             = uint120(stake._stakePoints);
3877         stakeStore.isActive                = stake._isActive;
3878         stakeStore.payoutPreCapitalAddIcsa = uint80 (stake._payoutPreCapitalAddIcsa);
3879         stakeStore.payoutPreCapitalAddHdrn = uint80 (stake._payoutPreCapitalAddHdrn);
3880         stakeStore.stakeAmount             = uint80 (stake._stakeAmount);
3881         stakeStore.minStakeLength          = uint16 (stake._minStakeLength);
3882     }
3883 
3884     /**
3885      * @dev Updates all stake values which must wait for the follwing day to be
3886      *      properly accounted for. Primarily keeps track of payout per point
3887      *      and stake points per day.
3888      */
3889     function _stakeDailyUpdate ()
3890         internal
3891     {
3892         // Most of the magic happens in this function
3893         
3894         uint256 hdrnDay = _hdrn.currentDay();
3895 
3896         if (currentDay < hdrnDay) {
3897             uint256 daysPast = hdrnDay - currentDay;
3898             
3899             for (uint256 i = 0; i < daysPast; i++) {
3900                 HEXGlobals    memory hx   = _hexGlobalsLoad();
3901                 HDRNDailyData memory hdrn = _hdrnDailyDataLoad(currentDay);
3902 
3903                 uint256 newPoolPoints;
3904 
3905                 // HDRN Staking
3906                 uint256 newHdrnPoolPayout;
3907                 newPoolPoints = (hdrnPoolPoints[currentDay + 1] + hdrnPoolPoints[currentDay]) - hdrnPoolPointsRemoved;
3908 
3909                 // if there are stakes in the pool, else carry the previous day forward.
3910                 if (newPoolPoints > 0) {
3911                     // calculate next day's payout per point
3912                     newHdrnPoolPayout = ((hdrn.dayBurntTotal * _decimalResolution) / hx.shareRate) + (hdrnPoolIcsaCollected * _decimalResolution) + (icsaSeedLiquidity[currentDay + 1] * _decimalResolution);
3913                     newHdrnPoolPayout /= newPoolPoints;
3914                     newHdrnPoolPayout += hdrnPoolPayout[currentDay];
3915 
3916                     // drain the collection
3917                     hdrnPoolIcsaCollected = 0;
3918                 } else {
3919                     newHdrnPoolPayout = hdrnPoolPayout[currentDay];
3920                     
3921                     // carry the would be payout forward until there are stakes in the pool
3922                     hdrnPoolIcsaCollected += (hdrn.dayBurntTotal / hx.shareRate) + icsaSeedLiquidity[currentDay + 1];
3923                 }
3924 
3925                 hdrnPoolPayout[currentDay + 1] = newHdrnPoolPayout;
3926                 hdrnPoolPoints[currentDay + 1] = newPoolPoints;
3927 
3928                 emit HDRNStakingStats (
3929                     uint256(uint48 (block.timestamp))
3930                         |  (uint256(uint104(newPoolPoints)) << 48)
3931                         |  (uint256(uint104(hdrnPoolPointsRemoved)) << 152),
3932                     newHdrnPoolPayout,
3933                     currentDay + 1
3934                 );
3935 
3936                 hdrnPoolPointsRemoved = 0;
3937 
3938                 // ICSA Staking
3939                 uint256 newIcsaPoolPayoutIcsa;
3940                 uint256 newIcsaPoolPayoutHdrn;
3941                 newPoolPoints = (icsaPoolPoints[currentDay + 1] + icsaPoolPoints[currentDay]) - icsaPoolPointsRemoved;
3942 
3943                 // if there are stakes in the pool, else carry the previous day forward.
3944                 if (newPoolPoints > 0) {
3945                     // calculate next day's ICSA payout per point
3946                     newIcsaPoolPayoutIcsa = ((hdrn.dayBurntTotal * _decimalResolution) / hx.shareRate) + (icsaPoolIcsaCollected * _decimalResolution) + (icsaSeedLiquidity[currentDay + 1] * _decimalResolution);
3947                     newIcsaPoolPayoutIcsa /= newPoolPoints;
3948                     newIcsaPoolPayoutIcsa += icsaPoolPayoutIcsa[currentDay];
3949 
3950                     // calculate next day's HDRN payout per point
3951                     newIcsaPoolPayoutHdrn = (icsaPoolHdrnCollected * _decimalResolution) + (hdrnSeedLiquidity[currentDay + 1] * _decimalResolution);
3952                     newIcsaPoolPayoutHdrn /= newPoolPoints;
3953                     newIcsaPoolPayoutHdrn += icsaPoolPayoutHdrn[currentDay];
3954                     // drain the collections
3955                     icsaPoolIcsaCollected = 0;
3956                     icsaPoolHdrnCollected = 0;
3957                 } else {
3958                     newIcsaPoolPayoutIcsa = icsaPoolPayoutIcsa[currentDay];
3959                     newIcsaPoolPayoutHdrn = icsaPoolPayoutHdrn[currentDay];
3960 
3961                     // carry the would be payout forward until there are stakes in the pool
3962                     icsaPoolIcsaCollected += (hdrn.dayBurntTotal / hx.shareRate) + icsaSeedLiquidity[currentDay + 1];
3963                     icsaPoolHdrnCollected += hdrnSeedLiquidity[currentDay + 1];
3964                 }
3965 
3966                 icsaPoolPayoutIcsa[currentDay + 1] = newIcsaPoolPayoutIcsa;
3967                 icsaPoolPayoutHdrn[currentDay + 1] = newIcsaPoolPayoutHdrn;
3968                 icsaPoolPoints[currentDay + 1] = newPoolPoints;
3969 
3970                 emit ICSAStakingStats (
3971                     uint256(uint48 (block.timestamp))
3972                         |  (uint256(uint104(newPoolPoints)) << 48)
3973                         |  (uint256(uint104(icsaPoolPointsRemoved)) << 152),
3974                     newIcsaPoolPayoutIcsa,
3975                     newIcsaPoolPayoutHdrn,
3976                     currentDay + 1
3977                 );
3978 
3979                 icsaPoolPointsRemoved = 0;
3980 
3981                 // NFT Staking
3982                 uint256 newNftPoolPayout;
3983                 newPoolPoints = (nftPoolPoints[currentDay + 1] + nftPoolPoints[currentDay]) - nftPoolPointsRemoved;
3984 
3985                 // if there are stakes in the pool, else carry the previous day forward.
3986                 if (newPoolPoints > 0) {
3987                     // calculate next day's payout per point
3988                     newNftPoolPayout = ((hdrn.dayBurntTotal * _decimalResolution) / hx.shareRate) + (nftPoolIcsaCollected * _decimalResolution) + (icsaSeedLiquidity[currentDay + 1] * _decimalResolution);
3989                     newNftPoolPayout /= newPoolPoints;
3990                     newNftPoolPayout += nftPoolPayout[currentDay];
3991 
3992                     // drain the collection
3993                     nftPoolIcsaCollected = 0;
3994                 } else {
3995                     newNftPoolPayout = nftPoolPayout[currentDay];
3996 
3997                     // carry the would be payout forward until there are stakes in the pool
3998                     nftPoolIcsaCollected += (hdrn.dayBurntTotal / hx.shareRate) + icsaSeedLiquidity[currentDay + 1];
3999                 }
4000                 
4001                 nftPoolPayout[currentDay + 1] = newNftPoolPayout;
4002                 nftPoolPoints[currentDay + 1] = newPoolPoints;
4003 
4004                 emit NFTStakingStats (
4005                     uint256(uint48 (block.timestamp))
4006                         |  (uint256(uint104(newPoolPoints)) << 48)
4007                         |  (uint256(uint104(nftPoolPointsRemoved)) << 152),
4008                     newNftPoolPayout,
4009                     currentDay + 1
4010                 );
4011 
4012                 nftPoolPointsRemoved = 0;
4013 
4014                 // all math is done, advance to the next day
4015                 currentDay++;
4016             }
4017         }
4018     }
4019 
4020     /**
4021      * @dev Fetches time weighted price square root (scaled 2 ** 96) from a uniswap v3 pool. 
4022      * @param uniswapV3Pool Address of the uniswap v3 pool.
4023      * @return Time weighted square root token price (scaled 2 ** 96).
4024      */
4025     function getSqrtTwapX96(
4026         address uniswapV3Pool
4027     )
4028         internal
4029         view 
4030         returns (uint160)
4031     {
4032         uint32[] memory secondsAgos = new uint32[](2);
4033         secondsAgos[0] = _twapInterval;
4034         secondsAgos[1] = 0;
4035 
4036         (int56[] memory tickCumulatives, ) = IUniswapV3Pool(uniswapV3Pool).observe(secondsAgos);
4037 
4038         uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(
4039             int24((tickCumulatives[1] - tickCumulatives[0]) / int8(_twapInterval))
4040         );
4041 
4042         return sqrtPriceX96;
4043     }
4044 
4045     /**
4046      * @dev Converts a uniswap v3 square root price into a token price (scaled 2 ** 96).
4047      * @param sqrtPriceX96 Square root uniswap pool price (scaled 2 ** 96).
4048      * @return Token price (scaled 2 ** 96).
4049      */
4050     function getPriceX96FromSqrtPriceX96(
4051         uint160 sqrtPriceX96
4052     )
4053         internal 
4054         pure
4055         returns(uint256)
4056     {
4057         return FullMath.mulDiv(sqrtPriceX96, sqrtPriceX96, FixedPoint96.Q96);
4058     }
4059 
4060     // External Functions
4061 
4062     // HSI Buy-Back
4063 
4064     /**
4065      * @dev Sells an HSI NFT token to the Icosa contract.
4066      * @param tokenId Token ID of the HSI NFT.
4067      * @return Amount of ICSA paid to the seller.
4068      */
4069     function hexStakeSell (
4070         uint256 tokenId
4071     )
4072         external
4073         nonReentrant
4074         returns (uint256)
4075     {
4076         _stakeDailyUpdate();
4077 
4078         require(_hsim.ownerOf(tokenId) == msg.sender,
4079             "ICSA: NOT OWNER");
4080 
4081         // load HSI stake data and HEX share rate
4082         HDRNShareCache memory share  = _hsiLoad(IHEXStakeInstance(_hsim.hsiToken(tokenId)));
4083         HEXGlobals memory hexGlobals = _hexGlobalsLoad();
4084 
4085         // mint ICSA to the caller
4086         uint256 borrowableHdrn = share._stake.stakeShares * (share._stake.stakedDays - share._mintedDays);
4087         uint256 payout         = borrowableHdrn / (hexGlobals.shareRate / 10);
4088         
4089         require(payout > 0,
4090             "ICSA: LOW VALUE");
4091 
4092         uint256 qcBonus;
4093         uint256 hlBonus = ((payout * (1000 + share._launchBonus)) / 1000) - payout;
4094 
4095         if (share._stake.stakedDays == 5555) {
4096             qcBonus = ((payout * 110) / 100) - payout;
4097         }
4098 
4099         nftPoolIcsaCollected += qcBonus + hlBonus;
4100 
4101         _mint(msg.sender, (payout + qcBonus + hlBonus));
4102 
4103         // transfer and detokenize the HSI
4104         _hsim.transferFrom(msg.sender, address(this), tokenId);
4105         address hsiAddress = _hsim.hexStakeDetokenize(tokenId);
4106         uint256 hsiCount   = _hsim.hsiCount(address(this));
4107 
4108         // borrow HDRN against the HSI
4109         icsaPoolHdrnCollected += _hdrn.loanInstanced(hsiCount - 1, hsiAddress);
4110 
4111         emit HSIBuyBack(payout, msg.sender, share._stake.stakeId);
4112 
4113         return (payout + qcBonus + hlBonus);
4114     }
4115 
4116     // HDRN Staking
4117 
4118     /**
4119      * @dev Starts a HDRN stake.
4120      * @param amount Amount of HDRN to stake.
4121      * @return Number of stake points allocated to the stake.
4122      */
4123     function hdrnStakeStart (
4124         uint256 amount
4125     )
4126         external
4127         nonReentrant
4128         returns (uint256)
4129     {
4130         _stakeDailyUpdate();
4131 
4132         // load stake into memory
4133         StakeCache memory stake;
4134         _stakeLoad(hdrnStakes[msg.sender], stake);
4135 
4136         require(stake._isActive == false,
4137             "ICSA: STAKE EXISTS");
4138 
4139         require(_hdrn.balanceOf(msg.sender) >= amount,
4140             "ICSA: LOW BALANCE");
4141 
4142         // get the HEX share rate and calculate stake points
4143         HEXGlobals memory hexGlobals = _hexGlobalsLoad();
4144         uint256 stakePoints = amount / hexGlobals.shareRate;
4145 
4146         uint256 stakerClass = (amount * _decimalResolution) / _hdrn.totalSupply();
4147         
4148         require(stakePoints > 0,
4149             "ICSA: TOO SMALL");
4150 
4151         uint256 minStakeLength = _calcMinStakeLength(stakerClass);
4152 
4153         // add stake entry
4154         _stakeAdd (
4155             _stakeTypeHDRN,
4156             stakePoints,
4157             amount,
4158             0,
4159             msg.sender,
4160             minStakeLength
4161         );
4162 
4163         // add stake to the pool (following day)
4164         hdrnPoolPoints[currentDay + 1] += stakePoints;
4165 
4166         // transfer HDRN to the contract and return stake points
4167         _hdrn.transferFrom(msg.sender, address(this), amount);
4168 
4169         emit HDRNStakeStart(
4170             uint256(uint40 (block.timestamp))
4171                 |  (uint256(uint120(stakePoints))    << 40)
4172                 |  (uint256(uint80 (amount))         << 160)
4173                 |  (uint256(uint16 (minStakeLength)) << 240),
4174             msg.sender
4175         );
4176 
4177         return stakePoints;
4178     }
4179 
4180     /**
4181      * @dev Adds more HDRN to an existing stake.
4182      * @param amount Amount of HDRN to add to the stake.
4183      * @return Number of stake points allocated to the stake.
4184      */
4185     function hdrnStakeAddCapital (
4186         uint256 amount
4187     )
4188         external
4189         nonReentrant
4190         returns (uint256)
4191     {
4192         _stakeDailyUpdate();
4193 
4194         // load stake into memory
4195         StakeCache memory stake;
4196         _stakeLoad(hdrnStakes[msg.sender], stake);
4197 
4198         require(stake._isActive == true,
4199             "ICSA: NO STAKE");
4200 
4201         require(_hdrn.balanceOf(msg.sender) >= amount,
4202             "ICSA: LOW BALANCE");
4203 
4204         // get the HEX share rate and calculate additional stake points
4205         HEXGlobals memory hexGlobals = _hexGlobalsLoad();
4206         uint256 stakePoints = amount / hexGlobals.shareRate;
4207 
4208         uint256 stakerClass = ((stake._stakeAmount + amount) * _decimalResolution) / _hdrn.totalSupply();
4209 
4210         require(stakePoints > 0,
4211             "ICSA: TOO SMALL");
4212 
4213         // lock in payout from previous stake points
4214         uint256 payoutPerPoint = hdrnPoolPayout[currentDay] - hdrnPoolPayout[stake._capitalAdded];
4215         uint256 payout = (stake._stakePoints * payoutPerPoint) / _decimalResolution;
4216 
4217         uint256 minStakeLength = _calcMinStakeLength(stakerClass);
4218 
4219         // update stake entry
4220         stake._capitalAdded             = currentDay;
4221         stake._stakePoints             += stakePoints;
4222         stake._payoutPreCapitalAddIcsa += payout;
4223         stake._stakeAmount             += amount;
4224         stake._minStakeLength           = minStakeLength;
4225         _stakeUpdate(hdrnStakes[msg.sender], stake);
4226 
4227         // add additional points to the pool (following day)
4228         hdrnPoolPoints[currentDay + 1] += stakePoints;
4229 
4230         // transfer HDRN to the contract and return stake points
4231         _hdrn.transferFrom(msg.sender, address(this), amount);
4232 
4233         emit HDRNStakeAddCapital(
4234             uint256(uint40 (block.timestamp))
4235                 |  (uint256(uint120(stakePoints))    << 40)
4236                 |  (uint256(uint80 (amount))         << 160)
4237                 |  (uint256(uint16 (minStakeLength)) << 240),
4238             msg.sender
4239         );
4240 
4241         return stake._stakePoints;
4242     }
4243 
4244     /**
4245      * @dev Ends a HDRN stake.
4246      * @return ICSA yield, HDRN principal penalty, ICSA yield penalty.
4247      */
4248     function hdrnStakeEnd () 
4249         external
4250         nonReentrant
4251         returns (uint256, uint256, uint256)
4252     {
4253         _stakeDailyUpdate();
4254 
4255         // load stake into memory
4256         StakeCache memory stake;
4257         _stakeLoad(hdrnStakes[msg.sender], stake);
4258 
4259         require(stake._isActive == true,
4260             "ICSA: NO STAKE");
4261 
4262         // ended pending stake, just reverse it.
4263         if (stake._stakeStart == currentDay) {
4264             // return staked principal
4265             _hdrn.transfer(msg.sender, stake._stakeAmount);
4266 
4267             // remove points from the pool
4268             hdrnPoolPointsRemoved += stake._stakePoints;
4269 
4270             // update stake entry
4271             stake._stakeStart              = 0;
4272             stake._capitalAdded            = 0;
4273             stake._stakePoints             = 0;
4274             stake._isActive                = false;
4275             stake._payoutPreCapitalAddIcsa = 0;
4276             stake._stakeAmount             = 0;
4277             stake._minStakeLength          = 0;
4278             _stakeUpdate(hdrnStakes[msg.sender], stake);
4279 
4280             emit HDRNStakeEnd(
4281             uint256(uint40 (block.timestamp))
4282                 |  (uint256(uint72(0)) << 40)
4283                 |  (uint256(uint72(0)) << 112)
4284                 |  (uint256(uint72(0)) << 184),
4285             msg.sender
4286             );
4287 
4288             return (0,0,0);
4289         }
4290 
4291         // calculate payout per point
4292         uint256 payoutPerPoint = hdrnPoolPayout[currentDay] - hdrnPoolPayout[stake._capitalAdded];
4293 
4294         uint256 payout;
4295         uint256 bonus;
4296         uint256 payoutPenalty;
4297         uint256 principal;
4298         uint256 principalPenalty;
4299 
4300         if ((stake._capitalAdded + stake._minStakeLength) > currentDay) {
4301             uint256 servedDays = currentDay - stake._capitalAdded;
4302             
4303             payout = stake._payoutPreCapitalAddIcsa + ((stake._stakePoints * payoutPerPoint) / _decimalResolution);
4304             (payout, payoutPenalty) = _calcStakePenalty(stake._minStakeLength, servedDays, payout);
4305 
4306             // distribute ICSA penalties
4307             hdrnPoolIcsaCollected += payoutPenalty / 3;
4308             icsaPoolIcsaCollected += payoutPenalty / 3;
4309             nftPoolIcsaCollected  += payoutPenalty / 3;
4310 
4311             principal = stake._stakeAmount;
4312             (principal, principalPenalty) = _calcStakePenalty(stake._minStakeLength, servedDays, principal);
4313 
4314             // distribute HDRN penalties
4315             _hdrn.proofOfBenevolence(principalPenalty / 2);
4316             icsaPoolHdrnCollected += principalPenalty / 2;
4317         } else {
4318             uint256 stakerClass = (stake._stakeAmount * _decimalResolution) / _hdrn.totalSupply();
4319 
4320             payout = stake._payoutPreCapitalAddIcsa + ((stake._stakePoints * payoutPerPoint) / _decimalResolution);
4321             bonus  = _calcStakeBonus(stakerClass, payout);
4322             principal = stake._stakeAmount;
4323         }
4324 
4325         // remove points from the pool
4326         hdrnPoolPointsRemoved += stake._stakePoints;
4327 
4328         // update stake entry
4329         stake._stakeStart              = 0;
4330         stake._capitalAdded            = 0;
4331         stake._stakePoints             = 0;
4332         stake._isActive                = false;
4333         stake._payoutPreCapitalAddIcsa = 0;
4334         stake._stakeAmount             = 0;
4335         stake._minStakeLength          = 0;
4336         _stakeUpdate(hdrnStakes[msg.sender], stake);
4337 
4338         nftPoolIcsaCollected += bonus;
4339 
4340         // mint ICSA and return payout
4341         if (payout > 0) { _mint(msg.sender, (payout + bonus)); }
4342 
4343         // return staked principal
4344         if (principal > 0) { _hdrn.transfer(msg.sender, principal); }
4345 
4346         emit HDRNStakeEnd(
4347             uint256(uint40 (block.timestamp))
4348                 |  (uint256(uint72(payout + bonus))   << 40)
4349                 |  (uint256(uint72(principalPenalty)) << 112)
4350                 |  (uint256(uint72(payoutPenalty))    << 184),
4351             msg.sender
4352         );
4353 
4354         return ((payout + bonus), principalPenalty, payoutPenalty);
4355     }
4356 
4357     // ICSA Staking
4358 
4359     /**
4360      * @dev Starts an ICSA stake.
4361      * @param amount Amount of ICSA to stake.
4362      * @return Number of stake points allocated to the stake.
4363      */
4364     function icsaStakeStart (
4365         uint256 amount
4366     )
4367         external
4368         nonReentrant
4369         returns (uint256)
4370     {
4371         _stakeDailyUpdate();
4372 
4373         // load stake into memory
4374         StakeCache memory stake;
4375         _stakeLoad(icsaStakes[msg.sender], stake);
4376 
4377         require(stake._isActive == false,
4378             "ICSA: STAKE EXISTS");
4379 
4380         require(balanceOf(msg.sender) >= amount,
4381             "ICSA: LOW BALANCE");
4382 
4383         // get the HEX share rate and calculate stake points
4384         HEXGlobals memory hexGlobals = _hexGlobalsLoad();
4385         uint256 stakePoints = amount / hexGlobals.shareRate;
4386 
4387         uint256 stakerClass = (amount * _decimalResolution) / totalSupply();
4388         
4389         require(stakePoints > 0,
4390             "ICSA: TOO SMALL");
4391 
4392         uint256 minStakeLength = _calcMinStakeLength(stakerClass);
4393 
4394         // add stake entry
4395         _stakeAdd (
4396             _stakeTypeICSA,
4397             stakePoints,
4398             amount,
4399             0,
4400             msg.sender,
4401             minStakeLength
4402         );
4403 
4404         // add stake to the pool (following day)
4405         icsaPoolPoints[currentDay + 1] += stakePoints;
4406 
4407         // increase staked supply metric
4408         icsaStakedSupply += amount;
4409 
4410         // temporarily burn stakers ICSA
4411         _burn(msg.sender, amount);
4412 
4413         emit ICSAStakeStart(
4414             uint256(uint40 (block.timestamp))
4415                 |  (uint256(uint120(stakePoints))    << 40)
4416                 |  (uint256(uint80 (amount))         << 160)
4417                 |  (uint256(uint16 (minStakeLength)) << 240),
4418             msg.sender
4419         );
4420 
4421         return stakePoints;
4422     }
4423 
4424     /**
4425      * @dev Adds more ICSA to an existing stake.
4426      * @param amount Amount of ICSA to add to the stake.
4427      * @return Number of stake points allocated to the stake.
4428      */
4429     function icsaStakeAddCapital (
4430         uint256 amount
4431     )
4432         external
4433         nonReentrant
4434         returns (uint256)
4435     {
4436         _stakeDailyUpdate();
4437 
4438         // load stake into memory
4439         StakeCache memory stake;
4440         _stakeLoad(icsaStakes[msg.sender], stake);
4441 
4442         require(stake._isActive == true,
4443             "ICSA: NO STAKE");
4444 
4445         require(balanceOf(msg.sender) >= amount,
4446             "ICSA: LOW BALANCE");
4447 
4448         // get the HEX share rate and calculate additional stake points
4449         HEXGlobals memory hexGlobals = _hexGlobalsLoad();
4450         uint256 stakePoints = amount / hexGlobals.shareRate;
4451 
4452         uint256 stakerClass = ((stake._stakeAmount + amount) * _decimalResolution) / totalSupply();
4453 
4454         require(stakePoints > 0,
4455             "ICSA: TOO SMALL");
4456 
4457         // lock in payout from previous stake points
4458         uint256 payoutPerPointIcsa = icsaPoolPayoutIcsa[currentDay] - icsaPoolPayoutIcsa[stake._capitalAdded];
4459         uint256 payoutIcsa = (stake._stakePoints * payoutPerPointIcsa) / _decimalResolution;
4460 
4461         uint256 payoutPerPointHdrn = icsaPoolPayoutHdrn[currentDay] - icsaPoolPayoutHdrn[stake._capitalAdded];
4462         uint256 payoutHdrn = (stake._stakePoints * payoutPerPointHdrn) / _decimalResolution;
4463 
4464         uint256 minStakeLength = _calcMinStakeLength(stakerClass);
4465 
4466         // update stake entry
4467         stake._capitalAdded             = currentDay;
4468         stake._stakePoints             += stakePoints;
4469         stake._payoutPreCapitalAddIcsa += payoutIcsa;
4470         stake._payoutPreCapitalAddHdrn += payoutHdrn;
4471         stake._stakeAmount             += amount;
4472         stake._minStakeLength           = minStakeLength;
4473         _stakeUpdate(icsaStakes[msg.sender], stake);
4474 
4475         // add additional points to the pool (following day)
4476         icsaPoolPoints[currentDay + 1] += stakePoints;
4477 
4478         // increase staked supply metric
4479         icsaStakedSupply += amount;
4480 
4481         // temporarily burn stakers ICSA
4482         _burn(msg.sender, amount);
4483 
4484         emit ICSAStakeAddCapital(
4485             uint256(uint40 (block.timestamp))
4486                 |  (uint256(uint120(stakePoints))    << 40)
4487                 |  (uint256(uint80 (amount))         << 160)
4488                 |  (uint256(uint16 (minStakeLength)) << 240),
4489             msg.sender
4490         );
4491 
4492         return stake._stakePoints;
4493     }
4494 
4495     /**
4496      * @dev Ends an ICSA stake.
4497      * @return ICSA yield, HDRN yield, ICSA principal penalty, HDRN yield penalty, ICSA yield penalty.
4498      */
4499     function icsaStakeEnd () 
4500         external
4501         nonReentrant
4502         returns (uint256, uint256, uint256, uint256, uint256)
4503     {
4504         _stakeDailyUpdate();
4505 
4506         // load stake into memory
4507         StakeCache memory stake;
4508         _stakeLoad(icsaStakes[msg.sender], stake);
4509 
4510         require(stake._isActive == true,
4511             "ICSA: NO STAKE");
4512 
4513         // ended pending stake, just reverse it.
4514         if (stake._stakeStart == currentDay) {
4515             // return staked principal
4516             _mint(msg.sender, stake._stakeAmount);
4517             
4518             // remove points from the pool
4519             icsaPoolPointsRemoved += stake._stakePoints;
4520 
4521             // decrease staked supply metric
4522             icsaStakedSupply -= stake._stakeAmount;
4523 
4524             // update stake entry
4525             stake._stakeStart              = 0;
4526             stake._capitalAdded            = 0;
4527             stake._stakePoints             = 0;
4528             stake._isActive                = false;
4529             stake._payoutPreCapitalAddIcsa = 0;
4530             stake._payoutPreCapitalAddHdrn = 0;
4531             stake._stakeAmount             = 0;
4532             stake._minStakeLength          = 0;
4533             _stakeUpdate(icsaStakes[msg.sender], stake);
4534 
4535             emit ICSAStakeEnd(
4536             uint256(uint40 (block.timestamp))
4537                 |  (uint256(uint72(0)) << 40)
4538                 |  (uint256(uint72(0)) << 112)
4539                 |  (uint256(uint72(0)) << 184),
4540             uint256(uint128(0))
4541                 |  (uint256(uint128(0)) << 128),
4542             msg.sender
4543             );
4544 
4545             return (0,0,0,0,0);
4546         }
4547 
4548         // calculate payout per point
4549         uint256 payoutPerPointIcsa = icsaPoolPayoutIcsa[currentDay] - icsaPoolPayoutIcsa[stake._capitalAdded];
4550         uint256 payoutPerPointHdrn = icsaPoolPayoutHdrn[currentDay] - icsaPoolPayoutHdrn[stake._capitalAdded];
4551 
4552         uint256 payoutIcsa;
4553         uint256 bonusIcsa;
4554         uint256 payoutHdrn;
4555         uint256 payoutPenaltyIcsa;
4556         uint256 payoutPenaltyHdrn;
4557         uint256 principal;
4558         uint256 principalPenalty;
4559 
4560         if ((stake._capitalAdded + stake._minStakeLength) > currentDay) {
4561             uint256 servedDays = currentDay - stake._capitalAdded;
4562             
4563             payoutIcsa = stake._payoutPreCapitalAddIcsa + ((stake._stakePoints * payoutPerPointIcsa) / _decimalResolution);
4564             (payoutIcsa, payoutPenaltyIcsa) = _calcStakePenalty(stake._minStakeLength, servedDays, payoutIcsa);
4565 
4566             payoutHdrn = stake._payoutPreCapitalAddHdrn + ((stake._stakePoints * payoutPerPointHdrn) / _decimalResolution);
4567             (payoutHdrn, payoutPenaltyHdrn) = _calcStakePenalty(stake._minStakeLength, servedDays, payoutHdrn);
4568 
4569             principal = stake._stakeAmount;
4570             (principal, principalPenalty) = _calcStakePenalty(stake._minStakeLength, servedDays, principal);
4571 
4572             // distribute ICSA penalties
4573             hdrnPoolIcsaCollected += (payoutPenaltyIcsa + principalPenalty) / 3;
4574             icsaPoolIcsaCollected += (payoutPenaltyIcsa + principalPenalty) / 3;
4575             nftPoolIcsaCollected  += (payoutPenaltyIcsa + principalPenalty) / 3;
4576 
4577             // distribute HDRN penalties
4578             _hdrn.proofOfBenevolence(payoutPenaltyHdrn / 2);
4579             icsaPoolHdrnCollected += payoutPenaltyHdrn / 2;
4580         } else {
4581             uint256 stakerClass = (stake._stakeAmount * _decimalResolution) / totalSupply();
4582 
4583             payoutIcsa = stake._payoutPreCapitalAddIcsa + ((stake._stakePoints * payoutPerPointIcsa) / _decimalResolution);
4584             payoutHdrn = stake._payoutPreCapitalAddHdrn + ((stake._stakePoints * payoutPerPointHdrn) / _decimalResolution);
4585             bonusIcsa = _calcStakeBonus(stakerClass, payoutIcsa);
4586             principal = stake._stakeAmount;
4587         }
4588 
4589         // remove points from the pool
4590         icsaPoolPointsRemoved += stake._stakePoints;
4591 
4592         // decrease staked supply metric
4593         icsaStakedSupply -= stake._stakeAmount;
4594 
4595         // update stake entry
4596         stake._stakeStart              = 0;
4597         stake._capitalAdded            = 0;
4598         stake._stakePoints             = 0;
4599         stake._isActive                = false;
4600         stake._payoutPreCapitalAddIcsa = 0;
4601         stake._payoutPreCapitalAddHdrn = 0;
4602         stake._stakeAmount             = 0;
4603         stake._minStakeLength          = 0;
4604         _stakeUpdate(icsaStakes[msg.sender], stake);
4605 
4606         nftPoolIcsaCollected += bonusIcsa;
4607 
4608         // mint ICSA
4609         if (payoutIcsa + principal > 0) { _mint(msg.sender, (payoutIcsa + principal + bonusIcsa)); }
4610 
4611         // transfer HDRN
4612         if (payoutHdrn > 0) { _hdrn.transfer(msg.sender, payoutHdrn); }
4613 
4614         emit ICSAStakeEnd(
4615             uint256(uint40 (block.timestamp))
4616                 |  (uint256(uint72(payoutIcsa + bonusIcsa))       << 40)
4617                 |  (uint256(uint72(payoutHdrn))       << 112)
4618                 |  (uint256(uint72(principalPenalty)) << 184),
4619             uint256(uint128(payoutPenaltyIcsa))
4620                 |  (uint256(uint128(payoutPenaltyHdrn)) << 128),
4621             msg.sender
4622         );
4623 
4624         return ((payoutIcsa + bonusIcsa), payoutHdrn, principalPenalty, payoutPenaltyIcsa, payoutPenaltyHdrn);
4625     }
4626 
4627     // NFT Staking
4628 
4629     /**
4630      * @dev Starts an NFT stake.
4631      * @param amount Amount of tokens to buy the NFT with.
4632      * @param tokenAddress Address of the token contract.
4633      * @return Number of stake points allocated to the stake.
4634      */
4635     function nftStakeStart (
4636         uint256 amount,
4637         address tokenAddress
4638     )
4639         external
4640         payable
4641         nonReentrant
4642         returns (uint256)
4643     {
4644         _stakeDailyUpdate();
4645 
4646         require(currentDay < (launchDay + _waatsaEventLength),
4647             "ICSA: TOO LATE");
4648 
4649         // Fallback in case PulseChain launches mid-WAATSA
4650         require(block.chainid == 1,
4651             "ICSA: BAD CHAIN");
4652 
4653         uint256 tokenPrice;
4654         uint256 stakePoints;
4655 
4656         IERC20 token = IERC20(tokenAddress);
4657 
4658         // ETH handler
4659         if (tokenAddress == address(0)) {
4660 
4661             // amount does not match sent eth, nuke transaction.
4662             if (amount != msg.value) {
4663                 revert();
4664             }
4665 
4666             // weth pools are backwards for some reason.
4667             tokenPrice = getPriceX96FromSqrtPriceX96(getSqrtTwapX96(_uniswapPools[_wethAddress]));
4668             stakePoints = (amount * (2**96)) / tokenPrice;
4669             
4670             _hdrnFlowAddress.transfer(amount);
4671         }
4672 
4673         // ERC20 handler
4674         else {
4675             address uniswapPool = _uniswapPools[tokenAddress];
4676 
4677             // invalid token, nuke the transaction.
4678             if (tokenAddress != _usdcAddress && uniswapPool == address(0)) {
4679                 revert();
4680             }
4681 
4682             if (tokenAddress != _usdcAddress) {
4683                 // weth pools are backwards for some reason.
4684                 if (tokenAddress == _wethAddress) {
4685                     tokenPrice = getPriceX96FromSqrtPriceX96(getSqrtTwapX96(uniswapPool));
4686                     stakePoints = (amount * (2**96)) / tokenPrice;
4687                 }
4688 
4689                 else {
4690                     tokenPrice = getPriceX96FromSqrtPriceX96(getSqrtTwapX96(uniswapPool));
4691                     stakePoints = (amount * tokenPrice) / (2 ** 96);
4692                 }
4693             }
4694 
4695             else {
4696                 stakePoints = amount;
4697             }
4698 
4699             token.transferFrom(msg.sender, _hdrnFlowAddress, amount);
4700         }
4701 
4702         require(stakePoints > 0,
4703             "ICSA: TOO SMALL");
4704 
4705         uint256 nftId = _waatsa.mintStakeNft(msg.sender);
4706 
4707         // add stake entry
4708         _stakeAdd (
4709             _stakeTypeNFT,
4710             stakePoints,
4711             0,
4712             nftId,
4713             address(0),
4714             0
4715         );
4716 
4717         // add stake to the pool (following day)
4718         nftPoolPoints[currentDay + 1] += stakePoints;
4719 
4720         emit NFTStakeStart(
4721             uint256(uint40 (block.timestamp))
4722                 |  (uint256(uint216(stakePoints)) << 40),
4723             msg.sender,
4724             uint96(nftId),
4725             tokenAddress
4726         );
4727 
4728         return stakePoints;
4729     }
4730 
4731     /**
4732      * @dev Ends an NFT stake.
4733      * @param nftId Token id of the staking NFT.
4734      * @return ICSA yield.
4735      */
4736     function nftStakeEnd (
4737         uint256 nftId
4738     ) 
4739         external
4740         nonReentrant
4741         returns (uint256)
4742     {
4743         _stakeDailyUpdate();
4744 
4745         require(_waatsa.ownerOf(nftId) == msg.sender,
4746             "ICSA: NOT OWNER");
4747         
4748         // load stake into memory
4749         StakeCache memory stake;
4750         _stakeLoad(nftStakes[nftId], stake);
4751 
4752         require(stake._isActive == true,
4753             "ICSA: NO STAKE");
4754 
4755         uint256 payoutPerPoint = nftPoolPayout[currentDay] - nftPoolPayout[stake._capitalAdded];
4756         uint256 payout = (stake._stakePoints * payoutPerPoint) / _decimalResolution;
4757 
4758         // remove points from the pool
4759         nftPoolPointsRemoved += stake._stakePoints;
4760 
4761         // update stake entry
4762         stake._stakeStart              = 0;
4763         stake._capitalAdded            = 0;
4764         stake._stakePoints             = 0;
4765         stake._isActive                = false;
4766         stake._payoutPreCapitalAddIcsa = 0;
4767         stake._payoutPreCapitalAddHdrn = 0;
4768         stake._stakeAmount             = 0;
4769         stake._minStakeLength          = 0;
4770         _stakeUpdate(nftStakes[nftId], stake);
4771 
4772         // mint ICSA
4773         if (payout > 0 ) { _mint(msg.sender, payout); }
4774         _waatsa.burnStakeNft(nftId);
4775 
4776         emit NFTStakeEnd(
4777             uint256(uint40 (block.timestamp))
4778                 |  (uint256(uint216(payout)) << 40),
4779             msg.sender,
4780             uint96(nftId)
4781         );
4782 
4783         return payout;
4784     }
4785 
4786     function injectSeedLiquidity (
4787         uint256 amount,
4788         uint256 seedDays
4789     ) 
4790         external
4791         nonReentrant
4792     {
4793         require(_hdrn.balanceOf(msg.sender) >= amount,
4794             "ICSA: LOW BALANCE");
4795 
4796         require(seedDays >= 1,
4797             "ICSA: LOW SEED");
4798 
4799         // calculate and seed ICSA liquidity
4800         HEXGlobals memory hx = _hexGlobalsLoad();
4801         uint256 icsaSeedTotal = amount / hx.shareRate;
4802         uint256 seedEnd = currentDay + seedDays + 1;
4803 
4804         for (uint256 i = currentDay + 1; i < seedEnd; i++) {
4805             icsaSeedLiquidity[i] += icsaSeedTotal / seedDays;
4806             hdrnSeedLiquidity[i] += amount / seedDays;
4807         }
4808 
4809         _hdrn.transferFrom(msg.sender, address(this), amount);
4810     }
4811 
4812     // Overrides
4813 
4814     /* In short, _stakeDailyUpdate needs to be called in all possible cases.
4815        This is to ensure the gas limit is never exceeded. By overriding these
4816        functions we ensure it is always called given any contract interraction. */
4817     
4818     function approve(
4819         address spender,
4820         uint256 amount
4821     ) 
4822         public
4823         virtual
4824         override
4825         returns (bool) 
4826     {
4827         _stakeDailyUpdate();
4828         return super.approve(spender, amount);
4829     }
4830 
4831     function transfer(
4832         address to,
4833         uint256 amount
4834     )
4835         public
4836         virtual
4837         override
4838         returns (bool)
4839     {
4840         _stakeDailyUpdate();
4841         return super.transfer(to, amount);
4842     }
4843 
4844     function transferFrom(
4845         address from,
4846         address to,
4847         uint256 amount
4848     )
4849         public
4850         virtual
4851         override
4852         returns (bool)
4853     {
4854         _stakeDailyUpdate();
4855         return super.transferFrom(from, to, amount);
4856     }
4857 }