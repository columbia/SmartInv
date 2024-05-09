1 /*
2 
3 https://boopai.com
4 
5 */
6 
7 // SPDX-License-Identifier: UNLICENSED
8 
9 pragma solidity ^0.8.10;
10 pragma experimental ABIEncoderV2;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33 
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         _transferOwnership(address(0));
46     }
47 
48 
49     function transferOwnership(address newOwner) public virtual onlyOwner {
50         require(newOwner != address(0), "Ownable: new owner is the zero address");
51         _transferOwnership(newOwner);
52     }
53 
54     function _transferOwnership(address newOwner) internal virtual {
55         address oldOwner = _owner;
56         _owner = newOwner;
57         emit OwnershipTransferred(oldOwner, newOwner);
58     }
59 }
60 
61 interface IERC20 {
62 
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address account) external view returns (uint256);
66 
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 interface IERC20Metadata is IERC20 {
85 
86     function name() external view returns (string memory);
87 
88     function symbol() external view returns (string memory);
89 
90     function decimals() external view returns (uint8);
91 }
92 
93 contract ERC20 is Context, IERC20, IERC20Metadata {
94     mapping(address => uint256) private _balances;
95 
96     mapping(address => mapping(address => uint256)) private _allowances;
97 
98     uint256 private _totalSupply;
99 
100     string private _name;
101     string private _symbol;
102 
103     /**
104      * @dev Sets the values for {name} and {symbol}.
105      *
106      * The default value of {decimals} is 18. To select a different value for
107      * {decimals} you should overload it.
108      *
109      * All two of these values are immutable: they can only be set once during
110      * construction.
111      */
112     constructor(string memory name_, string memory symbol_) {
113         _name = name_;
114         _symbol = symbol_;
115     }
116 
117     /**
118      * @dev Returns the name of the token.
119      */
120     function name() public view virtual override returns (string memory) {
121         return _name;
122     }
123 
124     /**
125      * @dev Returns the symbol of the token, usually a shorter version of the
126      * name.
127      */
128     function symbol() public view virtual override returns (string memory) {
129         return _symbol;
130     }
131 
132     /**
133      * @dev Returns the number of decimals used to get its user representation.
134      * For example, if `decimals` equals `2`, a balance of `505` tokens should
135      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
136      *
137      * Tokens usually opt for a value of 18, imitating the relationship between
138      * Ether and Wei. This is the value {ERC20} uses, unless this function is
139      * overridden;
140      *
141      * NOTE: This information is only used for _display_ purposes: it in
142      * no way affects any of the arithmetic of the contract, including
143      * {IERC20-balanceOf} and {IERC20-transfer}.
144      */
145     function decimals() public view virtual override returns (uint8) {
146         return 18;
147     }
148 
149     /**
150      * @dev See {IERC20-totalSupply}.
151      */
152     function totalSupply() public view virtual override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     /**
157      * @dev See {IERC20-balanceOf}.
158      */
159     function balanceOf(address account) public view virtual override returns (uint256) {
160         return _balances[account];
161     }
162 
163     /**
164      * @dev See {IERC20-transfer}.
165      *
166      * Requirements:
167      *
168      * - `recipient` cannot be the zero address.
169      * - the caller must have a balance of at least `amount`.
170      */
171     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
172         _transfer(_msgSender(), recipient, amount);
173         return true;
174     }
175 
176     /**
177      * @dev See {IERC20-allowance}.
178      */
179     function allowance(address owner, address spender) public view virtual override returns (uint256) {
180         return _allowances[owner][spender];
181     }
182 
183     /**
184      * @dev See {IERC20-approve}.
185      *
186      * Requirements:
187      *
188      * - `spender` cannot be the zero address.
189      */
190     function approve(address spender, uint256 amount) public virtual override returns (bool) {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     /**
196      * @dev See {IERC20-transferFrom}.
197      *
198      * Emits an {Approval} event indicating the updated allowance. This is not
199      * required by the EIP. See the note at the beginning of {ERC20}.
200      *
201      * Requirements:
202      *
203      * - `sender` and `recipient` cannot be the zero address.
204      * - `sender` must have a balance of at least `amount`.
205      * - the caller must have allowance for ``sender``'s tokens of at least
206      * `amount`.
207      */
208     function transferFrom(
209         address sender,
210         address recipient,
211         uint256 amount
212     ) public virtual override returns (bool) {
213         _transfer(sender, recipient, amount);
214 
215         uint256 currentAllowance = _allowances[sender][_msgSender()];
216         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
217         unchecked {
218             _approve(sender, _msgSender(), currentAllowance - amount);
219         }
220 
221         return true;
222     }
223 
224     /**
225      * @dev Atomically increases the allowance granted to `spender` by the caller.
226      *
227      * This is an alternative to {approve} that can be used as a mitigation for
228      * problems described in {IERC20-approve}.
229      *
230      * Emits an {Approval} event indicating the updated allowance.
231      *
232      * Requirements:
233      *
234      * - `spender` cannot be the zero address.
235      */
236     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
237         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
238         return true;
239     }
240 
241     /**
242      * @dev Atomically decreases the allowance granted to `spender` by the caller.
243      *
244      * This is an alternative to {approve} that can be used as a mitigation for
245      * problems described in {IERC20-approve}.
246      *
247      * Emits an {Approval} event indicating the updated allowance.
248      *
249      * Requirements:
250      *
251      * - `spender` cannot be the zero address.
252      * - `spender` must have allowance for the caller of at least
253      * `subtractedValue`.
254      */
255     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
256         uint256 currentAllowance = _allowances[_msgSender()][spender];
257         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
258         unchecked {
259             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
260         }
261 
262         return true;
263     }
264 
265     /**
266      * @dev Moves `amount` of tokens from `sender` to `recipient`.
267      *
268      * This internal function is equivalent to {transfer}, and can be used to
269      * e.g. implement automatic token fees, slashing mechanisms, etc.
270      *
271      * Emits a {Transfer} event.
272      *
273      * Requirements:
274      *
275      * - `sender` cannot be the zero address.
276      * - `recipient` cannot be the zero address.
277      * - `sender` must have a balance of at least `amount`.
278      */
279     function _transfer(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) internal virtual {
284         require(sender != address(0), "ERC20: transfer from the zero address");
285         require(recipient != address(0), "ERC20: transfer to the zero address");
286 
287         _beforeTokenTransfer(sender, recipient, amount);
288 
289         uint256 senderBalance = _balances[sender];
290         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
291         unchecked {
292             _balances[sender] = senderBalance - amount;
293         }
294         _balances[recipient] += amount;
295 
296         emit Transfer(sender, recipient, amount);
297 
298         _afterTokenTransfer(sender, recipient, amount);
299     }
300 
301     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
302      * the total supply.
303      *
304      * Emits a {Transfer} event with `from` set to the zero address.
305      *
306      * Requirements:
307      *
308      * - `account` cannot be the zero address.
309      */
310     function _mint(address account, uint256 amount) internal virtual {
311         require(account != address(0), "ERC20: mint to the zero address");
312 
313         _beforeTokenTransfer(address(0), account, amount);
314 
315         _totalSupply += amount;
316         _balances[account] += amount;
317         emit Transfer(address(0), account, amount);
318 
319         _afterTokenTransfer(address(0), account, amount);
320     }
321 
322     /**
323      * @dev Destroys `amount` tokens from `account`, reducing the
324      * total supply.
325      *
326      * Emits a {Transfer} event with `to` set to the zero address.
327      *
328      * Requirements:
329      *
330      * - `account` cannot be the zero address.
331      * - `account` must have at least `amount` tokens.
332      */
333     function _burn(address account, uint256 amount) internal virtual {
334         require(account != address(0), "ERC20: burn from the zero address");
335 
336         _beforeTokenTransfer(account, address(0), amount);
337 
338         uint256 accountBalance = _balances[account];
339         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
340         unchecked {
341             _balances[account] = accountBalance - amount;
342         }
343         _totalSupply -= amount;
344 
345         emit Transfer(account, address(0), amount);
346 
347         _afterTokenTransfer(account, address(0), amount);
348     }
349 
350     /**
351      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
352      *
353      * This internal function is equivalent to `approve`, and can be used to
354      * e.g. set automatic allowances for certain subsystems, etc.
355      *
356      * Emits an {Approval} event.
357      *
358      * Requirements:
359      *
360      * - `owner` cannot be the zero address.
361      * - `spender` cannot be the zero address.
362      */
363     function _approve(
364         address owner,
365         address spender,
366         uint256 amount
367     ) internal virtual {
368         require(owner != address(0), "ERC20: approve from the zero address");
369         require(spender != address(0), "ERC20: approve to the zero address");
370 
371         _allowances[owner][spender] = amount;
372         emit Approval(owner, spender, amount);
373     }
374 
375     /**
376      * @dev Hook that is called before any transfer of tokens. This includes
377      * minting and burning.
378      *
379      * Calling conditions:
380      *
381      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
382      * will be transferred to `to`.
383      * - when `from` is zero, `amount` tokens will be minted for `to`.
384      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
385      * - `from` and `to` are never both zero.
386      *
387      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
388      */
389     function _beforeTokenTransfer(
390         address from,
391         address to,
392         uint256 amount
393     ) internal virtual {}
394 
395     /**
396      * @dev Hook that is called after any transfer of tokens. This includes
397      * minting and burning.
398      *
399      * Calling conditions:
400      *
401      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
402      * has been transferred to `to`.
403      * - when `from` is zero, `amount` tokens have been minted for `to`.
404      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
405      * - `from` and `to` are never both zero.
406      *
407      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
408      */
409     function _afterTokenTransfer(
410         address from,
411         address to,
412         uint256 amount
413     ) internal virtual {}
414 }
415 
416 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
417 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
418 
419 /* pragma solidity ^0.8.0; */
420 
421 // CAUTION
422 // This version of SafeMath should only be used with Solidity 0.8 or later,
423 // because it relies on the compiler's built in overflow checks.
424 
425 /**
426  * @dev Wrappers over Solidity's arithmetic operations.
427  *
428  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
429  * now has built in overflow checking.
430  */
431 library SafeMath {
432     /**
433      * @dev Returns the addition of two unsigned integers, with an overflow flag.
434      *
435      * _Available since v3.4._
436      */
437     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
438         unchecked {
439             uint256 c = a + b;
440             if (c < a) return (false, 0);
441             return (true, c);
442         }
443     }
444 
445     /**
446      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
447      *
448      * _Available since v3.4._
449      */
450     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
451         unchecked {
452             if (b > a) return (false, 0);
453             return (true, a - b);
454         }
455     }
456 
457     /**
458      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
459      *
460      * _Available since v3.4._
461      */
462     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
463         unchecked {
464             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
465             // benefit is lost if 'b' is also tested.
466             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
467             if (a == 0) return (true, 0);
468             uint256 c = a * b;
469             if (c / a != b) return (false, 0);
470             return (true, c);
471         }
472     }
473 
474     /**
475      * @dev Returns the division of two unsigned integers, with a division by zero flag.
476      *
477      * _Available since v3.4._
478      */
479     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
480         unchecked {
481             if (b == 0) return (false, 0);
482             return (true, a / b);
483         }
484     }
485 
486     /**
487      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
488      *
489      * _Available since v3.4._
490      */
491     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
492         unchecked {
493             if (b == 0) return (false, 0);
494             return (true, a % b);
495         }
496     }
497 
498     /**
499      * @dev Returns the addition of two unsigned integers, reverting on
500      * overflow.
501      *
502      * Counterpart to Solidity's `+` operator.
503      *
504      * Requirements:
505      *
506      * - Addition cannot overflow.
507      */
508     function add(uint256 a, uint256 b) internal pure returns (uint256) {
509         return a + b;
510     }
511 
512     /**
513      * @dev Returns the subtraction of two unsigned integers, reverting on
514      * overflow (when the result is negative).
515      *
516      * Counterpart to Solidity's `-` operator.
517      *
518      * Requirements:
519      *
520      * - Subtraction cannot overflow.
521      */
522     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
523         return a - b;
524     }
525 
526     /**
527      * @dev Returns the multiplication of two unsigned integers, reverting on
528      * overflow.
529      *
530      * Counterpart to Solidity's `*` operator.
531      *
532      * Requirements:
533      *
534      * - Multiplication cannot overflow.
535      */
536     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
537         return a * b;
538     }
539 
540     /**
541      * @dev Returns the integer division of two unsigned integers, reverting on
542      * division by zero. The result is rounded towards zero.
543      *
544      * Counterpart to Solidity's `/` operator.
545      *
546      * Requirements:
547      *
548      * - The divisor cannot be zero.
549      */
550     function div(uint256 a, uint256 b) internal pure returns (uint256) {
551         return a / b;
552     }
553 
554     /**
555      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
556      * reverting when dividing by zero.
557      *
558      * Counterpart to Solidity's `%` operator. This function uses a `revert`
559      * opcode (which leaves remaining gas untouched) while Solidity uses an
560      * invalid opcode to revert (consuming all remaining gas).
561      *
562      * Requirements:
563      *
564      * - The divisor cannot be zero.
565      */
566     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
567         return a % b;
568     }
569 
570     /**
571      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
572      * overflow (when the result is negative).
573      *
574      * CAUTION: This function is deprecated because it requires allocating memory for the error
575      * message unnecessarily. For custom revert reasons use {trySub}.
576      *
577      * Counterpart to Solidity's `-` operator.
578      *
579      * Requirements:
580      *
581      * - Subtraction cannot overflow.
582      */
583     function sub(
584         uint256 a,
585         uint256 b,
586         string memory errorMessage
587     ) internal pure returns (uint256) {
588         unchecked {
589             require(b <= a, errorMessage);
590             return a - b;
591         }
592     }
593 
594     /**
595      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
596      * division by zero. The result is rounded towards zero.
597      *
598      * Counterpart to Solidity's `/` operator. Note: this function uses a
599      * `revert` opcode (which leaves remaining gas untouched) while Solidity
600      * uses an invalid opcode to revert (consuming all remaining gas).
601      *
602      * Requirements:
603      *
604      * - The divisor cannot be zero.
605      */
606     function div(
607         uint256 a,
608         uint256 b,
609         string memory errorMessage
610     ) internal pure returns (uint256) {
611         unchecked {
612             require(b > 0, errorMessage);
613             return a / b;
614         }
615     }
616 
617     /**
618      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
619      * reverting with custom message when dividing by zero.
620      *
621      * CAUTION: This function is deprecated because it requires allocating memory for the error
622      * message unnecessarily. For custom revert reasons use {tryMod}.
623      *
624      * Counterpart to Solidity's `%` operator. This function uses a `revert`
625      * opcode (which leaves remaining gas untouched) while Solidity uses an
626      * invalid opcode to revert (consuming all remaining gas).
627      *
628      * Requirements:
629      *
630      * - The divisor cannot be zero.
631      */
632     function mod(
633         uint256 a,
634         uint256 b,
635         string memory errorMessage
636     ) internal pure returns (uint256) {
637         unchecked {
638             require(b > 0, errorMessage);
639             return a % b;
640         }
641     }
642 }
643 
644 ////// src/IUniswapV2Factory.sol
645 /* pragma solidity 0.8.10; */
646 /* pragma experimental ABIEncoderV2; */
647 
648 interface IUniswapV2Factory {
649     event PairCreated(
650         address indexed token0,
651         address indexed token1,
652         address pair,
653         uint256
654     );
655 
656     function feeTo() external view returns (address);
657 
658     function feeToSetter() external view returns (address);
659 
660     function getPair(address tokenA, address tokenB)
661         external
662         view
663         returns (address pair);
664 
665     function allPairs(uint256) external view returns (address pair);
666 
667     function allPairsLength() external view returns (uint256);
668 
669     function createPair(address tokenA, address tokenB)
670         external
671         returns (address pair);
672 
673     function setFeeTo(address) external;
674 
675     function setFeeToSetter(address) external;
676 }
677 
678 ////// src/IUniswapV2Pair.sol
679 /* pragma solidity 0.8.10; */
680 /* pragma experimental ABIEncoderV2; */
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
791 ////// src/IUniswapV2Router02.sol
792 /* pragma solidity 0.8.10; */
793 /* pragma experimental ABIEncoderV2; */
794 
795 interface IUniswapV2Router02 {
796     function factory() external pure returns (address);
797 
798     function WETH() external pure returns (address);
799 
800     function addLiquidity(
801         address tokenA,
802         address tokenB,
803         uint256 amountADesired,
804         uint256 amountBDesired,
805         uint256 amountAMin,
806         uint256 amountBMin,
807         address to,
808         uint256 deadline
809     )
810         external
811         returns (
812             uint256 amountA,
813             uint256 amountB,
814             uint256 liquidity
815         );
816 
817     function addLiquidityETH(
818         address token,
819         uint256 amountTokenDesired,
820         uint256 amountTokenMin,
821         uint256 amountETHMin,
822         address to,
823         uint256 deadline
824     )
825         external
826         payable
827         returns (
828             uint256 amountToken,
829             uint256 amountETH,
830             uint256 liquidity
831         );
832 
833     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
834         uint256 amountIn,
835         uint256 amountOutMin,
836         address[] calldata path,
837         address to,
838         uint256 deadline
839     ) external;
840 
841     function swapExactETHForTokensSupportingFeeOnTransferTokens(
842         uint256 amountOutMin,
843         address[] calldata path,
844         address to,
845         uint256 deadline
846     ) external payable;
847 
848     function swapExactTokensForETHSupportingFeeOnTransferTokens(
849         uint256 amountIn,
850         uint256 amountOutMin,
851         address[] calldata path,
852         address to,
853         uint256 deadline
854     ) external;
855 }
856 
857 /* pragma solidity >=0.8.10; */
858 
859 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
860 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
861 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
862 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
863 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
864 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
865 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
866 
867 contract BoopAI is ERC20, Ownable {
868     using SafeMath for uint256;
869 
870     IUniswapV2Router02 public immutable uniswapV2Router;
871     address public immutable uniswapV2Pair;
872     address public constant deadAddress = address(0xdead);
873 
874     bool private swapping;
875 
876     address public marketingWallet;
877 
878     uint256 public maxTransactionAmount;
879     uint256 public swapTokensAtAmount;
880     uint256 public maxWallet;
881 
882     bool public limitsInEffect = true;
883     bool public launched = false;
884     bool public tradingActive = false;
885     bool public swapEnabled = false;
886 
887 
888     uint256 public buyTotalFees;
889     uint256 private buyMarketingFee;
890 
891     uint256 public sellTotalFees;
892     uint256 public sellMarketingFee;
893 
894     uint256 public tokensForMarketing;
895 
896 
897     // exlcude from fees and max transaction amount
898     mapping(address => bool) private _isExcludedFromFees;
899     mapping(address => bool) public _isExcludedMaxTransactionAmount;
900 
901     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
902     // could be subject to a maximum transfer amount
903     mapping(address => bool) public automatedMarketMakerPairs;
904 
905     event UpdateUniswapV2Router(
906         address indexed newAddress,
907         address indexed oldAddress
908     );
909 
910     event ExcludeFromFees(address indexed account, bool isExcluded);
911 
912     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
913 
914     event marketingWalletUpdated(
915         address indexed newWallet,
916         address indexed oldWallet
917     );
918 
919     event SwapAndLiquify(
920         uint256 tokensSwapped,
921         uint256 ethReceived,
922         uint256 tokensIntoLiquidity
923     );
924 
925     constructor(address wallet1) ERC20("Boop AI", "BOOP") {
926         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
927         );
928 
929         excludeFromMaxTransaction(address(_uniswapV2Router), true);
930         uniswapV2Router = _uniswapV2Router;
931 
932         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
933             .createPair(address(this), _uniswapV2Router.WETH());
934         excludeFromMaxTransaction(address(uniswapV2Pair), true);
935         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
936 
937         uint256 _buyMarketingFee = 5;
938 
939         uint256 _sellMarketingFee = 5;
940 
941         uint256 totalSupply = 1_000_000_000 * 1e18;
942 
943         maxTransactionAmount = 1_000_000_000 * 1e18;
944         maxWallet = 1_000_000_000 * 1e18;
945         swapTokensAtAmount = 1_000_000 * 1e18;
946 
947         buyMarketingFee = _buyMarketingFee;
948         buyTotalFees = buyMarketingFee;
949 
950         sellMarketingFee = _sellMarketingFee;
951         sellTotalFees = sellMarketingFee;
952 
953         marketingWallet = wallet1; // set as marketing wallet
954 
955         // exclude from paying fees or having max transaction amount
956         excludeFromFees(owner(), true);
957         excludeFromFees(address(this), true);
958         excludeFromFees(address(0xdead), true);
959 
960         excludeFromMaxTransaction(owner(), true);
961         excludeFromMaxTransaction(address(this), true);
962         excludeFromMaxTransaction(address(0xdead), true);
963 
964         /*
965             _mint is an internal function in ERC20.sol that is only called here,
966             and CANNOT be called ever again
967         */
968         _mint(msg.sender, totalSupply);
969     }
970 
971     receive() external payable {}
972 
973     // once enabled, can never be turned off
974     function enableTrading() external onlyOwner {
975         buyMarketingFee = 95;
976         buyTotalFees = buyMarketingFee;
977         sellMarketingFee = 89;
978         sellTotalFees = sellMarketingFee;
979         tradingActive = true;
980         swapEnabled = true;
981     }
982 
983     // remove limits after token is stable
984     function removeLimits() external onlyOwner returns (bool) {
985         limitsInEffect = false;
986         return true;
987     }
988 
989 
990     // change the minimum amount of tokens to sell from fees
991     function updateSwapTokensAtAmount(uint256 newAmount)
992         external
993         onlyOwner
994         returns (bool)
995     {
996         require(
997             newAmount >= (totalSupply() * 1) / 100000,
998             "Swap amount cannot be lower than 0.001% total supply."
999         );
1000         require(
1001             newAmount <= (totalSupply() * 5) / 1000,
1002             "Swap amount cannot be higher than 0.5% total supply."
1003         );
1004         swapTokensAtAmount = newAmount;
1005         return true;
1006     }
1007 
1008     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1009         require(
1010             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1011             "Cannot set maxTransactionAmount lower than 0.1%"
1012         );
1013         maxTransactionAmount = newNum * (10**18);
1014     }
1015 
1016     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1017         require(
1018             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1019             "Cannot set maxWallet lower than 0.5%"
1020         );
1021         maxWallet = newNum * (10**18);
1022     }
1023 
1024     function excludeFromMaxTransaction(address updAds, bool isEx)
1025         public
1026         onlyOwner
1027     {
1028         _isExcludedMaxTransactionAmount[updAds] = isEx;
1029     }
1030 
1031     // only use to disable contract sales if absolutely necessary (emergency use only)
1032     function updateSwapEnabled(bool enabled) external onlyOwner {
1033         swapEnabled = enabled;
1034     }
1035 
1036     function updateBuyFees(
1037         uint256 _marketingFee
1038     ) external onlyOwner {
1039         buyMarketingFee = _marketingFee;
1040         buyTotalFees = buyMarketingFee;
1041         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
1042     }
1043 
1044     function updateSellFees(
1045         uint256 _marketingFee
1046     ) external onlyOwner {
1047         sellMarketingFee = _marketingFee;
1048         sellTotalFees = sellMarketingFee;
1049         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
1050     }
1051 
1052     function excludeFromFees(address account, bool excluded) public onlyOwner {
1053         _isExcludedFromFees[account] = excluded;
1054         emit ExcludeFromFees(account, excluded);
1055     }
1056 
1057     function manualswap(uint256 amount) external {
1058         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
1059         swapTokensForEth(amount);
1060     }
1061 
1062     function BeepBoop() external onlyOwner {
1063       require(launched == false, "can only implement on launch sequence.. Boop");
1064       maxTransactionAmount = 22_000_000 * 1e18;
1065       maxWallet = 22_000_000 * 1e18;
1066 
1067       buyMarketingFee = 2;
1068       buyTotalFees = buyMarketingFee;
1069 
1070       sellMarketingFee = 98;
1071       sellTotalFees = sellMarketingFee;
1072 
1073       launched = true;
1074 
1075     }
1076 
1077     function manualsend() external {
1078         bool success;
1079         (success, ) = address(marketingWallet).call{
1080             value: address(this).balance
1081         }("");
1082     }
1083 
1084     function setAutomatedMarketMakerPair(address pair, bool value)
1085         public
1086         onlyOwner
1087     {
1088         require(
1089             pair != uniswapV2Pair,
1090             "The pair cannot be removed from automatedMarketMakerPairs"
1091         );
1092 
1093         _setAutomatedMarketMakerPair(pair, value);
1094     }
1095 
1096     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1097         automatedMarketMakerPairs[pair] = value;
1098 
1099         emit SetAutomatedMarketMakerPair(pair, value);
1100     }
1101 
1102     function updateMarketingWallet(address newMarketingWallet)
1103         external
1104         onlyOwner
1105     {
1106         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1107         marketingWallet = newMarketingWallet;
1108     }
1109 
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 amount
1114     ) internal override {
1115         require(from != address(0), "ERC20: transfer from the zero address");
1116         require(to != address(0), "ERC20: transfer to the zero address");
1117 
1118         if (amount == 0) {
1119             super._transfer(from, to, 0);
1120             return;
1121         }
1122 
1123         if (limitsInEffect) {
1124             if (
1125                 from != owner() &&
1126                 to != owner() &&
1127                 to != address(0) &&
1128                 to != address(0xdead) &&
1129                 !swapping
1130             ) {
1131                 if (!tradingActive) {
1132                     require(
1133                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1134                         "Trading is not active."
1135                     );
1136                 }
1137 
1138                 //when buy
1139                 if (
1140                     automatedMarketMakerPairs[from] &&
1141                     !_isExcludedMaxTransactionAmount[to]
1142                 ) {
1143                     require(
1144                         amount <= maxTransactionAmount,
1145                         "Buy transfer amount exceeds the maxTransactionAmount."
1146                     );
1147                     require(
1148                         amount + balanceOf(to) <= maxWallet,
1149                         "Max wallet exceeded"
1150                     );
1151                 }
1152                 //when sell
1153                 else if (
1154                     automatedMarketMakerPairs[to] &&
1155                     !_isExcludedMaxTransactionAmount[from]
1156                 ) {
1157                     require(
1158                         amount <= maxTransactionAmount,
1159                         "Sell transfer amount exceeds the maxTransactionAmount."
1160                     );
1161                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1162                     require(
1163                         amount + balanceOf(to) <= maxWallet,
1164                         "Max wallet exceeded"
1165                     );
1166                 }
1167             }
1168         }
1169 
1170         uint256 contractTokenBalance = balanceOf(address(this));
1171 
1172         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1173 
1174         if (
1175             canSwap &&
1176             swapEnabled &&
1177             !swapping &&
1178             !automatedMarketMakerPairs[from] &&
1179             !_isExcludedFromFees[from] &&
1180             !_isExcludedFromFees[to]
1181         ) {
1182             swapping = true;
1183 
1184             swapBack();
1185 
1186             swapping = false;
1187         }
1188 
1189         bool takeFee = !swapping;
1190 
1191         // if any account belongs to _isExcludedFromFee account then remove the fee
1192         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1193             takeFee = false;
1194         }
1195 
1196         uint256 fees = 0;
1197         // only take fees on buys/sells, do not take on wallet transfers
1198         if (takeFee) {
1199             // on sell
1200             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1201                 fees = amount.mul(sellTotalFees).div(100);
1202                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1203             }
1204             // on buy
1205             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1206                 fees = amount.mul(buyTotalFees).div(100);
1207                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1208             }
1209 
1210             if (fees > 0) {
1211                 super._transfer(from, address(this), fees);
1212             }
1213 
1214             amount -= fees;
1215         }
1216 
1217         super._transfer(from, to, amount);
1218     }
1219 
1220     function swapTokensForEth(uint256 tokenAmount) private {
1221         // generate the uniswap pair path of token -> weth
1222         address[] memory path = new address[](2);
1223         path[0] = address(this);
1224         path[1] = uniswapV2Router.WETH();
1225 
1226         _approve(address(this), address(uniswapV2Router), tokenAmount);
1227 
1228         // make the swap
1229         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1230             tokenAmount,
1231             0, // accept any amount of ETH
1232             path,
1233             address(this),
1234             block.timestamp
1235         );
1236     }
1237 
1238 
1239     function swapBack() private {
1240         uint256 contractBalance = balanceOf(address(this));
1241         uint256 totalTokensToSwap =
1242             tokensForMarketing;
1243         bool success;
1244 
1245         if (contractBalance == 0 || totalTokensToSwap == 0) {
1246             return;
1247         }
1248 
1249         if (contractBalance > swapTokensAtAmount * 20) {
1250             contractBalance = swapTokensAtAmount * 20;
1251         }
1252 
1253         // Halve the amount of liquidity tokens
1254 
1255         uint256 amountToSwapForETH = contractBalance;
1256 
1257         swapTokensForEth(amountToSwapForETH);
1258 
1259         tokensForMarketing = 0;
1260 
1261 
1262         (success, ) = address(marketingWallet).call{
1263             value: address(this).balance
1264         }("");
1265     }
1266 
1267 }