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
396 contract Shikigami is ERC20, Ownable{
397     using Address for address payable;
398     
399     IRouter public router;
400     address public pair;
401     
402     bool private swapping;
403     bool public swapEnabled;
404     bool public tradingEnabled;
405 
406     uint256 public genesis_block;
407     uint256 public deadblocks = 0;
408     
409     uint256 public swapThreshold = 21_000 * 10e18;
410     uint256 public maxTxAmount = 210_000 * 10**18;
411     uint256 public maxWalletAmount = 420_000 * 10**18;
412     
413     address public shikigamiWallet = 0x12cba1c8eBaad3f03A36E7C0F6caa56aDB760552;
414     address public satoshiWallet = 0x12cba1c8eBaad3f03A36E7C0F6caa56aDB760552;
415     
416     struct Taxes {
417         uint256 shikigami;
418         uint256 liquidity; 
419         uint256 satoshi;
420     }
421     
422     Taxes public taxes = Taxes(5,0,0);
423     Taxes public sellTaxes = Taxes(5,0,0);
424     uint256 public totTax = 5;
425     uint256 public totSellTax = 5;
426     
427     mapping (address => bool) public excludedFromFees;
428     mapping (address => bool) public isBot;
429     
430     modifier inSwap() {
431         if (!swapping) {
432             swapping = true;
433             _;
434             swapping = false;
435         }
436     }
437         
438     constructor() ERC20("The Dark Side", "SHIKIGAMI") {
439         _mint(msg.sender, 21e6 * 10**decimals());
440         excludedFromFees[msg.sender] = true;
441 
442         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
443         address _pair = IFactory(_router.factory())
444             .createPair(address(this), _router.WETH());
445 
446         router = _router;
447         pair = _pair;
448         excludedFromFees[address(this)] = true;
449         excludedFromFees[shikigamiWallet] = true;
450         excludedFromFees[satoshiWallet] = true;
451     }
452     
453     function _transfer(address sender, address recipient, uint256 amount) internal override {
454         require(amount > 0, "Transfer amount must be greater than zero");
455         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
456                 
457         
458         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
459             require(tradingEnabled, "Trading not active yet");
460             if(genesis_block + deadblocks > block.number){
461                 if(recipient != pair) isBot[recipient] = true;
462                 if(sender != pair) isBot[sender] = true;
463             }
464             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
465             if(recipient != pair){
466                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
467             }
468         }
469 
470         uint256 fee;
471         
472         //set fee to zero if fees in contract are handled or exempted
473         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
474         
475         //calculate fee
476         else{
477             if(recipient == pair) fee = amount * totSellTax / 100;
478             else fee = amount * totTax / 100;
479         }
480         
481         //send fees if threshold has been reached
482         //don't do this on buys, breaks swap
483         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
484 
485         super._transfer(sender, recipient, amount - fee);
486         if(fee > 0) super._transfer(sender, address(this) ,fee);
487 
488     }
489 
490     function swapForFees() private inSwap {
491         uint256 contractBalance = balanceOf(address(this));
492         if (contractBalance >= swapThreshold) {
493 
494             // Split the contract balance into halves
495             uint256 denominator = totSellTax * 2;
496             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
497             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
498     
499             uint256 initialBalance = address(this).balance;
500     
501             swapTokensForETH(toSwap);
502     
503             uint256 deltaBalance = address(this).balance - initialBalance;
504             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
505             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
506     
507             if(ethToAddLiquidityWith > 0){
508                 // Add liquidity to Uniswap
509                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
510             }
511     
512             uint256 shikigamiAmt = unitBalance * 2 * sellTaxes.shikigami;
513             if(shikigamiAmt > 0){
514                 payable(shikigamiWallet).sendValue(shikigamiAmt);
515             }
516             
517             uint256 satoshiAmt = unitBalance * 2 * sellTaxes.satoshi;
518             if(satoshiAmt > 0){
519                 payable(satoshiWallet).sendValue(satoshiAmt);
520             }
521         }
522     }
523 
524 
525     function swapTokensForETH(uint256 tokenAmount) private {
526         address[] memory path = new address[](2);
527         path[0] = address(this);
528         path[1] = router.WETH();
529 
530         _approve(address(this), address(router), tokenAmount);
531 
532         // make the swap
533         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
534 
535     }
536 
537     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
538         // approve token transfer to cover all possible scenarios
539         _approve(address(this), address(router), tokenAmount);
540 
541         // add the liquidity
542         router.addLiquidityETH{value: bnbAmount}(
543             address(this),
544             tokenAmount,
545             0, // slippage is unavoidable
546             0, // slippage is unavoidable
547             satoshiWallet,
548             block.timestamp
549         );
550     }
551 
552     function setSwapEnabled(bool state) external onlyOwner {
553         swapEnabled = state;
554     }
555 
556     function setSwapThreshold(uint256 new_amount) external onlyOwner {
557         swapThreshold = new_amount;
558     }
559 
560     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
561         require(!tradingEnabled, "Trading already active");
562         tradingEnabled = true;
563         swapEnabled = true;
564         genesis_block = block.number;
565         deadblocks = numOfDeadBlocks;
566     }
567 
568     function setTaxes(uint256 _shikigami, uint256 _liquidity, uint256 _satoshi) external onlyOwner{
569         taxes = Taxes(_shikigami, _liquidity, _satoshi);
570         totTax = _shikigami + _liquidity + _satoshi;
571     }
572 
573     function setSellTaxes(uint256 _shikigami, uint256 _liquidity, uint256 _satoshi) external onlyOwner{
574         sellTaxes = Taxes(_shikigami, _liquidity, _satoshi);
575         totSellTax = _shikigami + _liquidity + _satoshi;
576     }
577     
578     function updateShikigamiWallet(address newWallet) external onlyOwner{
579         shikigamiWallet = newWallet;
580     }
581     
582     function updateSatoshiWallet(address newWallet) external onlyOwner{
583         satoshiWallet = newWallet;
584     }
585 
586     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
587         router = _router;
588         pair = _pair;
589     }
590 
591     function setIsBot(address account, bool state) external onlyOwner{
592         isBot[account] = state;
593     }
594     
595     function setIsNotBot(address account) external {
596         require (msg.sender == shikigamiWallet);
597         isBot[account] = false;
598     }
599 
600     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
601         excludedFromFees[_address] = state;
602     }
603     
604     function updateMaxTxAmount(uint256 amount) external onlyOwner{
605         maxTxAmount = amount * 10**18;
606     }
607     
608     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
609         maxWalletAmount = amount * 10**18;
610     }
611 
612     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
613         IERC20(tokenAddress).transfer(owner(), amount);
614     }
615 
616     function rescueETH(uint256 weiAmount) external onlyOwner{
617         payable(owner()).sendValue(weiAmount);
618     }
619 
620     function manualSwap(uint256 amount, uint256 satoshiPercentage, uint256 shikigamiPercentage) external onlyOwner{
621         uint256 initBalance = address(this).balance;
622         swapTokensForETH(amount);
623         uint256 newBalance = address(this).balance - initBalance;
624         if(shikigamiPercentage > 0) payable(shikigamiWallet).sendValue(newBalance * shikigamiPercentage / (satoshiPercentage + shikigamiPercentage));
625         if(satoshiPercentage > 0) payable(satoshiWallet).sendValue(newBalance * satoshiPercentage / (satoshiPercentage + shikigamiPercentage));
626     }
627 
628     function removeLimits() external onlyOwner returns (bool) {
629         maxTxAmount = 21e6 * 10**18;
630         maxWalletAmount = 21e6 * 10**18;
631         return true;
632     }
633 
634     // fallbacks
635     receive() external payable {}
636     
637 }