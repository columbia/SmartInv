1 // Chainback - Web3 Internet Archive
2 // https://chainback.org
3 // https://t.me/chainback_archive
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 interface IUniswapV2Factory {
10     function createPair(address tokenA, address tokenB)
11         external
12         returns (address pair);
13 }
14 
15 interface IUniswapV2Router01 {
16     function factory() external pure returns (address);
17 
18     function WETH() external pure returns (address);
19 
20     function addLiquidityETH(
21         address token,
22         uint256 amountTokenDesired,
23         uint256 amountTokenMin,
24         uint256 amountETHMin,
25         address to,
26         uint256 deadline
27     )
28         external
29         payable
30         returns (
31             uint256 amountToken,
32             uint256 amountETH,
33             uint256 liquidity
34         );
35 }
36 
37 interface IUniswapV2Router02 is IUniswapV2Router01 {
38     function swapExactTokensForETHSupportingFeeOnTransferTokens(
39         uint256 amountIn,
40         uint256 amountOutMin,
41         address[] calldata path,
42         address to,
43         uint256 deadline
44     ) external;
45 }
46 
47 interface IUniswapV2Pair {
48     function sync() external;
49 }
50 
51 /**
52  * @dev Provides information about the current execution context, including the
53  * sender of the transaction and its data. While these are generally available
54  * via msg.sender and msg.data, they should not be accessed in such a direct
55  * manner, since when dealing with meta-transactions the account sending and
56  * paying for execution may not be the actual sender (as far as an application
57  * is concerned).
58  *
59  * This contract is only required for intermediate, library-like contracts.
60  */
61 abstract contract Context {
62     function _msgSender() internal view virtual returns (address) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view virtual returns (bytes calldata) {
67         return msg.data;
68     }
69 }
70 
71 /**
72  * @dev Contract module which provides a basic access control mechanism, where
73  * there is an account (an owner) that can be granted exclusive access to
74  * specific functions.
75  *
76  * By default, the owner account will be the one that deploys the contract. This
77  * can later be changed with {transferOwnership}.
78  *
79  * This module is used through inheritance. It will make available the modifier
80  * `onlyOwner`, which can be applied to your functions to restrict their use to
81  * the owner.
82  */
83 abstract contract Ownable is Context {
84     address private _owner;
85 
86     event OwnershipTransferred(
87         address indexed previousOwner,
88         address indexed newOwner
89     );
90 
91     /**
92      * @dev Initializes the contract setting the deployer as the initial owner.
93      */
94     constructor() {
95         _transferOwnership(_msgSender());
96     }
97 
98     /**
99      * @dev Returns the address of the current owner.
100      */
101     function owner() public view virtual returns (address) {
102         return _owner;
103     }
104 
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108     modifier onlyOwner() {
109         require(owner() == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     /**
114      * @dev Leaves the contract without owner. It will not be possible to call
115      * `onlyOwner` functions anymore. Can only be called by the current owner.
116      *
117      * NOTE: Renouncing ownership will leave the contract without an owner,
118      * thereby removing any functionality that is only available to the owner.
119      */
120     function renounceOwnership() public virtual onlyOwner {
121         _transferOwnership(address(0));
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      * Can only be called by the current owner.
127      */
128     function transferOwnership(address newOwner) public virtual onlyOwner {
129         require(
130             newOwner != address(0),
131             "Ownable: new owner is the zero address"
132         );
133         _transferOwnership(newOwner);
134     }
135 
136     /**
137      * @dev Transfers ownership of the contract to a new account (`newOwner`).
138      * Internal function without access restriction.
139      */
140     function _transferOwnership(address newOwner) internal virtual {
141         address oldOwner = _owner;
142         _owner = newOwner;
143         emit OwnershipTransferred(oldOwner, newOwner);
144     }
145 }
146 
147 /**
148  * @dev Interface of the ERC20 standard as defined in the EIP.
149  */
150 interface IERC20 {
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `recipient`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address recipient, uint256 amount)
169         external
170         returns (bool);
171 
172     /**
173      * @dev Returns the remaining number of tokens that `spender` will be
174      * allowed to spend on behalf of `owner` through {transferFrom}. This is
175      * zero by default.
176      *
177      * This value changes when {approve} or {transferFrom} are called.
178      */
179     function allowance(address owner, address spender)
180         external
181         view
182         returns (uint256);
183 
184     /**
185      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * IMPORTANT: Beware that changing an allowance with this method brings the risk
190      * that someone may use both the old and the new allowance by unfortunate
191      * transaction ordering. One possible solution to mitigate this race
192      * condition is to first reduce the spender's allowance to 0 and set the
193      * desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      *
196      * Emits an {Approval} event.
197      */
198     function approve(address spender, uint256 amount) external returns (bool);
199 
200     /**
201      * @dev Moves `amount` tokens from `sender` to `recipient` using the
202      * allowance mechanism. `amount` is then deducted from the caller's
203      * allowance.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address sender,
211         address recipient,
212         uint256 amount
213     ) external returns (bool);
214 
215     /**
216      * @dev Emitted when `value` tokens are moved from one account (`from`) to
217      * another (`to`).
218      *
219      * Note that `value` may be zero.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 value);
222 
223     /**
224      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
225      * a call to {approve}. `value` is the new allowance.
226      */
227     event Approval(
228         address indexed owner,
229         address indexed spender,
230         uint256 value
231     );
232 }
233 
234 /**
235  * @dev Interface for the optional metadata functions from the ERC20 standard.
236  *
237  * _Available since v4.1._
238  */
239 interface IERC20Metadata is IERC20 {
240     /**
241      * @dev Returns the name of the token.
242      */
243     function name() external view returns (string memory);
244 
245     /**
246      * @dev Returns the symbol of the token.
247      */
248     function symbol() external view returns (string memory);
249 
250     /**
251      * @dev Returns the decimals places of the token.
252      */
253     function decimals() external view returns (uint8);
254 }
255 
256 /**
257  * @dev Implementation of the {IERC20} interface.
258  *
259  * This implementation is agnostic to the way tokens are created. This means
260  * that a supply mechanism has to be added in a derived contract using {_mint}.
261  * For a generic mechanism see {ERC20PresetMinterPauser}.
262  *
263  * TIP: For a detailed writeup see our guide
264  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
265  * to implement supply mechanisms].
266  *
267  * We have followed general OpenZeppelin Contracts guidelines: functions revert
268  * instead returning `false` on failure. This behavior is nonetheless
269  * conventional and does not conflict with the expectations of ERC20
270  * applications.
271  *
272  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
273  * This allows applications to reconstruct the allowance for all accounts just
274  * by listening to said events. Other implementations of the EIP may not emit
275  * these events, as it isn't required by the specification.
276  *
277  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
278  * functions have been added to mitigate the well-known issues around setting
279  * allowances. See {IERC20-approve}.
280  */
281 contract ERC20 is Context, IERC20, IERC20Metadata {
282     mapping(address => uint256) private _balances;
283 
284     mapping(address => mapping(address => uint256)) private _allowances;
285 
286     uint256 private _totalSupply;
287 
288     string private _name;
289     string private _symbol;
290 
291     /**
292      * @dev Sets the values for {name} and {symbol}.
293      *
294      * The default value of {decimals} is 18. To select a different value for
295      * {decimals} you should overload it.
296      *
297      * All two of these values are immutable: they can only be set once during
298      * construction.
299      */
300     constructor(string memory name_, string memory symbol_) {
301         _name = name_;
302         _symbol = symbol_;
303     }
304 
305     /**
306      * @dev Returns the name of the token.
307      */
308     function name() public view virtual override returns (string memory) {
309         return _name;
310     }
311 
312     /**
313      * @dev Returns the symbol of the token, usually a shorter version of the
314      * name.
315      */
316     function symbol() public view virtual override returns (string memory) {
317         return _symbol;
318     }
319 
320     /**
321      * @dev Returns the number of decimals used to get its user representation.
322      * For example, if `decimals` equals `2`, a balance of `505` tokens should
323      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
324      *
325      * Tokens usually opt for a value of 18, imitating the relationship between
326      * Ether and Wei. This is the value {ERC20} uses, unless this function is
327      * overridden;
328      *
329      * NOTE: This information is only used for _display_ purposes: it in
330      * no way affects any of the arithmetic of the contract, including
331      * {IERC20-balanceOf} and {IERC20-transfer}.
332      */
333     function decimals() public view virtual override returns (uint8) {
334         return 18;
335     }
336 
337     /**
338      * @dev See {IERC20-totalSupply}.
339      */
340     function totalSupply() public view virtual override returns (uint256) {
341         return _totalSupply;
342     }
343 
344     /**
345      * @dev See {IERC20-balanceOf}.
346      */
347     function balanceOf(address account)
348         public
349         view
350         virtual
351         override
352         returns (uint256)
353     {
354         return _balances[account];
355     }
356 
357     /**
358      * @dev See {IERC20-transfer}.
359      *
360      * Requirements:
361      *
362      * - `recipient` cannot be the zero address.
363      * - the caller must have a balance of at least `amount`.
364      */
365     function transfer(address recipient, uint256 amount)
366         public
367         virtual
368         override
369         returns (bool)
370     {
371         _transfer(_msgSender(), recipient, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-allowance}.
377      */
378     function allowance(address owner, address spender)
379         public
380         view
381         virtual
382         override
383         returns (uint256)
384     {
385         return _allowances[owner][spender];
386     }
387 
388     /**
389      * @dev See {IERC20-approve}.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function approve(address spender, uint256 amount)
396         public
397         virtual
398         override
399         returns (bool)
400     {
401         _approve(_msgSender(), spender, amount);
402         return true;
403     }
404 
405     /**
406      * @dev See {IERC20-transferFrom}.
407      *
408      * Emits an {Approval} event indicating the updated allowance. This is not
409      * required by the EIP. See the note at the beginning of {ERC20}.
410      *
411      * Requirements:
412      *
413      * - `sender` and `recipient` cannot be the zero address.
414      * - `sender` must have a balance of at least `amount`.
415      * - the caller must have allowance for ``sender``'s tokens of at least
416      * `amount`.
417      */
418     function transferFrom(
419         address sender,
420         address recipient,
421         uint256 amount
422     ) public virtual override returns (bool) {
423         _transfer(sender, recipient, amount);
424 
425         uint256 currentAllowance = _allowances[sender][_msgSender()];
426         require(
427             currentAllowance >= amount,
428             "ERC20: transfer amount exceeds allowance"
429         );
430         unchecked {
431             _approve(sender, _msgSender(), currentAllowance - amount);
432         }
433 
434         return true;
435     }
436 
437     /**
438      * @dev Atomically increases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      */
449     function increaseAllowance(address spender, uint256 addedValue)
450         public
451         virtual
452         returns (bool)
453     {
454         _approve(
455             _msgSender(),
456             spender,
457             _allowances[_msgSender()][spender] + addedValue
458         );
459         return true;
460     }
461 
462     /**
463      * @dev Atomically decreases the allowance granted to `spender` by the caller.
464      *
465      * This is an alternative to {approve} that can be used as a mitigation for
466      * problems described in {IERC20-approve}.
467      *
468      * Emits an {Approval} event indicating the updated allowance.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      * - `spender` must have allowance for the caller of at least
474      * `subtractedValue`.
475      */
476     function decreaseAllowance(address spender, uint256 subtractedValue)
477         public
478         virtual
479         returns (bool)
480     {
481         uint256 currentAllowance = _allowances[_msgSender()][spender];
482         require(
483             currentAllowance >= subtractedValue,
484             "ERC20: decreased allowance below zero"
485         );
486         unchecked {
487             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
488         }
489 
490         return true;
491     }
492 
493     /**
494      * @dev Moves `amount` of tokens from `sender` to `recipient`.
495      *
496      * This internal function is equivalent to {transfer}, and can be used to
497      * e.g. implement automatic token fees, slashing mechanisms, etc.
498      *
499      * Emits a {Transfer} event.
500      *
501      * Requirements:
502      *
503      * - `sender` cannot be the zero address.
504      * - `recipient` cannot be the zero address.
505      * - `sender` must have a balance of at least `amount`.
506      */
507     function _transfer(
508         address sender,
509         address recipient,
510         uint256 amount
511     ) internal virtual {
512         require(sender != address(0), "ERC20: transfer from the zero address");
513         require(recipient != address(0), "ERC20: transfer to the zero address");
514 
515         _beforeTokenTransfer(sender, recipient, amount);
516 
517         uint256 senderBalance = _balances[sender];
518         require(
519             senderBalance >= amount,
520             "ERC20: transfer amount exceeds balance"
521         );
522         unchecked {
523             _balances[sender] = senderBalance - amount;
524         }
525         _balances[recipient] += amount;
526 
527         emit Transfer(sender, recipient, amount);
528 
529         _afterTokenTransfer(sender, recipient, amount);
530     }
531 
532     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
533      * the total supply.
534      *
535      * Emits a {Transfer} event with `from` set to the zero address.
536      *
537      * Requirements:
538      *
539      * - `account` cannot be the zero address.
540      */
541     function _mint(address account, uint256 amount) internal virtual {
542         require(account != address(0), "ERC20: mint to the zero address");
543 
544         _beforeTokenTransfer(address(0), account, amount);
545 
546         _totalSupply += amount;
547         _balances[account] += amount;
548         emit Transfer(address(0), account, amount);
549 
550         _afterTokenTransfer(address(0), account, amount);
551     }
552 
553     /**
554      * @dev Destroys `amount` tokens from `account`, reducing the
555      * total supply.
556      *
557      * Emits a {Transfer} event with `to` set to the zero address.
558      *
559      * Requirements:
560      *
561      * - `account` cannot be the zero address.
562      * - `account` must have at least `amount` tokens.
563      */
564     function _burn(address account, uint256 amount) internal virtual {
565         require(account != address(0), "ERC20: burn from the zero address");
566 
567         _beforeTokenTransfer(account, address(0), amount);
568 
569         uint256 accountBalance = _balances[account];
570         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
571         unchecked {
572             _balances[account] = accountBalance - amount;
573         }
574         _totalSupply -= amount;
575 
576         emit Transfer(account, address(0), amount);
577 
578         _afterTokenTransfer(account, address(0), amount);
579     }
580 
581     /**
582      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
583      *
584      * This internal function is equivalent to `approve`, and can be used to
585      * e.g. set automatic allowances for certain subsystems, etc.
586      *
587      * Emits an {Approval} event.
588      *
589      * Requirements:
590      *
591      * - `owner` cannot be the zero address.
592      * - `spender` cannot be the zero address.
593      */
594     function _approve(
595         address owner,
596         address spender,
597         uint256 amount
598     ) internal virtual {
599         require(owner != address(0), "ERC20: approve from the zero address");
600         require(spender != address(0), "ERC20: approve to the zero address");
601 
602         _allowances[owner][spender] = amount;
603         emit Approval(owner, spender, amount);
604     }
605 
606     /**
607      * @dev Hook that is called before any transfer of tokens. This includes
608      * minting and burning.
609      *
610      * Calling conditions:
611      *
612      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
613      * will be transferred to `to`.
614      * - when `from` is zero, `amount` tokens will be minted for `to`.
615      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
616      * - `from` and `to` are never both zero.
617      *
618      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
619      */
620     function _beforeTokenTransfer(
621         address from,
622         address to,
623         uint256 amount
624     ) internal virtual {}
625 
626     /**
627      * @dev Hook that is called after any transfer of tokens. This includes
628      * minting and burning.
629      *
630      * Calling conditions:
631      *
632      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
633      * has been transferred to `to`.
634      * - when `from` is zero, `amount` tokens have been minted for `to`.
635      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
636      * - `from` and `to` are never both zero.
637      *
638      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
639      */
640     function _afterTokenTransfer(
641         address from,
642         address to,
643         uint256 amount
644     ) internal virtual {}
645 }
646 
647 // CAUTION
648 // This version of SafeMath should only be used with Solidity 0.8 or later,
649 // because it relies on the compiler's built in overflow checks.
650 
651 /**
652  * @dev Wrappers over Solidity's arithmetic operations.
653  *
654  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
655  * now has built in overflow checking.
656  */
657 library SafeMath {
658     /**
659      * @dev Returns the addition of two unsigned integers, with an overflow flag.
660      *
661      * _Available since v3.4._
662      */
663     function tryAdd(uint256 a, uint256 b)
664         internal
665         pure
666         returns (bool, uint256)
667     {
668         unchecked {
669             uint256 c = a + b;
670             if (c < a) return (false, 0);
671             return (true, c);
672         }
673     }
674 
675     /**
676      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
677      *
678      * _Available since v3.4._
679      */
680     function trySub(uint256 a, uint256 b)
681         internal
682         pure
683         returns (bool, uint256)
684     {
685         unchecked {
686             if (b > a) return (false, 0);
687             return (true, a - b);
688         }
689     }
690 
691     /**
692      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
693      *
694      * _Available since v3.4._
695      */
696     function tryMul(uint256 a, uint256 b)
697         internal
698         pure
699         returns (bool, uint256)
700     {
701         unchecked {
702             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
703             // benefit is lost if 'b' is also tested.
704             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
705             if (a == 0) return (true, 0);
706             uint256 c = a * b;
707             if (c / a != b) return (false, 0);
708             return (true, c);
709         }
710     }
711 
712     /**
713      * @dev Returns the division of two unsigned integers, with a division by zero flag.
714      *
715      * _Available since v3.4._
716      */
717     function tryDiv(uint256 a, uint256 b)
718         internal
719         pure
720         returns (bool, uint256)
721     {
722         unchecked {
723             if (b == 0) return (false, 0);
724             return (true, a / b);
725         }
726     }
727 
728     /**
729      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
730      *
731      * _Available since v3.4._
732      */
733     function tryMod(uint256 a, uint256 b)
734         internal
735         pure
736         returns (bool, uint256)
737     {
738         unchecked {
739             if (b == 0) return (false, 0);
740             return (true, a % b);
741         }
742     }
743 
744     /**
745      * @dev Returns the addition of two unsigned integers, reverting on
746      * overflow.
747      *
748      * Counterpart to Solidity's `+` operator.
749      *
750      * Requirements:
751      *
752      * - Addition cannot overflow.
753      */
754     function add(uint256 a, uint256 b) internal pure returns (uint256) {
755         return a + b;
756     }
757 
758     /**
759      * @dev Returns the subtraction of two unsigned integers, reverting on
760      * overflow (when the result is negative).
761      *
762      * Counterpart to Solidity's `-` operator.
763      *
764      * Requirements:
765      *
766      * - Subtraction cannot overflow.
767      */
768     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
769         return a - b;
770     }
771 
772     /**
773      * @dev Returns the multiplication of two unsigned integers, reverting on
774      * overflow.
775      *
776      * Counterpart to Solidity's `*` operator.
777      *
778      * Requirements:
779      *
780      * - Multiplication cannot overflow.
781      */
782     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
783         return a * b;
784     }
785 
786     /**
787      * @dev Returns the integer division of two unsigned integers, reverting on
788      * division by zero. The result is rounded towards zero.
789      *
790      * Counterpart to Solidity's `/` operator.
791      *
792      * Requirements:
793      *
794      * - The divisor cannot be zero.
795      */
796     function div(uint256 a, uint256 b) internal pure returns (uint256) {
797         return a / b;
798     }
799 
800     /**
801      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
802      * reverting when dividing by zero.
803      *
804      * Counterpart to Solidity's `%` operator. This function uses a `revert`
805      * opcode (which leaves remaining gas untouched) while Solidity uses an
806      * invalid opcode to revert (consuming all remaining gas).
807      *
808      * Requirements:
809      *
810      * - The divisor cannot be zero.
811      */
812     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
813         return a % b;
814     }
815 
816     /**
817      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
818      * overflow (when the result is negative).
819      *
820      * CAUTION: This function is deprecated because it requires allocating memory for the error
821      * message unnecessarily. For custom revert reasons use {trySub}.
822      *
823      * Counterpart to Solidity's `-` operator.
824      *
825      * Requirements:
826      *
827      * - Subtraction cannot overflow.
828      */
829     function sub(
830         uint256 a,
831         uint256 b,
832         string memory errorMessage
833     ) internal pure returns (uint256) {
834         unchecked {
835             require(b <= a, errorMessage);
836             return a - b;
837         }
838     }
839 
840     /**
841      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
842      * division by zero. The result is rounded towards zero.
843      *
844      * Counterpart to Solidity's `/` operator. Note: this function uses a
845      * `revert` opcode (which leaves remaining gas untouched) while Solidity
846      * uses an invalid opcode to revert (consuming all remaining gas).
847      *
848      * Requirements:
849      *
850      * - The divisor cannot be zero.
851      */
852     function div(
853         uint256 a,
854         uint256 b,
855         string memory errorMessage
856     ) internal pure returns (uint256) {
857         unchecked {
858             require(b > 0, errorMessage);
859             return a / b;
860         }
861     }
862 
863     /**
864      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
865      * reverting with custom message when dividing by zero.
866      *
867      * CAUTION: This function is deprecated because it requires allocating memory for the error
868      * message unnecessarily. For custom revert reasons use {tryMod}.
869      *
870      * Counterpart to Solidity's `%` operator. This function uses a `revert`
871      * opcode (which leaves remaining gas untouched) while Solidity uses an
872      * invalid opcode to revert (consuming all remaining gas).
873      *
874      * Requirements:
875      *
876      * - The divisor cannot be zero.
877      */
878     function mod(
879         uint256 a,
880         uint256 b,
881         string memory errorMessage
882     ) internal pure returns (uint256) {
883         unchecked {
884             require(b > 0, errorMessage);
885             return a % b;
886         }
887     }
888 }
889 
890 contract Chainback is ERC20, Ownable {
891     using SafeMath for uint256;
892 
893     IUniswapV2Router02 public immutable uniswapV2Router;
894     address public uniswapV2Pair;
895     address public constant deadAddress = address(0xdead);
896 
897     bool private swapping;
898 
899     address public marketingWallet;
900     address public devWallet;
901 
902     uint256 public maxTransactionAmount;
903     uint256 public swapTokensAtAmount;
904     uint256 public maxWallet;
905 
906     uint256 public percentForLPBurn = 0; // 0 = 0%
907     bool public lpBurnEnabled = true;
908     uint256 public lpBurnFrequency = 360000000000000 seconds;
909     uint256 public lastLpBurnTime;
910 
911     uint256 public manualBurnFrequency = 300000000000000 minutes;
912     uint256 public lastManualLpBurnTime;
913 
914     bool public limitsInEffect = true;
915     bool public tradingActive = true;
916     bool public swapEnabled = true;
917 
918     // Anti-bot and anti-whale mappings and variables
919     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
920     bool public transferDelayEnabled = true;
921 
922     uint256 public buyTotalFees;
923     uint256 public constant buyMarketingFee = 2;
924     uint256 public constant buyLiquidityFee = 0;
925     uint256 public constant buyDevFee = 2;
926 
927     uint256 public sellTotalFees;
928     uint256 public constant sellMarketingFee = 2;
929     uint256 public constant sellLiquidityFee = 0;
930     uint256 public constant sellDevFee = 2;
931 
932     uint256 public tokensForMarketing;
933     uint256 public tokensForLiquidity;
934     uint256 public tokensForDev;
935 
936     /******************/
937 
938     // exlcude from fees and max transaction amount
939     mapping(address => bool) private _isExcludedFromFees;
940     mapping(address => bool) public _isExcludedMaxTransactionAmount;
941 
942     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
943     // could be subject to a maximum transfer amount
944     mapping(address => bool) public automatedMarketMakerPairs;
945 
946     event UpdateUniswapV2Router(
947         address indexed newAddress,
948         address indexed oldAddress
949     );
950 
951     event ExcludeFromFees(address indexed account, bool isExcluded);
952 
953     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
954 
955     event marketingWalletUpdated(
956         address indexed newWallet,
957         address indexed oldWallet
958     );
959 
960     event devWalletUpdated(
961         address indexed newWallet,
962         address indexed oldWallet
963     );
964 
965     event SwapAndLiquify(
966         uint256 tokensSwapped,
967         uint256 ethReceived,
968         uint256 tokensIntoLiquidity
969     );
970 
971     event AutoNukeLP();
972 
973     event ManualNukeLP();
974 
975     event BoughtEarly(address indexed sniper);
976 
977     constructor() ERC20("ARCHIVE", "Chainback Web3 Internet Archive") {
978         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
979             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
980         );
981 
982         excludeFromMaxTransaction(address(_uniswapV2Router), true);
983         uniswapV2Router = _uniswapV2Router;
984 
985         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
986             .createPair(address(this), _uniswapV2Router.WETH());
987         excludeFromMaxTransaction(address(uniswapV2Pair), true);
988         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
989 
990         uint256 totalSupply = 1_000_000_000 * 1e18; // 1 billion total supply
991 
992         maxTransactionAmount = 30_000_000 * 1e18; //3% from total supply maxTransactionAmountTxn
993         maxWallet = 30_000_000 * 1e18; // 3% from total supply maxWallet
994         swapTokensAtAmount = (totalSupply * 3) / 10000; // 0.03% swap wallet
995 
996         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
997         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
998 
999         marketingWallet = address(0x2AedE79D046b1a7975FB830Af0a820526Dc894E2); // set as marketing wallet
1000         devWallet = address(0x2AedE79D046b1a7975FB830Af0a820526Dc894E2); // set as dev wallet
1001 
1002         // exclude from paying fees or having max transaction amount
1003         excludeFromFees(owner(), true);
1004         excludeFromFees(address(this), true);
1005         excludeFromFees(address(0xdead), true);
1006 
1007         excludeFromMaxTransaction(owner(), true);
1008         excludeFromMaxTransaction(address(this), true);
1009         excludeFromMaxTransaction(address(0xdead), true);
1010 
1011         /*
1012             _mint is an internal function in ERC20.sol that is only called here,
1013             and CANNOT be called ever again
1014         */
1015         _mint(msg.sender, totalSupply);
1016     }
1017 
1018     receive() external payable {}
1019 
1020     // once enabled, can never be turned off
1021     function startTrading() external onlyOwner {
1022         tradingActive = true;
1023         swapEnabled = true;
1024         lastLpBurnTime = block.timestamp;
1025     }
1026 
1027     // remove limits after token is stable
1028     function removeLimits() external onlyOwner returns (bool) {
1029         limitsInEffect = false;
1030         return true;
1031     }
1032 
1033     // disable Transfer delay - cannot be reenabled
1034     function disableTransferDelay() external onlyOwner returns (bool) {
1035         transferDelayEnabled = false;
1036         return true;
1037     }
1038 
1039     // change the minimum amount of tokens to sell from fees
1040     function updateSwapTokensAtAmount(uint256 newAmount)
1041         external
1042         onlyOwner
1043         returns (bool)
1044     {
1045         require(
1046             newAmount >= (totalSupply() * 1) / 100000,
1047             "Swap amount cannot be lower than 0.001% total supply."
1048         );
1049         require(
1050             newAmount <= (totalSupply() * 5) / 1000,
1051             "Swap amount cannot be higher than 0.5% total supply."
1052         );
1053         swapTokensAtAmount = newAmount;
1054         return true;
1055     }
1056 
1057     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1058         require(
1059             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1060             "Cannot set maxTransactionAmount lower than 0.1%"
1061         );
1062         maxTransactionAmount = newNum * (10**18);
1063     }
1064 
1065     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1066         require(
1067             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1068             "Cannot set maxWallet lower than 0.5%"
1069         );
1070         maxWallet = newNum * (10**18);
1071     }
1072 
1073     function excludeFromMaxTransaction(address updAds, bool isEx)
1074         public
1075         onlyOwner
1076     {
1077         _isExcludedMaxTransactionAmount[updAds] = isEx;
1078     }
1079 
1080     // only use to disable contract sales if absolutely necessary (emergency use only)
1081     function updateSwapEnabled(bool enabled) external onlyOwner {
1082         swapEnabled = enabled;
1083     }
1084 
1085     function excludeFromFees(address account, bool excluded) public onlyOwner {
1086         _isExcludedFromFees[account] = excluded;
1087         emit ExcludeFromFees(account, excluded);
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
1116     function updateDevWallet(address newWallet) external onlyOwner {
1117         emit devWalletUpdated(newWallet, devWallet);
1118         devWallet = newWallet;
1119     }
1120 
1121     function isExcludedFromFees(address account) public view returns (bool) {
1122         return _isExcludedFromFees[account];
1123     }
1124 
1125     function _transfer(
1126         address from,
1127         address to,
1128         uint256 amount
1129     ) internal override {
1130         require(from != address(0), "ERC20: transfer from the zero address");
1131         require(to != address(0), "ERC20: transfer to the zero address");
1132 
1133         if (amount == 0) {
1134             super._transfer(from, to, 0);
1135             return;
1136         }
1137 
1138         if (limitsInEffect) {
1139             if (
1140                 from != owner() &&
1141                 to != owner() &&
1142                 to != address(0) &&
1143                 to != address(0xdead) &&
1144                 !swapping
1145             ) {
1146                 if (!tradingActive) {
1147                     require(
1148                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1149                         "Trading is not active."
1150                     );
1151                 }
1152 
1153                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1154                 if (transferDelayEnabled) {
1155                     if (
1156                         to != owner() &&
1157                         to != address(uniswapV2Router) &&
1158                         to != address(uniswapV2Pair)
1159                     ) {
1160                         require(
1161                             _holderLastTransferTimestamp[tx.origin] <
1162                                 block.number,
1163                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1164                         );
1165                         _holderLastTransferTimestamp[tx.origin] = block.number;
1166                     }
1167                 }
1168 
1169                 //when buy
1170                 if (
1171                     automatedMarketMakerPairs[from] &&
1172                     !_isExcludedMaxTransactionAmount[to]
1173                 ) {
1174                     require(
1175                         amount <= maxTransactionAmount,
1176                         "Buy transfer amount exceeds the maxTransactionAmount."
1177                     );
1178                     require(
1179                         amount + balanceOf(to) <= maxWallet,
1180                         "Max wallet exceeded"
1181                     );
1182                 }
1183                 //when sell
1184                 else if (
1185                     automatedMarketMakerPairs[to] &&
1186                     !_isExcludedMaxTransactionAmount[from]
1187                 ) {
1188                     require(
1189                         amount <= maxTransactionAmount,
1190                         "Sell transfer amount exceeds the maxTransactionAmount."
1191                     );
1192                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1193                     require(
1194                         amount + balanceOf(to) <= maxWallet,
1195                         "Max wallet exceeded"
1196                     );
1197                 }
1198             }
1199         }
1200 
1201         uint256 contractTokenBalance = balanceOf(address(this));
1202 
1203         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1204 
1205         if (
1206             canSwap &&
1207             swapEnabled &&
1208             !swapping &&
1209             !automatedMarketMakerPairs[from] &&
1210             !_isExcludedFromFees[from] &&
1211             !_isExcludedFromFees[to]
1212         ) {
1213             swapping = true;
1214 
1215             swapBack();
1216 
1217             swapping = false;
1218         }
1219 
1220         if (
1221             !swapping &&
1222             automatedMarketMakerPairs[to] &&
1223             lpBurnEnabled &&
1224             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1225             !_isExcludedFromFees[from]
1226         ) {
1227             autoBurnLiquidityPairTokens();
1228         }
1229 
1230         bool takeFee = !swapping;
1231 
1232         // if any account belongs to _isExcludedFromFee account then remove the fee
1233         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1234             takeFee = false;
1235         }
1236 
1237         uint256 fees = 0;
1238         // only take fees on buys/sells, do not take on wallet transfers
1239         if (takeFee) {
1240             // on sell
1241             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1242                 fees = amount.mul(sellTotalFees).div(100);
1243                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1244                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1245                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1246             }
1247             // on buy
1248             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1249                 fees = amount.mul(buyTotalFees).div(100);
1250                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1251                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1252                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1253             }
1254 
1255             if (fees > 0) {
1256                 super._transfer(from, address(this), fees);
1257             }
1258 
1259             amount -= fees;
1260         }
1261 
1262         super._transfer(from, to, amount);
1263     }
1264 
1265     function swapTokensForEth(uint256 tokenAmount) private {
1266         // generate the uniswap pair path of token -> weth
1267         address[] memory path = new address[](2);
1268         path[0] = address(this);
1269         path[1] = uniswapV2Router.WETH();
1270 
1271         _approve(address(this), address(uniswapV2Router), tokenAmount);
1272 
1273         // make the swap
1274         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1275             tokenAmount,
1276             0, // accept any amount of ETH
1277             path,
1278             address(this),
1279             block.timestamp
1280         );
1281     }
1282 
1283     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1284         // approve token transfer to cover all possible scenarios
1285         _approve(address(this), address(uniswapV2Router), tokenAmount);
1286 
1287         // add the liquidity
1288         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1289             address(this),
1290             tokenAmount,
1291             0, // slippage is unavoidable
1292             0, // slippage is unavoidable
1293             deadAddress,
1294             block.timestamp
1295         );
1296     }
1297 
1298     function swapBack() private {
1299         uint256 contractBalance = balanceOf(address(this));
1300         uint256 totalTokensToSwap = tokensForLiquidity +
1301             tokensForMarketing +
1302             tokensForDev;
1303         bool success;
1304 
1305         if (contractBalance == 0 || totalTokensToSwap == 0) {
1306             return;
1307         }
1308 
1309         if (contractBalance > swapTokensAtAmount * 20) {
1310             contractBalance = swapTokensAtAmount * 20;
1311         }
1312 
1313         // Halve the amount of liquidity tokens
1314         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1315             totalTokensToSwap /
1316             2;
1317         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1318 
1319         uint256 initialETHBalance = address(this).balance;
1320 
1321         swapTokensForEth(amountToSwapForETH);
1322 
1323         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1324 
1325         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1326             totalTokensToSwap
1327         );
1328         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1329 
1330         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1331 
1332         tokensForLiquidity = 0;
1333         tokensForMarketing = 0;
1334         tokensForDev = 0;
1335 
1336         (success, ) = address(devWallet).call{value: ethForDev}("");
1337 
1338         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1339             addLiquidity(liquidityTokens, ethForLiquidity);
1340             emit SwapAndLiquify(
1341                 amountToSwapForETH,
1342                 ethForLiquidity,
1343                 tokensForLiquidity
1344             );
1345         }
1346 
1347         (success, ) = address(marketingWallet).call{
1348             value: address(this).balance
1349         }("");
1350     }
1351 
1352     function setAutoLPBurnSettings(
1353         uint256 _frequencyInSeconds,
1354         uint256 _percent,
1355         bool _Enabled
1356     ) external onlyOwner {
1357         require(
1358             _frequencyInSeconds >= 600,
1359             "cannot set buyback more often than every 10 minutes"
1360         );
1361         require(
1362             _percent <= 1000 && _percent >= 0,
1363             "Must set auto LP burn percent between 0% and 10%"
1364         );
1365         lpBurnFrequency = _frequencyInSeconds;
1366         percentForLPBurn = _percent;
1367         lpBurnEnabled = _Enabled;
1368     }
1369 
1370     function autoBurnLiquidityPairTokens() internal returns (bool) {
1371         lastLpBurnTime = block.timestamp;
1372 
1373         // get balance of liquidity pair
1374         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1375 
1376         // calculate amount to burn
1377         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1378             10000
1379         );
1380 
1381         // pull tokens from pancakePair liquidity and move to dead address permanently
1382         if (amountToBurn > 0) {
1383             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1384         }
1385 
1386         //sync price since this is not in a swap transaction!
1387         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1388         pair.sync();
1389         emit AutoNukeLP();
1390         return true;
1391     }
1392 
1393     function manualBurnLiquidityPairTokens(uint256 percent)
1394         external
1395         onlyOwner
1396         returns (bool)
1397     {
1398         require(
1399             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1400             "Must wait for cooldown to finish"
1401         );
1402         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1403         lastManualLpBurnTime = block.timestamp;
1404 
1405         // get balance of liquidity pair
1406         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1407 
1408         // calculate amount to burn
1409         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1410 
1411         // pull tokens from pancakePair liquidity and move to dead address permanently
1412         if (amountToBurn > 0) {
1413             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1414         }
1415 
1416         //sync price since this is not in a swap transaction!
1417         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1418         pair.sync();
1419         emit ManualNukeLP();
1420         return true;
1421     }
1422 }