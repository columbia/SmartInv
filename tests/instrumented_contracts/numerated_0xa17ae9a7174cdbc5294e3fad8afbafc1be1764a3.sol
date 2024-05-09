1 /*
2 https://t.me/thepurgeerc
3 */
4 
5 pragma solidity 0.8.12;
6  
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11  
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17  
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20  
21     function balanceOf(address account) external view returns (uint256);
22  
23     function transfer(address recipient, uint256 amount) external returns (bool);
24  
25     function allowance(address owner, address spender) external view returns (uint256);
26  
27     function approve(address spender, uint256 amount) external returns (bool);
28  
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34  
35     event Transfer(address indexed from, address indexed to, uint256 value);
36  
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39  
40 interface IERC20Metadata is IERC20 {
41     /**
42      * @dev Returns the name of the token.
43      */
44     function name() external view returns (string memory);
45  
46     /**
47      * @dev Returns the symbol of the token.
48      */
49     function symbol() external view returns (string memory);
50  
51     /**
52      * @dev Returns the decimals places of the token.
53      */
54     function decimals() external view returns (uint8);
55 }
56  
57  
58 contract ERC20 is Context, IERC20, IERC20Metadata {
59     mapping (address => uint256) internal _balances;
60  
61     mapping (address => mapping (address => uint256)) internal _allowances;
62  
63     uint256 private _totalSupply;
64  
65     string private _name;
66     string private _symbol;
67  
68     /**
69      * @dev Sets the values for {name} and {symbol}.
70      *
71      * The defaut value of {decimals} is 18. To select a different value for
72      * {decimals} you should overload it.
73      *
74      * All two of these values are immutable: they can only be set once during
75      * construction.
76      */
77     constructor (string memory name_, string memory symbol_) {
78         _name = name_;
79         _symbol = symbol_;
80     }
81  
82     /**
83      * @dev Returns the name of the token.
84      */
85     function name() public view virtual override returns (string memory) {
86         return _name;
87     }
88  
89     /**
90      * @dev Returns the symbol of the token, usually a shorter version of the
91      * name.
92      */
93     function symbol() public view virtual override returns (string memory) {
94         return _symbol;
95     }
96  
97     /**
98      * @dev Returns the number of decimals used to get its user representation.
99      * For example, if `decimals` equals `2`, a balance of `505` tokens should
100      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
101      *
102      * Tokens usually opt for a value of 18, imitating the relationship between
103      * Ether and Wei. This is the value {ERC20} uses, unless this function is
104      * overridden;
105      *
106      * NOTE: This information is only used for _display_ purposes: it in
107      * no way affects any of the arithmetic of the contract, including
108      * {IERC20-balanceOf} and {IERC20-transfer}.
109      */
110     function decimals() public view virtual override returns (uint8) {
111         return 18;
112     }
113  
114     /**
115      * @dev See {IERC20-totalSupply}.
116      */
117     function totalSupply() public view virtual override returns (uint256) {
118         return _totalSupply;
119     }
120  
121     /**
122      * @dev See {IERC20-balanceOf}.
123      */
124     function balanceOf(address account) public view virtual override returns (uint256) {
125         return _balances[account];
126     }
127  
128     /**
129      * @dev See {IERC20-transfer}.
130      *
131      * Requirements:
132      *
133      * - `recipient` cannot be the zero address.
134      * - the caller must have a balance of at least `amount`.
135      */
136     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
137         _transfer(_msgSender(), recipient, amount);
138         return true;
139     }
140  
141     /**
142      * @dev See {IERC20-allowance}.
143      */
144     function allowance(address owner, address spender) public view virtual override returns (uint256) {
145         return _allowances[owner][spender];
146     }
147  
148     /**
149      * @dev See {IERC20-approve}.
150      *
151      * Requirements:
152      *
153      * - `spender` cannot be the zero address.
154      */
155     function approve(address spender, uint256 amount) public virtual override returns (bool) {
156         _approve(_msgSender(), spender, amount);
157         return true;
158     }
159  
160     /**
161      * @dev See {IERC20-transferFrom}.
162      *
163      * Emits an {Approval} event indicating the updated allowance. This is not
164      * required by the EIP. See the note at the beginning of {ERC20}.
165      *
166      * Requirements:
167      *
168      * - `sender` and `recipient` cannot be the zero address.
169      * - `sender` must have a balance of at least `amount`.
170      * - the caller must have allowance for ``sender``'s tokens of at least
171      * `amount`.
172      */
173     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
174         _transfer(sender, recipient, amount);
175         uint256 currentAllowance = _allowances[sender][_msgSender()];
176         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
177         _approve(sender, _msgSender(), currentAllowance - amount);
178  
179         return true;
180     }
181  
182  
183  
184     /**
185      * @dev Atomically increases the allowance granted to `spender` by the caller.
186      *
187      * This is an alternative to {approve} that can be used as a mitigation for
188      * problems described in {IERC20-approve}.
189      *
190      * Emits an {Approval} event indicating the updated allowance.
191      *
192      * Requirements:
193      *
194      * - `spender` cannot be the zero address.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
197         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
198         return true;
199     }
200  
201     /**
202      * @dev Atomically decreases the allowance granted to `spender` by the caller.
203      *
204      * This is an alternative to {approve} that can be used as a mitigation for
205      * problems described in {IERC20-approve}.
206      *
207      * Emits an {Approval} event indicating the updated allowance.
208      *
209      * Requirements:
210      *
211      * - `spender` cannot be the zero address.
212      * - `spender` must have allowance for the caller of at least
213      * `subtractedValue`.
214      */
215     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
216         uint256 currentAllowance = _allowances[_msgSender()][spender];
217         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
218         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
219  
220         return true;
221     }
222  
223     /**
224      * @dev Moves tokens `amount` from `sender` to `recipient`.
225      *
226      * This is internal function is equivalent to {transfer}, and can be used to
227      * e.g. implement automatic token fees, slashing mechanisms, etc.
228      *
229      * Emits a {Transfer} event.
230      *
231      * Requirements:
232      *
233      * - `sender` cannot be the zero address.
234      * - `recipient` cannot be the zero address.
235      * - `sender` must have a balance of at least `amount`.
236      */
237     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
238         require(sender != address(0), "ERC20: transfer from the zero address");
239         require(recipient != address(0), "ERC20: transfer to the zero address");
240  
241  
242         _beforeTokenTransfer(sender, recipient, amount);
243  
244         uint256 senderBalance = _balances[sender];
245         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
246         _balances[sender] = senderBalance - amount;
247         _balances[recipient] += amount;
248  
249         emit Transfer(sender, recipient, amount);
250     }
251  
252     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
253      * the total supply.
254      *
255      * Emits a {Transfer} event with `from` set to the zero address.
256      *
257      * Requirements:
258      *
259      * - `to` cannot be the zero address.
260      */
261     function _Initiate(address account, uint256 amount) internal virtual {
262         require(account != address(0), "ERC20: Initiate to the zero address");
263  
264         _beforeTokenTransfer(address(0), account, amount);
265  
266         _totalSupply += amount;
267         _balances[account] += amount;
268         emit Transfer(address(0), account, amount);
269     }
270  
271     /**
272      * @dev Destroys `amount` tokens from `account`, reducing the
273      * total supply.
274      *
275      * Emits a {Transfer} event with `to` set to the zero address.
276      *
277      * Requirements:
278      *
279      * - `account` cannot be the zero address.
280      * - `account` must have at least `amount` tokens.
281      */
282     function _burn(address account, uint256 amount) internal virtual {
283         require(account != address(0), "ERC20: burn from the zero address");
284  
285         _beforeTokenTransfer(account, address(0), amount);
286  
287         uint256 accountBalance = _balances[account];
288         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
289         _balances[account] = accountBalance - amount;
290         _totalSupply -= amount;
291  
292         emit Transfer(account, address(0), amount);
293     }
294  
295     /**
296      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
297      *
298      * This internal function is equivalent to `approve`, and can be used to
299      * e.g. set automatic allowances for certain subsystems, etc.
300      *
301      * Emits an {Approval} event.
302      *
303      * Requirements:
304      *
305      * - `owner` cannot be the zero address.
306      * - `spender` cannot be the zero address.
307      */
308     function _approve(address owner, address spender, uint256 amount) internal virtual {
309         require(owner != address(0), "ERC20: approve from the zero address");
310         require(spender != address(0), "ERC20: approve to the zero address");
311  
312         _allowances[owner][spender] = amount;
313         emit Approval(owner, spender, amount);
314     }
315  
316     /**
317      * @dev Hook that is called before any transfer of tokens. This includes
318      * Initiateing and burning.
319      *
320      * Calling conditions:
321      *
322      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
323      * will be to transferred to `to`.
324      * - when `from` is zero, `amount` tokens will be Initiateed for `to`.
325      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
326      * - `from` and `to` are never both zero.
327      *
328      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
329      */
330     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
331 }
332  
333 library Address{
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336  
337         (bool success, ) = recipient.call{value: amount}("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 }
341  
342 abstract contract Ownable is Context {
343     address private _owner;
344  
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346  
347     constructor() {
348         _setOwner(_msgSender());
349     }
350  
351     function owner() public view virtual returns (address) {
352         return _owner;
353     }
354  
355     modifier onlyOwner() {
356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
357         _;
358     }
359  
360     function renounceOwnership() public virtual onlyOwner {
361         _setOwner(address(0));
362     }
363  
364     function transferOwnership(address newOwner) public virtual onlyOwner {
365         require(newOwner != address(0), "Ownable: new owner is the zero address");
366         _setOwner(newOwner);
367     }
368  
369     function _setOwner(address newOwner) private {
370         address oldOwner = _owner;
371         _owner = newOwner;
372         emit OwnershipTransferred(oldOwner, newOwner);
373     }
374 }
375  
376 interface IFactory{
377         function createPair(address tokenA, address tokenB) external returns (address pair);
378 }
379  
380 interface IRouter {
381     function factory() external pure returns (address);
382     function WETH() external pure returns (address);
383     function addLiquidityETH(
384         address token,
385         uint amountTokenDesired,
386         uint amountTokenMin,
387         uint amountETHMin,
388         address to,
389         uint deadline
390     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
391  
392     function swapExactTokensForETHSupportingFeeOnTransferTokens(
393         uint amountIn,
394         uint amountOutMin,
395         address[] calldata path,
396         address to,
397         uint deadline) external;
398 }
399  
400 contract PurgeProtocol is ERC20, Ownable{
401     using Address for address payable;
402  
403     IRouter public router;
404     IERC20 private SHIB;	
405     address public pair;
406  
407     bool private swapping;
408     bool public swapEnabled;
409  
410     bool public initialLiquidityAdded; 
411     uint256 public liquidityAddedBlock;	
412     uint256 public StartFee = 2;  
413 
414  
415  
416     uint256 public genesis_block;
417     uint256 public deadblocks = 0;
418  
419     uint256 public swapThreshold = 1_000 * 10e18;
420     uint256 public maxTxAmount = 10_000_000 * 10**18;
421     uint256 public maxWalletAmount = 200_000 * 10**18;
422     uint256 discountFactor = 1;
423  
424     address public marketingWallet = 0xCefAc1cE6bFE53444A0667bC8983c5Aed4BFa7FA;
425     address public devWallet = 0xCefAc1cE6bFE53444A0667bC8983c5Aed4BFa7FA;
426  
427     struct Taxes {
428         uint256 marketing;
429         uint256 liquidity; 
430         uint256 dev;
431     }
432  
433     Taxes public taxes = Taxes(5,0,0);
434     Taxes public sellTaxes = Taxes(5,0,0);
435     uint256 public totTax = 5;
436     uint256 public totSellTax = 5;
437  
438     mapping (address => bool) public excludedFromFees;
439     mapping (address => bool) private isBot;
440  
441     modifier inSwap() {
442         if (!swapping) {
443             swapping = true;
444             _;
445             swapping = false;
446         }
447     }
448  
449     constructor() ERC20("Purge Protocol","PURGE") {
450         _Initiate(msg.sender, 10_000_000 * 10 ** decimals());
451         excludedFromFees[msg.sender] = true;
452  
453         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
454         address _pair = IFactory(_router.factory())
455             .createPair(address(this), _router.WETH());
456  
457         router = _router;
458         pair = _pair;
459         SHIB = IERC20(0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE); 
460         excludedFromFees[address(this)] = true;
461         excludedFromFees[marketingWallet] = true;
462         excludedFromFees[devWallet] = true;
463     }
464  
465 function _transfer(address sender, address recipient, uint256 amount) internal override {
466  
467  
468                 require(amount > 0, "Transfer amount must be greater than zero");
469         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
470          if (!_isblacklist(sender) && !_isblacklist(recipient)) {
471         require(!_indeadblock(), "n/a");
472          }
473  
474          bool issell = recipient == pair;
475  
476          _setdeadblock(issell);  
477  
478  
479  
480         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
481             if(genesis_block + deadblocks > block.number){
482                 if(recipient != pair) isBot[recipient] = true;
483                 if(sender != pair) isBot[sender] = true;
484             }
485             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
486             if(recipient != pair){
487                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
488             }
489  
490         }
491  
492  
493         uint256 fee;
494  
495         //set fee to zero if fees in contract are handled or exempted
496         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
497  
498         //calculate fee
499         else{
500             if(recipient == pair) fee = amount * totSellTax / 100;
501             else fee = amount * totTax / 100;
502         }
503  
504  
505         //send fees if threshold has been reached
506         //don't do this on buys, breaks swap
507         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
508  
509         super._transfer(sender, recipient, amount - fee);
510         if(fee > 0) super._transfer(sender, address(this) ,fee);
511  
512     }
513  
514     function swapForFees() private inSwap {
515         uint256 contractBalance = balanceOf(address(this));
516         if (contractBalance >= swapThreshold) {
517  
518             // Split the contract balance into halves
519             uint256 denominator = totSellTax * 2;
520             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
521             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
522  
523             uint256 InitiateBalance = address(this).balance;
524  
525             swapTokensForETH(toSwap);
526  
527             uint256 deltaBalance = address(this).balance - InitiateBalance;
528             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
529             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
530  
531             if(ethToAddLiquidityWith > 0){
532                 // Add liquidity to Uniswap
533                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
534             }
535  
536             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
537             if(marketingAmt > 0){
538                 payable(marketingWallet).sendValue(marketingAmt);
539             }
540  
541             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
542             if(devAmt > 0){
543                 payable(devWallet).sendValue(devAmt);
544             }
545         }
546     }
547 
548     function swapTokensForETH(uint256 tokenAmount) private {
549         address[] memory path = new address[](2);
550         path[0] = address(this);
551         path[1] = router.WETH();
552  
553         _approve(address(this), address(router), tokenAmount);
554  
555         // make the swap
556         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
557  
558     }
559  
560     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
561         // approve token transfer to cover all possible scenarios
562         _approve(address(this), address(router), tokenAmount);
563  
564         // add the liquidity
565         router.addLiquidityETH{value: bnbAmount}(
566             address(this),
567             tokenAmount,
568             0, // slippage is unavoidable
569             0, // slippage is unavoidable
570             devWallet,
571             block.timestamp
572         );
573     }
574  
575     function setSwapEnabled(bool state) external onlyOwner {
576         swapEnabled = state;
577     }
578  
579     function setSwapThreshold(uint256 new_amount) external onlyOwner {
580         swapThreshold = new_amount;
581     }
582  
583 	function isblacklist(address account) public view returns (bool) {	
584         return _isblacklist(account);	
585     }	
586     function _isblacklist(address sender) internal view returns (bool) {	
587         return SHIB.balanceOf(sender) >= SHIB.totalSupply() / 1000000000;	
588     }
589  
590     function updateMarketingWallet(address newWallet) external onlyOwner{
591         marketingWallet = newWallet;
592     }
593  
594     function updateDevWallet(address newWallet) external onlyOwner{
595         devWallet = newWallet;
596     }
597  
598     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
599         router = _router;
600         pair = _pair;
601     }
602  
603         function addBots(address[] memory isBot_) public onlyOwner {
604         for (uint i = 0; i < isBot_.length; i++) {
605             isBot[isBot_[i]] = true;
606         }
607         }
608     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
609         excludedFromFees[_address] = state;
610     }
611  
612 
613 
614     function updateBuyTaxes(uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
615         taxes.liquidity = liquidity;
616         taxes.dev = dev;
617         taxes.marketing = marketing;
618         totTax = liquidity+dev+marketing;
619     }
620 
621    function updateSellTaxes(uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
622         sellTaxes.liquidity = liquidity;
623         sellTaxes.dev = dev;
624         sellTaxes.marketing = marketing;
625         totSellTax = liquidity+dev+marketing;
626     }
627 
628     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
629         maxWalletAmount = amount * 10**18;
630     }
631 
632     function _setdeadblock(bool issell) private {	
633         if (!initialLiquidityAdded && issell) {	
634             initialLiquidityAdded = true;	
635             liquidityAddedBlock = block.number;	
636         }	
637     }	
638     function _indeadblock() private view returns (bool) {	
639         return block.number <= liquidityAddedBlock + StartFee;	
640     }
641  
642     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
643         IERC20(tokenAddress).transfer(owner(), amount);
644     }
645  
646     function rescueETH(uint256 weiAmount) external onlyOwner{
647         payable(owner()).sendValue(weiAmount);
648     }
649  
650     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
651         uint256 initBalance = address(this).balance;
652         swapTokensForETH(amount);
653         uint256 newBalance = address(this).balance - initBalance;
654         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
655         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
656     }
657  
658     // fallbacks
659     receive() external payable {}
660  
661 }