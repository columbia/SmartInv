1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: @openzeppelin/contracts/math/SafeMath.sol
107 
108 pragma solidity >=0.6.0 <0.8.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
267 
268 pragma solidity >=0.6.0 <0.8.0;
269 
270 
271 
272 
273 /**
274  * @dev Implementation of the {IERC20} interface.
275  *
276  * This implementation is agnostic to the way tokens are created. This means
277  * that a supply mechanism has to be added in a derived contract using {_mint}.
278  * For a generic mechanism see {ERC20PresetMinterPauser}.
279  *
280  * TIP: For a detailed writeup see our guide
281  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
282  * to implement supply mechanisms].
283  *
284  * We have followed general OpenZeppelin guidelines: functions revert instead
285  * of returning `false` on failure. This behavior is nonetheless conventional
286  * and does not conflict with the expectations of ERC20 applications.
287  *
288  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
289  * This allows applications to reconstruct the allowance for all accounts just
290  * by listening to said events. Other implementations of the EIP may not emit
291  * these events, as it isn't required by the specification.
292  *
293  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
294  * functions have been added to mitigate the well-known issues around setting
295  * allowances. See {IERC20-approve}.
296  */
297 contract ERC20 is Context, IERC20 {
298     using SafeMath for uint256;
299 
300     mapping (address => uint256) private _balances;
301 
302     mapping (address => mapping (address => uint256)) private _allowances;
303 
304     uint256 private _totalSupply;
305 
306     string private _name;
307     string private _symbol;
308     uint8 private _decimals;
309 
310     /**
311      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
312      * a default value of 18.
313      *
314      * To select a different value for {decimals}, use {_setupDecimals}.
315      *
316      * All three of these values are immutable: they can only be set once during
317      * construction.
318      */
319     constructor (string memory name_, string memory symbol_) public {
320         _name = name_;
321         _symbol = symbol_;
322         _decimals = 18;
323     }
324 
325     /**
326      * @dev Returns the name of the token.
327      */
328     function name() public view returns (string memory) {
329         return _name;
330     }
331 
332     /**
333      * @dev Returns the symbol of the token, usually a shorter version of the
334      * name.
335      */
336     function symbol() public view returns (string memory) {
337         return _symbol;
338     }
339 
340     /**
341      * @dev Returns the number of decimals used to get its user representation.
342      * For example, if `decimals` equals `2`, a balance of `505` tokens should
343      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
344      *
345      * Tokens usually opt for a value of 18, imitating the relationship between
346      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
347      * called.
348      *
349      * NOTE: This information is only used for _display_ purposes: it in
350      * no way affects any of the arithmetic of the contract, including
351      * {IERC20-balanceOf} and {IERC20-transfer}.
352      */
353     function decimals() public view returns (uint8) {
354         return _decimals;
355     }
356 
357     /**
358      * @dev See {IERC20-totalSupply}.
359      */
360     function totalSupply() public view override returns (uint256) {
361         return _totalSupply;
362     }
363 
364     /**
365      * @dev See {IERC20-balanceOf}.
366      */
367     function balanceOf(address account) public view override returns (uint256) {
368         return _balances[account];
369     }
370 
371     /**
372      * @dev See {IERC20-transfer}.
373      *
374      * Requirements:
375      *
376      * - `recipient` cannot be the zero address.
377      * - the caller must have a balance of at least `amount`.
378      */
379     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
380         _transfer(_msgSender(), recipient, amount);
381         return true;
382     }
383 
384     /**
385      * @dev See {IERC20-allowance}.
386      */
387     function allowance(address owner, address spender) public view virtual override returns (uint256) {
388         return _allowances[owner][spender];
389     }
390 
391     /**
392      * @dev See {IERC20-approve}.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      */
398     function approve(address spender, uint256 amount) public virtual override returns (bool) {
399         _approve(_msgSender(), spender, amount);
400         return true;
401     }
402 
403     /**
404      * @dev See {IERC20-transferFrom}.
405      *
406      * Emits an {Approval} event indicating the updated allowance. This is not
407      * required by the EIP. See the note at the beginning of {ERC20}.
408      *
409      * Requirements:
410      *
411      * - `sender` and `recipient` cannot be the zero address.
412      * - `sender` must have a balance of at least `amount`.
413      * - the caller must have allowance for ``sender``'s tokens of at least
414      * `amount`.
415      */
416     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
417         _transfer(sender, recipient, amount);
418         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
419         return true;
420     }
421 
422     /**
423      * @dev Atomically increases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      */
434     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
435         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
436         return true;
437     }
438 
439     /**
440      * @dev Atomically decreases the allowance granted to `spender` by the caller.
441      *
442      * This is an alternative to {approve} that can be used as a mitigation for
443      * problems described in {IERC20-approve}.
444      *
445      * Emits an {Approval} event indicating the updated allowance.
446      *
447      * Requirements:
448      *
449      * - `spender` cannot be the zero address.
450      * - `spender` must have allowance for the caller of at least
451      * `subtractedValue`.
452      */
453     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
454         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
455         return true;
456     }
457 
458     /**
459      * @dev Moves tokens `amount` from `sender` to `recipient`.
460      *
461      * This is internal function is equivalent to {transfer}, and can be used to
462      * e.g. implement automatic token fees, slashing mechanisms, etc.
463      *
464      * Emits a {Transfer} event.
465      *
466      * Requirements:
467      *
468      * - `sender` cannot be the zero address.
469      * - `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      */
472     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
473         require(sender != address(0), "ERC20: transfer from the zero address");
474         require(recipient != address(0), "ERC20: transfer to the zero address");
475 
476         _beforeTokenTransfer(sender, recipient, amount);
477 
478         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
479         _balances[recipient] = _balances[recipient].add(amount);
480         emit Transfer(sender, recipient, amount);
481     }
482 
483     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
484      * the total supply.
485      *
486      * Emits a {Transfer} event with `from` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `to` cannot be the zero address.
491      */
492     function _mint(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: mint to the zero address");
494 
495         _beforeTokenTransfer(address(0), account, amount);
496 
497         _totalSupply = _totalSupply.add(amount);
498         _balances[account] = _balances[account].add(amount);
499         emit Transfer(address(0), account, amount);
500     }
501 
502     /**
503      * @dev Destroys `amount` tokens from `account`, reducing the
504      * total supply.
505      *
506      * Emits a {Transfer} event with `to` set to the zero address.
507      *
508      * Requirements:
509      *
510      * - `account` cannot be the zero address.
511      * - `account` must have at least `amount` tokens.
512      */
513     function _burn(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: burn from the zero address");
515 
516         _beforeTokenTransfer(account, address(0), amount);
517 
518         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
519         _totalSupply = _totalSupply.sub(amount);
520         emit Transfer(account, address(0), amount);
521     }
522 
523     /**
524      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
525      *
526      * This internal function is equivalent to `approve`, and can be used to
527      * e.g. set automatic allowances for certain subsystems, etc.
528      *
529      * Emits an {Approval} event.
530      *
531      * Requirements:
532      *
533      * - `owner` cannot be the zero address.
534      * - `spender` cannot be the zero address.
535      */
536     function _approve(address owner, address spender, uint256 amount) internal virtual {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     /**
545      * @dev Sets {decimals} to a value other than the default one of 18.
546      *
547      * WARNING: This function should only be called from the constructor. Most
548      * applications that interact with token contracts will not expect
549      * {decimals} to ever change, and may work incorrectly if it does.
550      */
551     function _setupDecimals(uint8 decimals_) internal {
552         _decimals = decimals_;
553     }
554 
555     /**
556      * @dev Hook that is called before any transfer of tokens. This includes
557      * minting and burning.
558      *
559      * Calling conditions:
560      *
561      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
562      * will be to transferred to `to`.
563      * - when `from` is zero, `amount` tokens will be minted for `to`.
564      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
565      * - `from` and `to` are never both zero.
566      *
567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
568      */
569     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
570 }
571 
572 // File: @openzeppelin/contracts/access/Ownable.sol
573 
574 pragma solidity >=0.6.0 <0.8.0;
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
588 abstract contract Ownable is Context {
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
640 // File: contracts/Authorizable.sol
641 
642 pragma solidity 0.6.12;
643 
644 
645 contract Authorizable is Ownable {
646 
647     mapping(address => bool) public authorized;
648 
649     modifier onlyAuthorized() {
650         require(authorized[msg.sender] || owner() == msg.sender);
651         _;
652     }
653 
654     function addAuthorized(address _toAdd) onlyOwner public {
655         authorized[_toAdd] = true;
656     }
657 
658     function removeAuthorized(address _toRemove) onlyOwner public {
659         require(_toRemove != msg.sender);
660         authorized[_toRemove] = false;
661     }
662 
663 
664 }
665 
666 // File: contracts/DogenToken.sol
667 
668 pragma solidity 0.6.12;
669 
670 
671 
672 
673 // DogenToken with Governance.
674 contract DogenToken is ERC20("DogenToken", "DOGEN"), Ownable, Authorizable {
675     uint256 private _cap = 420000000000e18;
676     uint256 private _totalLock;
677 
678     uint256 public lockFromBlock;
679     uint256 public lockToBlock;
680     uint256 public manualMintLimit = 1000000e18;
681     uint256 public manualMinted = 0;
682 
683 
684     mapping(address => uint256) private _locks;
685     mapping(address => uint256) private _lastUnlockBlock;
686 
687     event Lock(address indexed to, uint256 value);
688 
689     constructor(uint256 _lockFromBlock, uint256 _lockToBlock) public {
690         lockFromBlock = _lockFromBlock;
691         lockToBlock = _lockToBlock;
692     }
693 
694     /**
695      * @dev Returns the cap on the token's total supply.
696      */
697     function cap() public view returns (uint256) {
698         return _cap;
699     }
700 
701     // Update the total cap - can go up or down but wont destroy prevoius tokens.
702     function capUpdate(uint256 _newCap) public onlyAuthorized {
703         _cap = _newCap;
704     }
705 
706      // Update the lockFromBlock
707     function lockFromUpdate(uint256 _newLockFrom) public onlyAuthorized {
708         lockFromBlock = _newLockFrom;
709     }
710 
711      // Update the lockToBlock
712     function lockToUpdate(uint256 _newLockTo) public onlyAuthorized {
713         lockToBlock = _newLockTo;
714     }
715 
716     function unlockedSupply() public view returns (uint256) {
717         return totalSupply().sub(_totalLock);
718     }
719 
720     function lockedSupply() public view returns (uint256) {
721         return totalLock();
722     }
723 
724     function circulatingSupply() public view returns (uint256) {
725         return totalSupply();
726     }
727 
728     function totalLock() public view returns (uint256) {
729         return _totalLock;
730     }
731 
732     /**
733      * @dev See {ERC20-_beforeTokenTransfer}.
734      *
735      * Requirements:
736      *
737      * - minted tokens must not cause the total supply to go over the cap.
738      */
739     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
740         super._beforeTokenTransfer(from, to, amount);
741 
742         if (from == address(0)) { // When minting tokens
743             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
744         }
745     }
746 
747     /**
748      * @dev Moves tokens `amount` from `sender` to `recipient`.
749      *
750      * This is internal function is equivalent to {transfer}, and can be used to
751      * e.g. implement automatic token fees, slashing mechanisms, etc.
752      *
753      * Emits a {Transfer} event.
754      *
755      * Requirements:
756      *
757      * - `sender` cannot be the zero address.
758      * - `recipient` cannot be the zero address.
759      * - `sender` must have a balance of at least `amount`.
760      */
761     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
762         super._transfer(sender, recipient, amount);
763         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
764     }
765 
766     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
767     function mint(address _to, uint256 _amount) public onlyOwner {
768         _mint(_to, _amount);
769         _moveDelegates(address(0), _delegates[_to], _amount);
770     }
771 
772     function manualMint(address _to, uint256 _amount) public onlyAuthorized {
773         if(manualMinted < manualMintLimit){
774             _mint(_to, _amount);
775             _moveDelegates(address(0), _delegates[_to], _amount);
776             manualMinted = manualMinted.add(_amount);
777         }
778     }
779 
780     function totalBalanceOf(address _holder) public view returns (uint256) {
781         return _locks[_holder].add(balanceOf(_holder));
782     }
783 
784     function lockOf(address _holder) public view returns (uint256) {
785         return _locks[_holder];
786     }
787 
788     function lastUnlockBlock(address _holder) public view returns (uint256) {
789         return _lastUnlockBlock[_holder];
790     }
791 
792     function lock(address _holder, uint256 _amount) public onlyOwner {
793         require(_holder != address(0), "ERC20: lock to the zero address");
794         require(_amount <= balanceOf(_holder), "ERC20: lock amount over blance");
795 
796         _transfer(_holder, address(this), _amount);
797 
798         _locks[_holder] = _locks[_holder].add(_amount);
799         _totalLock = _totalLock.add(_amount);
800         if (_lastUnlockBlock[_holder] < lockFromBlock) {
801             _lastUnlockBlock[_holder] = lockFromBlock;
802         }
803         emit Lock(_holder, _amount);
804     }
805 
806     function canUnlockAmount(address _holder) public view returns (uint256) {
807         if (block.number < lockFromBlock) {
808             return 0;
809         }
810         else if (block.number >= lockToBlock) {
811             return _locks[_holder];
812         }
813         else {
814             uint256 releaseBlock = block.number.sub(_lastUnlockBlock[_holder]);
815             uint256 numberLockBlock = lockToBlock.sub(_lastUnlockBlock[_holder]);
816             return _locks[_holder].mul(releaseBlock).div(numberLockBlock);
817         }
818     }
819 
820     function unlock() public {
821         require(_locks[msg.sender] > 0, "ERC20: cannot unlock");
822 
823         uint256 amount = canUnlockAmount(msg.sender);
824         // just for sure
825         if (amount > balanceOf(address(this))) {
826             amount = balanceOf(address(this));
827         }
828         _transfer(address(this), msg.sender, amount);
829         _locks[msg.sender] = _locks[msg.sender].sub(amount);
830         _lastUnlockBlock[msg.sender] = block.number;
831         _totalLock = _totalLock.sub(amount);
832     }
833 
834     // This function is for dev address migrate all balance to a multi sig address
835     function transferAll(address _to) public {
836         _locks[_to] = _locks[_to].add(_locks[msg.sender]);
837 
838         if (_lastUnlockBlock[_to] < lockFromBlock) {
839             _lastUnlockBlock[_to] = lockFromBlock;
840         }
841 
842         if (_lastUnlockBlock[_to] < _lastUnlockBlock[msg.sender]) {
843             _lastUnlockBlock[_to] = _lastUnlockBlock[msg.sender];
844         }
845 
846         _locks[msg.sender] = 0;
847         _lastUnlockBlock[msg.sender] = 0;
848 
849         _transfer(msg.sender, _to, balanceOf(msg.sender));
850     }
851 
852     // Copied and modified from YAM code:
853     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
854     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
855     // Which is copied and modified from COMPOUND:
856     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
857 
858     /// @dev A record of each accounts delegate
859     mapping (address => address) internal _delegates;
860 
861     /// @notice A checkpoint for marking number of votes from a given block
862     struct Checkpoint {
863         uint32 fromBlock;
864         uint256 votes;
865     }
866 
867     /// @notice A record of votes checkpoints for each account, by index
868     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
869 
870     /// @notice The number of checkpoints for each account
871     mapping (address => uint32) public numCheckpoints;
872 
873     /// @notice The EIP-712 typehash for the contract's domain
874     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
875 
876     /// @notice The EIP-712 typehash for the delegation struct used by the contract
877     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
878 
879     /// @notice A record of states for signing / validating signatures
880     mapping (address => uint) public nonces;
881 
882       /// @notice An event thats emitted when an account changes its delegate
883     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
884 
885     /// @notice An event thats emitted when a delegate account's vote balance changes
886     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
887 
888     /**
889      * @notice Delegate votes from `msg.sender` to `delegatee`
890      * @param delegator The address to get delegatee for
891      */
892     function delegates(address delegator)
893         external
894         view
895         returns (address)
896     {
897         return _delegates[delegator];
898     }
899 
900    /**
901     * @notice Delegate votes from `msg.sender` to `delegatee`
902     * @param delegatee The address to delegate votes to
903     */
904     function delegate(address delegatee) external {
905         return _delegate(msg.sender, delegatee);
906     }
907 
908     /**
909      * @notice Delegates votes from signatory to `delegatee`
910      * @param delegatee The address to delegate votes to
911      * @param nonce The contract state required to match the signature
912      * @param expiry The time at which to expire the signature
913      * @param v The recovery byte of the signature
914      * @param r Half of the ECDSA signature pair
915      * @param s Half of the ECDSA signature pair
916      */
917     function delegateBySig(
918         address delegatee,
919         uint nonce,
920         uint expiry,
921         uint8 v,
922         bytes32 r,
923         bytes32 s
924     )
925         external
926     {
927         bytes32 domainSeparator = keccak256(
928             abi.encode(
929                 DOMAIN_TYPEHASH,
930                 keccak256(bytes(name())),
931                 getChainId(),
932                 address(this)
933             )
934         );
935 
936         bytes32 structHash = keccak256(
937             abi.encode(
938                 DELEGATION_TYPEHASH,
939                 delegatee,
940                 nonce,
941                 expiry
942             )
943         );
944 
945         bytes32 digest = keccak256(
946             abi.encodePacked(
947                 "\x19\x01",
948                 domainSeparator,
949                 structHash
950             )
951         );
952 
953         address signatory = ecrecover(digest, v, r, s);
954         require(signatory != address(0), "DOGEN::delegateBySig: invalid signature");
955         require(nonce == nonces[signatory]++, "DOGEN::delegateBySig: invalid nonce");
956         require(now <= expiry, "DOGEN::delegateBySig: signature expired");
957         return _delegate(signatory, delegatee);
958     }
959 
960     /**
961      * @notice Gets the current votes balance for `account`
962      * @param account The address to get votes balance
963      * @return The number of current votes for `account`
964      */
965     function getCurrentVotes(address account)
966         external
967         view
968         returns (uint256)
969     {
970         uint32 nCheckpoints = numCheckpoints[account];
971         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
972     }
973 
974     /**
975      * @notice Determine the prior number of votes for an account as of a block number
976      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
977      * @param account The address of the account to check
978      * @param blockNumber The block number to get the vote balance at
979      * @return The number of votes the account had as of the given block
980      */
981     function getPriorVotes(address account, uint blockNumber)
982         external
983         view
984         returns (uint256)
985     {
986         require(blockNumber < block.number, "DOGEN::getPriorVotes: not yet determined");
987 
988         uint32 nCheckpoints = numCheckpoints[account];
989         if (nCheckpoints == 0) {
990             return 0;
991         }
992 
993         // First check most recent balance
994         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
995             return checkpoints[account][nCheckpoints - 1].votes;
996         }
997 
998         // Next check implicit zero balance
999         if (checkpoints[account][0].fromBlock > blockNumber) {
1000             return 0;
1001         }
1002 
1003         uint32 lower = 0;
1004         uint32 upper = nCheckpoints - 1;
1005         while (upper > lower) {
1006             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1007             Checkpoint memory cp = checkpoints[account][center];
1008             if (cp.fromBlock == blockNumber) {
1009                 return cp.votes;
1010             } else if (cp.fromBlock < blockNumber) {
1011                 lower = center;
1012             } else {
1013                 upper = center - 1;
1014             }
1015         }
1016         return checkpoints[account][lower].votes;
1017     }
1018 
1019     function _delegate(address delegator, address delegatee)
1020         internal
1021     {
1022         address currentDelegate = _delegates[delegator];
1023         uint256 delegatorBalance = balanceOf(delegator);
1024         _delegates[delegator] = delegatee;
1025 
1026         emit DelegateChanged(delegator, currentDelegate, delegatee);
1027 
1028         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1029     }
1030 
1031     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1032         if (srcRep != dstRep && amount > 0) {
1033             if (srcRep != address(0)) {
1034                 // decrease old representative
1035                 uint32 srcRepNum = numCheckpoints[srcRep];
1036                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1037                 uint256 srcRepNew = srcRepOld.sub(amount);
1038                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1039             }
1040 
1041             if (dstRep != address(0)) {
1042                 // increase new representative
1043                 uint32 dstRepNum = numCheckpoints[dstRep];
1044                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1045                 uint256 dstRepNew = dstRepOld.add(amount);
1046                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1047             }
1048         }
1049     }
1050 
1051     function _writeCheckpoint(
1052         address delegatee,
1053         uint32 nCheckpoints,
1054         uint256 oldVotes,
1055         uint256 newVotes
1056     )
1057         internal
1058     {
1059         uint32 blockNumber = safe32(block.number, "DOGEN::_writeCheckpoint: block number exceeds 32 bits");
1060 
1061         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1062             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1063         } else {
1064             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1065             numCheckpoints[delegatee] = nCheckpoints + 1;
1066         }
1067 
1068         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1069     }
1070 
1071     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1072         require(n < 2**32, errorMessage);
1073         return uint32(n);
1074     }
1075 
1076     function getChainId() internal pure returns (uint) {
1077         uint256 chainId;
1078         assembly { chainId := chainid() }
1079         return chainId;
1080     }
1081 }