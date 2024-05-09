1 /**
2 */
3 
4 /*
5  * Tyrant Temple
6  */
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
10 
11 interface IUniswapV2Factory {
12     function createPair(address tokenA, address tokenB)
13         external
14         returns (address pair);
15 }
16 
17 interface IUniswapV2Router01 {
18     function factory() external pure returns (address);
19 
20     function WETH() external pure returns (address);
21 
22     function addLiquidityETH(
23         address token,
24         uint256 amountTokenDesired,
25         uint256 amountTokenMin,
26         uint256 amountETHMin,
27         address to,
28         uint256 deadline
29     )
30         external
31         payable
32         returns (
33             uint256 amountToken,
34             uint256 amountETH,
35             uint256 liquidity
36         );
37 }
38 
39 interface IUniswapV2Router02 is IUniswapV2Router01 {
40     function swapExactTokensForETHSupportingFeeOnTransferTokens(
41         uint256 amountIn,
42         uint256 amountOutMin,
43         address[] calldata path,
44         address to,
45         uint256 deadline
46     ) external;
47 }
48 
49 interface IUniswapV2Pair {
50     function sync() external;
51 }
52 
53 /**
54  * @dev Provides information about the current execution context, including the
55  * sender of the transaction and its data. While these are generally available
56  * via msg.sender and msg.data, they should not be accessed in such a direct
57  * manner, since when dealing with meta-transactions the account sending and
58  * paying for execution may not be the actual sender (as far as an application
59  * is concerned).
60  *
61  * This contract is only required for intermediate, library-like contracts.
62  */
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 
68     function _msgData() internal view virtual returns (bytes calldata) {
69         return msg.data;
70     }
71 }
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(
89         address indexed previousOwner,
90         address indexed newOwner
91     );
92 
93     /**
94      * @dev Initializes the contract setting the deployer as the initial owner.
95      */
96     constructor() {
97         _transferOwnership(_msgSender());
98     }
99 
100     /**
101      * @dev Returns the address of the current owner.
102      */
103     function owner() public view virtual returns (address) {
104         return _owner;
105     }
106 
107     /**
108      * @dev Throws if called by any account other than the owner.
109      */
110     modifier onlyOwner() {
111         require(owner() == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     /**
116      * @dev Leaves the contract without owner. It will not be possible to call
117      * `onlyOwner` functions anymore. Can only be called by the current owner.
118      *
119      * NOTE: Renouncing ownership will leave the contract without an owner,
120      * thereby removing any functionality that is only available to the owner.
121      */
122     function renounceOwnership() public virtual onlyOwner {
123         _transferOwnership(address(0));
124     }
125 
126     /**
127      * @dev Transfers ownership of the contract to a new account (`newOwner`).
128      * Can only be called by the current owner.
129      */
130     function transferOwnership(address newOwner) public virtual onlyOwner {
131         require(
132             newOwner != address(0),
133             "Ownable: new owner is the zero address"
134         );
135         _transferOwnership(newOwner);
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      * Internal function without access restriction.
141      */
142     function _transferOwnership(address newOwner) internal virtual {
143         address oldOwner = _owner;
144         _owner = newOwner;
145         emit OwnershipTransferred(oldOwner, newOwner);
146     }
147 }
148 
149 /**
150  * @dev Interface of the ERC20 standard as defined in the EIP.
151  */
152 interface IERC20 {
153     /**
154      * @dev Returns the amount of tokens in existence.
155      */
156     function totalSupply() external view returns (uint256);
157 
158     /**
159      * @dev Returns the amount of tokens owned by `account`.
160      */
161     function balanceOf(address account) external view returns (uint256);
162 
163     /**
164      * @dev Moves `amount` tokens from the caller's account to `recipient`.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transfer(address recipient, uint256 amount)
171         external
172         returns (bool);
173 
174     /**
175      * @dev Returns the remaining number of tokens that `spender` will be
176      * allowed to spend on behalf of `owner` through {transferFrom}. This is
177      * zero by default.
178      *
179      * This value changes when {approve} or {transferFrom} are called.
180      */
181     function allowance(address owner, address spender)
182         external
183         view
184         returns (uint256);
185 
186     /**
187      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * IMPORTANT: Beware that changing an allowance with this method brings the risk
192      * that someone may use both the old and the new allowance by unfortunate
193      * transaction ordering. One possible solution to mitigate this race
194      * condition is to first reduce the spender's allowance to 0 and set the
195      * desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address spender, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Moves `amount` tokens from `sender` to `recipient` using the
204      * allowance mechanism. `amount` is then deducted from the caller's
205      * allowance.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address sender,
213         address recipient,
214         uint256 amount
215     ) external returns (bool);
216 
217     /**
218      * @dev Emitted when `value` tokens are moved from one account (`from`) to
219      * another (`to`).
220      *
221      * Note that `value` may be zero.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 value);
224 
225     /**
226      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
227      * a call to {approve}. `value` is the new allowance.
228      */
229     event Approval(
230         address indexed owner,
231         address indexed spender,
232         uint256 value
233     );
234 }
235 
236 /**
237  * @dev Interface for the optional metadata functions from the ERC20 standard.
238  *
239  * _Available since v4.1._
240  */
241 interface IERC20Metadata is IERC20 {
242     /**
243      * @dev Returns the name of the token.
244      */
245     function name() external view returns (string memory);
246 
247     /**
248      * @dev Returns the symbol of the token.
249      */
250     function symbol() external view returns (string memory);
251 
252     /**
253      * @dev Returns the decimals places of the token.
254      */
255     function decimals() external view returns (uint8);
256 }
257 
258 /**
259  * @dev Implementation of the {IERC20} interface.
260  *
261  * This implementation is agnostic to the way tokens are created. This means
262  * that a supply mechanism has to be added in a derived contract using {_mint}.
263  * For a generic mechanism see {ERC20PresetMinterPauser}.
264  *
265  * TIP: For a detailed writeup see our guide
266  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
267  * to implement supply mechanisms].
268  *
269  * We have followed general OpenZeppelin Contracts guidelines: functions revert
270  * instead returning `false` on failure. This behavior is nonetheless
271  * conventional and does not conflict with the expectations of ERC20
272  * applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20, IERC20Metadata {
284     mapping(address => uint256) private _balances;
285 
286     mapping(address => mapping(address => uint256)) private _allowances;
287 
288     uint256 private _totalSupply;
289 
290     string private _name;
291     string private _symbol;
292 
293     /**
294      * @dev Sets the values for {name} and {symbol}.
295      *
296      * The default value of {decimals} is 18. To select a different value for
297      * {decimals} you should overload it.
298      *
299      * All two of these values are immutable: they can only be set once during
300      * construction.
301      */
302     constructor(string memory name_, string memory symbol_) {
303         _name = name_;
304         _symbol = symbol_;
305     }
306 
307     /**
308      * @dev Returns the name of the token.
309      */
310     function name() public view virtual override returns (string memory) {
311         return _name;
312     }
313 
314     /**
315      * @dev Returns the symbol of the token, usually a shorter version of the
316      * name.
317      */
318     function symbol() public view virtual override returns (string memory) {
319         return _symbol;
320     }
321 
322     /**
323      * @dev Returns the number of decimals used to get its user representation.
324      * For example, if `decimals` equals `2`, a balance of `505` tokens should
325      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
326      *
327      * Tokens usually opt for a value of 18, imitating the relationship between
328      * Ether and Wei. This is the value {ERC20} uses, unless this function is
329      * overridden;
330      *
331      * NOTE: This information is only used for _display_ purposes: it in
332      * no way affects any of the arithmetic of the contract, including
333      * {IERC20-balanceOf} and {IERC20-transfer}.
334      */
335     function decimals() public view virtual override returns (uint8) {
336         return 18;
337     }
338 
339     /**
340      * @dev See {IERC20-totalSupply}.
341      */
342     function totalSupply() public view virtual override returns (uint256) {
343         return _totalSupply;
344     }
345 
346     /**
347      * @dev See {IERC20-balanceOf}.
348      */
349     function balanceOf(address account)
350         public
351         view
352         virtual
353         override
354         returns (uint256)
355     {
356         return _balances[account];
357     }
358 
359     /**
360      * @dev See {IERC20-transfer}.
361      *
362      * Requirements:
363      *
364      * - `recipient` cannot be the zero address.
365      * - the caller must have a balance of at least `amount`.
366      */
367     function transfer(address recipient, uint256 amount)
368         public
369         virtual
370         override
371         returns (bool)
372     {
373         _transfer(_msgSender(), recipient, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-allowance}.
379      */
380     function allowance(address owner, address spender)
381         public
382         view
383         virtual
384         override
385         returns (uint256)
386     {
387         return _allowances[owner][spender];
388     }
389 
390     /**
391      * @dev See {IERC20-approve}.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function approve(address spender, uint256 amount)
398         public
399         virtual
400         override
401         returns (bool)
402     {
403         _approve(_msgSender(), spender, amount);
404         return true;
405     }
406 
407     /**
408      * @dev See {IERC20-transferFrom}.
409      *
410      * Emits an {Approval} event indicating the updated allowance. This is not
411      * required by the EIP. See the note at the beginning of {ERC20}.
412      *
413      * Requirements:
414      *
415      * - `sender` and `recipient` cannot be the zero address.
416      * - `sender` must have a balance of at least `amount`.
417      * - the caller must have allowance for ``sender``'s tokens of at least
418      * `amount`.
419      */
420     function transferFrom(
421         address sender,
422         address recipient,
423         uint256 amount
424     ) public virtual override returns (bool) {
425         _transfer(sender, recipient, amount);
426 
427         uint256 currentAllowance = _allowances[sender][_msgSender()];
428         require(
429             currentAllowance >= amount,
430             "ERC20: transfer amount exceeds allowance"
431         );
432         unchecked {
433             _approve(sender, _msgSender(), currentAllowance - amount);
434         }
435 
436         return true;
437     }
438 
439     /**
440      * @dev Atomically increases the allowance granted to `spender` by the caller.
441      *
442      * This is an alternative to {approve} that can be used as a mitigation for
443      * problems described in {IERC20-approve}.
444      *
445      * Emits an {Approval} event indicating the updated allowance.
446      *
447      * Requirements:
448      *
449      * - `spender` cannot be the zero address.
450      */
451     function increaseAllowance(address spender, uint256 addedValue)
452         public
453         virtual
454         returns (bool)
455     {
456         _approve(
457             _msgSender(),
458             spender,
459             _allowances[_msgSender()][spender] + addedValue
460         );
461         return true;
462     }
463 
464     /**
465      * @dev Atomically decreases the allowance granted to `spender` by the caller.
466      *
467      * This is an alternative to {approve} that can be used as a mitigation for
468      * problems described in {IERC20-approve}.
469      *
470      * Emits an {Approval} event indicating the updated allowance.
471      *
472      * Requirements:
473      *
474      * - `spender` cannot be the zero address.
475      * - `spender` must have allowance for the caller of at least
476      * `subtractedValue`.
477      */
478     function decreaseAllowance(address spender, uint256 subtractedValue)
479         public
480         virtual
481         returns (bool)
482     {
483         uint256 currentAllowance = _allowances[_msgSender()][spender];
484         require(
485             currentAllowance >= subtractedValue,
486             "ERC20: decreased allowance below zero"
487         );
488         unchecked {
489             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
490         }
491 
492         return true;
493     }
494 
495     /**
496      * @dev Moves `amount` of tokens from `sender` to `recipient`.
497      *
498      * This internal function is equivalent to {transfer}, and can be used to
499      * e.g. implement automatic token fees, slashing mechanisms, etc.
500      *
501      * Emits a {Transfer} event.
502      *
503      * Requirements:
504      *
505      * - `sender` cannot be the zero address.
506      * - `recipient` cannot be the zero address.
507      * - `sender` must have a balance of at least `amount`.
508      */
509     function _transfer(
510         address sender,
511         address recipient,
512         uint256 amount
513     ) internal virtual {
514         require(sender != address(0), "ERC20: transfer from the zero address");
515         require(recipient != address(0), "ERC20: transfer to the zero address");
516 
517         _beforeTokenTransfer(sender, recipient, amount);
518 
519         uint256 senderBalance = _balances[sender];
520         require(
521             senderBalance >= amount,
522             "ERC20: transfer amount exceeds balance"
523         );
524         unchecked {
525             _balances[sender] = senderBalance - amount;
526         }
527         _balances[recipient] += amount;
528 
529         emit Transfer(sender, recipient, amount);
530 
531         _afterTokenTransfer(sender, recipient, amount);
532     }
533 
534     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
535      * the total supply.
536      *
537      * Emits a {Transfer} event with `from` set to the zero address.
538      *
539      * Requirements:
540      *
541      * - `account` cannot be the zero address.
542      */
543     function _mint(address account, uint256 amount) internal virtual {
544         require(account != address(0), "ERC20: mint to the zero address");
545 
546         _beforeTokenTransfer(address(0), account, amount);
547 
548         _totalSupply += amount;
549         _balances[account] += amount;
550         emit Transfer(address(0), account, amount);
551 
552         _afterTokenTransfer(address(0), account, amount);
553     }
554 
555     /**
556      * @dev Destroys `amount` tokens from `account`, reducing the
557      * total supply.
558      *
559      * Emits a {Transfer} event with `to` set to the zero address.
560      *
561      * Requirements:
562      *
563      * - `account` cannot be the zero address.
564      * - `account` must have at least `amount` tokens.
565      */
566     function _burn(address account, uint256 amount) internal virtual {
567         require(account != address(0), "ERC20: burn from the zero address");
568 
569         _beforeTokenTransfer(account, address(0), amount);
570 
571         uint256 accountBalance = _balances[account];
572         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
573         unchecked {
574             _balances[account] = accountBalance - amount;
575         }
576         _totalSupply -= amount;
577 
578         emit Transfer(account, address(0), amount);
579 
580         _afterTokenTransfer(account, address(0), amount);
581     }
582 
583     /**
584      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
585      *
586      * This internal function is equivalent to `approve`, and can be used to
587      * e.g. set automatic allowances for certain subsystems, etc.
588      *
589      * Emits an {Approval} event.
590      *
591      * Requirements:
592      *
593      * - `owner` cannot be the zero address.
594      * - `spender` cannot be the zero address.
595      */
596     function _approve(
597         address owner,
598         address spender,
599         uint256 amount
600     ) internal virtual {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603 
604         _allowances[owner][spender] = amount;
605         emit Approval(owner, spender, amount);
606     }
607 
608     /**
609      * @dev Hook that is called before any transfer of tokens. This includes
610      * minting and burning.
611      *
612      * Calling conditions:
613      *
614      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
615      * will be transferred to `to`.
616      * - when `from` is zero, `amount` tokens will be minted for `to`.
617      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
618      * - `from` and `to` are never both zero.
619      *
620      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
621      */
622     function _beforeTokenTransfer(
623         address from,
624         address to,
625         uint256 amount
626     ) internal virtual {}
627 
628     /**
629      * @dev Hook that is called after any transfer of tokens. This includes
630      * minting and burning.
631      *
632      * Calling conditions:
633      *
634      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
635      * has been transferred to `to`.
636      * - when `from` is zero, `amount` tokens have been minted for `to`.
637      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
638      * - `from` and `to` are never both zero.
639      *
640      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
641      */
642     function _afterTokenTransfer(
643         address from,
644         address to,
645         uint256 amount
646     ) internal virtual {}
647 }
648 
649 // CAUTION
650 // This version of SafeMath should only be used with Solidity 0.8 or later,
651 // because it relies on the compiler's built in overflow checks.
652 
653 /**
654  * @dev Wrappers over Solidity's arithmetic operations.
655  *
656  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
657  * now has built in overflow checking.
658  */
659 library SafeMath {
660     /**
661      * @dev Returns the addition of two unsigned integers, with an overflow flag.
662      *
663      * _Available since v3.4._
664      */
665     function tryAdd(uint256 a, uint256 b)
666         internal
667         pure
668         returns (bool, uint256)
669     {
670         unchecked {
671             uint256 c = a + b;
672             if (c < a) return (false, 0);
673             return (true, c);
674         }
675     }
676 
677     /**
678      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
679      *
680      * _Available since v3.4._
681      */
682     function trySub(uint256 a, uint256 b)
683         internal
684         pure
685         returns (bool, uint256)
686     {
687         unchecked {
688             if (b > a) return (false, 0);
689             return (true, a - b);
690         }
691     }
692 
693     /**
694      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
695      *
696      * _Available since v3.4._
697      */
698     function tryMul(uint256 a, uint256 b)
699         internal
700         pure
701         returns (bool, uint256)
702     {
703         unchecked {
704             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
705             // benefit is lost if 'b' is also tested.
706             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
707             if (a == 0) return (true, 0);
708             uint256 c = a * b;
709             if (c / a != b) return (false, 0);
710             return (true, c);
711         }
712     }
713 
714     /**
715      * @dev Returns the division of two unsigned integers, with a division by zero flag.
716      *
717      * _Available since v3.4._
718      */
719     function tryDiv(uint256 a, uint256 b)
720         internal
721         pure
722         returns (bool, uint256)
723     {
724         unchecked {
725             if (b == 0) return (false, 0);
726             return (true, a / b);
727         }
728     }
729 
730     /**
731      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
732      *
733      * _Available since v3.4._
734      */
735     function tryMod(uint256 a, uint256 b)
736         internal
737         pure
738         returns (bool, uint256)
739     {
740         unchecked {
741             if (b == 0) return (false, 0);
742             return (true, a % b);
743         }
744     }
745 
746     /**
747      * @dev Returns the addition of two unsigned integers, reverting on
748      * overflow.
749      *
750      * Counterpart to Solidity's `+` operator.
751      *
752      * Requirements:
753      *
754      * - Addition cannot overflow.
755      */
756     function add(uint256 a, uint256 b) internal pure returns (uint256) {
757         return a + b;
758     }
759 
760     /**
761      * @dev Returns the subtraction of two unsigned integers, reverting on
762      * overflow (when the result is negative).
763      *
764      * Counterpart to Solidity's `-` operator.
765      *
766      * Requirements:
767      *
768      * - Subtraction cannot overflow.
769      */
770     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
771         return a - b;
772     }
773 
774     /**
775      * @dev Returns the multiplication of two unsigned integers, reverting on
776      * overflow.
777      *
778      * Counterpart to Solidity's `*` operator.
779      *
780      * Requirements:
781      *
782      * - Multiplication cannot overflow.
783      */
784     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
785         return a * b;
786     }
787 
788     /**
789      * @dev Returns the integer division of two unsigned integers, reverting on
790      * division by zero. The result is rounded towards zero.
791      *
792      * Counterpart to Solidity's `/` operator.
793      *
794      * Requirements:
795      *
796      * - The divisor cannot be zero.
797      */
798     function div(uint256 a, uint256 b) internal pure returns (uint256) {
799         return a / b;
800     }
801 
802     /**
803      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
804      * reverting when dividing by zero.
805      *
806      * Counterpart to Solidity's `%` operator. This function uses a `revert`
807      * opcode (which leaves remaining gas untouched) while Solidity uses an
808      * invalid opcode to revert (consuming all remaining gas).
809      *
810      * Requirements:
811      *
812      * - The divisor cannot be zero.
813      */
814     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
815         return a % b;
816     }
817 
818     /**
819      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
820      * overflow (when the result is negative).
821      *
822      * CAUTION: This function is deprecated because it requires allocating memory for the error
823      * message unnecessarily. For custom revert reasons use {trySub}.
824      *
825      * Counterpart to Solidity's `-` operator.
826      *
827      * Requirements:
828      *
829      * - Subtraction cannot overflow.
830      */
831     function sub(
832         uint256 a,
833         uint256 b,
834         string memory errorMessage
835     ) internal pure returns (uint256) {
836         unchecked {
837             require(b <= a, errorMessage);
838             return a - b;
839         }
840     }
841 
842     /**
843      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
844      * division by zero. The result is rounded towards zero.
845      *
846      * Counterpart to Solidity's `/` operator. Note: this function uses a
847      * `revert` opcode (which leaves remaining gas untouched) while Solidity
848      * uses an invalid opcode to revert (consuming all remaining gas).
849      *
850      * Requirements:
851      *
852      * - The divisor cannot be zero.
853      */
854     function div(
855         uint256 a,
856         uint256 b,
857         string memory errorMessage
858     ) internal pure returns (uint256) {
859         unchecked {
860             require(b > 0, errorMessage);
861             return a / b;
862         }
863     }
864 
865     /**
866      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
867      * reverting with custom message when dividing by zero.
868      *
869      * CAUTION: This function is deprecated because it requires allocating memory for the error
870      * message unnecessarily. For custom revert reasons use {tryMod}.
871      *
872      * Counterpart to Solidity's `%` operator. This function uses a `revert`
873      * opcode (which leaves remaining gas untouched) while Solidity uses an
874      * invalid opcode to revert (consuming all remaining gas).
875      *
876      * Requirements:
877      *
878      * - The divisor cannot be zero.
879      */
880     function mod(
881         uint256 a,
882         uint256 b,
883         string memory errorMessage
884     ) internal pure returns (uint256) {
885         unchecked {
886             require(b > 0, errorMessage);
887             return a % b;
888         }
889     }
890 }
891 
892 contract TyrantTemple is ERC20, Ownable {
893     using SafeMath for uint256;
894 
895     IUniswapV2Router02 public immutable uniswapV2Router;
896     address public uniswapV2Pair;
897     address public constant deadAddress = address(0xdead);
898 
899     bool private swapping;
900 
901     address public marketingWallet;
902     address public devWallet;
903 
904     uint256 public maxTransactionAmount;
905     uint256 public swapTokensAtAmount;
906     uint256 public maxWallet;
907 
908     uint256 public percentForLPBurn = 0; // 0 = 0%
909     bool public lpBurnEnabled = true;
910     uint256 public lpBurnFrequency = 360000000000000 seconds;
911     uint256 public lastLpBurnTime;
912 
913     uint256 public manualBurnFrequency = 300000000000000 minutes;
914     uint256 public lastManualLpBurnTime;
915 
916     bool public limitsInEffect = true;
917     bool public tradingActive = true;
918     bool public swapEnabled = true;
919 
920     // Anti-bot and anti-whale mappings and variables
921     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
922     bool public transferDelayEnabled = true;
923 
924     uint256 public buyTotalFees;
925     uint256 public constant buyMarketingFee = 1;
926     uint256 public constant buyLiquidityFee = 0;
927     uint256 public constant buyDevFee = 4;
928 
929     uint256 public sellTotalFees;
930     uint256 public constant sellMarketingFee = 1;
931     uint256 public constant sellLiquidityFee = 0;
932     uint256 public constant sellDevFee = 4;
933 
934     uint256 public tokensForMarketing;
935     uint256 public tokensForLiquidity;
936     uint256 public tokensForDev;
937 
938     /******************/
939 
940     // exlcude from fees and max transaction amount
941     mapping(address => bool) private _isExcludedFromFees;
942     mapping(address => bool) public _isExcludedMaxTransactionAmount;
943 
944     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
945     // could be subject to a maximum transfer amount
946     mapping(address => bool) public automatedMarketMakerPairs;
947 
948     event UpdateUniswapV2Router(
949         address indexed newAddress,
950         address indexed oldAddress
951     );
952 
953     event ExcludeFromFees(address indexed account, bool isExcluded);
954 
955     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
956 
957     event marketingWalletUpdated(
958         address indexed newWallet,
959         address indexed oldWallet
960     );
961 
962     event devWalletUpdated(
963         address indexed newWallet,
964         address indexed oldWallet
965     );
966 
967     event SwapAndLiquify(
968         uint256 tokensSwapped,
969         uint256 ethReceived,
970         uint256 tokensIntoLiquidity
971     );
972 
973     event AutoNukeLP();
974 
975     event ManualNukeLP();
976 
977     event BoughtEarly(address indexed sniper);
978 
979     constructor() ERC20("Temple of the Dragon", "Tyrant Temple") {
980         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
981             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
982         );
983 
984         excludeFromMaxTransaction(address(_uniswapV2Router), true);
985         uniswapV2Router = _uniswapV2Router;
986 
987         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
988             .createPair(address(this), _uniswapV2Router.WETH());
989         excludeFromMaxTransaction(address(uniswapV2Pair), true);
990         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
991 
992         uint256 totalSupply = 10000000 * 1e18; // 
993 
994         maxTransactionAmount = 200000 * 1e18; //2% from total supply maxTransactionAmountTxn
995         maxWallet = 400000 * 1e18; // 4% from total supply maxWallet
996         swapTokensAtAmount = (totalSupply * 3) / 10000; // 
997 
998         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
999         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1000 
1001         marketingWallet = address(0x6BD72A62bd476BC7113010CB939EE39fA80D6a19); // set as marketing wallet
1002         devWallet = address(0x41824090B74602c41b57Db49C21A718b9436773d); // set as dev wallet
1003 
1004         // exclude from paying fees or having max transaction amount
1005         excludeFromFees(owner(), true);
1006         excludeFromFees(address(this), true);
1007         excludeFromFees(address(0xdead), true);
1008 
1009         excludeFromMaxTransaction(owner(), true);
1010         excludeFromMaxTransaction(address(this), true);
1011         excludeFromMaxTransaction(address(0xdead), true);
1012 
1013         /*
1014             _mint is an internal function in ERC20.sol that is only called here,
1015             and CANNOT be called ever again
1016         */
1017         _mint(msg.sender, totalSupply);
1018     }
1019 
1020     receive() external payable {}
1021 
1022     // once enabled, can never be turned off
1023     function startTrading() external onlyOwner {
1024         tradingActive = true;
1025         swapEnabled = true;
1026         lastLpBurnTime = block.timestamp;
1027     }
1028 
1029     // remove limits after token is stable
1030     function removeLimits() external onlyOwner returns (bool) {
1031         limitsInEffect = false;
1032         return true;
1033     }
1034 
1035     // disable Transfer delay - cannot be reenabled
1036     function disableTransferDelay() external onlyOwner returns (bool) {
1037         transferDelayEnabled = false;
1038         return true;
1039     }
1040 
1041     // change the minimum amount of tokens to sell from fees
1042     function updateSwapTokensAtAmount(uint256 newAmount)
1043         external
1044         onlyOwner
1045         returns (bool)
1046     {
1047         require(
1048             newAmount >= (totalSupply() * 1) / 100000,
1049             "Swap amount cannot be lower than 0.001% total supply."
1050         );
1051         require(
1052             newAmount <= (totalSupply() * 5) / 1000,
1053             "Swap amount cannot be higher than 0.5% total supply."
1054         );
1055         swapTokensAtAmount = newAmount;
1056         return true;
1057     }
1058 
1059     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1060         require(
1061             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1062             "Cannot set maxTransactionAmount lower than 0.1%"
1063         );
1064         maxTransactionAmount = newNum * (10**18);
1065     }
1066 
1067     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1068         require(
1069             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1070             "Cannot set maxWallet lower than 0.5%"
1071         );
1072         maxWallet = newNum * (10**18);
1073     }
1074 
1075     function excludeFromMaxTransaction(address updAds, bool isEx)
1076         public
1077         onlyOwner
1078     {
1079         _isExcludedMaxTransactionAmount[updAds] = isEx;
1080     }
1081 
1082     // only use to disable contract sales if absolutely necessary (emergency use only)
1083     function updateSwapEnabled(bool enabled) external onlyOwner {
1084         swapEnabled = enabled;
1085     }
1086 
1087     function excludeFromFees(address account, bool excluded) public onlyOwner {
1088         _isExcludedFromFees[account] = excluded;
1089         emit ExcludeFromFees(account, excluded);
1090     }
1091 
1092     function setAutomatedMarketMakerPair(address pair, bool value)
1093         public
1094         onlyOwner
1095     {
1096         require(
1097             pair != uniswapV2Pair,
1098             "The pair cannot be removed from automatedMarketMakerPairs"
1099         );
1100 
1101         _setAutomatedMarketMakerPair(pair, value);
1102     }
1103 
1104     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1105         automatedMarketMakerPairs[pair] = value;
1106 
1107         emit SetAutomatedMarketMakerPair(pair, value);
1108     }
1109 
1110     function updateMarketingWallet(address newMarketingWallet)
1111         external
1112         onlyOwner
1113     {
1114         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1115         marketingWallet = newMarketingWallet;
1116     }
1117 
1118     function updateDevWallet(address newWallet) external onlyOwner {
1119         emit devWalletUpdated(newWallet, devWallet);
1120         devWallet = newWallet;
1121     }
1122 
1123     function isExcludedFromFees(address account) public view returns (bool) {
1124         return _isExcludedFromFees[account];
1125     }
1126 
1127     function _transfer(
1128         address from,
1129         address to,
1130         uint256 amount
1131     ) internal override {
1132         require(from != address(0), "ERC20: transfer from the zero address");
1133         require(to != address(0), "ERC20: transfer to the zero address");
1134 
1135         if (amount == 0) {
1136             super._transfer(from, to, 0);
1137             return;
1138         }
1139 
1140         if (limitsInEffect) {
1141             if (
1142                 from != owner() &&
1143                 to != owner() &&
1144                 to != address(0) &&
1145                 to != address(0xdead) &&
1146                 !swapping
1147             ) {
1148                 if (!tradingActive) {
1149                     require(
1150                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1151                         "Trading is not active."
1152                     );
1153                 }
1154 
1155                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1156                 if (transferDelayEnabled) {
1157                     if (
1158                         to != owner() &&
1159                         to != address(uniswapV2Router) &&
1160                         to != address(uniswapV2Pair)
1161                     ) {
1162                         require(
1163                             _holderLastTransferTimestamp[tx.origin] <
1164                                 block.number,
1165                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1166                         );
1167                         _holderLastTransferTimestamp[tx.origin] = block.number;
1168                     }
1169                 }
1170 
1171                 //when buy
1172                 if (
1173                     automatedMarketMakerPairs[from] &&
1174                     !_isExcludedMaxTransactionAmount[to]
1175                 ) {
1176                     require(
1177                         amount <= maxTransactionAmount,
1178                         "Buy transfer amount exceeds the maxTransactionAmount."
1179                     );
1180                     require(
1181                         amount + balanceOf(to) <= maxWallet,
1182                         "Max wallet exceeded"
1183                     );
1184                 }
1185                 //when sell
1186                 else if (
1187                     automatedMarketMakerPairs[to] &&
1188                     !_isExcludedMaxTransactionAmount[from]
1189                 ) {
1190                     require(
1191                         amount <= maxTransactionAmount,
1192                         "Sell transfer amount exceeds the maxTransactionAmount."
1193                     );
1194                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1195                     require(
1196                         amount + balanceOf(to) <= maxWallet,
1197                         "Max wallet exceeded"
1198                     );
1199                 }
1200             }
1201         }
1202 
1203         uint256 contractTokenBalance = balanceOf(address(this));
1204 
1205         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1206 
1207         if (
1208             canSwap &&
1209             swapEnabled &&
1210             !swapping &&
1211             !automatedMarketMakerPairs[from] &&
1212             !_isExcludedFromFees[from] &&
1213             !_isExcludedFromFees[to]
1214         ) {
1215             swapping = true;
1216 
1217             swapBack();
1218 
1219             swapping = false;
1220         }
1221 
1222         if (
1223             !swapping &&
1224             automatedMarketMakerPairs[to] &&
1225             lpBurnEnabled &&
1226             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1227             !_isExcludedFromFees[from]
1228         ) {
1229             autoBurnLiquidityPairTokens();
1230         }
1231 
1232         bool takeFee = !swapping;
1233 
1234         // if any account belongs to _isExcludedFromFee account then remove the fee
1235         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1236             takeFee = false;
1237         }
1238 
1239         uint256 fees = 0;
1240         // only take fees on buys/sells, do not take on wallet transfers
1241         if (takeFee) {
1242             // on sell
1243             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1244                 fees = amount.mul(sellTotalFees).div(100);
1245                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1246                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1247                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1248             }
1249             // on buy
1250             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1251                 fees = amount.mul(buyTotalFees).div(100);
1252                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1253                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1254                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1255             }
1256 
1257             if (fees > 0) {
1258                 super._transfer(from, address(this), fees);
1259             }
1260 
1261             amount -= fees;
1262         }
1263 
1264         super._transfer(from, to, amount);
1265     }
1266 
1267     function swapTokensForEth(uint256 tokenAmount) private {
1268         // generate the uniswap pair path of token -> weth
1269         address[] memory path = new address[](2);
1270         path[0] = address(this);
1271         path[1] = uniswapV2Router.WETH();
1272 
1273         _approve(address(this), address(uniswapV2Router), tokenAmount);
1274 
1275         // make the swap
1276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1277             tokenAmount,
1278             0, // accept any amount of ETH
1279             path,
1280             address(this),
1281             block.timestamp
1282         );
1283     }
1284 
1285     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1286         // approve token transfer to cover all possible scenarios
1287         _approve(address(this), address(uniswapV2Router), tokenAmount);
1288 
1289         // add the liquidity
1290         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1291             address(this),
1292             tokenAmount,
1293             0, // slippage is unavoidable
1294             0, // slippage is unavoidable
1295             deadAddress,
1296             block.timestamp
1297         );
1298     }
1299 
1300     function swapBack() private {
1301         uint256 contractBalance = balanceOf(address(this));
1302         uint256 totalTokensToSwap = tokensForLiquidity +
1303             tokensForMarketing +
1304             tokensForDev;
1305         bool success;
1306 
1307         if (contractBalance == 0 || totalTokensToSwap == 0) {
1308             return;
1309         }
1310 
1311         if (contractBalance > swapTokensAtAmount * 20) {
1312             contractBalance = swapTokensAtAmount * 20;
1313         }
1314 
1315         // Halve the amount of liquidity tokens
1316         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1317             totalTokensToSwap /
1318             2;
1319         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1320 
1321         uint256 initialETHBalance = address(this).balance;
1322 
1323         swapTokensForEth(amountToSwapForETH);
1324 
1325         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1326 
1327         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1328             totalTokensToSwap
1329         );
1330         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1331 
1332         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1333 
1334         tokensForLiquidity = 0;
1335         tokensForMarketing = 0;
1336         tokensForDev = 0;
1337 
1338         (success, ) = address(devWallet).call{value: ethForDev}("");
1339 
1340         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1341             addLiquidity(liquidityTokens, ethForLiquidity);
1342             emit SwapAndLiquify(
1343                 amountToSwapForETH,
1344                 ethForLiquidity,
1345                 tokensForLiquidity
1346             );
1347         }
1348 
1349         (success, ) = address(marketingWallet).call{
1350             value: address(this).balance
1351         }("");
1352     }
1353 
1354     function setAutoLPBurnSettings(
1355         uint256 _frequencyInSeconds,
1356         uint256 _percent,
1357         bool _Enabled
1358     ) external onlyOwner {
1359         require(
1360             _frequencyInSeconds >= 600,
1361             "cannot set buyback more often than every 10 minutes"
1362         );
1363         require(
1364             _percent <= 1000 && _percent >= 0,
1365             "Must set auto LP burn percent between 0% and 10%"
1366         );
1367         lpBurnFrequency = _frequencyInSeconds;
1368         percentForLPBurn = _percent;
1369         lpBurnEnabled = _Enabled;
1370     }
1371 
1372     function autoBurnLiquidityPairTokens() internal returns (bool) {
1373         lastLpBurnTime = block.timestamp;
1374 
1375         // get balance of liquidity pair
1376         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1377 
1378         // calculate amount to burn
1379         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1380             10000
1381         );
1382 
1383         // pull tokens from pancakePair liquidity and move to dead address permanently
1384         if (amountToBurn > 0) {
1385             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1386         }
1387 
1388         //sync price since this is not in a swap transaction!
1389         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1390         pair.sync();
1391         emit AutoNukeLP();
1392         return true;
1393     }
1394 
1395     function manualBurnLiquidityPairTokens(uint256 percent)
1396         external
1397         onlyOwner
1398         returns (bool)
1399     {
1400         require(
1401             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1402             "Must wait for cooldown to finish"
1403         );
1404         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1405         lastManualLpBurnTime = block.timestamp;
1406 
1407         // get balance of liquidity pair
1408         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1409 
1410         // calculate amount to burn
1411         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1412 
1413         // pull tokens from pancakePair liquidity and move to dead address permanently
1414         if (amountToBurn > 0) {
1415             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1416         }
1417 
1418         //sync price since this is not in a swap transaction!
1419         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1420         pair.sync();
1421         emit ManualNukeLP();
1422         return true;
1423     }
1424 }