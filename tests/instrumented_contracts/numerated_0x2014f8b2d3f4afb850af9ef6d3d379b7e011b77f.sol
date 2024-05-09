1 /*
2 
3 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
4 /                                                                                                                  /
5 /    $$$$$$$$ $$___$$_ $$$$$$$_ ___$$$$$__ $$____$$_ $$___$$_ $$$$$___ $$$$_ __$$$$_ __$$$___$$$$$$$$ $$$$$$$_     /
6 /     __$$___ $$___$$_ $$______ __$$___$$_ _$$__$$__ $$$__$$_ $$__$$__ _$$__ _$$____ _$$_$$__ __$$___ $$______     /
7 /     __$$___ $$$$$$$_ $$$$$___ ___$$$____ __$$$$___ $$$$_$$_ $$___$$_ _$$__ $$_____ $$___$$_ __$$___ $$$$$___     /
8 /     __$$___ $$___$$_ $$______ _____$$$__ ___$$____ $$_$$$$_ $$___$$_ _$$__ $$_____ $$$$$$$_ __$$___ $$______     /
9 /     __$$___ $$___$$_ $$______ __$$___$$_ ___$$____ $$__$$$_ $$__$$__ _$$__ _$$____ $$___$$_ __$$___ $$______     / 
10 /     __$$___ $$___$$_ $$$$$$$_ ___$$$$$__ ___$$____ $$___$$_ $$$$$___ $$$$_ __$$$$_ $$___$$_ __$$___ $$$$$$$_     /
11 /                                                                                                                  /
12 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
13 
14 /*
15  * https://http://thesyndicatetoken.xyz/
16  * https://t.me/TheSyndicateEntry
17  * https://twitter.com/thesyndicateeth
18  *
19  */
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity ^0.8.0;
23 
24 interface IUniswapV2Factory {
25     function createPair(address tokenA, address tokenB)
26         external
27         returns (address pair);
28 }
29 
30 interface IUniswapV2Router01 {
31     function factory() external pure returns (address);
32 
33     function WETH() external pure returns (address);
34 
35     function addLiquidityETH(
36         address token,
37         uint256 amountTokenDesired,
38         uint256 amountTokenMin,
39         uint256 amountETHMin,
40         address to,
41         uint256 deadline
42     )
43         external
44         payable
45         returns (
46             uint256 amountToken,
47             uint256 amountETH,
48             uint256 liquidity
49         );
50 }
51 
52 interface IUniswapV2Router02 is IUniswapV2Router01 {
53     function swapExactTokensForETHSupportingFeeOnTransferTokens(
54         uint256 amountIn,
55         uint256 amountOutMin,
56         address[] calldata path,
57         address to,
58         uint256 deadline
59     ) external;
60 }
61 
62 interface IUniswapV2Pair {
63     function sync() external;
64 }
65 
66 /**
67  * @dev Provides information about the current execution context, including the
68  * sender of the transaction and its data. While these are generally available
69  * via msg.sender and msg.data, they should not be accessed in such a direct
70  * manner, since when dealing with meta-transactions the account sending and
71  * paying for execution may not be the actual sender (as far as an application
72  * is concerned).
73  *
74  * This contract is only required for intermediate, library-like contracts.
75  */
76 abstract contract Context {
77     function _msgSender() internal view virtual returns (address) {
78         return msg.sender;
79     }
80 
81     function _msgData() internal view virtual returns (bytes calldata) {
82         return msg.data;
83     }
84 }
85 
86 /**
87  * @dev Contract module which provides a basic access control mechanism, where
88  * there is an account (an owner) that can be granted exclusive access to
89  * specific functions.
90  *
91  * By default, the owner account will be the one that deploys the contract. This
92  * can later be changed with {transferOwnership}.
93  *
94  * This module is used through inheritance. It will make available the modifier
95  * `onlyOwner`, which can be applied to your functions to restrict their use to
96  * the owner.
97  */
98 abstract contract Ownable is Context {
99     address private _owner;
100 
101     event OwnershipTransferred(
102         address indexed previousOwner,
103         address indexed newOwner
104     );
105 
106     /**
107      * @dev Initializes the contract setting the deployer as the initial owner.
108      */
109     constructor() {
110         _transferOwnership(_msgSender());
111     }
112 
113     /**
114      * @dev Returns the address of the current owner.
115      */
116     function owner() public view virtual returns (address) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     /**
129      * @dev Leaves the contract without owner. It will not be possible to call
130      * `onlyOwner` functions anymore. Can only be called by the current owner.
131      *
132      * NOTE: Renouncing ownership will leave the contract without an owner,
133      * thereby removing any functionality that is only available to the owner.
134      */
135     function renounceOwnership() public virtual onlyOwner {
136         _transferOwnership(address(0));
137     }
138 
139     /**
140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
141      * Can only be called by the current owner.
142      */
143     function transferOwnership(address newOwner) public virtual onlyOwner {
144         require(
145             newOwner != address(0),
146             "Ownable: new owner is the zero address"
147         );
148         _transferOwnership(newOwner);
149     }
150 
151     /**
152      * @dev Transfers ownership of the contract to a new account (`newOwner`).
153      * Internal function without access restriction.
154      */
155     function _transferOwnership(address newOwner) internal virtual {
156         address oldOwner = _owner;
157         _owner = newOwner;
158         emit OwnershipTransferred(oldOwner, newOwner);
159     }
160 }
161 
162 /**
163  * @dev Interface of the ERC20 standard as defined in the EIP.
164  */
165 interface IERC20 {
166     /**
167      * @dev Returns the amount of tokens in existence.
168      */
169     function totalSupply() external view returns (uint256);
170 
171     /**
172      * @dev Returns the amount of tokens owned by `account`.
173      */
174     function balanceOf(address account) external view returns (uint256);
175 
176     /**
177      * @dev Moves `amount` tokens from the caller's account to `recipient`.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transfer(address recipient, uint256 amount)
184         external
185         returns (bool);
186 
187     /**
188      * @dev Returns the remaining number of tokens that `spender` will be
189      * allowed to spend on behalf of `owner` through {transferFrom}. This is
190      * zero by default.
191      *
192      * This value changes when {approve} or {transferFrom} are called.
193      */
194     function allowance(address owner, address spender)
195         external
196         view
197         returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(
225         address sender,
226         address recipient,
227         uint256 amount
228     ) external returns (bool);
229 
230     /**
231      * @dev Emitted when `value` tokens are moved from one account (`from`) to
232      * another (`to`).
233      *
234      * Note that `value` may be zero.
235      */
236     event Transfer(address indexed from, address indexed to, uint256 value);
237 
238     /**
239      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
240      * a call to {approve}. `value` is the new allowance.
241      */
242     event Approval(
243         address indexed owner,
244         address indexed spender,
245         uint256 value
246     );
247 }
248 
249 /**
250  * @dev Interface for the optional metadata functions from the ERC20 standard.
251  *
252  * _Available since v4.1._
253  */
254 interface IERC20Metadata is IERC20 {
255     /**
256      * @dev Returns the name of the token.
257      */
258     function name() external view returns (string memory);
259 
260     /**
261      * @dev Returns the symbol of the token.
262      */
263     function symbol() external view returns (string memory);
264 
265     /**
266      * @dev Returns the decimals places of the token.
267      */
268     function decimals() external view returns (uint8);
269 }
270 
271 /**
272  * @dev Implementation of the {IERC20} interface.
273  *
274  * This implementation is agnostic to the way tokens are created. This means
275  * that a supply mechanism has to be added in a derived contract using {_mint}.
276  * For a generic mechanism see {ERC20PresetMinterPauser}.
277  *
278  * TIP: For a detailed writeup see our guide
279  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
280  * to implement supply mechanisms].
281  *
282  * We have followed general OpenZeppelin Contracts guidelines: functions revert
283  * instead returning `false` on failure. This behavior is nonetheless
284  * conventional and does not conflict with the expectations of ERC20
285  * applications.
286  *
287  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
288  * This allows applications to reconstruct the allowance for all accounts just
289  * by listening to said events. Other implementations of the EIP may not emit
290  * these events, as it isn't required by the specification.
291  *
292  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
293  * functions have been added to mitigate the well-known issues around setting
294  * allowances. See {IERC20-approve}.
295  */
296 contract ERC20 is Context, IERC20, IERC20Metadata {
297     mapping(address => uint256) private _balances;
298 
299     mapping(address => mapping(address => uint256)) private _allowances;
300 
301     uint256 private _totalSupply;
302 
303     string private _name;
304     string private _symbol;
305 
306     /**
307      * @dev Sets the values for {name} and {symbol}.
308      *
309      * The default value of {decimals} is 18. To select a different value for
310      * {decimals} you should overload it.
311      *
312      * All two of these values are immutable: they can only be set once during
313      * construction.
314      */
315     constructor(string memory name_, string memory symbol_) {
316         _name = name_;
317         _symbol = symbol_;
318     }
319 
320     /**
321      * @dev Returns the name of the token.
322      */
323     function name() public view virtual override returns (string memory) {
324         return _name;
325     }
326 
327     /**
328      * @dev Returns the symbol of the token, usually a shorter version of the
329      * name.
330      */
331     function symbol() public view virtual override returns (string memory) {
332         return _symbol;
333     }
334 
335     /**
336      * @dev Returns the number of decimals used to get its user representation.
337      * For example, if `decimals` equals `2`, a balance of `505` tokens should
338      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
339      *
340      * Tokens usually opt for a value of 18, imitating the relationship between
341      * Ether and Wei. This is the value {ERC20} uses, unless this function is
342      * overridden;
343      *
344      * NOTE: This information is only used for _display_ purposes: it in
345      * no way affects any of the arithmetic of the contract, including
346      * {IERC20-balanceOf} and {IERC20-transfer}.
347      */
348     function decimals() public view virtual override returns (uint8) {
349         return 18;
350     }
351 
352     /**
353      * @dev See {IERC20-totalSupply}.
354      */
355     function totalSupply() public view virtual override returns (uint256) {
356         return _totalSupply;
357     }
358 
359     /**
360      * @dev See {IERC20-balanceOf}.
361      */
362     function balanceOf(address account)
363         public
364         view
365         virtual
366         override
367         returns (uint256)
368     {
369         return _balances[account];
370     }
371 
372     /**
373      * @dev See {IERC20-transfer}.
374      *
375      * Requirements:
376      *
377      * - `recipient` cannot be the zero address.
378      * - the caller must have a balance of at least `amount`.
379      */
380     function transfer(address recipient, uint256 amount)
381         public
382         virtual
383         override
384         returns (bool)
385     {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-allowance}.
392      */
393     function allowance(address owner, address spender)
394         public
395         view
396         virtual
397         override
398         returns (uint256)
399     {
400         return _allowances[owner][spender];
401     }
402 
403     /**
404      * @dev See {IERC20-approve}.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function approve(address spender, uint256 amount)
411         public
412         virtual
413         override
414         returns (bool)
415     {
416         _approve(_msgSender(), spender, amount);
417         return true;
418     }
419 
420     /**
421      * @dev See {IERC20-transferFrom}.
422      *
423      * Emits an {Approval} event indicating the updated allowance. This is not
424      * required by the EIP. See the note at the beginning of {ERC20}.
425      *
426      * Requirements:
427      *
428      * - `sender` and `recipient` cannot be the zero address.
429      * - `sender` must have a balance of at least `amount`.
430      * - the caller must have allowance for ``sender``'s tokens of at least
431      * `amount`.
432      */
433     function transferFrom(
434         address sender,
435         address recipient,
436         uint256 amount
437     ) public virtual override returns (bool) {
438         _transfer(sender, recipient, amount);
439 
440         uint256 currentAllowance = _allowances[sender][_msgSender()];
441         require(
442             currentAllowance >= amount,
443             "ERC20: transfer amount exceeds allowance"
444         );
445         unchecked {
446             _approve(sender, _msgSender(), currentAllowance - amount);
447         }
448 
449         return true;
450     }
451 
452     /**
453      * @dev Atomically increases the allowance granted to `spender` by the caller.
454      *
455      * This is an alternative to {approve} that can be used as a mitigation for
456      * problems described in {IERC20-approve}.
457      *
458      * Emits an {Approval} event indicating the updated allowance.
459      *
460      * Requirements:
461      *
462      * - `spender` cannot be the zero address.
463      */
464     function increaseAllowance(address spender, uint256 addedValue)
465         public
466         virtual
467         returns (bool)
468     {
469         _approve(
470             _msgSender(),
471             spender,
472             _allowances[_msgSender()][spender] + addedValue
473         );
474         return true;
475     }
476 
477     /**
478      * @dev Atomically decreases the allowance granted to `spender` by the caller.
479      *
480      * This is an alternative to {approve} that can be used as a mitigation for
481      * problems described in {IERC20-approve}.
482      *
483      * Emits an {Approval} event indicating the updated allowance.
484      *
485      * Requirements:
486      *
487      * - `spender` cannot be the zero address.
488      * - `spender` must have allowance for the caller of at least
489      * `subtractedValue`.
490      */
491     function decreaseAllowance(address spender, uint256 subtractedValue)
492         public
493         virtual
494         returns (bool)
495     {
496         uint256 currentAllowance = _allowances[_msgSender()][spender];
497         require(
498             currentAllowance >= subtractedValue,
499             "ERC20: decreased allowance below zero"
500         );
501         unchecked {
502             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
503         }
504 
505         return true;
506     }
507 
508     /**
509      * @dev Moves `amount` of tokens from `sender` to `recipient`.
510      *
511      * This internal function is equivalent to {transfer}, and can be used to
512      * e.g. implement automatic token fees, slashing mechanisms, etc.
513      *
514      * Emits a {Transfer} event.
515      *
516      * Requirements:
517      *
518      * - `sender` cannot be the zero address.
519      * - `recipient` cannot be the zero address.
520      * - `sender` must have a balance of at least `amount`.
521      */
522     function _transfer(
523         address sender,
524         address recipient,
525         uint256 amount
526     ) internal virtual {
527         require(sender != address(0), "ERC20: transfer from the zero address");
528         require(recipient != address(0), "ERC20: transfer to the zero address");
529 
530         _beforeTokenTransfer(sender, recipient, amount);
531 
532         uint256 senderBalance = _balances[sender];
533         require(
534             senderBalance >= amount,
535             "ERC20: transfer amount exceeds balance"
536         );
537         unchecked {
538             _balances[sender] = senderBalance - amount;
539         }
540         _balances[recipient] += amount;
541 
542         emit Transfer(sender, recipient, amount);
543 
544         _afterTokenTransfer(sender, recipient, amount);
545     }
546 
547     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
548      * the total supply.
549      *
550      * Emits a {Transfer} event with `from` set to the zero address.
551      *
552      * Requirements:
553      *
554      * - `account` cannot be the zero address.
555      */
556     function _mint(address account, uint256 amount) internal virtual {
557         require(account != address(0), "ERC20: mint to the zero address");
558 
559         _beforeTokenTransfer(address(0), account, amount);
560 
561         _totalSupply += amount;
562         _balances[account] += amount;
563         emit Transfer(address(0), account, amount);
564 
565         _afterTokenTransfer(address(0), account, amount);
566     }
567 
568     /**
569      * @dev Destroys `amount` tokens from `account`, reducing the
570      * total supply.
571      *
572      * Emits a {Transfer} event with `to` set to the zero address.
573      *
574      * Requirements:
575      *
576      * - `account` cannot be the zero address.
577      * - `account` must have at least `amount` tokens.
578      */
579     function _burn(address account, uint256 amount) internal virtual {
580         require(account != address(0), "ERC20: burn from the zero address");
581 
582         _beforeTokenTransfer(account, address(0), amount);
583 
584         uint256 accountBalance = _balances[account];
585         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
586         unchecked {
587             _balances[account] = accountBalance - amount;
588         }
589         _totalSupply -= amount;
590 
591         emit Transfer(account, address(0), amount);
592 
593         _afterTokenTransfer(account, address(0), amount);
594     }
595 
596     /**
597      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
598      *
599      * This internal function is equivalent to `approve`, and can be used to
600      * e.g. set automatic allowances for certain subsystems, etc.
601      *
602      * Emits an {Approval} event.
603      *
604      * Requirements:
605      *
606      * - `owner` cannot be the zero address.
607      * - `spender` cannot be the zero address.
608      */
609     function _approve(
610         address owner,
611         address spender,
612         uint256 amount
613     ) internal virtual {
614         require(owner != address(0), "ERC20: approve from the zero address");
615         require(spender != address(0), "ERC20: approve to the zero address");
616 
617         _allowances[owner][spender] = amount;
618         emit Approval(owner, spender, amount);
619     }
620 
621     /**
622      * @dev Hook that is called before any transfer of tokens. This includes
623      * minting and burning.
624      *
625      * Calling conditions:
626      *
627      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
628      * will be transferred to `to`.
629      * - when `from` is zero, `amount` tokens will be minted for `to`.
630      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
631      * - `from` and `to` are never both zero.
632      *
633      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
634      */
635     function _beforeTokenTransfer(
636         address from,
637         address to,
638         uint256 amount
639     ) internal virtual {}
640 
641     /**
642      * @dev Hook that is called after any transfer of tokens. This includes
643      * minting and burning.
644      *
645      * Calling conditions:
646      *
647      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
648      * has been transferred to `to`.
649      * - when `from` is zero, `amount` tokens have been minted for `to`.
650      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
651      * - `from` and `to` are never both zero.
652      *
653      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
654      */
655     function _afterTokenTransfer(
656         address from,
657         address to,
658         uint256 amount
659     ) internal virtual {}
660 }
661 
662 // CAUTION
663 // This version of SafeMath should only be used with Solidity 0.8 or later,
664 // because it relies on the compiler's built in overflow checks.
665 
666 /**
667  * @dev Wrappers over Solidity's arithmetic operations.
668  *
669  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
670  * now has built in overflow checking.
671  */
672 library SafeMath {
673     /**
674      * @dev Returns the addition of two unsigned integers, with an overflow flag.
675      *
676      * _Available since v3.4._
677      */
678     function tryAdd(uint256 a, uint256 b)
679         internal
680         pure
681         returns (bool, uint256)
682     {
683         unchecked {
684             uint256 c = a + b;
685             if (c < a) return (false, 0);
686             return (true, c);
687         }
688     }
689 
690     /**
691      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
692      *
693      * _Available since v3.4._
694      */
695     function trySub(uint256 a, uint256 b)
696         internal
697         pure
698         returns (bool, uint256)
699     {
700         unchecked {
701             if (b > a) return (false, 0);
702             return (true, a - b);
703         }
704     }
705 
706     /**
707      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
708      *
709      * _Available since v3.4._
710      */
711     function tryMul(uint256 a, uint256 b)
712         internal
713         pure
714         returns (bool, uint256)
715     {
716         unchecked {
717             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
718             // benefit is lost if 'b' is also tested.
719             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
720             if (a == 0) return (true, 0);
721             uint256 c = a * b;
722             if (c / a != b) return (false, 0);
723             return (true, c);
724         }
725     }
726 
727     /**
728      * @dev Returns the division of two unsigned integers, with a division by zero flag.
729      *
730      * _Available since v3.4._
731      */
732     function tryDiv(uint256 a, uint256 b)
733         internal
734         pure
735         returns (bool, uint256)
736     {
737         unchecked {
738             if (b == 0) return (false, 0);
739             return (true, a / b);
740         }
741     }
742 
743     /**
744      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
745      *
746      * _Available since v3.4._
747      */
748     function tryMod(uint256 a, uint256 b)
749         internal
750         pure
751         returns (bool, uint256)
752     {
753         unchecked {
754             if (b == 0) return (false, 0);
755             return (true, a % b);
756         }
757     }
758 
759     /**
760      * @dev Returns the addition of two unsigned integers, reverting on
761      * overflow.
762      *
763      * Counterpart to Solidity's `+` operator.
764      *
765      * Requirements:
766      *
767      * - Addition cannot overflow.
768      */
769     function add(uint256 a, uint256 b) internal pure returns (uint256) {
770         return a + b;
771     }
772 
773     /**
774      * @dev Returns the subtraction of two unsigned integers, reverting on
775      * overflow (when the result is negative).
776      *
777      * Counterpart to Solidity's `-` operator.
778      *
779      * Requirements:
780      *
781      * - Subtraction cannot overflow.
782      */
783     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
784         return a - b;
785     }
786 
787     /**
788      * @dev Returns the multiplication of two unsigned integers, reverting on
789      * overflow.
790      *
791      * Counterpart to Solidity's `*` operator.
792      *
793      * Requirements:
794      *
795      * - Multiplication cannot overflow.
796      */
797     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
798         return a * b;
799     }
800 
801     /**
802      * @dev Returns the integer division of two unsigned integers, reverting on
803      * division by zero. The result is rounded towards zero.
804      *
805      * Counterpart to Solidity's `/` operator.
806      *
807      * Requirements:
808      *
809      * - The divisor cannot be zero.
810      */
811     function div(uint256 a, uint256 b) internal pure returns (uint256) {
812         return a / b;
813     }
814 
815     /**
816      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
817      * reverting when dividing by zero.
818      *
819      * Counterpart to Solidity's `%` operator. This function uses a `revert`
820      * opcode (which leaves remaining gas untouched) while Solidity uses an
821      * invalid opcode to revert (consuming all remaining gas).
822      *
823      * Requirements:
824      *
825      * - The divisor cannot be zero.
826      */
827     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
828         return a % b;
829     }
830 
831     /**
832      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
833      * overflow (when the result is negative).
834      *
835      * CAUTION: This function is deprecated because it requires allocating memory for the error
836      * message unnecessarily. For custom revert reasons use {trySub}.
837      *
838      * Counterpart to Solidity's `-` operator.
839      *
840      * Requirements:
841      *
842      * - Subtraction cannot overflow.
843      */
844     function sub(
845         uint256 a,
846         uint256 b,
847         string memory errorMessage
848     ) internal pure returns (uint256) {
849         unchecked {
850             require(b <= a, errorMessage);
851             return a - b;
852         }
853     }
854 
855     /**
856      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
857      * division by zero. The result is rounded towards zero.
858      *
859      * Counterpart to Solidity's `/` operator. Note: this function uses a
860      * `revert` opcode (which leaves remaining gas untouched) while Solidity
861      * uses an invalid opcode to revert (consuming all remaining gas).
862      *
863      * Requirements:
864      *
865      * - The divisor cannot be zero.
866      */
867     function div(
868         uint256 a,
869         uint256 b,
870         string memory errorMessage
871     ) internal pure returns (uint256) {
872         unchecked {
873             require(b > 0, errorMessage);
874             return a / b;
875         }
876     }
877 
878     /**
879      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
880      * reverting with custom message when dividing by zero.
881      *
882      * CAUTION: This function is deprecated because it requires allocating memory for the error
883      * message unnecessarily. For custom revert reasons use {tryMod}.
884      *
885      * Counterpart to Solidity's `%` operator. This function uses a `revert`
886      * opcode (which leaves remaining gas untouched) while Solidity uses an
887      * invalid opcode to revert (consuming all remaining gas).
888      *
889      * Requirements:
890      *
891      * - The divisor cannot be zero.
892      */
893     function mod(
894         uint256 a,
895         uint256 b,
896         string memory errorMessage
897     ) internal pure returns (uint256) {
898         unchecked {
899             require(b > 0, errorMessage);
900             return a % b;
901         }
902     }
903 }
904 
905 contract TheSyndicate is ERC20, Ownable {
906     using SafeMath for uint256;
907 
908     IUniswapV2Router02 public immutable uniswapV2Router;
909     address public uniswapV2Pair;
910     address public constant deadAddress = address(0xdead);
911 
912     bool private swapping;
913 
914     address public marketingWallet;
915     address public devWallet;
916 
917     uint256 public maxTransactionAmount;
918     uint256 public swapTokensAtAmount;
919     uint256 public maxWallet;
920 
921     uint256 public percentForLPBurn = 0; // 0 = 0%
922     bool public lpBurnEnabled = true;
923     uint256 public lpBurnFrequency = 360000000000000 seconds;
924     uint256 public lastLpBurnTime;
925 
926     uint256 public manualBurnFrequency = 300000000000000 minutes;
927     uint256 public lastManualLpBurnTime;
928 
929     bool public limitsInEffect = true;
930     bool public tradingActive = true;
931     bool public swapEnabled = true;
932 
933     // Anti-bot and anti-whale mappings and variables
934     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
935     bool public transferDelayEnabled = true;
936 
937     uint256 public buyTotalFees;
938     uint256 public constant buyMarketingFee = 5;
939     uint256 public constant buyLiquidityFee = 2;
940     uint256 public constant buyDevFee = 0;
941 
942     uint256 public sellTotalFees;
943     uint256 public constant sellMarketingFee = 5;
944     uint256 public constant sellLiquidityFee = 2;
945     uint256 public constant sellDevFee = 2;
946 
947     uint256 public tokensForMarketing;
948     uint256 public tokensForLiquidity;
949     uint256 public tokensForDev;
950 
951     /******************/
952 
953     // exlcude from fees and max transaction amount
954     mapping(address => bool) private _isExcludedFromFees;
955     mapping(address => bool) public _isExcludedMaxTransactionAmount;
956 
957     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
958     // could be subject to a maximum transfer amount
959     mapping(address => bool) public automatedMarketMakerPairs;
960 
961     event UpdateUniswapV2Router(
962         address indexed newAddress,
963         address indexed oldAddress
964     );
965 
966     event ExcludeFromFees(address indexed account, bool isExcluded);
967 
968     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
969 
970     event marketingWalletUpdated(
971         address indexed newWallet,
972         address indexed oldWallet
973     );
974 
975     event devWalletUpdated(
976         address indexed newWallet,
977         address indexed oldWallet
978     );
979 
980     event SwapAndLiquify(
981         uint256 tokensSwapped,
982         uint256 ethReceived,
983         uint256 tokensIntoLiquidity
984     );
985 
986     event AutoNukeLP();
987 
988     event ManualNukeLP();
989 
990     event BoughtEarly(address indexed sniper);
991 
992     constructor() ERC20("SYNDC", "The Syndicate") {
993         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
994             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
995         );
996 
997         excludeFromMaxTransaction(address(_uniswapV2Router), true);
998         uniswapV2Router = _uniswapV2Router;
999 
1000         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1001             .createPair(address(this), _uniswapV2Router.WETH());
1002         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1003         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1004 
1005         uint256 totalSupply = 1_000_000_000 * 1e18; // 1 billion total supply
1006 
1007         maxTransactionAmount = 30_000_000 * 1e18; //3% from total supply maxTransactionAmountTxn
1008         maxWallet = 30_000_000 * 1e18; // 3% from total supply maxWallet
1009         swapTokensAtAmount = (totalSupply * 3) / 10000; // 0.03% swap wallet
1010 
1011         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1012         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1013 
1014         marketingWallet = address(0xcf5BeF2A522b7f4C740D28aB431308DE78DbFBFE); // set as marketing wallet
1015         devWallet = address(0xcf5BeF2A522b7f4C740D28aB431308DE78DbFBFE); // set as dev wallet
1016 
1017         // exclude from paying fees or having max transaction amount
1018         excludeFromFees(owner(), true);
1019         excludeFromFees(address(this), true);
1020         excludeFromFees(address(0xdead), true);
1021 
1022         excludeFromMaxTransaction(owner(), true);
1023         excludeFromMaxTransaction(address(this), true);
1024         excludeFromMaxTransaction(address(0xdead), true);
1025 
1026         /*
1027             _mint is an internal function in ERC20.sol that is only called here,
1028             and CANNOT be called ever again
1029         */
1030         _mint(msg.sender, totalSupply);
1031     }
1032 
1033     receive() external payable {}
1034 
1035     // once enabled, can never be turned off
1036     function startTrading() external onlyOwner {
1037         tradingActive = true;
1038         swapEnabled = true;
1039         lastLpBurnTime = block.timestamp;
1040     }
1041 
1042     // remove limits after token is stable
1043     function removeLimits() external onlyOwner returns (bool) {
1044         limitsInEffect = false;
1045         return true;
1046     }
1047 
1048     // disable Transfer delay - cannot be reenabled
1049     function disableTransferDelay() external onlyOwner returns (bool) {
1050         transferDelayEnabled = false;
1051         return true;
1052     }
1053 
1054     // change the minimum amount of tokens to sell from fees
1055     function updateSwapTokensAtAmount(uint256 newAmount)
1056         external
1057         onlyOwner
1058         returns (bool)
1059     {
1060         require(
1061             newAmount >= (totalSupply() * 1) / 100000,
1062             "Swap amount cannot be lower than 0.001% total supply."
1063         );
1064         require(
1065             newAmount <= (totalSupply() * 5) / 1000,
1066             "Swap amount cannot be higher than 0.5% total supply."
1067         );
1068         swapTokensAtAmount = newAmount;
1069         return true;
1070     }
1071 
1072     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1073         require(
1074             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1075             "Cannot set maxTransactionAmount lower than 0.1%"
1076         );
1077         maxTransactionAmount = newNum * (10**18);
1078     }
1079 
1080     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1081         require(
1082             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1083             "Cannot set maxWallet lower than 0.5%"
1084         );
1085         maxWallet = newNum * (10**18);
1086     }
1087 
1088     function excludeFromMaxTransaction(address updAds, bool isEx)
1089         public
1090         onlyOwner
1091     {
1092         _isExcludedMaxTransactionAmount[updAds] = isEx;
1093     }
1094 
1095     // only use to disable contract sales if absolutely necessary (emergency use only)
1096     function updateSwapEnabled(bool enabled) external onlyOwner {
1097         swapEnabled = enabled;
1098     }
1099 
1100     function excludeFromFees(address account, bool excluded) public onlyOwner {
1101         _isExcludedFromFees[account] = excluded;
1102         emit ExcludeFromFees(account, excluded);
1103     }
1104 
1105     function setAutomatedMarketMakerPair(address pair, bool value)
1106         public
1107         onlyOwner
1108     {
1109         require(
1110             pair != uniswapV2Pair,
1111             "The pair cannot be removed from automatedMarketMakerPairs"
1112         );
1113 
1114         _setAutomatedMarketMakerPair(pair, value);
1115     }
1116 
1117     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1118         automatedMarketMakerPairs[pair] = value;
1119 
1120         emit SetAutomatedMarketMakerPair(pair, value);
1121     }
1122 
1123     function updateMarketingWallet(address newMarketingWallet)
1124         external
1125         onlyOwner
1126     {
1127         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1128         marketingWallet = newMarketingWallet;
1129     }
1130 
1131     function updateDevWallet(address newWallet) external onlyOwner {
1132         emit devWalletUpdated(newWallet, devWallet);
1133         devWallet = newWallet;
1134     }
1135 
1136     function isExcludedFromFees(address account) public view returns (bool) {
1137         return _isExcludedFromFees[account];
1138     }
1139 
1140     function _transfer(
1141         address from,
1142         address to,
1143         uint256 amount
1144     ) internal override {
1145         require(from != address(0), "ERC20: transfer from the zero address");
1146         require(to != address(0), "ERC20: transfer to the zero address");
1147 
1148         if (amount == 0) {
1149             super._transfer(from, to, 0);
1150             return;
1151         }
1152 
1153         if (limitsInEffect) {
1154             if (
1155                 from != owner() &&
1156                 to != owner() &&
1157                 to != address(0) &&
1158                 to != address(0xdead) &&
1159                 !swapping
1160             ) {
1161                 if (!tradingActive) {
1162                     require(
1163                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1164                         "Trading is not active."
1165                     );
1166                 }
1167 
1168                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1169                 if (transferDelayEnabled) {
1170                     if (
1171                         to != owner() &&
1172                         to != address(uniswapV2Router) &&
1173                         to != address(uniswapV2Pair)
1174                     ) {
1175                         require(
1176                             _holderLastTransferTimestamp[tx.origin] <
1177                                 block.number,
1178                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1179                         );
1180                         _holderLastTransferTimestamp[tx.origin] = block.number;
1181                     }
1182                 }
1183 
1184                 //when buy
1185                 if (
1186                     automatedMarketMakerPairs[from] &&
1187                     !_isExcludedMaxTransactionAmount[to]
1188                 ) {
1189                     require(
1190                         amount <= maxTransactionAmount,
1191                         "Buy transfer amount exceeds the maxTransactionAmount."
1192                     );
1193                     require(
1194                         amount + balanceOf(to) <= maxWallet,
1195                         "Max wallet exceeded"
1196                     );
1197                 }
1198                 //when sell
1199                 else if (
1200                     automatedMarketMakerPairs[to] &&
1201                     !_isExcludedMaxTransactionAmount[from]
1202                 ) {
1203                     require(
1204                         amount <= maxTransactionAmount,
1205                         "Sell transfer amount exceeds the maxTransactionAmount."
1206                     );
1207                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1208                     require(
1209                         amount + balanceOf(to) <= maxWallet,
1210                         "Max wallet exceeded"
1211                     );
1212                 }
1213             }
1214         }
1215 
1216         uint256 contractTokenBalance = balanceOf(address(this));
1217 
1218         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1219 
1220         if (
1221             canSwap &&
1222             swapEnabled &&
1223             !swapping &&
1224             !automatedMarketMakerPairs[from] &&
1225             !_isExcludedFromFees[from] &&
1226             !_isExcludedFromFees[to]
1227         ) {
1228             swapping = true;
1229 
1230             swapBack();
1231 
1232             swapping = false;
1233         }
1234 
1235         if (
1236             !swapping &&
1237             automatedMarketMakerPairs[to] &&
1238             lpBurnEnabled &&
1239             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1240             !_isExcludedFromFees[from]
1241         ) {
1242             autoBurnLiquidityPairTokens();
1243         }
1244 
1245         bool takeFee = !swapping;
1246 
1247         // if any account belongs to _isExcludedFromFee account then remove the fee
1248         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1249             takeFee = false;
1250         }
1251 
1252         uint256 fees = 0;
1253         // only take fees on buys/sells, do not take on wallet transfers
1254         if (takeFee) {
1255             // on sell
1256             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1257                 fees = amount.mul(sellTotalFees).div(100);
1258                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1259                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1260                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1261             }
1262             // on buy
1263             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1264                 fees = amount.mul(buyTotalFees).div(100);
1265                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1266                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1267                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1268             }
1269 
1270             if (fees > 0) {
1271                 super._transfer(from, address(this), fees);
1272             }
1273 
1274             amount -= fees;
1275         }
1276 
1277         super._transfer(from, to, amount);
1278     }
1279 
1280     function swapTokensForEth(uint256 tokenAmount) private {
1281         // generate the uniswap pair path of token -> weth
1282         address[] memory path = new address[](2);
1283         path[0] = address(this);
1284         path[1] = uniswapV2Router.WETH();
1285 
1286         _approve(address(this), address(uniswapV2Router), tokenAmount);
1287 
1288         // make the swap
1289         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1290             tokenAmount,
1291             0, // accept any amount of ETH
1292             path,
1293             address(this),
1294             block.timestamp
1295         );
1296     }
1297 
1298     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1299         // approve token transfer to cover all possible scenarios
1300         _approve(address(this), address(uniswapV2Router), tokenAmount);
1301 
1302         // add the liquidity
1303         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1304             address(this),
1305             tokenAmount,
1306             0, // slippage is unavoidable
1307             0, // slippage is unavoidable
1308             deadAddress,
1309             block.timestamp
1310         );
1311     }
1312 
1313     function swapBack() private {
1314         uint256 contractBalance = balanceOf(address(this));
1315         uint256 totalTokensToSwap = tokensForLiquidity +
1316             tokensForMarketing +
1317             tokensForDev;
1318         bool success;
1319 
1320         if (contractBalance == 0 || totalTokensToSwap == 0) {
1321             return;
1322         }
1323 
1324         if (contractBalance > swapTokensAtAmount * 20) {
1325             contractBalance = swapTokensAtAmount * 20;
1326         }
1327 
1328         // Halve the amount of liquidity tokens
1329         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1330             totalTokensToSwap /
1331             2;
1332         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1333 
1334         uint256 initialETHBalance = address(this).balance;
1335 
1336         swapTokensForEth(amountToSwapForETH);
1337 
1338         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1339 
1340         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1341             totalTokensToSwap
1342         );
1343         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1344 
1345         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1346 
1347         tokensForLiquidity = 0;
1348         tokensForMarketing = 0;
1349         tokensForDev = 0;
1350 
1351         (success, ) = address(devWallet).call{value: ethForDev}("");
1352 
1353         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1354             addLiquidity(liquidityTokens, ethForLiquidity);
1355             emit SwapAndLiquify(
1356                 amountToSwapForETH,
1357                 ethForLiquidity,
1358                 tokensForLiquidity
1359             );
1360         }
1361 
1362         (success, ) = address(marketingWallet).call{
1363             value: address(this).balance
1364         }("");
1365     }
1366 
1367     function setAutoLPBurnSettings(
1368         uint256 _frequencyInSeconds,
1369         uint256 _percent,
1370         bool _Enabled
1371     ) external onlyOwner {
1372         require(
1373             _frequencyInSeconds >= 600,
1374             "cannot set buyback more often than every 10 minutes"
1375         );
1376         require(
1377             _percent <= 1000 && _percent >= 0,
1378             "Must set auto LP burn percent between 0% and 10%"
1379         );
1380         lpBurnFrequency = _frequencyInSeconds;
1381         percentForLPBurn = _percent;
1382         lpBurnEnabled = _Enabled;
1383     }
1384 
1385     function autoBurnLiquidityPairTokens() internal returns (bool) {
1386         lastLpBurnTime = block.timestamp;
1387 
1388         // get balance of liquidity pair
1389         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1390 
1391         // calculate amount to burn
1392         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1393             10000
1394         );
1395 
1396         // pull tokens from pancakePair liquidity and move to dead address permanently
1397         if (amountToBurn > 0) {
1398             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1399         }
1400 
1401         //sync price since this is not in a swap transaction!
1402         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1403         pair.sync();
1404         emit AutoNukeLP();
1405         return true;
1406     }
1407 
1408     function manualBurnLiquidityPairTokens(uint256 percent)
1409         external
1410         onlyOwner
1411         returns (bool)
1412     {
1413         require(
1414             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1415             "Must wait for cooldown to finish"
1416         );
1417         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1418         lastManualLpBurnTime = block.timestamp;
1419 
1420         // get balance of liquidity pair
1421         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1422 
1423         // calculate amount to burn
1424         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1425 
1426         // pull tokens from pancakePair liquidity and move to dead address permanently
1427         if (amountToBurn > 0) {
1428             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1429         }
1430 
1431         //sync price since this is not in a swap transaction!
1432         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1433         pair.sync();
1434         emit ManualNukeLP();
1435         return true;
1436     }
1437 }