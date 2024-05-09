1 /**
2  *Submitted for verification at Etherscan.io on 2023-06-26
3 */
4 
5 //SPDX-License-Identifier: UNLICENSED
6 
7 pragma solidity ^0.8.7;
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
268         _beforeTokenTransfer(sender, recipient, amount);
269 
270         uint256 senderBalance = _balances[sender];
271         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
272         _balances[sender] = senderBalance - amount;
273         _balances[recipient] += amount;
274 
275         emit Transfer(sender, recipient, amount);
276     }
277 
278     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
279      * the total supply.
280      *
281      * Emits a {Transfer} event with `from` set to the zero address.
282      *
283      * Requirements:
284      *
285      * - `to` cannot be the zero address.
286      */
287     function _tokengeneration(address account, uint256 amount) internal virtual {
288         require(account != address(0), "ERC20: generation to the zero address");
289 
290         _beforeTokenTransfer(address(0), account, amount);
291 
292         _totalSupply = amount;
293         _balances[account] = amount;
294         emit Transfer(address(0), account, amount);
295     }
296 
297     /**
298      * @dev Destroys `amount` tokens from `account`, reducing the
299      * total supply.
300      *
301      * Emits a {Transfer} event with `to` set to the zero address.
302      *
303      * Requirements:
304      *
305      * - `account` cannot be the zero address.
306      * - `account` must have at least `amount` tokens.
307      */
308     function _burn(address account, uint256 amount) internal virtual {
309         require(account != address(0), "ERC20: burn from the zero address");
310 
311         _beforeTokenTransfer(account, address(0), amount);
312 
313         uint256 accountBalance = _balances[account];
314         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
315         _balances[account] = accountBalance - amount;
316         _totalSupply -= amount;
317 
318         emit Transfer(account, address(0), amount);
319     }
320 
321     /**
322      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
323      *
324      * This internal function is equivalent to `approve`, and can be used to
325      * e.g. set automatic allowances for certain subsystems, etc.
326      *
327      * Emits an {Approval} event.
328      *
329      * Requirements:
330      *
331      * - `owner` cannot be the zero address.
332      * - `spender` cannot be the zero address.
333      */
334     function _approve(
335         address owner,
336         address spender,
337         uint256 amount
338     ) internal virtual {
339         require(owner != address(0), "ERC20: approve from the zero address");
340         require(spender != address(0), "ERC20: approve to the zero address");
341 
342         _allowances[owner][spender] = amount;
343         emit Approval(owner, spender, amount);
344     }
345 
346     /**
347      * @dev Hook that is called before any transfer of tokens. This includes
348      * generation and burning.
349      *
350      * Calling conditions:
351      *
352      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
353      * will be to transferred to `to`.
354      * - when `from` is zero, `amount` tokens will be generated for `to`.
355      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
356      * - `from` and `to` are never both zero.
357      *
358      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
359      */
360     function _beforeTokenTransfer(
361         address from,
362         address to,
363         uint256 amount
364     ) internal virtual {}
365 }
366 
367 library Address {
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         (bool success, ) = recipient.call{ value: amount }("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 }
375 
376 abstract contract Ownable is Context {
377     address private _owner;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381     constructor() {
382         _setOwner(_msgSender());
383     }
384 
385     function owner() public view virtual returns (address) {
386         return _owner;
387     }
388 
389     modifier onlyOwner() {
390         require(owner() == _msgSender(), "Ownable: caller is not the owner");
391         _;
392     }
393 
394     function renounceOwnership() public virtual onlyOwner {
395         _setOwner(address(0));
396     }
397 
398     function transferOwnership(address newOwner) public virtual onlyOwner {
399         require(newOwner != address(0), "Ownable: new owner is the zero address");
400         _setOwner(newOwner);
401     }
402 
403     function _setOwner(address newOwner) private {
404         address oldOwner = _owner;
405         _owner = newOwner;
406         emit OwnershipTransferred(oldOwner, newOwner);
407     }
408 }
409 
410 interface IFactory {
411     function createPair(address tokenA, address tokenB) external returns (address pair);
412 }
413 
414 interface IRouter {
415     function factory() external pure returns (address);
416 
417     function WETH() external pure returns (address);
418 
419     function addLiquidityETH(
420         address token,
421         uint256 amountTokenDesired,
422         uint256 amountTokenMin,
423         uint256 amountETHMin,
424         address to,
425         uint256 deadline
426     )
427         external
428         payable
429         returns (
430             uint256 amountToken,
431             uint256 amountETH,
432             uint256 liquidity
433         );
434 
435     function swapExactTokensForETHSupportingFeeOnTransferTokens(
436         uint256 amountIn,
437         uint256 amountOutMin,
438         address[] calldata path,
439         address to,
440         uint256 deadline
441     ) external;
442 }
443 
444 contract RAMBE is ERC20, Ownable {
445     using Address for address payable;
446 
447     IRouter public router;
448     address public pair;
449 
450     bool private _liquidityMutex = false;
451     bool private providingLiquidity = false;
452     bool public tradingEnabled = false;
453 
454     uint256 public ThresholdAmount = 2e7 * 10**18;
455 
456     uint256 public genesis_block;
457     uint256 private deadline = 1;
458 
459     address public marketingWallet = 0xa0E13E7CA54274173931349e4c3DA1223d4F701d;
460     address public burnWallet = 0x000000000000000000000000000000000000dEaD;
461 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
462 
463     struct Taxes {
464         uint256 marketing;
465         uint256 liquidity;
466         uint256 burnTax;   
467     }
468 
469     Taxes public buyTaxes = Taxes(2, 1, 1);
470     Taxes public sellTaxes = Taxes(3, 2, 1);
471 
472     mapping(address => bool) public exemptFee;
473 
474     modifier mutexLock() {
475         if (!_liquidityMutex) {
476             _liquidityMutex = true;
477             _;
478             _liquidityMutex = false;
479         }
480     }
481 
482     constructor() ERC20("HARAMBE Token", "RAMBE") {
483         _tokengeneration(msg.sender, 1e9 * 10**decimals());
484 
485         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
486         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
487 
488         router = _router;
489         pair = _pair;
490         exemptFee[address(this)] = true;
491         exemptFee[msg.sender] = true;
492         exemptFee[marketingWallet] = true;
493         exemptFee[burnWallet] = true;
494         exemptFee[deadWallet] = true;
495 
496     }
497 
498     function approve(address spender, uint256 amount) public override returns (bool) {
499         _approve(_msgSender(), spender, amount);
500         return true;
501     }
502 
503     function transferFrom(
504         address sender,
505         address recipient,
506         uint256 amount
507     ) public override returns (bool) {
508         _transfer(sender, recipient, amount);
509 
510         uint256 currentAllowance = _allowances[sender][_msgSender()];
511         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
512         _approve(sender, _msgSender(), currentAllowance - amount);
513 
514         return true;
515     }
516 
517     function increaseAllowance(address spender, uint256 addedValue)
518         public
519         override
520         returns (bool)
521     {
522         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
523         return true;
524     }
525 
526     function decreaseAllowance(address spender, uint256 subtractedValue)
527         public
528         override
529         returns (bool)
530     {
531         uint256 currentAllowance = _allowances[_msgSender()][spender];
532         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
533         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
534 
535         return true;
536     }
537 
538     function transfer(address recipient, uint256 amount) public override returns (bool) {
539         _transfer(msg.sender, recipient, amount);
540         return true;
541     }
542 
543     function _transfer(
544         address sender,
545         address recipient,
546         uint256 amount
547     ) internal override {
548         require(amount > 0, "Transfer amount must be greater than zero");
549 
550         if (!exemptFee[sender] && !exemptFee[recipient]) {
551             require(tradingEnabled, "Trading not enabled");
552         }
553 
554         uint256 feeswap;
555         uint256 feesum;
556         uint256 fee;
557         Taxes memory currentTaxes;
558 
559         bool useLaunchFee = !exemptFee[sender] &&
560             !exemptFee[recipient] &&
561             block.number <= genesis_block + deadline;
562 
563         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
564             fee = 0;
565 
566         else if (recipient == pair) {
567             feeswap = sellTaxes.burnTax + sellTaxes.marketing + sellTaxes.liquidity;
568             feesum = feeswap;
569             currentTaxes = sellTaxes;
570         } else if (sender == pair) {
571             feeswap = buyTaxes.burnTax + buyTaxes.marketing + buyTaxes.liquidity;
572             feesum = feeswap;
573             currentTaxes = buyTaxes;
574         }
575 
576         fee = ((amount * feesum) / 100);
577 
578         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
579 
580         super._transfer(sender, recipient, amount - fee);
581         if (fee > 0) {
582     
583             if (feeswap > 0) {
584                 uint256 feeAmount = ((amount * feeswap) / 100);
585                 super._transfer(sender, address(this), feeAmount);
586             }
587 
588         }
589     }
590 
591     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
592 
593         if(feeswap == 0){
594             return;
595         }	
596 
597         uint256 contractBalance = balanceOf(address(this));
598         if (contractBalance >= ThresholdAmount) {
599             if (ThresholdAmount > 1) {
600                 contractBalance = ThresholdAmount;
601             }
602 
603             // Split the contract balance into halves
604             uint256 denominator = feeswap * 2;
605             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) / denominator;
606             uint256 AmountToSwap = contractBalance - tokensToAddLiquidityWith;
607  
608             uint256 initialBalance = address(this).balance;
609 
610             swapTokensForETH(AmountToSwap);
611 
612             uint256 deltaBalance = address(this).balance - initialBalance;
613             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
614             uint256 bnbToAddLiquidityWith = (unitBalance * swapTaxes.liquidity);
615 
616             if (bnbToAddLiquidityWith > 0) {
617                 // Add liquidity to pancake
618                 addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
619             }
620 
621             uint256 marketingAmt = (unitBalance * 2 * swapTaxes.marketing);
622             if (marketingAmt > 0) {
623                 payable(marketingWallet).sendValue(marketingAmt);
624             }
625 
626             uint256 burnAmt = (unitBalance * 2 * swapTaxes.burnTax);
627             if (burnAmt > 0) {
628                 payable(burnWallet).sendValue(burnAmt);
629             }
630 
631         }
632     }
633 
634     function swapTokensForETH(uint256 tokenAmount) private {
635         // generate the pancake pair path of token -> weth
636         address[] memory path = new address[](2);
637         path[0] = address(this);
638         path[1] = router.WETH();
639 
640         _approve(address(this), address(router), tokenAmount);
641 
642         // make the swap
643         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
644             tokenAmount,
645             0,
646             path,
647             address(this),
648             block.timestamp
649         );
650     }
651 
652     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
653         // approve token transfer to cover all possible scenarios
654         _approve(address(this), address(router), tokenAmount);
655 
656         // add the liquidity
657         router.addLiquidityETH{ value: ethAmount }(
658             address(this),
659             tokenAmount,
660             0, // slippage is unavoidable
661             0, // slippage is unavoidable
662             deadWallet,
663             block.timestamp
664         );
665     }
666 
667     function updateLiquidityProvide(bool state) external onlyOwner {
668         providingLiquidity = state;
669     }
670 
671     function updateTreshhold(uint256 new_amount) external onlyOwner {
672         ThresholdAmount = new_amount * 10**decimals();
673     }
674 
675         function SetBuyTaxes(
676         uint256 _marketing,
677         uint256 _burn,
678         uint256 _liquidity
679     ) external onlyOwner {
680         require((_marketing + _liquidity + _burn) <= 15, "Must keep fees at 15% or less");
681         buyTaxes.marketing = _marketing;
682         buyTaxes.liquidity = _liquidity;
683         buyTaxes.burnTax = _burn;
684     }
685 
686     function SetSellTaxes(
687         uint256 _marketing,
688         uint256 _liquidity,
689         uint256 _burn
690     ) external onlyOwner {
691         require((_marketing + _liquidity + _burn) <= 15, "Must keep fees at 15% or less");
692         sellTaxes.marketing = _marketing;
693         sellTaxes.liquidity = _liquidity;
694         sellTaxes.burnTax = _burn;
695     }
696 
697     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
698         router = IRouter(newRouter);
699         pair = newPair;
700     }
701 
702    function enableTrading() external onlyOwner {
703         require(!tradingEnabled, "Trading is already enabled");
704         tradingEnabled = true;
705         providingLiquidity = true;
706         genesis_block = block.number;
707     }
708 
709      function updatedeadline(uint256 _deadline) external onlyOwner {
710         require(!tradingEnabled, "Can't change when trading has started");
711         require(_deadline < 8,"Deadline should be less than 8 Blocks");
712         deadline = _deadline;
713     }
714     
715     function updateMarketingWallet(address newWallet) external onlyOwner {
716         require(newWallet != address(0), "Fee Address cannot be zero address");
717         require(newWallet != address(this), "Fee Address cannot be CA");
718         marketingWallet = newWallet;
719     }
720 
721     function updateburnWallet(address newWallet) external onlyOwner {
722         require(newWallet != address(0), "Fee Address cannot be zero address");
723         require(newWallet != address(this), "Fee Address cannot be CA");
724         burnWallet = newWallet;
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
737     function rescueETH() external onlyOwner {
738         uint256 contractETHBalance = address(this).balance;
739         payable(owner()).transfer(contractETHBalance);
740     }
741 
742     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
743         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
744         IERC20(tokenAdd).transfer(owner(), amount);
745     }
746 
747     // fallbacks
748     receive() external payable {}
749 }