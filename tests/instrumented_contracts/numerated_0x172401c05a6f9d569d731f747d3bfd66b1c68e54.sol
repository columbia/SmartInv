1 //SPDX-License-Identifier: MIT
2 
3 /*
4 
5 Black Network $BLACK 🔲🔲🔲
6 
7 What is 🔎
8 Black Network is a technology for building apps and organizations, holding assets, transacting and communicating without being controlled by a central authority. There is no need to hand over all your personal details to use Black Network - you keep control of your own data and what is being shared.
9 
10 Token ◼️
11 $BLACK is a decentralized token on the Ethereum Chain first. Created by the blockchain specialists with the main purpose of build and explore on the Black Network
12 
13 Tokenomics⚫
14 Max Buy: 3%
15 Max Wallet 3%
16 Tax 3% Buy/Sell
17 
18 Telegram: https://t.me/NETWORKBLACKERC
19 Twitter: https://twitter.com/BLACKERCNETWORK
20 
21 */
22 
23 pragma solidity 0.8.12;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38 
39     function balanceOf(address account) external view returns (uint256);
40 
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     function transferFrom(
48         address sender,
49         address recipient,
50         uint256 amount
51     ) external returns (bool);
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 interface IERC20Metadata is IERC20 {
59     /**
60      * @dev Returns the name of the token.
61      */
62     function name() external view returns (string memory);
63 
64     /**
65      * @dev Returns the symbol of the token.
66      */
67     function symbol() external view returns (string memory);
68 
69     /**
70      * @dev Returns the decimals places of the token.
71      */
72     function decimals() external view returns (uint8);
73 }
74 
75 
76 contract ERC20 is Context, IERC20, IERC20Metadata {
77     mapping (address => uint256) internal _balances;
78 
79     mapping (address => mapping (address => uint256)) internal _allowances;
80 
81     uint256 private _totalSupply;
82 
83     string private _name;
84     string private _symbol;
85 
86     /**
87      * @dev Sets the values for {name} and {symbol}.
88      *
89      * The defaut value of {decimals} is 18. To select a different value for
90      * {decimals} you should overload it.
91      *
92      * All two of these values are immutable: they can only be set once during
93      * construction.
94      */
95     constructor (string memory name_, string memory symbol_) {
96         _name = name_;
97         _symbol = symbol_;
98     }
99 
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() public view virtual override returns (string memory) {
104         return _name;
105     }
106 
107     /**
108      * @dev Returns the symbol of the token, usually a shorter version of the
109      * name.
110      */
111     function symbol() public view virtual override returns (string memory) {
112         return _symbol;
113     }
114 
115     /**
116      * @dev Returns the number of decimals used to get its user representation.
117      * For example, if `decimals` equals `2`, a balance of `505` tokens should
118      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
119      *
120      * Tokens usually opt for a value of 18, imitating the relationship between
121      * Ether and Wei. This is the value {ERC20} uses, unless this function is
122      * overridden;
123      *
124      * NOTE: This information is only used for _display_ purposes: it in
125      * no way affects any of the arithmetic of the contract, including
126      * {IERC20-balanceOf} and {IERC20-transfer}.
127      */
128     function decimals() public view virtual override returns (uint8) {
129         return 18;
130     }
131 
132     /**
133      * @dev See {IERC20-totalSupply}.
134      */
135     function totalSupply() public view virtual override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     /**
140      * @dev See {IERC20-balanceOf}.
141      */
142     function balanceOf(address account) public view virtual override returns (uint256) {
143         return _balances[account];
144     }
145 
146     /**
147      * @dev See {IERC20-transfer}.
148      *
149      * Requirements:
150      *
151      * - `recipient` cannot be the zero address.
152      * - the caller must have a balance of at least `amount`.
153      */
154     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
155         _transfer(_msgSender(), recipient, amount);
156         return true;
157     }
158 
159     /**
160      * @dev See {IERC20-allowance}.
161      */
162     function allowance(address owner, address spender) public view virtual override returns (uint256) {
163         return _allowances[owner][spender];
164     }
165 
166     /**
167      * @dev See {IERC20-approve}.
168      *
169      * Requirements:
170      *
171      * - `spender` cannot be the zero address.
172      */
173     function approve(address spender, uint256 amount) public virtual override returns (bool) {
174         _approve(_msgSender(), spender, amount);
175         return true;
176     }
177 
178     /**
179      * @dev See {IERC20-transferFrom}.
180      *
181      * Emits an {Approval} event indicating the updated allowance. This is not
182      * required by the EIP. See the note at the beginning of {ERC20}.
183      *
184      * Requirements:
185      *
186      * - `sender` and `recipient` cannot be the zero address.
187      * - `sender` must have a balance of at least `amount`.
188      * - the caller must have allowance for ``sender``'s tokens of at least
189      * `amount`.
190      */
191     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
192         _transfer(sender, recipient, amount);
193 
194         uint256 currentAllowance = _allowances[sender][_msgSender()];
195         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
196         _approve(sender, _msgSender(), currentAllowance - amount);
197 
198         return true;
199     }
200 
201     /**
202      * @dev Atomically increases the allowance granted to `spender` by the caller.
203      *
204      * This is an alternative to {approve} that can be used as a mitigation for
205      * problems described in {IERC20-approve}.
206      *
207      * Emits an {Approval} event indicating the updated allowance.
208      *
209      * Requirements:
210      *
211      * - `spender` cannot be the zero address.
212      */
213     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
214         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
215         return true;
216     }
217 
218     /**
219      * @dev Atomically decreases the allowance granted to `spender` by the caller.
220      *
221      * This is an alternative to {approve} that can be used as a mitigation for
222      * problems described in {IERC20-approve}.
223      *
224      * Emits an {Approval} event indicating the updated allowance.
225      *
226      * Requirements:
227      *
228      * - `spender` cannot be the zero address.
229      * - `spender` must have allowance for the caller of at least
230      * `subtractedValue`.
231      */
232     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
233         uint256 currentAllowance = _allowances[_msgSender()][spender];
234         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
235         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
236 
237         return true;
238     }
239 
240     /**
241      * @dev Moves tokens `amount` from `sender` to `recipient`.
242      *
243      * This is internal function is equivalent to {transfer}, and can be used to
244      * e.g. implement automatic token fees, slashing mechanisms, etc.
245      *
246      * Emits a {Transfer} event.
247      *
248      * Requirements:
249      *
250      * - `sender` cannot be the zero address.
251      * - `recipient` cannot be the zero address.
252      * - `sender` must have a balance of at least `amount`.
253      */
254     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
255         require(sender != address(0), "ERC20: transfer from the zero address");
256         require(recipient != address(0), "ERC20: transfer to the zero address");
257 
258         _beforeTokenTransfer(sender, recipient, amount);
259 
260         uint256 senderBalance = _balances[sender];
261         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
262         _balances[sender] = senderBalance - amount;
263         _balances[recipient] += amount;
264 
265         emit Transfer(sender, recipient, amount);
266     }
267 
268     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
269      * the total supply.
270      *
271      * Emits a {Transfer} event with `from` set to the zero address.
272      *
273      * Requirements:
274      *
275      * - `to` cannot be the zero address.
276      */
277     function _mint(address account, uint256 amount) internal virtual {
278         require(account != address(0), "ERC20: mint to the zero address");
279 
280         _beforeTokenTransfer(address(0), account, amount);
281 
282         _totalSupply += amount;
283         _balances[account] += amount;
284         emit Transfer(address(0), account, amount);
285     }
286 
287     /**
288      * @dev Destroys `amount` tokens from `account`, reducing the
289      * total supply.
290      *
291      * Emits a {Transfer} event with `to` set to the zero address.
292      *
293      * Requirements:
294      *
295      * - `account` cannot be the zero address.
296      * - `account` must have at least `amount` tokens.
297      */
298     function _burn(address account, uint256 amount) internal virtual {
299         require(account != address(0), "ERC20: burn from the zero address");
300 
301         _beforeTokenTransfer(account, address(0), amount);
302 
303         uint256 accountBalance = _balances[account];
304         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
305         _balances[account] = accountBalance - amount;
306         _totalSupply -= amount;
307 
308         emit Transfer(account, address(0), amount);
309     }
310 
311     /**
312      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
313      *
314      * This internal function is equivalent to `approve`, and can be used to
315      * e.g. set automatic allowances for certain subsystems, etc.
316      *
317      * Emits an {Approval} event.
318      *
319      * Requirements:
320      *
321      * - `owner` cannot be the zero address.
322      * - `spender` cannot be the zero address.
323      */
324     function _approve(address owner, address spender, uint256 amount) internal virtual {
325         require(owner != address(0), "ERC20: approve from the zero address");
326         require(spender != address(0), "ERC20: approve to the zero address");
327 
328         _allowances[owner][spender] = amount;
329         emit Approval(owner, spender, amount);
330     }
331 
332     /**
333      * @dev Hook that is called before any transfer of tokens. This includes
334      * minting and burning.
335      *
336      * Calling conditions:
337      *
338      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
339      * will be to transferred to `to`.
340      * - when `from` is zero, `amount` tokens will be minted for `to`.
341      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
342      * - `from` and `to` are never both zero.
343      *
344      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
345      */
346     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
347 }
348 
349 library Address{
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         (bool success, ) = recipient.call{value: amount}("");
354         require(success, "Address: unable to send value, recipient may have reverted");
355     }
356 }
357 
358 abstract contract Ownable is Context {
359     address private _owner;
360 
361     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
362 
363     constructor() {
364         _setOwner(_msgSender());
365     }
366 
367     function owner() public view virtual returns (address) {
368         return _owner;
369     }
370 
371     modifier onlyOwner() {
372         require(owner() == _msgSender(), "Ownable: caller is not the owner");
373         _;
374     }
375 
376     function renounceOwnership() public virtual onlyOwner {
377         _setOwner(address(0));
378     }
379 
380     function transferOwnership(address newOwner) public virtual onlyOwner {
381         require(newOwner != address(0), "Ownable: new owner is the zero address");
382         _setOwner(newOwner);
383     }
384 
385     function _setOwner(address newOwner) private {
386         address oldOwner = _owner;
387         _owner = newOwner;
388         emit OwnershipTransferred(oldOwner, newOwner);
389     }
390 }
391 
392 interface IFactory{
393         function createPair(address tokenA, address tokenB) external returns (address pair);
394 }
395 
396 interface IRouter {
397     function factory() external pure returns (address);
398     function WETH() external pure returns (address);
399     function addLiquidityETH(
400         address token,
401         uint amountTokenDesired,
402         uint amountTokenMin,
403         uint amountETHMin,
404         address to,
405         uint deadline
406     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
407 
408     function swapExactTokensForETHSupportingFeeOnTransferTokens(
409         uint amountIn,
410         uint amountOutMin,
411         address[] calldata path,
412         address to,
413         uint deadline) external;
414 }
415 
416 contract CONTRACT is ERC20, Ownable{
417     using Address for address payable;
418     
419     IRouter public router;
420     address public pair;
421     
422     bool private swapping;
423     bool public swapEnabled;
424     bool public tradingEnabled;
425 
426     uint256 public genesis_block;
427     uint256 public deadblocks = 0;
428     
429     uint256 public swapThreshold = 100_000 * 10e18;
430     uint256 public maxTxAmount = 100_000_000 * 10**18;
431     uint256 public maxWalletAmount = 3_000_000 * 10**18;
432     
433     address public marketingWallet = 0x475B0B7aaB3D872AaA159eceeCc185a77B5EA9Ba;
434     address public devWallet = 0x475B0B7aaB3D872AaA159eceeCc185a77B5EA9Ba;
435     
436     struct Taxes {
437         uint256 marketing;
438         uint256 liquidity; 
439         uint256 dev;
440     }
441     
442     Taxes public taxes = Taxes(10,0,0);
443     Taxes public sellTaxes = Taxes(20,0,0);
444     uint256 public totTax = 10;
445     uint256 public totSellTax = 10;
446     
447     mapping (address => bool) public excludedFromFees;
448     mapping (address => bool) public isBot;
449     
450     modifier inSwap() {
451         if (!swapping) {
452             swapping = true;
453             _;
454             swapping = false;
455         }
456     }
457         
458     constructor() ERC20("Black Network", "BLACK") {
459         _mint(msg.sender, 100000000 * 10 ** decimals());
460         excludedFromFees[msg.sender] = true;
461 
462         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
463         address _pair = IFactory(_router.factory())
464             .createPair(address(this), _router.WETH());
465 
466         router = _router;
467         pair = _pair;
468         excludedFromFees[address(this)] = true;
469         excludedFromFees[marketingWallet] = true;
470         excludedFromFees[devWallet] = true;
471     }
472     
473     function _transfer(address sender, address recipient, uint256 amount) internal override {
474         require(amount > 0, "Transfer amount must be greater than zero");
475         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
476                 
477         
478         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
479             require(tradingEnabled, "Trading not active yet");
480             if(genesis_block + deadblocks > block.number){
481                 if(recipient != pair) isBot[recipient] = true;
482                 if(sender != pair) isBot[sender] = true;
483             }
484             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
485             if(recipient != pair){
486                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
487             }
488         }
489 
490         uint256 fee;
491         
492         //set fee to zero if fees in contract are handled or exempted
493         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
494         
495         //calculate fee
496         else{
497             if(recipient == pair) fee = amount * totSellTax / 100;
498             else fee = amount * totTax / 100;
499         }
500         
501         //send fees if threshold has been reached
502         //don't do this on buys, breaks swap
503         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
504 
505         super._transfer(sender, recipient, amount - fee);
506         if(fee > 0) super._transfer(sender, address(this) ,fee);
507 
508     }
509 
510     function swapForFees() private inSwap {
511         uint256 contractBalance = balanceOf(address(this));
512         if (contractBalance >= swapThreshold) {
513 
514             // Split the contract balance into halves
515             uint256 denominator = totSellTax * 2;
516             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
517             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
518     
519             uint256 initialBalance = address(this).balance;
520     
521             swapTokensForETH(toSwap);
522     
523             uint256 deltaBalance = address(this).balance - initialBalance;
524             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
525             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
526     
527             if(ethToAddLiquidityWith > 0){
528                 // Add liquidity to Uniswap
529                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
530             }
531     
532             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
533             if(marketingAmt > 0){
534                 payable(marketingWallet).sendValue(marketingAmt);
535             }
536             
537             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
538             if(devAmt > 0){
539                 payable(devWallet).sendValue(devAmt);
540             }
541         }
542     }
543 
544 
545     function swapTokensForETH(uint256 tokenAmount) private {
546         address[] memory path = new address[](2);
547         path[0] = address(this);
548         path[1] = router.WETH();
549 
550         _approve(address(this), address(router), tokenAmount);
551 
552         // make the swap
553         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
554 
555     }
556 
557     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
558         // approve token transfer to cover all possible scenarios
559         _approve(address(this), address(router), tokenAmount);
560 
561         // add the liquidity
562         router.addLiquidityETH{value: bnbAmount}(
563             address(this),
564             tokenAmount,
565             0, // slippage is unavoidable
566             0, // slippage is unavoidable
567             devWallet,
568             block.timestamp
569         );
570     }
571 
572     function setSwapEnabled(bool state) external onlyOwner {
573         swapEnabled = state;
574     }
575 
576     function setSwapThreshold(uint256 new_amount) external onlyOwner {
577         swapThreshold = new_amount;
578     }
579 
580     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
581         require(!tradingEnabled, "Trading already active");
582         tradingEnabled = true;
583         swapEnabled = true;
584         genesis_block = block.number;
585         deadblocks = numOfDeadBlocks;
586     }
587 
588     function setTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
589         taxes = Taxes(_marketing, _liquidity, _dev);
590         totTax = _marketing + _liquidity + _dev;
591     }
592 
593     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
594         sellTaxes = Taxes(_marketing, _liquidity, _dev);
595         totSellTax = _marketing + _liquidity + _dev;
596     }
597     
598     function updateMarketingWallet(address newWallet) external onlyOwner{
599         marketingWallet = newWallet;
600     }
601     
602     function updateDevWallet(address newWallet) external onlyOwner{
603         devWallet = newWallet;
604     }
605 
606     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
607         router = _router;
608         pair = _pair;
609     }
610     
611     function setIsBot(address account, bool state) external onlyOwner{
612         isBot[account] = state;
613     }
614 
615     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
616         excludedFromFees[_address] = state;
617     }
618     
619     function updateMaxTxAmount(uint256 amount) external onlyOwner{
620         maxTxAmount = amount * 10**18;
621     }
622     
623     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
624         maxWalletAmount = amount * 10**18;
625     }
626 
627     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
628         IERC20(tokenAddress).transfer(owner(), amount);
629     }
630 
631     function rescueETH(uint256 weiAmount) external onlyOwner{
632         payable(owner()).sendValue(weiAmount);
633     }
634 
635     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
636         uint256 initBalance = address(this).balance;
637         swapTokensForETH(amount);
638         uint256 newBalance = address(this).balance - initBalance;
639         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
640         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
641     }
642 
643     // fallbacks
644     receive() external payable {}
645     
646 }