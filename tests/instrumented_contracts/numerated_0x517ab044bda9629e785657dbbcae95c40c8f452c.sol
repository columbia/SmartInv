1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/utils/Context.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes calldata) {
252         return msg.data;
253     }
254 }
255 
256 // File: @openzeppelin/contracts/access/Ownable.sol
257 
258 
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 abstract contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor() {
284         _setOwner(_msgSender());
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view virtual returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(owner() == _msgSender(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public virtual onlyOwner {
310         _setOwner(address(0));
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      * Can only be called by the current owner.
316      */
317     function transferOwnership(address newOwner) public virtual onlyOwner {
318         require(newOwner != address(0), "Ownable: new owner is the zero address");
319         _setOwner(newOwner);
320     }
321 
322     function _setOwner(address newOwner) private {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
330 
331 
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev Interface of the ERC20 standard as defined in the EIP.
337  */
338 interface IERC20 {
339     /**
340      * @dev Returns the amount of tokens in existence.
341      */
342     function totalSupply() external view returns (uint256);
343 
344     /**
345      * @dev Returns the amount of tokens owned by `account`.
346      */
347     function balanceOf(address account) external view returns (uint256);
348 
349     /**
350      * @dev Moves `amount` tokens from the caller's account to `recipient`.
351      *
352      * Returns a boolean value indicating whether the operation succeeded.
353      *
354      * Emits a {Transfer} event.
355      */
356     function transfer(address recipient, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Returns the remaining number of tokens that `spender` will be
360      * allowed to spend on behalf of `owner` through {transferFrom}. This is
361      * zero by default.
362      *
363      * This value changes when {approve} or {transferFrom} are called.
364      */
365     function allowance(address owner, address spender) external view returns (uint256);
366 
367     /**
368      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * IMPORTANT: Beware that changing an allowance with this method brings the risk
373      * that someone may use both the old and the new allowance by unfortunate
374      * transaction ordering. One possible solution to mitigate this race
375      * condition is to first reduce the spender's allowance to 0 and set the
376      * desired value afterwards:
377      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
378      *
379      * Emits an {Approval} event.
380      */
381     function approve(address spender, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Moves `amount` tokens from `sender` to `recipient` using the
385      * allowance mechanism. `amount` is then deducted from the caller's
386      * allowance.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(
393         address sender,
394         address recipient,
395         uint256 amount
396     ) external returns (bool);
397 
398     /**
399      * @dev Emitted when `value` tokens are moved from one account (`from`) to
400      * another (`to`).
401      *
402      * Note that `value` may be zero.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 value);
405 
406     /**
407      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
408      * a call to {approve}. `value` is the new allowance.
409      */
410     event Approval(address indexed owner, address indexed spender, uint256 value);
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
414 
415 
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Interface for the optional metadata functions from the ERC20 standard.
422  *
423  * _Available since v4.1._
424  */
425 interface IERC20Metadata is IERC20 {
426     /**
427      * @dev Returns the name of the token.
428      */
429     function name() external view returns (string memory);
430 
431     /**
432      * @dev Returns the symbol of the token.
433      */
434     function symbol() external view returns (string memory);
435 
436     /**
437      * @dev Returns the decimals places of the token.
438      */
439     function decimals() external view returns (uint8);
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
443 
444 
445 
446 pragma solidity ^0.8.0;
447 
448 
449 
450 
451 /**
452  * @dev Implementation of the {IERC20} interface.
453  *
454  * This implementation is agnostic to the way tokens are created. This means
455  * that a supply mechanism has to be added in a derived contract using {_mint}.
456  * For a generic mechanism see {ERC20PresetMinterPauser}.
457  *
458  * TIP: For a detailed writeup see our guide
459  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
460  * to implement supply mechanisms].
461  *
462  * We have followed general OpenZeppelin Contracts guidelines: functions revert
463  * instead returning `false` on failure. This behavior is nonetheless
464  * conventional and does not conflict with the expectations of ERC20
465  * applications.
466  *
467  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
468  * This allows applications to reconstruct the allowance for all accounts just
469  * by listening to said events. Other implementations of the EIP may not emit
470  * these events, as it isn't required by the specification.
471  *
472  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
473  * functions have been added to mitigate the well-known issues around setting
474  * allowances. See {IERC20-approve}.
475  */
476 contract ERC20 is Context, IERC20, IERC20Metadata {
477     mapping(address => uint256) private _balances;
478 
479     mapping(address => mapping(address => uint256)) private _allowances;
480 
481     uint256 private _totalSupply;
482 
483     string private _name;
484     string private _symbol;
485 
486     /**
487      * @dev Sets the values for {name} and {symbol}.
488      *
489      * The default value of {decimals} is 18. To select a different value for
490      * {decimals} you should overload it.
491      *
492      * All two of these values are immutable: they can only be set once during
493      * construction.
494      */
495     constructor(string memory name_, string memory symbol_) {
496         _name = name_;
497         _symbol = symbol_;
498     }
499 
500     /**
501      * @dev Returns the name of the token.
502      */
503     function name() public view virtual override returns (string memory) {
504         return _name;
505     }
506 
507     /**
508      * @dev Returns the symbol of the token, usually a shorter version of the
509      * name.
510      */
511     function symbol() public view virtual override returns (string memory) {
512         return _symbol;
513     }
514 
515     /**
516      * @dev Returns the number of decimals used to get its user representation.
517      * For example, if `decimals` equals `2`, a balance of `505` tokens should
518      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
519      *
520      * Tokens usually opt for a value of 18, imitating the relationship between
521      * Ether and Wei. This is the value {ERC20} uses, unless this function is
522      * overridden;
523      *
524      * NOTE: This information is only used for _display_ purposes: it in
525      * no way affects any of the arithmetic of the contract, including
526      * {IERC20-balanceOf} and {IERC20-transfer}.
527      */
528     function decimals() public view virtual override returns (uint8) {
529         return 18;
530     }
531 
532     /**
533      * @dev See {IERC20-totalSupply}.
534      */
535     function totalSupply() public view virtual override returns (uint256) {
536         return _totalSupply;
537     }
538 
539     /**
540      * @dev See {IERC20-balanceOf}.
541      */
542     function balanceOf(address account) public view virtual override returns (uint256) {
543         return _balances[account];
544     }
545 
546     /**
547      * @dev See {IERC20-transfer}.
548      *
549      * Requirements:
550      *
551      * - `recipient` cannot be the zero address.
552      * - the caller must have a balance of at least `amount`.
553      */
554     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
555         _transfer(_msgSender(), recipient, amount);
556         return true;
557     }
558 
559     /**
560      * @dev See {IERC20-allowance}.
561      */
562     function allowance(address owner, address spender) public view virtual override returns (uint256) {
563         return _allowances[owner][spender];
564     }
565 
566     /**
567      * @dev See {IERC20-approve}.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      */
573     function approve(address spender, uint256 amount) public virtual override returns (bool) {
574         _approve(_msgSender(), spender, amount);
575         return true;
576     }
577 
578     /**
579      * @dev See {IERC20-transferFrom}.
580      *
581      * Emits an {Approval} event indicating the updated allowance. This is not
582      * required by the EIP. See the note at the beginning of {ERC20}.
583      *
584      * Requirements:
585      *
586      * - `sender` and `recipient` cannot be the zero address.
587      * - `sender` must have a balance of at least `amount`.
588      * - the caller must have allowance for ``sender``'s tokens of at least
589      * `amount`.
590      */
591     function transferFrom(
592         address sender,
593         address recipient,
594         uint256 amount
595     ) public virtual override returns (bool) {
596         _transfer(sender, recipient, amount);
597 
598         uint256 currentAllowance = _allowances[sender][_msgSender()];
599         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
600         unchecked {
601             _approve(sender, _msgSender(), currentAllowance - amount);
602         }
603 
604         return true;
605     }
606 
607     /**
608      * @dev Atomically increases the allowance granted to `spender` by the caller.
609      *
610      * This is an alternative to {approve} that can be used as a mitigation for
611      * problems described in {IERC20-approve}.
612      *
613      * Emits an {Approval} event indicating the updated allowance.
614      *
615      * Requirements:
616      *
617      * - `spender` cannot be the zero address.
618      */
619     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
620         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
621         return true;
622     }
623 
624     /**
625      * @dev Atomically decreases the allowance granted to `spender` by the caller.
626      *
627      * This is an alternative to {approve} that can be used as a mitigation for
628      * problems described in {IERC20-approve}.
629      *
630      * Emits an {Approval} event indicating the updated allowance.
631      *
632      * Requirements:
633      *
634      * - `spender` cannot be the zero address.
635      * - `spender` must have allowance for the caller of at least
636      * `subtractedValue`.
637      */
638     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
639         uint256 currentAllowance = _allowances[_msgSender()][spender];
640         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
641         unchecked {
642             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
643         }
644 
645         return true;
646     }
647 
648     /**
649      * @dev Moves `amount` of tokens from `sender` to `recipient`.
650      *
651      * This internal function is equivalent to {transfer}, and can be used to
652      * e.g. implement automatic token fees, slashing mechanisms, etc.
653      *
654      * Emits a {Transfer} event.
655      *
656      * Requirements:
657      *
658      * - `sender` cannot be the zero address.
659      * - `recipient` cannot be the zero address.
660      * - `sender` must have a balance of at least `amount`.
661      */
662     function _transfer(
663         address sender,
664         address recipient,
665         uint256 amount
666     ) internal virtual {
667         require(sender != address(0), "ERC20: transfer from the zero address");
668         require(recipient != address(0), "ERC20: transfer to the zero address");
669 
670         _beforeTokenTransfer(sender, recipient, amount);
671 
672         uint256 senderBalance = _balances[sender];
673         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
674         unchecked {
675             _balances[sender] = senderBalance - amount;
676         }
677         _balances[recipient] += amount;
678 
679         emit Transfer(sender, recipient, amount);
680 
681         _afterTokenTransfer(sender, recipient, amount);
682     }
683 
684     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
685      * the total supply.
686      *
687      * Emits a {Transfer} event with `from` set to the zero address.
688      *
689      * Requirements:
690      *
691      * - `account` cannot be the zero address.
692      */
693     function _mint(address account, uint256 amount) internal virtual {
694         require(account != address(0), "ERC20: mint to the zero address");
695 
696         _beforeTokenTransfer(address(0), account, amount);
697 
698         _totalSupply += amount;
699         _balances[account] += amount;
700         emit Transfer(address(0), account, amount);
701 
702         _afterTokenTransfer(address(0), account, amount);
703     }
704 
705     /**
706      * @dev Destroys `amount` tokens from `account`, reducing the
707      * total supply.
708      *
709      * Emits a {Transfer} event with `to` set to the zero address.
710      *
711      * Requirements:
712      *
713      * - `account` cannot be the zero address.
714      * - `account` must have at least `amount` tokens.
715      */
716     function _burn(address account, uint256 amount) internal virtual {
717         require(account != address(0), "ERC20: burn from the zero address");
718 
719         _beforeTokenTransfer(account, address(0), amount);
720 
721         uint256 accountBalance = _balances[account];
722         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
723         unchecked {
724             _balances[account] = accountBalance - amount;
725         }
726         _totalSupply -= amount;
727 
728         emit Transfer(account, address(0), amount);
729 
730         _afterTokenTransfer(account, address(0), amount);
731     }
732 
733     /**
734      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
735      *
736      * This internal function is equivalent to `approve`, and can be used to
737      * e.g. set automatic allowances for certain subsystems, etc.
738      *
739      * Emits an {Approval} event.
740      *
741      * Requirements:
742      *
743      * - `owner` cannot be the zero address.
744      * - `spender` cannot be the zero address.
745      */
746     function _approve(
747         address owner,
748         address spender,
749         uint256 amount
750     ) internal virtual {
751         require(owner != address(0), "ERC20: approve from the zero address");
752         require(spender != address(0), "ERC20: approve to the zero address");
753 
754         _allowances[owner][spender] = amount;
755         emit Approval(owner, spender, amount);
756     }
757 
758     /**
759      * @dev Hook that is called before any transfer of tokens. This includes
760      * minting and burning.
761      *
762      * Calling conditions:
763      *
764      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
765      * will be transferred to `to`.
766      * - when `from` is zero, `amount` tokens will be minted for `to`.
767      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
768      * - `from` and `to` are never both zero.
769      *
770      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
771      */
772     function _beforeTokenTransfer(
773         address from,
774         address to,
775         uint256 amount
776     ) internal virtual {}
777 
778     /**
779      * @dev Hook that is called after any transfer of tokens. This includes
780      * minting and burning.
781      *
782      * Calling conditions:
783      *
784      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
785      * has been transferred to `to`.
786      * - when `from` is zero, `amount` tokens have been minted for `to`.
787      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
788      * - `from` and `to` are never both zero.
789      *
790      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
791      */
792     function _afterTokenTransfer(
793         address from,
794         address to,
795         uint256 amount
796     ) internal virtual {}
797 }
798 
799 // File: contracts/JiraToken.sol
800 
801 
802 pragma solidity ^0.8.4;
803 
804 
805 
806 
807 contract JiraToken is ERC20, Ownable {
808     using SafeMath for uint256;
809 
810     address public staking; //TODO : Set Address
811     uint8 public _decimals = 18;
812     string public _name = 'Jira Token';
813     string public _symbol = 'JIRA';
814     uint256 TOTAL_CAP = 2 * 10 ** 8 * 1e18;
815     uint256 STAKING_CAP = 10 ** 7 * 1e18;
816     uint256 stakingSupply = 0;
817 
818     constructor() ERC20(_name, _symbol) {
819 
820     }
821 
822     modifier onlyStaking() {
823         require(msg.sender == staking, "Not staking");
824         _;
825     }
826     
827     function mint(address _to, uint256 _amount) external onlyStaking {
828         require(_amount != 0, "Invalid amount");
829         require(stakingSupply + _amount <= STAKING_CAP, "Max limit");
830 	    stakingSupply += _amount;
831         _mint(_to, _amount);
832     }
833 
834     function mintOnlyOwner(address _to, uint256 _amount) external onlyOwner {
835         require(_amount != 0, "Invalid amount");
836         require(totalSupply() + _amount <= TOTAL_CAP, "Max limit");
837         _mint(_to, _amount);
838     }
839 
840     function modifyTotalCap(uint256 _cap) external onlyOwner {
841 	require(_cap > totalSupply(), "total supply already exceeds");
842 	TOTAL_CAP = _cap;
843     }
844 
845     function modifyStakingCap(uint256 _cap) external onlyOwner {
846 	require(_cap > stakeSupply(), "staking supply already exceeds");
847 	STAKING_CAP = _cap;
848     }
849 
850     function modifyStakingOwner(address _staking) external onlyOwner {
851         staking = _staking;
852     }
853 
854     function stakeSupply() public view returns (uint256) {
855 	return stakingSupply;
856     }
857 
858     /**
859      * @dev Destroys `amount` tokens from the caller.
860      *
861      * See {ERC20-_burn}.
862      */
863     function burn(uint256 amount) public virtual {
864         _burn(_msgSender(), amount);
865     }
866 }