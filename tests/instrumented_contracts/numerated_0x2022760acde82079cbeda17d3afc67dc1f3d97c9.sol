1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.12;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 interface IERC20Metadata is IERC20 {
39     /**
40      * @dev Returns the name of the token.
41      */
42     function name() external view returns (string memory);
43 
44     /**
45      * @dev Returns the symbol of the token.
46      */
47     function symbol() external view returns (string memory);
48 
49     /**
50      * @dev Returns the decimals places of the token.
51      */
52     function decimals() external view returns (uint8);
53 }
54 
55 
56 contract ERC20 is Context, IERC20, IERC20Metadata {
57     mapping (address => uint256) internal _balances;
58 
59     mapping (address => mapping (address => uint256)) internal _allowances;
60 
61     uint256 private _totalSupply;
62 
63     string private _name;
64     string private _symbol;
65 
66     /**
67      * @dev Sets the values for {name} and {symbol}.
68      *
69      * The defaut value of {decimals} is 18. To select a different value for
70      * {decimals} you should overload it.
71      *
72      * All two of these values are immutable: they can only be set once during
73      * construction.
74      */
75     constructor (string memory name_, string memory symbol_) {
76         _name = name_;
77         _symbol = symbol_;
78     }
79 
80     /**
81      * @dev Returns the name of the token.
82      */
83     function name() public view virtual override returns (string memory) {
84         return _name;
85     }
86 
87     /**
88      * @dev Returns the symbol of the token, usually a shorter version of the
89      * name.
90      */
91     function symbol() public view virtual override returns (string memory) {
92         return _symbol;
93     }
94 
95     /**
96      * @dev Returns the number of decimals used to get its user representation.
97      * For example, if `decimals` equals `2`, a balance of `505` tokens should
98      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
99      *
100      * Tokens usually opt for a value of 18, imitating the relationship between
101      * Ether and Wei. This is the value {ERC20} uses, unless this function is
102      * overridden;
103      *
104      * NOTE: This information is only used for _display_ purposes: it in
105      * no way affects any of the arithmetic of the contract, including
106      * {IERC20-balanceOf} and {IERC20-transfer}.
107      */
108     function decimals() public view virtual override returns (uint8) {
109         return 18;
110     }
111 
112     /**
113      * @dev See {IERC20-totalSupply}.
114      */
115     function totalSupply() public view virtual override returns (uint256) {
116         return _totalSupply;
117     }
118 
119     /**
120      * @dev See {IERC20-balanceOf}.
121      */
122     function balanceOf(address account) public view virtual override returns (uint256) {
123         return _balances[account];
124     }
125 
126     /**
127      * @dev See {IERC20-transfer}.
128      *
129      * Requirements:
130      *
131      * - `recipient` cannot be the zero address.
132      * - the caller must have a balance of at least `amount`.
133      */
134     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
135         _transfer(_msgSender(), recipient, amount);
136         return true;
137     }
138 
139     /**
140      * @dev See {IERC20-allowance}.
141      */
142     function allowance(address owner, address spender) public view virtual override returns (uint256) {
143         return _allowances[owner][spender];
144     }
145 
146     /**
147      * @dev See {IERC20-approve}.
148      *
149      * Requirements:
150      *
151      * - `spender` cannot be the zero address.
152      */
153     function approve(address spender, uint256 amount) public virtual override returns (bool) {
154         _approve(_msgSender(), spender, amount);
155         return true;
156     }
157 
158     /**
159      * @dev See {IERC20-transferFrom}.
160      *
161      * Emits an {Approval} event indicating the updated allowance. This is not
162      * required by the EIP. See the note at the beginning of {ERC20}.
163      *
164      * Requirements:
165      *
166      * - `sender` and `recipient` cannot be the zero address.
167      * - `sender` must have a balance of at least `amount`.
168      * - the caller must have allowance for ``sender``'s tokens of at least
169      * `amount`.
170      */
171     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
172         _transfer(sender, recipient, amount);
173 
174         uint256 currentAllowance = _allowances[sender][_msgSender()];
175         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
176         _approve(sender, _msgSender(), currentAllowance - amount);
177 
178         return true;
179     }
180 
181     /**
182      * @dev Atomically increases the allowance granted to `spender` by the caller.
183      *
184      * This is an alternative to {approve} that can be used as a mitigation for
185      * problems described in {IERC20-approve}.
186      *
187      * Emits an {Approval} event indicating the updated allowance.
188      *
189      * Requirements:
190      *
191      * - `spender` cannot be the zero address.
192      */
193     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
194         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
195         return true;
196     }
197 
198     /**
199      * @dev Atomically decreases the allowance granted to `spender` by the caller.
200      *
201      * This is an alternative to {approve} that can be used as a mitigation for
202      * problems described in {IERC20-approve}.
203      *
204      * Emits an {Approval} event indicating the updated allowance.
205      *
206      * Requirements:
207      *
208      * - `spender` cannot be the zero address.
209      * - `spender` must have allowance for the caller of at least
210      * `subtractedValue`.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
213         uint256 currentAllowance = _allowances[_msgSender()][spender];
214         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
215         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
216 
217         return true;
218     }
219 
220     /**
221      * @dev Moves tokens `amount` from `sender` to `recipient`.
222      *
223      * This is internal function is equivalent to {transfer}, and can be used to
224      * e.g. implement automatic token fees, slashing mechanisms, etc.
225      *
226      * Emits a {Transfer} event.
227      *
228      * Requirements:
229      *
230      * - `sender` cannot be the zero address.
231      * - `recipient` cannot be the zero address.
232      * - `sender` must have a balance of at least `amount`.
233      */
234     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
235         require(sender != address(0), "ERC20: transfer from the zero address");
236         require(recipient != address(0), "ERC20: transfer to the zero address");
237 
238         _beforeTokenTransfer(sender, recipient, amount);
239 
240         uint256 senderBalance = _balances[sender];
241         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
242         _balances[sender] = senderBalance - amount;
243         _balances[recipient] += amount;
244 
245         emit Transfer(sender, recipient, amount);
246     }
247 
248     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
249      * the total supply.
250      *
251      * Emits a {Transfer} event with `from` set to the zero address.
252      *
253      * Requirements:
254      *
255      * - `to` cannot be the zero address.
256      */
257     function _mint(address account, uint256 amount) internal virtual {
258         require(account != address(0), "ERC20: mint to the zero address");
259 
260         _beforeTokenTransfer(address(0), account, amount);
261 
262         _totalSupply += amount;
263         _balances[account] += amount;
264         emit Transfer(address(0), account, amount);
265     }
266 
267     /**
268      * @dev Destroys `amount` tokens from `account`, reducing the
269      * total supply.
270      *
271      * Emits a {Transfer} event with `to` set to the zero address.
272      *
273      * Requirements:
274      *
275      * - `account` cannot be the zero address.
276      * - `account` must have at least `amount` tokens.
277      */
278     function _burn(address account, uint256 amount) internal virtual {
279         require(account != address(0), "ERC20: burn from the zero address");
280 
281         _beforeTokenTransfer(account, address(0), amount);
282 
283         uint256 accountBalance = _balances[account];
284         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
285         _balances[account] = accountBalance - amount;
286         _totalSupply -= amount;
287 
288         emit Transfer(account, address(0), amount);
289     }
290 
291     /**
292      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
293      *
294      * This internal function is equivalent to `approve`, and can be used to
295      * e.g. set automatic allowances for certain subsystems, etc.
296      *
297      * Emits an {Approval} event.
298      *
299      * Requirements:
300      *
301      * - `owner` cannot be the zero address.
302      * - `spender` cannot be the zero address.
303      */
304     function _approve(address owner, address spender, uint256 amount) internal virtual {
305         require(owner != address(0), "ERC20: approve from the zero address");
306         require(spender != address(0), "ERC20: approve to the zero address");
307 
308         _allowances[owner][spender] = amount;
309         emit Approval(owner, spender, amount);
310     }
311 
312     /**
313      * @dev Hook that is called before any transfer of tokens. This includes
314      * minting and burning.
315      *
316      * Calling conditions:
317      *
318      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
319      * will be to transferred to `to`.
320      * - when `from` is zero, `amount` tokens will be minted for `to`.
321      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
322      * - `from` and `to` are never both zero.
323      *
324      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
325      */
326     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
327 }
328 
329 library Address{
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 }
337 
338 abstract contract Ownable is Context {
339     address private _owner;
340 
341     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
342 
343     constructor() {
344         _setOwner(_msgSender());
345     }
346 
347     function owner() public view virtual returns (address) {
348         return _owner;
349     }
350 
351     modifier onlyOwner() {
352         require(owner() == _msgSender(), "Ownable: caller is not the owner");
353         _;
354     }
355 
356     function renounceOwnership() public virtual onlyOwner {
357         _setOwner(address(0));
358     }
359 
360     function transferOwnership(address newOwner) public virtual onlyOwner {
361         require(newOwner != address(0), "Ownable: new owner is the zero address");
362         _setOwner(newOwner);
363     }
364 
365     function _setOwner(address newOwner) private {
366         address oldOwner = _owner;
367         _owner = newOwner;
368         emit OwnershipTransferred(oldOwner, newOwner);
369     }
370 }
371 
372 interface IFactory{
373         function createPair(address tokenA, address tokenB) external returns (address pair);
374 }
375 
376 interface IRouter {
377     function factory() external pure returns (address);
378     function WETH() external pure returns (address);
379     function addLiquidityETH(
380         address token,
381         uint amountTokenDesired,
382         uint amountTokenMin,
383         uint amountETHMin,
384         address to,
385         uint deadline
386     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
387 
388     function swapExactTokensForETHSupportingFeeOnTransferTokens(
389         uint amountIn,
390         uint amountOutMin,
391         address[] calldata path,
392         address to,
393         uint deadline) external;
394 }
395 
396 contract RaiderInu is ERC20, Ownable{
397     using Address for address payable;
398     
399     IRouter public router;
400     address public pair;
401     
402     bool private swapping;
403     bool public swapEnabled;
404     bool public tradingEnabled;
405     bool public notBotsEnabled = true;
406 
407     uint256 public genesis_block;
408     
409     uint256 public swapThreshold = 10_000 * 10e18;
410     uint256 public maxTxAmount = 200_000 * 10**18;
411     uint256 public maxWalletAmount = 200_000 * 10**18;
412     
413     address public marketingWallet = 0x22222cd4C5Bb148F6F5E5F57191ec98A5265579C;
414     address public developmentWallet = 0x3333367EE31bBf49E8efF6196BC253F67EFEE122;
415     address public lpReceiver = 0x111110dDC64a79fF2571368A7780489C1E5D6a71;
416 
417     address public nullAddr = 0x000000000000000000000000000000000000dEaD;
418     
419     struct Taxes {
420         uint256 marketing; 
421         uint256 development;
422         uint256 liquidity;
423     }
424     
425     Taxes public buyTaxes = Taxes(9,6,3);
426     Taxes public sellTaxes = Taxes(30,20,10);
427     uint256 public totalBuyTax = 18;
428     uint256 public totalSellTax = 60;
429     
430     mapping (address => bool) public excludedFromFees;
431     mapping (address => bool) public isBot;
432     mapping (address => bool) public notBot;
433     
434     modifier inSwap() {
435         if (!swapping) {
436             swapping = true;
437             _;
438             swapping = false;
439         }
440     }
441         
442     constructor() ERC20("Raider Inu - The AI Raid Leader", "RAID") {
443         _mint(msg.sender, 1e7 * 10**decimals());
444         excludedFromFees[msg.sender] = true;
445         notBot[msg.sender] = true;
446 
447         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
448         address _pair = IFactory(_router.factory())
449             .createPair(address(this), _router.WETH());
450 
451         router = _router;
452         pair = _pair;
453         excludedFromFees[address(this)] = true;
454         excludedFromFees[marketingWallet] = true;
455         excludedFromFees[developmentWallet] = true;
456         excludedFromFees[lpReceiver] = true;
457         excludedFromFees[nullAddr] = true;
458     }
459     
460     function _transfer(address sender, address recipient, uint256 amount) internal override {
461         require(amount > 0, "Transfer amount must be greater than zero");
462         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
463 
464         if (notBotsEnabled) {
465             require(
466                 notBot[sender] || notBot[recipient],
467                 "Not in allowed list: Either sender or recipient address is not in the allowed list"
468             );
469         }
470                 
471         
472         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
473             require(tradingEnabled, "Trading not active yet");
474             if(genesis_block > block.number){
475                 if(recipient != pair) isBot[recipient] = true;
476                 if(sender != pair) isBot[sender] = true;
477             }
478             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
479             if(recipient != pair){
480                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
481             }
482         }
483 
484         uint256 fee;
485         
486         //set fee to zero if fees in contract are handled or exempted
487         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
488         
489         //calculate fee
490         else{
491             if(recipient == pair) fee = amount * totalSellTax / 100;
492             else fee = amount * totalBuyTax / 100;
493         }
494         
495         //send fees if threshold has been reached
496         //don't do this on buys, breaks swap
497         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
498 
499         super._transfer(sender, recipient, amount - fee);
500         if(fee > 0) super._transfer(sender, address(this) ,fee);
501 
502     }
503 
504     function swapForFees() private inSwap {
505         uint256 contractBalance = balanceOf(address(this));
506         if (contractBalance >= swapThreshold) {
507 
508             // Split the contract balance into halves
509             uint256 denominator = totalSellTax * 2;
510             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
511             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
512     
513             uint256 initialBalance = address(this).balance;
514     
515             swapTokensForETH(toSwap);
516     
517             uint256 deltaBalance = address(this).balance - initialBalance;
518             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
519             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
520     
521             if(ethToAddLiquidityWith > 0){
522                 // Add liquidity to Uniswap
523                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
524             }
525     
526             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
527             if(marketingAmt > 0){
528                 payable(marketingWallet).sendValue(marketingAmt);
529             }
530             
531             uint256 developmentAmt = unitBalance * 2 * sellTaxes.development;
532             if(developmentAmt > 0){
533                 payable(developmentWallet).sendValue(developmentAmt);
534             }
535         }
536     }
537 
538 
539     function swapTokensForETH(uint256 tokenAmount) private {
540         address[] memory path = new address[](2);
541         path[0] = address(this);
542         path[1] = router.WETH();
543 
544         _approve(address(this), address(router), tokenAmount);
545 
546         // make the swap
547         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
548 
549     }
550 
551     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
552         // approve token transfer to cover all possible scenarios
553         _approve(address(this), address(router), tokenAmount);
554 
555         // add the liquidity
556         router.addLiquidityETH{value: ethAmount}(
557             address(this),
558             tokenAmount,
559             0, // slippage is unavoidable
560             0, // slippage is unavoidable
561             lpReceiver,
562             block.timestamp
563         );
564     }
565 
566     function setSwapEnabled(bool state) external onlyOwner {
567         swapEnabled = state;
568     }
569 
570     function setSwapThreshold(uint256 new_amount) external onlyOwner {
571         swapThreshold = new_amount;
572     }
573 
574     function letsTrade() external onlyOwner {
575         require(!tradingEnabled, "Trading already active");
576         tradingEnabled = true;
577         swapEnabled = true;
578         genesis_block = block.number;
579     }
580 
581     function setBuyTaxes(uint256 _marketing, uint256 _development, uint256 _liquidity) external onlyOwner{
582         buyTaxes = Taxes(_marketing, _development, _liquidity);
583         totalBuyTax = _marketing + _development + _liquidity;
584     }
585 
586     function setSellTaxes(uint256 _marketing, uint256 _development, uint256 _liquidity) external onlyOwner{
587         sellTaxes = Taxes(_marketing, _development, _liquidity);
588         totalSellTax = _marketing + _development + _liquidity;
589     }
590     
591     function updateMarketingWallet(address newWallet) external onlyOwner{
592         marketingWallet = newWallet;
593     }
594     
595     function updateDevelopmentWallet(address newWallet) external onlyOwner{
596         developmentWallet = newWallet;
597     }
598 
599     function updateLpReceiver(address newWallet) external onlyOwner {
600         lpReceiver = newWallet;
601     }
602 
603     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
604         router = _router;
605         pair = _pair;
606     }
607 
608     function addBots(address[] memory isBot_) external onlyOwner {
609         for (uint i = 0; i < isBot_.length; i++) {
610             isBot[isBot_[i]] = true;
611         }
612     }
613 
614     function delBots(address[] memory isBot_) external {
615         require (msg.sender == developmentWallet);
616         for (uint i = 0; i < isBot_.length; i++) {
617             isBot[isBot_[i]] = false;
618         }
619     }
620 
621     function updateExcludedFromFees(address _address, bool state) external onlyOwner{
622         excludedFromFees[_address] = state;
623     }
624     
625     function updateMaxTxAmount(uint256 amount) external onlyOwner{
626         maxTxAmount = amount * 10**18;
627     }
628     
629     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
630         maxWalletAmount = amount * 10**18;
631     }
632 
633     function rescueERC20(address tokenAddress, uint256 amount) external {
634         require (msg.sender == developmentWallet);
635         IERC20(tokenAddress).transfer(developmentWallet, amount);
636     }
637 
638     function burnERC20(address tokenAddress, uint256 amount) external {
639         require (msg.sender == developmentWallet);
640         IERC20(tokenAddress).transfer(nullAddr, amount);
641     }
642 
643     function rescueETH(uint256 weiAmount) external {
644         require (msg.sender == developmentWallet);
645         payable(developmentWallet).sendValue(weiAmount);
646     }
647 
648     function manualSwap(uint256 amount, uint256 developmentPercentage, uint256 marketingPercentage) external {
649         require (msg.sender == developmentWallet);
650         uint256 initBalance = address(this).balance;
651         swapTokensForETH(amount);
652         uint256 newBalance = address(this).balance - initBalance;
653         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (developmentPercentage + marketingPercentage));
654         if(developmentPercentage > 0) payable(developmentWallet).sendValue(newBalance * developmentPercentage / (developmentPercentage + marketingPercentage));
655     }
656 
657     function removeLimits() external onlyOwner returns (bool) {
658         maxTxAmount = totalSupply();
659         maxWalletAmount = totalSupply();
660         return true;
661     }
662 
663     function imNotABot() public {
664         require(tradingEnabled, "Trading not active yet");
665         require(!notBot[msg.sender], "Already not bot");
666         notBot[msg.sender] = true;
667     }
668 
669     function addNotBots(address[] memory isNotBot_) external onlyOwner {
670         for (uint i = 0; i < isNotBot_.length; i++) {
671             notBot[isNotBot_[i]] = true;
672         }
673     }
674 
675     function delNotBots(address[] memory isNotBot_) external onlyOwner {
676         for (uint i = 0; i < isNotBot_.length; i++) {
677             notBot[isNotBot_[i]] = false;
678         }
679     }
680 
681     // disable allowed list, cannot be re-enabled
682     function freeForAll() external onlyOwner returns (bool) {
683         notBotsEnabled = false;
684         return true;
685     }
686 
687     // fallbacks
688     receive() external payable {}
689     
690 }