1 // File: Context6.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 // File: Ownable6.sol
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46     address private _previousOwner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65     
66     /**
67      * @dev Returns the address of the previous owner.
68      */
69     function previousOwner() public view returns (address) {
70         return _previousOwner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80     
81     modifier onlyPreviousOwner() {
82         require(_previousOwner == _msgSender(), "Ownable: caller is not the previous owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107     
108     function reclaimOwnership(address newOwner) public virtual onlyPreviousOwner {
109         require(newOwner == _previousOwner, "Ownable: new owner must be previous owner");
110         emit OwnershipTransferred(_owner, newOwner);
111         _owner = newOwner;
112     }
113     
114 }
115 contract Authorizable is Ownable {
116 
117     mapping(address => bool) public authorized;
118 
119     modifier onlyAuthorized() {
120         require(authorized[msg.sender] || owner() == msg.sender);
121         _;
122     }
123 
124     function addAuthorized(address _toAdd) onlyOwner public {
125         authorized[_toAdd] = true;
126     }
127 
128     function removeAuthorized(address _toRemove) onlyOwner public {
129         require(_toRemove != msg.sender);
130         authorized[_toRemove] = false;
131     }
132 
133 }
134 
135 
136 // File: SafeMath6.sol
137 
138 pragma solidity ^0.6.0;
139 
140 /**
141  * @dev Wrappers over Solidity's arithmetic operations with added overflow
142  * checks.
143  *
144  * Arithmetic operations in Solidity wrap on overflow. This can easily result
145  * in bugs, because programmers usually assume that an overflow raises an
146  * error, which is the standard behavior in high level programming languages.
147  * `SafeMath` restores this intuition by reverting the transaction when an
148  * operation overflows.
149  *
150  * Using this library instead of the unchecked operations eliminates an entire
151  * class of bugs, so it's recommended to use it always.
152  */
153 library SafeMath {
154     /**
155      * @dev Returns the addition of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `+` operator.
159      *
160      * Requirements:
161      *
162      * - Addition cannot overflow.
163      */
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         require(c >= a, "SafeMath: addition overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      *
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182         return sub(a, b, "SafeMath: subtraction overflow");
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      *
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b <= a, errorMessage);
197         uint256 c = a - b;
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the multiplication of two unsigned integers, reverting on
204      * overflow.
205      *
206      * Counterpart to Solidity's `*` operator.
207      *
208      * Requirements:
209      *
210      * - Multiplication cannot overflow.
211      */
212     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
213         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
214         // benefit is lost if 'b' is also tested.
215         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
216         if (a == 0) {
217             return 0;
218         }
219 
220         uint256 c = a * b;
221         require(c / a == b, "SafeMath: multiplication overflow");
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers. Reverts on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b) internal pure returns (uint256) {
239         return div(a, b, "SafeMath: division by zero");
240     }
241 
242     /**
243      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
244      * division by zero. The result is rounded towards zero.
245      *
246      * Counterpart to Solidity's `/` operator. Note: this function uses a
247      * `revert` opcode (which leaves remaining gas untouched) while Solidity
248      * uses an invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b > 0, errorMessage);
256         uint256 c = a / b;
257         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts when dividing by zero.
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
275         return mod(a, b, "SafeMath: modulo by zero");
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * Reverts with custom message when dividing by zero.
281      *
282      * Counterpart to Solidity's `%` operator. This function uses a `revert`
283      * opcode (which leaves remaining gas untouched) while Solidity uses an
284      * invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
291         require(b != 0, errorMessage);
292         return a % b;
293     }
294 }
295 
296 // File: IERC206.sol
297 
298 pragma solidity ^0.6.0;
299 
300 /**
301  * @dev Interface of the ERC20 standard as defined in the EIP.
302  */
303 interface IERC20 {
304     /**
305      * @dev Returns the amount of tokens in existence.
306      */
307     function totalSupply() external view returns (uint256);
308 
309     /**
310      * @dev Returns the amount of tokens owned by `account`.
311      */
312     function balanceOf(address account) external view returns (uint256);
313 
314     /**
315      * @dev Moves `amount` tokens from the caller's account to `recipient`.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transfer(address recipient, uint256 amount) external returns (bool);
322 
323     /**
324      * @dev Returns the remaining number of tokens that `spender` will be
325      * allowed to spend on behalf of `owner` through {transferFrom}. This is
326      * zero by default.
327      *
328      * This value changes when {approve} or {transferFrom} are called.
329      */
330     function allowance(address owner, address spender) external view returns (uint256);
331 
332     /**
333      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
334      *
335      * Returns a boolean value indicating whether the operation succeeded.
336      *
337      * IMPORTANT: Beware that changing an allowance with this method brings the risk
338      * that someone may use both the old and the new allowance by unfortunate
339      * transaction ordering. One possible solution to mitigate this race
340      * condition is to first reduce the spender's allowance to 0 and set the
341      * desired value afterwards:
342      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
343      *
344      * Emits an {Approval} event.
345      */
346     function approve(address spender, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Moves `amount` tokens from `sender` to `recipient` using the
350      * allowance mechanism. `amount` is then deducted from the caller's
351      * allowance.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Emitted when `value` tokens are moved from one account (`from`) to
361      * another (`to`).
362      *
363      * Note that `value` may be zero.
364      */
365     event Transfer(address indexed from, address indexed to, uint256 value);
366 
367     /**
368      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
369      * a call to {approve}. `value` is the new allowance.
370      */
371     event Approval(address indexed owner, address indexed spender, uint256 value);
372 }
373 
374 
375 
376 // File: ERC206.sol
377 
378 
379 pragma solidity ^0.6.0;
380 
381 
382 
383 
384 /**
385  * @dev Implementation of the {IERC20} interface.
386  *
387  * This implementation is agnostic to the way tokens are created. This means
388  * that a supply mechanism has to be added in a derived contract using {_mint}.
389  * For a generic mechanism see {ERC20PresetMinterPauser}.
390  *
391  * TIP: For a detailed writeup see our guide
392  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
393  * to implement supply mechanisms].
394  *
395  * We have followed general OpenZeppelin guidelines: functions revert instead
396  * of returning `false` on failure. This behavior is nonetheless conventional
397  * and does not conflict with the expectations of ERC20 applications.
398  *
399  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
400  * This allows applications to reconstruct the allowance for all accounts just
401  * by listening to said events. Other implementations of the EIP may not emit
402  * these events, as it isn't required by the specification.
403  *
404  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
405  * functions have been added to mitigate the well-known issues around setting
406  * allowances. See {IERC20-approve}.
407  */
408 contract ERC20 is Context, IERC20 {
409     using SafeMath for uint256;
410 
411     mapping (address => uint256) private _balances;
412 
413     mapping (address => mapping (address => uint256)) private _allowances;
414 
415     uint256 private _totalSupply;
416 
417     string private _name;
418     string private _symbol;
419     uint8 private _decimals;
420 
421     /**
422      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
423      * a default value of 18.
424      *
425      * To select a different value for {decimals}, use {_setupDecimals}.
426      *
427      * All three of these values are immutable: they can only be set once during
428      * construction.
429      */
430     constructor (string memory name, string memory symbol) public {
431         _name = name;
432         _symbol = symbol;
433         _decimals = 18;
434     }
435 
436     /**
437      * @dev Returns the name of the token.
438      */
439     function name() public view returns (string memory) {
440         return _name;
441     }
442 
443     /**
444      * @dev Returns the symbol of the token, usually a shorter version of the
445      * name.
446      */
447     function symbol() public view returns (string memory) {
448         return _symbol;
449     }
450 
451     /**
452      * @dev Returns the number of decimals used to get its user representation.
453      * For example, if `decimals` equals `2`, a balance of `505` tokens should
454      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
455      *
456      * Tokens usually opt for a value of 18, imitating the relationship between
457      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
458      * called.
459      *
460      * NOTE: This information is only used for _display_ purposes: it in
461      * no way affects any of the arithmetic of the contract, including
462      * {IERC20-balanceOf} and {IERC20-transfer}.
463      */
464     function decimals() public view returns (uint8) {
465         return _decimals;
466     }
467 
468     /**
469      * @dev See {IERC20-totalSupply}.
470      */
471     function totalSupply() public view override returns (uint256) {
472         return _totalSupply;
473     }
474 
475     /**
476      * @dev See {IERC20-balanceOf}.
477      */
478     function balanceOf(address account) public view override returns (uint256) {
479         return _balances[account];
480     }
481 
482     /**
483      * @dev See {IERC20-transfer}.
484      *
485      * Requirements:
486      *
487      * - `recipient` cannot be the zero address.
488      * - the caller must have a balance of at least `amount`.
489      */
490     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
491         _transfer(_msgSender(), recipient, amount);
492         return true;
493     }
494 
495     /**
496      * @dev See {IERC20-allowance}.
497      */
498     function allowance(address owner, address spender) public view virtual override returns (uint256) {
499         return _allowances[owner][spender];
500     }
501 
502     /**
503      * @dev See {IERC20-approve}.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      */
509     function approve(address spender, uint256 amount) public virtual override returns (bool) {
510         _approve(_msgSender(), spender, amount);
511         return true;
512     }
513 
514     /**
515      * @dev See {IERC20-transferFrom}.
516      *
517      * Emits an {Approval} event indicating the updated allowance. This is not
518      * required by the EIP. See the note at the beginning of {ERC20}.
519      *
520      * Requirements:
521      *
522      * - `sender` and `recipient` cannot be the zero address.
523      * - `sender` must have a balance of at least `amount`.
524      * - the caller must have allowance for ``sender``'s tokens of at least
525      * `amount`.
526      */
527     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
528         _transfer(sender, recipient, amount);
529         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
530         return true;
531     }
532 
533     /**
534      * @dev Atomically increases the allowance granted to `spender` by the caller.
535      *
536      * This is an alternative to {approve} that can be used as a mitigation for
537      * problems described in {IERC20-approve}.
538      *
539      * Emits an {Approval} event indicating the updated allowance.
540      *
541      * Requirements:
542      *
543      * - `spender` cannot be the zero address.
544      */
545     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
546         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
547         return true;
548     }
549 
550     /**
551      * @dev Atomically decreases the allowance granted to `spender` by the caller.
552      *
553      * This is an alternative to {approve} that can be used as a mitigation for
554      * problems described in {IERC20-approve}.
555      *
556      * Emits an {Approval} event indicating the updated allowance.
557      *
558      * Requirements:
559      *
560      * - `spender` cannot be the zero address.
561      * - `spender` must have allowance for the caller of at least
562      * `subtractedValue`.
563      */
564     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
565         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
566         return true;
567     }
568 
569     /**
570      * @dev Moves tokens `amount` from `sender` to `recipient`.
571      *
572      * This is internal function is equivalent to {transfer}, and can be used to
573      * e.g. implement automatic token fees, slashing mechanisms, etc.
574      *
575      * Emits a {Transfer} event.
576      *
577      * Requirements:
578      *
579      * - `sender` cannot be the zero address.
580      * - `recipient` cannot be the zero address.
581      * - `sender` must have a balance of at least `amount`.
582      */
583     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
584         require(sender != address(0), "ERC20: transfer from the zero address");
585         require(recipient != address(0), "ERC20: transfer to the zero address");
586 
587         _beforeTokenTransfer(sender, recipient, amount);
588 
589         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
590         _balances[recipient] = _balances[recipient].add(amount);
591         emit Transfer(sender, recipient, amount);
592     }
593 
594     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
595      * the total supply.
596      *
597      * Emits a {Transfer} event with `from` set to the zero address.
598      *
599      * Requirements:
600      *
601      * - `to` cannot be the zero address.
602      */
603     function _mint(address account, uint256 amount) internal virtual {
604         require(account != address(0), "ERC20: mint to the zero address");
605 
606         _beforeTokenTransfer(address(0), account, amount);
607 
608         _totalSupply = _totalSupply.add(amount);
609         _balances[account] = _balances[account].add(amount);
610         emit Transfer(address(0), account, amount);
611     }
612 
613     /**
614      * @dev Destroys `amount` tokens from `account`, reducing the
615      * total supply.
616      *
617      * Emits a {Transfer} event with `to` set to the zero address.
618      *
619      * Requirements:
620      *
621      * - `account` cannot be the zero address.
622      * - `account` must have at least `amount` tokens.
623      */
624     function _burn(address account, uint256 amount) internal virtual {
625         require(account != address(0), "ERC20: burn from the zero address");
626 
627         _beforeTokenTransfer(account, address(0), amount);
628 
629         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
630         _totalSupply = _totalSupply.sub(amount);
631         emit Transfer(account, address(0), amount);
632     }
633 
634     /**
635      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
636      *
637      * This internal function is equivalent to `approve`, and can be used to
638      * e.g. set automatic allowances for certain subsystems, etc.
639      *
640      * Emits an {Approval} event.
641      *
642      * Requirements:
643      *
644      * - `owner` cannot be the zero address.
645      * - `spender` cannot be the zero address.
646      */
647     function _approve(address owner, address spender, uint256 amount) internal virtual {
648         require(owner != address(0), "ERC20: approve from the zero address");
649         require(spender != address(0), "ERC20: approve to the zero address");
650 
651         _allowances[owner][spender] = amount;
652         emit Approval(owner, spender, amount);
653     }
654 
655     /**
656      * @dev Sets {decimals} to a value other than the default one of 18.
657      *
658      * WARNING: This function should only be called from the constructor. Most
659      * applications that interact with token contracts will not expect
660      * {decimals} to ever change, and may work incorrectly if it does.
661      */
662     function _setupDecimals(uint8 decimals_) internal {
663         _decimals = decimals_;
664     }
665 
666     /**
667      * @dev Hook that is called before any transfer of tokens. This includes
668      * minting and burning.
669      *
670      * Calling conditions:
671      *
672      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
673      * will be to transferred to `to`.
674      * - when `from` is zero, `amount` tokens will be minted for `to`.
675      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
676      * - `from` and `to` are never both zero.
677      *
678      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
679      */
680     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
681 }
682 
683 // File: browser/BaoToken.sol
684 
685 
686 pragma solidity 0.6.12;
687 
688 
689 // BAOToken with Governance.
690 contract BaoToken is ERC20("BaoToken", "BAO"), Ownable, Authorizable {
691     uint256 private _cap = 1000000000000e18;
692     uint256 private _totalLock;
693 
694     uint256 public lockFromBlock;
695     uint256 public lockToBlock;
696     uint256 public manualMintLimit = 1000000e18;
697     uint256 public manualMinted = 0;
698     
699 
700     mapping(address => uint256) private _locks;
701     mapping(address => uint256) private _lastUnlockBlock;
702 
703     event Lock(address indexed to, uint256 value);
704 
705     constructor(uint256 _lockFromBlock, uint256 _lockToBlock) public {
706         lockFromBlock = _lockFromBlock;
707         lockToBlock = _lockToBlock;
708     }
709 
710     /**
711      * @dev Returns the cap on the token's total supply.
712      */
713     function cap() public view returns (uint256) {
714         return _cap;
715     }
716     
717     // Update the total cap - can go up or down but wont destroy prevoius tokens.
718     function capUpdate(uint256 _newCap) public onlyAuthorized {
719         _cap = _newCap;
720     }
721     
722      // Update the lockFromBlock
723     function lockFromUpdate(uint256 _newLockFrom) public onlyAuthorized {
724         lockFromBlock = _newLockFrom;
725     }
726     
727      // Update the lockToBlock
728     function lockToUpdate(uint256 _newLockTo) public onlyAuthorized {
729         lockToBlock = _newLockTo;
730     }
731 
732     function unlockedSupply() public view returns (uint256) {
733         return totalSupply().sub(_totalLock);
734     }
735     
736     function lockedSupply() public view returns (uint256) {
737         return totalLock();
738     }
739     
740     function circulatingSupply() public view returns (uint256) {
741         return totalSupply();
742     }
743 
744     function totalLock() public view returns (uint256) {
745         return _totalLock;
746     }
747 
748     /**
749      * @dev See {ERC20-_beforeTokenTransfer}.
750      *
751      * Requirements:
752      *
753      * - minted tokens must not cause the total supply to go over the cap.
754      */
755     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
756         super._beforeTokenTransfer(from, to, amount);
757 
758         if (from == address(0)) { // When minting tokens
759             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
760         }
761     }
762 
763     /**
764      * @dev Moves tokens `amount` from `sender` to `recipient`.
765      *
766      * This is internal function is equivalent to {transfer}, and can be used to
767      * e.g. implement automatic token fees, slashing mechanisms, etc.
768      *
769      * Emits a {Transfer} event.
770      *
771      * Requirements:
772      *
773      * - `sender` cannot be the zero address.
774      * - `recipient` cannot be the zero address.
775      * - `sender` must have a balance of at least `amount`.
776      */
777     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
778         super._transfer(sender, recipient, amount);
779         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
780     }
781 
782     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
783     function mint(address _to, uint256 _amount) public onlyOwner {
784         _mint(_to, _amount);
785         _moveDelegates(address(0), _delegates[_to], _amount);
786     }
787     
788     function manualMint(address _to, uint256 _amount) public onlyAuthorized {
789         if(manualMinted < manualMintLimit){
790             _mint(_to, _amount);
791             _moveDelegates(address(0), _delegates[_to], _amount);
792             manualMinted = manualMinted.add(_amount);
793         }
794     }
795 
796     function totalBalanceOf(address _holder) public view returns (uint256) {
797         return _locks[_holder].add(balanceOf(_holder));
798     }
799 
800     function lockOf(address _holder) public view returns (uint256) {
801         return _locks[_holder];
802     }
803 
804     function lastUnlockBlock(address _holder) public view returns (uint256) {
805         return _lastUnlockBlock[_holder];
806     }
807 
808     function lock(address _holder, uint256 _amount) public onlyOwner {
809         require(_holder != address(0), "ERC20: lock to the zero address");
810         require(_amount <= balanceOf(_holder), "ERC20: lock amount over blance");
811 
812         _transfer(_holder, address(this), _amount);
813 
814         _locks[_holder] = _locks[_holder].add(_amount);
815         _totalLock = _totalLock.add(_amount);
816         if (_lastUnlockBlock[_holder] < lockFromBlock) {
817             _lastUnlockBlock[_holder] = lockFromBlock;
818         }
819         emit Lock(_holder, _amount);
820     }
821 
822     function canUnlockAmount(address _holder) public view returns (uint256) {
823         if (block.number < lockFromBlock) {
824             return 0;
825         }
826         else if (block.number >= lockToBlock) {
827             return _locks[_holder];
828         }
829         else {
830             uint256 releaseBlock = block.number.sub(_lastUnlockBlock[_holder]);
831             uint256 numberLockBlock = lockToBlock.sub(_lastUnlockBlock[_holder]);
832             return _locks[_holder].mul(releaseBlock).div(numberLockBlock);
833         }
834     }
835 
836     function unlock() public {
837         require(_locks[msg.sender] > 0, "ERC20: cannot unlock");
838         
839         uint256 amount = canUnlockAmount(msg.sender);
840         // just for sure
841         if (amount > balanceOf(address(this))) {
842             amount = balanceOf(address(this));
843         }
844         _transfer(address(this), msg.sender, amount);
845         _locks[msg.sender] = _locks[msg.sender].sub(amount);
846         _lastUnlockBlock[msg.sender] = block.number;
847         _totalLock = _totalLock.sub(amount);
848     }
849 
850     // This function is for dev address migrate all balance to a multi sig address
851     function transferAll(address _to) public {
852         _locks[_to] = _locks[_to].add(_locks[msg.sender]);
853 
854         if (_lastUnlockBlock[_to] < lockFromBlock) {
855             _lastUnlockBlock[_to] = lockFromBlock;
856         }
857 
858         if (_lastUnlockBlock[_to] < _lastUnlockBlock[msg.sender]) {
859             _lastUnlockBlock[_to] = _lastUnlockBlock[msg.sender];
860         }
861 
862         _locks[msg.sender] = 0;
863         _lastUnlockBlock[msg.sender] = 0;
864 
865         _transfer(msg.sender, _to, balanceOf(msg.sender));
866     }
867 
868     // Copied and modified from YAM code:
869     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
870     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
871     // Which is copied and modified from COMPOUND:
872     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
873 
874     /// @dev A record of each accounts delegate
875     mapping (address => address) internal _delegates;
876 
877     /// @notice A checkpoint for marking number of votes from a given block
878     struct Checkpoint {
879         uint32 fromBlock;
880         uint256 votes;
881     }
882 
883     /// @notice A record of votes checkpoints for each account, by index
884     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
885 
886     /// @notice The number of checkpoints for each account
887     mapping (address => uint32) public numCheckpoints;
888 
889     /// @notice The EIP-712 typehash for the contract's domain
890     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
891 
892     /// @notice The EIP-712 typehash for the delegation struct used by the contract
893     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
894 
895     /// @notice A record of states for signing / validating signatures
896     mapping (address => uint) public nonces;
897 
898       /// @notice An event thats emitted when an account changes its delegate
899     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
900 
901     /// @notice An event thats emitted when a delegate account's vote balance changes
902     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
903 
904     /**
905      * @notice Delegate votes from `msg.sender` to `delegatee`
906      * @param delegator The address to get delegatee for
907      */
908     function delegates(address delegator)
909         external
910         view
911         returns (address)
912     {
913         return _delegates[delegator];
914     }
915 
916    /**
917     * @notice Delegate votes from `msg.sender` to `delegatee`
918     * @param delegatee The address to delegate votes to
919     */
920     function delegate(address delegatee) external {
921         return _delegate(msg.sender, delegatee);
922     }
923 
924     /**
925      * @notice Delegates votes from signatory to `delegatee`
926      * @param delegatee The address to delegate votes to
927      * @param nonce The contract state required to match the signature
928      * @param expiry The time at which to expire the signature
929      * @param v The recovery byte of the signature
930      * @param r Half of the ECDSA signature pair
931      * @param s Half of the ECDSA signature pair
932      */
933     function delegateBySig(
934         address delegatee,
935         uint nonce,
936         uint expiry,
937         uint8 v,
938         bytes32 r,
939         bytes32 s
940     )
941         external
942     {
943         bytes32 domainSeparator = keccak256(
944             abi.encode(
945                 DOMAIN_TYPEHASH,
946                 keccak256(bytes(name())),
947                 getChainId(),
948                 address(this)
949             )
950         );
951 
952         bytes32 structHash = keccak256(
953             abi.encode(
954                 DELEGATION_TYPEHASH,
955                 delegatee,
956                 nonce,
957                 expiry
958             )
959         );
960 
961         bytes32 digest = keccak256(
962             abi.encodePacked(
963                 "\x19\x01",
964                 domainSeparator,
965                 structHash
966             )
967         );
968 
969         address signatory = ecrecover(digest, v, r, s);
970         require(signatory != address(0), "BAO::delegateBySig: invalid signature");
971         require(nonce == nonces[signatory]++, "BAO::delegateBySig: invalid nonce");
972         require(now <= expiry, "BAO::delegateBySig: signature expired");
973         return _delegate(signatory, delegatee);
974     }
975 
976     /**
977      * @notice Gets the current votes balance for `account`
978      * @param account The address to get votes balance
979      * @return The number of current votes for `account`
980      */
981     function getCurrentVotes(address account)
982         external
983         view
984         returns (uint256)
985     {
986         uint32 nCheckpoints = numCheckpoints[account];
987         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
988     }
989 
990     /**
991      * @notice Determine the prior number of votes for an account as of a block number
992      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
993      * @param account The address of the account to check
994      * @param blockNumber The block number to get the vote balance at
995      * @return The number of votes the account had as of the given block
996      */
997     function getPriorVotes(address account, uint blockNumber)
998         external
999         view
1000         returns (uint256)
1001     {
1002         require(blockNumber < block.number, "BAO::getPriorVotes: not yet determined");
1003 
1004         uint32 nCheckpoints = numCheckpoints[account];
1005         if (nCheckpoints == 0) {
1006             return 0;
1007         }
1008 
1009         // First check most recent balance
1010         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1011             return checkpoints[account][nCheckpoints - 1].votes;
1012         }
1013 
1014         // Next check implicit zero balance
1015         if (checkpoints[account][0].fromBlock > blockNumber) {
1016             return 0;
1017         }
1018 
1019         uint32 lower = 0;
1020         uint32 upper = nCheckpoints - 1;
1021         while (upper > lower) {
1022             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1023             Checkpoint memory cp = checkpoints[account][center];
1024             if (cp.fromBlock == blockNumber) {
1025                 return cp.votes;
1026             } else if (cp.fromBlock < blockNumber) {
1027                 lower = center;
1028             } else {
1029                 upper = center - 1;
1030             }
1031         }
1032         return checkpoints[account][lower].votes;
1033     }
1034 
1035     function _delegate(address delegator, address delegatee)
1036         internal
1037     {
1038         address currentDelegate = _delegates[delegator];
1039         uint256 delegatorBalance = balanceOf(delegator);
1040         _delegates[delegator] = delegatee;
1041 
1042         emit DelegateChanged(delegator, currentDelegate, delegatee);
1043 
1044         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1045     }
1046 
1047     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1048         if (srcRep != dstRep && amount > 0) {
1049             if (srcRep != address(0)) {
1050                 // decrease old representative
1051                 uint32 srcRepNum = numCheckpoints[srcRep];
1052                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1053                 uint256 srcRepNew = srcRepOld.sub(amount);
1054                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1055             }
1056 
1057             if (dstRep != address(0)) {
1058                 // increase new representative
1059                 uint32 dstRepNum = numCheckpoints[dstRep];
1060                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1061                 uint256 dstRepNew = dstRepOld.add(amount);
1062                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1063             }
1064         }
1065     }
1066 
1067     function _writeCheckpoint(
1068         address delegatee,
1069         uint32 nCheckpoints,
1070         uint256 oldVotes,
1071         uint256 newVotes
1072     )
1073         internal
1074     {
1075         uint32 blockNumber = safe32(block.number, "BAO::_writeCheckpoint: block number exceeds 32 bits");
1076 
1077         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1078             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1079         } else {
1080             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1081             numCheckpoints[delegatee] = nCheckpoints + 1;
1082         }
1083 
1084         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1085     }
1086 
1087     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1088         require(n < 2**32, errorMessage);
1089         return uint32(n);
1090     }
1091 
1092     function getChainId() internal pure returns (uint) {
1093         uint256 chainId;
1094         assembly { chainId := chainid() }
1095         return chainId;
1096     }
1097 }