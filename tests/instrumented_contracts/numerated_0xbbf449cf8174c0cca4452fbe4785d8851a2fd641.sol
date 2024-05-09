1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Interface for the optional metadata functions from the ERC20 standard.
110  *
111  * _Available since v4.1._
112  */
113 interface IERC20Metadata is IERC20 {
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() external view returns (string memory);
118 
119     /**
120      * @dev Returns the symbol of the token.
121      */
122     function symbol() external view returns (string memory);
123 
124     /**
125      * @dev Returns the decimals places of the token.
126      */
127     function decimals() external view returns (uint8);
128 }
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Implementation of the {IERC20} interface.
134  *
135  * This implementation is agnostic to the way tokens are created. This means
136  * that a supply mechanism has to be added in a derived contract using {_mint}.
137  * For a generic mechanism see {ERC20PresetMinterPauser}.
138  *
139  * TIP: For a detailed writeup see our guide
140  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
141  * to implement supply mechanisms].
142  *
143  * We have followed general OpenZeppelin Contracts guidelines: functions revert
144  * instead returning `false` on failure. This behavior is nonetheless
145  * conventional and does not conflict with the expectations of ERC20
146  * applications.
147  *
148  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
149  * This allows applications to reconstruct the allowance for all accounts just
150  * by listening to said events. Other implementations of the EIP may not emit
151  * these events, as it isn't required by the specification.
152  *
153  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
154  * functions have been added to mitigate the well-known issues around setting
155  * allowances. See {IERC20-approve}.
156  */
157 contract ERC20 is Context, IERC20, IERC20Metadata {
158     mapping(address => uint256) private _balances;
159 
160     mapping(address => mapping(address => uint256)) private _allowances;
161 
162     uint256 private _totalSupply;
163 
164     string private _name;
165     string private _symbol;
166 
167     /**
168      * @dev Sets the values for {name} and {symbol}.
169      *
170      * The default value of {decimals} is 18. To select a different value for
171      * {decimals} you should overload it.
172      *
173      * All two of these values are immutable: they can only be set once during
174      * construction.
175      */
176     constructor(string memory name_, string memory symbol_) {
177         _name = name_;
178         _symbol = symbol_;
179     }
180 
181     /**
182      * @dev Returns the name of the token.
183      */
184     function name() public view virtual override returns (string memory) {
185         return _name;
186     }
187 
188     /**
189      * @dev Returns the symbol of the token, usually a shorter version of the
190      * name.
191      */
192     function symbol() public view virtual override returns (string memory) {
193         return _symbol;
194     }
195 
196     /**
197      * @dev Returns the number of decimals used to get its user representation.
198      * For example, if `decimals` equals `2`, a balance of `505` tokens should
199      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
200      *
201      * Tokens usually opt for a value of 18, imitating the relationship between
202      * Ether and Wei. This is the value {ERC20} uses, unless this function is
203      * overridden;
204      *
205      * NOTE: This information is only used for _display_ purposes: it in
206      * no way affects any of the arithmetic of the contract, including
207      * {IERC20-balanceOf} and {IERC20-transfer}.
208      */
209     function decimals() public view virtual override returns (uint8) {
210         return 18;
211     }
212 
213     /**
214      * @dev See {IERC20-totalSupply}.
215      */
216     function totalSupply() public view virtual override returns (uint256) {
217         return _totalSupply;
218     }
219 
220     /**
221      * @dev See {IERC20-balanceOf}.
222      */
223     function balanceOf(address account) public view virtual override returns (uint256) {
224         return _balances[account];
225     }
226 
227     /**
228      * @dev See {IERC20-transfer}.
229      *
230      * Requirements:
231      *
232      * - `recipient` cannot be the zero address.
233      * - the caller must have a balance of at least `amount`.
234      */
235     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
236         _transfer(_msgSender(), recipient, amount);
237         return true;
238     }
239 
240     /**
241      * @dev See {IERC20-allowance}.
242      */
243     function allowance(address owner, address spender) public view virtual override returns (uint256) {
244         return _allowances[owner][spender];
245     }
246 
247     /**
248      * @dev See {IERC20-approve}.
249      *
250      * Requirements:
251      *
252      * - `spender` cannot be the zero address.
253      */
254     function approve(address spender, uint256 amount) public virtual override returns (bool) {
255         _approve(_msgSender(), spender, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-transferFrom}.
261      *
262      * Emits an {Approval} event indicating the updated allowance. This is not
263      * required by the EIP. See the note at the beginning of {ERC20}.
264      *
265      * Requirements:
266      *
267      * - `sender` and `recipient` cannot be the zero address.
268      * - `sender` must have a balance of at least `amount`.
269      * - the caller must have allowance for ``sender``'s tokens of at least
270      * `amount`.
271      */
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) public virtual override returns (bool) {
277         _transfer(sender, recipient, amount);
278 
279         uint256 currentAllowance = _allowances[sender][_msgSender()];
280         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
281     unchecked {
282         _approve(sender, _msgSender(), currentAllowance - amount);
283     }
284 
285         return true;
286     }
287 
288     /**
289      * @dev Atomically increases the allowance granted to `spender` by the caller.
290      *
291      * This is an alternative to {approve} that can be used as a mitigation for
292      * problems described in {IERC20-approve}.
293      *
294      * Emits an {Approval} event indicating the updated allowance.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
301         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
302         return true;
303     }
304 
305     /**
306      * @dev Atomically decreases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      * - `spender` must have allowance for the caller of at least
317      * `subtractedValue`.
318      */
319     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
320         uint256 currentAllowance = _allowances[_msgSender()][spender];
321         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
322     unchecked {
323         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
324     }
325 
326         return true;
327     }
328 
329     /**
330      * @dev Moves `amount` of tokens from `sender` to `recipient`.
331      *
332      * This internal function is equivalent to {transfer}, and can be used to
333      * e.g. implement automatic token fees, slashing mechanisms, etc.
334      *
335      * Emits a {Transfer} event.
336      *
337      * Requirements:
338      *
339      * - `sender` cannot be the zero address.
340      * - `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      */
343     function _transfer(
344         address sender,
345         address recipient,
346         uint256 amount
347     ) internal virtual {
348         require(sender != address(0), "ERC20: transfer from the zero address");
349         require(recipient != address(0), "ERC20: transfer to the zero address");
350 
351         _beforeTokenTransfer(sender, recipient, amount);
352 
353         uint256 senderBalance = _balances[sender];
354         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
355     unchecked {
356         _balances[sender] = senderBalance - amount;
357     }
358         _balances[recipient] += amount;
359 
360         emit Transfer(sender, recipient, amount);
361 
362         _afterTokenTransfer(sender, recipient, amount);
363     }
364 
365     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
366      * the total supply.
367      *
368      * Emits a {Transfer} event with `from` set to the zero address.
369      *
370      * Requirements:
371      *
372      * - `account` cannot be the zero address.
373      */
374     function _mint(address account, uint256 amount) internal virtual {
375         require(account != address(0), "ERC20: mint to the zero address");
376 
377         _beforeTokenTransfer(address(0), account, amount);
378 
379         _totalSupply += amount;
380         _balances[account] += amount;
381         emit Transfer(address(0), account, amount);
382 
383         _afterTokenTransfer(address(0), account, amount);
384     }
385 
386     /**
387      * @dev Destroys `amount` tokens from `account`, reducing the
388      * total supply.
389      *
390      * Emits a {Transfer} event with `to` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      * - `account` must have at least `amount` tokens.
396      */
397     function _burn(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: burn from the zero address");
399 
400         _beforeTokenTransfer(account, address(0), amount);
401 
402         uint256 accountBalance = _balances[account];
403         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
404     unchecked {
405         _balances[account] = accountBalance - amount;
406     }
407         _totalSupply -= amount;
408 
409         emit Transfer(account, address(0), amount);
410 
411         _afterTokenTransfer(account, address(0), amount);
412     }
413 
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(
428         address owner,
429         address spender,
430         uint256 amount
431     ) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434 
435         _allowances[owner][spender] = amount;
436         emit Approval(owner, spender, amount);
437     }
438 
439     /**
440      * @dev Hook that is called before any transfer of tokens. This includes
441      * minting and burning.
442      *
443      * Calling conditions:
444      *
445      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
446      * will be transferred to `to`.
447      * - when `from` is zero, `amount` tokens will be minted for `to`.
448      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
449      * - `from` and `to` are never both zero.
450      *
451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
452      */
453     function _beforeTokenTransfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {}
458 
459     /**
460      * @dev Hook that is called after any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * has been transferred to `to`.
467      * - when `from` is zero, `amount` tokens have been minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _afterTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 }
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Contract module which provides a basic access control mechanism, where
484  * there is an account (an owner) that can be granted exclusive access to
485  * specific functions.
486  *
487  * By default, the owner account will be the one that deploys the contract. This
488  * can later be changed with {transferOwnership}.
489  *
490  * This module is used through inheritance. It will make available the modifier
491  * `onlyOwner`, which can be applied to your functions to restrict their use to
492  * the owner.
493  */
494 abstract contract Ownable is Context {
495     address private _owner;
496 
497     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
498 
499     /**
500      * @dev Initializes the contract setting the deployer as the initial owner.
501      */
502     constructor() {
503         _setOwner(_msgSender());
504     }
505 
506     /**
507      * @dev Returns the address of the current owner.
508      */
509     function owner() public view virtual returns (address) {
510         return _owner;
511     }
512 
513     /**
514      * @dev Throws if called by any account other than the owner.
515      */
516     modifier onlyOwner() {
517         require(owner() == _msgSender(), "Ownable: caller is not the owner");
518         _;
519     }
520 
521     /**
522      * @dev Leaves the contract without owner. It will not be possible to call
523      * `onlyOwner` functions anymore. Can only be called by the current owner.
524      *
525      * NOTE: Renouncing ownership will leave the contract without an owner,
526      * thereby removing any functionality that is only available to the owner.
527      */
528     function renounceOwnership() public virtual onlyOwner {
529         _setOwner(address(0));
530     }
531 
532     /**
533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
534      * Can only be called by the current owner.
535      */
536     function transferOwnership(address newOwner) public virtual onlyOwner {
537         require(newOwner != address(0), "Ownable: new owner is the zero address");
538         _setOwner(newOwner);
539     }
540 
541     function _setOwner(address newOwner) private {
542         address oldOwner = _owner;
543         _owner = newOwner;
544         emit OwnershipTransferred(oldOwner, newOwner);
545     }
546 }
547 
548 pragma solidity ^0.8.0;
549 
550 interface IBoars {
551     function balanceOf(address _user) external view returns(uint256);
552     function ownerOf(uint256 _tokenId) external view returns(address);
553     function totalSupply() external view returns (uint256);
554 }
555 
556 contract Oink is ERC20("Oink", "OINK"), Ownable {
557     struct ContractSettings {
558         uint256 baseRate;
559         uint256 start;
560         uint256 end;
561     }
562 
563     ContractSettings public contractSettings;
564     IBoars public iBoars;
565     IBoars public iSymbiosis;
566 
567     // Prevents new contracts from being added or changes to disbursement if permanently locked
568     bool public isLocked = false;
569     mapping(bytes32 => uint256) public lastClaim;
570 
571     event RewardPaid(address indexed user, uint256 reward);
572 
573     constructor(address angryBoarsAddress, uint256 _baseRate) {
574         iBoars = IBoars(angryBoarsAddress);
575         // initialize contractSettings
576         contractSettings = ContractSettings({
577         baseRate: _baseRate,
578         start: 1637251200,
579         end: 1795017600
580         });
581     }
582 
583     /**
584         - sets an end date for when rewards officially end
585      */
586     function setEndDateForContract(uint256 _endTime) public onlyOwner {
587         require(!isLocked, "Cannot modify end dates after lock");
588         contractSettings.end = _endTime;
589     }
590 
591     function claimReward(uint256 _tokenId) public returns (uint256) {
592         require(contractSettings.end > block.timestamp, "Time for claiming has expired.");
593         require(iBoars.ownerOf(_tokenId) == msg.sender, "Caller does not own the token being claimed for.");
594 
595         uint256 unclaimedReward = computeUnclaimedReward(_tokenId);
596 
597         // update the lastClaim date for tokenId and contractAddress
598         bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));
599         lastClaim[lastClaimKey] = block.timestamp;
600 
601         // mint the tokens and distribute to msg.sender
602         _mint(msg.sender, unclaimedReward);
603         emit RewardPaid(msg.sender, unclaimedReward);
604 
605         return unclaimedReward;
606     }
607 
608     function claimRewards(uint256[] calldata _tokenIds) public returns (uint256) {
609         require(contractSettings.end > block.timestamp, "Time for claiming has expired");
610 
611         uint256 totalUnclaimedRewards = 0;
612 
613         for(uint256 i = 0; i < _tokenIds.length; i++) {
614             uint256 _tokenId = _tokenIds[i];
615 
616             require(iBoars.ownerOf(_tokenId) == msg.sender, "Caller does not own the token being claimed for.");
617 
618             uint256 unclaimedReward = computeUnclaimedReward(_tokenId);
619             totalUnclaimedRewards = totalUnclaimedRewards + unclaimedReward;
620 
621             // update the lastClaim date for tokenId and contractAddress
622             bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));
623             lastClaim[lastClaimKey] = block.timestamp;
624         }
625 
626         // mint the tokens and distribute to msg.sender
627         _mint(msg.sender, totalUnclaimedRewards);
628         emit RewardPaid(msg.sender, totalUnclaimedRewards);
629 
630         return totalUnclaimedRewards;
631     }
632 
633     function permanentlyLock() public onlyOwner {
634         isLocked = true;
635     }
636 
637     function getUnclaimedRewardAmount(uint256 _tokenId) public view returns (uint256) {
638         return computeUnclaimedReward(_tokenId);
639     }
640 
641     function getUnclaimedRewardsAmount(uint256[] calldata _tokenIds) public view returns (uint256) {
642 
643         uint256 totalUnclaimedRewards = 0;
644 
645         for(uint256 i = 0; i < _tokenIds.length; i++) {
646             totalUnclaimedRewards += computeUnclaimedReward(_tokenIds[i]);
647         }
648 
649         return totalUnclaimedRewards;
650     }
651 
652     function getTotalUnclaimedRewardsForContract() public view returns (uint256) {
653         uint256 totalUnclaimedRewards = 0;
654         uint256 totalSupply = iBoars.totalSupply();
655 
656         for(uint256 i = 0; i < totalSupply; i++) {
657             totalUnclaimedRewards += computeUnclaimedReward(i);
658         }
659 
660         return totalUnclaimedRewards;
661     }
662 
663     function getLastClaimedTime(uint256 _tokenId) public view returns (uint256) {
664 
665         bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));
666 
667         return lastClaim[lastClaimKey];
668     }
669 
670     function computeAccumulatedReward(uint256 _lastClaimDate, uint256 _baseRate, uint256 currentTime) internal pure returns (uint256) {
671         require(currentTime > _lastClaimDate, "Last claim date must be smaller than block timestamp");
672 
673         uint256 secondsElapsed = currentTime - _lastClaimDate;
674         uint256 accumulatedReward = secondsElapsed * _baseRate / 1 days;
675 
676         return accumulatedReward;
677     }
678 
679     function computeUnclaimedReward(uint256 _tokenId) internal view returns (uint256) {
680 
681         // Will revert if tokenId does not exist
682         iBoars.ownerOf(_tokenId);
683 
684         // build the hash for lastClaim based on contractAddress and tokenId
685         bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));
686         uint256 lastClaimDate = lastClaim[lastClaimKey];
687         uint256 baseRate = contractSettings.baseRate;
688 
689         // if there has been a lastClaim, compute the value since lastClaim
690         if (lastClaimDate != uint256(0)) {
691             return computeAccumulatedReward(lastClaimDate, baseRate, block.timestamp);
692         }
693         
694         else {
695             // if there has not been a lastClaim, add the initIssuance + computed value since contract startDate
696             uint256 totalReward = computeAccumulatedReward(contractSettings.start, baseRate, block.timestamp);
697 
698             return totalReward;
699         }
700     }
701     
702     function burn(address _from, uint256 _amount) external {
703 		require(msg.sender == address(iSymbiosis));
704 		_burn(_from, _amount);
705 	}
706 	
707 	function setMeerk(address symbiosisAddress) public onlyOwner {
708 	    iSymbiosis = IBoars(symbiosisAddress);
709 	}
710 }