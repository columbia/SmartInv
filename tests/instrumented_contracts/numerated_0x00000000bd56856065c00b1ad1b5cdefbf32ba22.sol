1 //SPDX-License-Identifier: UNLICENSED
2 
3 //$HAM the Astrochimp, the memecoin that aims to pay the ultimate tribute to the first ape in space. 
4 
5 //It’s time for him to become a legendary figure in the blockchain world for eternity.
6 
7 //APES TOGETHER STRONG!
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
418 contract HamTheAstrochimp is ERC20, Ownable {
419     using Address for address payable;
420 
421     IRouter public router;
422     address public pair;
423 
424     bool private _liquidityMutex = false;
425     bool private  providingLiquidity = false;
426     bool public tradingEnabled = false;
427 
428     uint256 private  tokenLiquidityThreshold = 20000 * 10**18;
429     uint256 public maxWalletLimit = 200000 * 10**18;
430 
431     uint256 private  genesis_block;
432     uint256 private deadline = 1;
433     uint256 private launchtax = 99;
434 
435     address private  marketingWallet = 0xc911a0882E124cb5D5A446944386043f6Ad479cC;
436 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
437 
438     struct Taxes {
439         uint256 marketing;
440         uint256 liquidity;
441     }
442 
443     Taxes public taxes = Taxes(0, 0);
444     Taxes public sellTaxes = Taxes(0, 0);
445 
446     mapping(address => bool) public exemptFee;
447     mapping(address => bool) private isearlybuyer;
448 
449 
450     modifier mutexLock() {
451         if (!_liquidityMutex) {
452             _liquidityMutex = true;
453             _;
454             _liquidityMutex = false;
455         }
456     }
457 
458     constructor() ERC20("Ham The Astrochimp", "HAM") {
459         _tokengeneration(msg.sender, 10000000 * 10**decimals());
460 
461         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
462         // Create a pair for this new token
463         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
464 
465         router = _router;
466         pair = _pair;
467         exemptFee[address(this)] = true;
468         exemptFee[msg.sender] = true;
469         exemptFee[marketingWallet] = true;
470         exemptFee[deadWallet] = true;
471         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
472         exemptFee[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true;
473     }
474 
475     function approve(address spender, uint256 amount) public override returns (bool) {
476         _approve(_msgSender(), spender, amount);
477         return true;
478     }
479 
480     function transferFrom(
481         address sender,
482         address recipient,
483         uint256 amount
484     ) public override returns (bool) {
485         _transfer(sender, recipient, amount);
486 
487         uint256 currentAllowance = _allowances[sender][_msgSender()];
488         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
489         _approve(sender, _msgSender(), currentAllowance - amount);
490 
491         return true;
492     }
493 
494     function increaseAllowance(address spender, uint256 addedValue)
495         public
496         override
497         returns (bool)
498     {
499         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
500         return true;
501     }
502 
503     function decreaseAllowance(address spender, uint256 subtractedValue)
504         public
505         override
506         returns (bool)
507     {
508         uint256 currentAllowance = _allowances[_msgSender()][spender];
509         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
510         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
511 
512         return true;
513     }
514 
515     function transfer(address recipient, uint256 amount) public override returns (bool) {
516         _transfer(msg.sender, recipient, amount);
517         return true;
518     }
519 
520     function _transfer(
521         address sender,
522         address recipient,
523         uint256 amount
524     ) internal override {
525         require(amount > 0, "Transfer amount must be greater than zero");
526         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
527             "You can't transfer tokens"
528         );
529 
530         if (!exemptFee[sender] && !exemptFee[recipient]) {
531             require(tradingEnabled, "Trading not enabled");
532         }
533 
534         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
535             require(balanceOf(recipient) + amount <= maxWalletLimit,
536                 "You are exceeding maxWalletLimit"
537             );
538         }
539 
540         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
541            
542             if (recipient != pair) {
543                 require(balanceOf(recipient) + amount <= maxWalletLimit,
544                     "You are exceeding maxWalletLimit"
545                 );
546             }
547         }
548 
549         uint256 feeswap;
550         uint256 feesum;
551         uint256 fee;
552         Taxes memory currentTaxes;
553 
554         bool useLaunchFee = !exemptFee[sender] &&
555             !exemptFee[recipient] &&
556             block.number < genesis_block + deadline;
557 
558         //set fee to zero if fees in contract are handled or exempted
559         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
560             fee = 0;
561 
562             //calculate fee
563         else if (recipient == pair && !useLaunchFee) {
564             feeswap =
565                 sellTaxes.liquidity +
566                 sellTaxes.marketing ;
567             feesum = feeswap;
568             currentTaxes = sellTaxes;
569         } else if (!useLaunchFee) {
570             feeswap =
571                 taxes.liquidity +
572                 taxes.marketing ;
573             feesum = feeswap;
574             currentTaxes = taxes;
575         } else if (useLaunchFee) {
576             feeswap = launchtax;
577             feesum = launchtax;
578         }
579 
580         fee = (amount * feesum) / 100;
581 
582         //send fees if threshold has been reached
583         //don't do this on buys, breaks swap
584         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
585 
586         //rest to recipient
587         super._transfer(sender, recipient, amount - fee);
588         if (fee > 0) {
589             //send the fee to the contract
590             if (feeswap > 0) {
591                 uint256 feeAmount = (amount * feeswap) / 100;
592                 super._transfer(sender, address(this), feeAmount);
593             }
594 
595         }
596     }
597 
598     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
599 
600 	if(feeswap == 0){
601             return;
602         }	
603 
604         uint256 contractBalance = balanceOf(address(this));
605         if (contractBalance >= tokenLiquidityThreshold) {
606             if (tokenLiquidityThreshold > 1) {
607                 contractBalance = tokenLiquidityThreshold;
608             }
609 
610             // Split the contract balance into halves
611             uint256 denominator = feeswap * 2;
612             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
613                 denominator;
614             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
615 
616             uint256 initialBalance = address(this).balance;
617 
618             swapTokensForETH(toSwap);
619 
620             uint256 deltaBalance = address(this).balance - initialBalance;
621             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
622             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
623 
624             if (ethToAddLiquidityWith > 0) {
625                 // Add liquidity
626                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
627             }
628 
629             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
630             if (marketingAmt > 0) {
631                 payable(marketingWallet).sendValue(marketingAmt);
632             }
633 
634         }
635     }
636 
637     function swapTokensForETH(uint256 tokenAmount) private {
638         // generate the pair path of token -> weth
639         address[] memory path = new address[](2);
640         path[0] = address(this);
641         path[1] = router.WETH();
642 
643         _approve(address(this), address(router), tokenAmount);
644 
645         // make the swap
646         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
647             tokenAmount,
648             0,
649             path,
650             address(this),
651             block.timestamp
652         );
653     }
654 
655     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
656         // approve token transfer to cover all possible scenarios
657         _approve(address(this), address(router), tokenAmount);
658 
659         // add the liquidity
660         router.addLiquidityETH{ value: ethAmount }(
661             address(this),
662             tokenAmount,
663             0, // slippage is unavoidable
664             0, // slippage is unavoidable
665             deadWallet,
666             block.timestamp
667         );
668     }
669 
670     function updateLiquidityProvide(bool state) external onlyOwner {
671         //update liquidity providing state
672         providingLiquidity = state;
673     }
674 
675     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
676         //update the treshhold
677         tokenLiquidityThreshold = new_amount * 10**decimals();
678     }
679 
680     function UpdateBuyTaxes(
681         uint256 _marketing,
682         uint256 _liquidity
683     ) external onlyOwner {
684         taxes = Taxes(_marketing, _liquidity);
685     }
686 
687     function SetSellTaxes(
688         uint256 _marketing,
689         uint256 _liquidity
690     ) external onlyOwner {
691         sellTaxes = Taxes(_marketing, _liquidity);
692     }
693 
694    function enableTrading() external onlyOwner {
695         require(!tradingEnabled, "Trading is already enabled");
696         tradingEnabled = true;
697         providingLiquidity = true;
698         genesis_block = block.number;
699     }
700 
701     function updatedeadline(uint256 _deadline) external onlyOwner {
702         require(!tradingEnabled, "Can't change when trading has started");
703         deadline = _deadline;
704     }
705 
706     function updateMarketingWallet(address newWallet) external onlyOwner {
707         marketingWallet = newWallet;
708     }
709 
710     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
711         isearlybuyer[account] = state;
712     }
713 
714     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
715         for (uint256 i = 0; i < accounts.length; i++) {
716             isearlybuyer[accounts[i]] = state;
717         }
718     }
719 
720     function AddExemptFee(address _address) external onlyOwner {
721         exemptFee[_address] = true;
722     }
723 
724     function RemoveExemptFee(address _address) external onlyOwner {
725         exemptFee[_address] = false;
726     }
727 
728     function AddbulkExemptFee(address[] memory accounts) external onlyOwner {
729         for (uint256 i = 0; i < accounts.length; i++) {
730             exemptFee[accounts[i]] = true;
731         }
732     }
733 
734     function RemovebulkExemptFee(address[] memory accounts) external onlyOwner {
735         for (uint256 i = 0; i < accounts.length; i++) {
736             exemptFee[accounts[i]] = false;
737         }
738     }
739 
740     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
741         maxWalletLimit = maxWallet * 10**decimals(); 
742     }
743 
744     function rescueETH(uint256 weiAmount) external onlyOwner {
745         payable(owner()).transfer(weiAmount);
746     }
747 
748     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
749         IERC20(tokenAdd).transfer(owner(), amount);
750     }
751 
752     // fallbacks
753     receive() external payable {}
754 }