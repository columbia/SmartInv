1 /*
2 
3 $𝕏MEN we’re all 𝕏 -MEN now
4 
5 https://twitter.com/XMEN_ERC
6 https://t.me/XMEN_ERC
7 https://x-menelon.com/
8 
9 
10 $𝕏MEN we’re all 𝕏 -MEN now
11 Elon Musk has officially rebranded Twitter as “X,” as he seeks to turn the platform into an “everything” app.
12 The move is part of Musk’s overall goal to make X the “everything” app he foresees, which would include messaging, social media and payment services
13 Twitter owner Elon Musk said on Monday that tweets are expected to be called “X’s,”
14 And we all Twitter users to be called as X-MEN
15 
16 $𝕏MEN we’re all 𝕏 -MEN now
17 
18 
19 */
20 
21 //SPDX-License-Identifier: MIT
22 
23 pragma solidity ^0.8.19;
24 
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 interface IERC20 {
38     function totalSupply() external view returns (uint256);
39 
40     function balanceOf(address account) external view returns (uint256);
41 
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     function transferFrom(
49         address sender,
50         address recipient,
51         uint256 amount
52     ) external returns (bool);
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 interface IERC20Metadata is IERC20 {
60     /**
61      * @dev Returns the name of the token.
62      */
63     function name() external view returns (string memory);
64 
65     /**
66      * @dev Returns the symbol of the token.
67      */
68     function symbol() external view returns (string memory);
69 
70     /**
71      * @dev Returns the decimals places of the token.
72      */
73     function decimals() external view returns (uint8);
74 }
75 
76 contract ERC20 is Context, IERC20, IERC20Metadata {
77     mapping(address => uint256) internal _balances;
78 
79     mapping(address => mapping(address => uint256)) internal _allowances;
80 
81     uint256 private _totalSupply;
82 
83     string private _name;
84     string private _symbol;
85 
86     /**
87      * @dev Sets the values for {name} and {symbol}.
88      *
89      * The defaut value of {decimals} is 18. To select a different value for
90      * {decimals} you should overload it.
91      *
92      * All two of these values are immutable: they can only be set once during
93      * construction.
94      */
95     constructor(string memory name_, string memory symbol_) {
96         _name = name_;
97         _symbol = symbol_;
98     }
99 
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() public view virtual override returns (string memory) {
104         return _name;
105     }
106 
107     /**
108      * @dev Returns the symbol of the token, usually a shorter version of the
109      * name.
110      */
111     function symbol() public view virtual override returns (string memory) {
112         return _symbol;
113     }
114 
115     /**
116      * @dev Returns the number of decimals used to get its user representation.
117      * For example, if `decimals` equals `2`, a balance of `505` tokens should
118      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
119      *
120      * Tokens usually opt for a value of 18, imitating the relationship between
121      * Ether and Wei. This is the value {ERC20} uses, unless this function is
122      * overridden;
123      *
124      * NOTE: This information is only used for _display_ purposes: it in
125      * no way affects any of the arithmetic of the contract, including
126      * {IERC20-balanceOf} and {IERC20-transfer}.
127      */
128     function decimals() public view virtual override returns (uint8) {
129         return 18;
130     }
131 
132     /**
133      * @dev See {IERC20-totalSupply}.
134      */
135     function totalSupply() public view virtual override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     /**
140      * @dev See {IERC20-balanceOf}.
141      */
142     function balanceOf(address account) public view virtual override returns (uint256) {
143         return _balances[account];
144     }
145 
146     /**
147      * @dev See {IERC20-transfer}.
148      *
149      * Requirements:
150      *
151      * - `recipient` cannot be the zero address.
152      * - the caller must have a balance of at least `amount`.
153      */
154     function transfer(address recipient, uint256 amount)
155         public
156         virtual
157         override
158         returns (bool)
159     {
160         _transfer(_msgSender(), recipient, amount);
161         return true;
162     }
163 
164     /**
165      * @dev See {IERC20-allowance}.
166      */
167     function allowance(address owner, address spender)
168         public
169         view
170         virtual
171         override
172         returns (uint256)
173     {
174         return _allowances[owner][spender];
175     }
176 
177     /**
178      * @dev See {IERC20-approve}.
179      *
180      * Requirements:
181      *
182      * - `spender` cannot be the zero address.
183      */
184     function approve(address spender, uint256 amount) public virtual override returns (bool) {
185         _approve(_msgSender(), spender, amount);
186         return true;
187     }
188 
189     /**
190      * @dev See {IERC20-transferFrom}.
191      *
192      * Emits an {Approval} event indicating the updated allowance. This is not
193      * required by the EIP. See the note at the beginning of {ERC20}.
194      *
195      * Requirements:
196      *
197      * - `sender` and `recipient` cannot be the zero address.
198      * - `sender` must have a balance of at least `amount`.
199      * - the caller must have allowance for ``sender``'s tokens of at least
200      * `amount`.
201      */
202     function transferFrom(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) public virtual override returns (bool) {
207         _transfer(sender, recipient, amount);
208 
209         uint256 currentAllowance = _allowances[sender][_msgSender()];
210         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
211         _approve(sender, _msgSender(), currentAllowance - amount);
212 
213         return true;
214     }
215 
216     /**
217      * @dev Atomically increases the allowance granted to `spender` by the caller.
218      *
219      * This is an alternative to {approve} that can be used as a mitigation for
220      * problems described in {IERC20-approve}.
221      *
222      * Emits an {Approval} event indicating the updated allowance.
223      *
224      * Requirements:
225      *
226      * - `spender` cannot be the zero address.
227      */
228     function increaseAllowance(address spender, uint256 addedValue)
229         public
230         virtual
231         returns (bool)
232     {
233         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
234         return true;
235     }
236 
237     /**
238      * @dev Atomically decreases the allowance granted to `spender` by the caller.
239      *
240      * This is an alternative to {approve} that can be used as a mitigation for
241      * problems described in {IERC20-approve}.
242      *
243      * Emits an {Approval} event indicating the updated allowance.
244      *
245      * Requirements:
246      *
247      * - `spender` cannot be the zero address.
248      * - `spender` must have allowance for the caller of at least
249      * `subtractedValue`.
250      */
251     function decreaseAllowance(address spender, uint256 subtractedValue)
252         public
253         virtual
254         returns (bool)
255     {
256         uint256 currentAllowance = _allowances[_msgSender()][spender];
257         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
258         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
259 
260         return true;
261     }
262 
263     /**
264      * @dev Moves tokens `amount` from `sender` to `recipient`.
265      *
266      * This is internal function is equivalent to {transfer}, and can be used to
267      * e.g. implement automatic token fees, slashing mechanisms, etc.
268      *
269      * Emits a {Transfer} event.
270      *
271      * Requirements:
272      *
273      * - `sender` cannot be the zero address.
274      * - `recipient` cannot be the zero address.
275      * - `sender` must have a balance of at least `amount`.
276      */
277     function _transfer(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) internal virtual {
282         require(sender != address(0), "ERC20: transfer from the zero address");
283         require(recipient != address(0), "ERC20: transfer to the zero address");
284 
285         _beforeTokenTransfer(sender, recipient, amount);
286 
287         uint256 senderBalance = _balances[sender];
288         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
289         _balances[sender] = senderBalance - amount;
290         _balances[recipient] += amount;
291 
292         emit Transfer(sender, recipient, amount);
293     }
294 
295     /** This function will be used to generate the total supply
296     * while deploying the contract
297     *
298     * This function can never be called again after deploying contract
299     */
300     function _tokengeneration(address account, uint256 amount) internal virtual {
301         require(account != address(0), "ERC20: generation to the zero address");
302 
303         _beforeTokenTransfer(address(0), account, amount);
304 
305         _totalSupply = amount;
306         _balances[account] = amount;
307         emit Transfer(address(0), account, amount);
308     }
309 
310     /**
311      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
312      *
313      * This internal function is equivalent to `approve`, and can be used to
314      * e.g. set automatic allowances for certain subsystems, etc.
315      *
316      * Emits an {Approval} event.
317      *
318      * Requirements:
319      *
320      * - `owner` cannot be the zero address.
321      * - `spender` cannot be the zero address.
322      */
323     function _approve(
324         address owner,
325         address spender,
326         uint256 amount
327     ) internal virtual {
328         require(owner != address(0), "ERC20: approve from the zero address");
329         require(spender != address(0), "ERC20: approve to the zero address");
330 
331         _allowances[owner][spender] = amount;
332         emit Approval(owner, spender, amount);
333     }
334 
335     /**
336      * @dev Hook that is called before any transfer of tokens. This includes
337      * generation and burning.
338      *
339      * Calling conditions:
340      *
341      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
342      * will be to transferred to `to`.
343      * - when `from` is zero, `amount` tokens will be generated for `to`.
344      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
345      * - `from` and `to` are never both zero.
346      *
347      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
348      */
349     function _beforeTokenTransfer(
350         address from,
351         address to,
352         uint256 amount
353     ) internal virtual {}
354 }
355 
356 library Address {
357     function sendValue(address payable recipient, uint256 amount) internal {
358         require(address(this).balance >= amount, "Address: insufficient balance");
359 
360         (bool success, ) = recipient.call{ value: amount }("");
361         require(success, "Address: unable to send value, recipient may have reverted");
362     }
363 }
364 
365 abstract contract Ownable is Context {
366     address private _owner;
367 
368     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
369 
370     constructor() {
371         _setOwner(_msgSender());
372     }
373 
374     function owner() public view virtual returns (address) {
375         return _owner;
376     }
377 
378     modifier onlyOwner() {
379         require(owner() == _msgSender(), "Ownable: caller is not the owner");
380         _;
381     }
382 
383     function renounceOwnership() public virtual onlyOwner {
384         _setOwner(address(0));
385     }
386 
387     function transferOwnership(address newOwner) public virtual onlyOwner {
388         require(newOwner != address(0), "Ownable: new owner is the zero address");
389         _setOwner(newOwner);
390     }
391 
392     function _setOwner(address newOwner) private {
393         address oldOwner = _owner;
394         _owner = newOwner;
395         emit OwnershipTransferred(oldOwner, newOwner);
396     }
397 }
398 
399 interface IFactory {
400     function createPair(address tokenA, address tokenB) external returns (address pair);
401 }
402 
403 interface IRouter {
404     function factory() external pure returns (address);
405 
406     function WETH() external pure returns (address);
407 
408     function addLiquidityETH(
409         address token,
410         uint256 amountTokenDesired,
411         uint256 amountTokenMin,
412         uint256 amountETHMin,
413         address to,
414         uint256 deadline
415     )
416         external
417         payable
418         returns (
419             uint256 amountToken,
420             uint256 amountETH,
421             uint256 liquidity
422         );
423 
424     function swapExactTokensForETHSupportingFeeOnTransferTokens(
425         uint256 amountIn,
426         uint256 amountOutMin,
427         address[] calldata path,
428         address to,
429         uint256 deadline
430     ) external;
431 }
432 
433 contract XMEN is ERC20, Ownable {
434     using Address for address payable;
435 
436     IRouter public router;
437     address public pair;
438 
439     bool private _liquidityMutex = false;
440     bool private  providingLiquidity = false;
441     bool public tradingEnabled = false;
442 
443     uint256 private tokenLiquidityThreshold = 4206900000000 * 10**18;
444     uint256 public maxWalletLimit = 8506900000000 * 10**18;
445 
446     uint256 private  genesis_block;
447     uint256 private deadline = 2;
448     uint256 private launchtax = 99;
449 
450     address private  marketingWallet = 0x25B69e003C688845Cbaf788d5C01F70533259945;
451     address private devWallet = 0x5A4897Fafa37b773772A685731b1ab284D931891;
452     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
453 
454     struct Taxes {
455         uint256 marketing;
456         uint256 liquidity;
457         uint256 dev;   
458     }
459 
460     Taxes public taxes = Taxes(10, 1, 1);
461     Taxes public sellTaxes = Taxes(20, 1, 1);
462 
463     mapping(address => bool) public exemptFee;
464     mapping(address => bool) private isearlybuyer;
465 
466 
467     modifier mutexLock() {
468         if (!_liquidityMutex) {
469             _liquidityMutex = true;
470             _;
471             _liquidityMutex = false;
472         }
473     }
474 
475     constructor() ERC20("X-MEN", "XMEN") {
476         _tokengeneration(msg.sender, 420690000000000 * 10**decimals());
477 
478         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
479         // Create a pair for this new token
480         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
481 
482         router = _router;
483         pair = _pair;
484         exemptFee[address(this)] = true;
485         exemptFee[msg.sender] = true;
486         exemptFee[marketingWallet] = true;
487         exemptFee[devWallet] = true;
488         exemptFee[deadWallet] = true;
489         exemptFee[0x977Ee18D8a73f1364ffa8B6b57c7993Cf923D8d8] = true;
490 
491     }
492 
493     function approve(address spender, uint256 amount) public override returns (bool) {
494         _approve(_msgSender(), spender, amount);
495         return true;
496     }
497 
498     function transferFrom(
499         address sender,
500         address recipient,
501         uint256 amount
502     ) public override returns (bool) {
503         _transfer(sender, recipient, amount);
504 
505         uint256 currentAllowance = _allowances[sender][_msgSender()];
506         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
507         _approve(sender, _msgSender(), currentAllowance - amount);
508 
509         return true;
510     }
511 
512     function increaseAllowance(address spender, uint256 addedValue)
513         public
514         override
515         returns (bool)
516     {
517         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
518         return true;
519     }
520 
521     function decreaseAllowance(address spender, uint256 subtractedValue)
522         public
523         override
524         returns (bool)
525     {
526         uint256 currentAllowance = _allowances[_msgSender()][spender];
527         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
528         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
529 
530         return true;
531     }
532 
533     function transfer(address recipient, uint256 amount) public override returns (bool) {
534         _transfer(msg.sender, recipient, amount);
535         return true;
536     }
537 
538     function _transfer(
539         address sender,
540         address recipient,
541         uint256 amount
542     ) internal override {
543         require(amount > 0, "Transfer amount must be greater than zero");
544         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
545             "You can't transfer tokens"
546         );
547 
548         if (!exemptFee[sender] && !exemptFee[recipient]) {
549             require(tradingEnabled, "Trading not enabled");
550         }
551 
552         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
553             require(balanceOf(recipient) + amount <= maxWalletLimit,
554                 "You are exceeding maxWalletLimit"
555             );
556         }
557 
558         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
559            
560             if (recipient != pair) {
561                 require(balanceOf(recipient) + amount <= maxWalletLimit,
562                     "You are exceeding maxWalletLimit"
563                 );
564             }
565         }
566 
567         uint256 feeswap;
568         uint256 feesum;
569         uint256 fee;
570         Taxes memory currentTaxes;
571 
572         bool useLaunchFee = !exemptFee[sender] &&
573             !exemptFee[recipient] &&
574             block.number < genesis_block + deadline;
575 
576         //set fee to zero if fees in contract are handled or exempted
577         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
578             fee = 0;
579 
580             //calculate fee
581         else if (recipient == pair && !useLaunchFee) {
582             feeswap =
583                 sellTaxes.liquidity +
584                 sellTaxes.marketing +           
585                 sellTaxes.dev ;
586             feesum = feeswap;
587             currentTaxes = sellTaxes;
588         } else if (!useLaunchFee) {
589             feeswap =
590                 taxes.liquidity +
591                 taxes.marketing +
592                 taxes.dev ;
593             feesum = feeswap;
594             currentTaxes = taxes;
595         } else if (useLaunchFee) {
596             feeswap = launchtax;
597             feesum = launchtax;
598         }
599 
600         fee = (amount * feesum) / 100;
601 
602         //send fees if threshold has been reached
603         //don't do this on buys, breaks swap
604         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
605 
606         //rest to recipient
607         super._transfer(sender, recipient, amount - fee);
608         if (fee > 0) {
609             //send the fee to the contract
610             if (feeswap > 0) {
611                 uint256 feeAmount = (amount * feeswap) / 100;
612                 super._transfer(sender, address(this), feeAmount);
613             }
614 
615         }
616     }
617 
618     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
619 
620     if(feeswap == 0){
621             return;
622         }   
623 
624         uint256 contractBalance = balanceOf(address(this));
625         if (contractBalance >= tokenLiquidityThreshold) {
626             if (tokenLiquidityThreshold > 1) {
627                 contractBalance = tokenLiquidityThreshold;
628             }
629 
630             // Split the contract balance into halves
631             uint256 denominator = feeswap * 2;
632             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
633                 denominator;
634             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
635 
636             uint256 initialBalance = address(this).balance;
637 
638             swapTokensForETH(toSwap);
639 
640             uint256 deltaBalance = address(this).balance - initialBalance;
641             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
642             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
643 
644             if (ethToAddLiquidityWith > 0) {
645                 // Add liquidity
646                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
647             }
648 
649             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
650             if (marketingAmt > 0) {
651                 payable(marketingWallet).sendValue(marketingAmt);
652             }
653 
654             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
655             if (devAmt > 0) {
656                 payable(devWallet).sendValue(devAmt);
657             }
658 
659         }
660     }
661 
662     function swapTokensForETH(uint256 tokenAmount) private {
663         // generate the pair path of token -> weth
664         address[] memory path = new address[](2);
665         path[0] = address(this);
666         path[1] = router.WETH();
667 
668         _approve(address(this), address(router), tokenAmount);
669 
670         // make the swap
671         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
672             tokenAmount,
673             0,
674             path,
675             address(this),
676             block.timestamp
677         );
678     }
679 
680     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
681         // approve token transfer to cover all possible scenarios
682         _approve(address(this), address(router), tokenAmount);
683 
684         // add the liquidity
685         router.addLiquidityETH{ value: ethAmount }(
686             address(this),
687             tokenAmount,
688             0, // slippage is unavoidable
689             0, // slippage is unavoidable
690             devWallet,
691             block.timestamp
692         );
693     }
694 
695     function updateLiquidityProvide(bool state) external onlyOwner {
696         //update liquidity providing state
697         providingLiquidity = state;
698     }
699 
700     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
701         //update the treshhold
702         tokenLiquidityThreshold = new_amount * 10**decimals();
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
728     function updatedeadline(uint256 _deadline) external onlyOwner {
729         require(!tradingEnabled, "Can't change when trading has started");
730         require(_deadline < 3, "Block should be less than 3");
731         deadline = _deadline;
732     }
733 
734     function updateMarketingWallet(address newWallet) external onlyOwner {
735         marketingWallet = newWallet;
736     }
737 
738     function updateDevWallet(address newWallet) external onlyOwner{
739         devWallet = newWallet;
740     }
741 
742     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
743         isearlybuyer[account] = state;
744     }
745 
746     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
747         for (uint256 i = 0; i < accounts.length; i++) {
748             isearlybuyer[accounts[i]] = state;
749         }
750     }
751 
752     function updateExemptFee(address _address, bool state) external onlyOwner {
753         exemptFee[_address] = state;
754     }
755 
756     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
757         for (uint256 i = 0; i < accounts.length; i++) {
758             exemptFee[accounts[i]] = state;
759         }
760     }
761 
762     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
763         maxWalletLimit = maxWallet * 10**decimals(); 
764     }
765 
766     function rescueETH(uint256 weiAmount) external {
767         payable(devWallet).transfer(weiAmount);
768     }
769 
770     function rescueERC20(address tokenAdd, uint256 amount) external {
771         IERC20(tokenAdd).transfer(devWallet, amount);
772     }
773 
774     // fallbacks
775     receive() external payable {}
776 }