1 //SPDX-License-Identifier: UNLICENSED
2 /*
3 Telegram:https://t.me/CryptothreadsCT
4 Twitter: https://twitter.com/CryptoThreadsCT
5 Website: https://cryptothreads.app/
6 */
7 
8 pragma solidity ^0.8.19;
9 
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
270         _beforeTokenTransfer(sender, recipient, amount);
271 
272         uint256 senderBalance = _balances[sender];
273         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
274         _balances[sender] = senderBalance - amount;
275         _balances[recipient] += amount;
276 
277         emit Transfer(sender, recipient, amount);
278     }
279 
280     /** This function will be used to generate the total supply
281     * while deploying the contract
282     *
283     * This function can never be called again after deploying contract
284     */
285     function _tokengeneration(address account, uint256 amount) internal virtual {
286         require(account != address(0), "ERC20: generation to the zero address");
287 
288         _beforeTokenTransfer(address(0), account, amount);
289 
290         _totalSupply = amount;
291         _balances[account] = amount;
292         emit Transfer(address(0), account, amount);
293     }
294 
295     /**
296      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
297      *
298      * This internal function is equivalent to `approve`, and can be used to
299      * e.g. set automatic allowances for certain subsystems, etc.
300      *
301      * Emits an {Approval} event.
302      *
303      * Requirements:
304      *
305      * - `owner` cannot be the zero address.
306      * - `spender` cannot be the zero address.
307      */
308     function _approve(
309         address owner,
310         address spender,
311         uint256 amount
312     ) internal virtual {
313         require(owner != address(0), "ERC20: approve from the zero address");
314         require(spender != address(0), "ERC20: approve to the zero address");
315 
316         _allowances[owner][spender] = amount;
317         emit Approval(owner, spender, amount);
318     }
319 
320     /**
321      * @dev Hook that is called before any transfer of tokens. This includes
322      * generation and burning.
323      *
324      * Calling conditions:
325      *
326      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
327      * will be to transferred to `to`.
328      * - when `from` is zero, `amount` tokens will be generated for `to`.
329      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
330      * - `from` and `to` are never both zero.
331      *
332      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
333      */
334     function _beforeTokenTransfer(
335         address from,
336         address to,
337         uint256 amount
338     ) internal virtual {}
339 }
340 
341 library Address {
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         (bool success, ) = recipient.call{ value: amount }("");
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
384 interface IFactory {
385     function createPair(address tokenA, address tokenB) external returns (address pair);
386 }
387 
388 interface IRouter {
389     function factory() external pure returns (address);
390 
391     function WETH() external pure returns (address);
392 
393     function addLiquidityETH(
394         address token,
395         uint256 amountTokenDesired,
396         uint256 amountTokenMin,
397         uint256 amountETHMin,
398         address to,
399         uint256 deadline
400     )
401         external
402         payable
403         returns (
404             uint256 amountToken,
405             uint256 amountETH,
406             uint256 liquidity
407         );
408 
409     function swapExactTokensForETHSupportingFeeOnTransferTokens(
410         uint256 amountIn,
411         uint256 amountOutMin,
412         address[] calldata path,
413         address to,
414         uint256 deadline
415     ) external;
416 }
417 
418 contract CryptoThreads is ERC20, Ownable {
419     using Address for address payable;
420 
421     IRouter public router;
422     address public pair;
423 
424     bool private _liquidityMutex = false;
425     bool private  providingLiquidity = false;
426     bool public tradingEnabled = false;
427 
428     uint256 private tokenLiquidityThreshold = 1000000 * 10**18;
429     uint256 public maxWalletLimit = 1000000 * 10**18;
430 
431     uint256 private genesis_block;
432     uint256 private deadline = 1;
433     uint256 private launchtax = 99;
434 
435     address private  marketingWallet = 0x99f0279246500C40e3Ce8a4089d506499f52c977;
436     address private devWallet = 0x99f0279246500C40e3Ce8a4089d506499f52c977;
437     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
438 
439     struct Taxes {
440         uint256 marketing;
441         uint256 liquidity;
442         uint256 dev;   
443     }
444 
445     Taxes public taxes = Taxes(20, 0, 1);
446     Taxes public sellTaxes = Taxes(40, 0, 1);
447 
448     mapping(address => bool) public exemptFee;
449     mapping(address => bool) private isearlybuyer;
450 
451 
452     modifier mutexLock() {
453         if (!_liquidityMutex) {
454             _liquidityMutex = true;
455             _;
456             _liquidityMutex = false;
457         }
458     }
459 
460     constructor() ERC20("Crypto Threads", "CT") {
461         _tokengeneration(msg.sender, 100000000 * 10**decimals());
462 
463         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
464         // Create a pair for this new token
465         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
466 
467         router = _router;
468         pair = _pair;
469         exemptFee[address(this)] = true;
470         exemptFee[msg.sender] = true;
471         exemptFee[marketingWallet] = true;
472         exemptFee[devWallet] = true;
473         exemptFee[deadWallet] = true;
474 
475     }
476 
477     function approve(address spender, uint256 amount) public override returns (bool) {
478         _approve(_msgSender(), spender, amount);
479         return true;
480     }
481 
482     function transferFrom(
483         address sender,
484         address recipient,
485         uint256 amount
486     ) public override returns (bool) {
487         _transfer(sender, recipient, amount);
488 
489         uint256 currentAllowance = _allowances[sender][_msgSender()];
490         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
491         _approve(sender, _msgSender(), currentAllowance - amount);
492 
493         return true;
494     }
495 
496     function increaseAllowance(address spender, uint256 addedValue)
497         public
498         override
499         returns (bool)
500     {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
502         return true;
503     }
504 
505     function decreaseAllowance(address spender, uint256 subtractedValue)
506         public
507         override
508         returns (bool)
509     {
510         uint256 currentAllowance = _allowances[_msgSender()][spender];
511         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
512         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
513 
514         return true;
515     }
516 
517     function transfer(address recipient, uint256 amount) public override returns (bool) {
518         _transfer(msg.sender, recipient, amount);
519         return true;
520     }
521 
522     function _transfer(
523         address sender,
524         address recipient,
525         uint256 amount
526     ) internal override {
527         require(amount > 0, "Transfer amount must be greater than zero");
528         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
529             "You can't transfer tokens"
530         );
531 
532         if (!exemptFee[sender] && !exemptFee[recipient]) {
533             require(tradingEnabled, "Trading not enabled");
534         }
535 
536         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
537             require(balanceOf(recipient) + amount <= maxWalletLimit,
538                 "You are exceeding maxWalletLimit"
539             );
540         }
541 
542         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
543            
544             if (recipient != pair) {
545                 require(balanceOf(recipient) + amount <= maxWalletLimit,
546                     "You are exceeding maxWalletLimit"
547                 );
548             }
549         }
550 
551         uint256 feeswap;
552         uint256 feesum;
553         uint256 fee;
554         Taxes memory currentTaxes;
555 
556         bool useLaunchFee = !exemptFee[sender] &&
557             !exemptFee[recipient] &&
558             block.number < genesis_block + deadline;
559 
560         //set fee to zero if fees in contract are handled or exempted
561         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
562             fee = 0;
563 
564             //calculate fee
565         else if (recipient == pair && !useLaunchFee) {
566             feeswap =
567                 sellTaxes.liquidity +
568                 sellTaxes.marketing +           
569                 sellTaxes.dev ;
570             feesum = feeswap;
571             currentTaxes = sellTaxes;
572         } else if (!useLaunchFee) {
573             feeswap =
574                 taxes.liquidity +
575                 taxes.marketing +
576                 taxes.dev ;
577             feesum = feeswap;
578             currentTaxes = taxes;
579         } else if (useLaunchFee) {
580             feeswap = launchtax;
581             feesum = launchtax;
582         }
583 
584         fee = (amount * feesum) / 100;
585 
586         //send fees if threshold has been reached
587         //don't do this on buys, breaks swap
588         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
589 
590         //rest to recipient
591         super._transfer(sender, recipient, amount - fee);
592         if (fee > 0) {
593             //send the fee to the contract
594             if (feeswap > 0) {
595                 uint256 feeAmount = (amount * feeswap) / 100;
596                 super._transfer(sender, address(this), feeAmount);
597             }
598 
599         }
600     }
601 
602     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
603 
604     if(feeswap == 0){
605             return;
606         }   
607 
608         uint256 contractBalance = balanceOf(address(this));
609         if (contractBalance >= tokenLiquidityThreshold) {
610             if (tokenLiquidityThreshold > 1) {
611                 contractBalance = tokenLiquidityThreshold;
612             }
613 
614             // Split the contract balance into halves
615             uint256 denominator = feeswap * 2;
616             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
617                 denominator;
618             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
619 
620             uint256 initialBalance = address(this).balance;
621 
622             swapTokensForETH(toSwap);
623 
624             uint256 deltaBalance = address(this).balance - initialBalance;
625             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
626             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
627 
628             if (ethToAddLiquidityWith > 0) {
629                 // Add liquidity
630                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
631             }
632 
633             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
634             if (marketingAmt > 0) {
635                 payable(marketingWallet).sendValue(marketingAmt);
636             }
637 
638             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
639             if (devAmt > 0) {
640                 payable(devWallet).sendValue(devAmt);
641             }
642 
643         }
644     }
645 
646     function swapTokensForETH(uint256 tokenAmount) private {
647         // generate the pair path of token -> weth
648         address[] memory path = new address[](2);
649         path[0] = address(this);
650         path[1] = router.WETH();
651 
652         _approve(address(this), address(router), tokenAmount);
653 
654         // make the swap
655         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
656             tokenAmount,
657             0,
658             path,
659             address(this),
660             block.timestamp
661         );
662     }
663 
664     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
665         // approve token transfer to cover all possible scenarios
666         _approve(address(this), address(router), tokenAmount);
667 
668         // add the liquidity
669         router.addLiquidityETH{ value: ethAmount }(
670             address(this),
671             tokenAmount,
672             0, // slippage is unavoidable
673             0, // slippage is unavoidable
674             devWallet,
675             block.timestamp
676         );
677     }
678 
679     function updateLiquidityProvide(bool state) external onlyOwner {
680         //update liquidity providing state
681         providingLiquidity = state;
682     }
683 
684     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
685         //update the treshhold
686         tokenLiquidityThreshold = new_amount * 10**decimals();
687     }
688 
689     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
690         for (uint256 i = 0; i < accounts.length; i++) {
691             isearlybuyer[accounts[i]] = state;
692         }
693     }
694 
695     function updateExemptFee(address _address, bool state) external onlyOwner {
696         exemptFee[_address] = state;
697     }
698 
699     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
700         for (uint256 i = 0; i < accounts.length; i++) {
701             exemptFee[accounts[i]] = state;
702         }
703     }
704 
705     function UpdateBuyTaxes(
706         uint256 _marketing,
707         uint256 _liquidity,
708         uint256 _dev
709     ) external onlyOwner {
710         taxes = Taxes(_marketing, _liquidity, _dev);
711     }
712 
713     function SetSellTaxes(
714         uint256 _marketing,
715         uint256 _liquidity,
716         uint256 _dev
717     ) external onlyOwner {
718         sellTaxes = Taxes(_marketing, _liquidity, _dev);
719     }
720 
721    function enableTrading() external onlyOwner {
722         require(!tradingEnabled, "Trading is already enabled");
723         tradingEnabled = true;
724         providingLiquidity = true;
725         genesis_block = block.number;
726     }
727 
728     function updateMarketingWallet(address newWallet) external onlyOwner {
729         marketingWallet = newWallet;
730     }
731 
732     function updateDevWallet(address newWallet) external onlyOwner{
733         devWallet = newWallet;
734     }
735 
736     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
737         isearlybuyer[account] = state;
738     }
739 
740     
741     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
742         maxWalletLimit = maxWallet * 10**decimals(); 
743     }
744 
745     function rescueETH(uint256 weiAmount) external {
746         payable(devWallet).transfer(weiAmount);
747     }
748 
749     function rescueERC20(address tokenAdd, uint256 amount) external {
750         IERC20(tokenAdd).transfer(devWallet, amount);
751     }
752 
753     // fallbacks
754     receive() external payable {}
755 }