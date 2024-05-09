1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9 
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 abstract contract Context {
81     function _msgSender() internal view returns (address) {
82         return msg.sender;
83     }
84 }
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 }
148 
149 /**
150  * @dev Contract module which provides a basic access control mechanism, where
151  * there is an account (an owner) that can be granted exclusive access to
152  * specific functions.
153  *
154  * By default, the owner account will be the one that deploys the contract. This
155  * can later be changed with {transferOwnership}.
156  *
157  * This module is used through inheritance. It will make available the modifier
158  * `onlyOwner`, which can be applied to your functions to restrict their use to
159  * the owner.
160  */
161 contract Ownable is Context {
162     address private _owner;
163 
164     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165 
166     /**
167      * @dev Initializes the contract setting the deployer as the initial owner.
168      */
169     constructor () internal {
170         address msgSender = _msgSender();
171         _owner = msgSender;
172         emit OwnershipTransferred(address(0), msgSender);
173     }
174 
175     /**
176      * @dev Returns the address of the current owner.
177      */
178     function owner() public view returns (address) {
179         return _owner;
180     }
181 
182     /**
183      * @dev Throws if called by any account other than the owner.
184      */
185     modifier onlyOwner() {
186         require(_owner == _msgSender(), "Ownable: caller is not the owner");
187         _;
188     }
189 
190     /**
191      * @dev Leaves the contract without owner. It will not be possible to call
192      * `onlyOwner` functions anymore. Can only be called by the current owner.
193      *
194      * NOTE: Renouncing ownership will leave the contract without an owner,
195      * thereby removing any functionality that is only available to the owner.
196      */
197     function renounceOwnership() public onlyOwner {
198         emit OwnershipTransferred(_owner, address(0));
199         _owner = address(0);
200     }
201 
202     /**
203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
204      * Can only be called by the current owner.
205      */
206     function transferOwnership(address newOwner) public onlyOwner {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         emit OwnershipTransferred(_owner, newOwner);
209         _owner = newOwner;
210     }
211 }
212 
213 /**
214  * @dev Implementation of the {IERC20} interface.
215  *
216  * This implementation is agnostic to the way tokens are created. This means
217  * that a supply mechanism has to be added in a derived contract using {_mint}.
218  * For a generic mechanism see {ERC20PresetMinterPauser}.
219  *
220  * TIP: For a detailed writeup see our guide
221  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
222  * to implement supply mechanisms].
223  *
224  * We have followed general OpenZeppelin guidelines: functions revert instead
225  * of returning `false` on failure. This behavior is nonetheless conventional
226  * and does not conflict with the expectations of ERC20 applications.
227  *
228  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
229  * This allows applications to reconstruct the allowance for all accounts just
230  * by listening to said events. Other implementations of the EIP may not emit
231  * these events, as it isn't required by the specification.
232  *
233  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
234  * functions have been added to mitigate the well-known issues around setting
235  * allowances. See {IERC20-approve}.
236  */
237 contract ERC20 is Context, IERC20 {
238     using SafeMath for uint256;
239 
240     mapping (address => uint256) private _balances;
241     mapping (address => mapping (address => uint256)) private _allowances;
242 
243     string public name;
244     string public symbol;
245     uint8 public decimals;
246     uint256 private _totalSupply;
247 
248     /**
249      * @dev See {IERC20-totalSupply}.
250      */
251     function totalSupply() public view override returns (uint256) {
252         return _totalSupply;
253     }
254 
255     /**
256      * @dev See {IERC20-balanceOf}.
257      */
258     function balanceOf(address account) public view override returns (uint256) {
259         return _balances[account];
260     }
261 
262     /**
263      * @dev See {IERC20-transfer}.
264      *
265      * Requirements:
266      *
267      * - `recipient` cannot be the zero address.
268      * - the caller must have a balance of at least `amount`.
269      */
270     function transfer(address recipient, uint256 amount) public override returns (bool) {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-allowance}.
277      */
278     function allowance(address owner, address spender) public view override returns (uint256) {
279         return _allowances[owner][spender];
280     }
281 
282     /**
283      * @dev See {IERC20-approve}.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 amount) public override returns (bool) {
290         require((allowance(_msgSender(), spender) == 0) || (amount == 0), "ERC20: change allowance use increaseAllowance or decreaseAllowance instead");
291         _approve(_msgSender(), spender, amount);
292         return true;
293     }
294 
295     /**
296      * @dev See {IERC20-transferFrom}.
297      *
298      * Emits an {Approval} event indicating the updated allowance. This is not
299      * required by the EIP. See the note at the beginning of {ERC20}.
300      *
301      * Requirements:
302      *
303      * - `sender` and `recipient` cannot be the zero address.
304      * - `sender` must have a balance of at least `amount`.
305      * - the caller must have allowance for ``sender``'s tokens of at least
306      * `amount`.
307      */
308     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
309         _transfer(sender, recipient, amount);
310         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
311         return true;
312     }
313 
314     /**
315      * @dev Atomically increases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
327         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
328         return true;
329     }
330 
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
347         return true;
348     }
349 
350     /**
351      * @dev Moves tokens `amount` from `sender` to `recipient`.
352      *
353      * This is internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `sender` cannot be the zero address.
361      * - `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      */
364     function _transfer(address sender, address recipient, uint256 amount) internal {
365         require(sender != address(0), "ERC20: transfer from the zero address");
366         require(recipient != address(0), "ERC20: transfer to the zero address");
367 
368         _beforeTokenTransfer(sender, recipient, amount);
369 
370         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
371         _balances[recipient] = _balances[recipient].add(amount);
372         emit Transfer(sender, recipient, amount);
373     }
374 
375     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
376      * the total supply.
377      *
378      * Emits a {Transfer} event with `from` set to the zero address.
379      *
380      * Requirements:
381      *
382      * - `to` cannot be the zero address.
383      */
384     function _mint(address account, uint256 amount) internal {
385         require(account != address(0), "ERC20: mint to the zero address");
386 
387         _beforeTokenTransfer(address(0), account, amount);
388 
389         _totalSupply = _totalSupply.add(amount);
390         _balances[account] = _balances[account].add(amount);
391         emit Transfer(address(0), account, amount);
392     }
393 
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal {
406         require(account != address(0), "ERC20: burn from the zero address");
407 
408         _beforeTokenTransfer(account, address(0), amount);
409 
410         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
411         _totalSupply = _totalSupply.sub(amount);
412         emit Transfer(account, address(0), amount);
413     }
414 
415     /**
416      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
417      *
418      * This internal function is equivalent to `approve`, and can be used to
419      * e.g. set automatic allowances for certain subsystems, etc.
420      *
421      * Emits an {Approval} event.
422      *
423      * Requirements:
424      *
425      * - `owner` cannot be the zero address.
426      * - `spender` cannot be the zero address.
427      */
428     function _approve(address owner, address spender, uint256 amount) internal {
429         require(owner != address(0), "ERC20: approve from the zero address");
430         require(spender != address(0), "ERC20: approve to the zero address");
431 
432         _allowances[owner][spender] = amount;
433         emit Approval(owner, spender, amount);
434     }
435 
436     /**
437      * @dev Hook that is called before any transfer of tokens. This includes
438      * minting and burning.
439      *
440      * Calling conditions:
441      *
442      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
443      * will be to transferred to `to`.
444      * - when `from` is zero, `amount` tokens will be minted for `to`.
445      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
446      * - `from` and `to` are never both zero.
447      *
448      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
449      */
450     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
451 }
452 
453 /**
454  * @dev Contract module which allows children to implement an emergency stop
455  * mechanism that can be triggered by an authorized account.
456  *
457  * This module is used through inheritance. It will make available the
458  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
459  * the functions of your contract. Note that they will not be pausable by
460  * simply including this module, only once the modifiers are put in place.
461  */
462 contract Pausable is Context {
463     /**
464      * @dev Emitted when the pause is triggered by `account`.
465      */
466     event Paused(address account);
467 
468     /**
469      * @dev Emitted when the pause is lifted by `account`.
470      */
471     event Unpaused(address account);
472 
473     bool private _paused;
474 
475     /**
476      * @dev Initializes the contract in unpaused state.
477      */
478     constructor () internal {
479         _paused = false;
480     }
481 
482     /**
483      * @dev Returns true if the contract is paused, and false otherwise.
484      */
485     function paused() public view returns (bool) {
486         return _paused;
487     }
488 
489     /**
490      * @dev Modifier to make a function callable only when the contract is not paused.
491      *
492      * Requirements:
493      *
494      * - The contract must not be paused.
495      */
496     modifier whenNotPaused() {
497         require(!_paused, "Pausable: paused");
498         _;
499     }
500 
501     /**
502      * @dev Modifier to make a function callable only when the contract is paused.
503      *
504      * Requirements:
505      *
506      * - The contract must be paused.
507      */
508     modifier whenPaused() {
509         require(_paused, "Pausable: not paused");
510         _;
511     }
512 
513     /**
514      * @dev Triggers stopped state.
515      *
516      * Requirements:
517      *
518      * - The contract must not be paused.
519      */
520     function _pause() internal whenNotPaused {
521         _paused = true;
522         emit Paused(_msgSender());
523     }
524 
525     /**
526      * @dev Returns to normal state.
527      *
528      * Requirements:
529      *
530      * - The contract must be paused.
531      */
532     function _unpause() internal whenPaused {
533         _paused = false;
534         emit Unpaused(_msgSender());
535     }
536 }
537 
538 contract SperaxToken is ERC20, Pausable, Ownable {
539 
540     mapping(address => TimeLock) private _timelock;
541 
542     event BlockTransfer(address indexed account);
543     event AllowTransfer(address indexed account);
544 
545     struct TimeLock {
546         uint256 releaseTime;
547         uint256 amount;
548     }
549 
550     /**
551      * @dev Initialize the contract give all tokens to the deployer
552      */
553     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) public {
554         name = _name;
555         symbol = _symbol;
556         decimals = _decimals;
557         _mint(_msgSender(), _initialSupply * (10 ** uint256(_decimals)));
558     }
559 
560     /**
561      * @dev Destroys `amount` tokens from the caller.
562      *
563      * See {ERC20-_burn}.
564      */
565     function burn(uint256 amount) public {
566         _burn(_msgSender(), amount);
567     }
568 
569     /**
570      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
571      * allowance.
572      *
573      * See {ERC20-_burn} and {ERC20-allowance}.
574      *
575      * Requirements:
576      *
577      * - the caller must have allowance for ``accounts``'s tokens of at least
578      * `amount`.
579      */
580     function burnFrom(address account, uint256 amount) public {
581         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "SperaxToken: burn amount exceeds allowance");
582 
583         _approve(account, _msgSender(), decreasedAllowance);
584         _burn(account, amount);
585     }
586 
587 
588     /**
589      * @dev View `account` locked information
590      */
591     function timelockOf(address account) public view returns(uint256 releaseTime, uint256 amount) {
592         TimeLock memory timelock = _timelock[account];
593         return (timelock.releaseTime, timelock.amount);
594     }
595 
596     /**
597      * @dev Transfer to the "recipient" some specified 'amount' that is locked until "releaseTime"
598      * @notice only Owner call
599      */
600     function transferWithLock(address recipient, uint256 amount, uint256 releaseTime) public onlyOwner returns (bool) {
601         require(recipient != address(0), "SperaxToken: transferWithLock to zero address");
602         require(releaseTime > block.timestamp, "SperaxToken: release time before lock time");
603         require(_timelock[recipient].releaseTime == 0, "SperaxToken: already locked");
604 
605         TimeLock memory timelock = TimeLock({
606             releaseTime : releaseTime,
607             amount      : amount
608         });
609         _timelock[recipient] = timelock;
610 
611         _transfer(_msgSender(), recipient, amount);
612         return true;
613     }
614 
615     /**
616      * @dev Release the specified `amount` of locked amount
617      * @notice only Owner call
618      */
619     function release(address account, uint256 releaseAmount) public onlyOwner {
620         require(account != address(0), "SperaxToken: release zero address");
621 
622         TimeLock storage timelock = _timelock[account];
623         timelock.amount = timelock.amount.sub(releaseAmount);
624         if(timelock.amount == 0) {
625             timelock.releaseTime = 0;
626         }
627     }
628 
629     /**
630      * @dev Triggers stopped state.
631      * @notice only Owner call
632      */
633     function pause() public onlyOwner {
634         _pause();
635     }
636 
637     /**
638      * @dev Returns to normal state.
639      * @notice only Owner call
640      */
641     function unpause() public onlyOwner {
642         _unpause();
643     }
644 
645     /**
646      * @dev Batch transfer amount to recipient
647      * @notice that excessive gas consumption causes transaction revert
648      */
649     function batchTransfer(address[] memory recipients, uint256[] memory amounts) public {
650         require(recipients.length > 0, "SperaxToken: least one recipient address");
651         require(recipients.length == amounts.length, "SperaxToken: number of recipient addresses does not match the number of tokens");
652 
653         for(uint256 i = 0; i < recipients.length; ++i) {
654             _transfer(_msgSender(), recipients[i], amounts[i]);
655         }
656     }
657 
658     /**
659      * @dev See {ERC20-_beforeTokenTransfer}.
660      *
661      * Requirements:
662      *
663      * - the contract must not be paused.
664      * - accounts must not trigger the locked `amount` during the locked period.
665      */
666     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
667         require(!paused(), "SperaxToken: token transfer while paused");
668 
669         // Check whether the locked amount is triggered
670         TimeLock storage timelock = _timelock[from];
671         if(timelock.releaseTime != 0 && balanceOf(from).sub(amount) < timelock.amount) {
672             require(block.timestamp >= timelock.releaseTime, "SperaxToken: current time is before from account release time");
673 
674             // Update the locked `amount` if the current time reaches the release time
675             timelock.amount = balanceOf(from).sub(amount);
676             if(timelock.amount == 0) {
677                 timelock.releaseTime = 0;
678             }
679         }
680 
681         super._beforeTokenTransfer(from, to, amount);
682     }
683 }