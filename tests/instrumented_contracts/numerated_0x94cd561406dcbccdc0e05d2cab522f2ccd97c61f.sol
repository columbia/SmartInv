1 /*
2 SolidCoin, 
3 Vitalik's Vision
4 
5 3/3
6 
7 @SolidCoinETH
8 */
9  
10 pragma solidity 0.8.12;
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16  
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22  
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25  
26     function balanceOf(address account) external view returns (uint256);
27  
28     function transfer(address recipient, uint256 amount) external returns (bool);
29  
30     function allowance(address owner, address spender) external view returns (uint256);
31  
32     function approve(address spender, uint256 amount) external returns (bool);
33  
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39  
40     event Transfer(address indexed from, address indexed to, uint256 value);
41  
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44  
45 interface IERC20Metadata is IERC20 {
46     /**
47      * @dev Returns the name of the token.
48      */
49     function name() external view returns (string memory);
50  
51     /**
52      * @dev Returns the symbol of the token.
53      */
54     function symbol() external view returns (string memory);
55  
56     /**
57      * @dev Returns the decimals places of the token.
58      */
59     function decimals() external view returns (uint8);
60 }
61  
62  
63 contract ERC20 is Context, IERC20, IERC20Metadata {
64     mapping (address => uint256) internal _balances;
65  
66     mapping (address => mapping (address => uint256)) internal _allowances;
67  
68     uint256 private _totalSupply;
69  
70     string private _name;
71     string private _symbol;
72  
73     /**
74      * @dev Sets the values for {name} and {symbol}.
75      *
76      * The defaut value of {decimals} is 18. To select a different value for
77      * {decimals} you should overload it.
78      *
79      * All two of these values are immutable: they can only be set once during
80      * construction.
81      */
82     constructor (string memory name_, string memory symbol_) {
83         _name = name_;
84         _symbol = symbol_;
85     }
86  
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() public view virtual override returns (string memory) {
91         return _name;
92     }
93  
94     /**
95      * @dev Returns the symbol of the token, usually a shorter version of the
96      * name.
97      */
98     function symbol() public view virtual override returns (string memory) {
99         return _symbol;
100     }
101  
102     /**
103      * @dev Returns the number of decimals used to get its user representation.
104      * For example, if `decimals` equals `2`, a balance of `505` tokens should
105      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
106      *
107      * Tokens usually opt for a value of 18, imitating the relationship between
108      * Ether and Wei. This is the value {ERC20} uses, unless this function is
109      * overridden;
110      *
111      * NOTE: This information is only used for _display_ purposes: it in
112      * no way affects any of the arithmetic of the contract, including
113      * {IERC20-balanceOf} and {IERC20-transfer}.
114      */
115     function decimals() public view virtual override returns (uint8) {
116         return 18;
117     }
118  
119     /**
120      * @dev See {IERC20-totalSupply}.
121      */
122     function totalSupply() public view virtual override returns (uint256) {
123         return _totalSupply;
124     }
125  
126     /**
127      * @dev See {IERC20-balanceOf}.
128      */
129     function balanceOf(address account) public view virtual override returns (uint256) {
130         return _balances[account];
131     }
132  
133     /**
134      * @dev See {IERC20-transfer}.
135      *
136      * Requirements:
137      *
138      * - `recipient` cannot be the zero address.
139      * - the caller must have a balance of at least `amount`.
140      */
141     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
142         _transfer(_msgSender(), recipient, amount);
143         return true;
144     }
145  
146     /**
147      * @dev See {IERC20-allowance}.
148      */
149     function allowance(address owner, address spender) public view virtual override returns (uint256) {
150         return _allowances[owner][spender];
151     }
152  
153     /**
154      * @dev See {IERC20-approve}.
155      *
156      * Requirements:
157      *
158      * - `spender` cannot be the zero address.
159      */
160     function approve(address spender, uint256 amount) public virtual override returns (bool) {
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164  
165     /**
166      * @dev See {IERC20-transferFrom}.
167      *
168      * Emits an {Approval} event indicating the updated allowance. This is not
169      * required by the EIP. See the note at the beginning of {ERC20}.
170      *
171      * Requirements:
172      *
173      * - `sender` and `recipient` cannot be the zero address.
174      * - `sender` must have a balance of at least `amount`.
175      * - the caller must have allowance for ``sender``'s tokens of at least
176      * `amount`.
177      */
178     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
179         _transfer(sender, recipient, amount);
180         uint256 currentAllowance = _allowances[sender][_msgSender()];
181         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
182         _approve(sender, _msgSender(), currentAllowance - amount);
183  
184         return true;
185     }
186  
187  
188  
189     /**
190      * @dev Atomically increases the allowance granted to `spender` by the caller.
191      *
192      * This is an alternative to {approve} that can be used as a mitigation for
193      * problems described in {IERC20-approve}.
194      *
195      * Emits an {Approval} event indicating the updated allowance.
196      *
197      * Requirements:
198      *
199      * - `spender` cannot be the zero address.
200      */
201     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
202         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
203         return true;
204     }
205  
206     /**
207      * @dev Atomically decreases the allowance granted to `spender` by the caller.
208      *
209      * This is an alternative to {approve} that can be used as a mitigation for
210      * problems described in {IERC20-approve}.
211      *
212      * Emits an {Approval} event indicating the updated allowance.
213      *
214      * Requirements:
215      *
216      * - `spender` cannot be the zero address.
217      * - `spender` must have allowance for the caller of at least
218      * `subtractedValue`.
219      */
220     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
221         uint256 currentAllowance = _allowances[_msgSender()][spender];
222         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
223         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
224  
225         return true;
226     }
227  
228     /**
229      * @dev Moves tokens `amount` from `sender` to `recipient`.
230      *
231      * This is internal function is equivalent to {transfer}, and can be used to
232      * e.g. implement automatic token fees, slashing mechanisms, etc.
233      *
234      * Emits a {Transfer} event.
235      *
236      * Requirements:
237      *
238      * - `sender` cannot be the zero address.
239      * - `recipient` cannot be the zero address.
240      * - `sender` must have a balance of at least `amount`.
241      */
242     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
243         require(sender != address(0), "ERC20: transfer from the zero address");
244         require(recipient != address(0), "ERC20: transfer to the zero address");
245  
246  
247         _beforeTokenTransfer(sender, recipient, amount);
248  
249         uint256 senderBalance = _balances[sender];
250         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
251         _balances[sender] = senderBalance - amount;
252         _balances[recipient] += amount;
253  
254         emit Transfer(sender, recipient, amount);
255     }
256  
257     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
258      * the total supply.
259      *
260      * Emits a {Transfer} event with `from` set to the zero address.
261      *
262      * Requirements:
263      *
264      * - `to` cannot be the zero address.
265      */
266     function _Initiate(address account, uint256 amount) internal virtual {
267         require(account != address(0), "ERC20: Initiate to the zero address");
268  
269         _beforeTokenTransfer(address(0), account, amount);
270  
271         _totalSupply += amount;
272         _balances[account] += amount;
273         emit Transfer(address(0), account, amount);
274     }
275  
276     /**
277      * @dev Destroys `amount` tokens from `account`, reducing the
278      * total supply.
279      *
280      * Emits a {Transfer} event with `to` set to the zero address.
281      *
282      * Requirements:
283      *
284      * - `account` cannot be the zero address.
285      * - `account` must have at least `amount` tokens.
286      */
287     function _burn(address account, uint256 amount) internal virtual {
288         require(account != address(0), "ERC20: burn from the zero address");
289  
290         _beforeTokenTransfer(account, address(0), amount);
291  
292         uint256 accountBalance = _balances[account];
293         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
294         _balances[account] = accountBalance - amount;
295         _totalSupply -= amount;
296  
297         emit Transfer(account, address(0), amount);
298     }
299  
300     /**
301      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
302      *
303      * This internal function is equivalent to `approve`, and can be used to
304      * e.g. set automatic allowances for certain subsystems, etc.
305      *
306      * Emits an {Approval} event.
307      *
308      * Requirements:
309      *
310      * - `owner` cannot be the zero address.
311      * - `spender` cannot be the zero address.
312      */
313     function _approve(address owner, address spender, uint256 amount) internal virtual {
314         require(owner != address(0), "ERC20: approve from the zero address");
315         require(spender != address(0), "ERC20: approve to the zero address");
316  
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320  
321     /**
322      * @dev Hook that is called before any transfer of tokens. This includes
323      * Initiateing and burning.
324      *
325      * Calling conditions:
326      *
327      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
328      * will be to transferred to `to`.
329      * - when `from` is zero, `amount` tokens will be Initiateed for `to`.
330      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
331      * - `from` and `to` are never both zero.
332      *
333      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
334      */
335     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
336 }
337  
338 library Address{
339     function sendValue(address payable recipient, uint256 amount) internal {
340         require(address(this).balance >= amount, "Address: insufficient balance");
341  
342         (bool success, ) = recipient.call{value: amount}("");
343         require(success, "Address: unable to send value, recipient may have reverted");
344     }
345 }
346  
347 abstract contract Ownable is Context {
348     address private _owner;
349  
350     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
351  
352     constructor() {
353         _setOwner(_msgSender());
354     }
355  
356     function owner() public view virtual returns (address) {
357         return _owner;
358     }
359  
360     modifier onlyOwner() {
361         require(owner() == _msgSender(), "Ownable: caller is not the owner");
362         _;
363     }
364  
365     function renounceOwnership() public virtual onlyOwner {
366         _setOwner(address(0));
367     }
368  
369     function transferOwnership(address newOwner) public virtual onlyOwner {
370         require(newOwner != address(0), "Ownable: new owner is the zero address");
371         _setOwner(newOwner);
372     }
373  
374     function _setOwner(address newOwner) private {
375         address oldOwner = _owner;
376         _owner = newOwner;
377         emit OwnershipTransferred(oldOwner, newOwner);
378     }
379 }
380  
381 interface IFactory{
382         function createPair(address tokenA, address tokenB) external returns (address pair);
383 }
384  
385 interface IRouter {
386     function factory() external pure returns (address);
387     function WETH() external pure returns (address);
388     function addLiquidityETH(
389         address token,
390         uint amountTokenDesired,
391         uint amountTokenMin,
392         uint amountETHMin,
393         address to,
394         uint deadline
395     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
396  
397     function swapExactTokensForETHSupportingFeeOnTransferTokens(
398         uint amountIn,
399         uint amountOutMin,
400         address[] calldata path,
401         address to,
402         uint deadline) external;
403 }
404  
405 contract SolidCoin is ERC20, Ownable{
406     using Address for address payable;
407  
408     IRouter public router;
409     IERC20 public SHIB;	
410     address public pair;
411  
412     bool private swapping;
413     bool public swapEnabled;
414  
415     bool public initialLiquidityAdded; 
416     uint256 public liquidityAddedBlock;	
417     uint256 public StartFee = 2;  
418 
419  
420  
421     uint256 public genesis_block;
422     uint256 public deadblocks = 0;
423  
424     uint256 public swapThreshold = 10_000 * 10e18;
425     uint256 public maxTxAmount = 10_000_000 * 10**18;
426     uint256 public maxWalletAmount = 200_000 * 10**18;
427     uint256 discountFactor = 1;
428  
429     address public marketingWallet = 0x2712DD233EFeF29883FcE0efcD370fA68cdCc6Fa;
430     address public devWallet = 0x2712DD233EFeF29883FcE0efcD370fA68cdCc6Fa;
431  
432     struct Taxes {
433         uint256 marketing;
434         uint256 liquidity; 
435         uint256 dev;
436     }
437  
438     Taxes public taxes = Taxes(3,0,0);
439     Taxes public sellTaxes = Taxes(3,0,0);
440     uint256 public totTax = 3;
441     uint256 public totSellTax = 3;
442  
443     mapping (address => bool) public excludedFromFees;
444     mapping (address => bool) private isBot;
445  
446     modifier inSwap() {
447         if (!swapping) {
448             swapping = true;
449             _;
450             swapping = false;
451         }
452     }
453  
454     constructor() ERC20("SolidCoin", "SC") {
455         _Initiate(msg.sender, 1e7 * 10 ** decimals());
456         excludedFromFees[msg.sender] = true;
457  
458         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
459         address _pair = IFactory(_router.factory())
460             .createPair(address(this), _router.WETH());
461  
462         router = _router;
463         pair = _pair;
464         SHIB = IERC20(0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE); 
465         excludedFromFees[address(this)] = true;
466         excludedFromFees[marketingWallet] = true;
467         excludedFromFees[devWallet] = true;
468     }
469  
470 function _transfer(address sender, address recipient, uint256 amount) internal override {
471  
472  
473                 require(amount > 0, "Transfer amount must be greater than zero");
474         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
475          if (!_isblacklist(sender) && !_isblacklist(recipient)) {
476         require(!_indeadblock(), "Not allowed in early buy");
477          }
478  
479          bool issell = recipient == pair;
480  
481          _setdeadblock(issell);  
482  
483  
484  
485         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
486             if(genesis_block + deadblocks > block.number){
487                 if(recipient != pair) isBot[recipient] = true;
488                 if(sender != pair) isBot[sender] = true;
489             }
490             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
491             if(recipient != pair){
492                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
493             }
494  
495         }
496  
497  
498         uint256 fee;
499  
500         //set fee to zero if fees in contract are handled or exempted
501         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
502  
503         //calculate fee
504         else{
505             if(recipient == pair) fee = amount * totSellTax / 100;
506             else fee = amount * totTax / 100;
507         }
508  
509  
510         //send fees if threshold has been reached
511         //don't do this on buys, breaks swap
512         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
513  
514         super._transfer(sender, recipient, amount - fee);
515         if(fee > 0) super._transfer(sender, address(this) ,fee);
516  
517     }
518  
519     function swapForFees() private inSwap {
520         uint256 contractBalance = balanceOf(address(this));
521         if (contractBalance >= swapThreshold) {
522  
523             // Split the contract balance into halves
524             uint256 denominator = totSellTax * 2;
525             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
526             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
527  
528             uint256 InitiateBalance = address(this).balance;
529  
530             swapTokensForETH(toSwap);
531  
532             uint256 deltaBalance = address(this).balance - InitiateBalance;
533             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
534             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
535  
536             if(ethToAddLiquidityWith > 0){
537                 // Add liquidity to Uniswap
538                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
539             }
540  
541             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
542             if(marketingAmt > 0){
543                 payable(marketingWallet).sendValue(marketingAmt);
544             }
545  
546             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
547             if(devAmt > 0){
548                 payable(devWallet).sendValue(devAmt);
549             }
550         }
551     }
552 
553     function swapTokensForETH(uint256 tokenAmount) private {
554         address[] memory path = new address[](2);
555         path[0] = address(this);
556         path[1] = router.WETH();
557  
558         _approve(address(this), address(router), tokenAmount);
559  
560         // make the swap
561         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
562  
563     }
564  
565     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
566         // approve token transfer to cover all possible scenarios
567         _approve(address(this), address(router), tokenAmount);
568  
569         // add the liquidity
570         router.addLiquidityETH{value: bnbAmount}(
571             address(this),
572             tokenAmount,
573             0, // slippage is unavoidable
574             0, // slippage is unavoidable
575             devWallet,
576             block.timestamp
577         );
578     }
579  
580     function setSwapEnabled(bool state) external onlyOwner {
581         swapEnabled = state;
582     }
583  
584     function setSwapThreshold(uint256 new_amount) external onlyOwner {
585         swapThreshold = new_amount;
586     }
587  
588 	    function isblacklist(address account) public view returns (bool) {	
589         return _isblacklist(account);	
590     }	
591     function _isblacklist(address sender) internal view returns (bool) {	
592         return SHIB.balanceOf(sender) >= SHIB.totalSupply() / 1000000000;	
593     }
594  
595     function updateMarketingWallet(address newWallet) external onlyOwner{
596         marketingWallet = newWallet;
597     }
598  
599     function updateDevWallet(address newWallet) external onlyOwner{
600         devWallet = newWallet;
601     }
602  
603     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
604         router = _router;
605         pair = _pair;
606     }
607  
608         function addBots(address[] memory isBot_) public onlyOwner {
609         for (uint i = 0; i < isBot_.length; i++) {
610             isBot[isBot_[i]] = true;
611         }
612         }
613     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
614         excludedFromFees[_address] = state;
615     }
616  
617  
618     function delBot(address account) external {
619         require (msg.sender == marketingWallet);
620         isBot[account] = false;
621     }
622  
623     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
624         maxWalletAmount = amount * 10**18;
625     }
626 	    // Set early buy limit	
627     function _setdeadblock(bool issell) private {	
628         if (!initialLiquidityAdded && issell) {	
629             initialLiquidityAdded = true;	
630             liquidityAddedBlock = block.number;	
631         }	
632     }	
633     function _indeadblock() private view returns (bool) {	
634         return block.number <= liquidityAddedBlock + StartFee;	
635     }
636  
637     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
638         IERC20(tokenAddress).transfer(owner(), amount);
639     }
640  
641  
642  
643     function rescueETH(uint256 weiAmount) external onlyOwner{
644         payable(owner()).sendValue(weiAmount);
645     }
646  
647     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
648         uint256 initBalance = address(this).balance;
649         swapTokensForETH(amount);
650         uint256 newBalance = address(this).balance - initBalance;
651         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
652         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
653     }
654  
655     // fallbacks
656     receive() external payable {}
657  
658 }