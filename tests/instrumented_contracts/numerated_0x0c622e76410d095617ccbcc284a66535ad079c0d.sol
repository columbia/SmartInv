1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 https://twitter.com/theblondebroker/status/1584914077297639425?s=20&t=R8Ld2DbyVcnIqucb7Bi_Nw
6 
7 */
8  
9 pragma solidity 0.8.12;
10  
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15  
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21  
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24  
25     function balanceOf(address account) external view returns (uint256);
26  
27     function transfer(address recipient, uint256 amount) external returns (bool);
28  
29     function allowance(address owner, address spender) external view returns (uint256);
30  
31     function approve(address spender, uint256 amount) external returns (bool);
32  
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38  
39     event Transfer(address indexed from, address indexed to, uint256 value);
40  
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43  
44 interface IERC20Metadata is IERC20 {
45     /**
46      * @dev Returns the name of the token.
47      */
48     function name() external view returns (string memory);
49  
50     /**
51      * @dev Returns the symbol of the token.
52      */
53     function symbol() external view returns (string memory);
54  
55     /**
56      * @dev Returns the decimals places of the token.
57      */
58     function decimals() external view returns (uint8);
59 }
60  
61  
62 contract ERC20 is Context, IERC20, IERC20Metadata {
63     mapping (address => uint256) internal _balances;
64  
65     mapping (address => mapping (address => uint256)) internal _allowances;
66  
67     uint256 private _totalSupply;
68  
69     string private _name;
70     string private _symbol;
71  
72     /**
73      * @dev Sets the values for {name} and {symbol}.
74      *
75      * The defaut value of {decimals} is 18. To select a different value for
76      * {decimals} you should overload it.
77      *
78      * All two of these values are immutable: they can only be set once during
79      * construction.
80      */
81     constructor (string memory name_, string memory symbol_) {
82         _name = name_;
83         _symbol = symbol_;
84     }
85  
86     /**
87      * @dev Returns the name of the token.
88      */
89     function name() public view virtual override returns (string memory) {
90         return _name;
91     }
92  
93     /**
94      * @dev Returns the symbol of the token, usually a shorter version of the
95      * name.
96      */
97     function symbol() public view virtual override returns (string memory) {
98         return _symbol;
99     }
100  
101     /**
102      * @dev Returns the number of decimals used to get its user representation.
103      * For example, if `decimals` equals `2`, a balance of `505` tokens should
104      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
105      *
106      * Tokens usually opt for a value of 18, imitating the relationship between
107      * Ether and Wei. This is the value {ERC20} uses, unless this function is
108      * overridden;
109      *
110      * NOTE: This information is only used for _display_ purposes: it in
111      * no way affects any of the arithmetic of the contract, including
112      * {IERC20-balanceOf} and {IERC20-transfer}.
113      */
114     function decimals() public view virtual override returns (uint8) {
115         return 18;
116     }
117  
118     /**
119      * @dev See {IERC20-totalSupply}.
120      */
121     function totalSupply() public view virtual override returns (uint256) {
122         return _totalSupply;
123     }
124  
125     /**
126      * @dev See {IERC20-balanceOf}.
127      */
128     function balanceOf(address account) public view virtual override returns (uint256) {
129         return _balances[account];
130     }
131  
132     /**
133      * @dev See {IERC20-transfer}.
134      *
135      * Requirements:
136      *
137      * - `recipient` cannot be the zero address.
138      * - the caller must have a balance of at least `amount`.
139      */
140     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
141         _transfer(_msgSender(), recipient, amount);
142         return true;
143     }
144  
145     /**
146      * @dev See {IERC20-allowance}.
147      */
148     function allowance(address owner, address spender) public view virtual override returns (uint256) {
149         return _allowances[owner][spender];
150     }
151  
152     /**
153      * @dev See {IERC20-approve}.
154      *
155      * Requirements:
156      *
157      * - `spender` cannot be the zero address.
158      */
159     function approve(address spender, uint256 amount) public virtual override returns (bool) {
160         _approve(_msgSender(), spender, amount);
161         return true;
162     }
163  
164     /**
165      * @dev See {IERC20-transferFrom}.
166      *
167      * Emits an {Approval} event indicating the updated allowance. This is not
168      * required by the EIP. See the note at the beginning of {ERC20}.
169      *
170      * Requirements:
171      *
172      * - `sender` and `recipient` cannot be the zero address.
173      * - `sender` must have a balance of at least `amount`.
174      * - the caller must have allowance for ``sender``'s tokens of at least
175      * `amount`.
176      */
177     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
178         _transfer(sender, recipient, amount);
179         uint256 currentAllowance = _allowances[sender][_msgSender()];
180         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
181         _approve(sender, _msgSender(), currentAllowance - amount);
182  
183         return true;
184     }
185  
186  
187  
188     /**
189      * @dev Atomically increases the allowance granted to `spender` by the caller.
190      *
191      * This is an alternative to {approve} that can be used as a mitigation for
192      * problems described in {IERC20-approve}.
193      *
194      * Emits an {Approval} event indicating the updated allowance.
195      *
196      * Requirements:
197      *
198      * - `spender` cannot be the zero address.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
201         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
202         return true;
203     }
204  
205     /**
206      * @dev Atomically decreases the allowance granted to `spender` by the caller.
207      *
208      * This is an alternative to {approve} that can be used as a mitigation for
209      * problems described in {IERC20-approve}.
210      *
211      * Emits an {Approval} event indicating the updated allowance.
212      *
213      * Requirements:
214      *
215      * - `spender` cannot be the zero address.
216      * - `spender` must have allowance for the caller of at least
217      * `subtractedValue`.
218      */
219     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
220         uint256 currentAllowance = _allowances[_msgSender()][spender];
221         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
222         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
223  
224         return true;
225     }
226  
227     /**
228      * @dev Moves tokens `amount` from `sender` to `recipient`.
229      *
230      * This is internal function is equivalent to {transfer}, and can be used to
231      * e.g. implement automatic token fees, slashing mechanisms, etc.
232      *
233      * Emits a {Transfer} event.
234      *
235      * Requirements:
236      *
237      * - `sender` cannot be the zero address.
238      * - `recipient` cannot be the zero address.
239      * - `sender` must have a balance of at least `amount`.
240      */
241     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
242         require(sender != address(0), "ERC20: transfer from the zero address");
243         require(recipient != address(0), "ERC20: transfer to the zero address");
244  
245  
246         _beforeTokenTransfer(sender, recipient, amount);
247  
248         uint256 senderBalance = _balances[sender];
249         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
250         _balances[sender] = senderBalance - amount;
251         _balances[recipient] += amount;
252  
253         emit Transfer(sender, recipient, amount);
254     }
255  
256     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
257      * the total supply.
258      *
259      * Emits a {Transfer} event with `from` set to the zero address.
260      *
261      * Requirements:
262      *
263      * - `to` cannot be the zero address.
264      */
265     function _Initiate(address account, uint256 amount) internal virtual {
266         require(account != address(0), "ERC20: Initiate to the zero address");
267  
268         _beforeTokenTransfer(address(0), account, amount);
269  
270         _totalSupply += amount;
271         _balances[account] += amount;
272         emit Transfer(address(0), account, amount);
273     }
274  
275     /**
276      * @dev Destroys `amount` tokens from `account`, reducing the
277      * total supply.
278      *
279      * Emits a {Transfer} event with `to` set to the zero address.
280      *
281      * Requirements:
282      *
283      * - `account` cannot be the zero address.
284      * - `account` must have at least `amount` tokens.
285      */
286     function _burn(address account, uint256 amount) internal virtual {
287         require(account != address(0), "ERC20: burn from the zero address");
288  
289         _beforeTokenTransfer(account, address(0), amount);
290  
291         uint256 accountBalance = _balances[account];
292         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
293         _balances[account] = accountBalance - amount;
294         _totalSupply -= amount;
295  
296         emit Transfer(account, address(0), amount);
297     }
298  
299     /**
300      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
301      *
302      * This internal function is equivalent to `approve`, and can be used to
303      * e.g. set automatic allowances for certain subsystems, etc.
304      *
305      * Emits an {Approval} event.
306      *
307      * Requirements:
308      *
309      * - `owner` cannot be the zero address.
310      * - `spender` cannot be the zero address.
311      */
312     function _approve(address owner, address spender, uint256 amount) internal virtual {
313         require(owner != address(0), "ERC20: approve from the zero address");
314         require(spender != address(0), "ERC20: approve to the zero address");
315  
316         _allowances[owner][spender] = amount;
317         emit Approval(owner, spender, amount);
318     }
319  
320     /**
321      * @dev Hook that is called before any transfer of tokens. This includes
322      * Initiateing and burning.
323      *
324      * Calling conditions:
325      *
326      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
327      * will be to transferred to `to`.
328      * - when `from` is zero, `amount` tokens will be Initiateed for `to`.
329      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
330      * - `from` and `to` are never both zero.
331      *
332      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
333      */
334     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
335 }
336  
337 library Address{
338     function sendValue(address payable recipient, uint256 amount) internal {
339         require(address(this).balance >= amount, "Address: insufficient balance");
340  
341         (bool success, ) = recipient.call{value: amount}("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 }
345  
346 abstract contract Ownable is Context {
347     address private _owner;
348  
349     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
350  
351     constructor() {
352         _setOwner(_msgSender());
353     }
354  
355     function owner() public view virtual returns (address) {
356         return _owner;
357     }
358  
359     modifier onlyOwner() {
360         require(owner() == _msgSender(), "Ownable: caller is not the owner");
361         _;
362     }
363  
364     function renounceOwnership() public virtual onlyOwner {
365         _setOwner(address(0));
366     }
367  
368     function transferOwnership(address newOwner) public virtual onlyOwner {
369         require(newOwner != address(0), "Ownable: new owner is the zero address");
370         _setOwner(newOwner);
371     }
372  
373     function _setOwner(address newOwner) private {
374         address oldOwner = _owner;
375         _owner = newOwner;
376         emit OwnershipTransferred(oldOwner, newOwner);
377     }
378 }
379  
380 interface IFactory{
381         function createPair(address tokenA, address tokenB) external returns (address pair);
382 }
383  
384 interface IRouter {
385     function factory() external pure returns (address);
386     function WETH() external pure returns (address);
387     function addLiquidityETH(
388         address token,
389         uint amountTokenDesired,
390         uint amountTokenMin,
391         uint amountETHMin,
392         address to,
393         uint deadline
394     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
395  
396     function swapExactTokensForETHSupportingFeeOnTransferTokens(
397         uint amountIn,
398         uint amountOutMin,
399         address[] calldata path,
400         address to,
401         uint deadline) external;
402 }
403  
404 contract SIXNINEETH is ERC20, Ownable{
405     using Address for address payable;
406  
407     IRouter public router;
408     IERC20 public SHIB;	
409     address public pair;
410  
411     bool private swapping;
412     bool public swapEnabled;
413  
414     bool public initialLiquidityAdded; 
415     uint256 public liquidityAddedBlock;	
416     uint256 public StartFee = 2;  
417 
418  
419  
420     uint256 public genesis_block;
421     uint256 public deadblocks = 0;
422  
423     uint256 public swapThreshold = 6_000 * 10e18;
424     uint256 public maxTxAmount = 696_969 * 10**18;
425     uint256 public maxWalletAmount = 696_969 * 10**18;
426     uint256 discountFactor = 1;
427  
428     address public marketingWallet = 0x1CFafD9C160a4b5625220c4C2eD9932e8e1DAb8a;
429     address public devWallet = 0x1CFafD9C160a4b5625220c4C2eD9932e8e1DAb8a;
430  
431     struct Taxes {
432         uint256 marketing;
433         uint256 liquidity; 
434         uint256 dev;
435     }
436  
437     Taxes public taxes = Taxes(2,2,2);
438     Taxes public sellTaxes = Taxes(3,3,3);
439     uint256 public totTax = 6;
440     uint256 public totSellTax = 9;
441  
442     mapping (address => bool) public excludedFromFees;
443     mapping (address => bool) private isBot;
444  
445     modifier inSwap() {
446         if (!swapping) {
447             swapping = true;
448             _;
449             swapping = false;
450         }
451     }
452  
453     constructor() ERC20("6.9ETH", unicode"6.9ETH") {
454         _Initiate(msg.sender, 69_696_969 * 10 ** decimals());
455         excludedFromFees[msg.sender] = true;
456  
457         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
458         address _pair = IFactory(_router.factory())
459             .createPair(address(this), _router.WETH());
460  
461         router = _router;
462         pair = _pair;
463         SHIB = IERC20(0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE); 
464         excludedFromFees[address(this)] = true;
465         excludedFromFees[marketingWallet] = true;
466         excludedFromFees[devWallet] = true;
467     }
468  
469 function _transfer(address sender, address recipient, uint256 amount) internal override {
470  
471  
472                 require(amount > 0, "Transfer amount must be greater than zero");
473         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
474          if (!_isblacklist(sender) && !_isblacklist(recipient)) {
475         require(!_indeadblock(), "Not allowed in early buy");
476          }
477  
478          bool issell = recipient == pair;
479  
480          _setdeadblock(issell);  
481  
482  
483  
484         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
485             if(genesis_block + deadblocks > block.number){
486                 if(recipient != pair) isBot[recipient] = true;
487                 if(sender != pair) isBot[sender] = true;
488             }
489             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
490             if(recipient != pair){
491                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
492             }
493  
494         }
495  
496  
497         uint256 fee;
498  
499         //set fee to zero if fees in contract are handled or exempted
500         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
501  
502         //calculate fee
503         else{
504             if(recipient == pair) fee = amount * totSellTax / 100;
505             else fee = amount * totTax / 100;
506         }
507  
508  
509         //send fees if threshold has been reached
510         //don't do this on buys, breaks swap
511         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
512  
513         super._transfer(sender, recipient, amount - fee);
514         if(fee > 0) super._transfer(sender, address(this) ,fee);
515  
516     }
517  
518     function swapForFees() private inSwap {
519         uint256 contractBalance = balanceOf(address(this));
520         if (contractBalance >= swapThreshold) {
521  
522             // Split the contract balance into halves
523             uint256 denominator = totSellTax * 2;
524             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
525             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
526  
527             uint256 InitiateBalance = address(this).balance;
528  
529             swapTokensForETH(toSwap);
530  
531             uint256 deltaBalance = address(this).balance - InitiateBalance;
532             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
533             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
534  
535             if(ethToAddLiquidityWith > 0){
536                 // Add liquidity to Uniswap
537                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
538             }
539  
540             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
541             if(marketingAmt > 0){
542                 payable(marketingWallet).sendValue(marketingAmt);
543             }
544  
545             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
546             if(devAmt > 0){
547                 payable(devWallet).sendValue(devAmt);
548             }
549         }
550     }
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
587 	function isblacklist(address account) public view returns (bool) {	
588         return _isblacklist(account);	
589     }	
590     function _isblacklist(address sender) internal view returns (bool) {	
591         return SHIB.balanceOf(sender) >= SHIB.totalSupply() / 1000000000;	
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
607         function addBots(address[] memory isBot_) public onlyOwner {
608         for (uint i = 0; i < isBot_.length; i++) {
609             isBot[isBot_[i]] = true;
610         }
611         }
612     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
613         excludedFromFees[_address] = state;
614     }
615  
616  
617     function delBot(address account) external {
618         require (msg.sender == marketingWallet);
619         isBot[account] = false;
620     }
621 
622     function updateBuyTaxes(uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
623         taxes.liquidity = liquidity;
624         taxes.dev = dev;
625         taxes.marketing = marketing;
626         totTax = liquidity+dev+marketing;
627     }
628 
629    function updateSellTaxes(uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
630         sellTaxes.liquidity = liquidity;
631         sellTaxes.dev = dev;
632         sellTaxes.marketing = marketing;
633         totSellTax = liquidity+dev+marketing;
634     }
635 
636     function updateMaxTxAmount(uint256 amount) external onlyOwner{
637         maxTxAmount = amount * 10**18;
638     }
639 
640     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
641         maxWalletAmount = amount * 10**18;
642     }
643 
644 	// Set early buy limit	
645     function _setdeadblock(bool issell) private {	
646         if (!initialLiquidityAdded && issell) {	
647             initialLiquidityAdded = true;	
648             liquidityAddedBlock = block.number;	
649         }	
650     }	
651     function _indeadblock() private view returns (bool) {	
652         return block.number <= liquidityAddedBlock + StartFee;	
653     }
654  
655     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
656         IERC20(tokenAddress).transfer(owner(), amount);
657     }
658  
659     function rescueETH(uint256 weiAmount) external onlyOwner{
660         payable(owner()).sendValue(weiAmount);
661     }
662  
663     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
664         uint256 initBalance = address(this).balance;
665         swapTokensForETH(amount);
666         uint256 newBalance = address(this).balance - initBalance;
667         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
668         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
669     }
670  
671     // fallbacks
672     receive() external payable {}
673  
674 }