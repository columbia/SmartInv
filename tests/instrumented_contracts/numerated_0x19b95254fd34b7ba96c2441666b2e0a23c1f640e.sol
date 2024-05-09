1 pragma solidity 0.8.20;
2 
3 // SPDX-License-Identifier: MIT
4 
5 /* 
6 
7 TELEGRAM:https://t.me/peterpancoineth
8 WEBSITE:https://peterpan.finance
9 TWITTER:https://x.com/peterpan_v2
10 
11 */
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Metadata is IERC20{
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 contract ERC20 is Context, IERC20, IERC20Metadata {
117     mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     string private _name;
124     string private _symbol;
125 
126     /**
127      * @dev Sets the values for {name} and {symbol}.
128      *
129      * All two of these values are immutable: they can only be set once during
130      * construction.
131      */
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     /**
138      * @dev Returns the name of the token.
139      */
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     /**
145      * @dev Returns the symbol of the token, usually a shorter version of the
146      * name.
147      */
148     function symbol() public view virtual override returns (string memory) {
149         return _symbol;
150     }
151 
152     /**
153      * @dev Returns the number of decimals used to get its user representation.
154      * For example, if `decimals` equals `2`, a balance of `505` tokens should
155      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
156      *
157      * Tokens usually opt for a value of 18, imitating the relationship between
158      * Ether and Wei. This is the default value returned by this function, unless
159      * it's overridden.
160      *
161      * NOTE: This information is only used for _display_ purposes: it in
162      * no way affects any of the arithmetic of the contract, including
163      * {IERC20-balanceOf} and {IERC20-transfer}.
164      */
165     function decimals() public view virtual override returns (uint8) {
166         return 18;
167     }
168 
169     /**
170      * @dev See {IERC20-totalSupply}.
171      */
172     function totalSupply() public view virtual override returns (uint256) {
173         return _totalSupply;
174     }
175 
176     /**
177      * @dev See {IERC20-balanceOf}.
178      */
179     function balanceOf(address account) public view virtual override returns (uint256) {
180         return _balances[account];
181     }
182 
183     /**
184      * @dev See {IERC20-transfer}.
185      *
186      * Requirements:
187      *
188      * - `to` cannot be the zero address.
189      * - the caller must have a balance of at least `amount`.
190      */
191     function transfer(address to, uint256 amount) public virtual override returns (bool) {
192         address owner = _msgSender();
193         _transfer(owner, to, amount);
194         return true;
195     }
196 
197     /**
198      * @dev See {IERC20-allowance}.
199      */
200     function allowance(address owner, address spender) public view virtual override returns (uint256) {
201         return _allowances[owner][spender];
202     }
203 
204     /**
205      * @dev See {IERC20-approve}.
206      *
207      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
208      * `transferFrom`. This is semantically equivalent to an infinite approval.
209      *
210      * Requirements:
211      *
212      * - `spender` cannot be the zero address.
213      */
214     function approve(address spender, uint256 amount) public virtual override returns (bool) {
215         address owner = _msgSender();
216         _approve(owner, spender, amount);
217         return true;
218     }
219 
220     /**
221      * @dev See {IERC20-transferFrom}.
222      *
223      * Emits an {Approval} event indicating the updated allowance. This is not
224      * required by the EIP. See the note at the beginning of {ERC20}.
225      *
226      * NOTE: Does not update the allowance if the current allowance
227      * is the maximum `uint256`.
228      *
229      * Requirements:
230      *
231      * - `from` and `to` cannot be the zero address.
232      * - `from` must have a balance of at least `amount`.
233      * - the caller must have allowance for ``from``'s tokens of at least
234      * `amount`.
235      */
236     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
237         address spender = _msgSender();
238         _spendAllowance(from, spender, amount);
239         _transfer(from, to, amount);
240         return true;
241     }
242 
243     /**
244      * @dev Atomically increases the allowance granted to `spender` by the caller.
245      *
246      * This is an alternative to {approve} that can be used as a mitigation for
247      * problems described in {IERC20-approve}.
248      *
249      * Emits an {Approval} event indicating the updated allowance.
250      *
251      * Requirements:
252      *
253      * - `spender` cannot be the zero address.
254      */
255     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
256         address owner = _msgSender();
257         _approve(owner, spender, allowance(owner, spender) + addedValue);
258         return true;
259     }
260 
261     /**
262      * @dev Atomically decreases the allowance granted to `spender` by the caller.
263      *
264      * This is an alternative to {approve} that can be used as a mitigation for
265      * problems described in {IERC20-approve}.
266      *
267      * Emits an {Approval} event indicating the updated allowance.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      * - `spender` must have allowance for the caller of at least
273      * `subtractedValue`.
274      */
275     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
276         address owner = _msgSender();
277         uint256 currentAllowance = allowance(owner, spender);
278         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
279         unchecked {
280             _approve(owner, spender, currentAllowance - subtractedValue);
281         }
282 
283         return true;
284     }
285 
286     /**
287      * @dev Moves `amount` of tokens from `from` to `to`.
288      *
289      * This internal function is equivalent to {transfer}, and can be used to
290      * e.g. implement automatic token fees, slashing mechanisms, etc.
291      *
292      * Emits a {Transfer} event.
293      *
294      * Requirements:
295      *
296      * - `from` cannot be the zero address.
297      * - `to` cannot be the zero address.
298      * - `from` must have a balance of at least `amount`.
299      */
300     function _transfer(address from, address to, uint256 amount) internal virtual {
301         require(from != address(0), "ERC20: transfer from the zero address");
302         require(to != address(0), "ERC20: transfer to the zero address");
303 
304         _beforeTokenTransfer(from, to, amount);
305 
306         uint256 fromBalance = _balances[from];
307         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
308         unchecked {
309             _balances[from] = fromBalance - amount;
310             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
311             // decrementing then incrementing.
312             _balances[to] += amount;
313         }
314 
315         emit Transfer(from, to, amount);
316 
317         _afterTokenTransfer(from, to, amount);
318     }
319 
320     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
321      * the total supply.
322      *
323      * Emits a {Transfer} event with `from` set to the zero address.
324      *
325      * Requirements:
326      *
327      * - `account` cannot be the zero address.
328      */
329     function _mint(address account, uint256 amount) internal virtual {
330         require(account != address(0), "ERC20: mint to the zero address");
331 
332         _beforeTokenTransfer(address(0), account, amount);
333 
334         _totalSupply += amount;
335         unchecked {
336             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
337             _balances[account] += amount;
338         }
339         emit Transfer(address(0), account, amount);
340 
341         _afterTokenTransfer(address(0), account, amount);
342     }
343 
344     /**
345      * @dev Destroys `amount` tokens from `account`, reducing the
346      * total supply.
347      *
348      * Emits a {Transfer} event with `to` set to the zero address.
349      *
350      * Requirements:
351      *
352      * - `account` cannot be the zero address.
353      * - `account` must have at least `amount` tokens.
354      */
355     function _burn(address account, uint256 amount) internal virtual {
356         require(account != address(0), "ERC20: burn from the zero address");
357 
358         _beforeTokenTransfer(account, address(0), amount);
359 
360         uint256 accountBalance = _balances[account];
361         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
362         unchecked {
363             _balances[account] = accountBalance - amount;
364             // Overflow not possible: amount <= accountBalance <= totalSupply.
365             _totalSupply -= amount;
366         }
367 
368         emit Transfer(account, address(0), amount);
369 
370         _afterTokenTransfer(account, address(0), amount);
371     }
372 
373     /**
374      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
375      *
376      * This internal function is equivalent to `approve`, and can be used to
377      * e.g. set automatic allowances for certain subsystems, etc.
378      *
379      * Emits an {Approval} event.
380      *
381      * Requirements:
382      *
383      * - `owner` cannot be the zero address.
384      * - `spender` cannot be the zero address.
385      */
386     function _approve(address owner, address spender, uint256 amount) internal virtual {
387         require(owner != address(0), "ERC20: approve from the zero address");
388         require(spender != address(0), "ERC20: approve to the zero address");
389 
390         _allowances[owner][spender] = amount;
391         emit Approval(owner, spender, amount);
392     }
393 
394     /**
395      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
396      *
397      * Does not update the allowance amount in case of infinite allowance.
398      * Revert if not enough allowance is available.
399      *
400      * Might emit an {Approval} event.
401      */
402     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
403         uint256 currentAllowance = allowance(owner, spender);
404         if (currentAllowance != type(uint256).max) {
405             require(currentAllowance >= amount, "ERC20: insufficient allowance");
406             unchecked {
407                 _approve(owner, spender, currentAllowance - amount);
408             }
409         }
410     }
411 
412     /**
413      * @dev Hook that is called before any transfer of tokens. This includes
414      * minting and burning.
415      *
416      * Calling conditions:
417      *
418      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
419      * will be transferred to `to`.
420      * - when `from` is zero, `amount` tokens will be minted for `to`.
421      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
422      * - `from` and `to` are never both zero.
423      *
424      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
425      */
426     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
427 
428     /**
429      * @dev Hook that is called after any transfer of tokens. This includes
430      * minting and burning.
431      *
432      * Calling conditions:
433      *
434      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
435      * has been transferred to `to`.
436      * - when `from` is zero, `amount` tokens have been minted for `to`.
437      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
438      * - `from` and `to` are never both zero.
439      *
440      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
441      */
442     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
443 }
444 
445 contract Ownable is Context {
446     address private _owner;
447 
448     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
449     
450     constructor () {
451         address msgSender = _msgSender();
452         _owner = msgSender;
453         emit OwnershipTransferred(address(0), msgSender);
454     }
455 
456     function owner() public view returns (address) {
457         return _owner;
458     }
459 
460     modifier onlyOwner() {
461         require(_owner == _msgSender(), "Ownable: caller is not the owner");
462         _;
463     }
464 
465     function renounceOwnership() external virtual onlyOwner {
466         emit OwnershipTransferred(_owner, address(0));
467         _owner = address(0);
468     }
469 
470     function transferOwnership(address newOwner) public virtual onlyOwner {
471         require(newOwner != address(0), "Ownable: new owner is the zero address");
472         emit OwnershipTransferred(_owner, newOwner);
473         _owner = newOwner;
474     }
475 }
476 
477 interface IDexRouter {
478     function factory() external pure returns (address);
479     function WETH() external pure returns (address);
480     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
481 }
482 
483 interface IDexFactory {
484     function createPair(address tokenA, address tokenB) external returns (address pair);
485 }
486 
487 contract peterpan is ERC20, Ownable {
488 
489     mapping (address => bool) public exemptFromFees;
490     mapping (address => bool) public exemptFromLimits;
491 
492     bool public tradingActive;
493 
494     mapping (address => bool) public isAMMPair;
495 
496     uint256 public maxTransaction;
497     uint256 public maxWallet;
498 
499     address public operationsAddress;
500 
501     uint256 public buyTax;
502     uint256 public sellTax;
503 
504     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
505     bool public transferDelayEnabled = true;
506     bool public limitsInEffect = true;
507 
508     bool private swapping;
509     uint256 public swapTokensAtAmt;
510 
511     address public lpPair;
512     IDexRouter public dexRouter;
513 
514     uint256 public constant FEE_DIVISOR = 10000;
515 
516     // events
517 
518     event UpdatedMaxTransaction(uint256 newMax);
519     event UpdatedMaxWallet(uint256 newMax);
520     event SetExemptFromFees(address _address, bool _isExempt);
521     event SetExemptFromLimits(address _address, bool _isExempt);
522     event RemovedLimits();
523     event UpdatedBuyTax(uint256 newAmt);
524     event UpdatedSellTax(uint256 newAmt);
525 
526     // constructor
527 
528     constructor(string memory _name, string memory _symbol)
529         ERC20(_name, _symbol)
530     {   
531         address newOwner = 0x556A7234F4130C9A5244f534cFB6C238710ea6AA;
532         _mint(newOwner, 469_000_000 * 1e18);
533         uint256 _totalSupply = totalSupply();
534 
535         address _v2Router;
536 
537         // @dev assumes WETH pair
538         if(block.chainid == 1){
539             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
540         } else if(block.chainid == 5){
541             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
542         } else {
543             revert("Chain not configured");
544         }
545 
546         dexRouter = IDexRouter(_v2Router);
547 
548         maxTransaction = _totalSupply * 15 / 1000;
549         maxWallet = _totalSupply * 15 / 1000;
550         swapTokensAtAmt = _totalSupply * 25 / 100000;
551 
552         operationsAddress = 0x736E88b667FBe9286e48854B6818C317cD82D9AB;
553 
554         buyTax = 8000; // 1% = 100
555         sellTax = 8000; // 1% = 100
556 
557         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
558 
559         isAMMPair[lpPair] = true;
560 
561         exemptFromLimits[lpPair] = true;
562         exemptFromLimits[newOwner] = true;
563         exemptFromLimits[address(this)] = true;
564         exemptFromLimits[address(dexRouter)] = true;
565         
566 
567         exemptFromFees[newOwner] = true;
568         exemptFromFees[address(this)] = true;
569         exemptFromFees[address(dexRouter)] = true;
570         
571  
572         _approve(address(this), address(dexRouter), type(uint256).max);
573         transferOwnership(newOwner);
574     }
575 
576     receive() external payable {}
577 
578     function _transfer(
579         address from,
580         address to,
581         uint256 amount
582     ) internal virtual override {
583         
584         if(exemptFromFees[from] || exemptFromFees[to] || swapping){
585             super._transfer(from,to,amount);
586             return;
587         }
588 
589         require(tradingActive, "Trading not active");
590 
591         if(limitsInEffect){
592             checkLimits(from, to, amount);
593         }
594 
595         amount -= handleTax(from, to, amount);
596 
597         super._transfer(from,to,amount);
598     }
599 
600     function checkLimits(address from, address to, uint256 amount) internal {
601         if (transferDelayEnabled){
602             if (to != address(dexRouter) && !isAMMPair[to]){
603                 require(_holderLastTransferBlock[tx.origin] < block.number, "Transfer Delay enabled.");
604                 _holderLastTransferBlock[tx.origin] = block.number;
605             }
606         }
607 
608         // buy
609         if (isAMMPair[from] && !exemptFromLimits[to]) {
610             require(amount <= maxTransaction, "Max tx exceeded.");
611             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
612         } 
613         // sell
614         else if (isAMMPair[to] && !exemptFromLimits[from]) {
615             require(amount <= maxTransaction, "Max tx exceeded.");
616         }
617         else if(!exemptFromLimits[to]) {
618             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
619         }
620     }
621 
622     function handleTax(address from, address to, uint256 amount) internal returns (uint256){
623         if(balanceOf(address(this)) >= swapTokensAtAmt && !swapping && !isAMMPair[from]) {
624             swapping = true;
625             swapBack();
626             swapping = false;
627         }
628         
629         uint256 tax = 0;
630 
631         // on sell
632         if (isAMMPair[to] && sellTax > 0){
633             tax = amount * sellTax / FEE_DIVISOR;
634         }
635         // on buy
636         else if(isAMMPair[from] && buyTax > 0) {
637             tax = amount * buyTax / FEE_DIVISOR;
638         }
639         
640         if(tax > 0){    
641             super._transfer(from, address(this), tax);
642         }
643         
644         return tax;
645     }
646 
647     function swapTokensForETH(uint256 tokenAmt) private {
648 
649         address[] memory path = new address[](2);
650         path[0] = address(this);
651         path[1] = dexRouter.WETH();
652 
653         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
654             tokenAmt,
655             0,
656             path,
657             address(this),
658             block.timestamp
659         );
660     }
661 
662     function swapBack() private {
663 
664         uint256 contractBalance = balanceOf(address(this));
665         
666         if(contractBalance == 0) {return;}
667 
668         if(contractBalance > swapTokensAtAmt * 40){
669             contractBalance = swapTokensAtAmt * 40;
670         }
671         
672         swapTokensForETH(contractBalance);
673             
674         if(address(this).balance > 0){
675             bool success;
676             (success, ) = operationsAddress.call{value: address(this).balance}("");
677         }
678     }
679 
680     // owner functions
681 
682     function setExemptFromFees(address _address, bool _isExempt) external onlyOwner {
683         require(_address != address(0), "Zero Address");
684         exemptFromFees[_address] = _isExempt;
685         emit SetExemptFromFees(_address, _isExempt);
686     }
687 
688     function setExemptFromLimits(address _address, bool _isExempt) external onlyOwner {
689         require(_address != address(0), "Zero Address");
690         if(!_isExempt){
691             require(_address != lpPair, "Pair");
692         }
693         exemptFromLimits[_address] = _isExempt;
694         emit SetExemptFromLimits(_address, _isExempt);
695     }
696 
697     function updateMaxTransaction(uint256 newNumInTokens) external onlyOwner {
698         require(newNumInTokens >= (totalSupply() * 5 / 1000)/(10**decimals()), "Too low");
699         maxTransaction = newNumInTokens * (10**decimals());
700         emit UpdatedMaxTransaction(maxTransaction);
701     }
702 
703     function updateMaxWallet(uint256 newNumInTokens) external onlyOwner {
704         require(newNumInTokens >= (totalSupply() * 1 / 100)/(10**decimals()), "Too low");
705         maxWallet = newNumInTokens * (10**decimals());
706         emit UpdatedMaxWallet(maxWallet);
707     }
708 
709     function updateTaxes(uint256 _buyTax, uint256 _sellTax) external onlyOwner {
710         buyTax = _buyTax;
711         emit UpdatedBuyTax(buyTax);
712         sellTax = _sellTax;
713         emit UpdatedSellTax(sellTax);
714     }
715 
716     function enableTrading() external onlyOwner {
717         require(!tradingActive, "Trading active");
718         tradingActive = true;
719     }
720 
721     function removeLimits() external onlyOwner {
722         limitsInEffect = false;
723         transferDelayEnabled = false;
724         maxTransaction = totalSupply();
725         maxWallet = totalSupply();
726         emit RemovedLimits();
727     }
728 
729     function disableTransferDelay() external onlyOwner {
730         transferDelayEnabled = false;
731     }
732 
733     function updateOperationsAddress(address _address) external onlyOwner {
734         require(_address != address(0), "zero address");
735         operationsAddress = _address;
736     }
737 }