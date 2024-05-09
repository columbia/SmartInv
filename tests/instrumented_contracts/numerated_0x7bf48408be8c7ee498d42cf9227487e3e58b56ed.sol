1 /*
2 https://trackererc.site/
3 https://t.me/TrackerERC
4 https://twitter.com/Tracker_ETH_
5 */
6 
7 //SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.19;
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
27     function transfer(address recipient, uint256 amount)
28         external
29         returns (bool);
30 
31     function allowance(address owner, address spender)
32         external
33         view
34         returns (uint256);
35 
36     function approve(address spender, uint256 amount) external returns (bool);
37 
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     event Approval(
47         address indexed owner,
48         address indexed spender,
49         uint256 value
50     );
51 }
52 
53 interface IERC20Metadata is IERC20 {
54     /**
55      * @dev Returns the name of the token.
56      */
57     function name() external view returns (string memory);
58 
59     /**
60      * @dev Returns the symbol of the token.
61      */
62     function symbol() external view returns (string memory);
63 
64     /**
65      * @dev Returns the decimals places of the token.
66      */
67     function decimals() external view returns (uint8);
68 }
69 
70 contract ERC20 is Context, IERC20, IERC20Metadata {
71     mapping(address => uint256) internal _balances;
72 
73     mapping(address => mapping(address => uint256)) internal _allowances;
74 
75     uint256 private _totalSupply;
76 
77     string private _name;
78     string private _symbol;
79 
80     /**
81      * @dev Sets the values for {name} and {symbol}.
82      *
83      * The defaut value of {decimals} is 18. To select a different value for
84      * {decimals} you should overload it.
85      *
86      * All two of these values are immutable: they can only be set once during
87      * construction.
88      */
89     constructor(string memory name_, string memory symbol_) {
90         _name = name_;
91         _symbol = symbol_;
92     }
93 
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() public view virtual override returns (string memory) {
98         return _name;
99     }
100 
101     /**
102      * @dev Returns the symbol of the token, usually a shorter version of the
103      * name.
104      */
105     function symbol() public view virtual override returns (string memory) {
106         return _symbol;
107     }
108 
109     /**
110      * @dev Returns the number of decimals used to get its user representation.
111      * For example, if `decimals` equals `2`, a balance of `505` tokens should
112      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
113      *
114      * Tokens usually opt for a value of 18, imitating the relationship between
115      * Ether and Wei. This is the value {ERC20} uses, unless this function is
116      * overridden;
117      *
118      * NOTE: This information is only used for _display_ purposes: it in
119      * no way affects any of the arithmetic of the contract, including
120      * {IERC20-balanceOf} and {IERC20-transfer}.
121      */
122     function decimals() public view virtual override returns (uint8) {
123         return 18;
124     }
125 
126     /**
127      * @dev See {IERC20-totalSupply}.
128      */
129     function totalSupply() public view virtual override returns (uint256) {
130         return _totalSupply;
131     }
132 
133     /**
134      * @dev See {IERC20-balanceOf}.
135      */
136     function balanceOf(address account)
137         public
138         view
139         virtual
140         override
141         returns (uint256)
142     {
143         return _balances[account];
144     }
145 
146     /**
147      * @dev See {IERC20-transfer}.
148      *
149      * Requirements:
150      *
151      * - `recipient` cannot be the zero address.
152      * - the caller must have a balance of at least `amount`.
153      */
154     function transfer(address recipient, uint256 amount)
155         public
156         virtual
157         override
158         returns (bool)
159     {
160         _transfer(_msgSender(), recipient, amount);
161         return true;
162     }
163 
164     /**
165      * @dev See {IERC20-allowance}.
166      */
167     function allowance(address owner, address spender)
168         public
169         view
170         virtual
171         override
172         returns (uint256)
173     {
174         return _allowances[owner][spender];
175     }
176 
177     /**
178      * @dev See {IERC20-approve}.
179      *
180      * Requirements:
181      *
182      * - `spender` cannot be the zero address.
183      */
184     function approve(address spender, uint256 amount)
185         public
186         virtual
187         override
188         returns (bool)
189     {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     /**
195      * @dev See {IERC20-transferFrom}.
196      *
197      * Emits an {Approval} event indicating the updated allowance. This is not
198      * required by the EIP. See the note at the beginning of {ERC20}.
199      *
200      * Requirements:
201      *
202      * - `sender` and `recipient` cannot be the zero address.
203      * - `sender` must have a balance of at least `amount`.
204      * - the caller must have allowance for ``sender``'s tokens of at least
205      * `amount`.
206      */
207     function transferFrom(
208         address sender,
209         address recipient,
210         uint256 amount
211     ) public virtual override returns (bool) {
212         _transfer(sender, recipient, amount);
213 
214         uint256 currentAllowance = _allowances[sender][_msgSender()];
215         require(
216             currentAllowance >= amount,
217             "ERC20: transfer amount exceeds allowance"
218         );
219         _approve(sender, _msgSender(), currentAllowance - amount);
220 
221         return true;
222     }
223 
224     /**
225      * @dev Atomically increases the allowance granted to `spender` by the caller.
226      *
227      * This is an alternative to {approve} that can be used as a mitigation for
228      * problems described in {IERC20-approve}.
229      *
230      * Emits an {Approval} event indicating the updated allowance.
231      *
232      * Requirements:
233      *
234      * - `spender` cannot be the zero address.
235      */
236     function increaseAllowance(address spender, uint256 addedValue)
237         public
238         virtual
239         returns (bool)
240     {
241         _approve(
242             _msgSender(),
243             spender,
244             _allowances[_msgSender()][spender] + addedValue
245         );
246         return true;
247     }
248 
249     /**
250      * @dev Atomically decreases the allowance granted to `spender` by the caller.
251      *
252      * This is an alternative to {approve} that can be used as a mitigation for
253      * problems described in {IERC20-approve}.
254      *
255      * Emits an {Approval} event indicating the updated allowance.
256      *
257      * Requirements:
258      *
259      * - `spender` cannot be the zero address.
260      * - `spender` must have allowance for the caller of at least
261      * `subtractedValue`.
262      */
263     function decreaseAllowance(address spender, uint256 subtractedValue)
264         public
265         virtual
266         returns (bool)
267     {
268         uint256 currentAllowance = _allowances[_msgSender()][spender];
269         require(
270             currentAllowance >= subtractedValue,
271             "ERC20: decreased allowance below zero"
272         );
273         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
274 
275         return true;
276     }
277 
278     /**
279      * @dev Moves tokens `amount` from `sender` to `recipient`.
280      *
281      * This is internal function is equivalent to {transfer}, and can be used to
282      * e.g. implement automatic token fees, slashing mechanisms, etc.
283      *
284      * Emits a {Transfer} event.
285      *
286      * Requirements:
287      *
288      * - `sender` cannot be the zero address.
289      * - `recipient` cannot be the zero address.
290      * - `sender` must have a balance of at least `amount`.
291      */
292     function _transfer(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) internal virtual {
297         require(sender != address(0), "ERC20: transfer from the zero address");
298         require(recipient != address(0), "ERC20: transfer to the zero address");
299 
300         uint256 senderBalance = _balances[sender];
301         require(
302             senderBalance >= amount,
303             "ERC20: transfer amount exceeds balance"
304         );
305         _balances[sender] = senderBalance - amount;
306         _balances[recipient] += amount;
307 
308         emit Transfer(sender, recipient, amount);
309     }
310 
311     /** This function will be used to generate the total supply
312      * while deploying the contract
313      *
314      * This function can never be called again after deploying contract
315      */
316     function _tokengeneration(address account, uint256 amount)
317         internal
318         virtual
319     {
320         _totalSupply = amount;
321         _balances[account] = amount;
322         emit Transfer(address(0), account, amount);
323     }
324 
325     /**
326      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
327      *
328      * This internal function is equivalent to `approve`, and can be used to
329      * e.g. set automatic allowances for certain subsystems, etc.
330      *
331      * Emits an {Approval} event.
332      *
333      * Requirements:
334      *
335      * - `owner` cannot be the zero address.
336      * - `spender` cannot be the zero address.
337      */
338     function _approve(
339         address owner,
340         address spender,
341         uint256 amount
342     ) internal virtual {
343         require(owner != address(0), "ERC20: approve from the zero address");
344         require(spender != address(0), "ERC20: approve to the zero address");
345 
346         _allowances[owner][spender] = amount;
347         emit Approval(owner, spender, amount);
348     }
349 }
350 
351 library Address {
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(
354             address(this).balance >= amount,
355             "Address: insufficient balance"
356         );
357 
358         (bool success, ) = recipient.call{value: amount}("");
359         require(
360             success,
361             "Address: unable to send value, recipient may have reverted"
362         );
363     }
364 }
365 
366 abstract contract Ownable is Context {
367     address private _owner;
368 
369     event OwnershipTransferred(
370         address indexed previousOwner,
371         address indexed newOwner
372     );
373 
374     constructor() {
375         _setOwner(_msgSender());
376     }
377 
378     function owner() public view virtual returns (address) {
379         return _owner;
380     }
381 
382     modifier onlyOwner() {
383         require(owner() == _msgSender(), "Ownable: caller is not the owner");
384         _;
385     }
386 
387     function renounceOwnership() public virtual onlyOwner {
388         _setOwner(address(0));
389     }
390 
391     function transferOwnership(address newOwner) public virtual onlyOwner {
392         require(
393             newOwner != address(0),
394             "Ownable: new owner is the zero address"
395         );
396         _setOwner(newOwner);
397     }
398 
399     function _setOwner(address newOwner) private {
400         address oldOwner = _owner;
401         _owner = newOwner;
402         emit OwnershipTransferred(oldOwner, newOwner);
403     }
404 }
405 
406 interface IFactory {
407     function createPair(address tokenA, address tokenB)
408         external
409         returns (address pair);
410 }
411 
412 interface IRouter {
413     function factory() external pure returns (address);
414 
415     function WETH() external pure returns (address);
416 
417     function addLiquidityETH(
418         address token,
419         uint256 amountTokenDesired,
420         uint256 amountTokenMin,
421         uint256 amountETHMin,
422         address to,
423         uint256 deadline
424     )
425         external
426         payable
427         returns (
428             uint256 amountToken,
429             uint256 amountETH,
430             uint256 liquidity
431         );
432 
433     function swapExactTokensForETHSupportingFeeOnTransferTokens(
434         uint256 amountIn,
435         uint256 amountOutMin,
436         address[] calldata path,
437         address to,
438         uint256 deadline
439     ) external;
440 }
441 
442  contract TRACKER is ERC20, Ownable {
443     using Address for address payable;
444 
445     IRouter public router;
446     address public pair;
447 
448     bool private _interlock = false;
449     bool private providingLiquidity = true;
450     bool public tradingEnabled = false;
451 
452     uint256 private maxThreshold = 10000 * 10**18; // 1%
453     uint256 private minThrehold = 100 * 10**18; // 0.01%
454     
455     uint256 public MaxTxAmount = 30000 * 10**18; // 3%
456     uint256 public MaxWalletSize = 30000 * 10**18; // 3%
457     
458     address public marketingWallet = 0x3791ceF692803d5D56ad7FB657c75e4f2973BFe1;
459     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
460 
461     struct Taxes {
462         uint256 marketing;
463         uint256 liquidity;
464     }
465 
466     Taxes private taxes = Taxes(25, 0);
467     Taxes private sellTaxes = Taxes(50, 0);
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
487     constructor() ERC20("Tracker", "TRACKER") {
488         _tokengeneration(msg.sender, 1000000 * 10**decimals());
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
619         if (contractBalance >= minThrehold) {
620             if (contractBalance > maxThreshold) {
621             }
622 
623             // Split the contract balance into halves
624             uint256 denominator = feeswap * 2;
625             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) / denominator;
626             uint256 initialBalance = address(this).balance;
627 
628             swapTokensForETH(contractBalance);
629 
630             uint256 deltaBalance = address(this).balance - initialBalance;
631             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
632             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
633 
634             if (ethToAddLiquidityWith > 0) {
635                 // Add liquidity to pancake
636                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
637             }
638 
639             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
640             if (marketingAmt > 0) {
641                 payable(marketingWallet).sendValue(marketingAmt);
642             }
643         }
644     }
645 
646     function swapTokensForETH(uint256 tokenAmount) private {
647         address[] memory path = new address[](2);
648         path[0] = address(this);
649         path[1] = router.WETH();
650 
651         _approve(address(this), address(router), tokenAmount);
652 
653         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
654             tokenAmount,
655             0,
656             path,
657             address(this),
658             block.timestamp
659         );
660     }
661 
662     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
663         _approve(address(this), address(router), tokenAmount);
664 
665         // add the liquidity
666         router.addLiquidityETH{value: ethAmount}(
667             address(this),
668             tokenAmount,
669             0, // slippage is unavoidable
670             0, // slippage is unavoidable
671             deadWallet,
672             block.timestamp
673         );
674     }
675 
676     function updateLiquidityProvide(bool state) external onlyOwner {
677         providingLiquidity = state;
678     }
679 
680    
681     function UpdateTreshhold(uint256 max_amount, uint256 min_amount) external onlyOwner {
682         require(max_amount <= 10000, "must keep max Threshold at 1% or less" );
683         require(min_amount >= 100, "min Threshold must be greater than or equal to 0.01%");
684         maxThreshold = max_amount * 10**decimals();
685         minThrehold = min_amount * 10**decimals();
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
703     require (_maxWallet >= 1000, "Cannot set MaxWallet amount lower then 0.1%");
704     require (_maxTx >= 1000, "Cannot set MaxTx amount lower then 0.1%");
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