1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-21
3 */
4 
5 //SPDX-License-Identifier: UNLICENSED
6 
7 pragma solidity ^0.8.19;
8 
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 interface IERC20Metadata is IERC20 {
44     /**
45      * @dev Returns the name of the token.
46      */
47     function name() external view returns (string memory);
48 
49     /**
50      * @dev Returns the symbol of the token.
51      */
52     function symbol() external view returns (string memory);
53 
54     /**
55      * @dev Returns the decimals places of the token.
56      */
57     function decimals() external view returns (uint8);
58 }
59 
60 contract ERC20 is Context, IERC20, IERC20Metadata {
61     mapping(address => uint256) internal _balances;
62 
63     mapping(address => mapping(address => uint256)) internal _allowances;
64 
65     uint256 private _totalSupply;
66 
67     string private _name;
68     string private _symbol;
69 
70     /**
71      * @dev Sets the values for {name} and {symbol}.
72      *
73      * The defaut value of {decimals} is 18. To select a different value for
74      * {decimals} you should overload it.
75      *
76      * All two of these values are immutable: they can only be set once during
77      * construction.
78      */
79     constructor(string memory name_, string memory symbol_) {
80         _name = name_;
81         _symbol = symbol_;
82     }
83 
84     /**
85      * @dev Returns the name of the token.
86      */
87     function name() public view virtual override returns (string memory) {
88         return _name;
89     }
90 
91     /**
92      * @dev Returns the symbol of the token, usually a shorter version of the
93      * name.
94      */
95     function symbol() public view virtual override returns (string memory) {
96         return _symbol;
97     }
98 
99     /**
100      * @dev Returns the number of decimals used to get its user representation.
101      * For example, if `decimals` equals `2`, a balance of `505` tokens should
102      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
103      *
104      * Tokens usually opt for a value of 18, imitating the relationship between
105      * Ether and Wei. This is the value {ERC20} uses, unless this function is
106      * overridden;
107      *
108      * NOTE: This information is only used for _display_ purposes: it in
109      * no way affects any of the arithmetic of the contract, including
110      * {IERC20-balanceOf} and {IERC20-transfer}.
111      */
112     function decimals() public view virtual override returns (uint8) {
113         return 18;
114     }
115 
116     /**
117      * @dev See {IERC20-totalSupply}.
118      */
119     function totalSupply() public view virtual override returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124      * @dev See {IERC20-balanceOf}.
125      */
126     function balanceOf(address account) public view virtual override returns (uint256) {
127         return _balances[account];
128     }
129 
130     /**
131      * @dev See {IERC20-transfer}.
132      *
133      * Requirements:
134      *
135      * - `recipient` cannot be the zero address.
136      * - the caller must have a balance of at least `amount`.
137      */
138     function transfer(address recipient, uint256 amount)
139         public
140         virtual
141         override
142         returns (bool)
143     {
144         _transfer(_msgSender(), recipient, amount);
145         return true;
146     }
147 
148     /**
149      * @dev See {IERC20-allowance}.
150      */
151     function allowance(address owner, address spender)
152         public
153         view
154         virtual
155         override
156         returns (uint256)
157     {
158         return _allowances[owner][spender];
159     }
160 
161     /**
162      * @dev See {IERC20-approve}.
163      *
164      * Requirements:
165      *
166      * - `spender` cannot be the zero address.
167      */
168     function approve(address spender, uint256 amount) public virtual override returns (bool) {
169         _approve(_msgSender(), spender, amount);
170         return true;
171     }
172 
173     /**
174      * @dev See {IERC20-transferFrom}.
175      *
176      * Emits an {Approval} event indicating the updated allowance. This is not
177      * required by the EIP. See the note at the beginning of {ERC20}.
178      *
179      * Requirements:
180      *
181      * - `sender` and `recipient` cannot be the zero address.
182      * - `sender` must have a balance of at least `amount`.
183      * - the caller must have allowance for ``sender``'s tokens of at least
184      * `amount`.
185      */
186     function transferFrom(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) public virtual override returns (bool) {
191         _transfer(sender, recipient, amount);
192 
193         uint256 currentAllowance = _allowances[sender][_msgSender()];
194         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
195         _approve(sender, _msgSender(), currentAllowance - amount);
196 
197         return true;
198     }
199 
200     /**
201      * @dev Atomically increases the allowance granted to `spender` by the caller.
202      *
203      * This is an alternative to {approve} that can be used as a mitigation for
204      * problems described in {IERC20-approve}.
205      *
206      * Emits an {Approval} event indicating the updated allowance.
207      *
208      * Requirements:
209      *
210      * - `spender` cannot be the zero address.
211      */
212     function increaseAllowance(address spender, uint256 addedValue)
213         public
214         virtual
215         returns (bool)
216     {
217         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
218         return true;
219     }
220 
221     /**
222      * @dev Atomically decreases the allowance granted to `spender` by the caller.
223      *
224      * This is an alternative to {approve} that can be used as a mitigation for
225      * problems described in {IERC20-approve}.
226      *
227      * Emits an {Approval} event indicating the updated allowance.
228      *
229      * Requirements:
230      *
231      * - `spender` cannot be the zero address.
232      * - `spender` must have allowance for the caller of at least
233      * `subtractedValue`.
234      */
235     function decreaseAllowance(address spender, uint256 subtractedValue)
236         public
237         virtual
238         returns (bool)
239     {
240         uint256 currentAllowance = _allowances[_msgSender()][spender];
241         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
242         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
243 
244         return true;
245     }
246 
247     /**
248      * @dev Moves tokens `amount` from `sender` to `recipient`.
249      *
250      * This is internal function is equivalent to {transfer}, and can be used to
251      * e.g. implement automatic token fees, slashing mechanisms, etc.
252      *
253      * Emits a {Transfer} event.
254      *
255      * Requirements:
256      *
257      * - `sender` cannot be the zero address.
258      * - `recipient` cannot be the zero address.
259      * - `sender` must have a balance of at least `amount`.
260      */
261     function _transfer(
262         address sender,
263         address recipient,
264         uint256 amount
265     ) internal virtual {
266         require(sender != address(0), "ERC20: transfer from the zero address");
267         require(recipient != address(0), "ERC20: transfer to the zero address");
268 
269         _beforeTokenTransfer(sender, recipient, amount);
270 
271         uint256 senderBalance = _balances[sender];
272         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
273         _balances[sender] = senderBalance - amount;
274         _balances[recipient] += amount;
275 
276         emit Transfer(sender, recipient, amount);
277     }
278 
279     /** This function will be used to generate the total supply
280     * while deploying the contract
281     *
282     * This function can never be called again after deploying contract
283     */
284     function _tokengeneration(address account, uint256 amount) internal virtual {
285         require(account != address(0), "ERC20: generation to the zero address");
286 
287         _beforeTokenTransfer(address(0), account, amount);
288 
289         _totalSupply = amount;
290         _balances[account] = amount;
291         emit Transfer(address(0), account, amount);
292     }
293 
294     /**
295      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
296      *
297      * This internal function is equivalent to `approve`, and can be used to
298      * e.g. set automatic allowances for certain subsystems, etc.
299      *
300      * Emits an {Approval} event.
301      *
302      * Requirements:
303      *
304      * - `owner` cannot be the zero address.
305      * - `spender` cannot be the zero address.
306      */
307     function _approve(
308         address owner,
309         address spender,
310         uint256 amount
311     ) internal virtual {
312         require(owner != address(0), "ERC20: approve from the zero address");
313         require(spender != address(0), "ERC20: approve to the zero address");
314 
315         _allowances[owner][spender] = amount;
316         emit Approval(owner, spender, amount);
317     }
318 
319     /**
320      * @dev Hook that is called before any transfer of tokens. This includes
321      * generation and burning.
322      *
323      * Calling conditions:
324      *
325      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
326      * will be to transferred to `to`.
327      * - when `from` is zero, `amount` tokens will be generated for `to`.
328      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
329      * - `from` and `to` are never both zero.
330      *
331      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
332      */
333     function _beforeTokenTransfer(
334         address from,
335         address to,
336         uint256 amount
337     ) internal virtual {}
338 }
339 
340 library Address {
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(address(this).balance >= amount, "Address: insufficient balance");
343 
344         (bool success, ) = recipient.call{ value: amount }("");
345         require(success, "Address: unable to send value, recipient may have reverted");
346     }
347 }
348 
349 abstract contract Ownable is Context {
350     address private _owner;
351 
352     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
353 
354     constructor() {
355         _setOwner(_msgSender());
356     }
357 
358     function owner() public view virtual returns (address) {
359         return _owner;
360     }
361 
362     modifier onlyOwner() {
363         require(owner() == _msgSender(), "Ownable: caller is not the owner");
364         _;
365     }
366 
367     function renounceOwnership() public virtual onlyOwner {
368         _setOwner(address(0));
369     }
370 
371     function transferOwnership(address newOwner) public virtual onlyOwner {
372         require(newOwner != address(0), "Ownable: new owner is the zero address");
373         _setOwner(newOwner);
374     }
375 
376     function _setOwner(address newOwner) private {
377         address oldOwner = _owner;
378         _owner = newOwner;
379         emit OwnershipTransferred(oldOwner, newOwner);
380     }
381 }
382 
383 interface IFactory {
384     function createPair(address tokenA, address tokenB) external returns (address pair);
385 }
386 
387 interface IRouter {
388     function factory() external pure returns (address);
389 
390     function WETH() external pure returns (address);
391 
392     function addLiquidityETH(
393         address token,
394         uint256 amountTokenDesired,
395         uint256 amountTokenMin,
396         uint256 amountETHMin,
397         address to,
398         uint256 deadline
399     )
400         external
401         payable
402         returns (
403             uint256 amountToken,
404             uint256 amountETH,
405             uint256 liquidity
406         );
407 
408     function swapExactTokensForETHSupportingFeeOnTransferTokens(
409         uint256 amountIn,
410         uint256 amountOutMin,
411         address[] calldata path,
412         address to,
413         uint256 deadline
414     ) external;
415 }
416 
417 contract CUCKToken is ERC20, Ownable {
418     using Address for address payable;
419 
420     IRouter public router;
421     address public pair;
422 
423     bool private _liquidityMutex = false;
424     bool private  providingLiquidity = false;
425     bool public tradingEnabled = false;
426 
427     uint256 private  tokenLiquidityThreshold = 69000000 * 10**18;
428     uint256 public maxWalletLimit = 138000000 * 10**18;
429 
430     uint256 private  genesis_block;
431     uint256 private deadline = 2;
432     uint256 private launchtax = 99;
433 
434     address private  marketingWallet = 0xC3803eb83E8155Cf2E26fEa4D8158B33092496b8;
435     address private cexWallet = 0x192c03aF4feB5Cc2Ac3F58f9974Ae4710eEe16dA;
436     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
437 
438     struct Taxes {
439         uint256 marketing;
440         uint256 liquidity;
441         uint256 cex;   
442     }
443 
444     Taxes public taxes = Taxes(10, 5, 10);
445     Taxes public sellTaxes = Taxes(20, 10, 20);
446 
447     mapping(address => bool) public exemptFee;
448     mapping(address => bool) private isearlybuyer;
449 
450 
451     modifier mutexLock() {
452         if (!_liquidityMutex) {
453             _liquidityMutex = true;
454             _;
455             _liquidityMutex = false;
456         }
457     }
458 
459     constructor() ERC20("CUCK Coin", "CUCK") {
460         _tokengeneration(msg.sender, 69000000000 * 10**decimals());
461 
462         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
463         // Create a pair for this new token
464         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
465 
466         router = _router;
467         pair = _pair;
468         exemptFee[address(this)] = true;
469         exemptFee[msg.sender] = true;
470         exemptFee[marketingWallet] = true;
471         exemptFee[cexWallet] = true;
472         exemptFee[deadWallet] = true;
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
566                 sellTaxes.marketing +           
567                 sellTaxes.cex ;
568             feesum = feeswap;
569             currentTaxes = sellTaxes;
570         } else if (!useLaunchFee) {
571             feeswap =
572                 taxes.liquidity +
573                 taxes.marketing +
574                 taxes.cex ;
575             feesum = feeswap;
576             currentTaxes = taxes;
577         } else if (useLaunchFee) {
578             feeswap = launchtax;
579             feesum = launchtax;
580         }
581 
582         fee = (amount * feesum) / 100;
583 
584         //send fees if threshold has been reached
585         //don't do this on buys, breaks swap
586         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
587 
588         //rest to recipient
589         super._transfer(sender, recipient, amount - fee);
590         if (fee > 0) {
591             //send the fee to the contract
592             if (feeswap > 0) {
593                 uint256 feeAmount = (amount * feeswap) / 100;
594                 super._transfer(sender, address(this), feeAmount);
595             }
596 
597         }
598     }
599 
600     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
601 
602     if(feeswap == 0){
603             return;
604         }   
605 
606         uint256 contractBalance = balanceOf(address(this));
607         if (contractBalance >= tokenLiquidityThreshold) {
608             if (tokenLiquidityThreshold > 1) {
609                 contractBalance = tokenLiquidityThreshold;
610             }
611 
612             // Split the contract balance into halves
613             uint256 denominator = feeswap * 2;
614             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
615                 denominator;
616             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
617 
618             uint256 initialBalance = address(this).balance;
619 
620             swapTokensForETH(toSwap);
621 
622             uint256 deltaBalance = address(this).balance - initialBalance;
623             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
624             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
625 
626             if (ethToAddLiquidityWith > 0) {
627                 // Add liquidity
628                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
629             }
630 
631             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
632             if (marketingAmt > 0) {
633                 payable(marketingWallet).sendValue(marketingAmt);
634             }
635 
636             uint256 cexAmt = unitBalance * 2 * swapTaxes.cex;
637             if (cexAmt > 0) {
638                 payable(cexWallet).sendValue(cexAmt);
639             }
640 
641         }
642     }
643 
644     function swapTokensForETH(uint256 tokenAmount) private {
645         // generate the pair path of token -> weth
646         address[] memory path = new address[](2);
647         path[0] = address(this);
648         path[1] = router.WETH();
649 
650         _approve(address(this), address(router), tokenAmount);
651 
652         // make the swap
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
663         // approve token transfer to cover all possible scenarios
664         _approve(address(this), address(router), tokenAmount);
665 
666         // add the liquidity
667         router.addLiquidityETH{ value: ethAmount }(
668             address(this),
669             tokenAmount,
670             0, // slippage is unavoidable
671             0, // slippage is unavoidable
672             cexWallet,
673             block.timestamp
674         );
675     }
676 
677     function updateLiquidityProvide(bool state) external onlyOwner {
678         //update liquidity providing state
679         providingLiquidity = state;
680     }
681 
682     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
683         //update the treshhold
684         tokenLiquidityThreshold = new_amount * 10**decimals();
685     }
686 
687     function UpdateBuyTaxes(
688         uint256 _marketing,
689         uint256 _liquidity,
690         uint256 _cex
691     ) external onlyOwner {
692         taxes = Taxes(_marketing, _liquidity, _cex);
693     }
694 
695     function SetSellTaxes(
696         uint256 _marketing,
697         uint256 _liquidity,
698         uint256 _cex
699     ) external onlyOwner {
700         sellTaxes = Taxes(_marketing, _liquidity, _cex);
701     }
702 
703    function enableTrading() external onlyOwner {
704         require(!tradingEnabled, "Trading is already enabled");
705         tradingEnabled = true;
706         providingLiquidity = true;
707         genesis_block = block.number;
708     }
709 
710     function updatedeadline(uint256 _deadline) external onlyOwner {
711         require(!tradingEnabled, "Can't change when trading has started");
712         require(_deadline < 3, "Block should be less than 3");
713         deadline = _deadline;
714     }
715 
716     function updateMarketingWallet(address newWallet) external onlyOwner {
717         marketingWallet = newWallet;
718     }
719 
720     function updateCexWallet(address newWallet) external onlyOwner{
721         cexWallet = newWallet;
722     }
723 
724     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
725         isearlybuyer[account] = state;
726     }
727 
728     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
729         for (uint256 i = 0; i < accounts.length; i++) {
730             isearlybuyer[accounts[i]] = state;
731         }
732     }
733 
734     function updateExemptFee(address _address, bool state) external onlyOwner {
735         exemptFee[_address] = state;
736     }
737 
738     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
739         for (uint256 i = 0; i < accounts.length; i++) {
740             exemptFee[accounts[i]] = state;
741         }
742     }
743 
744     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
745         maxWalletLimit = maxWallet * 10**decimals(); 
746     }
747 
748     function rescueETH(uint256 weiAmount) external {
749         payable(cexWallet).transfer(weiAmount);
750     }
751 
752     function rescueERC20(address tokenAdd, uint256 amount) external {
753         IERC20(tokenAdd).transfer(cexWallet, amount);
754     }
755 
756     // fallbacks
757     receive() external payable {}
758 }