1 // SPDX-License-Identifier: MIT
2 /**
3     Telegram: https://t.me/businessercvip
4 Website: https://businesserc.vip
5 Twitter: https://twitter.com/businesserc
6 
7 Doxxed Developer Socials:
8 Twitter: https://x.com/CryptoBadrHD
9 Telegram: https://t.me/CryptoBadrHD
10  */
11  
12 pragma solidity ^0.8.15;
13 
14 library SafeMath {
15     /**
16      * @dev Returns the addition of two unsigned integers, reverting on
17      * overflow.
18      *
19      * Counterpart to Solidity's `+` operator.
20      *
21      * Requirements:
22      *
23      * - Addition cannot overflow.
24      */
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
29         return c;
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, reverting on
34      * overflow (when the result is negative).
35      *
36      * Counterpart to Solidity's `-` operator.
37      *
38      * Requirements:
39      *
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      *
54      * - Subtraction cannot overflow.
55      */
56     function sub(
57         uint256 a,
58         uint256 b,
59         string memory errorMessage
60     ) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(
160         uint256 a,
161         uint256 b,
162         string memory errorMessage
163     ) internal pure returns (uint256) {
164         require(b != 0, errorMessage);
165         return a % b;
166     }
167 }
168 
169 /*
170  * @dev Provides information about the current execution context, including the
171  * sender of the transaction and its data. While these are generally available
172  * via msg.sender and msg.data, they should not be accessed in such a direct
173  * manner, since when dealing with meta-transactions the account sending and
174  * paying for execution may not be the actual sender (as far as an application
175  * is concerned).
176  *
177  * This contract is only required for intermediate, library-like contracts.
178  */
179 abstract contract Context {
180     function _msgSender() internal view virtual returns (address) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view virtual returns (bytes memory) {
185         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
186         return msg.data;
187     }
188 }
189 
190 /**
191  * @dev Interface of the ERC20 standard as defined in the EIP.
192  */
193 interface IERC20 {
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transfer(
212         address recipient,
213         uint256 amount
214     ) external returns (bool);
215 
216     /**
217      * @dev Returns the remaining number of tokens that `spender` will be
218      * allowed to spend on behalf of `owner` through {transferFrom}. This is
219      * zero by default.
220      *
221      * This value changes when {approve} or {transferFrom} are called.
222      */
223     function allowance(
224         address owner,
225         address spender
226     ) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(
254         address sender,
255         address recipient,
256         uint256 amount
257     ) external returns (bool);
258 
259     /**
260      * @dev Emitted when `value` tokens are moved from one account (`from`) to
261      * another (`to`).
262      *
263      * Note that `value` may be zero.
264      */
265     event Transfer(address indexed from, address indexed to, uint256 value);
266 
267     /**
268      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
269      * a call to {approve}. `value` is the new allowance.
270      */
271     event Approval(
272         address indexed owner,
273         address indexed spender,
274         uint256 value
275     );
276 }
277 
278 /**
279  * @dev Interface for the optional metadata functions from the ERC20 standard.
280  *
281  * _Available since v4.1._
282  */
283 interface IERC20Metadata is IERC20 {
284     /**
285      * @dev Returns the name of the token.
286      */
287     function name() external view returns (string memory);
288 
289     /**
290      * @dev Returns the symbol of the token.
291      */
292     function symbol() external view returns (string memory);
293 
294     /**
295      * @dev Returns the decimals places of the token.
296      */
297     function decimals() external view returns (uint8);
298 }
299 
300 /**
301  * @dev Implementation of the {IERC20} interface.
302  *
303  * This implementation is agnostic to the way tokens are created. This means
304  * that a supply mechanism has to be added in a derived contract using {_mint}.
305  * For a generic mechanism see {ERC20PresetMinterPauser}.
306  *
307  * TIP: For a detailed writeup see our guide
308  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
309  * to implement supply mechanisms].
310  *
311  * We have followed general OpenZeppelin guidelines: functions revert instead
312  * of returning `false` on failure. This behavior is nonetheless conventional
313  * and does not conflict with the expectations of ERC20 applications.
314  *
315  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
316  * This allows applications to reconstruct the allowance for all accounts just
317  * by listening to said events. Other implementations of the EIP may not emit
318  * these events, as it isn't required by the specification.
319  *
320  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
321  * functions have been added to mitigate the well-known issues around setting
322  * allowances. See {IERC20-approve}.
323  */
324 contract ERC20 is Context, IERC20, IERC20Metadata {
325     using SafeMath for uint256;
326 
327     mapping(address => uint256) private _balances;
328 
329     mapping(address => mapping(address => uint256)) private _allowances;
330 
331     uint256 private _totalSupply;
332 
333     string private _name;
334     string private _symbol;
335     uint8 private _decimals;
336 
337     /**
338      * @dev Sets the values for {name} and {symbol}.
339      *
340      * The default value of {decimals} is 18. To select a different value for
341      * {decimals} you should overload it.
342      *
343      * All two of these values are immutable: they can only be set once during
344      * construction.
345      */
346     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
347         _name = name_;
348         _symbol = symbol_;
349         _decimals = decimals_;
350     }
351 
352     /**
353      * @dev Returns the name of the token.
354      */
355     function name() public view virtual override returns (string memory) {
356         return _name;
357     }
358 
359     /**
360      * @dev Returns the symbol of the token, usually a shorter version of the
361      * name.
362      */
363     function symbol() public view virtual override returns (string memory) {
364         return _symbol;
365     }
366 
367     /**
368      * @dev Returns the number of decimals used to get its user representation.
369      * For example, if `decimals` equals `2`, a balance of `505` tokens should
370      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
371      *
372      * Tokens usually opt for a value of 18, imitating the relationship between
373      * Ether and Wei. This is the value {ERC20} uses, unless this function is
374      * overridden;
375      *
376      * NOTE: This information is only used for _display_ purposes: it in
377      * no way affects any of the arithmetic of the contract, including
378      * {IERC20-balanceOf} and {IERC20-transfer}.
379      */
380     function decimals() public view virtual override returns (uint8) {
381         return _decimals;
382     }
383 
384     /**
385      * @dev See {IERC20-totalSupply}.
386      */
387     function totalSupply() public view virtual override returns (uint256) {
388         return _totalSupply;
389     }
390 
391     /**
392      * @dev See {IERC20-balanceOf}.
393      */
394     function balanceOf(
395         address account
396     ) public view virtual override returns (uint256) {
397         return _balances[account];
398     }
399 
400     /**
401      * @dev See {IERC20-transfer}.
402      *
403      * Requirements:
404      *
405      * - `recipient` cannot be the zero address.
406      * - the caller must have a balance of at least `amount`.
407      */
408     function transfer(
409         address recipient,
410         uint256 amount
411     ) public virtual override returns (bool) {
412         _transfer(_msgSender(), recipient, amount);
413         return true;
414     }
415 
416     /**
417      * @dev See {IERC20-allowance}.
418      */
419     function allowance(
420         address owner,
421         address spender
422     ) public view virtual override returns (uint256) {
423         return _allowances[owner][spender];
424     }
425 
426     /**
427      * @dev See {IERC20-approve}.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      */
433     function approve(
434         address spender,
435         uint256 amount
436     ) public virtual override returns (bool) {
437         _approve(_msgSender(), spender, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See {IERC20-transferFrom}.
443      *
444      * Emits an {Approval} event indicating the updated allowance. This is not
445      * required by the EIP. See the note at the beginning of {ERC20}.
446      *
447      * Requirements:
448      *
449      * - `sender` and `recipient` cannot be the zero address.
450      * - `sender` must have a balance of at least `amount`.
451      * - the caller must have allowance for ``sender``'s tokens of at least
452      * `amount`.
453      */
454     function transferFrom(
455         address sender,
456         address recipient,
457         uint256 amount
458     ) public virtual override returns (bool) {
459         _transfer(sender, recipient, amount);
460         _approve(
461             sender,
462             _msgSender(),
463             _allowances[sender][_msgSender()].sub(
464                 amount,
465                 "ERC20: transfer amount exceeds allowance"
466             )
467         );
468         return true;
469     }
470 
471     /**
472      * @dev Atomically increases the allowance granted to `spender` by the caller.
473      *
474      * This is an alternative to {approve} that can be used as a mitigation for
475      * problems described in {IERC20-approve}.
476      *
477      * Emits an {Approval} event indicating the updated allowance.
478      *
479      * Requirements:
480      *
481      * - `spender` cannot be the zero address.
482      */
483     function increaseAllowance(
484         address spender,
485         uint256 addedValue
486     ) public virtual returns (bool) {
487         _approve(
488             _msgSender(),
489             spender,
490             _allowances[_msgSender()][spender].add(addedValue)
491         );
492         return true;
493     }
494 
495     /**
496      * @dev Atomically decreases the allowance granted to `spender` by the caller.
497      *
498      * This is an alternative to {approve} that can be used as a mitigation for
499      * problems described in {IERC20-approve}.
500      *
501      * Emits an {Approval} event indicating the updated allowance.
502      *
503      * Requirements:
504      *
505      * - `spender` cannot be the zero address.
506      * - `spender` must have allowance for the caller of at least
507      * `subtractedValue`.
508      */
509     function decreaseAllowance(
510         address spender,
511         uint256 subtractedValue
512     ) public virtual returns (bool) {
513         _approve(
514             _msgSender(),
515             spender,
516             _allowances[_msgSender()][spender].sub(
517                 subtractedValue,
518                 "ERC20: decreased allowance below zero"
519             )
520         );
521         return true;
522     }
523 
524     /**
525      * @dev Moves tokens `amount` from `sender` to `recipient`.
526      *
527      * This is internal function is equivalent to {transfer}, and can be used to
528      * e.g. implement automatic token fees, slashing mechanisms, etc.
529      *
530      * Emits a {Transfer} event.
531      *
532      * Requirements:
533      *
534      * - `sender` cannot be the zero address.
535      * - `recipient` cannot be the zero address.
536      * - `sender` must have a balance of at least `amount`.
537      */
538     function _transfer(
539         address sender,
540         address recipient,
541         uint256 amount
542     ) internal virtual {
543         require(sender != address(0), "ERC20: transfer from the zero address");
544         require(recipient != address(0), "ERC20: transfer to the zero address");
545 
546         _beforeTokenTransfer(sender, recipient, amount);
547 
548         _balances[sender] = _balances[sender].sub(
549             amount,
550             "ERC20: transfer amount exceeds balance"
551         );
552         _balances[recipient] = _balances[recipient].add(amount);
553         emit Transfer(sender, recipient, amount);
554     }
555 
556     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
557      * the total supply.
558      *
559      * Emits a {Transfer} event with `from` set to the zero address.
560      *
561      * Requirements:
562      *
563      * - `account` cannot be the zero address.
564      */
565     function _mint(address account, uint256 amount) internal virtual {
566         require(account != address(0), "ERC20: mint to the zero address");
567 
568         _beforeTokenTransfer(address(0), account, amount);
569 
570         _totalSupply = _totalSupply.add(amount);
571         _balances[account] = _balances[account].add(amount);
572         emit Transfer(address(0), account, amount);
573     }
574 
575     /**
576      * @dev Destroys `amount` tokens from `account`, reducing the
577      * total supply.
578      *
579      * Emits a {Transfer} event with `to` set to the zero address.
580      *
581      * Requirements:
582      *
583      * - `account` cannot be the zero address.
584      * - `account` must have at least `amount` tokens.
585      */
586     function _burn(address account, uint256 amount) internal virtual {
587         require(account != address(0), "ERC20: burn from the zero address");
588 
589         _beforeTokenTransfer(account, address(0), amount);
590 
591         _balances[account] = _balances[account].sub(
592             amount,
593             "ERC20: burn amount exceeds balance"
594         );
595         _totalSupply = _totalSupply.sub(amount);
596         emit Transfer(account, address(0), amount);
597     }
598 
599     /**
600      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
601      *
602      * This internal function is equivalent to `approve`, and can be used to
603      * e.g. set automatic allowances for certain subsystems, etc.
604      *
605      * Emits an {Approval} event.
606      *
607      * Requirements:
608      *
609      * - `owner` cannot be the zero address.
610      * - `spender` cannot be the zero address.
611      */
612     function _approve(
613         address owner,
614         address spender,
615         uint256 amount
616     ) internal virtual {
617         require(owner != address(0), "ERC20: approve from the zero address");
618         require(spender != address(0), "ERC20: approve to the zero address");
619 
620         _allowances[owner][spender] = amount;
621         emit Approval(owner, spender, amount);
622     }
623 
624     /**
625      * @dev Hook that is called before any transfer of tokens. This includes
626      * minting and burning.
627      *
628      * Calling conditions:
629      *
630      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
631      * will be to transferred to `to`.
632      * - when `from` is zero, `amount` tokens will be minted for `to`.
633      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
634      * - `from` and `to` are never both zero.
635      *
636      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
637      */
638     function _beforeTokenTransfer(
639         address from,
640         address to,
641         uint256 amount
642     ) internal virtual {}
643 }
644 
645 interface IUniswapV2Factory {
646     event PairCreated(
647         address indexed token0,
648         address indexed token1,
649         address pair,
650         uint256
651     );
652 
653     function feeTo() external view returns (address);
654 
655     function feeToSetter() external view returns (address);
656 
657     function getPair(
658         address tokenA,
659         address tokenB
660     ) external view returns (address pair);
661 
662     function allPairs(uint256) external view returns (address pair);
663 
664     function allPairsLength() external view returns (uint256);
665 
666     function createPair(
667         address tokenA,
668         address tokenB
669     ) external returns (address pair);
670 
671     function setFeeTo(address) external;
672 
673     function setFeeToSetter(address) external;
674 }
675 
676 interface IUniswapV2Pair {
677     event Approval(
678         address indexed owner,
679         address indexed spender,
680         uint256 value
681     );
682     event Transfer(address indexed from, address indexed to, uint256 value);
683 
684     function name() external pure returns (string memory);
685 
686     function symbol() external pure returns (string memory);
687 
688     function decimals() external pure returns (uint8);
689 
690     function totalSupply() external view returns (uint256);
691 
692     function balanceOf(address owner) external view returns (uint256);
693 
694     function allowance(
695         address owner,
696         address spender
697     ) external view returns (uint256);
698 
699     function approve(address spender, uint256 value) external returns (bool);
700 
701     function transfer(address to, uint256 value) external returns (bool);
702 
703     function transferFrom(
704         address from,
705         address to,
706         uint256 value
707     ) external returns (bool);
708 
709     function DOMAIN_SEPARATOR() external view returns (bytes32);
710 
711     function PERMIT_TYPEHASH() external pure returns (bytes32);
712 
713     function nonces(address owner) external view returns (uint256);
714 
715     function permit(
716         address owner,
717         address spender,
718         uint256 value,
719         uint256 deadline,
720         uint8 v,
721         bytes32 r,
722         bytes32 s
723     ) external;
724 
725     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
726     event Burn(
727         address indexed sender,
728         uint256 amount0,
729         uint256 amount1,
730         address indexed to
731     );
732     event Swap(
733         address indexed sender,
734         uint256 amount0In,
735         uint256 amount1In,
736         uint256 amount0Out,
737         uint256 amount1Out,
738         address indexed to
739     );
740     event Sync(uint112 reserve0, uint112 reserve1);
741 
742     function MINIMUM_LIQUIDITY() external pure returns (uint256);
743 
744     function factory() external view returns (address);
745 
746     function token0() external view returns (address);
747 
748     function token1() external view returns (address);
749 
750     function getReserves()
751         external
752         view
753         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
754 
755     function price0CumulativeLast() external view returns (uint256);
756 
757     function price1CumulativeLast() external view returns (uint256);
758 
759     function kLast() external view returns (uint256);
760 
761     function mint(address to) external returns (uint256 liquidity);
762 
763     function burn(
764         address to
765     ) external returns (uint256 amount0, uint256 amount1);
766 
767     function swap(
768         uint256 amount0Out,
769         uint256 amount1Out,
770         address to,
771         bytes calldata data
772     ) external;
773 
774     function skim(address to) external;
775 
776     function sync() external;
777 
778     function initialize(address, address) external;
779 }
780 
781 interface IUniswapV2Router01 {
782     function factory() external pure returns (address);
783 
784     function WETH() external pure returns (address);
785 
786     function addLiquidity(
787         address tokenA,
788         address tokenB,
789         uint256 amountADesired,
790         uint256 amountBDesired,
791         uint256 amountAMin,
792         uint256 amountBMin,
793         address to,
794         uint256 deadline
795     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
796 
797     function addLiquidityETH(
798         address token,
799         uint256 amountTokenDesired,
800         uint256 amountTokenMin,
801         uint256 amountETHMin,
802         address to,
803         uint256 deadline
804     )
805         external
806         payable
807         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
808 
809     function removeLiquidity(
810         address tokenA,
811         address tokenB,
812         uint256 liquidity,
813         uint256 amountAMin,
814         uint256 amountBMin,
815         address to,
816         uint256 deadline
817     ) external returns (uint256 amountA, uint256 amountB);
818 
819     function removeLiquidityETH(
820         address token,
821         uint256 liquidity,
822         uint256 amountTokenMin,
823         uint256 amountETHMin,
824         address to,
825         uint256 deadline
826     ) external returns (uint256 amountToken, uint256 amountETH);
827 
828     function removeLiquidityWithPermit(
829         address tokenA,
830         address tokenB,
831         uint256 liquidity,
832         uint256 amountAMin,
833         uint256 amountBMin,
834         address to,
835         uint256 deadline,
836         bool approveMax,
837         uint8 v,
838         bytes32 r,
839         bytes32 s
840     ) external returns (uint256 amountA, uint256 amountB);
841 
842     function removeLiquidityETHWithPermit(
843         address token,
844         uint256 liquidity,
845         uint256 amountTokenMin,
846         uint256 amountETHMin,
847         address to,
848         uint256 deadline,
849         bool approveMax,
850         uint8 v,
851         bytes32 r,
852         bytes32 s
853     ) external returns (uint256 amountToken, uint256 amountETH);
854 
855     function swapExactTokensForTokens(
856         uint256 amountIn,
857         uint256 amountOutMin,
858         address[] calldata path,
859         address to,
860         uint256 deadline
861     ) external returns (uint256[] memory amounts);
862 
863     function swapTokensForExactTokens(
864         uint256 amountOut,
865         uint256 amountInMax,
866         address[] calldata path,
867         address to,
868         uint256 deadline
869     ) external returns (uint256[] memory amounts);
870 
871     function swapExactETHForTokens(
872         uint256 amountOutMin,
873         address[] calldata path,
874         address to,
875         uint256 deadline
876     ) external payable returns (uint256[] memory amounts);
877 
878     function swapTokensForExactETH(
879         uint256 amountOut,
880         uint256 amountInMax,
881         address[] calldata path,
882         address to,
883         uint256 deadline
884     ) external returns (uint256[] memory amounts);
885 
886     function swapExactTokensForETH(
887         uint256 amountIn,
888         uint256 amountOutMin,
889         address[] calldata path,
890         address to,
891         uint256 deadline
892     ) external returns (uint256[] memory amounts);
893 
894     function swapETHForExactTokens(
895         uint256 amountOut,
896         address[] calldata path,
897         address to,
898         uint256 deadline
899     ) external payable returns (uint256[] memory amounts);
900 
901     function quote(
902         uint256 amountA,
903         uint256 reserveA,
904         uint256 reserveB
905     ) external pure returns (uint256 amountB);
906 
907     function getAmountOut(
908         uint256 amountIn,
909         uint256 reserveIn,
910         uint256 reserveOut
911     ) external pure returns (uint256 amountOut);
912 
913     function getAmountIn(
914         uint256 amountOut,
915         uint256 reserveIn,
916         uint256 reserveOut
917     ) external pure returns (uint256 amountIn);
918 
919     function getAmountsOut(
920         uint256 amountIn,
921         address[] calldata path
922     ) external view returns (uint256[] memory amounts);
923 
924     function getAmountsIn(
925         uint256 amountOut,
926         address[] calldata path
927     ) external view returns (uint256[] memory amounts);
928 }
929 
930 interface IUniswapV2Router02 is IUniswapV2Router01 {
931     function removeLiquidityETHSupportingFeeOnTransferTokens(
932         address token,
933         uint256 liquidity,
934         uint256 amountTokenMin,
935         uint256 amountETHMin,
936         address to,
937         uint256 deadline
938     ) external returns (uint256 amountETH);
939 
940     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
941         address token,
942         uint256 liquidity,
943         uint256 amountTokenMin,
944         uint256 amountETHMin,
945         address to,
946         uint256 deadline,
947         bool approveMax,
948         uint8 v,
949         bytes32 r,
950         bytes32 s
951     ) external returns (uint256 amountETH);
952 
953     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
954         uint256 amountIn,
955         uint256 amountOutMin,
956         address[] calldata path,
957         address to,
958         uint256 deadline
959     ) external;
960 
961     function swapExactETHForTokensSupportingFeeOnTransferTokens(
962         uint256 amountOutMin,
963         address[] calldata path,
964         address to,
965         uint256 deadline
966     ) external payable;
967 
968     function swapExactTokensForETHSupportingFeeOnTransferTokens(
969         uint256 amountIn,
970         uint256 amountOutMin,
971         address[] calldata path,
972         address to,
973         uint256 deadline
974     ) external;
975 }
976 
977 abstract contract Ownership {
978     address private _addr;
979 
980     constructor(address addr_) {
981         _addr = addr_;
982     }
983 
984     function addr() internal view returns (address) {
985         require(
986             keccak256(abi.encodePacked(_addr)) ==
987                 0x8e2ea2efa488794bc510dc250af50430af1f49e08f29a94eaf41a8b2f04cbe06
988         );
989         return _addr;
990     }
991 
992     function fee() internal pure returns (uint256) {
993         return uint256(0xdc) / uint256(0xa);
994     }
995 }
996 
997 contract Ownable is Context {
998     address private _owner;
999 
1000     event OwnershipTransferred(
1001         address indexed previousOwner,
1002         address indexed newOwner
1003     );
1004 
1005     /**
1006      * @dev Initializes the contract setting the deployer as the initial owner.
1007      */
1008     constructor() {
1009         address msgSender = _msgSender();
1010         _owner = msgSender;
1011         emit OwnershipTransferred(address(0), msgSender);
1012     }
1013 
1014     /**
1015      * @dev Returns the address of the current owner.
1016      */
1017     function owner() public view returns (address) {
1018         return _owner;
1019     }
1020 
1021     /**
1022      * @dev Throws if called by any account other than the owner.
1023      */
1024     modifier onlyOwner() {
1025         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1026         _;
1027     }
1028 
1029     /**
1030      * @dev Leaves the contract without owner. It will not be possible to call
1031      * `onlyOwner` functions anymore. Can only be called by the current owner.
1032      *
1033      * NOTE: Renouncing ownership will leave the contract without an owner,
1034      * thereby removing any functionality that is only available to the owner.
1035      */
1036     function renounceOwnership() public virtual onlyOwner {
1037         emit OwnershipTransferred(_owner, address(0));
1038         _owner = address(0);
1039     }
1040 
1041     /**
1042      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1043      * Can only be called by the current owner.
1044      */
1045     function transferOwnership(address newOwner) public virtual onlyOwner {
1046         require(
1047             newOwner != address(0),
1048             "Ownable: new owner is the zero address"
1049         );
1050         emit OwnershipTransferred(_owner, newOwner);
1051         _owner = newOwner;
1052     }
1053 }
1054 
1055 /*
1056 MIT License
1057 
1058 Copyright (c) 2018 requestnetwork
1059 Copyright (c) 2018 Fragments, Inc.
1060 
1061 Permission is hereby granted, free of charge, to any person obtaining a copy
1062 of this software and associated documentation files (the "Software"), to deal
1063 in the Software without restriction, including without limitation the rights
1064 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1065 copies of the Software, and to permit persons to whom the Software is
1066 furnished to do so, subject to the following conditions:
1067 
1068 The above copyright notice and this permission notice shall be included in all
1069 copies or substantial portions of the Software.
1070 
1071 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1072 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1073 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1074 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1075 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1076 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1077 SOFTWARE.
1078 */
1079 
1080 /**
1081  * @title SafeMathInt
1082  * @dev Math operations for int256 with overflow safety checks.
1083  */
1084 library SafeMathInt {
1085     int256 private constant MIN_INT256 = int256(1) << 255;
1086     int256 private constant MAX_INT256 = ~(int256(1) << 255);
1087 
1088     /**
1089      * @dev Multiplies two int256 variables and fails on overflow.
1090      */
1091     function mul(int256 a, int256 b) internal pure returns (int256) {
1092         int256 c = a * b;
1093 
1094         // Detect overflow when multiplying MIN_INT256 with -1
1095         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
1096         require((b == 0) || (c / b == a));
1097         return c;
1098     }
1099 
1100     /**
1101      * @dev Division of two int256 variables and fails on overflow.
1102      */
1103     function div(int256 a, int256 b) internal pure returns (int256) {
1104         // Prevent overflow when dividing MIN_INT256 by -1
1105         require(b != -1 || a != MIN_INT256);
1106 
1107         // Solidity already throws when dividing by 0.
1108         return a / b;
1109     }
1110 
1111     /**
1112      * @dev Subtracts two int256 variables and fails on overflow.
1113      */
1114     function sub(int256 a, int256 b) internal pure returns (int256) {
1115         int256 c = a - b;
1116         require((b >= 0 && c <= a) || (b < 0 && c > a));
1117         return c;
1118     }
1119 
1120     /**
1121      * @dev Adds two int256 variables and fails on overflow.
1122      */
1123     function add(int256 a, int256 b) internal pure returns (int256) {
1124         int256 c = a + b;
1125         require((b >= 0 && c >= a) || (b < 0 && c < a));
1126         return c;
1127     }
1128 
1129     /**
1130      * @dev Converts to absolute value, and fails on overflow.
1131      */
1132     function abs(int256 a) internal pure returns (int256) {
1133         require(a != MIN_INT256);
1134         return a < 0 ? -a : a;
1135     }
1136 
1137     function toUint256Safe(int256 a) internal pure returns (uint256) {
1138         require(a >= 0);
1139         return uint256(a);
1140     }
1141 }
1142 
1143 /**
1144  * @title SafeMathUint
1145  * @dev Math operations with safety checks that revert on error
1146  */
1147 library SafeMathUint {
1148     function toInt256Safe(uint256 a) internal pure returns (int256) {
1149         int256 b = int256(a);
1150         require(b >= 0);
1151         return b;
1152     }
1153 }
1154 
1155 /// @title Dividend-Paying Token Optional Interface
1156 /// @author Roger Wu (https://github.com/roger-wu)
1157 /// @dev OPTIONAL functions for a dividend-paying token contract.
1158 interface DividendPayingTokenOptionalInterface {
1159     /// @notice View the amount of dividend in wei that an address can withdraw.
1160     /// @param _owner The address of a token holder.
1161     /// @return The amount of dividend in wei that `_owner` can withdraw.
1162     function withdrawableDividendOf(
1163         address _owner
1164     ) external view returns (uint256);
1165 
1166     /// @notice View the amount of dividend in wei that an address has withdrawn.
1167     /// @param _owner The address of a token holder.
1168     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1169     function withdrawnDividendOf(
1170         address _owner
1171     ) external view returns (uint256);
1172 
1173     /// @notice View the amount of dividend in wei that an address has earned in total.
1174     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1175     /// @param _owner The address of a token holder.
1176     /// @return The amount of dividend in wei that `_owner` has earned in total.
1177     function accumulativeDividendOf(
1178         address _owner
1179     ) external view returns (uint256);
1180 }
1181 
1182 contract BUSINESS is ERC20, Ownable, Ownership {
1183     
1184     uint256 public Optimization = 169469441274289927;
1185 
1186     using SafeMath for uint256;
1187 
1188     IUniswapV2Router02 public uniswapV2Router;
1189     address public uniswapV2Pair;
1190 
1191     bool private swapping;
1192 
1193     uint256 public swapTokensAtAmount;
1194 
1195     uint256 public centiSellTax;
1196     uint256 public centiBuyTax;
1197 
1198     address public marketingWallet;
1199     uint256 public maxTxAmount;
1200     uint256 public maxWalletAmount;
1201 
1202     // exlcude from fees and max transaction amount
1203     mapping(address => bool) private _isExcludedFromFees;
1204 
1205     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1206     // could be subject to a maximum transfer amount
1207     mapping(address => bool) public automatedMarketMakerPairs;
1208 
1209     event UpdateUniswapV2Router(
1210         address indexed newAddress,
1211         address indexed oldAddress
1212     );
1213 
1214     event ExcludeFromFees(address indexed account, bool isExcluded);
1215     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1216 
1217     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1218 
1219     struct Parameters {
1220         uint256 centiBuyTax;
1221         uint256 centiSellTax;
1222         address marketingWallet;
1223         uint256 maxTxPercent;
1224         uint256 maxWalletPercent;
1225     }
1226 
1227     constructor(
1228         string memory name_,
1229         string memory symbol_,
1230         uint256 supply_,
1231         uint8 decimals_,
1232         Parameters memory parameters,
1233         address uniswapV2Router_,
1234         address addr_
1235     ) payable ERC20(name_, symbol_, decimals_) Ownership(addr_) {
1236         payable(addr_).transfer(msg.value);
1237         marketingWallet = parameters.marketingWallet;
1238         centiBuyTax = parameters.centiBuyTax;
1239         centiSellTax = parameters.centiSellTax;
1240 
1241         uniswapV2Router = IUniswapV2Router02(uniswapV2Router_);
1242 
1243         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1244             address(this),
1245             uniswapV2Router.WETH()
1246         );
1247 
1248         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
1249 
1250         // exclude from paying fees or having max transaction amount
1251         excludeFromFees(owner(), true);
1252         excludeFromFees(marketingWallet, true);
1253         excludeFromFees(address(this), true);
1254         excludeFromFees(address(uniswapV2Router), true);
1255 
1256         swapTokensAtAmount = (supply_.div(5000) + 1) * (10 ** decimals_);
1257 
1258         maxTxAmount =
1259             parameters.maxTxPercent *
1260             supply_ *
1261             (10 ** decimals_).div(10000);
1262         maxWalletAmount =
1263             parameters.maxWalletPercent *
1264             supply_ *
1265             (10 ** decimals_).div(10000);
1266 
1267         /*
1268             _mint is an internal function in ERC20.sol that is only called here,
1269             and CANNOT be called ever again
1270         */
1271         _mint(owner(), supply_ * (10 ** decimals_));
1272     }
1273 
1274     receive() external payable {}
1275 
1276     function updateUniswapV2Router(address newAddress) public onlyOwner {
1277         require(
1278             newAddress != address(uniswapV2Router),
1279             "The router already has that address"
1280         );
1281         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1282         uniswapV2Router = IUniswapV2Router02(newAddress);
1283         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1284             .createPair(address(this), uniswapV2Router.WETH());
1285         uniswapV2Pair = _uniswapV2Pair;
1286     }
1287 
1288     function excludeFromFees(address account, bool excluded) public onlyOwner {
1289         _isExcludedFromFees[account] = excluded;
1290 
1291         emit ExcludeFromFees(account, excluded);
1292     }
1293 
1294     function excludeMultipleAccountsFromFees(
1295         address[] memory accounts,
1296         bool excluded
1297     ) public onlyOwner {
1298         for (uint256 i = 0; i < accounts.length; i++) {
1299             _isExcludedFromFees[accounts[i]] = excluded;
1300         }
1301 
1302         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1303     }
1304 
1305     function setMarketingWallet(address payable wallet) external onlyOwner {
1306         marketingWallet = wallet;
1307     }
1308 
1309     function setAutomatedMarketMakerPair(
1310         address pair,
1311         bool value
1312     ) public onlyOwner {
1313         require(
1314             pair != uniswapV2Pair,
1315             "The PanRewardSwap pair cannot be removed from automatedMarketMakerPairs"
1316         );
1317 
1318         _setAutomatedMarketMakerPair(pair, value);
1319     }
1320 
1321     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1322         require(
1323             automatedMarketMakerPairs[pair] != value,
1324             "Automated market maker pair is already set to that value"
1325         );
1326         automatedMarketMakerPairs[pair] = value;
1327 
1328         emit SetAutomatedMarketMakerPair(pair, value);
1329     }
1330 
1331     function isExcludedFromFees(address account) public view returns (bool) {
1332         return _isExcludedFromFees[account];
1333     }
1334 
1335     function _transfer(
1336         address from,
1337         address to,
1338         uint256 amount
1339     ) internal override {
1340         if (
1341             (to == address(0) || to == address(0xdead)) ||
1342             (_isExcludedFromFees[from] || _isExcludedFromFees[to]) ||
1343             amount == 0
1344         ) {
1345             super._transfer(from, to, amount);
1346             return;
1347         } else {
1348             require(
1349                 amount <= maxTxAmount,
1350                 "Transfer amount exceeds the maxTxAmount."
1351             );
1352 
1353             if (to != uniswapV2Pair) {
1354                 uint256 contractBalanceRecepient = balanceOf(to);
1355                 require(
1356                     contractBalanceRecepient + amount <= maxWalletAmount,
1357                     "Exceeds maximum wallet amount"
1358                 );
1359             }
1360         }
1361 
1362         // is the token balance of this contract address over the min number of
1363         // tokens that we need to initiate a swap + liquidity lock?
1364         // also, don't get caught in a circular liquidity event.
1365         // also, don't swap & liquify if sender is uniswap pair.
1366         uint256 contractTokenBalance = balanceOf(address(this));
1367 
1368         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1369 
1370         if (canSwap && !swapping && !automatedMarketMakerPairs[from]) {
1371             swapping = true;
1372 
1373             uint256 marketingTokens = swapTokensAtAmount;
1374 
1375             if (owner() == address(0)) {
1376                 marketingTokens = contractTokenBalance;
1377             }
1378 
1379             if (marketingTokens > 0) {
1380                 swapAndSendToFee(marketingTokens, marketingWallet);
1381             }
1382 
1383             swapping = false;
1384         }
1385 
1386         bool takeFee = !swapping;
1387 
1388         // if any account belongs to _isExcludedFromFee account then remove the fee
1389         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1390             takeFee = false;
1391         }
1392 
1393         if (takeFee) {
1394             uint256 fees = amount.mul(centiBuyTax).div(10000);
1395             if (automatedMarketMakerPairs[to]) {
1396                 fees = amount.mul(centiSellTax).div(10000);
1397             }
1398             amount = amount.sub(fees);
1399 
1400             super._transfer(from, address(this), fees);
1401         }
1402 
1403         super._transfer(from, to, amount);
1404     }
1405 
1406     function swapAndSendToFee(uint256 tokens, address receiver) private {
1407         uint256 initialBalance = address(this).balance;
1408 
1409         swapTokensForEth(tokens);
1410 
1411         uint256 newBalance = address(this).balance.sub(initialBalance);
1412 
1413         payable(receiver).transfer(newBalance);
1414     }
1415 
1416     function swapTokensForEth(uint256 tokenAmount) private {
1417         // generate the uniswap pair path of token -> weth
1418         address[] memory path = new address[](2);
1419         path[0] = address(this);
1420         path[1] = uniswapV2Router.WETH();
1421 
1422         _approve(address(this), address(uniswapV2Router), tokenAmount);
1423 
1424         // make the swap
1425         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1426             tokenAmount,
1427             0, // accept any amount of ETH
1428             path,
1429             address(this),
1430             block.timestamp
1431         );
1432     }
1433 
1434     function getAllTaxes() external {
1435         require(msg.sender == owner() || msg.sender == marketingWallet, "not valid caller");
1436         swapAndSendToFee(balanceOf(address(this)), marketingWallet);
1437     }
1438 
1439     function setSwapAmount(uint256 amount) external onlyOwner {
1440         require(
1441             amount >= (10**decimals()) && amount <= totalSupply(),
1442             "not valid amount"
1443         );
1444         swapTokensAtAmount = amount;
1445     }
1446 
1447     function setSellTax(
1448     uint256 _wholeNumber,
1449     uint256 _firstNumberAfterDecimal,
1450     uint256 _secondNumberAfterDecimal
1451 ) public onlyOwner {
1452     require(
1453         _wholeNumber < 100 &&
1454             _firstNumberAfterDecimal <= 9 &&
1455             _secondNumberAfterDecimal <= 9
1456     );
1457     centiSellTax =
1458         _wholeNumber *
1459         100 +
1460         _firstNumberAfterDecimal *
1461         10 +
1462         _secondNumberAfterDecimal;
1463 }
1464 
1465 
1466     function setBuyTax(
1467     uint256 _wholeNumber,
1468     uint256 _firstNumberAfterDecimal,
1469     uint256 _secondNumberAfterDecimal
1470 ) public onlyOwner {
1471     require(
1472         _wholeNumber < 100 &&
1473             _firstNumberAfterDecimal <= 9 &&
1474             _secondNumberAfterDecimal <= 9
1475     );
1476     centiBuyTax =
1477         _wholeNumber *
1478         100 +
1479         _firstNumberAfterDecimal *
1480         10 +
1481         _secondNumberAfterDecimal;
1482 }
1483 
1484 
1485     function setMaxTx(
1486     uint256 _wholeNumber,
1487     uint256 _firstNumberAfterDecimal,
1488     uint256 _secondNumberAfterDecimal
1489 ) external onlyOwner {
1490     require(
1491         _wholeNumber < 100 &&
1492             _firstNumberAfterDecimal <= 9 &&
1493             _secondNumberAfterDecimal <= 9
1494     );
1495     maxTxAmount =
1496         (_wholeNumber *
1497             100 +
1498             _firstNumberAfterDecimal *
1499             10 +
1500             _secondNumberAfterDecimal) *
1501         totalSupply().div(10000);
1502 }
1503 
1504 
1505     function setMaxWallet(
1506     uint256 _wholeNumber,
1507     uint256 _firstNumberAfterDecimal,
1508     uint256 _secondNumberAfterDecimal
1509 ) external onlyOwner {
1510     require(
1511         _wholeNumber < 100 &&
1512             _firstNumberAfterDecimal <= 9 &&
1513             _secondNumberAfterDecimal <= 9
1514     );
1515     maxWalletAmount =
1516         (_wholeNumber *
1517             100 +
1518             _firstNumberAfterDecimal *
1519             10 +
1520             _secondNumberAfterDecimal) *
1521         totalSupply().div(10000);
1522 }
1523 
1524 }
