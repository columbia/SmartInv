1 //SPDX-License-Identifier: MIT
2 /* 
3 100xgems
4 
5 100xgems is a holder first token. 
6 2 percent of every buy and every sell will go to a holder bid wallet. 
7 When a specific criteria is met the elected team will vote on what projects 
8 to buy tokens from as well as how much and set targets to sell. 
9 The goal is to increase profits substantially and then return those profits to holders.
10 
11 Links:
12 Http://100xgems.Biz
13 https://t.me/I00xgemsbiz
14 Twitter.com/100xgemsBiz
15 https://www.instagram.com/100xgemsBiz/
16 */
17 
18 pragma solidity 0.8.12;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33 
34     function balanceOf(address account) external view returns (uint256);
35 
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     function approve(address spender, uint256 amount) external returns (bool);
41 
42     function transferFrom(
43         address sender,
44         address recipient,
45         uint256 amount
46     ) external returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 interface IERC20Metadata is IERC20 {
54     /**
55      * @dev Returns the name of the token.
56      */
57     function name() external view returns (string memory);
58 
59     /**
60      * @dev Returns the symbol of the token.
61      */
62     function symbol() external view returns (string memory);
63 
64     /**
65      * @dev Returns the decimals places of the token.
66      */
67     function decimals() external view returns (uint8);
68 }
69 
70 
71 contract ERC20 is Context, IERC20, IERC20Metadata {
72     mapping (address => uint256) internal _balances;
73 
74     mapping (address => mapping (address => uint256)) internal _allowances;
75 
76     uint256 private _totalSupply;
77 
78     string private _name;
79     string private _symbol;
80 
81     /**
82      * @dev Sets the values for {name} and {symbol}.
83      *
84      * The defaut value of {decimals} is 18. To select a different value for
85      * {decimals} you should overload it.
86      *
87      * All two of these values are immutable: they can only be set once during
88      * construction.
89      */
90     constructor (string memory name_, string memory symbol_) {
91         _name = name_;
92         _symbol = symbol_;
93     }
94 
95     /**
96      * @dev Returns the name of the token.
97      */
98     function name() public view virtual override returns (string memory) {
99         return _name;
100     }
101 
102     /**
103      * @dev Returns the symbol of the token, usually a shorter version of the
104      * name.
105      */
106     function symbol() public view virtual override returns (string memory) {
107         return _symbol;
108     }
109 
110     /**
111      * @dev Returns the number of decimals used to get its user representation.
112      * For example, if `decimals` equals `2`, a balance of `505` tokens should
113      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
114      *
115      * Tokens usually opt for a value of 18, imitating the relationship between
116      * Ether and Wei. This is the value {ERC20} uses, unless this function is
117      * overridden;
118      *
119      * NOTE: This information is only used for _display_ purposes: it in
120      * no way affects any of the arithmetic of the contract, including
121      * {IERC20-balanceOf} and {IERC20-transfer}.
122      */
123     function decimals() public view virtual override returns (uint8) {
124         return 18;
125     }
126 
127     /**
128      * @dev See {IERC20-totalSupply}.
129      */
130     function totalSupply() public view virtual override returns (uint256) {
131         return _totalSupply;
132     }
133 
134     /**
135      * @dev See {IERC20-balanceOf}.
136      */
137     function balanceOf(address account) public view virtual override returns (uint256) {
138         return _balances[account];
139     }
140 
141     /**
142      * @dev See {IERC20-transfer}.
143      *
144      * Requirements:
145      *
146      * - `recipient` cannot be the zero address.
147      * - the caller must have a balance of at least `amount`.
148      */
149     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
150         _transfer(_msgSender(), recipient, amount);
151         return true;
152     }
153 
154     /**
155      * @dev See {IERC20-allowance}.
156      */
157     function allowance(address owner, address spender) public view virtual override returns (uint256) {
158         return _allowances[owner][spender];
159     }
160 
161     /**
162      * @dev See {IERC20-approve}.
163      *
164      * Requirements:
165      *
166      * - `spender` cannot be the zero address.
167      */
168     function approve(address spender, uint256 amount) public virtual override returns (bool) {
169         _approve(_msgSender(), spender, amount);
170         return true;
171     }
172 
173     /**
174      * @dev See {IERC20-transferFrom}.
175      *
176      * Emits an {Approval} event indicating the updated allowance. This is not
177      * required by the EIP. See the note at the beginning of {ERC20}.
178      *
179      * Requirements:
180      *
181      * - `sender` and `recipient` cannot be the zero address.
182      * - `sender` must have a balance of at least `amount`.
183      * - the caller must have allowance for ``sender``'s tokens of at least
184      * `amount`.
185      */
186     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
187         _transfer(sender, recipient, amount);
188 
189         uint256 currentAllowance = _allowances[sender][_msgSender()];
190         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
191         _approve(sender, _msgSender(), currentAllowance - amount);
192 
193         return true;
194     }
195 
196     /**
197      * @dev Atomically increases the allowance granted to `spender` by the caller.
198      *
199      * This is an alternative to {approve} that can be used as a mitigation for
200      * problems described in {IERC20-approve}.
201      *
202      * Emits an {Approval} event indicating the updated allowance.
203      *
204      * Requirements:
205      *
206      * - `spender` cannot be the zero address.
207      */
208     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
209         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
210         return true;
211     }
212 
213     /**
214      * @dev Atomically decreases the allowance granted to `spender` by the caller.
215      *
216      * This is an alternative to {approve} that can be used as a mitigation for
217      * problems described in {IERC20-approve}.
218      *
219      * Emits an {Approval} event indicating the updated allowance.
220      *
221      * Requirements:
222      *
223      * - `spender` cannot be the zero address.
224      * - `spender` must have allowance for the caller of at least
225      * `subtractedValue`.
226      */
227     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
228         uint256 currentAllowance = _allowances[_msgSender()][spender];
229         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
230         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
231 
232         return true;
233     }
234 
235     /**
236      * @dev Moves tokens `amount` from `sender` to `recipient`.
237      *
238      * This is internal function is equivalent to {transfer}, and can be used to
239      * e.g. implement automatic token fees, slashing mechanisms, etc.
240      *
241      * Emits a {Transfer} event.
242      *
243      * Requirements:
244      *
245      * - `sender` cannot be the zero address.
246      * - `recipient` cannot be the zero address.
247      * - `sender` must have a balance of at least `amount`.
248      */
249     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
250         require(sender != address(0), "ERC20: transfer from the zero address");
251         require(recipient != address(0), "ERC20: transfer to the zero address");
252 
253         _beforeTokenTransfer(sender, recipient, amount);
254 
255         uint256 senderBalance = _balances[sender];
256         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
257         _balances[sender] = senderBalance - amount;
258         _balances[recipient] += amount;
259 
260         emit Transfer(sender, recipient, amount);
261     }
262 
263     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
264      * the total supply.
265      *
266      * Emits a {Transfer} event with `from` set to the zero address.
267      *
268      * Requirements:
269      *
270      * - `to` cannot be the zero address.
271      */
272     function _mint(address account, uint256 amount) internal virtual {
273         require(account != address(0), "ERC20: mint to the zero address");
274 
275         _beforeTokenTransfer(address(0), account, amount);
276 
277         _totalSupply += amount;
278         _balances[account] += amount;
279         emit Transfer(address(0), account, amount);
280     }
281 
282     /**
283      * @dev Destroys `amount` tokens from `account`, reducing the
284      * total supply.
285      *
286      * Emits a {Transfer} event with `to` set to the zero address.
287      *
288      * Requirements:
289      *
290      * - `account` cannot be the zero address.
291      * - `account` must have at least `amount` tokens.
292      */
293     function _burn(address account, uint256 amount) internal virtual {
294         require(account != address(0), "ERC20: burn from the zero address");
295 
296         _beforeTokenTransfer(account, address(0), amount);
297 
298         uint256 accountBalance = _balances[account];
299         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
300         _balances[account] = accountBalance - amount;
301         _totalSupply -= amount;
302 
303         emit Transfer(account, address(0), amount);
304     }
305 
306     /**
307      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
308      *
309      * This internal function is equivalent to `approve`, and can be used to
310      * e.g. set automatic allowances for certain subsystems, etc.
311      *
312      * Emits an {Approval} event.
313      *
314      * Requirements:
315      *
316      * - `owner` cannot be the zero address.
317      * - `spender` cannot be the zero address.
318      */
319     function _approve(address owner, address spender, uint256 amount) internal virtual {
320         require(owner != address(0), "ERC20: approve from the zero address");
321         require(spender != address(0), "ERC20: approve to the zero address");
322 
323         _allowances[owner][spender] = amount;
324         emit Approval(owner, spender, amount);
325     }
326 
327     /**
328      * @dev Hook that is called before any transfer of tokens. This includes
329      * minting and burning.
330      *
331      * Calling conditions:
332      *
333      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
334      * will be to transferred to `to`.
335      * - when `from` is zero, `amount` tokens will be minted for `to`.
336      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
337      * - `from` and `to` are never both zero.
338      *
339      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
340      */
341     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
342 }
343 
344 library Address{
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         (bool success, ) = recipient.call{value: amount}("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 }
352 
353 abstract contract Ownable is Context {
354     address private _owner;
355 
356     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
357 
358     constructor() {
359         _setOwner(_msgSender());
360     }
361 
362     function owner() public view virtual returns (address) {
363         return _owner;
364     }
365 
366     modifier onlyOwner() {
367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
368         _;
369     }
370 
371     function renounceOwnership() public virtual onlyOwner {
372         _setOwner(address(0));
373     }
374 
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         _setOwner(newOwner);
378     }
379 
380     function _setOwner(address newOwner) private {
381         address oldOwner = _owner;
382         _owner = newOwner;
383         emit OwnershipTransferred(oldOwner, newOwner);
384     }
385 }
386 
387 interface IFactory{
388         function createPair(address tokenA, address tokenB) external returns (address pair);
389 }
390 
391 interface IRouter {
392     function factory() external pure returns (address);
393     function WETH() external pure returns (address);
394     function addLiquidityETH(
395         address token,
396         uint amountTokenDesired,
397         uint amountTokenMin,
398         uint amountETHMin,
399         address to,
400         uint deadline
401     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
402 
403     function swapExactTokensForETHSupportingFeeOnTransferTokens(
404         uint amountIn,
405         uint amountOutMin,
406         address[] calldata path,
407         address to,
408         uint deadline) external;
409 }
410 
411 contract Gems100x is ERC20, Ownable{
412     using Address for address payable;
413     
414     IRouter public router;
415     address public pair;
416     
417     bool private swapping;
418     bool public swapEnabled;
419     bool public tradingEnabled;
420     bool public whaleTaxEnabled = true; // Allows you to turn whale tax off and on
421 
422     uint256 public genesis_block;
423     uint256 public deadblocks = 0;
424     
425     uint256 public swapThreshold = 1_000_000 * 10e18;
426     uint256 public maxTxAmount = 10_000_000 * 10**18;
427     uint256 public maxWalletAmount = 10_000_000 * 10**18;
428     uint256 public whaleSellAmount = 5_000_000 * 10**18; //Doubles fees on sells over 1% of circulating supply
429     
430     address public marketingWallet = 0xC03B179dEbDf0C54AC63666fCBBCB099B2278ebF;
431     address public devWallet = 0xA035Dcb09a6Fac97C6cC1df5c9A917b52f628f9B;
432     
433     struct Taxes {
434         uint256 marketing;
435         uint256 liquidity; 
436         uint256 dev;
437     }
438                             // M,L,D 
439     Taxes public taxes = Taxes(1,4,1);
440     Taxes public sellTaxes = Taxes(1,4,1);
441     uint256 public totTax = 6;
442     uint256 public totSellTax = 6;
443     
444     mapping (address => bool) public excludedFromFees;
445     mapping (address => bool) public isBot;
446     
447     modifier inSwap() {
448         if (!swapping) {
449             swapping = true;
450             _;
451             swapping = false;
452         }
453     }
454 
455     constructor() ERC20("100xGems", "100xGems") {
456         _mint(msg.sender, 1e9 * 10 ** decimals());
457         excludedFromFees[msg.sender] = true;
458 
459         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
460         address _pair = IFactory(_router.factory())
461             .createPair(address(this), _router.WETH());
462 
463         router = _router;
464         pair = _pair;
465         excludedFromFees[address(this)] = true;
466         excludedFromFees[marketingWallet] = true;
467         excludedFromFees[devWallet] = true;
468     }
469     
470 
471     function _transfer(address sender, address recipient, uint256 amount) internal override {
472         require(amount > 0, "Transfer amount must be greater than zero");
473         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
474                 
475         
476         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
477             require(tradingEnabled, "Trading not active yet");
478             if(genesis_block + deadblocks > block.number){
479                 if(recipient != pair) isBot[recipient] = true;
480                 if(sender != pair) isBot[sender] = true;
481             }
482             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
483             if(recipient != pair){
484                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
485             }
486         }
487 
488         uint256 fee;
489         
490         //set fee to zero if fees in contract are handled or exempted
491         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
492         
493         //calculate fee
494         else{
495             if(recipient == pair) {
496                 // If sell is over 1%, then double taxes when whaleTaxEnabled is true
497                 if (amount > whaleSellAmount && whaleTaxEnabled) {
498                     fee = amount * (totSellTax * 2) / 100;
499                 } else {
500                     fee = amount * totSellTax / 100;
501                 }
502             } else {
503                 fee = amount * totTax / 100;
504             }
505         }
506         
507         //send fees if threshold has been reached
508         //don't do this on buys, breaks swap
509         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
510 
511         super._transfer(sender, recipient, amount - fee);
512         if(fee > 0) super._transfer(sender, address(this) ,fee);
513 
514     }
515 
516 
517     function swapForFees() private inSwap {
518         uint256 contractBalance = balanceOf(address(this));
519         if (contractBalance >= swapThreshold) {
520 
521             // Split the contract balance into halves
522             uint256 denominator = totSellTax * 2;
523             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
524             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
525     
526             uint256 initialBalance = address(this).balance;
527     
528             swapTokensForETH(toSwap);
529     
530             uint256 deltaBalance = address(this).balance - initialBalance;
531             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
532             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
533     
534             if(ethToAddLiquidityWith > 0){
535                 // Add liquidity to Uniswap
536                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
537             }
538     
539             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
540             if(marketingAmt > 0){
541                 payable(marketingWallet).sendValue(marketingAmt);
542             }
543             
544             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
545             if(devAmt > 0){
546                 payable(devWallet).sendValue(devAmt);
547             }
548         }
549     }
550 
551 
552     function swapTokensForETH(uint256 tokenAmount) private {
553         address[] memory path = new address[](2);
554         path[0] = address(this);
555         path[1] = router.WETH();
556 
557         _approve(address(this), address(router), tokenAmount);
558 
559         // make the swap
560         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
561 
562     }
563 
564     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
565         // approve token transfer to cover all possible scenarios
566         _approve(address(this), address(router), tokenAmount);
567 
568         // add the liquidity
569         router.addLiquidityETH{value: bnbAmount}(
570             address(this),
571             tokenAmount,
572             0, // slippage is unavoidable
573             0, // slippage is unavoidable
574             devWallet,
575             block.timestamp
576         );
577     }
578 
579     function setSwapEnabled(bool state) external onlyOwner {
580         swapEnabled = state;
581     }
582 
583     function setSwapThreshold(uint256 new_amount) external onlyOwner {
584         swapThreshold = new_amount;
585     }
586 
587     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
588         require(!tradingEnabled, "Trading already active");
589         tradingEnabled = true;
590         swapEnabled = true;
591         genesis_block = block.number;
592         deadblocks = numOfDeadBlocks;
593     }
594 
595     function enableWhaleTax(bool state) external onlyOwner{
596         require(!state, "Whale Tax is already set to this");
597         whaleTaxEnabled = state;
598     }
599 
600     function setTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
601         require(_marketing + _liquidity + _dev <= 20, "Max fee is 20%");
602         taxes = Taxes(_marketing, _liquidity, _dev);
603         totTax = _marketing + _liquidity + _dev;
604     }
605 
606     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
607         require(_marketing + _liquidity + _dev <= 20, "Max fee is 20%");
608         sellTaxes = Taxes(_marketing, _liquidity, _dev);
609         totSellTax = _marketing + _liquidity + _dev;
610     }
611     
612     function updateMarketingWallet(address newWallet) external onlyOwner{
613         marketingWallet = newWallet;
614     }
615     
616     function updateDevWallet(address newWallet) external onlyOwner{
617         devWallet = newWallet;
618     }
619 
620     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
621         router = _router;
622         pair = _pair;
623     }
624     
625     function setIsBot(address account, bool state) external onlyOwner{
626         isBot[account] = state;
627     }
628 
629     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
630         excludedFromFees[_address] = state;
631     }
632     
633     function updateMaxTxAmount(uint256 amount) external onlyOwner{
634         maxTxAmount = amount * 10**18;
635     }
636     
637     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
638         maxWalletAmount = amount * 10**18;
639     }
640 
641     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
642         IERC20(tokenAddress).transfer(owner(), amount);
643     }
644 
645     function rescueETH(uint256 weiAmount) external onlyOwner{
646         payable(owner()).sendValue(weiAmount);
647     }
648 
649     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
650         uint256 initBalance = address(this).balance;
651         swapTokensForETH(amount);
652         uint256 newBalance = address(this).balance - initBalance;
653         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
654         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
655     }
656 
657     // fallbacks
658     receive() external payable {}
659     
660 }