1 pragma solidity ^0.8.0;
2 // SPDX-License-Identifier: MIT
3 
4 
5 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
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
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     
77     event Mint(address indexed to, uint256 value);
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/IERC20Metadata.sol)
87 /**
88  * @dev Interface for the optional metadata functions from the ERC20 standard.
89  *
90  * _Available since v4.1._
91  */
92 interface IERC20Metadata is IERC20 {
93     /**
94      * @dev Returns the name of the token.
95      */
96     function name() external view returns (string memory);
97 
98     /**
99      * @dev Returns the symbol of the token.
100      */
101     function symbol() external view returns (string memory);
102 
103     /**
104      * @dev Returns the decimals places of the token.
105      */
106     function decimals() external view returns (uint8);
107 }
108 
109 
110 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
111 /**
112  * @dev Provides information about the current execution context, including the
113  * sender of the transaction and its data. While these are generally available
114  * via msg.sender and msg.data, they should not be accessed in such a direct
115  * manner, since when dealing with meta-transactions the account sending and
116  * paying for execution may not be the actual sender (as far as an application
117  * is concerned).
118  *
119  * This contract is only required for intermediate, library-like contracts.
120  */
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address) {
123         return msg.sender;
124     }
125 }
126 
127 
128 // OpenZeppelin Contracts v4.3.2 (token/ERC20/ERC20.sol)
129 /**
130  * @dev Implementation of the {IERC20} interface.
131  *
132  * This implementation is agnostic to the way tokens are created. This means
133  * that a supply mechanism has to be added in a derived contract using {_mint}.
134  * For a generic mechanism see {ERC20PresetMinterPauser}.
135  *
136  * TIP: For a detailed writeup see our guide
137  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
138  * to implement supply mechanisms].
139  *
140  * We have followed general OpenZeppelin Contracts guidelines: functions revert
141  * instead returning `false` on failure. This behavior is nonetheless
142  * conventional and does not conflict with the expectations of ERC20
143  * applications.
144  *
145  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
146  * This allows applications to reconstruct the allowance for all accounts just
147  * by listening to said events. Other implementations of the EIP may not emit
148  * these events, as it isn't required by the specification.
149  *
150  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
151  * functions have been added to mitigate the well-known issues around setting
152  * allowances. See {IERC20-approve}.
153  */
154 contract ERC20 is Context, IERC20, IERC20Metadata {
155     mapping(address => uint256) private _balances;
156 
157     mapping(address => mapping(address => uint256)) private _allowances;
158 
159     uint256 private _totalSupply;
160 
161     string private _name;
162     string private _symbol;
163 
164     /**
165      * @dev Sets the values for {name} and {symbol}.
166      *
167      * The default value of {decimals} is 18. To select a different value for
168      * {decimals} you should overload it.
169      *
170      * All two of these values are immutable: they can only be set once during
171      * construction.
172      */
173     constructor(string memory name_, string memory symbol_) {
174         _name = name_;
175         _symbol = symbol_;
176     }
177 
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() public view virtual override returns (string memory) {
182         return _name;
183     }
184 
185     /**
186      * @dev Returns the symbol of the token, usually a shorter version of the
187      * name.
188      */
189     function symbol() public view virtual override returns (string memory) {
190         return _symbol;
191     }
192 
193     /**
194      * @dev Returns the number of decimals used to get its user representation.
195      * For example, if `decimals` equals `2`, a balance of `505` tokens should
196      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
197      *
198      * Tokens usually opt for a value of 18, imitating the relationship between
199      * Ether and Wei. This is the value {ERC20} uses, unless this function is
200      * overridden;
201      *
202      * NOTE: This information is only used for _display_ purposes: it in
203      * no way affects any of the arithmetic of the contract, including
204      * {IERC20-balanceOf} and {IERC20-transfer}.
205      */
206     function decimals() public view virtual override returns (uint8) {
207         return 18;
208     }
209 
210     /**
211      * @dev See {IERC20-totalSupply}.
212      */
213     function totalSupply() public view virtual override returns (uint256) {
214         return _totalSupply;
215     }
216 
217     /**
218      * @dev See {IERC20-balanceOf}.
219      */
220     function balanceOf(address account) public view virtual override returns (uint256) {
221         return _balances[account];
222     }
223 
224     /**
225      * @dev See {IERC20-transfer}.
226      *
227      * Requirements:
228      *
229      * - `recipient` cannot be the zero address.
230      * - the caller must have a balance of at least `amount`.
231      */
232     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
233         _transfer(_msgSender(), recipient, amount);
234         return true;
235     }
236 
237     /**
238      * @dev See {IERC20-allowance}.
239      */
240     function allowance(address owner, address spender) public view virtual override returns (uint256) {
241         return _allowances[owner][spender];
242     }
243 
244     /**
245      * @dev See {IERC20-approve}.
246      *
247      * Requirements:
248      *
249      * - `spender` cannot be the zero address.
250      */
251     function approve(address spender, uint256 amount) public virtual override returns (bool) {
252         _approve(_msgSender(), spender, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-transferFrom}.
258      *
259      * Emits an {Approval} event indicating the updated allowance. This is not
260      * required by the EIP. See the note at the beginning of {ERC20}.
261      *
262      * Requirements:
263      *
264      * - `sender` and `recipient` cannot be the zero address.
265      * - `sender` must have a balance of at least `amount`.
266      * - the caller must have allowance for ``sender``'s tokens of at least
267      * `amount`.
268      */
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) public virtual override returns (bool) {
274         _transfer(sender, recipient, amount);
275 
276         uint256 currentAllowance = _allowances[sender][_msgSender()];
277         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
278         unchecked {
279             _approve(sender, _msgSender(), currentAllowance - amount);
280         }
281 
282         return true;
283     }
284 
285     /**
286      * @dev Atomically increases the allowance granted to `spender` by the caller.
287      *
288      * This is an alternative to {approve} that can be used as a mitigation for
289      * problems described in {IERC20-approve}.
290      *
291      * Emits an {Approval} event indicating the updated allowance.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      */
297     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
298         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
299         return true;
300     }
301 
302     /**
303      * @dev Atomically decreases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      * - `spender` must have allowance for the caller of at least
314      * `subtractedValue`.
315      */
316     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
317         uint256 currentAllowance = _allowances[_msgSender()][spender];
318         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
319         unchecked {
320             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
321         }
322 
323         return true;
324     }
325 
326     /**
327      * @dev Moves `amount` of tokens from `sender` to `recipient`.
328      *
329      * This internal function is equivalent to {transfer}, and can be used to
330      * e.g. implement automatic token fees, slashing mechanisms, etc.
331      *
332      * Emits a {Transfer} event.
333      *
334      * Requirements:
335      *
336      * - `sender` cannot be the zero address.
337      * - `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `amount`.
339      */
340     function _transfer(
341         address sender,
342         address recipient,
343         uint256 amount
344     ) internal virtual {
345         require(sender != address(0), "ERC20: transfer from the zero address");
346         require(recipient != address(0), "ERC20: transfer to the zero address");
347 
348         _beforeTokenTransfer(sender, recipient, amount);
349 
350         uint256 senderBalance = _balances[sender];
351         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
352         unchecked {
353             _balances[sender] = senderBalance - amount;
354         }
355         _balances[recipient] += amount;
356 
357         emit Transfer(sender, recipient, amount);
358 
359         _afterTokenTransfer(sender, recipient, amount);
360     }
361 
362     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
363      * the total supply.
364      *
365      * Emits a {Transfer} event with `from` set to the zero address.
366      *
367      * Requirements:
368      *
369      * - `account` cannot be the zero address.
370      */
371     function _mint(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: mint to the zero address");
373 
374         _beforeTokenTransfer(address(0), account, amount);
375 
376         _totalSupply += amount;
377         _balances[account] += amount;
378         
379         emit Mint(account, amount);
380         emit Transfer(address(0), account, amount);
381 
382         _afterTokenTransfer(address(0), account, amount);
383     }
384 
385     /**
386      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
387      *
388      * This internal function is equivalent to `approve`, and can be used to
389      * e.g. set automatic allowances for certain subsystems, etc.
390      *
391      * Emits an {Approval} event.
392      *
393      * Requirements:
394      *
395      * - `owner` cannot be the zero address.
396      * - `spender` cannot be the zero address.
397      */
398     function _approve(
399         address owner,
400         address spender,
401         uint256 amount
402     ) internal virtual {
403         require(owner != address(0), "ERC20: approve from the zero address");
404         require(spender != address(0), "ERC20: approve to the zero address");
405 
406         _allowances[owner][spender] = amount;
407         emit Approval(owner, spender, amount);
408     }
409 
410     /**
411      * @dev Hook that is called before any transfer of tokens. This includes
412      * minting and burning.
413      *
414      * Calling conditions:
415      *
416      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
417      * will be transferred to `to`.
418      * - when `from` is zero, `amount` tokens will be minted for `to`.
419      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
420      * - `from` and `to` are never both zero.
421      *
422      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
423      */
424     function _beforeTokenTransfer(
425         address from,
426         address to,
427         uint256 amount
428     ) internal virtual {}
429 
430     /**
431      * @dev Hook that is called after any transfer of tokens. This includes
432      * minting and burning.
433      *
434      * Calling conditions:
435      *
436      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
437      * has been transferred to `to`.
438      * - when `from` is zero, `amount` tokens have been minted for `to`.
439      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
440      * - `from` and `to` are never both zero.
441      *
442      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
443      */
444     function _afterTokenTransfer(
445         address from,
446         address to,
447         uint256 amount
448     ) internal virtual {}
449 }
450 
451 
452 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/ERC20Capped.sol)
453 /**
454  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
455  */
456 abstract contract ERC20Capped is ERC20 {
457     uint256 private immutable _cap;
458 
459     /**
460      * @dev Sets the value of the `cap`. This value is immutable, it can only be
461      * set once during construction.
462      */
463     constructor(uint256 cap_) {
464         require(cap_ > 0, "ERC20Capped: cap is 0");
465         _cap = cap_;
466     }
467 
468     /**
469      * @dev Returns the cap on the token's total supply.
470      */
471     function cap() public view virtual returns (uint256) {
472         return _cap;
473     }
474 
475     /**
476      * @dev See {ERC20-_mint}.
477      */
478     function _mint(address account, uint256 amount) internal virtual override {
479         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
480         super._mint(account, amount);
481     }
482 }
483 
484 
485 // OpenZeppelin Contracts v4.3.2 (access/Ownable.sol)
486 /**
487  * @dev Contract module which provides a basic access control mechanism, where
488  * there is an account (an owner) that can be granted exclusive access to
489  * specific functions.
490  *
491  * By default, the owner account will be the one that deploys the contract. This
492  * can later be changed with {transferOwnership}.
493  *
494  * This module is used through inheritance. It will make available the modifier
495  * `onlyOwner`, which can be applied to your functions to restrict their use to
496  * the owner.
497  */
498 abstract contract Ownable is Context {
499     address private _owner;
500 
501     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
502 
503     /**
504      * @dev Initializes the contract setting the deployer as the initial owner.
505      */
506     constructor() {
507         _transferOwnership(_msgSender());
508     }
509 
510     /**
511      * @dev Returns the address of the current owner.
512      */
513     function owner() public view virtual returns (address) {
514         return _owner;
515     }
516 
517     /**
518      * @dev Throws if called by any account other than the owner.
519      */
520     modifier onlyOwner() {
521         require(owner() == _msgSender(), "Ownable: caller is not the owner");
522         _;
523     }
524 
525     /**
526      * @dev Leaves the contract without owner. It will not be possible to call
527      * `onlyOwner` functions anymore. Can only be called by the current owner.
528      *
529      * NOTE: Renouncing ownership will leave the contract without an owner,
530      * thereby removing any functionality that is only available to the owner.
531      */
532     function renounceOwnership() public virtual onlyOwner {
533         _transferOwnership(address(0));
534     }
535 
536     /**
537      * @dev Transfers ownership of the contract to a new account (`newOwner`).
538      * Can only be called by the current owner.
539      */
540     function transferOwnership(address newOwner) public virtual onlyOwner {
541         require(newOwner != address(0), "Ownable: new owner is the zero address");
542         _transferOwnership(newOwner);
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Internal function without access restriction.
548      */
549     function _transferOwnership(address newOwner) internal virtual {
550         address oldOwner = _owner;
551         _owner = newOwner;
552         emit OwnershipTransferred(oldOwner, newOwner);
553     }
554 }
555 
556 
557 contract Membership is Context {
558     address private owner;
559     event MembershipChanged(address indexed owner, uint256 level);
560     event OwnerTransferred(address indexed preOwner, address indexed newOwner);
561 
562     mapping(address => uint256) internal membership;
563 
564     constructor() {
565         owner = _msgSender();
566         setMembership(_msgSender(), 1);
567     }
568 
569     function transferOwner(address newOwner) public onlyOwner {
570         address preOwner = owner;
571         setMembership(newOwner, 1);
572         setMembership(preOwner, 0);
573         owner = newOwner;
574         emit OwnerTransferred(preOwner, newOwner);
575     }
576 
577     function setMembership(address key, uint256 level) public onlyOwner {
578         membership[key] = level;
579         emit MembershipChanged(key, level);
580     }
581 
582     modifier onlyOwner() {
583         require(isOwner(), "Membership : caller is not the owner");
584         _;
585     }
586 
587     function isOwner() public view returns (bool) {
588         return _msgSender() == owner;
589     }
590 
591 
592     modifier onlyAdmin() {
593         require(isAdmin(), "Membership : caller is not a admin");
594         _;
595     }
596 
597     function isAdmin() public view returns (bool) {
598         return membership[_msgSender()] == 1;
599     }
600 
601     modifier onlyClaimant() {
602         require(isClaimant(), "Memberhsip : caller is not a claimant");
603         _;
604     }
605 
606     function isClaimant() public view returns (bool) {
607         return membership[_msgSender()] == 11;
608     }
609     
610     function getMembership(address account) public view returns (uint256){
611         return membership[account];
612     }
613 }
614 
615 
616 contract LOKA is ERC20Capped, Ownable {
617     constructor(
618         string memory name,
619         string memory symbol,
620         uint256 cap
621     ) ERC20(name, symbol) ERC20Capped(cap) {
622         
623     }
624 
625     function mint(address addr, uint256 amount) public onlyOwner {
626         _mint(addr, amount);
627     }
628     
629     function retain(address addr, uint256 amount, uint256 strtd, uint256 trm, uint256 tms) public onlyOwner {
630         _mint(addr, amount);
631         Claimant(addr).initialize(strtd, trm, tms);
632     }
633 
634     mapping(address => uint256) private _allocates;
635     function _allocate(address addr, uint256 amount) internal virtual {
636         _allocates[addr] += amount;
637     }
638     function allocate(address addr, uint256 amount) public onlyOwner {
639         _allocate(addr, amount);
640     }
641     function allocateOf(address account) public view virtual returns (uint256) {
642         return _allocates[account];
643     }
644     function take(address addr, uint256 amount) public {
645         address sender = _msgSender();
646         require(_allocates[sender]>=amount, "TokenVesting: No takable amount");
647         _allocates[sender] -= amount;
648         _mint(addr, amount);
649     }
650 }
651 
652 
653 contract Claimant is Membership {
654 
655     LOKA public token;
656 
657     uint256 public started;
658     uint256 public claimed;
659     uint256 public term;
660     uint256 public times;
661 
662     constructor(LOKA _token) Membership() {
663         token = _token;
664     }
665     
666     function initialize(uint256 strtd, uint256 trm, uint256 tms) public onlyAdmin {
667         started = strtd;
668         term = trm;
669         times = tms;
670     }
671 
672     function register(address m) public onlyAdmin {
673         setMembership(m, 11);
674     }
675 
676     function claimable() public view returns (uint256){
677         require(block.timestamp > started, "TokenVesting: Not claimable");
678         uint256 sequence = (block.timestamp - started) / term;
679         ++sequence;
680         if(sequence>times)
681             sequence = times;
682         uint256 unlocked = sequence * (totalAmount() / times);
683         return unlocked - claimed;
684     }
685 
686     function claim() public onlyClaimant {
687         uint256 amount = claimable();
688         require(amount > 0, "TokenVesting: No claimable amount");
689         claimed += amount;
690         token.transfer(_msgSender(), amount);
691     }
692 
693     function totalClaimed() public view returns (uint256) {
694         return claimed;
695     }
696 
697     function totalAmount() public view returns (uint256) {
698         return token.balanceOf(address(this))+claimed;
699     }
700 
701     function getStarted() public view returns (uint256) {
702         return started;
703     }
704 
705     function getTerm() public view returns (uint256) {
706         return term;
707     }
708     function getBlockTimestamp() public view returns (uint256) {
709         return block.timestamp;
710     }
711 }