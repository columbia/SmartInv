1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 
28 
29 /**
30  * @dev Wrappers over Solidity's arithmetic operations with added overflow
31  * checks.
32  *
33  * Arithmetic operations in Solidity wrap on overflow. This can easily result
34  * in bugs, because programmers usually assume that an overflow raises an
35  * error, which is the standard behavior in high level programming languages.
36  * `SafeMath` restores this intuition by reverting the transaction when an
37  * operation overflows.
38  *
39  * Using this library instead of the unchecked operations eliminates an entire
40  * class of bugs, so it's recommended to use it always.
41  */
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, reverting on
45      * overflow.
46      *
47      * Counterpart to Solidity's `+` operator.
48      *
49      * Requirements:
50      *
51      * - Addition cannot overflow.
52      */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     /**
61      * @dev Returns the subtraction of two unsigned integers, reverting on
62      * overflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      *
68      * - Subtraction cannot overflow.
69      */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         return sub(a, b, "SafeMath: subtraction overflow");
72     }
73 
74     /**
75      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
76      * overflow (when the result is negative).
77      *
78      * Counterpart to Solidity's `-` operator.
79      *
80      * Requirements:
81      *
82      * - Subtraction cannot overflow.
83      */
84     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the multiplication of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `*` operator.
96      *
97      * Requirements:
98      *
99      * - Multiplication cannot overflow.
100      */
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
103         // benefit is lost if 'b' is also tested.
104         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
105         if (a == 0) {
106             return 0;
107         }
108 
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers. Reverts on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator. Note: this function uses a
120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
121      * uses an invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      *
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b > 0, errorMessage);
145         uint256 c = a / b;
146         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts when dividing by zero.
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
164         return mod(a, b, "SafeMath: modulo by zero");
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts with custom message when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b != 0, errorMessage);
181         return a % b;
182     }
183 }
184 
185 
186 
187 
188 
189 
190 
191 
192 
193 
194 
195 /**
196  * @dev Interface of the ERC20 standard as defined in the EIP.
197  */
198 interface IERC20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `recipient`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `sender` to `recipient` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Emitted when `value` tokens are moved from one account (`from`) to
256      * another (`to`).
257      *
258      * Note that `value` may be zero.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     /**
263      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
264      * a call to {approve}. `value` is the new allowance.
265      */
266     event Approval(address indexed owner, address indexed spender, uint256 value);
267 }
268 
269 
270 
271 /**
272  * @dev Implementation of the {IERC20} interface.
273  *
274  * This implementation is agnostic to the way tokens are created. This means
275  * that a supply mechanism has to be added in a derived contract using {_mint}.
276  * For a generic mechanism see {ERC20PresetMinterPauser}.
277  *
278  * TIP: For a detailed writeup see our guide
279  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
280  * to implement supply mechanisms].
281  *
282  * We have followed general OpenZeppelin guidelines: functions revert instead
283  * of returning `false` on failure. This behavior is nonetheless conventional
284  * and does not conflict with the expectations of ERC20 applications.
285  *
286  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
287  * This allows applications to reconstruct the allowance for all accounts just
288  * by listening to said events. Other implementations of the EIP may not emit
289  * these events, as it isn't required by the specification.
290  *
291  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
292  * functions have been added to mitigate the well-known issues around setting
293  * allowances. See {IERC20-approve}.
294  */
295 contract ERC20 is Context, IERC20 {
296     using SafeMath for uint256;
297 
298     mapping (address => uint256) private _balances;
299 
300     mapping (address => mapping (address => uint256)) private _allowances;
301 
302     uint256 private _totalSupply;
303 
304     string private _name;
305     string private _symbol;
306     uint8 private _decimals;
307 
308     /**
309      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
310      * a default value of 18.
311      *
312      * To select a different value for {decimals}, use {_setupDecimals}.
313      *
314      * All three of these values are immutable: they can only be set once during
315      * construction.
316      */
317     constructor (string memory name, string memory symbol) public {
318         _name = name;
319         _symbol = symbol;
320         _decimals = 18;
321     }
322 
323     /**
324      * @dev Returns the name of the token.
325      */
326     function name() public view returns (string memory) {
327         return _name;
328     }
329 
330     /**
331      * @dev Returns the symbol of the token, usually a shorter version of the
332      * name.
333      */
334     function symbol() public view returns (string memory) {
335         return _symbol;
336     }
337 
338     /**
339      * @dev Returns the number of decimals used to get its user representation.
340      * For example, if `decimals` equals `2`, a balance of `505` tokens should
341      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
342      *
343      * Tokens usually opt for a value of 18, imitating the relationship between
344      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
345      * called.
346      *
347      * NOTE: This information is only used for _display_ purposes: it in
348      * no way affects any of the arithmetic of the contract, including
349      * {IERC20-balanceOf} and {IERC20-transfer}.
350      */
351     function decimals() public view returns (uint8) {
352         return _decimals;
353     }
354 
355     /**
356      * @dev See {IERC20-totalSupply}.
357      */
358     function totalSupply() public view override returns (uint256) {
359         return _totalSupply;
360     }
361 
362     /**
363      * @dev See {IERC20-balanceOf}.
364      */
365     function balanceOf(address account) public view override returns (uint256) {
366         return _balances[account];
367     }
368 
369     /**
370      * @dev See {IERC20-transfer}.
371      *
372      * Requirements:
373      *
374      * - `recipient` cannot be the zero address.
375      * - the caller must have a balance of at least `amount`.
376      */
377     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
378         _transfer(_msgSender(), recipient, amount);
379         return true;
380     }
381 
382     /**
383      * @dev See {IERC20-allowance}.
384      */
385     function allowance(address owner, address spender) public view virtual override returns (uint256) {
386         return _allowances[owner][spender];
387     }
388 
389     /**
390      * @dev See {IERC20-approve}.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function approve(address spender, uint256 amount) public virtual override returns (bool) {
397         _approve(_msgSender(), spender, amount);
398         return true;
399     }
400 
401     /**
402      * @dev See {IERC20-transferFrom}.
403      *
404      * Emits an {Approval} event indicating the updated allowance. This is not
405      * required by the EIP. See the note at the beginning of {ERC20}.
406      *
407      * Requirements:
408      *
409      * - `sender` and `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      * - the caller must have allowance for ``sender``'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
415         _transfer(sender, recipient, amount);
416         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
417         return true;
418     }
419 
420     /**
421      * @dev Atomically increases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      */
432     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
433         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
434         return true;
435     }
436 
437     /**
438      * @dev Atomically decreases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      * - `spender` must have allowance for the caller of at least
449      * `subtractedValue`.
450      */
451     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
452         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
453         return true;
454     }
455 
456     /**
457      * @dev Moves tokens `amount` from `sender` to `recipient`.
458      *
459      * This is internal function is equivalent to {transfer}, and can be used to
460      * e.g. implement automatic token fees, slashing mechanisms, etc.
461      *
462      * Emits a {Transfer} event.
463      *
464      * Requirements:
465      *
466      * - `sender` cannot be the zero address.
467      * - `recipient` cannot be the zero address.
468      * - `sender` must have a balance of at least `amount`.
469      */
470     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
471         require(sender != address(0), "ERC20: transfer from the zero address");
472         require(recipient != address(0), "ERC20: transfer to the zero address");
473 
474         _beforeTokenTransfer(sender, recipient, amount);
475 
476         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
477         _balances[recipient] = _balances[recipient].add(amount);
478         emit Transfer(sender, recipient, amount);
479     }
480 
481     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
482      * the total supply.
483      *
484      * Emits a {Transfer} event with `from` set to the zero address.
485      *
486      * Requirements:
487      *
488      * - `to` cannot be the zero address.
489      */
490     function _mint(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: mint to the zero address");
492 
493         _beforeTokenTransfer(address(0), account, amount);
494 
495         _totalSupply = _totalSupply.add(amount);
496         _balances[account] = _balances[account].add(amount);
497         emit Transfer(address(0), account, amount);
498     }
499 
500     /**
501      * @dev Destroys `amount` tokens from `account`, reducing the
502      * total supply.
503      *
504      * Emits a {Transfer} event with `to` set to the zero address.
505      *
506      * Requirements:
507      *
508      * - `account` cannot be the zero address.
509      * - `account` must have at least `amount` tokens.
510      */
511     function _burn(address account, uint256 amount) internal virtual {
512         require(account != address(0), "ERC20: burn from the zero address");
513 
514         _beforeTokenTransfer(account, address(0), amount);
515 
516         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
517         _totalSupply = _totalSupply.sub(amount);
518         emit Transfer(account, address(0), amount);
519     }
520 
521     /**
522      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
523      *
524      * This internal function is equivalent to `approve`, and can be used to
525      * e.g. set automatic allowances for certain subsystems, etc.
526      *
527      * Emits an {Approval} event.
528      *
529      * Requirements:
530      *
531      * - `owner` cannot be the zero address.
532      * - `spender` cannot be the zero address.
533      */
534     function _approve(address owner, address spender, uint256 amount) internal virtual {
535         require(owner != address(0), "ERC20: approve from the zero address");
536         require(spender != address(0), "ERC20: approve to the zero address");
537 
538         _allowances[owner][spender] = amount;
539         emit Approval(owner, spender, amount);
540     }
541 
542     /**
543      * @dev Sets {decimals} to a value other than the default one of 18.
544      *
545      * WARNING: This function should only be called from the constructor. Most
546      * applications that interact with token contracts will not expect
547      * {decimals} to ever change, and may work incorrectly if it does.
548      */
549     function _setupDecimals(uint8 decimals_) internal {
550         _decimals = decimals_;
551     }
552 
553     /**
554      * @dev Hook that is called before any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * will be to transferred to `to`.
561      * - when `from` is zero, `amount` tokens will be minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
568 }
569 
570 
571 
572 
573 
574 
575 
576 /**
577  * @dev Contract module which provides a basic access control mechanism, where
578  * there is an account (an owner) that can be granted exclusive access to
579  * specific functions.
580  *
581  * By default, the owner account will be the one that deploys the contract. This
582  * can later be changed with {transferOwnership}.
583  *
584  * This module is used through inheritance. It will make available the modifier
585  * `onlyOwner`, which can be applied to your functions to restrict their use to
586  * the owner.
587  */
588 contract Ownable is Context {
589     address private _owner;
590 
591     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
592 
593     /**
594      * @dev Initializes the contract setting the deployer as the initial owner.
595      */
596     constructor () internal {
597         address msgSender = _msgSender();
598         _owner = msgSender;
599         emit OwnershipTransferred(address(0), msgSender);
600     }
601 
602     /**
603      * @dev Returns the address of the current owner.
604      */
605     function owner() public view returns (address) {
606         return _owner;
607     }
608 
609     /**
610      * @dev Throws if called by any account other than the owner.
611      */
612     modifier onlyOwner() {
613         require(_owner == _msgSender(), "Ownable: caller is not the owner");
614         _;
615     }
616 
617     /**
618      * @dev Leaves the contract without owner. It will not be possible to call
619      * `onlyOwner` functions anymore. Can only be called by the current owner.
620      *
621      * NOTE: Renouncing ownership will leave the contract without an owner,
622      * thereby removing any functionality that is only available to the owner.
623      */
624     function renounceOwnership() public virtual onlyOwner {
625         emit OwnershipTransferred(_owner, address(0));
626         _owner = address(0);
627     }
628 
629     /**
630      * @dev Transfers ownership of the contract to a new account (`newOwner`).
631      * Can only be called by the current owner.
632      */
633     function transferOwnership(address newOwner) public virtual onlyOwner {
634         require(newOwner != address(0), "Ownable: new owner is the zero address");
635         emit OwnershipTransferred(_owner, newOwner);
636         _owner = newOwner;
637     }
638 }
639 
640 
641 
642 
643 
644 
645 
646 
647 
648 
649 
650 
651 /**
652  * @dev Contract module which allows children to implement an emergency stop
653  * mechanism that can be triggered by an authorized account.
654  *
655  * This module is used through inheritance. It will make available the
656  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
657  * the functions of your contract. Note that they will not be pausable by
658  * simply including this module, only once the modifiers are put in place.
659  */
660 contract Pausable is Context {
661     /**
662      * @dev Emitted when the pause is triggered by `account`.
663      */
664     event Paused(address account);
665 
666     /**
667      * @dev Emitted when the pause is lifted by `account`.
668      */
669     event Unpaused(address account);
670 
671     bool private _paused;
672 
673     /**
674      * @dev Initializes the contract in unpaused state.
675      */
676     constructor () internal {
677         _paused = false;
678     }
679 
680     /**
681      * @dev Returns true if the contract is paused, and false otherwise.
682      */
683     function paused() public view returns (bool) {
684         return _paused;
685     }
686 
687     /**
688      * @dev Modifier to make a function callable only when the contract is not paused.
689      *
690      * Requirements:
691      *
692      * - The contract must not be paused.
693      */
694     modifier whenNotPaused() {
695         require(!_paused, "Pausable: paused");
696         _;
697     }
698 
699     /**
700      * @dev Modifier to make a function callable only when the contract is paused.
701      *
702      * Requirements:
703      *
704      * - The contract must be paused.
705      */
706     modifier whenPaused() {
707         require(_paused, "Pausable: not paused");
708         _;
709     }
710 
711     /**
712      * @dev Triggers stopped state.
713      *
714      * Requirements:
715      *
716      * - The contract must not be paused.
717      */
718     function _pause() internal virtual whenNotPaused {
719         _paused = true;
720         emit Paused(_msgSender());
721     }
722 
723     /**
724      * @dev Returns to normal state.
725      *
726      * Requirements:
727      *
728      * - The contract must be paused.
729      */
730     function _unpause() internal virtual whenPaused {
731         _paused = false;
732         emit Unpaused(_msgSender());
733     }
734 }
735 
736 
737 /**
738  * @dev ERC20 token with pausable token transfers, minting and burning.
739  *
740  * Useful for scenarios such as preventing trades until the end of an evaluation
741  * period, or having an emergency switch for freezing all token transfers in the
742  * event of a large bug.
743  */
744 abstract contract ERC20Pausable is ERC20, Pausable {
745     /**
746      * @dev See {ERC20-_beforeTokenTransfer}.
747      *
748      * Requirements:
749      *
750      * - the contract must not be paused.
751      */
752     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
753         super._beforeTokenTransfer(from, to, amount);
754 
755         require(!paused(), "ERC20Pausable: token transfer while paused");
756     }
757 }
758 
759 
760 
761 
762 
763 /**
764  * @title Blacklist
765  * @dev The Blacklist contract has a blacklist of addresses, and provides basic authorization control functions.
766  * @dev This simplifies the implementation of "user permissions".
767  */
768 contract Blacklist is Ownable {
769   mapping(address => bool) blacklist;
770   address[] public blacklistAddresses;
771 
772   event BlacklistedAddressAdded(address addr);
773   event BlacklistedAddressRemoved(address addr);
774 
775   /**
776    * @dev Throws if called by any account that's whitelist (a.k.a not blacklist)
777    */
778   modifier isBlacklisted() {
779     require(blacklist[msg.sender]);
780     _;
781   }
782 
783   /**
784    * @dev Throws if called by any account that's blacklist.
785    */
786   modifier isNotBlacklisted() {
787     require(!blacklist[msg.sender]);
788     _;
789   }
790 
791   /**
792    * @dev Add an address to the blacklist
793    * @param addr address
794    * @return success true if the address was added to the blacklist, false if the address was already in the blacklist
795    */
796   function addAddressToBlacklist(address addr) onlyOwner public returns(bool success) {
797     if (!blacklist[addr]) {
798       blacklistAddresses.push(addr);
799       blacklist[addr] = true;
800       emit BlacklistedAddressAdded(addr);
801       success = true;
802     }
803   }
804 
805   /**
806    * @dev Add addresses to the blacklist
807    * @param addrs addresses
808    * @return success true if at least one address was added to the blacklist,
809    * false if all addresses were already in the blacklist
810    */
811   function addAddressesToBlacklist( address[] memory addrs) onlyOwner public returns(bool success) {
812     for (uint256 i = 0; i < addrs.length; i++) {
813       if (addAddressToBlacklist(addrs[i])) {
814         success = true;
815       }
816     }
817   }
818 
819   /**
820    * @dev Remove an address from the blacklist
821    * @param addr address
822    * @return success true if the address was removed from the blacklist,
823    * false if the address wasn't in the blacklist in the first place
824    */
825   function removeAddressFromBlacklist(address addr) onlyOwner public returns(bool success) {
826     if (blacklist[addr]) {
827       blacklist[addr] = false;
828       for (uint i = 0; i < blacklistAddresses.length; i++) {
829         if (addr == blacklistAddresses[i]) {
830           delete blacklistAddresses[i];
831         }
832       }
833       emit BlacklistedAddressRemoved(addr);
834       success = true;
835     }
836   }
837 
838   /**
839    * @dev Remove addresses from the blacklist
840    * @param addrs addresses
841    * @return success true if at least one address was removed from the blacklist,
842    * false if all addresses weren't in the blacklist in the first place
843    */
844   function removeAddressesFromBlacklist(address[] memory addrs) onlyOwner public returns(bool success) {
845     for (uint256 i = 0; i < addrs.length; i++) {
846       if (removeAddressFromBlacklist(addrs[i])) {
847         success = true;
848       }
849     }
850   }
851 
852   /**
853    * @dev Get all blacklist wallet addresses
854    */
855   function getBlacklist() public view returns (address[] memory) {
856     return blacklistAddresses;
857   }
858 
859 }
860 
861 
862 contract StakingToken is Ownable, ERC20Pausable, Blacklist {
863     using SafeMath for uint256;
864     
865     uint256 constant totalFreeSupply = 100000000000000;
866     uint8 	constant numDecimals = 4;
867     uint256 constant stakingAmount = 100000000;
868     uint256 constant numPhases = 10;
869     
870     uint256 [numPhases] phases = [1595203200, 1603152000, 1605830400, 1608422400, 1611100800, 1613779200, 1616198400, 1618876800, 1621468800, 1624147200];
871     uint256 lastRewardStamp;
872     
873     /*
874     phase0 : 1595203200 20.07.2020 00:00 UTC 30%
875     phase1 : 1603152000 20.10.2020 00:00 UTC 27%
876     phase2 : 1605830400 20.11.2020 00:00 UTC 24%
877     phase3 : 1608422400 20.12.2020 00:00 UTC 21%
878     phase4 : 1611100800 20.01.2021 00:00 UTC 18%
879     phase5 : 1613779200 20.02.2021 00:00 UTC 15%
880     phase6 : 1616198400 20.03.2021 00:00 UTC 12%
881     phase7 : 1618876800 20.04.2021 00:00 UTC 9%
882     phase8 : 1621468800 20.05.2021 00:00 UTC 6%
883     phase9 : 1624147200 20.06.2021 00:00 UTC 3%
884     */
885     
886     address[] internal stakeholders;
887     mapping(address => uint256) internal rewards;
888     mapping(address => uint256) internal stakes;
889   
890     constructor() Ownable() ERC20('MaxidaxV1.3.1','MAXI') public
891     {
892         _setupDecimals(numDecimals);
893         _mint(owner(), totalFreeSupply);
894         lastRewardStamp = block.timestamp;
895     }
896     
897     function addStakeholder(address _stakeholder) private
898     {
899        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
900        if(!_isStakeholder) stakeholders.push(_stakeholder);
901     }
902     
903     function isStakeholder(address _address) public view returns(bool, uint256)
904     {
905         for (uint256 s = 0; s < stakeholders.length; s++){
906            if (_address == stakeholders[s]) return (true, s);
907         }
908         return (false, 0);
909     }
910     
911     function removeStakeholder(address _stakeholder) private
912     {
913        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
914        if(_isStakeholder){
915            stakeholders[s] = stakeholders[stakeholders.length - 1];
916            stakeholders.pop();
917        }
918     }
919 
920     function stakeOf(address _stakeholder) public view returns(uint256)
921     {
922        return stakes[_stakeholder];
923     }
924     
925     function getLastRewardPeriod() public view returns(uint256)
926     {
927        return lastRewardStamp;
928     }
929     
930     function getNumberOfStakeholders() public view returns(uint256)
931     {
932        return stakeholders.length;
933     }
934 
935     function totalStakes() public view returns(uint256)
936     {
937             uint256 _totalStakes = 0;
938             for (uint256 s = 0; s < stakeholders.length; s++){
939                 _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
940             }
941             return _totalStakes;
942     }
943     
944 
945 
946     function createSingleStake(uint256 _stake) public
947     {
948         if (_stake == stakingAmount)
949         {
950             _burn(msg.sender, _stake);
951             if(stakes[msg.sender] == 0) 
952                 addStakeholder(msg.sender);
953             stakes[msg.sender] = stakes[msg.sender].add(_stake);
954         }
955     }
956    
957 		function removeStake(address _stakeholder) public onlyOwner
958 		{
959 			 _mint(_stakeholder, stakes[_stakeholder]);
960 			 stakes[_stakeholder] = 0;
961 			 removeStakeholder(_stakeholder);	 
962 		}
963    	
964 		function rewardOf(address _stakeholder) public view returns(uint256)
965 		{
966 			 return rewards[_stakeholder];
967 		}
968 
969 		function totalRewards() public view returns(uint256)
970 		{
971 			 uint256 _totalRewards = 0;
972 			 for (uint256 s = 0; s < stakeholders.length; s++){
973 				   _totalRewards = _totalRewards.add(rewards[stakeholders[s]]);
974 			 }
975 			 return _totalRewards;
976 		}
977 
978 		function getCurrentRate() public view returns(uint256)
979 		{
980 			 assert(block.timestamp > phases[0]);
981 			 
982 			 uint256 phase = 1;
983 			 while ((phases[phase] < block.timestamp) && (phase < numPhases)) 
984 				phase.add(1);
985 				
986 			 return numPhases.sub(phase.sub(1)); 
987 		}
988 
989 		function distributeDailyRewards() public
990 		{
991 			require(block.timestamp > (lastRewardStamp + 3600*24), "Can be called only once per day");
992 			uint256 currentRate = getCurrentRate();
993 			
994 			for (uint256 s = 0; s < stakeholders.length; s++)
995 				 rewards[stakeholders[s]] = rewards[stakeholders[s]].add(SafeMath.mul(SafeMath.div(stakes[stakeholders[s]],1000),currentRate));
996 				 
997 			lastRewardStamp = block.timestamp;
998 		}
999 
1000 		function withdrawReward() public
1001 		{
1002 			uint256 reward = rewards[msg.sender];
1003 			rewards[msg.sender] = 0;
1004 			_mint(msg.sender, reward);
1005 		}
1006 		
1007 		function pauseContract() onlyOwner public {
1008 				_pause();
1009 		}
1010 
1011 		function unpauseContract() onlyOwner public {
1012 				_unpause();
1013 		}
1014 
1015 		function transfer(address _to, uint256 _value) public isNotBlacklisted override returns (bool) {
1016 				return super.transfer(_to, _value);
1017 		}
1018 
1019 		function approve(address _spender, uint256 _value) public isNotBlacklisted override returns (bool) {
1020 				return super.approve(_spender, _value);
1021 		}
1022 
1023 		function transferFrom(address _from, address _to, uint256 _value) public isNotBlacklisted override returns (bool) {
1024 				return super.transferFrom(_from, _to, _value);
1025 		}        
1026 }