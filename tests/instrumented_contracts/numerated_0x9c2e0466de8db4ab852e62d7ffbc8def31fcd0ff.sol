1 //SPDX-License-Identifier: MIT
2 
3 /*
4 
5 Welcome to The Elite: New Era, an organization of people whose main goal is to disrupt the cryptocurrency scene, one coin at a time. 
6 We are influential, authority figures, innovators and above all else, leaders.
7 
8 Website: www.theelitenwo.com
9 Twitter: www.twitter.com/theelitenwo
10 Medium: www.medium/@theelitenwo
11 Telegram: https://t.me/theelitenwo
12 
13 */
14 
15 pragma solidity 0.8.12;
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
408 contract TheEliteNewEra is ERC20, Ownable{
409     using Address for address payable;
410     
411     IRouter public router;
412     address public pair;
413     
414     bool private swapping;
415     bool public swapEnabled;
416     bool public tradingEnabled;
417 
418     uint256 public genesis_block;
419     uint256 public deadblocks = 0;
420     
421     uint256 public swapThreshold = 50_000 * 10e18;
422     uint256 public maxTxAmount = 60_000 * 10**18;
423     uint256 public maxWalletAmount = 60_000 * 10**18;
424     
425     address public marketingWallet = 0x900cda50CEbEFaC173Afa1b2Ae84344Af5be65c5;
426     address public devWallet = 0xC1f0389Ee21F6d899f1f7f5B5ef995F40098B62a;
427     
428     struct Taxes {
429         uint256 marketing;
430         uint256 liquidity; 
431         uint256 dev;
432     }
433     
434     Taxes public taxes = Taxes(7,2,3);
435     Taxes public sellTaxes = Taxes(7,2,3);
436     uint256 public totTax = 12;
437     uint256 public totSellTax = 12;
438     
439     mapping (address => bool) public excludedFromFees;
440     mapping (address => bool) public isBot;
441     
442     modifier inSwap() {
443         if (!swapping) {
444             swapping = true;
445             _;
446             swapping = false;
447         }
448     }
449         
450     constructor() ERC20("The Elite: New Era", "NWO") {
451         _mint(msg.sender, 1e7 * 10 ** decimals());
452         excludedFromFees[msg.sender] = true;
453 
454         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
455         address _pair = IFactory(_router.factory())
456             .createPair(address(this), _router.WETH());
457 
458         router = _router;
459         pair = _pair;
460         excludedFromFees[address(this)] = true;
461         excludedFromFees[marketingWallet] = true;
462         excludedFromFees[devWallet] = true;
463     }
464     
465     function _transfer(address sender, address recipient, uint256 amount) internal override {
466         require(amount > 0, "Transfer amount must be greater than zero");
467         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
468                 
469         
470         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
471             require(tradingEnabled, "Trading not active yet");
472             if(genesis_block + deadblocks > block.number){
473                 if(recipient != pair) isBot[recipient] = true;
474                 if(sender != pair) isBot[sender] = true;
475             }
476             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
477             if(recipient != pair){
478                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
479             }
480         }
481 
482         uint256 fee;
483         
484         //set fee to zero if fees in contract are handled or exempted
485         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
486         
487         //calculate fee
488         else{
489             if(recipient == pair) fee = amount * totSellTax / 100;
490             else fee = amount * totTax / 100;
491         }
492         
493         //send fees if threshold has been reached
494         //don't do this on buys, breaks swap
495         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
496 
497         super._transfer(sender, recipient, amount - fee);
498         if(fee > 0) super._transfer(sender, address(this) ,fee);
499 
500     }
501 
502     function swapForFees() private inSwap {
503         uint256 contractBalance = balanceOf(address(this));
504         if (contractBalance >= swapThreshold) {
505 
506             // Split the contract balance into halves
507             uint256 denominator = totSellTax * 2;
508             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
509             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
510     
511             uint256 initialBalance = address(this).balance;
512     
513             swapTokensForETH(toSwap);
514     
515             uint256 deltaBalance = address(this).balance - initialBalance;
516             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
517             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
518     
519             if(ethToAddLiquidityWith > 0){
520                 // Add liquidity to Uniswap
521                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
522             }
523     
524             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
525             if(marketingAmt > 0){
526                 payable(marketingWallet).sendValue(marketingAmt);
527             }
528             
529             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
530             if(devAmt > 0){
531                 payable(devWallet).sendValue(devAmt);
532             }
533         }
534     }
535 
536 
537     function swapTokensForETH(uint256 tokenAmount) private {
538         address[] memory path = new address[](2);
539         path[0] = address(this);
540         path[1] = router.WETH();
541 
542         _approve(address(this), address(router), tokenAmount);
543 
544         // make the swap
545         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
546 
547     }
548 
549     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
550         // approve token transfer to cover all possible scenarios
551         _approve(address(this), address(router), tokenAmount);
552 
553         // add the liquidity
554         router.addLiquidityETH{value: bnbAmount}(
555             address(this),
556             tokenAmount,
557             0, // slippage is unavoidable
558             0, // slippage is unavoidable
559             devWallet,
560             block.timestamp
561         );
562     }
563 
564     function setSwapEnabled(bool state) external onlyOwner {
565         swapEnabled = state;
566     }
567 
568     function setSwapThreshold(uint256 new_amount) external onlyOwner {
569         swapThreshold = new_amount;
570     }
571 
572     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
573         require(!tradingEnabled, "Trading already active");
574         tradingEnabled = true;
575         swapEnabled = true;
576         genesis_block = block.number;
577         deadblocks = numOfDeadBlocks;
578     }
579 
580     function setTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
581         require(_marketing + _liquidity + _dev <= 25, "Max fee is 25%");
582         taxes = Taxes(_marketing, _liquidity, _dev);
583         totTax = _marketing + _liquidity + _dev;
584     }
585 
586     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
587         require(_marketing + _liquidity + _dev <= 25, "Max fee is 25%");
588         sellTaxes = Taxes(_marketing, _liquidity, _dev);
589         totSellTax = _marketing + _liquidity + _dev;
590     }
591     
592     function updateMarketingWallet(address newWallet) external onlyOwner{
593         marketingWallet = newWallet;
594     }
595     
596     function updateDevWallet(address newWallet) external onlyOwner{
597         devWallet = newWallet;
598     }
599 
600     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
601         router = _router;
602         pair = _pair;
603     }
604     
605     function setIsBot(address account, bool state) external onlyOwner{
606         isBot[account] = state;
607     }
608 
609     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
610         excludedFromFees[_address] = state;
611     }
612     
613     function updateMaxTxAmount(uint256 amount) external onlyOwner{
614         maxTxAmount = amount * 10**18;
615     }
616     
617     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
618         maxWalletAmount = amount * 10**18;
619     }
620 
621     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
622         IERC20(tokenAddress).transfer(owner(), amount);
623     }
624 
625     function rescueETH(uint256 weiAmount) external onlyOwner{
626         payable(owner()).sendValue(weiAmount);
627     }
628 
629     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
630         uint256 initBalance = address(this).balance;
631         swapTokensForETH(amount);
632         uint256 newBalance = address(this).balance - initBalance;
633         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
634         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
635     }
636 
637     // fallbacks
638     receive() external payable {}
639     
640 }