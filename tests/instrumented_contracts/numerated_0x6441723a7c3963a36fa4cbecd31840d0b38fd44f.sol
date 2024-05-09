1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-15
3 */
4 
5 /**
6 Telegram: https://t.me/YOSHIETH
7 Website: https://yoshitoken.xyz/
8 Twitter: https://twitter.com/yoshierc20
9 */
10 
11 // SPDX-License-Identifier: NOLICENSE
12 
13 pragma solidity ^0.8.7;
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     constructor() {
54         _setOwner(_msgSender());
55     }
56 
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     function renounceOwnership() public virtual onlyOwner {
67         _setOwner(address(0));
68     }
69 
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         _setOwner(newOwner);
73     }
74 
75     function _setOwner(address newOwner) private {
76         address oldOwner = _owner;
77         _owner = newOwner;
78         emit OwnershipTransferred(oldOwner, newOwner);
79     }
80 }
81 
82 interface IFactory{
83         function createPair(address tokenA, address tokenB) external returns (address pair);
84 }
85 
86 interface IRouter {
87     function factory() external pure returns (address);
88     function WETH() external pure returns (address);
89     function addLiquidityETH(
90         address token,
91         uint amountTokenDesired,
92         uint amountTokenMin,
93         uint amountETHMin,
94         address to,
95         uint deadline
96     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
97 
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline) external;
104 }
105 
106 library Address{
107     function sendValue(address payable recipient, uint256 amount) internal {
108         require(address(this).balance >= amount, "Address: insufficient balance");
109 
110         (bool success, ) = recipient.call{value: amount}("");
111         require(success, "Address: unable to send value, recipient may have reverted");
112     }
113 }
114 
115 
116 contract YOSHI is Context, IERC20, Ownable {
117     using Address for address payable;
118     
119     mapping (address => uint256) private _rOwned;
120     mapping (address => uint256) private _tOwned;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private _isExcluded;
124     mapping (address => bool) public allowedTransfer;
125     mapping (address => bool) private _isBlacklisted;
126 
127     address[] private _excluded;
128 
129     bool public tradingEnabled;
130     bool public swapEnabled;
131     bool private swapping;
132     
133     
134     
135     //Anti Dump
136     mapping(address => uint256) private _lastSell;
137     bool public coolDownEnabled = false;
138     uint256 public coolDownTime = 0 seconds;
139     
140     modifier antiBot(address account){
141         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
142         _;
143     }
144 
145     IRouter public router;
146     address public pair;
147 
148     uint8 private constant _decimals = 9;
149     uint256 private constant MAX = ~uint256(0);
150 
151     uint256 private _tTotal = 1e8 * 10**_decimals;
152     uint256 private _rTotal = (MAX - (MAX % _tTotal));
153 
154     uint256 public swapTokensAtAmount = 800_000 * 10**9;
155     uint256 public maxBuyLimit = 2_000_000 * 10**9;
156     uint256 public maxSellLimit = 2_000_000 * 10**9;
157     uint256 public maxWalletLimit = 2_000_000 * 10**9;
158     
159     uint256 public genesis_block;
160     
161     address public marketingWallet = 0x609c21AB8812f93B8416f6DCAa62EA68284D8BDC;
162     address public donationWallet = 0x927ECe5eA87f82c98bDaC49D45894C12A6976BD3;
163 
164     string private constant _name = "YOSHI";
165     string private constant _symbol = "YOSHI";
166 
167     struct Taxes {
168         uint256 rfi;
169         uint256 marketing;
170         uint256 liquidity; 
171         uint256 donation;
172     }
173 
174     Taxes public taxes = Taxes(0, 1, 0, 1);
175     Taxes public sellTaxes = Taxes(0, 40, 0, 40);
176 
177     struct TotFeesPaidStruct{
178         uint256 rfi;
179         uint256 marketing;
180         uint256 liquidity; 
181         uint256 donation;
182     }
183     
184     TotFeesPaidStruct public totFeesPaid;
185 
186     struct valuesFromGetValues{
187       uint256 rAmount;
188       uint256 rTransferAmount;
189       uint256 rRfi;
190       uint256 rMarketing;
191       uint256 rLiquidity;
192       uint256 rDonation;
193       uint256 tTransferAmount;
194       uint256 tRfi;
195       uint256 tMarketing;
196       uint256 tLiquidity;
197       uint256 tDonation;
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
223         _isExcludedFromFee[donationWallet] = true;
224         
225         allowedTransfer[address(this)] = true;
226         allowedTransfer[owner()] = true;
227         allowedTransfer[pair] = true;
228         allowedTransfer[marketingWallet] = true;
229         allowedTransfer[donationWallet] = true;
230 
231         emit Transfer(address(0), owner(), _tTotal);
232     }
233 
234     //std ERC20:
235     function name() public pure returns (string memory) {
236         return _name;
237     }
238     function symbol() public pure returns (string memory) {
239         return _symbol;
240     }
241     function decimals() public pure returns (uint8) {
242         return _decimals;
243     }
244 
245     //override ERC20:
246     function totalSupply() public view override returns (uint256) {
247         return _tTotal;
248     }
249 
250     function balanceOf(address account) public view override returns (uint256) {
251         if (_isExcluded[account]) return _tOwned[account];
252         return tokenFromReflection(_rOwned[account]);
253     }
254     
255     function allowance(address owner, address spender) public view override returns (uint256) {
256         return _allowances[owner][spender];
257     }
258 
259     function approve(address spender, uint256 amount) public  override antiBot(msg.sender) returns(bool) {
260         _approve(_msgSender(), spender, amount);
261         return true;
262     }
263 
264     function transferFrom(address sender, address recipient, uint256 amount) public override antiBot(sender) returns (bool) {
265         _transfer(sender, recipient, amount);
266 
267         uint256 currentAllowance = _allowances[sender][_msgSender()];
268         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
269         _approve(sender, _msgSender(), currentAllowance - amount);
270 
271         return true;
272     }
273 
274     function increaseAllowance(address spender, uint256 addedValue) public  antiBot(msg.sender) returns (bool) {
275         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
276         return true;
277     }
278 
279     function decreaseAllowance(address spender, uint256 subtractedValue) public  antiBot(msg.sender) returns (bool) {
280         uint256 currentAllowance = _allowances[_msgSender()][spender];
281         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
282         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
283 
284         return true;
285     }
286     
287     function transfer(address recipient, uint256 amount) public override antiBot(msg.sender) returns (bool)
288     { 
289       _transfer(msg.sender, recipient, amount);
290       return true;
291     }
292 
293     function isExcludedFromReward(address account) public view returns (bool) {
294         return _isExcluded[account];
295     }
296 
297     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
298         require(tAmount <= _tTotal, "Amount must be less than supply");
299         if (!deductTransferRfi) {
300             valuesFromGetValues memory s = _getValues(tAmount, true, false);
301             return s.rAmount;
302         } else {
303             valuesFromGetValues memory s = _getValues(tAmount, true, false);
304             return s.rTransferAmount;
305         }
306     }
307 
308     function setTradingStatus(bool state) external onlyOwner{
309         tradingEnabled = state;
310         swapEnabled = state;
311         if(state == true && genesis_block == 0) genesis_block = block.number;
312     }
313 
314     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
315         require(rAmount <= _rTotal, "Amount must be less than total reflections");
316         uint256 currentRate =  _getRate();
317         return rAmount/currentRate;
318     }
319 
320     function excludeFromReward(address account) public onlyOwner() {
321         require(!_isExcluded[account], "Account is already excluded");
322         if(_rOwned[account] > 0) {
323             _tOwned[account] = tokenFromReflection(_rOwned[account]);
324         }
325         _isExcluded[account] = true;
326         _excluded.push(account);
327     }
328 
329     function includeInReward(address account) external onlyOwner() {
330         require(_isExcluded[account], "Account is not excluded");
331         for (uint256 i = 0; i < _excluded.length; i++) {
332             if (_excluded[i] == account) {
333                 _excluded[i] = _excluded[_excluded.length - 1];
334                 _tOwned[account] = 0;
335                 _isExcluded[account] = false;
336                 _excluded.pop();
337                 break;
338             }
339         }
340     }
341 
342     function excludeFromFee(address account) public onlyOwner {
343         _isExcludedFromFee[account] = true;
344     }
345 
346     function includeInFee(address account) public onlyOwner {
347         _isExcludedFromFee[account] = false;
348     }
349 
350     function isExcludedFromFee(address account) public view returns(bool) {
351         return _isExcludedFromFee[account];
352     }
353 
354     function setTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _donation) public onlyOwner {
355        taxes = Taxes(_rfi,_marketing,_liquidity,_donation);
356         emit FeesChanged();
357     }
358     
359     function setSellTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _donation) public onlyOwner {
360        sellTaxes = Taxes(_rfi,_marketing,_liquidity,_donation);
361         emit FeesChanged();
362     }
363 
364     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
365         _rTotal -=rRfi;
366         totFeesPaid.rfi +=tRfi;
367     }
368 
369     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
370         totFeesPaid.liquidity +=tLiquidity;
371 
372         if(_isExcluded[address(this)])
373         {
374             _tOwned[address(this)]+=tLiquidity;
375         }
376         _rOwned[address(this)] +=rLiquidity;
377     }
378 
379     function _takeMarketing(uint256 rMarketing, uint256 tMarketing) private {
380         totFeesPaid.marketing +=tMarketing;
381 
382         if(_isExcluded[address(this)])
383         {
384             _tOwned[address(this)]+=tMarketing;
385         }
386         _rOwned[address(this)] +=rMarketing;
387     }
388     
389     function _takeDonation(uint256 rDonation, uint256 tDonation) private {
390         totFeesPaid.donation +=tDonation;
391 
392         if(_isExcluded[address(this)])
393         {
394             _tOwned[address(this)]+=tDonation;
395         }
396         _rOwned[address(this)] +=rDonation;
397     }
398 
399 
400     
401     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
402         to_return = _getTValues(tAmount, takeFee, isSell);
403         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rMarketing, to_return.rLiquidity) = _getRValues1(to_return, tAmount, takeFee, _getRate());
404         (to_return.rDonation) = _getRValues2(to_return, takeFee, _getRate());
405         return to_return;
406     }
407 
408     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
409 
410         if(!takeFee) {
411           s.tTransferAmount = tAmount;
412           return s;
413         }
414         Taxes memory temp;
415         if(isSell) temp = sellTaxes;
416         else temp = taxes;
417         
418         s.tRfi = tAmount*temp.rfi/100;
419         s.tMarketing = tAmount*temp.marketing/100;
420         s.tLiquidity = tAmount*temp.liquidity/100;
421         s.tDonation = tAmount*temp.donation/100;
422         s.tTransferAmount = tAmount-s.tRfi-s.tMarketing-s.tLiquidity-s.tDonation;
423         return s;
424     }
425 
426     function _getRValues1(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rMarketing, uint256 rLiquidity){
427         rAmount = tAmount*currentRate;
428 
429         if(!takeFee) {
430           return(rAmount, rAmount, 0,0,0);
431         }
432 
433         rRfi = s.tRfi*currentRate;
434         rMarketing = s.tMarketing*currentRate;
435         rLiquidity = s.tLiquidity*currentRate;
436         uint256 rDonation = s.tDonation*currentRate;
437         rTransferAmount =  rAmount-rRfi-rMarketing-rLiquidity-rDonation;
438         return (rAmount, rTransferAmount, rRfi,rMarketing,rLiquidity);
439     }
440     
441     function _getRValues2(valuesFromGetValues memory s, bool takeFee, uint256 currentRate) private pure returns (uint256 rDonation) {
442 
443         if(!takeFee) {
444           return(0);
445         }
446 
447         rDonation = s.tDonation*currentRate;
448         return (rDonation);
449     }
450 
451     function _getRate() private view returns(uint256) {
452         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
453         return rSupply/tSupply;
454     }
455 
456     function _getCurrentSupply() private view returns(uint256, uint256) {
457         uint256 rSupply = _rTotal;
458         uint256 tSupply = _tTotal;
459         for (uint256 i = 0; i < _excluded.length; i++) {
460             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
461             rSupply = rSupply-_rOwned[_excluded[i]];
462             tSupply = tSupply-_tOwned[_excluded[i]];
463         }
464         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
465         return (rSupply, tSupply);
466     }
467 
468     function _approve(address owner, address spender, uint256 amount) private {
469         require(owner != address(0), "ERC20: approve from the zero address");
470         require(spender != address(0), "ERC20: approve to the zero address");
471         _allowances[owner][spender] = amount;
472         emit Approval(owner, spender, amount);
473     }
474 
475     function _transfer(address from, address to, uint256 amount) private {
476         require(from != address(0), "ERC20: transfer from the zero address");
477         require(to != address(0), "ERC20: transfer to the zero address");
478         require(amount > 0, "Transfer amount must be greater than zero");
479         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
480         require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot");
481         
482         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
483             require(tradingEnabled, "Trading not active");
484         }
485         
486         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + 3) {
487             require(to != pair, "Sells not allowed for first 3 blocks");
488         }
489         
490         if(from == pair && !_isExcludedFromFee[to] && !swapping){
491             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
492             require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
493         }
494         
495         if(from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && !swapping){
496             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
497             if(to != pair){
498                 require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
499             }
500             if(coolDownEnabled){
501                 uint256 timePassed = block.timestamp - _lastSell[from];
502                 require(timePassed >= coolDownTime, "Cooldown enabled");
503                 _lastSell[from] = block.timestamp;
504             }
505         }
506         
507         
508         if(balanceOf(from) - amount <= 10 *  10**decimals()) amount -= (10 * 10**decimals() + amount - balanceOf(from));
509         
510        
511         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
512         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
513             if(to == pair)  swapAndLiquify(swapTokensAtAmount, sellTaxes);
514             else  swapAndLiquify(swapTokensAtAmount, taxes);
515         }
516         bool takeFee = true;
517         bool isSell = false;
518         if(swapping || _isExcludedFromFee[from] || _isExcludedFromFee[to]) takeFee = false;
519         if(to == pair) isSell = true;
520 
521         _tokenTransfer(from, to, amount, takeFee, isSell);
522     }
523 
524 
525     //this method is responsible for taking all fee, if takeFee is true
526     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
527 
528         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
529 
530         if (_isExcluded[sender] ) {  //from excluded
531                 _tOwned[sender] = _tOwned[sender]-tAmount;
532         }
533         if (_isExcluded[recipient]) { //to excluded
534                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
535         }
536 
537         _rOwned[sender] = _rOwned[sender]-s.rAmount;
538         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
539         
540         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
541         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
542             _takeLiquidity(s.rLiquidity,s.tLiquidity);
543             emit Transfer(sender, address(this), s.tLiquidity + s.tMarketing + s.tDonation);
544         }
545         if(s.rMarketing > 0 || s.tMarketing > 0) _takeMarketing(s.rMarketing, s.tMarketing);
546         if(s.rDonation > 0 || s.tDonation > 0) _takeDonation(s.rDonation, s.tDonation);
547         emit Transfer(sender, recipient, s.tTransferAmount);
548         
549     }
550 
551     function swapAndLiquify(uint256 contractBalance, Taxes memory temp) private lockTheSwap{
552         uint256 denominator = (temp.liquidity + temp.marketing + temp.donation) * 2;
553         uint256 tokensToAddLiquidityWith = contractBalance * temp.liquidity / denominator;
554         uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
555 
556         uint256 initialBalance = address(this).balance;
557 
558         swapTokensForBNB(toSwap);
559 
560         uint256 deltaBalance = address(this).balance - initialBalance;
561         uint256 unitBalance= deltaBalance / (denominator - temp.liquidity);
562         uint256 bnbToAddLiquidityWith = unitBalance * temp.liquidity;
563 
564         if(bnbToAddLiquidityWith > 0){
565             // Add liquidity to pancake
566             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
567         }
568 
569         uint256 marketingAmt = unitBalance * 2 * temp.marketing;
570         if(marketingAmt > 0){
571             payable(marketingWallet).sendValue(marketingAmt);
572         }
573         uint256 donationAmt = unitBalance * 2 * temp.donation;
574         if(donationAmt > 0){
575             payable(donationWallet).sendValue(donationAmt);
576         }
577     }
578 
579     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
580         // approve token transfer to cover all possible scenarios
581         _approve(address(this), address(router), tokenAmount);
582 
583         // add the liquidity
584         router.addLiquidityETH{value: bnbAmount}(
585             address(this),
586             tokenAmount,
587             0, // slippage is unavoidable
588             0, // slippage is unavoidable
589             owner(),
590             block.timestamp
591         );
592     }
593 
594     function swapTokensForBNB(uint256 tokenAmount) private {
595         // generate the uniswap pair path of token -> weth
596         address[] memory path = new address[](2);
597         path[0] = address(this);
598         path[1] = router.WETH();
599 
600         _approve(address(this), address(router), tokenAmount);
601 
602         // make the swap
603         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
604             tokenAmount,
605             0, // accept any amount of ETH
606             path,
607             address(this),
608             block.timestamp
609         );
610     }
611     
612     function airdropTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner{
613         require(accounts.length == amounts.length, "Arrays must have same size");
614         for(uint256 i = 0; i < accounts.length; i++){
615             _tokenTransfer(msg.sender, accounts[i], amounts[i], false, false);
616         }
617     }
618     
619     function bulkExcludeFee(address[] memory accounts, bool state) external onlyOwner{
620         for(uint256 i = 0; i < accounts.length; i++){
621             _isExcludedFromFee[accounts[i]] = state;
622         }
623     }
624 
625     function updateMarketingWallet(address newWallet) external onlyOwner{
626         marketingWallet = newWallet;
627     }
628     
629     function updateDonationWallet(address newWallet) external onlyOwner{
630         donationWallet = newWallet;
631     }
632 
633     
634     function updateCooldown(bool state, uint256 time) external onlyOwner{
635         coolDownTime = time * 1 seconds;
636         coolDownEnabled = state;
637     }
638 
639     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
640         swapTokensAtAmount = amount * 10**_decimals;
641     }
642 
643     function updateSwapEnabled(bool _enabled) external onlyOwner{
644         swapEnabled = _enabled;
645     }
646     
647     function updateIsBlacklisted(address account, bool state) external onlyOwner{
648         _isBlacklisted[account] = state;
649     }
650     
651     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
652         for(uint256 i =0; i < accounts.length; i++){
653             _isBlacklisted[accounts[i]] = state;
654 
655         }
656     }
657     
658     function updateAllowedTransfer(address account, bool state) external onlyOwner{
659         allowedTransfer[account] = state;
660     }
661     
662     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
663         maxBuyLimit = maxBuy * 10**decimals();
664         maxSellLimit = maxSell * 10**decimals();
665     }
666     
667     function updateMaxWalletlimit(uint256 amount) external onlyOwner{
668         maxWalletLimit = amount * 10**decimals();
669     }
670 
671     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
672         router = IRouter(newRouter);
673         pair = newPair;
674     }
675     
676     //Use this in case BNB are sent to the contract by mistake
677     function rescueBNB(uint256 weiAmount) external onlyOwner{
678         require(address(this).balance >= weiAmount, "insufficient BNB balance");
679         payable(msg.sender).transfer(weiAmount);
680     }
681     
682 
683     function rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
684         IERC20(_tokenAddr).transfer(_to, _amount);
685     }
686 
687     receive() external payable{
688     }
689 }