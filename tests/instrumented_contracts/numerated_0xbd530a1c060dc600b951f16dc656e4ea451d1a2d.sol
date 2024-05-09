1 // This contract is provided "as-is" under the principle of code-is-law. The contract is in Alpha.
2 // Any actions taken by this contract are considered the expected outcomes from a legal perspective.
3 // The deployer and maintainers have no liability in the result of any error.
4 // By interacting with this contract in any way you agree to these terms.
5 // 本合同根据 "法典即法律 "原则 "按现状 "提供。本合同为阿尔法版本。
6 // 本合同所采取的任何行动从法律的角度来看都是预期的结果。
7 // 部署者和维护者不对任何错误的结果负责。
8 // 以任何方式与本合同进行交互，即表示您同意这些条款。
9 // Настоящий договор составлен "как есть" в соответствии с принципом кодового права. Контракт заключен в Альфе.
10 // Любые действия, предпринимаемые по настоящему договору, рассматриваются с юридической точки зрения как ожидаемые результаты.
11 // Развертывающее лицо и сопровождающие лица не несут никакой ответственности в результате любой ошибки.
12 // Взаимодействуя с настоящим контрактом любым способом, вы соглашаетесь с настоящими условиями.
13 
14 
15 pragma solidity ^0.6.0;
16 
17 /*
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with GSN meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address payable) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes memory) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 /**
39  * @dev Implementation of the {IERC20} interface.a
40  *
41  * This implementation is agnostic to the way tokens are created. This means
42  * that a supply mechanism has to be added in a derived contract using {_mint}.
43  * For a generic mechanism see {ERC20PresetMinterPauser}.
44  *
45  * TIP: For a detailed writeup see our guide
46  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
47  * to implement supply mechanisms].
48  *
49  * We have followed general OpenZeppelin guidelines: functions revert instead
50  * of returning `false` on failure. This behavior is nonetheless conventional
51  * and does not conflict with the expectations of ERC20 applications.
52  *
53  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
54  * This allows applications to reconstruct the allowance for all accounts just
55  * by listening to said events. Other implementations of the EIP may not emit
56  * these events, as it isn't required by the specification.
57  *
58  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
59  * functions have been added to mitigate the well-known issues around setting
60  * allowances. See {IERC20-approve}.
61  */
62  
63  
64  // File: Ownable6.sol
65 
66 // SPDX-License-Identifier: MIT
67 
68 pragma solidity ^0.6.0;
69 
70 /**
71  * @dev Contract module which provides a basic access control mechanism, where
72  * there is an account (an owner) that can be granted exclusive access to
73  * specific functions.
74  *
75  * By default, the owner account will be the one that deploys the contract. This
76  * can later be changed with {transferOwnership}.
77  *
78  * This module is used through inheritance. It will make available the modifier
79  * `onlyOwner`, which can be applied to your functions to restrict their use to
80  * the owner.
81  */
82 contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor () internal {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     /**
97      * @dev Returns the address of the current owner.
98      */
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(_owner == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     /**
112      * @dev Leaves the contract without owner. It will not be possible to call
113      * `onlyOwner` functions anymore. Can only be called by the current owner.
114      *
115      * NOTE: Renouncing ownership will leave the contract without an owner,
116      * thereby removing any functionality that is only available to the owner.
117      */
118     function renounceOwnership() public virtual onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         emit OwnershipTransferred(_owner, newOwner);
130         _owner = newOwner;
131     }
132 }
133 
134 contract Authorizable is Ownable {
135 
136     mapping(address => bool) public authorized;
137 
138     modifier onlyAuthorized() {
139         require(authorized[msg.sender] || owner() == msg.sender);
140         _;
141     }
142 
143     function addAuthorized(address _toAdd) onlyOwner public {
144         authorized[_toAdd] = true;
145     }
146 
147     function removeAuthorized(address _toRemove) onlyOwner public {
148         require(_toRemove != msg.sender);
149         authorized[_toRemove] = false;
150     }
151 
152 }
153 
154  // File: IERC206.sol
155 
156 pragma solidity ^0.6.0;
157 
158 /**
159  * @dev Interface of the ERC20 standard as defined in the EIP.
160  */
161 interface IERC20 {
162     /**
163      * @dev Returns the amount of tokens in existence.
164      */
165     function totalSupply() external view returns (uint256);
166 
167     /**
168      * @dev Returns the amount of tokens owned by `account`.
169      */
170     function balanceOf(address account) external view returns (uint256);
171 
172     /**
173      * @dev Moves `amount` tokens from the caller's account to `recipient`.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transfer(address recipient, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Returns the remaining number of tokens that `spender` will be
183      * allowed to spend on behalf of `owner` through {transferFrom}. This is
184      * zero by default.
185      *
186      * This value changes when {approve} or {transferFrom} are called.
187      */
188     function allowance(address owner, address spender) external view returns (uint256);
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
196      * that someone may use both the old and the new allowance by unfortunate
197      * transaction ordering. One possible solution to mitigate this race
198      * condition is to first reduce the spender's allowance to 0 and set the
199      * desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Moves `amount` tokens from `sender` to `recipient` using the
208      * allowance mechanism. `amount` is then deducted from the caller's
209      * allowance.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Emitted when `value` tokens are moved from one account (`from`) to
219      * another (`to`).
220      *
221      * Note that `value` may be zero.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 value);
224 
225     /**
226      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
227      * a call to {approve}. `value` is the new allowance.
228      */
229     event Approval(address indexed owner, address indexed spender, uint256 value);
230 }
231 
232  
233  
234 contract ERC20 is Context, IERC20 {
235     using SafeMath for uint256;
236 
237     mapping (address => uint256) private _balances;
238 
239     mapping (address => mapping (address => uint256)) private _allowances;
240 
241     uint256 private _totalSupply;
242 
243     string private _name;
244     string private _symbol;
245     uint8 private _decimals;
246 
247     /**
248      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
249      * a default value of 18.
250      *
251      * To select a different value for {decimals}, use {_setupDecimals}.
252      *
253      * All three of these values are immutable: they can only be set once during
254      * construction.
255      */
256     constructor (string memory name, string memory symbol) public {
257         _name = name;
258         _symbol = symbol;
259         _decimals = 18;
260     }
261 
262     /**
263      * @dev Returns the name of the token.
264      */
265     function name() public view returns (string memory) {
266         return _name;
267     }
268 
269     /**
270      * @dev Returns the symbol of the token, usually a shorter version of the
271      * name.
272      */
273     function symbol() public view returns (string memory) {
274         return _symbol;
275     }
276 
277     /**
278      * @dev Returns the number of decimals used to get its user representation.
279      * For example, if `decimals` equals `2`, a balance of `505` tokens should
280      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
281      *
282      * Tokens usually opt for a value of 18, imitating the relationship between
283      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
284      * called.
285      *
286      * NOTE: This information is only used for _display_ purposes: it in
287      * no way affects any of the arithmetic of the contract, including
288      * {IERC20-balanceOf} and {IERC20-transfer}.
289      */
290     function decimals() public view returns (uint8) {
291         return _decimals;
292     }
293 
294     /**
295      * @dev See {IERC20-totalSupply}.
296      */
297     function totalSupply() public view override returns (uint256) {
298         return _totalSupply;
299     }
300 
301     /**
302      * @dev See {IERC20-balanceOf}.
303      */
304     function balanceOf(address account) public view override returns (uint256) {
305         return _balances[account];
306     }
307 
308     /**
309      * @dev See {IERC20-transfer}.
310      *
311      * Requirements:
312      *
313      * - `recipient` cannot be the zero address.
314      * - the caller must have a balance of at least `amount`.
315      */
316     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
317         _transfer(_msgSender(), recipient, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-allowance}.
323      */
324     function allowance(address owner, address spender) public view virtual override returns (uint256) {
325         return _allowances[owner][spender];
326     }
327 
328     /**
329      * @dev See {IERC20-approve}.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function approve(address spender, uint256 amount) public virtual override returns (bool) {
336         _approve(_msgSender(), spender, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-transferFrom}.
342      *
343      * Emits an {Approval} event indicating the updated allowance. This is not
344      * required by the EIP. See the note at the beginning of {ERC20}.
345      *
346      * Requirements:
347      *
348      * - `sender` and `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      * - the caller must have allowance for ``sender``'s tokens of at least
351      * `amount`.
352      */
353     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
354         _transfer(sender, recipient, amount);
355         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
356         return true;
357     }
358 
359     /**
360      * @dev Atomically increases the allowance granted to `spender` by the caller.
361      *
362      * This is an alternative to {approve} that can be used as a mitigation for
363      * problems described in {IERC20-approve}.
364      *
365      * Emits an {Approval} event indicating the updated allowance.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
372         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
373         return true;
374     }
375 
376     /**
377      * @dev Atomically decreases the allowance granted to `spender` by the caller.
378      *
379      * This is an alternative to {approve} that can be used as a mitigation for
380      * problems described in {IERC20-approve}.
381      *
382      * Emits an {Approval} event indicating the updated allowance.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      * - `spender` must have allowance for the caller of at least
388      * `subtractedValue`.
389      */
390     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
391         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
392         return true;
393     }
394 
395     /**
396      * @dev Moves tokens `amount` from `sender` to `recipient`.
397      *
398      * This is internal function is equivalent to {transfer}, and can be used to
399      * e.g. implement automatic token fees, slashing mechanisms, etc.
400      *
401      * Emits a {Transfer} event.
402      *
403      * Requirements:
404      *
405      * - `sender` cannot be the zero address.
406      * - `recipient` cannot be the zero address.
407      * - `sender` must have a balance of at least `amount`.
408      */
409     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
410         require(sender != address(0), "ERC20: transfer from the zero address");
411         require(recipient != address(0), "ERC20: transfer to the zero address");
412 
413         _beforeTokenTransfer(sender, recipient, amount);
414 
415         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
416         _balances[recipient] = _balances[recipient].add(amount);
417         emit Transfer(sender, recipient, amount);
418     }
419 
420     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
421      * the total supply.
422      *
423      * Emits a {Transfer} event with `from` set to the zero address.
424      *
425      * Requirements:
426      *
427      * - `to` cannot be the zero address.
428      */
429     function _mint(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: mint to the zero address");
431 
432         _beforeTokenTransfer(address(0), account, amount);
433 
434         _totalSupply = _totalSupply.add(amount);
435         _balances[account] = _balances[account].add(amount);
436         emit Transfer(address(0), account, amount);
437     }
438 
439     /**
440      * @dev Destroys `amount` tokens from `account`, reducing the
441      * total supply.
442      *
443      * Emits a {Transfer} event with `to` set to the zero address.
444      *
445      * Requirements:
446      *
447      * - `account` cannot be the zero address.
448      * - `account` must have at least `amount` tokens.
449      */
450     function _burn(address account, uint256 amount) internal virtual {
451         require(account != address(0), "ERC20: burn from the zero address");
452 
453         _beforeTokenTransfer(account, address(0), amount);
454 
455         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
456         _totalSupply = _totalSupply.sub(amount);
457         emit Transfer(account, address(0), amount);
458     }
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
462      *
463      * This internal function is equivalent to `approve`, and can be used to
464      * e.g. set automatic allowances for certain subsystems, etc.
465      *
466      * Emits an {Approval} event.
467      *
468      * Requirements:
469      *
470      * - `owner` cannot be the zero address.
471      * - `spender` cannot be the zero address.
472      */
473     function _approve(address owner, address spender, uint256 amount) internal virtual {
474         require(owner != address(0), "ERC20: approve from the zero address");
475         require(spender != address(0), "ERC20: approve to the zero address");
476 
477         _allowances[owner][spender] = amount;
478         emit Approval(owner, spender, amount);
479     }
480 
481     /**
482      * @dev Sets {decimals} to a value other than the default one of 18.
483      *
484      * WARNING: This function should only be called from the constructor. Most
485      * applications that interact with token contracts will not expect
486      * {decimals} to ever change, and may work incorrectly if it does.
487      */
488     function _setupDecimals(uint8 decimals_) internal {
489         _decimals = decimals_;
490     }
491 
492     /**
493      * @dev Hook that is called before any transfer of tokens. This includes
494      * minting and burning.
495      *
496      * Calling conditions:
497      *
498      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
499      * will be to transferred to `to`.
500      * - when `from` is zero, `amount` tokens will be minted for `to`.
501      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
502      * - `from` and `to` are never both zero.
503      *
504      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
505      */
506     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
507 }
508 
509 // File: BaoToken.sol
510 
511 pragma solidity 0.6.12;
512 
513 
514 // BAOToken with Governance.
515 contract BaoToken is ERC20("BaoToken", "BAO"), Ownable, Authorizable {
516     uint256 private _cap;
517     uint256 private _totalLock;
518 
519     uint256 public lockFromBlock;
520     uint256 public lockToBlock;
521     uint256 public manualMintLimit = 1000000e18;
522     uint256 public manualMinted = 0;
523     
524 
525     mapping(address => uint256) private _locks;
526     mapping(address => uint256) private _lastUnlockBlock;
527 
528     event Lock(address indexed to, uint256 value);
529 
530     constructor(uint256 _lockFromBlock, uint256 _lockToBlock) public {
531         lockFromBlock = _lockFromBlock;
532         lockToBlock = _lockToBlock;
533     }
534 
535     /**
536      * @dev Returns the cap on the token's total supply.
537      */
538     function cap() public view returns (uint256) {
539         return _cap;
540     }
541     
542      // Update the total cap - can go up or down but wont destroy prevoius tokens.
543     function capUpdate(uint256 _newCap) public onlyAuthorized {
544         _cap = _newCap;
545     }
546     
547      // Update the lockFromBlock
548     function lockFromUpdate(uint256 _newLockFrom) public onlyAuthorized {
549         lockFromBlock = _newLockFrom;
550     }
551     
552      // Update the lockToBlock
553     function lockToUpdate(uint256 _newLockTo) public onlyAuthorized {
554         lockToBlock = _newLockTo;
555     }
556 
557 
558     function unlockedSupply() public view returns (uint256) {
559         return totalSupply().sub(_totalLock);
560     }
561     
562     function lockedSupply() public view returns (uint256) {
563         return totalLock();
564     }
565     
566     function circulatingSupply() public view returns (uint256) {
567         return totalSupply();
568     }
569 
570     function totalLock() public view returns (uint256) {
571         return _totalLock;
572     }
573 
574     /**
575      * @dev See {ERC20-_beforeTokenTransfer}.
576      *
577      * Requirements:
578      *
579      * - minted tokens must not cause the total supply to go over the cap.
580      */
581     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
582         super._beforeTokenTransfer(from, to, amount);
583 
584         if (from == address(0)) { // When minting tokens
585             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
586         }
587     }
588 
589     /**
590      * @dev Moves tokens `amount` from `sender` to `recipient`.
591      *
592      * This is internal function is equivalent to {transfer}, and can be used to
593      * e.g. implement automatic token fees, slashing mechanisms, etc.
594      *
595      * Emits a {Transfer} event.
596      *
597      * Requirements:
598      *
599      * - `sender` cannot be the zero address.
600      * - `recipient` cannot be the zero address.
601      * - `sender` must have a balance of at least `amount`.
602      */
603     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
604         super._transfer(sender, recipient, amount);
605         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
606     }
607 
608     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
609     function mint(address _to, uint256 _amount) public onlyOwner {
610         _mint(_to, _amount);
611         _moveDelegates(address(0), _delegates[_to], _amount);
612     }
613     
614       function manualMint(address _to, uint256 _amount) public onlyAuthorized {
615         if(manualMinted < manualMintLimit){
616         _mint(_to, _amount);
617         _moveDelegates(address(0), _delegates[_to], _amount);
618         manualMinted = manualMinted + _amount;
619         }
620     }
621 
622     function totalBalanceOf(address _holder) public view returns (uint256) {
623         return _locks[_holder].add(balanceOf(_holder));
624     }
625 
626     function lockOf(address _holder) public view returns (uint256) {
627         return _locks[_holder];
628     }
629 
630     function lastUnlockBlock(address _holder) public view returns (uint256) {
631         return _lastUnlockBlock[_holder];
632     }
633 
634     function lock(address _holder, uint256 _amount) public onlyOwner {
635         require(_holder != address(0), "ERC20: lock to the zero address");
636         require(_amount <= balanceOf(_holder), "ERC20: lock amount over balance");
637 
638         _transfer(_holder, address(this), _amount);
639 
640         _locks[_holder] = _locks[_holder].add(_amount);
641         _totalLock = _totalLock.add(_amount);
642         if (_lastUnlockBlock[_holder] < lockFromBlock) {
643             _lastUnlockBlock[_holder] = lockFromBlock;
644         }
645         emit Lock(_holder, _amount);
646     }
647 
648     function canUnlockAmount(address _holder) public view returns (uint256) {
649         if (block.number < lockFromBlock) {
650             return 0;
651         }
652         else if (block.number >= lockToBlock) {
653             return _locks[_holder];
654         }
655         else {
656             uint256 releaseBlock = block.number.sub(_lastUnlockBlock[_holder]);
657             uint256 numberLockBlock = lockToBlock.sub(_lastUnlockBlock[_holder]);
658             return _locks[_holder].mul(releaseBlock).div(numberLockBlock);
659         }
660     }
661 
662     function unlock() public {
663         require(_locks[msg.sender] > 0, "ERC20: cannot unlock");
664         
665         uint256 amount = canUnlockAmount(msg.sender);
666         // just for sure
667         if (amount > balanceOf(address(this))) {
668             amount = balanceOf(address(this));
669         }
670         _transfer(address(this), msg.sender, amount);
671         _locks[msg.sender] = _locks[msg.sender].sub(amount);
672         _lastUnlockBlock[msg.sender] = block.number;
673         _totalLock = _totalLock.sub(amount);
674     }
675 
676     // This function is for dev address migrate all balance to a multi sig address
677     function transferAll(address _to) public {
678         _locks[_to] = _locks[_to].add(_locks[msg.sender]);
679 
680         if (_lastUnlockBlock[_to] < lockFromBlock) {
681             _lastUnlockBlock[_to] = lockFromBlock;
682         }
683 
684         if (_lastUnlockBlock[_to] < _lastUnlockBlock[msg.sender]) {
685             _lastUnlockBlock[_to] = _lastUnlockBlock[msg.sender];
686         }
687 
688         _locks[msg.sender] = 0;
689         _lastUnlockBlock[msg.sender] = 0;
690 
691         _transfer(msg.sender, _to, balanceOf(msg.sender));
692     }
693 
694     // Copied and modified from YAM code:
695     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
696     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
697     // Which is copied and modified from COMPOUND:
698     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
699 
700     /// @dev A record of each accounts delegate
701     mapping (address => address) internal _delegates;
702 
703     /// @notice A checkpoint for marking number of votes from a given block
704     struct Checkpoint {
705         uint32 fromBlock;
706         uint256 votes;
707     }
708 
709     /// @notice A record of votes checkpoints for each account, by index
710     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
711 
712     /// @notice The number of checkpoints for each account
713     mapping (address => uint32) public numCheckpoints;
714 
715     /// @notice The EIP-712 typehash for the contract's domain
716     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
717 
718     /// @notice The EIP-712 typehash for the delegation struct used by the contract
719     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
720 
721     /// @notice A record of states for signing / validating signatures
722     mapping (address => uint) public nonces;
723 
724       /// @notice An event thats emitted when an account changes its delegate
725     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
726 
727     /// @notice An event thats emitted when a delegate account's vote balance changes
728     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
729 
730     /**
731      * @notice Delegate votes from `msg.sender` to `delegatee`
732      * @param delegator The address to get delegatee for
733      */
734     function delegates(address delegator)
735         external
736         view
737         returns (address)
738     {
739         return _delegates[delegator];
740     }
741 
742    /**
743     * @notice Delegate votes from `msg.sender` to `delegatee`
744     * @param delegatee The address to delegate votes to
745     */
746     function delegate(address delegatee) external {
747         return _delegate(msg.sender, delegatee);
748     }
749 
750     /**
751      * @notice Delegates votes from signatory to `delegatee`
752      * @param delegatee The address to delegate votes to
753      * @param nonce The contract state required to match the signature
754      * @param expiry The time at which to expire the signature
755      * @param v The recovery byte of the signature
756      * @param r Half of the ECDSA signature pair
757      * @param s Half of the ECDSA signature pair
758      */
759     function delegateBySig(
760         address delegatee,
761         uint nonce,
762         uint expiry,
763         uint8 v,
764         bytes32 r,
765         bytes32 s
766     )
767         external
768     {
769         bytes32 domainSeparator = keccak256(
770             abi.encode(
771                 DOMAIN_TYPEHASH,
772                 keccak256(bytes(name())),
773                 getChainId(),
774                 address(this)
775             )
776         );
777 
778         bytes32 structHash = keccak256(
779             abi.encode(
780                 DELEGATION_TYPEHASH,
781                 delegatee,
782                 nonce,
783                 expiry
784             )
785         );
786 
787         bytes32 digest = keccak256(
788             abi.encodePacked(
789                 "\x19\x01",
790                 domainSeparator,
791                 structHash
792             )
793         );
794 
795         address signatory = ecrecover(digest, v, r, s);
796         require(signatory != address(0), "BAO::delegateBySig: invalid signature");
797         require(nonce == nonces[signatory]++, "BAO::delegateBySig: invalid nonce");
798         require(now <= expiry, "BAO::delegateBySig: signature expired");
799         return _delegate(signatory, delegatee);
800     }
801 
802     /**
803      * @notice Gets the current votes balance for `account`
804      * @param account The address to get votes balance
805      * @return The number of current votes for `account`
806      */
807     function getCurrentVotes(address account)
808         external
809         view
810         returns (uint256)
811     {
812         uint32 nCheckpoints = numCheckpoints[account];
813         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
814     }
815 
816     /**
817      * @notice Determine the prior number of votes for an account as of a block number
818      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
819      * @param account The address of the account to check
820      * @param blockNumber The block number to get the vote balance at
821      * @return The number of votes the account had as of the given block
822      */
823     function getPriorVotes(address account, uint blockNumber)
824         external
825         view
826         returns (uint256)
827     {
828         require(blockNumber < block.number, "BAO::getPriorVotes: not yet determined");
829 
830         uint32 nCheckpoints = numCheckpoints[account];
831         if (nCheckpoints == 0) {
832             return 0;
833         }
834 
835         // First check most recent balance
836         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
837             return checkpoints[account][nCheckpoints - 1].votes;
838         }
839 
840         // Next check implicit zero balance
841         if (checkpoints[account][0].fromBlock > blockNumber) {
842             return 0;
843         }
844 
845         uint32 lower = 0;
846         uint32 upper = nCheckpoints - 1;
847         while (upper > lower) {
848             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
849             Checkpoint memory cp = checkpoints[account][center];
850             if (cp.fromBlock == blockNumber) {
851                 return cp.votes;
852             } else if (cp.fromBlock < blockNumber) {
853                 lower = center;
854             } else {
855                 upper = center - 1;
856             }
857         }
858         return checkpoints[account][lower].votes;
859     }
860 
861     function _delegate(address delegator, address delegatee)
862         internal
863     {
864         address currentDelegate = _delegates[delegator];
865         uint256 delegatorBalance = balanceOf(delegator);
866         _delegates[delegator] = delegatee;
867 
868         emit DelegateChanged(delegator, currentDelegate, delegatee);
869 
870         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
871     }
872 
873     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
874         if (srcRep != dstRep && amount > 0) {
875             if (srcRep != address(0)) {
876                 // decrease old representative
877                 uint32 srcRepNum = numCheckpoints[srcRep];
878                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
879                 uint256 srcRepNew = srcRepOld.sub(amount);
880                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
881             }
882 
883             if (dstRep != address(0)) {
884                 // increase new representative
885                 uint32 dstRepNum = numCheckpoints[dstRep];
886                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
887                 uint256 dstRepNew = dstRepOld.add(amount);
888                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
889             }
890         }
891     }
892 
893     function _writeCheckpoint(
894         address delegatee,
895         uint32 nCheckpoints,
896         uint256 oldVotes,
897         uint256 newVotes
898     )
899         internal
900     {
901         uint32 blockNumber = safe32(block.number, "BAO::_writeCheckpoint: block number exceeds 32 bits");
902 
903         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
904             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
905         } else {
906             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
907             numCheckpoints[delegatee] = nCheckpoints + 1;
908         }
909 
910         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
911     }
912 
913     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
914         require(n < 2**32, errorMessage);
915         return uint32(n);
916     }
917 
918     function getChainId() internal pure returns (uint) {
919         uint256 chainId;
920         assembly { chainId := chainid() }
921         return chainId;
922     }
923     
924 }
925 
926 
927 // File: EnumerableSet6.sol
928 
929 pragma solidity ^0.6.0;
930 
931 /**
932  * @dev Library for managing
933  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
934  * types.
935  *
936  * Sets have the following properties:
937  *
938  * - Elements are added, removed, and checked for existence in constant time
939  * (O(1)).
940  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
941  *
942  * ```
943  * contract Example {
944  *     // Add the library methods
945  *     using EnumerableSet for EnumerableSet.AddressSet;
946  *
947  *     // Declare a set state variable
948  *     EnumerableSet.AddressSet private mySet;
949  * }
950  * ```
951  *
952  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
953  * (`UintSet`) are supported.
954  */
955 library EnumerableSet {
956     // To implement this library for multiple types with as little code
957     // repetition as possible, we write it in terms of a generic Set type with
958     // bytes32 values.
959     // The Set implementation uses private functions, and user-facing
960     // implementations (such as AddressSet) are just wrappers around the
961     // underlying Set.
962     // This means that we can only create new EnumerableSets for types that fit
963     // in bytes32.
964 
965     struct Set {
966         // Storage of set values
967         bytes32[] _values;
968 
969         // Position of the value in the `values` array, plus 1 because index 0
970         // means a value is not in the set.
971         mapping (bytes32 => uint256) _indexes;
972     }
973 
974     /**
975      * @dev Add a value to a set. O(1).
976      *
977      * Returns true if the value was added to the set, that is if it was not
978      * already present.
979      */
980     function _add(Set storage set, bytes32 value) private returns (bool) {
981         if (!_contains(set, value)) {
982             set._values.push(value);
983             // The value is stored at length-1, but we add 1 to all indexes
984             // and use 0 as a sentinel value
985             set._indexes[value] = set._values.length;
986             return true;
987         } else {
988             return false;
989         }
990     }
991 
992     /**
993      * @dev Removes a value from a set. O(1).
994      *
995      * Returns true if the value was removed from the set, that is if it was
996      * present.
997      */
998     function _remove(Set storage set, bytes32 value) private returns (bool) {
999         // We read and store the value's index to prevent multiple reads from the same storage slot
1000         uint256 valueIndex = set._indexes[value];
1001 
1002         if (valueIndex != 0) { // Equivalent to contains(set, value)
1003             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1004             // the array, and then remove the last element (sometimes called as 'swap and pop').
1005             // This modifies the order of the array, as noted in {at}.
1006 
1007             uint256 toDeleteIndex = valueIndex - 1;
1008             uint256 lastIndex = set._values.length - 1;
1009 
1010             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1011             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1012 
1013             bytes32 lastvalue = set._values[lastIndex];
1014 
1015             // Move the last value to the index where the value to delete is
1016             set._values[toDeleteIndex] = lastvalue;
1017             // Update the index for the moved value
1018             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1019 
1020             // Delete the slot where the moved value was stored
1021             set._values.pop();
1022 
1023             // Delete the index for the deleted slot
1024             delete set._indexes[value];
1025 
1026             return true;
1027         } else {
1028             return false;
1029         }
1030     }
1031 
1032     /**
1033      * @dev Returns true if the value is in the set. O(1).
1034      */
1035     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1036         return set._indexes[value] != 0;
1037     }
1038 
1039     /**
1040      * @dev Returns the number of values on the set. O(1).
1041      */
1042     function _length(Set storage set) private view returns (uint256) {
1043         return set._values.length;
1044     }
1045 
1046    /**
1047     * @dev Returns the value stored at position `index` in the set. O(1).
1048     *
1049     * Note that there are no guarantees on the ordering of values inside the
1050     * array, and it may change when more values are added or removed.
1051     *
1052     * Requirements:
1053     *
1054     * - `index` must be strictly less than {length}.
1055     */
1056     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1057         require(set._values.length > index, "EnumerableSet: index out of bounds");
1058         return set._values[index];
1059     }
1060 
1061     // AddressSet
1062 
1063     struct AddressSet {
1064         Set _inner;
1065     }
1066 
1067     /**
1068      * @dev Add a value to a set. O(1).
1069      *
1070      * Returns true if the value was added to the set, that is if it was not
1071      * already present.
1072      */
1073     function add(AddressSet storage set, address value) internal returns (bool) {
1074         return _add(set._inner, bytes32(uint256(value)));
1075     }
1076 
1077     /**
1078      * @dev Removes a value from a set. O(1).
1079      *
1080      * Returns true if the value was removed from the set, that is if it was
1081      * present.
1082      */
1083     function remove(AddressSet storage set, address value) internal returns (bool) {
1084         return _remove(set._inner, bytes32(uint256(value)));
1085     }
1086 
1087     /**
1088      * @dev Returns true if the value is in the set. O(1).
1089      */
1090     function contains(AddressSet storage set, address value) internal view returns (bool) {
1091         return _contains(set._inner, bytes32(uint256(value)));
1092     }
1093 
1094     /**
1095      * @dev Returns the number of values in the set. O(1).
1096      */
1097     function length(AddressSet storage set) internal view returns (uint256) {
1098         return _length(set._inner);
1099     }
1100 
1101    /**
1102     * @dev Returns the value stored at position `index` in the set. O(1).
1103     *
1104     * Note that there are no guarantees on the ordering of values inside the
1105     * array, and it may change when more values are added or removed.
1106     *
1107     * Requirements:
1108     *
1109     * - `index` must be strictly less than {length}.
1110     */
1111     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1112         return address(uint256(_at(set._inner, index)));
1113     }
1114 
1115 
1116     // UintSet
1117 
1118     struct UintSet {
1119         Set _inner;
1120     }
1121 
1122     /**
1123      * @dev Add a value to a set. O(1).
1124      *
1125      * Returns true if the value was added to the set, that is if it was not
1126      * already present.
1127      */
1128     function add(UintSet storage set, uint256 value) internal returns (bool) {
1129         return _add(set._inner, bytes32(value));
1130     }
1131 
1132     /**
1133      * @dev Removes a value from a set. O(1).
1134      *
1135      * Returns true if the value was removed from the set, that is if it was
1136      * present.
1137      */
1138     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1139         return _remove(set._inner, bytes32(value));
1140     }
1141 
1142     /**
1143      * @dev Returns true if the value is in the set. O(1).
1144      */
1145     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1146         return _contains(set._inner, bytes32(value));
1147     }
1148 
1149     /**
1150      * @dev Returns the number of values on the set. O(1).
1151      */
1152     function length(UintSet storage set) internal view returns (uint256) {
1153         return _length(set._inner);
1154     }
1155 
1156    /**
1157     * @dev Returns the value stored at position `index` in the set. O(1).
1158     *
1159     * Note that there are no guarantees on the ordering of values inside the
1160     * array, and it may change when more values are added or removed.
1161     *
1162     * Requirements:
1163     *
1164     * - `index` must be strictly less than {length}.
1165     */
1166     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1167         return uint256(_at(set._inner, index));
1168     }
1169 }
1170 
1171 // File: Address6.sol
1172 
1173 pragma solidity ^0.6.2;
1174 
1175 /**
1176  * @dev Collection of functions related to the address type
1177  */
1178 library Address {
1179     /**
1180      * @dev Returns true if `account` is a contract.
1181      *
1182      * [IMPORTANT]
1183      * ====
1184      * It is unsafe to assume that an address for which this function returns
1185      * false is an externally-owned account (EOA) and not a contract.
1186      *
1187      * Among others, `isContract` will return false for the following
1188      * types of addresses:
1189      *
1190      *  - an externally-owned account
1191      *  - a contract in construction
1192      *  - an address where a contract will be created
1193      *  - an address where a contract lived, but was destroyed
1194      * ====
1195      */
1196     function isContract(address account) internal view returns (bool) {
1197         // This method relies on extcodesize, which returns 0 for contracts in
1198         // construction, since the code is only stored at the end of the
1199         // constructor execution.
1200 
1201         uint256 size;
1202         // solhint-disable-next-line no-inline-assembly
1203         assembly { size := extcodesize(account) }
1204         return size > 0;
1205     }
1206 
1207     /**
1208      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1209      * `recipient`, forwarding all available gas and reverting on errors.
1210      *
1211      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1212      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1213      * imposed by `transfer`, making them unable to receive funds via
1214      * `transfer`. {sendValue} removes this limitation.
1215      *
1216      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1217      *
1218      * IMPORTANT: because control is transferred to `recipient`, care must be
1219      * taken to not create reentrancy vulnerabilities. Consider using
1220      * {ReentrancyGuard} or the
1221      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1222      */
1223     function sendValue(address payable recipient, uint256 amount) internal {
1224         require(address(this).balance >= amount, "Address: insufficient balance");
1225 
1226         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1227         (bool success, ) = recipient.call{ value: amount }("");
1228         require(success, "Address: unable to send value, recipient may have reverted");
1229     }
1230 
1231     /**
1232      * @dev Performs a Solidity function call using a low level `call`. A
1233      * plain`call` is an unsafe replacement for a function call: use this
1234      * function instead.
1235      *
1236      * If `target` reverts with a revert reason, it is bubbled up by this
1237      * function (like regular Solidity function calls).
1238      *
1239      * Returns the raw returned data. To convert to the expected return value,
1240      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1241      *
1242      * Requirements:
1243      *
1244      * - `target` must be a contract.
1245      * - calling `target` with `data` must not revert.
1246      *
1247      * _Available since v3.1._
1248      */
1249     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1250       return functionCall(target, data, "Address: low-level call failed");
1251     }
1252 
1253     /**
1254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1255      * `errorMessage` as a fallback revert reason when `target` reverts.
1256      *
1257      * _Available since v3.1._
1258      */
1259     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1260         return functionCallWithValue(target, data, 0, errorMessage);
1261     }
1262 
1263     /**
1264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1265      * but also transferring `value` wei to `target`.
1266      *
1267      * Requirements:
1268      *
1269      * - the calling contract must have an ETH balance of at least `value`.
1270      * - the called Solidity function must be `payable`.
1271      *
1272      * _Available since v3.1._
1273      */
1274     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1275         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1276     }
1277 
1278     /**
1279      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1280      * with `errorMessage` as a fallback revert reason when `target` reverts.
1281      *
1282      * _Available since v3.1._
1283      */
1284     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1285         require(address(this).balance >= value, "Address: insufficient balance for call");
1286         require(isContract(target), "Address: call to non-contract");
1287 
1288         // solhint-disable-next-line avoid-low-level-calls
1289         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1290         return _verifyCallResult(success, returndata, errorMessage);
1291     }
1292 
1293     /**
1294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1295      * but performing a static call.
1296      *
1297      * _Available since v3.3._
1298      */
1299     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1300         return functionStaticCall(target, data, "Address: low-level static call failed");
1301     }
1302 
1303     /**
1304      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1305      * but performing a static call.
1306      *
1307      * _Available since v3.3._
1308      */
1309     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1310         require(isContract(target), "Address: static call to non-contract");
1311 
1312         // solhint-disable-next-line avoid-low-level-calls
1313         (bool success, bytes memory returndata) = target.staticcall(data);
1314         return _verifyCallResult(success, returndata, errorMessage);
1315     }
1316 
1317     /**
1318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1319      * but performing a delegate call.
1320      *
1321      * _Available since v3.3._
1322      */
1323     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1324         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1325     }
1326 
1327     /**
1328      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1329      * but performing a delegate call.
1330      *
1331      * _Available since v3.3._
1332      */
1333     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1334         require(isContract(target), "Address: delegate call to non-contract");
1335 
1336         // solhint-disable-next-line avoid-low-level-calls
1337         (bool success, bytes memory returndata) = target.delegatecall(data);
1338         return _verifyCallResult(success, returndata, errorMessage);
1339     }
1340 
1341     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1342         if (success) {
1343             return returndata;
1344         } else {
1345             // Look for revert reason and bubble it up if present
1346             if (returndata.length > 0) {
1347                 // The easiest way to bubble the revert reason is using memory via assembly
1348 
1349                 // solhint-disable-next-line no-inline-assembly
1350                 assembly {
1351                     let returndata_size := mload(returndata)
1352                     revert(add(32, returndata), returndata_size)
1353                 }
1354             } else {
1355                 revert(errorMessage);
1356             }
1357         }
1358     }
1359 }
1360 
1361 // File: SafeMath6.sol
1362 
1363 pragma solidity ^0.6.0;
1364 
1365 /**
1366  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1367  * checks.
1368  *
1369  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1370  * in bugs, because programmers usually assume that an overflow raises an
1371  * error, which is the standard behavior in high level programming languages.
1372  * `SafeMath` restores this intuition by reverting the transaction when an
1373  * operation overflows.
1374  *
1375  * Using this library instead of the unchecked operations eliminates an entire
1376  * class of bugs, so it's recommended to use it always.
1377  */
1378 library SafeMath {
1379     /**
1380      * @dev Returns the addition of two unsigned integers, reverting on
1381      * overflow.
1382      *
1383      * Counterpart to Solidity's `+` operator.
1384      *
1385      * Requirements:
1386      *
1387      * - Addition cannot overflow.
1388      */
1389     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1390         uint256 c = a + b;
1391         require(c >= a, "SafeMath: addition overflow");
1392 
1393         return c;
1394     }
1395 
1396     /**
1397      * @dev Returns the subtraction of two unsigned integers, reverting on
1398      * overflow (when the result is negative).
1399      *
1400      * Counterpart to Solidity's `-` operator.
1401      *
1402      * Requirements:
1403      *
1404      * - Subtraction cannot overflow.
1405      */
1406     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1407         return sub(a, b, "SafeMath: subtraction overflow");
1408     }
1409 
1410     /**
1411      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1412      * overflow (when the result is negative).
1413      *
1414      * Counterpart to Solidity's `-` operator.
1415      *
1416      * Requirements:
1417      *
1418      * - Subtraction cannot overflow.
1419      */
1420     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1421         require(b <= a, errorMessage);
1422         uint256 c = a - b;
1423 
1424         return c;
1425     }
1426 
1427     /**
1428      * @dev Returns the multiplication of two unsigned integers, reverting on
1429      * overflow.
1430      *
1431      * Counterpart to Solidity's `*` operator.
1432      *
1433      * Requirements:
1434      *
1435      * - Multiplication cannot overflow.
1436      */
1437     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1438         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1439         // benefit is lost if 'b' is also tested.
1440         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1441         if (a == 0) {
1442             return 0;
1443         }
1444 
1445         uint256 c = a * b;
1446         require(c / a == b, "SafeMath: multiplication overflow");
1447 
1448         return c;
1449     }
1450 
1451     /**
1452      * @dev Returns the integer division of two unsigned integers. Reverts on
1453      * division by zero. The result is rounded towards zero.
1454      *
1455      * Counterpart to Solidity's `/` operator. Note: this function uses a
1456      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1457      * uses an invalid opcode to revert (consuming all remaining gas).
1458      *
1459      * Requirements:
1460      *
1461      * - The divisor cannot be zero.
1462      */
1463     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1464         return div(a, b, "SafeMath: division by zero");
1465     }
1466 
1467     /**
1468      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1469      * division by zero. The result is rounded towards zero.
1470      *
1471      * Counterpart to Solidity's `/` operator. Note: this function uses a
1472      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1473      * uses an invalid opcode to revert (consuming all remaining gas).
1474      *
1475      * Requirements:
1476      *
1477      * - The divisor cannot be zero.
1478      */
1479     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1480         require(b > 0, errorMessage);
1481         uint256 c = a / b;
1482         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1483 
1484         return c;
1485     }
1486 
1487     /**
1488      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1489      * Reverts when dividing by zero.
1490      *
1491      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1492      * opcode (which leaves remaining gas untouched) while Solidity uses an
1493      * invalid opcode to revert (consuming all remaining gas).
1494      *
1495      * Requirements:
1496      *
1497      * - The divisor cannot be zero.
1498      */
1499     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1500         return mod(a, b, "SafeMath: modulo by zero");
1501     }
1502 
1503     /**
1504      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1505      * Reverts with custom message when dividing by zero.
1506      *
1507      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1508      * opcode (which leaves remaining gas untouched) while Solidity uses an
1509      * invalid opcode to revert (consuming all remaining gas).
1510      *
1511      * Requirements:
1512      *
1513      * - The divisor cannot be zero.
1514      */
1515     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1516         require(b != 0, errorMessage);
1517         return a % b;
1518     }
1519 }
1520 
1521 // File: SafeERC206.sol
1522 
1523 pragma solidity ^0.6.0;
1524 
1525 
1526 /**
1527  * @title SafeERC20
1528  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1529  * contract returns false). Tokens that return no value (and instead revert or
1530  * throw on failure) are also supported, non-reverting calls are assumed to be
1531  * successful.
1532  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1533  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1534  */
1535 library SafeERC20 {
1536     using SafeMath for uint256;
1537     using Address for address;
1538 
1539     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1540         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1541     }
1542 
1543     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1544         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1545     }
1546 
1547     /**
1548      * @dev Deprecated. This function has issues similar to the ones found in
1549      * {IERC20-approve}, and its usage is discouraged.
1550      *
1551      * Whenever possible, use {safeIncreaseAllowance} and
1552      * {safeDecreaseAllowance} instead.
1553      */
1554     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1555         // safeApprove should only be called when setting an initial allowance,
1556         // or when resetting it to zero. To increase and decrease it, use
1557         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1558         // solhint-disable-next-line max-line-length
1559         require((value == 0) || (token.allowance(address(this), spender) == 0),
1560             "SafeERC20: approve from non-zero to non-zero allowance"
1561         );
1562         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1563     }
1564 
1565     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1566         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1567         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1568     }
1569 
1570     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1571         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1572         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1573     }
1574 
1575     /**
1576      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1577      * on the return value: the return value is optional (but if data is returned, it must not be false).
1578      * @param token The token targeted by the call.
1579      * @param data The call data (encoded using abi.encode or one of its variants).
1580      */
1581     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1582         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1583         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1584         // the target address contains contract code and also asserts for success in the low-level call.
1585 
1586         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1587         if (returndata.length > 0) { // Return data is optional
1588             // solhint-disable-next-line max-line-length
1589             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1590         }
1591     }
1592 }
1593 
1594 
1595 // File: browser/BaoMasterFarmer.sol
1596 
1597 pragma solidity 0.6.12;
1598 
1599 
1600 interface IMigratorToBaoSwap {
1601     // Perform LP token migration from legacy UniswapV2 to BaoSwap.
1602     // Take the current LP token address and return the new LP token address.
1603     // Migrator should have full access to the caller's LP token.
1604     // Return the new LP token address.
1605     //
1606     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1607     // BaoSwap must mint EXACTLY the same amount of BaoSwap LP tokens or
1608     // else something bad will happen. Traditional UniswapV2 does not
1609     // do that so be careful!
1610     function migrate(IERC20 token) external returns (IERC20);
1611 }
1612 
1613 // BaoMasterFarmer is the master of Bao. He can make Bao and he is a fair guy.
1614 //
1615 // Note that it's ownable and the owner wields tremendous power. The ownership
1616 // will be transferred to a governance smart contract once Bao is sufficiently
1617 // distributed and the community can show to govern itself.
1618 //
1619 contract BaoMasterFarmer is Ownable, Authorizable {
1620     using SafeMath for uint256;
1621     using SafeERC20 for IERC20;
1622 
1623     // Info of each user.
1624     struct UserInfo {
1625         uint256 amount;     // How many LP tokens the user has provided.
1626         uint256 rewardDebt; // Reward debt. See explanation below.
1627         uint256 rewardDebtAtBlock; // the last block user stake
1628 		uint256 lastWithdrawBlock; // the last block a user withdrew at.
1629 		uint256 firstDepositBlock; // the last block a user deposited at.
1630 		uint256 blockdelta; //time passed since withdrawals
1631 		uint256 lastDepositBlock;
1632         //
1633         // We do some fancy math here. Basically, any point in time, the amount of Baos
1634         // entitled to a user but is pending to be distributed is:
1635         //
1636         //   pending reward = (user.amount * pool.accBaoPerShare) - user.rewardDebt
1637         //
1638         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1639         //   1. The pool's `accBaoPerShare` (and `lastRewardBlock`) gets updated.
1640         //   2. User receives the pending reward sent to his/her address.
1641         //   3. User's `amount` gets updated.
1642         //   4. User's `rewardDebt` gets updated.
1643     }
1644     
1645     struct UserGlobalInfo {
1646         uint256 globalAmount;
1647         mapping(address => uint256) referrals;
1648         uint256 totalReferals;
1649         uint256 globalRefAmount;
1650     }
1651 
1652     // Info of each pool.
1653     struct PoolInfo {
1654         IERC20 lpToken;           // Address of LP token contract.
1655         uint256 allocPoint;       // How many allocation points assigned to this pool. Baos to distribute per block.
1656         uint256 lastRewardBlock;  // Last block number that Baos distribution occurs.
1657         uint256 accBaoPerShare; // Accumulated Baos per share, times 1e12. See below.
1658     }
1659 
1660     // The Bao TOKEN!
1661     BaoToken public Bao;
1662     //An ETH/USDC Oracle (Chainlink)
1663     address public usdOracle;
1664     // Dev address.
1665     address public devaddr;
1666 	// LP address
1667 	address public liquidityaddr;
1668 	// Community Fund Address
1669 	address public comfundaddr;
1670 	// Founder Reward
1671 	address public founderaddr;
1672     // Bao tokens created per block.
1673     uint256 public REWARD_PER_BLOCK;
1674     // Bonus muliplier for early Bao makers.
1675     uint256[] public REWARD_MULTIPLIER =[4096, 2048, 2048, 1024, 1024, 512, 512, 256, 256, 256, 256, 256, 256, 256, 256, 128, 128, 128, 128, 128, 128, 128, 128, 128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 16, 8, 8, 8, 8, 32, 32, 64, 64, 64, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 256, 256, 256, 128, 128, 128, 128, 128, 128, 128, 128, 128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 16, 16, 16, 16, 8, 8, 8, 4, 2, 1, 0];
1676     uint256[] public HALVING_AT_BLOCK; // init in constructor function
1677     uint256[] public blockDeltaStartStage;
1678     uint256[] public blockDeltaEndStage;
1679     uint256[] public userFeeStage;
1680     uint256[] public devFeeStage;
1681     uint256 public FINISH_BONUS_AT_BLOCK;
1682     uint256 public userDepFee;
1683     uint256 public devDepFee;
1684 
1685     // The block number when Bao mining starts.
1686     uint256 public START_BLOCK;
1687 
1688     uint256 public PERCENT_LOCK_BONUS_REWARD; // lock xx% of bounus reward in 3 year
1689     uint256 public PERCENT_FOR_DEV; // dev bounties + partnerships
1690 	uint256 public PERCENT_FOR_LP; // LP fund
1691 	uint256 public PERCENT_FOR_COM; // community fund
1692 	uint256 public PERCENT_FOR_FOUNDERS; // founders fund
1693 
1694     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1695     IMigratorToBaoSwap public migrator;
1696 
1697     // Info of each pool.
1698     PoolInfo[] public poolInfo;
1699     mapping(address => uint256) public poolId1; // poolId1 count from 1, subtraction 1 before using with poolInfo
1700     // Info of each user that stakes LP tokens. pid => user address => info
1701     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1702     mapping (address => UserGlobalInfo) public userGlobalInfo;
1703     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1704     uint256 public totalAllocPoint = 0;
1705 
1706     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1707     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1708     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1709     event SendBaoReward(address indexed user, uint256 indexed pid, uint256 amount, uint256 lockAmount);
1710 
1711     constructor(
1712         BaoToken _Bao,
1713         address _devaddr,
1714 		address _liquidityaddr,
1715 		address _comfundaddr,
1716 		address _founderaddr,
1717         uint256 _rewardPerBlock,
1718         uint256 _startBlock,
1719         uint256 _halvingAfterBlock,
1720         uint256 _userDepFee,
1721         uint256 _devDepFee,
1722         uint256[] memory _blockDeltaStartStage,
1723         uint256[] memory _blockDeltaEndStage,
1724         uint256[] memory _userFeeStage,
1725         uint256[] memory _devFeeStage
1726     ) public {
1727         Bao = _Bao;
1728         devaddr = _devaddr;
1729 		liquidityaddr = _liquidityaddr;
1730 		comfundaddr = _comfundaddr;
1731 		founderaddr = _founderaddr;
1732         REWARD_PER_BLOCK = _rewardPerBlock;
1733         START_BLOCK = _startBlock;
1734 	    userDepFee = _userDepFee;
1735 	    devDepFee = _devDepFee;
1736 	    blockDeltaStartStage = _blockDeltaStartStage;
1737 	    blockDeltaEndStage = _blockDeltaEndStage;
1738 	    userFeeStage = _userFeeStage;
1739 	    devFeeStage = _devFeeStage;
1740         for (uint256 i = 0; i < REWARD_MULTIPLIER.length - 1; i++) {
1741             uint256 halvingAtBlock = _halvingAfterBlock.add(i + 1).add(_startBlock);
1742             HALVING_AT_BLOCK.push(halvingAtBlock);
1743         }
1744         FINISH_BONUS_AT_BLOCK = _halvingAfterBlock.mul(REWARD_MULTIPLIER.length - 1).add(_startBlock);
1745         HALVING_AT_BLOCK.push(uint256(-1));
1746     }
1747 
1748     function poolLength() external view returns (uint256) {
1749         return poolInfo.length;
1750     }
1751     
1752 
1753     
1754 
1755     // Add a new lp to the pool. Can only be called by the owner.
1756     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1757         require(poolId1[address(_lpToken)] == 0, "BaoMasterFarmer::add: lp is already in pool");
1758         if (_withUpdate) {
1759             massUpdatePools();
1760         }
1761         uint256 lastRewardBlock = block.number > START_BLOCK ? block.number : START_BLOCK;
1762         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1763         poolId1[address(_lpToken)] = poolInfo.length + 1;
1764         poolInfo.push(PoolInfo({
1765             lpToken: _lpToken,
1766             allocPoint: _allocPoint,
1767             lastRewardBlock: lastRewardBlock,
1768             accBaoPerShare: 0
1769         }));
1770     }
1771 
1772     // Update the given pool's Bao allocation point. Can only be called by the owner.
1773     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1774         if (_withUpdate) {
1775             massUpdatePools();
1776         }
1777         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1778         poolInfo[_pid].allocPoint = _allocPoint;
1779     }
1780 
1781     // Set the migrator contract. Can only be called by the owner.
1782     function setMigrator(IMigratorToBaoSwap _migrator) public onlyOwner {
1783         migrator = _migrator;
1784     }
1785 
1786     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1787     function migrate(uint256 _pid) public {
1788         require(address(migrator) != address(0), "migrate: no migrator");
1789         PoolInfo storage pool = poolInfo[_pid];
1790         IERC20 lpToken = pool.lpToken;
1791         uint256 bal = lpToken.balanceOf(address(this));
1792         lpToken.safeApprove(address(migrator), bal);
1793         IERC20 newLpToken = migrator.migrate(lpToken);
1794         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1795         pool.lpToken = newLpToken;
1796     }
1797 
1798     // Update reward variables for all pools. Be careful of gas spending!
1799     function massUpdatePools() public {
1800         uint256 length = poolInfo.length;
1801         for (uint256 pid = 0; pid < length; ++pid) {
1802             updatePool(pid);
1803         }
1804     }
1805 
1806     // Update reward variables of the given pool to be up-to-date.
1807     function updatePool(uint256 _pid) public {
1808         PoolInfo storage pool = poolInfo[_pid];
1809         if (block.number <= pool.lastRewardBlock) {
1810             return;
1811         }
1812         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1813         if (lpSupply == 0) {
1814             pool.lastRewardBlock = block.number;
1815             return;
1816         }
1817         uint256 BaoForDev;
1818         uint256 BaoForFarmer;
1819 		uint256 BaoForLP;
1820 		uint256 BaoForCom;
1821 		uint256 BaoForFounders;
1822         (BaoForDev, BaoForFarmer, BaoForLP, BaoForCom, BaoForFounders) = getPoolReward(pool.lastRewardBlock, block.number, pool.allocPoint);
1823         Bao.mint(address(this), BaoForFarmer);
1824         pool.accBaoPerShare = pool.accBaoPerShare.add(BaoForFarmer.mul(1e12).div(lpSupply));
1825         pool.lastRewardBlock = block.number;
1826         if (BaoForDev > 0) {
1827             Bao.mint(address(devaddr), BaoForDev);
1828             //Dev fund has xx% locked during the starting bonus period. After which locked funds drip out linearly each block over 3 years.
1829             if (block.number <= FINISH_BONUS_AT_BLOCK) {
1830                 Bao.lock(address(devaddr), BaoForDev.mul(75).div(100));
1831             }
1832         }
1833 		if (BaoForLP > 0) {
1834             Bao.mint(liquidityaddr, BaoForLP);
1835 			//LP + Partnership fund has only xx% locked over time as most of it is needed early on for incentives and listings. The locked amount will drip out linearly each block after the bonus period.
1836 			if (block.number <= FINISH_BONUS_AT_BLOCK) {
1837                 Bao.lock(address(liquidityaddr), BaoForLP.mul(45).div(100));
1838             }
1839         }
1840 		if (BaoForCom > 0) {
1841             Bao.mint(comfundaddr, BaoForCom);
1842 			//Community Fund has xx% locked during bonus period and then drips out linearly over 3 years.
1843             if (block.number <= FINISH_BONUS_AT_BLOCK) {
1844                 Bao.lock(address(comfundaddr), BaoForCom.mul(85).div(100));
1845             }
1846         }
1847 		if (BaoForFounders > 0) {
1848             Bao.mint(founderaddr, BaoForFounders);
1849 			//The Founders reward has xx% of their funds locked during the bonus period which then drip out linearly per block over 3 years.
1850 			if (block.number <= FINISH_BONUS_AT_BLOCK) {
1851                 Bao.lock(address(founderaddr), BaoForFounders.mul(95).div(100));
1852             }
1853         }
1854         
1855     }
1856 
1857     // |--------------------------------------|
1858     // [20, 30, 40, 50, 60, 70, 80, 99999999]
1859     // Return reward multiplier over the given _from to _to block.
1860     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1861         uint256 result = 0;
1862         if (_from < START_BLOCK) return 0;
1863 
1864         for (uint256 i = 0; i < HALVING_AT_BLOCK.length; i++) {
1865             uint256 endBlock = HALVING_AT_BLOCK[i];
1866 
1867             if (_to <= endBlock) {
1868                 uint256 m = _to.sub(_from).mul(REWARD_MULTIPLIER[i]);
1869                 return result.add(m);
1870             }
1871 
1872             if (_from < endBlock) {
1873                 uint256 m = endBlock.sub(_from).mul(REWARD_MULTIPLIER[i]);
1874                 _from = endBlock;
1875                 result = result.add(m);
1876             }
1877         }
1878 
1879         return result;
1880     }
1881 
1882     function getPoolReward(uint256 _from, uint256 _to, uint256 _allocPoint) public view returns (uint256 forDev, uint256 forFarmer, uint256 forLP, uint256 forCom, uint256 forFounders) {
1883         uint256 multiplier = getMultiplier(_from, _to);
1884         uint256 amount = multiplier.mul(REWARD_PER_BLOCK).mul(_allocPoint).div(totalAllocPoint);
1885         uint256 BaoCanMint = Bao.cap().sub(Bao.totalSupply());
1886 
1887         if (BaoCanMint < amount) {
1888             forDev = 0;
1889 			forFarmer = BaoCanMint;
1890 			forLP = 0;
1891 			forCom = 0;
1892 			forFounders = 0;
1893         }
1894         else {
1895             forDev = amount.mul(PERCENT_FOR_DEV).div(100);
1896 			forFarmer = amount;
1897 			forLP = amount.mul(PERCENT_FOR_LP).div(100);
1898 			forCom = amount.mul(PERCENT_FOR_COM).div(100);
1899 			forFounders = amount.mul(PERCENT_FOR_FOUNDERS).div(100);
1900         }
1901     }
1902 
1903     // View function to see pending Baos on frontend.
1904     function pendingReward(uint256 _pid, address _user) external view returns (uint256) {
1905         PoolInfo storage pool = poolInfo[_pid];
1906         UserInfo storage user = userInfo[_pid][_user];
1907         uint256 accBaoPerShare = pool.accBaoPerShare;
1908         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1909         if (block.number > pool.lastRewardBlock && lpSupply > 0) {
1910             uint256 BaoForFarmer;
1911             (, BaoForFarmer, , ,) = getPoolReward(pool.lastRewardBlock, block.number, pool.allocPoint);
1912             accBaoPerShare = accBaoPerShare.add(BaoForFarmer.mul(1e12).div(lpSupply));
1913 
1914         }
1915         return user.amount.mul(accBaoPerShare).div(1e12).sub(user.rewardDebt);
1916     }
1917 
1918     function claimReward(uint256 _pid) public {
1919         updatePool(_pid);
1920         _harvest(_pid);
1921     }
1922 
1923     // lock 95% of reward if it come from bounus time
1924     function _harvest(uint256 _pid) internal {
1925         PoolInfo storage pool = poolInfo[_pid];
1926         UserInfo storage user = userInfo[_pid][msg.sender];
1927 
1928         if (user.amount > 0) {
1929             uint256 pending = user.amount.mul(pool.accBaoPerShare).div(1e12).sub(user.rewardDebt);
1930             uint256 masterBal = Bao.balanceOf(address(this));
1931 
1932             if (pending > masterBal) {
1933                 pending = masterBal;
1934             }
1935             
1936             if(pending > 0) {
1937                 Bao.transfer(msg.sender, pending);
1938                 uint256 lockAmount = 0;
1939                 if (user.rewardDebtAtBlock <= FINISH_BONUS_AT_BLOCK) {
1940                     lockAmount = pending.mul(PERCENT_LOCK_BONUS_REWARD).div(100);
1941                     Bao.lock(msg.sender, lockAmount);
1942                 }
1943 
1944                 user.rewardDebtAtBlock = block.number;
1945 
1946                 emit SendBaoReward(msg.sender, _pid, pending, lockAmount);
1947             }
1948 
1949             user.rewardDebt = user.amount.mul(pool.accBaoPerShare).div(1e12);
1950         }
1951     }
1952 
1953 
1954     function getGlobalAmount(address _user) public view returns(uint256) {
1955         UserGlobalInfo memory current = userGlobalInfo[_user];
1956         return current.globalAmount;
1957     }
1958     
1959      function getGlobalRefAmount(address _user) public view returns(uint256) {
1960         UserGlobalInfo memory current = userGlobalInfo[_user];
1961         return current.globalRefAmount;
1962     }
1963     
1964     function getTotalRefs(address _user) public view returns(uint256) {
1965         UserGlobalInfo memory current = userGlobalInfo[_user];
1966         return current.totalReferals;
1967     }
1968     
1969     function getRefValueOf(address _user, address _user2) public view returns(uint256) {
1970         UserGlobalInfo storage current = userGlobalInfo[_user];
1971         uint256 a = current.referrals[_user2];
1972         return a;
1973     }
1974     
1975     // Deposit LP tokens to BaoMasterFarmer for $BAO allocation.
1976     function deposit(uint256 _pid, uint256 _amount, address _ref) public {
1977         require(_amount > 0, "BaoMasterFarmer::deposit: amount must be greater than 0");
1978 
1979         PoolInfo storage pool = poolInfo[_pid];
1980         UserInfo storage user = userInfo[_pid][msg.sender];
1981         UserInfo storage devr = userInfo[_pid][devaddr];
1982         UserGlobalInfo storage refer = userGlobalInfo[_ref];
1983         UserGlobalInfo storage current = userGlobalInfo[msg.sender];
1984         
1985         if(refer.referrals[msg.sender] > 0){
1986             refer.referrals[msg.sender] = refer.referrals[msg.sender] + _amount;
1987             refer.globalRefAmount = refer.globalRefAmount + _amount;
1988         } else {
1989             refer.referrals[msg.sender] = refer.referrals[msg.sender] + _amount;
1990             refer.totalReferals = refer.totalReferals + 1;
1991             refer.globalRefAmount = refer.globalRefAmount + _amount;
1992         }
1993 
1994         
1995         current.globalAmount = current.globalAmount + _amount.mul(userDepFee).div(100);
1996         
1997         updatePool(_pid);
1998         _harvest(_pid);
1999         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
2000         if (user.amount == 0) {
2001             user.rewardDebtAtBlock = block.number;
2002         }
2003         user.amount = user.amount.add(_amount.sub(_amount.mul(userDepFee).div(10000)));
2004         user.rewardDebt = user.amount.mul(pool.accBaoPerShare).div(1e12);
2005         devr.amount = devr.amount.add(_amount.sub(_amount.mul(devDepFee).div(10000)));
2006         devr.rewardDebt = devr.amount.mul(pool.accBaoPerShare).div(1e12);
2007         emit Deposit(msg.sender, _pid, _amount);
2008 		if(user.firstDepositBlock > 0){
2009 		} else {
2010 			user.firstDepositBlock = block.number;
2011 		}
2012 		user.lastDepositBlock = block.number;
2013     }
2014     
2015   // Withdraw LP tokens from BaoMasterFarmer.
2016     function withdraw(uint256 _pid, uint256 _amount, address _ref) public {
2017         PoolInfo storage pool = poolInfo[_pid];
2018         UserInfo storage user = userInfo[_pid][msg.sender];
2019         UserGlobalInfo storage refer = userGlobalInfo[_ref];
2020         UserGlobalInfo storage current = userGlobalInfo[msg.sender];
2021         require(user.amount >= _amount, "BaoMasterFarmer::withdraw: not good");
2022         if(_ref != address(0)){
2023                 refer.referrals[msg.sender] = refer.referrals[msg.sender] - _amount;
2024                 refer.globalRefAmount = refer.globalRefAmount - _amount;
2025             }
2026         current.globalAmount = current.globalAmount - _amount;
2027         
2028         updatePool(_pid);
2029         _harvest(_pid);
2030 
2031         if(_amount > 0) {
2032             user.amount = user.amount.sub(_amount);
2033 			if(user.lastWithdrawBlock > 0){
2034 				user.blockdelta = block.number - user.lastWithdrawBlock; }
2035 			else {
2036 				user.blockdelta = block.number - user.firstDepositBlock;
2037 			}
2038 			if(user.blockdelta == blockDeltaStartStage[0] || block.number == user.lastDepositBlock){
2039 				//25% fee for withdrawals of LP tokens in the same block this is to prevent abuse from flashloans
2040 				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[0]).div(100));
2041 				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[0]).div(100));
2042 			} else if (user.blockdelta >= blockDeltaStartStage[1] && user.blockdelta <= blockDeltaEndStage[0]){
2043 				//8% fee if a user deposits and withdraws in under between same block and 59 minutes.
2044 				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[1]).div(100));
2045 				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[1]).div(100));
2046 			} else if (user.blockdelta >= blockDeltaStartStage[2] && user.blockdelta <= blockDeltaEndStage[1]){
2047 				//4% fee if a user deposits and withdraws after 1 hour but before 1 day.
2048 				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[2]).div(100));
2049 				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[2]).div(100));
2050 			} else if (user.blockdelta >= blockDeltaStartStage[3] && user.blockdelta <= blockDeltaEndStage[2]){
2051 				//2% fee if a user deposits and withdraws between after 1 day but before 3 days.
2052 				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[3]).div(100));
2053 				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[3]).div(100));
2054 			} else if (user.blockdelta >= blockDeltaStartStage[4] && user.blockdelta <= blockDeltaEndStage[3]){
2055 				//1% fee if a user deposits and withdraws after 3 days but before 5 days.
2056 				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[4]).div(100));
2057 				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[4]).div(100));
2058 			}  else if (user.blockdelta >= blockDeltaStartStage[5] && user.blockdelta <= blockDeltaEndStage[4]){
2059 				//0.5% fee if a user deposits and withdraws if the user withdraws after 5 days but before 2 weeks.
2060 				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[5]).div(1000));
2061 				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[5]).div(1000));
2062 			} else if (user.blockdelta >= blockDeltaStartStage[6] && user.blockdelta <= blockDeltaEndStage[5]){
2063 				//0.25% fee if a user deposits and withdraws after 2 weeks.
2064 				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[6]).div(10000));
2065 				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[6]).div(10000));
2066 			} else if (user.blockdelta > blockDeltaStartStage[7]) {
2067 				//0.1% fee if a user deposits and withdraws after 4 weeks.
2068 				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[7]).div(10000));
2069 				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[7]).div(10000));
2070 			}
2071 		user.rewardDebt = user.amount.mul(pool.accBaoPerShare).div(1e12);
2072         emit Withdraw(msg.sender, _pid, _amount);
2073 		user.lastWithdrawBlock = block.number;
2074 			}
2075         }
2076 
2077 
2078     // Withdraw without caring about rewards. EMERGENCY ONLY. This has the same 25% fee as same block withdrawals to prevent abuse of thisfunction.
2079     function emergencyWithdraw(uint256 _pid) public {
2080         PoolInfo storage pool = poolInfo[_pid];
2081         UserInfo storage user = userInfo[_pid][msg.sender];
2082         //reordered from Sushi function to prevent risk of reentrancy
2083         uint256 amountToSend = user.amount.mul(75).div(100);
2084         uint256 devToSend = user.amount.mul(25).div(100);
2085         user.amount = 0;
2086         user.rewardDebt = 0;
2087         pool.lpToken.safeTransfer(address(msg.sender), amountToSend);
2088         pool.lpToken.safeTransfer(address(devaddr), devToSend);
2089         emit EmergencyWithdraw(msg.sender, _pid, amountToSend);
2090 
2091     }
2092 
2093     // Safe Bao transfer function, just in case if rounding error causes pool to not have enough Baos.
2094     function safeBaoTransfer(address _to, uint256 _amount) internal {
2095         uint256 BaoBal = Bao.balanceOf(address(this));
2096         if (_amount > BaoBal) {
2097             Bao.transfer(_to, BaoBal);
2098         } else {
2099             Bao.transfer(_to, _amount);
2100         }
2101     }
2102 
2103     // Update dev address by the previous dev.
2104     function dev(address _devaddr) public onlyAuthorized {
2105         devaddr = _devaddr;
2106     }
2107     
2108     // Update Finish Bonus Block
2109     function bonusFinishUpdate(uint256 _newFinish) public onlyAuthorized {
2110         FINISH_BONUS_AT_BLOCK = _newFinish;
2111     }
2112     
2113     // Update Halving At Block
2114     function halvingUpdate(uint256[] memory _newHalving) public onlyAuthorized {
2115         HALVING_AT_BLOCK = _newHalving;
2116     }
2117     
2118     // Update Liquidityaddr
2119     function lpUpdate(address _newLP) public onlyAuthorized {
2120        liquidityaddr = _newLP;
2121     }
2122     
2123     // Update comfundaddr
2124     function comUpdate(address _newCom) public onlyAuthorized {
2125        comfundaddr = _newCom;
2126     }
2127     
2128     // Update founderaddr
2129     function founderUpdate(address _newFounder) public onlyAuthorized {
2130        founderaddr = _newFounder;
2131     }
2132     
2133     // Update Reward Per Block
2134     function rewardUpdate(uint256 _newReward) public onlyAuthorized {
2135        REWARD_PER_BLOCK = _newReward;
2136     }
2137     
2138     // Update Rewards Mulitplier Array
2139     function rewardMulUpdate(uint256[] memory _newMulReward) public onlyAuthorized {
2140        REWARD_MULTIPLIER = _newMulReward;
2141     }
2142     
2143     // Update % lock for general users
2144     function lockUpdate(uint _newlock) public onlyAuthorized {
2145        PERCENT_LOCK_BONUS_REWARD = _newlock;
2146     }
2147     
2148     // Update % lock for dev
2149     function lockdevUpdate(uint _newdevlock) public onlyAuthorized {
2150        PERCENT_FOR_DEV = _newdevlock;
2151     }
2152     
2153     // Update % lock for LP
2154     function locklpUpdate(uint _newlplock) public onlyAuthorized {
2155        PERCENT_FOR_LP = _newlplock;
2156     }
2157     
2158     // Update % lock for COM
2159     function lockcomUpdate(uint _newcomlock) public onlyAuthorized {
2160        PERCENT_FOR_COM = _newcomlock;
2161     }
2162     
2163     // Update % lock for Founders
2164     function lockfounderUpdate(uint _newfounderlock) public onlyAuthorized {
2165        PERCENT_FOR_FOUNDERS = _newfounderlock;
2166     }
2167     
2168     // Update START_BLOCK
2169     function starblockUpdate(uint _newstarblock) public onlyAuthorized {
2170        START_BLOCK = _newstarblock;
2171     }
2172 
2173     function getNewRewardPerBlock(uint256 pid1) public view returns (uint256) {
2174         uint256 multiplier = getMultiplier(block.number -1, block.number);
2175         if (pid1 == 0) {
2176             return multiplier.mul(REWARD_PER_BLOCK);
2177         }
2178         else {
2179             return multiplier
2180                 .mul(REWARD_PER_BLOCK)
2181                 .mul(poolInfo[pid1 - 1].allocPoint)
2182                 .div(totalAllocPoint);
2183         }
2184     }
2185 	
2186 	function userDelta(uint256 _pid) public view returns (uint256) {
2187         UserInfo storage user = userInfo[_pid][msg.sender];
2188 		if (user.lastWithdrawBlock > 0) {
2189 			uint256 estDelta = block.number - user.lastWithdrawBlock;
2190 			return estDelta;
2191 		} else {
2192 		    uint256 estDelta = block.number - user.firstDepositBlock;
2193 			return estDelta;
2194 		}
2195 	}
2196 	
2197 	function reviseWithdraw(uint _pid, address _user, uint256 _block) public onlyAuthorized() {
2198 	   UserInfo storage user = userInfo[_pid][_user];
2199 	   user.lastWithdrawBlock = _block;
2200 	    
2201 	}
2202 	
2203 	function reviseDeposit(uint _pid, address _user, uint256 _block) public onlyAuthorized() {
2204 	   UserInfo storage user = userInfo[_pid][_user];
2205 	   user.firstDepositBlock = _block;
2206 	    
2207 	}
2208 	
2209 	function setStageStarts(uint[] memory _blockStarts) public onlyAuthorized() {
2210         blockDeltaStartStage = _blockStarts;
2211     }
2212     
2213     function setStageEnds(uint[] memory _blockEnds) public onlyAuthorized() {
2214         blockDeltaEndStage = _blockEnds;
2215     }
2216     
2217     function setUserFeeStage(uint[] memory _userFees) public onlyAuthorized() {
2218         userFeeStage = _userFees;
2219     }
2220     
2221     function setDevFeeStage(uint[] memory _devFees) public onlyAuthorized() {
2222         devFeeStage = _devFees;
2223     }
2224     
2225     function setDevDepFee(uint _devDepFees) public onlyAuthorized() {
2226         devDepFee = _devDepFees;
2227     }
2228     
2229     function setUserDepFee(uint _usrDepFees) public onlyAuthorized() {
2230         userDepFee = _usrDepFees;
2231     }
2232 
2233 
2234 
2235 }