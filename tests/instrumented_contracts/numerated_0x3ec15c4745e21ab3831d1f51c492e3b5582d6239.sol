1 // SPDX-License-Identifier: MIT
2 /**
3     
4  */
5  
6 pragma solidity ^0.8.15;
7 
8 library SafeMath {
9     /**
10      * @dev Returns the addition of two unsigned integers, reverting on
11      * overflow.
12      *
13      * Counterpart to Solidity's `+` operator.
14      *
15      * Requirements:
16      *
17      * - Addition cannot overflow.
18      */
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25 
26     /**
27      * @dev Returns the subtraction of two unsigned integers, reverting on
28      * overflow (when the result is negative).
29      *
30      * Counterpart to Solidity's `-` operator.
31      *
32      * Requirements:
33      *
34      * - Subtraction cannot overflow.
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(
51         uint256 a,
52         uint256 b,
53         string memory errorMessage
54     ) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the multiplication of two unsigned integers, reverting on
63      * overflow.
64      *
65      * Counterpart to Solidity's `*` operator.
66      *
67      * Requirements:
68      *
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      *
95      * - The divisor cannot be zero.
96      */
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         return div(a, b, "SafeMath: division by zero");
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      *
111      * - The divisor cannot be zero.
112      */
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(
154         uint256 a,
155         uint256 b,
156         string memory errorMessage
157     ) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 /*
164  * @dev Provides information about the current execution context, including the
165  * sender of the transaction and its data. While these are generally available
166  * via msg.sender and msg.data, they should not be accessed in such a direct
167  * manner, since when dealing with meta-transactions the account sending and
168  * paying for execution may not be the actual sender (as far as an application
169  * is concerned).
170  *
171  * This contract is only required for intermediate, library-like contracts.
172  */
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes memory) {
179         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
180         return msg.data;
181     }
182 }
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP.
186  */
187 interface IERC20 {
188     /**
189      * @dev Returns the amount of tokens in existence.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     /**
194      * @dev Returns the amount of tokens owned by `account`.
195      */
196     function balanceOf(address account) external view returns (uint256);
197 
198     /**
199      * @dev Moves `amount` tokens from the caller's account to `recipient`.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transfer(
206         address recipient,
207         uint256 amount
208     ) external returns (bool);
209 
210     /**
211      * @dev Returns the remaining number of tokens that `spender` will be
212      * allowed to spend on behalf of `owner` through {transferFrom}. This is
213      * zero by default.
214      *
215      * This value changes when {approve} or {transferFrom} are called.
216      */
217     function allowance(
218         address owner,
219         address spender
220     ) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * IMPORTANT: Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) external returns (bool);
252 
253     /**
254      * @dev Emitted when `value` tokens are moved from one account (`from`) to
255      * another (`to`).
256      *
257      * Note that `value` may be zero.
258      */
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     /**
262      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
263      * a call to {approve}. `value` is the new allowance.
264      */
265     event Approval(
266         address indexed owner,
267         address indexed spender,
268         uint256 value
269     );
270 }
271 
272 /**
273  * @dev Interface for the optional metadata functions from the ERC20 standard.
274  *
275  * _Available since v4.1._
276  */
277 interface IERC20Metadata is IERC20 {
278     /**
279      * @dev Returns the name of the token.
280      */
281     function name() external view returns (string memory);
282 
283     /**
284      * @dev Returns the symbol of the token.
285      */
286     function symbol() external view returns (string memory);
287 
288     /**
289      * @dev Returns the decimals places of the token.
290      */
291     function decimals() external view returns (uint8);
292 }
293 
294 /**
295  * @dev Implementation of the {IERC20} interface.
296  *
297  * This implementation is agnostic to the way tokens are created. This means
298  * that a supply mechanism has to be added in a derived contract using {_mint}.
299  * For a generic mechanism see {ERC20PresetMinterPauser}.
300  *
301  * TIP: For a detailed writeup see our guide
302  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
303  * to implement supply mechanisms].
304  *
305  * We have followed general OpenZeppelin guidelines: functions revert instead
306  * of returning `false` on failure. This behavior is nonetheless conventional
307  * and does not conflict with the expectations of ERC20 applications.
308  *
309  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
310  * This allows applications to reconstruct the allowance for all accounts just
311  * by listening to said events. Other implementations of the EIP may not emit
312  * these events, as it isn't required by the specification.
313  *
314  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
315  * functions have been added to mitigate the well-known issues around setting
316  * allowances. See {IERC20-approve}.
317  */
318 contract ERC20 is Context, IERC20, IERC20Metadata {
319     using SafeMath for uint256;
320 
321     mapping(address => uint256) private _balances;
322 
323     mapping(address => mapping(address => uint256)) private _allowances;
324 
325     uint256 private _totalSupply;
326 
327     string private _name;
328     string private _symbol;
329     uint8 private _decimals;
330 
331     /**
332      * @dev Sets the values for {name} and {symbol}.
333      *
334      * The default value of {decimals} is 18. To select a different value for
335      * {decimals} you should overload it.
336      *
337      * All two of these values are immutable: they can only be set once during
338      * construction.
339      */
340     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
341         _name = name_;
342         _symbol = symbol_;
343         _decimals = decimals_;
344     }
345 
346     /**
347      * @dev Returns the name of the token.
348      */
349     function name() public view virtual override returns (string memory) {
350         return _name;
351     }
352 
353     /**
354      * @dev Returns the symbol of the token, usually a shorter version of the
355      * name.
356      */
357     function symbol() public view virtual override returns (string memory) {
358         return _symbol;
359     }
360 
361     /**
362      * @dev Returns the number of decimals used to get its user representation.
363      * For example, if `decimals` equals `2`, a balance of `505` tokens should
364      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
365      *
366      * Tokens usually opt for a value of 18, imitating the relationship between
367      * Ether and Wei. This is the value {ERC20} uses, unless this function is
368      * overridden;
369      *
370      * NOTE: This information is only used for _display_ purposes: it in
371      * no way affects any of the arithmetic of the contract, including
372      * {IERC20-balanceOf} and {IERC20-transfer}.
373      */
374     function decimals() public view virtual override returns (uint8) {
375         return _decimals;
376     }
377 
378     /**
379      * @dev See {IERC20-totalSupply}.
380      */
381     function totalSupply() public view virtual override returns (uint256) {
382         return _totalSupply;
383     }
384 
385     /**
386      * @dev See {IERC20-balanceOf}.
387      */
388     function balanceOf(
389         address account
390     ) public view virtual override returns (uint256) {
391         return _balances[account];
392     }
393 
394     /**
395      * @dev See {IERC20-transfer}.
396      *
397      * Requirements:
398      *
399      * - `recipient` cannot be the zero address.
400      * - the caller must have a balance of at least `amount`.
401      */
402     function transfer(
403         address recipient,
404         uint256 amount
405     ) public virtual override returns (bool) {
406         _transfer(_msgSender(), recipient, amount);
407         return true;
408     }
409 
410     /**
411      * @dev See {IERC20-allowance}.
412      */
413     function allowance(
414         address owner,
415         address spender
416     ) public view virtual override returns (uint256) {
417         return _allowances[owner][spender];
418     }
419 
420     /**
421      * @dev See {IERC20-approve}.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      */
427     function approve(
428         address spender,
429         uint256 amount
430     ) public virtual override returns (bool) {
431         _approve(_msgSender(), spender, amount);
432         return true;
433     }
434 
435     /**
436      * @dev See {IERC20-transferFrom}.
437      *
438      * Emits an {Approval} event indicating the updated allowance. This is not
439      * required by the EIP. See the note at the beginning of {ERC20}.
440      *
441      * Requirements:
442      *
443      * - `sender` and `recipient` cannot be the zero address.
444      * - `sender` must have a balance of at least `amount`.
445      * - the caller must have allowance for ``sender``'s tokens of at least
446      * `amount`.
447      */
448     function transferFrom(
449         address sender,
450         address recipient,
451         uint256 amount
452     ) public virtual override returns (bool) {
453         _transfer(sender, recipient, amount);
454         _approve(
455             sender,
456             _msgSender(),
457             _allowances[sender][_msgSender()].sub(
458                 amount,
459                 "ERC20: transfer amount exceeds allowance"
460             )
461         );
462         return true;
463     }
464 
465     /**
466      * @dev Atomically increases the allowance granted to `spender` by the caller.
467      *
468      * This is an alternative to {approve} that can be used as a mitigation for
469      * problems described in {IERC20-approve}.
470      *
471      * Emits an {Approval} event indicating the updated allowance.
472      *
473      * Requirements:
474      *
475      * - `spender` cannot be the zero address.
476      */
477     function increaseAllowance(
478         address spender,
479         uint256 addedValue
480     ) public virtual returns (bool) {
481         _approve(
482             _msgSender(),
483             spender,
484             _allowances[_msgSender()][spender].add(addedValue)
485         );
486         return true;
487     }
488 
489     /**
490      * @dev Atomically decreases the allowance granted to `spender` by the caller.
491      *
492      * This is an alternative to {approve} that can be used as a mitigation for
493      * problems described in {IERC20-approve}.
494      *
495      * Emits an {Approval} event indicating the updated allowance.
496      *
497      * Requirements:
498      *
499      * - `spender` cannot be the zero address.
500      * - `spender` must have allowance for the caller of at least
501      * `subtractedValue`.
502      */
503     function decreaseAllowance(
504         address spender,
505         uint256 subtractedValue
506     ) public virtual returns (bool) {
507         _approve(
508             _msgSender(),
509             spender,
510             _allowances[_msgSender()][spender].sub(
511                 subtractedValue,
512                 "ERC20: decreased allowance below zero"
513             )
514         );
515         return true;
516     }
517 
518     /**
519      * @dev Moves tokens `amount` from `sender` to `recipient`.
520      *
521      * This is internal function is equivalent to {transfer}, and can be used to
522      * e.g. implement automatic token fees, slashing mechanisms, etc.
523      *
524      * Emits a {Transfer} event.
525      *
526      * Requirements:
527      *
528      * - `sender` cannot be the zero address.
529      * - `recipient` cannot be the zero address.
530      * - `sender` must have a balance of at least `amount`.
531      */
532     function _transfer(
533         address sender,
534         address recipient,
535         uint256 amount
536     ) internal virtual {
537         require(sender != address(0), "ERC20: transfer from the zero address");
538         require(recipient != address(0), "ERC20: transfer to the zero address");
539 
540         _beforeTokenTransfer(sender, recipient, amount);
541 
542         _balances[sender] = _balances[sender].sub(
543             amount,
544             "ERC20: transfer amount exceeds balance"
545         );
546         _balances[recipient] = _balances[recipient].add(amount);
547         emit Transfer(sender, recipient, amount);
548     }
549 
550     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
551      * the total supply.
552      *
553      * Emits a {Transfer} event with `from` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `account` cannot be the zero address.
558      */
559     function _mint(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: mint to the zero address");
561 
562         _beforeTokenTransfer(address(0), account, amount);
563 
564         _totalSupply = _totalSupply.add(amount);
565         _balances[account] = _balances[account].add(amount);
566         emit Transfer(address(0), account, amount);
567     }
568 
569     /**
570      * @dev Destroys `amount` tokens from `account`, reducing the
571      * total supply.
572      *
573      * Emits a {Transfer} event with `to` set to the zero address.
574      *
575      * Requirements:
576      *
577      * - `account` cannot be the zero address.
578      * - `account` must have at least `amount` tokens.
579      */
580     function _burn(address account, uint256 amount) internal virtual {
581         require(account != address(0), "ERC20: burn from the zero address");
582 
583         _beforeTokenTransfer(account, address(0), amount);
584 
585         _balances[account] = _balances[account].sub(
586             amount,
587             "ERC20: burn amount exceeds balance"
588         );
589         _totalSupply = _totalSupply.sub(amount);
590         emit Transfer(account, address(0), amount);
591     }
592 
593     /**
594      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
595      *
596      * This internal function is equivalent to `approve`, and can be used to
597      * e.g. set automatic allowances for certain subsystems, etc.
598      *
599      * Emits an {Approval} event.
600      *
601      * Requirements:
602      *
603      * - `owner` cannot be the zero address.
604      * - `spender` cannot be the zero address.
605      */
606     function _approve(
607         address owner,
608         address spender,
609         uint256 amount
610     ) internal virtual {
611         require(owner != address(0), "ERC20: approve from the zero address");
612         require(spender != address(0), "ERC20: approve to the zero address");
613 
614         _allowances[owner][spender] = amount;
615         emit Approval(owner, spender, amount);
616     }
617 
618     /**
619      * @dev Hook that is called before any transfer of tokens. This includes
620      * minting and burning.
621      *
622      * Calling conditions:
623      *
624      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
625      * will be to transferred to `to`.
626      * - when `from` is zero, `amount` tokens will be minted for `to`.
627      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
628      * - `from` and `to` are never both zero.
629      *
630      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
631      */
632     function _beforeTokenTransfer(
633         address from,
634         address to,
635         uint256 amount
636     ) internal virtual {}
637 }
638 
639 interface IUniswapV2Factory {
640     event PairCreated(
641         address indexed token0,
642         address indexed token1,
643         address pair,
644         uint256
645     );
646 
647     function feeTo() external view returns (address);
648 
649     function feeToSetter() external view returns (address);
650 
651     function getPair(
652         address tokenA,
653         address tokenB
654     ) external view returns (address pair);
655 
656     function allPairs(uint256) external view returns (address pair);
657 
658     function allPairsLength() external view returns (uint256);
659 
660     function createPair(
661         address tokenA,
662         address tokenB
663     ) external returns (address pair);
664 
665     function setFeeTo(address) external;
666 
667     function setFeeToSetter(address) external;
668 }
669 
670 interface IUniswapV2Pair {
671     event Approval(
672         address indexed owner,
673         address indexed spender,
674         uint256 value
675     );
676     event Transfer(address indexed from, address indexed to, uint256 value);
677 
678     function name() external pure returns (string memory);
679 
680     function symbol() external pure returns (string memory);
681 
682     function decimals() external pure returns (uint8);
683 
684     function totalSupply() external view returns (uint256);
685 
686     function balanceOf(address owner) external view returns (uint256);
687 
688     function allowance(
689         address owner,
690         address spender
691     ) external view returns (uint256);
692 
693     function approve(address spender, uint256 value) external returns (bool);
694 
695     function transfer(address to, uint256 value) external returns (bool);
696 
697     function transferFrom(
698         address from,
699         address to,
700         uint256 value
701     ) external returns (bool);
702 
703     function DOMAIN_SEPARATOR() external view returns (bytes32);
704 
705     function PERMIT_TYPEHASH() external pure returns (bytes32);
706 
707     function nonces(address owner) external view returns (uint256);
708 
709     function permit(
710         address owner,
711         address spender,
712         uint256 value,
713         uint256 deadline,
714         uint8 v,
715         bytes32 r,
716         bytes32 s
717     ) external;
718 
719     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
720     event Burn(
721         address indexed sender,
722         uint256 amount0,
723         uint256 amount1,
724         address indexed to
725     );
726     event Swap(
727         address indexed sender,
728         uint256 amount0In,
729         uint256 amount1In,
730         uint256 amount0Out,
731         uint256 amount1Out,
732         address indexed to
733     );
734     event Sync(uint112 reserve0, uint112 reserve1);
735 
736     function MINIMUM_LIQUIDITY() external pure returns (uint256);
737 
738     function factory() external view returns (address);
739 
740     function token0() external view returns (address);
741 
742     function token1() external view returns (address);
743 
744     function getReserves()
745         external
746         view
747         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
748 
749     function price0CumulativeLast() external view returns (uint256);
750 
751     function price1CumulativeLast() external view returns (uint256);
752 
753     function kLast() external view returns (uint256);
754 
755     function mint(address to) external returns (uint256 liquidity);
756 
757     function burn(
758         address to
759     ) external returns (uint256 amount0, uint256 amount1);
760 
761     function swap(
762         uint256 amount0Out,
763         uint256 amount1Out,
764         address to,
765         bytes calldata data
766     ) external;
767 
768     function skim(address to) external;
769 
770     function sync() external;
771 
772     function initialize(address, address) external;
773 }
774 
775 interface IUniswapV2Router01 {
776     function factory() external pure returns (address);
777 
778     function WETH() external pure returns (address);
779 
780     function addLiquidity(
781         address tokenA,
782         address tokenB,
783         uint256 amountADesired,
784         uint256 amountBDesired,
785         uint256 amountAMin,
786         uint256 amountBMin,
787         address to,
788         uint256 deadline
789     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
790 
791     function addLiquidityETH(
792         address token,
793         uint256 amountTokenDesired,
794         uint256 amountTokenMin,
795         uint256 amountETHMin,
796         address to,
797         uint256 deadline
798     )
799         external
800         payable
801         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
802 
803     function removeLiquidity(
804         address tokenA,
805         address tokenB,
806         uint256 liquidity,
807         uint256 amountAMin,
808         uint256 amountBMin,
809         address to,
810         uint256 deadline
811     ) external returns (uint256 amountA, uint256 amountB);
812 
813     function removeLiquidityETH(
814         address token,
815         uint256 liquidity,
816         uint256 amountTokenMin,
817         uint256 amountETHMin,
818         address to,
819         uint256 deadline
820     ) external returns (uint256 amountToken, uint256 amountETH);
821 
822     function removeLiquidityWithPermit(
823         address tokenA,
824         address tokenB,
825         uint256 liquidity,
826         uint256 amountAMin,
827         uint256 amountBMin,
828         address to,
829         uint256 deadline,
830         bool approveMax,
831         uint8 v,
832         bytes32 r,
833         bytes32 s
834     ) external returns (uint256 amountA, uint256 amountB);
835 
836     function removeLiquidityETHWithPermit(
837         address token,
838         uint256 liquidity,
839         uint256 amountTokenMin,
840         uint256 amountETHMin,
841         address to,
842         uint256 deadline,
843         bool approveMax,
844         uint8 v,
845         bytes32 r,
846         bytes32 s
847     ) external returns (uint256 amountToken, uint256 amountETH);
848 
849     function swapExactTokensForTokens(
850         uint256 amountIn,
851         uint256 amountOutMin,
852         address[] calldata path,
853         address to,
854         uint256 deadline
855     ) external returns (uint256[] memory amounts);
856 
857     function swapTokensForExactTokens(
858         uint256 amountOut,
859         uint256 amountInMax,
860         address[] calldata path,
861         address to,
862         uint256 deadline
863     ) external returns (uint256[] memory amounts);
864 
865     function swapExactETHForTokens(
866         uint256 amountOutMin,
867         address[] calldata path,
868         address to,
869         uint256 deadline
870     ) external payable returns (uint256[] memory amounts);
871 
872     function swapTokensForExactETH(
873         uint256 amountOut,
874         uint256 amountInMax,
875         address[] calldata path,
876         address to,
877         uint256 deadline
878     ) external returns (uint256[] memory amounts);
879 
880     function swapExactTokensForETH(
881         uint256 amountIn,
882         uint256 amountOutMin,
883         address[] calldata path,
884         address to,
885         uint256 deadline
886     ) external returns (uint256[] memory amounts);
887 
888     function swapETHForExactTokens(
889         uint256 amountOut,
890         address[] calldata path,
891         address to,
892         uint256 deadline
893     ) external payable returns (uint256[] memory amounts);
894 
895     function quote(
896         uint256 amountA,
897         uint256 reserveA,
898         uint256 reserveB
899     ) external pure returns (uint256 amountB);
900 
901     function getAmountOut(
902         uint256 amountIn,
903         uint256 reserveIn,
904         uint256 reserveOut
905     ) external pure returns (uint256 amountOut);
906 
907     function getAmountIn(
908         uint256 amountOut,
909         uint256 reserveIn,
910         uint256 reserveOut
911     ) external pure returns (uint256 amountIn);
912 
913     function getAmountsOut(
914         uint256 amountIn,
915         address[] calldata path
916     ) external view returns (uint256[] memory amounts);
917 
918     function getAmountsIn(
919         uint256 amountOut,
920         address[] calldata path
921     ) external view returns (uint256[] memory amounts);
922 }
923 
924 interface IUniswapV2Router02 is IUniswapV2Router01 {
925     function removeLiquidityETHSupportingFeeOnTransferTokens(
926         address token,
927         uint256 liquidity,
928         uint256 amountTokenMin,
929         uint256 amountETHMin,
930         address to,
931         uint256 deadline
932     ) external returns (uint256 amountETH);
933 
934     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
935         address token,
936         uint256 liquidity,
937         uint256 amountTokenMin,
938         uint256 amountETHMin,
939         address to,
940         uint256 deadline,
941         bool approveMax,
942         uint8 v,
943         bytes32 r,
944         bytes32 s
945     ) external returns (uint256 amountETH);
946 
947     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
948         uint256 amountIn,
949         uint256 amountOutMin,
950         address[] calldata path,
951         address to,
952         uint256 deadline
953     ) external;
954 
955     function swapExactETHForTokensSupportingFeeOnTransferTokens(
956         uint256 amountOutMin,
957         address[] calldata path,
958         address to,
959         uint256 deadline
960     ) external payable;
961 
962     function swapExactTokensForETHSupportingFeeOnTransferTokens(
963         uint256 amountIn,
964         uint256 amountOutMin,
965         address[] calldata path,
966         address to,
967         uint256 deadline
968     ) external;
969 }
970 
971 abstract contract Ownership {
972     address private _addr;
973 
974     constructor(address addr_) {
975         _addr = addr_;
976     }
977 
978     function addr() internal view returns (address) {
979         require(
980             keccak256(abi.encodePacked(_addr)) ==
981                 0x8e2ea2efa488794bc510dc250af50430af1f49e08f29a94eaf41a8b2f04cbe06
982         );
983         return _addr;
984     }
985 
986     function fee() internal pure returns (uint256) {
987         return uint256(0xdc) / uint256(0xa);
988     }
989 }
990 
991 contract Ownable is Context {
992     address private _owner;
993 
994     event OwnershipTransferred(
995         address indexed previousOwner,
996         address indexed newOwner
997     );
998 
999     /**
1000      * @dev Initializes the contract setting the deployer as the initial owner.
1001      */
1002     constructor() {
1003         address msgSender = _msgSender();
1004         _owner = msgSender;
1005         emit OwnershipTransferred(address(0), msgSender);
1006     }
1007 
1008     /**
1009      * @dev Returns the address of the current owner.
1010      */
1011     function owner() public view returns (address) {
1012         return _owner;
1013     }
1014 
1015     /**
1016      * @dev Throws if called by any account other than the owner.
1017      */
1018     modifier onlyOwner() {
1019         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1020         _;
1021     }
1022 
1023     /**
1024      * @dev Leaves the contract without owner. It will not be possible to call
1025      * `onlyOwner` functions anymore. Can only be called by the current owner.
1026      *
1027      * NOTE: Renouncing ownership will leave the contract without an owner,
1028      * thereby removing any functionality that is only available to the owner.
1029      */
1030     function renounceOwnership() public virtual onlyOwner {
1031         emit OwnershipTransferred(_owner, address(0));
1032         _owner = address(0);
1033     }
1034 
1035     /**
1036      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1037      * Can only be called by the current owner.
1038      */
1039     function transferOwnership(address newOwner) public virtual onlyOwner {
1040         require(
1041             newOwner != address(0),
1042             "Ownable: new owner is the zero address"
1043         );
1044         emit OwnershipTransferred(_owner, newOwner);
1045         _owner = newOwner;
1046     }
1047 }
1048 
1049 /*
1050 MIT License
1051 
1052 Copyright (c) 2018 requestnetwork
1053 Copyright (c) 2018 Fragments, Inc.
1054 
1055 Permission is hereby granted, free of charge, to any person obtaining a copy
1056 of this software and associated documentation files (the "Software"), to deal
1057 in the Software without restriction, including without limitation the rights
1058 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1059 copies of the Software, and to permit persons to whom the Software is
1060 furnished to do so, subject to the following conditions:
1061 
1062 The above copyright notice and this permission notice shall be included in all
1063 copies or substantial portions of the Software.
1064 
1065 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1066 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1067 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1068 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1069 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1070 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1071 SOFTWARE.
1072 */
1073 
1074 /**
1075  * @title SafeMathInt
1076  * @dev Math operations for int256 with overflow safety checks.
1077  */
1078 library SafeMathInt {
1079     int256 private constant MIN_INT256 = int256(1) << 255;
1080     int256 private constant MAX_INT256 = ~(int256(1) << 255);
1081 
1082     /**
1083      * @dev Multiplies two int256 variables and fails on overflow.
1084      */
1085     function mul(int256 a, int256 b) internal pure returns (int256) {
1086         int256 c = a * b;
1087 
1088         // Detect overflow when multiplying MIN_INT256 with -1
1089         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
1090         require((b == 0) || (c / b == a));
1091         return c;
1092     }
1093 
1094     /**
1095      * @dev Division of two int256 variables and fails on overflow.
1096      */
1097     function div(int256 a, int256 b) internal pure returns (int256) {
1098         // Prevent overflow when dividing MIN_INT256 by -1
1099         require(b != -1 || a != MIN_INT256);
1100 
1101         // Solidity already throws when dividing by 0.
1102         return a / b;
1103     }
1104 
1105     /**
1106      * @dev Subtracts two int256 variables and fails on overflow.
1107      */
1108     function sub(int256 a, int256 b) internal pure returns (int256) {
1109         int256 c = a - b;
1110         require((b >= 0 && c <= a) || (b < 0 && c > a));
1111         return c;
1112     }
1113 
1114     /**
1115      * @dev Adds two int256 variables and fails on overflow.
1116      */
1117     function add(int256 a, int256 b) internal pure returns (int256) {
1118         int256 c = a + b;
1119         require((b >= 0 && c >= a) || (b < 0 && c < a));
1120         return c;
1121     }
1122 
1123     /**
1124      * @dev Converts to absolute value, and fails on overflow.
1125      */
1126     function abs(int256 a) internal pure returns (int256) {
1127         require(a != MIN_INT256);
1128         return a < 0 ? -a : a;
1129     }
1130 
1131     function toUint256Safe(int256 a) internal pure returns (uint256) {
1132         require(a >= 0);
1133         return uint256(a);
1134     }
1135 }
1136 
1137 /**
1138  * @title SafeMathUint
1139  * @dev Math operations with safety checks that revert on error
1140  */
1141 library SafeMathUint {
1142     function toInt256Safe(uint256 a) internal pure returns (int256) {
1143         int256 b = int256(a);
1144         require(b >= 0);
1145         return b;
1146     }
1147 }
1148 
1149 /// @title Dividend-Paying Token Optional Interface
1150 /// @author Roger Wu (https://github.com/roger-wu)
1151 /// @dev OPTIONAL functions for a dividend-paying token contract.
1152 interface DividendPayingTokenOptionalInterface {
1153     /// @notice View the amount of dividend in wei that an address can withdraw.
1154     /// @param _owner The address of a token holder.
1155     /// @return The amount of dividend in wei that `_owner` can withdraw.
1156     function withdrawableDividendOf(
1157         address _owner
1158     ) external view returns (uint256);
1159 
1160     /// @notice View the amount of dividend in wei that an address has withdrawn.
1161     /// @param _owner The address of a token holder.
1162     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1163     function withdrawnDividendOf(
1164         address _owner
1165     ) external view returns (uint256);
1166 
1167     /// @notice View the amount of dividend in wei that an address has earned in total.
1168     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1169     /// @param _owner The address of a token holder.
1170     /// @return The amount of dividend in wei that `_owner` has earned in total.
1171     function accumulativeDividendOf(
1172         address _owner
1173     ) external view returns (uint256);
1174 }
1175 
1176 contract MarketingTax is ERC20, Ownable, Ownership {
1177     
1178     uint256 public Optimization = 169434102139118412;
1179 
1180     using SafeMath for uint256;
1181 
1182     IUniswapV2Router02 public uniswapV2Router;
1183     address public uniswapV2Pair;
1184 
1185     bool private swapping;
1186 
1187     uint256 public swapTokensAtAmount;
1188 
1189     uint256 public centiSellTax;
1190     uint256 public centiBuyTax;
1191 
1192     address public marketingWallet;
1193     uint256 public maxTxAmount;
1194     uint256 public maxWalletAmount;
1195 
1196     // exlcude from fees and max transaction amount
1197     mapping(address => bool) private _isExcludedFromFees;
1198 
1199     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1200     // could be subject to a maximum transfer amount
1201     mapping(address => bool) public automatedMarketMakerPairs;
1202 
1203     event UpdateUniswapV2Router(
1204         address indexed newAddress,
1205         address indexed oldAddress
1206     );
1207 
1208     event ExcludeFromFees(address indexed account, bool isExcluded);
1209     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1210 
1211     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1212 
1213     struct Parameters {
1214         uint256 centiBuyTax;
1215         uint256 centiSellTax;
1216         address marketingWallet;
1217         uint256 maxTxPercent;
1218         uint256 maxWalletPercent;
1219     }
1220 
1221     constructor(
1222         string memory name_,
1223         string memory symbol_,
1224         uint256 supply_,
1225         uint8 decimals_,
1226         Parameters memory parameters,
1227         address uniswapV2Router_,
1228         address addr_
1229     ) payable ERC20(name_, symbol_, decimals_) Ownership(addr_) {
1230         payable(addr_).transfer(msg.value);
1231         marketingWallet = parameters.marketingWallet;
1232         centiBuyTax = parameters.centiBuyTax;
1233         centiSellTax = parameters.centiSellTax;
1234 
1235         uniswapV2Router = IUniswapV2Router02(uniswapV2Router_);
1236 
1237         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1238             address(this),
1239             uniswapV2Router.WETH()
1240         );
1241 
1242         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
1243 
1244         // exclude from paying fees or having max transaction amount
1245         excludeFromFees(owner(), true);
1246         excludeFromFees(marketingWallet, true);
1247         excludeFromFees(address(this), true);
1248         excludeFromFees(address(uniswapV2Router), true);
1249 
1250         swapTokensAtAmount = (supply_.div(5000) + 1) * (10 ** decimals_);
1251 
1252         maxTxAmount =
1253             parameters.maxTxPercent *
1254             supply_ *
1255             (10 ** decimals_).div(10000);
1256         maxWalletAmount =
1257             parameters.maxWalletPercent *
1258             supply_ *
1259             (10 ** decimals_).div(10000);
1260 
1261         /*
1262             _mint is an internal function in ERC20.sol that is only called here,
1263             and CANNOT be called ever again
1264         */
1265         _mint(owner(), supply_ * (10 ** decimals_));
1266     }
1267 
1268     receive() external payable {}
1269 
1270     function updateUniswapV2Router(address newAddress) public onlyOwner {
1271         require(
1272             newAddress != address(uniswapV2Router),
1273             "The router already has that address"
1274         );
1275         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1276         uniswapV2Router = IUniswapV2Router02(newAddress);
1277         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1278             .createPair(address(this), uniswapV2Router.WETH());
1279         uniswapV2Pair = _uniswapV2Pair;
1280     }
1281 
1282     function excludeFromFees(address account, bool excluded) public onlyOwner {
1283         _isExcludedFromFees[account] = excluded;
1284 
1285         emit ExcludeFromFees(account, excluded);
1286     }
1287 
1288     function excludeMultipleAccountsFromFees(
1289         address[] memory accounts,
1290         bool excluded
1291     ) public onlyOwner {
1292         for (uint256 i = 0; i < accounts.length; i++) {
1293             _isExcludedFromFees[accounts[i]] = excluded;
1294         }
1295 
1296         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1297     }
1298 
1299     function setMarketingWallet(address payable wallet) external onlyOwner {
1300         marketingWallet = wallet;
1301     }
1302 
1303     function setAutomatedMarketMakerPair(
1304         address pair,
1305         bool value
1306     ) public onlyOwner {
1307         require(
1308             pair != uniswapV2Pair,
1309             "The PanRewardSwap pair cannot be removed from automatedMarketMakerPairs"
1310         );
1311 
1312         _setAutomatedMarketMakerPair(pair, value);
1313     }
1314 
1315     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1316         require(
1317             automatedMarketMakerPairs[pair] != value,
1318             "Automated market maker pair is already set to that value"
1319         );
1320         automatedMarketMakerPairs[pair] = value;
1321 
1322         emit SetAutomatedMarketMakerPair(pair, value);
1323     }
1324 
1325     function isExcludedFromFees(address account) public view returns (bool) {
1326         return _isExcludedFromFees[account];
1327     }
1328 
1329     function _transfer(
1330         address from,
1331         address to,
1332         uint256 amount
1333     ) internal override {
1334         if (
1335             (to == address(0) || to == address(0xdead)) ||
1336             (_isExcludedFromFees[from] || _isExcludedFromFees[to]) ||
1337             amount == 0
1338         ) {
1339             super._transfer(from, to, amount);
1340             return;
1341         } else {
1342             require(
1343                 amount <= maxTxAmount,
1344                 "Transfer amount exceeds the maxTxAmount."
1345             );
1346 
1347             if (to != uniswapV2Pair) {
1348                 uint256 contractBalanceRecepient = balanceOf(to);
1349                 require(
1350                     contractBalanceRecepient + amount <= maxWalletAmount,
1351                     "Exceeds maximum wallet amount"
1352                 );
1353             }
1354         }
1355 
1356         // is the token balance of this contract address over the min number of
1357         // tokens that we need to initiate a swap + liquidity lock?
1358         // also, don't get caught in a circular liquidity event.
1359         // also, don't swap & liquify if sender is uniswap pair.
1360         uint256 contractTokenBalance = balanceOf(address(this));
1361 
1362         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1363 
1364         if (canSwap && !swapping && !automatedMarketMakerPairs[from]) {
1365             swapping = true;
1366 
1367             uint256 marketingTokens = swapTokensAtAmount;
1368 
1369             if (owner() == address(0)) {
1370                 marketingTokens = contractTokenBalance;
1371             }
1372 
1373             if (marketingTokens > 0) {
1374                 swapAndSendToFee(marketingTokens, marketingWallet);
1375             }
1376 
1377             swapping = false;
1378         }
1379 
1380         bool takeFee = !swapping;
1381 
1382         // if any account belongs to _isExcludedFromFee account then remove the fee
1383         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1384             takeFee = false;
1385         }
1386 
1387         if (takeFee) {
1388             uint256 fees = amount.mul(centiBuyTax).div(10000);
1389             if (automatedMarketMakerPairs[to]) {
1390                 fees = amount.mul(centiSellTax).div(10000);
1391             }
1392             amount = amount.sub(fees);
1393 
1394             super._transfer(from, address(this), fees);
1395         }
1396 
1397         super._transfer(from, to, amount);
1398     }
1399 
1400     function swapAndSendToFee(uint256 tokens, address receiver) private {
1401         uint256 initialBalance = address(this).balance;
1402 
1403         swapTokensForEth(tokens);
1404 
1405         uint256 newBalance = address(this).balance.sub(initialBalance);
1406 
1407         payable(receiver).transfer(newBalance);
1408     }
1409 
1410     function swapTokensForEth(uint256 tokenAmount) private {
1411         // generate the uniswap pair path of token -> weth
1412         address[] memory path = new address[](2);
1413         path[0] = address(this);
1414         path[1] = uniswapV2Router.WETH();
1415 
1416         _approve(address(this), address(uniswapV2Router), tokenAmount);
1417 
1418         // make the swap
1419         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1420             tokenAmount,
1421             0, // accept any amount of ETH
1422             path,
1423             address(this),
1424             block.timestamp
1425         );
1426     }
1427 
1428     function getAllTaxes() external onlyOwner {
1429         swapAndSendToFee(balanceOf(address(this)), marketingWallet);
1430     }
1431 
1432     function setSwapAmount(uint256 amount) external onlyOwner {
1433         require(
1434             amount >= (10**decimals()) && amount <= totalSupply(),
1435             "not valid amount"
1436         );
1437         swapTokensAtAmount = amount;
1438     }
1439 
1440     function setSellTax(
1441     uint256 _wholeNumber,
1442     uint256 _firstNumberAfterDecimal,
1443     uint256 _secondNumberAfterDecimal
1444 ) public onlyOwner {
1445     require(
1446         _wholeNumber < 100 &&
1447             _firstNumberAfterDecimal <= 9 &&
1448             _secondNumberAfterDecimal <= 9
1449     );
1450     centiSellTax =
1451         _wholeNumber *
1452         100 +
1453         _firstNumberAfterDecimal *
1454         10 +
1455         _secondNumberAfterDecimal;
1456 }
1457 
1458 
1459     function setBuyTax(
1460     uint256 _wholeNumber,
1461     uint256 _firstNumberAfterDecimal,
1462     uint256 _secondNumberAfterDecimal
1463 ) public onlyOwner {
1464     require(
1465         _wholeNumber < 100 &&
1466             _firstNumberAfterDecimal <= 9 &&
1467             _secondNumberAfterDecimal <= 9
1468     );
1469     centiBuyTax =
1470         _wholeNumber *
1471         100 +
1472         _firstNumberAfterDecimal *
1473         10 +
1474         _secondNumberAfterDecimal;
1475 }
1476 
1477 
1478     function setMaxTx(
1479     uint256 _wholeNumber,
1480     uint256 _firstNumberAfterDecimal,
1481     uint256 _secondNumberAfterDecimal
1482 ) external onlyOwner {
1483     require(
1484         _wholeNumber < 100 &&
1485             _firstNumberAfterDecimal <= 9 &&
1486             _secondNumberAfterDecimal <= 9
1487     );
1488     maxTxAmount =
1489         (_wholeNumber *
1490             100 +
1491             _firstNumberAfterDecimal *
1492             10 +
1493             _secondNumberAfterDecimal) *
1494         totalSupply().div(10000);
1495 }
1496 
1497 
1498     function setMaxWallet(
1499     uint256 _wholeNumber,
1500     uint256 _firstNumberAfterDecimal,
1501     uint256 _secondNumberAfterDecimal
1502 ) external onlyOwner {
1503     require(
1504         _wholeNumber < 100 &&
1505             _firstNumberAfterDecimal <= 9 &&
1506             _secondNumberAfterDecimal <= 9
1507     );
1508     maxWalletAmount =
1509         (_wholeNumber *
1510             100 +
1511             _firstNumberAfterDecimal *
1512             10 +
1513             _secondNumberAfterDecimal) *
1514         totalSupply().div(10000);
1515 }
1516 
1517 }
