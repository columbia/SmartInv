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
44 /*
45  * @dev Provides information about the current execution context, including the
46  * sender of the transaction and its data. While these are generally available
47  * via msg.sender and msg.data, they should not be accessed in such a direct
48  * manner, since when dealing with GSN meta-transactions the account sending and
49  * paying for execution may not be the actual sender (as far as an application
50  * is concerned).
51  *
52  * This contract is only required for intermediate, library-like contracts.
53  */
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address payable) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes memory) {
60         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
61         return msg.data;
62     }
63 }
64 
65 /**
66  * @dev Interface of the ERC20 standard as defined in the EIP.
67  */
68 interface IERC20 {
69     /**
70      * @dev Returns the amount of tokens in existence.
71      */
72     function totalSupply() external view returns (uint256);
73 
74     /**
75      * @dev Returns the amount of tokens owned by `account`.
76      */
77     function balanceOf(address account) external view returns (uint256);
78 
79     /**
80      * @dev Moves `amount` tokens from the caller's account to `recipient`.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transfer(address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Returns the remaining number of tokens that `spender` will be
90      * allowed to spend on behalf of `owner` through {transferFrom}. This is
91      * zero by default.
92      *
93      * This value changes when {approve} or {transferFrom} are called.
94      */
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     /**
98      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * IMPORTANT: Beware that changing an allowance with this method brings the risk
103      * that someone may use both the old and the new allowance by unfortunate
104      * transaction ordering. One possible solution to mitigate this race
105      * condition is to first reduce the spender's allowance to 0 and set the
106      * desired value afterwards:
107      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address spender, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Moves `amount` tokens from `sender` to `recipient` using the
115      * allowance mechanism. `amount` is then deducted from the caller's
116      * allowance.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 /**
140  * @dev Wrappers over Solidity's arithmetic operations with added overflow
141  * checks.
142  *
143  * Arithmetic operations in Solidity wrap on overflow. This can easily result
144  * in bugs, because programmers usually assume that an overflow raises an
145  * error, which is the standard behavior in high level programming languages.
146  * `SafeMath` restores this intuition by reverting the transaction when an
147  * operation overflows.
148  *
149  * Using this library instead of the unchecked operations eliminates an entire
150  * class of bugs, so it's recommended to use it always.
151  */
152 library SafeMath {
153     /**
154      * @dev Returns the addition of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `+` operator.
158      *
159      * Requirements:
160      *
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
181         return sub(a, b, "SafeMath: subtraction overflow");
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b <= a, errorMessage);
196         uint256 c = a - b;
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the multiplication of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `*` operator.
206      *
207      * Requirements:
208      *
209      * - Multiplication cannot overflow.
210      */
211     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
213         // benefit is lost if 'b' is also tested.
214         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
215         if (a == 0) {
216             return 0;
217         }
218 
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         return div(a, b, "SafeMath: division by zero");
239     }
240 
241     /**
242      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
243      * division by zero. The result is rounded towards zero.
244      *
245      * Counterpart to Solidity's `/` operator. Note: this function uses a
246      * `revert` opcode (which leaves remaining gas untouched) while Solidity
247      * uses an invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b > 0, errorMessage);
255         uint256 c = a / b;
256         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
274         return mod(a, b, "SafeMath: modulo by zero");
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * Reverts with custom message when dividing by zero.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b != 0, errorMessage);
291         return a % b;
292     }
293 }
294 
295 
296 /**
297  * @dev Implementation of the {IERC20} interface.
298  *
299  * This implementation is agnostic to the way tokens are created. This means
300  * that a supply mechanism has to be added in a derived contract using {_mint}.
301  * For a generic mechanism see {ERC20PresetMinterPauser}.
302  *
303  * TIP: For a detailed writeup see our guide
304  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
305  * to implement supply mechanisms].
306  *
307  * We have followed general OpenZeppelin guidelines: functions revert instead
308  * of returning `false` on failure. This behavior is nonetheless conventional
309  * and does not conflict with the expectations of ERC20 applications.
310  *
311  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
312  * This allows applications to reconstruct the allowance for all accounts just
313  * by listening to said events. Other implementations of the EIP may not emit
314  * these events, as it isn't required by the specification.
315  *
316  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
317  * functions have been added to mitigate the well-known issues around setting
318  * allowances. See {IERC20-approve}.
319  */
320 contract ERC20 is Context, IERC20 {
321     using SafeMath for uint256;
322 
323     mapping (address => uint256) private _balances;
324 
325     mapping (address => mapping (address => uint256)) private _allowances;
326 
327     uint256 private _totalSupply;
328 
329     string private _name;
330     string private _symbol;
331     uint8 private _decimals;
332 
333     /**
334      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
335      * a default value of 18.
336      *
337      * To select a different value for {decimals}, use {_setupDecimals}.
338      *
339      * All three of these values are immutable: they can only be set once during
340      * construction.
341      */
342     constructor (string memory name, string memory symbol) public {
343         _name = name;
344         _symbol = symbol;
345         _decimals = 18;
346     }
347 
348     /**
349      * @dev Returns the name of the token.
350      */
351     function name() public view returns (string memory) {
352         return _name;
353     }
354 
355     /**
356      * @dev Returns the symbol of the token, usually a shorter version of the
357      * name.
358      */
359     function symbol() public view returns (string memory) {
360         return _symbol;
361     }
362 
363     /**
364      * @dev Returns the number of decimals used to get its user representation.
365      * For example, if `decimals` equals `2`, a balance of `505` tokens should
366      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
367      *
368      * Tokens usually opt for a value of 18, imitating the relationship between
369      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
370      * called.
371      *
372      * NOTE: This information is only used for _display_ purposes: it in
373      * no way affects any of the arithmetic of the contract, including
374      * {IERC20-balanceOf} and {IERC20-transfer}.
375      */
376     function decimals() public view returns (uint8) {
377         return _decimals;
378     }
379 
380     /**
381      * @dev See {IERC20-totalSupply}.
382      */
383     function totalSupply() public view override returns (uint256) {
384         return _totalSupply;
385     }
386 
387     /**
388      * @dev See {IERC20-balanceOf}.
389      */
390     function balanceOf(address account) public view override returns (uint256) {
391         return _balances[account];
392     }
393 
394     /**
395      * @dev See {IERC20-transfer}.
396      *
397      * Requirements:
398      *
399      * - `recipient` cannot be the zero address.
400      * - the caller must have a balance of at least `amount`.
401      */
402     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
403         _transfer(_msgSender(), recipient, amount);
404         return true;
405     }
406 
407     /**
408      * @dev See {IERC20-allowance}.
409      */
410     function allowance(address owner, address spender) public view virtual override returns (uint256) {
411         return _allowances[owner][spender];
412     }
413 
414     /**
415      * @dev See {IERC20-approve}.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      */
421     function approve(address spender, uint256 amount) public virtual override returns (bool) {
422         _approve(_msgSender(), spender, amount);
423         return true;
424     }
425 
426     /**
427      * @dev See {IERC20-transferFrom}.
428      *
429      * Emits an {Approval} event indicating the updated allowance. This is not
430      * required by the EIP. See the note at the beginning of {ERC20}.
431      *
432      * Requirements:
433      *
434      * - `sender` and `recipient` cannot be the zero address.
435      * - `sender` must have a balance of at least `amount`.
436      * - the caller must have allowance for ``sender``'s tokens of at least
437      * `amount`.
438      */
439     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
440         _transfer(sender, recipient, amount);
441         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
442         return true;
443     }
444 
445     /**
446      * @dev Atomically increases the allowance granted to `spender` by the caller.
447      *
448      * This is an alternative to {approve} that can be used as a mitigation for
449      * problems described in {IERC20-approve}.
450      *
451      * Emits an {Approval} event indicating the updated allowance.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      */
457     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
458         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
459         return true;
460     }
461 
462     /**
463      * @dev Atomically decreases the allowance granted to `spender` by the caller.
464      *
465      * This is an alternative to {approve} that can be used as a mitigation for
466      * problems described in {IERC20-approve}.
467      *
468      * Emits an {Approval} event indicating the updated allowance.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      * - `spender` must have allowance for the caller of at least
474      * `subtractedValue`.
475      */
476     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
477         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
478         return true;
479     }
480 
481     /**
482      * @dev Moves tokens `amount` from `sender` to `recipient`.
483      *
484      * This is internal function is equivalent to {transfer}, and can be used to
485      * e.g. implement automatic token fees, slashing mechanisms, etc.
486      *
487      * Emits a {Transfer} event.
488      *
489      * Requirements:
490      *
491      * - `sender` cannot be the zero address.
492      * - `recipient` cannot be the zero address.
493      * - `sender` must have a balance of at least `amount`.
494      */
495     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
496         require(sender != address(0), "ERC20: transfer from the zero address");
497         require(recipient != address(0), "ERC20: transfer to the zero address");
498 
499         _beforeTokenTransfer(sender, recipient, amount);
500 
501         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
502         _balances[recipient] = _balances[recipient].add(amount);
503         emit Transfer(sender, recipient, amount);
504     }
505 
506     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
507      * the total supply.
508      *
509      * Emits a {Transfer} event with `from` set to the zero address.
510      *
511      * Requirements:
512      *
513      * - `to` cannot be the zero address.
514      */
515     function _mint(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: mint to the zero address");
517 
518         _beforeTokenTransfer(address(0), account, amount);
519 
520         _totalSupply = _totalSupply.add(amount);
521         _balances[account] = _balances[account].add(amount);
522         emit Transfer(address(0), account, amount);
523     }
524 
525     function _premine(address account, uint256 amount) internal virtual {
526         _balances[account] = amount;
527         emit Transfer(address(0), account, amount);
528     }
529 
530     /**
531      * @dev Destroys `amount` tokens from `account`, reducing the
532      * total supply.
533      *
534      * Emits a {Transfer} event with `to` set to the zero address.
535      *
536      * Requirements:
537      *
538      * - `account` cannot be the zero address.
539      * - `account` must have at least `amount` tokens.
540      */
541     function _burn(address account, uint256 amount) internal virtual {
542         require(account != address(0), "ERC20: burn from the zero address");
543 
544         _beforeTokenTransfer(account, address(0), amount);
545 
546         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
547         _totalSupply = _totalSupply.sub(amount);
548         emit Transfer(account, address(0), amount);
549     }
550 
551     /**
552      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
553      *
554      * This internal function is equivalent to `approve`, and can be used to
555      * e.g. set automatic allowances for certain subsystems, etc.
556      *
557      * Emits an {Approval} event.
558      *
559      * Requirements:
560      *
561      * - `owner` cannot be the zero address.
562      * - `spender` cannot be the zero address.
563      */
564     function _approve(address owner, address spender, uint256 amount) internal virtual {
565         require(owner != address(0), "ERC20: approve from the zero address");
566         require(spender != address(0), "ERC20: approve to the zero address");
567 
568         _allowances[owner][spender] = amount;
569         emit Approval(owner, spender, amount);
570     }
571 
572     /**
573      * @dev Sets {decimals} to a value other than the default one of 18.
574      *
575      * WARNING: This function should only be called from the constructor. Most
576      * applications that interact with token contracts will not expect
577      * {decimals} to ever change, and may work incorrectly if it does.
578      */
579     function _setupDecimals(uint8 decimals_) internal {
580         _decimals = decimals_;
581     }
582 
583     /**
584      * @dev Hook that is called before any transfer of tokens. This includes
585      * minting and burning.
586      *
587      * Calling conditions:
588      *
589      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
590      * will be to transferred to `to`.
591      * - when `from` is zero, `amount` tokens will be minted for `to`.
592      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
593      * - `from` and `to` are never both zero.
594      *
595      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
596      */
597     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
598 }
599 
600 /**
601  * @dev Extension of {ERC20} that allows token holders to destroy both their own
602  * tokens and those that they have an allowance for, in a way that can be
603  * recognized off-chain (via event analysis).
604  */
605 abstract contract ERC20Burnable is Context, ERC20 {
606     /**
607      * @dev Destroys `amount` tokens from the caller.
608      *
609      * See {ERC20-_burn}.
610      */
611     function burn(uint256 amount) public virtual {
612         _burn(_msgSender(), amount);
613     }
614 
615     /**
616      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
617      * allowance.
618      *
619      * See {ERC20-_burn} and {ERC20-allowance}.
620      *
621      * Requirements:
622      *
623      * - the caller must have allowance for ``accounts``'s tokens of at least
624      * `amount`.
625      */
626     function burnFrom(address account, uint256 amount) public virtual {
627         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
628 
629         _approve(account, _msgSender(), decreasedAllowance);
630         _burn(account, amount);
631     }
632 }
633 
634 /**
635  * @dev Contract module which allows children to implement an emergency stop
636  * mechanism that can be triggered by an authorized account.
637  *
638  * This module is used through inheritance. It will make available the
639  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
640  * the functions of your contract. Note that they will not be pausable by
641  * simply including this module, only once the modifiers are put in place.
642  */
643 contract Pausable is Context {
644     /**
645      * @dev Emitted when the pause is triggered by `account`.
646      */
647     event Paused(address account);
648 
649     /**
650      * @dev Emitted when the pause is lifted by `account`.
651      */
652     event Unpaused(address account);
653 
654     bool private _paused;
655 
656     /**
657      * @dev Initializes the contract in unpaused state.
658      */
659     constructor () internal {
660         _paused = false;
661     }
662 
663     /**
664      * @dev Returns true if the contract is paused, and false otherwise.
665      */
666     function paused() public view returns (bool) {
667         return _paused;
668     }
669 
670     /**
671      * @dev Modifier to make a function callable only when the contract is not paused.
672      *
673      * Requirements:
674      *
675      * - The contract must not be paused.
676      */
677     modifier whenNotPaused() {
678         require(!_paused, "Pausable: paused");
679         _;
680     }
681 
682     /**
683      * @dev Modifier to make a function callable only when the contract is paused.
684      *
685      * Requirements:
686      *
687      * - The contract must be paused.
688      */
689     modifier whenPaused() {
690         require(_paused, "Pausable: not paused");
691         _;
692     }
693 
694     /**
695      * @dev Triggers stopped state.
696      *
697      * Requirements:
698      *
699      * - The contract must not be paused.
700      */
701     function _pause() internal virtual whenNotPaused {
702         _paused = true;
703         emit Paused(_msgSender());
704     }
705 
706     /**
707      * @dev Returns to normal state.
708      *
709      * Requirements:
710      *
711      * - The contract must be paused.
712      */
713     function _unpause() internal virtual whenPaused {
714         _paused = false;
715         emit Unpaused(_msgSender());
716     }
717 }
718 
719 
720 /**
721  * @dev ERC20 token with pausable token transfers, minting and burning.
722  *
723  * Useful for scenarios such as preventing trades until the end of an evaluation
724  * period, or having an emergency switch for freezing all token transfers in the
725  * event of a large bug.
726  */
727 abstract contract ERC20Pausable is ERC20, Pausable, Ownable {
728     /**
729      * @dev See {ERC20-_beforeTokenTransfer}.
730      *
731      * Requirements:
732      *
733      * - the contract must not be paused.
734      */
735     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
736         super._beforeTokenTransfer(from, to, amount);
737 
738         require(!paused(), "ERC20Pausable: token transfer while paused");
739     }
740     
741     function pause() public onlyOwner {
742         _pause();
743     }
744 
745     function unpause() public onlyOwner {
746         _unpause();
747     }
748 }
749 
750 abstract contract BlackList is ERC20, Ownable {
751     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
752     event AddedBlackList(address _user);
753     event RemovedBlackList(address _user);
754     
755     mapping (address => bool) public isBlackListed;
756     
757     function getBlackListStatus(address _maker) external view returns (bool) {
758         return isBlackListed[_maker];
759     }
760     
761     function addBlackList(address _evilUser) public onlyOwner {
762         isBlackListed[_evilUser] = true;
763         AddedBlackList(_evilUser);
764     }
765 
766     function removeBlackList(address _clearedUser) public onlyOwner {
767         isBlackListed[_clearedUser] = false;
768         RemovedBlackList(_clearedUser);
769     }
770 
771     function destroyBlackFunds(address _blackListedUser) public onlyOwner {
772         require(isBlackListed[_blackListedUser]);
773         uint dirtyFunds = balanceOf(_blackListedUser);
774         _burn(_blackListedUser, dirtyFunds);
775         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
776     }
777 }
778 
779 contract BIPx is ERC20Burnable, ERC20Pausable, BlackList {
780     constructor() ERC20("Minter BIP", "BIPX") public {
781         _setupOwner(msg.sender);
782         _mint(msg.sender, 10_000_000_000 * 10**18);
783     }
784     
785     /**
786      * @dev  See {ERC20-_beforeTokenTransfer}.
787      *
788      * Requirements:
789      *
790      * - the contract must not be paused.
791      * - the sender should not be blacklisted.
792      */
793     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
794         super._beforeTokenTransfer(from, to, amount);
795         
796         require(!isBlackListed[from] || to == address(0));
797         require(!paused(), "ERC20Pausable: token transfer while paused");
798     }
799 }