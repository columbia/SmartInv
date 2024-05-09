1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-16
3 */
4 
5 //SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.17;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 interface IERC20Metadata is IERC20 {
43     /**
44      * @dev Returns the name of the token.
45      */
46     function name() external view returns (string memory);
47 
48     /**
49      * @dev Returns the symbol of the token.
50      */
51     function symbol() external view returns (string memory);
52 
53     /**
54      * @dev Returns the decimals places of the token.
55      */
56     function decimals() external view returns (uint8);
57 }
58 
59 contract ERC20 is Context, IERC20, IERC20Metadata {
60     mapping(address => uint256) internal _balances;
61 
62     mapping(address => mapping(address => uint256)) internal _allowances;
63 
64     uint256 private _totalSupply;
65 
66     string private _name;
67     string private _symbol;
68 
69     /**
70      * @dev Sets the values for {name} and {symbol}.
71      *
72      * The defaut value of {decimals} is 18. To select a different value for
73      * {decimals} you should overload it.
74      *
75      * All two of these values are immutable: they can only be set once during
76      * construction.
77      */
78     constructor(string memory name_, string memory symbol_) {
79         _name = name_;
80         _symbol = symbol_;
81     }
82 
83     /**
84      * @dev Returns the name of the token.
85      */
86     function name() public view virtual override returns (string memory) {
87         return _name;
88     }
89 
90     /**
91      * @dev Returns the symbol of the token, usually a shorter version of the
92      * name.
93      */
94     function symbol() public view virtual override returns (string memory) {
95         return _symbol;
96     }
97 
98     /**
99      * @dev Returns the number of decimals used to get its user representation.
100      * For example, if `decimals` equals `2`, a balance of `505` tokens should
101      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
102      *
103      * Tokens usually opt for a value of 18, imitating the relationship between
104      * Ether and Wei. This is the value {ERC20} uses, unless this function is
105      * overridden;
106      *
107      * NOTE: This information is only used for _display_ purposes: it in
108      * no way affects any of the arithmetic of the contract, including
109      * {IERC20-balanceOf} and {IERC20-transfer}.
110      */
111     function decimals() public view virtual override returns (uint8) {
112         return 18;
113     }
114 
115     /**
116      * @dev See {IERC20-totalSupply}.
117      */
118     function totalSupply() public view virtual override returns (uint256) {
119         return _totalSupply;
120     }
121 
122     /**
123      * @dev See {IERC20-balanceOf}.
124      */
125     function balanceOf(address account) public view virtual override returns (uint256) {
126         return _balances[account];
127     }
128 
129     /**
130      * @dev See {IERC20-transfer}.
131      *
132      * Requirements:
133      *
134      * - `recipient` cannot be the zero address.
135      * - the caller must have a balance of at least `amount`.
136      */
137     function transfer(address recipient, uint256 amount)
138         public
139         virtual
140         override
141         returns (bool)
142     {
143         _transfer(_msgSender(), recipient, amount);
144         return true;
145     }
146 
147     /**
148      * @dev See {IERC20-allowance}.
149      */
150     function allowance(address owner, address spender)
151         public
152         view
153         virtual
154         override
155         returns (uint256)
156     {
157         return _allowances[owner][spender];
158     }
159 
160     /**
161      * @dev See {IERC20-approve}.
162      *
163      * Requirements:
164      *
165      * - `spender` cannot be the zero address.
166      */
167     function approve(address spender, uint256 amount) public virtual override returns (bool) {
168         _approve(_msgSender(), spender, amount);
169         return true;
170     }
171 
172     /**
173      * @dev See {IERC20-transferFrom}.
174      *
175      * Emits an {Approval} event indicating the updated allowance. This is not
176      * required by the EIP. See the note at the beginning of {ERC20}.
177      *
178      * Requirements:
179      *
180      * - `sender` and `recipient` cannot be the zero address.
181      * - `sender` must have a balance of at least `amount`.
182      * - the caller must have allowance for ``sender``'s tokens of at least
183      * `amount`.
184      */
185     function transferFrom(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) public virtual override returns (bool) {
190         _transfer(sender, recipient, amount);
191 
192         uint256 currentAllowance = _allowances[sender][_msgSender()];
193         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
194         _approve(sender, _msgSender(), currentAllowance - amount);
195 
196         return true;
197     }
198 
199     /**
200      * @dev Atomically increases the allowance granted to `spender` by the caller.
201      *
202      * This is an alternative to {approve} that can be used as a mitigation for
203      * problems described in {IERC20-approve}.
204      *
205      * Emits an {Approval} event indicating the updated allowance.
206      *
207      * Requirements:
208      *
209      * - `spender` cannot be the zero address.
210      */
211     function increaseAllowance(address spender, uint256 addedValue)
212         public
213         virtual
214         returns (bool)
215     {
216         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
217         return true;
218     }
219 
220     /**
221      * @dev Atomically decreases the allowance granted to `spender` by the caller.
222      *
223      * This is an alternative to {approve} that can be used as a mitigation for
224      * problems described in {IERC20-approve}.
225      *
226      * Emits an {Approval} event indicating the updated allowance.
227      *
228      * Requirements:
229      *
230      * - `spender` cannot be the zero address.
231      * - `spender` must have allowance for the caller of at least
232      * `subtractedValue`.
233      */
234     function decreaseAllowance(address spender, uint256 subtractedValue)
235         public
236         virtual
237         returns (bool)
238     {
239         uint256 currentAllowance = _allowances[_msgSender()][spender];
240         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
241         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
242 
243         return true;
244     }
245 
246     /**
247      * @dev Moves tokens `amount` from `sender` to `recipient`.
248      *
249      * This is internal function is equivalent to {transfer}, and can be used to
250      * e.g. implement automatic token fees, slashing mechanisms, etc.
251      *
252      * Emits a {Transfer} event.
253      *
254      * Requirements:
255      *
256      * - `sender` cannot be the zero address.
257      * - `recipient` cannot be the zero address.
258      * - `sender` must have a balance of at least `amount`.
259      */
260     function _transfer(
261         address sender,
262         address recipient,
263         uint256 amount
264     ) internal virtual {
265         require(sender != address(0), "ERC20: transfer from the zero address");
266         require(recipient != address(0), "ERC20: transfer to the zero address");
267 
268         uint256 senderBalance = _balances[sender];
269         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
270         _balances[sender] = senderBalance - amount;
271         _balances[recipient] += amount;
272 
273         emit Transfer(sender, recipient, amount);
274     }
275 
276     /** This function will be used to generate the total supply
277     * while deploying the contract
278     *
279     * This function can never be called again after deploying contract
280     */
281     function _tokengeneration(address account, uint256 amount) internal virtual {
282         _totalSupply = amount;
283         _balances[account] = amount;
284         emit Transfer(address(0), account, amount);
285     }
286 
287     /**
288      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
289      *
290      * This internal function is equivalent to `approve`, and can be used to
291      * e.g. set automatic allowances for certain subsystems, etc.
292      *
293      * Emits an {Approval} event.
294      *
295      * Requirements:
296      *
297      * - `owner` cannot be the zero address.
298      * - `spender` cannot be the zero address.
299      */
300     function _approve(
301         address owner,
302         address spender,
303         uint256 amount
304     ) internal virtual {
305         require(owner != address(0), "ERC20: approve from the zero address");
306         require(spender != address(0), "ERC20: approve to the zero address");
307 
308         _allowances[owner][spender] = amount;
309         emit Approval(owner, spender, amount);
310     }
311 }
312 
313 library Address {
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 }
321 
322 abstract contract Ownable is Context {
323     address private _owner;
324 
325     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
326 
327     constructor() {
328         _setOwner(_msgSender());
329     }
330 
331     function owner() public view virtual returns (address) {
332         return _owner;
333     }
334 
335     modifier onlyOwner() {
336         require(owner() == _msgSender(), "Ownable: caller is not the owner");
337         _;
338     }
339 
340     function renounceOwnership() public virtual onlyOwner {
341         _setOwner(address(0));
342     }
343 
344     function transferOwnership(address newOwner) public virtual onlyOwner {
345         require(newOwner != address(0), "Ownable: new owner is the zero address");
346         _setOwner(newOwner);
347     }
348 
349     function _setOwner(address newOwner) private {
350         address oldOwner = _owner;
351         _owner = newOwner;
352         emit OwnershipTransferred(oldOwner, newOwner);
353     }
354 }
355 
356 interface IFactory {
357     function createPair(address tokenA, address tokenB) external returns (address pair);
358 }
359 
360 interface IRouter {
361     function factory() external pure returns (address);
362 
363     function WETH() external pure returns (address);
364 
365     function addLiquidityETH(
366         address token,
367         uint256 amountTokenDesired,
368         uint256 amountTokenMin,
369         uint256 amountETHMin,
370         address to,
371         uint256 deadline
372     )
373         external
374         payable
375         returns (
376             uint256 amountToken,
377             uint256 amountETH,
378             uint256 liquidity
379         );
380 
381     function swapExactTokensForETHSupportingFeeOnTransferTokens(
382         uint256 amountIn,
383         uint256 amountOutMin,
384         address[] calldata path,
385         address to,
386         uint256 deadline
387     ) external;
388 }
389 
390 interface referralLogic {
391     function referralBuy(address _buyer, uint256 _amount) external;
392 }
393 
394 contract ChookyInu is ERC20, Ownable {
395     using Address for address payable;
396 
397     IRouter public router;
398     address public pair;
399     address public referralContract;
400 
401     bool private _interlock = false;
402     bool public providingLiquidity = false;
403     bool public tradingEnabled = false;
404 
405     uint256 public tokenLiquidityThreshold = 21_000 * 10**18;
406     uint256 public maxBuyLimit = 210_000 * 10**18;
407     uint256 public maxSellLimit = 210_000 * 10**18;
408     uint256 public maxWalletLimit = 210_000 * 10**18;
409 
410     uint256 public genesis_block;
411 
412     address public marketingWallet = 0xb172C5bF1c12B0ecDFb04192C40095a095cdEf43;
413 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
414 
415     struct Taxes {
416         uint256 marketing;
417         uint256 liquidity;
418         uint256 burn;
419     }
420 
421     Taxes public taxes = Taxes(4, 0, 0);
422     Taxes public sellTaxes = Taxes(8, 0, 0);
423     Taxes public transferTaxes = Taxes(0, 0, 0);
424 
425     mapping(address => bool) public exemptFee;
426 
427     bool public referralActive = false;
428 
429     modifier lockTheSwap() {
430         if (!_interlock) {
431             _interlock = true;
432             _;
433             _interlock = false;
434         }
435     }
436 
437     constructor() ERC20("Chooky Inu", "$CHOO") {
438         _tokengeneration(msg.sender, 21_000_000 * 10**decimals());
439         exemptFee[msg.sender] = true;
440 
441         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
442         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
443 
444         router = _router;
445         pair = _pair;
446         exemptFee[address(this)] = true;
447         exemptFee[marketingWallet] = true;
448         exemptFee[deadWallet] = true;
449 
450     }
451 
452     function approve(address spender, uint256 amount) public override returns (bool) {
453         _approve(_msgSender(), spender, amount);
454         return true;
455     }
456 
457     function transferFrom(
458         address sender,
459         address recipient,
460         uint256 amount
461     ) public override returns (bool) {
462         _transfer(sender, recipient, amount);
463 
464         uint256 currentAllowance = _allowances[sender][_msgSender()];
465         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
466         _approve(sender, _msgSender(), currentAllowance - amount);
467 
468         return true;
469     }
470 
471     function increaseAllowance(address spender, uint256 addedValue)
472         public
473         override
474         returns (bool)
475     {
476         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
477         return true;
478     }
479 
480     function decreaseAllowance(address spender, uint256 subtractedValue)
481         public
482         override
483         returns (bool)
484     {
485         uint256 currentAllowance = _allowances[_msgSender()][spender];
486         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
487         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
488 
489         return true;
490     }
491 
492     function transfer(address recipient, uint256 amount) public override returns (bool) {
493         _transfer(msg.sender, recipient, amount);
494         return true;
495     }
496 
497     function _transfer(
498         address sender,
499         address recipient,
500         uint256 amount
501     ) internal override {
502         require(amount > 0, "Transfer amount must be greater than zero");
503 
504         if (!exemptFee[sender] && !exemptFee[recipient]) {
505             require(tradingEnabled, "Trading not enabled");
506         }
507 
508         if (sender == pair && !exemptFee[recipient] && !_interlock) {
509             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
510             require(
511                 balanceOf(recipient) + amount <= maxWalletLimit,
512                 "You are exceeding maxWalletLimit"
513             );
514         }
515 
516         if (
517             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_interlock
518         ) {
519             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
520             if (recipient != pair) {
521                 require(
522                     balanceOf(recipient) + amount <= maxWalletLimit,
523                     "You are exceeding maxWalletLimit"
524                 );
525             }
526         }
527 
528         
529         //Referral logic
530         if(sender == pair && referralActive) {
531             referralLogic(referralContract).referralBuy(recipient, amount);
532         }
533 
534         uint256 feeswap;
535         uint256 feesum;
536         uint256 fee;
537         Taxes memory currentTaxes;
538 
539         //set fee to zero if fees in contract are handled or exempted
540         if (_interlock || exemptFee[sender] || exemptFee[recipient])
541             fee = 0;
542 
543             //calculate fee
544         else if (recipient == pair) {
545             feeswap =
546                 sellTaxes.liquidity +
547                 sellTaxes.marketing +
548                 sellTaxes.burn;
549             feesum = feeswap;
550             currentTaxes = sellTaxes;
551         } else if (sender == pair) {
552             feeswap =
553                 taxes.liquidity +
554                 taxes.marketing +
555                 taxes.burn ;
556             feesum = feeswap;
557             currentTaxes = taxes;
558         } else {
559             feeswap =
560                 transferTaxes.liquidity +
561                 transferTaxes.marketing +
562                 transferTaxes.burn ;
563             feesum = feeswap;
564             currentTaxes = transferTaxes;
565         }
566 
567         fee = (amount * feesum) / 100;
568 
569         //send fees if threshold has been reached
570         //don't do this on buys, breaks swap
571         if (providingLiquidity && sender != pair) Liquify(feeswap, currentTaxes);
572 
573         //rest to recipient
574         super._transfer(sender, recipient, amount - fee);
575         if (fee > 0) {
576             //send the fee to the contract
577             if (feeswap > 0) {
578                 uint256 burnAmount = (amount * currentTaxes.burn) / 100;
579                 uint256 feeAmount = (amount * feeswap) / 100 - burnAmount;
580                 super._transfer(sender, address(this), feeAmount);
581                 super._transfer(sender, deadWallet, burnAmount);
582             }
583 
584         }
585     }
586 
587     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
588 
589         if(feeswap == 0){
590             return;
591         }
592 
593         uint256 contractBalance = balanceOf(address(this));
594         if (contractBalance >= tokenLiquidityThreshold) {
595             if (tokenLiquidityThreshold > 1) {
596                 contractBalance = tokenLiquidityThreshold;
597             }
598 
599             // Split the contract balance into halves
600             uint256 denominator = feeswap * 2;
601             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
602                 denominator;
603             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
604 
605             uint256 initialBalance = address(this).balance;
606 
607             swapTokensForETH(toSwap);
608 
609             uint256 deltaBalance = address(this).balance - initialBalance;
610             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
611             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
612 
613             if (ethToAddLiquidityWith > 0) {
614                 // Add liquidity to pancake
615                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
616             }
617 
618             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
619             if (marketingAmt > 0) {
620                 payable(marketingWallet).sendValue(marketingAmt);
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
666         require(new_amount <= 420_000 && new_amount > 0, "Swap threshold amount should be lower or euqal to 1% of tokens");
667         tokenLiquidityThreshold = new_amount * 10**decimals();
668     }
669 
670     function SetBuyTaxes(
671         uint256 _marketing,
672         uint256 _liquidity,
673         uint256 _burn
674     ) external onlyOwner {
675         taxes = Taxes(_marketing, _liquidity,  _burn);
676         require((_marketing + _liquidity +  _burn) <= 12, "Must keep fees at 12% or less");
677     }
678 
679     function SetSellTaxes(
680         uint256 _marketing,
681         uint256 _liquidity,
682         uint256 _burn
683     ) external onlyOwner {
684         sellTaxes = Taxes(_marketing, _liquidity,  _burn);
685         require((_marketing + _liquidity + _burn) <= 12, "Must keep fees at 12% or less");
686     }
687 
688     function SetTransferTaxes(
689         uint256 _marketing,
690         uint256 _liquidity,
691         uint256 _burn
692     ) external onlyOwner {
693         transferTaxes = Taxes(_marketing, _liquidity,  _burn);
694         require((_marketing + _liquidity + _burn) <= 12, "Must keep fees at 12% or less");
695     }
696 
697     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
698         router = IRouter(newRouter);
699         pair = newPair;
700     }
701 
702     function updateReferralContract(address _newReferralContract) external onlyOwner {
703         require(_newReferralContract != address(0),"Fee Address cannot be zero address");
704         referralContract = _newReferralContract;
705     }
706 
707     function toggleReferral(bool status) external onlyOwner{
708         referralActive = status;
709     }
710 
711     function _openTrading() external onlyOwner {
712         require(!tradingEnabled, "Cannot re-enable trading");
713         tradingEnabled = true;
714         providingLiquidity = true;
715         genesis_block = block.number;
716     }
717 
718     function _toggleTrading(bool status) external onlyOwner {
719         tradingEnabled = status;
720     }
721 
722     function updateMarketingWallet(address newWallet) external onlyOwner {
723         require(newWallet != address(0),"Fee Address cannot be zero address");
724         marketingWallet = newWallet;
725     }
726 
727     function updateExemptFee(address _address, bool state) external onlyOwner {
728         exemptFee[_address] = state;
729     }
730 
731     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
732         for (uint256 i = 0; i < accounts.length; i++) {
733             exemptFee[accounts[i]] = state;
734         }
735     }
736 
737     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell, uint256 maxWallet) external onlyOwner {
738         require(maxBuy >= 21_000, "Cannot set max buy amount lower than 0.1%");
739         require(maxSell >= 21_000, "Cannot set max sell amount lower than 0.1%");
740         require(maxWallet >= 210_000, "Cannot set max wallet amount lower than 1%");
741         maxBuyLimit = maxBuy * 10**decimals();
742         maxSellLimit = maxSell * 10**decimals();
743         maxWalletLimit = maxWallet * 10**decimals(); 
744     }
745 
746     function rescueBNB(uint256 weiAmount) external onlyOwner {
747         payable(owner()).transfer(weiAmount);
748     }
749 
750     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
751         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
752         IERC20(tokenAdd).transfer(owner(), amount);
753     }
754 
755     // fallbacks
756     receive() external payable {}
757 }