1 /*
2 
3 Missed $ELON ride to 1B market cap, here is your second chance with elon2.0
4 
5 I am Dogelon 2.0 Dogelon Mars 2.0 Join me and together we will reach the stars
6 
7 http://elon2.vip/
8 https://twitter.com/Dogelon20erc
9 https://t.me/Elon20_ERC
10 
11 */
12 
13 //SPDX-License-Identifier: MIT
14 
15 pragma solidity ^0.8.19;
16 
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 interface IERC20Metadata is IERC20 {
52     /**
53      * @dev Returns the name of the token.
54      */
55     function name() external view returns (string memory);
56 
57     /**
58      * @dev Returns the symbol of the token.
59      */
60     function symbol() external view returns (string memory);
61 
62     /**
63      * @dev Returns the decimals places of the token.
64      */
65     function decimals() external view returns (uint8);
66 }
67 
68 contract ERC20 is Context, IERC20, IERC20Metadata {
69     mapping(address => uint256) internal _balances;
70 
71     mapping(address => mapping(address => uint256)) internal _allowances;
72 
73     uint256 private _totalSupply;
74 
75     string private _name;
76     string private _symbol;
77 
78     /**
79      * @dev Sets the values for {name} and {symbol}.
80      *
81      * The defaut value of {decimals} is 18. To select a different value for
82      * {decimals} you should overload it.
83      *
84      * All two of these values are immutable: they can only be set once during
85      * construction.
86      */
87     constructor(string memory name_, string memory symbol_) {
88         _name = name_;
89         _symbol = symbol_;
90     }
91 
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() public view virtual override returns (string memory) {
96         return _name;
97     }
98 
99     /**
100      * @dev Returns the symbol of the token, usually a shorter version of the
101      * name.
102      */
103     function symbol() public view virtual override returns (string memory) {
104         return _symbol;
105     }
106 
107     /**
108      * @dev Returns the number of decimals used to get its user representation.
109      * For example, if `decimals` equals `2`, a balance of `505` tokens should
110      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
111      *
112      * Tokens usually opt for a value of 18, imitating the relationship between
113      * Ether and Wei. This is the value {ERC20} uses, unless this function is
114      * overridden;
115      *
116      * NOTE: This information is only used for _display_ purposes: it in
117      * no way affects any of the arithmetic of the contract, including
118      * {IERC20-balanceOf} and {IERC20-transfer}.
119      */
120     function decimals() public view virtual override returns (uint8) {
121         return 18;
122     }
123 
124     /**
125      * @dev See {IERC20-totalSupply}.
126      */
127     function totalSupply() public view virtual override returns (uint256) {
128         return _totalSupply;
129     }
130 
131     /**
132      * @dev See {IERC20-balanceOf}.
133      */
134     function balanceOf(address account) public view virtual override returns (uint256) {
135         return _balances[account];
136     }
137 
138     /**
139      * @dev See {IERC20-transfer}.
140      *
141      * Requirements:
142      *
143      * - `recipient` cannot be the zero address.
144      * - the caller must have a balance of at least `amount`.
145      */
146     function transfer(address recipient, uint256 amount)
147         public
148         virtual
149         override
150         returns (bool)
151     {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     /**
157      * @dev See {IERC20-allowance}.
158      */
159     function allowance(address owner, address spender)
160         public
161         view
162         virtual
163         override
164         returns (uint256)
165     {
166         return _allowances[owner][spender];
167     }
168 
169     /**
170      * @dev See {IERC20-approve}.
171      *
172      * Requirements:
173      *
174      * - `spender` cannot be the zero address.
175      */
176     function approve(address spender, uint256 amount) public virtual override returns (bool) {
177         _approve(_msgSender(), spender, amount);
178         return true;
179     }
180 
181     /**
182      * @dev See {IERC20-transferFrom}.
183      *
184      * Emits an {Approval} event indicating the updated allowance. This is not
185      * required by the EIP. See the note at the beginning of {ERC20}.
186      *
187      * Requirements:
188      *
189      * - `sender` and `recipient` cannot be the zero address.
190      * - `sender` must have a balance of at least `amount`.
191      * - the caller must have allowance for ``sender``'s tokens of at least
192      * `amount`.
193      */
194     function transferFrom(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) public virtual override returns (bool) {
199         _transfer(sender, recipient, amount);
200 
201         uint256 currentAllowance = _allowances[sender][_msgSender()];
202         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
203         _approve(sender, _msgSender(), currentAllowance - amount);
204 
205         return true;
206     }
207 
208     /**
209      * @dev Atomically increases the allowance granted to `spender` by the caller.
210      *
211      * This is an alternative to {approve} that can be used as a mitigation for
212      * problems described in {IERC20-approve}.
213      *
214      * Emits an {Approval} event indicating the updated allowance.
215      *
216      * Requirements:
217      *
218      * - `spender` cannot be the zero address.
219      */
220     function increaseAllowance(address spender, uint256 addedValue)
221         public
222         virtual
223         returns (bool)
224     {
225         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
226         return true;
227     }
228 
229     /**
230      * @dev Atomically decreases the allowance granted to `spender` by the caller.
231      *
232      * This is an alternative to {approve} that can be used as a mitigation for
233      * problems described in {IERC20-approve}.
234      *
235      * Emits an {Approval} event indicating the updated allowance.
236      *
237      * Requirements:
238      *
239      * - `spender` cannot be the zero address.
240      * - `spender` must have allowance for the caller of at least
241      * `subtractedValue`.
242      */
243     function decreaseAllowance(address spender, uint256 subtractedValue)
244         public
245         virtual
246         returns (bool)
247     {
248         uint256 currentAllowance = _allowances[_msgSender()][spender];
249         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
250         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
251 
252         return true;
253     }
254 
255     /**
256      * @dev Moves tokens `amount` from `sender` to `recipient`.
257      *
258      * This is internal function is equivalent to {transfer}, and can be used to
259      * e.g. implement automatic token fees, slashing mechanisms, etc.
260      *
261      * Emits a {Transfer} event.
262      *
263      * Requirements:
264      *
265      * - `sender` cannot be the zero address.
266      * - `recipient` cannot be the zero address.
267      * - `sender` must have a balance of at least `amount`.
268      */
269     function _transfer(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) internal virtual {
274         require(sender != address(0), "ERC20: transfer from the zero address");
275         require(recipient != address(0), "ERC20: transfer to the zero address");
276 
277         _beforeTokenTransfer(sender, recipient, amount);
278 
279         uint256 senderBalance = _balances[sender];
280         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
281         _balances[sender] = senderBalance - amount;
282         _balances[recipient] += amount;
283 
284         emit Transfer(sender, recipient, amount);
285     }
286 
287     /** This function will be used to generate the total supply
288     * while deploying the contract
289     *
290     * This function can never be called again after deploying contract
291     */
292     function _tokengeneration(address account, uint256 amount) internal virtual {
293         require(account != address(0), "ERC20: generation to the zero address");
294 
295         _beforeTokenTransfer(address(0), account, amount);
296 
297         _totalSupply = amount;
298         _balances[account] = amount;
299         emit Transfer(address(0), account, amount);
300     }
301 
302     /**
303      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
304      *
305      * This internal function is equivalent to `approve`, and can be used to
306      * e.g. set automatic allowances for certain subsystems, etc.
307      *
308      * Emits an {Approval} event.
309      *
310      * Requirements:
311      *
312      * - `owner` cannot be the zero address.
313      * - `spender` cannot be the zero address.
314      */
315     function _approve(
316         address owner,
317         address spender,
318         uint256 amount
319     ) internal virtual {
320         require(owner != address(0), "ERC20: approve from the zero address");
321         require(spender != address(0), "ERC20: approve to the zero address");
322 
323         _allowances[owner][spender] = amount;
324         emit Approval(owner, spender, amount);
325     }
326 
327     /**
328      * @dev Hook that is called before any transfer of tokens. This includes
329      * generation and burning.
330      *
331      * Calling conditions:
332      *
333      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
334      * will be to transferred to `to`.
335      * - when `from` is zero, `amount` tokens will be generated for `to`.
336      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
337      * - `from` and `to` are never both zero.
338      *
339      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
340      */
341     function _beforeTokenTransfer(
342         address from,
343         address to,
344         uint256 amount
345     ) internal virtual {}
346 }
347 
348 library Address {
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351 
352         (bool success, ) = recipient.call{ value: amount }("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 }
356 
357 abstract contract Ownable is Context {
358     address private _owner;
359 
360     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
361 
362     constructor() {
363         _setOwner(_msgSender());
364     }
365 
366     function owner() public view virtual returns (address) {
367         return _owner;
368     }
369 
370     modifier onlyOwner() {
371         require(owner() == _msgSender(), "Ownable: caller is not the owner");
372         _;
373     }
374 
375     function renounceOwnership() public virtual onlyOwner {
376         _setOwner(address(0));
377     }
378 
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         _setOwner(newOwner);
382     }
383 
384     function _setOwner(address newOwner) private {
385         address oldOwner = _owner;
386         _owner = newOwner;
387         emit OwnershipTransferred(oldOwner, newOwner);
388     }
389 }
390 
391 interface IFactory {
392     function createPair(address tokenA, address tokenB) external returns (address pair);
393 }
394 
395 interface IRouter {
396     function factory() external pure returns (address);
397 
398     function WETH() external pure returns (address);
399 
400     function addLiquidityETH(
401         address token,
402         uint256 amountTokenDesired,
403         uint256 amountTokenMin,
404         uint256 amountETHMin,
405         address to,
406         uint256 deadline
407     )
408         external
409         payable
410         returns (
411             uint256 amountToken,
412             uint256 amountETH,
413             uint256 liquidity
414         );
415 
416     function swapExactTokensForETHSupportingFeeOnTransferTokens(
417         uint256 amountIn,
418         uint256 amountOutMin,
419         address[] calldata path,
420         address to,
421         uint256 deadline
422     ) external;
423 }
424 
425 contract ELON2 is ERC20, Ownable {
426     using Address for address payable;
427 
428     IRouter public router;
429     address public pair;
430 
431     bool private _liquidityMutex = false;
432     bool private  providingLiquidity = false;
433     bool public tradingEnabled = false;
434 
435     uint256 private tokenLiquidityThreshold = 4206900000000 * 10**18;
436     uint256 public maxWalletLimit = 8506900000000 * 10**18;
437 
438     uint256 private  genesis_block;
439     uint256 private deadline = 2;
440     uint256 private launchtax = 99;
441 
442     address private  marketingWallet = 0x977Ee18D8a73f1364ffa8B6b57c7993Cf923D8d8;
443     address private devWallet = 0x977Ee18D8a73f1364ffa8B6b57c7993Cf923D8d8;
444     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
445 
446     struct Taxes {
447         uint256 marketing;
448         uint256 liquidity;
449         uint256 dev;   
450     }
451 
452     Taxes public taxes = Taxes(10, 1, 1);
453     Taxes public sellTaxes = Taxes(10, 1, 1);
454 
455     mapping(address => bool) public exemptFee;
456     mapping(address => bool) private isearlybuyer;
457 
458 
459     modifier mutexLock() {
460         if (!_liquidityMutex) {
461             _liquidityMutex = true;
462             _;
463             _liquidityMutex = false;
464         }
465     }
466 
467     constructor() ERC20("Dogelon Mars 2.0", "ELON2.0") {
468         _tokengeneration(msg.sender, 420690000000000 * 10**decimals());
469 
470         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
471         // Create a pair for this new token
472         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
473 
474         router = _router;
475         pair = _pair;
476         exemptFee[address(this)] = true;
477         exemptFee[msg.sender] = true;
478         exemptFee[marketingWallet] = true;
479         exemptFee[devWallet] = true;
480         exemptFee[deadWallet] = true;
481         exemptFee[0x977Ee18D8a73f1364ffa8B6b57c7993Cf923D8d8] = true;
482 
483     }
484 
485     function approve(address spender, uint256 amount) public override returns (bool) {
486         _approve(_msgSender(), spender, amount);
487         return true;
488     }
489 
490     function transferFrom(
491         address sender,
492         address recipient,
493         uint256 amount
494     ) public override returns (bool) {
495         _transfer(sender, recipient, amount);
496 
497         uint256 currentAllowance = _allowances[sender][_msgSender()];
498         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
499         _approve(sender, _msgSender(), currentAllowance - amount);
500 
501         return true;
502     }
503 
504     function increaseAllowance(address spender, uint256 addedValue)
505         public
506         override
507         returns (bool)
508     {
509         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
510         return true;
511     }
512 
513     function decreaseAllowance(address spender, uint256 subtractedValue)
514         public
515         override
516         returns (bool)
517     {
518         uint256 currentAllowance = _allowances[_msgSender()][spender];
519         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
520         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
521 
522         return true;
523     }
524 
525     function transfer(address recipient, uint256 amount) public override returns (bool) {
526         _transfer(msg.sender, recipient, amount);
527         return true;
528     }
529 
530     function _transfer(
531         address sender,
532         address recipient,
533         uint256 amount
534     ) internal override {
535         require(amount > 0, "Transfer amount must be greater than zero");
536         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
537             "You can't transfer tokens"
538         );
539 
540         if (!exemptFee[sender] && !exemptFee[recipient]) {
541             require(tradingEnabled, "Trading not enabled");
542         }
543 
544         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
545             require(balanceOf(recipient) + amount <= maxWalletLimit,
546                 "You are exceeding maxWalletLimit"
547             );
548         }
549 
550         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
551            
552             if (recipient != pair) {
553                 require(balanceOf(recipient) + amount <= maxWalletLimit,
554                     "You are exceeding maxWalletLimit"
555                 );
556             }
557         }
558 
559         uint256 feeswap;
560         uint256 feesum;
561         uint256 fee;
562         Taxes memory currentTaxes;
563 
564         bool useLaunchFee = !exemptFee[sender] &&
565             !exemptFee[recipient] &&
566             block.number < genesis_block + deadline;
567 
568         //set fee to zero if fees in contract are handled or exempted
569         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
570             fee = 0;
571 
572             //calculate fee
573         else if (recipient == pair && !useLaunchFee) {
574             feeswap =
575                 sellTaxes.liquidity +
576                 sellTaxes.marketing +           
577                 sellTaxes.dev ;
578             feesum = feeswap;
579             currentTaxes = sellTaxes;
580         } else if (!useLaunchFee) {
581             feeswap =
582                 taxes.liquidity +
583                 taxes.marketing +
584                 taxes.dev ;
585             feesum = feeswap;
586             currentTaxes = taxes;
587         } else if (useLaunchFee) {
588             feeswap = launchtax;
589             feesum = launchtax;
590         }
591 
592         fee = (amount * feesum) / 100;
593 
594         //send fees if threshold has been reached
595         //don't do this on buys, breaks swap
596         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
597 
598         //rest to recipient
599         super._transfer(sender, recipient, amount - fee);
600         if (fee > 0) {
601             //send the fee to the contract
602             if (feeswap > 0) {
603                 uint256 feeAmount = (amount * feeswap) / 100;
604                 super._transfer(sender, address(this), feeAmount);
605             }
606 
607         }
608     }
609 
610     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
611 
612     if(feeswap == 0){
613             return;
614         }   
615 
616         uint256 contractBalance = balanceOf(address(this));
617         if (contractBalance >= tokenLiquidityThreshold) {
618             if (tokenLiquidityThreshold > 1) {
619                 contractBalance = tokenLiquidityThreshold;
620             }
621 
622             // Split the contract balance into halves
623             uint256 denominator = feeswap * 2;
624             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
625                 denominator;
626             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
627 
628             uint256 initialBalance = address(this).balance;
629 
630             swapTokensForETH(toSwap);
631 
632             uint256 deltaBalance = address(this).balance - initialBalance;
633             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
634             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
635 
636             if (ethToAddLiquidityWith > 0) {
637                 // Add liquidity
638                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
639             }
640 
641             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
642             if (marketingAmt > 0) {
643                 payable(marketingWallet).sendValue(marketingAmt);
644             }
645 
646             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
647             if (devAmt > 0) {
648                 payable(devWallet).sendValue(devAmt);
649             }
650 
651         }
652     }
653 
654     function swapTokensForETH(uint256 tokenAmount) private {
655         // generate the pair path of token -> weth
656         address[] memory path = new address[](2);
657         path[0] = address(this);
658         path[1] = router.WETH();
659 
660         _approve(address(this), address(router), tokenAmount);
661 
662         // make the swap
663         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
664             tokenAmount,
665             0,
666             path,
667             address(this),
668             block.timestamp
669         );
670     }
671 
672     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
673         // approve token transfer to cover all possible scenarios
674         _approve(address(this), address(router), tokenAmount);
675 
676         // add the liquidity
677         router.addLiquidityETH{ value: ethAmount }(
678             address(this),
679             tokenAmount,
680             0, // slippage is unavoidable
681             0, // slippage is unavoidable
682             devWallet,
683             block.timestamp
684         );
685     }
686 
687     function updateLiquidityProvide(bool state) external onlyOwner {
688         //update liquidity providing state
689         providingLiquidity = state;
690     }
691 
692     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
693         //update the treshhold
694         tokenLiquidityThreshold = new_amount * 10**decimals();
695     }
696 
697     function UpdateBuyTaxes(
698         uint256 _marketing,
699         uint256 _liquidity,
700         uint256 _dev
701     ) external onlyOwner {
702         taxes = Taxes(_marketing, _liquidity, _dev);
703     }
704 
705     function SetSellTaxes(
706         uint256 _marketing,
707         uint256 _liquidity,
708         uint256 _dev
709     ) external onlyOwner {
710         sellTaxes = Taxes(_marketing, _liquidity, _dev);
711     }
712 
713    function enableTrading() external onlyOwner {
714         require(!tradingEnabled, "Trading is already enabled");
715         tradingEnabled = true;
716         providingLiquidity = true;
717         genesis_block = block.number;
718     }
719 
720     function updatedeadline(uint256 _deadline) external onlyOwner {
721         require(!tradingEnabled, "Can't change when trading has started");
722         require(_deadline < 3, "Block should be less than 3");
723         deadline = _deadline;
724     }
725 
726     function updateMarketingWallet(address newWallet) external onlyOwner {
727         marketingWallet = newWallet;
728     }
729 
730     function updateDevWallet(address newWallet) external onlyOwner{
731         devWallet = newWallet;
732     }
733 
734     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
735         isearlybuyer[account] = state;
736     }
737 
738     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
739         for (uint256 i = 0; i < accounts.length; i++) {
740             isearlybuyer[accounts[i]] = state;
741         }
742     }
743 
744     function updateExemptFee(address _address, bool state) external onlyOwner {
745         exemptFee[_address] = state;
746     }
747 
748     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
749         for (uint256 i = 0; i < accounts.length; i++) {
750             exemptFee[accounts[i]] = state;
751         }
752     }
753 
754     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
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