1 /**
2 
3 /*
4     
5   Enough with the PEPE CLONES :@
6 
7  https://notpepe.wtf
8  https://t.me/notpepeentry
9  https://Twitter.com/Notpepewtf
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
424 contract NOTPEPE is ERC20, Ownable {
425     using Address for address payable;
426 
427     IRouter public router;
428     address public pair;
429 
430     bool private _liquidityMutex = false;
431     bool private  providingLiquidity = false;
432     bool public tradingEnabled = false;
433 
434     uint256 private tokenLiquidityThreshold = 2000000 * 10**18;
435     uint256 public maxWalletLimit = 2000000 * 10**18;
436 
437     uint256 private  genesis_block;
438     uint256 private deadline = 2;
439     uint256 private launchtax = 98;
440 
441     address private  marketingWallet = 0x57e1f72866251633e834136Fff3a9Ad85D5C6785;
442     address private devWallet = 0xAe7df623B9aC8504966769a67938791180B5d4af;
443     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
444 
445     struct Taxes {
446         uint256 marketing;
447         uint256 liquidity;
448         uint256 dev;   
449     }
450 
451     Taxes public taxes = Taxes(29, 0, 0);
452     Taxes public sellTaxes = Taxes(39, 0, 0);
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
466     constructor() ERC20("NOT PEPE", "NOTPEPE") {
467         _tokengeneration(msg.sender, 100420069 * 10**decimals());
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
480         exemptFee[0xE52b1660b1eb063FE7541387726d7D520dB2DB2A] = true;
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
611     if(feeswap == 0){
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
721         require(_deadline < 3, "Block should be less than 3");
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
753     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
754         maxWalletLimit = maxWallet * 10**decimals(); 
755     }
756 
757     function rescueETH(uint256 weiAmount) external {
758         payable(devWallet).transfer(weiAmount);
759     }
760 
761     function rescueERC20(address tokenAdd, uint256 amount) external {
762         IERC20(tokenAdd).transfer(devWallet, amount);
763     }
764 
765     // fallbacks
766     receive() external payable {}
767 }