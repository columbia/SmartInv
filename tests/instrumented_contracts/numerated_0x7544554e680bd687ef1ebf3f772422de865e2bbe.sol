1 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.2
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
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
84 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.2
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  *
91  * _Available since v4.1._
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 
111 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Provides information about the current execution context, including the
117  * sender of the transaction and its data. While these are generally available
118  * via msg.sender and msg.data, they should not be accessed in such a direct
119  * manner, since when dealing with meta-transactions the account sending and
120  * paying for execution may not be the actual sender (as far as an application
121  * is concerned).
122  *
123  * This contract is only required for intermediate, library-like contracts.
124  */
125 abstract contract Context {
126     function _msgSender() internal view virtual returns (address) {
127         return msg.sender;
128     }
129 
130     function _msgData() internal view virtual returns (bytes calldata) {
131         return msg.data;
132     }
133 }
134 
135 
136 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.2
137 
138 pragma solidity ^0.8.0;
139 
140 
141 
142 /**
143  * @dev Implementation of the {IERC20} interface.
144  *
145  * This implementation is agnostic to the way tokens are created. This means
146  * that a supply mechanism has to be added in a derived contract using {_mint}.
147  * For a generic mechanism see {ERC20PresetMinterPauser}.
148  *
149  * TIP: For a detailed writeup see our guide
150  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
151  * to implement supply mechanisms].
152  *
153  * We have followed general OpenZeppelin Contracts guidelines: functions revert
154  * instead returning `false` on failure. This behavior is nonetheless
155  * conventional and does not conflict with the expectations of ERC20
156  * applications.
157  *
158  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
159  * This allows applications to reconstruct the allowance for all accounts just
160  * by listening to said events. Other implementations of the EIP may not emit
161  * these events, as it isn't required by the specification.
162  *
163  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
164  * functions have been added to mitigate the well-known issues around setting
165  * allowances. See {IERC20-approve}.
166  */
167 contract ERC20 is Context, IERC20, IERC20Metadata {
168     mapping(address => uint256) private _balances;
169 
170     mapping(address => mapping(address => uint256)) private _allowances;
171 
172     uint256 private _totalSupply;
173 
174     string private _name;
175     string private _symbol;
176 
177     /**
178      * @dev Sets the values for {name} and {symbol}.
179      *
180      * The default value of {decimals} is 18. To select a different value for
181      * {decimals} you should overload it.
182      *
183      * All two of these values are immutable: they can only be set once during
184      * construction.
185      */
186     constructor(string memory name_, string memory symbol_) {
187         _name = name_;
188         _symbol = symbol_;
189     }
190 
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() public view virtual override returns (string memory) {
195         return _name;
196     }
197 
198     /**
199      * @dev Returns the symbol of the token, usually a shorter version of the
200      * name.
201      */
202     function symbol() public view virtual override returns (string memory) {
203         return _symbol;
204     }
205 
206     /**
207      * @dev Returns the number of decimals used to get its user representation.
208      * For example, if `decimals` equals `2`, a balance of `505` tokens should
209      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
210      *
211      * Tokens usually opt for a value of 18, imitating the relationship between
212      * Ether and Wei. This is the value {ERC20} uses, unless this function is
213      * overridden;
214      *
215      * NOTE: This information is only used for _display_ purposes: it in
216      * no way affects any of the arithmetic of the contract, including
217      * {IERC20-balanceOf} and {IERC20-transfer}.
218      */
219     function decimals() public view virtual override returns (uint8) {
220         return 18;
221     }
222 
223     /**
224      * @dev See {IERC20-totalSupply}.
225      */
226     function totalSupply() public view virtual override returns (uint256) {
227         return _totalSupply;
228     }
229 
230     /**
231      * @dev See {IERC20-balanceOf}.
232      */
233     function balanceOf(address account) public view virtual override returns (uint256) {
234         return _balances[account];
235     }
236 
237     /**
238      * @dev See {IERC20-transfer}.
239      *
240      * Requirements:
241      *
242      * - `recipient` cannot be the zero address.
243      * - the caller must have a balance of at least `amount`.
244      */
245     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
246         _transfer(_msgSender(), recipient, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-allowance}.
252      */
253     function allowance(address owner, address spender) public view virtual override returns (uint256) {
254         return _allowances[owner][spender];
255     }
256 
257     /**
258      * @dev See {IERC20-approve}.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      */
264     function approve(address spender, uint256 amount) public virtual override returns (bool) {
265         _approve(_msgSender(), spender, amount);
266         return true;
267     }
268 
269     /**
270      * @dev See {IERC20-transferFrom}.
271      *
272      * Emits an {Approval} event indicating the updated allowance. This is not
273      * required by the EIP. See the note at the beginning of {ERC20}.
274      *
275      * Requirements:
276      *
277      * - `sender` and `recipient` cannot be the zero address.
278      * - `sender` must have a balance of at least `amount`.
279      * - the caller must have allowance for ``sender``'s tokens of at least
280      * `amount`.
281      */
282     function transferFrom(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) public virtual override returns (bool) {
287         _transfer(sender, recipient, amount);
288 
289         uint256 currentAllowance = _allowances[sender][_msgSender()];
290         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
291         unchecked {
292             _approve(sender, _msgSender(), currentAllowance - amount);
293         }
294 
295         return true;
296     }
297 
298     /**
299      * @dev Atomically increases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to {approve} that can be used as a mitigation for
302      * problems described in {IERC20-approve}.
303      *
304      * Emits an {Approval} event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
311         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
312         return true;
313     }
314 
315     /**
316      * @dev Atomically decreases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      * - `spender` must have allowance for the caller of at least
327      * `subtractedValue`.
328      */
329     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
330         uint256 currentAllowance = _allowances[_msgSender()][spender];
331         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
332         unchecked {
333             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
334         }
335 
336         return true;
337     }
338 
339     /**
340      * @dev Moves `amount` of tokens from `sender` to `recipient`.
341      *
342      * This internal function is equivalent to {transfer}, and can be used to
343      * e.g. implement automatic token fees, slashing mechanisms, etc.
344      *
345      * Emits a {Transfer} event.
346      *
347      * Requirements:
348      *
349      * - `sender` cannot be the zero address.
350      * - `recipient` cannot be the zero address.
351      * - `sender` must have a balance of at least `amount`.
352      */
353     function _transfer(
354         address sender,
355         address recipient,
356         uint256 amount
357     ) internal virtual {
358         require(sender != address(0), "ERC20: transfer from the zero address");
359         require(recipient != address(0), "ERC20: transfer to the zero address");
360 
361         _beforeTokenTransfer(sender, recipient, amount);
362 
363         uint256 senderBalance = _balances[sender];
364         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
365         unchecked {
366             _balances[sender] = senderBalance - amount;
367         }
368         _balances[recipient] += amount;
369 
370         emit Transfer(sender, recipient, amount);
371 
372         _afterTokenTransfer(sender, recipient, amount);
373     }
374 
375     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
376      * the total supply.
377      *
378      * Emits a {Transfer} event with `from` set to the zero address.
379      *
380      * Requirements:
381      *
382      * - `account` cannot be the zero address.
383      */
384     function _mint(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: mint to the zero address");
386 
387         _beforeTokenTransfer(address(0), account, amount);
388 
389         _totalSupply += amount;
390         _balances[account] += amount;
391         emit Transfer(address(0), account, amount);
392 
393         _afterTokenTransfer(address(0), account, amount);
394     }
395 
396     /**
397      * @dev Destroys `amount` tokens from `account`, reducing the
398      * total supply.
399      *
400      * Emits a {Transfer} event with `to` set to the zero address.
401      *
402      * Requirements:
403      *
404      * - `account` cannot be the zero address.
405      * - `account` must have at least `amount` tokens.
406      */
407     function _burn(address account, uint256 amount) internal virtual {
408         require(account != address(0), "ERC20: burn from the zero address");
409 
410         _beforeTokenTransfer(account, address(0), amount);
411 
412         uint256 accountBalance = _balances[account];
413         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
414         unchecked {
415             _balances[account] = accountBalance - amount;
416         }
417         _totalSupply -= amount;
418 
419         emit Transfer(account, address(0), amount);
420 
421         _afterTokenTransfer(account, address(0), amount);
422     }
423 
424     /**
425      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
426      *
427      * This internal function is equivalent to `approve`, and can be used to
428      * e.g. set automatic allowances for certain subsystems, etc.
429      *
430      * Emits an {Approval} event.
431      *
432      * Requirements:
433      *
434      * - `owner` cannot be the zero address.
435      * - `spender` cannot be the zero address.
436      */
437     function _approve(
438         address owner,
439         address spender,
440         uint256 amount
441     ) internal virtual {
442         require(owner != address(0), "ERC20: approve from the zero address");
443         require(spender != address(0), "ERC20: approve to the zero address");
444 
445         _allowances[owner][spender] = amount;
446         emit Approval(owner, spender, amount);
447     }
448 
449     /**
450      * @dev Hook that is called before any transfer of tokens. This includes
451      * minting and burning.
452      *
453      * Calling conditions:
454      *
455      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
456      * will be transferred to `to`.
457      * - when `from` is zero, `amount` tokens will be minted for `to`.
458      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
459      * - `from` and `to` are never both zero.
460      *
461      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
462      */
463     function _beforeTokenTransfer(
464         address from,
465         address to,
466         uint256 amount
467     ) internal virtual {}
468 
469     /**
470      * @dev Hook that is called after any transfer of tokens. This includes
471      * minting and burning.
472      *
473      * Calling conditions:
474      *
475      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
476      * has been transferred to `to`.
477      * - when `from` is zero, `amount` tokens have been minted for `to`.
478      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
479      * - `from` and `to` are never both zero.
480      *
481      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
482      */
483     function _afterTokenTransfer(
484         address from,
485         address to,
486         uint256 amount
487     ) internal virtual {}
488 }
489 
490 
491 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Contract module which provides a basic access control mechanism, where
497  * there is an account (an owner) that can be granted exclusive access to
498  * specific functions.
499  *
500  * By default, the owner account will be the one that deploys the contract. This
501  * can later be changed with {transferOwnership}.
502  *
503  * This module is used through inheritance. It will make available the modifier
504  * `onlyOwner`, which can be applied to your functions to restrict their use to
505  * the owner.
506  */
507 abstract contract Ownable is Context {
508     address private _owner;
509 
510     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
511 
512     /**
513      * @dev Initializes the contract setting the deployer as the initial owner.
514      */
515     constructor() {
516         _setOwner(_msgSender());
517     }
518 
519     /**
520      * @dev Returns the address of the current owner.
521      */
522     function owner() public view virtual returns (address) {
523         return _owner;
524     }
525 
526     /**
527      * @dev Throws if called by any account other than the owner.
528      */
529     modifier onlyOwner() {
530         require(owner() == _msgSender(), "Ownable: caller is not the owner");
531         _;
532     }
533 
534     /**
535      * @dev Leaves the contract without owner. It will not be possible to call
536      * `onlyOwner` functions anymore. Can only be called by the current owner.
537      *
538      * NOTE: Renouncing ownership will leave the contract without an owner,
539      * thereby removing any functionality that is only available to the owner.
540      */
541     function renounceOwnership() public virtual onlyOwner {
542         _setOwner(address(0));
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Can only be called by the current owner.
548      */
549     function transferOwnership(address newOwner) public virtual onlyOwner {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         _setOwner(newOwner);
552     }
553 
554     function _setOwner(address newOwner) private {
555         address oldOwner = _owner;
556         _owner = newOwner;
557         emit OwnershipTransferred(oldOwner, newOwner);
558     }
559 }
560 
561 
562 // File contracts/interfaces/ICIGAR.sol
563 
564 pragma solidity ^0.8.0;
565 
566 interface ICIGAR {
567     function publicSaleMint(address to, uint256 amountInEther) external payable;
568 
569     function mint(address to, uint256 amount) external;
570 
571     function reserveToDAO(address dao) external;
572 
573     function reserveToLiquidity(address liquidityHandler) external;
574 
575     function reserveToTeam(address team) external;
576 
577     function burn(address from, uint256 amount) external;
578 
579     function addController(address controller) external;
580 
581     function removeController(address controller) external;
582 
583     function flipSaleState() external;
584 
585     function setMintPrice(uint256 _mintPrice) external;
586 
587     function setMaxMint(uint256 _maxMint) external;
588 
589     function lockControllers() external;
590 
591     function withdrawPublicSale() external;
592 }
593 
594 
595 // File contracts/staking/CIGAR.sol
596 
597 // SPDX-License-Identifier: MIT
598 
599 /*
600                                           «∩ⁿ─╖
601                                        ⌐  ╦╠Σ▌╓┴                        .⌐─≈-,
602                                 ≤╠╠╠╫╕╬╦╜              ┌"░░░░░░░░░░≈╖φ░╔╦╬░░Σ╜^
603                                ¼,╠.:╬╬╦╖╔≡p               "╙φ░ ╠╩╚`  ░╩░╟╓╜
604                                    Γ╠▀╬═┘`                         Θ Å░▄
605                       ,,,,,        ┌#                             ]  ▌░░╕
606              ,-─S╜" ,⌐"",`░░φ░░░░S>╫▐                             ╩  ░░░░¼
607             ╙ⁿ═s, <░φ╬░░φù ░░░░░░░░╬╠░░"Zw,                    ,─╓φ░Å░░╩╧w¼
608             ∩²≥┴╝δ»╬░╝░░╩░╓║╙░░░░░░Åφ▄φ░░╦≥░⌠░≥╖,          ,≈"╓φ░░░╬╬░░╕ {⌐\
609             } ▐      ½,#░░░░░╦╚░░╬╜Σ░p╠░░╬╘░░░░╩  ^"¥7"""░"¬╖╠░░░#▒░░░╩ φ╩ ∩
610               Γ      ╬░⌐"╢╙φ░░▒╬╓╓░░░░▄▄╬▄░╬░░Å░░░░╠░╦,φ╠░░░░░░-"╠░╩╩  ê░Γ╠
611              ╘░,,   ╠╬     '░╗Σ╢░░░░░░▀╢▓▒▒╬╬░╦#####≥╨░░░╝╜╙` ,φ╬░░░. é░░╔⌐
612               ▐░ `^Σ░▒╗,   ▐░░░░░ ▒░"╙Σ░╨▀╜╬░▓▓▓▓▓▓▀▀░»φ░N  ╔╬▒░░░"`,╬≥░░╢
613                \  ╠░░░░░░╬#╩╣▄░Γ, ▐░,φ╬▄Å` ░ ```"╚░░░░,╓▄▄▄╬▀▀░╠╙░╔╬░░░ ½"
614                 └ '░░░░░░╦╠ ╟▒M╗▄▄,▄▄▄╗#▒╬▒╠"╙╙╙╙╙╙╢▒▒▓▀▀░░░░░╠╦#░░░░╚,╩
615                   ¼░░░░░░░⌂╦ ▀░░░╚╙░╚▓▒▀░░░½░░╠╜   ╘▀░░░╩╩╩,▄╣╬░░░░░╙╔╩
616                     ╢^╙╨╠░░▄æ,Σ ",╓╥m╬░░░░░░░Θ░φ░φ▄ ╬╬░,▄#▒▀░░░░░≥░░#`
617                       *╓,╙φ░░░░░#░░░░░░░#╬╠╩ ╠╩╚╠╟▓▄╣▒▓╬▓▀░░░░░╩░╓═^
618                           `"╜╧Σ░░░Σ░░░░░░╬▓µ ─"░░░░░░░░░░╜░╬▄≈"
619                                     `"╙╜╜╜╝╩ÅΣM≡,`╙╚░╙╙░╜|  ╙╙╙┴7≥╗
620                                                    `"┴╙¬¬¬┴┴╙╙╙╙""
621 */
622 
623 pragma solidity ^0.8.0;
624 
625 
626 
627 contract CIGAR is ICIGAR, ERC20, Ownable {
628     uint256 public constant DAO_AMOUNT = 600000000000 ether;
629     uint256 public constant LIQUIDITY_AMOUNT = 150000000000 ether;
630     uint256 public constant TEAM_AMOUNT = 450000000000 ether;
631     uint256 public constant PUBLIC_SALE_AMOUNT = 300000000000 ether;
632     uint256 public constant STAKING_AMOUNT = 1500000000000 ether;
633     uint256 public constant TOTAL_AMOUNT = 3000000000000 ether;
634 
635     // price per 1 ether tokens
636     uint256 public mintPrice = .00001 ether;
637     // max number of tokens to mint in one tx in ether
638     uint256 public maxMint = 10000;
639 
640     uint256 public immutable timeStarted;
641     uint256 public teamValueMinted;
642     uint256 public publicSaleMinted;
643     uint256 public totalMinted;
644 
645     bool public saleIsActive;
646 
647     bool public areControllersLocked;
648 
649     // a mapping from an address to whether or not it can mint / burn
650     mapping(address => bool) public controllers;
651 
652     constructor() ERC20("CIGAR", "CIGAR") {
653         timeStarted = block.timestamp;
654     }
655 
656     function publicSaleMint(address to, uint256 amountInEther) external override payable {
657         require(saleIsActive, "Sale is not active");
658         uint256 amountInWei = amountInEther * 1 ether;
659         require(publicSaleMinted + amountInWei <= PUBLIC_SALE_AMOUNT, "The public sale cap has been reached");
660         require(amountInEther <= maxMint, "Amount requested is greater than max mint");
661         require(amountInEther * mintPrice == msg.value, "Given ether does not match price required");
662 
663         _mint(to, amountInWei);
664         publicSaleMinted += amountInWei;
665         totalMinted += amountInWei;
666     }
667 
668     function mint(address to, uint256 amount) external override {
669         require(controllers[msg.sender], "Only controllers are allowed to mint");
670         totalMinted += amount;
671         require(totalMinted <= TOTAL_AMOUNT, "Max CIGAR reached");
672         _mint(to, amount);
673     }
674 
675     function reserveToDAO(address dao) external override onlyOwner {
676         totalMinted += DAO_AMOUNT;
677         _mint(dao, DAO_AMOUNT);
678     }
679 
680     function reserveToLiquidity(address liquidityHandler) external override onlyOwner {
681         totalMinted += LIQUIDITY_AMOUNT;
682         _mint(liquidityHandler, LIQUIDITY_AMOUNT);
683     }
684 
685     function reserveToTeam(address team) external override onlyOwner {
686         require(teamValueMinted < TEAM_AMOUNT, "Team amount has been fully vested");
687         uint256 quarter = 13 * (1 weeks);
688         uint256 quarterNum = (block.timestamp - timeStarted) / quarter;
689         require(quarterNum > 0, "A quarter has not passed");
690         uint256 quarterAmount = TEAM_AMOUNT / 4;
691         require(quarterNum * quarterAmount > teamValueMinted, "Quarter value already minted");
692 
693         uint256 amountToMint = (quarterNum * quarterAmount) - teamValueMinted;
694         totalMinted += amountToMint;
695         teamValueMinted += amountToMint;
696         _mint(team, amountToMint);
697     }
698 
699     function burn(address from, uint256 amount) external override {
700         require(controllers[msg.sender], "Only controllers are allowed to burn");
701         _burn(from, amount);
702     }
703 
704     function addController(address controller) external override onlyOwner {
705         require(!areControllersLocked, 'Controllers have been locked! No more controllers allowed.');
706         controllers[controller] = true;
707     }
708 
709     function removeController(address controller) external override onlyOwner {
710         require(!areControllersLocked, 'Controllers have been locked! No more changes allowed.');
711         controllers[controller] = false;
712     }
713 
714     function flipSaleState() external override onlyOwner {
715         saleIsActive = !saleIsActive;
716     }
717 
718     function setMintPrice(uint256 _mintPrice) external override onlyOwner {
719         mintPrice = _mintPrice;
720     }
721 
722     function setMaxMint(uint256 _maxMint) external override onlyOwner {
723         maxMint = _maxMint;
724     }
725 
726     function lockControllers() external override onlyOwner {
727         areControllersLocked = true;
728     }
729 
730     function withdrawPublicSale() external override onlyOwner {
731         uint balance = address(this).balance;
732         payable(msg.sender).transfer(balance);
733     }
734 }