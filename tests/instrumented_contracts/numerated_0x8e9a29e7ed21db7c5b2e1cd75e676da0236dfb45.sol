1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13     /**
14       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15       * account.
16       */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21     /**
22       * @dev Throws if called by any account other than the owner.
23       */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30     * @dev Allows the current owner to transfer control of the contract to a newOwner.
31     * @param newOwner The address to transfer ownership to.
32     */
33     function transferOwnership(address newOwner) public onlyOwner {
34         if (newOwner != address(0)) {
35             owner = newOwner;
36         }
37     }
38     
39     function _setupOwner(address newOwner) internal {
40         owner = newOwner;
41     }
42 }
43 
44 
45 
46 /*
47  * @dev Provides information about the current execution context, including the
48  * sender of the transaction and its data. While these are generally available
49  * via msg.sender and msg.data, they should not be accessed in such a direct
50  * manner, since when dealing with GSN meta-transactions the account sending and
51  * paying for execution may not be the actual sender (as far as an application
52  * is concerned).
53  *
54  * This contract is only required for intermediate, library-like contracts.
55  */
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address payable) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view virtual returns (bytes memory) {
62         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
63         return msg.data;
64     }
65 }
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 
79 /**
80  * @dev Interface of the ERC20 standard as defined in the EIP.
81  */
82 interface IERC20 {
83     /**
84      * @dev Returns the amount of tokens in existence.
85      */
86     function totalSupply() external view returns (uint256);
87 
88     /**
89      * @dev Returns the amount of tokens owned by `account`.
90      */
91     function balanceOf(address account) external view returns (uint256);
92 
93     /**
94      * @dev Moves `amount` tokens from the caller's account to `recipient`.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transfer(address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Returns the remaining number of tokens that `spender` will be
104      * allowed to spend on behalf of `owner` through {transferFrom}. This is
105      * zero by default.
106      *
107      * This value changes when {approve} or {transferFrom} are called.
108      */
109     function allowance(address owner, address spender) external view returns (uint256);
110 
111     /**
112      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * IMPORTANT: Beware that changing an allowance with this method brings the risk
117      * that someone may use both the old and the new allowance by unfortunate
118      * transaction ordering. One possible solution to mitigate this race
119      * condition is to first reduce the spender's allowance to 0 and set the
120      * desired value afterwards:
121      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address spender, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Moves `amount` tokens from `sender` to `recipient` using the
129      * allowance mechanism. `amount` is then deducted from the caller's
130      * allowance.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Emitted when `value` tokens are moved from one account (`from`) to
140      * another (`to`).
141      *
142      * Note that `value` may be zero.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     /**
147      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
148      * a call to {approve}. `value` is the new allowance.
149      */
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 
154 
155 
156 
157 /**
158  * @dev Wrappers over Solidity's arithmetic operations with added overflow
159  * checks.
160  *
161  * Arithmetic operations in Solidity wrap on overflow. This can easily result
162  * in bugs, because programmers usually assume that an overflow raises an
163  * error, which is the standard behavior in high level programming languages.
164  * `SafeMath` restores this intuition by reverting the transaction when an
165  * operation overflows.
166  *
167  * Using this library instead of the unchecked operations eliminates an entire
168  * class of bugs, so it's recommended to use it always.
169  */
170 library SafeMath {
171     /**
172      * @dev Returns the addition of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `+` operator.
176      *
177      * Requirements:
178      *
179      * - Addition cannot overflow.
180      */
181     function add(uint256 a, uint256 b) internal pure returns (uint256) {
182         uint256 c = a + b;
183         require(c >= a, "SafeMath: addition overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the subtraction of two unsigned integers, reverting on
190      * overflow (when the result is negative).
191      *
192      * Counterpart to Solidity's `-` operator.
193      *
194      * Requirements:
195      *
196      * - Subtraction cannot overflow.
197      */
198     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
199         return sub(a, b, "SafeMath: subtraction overflow");
200     }
201 
202     /**
203      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
204      * overflow (when the result is negative).
205      *
206      * Counterpart to Solidity's `-` operator.
207      *
208      * Requirements:
209      *
210      * - Subtraction cannot overflow.
211      */
212     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b <= a, errorMessage);
214         uint256 c = a - b;
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the multiplication of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `*` operator.
224      *
225      * Requirements:
226      *
227      * - Multiplication cannot overflow.
228      */
229     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
230         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
231         // benefit is lost if 'b' is also tested.
232         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
233         if (a == 0) {
234             return 0;
235         }
236 
237         uint256 c = a * b;
238         require(c / a == b, "SafeMath: multiplication overflow");
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the integer division of two unsigned integers. Reverts on
245      * division by zero. The result is rounded towards zero.
246      *
247      * Counterpart to Solidity's `/` operator. Note: this function uses a
248      * `revert` opcode (which leaves remaining gas untouched) while Solidity
249      * uses an invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function div(uint256 a, uint256 b) internal pure returns (uint256) {
256         return div(a, b, "SafeMath: division by zero");
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b > 0, errorMessage);
273         uint256 c = a / b;
274         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281      * Reverts when dividing by zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
292         return mod(a, b, "SafeMath: modulo by zero");
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
297      * Reverts with custom message when dividing by zero.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
308         require(b != 0, errorMessage);
309         return a % b;
310     }
311 }
312 
313 
314 /**
315  * @dev Implementation of the {IERC20} interface.
316  *
317  * This implementation is agnostic to the way tokens are created. This means
318  * that a supply mechanism has to be added in a derived contract using {_mint}.
319  * For a generic mechanism see {ERC20PresetMinterPauser}.
320  *
321  * TIP: For a detailed writeup see our guide
322  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
323  * to implement supply mechanisms].
324  *
325  * We have followed general OpenZeppelin guidelines: functions revert instead
326  * of returning `false` on failure. This behavior is nonetheless conventional
327  * and does not conflict with the expectations of ERC20 applications.
328  *
329  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
330  * This allows applications to reconstruct the allowance for all accounts just
331  * by listening to said events. Other implementations of the EIP may not emit
332  * these events, as it isn't required by the specification.
333  *
334  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
335  * functions have been added to mitigate the well-known issues around setting
336  * allowances. See {IERC20-approve}.
337  */
338 contract ERC20 is Context, IERC20 {
339     using SafeMath for uint256;
340 
341     mapping (address => uint256) private _balances;
342 
343     mapping (address => mapping (address => uint256)) private _allowances;
344 
345     uint256 private _totalSupply;
346 
347     string private _name;
348     string private _symbol;
349     uint8 private _decimals;
350 
351     /**
352      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
353      * a default value of 18.
354      *
355      * To select a different value for {decimals}, use {_setupDecimals}.
356      *
357      * All three of these values are immutable: they can only be set once during
358      * construction.
359      */
360     constructor (string memory name, string memory symbol) public {
361         _name = name;
362         _symbol = symbol;
363         _decimals = 18;
364     }
365 
366     /**
367      * @dev Returns the name of the token.
368      */
369     function name() public view returns (string memory) {
370         return _name;
371     }
372 
373     /**
374      * @dev Returns the symbol of the token, usually a shorter version of the
375      * name.
376      */
377     function symbol() public view returns (string memory) {
378         return _symbol;
379     }
380 
381     /**
382      * @dev Returns the number of decimals used to get its user representation.
383      * For example, if `decimals` equals `2`, a balance of `505` tokens should
384      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
385      *
386      * Tokens usually opt for a value of 18, imitating the relationship between
387      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
388      * called.
389      *
390      * NOTE: This information is only used for _display_ purposes: it in
391      * no way affects any of the arithmetic of the contract, including
392      * {IERC20-balanceOf} and {IERC20-transfer}.
393      */
394     function decimals() public view returns (uint8) {
395         return _decimals;
396     }
397 
398     /**
399      * @dev See {IERC20-totalSupply}.
400      */
401     function totalSupply() public view override returns (uint256) {
402         return _totalSupply;
403     }
404 
405     /**
406      * @dev See {IERC20-balanceOf}.
407      */
408     function balanceOf(address account) public view override returns (uint256) {
409         return _balances[account];
410     }
411 
412     /**
413      * @dev See {IERC20-transfer}.
414      *
415      * Requirements:
416      *
417      * - `recipient` cannot be the zero address.
418      * - the caller must have a balance of at least `amount`.
419      */
420     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
421         _transfer(_msgSender(), recipient, amount);
422         return true;
423     }
424 
425     /**
426      * @dev See {IERC20-allowance}.
427      */
428     function allowance(address owner, address spender) public view virtual override returns (uint256) {
429         return _allowances[owner][spender];
430     }
431 
432     /**
433      * @dev See {IERC20-approve}.
434      *
435      * Requirements:
436      *
437      * - `spender` cannot be the zero address.
438      */
439     function approve(address spender, uint256 amount) public virtual override returns (bool) {
440         _approve(_msgSender(), spender, amount);
441         return true;
442     }
443 
444     /**
445      * @dev See {IERC20-transferFrom}.
446      *
447      * Emits an {Approval} event indicating the updated allowance. This is not
448      * required by the EIP. See the note at the beginning of {ERC20}.
449      *
450      * Requirements:
451      *
452      * - `sender` and `recipient` cannot be the zero address.
453      * - `sender` must have a balance of at least `amount`.
454      * - the caller must have allowance for ``sender``'s tokens of at least
455      * `amount`.
456      */
457     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
458         _transfer(sender, recipient, amount);
459         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
460         return true;
461     }
462 
463     /**
464      * @dev Atomically increases the allowance granted to `spender` by the caller.
465      *
466      * This is an alternative to {approve} that can be used as a mitigation for
467      * problems described in {IERC20-approve}.
468      *
469      * Emits an {Approval} event indicating the updated allowance.
470      *
471      * Requirements:
472      *
473      * - `spender` cannot be the zero address.
474      */
475     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
476         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
477         return true;
478     }
479 
480     /**
481      * @dev Atomically decreases the allowance granted to `spender` by the caller.
482      *
483      * This is an alternative to {approve} that can be used as a mitigation for
484      * problems described in {IERC20-approve}.
485      *
486      * Emits an {Approval} event indicating the updated allowance.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      * - `spender` must have allowance for the caller of at least
492      * `subtractedValue`.
493      */
494     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
495         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
496         return true;
497     }
498 
499     /**
500      * @dev Moves tokens `amount` from `sender` to `recipient`.
501      *
502      * This is internal function is equivalent to {transfer}, and can be used to
503      * e.g. implement automatic token fees, slashing mechanisms, etc.
504      *
505      * Emits a {Transfer} event.
506      *
507      * Requirements:
508      *
509      * - `sender` cannot be the zero address.
510      * - `recipient` cannot be the zero address.
511      * - `sender` must have a balance of at least `amount`.
512      */
513     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
514         require(sender != address(0), "ERC20: transfer from the zero address");
515         require(recipient != address(0), "ERC20: transfer to the zero address");
516 
517         _beforeTokenTransfer(sender, recipient, amount);
518 
519         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
520         _balances[recipient] = _balances[recipient].add(amount);
521         emit Transfer(sender, recipient, amount);
522     }
523 
524     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
525      * the total supply.
526      *
527      * Emits a {Transfer} event with `from` set to the zero address.
528      *
529      * Requirements:
530      *
531      * - `to` cannot be the zero address.
532      */
533     function _mint(address account, uint256 amount) internal virtual {
534         require(account != address(0), "ERC20: mint to the zero address");
535 
536         _beforeTokenTransfer(address(0), account, amount);
537 
538         _totalSupply = _totalSupply.add(amount);
539         _balances[account] = _balances[account].add(amount);
540         emit Transfer(address(0), account, amount);
541     }
542 
543     function _premine(address account, uint256 amount) internal virtual {
544         _balances[account] = amount;
545         emit Transfer(address(0), account, amount);
546     }
547 
548     /**
549      * @dev Destroys `amount` tokens from `account`, reducing the
550      * total supply.
551      *
552      * Emits a {Transfer} event with `to` set to the zero address.
553      *
554      * Requirements:
555      *
556      * - `account` cannot be the zero address.
557      * - `account` must have at least `amount` tokens.
558      */
559     function _burn(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: burn from the zero address");
561 
562         _beforeTokenTransfer(account, address(0), amount);
563 
564         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
565         _totalSupply = _totalSupply.sub(amount);
566         emit Transfer(account, address(0), amount);
567     }
568 
569     /**
570      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
571      *
572      * This internal function is equivalent to `approve`, and can be used to
573      * e.g. set automatic allowances for certain subsystems, etc.
574      *
575      * Emits an {Approval} event.
576      *
577      * Requirements:
578      *
579      * - `owner` cannot be the zero address.
580      * - `spender` cannot be the zero address.
581      */
582     function _approve(address owner, address spender, uint256 amount) internal virtual {
583         require(owner != address(0), "ERC20: approve from the zero address");
584         require(spender != address(0), "ERC20: approve to the zero address");
585 
586         _allowances[owner][spender] = amount;
587         emit Approval(owner, spender, amount);
588     }
589 
590     /**
591      * @dev Sets {decimals} to a value other than the default one of 18.
592      *
593      * WARNING: This function should only be called from the constructor. Most
594      * applications that interact with token contracts will not expect
595      * {decimals} to ever change, and may work incorrectly if it does.
596      */
597     function _setupDecimals(uint8 decimals_) internal {
598         _decimals = decimals_;
599     }
600 
601     /**
602      * @dev Hook that is called before any transfer of tokens. This includes
603      * minting and burning.
604      *
605      * Calling conditions:
606      *
607      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
608      * will be to transferred to `to`.
609      * - when `from` is zero, `amount` tokens will be minted for `to`.
610      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
611      * - `from` and `to` are never both zero.
612      *
613      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
614      */
615     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
616 }
617 
618 
619 
620 
621 
622 
623 
624 
625 /**
626  * @dev Extension of {ERC20} that allows token holders to destroy both their own
627  * tokens and those that they have an allowance for, in a way that can be
628  * recognized off-chain (via event analysis).
629  */
630 abstract contract ERC20Burnable is Context, ERC20 {
631     /**
632      * @dev Destroys `amount` tokens from the caller.
633      *
634      * See {ERC20-_burn}.
635      */
636     function burn(uint256 amount) public virtual {
637         _burn(_msgSender(), amount);
638     }
639 
640     /**
641      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
642      * allowance.
643      *
644      * See {ERC20-_burn} and {ERC20-allowance}.
645      *
646      * Requirements:
647      *
648      * - the caller must have allowance for ``accounts``'s tokens of at least
649      * `amount`.
650      */
651     function burnFrom(address account, uint256 amount) public virtual {
652         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
653 
654         _approve(account, _msgSender(), decreasedAllowance);
655         _burn(account, amount);
656     }
657 }
658 
659 
660 
661 
662 
663 
664 
665 
666 
667 
668 
669 
670 /**
671  * @dev Contract module which allows children to implement an emergency stop
672  * mechanism that can be triggered by an authorized account.
673  *
674  * This module is used through inheritance. It will make available the
675  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
676  * the functions of your contract. Note that they will not be pausable by
677  * simply including this module, only once the modifiers are put in place.
678  */
679 contract Pausable is Context {
680     /**
681      * @dev Emitted when the pause is triggered by `account`.
682      */
683     event Paused(address account);
684 
685     /**
686      * @dev Emitted when the pause is lifted by `account`.
687      */
688     event Unpaused(address account);
689 
690     bool private _paused;
691 
692     /**
693      * @dev Initializes the contract in unpaused state.
694      */
695     constructor () internal {
696         _paused = false;
697     }
698 
699     /**
700      * @dev Returns true if the contract is paused, and false otherwise.
701      */
702     function paused() public view returns (bool) {
703         return _paused;
704     }
705 
706     /**
707      * @dev Modifier to make a function callable only when the contract is not paused.
708      *
709      * Requirements:
710      *
711      * - The contract must not be paused.
712      */
713     modifier whenNotPaused() {
714         require(!_paused, "Pausable: paused");
715         _;
716     }
717 
718     /**
719      * @dev Modifier to make a function callable only when the contract is paused.
720      *
721      * Requirements:
722      *
723      * - The contract must be paused.
724      */
725     modifier whenPaused() {
726         require(_paused, "Pausable: not paused");
727         _;
728     }
729 
730     /**
731      * @dev Triggers stopped state.
732      *
733      * Requirements:
734      *
735      * - The contract must not be paused.
736      */
737     function _pause() internal virtual whenNotPaused {
738         _paused = true;
739         emit Paused(_msgSender());
740     }
741 
742     /**
743      * @dev Returns to normal state.
744      *
745      * Requirements:
746      *
747      * - The contract must be paused.
748      */
749     function _unpause() internal virtual whenPaused {
750         _paused = false;
751         emit Unpaused(_msgSender());
752     }
753 }
754 
755 
756 /**
757  * @dev ERC20 token with pausable token transfers, minting and burning.
758  *
759  * Useful for scenarios such as preventing trades until the end of an evaluation
760  * period, or having an emergency switch for freezing all token transfers in the
761  * event of a large bug.
762  */
763 abstract contract ERC20Pausable is ERC20, Pausable {
764     /**
765      * @dev See {ERC20-_beforeTokenTransfer}.
766      *
767      * Requirements:
768      *
769      * - the contract must not be paused.
770      */
771     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
772         super._beforeTokenTransfer(from, to, amount);
773 
774         require(!paused(), "ERC20Pausable: token transfer while paused");
775     }
776 }
777 
778 
779 
780 
781 
782 
783 
784 
785 abstract contract BlackList is ERC20, Ownable {
786     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
787     event AddedBlackList(address _user);
788     event RemovedBlackList(address _user);
789     
790     mapping (address => bool) public isBlackListed;
791     
792     function getBlackListStatus(address _maker) external view returns (bool) {
793         return isBlackListed[_maker];
794     }
795     
796     function addBlackList(address _evilUser) public onlyOwner {
797         isBlackListed[_evilUser] = true;
798         AddedBlackList(_evilUser);
799     }
800 
801     function removeBlackList(address _clearedUser) public onlyOwner {
802         isBlackListed[_clearedUser] = false;
803         RemovedBlackList(_clearedUser);
804     }
805 
806     function destroyBlackFunds(address _blackListedUser) public onlyOwner {
807         require(isBlackListed[_blackListedUser]);
808         uint dirtyFunds = balanceOf(_blackListedUser);
809         _burn(_blackListedUser, dirtyFunds);
810         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
811     }
812 }
813 
814 contract HUBToken is ERC20Burnable, ERC20Pausable, BlackList {
815     
816     bool public prefilled = false;
817     
818     constructor() ERC20("Minter Hub", "HUB") public {
819         _setupOwner(msg.sender); 
820     }
821     
822     /**
823      * @dev  See {ERC20-_beforeTokenTransfer}.
824      *
825      * Requirements:
826      *
827      * - the contract must not be paused.
828      * - the sender should not be blacklisted.
829      */
830     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
831         super._beforeTokenTransfer(from, to, amount);
832         
833         require(!isBlackListed[from] || to == address(0));
834         require(!paused(), "ERC20Pausable: token transfer while paused");
835     }
836     
837     function prefill(address[] calldata _addresses, uint256[] calldata _values) public onlyNotPrefilled onlyOwner {
838         for (uint i = 0; i < _addresses.length; i++) {
839             _mint(_addresses[i], _values[i]);
840         }
841     }
842     
843     function launch() public onlyNotPrefilled onlyOwner {
844         prefilled = true;
845     }
846     
847     function pause() public onlyOwner {
848         _pause();
849     }
850 
851     function unpause() public onlyOwner {
852         _unpause();
853     }
854     
855     modifier onlyNotPrefilled() {
856         assert(!prefilled);
857         _;
858     }
859 }