1 /*
2 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
3 
4 ██████╗░██╗░░░██╗██████╗░███╗░░██╗  ██╗░░░░░██╗███╗░░██╗██╗░░░██╗
5 ██╔══██╗██║░░░██║██╔══██╗████╗░██║  ██║░░░░░██║████╗░██║██║░░░██║
6 ██████╦╝██║░░░██║██████╔╝██╔██╗██║  ██║░░░░░██║██╔██╗██║██║░░░██║
7 ██╔══██╗██║░░░██║██╔══██╗██║╚████║  ██║░░░░░██║██║╚████║██║░░░██║
8 ██████╦╝╚██████╔╝██║░░██║██║░╚███║  ███████╗██║██║░╚███║╚██████╔╝
9 ╚═════╝░░╚═════╝░╚═╝░░╚═╝╚═╝░░╚══╝  ╚══════╝╚═╝╚═╝░░╚══╝░╚═════╝░
10                                                              
11 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
12 
13 /*
14  * https://t.me/BURNLINU
15  * https://twitter.com/BURNLINU
16  *
17  */
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity ^0.8.0;
22 
23 interface IUniswapV2Factory {
24     function createPair(address tokenA, address tokenB)
25         external
26         returns (address pair);
27 }
28 
29 interface IUniswapV2Router01 {
30     function factory() external pure returns (address);
31 
32     function WETH() external pure returns (address);
33 
34     function addLiquidityETH(
35         address token,
36         uint256 amountTokenDesired,
37         uint256 amountTokenMin,
38         uint256 amountETHMin,
39         address to,
40         uint256 deadline
41     )
42         external
43         payable
44         returns (
45             uint256 amountToken,
46             uint256 amountETH,
47             uint256 liquidity
48         );
49 }
50 
51 interface IUniswapV2Router02 is IUniswapV2Router01 {
52     function swapExactTokensForETHSupportingFeeOnTransferTokens(
53         uint256 amountIn,
54         uint256 amountOutMin,
55         address[] calldata path,
56         address to,
57         uint256 deadline
58     ) external;
59 }
60 
61 interface IUniswapV2Pair {
62     function sync() external;
63 }
64 
65 /**
66  * @dev Provides information about the current execution context, including the
67  * sender of the transaction and its data. While these are generally available
68  * via msg.sender and msg.data, they should not be accessed in such a direct
69  * manner, since when dealing with meta-transactions the account sending and
70  * paying for execution may not be the actual sender (as far as an application
71  * is concerned).
72  *
73  * This contract is only required for intermediate, library-like contracts.
74  */
75 abstract contract Context {
76     function _msgSender() internal view virtual returns (address) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes calldata) {
81         return msg.data;
82     }
83 }
84 
85 /**
86  * @dev Contract module which provides a basic access control mechanism, where
87  * there is an account (an owner) that can be granted exclusive access to
88  * specific functions.
89  *
90  * By default, the owner account will be the one that deploys the contract. This
91  * can later be changed with {transferOwnership}.
92  *
93  * This module is used through inheritance. It will make available the modifier
94  * `onlyOwner`, which can be applied to your functions to restrict their use to
95  * the owner.
96  */
97 abstract contract Ownable is Context {
98     address private _owner;
99 
100     event OwnershipTransferred(
101         address indexed previousOwner,
102         address indexed newOwner
103     );
104 
105     /**
106      * @dev Initializes the contract setting the deployer as the initial owner.
107      */
108     constructor() {
109         _transferOwnership(_msgSender());
110     }
111 
112     /**
113      * @dev Returns the address of the current owner.
114      */
115     function owner() public view virtual returns (address) {
116         return _owner;
117     }
118 
119     /**
120      * @dev Throws if called by any account other than the owner.
121      */
122     modifier onlyOwner() {
123         require(owner() == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126 
127     /**
128      * @dev Leaves the contract without owner. It will not be possible to call
129      * `onlyOwner` functions anymore. Can only be called by the current owner.
130      *
131      * NOTE: Renouncing ownership will leave the contract without an owner,
132      * thereby removing any functionality that is only available to the owner.
133      */
134     function renounceOwnership() public virtual onlyOwner {
135         _transferOwnership(address(0));
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      * Can only be called by the current owner.
141      */
142     function transferOwnership(address newOwner) public virtual onlyOwner {
143         require(
144             newOwner != address(0),
145             "Ownable: new owner is the zero address"
146         );
147         _transferOwnership(newOwner);
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Internal function without access restriction.
153      */
154     function _transferOwnership(address newOwner) internal virtual {
155         address oldOwner = _owner;
156         _owner = newOwner;
157         emit OwnershipTransferred(oldOwner, newOwner);
158     }
159 }
160 
161 /**
162  * @dev Interface of the ERC20 standard as defined in the EIP.
163  */
164 interface IERC20 {
165     /**
166      * @dev Returns the amount of tokens in existence.
167      */
168     function totalSupply() external view returns (uint256);
169 
170     /**
171      * @dev Returns the amount of tokens owned by `account`.
172      */
173     function balanceOf(address account) external view returns (uint256);
174 
175     /**
176      * @dev Moves `amount` tokens from the caller's account to `recipient`.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transfer(address recipient, uint256 amount)
183         external
184         returns (bool);
185 
186     /**
187      * @dev Returns the remaining number of tokens that `spender` will be
188      * allowed to spend on behalf of `owner` through {transferFrom}. This is
189      * zero by default.
190      *
191      * This value changes when {approve} or {transferFrom} are called.
192      */
193     function allowance(address owner, address spender)
194         external
195         view
196         returns (uint256);
197 
198     /**
199      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * IMPORTANT: Beware that changing an allowance with this method brings the risk
204      * that someone may use both the old and the new allowance by unfortunate
205      * transaction ordering. One possible solution to mitigate this race
206      * condition is to first reduce the spender's allowance to 0 and set the
207      * desired value afterwards:
208      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209      *
210      * Emits an {Approval} event.
211      */
212     function approve(address spender, uint256 amount) external returns (bool);
213 
214     /**
215      * @dev Moves `amount` tokens from `sender` to `recipient` using the
216      * allowance mechanism. `amount` is then deducted from the caller's
217      * allowance.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transferFrom(
224         address sender,
225         address recipient,
226         uint256 amount
227     ) external returns (bool);
228 
229     /**
230      * @dev Emitted when `value` tokens are moved from one account (`from`) to
231      * another (`to`).
232      *
233      * Note that `value` may be zero.
234      */
235     event Transfer(address indexed from, address indexed to, uint256 value);
236 
237     /**
238      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
239      * a call to {approve}. `value` is the new allowance.
240      */
241     event Approval(
242         address indexed owner,
243         address indexed spender,
244         uint256 value
245     );
246 }
247 
248 /**
249  * @dev Interface for the optional metadata functions from the ERC20 standard.
250  *
251  * _Available since v4.1._
252  */
253 interface IERC20Metadata is IERC20 {
254     /**
255      * @dev Returns the name of the token.
256      */
257     function name() external view returns (string memory);
258 
259     /**
260      * @dev Returns the symbol of the token.
261      */
262     function symbol() external view returns (string memory);
263 
264     /**
265      * @dev Returns the decimals places of the token.
266      */
267     function decimals() external view returns (uint8);
268 }
269 
270 /**
271  * @dev Implementation of the {IERC20} interface.
272  *
273  * This implementation is agnostic to the way tokens are created. This means
274  * that a supply mechanism has to be added in a derived contract using {_mint}.
275  * For a generic mechanism see {ERC20PresetMinterPauser}.
276  *
277  * TIP: For a detailed writeup see our guide
278  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
279  * to implement supply mechanisms].
280  *
281  * We have followed general OpenZeppelin Contracts guidelines: functions revert
282  * instead returning `false` on failure. This behavior is nonetheless
283  * conventional and does not conflict with the expectations of ERC20
284  * applications.
285  *
286  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
287  * This allows applications to reconstruct the allowance for all accounts just
288  * by listening to said events. Other implementations of the EIP may not emit
289  * these events, as it isn't required by the specification.
290  *
291  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
292  * functions have been added to mitigate the well-known issues around setting
293  * allowances. See {IERC20-approve}.
294  */
295 contract ERC20 is Context, IERC20, IERC20Metadata {
296     mapping(address => uint256) private _balances;
297 
298     mapping(address => mapping(address => uint256)) private _allowances;
299 
300     uint256 private _totalSupply;
301 
302     string private _name;
303     string private _symbol;
304 
305     /**
306      * @dev Sets the values for {name} and {symbol}.
307      *
308      * The default value of {decimals} is 18. To select a different value for
309      * {decimals} you should overload it.
310      *
311      * All two of these values are immutable: they can only be set once during
312      * construction.
313      */
314     constructor(string memory name_, string memory symbol_) {
315         _name = name_;
316         _symbol = symbol_;
317     }
318 
319     /**
320      * @dev Returns the name of the token.
321      */
322     function name() public view virtual override returns (string memory) {
323         return _name;
324     }
325 
326     /**
327      * @dev Returns the symbol of the token, usually a shorter version of the
328      * name.
329      */
330     function symbol() public view virtual override returns (string memory) {
331         return _symbol;
332     }
333 
334     /**
335      * @dev Returns the number of decimals used to get its user representation.
336      * For example, if `decimals` equals `2`, a balance of `505` tokens should
337      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
338      *
339      * Tokens usually opt for a value of 18, imitating the relationship between
340      * Ether and Wei. This is the value {ERC20} uses, unless this function is
341      * overridden;
342      *
343      * NOTE: This information is only used for _display_ purposes: it in
344      * no way affects any of the arithmetic of the contract, including
345      * {IERC20-balanceOf} and {IERC20-transfer}.
346      */
347     function decimals() public view virtual override returns (uint8) {
348         return 18;
349     }
350 
351     /**
352      * @dev See {IERC20-totalSupply}.
353      */
354     function totalSupply() public view virtual override returns (uint256) {
355         return _totalSupply;
356     }
357 
358     /**
359      * @dev See {IERC20-balanceOf}.
360      */
361     function balanceOf(address account)
362         public
363         view
364         virtual
365         override
366         returns (uint256)
367     {
368         return _balances[account];
369     }
370 
371     /**
372      * @dev See {IERC20-transfer}.
373      *
374      * Requirements:
375      *
376      * - `recipient` cannot be the zero address.
377      * - the caller must have a balance of at least `amount`.
378      */
379     function transfer(address recipient, uint256 amount)
380         public
381         virtual
382         override
383         returns (bool)
384     {
385         _transfer(_msgSender(), recipient, amount);
386         return true;
387     }
388 
389     /**
390      * @dev See {IERC20-allowance}.
391      */
392     function allowance(address owner, address spender)
393         public
394         view
395         virtual
396         override
397         returns (uint256)
398     {
399         return _allowances[owner][spender];
400     }
401 
402     /**
403      * @dev See {IERC20-approve}.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function approve(address spender, uint256 amount)
410         public
411         virtual
412         override
413         returns (bool)
414     {
415         _approve(_msgSender(), spender, amount);
416         return true;
417     }
418 
419     /**
420      * @dev See {IERC20-transferFrom}.
421      *
422      * Emits an {Approval} event indicating the updated allowance. This is not
423      * required by the EIP. See the note at the beginning of {ERC20}.
424      *
425      * Requirements:
426      *
427      * - `sender` and `recipient` cannot be the zero address.
428      * - `sender` must have a balance of at least `amount`.
429      * - the caller must have allowance for ``sender``'s tokens of at least
430      * `amount`.
431      */
432     function transferFrom(
433         address sender,
434         address recipient,
435         uint256 amount
436     ) public virtual override returns (bool) {
437         _transfer(sender, recipient, amount);
438 
439         uint256 currentAllowance = _allowances[sender][_msgSender()];
440         require(
441             currentAllowance >= amount,
442             "ERC20: transfer amount exceeds allowance"
443         );
444         unchecked {
445             _approve(sender, _msgSender(), currentAllowance - amount);
446         }
447 
448         return true;
449     }
450 
451     /**
452      * @dev Atomically increases the allowance granted to `spender` by the caller.
453      *
454      * This is an alternative to {approve} that can be used as a mitigation for
455      * problems described in {IERC20-approve}.
456      *
457      * Emits an {Approval} event indicating the updated allowance.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      */
463     function increaseAllowance(address spender, uint256 addedValue)
464         public
465         virtual
466         returns (bool)
467     {
468         _approve(
469             _msgSender(),
470             spender,
471             _allowances[_msgSender()][spender] + addedValue
472         );
473         return true;
474     }
475 
476     /**
477      * @dev Atomically decreases the allowance granted to `spender` by the caller.
478      *
479      * This is an alternative to {approve} that can be used as a mitigation for
480      * problems described in {IERC20-approve}.
481      *
482      * Emits an {Approval} event indicating the updated allowance.
483      *
484      * Requirements:
485      *
486      * - `spender` cannot be the zero address.
487      * - `spender` must have allowance for the caller of at least
488      * `subtractedValue`.
489      */
490     function decreaseAllowance(address spender, uint256 subtractedValue)
491         public
492         virtual
493         returns (bool)
494     {
495         uint256 currentAllowance = _allowances[_msgSender()][spender];
496         require(
497             currentAllowance >= subtractedValue,
498             "ERC20: decreased allowance below zero"
499         );
500         unchecked {
501             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
502         }
503 
504         return true;
505     }
506 
507     /**
508      * @dev Moves `amount` of tokens from `sender` to `recipient`.
509      *
510      * This internal function is equivalent to {transfer}, and can be used to
511      * e.g. implement automatic token fees, slashing mechanisms, etc.
512      *
513      * Emits a {Transfer} event.
514      *
515      * Requirements:
516      *
517      * - `sender` cannot be the zero address.
518      * - `recipient` cannot be the zero address.
519      * - `sender` must have a balance of at least `amount`.
520      */
521     function _transfer(
522         address sender,
523         address recipient,
524         uint256 amount
525     ) internal virtual {
526         require(sender != address(0), "ERC20: transfer from the zero address");
527         require(recipient != address(0), "ERC20: transfer to the zero address");
528 
529         _beforeTokenTransfer(sender, recipient, amount);
530 
531         uint256 senderBalance = _balances[sender];
532         require(
533             senderBalance >= amount,
534             "ERC20: transfer amount exceeds balance"
535         );
536         unchecked {
537             _balances[sender] = senderBalance - amount;
538         }
539         _balances[recipient] += amount;
540 
541         emit Transfer(sender, recipient, amount);
542 
543         _afterTokenTransfer(sender, recipient, amount);
544     }
545 
546     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
547      * the total supply.
548      *
549      * Emits a {Transfer} event with `from` set to the zero address.
550      *
551      * Requirements:
552      *
553      * - `account` cannot be the zero address.
554      */
555     function _mint(address account, uint256 amount) internal virtual {
556         require(account != address(0), "ERC20: mint to the zero address");
557 
558         _beforeTokenTransfer(address(0), account, amount);
559 
560         _totalSupply += amount;
561         _balances[account] += amount;
562         emit Transfer(address(0), account, amount);
563 
564         _afterTokenTransfer(address(0), account, amount);
565     }
566 
567     /**
568      * @dev Destroys `amount` tokens from `account`, reducing the
569      * total supply.
570      *
571      * Emits a {Transfer} event with `to` set to the zero address.
572      *
573      * Requirements:
574      *
575      * - `account` cannot be the zero address.
576      * - `account` must have at least `amount` tokens.
577      */
578     function _burn(address account, uint256 amount) internal virtual {
579         require(account != address(0), "ERC20: burn from the zero address");
580 
581         _beforeTokenTransfer(account, address(0), amount);
582 
583         uint256 accountBalance = _balances[account];
584         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
585         unchecked {
586             _balances[account] = accountBalance - amount;
587         }
588         _totalSupply -= amount;
589 
590         emit Transfer(account, address(0), amount);
591 
592         _afterTokenTransfer(account, address(0), amount);
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
627      * will be transferred to `to`.
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
639 
640     /**
641      * @dev Hook that is called after any transfer of tokens. This includes
642      * minting and burning.
643      *
644      * Calling conditions:
645      *
646      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
647      * has been transferred to `to`.
648      * - when `from` is zero, `amount` tokens have been minted for `to`.
649      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
650      * - `from` and `to` are never both zero.
651      *
652      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
653      */
654     function _afterTokenTransfer(
655         address from,
656         address to,
657         uint256 amount
658     ) internal virtual {}
659 }
660 
661 // CAUTION
662 // This version of SafeMath should only be used with Solidity 0.8 or later,
663 // because it relies on the compiler's built in overflow checks.
664 
665 /**
666  * @dev Wrappers over Solidity's arithmetic operations.
667  *
668  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
669  * now has built in overflow checking.
670  */
671 library SafeMath {
672     /**
673      * @dev Returns the addition of two unsigned integers, with an overflow flag.
674      *
675      * _Available since v3.4._
676      */
677     function tryAdd(uint256 a, uint256 b)
678         internal
679         pure
680         returns (bool, uint256)
681     {
682         unchecked {
683             uint256 c = a + b;
684             if (c < a) return (false, 0);
685             return (true, c);
686         }
687     }
688 
689     /**
690      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
691      *
692      * _Available since v3.4._
693      */
694     function trySub(uint256 a, uint256 b)
695         internal
696         pure
697         returns (bool, uint256)
698     {
699         unchecked {
700             if (b > a) return (false, 0);
701             return (true, a - b);
702         }
703     }
704 
705     /**
706      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
707      *
708      * _Available since v3.4._
709      */
710     function tryMul(uint256 a, uint256 b)
711         internal
712         pure
713         returns (bool, uint256)
714     {
715         unchecked {
716             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
717             // benefit is lost if 'b' is also tested.
718             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
719             if (a == 0) return (true, 0);
720             uint256 c = a * b;
721             if (c / a != b) return (false, 0);
722             return (true, c);
723         }
724     }
725 
726     /**
727      * @dev Returns the division of two unsigned integers, with a division by zero flag.
728      *
729      * _Available since v3.4._
730      */
731     function tryDiv(uint256 a, uint256 b)
732         internal
733         pure
734         returns (bool, uint256)
735     {
736         unchecked {
737             if (b == 0) return (false, 0);
738             return (true, a / b);
739         }
740     }
741 
742     /**
743      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
744      *
745      * _Available since v3.4._
746      */
747     function tryMod(uint256 a, uint256 b)
748         internal
749         pure
750         returns (bool, uint256)
751     {
752         unchecked {
753             if (b == 0) return (false, 0);
754             return (true, a % b);
755         }
756     }
757 
758     /**
759      * @dev Returns the addition of two unsigned integers, reverting on
760      * overflow.
761      *
762      * Counterpart to Solidity's `+` operator.
763      *
764      * Requirements:
765      *
766      * - Addition cannot overflow.
767      */
768     function add(uint256 a, uint256 b) internal pure returns (uint256) {
769         return a + b;
770     }
771 
772     /**
773      * @dev Returns the subtraction of two unsigned integers, reverting on
774      * overflow (when the result is negative).
775      *
776      * Counterpart to Solidity's `-` operator.
777      *
778      * Requirements:
779      *
780      * - Subtraction cannot overflow.
781      */
782     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
783         return a - b;
784     }
785 
786     /**
787      * @dev Returns the multiplication of two unsigned integers, reverting on
788      * overflow.
789      *
790      * Counterpart to Solidity's `*` operator.
791      *
792      * Requirements:
793      *
794      * - Multiplication cannot overflow.
795      */
796     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
797         return a * b;
798     }
799 
800     /**
801      * @dev Returns the integer division of two unsigned integers, reverting on
802      * division by zero. The result is rounded towards zero.
803      *
804      * Counterpart to Solidity's `/` operator.
805      *
806      * Requirements:
807      *
808      * - The divisor cannot be zero.
809      */
810     function div(uint256 a, uint256 b) internal pure returns (uint256) {
811         return a / b;
812     }
813 
814     /**
815      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
816      * reverting when dividing by zero.
817      *
818      * Counterpart to Solidity's `%` operator. This function uses a `revert`
819      * opcode (which leaves remaining gas untouched) while Solidity uses an
820      * invalid opcode to revert (consuming all remaining gas).
821      *
822      * Requirements:
823      *
824      * - The divisor cannot be zero.
825      */
826     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
827         return a % b;
828     }
829 
830     /**
831      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
832      * overflow (when the result is negative).
833      *
834      * CAUTION: This function is deprecated because it requires allocating memory for the error
835      * message unnecessarily. For custom revert reasons use {trySub}.
836      *
837      * Counterpart to Solidity's `-` operator.
838      *
839      * Requirements:
840      *
841      * - Subtraction cannot overflow.
842      */
843     function sub(
844         uint256 a,
845         uint256 b,
846         string memory errorMessage
847     ) internal pure returns (uint256) {
848         unchecked {
849             require(b <= a, errorMessage);
850             return a - b;
851         }
852     }
853 
854     /**
855      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
856      * division by zero. The result is rounded towards zero.
857      *
858      * Counterpart to Solidity's `/` operator. Note: this function uses a
859      * `revert` opcode (which leaves remaining gas untouched) while Solidity
860      * uses an invalid opcode to revert (consuming all remaining gas).
861      *
862      * Requirements:
863      *
864      * - The divisor cannot be zero.
865      */
866     function div(
867         uint256 a,
868         uint256 b,
869         string memory errorMessage
870     ) internal pure returns (uint256) {
871         unchecked {
872             require(b > 0, errorMessage);
873             return a / b;
874         }
875     }
876 
877     /**
878      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
879      * reverting with custom message when dividing by zero.
880      *
881      * CAUTION: This function is deprecated because it requires allocating memory for the error
882      * message unnecessarily. For custom revert reasons use {tryMod}.
883      *
884      * Counterpart to Solidity's `%` operator. This function uses a `revert`
885      * opcode (which leaves remaining gas untouched) while Solidity uses an
886      * invalid opcode to revert (consuming all remaining gas).
887      *
888      * Requirements:
889      *
890      * - The divisor cannot be zero.
891      */
892     function mod(
893         uint256 a,
894         uint256 b,
895         string memory errorMessage
896     ) internal pure returns (uint256) {
897         unchecked {
898             require(b > 0, errorMessage);
899             return a % b;
900         }
901     }
902 }
903 
904 contract BurnLinu is ERC20, Ownable {
905     using SafeMath for uint256;
906 
907     IUniswapV2Router02 public immutable uniswapV2Router;
908     address public uniswapV2Pair;
909     address public constant deadAddress = address(0xdead);
910 
911     bool private swapping;
912 
913     address public marketingWallet;
914     address public devWallet;
915 
916     uint256 public maxTransactionAmount;
917     uint256 public swapTokensAtAmount;
918     uint256 public maxWallet;
919 
920     uint256 public percentForLPBurn = 20; // 20 = .20%
921     bool public lpBurnEnabled = true;
922     uint256 public lpBurnFrequency = 3600 seconds;
923     uint256 public lastLpBurnTime;
924 
925     uint256 public manualBurnFrequency = 30 minutes;
926     uint256 public lastManualLpBurnTime;
927 
928     bool public limitsInEffect = true;
929     bool public tradingActive = false;
930     bool public swapEnabled = false;
931 
932     // Anti-bot and anti-whale mappings and variables
933     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
934     bool public transferDelayEnabled = true;
935 
936     uint256 public buyTotalFees;
937     uint256 public constant buyMarketingFee = 7;
938     uint256 public constant buyLiquidityFee = 3;
939     uint256 public constant buyDevFee = 0;
940 
941     uint256 public sellTotalFees;
942     uint256 public constant sellMarketingFee = 8;
943     uint256 public constant sellLiquidityFee = 2;
944     uint256 public constant sellDevFee = 0;
945 
946     uint256 public tokensForMarketing;
947     uint256 public tokensForLiquidity;
948     uint256 public tokensForDev;
949 
950     /******************/
951 
952     // exlcude from fees and max transaction amount
953     mapping(address => bool) private _isExcludedFromFees;
954     mapping(address => bool) public _isExcludedMaxTransactionAmount;
955 
956     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
957     // could be subject to a maximum transfer amount
958     mapping(address => bool) public automatedMarketMakerPairs;
959 
960     event UpdateUniswapV2Router(
961         address indexed newAddress,
962         address indexed oldAddress
963     );
964 
965     event ExcludeFromFees(address indexed account, bool isExcluded);
966 
967     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
968 
969     event marketingWalletUpdated(
970         address indexed newWallet,
971         address indexed oldWallet
972     );
973 
974     event devWalletUpdated(
975         address indexed newWallet,
976         address indexed oldWallet
977     );
978 
979     event SwapAndLiquify(
980         uint256 tokensSwapped,
981         uint256 ethReceived,
982         uint256 tokensIntoLiquidity
983     );
984 
985     event AutoNukeLP();
986 
987     event ManualNukeLP();
988 
989     event BoughtEarly(address indexed sniper);
990 
991     constructor() ERC20("BURN LINU", "BLINU") {
992         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
993             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
994         );
995 
996         excludeFromMaxTransaction(address(_uniswapV2Router), true);
997         uniswapV2Router = _uniswapV2Router;
998 
999         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1000             .createPair(address(this), _uniswapV2Router.WETH());
1001         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1002         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1003 
1004         uint256 totalSupply = 1_000_000_000 * 1e18; // 1 billion total supply
1005 
1006         maxTransactionAmount = 15_000_000 * 1e18; // 1.5% from total supply maxTransactionAmountTxn
1007         maxWallet = 30_000_000 * 1e18; // 3% from total supply maxWallet
1008         swapTokensAtAmount = (totalSupply * 3) / 10000; // 0.03% swap wallet
1009 
1010         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1011         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1012 
1013         marketingWallet = address(0x262Fdf6af31e7f9a6288659A0FD30D3ea66b47e6); // set as marketing wallet
1014         devWallet = address(0x6C90E754Cd94C27C51b6D02109E24C843D76B351); // set as dev wallet
1015 
1016         // exclude from paying fees or having max transaction amount
1017         excludeFromFees(owner(), true);
1018         excludeFromFees(address(this), true);
1019         excludeFromFees(address(0xdead), true);
1020 
1021         excludeFromMaxTransaction(owner(), true);
1022         excludeFromMaxTransaction(address(this), true);
1023         excludeFromMaxTransaction(address(0xdead), true);
1024 
1025         /*
1026             _mint is an internal function in ERC20.sol that is only called here,
1027             and CANNOT be called ever again
1028         */
1029         _mint(msg.sender, totalSupply);
1030     }
1031 
1032     receive() external payable {}
1033 
1034     // once enabled, can never be turned off
1035     function startTrading() external onlyOwner {
1036         tradingActive = true;
1037         swapEnabled = true;
1038         lastLpBurnTime = block.timestamp;
1039     }
1040 
1041     // remove limits after token is stable
1042     function removeLimits() external onlyOwner returns (bool) {
1043         limitsInEffect = false;
1044         return true;
1045     }
1046 
1047     // disable Transfer delay - cannot be reenabled
1048     function disableTransferDelay() external onlyOwner returns (bool) {
1049         transferDelayEnabled = false;
1050         return true;
1051     }
1052 
1053     // change the minimum amount of tokens to sell from fees
1054     function updateSwapTokensAtAmount(uint256 newAmount)
1055         external
1056         onlyOwner
1057         returns (bool)
1058     {
1059         require(
1060             newAmount >= (totalSupply() * 1) / 100000,
1061             "Swap amount cannot be lower than 0.001% total supply."
1062         );
1063         require(
1064             newAmount <= (totalSupply() * 5) / 1000,
1065             "Swap amount cannot be higher than 0.5% total supply."
1066         );
1067         swapTokensAtAmount = newAmount;
1068         return true;
1069     }
1070 
1071     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1072         require(
1073             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1074             "Cannot set maxTransactionAmount lower than 0.1%"
1075         );
1076         maxTransactionAmount = newNum * (10**18);
1077     }
1078 
1079     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1080         require(
1081             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1082             "Cannot set maxWallet lower than 0.5%"
1083         );
1084         maxWallet = newNum * (10**18);
1085     }
1086 
1087     function excludeFromMaxTransaction(address updAds, bool isEx)
1088         public
1089         onlyOwner
1090     {
1091         _isExcludedMaxTransactionAmount[updAds] = isEx;
1092     }
1093 
1094     // only use to disable contract sales if absolutely necessary (emergency use only)
1095     function updateSwapEnabled(bool enabled) external onlyOwner {
1096         swapEnabled = enabled;
1097     }
1098 
1099     function excludeFromFees(address account, bool excluded) public onlyOwner {
1100         _isExcludedFromFees[account] = excluded;
1101         emit ExcludeFromFees(account, excluded);
1102     }
1103 
1104     function setAutomatedMarketMakerPair(address pair, bool value)
1105         public
1106         onlyOwner
1107     {
1108         require(
1109             pair != uniswapV2Pair,
1110             "The pair cannot be removed from automatedMarketMakerPairs"
1111         );
1112 
1113         _setAutomatedMarketMakerPair(pair, value);
1114     }
1115 
1116     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1117         automatedMarketMakerPairs[pair] = value;
1118 
1119         emit SetAutomatedMarketMakerPair(pair, value);
1120     }
1121 
1122     function updateMarketingWallet(address newMarketingWallet)
1123         external
1124         onlyOwner
1125     {
1126         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1127         marketingWallet = newMarketingWallet;
1128     }
1129 
1130     function updateDevWallet(address newWallet) external onlyOwner {
1131         emit devWalletUpdated(newWallet, devWallet);
1132         devWallet = newWallet;
1133     }
1134 
1135     function isExcludedFromFees(address account) public view returns (bool) {
1136         return _isExcludedFromFees[account];
1137     }
1138 
1139     function _transfer(
1140         address from,
1141         address to,
1142         uint256 amount
1143     ) internal override {
1144         require(from != address(0), "ERC20: transfer from the zero address");
1145         require(to != address(0), "ERC20: transfer to the zero address");
1146 
1147         if (amount == 0) {
1148             super._transfer(from, to, 0);
1149             return;
1150         }
1151 
1152         if (limitsInEffect) {
1153             if (
1154                 from != owner() &&
1155                 to != owner() &&
1156                 to != address(0) &&
1157                 to != address(0xdead) &&
1158                 !swapping
1159             ) {
1160                 if (!tradingActive) {
1161                     require(
1162                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1163                         "Trading is not active."
1164                     );
1165                 }
1166 
1167                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1168                 if (transferDelayEnabled) {
1169                     if (
1170                         to != owner() &&
1171                         to != address(uniswapV2Router) &&
1172                         to != address(uniswapV2Pair)
1173                     ) {
1174                         require(
1175                             _holderLastTransferTimestamp[tx.origin] <
1176                                 block.number,
1177                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1178                         );
1179                         _holderLastTransferTimestamp[tx.origin] = block.number;
1180                     }
1181                 }
1182 
1183                 //when buy
1184                 if (
1185                     automatedMarketMakerPairs[from] &&
1186                     !_isExcludedMaxTransactionAmount[to]
1187                 ) {
1188                     require(
1189                         amount <= maxTransactionAmount,
1190                         "Buy transfer amount exceeds the maxTransactionAmount."
1191                     );
1192                     require(
1193                         amount + balanceOf(to) <= maxWallet,
1194                         "Max wallet exceeded"
1195                     );
1196                 }
1197                 //when sell
1198                 else if (
1199                     automatedMarketMakerPairs[to] &&
1200                     !_isExcludedMaxTransactionAmount[from]
1201                 ) {
1202                     require(
1203                         amount <= maxTransactionAmount,
1204                         "Sell transfer amount exceeds the maxTransactionAmount."
1205                     );
1206                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1207                     require(
1208                         amount + balanceOf(to) <= maxWallet,
1209                         "Max wallet exceeded"
1210                     );
1211                 }
1212             }
1213         }
1214 
1215         uint256 contractTokenBalance = balanceOf(address(this));
1216 
1217         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1218 
1219         if (
1220             canSwap &&
1221             swapEnabled &&
1222             !swapping &&
1223             !automatedMarketMakerPairs[from] &&
1224             !_isExcludedFromFees[from] &&
1225             !_isExcludedFromFees[to]
1226         ) {
1227             swapping = true;
1228 
1229             swapBack();
1230 
1231             swapping = false;
1232         }
1233 
1234         if (
1235             !swapping &&
1236             automatedMarketMakerPairs[to] &&
1237             lpBurnEnabled &&
1238             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1239             !_isExcludedFromFees[from]
1240         ) {
1241             autoBurnLiquidityPairTokens();
1242         }
1243 
1244         bool takeFee = !swapping;
1245 
1246         // if any account belongs to _isExcludedFromFee account then remove the fee
1247         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1248             takeFee = false;
1249         }
1250 
1251         uint256 fees = 0;
1252         // only take fees on buys/sells, do not take on wallet transfers
1253         if (takeFee) {
1254             // on sell
1255             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1256                 fees = amount.mul(sellTotalFees).div(100);
1257                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1258                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1259                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1260             }
1261             // on buy
1262             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1263                 fees = amount.mul(buyTotalFees).div(100);
1264                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1265                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1266                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1267             }
1268 
1269             if (fees > 0) {
1270                 super._transfer(from, address(this), fees);
1271             }
1272 
1273             amount -= fees;
1274         }
1275 
1276         super._transfer(from, to, amount);
1277     }
1278 
1279     function swapTokensForEth(uint256 tokenAmount) private {
1280         // generate the uniswap pair path of token -> weth
1281         address[] memory path = new address[](2);
1282         path[0] = address(this);
1283         path[1] = uniswapV2Router.WETH();
1284 
1285         _approve(address(this), address(uniswapV2Router), tokenAmount);
1286 
1287         // make the swap
1288         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1289             tokenAmount,
1290             0, // accept any amount of ETH
1291             path,
1292             address(this),
1293             block.timestamp
1294         );
1295     }
1296 
1297     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1298         // approve token transfer to cover all possible scenarios
1299         _approve(address(this), address(uniswapV2Router), tokenAmount);
1300 
1301         // add the liquidity
1302         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1303             address(this),
1304             tokenAmount,
1305             0, // slippage is unavoidable
1306             0, // slippage is unavoidable
1307             deadAddress,
1308             block.timestamp
1309         );
1310     }
1311 
1312     function swapBack() private {
1313         uint256 contractBalance = balanceOf(address(this));
1314         uint256 totalTokensToSwap = tokensForLiquidity +
1315             tokensForMarketing +
1316             tokensForDev;
1317         bool success;
1318 
1319         if (contractBalance == 0 || totalTokensToSwap == 0) {
1320             return;
1321         }
1322 
1323         if (contractBalance > swapTokensAtAmount * 20) {
1324             contractBalance = swapTokensAtAmount * 20;
1325         }
1326 
1327         // Halve the amount of liquidity tokens
1328         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1329             totalTokensToSwap /
1330             2;
1331         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1332 
1333         uint256 initialETHBalance = address(this).balance;
1334 
1335         swapTokensForEth(amountToSwapForETH);
1336 
1337         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1338 
1339         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1340             totalTokensToSwap
1341         );
1342         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1343 
1344         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1345 
1346         tokensForLiquidity = 0;
1347         tokensForMarketing = 0;
1348         tokensForDev = 0;
1349 
1350         (success, ) = address(devWallet).call{value: ethForDev}("");
1351 
1352         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1353             addLiquidity(liquidityTokens, ethForLiquidity);
1354             emit SwapAndLiquify(
1355                 amountToSwapForETH,
1356                 ethForLiquidity,
1357                 tokensForLiquidity
1358             );
1359         }
1360 
1361         (success, ) = address(marketingWallet).call{
1362             value: address(this).balance
1363         }("");
1364     }
1365 
1366     function setAutoLPBurnSettings(
1367         uint256 _frequencyInSeconds,
1368         uint256 _percent,
1369         bool _Enabled
1370     ) external onlyOwner {
1371         require(
1372             _frequencyInSeconds >= 600,
1373             "cannot set buyback more often than every 10 minutes"
1374         );
1375         require(
1376             _percent <= 1000 && _percent >= 0,
1377             "Must set auto LP burn percent between 0% and 10%"
1378         );
1379         lpBurnFrequency = _frequencyInSeconds;
1380         percentForLPBurn = _percent;
1381         lpBurnEnabled = _Enabled;
1382     }
1383 
1384     function autoBurnLiquidityPairTokens() internal returns (bool) {
1385         lastLpBurnTime = block.timestamp;
1386 
1387         // get balance of liquidity pair
1388         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1389 
1390         // calculate amount to burn
1391         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1392             10000
1393         );
1394 
1395         // pull tokens from pancakePair liquidity and move to dead address permanently
1396         if (amountToBurn > 0) {
1397             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1398         }
1399 
1400         //sync price since this is not in a swap transaction!
1401         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1402         pair.sync();
1403         emit AutoNukeLP();
1404         return true;
1405     }
1406 
1407     function manualBurnLiquidityPairTokens(uint256 percent)
1408         external
1409         onlyOwner
1410         returns (bool)
1411     {
1412         require(
1413             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1414             "Must wait for cooldown to finish"
1415         );
1416         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1417         lastManualLpBurnTime = block.timestamp;
1418 
1419         // get balance of liquidity pair
1420         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1421 
1422         // calculate amount to burn
1423         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1424 
1425         // pull tokens from pancakePair liquidity and move to dead address permanently
1426         if (amountToBurn > 0) {
1427             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1428         }
1429 
1430         //sync price since this is not in a swap transaction!
1431         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1432         pair.sync();
1433         emit ManualNukeLP();
1434         return true;
1435     }
1436 }