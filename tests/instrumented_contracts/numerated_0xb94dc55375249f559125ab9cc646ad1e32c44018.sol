1 //SPDX-License-Identifier: UNLICENSED
2 
3 // "I AM BECOME MEME, DESTROYER OF SHORTS" - ELON MUSK
4 
5 // Missed $MUSK? Do NOT miss $MUSK2.0!
6 
7 // Telegram: t.me/muskcoin20
8 
9 
10 pragma solidity ^0.8.19;
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
419 contract ElonMusk20 is ERC20, Ownable {
420     using Address for address payable;
421 
422     IRouter public router;
423     address public pair;
424 
425     bool private _liquidityMutex = false;
426     bool private  providingLiquidity = false;
427     bool public tradingEnabled = false;
428 
429     uint256 private  tokenLiquidityThreshold = 2000000 * 10**18;
430     uint256 public maxWalletLimit = 20000000 * 10**18;
431 
432     uint256 private  genesis_block;
433     uint256 private deadline = 1;
434     uint256 private launchtax = 95;
435 
436     address private  marketingWallet = 0x288Bb1C9C3d133C377F496b2ABB91595b06FC77E;
437 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
438 
439     struct Taxes {
440         uint256 marketing;
441         uint256 liquidity;
442     }
443 
444     Taxes public taxes = Taxes(15, 0);
445     Taxes public sellTaxes = Taxes(25, 0);
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
459     constructor() ERC20("Elon Musk2.0", "MUSK2.0") {
460         _tokengeneration(msg.sender, 1000000000 * 10**decimals());
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
471         exemptFee[deadWallet] = true;
472         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
473         exemptFee[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true;
474     }
475 
476     function approve(address spender, uint256 amount) public override returns (bool) {
477         _approve(_msgSender(), spender, amount);
478         return true;
479     }
480 
481     function transferFrom(
482         address sender,
483         address recipient,
484         uint256 amount
485     ) public override returns (bool) {
486         _transfer(sender, recipient, amount);
487 
488         uint256 currentAllowance = _allowances[sender][_msgSender()];
489         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
490         _approve(sender, _msgSender(), currentAllowance - amount);
491 
492         return true;
493     }
494 
495     function increaseAllowance(address spender, uint256 addedValue)
496         public
497         override
498         returns (bool)
499     {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
501         return true;
502     }
503 
504     function decreaseAllowance(address spender, uint256 subtractedValue)
505         public
506         override
507         returns (bool)
508     {
509         uint256 currentAllowance = _allowances[_msgSender()][spender];
510         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
511         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
512 
513         return true;
514     }
515 
516     function transfer(address recipient, uint256 amount) public override returns (bool) {
517         _transfer(msg.sender, recipient, amount);
518         return true;
519     }
520 
521     function _transfer(
522         address sender,
523         address recipient,
524         uint256 amount
525     ) internal override {
526         require(amount > 0, "Transfer amount must be greater than zero");
527         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
528             "You can't transfer tokens"
529         );
530 
531         if (!exemptFee[sender] && !exemptFee[recipient]) {
532             require(tradingEnabled, "Trading not enabled");
533         }
534 
535         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
536             require(balanceOf(recipient) + amount <= maxWalletLimit,
537                 "You are exceeding maxWalletLimit"
538             );
539         }
540 
541         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
542            
543             if (recipient != pair) {
544                 require(balanceOf(recipient) + amount <= maxWalletLimit,
545                     "You are exceeding maxWalletLimit"
546                 );
547             }
548         }
549 
550         uint256 feeswap;
551         uint256 feesum;
552         uint256 fee;
553         Taxes memory currentTaxes;
554 
555         bool useLaunchFee = !exemptFee[sender] &&
556             !exemptFee[recipient] &&
557             block.number < genesis_block + deadline;
558 
559         //set fee to zero if fees in contract are handled or exempted
560         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
561             fee = 0;
562 
563             //calculate fee
564         else if (recipient == pair && !useLaunchFee) {
565             feeswap =
566                 sellTaxes.liquidity +
567                 sellTaxes.marketing ;
568             feesum = feeswap;
569             currentTaxes = sellTaxes;
570         } else if (!useLaunchFee) {
571             feeswap =
572                 taxes.liquidity +
573                 taxes.marketing ;
574             feesum = feeswap;
575             currentTaxes = taxes;
576         } else if (useLaunchFee) {
577             feeswap = launchtax;
578             feesum = launchtax;
579         }
580 
581         fee = (amount * feesum) / 100;
582 
583         //send fees if threshold has been reached
584         //don't do this on buys, breaks swap
585         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
586 
587         //rest to recipient
588         super._transfer(sender, recipient, amount - fee);
589         if (fee > 0) {
590             //send the fee to the contract
591             if (feeswap > 0) {
592                 uint256 feeAmount = (amount * feeswap) / 100;
593                 super._transfer(sender, address(this), feeAmount);
594             }
595 
596         }
597     }
598 
599     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
600 
601 	if(feeswap == 0){
602             return;
603         }	
604 
605         uint256 contractBalance = balanceOf(address(this));
606         if (contractBalance >= tokenLiquidityThreshold) {
607             if (tokenLiquidityThreshold > 1) {
608                 contractBalance = tokenLiquidityThreshold;
609             }
610 
611             // Split the contract balance into halves
612             uint256 denominator = feeswap * 2;
613             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
614                 denominator;
615             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
616 
617             uint256 initialBalance = address(this).balance;
618 
619             swapTokensForETH(toSwap);
620 
621             uint256 deltaBalance = address(this).balance - initialBalance;
622             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
623             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
624 
625             if (ethToAddLiquidityWith > 0) {
626                 // Add liquidity
627                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
628             }
629 
630             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
631             if (marketingAmt > 0) {
632                 payable(marketingWallet).sendValue(marketingAmt);
633             }
634 
635         }
636     }
637 
638     function swapTokensForETH(uint256 tokenAmount) private {
639         // generate the pair path of token -> weth
640         address[] memory path = new address[](2);
641         path[0] = address(this);
642         path[1] = router.WETH();
643 
644         _approve(address(this), address(router), tokenAmount);
645 
646         // make the swap
647         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
648             tokenAmount,
649             0,
650             path,
651             address(this),
652             block.timestamp
653         );
654     }
655 
656     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
657         // approve token transfer to cover all possible scenarios
658         _approve(address(this), address(router), tokenAmount);
659 
660         // add the liquidity
661         router.addLiquidityETH{ value: ethAmount }(
662             address(this),
663             tokenAmount,
664             0, // slippage is unavoidable
665             0, // slippage is unavoidable
666             deadWallet,
667             block.timestamp
668         );
669     }
670 
671     function updateLiquidityProvide(bool state) external onlyOwner {
672         //update liquidity providing state
673         providingLiquidity = state;
674     }
675 
676     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
677         //update the treshhold
678         tokenLiquidityThreshold = new_amount * 10**decimals();
679     }
680 
681     function UpdateBuyTaxes(
682         uint256 _marketing,
683         uint256 _liquidity
684     ) external onlyOwner {
685         taxes = Taxes(_marketing, _liquidity);
686     }
687 
688     function SetSellTaxes(
689         uint256 _marketing,
690         uint256 _liquidity
691     ) external onlyOwner {
692         sellTaxes = Taxes(_marketing, _liquidity);
693     }
694 
695    function enableTrading() external onlyOwner {
696         require(!tradingEnabled, "Trading is already enabled");
697         tradingEnabled = true;
698         providingLiquidity = true;
699         genesis_block = block.number;
700     }
701 
702     function updatedeadline(uint256 _deadline) external onlyOwner {
703         require(!tradingEnabled, "Can't change when trading has started");
704         deadline = _deadline;
705     }
706 
707     function updateMarketingWallet(address newWallet) external onlyOwner {
708         marketingWallet = newWallet;
709     }
710 
711     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
712         isearlybuyer[account] = state;
713     }
714 
715     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
716         for (uint256 i = 0; i < accounts.length; i++) {
717             isearlybuyer[accounts[i]] = state;
718         }
719     }
720 
721     function AddExemptFee(address _address) external onlyOwner {
722         exemptFee[_address] = true;
723     }
724 
725     function RemoveExemptFee(address _address) external onlyOwner {
726         exemptFee[_address] = false;
727     }
728 
729     function AddbulkExemptFee(address[] memory accounts) external onlyOwner {
730         for (uint256 i = 0; i < accounts.length; i++) {
731             exemptFee[accounts[i]] = true;
732         }
733     }
734 
735     function RemovebulkExemptFee(address[] memory accounts) external onlyOwner {
736         for (uint256 i = 0; i < accounts.length; i++) {
737             exemptFee[accounts[i]] = false;
738         }
739     }
740 
741     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
742         maxWalletLimit = maxWallet * 10**decimals(); 
743     }
744 
745     function rescueETH(uint256 weiAmount) external onlyOwner {
746         payable(owner()).transfer(weiAmount);
747     }
748 
749     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
750         IERC20(tokenAdd).transfer(owner(), amount);
751     }
752 
753     // fallbacks
754     receive() external payable {}
755 }