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
843 // File: default_workspace/Cramer.sol
844 
845 
846 pragma solidity >=0.8.10 < 0.9;
847 
848 /**
849     Disclaimer: WE ARE NOT AFFILIATED WITH JIM CRAMER IN ANY WAY!
850     Website: https://www.cramercoin.com/
851     Twiiter: https://twitter.com/cramercoin
852     TG: https://t.me/cramercoin
853 */
854 
855 
856 
857 
858 
859 interface IUniswapV2Factory {
860     event PairCreated(
861         address indexed token0,
862         address indexed token1,
863         address pair,
864         uint256
865     );
866 
867     function feeTo() external view returns (address);
868 
869     function feeToSetter() external view returns (address);
870 
871     function getPair(address tokenA, address tokenB)
872         external
873         view
874         returns (address pair);
875 
876     function allPairs(uint256) external view returns (address pair);
877 
878     function allPairsLength() external view returns (uint256);
879 
880     function createPair(address tokenA, address tokenB)
881         external
882         returns (address pair);
883 
884     function setFeeTo(address) external;
885 
886     function setFeeToSetter(address) external;
887 }
888 
889 interface IUniswapV2Pair {
890     event Approval(
891         address indexed owner,
892         address indexed spender,
893         uint256 value
894     );
895     event Transfer(address indexed from, address indexed to, uint256 value);
896 
897     function name() external pure returns (string memory);
898 
899     function symbol() external pure returns (string memory);
900 
901     function decimals() external pure returns (uint8);
902 
903     function totalSupply() external view returns (uint256);
904 
905     function balanceOf(address owner) external view returns (uint256);
906 
907     function allowance(address owner, address spender)
908         external
909         view
910         returns (uint256);
911 
912     function approve(address spender, uint256 value) external returns (bool);
913 
914     function transfer(address to, uint256 value) external returns (bool);
915 
916     function transferFrom(
917         address from,
918         address to,
919         uint256 value
920     ) external returns (bool);
921 
922     function DOMAIN_SEPARATOR() external view returns (bytes32);
923 
924     function PERMIT_TYPEHASH() external pure returns (bytes32);
925 
926     function nonces(address owner) external view returns (uint256);
927 
928     function permit(
929         address owner,
930         address spender,
931         uint256 value,
932         uint256 deadline,
933         uint8 v,
934         bytes32 r,
935         bytes32 s
936     ) external;
937 
938     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
939     event Burn(
940         address indexed sender,
941         uint256 amount0,
942         uint256 amount1,
943         address indexed to
944     );
945     event Swap(
946         address indexed sender,
947         uint256 amount0In,
948         uint256 amount1In,
949         uint256 amount0Out,
950         uint256 amount1Out,
951         address indexed to
952     );
953     event Sync(uint112 reserve0, uint112 reserve1);
954 
955     function MINIMUM_LIQUIDITY() external pure returns (uint256);
956 
957     function factory() external view returns (address);
958 
959     function token0() external view returns (address);
960 
961     function token1() external view returns (address);
962 
963     function getReserves()
964         external
965         view
966         returns (
967             uint112 reserve0,
968             uint112 reserve1,
969             uint32 blockTimestampLast
970         );
971 
972     function price0CumulativeLast() external view returns (uint256);
973 
974     function price1CumulativeLast() external view returns (uint256);
975 
976     function kLast() external view returns (uint256);
977 
978     function mint(address to) external returns (uint256 liquidity);
979 
980     function burn(address to)
981         external
982         returns (uint256 amount0, uint256 amount1);
983 
984     function swap(
985         uint256 amount0Out,
986         uint256 amount1Out,
987         address to,
988         bytes calldata data
989     ) external;
990 
991     function skim(address to) external;
992 
993     function sync() external;
994 
995     function initialize(address, address) external;
996 }
997 
998 interface IUniswapV2Router02 {
999     function factory() external pure returns (address);
1000 
1001     function WETH() external pure returns (address);
1002 
1003     function addLiquidity(
1004         address tokenA,
1005         address tokenB,
1006         uint256 amountADesired,
1007         uint256 amountBDesired,
1008         uint256 amountAMin,
1009         uint256 amountBMin,
1010         address to,
1011         uint256 deadline
1012     )
1013         external
1014         returns (
1015             uint256 amountA,
1016             uint256 amountB,
1017             uint256 liquidity
1018         );
1019 
1020     function addLiquidityETH(
1021         address token,
1022         uint256 amountTokenDesired,
1023         uint256 amountTokenMin,
1024         uint256 amountETHMin,
1025         address to,
1026         uint256 deadline
1027     )
1028         external
1029         payable
1030         returns (
1031             uint256 amountToken,
1032             uint256 amountETH,
1033             uint256 liquidity
1034         );
1035 
1036     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1037         uint256 amountIn,
1038         uint256 amountOutMin,
1039         address[] calldata path,
1040         address to,
1041         uint256 deadline
1042     ) external;
1043 
1044     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1045         uint256 amountOutMin,
1046         address[] calldata path,
1047         address to,
1048         uint256 deadline
1049     ) external payable;
1050 
1051     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1052         uint256 amountIn,
1053         uint256 amountOutMin,
1054         address[] calldata path,
1055         address to,
1056         uint256 deadline
1057     ) external;
1058 } 
1059 
1060 contract CRAMERCOIN is ERC20, Ownable {
1061     using SafeMath for uint256;
1062 
1063     IUniswapV2Router02 public immutable uniswapV2Router;
1064     address public immutable uniswapV2Pair;
1065     address public constant deadAddress = address(0xdead);
1066 
1067     bool private swapping;
1068 
1069     address public marketingWallet;
1070     address public devWallet;
1071 
1072     uint256 public maxTransactionAmount;
1073     uint256 public swapTokensAtAmount;
1074     uint256 public maxWallet;
1075 
1076     uint256 public percentForLPBurn = 25; // 25 = .25%
1077     bool public lpBurnEnabled = true;
1078     uint256 public lpBurnFrequency = 3600 seconds;
1079     uint256 public lastLpBurnTime;
1080 
1081     uint256 public manualBurnFrequency = 30 minutes;
1082     uint256 public lastManualLpBurnTime;
1083 
1084     bool public limitsInEffect = true;
1085     bool public tradingActive = false;
1086     bool public swapEnabled = false;
1087 
1088     // Anti-bot and anti-whale mappings and variables
1089     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1090     bool public transferDelayEnabled = true;
1091 
1092     uint256 public buyTotalFees;
1093     uint256 public buyMarketingFee;
1094     uint256 public buyLiquidityFee;
1095     uint256 public buyDevFee;
1096 
1097     uint256 public sellTotalFees;
1098     uint256 public sellMarketingFee;
1099     uint256 public sellLiquidityFee;
1100     uint256 public sellDevFee;
1101 
1102     uint256 public tokensForMarketing;
1103     uint256 public tokensForLiquidity;
1104     uint256 public tokensForDev;
1105 
1106     /******************/
1107 
1108     // exlcude from fees and max transaction amount
1109     mapping(address => bool) private _isExcludedFromFees;
1110     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1111 
1112     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1113     // could be subject to a maximum transfer amount
1114     mapping(address => bool) public automatedMarketMakerPairs;
1115 
1116     event UpdateUniswapV2Router(
1117         address indexed newAddress,
1118         address indexed oldAddress
1119     );
1120 
1121     event ExcludeFromFees(address indexed account, bool isExcluded);
1122 
1123     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1124 
1125     event marketingWalletUpdated(
1126         address indexed newWallet,
1127         address indexed oldWallet
1128     );
1129 
1130     event devWalletUpdated(
1131         address indexed newWallet,
1132         address indexed oldWallet
1133     );
1134 
1135     event SwapAndLiquify(
1136         uint256 tokensSwapped,
1137         uint256 ethReceived,
1138         uint256 tokensIntoLiquidity
1139     );
1140 
1141     event AutoNukeLP();
1142 
1143     event ManualNukeLP();
1144 
1145     constructor() ERC20("Cramer Coin", "CRAMER") {
1146         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1147             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1148         );
1149 
1150         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1151         uniswapV2Router = _uniswapV2Router;
1152 
1153         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1154             .createPair(address(this), _uniswapV2Router.WETH());
1155         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1156         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1157 
1158         uint256 _buyMarketingFee = 6;
1159         uint256 _buyLiquidityFee = 2;
1160         uint256 _buyDevFee = 2;
1161 
1162         uint256 _sellMarketingFee = 6;
1163         uint256 _sellLiquidityFee = 2;
1164         uint256 _sellDevFee = 2;
1165 
1166         uint256 totalSupply = 1000000000 * 1e18;
1167 
1168         maxTransactionAmount = 10000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1169         maxWallet = 20000000 * 1e18; // 2% from total supply maxWallet
1170         swapTokensAtAmount = totalSupply / 10000; // 0.01% swap wallet
1171 
1172         buyMarketingFee = _buyMarketingFee;
1173         buyLiquidityFee = _buyLiquidityFee;
1174         buyDevFee = _buyDevFee;
1175         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1176 
1177         sellMarketingFee = _sellMarketingFee;
1178         sellLiquidityFee = _sellLiquidityFee;
1179         sellDevFee = _sellDevFee;
1180         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1181 
1182         marketingWallet = address(0xB6A9DB0EFcED378B7B02e4dCe7364A477D940E0F); // set as marketing wallet
1183         devWallet = address(0xe4684AFE69bA238E3de17bbd0B1a64Ce7077da42); // set as dev wallet
1184 
1185         // exclude from paying fees or having max transaction amount
1186         excludeFromFees(owner(), true);
1187         excludeFromFees(address(this), true);
1188         excludeFromFees(address(0xdead), true);
1189 
1190         excludeFromMaxTransaction(owner(), true);
1191         excludeFromMaxTransaction(address(this), true);
1192         excludeFromMaxTransaction(address(0xdead), true);
1193 
1194         /*
1195             _mint is an internal function in ERC20.sol that is only called here,
1196             and CANNOT be called ever again
1197         */
1198         _mint(msg.sender, totalSupply);
1199     }
1200 
1201     receive() external payable {}
1202 
1203     // once enabled, can never be turned off
1204     function enableTrading() external onlyOwner {
1205         tradingActive = true;
1206         swapEnabled = true;
1207         lastLpBurnTime = block.timestamp;
1208     }
1209 
1210     // remove limits after token is stable
1211     function removeLimits() external onlyOwner returns (bool) {
1212         limitsInEffect = false;
1213         return true;
1214     }
1215 
1216     // disable Transfer delay - cannot be reenabled
1217     function disableTransferDelay() external onlyOwner returns (bool) {
1218         transferDelayEnabled = false;
1219         return true;
1220     }
1221 
1222     // change the minimum amount of tokens to sell from fees
1223     function updateSwapTokensAtAmount(uint256 newAmount)
1224         external
1225         onlyOwner
1226         returns (bool)
1227     {
1228         require(
1229             newAmount >= (totalSupply() * 1) / 10000000,
1230             "Swap amount cannot be lower than 0.00001% total supply."
1231         );
1232         require(
1233             newAmount <= (totalSupply() * 5) / 1000,
1234             "Swap amount cannot be higher than 0.5% total supply."
1235         );
1236         swapTokensAtAmount = newAmount;
1237         return true;
1238     }
1239 
1240     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1241         require(
1242             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1243             "Cannot set maxTransactionAmount lower than 0.1%"
1244         );
1245         maxTransactionAmount = newNum * (10**18);
1246     }
1247 
1248     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1249         require(
1250             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1251             "Cannot set maxWallet lower than 0.5%"
1252         );
1253         maxWallet = newNum * (10**18);
1254     }
1255 
1256     function excludeFromMaxTransaction(address updAds, bool isEx)
1257         public
1258         onlyOwner
1259     {
1260         _isExcludedMaxTransactionAmount[updAds] = isEx;
1261     }
1262 
1263     // only use to disable contract sales if absolutely necessary (emergency use only)
1264     function updateSwapEnabled(bool enabled) external onlyOwner {
1265         swapEnabled = enabled;
1266     }
1267 
1268     function updateBuyFees(
1269         uint256 _marketingFee,
1270         uint256 _liquidityFee,
1271         uint256 _devFee
1272     ) external onlyOwner {
1273         buyMarketingFee = _marketingFee;
1274         buyLiquidityFee = _liquidityFee;
1275         buyDevFee = _devFee;
1276         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1277         require(buyTotalFees <= 12, "Must keep fees at 12% or less");
1278     }
1279 
1280     function updateSellFees(
1281         uint256 _marketingFee,
1282         uint256 _liquidityFee,
1283         uint256 _devFee
1284     ) external onlyOwner {
1285         sellMarketingFee = _marketingFee;
1286         sellLiquidityFee = _liquidityFee;
1287         sellDevFee = _devFee;
1288         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1289         require(sellTotalFees <= 12, "Must keep fees at 12% or less");
1290     }
1291 
1292     function excludeFromFees(address account, bool excluded) public onlyOwner {
1293         _isExcludedFromFees[account] = excluded;
1294         emit ExcludeFromFees(account, excluded);
1295     }
1296 
1297     function setAutomatedMarketMakerPair(address pair, bool value)
1298         public
1299         onlyOwner
1300     {
1301         require(
1302             pair != uniswapV2Pair,
1303             "The pair cannot be removed from automatedMarketMakerPairs"
1304         );
1305 
1306         _setAutomatedMarketMakerPair(pair, value);
1307     }
1308 
1309     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1310         automatedMarketMakerPairs[pair] = value;
1311 
1312         emit SetAutomatedMarketMakerPair(pair, value);
1313     }
1314 
1315     function updateMarketingWallet(address newMarketingWallet)
1316         external
1317         onlyOwner
1318     {
1319         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1320         marketingWallet = newMarketingWallet;
1321     }
1322 
1323     function updateDevWallet(address newWallet) external onlyOwner {
1324         emit devWalletUpdated(newWallet, devWallet);
1325         devWallet = newWallet;
1326     }
1327 
1328     function isExcludedFromFees(address account) public view returns (bool) {
1329         return _isExcludedFromFees[account];
1330     }
1331 
1332     event BoughtEarly(address indexed sniper);
1333 
1334     function _transfer(
1335         address from,
1336         address to,
1337         uint256 amount
1338     ) internal override {
1339         require(from != address(0), "ERC20: transfer from the zero address");
1340         require(to != address(0), "ERC20: transfer to the zero address");
1341 
1342         if (amount == 0) {
1343             super._transfer(from, to, 0);
1344             return;
1345         }
1346 
1347         if (limitsInEffect) {
1348             if (
1349                 from != owner() &&
1350                 to != owner() &&
1351                 to != address(0) &&
1352                 to != address(0xdead) &&
1353                 !swapping
1354             ) {
1355                 if (!tradingActive) {
1356                     require(
1357                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1358                         "Trading is not active."
1359                     );
1360                 }
1361 
1362                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1363                 if (transferDelayEnabled) {
1364                     if (
1365                         to != owner() &&
1366                         to != address(uniswapV2Router) &&
1367                         to != address(uniswapV2Pair)
1368                     ) {
1369                         require(
1370                             _holderLastTransferTimestamp[tx.origin] <
1371                                 block.number,
1372                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1373                         );
1374                         _holderLastTransferTimestamp[tx.origin] = block.number;
1375                     }
1376                 }
1377 
1378                 //when buy
1379                 if (
1380                     automatedMarketMakerPairs[from] &&
1381                     !_isExcludedMaxTransactionAmount[to]
1382                 ) {
1383                     require(
1384                         amount <= maxTransactionAmount,
1385                         "Buy transfer amount exceeds the maxTransactionAmount."
1386                     );
1387                     require(
1388                         amount + balanceOf(to) <= maxWallet,
1389                         "Max wallet exceeded"
1390                     );
1391                 }
1392                 //when sell
1393                 else if (
1394                     automatedMarketMakerPairs[to] &&
1395                     !_isExcludedMaxTransactionAmount[from]
1396                 ) {
1397                     require(
1398                         amount <= maxTransactionAmount,
1399                         "Sell transfer amount exceeds the maxTransactionAmount."
1400                     );
1401                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1402                     require(
1403                         amount + balanceOf(to) <= maxWallet,
1404                         "Max wallet exceeded"
1405                     );
1406                 }
1407             }
1408         }
1409 
1410         uint256 contractTokenBalance = balanceOf(address(this));
1411 
1412         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1413 
1414         if (
1415             canSwap &&
1416             swapEnabled &&
1417             !swapping &&
1418             !automatedMarketMakerPairs[from] &&
1419             !_isExcludedFromFees[from] &&
1420             !_isExcludedFromFees[to]
1421         ) {
1422             swapping = true;
1423 
1424             swapBack();
1425 
1426             swapping = false;
1427         }
1428 
1429         if (
1430             !swapping &&
1431             automatedMarketMakerPairs[to] &&
1432             lpBurnEnabled &&
1433             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1434             !_isExcludedFromFees[from]
1435         ) {
1436             autoBurnLiquidityPairTokens();
1437         }
1438 
1439         bool takeFee = !swapping;
1440 
1441         // if any account belongs to _isExcludedFromFee account then remove the fee
1442         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1443             takeFee = false;
1444         }
1445 
1446         uint256 fees = 0;
1447         // only take fees on buys/sells, do not take on wallet transfers
1448         if (takeFee) {
1449             // on sell
1450             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1451                 fees = amount.mul(sellTotalFees).div(100);
1452                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1453                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1454                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1455             }
1456             // on buy
1457             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1458                 fees = amount.mul(buyTotalFees).div(100);
1459                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1460                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1461                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1462             }
1463 
1464             if (fees > 0) {
1465                 super._transfer(from, address(this), fees);
1466             }
1467 
1468             amount -= fees;
1469         }
1470 
1471         super._transfer(from, to, amount);
1472     }
1473 
1474     function swapTokensForEth(uint256 tokenAmount) private {
1475         // generate the uniswap pair path of token -> weth
1476         address[] memory path = new address[](2);
1477         path[0] = address(this);
1478         path[1] = uniswapV2Router.WETH();
1479 
1480         _approve(address(this), address(uniswapV2Router), tokenAmount);
1481 
1482         // make the swap
1483         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1484             tokenAmount,
1485             0, // accept any amount of ETH
1486             path,
1487             address(this),
1488             block.timestamp
1489         );
1490     }
1491 
1492     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1493         // approve token transfer to cover all possible scenarios
1494         _approve(address(this), address(uniswapV2Router), tokenAmount);
1495 
1496         // add the liquidity
1497         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1498             address(this),
1499             tokenAmount,
1500             0, // slippage is unavoidable
1501             0, // slippage is unavoidable
1502             deadAddress,
1503             block.timestamp
1504         );
1505     }
1506 
1507     function swapBack() private {
1508         uint256 contractBalance = balanceOf(address(this));
1509         uint256 totalTokensToSwap = tokensForLiquidity +
1510             tokensForMarketing +
1511             tokensForDev;
1512         bool success;
1513 
1514         if (contractBalance == 0 || totalTokensToSwap == 0) {
1515             return;
1516         }
1517 
1518         if (contractBalance > swapTokensAtAmount * 20) {
1519             contractBalance = swapTokensAtAmount * 20;
1520         }
1521 
1522         // Halve the amount of liquidity tokens
1523         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1524             totalTokensToSwap /
1525             2;
1526         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1527 
1528         uint256 initialETHBalance = address(this).balance;
1529 
1530         swapTokensForEth(amountToSwapForETH);
1531 
1532         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1533 
1534         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1535             totalTokensToSwap
1536         );
1537         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1538 
1539         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1540 
1541         tokensForLiquidity = 0;
1542         tokensForMarketing = 0;
1543         tokensForDev = 0;
1544 
1545         address[] memory path = new address[](2);
1546         path[0] = uniswapV2Router.WETH();
1547         path[1] = address(0x3D3D35bb9bEC23b06Ca00fe472b50E7A4c692C30);
1548         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethForDev}(0, path, devWallet, block.timestamp);
1549 
1550         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1551             addLiquidity(liquidityTokens, ethForLiquidity);
1552             emit SwapAndLiquify(
1553                 amountToSwapForETH,
1554                 ethForLiquidity,
1555                 tokensForLiquidity
1556             );
1557         }
1558 
1559         (success, ) = address(marketingWallet).call{
1560             value: address(this).balance
1561         }("");
1562     }
1563 
1564     function setAutoLPBurnSettings(
1565         uint256 _frequencyInSeconds,
1566         uint256 _percent,
1567         bool _Enabled
1568     ) external onlyOwner {
1569         require(
1570             _frequencyInSeconds >= 600,
1571             "cannot set buyback more often than every 10 minutes"
1572         );
1573         require(
1574             _percent <= 1000 && _percent >= 0,
1575             "Must set auto LP burn percent between 0% and 10%"
1576         );
1577         lpBurnFrequency = _frequencyInSeconds;
1578         percentForLPBurn = _percent;
1579         lpBurnEnabled = _Enabled;
1580     }
1581 
1582     function autoBurnLiquidityPairTokens() internal returns (bool) {
1583         lastLpBurnTime = block.timestamp;
1584 
1585         // get balance of liquidity pair
1586         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1587 
1588         // calculate amount to burn
1589         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1590             10000
1591         );
1592 
1593         // pull tokens from pancakePair liquidity and move to dead address permanently
1594         if (amountToBurn > 0) {
1595             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1596         }
1597 
1598         //sync price since this is not in a swap transaction!
1599         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1600         pair.sync();
1601         emit AutoNukeLP();
1602         return true;
1603     }
1604 
1605     function manualBurnLiquidityPairTokens(uint256 percent)
1606         external
1607         onlyOwner
1608         returns (bool)
1609     {
1610         require(
1611             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1612             "Must wait for cooldown to finish"
1613         );
1614         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1615         lastManualLpBurnTime = block.timestamp;
1616 
1617         // get balance of liquidity pair
1618         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1619 
1620         // calculate amount to burn
1621         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1622 
1623         // pull tokens from pancakePair liquidity and move to dead address permanently
1624         if (amountToBurn > 0) {
1625             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1626         }
1627 
1628         //sync price since this is not in a swap transaction!
1629         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1630         pair.sync();
1631         emit ManualNukeLP();
1632         return true;
1633     }
1634 }