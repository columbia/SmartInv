1 //SPDX-License-Identifier: MIT 
2 
3 //https://t.me/bunny_ai https://bunnyai.app
4 
5 pragma solidity ^0.8.17;
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
57 contract ERC20 is Context, IERC20, IERC20Metadata {
58     mapping(address => uint256) internal _balances;
59 
60     mapping(address => mapping(address => uint256)) internal _allowances;
61 
62     uint256 private _totalSupply;
63 
64     string private _name;
65     string private _symbol;
66 
67     /**
68      * @dev Sets the values for {name} and {symbol}.
69      *
70      * The defaut value of {decimals} is 18. To select a different value for
71      * {decimals} you should overload it.
72      *
73      * All two of these values are immutable: they can only be set once during
74      * construction.
75      */
76     constructor(string memory name_, string memory symbol_) {
77         _name = name_;
78         _symbol = symbol_;
79     }
80 
81     /**
82      * @dev Returns the name of the token.
83      */
84     function name() public view virtual override returns (string memory) {
85         return _name;
86     }
87 
88     /**
89      * @dev Returns the symbol of the token, usually a shorter version of the
90      * name.
91      */
92     function symbol() public view virtual override returns (string memory) {
93         return _symbol;
94     }
95 
96     /**
97      * @dev Returns the number of decimals used to get its user representation.
98      * For example, if `decimals` equals `2`, a balance of `505` tokens should
99      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
100      *
101      * Tokens usually opt for a value of 18, imitating the relationship between
102      * Ether and Wei. This is the value {ERC20} uses, unless this function is
103      * overridden;
104      *
105      * NOTE: This information is only used for _display_ purposes: it in
106      * no way affects any of the arithmetic of the contract, including
107      * {IERC20-balanceOf} and {IERC20-transfer}.
108      */
109     function decimals() public view virtual override returns (uint8) {
110         return 18;
111     }
112 
113     /**
114      * @dev See {IERC20-totalSupply}.
115      */
116     function totalSupply() public view virtual override returns (uint256) {
117         return _totalSupply;
118     }
119 
120     /**
121      * @dev See {IERC20-balanceOf}.
122      */
123     function balanceOf(address account) public view virtual override returns (uint256) {
124         return _balances[account];
125     }
126 
127     /**
128      * @dev See {IERC20-transfer}.
129      *
130      * Requirements:
131      *
132      * - `recipient` cannot be the zero address.
133      * - the caller must have a balance of at least `amount`.
134      */
135     function transfer(address recipient, uint256 amount)
136         public
137         virtual
138         override
139         returns (bool)
140     {
141         _transfer(_msgSender(), recipient, amount);
142         return true;
143     }
144 
145     /**
146      * @dev See {IERC20-allowance}.
147      */
148     function allowance(address owner, address spender)
149         public
150         view
151         virtual
152         override
153         returns (uint256)
154     {
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
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) public virtual override returns (bool) {
188         _transfer(sender, recipient, amount);
189 
190         uint256 currentAllowance = _allowances[sender][_msgSender()];
191         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
192         _approve(sender, _msgSender(), currentAllowance - amount);
193 
194         return true;
195     }
196 
197     /**
198      * @dev Atomically increases the allowance granted to `spender` by the caller.
199      *
200      * This is an alternative to {approve} that can be used as a mitigation for
201      * problems described in {IERC20-approve}.
202      *
203      * Emits an {Approval} event indicating the updated allowance.
204      *
205      * Requirements:
206      *
207      * - `spender` cannot be the zero address.
208      */
209     function increaseAllowance(address spender, uint256 addedValue)
210         public
211         virtual
212         returns (bool)
213     {
214         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
215         return true;
216     }
217 
218     /**
219      * @dev Atomically decreases the allowance granted to `spender` by the caller.
220      *
221      * This is an alternative to {approve} that can be used as a mitigation for
222      * problems described in {IERC20-approve}.
223      *
224      * Emits an {Approval} event indicating the updated allowance.
225      *
226      * Requirements:
227      *
228      * - `spender` cannot be the zero address.
229      * - `spender` must have allowance for the caller of at least
230      * `subtractedValue`.
231      */
232     function decreaseAllowance(address spender, uint256 subtractedValue)
233         public
234         virtual
235         returns (bool)
236     {
237         uint256 currentAllowance = _allowances[_msgSender()][spender];
238         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
239         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
240 
241         return true;
242     }
243 
244     /**
245      * @dev Moves tokens `amount` from `sender` to `recipient`.
246      *
247      * This is internal function is equivalent to {transfer}, and can be used to
248      * e.g. implement automatic token fees, slashing mechanisms, etc.
249      *
250      * Emits a {Transfer} event.
251      *
252      * Requirements:
253      *
254      * - `sender` cannot be the zero address.
255      * - `recipient` cannot be the zero address.
256      * - `sender` must have a balance of at least `amount`.
257      */
258     function _transfer(
259         address sender,
260         address recipient,
261         uint256 amount
262     ) internal virtual {
263         require(sender != address(0), "ERC20: transfer from the zero address");
264         require(recipient != address(0), "ERC20: transfer to the zero address");
265 
266         uint256 senderBalance = _balances[sender];
267         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
268         _balances[sender] = senderBalance - amount;
269         _balances[recipient] += amount;
270 
271         emit Transfer(sender, recipient, amount);
272     }
273 
274     /** This function will be used to generate the total supply
275     * while deploying the contract
276     *
277     * This function can never be called again after deploying contract
278     */
279     function _tokengeneration(address account, uint256 amount) internal virtual {
280         _totalSupply = amount;
281         _balances[account] = amount;
282         emit Transfer(address(0), account, amount);
283     }
284 
285     /**
286      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
287      *
288      * This internal function is equivalent to `approve`, and can be used to
289      * e.g. set automatic allowances for certain subsystems, etc.
290      *
291      * Emits an {Approval} event.
292      *
293      * Requirements:
294      *
295      * - `owner` cannot be the zero address.
296      * - `spender` cannot be the zero address.
297      */
298     function _approve(
299         address owner,
300         address spender,
301         uint256 amount
302     ) internal virtual {
303         require(owner != address(0), "ERC20: approve from the zero address");
304         require(spender != address(0), "ERC20: approve to the zero address");
305 
306         _allowances[owner][spender] = amount;
307         emit Approval(owner, spender, amount);
308     }
309 }
310 
311 library Address {
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         (bool success, ) = recipient.call{ value: amount }("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 }
319 
320 abstract contract Ownable is Context {
321     address private _owner;
322 
323     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
324 
325     constructor() {
326         _setOwner(_msgSender());
327     }
328 
329     function owner() public view virtual returns (address) {
330         return _owner;
331     }
332 
333     modifier onlyOwner() {
334         require(owner() == _msgSender(), "Ownable: caller is not the owner");
335         _;
336     }
337 
338     function renounceOwnership() public virtual onlyOwner {
339         _setOwner(address(0));
340     }
341 
342     function transferOwnership(address newOwner) public virtual onlyOwner {
343         require(newOwner != address(0), "Ownable: new owner is the zero address");
344         _setOwner(newOwner);
345     }
346 
347     function _setOwner(address newOwner) private {
348         address oldOwner = _owner;
349         _owner = newOwner;
350         emit OwnershipTransferred(oldOwner, newOwner);
351     }
352 }
353 
354 interface IFactory {
355     function createPair(address tokenA, address tokenB) external returns (address pair);
356 }
357 
358 interface IRouter {
359     function factory() external pure returns (address);
360 
361     function WETH() external pure returns (address);
362 
363     function addLiquidityETH(
364         address token,
365         uint256 amountTokenDesired,
366         uint256 amountTokenMin,
367         uint256 amountETHMin,
368         address to,
369         uint256 deadline
370     )
371         external
372         payable
373         returns (
374             uint256 amountToken,
375             uint256 amountETH,
376             uint256 liquidity
377         );
378 
379     function swapExactTokensForETHSupportingFeeOnTransferTokens(
380         uint256 amountIn,
381         uint256 amountOutMin,
382         address[] calldata path,
383         address to,
384         uint256 deadline
385     ) external;
386 }
387 
388 interface referralLogic {
389     function referralBuy(address _buyer, uint256 _amount) external;
390 }
391 
392 contract BunnyAI is ERC20, Ownable {
393     using Address for address payable;
394 
395     IRouter public router;
396     address public pair;
397     address public referralContract;
398 
399     bool private _interlock = false;
400     bool public providingLiquidity = false;
401     bool public tradingEnabled = false;
402 
403     uint256 public tokenLiquidityThreshold = 23_000 * 10**18;
404     uint256 public maxBuyLimit = 230_000 * 10**18;
405     uint256 public maxSellLimit = 230_000 * 10**18;
406     uint256 public maxWalletLimit = 230_000 * 10**18;
407 
408     uint256 public genesis_block;
409 
410     address public marketingWallet = 0x42b756987dEE8a21508C4E470bfEfB5e36A5E4E4;
411     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
412 
413     struct Taxes {
414         uint256 marketing;
415         uint256 liquidity;
416         uint256 burn;
417     }
418 
419     Taxes public taxes = Taxes(5, 2, 1);
420     Taxes public sellTaxes = Taxes(7, 2, 1);
421     Taxes public transferTaxes = Taxes(0, 0, 0);
422 
423     mapping(address => bool) public exemptFee;
424 
425     bool public referralActive = false;
426 
427     modifier lockTheSwap() {
428         if (!_interlock) {
429             _interlock = true;
430             _;
431             _interlock = false;
432         }
433     }
434 
435     constructor() ERC20("BunnyAI", "BUNAI") {
436         _tokengeneration(msg.sender, 23_000_000 * 10**decimals());
437         exemptFee[msg.sender] = true;
438 
439         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
440         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
441 
442         router = _router;
443         pair = _pair;
444         exemptFee[address(this)] = true;
445         exemptFee[marketingWallet] = true;
446         exemptFee[deadWallet] = true;
447 
448     }
449 
450     function approve(address spender, uint256 amount) public override returns (bool) {
451         _approve(_msgSender(), spender, amount);
452         return true;
453     }
454 
455     function transferFrom(
456         address sender,
457         address recipient,
458         uint256 amount
459     ) public override returns (bool) {
460         _transfer(sender, recipient, amount);
461 
462         uint256 currentAllowance = _allowances[sender][_msgSender()];
463         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
464         _approve(sender, _msgSender(), currentAllowance - amount);
465 
466         return true;
467     }
468 
469     function increaseAllowance(address spender, uint256 addedValue)
470         public
471         override
472         returns (bool)
473     {
474         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
475         return true;
476     }
477 
478     function decreaseAllowance(address spender, uint256 subtractedValue)
479         public
480         override
481         returns (bool)
482     {
483         uint256 currentAllowance = _allowances[_msgSender()][spender];
484         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
485         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
486 
487         return true;
488     }
489 
490     function transfer(address recipient, uint256 amount) public override returns (bool) {
491         _transfer(msg.sender, recipient, amount);
492         return true;
493     }
494 
495     function _transfer(
496         address sender,
497         address recipient,
498         uint256 amount
499     ) internal override {
500         require(amount > 0, "Transfer amount must be greater than zero");
501 
502         if (!exemptFee[sender] && !exemptFee[recipient]) {
503             require(tradingEnabled, "Trading not enabled");
504         }
505 
506         if (sender == pair && !exemptFee[recipient] && !_interlock) {
507             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
508             require(
509                 balanceOf(recipient) + amount <= maxWalletLimit,
510                 "You are exceeding maxWalletLimit"
511             );
512         }
513 
514         if (
515             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_interlock
516         ) {
517             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
518             if (recipient != pair) {
519                 require(
520                     balanceOf(recipient) + amount <= maxWalletLimit,
521                     "You are exceeding maxWalletLimit"
522                 );
523             }
524         }
525 
526         
527         //Referral logic
528         if(sender == pair && referralActive) {
529             referralLogic(referralContract).referralBuy(recipient, amount);
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
546                 sellTaxes.burn;
547             feesum = feeswap;
548             currentTaxes = sellTaxes;
549         } else if (sender == pair) {
550             feeswap =
551                 taxes.liquidity +
552                 taxes.marketing +
553                 taxes.burn ;
554             feesum = feeswap;
555             currentTaxes = taxes;
556         } else {
557             feeswap =
558                 transferTaxes.liquidity +
559                 transferTaxes.marketing +
560                 transferTaxes.burn ;
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
576                 uint256 burnAmount = (amount * currentTaxes.burn) / 100;
577                 uint256 feeAmount = (amount * feeswap) / 100 - burnAmount;
578                 super._transfer(sender, address(this), feeAmount);
579                 super._transfer(sender, deadWallet, burnAmount);
580             }
581 
582         }
583     }
584 
585     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
586 
587         if(feeswap == 0){
588             return;
589         }
590 
591         uint256 contractBalance = balanceOf(address(this));
592         if (contractBalance >= tokenLiquidityThreshold) {
593             if (tokenLiquidityThreshold > 1) {
594                 contractBalance = tokenLiquidityThreshold;
595             }
596 
597             // Split the contract balance into halves
598             uint256 denominator = feeswap * 2;
599             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
600                 denominator;
601             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
602 
603             uint256 initialBalance = address(this).balance;
604 
605             swapTokensForETH(toSwap);
606 
607             uint256 deltaBalance = address(this).balance - initialBalance;
608             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
609             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
610 
611             if (ethToAddLiquidityWith > 0) {
612                 // Add liquidity to pancake
613                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
614             }
615 
616             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
617             if (marketingAmt > 0) {
618                 payable(marketingWallet).sendValue(marketingAmt);
619             }
620 
621         }
622     }
623 
624     function swapTokensForETH(uint256 tokenAmount) private {
625         // generate the pancake pair path of token -> weth
626         address[] memory path = new address[](2);
627         path[0] = address(this);
628         path[1] = router.WETH();
629 
630         _approve(address(this), address(router), tokenAmount);
631 
632         // make the swap
633         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
634             tokenAmount,
635             0,
636             path,
637             address(this),
638             block.timestamp
639         );
640     }
641 
642     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
643         // approve token transfer to cover all possible scenarios
644         _approve(address(this), address(router), tokenAmount);
645 
646         // add the liquidity
647         router.addLiquidityETH{ value: ethAmount }(
648             address(this),
649             tokenAmount,
650             0, // slippage is unavoidable
651             0, // slippage is unavoidable
652             deadWallet,
653             block.timestamp
654         );
655     }
656 
657     function updateLiquidityProvide(bool state) external onlyOwner {
658         //update liquidity providing state
659         providingLiquidity = state;
660     }
661 
662     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
663         //update the treshhold
664         require(new_amount <= 420_000 && new_amount > 0, "Swap threshold amount should be lower or euqal to 1% of tokens");
665         tokenLiquidityThreshold = new_amount * 10**decimals();
666     }
667 
668     function SetBuyTaxes(
669         uint256 _marketing,
670         uint256 _liquidity,
671         uint256 _burn
672     ) external onlyOwner {
673         taxes = Taxes(_marketing, _liquidity,  _burn);
674         require((_marketing + _liquidity +  _burn) <= 12, "Must keep fees at 12% or less");
675     }
676 
677     function SetSellTaxes(
678         uint256 _marketing,
679         uint256 _liquidity,
680         uint256 _burn
681     ) external onlyOwner {
682         sellTaxes = Taxes(_marketing, _liquidity,  _burn);
683         require((_marketing + _liquidity + _burn) <= 12, "Must keep fees at 12% or less");
684     }
685 
686     function SetTransferTaxes(
687         uint256 _marketing,
688         uint256 _liquidity,
689         uint256 _burn
690     ) external onlyOwner {
691         transferTaxes = Taxes(_marketing, _liquidity,  _burn);
692         require((_marketing + _liquidity + _burn) <= 12, "Must keep fees at 12% or less");
693     }
694 
695     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
696         router = IRouter(newRouter);
697         pair = newPair;
698     }
699 
700     function updateReferralContract(address _newReferralContract) external onlyOwner {
701         require(_newReferralContract != address(0),"Fee Address cannot be zero address");
702         referralContract = _newReferralContract;
703     }
704 
705     function toggleReferral(bool status) external onlyOwner{
706         referralActive = status;
707     }
708 
709     function _openTrading() external onlyOwner {
710         require(!tradingEnabled, "Cannot re-enable trading");
711         tradingEnabled = true;
712         providingLiquidity = true;
713         genesis_block = block.number;
714     }
715 
716     function _toggleTrading(bool status) external onlyOwner {
717         tradingEnabled = status;
718     }
719 
720     function updateMarketingWallet(address newWallet) external onlyOwner {
721         require(newWallet != address(0),"Fee Address cannot be zero address");
722         marketingWallet = newWallet;
723     }
724 
725     function updateExemptFee(address _address, bool state) external onlyOwner {
726         exemptFee[_address] = state;
727     }
728 
729     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
730         for (uint256 i = 0; i < accounts.length; i++) {
731             exemptFee[accounts[i]] = state;
732         }
733     }
734 
735     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell, uint256 maxWallet) external onlyOwner {
736         require(maxBuy >= 23_000, "Cannot set max buy amount lower than 0.1%");
737         require(maxSell >= 23_000, "Cannot set max sell amount lower than 0.1%");
738         require(maxWallet >= 230_000, "Cannot set max wallet amount lower than 1%");
739         maxBuyLimit = maxBuy * 10**decimals();
740         maxSellLimit = maxSell * 10**decimals();
741         maxWalletLimit = maxWallet * 10**decimals(); 
742     }
743 
744     function rescueBNB(uint256 weiAmount) external onlyOwner {
745         payable(owner()).transfer(weiAmount);
746     }
747 
748     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
749         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
750         IERC20(tokenAdd).transfer(owner(), amount);
751     }
752 
753     // fallbacks
754     receive() external payable {}
755 }