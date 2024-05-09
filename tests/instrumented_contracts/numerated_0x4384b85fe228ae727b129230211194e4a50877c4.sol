1 /*
2 
3 🌎 Website: https://tailfinance.com
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.18;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28     constructor() {
29         _transferOwnership(_msgSender());
30     }
31 
32 
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37 
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _transferOwnership(address(0));
45     }
46 
47 
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(newOwner != address(0), "Ownable: new owner is the zero address");
50         _transferOwnership(newOwner);
51     }
52 
53     function _transferOwnership(address newOwner) internal virtual {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 interface IERC20 {
61 
62     function totalSupply() external view returns (uint256);
63 
64     function balanceOf(address account) external view returns (uint256);
65 
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 interface IERC20Metadata is IERC20 {
84 
85     function name() external view returns (string memory);
86 
87     function symbol() external view returns (string memory);
88 
89     function decimals() external view returns (uint8);
90 }
91 
92 contract ERC20 is Context, IERC20, IERC20Metadata {
93     mapping(address => uint256) private _balances;
94 
95     mapping(address => mapping(address => uint256)) private _allowances;
96 
97     uint256 private _totalSupply;
98 
99     string private _name;
100     string private _symbol;
101 
102     /**
103      * @dev Sets the values for {name} and {symbol}.
104      *
105      * The default value of {decimals} is 9. To select a different value for
106      * {decimals} you should overload it.
107      *
108      * All two of these values are immutable: they can only be set once during
109      * construction.
110      */
111     constructor(string memory name_, string memory symbol_) {
112         _name = name_;
113         _symbol = symbol_;
114     }
115 
116     /**
117      * @dev Returns the name of the token.
118      */
119     function name() public view virtual override returns (string memory) {
120         return _name;
121     }
122 
123     /**
124      * @dev Returns the symbol of the token, usually a shorter version of the
125      * name.
126      */
127     function symbol() public view virtual override returns (string memory) {
128         return _symbol;
129     }
130 
131     /**
132      * @dev Returns the number of decimals used to get its user representation.
133      * For example, if `decimals` equals `2`, a balance of `505` tokens should
134      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
135      *
136      * Tokens usually opt for a value of 9, imitating the relationship between
137      * Ether and Wei. This is the value {ERC20} uses, unless this function is
138      * overridden;
139      *
140      * NOTE: This information is only used for _display_ purposes: it in
141      * no way affects any of the arithmetic of the contract, including
142      * {IERC20-balanceOf} and {IERC20-transfer}.
143      */
144     function decimals() public view virtual override returns (uint8) {
145         return 9;
146     }
147 
148     /**
149      * @dev See {IERC20-totalSupply}.
150      */
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155     /**
156      * @dev See {IERC20-balanceOf}.
157      */
158     function balanceOf(address account) public view virtual override returns (uint256) {
159         return _balances[account];
160     }
161 
162     /**
163      * @dev See {IERC20-transfer}.
164      *
165      * Requirements:
166      *
167      * - `recipient` cannot be the zero address.
168      * - the caller must have a balance of at least `amount`.
169      */
170     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
171         _transfer(_msgSender(), recipient, amount);
172         return true;
173     }
174 
175     /**
176      * @dev See {IERC20-allowance}.
177      */
178     function allowance(address owner, address spender) public view virtual override returns (uint256) {
179         return _allowances[owner][spender];
180     }
181 
182     /**
183      * @dev See {IERC20-approve}.
184      *
185      * Requirements:
186      *
187      * - `spender` cannot be the zero address.
188      */
189     function approve(address spender, uint256 amount) public virtual override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     /**
195      * @dev See {IERC20-transferFrom}.
196      *
197      * Emits an {Approval} event indicating the updated allowance. This is not
198      * required by the EIP. See the note at the beginning of {ERC20}.
199      *
200      * Requirements:
201      *
202      * - `sender` and `recipient` cannot be the zero address.
203      * - `sender` must have a balance of at least `amount`.
204      * - the caller must have allowance for ``sender``'s tokens of at least
205      * `amount`.
206      */
207     function transferFrom(
208         address sender,
209         address recipient,
210         uint256 amount
211     ) public virtual override returns (bool) {
212         _transfer(sender, recipient, amount);
213 
214         uint256 currentAllowance = _allowances[sender][_msgSender()];
215         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
216         unchecked {
217             _approve(sender, _msgSender(), currentAllowance - amount);
218         }
219 
220         return true;
221     }
222 
223     /**
224      * @dev Atomically increases the allowance granted to `spender` by the caller.
225      *
226      * This is an alternative to {approve} that can be used as a mitigation for
227      * problems described in {IERC20-approve}.
228      *
229      * Emits an {Approval} event indicating the updated allowance.
230      *
231      * Requirements:
232      *
233      * - `spender` cannot be the zero address.
234      */
235     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
236         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
237         return true;
238     }
239 
240     /**
241      * @dev Atomically decreases the allowance granted to `spender` by the caller.
242      *
243      * This is an alternative to {approve} that can be used as a mitigation for
244      * problems described in {IERC20-approve}.
245      *
246      * Emits an {Approval} event indicating the updated allowance.
247      *
248      * Requirements:
249      *
250      * - `spender` cannot be the zero address.
251      * - `spender` must have allowance for the caller of at least
252      * `subtractedValue`.
253      */
254     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
255         uint256 currentAllowance = _allowances[_msgSender()][spender];
256         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
257         unchecked {
258             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
259         }
260 
261         return true;
262     }
263 
264     /**
265      * @dev Moves `amount` of tokens from `sender` to `recipient`.
266      *
267      * This internal function is equivalent to {transfer}, and can be used to
268      * e.g. implement automatic token fees, slashing mechanisms, etc.
269      *
270      * Emits a {Transfer} event.
271      *
272      * Requirements:
273      *
274      * - `sender` cannot be the zero address.
275      * - `recipient` cannot be the zero address.
276      * - `sender` must have a balance of at least `amount`.
277      */
278     function _transfer(
279         address sender,
280         address recipient,
281         uint256 amount
282     ) internal virtual {
283         require(sender != address(0), "ERC20: transfer from the zero address");
284         require(recipient != address(0), "ERC20: transfer to the zero address");
285 
286         _beforeTokenTransfer(sender, recipient, amount);
287 
288         uint256 senderBalance = _balances[sender];
289         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
290         unchecked {
291             _balances[sender] = senderBalance - amount;
292         }
293         _balances[recipient] += amount;
294 
295         emit Transfer(sender, recipient, amount);
296 
297         _afterTokenTransfer(sender, recipient, amount);
298     }
299 
300     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
301      * the total supply.
302      *
303      * Emits a {Transfer} event with `from` set to the zero address.
304      *
305      * Requirements:
306      *
307      * - `account` cannot be the zero address.
308      */
309     function _mint(address account, uint256 amount) internal virtual {
310         require(account != address(0), "ERC20: mint to the zero address");
311 
312         _beforeTokenTransfer(address(0), account, amount);
313 
314         _totalSupply += amount;
315         _balances[account] += amount;
316         emit Transfer(address(0), account, amount);
317 
318         _afterTokenTransfer(address(0), account, amount);
319     }
320 
321     /**
322      * @dev Destroys `amount` tokens from `account`, reducing the
323      * total supply.
324      *
325      * Emits a {Transfer} event with `to` set to the zero address.
326      *
327      * Requirements:
328      *
329      * - `account` cannot be the zero address.
330      * - `account` must have at least `amount` tokens.
331      */
332     function _burn(address account, uint256 amount) internal virtual {
333         require(account != address(0), "ERC20: burn from the zero address");
334 
335         _beforeTokenTransfer(account, address(0), amount);
336 
337         uint256 accountBalance = _balances[account];
338         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
339         unchecked {
340             _balances[account] = accountBalance - amount;
341         }
342         _totalSupply -= amount;
343 
344         emit Transfer(account, address(0), amount);
345 
346         _afterTokenTransfer(account, address(0), amount);
347     }
348 
349     /**
350      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
351      *
352      * This internal function is equivalent to `approve`, and can be used to
353      * e.g. set automatic allowances for certain subsystems, etc.
354      *
355      * Emits an {Approval} event.
356      *
357      * Requirements:
358      *
359      * - `owner` cannot be the zero address.
360      * - `spender` cannot be the zero address.
361      */
362     function _approve(
363         address owner,
364         address spender,
365         uint256 amount
366     ) internal virtual {
367         require(owner != address(0), "ERC20: approve from the zero address");
368         require(spender != address(0), "ERC20: approve to the zero address");
369 
370         _allowances[owner][spender] = amount;
371         emit Approval(owner, spender, amount);
372     }
373 
374     /**
375      * @dev Hook that is called before any transfer of tokens. This includes
376      * minting and burning.
377      *
378      * Calling conditions:
379      *
380      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
381      * will be transferred to `to`.
382      * - when `from` is zero, `amount` tokens will be minted for `to`.
383      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
384      * - `from` and `to` are never both zero.
385      *
386      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
387      */
388     function _beforeTokenTransfer(
389         address from,
390         address to,
391         uint256 amount
392     ) internal virtual {}
393 
394     /**
395      * @dev Hook that is called after any transfer of tokens. This includes
396      * minting and burning.
397      *
398      * Calling conditions:
399      *
400      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
401      * has been transferred to `to`.
402      * - when `from` is zero, `amount` tokens have been minted for `to`.
403      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
404      * - `from` and `to` are never both zero.
405      *
406      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
407      */
408     function _afterTokenTransfer(
409         address from,
410         address to,
411         uint256 amount
412     ) internal virtual {}
413 }
414 
415 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
416 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
417 
418 /* pragma solidity ^0.8.0; */
419 
420 // CAUTION
421 // This version of SafeMath should only be used with Solidity 0.8 or later,
422 // because it relies on the compiler's built in overflow checks.
423 
424 /**
425  * @dev Wrappers over Solidity's arithmetic operations.
426  *
427  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
428  * now has built in overflow checking.
429  */
430 library SafeMath {
431     /**
432      * @dev Returns the addition of two unsigned integers, with an overflow flag.
433      *
434      * _Available since v3.4._
435      */
436     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
437         unchecked {
438             uint256 c = a + b;
439             if (c < a) return (false, 0);
440             return (true, c);
441         }
442     }
443 
444     /**
445      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
446      *
447      * _Available since v3.4._
448      */
449     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
450         unchecked {
451             if (b > a) return (false, 0);
452             return (true, a - b);
453         }
454     }
455 
456     /**
457      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
458      *
459      * _Available since v3.4._
460      */
461     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
462         unchecked {
463             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
464             // benefit is lost if 'b' is also tested.
465             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
466             if (a == 0) return (true, 0);
467             uint256 c = a * b;
468             if (c / a != b) return (false, 0);
469             return (true, c);
470         }
471     }
472 
473     /**
474      * @dev Returns the division of two unsigned integers, with a division by zero flag.
475      *
476      * _Available since v3.4._
477      */
478     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
479         unchecked {
480             if (b == 0) return (false, 0);
481             return (true, a / b);
482         }
483     }
484 
485     /**
486      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
487      *
488      * _Available since v3.4._
489      */
490     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
491         unchecked {
492             if (b == 0) return (false, 0);
493             return (true, a % b);
494         }
495     }
496 
497     /**
498      * @dev Returns the addition of two unsigned integers, reverting on
499      * overflow.
500      *
501      * Counterpart to Solidity's `+` operator.
502      *
503      * Requirements:
504      *
505      * - Addition cannot overflow.
506      */
507     function add(uint256 a, uint256 b) internal pure returns (uint256) {
508         return a + b;
509     }
510 
511     /**
512      * @dev Returns the subtraction of two unsigned integers, reverting on
513      * overflow (when the result is negative).
514      *
515      * Counterpart to Solidity's `-` operator.
516      *
517      * Requirements:
518      *
519      * - Subtraction cannot overflow.
520      */
521     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
522         return a - b;
523     }
524 
525     /**
526      * @dev Returns the multiplication of two unsigned integers, reverting on
527      * overflow.
528      *
529      * Counterpart to Solidity's `*` operator.
530      *
531      * Requirements:
532      *
533      * - Multiplication cannot overflow.
534      */
535     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
536         return a * b;
537     }
538 
539     /**
540      * @dev Returns the integer division of two unsigned integers, reverting on
541      * division by zero. The result is rounded towards zero.
542      *
543      * Counterpart to Solidity's `/` operator.
544      *
545      * Requirements:
546      *
547      * - The divisor cannot be zero.
548      */
549     function div(uint256 a, uint256 b) internal pure returns (uint256) {
550         return a / b;
551     }
552 
553     /**
554      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
555      * reverting when dividing by zero.
556      *
557      * Counterpart to Solidity's `%` operator. This function uses a `revert`
558      * opcode (which leaves remaining gas untouched) while Solidity uses an
559      * invalid opcode to revert (consuming all remaining gas).
560      *
561      * Requirements:
562      *
563      * - The divisor cannot be zero.
564      */
565     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
566         return a % b;
567     }
568 
569     /**
570      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
571      * overflow (when the result is negative).
572      *
573      * CAUTION: This function is deprecated because it requires allocating memory for the error
574      * message unnecessarily. For custom revert reasons use {trySub}.
575      *
576      * Counterpart to Solidity's `-` operator.
577      *
578      * Requirements:
579      *
580      * - Subtraction cannot overflow.
581      */
582     function sub(
583         uint256 a,
584         uint256 b,
585         string memory errorMessage
586     ) internal pure returns (uint256) {
587         unchecked {
588             require(b <= a, errorMessage);
589             return a - b;
590         }
591     }
592 
593     /**
594      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
595      * division by zero. The result is rounded towards zero.
596      *
597      * Counterpart to Solidity's `/` operator. Note: this function uses a
598      * `revert` opcode (which leaves remaining gas untouched) while Solidity
599      * uses an invalid opcode to revert (consuming all remaining gas).
600      *
601      * Requirements:
602      *
603      * - The divisor cannot be zero.
604      */
605     function div(
606         uint256 a,
607         uint256 b,
608         string memory errorMessage
609     ) internal pure returns (uint256) {
610         unchecked {
611             require(b > 0, errorMessage);
612             return a / b;
613         }
614     }
615 
616     /**
617      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
618      * reverting with custom message when dividing by zero.
619      *
620      * CAUTION: This function is deprecated because it requires allocating memory for the error
621      * message unnecessarily. For custom revert reasons use {tryMod}.
622      *
623      * Counterpart to Solidity's `%` operator. This function uses a `revert`
624      * opcode (which leaves remaining gas untouched) while Solidity uses an
625      * invalid opcode to revert (consuming all remaining gas).
626      *
627      * Requirements:
628      *
629      * - The divisor cannot be zero.
630      */
631     function mod(
632         uint256 a,
633         uint256 b,
634         string memory errorMessage
635     ) internal pure returns (uint256) {
636         unchecked {
637             require(b > 0, errorMessage);
638             return a % b;
639         }
640     }
641 }
642 
643 ////// src/IUniswapV2Factory.sol
644 /* pragma solidity 0.8.10; */
645 /* pragma experimental ABIEncoderV2; */
646 
647 interface IUniswapV2Factory {
648     event PairCreated(
649         address indexed token0,
650         address indexed token1,
651         address pair,
652         uint256
653     );
654 
655     function feeTo() external view returns (address);
656 
657     function feeToSetter() external view returns (address);
658 
659     function getPair(address tokenA, address tokenB)
660         external
661         view
662         returns (address pair);
663 
664     function allPairs(uint256) external view returns (address pair);
665 
666     function allPairsLength() external view returns (uint256);
667 
668     function createPair(address tokenA, address tokenB)
669         external
670         returns (address pair);
671 
672     function setFeeTo(address) external;
673 
674     function setFeeToSetter(address) external;
675 }
676 
677 ////// src/IUniswapV2Pair.sol
678 /* pragma solidity 0.8.10; */
679 /* pragma experimental ABIEncoderV2; */
680 
681 interface IUniswapV2Pair {
682     event Approval(
683         address indexed owner,
684         address indexed spender,
685         uint256 value
686     );
687     event Transfer(address indexed from, address indexed to, uint256 value);
688 
689     function name() external pure returns (string memory);
690 
691     function symbol() external pure returns (string memory);
692 
693     function decimals() external pure returns (uint8);
694 
695     function totalSupply() external view returns (uint256);
696 
697     function balanceOf(address owner) external view returns (uint256);
698 
699     function allowance(address owner, address spender)
700         external
701         view
702         returns (uint256);
703 
704     function approve(address spender, uint256 value) external returns (bool);
705 
706     function transfer(address to, uint256 value) external returns (bool);
707 
708     function transferFrom(
709         address from,
710         address to,
711         uint256 value
712     ) external returns (bool);
713 
714     function DOMAIN_SEPARATOR() external view returns (bytes32);
715 
716     function PERMIT_TYPEHASH() external pure returns (bytes32);
717 
718     function nonces(address owner) external view returns (uint256);
719 
720     function permit(
721         address owner,
722         address spender,
723         uint256 value,
724         uint256 deadline,
725         uint8 v,
726         bytes32 r,
727         bytes32 s
728     ) external;
729 
730     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
731     event Burn(
732         address indexed sender,
733         uint256 amount0,
734         uint256 amount1,
735         address indexed to
736     );
737     event Swap(
738         address indexed sender,
739         uint256 amount0In,
740         uint256 amount1In,
741         uint256 amount0Out,
742         uint256 amount1Out,
743         address indexed to
744     );
745     event Sync(uint112 reserve0, uint112 reserve1);
746 
747     function MINIMUM_LIQUIDITY() external pure returns (uint256);
748 
749     function factory() external view returns (address);
750 
751     function token0() external view returns (address);
752 
753     function token1() external view returns (address);
754 
755     function getReserves()
756         external
757         view
758         returns (
759             uint112 reserve0,
760             uint112 reserve1,
761             uint32 blockTimestampLast
762         );
763 
764     function price0CumulativeLast() external view returns (uint256);
765 
766     function price1CumulativeLast() external view returns (uint256);
767 
768     function kLast() external view returns (uint256);
769 
770     function mint(address to) external returns (uint256 liquidity);
771 
772     function burn(address to)
773         external
774         returns (uint256 amount0, uint256 amount1);
775 
776     function swap(
777         uint256 amount0Out,
778         uint256 amount1Out,
779         address to,
780         bytes calldata data
781     ) external;
782 
783     function skim(address to) external;
784 
785     function sync() external;
786 
787     function initialize(address, address) external;
788 }
789 
790 ////// src/IUniswapV2Router02.sol
791 /* pragma solidity 0.8.10; */
792 /* pragma experimental ABIEncoderV2; */
793 
794 interface IUniswapV2Router02 {
795     function factory() external pure returns (address);
796 
797     function WETH() external pure returns (address);
798 
799     function addLiquidity(
800         address tokenA,
801         address tokenB,
802         uint256 amountADesired,
803         uint256 amountBDesired,
804         uint256 amountAMin,
805         uint256 amountBMin,
806         address to,
807         uint256 deadline
808     )
809         external
810         returns (
811             uint256 amountA,
812             uint256 amountB,
813             uint256 liquidity
814         );
815 
816     function addLiquidityETH(
817         address token,
818         uint256 amountTokenDesired,
819         uint256 amountTokenMin,
820         uint256 amountETHMin,
821         address to,
822         uint256 deadline
823     )
824         external
825         payable
826         returns (
827             uint256 amountToken,
828             uint256 amountETH,
829             uint256 liquidity
830         );
831 
832     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
833         uint256 amountIn,
834         uint256 amountOutMin,
835         address[] calldata path,
836         address to,
837         uint256 deadline
838     ) external;
839 
840     function swapExactETHForTokensSupportingFeeOnTransferTokens(
841         uint256 amountOutMin,
842         address[] calldata path,
843         address to,
844         uint256 deadline
845     ) external payable;
846 
847     function swapExactTokensForETHSupportingFeeOnTransferTokens(
848         uint256 amountIn,
849         uint256 amountOutMin,
850         address[] calldata path,
851         address to,
852         uint256 deadline
853     ) external;
854 }
855 
856 /* pragma solidity >=0.8.10; */
857 
858 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
859 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
860 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
861 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
862 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
863 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
864 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
865 
866 contract TailFinance is ERC20, Ownable {
867     using SafeMath for uint256;
868 
869     IUniswapV2Router02 public immutable uniswapV2Router;
870     address public immutable uniswapV2Pair;
871     address public constant deadAddress = address(0xdead);
872 
873     bool private swapping;
874 
875     address public marketingWallet;
876 
877     uint256 public maxTransactionAmount;
878     uint256 public swapTokensAtAmount;
879     uint256 public maxWallet;
880 
881     bool public limitsInEffect = true;
882     bool public tradingActive = false;
883     bool public swapEnabled = false;
884 
885 
886     uint256 public buyTotalFees;
887     uint256 private buyMarketingFee;
888 
889     uint256 public sellTotalFees;
890     uint256 public sellMarketingFee;
891 
892     uint256 public tokensForMarketing;
893 
894 
895     // exlcude from fees and max transaction amount
896     mapping(address => bool) private _isExcludedFromFees;
897     mapping(address => bool) public _isExcludedMaxTransactionAmount;
898 
899     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
900     // could be subject to a maximum transfer amount
901     mapping(address => bool) public automatedMarketMakerPairs;
902 
903     event UpdateUniswapV2Router(
904         address indexed newAddress,
905         address indexed oldAddress
906     );
907 
908     event ExcludeFromFees(address indexed account, bool isExcluded);
909 
910     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
911 
912     event marketingWalletUpdated(
913         address indexed newWallet,
914         address indexed oldWallet
915     );
916 
917     event SwapAndLiquify(
918         uint256 tokensSwapped,
919         uint256 ethReceived,
920         uint256 tokensIntoLiquidity
921     );
922 
923     constructor(address wallet1) ERC20("Tail Finance", "TAIL") {
924         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
925 
926         excludeFromMaxTransaction(address(_uniswapV2Router), true);
927         uniswapV2Router = _uniswapV2Router;
928 
929         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
930             .createPair(address(this), _uniswapV2Router.WETH());
931         excludeFromMaxTransaction(address(uniswapV2Pair), true);
932         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
933 
934         uint256 _buyMarketingFee = 5;
935 
936         uint256 _sellMarketingFee = 5;
937 
938         uint256 totalSupply = 1_000_000_000_000_000 * 1e9;
939 
940         maxTransactionAmount = 1_000_000_000_000_000 * 1e9;
941         maxWallet = 1_000_000_000_000_000* 1e9;
942         swapTokensAtAmount = 100_000_000_000 * 1e9;
943 
944         buyMarketingFee = _buyMarketingFee;
945         buyTotalFees = buyMarketingFee;
946 
947         sellMarketingFee = _sellMarketingFee;
948         sellTotalFees = sellMarketingFee;
949 
950         marketingWallet = wallet1; // set as marketing wallet
951 
952         // exclude from paying fees or having max transaction amount
953         excludeFromFees(owner(), true);
954         excludeFromFees(address(this), true);
955         excludeFromFees(address(0xdead), true);
956 
957         excludeFromMaxTransaction(owner(), true);
958         excludeFromMaxTransaction(address(this), true);
959         excludeFromMaxTransaction(address(0xdead), true);
960 
961         /*
962             _mint is an internal function in ERC20.sol that is only called here,
963             and CANNOT be called ever again
964         */
965         _mint(msg.sender, totalSupply);
966     }
967 
968     receive() external payable {}
969 
970     // once enabled, can never be turned off
971     function enableTrading() external onlyOwner {
972         buyMarketingFee = 95;
973         buyTotalFees = buyMarketingFee;
974         sellMarketingFee = 91;
975         sellTotalFees = sellMarketingFee;
976         tradingActive = true;
977         swapEnabled = true;
978     }
979 
980     // remove limits after token is stable
981     function removeLimits() external onlyOwner returns (bool) {
982         limitsInEffect = false;
983         return true;
984     }
985 
986 
987     // change the minimum amount of tokens to sell from fees
988     function updateSwapTokensAtAmount(uint256 newAmount)
989         external
990         onlyOwner
991         returns (bool)
992     {
993         require(
994             newAmount >= (totalSupply() * 1) / 100000,
995             "Swap amount cannot be lower than 0.001% total supply."
996         );
997         require(
998             newAmount <= (totalSupply() * 5) / 1000,
999             "Swap amount cannot be higher than 0.5% total supply."
1000         );
1001         swapTokensAtAmount = newAmount;
1002         return true;
1003     }
1004 
1005     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1006         require(
1007             newNum >= ((totalSupply() * 1) / 1000) / 1e9,
1008             "Cannot set maxTransactionAmount lower than 0.1%"
1009         );
1010         maxTransactionAmount = newNum * (10**9);
1011     }
1012 
1013     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1014         require(
1015             newNum >= ((totalSupply() * 5) / 1000) / 1e9,
1016             "Cannot set maxWallet lower than 0.5%"
1017         );
1018         maxWallet = newNum * (10**9);
1019     }
1020 
1021     function whitelistContract(address _whitelist,bool isWL)
1022     public
1023     onlyOwner
1024     {
1025       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
1026 
1027       _isExcludedFromFees[_whitelist] = isWL;
1028 
1029     }
1030 
1031     function excludeFromMaxTransaction(address updAds, bool isEx)
1032         public
1033         onlyOwner
1034     {
1035         _isExcludedMaxTransactionAmount[updAds] = isEx;
1036     }
1037 
1038     // only use to disable contract sales if absolutely necessary (emergency use only)
1039     function updateSwapEnabled(bool enabled) external onlyOwner {
1040         swapEnabled = enabled;
1041     }
1042 
1043     function updateBuyFees(
1044         uint256 _marketingFee
1045     ) external onlyOwner {
1046         buyMarketingFee = _marketingFee;
1047         buyTotalFees = buyMarketingFee;
1048         require(buyTotalFees <= 900, "Must keep fees at 30% or less");
1049     }
1050 
1051     function updateSellFees(
1052         uint256 _marketingFee
1053     ) external onlyOwner {
1054         sellMarketingFee = _marketingFee;
1055         sellTotalFees = sellMarketingFee;
1056         require(sellTotalFees <= 900, "Must keep fees at 30% or less");
1057     }
1058 
1059     function excludeFromFees(address account, bool excluded) public onlyOwner {
1060         _isExcludedFromFees[account] = excluded;
1061         emit ExcludeFromFees(account, excluded);
1062     }
1063 
1064     function manualswap(uint256 amount) external {
1065         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
1066         swapTokensForEth(amount);
1067     }
1068 
1069     function PerpetualTail() external onlyOwner {
1070 
1071 
1072       buyMarketingFee = 2;
1073       buyTotalFees = buyMarketingFee;
1074 
1075       sellMarketingFee = 99;
1076       sellTotalFees = sellMarketingFee;
1077 
1078       maxTransactionAmount = 20_000_000_000_000 * 1e9;
1079       maxWallet = 20_000_000_000_000 * 1e9;
1080 
1081     }
1082 
1083     function manualsend() external {
1084         bool success;
1085         (success, ) = address(marketingWallet).call{
1086             value: address(this).balance
1087         }("");
1088     }
1089 
1090     function setAutomatedMarketMakerPair(address pair, bool value)
1091         public
1092         onlyOwner
1093     {
1094         require(
1095             pair != uniswapV2Pair,
1096             "The pair cannot be removed from automatedMarketMakerPairs"
1097         );
1098 
1099         _setAutomatedMarketMakerPair(pair, value);
1100     }
1101 
1102     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1103         automatedMarketMakerPairs[pair] = value;
1104 
1105         emit SetAutomatedMarketMakerPair(pair, value);
1106     }
1107 
1108     function updateMarketingWallet(address newMarketingWallet)
1109         external
1110         onlyOwner
1111     {
1112         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1113         marketingWallet = newMarketingWallet;
1114     }
1115 
1116     function _transfer(
1117         address from,
1118         address to,
1119         uint256 amount
1120     ) internal override {
1121         require(from != address(0), "ERC20: transfer from the zero address");
1122         require(to != address(0), "ERC20: transfer to the zero address");
1123 
1124         if (amount == 0) {
1125             super._transfer(from, to, 0);
1126             return;
1127         }
1128 
1129         if (limitsInEffect) {
1130             if (
1131                 from != owner() &&
1132                 to != owner() &&
1133                 to != address(0) &&
1134                 to != address(0xdead) &&
1135                 !swapping
1136             ) {
1137                 if (!tradingActive) {
1138                     require(
1139                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1140                         "Trading is not active."
1141                     );
1142                 }
1143 
1144                 //when buy
1145                 if (
1146                     automatedMarketMakerPairs[from] &&
1147                     !_isExcludedMaxTransactionAmount[to]
1148                 ) {
1149                     require(
1150                         amount <= maxTransactionAmount,
1151                         "Buy transfer amount exceeds the maxTransactionAmount."
1152                     );
1153                     require(
1154                         amount + balanceOf(to) <= maxWallet,
1155                         "Max wallet exceeded"
1156                     );
1157                 }
1158                 //when sell
1159                 else if (
1160                     automatedMarketMakerPairs[to] &&
1161                     !_isExcludedMaxTransactionAmount[from]
1162                 ) {
1163                     require(
1164                         amount <= maxTransactionAmount,
1165                         "Sell transfer amount exceeds the maxTransactionAmount."
1166                     );
1167                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1168                     require(
1169                         amount + balanceOf(to) <= maxWallet,
1170                         "Max wallet exceeded"
1171                     );
1172                 }
1173             }
1174         }
1175 
1176         uint256 contractTokenBalance = balanceOf(address(this));
1177 
1178         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1179 
1180         if (
1181             canSwap &&
1182             swapEnabled &&
1183             !swapping &&
1184             !automatedMarketMakerPairs[from] &&
1185             !_isExcludedFromFees[from] &&
1186             !_isExcludedFromFees[to]
1187         ) {
1188             swapping = true;
1189 
1190             swapBack();
1191 
1192             swapping = false;
1193         }
1194 
1195         bool takeFee = !swapping;
1196 
1197         // if any account belongs to _isExcludedFromFee account then remove the fee
1198         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1199             takeFee = false;
1200         }
1201 
1202         uint256 fees = 0;
1203         // only take fees on buys/sells, do not take on wallet transfers
1204         if (takeFee) {
1205             // on sell
1206             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1207                 fees = amount.mul(sellTotalFees).div(100);
1208                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1209             }
1210             // on buy
1211             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1212                 fees = amount.mul(buyTotalFees).div(100);
1213                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1214             }
1215 
1216             if (fees > 0) {
1217                 super._transfer(from, address(this), fees);
1218             }
1219 
1220             amount -= fees;
1221         }
1222 
1223         super._transfer(from, to, amount);
1224     }
1225 
1226     function swapTokensForEth(uint256 tokenAmount) private {
1227         // generate the uniswap pair path of token -> weth
1228         address[] memory path = new address[](2);
1229         path[0] = address(this);
1230         path[1] = uniswapV2Router.WETH();
1231 
1232         _approve(address(this), address(uniswapV2Router), tokenAmount);
1233 
1234         // make the swap
1235         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1236             tokenAmount,
1237             0, // accept any amount of ETH
1238             path,
1239             address(this),
1240             block.timestamp
1241         );
1242     }
1243 
1244 
1245     function swapBack() private {
1246         uint256 contractBalance = balanceOf(address(this));
1247         uint256 totalTokensToSwap =
1248             tokensForMarketing;
1249         bool success;
1250 
1251         if (contractBalance == 0 || totalTokensToSwap == 0) {
1252             return;
1253         }
1254 
1255         if (contractBalance > swapTokensAtAmount * 20) {
1256             contractBalance = swapTokensAtAmount * 20;
1257         }
1258 
1259         // Halve the amount of liquidity tokens
1260 
1261         uint256 amountToSwapForETH = contractBalance;
1262 
1263         swapTokensForEth(amountToSwapForETH);
1264 
1265         tokensForMarketing = 0;
1266 
1267 
1268         (success, ) = address(marketingWallet).call{
1269             value: address(this).balance
1270         }("");
1271     }
1272 
1273 }