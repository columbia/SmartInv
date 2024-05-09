1 //SPDX-License-Identifier: UNLICENSED
2 
3 /**
4 Telegram: https://t.me/babyshiberc
5 Twitter: https://x.com/babyshiberc
6 Website: https://babyshib.vip
7 
8 In 2020, Shiba Inu was gifted to mankind by Ryoshi
9 
10 Shiba Inu exceeded all expectations, but something was lacking
11 
12 An heir to carry on its esteemed legacy 
13 
14 Hence, the birth of Baby Shiba Inu in 2023
15 
16 The one and only ideal homage to Shib
17 
18 And the arch-rival of Baby Doge 
19 
20 Following the path paved by Ryoshi
21 
22 It was fate
23 
24 Both Shiba Inu and Baby Shiba Inu
25 
26 Will rule the memecoin world
27 
28 United in ascent
29 
30 Byoshi.
31 */
32 
33 pragma solidity ^0.8.19;
34 
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes calldata) {
41         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
42         return msg.data;
43     }
44 }
45 
46 interface IERC20 {
47     function totalSupply() external view returns (uint256);
48 
49     function balanceOf(address account) external view returns (uint256);
50 
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     function transferFrom(
58         address sender,
59         address recipient,
60         uint256 amount
61     ) external returns (bool);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 interface IERC20Metadata is IERC20 {
69     /**
70      * @dev Returns the name of the token.
71      */
72     function name() external view returns (string memory);
73 
74     /**
75      * @dev Returns the symbol of the token.
76      */
77     function symbol() external view returns (string memory);
78 
79     /**
80      * @dev Returns the decimals places of the token.
81      */
82     function decimals() external view returns (uint8);
83 }
84 
85 contract ERC20 is Context, IERC20, IERC20Metadata {
86     mapping(address => uint256) internal _balances;
87 
88     mapping(address => mapping(address => uint256)) internal _allowances;
89 
90     uint256 private _totalSupply;
91 
92     string private _name;
93     string private _symbol;
94 
95     
96     constructor(string memory name_, string memory symbol_) {
97         _name = name_;
98         _symbol = symbol_;
99     }
100 
101     
102     function name() public view virtual override returns (string memory) {
103         return _name;
104     }
105 
106     
107     function symbol() public view virtual override returns (string memory) {
108         return _symbol;
109     }
110 
111     
112     function decimals() public view virtual override returns (uint8) {
113         return 18;
114     }
115 
116     
117     function totalSupply() public view virtual override returns (uint256) {
118         return _totalSupply;
119     }
120 
121     
122     function balanceOf(address account) public view virtual override returns (uint256) {
123         return _balances[account];
124     }
125 
126     
127     function transfer(address recipient, uint256 amount)
128         public
129         virtual
130         override
131         returns (bool)
132     {
133         _transfer(_msgSender(), recipient, amount);
134         return true;
135     }
136 
137     
138     function allowance(address owner, address spender)
139         public
140         view
141         virtual
142         override
143         returns (uint256)
144     {
145         return _allowances[owner][spender];
146     }
147 
148     
149     function approve(address spender, uint256 amount) public virtual override returns (bool) {
150         _approve(_msgSender(), spender, amount);
151         return true;
152     }
153 
154     
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) public virtual override returns (bool) {
160         _transfer(sender, recipient, amount);
161 
162         uint256 currentAllowance = _allowances[sender][_msgSender()];
163         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
164         _approve(sender, _msgSender(), currentAllowance - amount);
165 
166         return true;
167     }
168 
169     
170     function increaseAllowance(address spender, uint256 addedValue)
171         public
172         virtual
173         returns (bool)
174     {
175         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
176         return true;
177     }
178 
179     
180     function decreaseAllowance(address spender, uint256 subtractedValue)
181         public
182         virtual
183         returns (bool)
184     {
185         uint256 currentAllowance = _allowances[_msgSender()][spender];
186         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
187         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
188 
189         return true;
190     }
191 
192     
193     function _transfer(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) internal virtual {
198         require(sender != address(0), "ERC20: transfer from the zero address");
199         require(recipient != address(0), "ERC20: transfer to the zero address");
200 
201         _beforeTokenTransfer(sender, recipient, amount);
202 
203         uint256 senderBalance = _balances[sender];
204         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
205         _balances[sender] = senderBalance - amount;
206         _balances[recipient] += amount;
207 
208         emit Transfer(sender, recipient, amount);
209     }
210 
211     
212     function _tokengeneration(address account, uint256 amount) internal virtual {
213         require(account != address(0), "ERC20: generation to the zero address");
214 
215         _beforeTokenTransfer(address(0), account, amount);
216 
217         _totalSupply = amount;
218         _balances[account] = amount;
219         emit Transfer(address(0), account, amount);
220     }
221 
222     
223     function _approve(
224         address owner,
225         address spender,
226         uint256 amount
227     ) internal virtual {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230 
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 
235     
236     function _beforeTokenTransfer(
237         address from,
238         address to,
239         uint256 amount
240     ) internal virtual {}
241 }
242 
243 library Address {
244     function sendValue(address payable recipient, uint256 amount) internal {
245         require(address(this).balance >= amount, "Address: insufficient balance");
246 
247         (bool success, ) = recipient.call{ value: amount }("");
248         require(success, "Address: unable to send value, recipient may have reverted");
249     }
250 }
251 
252 abstract contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     constructor() {
258         _setOwner(_msgSender());
259     }
260 
261     function owner() public view virtual returns (address) {
262         return _owner;
263     }
264 
265     modifier onlyOwner() {
266         require(owner() == _msgSender(), "Ownable: caller is not the owner");
267         _;
268     }
269 
270     function renounceOwnership() public virtual onlyOwner {
271         _setOwner(address(0));
272     }
273 
274     function transferOwnership(address newOwner) public virtual onlyOwner {
275         require(newOwner != address(0), "Ownable: new owner is the zero address");
276         _setOwner(newOwner);
277     }
278 
279     function _setOwner(address newOwner) private {
280         address oldOwner = _owner;
281         _owner = newOwner;
282         emit OwnershipTransferred(oldOwner, newOwner);
283     }
284 }
285 
286 interface IFactory {
287     function createPair(address tokenA, address tokenB) external returns (address pair);
288 }
289 
290 interface IRouter {
291     function factory() external pure returns (address);
292 
293     function WETH() external pure returns (address);
294 
295     function addLiquidityETH(
296         address token,
297         uint256 amountTokenDesired,
298         uint256 amountTokenMin,
299         uint256 amountETHMin,
300         address to,
301         uint256 deadline
302     )
303         external
304         payable
305         returns (
306             uint256 amountToken,
307             uint256 amountETH,
308             uint256 liquidity
309         );
310 
311     function swapExactTokensForETHSupportingFeeOnTransferTokens(
312         uint256 amountIn,
313         uint256 amountOutMin,
314         address[] calldata path,
315         address to,
316         uint256 deadline
317     ) external;
318 }
319 
320 contract BabyShibaInu is ERC20, Ownable {
321     using Address for address payable;
322 
323     IRouter public router;
324     address public pair;
325 
326     bool private _liquidityMutex = false;
327     bool private  providingLiquidity = false;
328     bool public tradingEnabled = false;
329 
330     uint256 private  tokenLiquidityThreshold = 3360000 * 10**18;
331     uint256 public maxWalletLimit = 4200000 * 10**18;
332 
333     uint256 private  genesis_block;
334     uint256 private deadline = 1;
335     uint256 private launchtax = 95;
336 
337     address private  marketingWallet = 0x12BB78886e28266A8025532285a75810eA20fDc1;
338 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
339 
340     struct Taxes {
341         uint256 marketing;
342         uint256 liquidity;
343     }
344 
345     Taxes public taxes = Taxes(20, 0);
346     Taxes public sellTaxes = Taxes(95, 0);
347 
348     mapping(address => bool) public exemptFee;
349     mapping(address => bool) private isearlybuyer;
350 
351 
352     modifier mutexLock() {
353         if (!_liquidityMutex) {
354             _liquidityMutex = true;
355             _;
356             _liquidityMutex = false;
357         }
358     }
359 
360     constructor() ERC20("Baby Shiba Inu", "BABYSHIB") {
361         _tokengeneration(msg.sender, 420000000 * 10**decimals());
362 
363         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
364         // Create a pair for this new token
365         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
366 
367         router = _router;
368         pair = _pair;
369         exemptFee[address(this)] = true;
370         exemptFee[msg.sender] = true;
371         exemptFee[marketingWallet] = true;
372         exemptFee[deadWallet] = true;
373         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
374         exemptFee[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true;
375     }
376 
377     function approve(address spender, uint256 amount) public override returns (bool) {
378         _approve(_msgSender(), spender, amount);
379         return true;
380     }
381 
382     function transferFrom(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) public override returns (bool) {
387         _transfer(sender, recipient, amount);
388 
389         uint256 currentAllowance = _allowances[sender][_msgSender()];
390         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
391         _approve(sender, _msgSender(), currentAllowance - amount);
392 
393         return true;
394     }
395 
396     function increaseAllowance(address spender, uint256 addedValue)
397         public
398         override
399         returns (bool)
400     {
401         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
402         return true;
403     }
404 
405     function decreaseAllowance(address spender, uint256 subtractedValue)
406         public
407         override
408         returns (bool)
409     {
410         uint256 currentAllowance = _allowances[_msgSender()][spender];
411         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
412         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
413 
414         return true;
415     }
416 
417     function transfer(address recipient, uint256 amount) public override returns (bool) {
418         _transfer(msg.sender, recipient, amount);
419         return true;
420     }
421 
422     function _transfer(
423         address sender,
424         address recipient,
425         uint256 amount
426     ) internal override {
427         require(amount > 0, "Transfer amount must be greater than zero");
428         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
429             "You can't transfer tokens"
430         );
431 
432         if (!exemptFee[sender] && !exemptFee[recipient]) {
433             require(tradingEnabled, "Trading not enabled");
434         }
435 
436         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
437             require(balanceOf(recipient) + amount <= maxWalletLimit,
438                 "You are exceeding maxWalletLimit"
439             );
440         }
441 
442         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
443            
444             if (recipient != pair) {
445                 require(balanceOf(recipient) + amount <= maxWalletLimit,
446                     "You are exceeding maxWalletLimit"
447                 );
448             }
449         }
450 
451         uint256 feeswap;
452         uint256 feesum;
453         uint256 fee;
454         Taxes memory currentTaxes;
455 
456         bool useLaunchFee = !exemptFee[sender] &&
457             !exemptFee[recipient] &&
458             block.number < genesis_block + deadline;
459 
460         //set fee to zero if fees in contract are handled or exempted
461         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
462             fee = 0;
463 
464             //calculate fee
465         else if (recipient == pair && !useLaunchFee) {
466             feeswap =
467                 sellTaxes.liquidity +
468                 sellTaxes.marketing ;
469             feesum = feeswap;
470             currentTaxes = sellTaxes;
471         } else if (!useLaunchFee) {
472             feeswap =
473                 taxes.liquidity +
474                 taxes.marketing ;
475             feesum = feeswap;
476             currentTaxes = taxes;
477         } else if (useLaunchFee) {
478             feeswap = launchtax;
479             feesum = launchtax;
480         }
481 
482         fee = (amount * feesum) / 100;
483 
484         //send fees if threshold has been reached
485         //don't do this on buys, breaks swap
486         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
487 
488         //rest to recipient
489         super._transfer(sender, recipient, amount - fee);
490         if (fee > 0) {
491             //send the fee to the contract
492             if (feeswap > 0) {
493                 uint256 feeAmount = (amount * feeswap) / 100;
494                 super._transfer(sender, address(this), feeAmount);
495             }
496 
497         }
498     }
499 
500     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
501 
502 	if(feeswap == 0){
503             return;
504         }	
505 
506         uint256 contractBalance = balanceOf(address(this));
507         if (contractBalance >= tokenLiquidityThreshold) {
508             if (tokenLiquidityThreshold > 1) {
509                 contractBalance = tokenLiquidityThreshold;
510             }
511 
512             // Split the contract balance into halves
513             uint256 denominator = feeswap * 2;
514             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
515                 denominator;
516             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
517 
518             uint256 initialBalance = address(this).balance;
519 
520             swapTokensForETH(toSwap);
521 
522             uint256 deltaBalance = address(this).balance - initialBalance;
523             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
524             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
525 
526             if (ethToAddLiquidityWith > 0) {
527                 // Add liquidity
528                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
529             }
530 
531             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
532             if (marketingAmt > 0) {
533                 payable(marketingWallet).sendValue(marketingAmt);
534             }
535 
536         }
537     }
538 
539     function swapTokensForETH(uint256 tokenAmount) private {
540         // generate the pair path of token -> weth
541         address[] memory path = new address[](2);
542         path[0] = address(this);
543         path[1] = router.WETH();
544 
545         _approve(address(this), address(router), tokenAmount);
546 
547         // make the swap
548         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
549             tokenAmount,
550             0,
551             path,
552             address(this),
553             block.timestamp
554         );
555     }
556 
557     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
558         // approve token transfer to cover all possible scenarios
559         _approve(address(this), address(router), tokenAmount);
560 
561         // add the liquidity
562         router.addLiquidityETH{ value: ethAmount }(
563             address(this),
564             tokenAmount,
565             0, // slippage is unavoidable
566             0, // slippage is unavoidable
567             deadWallet,
568             block.timestamp
569         );
570     }
571 
572     function updateLiquidityProvide(bool state) external onlyOwner {
573         //update liquidity providing state
574         providingLiquidity = state;
575     }
576 
577     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
578         //update the treshhold
579         tokenLiquidityThreshold = new_amount * 10**decimals();
580     }
581 
582     function UpdateBuyTaxes(
583         uint256 _marketing,
584         uint256 _liquidity
585     ) external onlyOwner {
586         taxes = Taxes(_marketing, _liquidity);
587     }
588 
589     function SetSellTaxes(
590         uint256 _marketing,
591         uint256 _liquidity
592     ) external onlyOwner {
593         sellTaxes = Taxes(_marketing, _liquidity);
594     }
595 
596    function enableTrading() external onlyOwner {
597         require(!tradingEnabled, "Trading is already enabled");
598         tradingEnabled = true;
599         providingLiquidity = true;
600         genesis_block = block.number;
601     }
602 
603     function updatedeadline(uint256 _deadline) external onlyOwner {
604         require(!tradingEnabled, "Can't change when trading has started");
605         deadline = _deadline;
606     }
607 
608     function updateMarketingWallet(address newWallet) external onlyOwner {
609         marketingWallet = newWallet;
610     }
611 
612     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
613         isearlybuyer[account] = state;
614     }
615 
616     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
617         for (uint256 i = 0; i < accounts.length; i++) {
618             isearlybuyer[accounts[i]] = state;
619         }
620     }
621 
622     function AddExemptFee(address _address) external onlyOwner {
623         exemptFee[_address] = true;
624     }
625 
626     function RemoveExemptFee(address _address) external onlyOwner {
627         exemptFee[_address] = false;
628     }
629 
630     function AddbulkExemptFee(address[] memory accounts) external onlyOwner {
631         for (uint256 i = 0; i < accounts.length; i++) {
632             exemptFee[accounts[i]] = true;
633         }
634     }
635 
636     function RemovebulkExemptFee(address[] memory accounts) external onlyOwner {
637         for (uint256 i = 0; i < accounts.length; i++) {
638             exemptFee[accounts[i]] = false;
639         }
640     }
641 
642     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
643         maxWalletLimit = maxWallet * 10**decimals(); 
644     }
645 
646     function rescueETH(uint256 weiAmount) external onlyOwner {
647         payable(owner()).transfer(weiAmount);
648     }
649 
650     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
651         IERC20(tokenAdd).transfer(owner(), amount);
652     }
653 
654     // fallbacks
655     receive() external payable {}
656 }