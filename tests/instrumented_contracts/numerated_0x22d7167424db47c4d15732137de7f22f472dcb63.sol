1 /*
2     
3     Shibmerican 2.0
4 
5     |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
6     | * * * * * * * * *  :::::::::::::::::::::::::|
7     |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
8     | * * * * * * * * *  :::::::::::::::::::::::::|
9     |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
10     | * * * * * * * * *  ::::::::::::::::::::;::::|
11     |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
12     |:::::::::::::::::::::::::::::::::::::::::::::|
13     |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
14     |:::::::::::::::::::::::::::::::::::::::::::::|
15     |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
16     |:::::::::::::::::::::::::::::::::::::::::::::|
17     |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
18 
19     https://www.shibamericanv2.com/
20 
21     https://twitter.com/Shibmerican2
22 
23     https://t.me/shibmerican2portal
24 
25 */
26 //SPDX-License-Identifier: MIT
27 
28 pragma solidity ^0.8.19;
29 
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
38         return msg.data;
39     }
40 }
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44 
45     function balanceOf(address account) external view returns (uint256);
46 
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     function transferFrom(
54         address sender,
55         address recipient,
56         uint256 amount
57     ) external returns (bool);
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 interface IERC20Metadata is IERC20 {
65     /**
66      * @dev Returns the name of the token.
67      */
68     function name() external view returns (string memory);
69 
70     /**
71      * @dev Returns the symbol of the token.
72      */
73     function symbol() external view returns (string memory);
74 
75     /**
76      * @dev Returns the decimals places of the token.
77      */
78     function decimals() external view returns (uint8);
79 }
80 
81 contract ERC20 is Context, IERC20, IERC20Metadata {
82     mapping(address => uint256) internal _balances;
83 
84     mapping(address => mapping(address => uint256)) internal _allowances;
85 
86     uint256 private _totalSupply;
87 
88     string private _name;
89     string private _symbol;
90 
91     /**
92      * @dev Sets the values for {name} and {symbol}.
93      *
94      * The defaut value of {decimals} is 18. To select a different value for
95      * {decimals} you should overload it.
96      *
97      * All two of these values are immutable: they can only be set once during
98      * construction.
99      */
100     constructor(string memory name_, string memory symbol_) {
101         _name = name_;
102         _symbol = symbol_;
103     }
104 
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() public view virtual override returns (string memory) {
109         return _name;
110     }
111 
112     /**
113      * @dev Returns the symbol of the token, usually a shorter version of the
114      * name.
115      */
116     function symbol() public view virtual override returns (string memory) {
117         return _symbol;
118     }
119 
120     /**
121      * @dev Returns the number of decimals used to get its user representation.
122      * For example, if `decimals` equals `2`, a balance of `505` tokens should
123      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
124      *
125      * Tokens usually opt for a value of 18, imitating the relationship between
126      * Ether and Wei. This is the value {ERC20} uses, unless this function is
127      * overridden;
128      *
129      * NOTE: This information is only used for _display_ purposes: it in
130      * no way affects any of the arithmetic of the contract, including
131      * {IERC20-balanceOf} and {IERC20-transfer}.
132      */
133     function decimals() public view virtual override returns (uint8) {
134         return 18;
135     }
136 
137     /**
138      * @dev See {IERC20-totalSupply}.
139      */
140     function totalSupply() public view virtual override returns (uint256) {
141         return _totalSupply;
142     }
143 
144     /**
145      * @dev See {IERC20-balanceOf}.
146      */
147     function balanceOf(address account) public view virtual override returns (uint256) {
148         return _balances[account];
149     }
150 
151     /**
152      * @dev See {IERC20-transfer}.
153      *
154      * Requirements:
155      *
156      * - `recipient` cannot be the zero address.
157      * - the caller must have a balance of at least `amount`.
158      */
159     function transfer(address recipient, uint256 amount)
160         public
161         virtual
162         override
163         returns (bool)
164     {
165         _transfer(_msgSender(), recipient, amount);
166         return true;
167     }
168 
169     /**
170      * @dev See {IERC20-allowance}.
171      */
172     function allowance(address owner, address spender)
173         public
174         view
175         virtual
176         override
177         returns (uint256)
178     {
179         return _allowances[owner][spender];
180     }
181 
182     /**
183      * @dev See {IERC20-approve}.
184      *
185      * Requirements:
186      *
187      * - `spender` cannot be the zero address.
188      */
189     function approve(address spender, uint256 amount) public virtual override returns (bool) {
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
215         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
216         _approve(sender, _msgSender(), currentAllowance - amount);
217 
218         return true;
219     }
220 
221     /**
222      * @dev Atomically increases the allowance granted to `spender` by the caller.
223      *
224      * This is an alternative to {approve} that can be used as a mitigation for
225      * problems described in {IERC20-approve}.
226      *
227      * Emits an {Approval} event indicating the updated allowance.
228      *
229      * Requirements:
230      *
231      * - `spender` cannot be the zero address.
232      */
233     function increaseAllowance(address spender, uint256 addedValue)
234         public
235         virtual
236         returns (bool)
237     {
238         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
239         return true;
240     }
241 
242     /**
243      * @dev Atomically decreases the allowance granted to `spender` by the caller.
244      *
245      * This is an alternative to {approve} that can be used as a mitigation for
246      * problems described in {IERC20-approve}.
247      *
248      * Emits an {Approval} event indicating the updated allowance.
249      *
250      * Requirements:
251      *
252      * - `spender` cannot be the zero address.
253      * - `spender` must have allowance for the caller of at least
254      * `subtractedValue`.
255      */
256     function decreaseAllowance(address spender, uint256 subtractedValue)
257         public
258         virtual
259         returns (bool)
260     {
261         uint256 currentAllowance = _allowances[_msgSender()][spender];
262         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
263         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
264 
265         return true;
266     }
267 
268     /**
269      * @dev Moves tokens `amount` from `sender` to `recipient`.
270      *
271      * This is internal function is equivalent to {transfer}, and can be used to
272      * e.g. implement automatic token fees, slashing mechanisms, etc.
273      *
274      * Emits a {Transfer} event.
275      *
276      * Requirements:
277      *
278      * - `sender` cannot be the zero address.
279      * - `recipient` cannot be the zero address.
280      * - `sender` must have a balance of at least `amount`.
281      */
282     function _transfer(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) internal virtual {
287         require(sender != address(0), "ERC20: transfer from the zero address");
288         require(recipient != address(0), "ERC20: transfer to the zero address");
289 
290         _beforeTokenTransfer(sender, recipient, amount);
291 
292         uint256 senderBalance = _balances[sender];
293         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
294         _balances[sender] = senderBalance - amount;
295         _balances[recipient] += amount;
296 
297         emit Transfer(sender, recipient, amount);
298     }
299 
300     /** This function will be used to generate the total supply
301     * while deploying the contract
302     *
303     * This function can never be called again after deploying contract
304     */
305     function _tokengeneration(address account, uint256 amount) internal virtual {
306         require(account != address(0), "ERC20: generation to the zero address");
307 
308         _beforeTokenTransfer(address(0), account, amount);
309 
310         _totalSupply = amount;
311         _balances[account] = amount;
312         emit Transfer(address(0), account, amount);
313     }
314 
315     /**
316      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
317      *
318      * This internal function is equivalent to `approve`, and can be used to
319      * e.g. set automatic allowances for certain subsystems, etc.
320      *
321      * Emits an {Approval} event.
322      *
323      * Requirements:
324      *
325      * - `owner` cannot be the zero address.
326      * - `spender` cannot be the zero address.
327      */
328     function _approve(
329         address owner,
330         address spender,
331         uint256 amount
332     ) internal virtual {
333         require(owner != address(0), "ERC20: approve from the zero address");
334         require(spender != address(0), "ERC20: approve to the zero address");
335 
336         _allowances[owner][spender] = amount;
337         emit Approval(owner, spender, amount);
338     }
339 
340     /**
341      * @dev Hook that is called before any transfer of tokens. This includes
342      * generation and burning.
343      *
344      * Calling conditions:
345      *
346      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
347      * will be to transferred to `to`.
348      * - when `from` is zero, `amount` tokens will be generated for `to`.
349      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
350      * - `from` and `to` are never both zero.
351      *
352      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
353      */
354     function _beforeTokenTransfer(
355         address from,
356         address to,
357         uint256 amount
358     ) internal virtual {}
359 }
360 
361 library Address {
362     function sendValue(address payable recipient, uint256 amount) internal {
363         require(address(this).balance >= amount, "Address: insufficient balance");
364 
365         (bool success, ) = recipient.call{ value: amount }("");
366         require(success, "Address: unable to send value, recipient may have reverted");
367     }
368 }
369 
370 abstract contract Ownable is Context {
371     address private _owner;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     constructor() {
376         _setOwner(_msgSender());
377     }
378 
379     function owner() public view virtual returns (address) {
380         return _owner;
381     }
382 
383     modifier onlyOwner() {
384         require(owner() == _msgSender(), "Ownable: caller is not the owner");
385         _;
386     }
387 
388     function renounceOwnership() public virtual onlyOwner {
389         _setOwner(address(0));
390     }
391 
392     function transferOwnership(address newOwner) public virtual onlyOwner {
393         require(newOwner != address(0), "Ownable: new owner is the zero address");
394         _setOwner(newOwner);
395     }
396 
397     function _setOwner(address newOwner) private {
398         address oldOwner = _owner;
399         _owner = newOwner;
400         emit OwnershipTransferred(oldOwner, newOwner);
401     }
402 }
403 
404 interface IFactory {
405     function createPair(address tokenA, address tokenB) external returns (address pair);
406 }
407 
408 interface IRouter {
409     function factory() external pure returns (address);
410 
411     function WETH() external pure returns (address);
412 
413     function addLiquidityETH(
414         address token,
415         uint256 amountTokenDesired,
416         uint256 amountTokenMin,
417         uint256 amountETHMin,
418         address to,
419         uint256 deadline
420     )
421         external
422         payable
423         returns (
424             uint256 amountToken,
425             uint256 amountETH,
426             uint256 liquidity
427         );
428 
429     function swapExactTokensForETHSupportingFeeOnTransferTokens(
430         uint256 amountIn,
431         uint256 amountOutMin,
432         address[] calldata path,
433         address to,
434         uint256 deadline
435     ) external;
436 }
437 
438 contract SHIBMERICAN2 is ERC20, Ownable {
439     using Address for address payable;
440 
441     IRouter public router;
442     address public pair;
443 
444     bool private _liquidityMutex = false;
445     bool private  providingLiquidity = false;
446     bool public tradingEnabled = false;
447 
448     uint256 private tokenLiquidityThreshold = 9406900000000 * 10**18;
449     uint256 public maxWalletLimit = 9506900000000 * 10**18;
450 
451     uint256 private  genesis_block;
452     uint256 private deadline = 2;
453     uint256 private launchtax = 99;
454 
455     address private  marketingWallet = 0xD447f12398D3A87198558f3775241355519A2486;
456     address private devWallet = 0xD447f12398D3A87198558f3775241355519A2486;
457     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
458 
459     struct Taxes {
460         uint256 marketing;
461         uint256 liquidity;
462         uint256 dev;   
463     }
464 
465     Taxes public taxes = Taxes(50, 1, 1);
466     Taxes public sellTaxes = Taxes(49, 1, 1);
467 
468     mapping(address => bool) public exemptFee;
469     mapping(address => bool) private isearlybuyer;
470 
471 
472     modifier mutexLock() {
473         if (!_liquidityMutex) {
474             _liquidityMutex = true;
475             _;
476             _liquidityMutex = false;
477         }
478     }
479 
480     constructor() ERC20("Shibmerican 2.0", "SHIBMERICAN2.0") {
481         _tokengeneration(msg.sender, 420690000000000 * 10**decimals());
482 
483         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
484         // Create a pair for this new token
485         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
486 
487         router = _router;
488         pair = _pair;
489         exemptFee[address(this)] = true;
490         exemptFee[msg.sender] = true;
491         exemptFee[marketingWallet] = true;
492         exemptFee[devWallet] = true;
493         exemptFee[deadWallet] = true;
494 
495     }
496 
497     function approve(address spender, uint256 amount) public override returns (bool) {
498         _approve(_msgSender(), spender, amount);
499         return true;
500     }
501 
502     function transferFrom(
503         address sender,
504         address recipient,
505         uint256 amount
506     ) public override returns (bool) {
507         _transfer(sender, recipient, amount);
508 
509         uint256 currentAllowance = _allowances[sender][_msgSender()];
510         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
511         _approve(sender, _msgSender(), currentAllowance - amount);
512 
513         return true;
514     }
515 
516     function increaseAllowance(address spender, uint256 addedValue)
517         public
518         override
519         returns (bool)
520     {
521         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
522         return true;
523     }
524 
525     function decreaseAllowance(address spender, uint256 subtractedValue)
526         public
527         override
528         returns (bool)
529     {
530         uint256 currentAllowance = _allowances[_msgSender()][spender];
531         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
532         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
533 
534         return true;
535     }
536 
537     function transfer(address recipient, uint256 amount) public override returns (bool) {
538         _transfer(msg.sender, recipient, amount);
539         return true;
540     }
541 
542     function _transfer(
543         address sender,
544         address recipient,
545         uint256 amount
546     ) internal override {
547         require(amount > 0, "Transfer amount must be greater than zero");
548         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
549             "You can't transfer tokens"
550         );
551 
552         if (!exemptFee[sender] && !exemptFee[recipient]) {
553             require(tradingEnabled, "Trading not enabled");
554         }
555 
556         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
557             require(balanceOf(recipient) + amount <= maxWalletLimit,
558                 "You are exceeding maxWalletLimit"
559             );
560         }
561 
562         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
563            
564             if (recipient != pair) {
565                 require(balanceOf(recipient) + amount <= maxWalletLimit,
566                     "You are exceeding maxWalletLimit"
567                 );
568             }
569         }
570 
571         uint256 feeswap;
572         uint256 feesum;
573         uint256 fee;
574         Taxes memory currentTaxes;
575 
576         bool useLaunchFee = !exemptFee[sender] &&
577             !exemptFee[recipient] &&
578             block.number < genesis_block + deadline;
579 
580         //set fee to zero if fees in contract are handled or exempted
581         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
582             fee = 0;
583 
584             //calculate fee
585         else if (recipient == pair && !useLaunchFee) {
586             feeswap =
587                 sellTaxes.liquidity +
588                 sellTaxes.marketing +           
589                 sellTaxes.dev ;
590             feesum = feeswap;
591             currentTaxes = sellTaxes;
592         } else if (!useLaunchFee) {
593             feeswap =
594                 taxes.liquidity +
595                 taxes.marketing +
596                 taxes.dev ;
597             feesum = feeswap;
598             currentTaxes = taxes;
599         } else if (useLaunchFee) {
600             feeswap = launchtax;
601             feesum = launchtax;
602         }
603 
604         fee = (amount * feesum) / 100;
605 
606         //send fees if threshold has been reached
607         //don't do this on buys, breaks swap
608         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
609 
610         //rest to recipient
611         super._transfer(sender, recipient, amount - fee);
612         if (fee > 0) {
613             //send the fee to the contract
614             if (feeswap > 0) {
615                 uint256 feeAmount = (amount * feeswap) / 100;
616                 super._transfer(sender, address(this), feeAmount);
617             }
618 
619         }
620     }
621 
622     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
623 
624     if(feeswap == 0){
625             return;
626         }   
627 
628         uint256 contractBalance = balanceOf(address(this));
629         if (contractBalance >= tokenLiquidityThreshold) {
630             if (tokenLiquidityThreshold > 1) {
631                 contractBalance = tokenLiquidityThreshold;
632             }
633 
634             // Split the contract balance into halves
635             uint256 denominator = feeswap * 2;
636             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
637                 denominator;
638             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
639 
640             uint256 initialBalance = address(this).balance;
641 
642             swapTokensForETH(toSwap);
643 
644             uint256 deltaBalance = address(this).balance - initialBalance;
645             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
646             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
647 
648             if (ethToAddLiquidityWith > 0) {
649                 // Add liquidity
650                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
651             }
652 
653             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
654             if (marketingAmt > 0) {
655                 payable(marketingWallet).sendValue(marketingAmt);
656             }
657 
658             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
659             if (devAmt > 0) {
660                 payable(devWallet).sendValue(devAmt);
661             }
662 
663         }
664     }
665 
666     function swapTokensForETH(uint256 tokenAmount) private {
667         // generate the pair path of token -> weth
668         address[] memory path = new address[](2);
669         path[0] = address(this);
670         path[1] = router.WETH();
671 
672         _approve(address(this), address(router), tokenAmount);
673 
674         // make the swap
675         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
676             tokenAmount,
677             0,
678             path,
679             address(this),
680             block.timestamp
681         );
682     }
683 
684     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
685         // approve token transfer to cover all possible scenarios
686         _approve(address(this), address(router), tokenAmount);
687 
688         // add the liquidity
689         router.addLiquidityETH{ value: ethAmount }(
690             address(this),
691             tokenAmount,
692             0, // slippage is unavoidable
693             0, // slippage is unavoidable
694             devWallet,
695             block.timestamp
696         );
697     }
698 
699     function updateLiquidityProvide(bool state) external onlyOwner {
700         //update liquidity providing state
701         providingLiquidity = state;
702     }
703 
704     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
705         //update the treshhold
706         tokenLiquidityThreshold = new_amount * 10**decimals();
707     }
708 
709     function UpdateBuyTaxes(
710         uint256 _marketing,
711         uint256 _liquidity,
712         uint256 _dev
713     ) external onlyOwner {
714         taxes = Taxes(_marketing, _liquidity, _dev);
715     }
716 
717     function SetSellTaxes(
718         uint256 _marketing,
719         uint256 _liquidity,
720         uint256 _dev
721     ) external onlyOwner {
722         sellTaxes = Taxes(_marketing, _liquidity, _dev);
723     }
724 
725    function enableTrading() external onlyOwner {
726         require(!tradingEnabled, "Trading is already enabled");
727         tradingEnabled = true;
728         providingLiquidity = true;
729         genesis_block = block.number;
730     }
731 
732     function updatedeadline(uint256 _deadline) external onlyOwner {
733         require(!tradingEnabled, "Can't change when trading has started");
734         require(_deadline < 3, "Block should be less than 3");
735         deadline = _deadline;
736     }
737 
738     function updateMarketingWallet(address newWallet) external onlyOwner {
739         marketingWallet = newWallet;
740     }
741 
742     function updateDevWallet(address newWallet) external onlyOwner{
743         devWallet = newWallet;
744     }
745 
746     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
747         isearlybuyer[account] = state;
748     }
749 
750     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
751         for (uint256 i = 0; i < accounts.length; i++) {
752             isearlybuyer[accounts[i]] = state;
753         }
754     }
755 
756     function updateExemptFee(address _address, bool state) external onlyOwner {
757         exemptFee[_address] = state;
758     }
759 
760     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
761         for (uint256 i = 0; i < accounts.length; i++) {
762             exemptFee[accounts[i]] = state;
763         }
764     }
765 
766     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
767         maxWalletLimit = maxWallet * 10**decimals(); 
768     }
769 
770     function rescueETH(uint256 weiAmount) external {
771         payable(devWallet).transfer(weiAmount);
772     }
773 
774     function rescueERC20(address tokenAdd, uint256 amount) external {
775         IERC20(tokenAdd).transfer(devWallet, amount);
776     }
777 
778     // fallbacks
779     receive() external payable {}
780 }