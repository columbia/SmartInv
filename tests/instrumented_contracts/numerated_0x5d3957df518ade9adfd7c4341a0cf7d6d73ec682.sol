1 /*
2     This is the contract for relaunch and migration of MFX token with CA: "0x6266a18F1605DA94e8317232ffa634C74646ac40" rebranded as "R33LZ".
3     Author: @Arrnaya
4     Website: www.r33lz.com
5 */
6 
7 //SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.17;
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
61 contract ERC20 is Context, IERC20, IERC20Metadata {
62     mapping(address => uint256) internal _balances;
63 
64     mapping(address => mapping(address => uint256)) internal _allowances;
65 
66     uint256 private _totalSupply;
67 
68     string private _name;
69     string private _symbol;
70 
71     /**
72      * @dev Sets the values for {name} and {symbol}.
73      *
74      * The defaut value of {decimals} is 18. To select a different value for
75      * {decimals} you should overload it.
76      *
77      * All two of these values are immutable: they can only be set once during
78      * construction.
79      */
80     constructor(string memory name_, string memory symbol_) {
81         _name = name_;
82         _symbol = symbol_;
83     }
84 
85     /**
86      * @dev Returns the name of the token.
87      */
88     function name() public view virtual override returns (string memory) {
89         return _name;
90     }
91 
92     /**
93      * @dev Returns the symbol of the token, usually a shorter version of the
94      * name.
95      */
96     function symbol() public view virtual override returns (string memory) {
97         return _symbol;
98     }
99 
100     /**
101      * @dev Returns the number of decimals used to get its user representation.
102      * For example, if `decimals` equals `2`, a balance of `505` tokens should
103      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
104      *
105      * Tokens usually opt for a value of 18, imitating the relationship between
106      * Ether and Wei. This is the value {ERC20} uses, unless this function is
107      * overridden;
108      *
109      * NOTE: This information is only used for _display_ purposes: it in
110      * no way affects any of the arithmetic of the contract, including
111      * {IERC20-balanceOf} and {IERC20-transfer}.
112      */
113     function decimals() public view virtual override returns (uint8) {
114         return 18;
115     }
116 
117     /**
118      * @dev See {IERC20-totalSupply}.
119      */
120     function totalSupply() public view virtual override returns (uint256) {
121         return _totalSupply;
122     }
123 
124     /**
125      * @dev See {IERC20-balanceOf}.
126      */
127     function balanceOf(address account) public view virtual override returns (uint256) {
128         return _balances[account];
129     }
130 
131     /**
132      * @dev See {IERC20-transfer}.
133      *
134      * Requirements:
135      *
136      * - `recipient` cannot be the zero address.
137      * - the caller must have a balance of at least `amount`.
138      */
139     function transfer(address recipient, uint256 amount)
140         public
141         virtual
142         override
143         returns (bool)
144     {
145         _transfer(_msgSender(), recipient, amount);
146         return true;
147     }
148 
149     /**
150      * @dev See {IERC20-allowance}.
151      */
152     function allowance(address owner, address spender)
153         public
154         view
155         virtual
156         override
157         returns (uint256)
158     {
159         return _allowances[owner][spender];
160     }
161 
162     /**
163      * @dev See {IERC20-approve}.
164      *
165      * Requirements:
166      *
167      * - `spender` cannot be the zero address.
168      */
169     function approve(address spender, uint256 amount) public virtual override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173 
174     /**
175      * @dev See {IERC20-transferFrom}.
176      *
177      * Emits an {Approval} event indicating the updated allowance. This is not
178      * required by the EIP. See the note at the beginning of {ERC20}.
179      *
180      * Requirements:
181      *
182      * - `sender` and `recipient` cannot be the zero address.
183      * - `sender` must have a balance of at least `amount`.
184      * - the caller must have allowance for ``sender``'s tokens of at least
185      * `amount`.
186      */
187     function transferFrom(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) public virtual override returns (bool) {
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
213     function increaseAllowance(address spender, uint256 addedValue)
214         public
215         virtual
216         returns (bool)
217     {
218         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
219         return true;
220     }
221 
222     /**
223      * @dev Atomically decreases the allowance granted to `spender` by the caller.
224      *
225      * This is an alternative to {approve} that can be used as a mitigation for
226      * problems described in {IERC20-approve}.
227      *
228      * Emits an {Approval} event indicating the updated allowance.
229      *
230      * Requirements:
231      *
232      * - `spender` cannot be the zero address.
233      * - `spender` must have allowance for the caller of at least
234      * `subtractedValue`.
235      */
236     function decreaseAllowance(address spender, uint256 subtractedValue)
237         public
238         virtual
239         returns (bool)
240     {
241         uint256 currentAllowance = _allowances[_msgSender()][spender];
242         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
243         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
244 
245         return true;
246     }
247 
248     /**
249      * @dev Moves tokens `amount` from `sender` to `recipient`.
250      *
251      * This is internal function is equivalent to {transfer}, and can be used to
252      * e.g. implement automatic token fees, slashing mechanisms, etc.
253      *
254      * Emits a {Transfer} event.
255      *
256      * Requirements:
257      *
258      * - `sender` cannot be the zero address.
259      * - `recipient` cannot be the zero address.
260      * - `sender` must have a balance of at least `amount`.
261      */
262     function _transfer(
263         address sender,
264         address recipient,
265         uint256 amount
266     ) internal virtual {
267         require(sender != address(0), "ERC20: transfer from the zero address");
268         require(recipient != address(0), "ERC20: transfer to the zero address");
269 
270         uint256 senderBalance = _balances[sender];
271         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
272         _balances[sender] = senderBalance - amount;
273         _balances[recipient] += amount;
274 
275         emit Transfer(sender, recipient, amount);
276     }
277 
278     /** This function will be used to generate the total supply
279     * while deploying the contract
280     *
281     * This function can never be called again after deploying contract
282     */
283     function _tokengeneration(address account, uint256 amount) internal virtual {
284         _totalSupply = amount;
285         _balances[account] = amount;
286         emit Transfer(address(0), account, amount);
287     }
288 
289     /**
290      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
291      *
292      * This internal function is equivalent to `approve`, and can be used to
293      * e.g. set automatic allowances for certain subsystems, etc.
294      *
295      * Emits an {Approval} event.
296      *
297      * Requirements:
298      *
299      * - `owner` cannot be the zero address.
300      * - `spender` cannot be the zero address.
301      */
302     function _approve(
303         address owner,
304         address spender,
305         uint256 amount
306     ) internal virtual {
307         require(owner != address(0), "ERC20: approve from the zero address");
308         require(spender != address(0), "ERC20: approve to the zero address");
309 
310         _allowances[owner][spender] = amount;
311         emit Approval(owner, spender, amount);
312     }
313 }
314 
315 library Address {
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         (bool success, ) = recipient.call{ value: amount }("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 }
323 
324 abstract contract Ownable is Context {
325     address private _owner;
326 
327     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
328 
329     constructor() {
330         _setOwner(_msgSender());
331     }
332 
333     function owner() public view virtual returns (address) {
334         return _owner;
335     }
336 
337     modifier onlyOwner() {
338         require(owner() == _msgSender(), "Ownable: caller is not the owner");
339         _;
340     }
341 
342     function renounceOwnership() public virtual onlyOwner {
343         _setOwner(address(0));
344     }
345 
346     function transferOwnership(address newOwner) public virtual onlyOwner {
347         require(newOwner != address(0), "Ownable: new owner is the zero address");
348         _setOwner(newOwner);
349     }
350 
351     function _setOwner(address newOwner) private {
352         address oldOwner = _owner;
353         _owner = newOwner;
354         emit OwnershipTransferred(oldOwner, newOwner);
355     }
356 }
357 
358 interface IFactory {
359     function createPair(address tokenA, address tokenB) external returns (address pair);
360 }
361 
362 interface IRouter {
363     function factory() external pure returns (address);
364 
365     function WETH() external pure returns (address);
366 
367     function addLiquidityETH(
368         address token,
369         uint256 amountTokenDesired,
370         uint256 amountTokenMin,
371         uint256 amountETHMin,
372         address to,
373         uint256 deadline
374     )
375         external
376         payable
377         returns (
378             uint256 amountToken,
379             uint256 amountETH,
380             uint256 liquidity
381         );
382 
383     function swapExactTokensForETHSupportingFeeOnTransferTokens(
384         uint256 amountIn,
385         uint256 amountOutMin,
386         address[] calldata path,
387         address to,
388         uint256 deadline
389     ) external;
390 }
391 
392 contract R33lz is ERC20, Ownable {
393     using Address for address payable;
394 
395     IRouter public router;
396     address public pair;
397 
398     bool private _interlock = false;
399     bool public providingLiquidity = false;
400     bool public tradingEnabled = false;
401 
402     uint256 public tokenLiquidityThreshold = 1_000_000 * 10**decimals();
403     uint256 public maxBuyLimit = 10_000_000 * 10**decimals();
404     uint256 public maxSellLimit = 10_000_000 * 10**decimals();
405     uint256 public maxWalletLimit = 20_000_000 * 10**decimals();
406 
407     uint256 public launchedAtBlock;
408 
409     address public marketingWallet = 0xdd5f69f0d464909434856efDB64eE1f539E14E2b;
410     address public devWallet = 0xFFaD3d0d3c39b3C056dDEB105d3c8bB7c26DD699;
411 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
412 
413     struct Taxes {
414         uint256 marketing;
415         uint256 liquidity;
416         uint256 developer;
417     }
418 
419     Taxes public taxes = Taxes(3, 1, 0);
420     Taxes public sellTaxes = Taxes(6, 2, 0);
421     Taxes public transferTaxes = Taxes(0, 0, 0);
422 
423     mapping(address => bool) public exemptFee;
424     mapping(address => bool) public nonCustodial;
425 
426     modifier lockTheSwap() {
427         if (!_interlock) {
428             _interlock = true;
429             _;
430             _interlock = false;
431         }
432     }
433 
434     constructor() ERC20("R33LZ", "R33LZ") {
435         _tokengeneration(msg.sender, 1_000_000_000 * 10**decimals());
436         exemptFee[msg.sender] = true;
437 
438         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UNISWAP V2
439         // IRouter _router = IRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E); // PCS V2
440         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
441 
442         router = _router;
443         pair = _pair;
444         exemptFee[address(this)] = true;
445         exemptFee[marketingWallet] = true;
446         exemptFee[devWallet] = true;
447         exemptFee[deadWallet] = true;
448 
449     }
450 
451     function approve(address spender, uint256 amount) public override returns (bool) {
452         _approve(_msgSender(), spender, amount);
453         return true;
454     }
455 
456     function transferFrom(
457         address sender,
458         address recipient,
459         uint256 amount
460     ) public override returns (bool) {
461         _transfer(sender, recipient, amount);
462 
463         uint256 currentAllowance = _allowances[sender][_msgSender()];
464         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
465         _approve(sender, _msgSender(), currentAllowance - amount);
466 
467         return true;
468     }
469 
470     function increaseAllowance(address spender, uint256 addedValue)
471         public
472         override
473         returns (bool)
474     {
475         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
476         return true;
477     }
478 
479     function decreaseAllowance(address spender, uint256 subtractedValue)
480         public
481         override
482         returns (bool)
483     {
484         uint256 currentAllowance = _allowances[_msgSender()][spender];
485         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
486         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
487 
488         return true;
489     }
490 
491     function transfer(address recipient, uint256 amount) public override returns (bool) {
492         _transfer(msg.sender, recipient, amount);
493         return true;
494     }
495 
496     function _transfer(
497         address sender,
498         address recipient,
499         uint256 amount
500     ) internal override {
501         require(amount > 0, "Transfer amount must be greater than zero");
502         require(!nonCustodial[sender], "Prohibited!");
503 
504         if(block.number < launchedAtBlock + 1 && sender == pair) {
505             nonCustodial[recipient] = true;
506         }
507 
508         if (!exemptFee[sender] && !exemptFee[recipient]) {
509             require(tradingEnabled, "Trading not enabled");
510         }
511 
512         if (sender == pair && !exemptFee[recipient] && !_interlock) {
513             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
514             require(
515                 balanceOf(recipient) + amount <= maxWalletLimit,
516                 "You are exceeding maxWalletLimit"
517             );
518         }
519 
520         if (
521             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_interlock
522         ) {
523             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
524             if (recipient != pair) {
525                 require(
526                     balanceOf(recipient) + amount <= maxWalletLimit,
527                     "You are exceeding maxWalletLimit"
528                 );
529             }
530         }
531 
532         uint256 feeswap;
533         uint256 feesum;
534         uint256 fee;
535         Taxes memory currentTaxes;
536 
537         //set fee to zero if fees in contract are handled or exempted
538         if (_interlock || exemptFee[sender] || exemptFee[recipient])
539             fee = 0;
540 
541             //calculate fee
542         else if (recipient == pair) {
543             feeswap =
544                 sellTaxes.liquidity +
545                 sellTaxes.marketing +
546                 sellTaxes.developer;
547             feesum = feeswap;
548             currentTaxes = sellTaxes;
549         } else if (sender == pair) {
550             feeswap =
551                 taxes.liquidity +
552                 taxes.marketing +
553                 taxes.developer ;
554             feesum = feeswap;
555             currentTaxes = taxes;
556         } else {
557             feeswap =
558                 transferTaxes.liquidity +
559                 transferTaxes.marketing +
560                 transferTaxes.developer ;
561             feesum = feeswap;
562             currentTaxes = transferTaxes;
563         }
564 
565         fee = (amount * feesum) / 100;
566 
567         //send fees if threshold has been reached
568         //don't do this on buys, breaks swap
569         if (providingLiquidity && sender != pair) Liquify(feeswap, currentTaxes);
570 
571         //rest to recipient
572         super._transfer(sender, recipient, amount - fee);
573         if (fee > 0) {
574             //send the fee to the contract
575             if (feeswap > 0) {
576                 uint256 feeAmount = (amount * feeswap) / 100;
577                 super._transfer(sender, address(this), feeAmount);
578             }
579 
580         }
581     }
582 
583     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
584 
585         if(feeswap == 0){
586             return;
587         }
588 
589         uint256 contractBalance = balanceOf(address(this));
590         if (contractBalance >= tokenLiquidityThreshold) {
591             if (tokenLiquidityThreshold > 1) {
592                 contractBalance = tokenLiquidityThreshold;
593             }
594 
595             // Split the contract balance into halves
596             uint256 denominator = feeswap * 2;
597             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
598                 denominator;
599             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
600 
601             uint256 initialBalance = address(this).balance;
602 
603             swapTokensForETH(toSwap);
604 
605             uint256 deltaBalance = address(this).balance - initialBalance;
606             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
607             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
608 
609             if (ethToAddLiquidityWith > 0) {
610                 // Add liquidity to pancake
611                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
612             }
613 
614             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
615             uint256 developerAmt = unitBalance * 2 * swapTaxes.developer;
616             if (marketingAmt > 0) {
617                 payable(marketingWallet).sendValue(marketingAmt);
618             }
619             if (developerAmt > 0) {
620                 payable(devWallet).sendValue(developerAmt);
621             }
622 
623         }
624     }
625 
626     function swapTokensForETH(uint256 tokenAmount) private {
627         // generate the pancake pair path of token -> weth
628         address[] memory path = new address[](2);
629         path[0] = address(this);
630         path[1] = router.WETH();
631 
632         _approve(address(this), address(router), tokenAmount);
633 
634         // make the swap
635         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
636             tokenAmount,
637             0,
638             path,
639             address(this),
640             block.timestamp
641         );
642     }
643 
644     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
645         // approve token transfer to cover all possible scenarios
646         _approve(address(this), address(router), tokenAmount);
647 
648         // add the liquidity
649         router.addLiquidityETH{ value: ethAmount }(
650             address(this),
651             tokenAmount,
652             0, // slippage is unavoidable
653             0, // slippage is unavoidable
654             deadWallet,
655             block.timestamp
656         );
657     }
658 
659     function updateLiquidityProvide(bool state) external onlyOwner {
660         //update liquidity providing state
661         providingLiquidity = state;
662     }
663 
664     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
665         //update the treshhold
666         require(new_amount <= 10_000_000 && new_amount > 0, "Swap threshold amount should be lower or euqal to 1% of tokens");
667         tokenLiquidityThreshold = new_amount * 10**decimals();
668     }
669 
670     function SetBuyTaxes(
671         uint256 _marketing,
672         uint256 _liquidity,
673         uint256 _developer
674     ) external onlyOwner {
675         taxes = Taxes(_marketing, _liquidity,  _developer);
676         require((_marketing + _liquidity +  _developer) <= 15, "Must keep fees at 15% or less");
677     }
678 
679     function SetSellTaxes(
680         uint256 _marketing,
681         uint256 _liquidity,
682         uint256 _developer
683     ) external onlyOwner {
684         sellTaxes = Taxes(_marketing, _liquidity,  _developer);
685         require((_marketing + _liquidity + _developer) <= 15, "Must keep fees at 15% or less");
686     }
687 
688     function SetTransferTaxes(
689         uint256 _marketing,
690         uint256 _liquidity,
691         uint256 _developer
692     ) external onlyOwner {
693         transferTaxes = Taxes(_marketing, _liquidity,  _developer);
694         require((_marketing + _liquidity + _developer) <= 15, "Must keep fees at 15% or less");
695     }
696 
697     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
698         router = IRouter(newRouter);
699         pair = newPair;
700     }
701 
702     function _openTrading() external onlyOwner {
703         require(!tradingEnabled, "Cannot re-enable trading");
704         tradingEnabled = true;
705         providingLiquidity = true;
706         launchedAtBlock = block.number;
707     }
708 
709     function updateWallets(address _marketingWallet, address _devWallet) external onlyOwner {
710         require(_marketingWallet != address(0),"Fee Address cannot be zero address");
711         require(_devWallet != address(0),"Fee Address cannot be zero address");
712         marketingWallet = _marketingWallet;
713         devWallet = _devWallet;
714     }
715 
716     function updateExemptFee(address _address, bool state) external onlyOwner {
717         exemptFee[_address] = state;
718     }
719 
720     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
721         for (uint256 i = 0; i < accounts.length; i++) {
722             exemptFee[accounts[i]] = state;
723         }
724     }
725 
726     function removeNonCustodialWallets(address[] memory _account) external onlyOwner {
727         for (uint256 i = 0; i < _account.length; i++) {
728             nonCustodial[_account[i]] = false;
729         }
730     }
731 
732     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell, uint256 maxWallet) external onlyOwner {
733         require(maxBuy >= 1_000_000, "Cannot set max buy amount lower than 0.1%");
734         require(maxSell >= 1_000_000, "Cannot set max sell amount lower than 0.1%");
735         require(maxWallet >= 5_000_000, "Cannot set max wallet amount lower than 0.5%");
736         maxBuyLimit = maxBuy * 10**decimals();
737         maxSellLimit = maxSell * 10**decimals();
738         maxWalletLimit = maxWallet * 10**decimals(); 
739     }
740 
741     function rescueETH(uint256 weiAmount) external onlyOwner {
742         payable(owner()).transfer(weiAmount);
743     }
744 
745     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
746         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
747         IERC20(tokenAdd).transfer(owner(), amount);
748     }
749 
750     // fallbacks
751     receive() external payable {}
752 }