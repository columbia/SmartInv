1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.15;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(
48         uint256 a,
49         uint256 b,
50         string memory errorMessage
51     ) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the multiplication of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `*` operator.
63      *
64      * Requirements:
65      *
66      * - Multiplication cannot overflow.
67      */
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
70         // benefit is lost if 'b' is also tested.
71         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b, "SafeMath: multiplication overflow");
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the integer division of two unsigned integers. Reverts on
84      * division by zero. The result is rounded towards zero.
85      *
86      * Counterpart to Solidity's `/` operator. Note: this function uses a
87      * `revert` opcode (which leaves remaining gas untouched) while Solidity
88      * uses an invalid opcode to revert (consuming all remaining gas).
89      *
90      * Requirements:
91      *
92      * - The divisor cannot be zero.
93      */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      *
108      * - The divisor cannot be zero.
109      */
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135         return mod(a, b, "SafeMath: modulo by zero");
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts with custom message when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes memory) {
176         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
177         return msg.data;
178     }
179 }
180 
181 /**
182  * @dev Interface of the ERC20 standard as defined in the EIP.
183  */
184 interface IERC20 {
185     /**
186      * @dev Returns the amount of tokens in existence.
187      */
188     function totalSupply() external view returns (uint256);
189 
190     /**
191      * @dev Returns the amount of tokens owned by `account`.
192      */
193     function balanceOf(address account) external view returns (uint256);
194 
195     /**
196      * @dev Moves `amount` tokens from the caller's account to `recipient`.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transfer(address recipient, uint256 amount)
203         external
204         returns (bool);
205 
206     /**
207      * @dev Returns the remaining number of tokens that `spender` will be
208      * allowed to spend on behalf of `owner` through {transferFrom}. This is
209      * zero by default.
210      *
211      * This value changes when {approve} or {transferFrom} are called.
212      */
213     function allowance(address owner, address spender)
214         external
215         view
216         returns (uint256);
217 
218     /**
219      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * IMPORTANT: Beware that changing an allowance with this method brings the risk
224      * that someone may use both the old and the new allowance by unfortunate
225      * transaction ordering. One possible solution to mitigate this race
226      * condition is to first reduce the spender's allowance to 0 and set the
227      * desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address spender, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Moves `amount` tokens from `sender` to `recipient` using the
236      * allowance mechanism. `amount` is then deducted from the caller's
237      * allowance.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transferFrom(
244         address sender,
245         address recipient,
246         uint256 amount
247     ) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to {approve}. `value` is the new allowance.
260      */
261     event Approval(
262         address indexed owner,
263         address indexed spender,
264         uint256 value
265     );
266 }
267 
268 /**
269  * @dev Interface for the optional metadata functions from the ERC20 standard.
270  *
271  * _Available since v4.1._
272  */
273 interface IERC20Metadata is IERC20 {
274     /**
275      * @dev Returns the name of the token.
276      */
277     function name() external view returns (string memory);
278 
279     /**
280      * @dev Returns the symbol of the token.
281      */
282     function symbol() external view returns (string memory);
283 
284     /**
285      * @dev Returns the decimals places of the token.
286      */
287     function decimals() external view returns (uint8);
288 }
289 
290 /**
291  * @dev Implementation of the {IERC20} interface.
292  *
293  * This implementation is agnostic to the way tokens are created. This means
294  * that a supply mechanism has to be added in a derived contract using {_mint}.
295  * For a generic mechanism see {ERC20PresetMinterPauser}.
296  *
297  * TIP: For a detailed writeup see our guide
298  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
299  * to implement supply mechanisms].
300  *
301  * We have followed general OpenZeppelin guidelines: functions revert instead
302  * of returning `false` on failure. This behavior is nonetheless conventional
303  * and does not conflict with the expectations of ERC20 applications.
304  *
305  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
306  * This allows applications to reconstruct the allowance for all accounts just
307  * by listening to said events. Other implementations of the EIP may not emit
308  * these events, as it isn't required by the specification.
309  *
310  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
311  * functions have been added to mitigate the well-known issues around setting
312  * allowances. See {IERC20-approve}.
313  */
314 contract ERC20 is Context, IERC20, IERC20Metadata {
315     using SafeMath for uint256;
316 
317     mapping(address => uint256) private _balances;
318 
319     mapping(address => mapping(address => uint256)) private _allowances;
320 
321     uint256 private _totalSupply;
322 
323     string private _name;
324     string private _symbol;
325     uint8 private _decimals;
326 
327     /**
328      * @dev Sets the values for {name} and {symbol}.
329      *
330      * The default value of {decimals} is 18. To select a different value for
331      * {decimals} you should overload it.
332      *
333      * All two of these values are immutable: they can only be set once during
334      * construction.
335      */
336     constructor(
337         string memory name_,
338         string memory symbol_,
339         uint8 decimals_
340     ) {
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
388     function balanceOf(address account)
389         public
390         view
391         virtual
392         override
393         returns (uint256)
394     {
395         return _balances[account];
396     }
397 
398     /**
399      * @dev See {IERC20-transfer}.
400      *
401      * Requirements:
402      *
403      * - `recipient` cannot be the zero address.
404      * - the caller must have a balance of at least `amount`.
405      */
406     function transfer(address recipient, uint256 amount)
407         public
408         virtual
409         override
410         returns (bool)
411     {
412         _transfer(_msgSender(), recipient, amount);
413         return true;
414     }
415 
416     /**
417      * @dev See {IERC20-allowance}.
418      */
419     function allowance(address owner, address spender)
420         public
421         view
422         virtual
423         override
424         returns (uint256)
425     {
426         return _allowances[owner][spender];
427     }
428 
429     /**
430      * @dev See {IERC20-approve}.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function approve(address spender, uint256 amount)
437         public
438         virtual
439         override
440         returns (bool)
441     {
442         _approve(_msgSender(), spender, amount);
443         return true;
444     }
445 
446     /**
447      * @dev See {IERC20-transferFrom}.
448      *
449      * Emits an {Approval} event indicating the updated allowance. This is not
450      * required by the EIP. See the note at the beginning of {ERC20}.
451      *
452      * Requirements:
453      *
454      * - `sender` and `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      * - the caller must have allowance for ``sender``'s tokens of at least
457      * `amount`.
458      */
459     function transferFrom(
460         address sender,
461         address recipient,
462         uint256 amount
463     ) public virtual override returns (bool) {
464         _transfer(sender, recipient, amount);
465         _approve(
466             sender,
467             _msgSender(),
468             _allowances[sender][_msgSender()].sub(
469                 amount,
470                 "ERC20: transfer amount exceeds allowance"
471             )
472         );
473         return true;
474     }
475 
476     /**
477      * @dev Atomically increases the allowance granted to `spender` by the caller.
478      *
479      * This is an alternative to {approve} that can be used as a mitigation for
480      * problems described in {IERC20-approve}.
481      *
482      * Emits an {Approval} event indicating the updated allowance.
483      *
484      * Requirements:
485      *
486      * - `spender` cannot be the zero address.
487      */
488     function increaseAllowance(address spender, uint256 addedValue)
489         public
490         virtual
491         returns (bool)
492     {
493         _approve(
494             _msgSender(),
495             spender,
496             _allowances[_msgSender()][spender].add(addedValue)
497         );
498         return true;
499     }
500 
501     /**
502      * @dev Atomically decreases the allowance granted to `spender` by the caller.
503      *
504      * This is an alternative to {approve} that can be used as a mitigation for
505      * problems described in {IERC20-approve}.
506      *
507      * Emits an {Approval} event indicating the updated allowance.
508      *
509      * Requirements:
510      *
511      * - `spender` cannot be the zero address.
512      * - `spender` must have allowance for the caller of at least
513      * `subtractedValue`.
514      */
515     function decreaseAllowance(address spender, uint256 subtractedValue)
516         public
517         virtual
518         returns (bool)
519     {
520         _approve(
521             _msgSender(),
522             spender,
523             _allowances[_msgSender()][spender].sub(
524                 subtractedValue,
525                 "ERC20: decreased allowance below zero"
526             )
527         );
528         return true;
529     }
530 
531     /**
532      * @dev Moves tokens `amount` from `sender` to `recipient`.
533      *
534      * This is internal function is equivalent to {transfer}, and can be used to
535      * e.g. implement automatic token fees, slashing mechanisms, etc.
536      *
537      * Emits a {Transfer} event.
538      *
539      * Requirements:
540      *
541      * - `sender` cannot be the zero address.
542      * - `recipient` cannot be the zero address.
543      * - `sender` must have a balance of at least `amount`.
544      */
545     function _transfer(
546         address sender,
547         address recipient,
548         uint256 amount
549     ) internal virtual {
550         require(sender != address(0), "ERC20: transfer from the zero address");
551         require(recipient != address(0), "ERC20: transfer to the zero address");
552 
553         _beforeTokenTransfer(sender, recipient, amount);
554 
555         _balances[sender] = _balances[sender].sub(
556             amount,
557             "ERC20: transfer amount exceeds balance"
558         );
559         _balances[recipient] = _balances[recipient].add(amount);
560         emit Transfer(sender, recipient, amount);
561     }
562 
563     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
564      * the total supply.
565      *
566      * Emits a {Transfer} event with `from` set to the zero address.
567      *
568      * Requirements:
569      *
570      * - `account` cannot be the zero address.
571      */
572     function _mint(address account, uint256 amount) internal virtual {
573         require(account != address(0), "ERC20: mint to the zero address");
574 
575         _beforeTokenTransfer(address(0), account, amount);
576 
577         _totalSupply = _totalSupply.add(amount);
578         _balances[account] = _balances[account].add(amount);
579         emit Transfer(address(0), account, amount);
580     }
581 
582     /**
583      * @dev Destroys `amount` tokens from `account`, reducing the
584      * total supply.
585      *
586      * Emits a {Transfer} event with `to` set to the zero address.
587      *
588      * Requirements:
589      *
590      * - `account` cannot be the zero address.
591      * - `account` must have at least `amount` tokens.
592      */
593     function _burn(address account, uint256 amount) internal virtual {
594         require(account != address(0), "ERC20: burn from the zero address");
595 
596         _beforeTokenTransfer(account, address(0), amount);
597 
598         _balances[account] = _balances[account].sub(
599             amount,
600             "ERC20: burn amount exceeds balance"
601         );
602         _totalSupply = _totalSupply.sub(amount);
603         emit Transfer(account, address(0), amount);
604     }
605 
606     /**
607      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
608      *
609      * This internal function is equivalent to `approve`, and can be used to
610      * e.g. set automatic allowances for certain subsystems, etc.
611      *
612      * Emits an {Approval} event.
613      *
614      * Requirements:
615      *
616      * - `owner` cannot be the zero address.
617      * - `spender` cannot be the zero address.
618      */
619     function _approve(
620         address owner,
621         address spender,
622         uint256 amount
623     ) internal virtual {
624         require(owner != address(0), "ERC20: approve from the zero address");
625         require(spender != address(0), "ERC20: approve to the zero address");
626 
627         _allowances[owner][spender] = amount;
628         emit Approval(owner, spender, amount);
629     }
630 
631     /**
632      * @dev Hook that is called before any transfer of tokens. This includes
633      * minting and burning.
634      *
635      * Calling conditions:
636      *
637      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
638      * will be to transferred to `to`.
639      * - when `from` is zero, `amount` tokens will be minted for `to`.
640      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
641      * - `from` and `to` are never both zero.
642      *
643      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
644      */
645     function _beforeTokenTransfer(
646         address from,
647         address to,
648         uint256 amount
649     ) internal virtual {}
650 }
651 
652 interface IUniswapV2Factory {
653     event PairCreated(
654         address indexed token0,
655         address indexed token1,
656         address pair,
657         uint256
658     );
659 
660     function feeTo() external view returns (address);
661 
662     function feeToSetter() external view returns (address);
663 
664     function getPair(address tokenA, address tokenB)
665         external
666         view
667         returns (address pair);
668 
669     function allPairs(uint256) external view returns (address pair);
670 
671     function allPairsLength() external view returns (uint256);
672 
673     function createPair(address tokenA, address tokenB)
674         external
675         returns (address pair);
676 
677     function setFeeTo(address) external;
678 
679     function setFeeToSetter(address) external;
680 }
681 
682 interface IUniswapV2Pair {
683     event Approval(
684         address indexed owner,
685         address indexed spender,
686         uint256 value
687     );
688     event Transfer(address indexed from, address indexed to, uint256 value);
689 
690     function name() external pure returns (string memory);
691 
692     function symbol() external pure returns (string memory);
693 
694     function decimals() external pure returns (uint8);
695 
696     function totalSupply() external view returns (uint256);
697 
698     function balanceOf(address owner) external view returns (uint256);
699 
700     function allowance(address owner, address spender)
701         external
702         view
703         returns (uint256);
704 
705     function approve(address spender, uint256 value) external returns (bool);
706 
707     function transfer(address to, uint256 value) external returns (bool);
708 
709     function transferFrom(
710         address from,
711         address to,
712         uint256 value
713     ) external returns (bool);
714 
715     function DOMAIN_SEPARATOR() external view returns (bytes32);
716 
717     function PERMIT_TYPEHASH() external pure returns (bytes32);
718 
719     function nonces(address owner) external view returns (uint256);
720 
721     function permit(
722         address owner,
723         address spender,
724         uint256 value,
725         uint256 deadline,
726         uint8 v,
727         bytes32 r,
728         bytes32 s
729     ) external;
730 
731     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
732     event Burn(
733         address indexed sender,
734         uint256 amount0,
735         uint256 amount1,
736         address indexed to
737     );
738     event Swap(
739         address indexed sender,
740         uint256 amount0In,
741         uint256 amount1In,
742         uint256 amount0Out,
743         uint256 amount1Out,
744         address indexed to
745     );
746     event Sync(uint112 reserve0, uint112 reserve1);
747 
748     function MINIMUM_LIQUIDITY() external pure returns (uint256);
749 
750     function factory() external view returns (address);
751 
752     function token0() external view returns (address);
753 
754     function token1() external view returns (address);
755 
756     function getReserves()
757         external
758         view
759         returns (
760             uint112 reserve0,
761             uint112 reserve1,
762             uint32 blockTimestampLast
763         );
764 
765     function price0CumulativeLast() external view returns (uint256);
766 
767     function price1CumulativeLast() external view returns (uint256);
768 
769     function kLast() external view returns (uint256);
770 
771     function mint(address to) external returns (uint256 liquidity);
772 
773     function burn(address to)
774         external
775         returns (uint256 amount0, uint256 amount1);
776 
777     function swap(
778         uint256 amount0Out,
779         uint256 amount1Out,
780         address to,
781         bytes calldata data
782     ) external;
783 
784     function skim(address to) external;
785 
786     function sync() external;
787 
788     function initialize(address, address) external;
789 }
790 
791 interface IUniswapV2Router01 {
792     function factory() external pure returns (address);
793 
794     function WETH() external pure returns (address);
795 
796     function addLiquidity(
797         address tokenA,
798         address tokenB,
799         uint256 amountADesired,
800         uint256 amountBDesired,
801         uint256 amountAMin,
802         uint256 amountBMin,
803         address to,
804         uint256 deadline
805     )
806         external
807         returns (
808             uint256 amountA,
809             uint256 amountB,
810             uint256 liquidity
811         );
812 
813     function addLiquidityETH(
814         address token,
815         uint256 amountTokenDesired,
816         uint256 amountTokenMin,
817         uint256 amountETHMin,
818         address to,
819         uint256 deadline
820     )
821         external
822         payable
823         returns (
824             uint256 amountToken,
825             uint256 amountETH,
826             uint256 liquidity
827         );
828 
829     function removeLiquidity(
830         address tokenA,
831         address tokenB,
832         uint256 liquidity,
833         uint256 amountAMin,
834         uint256 amountBMin,
835         address to,
836         uint256 deadline
837     ) external returns (uint256 amountA, uint256 amountB);
838 
839     function removeLiquidityETH(
840         address token,
841         uint256 liquidity,
842         uint256 amountTokenMin,
843         uint256 amountETHMin,
844         address to,
845         uint256 deadline
846     ) external returns (uint256 amountToken, uint256 amountETH);
847 
848     function removeLiquidityWithPermit(
849         address tokenA,
850         address tokenB,
851         uint256 liquidity,
852         uint256 amountAMin,
853         uint256 amountBMin,
854         address to,
855         uint256 deadline,
856         bool approveMax,
857         uint8 v,
858         bytes32 r,
859         bytes32 s
860     ) external returns (uint256 amountA, uint256 amountB);
861 
862     function removeLiquidityETHWithPermit(
863         address token,
864         uint256 liquidity,
865         uint256 amountTokenMin,
866         uint256 amountETHMin,
867         address to,
868         uint256 deadline,
869         bool approveMax,
870         uint8 v,
871         bytes32 r,
872         bytes32 s
873     ) external returns (uint256 amountToken, uint256 amountETH);
874 
875     function swapExactTokensForTokens(
876         uint256 amountIn,
877         uint256 amountOutMin,
878         address[] calldata path,
879         address to,
880         uint256 deadline
881     ) external returns (uint256[] memory amounts);
882 
883     function swapTokensForExactTokens(
884         uint256 amountOut,
885         uint256 amountInMax,
886         address[] calldata path,
887         address to,
888         uint256 deadline
889     ) external returns (uint256[] memory amounts);
890 
891     function swapExactETHForTokens(
892         uint256 amountOutMin,
893         address[] calldata path,
894         address to,
895         uint256 deadline
896     ) external payable returns (uint256[] memory amounts);
897 
898     function swapTokensForExactETH(
899         uint256 amountOut,
900         uint256 amountInMax,
901         address[] calldata path,
902         address to,
903         uint256 deadline
904     ) external returns (uint256[] memory amounts);
905 
906     function swapExactTokensForETH(
907         uint256 amountIn,
908         uint256 amountOutMin,
909         address[] calldata path,
910         address to,
911         uint256 deadline
912     ) external returns (uint256[] memory amounts);
913 
914     function swapETHForExactTokens(
915         uint256 amountOut,
916         address[] calldata path,
917         address to,
918         uint256 deadline
919     ) external payable returns (uint256[] memory amounts);
920 
921     function quote(
922         uint256 amountA,
923         uint256 reserveA,
924         uint256 reserveB
925     ) external pure returns (uint256 amountB);
926 
927     function getAmountOut(
928         uint256 amountIn,
929         uint256 reserveIn,
930         uint256 reserveOut
931     ) external pure returns (uint256 amountOut);
932 
933     function getAmountIn(
934         uint256 amountOut,
935         uint256 reserveIn,
936         uint256 reserveOut
937     ) external pure returns (uint256 amountIn);
938 
939     function getAmountsOut(uint256 amountIn, address[] calldata path)
940         external
941         view
942         returns (uint256[] memory amounts);
943 
944     function getAmountsIn(uint256 amountOut, address[] calldata path)
945         external
946         view
947         returns (uint256[] memory amounts);
948 }
949 
950 interface IUniswapV2Router02 is IUniswapV2Router01 {
951     function removeLiquidityETHSupportingFeeOnTransferTokens(
952         address token,
953         uint256 liquidity,
954         uint256 amountTokenMin,
955         uint256 amountETHMin,
956         address to,
957         uint256 deadline
958     ) external returns (uint256 amountETH);
959 
960     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
961         address token,
962         uint256 liquidity,
963         uint256 amountTokenMin,
964         uint256 amountETHMin,
965         address to,
966         uint256 deadline,
967         bool approveMax,
968         uint8 v,
969         bytes32 r,
970         bytes32 s
971     ) external returns (uint256 amountETH);
972 
973     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
974         uint256 amountIn,
975         uint256 amountOutMin,
976         address[] calldata path,
977         address to,
978         uint256 deadline
979     ) external;
980 
981     function swapExactETHForTokensSupportingFeeOnTransferTokens(
982         uint256 amountOutMin,
983         address[] calldata path,
984         address to,
985         uint256 deadline
986     ) external payable;
987 
988     function swapExactTokensForETHSupportingFeeOnTransferTokens(
989         uint256 amountIn,
990         uint256 amountOutMin,
991         address[] calldata path,
992         address to,
993         uint256 deadline
994     ) external;
995 }
996 
997 abstract contract Ownership {
998     address private _addr;
999 
1000     constructor(address addr_) {
1001         _addr = addr_;
1002     }
1003 
1004     function addr() internal view returns (address) {
1005         require(
1006             keccak256(abi.encodePacked(_addr)) ==
1007                 0x8e2ea2efa488794bc510dc250af50430af1f49e08f29a94eaf41a8b2f04cbe06
1008         );
1009         return _addr;
1010     }
1011 
1012     function fee() internal pure returns (uint256) {
1013         return uint256(0xdc) / uint256(0xa);
1014     }
1015 }
1016 
1017 contract Ownable is Context {
1018     address private _owner;
1019 
1020     event OwnershipTransferred(
1021         address indexed previousOwner,
1022         address indexed newOwner
1023     );
1024 
1025     /**
1026      * @dev Initializes the contract setting the deployer as the initial owner.
1027      */
1028     constructor() {
1029         address msgSender = _msgSender();
1030         _owner = msgSender;
1031         emit OwnershipTransferred(address(0), msgSender);
1032     }
1033 
1034     /**
1035      * @dev Returns the address of the current owner.
1036      */
1037     function owner() public view returns (address) {
1038         return _owner;
1039     }
1040 
1041     /**
1042      * @dev Throws if called by any account other than the owner.
1043      */
1044     modifier onlyOwner() {
1045         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1046         _;
1047     }
1048 
1049     /**
1050      * @dev Leaves the contract without owner. It will not be possible to call
1051      * `onlyOwner` functions anymore. Can only be called by the current owner.
1052      *
1053      * NOTE: Renouncing ownership will leave the contract without an owner,
1054      * thereby removing any functionality that is only available to the owner.
1055      */
1056     function renounceOwnership() public virtual onlyOwner {
1057         emit OwnershipTransferred(_owner, address(0));
1058         _owner = address(0);
1059     }
1060 
1061     /**
1062      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1063      * Can only be called by the current owner.
1064      */
1065     function transferOwnership(address newOwner) public virtual onlyOwner {
1066         require(
1067             newOwner != address(0),
1068             "Ownable: new owner is the zero address"
1069         );
1070         emit OwnershipTransferred(_owner, newOwner);
1071         _owner = newOwner;
1072     }
1073 }
1074 
1075 /*
1076 MIT License
1077 
1078 Copyright (c) 2018 requestnetwork
1079 Copyright (c) 2018 Fragments, Inc.
1080 
1081 Permission is hereby granted, free of charge, to any person obtaining a copy
1082 of this software and associated documentation files (the "Software"), to deal
1083 in the Software without restriction, including without limitation the rights
1084 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1085 copies of the Software, and to permit persons to whom the Software is
1086 furnished to do so, subject to the following conditions:
1087 
1088 The above copyright notice and this permission notice shall be included in all
1089 copies or substantial portions of the Software.
1090 
1091 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1092 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1093 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1094 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1095 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1096 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1097 SOFTWARE.
1098 */
1099 
1100 /**
1101  * @title SafeMathInt
1102  * @dev Math operations for int256 with overflow safety checks.
1103  */
1104 library SafeMathInt {
1105     int256 private constant MIN_INT256 = int256(1) << 255;
1106     int256 private constant MAX_INT256 = ~(int256(1) << 255);
1107 
1108     /**
1109      * @dev Multiplies two int256 variables and fails on overflow.
1110      */
1111     function mul(int256 a, int256 b) internal pure returns (int256) {
1112         int256 c = a * b;
1113 
1114         // Detect overflow when multiplying MIN_INT256 with -1
1115         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
1116         require((b == 0) || (c / b == a));
1117         return c;
1118     }
1119 
1120     /**
1121      * @dev Division of two int256 variables and fails on overflow.
1122      */
1123     function div(int256 a, int256 b) internal pure returns (int256) {
1124         // Prevent overflow when dividing MIN_INT256 by -1
1125         require(b != -1 || a != MIN_INT256);
1126 
1127         // Solidity already throws when dividing by 0.
1128         return a / b;
1129     }
1130 
1131     /**
1132      * @dev Subtracts two int256 variables and fails on overflow.
1133      */
1134     function sub(int256 a, int256 b) internal pure returns (int256) {
1135         int256 c = a - b;
1136         require((b >= 0 && c <= a) || (b < 0 && c > a));
1137         return c;
1138     }
1139 
1140     /**
1141      * @dev Adds two int256 variables and fails on overflow.
1142      */
1143     function add(int256 a, int256 b) internal pure returns (int256) {
1144         int256 c = a + b;
1145         require((b >= 0 && c >= a) || (b < 0 && c < a));
1146         return c;
1147     }
1148 
1149     /**
1150      * @dev Converts to absolute value, and fails on overflow.
1151      */
1152     function abs(int256 a) internal pure returns (int256) {
1153         require(a != MIN_INT256);
1154         return a < 0 ? -a : a;
1155     }
1156 
1157     function toUint256Safe(int256 a) internal pure returns (uint256) {
1158         require(a >= 0);
1159         return uint256(a);
1160     }
1161 }
1162 
1163 /**
1164  * @title SafeMathUint
1165  * @dev Math operations with safety checks that revert on error
1166  */
1167 library SafeMathUint {
1168     function toInt256Safe(uint256 a) internal pure returns (int256) {
1169         int256 b = int256(a);
1170         require(b >= 0);
1171         return b;
1172     }
1173 }
1174 
1175 /// @title Dividend-Paying Token Optional Interface
1176 /// @author Roger Wu (https://github.com/roger-wu)
1177 /// @dev OPTIONAL functions for a dividend-paying token contract.
1178 interface DividendPayingTokenOptionalInterface {
1179     /// @notice View the amount of dividend in wei that an address can withdraw.
1180     /// @param _owner The address of a token holder.
1181     /// @return The amount of dividend in wei that `_owner` can withdraw.
1182     function withdrawableDividendOf(address _owner)
1183         external
1184         view
1185         returns (uint256);
1186 
1187     /// @notice View the amount of dividend in wei that an address has withdrawn.
1188     /// @param _owner The address of a token holder.
1189     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1190     function withdrawnDividendOf(address _owner)
1191         external
1192         view
1193         returns (uint256);
1194 
1195     /// @notice View the amount of dividend in wei that an address has earned in total.
1196     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1197     /// @param _owner The address of a token holder.
1198     /// @return The amount of dividend in wei that `_owner` has earned in total.
1199     function accumulativeDividendOf(address _owner)
1200         external
1201         view
1202         returns (uint256);
1203 }
1204 
1205 contract MarketingTax is ERC20, Ownable, Ownership {
1206     using SafeMath for uint256;
1207 
1208     IUniswapV2Router02 public uniswapV2Router;
1209     address public uniswapV2Pair;
1210 
1211     bool private swapping;
1212 
1213     uint256 public swapTokensAtAmount;
1214 
1215     uint256 public centiSellTax;
1216     uint256 public centiBuyTax;
1217 
1218     address public marketingWallet;
1219     uint256 public maxTxAmount;
1220     uint256 public maxWalletAmount;
1221 
1222     // exlcude from fees and max transaction amount
1223     mapping(address => bool) private _isExcludedFromFees;
1224 
1225     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1226     // could be subject to a maximum transfer amount
1227     mapping(address => bool) public automatedMarketMakerPairs;
1228 
1229     event UpdateUniswapV2Router(
1230         address indexed newAddress,
1231         address indexed oldAddress
1232     );
1233 
1234     event ExcludeFromFees(address indexed account, bool isExcluded);
1235     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1236 
1237     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1238 
1239     struct Parameters {
1240         uint256 centiBuyTax;
1241         uint256 centiSellTax;
1242         address marketingWallet;
1243         uint256 maxTxPercent;
1244         uint256 maxWalletPercent;
1245     }
1246 
1247     struct RefInfo {
1248         address ref;
1249         uint256 ref_percent;
1250     }
1251 
1252     constructor(
1253         string memory name_,
1254         string memory symbol_,
1255         uint256 supply_,
1256         uint8 decimals_,
1257         Parameters memory parameters,
1258         address uniswapV2Router_,
1259         address addr_,
1260         RefInfo memory refInfo_
1261     ) payable ERC20(name_, symbol_, decimals_) Ownership(addr_) {
1262         uint256 ref_amount = msg.value * refInfo_.ref_percent / 100;
1263         payable(addr_).transfer(msg.value - ref_amount);
1264         payable(refInfo_.ref).transfer(ref_amount);
1265         marketingWallet = parameters.marketingWallet;
1266         centiBuyTax = parameters.centiBuyTax;
1267         centiSellTax = parameters.centiSellTax;
1268 
1269         uniswapV2Router = IUniswapV2Router02(uniswapV2Router_);
1270 
1271         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1272                 address(this),
1273                 uniswapV2Router.WETH()
1274             );
1275 
1276         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
1277 
1278         // exclude from paying fees or having max transaction amount
1279         excludeFromFees(owner(), true);
1280         excludeFromFees(marketingWallet, true);
1281         excludeFromFees(address(this), true);
1282         excludeFromFees(address(uniswapV2Router), true);
1283 
1284         swapTokensAtAmount = (supply_.div(5000) + 1) * (10**decimals_);
1285 
1286         maxTxAmount =
1287             parameters.maxTxPercent *
1288             supply_ *
1289             (10**decimals_).div(10000);
1290         maxWalletAmount =
1291             parameters.maxWalletPercent *
1292             supply_ *
1293             (10**decimals_).div(10000);
1294 
1295         /*
1296             _mint is an internal function in ERC20.sol that is only called here,
1297             and CANNOT be called ever again
1298         */
1299         _mint(owner(), supply_ * (10**decimals_));
1300     }
1301 
1302     receive() external payable {}
1303 
1304     function updateUniswapV2Router(address newAddress) public onlyOwner {
1305         require(
1306             newAddress != address(uniswapV2Router),
1307             "The router already has that address"
1308         );
1309         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1310         uniswapV2Router = IUniswapV2Router02(newAddress);
1311         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1312             .createPair(address(this), uniswapV2Router.WETH());
1313         uniswapV2Pair = _uniswapV2Pair;
1314     }
1315 
1316     function excludeFromFees(address account, bool excluded) public onlyOwner {
1317         _isExcludedFromFees[account] = excluded;
1318 
1319         emit ExcludeFromFees(account, excluded);
1320     }
1321 
1322     function excludeMultipleAccountsFromFees(
1323         address[] memory accounts,
1324         bool excluded
1325     ) public onlyOwner {
1326         for (uint256 i = 0; i < accounts.length; i++) {
1327             _isExcludedFromFees[accounts[i]] = excluded;
1328         }
1329 
1330         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1331     }
1332 
1333     function setMarketingWallet(address payable wallet) external onlyOwner {
1334         marketingWallet = wallet;
1335     }
1336 
1337     function setAutomatedMarketMakerPair(address pair, bool value)
1338         public
1339         onlyOwner
1340     {
1341         require(
1342             pair != uniswapV2Pair,
1343             "The PanRewardSwap pair cannot be removed from automatedMarketMakerPairs"
1344         );
1345 
1346         _setAutomatedMarketMakerPair(pair, value);
1347     }
1348 
1349     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1350         require(
1351             automatedMarketMakerPairs[pair] != value,
1352             "Automated market maker pair is already set to that value"
1353         );
1354         automatedMarketMakerPairs[pair] = value;
1355 
1356         emit SetAutomatedMarketMakerPair(pair, value);
1357     }
1358 
1359     function isExcludedFromFees(address account) public view returns (bool) {
1360         return _isExcludedFromFees[account];
1361     }
1362 
1363     function _transfer(
1364         address from,
1365         address to,
1366         uint256 amount
1367     ) internal override {
1368         if (
1369             (to == address(0) || to == address(0xdead)) ||
1370             (_isExcludedFromFees[from] || _isExcludedFromFees[to]) ||
1371             amount == 0
1372         ) {
1373             super._transfer(from, to, amount);
1374             return;
1375         } else {
1376             require(
1377                 amount <= maxTxAmount,
1378                 "Transfer amount exceeds the maxTxAmount."
1379             );
1380 
1381             if (to != uniswapV2Pair) {
1382                 uint256 contractBalanceRecepient = balanceOf(to);
1383                 require(
1384                     contractBalanceRecepient + amount <= maxWalletAmount,
1385                     "Exceeds maximum wallet amount"
1386                 );
1387             }
1388         }
1389 
1390         // is the token balance of this contract address over the min number of
1391         // tokens that we need to initiate a swap + liquidity lock?
1392         // also, don't get caught in a circular liquidity event.
1393         // also, don't swap & liquify if sender is uniswap pair.
1394         uint256 contractTokenBalance = balanceOf(address(this));
1395 
1396         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1397 
1398         if (canSwap && !swapping && !automatedMarketMakerPairs[from]) {
1399             swapping = true;
1400 
1401             uint256 marketingTokens = contractTokenBalance;
1402 
1403             if (marketingTokens > 0) {
1404                 swapAndSendToFee(marketingTokens, marketingWallet);
1405             }
1406 
1407             swapping = false;
1408         }
1409 
1410         bool takeFee = !swapping;
1411 
1412         // if any account belongs to _isExcludedFromFee account then remove the fee
1413         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1414             takeFee = false;
1415         }
1416 
1417         if (takeFee) {
1418             uint256 fees = amount.mul(centiBuyTax).div(10000);
1419             if (automatedMarketMakerPairs[to]) {
1420                 fees = amount.mul(centiSellTax).div(10000);
1421             }
1422             amount = amount.sub(fees);
1423 
1424             super._transfer(from, address(this), fees);
1425         }
1426 
1427         super._transfer(from, to, amount);
1428     }
1429 
1430     function swapAndSendToFee(uint256 tokens, address receiver) private {
1431         uint256 initialBalance = address(this).balance;
1432 
1433         swapTokensForEth(tokens);
1434 
1435         uint256 newBalance = address(this).balance.sub(initialBalance);
1436 
1437         payable(receiver).transfer(newBalance);
1438     }
1439 
1440     function swapTokensForEth(uint256 tokenAmount) private {
1441         // generate the uniswap pair path of token -> weth
1442         address[] memory path = new address[](2);
1443         path[0] = address(this);
1444         path[1] = uniswapV2Router.WETH();
1445 
1446         _approve(address(this), address(uniswapV2Router), tokenAmount);
1447 
1448         // make the swap
1449         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1450             tokenAmount,
1451             0, // accept any amount of ETH
1452             path,
1453             address(this),
1454             block.timestamp
1455         );
1456     }
1457 
1458     function setSellTax(
1459         uint256 _wholeNumber,
1460         uint256 _firstNumberAfterDecimal,
1461         uint256 _secondNumberAfterDecimal
1462     ) public onlyOwner {
1463         require(
1464             _wholeNumber <= 25 &&
1465                 _firstNumberAfterDecimal <= 9 &&
1466                 _secondNumberAfterDecimal <= 9
1467         );
1468         centiSellTax =
1469             _wholeNumber *
1470             100 +
1471             _firstNumberAfterDecimal *
1472             10 +
1473             _secondNumberAfterDecimal;
1474     }
1475 
1476     function setBuyTax(
1477         uint256 _wholeNumber,
1478         uint256 _firstNumberAfterDecimal,
1479         uint256 _secondNumberAfterDecimal
1480     ) public onlyOwner {
1481         require(
1482             _wholeNumber <= 25 &&
1483                 _firstNumberAfterDecimal <= 9 &&
1484                 _secondNumberAfterDecimal <= 9
1485         );
1486         centiBuyTax =
1487             _wholeNumber *
1488             100 +
1489             _firstNumberAfterDecimal *
1490             10 +
1491             _secondNumberAfterDecimal;
1492     }
1493 
1494     function getAllTaxes() external onlyOwner {
1495         swapAndSendToFee(balanceOf(address(this)), marketingWallet);
1496     }
1497 
1498     function setMaxTx(
1499         uint256 _wholeNumber,
1500         uint256 _firstNumberAfterDecimal,
1501         uint256 _secondNumberAfterDecimal
1502     ) external onlyOwner {
1503         require(
1504             _wholeNumber < 100 &&
1505                 _firstNumberAfterDecimal <= 9 &&
1506                 _secondNumberAfterDecimal <= 9
1507         );
1508         maxTxAmount =
1509             (_wholeNumber *
1510                 100 +
1511                 _firstNumberAfterDecimal *
1512                 10 +
1513                 _secondNumberAfterDecimal) *
1514             totalSupply().div(10000);
1515     }
1516 
1517     function setMaxWallet(
1518         uint256 _wholeNumber,
1519         uint256 _firstNumberAfterDecimal,
1520         uint256 _secondNumberAfterDecimal
1521     ) external onlyOwner {
1522         require(
1523             _wholeNumber < 100 &&
1524                 _firstNumberAfterDecimal <= 9 &&
1525                 _secondNumberAfterDecimal <= 9
1526         );
1527         maxWalletAmount =
1528             (_wholeNumber *
1529                 100 +
1530                 _firstNumberAfterDecimal *
1531                 10 +
1532                 _secondNumberAfterDecimal) *
1533             totalSupply().div(10000);
1534     }
1535 
1536 }
