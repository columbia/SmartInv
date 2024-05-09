1 pragma solidity 0.8.0;
2 
3 /**
4 * @dev Interface of the ERC20 standard as defined in the EIP.
5 */
6 interface IERC20 {
7     /**
8     * @dev Returns the amount of tokens in existence.
9     */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13     * @dev Returns the name of the token.
14     */
15     function name() external view returns (string memory);
16 
17     /**
18     * @dev Returns the symbol of the token.
19     */
20     function symbol() external view returns (string memory);
21 
22     /**
23     * @dev Returns the decimals places of the token.
24     */
25     function decimals() external view returns (uint8);
26 
27     /**
28     * @dev Returns the bep token owner.
29     */
30     function getOwner() external view returns (address);
31 
32     /**
33     * @dev Returns the amount of tokens owned by `account`.
34     */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38     * @dev Moves `amount` tokens from the caller's account to `recipient`.
39     *
40     * Returns a boolean value indicating whether the operation succeeded.
41     *
42     * Emits a {Transfer} event.
43     */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47     * @dev Returns the remaining number of tokens that `spender` will be
48     * allowed to spend on behalf of `owner` through {transferFrom}. This is
49     * zero by default.
50     *
51     * This value changes when {approve} or {transferFrom} are called.
52     */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57     *
58     * Returns a boolean value indicating whether the operation succeeded.
59     *
60     * IMPORTANT: Beware that changing an allowance with this method brings the risk
61     * that someone may use both the old and the new allowance by unfortunate
62     * transaction ordering. One possible solution to mitigate this race
63     * condition is to first reduce the spender's allowance to 0 and set the
64     * desired value afterwards:
65     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66     *
67     * Emits an {Approval} event.
68     */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72     * @dev Moves `amount` tokens from `sender` to `recipient` using the
73     * allowance mechanism. `amount` is then deducted from the caller's
74     * allowance.
75     *
76     * Returns a boolean value indicating whether the operation succeeded.
77     *
78     * Emits a {Transfer} event.
79     */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83     * @dev Emitted when `value` tokens are moved from one account (`from`) to
84     * another (`to`).
85     *
86     * Note that `value` may be zero.
87     */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92     * a call to {approve}. `value` is the new allowance.
93     */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /**
98 * @dev Provides information about the current execution context, including the
99 * sender of the transaction and its data. While these are generally available
100 * via msg.sender and msg.data, they should not be accessed in such a direct
101 * manner, since when dealing with meta-transactions the account sending and
102 * paying for execution may not be the actual sender (as far as an application
103 * is concerned).
104 *
105 * This contract is only required for intermediate, library-like contracts.
106 */
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 /**
118 * @dev Contract module which provides a manager access control mechanism, where
119 * there is owner and manager, that can be granted exclusive access to
120 * specific functions.
121 *
122 * Both owner and manager accounts need to be specified when deploying the contract. This
123 * can later be changed with {setOwner} and {setManager}.
124 *
125 * This module is used through inheritance. Modifiers `onlyOwner` and `ownerOrManager`
126 * will be available, which can be applied to your functions to restrict their use.
127 */
128 abstract contract Managed is Context
129 {
130     event OwnershipTransfered(address indexed previousOwner, address indexed newOwner);
131     event ManagementTransferred(address indexed previousManager, address indexed newManager);
132 
133     address private _owner;
134     address private _manager;
135 
136     /**
137     * @dev Initializes the contract, setting owner and manager.
138     */
139     constructor(address owner_, address manager_)
140     {
141         require(owner_ != address(0), "Owner address can't be a zero address");
142         require(manager_ != address(0), "Manager address can't be a zero address");
143 
144         _setOwner(owner_);
145         _setManager(manager_);
146     }
147 
148     /**
149     * @dev Returns the address of the current owner.
150     */
151     function owner() public view returns (address)
152     { return _owner; }
153 
154     /**
155     * @dev Returns the address of the current manager.
156     */
157     function manager() public view returns (address)
158     { return _manager; }
159 
160     /**
161     * @dev Transfers owner permissions to a new account (`newOwner`).
162     * Can only be called by owner.
163     */
164     function setOwner(address newOwner) external onlyOwner
165     {
166         require(newOwner != address(0), "Managed: new owner can't be zero address");
167         _setOwner(newOwner);
168     }
169 
170     /**
171     * @dev Transfers manager permissions to a new account (`newManager`).
172     * Can only be called by owner.
173     */
174     function setManager(address newManager) external onlyOwner
175     {
176         require(newManager != address(0), "Managed: new manager can't be zero address");
177         _setManager(newManager);
178     }
179 
180     /**
181     * @dev Throws if called by any account other than the owner.
182     */
183     modifier onlyOwner()
184     {
185         require(_msgSender() == _owner, "Managed: caller is not the owner");
186         _;
187     }
188 
189     /**
190     * @dev Throws if called by any account other than owner or manager.
191     */
192     modifier ownerOrManager()
193     {
194         require(_msgSender() == _owner || _msgSender() == _manager, "Managed: caller is not the owner or manager");
195         _;
196     }
197 
198     /**
199     * @dev Transfers owner permissions to a new account (`newOwner`).
200     * Internal function without access restriction.
201     */
202     function _setOwner(address newOwner) internal
203     {
204         address oldOwner = _owner;
205         _owner = newOwner;
206         emit OwnershipTransfered(oldOwner, newOwner);
207     }
208 
209     /**
210     * @dev Transfers manager permissions to a new account (`newManager`).
211     * Internal function without access restriction.
212     */
213     function _setManager(address newManager) internal
214     {
215         address oldManager = _manager;
216         _manager = newManager;
217         emit ManagementTransferred(oldManager, newManager);
218     }
219 }
220 
221 /**
222 * @dev Contract module which provides a locking mechanism that allows
223 * a total token lock, or lock of a specific address.
224 *
225 * This module is used through inheritance. Modifier `isUnlocked`
226 * will be available, which can be applied to your functions to restrict their use.
227 */
228 abstract contract Lockable is Managed
229 {
230     event AddressLockChanged(address indexed addr, bool newLock);
231     event TokenLockChanged(bool newLock);
232 
233     mapping(address => bool) private _addressLocks;
234     bool private _locked;
235 
236     /**
237     * @dev Completely locks any transfers of the token.
238     * Can only be called by owner.
239     */
240     function lockToken() external onlyOwner
241     {
242         _locked = true;
243         emit TokenLockChanged(true);
244     }
245 
246     /**
247     * @dev Completely unlocks any transfers of the token.
248     * Can only be called by owner.
249     */
250     function unlockToken() external onlyOwner
251     {
252         _locked = false;
253         emit TokenLockChanged(false);
254     }
255 
256     /**
257     * @dev Return whether the token is currently locked.
258     */
259     function isLocked() public view returns (bool)
260     { return _locked; }
261 
262     /**
263     * @dev Throws if a function is called while the token is locked.
264     */
265     modifier isUnlocked()
266     {
267         require(!_locked, "All token transfers are currently locked");
268         _;
269     }
270 
271     /**
272     * @dev Completely locks sending and receiving of token for a specific address.
273     * Can only be called by owner or manager
274     */
275     function lockAddress(address addr) external onlyOwner
276     {
277         _addressLocks[addr] = true;
278         emit AddressLockChanged(addr, true);
279     }
280 
281     /**
282     * @dev Completely unlocks sending and receiving of token for a specific address.
283     * Can only be called by owner or manager
284     */
285     function unlockAddress(address addr) external onlyOwner
286     {
287         _addressLocks[addr] = false;
288         emit AddressLockChanged(addr, false);
289     }
290 
291     /**
292     * @dev Returns whether the account (`addr`) is currently locked.
293     */
294     function isAddressLocked(address addr) public view returns (bool)
295     { return _addressLocks[addr]; }
296 }
297 
298 /**
299 * @dev Implementation of the {IERC20} interface.
300 *
301 * This implementation is agnostic to the way tokens are created. This means
302 * that a supply mechanism has to be added in a derived contract using {_mint}.
303 * For a generic mechanism see {ERC20PresetMinterPauser}.
304 *
305 * TIP: For a detailed writeup see our guide
306 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
307 * to implement supply mechanisms].
308 *
309 * We have followed general OpenZeppelin Contracts guidelines: functions revert
310 * instead returning `false` on failure. This behavior is nonetheless
311 * conventional and does not conflict with the expectations of ERC20
312 * applications.
313 *
314 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
315 * This allows applications to reconstruct the allowance for all accounts just
316 * by listening to said events. Other implementations of the EIP may not emit
317 * these events, as it isn't required by the specification.
318 *
319 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
320 * functions have been added to mitigate the well-known issues around setting
321 * allowances. See {IERC20-approve}.
322 */
323 contract ERC20 is Context, IERC20, Managed, Lockable
324 {
325     event Burn(address indexed from, uint256 amount);
326     event Release(address indexed to, uint256 amount);
327     event Halving(uint256 oldReleaseAmount, uint256 newReleaseAmount);
328     event ReleaseAddressChanged(address indexed oldAddress, address indexed newAddress);
329 
330     mapping(address => uint256) private _balances;
331 
332     mapping(address => mapping(address => uint256)) private _allowances;
333 
334     uint256 private _totalSupply;
335     string private _name;
336     string private _symbol;
337     uint8 private immutable _decimals;
338 
339     uint256 private _releaseAmount;
340     uint256 private _nextReleaseDate;
341     uint256 private _nextReducementDate;
342     address private _releaseAddress;
343 
344     uint256 private _week = 600000; // 10 000 minutes
345     uint256 private _4years = 126000000; // 2 100 000 minutes
346 
347     /**
348     * @dev Sets the values for {owner}, {manager} and {initialDepositAddress}.
349     *
350     * Sets the {_releaseAmount} to 50538 coins, and timestamp for {_nextReleaseDate} and {_nextReducementDate}.
351     * Sends first released amount to the {initialDepositAddress}, and locks the remaining supply within contract.
352     *
353     * The default value of {decimals} is 18. To select a different value for
354     * {decimals} you should overload it.
355     *
356     * All values for token parameters are immutable: they can only be set once during
357     * construction.
358     */
359     constructor(string memory name_, string memory symbol_, uint8 decimals_, address owner_, address manager_, address initialDepositAddress) Managed(owner_, manager_)
360     {
361         require(initialDepositAddress != address(0), "Initial unlock address can't be a zero address");
362 
363         _name = name_;
364         _symbol = symbol_;
365         _decimals = decimals_;
366 
367         _totalSupply = 21000000 * uint256(10**decimals_);
368         _releaseAmount = 50000 * uint256(10**decimals_);
369 
370         _nextReleaseDate = block.timestamp + _week;
371         _nextReducementDate = block.timestamp + _4years;
372 
373         _balances[address(this)] = _totalSupply - _releaseAmount;
374         emit Transfer(address(0), address(this), _balances[address(this)]);
375 
376         _releaseAddress = initialDepositAddress;
377 
378         _balances[initialDepositAddress] = _releaseAmount;
379         emit Transfer(address(0), initialDepositAddress, _balances[initialDepositAddress]);
380 
381         emit Release(initialDepositAddress, _balances[initialDepositAddress]);
382     }
383 
384     /**
385     * @dev Returns the name of the token.
386     */
387     function name() public view virtual override returns (string memory) {
388         return _name;
389     }
390 
391     /**
392     * @dev Returns the symbol of the token, usually a shorter version of the
393     * name.
394     */
395     function symbol() public view virtual override returns (string memory) {
396         return _symbol;
397     }
398 
399     /**
400     * @dev Returns the number of decimals used to get its user representation.
401     * For example, if `decimals` equals `2`, a balance of `505` tokens should
402     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
403     *
404     * Tokens usually opt for a value of 18, imitating the relationship between
405     * Ether and Wei. This is the value {ERC20} uses, unless this function is
406     * overridden;
407     *
408     * NOTE: This information is only used for _display_ purposes: it in
409     * no way affects any of the arithmetic of the contract, including
410     * {IERC20-balanceOf} and {IERC20-transfer}.
411     */
412     function decimals() public view virtual override returns (uint8) {
413         return _decimals;
414     }
415 
416     /**
417     * @dev See {IERC20-getOwner}.
418     */
419     function getOwner() public view virtual override returns (address)
420     { return owner(); }
421 
422     /**
423     * @dev See {IERC20-totalSupply}.
424     */
425     function totalSupply() public view virtual override returns (uint256) {
426         return _totalSupply;
427     }
428 
429     /**
430     * @dev See {IERC20-balanceOf}.
431     */
432     function balanceOf(address account) public view virtual override returns (uint256) {
433         return _balances[account];
434     }
435 
436     /**
437     * @dev See {IERC20-transfer}.
438     *
439     * Requirements:
440     *
441     * - the caller must have an available balance of at least `amount`.
442     */
443     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
444         _transfer(_msgSender(), recipient, amount);
445         return true;
446     }
447 
448     /**
449     * @dev See {IERC20-allowance}.
450     */
451     function allowance(address owner, address spender) public view virtual override returns (uint256) {
452         return _allowances[owner][spender];
453     }
454 
455     /**
456     * @dev See {IERC20-approve}.
457     *
458     * Requirements:
459     *
460     * - `spender` cannot be the zero address.
461     */
462     function approve(address spender, uint256 amount) external virtual override returns (bool) {
463         _approve(_msgSender(), spender, amount);
464         return true;
465     }
466 
467     /**
468     * @dev See {IERC20-transferFrom}.
469     *
470     * Emits an {Approval} event indicating the updated allowance. This is not
471     * required by the EIP. See the note at the beginning of {ERC20}.
472     *
473     * Requirements:
474     *
475     * - `sender` and `recipient` cannot be the zero address.
476     * - `sender` must have a balance of at least `amount`.
477     * - the caller must have allowance for ``sender``'s tokens of at least
478     * `amount`.
479     */
480     function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
481         _transfer(sender, recipient, amount);
482 
483         uint256 currentAllowance = _allowances[sender][_msgSender()];
484         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
485         unchecked {
486             _approve(sender, _msgSender(), currentAllowance - amount);
487         }
488 
489         return true;
490     }
491 
492     /**
493     * @dev Destroys `amount` tokens from the caller.
494     *
495     * See {ERC20-_burn}.
496     */
497     function burn(uint256 amount) external virtual
498     { _burn(_msgSender(), amount); }
499 
500     /**
501     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
502     * allowance.
503     *
504     * See {ERC20-_burn} and {ERC20-allowance}.
505     *
506     * Requirements:
507     *
508     * - the caller must have allowance for `accounts`'s tokens of at least
509     * `amount`.
510     */
511     function burnFrom(address account, uint256 amount) external virtual
512     {
513         uint256 currentAllowance = allowance(account, _msgSender());
514         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
515         unchecked {
516             _approve(account, _msgSender(), currentAllowance - amount);
517         }
518         _burn(account, amount);
519     }
520 
521     /**
522     * @dev Atomically increases the allowance granted to `spender` by the caller.
523     *
524     * This is an alternative to {approve} that can be used as a mitigation for
525     * problems described in {IERC20-approve}.
526     *
527     * Emits an {Approval} event indicating the updated allowance.
528     *
529     * Requirements:
530     *
531     * - `spender` cannot be the zero address.
532     */
533     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
534         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
535         return true;
536     }
537 
538     /**
539     * @dev Atomically decreases the allowance granted to `spender` by the caller.
540     *
541     * This is an alternative to {approve} that can be used as a mitigation for
542     * problems described in {IERC20-approve}.
543     *
544     * Emits an {Approval} event indicating the updated allowance.
545     *
546     * Requirements:
547     *
548     * - `spender` cannot be the zero address.
549     * - `spender` must have allowance for the caller of at least
550     * `subtractedValue`.
551     */
552     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
553         uint256 currentAllowance = _allowances[_msgSender()][spender];
554         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
555         unchecked {
556             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
557         }
558 
559         return true;
560     }
561 
562     /**
563     * @dev Sets {_releaseAddress} to {newReleaseAddress}.
564     *
565     * Emits a {ReleaseAddressChanged} event containing old and a new release addresses.
566     */
567     function setReleaseAddress(address newReleaseAddress) external onlyOwner
568     {
569         require(newReleaseAddress != address(0), "New release address can't be a zero address");
570 
571         address oldAddress = _releaseAddress;
572         _releaseAddress = newReleaseAddress;
573 
574         emit ReleaseAddressChanged(oldAddress, _releaseAddress);
575     }
576 
577     /**
578     * @dev Calculates and releases new coins into circulation.
579     * If multiple weeks have passed, releases all the coins that should be
580     * released within those weeks.
581     *
582     * Emits a {Release} event containing the address {_releaseAddress} the coins were released to,
583     * and the amount {toRelease} of coins the function released.
584     */
585     function release() external ownerOrManager
586     {
587         require(block.timestamp > _nextReleaseDate, "Next coin release is not yet scheduled");
588         require(balanceOf(address(this)) > 0, "There are no more coins to release");
589 
590         uint256 toRelease = 0;
591         uint256 currentRelease = 0;
592 
593         while((currentRelease = _calculateReleaseAmount()) > 0)
594         { toRelease += currentRelease; }
595 
596         _transfer(address(this), _releaseAddress, toRelease);
597         emit Release(_releaseAddress, toRelease);
598     }
599 
600     /**
601     * @dev Calculates the exact amount of coins that should be released for one release cycle.
602     * If the next release will be after the halving date, it also calculates a new {_releaseAmount}
603     * for future releases.
604     *
605     * Emits a {Halving} event if halving happens, containing the old release amount {oldReleaseAmount},
606     * and new release amount {_releaseAmount}
607     */
608     function _calculateReleaseAmount() internal returns (uint256)
609     {
610         if(block.timestamp < _nextReleaseDate || balanceOf(address(this)) == 0)
611             return 0;
612 
613         uint256 amount = _releaseAmount > balanceOf(address(this)) ? balanceOf(address(this)) : _releaseAmount;
614 
615         _nextReleaseDate += _week;
616         if(_nextReleaseDate >= _nextReducementDate)
617         {
618             _nextReducementDate += _4years;
619 
620             uint256 oldReleaseAmount = _releaseAmount;
621             _releaseAmount = (_releaseAmount * 500000) / 1000000;
622 
623             emit Halving(oldReleaseAmount, _releaseAmount);
624         }
625 
626         return amount;
627     }
628 
629     /**
630     * @dev Moves `amount` of tokens from `sender` to `recipient`.
631     *
632     * This internal function is equivalent to {transfer}, and can be used to
633     * e.g. implement automatic token fees, slashing mechanisms, etc.
634     *
635     * If the `recipient` address is zero address, calls {_burn} instead.
636     *
637     * Emits a {Transfer} event.
638     *
639     * Requirements:
640     *
641     * - `sender` cannot be the zero address.
642     * - `sender` must have an available balance of at least `amount`.
643     */
644     function _transfer(address sender, address recipient, uint256 amount) internal isUnlocked virtual
645     {
646         require(recipient != address(0), "ERC20: transfer to zero address");
647         require(sender != address(0), "ERC20: transfer from the zero address");
648 
649         require(!isAddressLocked(sender), "Sender address is currently locked and can't send funds");
650         require(!isAddressLocked(recipient), "Recipient address is currently locked and can't receive funds");
651 
652         require(_balances[sender] >= amount, "ERC20: transfer amount exceeds available balance");
653 
654         _balances[sender] -= amount;
655         _balances[recipient] += amount;
656 
657         emit Transfer(sender, recipient, amount);
658     }
659 
660     /**
661     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
662     *
663     * This internal function is equivalent to `approve`, and can be used to
664     * e.g. set automatic allowances for certain subsystems, etc.
665     *
666     * Emits an {Approval} event.
667     *
668     * Requirements:
669     *
670     * - `owner` cannot be the zero address.
671     * - `spender` cannot be the zero address.
672     */
673     function _approve(address owner, address spender, uint256 amount) internal virtual {
674         require(owner != address(0), "ERC20: approve from the zero address");
675         require(spender != address(0), "ERC20: approve to the zero address");
676 
677         _allowances[owner][spender] = amount;
678         emit Approval(owner, spender, amount);
679     }
680 
681     /**
682     * @dev Destroys `amount` tokens from `account`, reducing the
683     * total supply.
684     *
685     * Emits a {Transfer} event with `to` set to the zero address.
686     * Emits a {Burn} event with `amount` burned.
687     *
688     * Requirements:
689     *
690     * - `account` cannot be the zero address.
691     * - `account` must have at least `amount` tokens.
692     * - `account` can't be locked.
693     */
694     function _burn(address account, uint256 amount) internal isUnlocked virtual
695     {
696         require(account != address(0), "ERC20: burn from the zero address");
697 
698         require(!isAddressLocked(account), "Sender address is currently locked and can't burn funds");
699 
700         require(_balances[account] >= amount, "ERC20: burn amount exceeds available balance");
701 
702         _balances[account] -= amount;
703         _totalSupply -= amount;
704 
705         emit Transfer(account, address(0), amount);
706         emit Burn(account, amount);
707     }
708 }