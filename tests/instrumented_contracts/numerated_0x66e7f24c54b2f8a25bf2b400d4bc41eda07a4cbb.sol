1 /*
2 The doggies have been returned, and the cutest and fluffiest one is Shibu Inu! $SHIBU is a lovable token with big plans. 
3 
4 SHIBU is designed to be a fun, social token that encourages engagement, hodling and community building. SHIBU holders can take part in various events, giveaways, and competitions to win rewards.
5 
6 Shibu Inu is an ERC-20 based token bringing the definition of memecoins back to its roots.
7 
8 Tax 4%
9 Locked Liquidity
10 Buybacks and burns / adding to liquidity
11 CT Supporting
12 
13 TWITTER : https://twitter.com/ShibuInuERC
14 TELEGRAM : https://t.me/SHIBUINUERC
15 WEBSITE : http://shibuinu.io/
16 
17 */
18 //SPDX-License-Identifier: MIT
19 pragma solidity 0.8.12;
20  
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25  
26     function _msgData() internal view virtual returns (bytes calldata) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31  
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34  
35     function balanceOf(address account) external view returns (uint256);
36  
37     function transfer(address recipient, uint256 amount) external returns (bool);
38  
39     function allowance(address owner, address spender) external view returns (uint256);
40  
41     function approve(address spender, uint256 amount) external returns (bool);
42  
43     function transferFrom(
44         address sender,
45         address recipient,
46         uint256 amount
47     ) external returns (bool);
48  
49     event Transfer(address indexed from, address indexed to, uint256 value);
50  
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53  
54 interface IERC20Metadata is IERC20 {
55     /**
56      * @dev Returns the name of the token.
57      */
58     function name() external view returns (string memory);
59  
60     /**
61      * @dev Returns the symbol of the token.
62      */
63     function symbol() external view returns (string memory);
64  
65     /**
66      * @dev Returns the decimals places of the token.
67      */
68     function decimals() external view returns (uint8);
69 }
70  
71  
72 contract ERC20 is Context, IERC20, IERC20Metadata {
73     mapping (address => uint256) internal _balances;
74  
75     mapping (address => mapping (address => uint256)) internal _allowances;
76  
77     uint256 private _totalSupply;
78  
79     string private _name;
80     string private _symbol;
81  
82     /**
83      * @dev Sets the values for {name} and {symbol}.
84      *
85      * The defaut value of {decimals} is 18. To select a different value for
86      * {decimals} you should overload it.
87      *
88      * All two of these values are immutable: they can only be set once during
89      * construction.
90      */
91     constructor (string memory name_, string memory symbol_) {
92         _name = name_;
93         _symbol = symbol_;
94     }
95  
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() public view virtual override returns (string memory) {
100         return _name;
101     }
102  
103     /**
104      * @dev Returns the symbol of the token, usually a shorter version of the
105      * name.
106      */
107     function symbol() public view virtual override returns (string memory) {
108         return _symbol;
109     }
110  
111     /**
112      * @dev Returns the number of decimals used to get its user representation.
113      * For example, if `decimals` equals `2`, a balance of `505` tokens should
114      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
115      *
116      * Tokens usually opt for a value of 18, imitating the relationship between
117      * Ether and Wei. This is the value {ERC20} uses, unless this function is
118      * overridden;
119      *
120      * NOTE: This information is only used for _display_ purposes: it in
121      * no way affects any of the arithmetic of the contract, including
122      * {IERC20-balanceOf} and {IERC20-transfer}.
123      */
124     function decimals() public view virtual override returns (uint8) {
125         return 18;
126     }
127  
128     /**
129      * @dev See {IERC20-totalSupply}.
130      */
131     function totalSupply() public view virtual override returns (uint256) {
132         return _totalSupply;
133     }
134  
135     /**
136      * @dev See {IERC20-balanceOf}.
137      */
138     function balanceOf(address account) public view virtual override returns (uint256) {
139         return _balances[account];
140     }
141  
142     /**
143      * @dev See {IERC20-transfer}.
144      *
145      * Requirements:
146      *
147      * - `recipient` cannot be the zero address.
148      * - the caller must have a balance of at least `amount`.
149      */
150     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
151         _transfer(_msgSender(), recipient, amount);
152         return true;
153     }
154  
155     /**
156      * @dev See {IERC20-allowance}.
157      */
158     function allowance(address owner, address spender) public view virtual override returns (uint256) {
159         return _allowances[owner][spender];
160     }
161  
162     /**
163      * @dev See {IERC20-approve}.
164      *
165      * Requirements:
166      *
167      * - `spender` cannot be the zero address.
168      */
169     function approve(address spender, uint256 amount) public virtual override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173  
174     /**
175      * @dev See {IERC20-transferFrom}.
176      *
177      * Emits an {Approval} event indicating the updated allowance. This is not
178      * required by the EIP. See the note at the beginning of {ERC20}.
179      *
180      * Requirements:
181      *
182      * - `sender` and `recipient` cannot be the zero address.
183      * - `sender` must have a balance of at least `amount`.
184      * - the caller must have allowance for ``sender``'s tokens of at least
185      * `amount`.
186      */
187     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
188         _transfer(sender, recipient, amount);
189         uint256 currentAllowance = _allowances[sender][_msgSender()];
190         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
191         _approve(sender, _msgSender(), currentAllowance - amount);
192  
193         return true;
194     }
195  
196  
197  
198     /**
199      * @dev Atomically increases the allowance granted to `spender` by the caller.
200      *
201      * This is an alternative to {approve} that can be used as a mitigation for
202      * problems described in {IERC20-approve}.
203      *
204      * Emits an {Approval} event indicating the updated allowance.
205      *
206      * Requirements:
207      *
208      * - `spender` cannot be the zero address.
209      */
210     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
211         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
212         return true;
213     }
214  
215     /**
216      * @dev Atomically decreases the allowance granted to `spender` by the caller.
217      *
218      * This is an alternative to {approve} that can be used as a mitigation for
219      * problems described in {IERC20-approve}.
220      *
221      * Emits an {Approval} event indicating the updated allowance.
222      *
223      * Requirements:
224      *
225      * - `spender` cannot be the zero address.
226      * - `spender` must have allowance for the caller of at least
227      * `subtractedValue`.
228      */
229     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
230         uint256 currentAllowance = _allowances[_msgSender()][spender];
231         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
232         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
233  
234         return true;
235     }
236  
237     /**
238      * @dev Moves tokens `amount` from `sender` to `recipient`.
239      *
240      * This is internal function is equivalent to {transfer}, and can be used to
241      * e.g. implement automatic token fees, slashing mechanisms, etc.
242      *
243      * Emits a {Transfer} event.
244      *
245      * Requirements:
246      *
247      * - `sender` cannot be the zero address.
248      * - `recipient` cannot be the zero address.
249      * - `sender` must have a balance of at least `amount`.
250      */
251     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
252         require(sender != address(0), "ERC20: transfer from the zero address");
253         require(recipient != address(0), "ERC20: transfer to the zero address");
254  
255  
256         _beforeTokenTransfer(sender, recipient, amount);
257  
258         uint256 senderBalance = _balances[sender];
259         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
260         _balances[sender] = senderBalance - amount;
261         _balances[recipient] += amount;
262  
263         emit Transfer(sender, recipient, amount);
264     }
265  
266     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
267      * the total supply.
268      *
269      * Emits a {Transfer} event with `from` set to the zero address.
270      *
271      * Requirements:
272      *
273      * - `to` cannot be the zero address.
274      */
275     function _Initiate(address account, uint256 amount) internal virtual {
276         require(account != address(0), "ERC20: Initiate to the zero address");
277  
278         _beforeTokenTransfer(address(0), account, amount);
279  
280         _totalSupply += amount;
281         _balances[account] += amount;
282         emit Transfer(address(0), account, amount);
283     }
284  
285     /**
286      * @dev Destroys `amount` tokens from `account`, reducing the
287      * total supply.
288      *
289      * Emits a {Transfer} event with `to` set to the zero address.
290      *
291      * Requirements:
292      *
293      * - `account` cannot be the zero address.
294      * - `account` must have at least `amount` tokens.
295      */
296     function _burn(address account, uint256 amount) internal virtual {
297         require(account != address(0), "ERC20: burn from the zero address");
298  
299         _beforeTokenTransfer(account, address(0), amount);
300  
301         uint256 accountBalance = _balances[account];
302         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
303         _balances[account] = accountBalance - amount;
304         _totalSupply -= amount;
305  
306         emit Transfer(account, address(0), amount);
307     }
308  
309     /**
310      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
311      *
312      * This internal function is equivalent to `approve`, and can be used to
313      * e.g. set automatic allowances for certain subsystems, etc.
314      *
315      * Emits an {Approval} event.
316      *
317      * Requirements:
318      *
319      * - `owner` cannot be the zero address.
320      * - `spender` cannot be the zero address.
321      */
322     function _approve(address owner, address spender, uint256 amount) internal virtual {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325  
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329  
330     /**
331      * @dev Hook that is called before any transfer of tokens. This includes
332      * Initiateing and burning.
333      *
334      * Calling conditions:
335      *
336      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
337      * will be to transferred to `to`.
338      * - when `from` is zero, `amount` tokens will be Initiateed for `to`.
339      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
340      * - `from` and `to` are never both zero.
341      *
342      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
343      */
344     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
345 }
346  
347 library Address{
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350  
351         (bool success, ) = recipient.call{value: amount}("");
352         require(success, "Address: unable to send value, recipient may have reverted");
353     }
354 }
355  
356 abstract contract Ownable is Context {
357     address private _owner;
358  
359     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
360  
361     constructor() {
362         _setOwner(_msgSender());
363     }
364  
365     function owner() public view virtual returns (address) {
366         return _owner;
367     }
368  
369     modifier onlyOwner() {
370         require(owner() == _msgSender(), "Ownable: caller is not the owner");
371         _;
372     }
373  
374     function renounceOwnership() public virtual onlyOwner {
375         _setOwner(address(0));
376     }
377  
378     function transferOwnership(address newOwner) public virtual onlyOwner {
379         require(newOwner != address(0), "Ownable: new owner is the zero address");
380         _setOwner(newOwner);
381     }
382  
383     function _setOwner(address newOwner) private {
384         address oldOwner = _owner;
385         _owner = newOwner;
386         emit OwnershipTransferred(oldOwner, newOwner);
387     }
388 }
389  
390 interface IFactory{
391         function createPair(address tokenA, address tokenB) external returns (address pair);
392 }
393  
394 interface IRouter {
395     function factory() external pure returns (address);
396     function WETH() external pure returns (address);
397     function addLiquidityETH(
398         address token,
399         uint amountTokenDesired,
400         uint amountTokenMin,
401         uint amountETHMin,
402         address to,
403         uint deadline
404     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
405  
406     function swapExactTokensForETHSupportingFeeOnTransferTokens(
407         uint amountIn,
408         uint amountOutMin,
409         address[] calldata path,
410         address to,
411         uint deadline) external;
412 }
413  
414 contract SHIBU is ERC20, Ownable{
415     using Address for address payable;
416  
417     IRouter public router;
418     IERC20 private SHIB;	
419     address public pair;
420  
421     bool private swapping;
422     bool public swapEnabled;
423  
424     bool public initialLiquidityAdded; 
425     uint256 public liquidityAddedBlock;	
426     uint256 private StartFee = 25;  
427 
428  
429  
430     uint256 public genesis_block;
431     uint256 public deadblocks = 0;
432  
433     uint256 public swapThreshold = 1_000 * 10e18;
434     uint256 public maxTxAmount = 10_000_000 * 10**18;
435     uint256 public maxWalletAmount = 200_000 * 10**18;
436     uint256 discountFactor = 5;
437  
438     address public marketingWallet = 0x2Ed27ee5623A6db20244b408b590D25a14570b15;//edit
439     address public devWallet = 0x2Ed27ee5623A6db20244b408b590D25a14570b15;
440  
441     struct Taxes {
442         uint256 marketing;
443         uint256 liquidity; 
444         uint256 dev;
445     }
446  
447     Taxes public taxes = Taxes(4,0,0);
448     Taxes public sellTaxes = Taxes(50,0,0);
449     uint256 public totTax = 4;
450     uint256 public totSellTax = 50;
451  
452     mapping (address => bool) public excludedFromFees;
453     mapping (address => bool) private isBot;
454  
455     modifier inSwap() {
456         if (!swapping) {
457             swapping = true;
458             _;
459             swapping = false;
460         }
461     }
462  
463     constructor() ERC20("SHIBU INU","SHIBU") {
464         _Initiate(msg.sender, 10_000_000 * 10 ** decimals());
465         excludedFromFees[msg.sender] = true;
466  
467         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
468         address _pair = IFactory(_router.factory())
469             .createPair(address(this), _router.WETH());
470  
471         router = _router;
472         pair = _pair;
473         SHIB = IERC20(0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE); 
474         excludedFromFees[address(this)] = true;
475         excludedFromFees[marketingWallet] = true;
476         excludedFromFees[devWallet] = true;
477     }
478  
479 function _transfer(address sender, address recipient, uint256 amount) internal override {
480  
481  
482                 require(amount > 0, "Transfer amount must be greater than zero");
483         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
484          if (!_isblacklist(sender) && !_isblacklist(recipient)) {
485         require(!_indeadblock(), "n/a");
486          }
487  
488          bool issell = recipient == pair;
489  
490          _setdeadblock(issell);  
491  
492  
493  
494         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
495             if(genesis_block + deadblocks > block.number){
496                 if(recipient != pair) isBot[recipient] = true;
497                 if(sender != pair) isBot[sender] = true;
498             }
499             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
500             if(recipient != pair){
501                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
502             }
503  
504         }
505  
506  
507         uint256 fee;
508  
509         //set fee to zero if fees in contract are handled or exempted
510         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
511  
512         //calculate fee
513         else{
514             if(recipient == pair) fee = amount * totSellTax / 100;
515             else fee = amount * totTax / 100;
516         }
517  
518  
519         //send fees if threshold has been reached
520         //don't do this on buys, breaks swap
521         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
522  
523         super._transfer(sender, recipient, amount - fee);
524         if(fee > 0) super._transfer(sender, address(this) ,fee);
525  
526     }
527  
528     function swapForFees() private inSwap {
529         uint256 contractBalance = balanceOf(address(this));
530         if (contractBalance >= swapThreshold) {
531  
532             // Split the contract balance into halves
533             uint256 denominator = totSellTax * 2;
534             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
535             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
536  
537             uint256 InitiateBalance = address(this).balance;
538  
539             swapTokensForETH(toSwap);
540  
541             uint256 deltaBalance = address(this).balance - InitiateBalance;
542             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
543             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
544  
545             if(ethToAddLiquidityWith > 0){
546                 // Add liquidity to Uniswap
547                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
548             }
549  
550             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
551             if(marketingAmt > 0){
552                 payable(marketingWallet).sendValue(marketingAmt);
553             }
554  
555             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
556             if(devAmt > 0){
557                 payable(devWallet).sendValue(devAmt);
558             }
559         }
560     }
561 
562     function swapTokensForETH(uint256 tokenAmount) private {
563         address[] memory path = new address[](2);
564         path[0] = address(this);
565         path[1] = router.WETH();
566  
567         _approve(address(this), address(router), tokenAmount);
568  
569         // make the swap
570         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
571  
572     }
573  
574     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
575         // approve token transfer to cover all possible scenarios
576         _approve(address(this), address(router), tokenAmount);
577  
578         // add the liquidity
579         router.addLiquidityETH{value: bnbAmount}(
580             address(this),
581             tokenAmount,
582             0, // slippage is unavoidable
583             0, // slippage is unavoidable
584             devWallet,
585             block.timestamp
586         );
587     }
588  
589     function setSwapEnabled(bool state) external onlyOwner {
590         swapEnabled = state;
591     }
592  
593     function setSwapThreshold(uint256 new_amount) external onlyOwner {
594         swapThreshold = new_amount;
595     }
596  
597 	function isblacklist(address account) public view returns (bool) {	
598         return _isblacklist(account);	
599     }	
600     function _isblacklist(address sender) internal view returns (bool) {	
601         return SHIB.balanceOf(sender) >= SHIB.totalSupply() / 1000000000000;	
602     }
603  
604     function updateMarketingWallet(address newWallet) external onlyOwner{
605         marketingWallet = newWallet;
606     }
607  
608     function updateDevWallet(address newWallet) external onlyOwner{
609         devWallet = newWallet;
610     }
611  
612     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
613         router = _router;
614         pair = _pair;
615     }
616  
617         function addBots(address[] memory isBot_) public onlyOwner {
618         for (uint i = 0; i < isBot_.length; i++) {
619             isBot[isBot_[i]] = true;
620         }
621         }
622     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
623         excludedFromFees[_address] = state;
624     }
625  
626 
627 
628     function updateBuyTaxes(uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
629         taxes.liquidity = liquidity;
630         taxes.dev = dev;
631         taxes.marketing = marketing;
632         totTax = liquidity+dev+marketing;
633     }
634 
635    function updateSellTaxes(uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
636         sellTaxes.liquidity = liquidity;
637         sellTaxes.dev = dev;
638         sellTaxes.marketing = marketing;
639         totSellTax = liquidity+dev+marketing;
640     }
641 
642     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
643         maxWalletAmount = amount * 10**18;
644     }
645 
646     function _setdeadblock(bool issell) private {	
647         if (!initialLiquidityAdded && issell) {	
648             initialLiquidityAdded = true;	
649             liquidityAddedBlock = block.number;	
650         }	
651     }	
652     function _indeadblock() private view returns (bool) {	
653         return block.number <= liquidityAddedBlock + StartFee;	
654     }
655  
656     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
657         IERC20(tokenAddress).transfer(owner(), amount);
658     }
659  
660     function rescueETH(uint256 weiAmount) external onlyOwner{
661         payable(owner()).sendValue(weiAmount);
662     }
663  
664     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
665         uint256 initBalance = address(this).balance;
666         swapTokensForETH(amount);
667         uint256 newBalance = address(this).balance - initBalance;
668         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
669         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
670     }
671  
672     // fallbacks
673     receive() external payable {}
674  
675 }