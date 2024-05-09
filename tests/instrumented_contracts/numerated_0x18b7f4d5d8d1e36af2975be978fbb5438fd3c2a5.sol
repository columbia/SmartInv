1 /*
2      _______     
3     /O     /\   
4    /   O  /O \
5 ((/_____O/    \
6   \O    O\    / 
7    \O    O\ O/   
8     \O____O\/ )) 
9  
10 [Website]  http://betrock.io/
11 [Telegram] https://t.me/BetrockPortal
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.8.0;
17 
18 // CAUTION
19 // This version of SafeMath should only be used with Solidity 0.8 or later,
20 // because it relies on the compiler's built in overflow checks.
21 
22 /**
23  * @dev Wrappers over Solidity's arithmetic operations.
24  *
25  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
26  * now has built in overflow checking.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             uint256 c = a + b;
37             if (c < a) return (false, 0);
38             return (true, c);
39         }
40     }
41 
42     /**
43      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             if (b > a) return (false, 0);
50             return (true, a - b);
51         }
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         unchecked {
61             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62             // benefit is lost if 'b' is also tested.
63             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64             if (a == 0) return (true, 0);
65             uint256 c = a * b;
66             if (c / a != b) return (false, 0);
67             return (true, c);
68         }
69     }
70 
71     /**
72      * @dev Returns the division of two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a / b);
80         }
81     }
82 
83     /**
84      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             if (b == 0) return (false, 0);
91             return (true, a % b);
92         }
93     }
94 
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a + b;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a - b;
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `*` operator.
128      *
129      * Requirements:
130      *
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a * b;
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers, reverting on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator.
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a / b;
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * reverting when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         return a % b;
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * CAUTION: This function is deprecated because it requires allocating memory for the error
172      * message unnecessarily. For custom revert reasons use {trySub}.
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         unchecked {
186             require(b <= a, errorMessage);
187             return a - b;
188         }
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(
204         uint256 a,
205         uint256 b,
206         string memory errorMessage
207     ) internal pure returns (uint256) {
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
229     function mod(
230         uint256 a,
231         uint256 b,
232         string memory errorMessage
233     ) internal pure returns (uint256) {
234         unchecked {
235             require(b > 0, errorMessage);
236             return a % b;
237         }
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Context.sol
242 
243 
244 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev Provides information about the current execution context, including the
250  * sender of the transaction and its data. While these are generally available
251  * via msg.sender and msg.data, they should not be accessed in such a direct
252  * manner, since when dealing with meta-transactions the account sending and
253  * paying for execution may not be the actual sender (as far as an application
254  * is concerned).
255  *
256  * This contract is only required for intermediate, library-like contracts.
257  */
258 abstract contract Context {
259     function _msgSender() internal view virtual returns (address) {
260         return msg.sender;
261     }
262 
263     function _msgData() internal view virtual returns (bytes calldata) {
264         return msg.data;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/access/Ownable.sol
269 
270 
271 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 
276 /**
277  * @dev Contract module which provides a basic access control mechanism, where
278  * there is an account (an owner) that can be granted exclusive access to
279  * specific functions.
280  *
281  * By default, the owner account will be the one that deploys the contract. This
282  * can later be changed with {transferOwnership}.
283  *
284  * This module is used through inheritance. It will make available the modifier
285  * `onlyOwner`, which can be applied to your functions to restrict their use to
286  * the owner.
287  */
288 abstract contract Ownable is Context {
289     address private _owner;
290 
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293     /**
294      * @dev Initializes the contract setting the deployer as the initial owner.
295      */
296     constructor() {
297         _transferOwnership(_msgSender());
298     }
299 
300     /**
301      * @dev Throws if called by any account other than the owner.
302      */
303     modifier onlyOwner() {
304         _checkOwner();
305         _;
306     }
307 
308     /**
309      * @dev Returns the address of the current owner.
310      */
311     function owner() public view virtual returns (address) {
312         return _owner;
313     }
314 
315     /**
316      * @dev Throws if the sender is not the owner.
317      */
318     function _checkOwner() internal view virtual {
319         require(owner() == _msgSender(), "Ownable: caller is not the owner");
320     }
321 
322     /**
323      * @dev Leaves the contract without owner. It will not be possible to call
324      * `onlyOwner` functions anymore. Can only be called by the current owner.
325      *
326      * NOTE: Renouncing ownership will leave the contract without an owner,
327      * thereby removing any functionality that is only available to the owner.
328      */
329     function renounceOwnership() public virtual onlyOwner {
330         _transferOwnership(address(0));
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      * Can only be called by the current owner.
336      */
337     function transferOwnership(address newOwner) public virtual onlyOwner {
338         require(newOwner != address(0), "Ownable: new owner is the zero address");
339         _transferOwnership(newOwner);
340     }
341 
342     /**
343      * @dev Transfers ownership of the contract to a new account (`newOwner`).
344      * Internal function without access restriction.
345      */
346     function _transferOwnership(address newOwner) internal virtual {
347         address oldOwner = _owner;
348         _owner = newOwner;
349         emit OwnershipTransferred(oldOwner, newOwner);
350     }
351 }
352 
353 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
354 
355 
356 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Interface of the ERC20 standard as defined in the EIP.
362  */
363 interface IERC20 {
364     /**
365      * @dev Emitted when `value` tokens are moved from one account (`from`) to
366      * another (`to`).
367      *
368      * Note that `value` may be zero.
369      */
370     event Transfer(address indexed from, address indexed to, uint256 value);
371 
372     /**
373      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
374      * a call to {approve}. `value` is the new allowance.
375      */
376     event Approval(address indexed owner, address indexed spender, uint256 value);
377 
378     /**
379      * @dev Returns the amount of tokens in existence.
380      */
381     function totalSupply() external view returns (uint256);
382 
383     /**
384      * @dev Returns the amount of tokens owned by `account`.
385      */
386     function balanceOf(address account) external view returns (uint256);
387 
388     /**
389      * @dev Moves `amount` tokens from the caller's account to `to`.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transfer(address to, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Returns the remaining number of tokens that `spender` will be
399      * allowed to spend on behalf of `owner` through {transferFrom}. This is
400      * zero by default.
401      *
402      * This value changes when {approve} or {transferFrom} are called.
403      */
404     function allowance(address owner, address spender) external view returns (uint256);
405 
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * IMPORTANT: Beware that changing an allowance with this method brings the risk
412      * that someone may use both the old and the new allowance by unfortunate
413      * transaction ordering. One possible solution to mitigate this race
414      * condition is to first reduce the spender's allowance to 0 and set the
415      * desired value afterwards:
416      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
417      *
418      * Emits an {Approval} event.
419      */
420     function approve(address spender, uint256 amount) external returns (bool);
421 
422     /**
423      * @dev Moves `amount` tokens from `from` to `to` using the
424      * allowance mechanism. `amount` is then deducted from the caller's
425      * allowance.
426      *
427      * Returns a boolean value indicating whether the operation succeeded.
428      *
429      * Emits a {Transfer} event.
430      */
431     function transferFrom(
432         address from,
433         address to,
434         uint256 amount
435     ) external returns (bool);
436 }
437 
438 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 
446 /**
447  * @dev Interface for the optional metadata functions from the ERC20 standard.
448  *
449  * _Available since v4.1._
450  */
451 interface IERC20Metadata is IERC20 {
452     /**
453      * @dev Returns the name of the token.
454      */
455     function name() external view returns (string memory);
456 
457     /**
458      * @dev Returns the symbol of the token.
459      */
460     function symbol() external view returns (string memory);
461 
462     /**
463      * @dev Returns the decimals places of the token.
464      */
465     function decimals() external view returns (uint8);
466 }
467 
468 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
469 
470 
471 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 
476 
477 
478 /**
479  * @dev Implementation of the {IERC20} interface.
480  *
481  * This implementation is agnostic to the way tokens are created. This means
482  * that a supply mechanism has to be added in a derived contract using {_mint}.
483  * For a generic mechanism see {ERC20PresetMinterPauser}.
484  *
485  * TIP: For a detailed writeup see our guide
486  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
487  * to implement supply mechanisms].
488  *
489  * We have followed general OpenZeppelin Contracts guidelines: functions revert
490  * instead returning `false` on failure. This behavior is nonetheless
491  * conventional and does not conflict with the expectations of ERC20
492  * applications.
493  *
494  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
495  * This allows applications to reconstruct the allowance for all accounts just
496  * by listening to said events. Other implementations of the EIP may not emit
497  * these events, as it isn't required by the specification.
498  *
499  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
500  * functions have been added to mitigate the well-known issues around setting
501  * allowances. See {IERC20-approve}.
502  */
503 contract ERC20 is Context, IERC20, IERC20Metadata {
504     mapping(address => uint256) private _balances;
505 
506     mapping(address => mapping(address => uint256)) private _allowances;
507 
508     uint256 private _totalSupply;
509 
510     string private _name;
511     string private _symbol;
512 
513     /**
514      * @dev Sets the values for {name} and {symbol}.
515      *
516      * The default value of {decimals} is 18. To select a different value for
517      * {decimals} you should overload it.
518      *
519      * All two of these values are immutable: they can only be set once during
520      * construction.
521      */
522     constructor(string memory name_, string memory symbol_) {
523         _name = name_;
524         _symbol = symbol_;
525     }
526 
527     /**
528      * @dev Returns the name of the token.
529      */
530     function name() public view virtual override returns (string memory) {
531         return _name;
532     }
533 
534     /**
535      * @dev Returns the symbol of the token, usually a shorter version of the
536      * name.
537      */
538     function symbol() public view virtual override returns (string memory) {
539         return _symbol;
540     }
541 
542     /**
543      * @dev Returns the number of decimals used to get its user representation.
544      * For example, if `decimals` equals `2`, a balance of `505` tokens should
545      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
546      *
547      * Tokens usually opt for a value of 18, imitating the relationship between
548      * Ether and Wei. This is the value {ERC20} uses, unless this function is
549      * overridden;
550      *
551      * NOTE: This information is only used for _display_ purposes: it in
552      * no way affects any of the arithmetic of the contract, including
553      * {IERC20-balanceOf} and {IERC20-transfer}.
554      */
555     function decimals() public view virtual override returns (uint8) {
556         return 18;
557     }
558 
559     /**
560      * @dev See {IERC20-totalSupply}.
561      */
562     function totalSupply() public view virtual override returns (uint256) {
563         return _totalSupply;
564     }
565 
566     /**
567      * @dev See {IERC20-balanceOf}.
568      */
569     function balanceOf(address account) public view virtual override returns (uint256) {
570         return _balances[account];
571     }
572 
573     /**
574      * @dev See {IERC20-transfer}.
575      *
576      * Requirements:
577      *
578      * - `to` cannot be the zero address.
579      * - the caller must have a balance of at least `amount`.
580      */
581     function transfer(address to, uint256 amount) public virtual override returns (bool) {
582         address owner = _msgSender();
583         _transfer(owner, to, amount);
584         return true;
585     }
586 
587     /**
588      * @dev See {IERC20-allowance}.
589      */
590     function allowance(address owner, address spender) public view virtual override returns (uint256) {
591         return _allowances[owner][spender];
592     }
593 
594     /**
595      * @dev See {IERC20-approve}.
596      *
597      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
598      * `transferFrom`. This is semantically equivalent to an infinite approval.
599      *
600      * Requirements:
601      *
602      * - `spender` cannot be the zero address.
603      */
604     function approve(address spender, uint256 amount) public virtual override returns (bool) {
605         address owner = _msgSender();
606         _approve(owner, spender, amount);
607         return true;
608     }
609 
610     /**
611      * @dev See {IERC20-transferFrom}.
612      *
613      * Emits an {Approval} event indicating the updated allowance. This is not
614      * required by the EIP. See the note at the beginning of {ERC20}.
615      *
616      * NOTE: Does not update the allowance if the current allowance
617      * is the maximum `uint256`.
618      *
619      * Requirements:
620      *
621      * - `from` and `to` cannot be the zero address.
622      * - `from` must have a balance of at least `amount`.
623      * - the caller must have allowance for ``from``'s tokens of at least
624      * `amount`.
625      */
626     function transferFrom(
627         address from,
628         address to,
629         uint256 amount
630     ) public virtual override returns (bool) {
631         address spender = _msgSender();
632         _spendAllowance(from, spender, amount);
633         _transfer(from, to, amount);
634         return true;
635     }
636 
637     /**
638      * @dev Atomically increases the allowance granted to `spender` by the caller.
639      *
640      * This is an alternative to {approve} that can be used as a mitigation for
641      * problems described in {IERC20-approve}.
642      *
643      * Emits an {Approval} event indicating the updated allowance.
644      *
645      * Requirements:
646      *
647      * - `spender` cannot be the zero address.
648      */
649     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
650         address owner = _msgSender();
651         _approve(owner, spender, allowance(owner, spender) + addedValue);
652         return true;
653     }
654 
655     /**
656      * @dev Atomically decreases the allowance granted to `spender` by the caller.
657      *
658      * This is an alternative to {approve} that can be used as a mitigation for
659      * problems described in {IERC20-approve}.
660      *
661      * Emits an {Approval} event indicating the updated allowance.
662      *
663      * Requirements:
664      *
665      * - `spender` cannot be the zero address.
666      * - `spender` must have allowance for the caller of at least
667      * `subtractedValue`.
668      */
669     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
670         address owner = _msgSender();
671         uint256 currentAllowance = allowance(owner, spender);
672         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
673         unchecked {
674             _approve(owner, spender, currentAllowance - subtractedValue);
675         }
676 
677         return true;
678     }
679 
680     /**
681      * @dev Moves `amount` of tokens from `from` to `to`.
682      *
683      * This internal function is equivalent to {transfer}, and can be used to
684      * e.g. implement automatic token fees, slashing mechanisms, etc.
685      *
686      * Emits a {Transfer} event.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `from` must have a balance of at least `amount`.
693      */
694     function _transfer(
695         address from,
696         address to,
697         uint256 amount
698     ) internal virtual {
699         require(from != address(0), "ERC20: transfer from the zero address");
700         require(to != address(0), "ERC20: transfer to the zero address");
701 
702         _beforeTokenTransfer(from, to, amount);
703 
704         uint256 fromBalance = _balances[from];
705         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
706         unchecked {
707             _balances[from] = fromBalance - amount;
708             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
709             // decrementing then incrementing.
710             _balances[to] += amount;
711         }
712 
713         emit Transfer(from, to, amount);
714 
715         _afterTokenTransfer(from, to, amount);
716     }
717 
718     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
719      * the total supply.
720      *
721      * Emits a {Transfer} event with `from` set to the zero address.
722      *
723      * Requirements:
724      *
725      * - `account` cannot be the zero address.
726      */
727     function _mint(address account, uint256 amount) internal virtual {
728         require(account != address(0), "ERC20: mint to the zero address");
729 
730         _beforeTokenTransfer(address(0), account, amount);
731 
732         _totalSupply += amount;
733         unchecked {
734             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
735             _balances[account] += amount;
736         }
737         emit Transfer(address(0), account, amount);
738 
739         _afterTokenTransfer(address(0), account, amount);
740     }
741 
742     /**
743      * @dev Destroys `amount` tokens from `account`, reducing the
744      * total supply.
745      *
746      * Emits a {Transfer} event with `to` set to the zero address.
747      *
748      * Requirements:
749      *
750      * - `account` cannot be the zero address.
751      * - `account` must have at least `amount` tokens.
752      */
753     function _burn(address account, uint256 amount) internal virtual {
754         require(account != address(0), "ERC20: burn from the zero address");
755 
756         _beforeTokenTransfer(account, address(0), amount);
757 
758         uint256 accountBalance = _balances[account];
759         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
760         unchecked {
761             _balances[account] = accountBalance - amount;
762             // Overflow not possible: amount <= accountBalance <= totalSupply.
763             _totalSupply -= amount;
764         }
765 
766         emit Transfer(account, address(0), amount);
767 
768         _afterTokenTransfer(account, address(0), amount);
769     }
770 
771     /**
772      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
773      *
774      * This internal function is equivalent to `approve`, and can be used to
775      * e.g. set automatic allowances for certain subsystems, etc.
776      *
777      * Emits an {Approval} event.
778      *
779      * Requirements:
780      *
781      * - `owner` cannot be the zero address.
782      * - `spender` cannot be the zero address.
783      */
784     function _approve(
785         address owner,
786         address spender,
787         uint256 amount
788     ) internal virtual {
789         require(owner != address(0), "ERC20: approve from the zero address");
790         require(spender != address(0), "ERC20: approve to the zero address");
791 
792         _allowances[owner][spender] = amount;
793         emit Approval(owner, spender, amount);
794     }
795 
796     /**
797      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
798      *
799      * Does not update the allowance amount in case of infinite allowance.
800      * Revert if not enough allowance is available.
801      *
802      * Might emit an {Approval} event.
803      */
804     function _spendAllowance(
805         address owner,
806         address spender,
807         uint256 amount
808     ) internal virtual {
809         uint256 currentAllowance = allowance(owner, spender);
810         if (currentAllowance != type(uint256).max) {
811             require(currentAllowance >= amount, "ERC20: insufficient allowance");
812             unchecked {
813                 _approve(owner, spender, currentAllowance - amount);
814             }
815         }
816     }
817 
818     /**
819      * @dev Hook that is called before any transfer of tokens. This includes
820      * minting and burning.
821      *
822      * Calling conditions:
823      *
824      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
825      * will be transferred to `to`.
826      * - when `from` is zero, `amount` tokens will be minted for `to`.
827      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
828      * - `from` and `to` are never both zero.
829      *
830      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
831      */
832     function _beforeTokenTransfer(
833         address from,
834         address to,
835         uint256 amount
836     ) internal virtual {}
837 
838     /**
839      * @dev Hook that is called after any transfer of tokens. This includes
840      * minting and burning.
841      *
842      * Calling conditions:
843      *
844      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
845      * has been transferred to `to`.
846      * - when `from` is zero, `amount` tokens have been minted for `to`.
847      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
848      * - `from` and `to` are never both zero.
849      *
850      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
851      */
852     function _afterTokenTransfer(
853         address from,
854         address to,
855         uint256 amount
856     ) internal virtual {}
857 }
858 
859 pragma solidity 0.8.9;
860 
861 
862 interface IUniswapV2Pair {
863     event Approval(address indexed owner, address indexed spender, uint value);
864     event Transfer(address indexed from, address indexed to, uint value);
865 
866     function name() external pure returns (string memory);
867     function symbol() external pure returns (string memory);
868     function decimals() external pure returns (uint8);
869     function totalSupply() external view returns (uint);
870     function balanceOf(address owner) external view returns (uint);
871     function allowance(address owner, address spender) external view returns (uint);
872 
873     function approve(address spender, uint value) external returns (bool);
874     function transfer(address to, uint value) external returns (bool);
875     function transferFrom(address from, address to, uint value) external returns (bool);
876 
877     function DOMAIN_SEPARATOR() external view returns (bytes32);
878     function PERMIT_TYPEHASH() external pure returns (bytes32);
879     function nonces(address owner) external view returns (uint);
880 
881     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
882 
883     event Mint(address indexed sender, uint amount0, uint amount1);
884     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
885     event Swap(
886         address indexed sender,
887         uint amount0In,
888         uint amount1In,
889         uint amount0Out,
890         uint amount1Out,
891         address indexed to
892     );
893     event Sync(uint112 reserve0, uint112 reserve1);
894 
895     function MINIMUM_LIQUIDITY() external pure returns (uint);
896     function factory() external view returns (address);
897     function token0() external view returns (address);
898     function token1() external view returns (address);
899     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
900     function price0CumulativeLast() external view returns (uint);
901     function price1CumulativeLast() external view returns (uint);
902     function kLast() external view returns (uint);
903 
904     function mint(address to) external returns (uint liquidity);
905     function burn(address to) external returns (uint amount0, uint amount1);
906     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
907     function skim(address to) external;
908     function sync() external;
909 
910     function initialize(address, address) external;
911 }
912 
913 
914 interface IUniswapV2Factory {
915     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
916 
917     function feeTo() external view returns (address);
918     function feeToSetter() external view returns (address);
919 
920     function getPair(address tokenA, address tokenB) external view returns (address pair);
921     function allPairs(uint) external view returns (address pair);
922     function allPairsLength() external view returns (uint);
923 
924     function createPair(address tokenA, address tokenB) external returns (address pair);
925 
926     function setFeeTo(address) external;
927     function setFeeToSetter(address) external;
928 }
929 
930 
931 library SafeMathInt {
932     int256 private constant MIN_INT256 = int256(1) << 255;
933     int256 private constant MAX_INT256 = ~(int256(1) << 255);
934 
935     /**
936      * @dev Multiplies two int256 variables and fails on overflow.
937      */
938     function mul(int256 a, int256 b) internal pure returns (int256) {
939         int256 c = a * b;
940 
941         // Detect overflow when multiplying MIN_INT256 with -1
942         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
943         require((b == 0) || (c / b == a));
944         return c;
945     }
946 
947     /**
948      * @dev Division of two int256 variables and fails on overflow.
949      */
950     function div(int256 a, int256 b) internal pure returns (int256) {
951         // Prevent overflow when dividing MIN_INT256 by -1
952         require(b != -1 || a != MIN_INT256);
953 
954         // Solidity already throws when dividing by 0.
955         return a / b;
956     }
957 
958     /**
959      * @dev Subtracts two int256 variables and fails on overflow.
960      */
961     function sub(int256 a, int256 b) internal pure returns (int256) {
962         int256 c = a - b;
963         require((b >= 0 && c <= a) || (b < 0 && c > a));
964         return c;
965     }
966 
967     /**
968      * @dev Adds two int256 variables and fails on overflow.
969      */
970     function add(int256 a, int256 b) internal pure returns (int256) {
971         int256 c = a + b;
972         require((b >= 0 && c >= a) || (b < 0 && c < a));
973         return c;
974     }
975 
976     /**
977      * @dev Converts to absolute value, and fails on overflow.
978      */
979     function abs(int256 a) internal pure returns (int256) {
980         require(a != MIN_INT256);
981         return a < 0 ? -a : a;
982     }
983 
984 
985     function toUint256Safe(int256 a) internal pure returns (uint256) {
986         require(a >= 0);
987         return uint256(a);
988     }
989 }
990 
991 library SafeMathUint {
992   function toInt256Safe(uint256 a) internal pure returns (int256) {
993     int256 b = int256(a);
994     require(b >= 0);
995     return b;
996   }
997 }
998 
999 
1000 interface IUniswapV2Router01 {
1001     function factory() external pure returns (address);
1002     function WETH() external pure returns (address);
1003 
1004     function addLiquidity(
1005         address tokenA,
1006         address tokenB,
1007         uint amountADesired,
1008         uint amountBDesired,
1009         uint amountAMin,
1010         uint amountBMin,
1011         address to,
1012         uint deadline
1013     ) external returns (uint amountA, uint amountB, uint liquidity);
1014     function addLiquidityETH(
1015         address token,
1016         uint amountTokenDesired,
1017         uint amountTokenMin,
1018         uint amountETHMin,
1019         address to,
1020         uint deadline
1021     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1022     function removeLiquidity(
1023         address tokenA,
1024         address tokenB,
1025         uint liquidity,
1026         uint amountAMin,
1027         uint amountBMin,
1028         address to,
1029         uint deadline
1030     ) external returns (uint amountA, uint amountB);
1031     function removeLiquidityETH(
1032         address token,
1033         uint liquidity,
1034         uint amountTokenMin,
1035         uint amountETHMin,
1036         address to,
1037         uint deadline
1038     ) external returns (uint amountToken, uint amountETH);
1039     function removeLiquidityWithPermit(
1040         address tokenA,
1041         address tokenB,
1042         uint liquidity,
1043         uint amountAMin,
1044         uint amountBMin,
1045         address to,
1046         uint deadline,
1047         bool approveMax, uint8 v, bytes32 r, bytes32 s
1048     ) external returns (uint amountA, uint amountB);
1049     function removeLiquidityETHWithPermit(
1050         address token,
1051         uint liquidity,
1052         uint amountTokenMin,
1053         uint amountETHMin,
1054         address to,
1055         uint deadline,
1056         bool approveMax, uint8 v, bytes32 r, bytes32 s
1057     ) external returns (uint amountToken, uint amountETH);
1058     function swapExactTokensForTokens(
1059         uint amountIn,
1060         uint amountOutMin,
1061         address[] calldata path,
1062         address to,
1063         uint deadline
1064     ) external returns (uint[] memory amounts);
1065     function swapTokensForExactTokens(
1066         uint amountOut,
1067         uint amountInMax,
1068         address[] calldata path,
1069         address to,
1070         uint deadline
1071     ) external returns (uint[] memory amounts);
1072     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1073         external
1074         payable
1075         returns (uint[] memory amounts);
1076     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1077         external
1078         returns (uint[] memory amounts);
1079     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1080         external
1081         returns (uint[] memory amounts);
1082     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1083         external
1084         payable
1085         returns (uint[] memory amounts);
1086 
1087     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1088     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1089     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1090     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1091     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1092 }
1093 
1094 interface IUniswapV2Router02 is IUniswapV2Router01 {
1095     function removeLiquidityETHSupportingFeeOnTransferTokens(
1096         address token,
1097         uint liquidity,
1098         uint amountTokenMin,
1099         uint amountETHMin,
1100         address to,
1101         uint deadline
1102     ) external returns (uint amountETH);
1103     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1104         address token,
1105         uint liquidity,
1106         uint amountTokenMin,
1107         uint amountETHMin,
1108         address to,
1109         uint deadline,
1110         bool approveMax, uint8 v, bytes32 r, bytes32 s
1111     ) external returns (uint amountETH);
1112 
1113     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1114         uint amountIn,
1115         uint amountOutMin,
1116         address[] calldata path,
1117         address to,
1118         uint deadline
1119     ) external;
1120     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1121         uint amountOutMin,
1122         address[] calldata path,
1123         address to,
1124         uint deadline
1125     ) external payable;
1126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1127         uint amountIn,
1128         uint amountOutMin,
1129         address[] calldata path,
1130         address to,
1131         uint deadline
1132     ) external;
1133 }
1134 
1135 
1136 contract Betrock is ERC20, Ownable  {
1137     using SafeMath for uint256;
1138 
1139     IUniswapV2Router02 public immutable uniswapV2Router;
1140     address public immutable uniswapV2Pair;
1141     address public constant deadAddress = address(0xdead);
1142 
1143     bool private swapping;
1144 
1145     address public marketingWallet;
1146     address public devWallet;
1147     
1148     uint256 public maxTransactionAmount;
1149     uint256 public swapTokensAtAmount;
1150     uint256 public maxWallet;
1151     
1152     uint256 public percentForLPBurn = 1; // 25 = .25%
1153     bool public lpBurnEnabled = false;
1154     uint256 public lpBurnFrequency = 1360000000000 seconds;
1155     uint256 public lastLpBurnTime;
1156     
1157     uint256 public manualBurnFrequency = 43210 minutes;
1158     uint256 public lastManualLpBurnTime;
1159 
1160     bool public limitsInEffect = true;
1161     bool public tradingActive = true; // go live after adding LP
1162     bool public swapEnabled = true;
1163     
1164      // Anti-bot and anti-whale mappings and variables
1165     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1166     bool public transferDelayEnabled = true;
1167 
1168     uint256 public buyTotalFees;
1169     uint256 public buyMarketingFee;
1170     uint256 public buyLiquidityFee;
1171     uint256 public buyDevFee;
1172     
1173     uint256 public sellTotalFees;
1174     uint256 public sellMarketingFee;
1175     uint256 public sellLiquidityFee;
1176     uint256 public sellDevFee;
1177     
1178     uint256 public tokensForMarketing;
1179     uint256 public tokensForLiquidity;
1180     uint256 public tokensForDev;
1181     
1182     /******************/
1183 
1184     // exlcude from fees and max transaction amount
1185     mapping (address => bool) private _isExcludedFromFees;
1186     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1187 
1188     // blacklist
1189     mapping(address => bool) public blacklists;
1190 
1191     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1192     // could be subject to a maximum transfer amount
1193     mapping (address => bool) public automatedMarketMakerPairs;
1194 
1195     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1196 
1197     event ExcludeFromFees(address indexed account, bool isExcluded);
1198 
1199     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1200 
1201     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
1202     
1203     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
1204 
1205     event SwapAndLiquify(
1206         uint256 tokensSwapped,
1207         uint256 ethReceived,
1208         uint256 tokensIntoLiquidity
1209     );
1210     
1211     event AutoNukeLP();
1212     
1213     event ManualNukeLP();
1214 
1215     constructor() ERC20("Betrock", "BETROCK") {
1216         
1217         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1218         
1219         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1220         uniswapV2Router = _uniswapV2Router;
1221         
1222         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1223         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1224         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1225         
1226         uint256 _buyMarketingFee = 0;
1227         uint256 _buyLiquidityFee = 0;
1228         uint256 _buyDevFee = 10;
1229 
1230         uint256 _sellMarketingFee = 0;
1231         uint256 _sellLiquidityFee = 0;
1232         uint256 _sellDevFee = 30;
1233         
1234         uint256 totalSupply = 100_000_000 * 1e18;
1235         
1236         //  Maximum tx size and wallet size
1237         maxTransactionAmount = totalSupply * 1 / 100;
1238         maxWallet = totalSupply * 1 / 100;
1239 
1240         swapTokensAtAmount = totalSupply * 1 / 10000;
1241 
1242         buyMarketingFee = _buyMarketingFee;
1243         buyLiquidityFee = _buyLiquidityFee;
1244         buyDevFee = _buyDevFee;
1245         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1246         
1247         sellMarketingFee = _sellMarketingFee;
1248         sellLiquidityFee = _sellLiquidityFee;
1249         sellDevFee = _sellDevFee;
1250         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1251         
1252         marketingWallet = address(owner()); // set as marketing wallet
1253         devWallet = address(owner()); // set as dev wallet
1254 
1255         // exclude from paying fees or having max transaction amount
1256         excludeFromFees(owner(), true);
1257         excludeFromFees(address(this), true);
1258         excludeFromFees(address(0xdead), true);
1259         
1260         excludeFromMaxTransaction(owner(), true);
1261         excludeFromMaxTransaction(address(this), true);
1262         excludeFromMaxTransaction(address(0xdead), true);
1263         
1264         /*
1265             _mint is an internal function in ERC20.sol that is only called here,
1266             and CANNOT be called ever again
1267         */
1268         _mint(msg.sender, totalSupply);
1269     }
1270 
1271     receive() external payable {
1272 
1273     }
1274 
1275     function blacklist(address[] calldata _addresses, bool _isBlacklisting) external onlyOwner {
1276         for (uint i=0; i<_addresses.length; i++) {
1277             blacklists[_addresses[i]] = _isBlacklisting;
1278         }
1279     }
1280 
1281     // once enabled, can never be turned off
1282     function enableTrading() external onlyOwner {
1283         tradingActive = true;
1284         swapEnabled = true;
1285         lastLpBurnTime = block.timestamp;
1286     }
1287     
1288     // remove limits after token is stable
1289     function removeLimits() external onlyOwner returns (bool){
1290         limitsInEffect = false;
1291         return true;
1292     }
1293     
1294     // disable Transfer delay - cannot be reenabled
1295     function disableTransferDelay() external onlyOwner returns (bool){
1296         transferDelayEnabled = false;
1297         return true;
1298     }
1299     
1300      // change the minimum amount of tokens to sell from fees
1301     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1302         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1303         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
1304         swapTokensAtAmount = newAmount;
1305         return true;
1306     }
1307     
1308     function updateMaxLimits(uint256 maxPerTx, uint256 maxPerWallet) external onlyOwner {
1309         require(maxPerTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1310         maxTransactionAmount = maxPerTx * (10**18);
1311 
1312         require(maxPerWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1313         maxWallet = maxPerWallet * (10**18);
1314     }
1315     
1316     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1317         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1318         maxTransactionAmount = newNum * (10**18);
1319     }
1320 
1321     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1322         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1323         maxWallet = newNum * (10**18);
1324     }
1325     
1326     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1327         _isExcludedMaxTransactionAmount[updAds] = isEx;
1328     }
1329     
1330     // only use to disable contract sales if absolutely necessary (emergency use only)
1331     function updateSwapEnabled(bool enabled) external onlyOwner(){
1332         swapEnabled = enabled;
1333     }
1334     
1335     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1336         buyMarketingFee = _marketingFee;
1337         buyLiquidityFee = _liquidityFee;
1338         buyDevFee = _devFee;
1339         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1340         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1341     }
1342     
1343     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1344         sellMarketingFee = _marketingFee;
1345         sellLiquidityFee = _liquidityFee;
1346         sellDevFee = _devFee;
1347         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1348         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1349     }
1350 
1351     function updateTaxes (uint256 buy, uint256 sell) external onlyOwner {
1352         sellDevFee = sell;
1353         buyDevFee = buy;
1354         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1355         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1356         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1357         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1358     }
1359 
1360     function excludeFromFees(address account, bool excluded) public onlyOwner {
1361         _isExcludedFromFees[account] = excluded;
1362         emit ExcludeFromFees(account, excluded);
1363     }
1364 
1365     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1366         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1367 
1368         _setAutomatedMarketMakerPair(pair, value);
1369     }
1370 
1371     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1372         automatedMarketMakerPairs[pair] = value;
1373 
1374         emit SetAutomatedMarketMakerPair(pair, value);
1375     }
1376 
1377     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1378         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1379         marketingWallet = newMarketingWallet;
1380     }
1381     
1382     function updateDevWallet(address newWallet) external onlyOwner {
1383         emit devWalletUpdated(newWallet, devWallet);
1384         devWallet = newWallet;
1385     }
1386     
1387 
1388     function isExcludedFromFees(address account) public view returns(bool) {
1389         return _isExcludedFromFees[account];
1390     }
1391     
1392     event BoughtEarly(address indexed sniper);
1393 
1394     function _transfer(
1395         address from,
1396         address to,
1397         uint256 amount
1398     ) internal override {
1399         require(from != address(0), "ERC20: transfer from the zero address");
1400         require(to != address(0), "ERC20: transfer to the zero address");
1401         require(!blacklists[to] && !blacklists[from], "Blacklisted");
1402         
1403          if(amount == 0) {
1404             super._transfer(from, to, 0);
1405             return;
1406         }
1407         
1408         if(limitsInEffect){
1409             if (
1410                 from != owner() &&
1411                 to != owner() &&
1412                 to != address(0) &&
1413                 to != address(0xdead) &&
1414                 !swapping
1415             ){
1416                 if(!tradingActive){
1417                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1418                 }
1419 
1420                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1421                 if (transferDelayEnabled){
1422                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1423                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1424                         _holderLastTransferTimestamp[tx.origin] = block.number;
1425                     }
1426                 }
1427                  
1428                 //when buy
1429                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1430                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1431                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1432                 }
1433                 
1434                 //when sell
1435                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1436                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1437                 }
1438                 else if(!_isExcludedMaxTransactionAmount[to]){
1439                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1440                 }
1441             }
1442         }
1443         
1444         
1445         uint256 contractTokenBalance = balanceOf(address(this));
1446         
1447         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1448 
1449         if( 
1450             canSwap &&
1451             swapEnabled &&
1452             !swapping &&
1453             !automatedMarketMakerPairs[from] &&
1454             !_isExcludedFromFees[from] &&
1455             !_isExcludedFromFees[to]
1456         ) {
1457             swapping = true;
1458             
1459             swapBack();
1460 
1461             swapping = false;
1462         }
1463         
1464         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1465             autoBurnLiquidityPairTokens();
1466         }
1467 
1468         bool takeFee = !swapping;
1469 
1470         // if any account belongs to _isExcludedFromFee account then remove the fee
1471         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1472             takeFee = false;
1473         }
1474         
1475         uint256 fees = 0;
1476         // only take fees on buys/sells, do not take on wallet transfers
1477         if(takeFee){
1478             // on sell
1479             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1480                 fees = amount.mul(sellTotalFees).div(100);
1481                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1482                 tokensForDev += fees * sellDevFee / sellTotalFees;
1483                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1484             }
1485             // on buy
1486             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1487                 fees = amount.mul(buyTotalFees).div(100);
1488                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1489                 tokensForDev += fees * buyDevFee / buyTotalFees;
1490                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1491             }
1492             
1493             if(fees > 0){    
1494                 super._transfer(from, address(this), fees);
1495             }
1496             
1497             amount -= fees;
1498         }
1499 
1500         super._transfer(from, to, amount);
1501     }
1502 
1503     function swapTokensForEth(uint256 tokenAmount) private {
1504 
1505         // generate the uniswap pair path of token -> weth
1506         address[] memory path = new address[](2);
1507         path[0] = address(this);
1508         path[1] = uniswapV2Router.WETH();
1509 
1510         _approve(address(this), address(uniswapV2Router), tokenAmount);
1511 
1512         // make the swap
1513         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1514             tokenAmount,
1515             0, // accept any amount of ETH
1516             path,
1517             address(this),
1518             block.timestamp
1519         );
1520         
1521     }
1522     
1523     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1524         // approve token transfer to cover all possible scenarios
1525         _approve(address(this), address(uniswapV2Router), tokenAmount);
1526 
1527         // add the liquidity
1528         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1529             address(this),
1530             tokenAmount,
1531             0, // slippage is unavoidable
1532             0, // slippage is unavoidable
1533             deadAddress,
1534             block.timestamp
1535         );
1536     }
1537 
1538     function swapBack() private {
1539         uint256 contractBalance = balanceOf(address(this));
1540         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1541         bool success;
1542         
1543         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1544 
1545         if(contractBalance > swapTokensAtAmount * 20){
1546           contractBalance = swapTokensAtAmount * 20;
1547         }
1548         
1549         // Halve the amount of liquidity tokens
1550         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1551         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1552         
1553         uint256 initialETHBalance = address(this).balance;
1554 
1555         swapTokensForEth(amountToSwapForETH); 
1556         
1557         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1558         
1559         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1560         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1561         
1562         
1563         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1564         
1565         
1566         tokensForLiquidity = 0;
1567         tokensForMarketing = 0;
1568         tokensForDev = 0;
1569         
1570         (success,) = address(devWallet).call{value: ethForDev}("");
1571         
1572         if(liquidityTokens > 0 && ethForLiquidity > 0){
1573             addLiquidity(liquidityTokens, ethForLiquidity);
1574             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1575         }
1576         
1577         
1578         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1579     }
1580     
1581     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1582         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1583         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1584         lpBurnFrequency = _frequencyInSeconds;
1585         percentForLPBurn = _percent;
1586         lpBurnEnabled = _Enabled;
1587     }
1588     
1589     function autoBurnLiquidityPairTokens() internal returns (bool){
1590         
1591         lastLpBurnTime = block.timestamp;
1592         
1593         // get balance of liquidity pair
1594         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1595         
1596         // calculate amount to burn
1597         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1598         
1599         // pull tokens from pancakePair liquidity and move to dead address permanently
1600         if (amountToBurn > 0){
1601             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1602         }
1603         
1604         //sync price since this is not in a swap transaction!
1605         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1606         pair.sync();
1607         emit AutoNukeLP();
1608         return true;
1609     }
1610 
1611     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1612         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1613         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1614         lastManualLpBurnTime = block.timestamp;
1615         
1616         // get balance of liquidity pair
1617         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1618         
1619         // calculate amount to burn
1620         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1621         
1622         // pull tokens from pancakePair liquidity and move to dead address permanently
1623         if (amountToBurn > 0){
1624             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1625         }
1626         
1627         //sync price since this is not in a swap transaction!
1628         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1629         pair.sync();
1630         emit ManualNukeLP();
1631         return true;
1632     }
1633 }