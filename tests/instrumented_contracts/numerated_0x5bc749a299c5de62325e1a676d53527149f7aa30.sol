1 pragma solidity ^0.8.19;
2 // SPDX-License-Identifier: MIT
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
97 
98 pragma solidity ^0.8.19;
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP.
102  */
103 interface IERC20 {
104     /**
105      * @dev Returns the amount of tokens in existence.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address recipient, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Returns the remaining number of tokens that `spender` will be
125      * allowed to spend on behalf of `owner` through {transferFrom}. This is
126      * zero by default.
127      *
128      * This value changes when {approve} or {transferFrom} are called.
129      */
130     function allowance(address owner, address spender) external view returns (uint256);
131 
132     /**
133      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * IMPORTANT: Beware that changing an allowance with this method brings the risk
138      * that someone may use both the old and the new allowance by unfortunate
139      * transaction ordering. One possible solution to mitigate this race
140      * condition is to first reduce the spender's allowance to 0 and set the
141      * desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      *
144      * Emits an {Approval} event.
145      */
146     function approve(address spender, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Moves `amount` tokens from `sender` to `recipient` using the
150      * allowance mechanism. `amount` is then deducted from the caller's
151      * allowance.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
179 
180 pragma solidity ^0.8.19;
181 
182 /**
183  * @dev Interface for the optional metadata functions from the ERC20 standard.
184  *
185  * _Available since v4.1._
186  */
187 interface IERC20Metadata is IERC20 {
188     /**
189      * @dev Returns the name of the token.
190      */
191     function name() external view returns (string memory);
192 
193     /**
194      * @dev Returns the symbol of the token.
195      */
196     function symbol() external view returns (string memory);
197 
198     /**
199      * @dev Returns the decimals places of the token.
200      */
201     function decimals() external view returns (uint8);
202 }
203 
204 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
205 
206 /**
207  * @dev Implementation of the {IERC20} interface.
208  *
209  * This implementation is agnostic to the way tokens are created. This means
210  * that a supply mechanism has to be added in a derived contract using {_mint}.
211  * For a generic mechanism see {ERC20PresetMinterPauser}.
212  *
213  * TIP: For a detailed writeup see our guide
214  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
215  * to implement supply mechanisms].
216  *
217  * We have followed general OpenZeppelin Contracts guidelines: functions revert
218  * instead returning `false` on failure. This behavior is nonetheless
219  * conventional and does not conflict with the expectations of ERC20
220  * applications.
221  *
222  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
223  * This allows applications to reconstruct the allowance for all accounts just
224  * by listening to said events. Other implementations of the EIP may not emit
225  * these events, as it isn't required by the specification.
226  *
227  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
228  * functions have been added to mitigate the well-known issues around setting
229  * allowances. See {IERC20-approve}.
230  */
231 contract ERC20 is Context, IERC20, IERC20Metadata {
232     mapping(address => uint256) private _balances;
233 
234     mapping(address => mapping(address => uint256)) private _allowances;
235 
236     uint256 private _totalSupply;
237 
238     string private _name;
239     string private _symbol;
240 
241     /**
242      * @dev Sets the values for {name} and {symbol}.
243      *
244      * The default value of {decimals} is 18. To select a different value for
245      * {decimals} you should overload it.
246      *
247      * All two of these values are immutable: they can only be set once during
248      * construction.
249      */
250     constructor(string memory name_, string memory symbol_) {
251         _name = name_;
252         _symbol = symbol_;
253     }
254 
255     /**
256      * @dev Returns the name of the token.
257      */
258     function name() public view virtual override returns (string memory) {
259         return _name;
260     }
261 
262     /**
263      * @dev Returns the symbol of the token, usually a shorter version of the
264      * name.
265      */
266     function symbol() public view virtual override returns (string memory) {
267         return _symbol;
268     }
269 
270     /**
271      * @dev Returns the number of decimals used to get its user representation.
272      * For example, if `decimals` equals `2`, a balance of `505` tokens should
273      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
274      *
275      * Tokens usually opt for a value of 18, imitating the relationship between
276      * Ether and Wei. This is the value {ERC20} uses, unless this function is
277      * overridden;
278      *
279      * NOTE: This information is only used for _display_ purposes: it in
280      * no way affects any of the arithmetic of the contract, including
281      * {IERC20-balanceOf} and {IERC20-transfer}.
282      */
283     function decimals() public view virtual override returns (uint8) {
284         return 18;
285     }
286 
287     /**
288      * @dev See {IERC20-totalSupply}.
289      */
290     function totalSupply() public view virtual override returns (uint256) {
291         return _totalSupply;
292     }
293 
294     /**
295      * @dev See {IERC20-balanceOf}.
296      */
297     function balanceOf(address account) public view virtual override returns (uint256) {
298         return _balances[account];
299     }
300 
301     /**
302      * @dev See {IERC20-transfer}.
303      *
304      * Requirements:
305      *
306      * - `recipient` cannot be the zero address.
307      * - the caller must have a balance of at least `amount`.
308      */
309     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
310         _transfer(_msgSender(), recipient, amount);
311         return true;
312     }
313 
314     /**
315      * @dev See {IERC20-allowance}.
316      */
317     function allowance(address owner, address spender) public view virtual override returns (uint256) {
318         return _allowances[owner][spender];
319     }
320 
321     /**
322      * @dev See {IERC20-approve}.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      */
328     function approve(address spender, uint256 amount) public virtual override returns (bool) {
329         _approve(_msgSender(), spender, amount);
330         return true;
331     }
332 
333     /**
334      * @dev See {IERC20-transferFrom}.
335      *
336      * Emits an {Approval} event indicating the updated allowance. This is not
337      * required by the EIP. See the note at the beginning of {ERC20}.
338      *
339      * Requirements:
340      *
341      * - `sender` and `recipient` cannot be the zero address.
342      * - `sender` must have a balance of at least `amount`.
343      * - the caller must have allowance for ``sender``'s tokens of at least
344      * `amount`.
345      */
346     function transferFrom(
347         address sender,
348         address recipient,
349         uint256 amount
350     ) public virtual override returns (bool) {
351         _transfer(sender, recipient, amount);
352 
353         uint256 currentAllowance = _allowances[sender][_msgSender()];
354         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
355         unchecked {
356             _approve(sender, _msgSender(), currentAllowance - amount);
357         }
358 
359         return true;
360     }
361 
362     /**
363      * @dev Atomically increases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
375         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
376         return true;
377     }
378 
379     /**
380      * @dev Atomically decreases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to {approve} that can be used as a mitigation for
383      * problems described in {IERC20-approve}.
384      *
385      * Emits an {Approval} event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      * - `spender` must have allowance for the caller of at least
391      * `subtractedValue`.
392      */
393     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
394         uint256 currentAllowance = _allowances[_msgSender()][spender];
395         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
396         unchecked {
397             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
398         }
399 
400         return true;
401     }
402 
403     /**
404      * @dev Moves `amount` of tokens from `sender` to `recipient`.
405      *
406      * This internal function is equivalent to {transfer}, and can be used to
407      * e.g. implement automatic token fees, slashing mechanisms, etc.
408      *
409      * Emits a {Transfer} event.
410      *
411      * Requirements:
412      *
413      * - `sender` cannot be the zero address.
414      * - `recipient` cannot be the zero address.
415      * - `sender` must have a balance of at least `amount`.
416      */
417     function _transfer(
418         address sender,
419         address recipient,
420         uint256 amount
421     ) internal virtual {
422         require(sender != address(0), "ERC20: transfer from the zero address");
423         require(recipient != address(0), "ERC20: transfer to the zero address");
424 
425         _beforeTokenTransfer(sender, recipient, amount);
426 
427         uint256 senderBalance = _balances[sender];
428         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
429         unchecked {
430             _balances[sender] = senderBalance - amount;
431         }
432         _balances[recipient] += amount;
433 
434         emit Transfer(sender, recipient, amount);
435 
436         _afterTokenTransfer(sender, recipient, amount);
437     }
438 
439     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
440      * the total supply.
441      *
442      * Emits a {Transfer} event with `from` set to the zero address.
443      *
444      * Requirements:
445      *
446      * - `account` cannot be the zero address.
447      */
448     function _mint(address account, uint256 amount) internal virtual {
449         require(account != address(0), "ERC20: mint to the zero address");
450 
451         _beforeTokenTransfer(address(0), account, amount);
452 
453         _totalSupply += amount;
454         _balances[account] += amount;
455         emit Transfer(address(0), account, amount);
456 
457         _afterTokenTransfer(address(0), account, amount);
458     }
459 
460     /**
461      * @dev Destroys `amount` tokens from `account`, reducing the
462      * total supply.
463      *
464      * Emits a {Transfer} event with `to` set to the zero address.
465      *
466      * Requirements:
467      *
468      * - `account` cannot be the zero address.
469      * - `account` must have at least `amount` tokens.
470      */
471     function _burn(address account, uint256 amount) internal virtual {
472         require(account != address(0), "ERC20: burn from the zero address");
473 
474         _beforeTokenTransfer(account, address(0), amount);
475 
476         uint256 accountBalance = _balances[account];
477         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
478         unchecked {
479             _balances[account] = accountBalance - amount;
480         }
481         _totalSupply -= amount;
482 
483         emit Transfer(account, address(0), amount);
484 
485         _afterTokenTransfer(account, address(0), amount);
486     }
487 
488     /**
489      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
490      *
491      * This internal function is equivalent to `approve`, and can be used to
492      * e.g. set automatic allowances for certain subsystems, etc.
493      *
494      * Emits an {Approval} event.
495      *
496      * Requirements:
497      *
498      * - `owner` cannot be the zero address.
499      * - `spender` cannot be the zero address.
500      */
501     function _approve(
502         address owner,
503         address spender,
504         uint256 amount
505     ) internal virtual {
506         require(owner != address(0), "ERC20: approve from the zero address");
507         require(spender != address(0), "ERC20: approve to the zero address");
508 
509         _allowances[owner][spender] = amount;
510         emit Approval(owner, spender, amount);
511     }
512 
513     /**
514      * @dev Hook that is called before any transfer of tokens. This includes
515      * minting and burning.
516      *
517      * Calling conditions:
518      *
519      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
520      * will be transferred to `to`.
521      * - when `from` is zero, `amount` tokens will be minted for `to`.
522      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
523      * - `from` and `to` are never both zero.
524      *
525      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
526      */
527     function _beforeTokenTransfer(
528         address from,
529         address to,
530         uint256 amount
531     ) internal virtual {}
532 
533     /**
534      * @dev Hook that is called after any transfer of tokens. This includes
535      * minting and burning.
536      *
537      * Calling conditions:
538      *
539      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
540      * has been transferred to `to`.
541      * - when `from` is zero, `amount` tokens have been minted for `to`.
542      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
543      * - `from` and `to` are never both zero.
544      *
545      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
546      */
547     function _afterTokenTransfer(
548         address from,
549         address to,
550         uint256 amount
551     ) internal virtual {}
552 }
553 
554 // File contracts/STIMMY.sol
555 
556 contract STIMMY is Ownable, ERC20 {
557     string constant _name = "STIMMY";
558     string constant _symbol = "STIMMY";
559     uint8 constant _decimals = 18;
560     address public pair;
561 
562     mapping(address => bool) public blacklists;
563     mapping(address => bool) public tradeExceptions;
564 
565     /** Max buy amount per tx */
566     uint256 public constant MAX_BUY = 137_500_000 ether;
567     /** Number of blocks to count as dead land */
568     uint256 public constant DEADBLOCK_COUNT = 5;
569 
570     /** Deadblock start blocknum */
571     uint256 public deadblockStart;
572     /** Block contracts? */
573     bool private _blockContracts;
574     /** Limit buys? */
575     bool private _limitBuys;
576     /** Crowd control measures? */
577     bool private _unrestricted;
578 
579     /** Developer wallet map with super access */
580     mapping(address => bool) private whitelist;
581     /** Used to watch for sandwiches */
582     mapping(address => uint) private _lastBlockTransfer;
583 
584     /** Amount must be greater than zero */
585     error NoZeroTransfers();
586     /** Not allowed */
587     error NotAllowed();
588     /** Amount exceeds max transaction */
589     error LimitExceeded();
590 
591     constructor(address _airdropAddress, address _marketingAddress, address _developmentAddress) ERC20(_name, _symbol) {
592         // add addresses to exception
593         tradeExceptions[msg.sender] = true;
594         tradeExceptions[_airdropAddress] = true;
595         tradeExceptions[_marketingAddress] = true;
596         tradeExceptions[_developmentAddress] = true;
597 
598         uint256 _totalSupply = 1_234_000_000 * (10 ** _decimals);
599         uint256 _airdropAllocation = (_totalSupply * 500) / 10000;
600         uint256 _marketingAllocation = (_totalSupply * 333) / 10000;
601         uint256 _developmentAllocation = (_totalSupply * 244) / 10000;
602 
603         uint256 _remainingAllocation = _totalSupply - (_airdropAllocation + _marketingAllocation + _developmentAllocation);
604         
605         _mint(msg.sender, _remainingAllocation);  // Mint tokens for the contract deployer
606         
607         // Mint additional tokens for airdrop, marketing, and airdrop addresses
608         _mint(_airdropAddress, _airdropAllocation);
609         _mint(_marketingAddress, _marketingAllocation);
610         _mint(_developmentAddress, _developmentAllocation);
611 
612         _blockContracts = true;
613         _limitBuys = true;
614     }
615 
616     /**
617     * Blacklist an address
618     * @param _address Address to blacklist
619     */
620     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
621         blacklists[_address] = _isBlacklisting;
622     }
623 
624     /**
625     * Sets pair, start trading
626     * @param _pair Uniswap address
627     */
628     function setPair(address _pair) external onlyOwner {
629         deadblockStart = block.number;
630         pair = _pair;
631     }
632 
633     /**
634     * Checks for exception
635     * @param _address Address to blacklist
636     */
637     function _isException(address _address) internal view returns (bool) {
638         return tradeExceptions[_address];
639     }
640 
641     /**
642     * Add address to exception
643     * @param _address Address to exception
644     */
645     function addException(address _address) external onlyOwner {
646         tradeExceptions[_address] = true;
647     }
648 
649     /**
650     * Checks if address is contract
651     * @param _address Address in question
652     * @dev Contract will have codesize
653     */
654     function _isContract(address _address) internal view returns (bool) {
655         uint32 size;
656         assembly {
657             size := extcodesize(_address)
658         }
659         return (size > 0);
660     }
661 
662     /**
663     * Checks if address has inhuman reflexes or if it's a contract
664     * @param _address Address in question
665     */
666     function _checkIfBot(address _address) internal view returns (bool) {
667         return (block.number < DEADBLOCK_COUNT + deadblockStart || _isContract(_address)) && !_isException(_address);
668     }
669 
670     /**
671     * Sets contract blocker
672     * @param _val Should we block contracts?
673     */
674     function setBlockContracts(bool _val) external onlyOwner {
675         _blockContracts = _val;
676     }
677 
678     /**
679     * Sets buy limiter
680     * @param _val Limited?
681     */
682     function setLimitBuys(bool _val) external onlyOwner {
683         _limitBuys = _val;
684     }
685 
686     /**
687     * Add or remove restrictions
688     */
689     function setRestrictions(bool _val) external onlyOwner {
690         _unrestricted = _val;
691     }
692 
693     /**
694     * @dev Hook that is called before any transfer of tokens. This includes
695     * minting and burning.
696     *
697     * Checks:
698     * - transfer amount is non-zero
699     * - address is not blacklisted.
700     * - check if trade started, only after adding pair
701     * - buy/sell are not executed during the same block to help alleviate sandwiches
702     * - buy amount does not exceed max buy during limited period
703     * - check for bots to alleviate snipes
704     */
705 
706     function _beforeTokenTransfer(
707         address from,
708         address to,
709         uint256 amount
710     ) override internal virtual {
711         if (amount == 0) { revert NoZeroTransfers(); }
712 
713         super._beforeTokenTransfer(from, to, amount);
714 
715         if (_unrestricted) { return; }
716 
717         require(!blacklists[to] && !blacklists[from], "Blacklisted");
718 
719         if (pair == address(0)) {
720             bool isAllowed = _isException(from) || _isException(to);
721             require(isAllowed, "Trade Not Started");
722             return;
723         }
724 
725         // Watch for sandwich
726         if (block.number == _lastBlockTransfer[from] || block.number == _lastBlockTransfer[to]) {
727             revert NotAllowed();
728         }
729 
730         bool isBuy = (from == pair);
731         bool isSell = (to == pair);
732 
733         if (isBuy) {
734             // Watch for bots
735             if (_blockContracts && _checkIfBot(to)) { revert NotAllowed(); }
736             // Watch for buys exceeding max during limited period
737             if (_limitBuys && amount > MAX_BUY) { revert LimitExceeded(); }
738             _lastBlockTransfer[to] = block.number;
739         } else if (isSell) {
740             _lastBlockTransfer[from] = block.number;
741         }
742     }
743 
744     function burn(uint256 value) external {
745         _burn(msg.sender, value);
746     }
747 }