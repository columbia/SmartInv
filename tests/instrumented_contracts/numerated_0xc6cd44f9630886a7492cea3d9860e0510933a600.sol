1 //
2 //      Fake Market Cap
3 //      
4 //      @sterlingcrispin 
5 // 
6 //      NotAudited.xyz
7 //
8 //      no warranty expressed or implied
9 //
10 //      this is a social experiment and not an investment
11 //
12 
13 
14 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
15 
16 
17 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 // CAUTION
22 // This version of SafeMath should only be used with Solidity 0.8 or later,
23 // because it relies on the compiler's built in overflow checks.
24 
25 /**
26  * @dev Wrappers over Solidity's arithmetic operations.
27  *
28  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
29  * now has built in overflow checking.
30  */
31 library SafeMath {
32     /**
33      * @dev Returns the addition of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             uint256 c = a + b;
40             if (c < a) return (false, 0);
41             return (true, c);
42         }
43     }
44 
45     /**
46      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             if (b > a) return (false, 0);
53             return (true, a - b);
54         }
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65             // benefit is lost if 'b' is also tested.
66             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67             if (a == 0) return (true, 0);
68             uint256 c = a * b;
69             if (c / a != b) return (false, 0);
70             return (true, c);
71         }
72     }
73 
74     /**
75      * @dev Returns the division of two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a / b);
83         }
84     }
85 
86     /**
87      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
92         unchecked {
93             if (b == 0) return (false, 0);
94             return (true, a % b);
95         }
96     }
97 
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a + b;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a - b;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      *
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a * b;
138     }
139 
140     /**
141      * @dev Returns the integer division of two unsigned integers, reverting on
142      * division by zero. The result is rounded towards zero.
143      *
144      * Counterpart to Solidity's `/` operator.
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a / b;
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * reverting when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return a % b;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * CAUTION: This function is deprecated because it requires allocating memory for the error
175      * message unnecessarily. For custom revert reasons use {trySub}.
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(
184         uint256 a,
185         uint256 b,
186         string memory errorMessage
187     ) internal pure returns (uint256) {
188         unchecked {
189             require(b <= a, errorMessage);
190             return a - b;
191         }
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(
207         uint256 a,
208         uint256 b,
209         string memory errorMessage
210     ) internal pure returns (uint256) {
211         unchecked {
212             require(b > 0, errorMessage);
213             return a / b;
214         }
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * reverting with custom message when dividing by zero.
220      *
221      * CAUTION: This function is deprecated because it requires allocating memory for the error
222      * message unnecessarily. For custom revert reasons use {tryMod}.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(
233         uint256 a,
234         uint256 b,
235         string memory errorMessage
236     ) internal pure returns (uint256) {
237         unchecked {
238             require(b > 0, errorMessage);
239             return a % b;
240         }
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Context.sol
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Provides information about the current execution context, including the
253  * sender of the transaction and its data. While these are generally available
254  * via msg.sender and msg.data, they should not be accessed in such a direct
255  * manner, since when dealing with meta-transactions the account sending and
256  * paying for execution may not be the actual sender (as far as an application
257  * is concerned).
258  *
259  * This contract is only required for intermediate, library-like contracts.
260  */
261 abstract contract Context {
262     function _msgSender() internal view virtual returns (address) {
263         return msg.sender;
264     }
265 
266     function _msgData() internal view virtual returns (bytes calldata) {
267         return msg.data;
268     }
269 }
270 
271 // File: @openzeppelin/contracts/access/Ownable.sol
272 
273 
274 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
275 
276 pragma solidity ^0.8.0;
277 
278 
279 /**
280  * @dev Contract module which provides a basic access control mechanism, where
281  * there is an account (an owner) that can be granted exclusive access to
282  * specific functions.
283  *
284  * By default, the owner account will be the one that deploys the contract. This
285  * can later be changed with {transferOwnership}.
286  *
287  * This module is used through inheritance. It will make available the modifier
288  * `onlyOwner`, which can be applied to your functions to restrict their use to
289  * the owner.
290  */
291 abstract contract Ownable is Context {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     /**
297      * @dev Initializes the contract setting the deployer as the initial owner.
298      */
299     constructor() {
300         _transferOwnership(_msgSender());
301     }
302 
303     /**
304      * @dev Throws if called by any account other than the owner.
305      */
306     modifier onlyOwner() {
307         _checkOwner();
308         _;
309     }
310 
311     /**
312      * @dev Returns the address of the current owner.
313      */
314     function owner() public view virtual returns (address) {
315         return _owner;
316     }
317 
318     /**
319      * @dev Throws if the sender is not the owner.
320      */
321     function _checkOwner() internal view virtual {
322         require(owner() == _msgSender(), "Ownable: caller is not the owner");
323     }
324 
325     /**
326      * @dev Leaves the contract without owner. It will not be possible to call
327      * `onlyOwner` functions anymore. Can only be called by the current owner.
328      *
329      * NOTE: Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public virtual onlyOwner {
333         _transferOwnership(address(0));
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Can only be called by the current owner.
339      */
340     function transferOwnership(address newOwner) public virtual onlyOwner {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         _transferOwnership(newOwner);
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      * Internal function without access restriction.
348      */
349     function _transferOwnership(address newOwner) internal virtual {
350         address oldOwner = _owner;
351         _owner = newOwner;
352         emit OwnershipTransferred(oldOwner, newOwner);
353     }
354 }
355 
356 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
357 
358 
359 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @dev Interface of the ERC20 standard as defined in the EIP.
365  */
366 interface IERC20 {
367     /**
368      * @dev Emitted when `value` tokens are moved from one account (`from`) to
369      * another (`to`).
370      *
371      * Note that `value` may be zero.
372      */
373     event Transfer(address indexed from, address indexed to, uint256 value);
374 
375     /**
376      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
377      * a call to {approve}. `value` is the new allowance.
378      */
379     event Approval(address indexed owner, address indexed spender, uint256 value);
380 
381     /**
382      * @dev Returns the amount of tokens in existence.
383      */
384     function totalSupply() external view returns (uint256);
385 
386     /**
387      * @dev Returns the amount of tokens owned by `account`.
388      */
389     function balanceOf(address account) external view returns (uint256);
390 
391     /**
392      * @dev Moves `amount` tokens from the caller's account to `to`.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * Emits a {Transfer} event.
397      */
398     function transfer(address to, uint256 amount) external returns (bool);
399 
400     /**
401      * @dev Returns the remaining number of tokens that `spender` will be
402      * allowed to spend on behalf of `owner` through {transferFrom}. This is
403      * zero by default.
404      *
405      * This value changes when {approve} or {transferFrom} are called.
406      */
407     function allowance(address owner, address spender) external view returns (uint256);
408 
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * IMPORTANT: Beware that changing an allowance with this method brings the risk
415      * that someone may use both the old and the new allowance by unfortunate
416      * transaction ordering. One possible solution to mitigate this race
417      * condition is to first reduce the spender's allowance to 0 and set the
418      * desired value afterwards:
419      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
420      *
421      * Emits an {Approval} event.
422      */
423     function approve(address spender, uint256 amount) external returns (bool);
424 
425     /**
426      * @dev Moves `amount` tokens from `from` to `to` using the
427      * allowance mechanism. `amount` is then deducted from the caller's
428      * allowance.
429      *
430      * Returns a boolean value indicating whether the operation succeeded.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(
435         address from,
436         address to,
437         uint256 amount
438     ) external returns (bool);
439 }
440 
441 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
442 
443 
444 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 
449 /**
450  * @dev Interface for the optional metadata functions from the ERC20 standard.
451  *
452  * _Available since v4.1._
453  */
454 interface IERC20Metadata is IERC20 {
455     /**
456      * @dev Returns the name of the token.
457      */
458     function name() external view returns (string memory);
459 
460     /**
461      * @dev Returns the symbol of the token.
462      */
463     function symbol() external view returns (string memory);
464 
465     /**
466      * @dev Returns the decimals places of the token.
467      */
468     function decimals() external view returns (uint8);
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
472 
473 
474 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 
479 
480 
481 /**
482  * @dev Implementation of the {IERC20} interface.
483  *
484  * This implementation is agnostic to the way tokens are created. This means
485  * that a supply mechanism has to be added in a derived contract using {_mint}.
486  * For a generic mechanism see {ERC20PresetMinterPauser}.
487  *
488  * TIP: For a detailed writeup see our guide
489  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
490  * to implement supply mechanisms].
491  *
492  * We have followed general OpenZeppelin Contracts guidelines: functions revert
493  * instead returning `false` on failure. This behavior is nonetheless
494  * conventional and does not conflict with the expectations of ERC20
495  * applications.
496  *
497  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
498  * This allows applications to reconstruct the allowance for all accounts just
499  * by listening to said events. Other implementations of the EIP may not emit
500  * these events, as it isn't required by the specification.
501  *
502  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
503  * functions have been added to mitigate the well-known issues around setting
504  * allowances. See {IERC20-approve}.
505  */
506 contract ERC20 is Context, IERC20, IERC20Metadata {
507     mapping(address => uint256) private _balances;
508 
509     mapping(address => mapping(address => uint256)) private _allowances;
510 
511     // yes that's right I just edited this variable to be public
512     // yes I could have done this another way
513     // if you are reading this, pllease tweet 
514     // "I am an itty bitty baby, I am an itty bitty boat, thank you @sterlingcrispin"
515     // and I will airdrop the first five people a little of this CAP coin
516     // but if you are reading this it's probably too late
517     uint256 public _totalSupply;
518 
519     string private _name;
520     string private _symbol;
521 
522     /**
523      * @dev Sets the values for {name} and {symbol}.
524      *
525      * The default value of {decimals} is 18. To select a different value for
526      * {decimals} you should overload it.
527      *
528      * All two of these values are immutable: they can only be set once during
529      * construction.
530      */
531     constructor(string memory name_, string memory symbol_) {
532         _name = name_;
533         _symbol = symbol_;
534     }
535 
536     /**
537      * @dev Returns the name of the token.
538      */
539     function name() public view virtual override returns (string memory) {
540         return _name;
541     }
542 
543     /**
544      * @dev Returns the symbol of the token, usually a shorter version of the
545      * name.
546      */
547     function symbol() public view virtual override returns (string memory) {
548         return _symbol;
549     }
550 
551     /**
552      * @dev Returns the number of decimals used to get its user representation.
553      * For example, if `decimals` equals `2`, a balance of `505` tokens should
554      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
555      *
556      * Tokens usually opt for a value of 18, imitating the relationship between
557      * Ether and Wei. This is the value {ERC20} uses, unless this function is
558      * overridden;
559      *
560      * NOTE: This information is only used for _display_ purposes: it in
561      * no way affects any of the arithmetic of the contract, including
562      * {IERC20-balanceOf} and {IERC20-transfer}.
563      */
564     function decimals() public view virtual override returns (uint8) {
565         return 18;
566     }
567 
568     /**
569      * @dev See {IERC20-totalSupply}.
570      */
571     function totalSupply() public view virtual override returns (uint256) {
572         return _totalSupply;
573     }
574 
575     /**
576      * @dev See {IERC20-balanceOf}.
577      */
578     function balanceOf(address account) public view virtual override returns (uint256) {
579         return _balances[account];
580     }
581 
582     /**
583      * @dev See {IERC20-transfer}.
584      *
585      * Requirements:
586      *
587      * - `to` cannot be the zero address.
588      * - the caller must have a balance of at least `amount`.
589      */
590     function transfer(address to, uint256 amount) public virtual override returns (bool) {
591         address owner = _msgSender();
592         _transfer(owner, to, amount);
593         return true;
594     }
595 
596     /**
597      * @dev See {IERC20-allowance}.
598      */
599     function allowance(address owner, address spender) public view virtual override returns (uint256) {
600         return _allowances[owner][spender];
601     }
602 
603     /**
604      * @dev See {IERC20-approve}.
605      *
606      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
607      * `transferFrom`. This is semantically equivalent to an infinite approval.
608      *
609      * Requirements:
610      *
611      * - `spender` cannot be the zero address.
612      */
613     function approve(address spender, uint256 amount) public virtual override returns (bool) {
614         address owner = _msgSender();
615         _approve(owner, spender, amount);
616         return true;
617     }
618 
619     /**
620      * @dev See {IERC20-transferFrom}.
621      *
622      * Emits an {Approval} event indicating the updated allowance. This is not
623      * required by the EIP. See the note at the beginning of {ERC20}.
624      *
625      * NOTE: Does not update the allowance if the current allowance
626      * is the maximum `uint256`.
627      *
628      * Requirements:
629      *
630      * - `from` and `to` cannot be the zero address.
631      * - `from` must have a balance of at least `amount`.
632      * - the caller must have allowance for ``from``'s tokens of at least
633      * `amount`.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 amount
639     ) public virtual override returns (bool) {
640         address spender = _msgSender();
641         _spendAllowance(from, spender, amount);
642         _transfer(from, to, amount);
643         return true;
644     }
645 
646     /**
647      * @dev Atomically increases the allowance granted to `spender` by the caller.
648      *
649      * This is an alternative to {approve} that can be used as a mitigation for
650      * problems described in {IERC20-approve}.
651      *
652      * Emits an {Approval} event indicating the updated allowance.
653      *
654      * Requirements:
655      *
656      * - `spender` cannot be the zero address.
657      */
658     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
659         address owner = _msgSender();
660         _approve(owner, spender, allowance(owner, spender) + addedValue);
661         return true;
662     }
663 
664     /**
665      * @dev Atomically decreases the allowance granted to `spender` by the caller.
666      *
667      * This is an alternative to {approve} that can be used as a mitigation for
668      * problems described in {IERC20-approve}.
669      *
670      * Emits an {Approval} event indicating the updated allowance.
671      *
672      * Requirements:
673      *
674      * - `spender` cannot be the zero address.
675      * - `spender` must have allowance for the caller of at least
676      * `subtractedValue`.
677      */
678     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
679         address owner = _msgSender();
680         uint256 currentAllowance = allowance(owner, spender);
681         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
682         unchecked {
683             _approve(owner, spender, currentAllowance - subtractedValue);
684         }
685 
686         return true;
687     }
688 
689     /**
690      * @dev Moves `amount` of tokens from `from` to `to`.
691      *
692      * This internal function is equivalent to {transfer}, and can be used to
693      * e.g. implement automatic token fees, slashing mechanisms, etc.
694      *
695      * Emits a {Transfer} event.
696      *
697      * Requirements:
698      *
699      * - `from` cannot be the zero address.
700      * - `to` cannot be the zero address.
701      * - `from` must have a balance of at least `amount`.
702      */
703     function _transfer(
704         address from,
705         address to,
706         uint256 amount
707     ) internal virtual {
708         require(from != address(0), "ERC20: transfer from the zero address");
709         require(to != address(0), "ERC20: transfer to the zero address");
710 
711         _beforeTokenTransfer(from, to, amount);
712 
713         uint256 fromBalance = _balances[from];
714         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
715         unchecked {
716             _balances[from] = fromBalance - amount;
717             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
718             // decrementing then incrementing.
719             _balances[to] += amount;
720         }
721 
722         emit Transfer(from, to, amount);
723 
724         _afterTokenTransfer(from, to, amount);
725     }
726 
727     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
728      * the total supply.
729      *
730      * Emits a {Transfer} event with `from` set to the zero address.
731      *
732      * Requirements:
733      *
734      * - `account` cannot be the zero address.
735      */
736     function _mint(address account, uint256 amount) internal virtual {
737         require(account != address(0), "ERC20: mint to the zero address");
738 
739         _beforeTokenTransfer(address(0), account, amount);
740 
741         _totalSupply += amount;
742         unchecked {
743             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
744             _balances[account] += amount;
745         }
746         emit Transfer(address(0), account, amount);
747 
748         _afterTokenTransfer(address(0), account, amount);
749     }
750 
751     /**
752      * @dev Destroys `amount` tokens from `account`, reducing the
753      * total supply.
754      *
755      * Emits a {Transfer} event with `to` set to the zero address.
756      *
757      * Requirements:
758      *
759      * - `account` cannot be the zero address.
760      * - `account` must have at least `amount` tokens.
761      */
762     function _burn(address account, uint256 amount) internal virtual {
763         require(account != address(0), "ERC20: burn from the zero address");
764 
765         _beforeTokenTransfer(account, address(0), amount);
766 
767         uint256 accountBalance = _balances[account];
768         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
769         unchecked {
770             _balances[account] = accountBalance - amount;
771             // Overflow not possible: amount <= accountBalance <= totalSupply.
772             _totalSupply -= amount;
773         }
774 
775         emit Transfer(account, address(0), amount);
776 
777         _afterTokenTransfer(account, address(0), amount);
778     }
779 
780     /**
781      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
782      *
783      * This internal function is equivalent to `approve`, and can be used to
784      * e.g. set automatic allowances for certain subsystems, etc.
785      *
786      * Emits an {Approval} event.
787      *
788      * Requirements:
789      *
790      * - `owner` cannot be the zero address.
791      * - `spender` cannot be the zero address.
792      */
793     function _approve(
794         address owner,
795         address spender,
796         uint256 amount
797     ) internal virtual {
798         require(owner != address(0), "ERC20: approve from the zero address");
799         require(spender != address(0), "ERC20: approve to the zero address");
800 
801         _allowances[owner][spender] = amount;
802         emit Approval(owner, spender, amount);
803     }
804 
805     /**
806      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
807      *
808      * Does not update the allowance amount in case of infinite allowance.
809      * Revert if not enough allowance is available.
810      *
811      * Might emit an {Approval} event.
812      */
813     function _spendAllowance(
814         address owner,
815         address spender,
816         uint256 amount
817     ) internal virtual {
818         uint256 currentAllowance = allowance(owner, spender);
819         if (currentAllowance != type(uint256).max) {
820             require(currentAllowance >= amount, "ERC20: insufficient allowance");
821             unchecked {
822                 _approve(owner, spender, currentAllowance - amount);
823             }
824         }
825     }
826 
827     /**
828      * @dev Hook that is called before any transfer of tokens. This includes
829      * minting and burning.
830      *
831      * Calling conditions:
832      *
833      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
834      * will be transferred to `to`.
835      * - when `from` is zero, `amount` tokens will be minted for `to`.
836      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
837      * - `from` and `to` are never both zero.
838      *
839      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
840      */
841     function _beforeTokenTransfer(
842         address from,
843         address to,
844         uint256 amount
845     ) internal virtual {}
846 
847     /**
848      * @dev Hook that is called after any transfer of tokens. This includes
849      * minting and burning.
850      *
851      * Calling conditions:
852      *
853      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
854      * has been transferred to `to`.
855      * - when `from` is zero, `amount` tokens have been minted for `to`.
856      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
857      * - `from` and `to` are never both zero.
858      *
859      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
860      */
861     function _afterTokenTransfer(
862         address from,
863         address to,
864         uint256 amount
865     ) internal virtual {}
866 }
867 
868 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
869 
870 
871 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
872 
873 pragma solidity ^0.8.0;
874 
875 
876 
877 /**
878  * @dev Extension of {ERC20} that allows token holders to destroy both their own
879  * tokens and those that they have an allowance for, in a way that can be
880  * recognized off-chain (via event analysis).
881  */
882 abstract contract ERC20Burnable is Context, ERC20 {
883     /**
884      * @dev Destroys `amount` tokens from the caller.
885      *
886      * See {ERC20-_burn}.
887      */
888     function burn(uint256 amount) public virtual {
889         _burn(_msgSender(), amount);
890     }
891 
892     /**
893      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
894      * allowance.
895      *
896      * See {ERC20-_burn} and {ERC20-allowance}.
897      *
898      * Requirements:
899      *
900      * - the caller must have allowance for ``accounts``'s tokens of at least
901      * `amount`.
902      */
903     function burnFrom(address account, uint256 amount) public virtual {
904         _spendAllowance(account, _msgSender(), amount);
905         _burn(account, amount);
906     }
907 }
908 
909 // File: contracts/FakeMarketCap.sol
910 
911 
912 
913 //
914 //      Fake Market Cap
915 //      
916 //      @sterlingcrispin 
917 // 
918 //      NotAudited.xyz
919 //
920 //      no warranty expressed or implied
921 //
922 //      this is a social experiment and not an investment
923 //
924 
925 pragma solidity ^0.8.9;
926 
927 
928 
929 
930 
931 contract FakeMarketCap is ERC20, ERC20Burnable, Ownable {
932     constructor() ERC20("Fake Market Cap", "CAP") {}
933     using SafeMath for uint256;
934 
935     // 10% increase per trade
936     // aka
937     // 1100000000000000000
938     uint256 public rate = 11e17; 
939     // .001% min increase
940     // aka
941     // 1001000000000000000
942     uint256 public minRate = 1001e15; 
943 
944     // how much the rate of increase should decay
945     // ie: it starts off at a 10% rate of growth and slowly
946     // decays to 9.5% growth, 7%, 3%,..etc until 0.001% growth
947     // this is to extend the rate of growth at the tail end
948     // of the range, otherwise this would end too quickly
949     // rate of decay 0.9999
950     uint256 public decayRate = 9999;
951     uint256 public decayBasis = 10000;
952 
953     // failsafe 
954     bool public shouldIncrease = true;
955 
956     // Maximum possible uint256 value
957     uint256 constant MAX_UINT256 = ~uint256(0); 
958 
959     // so I can keep track of the status of the coin
960     bool public failsafeTriggered = false;
961 
962     // prevent contract owner from minting any new real coins
963     bool public mintEnabled = true;
964 
965     // this can only be called once
966     // 420,690,000 coins
967     // aka
968     // 420690000000000000000000000
969     function mint(address to) public onlyOwner {
970         require(mintEnabled == true, "Already Minted");
971         _mint(to, 42069e22);
972         mintEnabled = false;
973     }
974 
975     // this could probably be more gas optimized
976     // sorry Cygaar
977     function _beforeTokenTransfer(
978         address from,
979         address to,
980         uint256 amount
981     ) override internal virtual {
982         // this If Statement is a second fail safe, in the event that transfers start reverting
983         // for an unexpected reason I can disable all of this experimental stuff
984         // and allow the coin to operate as a normal coin would
985         if(shouldIncrease){
986             // Fail safe check if multiplication would overflow
987             if (_totalSupply > type(uint256).max / rate) {
988                 failsafeTriggered = true;
989                 return;
990             }
991             // Calculate increase
992             _totalSupply = (_totalSupply * rate) / 1e18; 
993             // Adjust rate with a decay factor
994             if (rate > minRate) {
995                 // Slow down the increase rate by 0.9999
996                 rate = (rate * decayRate) / decayBasis; 
997                 if (rate < minRate) {
998                     // rate shouldn't go below 1.001%
999                     rate = minRate; 
1000                 }
1001             }
1002         }
1003     }
1004 
1005     // set or reset status of the growth
1006     function setValues(
1007         uint256 _rate,
1008         uint256 _minRate, 
1009         uint256 _decayRate,
1010         uint256 _decayBasis,
1011         uint256 _newSupply, 
1012         bool _shouldIncrease,
1013         bool _failsafeTriggered
1014 
1015     ) public {
1016         rate = _rate;
1017         minRate = _minRate;
1018         decayRate = _decayRate;
1019         decayBasis = _decayBasis;
1020         _totalSupply = _newSupply;
1021         shouldIncrease = _shouldIncrease;
1022         failsafeTriggered = _failsafeTriggered;
1023     }
1024 
1025     // Bulk send function
1026     function bulkSend(address[] memory recipients, uint256[] memory amounts) public onlyOwner {
1027         require(recipients.length == amounts.length, "Array lengths must match");
1028 
1029         for (uint256 i = 0; i < recipients.length; i++) {
1030             _transfer(msg.sender, recipients[i], amounts[i]);
1031         }
1032     }
1033 
1034     // this literally does nothing, do not interact with this
1035     mapping(address => bool) public chungo;
1036     function registerForScrungus(address to) public {
1037         chungo[to] = true;
1038     }
1039 }