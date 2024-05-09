1 /**
2 
3     Telegram: https://t.me/BabyShibaCoinio
4 
5     ██████╗░░█████╗░██████╗░██╗░░░██╗  ░██████╗██╗░░██╗██╗██████╗░░█████╗░
6     ██╔══██╗██╔══██╗██╔══██╗╚██╗░██╔╝  ██╔════╝██║░░██║██║██╔══██╗██╔══██╗
7     ██████╦╝███████║██████╦╝░╚████╔╝░  ╚█████╗░███████║██║██████╦╝███████║
8     ██╔══██╗██╔══██║██╔══██╗░░╚██╔╝░░  ░╚═══██╗██╔══██║██║██╔══██╗██╔══██║
9     ██████╦╝██║░░██║██████╦╝░░░██║░░░  ██████╔╝██║░░██║██║██████╦╝██║░░██║
10     ╚═════╝░╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░  ╚═════╝░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝░░╚═╝
11 
12 */
13 
14 //SPDX-License-Identifier: MIT
15 pragma solidity ^0.8.7;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     function approve(address spender, uint256 amount) external returns (bool);
38 
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns (bool);
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 interface IERC20Metadata is IERC20 {
51     /**
52      * @dev Returns the name of the token.
53      */
54     function name() external view returns (string memory);
55 
56     /**
57      * @dev Returns the symbol of the token.
58      */
59     function symbol() external view returns (string memory);
60 
61     /**
62      * @dev Returns the decimals places of the token.
63      */
64     function decimals() external view returns (uint8);
65 }
66 
67 
68 contract ERC20 is Context, IERC20, IERC20Metadata {
69     mapping (address => uint256) internal _balances;
70 
71     mapping (address => mapping (address => uint256)) internal _allowances;
72 
73     uint256 private _totalSupply;
74 
75     string private _name;
76     string private _symbol;
77 
78     /**
79      * @dev Sets the values for {name} and {symbol}.
80      *
81      * The defaut value of {decimals} is 18. To select a different value for
82      * {decimals} you should overload it.
83      *
84      * All two of these values are immutable: they can only be set once during
85      * construction.
86      */
87     constructor (string memory name_, string memory symbol_) {
88         _name = name_;
89         _symbol = symbol_;
90     }
91 
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() public view virtual override returns (string memory) {
96         return _name;
97     }
98 
99     /**
100      * @dev Returns the symbol of the token, usually a shorter version of the
101      * name.
102      */
103     function symbol() public view virtual override returns (string memory) {
104         return _symbol;
105     }
106 
107     /**
108      * @dev Returns the number of decimals used to get its user representation.
109      * For example, if `decimals` equals `2`, a balance of `505` tokens should
110      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
111      *
112      * Tokens usually opt for a value of 18, imitating the relationship between
113      * Ether and Wei. This is the value {ERC20} uses, unless this function is
114      * overridden;
115      *
116      * NOTE: This information is only used for _display_ purposes: it in
117      * no way affects any of the arithmetic of the contract, including
118      * {IERC20-balanceOf} and {IERC20-transfer}.
119      */
120     function decimals() public view virtual override returns (uint8) {
121         return 18;
122     }
123 
124     /**
125      * @dev See {IERC20-totalSupply}.
126      */
127     function totalSupply() public view virtual override returns (uint256) {
128         return _totalSupply;
129     }
130 
131     /**
132      * @dev See {IERC20-balanceOf}.
133      */
134     function balanceOf(address account) public view virtual override returns (uint256) {
135         return _balances[account];
136     }
137 
138     /**
139      * @dev See {IERC20-transfer}.
140      *
141      * Requirements:
142      *
143      * - `recipient` cannot be the zero address.
144      * - the caller must have a balance of at least `amount`.
145      */
146     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
147         _transfer(_msgSender(), recipient, amount);
148         return true;
149     }
150 
151     /**
152      * @dev See {IERC20-allowance}.
153      */
154     function allowance(address owner, address spender) public view virtual override returns (uint256) {
155         return _allowances[owner][spender];
156     }
157 
158     /**
159      * @dev See {IERC20-approve}.
160      *
161      * Requirements:
162      *
163      * - `spender` cannot be the zero address.
164      */
165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169 
170     /**
171      * @dev See {IERC20-transferFrom}.
172      *
173      * Emits an {Approval} event indicating the updated allowance. This is not
174      * required by the EIP. See the note at the beginning of {ERC20}.
175      *
176      * Requirements:
177      *
178      * - `sender` and `recipient` cannot be the zero address.
179      * - `sender` must have a balance of at least `amount`.
180      * - the caller must have allowance for ``sender``'s tokens of at least
181      * `amount`.
182      */
183     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
184         _transfer(sender, recipient, amount);
185 
186         uint256 currentAllowance = _allowances[sender][_msgSender()];
187         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
188         _approve(sender, _msgSender(), currentAllowance - amount);
189 
190         return true;
191     }
192 
193     /**
194      * @dev Atomically increases the allowance granted to `spender` by the caller.
195      *
196      * This is an alternative to {approve} that can be used as a mitigation for
197      * problems described in {IERC20-approve}.
198      *
199      * Emits an {Approval} event indicating the updated allowance.
200      *
201      * Requirements:
202      *
203      * - `spender` cannot be the zero address.
204      */
205     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
206         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
207         return true;
208     }
209 
210     /**
211      * @dev Atomically decreases the allowance granted to `spender` by the caller.
212      *
213      * This is an alternative to {approve} that can be used as a mitigation for
214      * problems described in {IERC20-approve}.
215      *
216      * Emits an {Approval} event indicating the updated allowance.
217      *
218      * Requirements:
219      *
220      * - `spender` cannot be the zero address.
221      * - `spender` must have allowance for the caller of at least
222      * `subtractedValue`.
223      */
224     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
225         uint256 currentAllowance = _allowances[_msgSender()][spender];
226         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
227         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
228 
229         return true;
230     }
231 
232     /**
233      * @dev Moves tokens `amount` from `sender` to `recipient`.
234      *
235      * This is internal function is equivalent to {transfer}, and can be used to
236      * e.g. implement automatic token fees, slashing mechanisms, etc.
237      *
238      * Emits a {Transfer} event.
239      *
240      * Requirements:
241      *
242      * - `sender` cannot be the zero address.
243      * - `recipient` cannot be the zero address.
244      * - `sender` must have a balance of at least `amount`.
245      */
246     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
247         require(sender != address(0), "ERC20: transfer from the zero address");
248         require(recipient != address(0), "ERC20: transfer to the zero address");
249 
250         _beforeTokenTransfer(sender, recipient, amount);
251 
252         uint256 senderBalance = _balances[sender];
253         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
254         _balances[sender] = senderBalance - amount;
255         _balances[recipient] += amount;
256 
257         emit Transfer(sender, recipient, amount);
258     }
259 
260     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
261      * the total supply.
262      *
263      * Emits a {Transfer} event with `from` set to the zero address.
264      *
265      * Requirements:
266      *
267      * - `to` cannot be the zero address.
268      */
269     function _mint(address account, uint256 amount) internal virtual {
270         require(account != address(0), "ERC20: mint to the zero address");
271 
272         _beforeTokenTransfer(address(0), account, amount);
273 
274         _totalSupply += amount;
275         _balances[account] += amount;
276         emit Transfer(address(0), account, amount);
277     }
278 
279     /**
280      * @dev Destroys `amount` tokens from `account`, reducing the
281      * total supply.
282      *
283      * Emits a {Transfer} event with `to` set to the zero address.
284      *
285      * Requirements:
286      *
287      * - `account` cannot be the zero address.
288      * - `account` must have at least `amount` tokens.
289      */
290     function _burn(address account, uint256 amount) internal virtual {
291         require(account != address(0), "ERC20: burn from the zero address");
292 
293         _beforeTokenTransfer(account, address(0), amount);
294 
295         uint256 accountBalance = _balances[account];
296         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
297         _balances[account] = accountBalance - amount;
298         _totalSupply -= amount;
299 
300         emit Transfer(account, address(0), amount);
301     }
302 
303     /**
304      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
305      *
306      * This internal function is equivalent to `approve`, and can be used to
307      * e.g. set automatic allowances for certain subsystems, etc.
308      *
309      * Emits an {Approval} event.
310      *
311      * Requirements:
312      *
313      * - `owner` cannot be the zero address.
314      * - `spender` cannot be the zero address.
315      */
316     function _approve(address owner, address spender, uint256 amount) internal virtual {
317         require(owner != address(0), "ERC20: approve from the zero address");
318         require(spender != address(0), "ERC20: approve to the zero address");
319 
320         _allowances[owner][spender] = amount;
321         emit Approval(owner, spender, amount);
322     }
323 
324     /**
325      * @dev Hook that is called before any transfer of tokens. This includes
326      * minting and burning.
327      *
328      * Calling conditions:
329      *
330      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
331      * will be to transferred to `to`.
332      * - when `from` is zero, `amount` tokens will be minted for `to`.
333      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
334      * - `from` and `to` are never both zero.
335      *
336      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
337      */
338     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
339 }
340 
341 library Address{
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         (bool success, ) = recipient.call{value: amount}("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 }
349 
350 abstract contract Ownable is Context {
351     address private _owner;
352 
353     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
354 
355     constructor() {
356         _setOwner(_msgSender());
357     }
358 
359     function owner() public view virtual returns (address) {
360         return _owner;
361     }
362 
363     modifier onlyOwner() {
364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
365         _;
366     }
367 
368     function renounceOwnership() public virtual onlyOwner {
369         _setOwner(address(0));
370     }
371 
372     function transferOwnership(address newOwner) public virtual onlyOwner {
373         require(newOwner != address(0), "Ownable: new owner is the zero address");
374         _setOwner(newOwner);
375     }
376 
377     function _setOwner(address newOwner) private {
378         address oldOwner = _owner;
379         _owner = newOwner;
380         emit OwnershipTransferred(oldOwner, newOwner);
381     }
382 }
383 
384 interface IFactory{
385         function createPair(address tokenA, address tokenB) external returns (address pair);
386 }
387 
388 interface IRouter {
389     function factory() external pure returns (address);
390     function WETH() external pure returns (address);
391     function addLiquidityETH(
392         address token,
393         uint amountTokenDesired,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline
398     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
399 
400     function swapExactTokensForETHSupportingFeeOnTransferTokens(
401         uint amountIn,
402         uint amountOutMin,
403         address[] calldata path,
404         address to,
405         uint deadline) external;
406 }
407 
408 contract BabyShibaCoin is ERC20, Ownable{
409     using Address for address payable;
410     
411     IRouter public router;
412     address public pair;
413     
414     bool private _liquidityMutex = false;
415     bool public providingLiquidity = false;
416     bool public tradingEnabled = false;
417     
418     uint256 public tokenLiquidityThreshold = 420_000 * 10**18;
419     uint256 public maxBuyLimit = 4_200_000 * 10**18;
420     uint256 public maxSellLimit = 2_100_000 * 10**18;
421     uint256 public maxWalletLimit = 8_400_000 * 10**18;
422 
423     uint256 public genesis_block;
424     
425     address public marketingWallet = 0xbed0a7b3E328B422C324A59be18470197AD96c5B;
426     address public devWallet = 0xd4aC7025c9E9BdB646149C2b1b059371a43E64D0;
427     address public operationWallet = 0x48Ae088724118c33781c8Ca7335Ac369aF47057d;
428     
429     struct Taxes {
430         uint256 marketing;
431         uint256 liquidity; 
432         uint256 dev;
433         uint256 operation;
434     }
435     
436     Taxes public taxes = Taxes(3, 0, 1, 1);
437     Taxes public sellTaxes = Taxes(3, 0, 1, 1);
438     
439     mapping (address => bool) public exemptFee;
440     mapping (address => bool) public isBlacklisted;
441     mapping (address => bool) public allowedTransfer;
442     
443     //Anti Dump
444     mapping(address => uint256) private _lastSell;
445     bool public coolDownEnabled = true;
446     uint256 public coolDownTime = 60 seconds;
447     
448     modifier antiBot(address account){
449         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
450         _;
451     }
452     
453     modifier mutexLock() {
454         if (!_liquidityMutex) {
455             _liquidityMutex = true;
456             _;
457             _liquidityMutex = false;
458         }
459     }
460     
461     constructor() ERC20("Baby Shiba Coin", "BabyShiba") {
462         _mint(msg.sender, 420000000 * 10 ** decimals());
463         exemptFee[msg.sender] = true;
464 
465         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
466          // Create a koffeeSwap pair for this new token
467         address _pair = IFactory(_router.factory())
468             .createPair(address(this), _router.WETH());
469  
470         router = _router;
471         pair = _pair;
472         exemptFee[address(this)] = true;
473         exemptFee[marketingWallet] = true;
474         exemptFee[devWallet] = true;
475         exemptFee[operationWallet] = true;
476         
477         allowedTransfer[address(this)] = true;
478         allowedTransfer[owner()] = true;
479         allowedTransfer[pair] = true;
480         allowedTransfer[marketingWallet] = true;
481         allowedTransfer[devWallet] = true;
482         allowedTransfer[operationWallet] = true;
483         
484     }
485     
486     function approve(address spender, uint256 amount) public  override antiBot(msg.sender) returns(bool) {
487         _approve(_msgSender(), spender, amount);
488         return true;
489     }
490 
491     function transferFrom(address sender, address recipient, uint256 amount) public override antiBot(sender) returns (bool) {
492         _transfer(sender, recipient, amount);
493 
494         uint256 currentAllowance = _allowances[sender][_msgSender()];
495         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
496         _approve(sender, _msgSender(), currentAllowance - amount);
497 
498         return true;
499     }
500 
501     function increaseAllowance(address spender, uint256 addedValue) public override antiBot(msg.sender) returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
503         return true;
504     }
505 
506     function decreaseAllowance(address spender, uint256 subtractedValue) public override antiBot(msg.sender) returns (bool) {
507         uint256 currentAllowance = _allowances[_msgSender()][spender];
508         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
509         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
510 
511         return true;
512     }
513     
514     function transfer(address recipient, uint256 amount) public override antiBot(msg.sender) returns (bool)
515     { 
516       _transfer(msg.sender, recipient, amount);
517       return true;
518     }
519     
520     function _transfer(address sender, address recipient, uint256 amount) internal override {
521         require(amount > 0, "Transfer amount must be greater than zero");
522         require(!isBlacklisted[sender] && !isBlacklisted[recipient], "You can't transfer tokens");
523         if(recipient == pair && genesis_block == 0) genesis_block = block.number;
524         if(!exemptFee[sender] && !exemptFee[recipient]){
525             require(tradingEnabled, "Trading not enabled");
526         }
527         
528         if(sender == pair && !exemptFee[recipient] && !_liquidityMutex){
529             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
530             require(balanceOf(recipient) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
531         }
532         
533         if(sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex){
534             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
535             if(recipient != pair){
536                 require(balanceOf(recipient) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
537             }
538             if(coolDownEnabled){
539                 uint256 timePassed = block.timestamp - _lastSell[sender];
540                 require(timePassed >= coolDownTime, "Cooldown enabled");
541                 _lastSell[sender] = block.timestamp;
542             }
543         }
544         
545         
546         if(balanceOf(sender) - amount <= 10 *  10**decimals()) amount -= (10 * 10**decimals() + amount - balanceOf(sender));
547 
548         uint256 feeswap;
549         uint256 feesum;
550         uint256 fee;
551         Taxes memory currentTaxes;
552 
553         if(!exemptFee[sender] && !exemptFee[recipient] && block.number <= genesis_block + 3) {
554             require(recipient != pair, "Sells not allowed for first 3 blocks");
555         }
556         
557         //set fee to zero if fees in contract are handled or exempted
558         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient]) fee = 0;
559         
560         //calculate fee
561         else if(recipient == pair){
562             feeswap = sellTaxes.liquidity + sellTaxes.marketing + sellTaxes.dev + sellTaxes.operation;
563             feesum = feeswap;
564             currentTaxes = sellTaxes;
565         }
566         else{
567             feeswap =  taxes.liquidity + taxes.marketing + taxes.dev + taxes.operation;
568             feesum = feeswap;
569             currentTaxes = taxes;
570         }
571         
572         fee = amount * feesum / 100;
573 
574         //send fees if threshold has been reached
575         //don't do this on buys, breaks swap
576         if (providingLiquidity && sender != pair && feeswap > 0) handle_fees(feeswap, currentTaxes);
577 
578         //rest to recipient
579         super._transfer(sender, recipient, amount - fee);
580         if(fee > 0){
581             //send the fee to the contract
582             if (feeswap > 0) {
583                 uint256 feeAmount = amount * feeswap / 100;
584                 super._transfer(sender, address(this), feeAmount);
585             }
586 
587         }
588 
589     }
590 
591     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
592         uint256 contractBalance = balanceOf(address(this));
593         if (contractBalance >= tokenLiquidityThreshold) {
594             if(tokenLiquidityThreshold > 1){
595                 contractBalance = tokenLiquidityThreshold;
596             }
597 
598             // Split the contract balance into halves
599             uint256 denominator = feeswap * 2;
600             uint256 tokensToAddLiquidityWith = contractBalance * swapTaxes.liquidity / denominator;
601             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
602     
603             uint256 initialBalance = address(this).balance;
604     
605             swapTokensForBNB(toSwap);
606     
607             uint256 deltaBalance = address(this).balance - initialBalance;
608             uint256 unitBalance= deltaBalance / (denominator - swapTaxes.liquidity);
609             uint256 bnbToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
610     
611             if(bnbToAddLiquidityWith > 0){
612                 // Add liquidity
613                 addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
614             }
615     
616             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
617             if(marketingAmt > 0){
618                 payable(marketingWallet).sendValue(marketingAmt);
619             }
620             
621             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
622             if(devAmt > 0){
623                 payable(devWallet).sendValue(devAmt);
624             }
625             
626             uint256 operationAmt = unitBalance * 2 * swapTaxes.operation;
627             if(operationAmt > 0){
628                 payable(operationWallet).sendValue(operationAmt);
629             }
630         }
631     }
632 
633 
634     function swapTokensForBNB(uint256 tokenAmount) private {
635         // generate the uniswap pair path of token -> weth
636         address[] memory path = new address[](2);
637         path[0] = address(this);
638         path[1] = router.WETH();
639 
640         _approve(address(this), address(router), tokenAmount);
641 
642         // make the swap
643         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
644 
645     }
646 
647     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
648         // approve token transfer to cover all possible scenarios
649         _approve(address(this), address(router), tokenAmount);
650 
651         // add the liquidity
652         router.addLiquidityETH{value: bnbAmount}(
653             address(this),
654             tokenAmount,
655             0, // slippage is unavoidable
656             0, // slippage is unavoidable
657             owner(),
658             block.timestamp
659         );
660     }
661 
662     function updateLiquidityProvide(bool state) external onlyOwner {
663         //update liquidity providing state
664         providingLiquidity = state;
665     }
666 
667     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
668         //update the treshhold
669         tokenLiquidityThreshold = new_amount;
670     }
671 
672     function updateTaxes(Taxes memory newTaxes) external onlyOwner{
673         taxes = newTaxes;
674     }
675     
676     function updateSellTaxes(Taxes memory newSellTaxes) external onlyOwner{
677         sellTaxes = newSellTaxes;
678     }
679     
680     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
681         router = IRouter(newRouter);
682         pair = newPair;
683     }
684     
685     function updateTradingEnabled(bool state) external onlyOwner{
686         tradingEnabled = state;
687         providingLiquidity = state;
688     }
689     
690     function updateMarketingWallet(address newWallet) external onlyOwner{
691         marketingWallet = newWallet;
692     }
693     
694     function updateDevWallet(address newWallet) external onlyOwner{
695         devWallet = newWallet;
696     }
697     
698     function updateOperationWallet(address newWallet) external onlyOwner{
699         operationWallet = newWallet;
700     }
701     
702     function updateCooldown(bool state, uint256 time) external onlyOwner{
703         coolDownTime = time * 1 seconds;
704         coolDownEnabled = state;
705     }
706     
707     function updateIsBlacklisted(address account, bool state) external onlyOwner{
708         isBlacklisted[account] = state;
709     }
710     
711     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
712         for(uint256 i =0; i < accounts.length; i++){
713             isBlacklisted[accounts[i]] = state;
714 
715         }
716     }
717     
718     function updateAllowedTransfer(address account, bool state) external onlyOwner{
719         allowedTransfer[account] = state;
720     }
721     
722     function updateExemptFee(address _address, bool state) external onlyOwner {
723         exemptFee[_address] = state;
724     }
725     
726     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner{
727         for(uint256 i = 0; i < accounts.length; i++){
728             exemptFee[accounts[i]] = state;
729         }
730     }
731     
732     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
733         maxBuyLimit = maxBuy * 10**decimals();
734         maxSellLimit = maxSell * 10**decimals();
735     }
736     
737     function updateMaxWalletlimit(uint256 amount) external onlyOwner{
738         maxWalletLimit = amount * 10**decimals();
739     }
740 
741     function rescueBNB(uint256 weiAmount) external onlyOwner{
742         payable(devWallet).transfer(weiAmount);
743     }
744     
745     function rescueBEP20(address tokenAdd, uint256 amount) external onlyOwner{
746         IERC20(tokenAdd).transfer(devWallet, amount);
747     }
748 
749     // fallbacks
750     receive() external payable {}
751     
752     
753 }