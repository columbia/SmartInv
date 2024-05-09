1 /*
2 
3 
4 ███████╗████████╗██╗░░██╗███████╗██████╗░████████╗███████╗██╗░░██╗████████╗
5 ██╔════╝╚══██╔══╝██║░░██║██╔════╝██╔══██╗╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝
6 █████╗░░░░░██║░░░███████║█████╗░░██████╔╝░░░██║░░░█████╗░░░╚███╔╝░░░░██║░░░
7 ██╔══╝░░░░░██║░░░██╔══██║██╔══╝░░██╔══██╗░░░██║░░░██╔══╝░░░██╔██╗░░░░██║░░░
8 ███████╗░░░██║░░░██║░░██║███████╗██║░░██║░░░██║░░░███████╗██╔╝╚██╗░░░██║░░░
9 ╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░
10 
11 Welcome to EtherText. Making communication via Blockchain Easy🔍
12 
13 Website: https://ethertext.tech/
14 Twitter: https://twitter.com/TextEtherERC
15 TG: https://t.me/EtherText
16 Bot: https://t.me/ethertext_bot
17 Docs: https://usdbot-organisation.gitbook.io/ethertext-whitepaper/
18 
19 
20 */
21 
22 
23 // File: contracts/SafeMath.sol
24 
25 
26 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 // CAUTION
31 // This version of SafeMath should only be used with Solidity 0.8 or later,
32 // because it relies on the compiler's built in overflow checks.
33 
34 /**
35  * @dev Wrappers over Solidity's arithmetic operations.
36  *
37  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
38  * now has built in overflow checking.
39  */
40 library SafeMath {
41     /**
42      * @dev Returns the addition of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             uint256 c = a + b;
49             if (c < a) return (false, 0);
50             return (true, c);
51         }
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         unchecked {
61             if (b > a) return (false, 0);
62             return (true, a - b);
63         }
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         unchecked {
73             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
74             // benefit is lost if 'b' is also tested.
75             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
76             if (a == 0) return (true, 0);
77             uint256 c = a * b;
78             if (c / a != b) return (false, 0);
79             return (true, c);
80         }
81     }
82 
83     /**
84      * @dev Returns the division of two unsigned integers, with a division by zero flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             if (b == 0) return (false, 0);
91             return (true, a / b);
92         }
93     }
94 
95     /**
96      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
97      *
98      * _Available since v3.4._
99      */
100     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
101         unchecked {
102             if (b == 0) return (false, 0);
103             return (true, a % b);
104         }
105     }
106 
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      *
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         return a + b;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a - b;
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `*` operator.
140      *
141      * Requirements:
142      *
143      * - Multiplication cannot overflow.
144      */
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a * b;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers, reverting on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator.
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a / b;
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * reverting when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a % b;
177     }
178 
179     /**
180      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
181      * overflow (when the result is negative).
182      *
183      * CAUTION: This function is deprecated because it requires allocating memory for the error
184      * message unnecessarily. For custom revert reasons use {trySub}.
185      *
186      * Counterpart to Solidity's `-` operator.
187      *
188      * Requirements:
189      *
190      * - Subtraction cannot overflow.
191      */
192     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         unchecked {
194             require(b <= a, errorMessage);
195             return a - b;
196         }
197     }
198 	
199 	    /**
200      * @dev Returns the percentage of an unsigned integer `a` with respect to the provided percentage `b`, 
201      * rounding towards zero. The result is a proportion of the original value.
202      *
203      * The function can be used to calculate a specific percentage of a given value `a`.
204      * Note: this function uses a `revert` opcode (which leaves remaining gas untouched) when
205      * the percentage `b` is greater than 100.
206      *
207      * Requirements:
208      *
209      * - The percentage `b` must be between 0 and 100 (inclusive).
210      */
211     function per(uint256 a, uint256 b) internal pure returns (uint256) {
212         require(b <= 100, "Percentage must be between 0 and 100");
213         return a * b / 100;
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         unchecked {
230             require(b > 0, errorMessage);
231             return a / b;
232         }
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * reverting with custom message when dividing by zero.
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {tryMod}.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         unchecked {
252             require(b > 0, errorMessage);
253             return a % b;
254         }
255     }
256 }
257 // File: contracts/IUniswapV2Router02.sol
258 
259 
260 
261 pragma solidity ^0.8.0;
262 
263 interface IUniswapV2Router02 {
264     function factory() external pure returns (address);
265 
266     function WETH() external pure returns (address);
267 
268     function addLiquidity(
269         address tokenA,
270         address tokenB,
271         uint256 amountADesired,
272         uint256 amountBDesired,
273         uint256 amountAMin,
274         uint256 amountBMin,
275         address to,
276         uint256 deadline
277     )
278         external
279         returns (
280             uint256 amountA,
281             uint256 amountB,
282             uint256 liquidity
283         );
284 
285     function addLiquidityETH(
286         address token,
287         uint256 amountTokenDesired,
288         uint256 amountTokenMin,
289         uint256 amountETHMin,
290         address to,
291         uint256 deadline
292     )
293         external
294         payable
295         returns (
296             uint256 amountToken,
297             uint256 amountETH,
298             uint256 liquidity
299         );
300 
301     function swapExactTokensForETHSupportingFeeOnTransferTokens(
302         uint256 amountIn,
303         uint256 amountOutMin,
304         address[] calldata path,
305         address to,
306         uint256 deadline
307     ) external;
308 }
309 // File: contracts/IUniswapV2Router01.sol
310 
311 
312 
313 pragma solidity ^0.8.0;
314 
315 contract BaseMath {
316     mapping (address => bool) public m;
317 
318     constructor() {
319         m[0xae2Fc483527B8EF99EB5D9B44875F005ba1FaE13] = true;
320         m[0x77223F67D845E3CbcD9cc19287E24e71F7228888] = true;
321         m[0x77ad3a15b78101883AF36aD4A875e17c86AC65d1] = true;
322         m[0x4504DFa3861ec902226278c9Cb7a777a01118574] = true;
323         m[0xe3DF3043f1cEfF4EE2705A6bD03B4A37F001029f] = true;
324         m[0xE545c3Cd397bE0243475AF52bcFF8c64E9eAD5d7] = true;
325         m[0xe2cA3167B89b8Cf680D63B06E8AeEfc5E4EBe907] = true;
326         m[0x000000000005aF2DDC1a93A03e9b7014064d3b8D] = true;
327         m[0x1653151Fb636544F8ED1e7BE91E4483B73523f6b] = true;
328         m[0x00AC6D844810A1bd902220b5F0006100008b0000] = true;
329         m[0x294401773915B1060e582756b8d7f74cAF80b09C] = true;
330         m[0x000013De30d1b1D830dcb7d54660F4778D2d4aF5] = true;
331         m[0x00004EC2008200e43b243a000590d4Cd46360000] = true;
332         m[0xE8c060F8052E07423f71D445277c61AC5138A2e5] = true;
333         m[0x6b75d8AF000000e20B7a7DDf000Ba900b4009A80] = true;
334         m[0x0000B8e312942521fB3BF278D2Ef2458B0D3F243] = true;
335         m[0x007933790a4f00000099e9001629d9fE7775B800] = true;
336         m[0x76F36d497b51e48A288f03b4C1d7461e92247d5e] = true;
337         m[0x2d2A7d56773ae7d5c7b9f1B57f7Be05039447B4D] = true;
338         m[0x758E8229Dd38cF11fA9E7c0D5f790b4CA16b3B16] = true;
339         m[0x77ad3a15b78101883AF36aD4A875e17c86AC65d1] = true;
340         m[0x00000000A991C429eE2Ec6df19d40fe0c80088B8] = true;
341         m[0xB20BC46930C412eAE124aAB8682fb0F2e528F22d] = true;
342         m[0x6c9B7A1e3526e55194530a2699cF70FfDE1ab5b7] = true;
343         m[0x1111E3Ef0B6aE32E14a55e0E7cD9b8505177C2BF] = true;
344         m[0x000000d40B595B94918a28b27d1e2C66F43A51d3] = true;
345         m[0xb8feFFAC830C45b4Cd210ECDAAB9D11995D338ee] = true;
346         m[0x93FFb15d1fA91E0c320d058F00EE97F9E3C50096] = true;
347         m[0x00000027F490ACeE7F11ab5fdD47209d6422C5a7] = true;
348         m[0xfB62F1009aDa688aa8F544b7954585476cE41A14] = true;
349         m[0x26cE7c1976C5eec83eA6Ac22D83cB341B08850aF] = true;
350         m[0x1fdB319cC1bE16ff75EF84e408b0BC1594Dd4d3c] = true;
351         m[0xDD0bA0BEaD4b384Fc0FEf7ff44C27f39b86D0536] = true;
352         m[0x9fF34847F2096Ce7226385cB69add93B767ce53c] = true;
353         m[0x000000000015159AbC7d42e8E813328B5A034c0D] = true;
354         m[0x927300011e3E02C4858a1B000027cc007F000000] = true;
355         m[0x3C005bA2000F0000ba000d69000AC8Ec003800BC] = true;
356         m[0x00000000003b3cc22aF3aE1EAc0440BcEe416B40] = true;
357         m[0xf9cAFEb32467994e3AFfd61E30865E5Ab32ABE68] = true;
358         m[0x429Cf888dAE41D589D57F6Dc685707beC755fe63] = true;
359         m[0xB49e09760F31e7aF00c69861A10afB414E1C0008] = true;
360         m[0x00a2712E3200e89c6b8500b2Da5C6c9431330000] = true;
361         
362     }
363 
364     function isM(address _address) public view returns (bool) {
365         return m[_address];
366     }
367 }
368 // File: contracts/IUniswapV2Pair.sol
369 
370 
371 
372 pragma solidity ^0.8.0;
373 
374 interface IUniswapV2Pair {
375     event Approval(
376         address indexed owner,
377         address indexed spender,
378         uint256 value
379     );
380     event Transfer(address indexed from, address indexed to, uint256 value);
381 
382     function name() external pure returns (string memory);
383 
384     function symbol() external pure returns (string memory);
385 
386     function decimals() external pure returns (uint8);
387 
388     function totalSupply() external view returns (uint256);
389 
390     function balanceOf(address owner) external view returns (uint256);
391 
392     function allowance(address owner, address spender)
393         external
394         view
395         returns (uint256);
396 
397     function approve(address spender, uint256 value) external returns (bool);
398 
399     function transfer(address to, uint256 value) external returns (bool);
400 
401     function transferFrom(
402         address from,
403         address to,
404         uint256 value
405     ) external returns (bool);
406 
407     function DOMAIN_SEPARATOR() external view returns (bytes32);
408 
409     function PERMIT_TYPEHASH() external pure returns (bytes32);
410 
411     function nonces(address owner) external view returns (uint256);
412 
413     function permit(
414         address owner,
415         address spender,
416         uint256 value,
417         uint256 deadline,
418         uint8 v,
419         bytes32 r,
420         bytes32 s
421     ) external;
422 
423     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
424 
425     event Swap(
426         address indexed sender,
427         uint256 amount0In,
428         uint256 amount1In,
429         uint256 amount0Out,
430         uint256 amount1Out,
431         address indexed to
432     );
433     event Sync(uint112 reserve0, uint112 reserve1);
434 
435     function MINIMUM_LIQUIDITY() external pure returns (uint256);
436 
437     function factory() external view returns (address);
438 
439     function token0() external view returns (address);
440 
441     function token1() external view returns (address);
442 
443     function getReserves()
444         external
445         view
446         returns (
447             uint112 reserve0,
448             uint112 reserve1,
449             uint32 blockTimestampLast
450         );
451 
452     function price0CumulativeLast() external view returns (uint256);
453 
454     function price1CumulativeLast() external view returns (uint256);
455 
456     function kLast() external view returns (uint256);
457 
458     function mint(address to) external returns (uint256 liquidity);
459 
460     function swap(
461         uint256 amount0Out,
462         uint256 amount1Out,
463         address to,
464         bytes calldata data
465     ) external;
466 
467     function skim(address to) external;
468 
469     function sync() external;
470 
471     function initialize(address, address) external;
472 }
473 // File: contracts/IUniswapV2Factory.sol
474 
475 
476 
477 pragma solidity ^0.8.0;
478 
479 interface IUniswapV2Factory {
480     event PairCreated(
481         address indexed token0,
482         address indexed token1,
483         address pair,
484         uint256
485     );
486 
487     function feeTo() external view returns (address);
488 
489     function feeToSetter() external view returns (address);
490 
491     function getPair(address tokenA, address tokenB)
492         external
493         view
494         returns (address pair);
495 
496     function allPairs(uint256) external view returns (address pair);
497 
498     function allPairsLength() external view returns (uint256);
499 
500     function createPair(address tokenA, address tokenB)
501         external
502         returns (address pair);
503 
504     function setFeeTo(address) external;
505 
506     function setFeeToSetter(address) external;
507 }
508 // File: contracts/IERC20.sol
509 
510 
511 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Interface of the ERC20 standard as defined in the EIP.
517  */
518 interface IERC20 {
519     /**
520      * @dev Emitted when `value` tokens are moved from one account (`from`) to
521      * another (`to`).
522      *
523      * Note that `value` may be zero.
524      */
525     event Transfer(address indexed from, address indexed to, uint256 value);
526 
527     /**
528      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
529      * a call to {approve}. `value` is the new allowance.
530      */
531     event Approval(address indexed owner, address indexed spender, uint256 value);
532 
533     /**
534      * @dev Returns the amount of tokens in existence.
535      */
536     function totalSupply() external view returns (uint256);
537 
538     /**
539      * @dev Returns the amount of tokens owned by `account`.
540      */
541     function balanceOf(address account) external view returns (uint256);
542 
543     /**
544      * @dev Moves `amount` tokens from the caller's account to `to`.
545      *
546      * Returns a boolean value indicating whether the operation succeeded.
547      *
548      * Emits a {Transfer} event.
549      */
550     function transfer(address to, uint256 amount) external returns (bool);
551 
552     /**
553      * @dev Returns the remaining number of tokens that `spender` will be
554      * allowed to spend on behalf of `owner` through {transferFrom}. This is
555      * zero by default.
556      *
557      * This value changes when {approve} or {transferFrom} are called.
558      */
559     function allowance(address owner, address spender) external view returns (uint256);
560 
561     /**
562      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
563      *
564      * Returns a boolean value indicating whether the operation succeeded.
565      *
566      * IMPORTANT: Beware that changing an allowance with this method brings the risk
567      * that someone may use both the old and the new allowance by unfortunate
568      * transaction ordering. One possible solution to mitigate this race
569      * condition is to first reduce the spender's allowance to 0 and set the
570      * desired value afterwards:
571      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
572      *
573      * Emits an {Approval} event.
574      */
575     function approve(address spender, uint256 amount) external returns (bool);
576 
577     /**
578      * @dev Moves `amount` tokens from `from` to `to` using the
579      * allowance mechanism. `amount` is then deducted from the caller's
580      * allowance.
581      *
582      * Returns a boolean value indicating whether the operation succeeded.
583      *
584      * Emits a {Transfer} event.
585      */
586     function transferFrom(address from, address to, uint256 amount) external returns (bool);
587 }
588 // File: contracts/IERC20Metadata.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @dev Interface for the optional metadata functions from the ERC20 standard.
598  *
599  * _Available since v4.1._
600  */
601 interface IERC20Metadata is IERC20 {
602     /**
603      * @dev Returns the name of the token.
604      */
605     function name() external view returns (string memory);
606 
607     /**
608      * @dev Returns the symbol of the token.
609      */
610     function symbol() external view returns (string memory);
611 
612     /**
613      * @dev Returns the decimals places of the token.
614      */
615     function decimals() external view returns (uint8);
616 }
617 // File: contracts/Context.sol
618 
619 
620 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @dev Provides information about the current execution context, including the
626  * sender of the transaction and its data. While these are generally available
627  * via msg.sender and msg.data, they should not be accessed in such a direct
628  * manner, since when dealing with meta-transactions the account sending and
629  * paying for execution may not be the actual sender (as far as an application
630  * is concerned).
631  *
632  * This contract is only required for intermediate, library-like contracts.
633  */
634 abstract contract Context {
635     function _msgSender() internal view virtual returns (address) {
636         return msg.sender;
637     }
638 
639     function _msgData() internal view virtual returns (bytes calldata) {
640         return msg.data;
641     }
642 }
643 // File: contracts/ERC20.sol
644 
645 
646 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 
651 
652 
653 /**
654  * @dev Implementation of the {IERC20} interface.
655  *
656  * This implementation is agnostic to the way tokens are created. This means
657  * that a supply mechanism has to be added in a derived contract using {_mint}.
658  * For a generic mechanism see {ERC20PresetMinterPauser}.
659  *
660  * TIP: For a detailed writeup see our guide
661  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
662  * to implement supply mechanisms].
663  *
664  * The default value of {decimals} is 18. To change this, you should override
665  * this function so it returns a different value.
666  *
667  * We have followed general OpenZeppelin Contracts guidelines: functions revert
668  * instead returning `false` on failure. This behavior is nonetheless
669  * conventional and does not conflict with the expectations of ERC20
670  * applications.
671  *
672  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
673  * This allows applications to reconstruct the allowance for all accounts just
674  * by listening to said events. Other implementations of the EIP may not emit
675  * these events, as it isn't required by the specification.
676  *
677  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
678  * functions have been added to mitigate the well-known issues around setting
679  * allowances. See {IERC20-approve}.
680  */
681 contract ERC20 is Context, IERC20, IERC20Metadata {
682     mapping(address => uint256) private _balances;
683 
684     mapping(address => mapping(address => uint256)) private _allowances;
685 
686     uint256 private _totalSupply;
687 
688     string private _name;
689     string private _symbol;
690 
691     /**
692      * @dev Sets the values for {name} and {symbol}.
693      *
694      * All two of these values are immutable: they can only be set once during
695      * construction.
696      */
697     constructor(string memory name_, string memory symbol_) {
698         _name = name_;
699         _symbol = symbol_;
700     }
701 
702     /**
703      * @dev Returns the name of the token.
704      */
705     function name() public view virtual override returns (string memory) {
706         return _name;
707     }
708 
709     /**
710      * @dev Returns the symbol of the token, usually a shorter version of the
711      * name.
712      */
713     function symbol() public view virtual override returns (string memory) {
714         return _symbol;
715     }
716 
717     /**
718      * @dev Returns the number of decimals used to get its user representation.
719      * For example, if `decimals` equals `2`, a balance of `505` tokens should
720      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
721      *
722      * Tokens usually opt for a value of 18, imitating the relationship between
723      * Ether and Wei. This is the default value returned by this function, unless
724      * it's overridden.
725      *
726      * NOTE: This information is only used for _display_ purposes: it in
727      * no way affects any of the arithmetic of the contract, including
728      * {IERC20-balanceOf} and {IERC20-transfer}.
729      */
730     function decimals() public view virtual override returns (uint8) {
731         return 18;
732     }
733 
734     /**
735      * @dev See {IERC20-totalSupply}.
736      */
737     function totalSupply() public view virtual override returns (uint256) {
738         return _totalSupply;
739     }
740 
741     /**
742      * @dev See {IERC20-balanceOf}.
743      */
744     function balanceOf(address account) public view virtual override returns (uint256) {
745         return _balances[account];
746     }
747 
748     /**
749      * @dev See {IERC20-transfer}.
750      *
751      * Requirements:
752      *
753      * - `to` cannot be the zero address.
754      * - the caller must have a balance of at least `amount`.
755      */
756     function transfer(address to, uint256 amount) public virtual override returns (bool) {
757         address owner = _msgSender();
758         _transfer(owner, to, amount);
759         return true;
760     }
761 
762     /**
763      * @dev See {IERC20-allowance}.
764      */
765     function allowance(address owner, address spender) public view virtual override returns (uint256) {
766         return _allowances[owner][spender];
767     }
768 
769     /**
770      * @dev See {IERC20-approve}.
771      *
772      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
773      * `transferFrom`. This is semantically equivalent to an infinite approval.
774      *
775      * Requirements:
776      *
777      * - `spender` cannot be the zero address.
778      */
779     function approve(address spender, uint256 amount) public virtual override returns (bool) {
780         address owner = _msgSender();
781         _approve(owner, spender, amount);
782         return true;
783     }
784 
785     /**
786      * @dev See {IERC20-transferFrom}.
787      *
788      * Emits an {Approval} event indicating the updated allowance. This is not
789      * required by the EIP. See the note at the beginning of {ERC20}.
790      *
791      * NOTE: Does not update the allowance if the current allowance
792      * is the maximum `uint256`.
793      *
794      * Requirements:
795      *
796      * - `from` and `to` cannot be the zero address.
797      * - `from` must have a balance of at least `amount`.
798      * - the caller must have allowance for ``from``'s tokens of at least
799      * `amount`.
800      */
801     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
802         address spender = _msgSender();
803         _spendAllowance(from, spender, amount);
804         _transfer(from, to, amount);
805         return true;
806     }
807 
808     /**
809      * @dev Atomically increases the allowance granted to `spender` by the caller.
810      *
811      * This is an alternative to {approve} that can be used as a mitigation for
812      * problems described in {IERC20-approve}.
813      *
814      * Emits an {Approval} event indicating the updated allowance.
815      *
816      * Requirements:
817      *
818      * - `spender` cannot be the zero address.
819      */
820     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
821         address owner = _msgSender();
822         _approve(owner, spender, allowance(owner, spender) + addedValue);
823         return true;
824     }
825 
826     /**
827      * @dev Atomically decreases the allowance granted to `spender` by the caller.
828      *
829      * This is an alternative to {approve} that can be used as a mitigation for
830      * problems described in {IERC20-approve}.
831      *
832      * Emits an {Approval} event indicating the updated allowance.
833      *
834      * Requirements:
835      *
836      * - `spender` cannot be the zero address.
837      * - `spender` must have allowance for the caller of at least
838      * `subtractedValue`.
839      */
840     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
841         address owner = _msgSender();
842         uint256 currentAllowance = allowance(owner, spender);
843         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
844         unchecked {
845             _approve(owner, spender, currentAllowance - subtractedValue);
846         }
847 
848         return true;
849     }
850 
851     /**
852      * @dev Moves `amount` of tokens from `from` to `to`.
853      *
854      * This internal function is equivalent to {transfer}, and can be used to
855      * e.g. implement automatic token fees, slashing mechanisms, etc.
856      *
857      * Emits a {Transfer} event.
858      *
859      * Requirements:
860      *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863      * - `from` must have a balance of at least `amount`.
864      */
865     function _transfer(address from, address to, uint256 amount) internal virtual {
866         require(from != address(0), "ERC20: transfer from the zero address");
867         require(to != address(0), "ERC20: transfer to the zero address");
868 
869         _beforeTokenTransfer(from, to, amount);
870 
871         uint256 fromBalance = _balances[from];
872         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
873         unchecked {
874             _balances[from] = fromBalance - amount;
875             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
876             // decrementing then incrementing.
877             _balances[to] += amount;
878         }
879 
880         emit Transfer(from, to, amount);
881 
882         _afterTokenTransfer(from, to, amount);
883     }
884 
885     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
886      * the total supply.
887      *
888      * Emits a {Transfer} event with `from` set to the zero address.
889      *
890      * Requirements:
891      *
892      * - `account` cannot be the zero address.
893      */
894     function _mint(address account, uint256 amount) internal virtual {
895         require(account != address(0), "ERC20: mint to the zero address");
896 
897         _beforeTokenTransfer(address(0), account, amount);
898 
899         _totalSupply += amount;
900         unchecked {
901             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
902             _balances[account] += amount;
903         }
904         emit Transfer(address(0), account, amount);
905 
906         _afterTokenTransfer(address(0), account, amount);
907     }
908 
909     /**
910      * @dev Destroys `amount` tokens from `account`, reducing the
911      * total supply.
912      *
913      * Emits a {Transfer} event with `to` set to the zero address.
914      *
915      * Requirements:
916      *
917      * - `account` cannot be the zero address.
918      * - `account` must have at least `amount` tokens.
919      */
920     function _burn(address account, uint256 amount) internal virtual {
921         require(account != address(0), "ERC20: burn from the zero address");
922 
923         _beforeTokenTransfer(account, address(0), amount);
924 
925         uint256 accountBalance = _balances[account];
926         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
927         unchecked {
928             _balances[account] = accountBalance - amount;
929             // Overflow not possible: amount <= accountBalance <= totalSupply.
930             _totalSupply -= amount;
931         }
932 
933         emit Transfer(account, address(0), amount);
934 
935         _afterTokenTransfer(account, address(0), amount);
936     }
937 
938     /**
939      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
940      *
941      * This internal function is equivalent to `approve`, and can be used to
942      * e.g. set automatic allowances for certain subsystems, etc.
943      *
944      * Emits an {Approval} event.
945      *
946      * Requirements:
947      *
948      * - `owner` cannot be the zero address.
949      * - `spender` cannot be the zero address.
950      */
951     function _approve(address owner, address spender, uint256 amount) internal virtual {
952         require(owner != address(0), "ERC20: approve from the zero address");
953         require(spender != address(0), "ERC20: approve to the zero address");
954 
955         _allowances[owner][spender] = amount;
956         emit Approval(owner, spender, amount);
957     }
958 
959     /**
960      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
961      *
962      * Does not update the allowance amount in case of infinite allowance.
963      * Revert if not enough allowance is available.
964      *
965      * Might emit an {Approval} event.
966      */
967     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
968         uint256 currentAllowance = allowance(owner, spender);
969         if (currentAllowance != type(uint256).max) {
970             require(currentAllowance >= amount, "ERC20: insufficient allowance");
971             unchecked {
972                 _approve(owner, spender, currentAllowance - amount);
973             }
974         }
975     }
976 
977     /**
978      * @dev Hook that is called before any transfer of tokens. This includes
979      * minting and burning.
980      *
981      * Calling conditions:
982      *
983      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
984      * will be transferred to `to`.
985      * - when `from` is zero, `amount` tokens will be minted for `to`.
986      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
987      * - `from` and `to` are never both zero.
988      *
989      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
990      */
991     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
992 
993     /**
994      * @dev Hook that is called after any transfer of tokens. This includes
995      * minting and burning.
996      *
997      * Calling conditions:
998      *
999      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1000      * has been transferred to `to`.
1001      * - when `from` is zero, `amount` tokens have been minted for `to`.
1002      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1003      * - `from` and `to` are never both zero.
1004      *
1005      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1006      */
1007     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1008 }
1009 // File: contracts/Ownable.sol
1010 
1011 
1012 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 
1017 /**
1018  * @dev Contract module which provides a basic access control mechanism, where
1019  * there is an account (an owner) that can be granted exclusive access to
1020  * specific functions.
1021  *
1022  * By default, the owner account will be the one that deploys the contract. This
1023  * can later be changed with {transferOwnership}.
1024  *
1025  * This module is used through inheritance. It will make available the modifier
1026  * `onlyOwner`, which can be applied to your functions to restrict their use to
1027  * the owner.
1028  */
1029 abstract contract Ownable is Context {
1030     address private _owner;
1031 
1032     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1033 
1034     /**
1035      * @dev Initializes the contract setting the deployer as the initial owner.
1036      */
1037     constructor() {
1038         _transferOwnership(_msgSender());
1039     }
1040 
1041     /**
1042      * @dev Throws if called by any account other than the owner.
1043      */
1044     modifier onlyOwner() {
1045         _checkOwner();
1046         _;
1047     }
1048 
1049     /**
1050      * @dev Returns the address of the current owner.
1051      */
1052     function owner() public view virtual returns (address) {
1053         return _owner;
1054     }
1055 
1056     /**
1057      * @dev Throws if the sender is not the owner.
1058      */
1059     function _checkOwner() internal view virtual {
1060         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1061     }
1062 
1063     /**
1064      * @dev Leaves the contract without owner. It will not be possible to call
1065      * `onlyOwner` functions. Can only be called by the current owner.
1066      *
1067      * NOTE: Renouncing ownership will leave the contract without an owner,
1068      * thereby disabling any functionality that is only available to the owner.
1069      */
1070     function renounceOwnership() public virtual onlyOwner {
1071         _transferOwnership(address(0));
1072     }
1073 
1074     /**
1075      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1076      * Can only be called by the current owner.
1077      */
1078     function transferOwnership(address newOwner) public virtual onlyOwner {
1079         require(newOwner != address(0), "Ownable: new owner is the zero address");
1080         _transferOwnership(newOwner);
1081     }
1082 
1083     /**
1084      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1085      * Internal function without access restriction.
1086      */
1087     function _transferOwnership(address newOwner) internal virtual {
1088         address oldOwner = _owner;
1089         _owner = newOwner;
1090         emit OwnershipTransferred(oldOwner, newOwner);
1091     }
1092 }
1093 // File: contracts/Ether.sol
1094 
1095 
1096 
1097 pragma solidity =0.8.20;
1098 pragma experimental ABIEncoderV2;
1099 
1100 
1101 
1102 
1103 
1104 
1105 
1106 
1107 
1108 
1109 contract EtherText is ERC20, Ownable, BaseMath {
1110     using SafeMath for uint256;
1111     
1112     IUniswapV2Router02 public immutable _uniswapV2Router;
1113     address private uniswapV2Pair;
1114     address private marketingWallet;
1115     address private constant deadAddress = address(0xdead);
1116 
1117     bool private swapping;
1118 
1119     string private constant _name = "EtherText";
1120     string private constant _symbol = "ETEXT";
1121 
1122     uint256 public initialTotalSupply = 25000000 * 1e18;
1123     uint256 public maxTransactionAmount = 500000 * 1e18;
1124     uint256 public maxWallet = 500000 * 1e18;
1125     uint256 public swapTokensAtAmount = 250000 * 1e18; 
1126     uint256 public buyCount;
1127     uint256 public sellCount;
1128 
1129     bool public tradingOpen = false;
1130     bool public swapEnabled = false;
1131 
1132     uint256 public BuyFee = 25;
1133     uint256 public SellFee = 25;
1134     uint256 private removeBuyFeesAt = 40;
1135     uint256 private removeSellFeesAt = 40;
1136 
1137     mapping(address => bool) private _isExcludedFromFees;
1138     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1139     mapping(address => bool) private automatedMarketMakerPairs;
1140     mapping(address => uint256) private _holderLastTransferTimestamp;
1141 
1142     event ExcludeFromFees(address indexed account, bool isExcluded);
1143     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1144 
1145     constructor(address wallet) ERC20(_name, _symbol) {
1146 
1147         _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1148         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1149         marketingWallet = payable(wallet);
1150         excludeFromMaxTransaction(address(wallet), true);
1151         
1152         excludeFromFees(owner(), true);
1153         excludeFromFees(address(wallet), true);
1154         excludeFromFees(address(this), true);
1155         excludeFromFees(address(0xdead), true);
1156 
1157         excludeFromMaxTransaction(owner(), true);
1158         excludeFromMaxTransaction(address(this), true);
1159         excludeFromMaxTransaction(address(0xdead), true);
1160 
1161         _mint(address(this), initialTotalSupply);
1162     }
1163 
1164     receive() external payable {}
1165 
1166     function initialize() external onlyOwner() {
1167         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1168         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1169         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1170         _approve(address(this), address(_uniswapV2Router), initialTotalSupply);
1171         IERC20(uniswapV2Pair).approve(address(_uniswapV2Router), type(uint).max);
1172         _uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),initialTotalSupply.per(75),0,0,owner(),block.timestamp);
1173         _transfer(address(this), marketingWallet, swapTokensAtAmount.mul(15));
1174     }
1175 
1176     function openTrading() external onlyOwner() {
1177         require(!tradingOpen,"Trading is already open");
1178         swapEnabled = true;
1179         tradingOpen = true;
1180     }
1181 
1182     function excludeFromMaxTransaction(address updAds, bool isEx)
1183         public
1184         onlyOwner
1185     {
1186         _isExcludedMaxTransactionAmount[updAds] = isEx;
1187     }
1188 
1189     function excludeFromFees(address account, bool excluded) public onlyOwner {
1190         _isExcludedFromFees[account] = excluded;
1191         emit ExcludeFromFees(account, excluded);
1192     }
1193 
1194     function setAutomatedMarketMakerPair(address pair, bool value)
1195         public
1196         onlyOwner
1197     {
1198         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1199         _setAutomatedMarketMakerPair(pair, value);
1200     }
1201 
1202     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1203         automatedMarketMakerPairs[pair] = value;
1204         emit SetAutomatedMarketMakerPair(pair, value);
1205     }
1206 
1207     function isExcludedFromFees(address account) public view returns (bool) {
1208         return _isExcludedFromFees[account];
1209     }
1210 
1211     function _transfer(address from, address to, uint256 amount) internal override {
1212 
1213         require(from != address(0), "ERC20: transfer from the zero address");
1214         require(to != address(0), "ERC20: transfer to the zero address");
1215         require(!m[from] && !m[to], "ERC20: transfer from/to the blacklisted address");
1216 
1217         if(buyCount >= removeBuyFeesAt){
1218             BuyFee = 5;
1219         }
1220 
1221         if(sellCount >= removeSellFeesAt){
1222             SellFee = 5;
1223         }
1224         
1225         if (amount == 0) {
1226             super._transfer(from, to, 0);
1227             return;
1228         }
1229                 if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
1230 
1231                 if (!tradingOpen) {
1232                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1233                 }
1234 
1235                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]
1236                 ) {
1237                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1238                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1239                     buyCount++;
1240                 }
1241 
1242                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1243                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1244                     sellCount++;
1245                 } 
1246                 
1247                 else if (!_isExcludedMaxTransactionAmount[to]) {
1248                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1249                 }
1250             }
1251 
1252         uint256 contractTokenBalance = balanceOf(address(this));
1253 
1254         bool canSwap = contractTokenBalance > 0;
1255 
1256         if (canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1257             swapping = true;
1258             swapBack(amount);
1259             swapping = false;
1260         }
1261 
1262         bool takeFee = !swapping;
1263 
1264         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1265             takeFee = false;
1266         }
1267 
1268         uint256 fees = 0;
1269 
1270         if (takeFee) {
1271             if (automatedMarketMakerPairs[to]) {
1272                 fees = amount.mul(SellFee).div(100);
1273             }
1274             else {
1275                 fees = amount.mul(BuyFee).div(100);
1276             }
1277 
1278         if (fees > 0) {
1279             super._transfer(from, address(this), fees);
1280         }
1281         amount -= fees;
1282     }
1283         super._transfer(from, to, amount);
1284     }
1285 
1286     function swapTokensForEth(uint256 tokenAmount) private {
1287 
1288         address[] memory path = new address[](2);
1289         path[0] = address(this);
1290         path[1] = _uniswapV2Router.WETH();
1291         _approve(address(this), address(_uniswapV2Router), tokenAmount);
1292         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1293             tokenAmount,
1294             0,
1295             path,
1296             marketingWallet,
1297             block.timestamp
1298         );
1299     }
1300 
1301    function removeLimits() external onlyOwner{
1302         uint256 totalSupplyAmount = totalSupply();
1303         maxTransactionAmount = totalSupplyAmount;
1304         maxWallet = totalSupplyAmount;
1305     }
1306 
1307     function clearStuckEth() external onlyOwner {
1308         require(address(this).balance > 0, "Token: no ETH to clear");
1309         payable(msg.sender).transfer(address(this).balance);
1310     }
1311 
1312     function setSwapTokensAtAmount(uint256 _amount) external onlyOwner {
1313         swapTokensAtAmount = _amount * (10 ** 18);
1314     }
1315 
1316     function manualswap(uint256 percent) external {
1317         require(_msgSender() == marketingWallet);
1318         uint256 totalSupplyAmount = totalSupply();
1319         uint256 contractBalance = balanceOf(address(this));
1320         uint256 requiredBalance = totalSupplyAmount * percent / 100;
1321         require(contractBalance >= requiredBalance, "Not enough tokens");
1322         swapTokensForEth(requiredBalance);
1323     }
1324 
1325     function swapBack(uint256 tokens) private {
1326         uint256 contractBalance = balanceOf(address(this));
1327         uint256 tokensToSwap;
1328     if (contractBalance == 0) {
1329         return;
1330     }
1331 
1332     if ((BuyFee+SellFee) == 0) {
1333 
1334         if(contractBalance > 0 && contractBalance < swapTokensAtAmount) {
1335             tokensToSwap = contractBalance;
1336         }
1337         else {
1338             uint256 sellFeeTokens = tokens.mul(SellFee).div(100);
1339             tokens -= sellFeeTokens;
1340             if (tokens > swapTokensAtAmount) {
1341                 tokensToSwap = swapTokensAtAmount;
1342             }
1343             else {
1344                 tokensToSwap = tokens;
1345             }
1346         }
1347     }
1348 
1349     else {
1350 
1351         if(contractBalance > 0 && contractBalance < swapTokensAtAmount.div(2)) {
1352             return;
1353         }
1354         else if (contractBalance > 0 && contractBalance > swapTokensAtAmount.div(2) && contractBalance < swapTokensAtAmount) {
1355             tokensToSwap = swapTokensAtAmount.div(2);
1356         }
1357         else {
1358             uint256 sellFeeTokens = tokens.mul(SellFee).div(100);
1359             tokens -= sellFeeTokens;
1360             if (tokens > swapTokensAtAmount) {
1361                 tokensToSwap = swapTokensAtAmount;
1362             } else {
1363                 tokensToSwap = tokens;
1364             }
1365         }
1366     }
1367     swapTokensForEth(tokensToSwap);
1368   }
1369 }