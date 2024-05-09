1 pragma solidity 0.8.4;
2 
3 /**
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 
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
102 
103 /**
104  * @dev Interface for the optional metadata functions from the ERC20 standard.
105  *
106  * _Available since v4.1._
107  */
108 interface IERC20Metadata is IERC20 {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 
126 
127 /**
128  * @dev Implementation of the {IERC20} interface.
129  *
130  * This implementation is agnostic to the way tokens are created. This means
131  * that a supply mechanism has to be added in a derived contract using {_mint}.
132  * For a generic mechanism see {ERC20PresetMinterPauser}.
133  *
134  * TIP: For a detailed writeup see our guide
135  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
136  * to implement supply mechanisms].
137  *
138  * We have followed general OpenZeppelin Contracts guidelines: functions revert
139  * instead returning `false` on failure. This behavior is nonetheless
140  * conventional and does not conflict with the expectations of ERC20
141  * applications.
142  *
143  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
144  * This allows applications to reconstruct the allowance for all accounts just
145  * by listening to said events. Other implementations of the EIP may not emit
146  * these events, as it isn't required by the specification.
147  *
148  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
149  * functions have been added to mitigate the well-known issues around setting
150  * allowances. See {IERC20-approve}.
151  */
152 contract ERC20 is Context, IERC20, IERC20Metadata {
153     mapping(address => uint256) private _balances;
154 
155     mapping(address => mapping(address => uint256)) private _allowances;
156 
157     uint256 private _totalSupply;
158 
159     string private _name;
160     string private _symbol;
161 
162     /**
163      * @dev Sets the values for {name} and {symbol}.
164      *
165      * The default value of {decimals} is 18. To select a different value for
166      * {decimals} you should overload it.
167      *
168      * All two of these values are immutable: they can only be set once during
169      * construction.
170      */
171     constructor(string memory name_, string memory symbol_) {
172         _name = name_;
173         _symbol = symbol_;
174     }
175 
176     /**
177      * @dev Returns the name of the token.
178      */
179     function name() public view virtual override returns (string memory) {
180         return _name;
181     }
182 
183     /**
184      * @dev Returns the symbol of the token, usually a shorter version of the
185      * name.
186      */
187     function symbol() public view virtual override returns (string memory) {
188         return _symbol;
189     }
190 
191     /**
192      * @dev Returns the number of decimals used to get its user representation.
193      * For example, if `decimals` equals `2`, a balance of `505` tokens should
194      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
195      *
196      * Tokens usually opt for a value of 18, imitating the relationship between
197      * Ether and Wei. This is the value {ERC20} uses, unless this function is
198      * overridden;
199      *
200      * NOTE: This information is only used for _display_ purposes: it in
201      * no way affects any of the arithmetic of the contract, including
202      * {IERC20-balanceOf} and {IERC20-transfer}.
203      */
204     function decimals() public view virtual override returns (uint8) {
205         return 18;
206     }
207 
208     /**
209      * @dev See {IERC20-totalSupply}.
210      */
211     function totalSupply() public view virtual override returns (uint256) {
212         return _totalSupply;
213     }
214 
215     /**
216      * @dev See {IERC20-balanceOf}.
217      */
218     function balanceOf(address account) public view virtual override returns (uint256) {
219         return _balances[account];
220     }
221 
222     /**
223      * @dev See {IERC20-transfer}.
224      *
225      * Requirements:
226      *
227      * - `recipient` cannot be the zero address.
228      * - the caller must have a balance of at least `amount`.
229      */
230     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     /**
236      * @dev See {IERC20-allowance}.
237      */
238     function allowance(address owner, address spender) public view virtual override returns (uint256) {
239         return _allowances[owner][spender];
240     }
241 
242     /**
243      * @dev See {IERC20-approve}.
244      *
245      * Requirements:
246      *
247      * - `spender` cannot be the zero address.
248      */
249     function approve(address spender, uint256 amount) public virtual override returns (bool) {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-transferFrom}.
256      *
257      * Emits an {Approval} event indicating the updated allowance. This is not
258      * required by the EIP. See the note at the beginning of {ERC20}.
259      *
260      * Requirements:
261      *
262      * - `sender` and `recipient` cannot be the zero address.
263      * - `sender` must have a balance of at least `amount`.
264      * - the caller must have allowance for ``sender``'s tokens of at least
265      * `amount`.
266      */
267     function transferFrom(
268         address sender,
269         address recipient,
270         uint256 amount
271     ) public virtual override returns (bool) {
272         _transfer(sender, recipient, amount);
273 
274         uint256 currentAllowance = _allowances[sender][_msgSender()];
275         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
276         unchecked {
277             _approve(sender, _msgSender(), currentAllowance - amount);
278         }
279 
280         return true;
281     }
282 
283     /**
284      * @dev Atomically increases the allowance granted to `spender` by the caller.
285      *
286      * This is an alternative to {approve} that can be used as a mitigation for
287      * problems described in {IERC20-approve}.
288      *
289      * Emits an {Approval} event indicating the updated allowance.
290      *
291      * Requirements:
292      *
293      * - `spender` cannot be the zero address.
294      */
295     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
296         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
297         return true;
298     }
299 
300     /**
301      * @dev Atomically decreases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to {approve} that can be used as a mitigation for
304      * problems described in {IERC20-approve}.
305      *
306      * Emits an {Approval} event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      * - `spender` must have allowance for the caller of at least
312      * `subtractedValue`.
313      */
314     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
315         uint256 currentAllowance = _allowances[_msgSender()][spender];
316         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
317         unchecked {
318             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
319         }
320 
321         return true;
322     }
323 
324     /**
325      * @dev Moves `amount` of tokens from `sender` to `recipient`.
326      *
327      * This internal function is equivalent to {transfer}, and can be used to
328      * e.g. implement automatic token fees, slashing mechanisms, etc.
329      *
330      * Emits a {Transfer} event.
331      *
332      * Requirements:
333      *
334      * - `sender` cannot be the zero address.
335      * - `recipient` cannot be the zero address.
336      * - `sender` must have a balance of at least `amount`.
337      */
338     function _transfer(
339         address sender,
340         address recipient,
341         uint256 amount
342     ) internal virtual {
343         require(sender != address(0), "ERC20: transfer from the zero address");
344         require(recipient != address(0), "ERC20: transfer to the zero address");
345 
346         _beforeTokenTransfer(sender, recipient, amount);
347 
348         uint256 senderBalance = _balances[sender];
349         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
350         unchecked {
351             _balances[sender] = senderBalance - amount;
352         }
353         _balances[recipient] += amount;
354 
355         emit Transfer(sender, recipient, amount);
356 
357         _afterTokenTransfer(sender, recipient, amount);
358     }
359 
360     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
361      * the total supply.
362      *
363      * Emits a {Transfer} event with `from` set to the zero address.
364      *
365      * Requirements:
366      *
367      * - `account` cannot be the zero address.
368      */
369     function _mint(address account, uint256 amount) internal virtual {
370         require(account != address(0), "ERC20: mint to the zero address");
371 
372         _beforeTokenTransfer(address(0), account, amount);
373 
374         _totalSupply += amount;
375         _balances[account] += amount;
376         emit Transfer(address(0), account, amount);
377 
378         _afterTokenTransfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _beforeTokenTransfer(account, address(0), amount);
396 
397         uint256 accountBalance = _balances[account];
398         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
399         unchecked {
400             _balances[account] = accountBalance - amount;
401         }
402         _totalSupply -= amount;
403 
404         emit Transfer(account, address(0), amount);
405 
406         _afterTokenTransfer(account, address(0), amount);
407     }
408 
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
411      *
412      * This internal function is equivalent to `approve`, and can be used to
413      * e.g. set automatic allowances for certain subsystems, etc.
414      *
415      * Emits an {Approval} event.
416      *
417      * Requirements:
418      *
419      * - `owner` cannot be the zero address.
420      * - `spender` cannot be the zero address.
421      */
422     function _approve(
423         address owner,
424         address spender,
425         uint256 amount
426     ) internal virtual {
427         require(owner != address(0), "ERC20: approve from the zero address");
428         require(spender != address(0), "ERC20: approve to the zero address");
429 
430         _allowances[owner][spender] = amount;
431         emit Approval(owner, spender, amount);
432     }
433 
434     /**
435      * @dev Hook that is called before any transfer of tokens. This includes
436      * minting and burning.
437      *
438      * Calling conditions:
439      *
440      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
441      * will be transferred to `to`.
442      * - when `from` is zero, `amount` tokens will be minted for `to`.
443      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
444      * - `from` and `to` are never both zero.
445      *
446      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
447      */
448     function _beforeTokenTransfer(
449         address from,
450         address to,
451         uint256 amount
452     ) internal virtual {}
453 
454     /**
455      * @dev Hook that is called after any transfer of tokens. This includes
456      * minting and burning.
457      *
458      * Calling conditions:
459      *
460      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
461      * has been transferred to `to`.
462      * - when `from` is zero, `amount` tokens have been minted for `to`.
463      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
464      * - `from` and `to` are never both zero.
465      *
466      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
467      */
468     function _afterTokenTransfer(
469         address from,
470         address to,
471         uint256 amount
472     ) internal virtual {}
473 }
474 
475 
476 /**
477  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
478  */
479 abstract contract ERC20Capped is ERC20 {
480     uint256 private immutable _cap;
481 
482     /**
483      * @dev Sets the value of the `cap`. This value is immutable, it can only be
484      * set once during construction.
485      */
486     constructor(uint256 cap_) {
487         require(cap_ > 0, "ERC20Capped: cap is 0");
488         _cap = cap_;
489     }
490 
491     /**
492      * @dev Returns the cap on the token's total supply.
493      */
494     function cap() public view virtual returns (uint256) {
495         return _cap;
496     }
497 
498     /**
499      * @dev See {ERC20-_mint}.
500      */
501     function _mint(address account, uint256 amount) internal virtual override {
502         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
503         super._mint(account, amount);
504     }
505 }
506 
507 
508 contract CoinversationToken is ERC20Capped {
509     uint256 public immutable startReleaseBlock;   // the block num when initial distribution start.
510     uint256 public constant MONTH = 195622; // 30 * 24 * 60 * 60 / 13.25
511 
512     mapping(address => uint256) public locks12;
513     mapping(address => uint256) public lastUnlockEra12;
514 
515     mapping(address => uint256) public locks24;
516     mapping(address => uint256) public lastUnlockEra24;
517     mapping(address => uint256) public addressStartReleaseBlock;
518     address public constant DEV_ACCOUNT = 0x2326eAb2a83bbe25dE8B9D0A8cB6dc63Dae6BaF9;
519     bool public isDevInitialFundMinted = false;
520 
521     constructor(uint256 _startReleaseBlock)
522         ERC20("Coinversation Token", "CTO")
523         ERC20Capped(100000000 * (10 ** decimals()))
524     {
525         //13566600
526         startReleaseBlock = _startReleaseBlock;
527 
528         uint8 decimals = decimals();
529 
530         //for initial release
531         ERC20._mint(0xDAc57a2C77a64AEFC171339F2891871d9A298EC5, 3604834 * (10 ** decimals));
532 
533         //investors' funds locks up in 12 MONTHs
534         locks12[0x707E4A05B3dDC2049387BF7B7CFe82D6F09e986e] = 7107144 * (10 ** (decimals - 1));
535         locks12[0x316D0e55B47ad86443b25EAa088e203482645046] = 425000 * (10 ** decimals);
536         locks12[0xA7060deA79008DEf99508F50DaBDCDe7293c1D8A] = 349225 * (10 ** decimals);
537         locks12[0xC286Bc3F74fAce4387959665aF71253461c28d34] = 2125000 * (10 ** decimals);
538 
539         locks12[0x3C68319b15Bc0145ce111636f6d8043ACF4D59f6] = 228572 * (10 ** decimals);
540         locks12[0x175dd00579DF16669fC993F8AFA4EE8AA962865A] = 228572 * (10 ** decimals);
541         locks12[0x729Ea64B1393eD633C069aF04b45e1212905b4A9] = 120000 * (10 ** decimals);
542         locks12[0x2C9bC9793AD5c24feD22654Ee13F287329668B55] = 571432 * (10 ** (decimals - 1));
543         locks12[0x2295b2e2F0C8CF5e4E9c2cae33ad4F4cCbc95fD5] = 857144 * (10 ** (decimals - 1));
544 
545         locks12[0xB7d41bb3863E403c29Fe4CA85D31206b6b507630] = 187500 * (10 ** decimals);
546         locks12[0x6D9e32012eC93EBb858F9103B9F7f52eBAb6299F] = 262500 * (10 ** decimals);
547         locks12[0x97CA08d4CA2015545eeb81ca71d1Ac719Fe4A8F6] = 93750 * (10 ** decimals);
548         locks12[0x968dF8FBF4d7c6C46282a46C5DA7d514b23a98fa] = 562500 * (10 ** decimals);
549 
550         locks12[0x16f9cEB2D822ee203a304635d12897dBD2cEeB75] = 93750 * (10 ** decimals);
551         locks12[0xe32341a633FA57CA963D2F2dc78D31D76ee258B7] = 65625 * (10 ** decimals);
552         locks12[0xE88540354a9565300D2E7109d7737508F4155A4d] = 56250 * (10 ** decimals);
553         locks12[0x570DaFD281d70d8d69D19c5A004b0FC3fF52Fd0b] = 56250 * (10 ** decimals);
554         locks12[0x9D400eb10623d34CCEc7aaa9FC347921866B9c86] = 75000 * (10 ** decimals);
555 
556         locks12[0xb87230a8169366051b1732DfB4687F2A041564cf] = 211425 * (10 ** (decimals - 1));
557         locks12[0x67c069523115A6ffE9192F85426cF79f8b4ba7a5] = 2586225 * (10 ** (decimals - 2));
558         locks12[0x8786CB3682Cb347AE1226b5A15E991339A877Dfb] = 2586225 * (10 ** (decimals - 2));
559 
560         //Project Development Fund locks up in 24 MONTHs
561         locks24[0x9C94F95fBa7aDcf936043b817817e18fcb611857] = 12750000 * (10 ** decimals);
562         addressStartReleaseBlock[0x9C94F95fBa7aDcf936043b817817e18fcb611857] = _startReleaseBlock;
563 
564         //Dev Group Fund locks up in 24 MONTHs and the initial release needs to be delayed by one more MONTH
565         locks24[DEV_ACCOUNT] = 13500000 * (10 ** decimals);
566         addressStartReleaseBlock[DEV_ACCOUNT] = _startReleaseBlock + MONTH;
567     }
568 
569     function nextUnlockBlock12(address _account) public view returns (uint) {
570         if(locks12[_account] > 0){
571             return startReleaseBlock + ((lastUnlockEra12[_account] + 1) * MONTH);
572         }else{
573             return 0;
574         }
575     }
576 
577     function canUnlockAmount12(address _account) public view returns (uint256, uint) {
578         uint startBlock = startReleaseBlock;
579         uint lastEra = lastUnlockEra12[_account];
580         // When block number less than nextReleaseBlock, no CTO can be unlocked
581         if (block.number < (startBlock + ((lastEra + 1) * MONTH))) {
582             return (0, 0);
583         }
584         // When block number more than endReleaseBlock12, all locked CTO can be unlocked
585         else if (block.number >= (startBlock + (12 * MONTH))) {
586             return (locks12[_account], 12 - lastEra);
587         }
588         // When block number is more than nextReleaseBlock but less than endReleaseBlock12,
589         // some CTO can be released
590         else {
591             uint eras = (block.number - (startBlock + (lastEra * MONTH))) / MONTH;
592             return (locks12[_account] / (12 - lastEra) * eras, eras);
593         }
594     }
595 
596     function canUnlockAmount24(uint _specificStartReleaseBlock, address _account) public view returns (uint256, uint) {
597         uint startBlock = _specificStartReleaseBlock;
598         uint lastEra = lastUnlockEra24[_account];
599         // When block number less than nextReleaseBlock, no CTO can be unlocked
600         if (block.number < (startBlock + ((lastEra + 1) * MONTH))) {
601             return (0, 0);
602         }
603         // When block number more than endReleaseBlock24, all locked CTO can be unlocked
604         else if (block.number >= (startBlock + (24 * MONTH))) {
605             return (locks24[_account], 24 - lastEra);
606         }
607         // When block number is more than nextReleaseBlock but less than endReleaseBlock24,
608         // some CTO can be released
609         else {
610             uint eras = (block.number - (startBlock + (lastEra * MONTH))) / MONTH;
611             return (locks24[_account] / (24 - lastEra) * eras, eras);
612         }
613     }
614 
615 
616     function unlock12() public {
617         (uint256 amount, uint eras) = canUnlockAmount12(msg.sender);
618         require(amount > 0, "none unlocked CTO");
619 
620         _mint(msg.sender, amount);
621 
622         locks12[msg.sender] = locks12[msg.sender] - amount;
623         lastUnlockEra12[msg.sender] = lastUnlockEra12[msg.sender] + eras;
624     }
625 
626     function unlock24() public {
627         (uint256 amount, uint eras) = canUnlockAmount24(addressStartReleaseBlock[msg.sender], msg.sender);
628         require(amount > 0, "none unlocked CTO");
629 
630         _mint(msg.sender, amount);
631 
632         locks24[msg.sender] = locks24[msg.sender] - amount;
633         lastUnlockEra24[msg.sender] = lastUnlockEra24[msg.sender] + eras;
634     }
635 
636     function mintDevInitialFund() public {
637         require(!isDevInitialFundMinted, "already minted");
638         require(block.number > addressStartReleaseBlock[DEV_ACCOUNT], "time is not up yet");
639 
640         _mint(DEV_ACCOUNT, 1500000 * 10 ** decimals());
641         isDevInitialFundMinted = true;
642     }
643 }