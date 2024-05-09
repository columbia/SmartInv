1 // Sources flattened with hardhat v2.2.1 https://hardhat.org
2 
3 // File openzeppelin-solidity/contracts/token/ERC20/IERC20.sol@v4.1.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File openzeppelin-solidity/contracts/utils/Context.sol@v4.1.0
85 
86 
87 
88 pragma solidity ^0.8.0;
89 
90 /*
91  * @dev Provides information about the current execution context, including the
92  * sender of the transaction and its data. While these are generally available
93  * via msg.sender and msg.data, they should not be accessed in such a direct
94  * manner, since when dealing with meta-transactions the account sending and
95  * paying for execution may not be the actual sender (as far as an application
96  * is concerned).
97  *
98  * This contract is only required for intermediate, library-like contracts.
99  */
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
107         return msg.data;
108     }
109 }
110 
111 
112 // File contracts/ERC20Customized.sol
113 
114 
115 
116 pragma solidity ^0.8.0;
117 
118 
119 /**
120  * @dev Implementation of the {IERC20} interface.
121  *
122  * This implementation is agnostic to the way tokens are created. This means
123  * that a supply mechanism has to be added in a derived contract using {_mint}.
124  * For a generic mechanism see {ERC20PresetMinterPauser}.
125  *
126  * TIP: For a detailed writeup see our guide
127  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
128  * to implement supply mechanisms].
129  *
130  * We have followed general OpenZeppelin guidelines: functions revert instead
131  * of returning `false` on failure. This behavior is nonetheless conventional
132  * and does not conflict with the expectations of ERC20 applications.
133  *
134  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
135  * This allows applications to reconstruct the allowance for all accounts just
136  * by listening to said events. Other implementations of the EIP may not emit
137  * these events, as it isn't required by the specification.
138  *
139  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
140  * functions have been added to mitigate the well-known issues around setting
141  * allowances. See {IERC20-approve}.
142  */
143 contract ERC20 is Context, IERC20 {
144     mapping (address => uint256) private _balances;
145 
146     mapping (address => mapping (address => uint256)) private _allowances;
147 
148     uint256 private _totalSupply;
149 
150     string private _name;
151     string private _symbol;
152 
153     /**
154      * @dev Sets the values for {name} and {symbol}.
155      *
156      * The defaut value of {decimals} is 18. To select a different value for
157      * {decimals} you should overload it.
158      *
159      * All three of these values are immutable: they can only be set once during
160      * construction.
161      */
162     constructor (string memory name_, string memory symbol_) {
163         _name = name_;
164         _symbol = symbol_;
165     }
166 
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() public view virtual returns (string memory) {
171         return _name;
172     }
173 
174     /**
175      * @dev Returns the symbol of the token, usually a shorter version of the
176      * name.
177      */
178     function symbol() public view virtual returns (string memory) {
179         return _symbol;
180     }
181 
182     /**
183      * @dev Returns the number of decimals used to get its user representation.
184      * For example, if `decimals` equals `2`, a balance of `505` tokens should
185      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
186      *
187      * Tokens usually opt for a value of 18, imitating the relationship between
188      * Ether and Wei. This is the value {ERC20} uses, unless this function is
189      * overloaded;
190      *
191      * NOTE: This information is only used for _display_ purposes: it in
192      * no way affects any of the arithmetic of the contract, including
193      * {IERC20-balanceOf} and {IERC20-transfer}.
194      */
195     function decimals() public view virtual returns (uint8) {
196         return 18;
197     }
198 
199     /**
200      * @dev See {IERC20-totalSupply}.
201      */
202     function totalSupply() public view virtual override returns (uint256) {
203         return _totalSupply;
204     }
205 
206     /**
207      * @dev See {IERC20-balanceOf}.
208      */
209     function balanceOf(address account) public view virtual override returns (uint256) {
210         return _balances[account];
211     }
212 
213     /**
214      * @dev See {IERC20-transfer}.
215      *
216      * Requirements:
217      *
218      * - `recipient` cannot be the zero address.
219      * - the caller must have a balance of at least `amount`.
220      */
221     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
222         _transfer(_msgSender(), recipient, amount);
223         return true;
224     }
225 
226     /**
227      * @dev See {IERC20-allowance}.
228      */
229     function allowance(address owner, address spender) public view virtual override returns (uint256) {
230         return _allowances[owner][spender];
231     }
232 
233     /**
234      * @dev See {IERC20-approve}.
235      *
236      * Requirements:
237      *
238      * - `spender` cannot be the zero address.
239      */
240     function approve(address spender, uint256 amount) public virtual override returns (bool) {
241         _approve(_msgSender(), spender, amount);
242         return true;
243     }
244 
245     /**
246      * @dev See {IERC20-transferFrom}.
247      *
248      * Emits an {Approval} event indicating the updated allowance. This is not
249      * required by the EIP. See the note at the beginning of {ERC20}.
250      *
251      * Requirements:
252      *
253      * - `sender` and `recipient` cannot be the zero address.
254      * - `sender` must have a balance of at least `amount`.
255      * - the caller must have allowance for ``sender``'s tokens of at least
256      * `amount`.
257      */
258     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
259         _transfer(sender, recipient, amount);
260 
261         uint256 currentAllowance = _allowances[sender][_msgSender()];
262         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
263         _approve(sender, _msgSender(), currentAllowance - amount);
264 
265         return true;
266     }
267 
268     /**
269      * @dev Atomically increases the allowance granted to `spender` by the caller.
270      *
271      * This is an alternative to {approve} that can be used as a mitigation for
272      * problems described in {IERC20-approve}.
273      *
274      * Emits an {Approval} event indicating the updated allowance.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
281         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
282         return true;
283     }
284 
285     /**
286      * @dev Atomically decreases the allowance granted to `spender` by the caller.
287      *
288      * This is an alternative to {approve} that can be used as a mitigation for
289      * problems described in {IERC20-approve}.
290      *
291      * Emits an {Approval} event indicating the updated allowance.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      * - `spender` must have allowance for the caller of at least
297      * `subtractedValue`.
298      */
299     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
300         uint256 currentAllowance = _allowances[_msgSender()][spender];
301         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
302         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
303 
304         return true;
305     }
306 
307     /**
308      * @dev Moves tokens `amount` from `sender` to `recipient`.
309      *
310      * This is internal function is equivalent to {transfer}, and can be used to
311      * e.g. implement automatic token fees, slashing mechanisms, etc.
312      *
313      * Emits a {Transfer} event.
314      *
315      * Requirements:
316      *
317      * - `sender` cannot be the zero address.
318      * - `recipient` cannot be the zero address.
319      * - `sender` must have a balance of at least `amount`.
320      */
321     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
322         require(sender != address(0), "ERC20: transfer from the zero address");
323         require(recipient != address(0), "ERC20: transfer to the zero address");
324 
325         _beforeTokenTransfer(sender, recipient, amount);
326 
327         uint256 senderBalance = _balances[sender];
328         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
329         _balances[sender] = senderBalance - amount;
330         _balances[recipient] += amount;
331 
332         emit Transfer(sender, recipient, amount);
333     }
334 
335     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
336      * the total supply.
337      *
338      * Emits a {Transfer} event with `from` set to the zero address.
339      *
340      * Requirements:
341      *
342      * - `to` cannot be the zero address.
343      */
344     function _mint(address account, uint256 amount) internal virtual {
345         require(account != address(0), "ERC20: mint to the zero address");
346 
347         _beforeTokenTransfer(address(0), account, amount);
348 
349         _totalSupply += amount;
350         _balances[account] += amount;
351         emit Transfer(address(0), account, amount);
352     }
353 
354     /**
355      * @dev Destroys `amount` tokens from `account`, reducing the
356      * total supply.
357      *
358      * Emits a {Transfer} event with `to` set to the zero address.
359      *
360      * Requirements:
361      *
362      * - `account` cannot be the zero address.
363      * - `account` must have at least `amount` tokens.
364      */
365     function _burn(address account, uint256 amount) internal virtual {
366         require(account != address(0), "ERC20: burn from the zero address");
367 
368         _beforeTokenTransfer(account, address(0), amount);
369 
370         uint256 accountBalance = _balances[account];
371         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
372         _balances[account] = accountBalance - amount;
373         _balances[address(0)] = _balances[address(0)] + amount;
374 
375         emit Transfer(account, address(0), amount);
376     }
377 
378     /**
379      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
380      *
381      * This internal function is equivalent to `approve`, and can be used to
382      * e.g. set automatic allowances for certain subsystems, etc.
383      *
384      * Emits an {Approval} event.
385      *
386      * Requirements:
387      *
388      * - `owner` cannot be the zero address.
389      * - `spender` cannot be the zero address.
390      */
391     function _approve(address owner, address spender, uint256 amount) internal virtual {
392         require(owner != address(0), "ERC20: approve from the zero address");
393         require(spender != address(0), "ERC20: approve to the zero address");
394 
395         _allowances[owner][spender] = amount;
396         emit Approval(owner, spender, amount);
397     }
398 
399     /**
400      * @dev Hook that is called before any transfer of tokens. This includes
401      * minting and burning.
402      *
403      * Calling conditions:
404      *
405      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
406      * will be to transferred to `to`.
407      * - when `from` is zero, `amount` tokens will be minted for `to`.
408      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
409      * - `from` and `to` are never both zero.
410      *
411      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
412      */
413     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
414 }
415 
416 
417 // File contracts/ERC20BurnableCustomized.sol
418 
419 
420 
421 pragma solidity ^0.8.0;
422 
423 
424 /**
425  * @dev Extension of {ERC20} that allows token holders to destroy both their own
426  * tokens and those that they have an allowance for, in a way that can be
427  * recognized off-chain (via event analysis).
428  */
429 abstract contract ERC20Burnable is Context, ERC20 {
430     /**
431      * @dev Destroys `amount` tokens from the caller.
432      *
433      * See {ERC20-_burn}.
434      */
435     function burn(uint256 amount) public virtual {
436         _burn(_msgSender(), amount);
437     }
438 
439     /**
440      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
441      * allowance.
442      *
443      * See {ERC20-_burn} and {ERC20-allowance}.
444      *
445      * Requirements:
446      *
447      * - the caller must have allowance for ``accounts``'s tokens of at least
448      * `amount`.
449      */
450     function burnFrom(address account, uint256 amount) public virtual {
451         uint256 currentAllowance = allowance(account, _msgSender());
452         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
453         _approve(account, _msgSender(), currentAllowance - amount);
454         _burn(account, amount);
455     }
456 }
457 
458 
459 // File openzeppelin-solidity/contracts/access/Ownable.sol@v4.1.0
460 
461 
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Contract module which provides a basic access control mechanism, where
467  * there is an account (an owner) that can be granted exclusive access to
468  * specific functions.
469  *
470  * By default, the owner account will be the one that deploys the contract. This
471  * can later be changed with {transferOwnership}.
472  *
473  * This module is used through inheritance. It will make available the modifier
474  * `onlyOwner`, which can be applied to your functions to restrict their use to
475  * the owner.
476  */
477 abstract contract Ownable is Context {
478     address private _owner;
479 
480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor () {
486         address msgSender = _msgSender();
487         _owner = msgSender;
488         emit OwnershipTransferred(address(0), msgSender);
489     }
490 
491     /**
492      * @dev Returns the address of the current owner.
493      */
494     function owner() public view virtual returns (address) {
495         return _owner;
496     }
497 
498     /**
499      * @dev Throws if called by any account other than the owner.
500      */
501     modifier onlyOwner() {
502         require(owner() == _msgSender(), "Ownable: caller is not the owner");
503         _;
504     }
505 
506     /**
507      * @dev Leaves the contract without owner. It will not be possible to call
508      * `onlyOwner` functions anymore. Can only be called by the current owner.
509      *
510      * NOTE: Renouncing ownership will leave the contract without an owner,
511      * thereby removing any functionality that is only available to the owner.
512      */
513     function renounceOwnership() public virtual onlyOwner {
514         emit OwnershipTransferred(_owner, address(0));
515         _owner = address(0);
516     }
517 
518     /**
519      * @dev Transfers ownership of the contract to a new account (`newOwner`).
520      * Can only be called by the current owner.
521      */
522     function transferOwnership(address newOwner) public virtual onlyOwner {
523         require(newOwner != address(0), "Ownable: new owner is the zero address");
524         emit OwnershipTransferred(_owner, newOwner);
525         _owner = newOwner;
526     }
527 }
528 
529 
530 // File contracts/QAOToken.sol
531 
532 pragma solidity 0.8.1;
533 
534 
535 contract QAOToken is ERC20Burnable, Ownable {
536 
537     uint256 private constant DAY_IN_SEC = 86400;
538     uint256 private constant DIV_ACCURACY = 1 ether;
539 
540     uint256 public constant DAILY_MINT_AMOUNT = 100000000 ether;
541     uint256 public constant ANNUAL_TREASURY_MINT_AMOUNT = 1000000000000 ether;
542     uint256 private _mintMultiplier = 1 ether;
543 
544     uint256 private _mintAirdropShare = 0.45 ether;
545     uint256 private _mintLiqPoolShare = 0.45 ether;
546     uint256 private _mintApiRewardShare = 0.1 ether;
547 
548     /* by default minting will be disabled */
549     bool private mintingIsActive = false;
550 
551     /* track the total airdrop amount, because we need a stable value to avoid fifo winners on withdrawing airdrops */
552     uint256 private _totalAirdropAmount;
553 
554     /* timestamp which specifies when the next mint phase should happen */
555     uint256 private _nextMintTimestamp;
556 
557     /* treasury minting and withdrawing variables */
558     uint256 private _annualTreasuryMintCounter = 0; 
559     uint256 private _annualTreasuryMintTimestamp = 0;
560     address private _treasuryGuard;
561     bool private _treasuryLockGuard = false;
562     bool private _treasuryLockOwner = false;
563 
564     /* pools */
565     address private _airdropPool;
566     address private _liquidityPool;
567     address private _apiRewardPool;
568 
569     /* voting engine */
570     address private _votingEngine;
571 
572 
573     constructor( address swapLiqPool, address treasuryGuard) ERC20("QAO", unicode"🌐") {
574 
575         _mint(swapLiqPool, 9000000000000 ether);
576 
577         _treasuryGuard = treasuryGuard;
578         _annualTreasuryMint();
579     }
580 
581     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
582         _applyMintSchedule();
583         _annualTreasuryMint();
584         return ERC20.transfer(recipient, amount);
585     }
586 
587     /*******************************************************************
588      * Standard minting functionality
589      *******************************************************************/
590 
591     /* turn on minting. make sure you specified the addresses of the receiving pools first */
592     function activateMinting() public onlyOwner {
593         require(!mintingIsActive, "QAO Token: Minting has already been activated");
594         require(_airdropPool != address(0), "QAO Token: Please specify the address of the airdrop pool before activating minting.");
595         require(_liquidityPool != address(0), "QAO Token: Please specify the address of the liquidity pool before activating minting.");
596         require(_apiRewardPool != address(0), "QAO Token: Please specify the address of the api reward pool before activating minting.");
597 
598         mintingIsActive = true;
599         _mintToPools();
600         _nextMintTimestamp = block.timestamp + DAY_IN_SEC;
601     }
602 
603     /* apply minting for the current day and reprocess any missed day */
604     function _applyMintSchedule() private {
605         if (mintingIsActive){
606             while (block.timestamp >= _nextMintTimestamp){
607                 _mintToPools();
608                 _nextMintTimestamp = _nextMintTimestamp + DAY_IN_SEC;
609             }
610         }
611     }
612 
613     /* calculate minting supply for each pool and mint tokens to them */
614     function _mintToPools() private {
615         uint256 totalMintAmount = (DAILY_MINT_AMOUNT * _mintMultiplier) / DIV_ACCURACY;
616         uint256 airdropAmount = (totalMintAmount * _mintAirdropShare) / DIV_ACCURACY;
617         uint256 liqPoolAmount = (totalMintAmount * _mintLiqPoolShare) / DIV_ACCURACY;
618         uint256 apiRewardAmount = (totalMintAmount * _mintApiRewardShare) / DIV_ACCURACY;
619 
620         _mint(_airdropPool, airdropAmount);
621         _mint(_liquidityPool, liqPoolAmount);
622         _mint(_apiRewardPool, apiRewardAmount);
623     }
624 
625     /* Get amount of days passed since the provided timestamp */
626     function _getPassedDays(uint256 timestamp) private view returns (uint256) {
627         uint256 secondsDiff = block.timestamp - timestamp;
628         return (secondsDiff / DAY_IN_SEC);
629     }
630 
631     /*******************************************************************
632      * Treasury functionality
633      *******************************************************************/
634     function _annualTreasuryMint() private {
635         if (block.timestamp >= _annualTreasuryMintTimestamp && _annualTreasuryMintCounter < 4) {
636             _annualTreasuryMintTimestamp = block.timestamp + (365 * DAY_IN_SEC);
637             _annualTreasuryMintCounter = _annualTreasuryMintCounter + 1;
638             _mint(address(this), ANNUAL_TREASURY_MINT_AMOUNT);
639         }
640     }
641 
642     function unlockTreasuryByGuard() public {
643         require(_msgSender() == _treasuryGuard, "QAO Token: You shall not pass!");
644         _treasuryLockGuard = true;
645     }
646     function unlockTreasuryByOwner() public onlyOwner {
647         _treasuryLockOwner = true;
648     }
649 
650     function withdrawFromTreasury(address recipient, uint256 amount) public onlyOwner {
651         require(_treasuryLockGuard && _treasuryLockOwner, "QAO Token: Treasury is not unlocked.");
652         _transfer(address(this), recipient, amount);
653         _treasuryLockGuard = false;
654         _treasuryLockOwner = false;
655     }
656 
657     /*******************************************************************
658      * Voting engine support functionality
659      *******************************************************************/
660     function setVotingEngine(address votingEngineAddr) public onlyOwner {
661         _votingEngine = votingEngineAddr;
662     }
663 
664     function votingEngine() public view returns (address) {
665         return _votingEngine;
666     }
667 
668     function mintVoteStakeReward(uint256 amount) public {
669         require(_votingEngine != address(0), "QAO Token: Voting engine not set.");
670         require(_msgSender() == _votingEngine, "QAO Token: Only the voting engine can call this function.");
671         _mint(_votingEngine, amount);
672     }
673 
674     /*******************************************************************
675      * Getters/ Setters for mint multiplier
676      *******************************************************************/ 
677     function mintMultiplier() public view returns (uint256) {
678         return _mintMultiplier;
679     }
680     function setMintMultiplier(uint256 newMultiplier) public onlyOwner {
681         require(newMultiplier < _mintMultiplier, "QAO Token: Value of new multiplier needs to be lower than the current one.");
682         _mintMultiplier = newMultiplier;
683     }
684 
685     /*******************************************************************
686      * Getters/ Setters for minting pools
687      *******************************************************************/  
688     function airdropPool() public view returns (address){
689         return _airdropPool;
690     }
691     function setAirdropPool(address newAddress) public onlyOwner {
692         require(newAddress != address(0), "QAO Token: Address Zero cannot be the airdrop pool.");
693         _airdropPool = newAddress;
694     }
695 
696     function liquidityPool() public view returns (address){
697         return _liquidityPool;
698     }
699     function setLiquidityPool(address newAddress) public onlyOwner {
700         require(newAddress != address(0), "QAO Token: Address Zero cannot be the liquidity pool.");
701         _liquidityPool = newAddress;
702     }
703 
704     function apiRewardPool() public view returns (address){
705         return _apiRewardPool;
706     }
707     function setApiRewardPool(address newAddress) public onlyOwner {
708         require(newAddress != address(0), "QAO Token: Address Zero cannot be the reward pool.");
709         _apiRewardPool = newAddress;
710     }
711 
712     /*******************************************************************
713      * Getters/ Setters for minting distribution shares
714      *******************************************************************/
715     function mintAirdropShare() public view returns (uint256){
716         return _mintAirdropShare;
717     }
718     function setMintAirdropShare(uint256 newShare) public onlyOwner {
719         require((newShare + _mintLiqPoolShare + _mintApiRewardShare) <= 1 ether, "QAO Token: Sum of mint shares is greater than 100%.");
720         _mintAirdropShare = newShare;
721     }
722 
723     function mintLiqPoolShare() public view returns (uint256){
724         return _mintLiqPoolShare;
725     }
726     function setMintLiqPoolShare(uint256 newShare) public onlyOwner {
727         require((newShare + _mintAirdropShare + _mintApiRewardShare) <= 1 ether, "QAO Token: Sum of mint shares is greater than 100%.");
728         _mintLiqPoolShare = newShare;
729     }
730 
731     function mintApiRewardShare() public view returns (uint256){
732         return _mintApiRewardShare;
733     }
734     function setMintApiRewardShare(uint256 newShare) public onlyOwner {
735         require((newShare + _mintAirdropShare + _mintLiqPoolShare) <= 1 ether, "QAO Token: Sum of mint shares is greater than 100%.");
736         _mintApiRewardShare = newShare;
737     }
738 }