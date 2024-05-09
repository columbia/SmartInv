1 /**
2   Telegram: https://t.me/Gamecrypt
3 */
4 
5 // SPDX-License-Identifier: NOLICENSE
6 
7 pragma solidity ^0.8.7;
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address account) external view returns (uint256);
13 
14     function transfer(address recipient, uint256 amount) external returns (bool);
15 
16     function allowance(address owner, address spender) external view returns (uint256);
17 
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     function transferFrom(
21         address sender,
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
38         return msg.data;
39     }
40 }
41 
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     constructor() {
48         _setOwner(_msgSender());
49     }
50 
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     modifier onlyOwner() {
56         require(owner() == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     function renounceOwnership() public virtual onlyOwner {
61         _setOwner(address(0));
62     }
63 
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         _setOwner(newOwner);
67     }
68 
69     function _setOwner(address newOwner) private {
70         address oldOwner = _owner;
71         _owner = newOwner;
72         emit OwnershipTransferred(oldOwner, newOwner);
73     }
74 }
75 
76 interface IFactory{
77         function createPair(address tokenA, address tokenB) external returns (address pair);
78 }
79 
80 interface IRouter {
81     function factory() external pure returns (address);
82     function WETH() external pure returns (address);
83     function addLiquidityETH(
84         address token,
85         uint amountTokenDesired,
86         uint amountTokenMin,
87         uint amountETHMin,
88         address to,
89         uint deadline
90     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
91 
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline) external;
98 }
99 
100 library Address{
101     function sendValue(address payable recipient, uint256 amount) internal {
102         require(address(this).balance >= amount, "Address: insufficient balance");
103 
104         (bool success, ) = recipient.call{value: amount}("");
105         require(success, "Address: unable to send value, recipient may have reverted");
106     }
107 }
108 
109 
110 contract GAMECRYPT is Context, IERC20, Ownable {
111     using Address for address payable;
112     
113     mapping (address => uint256) private _rOwned;
114     mapping (address => uint256) private _tOwned;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private _isExcluded;
118     mapping (address => bool) public allowedTransfer;
119     mapping (address => bool) private _isBlacklisted;
120 
121     address[] private _excluded;
122 
123     bool public tradingEnabled;
124     bool public swapEnabled;
125     bool private swapping;
126     
127     
128     
129     //Anti Dump
130     mapping(address => uint256) private _lastSell;
131     bool public coolDownEnabled = true;
132     uint256 public coolDownTime = 60 seconds;
133     
134     modifier antiBot(address account){
135         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
136         _;
137     }
138 
139     IRouter public router;
140     address public pair;
141 
142     uint8 private constant _decimals = 18;
143     uint256 private constant MAX = ~uint256(0);
144 
145     uint256 private _tTotal = 1e11 * 10**_decimals;
146     uint256 private _rTotal = (MAX - (MAX % _tTotal));
147 
148     uint256 public swapTokensAtAmount = 100_000_000 * 10**18;
149     uint256 public maxBuyLimit = 1_000_000_000 * 10**18;
150     uint256 public maxSellLimit = 500_000_000 * 10**18;
151     uint256 public maxWalletLimit = 2_000_000_000 * 10**18;
152     
153     uint256 public genesis_block;
154     
155     address public marketingWallet = 0x67834E7FD4cf846aA91a7BDacB6fA6FdFeEd617C;
156     address public devWallet = 0x90667312eBae98b1E03b3D17118Df871f5C7d7F6;
157     address public gamedevWallet = 0x4336E56E43a36745b5d344f076e0824cC2847f27;
158 
159 
160     string private constant _name = "Gamecrypt";
161     string private constant _symbol = "GAMECRYPT";
162 
163     struct Taxes {
164         uint256 rfi;
165         uint256 marketing;
166         uint256 liquidity; 
167         uint256 dev;
168         uint256 gamedev;
169     }
170 
171     Taxes public taxes = Taxes(2, 4, 4, 1, 2);
172     Taxes public sellTaxes = Taxes(2, 4, 4, 1, 2);
173 
174     struct TotFeesPaidStruct{
175         uint256 rfi;
176         uint256 marketing;
177         uint256 liquidity; 
178         uint256 dev;
179         uint256 gamedev;
180     }
181     
182     TotFeesPaidStruct public totFeesPaid;
183 
184     struct valuesFromGetValues{
185       uint256 rAmount;
186       uint256 rTransferAmount;
187       uint256 rRfi;
188       uint256 rMarketing;
189       uint256 rLiquidity;
190       uint256 rDev;
191       uint256 rGamedev;
192       uint256 tTransferAmount;
193       uint256 tRfi;
194       uint256 tMarketing;
195       uint256 tLiquidity;
196       uint256 tDev;
197       uint256 tGamedev;
198     }
199 
200     event FeesChanged();
201     event UpdatedRouter(address oldRouter, address newRouter);
202 
203     modifier lockTheSwap {
204         swapping = true;
205         _;
206         swapping = false;
207     }
208 
209     constructor (address routerAddress) {
210         IRouter _router = IRouter(routerAddress);
211         address _pair = IFactory(_router.factory())
212             .createPair(address(this), _router.WETH());
213 
214         router = _router;
215         pair = _pair;
216         
217         excludeFromReward(pair);
218 
219         _rOwned[owner()] = _rTotal;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[owner()] = true;
222         _isExcludedFromFee[marketingWallet] = true;
223         _isExcludedFromFee[devWallet] = true;
224         _isExcludedFromFee[gamedevWallet] = true;
225         
226         allowedTransfer[address(this)] = true;
227         allowedTransfer[owner()] = true;
228         allowedTransfer[pair] = true;
229         allowedTransfer[marketingWallet] = true;
230         allowedTransfer[devWallet] = true;
231         allowedTransfer[gamedevWallet] = true;
232 
233         emit Transfer(address(0), owner(), _tTotal);
234     }
235 
236     //std ERC20:
237     function name() public pure returns (string memory) {
238         return _name;
239     }
240     function symbol() public pure returns (string memory) {
241         return _symbol;
242     }
243     function decimals() public pure returns (uint8) {
244         return _decimals;
245     }
246 
247     //override ERC20:
248     function totalSupply() public view override returns (uint256) {
249         return _tTotal;
250     }
251 
252     function balanceOf(address account) public view override returns (uint256) {
253         if (_isExcluded[account]) return _tOwned[account];
254         return tokenFromReflection(_rOwned[account]);
255     }
256     
257     function allowance(address owner, address spender) public view override returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     function approve(address spender, uint256 amount) public  override antiBot(msg.sender) returns(bool) {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265 
266     function transferFrom(address sender, address recipient, uint256 amount) public override antiBot(sender) returns (bool) {
267         _transfer(sender, recipient, amount);
268 
269         uint256 currentAllowance = _allowances[sender][_msgSender()];
270         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
271         _approve(sender, _msgSender(), currentAllowance - amount);
272 
273         return true;
274     }
275 
276     function increaseAllowance(address spender, uint256 addedValue) public  antiBot(msg.sender) returns (bool) {
277         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
278         return true;
279     }
280 
281     function decreaseAllowance(address spender, uint256 subtractedValue) public  antiBot(msg.sender) returns (bool) {
282         uint256 currentAllowance = _allowances[_msgSender()][spender];
283         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
284         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
285 
286         return true;
287     }
288     
289     function transfer(address recipient, uint256 amount) public override antiBot(msg.sender) returns (bool)
290     { 
291       _transfer(msg.sender, recipient, amount);
292       return true;
293     }
294 
295     function isExcludedFromReward(address account) public view returns (bool) {
296         return _isExcluded[account];
297     }
298 
299     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
300         require(tAmount <= _tTotal, "Amount must be less than supply");
301         if (!deductTransferRfi) {
302             valuesFromGetValues memory s = _getValues(tAmount, true, false);
303             return s.rAmount;
304         } else {
305             valuesFromGetValues memory s = _getValues(tAmount, true, false);
306             return s.rTransferAmount;
307         }
308     }
309 
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
323     //@dev kept original RFI naming -> "reward" as in reflection
324     function excludeFromReward(address account) public onlyOwner() {
325         require(!_isExcluded[account], "Account is already excluded");
326         if(_rOwned[account] > 0) {
327             _tOwned[account] = tokenFromReflection(_rOwned[account]);
328         }
329         _isExcluded[account] = true;
330         _excluded.push(account);
331     }
332 
333     function includeInReward(address account) external onlyOwner() {
334         require(_isExcluded[account], "Account is not excluded");
335         for (uint256 i = 0; i < _excluded.length; i++) {
336             if (_excluded[i] == account) {
337                 _excluded[i] = _excluded[_excluded.length - 1];
338                 _tOwned[account] = 0;
339                 _isExcluded[account] = false;
340                 _excluded.pop();
341                 break;
342             }
343         }
344     }
345 
346 
347     function excludeFromFee(address account) public onlyOwner {
348         _isExcludedFromFee[account] = true;
349     }
350 
351     function includeInFee(address account) public onlyOwner {
352         _isExcludedFromFee[account] = false;
353     }
354 
355 
356     function isExcludedFromFee(address account) public view returns(bool) {
357         return _isExcludedFromFee[account];
358     }
359 
360     function setTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _dev, uint256 _gamedev) public onlyOwner {
361        taxes = Taxes(_rfi,_marketing,_liquidity,_dev,_gamedev);
362         emit FeesChanged();
363     }
364     
365     function setSellTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _dev, uint256 _gamedev) public onlyOwner {
366        sellTaxes = Taxes(_rfi,_marketing,_liquidity,_dev,_gamedev);
367         emit FeesChanged();
368     }
369 
370     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
371         _rTotal -=rRfi;
372         totFeesPaid.rfi +=tRfi;
373     }
374 
375     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
376         totFeesPaid.liquidity +=tLiquidity;
377 
378         if(_isExcluded[address(this)])
379         {
380             _tOwned[address(this)]+=tLiquidity;
381         }
382         _rOwned[address(this)] +=rLiquidity;
383     }
384 
385     function _takeMarketing(uint256 rMarketing, uint256 tMarketing) private {
386         totFeesPaid.marketing +=tMarketing;
387 
388         if(_isExcluded[address(this)])
389         {
390             _tOwned[address(this)]+=tMarketing;
391         }
392         _rOwned[address(this)] +=rMarketing;
393     }
394     
395     function _takeDev(uint256 rDev, uint256 tDev) private {
396         totFeesPaid.dev +=tDev;
397 
398         if(_isExcluded[address(this)])
399         {
400             _tOwned[address(this)]+=tDev;
401         }
402         _rOwned[address(this)] +=rDev;
403     }
404 
405     function _takeGamedev(uint256 rGamedev, uint256 tGamedev) private {
406         totFeesPaid.gamedev +=tGamedev;
407 
408         if(_isExcluded[address(this)])
409         {
410             _tOwned[address(this)]+=tGamedev;
411         }
412         _rOwned[address(this)] +=rGamedev;
413     }
414     
415     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
416         to_return = _getTValues(tAmount, takeFee, isSell);
417         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rMarketing, to_return.rLiquidity) = _getRValues1(to_return, tAmount, takeFee, _getRate());
418         (to_return.rDev,to_return.rGamedev) = _getRValues2(to_return, takeFee, _getRate());
419         return to_return;
420     }
421 
422     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
423 
424         if(!takeFee) {
425           s.tTransferAmount = tAmount;
426           return s;
427         }
428         Taxes memory temp;
429         if(isSell) temp = sellTaxes;
430         else temp = taxes;
431         
432         s.tRfi = tAmount*temp.rfi/100;
433         s.tMarketing = tAmount*temp.marketing/100;
434         s.tLiquidity = tAmount*temp.liquidity/100;
435         s.tDev = tAmount*temp.dev/100;
436         s.tGamedev = tAmount*temp.gamedev/100;
437         s.tTransferAmount = tAmount-s.tRfi-s.tMarketing-s.tLiquidity-s.tDev-s.tGamedev;
438         return s;
439     }
440 
441     function _getRValues1(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rMarketing, uint256 rLiquidity){
442         rAmount = tAmount*currentRate;
443 
444         if(!takeFee) {
445           return(rAmount, rAmount, 0,0,0);
446         }
447 
448         rRfi = s.tRfi*currentRate;
449         rMarketing = s.tMarketing*currentRate;
450         rLiquidity = s.tLiquidity*currentRate;
451         uint256 rDev = s.tDev*currentRate;
452         uint256 rGamedev = s.tGamedev*currentRate;
453         rTransferAmount =  rAmount-rRfi-rMarketing-rLiquidity-rDev-rGamedev;
454         return (rAmount, rTransferAmount, rRfi,rMarketing,rLiquidity);
455     }
456     
457     function _getRValues2(valuesFromGetValues memory s, bool takeFee, uint256 currentRate) private pure returns (uint256 rDev, uint256 rGamedev) {
458 
459         if(!takeFee) {
460           return(0,0);
461         }
462 
463         rDev = s.tDev*currentRate;
464         rGamedev = s.tGamedev*currentRate;
465         return (rDev,rGamedev);
466     }
467 
468     function _getRate() private view returns(uint256) {
469         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
470         return rSupply/tSupply;
471     }
472 
473     function _getCurrentSupply() private view returns(uint256, uint256) {
474         uint256 rSupply = _rTotal;
475         uint256 tSupply = _tTotal;
476         for (uint256 i = 0; i < _excluded.length; i++) {
477             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
478             rSupply = rSupply-_rOwned[_excluded[i]];
479             tSupply = tSupply-_tOwned[_excluded[i]];
480         }
481         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
482         return (rSupply, tSupply);
483     }
484 
485     function _approve(address owner, address spender, uint256 amount) private {
486         require(owner != address(0), "ERC20: approve from the zero address");
487         require(spender != address(0), "ERC20: approve to the zero address");
488         _allowances[owner][spender] = amount;
489         emit Approval(owner, spender, amount);
490     }
491 
492     function _transfer(address from, address to, uint256 amount) private {
493         require(from != address(0), "ERC20: transfer from the zero address");
494         require(to != address(0), "ERC20: transfer to the zero address");
495         require(amount > 0, "Transfer amount must be greater than zero");
496         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
497         require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot");
498         
499         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
500             require(tradingEnabled, "Trading not active");
501         }
502         
503         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + 3) {
504             require(to != pair, "Sells not allowed for first 3 blocks");
505         }
506         
507         if(from == pair && !_isExcludedFromFee[to] && !swapping){
508             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
509             require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
510         }
511         
512         if(from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && !swapping){
513             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
514             if(to != pair){
515                 require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
516             }
517             if(coolDownEnabled){
518                 uint256 timePassed = block.timestamp - _lastSell[from];
519                 require(timePassed >= coolDownTime, "Cooldown enabled");
520                 _lastSell[from] = block.timestamp;
521             }
522         }
523         
524         
525         if(balanceOf(from) - amount <= 10 *  10**decimals()) amount -= (10 * 10**decimals() + amount - balanceOf(from));
526         
527        
528         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
529         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
530             if(to == pair)  swapAndLiquify(swapTokensAtAmount, sellTaxes);
531             else  swapAndLiquify(swapTokensAtAmount, taxes);
532         }
533         bool takeFee = true;
534         bool isSell = false;
535         if(swapping || _isExcludedFromFee[from] || _isExcludedFromFee[to]) takeFee = false;
536         if(to == pair) isSell = true;
537 
538         _tokenTransfer(from, to, amount, takeFee, isSell);
539     }
540 
541 
542     //this method is responsible for taking all fee, if takeFee is true
543     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
544 
545         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
546 
547         if (_isExcluded[sender] ) {  //from excluded
548                 _tOwned[sender] = _tOwned[sender]-tAmount;
549         }
550         if (_isExcluded[recipient]) { //to excluded
551                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
552         }
553 
554         _rOwned[sender] = _rOwned[sender]-s.rAmount;
555         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
556         
557         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
558         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
559             _takeLiquidity(s.rLiquidity,s.tLiquidity);
560             emit Transfer(sender, address(this), s.tLiquidity + s.tMarketing + s.tDev + s.tGamedev);
561         }
562         if(s.rMarketing > 0 || s.tMarketing > 0) _takeMarketing(s.rMarketing, s.tMarketing);
563         if(s.rDev > 0 || s.tDev > 0) _takeDev(s.rDev, s.tDev);
564         if(s.rGamedev > 0 || s.tGamedev > 0) _takeGamedev(s.rGamedev, s.tGamedev);
565         emit Transfer(sender, recipient, s.tTransferAmount);
566         
567     }
568 
569     function swapAndLiquify(uint256 contractBalance, Taxes memory temp) private lockTheSwap{
570         uint256 denominator = (temp.liquidity + temp.marketing + temp.dev + temp.gamedev) * 2;
571         uint256 tokensToAddLiquidityWith = contractBalance * temp.liquidity / denominator;
572         uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
573 
574         uint256 initialBalance = address(this).balance;
575 
576         swapTokensForBNB(toSwap);
577 
578         uint256 deltaBalance = address(this).balance - initialBalance;
579         uint256 unitBalance= deltaBalance / (denominator - temp.liquidity);
580         uint256 bnbToAddLiquidityWith = unitBalance * temp.liquidity;
581 
582         if(bnbToAddLiquidityWith > 0){
583             // Add liquidity to pancake
584             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
585         }
586 
587         uint256 marketingAmt = unitBalance * 2 * temp.marketing;
588         if(marketingAmt > 0){
589             payable(marketingWallet).sendValue(marketingAmt);
590         }
591         uint256 devAmt = unitBalance * 2 * temp.dev;
592         if(devAmt > 0){
593             payable(devWallet).sendValue(devAmt);
594         }
595          uint256 gamedevAmt = unitBalance * 2 * temp.gamedev;
596         if(gamedevAmt > 0){
597             payable(gamedevWallet).sendValue(gamedevAmt);
598         }
599     }
600 
601     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
602         // approve token transfer to cover all possible scenarios
603         _approve(address(this), address(router), tokenAmount);
604 
605         // add the liquidity
606         router.addLiquidityETH{value: bnbAmount}(
607             address(this),
608             tokenAmount,
609             0, // slippage is unavoidable
610             0, // slippage is unavoidable
611             owner(),
612             block.timestamp
613         );
614     }
615 
616     function swapTokensForBNB(uint256 tokenAmount) private {
617         // generate the uniswap pair path of token -> weth
618         address[] memory path = new address[](2);
619         path[0] = address(this);
620         path[1] = router.WETH();
621 
622         _approve(address(this), address(router), tokenAmount);
623 
624         // make the swap
625         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
626             tokenAmount,
627             0, // accept any amount of ETH
628             path,
629             address(this),
630             block.timestamp
631         );
632     }
633     
634     function bulkExcludeFee(address[] memory accounts, bool state) external onlyOwner{
635         for(uint256 i = 0; i < accounts.length; i++){
636             _isExcludedFromFee[accounts[i]] = state;
637         }
638     }
639 
640     function updateMarketingWallet(address newWallet) external onlyOwner{
641         marketingWallet = newWallet;
642     }
643     
644     function updateDevWallet(address newWallet) external onlyOwner{
645         devWallet = newWallet;
646     }
647 
648     function updateGamedevWallet(address newWallet) external onlyOwner{
649         gamedevWallet = newWallet;
650     }
651 
652     
653     function updateCooldown(bool state, uint256 time) external onlyOwner{
654         coolDownTime = time * 1 seconds;
655         coolDownEnabled = state;
656     }
657 
658     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
659         swapTokensAtAmount = amount * 10**_decimals;
660     }
661 
662     function updateSwapEnabled(bool _enabled) external onlyOwner{
663         swapEnabled = _enabled;
664     }
665     
666     function updateIsBlacklisted(address account, bool state) external onlyOwner{
667         _isBlacklisted[account] = state;
668     }
669     
670     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
671         for(uint256 i =0; i < accounts.length; i++){
672             _isBlacklisted[accounts[i]] = state;
673 
674         }
675     }
676     
677     function updateAllowedTransfer(address account, bool state) external onlyOwner{
678         allowedTransfer[account] = state;
679     }
680     
681     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
682         maxBuyLimit = maxBuy * 10**decimals();
683         maxSellLimit = maxSell * 10**decimals();
684     }
685     
686     function updateMaxWalletlimit(uint256 amount) external onlyOwner{
687         maxWalletLimit = amount * 10**decimals();
688     }
689 
690     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
691         router = IRouter(newRouter);
692         pair = newPair;
693     }
694     
695     //Use this in case BNB are sent to the contract by mistake
696     function rescueBNB(uint256 weiAmount) external onlyOwner{
697         require(address(this).balance >= weiAmount, "insufficient BNB balance");
698         payable(msg.sender).transfer(weiAmount);
699     }
700     
701 
702     function rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
703         IERC20(_tokenAddr).transfer(_to, _amount);
704     }
705 
706     receive() external payable{
707     }
708 }