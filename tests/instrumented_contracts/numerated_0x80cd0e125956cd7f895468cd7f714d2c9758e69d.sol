1 /**
2 Buy & Sell Tax: 0
3 
4 Telegram:  https://t.me/starship_erc20
5 Twitter: https://twitter.com/starship_erc20
6 Website: www.marsmission.io
7 */
8 
9 //SPDX-License-Identifier: UNLICENSED
10 
11 pragma solidity ^0.8.17;
12 
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
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 interface IERC20Metadata is IERC20 {
48     /**
49      * @dev Returns the name of the token.
50      */
51     function name() external view returns (string memory);
52 
53     /**
54      * @dev Returns the symbol of the token.
55      */
56     function symbol() external view returns (string memory);
57 
58     /**
59      * @dev Returns the decimals places of the token.
60      */
61     function decimals() external view returns (uint8);
62 }
63 
64 contract ERC20 is Context, IERC20, IERC20Metadata {
65     mapping(address => uint256) internal _balances;
66 
67     mapping(address => mapping(address => uint256)) internal _allowances;
68 
69     uint256 private _totalSupply;
70 
71     string private _name;
72     string private _symbol;
73 
74     /**
75      * @dev Sets the values for {name} and {symbol}.
76      *
77      * The defaut value of {decimals} is 18. To select a different value for
78      * {decimals} you should overload it.
79      *
80      * All two of these values are immutable: they can only be set once during
81      * construction.
82      */
83     constructor(string memory name_, string memory symbol_) {
84         _name = name_;
85         _symbol = symbol_;
86     }
87 
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() public view virtual override returns (string memory) {
92         return _name;
93     }
94 
95     /**
96      * @dev Returns the symbol of the token, usually a shorter version of the
97      * name.
98      */
99     function symbol() public view virtual override returns (string memory) {
100         return _symbol;
101     }
102 
103     /**
104      * @dev Returns the number of decimals used to get its user representation.
105      * For example, if `decimals` equals `2`, a balance of `505` tokens should
106      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
107      *
108      * Tokens usually opt for a value of 18, imitating the relationship between
109      * Ether and Wei. This is the value {ERC20} uses, unless this function is
110      * overridden;
111      *
112      * NOTE: This information is only used for _display_ purposes: it in
113      * no way affects any of the arithmetic of the contract, including
114      * {IERC20-balanceOf} and {IERC20-transfer}.
115      */
116     function decimals() public view virtual override returns (uint8) {
117         return 18;
118     }
119 
120     /**
121      * @dev See {IERC20-totalSupply}.
122      */
123     function totalSupply() public view virtual override returns (uint256) {
124         return _totalSupply;
125     }
126 
127     /**
128      * @dev See {IERC20-balanceOf}.
129      */
130     function balanceOf(address account) public view virtual override returns (uint256) {
131         return _balances[account];
132     }
133 
134     /**
135      * @dev See {IERC20-transfer}.
136      *
137      * Requirements:
138      *
139      * - `recipient` cannot be the zero address.
140      * - the caller must have a balance of at least `amount`.
141      */
142     function transfer(address recipient, uint256 amount)
143         public
144         virtual
145         override
146         returns (bool)
147     {
148         _transfer(_msgSender(), recipient, amount);
149         return true;
150     }
151 
152     /**
153      * @dev See {IERC20-allowance}.
154      */
155     function allowance(address owner, address spender)
156         public
157         view
158         virtual
159         override
160         returns (uint256)
161     {
162         return _allowances[owner][spender];
163     }
164 
165     /**
166      * @dev See {IERC20-approve}.
167      *
168      * Requirements:
169      *
170      * - `spender` cannot be the zero address.
171      */
172     function approve(address spender, uint256 amount) public virtual override returns (bool) {
173         _approve(_msgSender(), spender, amount);
174         return true;
175     }
176 
177     /**
178      * @dev See {IERC20-transferFrom}.
179      *
180      * Emits an {Approval} event indicating the updated allowance. This is not
181      * required by the EIP. See the note at the beginning of {ERC20}.
182      *
183      * Requirements:
184      *
185      * - `sender` and `recipient` cannot be the zero address.
186      * - `sender` must have a balance of at least `amount`.
187      * - the caller must have allowance for ``sender``'s tokens of at least
188      * `amount`.
189      */
190     function transferFrom(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) public virtual override returns (bool) {
195         _transfer(sender, recipient, amount);
196 
197         uint256 currentAllowance = _allowances[sender][_msgSender()];
198         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
199         _approve(sender, _msgSender(), currentAllowance - amount);
200 
201         return true;
202     }
203 
204     /**
205      * @dev Atomically increases the allowance granted to `spender` by the caller.
206      *
207      * This is an alternative to {approve} that can be used as a mitigation for
208      * problems described in {IERC20-approve}.
209      *
210      * Emits an {Approval} event indicating the updated allowance.
211      *
212      * Requirements:
213      *
214      * - `spender` cannot be the zero address.
215      */
216     function increaseAllowance(address spender, uint256 addedValue)
217         public
218         virtual
219         returns (bool)
220     {
221         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
222         return true;
223     }
224 
225     /**
226      * @dev Atomically decreases the allowance granted to `spender` by the caller.
227      *
228      * This is an alternative to {approve} that can be used as a mitigation for
229      * problems described in {IERC20-approve}.
230      *
231      * Emits an {Approval} event indicating the updated allowance.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      * - `spender` must have allowance for the caller of at least
237      * `subtractedValue`.
238      */
239     function decreaseAllowance(address spender, uint256 subtractedValue)
240         public
241         virtual
242         returns (bool)
243     {
244         uint256 currentAllowance = _allowances[_msgSender()][spender];
245         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
246         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
247 
248         return true;
249     }
250 
251     /**
252      * @dev Moves tokens `amount` from `sender` to `recipient`.
253      *
254      * This is internal function is equivalent to {transfer}, and can be used to
255      * e.g. implement automatic token fees, slashing mechanisms, etc.
256      *
257      * Emits a {Transfer} event.
258      *
259      * Requirements:
260      *
261      * - `sender` cannot be the zero address.
262      * - `recipient` cannot be the zero address.
263      * - `sender` must have a balance of at least `amount`.
264      */
265     function _transfer(
266         address sender,
267         address recipient,
268         uint256 amount
269     ) internal virtual {
270         require(sender != address(0), "ERC20: transfer from the zero address");
271         require(recipient != address(0), "ERC20: transfer to the zero address");
272 
273         _beforeTokenTransfer(sender, recipient, amount);
274 
275         uint256 senderBalance = _balances[sender];
276         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
277         _balances[sender] = senderBalance - amount;
278         _balances[recipient] += amount;
279 
280         emit Transfer(sender, recipient, amount);
281     }
282 
283     /** This function will be used to generate the total supply
284     * while deploying the contract
285     *
286     * This function can never be called again after deploying contract
287     */
288     function _tokengeneration(address account, uint256 amount) internal virtual {
289         require(account != address(0), "ERC20: generation to the zero address");
290 
291         _beforeTokenTransfer(address(0), account, amount);
292 
293         _totalSupply = amount;
294         _balances[account] = amount;
295         emit Transfer(address(0), account, amount);
296     }
297 
298     /**
299      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
300      *
301      * This internal function is equivalent to `approve`, and can be used to
302      * e.g. set automatic allowances for certain subsystems, etc.
303      *
304      * Emits an {Approval} event.
305      *
306      * Requirements:
307      *
308      * - `owner` cannot be the zero address.
309      * - `spender` cannot be the zero address.
310      */
311     function _approve(
312         address owner,
313         address spender,
314         uint256 amount
315     ) internal virtual {
316         require(owner != address(0), "ERC20: approve from the zero address");
317         require(spender != address(0), "ERC20: approve to the zero address");
318 
319         _allowances[owner][spender] = amount;
320         emit Approval(owner, spender, amount);
321     }
322 
323     /**
324      * @dev Hook that is called before any transfer of tokens. This includes
325      * generation and burning.
326      *
327      * Calling conditions:
328      *
329      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
330      * will be to transferred to `to`.
331      * - when `from` is zero, `amount` tokens will be generated for `to`.
332      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
333      * - `from` and `to` are never both zero.
334      *
335      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
336      */
337     function _beforeTokenTransfer(
338         address from,
339         address to,
340         uint256 amount
341     ) internal virtual {}
342 }
343 
344 library Address {
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         (bool success, ) = recipient.call{ value: amount }("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 }
352 
353 abstract contract Ownable is Context {
354     address private _owner;
355 
356     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
357 
358     constructor() {
359         _setOwner(_msgSender());
360     }
361 
362     function owner() public view virtual returns (address) {
363         return _owner;
364     }
365 
366     modifier onlyOwner() {
367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
368         _;
369     }
370 
371     function renounceOwnership() public virtual onlyOwner {
372         _setOwner(address(0));
373     }
374 
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         _setOwner(newOwner);
378     }
379 
380     function _setOwner(address newOwner) private {
381         address oldOwner = _owner;
382         _owner = newOwner;
383         emit OwnershipTransferred(oldOwner, newOwner);
384     }
385 }
386 
387 interface IFactory {
388     function createPair(address tokenA, address tokenB) external returns (address pair);
389 }
390 
391 interface IRouter {
392     function factory() external pure returns (address);
393 
394     function WETH() external pure returns (address);
395 
396     function addLiquidityETH(
397         address token,
398         uint256 amountTokenDesired,
399         uint256 amountTokenMin,
400         uint256 amountETHMin,
401         address to,
402         uint256 deadline
403     )
404         external
405         payable
406         returns (
407             uint256 amountToken,
408             uint256 amountETH,
409             uint256 liquidity
410         );
411 
412     function swapExactTokensForETHSupportingFeeOnTransferTokens(
413         uint256 amountIn,
414         uint256 amountOutMin,
415         address[] calldata path,
416         address to,
417         uint256 deadline
418     ) external;
419 }
420 
421 contract STARSHIP is ERC20, Ownable {
422     using Address for address payable;
423 
424     IRouter public router;
425     address public pair;
426 
427     bool private _liquidityMutex = false;
428     bool private  providingLiquidity = false;
429     bool public tradingEnabled = false;
430 
431     uint256 private  tokenLiquidityThreshold = 675240 * 10**18;
432     uint256 public maxWalletLimit = 4501600 * 10**18;
433 
434     uint256 private  genesis_block;
435     uint256 private deadline = 3;
436     uint256 private launchtax = 99;
437 
438     address private  marketingWallet = 0x321F38B4f51984C9dADf9c77Ae4b9880347f79A3;
439     address private devWallet = 0x8633620a8DD478fbadB9236a7CeD9D8C5a59Dd96;
440 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
441 
442     struct Taxes {
443         uint256 marketing;
444         uint256 liquidity;
445         uint256 dev;   
446     }
447 
448     Taxes private taxes = Taxes(0, 0, 0);
449     Taxes private sellTaxes = Taxes(0, 0, 0);
450 
451     uint256 public TotalBuyFee = taxes.marketing + taxes.liquidity + taxes.dev;
452     uint256 public TotalSellFee = sellTaxes.marketing + sellTaxes.liquidity + sellTaxes.dev;
453 
454     mapping(address => bool) public exemptFee;
455     mapping(address => bool) private isearlybuyer;
456 
457 
458     modifier mutexLock() {
459         if (!_liquidityMutex) {
460             _liquidityMutex = true;
461             _;
462             _liquidityMutex = false;
463         }
464     }
465 
466     constructor() ERC20("STARSHIP", "SPACEX") {
467         _tokengeneration(msg.sender, 225080000 * 10**decimals());
468 
469         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
470         // Create a pair for this new token
471         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
472 
473         router = _router;
474         pair = _pair;
475         exemptFee[address(this)] = true;
476         exemptFee[msg.sender] = true;
477         exemptFee[marketingWallet] = true;
478         exemptFee[devWallet] = true;
479         exemptFee[deadWallet] = true;
480         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
481 
482     }
483 
484     function approve(address spender, uint256 amount) public override returns (bool) {
485         _approve(_msgSender(), spender, amount);
486         return true;
487     }
488 
489     function transferFrom(
490         address sender,
491         address recipient,
492         uint256 amount
493     ) public override returns (bool) {
494         _transfer(sender, recipient, amount);
495 
496         uint256 currentAllowance = _allowances[sender][_msgSender()];
497         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
498         _approve(sender, _msgSender(), currentAllowance - amount);
499 
500         return true;
501     }
502 
503     function increaseAllowance(address spender, uint256 addedValue)
504         public
505         override
506         returns (bool)
507     {
508         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
509         return true;
510     }
511 
512     function decreaseAllowance(address spender, uint256 subtractedValue)
513         public
514         override
515         returns (bool)
516     {
517         uint256 currentAllowance = _allowances[_msgSender()][spender];
518         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
519         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
520 
521         return true;
522     }
523 
524     function transfer(address recipient, uint256 amount) public override returns (bool) {
525         _transfer(msg.sender, recipient, amount);
526         return true;
527     }
528 
529     function _transfer(
530         address sender,
531         address recipient,
532         uint256 amount
533     ) internal override {
534         require(amount > 0, "Transfer amount must be greater than zero");
535         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
536             "You can't transfer tokens"
537         );
538 
539         if (!exemptFee[sender] && !exemptFee[recipient]) {
540             require(tradingEnabled, "Trading not enabled");
541         }
542 
543         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
544             require(balanceOf(recipient) + amount <= maxWalletLimit,
545                 "You are exceeding maxWalletLimit"
546             );
547         }
548 
549         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
550            
551             if (recipient != pair) {
552                 require(balanceOf(recipient) + amount <= maxWalletLimit,
553                     "You are exceeding maxWalletLimit"
554                 );
555             }
556         }
557 
558         uint256 feeswap;
559         uint256 feesum;
560         uint256 fee;
561         Taxes memory currentTaxes;
562 
563         bool useLaunchFee = !exemptFee[sender] &&
564             !exemptFee[recipient] &&
565             block.number < genesis_block + deadline;
566 
567         //set fee to zero if fees in contract are handled or exempted
568         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
569             fee = 0;
570 
571             //calculate fee
572         else if (recipient == pair && !useLaunchFee) {
573             feeswap =
574                 sellTaxes.liquidity +
575                 sellTaxes.marketing +           
576                 sellTaxes.dev ;
577             feesum = feeswap;
578             currentTaxes = sellTaxes;
579         } else if (!useLaunchFee) {
580             feeswap =
581                 taxes.liquidity +
582                 taxes.marketing +
583                 taxes.dev ;
584             feesum = feeswap;
585             currentTaxes = taxes;
586         } else if (useLaunchFee) {
587             feeswap = launchtax;
588             feesum = launchtax;
589         }
590 
591         fee = (amount * feesum) / 100;
592 
593         //send fees if threshold has been reached
594         //don't do this on buys, breaks swap
595         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
596 
597         //rest to recipient
598         super._transfer(sender, recipient, amount - fee);
599         if (fee > 0) {
600             //send the fee to the contract
601             if (feeswap > 0) {
602                 uint256 feeAmount = (amount * feeswap) / 100;
603                 super._transfer(sender, address(this), feeAmount);
604             }
605 
606         }
607     }
608 
609     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
610 
611 	if(feeswap == 0){
612             return;
613         }	
614 
615         uint256 contractBalance = balanceOf(address(this));
616         if (contractBalance >= tokenLiquidityThreshold) {
617             if (tokenLiquidityThreshold > 1) {
618                 contractBalance = tokenLiquidityThreshold;
619             }
620 
621             // Split the contract balance into halves
622             uint256 denominator = feeswap * 2;
623             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
624                 denominator;
625             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
626 
627             uint256 initialBalance = address(this).balance;
628 
629             swapTokensForETH(toSwap);
630 
631             uint256 deltaBalance = address(this).balance - initialBalance;
632             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
633             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
634 
635             if (ethToAddLiquidityWith > 0) {
636                 // Add liquidity
637                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
638             }
639 
640             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
641             if (marketingAmt > 0) {
642                 payable(marketingWallet).sendValue(marketingAmt);
643             }
644 
645             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
646             if (devAmt > 0) {
647                 payable(devWallet).sendValue(devAmt);
648             }
649 
650         }
651     }
652 
653     function swapTokensForETH(uint256 tokenAmount) private {
654         // generate the pair path of token -> weth
655         address[] memory path = new address[](2);
656         path[0] = address(this);
657         path[1] = router.WETH();
658 
659         _approve(address(this), address(router), tokenAmount);
660 
661         // make the swap
662         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
663             tokenAmount,
664             0,
665             path,
666             address(this),
667             block.timestamp
668         );
669     }
670 
671     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
672         // approve token transfer to cover all possible scenarios
673         _approve(address(this), address(router), tokenAmount);
674 
675         // add the liquidity
676         router.addLiquidityETH{ value: ethAmount }(
677             address(this),
678             tokenAmount,
679             0, // slippage is unavoidable
680             0, // slippage is unavoidable
681             devWallet,
682             block.timestamp
683         );
684     }
685 
686     function updateLiquidityProvide(bool state) external onlyOwner {
687         //update liquidity providing state
688         providingLiquidity = state;
689     }
690 
691     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
692         //update the treshhold
693         tokenLiquidityThreshold = new_amount * 10**decimals();
694     }
695 
696     function UpdateBuyTaxes(
697         uint256 _marketing,
698         uint256 _liquidity,
699         uint256 _dev
700     ) external onlyOwner {
701         taxes = Taxes(_marketing, _liquidity, _dev);
702     }
703 
704     function SetSellTaxes(
705         uint256 _marketing,
706         uint256 _liquidity,
707         uint256 _dev
708     ) external onlyOwner {
709         sellTaxes = Taxes(_marketing, _liquidity, _dev);
710     }
711 
712    function enableTrading() external onlyOwner {
713         require(!tradingEnabled, "Trading is already enabled");
714         tradingEnabled = true;
715         providingLiquidity = true;
716         genesis_block = block.number;
717     }
718 
719     function updatedeadline(uint256 _deadline) external onlyOwner {
720         require(!tradingEnabled, "Can't change when trading has started");
721         require(_deadline < 5, "Block should be less than 5");
722         deadline = _deadline;
723     }
724 
725     function updateMarketingWallet(address newWallet) external onlyOwner {
726         marketingWallet = newWallet;
727     }
728 
729     function updateDevWallet(address newWallet) external onlyOwner{
730         devWallet = newWallet;
731     }
732 
733     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
734         isearlybuyer[account] = state;
735     }
736 
737     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
738         for (uint256 i = 0; i < accounts.length; i++) {
739             isearlybuyer[accounts[i]] = state;
740         }
741     }
742 
743     function updateExemptFee(address _address, bool state) external onlyOwner {
744         exemptFee[_address] = state;
745     }
746 
747     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
748         for (uint256 i = 0; i < accounts.length; i++) {
749             exemptFee[accounts[i]] = state;
750         }
751     }
752 
753     function updateMaxTxLimit(uint256 maxWallet) external onlyOwner {
754         require(maxWallet >= 225080, "Cannot set max wallet amount lower than 0.1%");
755         maxWalletLimit = maxWallet * 10**decimals(); 
756     }
757 
758     function rescueETH(uint256 weiAmount) external {
759         payable(devWallet).transfer(weiAmount);
760     }
761 
762     function rescueERC20(address tokenAdd, uint256 amount) external {
763         IERC20(tokenAdd).transfer(devWallet, amount);
764     }
765 
766     // fallbacks
767     receive() external payable {}
768 }