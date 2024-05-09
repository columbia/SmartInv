1 /* 
2 
3 www.oxchain.vip
4 https://t.me/Ox_Chain
5 https://twitter.com/OxchainETH
6 
7 */
8 
9 
10 //SPDX-License-Identifier: MIT
11 
12 pragma solidity ^0.8.19;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27 
28     function balanceOf(address account) external view returns (uint256);
29 
30     function transfer(address recipient, uint256 amount)
31         external
32         returns (bool);
33 
34     function allowance(address owner, address spender)
35         external
36         view
37         returns (uint256);
38 
39     function approve(address spender, uint256 amount) external returns (bool);
40 
41     function transferFrom(
42         address sender,
43         address recipient,
44         uint256 amount
45     ) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     event Approval(
50         address indexed owner,
51         address indexed spender,
52         uint256 value
53     );
54 }
55 
56 interface IERC20Metadata is IERC20 {
57     /**
58      * @dev Returns the name of the token.
59      */
60     function name() external view returns (string memory);
61 
62     /**
63      * @dev Returns the symbol of the token.
64      */
65     function symbol() external view returns (string memory);
66 
67     /**
68      * @dev Returns the decimals places of the token.
69      */
70     function decimals() external view returns (uint8);
71 }
72 
73 contract ERC20 is Context, IERC20, IERC20Metadata {
74     mapping(address => uint256) internal _balances;
75 
76     mapping(address => mapping(address => uint256)) internal _allowances;
77 
78     uint256 private _totalSupply;
79 
80     string private _name;
81     string private _symbol;
82 
83     /**
84      * @dev Sets the values for {name} and {symbol}.
85      *
86      * The defaut value of {decimals} is 18. To select a different value for
87      * {decimals} you should overload it.
88      *
89      * All two of these values are immutable: they can only be set once during
90      * construction.
91      */
92     constructor(string memory name_, string memory symbol_) {
93         _name = name_;
94         _symbol = symbol_;
95     }
96 
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() public view virtual override returns (string memory) {
101         return _name;
102     }
103 
104     /**
105      * @dev Returns the symbol of the token, usually a shorter version of the
106      * name.
107      */
108     function symbol() public view virtual override returns (string memory) {
109         return _symbol;
110     }
111 
112     /**
113      * @dev Returns the number of decimals used to get its user representation.
114      * For example, if `decimals` equals `2`, a balance of `505` tokens should
115      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
116      *
117      * Tokens usually opt for a value of 18, imitating the relationship between
118      * Ether and Wei. This is the value {ERC20} uses, unless this function is
119      * overridden;
120      *
121      * NOTE: This information is only used for _display_ purposes: it in
122      * no way affects any of the arithmetic of the contract, including
123      * {IERC20-balanceOf} and {IERC20-transfer}.
124      */
125     function decimals() public view virtual override returns (uint8) {
126         return 18;
127     }
128 
129     /**
130      * @dev See {IERC20-totalSupply}.
131      */
132     function totalSupply() public view virtual override returns (uint256) {
133         return _totalSupply;
134     }
135 
136     /**
137      * @dev See {IERC20-balanceOf}.
138      */
139     function balanceOf(address account)
140         public
141         view
142         virtual
143         override
144         returns (uint256)
145     {
146         return _balances[account];
147     }
148 
149     /**
150      * @dev See {IERC20-transfer}.
151      *
152      * Requirements:
153      *
154      * - `recipient` cannot be the zero address.
155      * - the caller must have a balance of at least `amount`.
156      */
157     function transfer(address recipient, uint256 amount)
158         public
159         virtual
160         override
161         returns (bool)
162     {
163         _transfer(_msgSender(), recipient, amount);
164         return true;
165     }
166 
167     /**
168      * @dev See {IERC20-allowance}.
169      */
170     function allowance(address owner, address spender)
171         public
172         view
173         virtual
174         override
175         returns (uint256)
176     {
177         return _allowances[owner][spender];
178     }
179 
180     /**
181      * @dev See {IERC20-approve}.
182      *
183      * Requirements:
184      *
185      * - `spender` cannot be the zero address.
186      */
187     function approve(address spender, uint256 amount)
188         public
189         virtual
190         override
191         returns (bool)
192     {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     /**
198      * @dev See {IERC20-transferFrom}.
199      *
200      * Emits an {Approval} event indicating the updated allowance. This is not
201      * required by the EIP. See the note at the beginning of {ERC20}.
202      *
203      * Requirements:
204      *
205      * - `sender` and `recipient` cannot be the zero address.
206      * - `sender` must have a balance of at least `amount`.
207      * - the caller must have allowance for ``sender``'s tokens of at least
208      * `amount`.
209      */
210     function transferFrom(
211         address sender,
212         address recipient,
213         uint256 amount
214     ) public virtual override returns (bool) {
215         _transfer(sender, recipient, amount);
216 
217         uint256 currentAllowance = _allowances[sender][_msgSender()];
218         require(
219             currentAllowance >= amount,
220             "ERC20: transfer amount exceeds allowance"
221         );
222         _approve(sender, _msgSender(), currentAllowance - amount);
223 
224         return true;
225     }
226 
227     /**
228      * @dev Atomically increases the allowance granted to `spender` by the caller.
229      *
230      * This is an alternative to {approve} that can be used as a mitigation for
231      * problems described in {IERC20-approve}.
232      *
233      * Emits an {Approval} event indicating the updated allowance.
234      *
235      * Requirements:
236      *
237      * - `spender` cannot be the zero address.
238      */
239     function increaseAllowance(address spender, uint256 addedValue)
240         public
241         virtual
242         returns (bool)
243     {
244         _approve(
245             _msgSender(),
246             spender,
247             _allowances[_msgSender()][spender] + addedValue
248         );
249         return true;
250     }
251 
252     /**
253      * @dev Atomically decreases the allowance granted to `spender` by the caller.
254      *
255      * This is an alternative to {approve} that can be used as a mitigation for
256      * problems described in {IERC20-approve}.
257      *
258      * Emits an {Approval} event indicating the updated allowance.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      * - `spender` must have allowance for the caller of at least
264      * `subtractedValue`.
265      */
266     function decreaseAllowance(address spender, uint256 subtractedValue)
267         public
268         virtual
269         returns (bool)
270     {
271         uint256 currentAllowance = _allowances[_msgSender()][spender];
272         require(
273             currentAllowance >= subtractedValue,
274             "ERC20: decreased allowance below zero"
275         );
276         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
277 
278         return true;
279     }
280 
281     /**
282      * @dev Moves tokens `amount` from `sender` to `recipient`.
283      *
284      * This is internal function is equivalent to {transfer}, and can be used to
285      * e.g. implement automatic token fees, slashing mechanisms, etc.
286      *
287      * Emits a {Transfer} event.
288      *
289      * Requirements:
290      *
291      * - `sender` cannot be the zero address.
292      * - `recipient` cannot be the zero address.
293      * - `sender` must have a balance of at least `amount`.
294      */
295     function _transfer(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) internal virtual {
300         require(sender != address(0), "ERC20: transfer from the zero address");
301         require(recipient != address(0), "ERC20: transfer to the zero address");
302 
303         uint256 senderBalance = _balances[sender];
304         require(
305             senderBalance >= amount,
306             "ERC20: transfer amount exceeds balance"
307         );
308         _balances[sender] = senderBalance - amount;
309         _balances[recipient] += amount;
310 
311         emit Transfer(sender, recipient, amount);
312     }
313 
314     /** This function will be used to generate the total supply
315      * while deploying the contract
316      *
317      * This function can never be called again after deploying contract
318      */
319     function _tokengeneration(address account, uint256 amount)
320         internal
321         virtual
322     {
323         _totalSupply = amount;
324         _balances[account] = amount;
325         emit Transfer(address(0), account, amount);
326     }
327 
328     /**
329      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
330      *
331      * This internal function is equivalent to `approve`, and can be used to
332      * e.g. set automatic allowances for certain subsystems, etc.
333      *
334      * Emits an {Approval} event.
335      *
336      * Requirements:
337      *
338      * - `owner` cannot be the zero address.
339      * - `spender` cannot be the zero address.
340      */
341     function _approve(
342         address owner,
343         address spender,
344         uint256 amount
345     ) internal virtual {
346         require(owner != address(0), "ERC20: approve from the zero address");
347         require(spender != address(0), "ERC20: approve to the zero address");
348 
349         _allowances[owner][spender] = amount;
350         emit Approval(owner, spender, amount);
351     }
352 }
353 
354 library Address {
355     function sendValue(address payable recipient, uint256 amount) internal {
356         require(
357             address(this).balance >= amount,
358             "Address: insufficient balance"
359         );
360 
361         (bool success, ) = recipient.call{value: amount}("");
362         require(
363             success,
364             "Address: unable to send value, recipient may have reverted"
365         );
366     }
367 }
368 
369 abstract contract Ownable is Context {
370     address private _owner;
371 
372     event OwnershipTransferred(
373         address indexed previousOwner,
374         address indexed newOwner
375     );
376 
377     constructor() {
378         _setOwner(_msgSender());
379     }
380 
381     function owner() public view virtual returns (address) {
382         return _owner;
383     }
384 
385     modifier onlyOwner() {
386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     function renounceOwnership() public virtual onlyOwner {
391         _setOwner(address(0));
392     }
393 
394     function transferOwnership(address newOwner) public virtual onlyOwner {
395         require(
396             newOwner != address(0),
397             "Ownable: new owner is the zero address"
398         );
399         _setOwner(newOwner);
400     }
401 
402     function _setOwner(address newOwner) private {
403         address oldOwner = _owner;
404         _owner = newOwner;
405         emit OwnershipTransferred(oldOwner, newOwner);
406     }
407 }
408 
409 interface IFactory {
410     function createPair(address tokenA, address tokenB)
411         external
412         returns (address pair);
413 }
414 
415 interface IRouter {
416     function factory() external pure returns (address);
417 
418     function WETH() external pure returns (address);
419 
420     function addLiquidityETH(
421         address token,
422         uint256 amountTokenDesired,
423         uint256 amountTokenMin,
424         uint256 amountETHMin,
425         address to,
426         uint256 deadline
427     )
428         external
429         payable
430         returns (
431             uint256 amountToken,
432             uint256 amountETH,
433             uint256 liquidity
434         );
435 
436     function swapExactTokensForETHSupportingFeeOnTransferTokens(
437         uint256 amountIn,
438         uint256 amountOutMin,
439         address[] calldata path,
440         address to,
441         uint256 deadline
442     ) external;
443 }
444 
445  contract Ox is ERC20, Ownable {
446     using Address for address payable;
447 
448     IRouter public router;
449     address public pair;
450 
451     bool private _interlock = false;
452     bool private providingLiquidity = true;
453     bool public tradingEnabled = false;
454 
455     uint256 private maxThreshold = 10000000 * 10**18; // 1%
456     uint256 private minThrehold = 100000 * 10**18; // 0.01%
457     
458     uint256 public MaxTxAmount = 10000000 * 10**18; // 1%
459     uint256 public MaxWalletSize = 20000000 * 10**18; // 2%
460     
461     address public marketingWallet = 0x1Bf03b3cFB9F3bdB1aEDEf827c89561F7817f786;
462     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
463 
464     struct Taxes {
465         uint256 marketing;
466         uint256 liquidity;
467     }
468 
469     Taxes private taxes = Taxes(21, 0);
470     Taxes private sellTaxes = Taxes(35, 0);
471 
472     uint256 public BuyTaxes = taxes.marketing + taxes.liquidity;
473     uint256 public SellTaxes = sellTaxes.marketing + sellTaxes.liquidity;
474 
475     mapping(address => bool) public exemptFee;
476     mapping(address => bool) private isearlybuyer;
477 
478     event MaxTxUpdated(uint256 MaxWalletSize, uint256 MaxTxAmount);
479     event BuyTaxesUpdated(uint256 marketing,  uint256 liquidity);
480     event SellTaxesUpdated(uint256 marketing, uint256 liquidity);
481    
482     modifier lockTheSwap() {
483         if (!_interlock) {
484             _interlock = true;
485             _;
486             _interlock = false;
487         }
488     }
489 
490     constructor() ERC20("Ox Chain", "0x") {
491         _tokengeneration(msg.sender, 1000000000 * 10**decimals());
492         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
493         address _pair = IFactory(_router.factory()).createPair(address(this),_router.WETH());
494         router = _router;
495         pair = _pair;
496         
497         exemptFee[msg.sender] = true;
498         exemptFee[address(this)] = true;
499         exemptFee[marketingWallet] = true;
500         exemptFee[deadWallet] = true;
501     }
502 
503     function approve(address spender, uint256 amount)
504         public
505         override
506         returns (bool)
507     {
508         _approve(_msgSender(), spender, amount);
509         return true;
510     }
511 
512     function transferFrom(
513         address sender,
514         address recipient,
515         uint256 amount
516     ) public override returns (bool) {
517         _transfer(sender, recipient, amount);
518 
519         uint256 currentAllowance = _allowances[sender][_msgSender()];
520         require(
521             currentAllowance >= amount,
522             "ERC20: transfer amount exceeds allowance"
523         );
524         _approve(sender, _msgSender(), currentAllowance - amount);
525 
526         return true;
527     }
528 
529     function increaseAllowance(address spender, uint256 addedValue)
530         public
531         override
532         returns (bool)
533     {
534         _approve(
535             _msgSender(),
536             spender,
537             _allowances[_msgSender()][spender] + addedValue
538         );
539         return true;
540     }
541 
542     function decreaseAllowance(address spender, uint256 subtractedValue)
543         public
544         override
545         returns (bool)
546     {
547         uint256 currentAllowance = _allowances[_msgSender()][spender];
548         require(currentAllowance >= subtractedValue,"ERC20: decreased allowance below zero");
549         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
550 
551         return true;
552     }
553 
554     function transfer(address recipient, uint256 amount)
555         public
556         override
557         returns (bool)
558     {
559         _transfer(msg.sender, recipient, amount);
560         return true;
561     }
562 
563     function _transfer(address sender, address recipient, uint256 amount) internal override {
564         require(amount > 0, "Transfer amount must be greater than zero");
565          require(!isearlybuyer[sender] && !isearlybuyer[recipient],
566             "You can't transfer tokens"
567         );
568       
569        if (!exemptFee[sender] && !exemptFee[recipient]) {
570             require(tradingEnabled, "Trading not enabled");
571         }
572         
573         if (sender == pair && recipient != address(router) && !exemptFee[recipient] ) {
574                 require(amount <= MaxTxAmount, "Exceeds the _maxTxAmount.");
575                 require(balanceOf(recipient) + amount <= MaxWalletSize, "Exceeds the maxWalletSize.");
576                 
577             }
578         uint256 feeswap;
579         uint256 feesum;
580         uint256 fee;
581         Taxes memory currentTaxes;
582 
583         //set fee to zero if fees in contract are handled or exempted
584         if (_interlock || exemptFee[sender] || exemptFee[recipient])
585             fee = 0;
586 
587             //calculate fee
588         else if (recipient == pair) {
589             feeswap = sellTaxes.liquidity + sellTaxes.marketing;
590             feesum = feeswap;
591             currentTaxes = sellTaxes;
592         } else if (recipient != pair) {
593             feeswap = taxes.liquidity + taxes.marketing;
594             feesum = feeswap;
595             currentTaxes = taxes;
596         } 
597 
598         fee = (amount * feesum) / 100;
599 
600         //send fees if threshold has been reached
601         //don't do this on buys, breaks swap
602         if (providingLiquidity && sender != pair)
603             Liquify(feeswap, currentTaxes);
604 
605         //rest to recipient
606         super._transfer(sender, recipient, amount - fee);
607         if (fee > 0) {
608             //send the fee to the contract
609             if (feeswap > 0) {
610                 uint256 feeAmount = (amount * feeswap) / 100;
611                 super._transfer(sender, address(this), feeAmount);
612             }
613         }
614   }
615 
616     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
617         if (feeswap == 0) {
618             return;
619         }
620 
621         uint256 contractBalance = balanceOf(address(this));
622         if (contractBalance >= minThrehold) {
623             if (contractBalance > maxThreshold) {
624             }
625 
626             // Split the contract balance into halves
627             uint256 denominator = feeswap * 2;
628             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) / denominator;
629             uint256 initialBalance = address(this).balance;
630 
631             swapTokensForETH(contractBalance);
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
683    
684     function UpdateTreshhold(uint256 max_amount, uint256 min_amount) external onlyOwner {
685         require(max_amount <= 200000000, "must keep max Threshold at 1% or less" );
686         require(min_amount >= 200000000, "min Threshold must be greater than or equal to 0.01%");
687         maxThreshold = max_amount * 10**decimals();
688         minThrehold = min_amount * 10**decimals();
689     }
690     
691     function updateBuyFee( uint256 _marketing, uint256 _liquidity) external onlyOwner {
692         taxes.marketing = _marketing;
693         taxes.liquidity = _liquidity;
694      emit BuyTaxesUpdated(_marketing, _liquidity);
695     }
696 
697     function updateSellFee( uint256 _marketing, uint256 _liquidity) external onlyOwner {
698         sellTaxes.marketing = _marketing;
699         sellTaxes.liquidity = _liquidity;
700     emit SellTaxesUpdated(_marketing, _liquidity);
701     }
702    
703      function setMaxTxLimit(uint256 _maxWallet, uint256 _maxTx) external onlyOwner {
704         MaxWalletSize = _maxWallet * 10**decimals(); 
705         MaxTxAmount = _maxTx * 10**decimals();
706     require (_maxWallet >= 20000000, "Cannot set MaxWallet amount lower then 0.1%");
707     require (_maxTx >= 20000000, "Cannot set MaxTx amount lower then 0.1%");
708     emit MaxTxUpdated(_maxWallet, _maxTx);
709     }
710     
711     function enableTrading() external onlyOwner {
712         require(!tradingEnabled, "Cannot re-enable trading");
713         tradingEnabled = true;
714     }
715    
716     function setMarketingWallet(address newWallet) external onlyOwner {
717         require(newWallet != address(0), "Fee Address cannot be zero address");
718         require(newWallet != address(this), "Fee Address cannot be CA");
719         exemptFee[newWallet] = true;
720         marketingWallet = newWallet;
721     }
722 
723       function multiBlockSniper(address[] memory accounts, bool state) external onlyOwner {
724         for (uint256 i = 0; i < accounts.length; i++) {
725             isearlybuyer[accounts[i]] = state;
726         }
727     }
728 
729     function blockSniper(address account, bool state) external onlyOwner {
730         isearlybuyer[account] = state;
731     }
732    
733     function excludeFromFee(address _address) external onlyOwner {
734         exemptFee[_address] = true;
735     }
736 
737     function includeInFee(address _address) external onlyOwner {
738         exemptFee[_address] = false;
739     }
740 
741     function rescueEHT() external onlyOwner {
742         uint256 contractETHBalance = address(this).balance;
743         payable(owner()).transfer(contractETHBalance);
744     }
745 
746     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
747         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
748         IERC20(tokenAdd).transfer(owner(), amount);
749     }
750 
751     // fallbacks
752     receive() external payable {}
753 }