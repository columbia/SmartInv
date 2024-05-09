1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File contracts/interfaces/IUniswapV3Factory.sol
4 
5 // SPDX-License-Identifier: GPL-2.0-or-later
6 pragma solidity ^0.8.0;
7 
8 /// @title The interface for the Uniswap V3 Factory
9 /// @notice The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees
10 interface IUniswapV3Factory {
11     /// @notice Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist
12     /// @dev tokenA and tokenB may be passed in either token0/token1 or token1/token0 order
13     /// @param tokenA The contract address of either token0 or token1
14     /// @param tokenB The contract address of the other token
15     /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
16     /// @return pool The pool address
17     function getPool(
18         address tokenA,
19         address tokenB,
20         uint24 fee
21     ) external view returns (address pool);
22 
23     /// @notice Creates a pool for the given two tokens and fee
24     /// @param tokenA One of the two tokens in the desired pool
25     /// @param tokenB The other of the two tokens in the desired pool
26     /// @param fee The desired fee for the pool
27     /// @dev tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
28     /// from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
29     /// are invalid.
30     /// @return pool The address of the newly created pool
31     function createPool(
32         address tokenA,
33         address tokenB,
34         uint24 fee
35     ) external returns (address pool);
36 }
37 
38 
39 // File contracts/interfaces/IUniswapV3Pool.sol
40 
41 interface IUniswapV3Pool {
42     /// @notice Sets the initial price for the pool
43     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
44     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
45     function initialize(uint160 sqrtPriceX96) external;
46 
47     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
48     /// when accessed externally.
49     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
50     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
51     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
52     /// boundary.
53     /// observationIndex The index of the last oracle observation that was written,
54     /// observationCardinality The current maximum number of observations stored in the pool,
55     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
56     /// feeProtocol The protocol fee for both tokens of the pool.
57     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
58     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
59     /// unlocked Whether the pool is currently locked to reentrancy
60     function slot0()
61         external
62         view
63         returns (
64             uint160 sqrtPriceX96,
65             int24 tick,
66             uint16 observationIndex,
67             uint16 observationCardinality,
68             uint16 observationCardinalityNext,
69             uint8 feeProtocol,
70             bool unlocked
71         );
72 
73     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
74     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
75     /// the input observationCardinalityNext.
76     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
77     function increaseObservationCardinalityNext(
78         uint16 observationCardinalityNext
79     ) external;
80 
81     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
82     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
83     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
84     /// you must call it with secondsAgos = [3600, 0].
85     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
86     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
87     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
88     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
89     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
90     /// timestamp
91     function observe(uint32[] calldata secondsAgos)
92         external
93         view
94         returns (
95             int56[] memory tickCumulatives,
96             uint160[] memory secondsPerLiquidityCumulativeX128s
97         );
98 }
99 
100 
101 // File contracts/libraries/Ownable.sol
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable {
116     address private _owner;
117 
118     event OwnershipTransferred(
119         address indexed previousOwner,
120         address indexed newOwner
121     );
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(msg.sender);
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == msg.sender, "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(
162             newOwner != address(0),
163             "Ownable: new owner is the zero address"
164         );
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 
180 // File contracts/interfaces/IERC20.sol
181 
182 interface IERC20 {
183     function totalSupply() external view returns (uint256);
184 
185     function balanceOf(address account) external view returns (uint256);
186 
187     function transfer(address recipient, uint256 amount)
188         external
189         returns (bool);
190 
191     function allowance(address owner, address spender)
192         external
193         view
194         returns (uint256);
195 
196     function approve(address spender, uint256 amount) external returns (bool);
197 
198     function transferFrom(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) external returns (bool);
203 
204     event Transfer(address indexed from, address indexed to, uint256 value);
205     event Approval(
206         address indexed owner,
207         address indexed spender,
208         uint256 value
209     );
210 }
211 
212 
213 // File contracts/libraries/ERC20.sol
214 
215 /**
216  * @dev Implementation of the {IERC20} interface.
217  *
218  * This implementation is agnostic to the way tokens are created. This means
219  * that a supply mechanism has to be added in a derived contract using {_mint}.
220  * For a generic mechanism see {ERC20PresetMinterPauser}.
221  *
222  * TIP: For a detailed writeup see our guide
223  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
224  * to implement supply mechanisms].
225  *
226  * We have followed general OpenZeppelin Contracts guidelines: functions revert
227  * instead returning `false` on failure. This behavior is nonetheless
228  * conventional and does not conflict with the expectations of ERC20
229  * applications.
230  *
231  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
232  * This allows applications to reconstruct the allowance for all accounts just
233  * by listening to said events. Other implementations of the EIP may not emit
234  * these events, as it isn't required by the specification.
235  *
236  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
237  * functions have been added to mitigate the well-known issues around setting
238  * allowances. See {IERC20-approve}.
239  */
240 contract ERC20 is IERC20 {
241     mapping(address => uint256) private _balances;
242 
243     mapping(address => mapping(address => uint256)) private _allowances;
244 
245     uint256 private _totalSupply;
246 
247     string private _name;
248     string private _symbol;
249     uint8 private _decimals;
250 
251     /**
252      * @dev Sets the values for {name} and {symbol}.
253      *
254      * The default value of {decimals} is 18. To select a different value for
255      * {decimals} you should overload it.
256      *
257      * All two of these values are immutable: they can only be set once during
258      * construction.
259      */
260     constructor(
261         string memory name_,
262         string memory symbol_,
263         uint8 decimals_
264     ) {
265         _name = name_;
266         _symbol = symbol_;
267         _decimals = decimals_;
268     }
269 
270     /**
271      * @dev Returns the name of the token.
272      */
273     function name() public view virtual returns (string memory) {
274         return _name;
275     }
276 
277     /**
278      * @dev Returns the symbol of the token, usually a shorter version of the
279      * name.
280      */
281     function symbol() public view virtual returns (string memory) {
282         return _symbol;
283     }
284 
285     /**
286      * @dev Returns the number of decimals used to get its user representation.
287      * For example, if `decimals` equals `2`, a balance of `505` tokens should
288      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
289      *
290      * Tokens usually opt for a value of 18, imitating the relationship between
291      * Ether and Wei. This is the value {ERC20} uses, unless this function is
292      * overridden;
293      *
294      * NOTE: This information is only used for _display_ purposes: it in
295      * no way affects any of the arithmetic of the contract, including
296      * {IERC20-balanceOf} and {IERC20-transfer}.
297      */
298     function decimals() public view virtual returns (uint8) {
299         return _decimals;
300     }
301 
302     /**
303      * @dev See {IERC20-totalSupply}.
304      */
305     function totalSupply() public view virtual override returns (uint256) {
306         return _totalSupply;
307     }
308 
309     /**
310      * @dev See {IERC20-balanceOf}.
311      */
312     function balanceOf(address account)
313         public
314         view
315         virtual
316         override
317         returns (uint256)
318     {
319         return _balances[account];
320     }
321 
322     /**
323      * @dev See {IERC20-transfer}.
324      *
325      * Requirements:
326      *
327      * - `recipient` cannot be the zero address.
328      * - the caller must have a balance of at least `amount`.
329      */
330     function transfer(address recipient, uint256 amount)
331         public
332         virtual
333         override
334         returns (bool)
335     {
336         _transfer(msg.sender, recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender)
344         public
345         view
346         virtual
347         override
348         returns (uint256)
349     {
350         return _allowances[owner][spender];
351     }
352 
353     /**
354      * @dev See {IERC20-approve}.
355      *
356      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
357      * `transferFrom`. This is semantically equivalent to an infinite approval.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function approve(address spender, uint256 amount)
364         public
365         virtual
366         override
367         returns (bool)
368     {
369         _approve(msg.sender, spender, amount);
370         return true;
371     }
372 
373     /**
374      * @dev See {IERC20-transferFrom}.
375      *
376      * Emits an {Approval} event indicating the updated allowance. This is not
377      * required by the EIP. See the note at the beginning of {ERC20}.
378      *
379      * NOTE: Does not update the allowance if the current allowance
380      * is the maximum `uint256`.
381      *
382      * Requirements:
383      *
384      * - `sender` and `recipient` cannot be the zero address.
385      * - `sender` must have a balance of at least `amount`.
386      * - the caller must have allowance for ``sender``'s tokens of at least
387      * `amount`.
388      */
389     function transferFrom(
390         address sender,
391         address recipient,
392         uint256 amount
393     ) public virtual override returns (bool) {
394         uint256 currentAllowance = _allowances[sender][msg.sender];
395         if (currentAllowance != type(uint256).max) {
396             require(
397                 currentAllowance >= amount,
398                 "ERC20: transfer amount exceeds allowance"
399             );
400             unchecked {
401                 _approve(sender, msg.sender, currentAllowance - amount);
402             }
403         }
404 
405         _transfer(sender, recipient, amount);
406 
407         return true;
408     }
409 
410     /**
411      * @dev Atomically increases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      */
422     function increaseAllowance(address spender, uint256 addedValue)
423         public
424         virtual
425         returns (bool)
426     {
427         _approve(
428             msg.sender,
429             spender,
430             _allowances[msg.sender][spender] + addedValue
431         );
432         return true;
433     }
434 
435     /**
436      * @dev Atomically decreases the allowance granted to `spender` by the caller.
437      *
438      * This is an alternative to {approve} that can be used as a mitigation for
439      * problems described in {IERC20-approve}.
440      *
441      * Emits an {Approval} event indicating the updated allowance.
442      *
443      * Requirements:
444      *
445      * - `spender` cannot be the zero address.
446      * - `spender` must have allowance for the caller of at least
447      * `subtractedValue`.
448      */
449     function decreaseAllowance(address spender, uint256 subtractedValue)
450         public
451         virtual
452         returns (bool)
453     {
454         uint256 currentAllowance = _allowances[msg.sender][spender];
455         require(
456             currentAllowance >= subtractedValue,
457             "ERC20: decreased allowance below zero"
458         );
459         unchecked {
460             _approve(msg.sender, spender, currentAllowance - subtractedValue);
461         }
462 
463         return true;
464     }
465 
466     /**
467      * @dev Moves `amount` of tokens from `sender` to `recipient`.
468      *
469      * This internal function is equivalent to {transfer}, and can be used to
470      * e.g. implement automatic token fees, slashing mechanisms, etc.
471      *
472      * Emits a {Transfer} event.
473      *
474      * Requirements:
475      *
476      * - `sender` cannot be the zero address.
477      * - `recipient` cannot be the zero address.
478      * - `sender` must have a balance of at least `amount`.
479      */
480     function _transfer(
481         address sender,
482         address recipient,
483         uint256 amount
484     ) internal virtual {
485         require(sender != address(0), "ERC20: transfer from the zero address");
486         require(recipient != address(0), "ERC20: transfer to the zero address");
487 
488         _beforeTokenTransfer(sender, recipient, amount);
489 
490         uint256 senderBalance = _balances[sender];
491         require(
492             senderBalance >= amount,
493             "ERC20: transfer amount exceeds balance"
494         );
495         unchecked {
496             _balances[sender] = senderBalance - amount;
497         }
498         _balances[recipient] += amount;
499 
500         emit Transfer(sender, recipient, amount);
501 
502         _afterTokenTransfer(sender, recipient, amount);
503     }
504 
505     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
506      * the total supply.
507      *
508      * Emits a {Transfer} event with `from` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      */
514     function _mint(address account, uint256 amount) internal virtual {
515         require(account != address(0), "ERC20: mint to the zero address");
516 
517         _beforeTokenTransfer(address(0), account, amount);
518 
519         _totalSupply += amount;
520         _balances[account] += amount;
521         emit Transfer(address(0), account, amount);
522 
523         _afterTokenTransfer(address(0), account, amount);
524     }
525 
526     /**
527      * @dev Destroys `amount` tokens from `account`, reducing the
528      * total supply.
529      *
530      * Emits a {Transfer} event with `to` set to the zero address.
531      *
532      * Requirements:
533      *
534      * - `account` cannot be the zero address.
535      * - `account` must have at least `amount` tokens.
536      */
537     function _burn(address account, uint256 amount) internal virtual {
538         require(account != address(0), "ERC20: burn from the zero address");
539 
540         _beforeTokenTransfer(account, address(0), amount);
541 
542         uint256 accountBalance = _balances[account];
543         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
544         unchecked {
545             _balances[account] = accountBalance - amount;
546         }
547         _totalSupply -= amount;
548 
549         emit Transfer(account, address(0), amount);
550 
551         _afterTokenTransfer(account, address(0), amount);
552     }
553 
554     /**
555      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
556      *
557      * This internal function is equivalent to `approve`, and can be used to
558      * e.g. set automatic allowances for certain subsystems, etc.
559      *
560      * Emits an {Approval} event.
561      *
562      * Requirements:
563      *
564      * - `owner` cannot be the zero address.
565      * - `spender` cannot be the zero address.
566      */
567     function _approve(
568         address owner,
569         address spender,
570         uint256 amount
571     ) internal virtual {
572         require(owner != address(0), "ERC20: approve from the zero address");
573         require(spender != address(0), "ERC20: approve to the zero address");
574 
575         _allowances[owner][spender] = amount;
576         emit Approval(owner, spender, amount);
577     }
578 
579     /**
580      * @dev Hook that is called before any transfer of tokens. This includes
581      * minting and burning.
582      *
583      * Calling conditions:
584      *
585      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
586      * will be transferred to `to`.
587      * - when `from` is zero, `amount` tokens will be minted for `to`.
588      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
589      * - `from` and `to` are never both zero.
590      *
591      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
592      */
593     function _beforeTokenTransfer(
594         address from,
595         address to,
596         uint256 amount
597     ) internal virtual {}
598 
599     /**
600      * @dev Hook that is called after any transfer of tokens. This includes
601      * minting and burning.
602      *
603      * Calling conditions:
604      *
605      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
606      * has been transferred to `to`.
607      * - when `from` is zero, `amount` tokens have been minted for `to`.
608      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
609      * - `from` and `to` are never both zero.
610      *
611      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
612      */
613     function _afterTokenTransfer(
614         address from,
615         address to,
616         uint256 amount
617     ) internal virtual {}
618 }
619 
620 
621 // File contracts/libraries/Math.sol
622 
623 library Math {
624     function compound(uint256 rewardRateX96, uint256 nCompounds)
625         internal
626         pure
627         returns (uint256 compoundedX96)
628     {
629         if (nCompounds == 0) {
630             compoundedX96 = 2**96;
631         } else if (nCompounds == 1) {
632             compoundedX96 = rewardRateX96;
633         } else {
634             compoundedX96 = compound(rewardRateX96, nCompounds / 2);
635             compoundedX96 = mulX96(compoundedX96, compoundedX96);
636 
637             if (nCompounds % 2 == 1) {
638                 compoundedX96 = mulX96(compoundedX96, rewardRateX96);
639             }
640         }
641     }
642 
643     // ref: https://blogs.sas.com/content/iml/2016/05/16/babylonian-square-roots.html
644     function sqrt(uint256 x) internal pure returns (uint256 y) {
645         uint256 z = (x + 1) / 2;
646         y = x;
647         while (z < y) {
648             y = z;
649             z = (x / z + z) / 2;
650         }
651     }
652 
653     function mulX96(uint256 x, uint256 y) internal pure returns (uint256 z) {
654         z = (x * y) >> 96;
655     }
656 
657     function divX96(uint256 x, uint256 y) internal pure returns (uint256 z) {
658         z = (x << 96) / y;
659     }
660 
661     function max(uint256 a, uint256 b) internal pure returns (uint256) {
662         return a >= b ? a : b;
663     }
664 
665     function min(uint256 a, uint256 b) internal pure returns (uint256) {
666         return a < b ? a : b;
667     }
668 }
669 
670 
671 // File contracts/libraries/TickMath.sol
672 
673 /// @title Math library for computing sqrt prices from ticks and vice versa
674 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
675 /// prices between 2**-128 and 2**128
676 library TickMath {
677     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
678     int24 internal constant MIN_TICK = -887272;
679     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
680     int24 internal constant MAX_TICK = -MIN_TICK;
681 
682     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
683     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
684     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
685     uint160 internal constant MAX_SQRT_RATIO =
686         1461446703485210103287273052203988822378723970342;
687 
688     /// @notice Calculates sqrt(1.0001^tick) * 2^96
689     /// @dev Throws if |tick| > max tick
690     /// @param tick The input tick for the above formula
691     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
692     /// at the given tick
693     function getSqrtRatioAtTick(int24 tick)
694         internal
695         pure
696         returns (uint160 sqrtPriceX96)
697     {
698         uint256 absTick = tick < 0
699             ? uint256(-int256(tick))
700             : uint256(int256(tick));
701         require(absTick <= uint256(int256(MAX_TICK)), "T");
702 
703         uint256 ratio = absTick & 0x1 != 0
704             ? 0xfffcb933bd6fad37aa2d162d1a594001
705             : 0x100000000000000000000000000000000;
706         if (absTick & 0x2 != 0)
707             ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
708         if (absTick & 0x4 != 0)
709             ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
710         if (absTick & 0x8 != 0)
711             ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
712         if (absTick & 0x10 != 0)
713             ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
714         if (absTick & 0x20 != 0)
715             ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
716         if (absTick & 0x40 != 0)
717             ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
718         if (absTick & 0x80 != 0)
719             ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
720         if (absTick & 0x100 != 0)
721             ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
722         if (absTick & 0x200 != 0)
723             ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
724         if (absTick & 0x400 != 0)
725             ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
726         if (absTick & 0x800 != 0)
727             ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
728         if (absTick & 0x1000 != 0)
729             ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
730         if (absTick & 0x2000 != 0)
731             ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
732         if (absTick & 0x4000 != 0)
733             ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
734         if (absTick & 0x8000 != 0)
735             ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
736         if (absTick & 0x10000 != 0)
737             ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
738         if (absTick & 0x20000 != 0)
739             ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
740         if (absTick & 0x40000 != 0)
741             ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
742         if (absTick & 0x80000 != 0)
743             ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
744 
745         if (tick > 0) ratio = type(uint256).max / ratio;
746 
747         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
748         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
749         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
750         sqrtPriceX96 = uint160(
751             (ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1)
752         );
753     }
754 
755     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
756     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
757     /// ever return.
758     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
759     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
760     function getTickAtSqrtRatio(uint160 sqrtPriceX96)
761         internal
762         pure
763         returns (int24 tick)
764     {
765         // second inequality must be < because the price can never reach the price at the max tick
766         require(
767             sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO,
768             "R"
769         );
770         uint256 ratio = uint256(sqrtPriceX96) << 32;
771 
772         uint256 r = ratio;
773         uint256 msb = 0;
774 
775         assembly {
776             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
777             msb := or(msb, f)
778             r := shr(f, r)
779         }
780         assembly {
781             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
782             msb := or(msb, f)
783             r := shr(f, r)
784         }
785         assembly {
786             let f := shl(5, gt(r, 0xFFFFFFFF))
787             msb := or(msb, f)
788             r := shr(f, r)
789         }
790         assembly {
791             let f := shl(4, gt(r, 0xFFFF))
792             msb := or(msb, f)
793             r := shr(f, r)
794         }
795         assembly {
796             let f := shl(3, gt(r, 0xFF))
797             msb := or(msb, f)
798             r := shr(f, r)
799         }
800         assembly {
801             let f := shl(2, gt(r, 0xF))
802             msb := or(msb, f)
803             r := shr(f, r)
804         }
805         assembly {
806             let f := shl(1, gt(r, 0x3))
807             msb := or(msb, f)
808             r := shr(f, r)
809         }
810         assembly {
811             let f := gt(r, 0x1)
812             msb := or(msb, f)
813         }
814 
815         if (msb >= 128) r = ratio >> (msb - 127);
816         else r = ratio << (127 - msb);
817 
818         int256 log_2 = (int256(msb) - 128) << 64;
819 
820         assembly {
821             r := shr(127, mul(r, r))
822             let f := shr(128, r)
823             log_2 := or(log_2, shl(63, f))
824             r := shr(f, r)
825         }
826         assembly {
827             r := shr(127, mul(r, r))
828             let f := shr(128, r)
829             log_2 := or(log_2, shl(62, f))
830             r := shr(f, r)
831         }
832         assembly {
833             r := shr(127, mul(r, r))
834             let f := shr(128, r)
835             log_2 := or(log_2, shl(61, f))
836             r := shr(f, r)
837         }
838         assembly {
839             r := shr(127, mul(r, r))
840             let f := shr(128, r)
841             log_2 := or(log_2, shl(60, f))
842             r := shr(f, r)
843         }
844         assembly {
845             r := shr(127, mul(r, r))
846             let f := shr(128, r)
847             log_2 := or(log_2, shl(59, f))
848             r := shr(f, r)
849         }
850         assembly {
851             r := shr(127, mul(r, r))
852             let f := shr(128, r)
853             log_2 := or(log_2, shl(58, f))
854             r := shr(f, r)
855         }
856         assembly {
857             r := shr(127, mul(r, r))
858             let f := shr(128, r)
859             log_2 := or(log_2, shl(57, f))
860             r := shr(f, r)
861         }
862         assembly {
863             r := shr(127, mul(r, r))
864             let f := shr(128, r)
865             log_2 := or(log_2, shl(56, f))
866             r := shr(f, r)
867         }
868         assembly {
869             r := shr(127, mul(r, r))
870             let f := shr(128, r)
871             log_2 := or(log_2, shl(55, f))
872             r := shr(f, r)
873         }
874         assembly {
875             r := shr(127, mul(r, r))
876             let f := shr(128, r)
877             log_2 := or(log_2, shl(54, f))
878             r := shr(f, r)
879         }
880         assembly {
881             r := shr(127, mul(r, r))
882             let f := shr(128, r)
883             log_2 := or(log_2, shl(53, f))
884             r := shr(f, r)
885         }
886         assembly {
887             r := shr(127, mul(r, r))
888             let f := shr(128, r)
889             log_2 := or(log_2, shl(52, f))
890             r := shr(f, r)
891         }
892         assembly {
893             r := shr(127, mul(r, r))
894             let f := shr(128, r)
895             log_2 := or(log_2, shl(51, f))
896             r := shr(f, r)
897         }
898         assembly {
899             r := shr(127, mul(r, r))
900             let f := shr(128, r)
901             log_2 := or(log_2, shl(50, f))
902         }
903 
904         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
905 
906         int24 tickLow = int24(
907             (log_sqrt10001 - 3402992956809132418596140100660247210) >> 128
908         );
909         int24 tickHi = int24(
910             (log_sqrt10001 + 291339464771989622907027621153398088495) >> 128
911         );
912 
913         tick = tickLow == tickHi
914             ? tickLow
915             : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96
916             ? tickHi
917             : tickLow;
918     }
919 }
920 
921 
922 // File contracts/Const.sol
923 
924 int24 constant INITIAL_QLT_PRICE_TICK = -23000; // QLT_USDC price ~ 100.0
925 
926 // initial values
927 uint24 constant UNISWAP_POOL_FEE = 10000;
928 int24 constant UNISWAP_POOL_TICK_SPACING = 200;
929 uint16 constant UNISWAP_POOL_OBSERVATION_CADINALITY = 64;
930 
931 // default values
932 uint256 constant DEFAULT_MIN_MINT_PRICE_X96 = 100 * Q96;
933 uint32 constant DEFAULT_TWAP_DURATION = 1 hours;
934 uint32 constant DEFAULT_UNSTAKE_LOCKUP_PERIOD = 3 days;
935 
936 // floating point math
937 uint256 constant Q96 = 2**96;
938 uint256 constant MX96 = Q96 / 10**6;
939 uint256 constant TX96 = Q96 / 10**12;
940 
941 // ERC-20 contract addresses
942 address constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
943 address constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
944 address constant USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
945 address constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
946 address constant BUSD = address(0x4Fabb145d64652a948d72533023f6E7A623C7C53);
947 address constant FRAX = address(0x853d955aCEf822Db058eb8505911ED77F175b99e);
948 address constant WBTC = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
949 
950 // Uniswap, see `https://docs.uniswap.org/protocol/reference/deployments`
951 address constant UNISWAP_FACTORY = address(
952     0x1F98431c8aD98523631AE4a59f267346ea31F984
953 );
954 address constant UNISWAP_ROUTER = address(
955     0xE592427A0AEce92De3Edee1F18E0157C05861564
956 );
957 address constant UNISWAP_NFP_MGR = address(
958     0xC36442b4a4522E871399CD717aBDD847Ab11FE88
959 );
960 
961 
962 // File contracts/QLT.sol
963 
964 contract QLT is ERC20, Ownable {
965     event Mint(address indexed account, uint256 amount);
966     event Burn(uint256 amount);
967 
968     mapping(address => bool) public authorizedMinters;
969 
970     constructor() ERC20("Quantland", "QLT", 9) {
971         require(
972             address(this) < USDC,
973             "QLT contract address must be smaller than USDC token contract address"
974         );
975         authorizedMinters[msg.sender] = true;
976 
977         // deploy uniswap pool
978         IUniswapV3Pool pool = IUniswapV3Pool(
979             IUniswapV3Factory(UNISWAP_FACTORY).createPool(
980                 address(this),
981                 USDC,
982                 UNISWAP_POOL_FEE
983             )
984         );
985         pool.initialize(TickMath.getSqrtRatioAtTick(INITIAL_QLT_PRICE_TICK));
986         pool.increaseObservationCardinalityNext(
987             UNISWAP_POOL_OBSERVATION_CADINALITY
988         );
989     }
990 
991     function mint(address account, uint256 amount)
992         external
993         onlyAuthorizedMinter
994     {
995         _mint(account, amount);
996 
997         emit Mint(account, amount);
998     }
999 
1000     function burn(uint256 amount) external onlyOwner {
1001         _burn(msg.sender, amount);
1002 
1003         emit Burn(amount);
1004     }
1005 
1006     /* Access Control */
1007     modifier onlyAuthorizedMinter() {
1008         require(authorizedMinters[msg.sender], "not authorized minter");
1009         _;
1010     }
1011 
1012     function addAuthorizedMinter(address account) external onlyOwner {
1013         authorizedMinters[account] = true;
1014     }
1015 
1016     function removeAuthorizedMinter(address account) external onlyOwner {
1017         authorizedMinters[account] = false;
1018     }
1019 }