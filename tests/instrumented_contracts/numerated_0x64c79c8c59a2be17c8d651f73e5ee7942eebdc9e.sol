1 //SPDX-License-Identifier: UNLICENSED
2 
3 /**
4 
5 Elon Cat $SCHRODINGER is inspired by both the famous quantum physics thought experiment and Elon Musk's cat named Schrödinger.
6 
7 Telegram: https://t.me/eloncat_coin
8 Twitter: https://x.com/eloncat_coin
9 Website: https://eloncat.io
10 
11 
12 */
13 
14 pragma solidity ^0.8.19;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29 
30     function balanceOf(address account) external view returns (uint256);
31 
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     function approve(address spender, uint256 amount) external returns (bool);
37 
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 interface IERC20Metadata is IERC20 {
50     /**
51      * @dev Returns the name of the token.
52      */
53     function name() external view returns (string memory);
54 
55     /**
56      * @dev Returns the symbol of the token.
57      */
58     function symbol() external view returns (string memory);
59 
60     /**
61      * @dev Returns the decimals places of the token.
62      */
63     function decimals() external view returns (uint8);
64 }
65 
66 contract ERC20 is Context, IERC20, IERC20Metadata {
67     mapping(address => uint256) internal _balances;
68 
69     mapping(address => mapping(address => uint256)) internal _allowances;
70 
71     uint256 private _totalSupply;
72 
73     string private _name;
74     string private _symbol;
75 
76     
77     constructor(string memory name_, string memory symbol_) {
78         _name = name_;
79         _symbol = symbol_;
80     }
81 
82     
83     function name() public view virtual override returns (string memory) {
84         return _name;
85     }
86 
87     
88     function symbol() public view virtual override returns (string memory) {
89         return _symbol;
90     }
91 
92     
93     function decimals() public view virtual override returns (uint8) {
94         return 18;
95     }
96 
97     
98     function totalSupply() public view virtual override returns (uint256) {
99         return _totalSupply;
100     }
101 
102     
103     function balanceOf(address account) public view virtual override returns (uint256) {
104         return _balances[account];
105     }
106 
107     
108     function transfer(address recipient, uint256 amount)
109         public
110         virtual
111         override
112         returns (bool)
113     {
114         _transfer(_msgSender(), recipient, amount);
115         return true;
116     }
117 
118     
119     function allowance(address owner, address spender)
120         public
121         view
122         virtual
123         override
124         returns (uint256)
125     {
126         return _allowances[owner][spender];
127     }
128 
129     
130     function approve(address spender, uint256 amount) public virtual override returns (bool) {
131         _approve(_msgSender(), spender, amount);
132         return true;
133     }
134 
135     
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) public virtual override returns (bool) {
141         _transfer(sender, recipient, amount);
142 
143         uint256 currentAllowance = _allowances[sender][_msgSender()];
144         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
145         _approve(sender, _msgSender(), currentAllowance - amount);
146 
147         return true;
148     }
149 
150     
151     function increaseAllowance(address spender, uint256 addedValue)
152         public
153         virtual
154         returns (bool)
155     {
156         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
157         return true;
158     }
159 
160     
161     function decreaseAllowance(address spender, uint256 subtractedValue)
162         public
163         virtual
164         returns (bool)
165     {
166         uint256 currentAllowance = _allowances[_msgSender()][spender];
167         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
168         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
169 
170         return true;
171     }
172 
173     
174     function _transfer(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) internal virtual {
179         require(sender != address(0), "ERC20: transfer from the zero address");
180         require(recipient != address(0), "ERC20: transfer to the zero address");
181 
182         _beforeTokenTransfer(sender, recipient, amount);
183 
184         uint256 senderBalance = _balances[sender];
185         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
186         _balances[sender] = senderBalance - amount;
187         _balances[recipient] += amount;
188 
189         emit Transfer(sender, recipient, amount);
190     }
191 
192     
193     function _tokengeneration(address account, uint256 amount) internal virtual {
194         require(account != address(0), "ERC20: generation to the zero address");
195 
196         _beforeTokenTransfer(address(0), account, amount);
197 
198         _totalSupply = amount;
199         _balances[account] = amount;
200         emit Transfer(address(0), account, amount);
201     }
202 
203     
204     function _approve(
205         address owner,
206         address spender,
207         uint256 amount
208     ) internal virtual {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211 
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     
217     function _beforeTokenTransfer(
218         address from,
219         address to,
220         uint256 amount
221     ) internal virtual {}
222 }
223 
224 library Address {
225     function sendValue(address payable recipient, uint256 amount) internal {
226         require(address(this).balance >= amount, "Address: insufficient balance");
227 
228         (bool success, ) = recipient.call{ value: amount }("");
229         require(success, "Address: unable to send value, recipient may have reverted");
230     }
231 }
232 
233 abstract contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     constructor() {
239         _setOwner(_msgSender());
240     }
241 
242     function owner() public view virtual returns (address) {
243         return _owner;
244     }
245 
246     modifier onlyOwner() {
247         require(owner() == _msgSender(), "Ownable: caller is not the owner");
248         _;
249     }
250 
251     function renounceOwnership() public virtual onlyOwner {
252         _setOwner(address(0));
253     }
254 
255     function transferOwnership(address newOwner) public virtual onlyOwner {
256         require(newOwner != address(0), "Ownable: new owner is the zero address");
257         _setOwner(newOwner);
258     }
259 
260     function _setOwner(address newOwner) private {
261         address oldOwner = _owner;
262         _owner = newOwner;
263         emit OwnershipTransferred(oldOwner, newOwner);
264     }
265 }
266 
267 interface IFactory {
268     function createPair(address tokenA, address tokenB) external returns (address pair);
269 }
270 
271 interface IRouter {
272     function factory() external pure returns (address);
273 
274     function WETH() external pure returns (address);
275 
276     function addLiquidityETH(
277         address token,
278         uint256 amountTokenDesired,
279         uint256 amountTokenMin,
280         uint256 amountETHMin,
281         address to,
282         uint256 deadline
283     )
284         external
285         payable
286         returns (
287             uint256 amountToken,
288             uint256 amountETH,
289             uint256 liquidity
290         );
291 
292     function swapExactTokensForETHSupportingFeeOnTransferTokens(
293         uint256 amountIn,
294         uint256 amountOutMin,
295         address[] calldata path,
296         address to,
297         uint256 deadline
298     ) external;
299 }
300 
301 contract ElonCat is ERC20, Ownable {
302     using Address for address payable;
303 
304     IRouter public router;
305     address public pair;
306 
307     bool private _liquidityMutex = false;
308     bool private  providingLiquidity = false;
309     bool public tradingEnabled = false;
310 
311     uint256 private  tokenLiquidityThreshold = 3780000 * 10**18;
312     uint256 public maxWalletLimit = 4200000 * 10**18;
313 
314     uint256 private  genesis_block;
315     uint256 private deadline = 1;
316     uint256 private launchtax = 95;
317 
318     address private  marketingWallet = 0xa862b50977556B27be0cEa725a08B8BfC87263f3;
319 	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
320 
321     struct Taxes {
322         uint256 marketing;
323         uint256 liquidity;
324     }
325 
326     Taxes public taxes = Taxes(18, 2);
327     Taxes public sellTaxes = Taxes(40, 2);
328 
329     mapping(address => bool) public exemptFee;
330     mapping(address => bool) private isearlybuyer;
331 
332 
333     modifier mutexLock() {
334         if (!_liquidityMutex) {
335             _liquidityMutex = true;
336             _;
337             _liquidityMutex = false;
338         }
339     }
340 
341     constructor() ERC20("Elon Cat", "SCHRODINGER") {
342         _tokengeneration(msg.sender, 420000000 * 10**decimals());
343 
344         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
345         // Create a pair for this new token
346         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
347 
348         router = _router;
349         pair = _pair;
350         exemptFee[address(this)] = true;
351         exemptFee[msg.sender] = true;
352         exemptFee[marketingWallet] = true;
353         exemptFee[deadWallet] = true;
354         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
355         exemptFee[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true;
356     }
357 
358     function approve(address spender, uint256 amount) public override returns (bool) {
359         _approve(_msgSender(), spender, amount);
360         return true;
361     }
362 
363     function transferFrom(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) public override returns (bool) {
368         _transfer(sender, recipient, amount);
369 
370         uint256 currentAllowance = _allowances[sender][_msgSender()];
371         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
372         _approve(sender, _msgSender(), currentAllowance - amount);
373 
374         return true;
375     }
376 
377     function increaseAllowance(address spender, uint256 addedValue)
378         public
379         override
380         returns (bool)
381     {
382         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
383         return true;
384     }
385 
386     function decreaseAllowance(address spender, uint256 subtractedValue)
387         public
388         override
389         returns (bool)
390     {
391         uint256 currentAllowance = _allowances[_msgSender()][spender];
392         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
393         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
394 
395         return true;
396     }
397 
398     function transfer(address recipient, uint256 amount) public override returns (bool) {
399         _transfer(msg.sender, recipient, amount);
400         return true;
401     }
402 
403     function _transfer(
404         address sender,
405         address recipient,
406         uint256 amount
407     ) internal override {
408         require(amount > 0, "Transfer amount must be greater than zero");
409         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
410             "You can't transfer tokens"
411         );
412 
413         if (!exemptFee[sender] && !exemptFee[recipient]) {
414             require(tradingEnabled, "Trading not enabled");
415         }
416 
417         if (sender == pair && !exemptFee[recipient] && !_liquidityMutex) {
418             require(balanceOf(recipient) + amount <= maxWalletLimit,
419                 "You are exceeding maxWalletLimit"
420             );
421         }
422 
423         if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
424            
425             if (recipient != pair) {
426                 require(balanceOf(recipient) + amount <= maxWalletLimit,
427                     "You are exceeding maxWalletLimit"
428                 );
429             }
430         }
431 
432         uint256 feeswap;
433         uint256 feesum;
434         uint256 fee;
435         Taxes memory currentTaxes;
436 
437         bool useLaunchFee = !exemptFee[sender] &&
438             !exemptFee[recipient] &&
439             block.number < genesis_block + deadline;
440 
441         //set fee to zero if fees in contract are handled or exempted
442         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
443             fee = 0;
444 
445             //calculate fee
446         else if (recipient == pair && !useLaunchFee) {
447             feeswap =
448                 sellTaxes.liquidity +
449                 sellTaxes.marketing ;
450             feesum = feeswap;
451             currentTaxes = sellTaxes;
452         } else if (!useLaunchFee) {
453             feeswap =
454                 taxes.liquidity +
455                 taxes.marketing ;
456             feesum = feeswap;
457             currentTaxes = taxes;
458         } else if (useLaunchFee) {
459             feeswap = launchtax;
460             feesum = launchtax;
461         }
462 
463         fee = (amount * feesum) / 100;
464 
465         //send fees if threshold has been reached
466         //don't do this on buys, breaks swap
467         if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);
468 
469         //rest to recipient
470         super._transfer(sender, recipient, amount - fee);
471         if (fee > 0) {
472             //send the fee to the contract
473             if (feeswap > 0) {
474                 uint256 feeAmount = (amount * feeswap) / 100;
475                 super._transfer(sender, address(this), feeAmount);
476             }
477 
478         }
479     }
480 
481     function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
482 
483 	if(feeswap == 0){
484             return;
485         }	
486 
487         uint256 contractBalance = balanceOf(address(this));
488         if (contractBalance >= tokenLiquidityThreshold) {
489             if (tokenLiquidityThreshold > 1) {
490                 contractBalance = tokenLiquidityThreshold;
491             }
492 
493             // Split the contract balance into halves
494             uint256 denominator = feeswap * 2;
495             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
496                 denominator;
497             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
498 
499             uint256 initialBalance = address(this).balance;
500 
501             swapTokensForETH(toSwap);
502 
503             uint256 deltaBalance = address(this).balance - initialBalance;
504             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
505             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
506 
507             if (ethToAddLiquidityWith > 0) {
508                 // Add liquidity
509                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
510             }
511 
512             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
513             if (marketingAmt > 0) {
514                 payable(marketingWallet).sendValue(marketingAmt);
515             }
516 
517         }
518     }
519 
520     function swapTokensForETH(uint256 tokenAmount) private {
521         // generate the pair path of token -> weth
522         address[] memory path = new address[](2);
523         path[0] = address(this);
524         path[1] = router.WETH();
525 
526         _approve(address(this), address(router), tokenAmount);
527 
528         // make the swap
529         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
530             tokenAmount,
531             0,
532             path,
533             address(this),
534             block.timestamp
535         );
536     }
537 
538     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
539         // approve token transfer to cover all possible scenarios
540         _approve(address(this), address(router), tokenAmount);
541 
542         // add the liquidity
543         router.addLiquidityETH{ value: ethAmount }(
544             address(this),
545             tokenAmount,
546             0, // slippage is unavoidable
547             0, // slippage is unavoidable
548             deadWallet,
549             block.timestamp
550         );
551     }
552 
553     function updateLiquidityProvide(bool state) external onlyOwner {
554         //update liquidity providing state
555         providingLiquidity = state;
556     }
557 
558     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
559         //update the treshhold
560         tokenLiquidityThreshold = new_amount * 10**decimals();
561     }
562 
563     function UpdateBuyTaxes(
564         uint256 _marketing,
565         uint256 _liquidity
566     ) external onlyOwner {
567         taxes = Taxes(_marketing, _liquidity);
568     }
569 
570     function SetSellTaxes(
571         uint256 _marketing,
572         uint256 _liquidity
573     ) external onlyOwner {
574         sellTaxes = Taxes(_marketing, _liquidity);
575     }
576 
577    function enableTrading() external onlyOwner {
578         require(!tradingEnabled, "Trading is already enabled");
579         tradingEnabled = true;
580         providingLiquidity = true;
581         genesis_block = block.number;
582     }
583 
584     function updatedeadline(uint256 _deadline) external onlyOwner {
585         require(!tradingEnabled, "Can't change when trading has started");
586         deadline = _deadline;
587     }
588 
589     function updateMarketingWallet(address newWallet) external onlyOwner {
590         marketingWallet = newWallet;
591     }
592 
593     function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
594         isearlybuyer[account] = state;
595     }
596 
597     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
598         for (uint256 i = 0; i < accounts.length; i++) {
599             isearlybuyer[accounts[i]] = state;
600         }
601     }
602 
603     function AddExemptFee(address _address) external onlyOwner {
604         exemptFee[_address] = true;
605     }
606 
607     function RemoveExemptFee(address _address) external onlyOwner {
608         exemptFee[_address] = false;
609     }
610 
611     function AddbulkExemptFee(address[] memory accounts) external onlyOwner {
612         for (uint256 i = 0; i < accounts.length; i++) {
613             exemptFee[accounts[i]] = true;
614         }
615     }
616 
617     function RemovebulkExemptFee(address[] memory accounts) external onlyOwner {
618         for (uint256 i = 0; i < accounts.length; i++) {
619             exemptFee[accounts[i]] = false;
620         }
621     }
622 
623     function updateMaxWalletLimit(uint256 maxWallet) external onlyOwner {
624         maxWalletLimit = maxWallet * 10**decimals(); 
625     }
626 
627     function rescueETH(uint256 weiAmount) external onlyOwner {
628         payable(owner()).transfer(weiAmount);
629     }
630 
631     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
632         IERC20(tokenAdd).transfer(owner(), amount);
633     }
634 
635     // fallbacks
636     receive() external payable {}
637 }