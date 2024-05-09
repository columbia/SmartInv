1 /*
2    Original code Curve Network
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.7;
7 
8 interface ERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address account) external view returns (uint256);
12 
13     function transfer(address recipient, uint256 amount) external returns (bool);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address sender,
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37         return msg.data;
38     }
39 }
40 
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     constructor() {
47         _setOwner(_msgSender());
48     }
49 
50     function owner() public view virtual returns (address) {
51         return _owner;
52     }
53 
54     modifier onlyOwner() {
55         require(owner() == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         _setOwner(address(0));
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         _setOwner(newOwner);
66     }
67 
68     function _setOwner(address newOwner) private {
69         address oldOwner = _owner;
70         _owner = newOwner;
71         emit OwnershipTransferred(oldOwner, newOwner);
72     }
73 }
74 
75 interface IFactory{
76         function createPair(address tokenA, address tokenB) external returns (address pair);
77 }
78 
79 interface IRouter {
80     function factory() external pure returns (address);
81     function WETH() external pure returns (address);
82     function addLiquidityETH(
83         address token,
84         uint amountTokenDesired,
85         uint amountTokenMin,
86         uint amountETHMin,
87         address to,
88         uint deadline
89     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
90 
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline) external;
97 }
98 
99 library Address{
100     function sendValue(address payable recipient, uint256 amount) internal {
101         require(address(this).balance >= amount, "Address: insufficient balance");
102 
103         (bool success, ) = recipient.call{value: amount}("");
104         require(success, "Address: unable to send value, recipient may have reverted");
105     }
106 }
107 
108 
109 contract CURVE is ERC20, Context, Ownable {
110     using Address for address payable;
111     
112     mapping (address => uint256) private _rOwned;
113     mapping (address => uint256) private _tOwned;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping (address => bool) private _isExcluded;
117     mapping (address => bool) public allowedTransfer;
118     mapping (address => bool) private _isBlacklisted;
119 
120     address[] private _excluded;
121 
122     bool public tradingEnabled;
123     bool public swapEnabled;
124     bool private swapping;
125     
126     mapping(address => uint256) private _lastSell;
127     
128     uint256 public coolDownTime = 0 seconds;
129     bool public coolDownEnabled = false;
130     
131     modifier antiBot(address account){
132         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
133         _;
134     }
135 
136     IRouter public router;
137     address public pair;
138 
139     uint8 private constant _decimals = 9;
140     uint256 private constant MAX = ~uint256(0);
141 
142     uint256 private _tTotal = 1000000000  * 10 **_decimals;
143     uint256 private _rTotal = (MAX - (MAX % _tTotal));
144     
145     uint256 private genesis_block;
146     
147     string private constant _symbol = "CURVE";
148     string private constant _name = "Curve Network";
149 
150     uint256 public Max_Buy_Limit = 20000000 * 10**9;
151     uint256 public Max_Sell_Limit = 20000000 * 10**9;
152 
153     address private Marketing_Wallet = 0xa32Caa7454496f436cd9168bBF197Bb085eE7545;
154     address private Team_Wallet = 0x72944c157A9F134C3D90500c80E7a1dE61f6f84D;
155 
156     uint256 public Max_Wallet_Holding = 20000000  * 10**9;
157     uint256 private swapTokensAtAmount = 5000000 * 10**9;
158     
159 
160     struct Taxes {
161         uint256 rfi;
162         uint256 marketing;
163         uint256 liquidity; 
164         uint256 team;
165     }
166 
167     Taxes public sellTaxes = Taxes(0, 4, 1, 5);
168     Taxes public taxes = Taxes(0, 4, 1, 5);
169     
170 
171     struct TotFeesPaidStruct{
172         uint256 rfi;
173         uint256 marketing;
174         uint256 liquidity; 
175         uint256 team;
176     }
177     
178     TotFeesPaidStruct public totFeesPaid;
179 
180     struct valuesFromGetValues{
181       uint256 rAmount;
182       uint256 rTransferAmount;
183       uint256 rRfi;
184       uint256 rMarketing;
185       uint256 rLiquidity;
186       uint256 rTeam;
187       uint256 tTransferAmount;
188       uint256 tRfi;
189       uint256 tMarketing;
190       uint256 tLiquidity;
191       uint256 tTeam;
192     }
193 
194     event FeesChanged();
195     event UpdatedRouter(address oldRouter, address newRouter);
196 
197     modifier lockTheSwap {
198         swapping = true;
199         _;
200         swapping = false;
201     }
202 
203     constructor (address routerAddress) {
204         IRouter _router = IRouter(routerAddress);
205         address _pair = IFactory(_router.factory())
206             .createPair(address(this), _router.WETH());
207 
208         router = _router;
209         pair = _pair;
210         
211         excludeFromReward(pair);
212 
213         _rOwned[owner()] = _rTotal;
214         _isExcludedFromFee[address(this)] = true;
215         _isExcludedFromFee[owner()] = true;
216         _isExcludedFromFee[Marketing_Wallet] = true;
217         _isExcludedFromFee[Team_Wallet] = true;
218         
219         allowedTransfer[address(this)] = true;
220         allowedTransfer[owner()] = true;
221         allowedTransfer[pair] = true;
222         allowedTransfer[Marketing_Wallet] = true;
223         allowedTransfer[Team_Wallet] = true;
224 
225         emit Transfer(address(0), owner(), _tTotal);
226     }
227 
228     //std ERC20:
229     function name() public pure returns (string memory) {
230         return _name;
231     }
232     function symbol() public pure returns (string memory) {
233         return _symbol;
234     }
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238 
239     //override ERC20:
240     function totalSupply() public view override returns (uint256) {
241         return _tTotal;
242     }
243 
244     function balanceOf(address account) public view override returns (uint256) {
245         if (_isExcluded[account]) return _tOwned[account];
246         return tokenFromReflection(_rOwned[account]);
247     }
248     
249     function allowance(address owner, address spender) public view override returns (uint256) {
250         return _allowances[owner][spender];
251     }
252 
253     function approve(address spender, uint256 amount) public  override antiBot(msg.sender) returns(bool) {
254         _approve(_msgSender(), spender, amount);
255         return true;
256     }
257 
258     function transferFrom(address sender, address recipient, uint256 amount) public override antiBot(sender) returns (bool) {
259         _transfer(sender, recipient, amount);
260 
261         uint256 currentAllowance = _allowances[sender][_msgSender()];
262         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
263         _approve(sender, _msgSender(), currentAllowance - amount);
264 
265         return true;
266     }
267 
268     function increaseAllowance(address spender, uint256 addedValue) public  antiBot(msg.sender) returns (bool) {
269         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
270         return true;
271     }
272 
273     function decreaseAllowance(address spender, uint256 subtractedValue) public  antiBot(msg.sender) returns (bool) {
274         uint256 currentAllowance = _allowances[_msgSender()][spender];
275         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
276         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
277 
278         return true;
279     }
280     
281     function transfer(address recipient, uint256 amount) public override antiBot(msg.sender) returns (bool)
282     { 
283       _transfer(msg.sender, recipient, amount);
284       return true;
285     }
286 
287     function isExcludedFromReward(address account) public view returns (bool) {
288         return _isExcluded[account];
289     }
290 
291     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
292         require(tAmount <= _tTotal, "Amount must be less than supply");
293         if (!deductTransferRfi) {
294             valuesFromGetValues memory s = _getValues(tAmount, true, false);
295             return s.rAmount;
296         } else {
297             valuesFromGetValues memory s = _getValues(tAmount, true, false);
298             return s.rTransferAmount;
299         }
300     }
301 
302     function setTradingStatus(bool state) external onlyOwner{
303         tradingEnabled = state;
304         swapEnabled = state;
305         if(state == true && genesis_block == 0) genesis_block = block.number;
306     }
307 
308     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
309         require(rAmount <= _rTotal, "Amount must be less than total reflections");
310         uint256 currentRate =  _getRate();
311         return rAmount/currentRate;
312     }
313 
314     function excludeFromReward(address account) public onlyOwner() {
315         require(!_isExcluded[account], "Account is already excluded");
316         if(_rOwned[account] > 0) {
317             _tOwned[account] = tokenFromReflection(_rOwned[account]);
318         }
319         _isExcluded[account] = true;
320         _excluded.push(account);
321     }
322 
323     function includeInReward(address account) external onlyOwner() {
324         require(_isExcluded[account], "Account is not excluded");
325         for (uint256 i = 0; i < _excluded.length; i++) {
326             if (_excluded[i] == account) {
327                 _excluded[i] = _excluded[_excluded.length - 1];
328                 _tOwned[account] = 0;
329                 _isExcluded[account] = false;
330                 _excluded.pop();
331                 break;
332             }
333         }
334     }
335 
336     function excludeFromFee(address account) public onlyOwner {
337         _isExcludedFromFee[account] = true;
338     }
339 
340     function includeInFee(address account) public onlyOwner {
341         _isExcludedFromFee[account] = false;
342     }
343 
344     function isExcludedFromFee(address account) public view returns(bool) {
345         return _isExcludedFromFee[account];
346     }
347 
348     function setTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _team) public onlyOwner {
349        taxes = Taxes(_rfi,_marketing,_liquidity,_team);
350         emit FeesChanged();
351     }
352     
353     function setSellTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _team) public onlyOwner {
354        sellTaxes = Taxes(_rfi,_marketing,_liquidity,_team);
355         emit FeesChanged();
356     }
357 
358     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
359         _rTotal -=rRfi;
360         totFeesPaid.rfi +=tRfi;
361     }
362 
363     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
364         totFeesPaid.liquidity +=tLiquidity;
365 
366         if(_isExcluded[address(this)])
367         {
368             _tOwned[address(this)]+=tLiquidity;
369         }
370         _rOwned[address(this)] +=rLiquidity;
371     }
372 
373     function _takeMarketing(uint256 rMarketing, uint256 tMarketing) private {
374         totFeesPaid.marketing +=tMarketing;
375 
376         if(_isExcluded[address(this)])
377         {
378             _tOwned[address(this)]+=tMarketing;
379         }
380         _rOwned[address(this)] +=rMarketing;
381     }
382     
383     function _takeTeam(uint256 rTeam, uint256 tTeam) private {
384         totFeesPaid.team +=tTeam;
385 
386         if(_isExcluded[address(this)])
387         {
388             _tOwned[address(this)]+=tTeam;
389         }
390         _rOwned[address(this)] +=rTeam;
391     }
392 
393 
394     
395     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
396         to_return = _getTValues(tAmount, takeFee, isSell);
397         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rMarketing, to_return.rLiquidity) = _getRValues1(to_return, tAmount, takeFee, _getRate());
398         (to_return.rTeam) = _getRValues2(to_return, takeFee, _getRate());
399         return to_return;
400     }
401 
402     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
403 
404         if(!takeFee) {
405           s.tTransferAmount = tAmount;
406           return s;
407         }
408         Taxes memory temp;
409         if(isSell) temp = sellTaxes;
410         else temp = taxes;
411         
412         s.tRfi = tAmount*temp.rfi/100;
413         s.tMarketing = tAmount*temp.marketing/100;
414         s.tLiquidity = tAmount*temp.liquidity/100;
415         s.tTeam = tAmount*temp.team/100;
416         s.tTransferAmount = tAmount-s.tRfi-s.tMarketing-s.tLiquidity-s.tTeam;
417         return s;
418     }
419 
420     function _getRValues1(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rMarketing, uint256 rLiquidity){
421         rAmount = tAmount*currentRate;
422 
423         if(!takeFee) {
424           return(rAmount, rAmount, 0,0,0);
425         }
426 
427         rRfi = s.tRfi*currentRate;
428         rMarketing = s.tMarketing*currentRate;
429         rLiquidity = s.tLiquidity*currentRate;
430         uint256 rTeam = s.tTeam*currentRate;
431         rTransferAmount =  rAmount-rRfi-rMarketing-rLiquidity-rTeam;
432         return (rAmount, rTransferAmount, rRfi,rMarketing,rLiquidity);
433     }
434     
435     function _getRValues2(valuesFromGetValues memory s, bool takeFee, uint256 currentRate) private pure returns (uint256 rTeam) {
436 
437         if(!takeFee) {
438           return(0);
439         }
440 
441         rTeam = s.tTeam*currentRate;
442         return (rTeam);
443     }
444 
445     function _getRate() private view returns(uint256) {
446         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
447         return rSupply/tSupply;
448     }
449 
450     function _getCurrentSupply() private view returns(uint256, uint256) {
451         uint256 rSupply = _rTotal;
452         uint256 tSupply = _tTotal;
453         for (uint256 i = 0; i < _excluded.length; i++) {
454             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
455             rSupply = rSupply-_rOwned[_excluded[i]];
456             tSupply = tSupply-_tOwned[_excluded[i]];
457         }
458         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
459         return (rSupply, tSupply);
460     }
461 
462     function _approve(address owner, address spender, uint256 amount) private {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465         _allowances[owner][spender] = amount;
466         emit Approval(owner, spender, amount);
467     }
468 
469     function _transfer(address from, address to, uint256 amount) private {
470         require(from != address(0), "ERC20: transfer from the zero address");
471         require(to != address(0), "ERC20: transfer to the zero address");
472         require(amount > 0, "Transfer amount must be greater than zero");
473         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
474         require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot");
475         
476         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
477             require(tradingEnabled, "Trading not active");
478         }
479         
480         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + 3) {
481             require(to != pair, "Sells not allowed for first 3 blocks");
482         }
483         
484         if(from == pair && !_isExcludedFromFee[to] && !swapping){
485             require(amount <= Max_Buy_Limit, "You are exceeding Max_Buy_Limit");
486             require(balanceOf(to) + amount <= Max_Wallet_Holding, "You are exceeding Max_Wallet_Holding");
487         }
488         
489         if(from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && !swapping){
490             require(amount <= Max_Sell_Limit, "You are exceeding Max_Sell_Limit");
491             if(to != pair){
492                 require(balanceOf(to) + amount <= Max_Wallet_Holding, "You are exceeding Max_Wallet_Holding");
493             }
494             if(coolDownEnabled){
495                 uint256 timePassed = block.timestamp - _lastSell[from];
496                 require(timePassed >= coolDownTime, "Cooldown enabled");
497                 _lastSell[from] = block.timestamp;
498             }
499         }
500         
501         
502         if(balanceOf(from) - amount <= 10 *  10**decimals()) amount -= (10 * 10**decimals() + amount - balanceOf(from));
503         
504        
505         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
506         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
507             if(to == pair)  swapAndLiquify(swapTokensAtAmount, sellTaxes);
508             else  swapAndLiquify(swapTokensAtAmount, taxes);
509         }
510         bool takeFee = true;
511         bool isSell = false;
512         if(swapping || _isExcludedFromFee[from] || _isExcludedFromFee[to]) takeFee = false;
513         if(to == pair) isSell = true;
514 
515         _tokenTransfer(from, to, amount, takeFee, isSell);
516     }
517 
518 
519     //this method is responsible for taking all fee, if takeFee is true
520     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
521 
522         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
523 
524         if (_isExcluded[sender] ) {  //from excluded
525                 _tOwned[sender] = _tOwned[sender]-tAmount;
526         }
527         if (_isExcluded[recipient]) { //to excluded
528                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
529         }
530 
531         _rOwned[sender] = _rOwned[sender]-s.rAmount;
532         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
533         
534         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
535         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
536             _takeLiquidity(s.rLiquidity,s.tLiquidity);
537             emit Transfer(sender, address(this), s.tLiquidity + s.tMarketing + s.tTeam);
538         }
539         if(s.rMarketing > 0 || s.tMarketing > 0) _takeMarketing(s.rMarketing, s.tMarketing);
540         if(s.rTeam > 0 || s.tTeam > 0) _takeTeam(s.rTeam, s.tTeam);
541         emit Transfer(sender, recipient, s.tTransferAmount);
542         
543     }
544 
545     function swapAndLiquify(uint256 contractBalance, Taxes memory temp) private lockTheSwap{
546         uint256 denominator = (temp.liquidity + temp.marketing + temp.team) * 2;
547         uint256 tokensToAddLiquidityWith = contractBalance * temp.liquidity / denominator;
548         uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
549 
550         uint256 initialBalance = address(this).balance;
551 
552         swapTokensForBNB(toSwap);
553 
554         uint256 deltaBalance = address(this).balance - initialBalance;
555         uint256 unitBalance= deltaBalance / (denominator - temp.liquidity);
556         uint256 bnbToAddLiquidityWith = unitBalance * temp.liquidity;
557 
558         if(bnbToAddLiquidityWith > 0){
559             // Add liquidity to pancake
560             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
561         }
562 
563         uint256 marketingAmt = unitBalance * 2 * temp.marketing;
564         if(marketingAmt > 0){
565             payable(Marketing_Wallet).sendValue(marketingAmt);
566         }
567         uint256 teamAmt = unitBalance * 2 * temp.team;
568         if(teamAmt > 0){
569             payable(Team_Wallet).sendValue(teamAmt);
570         }
571     }
572 
573     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
574         // approve token transfer to cover all possible scenarios
575         _approve(address(this), address(router), tokenAmount);
576 
577         // add the liquidity
578         router.addLiquidityETH{value: bnbAmount}(
579             address(this),
580             tokenAmount,
581             0, // slippage is unavoidable
582             0, // slippage is unavoidable
583             owner(),
584             block.timestamp
585         );
586     }
587 
588     function swapTokensForBNB(uint256 tokenAmount) private {
589         // generate the uniswap pair path of token -> weth
590         address[] memory path = new address[](2);
591         path[0] = address(this);
592         path[1] = router.WETH();
593 
594         _approve(address(this), address(router), tokenAmount);
595 
596         // make the swap
597         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
598             tokenAmount,
599             0, // accept any amount of ETH
600             path,
601             address(this),
602             block.timestamp
603         );
604     }
605     
606     function airdropTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner{
607         require(accounts.length == amounts.length, "Arrays must have same size");
608         for(uint256 i = 0; i < accounts.length; i++){
609             _tokenTransfer(msg.sender, accounts[i], amounts[i], false, false);
610         }
611     }
612     
613     function bulkExcludeFee(address[] memory accounts, bool state) external onlyOwner{
614         for(uint256 i = 0; i < accounts.length; i++){
615             _isExcludedFromFee[accounts[i]] = state;
616         }
617     }
618 
619     function Update_MarketingWallet(address newWallet) external onlyOwner{
620         Marketing_Wallet = newWallet;
621     }
622     
623     function Update_TeamWallet(address newWallet) external onlyOwner{
624         Team_Wallet = newWallet;
625     }
626 
627     
628     function updateCooldown(bool state, uint256 time) external onlyOwner{
629         coolDownTime = time * 1 seconds;
630         coolDownEnabled = state;
631     }
632 
633     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
634         swapTokensAtAmount = amount * 10**_decimals;
635     }
636 
637     function updateSwapEnabled(bool _enabled) external onlyOwner{
638         swapEnabled = _enabled;
639     }
640     
641     function updateIsBlacklisted(address account, bool state) external onlyOwner{
642         _isBlacklisted[account] = state;
643     }
644     
645     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
646         for(uint256 i =0; i < accounts.length; i++){
647             _isBlacklisted[accounts[i]] = state;
648 
649         }
650     }
651     
652     function updateAllowedTransfer(address account, bool state) external onlyOwner{
653         allowedTransfer[account] = state;
654     }
655     
656     function Update_Max_Tx_Limit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
657         Max_Buy_Limit = maxBuy * 10**decimals();
658         Max_Sell_Limit = maxSell * 10**decimals();
659     }
660     
661     function Update_Max_Wallet_Holding(uint256 amount) external onlyOwner{
662         Max_Wallet_Holding = amount * 10**decimals();
663     }
664 
665     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
666         router = IRouter(newRouter);
667         pair = newPair;
668     }
669     
670     //Use this in case BNB are sent to the contract by mistake
671     function rescueBNB(uint256 weiAmount) external onlyOwner{
672         require(address(this).balance >= weiAmount, "insufficient BNB balance");
673         payable(msg.sender).transfer(weiAmount);
674     }
675     
676 
677     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
678         ERC20(_tokenAddr).transfer(_to, _amount);
679     }
680 
681     receive() external payable{
682     }
683 }