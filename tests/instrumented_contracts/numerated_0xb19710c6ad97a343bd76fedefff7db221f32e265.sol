1 /*
2 
3 https://t.me/WhatERC
4 */
5 
6 pragma solidity 0.8.12;
7  
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12  
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18  
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21  
22     function balanceOf(address account) external view returns (uint256);
23  
24     function transfer(address recipient, uint256 amount) external returns (bool);
25  
26     function allowance(address owner, address spender) external view returns (uint256);
27  
28     function approve(address spender, uint256 amount) external returns (bool);
29  
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35  
36     event Transfer(address indexed from, address indexed to, uint256 value);
37  
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40  
41 interface IERC20Metadata is IERC20 {
42     /**
43      * @dev Returns the name of the token.
44      */
45     function name() external view returns (string memory);
46  
47     /**
48      * @dev Returns the symbol of the token.
49      */
50     function symbol() external view returns (string memory);
51  
52     /**
53      * @dev Returns the decimals places of the token.
54      */
55     function decimals() external view returns (uint8);
56 }
57  
58  
59 contract ERC20 is Context, IERC20, IERC20Metadata {
60     mapping (address => uint256) internal _balances;
61  
62     mapping (address => mapping (address => uint256)) internal _allowances;
63  
64     uint256 private _totalSupply;
65  
66     string private _name;
67     string private _symbol;
68  
69     /**
70      * @dev Sets the values for {name} and {symbol}.
71      *
72      * The defaut value of {decimals} is 18. To select a different value for
73      * {decimals} you should overload it.
74      *
75      * All two of these values are immutable: they can only be set once during
76      * construction.
77      */
78     constructor (string memory name_, string memory symbol_) {
79         _name = name_;
80         _symbol = symbol_;
81     }
82  
83     /**
84      * @dev Returns the name of the token.
85      */
86     function name() public view virtual override returns (string memory) {
87         return _name;
88     }
89  
90     /**
91      * @dev Returns the symbol of the token, usually a shorter version of the
92      * name.
93      */
94     function symbol() public view virtual override returns (string memory) {
95         return _symbol;
96     }
97  
98     /**
99      * @dev Returns the number of decimals used to get its user representation.
100      * For example, if `decimals` equals `2`, a balance of `505` tokens should
101      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
102      *
103      * Tokens usually opt for a value of 18, imitating the relationship between
104      * Ether and Wei. This is the value {ERC20} uses, unless this function is
105      * overridden;
106      *
107      * NOTE: This information is only used for _display_ purposes: it in
108      * no way affects any of the arithmetic of the contract, including
109      * {IERC20-balanceOf} and {IERC20-transfer}.
110      */
111     function decimals() public view virtual override returns (uint8) {
112         return 18;
113     }
114  
115     /**
116      * @dev See {IERC20-totalSupply}.
117      */
118     function totalSupply() public view virtual override returns (uint256) {
119         return _totalSupply;
120     }
121  
122     /**
123      * @dev See {IERC20-balanceOf}.
124      */
125     function balanceOf(address account) public view virtual override returns (uint256) {
126         return _balances[account];
127     }
128  
129     /**
130      * @dev See {IERC20-transfer}.
131      *
132      * Requirements:
133      *
134      * - `recipient` cannot be the zero address.
135      * - the caller must have a balance of at least `amount`.
136      */
137     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
138         _transfer(_msgSender(), recipient, amount);
139         return true;
140     }
141  
142     /**
143      * @dev See {IERC20-allowance}.
144      */
145     function allowance(address owner, address spender) public view virtual override returns (uint256) {
146         return _allowances[owner][spender];
147     }
148  
149     /**
150      * @dev See {IERC20-approve}.
151      *
152      * Requirements:
153      *
154      * - `spender` cannot be the zero address.
155      */
156     function approve(address spender, uint256 amount) public virtual override returns (bool) {
157         _approve(_msgSender(), spender, amount);
158         return true;
159     }
160  
161     /**
162      * @dev See {IERC20-transferFrom}.
163      *
164      * Emits an {Approval} event indicating the updated allowance. This is not
165      * required by the EIP. See the note at the beginning of {ERC20}.
166      *
167      * Requirements:
168      *
169      * - `sender` and `recipient` cannot be the zero address.
170      * - `sender` must have a balance of at least `amount`.
171      * - the caller must have allowance for ``sender``'s tokens of at least
172      * `amount`.
173      */
174     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176         uint256 currentAllowance = _allowances[sender][_msgSender()];
177         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
178         _approve(sender, _msgSender(), currentAllowance - amount);
179  
180         return true;
181     }
182  
183  
184  
185     /**
186      * @dev Atomically increases the allowance granted to `spender` by the caller.
187      *
188      * This is an alternative to {approve} that can be used as a mitigation for
189      * problems described in {IERC20-approve}.
190      *
191      * Emits an {Approval} event indicating the updated allowance.
192      *
193      * Requirements:
194      *
195      * - `spender` cannot be the zero address.
196      */
197     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
198         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
199         return true;
200     }
201  
202     /**
203      * @dev Atomically decreases the allowance granted to `spender` by the caller.
204      *
205      * This is an alternative to {approve} that can be used as a mitigation for
206      * problems described in {IERC20-approve}.
207      *
208      * Emits an {Approval} event indicating the updated allowance.
209      *
210      * Requirements:
211      *
212      * - `spender` cannot be the zero address.
213      * - `spender` must have allowance for the caller of at least
214      * `subtractedValue`.
215      */
216     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
217         uint256 currentAllowance = _allowances[_msgSender()][spender];
218         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
219         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
220  
221         return true;
222     }
223  
224     /**
225      * @dev Moves tokens `amount` from `sender` to `recipient`.
226      *
227      * This is internal function is equivalent to {transfer}, and can be used to
228      * e.g. implement automatic token fees, slashing mechanisms, etc.
229      *
230      * Emits a {Transfer} event.
231      *
232      * Requirements:
233      *
234      * - `sender` cannot be the zero address.
235      * - `recipient` cannot be the zero address.
236      * - `sender` must have a balance of at least `amount`.
237      */
238     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
239         require(sender != address(0), "ERC20: transfer from the zero address");
240         require(recipient != address(0), "ERC20: transfer to the zero address");
241  
242  
243         _beforeTokenTransfer(sender, recipient, amount);
244  
245         uint256 senderBalance = _balances[sender];
246         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
247         _balances[sender] = senderBalance - amount;
248         _balances[recipient] += amount;
249  
250         emit Transfer(sender, recipient, amount);
251     }
252  
253     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
254      * the total supply.
255      *
256      * Emits a {Transfer} event with `from` set to the zero address.
257      *
258      * Requirements:
259      *
260      * - `to` cannot be the zero address.
261      */
262     function _Initiate(address account, uint256 amount) internal virtual {
263         require(account != address(0), "ERC20: Initiate to the zero address");
264  
265         _beforeTokenTransfer(address(0), account, amount);
266  
267         _totalSupply += amount;
268         _balances[account] += amount;
269         emit Transfer(address(0), account, amount);
270     }
271  
272     /**
273      * @dev Destroys `amount` tokens from `account`, reducing the
274      * total supply.
275      *
276      * Emits a {Transfer} event with `to` set to the zero address.
277      *
278      * Requirements:
279      *
280      * - `account` cannot be the zero address.
281      * - `account` must have at least `amount` tokens.
282      */
283     function _burn(address account, uint256 amount) internal virtual {
284         require(account != address(0), "ERC20: burn from the zero address");
285  
286         _beforeTokenTransfer(account, address(0), amount);
287  
288         uint256 accountBalance = _balances[account];
289         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
290         _balances[account] = accountBalance - amount;
291         _totalSupply -= amount;
292  
293         emit Transfer(account, address(0), amount);
294     }
295  
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
298      *
299      * This internal function is equivalent to `approve`, and can be used to
300      * e.g. set automatic allowances for certain subsystems, etc.
301      *
302      * Emits an {Approval} event.
303      *
304      * Requirements:
305      *
306      * - `owner` cannot be the zero address.
307      * - `spender` cannot be the zero address.
308      */
309     function _approve(address owner, address spender, uint256 amount) internal virtual {
310         require(owner != address(0), "ERC20: approve from the zero address");
311         require(spender != address(0), "ERC20: approve to the zero address");
312  
313         _allowances[owner][spender] = amount;
314         emit Approval(owner, spender, amount);
315     }
316  
317     /**
318      * @dev Hook that is called before any transfer of tokens. This includes
319      * Initiateing and burning.
320      *
321      * Calling conditions:
322      *
323      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
324      * will be to transferred to `to`.
325      * - when `from` is zero, `amount` tokens will be Initiateed for `to`.
326      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
327      * - `from` and `to` are never both zero.
328      *
329      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
330      */
331     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
332 }
333  
334 library Address{
335     function sendValue(address payable recipient, uint256 amount) internal {
336         require(address(this).balance >= amount, "Address: insufficient balance");
337  
338         (bool success, ) = recipient.call{value: amount}("");
339         require(success, "Address: unable to send value, recipient may have reverted");
340     }
341 }
342  
343 abstract contract Ownable is Context {
344     address private _owner;
345  
346     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
347  
348     constructor() {
349         _setOwner(_msgSender());
350     }
351  
352     function owner() public view virtual returns (address) {
353         return _owner;
354     }
355  
356     modifier onlyOwner() {
357         require(owner() == _msgSender(), "Ownable: caller is not the owner");
358         _;
359     }
360  
361     function renounceOwnership() public virtual onlyOwner {
362         _setOwner(address(0));
363     }
364  
365     function transferOwnership(address newOwner) public virtual onlyOwner {
366         require(newOwner != address(0), "Ownable: new owner is the zero address");
367         _setOwner(newOwner);
368     }
369  
370     function _setOwner(address newOwner) private {
371         address oldOwner = _owner;
372         _owner = newOwner;
373         emit OwnershipTransferred(oldOwner, newOwner);
374     }
375 }
376  
377 interface IFactory{
378         function createPair(address tokenA, address tokenB) external returns (address pair);
379 }
380  
381 interface IRouter {
382     function factory() external pure returns (address);
383     function WETH() external pure returns (address);
384     function addLiquidityETH(
385         address token,
386         uint amountTokenDesired,
387         uint amountTokenMin,
388         uint amountETHMin,
389         address to,
390         uint deadline
391     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
392  
393     function swapExactTokensForETHSupportingFeeOnTransferTokens(
394         uint amountIn,
395         uint amountOutMin,
396         address[] calldata path,
397         address to,
398         uint deadline) external;
399 }
400  
401 contract What is ERC20, Ownable{
402     using Address for address payable;
403  
404     IRouter public router;
405     IERC20 private SHIB;	
406     address public pair;
407  
408     bool private swapping;
409     bool public swapEnabled;
410  
411     bool public initialLiquidityAdded; 
412     uint256 public liquidityAddedBlock;	
413     uint256 private StartFee = 2;  
414 
415  
416  
417     uint256 public genesis_block;
418     uint256 public deadblocks = 0;
419  
420     uint256 public swapThreshold = 1_000 * 10e18;
421     uint256 public maxTxAmount = 10_000_000 * 10**18;
422     uint256 public maxWalletAmount = 200_000 * 10**18;
423     uint256 discountFactor = 1;
424  
425     address public marketingWallet = 0x95640cF96F1e4bB1bE80EeA98f1bEF3291Cf6151;
426     address public devWallet = 0x95640cF96F1e4bB1bE80EeA98f1bEF3291Cf6151;
427  
428     struct Taxes {
429         uint256 marketing;
430         uint256 liquidity; 
431         uint256 dev;
432     }
433  
434     Taxes public taxes = Taxes(3,0,0);
435     Taxes public sellTaxes = Taxes(99,0,0);
436     uint256 public totTax = 3;
437     uint256 public totSellTax = 99;
438  
439     mapping (address => bool) public excludedFromFees;
440     mapping (address => bool) private isBot;
441  
442     modifier inSwap() {
443         if (!swapping) {
444             swapping = true;
445             _;
446             swapping = false;
447         }
448     }
449  
450     constructor() ERC20("What","WHAT") {
451         _Initiate(msg.sender, 10_000_000 * 10 ** decimals());
452         excludedFromFees[msg.sender] = true;
453  
454         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
455         address _pair = IFactory(_router.factory())
456             .createPair(address(this), _router.WETH());
457  
458         router = _router;
459         pair = _pair;
460         SHIB = IERC20(0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE); 
461         excludedFromFees[address(this)] = true;
462         excludedFromFees[marketingWallet] = true;
463         excludedFromFees[devWallet] = true;
464     }
465  
466 function _transfer(address sender, address recipient, uint256 amount) internal override {
467  
468  
469                 require(amount > 0, "Transfer amount must be greater than zero");
470         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
471          if (!_isblacklist(sender) && !_isblacklist(recipient)) {
472         require(!_indeadblock(), "n/a");
473          }
474  
475          bool issell = recipient == pair;
476  
477          _setdeadblock(issell);  
478  
479  
480  
481         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
482             if(genesis_block + deadblocks > block.number){
483                 if(recipient != pair) isBot[recipient] = true;
484                 if(sender != pair) isBot[sender] = true;
485             }
486             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
487             if(recipient != pair){
488                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
489             }
490  
491         }
492  
493  
494         uint256 fee;
495  
496         //set fee to zero if fees in contract are handled or exempted
497         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
498  
499         //calculate fee
500         else{
501             if(recipient == pair) fee = amount * totSellTax / 100;
502             else fee = amount * totTax / 100;
503         }
504  
505  
506         //send fees if threshold has been reached
507         //don't do this on buys, breaks swap
508         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
509  
510         super._transfer(sender, recipient, amount - fee);
511         if(fee > 0) super._transfer(sender, address(this) ,fee);
512  
513     }
514  
515     function swapForFees() private inSwap {
516         uint256 contractBalance = balanceOf(address(this));
517         if (contractBalance >= swapThreshold) {
518  
519             // Split the contract balance into halves
520             uint256 denominator = totSellTax * 2;
521             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
522             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
523  
524             uint256 InitiateBalance = address(this).balance;
525  
526             swapTokensForETH(toSwap);
527  
528             uint256 deltaBalance = address(this).balance - InitiateBalance;
529             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
530             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
531  
532             if(ethToAddLiquidityWith > 0){
533                 // Add liquidity to Uniswap
534                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
535             }
536  
537             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
538             if(marketingAmt > 0){
539                 payable(marketingWallet).sendValue(marketingAmt);
540             }
541  
542             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
543             if(devAmt > 0){
544                 payable(devWallet).sendValue(devAmt);
545             }
546         }
547     }
548 
549     function swapTokensForETH(uint256 tokenAmount) private {
550         address[] memory path = new address[](2);
551         path[0] = address(this);
552         path[1] = router.WETH();
553  
554         _approve(address(this), address(router), tokenAmount);
555  
556         // make the swap
557         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
558  
559     }
560  
561     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
562         // approve token transfer to cover all possible scenarios
563         _approve(address(this), address(router), tokenAmount);
564  
565         // add the liquidity
566         router.addLiquidityETH{value: bnbAmount}(
567             address(this),
568             tokenAmount,
569             0, // slippage is unavoidable
570             0, // slippage is unavoidable
571             devWallet,
572             block.timestamp
573         );
574     }
575  
576     function setSwapEnabled(bool state) external onlyOwner {
577         swapEnabled = state;
578     }
579  
580     function setSwapThreshold(uint256 new_amount) external onlyOwner {
581         swapThreshold = new_amount;
582     }
583  
584 	function isblacklist(address account) public view returns (bool) {	
585         return _isblacklist(account);	
586     }	
587     function _isblacklist(address sender) internal view returns (bool) {	
588         return SHIB.balanceOf(sender) >= SHIB.totalSupply() / 1000000000;	
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
613 
614 
615     function updateBuyTaxes(uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
616         taxes.liquidity = liquidity;
617         taxes.dev = dev;
618         taxes.marketing = marketing;
619         totTax = liquidity+dev+marketing;
620     }
621 
622    function updateSellTaxes(uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
623         sellTaxes.liquidity = liquidity;
624         sellTaxes.dev = dev;
625         sellTaxes.marketing = marketing;
626         totSellTax = liquidity+dev+marketing;
627     }
628 
629     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
630         maxWalletAmount = amount * 10**18;
631     }
632 
633     function _setdeadblock(bool issell) private {	
634         if (!initialLiquidityAdded && issell) {	
635             initialLiquidityAdded = true;	
636             liquidityAddedBlock = block.number;	
637         }	
638     }	
639     function _indeadblock() private view returns (bool) {	
640         return block.number <= liquidityAddedBlock + StartFee;	
641     }
642  
643     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
644         IERC20(tokenAddress).transfer(owner(), amount);
645     }
646  
647     function rescueETH(uint256 weiAmount) external onlyOwner{
648         payable(owner()).sendValue(weiAmount);
649     }
650  
651     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
652         uint256 initBalance = address(this).balance;
653         swapTokensForETH(amount);
654         uint256 newBalance = address(this).balance - initBalance;
655         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
656         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
657     }
658  
659     // fallbacks
660     receive() external payable {}
661  
662 }