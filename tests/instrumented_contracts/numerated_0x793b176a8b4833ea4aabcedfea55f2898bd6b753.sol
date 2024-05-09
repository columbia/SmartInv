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
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @dev Interface for the optional metadata functions from the ERC20 standard.
104  *
105  * _Available since v4.1._
106  */
107 interface IERC20Metadata is IERC20 {
108     /**
109      * @dev Returns the name of the token.
110      */
111     function name() external view returns (string memory);
112 
113     /**
114      * @dev Returns the symbol of the token.
115      */
116     function symbol() external view returns (string memory);
117 
118     /**
119      * @dev Returns the decimals places of the token.
120      */
121     function decimals() external view returns (uint8);
122 }
123 /**
124  * @dev Implementation of the {IERC20} interface.
125  *
126  * This implementation is agnostic to the way tokens are created. This means
127  * that a supply mechanism has to be added in a derived contract using {_mint}.
128  * For a generic mechanism see {ERC20PresetMinterPauser}.
129  *
130  * TIP: For a detailed writeup see our guide
131  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
132  * to implement supply mechanisms].
133  *
134  * We have followed general OpenZeppelin Contracts guidelines: functions revert
135  * instead returning `false` on failure. This behavior is nonetheless
136  * conventional and does not conflict with the expectations of ERC20
137  * applications.
138  *
139  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
140  * This allows applications to reconstruct the allowance for all accounts just
141  * by listening to said events. Other implementations of the EIP may not emit
142  * these events, as it isn't required by the specification.
143  *
144  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
145  * functions have been added to mitigate the well-known issues around setting
146  * allowances. See {IERC20-approve}.
147  */
148 contract ERC20 is Context, IERC20, IERC20Metadata {
149     mapping(address => uint256) private _balances;
150 
151     mapping(address => mapping(address => uint256)) private _allowances;
152 
153     uint256 private _totalSupply;
154 
155     string private _name;
156     string private _symbol;
157 
158     /**
159      * @dev Sets the values for {name} and {symbol}.
160      *
161      * The default value of {decimals} is 18. To select a different value for
162      * {decimals} you should overload it.
163      *
164      * All two of these values are immutable: they can only be set once during
165      * construction.
166      */
167     constructor(string memory name_, string memory symbol_) {
168         _name = name_;
169         _symbol = symbol_;
170     }
171 
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() public view virtual override returns (string memory) {
176         return _name;
177     }
178 
179     /**
180      * @dev Returns the symbol of the token, usually a shorter version of the
181      * name.
182      */
183     function symbol() public view virtual override returns (string memory) {
184         return _symbol;
185     }
186 
187     /**
188      * @dev Returns the number of decimals used to get its user representation.
189      * For example, if `decimals` equals `2`, a balance of `505` tokens should
190      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
191      *
192      * Tokens usually opt for a value of 18, imitating the relationship between
193      * Ether and Wei. This is the value {ERC20} uses, unless this function is
194      * overridden;
195      *
196      * NOTE: This information is only used for _display_ purposes: it in
197      * no way affects any of the arithmetic of the contract, including
198      * {IERC20-balanceOf} and {IERC20-transfer}.
199      */
200     function decimals() public view virtual override returns (uint8) {
201         return 18;
202     }
203 
204     /**
205      * @dev See {IERC20-totalSupply}.
206      */
207     function totalSupply() public view virtual override returns (uint256) {
208         return _totalSupply;
209     }
210 
211     /**
212      * @dev See {IERC20-balanceOf}.
213      */
214     function balanceOf(address account) public view virtual override returns (uint256) {
215         return _balances[account];
216     }
217 
218     /**
219      * @dev See {IERC20-transfer}.
220      *
221      * Requirements:
222      *
223      * - `recipient` cannot be the zero address.
224      * - the caller must have a balance of at least `amount`.
225      */
226     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     /**
232      * @dev See {IERC20-allowance}.
233      */
234     function allowance(address owner, address spender) public view virtual override returns (uint256) {
235         return _allowances[owner][spender];
236     }
237 
238     /**
239      * @dev See {IERC20-approve}.
240      *
241      * Requirements:
242      *
243      * - `spender` cannot be the zero address.
244      */
245     function approve(address spender, uint256 amount) public virtual override returns (bool) {
246         _approve(_msgSender(), spender, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-transferFrom}.
252      *
253      * Emits an {Approval} event indicating the updated allowance. This is not
254      * required by the EIP. See the note at the beginning of {ERC20}.
255      *
256      * Requirements:
257      *
258      * - `sender` and `recipient` cannot be the zero address.
259      * - `sender` must have a balance of at least `amount`.
260      * - the caller must have allowance for ``sender``'s tokens of at least
261      * `amount`.
262      */
263     function transferFrom(
264         address sender,
265         address recipient,
266         uint256 amount
267     ) public virtual override returns (bool) {
268         _transfer(sender, recipient, amount);
269 
270         uint256 currentAllowance = _allowances[sender][_msgSender()];
271         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
272         unchecked {
273             _approve(sender, _msgSender(), currentAllowance - amount);
274         }
275 
276         return true;
277     }
278 
279     /**
280      * @dev Atomically increases the allowance granted to `spender` by the caller.
281      *
282      * This is an alternative to {approve} that can be used as a mitigation for
283      * problems described in {IERC20-approve}.
284      *
285      * Emits an {Approval} event indicating the updated allowance.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
292         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
293         return true;
294     }
295 
296     /**
297      * @dev Atomically decreases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      * - `spender` must have allowance for the caller of at least
308      * `subtractedValue`.
309      */
310     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
311         uint256 currentAllowance = _allowances[_msgSender()][spender];
312         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
313         unchecked {
314             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
315         }
316 
317         return true;
318     }
319 
320     /**
321      * @dev Moves `amount` of tokens from `sender` to `recipient`.
322      *
323      * This internal function is equivalent to {transfer}, and can be used to
324      * e.g. implement automatic token fees, slashing mechanisms, etc.
325      *
326      * Emits a {Transfer} event.
327      *
328      * Requirements:
329      *
330      * - `sender` cannot be the zero address.
331      * - `recipient` cannot be the zero address.
332      * - `sender` must have a balance of at least `amount`.
333      */
334     function _transfer(
335         address sender,
336         address recipient,
337         uint256 amount
338     ) internal virtual {
339         require(sender != address(0), "ERC20: transfer from the zero address");
340         require(recipient != address(0), "ERC20: transfer to the zero address");
341 
342         _beforeTokenTransfer(sender, recipient, amount);
343 
344         uint256 senderBalance = _balances[sender];
345         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
346         unchecked {
347             _balances[sender] = senderBalance - amount;
348         }
349         _balances[recipient] += amount;
350 
351         emit Transfer(sender, recipient, amount);
352 
353         _afterTokenTransfer(sender, recipient, amount);
354     }
355 
356     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
357      * the total supply.
358      *
359      * Emits a {Transfer} event with `from` set to the zero address.
360      *
361      * Requirements:
362      *
363      * - `account` cannot be the zero address.
364      */
365     function _mint(address account, uint256 amount) internal virtual {
366         require(account != address(0), "ERC20: mint to the zero address");
367 
368         _beforeTokenTransfer(address(0), account, amount);
369 
370         _totalSupply += amount;
371         _balances[account] += amount;
372         emit Transfer(address(0), account, amount);
373 
374         _afterTokenTransfer(address(0), account, amount);
375     }
376 
377     /**
378      * @dev Destroys `amount` tokens from `account`, reducing the
379      * total supply.
380      *
381      * Emits a {Transfer} event with `to` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      * - `account` must have at least `amount` tokens.
387      */
388     function _burn(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: burn from the zero address");
390 
391         _beforeTokenTransfer(account, address(0), amount);
392 
393         uint256 accountBalance = _balances[account];
394         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
395         unchecked {
396             _balances[account] = accountBalance - amount;
397         }
398         _totalSupply -= amount;
399 
400         emit Transfer(account, address(0), amount);
401 
402         _afterTokenTransfer(account, address(0), amount);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(
419         address owner,
420         address spender,
421         uint256 amount
422     ) internal virtual {
423         require(owner != address(0), "ERC20: approve from the zero address");
424         require(spender != address(0), "ERC20: approve to the zero address");
425 
426         _allowances[owner][spender] = amount;
427         emit Approval(owner, spender, amount);
428     }
429 
430     /**
431      * @dev Hook that is called before any transfer of tokens. This includes
432      * minting and burning.
433      *
434      * Calling conditions:
435      *
436      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
437      * will be transferred to `to`.
438      * - when `from` is zero, `amount` tokens will be minted for `to`.
439      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
440      * - `from` and `to` are never both zero.
441      *
442      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
443      */
444     function _beforeTokenTransfer(
445         address from,
446         address to,
447         uint256 amount
448     ) internal virtual {}
449 
450     /**
451      * @dev Hook that is called after any transfer of tokens. This includes
452      * minting and burning.
453      *
454      * Calling conditions:
455      *
456      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
457      * has been transferred to `to`.
458      * - when `from` is zero, `amount` tokens have been minted for `to`.
459      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
460      * - `from` and `to` are never both zero.
461      *
462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
463      */
464     function _afterTokenTransfer(
465         address from,
466         address to,
467         uint256 amount
468     ) internal virtual {}
469 }
470 /**
471  * @dev Contract module which provides a basic access control mechanism, where
472  * there is an account (an owner) that can be granted exclusive access to
473  * specific functions.
474  *
475  * By default, the owner account will be the one that deploys the contract. This
476  * can later be changed with {transferOwnership}.
477  *
478  * This module is used through inheritance. It will make available the modifier
479  * `onlyOwner`, which can be applied to your functions to restrict their use to
480  * the owner.
481  */
482 abstract contract Ownable is Context {
483     address private _owner;
484 
485     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
486 
487     /**
488      * @dev Initializes the contract setting the deployer as the initial owner.
489      */
490     constructor() {
491         _setOwner(_msgSender());
492     }
493 
494     /**
495      * @dev Returns the address of the current owner.
496      */
497     function owner() public view virtual returns (address) {
498         return _owner;
499     }
500 
501     /**
502      * @dev Throws if called by any account other than the owner.
503      */
504     modifier onlyOwner() {
505         require(owner() == _msgSender(), "Ownable: caller is not the owner");
506         _;
507     }
508 
509     /**
510      * @dev Leaves the contract without owner. It will not be possible to call
511      * `onlyOwner` functions anymore. Can only be called by the current owner.
512      *
513      * NOTE: Renouncing ownership will leave the contract without an owner,
514      * thereby removing any functionality that is only available to the owner.
515      */
516     function renounceOwnership() public virtual onlyOwner {
517         _setOwner(address(0));
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Can only be called by the current owner.
523      */
524     function transferOwnership(address newOwner) public virtual onlyOwner {
525         require(newOwner != address(0), "Ownable: new owner is the zero address");
526         _setOwner(newOwner);
527     }
528 
529     function _setOwner(address newOwner) private {
530         address oldOwner = _owner;
531         _owner = newOwner;
532         emit OwnershipTransferred(oldOwner, newOwner);
533     }
534 }
535 
536 abstract contract BrainTokenInterface is ERC20, Ownable {
537     /// @notice Total number of tokens
538     uint256 public maxSupply = 1_000_000_000e18; // 1 Billion BRAIN
539 
540     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (BRAIN FARM).
541     function mint(address _to, uint256 _amount) public onlyOwner {
542         require(
543             (totalSupply() + _amount) <= maxSupply,
544             "BRAIN::mint: cannot exceed max supply"
545         );
546         _mint(_to, _amount);
547         _moveDelegates(address(0), _delegates[_to], _amount);
548     }
549 
550     /// @notice A record of each accounts delegate
551     mapping(address => address) internal _delegates;
552 
553     /// @notice A checkpoint for marking number of votes from a given block
554     struct Checkpoint {
555         uint32 fromBlock;
556         uint256 votes;
557     }
558 
559     /// @notice A record of votes checkpoints for each account, by index
560     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
561 
562     /// @notice The number of checkpoints for each account
563     mapping(address => uint32) public numCheckpoints;
564 
565     /// @notice The EIP-712 typehash for the contract's domain
566     bytes32 public constant DOMAIN_TYPEHASH =
567         keccak256(
568             "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
569         );
570 
571     /// @notice The EIP-712 typehash for the delegation struct used by the contract
572     bytes32 public constant DELEGATION_TYPEHASH =
573         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
574 
575     /// @notice A record of states for signing / validating signatures
576     mapping(address => uint256) public nonces;
577 
578     /// @notice An event thats emitted when an account changes its delegate
579     event DelegateChanged(
580         address indexed delegator,
581         address indexed fromDelegate,
582         address indexed toDelegate
583     );
584 
585     /// @notice An event thats emitted when a delegate account's vote balance changes
586     event DelegateVotesChanged(
587         address indexed delegate,
588         uint256 previousBalance,
589         uint256 newBalance
590     );
591 
592     /**
593      * @notice Delegate votes from `msg.sender` to `delegatee`
594      * @param delegator The address to get delegatee for
595      */
596     function delegates(address delegator) external view returns (address) {
597         return _delegates[delegator];
598     }
599 
600     /**
601      * @notice Delegate votes from `msg.sender` to `delegatee`
602      * @param delegatee The address to delegate votes to
603      */
604     function delegate(address delegatee) external {
605         return _delegate(msg.sender, delegatee);
606     }
607 
608     /**
609      * @notice Delegates votes from signatory to `delegatee`
610      * @param delegatee The address to delegate votes to
611      * @param nonce The contract state required to match the signature
612      * @param expiry The time at which to expire the signature
613      * @param v The recovery byte of the signature
614      * @param r Half of the ECDSA signature pair
615      * @param s Half of the ECDSA signature pair
616      */
617     function delegateBySig(
618         address delegatee,
619         uint256 nonce,
620         uint256 expiry,
621         uint8 v,
622         bytes32 r,
623         bytes32 s
624     ) external {
625         bytes32 domainSeparator = keccak256(
626             abi.encode(
627                 DOMAIN_TYPEHASH,
628                 keccak256(bytes(name())),
629                 getChainId(),
630                 address(this)
631             )
632         );
633 
634         bytes32 structHash = keccak256(
635             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
636         );
637 
638         bytes32 digest = keccak256(
639             abi.encodePacked("\x19\x01", domainSeparator, structHash)
640         );
641 
642         address signatory = ecrecover(digest, v, r, s);
643         require(
644             signatory != address(0),
645             "BRAIN::delegateBySig: invalid signature"
646         );
647         require(
648             nonce == nonces[signatory]++,
649             "BRAIN::delegateBySig: invalid nonce"
650         );
651         require(block.timestamp <= expiry, "BRAIN::delegateBySig: signature expired");
652         return _delegate(signatory, delegatee);
653     }
654 
655     /**
656      * @notice Gets the current votes balance for `account`
657      * @param account The address to get votes balance
658      * @return The number of current votes for `account`
659      */
660     function getCurrentVotes(address account) external view returns (uint256) {
661         uint32 nCheckpoints = numCheckpoints[account];
662         return
663             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
664     }
665 
666     /**
667      * @notice Determine the prior number of votes for an account as of a block number
668      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
669      * @param account The address of the account to check
670      * @param blockNumber The block number to get the vote balance at
671      * @return The number of votes the account had as of the given block
672      */
673     function getPriorVotes(address account, uint256 blockNumber)
674         external
675         view
676         returns (uint256)
677     {
678         require(
679             blockNumber < block.number,
680             "BRAIN::getPriorVotes: not yet determined"
681         );
682 
683         uint32 nCheckpoints = numCheckpoints[account];
684         if (nCheckpoints == 0) {
685             return 0;
686         }
687 
688         // First check most recent balance
689         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
690             return checkpoints[account][nCheckpoints - 1].votes;
691         }
692 
693         // Next check implicit zero balance
694         if (checkpoints[account][0].fromBlock > blockNumber) {
695             return 0;
696         }
697 
698         uint32 lower = 0;
699         uint32 upper = nCheckpoints - 1;
700         while (upper > lower) {
701             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
702             Checkpoint memory cp = checkpoints[account][center];
703             if (cp.fromBlock == blockNumber) {
704                 return cp.votes;
705             } else if (cp.fromBlock < blockNumber) {
706                 lower = center;
707             } else {
708                 upper = center - 1;
709             }
710         }
711         return checkpoints[account][lower].votes;
712     }
713 
714     function _delegate(address delegator, address delegatee) internal {
715         address currentDelegate = _delegates[delegator];
716         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BRAIN (not scaled);
717         _delegates[delegator] = delegatee;
718 
719         emit DelegateChanged(delegator, currentDelegate, delegatee);
720 
721         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
722     }
723 
724     function _moveDelegates(
725         address srcRep,
726         address dstRep,
727         uint256 amount
728     ) internal {
729         if (srcRep != dstRep && amount > 0) {
730             if (srcRep != address(0)) {
731                 // decrease old representative
732                 uint32 srcRepNum = numCheckpoints[srcRep];
733                 uint256 srcRepOld = srcRepNum > 0
734                     ? checkpoints[srcRep][srcRepNum - 1].votes
735                     : 0;
736                 uint256 srcRepNew = srcRepOld - amount;
737                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
738             }
739 
740             if (dstRep != address(0)) {
741                 // increase new representative
742                 uint32 dstRepNum = numCheckpoints[dstRep];
743                 uint256 dstRepOld = dstRepNum > 0
744                     ? checkpoints[dstRep][dstRepNum - 1].votes
745                     : 0;
746                 uint256 dstRepNew = dstRepOld + amount;
747                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
748             }
749         }
750     }
751 
752     function _writeCheckpoint(
753         address delegatee,
754         uint32 nCheckpoints,
755         uint256 oldVotes,
756         uint256 newVotes
757     ) internal {
758         uint32 blockNumber = safe32(
759             block.number,
760             "BRAIN::_writeCheckpoint: block number exceeds 32 bits"
761         );
762 
763         if (
764             nCheckpoints > 0 &&
765             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
766         ) {
767             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
768         } else {
769             checkpoints[delegatee][nCheckpoints] = Checkpoint(
770                 blockNumber,
771                 newVotes
772             );
773             numCheckpoints[delegatee] = nCheckpoints + 1;
774         }
775 
776         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
777     }
778 
779     function safe32(uint256 n, string memory errorMessage)
780         internal
781         pure
782         returns (uint32)
783     {
784         require(n < 2**32, errorMessage);
785         return uint32(n);
786     }
787 
788     function getChainId() internal view returns (uint256) {
789         uint256 chainId;
790         assembly {
791             chainId := chainid()
792         }
793         return chainId;
794     }
795 }
796 
797 contract BRAINToken is BrainTokenInterface {
798     constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
799 }