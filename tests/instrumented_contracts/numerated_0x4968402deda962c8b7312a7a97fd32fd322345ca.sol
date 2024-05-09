1 //SPDX-License-Identifier: MIT
2 
3 /**
4 Telegram: https://t.me/hpos10i20
5 Website: hpos10i20.com 
6 Twitter: https://twitter.com/hpos10i20
7 
8 */
9 pragma solidity ^0.8.19;
10 
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
62 contract ERC20 is Context, IERC20, IERC20Metadata {
63     mapping(address => uint256) internal _balances;
64 
65     mapping(address => mapping(address => uint256)) internal _allowances;
66 
67     uint256 private _totalSupply;
68 
69     string private _name;
70     string private _symbol;
71 
72     /**
73      * @dev Sets the values for {name} and {symbol}.
74      *
75      * The defaut value of {decimals} is 18. To select a different value for
76      * {decimals} you should overload it.
77      *
78      * All two of these values are immutable: they can only be set once during
79      * construction.
80      */
81     constructor(string memory name_, string memory symbol_) {
82         _name = name_;
83         _symbol = symbol_;
84     }
85 
86     /**
87      * @dev Returns the name of the token.
88      */
89     function name() public view virtual override returns (string memory) {
90         return _name;
91     }
92 
93     /**
94      * @dev Returns the symbol of the token, usually a shorter version of the
95      * name.
96      */
97     function symbol() public view virtual override returns (string memory) {
98         return _symbol;
99     }
100 
101     /**
102      * @dev Returns the number of decimals used to get its user representation.
103      * For example, if `decimals` equals `2`, a balance of `505` tokens should
104      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
105      *
106      * Tokens usually opt for a value of 18, imitating the relationship between
107      * Ether and Wei. This is the value {ERC20} uses, unless this function is
108      * overridden;
109      *
110      * NOTE: This information is only used for _display_ purposes: it in
111      * no way affects any of the arithmetic of the contract, including
112      * {IERC20-balanceOf} and {IERC20-transfer}.
113      */
114     function decimals() public view virtual override returns (uint8) {
115         return 18;
116     }
117 
118     /**
119      * @dev See {IERC20-totalSupply}.
120      */
121     function totalSupply() public view virtual override returns (uint256) {
122         return _totalSupply;
123     }
124 
125     /**
126      * @dev See {IERC20-balanceOf}.
127      */
128     function balanceOf(address account) public view virtual override returns (uint256) {
129         return _balances[account];
130     }
131 
132     /**
133      * @dev See {IERC20-transfer}.
134      *
135      * Requirements:
136      *
137      * - `recipient` cannot be the zero address.
138      * - the caller must have a balance of at least `amount`.
139      */
140     function transfer(address recipient, uint256 amount)
141         public
142         virtual
143         override
144         returns (bool)
145     {
146         _transfer(_msgSender(), recipient, amount);
147         return true;
148     }
149 
150     /**
151      * @dev See {IERC20-allowance}.
152      */
153     function allowance(address owner, address spender)
154         public
155         view
156         virtual
157         override
158         returns (uint256)
159     {
160         return _allowances[owner][spender];
161     }
162 
163     /**
164      * @dev See {IERC20-approve}.
165      *
166      * Requirements:
167      *
168      * - `spender` cannot be the zero address.
169      */
170     function approve(address spender, uint256 amount) public virtual override returns (bool) {
171         _approve(_msgSender(), spender, amount);
172         return true;
173     }
174 
175     /**
176      * @dev See {IERC20-transferFrom}.
177      *
178      * Emits an {Approval} event indicating the updated allowance. This is not
179      * required by the EIP. See the note at the beginning of {ERC20}.
180      *
181      * Requirements:
182      *
183      * - `sender` and `recipient` cannot be the zero address.
184      * - `sender` must have a balance of at least `amount`.
185      * - the caller must have allowance for ``sender``'s tokens of at least
186      * `amount`.
187      */
188     function transferFrom(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) public virtual override returns (bool) {
193         _transfer(sender, recipient, amount);
194 
195         uint256 currentAllowance = _allowances[sender][_msgSender()];
196         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
197         _approve(sender, _msgSender(), currentAllowance - amount);
198 
199         return true;
200     }
201 
202     /**
203      * @dev Atomically increases the allowance granted to `spender` by the caller.
204      *
205      * This is an alternative to {approve} that can be used as a mitigation for
206      * problems described in {IERC20-approve}.
207      *
208      * Emits an {Approval} event indicating the updated allowance.
209      *
210      * Requirements:
211      *
212      * - `spender` cannot be the zero address.
213      */
214     function increaseAllowance(address spender, uint256 addedValue)
215         public
216         virtual
217         returns (bool)
218     {
219         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
220         return true;
221     }
222 
223     /**
224      * @dev Atomically decreases the allowance granted to `spender` by the caller.
225      *
226      * This is an alternative to {approve} that can be used as a mitigation for
227      * problems described in {IERC20-approve}.
228      *
229      * Emits an {Approval} event indicating the updated allowance.
230      *
231      * Requirements:
232      *
233      * - `spender` cannot be the zero address.
234      * - `spender` must have allowance for the caller of at least
235      * `subtractedValue`.
236      */
237     function decreaseAllowance(address spender, uint256 subtractedValue)
238         public
239         virtual
240         returns (bool)
241     {
242         uint256 currentAllowance = _allowances[_msgSender()][spender];
243         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
244         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
245 
246         return true;
247     }
248 
249     /**
250      * @dev Moves tokens `amount` from `sender` to `recipient`.
251      *
252      * This is internal function is equivalent to {transfer}, and can be used to
253      * e.g. implement automatic token fees, slashing mechanisms, etc.
254      *
255      * Emits a {Transfer} event.
256      *
257      * Requirements:
258      *
259      * - `sender` cannot be the zero address.
260      * - `recipient` cannot be the zero address.
261      * - `sender` must have a balance of at least `amount`.
262      */
263     function _transfer(
264         address sender,
265         address recipient,
266         uint256 amount
267     ) internal virtual {
268         require(sender != address(0), "ERC20: transfer from the zero address");
269         require(recipient != address(0), "ERC20: transfer to the zero address");
270 
271         _beforeTokenTransfer(sender, recipient, amount);
272 
273         uint256 senderBalance = _balances[sender];
274         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
275         _balances[sender] = senderBalance - amount;
276         _balances[recipient] += amount;
277 
278         emit Transfer(sender, recipient, amount);
279     }
280 
281     /** This function will be used to generate the total supply
282     * while deploying the contract
283     *
284     * This function can never be called again after deploying contract
285     */
286     function _tokengeneration(address account, uint256 amount) internal virtual {
287         require(account != address(0), "ERC20: generation to the zero address");
288 
289         _beforeTokenTransfer(address(0), account, amount);
290 
291         _totalSupply = amount;
292         _balances[account] = amount;
293         emit Transfer(address(0), account, amount);
294     }
295 
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
298      *
299      * This internal function is equivalent to `approve`, and can be used to
300      * e.g. set automatic allowances for certain subsystems, etc.
301      *
302      * Emits an {Approval} event.
303      *
304      * Requirements:
305      *
306      * - `owner` cannot be the zero address.
307      * - `spender` cannot be the zero address.
308      */
309     function _approve(
310         address owner,
311         address spender,
312         uint256 amount
313     ) internal virtual {
314         require(owner != address(0), "ERC20: approve from the zero address");
315         require(spender != address(0), "ERC20: approve to the zero address");
316 
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320 
321     /**
322      * @dev Hook that is called before any transfer of tokens. This includes
323      * generation and burning.
324      *
325      * Calling conditions:
326      *
327      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
328      * will be to transferred to `to`.
329      * - when `from` is zero, `amount` tokens will be generated for `to`.
330      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
331      * - `from` and `to` are never both zero.
332      *
333      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
334      */
335     function _beforeTokenTransfer(
336         address from,
337         address to,
338         uint256 amount
339     ) internal virtual {}
340 }
341 
342 library Address {
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(address(this).balance >= amount, "Address: insufficient balance");
345 
346         (bool success, ) = recipient.call{ value: amount }("");
347         require(success, "Address: unable to send value, recipient may have reverted");
348     }
349 }
350 
351 abstract contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     constructor() {
357         _setOwner(_msgSender());
358     }
359 
360     function owner() public view virtual returns (address) {
361         return _owner;
362     }
363 
364     modifier onlyOwner() {
365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     function renounceOwnership() public virtual onlyOwner {
370         _setOwner(address(0));
371     }
372 
373     function transferOwnership(address newOwner) public virtual onlyOwner {
374         require(newOwner != address(0), "Ownable: new owner is the zero address");
375         _setOwner(newOwner);
376     }
377 
378     function _setOwner(address newOwner) private {
379         address oldOwner = _owner;
380         _owner = newOwner;
381         emit OwnershipTransferred(oldOwner, newOwner);
382     }
383 }
384 
385 interface IFactory {
386     function createPair(address tokenA, address tokenB) external returns (address pair);
387 }
388 
389 interface IRouter {
390     function factory() external pure returns (address);
391 
392     function WETH() external pure returns (address);
393 
394     function addLiquidityETH(
395         address token,
396         uint256 amountTokenDesired,
397         uint256 amountTokenMin,
398         uint256 amountETHMin,
399         address to,
400         uint256 deadline
401     )
402         external
403         payable
404         returns (
405             uint256 amountToken,
406             uint256 amountETH,
407             uint256 liquidity
408         );
409 
410     function swapExactTokensForETHSupportingFeeOnTransferTokens(
411         uint256 amountIn,
412         uint256 amountOutMin,
413         address[] calldata path,
414         address to,
415         uint256 deadline
416     ) external;
417 }
418 
419 contract HarryPotterObamaSonic10Inu is ERC20, Ownable {
420     using Address for address payable;
421 
422     IRouter public router;
423     address public pair;
424 
425     bool private _liquidityMutex = false;
426     bool private  providingLiquidity = false;
427     bool public tradingEnabled = false;
428 
429     uint256 private tokenLiquidityThreshold = 5000000 * 10**18; //0.5%
430     uint256 public maxWalletLimit = 20000000 * 10**18; //2%
431 
432     uint256 private  genesis_block;
433     uint256 private deadline = 2;
434     uint256 private launchtax = 99;
435 
436     address private  marketingWallet =0x4815C79a1f9634257f33099333c110bddcD742e4;
437     address private devWallet =0x4815C79a1f9634257f33099333c110bddcD742e4;
438     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
439 
440     struct Taxes {
441         uint256 marketing;
442         uint256 liquidity;
443         uint256 dev;   
444     }
445 
446     Taxes public taxes = Taxes(50, 1, 1);
447     Taxes public sellTaxes = Taxes(49, 1, 1);
448 
449     mapping(address => bool) public exemptFee;
450     mapping(address => bool) private isearlybuyer;
451 
452 
453     modifier mutexLock() {
454         if (!_liquidityMutex) {
455             _liquidityMutex = true;
456             _;
457             _liquidityMutex = false;
458         }
459     }
460 
461     constructor() ERC20("HarryPotterObamaSonic10Inu", "BITCOIN2.0") {
462         _tokengeneration(msg.sender, 1000000000 * 10**decimals());
463 
464         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
465         // Create a pair for this new token
466         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
467 
468         router = _router;
469         pair = _pair;
470         exemptFee[address(this)] = true;
471         exemptFee[msg.sender] = true;
472         exemptFee[marketingWallet] = true;
473         exemptFee[devWallet] = true;
474         exemptFee[deadWallet] = true;
475 
476     }
477 
478     function approve(address spender, uint256 amount) public override returns (bool) {
479         _approve(_msgSender(), spender, amount);
480         return true;
481     }
482 
483     function transferFrom(
484         address sender,
485         address recipient,
486         uint256 amount
487     ) public override returns (bool) {
488         _transfer(sender, recipient, amount);
489 
490         uint256 currentAllowance = _allowances[sender][_msgSender()];
491         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
492         _approve(sender, _msgSender(), currentAllowance - amount);
493 
494         return true;
495     }
496 
497     function increaseAllowance(address spender, uint256 addedValue)
498         public
499         override
500         returns (bool)
501     {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
503         return true;
504     }
505 
506     function decreaseAllowance(address spender, uint256 subtractedValue)
507         public
508         override
509         returns (bool)
510     {
511         uint256 currentAllowance = _allowances[_msgSender()][spender];
512         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
513         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
514 
515         return true;
516     }
517 
518     function transfer(address recipient, uint256 amount) public override returns (bool) {
519         _transfer(msg.sender, recipient, amount);
520         return true;
521     }
522 
523     function _transfer(
524         address sender,
525         address recipient,
526         uint256 amount
527     ) internal override {
528         require(amount > 0, "Transfer amount must be greater than zero");
529         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
530             "You can't transfer tokens"
531         );
532 
533         if (!exemptFee[sender] && !exemptFee[recipient]) {
534             require(tradingEnabled, "Trading not enabled");
535         }
536 
537         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
538             require(balanceOf(recipient) + amount <= maxWalletLimit,
539                 "You are exceeding maxWalletLimit"
540             );
541         }
542 
543         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
544            
545             if (recipient != pair) {
546                 require(balanceOf(recipient) + amount <= maxWalletLimit,
547                     "You are exceeding maxWalletLimit"
548                 );
549             }
550         }
551 
552         uint256 feeswap;
553         uint256 feesum;
554         uint256 fee;
555         Taxes memory currentTaxes;
556 
557         bool useLaunchFee = !exemptFee[sender] &&
558             !exemptFee[recipient] &&
559             block.number < genesis_block + deadline;
560 
561         //set fee to zero if fees in contract are handled or exempted
562         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
563             fee = 0;
564 
565             //calculate fee
566         else if (recipient == pair && !useLaunchFee) {
567             feeswap =
568                 sellTaxes.liquidity +
569                 sellTaxes.marketing +           
570                 sellTaxes.dev ;
571             feesum = feeswap;
572             currentTaxes = sellTaxes;
573         } else if (!useLaunchFee) {
574             feeswap =
575                 taxes.liquidity +
576                 taxes.marketing +
577                 taxes.dev ;
578             feesum = feeswap;
579             currentTaxes = taxes;
580         } else if (useLaunchFee) {
581             feeswap = launchtax;
582             feesum = launchtax;
583         }
584 
585         fee = (amount * feesum) / 100;
586 
587         //send fees if threshold has been reached
588         //don't do this on buys, breaks swap
589         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
590 
591         //rest to recipient
592         super._transfer(sender, recipient, amount - fee);
593         if (fee > 0) {
594             //send the fee to the contract
595             if (feeswap > 0) {
596                 uint256 feeAmount = (amount * feeswap) / 100;
597                 super._transfer(sender, address(this), feeAmount);
598             }
599 
600         }
601     }
602 
603     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
604 
605     if(feeswap == 0){
606             return;
607         }   
608 
609         uint256 contractBalance = balanceOf(address(this));
610         if (contractBalance >= tokenLiquidityThreshold) {
611             if (tokenLiquidityThreshold > 1) {
612                 contractBalance = tokenLiquidityThreshold;
613             }
614 
615             // Split the contract balance into halves
616             uint256 denominator = feeswap * 2;
617             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
618                 denominator;
619             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
620 
621             uint256 initialBalance = address(this).balance;
622 
623             swapTokensForETH(toSwap);
624 
625             uint256 deltaBalance = address(this).balance - initialBalance;
626             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
627             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
628 
629             if (ethToAddLiquidityWith > 0) {
630                 // Add liquidity
631                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
632             }
633 
634             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
635             if (marketingAmt > 0) {
636                 payable(marketingWallet).sendValue(marketingAmt);
637             }
638 
639             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
640             if (devAmt > 0) {
641                 payable(devWallet).sendValue(devAmt);
642             }
643 
644         }
645     }
646 
647     function swapTokensForETH(uint256 tokenAmount) private {
648         // generate the pair path of token -> weth
649         address[] memory path = new address[](2);
650         path[0] = address(this);
651         path[1] = router.WETH();
652 
653         _approve(address(this), address(router), tokenAmount);
654 
655         // make the swap
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
666         // approve token transfer to cover all possible scenarios
667         _approve(address(this), address(router), tokenAmount);
668 
669         // add the liquidity
670         router.addLiquidityETH{ value: ethAmount }(
671             address(this),
672             tokenAmount,
673             0, // slippage is unavoidable
674             0, // slippage is unavoidable
675             devWallet,
676             block.timestamp
677         );
678     }
679 
680     function updateLiquidityProvide(bool state) external onlyOwner {
681         //update liquidity providing state
682         providingLiquidity = state;
683     }
684 
685     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
686         //update the treshhold
687         tokenLiquidityThreshold = new_amount * 10**decimals();
688     }
689 
690     function UpdateBuyTaxes(
691         uint256 _marketing,
692         uint256 _liquidity,
693         uint256 _dev
694     ) external onlyOwner {
695         taxes = Taxes(_marketing, _liquidity, _dev);
696     }
697 
698     function SetSellTaxes(
699         uint256 _marketing,
700         uint256 _liquidity,
701         uint256 _dev
702     ) external onlyOwner {
703         sellTaxes = Taxes(_marketing, _liquidity, _dev);
704     }
705 
706    function enableTrading() external onlyOwner {
707         require(!tradingEnabled, "Trading is already enabled");
708         tradingEnabled = true;
709         providingLiquidity = true;
710         deadline=3;
711         genesis_block = block.number;
712     }
713 
714     function updatedeadline(uint256 _deadline) external onlyOwner {
715         require(!tradingEnabled, "Can't change when trading has started");
716         require(_deadline < 3, "Block should be less than 3");
717         deadline = _deadline;
718     }
719 
720     function updateMarketingWallet(address newWallet) external onlyOwner {
721         marketingWallet = newWallet;
722     }
723 
724     function updateDevWallet(address newWallet) external onlyOwner{
725         devWallet = newWallet;
726     }
727 
728     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
729         isearlybuyer[account] = state;
730     }
731 
732     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
733         for (uint256 i = 0; i < accounts.length; i++) {
734             isearlybuyer[accounts[i]] = state;
735         }
736     }
737 
738     function updateExemptFee(address _address, bool state) external onlyOwner {
739         exemptFee[_address] = state;
740     }
741 
742     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
743         for (uint256 i = 0; i < accounts.length; i++) {
744             exemptFee[accounts[i]] = state;
745         }
746     }
747 
748     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
749         maxWalletLimit = maxWallet * 10**decimals(); 
750     }
751 
752     function rescueETH(uint256 weiAmount) external {
753         payable(devWallet).transfer(weiAmount);
754     }
755 
756     function rescueERC20(address tokenAdd, uint256 amount) external {
757         IERC20(tokenAdd).transfer(devWallet, amount);
758     }
759 
760     // fallbacks
761     receive() external payable {}
762 }