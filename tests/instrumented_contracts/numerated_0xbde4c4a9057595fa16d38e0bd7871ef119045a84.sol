1 // SPDX-License-Identifier: MIT
2 
3 /** 
4     FriendRoom
5     Redefining how friends interact with each other using web3
6     
7     Website: https://friendroom.org/
8     Telegram: https://t.me/friendroomorg
9     Twitter: https://twitter.com/friendroomorg
10 */
11 pragma solidity =0.8.12;
12 pragma abicoder v2;
13 
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
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     /**
30      * @dev Initializes the contract setting the deployer as the initial owner.
31      */
32     constructor() {
33         _transferOwnership(_msgSender());
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         _checkOwner();
41         _;
42     }
43 
44     /**
45      * @dev Returns the address of the current owner.
46      */
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if the sender is not the owner.
53      */
54     function _checkOwner() internal view virtual {
55         require(owner() == _msgSender(), "Ownable: caller is not the owner");
56     }
57 
58     /**
59      * @dev Leaves the contract without owner. It will not be possible to call
60      * `onlyOwner` functions. Can only be called by the current owner.
61      *
62      * NOTE: Renouncing ownership will leave the contract without an owner,
63      * thereby disabling any functionality that is only available to the owner.
64      */
65     function renounceOwnership() public virtual onlyOwner {
66         _transferOwnership(address(0));
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Can only be called by the current owner.
72      */
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         _transferOwnership(newOwner);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Internal function without access restriction.
81      */
82     function _transferOwnership(address newOwner) internal virtual {
83         address oldOwner = _owner;
84         _owner = newOwner;
85         emit OwnershipTransferred(oldOwner, newOwner);
86     }
87 }
88 
89 interface IERC20 {
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
103 
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() external view returns (string memory);
108 
109     /**
110      * @dev Returns the symbol of the token.
111      */
112     function symbol() external view returns (string memory);
113 
114     /**
115      * @dev Returns the decimals places of the token.
116      */
117     function decimals() external view returns (uint8);
118 
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `to`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address to, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `from` to `to` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(address from, address to, uint256 amount) external returns (bool);
173 }
174 
175 contract ERC20 is Context, IERC20 {
176     mapping(address => uint256) private _balances;
177 
178     mapping(address => mapping(address => uint256)) private _allowances;
179 
180     uint256 private _totalSupply;
181 
182     string private _name;
183     string private _symbol;
184 
185     /**
186      * @dev Sets the values for {name} and {symbol}.
187      *
188      * All two of these values are immutable: they can only be set once during
189      * construction.
190      */
191     constructor(string memory name_, string memory symbol_) {
192         _name = name_;
193         _symbol = symbol_;
194     }
195 
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() public view virtual override returns (string memory) {
200         return _name;
201     }
202 
203     /**
204      * @dev Returns the symbol of the token, usually a shorter version of the
205      * name.
206      */
207     function symbol() public view virtual override returns (string memory) {
208         return _symbol;
209     }
210 
211     /**
212      * @dev Returns the number of decimals used to get its user representation.
213      * For example, if `decimals` equals `2`, a balance of `505` tokens should
214      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
215      *
216      * Tokens usually opt for a value of 18, imitating the relationship between
217      * Ether and Wei. This is the default value returned by this function, unless
218      * it's overridden.
219      *
220      * NOTE: This information is only used for _display_ purposes: it in
221      * no way affects any of the arithmetic of the contract, including
222      * {IERC20-balanceOf} and {IERC20-transfer}.
223      */
224     function decimals() public view virtual override returns (uint8) {
225         return 18;
226     }
227 
228     /**
229      * @dev See {IERC20-totalSupply}.
230      */
231     function totalSupply() public view virtual override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See {IERC20-balanceOf}.
237      */
238     function balanceOf(address account) public view virtual override returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See {IERC20-transfer}.
244      *
245      * Requirements:
246      *
247      * - `to` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address to, uint256 amount) public virtual override returns (bool) {
251         address owner = _msgSender();
252         _transfer(owner, to, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-allowance}.
258      */
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See {IERC20-approve}.
265      *
266      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
267      * `transferFrom`. This is semantically equivalent to an infinite approval.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount) public virtual override returns (bool) {
274         address owner = _msgSender();
275         _approve(owner, spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * NOTE: Does not update the allowance if the current allowance
286      * is the maximum `uint256`.
287      *
288      * Requirements:
289      *
290      * - `from` and `to` cannot be the zero address.
291      * - `from` must have a balance of at least `amount`.
292      * - the caller must have allowance for ``from``'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
296         address spender = _msgSender();
297         _spendAllowance(from, spender, amount);
298         _transfer(from, to, amount);
299         return true;
300     }
301 
302     /**
303      * @dev Atomically increases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
315         address owner = _msgSender();
316         _approve(owner, spender, allowance(owner, spender) + addedValue);
317         return true;
318     }
319 
320     /**
321      * @dev Atomically decreases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to {approve} that can be used as a mitigation for
324      * problems described in {IERC20-approve}.
325      *
326      * Emits an {Approval} event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      * - `spender` must have allowance for the caller of at least
332      * `subtractedValue`.
333      */
334     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
335         address owner = _msgSender();
336         uint256 currentAllowance = allowance(owner, spender);
337         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
338     unchecked {
339         _approve(owner, spender, currentAllowance - subtractedValue);
340     }
341 
342         return true;
343     }
344 
345     /**
346      * @dev Moves `amount` of tokens from `from` to `to`.
347      *
348      * This internal function is equivalent to {transfer}, and can be used to
349      * e.g. implement automatic token fees, slashing mechanisms, etc.
350      *
351      * Emits a {Transfer} event.
352      *
353      * Requirements:
354      *
355      * - `from` cannot be the zero address.
356      * - `to` cannot be the zero address.
357      * - `from` must have a balance of at least `amount`.
358      */
359     function _transfer(address from, address to, uint256 amount) internal virtual {
360         require(from != address(0), "ERC20: transfer from the zero address");
361         require(to != address(0), "ERC20: transfer to the zero address");
362 
363         _beforeTokenTransfer(from, to, amount);
364 
365         uint256 fromBalance = _balances[from];
366         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
367     unchecked {
368         _balances[from] = fromBalance - amount;
369         // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
370         // decrementing then incrementing.
371         _balances[to] += amount;
372     }
373 
374         emit Transfer(from, to, amount);
375 
376         _afterTokenTransfer(from, to, amount);
377     }
378 
379     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
380      * the total supply.
381      *
382      * Emits a {Transfer} event with `from` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      */
388     function _mint(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: mint to the zero address");
390 
391         _beforeTokenTransfer(address(0), account, amount);
392 
393         _totalSupply += amount;
394     unchecked {
395         // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
396         _balances[account] += amount;
397     }
398         emit Transfer(address(0), account, amount);
399 
400         _afterTokenTransfer(address(0), account, amount);
401     }
402 
403     /**
404      * @dev Destroys `amount` tokens from `account`, reducing the
405      * total supply.
406      *
407      * Emits a {Transfer} event with `to` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      * - `account` must have at least `amount` tokens.
413      */
414     function _burn(address account, uint256 amount) internal virtual {
415         require(account != address(0), "ERC20: burn from the zero address");
416 
417         _beforeTokenTransfer(account, address(0), amount);
418 
419         uint256 accountBalance = _balances[account];
420         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
421     unchecked {
422         _balances[account] = accountBalance - amount;
423         // Overflow not possible: amount <= accountBalance <= totalSupply.
424         _totalSupply -= amount;
425     }
426 
427         emit Transfer(account, address(0), amount);
428 
429         _afterTokenTransfer(account, address(0), amount);
430     }
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
434      *
435      * This internal function is equivalent to `approve`, and can be used to
436      * e.g. set automatic allowances for certain subsystems, etc.
437      *
438      * Emits an {Approval} event.
439      *
440      * Requirements:
441      *
442      * - `owner` cannot be the zero address.
443      * - `spender` cannot be the zero address.
444      */
445     function _approve(address owner, address spender, uint256 amount) internal virtual {
446         require(owner != address(0), "ERC20: approve from the zero address");
447         require(spender != address(0), "ERC20: approve to the zero address");
448 
449         _allowances[owner][spender] = amount;
450         emit Approval(owner, spender, amount);
451     }
452 
453     /**
454      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
455      *
456      * Does not update the allowance amount in case of infinite allowance.
457      * Revert if not enough allowance is available.
458      *
459      * Might emit an {Approval} event.
460      */
461     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
462         uint256 currentAllowance = allowance(owner, spender);
463         if (currentAllowance != type(uint256).max) {
464             require(currentAllowance >= amount, "ERC20: insufficient allowance");
465         unchecked {
466             _approve(owner, spender, currentAllowance - amount);
467         }
468         }
469     }
470 
471     /**
472      * @dev Hook that is called before any transfer of tokens. This includes
473      * minting and burning.
474      *
475      * Calling conditions:
476      *
477      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
478      * will be transferred to `to`.
479      * - when `from` is zero, `amount` tokens will be minted for `to`.
480      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
481      * - `from` and `to` are never both zero.
482      *
483      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
484      */
485     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
486 
487     /**
488      * @dev Hook that is called after any transfer of tokens. This includes
489      * minting and burning.
490      *
491      * Calling conditions:
492      *
493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
494      * has been transferred to `to`.
495      * - when `from` is zero, `amount` tokens have been minted for `to`.
496      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
497      * - `from` and `to` are never both zero.
498      *
499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
500      */
501     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
502 }
503 
504 contract FriendToken is Ownable, ERC20 {
505     bool public transferable;
506     bool public maxLimited;
507     bool public botLimited;
508     address public dev;
509     uint256 public buyFeeRate;
510     uint256 public sellFeeRate;
511     uint256 public maxHoldingAmount;
512     mapping (address => mapping(address => uint256)) public balanceFromPool;
513     mapping (address => bool) public uniswapPool;
514     mapping (address => bool) public blacklist;
515     mapping (address => bool) public dutyFree;
516     mapping (address => uint256) public lastTradingBlock;
517 
518     event DevSet(address indexed owner, address indexed account);
519     event LimitSet(address indexed owner, bool indexed limited, uint256 indexed amount);
520     event PoolSet(address indexed owner, address indexed account, bool indexed value);
521     event DutyFreeSet(address indexed owner, address indexed account, bool indexed value);
522     event FeeRateSet(address indexed owner, uint256 indexed buyFeeRate, uint256 indexed sellFeeRate);
523     event BlacklistSet(address indexed owner, address[] accounts);
524     event BlacklistRemoved(address indexed owner, address[] accounts);
525 
526     constructor(uint256 totalSupply) ERC20("Friend Room Token", "FRIEND") {
527         maxLimited = true;
528         botLimited = true;
529         maxHoldingAmount = totalSupply;
530 
531         buyFeeRate = 0.05 ether;
532         sellFeeRate = 0.05 ether;
533 
534         dev = msg.sender;
535         dutyFree[msg.sender] = true;
536 
537         _mint(msg.sender, totalSupply);
538     }
539 
540     function setTransferable() external onlyOwner {
541         transferable = !transferable;
542     }
543 
544     function setBlacklist(address[] calldata accounts) public onlyOwner {
545         for (uint256 i = 0; i < accounts.length; i++) {
546             blacklist[accounts[i]] = true;
547         }
548         emit BlacklistSet(msg.sender, accounts);
549     }
550 
551     function removeBlacklist(address[] calldata accounts) public onlyOwner {
552         for (uint256 i = 0; i < accounts.length; i++) {
553             blacklist[accounts[i]] = false;
554         }
555         emit BlacklistRemoved(msg.sender, accounts);
556     }
557 
558     function withdrawToken(address token, address to) external onlyOwner {
559         require(token != address(0), "token address cannot be zero address");
560         uint256 balance = IERC20(token).balanceOf(address(this));
561         IERC20(token).transfer(to, balance);
562     }
563 
564     function withdrawEth(address to) external onlyOwner {
565         (bool success, ) = to.call{value: address(this).balance}(new bytes(0));
566         require(success, "eth transfer failed");
567     }
568 
569     function setMaxLimit(bool _limited, uint256 _amount) external onlyOwner {
570         maxLimited = _limited;
571         maxHoldingAmount = _amount;
572         emit LimitSet(msg.sender, maxLimited, maxHoldingAmount);
573     }
574 
575     function setBotLimited() external onlyOwner {
576         botLimited = !botLimited;
577     }
578 
579     function setPool(address account) external onlyOwner {
580         uniswapPool[account] = !uniswapPool[account];
581         emit PoolSet(msg.sender, account, uniswapPool[account]);
582     }
583 
584     function setDev(address newDev) external onlyOwner {
585         dutyFree[dev] = false;
586 
587         dev = newDev;
588         dutyFree[dev] = true;
589 
590         emit DevSet(msg.sender, dev);
591     }
592 
593     function setDutyFree(address account) public onlyOwner {
594         dutyFree[account] = !dutyFree[account];
595         emit DutyFreeSet(msg.sender, account, dutyFree[account]);
596     }
597 
598     function setFeeRate(uint256 _buyFeeRate, uint256 _sellFeeRate) external onlyOwner {
599         buyFeeRate = _buyFeeRate;
600         sellFeeRate = _sellFeeRate;
601         emit FeeRateSet(msg.sender, _buyFeeRate, _sellFeeRate);
602     }
603 
604     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
605         require(!blacklist[to] && !blacklist[from], "blacklisted");
606 
607         if (!transferable) {
608             require(from == owner() || to == owner(), "trading is not started");
609             return;
610         }
611 
612         if (maxLimited && uniswapPool[from]) {
613             require(balanceFromPool[to][from] + amount <= maxHoldingAmount, "buy limit");
614             balanceFromPool[to][from] += amount;
615         }
616     }
617 
618     function _transfer(address from, address to, uint256 amount) internal override {
619         uint256 feeRate = 0;
620         if (uniswapPool[from]) {
621             if (botLimited) {
622                 require(lastTradingBlock[to] != block.number, "bot limit");
623                 lastTradingBlock[to] = block.number;
624             }
625 
626             if (!dutyFree[to]) {
627                 feeRate = buyFeeRate;
628             }
629         } else if (uniswapPool[to]) {
630             if (botLimited) {
631                 require(lastTradingBlock[from] != block.number, "bot limit");
632                 lastTradingBlock[from] = block.number;
633             }
634 
635             if (!dutyFree[from]) {
636                 feeRate = sellFeeRate;
637             }
638         }
639 
640         if (feeRate > 0) {
641             uint256 fee = amount * feeRate / 1 ether;
642             super._transfer(from, dev, fee);
643             amount -= fee;
644         }
645 
646         super._transfer(from, to, amount);
647     }
648 
649     function burn(uint256 value) external {
650         _burn(msg.sender, value);
651     }
652 }