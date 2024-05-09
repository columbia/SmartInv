1 //SPDX-License-Identifier: MIT
2 
3 /*
4 PULSESHIBA ($PLSS)
5 
6 $PLSS is a low-tax memecoin inspired by Pulse Chain & Shiba Inu. Our goal is to become one of the hottest memecoin on both ERC20 and PULSECHAIN.
7 
8 TOKENOMICS
9 
10 3% Tax
11 Liquidity Locked for 1 Month 
12 Ownership Renounced
13 
14 PULSECHAIN BRIDGE
15 
16 The PulseChain cross-chain bridge will occur in Q4 2022. All holders will be airdropped 1 for 1 of $PLSS on PRC20.
17 
18 Website: https://pulseshibatoken.com
19 Telegram: @PulseShibaERC
20 */
21 
22 pragma solidity 0.8.12;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37 
38     function balanceOf(address account) external view returns (uint256);
39 
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     function transferFrom(
47         address sender,
48         address recipient,
49         uint256 amount
50     ) external returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 interface IERC20Metadata is IERC20 {
58     /**
59      * @dev Returns the name of the token.
60      */
61     function name() external view returns (string memory);
62 
63     /**
64      * @dev Returns the symbol of the token.
65      */
66     function symbol() external view returns (string memory);
67 
68     /**
69      * @dev Returns the decimals places of the token.
70      */
71     function decimals() external view returns (uint8);
72 }
73 
74 
75 contract ERC20 is Context, IERC20, IERC20Metadata {
76     mapping (address => uint256) internal _balances;
77 
78     mapping (address => mapping (address => uint256)) internal _allowances;
79 
80     uint256 private _totalSupply;
81 
82     string private _name;
83     string private _symbol;
84 
85     /**
86      * @dev Sets the values for {name} and {symbol}.
87      *
88      * The defaut value of {decimals} is 18. To select a different value for
89      * {decimals} you should overload it.
90      *
91      * All two of these values are immutable: they can only be set once during
92      * construction.
93      */
94     constructor (string memory name_, string memory symbol_) {
95         _name = name_;
96         _symbol = symbol_;
97     }
98 
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() public view virtual override returns (string memory) {
103         return _name;
104     }
105 
106     /**
107      * @dev Returns the symbol of the token, usually a shorter version of the
108      * name.
109      */
110     function symbol() public view virtual override returns (string memory) {
111         return _symbol;
112     }
113 
114     /**
115      * @dev Returns the number of decimals used to get its user representation.
116      * For example, if `decimals` equals `2`, a balance of `505` tokens should
117      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
118      *
119      * Tokens usually opt for a value of 18, imitating the relationship between
120      * Ether and Wei. This is the value {ERC20} uses, unless this function is
121      * overridden;
122      *
123      * NOTE: This information is only used for _display_ purposes: it in
124      * no way affects any of the arithmetic of the contract, including
125      * {IERC20-balanceOf} and {IERC20-transfer}.
126      */
127     function decimals() public view virtual override returns (uint8) {
128         return 18;
129     }
130 
131     /**
132      * @dev See {IERC20-totalSupply}.
133      */
134     function totalSupply() public view virtual override returns (uint256) {
135         return _totalSupply;
136     }
137 
138     /**
139      * @dev See {IERC20-balanceOf}.
140      */
141     function balanceOf(address account) public view virtual override returns (uint256) {
142         return _balances[account];
143     }
144 
145     /**
146      * @dev See {IERC20-transfer}.
147      *
148      * Requirements:
149      *
150      * - `recipient` cannot be the zero address.
151      * - the caller must have a balance of at least `amount`.
152      */
153     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
154         _transfer(_msgSender(), recipient, amount);
155         return true;
156     }
157 
158     /**
159      * @dev See {IERC20-allowance}.
160      */
161     function allowance(address owner, address spender) public view virtual override returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165     /**
166      * @dev See {IERC20-approve}.
167      *
168      * Requirements:
169      *
170      * - `spender` cannot be the zero address.
171      */
172     function approve(address spender, uint256 amount) public virtual override returns (bool) {
173         _approve(_msgSender(), spender, amount);
174         return true;
175     }
176 
177     /**
178      * @dev See {IERC20-transferFrom}.
179      *
180      * Emits an {Approval} event indicating the updated allowance. This is not
181      * required by the EIP. See the note at the beginning of {ERC20}.
182      *
183      * Requirements:
184      *
185      * - `sender` and `recipient` cannot be the zero address.
186      * - `sender` must have a balance of at least `amount`.
187      * - the caller must have allowance for ``sender``'s tokens of at least
188      * `amount`.
189      */
190     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
191         _transfer(sender, recipient, amount);
192 
193         uint256 currentAllowance = _allowances[sender][_msgSender()];
194         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
195         _approve(sender, _msgSender(), currentAllowance - amount);
196 
197         return true;
198     }
199 
200     /**
201      * @dev Atomically increases the allowance granted to `spender` by the caller.
202      *
203      * This is an alternative to {approve} that can be used as a mitigation for
204      * problems described in {IERC20-approve}.
205      *
206      * Emits an {Approval} event indicating the updated allowance.
207      *
208      * Requirements:
209      *
210      * - `spender` cannot be the zero address.
211      */
212     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
213         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
214         return true;
215     }
216 
217     /**
218      * @dev Atomically decreases the allowance granted to `spender` by the caller.
219      *
220      * This is an alternative to {approve} that can be used as a mitigation for
221      * problems described in {IERC20-approve}.
222      *
223      * Emits an {Approval} event indicating the updated allowance.
224      *
225      * Requirements:
226      *
227      * - `spender` cannot be the zero address.
228      * - `spender` must have allowance for the caller of at least
229      * `subtractedValue`.
230      */
231     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
232         uint256 currentAllowance = _allowances[_msgSender()][spender];
233         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
234         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
235 
236         return true;
237     }
238 
239     /**
240      * @dev Moves tokens `amount` from `sender` to `recipient`.
241      *
242      * This is internal function is equivalent to {transfer}, and can be used to
243      * e.g. implement automatic token fees, slashing mechanisms, etc.
244      *
245      * Emits a {Transfer} event.
246      *
247      * Requirements:
248      *
249      * - `sender` cannot be the zero address.
250      * - `recipient` cannot be the zero address.
251      * - `sender` must have a balance of at least `amount`.
252      */
253     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
254         require(sender != address(0), "ERC20: transfer from the zero address");
255         require(recipient != address(0), "ERC20: transfer to the zero address");
256 
257         _beforeTokenTransfer(sender, recipient, amount);
258 
259         uint256 senderBalance = _balances[sender];
260         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
261         _balances[sender] = senderBalance - amount;
262         _balances[recipient] += amount;
263 
264         emit Transfer(sender, recipient, amount);
265     }
266 
267     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
268      * the total supply.
269      *
270      * Emits a {Transfer} event with `from` set to the zero address.
271      *
272      * Requirements:
273      *
274      * - `to` cannot be the zero address.
275      */
276     function _mint(address account, uint256 amount) internal virtual {
277         require(account != address(0), "ERC20: mint to the zero address");
278 
279         _beforeTokenTransfer(address(0), account, amount);
280 
281         _totalSupply += amount;
282         _balances[account] += amount;
283         emit Transfer(address(0), account, amount);
284     }
285 
286     /**
287      * @dev Destroys `amount` tokens from `account`, reducing the
288      * total supply.
289      *
290      * Emits a {Transfer} event with `to` set to the zero address.
291      *
292      * Requirements:
293      *
294      * - `account` cannot be the zero address.
295      * - `account` must have at least `amount` tokens.
296      */
297     function _burn(address account, uint256 amount) internal virtual {
298         require(account != address(0), "ERC20: burn from the zero address");
299 
300         _beforeTokenTransfer(account, address(0), amount);
301 
302         uint256 accountBalance = _balances[account];
303         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
304         _balances[account] = accountBalance - amount;
305         _totalSupply -= amount;
306 
307         emit Transfer(account, address(0), amount);
308     }
309 
310     /**
311      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
312      *
313      * This internal function is equivalent to `approve`, and can be used to
314      * e.g. set automatic allowances for certain subsystems, etc.
315      *
316      * Emits an {Approval} event.
317      *
318      * Requirements:
319      *
320      * - `owner` cannot be the zero address.
321      * - `spender` cannot be the zero address.
322      */
323     function _approve(address owner, address spender, uint256 amount) internal virtual {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326 
327         _allowances[owner][spender] = amount;
328         emit Approval(owner, spender, amount);
329     }
330 
331     /**
332      * @dev Hook that is called before any transfer of tokens. This includes
333      * minting and burning.
334      *
335      * Calling conditions:
336      *
337      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
338      * will be to transferred to `to`.
339      * - when `from` is zero, `amount` tokens will be minted for `to`.
340      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
341      * - `from` and `to` are never both zero.
342      *
343      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
344      */
345     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
346 }
347 
348 library Address{
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351 
352         (bool success, ) = recipient.call{value: amount}("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 }
356 
357 abstract contract Ownable is Context {
358     address private _owner;
359 
360     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
361 
362     constructor() {
363         _setOwner(_msgSender());
364     }
365 
366     function owner() public view virtual returns (address) {
367         return _owner;
368     }
369 
370     modifier onlyOwner() {
371         require(owner() == _msgSender(), "Ownable: caller is not the owner");
372         _;
373     }
374 
375     function renounceOwnership() public virtual onlyOwner {
376         _setOwner(address(0));
377     }
378 
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         _setOwner(newOwner);
382     }
383 
384     function _setOwner(address newOwner) private {
385         address oldOwner = _owner;
386         _owner = newOwner;
387         emit OwnershipTransferred(oldOwner, newOwner);
388     }
389 }
390 
391 interface IFactory{
392         function createPair(address tokenA, address tokenB) external returns (address pair);
393 }
394 
395 interface IRouter {
396     function factory() external pure returns (address);
397     function WETH() external pure returns (address);
398     function addLiquidityETH(
399         address token,
400         uint amountTokenDesired,
401         uint amountTokenMin,
402         uint amountETHMin,
403         address to,
404         uint deadline
405     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
406 
407     function swapExactTokensForETHSupportingFeeOnTransferTokens(
408         uint amountIn,
409         uint amountOutMin,
410         address[] calldata path,
411         address to,
412         uint deadline) external;
413 }
414 
415 contract PulseShiba is ERC20, Ownable{
416     using Address for address payable;
417     
418     IRouter public router;
419     address public pair;
420     
421     bool private swapping;
422     bool public swapEnabled;
423     bool public tradingEnabled;
424 
425     uint256 public genesis_block;
426     uint256 public deadblocks = 0;
427     
428     uint256 public swapThreshold = 10_000 * 10e18;
429     uint256 public maxTxAmount = 10_000_000 * 10**18;
430     uint256 public maxWalletAmount = 200_000 * 10**18;
431     
432     address public marketingWallet = 0xB4621d56B03C3f63470ae5cD7114C155a972dd7A;
433     address public devWallet = 0xB4621d56B03C3f63470ae5cD7114C155a972dd7A;
434     
435     struct Taxes {
436         uint256 marketing;
437         uint256 liquidity; 
438         uint256 dev;
439     }
440     
441     Taxes public taxes = Taxes(3,0,0);
442     Taxes public sellTaxes = Taxes(99,0,0);
443     uint256 public totTax = 3;
444     uint256 public totSellTax = 99;
445     
446     mapping (address => bool) public excludedFromFees;
447     mapping (address => bool) public isBot;
448     
449     modifier inSwap() {
450         if (!swapping) {
451             swapping = true;
452             _;
453             swapping = false;
454         }
455     }
456         
457     constructor() ERC20("PulseShiba", "PLSS") {
458         _mint(msg.sender, 1e7 * 10 ** decimals());
459         excludedFromFees[msg.sender] = true;
460 
461         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
462         address _pair = IFactory(_router.factory())
463             .createPair(address(this), _router.WETH());
464 
465         router = _router;
466         pair = _pair;
467         excludedFromFees[address(this)] = true;
468         excludedFromFees[marketingWallet] = true;
469         excludedFromFees[devWallet] = true;
470     }
471     
472     function _transfer(address sender, address recipient, uint256 amount) internal override {
473         require(amount > 0, "Transfer amount must be greater than zero");
474         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
475                 
476         
477         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
478             require(tradingEnabled, "Trading not active yet");
479             if(genesis_block + deadblocks > block.number){
480                 if(recipient != pair) isBot[recipient] = true;
481                 if(sender != pair) isBot[sender] = true;
482             }
483             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
484             if(recipient != pair){
485                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
486             }
487         }
488 
489         uint256 fee;
490         
491         //set fee to zero if fees in contract are handled or exempted
492         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
493         
494         //calculate fee
495         else{
496             if(recipient == pair) fee = amount * totSellTax / 100;
497             else fee = amount * totTax / 100;
498         }
499         
500         //send fees if threshold has been reached
501         //don't do this on buys, breaks swap
502         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
503 
504         super._transfer(sender, recipient, amount - fee);
505         if(fee > 0) super._transfer(sender, address(this) ,fee);
506 
507     }
508 
509     function swapForFees() private inSwap {
510         uint256 contractBalance = balanceOf(address(this));
511         if (contractBalance >= swapThreshold) {
512 
513             // Split the contract balance into halves
514             uint256 denominator = totSellTax * 2;
515             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
516             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
517     
518             uint256 initialBalance = address(this).balance;
519     
520             swapTokensForETH(toSwap);
521     
522             uint256 deltaBalance = address(this).balance - initialBalance;
523             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
524             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
525     
526             if(ethToAddLiquidityWith > 0){
527                 // Add liquidity to Uniswap
528                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
529             }
530     
531             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
532             if(marketingAmt > 0){
533                 payable(marketingWallet).sendValue(marketingAmt);
534             }
535             
536             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
537             if(devAmt > 0){
538                 payable(devWallet).sendValue(devAmt);
539             }
540         }
541     }
542 
543 
544     function swapTokensForETH(uint256 tokenAmount) private {
545         address[] memory path = new address[](2);
546         path[0] = address(this);
547         path[1] = router.WETH();
548 
549         _approve(address(this), address(router), tokenAmount);
550 
551         // make the swap
552         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
553 
554     }
555 
556     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
557         // approve token transfer to cover all possible scenarios
558         _approve(address(this), address(router), tokenAmount);
559 
560         // add the liquidity
561         router.addLiquidityETH{value: bnbAmount}(
562             address(this),
563             tokenAmount,
564             0, // slippage is unavoidable
565             0, // slippage is unavoidable
566             devWallet,
567             block.timestamp
568         );
569     }
570 
571     function setSwapEnabled(bool state) external onlyOwner {
572         swapEnabled = state;
573     }
574 
575     function setSwapThreshold(uint256 new_amount) external onlyOwner {
576         swapThreshold = new_amount;
577     }
578 
579     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
580         require(!tradingEnabled, "Trading already active");
581         tradingEnabled = true;
582         swapEnabled = true;
583         genesis_block = block.number;
584         deadblocks = numOfDeadBlocks;
585     }
586 
587     function setTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
588         taxes = Taxes(_marketing, _liquidity, _dev);
589         totTax = _marketing + _liquidity + _dev;
590     }
591 
592     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
593         sellTaxes = Taxes(_marketing, _liquidity, _dev);
594         totSellTax = _marketing + _liquidity + _dev;
595     }
596     
597     function updateMarketingWallet(address newWallet) external onlyOwner{
598         marketingWallet = newWallet;
599     }
600     
601     function updateDevWallet(address newWallet) external onlyOwner{
602         devWallet = newWallet;
603     }
604 
605     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
606         router = _router;
607         pair = _pair;
608     }
609     
610     function setIsBot(address account, bool state) external onlyOwner{
611         isBot[account] = state;
612     }
613 
614     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
615         excludedFromFees[_address] = state;
616     }
617     
618     function updateMaxTxAmount(uint256 amount) external onlyOwner{
619         maxTxAmount = amount * 10**18;
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