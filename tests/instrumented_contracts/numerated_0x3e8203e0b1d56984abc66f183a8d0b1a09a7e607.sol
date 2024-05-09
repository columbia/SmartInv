1 /**
2 
3 Telegram: https://t.me/Liquidprotocoleth
4 
5 Website:  https://www.liquidprotocol.io/
6 
7 Twitter: https://x.com/ProtocolLiquid
8 
9 Technical Whitepaper: https://rather.gitbook.io/liquidprotocol
10 
11 */
12 
13 // SPDX-License-Identifier: NOLICENSE
14 
15 pragma solidity ^0.8.7;
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
46         return msg.data;
47     }
48 }
49 
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     constructor() {
56         _setOwner(_msgSender());
57     }
58 
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     function renounceOwnership() public virtual onlyOwner {
69         _setOwner(address(0));
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         _setOwner(newOwner);
75     }
76 
77     function _setOwner(address newOwner) private {
78         address oldOwner = _owner;
79         _owner = newOwner;
80         emit OwnershipTransferred(oldOwner, newOwner);
81     }
82 }
83 
84 interface IFactory{
85         function createPair(address tokenA, address tokenB) external returns (address pair);
86 }
87 
88 interface IRouter {
89     function factory() external pure returns (address);
90     function WETH() external pure returns (address);
91     function addLiquidityETH(
92         address token,
93         uint amountTokenDesired,
94         uint amountTokenMin,
95         uint amountETHMin,
96         address to,
97         uint deadline
98     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
99 
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline) external;
106 }
107 
108 library Address{
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         (bool success, ) = recipient.call{value: amount}("");
113         require(success, "Address: unable to send value, recipient may have reverted");
114     }
115 }
116 
117 
118 contract liquidprotocol is Context, IERC20, Ownable {
119     using Address for address payable;
120     
121     mapping (address => uint256) private _rOwned;
122     mapping (address => uint256) private _tOwned;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private _isExcluded;
126     mapping (address => bool) public allowedTransfer;
127     mapping (address => bool) private _isBlacklisted;
128 
129     address[] private _excluded;
130 
131     bool public tradingEnabled;
132     bool public swapEnabled;
133     bool private swapping;
134     
135     
136     
137     //Anti Dump
138     mapping(address => uint256) private _lastSell;
139     bool public coolDownEnabled = false;
140     uint256 public coolDownTime = 0 seconds;
141     
142     modifier antiBot(address account){
143         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
144         _;
145     }
146 
147     IRouter public router;
148     address public pair;
149 
150     uint8 private constant _decimals = 9;
151     uint256 private constant MAX = ~uint256(0);
152 
153     uint256 private _tTotal = 1e6 * 10**_decimals;
154     uint256 private _rTotal = (MAX - (MAX % _tTotal));
155 
156     uint256 public swapTokensAtAmount = 10_000 * 10**9;
157     uint256 public maxBuyLimit = 20_000 * 10**9;
158     uint256 public maxSellLimit = 20_000 * 10**9;
159     uint256 public maxWalletLimit = 20_000 * 10**9;
160     
161     uint256 public genesis_block;
162     
163     address public marketingWallet = 0x6A3395512d678F87f09b0e2AC3682026bC040463;
164     address public donationWallet = 0xe7c7E2815012a85C937efa8FBDc870d967F205A6;
165 
166     string private constant _name = "Liquid Protocol";
167     string private constant _symbol = "LP";
168 
169     struct Taxes {
170         uint256 rfi;
171         uint256 marketing;
172         uint256 liquidity; 
173         uint256 donation;
174     }
175 
176     Taxes public taxes = Taxes(0, 34, 0, 37);
177     Taxes public sellTaxes = Taxes(0, 34, 0, 37);
178 
179     struct TotFeesPaidStruct{
180         uint256 rfi;
181         uint256 marketing;
182         uint256 liquidity; 
183         uint256 donation;
184     }
185     
186     TotFeesPaidStruct public totFeesPaid;
187 
188     struct valuesFromGetValues{
189       uint256 rAmount;
190       uint256 rTransferAmount;
191       uint256 rRfi;
192       uint256 rMarketing;
193       uint256 rLiquidity;
194       uint256 rDonation;
195       uint256 tTransferAmount;
196       uint256 tRfi;
197       uint256 tMarketing;
198       uint256 tLiquidity;
199       uint256 tDonation;
200     }
201 
202     event FeesChanged();
203     event UpdatedRouter(address oldRouter, address newRouter);
204 
205     modifier lockTheSwap {
206         swapping = true;
207         _;
208         swapping = false;
209     }
210 
211     constructor (address routerAddress) {
212         IRouter _router = IRouter(routerAddress);
213         address _pair = IFactory(_router.factory())
214             .createPair(address(this), _router.WETH());
215 
216         router = _router;
217         pair = _pair;
218         
219         excludeFromReward(pair);
220 
221         _rOwned[owner()] = _rTotal;
222         _isExcludedFromFee[address(this)] = true;
223         _isExcludedFromFee[owner()] = true;
224         _isExcludedFromFee[marketingWallet] = true;
225         _isExcludedFromFee[donationWallet] = true;
226         
227         allowedTransfer[address(this)] = true;
228         allowedTransfer[owner()] = true;
229         allowedTransfer[pair] = true;
230         allowedTransfer[marketingWallet] = true;
231         allowedTransfer[donationWallet] = true;
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
310     function setTradingStatus(bool state) external onlyOwner{
311         tradingEnabled = state;
312         swapEnabled = state;
313         if(state == true && genesis_block == 0) genesis_block = block.number;
314     }
315 
316     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
317         require(rAmount <= _rTotal, "Amount must be less than total reflections");
318         uint256 currentRate =  _getRate();
319         return rAmount/currentRate;
320     }
321 
322     function excludeFromReward(address account) public onlyOwner() {
323         require(!_isExcluded[account], "Account is already excluded");
324         if(_rOwned[account] > 0) {
325             _tOwned[account] = tokenFromReflection(_rOwned[account]);
326         }
327         _isExcluded[account] = true;
328         _excluded.push(account);
329     }
330 
331     function includeInReward(address account) external onlyOwner() {
332         require(_isExcluded[account], "Account is not excluded");
333         for (uint256 i = 0; i < _excluded.length; i++) {
334             if (_excluded[i] == account) {
335                 _excluded[i] = _excluded[_excluded.length - 1];
336                 _tOwned[account] = 0;
337                 _isExcluded[account] = false;
338                 _excluded.pop();
339                 break;
340             }
341         }
342     }
343 
344     function excludeFromFee(address account) public onlyOwner {
345         _isExcludedFromFee[account] = true;
346     }
347 
348     function includeInFee(address account) public onlyOwner {
349         _isExcludedFromFee[account] = false;
350     }
351 
352     function isExcludedFromFee(address account) public view returns(bool) {
353         return _isExcludedFromFee[account];
354     }
355 
356     function setTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _donation) public onlyOwner {
357        taxes = Taxes(_rfi,_marketing,_liquidity,_donation);
358         emit FeesChanged();
359     }
360     
361     function setSellTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _donation) public onlyOwner {
362        sellTaxes = Taxes(_rfi,_marketing,_liquidity,_donation);
363         emit FeesChanged();
364     }
365 
366     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
367         _rTotal -=rRfi;
368         totFeesPaid.rfi +=tRfi;
369     }
370 
371     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
372         totFeesPaid.liquidity +=tLiquidity;
373 
374         if(_isExcluded[address(this)])
375         {
376             _tOwned[address(this)]+=tLiquidity;
377         }
378         _rOwned[address(this)] +=rLiquidity;
379     }
380 
381     function _takeMarketing(uint256 rMarketing, uint256 tMarketing) private {
382         totFeesPaid.marketing +=tMarketing;
383 
384         if(_isExcluded[address(this)])
385         {
386             _tOwned[address(this)]+=tMarketing;
387         }
388         _rOwned[address(this)] +=rMarketing;
389     }
390     
391     function _takeDonation(uint256 rDonation, uint256 tDonation) private {
392         totFeesPaid.donation +=tDonation;
393 
394         if(_isExcluded[address(this)])
395         {
396             _tOwned[address(this)]+=tDonation;
397         }
398         _rOwned[address(this)] +=rDonation;
399     }
400 
401 
402     
403     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
404         to_return = _getTValues(tAmount, takeFee, isSell);
405         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rMarketing, to_return.rLiquidity) = _getRValues1(to_return, tAmount, takeFee, _getRate());
406         (to_return.rDonation) = _getRValues2(to_return, takeFee, _getRate());
407         return to_return;
408     }
409 
410     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
411 
412         if(!takeFee) {
413           s.tTransferAmount = tAmount;
414           return s;
415         }
416         Taxes memory temp;
417         if(isSell) temp = sellTaxes;
418         else temp = taxes;
419         
420         s.tRfi = tAmount*temp.rfi/100;
421         s.tMarketing = tAmount*temp.marketing/100;
422         s.tLiquidity = tAmount*temp.liquidity/100;
423         s.tDonation = tAmount*temp.donation/100;
424         s.tTransferAmount = tAmount-s.tRfi-s.tMarketing-s.tLiquidity-s.tDonation;
425         return s;
426     }
427 
428     function _getRValues1(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rMarketing, uint256 rLiquidity){
429         rAmount = tAmount*currentRate;
430 
431         if(!takeFee) {
432           return(rAmount, rAmount, 0,0,0);
433         }
434 
435         rRfi = s.tRfi*currentRate;
436         rMarketing = s.tMarketing*currentRate;
437         rLiquidity = s.tLiquidity*currentRate;
438         uint256 rDonation = s.tDonation*currentRate;
439         rTransferAmount =  rAmount-rRfi-rMarketing-rLiquidity-rDonation;
440         return (rAmount, rTransferAmount, rRfi,rMarketing,rLiquidity);
441     }
442     
443     function _getRValues2(valuesFromGetValues memory s, bool takeFee, uint256 currentRate) private pure returns (uint256 rDonation) {
444 
445         if(!takeFee) {
446           return(0);
447         }
448 
449         rDonation = s.tDonation*currentRate;
450         return (rDonation);
451     }
452 
453     function _getRate() private view returns(uint256) {
454         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
455         return rSupply/tSupply;
456     }
457 
458     function _getCurrentSupply() private view returns(uint256, uint256) {
459         uint256 rSupply = _rTotal;
460         uint256 tSupply = _tTotal;
461         for (uint256 i = 0; i < _excluded.length; i++) {
462             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
463             rSupply = rSupply-_rOwned[_excluded[i]];
464             tSupply = tSupply-_tOwned[_excluded[i]];
465         }
466         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
467         return (rSupply, tSupply);
468     }
469 
470     function _approve(address owner, address spender, uint256 amount) private {
471         require(owner != address(0), "ERC20: approve from the zero address");
472         require(spender != address(0), "ERC20: approve to the zero address");
473         _allowances[owner][spender] = amount;
474         emit Approval(owner, spender, amount);
475     }
476 
477     function _transfer(address from, address to, uint256 amount) private {
478         require(from != address(0), "ERC20: transfer from the zero address");
479         require(to != address(0), "ERC20: transfer to the zero address");
480         require(amount > 0, "Transfer amount must be greater than zero");
481         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
482         require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot");
483         
484         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
485             require(tradingEnabled, "Trading not active");
486         }
487         
488         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + 3) {
489             require(to != pair, "Sells not allowed for first 3 blocks");
490         }
491         
492         if(from == pair && !_isExcludedFromFee[to] && !swapping){
493             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
494             require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
495         }
496         
497         if(from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && !swapping){
498             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
499             if(to != pair){
500                 require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
501             }
502             if(coolDownEnabled){
503                 uint256 timePassed = block.timestamp - _lastSell[from];
504                 require(timePassed >= coolDownTime, "Cooldown enabled");
505                 _lastSell[from] = block.timestamp;
506             }
507         }
508         
509         
510         if(balanceOf(from) - amount <= 10 *  10**decimals()) amount -= (10 * 10**decimals() + amount - balanceOf(from));
511         
512        
513         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
514         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
515             if(to == pair)  swapAndLiquify(swapTokensAtAmount, sellTaxes);
516             else  swapAndLiquify(swapTokensAtAmount, taxes);
517         }
518         bool takeFee = true;
519         bool isSell = false;
520         if(swapping || _isExcludedFromFee[from] || _isExcludedFromFee[to]) takeFee = false;
521         if(to == pair) isSell = true;
522 
523         _tokenTransfer(from, to, amount, takeFee, isSell);
524     }
525 
526 
527     //this method is responsible for taking all fee, if takeFee is true
528     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
529 
530         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
531 
532         if (_isExcluded[sender] ) {  //from excluded
533                 _tOwned[sender] = _tOwned[sender]-tAmount;
534         }
535         if (_isExcluded[recipient]) { //to excluded
536                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
537         }
538 
539         _rOwned[sender] = _rOwned[sender]-s.rAmount;
540         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
541         
542         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
543         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
544             _takeLiquidity(s.rLiquidity,s.tLiquidity);
545             emit Transfer(sender, address(this), s.tLiquidity + s.tMarketing + s.tDonation);
546         }
547         if(s.rMarketing > 0 || s.tMarketing > 0) _takeMarketing(s.rMarketing, s.tMarketing);
548         if(s.rDonation > 0 || s.tDonation > 0) _takeDonation(s.rDonation, s.tDonation);
549         emit Transfer(sender, recipient, s.tTransferAmount);
550         
551     }
552 
553     function swapAndLiquify(uint256 contractBalance, Taxes memory temp) private lockTheSwap{
554         uint256 denominator = (temp.liquidity + temp.marketing + temp.donation) * 2;
555         uint256 tokensToAddLiquidityWith = contractBalance * temp.liquidity / denominator;
556         uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
557 
558         uint256 initialBalance = address(this).balance;
559 
560         swapTokensForBNB(toSwap);
561 
562         uint256 deltaBalance = address(this).balance - initialBalance;
563         uint256 unitBalance= deltaBalance / (denominator - temp.liquidity);
564         uint256 bnbToAddLiquidityWith = unitBalance * temp.liquidity;
565 
566         if(bnbToAddLiquidityWith > 0){
567             // Add liquidity to pancake
568             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
569         }
570 
571         uint256 marketingAmt = unitBalance * 2 * temp.marketing;
572         if(marketingAmt > 0){
573             payable(marketingWallet).sendValue(marketingAmt);
574         }
575         uint256 donationAmt = unitBalance * 2 * temp.donation;
576         if(donationAmt > 0){
577             payable(donationWallet).sendValue(donationAmt);
578         }
579     }
580 
581     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
582         // approve token transfer to cover all possible scenarios
583         _approve(address(this), address(router), tokenAmount);
584 
585         // add the liquidity
586         router.addLiquidityETH{value: bnbAmount}(
587             address(this),
588             tokenAmount,
589             0, // slippage is unavoidable
590             0, // slippage is unavoidable
591             owner(),
592             block.timestamp
593         );
594     }
595 
596     function swapTokensForBNB(uint256 tokenAmount) private {
597         // generate the uniswap pair path of token -> weth
598         address[] memory path = new address[](2);
599         path[0] = address(this);
600         path[1] = router.WETH();
601 
602         _approve(address(this), address(router), tokenAmount);
603 
604         // make the swap
605         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
606             tokenAmount,
607             0, // accept any amount of ETH
608             path,
609             address(this),
610             block.timestamp
611         );
612     }
613     
614     function airdropTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner{
615         require(accounts.length == amounts.length, "Arrays must have same size");
616         for(uint256 i = 0; i < accounts.length; i++){
617             _tokenTransfer(msg.sender, accounts[i], amounts[i], false, false);
618         }
619     }
620     
621     function bulkExcludeFee(address[] memory accounts, bool state) external onlyOwner{
622         for(uint256 i = 0; i < accounts.length; i++){
623             _isExcludedFromFee[accounts[i]] = state;
624         }
625     }
626 
627     function updateMarketingWallet(address newWallet) external onlyOwner{
628         marketingWallet = newWallet;
629     }
630     
631     function updateDonationWallet(address newWallet) external onlyOwner{
632         donationWallet = newWallet;
633     }
634 
635     
636     function updateCooldown(bool state, uint256 time) external onlyOwner{
637         coolDownTime = time * 1 seconds;
638         coolDownEnabled = state;
639     }
640 
641     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
642         swapTokensAtAmount = amount * 10**_decimals;
643     }
644 
645     function updateSwapEnabled(bool _enabled) external onlyOwner{
646         swapEnabled = _enabled;
647     }
648     
649     function updateIsBlacklisted(address account, bool state) external onlyOwner{
650         _isBlacklisted[account] = state;
651     }
652     
653     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
654         for(uint256 i =0; i < accounts.length; i++){
655             _isBlacklisted[accounts[i]] = state;
656 
657         }
658     }
659     
660     function updateAllowedTransfer(address account, bool state) external onlyOwner{
661         allowedTransfer[account] = state;
662     }
663     
664     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
665         maxBuyLimit = maxBuy * 10**decimals();
666         maxSellLimit = maxSell * 10**decimals();
667     }
668     
669     function updateMaxWalletlimit(uint256 amount) external onlyOwner{
670         maxWalletLimit = amount * 10**decimals();
671     }
672 
673     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
674         router = IRouter(newRouter);
675         pair = newPair;
676     }
677     
678     //Use this in case BNB are sent to the contract by mistake
679     function rescueBNB(uint256 weiAmount) external onlyOwner{
680         require(address(this).balance >= weiAmount, "insufficient BNB balance");
681         payable(msg.sender).transfer(weiAmount);
682     }
683     
684 
685     function rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
686         IERC20(_tokenAddr).transfer(_to, _amount);
687     }
688 
689     receive() external payable{
690     }
691 }