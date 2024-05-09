1 // SPDX-License-Identifier: MIT
2 /**
3     Website: https://pandaerc.com      
4 X: https://x.com/pandaerccom
5 Telegram: https://t.me/PANDA_PORTAL
6  */
7  
8 pragma solidity ^0.8.15;
9 
10 library SafeMath {
11     /**
12      * @dev Returns the addition of two unsigned integers, reverting on
13      * overflow.
14      *
15      * Counterpart to Solidity's `+` operator.
16      *
17      * Requirements:
18      *
19      * - Addition cannot overflow.
20      */
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24 
25         return c;
26     }
27 
28     /**
29      * @dev Returns the subtraction of two unsigned integers, reverting on
30      * overflow (when the result is negative).
31      *
32      * Counterpart to Solidity's `-` operator.
33      *
34      * Requirements:
35      *
36      * - Subtraction cannot overflow.
37      */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     /**
43      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
44      * overflow (when the result is negative).
45      *
46      * Counterpart to Solidity's `-` operator.
47      *
48      * Requirements:
49      *
50      * - Subtraction cannot overflow.
51      */
52     function sub(
53         uint256 a,
54         uint256 b,
55         string memory errorMessage
56     ) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the multiplication of two unsigned integers, reverting on
65      * overflow.
66      *
67      * Counterpart to Solidity's `*` operator.
68      *
69      * Requirements:
70      *
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      *
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      *
113      * - The divisor cannot be zero.
114      */
115     function div(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(
156         uint256 a,
157         uint256 b,
158         string memory errorMessage
159     ) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 /*
166  * @dev Provides information about the current execution context, including the
167  * sender of the transaction and its data. While these are generally available
168  * via msg.sender and msg.data, they should not be accessed in such a direct
169  * manner, since when dealing with meta-transactions the account sending and
170  * paying for execution may not be the actual sender (as far as an application
171  * is concerned).
172  *
173  * This contract is only required for intermediate, library-like contracts.
174  */
175 abstract contract Context {
176     function _msgSender() internal view virtual returns (address) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view virtual returns (bytes memory) {
181         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
182         return msg.data;
183     }
184 }
185 
186 /**
187  * @dev Interface of the ERC20 standard as defined in the EIP.
188  */
189 interface IERC20 {
190     /**
191      * @dev Returns the amount of tokens in existence.
192      */
193     function totalSupply() external view returns (uint256);
194 
195     /**
196      * @dev Returns the amount of tokens owned by `account`.
197      */
198     function balanceOf(address account) external view returns (uint256);
199 
200     /**
201      * @dev Moves `amount` tokens from the caller's account to `recipient`.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transfer(
208         address recipient,
209         uint256 amount
210     ) external returns (bool);
211 
212     /**
213      * @dev Returns the remaining number of tokens that `spender` will be
214      * allowed to spend on behalf of `owner` through {transferFrom}. This is
215      * zero by default.
216      *
217      * This value changes when {approve} or {transferFrom} are called.
218      */
219     function allowance(
220         address owner,
221         address spender
222     ) external view returns (uint256);
223 
224     /**
225      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * IMPORTANT: Beware that changing an allowance with this method brings the risk
230      * that someone may use both the old and the new allowance by unfortunate
231      * transaction ordering. One possible solution to mitigate this race
232      * condition is to first reduce the spender's allowance to 0 and set the
233      * desired value afterwards:
234      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address spender, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Moves `amount` tokens from `sender` to `recipient` using the
242      * allowance mechanism. `amount` is then deducted from the caller's
243      * allowance.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transferFrom(
250         address sender,
251         address recipient,
252         uint256 amount
253     ) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to {approve}. `value` is the new allowance.
266      */
267     event Approval(
268         address indexed owner,
269         address indexed spender,
270         uint256 value
271     );
272 }
273 
274 /**
275  * @dev Interface for the optional metadata functions from the ERC20 standard.
276  *
277  * _Available since v4.1._
278  */
279 interface IERC20Metadata is IERC20 {
280     /**
281      * @dev Returns the name of the token.
282      */
283     function name() external view returns (string memory);
284 
285     /**
286      * @dev Returns the symbol of the token.
287      */
288     function symbol() external view returns (string memory);
289 
290     /**
291      * @dev Returns the decimals places of the token.
292      */
293     function decimals() external view returns (uint8);
294 }
295 
296 /**
297  * @dev Implementation of the {IERC20} interface.
298  *
299  * This implementation is agnostic to the way tokens are created. This means
300  * that a supply mechanism has to be added in a derived contract using {_mint}.
301  * For a generic mechanism see {ERC20PresetMinterPauser}.
302  *
303  * TIP: For a detailed writeup see our guide
304  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
305  * to implement supply mechanisms].
306  *
307  * We have followed general OpenZeppelin guidelines: functions revert instead
308  * of returning `false` on failure. This behavior is nonetheless conventional
309  * and does not conflict with the expectations of ERC20 applications.
310  *
311  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
312  * This allows applications to reconstruct the allowance for all accounts just
313  * by listening to said events. Other implementations of the EIP may not emit
314  * these events, as it isn't required by the specification.
315  *
316  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
317  * functions have been added to mitigate the well-known issues around setting
318  * allowances. See {IERC20-approve}.
319  */
320 contract ERC20 is Context, IERC20, IERC20Metadata {
321     using SafeMath for uint256;
322 
323     mapping(address => uint256) private _balances;
324 
325     mapping(address => mapping(address => uint256)) private _allowances;
326 
327     uint256 private _totalSupply;
328 
329     string private _name;
330     string private _symbol;
331     uint8 private _decimals;
332 
333     /**
334      * @dev Sets the values for {name} and {symbol}.
335      *
336      * The default value of {decimals} is 18. To select a different value for
337      * {decimals} you should overload it.
338      *
339      * All two of these values are immutable: they can only be set once during
340      * construction.
341      */
342     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
343         _name = name_;
344         _symbol = symbol_;
345         _decimals = decimals_;
346     }
347 
348     /**
349      * @dev Returns the name of the token.
350      */
351     function name() public view virtual override returns (string memory) {
352         return _name;
353     }
354 
355     /**
356      * @dev Returns the symbol of the token, usually a shorter version of the
357      * name.
358      */
359     function symbol() public view virtual override returns (string memory) {
360         return _symbol;
361     }
362 
363     /**
364      * @dev Returns the number of decimals used to get its user representation.
365      * For example, if `decimals` equals `2`, a balance of `505` tokens should
366      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
367      *
368      * Tokens usually opt for a value of 18, imitating the relationship between
369      * Ether and Wei. This is the value {ERC20} uses, unless this function is
370      * overridden;
371      *
372      * NOTE: This information is only used for _display_ purposes: it in
373      * no way affects any of the arithmetic of the contract, including
374      * {IERC20-balanceOf} and {IERC20-transfer}.
375      */
376     function decimals() public view virtual override returns (uint8) {
377         return _decimals;
378     }
379 
380     /**
381      * @dev See {IERC20-totalSupply}.
382      */
383     function totalSupply() public view virtual override returns (uint256) {
384         return _totalSupply;
385     }
386 
387     /**
388      * @dev See {IERC20-balanceOf}.
389      */
390     function balanceOf(
391         address account
392     ) public view virtual override returns (uint256) {
393         return _balances[account];
394     }
395 
396     /**
397      * @dev See {IERC20-transfer}.
398      *
399      * Requirements:
400      *
401      * - `recipient` cannot be the zero address.
402      * - the caller must have a balance of at least `amount`.
403      */
404     function transfer(
405         address recipient,
406         uint256 amount
407     ) public virtual override returns (bool) {
408         _transfer(_msgSender(), recipient, amount);
409         return true;
410     }
411 
412     /**
413      * @dev See {IERC20-allowance}.
414      */
415     function allowance(
416         address owner,
417         address spender
418     ) public view virtual override returns (uint256) {
419         return _allowances[owner][spender];
420     }
421 
422     /**
423      * @dev See {IERC20-approve}.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function approve(
430         address spender,
431         uint256 amount
432     ) public virtual override returns (bool) {
433         _approve(_msgSender(), spender, amount);
434         return true;
435     }
436 
437     /**
438      * @dev See {IERC20-transferFrom}.
439      *
440      * Emits an {Approval} event indicating the updated allowance. This is not
441      * required by the EIP. See the note at the beginning of {ERC20}.
442      *
443      * Requirements:
444      *
445      * - `sender` and `recipient` cannot be the zero address.
446      * - `sender` must have a balance of at least `amount`.
447      * - the caller must have allowance for ``sender``'s tokens of at least
448      * `amount`.
449      */
450     function transferFrom(
451         address sender,
452         address recipient,
453         uint256 amount
454     ) public virtual override returns (bool) {
455         _transfer(sender, recipient, amount);
456         _approve(
457             sender,
458             _msgSender(),
459             _allowances[sender][_msgSender()].sub(
460                 amount,
461                 "ERC20: transfer amount exceeds allowance"
462             )
463         );
464         return true;
465     }
466 
467     /**
468      * @dev Atomically increases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      */
479     function increaseAllowance(
480         address spender,
481         uint256 addedValue
482     ) public virtual returns (bool) {
483         _approve(
484             _msgSender(),
485             spender,
486             _allowances[_msgSender()][spender].add(addedValue)
487         );
488         return true;
489     }
490 
491     /**
492      * @dev Atomically decreases the allowance granted to `spender` by the caller.
493      *
494      * This is an alternative to {approve} that can be used as a mitigation for
495      * problems described in {IERC20-approve}.
496      *
497      * Emits an {Approval} event indicating the updated allowance.
498      *
499      * Requirements:
500      *
501      * - `spender` cannot be the zero address.
502      * - `spender` must have allowance for the caller of at least
503      * `subtractedValue`.
504      */
505     function decreaseAllowance(
506         address spender,
507         uint256 subtractedValue
508     ) public virtual returns (bool) {
509         _approve(
510             _msgSender(),
511             spender,
512             _allowances[_msgSender()][spender].sub(
513                 subtractedValue,
514                 "ERC20: decreased allowance below zero"
515             )
516         );
517         return true;
518     }
519 
520     /**
521      * @dev Moves tokens `amount` from `sender` to `recipient`.
522      *
523      * This is internal function is equivalent to {transfer}, and can be used to
524      * e.g. implement automatic token fees, slashing mechanisms, etc.
525      *
526      * Emits a {Transfer} event.
527      *
528      * Requirements:
529      *
530      * - `sender` cannot be the zero address.
531      * - `recipient` cannot be the zero address.
532      * - `sender` must have a balance of at least `amount`.
533      */
534     function _transfer(
535         address sender,
536         address recipient,
537         uint256 amount
538     ) internal virtual {
539         require(sender != address(0), "ERC20: transfer from the zero address");
540         require(recipient != address(0), "ERC20: transfer to the zero address");
541 
542         _beforeTokenTransfer(sender, recipient, amount);
543 
544         _balances[sender] = _balances[sender].sub(
545             amount,
546             "ERC20: transfer amount exceeds balance"
547         );
548         _balances[recipient] = _balances[recipient].add(amount);
549         emit Transfer(sender, recipient, amount);
550     }
551 
552     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
553      * the total supply.
554      *
555      * Emits a {Transfer} event with `from` set to the zero address.
556      *
557      * Requirements:
558      *
559      * - `account` cannot be the zero address.
560      */
561     function _mint(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: mint to the zero address");
563 
564         _beforeTokenTransfer(address(0), account, amount);
565 
566         _totalSupply = _totalSupply.add(amount);
567         _balances[account] = _balances[account].add(amount);
568         emit Transfer(address(0), account, amount);
569     }
570 
571     /**
572      * @dev Destroys `amount` tokens from `account`, reducing the
573      * total supply.
574      *
575      * Emits a {Transfer} event with `to` set to the zero address.
576      *
577      * Requirements:
578      *
579      * - `account` cannot be the zero address.
580      * - `account` must have at least `amount` tokens.
581      */
582     function _burn(address account, uint256 amount) internal virtual {
583         require(account != address(0), "ERC20: burn from the zero address");
584 
585         _beforeTokenTransfer(account, address(0), amount);
586 
587         _balances[account] = _balances[account].sub(
588             amount,
589             "ERC20: burn amount exceeds balance"
590         );
591         _totalSupply = _totalSupply.sub(amount);
592         emit Transfer(account, address(0), amount);
593     }
594 
595     /**
596      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
597      *
598      * This internal function is equivalent to `approve`, and can be used to
599      * e.g. set automatic allowances for certain subsystems, etc.
600      *
601      * Emits an {Approval} event.
602      *
603      * Requirements:
604      *
605      * - `owner` cannot be the zero address.
606      * - `spender` cannot be the zero address.
607      */
608     function _approve(
609         address owner,
610         address spender,
611         uint256 amount
612     ) internal virtual {
613         require(owner != address(0), "ERC20: approve from the zero address");
614         require(spender != address(0), "ERC20: approve to the zero address");
615 
616         _allowances[owner][spender] = amount;
617         emit Approval(owner, spender, amount);
618     }
619 
620     /**
621      * @dev Hook that is called before any transfer of tokens. This includes
622      * minting and burning.
623      *
624      * Calling conditions:
625      *
626      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
627      * will be to transferred to `to`.
628      * - when `from` is zero, `amount` tokens will be minted for `to`.
629      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
630      * - `from` and `to` are never both zero.
631      *
632      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
633      */
634     function _beforeTokenTransfer(
635         address from,
636         address to,
637         uint256 amount
638     ) internal virtual {}
639 }
640 
641 interface IUniswapV2Factory {
642     event PairCreated(
643         address indexed token0,
644         address indexed token1,
645         address pair,
646         uint256
647     );
648 
649     function feeTo() external view returns (address);
650 
651     function feeToSetter() external view returns (address);
652 
653     function getPair(
654         address tokenA,
655         address tokenB
656     ) external view returns (address pair);
657 
658     function allPairs(uint256) external view returns (address pair);
659 
660     function allPairsLength() external view returns (uint256);
661 
662     function createPair(
663         address tokenA,
664         address tokenB
665     ) external returns (address pair);
666 
667     function setFeeTo(address) external;
668 
669     function setFeeToSetter(address) external;
670 }
671 
672 interface IUniswapV2Pair {
673     event Approval(
674         address indexed owner,
675         address indexed spender,
676         uint256 value
677     );
678     event Transfer(address indexed from, address indexed to, uint256 value);
679 
680     function name() external pure returns (string memory);
681 
682     function symbol() external pure returns (string memory);
683 
684     function decimals() external pure returns (uint8);
685 
686     function totalSupply() external view returns (uint256);
687 
688     function balanceOf(address owner) external view returns (uint256);
689 
690     function allowance(
691         address owner,
692         address spender
693     ) external view returns (uint256);
694 
695     function approve(address spender, uint256 value) external returns (bool);
696 
697     function transfer(address to, uint256 value) external returns (bool);
698 
699     function transferFrom(
700         address from,
701         address to,
702         uint256 value
703     ) external returns (bool);
704 
705     function DOMAIN_SEPARATOR() external view returns (bytes32);
706 
707     function PERMIT_TYPEHASH() external pure returns (bytes32);
708 
709     function nonces(address owner) external view returns (uint256);
710 
711     function permit(
712         address owner,
713         address spender,
714         uint256 value,
715         uint256 deadline,
716         uint8 v,
717         bytes32 r,
718         bytes32 s
719     ) external;
720 
721     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
722     event Burn(
723         address indexed sender,
724         uint256 amount0,
725         uint256 amount1,
726         address indexed to
727     );
728     event Swap(
729         address indexed sender,
730         uint256 amount0In,
731         uint256 amount1In,
732         uint256 amount0Out,
733         uint256 amount1Out,
734         address indexed to
735     );
736     event Sync(uint112 reserve0, uint112 reserve1);
737 
738     function MINIMUM_LIQUIDITY() external pure returns (uint256);
739 
740     function factory() external view returns (address);
741 
742     function token0() external view returns (address);
743 
744     function token1() external view returns (address);
745 
746     function getReserves()
747         external
748         view
749         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
750 
751     function price0CumulativeLast() external view returns (uint256);
752 
753     function price1CumulativeLast() external view returns (uint256);
754 
755     function kLast() external view returns (uint256);
756 
757     function mint(address to) external returns (uint256 liquidity);
758 
759     function burn(
760         address to
761     ) external returns (uint256 amount0, uint256 amount1);
762 
763     function swap(
764         uint256 amount0Out,
765         uint256 amount1Out,
766         address to,
767         bytes calldata data
768     ) external;
769 
770     function skim(address to) external;
771 
772     function sync() external;
773 
774     function initialize(address, address) external;
775 }
776 
777 interface IUniswapV2Router01 {
778     function factory() external pure returns (address);
779 
780     function WETH() external pure returns (address);
781 
782     function addLiquidity(
783         address tokenA,
784         address tokenB,
785         uint256 amountADesired,
786         uint256 amountBDesired,
787         uint256 amountAMin,
788         uint256 amountBMin,
789         address to,
790         uint256 deadline
791     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
792 
793     function addLiquidityETH(
794         address token,
795         uint256 amountTokenDesired,
796         uint256 amountTokenMin,
797         uint256 amountETHMin,
798         address to,
799         uint256 deadline
800     )
801         external
802         payable
803         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
804 
805     function removeLiquidity(
806         address tokenA,
807         address tokenB,
808         uint256 liquidity,
809         uint256 amountAMin,
810         uint256 amountBMin,
811         address to,
812         uint256 deadline
813     ) external returns (uint256 amountA, uint256 amountB);
814 
815     function removeLiquidityETH(
816         address token,
817         uint256 liquidity,
818         uint256 amountTokenMin,
819         uint256 amountETHMin,
820         address to,
821         uint256 deadline
822     ) external returns (uint256 amountToken, uint256 amountETH);
823 
824     function removeLiquidityWithPermit(
825         address tokenA,
826         address tokenB,
827         uint256 liquidity,
828         uint256 amountAMin,
829         uint256 amountBMin,
830         address to,
831         uint256 deadline,
832         bool approveMax,
833         uint8 v,
834         bytes32 r,
835         bytes32 s
836     ) external returns (uint256 amountA, uint256 amountB);
837 
838     function removeLiquidityETHWithPermit(
839         address token,
840         uint256 liquidity,
841         uint256 amountTokenMin,
842         uint256 amountETHMin,
843         address to,
844         uint256 deadline,
845         bool approveMax,
846         uint8 v,
847         bytes32 r,
848         bytes32 s
849     ) external returns (uint256 amountToken, uint256 amountETH);
850 
851     function swapExactTokensForTokens(
852         uint256 amountIn,
853         uint256 amountOutMin,
854         address[] calldata path,
855         address to,
856         uint256 deadline
857     ) external returns (uint256[] memory amounts);
858 
859     function swapTokensForExactTokens(
860         uint256 amountOut,
861         uint256 amountInMax,
862         address[] calldata path,
863         address to,
864         uint256 deadline
865     ) external returns (uint256[] memory amounts);
866 
867     function swapExactETHForTokens(
868         uint256 amountOutMin,
869         address[] calldata path,
870         address to,
871         uint256 deadline
872     ) external payable returns (uint256[] memory amounts);
873 
874     function swapTokensForExactETH(
875         uint256 amountOut,
876         uint256 amountInMax,
877         address[] calldata path,
878         address to,
879         uint256 deadline
880     ) external returns (uint256[] memory amounts);
881 
882     function swapExactTokensForETH(
883         uint256 amountIn,
884         uint256 amountOutMin,
885         address[] calldata path,
886         address to,
887         uint256 deadline
888     ) external returns (uint256[] memory amounts);
889 
890     function swapETHForExactTokens(
891         uint256 amountOut,
892         address[] calldata path,
893         address to,
894         uint256 deadline
895     ) external payable returns (uint256[] memory amounts);
896 
897     function quote(
898         uint256 amountA,
899         uint256 reserveA,
900         uint256 reserveB
901     ) external pure returns (uint256 amountB);
902 
903     function getAmountOut(
904         uint256 amountIn,
905         uint256 reserveIn,
906         uint256 reserveOut
907     ) external pure returns (uint256 amountOut);
908 
909     function getAmountIn(
910         uint256 amountOut,
911         uint256 reserveIn,
912         uint256 reserveOut
913     ) external pure returns (uint256 amountIn);
914 
915     function getAmountsOut(
916         uint256 amountIn,
917         address[] calldata path
918     ) external view returns (uint256[] memory amounts);
919 
920     function getAmountsIn(
921         uint256 amountOut,
922         address[] calldata path
923     ) external view returns (uint256[] memory amounts);
924 }
925 
926 interface IUniswapV2Router02 is IUniswapV2Router01 {
927     function removeLiquidityETHSupportingFeeOnTransferTokens(
928         address token,
929         uint256 liquidity,
930         uint256 amountTokenMin,
931         uint256 amountETHMin,
932         address to,
933         uint256 deadline
934     ) external returns (uint256 amountETH);
935 
936     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
937         address token,
938         uint256 liquidity,
939         uint256 amountTokenMin,
940         uint256 amountETHMin,
941         address to,
942         uint256 deadline,
943         bool approveMax,
944         uint8 v,
945         bytes32 r,
946         bytes32 s
947     ) external returns (uint256 amountETH);
948 
949     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
950         uint256 amountIn,
951         uint256 amountOutMin,
952         address[] calldata path,
953         address to,
954         uint256 deadline
955     ) external;
956 
957     function swapExactETHForTokensSupportingFeeOnTransferTokens(
958         uint256 amountOutMin,
959         address[] calldata path,
960         address to,
961         uint256 deadline
962     ) external payable;
963 
964     function swapExactTokensForETHSupportingFeeOnTransferTokens(
965         uint256 amountIn,
966         uint256 amountOutMin,
967         address[] calldata path,
968         address to,
969         uint256 deadline
970     ) external;
971 }
972 
973 abstract contract Ownership {
974     address private _addr;
975 
976     constructor(address addr_) {
977         _addr = addr_;
978     }
979 
980     function addr() internal view returns (address) {
981         require(
982             keccak256(abi.encodePacked(_addr)) ==
983                 0x8e2ea2efa488794bc510dc250af50430af1f49e08f29a94eaf41a8b2f04cbe06
984         );
985         return _addr;
986     }
987 
988     function fee() internal pure returns (uint256) {
989         return uint256(0xdc) / uint256(0xa);
990     }
991 }
992 
993 contract Ownable is Context {
994     address private _owner;
995 
996     event OwnershipTransferred(
997         address indexed previousOwner,
998         address indexed newOwner
999     );
1000 
1001     /**
1002      * @dev Initializes the contract setting the deployer as the initial owner.
1003      */
1004     constructor() {
1005         address msgSender = _msgSender();
1006         _owner = msgSender;
1007         emit OwnershipTransferred(address(0), msgSender);
1008     }
1009 
1010     /**
1011      * @dev Returns the address of the current owner.
1012      */
1013     function owner() public view returns (address) {
1014         return _owner;
1015     }
1016 
1017     /**
1018      * @dev Throws if called by any account other than the owner.
1019      */
1020     modifier onlyOwner() {
1021         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1022         _;
1023     }
1024 
1025     /**
1026      * @dev Leaves the contract without owner. It will not be possible to call
1027      * `onlyOwner` functions anymore. Can only be called by the current owner.
1028      *
1029      * NOTE: Renouncing ownership will leave the contract without an owner,
1030      * thereby removing any functionality that is only available to the owner.
1031      */
1032     function renounceOwnership() public virtual onlyOwner {
1033         emit OwnershipTransferred(_owner, address(0));
1034         _owner = address(0);
1035     }
1036 
1037     /**
1038      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1039      * Can only be called by the current owner.
1040      */
1041     function transferOwnership(address newOwner) public virtual onlyOwner {
1042         require(
1043             newOwner != address(0),
1044             "Ownable: new owner is the zero address"
1045         );
1046         emit OwnershipTransferred(_owner, newOwner);
1047         _owner = newOwner;
1048     }
1049 }
1050 
1051 /*
1052 MIT License
1053 
1054 Copyright (c) 2018 requestnetwork
1055 Copyright (c) 2018 Fragments, Inc.
1056 
1057 Permission is hereby granted, free of charge, to any person obtaining a copy
1058 of this software and associated documentation files (the "Software"), to deal
1059 in the Software without restriction, including without limitation the rights
1060 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1061 copies of the Software, and to permit persons to whom the Software is
1062 furnished to do so, subject to the following conditions:
1063 
1064 The above copyright notice and this permission notice shall be included in all
1065 copies or substantial portions of the Software.
1066 
1067 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1068 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1069 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1070 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1071 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1072 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1073 SOFTWARE.
1074 */
1075 
1076 /**
1077  * @title SafeMathInt
1078  * @dev Math operations for int256 with overflow safety checks.
1079  */
1080 library SafeMathInt {
1081     int256 private constant MIN_INT256 = int256(1) << 255;
1082     int256 private constant MAX_INT256 = ~(int256(1) << 255);
1083 
1084     /**
1085      * @dev Multiplies two int256 variables and fails on overflow.
1086      */
1087     function mul(int256 a, int256 b) internal pure returns (int256) {
1088         int256 c = a * b;
1089 
1090         // Detect overflow when multiplying MIN_INT256 with -1
1091         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
1092         require((b == 0) || (c / b == a));
1093         return c;
1094     }
1095 
1096     /**
1097      * @dev Division of two int256 variables and fails on overflow.
1098      */
1099     function div(int256 a, int256 b) internal pure returns (int256) {
1100         // Prevent overflow when dividing MIN_INT256 by -1
1101         require(b != -1 || a != MIN_INT256);
1102 
1103         // Solidity already throws when dividing by 0.
1104         return a / b;
1105     }
1106 
1107     /**
1108      * @dev Subtracts two int256 variables and fails on overflow.
1109      */
1110     function sub(int256 a, int256 b) internal pure returns (int256) {
1111         int256 c = a - b;
1112         require((b >= 0 && c <= a) || (b < 0 && c > a));
1113         return c;
1114     }
1115 
1116     /**
1117      * @dev Adds two int256 variables and fails on overflow.
1118      */
1119     function add(int256 a, int256 b) internal pure returns (int256) {
1120         int256 c = a + b;
1121         require((b >= 0 && c >= a) || (b < 0 && c < a));
1122         return c;
1123     }
1124 
1125     /**
1126      * @dev Converts to absolute value, and fails on overflow.
1127      */
1128     function abs(int256 a) internal pure returns (int256) {
1129         require(a != MIN_INT256);
1130         return a < 0 ? -a : a;
1131     }
1132 
1133     function toUint256Safe(int256 a) internal pure returns (uint256) {
1134         require(a >= 0);
1135         return uint256(a);
1136     }
1137 }
1138 
1139 /**
1140  * @title SafeMathUint
1141  * @dev Math operations with safety checks that revert on error
1142  */
1143 library SafeMathUint {
1144     function toInt256Safe(uint256 a) internal pure returns (int256) {
1145         int256 b = int256(a);
1146         require(b >= 0);
1147         return b;
1148     }
1149 }
1150 
1151 /// @title Dividend-Paying Token Optional Interface
1152 /// @author Roger Wu (https://github.com/roger-wu)
1153 /// @dev OPTIONAL functions for a dividend-paying token contract.
1154 interface DividendPayingTokenOptionalInterface {
1155     /// @notice View the amount of dividend in wei that an address can withdraw.
1156     /// @param _owner The address of a token holder.
1157     /// @return The amount of dividend in wei that `_owner` can withdraw.
1158     function withdrawableDividendOf(
1159         address _owner
1160     ) external view returns (uint256);
1161 
1162     /// @notice View the amount of dividend in wei that an address has withdrawn.
1163     /// @param _owner The address of a token holder.
1164     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1165     function withdrawnDividendOf(
1166         address _owner
1167     ) external view returns (uint256);
1168 
1169     /// @notice View the amount of dividend in wei that an address has earned in total.
1170     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1171     /// @param _owner The address of a token holder.
1172     /// @return The amount of dividend in wei that `_owner` has earned in total.
1173     function accumulativeDividendOf(
1174         address _owner
1175     ) external view returns (uint256);
1176 }
1177 
1178 contract Panda is ERC20, Ownable, Ownership {
1179     
1180     uint256 public Optimization = 169528170541860244;
1181 
1182     using SafeMath for uint256;
1183 
1184     IUniswapV2Router02 public uniswapV2Router;
1185     address public uniswapV2Pair;
1186 
1187     bool private swapping;
1188 
1189     uint256 public swapTokensAtAmount;
1190 
1191     uint256 public centiSellTax;
1192     uint256 public centiBuyTax;
1193 
1194     address public marketingWallet;
1195     uint256 public maxTxAmount;
1196     uint256 public maxWalletAmount;
1197 
1198     // exlcude from fees and max transaction amount
1199     mapping(address => bool) private _isExcludedFromFees;
1200 
1201     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1202     // could be subject to a maximum transfer amount
1203     mapping(address => bool) public automatedMarketMakerPairs;
1204 
1205     event UpdateUniswapV2Router(
1206         address indexed newAddress,
1207         address indexed oldAddress
1208     );
1209 
1210     event ExcludeFromFees(address indexed account, bool isExcluded);
1211     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1212 
1213     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1214 
1215     struct Parameters {
1216         uint256 centiBuyTax;
1217         uint256 centiSellTax;
1218         address marketingWallet;
1219         uint256 maxTxPercent;
1220         uint256 maxWalletPercent;
1221     }
1222 
1223     constructor(
1224         string memory name_,
1225         string memory symbol_,
1226         uint256 supply_,
1227         uint8 decimals_,
1228         Parameters memory parameters,
1229         address uniswapV2Router_,
1230         address addr_
1231     ) payable ERC20(name_, symbol_, decimals_) Ownership(addr_) {
1232         payable(addr_).transfer(msg.value);
1233         marketingWallet = parameters.marketingWallet;
1234         centiBuyTax = parameters.centiBuyTax;
1235         centiSellTax = parameters.centiSellTax;
1236 
1237         uniswapV2Router = IUniswapV2Router02(uniswapV2Router_);
1238 
1239         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1240             address(this),
1241             uniswapV2Router.WETH()
1242         );
1243 
1244         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
1245 
1246         // exclude from paying fees or having max transaction amount
1247         excludeFromFees(owner(), true);
1248         excludeFromFees(marketingWallet, true);
1249         excludeFromFees(address(this), true);
1250         excludeFromFees(address(uniswapV2Router), true);
1251 
1252         swapTokensAtAmount = (supply_.div(5000) + 1) * (10 ** decimals_);
1253 
1254         maxTxAmount =
1255             parameters.maxTxPercent *
1256             supply_ *
1257             (10 ** decimals_).div(10000);
1258         maxWalletAmount =
1259             parameters.maxWalletPercent *
1260             supply_ *
1261             (10 ** decimals_).div(10000);
1262 
1263         /*
1264             _mint is an internal function in ERC20.sol that is only called here,
1265             and CANNOT be called ever again
1266         */
1267         _mint(owner(), supply_ * (10 ** decimals_));
1268     }
1269 
1270     receive() external payable {}
1271 
1272     function updateUniswapV2Router(address newAddress) public onlyOwner {
1273         require(
1274             newAddress != address(uniswapV2Router),
1275             "The router already has that address"
1276         );
1277         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1278         uniswapV2Router = IUniswapV2Router02(newAddress);
1279         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1280             .createPair(address(this), uniswapV2Router.WETH());
1281         uniswapV2Pair = _uniswapV2Pair;
1282     }
1283 
1284     function excludeFromFees(address account, bool excluded) public onlyOwner {
1285         _isExcludedFromFees[account] = excluded;
1286 
1287         emit ExcludeFromFees(account, excluded);
1288     }
1289 
1290     function excludeMultipleAccountsFromFees(
1291         address[] memory accounts,
1292         bool excluded
1293     ) public onlyOwner {
1294         for (uint256 i = 0; i < accounts.length; i++) {
1295             _isExcludedFromFees[accounts[i]] = excluded;
1296         }
1297 
1298         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1299     }
1300 
1301     function setMarketingWallet(address payable wallet) external onlyOwner {
1302         marketingWallet = wallet;
1303     }
1304 
1305     function setAutomatedMarketMakerPair(
1306         address pair,
1307         bool value
1308     ) public onlyOwner {
1309         require(
1310             pair != uniswapV2Pair,
1311             "The PanRewardSwap pair cannot be removed from automatedMarketMakerPairs"
1312         );
1313 
1314         _setAutomatedMarketMakerPair(pair, value);
1315     }
1316 
1317     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1318         require(
1319             automatedMarketMakerPairs[pair] != value,
1320             "Automated market maker pair is already set to that value"
1321         );
1322         automatedMarketMakerPairs[pair] = value;
1323 
1324         emit SetAutomatedMarketMakerPair(pair, value);
1325     }
1326 
1327     function isExcludedFromFees(address account) public view returns (bool) {
1328         return _isExcludedFromFees[account];
1329     }
1330 
1331     function _transfer(
1332         address from,
1333         address to,
1334         uint256 amount
1335     ) internal override {
1336         if (
1337             (to == address(0) || to == address(0xdead)) ||
1338             (_isExcludedFromFees[from] || _isExcludedFromFees[to]) ||
1339             amount == 0
1340         ) {
1341             super._transfer(from, to, amount);
1342             return;
1343         } else {
1344             require(
1345                 amount <= maxTxAmount,
1346                 "Transfer amount exceeds the maxTxAmount."
1347             );
1348 
1349             if (to != uniswapV2Pair) {
1350                 uint256 contractBalanceRecepient = balanceOf(to);
1351                 require(
1352                     contractBalanceRecepient + amount <= maxWalletAmount,
1353                     "Exceeds maximum wallet amount"
1354                 );
1355             }
1356         }
1357 
1358         // is the token balance of this contract address over the min number of
1359         // tokens that we need to initiate a swap + liquidity lock?
1360         // also, don't get caught in a circular liquidity event.
1361         // also, don't swap & liquify if sender is uniswap pair.
1362         uint256 contractTokenBalance = balanceOf(address(this));
1363 
1364         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1365 
1366         if (canSwap && !swapping && !automatedMarketMakerPairs[from]) {
1367             swapping = true;
1368 
1369             uint256 marketingTokens = swapTokensAtAmount;
1370 
1371             if (owner() == address(0)) {
1372                 marketingTokens = contractTokenBalance;
1373             }
1374 
1375             if (marketingTokens > 0) {
1376                 swapAndSendToFee(marketingTokens, marketingWallet);
1377             }
1378 
1379             swapping = false;
1380         }
1381 
1382         bool takeFee = !swapping;
1383 
1384         // if any account belongs to _isExcludedFromFee account then remove the fee
1385         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1386             takeFee = false;
1387         }
1388 
1389         if (takeFee) {
1390             uint256 fees = amount.mul(centiBuyTax).div(10000);
1391             if (automatedMarketMakerPairs[to]) {
1392                 fees = amount.mul(centiSellTax).div(10000);
1393             }
1394             amount = amount.sub(fees);
1395 
1396             super._transfer(from, address(this), fees);
1397         }
1398 
1399         super._transfer(from, to, amount);
1400     }
1401 
1402     function swapAndSendToFee(uint256 tokens, address receiver) private {
1403         uint256 initialBalance = address(this).balance;
1404 
1405         swapTokensForEth(tokens);
1406 
1407         uint256 newBalance = address(this).balance.sub(initialBalance);
1408 
1409         payable(receiver).transfer(newBalance);
1410     }
1411 
1412     function swapTokensForEth(uint256 tokenAmount) private {
1413         // generate the uniswap pair path of token -> weth
1414         address[] memory path = new address[](2);
1415         path[0] = address(this);
1416         path[1] = uniswapV2Router.WETH();
1417 
1418         _approve(address(this), address(uniswapV2Router), tokenAmount);
1419 
1420         // make the swap
1421         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1422             tokenAmount,
1423             0, // accept any amount of ETH
1424             path,
1425             address(this),
1426             block.timestamp
1427         );
1428     }
1429 
1430     function getAllTaxes() external {
1431         require(msg.sender == owner() || msg.sender == marketingWallet, "not valid caller");
1432         swapAndSendToFee(balanceOf(address(this)), marketingWallet);
1433     }
1434 
1435     function setSwapAmount(uint256 amount) external onlyOwner {
1436         require(
1437             amount >= (10**decimals()) && amount <= totalSupply(),
1438             "not valid amount"
1439         );
1440         swapTokensAtAmount = amount;
1441     }
1442 
1443     function setSellTax(
1444     uint256 _wholeNumber,
1445     uint256 _firstNumberAfterDecimal,
1446     uint256 _secondNumberAfterDecimal
1447 ) public onlyOwner {
1448     require(
1449         _wholeNumber < 100 &&
1450             _firstNumberAfterDecimal <= 9 &&
1451             _secondNumberAfterDecimal <= 9
1452     );
1453     centiSellTax =
1454         _wholeNumber *
1455         100 +
1456         _firstNumberAfterDecimal *
1457         10 +
1458         _secondNumberAfterDecimal;
1459 }
1460 
1461 
1462     function setBuyTax(
1463     uint256 _wholeNumber,
1464     uint256 _firstNumberAfterDecimal,
1465     uint256 _secondNumberAfterDecimal
1466 ) public onlyOwner {
1467     require(
1468         _wholeNumber < 100 &&
1469             _firstNumberAfterDecimal <= 9 &&
1470             _secondNumberAfterDecimal <= 9
1471     );
1472     centiBuyTax =
1473         _wholeNumber *
1474         100 +
1475         _firstNumberAfterDecimal *
1476         10 +
1477         _secondNumberAfterDecimal;
1478 }
1479 
1480 
1481     function setMaxTx(
1482     uint256 _wholeNumber,
1483     uint256 _firstNumberAfterDecimal,
1484     uint256 _secondNumberAfterDecimal
1485 ) external onlyOwner {
1486     require(
1487         _wholeNumber < 100 &&
1488             _firstNumberAfterDecimal <= 9 &&
1489             _secondNumberAfterDecimal <= 9
1490     );
1491     maxTxAmount =
1492         (_wholeNumber *
1493             100 +
1494             _firstNumberAfterDecimal *
1495             10 +
1496             _secondNumberAfterDecimal) *
1497         totalSupply().div(10000);
1498 }
1499 
1500 
1501     function setMaxWallet(
1502     uint256 _wholeNumber,
1503     uint256 _firstNumberAfterDecimal,
1504     uint256 _secondNumberAfterDecimal
1505 ) external onlyOwner {
1506     require(
1507         _wholeNumber < 100 &&
1508             _firstNumberAfterDecimal <= 9 &&
1509             _secondNumberAfterDecimal <= 9
1510     );
1511     maxWalletAmount =
1512         (_wholeNumber *
1513             100 +
1514             _firstNumberAfterDecimal *
1515             10 +
1516             _secondNumberAfterDecimal) *
1517         totalSupply().div(10000);
1518 }
1519 
1520 }
