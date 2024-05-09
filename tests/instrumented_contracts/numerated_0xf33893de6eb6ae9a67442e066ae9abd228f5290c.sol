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
843 // File: Token.sol
844 
845 //SPDX-License-Identifier: MIT
846 pragma solidity >=0.8.0;
847 
848 
849 
850 
851 
852 contract Token is Context, ERC20, Ownable {
853     using SafeMath for uint256;
854 
855     uint8 private _decimals = 8;
856     mapping (address => bool) private _isBlackList;
857 
858 
859     uint256 private _tax = 0;
860     address private _taxAccount;
861 
862     struct Restriction{
863         uint256 delay;
864         uint256 amount;
865     }
866 
867     mapping (address => Restriction) private _Restrictions;
868     mapping (address => uint256) private _UserRestrictions;
869 
870     constructor(string memory name, string memory symbol, uint256 initialSupply, uint8 decimals, address owner)ERC20(name, symbol){
871         _decimals = decimals;
872         transferOwnership(owner);
873         _mint(owner, initialSupply);
874     }
875 
876     function decimals() public view override returns (uint8) {
877         return _decimals;
878     }
879 
880     function transferFrom(
881         address from,
882         address to,
883         uint256 amount
884     ) public override returns (bool) {
885 
886         require(!_isBlackList[from], "Sender in Black List");
887         // require(!_isBlackList[to], "Receiver in Black List");
888 
889         address spender = _msgSender();
890         _spendAllowance(from, spender, amount);
891 
892         require(checkRestriction(from, to, amount), "Restriction (amount/delay) error");
893 
894         uint256 tax = calculateTaxFee(amount);
895         if(tax > 0){
896             amount = amount - tax;
897             _transfer(from, _taxAccount, tax);
898         }
899 
900         _transfer(from, to, amount);
901         return true;
902     }
903 
904 
905     function transfer(address to, uint256 amount) public override returns (bool) {
906         address owner = _msgSender();
907 
908         require(!_isBlackList[owner], "Sender in Black List");
909         // require(!_isBlackList[to], "Receiver in Black List");
910 
911         require(checkRestriction(owner, to, amount), "Restriction (amount/delay) error");
912 
913         uint256 tax = calculateTaxFee(amount);
914         if(tax > 0){
915             amount = amount - tax;
916             _transfer(owner, _taxAccount, tax);
917         }
918 
919         _transfer(owner, to, amount);
920         return true;
921     }
922 
923     function ExcludeFromBlackList(address account) public onlyOwner() {
924         _isBlackList[account] = false;
925     }
926 
927     function IncludeInBlackList(address account) public onlyOwner() {
928         _isBlackList[account] = true;
929     }
930 
931     function getRestriction(address account) public view onlyOwner() returns (Restriction memory) {
932         return _Restrictions[account];
933     }
934 
935     function deleteRestriction(address account) public onlyOwner() {
936         delete _Restrictions[account];
937     }
938 
939     function addRestriction(address account, uint256 delay, uint256 amount) public onlyOwner() {
940         _Restrictions[account].amount = amount;
941         _Restrictions[account].delay = delay;
942     }
943 
944     function checkRestriction(address from, address to, uint256 amount) private returns (bool) {
945 
946         if(!(_Restrictions[to].delay > 0) && !(_Restrictions[to].amount > 0))
947             return true;
948 
949         if(_Restrictions[to].amount > 0 && amount > _Restrictions[to].amount)
950             return false;
951 
952         if(_Restrictions[to].delay > 0 && _UserRestrictions[from] >  block.timestamp - _Restrictions[to].delay)
953             return false;
954 
955         if(_Restrictions[to].delay > 0)
956             _UserRestrictions[from] =  block.timestamp;
957 
958         return true;
959 
960     }
961 
962     function setTax(address account, uint256 tax) public onlyOwner() {
963         _tax = tax;
964         _taxAccount = account;
965     }
966 
967     function getTax() public view onlyOwner() returns (address account, uint256 tax){
968         return (_taxAccount, _tax);
969     }
970 
971     function deleteTax() public onlyOwner() {
972         _tax = 0;
973     }
974 
975     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
976         if(_tax > 0)
977             return _amount.mul(_tax).div(10**2);
978         else
979             return 0;
980     }
981 
982 }