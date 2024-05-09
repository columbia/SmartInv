1 /**
2 https://twitter.com/EthKusanagi
3 https://medium.com/@info_22734/kusanagi-no-tsurugi-%E8%8D%89%E8%96%99%E3%81%AE%E5%89%A3-579c7a860343
4 https://t.me/KusanaginotsurugiPortal
5 https://kusanaginotsurugi.com
6 
7 TOKENOMICS
8 
9 - 6% Buy
10 - 6% Sell
11 - 1% Liquidity
12 - 2% Dev
13 - 3% Treasury
14 */
15 
16 // SPDX-License-Identifier: NOLICENSE
17 
18 pragma solidity ^0.8.7;
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
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 
47     function _msgData() internal view virtual returns (bytes calldata) {
48         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
49         return msg.data;
50     }
51 }
52 
53 abstract contract Ownable is Context {
54     address private _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     constructor() {
59         _setOwner(_msgSender());
60     }
61 
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function renounceOwnership() public virtual onlyOwner {
72         _setOwner(address(0));
73     }
74 
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         _setOwner(newOwner);
78     }
79 
80     function _setOwner(address newOwner) private {
81         address oldOwner = _owner;
82         _owner = newOwner;
83         emit OwnershipTransferred(oldOwner, newOwner);
84     }
85 }
86 
87 interface IFactory{
88         function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IRouter {
92     function factory() external pure returns (address);
93     function WETH() external pure returns (address);
94     function addLiquidityETH(
95         address token,
96         uint amountTokenDesired,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102 
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline) external;
109 }
110 
111 library Address{
112     function sendValue(address payable recipient, uint256 amount) internal {
113         require(address(this).balance >= amount, "Address: insufficient balance");
114 
115         (bool success, ) = recipient.call{value: amount}("");
116         require(success, "Address: unable to send value, recipient may have reverted");
117     }
118 }
119 
120 
121 contract Kusanagi is Context, IERC20, Ownable {
122     using Address for address payable;
123     
124     mapping (address => uint256) private _rOwned;
125     mapping (address => uint256) private _tOwned;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping (address => bool) private _isExcluded;
129     mapping (address => bool) public allowedTransfer;
130     mapping (address => bool) private _isBlacklisted;
131 
132     address[] private _excluded;
133 
134     bool public tradingEnabled;
135     bool public swapEnabled;
136     bool private swapping;
137 
138     //Anti Dump
139     mapping(address => uint256) private _lastSell;
140     bool public coolDownEnabled = false;
141     uint256 public coolDownTime = 0 seconds;
142     
143     modifier antiBot(address account){
144         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
145         _;
146     }
147 
148     IRouter public router;
149     address public pair;
150 
151     uint8 private constant _decimals = 9;
152     uint256 private constant MAX = ~uint256(0);
153 
154     uint256 private _tTotal = 1e8 * 10**_decimals;
155     uint256 private _rTotal = (MAX - (MAX % _tTotal));
156 
157     uint256 public swapTokensAtAmount = 1_000_000 * 10**9;
158     uint256 public maxBuyLimit = 2_000_000 * 10**9;
159     uint256 public maxSellLimit = 2_000_000 * 10**9;
160     uint256 public maxWalletLimit = 2_000_000 * 10**9;
161     
162     uint256 public genesis_block;
163     
164     address public developmentWallet = 0xA524c1f122E89BCD95301278f4C06f196Eeb5831;
165     address public treasuryWallet = 0x4221427F10F87Eb7EB9860f8aC8095D0AA6b0977;
166 
167     string private constant _name = "Kusanagi No Tsurugi";
168     string private constant _symbol = "KUSANAGI";
169 
170     struct Taxes {
171         uint256 rfi;
172         uint256 burn;
173         uint256 liquidity; 
174         uint256 treasury;
175     }
176 
177     Taxes public taxes = Taxes(0, 2, 1, 3);
178     Taxes public sellTaxes = Taxes(0, 2, 1, 3);
179 
180     struct TotFeesPaidStruct{
181         uint256 rfi;
182         uint256 burn;
183         uint256 liquidity; 
184         uint256 treasury;
185     }
186     
187     TotFeesPaidStruct public totFeesPaid;
188 
189     struct valuesFromGetValues{
190       uint256 rAmount;
191       uint256 rTransferAmount;
192       uint256 rRfi;
193       uint256 rburn;
194       uint256 rLiquidity;
195       uint256 rtreasury;
196       uint256 tTransferAmount;
197       uint256 tRfi;
198       uint256 tburn;
199       uint256 tLiquidity;
200       uint256 ttreasury;
201     }
202 
203     event FeesChanged();
204     event UpdatedRouter(address oldRouter, address newRouter);
205 
206     modifier lockTheSwap {
207         swapping = true;
208         _;
209         swapping = false;
210     }
211 
212     constructor (address routerAddress) {
213         IRouter _router = IRouter(routerAddress);
214         address _pair = IFactory(_router.factory())
215             .createPair(address(this), _router.WETH());
216 
217         router = _router;
218         pair = _pair;
219         
220         excludeFromReward(pair);
221 
222         _rOwned[owner()] = _rTotal;
223         _isExcludedFromFee[address(this)] = true;
224         _isExcludedFromFee[owner()] = true;
225         _isExcludedFromFee[developmentWallet] = true;
226         _isExcludedFromFee[treasuryWallet] = true;
227         
228         allowedTransfer[address(this)] = true;
229         allowedTransfer[owner()] = true;
230         allowedTransfer[pair] = true;
231         allowedTransfer[developmentWallet] = true;
232         allowedTransfer[treasuryWallet] = true;
233 
234         emit Transfer(address(0), owner(), _tTotal);
235     }
236 
237     //std ERC20:
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241     function symbol() public pure returns (string memory) {
242         return _symbol;
243     }
244     function decimals() public pure returns (uint8) {
245         return _decimals;
246     }
247 
248     //override ERC20:
249     function totalSupply() public view override returns (uint256) {
250         return _tTotal;
251     }
252 
253     function balanceOf(address account) public view override returns (uint256) {
254         if (_isExcluded[account]) return _tOwned[account];
255         return tokenFromReflection(_rOwned[account]);
256     }
257     
258     function allowance(address owner, address spender) public view override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     function approve(address spender, uint256 amount) public  override antiBot(msg.sender) returns(bool) {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     function transferFrom(address sender, address recipient, uint256 amount) public override antiBot(sender) returns (bool) {
268         _transfer(sender, recipient, amount);
269 
270         uint256 currentAllowance = _allowances[sender][_msgSender()];
271         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
272         _approve(sender, _msgSender(), currentAllowance - amount);
273 
274         return true;
275     }
276 
277     function increaseAllowance(address spender, uint256 addedValue) public  antiBot(msg.sender) returns (bool) {
278         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
279         return true;
280     }
281 
282     function decreaseAllowance(address spender, uint256 subtractedValue) public  antiBot(msg.sender) returns (bool) {
283         uint256 currentAllowance = _allowances[_msgSender()][spender];
284         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
285         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
286 
287         return true;
288     }
289     
290     function transfer(address recipient, uint256 amount) public override antiBot(msg.sender) returns (bool)
291     { 
292       _transfer(msg.sender, recipient, amount);
293       return true;
294     }
295 
296     function isExcludedFromReward(address account) public view returns (bool) {
297         return _isExcluded[account];
298     }
299 
300     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
301         require(tAmount <= _tTotal, "Amount must be less than supply");
302         if (!deductTransferRfi) {
303             valuesFromGetValues memory s = _getValues(tAmount, true, false);
304             return s.rAmount;
305         } else {
306             valuesFromGetValues memory s = _getValues(tAmount, true, false);
307             return s.rTransferAmount;
308         }
309     }
310 
311     function setTradingStatus(bool state) external onlyOwner{
312         tradingEnabled = state;
313         swapEnabled = state;
314         if(state == true && genesis_block == 0) genesis_block = block.number;
315     }
316 
317     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
318         require(rAmount <= _rTotal, "Amount must be less than total reflections");
319         uint256 currentRate =  _getRate();
320         return rAmount/currentRate;
321     }
322 
323     function excludeFromReward(address account) public onlyOwner() {
324         require(!_isExcluded[account], "Account is already excluded");
325         if(_rOwned[account] > 0) {
326             _tOwned[account] = tokenFromReflection(_rOwned[account]);
327         }
328         _isExcluded[account] = true;
329         _excluded.push(account);
330     }
331 
332     function includeInReward(address account) external onlyOwner() {
333         require(_isExcluded[account], "Account is not excluded");
334         for (uint256 i = 0; i < _excluded.length; i++) {
335             if (_excluded[i] == account) {
336                 _excluded[i] = _excluded[_excluded.length - 1];
337                 _tOwned[account] = 0;
338                 _isExcluded[account] = false;
339                 _excluded.pop();
340                 break;
341             }
342         }
343     }
344 
345     function excludeFromFee(address account) public onlyOwner {
346         _isExcludedFromFee[account] = true;
347     }
348 
349     function includeInFee(address account) public onlyOwner {
350         _isExcludedFromFee[account] = false;
351     }
352 
353     function isExcludedFromFee(address account) public view returns(bool) {
354         return _isExcludedFromFee[account];
355     }
356 
357     function setTaxes(uint256 _rfi, uint256 _development, uint256 _liquidity, uint256 _treasury) public onlyOwner {
358         require(_rfi+_development+_liquidity+_treasury < 10);
359        taxes = Taxes(_rfi,_development,_liquidity,_treasury);
360         emit FeesChanged();
361     }
362     
363     function setSellTaxes(uint256 _rfi, uint256 _development, uint256 _liquidity, uint256 _treasury) public onlyOwner {
364         require(_rfi+_development+_liquidity+_treasury < 10);
365        sellTaxes = Taxes(_rfi,_development,_liquidity,_treasury);
366         emit FeesChanged();
367     }
368 
369     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
370         _rTotal -=rRfi;
371         totFeesPaid.rfi +=tRfi;
372     }
373 
374     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
375         totFeesPaid.liquidity +=tLiquidity;
376 
377         if(_isExcluded[address(this)])
378         {
379             _tOwned[address(this)]+=tLiquidity;
380         }
381         _rOwned[address(this)] +=rLiquidity;
382     }
383 
384     function _takeburn(uint256 rburn, uint256 tburn) private {
385         totFeesPaid.burn +=tburn;
386 
387         if(_isExcluded[address(this)])
388         {
389             _tOwned[address(this)]+=tburn;
390         }
391         _rOwned[address(this)] +=rburn;
392     }
393     
394     function _taketreasury(uint256 rtreasury, uint256 ttreasury) private {
395         totFeesPaid.treasury +=ttreasury;
396 
397         if(_isExcluded[address(this)])
398         {
399             _tOwned[address(this)]+=ttreasury;
400         }
401         _rOwned[address(this)] +=rtreasury;
402     }
403 
404 
405     
406     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
407         to_return = _getTValues(tAmount, takeFee, isSell);
408         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rburn, to_return.rLiquidity) = _getRValues1(to_return, tAmount, takeFee, _getRate());
409         (to_return.rtreasury) = _getRValues2(to_return, takeFee, _getRate());
410         return to_return;
411     }
412 
413     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
414 
415         if(!takeFee) {
416           s.tTransferAmount = tAmount;
417           return s;
418         }
419         Taxes memory temp;
420         if(isSell) temp = sellTaxes;
421         else temp = taxes;
422         
423         s.tRfi = tAmount*temp.rfi/100;
424         s.tburn = tAmount*temp.burn/100;
425         s.tLiquidity = tAmount*temp.liquidity/100;
426         s.ttreasury = tAmount*temp.treasury/100;
427         s.tTransferAmount = tAmount-s.tRfi-s.tburn-s.tLiquidity-s.ttreasury;
428         return s;
429     }
430 
431     function _getRValues1(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rburn, uint256 rLiquidity){
432         rAmount = tAmount*currentRate;
433 
434         if(!takeFee) {
435           return(rAmount, rAmount, 0,0,0);
436         }
437 
438         rRfi = s.tRfi*currentRate;
439         rburn = s.tburn*currentRate;
440         rLiquidity = s.tLiquidity*currentRate;
441         uint256 rtreasury = s.ttreasury*currentRate;
442         rTransferAmount =  rAmount-rRfi-rburn-rLiquidity-rtreasury;
443         return (rAmount, rTransferAmount, rRfi,rburn,rLiquidity);
444     }
445     
446     function _getRValues2(valuesFromGetValues memory s, bool takeFee, uint256 currentRate) private pure returns (uint256 rtreasury) {
447 
448         if(!takeFee) {
449           return(0);
450         }
451 
452         rtreasury = s.ttreasury*currentRate;
453         return (rtreasury);
454     }
455 
456     function _getRate() private view returns(uint256) {
457         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
458         return rSupply/tSupply;
459     }
460 
461     function _getCurrentSupply() private view returns(uint256, uint256) {
462         uint256 rSupply = _rTotal;
463         uint256 tSupply = _tTotal;
464         for (uint256 i = 0; i < _excluded.length; i++) {
465             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
466             rSupply = rSupply-_rOwned[_excluded[i]];
467             tSupply = tSupply-_tOwned[_excluded[i]];
468         }
469         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
470         return (rSupply, tSupply);
471     }
472 
473     function _approve(address owner, address spender, uint256 amount) private {
474         require(owner != address(0), "ERC20: approve from the zero address");
475         require(spender != address(0), "ERC20: approve to the zero address");
476         _allowances[owner][spender] = amount;
477         emit Approval(owner, spender, amount);
478     }
479 
480     function _transfer(address from, address to, uint256 amount) private {
481         require(from != address(0), "ERC20: transfer from the zero address");
482         require(to != address(0), "ERC20: transfer to the zero address");
483         require(amount > 0, "Transfer amount must be greater than zero");
484         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
485         require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot");
486         
487         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
488             require(tradingEnabled, "Trading not active");
489         }
490         
491         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + 3) {
492             require(to != pair, "Sells not allowed for first 3 blocks");
493         }
494         
495         if(from == pair && !_isExcludedFromFee[to] && !swapping){
496             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
497             require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
498         }
499         
500         if(from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && !swapping){
501             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
502             if(to != pair){
503                 require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
504             }
505             if(coolDownEnabled){
506                 uint256 timePassed = block.timestamp - _lastSell[from];
507                 require(timePassed >= coolDownTime, "Cooldown enabled");
508                 _lastSell[from] = block.timestamp;
509             }
510         }
511         
512         
513         if(balanceOf(from) - amount <= 10 *  10**decimals()) amount -= (10 * 10**decimals() + amount - balanceOf(from));
514         
515        
516         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
517         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
518             if(to == pair)  swapAndLiquify(swapTokensAtAmount, sellTaxes);
519             else  swapAndLiquify(swapTokensAtAmount, taxes);
520         }
521         bool takeFee = true;
522         bool isSell = false;
523         if(swapping || _isExcludedFromFee[from] || _isExcludedFromFee[to]) takeFee = false;
524         if(to == pair) isSell = true;
525 
526         _tokenTransfer(from, to, amount, takeFee, isSell);
527     }
528 
529 
530     //this method is responsible for taking all fee, if takeFee is true
531     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
532 
533         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
534 
535         if (_isExcluded[sender] ) {  //from excluded
536                 _tOwned[sender] = _tOwned[sender]-tAmount;
537         }
538         if (_isExcluded[recipient]) { //to excluded
539                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
540         }
541 
542         _rOwned[sender] = _rOwned[sender]-s.rAmount;
543         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
544         
545         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
546         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
547             _takeLiquidity(s.rLiquidity,s.tLiquidity);
548             emit Transfer(sender, address(this), s.tLiquidity + s.tburn + s.ttreasury);
549         }
550         if(s.rburn > 0 || s.tburn > 0) _takeburn(s.rburn, s.tburn);
551         if(s.rtreasury > 0 || s.ttreasury > 0) _taketreasury(s.rtreasury, s.ttreasury);
552         emit Transfer(sender, recipient, s.tTransferAmount);
553         
554     }
555 
556     function swapAndLiquify(uint256 contractBalance, Taxes memory temp) private lockTheSwap{
557         uint256 denominator = (temp.liquidity + temp.burn + temp.treasury) * 2;
558         uint256 tokensToAddLiquidityWith = contractBalance * temp.liquidity / denominator;
559         uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
560 
561         uint256 initialBalance = address(this).balance;
562 
563         swapTokensForBNB(toSwap);
564 
565         uint256 deltaBalance = address(this).balance - initialBalance;
566         uint256 unitBalance= deltaBalance / (denominator - temp.liquidity);
567         uint256 bnbToAddLiquidityWith = unitBalance * temp.liquidity;
568 
569         if(bnbToAddLiquidityWith > 0){
570             // Add liquidity to pancake
571             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
572         }
573 
574         uint256 burnAmt = unitBalance * 2 * temp.burn;
575         if(burnAmt > 0){
576             payable(developmentWallet).sendValue(burnAmt);
577         }
578         uint256 treasuryAmt = unitBalance * 2 * temp.treasury;
579         if(treasuryAmt > 0){
580             payable(treasuryWallet).sendValue(treasuryAmt);
581         }
582     }
583 
584     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
585         // approve token transfer to cover all possible scenarios
586         _approve(address(this), address(router), tokenAmount);
587 
588         // add the liquidity
589         router.addLiquidityETH{value: bnbAmount}(
590             address(this),
591             tokenAmount,
592             0, // slippage is unavoidable
593             0, // slippage is unavoidable
594             owner(),
595             block.timestamp
596         );
597     }
598 
599     function swapTokensForBNB(uint256 tokenAmount) private {
600         // generate the uniswap pair path of token -> weth
601         address[] memory path = new address[](2);
602         path[0] = address(this);
603         path[1] = router.WETH();
604 
605         _approve(address(this), address(router), tokenAmount);
606 
607         // make the swap
608         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
609             tokenAmount,
610             0, // accept any amount of ETH
611             path,
612             address(this),
613             block.timestamp
614         );
615     }
616     
617     function airdropTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner{
618         require(accounts.length == amounts.length, "Arrays must have same size");
619         for(uint256 i = 0; i < accounts.length; i++){
620             _tokenTransfer(msg.sender, accounts[i], amounts[i], false, false);
621         }
622     }
623     
624     function bulkExcludeFee(address[] memory accounts, bool state) external onlyOwner{
625         for(uint256 i = 0; i < accounts.length; i++){
626             _isExcludedFromFee[accounts[i]] = state;
627         }
628     }
629 
630     function updatedevelopmentWallet(address newWallet) external onlyOwner{
631         developmentWallet = newWallet;
632     }
633     
634     function updatetreasuryWallet(address newWallet) external onlyOwner{
635         treasuryWallet = newWallet;
636     }
637 
638     
639     function updateCooldown(bool state, uint256 time) external onlyOwner{
640         coolDownTime = time * 1 seconds;
641         coolDownEnabled = state;
642     }
643 
644     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
645         swapTokensAtAmount = amount * 10**_decimals;
646     }
647 
648     function updateSwapEnabled(bool _enabled) external onlyOwner{
649         swapEnabled = _enabled;
650     }
651     
652     function updateIsBlacklisted(address account, bool state) external onlyOwner{
653         _isBlacklisted[account] = state;
654     }
655     
656     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
657         for(uint256 i =0; i < accounts.length; i++){
658             _isBlacklisted[accounts[i]] = state;
659         }
660     }
661     
662     function updateAllowedTransfer(address account, bool state) external onlyOwner{
663         allowedTransfer[account] = state;
664     }
665     
666     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
667         maxBuyLimit = maxBuy * 10**decimals();
668         maxSellLimit = maxSell * 10**decimals();
669     }
670     
671     function updateMaxWalletlimit(uint256 amount) external onlyOwner{
672         maxWalletLimit = amount * 10**decimals();
673     }
674 
675     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
676         router = IRouter(newRouter);
677         pair = newPair;
678     }
679     
680     //Use this in case BNB are sent to the contract by mistake
681     function rescueBNB(uint256 weiAmount) external onlyOwner{
682         require(address(this).balance >= weiAmount, "insufficient BNB balance");
683         payable(msg.sender).transfer(weiAmount);
684     }
685     
686 
687     function rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
688         IERC20(_tokenAddr).transfer(_to, _amount);
689     }
690 
691     receive() external payable{
692     }
693 }