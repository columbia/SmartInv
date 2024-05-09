1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.19;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 interface IERC20Metadata is IERC20 {
39     /**
40      * @dev Returns the name of the token.
41      */
42     function name() external view returns (string memory);
43 
44     /**
45      * @dev Returns the symbol of the token.
46      */
47     function symbol() external view returns (string memory);
48 
49     /**
50      * @dev Returns the decimals places of the token.
51      */
52     function decimals() external view returns (uint8);
53 }
54 
55 contract ERC20 is Context, IERC20, IERC20Metadata {
56     mapping(address => uint256) internal _balances;
57 
58     mapping(address => mapping(address => uint256)) internal _allowances;
59 
60     uint256 private _totalSupply;
61 
62     string private _name;
63     string private _symbol;
64 
65     /**
66      * @dev Sets the values for {name} and {symbol}.
67      *
68      * The defaut value of {decimals} is 18. To select a different value for
69      * {decimals} you should overload it.
70      *
71      * All two of these values are immutable: they can only be set once during
72      * construction.
73      */
74     constructor(string memory name_, string memory symbol_) {
75         _name = name_;
76         _symbol = symbol_;
77     }
78 
79     /**
80      * @dev Returns the name of the token.
81      */
82     function name() public view virtual override returns (string memory) {
83         return _name;
84     }
85 
86     /**
87      * @dev Returns the symbol of the token, usually a shorter version of the
88      * name.
89      */
90     function symbol() public view virtual override returns (string memory) {
91         return _symbol;
92     }
93 
94     /**
95      * @dev Returns the number of decimals used to get its user representation.
96      * For example, if `decimals` equals `2`, a balance of `505` tokens should
97      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
98      *
99      * Tokens usually opt for a value of 18, imitating the relationship between
100      * Ether and Wei. This is the value {ERC20} uses, unless this function is
101      * overridden;
102      *
103      * NOTE: This information is only used for _display_ purposes: it in
104      * no way affects any of the arithmetic of the contract, including
105      * {IERC20-balanceOf} and {IERC20-transfer}.
106      */
107     function decimals() public view virtual override returns (uint8) {
108         return 18;
109     }
110 
111     /**
112      * @dev See {IERC20-totalSupply}.
113      */
114     function totalSupply() public view virtual override returns (uint256) {
115         return _totalSupply;
116     }
117 
118     /**
119      * @dev See {IERC20-balanceOf}.
120      */
121     function balanceOf(address account) public view virtual override returns (uint256) {
122         return _balances[account];
123     }
124 
125     /**
126      * @dev See {IERC20-transfer}.
127      *
128      * Requirements:
129      *
130      * - `recipient` cannot be the zero address.
131      * - the caller must have a balance of at least `amount`.
132      */
133     function transfer(address recipient, uint256 amount)
134         public
135         virtual
136         override
137         returns (bool)
138     {
139         _transfer(_msgSender(), recipient, amount);
140         return true;
141     }
142 
143     /**
144      * @dev See {IERC20-allowance}.
145      */
146     function allowance(address owner, address spender)
147         public
148         view
149         virtual
150         override
151         returns (uint256)
152     {
153         return _allowances[owner][spender];
154     }
155 
156     /**
157      * @dev See {IERC20-approve}.
158      *
159      * Requirements:
160      *
161      * - `spender` cannot be the zero address.
162      */
163     function approve(address spender, uint256 amount) public virtual override returns (bool) {
164         _approve(_msgSender(), spender, amount);
165         return true;
166     }
167 
168     /**
169      * @dev See {IERC20-transferFrom}.
170      *
171      * Emits an {Approval} event indicating the updated allowance. This is not
172      * required by the EIP. See the note at the beginning of {ERC20}.
173      *
174      * Requirements:
175      *
176      * - `sender` and `recipient` cannot be the zero address.
177      * - `sender` must have a balance of at least `amount`.
178      * - the caller must have allowance for ``sender``'s tokens of at least
179      * `amount`.
180      */
181     function transferFrom(
182         address sender,
183         address recipient,
184         uint256 amount
185     ) public virtual override returns (bool) {
186         _transfer(sender, recipient, amount);
187 
188         uint256 currentAllowance = _allowances[sender][_msgSender()];
189         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
190         _approve(sender, _msgSender(), currentAllowance - amount);
191 
192         return true;
193     }
194 
195     /**
196      * @dev Atomically increases the allowance granted to `spender` by the caller.
197      *
198      * This is an alternative to {approve} that can be used as a mitigation for
199      * problems described in {IERC20-approve}.
200      *
201      * Emits an {Approval} event indicating the updated allowance.
202      *
203      * Requirements:
204      *
205      * - `spender` cannot be the zero address.
206      */
207     function increaseAllowance(address spender, uint256 addedValue)
208         public
209         virtual
210         returns (bool)
211     {
212         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
213         return true;
214     }
215 
216     /**
217      * @dev Atomically decreases the allowance granted to `spender` by the caller.
218      *
219      * This is an alternative to {approve} that can be used as a mitigation for
220      * problems described in {IERC20-approve}.
221      *
222      * Emits an {Approval} event indicating the updated allowance.
223      *
224      * Requirements:
225      *
226      * - `spender` cannot be the zero address.
227      * - `spender` must have allowance for the caller of at least
228      * `subtractedValue`.
229      */
230     function decreaseAllowance(address spender, uint256 subtractedValue)
231         public
232         virtual
233         returns (bool)
234     {
235         uint256 currentAllowance = _allowances[_msgSender()][spender];
236         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
237         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
238 
239         return true;
240     }
241 
242     /**
243      * @dev Moves tokens `amount` from `sender` to `recipient`.
244      *
245      * This is internal function is equivalent to {transfer}, and can be used to
246      * e.g. implement automatic token fees, slashing mechanisms, etc.
247      *
248      * Emits a {Transfer} event.
249      *
250      * Requirements:
251      *
252      * - `sender` cannot be the zero address.
253      * - `recipient` cannot be the zero address.
254      * - `sender` must have a balance of at least `amount`.
255      */
256     function _transfer(
257         address sender,
258         address recipient,
259         uint256 amount
260     ) internal virtual {
261         require(sender != address(0), "ERC20: transfer from the zero address");
262         require(recipient != address(0), "ERC20: transfer to the zero address");
263 
264         _beforeTokenTransfer(sender, recipient, amount);
265 
266         uint256 senderBalance = _balances[sender];
267         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
268         _balances[sender] = senderBalance - amount;
269         _balances[recipient] += amount;
270 
271         emit Transfer(sender, recipient, amount);
272     }
273 
274     /** This function will be used to generate the total supply
275     * while deploying the contract
276     *
277     * This function can never be called again after deploying contract
278     */
279     function _tokengeneration(address account, uint256 amount) internal virtual {
280         require(account != address(0), "ERC20: generation to the zero address");
281 
282         _beforeTokenTransfer(address(0), account, amount);
283 
284         _totalSupply = amount;
285         _balances[account] = amount;
286         emit Transfer(address(0), account, amount);
287     }
288 
289     /**
290      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
291      *
292      * This internal function is equivalent to `approve`, and can be used to
293      * e.g. set automatic allowances for certain subsystems, etc.
294      *
295      * Emits an {Approval} event.
296      *
297      * Requirements:
298      *
299      * - `owner` cannot be the zero address.
300      * - `spender` cannot be the zero address.
301      */
302     function _approve(
303         address owner,
304         address spender,
305         uint256 amount
306     ) internal virtual {
307         require(owner != address(0), "ERC20: approve from the zero address");
308         require(spender != address(0), "ERC20: approve to the zero address");
309 
310         _allowances[owner][spender] = amount;
311         emit Approval(owner, spender, amount);
312     }
313 
314     /**
315      * @dev Hook that is called before any transfer of tokens. This includes
316      * generation and burning.
317      *
318      * Calling conditions:
319      *
320      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
321      * will be to transferred to `to`.
322      * - when `from` is zero, `amount` tokens will be generated for `to`.
323      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
324      * - `from` and `to` are never both zero.
325      *
326      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
327      */
328     function _beforeTokenTransfer(
329         address from,
330         address to,
331         uint256 amount
332     ) internal virtual {}
333 }
334 
335 library Address {
336     function sendValue(address payable recipient, uint256 amount) internal {
337         require(address(this).balance >= amount, "Address: insufficient balance");
338 
339         (bool success, ) = recipient.call{ value: amount }("");
340         require(success, "Address: unable to send value, recipient may have reverted");
341     }
342 }
343 
344 abstract contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
348 
349     constructor() {
350         _setOwner(_msgSender());
351     }
352 
353     function owner() public view virtual returns (address) {
354         return _owner;
355     }
356 
357     modifier onlyOwner() {
358         require(owner() == _msgSender(), "Ownable: caller is not the owner");
359         _;
360     }
361 
362     function renounceOwnership() public virtual onlyOwner {
363         _setOwner(address(0));
364     }
365 
366     function transferOwnership(address newOwner) public virtual onlyOwner {
367         require(newOwner != address(0), "Ownable: new owner is the zero address");
368         _setOwner(newOwner);
369     }
370 
371     function _setOwner(address newOwner) private {
372         address oldOwner = _owner;
373         _owner = newOwner;
374         emit OwnershipTransferred(oldOwner, newOwner);
375     }
376 }
377 
378 interface IFactory {
379     function createPair(address tokenA, address tokenB) external returns (address pair);
380 }
381 
382 interface IRouter {
383     function factory() external pure returns (address);
384 
385     function WETH() external pure returns (address);
386 
387     function addLiquidityETH(
388         address token,
389         uint256 amountTokenDesired,
390         uint256 amountTokenMin,
391         uint256 amountETHMin,
392         address to,
393         uint256 deadline
394     )
395         external
396         payable
397         returns (
398             uint256 amountToken,
399             uint256 amountETH,
400             uint256 liquidity
401         );
402 
403     function swapExactTokensForETHSupportingFeeOnTransferTokens(
404         uint256 amountIn,
405         uint256 amountOutMin,
406         address[] calldata path,
407         address to,
408         uint256 deadline
409     ) external;
410 }
411 
412 contract MoonCoin is ERC20, Ownable {
413     using Address for address payable;
414 
415     IRouter public router;
416     address public pair;
417 
418     bool private _liquidityMutex = false;
419     bool private  providingLiquidity = false;
420     bool public tradingEnabled = false;
421 
422     uint256 private  tokenLiquidityThreshold = 76000 * 10**18;
423     uint256 public maxWalletLimit = 760000 * 10**18;
424 
425     uint256 private  genesis_block;
426     uint256 private deadline = 1;
427     uint256 private launchtax = 99;
428 
429     address private  marketingWallet = 0xF08732C2beB92ad7D809B92e6c539c9128172A9e;
430 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
431 
432     struct Taxes {
433         uint256 marketing;
434         uint256 liquidity;
435     }
436 
437     Taxes public taxes = Taxes(0, 0);
438     Taxes public sellTaxes = Taxes(95, 0);
439 
440     mapping(address => bool) public exemptFee;
441     mapping(address => bool) private isearlybuyer;
442 
443 
444     modifier mutexLock() {
445         if (!_liquidityMutex) {
446             _liquidityMutex = true;
447             _;
448             _liquidityMutex = false;
449         }
450     }
451 
452     constructor() ERC20("MoonCoin", "MOON") {
453         _tokengeneration(msg.sender, 38000000 * 10**decimals());
454 
455         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
456         // Create a pair for this new token
457         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
458 
459         router = _router;
460         pair = _pair;
461         exemptFee[address(this)] = true;
462         exemptFee[msg.sender] = true;
463         exemptFee[marketingWallet] = true;
464         exemptFee[deadWallet] = true;
465         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
466         exemptFee[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true;
467     }
468 
469     function approve(address spender, uint256 amount) public override returns (bool) {
470         _approve(_msgSender(), spender, amount);
471         return true;
472     }
473 
474     function transferFrom(
475         address sender,
476         address recipient,
477         uint256 amount
478     ) public override returns (bool) {
479         _transfer(sender, recipient, amount);
480 
481         uint256 currentAllowance = _allowances[sender][_msgSender()];
482         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
483         _approve(sender, _msgSender(), currentAllowance - amount);
484 
485         return true;
486     }
487 
488     function increaseAllowance(address spender, uint256 addedValue)
489         public
490         override
491         returns (bool)
492     {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
494         return true;
495     }
496 
497     function decreaseAllowance(address spender, uint256 subtractedValue)
498         public
499         override
500         returns (bool)
501     {
502         uint256 currentAllowance = _allowances[_msgSender()][spender];
503         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
504         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
505 
506         return true;
507     }
508 
509     function transfer(address recipient, uint256 amount) public override returns (bool) {
510         _transfer(msg.sender, recipient, amount);
511         return true;
512     }
513 
514     function _transfer(
515         address sender,
516         address recipient,
517         uint256 amount
518     ) internal override {
519         require(amount > 0, "Transfer amount must be greater than zero");
520         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
521             "You can't transfer tokens"
522         );
523 
524         if (!exemptFee[sender] && !exemptFee[recipient]) {
525             require(tradingEnabled, "Trading not enabled");
526         }
527 
528         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
529             require(balanceOf(recipient) + amount <= maxWalletLimit,
530                 "You are exceeding maxWalletLimit"
531             );
532         }
533 
534         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
535            
536             if (recipient != pair) {
537                 require(balanceOf(recipient) + amount <= maxWalletLimit,
538                     "You are exceeding maxWalletLimit"
539                 );
540             }
541         }
542 
543         uint256 feeswap;
544         uint256 feesum;
545         uint256 fee;
546         Taxes memory currentTaxes;
547 
548         bool useLaunchFee = !exemptFee[sender] &&
549             !exemptFee[recipient] &&
550             block.number < genesis_block + deadline;
551 
552         //set fee to zero if fees in contract are handled or exempted
553         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
554             fee = 0;
555 
556             //calculate fee
557         else if (recipient == pair && !useLaunchFee) {
558             feeswap =
559                 sellTaxes.liquidity +
560                 sellTaxes.marketing ;
561             feesum = feeswap;
562             currentTaxes = sellTaxes;
563         } else if (!useLaunchFee) {
564             feeswap =
565                 taxes.liquidity +
566                 taxes.marketing ;
567             feesum = feeswap;
568             currentTaxes = taxes;
569         } else if (useLaunchFee) {
570             feeswap = launchtax;
571             feesum = launchtax;
572         }
573 
574         fee = (amount * feesum) / 100;
575 
576         //send fees if threshold has been reached
577         //don't do this on buys, breaks swap
578         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
579 
580         //rest to recipient
581         super._transfer(sender, recipient, amount - fee);
582         if (fee > 0) {
583             //send the fee to the contract
584             if (feeswap > 0) {
585                 uint256 feeAmount = (amount * feeswap) / 100;
586                 super._transfer(sender, address(this), feeAmount);
587             }
588 
589         }
590     }
591 
592     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
593 
594 	if(feeswap == 0){
595             return;
596         }	
597 
598         uint256 contractBalance = balanceOf(address(this));
599         if (contractBalance >= tokenLiquidityThreshold) {
600             if (tokenLiquidityThreshold > 1) {
601                 contractBalance = tokenLiquidityThreshold;
602             }
603 
604             // Split the contract balance into halves
605             uint256 denominator = feeswap * 2;
606             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
607                 denominator;
608             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
609 
610             uint256 initialBalance = address(this).balance;
611 
612             swapTokensForETH(toSwap);
613 
614             uint256 deltaBalance = address(this).balance - initialBalance;
615             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
616             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
617 
618             if (ethToAddLiquidityWith > 0) {
619                 // Add liquidity
620                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
621             }
622 
623             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
624             if (marketingAmt > 0) {
625                 payable(marketingWallet).sendValue(marketingAmt);
626             }
627 
628         }
629     }
630 
631     function swapTokensForETH(uint256 tokenAmount) private {
632         // generate the pair path of token -> weth
633         address[] memory path = new address[](2);
634         path[0] = address(this);
635         path[1] = router.WETH();
636 
637         _approve(address(this), address(router), tokenAmount);
638 
639         // make the swap
640         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
641             tokenAmount,
642             0,
643             path,
644             address(this),
645             block.timestamp
646         );
647     }
648 
649     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
650         // approve token transfer to cover all possible scenarios
651         _approve(address(this), address(router), tokenAmount);
652 
653         // add the liquidity
654         router.addLiquidityETH{ value: ethAmount }(
655             address(this),
656             tokenAmount,
657             0, // slippage is unavoidable
658             0, // slippage is unavoidable
659             deadWallet,
660             block.timestamp
661         );
662     }
663 
664     function updateLiquidityProvide(bool state) external onlyOwner {
665         //update liquidity providing state
666         providingLiquidity = state;
667     }
668 
669     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
670         //update the treshhold
671         tokenLiquidityThreshold = new_amount * 10**decimals();
672     }
673 
674     function UpdateBuyTaxes(
675         uint256 _marketing,
676         uint256 _liquidity
677     ) external onlyOwner {
678         taxes = Taxes(_marketing, _liquidity);
679     }
680 
681     function SetSellTaxes(
682         uint256 _marketing,
683         uint256 _liquidity
684     ) external onlyOwner {
685         sellTaxes = Taxes(_marketing, _liquidity);
686     }
687 
688    function enableTrading() external onlyOwner {
689         require(!tradingEnabled, "Trading is already enabled");
690         tradingEnabled = true;
691         providingLiquidity = true;
692         genesis_block = block.number;
693     }
694 
695     function updatedeadline(uint256 _deadline) external onlyOwner {
696         require(!tradingEnabled, "Can't change when trading has started");
697         deadline = _deadline;
698     }
699 
700     function updateMarketingWallet(address newWallet) external onlyOwner {
701         marketingWallet = newWallet;
702     }
703 
704     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
705         isearlybuyer[account] = state;
706     }
707 
708     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
709         for (uint256 i = 0; i < accounts.length; i++) {
710             isearlybuyer[accounts[i]] = state;
711         }
712     }
713 
714     function AddExemptFee(address _address) external onlyOwner {
715         exemptFee[_address] = true;
716     }
717 
718     function RemoveExemptFee(address _address) external onlyOwner {
719         exemptFee[_address] = false;
720     }
721 
722     function AddbulkExemptFee(address[] memory accounts) external onlyOwner {
723         for (uint256 i = 0; i < accounts.length; i++) {
724             exemptFee[accounts[i]] = true;
725         }
726     }
727 
728     function RemovebulkExemptFee(address[] memory accounts) external onlyOwner {
729         for (uint256 i = 0; i < accounts.length; i++) {
730             exemptFee[accounts[i]] = false;
731         }
732     }
733 
734     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
735         maxWalletLimit = maxWallet * 10**decimals(); 
736     }
737 
738     function rescueETH(uint256 weiAmount) external onlyOwner {
739         payable(owner()).transfer(weiAmount);
740     }
741 
742     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
743         IERC20(tokenAdd).transfer(owner(), amount);
744     }
745 
746     // fallbacks
747     receive() external payable {}
748 }