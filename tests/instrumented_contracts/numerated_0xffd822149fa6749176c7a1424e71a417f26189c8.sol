1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Context.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Provides information about the current execution context, including the
240  * sender of the transaction and its data. While these are generally available
241  * via msg.sender and msg.data, they should not be accessed in such a direct
242  * manner, since when dealing with meta-transactions the account sending and
243  * paying for execution may not be the actual sender (as far as an application
244  * is concerned).
245  *
246  * This contract is only required for intermediate, library-like contracts.
247  */
248 abstract contract Context {
249     function _msgSender() internal view virtual returns (address) {
250         return msg.sender;
251     }
252 
253     function _msgData() internal view virtual returns (bytes calldata) {
254         return msg.data;
255     }
256 }
257 
258 // File: @openzeppelin/contracts/access/Ownable.sol
259 
260 
261 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 
266 /**
267  * @dev Contract module which provides a basic access control mechanism, where
268  * there is an account (an owner) that can be granted exclusive access to
269  * specific functions.
270  *
271  * By default, the owner account will be the one that deploys the contract. This
272  * can later be changed with {transferOwnership}.
273  *
274  * This module is used through inheritance. It will make available the modifier
275  * `onlyOwner`, which can be applied to your functions to restrict their use to
276  * the owner.
277  */
278 abstract contract Ownable is Context {
279     address private _owner;
280 
281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283     /**
284      * @dev Initializes the contract setting the deployer as the initial owner.
285      */
286     constructor() {
287         _transferOwnership(_msgSender());
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         _checkOwner();
295         _;
296     }
297 
298     /**
299      * @dev Returns the address of the current owner.
300      */
301     function owner() public view virtual returns (address) {
302         return _owner;
303     }
304 
305     /**
306      * @dev Throws if the sender is not the owner.
307      */
308     function _checkOwner() internal view virtual {
309         require(owner() == _msgSender(), "Ownable: caller is not the owner");
310     }
311 
312     /**
313      * @dev Leaves the contract without owner. It will not be possible to call
314      * `onlyOwner` functions anymore. Can only be called by the current owner.
315      *
316      * NOTE: Renouncing ownership will leave the contract without an owner,
317      * thereby removing any functionality that is only available to the owner.
318      */
319     function renounceOwnership() public virtual onlyOwner {
320         _transferOwnership(address(0));
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Can only be called by the current owner.
326      */
327     function transferOwnership(address newOwner) public virtual onlyOwner {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         _transferOwnership(newOwner);
330     }
331 
332     /**
333      * @dev Transfers ownership of the contract to a new account (`newOwner`).
334      * Internal function without access restriction.
335      */
336     function _transferOwnership(address newOwner) internal virtual {
337         address oldOwner = _owner;
338         _owner = newOwner;
339         emit OwnershipTransferred(oldOwner, newOwner);
340     }
341 }
342 
343 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
344 
345 
346 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Interface of the ERC20 standard as defined in the EIP.
352  */
353 interface IERC20 {
354     /**
355      * @dev Emitted when `value` tokens are moved from one account (`from`) to
356      * another (`to`).
357      *
358      * Note that `value` may be zero.
359      */
360     event Transfer(address indexed from, address indexed to, uint256 value);
361 
362     /**
363      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
364      * a call to {approve}. `value` is the new allowance.
365      */
366     event Approval(address indexed owner, address indexed spender, uint256 value);
367 
368     /**
369      * @dev Returns the amount of tokens in existence.
370      */
371     function totalSupply() external view returns (uint256);
372 
373     /**
374      * @dev Returns the amount of tokens owned by `account`.
375      */
376     function balanceOf(address account) external view returns (uint256);
377 
378     /**
379      * @dev Moves `amount` tokens from the caller's account to `to`.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transfer(address to, uint256 amount) external returns (bool);
386 
387     /**
388      * @dev Returns the remaining number of tokens that `spender` will be
389      * allowed to spend on behalf of `owner` through {transferFrom}. This is
390      * zero by default.
391      *
392      * This value changes when {approve} or {transferFrom} are called.
393      */
394     function allowance(address owner, address spender) external view returns (uint256);
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * IMPORTANT: Beware that changing an allowance with this method brings the risk
402      * that someone may use both the old and the new allowance by unfortunate
403      * transaction ordering. One possible solution to mitigate this race
404      * condition is to first reduce the spender's allowance to 0 and set the
405      * desired value afterwards:
406      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
407      *
408      * Emits an {Approval} event.
409      */
410     function approve(address spender, uint256 amount) external returns (bool);
411 
412     /**
413      * @dev Moves `amount` tokens from `from` to `to` using the
414      * allowance mechanism. `amount` is then deducted from the caller's
415      * allowance.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(
422         address from,
423         address to,
424         uint256 amount
425     ) external returns (bool);
426 }
427 
428 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 
436 /**
437  * @dev Interface for the optional metadata functions from the ERC20 standard.
438  *
439  * _Available since v4.1._
440  */
441 interface IERC20Metadata is IERC20 {
442     /**
443      * @dev Returns the name of the token.
444      */
445     function name() external view returns (string memory);
446 
447     /**
448      * @dev Returns the symbol of the token.
449      */
450     function symbol() external view returns (string memory);
451 
452     /**
453      * @dev Returns the decimals places of the token.
454      */
455     function decimals() external view returns (uint8);
456 }
457 
458 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
459 
460 
461 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 
466 
467 
468 /**
469  * @dev Implementation of the {IERC20} interface.
470  *
471  * This implementation is agnostic to the way tokens are created. This means
472  * that a supply mechanism has to be added in a derived contract using {_mint}.
473  * For a generic mechanism see {ERC20PresetMinterPauser}.
474  *
475  * TIP: For a detailed writeup see our guide
476  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
477  * to implement supply mechanisms].
478  *
479  * We have followed general OpenZeppelin Contracts guidelines: functions revert
480  * instead returning `false` on failure. This behavior is nonetheless
481  * conventional and does not conflict with the expectations of ERC20
482  * applications.
483  *
484  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
485  * This allows applications to reconstruct the allowance for all accounts just
486  * by listening to said events. Other implementations of the EIP may not emit
487  * these events, as it isn't required by the specification.
488  *
489  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
490  * functions have been added to mitigate the well-known issues around setting
491  * allowances. See {IERC20-approve}.
492  */
493 contract ERC20 is Context, IERC20, IERC20Metadata {
494     mapping(address => uint256) private _balances;
495 
496     mapping(address => mapping(address => uint256)) private _allowances;
497 
498     uint256 private _totalSupply;
499 
500     string private _name;
501     string private _symbol;
502 
503     /**
504      * @dev Sets the values for {name} and {symbol}.
505      *
506      * The default value of {decimals} is 18. To select a different value for
507      * {decimals} you should overload it.
508      *
509      * All two of these values are immutable: they can only be set once during
510      * construction.
511      */
512     constructor(string memory name_, string memory symbol_) {
513         _name = name_;
514         _symbol = symbol_;
515     }
516 
517     /**
518      * @dev Returns the name of the token.
519      */
520     function name() public view virtual override returns (string memory) {
521         return _name;
522     }
523 
524     /**
525      * @dev Returns the symbol of the token, usually a shorter version of the
526      * name.
527      */
528     function symbol() public view virtual override returns (string memory) {
529         return _symbol;
530     }
531 
532     /**
533      * @dev Returns the number of decimals used to get its user representation.
534      * For example, if `decimals` equals `2`, a balance of `505` tokens should
535      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
536      *
537      * Tokens usually opt for a value of 18, imitating the relationship between
538      * Ether and Wei. This is the value {ERC20} uses, unless this function is
539      * overridden;
540      *
541      * NOTE: This information is only used for _display_ purposes: it in
542      * no way affects any of the arithmetic of the contract, including
543      * {IERC20-balanceOf} and {IERC20-transfer}.
544      */
545     function decimals() public view virtual override returns (uint8) {
546         return 18;
547     }
548 
549     /**
550      * @dev See {IERC20-totalSupply}.
551      */
552     function totalSupply() public view virtual override returns (uint256) {
553         return _totalSupply;
554     }
555 
556     /**
557      * @dev See {IERC20-balanceOf}.
558      */
559     function balanceOf(address account) public view virtual override returns (uint256) {
560         return _balances[account];
561     }
562 
563     /**
564      * @dev See {IERC20-transfer}.
565      *
566      * Requirements:
567      *
568      * - `to` cannot be the zero address.
569      * - the caller must have a balance of at least `amount`.
570      */
571     function transfer(address to, uint256 amount) public virtual override returns (bool) {
572         address owner = _msgSender();
573         _transfer(owner, to, amount);
574         return true;
575     }
576 
577     /**
578      * @dev See {IERC20-allowance}.
579      */
580     function allowance(address owner, address spender) public view virtual override returns (uint256) {
581         return _allowances[owner][spender];
582     }
583 
584     /**
585      * @dev See {IERC20-approve}.
586      *
587      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
588      * `transferFrom`. This is semantically equivalent to an infinite approval.
589      *
590      * Requirements:
591      *
592      * - `spender` cannot be the zero address.
593      */
594     function approve(address spender, uint256 amount) public virtual override returns (bool) {
595         address owner = _msgSender();
596         _approve(owner, spender, amount);
597         return true;
598     }
599 
600     /**
601      * @dev See {IERC20-transferFrom}.
602      *
603      * Emits an {Approval} event indicating the updated allowance. This is not
604      * required by the EIP. See the note at the beginning of {ERC20}.
605      *
606      * NOTE: Does not update the allowance if the current allowance
607      * is the maximum `uint256`.
608      *
609      * Requirements:
610      *
611      * - `from` and `to` cannot be the zero address.
612      * - `from` must have a balance of at least `amount`.
613      * - the caller must have allowance for ``from``'s tokens of at least
614      * `amount`.
615      */
616     function transferFrom(
617         address from,
618         address to,
619         uint256 amount
620     ) public virtual override returns (bool) {
621         address spender = _msgSender();
622         _spendAllowance(from, spender, amount);
623         _transfer(from, to, amount);
624         return true;
625     }
626 
627     /**
628      * @dev Atomically increases the allowance granted to `spender` by the caller.
629      *
630      * This is an alternative to {approve} that can be used as a mitigation for
631      * problems described in {IERC20-approve}.
632      *
633      * Emits an {Approval} event indicating the updated allowance.
634      *
635      * Requirements:
636      *
637      * - `spender` cannot be the zero address.
638      */
639     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
640         address owner = _msgSender();
641         _approve(owner, spender, allowance(owner, spender) + addedValue);
642         return true;
643     }
644 
645     /**
646      * @dev Atomically decreases the allowance granted to `spender` by the caller.
647      *
648      * This is an alternative to {approve} that can be used as a mitigation for
649      * problems described in {IERC20-approve}.
650      *
651      * Emits an {Approval} event indicating the updated allowance.
652      *
653      * Requirements:
654      *
655      * - `spender` cannot be the zero address.
656      * - `spender` must have allowance for the caller of at least
657      * `subtractedValue`.
658      */
659     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
660         address owner = _msgSender();
661         uint256 currentAllowance = allowance(owner, spender);
662         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
663         unchecked {
664             _approve(owner, spender, currentAllowance - subtractedValue);
665         }
666 
667         return true;
668     }
669 
670     /**
671      * @dev Moves `amount` of tokens from `from` to `to`.
672      *
673      * This internal function is equivalent to {transfer}, and can be used to
674      * e.g. implement automatic token fees, slashing mechanisms, etc.
675      *
676      * Emits a {Transfer} event.
677      *
678      * Requirements:
679      *
680      * - `from` cannot be the zero address.
681      * - `to` cannot be the zero address.
682      * - `from` must have a balance of at least `amount`.
683      */
684     function _transfer(
685         address from,
686         address to,
687         uint256 amount
688     ) internal virtual {
689         require(from != address(0), "ERC20: transfer from the zero address");
690         require(to != address(0), "ERC20: transfer to the zero address");
691 
692         _beforeTokenTransfer(from, to, amount);
693 
694         uint256 fromBalance = _balances[from];
695         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
696         unchecked {
697             _balances[from] = fromBalance - amount;
698             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
699             // decrementing then incrementing.
700             _balances[to] += amount;
701         }
702 
703         emit Transfer(from, to, amount);
704 
705         _afterTokenTransfer(from, to, amount);
706     }
707 
708     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
709      * the total supply.
710      *
711      * Emits a {Transfer} event with `from` set to the zero address.
712      *
713      * Requirements:
714      *
715      * - `account` cannot be the zero address.
716      */
717     function _mint(address account, uint256 amount) internal virtual {
718         require(account != address(0), "ERC20: mint to the zero address");
719 
720         _beforeTokenTransfer(address(0), account, amount);
721 
722         _totalSupply += amount;
723         unchecked {
724             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
725             _balances[account] += amount;
726         }
727         emit Transfer(address(0), account, amount);
728 
729         _afterTokenTransfer(address(0), account, amount);
730     }
731 
732     /**
733      * @dev Destroys `amount` tokens from `account`, reducing the
734      * total supply.
735      *
736      * Emits a {Transfer} event with `to` set to the zero address.
737      *
738      * Requirements:
739      *
740      * - `account` cannot be the zero address.
741      * - `account` must have at least `amount` tokens.
742      */
743     function _burn(address account, uint256 amount) internal virtual {
744         require(account != address(0), "ERC20: burn from the zero address");
745 
746         _beforeTokenTransfer(account, address(0), amount);
747 
748         uint256 accountBalance = _balances[account];
749         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
750         unchecked {
751             _balances[account] = accountBalance - amount;
752             // Overflow not possible: amount <= accountBalance <= totalSupply.
753             _totalSupply -= amount;
754         }
755 
756         emit Transfer(account, address(0), amount);
757 
758         _afterTokenTransfer(account, address(0), amount);
759     }
760 
761     /**
762      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
763      *
764      * This internal function is equivalent to `approve`, and can be used to
765      * e.g. set automatic allowances for certain subsystems, etc.
766      *
767      * Emits an {Approval} event.
768      *
769      * Requirements:
770      *
771      * - `owner` cannot be the zero address.
772      * - `spender` cannot be the zero address.
773      */
774     function _approve(
775         address owner,
776         address spender,
777         uint256 amount
778     ) internal virtual {
779         require(owner != address(0), "ERC20: approve from the zero address");
780         require(spender != address(0), "ERC20: approve to the zero address");
781 
782         _allowances[owner][spender] = amount;
783         emit Approval(owner, spender, amount);
784     }
785 
786     /**
787      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
788      *
789      * Does not update the allowance amount in case of infinite allowance.
790      * Revert if not enough allowance is available.
791      *
792      * Might emit an {Approval} event.
793      */
794     function _spendAllowance(
795         address owner,
796         address spender,
797         uint256 amount
798     ) internal virtual {
799         uint256 currentAllowance = allowance(owner, spender);
800         if (currentAllowance != type(uint256).max) {
801             require(currentAllowance >= amount, "ERC20: insufficient allowance");
802             unchecked {
803                 _approve(owner, spender, currentAllowance - amount);
804             }
805         }
806     }
807 
808     /**
809      * @dev Hook that is called before any transfer of tokens. This includes
810      * minting and burning.
811      *
812      * Calling conditions:
813      *
814      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
815      * will be transferred to `to`.
816      * - when `from` is zero, `amount` tokens will be minted for `to`.
817      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
818      * - `from` and `to` are never both zero.
819      *
820      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
821      */
822     function _beforeTokenTransfer(
823         address from,
824         address to,
825         uint256 amount
826     ) internal virtual {}
827 
828     /**
829      * @dev Hook that is called after any transfer of tokens. This includes
830      * minting and burning.
831      *
832      * Calling conditions:
833      *
834      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
835      * has been transferred to `to`.
836      * - when `from` is zero, `amount` tokens have been minted for `to`.
837      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
838      * - `from` and `to` are never both zero.
839      *
840      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
841      */
842     function _afterTokenTransfer(
843         address from,
844         address to,
845         uint256 amount
846     ) internal virtual {}
847 }
848 
849 // File: contracts/Nothing.sol
850 
851 
852 pragma solidity 0.8.9;
853 
854 
855 interface IUniswapV2Pair {
856     event Approval(address indexed owner, address indexed spender, uint value);
857     event Transfer(address indexed from, address indexed to, uint value);
858 
859     function name() external pure returns (string memory);
860     function symbol() external pure returns (string memory);
861     function decimals() external pure returns (uint8);
862     function totalSupply() external view returns (uint);
863     function balanceOf(address owner) external view returns (uint);
864     function allowance(address owner, address spender) external view returns (uint);
865 
866     function approve(address spender, uint value) external returns (bool);
867     function transfer(address to, uint value) external returns (bool);
868     function transferFrom(address from, address to, uint value) external returns (bool);
869 
870     function DOMAIN_SEPARATOR() external view returns (bytes32);
871     function PERMIT_TYPEHASH() external pure returns (bytes32);
872     function nonces(address owner) external view returns (uint);
873 
874     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
875 
876     event Mint(address indexed sender, uint amount0, uint amount1);
877     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
878     event Swap(
879         address indexed sender,
880         uint amount0In,
881         uint amount1In,
882         uint amount0Out,
883         uint amount1Out,
884         address indexed to
885     );
886     event Sync(uint112 reserve0, uint112 reserve1);
887 
888     function MINIMUM_LIQUIDITY() external pure returns (uint);
889     function factory() external view returns (address);
890     function token0() external view returns (address);
891     function token1() external view returns (address);
892     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
893     function price0CumulativeLast() external view returns (uint);
894     function price1CumulativeLast() external view returns (uint);
895     function kLast() external view returns (uint);
896 
897     function mint(address to) external returns (uint liquidity);
898     function burn(address to) external returns (uint amount0, uint amount1);
899     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
900     function skim(address to) external;
901     function sync() external;
902 
903     function initialize(address, address) external;
904 }
905 
906 
907 interface IUniswapV2Factory {
908     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
909 
910     function feeTo() external view returns (address);
911     function feeToSetter() external view returns (address);
912 
913     function getPair(address tokenA, address tokenB) external view returns (address pair);
914     function allPairs(uint) external view returns (address pair);
915     function allPairsLength() external view returns (uint);
916 
917     function createPair(address tokenA, address tokenB) external returns (address pair);
918 
919     function setFeeTo(address) external;
920     function setFeeToSetter(address) external;
921 }
922 
923 
924 library SafeMathInt {
925     int256 private constant MIN_INT256 = int256(1) << 255;
926     int256 private constant MAX_INT256 = ~(int256(1) << 255);
927 
928     /**
929      * @dev Multiplies two int256 variables and fails on overflow.
930      */
931     function mul(int256 a, int256 b) internal pure returns (int256) {
932         int256 c = a * b;
933 
934         // Detect overflow when multiplying MIN_INT256 with -1
935         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
936         require((b == 0) || (c / b == a));
937         return c;
938     }
939 
940     /**
941      * @dev Division of two int256 variables and fails on overflow.
942      */
943     function div(int256 a, int256 b) internal pure returns (int256) {
944         // Prevent overflow when dividing MIN_INT256 by -1
945         require(b != -1 || a != MIN_INT256);
946 
947         // Solidity already throws when dividing by 0.
948         return a / b;
949     }
950 
951     /**
952      * @dev Subtracts two int256 variables and fails on overflow.
953      */
954     function sub(int256 a, int256 b) internal pure returns (int256) {
955         int256 c = a - b;
956         require((b >= 0 && c <= a) || (b < 0 && c > a));
957         return c;
958     }
959 
960     /**
961      * @dev Adds two int256 variables and fails on overflow.
962      */
963     function add(int256 a, int256 b) internal pure returns (int256) {
964         int256 c = a + b;
965         require((b >= 0 && c >= a) || (b < 0 && c < a));
966         return c;
967     }
968 
969     /**
970      * @dev Converts to absolute value, and fails on overflow.
971      */
972     function abs(int256 a) internal pure returns (int256) {
973         require(a != MIN_INT256);
974         return a < 0 ? -a : a;
975     }
976 
977 
978     function toUint256Safe(int256 a) internal pure returns (uint256) {
979         require(a >= 0);
980         return uint256(a);
981     }
982 }
983 
984 library SafeMathUint {
985   function toInt256Safe(uint256 a) internal pure returns (int256) {
986     int256 b = int256(a);
987     require(b >= 0);
988     return b;
989   }
990 }
991 
992 
993 interface IUniswapV2Router01 {
994     function factory() external pure returns (address);
995     function WETH() external pure returns (address);
996 
997     function addLiquidity(
998         address tokenA,
999         address tokenB,
1000         uint amountADesired,
1001         uint amountBDesired,
1002         uint amountAMin,
1003         uint amountBMin,
1004         address to,
1005         uint deadline
1006     ) external returns (uint amountA, uint amountB, uint liquidity);
1007     function addLiquidityETH(
1008         address token,
1009         uint amountTokenDesired,
1010         uint amountTokenMin,
1011         uint amountETHMin,
1012         address to,
1013         uint deadline
1014     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1015     function removeLiquidity(
1016         address tokenA,
1017         address tokenB,
1018         uint liquidity,
1019         uint amountAMin,
1020         uint amountBMin,
1021         address to,
1022         uint deadline
1023     ) external returns (uint amountA, uint amountB);
1024     function removeLiquidityETH(
1025         address token,
1026         uint liquidity,
1027         uint amountTokenMin,
1028         uint amountETHMin,
1029         address to,
1030         uint deadline
1031     ) external returns (uint amountToken, uint amountETH);
1032     function removeLiquidityWithPermit(
1033         address tokenA,
1034         address tokenB,
1035         uint liquidity,
1036         uint amountAMin,
1037         uint amountBMin,
1038         address to,
1039         uint deadline,
1040         bool approveMax, uint8 v, bytes32 r, bytes32 s
1041     ) external returns (uint amountA, uint amountB);
1042     function removeLiquidityETHWithPermit(
1043         address token,
1044         uint liquidity,
1045         uint amountTokenMin,
1046         uint amountETHMin,
1047         address to,
1048         uint deadline,
1049         bool approveMax, uint8 v, bytes32 r, bytes32 s
1050     ) external returns (uint amountToken, uint amountETH);
1051     function swapExactTokensForTokens(
1052         uint amountIn,
1053         uint amountOutMin,
1054         address[] calldata path,
1055         address to,
1056         uint deadline
1057     ) external returns (uint[] memory amounts);
1058     function swapTokensForExactTokens(
1059         uint amountOut,
1060         uint amountInMax,
1061         address[] calldata path,
1062         address to,
1063         uint deadline
1064     ) external returns (uint[] memory amounts);
1065     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1066         external
1067         payable
1068         returns (uint[] memory amounts);
1069     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1070         external
1071         returns (uint[] memory amounts);
1072     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1073         external
1074         returns (uint[] memory amounts);
1075     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1076         external
1077         payable
1078         returns (uint[] memory amounts);
1079 
1080     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1081     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1082     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1083     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1084     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1085 }
1086 
1087 interface IUniswapV2Router02 is IUniswapV2Router01 {
1088     function removeLiquidityETHSupportingFeeOnTransferTokens(
1089         address token,
1090         uint liquidity,
1091         uint amountTokenMin,
1092         uint amountETHMin,
1093         address to,
1094         uint deadline
1095     ) external returns (uint amountETH);
1096     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1097         address token,
1098         uint liquidity,
1099         uint amountTokenMin,
1100         uint amountETHMin,
1101         address to,
1102         uint deadline,
1103         bool approveMax, uint8 v, bytes32 r, bytes32 s
1104     ) external returns (uint amountETH);
1105 
1106     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1107         uint amountIn,
1108         uint amountOutMin,
1109         address[] calldata path,
1110         address to,
1111         uint deadline
1112     ) external;
1113     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1114         uint amountOutMin,
1115         address[] calldata path,
1116         address to,
1117         uint deadline
1118     ) external payable;
1119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1120         uint amountIn,
1121         uint amountOutMin,
1122         address[] calldata path,
1123         address to,
1124         uint deadline
1125     ) external;
1126 }
1127 
1128 
1129 /*
1130 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
1131 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
1132 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
1133 ░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
1134 ░░░░░░░▒█▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓███████████▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒░░░░░░░░
1135 ░░░░░░░▒█▒                                            ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██░░░░░░░
1136 ░░░░░░░▒█▒                                                            ▒█▓░░░░░░░
1137 ░░░░░░░▒█▒                                                            ▓█░░░░░░░░
1138 ░░░░░░░▒█▒                                                            ▓█░░░░░░░░
1139 ░░░░░░░▒█▒                                                            ██░░░░░░░░
1140 ░░░░░░░░█▓                                                           ▒█▒░░░░░░░░
1141 ░░░░░░░░██                                                           ▓█░░░░░░░░░
1142 ░░░░░░░░██                                                           ██░░░░░░░░░
1143 ░░░░░░░░▓█                                                           █▓░░░░░░░░░
1144 ░░░░░░░░▒█▒                                                         ▓█▒░░░░░░░░░
1145 ░░░░░░░░▒█▒                                                         ██░░░░░░░░░░
1146 ░░░░░░░░░█▓                                                         █▓░░░░░░░░░░
1147 ░░░░░░░░░█▓                                                        ▒█▒░░░░░░░░░░
1148 ░░░░░░░░░█▓                                                        ▒█▒░░░░░░░░░░
1149 ░░░░░░░░░█▓                                                        ▓█▒░░░░░░░░░░
1150 ░░░░░░░░▒█▒                                                        ▓█░░░░░░░░░░░
1151 ░░░░░░░░▒█▒                                                        ▓█░░░░░░░░░░░
1152 ░░░░░░░░▓█                                                         ▓█░░░░░░░░░░░
1153 ░░░░░░░░▓█                                                         ▓█░░░░░░░░░░░
1154 ░░░░░░░░▓█                                                         ▓█░░░░░░░░░░░
1155 ░░░░░░░░▓█                                                         ▓█░░░░░░░░░░░
1156 ░░░░░░░░▓█                                                         ██░░░░░░░░░░░
1157 ░░░░░░░░▓█                                                         ██░░░░░░░░░░░
1158 ░░░░░░░░▓█                                                         ██░░░░░░░░░░░
1159 ░░░░░░░░██                                                         ▓█░░░░░░░░░░░
1160 ░░░░░░░░██                                                         ▒█▒░░░░░░░░░░
1161 ░░░░░░░░█▓                                                          █▓░░░░░░░░░░
1162 ░░░░░░░░██                                                     ▒▒▒▒▓█▓░░░░░░░░░░
1163 ░░░░░░░░▒▓▓█████▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓████████▓▓▓▓▓▒▒▒░░░░░░░░░░░
1164 ░░░░░░░░░░░░░░░░░▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
1165 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
1166 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ nothing.gg ░░░░░
1167 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
1168 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
1169 */
1170 
1171 contract NOTHING is ERC20, Ownable  {
1172     using SafeMath for uint256;
1173 
1174     IUniswapV2Router02 public immutable uniswapV2Router;
1175     address public immutable uniswapV2Pair;
1176     address public constant deadAddress = address(0xdead);
1177 
1178     bool private swapping;
1179 
1180     address public marketingWallet;
1181     address public devWallet;
1182     
1183     uint256 public maxTransactionAmount;
1184     uint256 public swapTokensAtAmount;
1185     uint256 public maxWallet;
1186     
1187     uint256 public percentForLPBurn = 1; // 25 = .25%
1188     bool public lpBurnEnabled = false;
1189     uint256 public lpBurnFrequency = 1360000000000 seconds;
1190     uint256 public lastLpBurnTime;
1191     
1192     uint256 public manualBurnFrequency = 43210 minutes;
1193     uint256 public lastManualLpBurnTime;
1194 
1195     bool public limitsInEffect = true;
1196     bool public tradingActive = true;
1197     bool public swapEnabled = true;
1198     
1199      // Anti-bot and anti-whale mappings and variables
1200     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1201     bool public transferDelayEnabled = true;
1202 
1203     uint256 public buyTotalFees;
1204     uint256 public buyMarketingFee;
1205     uint256 public buyLiquidityFee;
1206     uint256 public buyDevFee;
1207     
1208     uint256 public sellTotalFees;
1209     uint256 public sellMarketingFee;
1210     uint256 public sellLiquidityFee;
1211     uint256 public sellDevFee;
1212     
1213     uint256 public tokensForMarketing;
1214     uint256 public tokensForLiquidity;
1215     uint256 public tokensForDev;
1216     
1217     /******************/
1218 
1219     // exlcude from fees and max transaction amount
1220     mapping (address => bool) private _isExcludedFromFees;
1221     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1222 
1223     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1224     // could be subject to a maximum transfer amount
1225     mapping (address => bool) public automatedMarketMakerPairs;
1226 
1227     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1228 
1229     event ExcludeFromFees(address indexed account, bool isExcluded);
1230 
1231     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1232 
1233     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
1234     
1235     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
1236 
1237     event SwapAndLiquify(
1238         uint256 tokensSwapped,
1239         uint256 ethReceived,
1240         uint256 tokensIntoLiquidity
1241     );
1242     
1243     event AutoNukeLP();
1244     
1245     event ManualNukeLP();
1246 
1247     constructor() ERC20("nothing", "thing") {
1248         
1249         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1250         
1251         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1252         uniswapV2Router = _uniswapV2Router;
1253         
1254         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1255         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1256         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1257         
1258         uint256 _buyMarketingFee = 0;
1259         uint256 _buyLiquidityFee = 0;
1260         uint256 _buyDevFee = 10;
1261 
1262         uint256 _sellMarketingFee = 0;
1263         uint256 _sellLiquidityFee = 0;
1264         uint256 _sellDevFee = 20;
1265         
1266         //  Supply of 1 Trillion tokens
1267         uint256 totalSupply = 100 * 1e10 * 1e18;
1268         
1269         //  Maximum tx size and wallet size initialized to 1% of supply
1270         maxTransactionAmount = 1 * 1e10 * 1e18; 
1271         maxWallet = 1 * 1e10 * 1e18;
1272 
1273         swapTokensAtAmount = totalSupply * 1 / 10000; 
1274 
1275         buyMarketingFee = _buyMarketingFee;
1276         buyLiquidityFee = _buyLiquidityFee;
1277         buyDevFee = _buyDevFee;
1278         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1279         
1280         sellMarketingFee = _sellMarketingFee;
1281         sellLiquidityFee = _sellLiquidityFee;
1282         sellDevFee = _sellDevFee;
1283         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1284         
1285         marketingWallet = address(owner()); // set as marketing wallet
1286         devWallet = address(owner()); // set as dev wallet
1287 
1288         // exclude from paying fees or having max transaction amount
1289         excludeFromFees(owner(), true);
1290         excludeFromFees(address(this), true);
1291         excludeFromFees(address(0xdead), true);
1292         
1293         excludeFromMaxTransaction(owner(), true);
1294         excludeFromMaxTransaction(address(this), true);
1295         excludeFromMaxTransaction(address(0xdead), true);
1296         
1297         /*
1298             _mint is an internal function in ERC20.sol that is only called here,
1299             and CANNOT be called ever again
1300         */
1301         _mint(msg.sender, totalSupply);
1302     }
1303 
1304     receive() external payable {
1305 
1306     }
1307 
1308     // once enabled, can never be turned off
1309     function enableTrading() external onlyOwner {
1310         tradingActive = true;
1311         swapEnabled = true;
1312         lastLpBurnTime = block.timestamp;
1313     }
1314     
1315     // remove limits after token is stable
1316     function removeLimits() external onlyOwner returns (bool){
1317         limitsInEffect = false;
1318         return true;
1319     }
1320     
1321     // disable Transfer delay - cannot be reenabled
1322     function disableTransferDelay() external onlyOwner returns (bool){
1323         transferDelayEnabled = false;
1324         return true;
1325     }
1326     
1327      // change the minimum amount of tokens to sell from fees
1328     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1329         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1330         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
1331         swapTokensAtAmount = newAmount;
1332         return true;
1333     }
1334     
1335     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1336         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1337         maxTransactionAmount = newNum * (10**18);
1338     }
1339 
1340     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1341         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1342         maxWallet = newNum * (10**18);
1343     }
1344     
1345     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1346         _isExcludedMaxTransactionAmount[updAds] = isEx;
1347     }
1348     
1349     // only use to disable contract sales if absolutely necessary (emergency use only)
1350     function updateSwapEnabled(bool enabled) external onlyOwner(){
1351         swapEnabled = enabled;
1352     }
1353     
1354     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1355         buyMarketingFee = _marketingFee;
1356         buyLiquidityFee = _liquidityFee;
1357         buyDevFee = _devFee;
1358         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1359         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1360     }
1361     
1362     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1363         sellMarketingFee = _marketingFee;
1364         sellLiquidityFee = _liquidityFee;
1365         sellDevFee = _devFee;
1366         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1367         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1368     }
1369 
1370     function excludeFromFees(address account, bool excluded) public onlyOwner {
1371         _isExcludedFromFees[account] = excluded;
1372         emit ExcludeFromFees(account, excluded);
1373     }
1374 
1375     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1376         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1377 
1378         _setAutomatedMarketMakerPair(pair, value);
1379     }
1380 
1381     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1382         automatedMarketMakerPairs[pair] = value;
1383 
1384         emit SetAutomatedMarketMakerPair(pair, value);
1385     }
1386 
1387     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1388         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1389         marketingWallet = newMarketingWallet;
1390     }
1391     
1392     function updateDevWallet(address newWallet) external onlyOwner {
1393         emit devWalletUpdated(newWallet, devWallet);
1394         devWallet = newWallet;
1395     }
1396     
1397 
1398     function isExcludedFromFees(address account) public view returns(bool) {
1399         return _isExcludedFromFees[account];
1400     }
1401     
1402     event BoughtEarly(address indexed sniper);
1403 
1404     function _transfer(
1405         address from,
1406         address to,
1407         uint256 amount
1408     ) internal override {
1409         require(from != address(0), "ERC20: transfer from the zero address");
1410         require(to != address(0), "ERC20: transfer to the zero address");
1411         
1412          if(amount == 0) {
1413             super._transfer(from, to, 0);
1414             return;
1415         }
1416         
1417         if(limitsInEffect){
1418             if (
1419                 from != owner() &&
1420                 to != owner() &&
1421                 to != address(0) &&
1422                 to != address(0xdead) &&
1423                 !swapping
1424             ){
1425                 if(!tradingActive){
1426                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1427                 }
1428 
1429                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1430                 if (transferDelayEnabled){
1431                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1432                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1433                         _holderLastTransferTimestamp[tx.origin] = block.number;
1434                     }
1435                 }
1436                  
1437                 //when buy
1438                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1439                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1440                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1441                 }
1442                 
1443                 //when sell
1444                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1445                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1446                 }
1447                 else if(!_isExcludedMaxTransactionAmount[to]){
1448                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1449                 }
1450             }
1451         }
1452         
1453         
1454         
1455         uint256 contractTokenBalance = balanceOf(address(this));
1456         
1457         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1458 
1459         if( 
1460             canSwap &&
1461             swapEnabled &&
1462             !swapping &&
1463             !automatedMarketMakerPairs[from] &&
1464             !_isExcludedFromFees[from] &&
1465             !_isExcludedFromFees[to]
1466         ) {
1467             swapping = true;
1468             
1469             swapBack();
1470 
1471             swapping = false;
1472         }
1473         
1474         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1475             autoBurnLiquidityPairTokens();
1476         }
1477 
1478         bool takeFee = !swapping;
1479 
1480         // if any account belongs to _isExcludedFromFee account then remove the fee
1481         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1482             takeFee = false;
1483         }
1484         
1485         uint256 fees = 0;
1486         // only take fees on buys/sells, do not take on wallet transfers
1487         if(takeFee){
1488             // on sell
1489             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1490                 fees = amount.mul(sellTotalFees).div(100);
1491                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1492                 tokensForDev += fees * sellDevFee / sellTotalFees;
1493                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1494             }
1495             // on buy
1496             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1497                 fees = amount.mul(buyTotalFees).div(100);
1498                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1499                 tokensForDev += fees * buyDevFee / buyTotalFees;
1500                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1501             }
1502             
1503             if(fees > 0){    
1504                 super._transfer(from, address(this), fees);
1505             }
1506             
1507             amount -= fees;
1508         }
1509 
1510         super._transfer(from, to, amount);
1511     }
1512 
1513     function swapTokensForEth(uint256 tokenAmount) private {
1514 
1515         // generate the uniswap pair path of token -> weth
1516         address[] memory path = new address[](2);
1517         path[0] = address(this);
1518         path[1] = uniswapV2Router.WETH();
1519 
1520         _approve(address(this), address(uniswapV2Router), tokenAmount);
1521 
1522         // make the swap
1523         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1524             tokenAmount,
1525             0, // accept any amount of ETH
1526             path,
1527             address(this),
1528             block.timestamp
1529         );
1530         
1531     }
1532     
1533     
1534     
1535     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1536         // approve token transfer to cover all possible scenarios
1537         _approve(address(this), address(uniswapV2Router), tokenAmount);
1538 
1539         // add the liquidity
1540         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1541             address(this),
1542             tokenAmount,
1543             0, // slippage is unavoidable
1544             0, // slippage is unavoidable
1545             deadAddress,
1546             block.timestamp
1547         );
1548     }
1549 
1550     function swapBack() private {
1551         uint256 contractBalance = balanceOf(address(this));
1552         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1553         bool success;
1554         
1555         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1556 
1557         if(contractBalance > swapTokensAtAmount * 20){
1558           contractBalance = swapTokensAtAmount * 20;
1559         }
1560         
1561         // Halve the amount of liquidity tokens
1562         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1563         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1564         
1565         uint256 initialETHBalance = address(this).balance;
1566 
1567         swapTokensForEth(amountToSwapForETH); 
1568         
1569         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1570         
1571         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1572         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1573         
1574         
1575         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1576         
1577         
1578         tokensForLiquidity = 0;
1579         tokensForMarketing = 0;
1580         tokensForDev = 0;
1581         
1582         (success,) = address(devWallet).call{value: ethForDev}("");
1583         
1584         if(liquidityTokens > 0 && ethForLiquidity > 0){
1585             addLiquidity(liquidityTokens, ethForLiquidity);
1586             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1587         }
1588         
1589         
1590         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1591     }
1592     
1593     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1594         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1595         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1596         lpBurnFrequency = _frequencyInSeconds;
1597         percentForLPBurn = _percent;
1598         lpBurnEnabled = _Enabled;
1599     }
1600     
1601     function autoBurnLiquidityPairTokens() internal returns (bool){
1602         
1603         lastLpBurnTime = block.timestamp;
1604         
1605         // get balance of liquidity pair
1606         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1607         
1608         // calculate amount to burn
1609         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1610         
1611         // pull tokens from pancakePair liquidity and move to dead address permanently
1612         if (amountToBurn > 0){
1613             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1614         }
1615         
1616         //sync price since this is not in a swap transaction!
1617         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1618         pair.sync();
1619         emit AutoNukeLP();
1620         return true;
1621     }
1622 
1623     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1624         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1625         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1626         lastManualLpBurnTime = block.timestamp;
1627         
1628         // get balance of liquidity pair
1629         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1630         
1631         // calculate amount to burn
1632         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1633         
1634         // pull tokens from pancakePair liquidity and move to dead address permanently
1635         if (amountToBurn > 0){
1636             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1637         }
1638         
1639         //sync price since this is not in a swap transaction!
1640         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1641         pair.sync();
1642         emit ManualNukeLP();
1643         return true;
1644     }
1645 }