1 /*
2  * 
3 https://dejitaru-ha.com 
4 
5  TSUKA is the handle
6  HA is the blade
7  The Sword has been passed.
8  A swining sword with no vision draws air.
9  The vision has been inherited by the wyrmlings.
10 
11  Honor the Dragon
12  protect the Sangha.
13 
14 
15  */
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.8.0;
19 
20 interface IUniswapV2Factory {
21     function createPair(address tokenA, address tokenB)
22         external
23         returns (address pair);
24 }
25 
26 interface IUniswapV2Router01 {
27     function factory() external pure returns (address);
28 
29     function WETH() external pure returns (address);
30 
31     function addLiquidityETH(
32         address token,
33         uint256 amountTokenDesired,
34         uint256 amountTokenMin,
35         uint256 amountETHMin,
36         address to,
37         uint256 deadline
38     )
39         external
40         payable
41         returns (
42             uint256 amountToken,
43             uint256 amountETH,
44             uint256 liquidity
45         );
46 }
47 
48 interface IUniswapV2Router02 is IUniswapV2Router01 {
49     function swapExactTokensForETHSupportingFeeOnTransferTokens(
50         uint256 amountIn,
51         uint256 amountOutMin,
52         address[] calldata path,
53         address to,
54         uint256 deadline
55     ) external;
56 }
57 
58 interface IUniswapV2Pair {
59     function sync() external;
60 }
61 
62 /**
63  * @dev Provides information about the current execution context, including the
64  * sender of the transaction and its data. While these are generally available
65  * via msg.sender and msg.data, they should not be accessed in such a direct
66  * manner, since when dealing with meta-transactions the account sending and
67  * paying for execution may not be the actual sender (as far as an application
68  * is concerned).
69  *
70  * This contract is only required for intermediate, library-like contracts.
71  */
72 abstract contract Context {
73     function _msgSender() internal view virtual returns (address) {
74         return msg.sender;
75     }
76 
77     function _msgData() internal view virtual returns (bytes calldata) {
78         return msg.data;
79     }
80 }
81 
82 /**
83  * @dev Contract module which provides a basic access control mechanism, where
84  * there is an account (an owner) that can be granted exclusive access to
85  * specific functions.
86  *
87  * By default, the owner account will be the one that deploys the contract. This
88  * can later be changed with {transferOwnership}.
89  *
90  * This module is used through inheritance. It will make available the modifier
91  * `onlyOwner`, which can be applied to your functions to restrict their use to
92  * the owner.
93  */
94 abstract contract Ownable is Context {
95     address private _owner;
96 
97     event OwnershipTransferred(
98         address indexed previousOwner,
99         address indexed newOwner
100     );
101 
102     /**
103      * @dev Initializes the contract setting the deployer as the initial owner.
104      */
105     constructor() {
106         _transferOwnership(_msgSender());
107     }
108 
109     /**
110      * @dev Returns the address of the current owner.
111      */
112     function owner() public view virtual returns (address) {
113         return _owner;
114     }
115 
116     /**
117      * @dev Throws if called by any account other than the owner.
118      */
119     modifier onlyOwner() {
120         require(owner() == _msgSender(), "Ownable: caller is not the owner");
121         _;
122     }
123 
124     /**
125      * @dev Leaves the contract without owner. It will not be possible to call
126      * `onlyOwner` functions anymore. Can only be called by the current owner.
127      *
128      * NOTE: Renouncing ownership will leave the contract without an owner,
129      * thereby removing any functionality that is only available to the owner.
130      */
131     function renounceOwnership() public virtual onlyOwner {
132         _transferOwnership(address(0));
133     }
134 
135     /**
136      * @dev Transfers ownership of the contract to a new account (`newOwner`).
137      * Can only be called by the current owner.
138      */
139     function transferOwnership(address newOwner) public virtual onlyOwner {
140         require(
141             newOwner != address(0),
142             "Ownable: new owner is the zero address"
143         );
144         _transferOwnership(newOwner);
145     }
146 
147     /**
148      * @dev Transfers ownership of the contract to a new account (`newOwner`).
149      * Internal function without access restriction.
150      */
151     function _transferOwnership(address newOwner) internal virtual {
152         address oldOwner = _owner;
153         _owner = newOwner;
154         emit OwnershipTransferred(oldOwner, newOwner);
155     }
156 }
157 
158 /**
159  * @dev Interface of the ERC20 standard as defined in the EIP.
160  */
161 interface IERC20 {
162     /**
163      * @dev Returns the amount of tokens in existence.
164      */
165     function totalSupply() external view returns (uint256);
166 
167     /**
168      * @dev Returns the amount of tokens owned by `account`.
169      */
170     function balanceOf(address account) external view returns (uint256);
171 
172     /**
173      * @dev Moves `amount` tokens from the caller's account to `recipient`.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transfer(address recipient, uint256 amount)
180         external
181         returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender)
191         external
192         view
193         returns (uint256);
194 
195     /**
196      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * IMPORTANT: Beware that changing an allowance with this method brings the risk
201      * that someone may use both the old and the new allowance by unfortunate
202      * transaction ordering. One possible solution to mitigate this race
203      * condition is to first reduce the spender's allowance to 0 and set the
204      * desired value afterwards:
205      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address spender, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Moves `amount` tokens from `sender` to `recipient` using the
213      * allowance mechanism. `amount` is then deducted from the caller's
214      * allowance.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transferFrom(
221         address sender,
222         address recipient,
223         uint256 amount
224     ) external returns (bool);
225 
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(
239         address indexed owner,
240         address indexed spender,
241         uint256 value
242     );
243 }
244 
245 /**
246  * @dev Interface for the optional metadata functions from the ERC20 standard.
247  *
248  * _Available since v4.1._
249  */
250 interface IERC20Metadata is IERC20 {
251     /**
252      * @dev Returns the name of the token.
253      */
254     function name() external view returns (string memory);
255 
256     /**
257      * @dev Returns the symbol of the token.
258      */
259     function symbol() external view returns (string memory);
260 
261     /**
262      * @dev Returns the decimals places of the token.
263      */
264     function decimals() external view returns (uint8);
265 }
266 
267 /**
268  * @dev Implementation of the {IERC20} interface.
269  *
270  * This implementation is agnostic to the way tokens are created. This means
271  * that a supply mechanism has to be added in a derived contract using {_mint}.
272  * For a generic mechanism see {ERC20PresetMinterPauser}.
273  *
274  * TIP: For a detailed writeup see our guide
275  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
276  * to implement supply mechanisms].
277  *
278  * We have followed general OpenZeppelin Contracts guidelines: functions revert
279  * instead returning `false` on failure. This behavior is nonetheless
280  * conventional and does not conflict with the expectations of ERC20
281  * applications.
282  *
283  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
284  * This allows applications to reconstruct the allowance for all accounts just
285  * by listening to said events. Other implementations of the EIP may not emit
286  * these events, as it isn't required by the specification.
287  *
288  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
289  * functions have been added to mitigate the well-known issues around setting
290  * allowances. See {IERC20-approve}.
291  */
292 contract ERC20 is Context, IERC20, IERC20Metadata {
293     mapping(address => uint256) private _balances;
294 
295     mapping(address => mapping(address => uint256)) private _allowances;
296 
297     uint256 private _totalSupply;
298 
299     string private _name;
300     string private _symbol;
301 
302     /**
303      * @dev Sets the values for {name} and {symbol}.
304      *
305      * The default value of {decimals} is 18. To select a different value for
306      * {decimals} you should overload it.
307      *
308      * All two of these values are immutable: they can only be set once during
309      * construction.
310      */
311     constructor(string memory name_, string memory symbol_) {
312         _name = name_;
313         _symbol = symbol_;
314     }
315 
316     /**
317      * @dev Returns the name of the token.
318      */
319     function name() public view virtual override returns (string memory) {
320         return _name;
321     }
322 
323     /**
324      * @dev Returns the symbol of the token, usually a shorter version of the
325      * name.
326      */
327     function symbol() public view virtual override returns (string memory) {
328         return _symbol;
329     }
330 
331     /**
332      * @dev Returns the number of decimals used to get its user representation.
333      * For example, if `decimals` equals `2`, a balance of `505` tokens should
334      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
335      *
336      * Tokens usually opt for a value of 18, imitating the relationship between
337      * Ether and Wei. This is the value {ERC20} uses, unless this function is
338      * overridden;
339      *
340      * NOTE: This information is only used for _display_ purposes: it in
341      * no way affects any of the arithmetic of the contract, including
342      * {IERC20-balanceOf} and {IERC20-transfer}.
343      */
344     function decimals() public view virtual override returns (uint8) {
345         return 18;
346     }
347 
348     /**
349      * @dev See {IERC20-totalSupply}.
350      */
351     function totalSupply() public view virtual override returns (uint256) {
352         return _totalSupply;
353     }
354 
355     /**
356      * @dev See {IERC20-balanceOf}.
357      */
358     function balanceOf(address account)
359         public
360         view
361         virtual
362         override
363         returns (uint256)
364     {
365         return _balances[account];
366     }
367 
368     /**
369      * @dev See {IERC20-transfer}.
370      *
371      * Requirements:
372      *
373      * - `recipient` cannot be the zero address.
374      * - the caller must have a balance of at least `amount`.
375      */
376     function transfer(address recipient, uint256 amount)
377         public
378         virtual
379         override
380         returns (bool)
381     {
382         _transfer(_msgSender(), recipient, amount);
383         return true;
384     }
385 
386     /**
387      * @dev See {IERC20-allowance}.
388      */
389     function allowance(address owner, address spender)
390         public
391         view
392         virtual
393         override
394         returns (uint256)
395     {
396         return _allowances[owner][spender];
397     }
398 
399     /**
400      * @dev See {IERC20-approve}.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function approve(address spender, uint256 amount)
407         public
408         virtual
409         override
410         returns (bool)
411     {
412         _approve(_msgSender(), spender, amount);
413         return true;
414     }
415 
416     /**
417      * @dev See {IERC20-transferFrom}.
418      *
419      * Emits an {Approval} event indicating the updated allowance. This is not
420      * required by the EIP. See the note at the beginning of {ERC20}.
421      *
422      * Requirements:
423      *
424      * - `sender` and `recipient` cannot be the zero address.
425      * - `sender` must have a balance of at least `amount`.
426      * - the caller must have allowance for ``sender``'s tokens of at least
427      * `amount`.
428      */
429     function transferFrom(
430         address sender,
431         address recipient,
432         uint256 amount
433     ) public virtual override returns (bool) {
434         _transfer(sender, recipient, amount);
435 
436         uint256 currentAllowance = _allowances[sender][_msgSender()];
437         require(
438             currentAllowance >= amount,
439             "ERC20: transfer amount exceeds allowance"
440         );
441         unchecked {
442             _approve(sender, _msgSender(), currentAllowance - amount);
443         }
444 
445         return true;
446     }
447 
448     /**
449      * @dev Atomically increases the allowance granted to `spender` by the caller.
450      *
451      * This is an alternative to {approve} that can be used as a mitigation for
452      * problems described in {IERC20-approve}.
453      *
454      * Emits an {Approval} event indicating the updated allowance.
455      *
456      * Requirements:
457      *
458      * - `spender` cannot be the zero address.
459      */
460     function increaseAllowance(address spender, uint256 addedValue)
461         public
462         virtual
463         returns (bool)
464     {
465         _approve(
466             _msgSender(),
467             spender,
468             _allowances[_msgSender()][spender] + addedValue
469         );
470         return true;
471     }
472 
473     /**
474      * @dev Atomically decreases the allowance granted to `spender` by the caller.
475      *
476      * This is an alternative to {approve} that can be used as a mitigation for
477      * problems described in {IERC20-approve}.
478      *
479      * Emits an {Approval} event indicating the updated allowance.
480      *
481      * Requirements:
482      *
483      * - `spender` cannot be the zero address.
484      * - `spender` must have allowance for the caller of at least
485      * `subtractedValue`.
486      */
487     function decreaseAllowance(address spender, uint256 subtractedValue)
488         public
489         virtual
490         returns (bool)
491     {
492         uint256 currentAllowance = _allowances[_msgSender()][spender];
493         require(
494             currentAllowance >= subtractedValue,
495             "ERC20: decreased allowance below zero"
496         );
497         unchecked {
498             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
499         }
500 
501         return true;
502     }
503 
504     /**
505      * @dev Moves `amount` of tokens from `sender` to `recipient`.
506      *
507      * This internal function is equivalent to {transfer}, and can be used to
508      * e.g. implement automatic token fees, slashing mechanisms, etc.
509      *
510      * Emits a {Transfer} event.
511      *
512      * Requirements:
513      *
514      * - `sender` cannot be the zero address.
515      * - `recipient` cannot be the zero address.
516      * - `sender` must have a balance of at least `amount`.
517      */
518     function _transfer(
519         address sender,
520         address recipient,
521         uint256 amount
522     ) internal virtual {
523         require(sender != address(0), "ERC20: transfer from the zero address");
524         require(recipient != address(0), "ERC20: transfer to the zero address");
525 
526         _beforeTokenTransfer(sender, recipient, amount);
527 
528         uint256 senderBalance = _balances[sender];
529         require(
530             senderBalance >= amount,
531             "ERC20: transfer amount exceeds balance"
532         );
533         unchecked {
534             _balances[sender] = senderBalance - amount;
535         }
536         _balances[recipient] += amount;
537 
538         emit Transfer(sender, recipient, amount);
539 
540         _afterTokenTransfer(sender, recipient, amount);
541     }
542 
543     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
544      * the total supply.
545      *
546      * Emits a {Transfer} event with `from` set to the zero address.
547      *
548      * Requirements:
549      *
550      * - `account` cannot be the zero address.
551      */
552     function _mint(address account, uint256 amount) internal virtual {
553         require(account != address(0), "ERC20: mint to the zero address");
554 
555         _beforeTokenTransfer(address(0), account, amount);
556 
557         _totalSupply += amount;
558         _balances[account] += amount;
559         emit Transfer(address(0), account, amount);
560 
561         _afterTokenTransfer(address(0), account, amount);
562     }
563 
564     /**
565      * @dev Destroys `amount` tokens from `account`, reducing the
566      * total supply.
567      *
568      * Emits a {Transfer} event with `to` set to the zero address.
569      *
570      * Requirements:
571      *
572      * - `account` cannot be the zero address.
573      * - `account` must have at least `amount` tokens.
574      */
575     function _burn(address account, uint256 amount) internal virtual {
576         require(account != address(0), "ERC20: burn from the zero address");
577 
578         _beforeTokenTransfer(account, address(0), amount);
579 
580         uint256 accountBalance = _balances[account];
581         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
582         unchecked {
583             _balances[account] = accountBalance - amount;
584         }
585         _totalSupply -= amount;
586 
587         emit Transfer(account, address(0), amount);
588 
589         _afterTokenTransfer(account, address(0), amount);
590     }
591 
592     /**
593      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
594      *
595      * This internal function is equivalent to `approve`, and can be used to
596      * e.g. set automatic allowances for certain subsystems, etc.
597      *
598      * Emits an {Approval} event.
599      *
600      * Requirements:
601      *
602      * - `owner` cannot be the zero address.
603      * - `spender` cannot be the zero address.
604      */
605     function _approve(
606         address owner,
607         address spender,
608         uint256 amount
609     ) internal virtual {
610         require(owner != address(0), "ERC20: approve from the zero address");
611         require(spender != address(0), "ERC20: approve to the zero address");
612 
613         _allowances[owner][spender] = amount;
614         emit Approval(owner, spender, amount);
615     }
616 
617     /**
618      * @dev Hook that is called before any transfer of tokens. This includes
619      * minting and burning.
620      *
621      * Calling conditions:
622      *
623      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
624      * will be transferred to `to`.
625      * - when `from` is zero, `amount` tokens will be minted for `to`.
626      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
627      * - `from` and `to` are never both zero.
628      *
629      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
630      */
631     function _beforeTokenTransfer(
632         address from,
633         address to,
634         uint256 amount
635     ) internal virtual {}
636 
637     /**
638      * @dev Hook that is called after any transfer of tokens. This includes
639      * minting and burning.
640      *
641      * Calling conditions:
642      *
643      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
644      * has been transferred to `to`.
645      * - when `from` is zero, `amount` tokens have been minted for `to`.
646      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
647      * - `from` and `to` are never both zero.
648      *
649      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
650      */
651     function _afterTokenTransfer(
652         address from,
653         address to,
654         uint256 amount
655     ) internal virtual {}
656 }
657 
658 // CAUTION
659 // This version of SafeMath should only be used with Solidity 0.8 or later,
660 // because it relies on the compiler's built in overflow checks.
661 
662 /**
663  * @dev Wrappers over Solidity's arithmetic operations.
664  *
665  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
666  * now has built in overflow checking.
667  */
668 library SafeMath {
669     /**
670      * @dev Returns the addition of two unsigned integers, with an overflow flag.
671      *
672      * _Available since v3.4._
673      */
674     function tryAdd(uint256 a, uint256 b)
675         internal
676         pure
677         returns (bool, uint256)
678     {
679         unchecked {
680             uint256 c = a + b;
681             if (c < a) return (false, 0);
682             return (true, c);
683         }
684     }
685 
686     /**
687      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
688      *
689      * _Available since v3.4._
690      */
691     function trySub(uint256 a, uint256 b)
692         internal
693         pure
694         returns (bool, uint256)
695     {
696         unchecked {
697             if (b > a) return (false, 0);
698             return (true, a - b);
699         }
700     }
701 
702     /**
703      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
704      *
705      * _Available since v3.4._
706      */
707     function tryMul(uint256 a, uint256 b)
708         internal
709         pure
710         returns (bool, uint256)
711     {
712         unchecked {
713             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
714             // benefit is lost if 'b' is also tested.
715             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
716             if (a == 0) return (true, 0);
717             uint256 c = a * b;
718             if (c / a != b) return (false, 0);
719             return (true, c);
720         }
721     }
722 
723     /**
724      * @dev Returns the division of two unsigned integers, with a division by zero flag.
725      *
726      * _Available since v3.4._
727      */
728     function tryDiv(uint256 a, uint256 b)
729         internal
730         pure
731         returns (bool, uint256)
732     {
733         unchecked {
734             if (b == 0) return (false, 0);
735             return (true, a / b);
736         }
737     }
738 
739     /**
740      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
741      *
742      * _Available since v3.4._
743      */
744     function tryMod(uint256 a, uint256 b)
745         internal
746         pure
747         returns (bool, uint256)
748     {
749         unchecked {
750             if (b == 0) return (false, 0);
751             return (true, a % b);
752         }
753     }
754 
755     /**
756      * @dev Returns the addition of two unsigned integers, reverting on
757      * overflow.
758      *
759      * Counterpart to Solidity's `+` operator.
760      *
761      * Requirements:
762      *
763      * - Addition cannot overflow.
764      */
765     function add(uint256 a, uint256 b) internal pure returns (uint256) {
766         return a + b;
767     }
768 
769     /**
770      * @dev Returns the subtraction of two unsigned integers, reverting on
771      * overflow (when the result is negative).
772      *
773      * Counterpart to Solidity's `-` operator.
774      *
775      * Requirements:
776      *
777      * - Subtraction cannot overflow.
778      */
779     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
780         return a - b;
781     }
782 
783     /**
784      * @dev Returns the multiplication of two unsigned integers, reverting on
785      * overflow.
786      *
787      * Counterpart to Solidity's `*` operator.
788      *
789      * Requirements:
790      *
791      * - Multiplication cannot overflow.
792      */
793     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
794         return a * b;
795     }
796 
797     /**
798      * @dev Returns the integer division of two unsigned integers, reverting on
799      * division by zero. The result is rounded towards zero.
800      *
801      * Counterpart to Solidity's `/` operator.
802      *
803      * Requirements:
804      *
805      * - The divisor cannot be zero.
806      */
807     function div(uint256 a, uint256 b) internal pure returns (uint256) {
808         return a / b;
809     }
810 
811     /**
812      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
813      * reverting when dividing by zero.
814      *
815      * Counterpart to Solidity's `%` operator. This function uses a `revert`
816      * opcode (which leaves remaining gas untouched) while Solidity uses an
817      * invalid opcode to revert (consuming all remaining gas).
818      *
819      * Requirements:
820      *
821      * - The divisor cannot be zero.
822      */
823     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
824         return a % b;
825     }
826 
827     /**
828      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
829      * overflow (when the result is negative).
830      *
831      * CAUTION: This function is deprecated because it requires allocating memory for the error
832      * message unnecessarily. For custom revert reasons use {trySub}.
833      *
834      * Counterpart to Solidity's `-` operator.
835      *
836      * Requirements:
837      *
838      * - Subtraction cannot overflow.
839      */
840     function sub(
841         uint256 a,
842         uint256 b,
843         string memory errorMessage
844     ) internal pure returns (uint256) {
845         unchecked {
846             require(b <= a, errorMessage);
847             return a - b;
848         }
849     }
850 
851     /**
852      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
853      * division by zero. The result is rounded towards zero.
854      *
855      * Counterpart to Solidity's `/` operator. Note: this function uses a
856      * `revert` opcode (which leaves remaining gas untouched) while Solidity
857      * uses an invalid opcode to revert (consuming all remaining gas).
858      *
859      * Requirements:
860      *
861      * - The divisor cannot be zero.
862      */
863     function div(
864         uint256 a,
865         uint256 b,
866         string memory errorMessage
867     ) internal pure returns (uint256) {
868         unchecked {
869             require(b > 0, errorMessage);
870             return a / b;
871         }
872     }
873 
874     /**
875      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
876      * reverting with custom message when dividing by zero.
877      *
878      * CAUTION: This function is deprecated because it requires allocating memory for the error
879      * message unnecessarily. For custom revert reasons use {tryMod}.
880      *
881      * Counterpart to Solidity's `%` operator. This function uses a `revert`
882      * opcode (which leaves remaining gas untouched) while Solidity uses an
883      * invalid opcode to revert (consuming all remaining gas).
884      *
885      * Requirements:
886      *
887      * - The divisor cannot be zero.
888      */
889     function mod(
890         uint256 a,
891         uint256 b,
892         string memory errorMessage
893     ) internal pure returns (uint256) {
894         unchecked {
895             require(b > 0, errorMessage);
896             return a % b;
897         }
898     }
899 }
900 
901 contract DejitaruHa is ERC20, Ownable {
902     using SafeMath for uint256;
903 
904     IUniswapV2Router02 public immutable uniswapV2Router;
905     address public uniswapV2Pair;
906     address public constant deadAddress = address(0xdead);
907 
908     bool private swapping;
909 
910     address public marketingWallet;
911     address public devWallet;
912 
913     uint256 public maxTransactionAmount;
914     uint256 public swapTokensAtAmount;
915     uint256 public maxWallet;
916 
917     uint256 public percentForLPBurn = 0; // 0 = 0%
918     bool public lpBurnEnabled = true;
919     uint256 public lpBurnFrequency = 360000000000000 seconds;
920     uint256 public lastLpBurnTime;
921 
922     uint256 public manualBurnFrequency = 300000000000000 minutes;
923     uint256 public lastManualLpBurnTime;
924 
925     bool public limitsInEffect = true;
926     bool public tradingActive = true;
927     bool public swapEnabled = true;
928 
929     // Anti-bot and anti-whale mappings and variables
930     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
931     bool public transferDelayEnabled = true;
932 
933     uint256 public buyTotalFees;
934     uint256 public constant buyMarketingFee = 5;
935     uint256 public constant buyLiquidityFee = 0;
936     uint256 public constant buyDevFee = 0;
937 
938     uint256 public sellTotalFees;
939     uint256 public constant sellMarketingFee = 5;
940     uint256 public constant sellLiquidityFee = 0;
941     uint256 public constant sellDevFee = 0;
942 
943     uint256 public tokensForMarketing;
944     uint256 public tokensForLiquidity;
945     uint256 public tokensForDev;
946 
947     /******************/
948 
949     // exlcude from fees and max transaction amount
950     mapping(address => bool) private _isExcludedFromFees;
951     mapping(address => bool) public _isExcludedMaxTransactionAmount;
952 
953     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
954     // could be subject to a maximum transfer amount
955     mapping(address => bool) public automatedMarketMakerPairs;
956 
957     event UpdateUniswapV2Router(
958         address indexed newAddress,
959         address indexed oldAddress
960     );
961 
962     event ExcludeFromFees(address indexed account, bool isExcluded);
963 
964     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
965 
966     event marketingWalletUpdated(
967         address indexed newWallet,
968         address indexed oldWallet
969     );
970 
971     event devWalletUpdated(
972         address indexed newWallet,
973         address indexed oldWallet
974     );
975 
976     event SwapAndLiquify(
977         uint256 tokensSwapped,
978         uint256 ethReceived,
979         uint256 tokensIntoLiquidity
980     );
981 
982     event AutoNukeLP();
983 
984     event ManualNukeLP();
985 
986     event BoughtEarly(address indexed sniper);
987 
988     constructor() ERC20("Dejitaru Ha", "Blade") {
989         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
990             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
991         );
992 
993         excludeFromMaxTransaction(address(_uniswapV2Router), true);
994         uniswapV2Router = _uniswapV2Router;
995 
996         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
997             .createPair(address(this), _uniswapV2Router.WETH());
998         excludeFromMaxTransaction(address(uniswapV2Pair), true);
999         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1000 
1001         uint256 totalSupply = 1_000_000 * 1e18; // 1 million total supply
1002 
1003         maxTransactionAmount = 30_000 * 1e18; //3% from total supply maxTransactionAmountTxn
1004         maxWallet = 30_000 * 1e18; // 3% from total supply maxWallet
1005         swapTokensAtAmount = (totalSupply * 3) / 1000; // 0.03% swap wallet
1006 
1007         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1008         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1009 
1010         marketingWallet = address(0x8242e56a759aa0B069B9c983fe3f582020CD1eC9); // set as marketing wallet
1011         devWallet = address(0x8242e56a759aa0B069B9c983fe3f582020CD1eC9); // set as dev wallet
1012 
1013         // exclude from paying fees or having max transaction amount
1014         excludeFromFees(owner(), true);
1015         excludeFromFees(address(this), true);
1016         excludeFromFees(address(0xdead), true);
1017 
1018         excludeFromMaxTransaction(owner(), true);
1019         excludeFromMaxTransaction(address(this), true);
1020         excludeFromMaxTransaction(address(0xdead), true);
1021 
1022         /*
1023             _mint is an internal function in ERC20.sol that is only called here,
1024             and CANNOT be called ever again
1025         */
1026         _mint(msg.sender, totalSupply);
1027     }
1028 
1029     receive() external payable {}
1030 
1031     // once enabled, can never be turned off
1032     function startTrading() external onlyOwner {
1033         tradingActive = true;
1034         swapEnabled = true;
1035         lastLpBurnTime = block.timestamp;
1036     }
1037 
1038     // remove limits after token is stable
1039     function removeLimits() external onlyOwner returns (bool) {
1040         limitsInEffect = false;
1041         return true;
1042     }
1043 
1044     // disable Transfer delay - cannot be reenabled
1045     function disableTransferDelay() external onlyOwner returns (bool) {
1046         transferDelayEnabled = false;
1047         return true;
1048     }
1049 
1050     // change the minimum amount of tokens to sell from fees
1051     function updateSwapTokensAtAmount(uint256 newAmount)
1052         external
1053         onlyOwner
1054         returns (bool)
1055     {
1056         require(
1057             newAmount >= (totalSupply() * 1) / 100000,
1058             "Swap amount cannot be lower than 0.001% total supply."
1059         );
1060         require(
1061             newAmount <= (totalSupply() * 5) / 1000,
1062             "Swap amount cannot be higher than 0.5% total supply."
1063         );
1064         swapTokensAtAmount = newAmount;
1065         return true;
1066     }
1067 
1068     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1069         require(
1070             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1071             "Cannot set maxTransactionAmount lower than 0.1%"
1072         );
1073         maxTransactionAmount = newNum * (10**18);
1074     }
1075 
1076     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1077         require(
1078             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1079             "Cannot set maxWallet lower than 0.5%"
1080         );
1081         maxWallet = newNum * (10**18);
1082     }
1083 
1084     function excludeFromMaxTransaction(address updAds, bool isEx)
1085         public
1086         onlyOwner
1087     {
1088         _isExcludedMaxTransactionAmount[updAds] = isEx;
1089     }
1090 
1091     // only use to disable contract sales if absolutely necessary (emergency use only)
1092     function updateSwapEnabled(bool enabled) external onlyOwner {
1093         swapEnabled = enabled;
1094     }
1095 
1096     function excludeFromFees(address account, bool excluded) public onlyOwner {
1097         _isExcludedFromFees[account] = excluded;
1098         emit ExcludeFromFees(account, excluded);
1099     }
1100 
1101     function setAutomatedMarketMakerPair(address pair, bool value)
1102         public
1103         onlyOwner
1104     {
1105         require(
1106             pair != uniswapV2Pair,
1107             "The pair cannot be removed from automatedMarketMakerPairs"
1108         );
1109 
1110         _setAutomatedMarketMakerPair(pair, value);
1111     }
1112 
1113     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1114         automatedMarketMakerPairs[pair] = value;
1115 
1116         emit SetAutomatedMarketMakerPair(pair, value);
1117     }
1118 
1119     function updateMarketingWallet(address newMarketingWallet)
1120         external
1121         onlyOwner
1122     {
1123         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1124         marketingWallet = newMarketingWallet;
1125     }
1126 
1127     function updateDevWallet(address newWallet) external onlyOwner {
1128         emit devWalletUpdated(newWallet, devWallet);
1129         devWallet = newWallet;
1130     }
1131 
1132     function isExcludedFromFees(address account) public view returns (bool) {
1133         return _isExcludedFromFees[account];
1134     }
1135 
1136     function _transfer(
1137         address from,
1138         address to,
1139         uint256 amount
1140     ) internal override {
1141         require(from != address(0), "ERC20: transfer from the zero address");
1142         require(to != address(0), "ERC20: transfer to the zero address");
1143 
1144         if (amount == 0) {
1145             super._transfer(from, to, 0);
1146             return;
1147         }
1148 
1149         if (limitsInEffect) {
1150             if (
1151                 from != owner() &&
1152                 to != owner() &&
1153                 to != address(0) &&
1154                 to != address(0xdead) &&
1155                 !swapping
1156             ) {
1157                 if (!tradingActive) {
1158                     require(
1159                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1160                         "Trading is not active."
1161                     );
1162                 }
1163 
1164                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1165                 if (transferDelayEnabled) {
1166                     if (
1167                         to != owner() &&
1168                         to != address(uniswapV2Router) &&
1169                         to != address(uniswapV2Pair)
1170                     ) {
1171                         require(
1172                             _holderLastTransferTimestamp[tx.origin] <
1173                                 block.number,
1174                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1175                         );
1176                         _holderLastTransferTimestamp[tx.origin] = block.number;
1177                     }
1178                 }
1179 
1180                 //when buy
1181                 if (
1182                     automatedMarketMakerPairs[from] &&
1183                     !_isExcludedMaxTransactionAmount[to]
1184                 ) {
1185                     require(
1186                         amount <= maxTransactionAmount,
1187                         "Buy transfer amount exceeds the maxTransactionAmount."
1188                     );
1189                     require(
1190                         amount + balanceOf(to) <= maxWallet,
1191                         "Max wallet exceeded"
1192                     );
1193                 }
1194                 //when sell
1195                 else if (
1196                     automatedMarketMakerPairs[to] &&
1197                     !_isExcludedMaxTransactionAmount[from]
1198                 ) {
1199                     require(
1200                         amount <= maxTransactionAmount,
1201                         "Sell transfer amount exceeds the maxTransactionAmount."
1202                     );
1203                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1204                     require(
1205                         amount + balanceOf(to) <= maxWallet,
1206                         "Max wallet exceeded"
1207                     );
1208                 }
1209             }
1210         }
1211 
1212         uint256 contractTokenBalance = balanceOf(address(this));
1213 
1214         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1215 
1216         if (
1217             canSwap &&
1218             swapEnabled &&
1219             !swapping &&
1220             !automatedMarketMakerPairs[from] &&
1221             !_isExcludedFromFees[from] &&
1222             !_isExcludedFromFees[to]
1223         ) {
1224             swapping = true;
1225 
1226             swapBack();
1227 
1228             swapping = false;
1229         }
1230 
1231         if (
1232             !swapping &&
1233             automatedMarketMakerPairs[to] &&
1234             lpBurnEnabled &&
1235             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1236             !_isExcludedFromFees[from]
1237         ) {
1238             autoBurnLiquidityPairTokens();
1239         }
1240 
1241         bool takeFee = !swapping;
1242 
1243         // if any account belongs to _isExcludedFromFee account then remove the fee
1244         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1245             takeFee = false;
1246         }
1247 
1248         uint256 fees = 0;
1249         // only take fees on buys/sells, do not take on wallet transfers
1250         if (takeFee) {
1251             // on sell
1252             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1253                 fees = amount.mul(sellTotalFees).div(100);
1254                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1255                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1256                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1257             }
1258             // on buy
1259             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1260                 fees = amount.mul(buyTotalFees).div(100);
1261                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1262                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1263                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1264             }
1265 
1266             if (fees > 0) {
1267                 super._transfer(from, address(this), fees);
1268             }
1269 
1270             amount -= fees;
1271         }
1272 
1273         super._transfer(from, to, amount);
1274     }
1275 
1276     function swapTokensForEth(uint256 tokenAmount) private {
1277         // generate the uniswap pair path of token -> weth
1278         address[] memory path = new address[](2);
1279         path[0] = address(this);
1280         path[1] = uniswapV2Router.WETH();
1281 
1282         _approve(address(this), address(uniswapV2Router), tokenAmount);
1283 
1284         // make the swap
1285         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1286             tokenAmount,
1287             0, // accept any amount of ETH
1288             path,
1289             address(this),
1290             block.timestamp
1291         );
1292     }
1293 
1294     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1295         // approve token transfer to cover all possible scenarios
1296         _approve(address(this), address(uniswapV2Router), tokenAmount);
1297 
1298         // add the liquidity
1299         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1300             address(this),
1301             tokenAmount,
1302             0, // slippage is unavoidable
1303             0, // slippage is unavoidable
1304             deadAddress,
1305             block.timestamp
1306         );
1307     }
1308 
1309     function swapBack() private {
1310         uint256 contractBalance = balanceOf(address(this));
1311         uint256 totalTokensToSwap = tokensForLiquidity +
1312             tokensForMarketing +
1313             tokensForDev;
1314         bool success;
1315 
1316         if (contractBalance == 0 || totalTokensToSwap == 0) {
1317             return;
1318         }
1319 
1320         if (contractBalance > swapTokensAtAmount * 20) {
1321             contractBalance = swapTokensAtAmount * 20;
1322         }
1323 
1324         // Halve the amount of liquidity tokens
1325         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1326             totalTokensToSwap /
1327             2;
1328         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1329 
1330         uint256 initialETHBalance = address(this).balance;
1331 
1332         swapTokensForEth(amountToSwapForETH);
1333 
1334         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1335 
1336         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1337             totalTokensToSwap
1338         );
1339         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1340 
1341         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1342 
1343         tokensForLiquidity = 0;
1344         tokensForMarketing = 0;
1345         tokensForDev = 0;
1346 
1347         (success, ) = address(devWallet).call{value: ethForDev}("");
1348 
1349         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1350             addLiquidity(liquidityTokens, ethForLiquidity);
1351             emit SwapAndLiquify(
1352                 amountToSwapForETH,
1353                 ethForLiquidity,
1354                 tokensForLiquidity
1355             );
1356         }
1357 
1358         (success, ) = address(marketingWallet).call{
1359             value: address(this).balance
1360         }("");
1361     }
1362 
1363     function setAutoLPBurnSettings(
1364         uint256 _frequencyInSeconds,
1365         uint256 _percent,
1366         bool _Enabled
1367     ) external onlyOwner {
1368         require(
1369             _frequencyInSeconds >= 600,
1370             "cannot set buyback more often than every 10 minutes"
1371         );
1372         require(
1373             _percent <= 1000 && _percent >= 0,
1374             "Must set auto LP burn percent between 0% and 10%"
1375         );
1376         lpBurnFrequency = _frequencyInSeconds;
1377         percentForLPBurn = _percent;
1378         lpBurnEnabled = _Enabled;
1379     }
1380 
1381     function autoBurnLiquidityPairTokens() internal returns (bool) {
1382         lastLpBurnTime = block.timestamp;
1383 
1384         // get balance of liquidity pair
1385         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1386 
1387         // calculate amount to burn
1388         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1389             10000
1390         );
1391 
1392         // pull tokens from pancakePair liquidity and move to dead address permanently
1393         if (amountToBurn > 0) {
1394             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1395         }
1396 
1397         //sync price since this is not in a swap transaction!
1398         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1399         pair.sync();
1400         emit AutoNukeLP();
1401         return true;
1402     }
1403 
1404     function manualBurnLiquidityPairTokens(uint256 percent)
1405         external
1406         onlyOwner
1407         returns (bool)
1408     {
1409         require(
1410             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1411             "Must wait for cooldown to finish"
1412         );
1413         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1414         lastManualLpBurnTime = block.timestamp;
1415 
1416         // get balance of liquidity pair
1417         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1418 
1419         // calculate amount to burn
1420         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1421 
1422         // pull tokens from pancakePair liquidity and move to dead address permanently
1423         if (amountToBurn > 0) {
1424             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1425         }
1426 
1427         //sync price since this is not in a swap transaction!
1428         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1429         pair.sync();
1430         emit ManualNukeLP();
1431         return true;
1432     }
1433 }