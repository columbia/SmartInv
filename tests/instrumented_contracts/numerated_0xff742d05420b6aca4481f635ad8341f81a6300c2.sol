1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 
83 /**
84  * @dev Interface for the optional metadata functions from the ERC20 standard.
85  *
86  * _Available since v4.1._
87  */
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 
105 
106 
107 /*
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  *
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 abstract contract Context {
118     function _msgSender() internal view virtual returns (address) {
119         return msg.sender;
120     }
121 
122     function _msgData() internal view virtual returns (bytes calldata) {
123         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
124         return msg.data;
125     }
126 }
127 
128 
129 // CAUTION
130 // This version of SafeMath should only be used with Solidity 0.8 or later,
131 // because it relies on the compiler's built in overflow checks.
132 
133 /**
134  * @dev Wrappers over Solidity's arithmetic operations.
135  *
136  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
137  * now has built in overflow checking.
138  */
139 library SafeMath {
140     /**
141      * @dev Returns the addition of two unsigned integers, with an overflow flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             uint256 c = a + b;
148             if (c < a) return (false, 0);
149             return (true, c);
150         }
151     }
152 
153     /**
154      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         unchecked {
160             if (b > a) return (false, 0);
161             return (true, a - b);
162         }
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
167      *
168      * _Available since v3.4._
169      */
170     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
171         unchecked {
172             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173             // benefit is lost if 'b' is also tested.
174             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175             if (a == 0) return (true, 0);
176             uint256 c = a * b;
177             if (c / a != b) return (false, 0);
178             return (true, c);
179         }
180     }
181 
182     /**
183      * @dev Returns the division of two unsigned integers, with a division by zero flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
188         unchecked {
189             if (b == 0) return (false, 0);
190             return (true, a / b);
191         }
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
196      *
197      * _Available since v3.4._
198      */
199     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
200         unchecked {
201             if (b == 0) return (false, 0);
202             return (true, a % b);
203         }
204     }
205 
206     /**
207      * @dev Returns the addition of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `+` operator.
211      *
212      * Requirements:
213      *
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         return a + b;
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting on
222      * overflow (when the result is negative).
223      *
224      * Counterpart to Solidity's `-` operator.
225      *
226      * Requirements:
227      *
228      * - Subtraction cannot overflow.
229      */
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         return a - b;
232     }
233 
234     /**
235      * @dev Returns the multiplication of two unsigned integers, reverting on
236      * overflow.
237      *
238      * Counterpart to Solidity's `*` operator.
239      *
240      * Requirements:
241      *
242      * - Multiplication cannot overflow.
243      */
244     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245         return a * b;
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers, reverting on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator.
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function div(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a / b;
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * reverting when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a % b;
276     }
277 
278     /**
279      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
280      * overflow (when the result is negative).
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {trySub}.
284      *
285      * Counterpart to Solidity's `-` operator.
286      *
287      * Requirements:
288      *
289      * - Subtraction cannot overflow.
290      */
291     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         unchecked {
293             require(b <= a, errorMessage);
294             return a - b;
295         }
296     }
297 
298     /**
299      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
300      * division by zero. The result is rounded towards zero.
301      *
302      * Counterpart to Solidity's `%` operator. This function uses a `revert`
303      * opcode (which leaves remaining gas untouched) while Solidity uses an
304      * invalid opcode to revert (consuming all remaining gas).
305      *
306      * Counterpart to Solidity's `/` operator. Note: this function uses a
307      * `revert` opcode (which leaves remaining gas untouched) while Solidity
308      * uses an invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
315         unchecked {
316             require(b > 0, errorMessage);
317             return a / b;
318         }
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * reverting with custom message when dividing by zero.
324      *
325      * CAUTION: This function is deprecated because it requires allocating memory for the error
326      * message unnecessarily. For custom revert reasons use {tryMod}.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      *
334      * - The divisor cannot be zero.
335      */
336     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         unchecked {
338             require(b > 0, errorMessage);
339             return a % b;
340         }
341     }
342 }
343 
344 
345 /**
346  * @dev Contract module which provides a basic access control mechanism, where
347  * there is an account (an owner) that can be granted exclusive access to
348  * specific functions.
349  *
350  * By default, the owner account will be the one that deploys the contract. This
351  * can later be changed with {transferOwnership}.
352  *
353  * This module is used through inheritance. It will make available the modifier
354  * `onlyOwner`, which can be applied to your functions to restrict their use to
355  * the owner.
356  */
357 abstract contract Ownable is Context {
358     address private _owner;
359 
360     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
361 
362     /**
363      * @dev Initializes the contract setting the deployer as the initial owner.
364      */
365     constructor () {
366         address msgSender = _msgSender();
367         _owner = msgSender;
368         emit OwnershipTransferred(address(0), msgSender);
369     }
370 
371     /**
372      * @dev Returns the address of the current owner.
373      */
374     function owner() public view virtual returns (address) {
375         return _owner;
376     }
377 
378     /**
379      * @dev Throws if called by any account other than the owner.
380      */
381     modifier onlyOwner() {
382         require(owner() == _msgSender(), "Ownable: caller is not the owner");
383         _;
384     }
385 
386     /**
387      * @dev Leaves the contract without owner. It will not be possible to call
388      * `onlyOwner` functions anymore. Can only be called by the current owner.
389      *
390      * NOTE: Renouncing ownership will leave the contract without an owner,
391      * thereby removing any functionality that is only available to the owner.
392      */
393     function renounceOwnership() public virtual onlyOwner {
394         emit OwnershipTransferred(_owner, address(0));
395         _owner = address(0);
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Can only be called by the current owner.
401      */
402     function transferOwnership(address newOwner) public virtual onlyOwner {
403         require(newOwner != address(0), "Ownable: new owner is the zero address");
404         emit OwnershipTransferred(_owner, newOwner);
405         _owner = newOwner;
406     }
407 }
408 
409 
410 /**
411  * @dev Implementation of the {IERC20} interface.
412  *
413  * This implementation is agnostic to the way tokens are created. This means
414  * that a supply mechanism has to be added in a derived contract using {_mint}.
415  * For a generic mechanism see {ERC20PresetMinterPauser}.
416  *
417  * TIP: For a detailed writeup see our guide
418  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
419  * to implement supply mechanisms].
420  *
421  * We have followed general OpenZeppelin guidelines: functions revert instead
422  * of returning `false` on failure. This behavior is nonetheless conventional
423  * and does not conflict with the expectations of ERC20 applications.
424  *
425  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
426  * This allows applications to reconstruct the allowance for all accounts just
427  * by listening to said events. Other implementations of the EIP may not emit
428  * these events, as it isn't required by the specification.
429  *
430  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
431  * functions have been added to mitigate the well-known issues around setting
432  * allowances. See {IERC20-approve}.
433  */
434 contract ERC20 is Context, IERC20, IERC20Metadata {
435     mapping (address => uint256) private _balances;
436 
437     mapping (address => mapping (address => uint256)) private _allowances;
438 
439     uint256 private _totalSupply;
440 
441     string private _name;
442     string private _symbol;
443 
444     /**
445      * @dev Sets the values for {name} and {symbol}.
446      *
447      * The defaut value of {decimals} is 18. To select a different value for
448      * {decimals} you should overload it.
449      *
450      * All two of these values are immutable: they can only be set once during
451      * construction.
452      */
453     constructor (string memory name_, string memory symbol_) {
454         _name = name_;
455         _symbol = symbol_;
456     }
457 
458     /**
459      * @dev Returns the name of the token.
460      */
461     function name() public view virtual override returns (string memory) {
462         return _name;
463     }
464 
465     /**
466      * @dev Returns the symbol of the token, usually a shorter version of the
467      * name.
468      */
469     function symbol() public view virtual override returns (string memory) {
470         return _symbol;
471     }
472 
473     /**
474      * @dev Returns the number of decimals used to get its user representation.
475      * For example, if `decimals` equals `2`, a balance of `505` tokens should
476      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
477      *
478      * Tokens usually opt for a value of 18, imitating the relationship between
479      * Ether and Wei. This is the value {ERC20} uses, unless this function is
480      * overridden;
481      *
482      * NOTE: This information is only used for _display_ purposes: it in
483      * no way affects any of the arithmetic of the contract, including
484      * {IERC20-balanceOf} and {IERC20-transfer}.
485      */
486     function decimals() public view virtual override returns (uint8) {
487         return 18;
488     }
489 
490     /**
491      * @dev See {IERC20-totalSupply}.
492      */
493     function totalSupply() public view virtual override returns (uint256) {
494         return _totalSupply;
495     }
496 
497     /**
498      * @dev See {IERC20-balanceOf}.
499      */
500     function balanceOf(address account) public view virtual override returns (uint256) {
501         return _balances[account];
502     }
503 
504     /**
505      * @dev See {IERC20-transfer}.
506      *
507      * Requirements:
508      *
509      * - `recipient` cannot be the zero address.
510      * - the caller must have a balance of at least `amount`.
511      */
512     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
513         _transfer(_msgSender(), recipient, amount);
514         return true;
515     }
516 
517     /**
518      * @dev See {IERC20-allowance}.
519      */
520     function allowance(address owner, address spender) public view virtual override returns (uint256) {
521         return _allowances[owner][spender];
522     }
523 
524     /**
525      * @dev See {IERC20-approve}.
526      *
527      * Requirements:
528      *
529      * - `spender` cannot be the zero address.
530      */
531     function approve(address spender, uint256 amount) public virtual override returns (bool) {
532         _approve(_msgSender(), spender, amount);
533         return true;
534     }
535 
536     /**
537      * @dev See {IERC20-transferFrom}.
538      *
539      * Emits an {Approval} event indicating the updated allowance. This is not
540      * required by the EIP. See the note at the beginning of {ERC20}.
541      *
542      * Requirements:
543      *
544      * - `sender` and `recipient` cannot be the zero address.
545      * - `sender` must have a balance of at least `amount`.
546      * - the caller must have allowance for ``sender``'s tokens of at least
547      * `amount`.
548      */
549     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
550         _transfer(sender, recipient, amount);
551 
552         uint256 currentAllowance = _allowances[sender][_msgSender()];
553         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
554         _approve(sender, _msgSender(), currentAllowance - amount);
555 
556         return true;
557     }
558 
559     /**
560      * @dev Atomically increases the allowance granted to `spender` by the caller.
561      *
562      * This is an alternative to {approve} that can be used as a mitigation for
563      * problems described in {IERC20-approve}.
564      *
565      * Emits an {Approval} event indicating the updated allowance.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      */
571     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
573         return true;
574     }
575 
576     /**
577      * @dev Atomically decreases the allowance granted to `spender` by the caller.
578      *
579      * This is an alternative to {approve} that can be used as a mitigation for
580      * problems described in {IERC20-approve}.
581      *
582      * Emits an {Approval} event indicating the updated allowance.
583      *
584      * Requirements:
585      *
586      * - `spender` cannot be the zero address.
587      * - `spender` must have allowance for the caller of at least
588      * `subtractedValue`.
589      */
590     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
591         uint256 currentAllowance = _allowances[_msgSender()][spender];
592         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
593         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
594 
595         return true;
596     }
597 
598     /**
599      * @dev Moves tokens `amount` from `sender` to `recipient`.
600      *
601      * This is internal function is equivalent to {transfer}, and can be used to
602      * e.g. implement automatic token fees, slashing mechanisms, etc.
603      *
604      * Emits a {Transfer} event.
605      *
606      * Requirements:
607      *
608      * - `sender` cannot be the zero address.
609      * - `recipient` cannot be the zero address.
610      * - `sender` must have a balance of at least `amount`.
611      */
612     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
613         require(sender != address(0), "ERC20: transfer from the zero address");
614         require(recipient != address(0), "ERC20: transfer to the zero address");
615 
616         _beforeTokenTransfer(sender, recipient, amount);
617 
618         uint256 senderBalance = _balances[sender];
619         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
620         _balances[sender] = senderBalance - amount;
621         _balances[recipient] += amount;
622 
623         emit Transfer(sender, recipient, amount);
624     }
625 
626     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
627      * the total supply.
628      *
629      * Emits a {Transfer} event with `from` set to the zero address.
630      *
631      * Requirements:
632      *
633      * - `to` cannot be the zero address.
634      */
635     function _mint(address account, uint256 amount) internal virtual {
636         require(account != address(0), "ERC20: mint to the zero address");
637 
638         _beforeTokenTransfer(address(0), account, amount);
639 
640         _totalSupply += amount;
641         _balances[account] += amount;
642         emit Transfer(address(0), account, amount);
643     }
644 
645     /**
646      * @dev Destroys `amount` tokens from `account`, reducing the
647      * total supply.
648      *
649      * Emits a {Transfer} event with `to` set to the zero address.
650      *
651      * Requirements:
652      *
653      * - `account` cannot be the zero address.
654      * - `account` must have at least `amount` tokens.
655      */
656     function _burn(address account, uint256 amount) internal virtual {
657         require(account != address(0), "ERC20: burn from the zero address");
658 
659         _beforeTokenTransfer(account, address(0), amount);
660 
661         uint256 accountBalance = _balances[account];
662         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
663         _balances[account] = accountBalance - amount;
664         _totalSupply -= amount;
665 
666         emit Transfer(account, address(0), amount);
667     }
668 
669     /**
670      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
671      *
672      * This internal function is equivalent to `approve`, and can be used to
673      * e.g. set automatic allowances for certain subsystems, etc.
674      *
675      * Emits an {Approval} event.
676      *
677      * Requirements:
678      *
679      * - `owner` cannot be the zero address.
680      * - `spender` cannot be the zero address.
681      */
682     function _approve(address owner, address spender, uint256 amount) internal virtual {
683         require(owner != address(0), "ERC20: approve from the zero address");
684         require(spender != address(0), "ERC20: approve to the zero address");
685 
686         _allowances[owner][spender] = amount;
687         emit Approval(owner, spender, amount);
688     }
689 
690     /**
691      * @dev Hook that is called before any transfer of tokens. This includes
692      * minting and burning.
693      *
694      * Calling conditions:
695      *
696      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
697      * will be to transferred to `to`.
698      * - when `from` is zero, `amount` tokens will be minted for `to`.
699      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
700      * - `from` and `to` are never both zero.
701      *
702      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
703      */
704     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
705 }
706 
707 
708 /**
709  * @dev Contract module which allows children to implement an emergency stop
710  * mechanism that can be triggered by an authorized account.
711  *
712  * This module is used through inheritance. It will make available the
713  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
714  * the functions of your contract. Note that they will not be pausable by
715  * simply including this module, only once the modifiers are put in place.
716  */
717 abstract contract Pausable is Context {
718     /**
719      * @dev Emitted when the pause is triggered by `account`.
720      */
721     event Paused(address account);
722 
723     /**
724      * @dev Emitted when the pause is lifted by `account`.
725      */
726     event Unpaused(address account);
727 
728     bool private _paused;
729 
730     /**
731      * @dev Initializes the contract in unpaused state.
732      */
733     constructor () {
734         _paused = false;
735     }
736 
737     /**
738      * @dev Returns true if the contract is paused, and false otherwise.
739      */
740     function paused() public view virtual returns (bool) {
741         return _paused;
742     }
743 
744     /**
745      * @dev Modifier to make a function callable only when the contract is not paused.
746      *
747      * Requirements:
748      *
749      * - The contract must not be paused.
750      */
751     modifier whenNotPaused() {
752         require(!paused(), "Pausable: paused");
753         _;
754     }
755 
756     /**
757      * @dev Modifier to make a function callable only when the contract is paused.
758      *
759      * Requirements:
760      *
761      * - The contract must be paused.
762      */
763     modifier whenPaused() {
764         require(paused(), "Pausable: not paused");
765         _;
766     }
767 
768     /**
769      * @dev Triggers stopped state.
770      *
771      * Requirements:
772      *
773      * - The contract must not be paused.
774      */
775     function _pause() internal virtual whenNotPaused {
776         _paused = true;
777         emit Paused(_msgSender());
778     }
779 
780     /**
781      * @dev Returns to normal state.
782      *
783      * Requirements:
784      *
785      * - The contract must be paused.
786      */
787     function _unpause() internal virtual whenPaused {
788         _paused = false;
789         emit Unpaused(_msgSender());
790     }
791 }
792 
793 
794 contract AscendEXToken is ERC20, Pausable, Ownable {
795     using SafeMath for uint256;
796 
797     constructor (string memory _name, string memory _symbol, uint256 _totalSupply) ERC20(_name, _symbol) {
798         _mint(_msgSender(), _totalSupply);
799     }
800 
801     function burn(uint256 amount) external {                   
802         _burn(_msgSender(), amount);
803     }
804 
805     function pause() external onlyOwner {
806         _pause();
807     }
808 
809     function unpause() external onlyOwner {
810         _unpause();
811     }
812 
813 
814     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
815         super._beforeTokenTransfer(from, to, amount);
816 
817         require(!paused(), "AscendEXToken: token transfer while paused");
818     }
819 }