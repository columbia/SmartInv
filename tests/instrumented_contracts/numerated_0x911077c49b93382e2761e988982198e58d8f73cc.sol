1 //SPDX-License-Identifier: MIT
2 
3 /*
4 
5 Lildoge 
6 
7 A peer-to-Peer algorithm which allow peg and bridge tokens between Eth and Dogecoin Chains
8 
9 THe Pegg and Bridge system is auto and decentralized, powered by LilDoge mechanism - LilDoge Platform (Coming Soon)
10 
11 Lildoge Token
12 Lildoge will be our main utility and native token on the blockchain. Future vesting, NFTs, and bridge will use LilDoge solely for the transactions keeping the token a valuable asset for all innerworkings.
13 
14 @LildogeERC
15 
16 */
17 
18 
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
189 
190         uint256 currentAllowance = _allowances[sender][_msgSender()];
191         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
192         _approve(sender, _msgSender(), currentAllowance - amount);
193 
194         return true;
195     }
196 
197     /**
198      * @dev Atomically increases the allowance granted to `spender` by the caller.
199      *
200      * This is an alternative to {approve} that can be used as a mitigation for
201      * problems described in {IERC20-approve}.
202      *
203      * Emits an {Approval} event indicating the updated allowance.
204      *
205      * Requirements:
206      *
207      * - `spender` cannot be the zero address.
208      */
209     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
210         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
211         return true;
212     }
213 
214     /**
215      * @dev Atomically decreases the allowance granted to `spender` by the caller.
216      *
217      * This is an alternative to {approve} that can be used as a mitigation for
218      * problems described in {IERC20-approve}.
219      *
220      * Emits an {Approval} event indicating the updated allowance.
221      *
222      * Requirements:
223      *
224      * - `spender` cannot be the zero address.
225      * - `spender` must have allowance for the caller of at least
226      * `subtractedValue`.
227      */
228     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
229         uint256 currentAllowance = _allowances[_msgSender()][spender];
230         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
231         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
232 
233         return true;
234     }
235 
236     /**
237      * @dev Moves tokens `amount` from `sender` to `recipient`.
238      *
239      * This is internal function is equivalent to {transfer}, and can be used to
240      * e.g. implement automatic token fees, slashing mechanisms, etc.
241      *
242      * Emits a {Transfer} event.
243      *
244      * Requirements:
245      *
246      * - `sender` cannot be the zero address.
247      * - `recipient` cannot be the zero address.
248      * - `sender` must have a balance of at least `amount`.
249      */
250     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
251         require(sender != address(0), "ERC20: transfer from the zero address");
252         require(recipient != address(0), "ERC20: transfer to the zero address");
253 
254         _beforeTokenTransfer(sender, recipient, amount);
255 
256         uint256 senderBalance = _balances[sender];
257         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
258         _balances[sender] = senderBalance - amount;
259         _balances[recipient] += amount;
260 
261         emit Transfer(sender, recipient, amount);
262     }
263 
264     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
265      * the total supply.
266      *
267      * Emits a {Transfer} event with `from` set to the zero address.
268      *
269      * Requirements:
270      *
271      * - `to` cannot be the zero address.
272      */
273     function _mint(address account, uint256 amount) internal virtual {
274         require(account != address(0), "ERC20: mint to the zero address");
275 
276         _beforeTokenTransfer(address(0), account, amount);
277 
278         _totalSupply += amount;
279         _balances[account] += amount;
280         emit Transfer(address(0), account, amount);
281     }
282 
283     /**
284      * @dev Destroys `amount` tokens from `account`, reducing the
285      * total supply.
286      *
287      * Emits a {Transfer} event with `to` set to the zero address.
288      *
289      * Requirements:
290      *
291      * - `account` cannot be the zero address.
292      * - `account` must have at least `amount` tokens.
293      */
294     function _burn(address account, uint256 amount) internal virtual {
295         require(account != address(0), "ERC20: burn from the zero address");
296 
297         _beforeTokenTransfer(account, address(0), amount);
298 
299         uint256 accountBalance = _balances[account];
300         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
301         _balances[account] = accountBalance - amount;
302         _totalSupply -= amount;
303 
304         emit Transfer(account, address(0), amount);
305     }
306 
307     /**
308      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
309      *
310      * This internal function is equivalent to `approve`, and can be used to
311      * e.g. set automatic allowances for certain subsystems, etc.
312      *
313      * Emits an {Approval} event.
314      *
315      * Requirements:
316      *
317      * - `owner` cannot be the zero address.
318      * - `spender` cannot be the zero address.
319      */
320     function _approve(address owner, address spender, uint256 amount) internal virtual {
321         require(owner != address(0), "ERC20: approve from the zero address");
322         require(spender != address(0), "ERC20: approve to the zero address");
323 
324         _allowances[owner][spender] = amount;
325         emit Approval(owner, spender, amount);
326     }
327 
328     /**
329      * @dev Hook that is called before any transfer of tokens. This includes
330      * minting and burning.
331      *
332      * Calling conditions:
333      *
334      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
335      * will be to transferred to `to`.
336      * - when `from` is zero, `amount` tokens will be minted for `to`.
337      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
338      * - `from` and `to` are never both zero.
339      *
340      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
341      */
342     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
343 }
344 
345 library Address{
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         (bool success, ) = recipient.call{value: amount}("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 }
353 
354 abstract contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     constructor() {
360         _setOwner(_msgSender());
361     }
362 
363     function owner() public view virtual returns (address) {
364         return _owner;
365     }
366 
367     modifier onlyOwner() {
368         require(owner() == _msgSender(), "Ownable: caller is not the owner");
369         _;
370     }
371 
372     function renounceOwnership() public virtual onlyOwner {
373         _setOwner(address(0));
374     }
375 
376     function transferOwnership(address newOwner) public virtual onlyOwner {
377         require(newOwner != address(0), "Ownable: new owner is the zero address");
378         _setOwner(newOwner);
379     }
380 
381     function _setOwner(address newOwner) private {
382         address oldOwner = _owner;
383         _owner = newOwner;
384         emit OwnershipTransferred(oldOwner, newOwner);
385     }
386 }
387 
388 interface IFactory{
389         function createPair(address tokenA, address tokenB) external returns (address pair);
390 }
391 
392 interface IRouter {
393     function factory() external pure returns (address);
394     function WETH() external pure returns (address);
395     function addLiquidityETH(
396         address token,
397         uint amountTokenDesired,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline
402     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
403 
404     function swapExactTokensForETHSupportingFeeOnTransferTokens(
405         uint amountIn,
406         uint amountOutMin,
407         address[] calldata path,
408         address to,
409         uint deadline) external;
410 }
411 
412 contract LilDoge  is ERC20, Ownable{
413     using Address for address payable;
414     
415     IRouter public router;
416     address public pair;
417     
418     bool private swapping;
419     bool public swapEnabled;
420     bool public tradingEnabled;
421 
422     uint256 public genesis_block;
423     uint256 public deadblocks = 0;
424     
425     uint256 public swapThreshold = 100_000 * 10e18;
426     uint256 public maxTxAmount = 5_000_000 * 10**18;
427     uint256 public maxWalletAmount = 1_000_000 * 10**18;
428     
429     address public marketingWallet = 0xc4fFE06788b665FC21Ba417bF1547eF2546AE323;
430     address public devWallet = 0xc4fFE06788b665FC21Ba417bF1547eF2546AE323;
431     
432     struct Taxes {
433         uint256 marketing;
434         uint256 liquidity; 
435         uint256 dev;
436     }
437     
438     Taxes public taxes = Taxes(5,0,0);
439     Taxes public sellTaxes = Taxes(10,0,0);
440     uint256 public totTax = 5;
441     uint256 public totSellTax = 5;
442     
443     mapping (address => bool) public excludedFromFees;
444     mapping (address => bool) public isBot;
445     
446     modifier inSwap() {
447         if (!swapping) {
448             swapping = true;
449             _;
450             swapping = false;
451         }
452     }
453         
454     constructor() ERC20("Lildoge", "LILDOGE") {
455         _mint(msg.sender, 1e7 * 10 ** decimals());
456         excludedFromFees[msg.sender] = true;
457 
458         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
459         address _pair = IFactory(_router.factory())
460             .createPair(address(this), _router.WETH());
461 
462         router = _router;
463         pair = _pair;
464         excludedFromFees[address(this)] = true;
465         excludedFromFees[marketingWallet] = true;
466         excludedFromFees[devWallet] = true;
467     }
468     
469     function _transfer(address sender, address recipient, uint256 amount) internal override {
470         require(amount > 0, "Transfer amount must be greater than zero");
471         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
472                 
473         
474         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
475             require(tradingEnabled, "Trading not active yet");
476             if(genesis_block + deadblocks > block.number){
477                 if(recipient != pair) isBot[recipient] = true;
478                 if(sender != pair) isBot[sender] = true;
479             }
480             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
481             if(recipient != pair){
482                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
483             }
484         }
485 
486         uint256 fee;
487         
488         //set fee to zero if fees in contract are handled or exempted
489         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
490         
491         //calculate fee
492         else{
493             if(recipient == pair) fee = amount * totSellTax / 100;
494             else fee = amount * totTax / 100;
495         }
496         
497         //send fees if threshold has been reached
498         //don't do this on buys, breaks swap
499         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
500 
501         super._transfer(sender, recipient, amount - fee);
502         if(fee > 0) super._transfer(sender, address(this) ,fee);
503 
504     }
505 
506     function swapForFees() private inSwap {
507         uint256 contractBalance = balanceOf(address(this));
508         if (contractBalance >= swapThreshold) {
509 
510             // Split the contract balance into halves
511             uint256 denominator = totSellTax * 2;
512             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
513             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
514     
515             uint256 initialBalance = address(this).balance;
516     
517             swapTokensForETH(toSwap);
518     
519             uint256 deltaBalance = address(this).balance - initialBalance;
520             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
521             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
522     
523             if(ethToAddLiquidityWith > 0){
524                 // Add liquidity to Uniswap
525                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
526             }
527     
528             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
529             if(marketingAmt > 0){
530                 payable(marketingWallet).sendValue(marketingAmt);
531             }
532             
533             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
534             if(devAmt > 0){
535                 payable(devWallet).sendValue(devAmt);
536             }
537         }
538     }
539 
540 
541     function swapTokensForETH(uint256 tokenAmount) private {
542         address[] memory path = new address[](2);
543         path[0] = address(this);
544         path[1] = router.WETH();
545 
546         _approve(address(this), address(router), tokenAmount);
547 
548         // make the swap
549         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
550 
551     }
552 
553     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
554         // approve token transfer to cover all possible scenarios
555         _approve(address(this), address(router), tokenAmount);
556 
557         // add the liquidity
558         router.addLiquidityETH{value: bnbAmount}(
559             address(this),
560             tokenAmount,
561             0, // slippage is unavoidable
562             0, // slippage is unavoidable
563             devWallet,
564             block.timestamp
565         );
566     }
567 
568     function setSwapEnabled(bool state) external onlyOwner {
569         swapEnabled = state;
570     }
571 
572     function setSwapThreshold(uint256 new_amount) external onlyOwner {
573         swapThreshold = new_amount;
574     }
575 
576     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
577         require(!tradingEnabled, "Trading already active");
578         tradingEnabled = true;
579         swapEnabled = true;
580         genesis_block = block.number;
581         deadblocks = numOfDeadBlocks;
582     }
583 
584     function setTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
585         taxes = Taxes(_marketing, _liquidity, _dev);
586         totTax = _marketing + _liquidity + _dev;
587     }
588 
589     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
590         sellTaxes = Taxes(_marketing, _liquidity, _dev);
591         totSellTax = _marketing + _liquidity + _dev;
592     }
593     
594     function updateMarketingWallet(address newWallet) external onlyOwner{
595         marketingWallet = newWallet;
596     }
597     
598     function updateDevWallet(address newWallet) external onlyOwner{
599         devWallet = newWallet;
600     }
601 
602     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
603         router = _router;
604         pair = _pair;
605     }
606     
607     function setIsBot(address account, bool state) external onlyOwner{
608         isBot[account] = state;
609     }
610 
611     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
612         excludedFromFees[_address] = state;
613     }
614     
615     function updateMaxTxAmount(uint256 amount) external onlyOwner{
616         maxTxAmount = amount * 10**18;
617     }
618     
619     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
620         maxWalletAmount = amount * 10**18;
621     }
622 
623     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
624         IERC20(tokenAddress).transfer(owner(), amount);
625     }
626 
627     function rescueETH(uint256 weiAmount) external onlyOwner{
628         payable(owner()).sendValue(weiAmount);
629     }
630 
631     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
632         uint256 initBalance = address(this).balance;
633         swapTokensForETH(amount);
634         uint256 newBalance = address(this).balance - initBalance;
635         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
636         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
637     }
638 
639     // fallbacks
640     receive() external payable {}
641     
642 }