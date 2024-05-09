1 // SPDX-License-Identifier: Unlicensed
2 /* solhint-disable */
3 
4 /** 
5 ──────────────────────────────────────────────────────────────────────────────────────────────────────────────
6 ─██████████████─██████████████─██████─────────██████████████─██████████─██████──██████─██████──────────██████─
7 ─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██─────────██░░░░░░░░░░██─██░░░░░░██─██░░██──██░░██─██░░██████████████░░██─
8 ─██░░██████████─██░░██████░░██─██░░██─────────██░░██████████─████░░████─██░░██──██░░██─██░░░░░░░░░░░░░░░░░░██─
9 ─██░░██─────────██░░██──██░░██─██░░██─────────██░░██───────────██░░██───██░░██──██░░██─██░░██████░░██████░░██─
10 ─██░░██─────────██░░██████░░██─██░░██─────────██░░██───────────██░░██───██░░██──██░░██─██░░██──██░░██──██░░██─
11 ─██░░██─────────██░░░░░░░░░░██─██░░██─────────██░░██───────────██░░██───██░░██──██░░██─██░░██──██░░██──██░░██─
12 ─██░░██─────────██░░██████░░██─██░░██─────────██░░██───────────██░░██───██░░██──██░░██─██░░██──██████──██░░██─
13 ─██░░██─────────██░░██──██░░██─██░░██─────────██░░██───────────██░░██───██░░██──██░░██─██░░██──────────██░░██─
14 ─██░░██████████─██░░██──██░░██─██░░██████████─██░░██████████─████░░████─██░░██████░░██─██░░██──────────██░░██─
15 ─██░░░░░░░░░░██─██░░██──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░██─██░░░░░░░░░░██─██░░██──────────██░░██─
16 ─██████████████─██████──██████─██████████████─██████████████─██████████─██████████████─██████──────────██████─
17 ──────────────────────────────────────────────────────────────────────────────────────────────────────────────
18 
19 We are the OG $CAL, a unique project backed by legit partnerships.
20 
21 Read more on how the shib team and others have stolen everything from us by visiting 
22 our medium page which explains everything in detail!
23 
24 Official links: 
25 Telegram: t.me/shibariumcalcium
26 Twitter: twitter.com/calshibarium
27 Website: calshibarium.finance
28 Docs: docs.calshibarium.finance
29 Mint page: mint.calshibarium.finance
30 OG rewards page: rewards.calshibarium.finance 
31 
32 Please come in and speak to @Chiefkeke1 if you have any questions. 
33 */
34 
35 pragma solidity >=0.6.2;
36 
37 interface IUniswapV2Router01 {
38     function factory() external pure returns (address);
39 
40     function WETH() external pure returns (address);
41 
42     function addLiquidity(
43         address tokenA,
44         address tokenB,
45         uint amountADesired,
46         uint amountBDesired,
47         uint amountAMin,
48         uint amountBMin,
49         address to,
50         uint deadline
51     ) external returns (uint amountA, uint amountB, uint liquidity);
52 
53     function addLiquidityETH(
54         address token,
55         uint amountTokenDesired,
56         uint amountTokenMin,
57         uint amountETHMin,
58         address to,
59         uint deadline
60     )
61         external
62         payable
63         returns (uint amountToken, uint amountETH, uint liquidity);
64 
65     function removeLiquidity(
66         address tokenA,
67         address tokenB,
68         uint liquidity,
69         uint amountAMin,
70         uint amountBMin,
71         address to,
72         uint deadline
73     ) external returns (uint amountA, uint amountB);
74 
75     function removeLiquidityETH(
76         address token,
77         uint liquidity,
78         uint amountTokenMin,
79         uint amountETHMin,
80         address to,
81         uint deadline
82     ) external returns (uint amountToken, uint amountETH);
83 
84     function removeLiquidityWithPermit(
85         address tokenA,
86         address tokenB,
87         uint liquidity,
88         uint amountAMin,
89         uint amountBMin,
90         address to,
91         uint deadline,
92         bool approveMax,
93         uint8 v,
94         bytes32 r,
95         bytes32 s
96     ) external returns (uint amountA, uint amountB);
97 
98     function removeLiquidityETHWithPermit(
99         address token,
100         uint liquidity,
101         uint amountTokenMin,
102         uint amountETHMin,
103         address to,
104         uint deadline,
105         bool approveMax,
106         uint8 v,
107         bytes32 r,
108         bytes32 s
109     ) external returns (uint amountToken, uint amountETH);
110 
111     function swapExactTokensForTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external returns (uint[] memory amounts);
118 
119     function swapTokensForExactTokens(
120         uint amountOut,
121         uint amountInMax,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external returns (uint[] memory amounts);
126 
127     function swapExactETHForTokens(
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external payable returns (uint[] memory amounts);
133 
134     function swapTokensForExactETH(
135         uint amountOut,
136         uint amountInMax,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external returns (uint[] memory amounts);
141 
142     function swapExactTokensForETH(
143         uint amountIn,
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external returns (uint[] memory amounts);
149 
150     function swapETHForExactTokens(
151         uint amountOut,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external payable returns (uint[] memory amounts);
156 
157     function quote(
158         uint amountA,
159         uint reserveA,
160         uint reserveB
161     ) external pure returns (uint amountB);
162 
163     function getAmountOut(
164         uint amountIn,
165         uint reserveIn,
166         uint reserveOut
167     ) external pure returns (uint amountOut);
168 
169     function getAmountIn(
170         uint amountOut,
171         uint reserveIn,
172         uint reserveOut
173     ) external pure returns (uint amountIn);
174 
175     function getAmountsOut(
176         uint amountIn,
177         address[] calldata path
178     ) external view returns (uint[] memory amounts);
179 
180     function getAmountsIn(
181         uint amountOut,
182         address[] calldata path
183     ) external view returns (uint[] memory amounts);
184 }
185 
186 /**
187  */
188 
189 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
190 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Provides information about the current execution context, including the
196  * sender of the transaction and its data. While these are generally available
197  * via msg.sender and msg.data, they should not be accessed in such a direct
198  * manner, since when dealing with meta-transactions the account sending and
199  * paying for execution may not be the actual sender (as far as an application
200  * is concerned).
201  *
202  * This contract is only required for intermediate, library-like contracts.
203  */
204 abstract contract Context {
205     function _msgSender() internal view virtual returns (address) {
206         return msg.sender;
207     }
208 
209     function _msgData() internal view virtual returns (bytes calldata) {
210         return msg.data;
211     }
212 }
213 
214 /**
215  */
216 
217 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
218 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev Interface of the ERC20 standard as defined in the EIP.
224  */
225 interface IERC20 {
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(
239         address indexed owner,
240         address indexed spender,
241         uint256 value
242     );
243 
244     /**
245      * @dev Returns the amount of tokens in existence.
246      */
247     function totalSupply() external view returns (uint256);
248 
249     /**
250      * @dev Returns the amount of tokens owned by `account`.
251      */
252     function balanceOf(address account) external view returns (uint256);
253 
254     /**
255      * @dev Moves `amount` tokens from the caller's account to `to`.
256      *
257      * Returns a boolean value indicating whether the operation succeeded.
258      *
259      * Emits a {Transfer} event.
260      */
261     function transfer(address to, uint256 amount) external returns (bool);
262 
263     /**
264      * @dev Returns the remaining number of tokens that `spender` will be
265      * allowed to spend on behalf of `owner` through {transferFrom}. This is
266      * zero by default.
267      *
268      * This value changes when {approve} or {transferFrom} are called.
269      */
270     function allowance(
271         address owner,
272         address spender
273     ) external view returns (uint256);
274 
275     /**
276      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
281      * that someone may use both the old and the new allowance by unfortunate
282      * transaction ordering. One possible solution to mitigate this race
283      * condition is to first reduce the spender's allowance to 0 and set the
284      * desired value afterwards:
285      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
286      *
287      * Emits an {Approval} event.
288      */
289     function approve(address spender, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Moves `amount` tokens from `from` to `to` using the
293      * allowance mechanism. `amount` is then deducted from the caller's
294      * allowance.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transferFrom(
301         address from,
302         address to,
303         uint256 amount
304     ) external returns (bool);
305 }
306 
307 /**
308  */
309 
310 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
311 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 ////import "../IERC20.sol";
316 
317 /**
318  * @dev Interface for the optional metadata functions from the ERC20 standard.
319  *
320  * _Available since v4.1._
321  */
322 interface IERC20Metadata is IERC20 {
323     /**
324      * @dev Returns the name of the token.
325      */
326     function name() external view returns (string memory);
327 
328     /**
329      * @dev Returns the symbol of the token.
330      */
331     function symbol() external view returns (string memory);
332 
333     /**
334      * @dev Returns the decimals places of the token.
335      */
336     function decimals() external view returns (uint8);
337 }
338 
339 /**
340  */
341 
342 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
343 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 // CAUTION
348 // This version of SafeMath should only be used with Solidity 0.8 or later,
349 // because it relies on the compiler's built in overflow checks.
350 
351 /**
352  * @dev Wrappers over Solidity's arithmetic operations.
353  *
354  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
355  * now has built in overflow checking.
356  */
357 library SafeMath {
358     /**
359      * @dev Returns the addition of two unsigned integers, with an overflow flag.
360      *
361      * _Available since v3.4._
362      */
363     function tryAdd(
364         uint256 a,
365         uint256 b
366     ) internal pure returns (bool, uint256) {
367         unchecked {
368             uint256 c = a + b;
369             if (c < a) return (false, 0);
370             return (true, c);
371         }
372     }
373 
374     /**
375      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
376      *
377      * _Available since v3.4._
378      */
379     function trySub(
380         uint256 a,
381         uint256 b
382     ) internal pure returns (bool, uint256) {
383         unchecked {
384             if (b > a) return (false, 0);
385             return (true, a - b);
386         }
387     }
388 
389     /**
390      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
391      *
392      * _Available since v3.4._
393      */
394     function tryMul(
395         uint256 a,
396         uint256 b
397     ) internal pure returns (bool, uint256) {
398         unchecked {
399             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
400             // benefit is lost if 'b' is also tested.
401             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
402             if (a == 0) return (true, 0);
403             uint256 c = a * b;
404             if (c / a != b) return (false, 0);
405             return (true, c);
406         }
407     }
408 
409     /**
410      * @dev Returns the division of two unsigned integers, with a division by zero flag.
411      *
412      * _Available since v3.4._
413      */
414     function tryDiv(
415         uint256 a,
416         uint256 b
417     ) internal pure returns (bool, uint256) {
418         unchecked {
419             if (b == 0) return (false, 0);
420             return (true, a / b);
421         }
422     }
423 
424     /**
425      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
426      *
427      * _Available since v3.4._
428      */
429     function tryMod(
430         uint256 a,
431         uint256 b
432     ) internal pure returns (bool, uint256) {
433         unchecked {
434             if (b == 0) return (false, 0);
435             return (true, a % b);
436         }
437     }
438 
439     /**
440      * @dev Returns the addition of two unsigned integers, reverting on
441      * overflow.
442      *
443      * Counterpart to Solidity's `+` operator.
444      *
445      * Requirements:
446      *
447      * - Addition cannot overflow.
448      */
449     function add(uint256 a, uint256 b) internal pure returns (uint256) {
450         return a + b;
451     }
452 
453     /**
454      * @dev Returns the subtraction of two unsigned integers, reverting on
455      * overflow (when the result is negative).
456      *
457      * Counterpart to Solidity's `-` operator.
458      *
459      * Requirements:
460      *
461      * - Subtraction cannot overflow.
462      */
463     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
464         return a - b;
465     }
466 
467     /**
468      * @dev Returns the multiplication of two unsigned integers, reverting on
469      * overflow.
470      *
471      * Counterpart to Solidity's `*` operator.
472      *
473      * Requirements:
474      *
475      * - Multiplication cannot overflow.
476      */
477     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
478         return a * b;
479     }
480 
481     /**
482      * @dev Returns the integer division of two unsigned integers, reverting on
483      * division by zero. The result is rounded towards zero.
484      *
485      * Counterpart to Solidity's `/` operator.
486      *
487      * Requirements:
488      *
489      * - The divisor cannot be zero.
490      */
491     function div(uint256 a, uint256 b) internal pure returns (uint256) {
492         return a / b;
493     }
494 
495     /**
496      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
497      * reverting when dividing by zero.
498      *
499      * Counterpart to Solidity's `%` operator. This function uses a `revert`
500      * opcode (which leaves remaining gas untouched) while Solidity uses an
501      * invalid opcode to revert (consuming all remaining gas).
502      *
503      * Requirements:
504      *
505      * - The divisor cannot be zero.
506      */
507     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
508         return a % b;
509     }
510 
511     /**
512      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
513      * overflow (when the result is negative).
514      *
515      * CAUTION: This function is deprecated because it requires allocating memory for the error
516      * message unnecessarily. For custom revert reasons use {trySub}.
517      *
518      * Counterpart to Solidity's `-` operator.
519      *
520      * Requirements:
521      *
522      * - Subtraction cannot overflow.
523      */
524     function sub(
525         uint256 a,
526         uint256 b,
527         string memory errorMessage
528     ) internal pure returns (uint256) {
529         unchecked {
530             require(b <= a, errorMessage);
531             return a - b;
532         }
533     }
534 
535     /**
536      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
537      * division by zero. The result is rounded towards zero.
538      *
539      * Counterpart to Solidity's `/` operator. Note: this function uses a
540      * `revert` opcode (which leaves remaining gas untouched) while Solidity
541      * uses an invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function div(
548         uint256 a,
549         uint256 b,
550         string memory errorMessage
551     ) internal pure returns (uint256) {
552         unchecked {
553             require(b > 0, errorMessage);
554             return a / b;
555         }
556     }
557 
558     /**
559      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
560      * reverting with custom message when dividing by zero.
561      *
562      * CAUTION: This function is deprecated because it requires allocating memory for the error
563      * message unnecessarily. For custom revert reasons use {tryMod}.
564      *
565      * Counterpart to Solidity's `%` operator. This function uses a `revert`
566      * opcode (which leaves remaining gas untouched) while Solidity uses an
567      * invalid opcode to revert (consuming all remaining gas).
568      *
569      * Requirements:
570      *
571      * - The divisor cannot be zero.
572      */
573     function mod(
574         uint256 a,
575         uint256 b,
576         string memory errorMessage
577     ) internal pure returns (uint256) {
578         unchecked {
579             require(b > 0, errorMessage);
580             return a % b;
581         }
582     }
583 }
584 
585 /**
586  */
587 
588 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
589 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 ////import "./IERC20.sol";
594 ////import "./extensions/IERC20Metadata.sol";
595 ////import "../../utils/Context.sol";
596 
597 /**
598  * @dev Implementation of the {IERC20} interface.
599  *
600  * This implementation is agnostic to the way tokens are created. This means
601  * that a supply mechanism has to be added in a derived contract using {_mint}.
602  * For a generic mechanism see {ERC20PresetMinterPauser}.
603  *
604  * TIP: For a detailed writeup see our guide
605  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
606  * to implement supply mechanisms].
607  *
608  * We have followed general OpenZeppelin Contracts guidelines: functions revert
609  * instead returning `false` on failure. This behavior is nonetheless
610  * conventional and does not conflict with the expectations of ERC20
611  * applications.
612  *
613  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
614  * This allows applications to reconstruct the allowance for all accounts just
615  * by listening to said events. Other implementations of the EIP may not emit
616  * these events, as it isn't required by the specification.
617  *
618  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
619  * functions have been added to mitigate the well-known issues around setting
620  * allowances. See {IERC20-approve}.
621  */
622 contract ERC20 is Context, IERC20, IERC20Metadata {
623     mapping(address => uint256) private _balances;
624 
625     mapping(address => mapping(address => uint256)) private _allowances;
626 
627     uint256 private _totalSupply;
628 
629     string private _name;
630     string private _symbol;
631 
632     /**
633      * @dev Sets the values for {name} and {symbol}.
634      *
635      * The default value of {decimals} is 18. To select a different value for
636      * {decimals} you should overload it.
637      *
638      * All two of these values are immutable: they can only be set once during
639      * construction.
640      */
641     constructor(string memory name_, string memory symbol_) {
642         _name = name_;
643         _symbol = symbol_;
644     }
645 
646     /**
647      * @dev Returns the name of the token.
648      */
649     function name() public view virtual override returns (string memory) {
650         return _name;
651     }
652 
653     /**
654      * @dev Returns the symbol of the token, usually a shorter version of the
655      * name.
656      */
657     function symbol() public view virtual override returns (string memory) {
658         return _symbol;
659     }
660 
661     /**
662      * @dev Returns the number of decimals used to get its user representation.
663      * For example, if `decimals` equals `2`, a balance of `505` tokens should
664      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
665      *
666      * Tokens usually opt for a value of 18, imitating the relationship between
667      * Ether and Wei. This is the value {ERC20} uses, unless this function is
668      * overridden;
669      *
670      * NOTE: This information is only used for _display_ purposes: it in
671      * no way affects any of the arithmetic of the contract, including
672      * {IERC20-balanceOf} and {IERC20-transfer}.
673      */
674     function decimals() public view virtual override returns (uint8) {
675         return 18;
676     }
677 
678     /**
679      * @dev See {IERC20-totalSupply}.
680      */
681     function totalSupply() public view virtual override returns (uint256) {
682         return _totalSupply;
683     }
684 
685     /**
686      * @dev See {IERC20-balanceOf}.
687      */
688     function balanceOf(
689         address account
690     ) public view virtual override returns (uint256) {
691         return _balances[account];
692     }
693 
694     /**
695      * @dev See {IERC20-transfer}.
696      *
697      * Requirements:
698      *
699      * - `to` cannot be the zero address.
700      * - the caller must have a balance of at least `amount`.
701      */
702     function transfer(
703         address to,
704         uint256 amount
705     ) public virtual override returns (bool) {
706         address owner = _msgSender();
707         _transfer(owner, to, amount);
708         return true;
709     }
710 
711     /**
712      * @dev See {IERC20-allowance}.
713      */
714     function allowance(
715         address owner,
716         address spender
717     ) public view virtual override returns (uint256) {
718         return _allowances[owner][spender];
719     }
720 
721     /**
722      * @dev See {IERC20-approve}.
723      *
724      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
725      * `transferFrom`. This is semantically equivalent to an infinite approval.
726      *
727      * Requirements:
728      *
729      * - `spender` cannot be the zero address.
730      */
731     function approve(
732         address spender,
733         uint256 amount
734     ) public virtual override returns (bool) {
735         address owner = _msgSender();
736         _approve(owner, spender, amount);
737         return true;
738     }
739 
740     /**
741      * @dev See {IERC20-transferFrom}.
742      *
743      * Emits an {Approval} event indicating the updated allowance. This is not
744      * required by the EIP. See the note at the beginning of {ERC20}.
745      *
746      * NOTE: Does not update the allowance if the current allowance
747      * is the maximum `uint256`.
748      *
749      * Requirements:
750      *
751      * - `from` and `to` cannot be the zero address.
752      * - `from` must have a balance of at least `amount`.
753      * - the caller must have allowance for ``from``'s tokens of at least
754      * `amount`.
755      */
756     function transferFrom(
757         address from,
758         address to,
759         uint256 amount
760     ) public virtual override returns (bool) {
761         address spender = _msgSender();
762         _spendAllowance(from, spender, amount);
763         _transfer(from, to, amount);
764         return true;
765     }
766 
767     /**
768      * @dev Atomically increases the allowance granted to `spender` by the caller.
769      *
770      * This is an alternative to {approve} that can be used as a mitigation for
771      * problems described in {IERC20-approve}.
772      *
773      * Emits an {Approval} event indicating the updated allowance.
774      *
775      * Requirements:
776      *
777      * - `spender` cannot be the zero address.
778      */
779     function increaseAllowance(
780         address spender,
781         uint256 addedValue
782     ) public virtual returns (bool) {
783         address owner = _msgSender();
784         _approve(owner, spender, allowance(owner, spender) + addedValue);
785         return true;
786     }
787 
788     /**
789      * @dev Atomically decreases the allowance granted to `spender` by the caller.
790      *
791      * This is an alternative to {approve} that can be used as a mitigation for
792      * problems described in {IERC20-approve}.
793      *
794      * Emits an {Approval} event indicating the updated allowance.
795      *
796      * Requirements:
797      *
798      * - `spender` cannot be the zero address.
799      * - `spender` must have allowance for the caller of at least
800      * `subtractedValue`.
801      */
802     function decreaseAllowance(
803         address spender,
804         uint256 subtractedValue
805     ) public virtual returns (bool) {
806         address owner = _msgSender();
807         uint256 currentAllowance = allowance(owner, spender);
808         require(
809             currentAllowance >= subtractedValue,
810             "ERC20: decreased allowance below zero"
811         );
812         unchecked {
813             _approve(owner, spender, currentAllowance - subtractedValue);
814         }
815 
816         return true;
817     }
818 
819     /**
820      * @dev Moves `amount` of tokens from `from` to `to`.
821      *
822      * This internal function is equivalent to {transfer}, and can be used to
823      * e.g. implement automatic token fees, slashing mechanisms, etc.
824      *
825      * Emits a {Transfer} event.
826      *
827      * Requirements:
828      *
829      * - `from` cannot be the zero address.
830      * - `to` cannot be the zero address.
831      * - `from` must have a balance of at least `amount`.
832      */
833     function _transfer(
834         address from,
835         address to,
836         uint256 amount
837     ) internal virtual {
838         require(from != address(0), "ERC20: transfer from the zero address");
839         require(to != address(0), "ERC20: transfer to the zero address");
840 
841         _beforeTokenTransfer(from, to, amount);
842 
843         uint256 fromBalance = _balances[from];
844         require(
845             fromBalance >= amount,
846             "ERC20: transfer amount exceeds balance"
847         );
848         unchecked {
849             _balances[from] = fromBalance - amount;
850             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
851             // decrementing then incrementing.
852             _balances[to] += amount;
853         }
854 
855         emit Transfer(from, to, amount);
856 
857         _afterTokenTransfer(from, to, amount);
858     }
859 
860     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
861      * the total supply.
862      *
863      * Emits a {Transfer} event with `from` set to the zero address.
864      *
865      * Requirements:
866      *
867      * - `account` cannot be the zero address.
868      */
869     function _mint(address account, uint256 amount) internal virtual {
870         require(account != address(0), "ERC20: mint to the zero address");
871 
872         _beforeTokenTransfer(address(0), account, amount);
873 
874         _totalSupply += amount;
875         unchecked {
876             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
877             _balances[account] += amount;
878         }
879         emit Transfer(address(0), account, amount);
880 
881         _afterTokenTransfer(address(0), account, amount);
882     }
883 
884     /**
885      * @dev Destroys `amount` tokens from `account`, reducing the
886      * total supply.
887      *
888      * Emits a {Transfer} event with `to` set to the zero address.
889      *
890      * Requirements:
891      *
892      * - `account` cannot be the zero address.
893      * - `account` must have at least `amount` tokens.
894      */
895     function _burn(address account, uint256 amount) internal virtual {
896         require(account != address(0), "ERC20: burn from the zero address");
897 
898         _beforeTokenTransfer(account, address(0), amount);
899 
900         uint256 accountBalance = _balances[account];
901         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
902         unchecked {
903             _balances[account] = accountBalance - amount;
904             // Overflow not possible: amount <= accountBalance <= totalSupply.
905             _totalSupply -= amount;
906         }
907 
908         emit Transfer(account, address(0), amount);
909 
910         _afterTokenTransfer(account, address(0), amount);
911     }
912 
913     /**
914      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
915      *
916      * This internal function is equivalent to `approve`, and can be used to
917      * e.g. set automatic allowances for certain subsystems, etc.
918      *
919      * Emits an {Approval} event.
920      *
921      * Requirements:
922      *
923      * - `owner` cannot be the zero address.
924      * - `spender` cannot be the zero address.
925      */
926     function _approve(
927         address owner,
928         address spender,
929         uint256 amount
930     ) internal virtual {
931         require(owner != address(0), "ERC20: approve from the zero address");
932         require(spender != address(0), "ERC20: approve to the zero address");
933 
934         _allowances[owner][spender] = amount;
935         emit Approval(owner, spender, amount);
936     }
937 
938     /**
939      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
940      *
941      * Does not update the allowance amount in case of infinite allowance.
942      * Revert if not enough allowance is available.
943      *
944      * Might emit an {Approval} event.
945      */
946     function _spendAllowance(
947         address owner,
948         address spender,
949         uint256 amount
950     ) internal virtual {
951         uint256 currentAllowance = allowance(owner, spender);
952         if (currentAllowance != type(uint256).max) {
953             require(
954                 currentAllowance >= amount,
955                 "ERC20: insufficient allowance"
956             );
957             unchecked {
958                 _approve(owner, spender, currentAllowance - amount);
959             }
960         }
961     }
962 
963     /**
964      * @dev Hook that is called before any transfer of tokens. This includes
965      * minting and burning.
966      *
967      * Calling conditions:
968      *
969      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
970      * will be transferred to `to`.
971      * - when `from` is zero, `amount` tokens will be minted for `to`.
972      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
973      * - `from` and `to` are never both zero.
974      *
975      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
976      */
977     function _beforeTokenTransfer(
978         address from,
979         address to,
980         uint256 amount
981     ) internal virtual {}
982 
983     /**
984      * @dev Hook that is called after any transfer of tokens. This includes
985      * minting and burning.
986      *
987      * Calling conditions:
988      *
989      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
990      * has been transferred to `to`.
991      * - when `from` is zero, `amount` tokens have been minted for `to`.
992      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
993      * - `from` and `to` are never both zero.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _afterTokenTransfer(
998         address from,
999         address to,
1000         uint256 amount
1001     ) internal virtual {}
1002 }
1003 
1004 /**
1005  */
1006 
1007 pragma solidity >=0.5.0;
1008 
1009 interface IUniswapV2Pair {
1010     event Approval(address indexed owner, address indexed spender, uint value);
1011     event Transfer(address indexed from, address indexed to, uint value);
1012 
1013     function name() external pure returns (string memory);
1014 
1015     function symbol() external pure returns (string memory);
1016 
1017     function decimals() external pure returns (uint8);
1018 
1019     function totalSupply() external view returns (uint);
1020 
1021     function balanceOf(address owner) external view returns (uint);
1022 
1023     function allowance(
1024         address owner,
1025         address spender
1026     ) external view returns (uint);
1027 
1028     function approve(address spender, uint value) external returns (bool);
1029 
1030     function transfer(address to, uint value) external returns (bool);
1031 
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint value
1036     ) external returns (bool);
1037 
1038     function DOMAIN_SEPARATOR() external view returns (bytes32);
1039 
1040     function PERMIT_TYPEHASH() external pure returns (bytes32);
1041 
1042     function nonces(address owner) external view returns (uint);
1043 
1044     function permit(
1045         address owner,
1046         address spender,
1047         uint value,
1048         uint deadline,
1049         uint8 v,
1050         bytes32 r,
1051         bytes32 s
1052     ) external;
1053 
1054     event Mint(address indexed sender, uint amount0, uint amount1);
1055     event Burn(
1056         address indexed sender,
1057         uint amount0,
1058         uint amount1,
1059         address indexed to
1060     );
1061     event Swap(
1062         address indexed sender,
1063         uint amount0In,
1064         uint amount1In,
1065         uint amount0Out,
1066         uint amount1Out,
1067         address indexed to
1068     );
1069     event Sync(uint112 reserve0, uint112 reserve1);
1070 
1071     function MINIMUM_LIQUIDITY() external pure returns (uint);
1072 
1073     function factory() external view returns (address);
1074 
1075     function token0() external view returns (address);
1076 
1077     function token1() external view returns (address);
1078 
1079     function getReserves()
1080         external
1081         view
1082         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1083 
1084     function price0CumulativeLast() external view returns (uint);
1085 
1086     function price1CumulativeLast() external view returns (uint);
1087 
1088     function kLast() external view returns (uint);
1089 
1090     function mint(address to) external returns (uint liquidity);
1091 
1092     function burn(address to) external returns (uint amount0, uint amount1);
1093 
1094     function swap(
1095         uint amount0Out,
1096         uint amount1Out,
1097         address to,
1098         bytes calldata data
1099     ) external;
1100 
1101     function skim(address to) external;
1102 
1103     function sync() external;
1104 
1105     function initialize(address, address) external;
1106 }
1107 
1108 /**
1109  */
1110 
1111 pragma solidity >=0.5.0;
1112 
1113 interface IUniswapV2Factory {
1114     event PairCreated(
1115         address indexed token0,
1116         address indexed token1,
1117         address pair,
1118         uint
1119     );
1120 
1121     function feeTo() external view returns (address);
1122 
1123     function feeToSetter() external view returns (address);
1124 
1125     function getPair(
1126         address tokenA,
1127         address tokenB
1128     ) external view returns (address pair);
1129 
1130     function allPairs(uint) external view returns (address pair);
1131 
1132     function allPairsLength() external view returns (uint);
1133 
1134     function createPair(
1135         address tokenA,
1136         address tokenB
1137     ) external returns (address pair);
1138 
1139     function setFeeTo(address) external;
1140 
1141     function setFeeToSetter(address) external;
1142 }
1143 
1144 /**
1145  */
1146 
1147 pragma solidity >=0.6.2;
1148 
1149 ////import './IUniswapV2Router01.sol';
1150 
1151 interface IUniswapV2Router02 is IUniswapV2Router01 {
1152     function removeLiquidityETHSupportingFeeOnTransferTokens(
1153         address token,
1154         uint liquidity,
1155         uint amountTokenMin,
1156         uint amountETHMin,
1157         address to,
1158         uint deadline
1159     ) external returns (uint amountETH);
1160 
1161     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1162         address token,
1163         uint liquidity,
1164         uint amountTokenMin,
1165         uint amountETHMin,
1166         address to,
1167         uint deadline,
1168         bool approveMax,
1169         uint8 v,
1170         bytes32 r,
1171         bytes32 s
1172     ) external returns (uint amountETH);
1173 
1174     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1175         uint amountIn,
1176         uint amountOutMin,
1177         address[] calldata path,
1178         address to,
1179         uint deadline
1180     ) external;
1181 
1182     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1183         uint amountOutMin,
1184         address[] calldata path,
1185         address to,
1186         uint deadline
1187     ) external payable;
1188 
1189     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1190         uint amountIn,
1191         uint amountOutMin,
1192         address[] calldata path,
1193         address to,
1194         uint deadline
1195     ) external;
1196 }
1197 
1198 /**
1199  */
1200 
1201 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1202 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 ////import "../utils/Context.sol";
1207 
1208 /**
1209  * @dev Contract module which provides a basic access control mechanism, where
1210  * there is an account (an owner) that can be granted exclusive access to
1211  * specific functions.
1212  *
1213  * By default, the owner account will be the one that deploys the contract. This
1214  * can later be changed with {transferOwnership}.
1215  *
1216  * This module is used through inheritance. It will make available the modifier
1217  * `onlyOwner`, which can be applied to your functions to restrict their use to
1218  * the owner.
1219  */
1220 abstract contract Ownable is Context {
1221     address private _owner;
1222 
1223     event OwnershipTransferred(
1224         address indexed previousOwner,
1225         address indexed newOwner
1226     );
1227 
1228     /**
1229      * @dev Initializes the contract setting the deployer as the initial owner.
1230      */
1231     constructor() {
1232         _transferOwnership(_msgSender());
1233     }
1234 
1235     /**
1236      * @dev Throws if called by any account other than the owner.
1237      */
1238     modifier onlyOwner() {
1239         _checkOwner();
1240         _;
1241     }
1242 
1243     /**
1244      * @dev Returns the address of the current owner.
1245      */
1246     function owner() public view virtual returns (address) {
1247         return _owner;
1248     }
1249 
1250     /**
1251      * @dev Throws if the sender is not the owner.
1252      */
1253     function _checkOwner() internal view virtual {
1254         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1255     }
1256 
1257     /**
1258      * @dev Leaves the contract without owner. It will not be possible to call
1259      * `onlyOwner` functions anymore. Can only be called by the current owner.
1260      *
1261      * NOTE: Renouncing ownership will leave the contract without an owner,
1262      * thereby removing any functionality that is only available to the owner.
1263      */
1264     function renounceOwnership() public virtual onlyOwner {
1265         _transferOwnership(address(0));
1266     }
1267 
1268     /**
1269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1270      * Can only be called by the current owner.
1271      */
1272     function transferOwnership(address newOwner) public virtual onlyOwner {
1273         require(
1274             newOwner != address(0),
1275             "Ownable: new owner is the zero address"
1276         );
1277         _transferOwnership(newOwner);
1278     }
1279 
1280     /**
1281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1282      * Internal function without access restriction.
1283      */
1284     function _transferOwnership(address newOwner) internal virtual {
1285         address oldOwner = _owner;
1286         _owner = newOwner;
1287         emit OwnershipTransferred(oldOwner, newOwner);
1288     }
1289 }
1290 
1291 /**
1292  */
1293 
1294 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: Unlicensed
1295 pragma solidity ^0.8.17;
1296 
1297 /* solhint-disable */
1298 
1299 contract TheRealCalcium is ERC20, Ownable {
1300     using SafeMath for uint256;
1301 
1302     IUniswapV2Router02 public router;
1303     address public immutable pair;
1304     address public constant DEAD = address(0xdead);
1305 
1306     struct Fee {
1307         uint16 marketingFee;
1308         uint16 liquidityFee;
1309     }
1310 
1311     bool private swapping;
1312 
1313     Fee public buyFee;
1314     Fee public sellFee;
1315 
1316     uint256 public swapTokensAtAmount;
1317     uint256 public mxWlt;
1318     uint256 public mxBy;
1319     uint256 public mxSl;
1320 
1321     uint16 private totalBuyFee;
1322     uint16 private totalSellFee;
1323 
1324     bool public swapEnabled;
1325 
1326     address payable public marketingWallet =
1327         payable(address(0x23d5D801d27BCa4e0B012cfE78BB7cBf483d685b));
1328 
1329     uint256 private launchBlock;
1330     bool public isTradingEnabled;
1331 
1332     uint256 public constant BLACKLIST_UNTIL = 2; //2 block bot blacklist
1333     uint256 public immutable MIN_SELL_AMOUNT;
1334     uint256 public immutable MAX_BUY_AMOUNT;
1335     uint256 public totalLockedAmount;
1336     uint256 public lockEndTime;
1337 
1338     mapping(address => bool) private _isExcludedFromFees;
1339     mapping(address => bool) public _kekekeList;
1340 
1341     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1342     // could be subject to a maximum transfer amount
1343     mapping(address => bool) public automatedMarketMakerPairs;
1344 
1345     event UpdateRouter(address indexed newAddress, address indexed oldAddress);
1346     event ExcludeFromFees(address indexed account, bool isExcluded);
1347     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1348     event SetAutomatedMarketMakerPair(
1349         address indexed _pair,
1350         bool indexed value
1351     );
1352     event SwapAndLiquify(
1353         uint256 tokensSwapped,
1354         uint256 ethReceived,
1355         uint256 tokensIntoLiqudity
1356     );
1357 
1358     modifier lockTheSwap() {
1359         swapping = true;
1360         _;
1361         swapping = false;
1362     }
1363 
1364     constructor() ERC20("The Real Calcium", "CAL") {
1365         /*
1366             _mint is an internal function in ERC20.sol that is only called here,
1367             and CANNOT be called ever again
1368         */
1369         _mint(owner(), 1 * 10 ** 6 * (10 ** 9));
1370 
1371         buyFee = Fee(0, 10);
1372         sellFee = Fee(10, 10);
1373 
1374         totalBuyFee = 10;
1375         totalSellFee = 20;
1376 
1377         IUniswapV2Router02 _router = IUniswapV2Router02(
1378             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1379         );
1380         // Create a _pair for this new token
1381         address _pair = IUniswapV2Factory(_router.factory()).createPair(
1382             address(this),
1383             _router.WETH()
1384         );
1385 
1386         router = _router;
1387         pair = _pair;
1388 
1389         _setAutomatedMarketMakerPair(_pair, true);
1390         _approve(address(this), address(router), type(uint256).max);
1391 
1392         // exclude from paying fees or having max transaction amount
1393         excludeFromFees(owner(), true);
1394         excludeFromFees(address(this), true);
1395 
1396         mxWlt = (totalSupply() * 3) / 100;
1397         mxBy = totalSupply();
1398         mxSl = totalSupply();
1399         swapTokensAtAmount = (totalSupply() * 1) / 50000;
1400         MIN_SELL_AMOUNT = (totalSupply() * 1) / 100000;
1401         MAX_BUY_AMOUNT = (totalSupply() * 1) / 100000;
1402 
1403         swapEnabled = true;
1404     }
1405 
1406     receive() external payable {}
1407 
1408     function decimals() public pure override returns (uint8) {
1409         return 9;
1410     }
1411 
1412     function updateRouter(address newAddress) public onlyOwner {
1413         emit UpdateRouter(newAddress, address(router));
1414         router = IUniswapV2Router02(newAddress);
1415         _approve(address(this), address(router), type(uint256).max);
1416     }
1417 
1418     function excludeFromFees(address account, bool excluded) public onlyOwner {
1419         _isExcludedFromFees[account] = excluded;
1420         emit ExcludeFromFees(account, excluded);
1421     }
1422 
1423     function lockTokens(uint256 amount) external onlyOwner {
1424         super._transfer(msg.sender, address(this), amount);
1425         totalLockedAmount += amount;
1426         lockEndTime = block.timestamp + 10 days;
1427     }
1428 
1429     function unlockTokens() external onlyOwner {
1430         require(block.timestamp >= lockEndTime, "Not yet");
1431         super._transfer(address(this), msg.sender, totalLockedAmount);
1432         totalLockedAmount = 0;
1433     }
1434 
1435     function removeFromKekeList(address _user) external onlyOwner {
1436         _kekekeList[_user] = false;
1437     }
1438 
1439     function excludeMultipleAccountsFromFees(
1440         address[] calldata accounts,
1441         bool excluded
1442     ) public onlyOwner {
1443         for (uint256 i = 0; i < accounts.length; i++) {
1444             _isExcludedFromFees[accounts[i]] = excluded;
1445         }
1446 
1447         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1448     }
1449 
1450     function setAutomatedMarketMakerPair(
1451         address _pair,
1452         bool value
1453     ) public onlyOwner {
1454         require(
1455             _pair != pair,
1456             "Token: The _pair cannot be removed from automatedMarketMakerPairs"
1457         );
1458         _setAutomatedMarketMakerPair(_pair, value);
1459     }
1460 
1461     function _setAutomatedMarketMakerPair(address _pair, bool value) private {
1462         automatedMarketMakerPairs[_pair] = value;
1463         emit SetAutomatedMarketMakerPair(_pair, value);
1464     }
1465 
1466     function setBuyFee(uint16 marketing, uint16 liquidity) external onlyOwner {
1467         buyFee.marketingFee = marketing;
1468         buyFee.liquidityFee = liquidity;
1469         totalBuyFee = marketing + liquidity;
1470         require(totalBuyFee <= 150, "Total fee cannot be above 15%");
1471     }
1472 
1473     function setSellFee(uint16 marketing, uint16 liquidity) external onlyOwner {
1474         sellFee.marketingFee = marketing;
1475         sellFee.liquidityFee = liquidity;
1476         totalSellFee = marketing + liquidity;
1477         require(totalSellFee <= 150, "Total fee cannot be above 15%");
1478     }
1479 
1480     function isExcludedFromFees(address account) public view returns (bool) {
1481         return _isExcludedFromFees[account];
1482     }
1483 
1484     function enableTrading() external onlyOwner {
1485         require(launchBlock == 0, "Already enabled");
1486         isTradingEnabled = true;
1487         launchBlock = block.number;
1488     }
1489 
1490     function setWallets(address marketing) external onlyOwner {
1491         marketingWallet = payable(marketing);
1492     }
1493 
1494     function setMxWlt(uint256 value) external onlyOwner {
1495         mxWlt = value;
1496     }
1497 
1498     function setmxBy(uint256 value) external onlyOwner {
1499         require(value <= MAX_BUY_AMOUNT, "Buy amount too low");
1500         mxBy = value;
1501     }
1502 
1503     function setmxSl(uint256 value) external onlyOwner {
1504         require(value >= MIN_SELL_AMOUNT, "Sell amount too low");
1505         mxSl = value;
1506     }
1507 
1508     function setSwapEnabled(bool value, uint256 amount) external onlyOwner {
1509         swapEnabled = value;
1510         swapTokensAtAmount = amount;
1511     }
1512 
1513     function _transfer(
1514         address from,
1515         address to,
1516         uint256 amount
1517     ) internal override {
1518         require(from != address(0), "ERC20: transfer from the zero address");
1519         require(to != address(0), "ERC20: transfer to the zero address");
1520         require(
1521             !_kekekeList[from] && !_kekekeList[to],
1522             "Account is blacklisted"
1523         );
1524 
1525         if (amount == 0) {
1526             super._transfer(from, to, 0);
1527             return;
1528         }
1529 
1530         uint256 contractTokenBalance = balanceOf(address(this)) -
1531             totalLockedAmount;
1532         bool overMinimumTokenBalance = contractTokenBalance >=
1533             swapTokensAtAmount;
1534 
1535         if (
1536             swapEnabled &&
1537             !swapping &&
1538             !automatedMarketMakerPairs[from] &&
1539             overMinimumTokenBalance
1540         ) {
1541             contractTokenBalance = swapTokensAtAmount;
1542             uint16 totalFee = totalBuyFee + totalSellFee;
1543 
1544             uint256 swapTokens = contractTokenBalance
1545                 .mul(buyFee.liquidityFee + sellFee.liquidityFee)
1546                 .div(totalFee);
1547             swapAndLiquify(swapTokens);
1548 
1549             uint256 feeTokens = contractTokenBalance - swapTokens;
1550             swapAndSendFee(feeTokens);
1551         }
1552 
1553         bool takeFee = true;
1554 
1555         // if any account belongs to _isExcludedFromFee account then remove the fee
1556         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1557             takeFee = false;
1558         }
1559 
1560         if (takeFee) {
1561             uint256 fees;
1562 
1563             if (!automatedMarketMakerPairs[to]) {
1564                 require(
1565                     amount + balanceOf(to) <= mxWlt,
1566                     "Wallet amount exceeds limit"
1567                 );
1568             }
1569 
1570             require(isTradingEnabled, "Trading not enabled yet");
1571 
1572             if (block.number < launchBlock + BLACKLIST_UNTIL) {
1573                 if (automatedMarketMakerPairs[from]) {
1574                     _kekekeList[to] = true;
1575                 }
1576                 if (automatedMarketMakerPairs[to]) {
1577                     _kekekeList[from] = true;
1578                 }
1579             }
1580 
1581             if (automatedMarketMakerPairs[to]) {
1582                 require(amount <= mxSl, "Sell exceeds limit");
1583                 fees = totalSellFee;
1584             } else if (automatedMarketMakerPairs[from]) {
1585                 require(amount <= mxBy, "Buy exceeds limit");
1586                 fees = totalBuyFee;
1587             }
1588 
1589             uint256 feeAmount = amount.mul(fees).div(1000);
1590             amount = amount.sub(feeAmount);
1591 
1592             super._transfer(from, address(this), feeAmount);
1593         }
1594 
1595         super._transfer(from, to, amount);
1596     }
1597 
1598     function swapAndSendFee(uint256 tokens) private lockTheSwap {
1599         uint256 initialBalance = address(this).balance;
1600         swapTokensForEth(tokens);
1601         uint256 newBalance = address(this).balance.sub(initialBalance);
1602 
1603         marketingWallet.transfer(newBalance);
1604     }
1605 
1606     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1607         // add the liquidity
1608         router.addLiquidityETH{value: ethAmount}(
1609             address(this),
1610             tokenAmount,
1611             0, // slippage is unavoidable
1612             0, // slippage is unavoidable
1613             DEAD,
1614             block.timestamp
1615         );
1616     }
1617 
1618     function swapAndLiquify(uint256 tokens) private lockTheSwap {
1619         // split the contract balance into halves
1620         uint256 half = tokens.div(2);
1621         uint256 otherHalf = tokens.sub(half);
1622 
1623         uint256 initialBalance = address(this).balance;
1624 
1625         // swap tokens for ETH
1626         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1627 
1628         // how much ETH did we just swap into?
1629         uint256 newBalance = address(this).balance.sub(initialBalance);
1630 
1631         // add liquidity to uniswap
1632         addLiquidity(otherHalf, newBalance);
1633 
1634         emit SwapAndLiquify(half, newBalance, otherHalf);
1635     }
1636 
1637     function swapTokensForEth(uint256 tokenAmount) private {
1638         // generate the uniswap _pair path of token -> weth
1639         address[] memory path = new address[](2);
1640         path[0] = address(this);
1641         path[1] = router.WETH();
1642 
1643         // make the swap
1644         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1645             tokenAmount,
1646             0, // accept any amount of ETH
1647             path,
1648             address(this),
1649             block.timestamp
1650         );
1651     }
1652 }