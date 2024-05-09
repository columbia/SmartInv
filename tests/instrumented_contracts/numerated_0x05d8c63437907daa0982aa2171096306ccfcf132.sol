1 // Sources flattened with hardhat v2.4.0 https://hardhat.org
2 
3 // SPDX-License-Identifier: MIT
4 
5 /*
6 * website: https://betdao.live
7 * telegram: https://t.me/BetDaoEntryPortal
8 */
9 pragma solidity ^0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
34 
35 
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor () {
60         address msgSender = _msgSender();
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view virtual returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(owner() == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 
104 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.1.0
105 
106 
107 
108 pragma solidity ^0.8.0;
109 
110 // CAUTION
111 // This version of SafeMath should only be used with Solidity 0.8 or later,
112 // because it relies on the compiler's built in overflow checks.
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations.
116  *
117  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
118  * now has built in overflow checking.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         unchecked {
128             uint256 c = a + b;
129             if (c < a) return (false, 0);
130             return (true, c);
131         }
132     }
133 
134     /**
135      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         unchecked {
141             if (b > a) return (false, 0);
142             return (true, a - b);
143         }
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154             // benefit is lost if 'b' is also tested.
155             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156             if (a == 0) return (true, 0);
157             uint256 c = a * b;
158             if (c / a != b) return (false, 0);
159             return (true, c);
160         }
161     }
162 
163     /**
164      * @dev Returns the division of two unsigned integers, with a division by zero flag.
165      *
166      * _Available since v3.4._
167      */
168     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         unchecked {
170             if (b == 0) return (false, 0);
171             return (true, a / b);
172         }
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
177      *
178      * _Available since v3.4._
179      */
180     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
181         unchecked {
182             if (b == 0) return (false, 0);
183             return (true, a % b);
184         }
185     }
186 
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      *
195      * - Addition cannot overflow.
196      */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         return a + b;
199     }
200 
201     /**
202      * @dev Returns the subtraction of two unsigned integers, reverting on
203      * overflow (when the result is negative).
204      *
205      * Counterpart to Solidity's `-` operator.
206      *
207      * Requirements:
208      *
209      * - Subtraction cannot overflow.
210      */
211     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a * b;
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers, reverting on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator.
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function div(uint256 a, uint256 b) internal pure returns (uint256) {
240         return a / b;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * reverting when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a % b;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
261      * overflow (when the result is negative).
262      *
263      * CAUTION: This function is deprecated because it requires allocating memory for the error
264      * message unnecessarily. For custom revert reasons use {trySub}.
265      *
266      * Counterpart to Solidity's `-` operator.
267      *
268      * Requirements:
269      *
270      * - Subtraction cannot overflow.
271      */
272     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         unchecked {
274             require(b <= a, errorMessage);
275             return a - b;
276         }
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
281      * division by zero. The result is rounded towards zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         unchecked {
297             require(b > 0, errorMessage);
298             return a / b;
299         }
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * reverting with custom message when dividing by zero.
305      *
306      * CAUTION: This function is deprecated because it requires allocating memory for the error
307      * message unnecessarily. For custom revert reasons use {tryMod}.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         unchecked {
319             require(b > 0, errorMessage);
320             return a % b;
321         }
322     }
323 }
324 
325 
326 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
327 
328 
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC20 standard as defined in the EIP.
334  */
335 interface IERC20 {
336     /**
337      * @dev Returns the amount of tokens in existence.
338      */
339     function totalSupply() external view returns (uint256);
340 
341     /**
342      * @dev Returns the amount of tokens owned by `account`.
343      */
344     function balanceOf(address account) external view returns (uint256);
345 
346     /**
347      * @dev Moves `amount` tokens from the caller's account to `recipient`.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transfer(address recipient, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Returns the remaining number of tokens that `spender` will be
357      * allowed to spend on behalf of `owner` through {transferFrom}. This is
358      * zero by default.
359      *
360      * This value changes when {approve} or {transferFrom} are called.
361      */
362     function allowance(address owner, address spender) external view returns (uint256);
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * IMPORTANT: Beware that changing an allowance with this method brings the risk
370      * that someone may use both the old and the new allowance by unfortunate
371      * transaction ordering. One possible solution to mitigate this race
372      * condition is to first reduce the spender's allowance to 0 and set the
373      * desired value afterwards:
374      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
375      *
376      * Emits an {Approval} event.
377      */
378     function approve(address spender, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Moves `amount` tokens from `sender` to `recipient` using the
382      * allowance mechanism. `amount` is then deducted from the caller's
383      * allowance.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Emitted when `value` tokens are moved from one account (`from`) to
393      * another (`to`).
394      *
395      * Note that `value` may be zero.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 value);
398 
399     /**
400      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
401      * a call to {approve}. `value` is the new allowance.
402      */
403     event Approval(address indexed owner, address indexed spender, uint256 value);
404 }
405 
406 
407 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.1.0
408 
409 
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @dev Interface for the optional metadata functions from the ERC20 standard.
415  *
416  * _Available since v4.1._
417  */
418 interface IERC20Metadata is IERC20 {
419     /**
420      * @dev Returns the name of the token.
421      */
422     function name() external view returns (string memory);
423 
424     /**
425      * @dev Returns the symbol of the token.
426      */
427     function symbol() external view returns (string memory);
428 
429     /**
430      * @dev Returns the decimals places of the token.
431      */
432     function decimals() external view returns (uint8);
433 }
434 
435 
436 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.1.0
437 
438 
439 
440 pragma solidity ^0.8.0;
441 
442 
443 
444 /**
445  * @dev Implementation of the {IERC20} interface.
446  *
447  * This implementation is agnostic to the way tokens are created. This means
448  * that a supply mechanism has to be added in a derived contract using {_mint}.
449  * For a generic mechanism see {ERC20PresetMinterPauser}.
450  *
451  * TIP: For a detailed writeup see our guide
452  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
453  * to implement supply mechanisms].
454  *
455  * We have followed general OpenZeppelin guidelines: functions revert instead
456  * of returning `false` on failure. This behavior is nonetheless conventional
457  * and does not conflict with the expectations of ERC20 applications.
458  *
459  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
460  * This allows applications to reconstruct the allowance for all accounts just
461  * by listening to said events. Other implementations of the EIP may not emit
462  * these events, as it isn't required by the specification.
463  *
464  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
465  * functions have been added to mitigate the well-known issues around setting
466  * allowances. See {IERC20-approve}.
467  */
468 contract ERC20 is Context, IERC20, IERC20Metadata {
469     mapping (address => uint256) private _balances;
470 
471     mapping (address => mapping (address => uint256)) private _allowances;
472 
473     uint256 private _totalSupply;
474 
475     string private _name;
476     string private _symbol;
477 
478     /**
479      * @dev Sets the values for {name} and {symbol}.
480      *
481      * The defaut value of {decimals} is 18. To select a different value for
482      * {decimals} you should overload it.
483      *
484      * All two of these values are immutable: they can only be set once during
485      * construction.
486      */
487     constructor (string memory name_, string memory symbol_) {
488         _name = name_;
489         _symbol = symbol_;
490     }
491 
492     /**
493      * @dev Returns the name of the token.
494      */
495     function name() public view virtual override returns (string memory) {
496         return _name;
497     }
498 
499     /**
500      * @dev Returns the symbol of the token, usually a shorter version of the
501      * name.
502      */
503     function symbol() public view virtual override returns (string memory) {
504         return _symbol;
505     }
506 
507     /**
508      * @dev Returns the number of decimals used to get its user representation.
509      * For example, if `decimals` equals `2`, a balance of `505` tokens should
510      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
511      *
512      * Tokens usually opt for a value of 18, imitating the relationship between
513      * Ether and Wei. This is the value {ERC20} uses, unless this function is
514      * overridden;
515      *
516      * NOTE: This information is only used for _display_ purposes: it in
517      * no way affects any of the arithmetic of the contract, including
518      * {IERC20-balanceOf} and {IERC20-transfer}.
519      */
520     function decimals() public view virtual override returns (uint8) {
521         return 18;
522     }
523 
524     /**
525      * @dev See {IERC20-totalSupply}.
526      */
527     function totalSupply() public view virtual override returns (uint256) {
528         return _totalSupply;
529     }
530 
531     /**
532      * @dev See {IERC20-balanceOf}.
533      */
534     function balanceOf(address account) public view virtual override returns (uint256) {
535         return _balances[account];
536     }
537 
538     /**
539      * @dev See {IERC20-transfer}.
540      *
541      * Requirements:
542      *
543      * - `recipient` cannot be the zero address.
544      * - the caller must have a balance of at least `amount`.
545      */
546     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
547         _transfer(_msgSender(), recipient, amount);
548         return true;
549     }
550 
551     /**
552      * @dev See {IERC20-allowance}.
553      */
554     function allowance(address owner, address spender) public view virtual override returns (uint256) {
555         return _allowances[owner][spender];
556     }
557 
558     /**
559      * @dev See {IERC20-approve}.
560      *
561      * Requirements:
562      *
563      * - `spender` cannot be the zero address.
564      */
565     function approve(address spender, uint256 amount) public virtual override returns (bool) {
566         _approve(_msgSender(), spender, amount);
567         return true;
568     }
569 
570     /**
571      * @dev See {IERC20-transferFrom}.
572      *
573      * Emits an {Approval} event indicating the updated allowance. This is not
574      * required by the EIP. See the note at the beginning of {ERC20}.
575      *
576      * Requirements:
577      *
578      * - `sender` and `recipient` cannot be the zero address.
579      * - `sender` must have a balance of at least `amount`.
580      * - the caller must have allowance for ``sender``'s tokens of at least
581      * `amount`.
582      */
583     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
584         _transfer(sender, recipient, amount);
585 
586         uint256 currentAllowance = _allowances[sender][_msgSender()];
587         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
588         _approve(sender, _msgSender(), currentAllowance - amount);
589 
590         return true;
591     }
592 
593     /**
594      * @dev Atomically increases the allowance granted to `spender` by the caller.
595      *
596      * This is an alternative to {approve} that can be used as a mitigation for
597      * problems described in {IERC20-approve}.
598      *
599      * Emits an {Approval} event indicating the updated allowance.
600      *
601      * Requirements:
602      *
603      * - `spender` cannot be the zero address.
604      */
605     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
606         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
607         return true;
608     }
609 
610     /**
611      * @dev Atomically decreases the allowance granted to `spender` by the caller.
612      *
613      * This is an alternative to {approve} that can be used as a mitigation for
614      * problems described in {IERC20-approve}.
615      *
616      * Emits an {Approval} event indicating the updated allowance.
617      *
618      * Requirements:
619      *
620      * - `spender` cannot be the zero address.
621      * - `spender` must have allowance for the caller of at least
622      * `subtractedValue`.
623      */
624     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
625         uint256 currentAllowance = _allowances[_msgSender()][spender];
626         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
627         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
628 
629         return true;
630     }
631 
632     /**
633      * @dev Moves tokens `amount` from `sender` to `recipient`.
634      *
635      * This is internal function is equivalent to {transfer}, and can be used to
636      * e.g. implement automatic token fees, slashing mechanisms, etc.
637      *
638      * Emits a {Transfer} event.
639      *
640      * Requirements:
641      *
642      * - `sender` cannot be the zero address.
643      * - `recipient` cannot be the zero address.
644      * - `sender` must have a balance of at least `amount`.
645      */
646     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
647         require(sender != address(0), "ERC20: transfer from the zero address");
648         require(recipient != address(0), "ERC20: transfer to the zero address");
649 
650         _beforeTokenTransfer(sender, recipient, amount);
651 
652         uint256 senderBalance = _balances[sender];
653         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
654         _balances[sender] = senderBalance - amount;
655         _balances[recipient] += amount;
656 
657         emit Transfer(sender, recipient, amount);
658     }
659 
660     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
661      * the total supply.
662      *
663      * Emits a {Transfer} event with `from` set to the zero address.
664      *
665      * Requirements:
666      *
667      * - `to` cannot be the zero address.
668      */
669     function _mint(address account, uint256 amount) internal virtual {
670         require(account != address(0), "ERC20: mint to the zero address");
671 
672         _beforeTokenTransfer(address(0), account, amount);
673 
674         _totalSupply += amount;
675         _balances[account] += amount;
676         emit Transfer(address(0), account, amount);
677     }
678 
679     /**
680      * @dev Destroys `amount` tokens from `account`, reducing the
681      * total supply.
682      *
683      * Emits a {Transfer} event with `to` set to the zero address.
684      *
685      * Requirements:
686      *
687      * - `account` cannot be the zero address.
688      * - `account` must have at least `amount` tokens.
689      */
690     function _burn(address account, uint256 amount) internal virtual {
691         require(account != address(0), "ERC20: burn from the zero address");
692 
693         _beforeTokenTransfer(account, address(0), amount);
694 
695         uint256 accountBalance = _balances[account];
696         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
697         _balances[account] = accountBalance - amount;
698         _totalSupply -= amount;
699 
700         emit Transfer(account, address(0), amount);
701     }
702 
703     /**
704      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
705      *
706      * This internal function is equivalent to `approve`, and can be used to
707      * e.g. set automatic allowances for certain subsystems, etc.
708      *
709      * Emits an {Approval} event.
710      *
711      * Requirements:
712      *
713      * - `owner` cannot be the zero address.
714      * - `spender` cannot be the zero address.
715      */
716     function _approve(address owner, address spender, uint256 amount) internal virtual {
717         require(owner != address(0), "ERC20: approve from the zero address");
718         require(spender != address(0), "ERC20: approve to the zero address");
719 
720         _allowances[owner][spender] = amount;
721         emit Approval(owner, spender, amount);
722     }
723 
724     /**
725      * @dev Hook that is called before any transfer of tokens. This includes
726      * minting and burning.
727      *
728      * Calling conditions:
729      *
730      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
731      * will be to transferred to `to`.
732      * - when `from` is zero, `amount` tokens will be minted for `to`.
733      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
734      * - `from` and `to` are never both zero.
735      *
736      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
737      */
738     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
739 }
740 
741 
742 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
743 
744 
745 
746 pragma solidity ^0.8.0;
747 
748 /**
749  * @dev Collection of functions related to the address type
750  */
751 library Address {
752     /**
753      * @dev Returns true if `account` is a contract.
754      *
755      * [IMPORTANT]
756      * ====
757      * It is unsafe to assume that an address for which this function returns
758      * false is an externally-owned account (EOA) and not a contract.
759      *
760      * Among others, `isContract` will return false for the following
761      * types of addresses:
762      *
763      *  - an externally-owned account
764      *  - a contract in construction
765      *  - an address where a contract will be created
766      *  - an address where a contract lived, but was destroyed
767      * ====
768      */
769     function isContract(address account) internal view returns (bool) {
770         // This method relies on extcodesize, which returns 0 for contracts in
771         // construction, since the code is only stored at the end of the
772         // constructor execution.
773 
774         uint256 size;
775         // solhint-disable-next-line no-inline-assembly
776         assembly { size := extcodesize(account) }
777         return size > 0;
778     }
779 
780     /**
781      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
782      * `recipient`, forwarding all available gas and reverting on errors.
783      *
784      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
785      * of certain opcodes, possibly making contracts go over the 2300 gas limit
786      * imposed by `transfer`, making them unable to receive funds via
787      * `transfer`. {sendValue} removes this limitation.
788      *
789      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
790      *
791      * IMPORTANT: because control is transferred to `recipient`, care must be
792      * taken to not create reentrancy vulnerabilities. Consider using
793      * {ReentrancyGuard} or the
794      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
795      */
796     function sendValue(address payable recipient, uint256 amount) internal {
797         require(address(this).balance >= amount, "Address: insufficient balance");
798 
799         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
800         (bool success, ) = recipient.call{ value: amount }("");
801         require(success, "Address: unable to send value, recipient may have reverted");
802     }
803 
804     /**
805      * @dev Performs a Solidity function call using a low level `call`. A
806      * plain`call` is an unsafe replacement for a function call: use this
807      * function instead.
808      *
809      * If `target` reverts with a revert reason, it is bubbled up by this
810      * function (like regular Solidity function calls).
811      *
812      * Returns the raw returned data. To convert to the expected return value,
813      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
814      *
815      * Requirements:
816      *
817      * - `target` must be a contract.
818      * - calling `target` with `data` must not revert.
819      *
820      * _Available since v3.1._
821      */
822     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
823       return functionCall(target, data, "Address: low-level call failed");
824     }
825 
826     /**
827      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
828      * `errorMessage` as a fallback revert reason when `target` reverts.
829      *
830      * _Available since v3.1._
831      */
832     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
833         return functionCallWithValue(target, data, 0, errorMessage);
834     }
835 
836     /**
837      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
838      * but also transferring `value` wei to `target`.
839      *
840      * Requirements:
841      *
842      * - the calling contract must have an ETH balance of at least `value`.
843      * - the called Solidity function must be `payable`.
844      *
845      * _Available since v3.1._
846      */
847     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
848         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
849     }
850 
851     /**
852      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
853      * with `errorMessage` as a fallback revert reason when `target` reverts.
854      *
855      * _Available since v3.1._
856      */
857     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
858         require(address(this).balance >= value, "Address: insufficient balance for call");
859         require(isContract(target), "Address: call to non-contract");
860 
861         // solhint-disable-next-line avoid-low-level-calls
862         (bool success, bytes memory returndata) = target.call{ value: value }(data);
863         return _verifyCallResult(success, returndata, errorMessage);
864     }
865 
866     /**
867      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
868      * but performing a static call.
869      *
870      * _Available since v3.3._
871      */
872     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
873         return functionStaticCall(target, data, "Address: low-level static call failed");
874     }
875 
876     /**
877      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
878      * but performing a static call.
879      *
880      * _Available since v3.3._
881      */
882     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
883         require(isContract(target), "Address: static call to non-contract");
884 
885         // solhint-disable-next-line avoid-low-level-calls
886         (bool success, bytes memory returndata) = target.staticcall(data);
887         return _verifyCallResult(success, returndata, errorMessage);
888     }
889 
890     /**
891      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
892      * but performing a delegate call.
893      *
894      * _Available since v3.4._
895      */
896     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
897         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
898     }
899 
900     /**
901      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
902      * but performing a delegate call.
903      *
904      * _Available since v3.4._
905      */
906     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
907         require(isContract(target), "Address: delegate call to non-contract");
908 
909         // solhint-disable-next-line avoid-low-level-calls
910         (bool success, bytes memory returndata) = target.delegatecall(data);
911         return _verifyCallResult(success, returndata, errorMessage);
912     }
913 
914     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
915         if (success) {
916             return returndata;
917         } else {
918             // Look for revert reason and bubble it up if present
919             if (returndata.length > 0) {
920                 // The easiest way to bubble the revert reason is using memory via assembly
921 
922                 // solhint-disable-next-line no-inline-assembly
923                 assembly {
924                     let returndata_size := mload(returndata)
925                     revert(add(32, returndata), returndata_size)
926                 }
927             } else {
928                 revert(errorMessage);
929             }
930         }
931     }
932 }
933 
934 
935 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.1.0
936 
937 
938 
939 pragma solidity ^0.8.0;
940 
941 
942 /**
943  * @title SafeERC20
944  * @dev Wrappers around ERC20 operations that throw on failure (when the token
945  * contract returns false). Tokens that return no value (and instead revert or
946  * throw on failure) are also supported, non-reverting calls are assumed to be
947  * successful.
948  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
949  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
950  */
951 library SafeERC20 {
952     using Address for address;
953 
954     function safeTransfer(IERC20 token, address to, uint256 value) internal {
955         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
956     }
957 
958     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
959         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
960     }
961 
962     /**
963      * @dev Deprecated. This function has issues similar to the ones found in
964      * {IERC20-approve}, and its usage is discouraged.
965      *
966      * Whenever possible, use {safeIncreaseAllowance} and
967      * {safeDecreaseAllowance} instead.
968      */
969     function safeApprove(IERC20 token, address spender, uint256 value) internal {
970         // safeApprove should only be called when setting an initial allowance,
971         // or when resetting it to zero. To increase and decrease it, use
972         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
973         // solhint-disable-next-line max-line-length
974         require((value == 0) || (token.allowance(address(this), spender) == 0),
975             "SafeERC20: approve from non-zero to non-zero allowance"
976         );
977         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
978     }
979 
980     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
981         uint256 newAllowance = token.allowance(address(this), spender) + value;
982         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
983     }
984 
985     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
986         unchecked {
987             uint256 oldAllowance = token.allowance(address(this), spender);
988             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
989             uint256 newAllowance = oldAllowance - value;
990             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
991         }
992     }
993 
994     /**
995      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
996      * on the return value: the return value is optional (but if data is returned, it must not be false).
997      * @param token The token targeted by the call.
998      * @param data The call data (encoded using abi.encode or one of its variants).
999      */
1000     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1001         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1002         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1003         // the target address contains contract code and also asserts for success in the low-level call.
1004 
1005         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1006         if (returndata.length > 0) { // Return data is optional
1007             // solhint-disable-next-line max-line-length
1008             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1009         }
1010     }
1011 }
1012 
1013 
1014 // File contracts/interfaces/IUniswapRouter01.sol
1015 
1016 
1017 pragma solidity >=0.8.0;
1018 
1019 interface IUniswapV2Router01 {
1020     function factory() external pure returns (address);
1021 
1022     function WETH() external pure returns (address);
1023 
1024     function addLiquidity(
1025         address tokenA,
1026         address tokenB,
1027         uint256 amountADesired,
1028         uint256 amountBDesired,
1029         uint256 amountAMin,
1030         uint256 amountBMin,
1031         address to,
1032         uint256 deadline
1033     )
1034         external
1035         returns (
1036             uint256 amountA,
1037             uint256 amountB,
1038             uint256 liquidity
1039         );
1040 
1041     function addLiquidityETH(
1042         address token,
1043         uint256 amountTokenDesired,
1044         uint256 amountTokenMin,
1045         uint256 amountETHMin,
1046         address to,
1047         uint256 deadline
1048     )
1049         external
1050         payable
1051         returns (
1052             uint256 amountToken,
1053             uint256 amountETH,
1054             uint256 liquidity
1055         );
1056 
1057     function removeLiquidity(
1058         address tokenA,
1059         address tokenB,
1060         uint256 liquidity,
1061         uint256 amountAMin,
1062         uint256 amountBMin,
1063         address to,
1064         uint256 deadline
1065     ) external returns (uint256 amountA, uint256 amountB);
1066 
1067     function removeLiquidityETH(
1068         address token,
1069         uint256 liquidity,
1070         uint256 amountTokenMin,
1071         uint256 amountETHMin,
1072         address to,
1073         uint256 deadline
1074     ) external returns (uint256 amountToken, uint256 amountETH);
1075 
1076     function removeLiquidityWithPermit(
1077         address tokenA,
1078         address tokenB,
1079         uint256 liquidity,
1080         uint256 amountAMin,
1081         uint256 amountBMin,
1082         address to,
1083         uint256 deadline,
1084         bool approveMax,
1085         uint8 v,
1086         bytes32 r,
1087         bytes32 s
1088     ) external returns (uint256 amountA, uint256 amountB);
1089 
1090     function removeLiquidityETHWithPermit(
1091         address token,
1092         uint256 liquidity,
1093         uint256 amountTokenMin,
1094         uint256 amountETHMin,
1095         address to,
1096         uint256 deadline,
1097         bool approveMax,
1098         uint8 v,
1099         bytes32 r,
1100         bytes32 s
1101     ) external returns (uint256 amountToken, uint256 amountETH);
1102 
1103     function swapExactTokensForTokens(
1104         uint256 amountIn,
1105         uint256 amountOutMin,
1106         address[] calldata path,
1107         address to,
1108         uint256 deadline
1109     ) external returns (uint256[] memory amounts);
1110 
1111     function swapTokensForExactTokens(
1112         uint256 amountOut,
1113         uint256 amountInMax,
1114         address[] calldata path,
1115         address to,
1116         uint256 deadline
1117     ) external returns (uint256[] memory amounts);
1118 
1119     function swapExactETHForTokens(
1120         uint256 amountOutMin,
1121         address[] calldata path,
1122         address to,
1123         uint256 deadline
1124     ) external payable returns (uint256[] memory amounts);
1125 
1126     function swapTokensForExactETH(
1127         uint256 amountOut,
1128         uint256 amountInMax,
1129         address[] calldata path,
1130         address to,
1131         uint256 deadline
1132     ) external returns (uint256[] memory amounts);
1133 
1134     function swapExactTokensForETH(
1135         uint256 amountIn,
1136         uint256 amountOutMin,
1137         address[] calldata path,
1138         address to,
1139         uint256 deadline
1140     ) external returns (uint256[] memory amounts);
1141 
1142     function swapETHForExactTokens(
1143         uint256 amountOut,
1144         address[] calldata path,
1145         address to,
1146         uint256 deadline
1147     ) external payable returns (uint256[] memory amounts);
1148 
1149     function quote(
1150         uint256 amountA,
1151         uint256 reserveA,
1152         uint256 reserveB
1153     ) external pure returns (uint256 amountB);
1154 
1155     function getAmountOut(
1156         uint256 amountIn,
1157         uint256 reserveIn,
1158         uint256 reserveOut
1159     ) external pure returns (uint256 amountOut);
1160 
1161     function getAmountIn(
1162         uint256 amountOut,
1163         uint256 reserveIn,
1164         uint256 reserveOut
1165     ) external pure returns (uint256 amountIn);
1166 
1167     function getAmountsOut(uint256 amountIn, address[] calldata path)
1168         external
1169         view
1170         returns (uint256[] memory amounts);
1171 
1172     function getAmountsIn(uint256 amountOut, address[] calldata path)
1173         external
1174         view
1175         returns (uint256[] memory amounts);
1176 }
1177 
1178 
1179 // File contracts/interfaces/IUniswapRouter02.sol
1180 
1181 
1182 pragma solidity >=0.8.0;
1183 interface IUniswapV2Router02 is IUniswapV2Router01 {
1184     function removeLiquidityETHSupportingFeeOnTransferTokens(
1185         address token,
1186         uint256 liquidity,
1187         uint256 amountTokenMin,
1188         uint256 amountETHMin,
1189         address to,
1190         uint256 deadline
1191     ) external returns (uint256 amountETH);
1192 
1193     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1194         address token,
1195         uint256 liquidity,
1196         uint256 amountTokenMin,
1197         uint256 amountETHMin,
1198         address to,
1199         uint256 deadline,
1200         bool approveMax,
1201         uint8 v,
1202         bytes32 r,
1203         bytes32 s
1204     ) external returns (uint256 amountETH);
1205 
1206     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1207         uint256 amountIn,
1208         uint256 amountOutMin,
1209         address[] calldata path,
1210         address to,
1211         uint256 deadline
1212     ) external;
1213 
1214     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1215         uint256 amountOutMin,
1216         address[] calldata path,
1217         address to,
1218         uint256 deadline
1219     ) external payable;
1220 
1221     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1222         uint256 amountIn,
1223         uint256 amountOutMin,
1224         address[] calldata path,
1225         address to,
1226         uint256 deadline
1227     ) external;
1228 }
1229 
1230 
1231 // File contracts/interfaces/IUniswapV2Factory.sol
1232 
1233 
1234 pragma solidity >=0.8.0;
1235 
1236 interface IUniswapV2Factory {
1237     event PairCreated(
1238         address indexed token0,
1239         address indexed token1,
1240         address pair,
1241         uint256
1242     );
1243 
1244     function feeTo() external view returns (address);
1245 
1246     function feeToSetter() external view returns (address);
1247 
1248     function getPair(address tokenA, address tokenB)
1249         external
1250         view
1251         returns (address pair);
1252 
1253     function allPairs(uint256) external view returns (address pair);
1254 
1255     function allPairsLength() external view returns (uint256);
1256 
1257     function createPair(address tokenA, address tokenB)
1258         external
1259         returns (address pair);
1260 
1261     function setReflectionFeeTo(address) external;
1262 
1263     function setReflectionFeeToSetter(address) external;
1264 }
1265 
1266 
1267 // File contracts/EarnableFi.sol
1268 
1269 
1270 pragma solidity >=0.8.0;
1271 
1272 contract BetDao is ERC20('BetDao', 'BDAO'), Ownable {
1273     using SafeMath for uint256;
1274     using SafeERC20 for IERC20;
1275 
1276     uint256 constant public MAX_SUPPLY = 10000000000 * 1e18;  // 10B max supply
1277 
1278     uint16 private MAX_BP_RATE = 10000;
1279 
1280     uint16 private buyDevTaxRate = 400;
1281     uint16 private buyMarketingTaxRate = 500;
1282     uint16 private buyTreasuryTaxRate = 300;
1283     uint16 private sellDevTaxRate = 500;
1284     uint16 private sellMarketingTaxRate = 700;
1285     uint16 private sellTreasuryTaxRate = 300;
1286     uint16 private maxTransferAmountRate = 100;
1287     uint16 private maxWalletAmountRate = 200;
1288 
1289     uint256 private minAmountToSwap = 500000000 * 1e18;    // 5% of total supply
1290 
1291     IUniswapV2Router02 public uniswapRouter;
1292     // The trading pair
1293     address public uniswapPair;
1294 
1295     address public marketingWallet = 0x6DaF5d67515d10cbEccc64A7A9A0630d280fE731;
1296     address public devWallet = 0x9b719777917C6a0c17A11305a12928ad642f8cc8;
1297     address public treasury = 0x2CE60975421d6701Dda959813B8e09F6743Ab3B1;
1298 
1299     mapping(address => bool) public bots;
1300 
1301     // In swap and withdraw
1302     bool private _inSwapAndWithdraw;
1303     // The operator can only update the transfer tax rate
1304     address private _operator;
1305     // Automatic swap and liquify enabled
1306     bool public swapAndWithdrawEnabled = false;
1307 
1308     mapping(address => bool) private _isExcludedFromFee;
1309     mapping(address => bool) private _isExcludedFromMaxTx;
1310     mapping(address => bool) private _isExcludedFromSwap;
1311 
1312     bool private _tradingOpen = false;
1313 
1314     modifier onlyOperator() {
1315         require(_operator == msg.sender, "!operator");
1316         _;
1317     }
1318 
1319     modifier lockTheSwap {
1320         _inSwapAndWithdraw = true;
1321         _;
1322         _inSwapAndWithdraw = false;
1323     }
1324 
1325     constructor() public {
1326         _operator = msg.sender;
1327         _mint(msg.sender, MAX_SUPPLY);
1328 
1329         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1330             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1331         );
1332         // Create a uniswap pair for this new token
1333         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
1334             .createPair(address(this), _uniswapV2Router.WETH());
1335 
1336         // set the rest of the contract variables
1337         uniswapRouter = _uniswapV2Router;
1338 
1339         _isExcludedFromFee[address(this)] = true;
1340         _isExcludedFromFee[msg.sender] = true;
1341         _isExcludedFromMaxTx[address(this)] = true;
1342         _isExcludedFromMaxTx[msg.sender] = true;
1343 
1344         bots[0xB53F1c0Aa7E8A0Ad32222a03fc763FEc87d86dEb] = true;
1345         bots[0x7Bc711E58c3927553dE062BcDB1e606E14548F19] = true;
1346         bots[0xF833C3ECf262Ccc97924925CA577Cd0AC2aac82a] = true;
1347         bots[0xAd808511eeBba7154B9FD9EfEB8b5f3A68b1284c] = true;
1348         bots[0x516a1e0A2e46ee5d6DF66aC0a16ff6Cba4a7EB4e] = true;
1349         bots[0xBE8ff2CE7b04698B92D63782c6520b91EC3a5574] = true;
1350         bots[0xD239d33856c0Cf96AC0686D803ec03Cda13B4A97] = true;
1351         bots[0x8D36e3F8250C3b9FAFc1D05991F0cE951CbD1145] = true;
1352         bots[0xE82eC3834952135901f0E904FEd9051d2710139e] = true;
1353         bots[0xe5C2f0cDb5Ac04AdDEB5524c419662D5D8D634a6] = true;
1354         bots[0xefBe8583F8E16dbBa53C2CE5A5C5529cfA3382e7] = true;
1355         bots[0x7905eA4442c303F1F2f88878927FEA43Ca8eE07A] = true;
1356         bots[0x9D8CF88ceD8d7BA4E1c8aD83e5cF682A063230b3] = true;
1357         bots[0xDE130FD31564814B8F104FdEB8DD65aE68909448] = true;
1358         bots[0xAD9A35D9B4C256ee79bDd022189D18c4426D3d53] = true;
1359         bots[0x6a489f88FAe23A703bC6853Efd4A6CC51C8294A2] = true;
1360         bots[0xECD6f9d7aAD98149B2a7619cb58556eC1a043c30] = true;
1361         bots[0x47584f11A998C19dDa33d8cA4002FBe892aC899b] = true;
1362         bots[0xB88De44e7895B241C4d57122ad4893f01eCB8976] = true;
1363         bots[0x27426D898ef9dE4EB1Bb5e2e4130858b83DB315a] = true;
1364         bots[0x85234e4766ACe3E0f5046c47b610E5eb4f37Fbe8] = true;
1365         bots[0x2f36BB7dF9dE6611aE7fDB780Bf6B987aCA173B5] = true;
1366         bots[0x9c29788b1aF93fB2262cA696775dbFfD05f7Cc0B] = true;
1367         bots[0x1AB4cF630221CEf45f7Cc3c6121d41d4d3aa5eaF] = true;
1368         bots[0x9074066e874A57ECcacc9290455bB5ea5543F1f1] = true;
1369         bots[0x2228476AC5242e38d5864068B8c6aB61d6bA2222] = true;
1370         bots[0x07f73aa38f2d74c19E9C48467E2B614428c2F341] = true;
1371         bots[0x4Fe2117D5390D752DDB8765a228E5641779E315B] = true;
1372         bots[0x1111592c55c9385B32d76C259947f38673Cb715a] = true;
1373         bots[0x3c1f60B578F3AaF06EDb594FAE223cB2AaA5bfD1] = true;
1374         bots[0x97DA67882b3F727c2fab876660785a6fba3fb3B5] = true;
1375     }
1376 
1377     /**
1378      * @dev Returns the address of the current operator.
1379      */
1380     function operator() public view returns (address) {
1381         return _operator;
1382     }
1383 
1384     function _transfer(address _sender, address _recepient, uint256 _amount) internal override {
1385         if (!_tradingOpen && _sender != owner() && _recepient != owner() && _sender != address(uniswapRouter)) {
1386             // registering bot
1387             bots[_sender] = true;
1388         }
1389         // require(_tradingOpen || _sender == owner() || _recepient == owner() || _sender == address(uniswapRouter), "!tradable");
1390         require(!bots[_sender] && !bots[_recepient], 'BetDao[_transfer]: blacklisted address');
1391 
1392         // swap and withdraw
1393         if (
1394             swapAndWithdrawEnabled == true
1395             && _inSwapAndWithdraw == false
1396             && address(uniswapRouter) != address(0)
1397             && uniswapPair != address(0)
1398             && _sender != uniswapPair
1399             && _sender != address(uniswapRouter)
1400             && _sender != owner()
1401             && _sender != address(this)
1402             && !_isExcludedFromSwap[_sender]
1403             && !_isExcludedFromSwap[_recepient]
1404         ) {
1405             swapAndWithdraw();
1406         }
1407 
1408         if (!_isExcludedFromMaxTx[_sender]) {
1409             require(_amount <= maxTransferAmount(), 'BetDao[_transfer]: exceed max tx amount');
1410         }
1411         if (!_isExcludedFromMaxTx[_recepient]) {
1412             if (_recepient != uniswapPair && _recepient != address(uniswapRouter)) {
1413                 require(balanceOf(_recepient).add(_amount) <= maxWalletAmount(), 'BetDao[_transfer]: exceed max wallet amount');
1414             }
1415         }
1416 
1417         if (_isExcludedFromFee[_sender]) {
1418             super._transfer(_sender, _recepient, _amount);
1419         } else {
1420             if (_sender == uniswapPair) {   // if buy transaction
1421                 uint256 devFee = _amount.mul(buyDevTaxRate).div(MAX_BP_RATE);
1422                 uint256 marketingFee = _amount.mul(buyMarketingTaxRate).div(MAX_BP_RATE);
1423                 uint256 treasuryFee = _amount.mul(buyTreasuryTaxRate).div(MAX_BP_RATE);
1424                 _amount = _amount.sub(devFee.add(marketingFee).add(treasuryFee));
1425 
1426                 super._transfer(_sender, _recepient, _amount);
1427                 super._transfer(_sender, address(this), devFee.add(marketingFee).add(treasuryFee));
1428             } else {    // if sell transaction
1429                 uint256 devFee = _amount.mul(sellDevTaxRate).div(MAX_BP_RATE);
1430                 uint256 marketingFee = _amount.mul(sellMarketingTaxRate).div(MAX_BP_RATE);
1431                 uint256 treasuryFee = _amount.mul(sellTreasuryTaxRate).div(MAX_BP_RATE);
1432                 _amount = _amount.sub(devFee.add(marketingFee).add(treasuryFee));
1433 
1434                 super._transfer(_sender, _recepient, _amount);
1435                 super._transfer(_sender, address(this), devFee.add(marketingFee).add(treasuryFee));
1436             }
1437         }
1438     }
1439 
1440     /**
1441      * @dev Transfers operator of the contract to a new account (`newOperator`).
1442      * Can only be called by the current operator.
1443      */
1444     function transferOperator(address newOperator) public onlyOperator {
1445         require(newOperator != address(0));
1446         _operator = newOperator;
1447     }
1448 
1449     /**
1450      * @dev Update the swapAndWithdrawEnabled.
1451      * Can only be called by the current operator.
1452      */
1453     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOperator {
1454         swapAndWithdrawEnabled = _enabled;
1455     }
1456 
1457     function manualSwap() external onlyOperator {
1458         swapAndWithdraw();
1459     }
1460 
1461     function manualWithdraw() external onlyOperator {
1462         uint256 bal = address(this).balance;
1463         payable(devWallet).transfer(bal);   // 2300 gas limit
1464     }
1465 
1466     /// @dev Swap and liquify
1467     function swapAndWithdraw() private lockTheSwap {
1468         uint256 contractTokenBalance = balanceOf(address(this));
1469         // swap tokens for ETH
1470         swapTokensForEth(contractTokenBalance);
1471 
1472         uint256 bal = address(this).balance;
1473         uint totalTxRate = sellDevTaxRate + sellMarketingTaxRate + sellTreasuryTaxRate;
1474         uint devShare = bal.mul(sellDevTaxRate).div(totalTxRate);
1475         uint marketingShare = bal.mul(sellMarketingTaxRate).div(totalTxRate);
1476         uint treasuryShare = bal.mul(sellTreasuryTaxRate).div(totalTxRate);
1477 
1478         require(devShare + marketingShare + treasuryShare <= bal, 'BetDao[swapAndWithdraw]: dividends error');
1479 
1480         payable(devWallet).transfer(devShare);
1481         payable(marketingWallet).transfer(marketingShare);
1482         payable(treasury).transfer(treasuryShare);
1483     }
1484 
1485     /// @dev Swap tokens for eth
1486     function swapTokensForEth(uint256 tokenAmount) private {
1487         // generate the pantherSwap pair path of token -> weth
1488         address[] memory path = new address[](2);
1489         path[0] = address(this);
1490         path[1] = uniswapRouter.WETH();
1491 
1492         _approve(address(this), address(uniswapRouter), tokenAmount);
1493 
1494         // make the swap
1495         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1496             tokenAmount,
1497             0, // accept any amount of ETH
1498             path,
1499             address(this),
1500             block.timestamp + 1 days
1501         );
1502     }
1503 
1504     /**
1505      * @dev Returns the max transfer amount.
1506      */
1507     function maxTransferAmount() public view returns (uint256) {
1508         return totalSupply().mul(maxTransferAmountRate).div(MAX_BP_RATE);
1509     }
1510 
1511     /**
1512      * @dev Returns the max wallet amount.
1513      */
1514     function maxWalletAmount() public view returns (uint256) {
1515         return totalSupply().mul(maxWalletAmountRate).div(MAX_BP_RATE);
1516     }
1517 
1518     function updateSellFees(uint16 _sellDevTaxRate, uint16 _sellMarketingTaxRate, uint16 _sellTreasuryTaxRate) external onlyOperator {
1519         require(_sellDevTaxRate + _sellMarketingTaxRate + _sellTreasuryTaxRate <= 2000, 'BetDao[updateSellFees]: wrong values');   // must not exceed 20% as max
1520         sellDevTaxRate = _sellDevTaxRate;
1521         sellMarketingTaxRate = _sellMarketingTaxRate;
1522         sellTreasuryTaxRate = _sellTreasuryTaxRate;
1523     }
1524 
1525     function updateBuyFees(uint16 _buyDevTaxRate, uint16 _buyMarketingTaxRate, uint16 _buyTreasuryTaxRate) external onlyOperator {
1526         require(_buyDevTaxRate + _buyMarketingTaxRate + _buyTreasuryTaxRate <= 2000, 'BetDao[updateBuyFees]: wrong values');   // must not exceed 20% as max
1527         buyDevTaxRate = _buyDevTaxRate;
1528         buyMarketingTaxRate = _buyMarketingTaxRate;
1529         buyTreasuryTaxRate = _buyTreasuryTaxRate;
1530     }
1531 
1532     function setMaxTransferAmountRate(uint16 _maxTransferAmountRate) external onlyOperator {
1533         require(_maxTransferAmountRate >= 100, 'BetDao[setMaxTransferAmountRate]: !max_amount');
1534         maxTransferAmountRate = _maxTransferAmountRate;
1535     }
1536 
1537     function setMaxWalletAmountRate(uint16 _maxWalletAmountRate) external onlyOperator {
1538         require(_maxWalletAmountRate >= 200, 'BetDao[setMaxWalletAmountRate]: !max_wallet');
1539         maxWalletAmountRate = _maxWalletAmountRate;
1540     }
1541 
1542     function setMinAmountToSwap(uint256 _minAmountToSwapRateBP) external onlyOperator {
1543         minAmountToSwap = totalSupply().mul(_minAmountToSwapRateBP).div(MAX_BP_RATE);
1544     }
1545 
1546     function openTrading() external onlyOwner {
1547         _tradingOpen = true;
1548         swapAndWithdrawEnabled = true;
1549         maxTransferAmountRate = 100;
1550         maxWalletAmountRate = 200;
1551     }
1552 
1553     function isExcludedFromFee(address _addr) external view returns (bool) {
1554         return _isExcludedFromFee[_addr];
1555     }
1556 
1557     function excludeFromFee(address _addr, bool _is) external onlyOperator {
1558         _isExcludedFromFee[_addr] = _is;
1559     }
1560 
1561     function isExcludedFromMaxTx(address _addr) external view returns (bool) {
1562         return _isExcludedFromMaxTx[_addr];
1563     }
1564 
1565     function excludeFromMaxTx(address _addr, bool _is) external onlyOperator {
1566         _isExcludedFromMaxTx[_addr] = _is;
1567     }
1568 
1569     function isExludedFromSwap(address _addr) external view returns (bool) {
1570         return _isExcludedFromSwap[_addr];
1571     }
1572 
1573     function excludeFromSwap(address _addr, bool _is) external onlyOperator {
1574         _isExcludedFromMaxTx[_addr] = _is;
1575     }
1576 
1577     function updateMarketingWallet(address _marketingWallet) external onlyOperator {
1578         marketingWallet = _marketingWallet;
1579     }
1580 
1581     function updateDevWallet(address _devWallet) external onlyOperator {
1582         devWallet = _devWallet;
1583     }
1584 
1585     function updateTreasury(address _treasury) external onlyOperator {
1586         treasury = _treasury;
1587     }
1588 
1589     function setBots(address[] memory _bots) external onlyOperator {
1590         for (uint16 i = 0; i < _bots.length; i++) {
1591             if (_bots[i] != uniswapPair && _bots[i] != address(uniswapRouter)) {
1592                 bots[_bots[i]] = true;
1593             }
1594         }
1595     }
1596 
1597     function delBots(address[] memory _bots) external onlyOperator {
1598         for (uint16 i = 0; i < _bots.length; i++) {
1599             bots[_bots[i]] = false;
1600         }
1601     }
1602 
1603     mapping (address => address) internal _delegates;
1604 
1605     /// @notice A checkpoint for marking number of votes from a given block
1606     struct Checkpoint {
1607         uint32 fromBlock;
1608         uint256 votes;
1609     }
1610 
1611     /// @notice A record of votes checkpoints for each account, by index
1612     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1613 
1614     /// @notice The number of checkpoints for each account
1615     mapping (address => uint32) public numCheckpoints;
1616 
1617     /// @notice The EIP-712 typehash for the contract's domain
1618     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1619 
1620     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1621     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1622 
1623     /// @notice A record of states for signing / validating signatures
1624     mapping (address => uint) public nonces;
1625 
1626       /// @notice An event thats emitted when an account changes its delegate
1627     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1628 
1629     /// @notice An event thats emitted when a delegate account's vote balance changes
1630     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1631 
1632     /**
1633      * @notice Delegate votes from `msg.sender` to `delegatee`
1634      * @param delegator The address to get delegatee for
1635      */
1636     function delegates(address delegator)
1637         external
1638         view
1639         returns (address)
1640     {
1641         return _delegates[delegator];
1642     }
1643 
1644    /**
1645     * @notice Delegate votes from `msg.sender` to `delegatee`
1646     * @param delegatee The address to delegate votes to
1647     */
1648     function delegate(address delegatee) external {
1649         return _delegate(msg.sender, delegatee);
1650     }
1651 
1652     /**
1653      * @notice Delegates votes from signatory to `delegatee`
1654      * @param delegatee The address to delegate votes to
1655      * @param nonce The contract state required to match the signature
1656      * @param expiry The time at which to expire the signature
1657      * @param v The recovery byte of the signature
1658      * @param r Half of the ECDSA signature pair
1659      * @param s Half of the ECDSA signature pair
1660      */
1661     function delegateBySig(
1662         address delegatee,
1663         uint nonce,
1664         uint expiry,
1665         uint8 v,
1666         bytes32 r,
1667         bytes32 s
1668     )
1669         external
1670     {
1671         bytes32 domainSeparator = keccak256(
1672             abi.encode(
1673                 DOMAIN_TYPEHASH,
1674                 keccak256(bytes(name())),
1675                 getChainId(),
1676                 address(this)
1677             )
1678         );
1679 
1680         bytes32 structHash = keccak256(
1681             abi.encode(
1682                 DELEGATION_TYPEHASH,
1683                 delegatee,
1684                 nonce,
1685                 expiry
1686             )
1687         );
1688 
1689         bytes32 digest = keccak256(
1690             abi.encodePacked(
1691                 "\x19\x01",
1692                 domainSeparator,
1693                 structHash
1694             )
1695         );
1696 
1697         address signatory = ecrecover(digest, v, r, s);
1698         require(signatory != address(0), "MARS::delegateBySig: invalid signature");
1699         require(nonce == nonces[signatory]++, "MARS::delegateBySig: invalid nonce");
1700         require(block.timestamp <= expiry, "MARS::delegateBySig: signature expired");
1701         return _delegate(signatory, delegatee);
1702     }
1703 
1704     /**
1705      * @notice Gets the current votes balance for `account`
1706      * @param account The address to get votes balance
1707      * @return The number of current votes for `account`
1708      */
1709     function getCurrentVotes(address account)
1710         external
1711         view
1712         returns (uint256)
1713     {
1714         uint32 nCheckpoints = numCheckpoints[account];
1715         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1716     }
1717 
1718     /**
1719      * @notice Determine the prior number of votes for an account as of a block number
1720      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1721      * @param account The address of the account to check
1722      * @param blockNumber The block number to get the vote balance at
1723      * @return The number of votes the account had as of the given block
1724      */
1725     function getPriorVotes(address account, uint blockNumber)
1726         external
1727         view
1728         returns (uint256)
1729     {
1730         require(blockNumber < block.number, "MARS::getPriorVotes: not yet determined");
1731 
1732         uint32 nCheckpoints = numCheckpoints[account];
1733         if (nCheckpoints == 0) {
1734             return 0;
1735         }
1736 
1737         // First check most recent balance
1738         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1739             return checkpoints[account][nCheckpoints - 1].votes;
1740         }
1741 
1742         // Next check implicit zero balance
1743         if (checkpoints[account][0].fromBlock > blockNumber) {
1744             return 0;
1745         }
1746 
1747         uint32 lower = 0;
1748         uint32 upper = nCheckpoints - 1;
1749         while (upper > lower) {
1750             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1751             Checkpoint memory cp = checkpoints[account][center];
1752             if (cp.fromBlock == blockNumber) {
1753                 return cp.votes;
1754             } else if (cp.fromBlock < blockNumber) {
1755                 lower = center;
1756             } else {
1757                 upper = center - 1;
1758             }
1759         }
1760         return checkpoints[account][lower].votes;
1761     }
1762 
1763     function _delegate(address delegator, address delegatee)
1764         internal
1765     {
1766         address currentDelegate = _delegates[delegator];
1767         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MARSs (not scaled);
1768         _delegates[delegator] = delegatee;
1769 
1770         emit DelegateChanged(delegator, currentDelegate, delegatee);
1771 
1772         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1773     }
1774 
1775     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1776         if (srcRep != dstRep && amount > 0) {
1777             if (srcRep != address(0)) {
1778                 // decrease old representative
1779                 uint32 srcRepNum = numCheckpoints[srcRep];
1780                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1781                 uint256 srcRepNew = srcRepOld.sub(amount);
1782                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1783             }
1784 
1785             if (dstRep != address(0)) {
1786                 // increase new representative
1787                 uint32 dstRepNum = numCheckpoints[dstRep];
1788                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1789                 uint256 dstRepNew = dstRepOld.add(amount);
1790                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1791             }
1792         }
1793     }
1794 
1795     function _writeCheckpoint(
1796         address delegatee,
1797         uint32 nCheckpoints,
1798         uint256 oldVotes,
1799         uint256 newVotes
1800     )
1801         internal
1802     {
1803         uint32 blockNumber = safe32(block.number, "MARS::_writeCheckpoint: block number exceeds 32 bits");
1804 
1805         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1806             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1807         } else {
1808             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1809             numCheckpoints[delegatee] = nCheckpoints + 1;
1810         }
1811 
1812         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1813     }
1814 
1815     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1816         require(n < 2**32, errorMessage);
1817         return uint32(n);
1818     }
1819 
1820     function getChainId() internal view returns (uint) {
1821         uint256 chainId;
1822         assembly { chainId := chainid() }
1823         return chainId;
1824     }
1825 
1826     //to recieve ETH from uniswapV2Router when swaping
1827     receive() external payable {
1828     }
1829 }