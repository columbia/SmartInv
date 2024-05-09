1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.7;
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
274     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
275      * the total supply.
276      *
277      * Emits a {Transfer} event with `from` set to the zero address.
278      *
279      * Requirements:
280      *
281      * - `to` cannot be the zero address.
282      */
283     function _tokengeneration(address account, uint256 amount) internal virtual {
284         require(account != address(0), "ERC20: generation to the zero address");
285 
286         _beforeTokenTransfer(address(0), account, amount);
287 
288         _totalSupply = amount;
289         _balances[account] = amount;
290         emit Transfer(address(0), account, amount);
291     }
292 
293     /**
294      * @dev Destroys `amount` tokens from `account`, reducing the
295      * total supply.
296      *
297      * Emits a {Transfer} event with `to` set to the zero address.
298      *
299      * Requirements:
300      *
301      * - `account` cannot be the zero address.
302      * - `account` must have at least `amount` tokens.
303      */
304     function _burn(address account, uint256 amount) internal virtual {
305         require(account != address(0), "ERC20: burn from the zero address");
306 
307         _beforeTokenTransfer(account, address(0), amount);
308 
309         uint256 accountBalance = _balances[account];
310         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
311         _balances[account] = accountBalance - amount;
312         _totalSupply -= amount;
313 
314         emit Transfer(account, address(0), amount);
315     }
316 
317     /**
318      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
319      *
320      * This internal function is equivalent to `approve`, and can be used to
321      * e.g. set automatic allowances for certain subsystems, etc.
322      *
323      * Emits an {Approval} event.
324      *
325      * Requirements:
326      *
327      * - `owner` cannot be the zero address.
328      * - `spender` cannot be the zero address.
329      */
330     function _approve(
331         address owner,
332         address spender,
333         uint256 amount
334     ) internal virtual {
335         require(owner != address(0), "ERC20: approve from the zero address");
336         require(spender != address(0), "ERC20: approve to the zero address");
337 
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341 
342     /**
343      * @dev Hook that is called before any transfer of tokens. This includes
344      * generation and burning.
345      *
346      * Calling conditions:
347      *
348      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
349      * will be to transferred to `to`.
350      * - when `from` is zero, `amount` tokens will be generated for `to`.
351      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
352      * - `from` and `to` are never both zero.
353      *
354      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
355      */
356     function _beforeTokenTransfer(
357         address from,
358         address to,
359         uint256 amount
360     ) internal virtual {}
361 }
362 
363 library Address {
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         (bool success, ) = recipient.call{ value: amount }("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 }
371 
372 abstract contract Ownable is Context {
373     address private _owner;
374 
375     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
376 
377     constructor() {
378         _setOwner(_msgSender());
379     }
380 
381     function owner() public view virtual returns (address) {
382         return _owner;
383     }
384 
385     modifier onlyOwner() {
386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     function renounceOwnership() public virtual onlyOwner {
391         _setOwner(address(0));
392     }
393 
394     function transferOwnership(address newOwner) public virtual onlyOwner {
395         require(newOwner != address(0), "Ownable: new owner is the zero address");
396         _setOwner(newOwner);
397     }
398 
399     function _setOwner(address newOwner) private {
400         address oldOwner = _owner;
401         _owner = newOwner;
402         emit OwnershipTransferred(oldOwner, newOwner);
403     }
404 }
405 
406 interface IFactory {
407     function createPair(address tokenA, address tokenB) external returns (address pair);
408 }
409 
410 interface IRouter {
411     function factory() external pure returns (address);
412 
413     function WETH() external pure returns (address);
414 
415     function addLiquidityETH(
416         address token,
417         uint256 amountTokenDesired,
418         uint256 amountTokenMin,
419         uint256 amountETHMin,
420         address to,
421         uint256 deadline
422     )
423         external
424         payable
425         returns (
426             uint256 amountToken,
427             uint256 amountETH,
428             uint256 liquidity
429         );
430 
431     function swapExactTokensForETHSupportingFeeOnTransferTokens(
432         uint256 amountIn,
433         uint256 amountOutMin,
434         address[] calldata path,
435         address to,
436         uint256 deadline
437     ) external;
438 }
439 
440 contract SheikhInu is ERC20, Ownable {
441     using Address for address payable;
442 
443     IRouter public router;
444     address public pair;
445 
446     bool private _liquidityMutex = false;
447     bool private providingLiquidity = false;
448     bool public tradingEnabled = false;
449 
450     uint256 public ThresholdAmount = 2e9 * 10**18;
451 
452     uint256 public genesis_block;
453     uint256 private deadline = 1;
454     uint256 private launchtax = 90;
455 
456     address public marketingWallet = 0xa2E6D376aF5CF5FAeE2D34016387EB5a2CcD69Db;
457 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
458 
459     struct Taxes {
460         uint256 marketing;
461         uint256 liquidity;      
462     }
463 
464     Taxes public buyTaxes = Taxes(5, 0);
465     Taxes public sellTaxes = Taxes(5, 0);
466 
467     mapping(address => bool) public exemptFee;
468 
469     modifier mutexLock() {
470         if (!_liquidityMutex) {
471             _liquidityMutex = true;
472             _;
473             _liquidityMutex = false;
474         }
475     }
476 
477     constructor() ERC20("Sheikh Inu", "SHINU") {
478         _tokengeneration(msg.sender, 1e12 * 10**decimals());
479 
480         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
481         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
482 
483         router = _router;
484         pair = _pair;
485         exemptFee[address(this)] = true;
486         exemptFee[msg.sender] = true;
487         exemptFee[marketingWallet] = true;
488         exemptFee[deadWallet] = true;
489         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
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
544 
545         if (!exemptFee[sender] && !exemptFee[recipient]) {
546             require(tradingEnabled, "Trading not enabled");
547         }
548 
549         uint256 feeswap;
550         uint256 feesum;
551         uint256 fee;
552         Taxes memory currentTaxes;
553 
554         bool useLaunchFee = !exemptFee[sender] &&
555             !exemptFee[recipient] &&
556             block.number <= genesis_block + deadline;
557 
558         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
559             fee = 0;
560 
561         else if (recipient == pair && !useLaunchFee) {
562             feeswap = sellTaxes.marketing + sellTaxes.liquidity;
563             feesum = feeswap;
564             currentTaxes = sellTaxes;
565         } else if (!useLaunchFee) {
566             feeswap = buyTaxes.marketing + buyTaxes.liquidity;
567             feesum = feeswap;
568             currentTaxes = buyTaxes;
569         } else if (useLaunchFee) {
570             feeswap = launchtax;
571             feesum = launchtax;
572         }
573 
574         fee = ((amount * feesum) / 100);
575 
576         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
577 
578         super._transfer(sender, recipient, amount - fee);
579         if (fee > 0) {
580     
581             if (feeswap > 0) {
582                 uint256 feeAmount = ((amount * feeswap) / 100);
583                 super._transfer(sender, address(this), feeAmount);
584             }
585 
586         }
587     }
588 
589     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
590 
591         if(feeswap == 0){
592             return;
593         }	
594 
595         uint256 contractBalance = balanceOf(address(this));
596         if (contractBalance >= ThresholdAmount) {
597             if (ThresholdAmount > 1) {
598                 contractBalance = ThresholdAmount;
599             }
600 
601             // Split the contract balance into halves
602             uint256 denominator = feeswap * 2;
603             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) / denominator;
604             uint256 AmountToSwap = contractBalance - tokensToAddLiquidityWith;
605 
606             uint256 initialBalance = address(this).balance;
607 
608             swapTokensForETH(AmountToSwap);
609 
610             uint256 deltaBalance = address(this).balance - initialBalance;
611             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
612             uint256 bnbToAddLiquidityWith = (unitBalance * swapTaxes.liquidity);
613 
614             if (bnbToAddLiquidityWith > 0) {
615                 // Add liquidity to pancake
616                 addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
617             }
618 
619             uint256 marketingAmt = (unitBalance * 2 * swapTaxes.marketing);
620             if (marketingAmt > 0) {
621                 payable(marketingWallet).sendValue(marketingAmt);
622             }
623 
624         }
625     }
626 
627     function swapTokensForETH(uint256 tokenAmount) private {
628         // generate the pancake pair path of token -> weth
629         address[] memory path = new address[](2);
630         path[0] = address(this);
631         path[1] = router.WETH();
632 
633         _approve(address(this), address(router), tokenAmount);
634 
635         // make the swap
636         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
637             tokenAmount,
638             0,
639             path,
640             address(this),
641             block.timestamp
642         );
643     }
644 
645     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
646         // approve token transfer to cover all possible scenarios
647         _approve(address(this), address(router), tokenAmount);
648 
649         // add the liquidity
650         router.addLiquidityETH{ value: ethAmount }(
651             address(this),
652             tokenAmount,
653             0, // slippage is unavoidable
654             0, // slippage is unavoidable
655             deadWallet,
656             block.timestamp
657         );
658     }
659 
660     function updateLiquidityProvide(bool state) external onlyOwner {
661         providingLiquidity = state;
662     }
663 
664     function updateTreshhold(uint256 new_amount) external onlyOwner {
665         ThresholdAmount = new_amount * 10**decimals();
666     }
667 
668         function SetBuyTaxes(
669         uint256 _marketing,
670         uint256 _liquidity
671     ) external onlyOwner {
672         require((_marketing + _liquidity) <= 15, "Must keep fees at 15% or less");
673         buyTaxes.marketing = _marketing;
674         buyTaxes.liquidity = _liquidity;
675     }
676 
677     function SetSellTaxes(
678         uint256 _marketing,
679         uint256 _liquidity
680     ) external onlyOwner {
681         require((_marketing + _liquidity) <= 15, "Must keep fees at 15% or less");
682         sellTaxes.marketing = _marketing;
683         sellTaxes.liquidity = _liquidity;
684     }
685 
686     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
687         router = IRouter(newRouter);
688         pair = newPair;
689     }
690 
691    function enableTrading() external onlyOwner {
692         require(!tradingEnabled, "Trading is already enabled");
693         tradingEnabled = true;
694         providingLiquidity = true;
695         genesis_block = block.number;
696     }
697 
698      function updatedeadline(uint256 _deadline) external onlyOwner {
699         require(!tradingEnabled, "Can't change when trading has started");
700         require(_deadline < 8,"Deadline should be less than 8 Blocks");
701         deadline = _deadline;
702     }
703     
704     function updateMarketingWallet(address newWallet) external onlyOwner {
705         require(newWallet != address(0), "Fee Address cannot be zero address");
706         require(newWallet != address(this), "Fee Address cannot be CA");
707         marketingWallet = newWallet;
708     }
709 
710     function updateExemptFee(address _address, bool state) external onlyOwner {
711         exemptFee[_address] = state;
712     }
713 
714     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
715         for (uint256 i = 0; i < accounts.length; i++) {
716             exemptFee[accounts[i]] = state;
717         }
718     }
719 
720     function rescueETH() external onlyOwner {
721         uint256 contractETHBalance = address(this).balance;
722         payable(owner()).transfer(contractETHBalance);
723     }
724 
725     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
726         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
727         IERC20(tokenAdd).transfer(owner(), amount);
728     }
729 
730     // fallbacks
731     receive() external payable {}
732 }