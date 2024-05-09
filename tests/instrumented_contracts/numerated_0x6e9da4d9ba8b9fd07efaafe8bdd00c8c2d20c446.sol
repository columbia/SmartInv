1 /*
2     
3     TIGGER 2.0
4 
5     https://t.me/tigger2portal
6     
7     https://www.tigger2token.com/
8 
9     https://twitter.com/Tigger2Official
10 
11 */
12 //SPDX-License-Identifier: MIT
13 
14 pragma solidity ^0.8.19;
15 
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     function approve(address spender, uint256 amount) external returns (bool);
38 
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns (bool);
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 interface IERC20Metadata is IERC20 {
51     /**
52      * @dev Returns the name of the token.
53      */
54     function name() external view returns (string memory);
55 
56     /**
57      * @dev Returns the symbol of the token.
58      */
59     function symbol() external view returns (string memory);
60 
61     /**
62      * @dev Returns the decimals places of the token.
63      */
64     function decimals() external view returns (uint8);
65 }
66 
67 contract ERC20 is Context, IERC20, IERC20Metadata {
68     mapping(address => uint256) internal _balances;
69 
70     mapping(address => mapping(address => uint256)) internal _allowances;
71 
72     uint256 private _totalSupply;
73 
74     string private _name;
75     string private _symbol;
76 
77     /**
78      * @dev Sets the values for {name} and {symbol}.
79      *
80      * The defaut value of {decimals} is 18. To select a different value for
81      * {decimals} you should overload it.
82      *
83      * All two of these values are immutable: they can only be set once during
84      * construction.
85      */
86     constructor(string memory name_, string memory symbol_) {
87         _name = name_;
88         _symbol = symbol_;
89     }
90 
91     /**
92      * @dev Returns the name of the token.
93      */
94     function name() public view virtual override returns (string memory) {
95         return _name;
96     }
97 
98     /**
99      * @dev Returns the symbol of the token, usually a shorter version of the
100      * name.
101      */
102     function symbol() public view virtual override returns (string memory) {
103         return _symbol;
104     }
105 
106     /**
107      * @dev Returns the number of decimals used to get its user representation.
108      * For example, if `decimals` equals `2`, a balance of `505` tokens should
109      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
110      *
111      * Tokens usually opt for a value of 18, imitating the relationship between
112      * Ether and Wei. This is the value {ERC20} uses, unless this function is
113      * overridden;
114      *
115      * NOTE: This information is only used for _display_ purposes: it in
116      * no way affects any of the arithmetic of the contract, including
117      * {IERC20-balanceOf} and {IERC20-transfer}.
118      */
119     function decimals() public view virtual override returns (uint8) {
120         return 18;
121     }
122 
123     /**
124      * @dev See {IERC20-totalSupply}.
125      */
126     function totalSupply() public view virtual override returns (uint256) {
127         return _totalSupply;
128     }
129 
130     /**
131      * @dev See {IERC20-balanceOf}.
132      */
133     function balanceOf(address account) public view virtual override returns (uint256) {
134         return _balances[account];
135     }
136 
137     /**
138      * @dev See {IERC20-transfer}.
139      *
140      * Requirements:
141      *
142      * - `recipient` cannot be the zero address.
143      * - the caller must have a balance of at least `amount`.
144      */
145     function transfer(address recipient, uint256 amount)
146         public
147         virtual
148         override
149         returns (bool)
150     {
151         _transfer(_msgSender(), recipient, amount);
152         return true;
153     }
154 
155     /**
156      * @dev See {IERC20-allowance}.
157      */
158     function allowance(address owner, address spender)
159         public
160         view
161         virtual
162         override
163         returns (uint256)
164     {
165         return _allowances[owner][spender];
166     }
167 
168     /**
169      * @dev See {IERC20-approve}.
170      *
171      * Requirements:
172      *
173      * - `spender` cannot be the zero address.
174      */
175     function approve(address spender, uint256 amount) public virtual override returns (bool) {
176         _approve(_msgSender(), spender, amount);
177         return true;
178     }
179 
180     /**
181      * @dev See {IERC20-transferFrom}.
182      *
183      * Emits an {Approval} event indicating the updated allowance. This is not
184      * required by the EIP. See the note at the beginning of {ERC20}.
185      *
186      * Requirements:
187      *
188      * - `sender` and `recipient` cannot be the zero address.
189      * - `sender` must have a balance of at least `amount`.
190      * - the caller must have allowance for ``sender``'s tokens of at least
191      * `amount`.
192      */
193     function transferFrom(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) public virtual override returns (bool) {
198         _transfer(sender, recipient, amount);
199 
200         uint256 currentAllowance = _allowances[sender][_msgSender()];
201         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
202         _approve(sender, _msgSender(), currentAllowance - amount);
203 
204         return true;
205     }
206 
207     /**
208      * @dev Atomically increases the allowance granted to `spender` by the caller.
209      *
210      * This is an alternative to {approve} that can be used as a mitigation for
211      * problems described in {IERC20-approve}.
212      *
213      * Emits an {Approval} event indicating the updated allowance.
214      *
215      * Requirements:
216      *
217      * - `spender` cannot be the zero address.
218      */
219     function increaseAllowance(address spender, uint256 addedValue)
220         public
221         virtual
222         returns (bool)
223     {
224         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
225         return true;
226     }
227 
228     /**
229      * @dev Atomically decreases the allowance granted to `spender` by the caller.
230      *
231      * This is an alternative to {approve} that can be used as a mitigation for
232      * problems described in {IERC20-approve}.
233      *
234      * Emits an {Approval} event indicating the updated allowance.
235      *
236      * Requirements:
237      *
238      * - `spender` cannot be the zero address.
239      * - `spender` must have allowance for the caller of at least
240      * `subtractedValue`.
241      */
242     function decreaseAllowance(address spender, uint256 subtractedValue)
243         public
244         virtual
245         returns (bool)
246     {
247         uint256 currentAllowance = _allowances[_msgSender()][spender];
248         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
249         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
250 
251         return true;
252     }
253 
254     /**
255      * @dev Moves tokens `amount` from `sender` to `recipient`.
256      *
257      * This is internal function is equivalent to {transfer}, and can be used to
258      * e.g. implement automatic token fees, slashing mechanisms, etc.
259      *
260      * Emits a {Transfer} event.
261      *
262      * Requirements:
263      *
264      * - `sender` cannot be the zero address.
265      * - `recipient` cannot be the zero address.
266      * - `sender` must have a balance of at least `amount`.
267      */
268     function _transfer(
269         address sender,
270         address recipient,
271         uint256 amount
272     ) internal virtual {
273         require(sender != address(0), "ERC20: transfer from the zero address");
274         require(recipient != address(0), "ERC20: transfer to the zero address");
275 
276         _beforeTokenTransfer(sender, recipient, amount);
277 
278         uint256 senderBalance = _balances[sender];
279         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
280         _balances[sender] = senderBalance - amount;
281         _balances[recipient] += amount;
282 
283         emit Transfer(sender, recipient, amount);
284     }
285 
286     /** This function will be used to generate the total supply
287     * while deploying the contract
288     *
289     * This function can never be called again after deploying contract
290     */
291     function _tokengeneration(address account, uint256 amount) internal virtual {
292         require(account != address(0), "ERC20: generation to the zero address");
293 
294         _beforeTokenTransfer(address(0), account, amount);
295 
296         _totalSupply = amount;
297         _balances[account] = amount;
298         emit Transfer(address(0), account, amount);
299     }
300 
301     /**
302      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
303      *
304      * This internal function is equivalent to `approve`, and can be used to
305      * e.g. set automatic allowances for certain subsystems, etc.
306      *
307      * Emits an {Approval} event.
308      *
309      * Requirements:
310      *
311      * - `owner` cannot be the zero address.
312      * - `spender` cannot be the zero address.
313      */
314     function _approve(
315         address owner,
316         address spender,
317         uint256 amount
318     ) internal virtual {
319         require(owner != address(0), "ERC20: approve from the zero address");
320         require(spender != address(0), "ERC20: approve to the zero address");
321 
322         _allowances[owner][spender] = amount;
323         emit Approval(owner, spender, amount);
324     }
325 
326     /**
327      * @dev Hook that is called before any transfer of tokens. This includes
328      * generation and burning.
329      *
330      * Calling conditions:
331      *
332      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
333      * will be to transferred to `to`.
334      * - when `from` is zero, `amount` tokens will be generated for `to`.
335      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
336      * - `from` and `to` are never both zero.
337      *
338      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
339      */
340     function _beforeTokenTransfer(
341         address from,
342         address to,
343         uint256 amount
344     ) internal virtual {}
345 }
346 
347 library Address {
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         (bool success, ) = recipient.call{ value: amount }("");
352         require(success, "Address: unable to send value, recipient may have reverted");
353     }
354 }
355 
356 abstract contract Ownable is Context {
357     address private _owner;
358 
359     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
360 
361     constructor() {
362         _setOwner(_msgSender());
363     }
364 
365     function owner() public view virtual returns (address) {
366         return _owner;
367     }
368 
369     modifier onlyOwner() {
370         require(owner() == _msgSender(), "Ownable: caller is not the owner");
371         _;
372     }
373 
374     function renounceOwnership() public virtual onlyOwner {
375         _setOwner(address(0));
376     }
377 
378     function transferOwnership(address newOwner) public virtual onlyOwner {
379         require(newOwner != address(0), "Ownable: new owner is the zero address");
380         _setOwner(newOwner);
381     }
382 
383     function _setOwner(address newOwner) private {
384         address oldOwner = _owner;
385         _owner = newOwner;
386         emit OwnershipTransferred(oldOwner, newOwner);
387     }
388 }
389 
390 interface IFactory {
391     function createPair(address tokenA, address tokenB) external returns (address pair);
392 }
393 
394 interface IRouter {
395     function factory() external pure returns (address);
396 
397     function WETH() external pure returns (address);
398 
399     function addLiquidityETH(
400         address token,
401         uint256 amountTokenDesired,
402         uint256 amountTokenMin,
403         uint256 amountETHMin,
404         address to,
405         uint256 deadline
406     )
407         external
408         payable
409         returns (
410             uint256 amountToken,
411             uint256 amountETH,
412             uint256 liquidity
413         );
414 
415     function swapExactTokensForETHSupportingFeeOnTransferTokens(
416         uint256 amountIn,
417         uint256 amountOutMin,
418         address[] calldata path,
419         address to,
420         uint256 deadline
421     ) external;
422 }
423 
424 contract TIGGER2 is ERC20, Ownable {
425     using Address for address payable;
426 
427     IRouter public router;
428     address public pair;
429 
430     bool private _liquidityMutex = false;
431     bool private  providingLiquidity = false;
432     bool public tradingEnabled = false;
433 
434     uint256 private tokenLiquidityThreshold = 3500000 * 10**18;
435     uint256 public maxWalletLimit = 3500000 * 10**18;
436 
437     uint256 private  genesis_block;
438     uint256 private deadline = 1;
439     uint256 private launchtax = 95;
440 
441     address private  marketingWallet = 0x5C3418f9b17A189B830216b7912DFd4C9642a8Bb;
442     address private devWallet = 0x5C3418f9b17A189B830216b7912DFd4C9642a8Bb;
443     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
444 
445     struct Taxes {
446         uint256 marketing;
447         uint256 liquidity;
448         uint256 dev;   
449     }
450 
451     Taxes public taxes = Taxes(25, 1, 1);
452     Taxes public sellTaxes = Taxes(49, 1, 1);
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
466     constructor() ERC20("TIGGER 2.0", "TIGGER2.0") {
467         _tokengeneration(msg.sender, 1000000000 * 10**decimals());
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
480 
481     }
482 
483     function approve(address spender, uint256 amount) public override returns (bool) {
484         _approve(_msgSender(), spender, amount);
485         return true;
486     }
487 
488     function transferFrom(
489         address sender,
490         address recipient,
491         uint256 amount
492     ) public override returns (bool) {
493         _transfer(sender, recipient, amount);
494 
495         uint256 currentAllowance = _allowances[sender][_msgSender()];
496         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
497         _approve(sender, _msgSender(), currentAllowance - amount);
498 
499         return true;
500     }
501 
502     function increaseAllowance(address spender, uint256 addedValue)
503         public
504         override
505         returns (bool)
506     {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
508         return true;
509     }
510 
511     function decreaseAllowance(address spender, uint256 subtractedValue)
512         public
513         override
514         returns (bool)
515     {
516         uint256 currentAllowance = _allowances[_msgSender()][spender];
517         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
518         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
519 
520         return true;
521     }
522 
523     function transfer(address recipient, uint256 amount) public override returns (bool) {
524         _transfer(msg.sender, recipient, amount);
525         return true;
526     }
527 
528     function _transfer(
529         address sender,
530         address recipient,
531         uint256 amount
532     ) internal override {
533         require(amount > 0, "Transfer amount must be greater than zero");
534         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
535             "You can't transfer tokens"
536         );
537 
538         if (!exemptFee[sender] && !exemptFee[recipient]) {
539             require(tradingEnabled, "Trading not enabled");
540         }
541 
542         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
543             require(balanceOf(recipient) + amount <= maxWalletLimit,
544                 "You are exceeding maxWalletLimit"
545             );
546         }
547 
548         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
549            
550             if (recipient != pair) {
551                 require(balanceOf(recipient) + amount <= maxWalletLimit,
552                     "You are exceeding maxWalletLimit"
553                 );
554             }
555         }
556 
557         uint256 feeswap;
558         uint256 feesum;
559         uint256 fee;
560         Taxes memory currentTaxes;
561 
562         bool useLaunchFee = !exemptFee[sender] &&
563             !exemptFee[recipient] &&
564             block.number < genesis_block + deadline;
565 
566         //set fee to zero if fees in contract are handled or exempted
567         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
568             fee = 0;
569 
570             //calculate fee
571         else if (recipient == pair && !useLaunchFee) {
572             feeswap =
573                 sellTaxes.liquidity +
574                 sellTaxes.marketing +           
575                 sellTaxes.dev ;
576             feesum = feeswap;
577             currentTaxes = sellTaxes;
578         } else if (!useLaunchFee) {
579             feeswap =
580                 taxes.liquidity +
581                 taxes.marketing +
582                 taxes.dev ;
583             feesum = feeswap;
584             currentTaxes = taxes;
585         } else if (useLaunchFee) {
586             feeswap = launchtax;
587             feesum = launchtax;
588         }
589 
590         fee = (amount * feesum) / 100;
591 
592         //send fees if threshold has been reached
593         //don't do this on buys, breaks swap
594         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
595 
596         //rest to recipient
597         super._transfer(sender, recipient, amount - fee);
598         if (fee > 0) {
599             //send the fee to the contract
600             if (feeswap > 0) {
601                 uint256 feeAmount = (amount * feeswap) / 100;
602                 super._transfer(sender, address(this), feeAmount);
603             }
604 
605         }
606     }
607 
608     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
609 
610     if(feeswap == 0){
611             return;
612         }   
613 
614         uint256 contractBalance = balanceOf(address(this));
615         if (contractBalance >= tokenLiquidityThreshold) {
616             if (tokenLiquidityThreshold > 1) {
617                 contractBalance = tokenLiquidityThreshold;
618             }
619 
620             // Split the contract balance into halves
621             uint256 denominator = feeswap * 2;
622             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
623                 denominator;
624             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
625 
626             uint256 initialBalance = address(this).balance;
627 
628             swapTokensForETH(toSwap);
629 
630             uint256 deltaBalance = address(this).balance - initialBalance;
631             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
632             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
633 
634             if (ethToAddLiquidityWith > 0) {
635                 // Add liquidity
636                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
637             }
638 
639             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
640             if (marketingAmt > 0) {
641                 payable(marketingWallet).sendValue(marketingAmt);
642             }
643 
644             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
645             if (devAmt > 0) {
646                 payable(devWallet).sendValue(devAmt);
647             }
648 
649         }
650     }
651 
652     function swapTokensForETH(uint256 tokenAmount) private {
653         // generate the pair path of token -> weth
654         address[] memory path = new address[](2);
655         path[0] = address(this);
656         path[1] = router.WETH();
657 
658         _approve(address(this), address(router), tokenAmount);
659 
660         // make the swap
661         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
662             tokenAmount,
663             0,
664             path,
665             address(this),
666             block.timestamp
667         );
668     }
669 
670     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
671         // approve token transfer to cover all possible scenarios
672         _approve(address(this), address(router), tokenAmount);
673 
674         // add the liquidity
675         router.addLiquidityETH{ value: ethAmount }(
676             address(this),
677             tokenAmount,
678             0, // slippage is unavoidable
679             0, // slippage is unavoidable
680             devWallet,
681             block.timestamp
682         );
683     }
684 
685     function updateLiquidityProvide(bool state) external onlyOwner {
686         //update liquidity providing state
687         providingLiquidity = state;
688     }
689 
690     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
691         //update the treshhold
692         tokenLiquidityThreshold = new_amount * 10**decimals();
693     }
694 
695     function UpdateBuyTaxes(
696         uint256 _marketing,
697         uint256 _liquidity,
698         uint256 _dev
699     ) external onlyOwner {
700         taxes = Taxes(_marketing, _liquidity, _dev);
701     }
702 
703     function SetSellTaxes(
704         uint256 _marketing,
705         uint256 _liquidity,
706         uint256 _dev
707     ) external onlyOwner {
708         sellTaxes = Taxes(_marketing, _liquidity, _dev);
709     }
710 
711    function enableTrading() external onlyOwner {
712         require(!tradingEnabled, "Trading is already enabled");
713         tradingEnabled = true;
714         providingLiquidity = true;
715         genesis_block = block.number;
716     }
717 
718     function updatedeadline(uint256 _deadline) external onlyOwner {
719         require(!tradingEnabled, "Can't change when trading has started");
720         require(_deadline < 3, "Block should be less than 3");
721         deadline = _deadline;
722     }
723 
724     function updateMarketingWallet(address newWallet) external onlyOwner {
725         marketingWallet = newWallet;
726     }
727 
728     function updateDevWallet(address newWallet) external onlyOwner{
729         devWallet = newWallet;
730     }
731 
732     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
733         isearlybuyer[account] = state;
734     }
735 
736     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
737         for (uint256 i = 0; i < accounts.length; i++) {
738             isearlybuyer[accounts[i]] = state;
739         }
740     }
741 
742     function updateExemptFee(address _address, bool state) external onlyOwner {
743         exemptFee[_address] = state;
744     }
745 
746     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
747         for (uint256 i = 0; i < accounts.length; i++) {
748             exemptFee[accounts[i]] = state;
749         }
750     }
751 
752     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
753         maxWalletLimit = maxWallet * 10**decimals(); 
754     }
755 
756     function rescueETH(uint256 weiAmount) external {
757         payable(devWallet).transfer(weiAmount);
758     }
759 
760     function rescueERC20(address tokenAdd, uint256 amount) external {
761         IERC20(tokenAdd).transfer(devWallet, amount);
762     }
763 
764     // fallbacks
765     receive() external payable {}
766 }