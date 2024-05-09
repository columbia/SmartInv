1 /*
2 https://safepepex.com/
3 https://t.me/safepepexeth
4 https://twitter.com/Safepepex
5 
6 Here to make history!
7 */
8 
9 //SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.19;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount)
30         external
31         returns (bool);
32 
33     function allowance(address owner, address spender)
34         external
35         view
36         returns (uint256);
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
48     event Approval(
49         address indexed owner,
50         address indexed spender,
51         uint256 value
52     );
53 }
54 
55 interface IERC20Metadata is IERC20 {
56     /**
57      * @dev Returns the name of the token.
58      */
59     function name() external view returns (string memory);
60 
61     /**
62      * @dev Returns the symbol of the token.
63      */
64     function symbol() external view returns (string memory);
65 
66     /**
67      * @dev Returns the decimals places of the token.
68      */
69     function decimals() external view returns (uint8);
70 }
71 
72 contract ERC20 is Context, IERC20, IERC20Metadata {
73     mapping(address => uint256) internal _balances;
74 
75     mapping(address => mapping(address => uint256)) internal _allowances;
76 
77     uint256 private _totalSupply;
78 
79     string private _name;
80     string private _symbol;
81 
82     /**
83      * @dev Sets the values for {name} and {symbol}.
84      *
85      * The defaut value of {decimals} is 18. To select a different value for
86      * {decimals} you should overload it.
87      *
88      * All two of these values are immutable: they can only be set once during
89      * construction.
90      */
91     constructor(string memory name_, string memory symbol_) {
92         _name = name_;
93         _symbol = symbol_;
94     }
95 
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() public view virtual override returns (string memory) {
100         return _name;
101     }
102 
103     /**
104      * @dev Returns the symbol of the token, usually a shorter version of the
105      * name.
106      */
107     function symbol() public view virtual override returns (string memory) {
108         return _symbol;
109     }
110 
111     /**
112      * @dev Returns the number of decimals used to get its user representation.
113      * For example, if `decimals` equals `2`, a balance of `505` tokens should
114      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
115      *
116      * Tokens usually opt for a value of 18, imitating the relationship between
117      * Ether and Wei. This is the value {ERC20} uses, unless this function is
118      * overridden;
119      *
120      * NOTE: This information is only used for _display_ purposes: it in
121      * no way affects any of the arithmetic of the contract, including
122      * {IERC20-balanceOf} and {IERC20-transfer}.
123      */
124     function decimals() public view virtual override returns (uint8) {
125         return 18;
126     }
127 
128     /**
129      * @dev See {IERC20-totalSupply}.
130      */
131     function totalSupply() public view virtual override returns (uint256) {
132         return _totalSupply;
133     }
134 
135     /**
136      * @dev See {IERC20-balanceOf}.
137      */
138     function balanceOf(address account)
139         public
140         view
141         virtual
142         override
143         returns (uint256)
144     {
145         return _balances[account];
146     }
147 
148     /**
149      * @dev See {IERC20-transfer}.
150      *
151      * Requirements:
152      *
153      * - `recipient` cannot be the zero address.
154      * - the caller must have a balance of at least `amount`.
155      */
156     function transfer(address recipient, uint256 amount)
157         public
158         virtual
159         override
160         returns (bool)
161     {
162         _transfer(_msgSender(), recipient, amount);
163         return true;
164     }
165 
166     /**
167      * @dev See {IERC20-allowance}.
168      */
169     function allowance(address owner, address spender)
170         public
171         view
172         virtual
173         override
174         returns (uint256)
175     {
176         return _allowances[owner][spender];
177     }
178 
179     /**
180      * @dev See {IERC20-approve}.
181      *
182      * Requirements:
183      *
184      * - `spender` cannot be the zero address.
185      */
186     function approve(address spender, uint256 amount)
187         public
188         virtual
189         override
190         returns (bool)
191     {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     /**
197      * @dev See {IERC20-transferFrom}.
198      *
199      * Emits an {Approval} event indicating the updated allowance. This is not
200      * required by the EIP. See the note at the beginning of {ERC20}.
201      *
202      * Requirements:
203      *
204      * - `sender` and `recipient` cannot be the zero address.
205      * - `sender` must have a balance of at least `amount`.
206      * - the caller must have allowance for ``sender``'s tokens of at least
207      * `amount`.
208      */
209     function transferFrom(
210         address sender,
211         address recipient,
212         uint256 amount
213     ) public virtual override returns (bool) {
214         _transfer(sender, recipient, amount);
215 
216         uint256 currentAllowance = _allowances[sender][_msgSender()];
217         require(
218             currentAllowance >= amount,
219             "ERC20: transfer amount exceeds allowance"
220         );
221         _approve(sender, _msgSender(), currentAllowance - amount);
222 
223         return true;
224     }
225 
226     /**
227      * @dev Atomically increases the allowance granted to `spender` by the caller.
228      *
229      * This is an alternative to {approve} that can be used as a mitigation for
230      * problems described in {IERC20-approve}.
231      *
232      * Emits an {Approval} event indicating the updated allowance.
233      *
234      * Requirements:
235      *
236      * - `spender` cannot be the zero address.
237      */
238     function increaseAllowance(address spender, uint256 addedValue)
239         public
240         virtual
241         returns (bool)
242     {
243         _approve(
244             _msgSender(),
245             spender,
246             _allowances[_msgSender()][spender] + addedValue
247         );
248         return true;
249     }
250 
251     /**
252      * @dev Atomically decreases the allowance granted to `spender` by the caller.
253      *
254      * This is an alternative to {approve} that can be used as a mitigation for
255      * problems described in {IERC20-approve}.
256      *
257      * Emits an {Approval} event indicating the updated allowance.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      * - `spender` must have allowance for the caller of at least
263      * `subtractedValue`.
264      */
265     function decreaseAllowance(address spender, uint256 subtractedValue)
266         public
267         virtual
268         returns (bool)
269     {
270         uint256 currentAllowance = _allowances[_msgSender()][spender];
271         require(
272             currentAllowance >= subtractedValue,
273             "ERC20: decreased allowance below zero"
274         );
275         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
276 
277         return true;
278     }
279 
280     /**
281      * @dev Moves tokens `amount` from `sender` to `recipient`.
282      *
283      * This is internal function is equivalent to {transfer}, and can be used to
284      * e.g. implement automatic token fees, slashing mechanisms, etc.
285      *
286      * Emits a {Transfer} event.
287      *
288      * Requirements:
289      *
290      * - `sender` cannot be the zero address.
291      * - `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `amount`.
293      */
294     function _transfer(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) internal virtual {
299         require(sender != address(0), "ERC20: transfer from the zero address");
300         require(recipient != address(0), "ERC20: transfer to the zero address");
301 
302         uint256 senderBalance = _balances[sender];
303         require(
304             senderBalance >= amount,
305             "ERC20: transfer amount exceeds balance"
306         );
307         _balances[sender] = senderBalance - amount;
308         _balances[recipient] += amount;
309 
310         emit Transfer(sender, recipient, amount);
311     }
312 
313     /** This function will be used to generate the total supply
314      * while deploying the contract
315      *
316      * This function can never be called again after deploying contract
317      */
318     function _tokengeneration(address account, uint256 amount)
319         internal
320         virtual
321     {
322         _totalSupply = amount;
323         _balances[account] = amount;
324         emit Transfer(address(0), account, amount);
325     }
326 
327     /**
328      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
329      *
330      * This internal function is equivalent to `approve`, and can be used to
331      * e.g. set automatic allowances for certain subsystems, etc.
332      *
333      * Emits an {Approval} event.
334      *
335      * Requirements:
336      *
337      * - `owner` cannot be the zero address.
338      * - `spender` cannot be the zero address.
339      */
340     function _approve(
341         address owner,
342         address spender,
343         uint256 amount
344     ) internal virtual {
345         require(owner != address(0), "ERC20: approve from the zero address");
346         require(spender != address(0), "ERC20: approve to the zero address");
347 
348         _allowances[owner][spender] = amount;
349         emit Approval(owner, spender, amount);
350     }
351 }
352 
353 library Address {
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(
356             address(this).balance >= amount,
357             "Address: insufficient balance"
358         );
359 
360         (bool success, ) = recipient.call{value: amount}("");
361         require(
362             success,
363             "Address: unable to send value, recipient may have reverted"
364         );
365     }
366 }
367 
368 abstract contract Ownable is Context {
369     address private _owner;
370 
371     event OwnershipTransferred(
372         address indexed previousOwner,
373         address indexed newOwner
374     );
375 
376     constructor() {
377         _setOwner(_msgSender());
378     }
379 
380     function owner() public view virtual returns (address) {
381         return _owner;
382     }
383 
384     modifier onlyOwner() {
385         require(owner() == _msgSender(), "Ownable: caller is not the owner");
386         _;
387     }
388 
389     function renounceOwnership() public virtual onlyOwner {
390         _setOwner(address(0));
391     }
392 
393     function transferOwnership(address newOwner) public virtual onlyOwner {
394         require(
395             newOwner != address(0),
396             "Ownable: new owner is the zero address"
397         );
398         _setOwner(newOwner);
399     }
400 
401     function _setOwner(address newOwner) private {
402         address oldOwner = _owner;
403         _owner = newOwner;
404         emit OwnershipTransferred(oldOwner, newOwner);
405     }
406 }
407 
408 interface IFactory {
409     function createPair(address tokenA, address tokenB)
410         external
411         returns (address pair);
412 }
413 
414 interface IRouter {
415     function factory() external pure returns (address);
416 
417     function WETH() external pure returns (address);
418 
419     function addLiquidityETH(
420         address token,
421         uint256 amountTokenDesired,
422         uint256 amountTokenMin,
423         uint256 amountETHMin,
424         address to,
425         uint256 deadline
426     )
427         external
428         payable
429         returns (
430             uint256 amountToken,
431             uint256 amountETH,
432             uint256 liquidity
433         );
434 
435     function swapExactTokensForETHSupportingFeeOnTransferTokens(
436         uint256 amountIn,
437         uint256 amountOutMin,
438         address[] calldata path,
439         address to,
440         uint256 deadline
441     ) external;
442 }
443 
444  contract SAFEPEPEX is ERC20, Ownable {
445     using Address for address payable;
446 
447     IRouter public router;
448     address public pair;
449 
450     bool private _interlock = false;
451     bool private providingLiquidity = true;
452     bool public tradingEnabled = false;
453 
454     uint256 public tokenLiquidityThreshold = 420690000000 * 10**18; // 0.1%
455     uint256 public MaxTxAmount = 4206900000000 * 10**18; // 1%
456     uint256 public MaxWalletSize = 4206900000000 * 10**18; // 1%
457     
458     address public marketingWallet = 0x157D173DE52BfE4422976133c336Bf2EB9B74D5e;
459     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
460 
461     struct Taxes {
462         uint256 marketing;
463         uint256 liquidity;
464     }
465 
466     Taxes private taxes = Taxes(2, 0);
467     Taxes private sellTaxes = Taxes(60, 0);
468 
469     uint256 public BuyTaxes = taxes.marketing + taxes.liquidity;
470     uint256 public SellTaxes = sellTaxes.marketing + sellTaxes.liquidity;
471 
472     mapping(address => bool) public exemptFee;
473     mapping(address => bool) private isearlybuyer;
474 
475     event MaxTxUpdated(uint256 MaxWalletSize, uint256 MaxTxAmount);
476     event BuyTaxesUpdated(uint256 marketing,  uint256 liquidity);
477     event SellTaxesUpdated(uint256 marketing, uint256 liquidity);
478    
479     modifier lockTheSwap() {
480         if (!_interlock) {
481             _interlock = true;
482             _;
483             _interlock = false;
484         }
485     }
486 
487     constructor() ERC20("SafePepe X", "SPX") {
488         _tokengeneration(msg.sender, 420690000000000 * 10**decimals());
489         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
490         address _pair = IFactory(_router.factory()).createPair(address(this),_router.WETH());
491         router = _router;
492         pair = _pair;
493         
494         exemptFee[msg.sender] = true;
495         exemptFee[address(this)] = true;
496         exemptFee[marketingWallet] = true;
497         exemptFee[deadWallet] = true;
498     }
499 
500     function approve(address spender, uint256 amount)
501         public
502         override
503         returns (bool)
504     {
505         _approve(_msgSender(), spender, amount);
506         return true;
507     }
508 
509     function transferFrom(
510         address sender,
511         address recipient,
512         uint256 amount
513     ) public override returns (bool) {
514         _transfer(sender, recipient, amount);
515 
516         uint256 currentAllowance = _allowances[sender][_msgSender()];
517         require(
518             currentAllowance >= amount,
519             "ERC20: transfer amount exceeds allowance"
520         );
521         _approve(sender, _msgSender(), currentAllowance - amount);
522 
523         return true;
524     }
525 
526     function increaseAllowance(address spender, uint256 addedValue)
527         public
528         override
529         returns (bool)
530     {
531         _approve(
532             _msgSender(),
533             spender,
534             _allowances[_msgSender()][spender] + addedValue
535         );
536         return true;
537     }
538 
539     function decreaseAllowance(address spender, uint256 subtractedValue)
540         public
541         override
542         returns (bool)
543     {
544         uint256 currentAllowance = _allowances[_msgSender()][spender];
545         require(currentAllowance >= subtractedValue,"ERC20: decreased allowance below zero");
546         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
547 
548         return true;
549     }
550 
551     function transfer(address recipient, uint256 amount)
552         public
553         override
554         returns (bool)
555     {
556         _transfer(msg.sender, recipient, amount);
557         return true;
558     }
559 
560     function _transfer(address sender, address recipient, uint256 amount) internal override {
561         require(amount > 0, "Transfer amount must be greater than zero");
562          require(!isearlybuyer[sender] && !isearlybuyer[recipient],
563             "You can't transfer tokens"
564         );
565       
566        if (!exemptFee[sender] && !exemptFee[recipient]) {
567             require(tradingEnabled, "Trading not enabled");
568         }
569         
570         if (sender == pair && recipient != address(router) && !exemptFee[recipient] ) {
571                 require(amount <= MaxTxAmount, "Exceeds the _maxTxAmount.");
572                 require(balanceOf(recipient) + amount <= MaxWalletSize, "Exceeds the maxWalletSize.");
573                 
574             }
575         uint256 feeswap;
576         uint256 feesum;
577         uint256 fee;
578         Taxes memory currentTaxes;
579 
580         //set fee to zero if fees in contract are handled or exempted
581         if (_interlock || exemptFee[sender] || exemptFee[recipient])
582             fee = 0;
583 
584             //calculate fee
585         else if (recipient == pair) {
586             feeswap = sellTaxes.liquidity + sellTaxes.marketing;
587             feesum = feeswap;
588             currentTaxes = sellTaxes;
589         } else if (recipient != pair) {
590             feeswap = taxes.liquidity + taxes.marketing;
591             feesum = feeswap;
592             currentTaxes = taxes;
593         } 
594 
595         fee = (amount * feesum) / 100;
596 
597         //send fees if threshold has been reached
598         //don't do this on buys, breaks swap
599         if (providingLiquidity && sender != pair)
600             Liquify(feeswap, currentTaxes);
601 
602         //rest to recipient
603         super._transfer(sender, recipient, amount - fee);
604         if (fee > 0) {
605             //send the fee to the contract
606             if (feeswap > 0) {
607                 uint256 feeAmount = (amount * feeswap) / 100;
608                 super._transfer(sender, address(this), feeAmount);
609             }
610         }
611   }
612 
613     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
614         if (feeswap == 0) {
615             return;
616         }
617 
618         uint256 contractBalance = balanceOf(address(this));
619         if (contractBalance >= tokenLiquidityThreshold) {
620             if (tokenLiquidityThreshold > 1) {
621                 contractBalance = tokenLiquidityThreshold;
622             }
623 
624             // Split the contract balance into halves
625             uint256 denominator = feeswap * 2;
626             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) / denominator;
627             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
628 
629             uint256 initialBalance = address(this).balance;
630 
631             swapTokensForETH(toSwap);
632 
633             uint256 deltaBalance = address(this).balance - initialBalance;
634             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
635             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
636 
637             if (ethToAddLiquidityWith > 0) {
638                 // Add liquidity to pancake
639                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
640             }
641 
642             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
643             if (marketingAmt > 0) {
644                 payable(marketingWallet).sendValue(marketingAmt);
645             }
646         }
647     }
648 
649     function swapTokensForETH(uint256 tokenAmount) private {
650         address[] memory path = new address[](2);
651         path[0] = address(this);
652         path[1] = router.WETH();
653 
654         _approve(address(this), address(router), tokenAmount);
655 
656         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
657             tokenAmount,
658             0,
659             path,
660             address(this),
661             block.timestamp
662         );
663     }
664 
665     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
666         _approve(address(this), address(router), tokenAmount);
667 
668         // add the liquidity
669         router.addLiquidityETH{value: ethAmount}(
670             address(this),
671             tokenAmount,
672             0, // slippage is unavoidable
673             0, // slippage is unavoidable
674             deadWallet,
675             block.timestamp
676         );
677     }
678 
679     function updateLiquidityProvide(bool state) external onlyOwner {
680         providingLiquidity = state;
681     }
682 
683     function setLiquidityTreshhold(uint256 new_amount) external onlyOwner {
684         require(new_amount <= 4206900000000,"Swap threshold amount should be lower or equal to 1% of tokens");
685         tokenLiquidityThreshold = new_amount * 10**decimals();
686     }
687 
688     function updateBuyFee( uint256 _marketing, uint256 _liquidity) external onlyOwner {
689         taxes.marketing = _marketing;
690         taxes.liquidity = _liquidity;
691      emit BuyTaxesUpdated(_marketing, _liquidity);
692     }
693 
694     function updateSellFee( uint256 _marketing, uint256 _liquidity) external onlyOwner {
695         sellTaxes.marketing = _marketing;
696         sellTaxes.liquidity = _liquidity;
697     emit SellTaxesUpdated(_marketing, _liquidity);
698     }
699    
700      function setMaxTxLimit(uint256 _maxWallet, uint256 _maxTx) external onlyOwner {
701         MaxWalletSize = _maxWallet * 10**decimals(); 
702         MaxTxAmount = _maxTx * 10**decimals();
703     require (_maxWallet >= 420690000000, "Cannot set MaxWallet amount lower then 0.1%");
704     require (_maxTx >= 420690000000, "Cannot set MaxTx amount lower then 0.1%");
705     emit MaxTxUpdated(_maxWallet, _maxTx);
706     }
707     
708     function enableTrading() external onlyOwner {
709         require(!tradingEnabled, "Cannot re-enable trading");
710         tradingEnabled = true;
711     }
712    
713     function setMarketingWallet(address newWallet) external onlyOwner {
714         require(newWallet != address(0), "Fee Address cannot be zero address");
715         require(newWallet != address(this), "Fee Address cannot be CA");
716         exemptFee[newWallet] = true;
717         marketingWallet = newWallet;
718     }
719 
720       function multiBlockSniper(address[] memory accounts, bool state) external onlyOwner {
721         for (uint256 i = 0; i < accounts.length; i++) {
722             isearlybuyer[accounts[i]] = state;
723         }
724     }
725 
726     function blockSniper(address account, bool state) external onlyOwner {
727         isearlybuyer[account] = state;
728     }
729    
730     function excludeFromFee(address _address) external onlyOwner {
731         exemptFee[_address] = true;
732     }
733 
734     function includeInFee(address _address) external onlyOwner {
735         exemptFee[_address] = false;
736     }
737 
738     function rescueEHT() external onlyOwner {
739         uint256 contractETHBalance = address(this).balance;
740         payable(owner()).transfer(contractETHBalance);
741     }
742 
743     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
744         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
745         IERC20(tokenAdd).transfer(owner(), amount);
746     }
747 
748     // fallbacks
749     receive() external payable {}
750 }