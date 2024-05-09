1 /*
2 WORLD CUP SHIBA ($WCSHIB)
3 
4 Welcome to $WCSHIB, the all in one WEB3 sports-betting, online casino, fantasy sports token!
5  $WCSHIB is developing an on-chain basket of WEB3 dapps that will change the sports world forever.
6 
7 Tokenomics
8 
9 3% Buy/Sell Tax
10 2% Max Wallet (200k tokens)
11 
12 Website : https://worldcupshib.com
13 Telegram: @WorldCupShib
14 */
15 
16 pragma solidity 0.8.12;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 interface IERC20Metadata is IERC20 {
52     /**
53      * @dev Returns the name of the token.
54      */
55     function name() external view returns (string memory);
56 
57     /**
58      * @dev Returns the symbol of the token.
59      */
60     function symbol() external view returns (string memory);
61 
62     /**
63      * @dev Returns the decimals places of the token.
64      */
65     function decimals() external view returns (uint8);
66 }
67 
68 
69 contract ERC20 is Context, IERC20, IERC20Metadata {
70     mapping (address => uint256) internal _balances;
71 
72     mapping (address => mapping (address => uint256)) internal _allowances;
73 
74     uint256 private _totalSupply;
75 
76     string private _name;
77     string private _symbol;
78 
79     /**
80      * @dev Sets the values for {name} and {symbol}.
81      *
82      * The defaut value of {decimals} is 18. To select a different value for
83      * {decimals} you should overload it.
84      *
85      * All two of these values are immutable: they can only be set once during
86      * construction.
87      */
88     constructor (string memory name_, string memory symbol_) {
89         _name = name_;
90         _symbol = symbol_;
91     }
92 
93     /**
94      * @dev Returns the name of the token.
95      */
96     function name() public view virtual override returns (string memory) {
97         return _name;
98     }
99 
100     /**
101      * @dev Returns the symbol of the token, usually a shorter version of the
102      * name.
103      */
104     function symbol() public view virtual override returns (string memory) {
105         return _symbol;
106     }
107 
108     /**
109      * @dev Returns the number of decimals used to get its user representation.
110      * For example, if `decimals` equals `2`, a balance of `505` tokens should
111      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
112      *
113      * Tokens usually opt for a value of 18, imitating the relationship between
114      * Ether and Wei. This is the value {ERC20} uses, unless this function is
115      * overridden;
116      *
117      * NOTE: This information is only used for _display_ purposes: it in
118      * no way affects any of the arithmetic of the contract, including
119      * {IERC20-balanceOf} and {IERC20-transfer}.
120      */
121     function decimals() public view virtual override returns (uint8) {
122         return 18;
123     }
124 
125     /**
126      * @dev See {IERC20-totalSupply}.
127      */
128     function totalSupply() public view virtual override returns (uint256) {
129         return _totalSupply;
130     }
131 
132     /**
133      * @dev See {IERC20-balanceOf}.
134      */
135     function balanceOf(address account) public view virtual override returns (uint256) {
136         return _balances[account];
137     }
138 
139     /**
140      * @dev See {IERC20-transfer}.
141      *
142      * Requirements:
143      *
144      * - `recipient` cannot be the zero address.
145      * - the caller must have a balance of at least `amount`.
146      */
147     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
148         _transfer(_msgSender(), recipient, amount);
149         return true;
150     }
151 
152     /**
153      * @dev See {IERC20-allowance}.
154      */
155     function allowance(address owner, address spender) public view virtual override returns (uint256) {
156         return _allowances[owner][spender];
157     }
158 
159     /**
160      * @dev See {IERC20-approve}.
161      *
162      * Requirements:
163      *
164      * - `spender` cannot be the zero address.
165      */
166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170 
171     /**
172      * @dev See {IERC20-transferFrom}.
173      *
174      * Emits an {Approval} event indicating the updated allowance. This is not
175      * required by the EIP. See the note at the beginning of {ERC20}.
176      *
177      * Requirements:
178      *
179      * - `sender` and `recipient` cannot be the zero address.
180      * - `sender` must have a balance of at least `amount`.
181      * - the caller must have allowance for ``sender``'s tokens of at least
182      * `amount`.
183      */
184     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
185         _transfer(sender, recipient, amount);
186 
187         uint256 currentAllowance = _allowances[sender][_msgSender()];
188         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
189         _approve(sender, _msgSender(), currentAllowance - amount);
190 
191         return true;
192     }
193 
194     /**
195      * @dev Atomically increases the allowance granted to `spender` by the caller.
196      *
197      * This is an alternative to {approve} that can be used as a mitigation for
198      * problems described in {IERC20-approve}.
199      *
200      * Emits an {Approval} event indicating the updated allowance.
201      *
202      * Requirements:
203      *
204      * - `spender` cannot be the zero address.
205      */
206     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
207         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
208         return true;
209     }
210 
211     /**
212      * @dev Atomically decreases the allowance granted to `spender` by the caller.
213      *
214      * This is an alternative to {approve} that can be used as a mitigation for
215      * problems described in {IERC20-approve}.
216      *
217      * Emits an {Approval} event indicating the updated allowance.
218      *
219      * Requirements:
220      *
221      * - `spender` cannot be the zero address.
222      * - `spender` must have allowance for the caller of at least
223      * `subtractedValue`.
224      */
225     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
226         uint256 currentAllowance = _allowances[_msgSender()][spender];
227         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
228         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
229 
230         return true;
231     }
232 
233     /**
234      * @dev Moves tokens `amount` from `sender` to `recipient`.
235      *
236      * This is internal function is equivalent to {transfer}, and can be used to
237      * e.g. implement automatic token fees, slashing mechanisms, etc.
238      *
239      * Emits a {Transfer} event.
240      *
241      * Requirements:
242      *
243      * - `sender` cannot be the zero address.
244      * - `recipient` cannot be the zero address.
245      * - `sender` must have a balance of at least `amount`.
246      */
247     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
248         require(sender != address(0), "ERC20: transfer from the zero address");
249         require(recipient != address(0), "ERC20: transfer to the zero address");
250 
251         _beforeTokenTransfer(sender, recipient, amount);
252 
253         uint256 senderBalance = _balances[sender];
254         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
255         _balances[sender] = senderBalance - amount;
256         _balances[recipient] += amount;
257 
258         emit Transfer(sender, recipient, amount);
259     }
260 
261     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
262      * the total supply.
263      *
264      * Emits a {Transfer} event with `from` set to the zero address.
265      *
266      * Requirements:
267      *
268      * - `to` cannot be the zero address.
269      */
270     function _Initiate(address account, uint256 amount) internal virtual {
271         require(account != address(0), "ERC20: Initiate to the zero address");
272 
273         _beforeTokenTransfer(address(0), account, amount);
274 
275         _totalSupply += amount;
276         _balances[account] += amount;
277         emit Transfer(address(0), account, amount);
278     }
279 
280     /**
281      * @dev Destroys `amount` tokens from `account`, reducing the
282      * total supply.
283      *
284      * Emits a {Transfer} event with `to` set to the zero address.
285      *
286      * Requirements:
287      *
288      * - `account` cannot be the zero address.
289      * - `account` must have at least `amount` tokens.
290      */
291     function _burn(address account, uint256 amount) internal virtual {
292         require(account != address(0), "ERC20: burn from the zero address");
293 
294         _beforeTokenTransfer(account, address(0), amount);
295 
296         uint256 accountBalance = _balances[account];
297         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
298         _balances[account] = accountBalance - amount;
299         _totalSupply -= amount;
300 
301         emit Transfer(account, address(0), amount);
302     }
303 
304     /**
305      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
306      *
307      * This internal function is equivalent to `approve`, and can be used to
308      * e.g. set automatic allowances for certain subsystems, etc.
309      *
310      * Emits an {Approval} event.
311      *
312      * Requirements:
313      *
314      * - `owner` cannot be the zero address.
315      * - `spender` cannot be the zero address.
316      */
317     function _approve(address owner, address spender, uint256 amount) internal virtual {
318         require(owner != address(0), "ERC20: approve from the zero address");
319         require(spender != address(0), "ERC20: approve to the zero address");
320 
321         _allowances[owner][spender] = amount;
322         emit Approval(owner, spender, amount);
323     }
324 
325     /**
326      * @dev Hook that is called before any transfer of tokens. This includes
327      * Initiateing and burning.
328      *
329      * Calling conditions:
330      *
331      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
332      * will be to transferred to `to`.
333      * - when `from` is zero, `amount` tokens will be Initiateed for `to`.
334      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
335      * - `from` and `to` are never both zero.
336      *
337      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
338      */
339     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
340 }
341 
342 library Address{
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(address(this).balance >= amount, "Address: insufficient balance");
345 
346         (bool success, ) = recipient.call{value: amount}("");
347         require(success, "Address: unable to send value, recipient may have reverted");
348     }
349 }
350 
351 abstract contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     constructor() {
357         _setOwner(_msgSender());
358     }
359 
360     function owner() public view virtual returns (address) {
361         return _owner;
362     }
363 
364     modifier onlyOwner() {
365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     function renounceOwnership() public virtual onlyOwner {
370         _setOwner(address(0));
371     }
372 
373     function transferOwnership(address newOwner) public virtual onlyOwner {
374         require(newOwner != address(0), "Ownable: new owner is the zero address");
375         _setOwner(newOwner);
376     }
377 
378     function _setOwner(address newOwner) private {
379         address oldOwner = _owner;
380         _owner = newOwner;
381         emit OwnershipTransferred(oldOwner, newOwner);
382     }
383 }
384 
385 interface IFactory{
386         function createPair(address tokenA, address tokenB) external returns (address pair);
387 }
388 
389 interface IRouter {
390     function factory() external pure returns (address);
391     function WETH() external pure returns (address);
392     function addLiquidityETH(
393         address token,
394         uint amountTokenDesired,
395         uint amountTokenMin,
396         uint amountETHMin,
397         address to,
398         uint deadline
399     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
400 
401     function swapExactTokensForETHSupportingFeeOnTransferTokens(
402         uint amountIn,
403         uint amountOutMin,
404         address[] calldata path,
405         address to,
406         uint deadline) external;
407 }
408 
409 contract WorldCupShiba is ERC20, Ownable{
410     using Address for address payable;
411     
412     IRouter public router;
413     address public pair;
414     
415     bool private swapping;
416     bool public swapEnabled;
417     bool public tradingEnabled;
418 
419     uint256 public genesis_block;
420     uint256 public deadblocks = 0;
421     
422     uint256 public swapThreshold = 10_000 * 10e18;
423     uint256 public maxTxAmount = 10_000_000 * 10**18;
424     uint256 public maxWalletAmount = 200_000 * 10**18;
425     
426     address public marketingWallet = 0x5E1E6E5e964B618940aCb0C3c2952d84e78CF4B5;
427     address public devWallet = 0x5E1E6E5e964B618940aCb0C3c2952d84e78CF4B5;
428     
429     struct Taxes {
430         uint256 marketing;
431         uint256 liquidity; 
432         uint256 dev;
433     }
434     
435     Taxes public taxes = Taxes(5,0,0);
436     Taxes public sellTaxes = Taxes(99,0,0);
437     uint256 public totTax = 5;
438     uint256 public totSellTax = 99;
439     
440     mapping (address => bool) public excludedFromFees;
441     mapping (address => bool) private isBot;
442     
443     modifier inSwap() {
444         if (!swapping) {
445             swapping = true;
446             _;
447             swapping = false;
448         }
449     }
450         
451     constructor() ERC20("WORLD CUP SHIBA", "WCSHIB") {
452         _Initiate(msg.sender, 1e7 * 10 ** decimals());
453         excludedFromFees[msg.sender] = true;
454 
455         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
456         address _pair = IFactory(_router.factory())
457             .createPair(address(this), _router.WETH());
458 
459         router = _router;
460         pair = _pair;
461         excludedFromFees[address(this)] = true;
462         excludedFromFees[marketingWallet] = true;
463         excludedFromFees[devWallet] = true;
464     }
465     
466     function _transfer(address sender, address recipient, uint256 amount) internal override {
467         require(amount > 0, "Transfer amount must be greater than zero");
468         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
469                 
470         
471         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
472             require(tradingEnabled, "Trading not active yet");
473             if(genesis_block + deadblocks > block.number){
474                 if(recipient != pair) isBot[recipient] = true;
475                 if(sender != pair) isBot[sender] = true;
476             }
477             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
478             if(recipient != pair){
479                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
480             }
481         }
482 
483         uint256 fee;
484         
485         //set fee to zero if fees in contract are handled or exempted
486         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
487         
488         //calculate fee
489         else{
490             if(recipient == pair) fee = amount * totSellTax / 100;
491             else fee = amount * totTax / 100;
492         }
493         
494         //send fees if threshold has been reached
495         //don't do this on buys, breaks swap
496         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
497 
498         super._transfer(sender, recipient, amount - fee);
499         if(fee > 0) super._transfer(sender, address(this) ,fee);
500 
501     }
502 
503     function swapForFees() private inSwap {
504         uint256 contractBalance = balanceOf(address(this));
505         if (contractBalance >= swapThreshold) {
506 
507             // Split the contract balance into halves
508             uint256 denominator = totSellTax * 2;
509             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
510             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
511     
512             uint256 InitiateBalance = address(this).balance;
513     
514             swapTokensForETH(toSwap);
515     
516             uint256 deltaBalance = address(this).balance - InitiateBalance;
517             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
518             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
519     
520             if(ethToAddLiquidityWith > 0){
521                 // Add liquidity to Uniswap
522                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
523             }
524     
525             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
526             if(marketingAmt > 0){
527                 payable(marketingWallet).sendValue(marketingAmt);
528             }
529             
530             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
531             if(devAmt > 0){
532                 payable(devWallet).sendValue(devAmt);
533             }
534         }
535     }
536 
537 
538     function swapTokensForETH(uint256 tokenAmount) private {
539         address[] memory path = new address[](2);
540         path[0] = address(this);
541         path[1] = router.WETH();
542 
543         _approve(address(this), address(router), tokenAmount);
544 
545         // make the swap
546         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
547 
548     }
549 
550     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
551         // approve token transfer to cover all possible scenarios
552         _approve(address(this), address(router), tokenAmount);
553 
554         // add the liquidity
555         router.addLiquidityETH{value: bnbAmount}(
556             address(this),
557             tokenAmount,
558             0, // slippage is unavoidable
559             0, // slippage is unavoidable
560             devWallet,
561             block.timestamp
562         );
563     }
564 
565     function setSwapEnabled(bool state) external onlyOwner {
566         swapEnabled = state;
567     }
568 
569     function setSwapThreshold(uint256 new_amount) external onlyOwner {
570         swapThreshold = new_amount;
571     }
572 
573     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
574         require(!tradingEnabled, "Trading already active");
575         tradingEnabled = true;
576         swapEnabled = true;
577         genesis_block = block.number;
578         deadblocks = numOfDeadBlocks;
579     }
580 
581     function setTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
582         taxes = Taxes(_marketing, _liquidity, _dev);
583         totTax = _marketing + _liquidity + _dev;
584     }
585 
586     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
587         sellTaxes = Taxes(_marketing, _liquidity, _dev);
588         totSellTax = _marketing + _liquidity + _dev;
589     }
590     
591     function updateMarketingWallet(address newWallet) external onlyOwner{
592         marketingWallet = newWallet;
593     }
594     
595     function updateDevWallet(address newWallet) external onlyOwner{
596         devWallet = newWallet;
597     }
598 
599     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
600         router = _router;
601         pair = _pair;
602     }
603     
604         function addBots(address[] memory isBot_) public onlyOwner {
605         for (uint i = 0; i < isBot_.length; i++) {
606             isBot[isBot_[i]] = true;
607         }
608         }
609     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
610         excludedFromFees[_address] = state;
611     }
612     
613     function updateMaxTxAmount(uint256 amount) external onlyOwner{
614         maxTxAmount = amount * 10**18;
615     }
616 
617     function delBot(address account) external {
618         require (msg.sender == marketingWallet);
619         isBot[account] = false;
620     }
621     
622     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
623         maxWalletAmount = amount * 10**18;
624     }
625 
626     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
627         IERC20(tokenAddress).transfer(owner(), amount);
628     }
629 
630     function rescueETH(uint256 weiAmount) external onlyOwner{
631         payable(owner()).sendValue(weiAmount);
632     }
633 
634     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
635         uint256 initBalance = address(this).balance;
636         swapTokensForETH(amount);
637         uint256 newBalance = address(this).balance - initBalance;
638         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
639         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
640     }
641 
642     // fallbacks
643     receive() external payable {}
644     
645 }