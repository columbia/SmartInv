1 // SPDX-License-Identifier: MIT
2 
3 /*
4 .__                               
5 |  |   _____   ____  ______  _  __
6 |  |  /     \_/ __ \/  _ \ \/ \/ /
7 |  |_|  Y Y  \  ___(  <_> )     / 
8 |____/__|_|  /\___  >____/ \/\_/  
9            \/     \/              
10 
11 
12 website: https://lmeow.netlify.app/
13 telegram: https://t.me/lmeowofficial
14 twitter: https://twitter.com/lmeowofficial
15 
16 */
17 
18 
19 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
20 
21 
22 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 // CAUTION
27 // This version of SafeMath should only be used with Solidity 0.8 or later,
28 // because it relies on the compiler's built in overflow checks.
29 
30 /**
31  * @dev Wrappers over Solidity's arithmetic operations.
32  *
33  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
34  * now has built in overflow checking.
35  */
36 library SafeMath {
37     /**
38      * @dev Returns the addition of two unsigned integers, with an overflow flag.
39      *
40      * _Available since v3.4._
41      */
42     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {
44             uint256 c = a + b;
45             if (c < a) return (false, 0);
46             return (true, c);
47         }
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
52      *
53      * _Available since v3.4._
54      */
55     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
56         unchecked {
57             if (b > a) return (false, 0);
58             return (true, a - b);
59         }
60     }
61 
62     /**
63      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
70             // benefit is lost if 'b' is also tested.
71             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
72             if (a == 0) return (true, 0);
73             uint256 c = a * b;
74             if (c / a != b) return (false, 0);
75             return (true, c);
76         }
77     }
78 
79     /**
80      * @dev Returns the division of two unsigned integers, with a division by zero flag.
81      *
82      * _Available since v3.4._
83      */
84     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
85         unchecked {
86             if (b == 0) return (false, 0);
87             return (true, a / b);
88         }
89     }
90 
91     /**
92      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         unchecked {
98             if (b == 0) return (false, 0);
99             return (true, a % b);
100         }
101     }
102 
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      *
111      * - Addition cannot overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         return a + b;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a - b;
129     }
130 
131     /**
132      * @dev Returns the multiplication of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `*` operator.
136      *
137      * Requirements:
138      *
139      * - Multiplication cannot overflow.
140      */
141     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a * b;
143     }
144 
145     /**
146      * @dev Returns the integer division of two unsigned integers, reverting on
147      * division by zero. The result is rounded towards zero.
148      *
149      * Counterpart to Solidity's `/` operator.
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a / b;
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
161      * reverting when dividing by zero.
162      *
163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
164      * opcode (which leaves remaining gas untouched) while Solidity uses an
165      * invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a % b;
173     }
174 
175     /**
176      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
177      * overflow (when the result is negative).
178      *
179      * CAUTION: This function is deprecated because it requires allocating memory for the error
180      * message unnecessarily. For custom revert reasons use {trySub}.
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      *
186      * - Subtraction cannot overflow.
187      */
188     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         unchecked {
190             require(b <= a, errorMessage);
191             return a - b;
192         }
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         unchecked {
209             require(b > 0, errorMessage);
210             return a / b;
211         }
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * reverting with custom message when dividing by zero.
217      *
218      * CAUTION: This function is deprecated because it requires allocating memory for the error
219      * message unnecessarily. For custom revert reasons use {tryMod}.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         unchecked {
231             require(b > 0, errorMessage);
232             return a % b;
233         }
234     }
235 }
236 
237 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
238 
239 
240 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev Provides information about the current execution context, including the
246  * sender of the transaction and its data. While these are generally available
247  * via msg.sender and msg.data, they should not be accessed in such a direct
248  * manner, since when dealing with meta-transactions the account sending and
249  * paying for execution may not be the actual sender (as far as an application
250  * is concerned).
251  *
252  * This contract is only required for intermediate, library-like contracts.
253  */
254 abstract contract Context {
255     function _msgSender() internal view virtual returns (address) {
256         return msg.sender;
257     }
258 
259     function _msgData() internal view virtual returns (bytes calldata) {
260         return msg.data;
261     }
262 }
263 
264 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
265 
266 
267 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 
272 /**
273  * @dev Contract module which provides a basic access control mechanism, where
274  * there is an account (an owner) that can be granted exclusive access to
275  * specific functions.
276  *
277  * By default, the owner account will be the one that deploys the contract. This
278  * can later be changed with {transferOwnership}.
279  *
280  * This module is used through inheritance. It will make available the modifier
281  * `onlyOwner`, which can be applied to your functions to restrict their use to
282  * the owner.
283  */
284 abstract contract Ownable is Context {
285     address private _owner;
286 
287     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
288 
289     /**
290      * @dev Initializes the contract setting the deployer as the initial owner.
291      */
292     constructor() {
293         _transferOwnership(_msgSender());
294     }
295 
296     /**
297      * @dev Throws if called by any account other than the owner.
298      */
299     modifier onlyOwner() {
300         _checkOwner();
301         _;
302     }
303 
304     /**
305      * @dev Returns the address of the current owner.
306      */
307     function owner() public view virtual returns (address) {
308         return _owner;
309     }
310 
311     /**
312      * @dev Throws if the sender is not the owner.
313      */
314     function _checkOwner() internal view virtual {
315         require(owner() == _msgSender(), "Ownable: caller is not the owner");
316     }
317 
318     /**
319      * @dev Leaves the contract without owner. It will not be possible to call
320      * `onlyOwner` functions. Can only be called by the current owner.
321      *
322      * NOTE: Renouncing ownership will leave the contract without an owner,
323      * thereby disabling any functionality that is only available to the owner.
324      */
325     function renounceOwnership() public virtual onlyOwner {
326         _transferOwnership(address(0));
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public virtual onlyOwner {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         _transferOwnership(newOwner);
336     }
337 
338     /**
339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
340      * Internal function without access restriction.
341      */
342     function _transferOwnership(address newOwner) internal virtual {
343         address oldOwner = _owner;
344         _owner = newOwner;
345         emit OwnershipTransferred(oldOwner, newOwner);
346     }
347 }
348 
349 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Interface of the ERC20 standard as defined in the EIP.
358  */
359 interface IERC20 {
360     /**
361      * @dev Emitted when `value` tokens are moved from one account (`from`) to
362      * another (`to`).
363      *
364      * Note that `value` may be zero.
365      */
366     event Transfer(address indexed from, address indexed to, uint256 value);
367 
368     /**
369      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
370      * a call to {approve}. `value` is the new allowance.
371      */
372     event Approval(address indexed owner, address indexed spender, uint256 value);
373 
374     /**
375      * @dev Returns the amount of tokens in existence.
376      */
377     function totalSupply() external view returns (uint256);
378 
379     /**
380      * @dev Returns the amount of tokens owned by `account`.
381      */
382     function balanceOf(address account) external view returns (uint256);
383 
384     /**
385      * @dev Moves `amount` tokens from the caller's account to `to`.
386      *
387      * Returns a boolean value indicating whether the operation succeeded.
388      *
389      * Emits a {Transfer} event.
390      */
391     function transfer(address to, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Returns the remaining number of tokens that `spender` will be
395      * allowed to spend on behalf of `owner` through {transferFrom}. This is
396      * zero by default.
397      *
398      * This value changes when {approve} or {transferFrom} are called.
399      */
400     function allowance(address owner, address spender) external view returns (uint256);
401 
402     /**
403      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * IMPORTANT: Beware that changing an allowance with this method brings the risk
408      * that someone may use both the old and the new allowance by unfortunate
409      * transaction ordering. One possible solution to mitigate this race
410      * condition is to first reduce the spender's allowance to 0 and set the
411      * desired value afterwards:
412      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
413      *
414      * Emits an {Approval} event.
415      */
416     function approve(address spender, uint256 amount) external returns (bool);
417 
418     /**
419      * @dev Moves `amount` tokens from `from` to `to` using the
420      * allowance mechanism. `amount` is then deducted from the caller's
421      * allowance.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * Emits a {Transfer} event.
426      */
427     function transferFrom(address from, address to, uint256 amount) external returns (bool);
428 }
429 
430 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 
438 /**
439  * @dev Interface for the optional metadata functions from the ERC20 standard.
440  *
441  * _Available since v4.1._
442  */
443 interface IERC20Metadata is IERC20 {
444     /**
445      * @dev Returns the name of the token.
446      */
447     function name() external view returns (string memory);
448 
449     /**
450      * @dev Returns the symbol of the token.
451      */
452     function symbol() external view returns (string memory);
453 
454     /**
455      * @dev Returns the decimals places of the token.
456      */
457     function decimals() external view returns (uint8);
458 }
459 
460 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 
469 
470 /**
471  * @dev Implementation of the {IERC20} interface.
472  *
473  * This implementation is agnostic to the way tokens are created. This means
474  * that a supply mechanism has to be added in a derived contract using {_mint}.
475  * For a generic mechanism see {ERC20PresetMinterPauser}.
476  *
477  * TIP: For a detailed writeup see our guide
478  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
479  * to implement supply mechanisms].
480  *
481  * The default value of {decimals} is 18. To change this, you should override
482  * this function so it returns a different value.
483  *
484  * We have followed general OpenZeppelin Contracts guidelines: functions revert
485  * instead returning `false` on failure. This behavior is nonetheless
486  * conventional and does not conflict with the expectations of ERC20
487  * applications.
488  *
489  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
490  * This allows applications to reconstruct the allowance for all accounts just
491  * by listening to said events. Other implementations of the EIP may not emit
492  * these events, as it isn't required by the specification.
493  *
494  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
495  * functions have been added to mitigate the well-known issues around setting
496  * allowances. See {IERC20-approve}.
497  */
498 contract ERC20 is Context, IERC20, IERC20Metadata {
499     mapping(address => uint256) private _balances;
500 
501     mapping(address => mapping(address => uint256)) private _allowances;
502 
503     uint256 private _totalSupply;
504 
505     string private _name;
506     string private _symbol;
507 
508     /**
509      * @dev Sets the values for {name} and {symbol}.
510      *
511      * All two of these values are immutable: they can only be set once during
512      * construction.
513      */
514     constructor(string memory name_, string memory symbol_) {
515         _name = name_;
516         _symbol = symbol_;
517     }
518 
519     /**
520      * @dev Returns the name of the token.
521      */
522     function name() public view virtual override returns (string memory) {
523         return _name;
524     }
525 
526     /**
527      * @dev Returns the symbol of the token, usually a shorter version of the
528      * name.
529      */
530     function symbol() public view virtual override returns (string memory) {
531         return _symbol;
532     }
533 
534     /**
535      * @dev Returns the number of decimals used to get its user representation.
536      * For example, if `decimals` equals `2`, a balance of `505` tokens should
537      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
538      *
539      * Tokens usually opt for a value of 18, imitating the relationship between
540      * Ether and Wei. This is the default value returned by this function, unless
541      * it's overridden.
542      *
543      * NOTE: This information is only used for _display_ purposes: it in
544      * no way affects any of the arithmetic of the contract, including
545      * {IERC20-balanceOf} and {IERC20-transfer}.
546      */
547     function decimals() public view virtual override returns (uint8) {
548         return 18;
549     }
550 
551     /**
552      * @dev See {IERC20-totalSupply}.
553      */
554     function totalSupply() public view virtual override returns (uint256) {
555         return _totalSupply;
556     }
557 
558     /**
559      * @dev See {IERC20-balanceOf}.
560      */
561     function balanceOf(address account) public view virtual override returns (uint256) {
562         return _balances[account];
563     }
564 
565     /**
566      * @dev See {IERC20-transfer}.
567      *
568      * Requirements:
569      *
570      * - `to` cannot be the zero address.
571      * - the caller must have a balance of at least `amount`.
572      */
573     function transfer(address to, uint256 amount) public virtual override returns (bool) {
574         address owner = _msgSender();
575         _transfer(owner, to, amount);
576         return true;
577     }
578 
579     /**
580      * @dev See {IERC20-allowance}.
581      */
582     function allowance(address owner, address spender) public view virtual override returns (uint256) {
583         return _allowances[owner][spender];
584     }
585 
586     /**
587      * @dev See {IERC20-approve}.
588      *
589      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
590      * `transferFrom`. This is semantically equivalent to an infinite approval.
591      *
592      * Requirements:
593      *
594      * - `spender` cannot be the zero address.
595      */
596     function approve(address spender, uint256 amount) public virtual override returns (bool) {
597         address owner = _msgSender();
598         _approve(owner, spender, amount);
599         return true;
600     }
601 
602     /**
603      * @dev See {IERC20-transferFrom}.
604      *
605      * Emits an {Approval} event indicating the updated allowance. This is not
606      * required by the EIP. See the note at the beginning of {ERC20}.
607      *
608      * NOTE: Does not update the allowance if the current allowance
609      * is the maximum `uint256`.
610      *
611      * Requirements:
612      *
613      * - `from` and `to` cannot be the zero address.
614      * - `from` must have a balance of at least `amount`.
615      * - the caller must have allowance for ``from``'s tokens of at least
616      * `amount`.
617      */
618     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
619         address spender = _msgSender();
620         _spendAllowance(from, spender, amount);
621         _transfer(from, to, amount);
622         return true;
623     }
624 
625     /**
626      * @dev Atomically increases the allowance granted to `spender` by the caller.
627      *
628      * This is an alternative to {approve} that can be used as a mitigation for
629      * problems described in {IERC20-approve}.
630      *
631      * Emits an {Approval} event indicating the updated allowance.
632      *
633      * Requirements:
634      *
635      * - `spender` cannot be the zero address.
636      */
637     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
638         address owner = _msgSender();
639         _approve(owner, spender, allowance(owner, spender) + addedValue);
640         return true;
641     }
642 
643     /**
644      * @dev Atomically decreases the allowance granted to `spender` by the caller.
645      *
646      * This is an alternative to {approve} that can be used as a mitigation for
647      * problems described in {IERC20-approve}.
648      *
649      * Emits an {Approval} event indicating the updated allowance.
650      *
651      * Requirements:
652      *
653      * - `spender` cannot be the zero address.
654      * - `spender` must have allowance for the caller of at least
655      * `subtractedValue`.
656      */
657     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
658         address owner = _msgSender();
659         uint256 currentAllowance = allowance(owner, spender);
660         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
661         unchecked {
662             _approve(owner, spender, currentAllowance - subtractedValue);
663         }
664 
665         return true;
666     }
667 
668     /**
669      * @dev Moves `amount` of tokens from `from` to `to`.
670      *
671      * This internal function is equivalent to {transfer}, and can be used to
672      * e.g. implement automatic token fees, slashing mechanisms, etc.
673      *
674      * Emits a {Transfer} event.
675      *
676      * Requirements:
677      *
678      * - `from` cannot be the zero address.
679      * - `to` cannot be the zero address.
680      * - `from` must have a balance of at least `amount`.
681      */
682     function _transfer(address from, address to, uint256 amount) internal virtual {
683         require(from != address(0), "ERC20: transfer from the zero address");
684         require(to != address(0), "ERC20: transfer to the zero address");
685 
686         _beforeTokenTransfer(from, to, amount);
687 
688         uint256 fromBalance = _balances[from];
689         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
690         unchecked {
691             _balances[from] = fromBalance - amount;
692             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
693             // decrementing then incrementing.
694             _balances[to] += amount;
695         }
696 
697         emit Transfer(from, to, amount);
698 
699         _afterTokenTransfer(from, to, amount);
700     }
701 
702     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
703      * the total supply.
704      *
705      * Emits a {Transfer} event with `from` set to the zero address.
706      *
707      * Requirements:
708      *
709      * - `account` cannot be the zero address.
710      */
711     function _mint(address account, uint256 amount) internal virtual {
712         require(account != address(0), "ERC20: mint to the zero address");
713 
714         _beforeTokenTransfer(address(0), account, amount);
715 
716         _totalSupply += amount;
717         unchecked {
718             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
719             _balances[account] += amount;
720         }
721         emit Transfer(address(0), account, amount);
722 
723         _afterTokenTransfer(address(0), account, amount);
724     }
725 
726     /**
727      * @dev Destroys `amount` tokens from `account`, reducing the
728      * total supply.
729      *
730      * Emits a {Transfer} event with `to` set to the zero address.
731      *
732      * Requirements:
733      *
734      * - `account` cannot be the zero address.
735      * - `account` must have at least `amount` tokens.
736      */
737     function _burn(address account, uint256 amount) internal virtual {
738         require(account != address(0), "ERC20: burn from the zero address");
739 
740         _beforeTokenTransfer(account, address(0), amount);
741 
742         uint256 accountBalance = _balances[account];
743         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
744         unchecked {
745             _balances[account] = accountBalance - amount;
746             // Overflow not possible: amount <= accountBalance <= totalSupply.
747             _totalSupply -= amount;
748         }
749 
750         emit Transfer(account, address(0), amount);
751 
752         _afterTokenTransfer(account, address(0), amount);
753     }
754 
755     /**
756      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
757      *
758      * This internal function is equivalent to `approve`, and can be used to
759      * e.g. set automatic allowances for certain subsystems, etc.
760      *
761      * Emits an {Approval} event.
762      *
763      * Requirements:
764      *
765      * - `owner` cannot be the zero address.
766      * - `spender` cannot be the zero address.
767      */
768     function _approve(address owner, address spender, uint256 amount) internal virtual {
769         require(owner != address(0), "ERC20: approve from the zero address");
770         require(spender != address(0), "ERC20: approve to the zero address");
771 
772         _allowances[owner][spender] = amount;
773         emit Approval(owner, spender, amount);
774     }
775 
776     /**
777      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
778      *
779      * Does not update the allowance amount in case of infinite allowance.
780      * Revert if not enough allowance is available.
781      *
782      * Might emit an {Approval} event.
783      */
784     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
785         uint256 currentAllowance = allowance(owner, spender);
786         if (currentAllowance != type(uint256).max) {
787             require(currentAllowance >= amount, "ERC20: insufficient allowance");
788             unchecked {
789                 _approve(owner, spender, currentAllowance - amount);
790             }
791         }
792     }
793 
794     /**
795      * @dev Hook that is called before any transfer of tokens. This includes
796      * minting and burning.
797      *
798      * Calling conditions:
799      *
800      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
801      * will be transferred to `to`.
802      * - when `from` is zero, `amount` tokens will be minted for `to`.
803      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
804      * - `from` and `to` are never both zero.
805      *
806      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
807      */
808     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
809 
810     /**
811      * @dev Hook that is called after any transfer of tokens. This includes
812      * minting and burning.
813      *
814      * Calling conditions:
815      *
816      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
817      * has been transferred to `to`.
818      * - when `from` is zero, `amount` tokens have been minted for `to`.
819      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
820      * - `from` and `to` are never both zero.
821      *
822      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
823      */
824     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
825 }
826 
827 // File: contracts/LMEOWToken.sol
828 
829 pragma solidity ^0.8.4;
830 
831 contract LMEOW is ERC20, Ownable {
832 
833     mapping(address => bool) public blacklistWallet;
834    
835     constructor() ERC20("LMEOW", "LMEOW") {
836         _mint(msg.sender, 420690000e18);
837     }
838 
839      function blacklist(address _address, bool _isBlacklisted) external onlyOwner {
840         blacklistWallet[_address] = _isBlacklisted;
841     }
842 
843 
844     function _beforeTokenTransfer(
845         address from,
846         address to,
847         uint256 amount
848     ) override internal virtual {
849         require(!blacklistWallet[to] && !blacklistWallet[from], "Blacklisted Wallet");
850     }
851 }