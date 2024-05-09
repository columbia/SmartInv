1 // File: @openzeppelin/contracts/GSN/Context.sol
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
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
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
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
97 
98 
99 pragma solidity ^0.6.0;
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP.
103  */
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * IMPORTANT: Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Moves `amount` tokens from `sender` to `recipient` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to {approve}. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 
176 
177 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
178 
179 
180 pragma solidity ^0.6.0;
181 
182 
183 
184 
185 
186 /**
187  * @dev Implementation of the {IERC20} interface.
188  *
189  * This implementation is agnostic to the way tokens are created. This means
190  * that a supply mechanism has to be added in a derived contract using {_mint}.
191  * For a generic mechanism see {ERC20PresetMinterPauser}.
192  *
193  * TIP: For a detailed writeup see our guide
194  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
195  * to implement supply mechanisms].
196  *
197  * We have followed general OpenZeppelin guidelines: functions revert instead
198  * of returning `false` on failure. This behavior is nonetheless conventional
199  * and does not conflict with the expectations of ERC20 applications.
200  *
201  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
202  * This allows applications to reconstruct the allowance for all accounts just
203  * by listening to said events. Other implementations of the EIP may not emit
204  * these events, as it isn't required by the specification.
205  *
206  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
207  * functions have been added to mitigate the well-known issues around setting
208  * allowances. See {IERC20-approve}.
209  */
210 contract ERC20 is Context, IERC20 {
211     using SafeMath for uint256;
212     using Address for address;
213 
214     mapping (address => uint256) private _balances;
215 
216     mapping (address => mapping (address => uint256)) private _allowances;
217 
218     uint256 private _totalSupply;
219 
220     string private _name;
221     string private _symbol;
222     uint8 private _decimals;
223 
224     /**
225      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
226      * a default value of 18.
227      *
228      * To select a different value for {decimals}, use {_setupDecimals}.
229      *
230      * All three of these values are immutable: they can only be set once during
231      * construction.
232      */
233     constructor (string memory name, string memory symbol) public {
234         _name = name;
235         _symbol = symbol;
236         _decimals = 18;
237     }
238 
239     /**
240      * @dev Returns the name of the token.
241      */
242     function name() public view returns (string memory) {
243         return _name;
244     }
245 
246     /**
247      * @dev Returns the symbol of the token, usually a shorter version of the
248      * name.
249      */
250     function symbol() public view returns (string memory) {
251         return _symbol;
252     }
253 
254     /**
255      * @dev Returns the number of decimals used to get its user representation.
256      * For example, if `decimals` equals `2`, a balance of `505` tokens should
257      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
258      *
259      * Tokens usually opt for a value of 18, imitating the relationship between
260      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
261      * called.
262      *
263      * NOTE: This information is only used for _display_ purposes: it in
264      * no way affects any of the arithmetic of the contract, including
265      * {IERC20-balanceOf} and {IERC20-transfer}.
266      */
267     function decimals() public view returns (uint8) {
268         return _decimals;
269     }
270 
271     /**
272      * @dev See {IERC20-totalSupply}.
273      */
274     function totalSupply() public view override returns (uint256) {
275         return _totalSupply;
276     }
277 
278     /**
279      * @dev See {IERC20-balanceOf}.
280      */
281     function balanceOf(address account) public view override returns (uint256) {
282         return _balances[account];
283     }
284 
285     /**
286      * @dev See {IERC20-transfer}.
287      *
288      * Requirements:
289      *
290      * - `recipient` cannot be the zero address.
291      * - the caller must have a balance of at least `amount`.
292      */
293     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
294         _transfer(_msgSender(), recipient, amount);
295         return true;
296     }
297 
298     /**
299      * @dev See {IERC20-allowance}.
300      */
301     function allowance(address owner, address spender) public view virtual override returns (uint256) {
302         return _allowances[owner][spender];
303     }
304 
305     /**
306      * @dev See {IERC20-approve}.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function approve(address spender, uint256 amount) public virtual override returns (bool) {
313         _approve(_msgSender(), spender, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-transferFrom}.
319      *
320      * Emits an {Approval} event indicating the updated allowance. This is not
321      * required by the EIP. See the note at the beginning of {ERC20};
322      *
323      * Requirements:
324      * - `sender` and `recipient` cannot be the zero address.
325      * - `sender` must have a balance of at least `amount`.
326      * - the caller must have allowance for ``sender``'s tokens of at least
327      * `amount`.
328      */
329     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
330         _transfer(sender, recipient, amount);
331         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
332         return true;
333     }
334 
335     /**
336      * @dev Atomically increases the allowance granted to `spender` by the caller.
337      *
338      * This is an alternative to {approve} that can be used as a mitigation for
339      * problems described in {IERC20-approve}.
340      *
341      * Emits an {Approval} event indicating the updated allowance.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      */
347     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
348         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
349         return true;
350     }
351 
352     /**
353      * @dev Atomically decreases the allowance granted to `spender` by the caller.
354      *
355      * This is an alternative to {approve} that can be used as a mitigation for
356      * problems described in {IERC20-approve}.
357      *
358      * Emits an {Approval} event indicating the updated allowance.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      * - `spender` must have allowance for the caller of at least
364      * `subtractedValue`.
365      */
366     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
367         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
368         return true;
369     }
370 
371     /**
372      * @dev Moves tokens `amount` from `sender` to `recipient`.
373      *
374      * This is internal function is equivalent to {transfer}, and can be used to
375      * e.g. implement automatic token fees, slashing mechanisms, etc.
376      *
377      * Emits a {Transfer} event.
378      *
379      * Requirements:
380      *
381      * - `sender` cannot be the zero address.
382      * - `recipient` cannot be the zero address.
383      * - `sender` must have a balance of at least `amount`.
384      */
385     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
386         require(sender != address(0), "ERC20: transfer from the zero address");
387         require(recipient != address(0), "ERC20: transfer to the zero address");
388 
389         _beforeTokenTransfer(sender, recipient, amount);
390 
391         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
392         _balances[recipient] = _balances[recipient].add(amount);
393         emit Transfer(sender, recipient, amount);
394     }
395 
396     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
397      * the total supply.
398      *
399      * Emits a {Transfer} event with `from` set to the zero address.
400      *
401      * Requirements
402      *
403      * - `to` cannot be the zero address.
404      */
405     function _mint(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: mint to the zero address");
407 
408         _beforeTokenTransfer(address(0), account, amount);
409 
410         _totalSupply = _totalSupply.add(amount);
411         _balances[account] = _balances[account].add(amount);
412         emit Transfer(address(0), account, amount);
413     }
414 
415     /**
416      * @dev Destroys `amount` tokens from `account`, reducing the
417      * total supply.
418      *
419      * Emits a {Transfer} event with `to` set to the zero address.
420      *
421      * Requirements
422      *
423      * - `account` cannot be the zero address.
424      * - `account` must have at least `amount` tokens.
425      */
426     function _burn(address account, uint256 amount) internal virtual {
427         require(account != address(0), "ERC20: burn from the zero address");
428 
429         _beforeTokenTransfer(account, address(0), amount);
430 
431         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
432         _totalSupply = _totalSupply.sub(amount);
433         emit Transfer(account, address(0), amount);
434     }
435 
436     /**
437      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
438      *
439      * This internal function is equivalent to `approve`, and can be used to
440      * e.g. set automatic allowances for certain subsystems, etc.
441      *
442      * Emits an {Approval} event.
443      *
444      * Requirements:
445      *
446      * - `owner` cannot be the zero address.
447      * - `spender` cannot be the zero address.
448      */
449     function _approve(address owner, address spender, uint256 amount) internal virtual {
450         require(owner != address(0), "ERC20: approve from the zero address");
451         require(spender != address(0), "ERC20: approve to the zero address");
452 
453         _allowances[owner][spender] = amount;
454         emit Approval(owner, spender, amount);
455     }
456 
457     /**
458      * @dev Sets {decimals} to a value other than the default one of 18.
459      *
460      * WARNING: This function should only be called from the constructor. Most
461      * applications that interact with token contracts will not expect
462      * {decimals} to ever change, and may work incorrectly if it does.
463      */
464     function _setupDecimals(uint8 decimals_) internal {
465         _decimals = decimals_;
466     }
467 
468     /**
469      * @dev Hook that is called before any transfer of tokens. This includes
470      * minting and burning.
471      *
472      * Calling conditions:
473      *
474      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
475      * will be to transferred to `to`.
476      * - when `from` is zero, `amount` tokens will be minted for `to`.
477      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
478      * - `from` and `to` are never both zero.
479      *
480      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
481      */
482     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
483 }
484 
485 
486 // File: localhost/contracts/POLContract.sol
487 
488 pragma solidity 0.6.12;
489 
490 
491 
492 contract POLContract {
493 
494     event Received(address, uint);
495     event onDeposit(address, uint256, uint256);
496     event onWithdraw(address, uint256);
497 
498     using SafeMath for uint256;
499 
500     struct VestingPeriod {
501         uint256 epoch;
502         uint256 amount;
503     }
504 
505     struct UserTokenInfo {
506         uint256 deposited; // incremented on successful deposit
507         uint256 withdrawn; // incremented on successful withdrawl
508         VestingPeriod[] vestingPeriods; // added to on successful deposit
509     }
510 
511     // map erc20 token to user address to release schedule
512     mapping(address => mapping(address => UserTokenInfo)) tokenUserMap;
513 
514     struct LiquidityTokenomics {
515         uint256[] epochs;
516         mapping (uint256 => uint256) releaseMap; // map epoch -> amount withdrawable
517     }
518 
519     // map erc20 token to release schedule
520     mapping(address => LiquidityTokenomics) tokenEpochMap;
521 
522 
523     // Fast mapping to prevent array iteration in solidity
524     mapping(address => bool) public lockedTokenLookup;
525 
526     // A dynamically-sized array of currently locked tokens
527     address[] public lockedTokens;
528 
529     // fee variables
530     uint256 public feeNumerator;
531     uint256 public feeDenominator;
532 
533     address public feeReserveAddress;
534     address public owner;
535 
536     constructor() public {
537         feeNumerator = 3;
538         feeDenominator = 1000;
539         feeReserveAddress = address(0xAA3d85aD9D128DFECb55424085754F6dFa643eb1);
540         owner = address(0xfCdd591498e86876F086524C0b2E9Af41a0c9FCD);
541     }
542 
543     receive() external payable {
544         emit Received(msg.sender, msg.value);
545     }
546 
547     modifier onlyOwner {
548         require(msg.sender == owner, "You are not the owner");
549         _;
550     }
551 
552     function updateFee(uint256 numerator, uint256 denominator) onlyOwner public {
553         feeNumerator = numerator;
554         feeDenominator = denominator;
555     }
556 
557     function calculateFee(uint256 amount) public view returns (uint256){
558         require(amount >= feeDenominator, 'Deposit is too small');
559         uint256 amountInLarge = amount.mul(feeDenominator.sub(feeNumerator));
560         uint256 amountIn = amountInLarge.div(feeDenominator);
561         uint256 fee = amount.sub(amountIn);
562         return (fee);
563     }
564 
565     function depositTokenMultipleEpochs(address token, uint256[] memory amounts, uint256[] memory dates) public payable {
566         require(amounts.length == dates.length, 'Amount and date arrays have differing lengths');
567         for (uint i=0; i<amounts.length; i++) {
568             depositToken(token, amounts[i], dates[i]);
569         }
570     }
571 
572     function depositToken(address token, uint256 amount, uint256 unlock_date) public payable {
573         require(unlock_date < 10000000000, 'Enter an unix timestamp in seconds, not miliseconds');
574         require(amount > 0, 'Your attempting to trasfer 0 tokens');
575         uint256 allowance = IERC20(token).allowance(msg.sender, address(this));
576         require(allowance >= amount, 'You need to set a higher allowance');
577         // charge a fee
578         uint256 fee = calculateFee(amount);
579         uint256 amountIn = amount.sub(fee);
580         require(IERC20(token).transferFrom(msg.sender, address(this), amountIn), 'Transfer failed');
581         require(IERC20(token).transferFrom(msg.sender, address(feeReserveAddress), fee), 'Transfer failed');
582         if (!lockedTokenLookup[token]) {
583             lockedTokens.push(token);
584             lockedTokenLookup[token] = true;
585         }
586         LiquidityTokenomics storage liquidityTokenomics = tokenEpochMap[token];
587         // amount is required to be above 0 in the start of this block, therefore this works
588         if (liquidityTokenomics.releaseMap[unlock_date] > 0) {
589             liquidityTokenomics.releaseMap[unlock_date] = liquidityTokenomics.releaseMap[unlock_date].add(amountIn);
590         } else {
591             liquidityTokenomics.epochs.push(unlock_date);
592             liquidityTokenomics.releaseMap[unlock_date] = amountIn;
593         }
594         UserTokenInfo storage uto = tokenUserMap[token][msg.sender];
595         uto.deposited = uto.deposited.add(amountIn);
596         VestingPeriod[] storage vp = uto.vestingPeriods;
597         vp.push(VestingPeriod(unlock_date, amountIn));
598 
599         emit onDeposit(token, amount, unlock_date);
600     }
601 
602     function withdrawToken(address token, uint256 amount) public {
603         require(amount > 0, 'Your attempting to withdraw 0 tokens');
604         uint256 withdrawable = getWithdrawableBalance(token, msg.sender);
605         UserTokenInfo storage uto = tokenUserMap[token][msg.sender];
606         uto.withdrawn = uto.withdrawn.add(amount);
607         require(amount <= withdrawable, 'Your attempting to withdraw more than you have available');
608         require(IERC20(token).transfer(msg.sender, amount), 'Transfer failed');
609         emit onWithdraw(token, amount);
610     }
611 
612     function getWithdrawableBalance(address token, address user) public view returns (uint256) {
613         UserTokenInfo storage uto = tokenUserMap[token][address(user)];
614         uint arrayLength = uto.vestingPeriods.length;
615         uint256 withdrawable = 0;
616         for (uint i=0; i<arrayLength; i++) {
617             VestingPeriod storage vestingPeriod = uto.vestingPeriods[i];
618             if (vestingPeriod.epoch < block.timestamp) {
619                 withdrawable = withdrawable.add(vestingPeriod.amount);
620             }
621         }
622         withdrawable = withdrawable.sub(uto.withdrawn);
623         return withdrawable;
624     }
625 
626     function getUserTokenInfo (address token, address user) public view returns (uint256, uint256, uint256) {
627         UserTokenInfo storage uto = tokenUserMap[address(token)][address(user)];
628         uint256 deposited = uto.deposited;
629         uint256 withdrawn = uto.withdrawn;
630         uint256 length = uto.vestingPeriods.length;
631         return (deposited, withdrawn, length);
632     }
633 
634     function getUserVestingAtIndex (address token, address user, uint index) public view returns (uint256, uint256) {
635         UserTokenInfo storage uto = tokenUserMap[address(token)][address(user)];
636         VestingPeriod storage vp = uto.vestingPeriods[index];
637         return (vp.epoch, vp.amount);
638     }
639 
640     function getTokenReleaseLength (address token) public view returns (uint256) {
641         LiquidityTokenomics storage liquidityTokenomics = tokenEpochMap[address(token)];
642         return liquidityTokenomics.epochs.length;
643     }
644 
645     function getTokenReleaseAtIndex (address token, uint index) public view returns (uint256, uint256) {
646         LiquidityTokenomics storage liquidityTokenomics = tokenEpochMap[address(token)];
647         uint256 epoch = liquidityTokenomics.epochs[index];
648         uint256 amount = liquidityTokenomics.releaseMap[epoch];
649         return (epoch, amount);
650     }
651 
652     function lockedTokensLength() external view returns (uint) {
653         return lockedTokens.length;
654     }
655 }
656 // File: localhost/contracts/SpaceMineToken.sol
657 
658 
659 pragma solidity 0.6.12;
660 
661 
662 
663 
664 
665 contract SpaceMineCore is ERC20("SpaceMineToken", "MINE"), Ownable {
666     using SafeMath for uint256;
667 
668     address internal _taxer;
669     address internal _taxDestination;
670 	uint256 internal _cap;
671     uint internal _taxRate = 0;
672     bool internal _lock = true;
673     mapping (address => bool) internal _taxWhitelist;
674 
675     function transfer(address recipient, uint256 amount) public override returns (bool) {
676         require(msg.sender == owner() || !_lock, "Transfer is locking");
677 
678         uint256 taxAmount = amount.mul(_taxRate).div(100);
679         if (_taxWhitelist[msg.sender] == true) {
680             taxAmount = 0;
681         }
682         uint256 transferAmount = amount.sub(taxAmount);
683         require(balanceOf(msg.sender) >= amount, "insufficient balance.");
684         super.transfer(recipient, transferAmount);
685 
686         if (taxAmount != 0) {
687             super.transfer(_taxDestination, taxAmount);
688         }
689         return true;
690     }
691 
692     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
693         require(sender == owner() || !_lock, "TransferFrom is locking");
694 
695         uint256 taxAmount = amount.mul(_taxRate).div(100);
696         if (_taxWhitelist[sender] == true) {
697             taxAmount = 0;
698         }
699         uint256 transferAmount = amount.sub(taxAmount);
700         require(balanceOf(sender) >= amount, "insufficient balance.");
701         super.transferFrom(sender, recipient, transferAmount);
702         if (taxAmount != 0) {
703             super.transferFrom(sender, _taxDestination, taxAmount);
704         }
705         return true;
706     }
707 
708 	function _mint(address account, uint256 value) override internal {
709         require(totalSupply().add(value) <= _cap, "cap exceeded");
710         super._mint(account, value);
711     }
712 }
713 
714 contract SpaceMineToken is SpaceMineCore {
715     mapping (address => bool) public minters;
716 
717 	uint256 public constant hard_cap = 96000 * 1e18;
718 
719     constructor() public {
720         _taxer = owner();
721         _taxDestination = owner();
722 		_cap = hard_cap;
723     }
724 
725 	function cap() public view returns (uint256) {
726         return _cap;
727     }
728 
729     function mint(address to, uint amount) public onlyMinter {
730         _mint(to, amount);
731 		_moveDelegates(address(0), _delegates[to], amount);
732     }
733 
734 	/// @notice A record of each accounts delegate
735 	mapping (address => address) public _delegates;
736 	/// @notice A checkpoint for marking number of votes from a given block
737     struct Checkpoint {
738         uint32 fromBlock;
739         uint256 votes;
740     }
741 
742     /// @notice A record of votes checkpoints for each account, by index
743     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
744 
745     /// @notice The number of checkpoints for each account
746     mapping (address => uint32) public numCheckpoints;
747 
748     /// @notice The EIP-712 typehash for the contract's domain
749     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
750 
751     /// @notice The EIP-712 typehash for the delegation struct used by the contract
752     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
753 
754     /// @notice A record of states for signing / validating signatures
755     mapping (address => uint) public nonces;
756 
757       /// @notice An event thats emitted when an account changes its delegate
758     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
759 
760     /// @notice An event thats emitted when a delegate account's vote balance changes
761     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
762 
763     /**
764      * @notice Delegate votes from `msg.sender` to `delegatee`
765      * @param delegator The address to get delegatee for
766      */
767     function delegates(address delegator)
768         external
769         view
770         returns (address)
771     {
772         return _delegates[delegator];
773     }
774 
775    /**
776     * @notice Delegate votes from `msg.sender` to `delegatee`
777     * @param delegatee The address to delegate votes to
778     */
779     function delegate(address delegatee) external {
780         return _delegate(msg.sender, delegatee);
781     }
782 
783     /**
784      * @notice Delegates votes from signatory to `delegatee`
785      * @param delegatee The address to delegate votes to
786      * @param nonce The contract state required to match the signature
787      * @param expiry The time at which to expire the signature
788      * @param v The recovery byte of the signature
789      * @param r Half of the ECDSA signature pair
790      * @param s Half of the ECDSA signature pair
791      */
792     function delegateBySig(
793         address delegatee,
794         uint nonce,
795         uint expiry,
796         uint8 v,
797         bytes32 r,
798         bytes32 s
799     )
800         external
801     {
802         bytes32 domainSeparator = keccak256(
803             abi.encode(
804                 DOMAIN_TYPEHASH,
805                 keccak256(bytes(name())),
806                 getChainId(),
807                 address(this)
808             )
809         );
810 
811         bytes32 structHash = keccak256(
812             abi.encode(
813                 DELEGATION_TYPEHASH,
814                 delegatee,
815                 nonce,
816                 expiry
817             )
818         );
819 
820         bytes32 digest = keccak256(
821             abi.encodePacked(
822                 "\x19\x01",
823                 domainSeparator,
824                 structHash
825             )
826         );
827 
828         address signatory = ecrecover(digest, v, r, s);
829         require(signatory != address(0), "MINE:delegateBySig: invalid signature");
830         require(nonce == nonces[signatory]++, "MINE::delegateBySig: invalid nonce");
831         require(block.timestamp <= expiry, "MINE::delegateBySig: signature expired");
832         return _delegate(signatory, delegatee);
833     }
834 
835     /**
836      * @notice Gets the current votes balance for `account`
837      * @param account The address to get votes balance
838      * @return The number of current votes for `account`
839      */
840     function getCurrentVotes(address account)
841         external
842         view
843         returns (uint256)
844     {
845         uint32 nCheckpoints = numCheckpoints[account];
846         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
847     }
848 
849     /**
850      * @notice Determine the prior number of votes for an account as of a block number
851      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
852      * @param account The address of the account to check
853      * @param blockNumber The block number to get the vote balance at
854      * @return The number of votes the account had as of the given block
855      */
856     function getPriorVotes(address account, uint blockNumber)
857         external
858         view
859         returns (uint256)
860     {
861         require(blockNumber < block.number, "MINE::getPriorVotes: not yet determined");
862 
863         uint32 nCheckpoints = numCheckpoints[account];
864         if (nCheckpoints == 0) {
865             return 0;
866         }
867 
868         // First check most recent balance
869         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
870             return checkpoints[account][nCheckpoints - 1].votes;
871         }
872 
873         // Next check implicit zero balance
874         if (checkpoints[account][0].fromBlock > blockNumber) {
875             return 0;
876         }
877 
878         uint32 lower = 0;
879         uint32 upper = nCheckpoints - 1;
880         while (upper > lower) {
881             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
882             Checkpoint memory cp = checkpoints[account][center];
883             if (cp.fromBlock == blockNumber) {
884                 return cp.votes;
885             } else if (cp.fromBlock < blockNumber) {
886                 lower = center;
887             } else {
888                 upper = center - 1;
889             }
890         }
891         return checkpoints[account][lower].votes;
892     }
893 
894     function _delegate(address delegator, address delegatee)
895         internal
896     {
897         address currentDelegate = _delegates[delegator];
898         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MINE;
899         _delegates[delegator] = delegatee;
900 
901         emit DelegateChanged(delegator, currentDelegate, delegatee);
902 
903         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
904     }
905 
906     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
907         if (srcRep != dstRep && amount > 0) {
908             if (srcRep != address(0)) {
909                 // decrease old representative
910                 uint32 srcRepNum = numCheckpoints[srcRep];
911                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
912                 uint256 srcRepNew = srcRepOld-amount;
913                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
914             }
915 
916             if (dstRep != address(0)) {
917                 // increase new representative
918                 uint32 dstRepNum = numCheckpoints[dstRep];
919                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
920                 uint256 dstRepNew = dstRepOld+amount;
921                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
922             }
923         }
924     }
925 
926     function _writeCheckpoint(
927         address delegatee,
928         uint32 nCheckpoints,
929         uint256 oldVotes,
930         uint256 newVotes
931     )
932         internal
933     {
934         uint32 blockNumber = safe32(block.number, "MINE::_writeCheckpoint: block number exceeds 32 bits");
935 
936         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
937             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
938         } else {
939             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
940             numCheckpoints[delegatee] = nCheckpoints + 1;
941         }
942 
943         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
944     }
945 
946     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
947         require(n < 2**32, errorMessage);
948         return uint32(n);
949     }
950 
951     function getChainId() internal pure returns (uint) {
952         uint256 chainId;
953         assembly { chainId := chainid() }
954         return chainId;
955     }
956 
957     function burn(uint amount) public {
958         require(amount > 0);
959         require(balanceOf(msg.sender) >= amount);
960         _burn(msg.sender, amount);
961     }
962 
963     function addMinter(address account) public onlyOwner {
964         minters[account] = true;
965     }
966 
967     function removeMinter(address account) public onlyOwner {
968         minters[account] = false;
969     }
970 
971     modifier onlyMinter() {
972         require(minters[msg.sender], "Restricted to minters.");
973         _;
974     }
975 
976     modifier onlyTaxer() {
977         require(msg.sender == _taxer, "Only for taxer.");
978         _;
979     }
980 
981     function setTaxer(address account) public onlyTaxer {
982         _taxer = account;
983     }
984 
985     function setTaxRate(uint256 rate) public onlyTaxer {
986         _taxRate = rate;
987     }
988 
989     function setTaxDestination(address account) public onlyTaxer {
990         _taxDestination = account;
991     }
992 
993     function addToWhitelist(address account) public onlyTaxer {
994         _taxWhitelist[account] = true;
995     }
996 
997     function removeFromWhitelist(address account) public onlyTaxer {
998         _taxWhitelist[account] = false;
999     }
1000 
1001     function taxer() public view returns(address) {
1002         return _taxer;
1003     }
1004 
1005     function taxDestination() public view returns(address) {
1006         return _taxDestination;
1007     }
1008 
1009     function taxRate() public view returns(uint256) {
1010         return _taxRate;
1011     }
1012 
1013     function isInWhitelist(address account) public view returns(bool) {
1014         return _taxWhitelist[account];
1015     }
1016 
1017     function unlock() public onlyOwner {
1018         _lock = false;
1019     }
1020 
1021     function getLockStatus() view public returns(bool) {
1022         return _lock;
1023     }
1024 }
1025 // File: localhost/contracts/uniswapv2/interfaces/IERC20.sol
1026 
1027 pragma solidity >=0.5.0;
1028 
1029 interface IERC20Uniswap {
1030     event Approval(address indexed owner, address indexed spender, uint value);
1031     event Transfer(address indexed from, address indexed to, uint value);
1032 
1033     function name() external view returns (string memory);
1034     function symbol() external view returns (string memory);
1035     function decimals() external view returns (uint8);
1036     function totalSupply() external view returns (uint);
1037     function balanceOf(address owner) external view returns (uint);
1038     function allowance(address owner, address spender) external view returns (uint);
1039 
1040     function approve(address spender, uint value) external returns (bool);
1041     function transfer(address to, uint value) external returns (bool);
1042     function transferFrom(address from, address to, uint value) external returns (bool);
1043 }
1044 
1045 // File: localhost/contracts/uniswapv2/interfaces/IWETH.sol
1046 
1047 pragma solidity >=0.5.0;
1048 
1049 interface IWETH {
1050     function deposit() external payable;
1051     function transfer(address to, uint value) external returns (bool);
1052     function withdraw(uint) external;
1053 }
1054 // File: localhost/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
1055 
1056 pragma solidity >=0.5.0;
1057 
1058 interface IUniswapV2Pair {
1059     event Approval(address indexed owner, address indexed spender, uint value);
1060     event Transfer(address indexed from, address indexed to, uint value);
1061 
1062     function name() external pure returns (string memory);
1063     function symbol() external pure returns (string memory);
1064     function decimals() external pure returns (uint8);
1065     function totalSupply() external view returns (uint);
1066     function balanceOf(address owner) external view returns (uint);
1067     function allowance(address owner, address spender) external view returns (uint);
1068 
1069     function approve(address spender, uint value) external returns (bool);
1070     function transfer(address to, uint value) external returns (bool);
1071     function transferFrom(address from, address to, uint value) external returns (bool);
1072 
1073     function DOMAIN_SEPARATOR() external view returns (bytes32);
1074     function PERMIT_TYPEHASH() external pure returns (bytes32);
1075     function nonces(address owner) external view returns (uint);
1076 
1077     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1078 
1079     event Mint(address indexed sender, uint amount0, uint amount1);
1080     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1081     event Swap(
1082         address indexed sender,
1083         uint amount0In,
1084         uint amount1In,
1085         uint amount0Out,
1086         uint amount1Out,
1087         address indexed to
1088     );
1089     event Sync(uint112 reserve0, uint112 reserve1);
1090 
1091     function MINIMUM_LIQUIDITY() external pure returns (uint);
1092     function factory() external view returns (address);
1093     function token0() external view returns (address);
1094     function token1() external view returns (address);
1095     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1096     function price0CumulativeLast() external view returns (uint);
1097     function price1CumulativeLast() external view returns (uint);
1098     function kLast() external view returns (uint);
1099 
1100     function mint(address to) external returns (uint liquidity);
1101     function burn(address to) external returns (uint amount0, uint amount1);
1102     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1103     function skim(address to) external;
1104     function sync() external;
1105 
1106     function initialize(address, address) external;
1107 }
1108 // File: localhost/contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
1109 
1110 pragma solidity >=0.6.2;
1111 
1112 interface IUniswapV2Router01 {
1113     function factory() external pure returns (address);
1114     function WETH() external pure returns (address);
1115 
1116     function addLiquidity(
1117         address tokenA,
1118         address tokenB,
1119         uint amountADesired,
1120         uint amountBDesired,
1121         uint amountAMin,
1122         uint amountBMin,
1123         address to,
1124         uint deadline
1125     ) external returns (uint amountA, uint amountB, uint liquidity);
1126     function addLiquidityETH(
1127         address token,
1128         uint amountTokenDesired,
1129         uint amountTokenMin,
1130         uint amountETHMin,
1131         address to,
1132         uint deadline
1133     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1134     function removeLiquidity(
1135         address tokenA,
1136         address tokenB,
1137         uint liquidity,
1138         uint amountAMin,
1139         uint amountBMin,
1140         address to,
1141         uint deadline
1142     ) external returns (uint amountA, uint amountB);
1143     function removeLiquidityETH(
1144         address token,
1145         uint liquidity,
1146         uint amountTokenMin,
1147         uint amountETHMin,
1148         address to,
1149         uint deadline
1150     ) external returns (uint amountToken, uint amountETH);
1151     function removeLiquidityWithPermit(
1152         address tokenA,
1153         address tokenB,
1154         uint liquidity,
1155         uint amountAMin,
1156         uint amountBMin,
1157         address to,
1158         uint deadline,
1159         bool approveMax, uint8 v, bytes32 r, bytes32 s
1160     ) external returns (uint amountA, uint amountB);
1161     function removeLiquidityETHWithPermit(
1162         address token,
1163         uint liquidity,
1164         uint amountTokenMin,
1165         uint amountETHMin,
1166         address to,
1167         uint deadline,
1168         bool approveMax, uint8 v, bytes32 r, bytes32 s
1169     ) external returns (uint amountToken, uint amountETH);
1170     function swapExactTokensForTokens(
1171         uint amountIn,
1172         uint amountOutMin,
1173         address[] calldata path,
1174         address to,
1175         uint deadline
1176     ) external returns (uint[] memory amounts);
1177     function swapTokensForExactTokens(
1178         uint amountOut,
1179         uint amountInMax,
1180         address[] calldata path,
1181         address to,
1182         uint deadline
1183     ) external returns (uint[] memory amounts);
1184     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1185         external
1186         payable
1187         returns (uint[] memory amounts);
1188     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1189         external
1190         returns (uint[] memory amounts);
1191     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1192         external
1193         returns (uint[] memory amounts);
1194     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1195         external
1196         payable
1197         returns (uint[] memory amounts);
1198 
1199     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1200     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1201     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1202     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1203     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1204 }
1205 // File: localhost/contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
1206 
1207 pragma solidity >=0.6.2;
1208 
1209 
1210 interface IUniswapV2Router02 is IUniswapV2Router01 {
1211     function removeLiquidityETHSupportingFeeOnTransferTokens(
1212         address token,
1213         uint liquidity,
1214         uint amountTokenMin,
1215         uint amountETHMin,
1216         address to,
1217         uint deadline
1218     ) external returns (uint amountETH);
1219     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1220         address token,
1221         uint liquidity,
1222         uint amountTokenMin,
1223         uint amountETHMin,
1224         address to,
1225         uint deadline,
1226         bool approveMax, uint8 v, bytes32 r, bytes32 s
1227     ) external returns (uint amountETH);
1228 
1229   /*
1230     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1231         uint amountIn,
1232         uint amountOutMin,
1233         address[] calldata path,
1234         address to,
1235         uint deadline
1236     ) external;
1237     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1238         uint amountOutMin,
1239         address[] calldata path,
1240         address to,
1241         uint deadline
1242     ) external payable;
1243     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1244         uint amountIn,
1245         uint amountOutMin,
1246         address[] calldata path,
1247         address to,
1248         uint deadline
1249     ) external;
1250   */
1251 }
1252 
1253 // File: localhost/contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
1254 
1255 pragma solidity >=0.5.0;
1256 
1257 interface IUniswapV2Factory {
1258     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1259 
1260     function feeTo() external view returns (address);
1261     function feeToSetter() external view returns (address);
1262     function migrator() external view returns (address);
1263 
1264     function getPair(address tokenA, address tokenB) external view returns (address pair);
1265     function allPairs(uint) external view returns (address pair);
1266     function allPairsLength() external view returns (uint);
1267 
1268     function createPair(address tokenA, address tokenB) external returns (address pair);
1269 
1270     function setFeeTo(address) external;
1271     function setFeeToSetter(address) external;
1272     function setMigrator(address) external;
1273 }
1274 
1275 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
1276 
1277 
1278 pragma solidity ^0.6.0;
1279 
1280 
1281 
1282 
1283 /**
1284  * @title SafeERC20
1285  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1286  * contract returns false). Tokens that return no value (and instead revert or
1287  * throw on failure) are also supported, non-reverting calls are assumed to be
1288  * successful.
1289  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1290  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1291  */
1292 library SafeERC20 {
1293     using SafeMath for uint256;
1294     using Address for address;
1295 
1296     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1297         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1298     }
1299 
1300     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1301         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1302     }
1303 
1304     /**
1305      * @dev Deprecated. This function has issues similar to the ones found in
1306      * {IERC20-approve}, and its usage is discouraged.
1307      *
1308      * Whenever possible, use {safeIncreaseAllowance} and
1309      * {safeDecreaseAllowance} instead.
1310      */
1311     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1312         // safeApprove should only be called when setting an initial allowance,
1313         // or when resetting it to zero. To increase and decrease it, use
1314         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1315         // solhint-disable-next-line max-line-length
1316         require((value == 0) || (token.allowance(address(this), spender) == 0),
1317             "SafeERC20: approve from non-zero to non-zero allowance"
1318         );
1319         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1320     }
1321 
1322     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1323         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1324         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1325     }
1326 
1327     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1328         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1329         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1330     }
1331 
1332     /**
1333      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1334      * on the return value: the return value is optional (but if data is returned, it must not be false).
1335      * @param token The token targeted by the call.
1336      * @param data The call data (encoded using abi.encode or one of its variants).
1337      */
1338     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1339         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1340         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1341         // the target address contains contract code and also asserts for success in the low-level call.
1342 
1343         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1344         if (returndata.length > 0) { // Return data is optional
1345             // solhint-disable-next-line max-line-length
1346             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1347         }
1348     }
1349 }
1350 
1351 // File: @openzeppelin/contracts/utils/Address.sol
1352 
1353 
1354 pragma solidity ^0.6.2;
1355 
1356 /**
1357  * @dev Collection of functions related to the address type
1358  */
1359 library Address {
1360     /**
1361      * @dev Returns true if `account` is a contract.
1362      *
1363      * [IMPORTANT]
1364      * ====
1365      * It is unsafe to assume that an address for which this function returns
1366      * false is an externally-owned account (EOA) and not a contract.
1367      *
1368      * Among others, `isContract` will return false for the following
1369      * types of addresses:
1370      *
1371      *  - an externally-owned account
1372      *  - a contract in construction
1373      *  - an address where a contract will be created
1374      *  - an address where a contract lived, but was destroyed
1375      * ====
1376      */
1377     function isContract(address account) internal view returns (bool) {
1378         // This method relies in extcodesize, which returns 0 for contracts in
1379         // construction, since the code is only stored at the end of the
1380         // constructor execution.
1381 
1382         uint256 size;
1383         // solhint-disable-next-line no-inline-assembly
1384         assembly { size := extcodesize(account) }
1385         return size > 0;
1386     }
1387 
1388     /**
1389      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1390      * `recipient`, forwarding all available gas and reverting on errors.
1391      *
1392      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1393      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1394      * imposed by `transfer`, making them unable to receive funds via
1395      * `transfer`. {sendValue} removes this limitation.
1396      *
1397      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1398      *
1399      * IMPORTANT: because control is transferred to `recipient`, care must be
1400      * taken to not create reentrancy vulnerabilities. Consider using
1401      * {ReentrancyGuard} or the
1402      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1403      */
1404     function sendValue(address payable recipient, uint256 amount) internal {
1405         require(address(this).balance >= amount, "Address: insufficient balance");
1406 
1407         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1408         (bool success, ) = recipient.call{ value: amount }("");
1409         require(success, "Address: unable to send value, recipient may have reverted");
1410     }
1411 
1412     /**
1413      * @dev Performs a Solidity function call using a low level `call`. A
1414      * plain`call` is an unsafe replacement for a function call: use this
1415      * function instead.
1416      *
1417      * If `target` reverts with a revert reason, it is bubbled up by this
1418      * function (like regular Solidity function calls).
1419      *
1420      * Returns the raw returned data. To convert to the expected return value,
1421      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1422      *
1423      * Requirements:
1424      *
1425      * - `target` must be a contract.
1426      * - calling `target` with `data` must not revert.
1427      *
1428      * _Available since v3.1._
1429      */
1430     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1431       return functionCall(target, data, "Address: low-level call failed");
1432     }
1433 
1434     /**
1435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1436      * `errorMessage` as a fallback revert reason when `target` reverts.
1437      *
1438      * _Available since v3.1._
1439      */
1440     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1441         return _functionCallWithValue(target, data, 0, errorMessage);
1442     }
1443 
1444     /**
1445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1446      * but also transferring `value` wei to `target`.
1447      *
1448      * Requirements:
1449      *
1450      * - the calling contract must have an ETH balance of at least `value`.
1451      * - the called Solidity function must be `payable`.
1452      *
1453      * _Available since v3.1._
1454      */
1455     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1456         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1457     }
1458 
1459     /**
1460      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1461      * with `errorMessage` as a fallback revert reason when `target` reverts.
1462      *
1463      * _Available since v3.1._
1464      */
1465     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1466         require(address(this).balance >= value, "Address: insufficient balance for call");
1467         return _functionCallWithValue(target, data, value, errorMessage);
1468     }
1469 
1470     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
1471         require(isContract(target), "Address: call to non-contract");
1472 
1473         // solhint-disable-next-line avoid-low-level-calls
1474         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
1475         if (success) {
1476             return returndata;
1477         } else {
1478             // Look for revert reason and bubble it up if present
1479             if (returndata.length > 0) {
1480                 // The easiest way to bubble the revert reason is using memory via assembly
1481 
1482                 // solhint-disable-next-line no-inline-assembly
1483                 assembly {
1484                     let returndata_size := mload(returndata)
1485                     revert(add(32, returndata), returndata_size)
1486                 }
1487             } else {
1488                 revert(errorMessage);
1489             }
1490         }
1491     }
1492 }
1493 
1494 
1495 
1496 
1497 // File: @openzeppelin/contracts/math/SafeMath.sol
1498 
1499 
1500 pragma solidity ^0.6.0;
1501 
1502 /**
1503  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1504  * checks.
1505  *
1506  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1507  * in bugs, because programmers usually assume that an overflow raises an
1508  * error, which is the standard behavior in high level programming languages.
1509  * `SafeMath` restores this intuition by reverting the transaction when an
1510  * operation overflows.
1511  *
1512  * Using this library instead of the unchecked operations eliminates an entire
1513  * class of bugs, so it's recommended to use it always.
1514  */
1515 library SafeMath {
1516     /**
1517      * @dev Returns the addition of two unsigned integers, reverting on
1518      * overflow.
1519      *
1520      * Counterpart to Solidity's `+` operator.
1521      *
1522      * Requirements:
1523      *
1524      * - Addition cannot overflow.
1525      */
1526     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1527         uint256 c = a + b;
1528         require(c >= a, "SafeMath: addition overflow");
1529 
1530         return c;
1531     }
1532 
1533     /**
1534      * @dev Returns the subtraction of two unsigned integers, reverting on
1535      * overflow (when the result is negative).
1536      *
1537      * Counterpart to Solidity's `-` operator.
1538      *
1539      * Requirements:
1540      *
1541      * - Subtraction cannot overflow.
1542      */
1543     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1544         return sub(a, b, "SafeMath: subtraction overflow");
1545     }
1546 
1547     /**
1548      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1549      * overflow (when the result is negative).
1550      *
1551      * Counterpart to Solidity's `-` operator.
1552      *
1553      * Requirements:
1554      *
1555      * - Subtraction cannot overflow.
1556      */
1557     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1558         require(b <= a, errorMessage);
1559         uint256 c = a - b;
1560 
1561         return c;
1562     }
1563 
1564     /**
1565      * @dev Returns the multiplication of two unsigned integers, reverting on
1566      * overflow.
1567      *
1568      * Counterpart to Solidity's `*` operator.
1569      *
1570      * Requirements:
1571      *
1572      * - Multiplication cannot overflow.
1573      */
1574     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1575         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1576         // benefit is lost if 'b' is also tested.
1577         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1578         if (a == 0) {
1579             return 0;
1580         }
1581 
1582         uint256 c = a * b;
1583         require(c / a == b, "SafeMath: multiplication overflow");
1584 
1585         return c;
1586     }
1587 
1588     /**
1589      * @dev Returns the integer division of two unsigned integers. Reverts on
1590      * division by zero. The result is rounded towards zero.
1591      *
1592      * Counterpart to Solidity's `/` operator. Note: this function uses a
1593      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1594      * uses an invalid opcode to revert (consuming all remaining gas).
1595      *
1596      * Requirements:
1597      *
1598      * - The divisor cannot be zero.
1599      */
1600     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1601         return div(a, b, "SafeMath: division by zero");
1602     }
1603 
1604     /**
1605      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1606      * division by zero. The result is rounded towards zero.
1607      *
1608      * Counterpart to Solidity's `/` operator. Note: this function uses a
1609      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1610      * uses an invalid opcode to revert (consuming all remaining gas).
1611      *
1612      * Requirements:
1613      *
1614      * - The divisor cannot be zero.
1615      */
1616     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1617         require(b > 0, errorMessage);
1618         uint256 c = a / b;
1619         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1620 
1621         return c;
1622     }
1623 
1624     /**
1625      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1626      * Reverts when dividing by zero.
1627      *
1628      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1629      * opcode (which leaves remaining gas untouched) while Solidity uses an
1630      * invalid opcode to revert (consuming all remaining gas).
1631      *
1632      * Requirements:
1633      *
1634      * - The divisor cannot be zero.
1635      */
1636     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1637         return mod(a, b, "SafeMath: modulo by zero");
1638     }
1639 
1640     /**
1641      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1642      * Reverts with custom message when dividing by zero.
1643      *
1644      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1645      * opcode (which leaves remaining gas untouched) while Solidity uses an
1646      * invalid opcode to revert (consuming all remaining gas).
1647      *
1648      * Requirements:
1649      *
1650      * - The divisor cannot be zero.
1651      */
1652     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1653         require(b != 0, errorMessage);
1654         return a % b;
1655     }
1656 }
1657 
1658 // File: @openzeppelin/contracts/math/Math.sol
1659 
1660 
1661 pragma solidity ^0.6.0;
1662 
1663 /**
1664  * @dev Standard math utilities missing in the Solidity language.
1665  */
1666 library Math {
1667     /**
1668      * @dev Returns the largest of two numbers.
1669      */
1670     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1671         return a >= b ? a : b;
1672     }
1673 
1674     /**
1675      * @dev Returns the smallest of two numbers.
1676      */
1677     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1678         return a < b ? a : b;
1679     }
1680 
1681     /**
1682      * @dev Returns the average of two numbers. The result is rounded towards
1683      * zero.
1684      */
1685     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1686         // (a + b) / 2 can overflow, so we distribute
1687         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1688     }
1689 }
1690 
1691 
1692 
1693 // File: localhost/contracts/SpaceMinePresale.sol
1694 
1695 // SPDX-License-Identifier: MIT
1696 
1697 pragma solidity 0.6.12;
1698 
1699 
1700 
1701 
1702 
1703 
1704 
1705 
1706 
1707 
1708 
1709 
1710 
1711 contract SpaceMinePresale is Ownable {
1712     using SafeMath for uint256;
1713     using SafeERC20 for IERC20;
1714 
1715     IUniswapV2Router02 private uniswapRouterV2;
1716     IUniswapV2Factory private uniswapFactory;
1717     IUniswapV2Pair private pair;
1718     POLContract private pol;
1719     address public tokenUniswapPair;
1720 
1721     SpaceMineToken public mine;
1722 
1723     mapping (address => bool) public whitelist;
1724     mapping (address => uint) public ethSupply;
1725     address payable devAddress;
1726     uint public minePrice = 10;
1727     uint public buyLimit = 4 * 1e18;
1728     bool public presaleStart = false;
1729     bool public onlyWhitelist = true;
1730     uint public presaleLastSupply = 8000 * 1e18;
1731     uint public initialLiquidityMax = 1600 * 1e18;
1732     uint256 public contractStartTimestamp;
1733     uint256 public constant LOCK_PERIOD = 26 weeks;
1734     bool public LPGenerationCompleted;
1735     uint256 public totalLPTokensMinted;
1736     uint256 public totalPresaleContributed;
1737 
1738     address payable constant UNICRYPT_DEPLOYER = 0x60e2E1b2a317EdfC870b6Fc6886F69083FB2099a;
1739     address constant UNISWAP_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
1740     address constant UNISWAP_ROUTER_V2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1741     address constant UNICRYPT_POL = 0x17e00383A843A9922bCA3B280C0ADE9f8BA48449;
1742 
1743     event BuyMineSuccess(address account, uint ethAmount, uint mineAmount);
1744 
1745     constructor(
1746         SpaceMineToken _mine
1747         
1748     ) public {
1749         mine = _mine;
1750         initWhitelist();
1751         pairSetup();
1752     }
1753 
1754     function pairSetup() internal {
1755         uniswapRouterV2 = IUniswapV2Router02(UNISWAP_ROUTER_V2); // For testing
1756         uniswapFactory = IUniswapV2Factory(UNISWAP_FACTORY); // For testing
1757 
1758         pol = POLContract(payable(UNICRYPT_POL)); // For testing;
1759         createUniswapPair();
1760     }
1761 
1762     function createUniswapPair() internal {
1763         require(tokenUniswapPair == address(0), "Token: pool already created");
1764         tokenUniswapPair = uniswapFactory.createPair(
1765             address(uniswapRouterV2.WETH()),
1766             address(mine)
1767         );
1768         pair = IUniswapV2Pair(tokenUniswapPair);
1769     }
1770 
1771     function addToWhitelist(address account) public onlyOwner {
1772         require(whitelist[account] == false, "This account is already in whitelist.");
1773         whitelist[account] = true;
1774     }
1775 
1776     function removeFromWhitelist(address account) public onlyOwner {
1777         require(whitelist[account], "This account is not in whitelist.");
1778         whitelist[account] = false;
1779     }
1780 
1781     function startPresale() public onlyOwner {
1782         presaleStart = true;
1783         contractStartTimestamp = block.timestamp;
1784         mine.mint(address(this), initialLiquidityMax);
1785     }
1786 
1787     function stopPresale() public onlyOwner {
1788         presaleStart = false;
1789     }
1790 
1791     function setDevAddress(address payable account) public onlyOwner {
1792         devAddress = account;
1793     }
1794 
1795     function setMinePrice(uint newPrice) public onlyOwner {
1796         minePrice = newPrice;
1797     }
1798 
1799     function setBuyLimit(uint newLimit) public onlyOwner {
1800         buyLimit = newLimit;
1801     }
1802 
1803     function changeToNotOnlyWhitelist() public onlyOwner {
1804         onlyWhitelist = false;
1805     }
1806 
1807     function checkpresaleLastSupply() public view returns(uint){
1808         return presaleLastSupply;
1809     }
1810 
1811     function burnLeftoverMine() public onlyOwner {
1812         // Only available 24 hours after presale ends (48 hours after presale starts)
1813         require(contractStartTimestamp.add(2 days) < block.timestamp, "Grace period is not over yet");
1814         mine.burn(mine.balanceOf(address(this)));
1815     }
1816 
1817     modifier needHaveLastSupply() {
1818         require(presaleLastSupply >= 0, "Oh you are too late, all mine are gone");
1819         _;
1820     }
1821 
1822     modifier presaleHasStarted() {
1823         require(presaleStart, "Presale has not been started, buckle up!");
1824         _;
1825     }
1826 
1827     receive() payable external presaleHasStarted needHaveLastSupply {
1828         if (onlyWhitelist) {
1829             require(whitelist[msg.sender], "Currently only people who are in whitelist can participate");
1830         }
1831         uint ethTotalAmount = ethSupply[msg.sender].add(msg.value);
1832         require(ethTotalAmount <= buyLimit, "Everyone should buy lesser than 4 eth.");
1833         uint mineAmount = msg.value.mul(minePrice);
1834         require(mineAmount <= presaleLastSupply, "sorry, insufficient presale supply");
1835         totalPresaleContributed.add(msg.value);
1836         presaleLastSupply = presaleLastSupply.sub(mineAmount);
1837         devAddress.transfer(msg.value.div(2));
1838         mine.mint(msg.sender, mineAmount);
1839         ethSupply[msg.sender] = ethTotalAmount;
1840         emit BuyMineSuccess(msg.sender, msg.value, mineAmount);
1841     }
1842 
1843     function liquidityGeneration() public {
1844         require(LPGenerationCompleted == false, "Liquidity generation already finished");
1845         uint256 initialETHLiquidity = address(this).balance;
1846 
1847         //Wrap eth
1848         address WETH = uniswapRouterV2.WETH();
1849         IWETH(WETH).deposit{value : initialETHLiquidity}();
1850         require(address(this).balance == 0 , "Transfer Failed");
1851         IWETH(WETH).transfer(address(pair),initialETHLiquidity);
1852 
1853         uint256 initialLiquidity = initialETHLiquidity.mul(4);
1854         require(initialLiquidity <= initialLiquidityMax, "Error amount");
1855 
1856         mine.transfer(address(pair), initialLiquidity);
1857         pair.mint(address(this));
1858         totalLPTokensMinted = pair.balanceOf(address(this));
1859         require(totalLPTokensMinted != 0 , "LP creation failed");
1860         LPGenerationCompleted = true;
1861 
1862         uint256 unlockTime = block.timestamp + LOCK_PERIOD;
1863 
1864         IERC20(address(pair)).approve(address(pol), totalLPTokensMinted);
1865         pol.depositToken(address(pair), totalLPTokensMinted, unlockTime);
1866         require(pair.balanceOf(address(pol)) != 0, "Auto lock failed");
1867     }
1868     
1869     function withdrawLiquidity() public onlyOwner {
1870         uint256 withdrawable = pol.getWithdrawableBalance(address(pair), address(this));
1871         pol.withdrawToken(address(pair), withdrawable);
1872         pair.transfer(msg.sender, pair.balanceOf(address(this)));
1873     }
1874 
1875     // Emergency drain in case of a bug in liquidity generation
1876     // Adds all funds to owner to refund people
1877     // Only available 24 hours after presale ends (48 hours after presale starts)
1878     function emergencyDrain() public onlyOwner {
1879         require(contractStartTimestamp.add(2 days) < block.timestamp, "Grace period is not over yet");
1880         uint256 initialLiquidity = address(this).balance.mul(4);
1881         mine.transfer(UNICRYPT_DEPLOYER, initialLiquidity);
1882         (bool success, ) = UNICRYPT_DEPLOYER.call{value: address(this).balance}("");
1883         require(success, "Transfer failed.");
1884     }
1885 
1886     function initWhitelist() internal {
1887         //add the original whitelist
1888         whitelist[0x04b936745C02E8Cb75cC68b93B4fb99b38939d5D] = true;
1889         whitelist[0xcC4fB675c46F3715c52307c4d2f8640c4EF7bb31] = true;
1890         whitelist[0xA734871BC0f9d069936db4fA44AeA6d4325F41e5] = true;
1891         whitelist[0x9A8ea427c5CF4490c07428b853A5577c9B7a2d14] = true;
1892         whitelist[0x9DC6A59a9Eee821cE178f0aaBE1880874d48eca1] = true;
1893         whitelist[0x7149De569464C1c90f9d70cAf03B25dc2766E936] = true;
1894         whitelist[0xf21cE4A93534E725215bfEc2A5e1aDD496E80469] = true;
1895         whitelist[0xB7A641f8aebf507E1Bbc85F8feeEa56F38DbeB24] = true;
1896         whitelist[0x9a0F4440086141b9a405675fC8f839144Dd63B8F] = true;
1897         whitelist[0xbE18f84532d8f7fb6d7919401C0096f3e257DB8b] = true;
1898         whitelist[0xB4E383BEc5c5312F2E823d0A9C9eb17882f2aaF9] = true;
1899         whitelist[0x5b85988F0032ee818f911ec969Dd9c649CAa0a14] = true;
1900         whitelist[0xA43c750d5dE3Bd88EE4F35DEF72Cf76afEbeC274] = true;
1901         whitelist[0xfc35497204dA2d9539b23FE0D71022e2523d99b1] = true;
1902         whitelist[0x870ABcf52d52ECb1Ed00270433138262300BCC6d] = true;
1903         whitelist[0x5D39036947e83862cE5f3DB351cC64E3D4592cD5] = true;
1904         whitelist[0x63c9a867D704dF159bbBB88EeEe1609196b1995E] = true;
1905         whitelist[0xC0375Db78aB51B82E9bE2E139348491259280343] = true;
1906         whitelist[0x13EAEced8317889e7A3452A3ecb474b7801F20d8] = true;
1907         whitelist[0x81409E4C1a55C034EC86F64A75d18D911A8B0071] = true;
1908         whitelist[0x6CF51FDeF74d02296017A1129086Ee9C3477DC01] = true;
1909         whitelist[0xD87dB443b01Cb8e453c11f9a26F48CD51c19842a] = true;
1910         whitelist[0x10F555120485f0E352c0F11A4aC6f4A420300092] = true;
1911         whitelist[0xBf26925f736E90E1715ce4E04cD9c289dD1bc002] = true;
1912         whitelist[0xd39E6aD9d32D6c71326b800EA883c8Edc0b7B5e4] = true;
1913         whitelist[0xF03336c8c2B040cF026af8774B67127dFF5413A5] = true;
1914         whitelist[0x6CAd957812F1bb9aB9364F20cfA15482BcE9DE77] = true;
1915         whitelist[0x64aaaBE41689B60ed969386b2D154e3887f628F6] = true;
1916         whitelist[0x635954403448b9f55655FD5dbcC9675e8a4b8109] = true;
1917         whitelist[0xfCE9f37F4F554419E9c370c9e6c67Bd0020BF577] = true;
1918         whitelist[0x26FA038d801970EE46d53b0056658B4e1a4458Db] = true;
1919         whitelist[0x8e9817f8f20F4B6156B4548144a2affde1890f08] = true;
1920         whitelist[0xD6F50F21038c5479b9cc663794E7b5Fc876b3C26] = true;
1921         whitelist[0x5984bb82F11171cb1DC2287E2A6935c44D491538] = true;
1922         whitelist[0x0d79cce030AE9654aA9488524F407ce464297722] = true;
1923         whitelist[0x0A4D7Bf0abc967d6204b83173A98B14603057C08] = true;
1924         whitelist[0x908A52B2a18C7Adf135A861DE80b4952fF03BEEa] = true;
1925         whitelist[0xB8dCE88744A07baf3904BAc6D9cEE3D1927BBb5e] = true;
1926         whitelist[0x156D2893955A52fF0796d2D88BF6Ab2e7663e3FC] = true;
1927         whitelist[0x8b584Cf38bFE7d50809bbC2A622C7Bd118a82577] = true;
1928         whitelist[0x5f4B42AE45C1681f5b24eB6aFBd1F0f95d7c8E25] = true;
1929         whitelist[0xA6a576527217e0194c8CDb5f15F21209FeAB5FB7] = true;
1930         whitelist[0x40a4fce89b26E924A3b5f13A91E78A5dc4944a45] = true;
1931         whitelist[0x7f62Fbb8a9E707e44A198584ae2e8Db67cEfC30a] = true;
1932         whitelist[0xC82b6f107fA7Baeb0809B2645cE8AAC4328Cb75A] = true;
1933         whitelist[0xeFAE1190444Aae8CFF4915eb7D5054BFcDfEDcE6] = true;
1934         whitelist[0x963D961b4F18dB19d285F44e6De8D77BD457D7D6] = true;
1935         whitelist[0x538fAaE7e0fD3aDC7C400b0A1CCA242095ebB554] = true;
1936         whitelist[0x3049c80BDD527128eb4E7886AB1Db1E8042a8EB7] = true;
1937         whitelist[0x08BeEabCa238deb5ee1016618BF80c40Ad221C98] = true;
1938         whitelist[0xcA7F8f6A21C6e0F3b0177207407Fc935429BdD27] = true;
1939         whitelist[0xD45FcAca001032bcB6DC509b4E0dc97A3351Ca88] = true;
1940         whitelist[0xA0dc2b64eb9c93334225032383344a9a62DA9Ef0] = true;
1941         whitelist[0x9e353fbdC3eC7290290BdA31a8001cb609858adf] = true;
1942         whitelist[0x465FE2dbE1F73FA4dB8b2a3b8A4aafcACb2Bf1AA] = true;
1943         whitelist[0x8468c6Efa8ca7ffccB2C31D112e5e9331A469867] = true;
1944         whitelist[0x04A0f10c0Dcfa5a4C060E5421f385c2A0E541a94] = true;
1945         whitelist[0x61412bB7b13c24C3A913639a22BE592D65e797b6] = true;
1946         whitelist[0x12429F85Fa35183Bc7cA6750303ee3f6AFE31d13] = true;
1947         whitelist[0xE349a754b82eFa0AB90C69BBc2Bcc7Cf17CC8650] = true;
1948         whitelist[0x6f158C7DdAeb8594d36C8869bee1B3080a6e5317] = true;
1949         whitelist[0x1e9b0e7D28bC135584EA1717065a6CcE3298a80D] = true;
1950         whitelist[0x98C744edfd71F95a63423bEe72eAE5cB78415067] = true;
1951         whitelist[0x921AC49968F27B7922B5aB1757ef30508e787580] = true;
1952         whitelist[0x294e20DA26e64730FadA867213d011B622aD0bb8] = true;
1953         whitelist[0xd2a4A34eF72F766f269409702A811eec8D55F2dE] = true;
1954         whitelist[0x7ae9185fc5fC77fdf2CaFCb0018a54C34E733fe7] = true;
1955         whitelist[0x44Acd0Ff3bE9Fdfb932453C82B5dF5739D28b276] = true;
1956         whitelist[0x0Ed67742bb18250F0e0CeD12B980668A32437915] = true;
1957         whitelist[0xaa126ef289c099D46a5a9484C95707E681D278DD] = true;
1958         whitelist[0xdd8D647b0133dEdC7907bbd2E303C029E2009d2a] = true;
1959         whitelist[0xd81a19b8b3BE4912018b32AD634C0CA873f45189] = true;
1960         whitelist[0x13adb88D0CE40651625b43B597019f9CE3D60bCC] = true;
1961         whitelist[0x9FBEacDf803004e8BEF3e5013faF0bF0090e6588] = true;
1962         whitelist[0xE792be33d36df027c6a5ad9bFe9F74bD40AD0F58] = true;
1963         whitelist[0x064a5d4359FFF916e59E0d68f6094729c4052B8b] = true;
1964         whitelist[0xBc159B71c296c21a1895a8dDf0aa45969c5F17c2] = true;
1965         whitelist[0xeC31a56b8323dd7289F5f69F99F8F8558faDBBc9] = true;
1966         whitelist[0xF9687743fb84966f63afB100B0F6be8E4aEc374e] = true;
1967         whitelist[0x21A56D488521C02644698Bf30dF4D7aC21B03ED4] = true;
1968         whitelist[0x83B045a90C8f67B7734D3b0417ed20eD5933E67D] = true;
1969         whitelist[0x89A5d9e66AA6439f9daBa379078193AbA58d949a] = true;
1970         whitelist[0xf062B3ab33A518Ef57e0039379A128CaF2e01AD8] = true;
1971         whitelist[0x71fE41C174277D4f6D52BfB10B7CE8cB55Bad9Fe] = true;
1972         whitelist[0x0388134B224Fc69B19f26c65581356B6eEA9aF81] = true;
1973         whitelist[0xf403ad7F9F36D0201d5AFe7331b40835E3CEd922] = true;
1974         whitelist[0x166B6770f7513ee4BE7a88f7C8d250E5E8BCbfAF] = true;
1975         whitelist[0x97ca6aE239E5476b546Fc873002BF117Cc52F6df] = true;
1976         whitelist[0x76AaD6e2165a469feA3A02F545D9f6e5E6AAd2d5] = true;
1977         whitelist[0xf4c7E60fC24Bd932b275cAa71C4Cf6642e49F5BD] = true;
1978         whitelist[0xe8C0C83C181AACdab4f48624B5574CC88aD8E840] = true;
1979         whitelist[0x0910AEd2f4a4b3E7F399F3d5Cf6EdacA132b83D0] = true;
1980         whitelist[0xD631A7500c39368F021109F497c4eD85B8a256EA] = true;
1981         whitelist[0x127563d0B37872e4956BF9B033e3cc03c6bF7E45] = true;
1982         whitelist[0x88d6F54C227A0483272f03435af70b4A864A0333] = true;
1983         whitelist[0xCdD607DECbe9b714F6E032bA478830a521753233] = true;
1984         whitelist[0x92353D9186a1d02bE280F55C8A563762A9Edc100] = true;
1985         whitelist[0x2B5b1Fffe86302F73e478a0E09d8Bf92eC75FFba] = true;
1986         whitelist[0x6f7d991841CeFF8cEdFF91CfFc913a2CB4560d71] = true;
1987         whitelist[0x585020d9C6b56874B78979F29d84E082D34f0B2a] = true;
1988         whitelist[0x93f5af632Ce523286e033f0510E9b3C9710F4489] = true;
1989         whitelist[0x3DdaEf422793e387bdD2aD26F5d511A949708B1A] = true;
1990         whitelist[0x07D7E180C0Bd4ee3d5e25006dB854D81f76Fe1Fb] = true;
1991         whitelist[0x129e81DAD8cFAEecEE130309b39B5F22215062ED] = true;
1992         whitelist[0xdB32722A9dc5da52273F4fB1F25a8c75176c9Db2] = true;
1993         whitelist[0x688c3689C5a3Fa844C1D186db2393d4590044178] = true;
1994         whitelist[0x51D2C8b408B264dA569f75eCE31172f50b27E838] = true;
1995         whitelist[0xcCEE65c43C62338f13A638bB98f18E36801B7450] = true;
1996         whitelist[0xbB02B1B914590f69e9f1942d205f77276b4B3CA9] = true;
1997         whitelist[0xba30963F47A2d33476E922Faa55bEc570C433dD0] = true;
1998         whitelist[0xaca3365a1A6DBA0839b3B56219Cf250eBB9F32f1] = true;
1999         whitelist[0x70e703ba15c43Aa6D043b8c29e60927E3b01df73] = true;
2000         whitelist[0x374D37AA9d27C8a03F0d34Db0a9D441aAc99F186] = true;
2001         whitelist[0x70b53C16852a2e341a31F0e884983DE58B937301] = true;
2002         whitelist[0xAbC3EF008F7693C5A87ba317AA370c102C1DD690] = true;
2003         whitelist[0xCc22DDc2e3B896Dd2b22A18590E73a2194B22c9C] = true;
2004         whitelist[0xB16E1101CbB48F631AB4dBd54c801Ecef9B47D2b] = true;
2005         whitelist[0x81D7D1dc2B8de78E68a082C858DAcB5ed3631133] = true;
2006         whitelist[0x7Bf7Dedb68CAC2cFD0d99DFdDb703c4CE9640941] = true;
2007         whitelist[0xA87fB81CDC6dfa965Bf8b7F43219BCc326A74Cfb] = true;
2008         whitelist[0xCB0B5c48E08dC20A7F535E106703f3172fBE3012] = true;
2009         whitelist[0xe15863985BE0c9Fb9D590E2d1D6486a551d63e06] = true;
2010         whitelist[0x506adE0A94949dB63047346D3796A01C09384198] = true;
2011         whitelist[0x61069795367ECC82167b8349BBb562449e452aac] = true;
2012         whitelist[0x6d55db28aAaD7Ad31b33BF48a0461e202BF18622] = true;
2013         whitelist[0x4d28975B4Ed2a1a9A00C657f28344DCe37EE0Ac6] = true;
2014         whitelist[0xF6196741d0896dc362788C1FDbDF91b544Ab7C1C] = true;
2015         whitelist[0x52d2D6E5A8b0a7594250D720b66a791fc8e71538] = true;
2016         whitelist[0x24ED3B0C0a1cb8fEce7E3A25A34e86613234dD04] = true;
2017         whitelist[0x3Bd8a3C2d90e1709259Cd271A8e8d2C5caDeBE82] = true;
2018         whitelist[0x46B8FfC41F26cd896E033942cAF999b78d10c277] = true;
2019         whitelist[0x25D1cbf24e549CcaD81c2A5cab9e62c6be208920] = true;
2020         whitelist[0xE139962e5d7B07A9378F159A4A1b7CABe9Df1d6E] = true;
2021         whitelist[0x03b76647464CF57255f20289D2501417A5eC457E] = true;
2022         whitelist[0x338bfa2c23Cc5Daf45208A2f23431d91e668515a] = true;
2023         whitelist[0x67C0fc4B0490ab7E76C08C2bbD30fAc0059bbc7A] = true;
2024         whitelist[0xE37689CFf507cB199f55eaA23338181C9a63a748] = true;
2025         whitelist[0xA37F6C27c603619B729adCe9849f2C4FcF79AD83] = true;
2026         whitelist[0xFD0d152BF613956B6929A7156fE75eEE2A20C3B6] = true;
2027         whitelist[0x25DbEB6565778B8570f8936165370348f16E7E88] = true;
2028         whitelist[0x467e20bD74Bbba59dc6C88B3A975fBC381FA2441] = true;
2029         whitelist[0xff4d2D37a08f1B0d40dda7eAd1D88Aa5ceEF7C66] = true;
2030         whitelist[0x4010a534B8Ab01945DEc322F4eecd6A4B4785277] = true;
2031         whitelist[0xD9D4e0F4C81d13EDF3eE8ceC6Ff026a06D418301] = true;
2032         whitelist[0xcbBC5D06BE48B9B1D90A8E787B4d42bc4A3B74a8] = true;
2033         whitelist[0x908A52B2a18C7Adf135A861DE80b4952fF03BEEa] = true;
2034         whitelist[0x0B431F91c54C303AE29E4023A70da6caDEB0D387] = true;
2035         whitelist[0xC2ea0584A6B5dF8Ad2C488A208B2f1ac25f4019f] = true;
2036         whitelist[0xf2306b7547b4E7C3d2B4F0864900414A91d5571f] = true;
2037         whitelist[0x387EAf27c966bB6dEE6A0E8bA45ba0854d01Ee32] = true;
2038         whitelist[0x291F8D2F3D94ef8731807883B452A92627714d03] = true;
2039         whitelist[0x74f90fC63084F5AC7546d105397034ac8A4a51F7] = true;
2040         whitelist[0x6B511F9919E0239d345E2F0f2688E11d168829D1] = true;
2041         whitelist[0x700bdccb187238bC4263C233bCBE48c3BcF7d32d] = true;
2042         whitelist[0xb06336f40e1dE49c9c2f35C5742d1923cB4A9E7D] = true;
2043         whitelist[0xc6fE56E09F826245304BA8210BAEcAC306e67357] = true;
2044         whitelist[0xA538311df7DC52bBE861F6e3EfDD749730503Cae] = true;
2045         whitelist[0x42147EE918238fdfF257a15fA758944D6b870B6A] = true;
2046         whitelist[0x5b049c3Bef543a181A720DcC6fEbc9afdab5D377] = true;
2047         whitelist[0xBacEcAc3EA45372e6a83C2B97032211e4758368a] = true;
2048         whitelist[0x9Fe686D6fAcBC5AE4433308B26e7c810ac43F3D4] = true;
2049         whitelist[0x85b25DF7991AfF597DCf936DdC66A41100A1DF38] = true;
2050         whitelist[0x51Bc4B6db5D958d066d3c6C11C4396e881961bca] = true;
2051         whitelist[0x5CbAfbE163BD766B5EEd26D81ECea0f41f232847] = true;
2052         whitelist[0x8e76Bcf139d65f9c160E8Ef0ED321d7049A3ee83] = true;
2053         whitelist[0xB80216042142Ef55F6d61FD5ae0F23B25D150178] = true;
2054         whitelist[0x8760E565273B47195F76A22455Ce0B68A11aF5B5] = true;
2055         whitelist[0x164D39D1DB5Ec3b4472a18F0E588F0C1F0D98d9E] = true;
2056         whitelist[0x404C4f2C30B70135964397eA658C26b6997bdeD5] = true;
2057         whitelist[0xE2BF97AdEcabf5bbd9C184b287Cd0a0490c259Be] = true;
2058         whitelist[0x7dD1a007Ff481FEa56F9F5B5832ec9f40c01172e] = true;
2059         whitelist[0xca1B8F95046506fdF2560880b2beB2950CC9aED6] = true;
2060         whitelist[0x75A4c4730e354e1097bf2f8D447Ae7751c20E480] = true;
2061         whitelist[0x3B1d9AF9fBe4DE15E4C320304204c623E6726358] = true;
2062         whitelist[0xbcf7564427Bfa1C2f305eD2352E3987f19b46608] = true;
2063         whitelist[0xebeA475d9453122fA1E87E79883893A20A12f3f9] = true;
2064         whitelist[0x2E2Aa9909361F5e1c9f2f8a85AFF7ee8194eCCe9] = true;
2065         whitelist[0x399b282c17F8ed9F542C2376917947d6B79E2Cc6] = true;
2066         whitelist[0xd63a8b9699fbe0b0B70C443CDA57CD667A77D1b2] = true;
2067         whitelist[0x76AaD6e2165a469feA3A02F545D9f6e5E6AAd2d5] = true;
2068         whitelist[0x8b09C4Fd7f3beAFc91bbcA198313CFD0D1a5ecbB] = true;
2069         whitelist[0xDb704Df06A7fA515fe77B30595451346198bC44C] = true;
2070         whitelist[0x576fe99A39fEC41fC644f193C8F539FaEb038241] = true;
2071         whitelist[0x0869fD08Ff42889e11E09A0c2B46Ce3d163a25D5] = true;
2072         whitelist[0xcD5d0593c17c40BD2BB857B2dc9F6A3771862D8d] = true;
2073         whitelist[0x7C1ec41944A9591f48e44A9d4e8eDC43B7D58948] = true;
2074         whitelist[0x04b936745C02E8Cb75cC68b93B4fb99b38939d5D] = true;
2075         whitelist[0x4670D6b9AEf53615382934A481B133B70a3B631a] = true;
2076         whitelist[0xD87dB443b01Cb8e453c11f9a26F48CD51c19842a] = true;
2077         whitelist[0xe1b6514df22AfCd09DE787FdA75d0834bF9c8DC1] = true;
2078         whitelist[0xA3fE401D499f306C49b54ee89b4160f4832Cbe6e] = true;
2079         whitelist[0x98b7C27df27C857536C61aDEa0D3C9C7E327432d] = true;
2080         whitelist[0xAFdfF5466Db276b274BAE48336D1B6f70F644065] = true;
2081         whitelist[0x80b3bdAD4bA4D26aAe097f742A97cd016aB46F86] = true;
2082         whitelist[0x72a5Ba942a401C4BD08a32963B75f971292213a8] = true;
2083         whitelist[0xe2438Db969db43314040e51F95D425c1fe1cc433] = true;
2084         whitelist[0x7f59fbfe6C2cBA95173d69B4B0B00E09c76501FC] = true;
2085         whitelist[0xd29979e7a3560C450Dd94333215D42898e1BbA72] = true;
2086         whitelist[0xdFA2ba1473d66e06b57278A058e411364caB1449] = true;
2087         whitelist[0xF4F98B4a1B0a0F46bA8856939bAC69A40b1F5f56] = true;
2088     }
2089     
2090     function testMint() public onlyOwner {
2091         mine.mint(address(this), 1);
2092     }
2093     
2094     function isInWhitelist(address account) public view returns(bool) {
2095         return whitelist[account];
2096     }
2097 
2098 }