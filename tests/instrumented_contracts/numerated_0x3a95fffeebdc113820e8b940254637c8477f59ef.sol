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
461 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
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
476  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
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
698         }
699         _balances[to] += amount;
700 
701         emit Transfer(from, to, amount);
702 
703         _afterTokenTransfer(from, to, amount);
704     }
705 
706     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
707      * the total supply.
708      *
709      * Emits a {Transfer} event with `from` set to the zero address.
710      *
711      * Requirements:
712      *
713      * - `account` cannot be the zero address.
714      */
715     function _mint(address account, uint256 amount) internal virtual {
716         require(account != address(0), "ERC20: mint to the zero address");
717 
718         _beforeTokenTransfer(address(0), account, amount);
719 
720         _totalSupply += amount;
721         _balances[account] += amount;
722         emit Transfer(address(0), account, amount);
723 
724         _afterTokenTransfer(address(0), account, amount);
725     }
726 
727     /**
728      * @dev Destroys `amount` tokens from `account`, reducing the
729      * total supply.
730      *
731      * Emits a {Transfer} event with `to` set to the zero address.
732      *
733      * Requirements:
734      *
735      * - `account` cannot be the zero address.
736      * - `account` must have at least `amount` tokens.
737      */
738     function _burn(address account, uint256 amount) internal virtual {
739         require(account != address(0), "ERC20: burn from the zero address");
740 
741         _beforeTokenTransfer(account, address(0), amount);
742 
743         uint256 accountBalance = _balances[account];
744         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
745         unchecked {
746             _balances[account] = accountBalance - amount;
747         }
748         _totalSupply -= amount;
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
768     function _approve(
769         address owner,
770         address spender,
771         uint256 amount
772     ) internal virtual {
773         require(owner != address(0), "ERC20: approve from the zero address");
774         require(spender != address(0), "ERC20: approve to the zero address");
775 
776         _allowances[owner][spender] = amount;
777         emit Approval(owner, spender, amount);
778     }
779 
780     /**
781      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
782      *
783      * Does not update the allowance amount in case of infinite allowance.
784      * Revert if not enough allowance is available.
785      *
786      * Might emit an {Approval} event.
787      */
788     function _spendAllowance(
789         address owner,
790         address spender,
791         uint256 amount
792     ) internal virtual {
793         uint256 currentAllowance = allowance(owner, spender);
794         if (currentAllowance != type(uint256).max) {
795             require(currentAllowance >= amount, "ERC20: insufficient allowance");
796             unchecked {
797                 _approve(owner, spender, currentAllowance - amount);
798             }
799         }
800     }
801 
802     /**
803      * @dev Hook that is called before any transfer of tokens. This includes
804      * minting and burning.
805      *
806      * Calling conditions:
807      *
808      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
809      * will be transferred to `to`.
810      * - when `from` is zero, `amount` tokens will be minted for `to`.
811      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
812      * - `from` and `to` are never both zero.
813      *
814      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
815      */
816     function _beforeTokenTransfer(
817         address from,
818         address to,
819         uint256 amount
820     ) internal virtual {}
821 
822     /**
823      * @dev Hook that is called after any transfer of tokens. This includes
824      * minting and burning.
825      *
826      * Calling conditions:
827      *
828      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
829      * has been transferred to `to`.
830      * - when `from` is zero, `amount` tokens have been minted for `to`.
831      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
832      * - `from` and `to` are never both zero.
833      *
834      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
835      */
836     function _afterTokenTransfer(
837         address from,
838         address to,
839         uint256 amount
840     ) internal virtual {}
841 }
842 
843 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
844 
845 pragma solidity >=0.5.0;
846 
847 interface IUniswapV2Pair {
848     event Approval(address indexed owner, address indexed spender, uint value);
849     event Transfer(address indexed from, address indexed to, uint value);
850 
851     function name() external pure returns (string memory);
852     function symbol() external pure returns (string memory);
853     function decimals() external pure returns (uint8);
854     function totalSupply() external view returns (uint);
855     function balanceOf(address owner) external view returns (uint);
856     function allowance(address owner, address spender) external view returns (uint);
857 
858     function approve(address spender, uint value) external returns (bool);
859     function transfer(address to, uint value) external returns (bool);
860     function transferFrom(address from, address to, uint value) external returns (bool);
861 
862     function DOMAIN_SEPARATOR() external view returns (bytes32);
863     function PERMIT_TYPEHASH() external pure returns (bytes32);
864     function nonces(address owner) external view returns (uint);
865 
866     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
867 
868     event Mint(address indexed sender, uint amount0, uint amount1);
869     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
870     event Swap(
871         address indexed sender,
872         uint amount0In,
873         uint amount1In,
874         uint amount0Out,
875         uint amount1Out,
876         address indexed to
877     );
878     event Sync(uint112 reserve0, uint112 reserve1);
879 
880     function MINIMUM_LIQUIDITY() external pure returns (uint);
881     function factory() external view returns (address);
882     function token0() external view returns (address);
883     function token1() external view returns (address);
884     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
885     function price0CumulativeLast() external view returns (uint);
886     function price1CumulativeLast() external view returns (uint);
887     function kLast() external view returns (uint);
888 
889     function mint(address to) external returns (uint liquidity);
890     function burn(address to) external returns (uint amount0, uint amount1);
891     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
892     function skim(address to) external;
893     function sync() external;
894 
895     function initialize(address, address) external;
896 }
897 
898 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
899 
900 pragma solidity >=0.5.0;
901 
902 interface IUniswapV2Factory {
903     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
904 
905     function feeTo() external view returns (address);
906     function feeToSetter() external view returns (address);
907 
908     function getPair(address tokenA, address tokenB) external view returns (address pair);
909     function allPairs(uint) external view returns (address pair);
910     function allPairsLength() external view returns (uint);
911 
912     function createPair(address tokenA, address tokenB) external returns (address pair);
913 
914     function setFeeTo(address) external;
915     function setFeeToSetter(address) external;
916 }
917 
918 // File: https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router01.sol
919 
920 pragma solidity >=0.6.2;
921 
922 interface IUniswapV2Router01 {
923     function factory() external pure returns (address);
924     function WETH() external pure returns (address);
925 
926     function addLiquidity(
927         address tokenA,
928         address tokenB,
929         uint amountADesired,
930         uint amountBDesired,
931         uint amountAMin,
932         uint amountBMin,
933         address to,
934         uint deadline
935     ) external returns (uint amountA, uint amountB, uint liquidity);
936     function addLiquidityETH(
937         address token,
938         uint amountTokenDesired,
939         uint amountTokenMin,
940         uint amountETHMin,
941         address to,
942         uint deadline
943     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
944     function removeLiquidity(
945         address tokenA,
946         address tokenB,
947         uint liquidity,
948         uint amountAMin,
949         uint amountBMin,
950         address to,
951         uint deadline
952     ) external returns (uint amountA, uint amountB);
953     function removeLiquidityETH(
954         address token,
955         uint liquidity,
956         uint amountTokenMin,
957         uint amountETHMin,
958         address to,
959         uint deadline
960     ) external returns (uint amountToken, uint amountETH);
961     function removeLiquidityWithPermit(
962         address tokenA,
963         address tokenB,
964         uint liquidity,
965         uint amountAMin,
966         uint amountBMin,
967         address to,
968         uint deadline,
969         bool approveMax, uint8 v, bytes32 r, bytes32 s
970     ) external returns (uint amountA, uint amountB);
971     function removeLiquidityETHWithPermit(
972         address token,
973         uint liquidity,
974         uint amountTokenMin,
975         uint amountETHMin,
976         address to,
977         uint deadline,
978         bool approveMax, uint8 v, bytes32 r, bytes32 s
979     ) external returns (uint amountToken, uint amountETH);
980     function swapExactTokensForTokens(
981         uint amountIn,
982         uint amountOutMin,
983         address[] calldata path,
984         address to,
985         uint deadline
986     ) external returns (uint[] memory amounts);
987     function swapTokensForExactTokens(
988         uint amountOut,
989         uint amountInMax,
990         address[] calldata path,
991         address to,
992         uint deadline
993     ) external returns (uint[] memory amounts);
994     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
995         external
996         payable
997         returns (uint[] memory amounts);
998     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
999         external
1000         returns (uint[] memory amounts);
1001     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1002         external
1003         returns (uint[] memory amounts);
1004     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1005         external
1006         payable
1007         returns (uint[] memory amounts);
1008 
1009     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1010     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1011     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1012     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1013     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1014 }
1015 
1016 // File: https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol
1017 
1018 pragma solidity >=0.6.2;
1019 
1020 
1021 interface IUniswapV2Router02 is IUniswapV2Router01 {
1022     function removeLiquidityETHSupportingFeeOnTransferTokens(
1023         address token,
1024         uint liquidity,
1025         uint amountTokenMin,
1026         uint amountETHMin,
1027         address to,
1028         uint deadline
1029     ) external returns (uint amountETH);
1030     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1031         address token,
1032         uint liquidity,
1033         uint amountTokenMin,
1034         uint amountETHMin,
1035         address to,
1036         uint deadline,
1037         bool approveMax, uint8 v, bytes32 r, bytes32 s
1038     ) external returns (uint amountETH);
1039 
1040     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1041         uint amountIn,
1042         uint amountOutMin,
1043         address[] calldata path,
1044         address to,
1045         uint deadline
1046     ) external;
1047     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1048         uint amountOutMin,
1049         address[] calldata path,
1050         address to,
1051         uint deadline
1052     ) external payable;
1053     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1054         uint amountIn,
1055         uint amountOutMin,
1056         address[] calldata path,
1057         address to,
1058         uint deadline
1059     ) external;
1060 }
1061 
1062 // File: FuckSBF.sol
1063 
1064 
1065  
1066 pragma solidity >=0.8.10; 
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 
1075 contract  FuckSBF is ERC20, Ownable {
1076     using SafeMath for uint256;
1077 
1078     IUniswapV2Router02 public immutable uniswapV2Router;
1079     address public immutable uniswapV2Pair;
1080     address public constant deadAddress = address(0xdead);
1081 
1082     bool private swapping;
1083 
1084     address public marketingWallet;
1085     address public devWallet;
1086 
1087     uint256 public maxTransactionAmount;
1088     uint256 public swapTokensAtAmount;
1089     uint256 public maxWallet;
1090 
1091     uint256 public percentForLPBurn = 25; // 25 = .25%
1092     bool public lpBurnEnabled = true;
1093     uint256 public lpBurnFrequency = 3600 seconds;
1094     uint256 public lastLpBurnTime;
1095 
1096     uint256 public manualBurnFrequency = 30 minutes;
1097     uint256 public lastManualLpBurnTime;
1098 
1099     bool public limitsInEffect = true;
1100     bool public tradingActive = false;
1101     bool public swapEnabled = false;
1102 
1103     // Anti-bot and anti-whale mappings and variables
1104     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1105     bool public transferDelayEnabled = true;
1106 
1107     uint256 public buyTotalFees;
1108     uint256 public buyMarketingFee;
1109     uint256 public buyLiquidityFee;
1110     uint256 public buyDevFee;
1111 
1112     uint256 public sellTotalFees;
1113     uint256 public sellMarketingFee;
1114     uint256 public sellLiquidityFee;
1115     uint256 public sellDevFee;
1116 
1117     uint256 public tokensForMarketing;
1118     uint256 public tokensForLiquidity;
1119     uint256 public tokensForDev;
1120 
1121     /******************/
1122 
1123     // exlcude from fees and max transaction amount
1124     mapping(address => bool) private _isExcludedFromFees;
1125     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1126 
1127     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1128     // could be subject to a maximum transfer amount
1129     mapping(address => bool) public automatedMarketMakerPairs;
1130 
1131     event UpdateUniswapV2Router(
1132         address indexed newAddress,
1133         address indexed oldAddress
1134     );
1135 
1136     event ExcludeFromFees(address indexed account, bool isExcluded);
1137 
1138     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1139 
1140     event marketingWalletUpdated(
1141         address indexed newWallet,
1142         address indexed oldWallet
1143     );
1144 
1145     event devWalletUpdated(
1146         address indexed newWallet,
1147         address indexed oldWallet
1148     );
1149 
1150     event SwapAndLiquify(
1151         uint256 tokensSwapped,
1152         uint256 ethReceived,
1153         uint256 tokensIntoLiquidity
1154     );
1155 
1156     event AutoNukeLP();
1157 
1158     event ManualNukeLP();
1159 
1160     constructor() ERC20("Fuck SBF", "FSBF") {
1161         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1162             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1163         );
1164 
1165         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1166         uniswapV2Router = _uniswapV2Router;
1167 
1168         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1169             .createPair(address(this), _uniswapV2Router.WETH());
1170         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1171         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1172 
1173         uint256 _buyMarketingFee = 0;
1174         uint256 _buyLiquidityFee = 0;
1175         uint256 _buyDevFee = 0;
1176 
1177         uint256 _sellMarketingFee = 0;
1178         uint256 _sellLiquidityFee = 0;
1179         uint256 _sellDevFee = 0;
1180 
1181         uint256 totalSupply = 1_000_000_000 * 1e18;
1182 
1183         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1184         maxWallet = 20_000_000 * 1e18; // 3% from total supply maxWallet
1185         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1186 
1187         buyMarketingFee = _buyMarketingFee;
1188         buyLiquidityFee = _buyLiquidityFee;
1189         buyDevFee = _buyDevFee;
1190         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1191 
1192         sellMarketingFee = _sellMarketingFee;
1193         sellLiquidityFee = _sellLiquidityFee;
1194         sellDevFee = _sellDevFee;
1195         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1196 
1197         marketingWallet = address(0x6B39Bf4cdce67464251559B9a5C4Edb20c63087e); // set as marketing wallet
1198         devWallet = address(0x6B39Bf4cdce67464251559B9a5C4Edb20c63087e); // set as dev wallet
1199 
1200         // exclude from paying fees or having max transaction amount
1201         excludeFromFees(owner(), true);
1202         excludeFromFees(address(this), true);
1203         excludeFromFees(address(0xdead), true);
1204 
1205         excludeFromMaxTransaction(owner(), true);
1206         excludeFromMaxTransaction(address(this), true);
1207         excludeFromMaxTransaction(address(0xdead), true);
1208 
1209         /*
1210             _mint is an internal function in ERC20.sol that is only called here,
1211             and CANNOT be called ever again
1212         */
1213         _mint(msg.sender, totalSupply);
1214     }
1215 
1216     receive() external payable {}
1217 
1218     // once enabled, can never be turned off
1219     function enableTrading() external onlyOwner {
1220         tradingActive = true;
1221         swapEnabled = true;
1222         lastLpBurnTime = block.timestamp;
1223     }
1224 
1225     // remove limits after token is stable
1226     function removeLimits() external onlyOwner returns (bool) {
1227         limitsInEffect = false;
1228         return true;
1229     }
1230 
1231     // disable Transfer delay - cannot be reenabled
1232     function disableTransferDelay() external onlyOwner returns (bool) {
1233         transferDelayEnabled = false;
1234         return true;
1235     }
1236 
1237     // change the minimum amount of tokens to sell from fees
1238     function updateSwapTokensAtAmount(uint256 newAmount)
1239         external
1240         onlyOwner
1241         returns (bool)
1242     {
1243         require(
1244             newAmount >= (totalSupply() * 1) / 100000,
1245             "Swap amount cannot be lower than 0.001% total supply."
1246         );
1247         require(
1248             newAmount <= (totalSupply() * 5) / 1000,
1249             "Swap amount cannot be higher than 0.5% total supply."
1250         );
1251         swapTokensAtAmount = newAmount;
1252         return true;
1253     }
1254 
1255     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1256         require(
1257             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1258             "Cannot set maxTransactionAmount lower than 0.1%"
1259         );
1260         maxTransactionAmount = newNum * (10**18);
1261     }
1262 
1263     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1264         require(
1265             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1266             "Cannot set maxWallet lower than 0.5%"
1267         );
1268         maxWallet = newNum * (10**18);
1269     }
1270 
1271     function excludeFromMaxTransaction(address updAds, bool isEx)
1272         public
1273         onlyOwner
1274     {
1275         _isExcludedMaxTransactionAmount[updAds] = isEx;
1276     }
1277 
1278     // only use to disable contract sales if absolutely necessary (emergency use only)
1279     function updateSwapEnabled(bool enabled) external onlyOwner {
1280         swapEnabled = enabled;
1281     }
1282 
1283     function updateBuyFees(
1284         uint256 _marketingFee,
1285         uint256 _liquidityFee,
1286         uint256 _devFee
1287     ) external onlyOwner {
1288         buyMarketingFee = _marketingFee;
1289         buyLiquidityFee = _liquidityFee;
1290         buyDevFee = _devFee;
1291         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1292         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1293     }
1294 
1295     function updateSellFees(
1296         uint256 _marketingFee,
1297         uint256 _liquidityFee,
1298         uint256 _devFee
1299     ) external onlyOwner {
1300         sellMarketingFee = _marketingFee;
1301         sellLiquidityFee = _liquidityFee;
1302         sellDevFee = _devFee;
1303         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1304         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1305     }
1306 
1307     function excludeFromFees(address account, bool excluded) public onlyOwner {
1308         _isExcludedFromFees[account] = excluded;
1309         emit ExcludeFromFees(account, excluded);
1310     }
1311 
1312     function setAutomatedMarketMakerPair(address pair, bool value)
1313         public
1314         onlyOwner
1315     {
1316         require(
1317             pair != uniswapV2Pair,
1318             "The pair cannot be removed from automatedMarketMakerPairs"
1319         );
1320 
1321         _setAutomatedMarketMakerPair(pair, value);
1322     }
1323 
1324     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1325         automatedMarketMakerPairs[pair] = value;
1326 
1327         emit SetAutomatedMarketMakerPair(pair, value);
1328     }
1329 
1330     function updateMarketingWallet(address newMarketingWallet)
1331         external
1332         onlyOwner
1333     {
1334         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1335         marketingWallet = newMarketingWallet;
1336     }
1337 
1338     function updateDevWallet(address newWallet) external onlyOwner {
1339         emit devWalletUpdated(newWallet, devWallet);
1340         devWallet = newWallet;
1341     }
1342 
1343     function isExcludedFromFees(address account) public view returns (bool) {
1344         return _isExcludedFromFees[account];
1345     }
1346 
1347     event BoughtEarly(address indexed sniper);
1348 
1349     function _transfer(
1350         address from,
1351         address to,
1352         uint256 amount
1353     ) internal override {
1354         require(from != address(0), "ERC20: transfer from the zero address");
1355         require(to != address(0), "ERC20: transfer to the zero address");
1356 
1357         if (amount == 0) {
1358             super._transfer(from, to, 0);
1359             return;
1360         }
1361 
1362         if (limitsInEffect) {
1363             if (
1364                 from != owner() &&
1365                 to != owner() &&
1366                 to != address(0) &&
1367                 to != address(0xdead) &&
1368                 !swapping
1369             ) {
1370                 if (!tradingActive) {
1371                     require(
1372                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1373                         "Trading is not active."
1374                     );
1375                 }
1376 
1377                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1378                 if (transferDelayEnabled) {
1379                     if (
1380                         to != owner() &&
1381                         to != address(uniswapV2Router) &&
1382                         to != address(uniswapV2Pair)
1383                     ) {
1384                         require(
1385                             _holderLastTransferTimestamp[tx.origin] <
1386                                 block.number,
1387                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1388                         );
1389                         _holderLastTransferTimestamp[tx.origin] = block.number;
1390                     }
1391                 }
1392 
1393                 //when buy
1394                 if (
1395                     automatedMarketMakerPairs[from] &&
1396                     !_isExcludedMaxTransactionAmount[to]
1397                 ) {
1398                     require(
1399                         amount <= maxTransactionAmount,
1400                         "Buy transfer amount exceeds the maxTransactionAmount."
1401                     );
1402                     require(
1403                         amount + balanceOf(to) <= maxWallet,
1404                         "Max wallet exceeded"
1405                     );
1406                 }
1407                 //when sell
1408                 else if (
1409                     automatedMarketMakerPairs[to] &&
1410                     !_isExcludedMaxTransactionAmount[from]
1411                 ) {
1412                     require(
1413                         amount <= maxTransactionAmount,
1414                         "Sell transfer amount exceeds the maxTransactionAmount."
1415                     );
1416                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1417                     require(
1418                         amount + balanceOf(to) <= maxWallet,
1419                         "Max wallet exceeded"
1420                     );
1421                 }
1422             }
1423         }
1424 
1425         uint256 contractTokenBalance = balanceOf(address(this));
1426 
1427         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1428 
1429         if (
1430             canSwap &&
1431             swapEnabled &&
1432             !swapping &&
1433             !automatedMarketMakerPairs[from] &&
1434             !_isExcludedFromFees[from] &&
1435             !_isExcludedFromFees[to]
1436         ) {
1437             swapping = true;
1438 
1439             swapBack();
1440 
1441             swapping = false;
1442         }
1443 
1444         if (
1445             !swapping &&
1446             automatedMarketMakerPairs[to] &&
1447             lpBurnEnabled &&
1448             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1449             !_isExcludedFromFees[from]
1450         ) {
1451             autoBurnLiquidityPairTokens();
1452         }
1453 
1454         bool takeFee = !swapping;
1455 
1456         // if any account belongs to _isExcludedFromFee account then remove the fee
1457         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1458             takeFee = false;
1459         }
1460 
1461         uint256 fees = 0;
1462         // only take fees on buys/sells, do not take on wallet transfers
1463         if (takeFee) {
1464             // on sell
1465             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1466                 fees = amount.mul(sellTotalFees).div(100);
1467                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1468                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1469                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1470             }
1471             // on buy
1472             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1473                 fees = amount.mul(buyTotalFees).div(100);
1474                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1475                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1476                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1477             }
1478 
1479             if (fees > 0) {
1480                 super._transfer(from, address(this), fees);
1481             }
1482 
1483             amount -= fees;
1484         }
1485 
1486         super._transfer(from, to, amount);
1487     }
1488 
1489     function swapTokensForEth(uint256 tokenAmount) private {
1490         // generate the uniswap pair path of token -> weth
1491         address[] memory path = new address[](2);
1492         path[0] = address(this);
1493         path[1] = uniswapV2Router.WETH();
1494 
1495         _approve(address(this), address(uniswapV2Router), tokenAmount);
1496 
1497         // make the swap
1498         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1499             tokenAmount,
1500             0, // accept any amount of ETH
1501             path,
1502             address(this),
1503             block.timestamp
1504         );
1505     }
1506 
1507     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1508         // approve token transfer to cover all possible scenarios
1509         _approve(address(this), address(uniswapV2Router), tokenAmount);
1510 
1511         // add the liquidity
1512         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1513             address(this),
1514             tokenAmount,
1515             0, // slippage is unavoidable
1516             0, // slippage is unavoidable
1517             deadAddress,
1518             block.timestamp
1519         );
1520     }
1521 
1522     function swapBack() private {
1523         uint256 contractBalance = balanceOf(address(this));
1524         uint256 totalTokensToSwap = tokensForLiquidity +
1525             tokensForMarketing +
1526             tokensForDev;
1527         bool success;
1528 
1529         if (contractBalance == 0 || totalTokensToSwap == 0) {
1530             return;
1531         }
1532 
1533         if (contractBalance > swapTokensAtAmount * 20) {
1534             contractBalance = swapTokensAtAmount * 20;
1535         }
1536 
1537         // Halve the amount of liquidity tokens
1538         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1539             totalTokensToSwap /
1540             2;
1541         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1542 
1543         uint256 initialETHBalance = address(this).balance;
1544 
1545         swapTokensForEth(amountToSwapForETH);
1546 
1547         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1548 
1549         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1550             totalTokensToSwap
1551         );
1552         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1553 
1554         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1555 
1556         tokensForLiquidity = 0;
1557         tokensForMarketing = 0;
1558         tokensForDev = 0;
1559 
1560         (success, ) = address(devWallet).call{value: ethForDev}("");
1561 
1562         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1563             addLiquidity(liquidityTokens, ethForLiquidity);
1564             emit SwapAndLiquify(
1565                 amountToSwapForETH,
1566                 ethForLiquidity,
1567                 tokensForLiquidity
1568             );
1569         }
1570 
1571         (success, ) = address(marketingWallet).call{
1572             value: address(this).balance
1573         }("");
1574     }
1575 
1576     function setAutoLPBurnSettings(
1577         uint256 _frequencyInSeconds,
1578         uint256 _percent,
1579         bool _Enabled
1580     ) external onlyOwner {
1581         require(
1582             _frequencyInSeconds >= 600,
1583             "cannot set buyback more often than every 10 minutes"
1584         );
1585         require(
1586             _percent <= 1000 && _percent >= 0,
1587             "Must set auto LP burn percent between 0% and 10%"
1588         );
1589         lpBurnFrequency = _frequencyInSeconds;
1590         percentForLPBurn = _percent;
1591         lpBurnEnabled = _Enabled;
1592     }
1593 
1594     function autoBurnLiquidityPairTokens() internal returns (bool) {
1595         lastLpBurnTime = block.timestamp;
1596 
1597         // get balance of liquidity pair
1598         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1599 
1600         // calculate amount to burn
1601         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1602             10000
1603         );
1604 
1605         // pull tokens from pancakePair liquidity and move to dead address permanently
1606         if (amountToBurn > 0) {
1607             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1608         }
1609 
1610         //sync price since this is not in a swap transaction!
1611         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1612         pair.sync();
1613         emit AutoNukeLP();
1614         return true;
1615     }
1616 
1617     function manualBurnLiquidityPairTokens(uint256 percent)
1618         external
1619         onlyOwner
1620         returns (bool)
1621     {
1622         require(
1623             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1624             "Must wait for cooldown to finish"
1625         );
1626         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1627         lastManualLpBurnTime = block.timestamp;
1628 
1629         // get balance of liquidity pair
1630         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1631 
1632         // calculate amount to burn
1633         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1634 
1635         // pull tokens from pancakePair liquidity and move to dead address permanently
1636         if (amountToBurn > 0) {
1637             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1638         }
1639 
1640         //sync price since this is not in a swap transaction!
1641         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1642         pair.sync();
1643         emit ManualNukeLP();
1644         return true;
1645     }
1646 }