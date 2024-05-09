1 // SPDX-License-Identifier: NOLICENSE
2 
3 pragma solidity ^0.8.7;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(address recipient, uint256 amount) external returns (bool);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function approve(address spender, uint256 amount) external returns (bool);
15 
16     function transferFrom(
17         address sender,
18         address recipient,
19         uint256 amount
20     ) external returns (bool);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor() {
44         _setOwner(_msgSender());
45     }
46 
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         _setOwner(address(0));
58     }
59 
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _setOwner(newOwner);
63     }
64 
65     function _setOwner(address newOwner) private {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 interface IFactory{
73         function createPair(address tokenA, address tokenB) external returns (address pair);
74 }
75 
76 interface IRouter {
77     function factory() external pure returns (address);
78     function WETH() external pure returns (address);
79     function addLiquidityETH(
80         address token,
81         uint amountTokenDesired,
82         uint amountTokenMin,
83         uint amountETHMin,
84         address to,
85         uint deadline
86     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
87 
88     function swapExactTokensForETHSupportingFeeOnTransferTokens(
89         uint amountIn,
90         uint amountOutMin,
91         address[] calldata path,
92         address to,
93         uint deadline) external;
94 }
95 
96 library Address{
97     function sendValue(address payable recipient, uint256 amount) internal {
98         require(address(this).balance >= amount, "Address: insufficient balance");
99 
100         (bool success, ) = recipient.call{value: amount}("");
101         require(success, "Address: unable to send value, recipient may have reverted");
102     }
103 }
104 
105 
106  contract LiverKingCoin is Context, IERC20, Ownable {
107     using Address for address payable;
108     
109     mapping (address => uint256) private _rOwned;
110     mapping (address => uint256) private _tOwned;
111     mapping (address => mapping (address => uint256)) private _allowances;
112     mapping (address => bool) private _isExcludedFromFee;
113     mapping (address => bool) private _isExcluded;
114     mapping (address => bool) public allowedTransfer;
115     mapping (address => bool) private _isBlacklisted;
116 
117     address[] private _excluded;
118 
119     bool public tradingEnabled;
120     bool public swapEnabled;
121     bool private swapping;
122     
123     
124     
125     //Anti Dump
126     mapping(address => uint256) private _lastSell;
127     bool public coolDownEnabled = false;
128     uint256 public coolDownTime = 0 seconds;
129     
130     modifier antiBot(address account){
131         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
132         _;
133     }
134 
135     IRouter public router;
136     address public pair;
137 
138     uint8 private constant _decimals = 6;
139     uint256 private constant MAX = ~uint256(0);
140 
141     uint256 private _tTotal = 9e6 * 10**_decimals;    
142     uint256 private _rTotal = (MAX - (MAX % _tTotal));
143 
144     uint256 public swapTokensAtAmount = 45_000 * 10**6; // 
145     uint256 public maxBuyLimit = 90_000 * 10**6; // 
146     uint256 public maxSellLimit = 90_000 * 10**6; // 
147     uint256 public maxWalletLimit = 180_000 * 10**6; // 
148     
149     uint256 public genesis_block;
150     
151     address public marketingWallet = 0xA88FE7f9dD4C7afE643d4Fce586C567dc1fa7858;
152     address public developmentWallet = 0xE38EA4c3ca36444F926b5A81F71a1CdFC29762cd;
153 
154     string private constant _name = "Liver King Coin";
155     string private constant _symbol = "$PRIMALS";
156 
157     struct Taxes {
158         uint256 rfi;
159         uint256 development;    
160         uint256 liquidity; 
161         uint256 marketing;
162     }
163 
164     Taxes public taxes = Taxes(0, 1, 2, 2);
165     Taxes public sellTaxes = Taxes(0, 1, 2, 2);
166 
167     struct TotFeesPaidStruct{
168         uint256 rfi;
169         uint256 development;
170         uint256 liquidity; 
171         uint256 marketing;
172     }
173     
174     TotFeesPaidStruct public totFeesPaid;
175 
176     struct valuesFromGetValues{
177       uint256 rAmount;
178       uint256 rTransferAmount;
179       uint256 rRfi;
180       uint256 rdevelopment;
181       uint256 rLiquidity;
182       uint256 rmarketing;
183       uint256 tTransferAmount;
184       uint256 tRfi;
185       uint256 tdevelopment;
186       uint256 tLiquidity;
187       uint256 tmarketing;
188     }
189 
190     event FeesChanged();
191     event UpdatedRouter(address oldRouter, address newRouter);
192 
193     modifier lockTheSwap {
194         swapping = true;
195         _;
196         swapping = false;
197     }
198 
199     constructor (address routerAddress) {
200         IRouter _router = IRouter(routerAddress);
201         address _pair = IFactory(_router.factory())
202             .createPair(address(this), _router.WETH());
203 
204         router = _router;
205         pair = _pair;
206         
207         excludeFromReward(pair);
208 
209         _rOwned[owner()] = _rTotal;
210         _isExcludedFromFee[address(this)] = true;
211         _isExcludedFromFee[owner()] = true;
212         _isExcludedFromFee[marketingWallet] = true;
213         _isExcludedFromFee[developmentWallet] = true;
214         
215         allowedTransfer[address(this)] = true;
216         allowedTransfer[owner()] = true;
217         allowedTransfer[pair] = true;
218         allowedTransfer[marketingWallet] = true;
219         allowedTransfer[developmentWallet] = true;
220 
221         emit Transfer(address(0), owner(), _tTotal);
222     }
223 
224     //std ERC20:
225     function name() public pure returns (string memory) {
226         return _name;
227     }
228     function symbol() public pure returns (string memory) {
229         return _symbol;
230     }
231     function decimals() public pure returns (uint8) {
232         return _decimals;
233     }
234 
235     //override ERC20:
236     function totalSupply() public view override returns (uint256) {
237         return _tTotal;
238     }
239 
240     function balanceOf(address account) public view override returns (uint256) {
241         if (_isExcluded[account]) return _tOwned[account];
242         return tokenFromReflection(_rOwned[account]);
243     }
244     
245     function allowance(address owner, address spender) public view override returns (uint256) {
246         return _allowances[owner][spender];
247     }
248 
249     function approve(address spender, uint256 amount) public  override antiBot(msg.sender) returns(bool) {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     function transferFrom(address sender, address recipient, uint256 amount) public override antiBot(sender) returns (bool) {
255         _transfer(sender, recipient, amount);
256 
257         uint256 currentAllowance = _allowances[sender][_msgSender()];
258         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
259         _approve(sender, _msgSender(), currentAllowance - amount);
260 
261         return true;
262     }
263 
264     function increaseAllowance(address spender, uint256 addedValue) public  antiBot(msg.sender) returns (bool) {
265         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
266         return true;
267     }
268 
269     function decreaseAllowance(address spender, uint256 subtractedValue) public  antiBot(msg.sender) returns (bool) {
270         uint256 currentAllowance = _allowances[_msgSender()][spender];
271         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
272         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
273 
274         return true;
275     }
276     
277     function transfer(address recipient, uint256 amount) public override antiBot(msg.sender) returns (bool)
278     { 
279       _transfer(msg.sender, recipient, amount);
280       return true;
281     }
282 
283     function isExcludedFromReward(address account) public view returns (bool) {
284         return _isExcluded[account];
285     }
286 
287     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
288         require(tAmount <= _tTotal, "Amount must be less than supply");
289         if (!deductTransferRfi) {
290             valuesFromGetValues memory s = _getValues(tAmount, true, false);
291             return s.rAmount;
292         } else {
293             valuesFromGetValues memory s = _getValues(tAmount, true, false);
294             return s.rTransferAmount;
295         }
296     }
297 
298     function setTradingStatus(bool state) external onlyOwner{
299         tradingEnabled = state;
300         swapEnabled = state;
301         if(state == true && genesis_block == 0) genesis_block = block.number;
302     }
303 
304     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
305         require(rAmount <= _rTotal, "Amount must be less than total reflections");
306         uint256 currentRate =  _getRate();
307         return rAmount/currentRate;
308     }
309 
310     function excludeFromReward(address account) public onlyOwner() {
311         require(!_isExcluded[account], "Account is already excluded");
312         if(_rOwned[account] > 0) {
313             _tOwned[account] = tokenFromReflection(_rOwned[account]);
314         }
315         _isExcluded[account] = true;
316         _excluded.push(account);
317     }
318 
319     function includeInReward(address account) external onlyOwner() {
320         require(_isExcluded[account], "Account is not excluded");
321         for (uint256 i = 0; i < _excluded.length; i++) {
322             if (_excluded[i] == account) {
323                 _excluded[i] = _excluded[_excluded.length - 1];
324                 _tOwned[account] = 0;
325                 _isExcluded[account] = false;
326                 _excluded.pop();
327                 break;
328             }
329         }
330     }
331 
332     function excludeFromFee(address account) public onlyOwner {
333         _isExcludedFromFee[account] = true;
334     }
335 
336     function includeInFee(address account) public onlyOwner {
337         _isExcludedFromFee[account] = false;
338     }
339 
340     function isExcludedFromFee(address account) public view returns(bool) {
341         return _isExcludedFromFee[account];
342     }
343 
344     function setTaxes(uint256 _rfi, uint256 _development, uint256 _liquidity, uint256 _marketing) public onlyOwner {
345        taxes = Taxes(_rfi,_development,_liquidity,_marketing);
346         emit FeesChanged();
347     }
348     
349     function setSellTaxes(uint256 _rfi, uint256 _development, uint256 _liquidity, uint256 _marketing) public onlyOwner {
350        sellTaxes = Taxes(_rfi,_development,_liquidity,_marketing);
351         emit FeesChanged();
352     }
353 
354     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
355         _rTotal -=rRfi;
356         totFeesPaid.rfi +=tRfi;
357     }
358 
359     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
360         totFeesPaid.liquidity +=tLiquidity;
361 
362         if(_isExcluded[address(this)])
363         {
364             _tOwned[address(this)]+=tLiquidity;
365         }
366         _rOwned[address(this)] +=rLiquidity;
367     }
368 
369     function _takedevelopment(uint256 rdevelopment, uint256 tdevelopment) private {
370         totFeesPaid.development +=tdevelopment;
371 
372         if(_isExcluded[address(this)])
373         {
374             _tOwned[address(this)]+=tdevelopment;
375         }
376         _rOwned[address(this)] +=rdevelopment;
377     }
378     
379     function _takemarketing(uint256 rmarketing, uint256 tmarketing) private {
380         totFeesPaid.marketing +=tmarketing;
381 
382         if(_isExcluded[address(this)])
383         {
384             _tOwned[address(this)]+=tmarketing;
385         }
386         _rOwned[address(this)] +=rmarketing;
387     }
388 
389 
390     
391     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
392         to_return = _getTValues(tAmount, takeFee, isSell);
393         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rdevelopment, to_return.rLiquidity) = _getRValues1(to_return, tAmount, takeFee, _getRate());
394         (to_return.rmarketing) = _getRValues2(to_return, takeFee, _getRate());
395         return to_return;
396     }
397 
398     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
399 
400         if(!takeFee) {
401           s.tTransferAmount = tAmount;
402           return s;
403         }
404         Taxes memory temp;
405         if(isSell) temp = sellTaxes;
406         else temp = taxes;
407         
408         s.tRfi = tAmount*temp.rfi/100;
409         s.tdevelopment = tAmount*temp.development/100;
410         s.tLiquidity = tAmount*temp.liquidity/100;
411         s.tmarketing = tAmount*temp.marketing/100;
412         s.tTransferAmount = tAmount-s.tRfi-s.tdevelopment-s.tLiquidity-s.tmarketing;
413         return s;
414     }
415 
416     function _getRValues1(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rdevelopment, uint256 rLiquidity){
417         rAmount = tAmount*currentRate;
418 
419         if(!takeFee) {
420           return(rAmount, rAmount, 0,0,0);
421         }
422 
423         rRfi = s.tRfi*currentRate;
424         rdevelopment = s.tdevelopment*currentRate;
425         rLiquidity = s.tLiquidity*currentRate;
426         uint256 rmarketing = s.tmarketing*currentRate;
427         rTransferAmount =  rAmount-rRfi-rdevelopment-rLiquidity-rmarketing;
428         return (rAmount, rTransferAmount, rRfi,rdevelopment,rLiquidity);
429     }
430     
431     function _getRValues2(valuesFromGetValues memory s, bool takeFee, uint256 currentRate) private pure returns (uint256 rmarketing) {
432 
433         if(!takeFee) {
434           return(0);
435         }
436 
437         rmarketing = s.tmarketing*currentRate;
438         return (rmarketing);
439     }
440 
441     function _getRate() private view returns(uint256) {
442         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
443         return rSupply/tSupply;
444     }
445 
446     function _getCurrentSupply() private view returns(uint256, uint256) {
447         uint256 rSupply = _rTotal;
448         uint256 tSupply = _tTotal;
449         for (uint256 i = 0; i < _excluded.length; i++) {
450             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
451             rSupply = rSupply-_rOwned[_excluded[i]];
452             tSupply = tSupply-_tOwned[_excluded[i]];
453         }
454         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
455         return (rSupply, tSupply);
456     }
457 
458     function _approve(address owner, address spender, uint256 amount) private {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
463     }
464 
465     function _transfer(address from, address to, uint256 amount) private {
466         require(from != address(0), "ERC20: transfer from the zero address");
467         require(to != address(0), "ERC20: transfer to the zero address");
468         require(amount > 0, "Transfer amount must be greater than zero");
469         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
470         require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot");
471         
472         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
473             require(tradingEnabled, "Trading not active");
474         }
475         
476         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + 3) {
477             require(to != pair, "Sells not allowed for first 3 blocks");
478         }
479         
480         if(from == pair && !_isExcludedFromFee[to] && !swapping){
481             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
482             require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
483         }
484         
485         if(from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && !swapping){
486             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
487             if(to != pair){
488                 require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
489             }
490             if(coolDownEnabled){
491                 uint256 timePassed = block.timestamp - _lastSell[from];
492                 require(timePassed >= coolDownTime, "Cooldown enabled");
493                 _lastSell[from] = block.timestamp;
494             }
495         }
496         
497         
498         if(balanceOf(from) - amount <= 10 *  10**decimals()) amount -= (10 * 10**decimals() + amount - balanceOf(from));
499         
500        
501         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
502         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
503             if(to == pair)  swapAndLiquify(swapTokensAtAmount, sellTaxes);
504             else  swapAndLiquify(swapTokensAtAmount, taxes);
505         }
506         bool takeFee = true;
507         bool isSell = false;
508         if (to != pair && from != pair) takeFee = false;
509         if(swapping || _isExcludedFromFee[from] || _isExcludedFromFee[to]) takeFee = false;
510         if(to == pair) isSell = true;
511 
512         _tokenTransfer(from, to, amount, takeFee, isSell);
513     }
514 
515 
516     //this method is responsible for taking all fee, if takeFee is true
517     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
518 
519         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
520 
521         if (_isExcluded[sender] ) {  //from excluded
522                 _tOwned[sender] = _tOwned[sender]-tAmount;
523         }
524         if (_isExcluded[recipient]) { //to excluded
525                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
526         }
527 
528         _rOwned[sender] = _rOwned[sender]-s.rAmount;
529         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
530         
531         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
532         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
533             _takeLiquidity(s.rLiquidity,s.tLiquidity);
534             emit Transfer(sender, address(this), s.tLiquidity + s.tdevelopment + s.tmarketing);
535         }
536         if(s.rdevelopment > 0 || s.tdevelopment > 0) _takedevelopment(s.rdevelopment, s.tdevelopment);
537         if(s.rmarketing > 0 || s.tmarketing > 0) _takemarketing(s.rmarketing, s.tmarketing);
538         emit Transfer(sender, recipient, s.tTransferAmount);
539         
540     }
541 
542     function swapAndLiquify(uint256 contractBalance, Taxes memory temp) private lockTheSwap{
543         uint256 denominator = (temp.liquidity + temp.development + temp.marketing) * 2;
544         uint256 tokensToAddLiquidityWith = contractBalance * temp.liquidity / denominator;
545         uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
546 
547         uint256 initialBalance = address(this).balance;
548 
549         swapTokensForBNB(toSwap);
550 
551         uint256 deltaBalance = address(this).balance - initialBalance;
552         uint256 unitBalance= deltaBalance / (denominator - temp.liquidity);
553         uint256 bnbToAddLiquidityWith = unitBalance * temp.liquidity;
554 
555         if(bnbToAddLiquidityWith > 0){
556             // Add liquidity to pancake
557             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
558         }
559 
560         uint256 developmentAmt = unitBalance * 2 * temp.development;
561         if(developmentAmt > 0){
562             payable(marketingWallet).sendValue(developmentAmt);
563         }
564         uint256 marketingAmt = unitBalance * 2 * temp.marketing;
565         if(marketingAmt > 0){
566             payable(developmentWallet).sendValue(marketingAmt);
567         }
568     }
569 
570     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
571         // approve token transfer to cover all possible scenarios
572         _approve(address(this), address(router), tokenAmount);
573 
574         // add the liquidity
575         router.addLiquidityETH{value: bnbAmount}(
576             address(this),
577             tokenAmount,
578             0, // slippage is unavoidable
579             0, // slippage is unavoidable
580             owner(),
581             block.timestamp
582         );
583     }
584 
585     function swapTokensForBNB(uint256 tokenAmount) private {
586         // generate the uniswap pair path of token -> weth
587         address[] memory path = new address[](2);
588         path[0] = address(this);
589         path[1] = router.WETH();
590 
591         _approve(address(this), address(router), tokenAmount);
592 
593         // make the swap
594         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
595             tokenAmount,
596             0, // accept any amount of ETH
597             path,
598             address(this),
599             block.timestamp
600         );
601     }
602     
603     function airdropTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner{
604         require(accounts.length == amounts.length, "Arrays must have same size");
605         for(uint256 i = 0; i < accounts.length; i++){
606             _tokenTransfer(msg.sender, accounts[i], amounts[i], false, false);
607         }
608     }
609     
610     function bulkExcludeFee(address[] memory accounts, bool state) external onlyOwner{
611         for(uint256 i = 0; i < accounts.length; i++){
612             _isExcludedFromFee[accounts[i]] = state;
613         }
614     }
615 
616     function updatemarketingWallet(address newWallet) external onlyOwner{
617         marketingWallet = newWallet;
618     }
619     
620     function updatedevelopmentWallet(address newWallet) external onlyOwner{
621         developmentWallet = newWallet;
622     }
623 
624     
625     function updateCooldown(bool state, uint256 time) external onlyOwner{
626         coolDownTime = time * 1 seconds;
627         coolDownEnabled = state;
628     }
629 
630     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
631         swapTokensAtAmount = amount * 10**_decimals;
632     }
633 
634     function updateSwapEnabled(bool _enabled) external onlyOwner{
635         swapEnabled = _enabled;
636     }
637     
638     function updateIsBlacklisted(address account, bool state) external onlyOwner{
639         _isBlacklisted[account] = state;
640     }
641     
642     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
643         for(uint256 i =0; i < accounts.length; i++){
644             _isBlacklisted[accounts[i]] = state;
645 
646         }
647     }
648     
649     function updateAllowedTransfer(address account, bool state) external onlyOwner{
650         allowedTransfer[account] = state;
651     }
652     
653     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
654         maxBuyLimit = maxBuy * 10**decimals();
655         maxSellLimit = maxSell * 10**decimals();
656     }
657     
658     function updateMaxWalletlimit(uint256 amount) external onlyOwner{
659         maxWalletLimit = amount * 10**decimals();
660     }
661 
662     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
663         router = IRouter(newRouter);
664         pair = newPair;
665     }
666     
667     //Use this in case BNB are sent to the contract by mistake
668     function rescueBNB(uint256 weiAmount) external onlyOwner{
669         require(address(this).balance >= weiAmount, "insufficient BNB balance");
670         payable(msg.sender).transfer(weiAmount);
671     }
672     
673 
674     function rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
675         IERC20(_tokenAddr).transfer(_to, _amount);
676     }
677 
678     receive() external payable{
679     }
680 }