1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      */
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the multiplication of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `*` operator.
67      *
68      * Requirements:
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0, errorMessage);
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts with custom message when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b != 0, errorMessage);
148         return a % b;
149     }
150 }
151 
152 /**
153  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
154  * the optional functions; to access them see {ERC20Detailed}.
155  */
156 interface IERC20 {
157     /**
158      * @dev Returns the amount of tokens in existence.
159      */
160     function totalSupply() external view returns (uint256);
161 
162     /**
163      * @dev Returns the amount of tokens owned by `account`.
164      */
165     function balanceOf(address account) external view returns (uint256);
166 
167     /**
168      * @dev Moves `amount` tokens from the caller's account to `recipient`.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transfer(address recipient, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Returns the remaining number of tokens that `spender` will be
178      * allowed to spend on behalf of `owner` through {transferFrom}. This is
179      * zero by default.
180      *
181      * This value changes when {approve} or {transferFrom} are called.
182      */
183     function allowance(address owner, address spender) external view returns (uint256);
184 
185     /**
186      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * IMPORTANT: Beware that changing an allowance with this method brings the risk
191      * that someone may use both the old and the new allowance by unfortunate
192      * transaction ordering. One possible solution to mitigate this race
193      * condition is to first reduce the spender's allowance to 0 and set the
194      * desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      *
197      * Emits an {Approval} event.
198      */
199     function approve(address spender, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Moves `amount` tokens from `sender` to `recipient` using the
203      * allowance mechanism. `amount` is then deducted from the caller's
204      * allowance.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Emitted when `value` tokens are moved from one account (`from`) to
214      * another (`to`).
215      *
216      * Note that `value` may be zero.
217      */
218     event Transfer(address indexed from, address indexed to, uint256 value);
219 
220     /**
221      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
222      * a call to {approve}. `value` is the new allowance.
223      */
224     event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 /**
228  * @dev Optional functions from the ERC20 standard.
229  */
230 abstract contract ERC20Detailed is IERC20 {
231     string private _name;
232     string private _symbol;
233     uint8 private _decimals;
234 
235     /**
236      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
237      * these values are immutable: they can only be set once during
238      * construction.
239      */
240     constructor (string memory name, string memory symbol, uint8 decimals) public {
241         _name = name;
242         _symbol = symbol;
243         _decimals = decimals;
244     }
245 
246     /**
247      * @dev Returns the name of the token.
248      */
249     function name() public view returns (string memory) {
250         return _name;
251     }
252 
253     /**
254      * @dev Returns the symbol of the token, usually a shorter version of the
255      * name.
256      */
257     function symbol() public view returns (string memory) {
258         return _symbol;
259     }
260 
261     /**
262      * @dev Returns the number of decimals used to get its user representation.
263      * For example, if `decimals` equals `2`, a balance of `505` tokens should
264      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
265      *
266      * Tokens usually opt for a value of 18, imitating the relationship between
267      * Ether and Wei.
268      *
269      * NOTE: This information is only used for _display_ purposes: it in
270      * no way affects any of the arithmetic of the contract, including
271      * {IERC20-balanceOf} and {IERC20-transfer}.
272      */
273     function decimals() public view returns (uint8) {
274         return _decimals;
275     }
276 }
277 
278 /*
279  * @dev Provides information about the current execution context, including the
280  * sender of the transaction and its data. While these are generally available
281  * via msg.sender and msg.data, they should not be accessed in such a direct
282  * manner, since when dealing with GSN meta-transactions the account sending and
283  * paying for execution may not be the actual sender (as far as an application
284  * is concerned).
285  *
286  * This contract is only required for intermediate, library-like contracts.
287  */
288 contract Context {
289     // Empty internal constructor, to prevent people from mistakenly deploying
290     // an instance of this contract, which should be used via inheritance.
291     constructor () internal { }
292 
293     function _msgSender() internal view virtual returns (address payable) {
294         return msg.sender;
295     }
296 
297     function _msgData() internal view virtual returns (bytes memory) {
298         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
299         return msg.data;
300     }
301 }
302 
303 /**
304  * @dev Implementation of the {IERC20} interface.
305  *
306  * This implementation is agnostic to the way tokens are created. This means
307  * that a supply mechanism has to be added in a derived contract using {_mint}.
308  * For a generic mechanism see {ERC20Mintable}.
309  *
310  * TIP: For a detailed writeup see our guide
311  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
312  * to implement supply mechanisms].
313  *
314  * We have followed general OpenZeppelin guidelines: functions revert instead
315  * of returning `false` on failure. This behavior is nonetheless conventional
316  * and does not conflict with the expectations of ERC20 applications.
317  *
318  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
319  * This allows applications to reconstruct the allowance for all accounts just
320  * by listening to said events. Other implementations of the EIP may not emit
321  * these events, as it isn't required by the specification.
322  *
323  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
324  * functions have been added to mitigate the well-known issues around setting
325  * allowances. See {IERC20-approve}.
326  */
327 contract ERC20 is Context, IERC20 {
328     using SafeMath for uint256;
329 
330     mapping (address => uint256) private _balances;
331 
332     mapping (address => mapping (address => uint256)) private _allowances;
333 
334     uint256 private _totalSupply;
335 
336     /**
337      * @dev See {IERC20-totalSupply}.
338      */
339     function totalSupply() public view override returns (uint256) {
340         return _totalSupply;
341     }
342 
343     /**
344      * @dev See {IERC20-balanceOf}.
345      */
346     function balanceOf(address account) public view override returns (uint256) {
347         return _balances[account];
348     }
349 
350     /**
351      * @dev See {IERC20-transfer}.
352      *
353      * Requirements:
354      *
355      * - `recipient` cannot be the zero address.
356      * - the caller must have a balance of at least `amount`.
357      */
358     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
359         _transfer(_msgSender(), recipient, amount);
360         return true;
361     }
362 
363     /**
364      * @dev See {IERC20-allowance}.
365      */
366     function allowance(address owner, address spender) public view virtual override returns (uint256) {
367         return _allowances[owner][spender];
368     }
369 
370     /**
371      * @dev See {IERC20-approve}.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function approve(address spender, uint256 amount) public virtual override returns (bool) {
378         _approve(_msgSender(), spender, amount);
379         return true;
380     }
381 
382     /**
383      * @dev See {IERC20-transferFrom}.
384      *
385      * Emits an {Approval} event indicating the updated allowance. This is not
386      * required by the EIP. See the note at the beginning of {ERC20};
387      *
388      * Requirements:
389      * - `sender` and `recipient` cannot be the zero address.
390      * - `sender` must have a balance of at least `amount`.
391      * - the caller must have allowance for `sender`'s tokens of at least
392      * `amount`.
393      */
394     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
395         _transfer(sender, recipient, amount);
396         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
397         return true;
398     }
399 
400     /**
401      * @dev Atomically increases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      */
412     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
413         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
414         return true;
415     }
416 
417     /**
418      * @dev Atomically decreases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      * - `spender` must have allowance for the caller of at least
429      * `subtractedValue`.
430      */
431     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
432         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
433         return true;
434     }
435 
436     /**
437      * @dev Moves tokens `amount` from `sender` to `recipient`.
438      *
439      * This is internal function is equivalent to {transfer}, and can be used to
440      * e.g. implement automatic token fees, slashing mechanisms, etc.
441      *
442      * Emits a {Transfer} event.
443      *
444      * Requirements:
445      *
446      * - `sender` cannot be the zero address.
447      * - `recipient` cannot be the zero address.
448      * - `sender` must have a balance of at least `amount`.
449      */
450     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
451         require(sender != address(0), "ERC20: transfer from the zero address");
452         require(recipient != address(0), "ERC20: transfer to the zero address");
453 
454         _beforeTokenTransfer(sender, recipient, amount);
455 
456         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
457         _balances[recipient] = _balances[recipient].add(amount);
458         emit Transfer(sender, recipient, amount);
459     }
460 
461     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
462      * the total supply.
463      *
464      * Emits a {Transfer} event with `from` set to the zero address.
465      *
466      * Requirements
467      *
468      * - `to` cannot be the zero address.
469      */
470     function _mint(address account, uint256 amount) internal virtual {
471         require(account != address(0), "ERC20: mint to the zero address");
472 
473         _beforeTokenTransfer(address(0), account, amount);
474 
475         _totalSupply = _totalSupply.add(amount);
476         _balances[account] = _balances[account].add(amount);
477         emit Transfer(address(0), account, amount);
478     }
479 
480     /**
481      * @dev Destroys `amount` tokens from `account`, reducing the
482      * total supply.
483      *
484      * Emits a {Transfer} event with `to` set to the zero address.
485      *
486      * Requirements
487      *
488      * - `account` cannot be the zero address.
489      * - `account` must have at least `amount` tokens.
490      */
491     function _burn(address account, uint256 amount) internal virtual {
492         require(account != address(0), "ERC20: burn from the zero address");
493 
494         _beforeTokenTransfer(account, address(0), amount);
495 
496         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
497         _totalSupply = _totalSupply.sub(amount);
498         emit Transfer(account, address(0), amount);
499     }
500 
501     /**
502      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
503      *
504      * This is internal function is equivalent to `approve`, and can be used to
505      * e.g. set automatic allowances for certain subsystems, etc.
506      *
507      * Emits an {Approval} event.
508      *
509      * Requirements:
510      *
511      * - `owner` cannot be the zero address.
512      * - `spender` cannot be the zero address.
513      */
514     function _approve(address owner, address spender, uint256 amount) internal virtual {
515         require(owner != address(0), "ERC20: approve from the zero address");
516         require(spender != address(0), "ERC20: approve to the zero address");
517 
518         _allowances[owner][spender] = amount;
519         emit Approval(owner, spender, amount);
520     }
521 
522     /**
523      * @dev Hook that is called before any transfer of tokens. This includes
524      * minting and burning.
525      *
526      * Calling conditions:
527      *
528      * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
529      * will be to transferred to `to`.
530      * - when `from` is zero, `amount` tokens will be minted for `to`.
531      * - when `to` is zero, `amount` of `from`'s tokens will be burned.
532      * - `from` and `to` are never both zero.
533      *
534      * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
535      */
536     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
537 }
538 
539 /**
540  * @dev Contract module which allows children to implement an emergency stop
541  * mechanism that can be triggered by an authorized account.
542  *
543  * This module is used through inheritance. It will make available the
544  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
545  * the functions of your contract. Note that they will not be pausable by
546  * simply including this module, only once the modifiers are put in place.
547  */
548 contract TargetPausable is Context {
549     /**
550      * @dev Emitted when the pause is triggered by a pauser (`account`).
551      */
552     event TargetPaused(address target, address account);
553 
554     /**
555      * @dev Emitted when the pause is lifted by a pauser (`account`).
556      */
557     event Unpaused(address target, address account);
558 
559     mapping (address => bool) private _targetpaused;
560 
561     /**
562      * @dev Returns true if the contract is paused, and false otherwise.
563      */
564     function paused(address target) public view returns (bool) {
565         return _targetpaused[target];
566     }
567 
568     /**
569      * @dev Called by a pauser to pause, triggers stopped state.
570      */
571     function _pause(address target) internal virtual {
572         _targetpaused[target] = true;
573         emit TargetPaused(target, _msgSender());
574     }
575 
576     /**
577      * @dev Called by a pauser to unpause, returns to normal state.
578      */
579     function _unpause(address target) internal virtual {
580         _targetpaused[target] = false;
581         emit TargetPaused(target, _msgSender());
582     }
583 }
584 
585 /**
586  * @title Pausable token
587  * @dev ERC20 with pausable transfers and allowances.
588  *
589  * Useful for scenarios such as preventing trades until the end of an evaluation
590  * period, or having an emergency switch for freezing all token transfers in the
591  * event of a large bug.
592  */
593 contract ERC20TargetPausable is ERC20, TargetPausable {
594     /**
595      * @dev See {ERC20-_beforeTokenTransfer}.
596      *
597      * Requirements:
598      *
599      * - the contract must not be paused.
600      */
601     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
602         super._beforeTokenTransfer(from, to, amount);
603 
604         require(!paused(from), "ERC20Pausable: token transfer while paused");
605     }
606 }
607 
608 /**
609  * @dev Contract module which provides a basic access control mechanism, where
610  * there is an account (an owner) that can be granted exclusive access to
611  * specific functions.
612  *
613  * By default, the owner account will be the one that deploys the contract. This
614  * can later be changed with {transferOwnership}.
615  *
616  * This module is used through inheritance. It will make available the modifier
617  * `onlyOwner`, which can be applied to your functions to restrict their use to
618  * the owner.
619  */
620 contract Ownable is Context {
621     address private _owner;
622 
623     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
624 
625     /**
626      * @dev Initializes the contract setting the deployer as the initial owner.
627      */
628     constructor () internal {
629         address msgSender = _msgSender();
630         _owner = msgSender;
631         emit OwnershipTransferred(address(0), msgSender);
632     }
633 
634     /**
635      * @dev Returns the address of the current owner.
636      */
637     function owner() public view returns (address) {
638         return _owner;
639     }
640 
641     /**
642      * @dev Throws if called by any account other than the owner.
643      */
644     modifier onlyOwner() {
645         require(_owner == _msgSender(), "Ownable: caller is not the owner");
646         _;
647     }
648 
649     /**
650      * @dev Leaves the contract without owner. It will not be possible to call
651      * `onlyOwner` functions anymore. Can only be called by the current owner.
652      *
653      * NOTE: Renouncing ownership will leave the contract without an owner,
654      * thereby removing any functionality that is only available to the owner.
655      */
656     function renounceOwnership() public virtual onlyOwner {
657         emit OwnershipTransferred(_owner, address(0));
658         _owner = address(0);
659     }
660 
661     /**
662      * @dev Transfers ownership of the contract to a new account (`newOwner`).
663      * Can only be called by the current owner.
664      */
665     function transferOwnership(address newOwner) public virtual onlyOwner {
666         _transferOwnership(newOwner);
667     }
668 
669     /**
670      * @dev Transfers ownership of the contract to a new account (`newOwner`).
671      */
672     function _transferOwnership(address newOwner) internal virtual {
673         require(newOwner != address(0), "Ownable: new owner is the zero address");
674         emit OwnershipTransferred(_owner, newOwner);
675         _owner = newOwner;
676     }
677 }
678 
679 contract ATHLON is ERC20Detailed, Ownable, ERC20TargetPausable {
680     constructor(uint256 initialSupply) 
681     ERC20Detailed("Athlon", "ALN", 18)
682     ERC20TargetPausable()
683     Ownable()
684     public {
685         _mint(msg.sender, initialSupply.mul(10 ** uint256(18)));
686     }
687 
688     function targetPause(address target) public onlyOwner {
689         _pause(target);
690     }
691 
692     function targetUnpause(address target) public onlyOwner {
693         _unpause(target);
694     }
695 }