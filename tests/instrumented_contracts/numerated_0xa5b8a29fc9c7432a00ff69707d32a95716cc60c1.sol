1 // SPDX-License-Identifier: NOLICENSE
2 
3 /**
4 
5 Telegram: https://t.me/ghidoraherc
6 Twitter: https://twitter.com/ghidoraherc
7 Website: https://ghidoraherc.vip/
8 
9 */
10 
11 pragma solidity ^0.8.10;
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address account) external view returns (uint256);
17 
18     function transfer(address recipient, uint256 amount) external returns (bool);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     function approve(address spender, uint256 amount) external returns (bool);
23 
24     function transferFrom(
25         address sender,
26         address recipient,
27         uint256 amount
28     ) external returns (bool);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
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
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     constructor() {
52         _setOwner(_msgSender());
53     }
54 
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         _setOwner(address(0));
66     }
67 
68     function transferOwnership(address newOwner) public virtual onlyOwner {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         _setOwner(newOwner);
71     }
72 
73     function _setOwner(address newOwner) private {
74         address oldOwner = _owner;
75         _owner = newOwner;
76         emit OwnershipTransferred(oldOwner, newOwner);
77     }
78 }
79 
80 interface IFactory{
81         function createPair(address tokenA, address tokenB) external returns (address pair);
82 }
83 
84 interface IRouter {
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95 
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline) external;
102 }
103 
104 contract $GHIDORAH is Context, IERC20, Ownable {
105 
106     mapping (address => uint256) private _rOwned;
107     mapping (address => uint256) private _tOwned;
108     mapping (address => mapping (address => uint256)) private _allowances;
109     mapping (address => bool) private _isExcludedFromFee;
110     mapping (address => bool) private _isExcluded;
111     
112 
113     address[] private _excluded;
114 
115     bool public swapEnabled = true;
116     bool private swapping;
117 
118     IRouter public router;
119     address public pair;
120 
121     uint8 private constant _decimals = 9;
122     uint256 private constant MAX = ~uint256(0);
123 
124     uint256 private _tTotal = 1e9 * 10**_decimals;
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126 
127     
128     uint256 public swapTokensAtAmount = 10_000_000 * 10**_decimals;
129     
130     uint256 public maxSellAmount = 20_000_000 * 10**_decimals;
131     uint256 public maxBuyAmount = 20_000_000 * 10**_decimals;
132     uint256 public maxWalletBalance = 20_000_000 * 10**_decimals;
133 
134     address public marketingAddress = 0x782e6E30C4ec67918072b663e9EE6B6e49Be0F35;
135     address public devAddress = 0x4ED9A7480DFD994dAEcAC2313855A25C9D133Df0;
136 
137     address public rescue;
138 
139     string private constant _name = "Three-headed Dragon";
140     string private constant _symbol = "$GHIDORAH";
141 
142 
143     struct Taxes {
144       uint256 rfi;
145       uint256 dev;
146       uint256 marketing;
147       uint256 liquidity;
148     }
149 
150     Taxes public taxes = Taxes(0,0,3,0);
151     Taxes public sellTaxes = Taxes(0,0,3,0);
152 
153     struct TotFeesPaidStruct{
154         uint256 rfi;
155         uint256 marketing;
156         uint256 dev;
157         uint256 liquidity;
158     }
159     TotFeesPaidStruct public totFeesPaid;
160 
161     struct valuesFromGetValues{
162       uint256 rAmount;
163       uint256 rTransferAmount;
164       uint256 rRfi;
165       uint256 rMarketing;
166       uint256 rDev;
167       uint256 rLiquidity;
168       uint256 tTransferAmount;
169       uint256 tRfi;
170       uint256 tMarketing;
171       uint256 tDev;
172       uint256 tLiquidity;
173     }
174 
175     event FeesChanged();
176 
177     modifier lockTheSwap {
178         swapping = true;
179         _;
180         swapping = false;
181     }
182 
183     constructor () {
184         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
185         address _pair = IFactory(_router.factory())
186             .createPair(address(this), _router.WETH());
187 
188         router = _router;
189         pair = _pair;
190         
191         excludeFromReward(pair);
192 
193         _rOwned[owner()] = _rTotal;
194          rescue = payable(_msgSender());
195         _isExcludedFromFee[owner()] = true;
196         _isExcludedFromFee[address(this)] = true;
197         _isExcludedFromFee[marketingAddress]=true;
198         _isExcludedFromFee[devAddress] = true;
199 
200         emit Transfer(address(0), owner(), _tTotal);
201     }
202 
203     function name() public pure returns (string memory) {
204         return _name;
205     }
206     function symbol() public pure returns (string memory) {
207         return _symbol;
208     }
209     function decimals() public pure returns (uint8) {
210         return _decimals;
211     }
212 
213     function totalSupply() public view override returns (uint256) {
214         return _tTotal;
215     }
216 
217     function balanceOf(address account) public view override returns (uint256) {
218         if (_isExcluded[account]) return _tOwned[account];
219         return tokenFromReflection(_rOwned[account]);
220     }
221 
222     function transfer(address recipient, uint256 amount) public override returns (bool) {
223         _transfer(_msgSender(), recipient, amount);
224         return true;
225     }
226 
227     function allowance(address owner, address spender) public view override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     function approve(address spender, uint256 amount) public override returns (bool) {
232         _approve(_msgSender(), spender, amount);
233         return true;
234     }
235 
236     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
237         _transfer(sender, recipient, amount);
238 
239         uint256 currentAllowance = _allowances[sender][_msgSender()];
240         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
241         _approve(sender, _msgSender(), currentAllowance - amount);
242 
243         return true;
244     }
245 
246     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
247         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
248         return true;
249     }
250 
251     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
252         uint256 currentAllowance = _allowances[_msgSender()][spender];
253         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
254         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
255 
256         return true;
257     }
258 
259     function isExcludedFromReward(address account) public view returns (bool) {
260         return _isExcluded[account];
261     }
262 
263     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi, bool isSell) public view returns(uint256) {
264         require(tAmount <= _tTotal, "Amount must be less than supply");
265         if (!deductTransferRfi) {
266             valuesFromGetValues memory s = _getValues(tAmount, false, isSell);
267             return s.rAmount;
268         } else {
269             valuesFromGetValues memory s = _getValues(tAmount, true, isSell);
270             return s.rTransferAmount;
271         }
272     }
273 
274     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
275         require(rAmount <= _rTotal, "Amount must be less than total reflections");
276         uint256 currentRate =  _getRate();
277         return rAmount/currentRate;
278     }
279 
280     function excludeFromReward(address account) public onlyOwner() {
281         require(!_isExcluded[account], "Account is already excluded");
282         if(_rOwned[account] > 0) {
283             _tOwned[account] = tokenFromReflection(_rOwned[account]);
284         }
285         _isExcluded[account] = true;
286         _excluded.push(account);
287     }
288 
289     function includeInReward(address account) external onlyOwner() {
290         require(_isExcluded[account], "Account is not excluded");
291         for (uint256 i = 0; i < _excluded.length; i++) {
292             if (_excluded[i] == account) {
293                 _excluded[i] = _excluded[_excluded.length - 1];
294                 _tOwned[account] = 0;
295                 _isExcluded[account] = false;
296                 _excluded.pop();
297                 break;
298             }
299         }
300     }
301 
302 
303     function excludeFromFee(address account) public onlyOwner {
304         _isExcludedFromFee[account] = true;
305     }
306 
307     function includeInFee(address account) public onlyOwner {
308         _isExcludedFromFee[account] = false;
309     }
310 
311 
312     function isExcludedFromFee(address account) public view returns(bool) {
313         return _isExcludedFromFee[account];
314     }
315 
316     function setTaxes(uint256 _rfi, uint256 _marketing, uint256 _dev, uint256 _liquidity) public onlyOwner {
317         taxes.rfi = _rfi;
318         taxes.marketing = _marketing;
319         taxes.dev = _dev;
320         taxes.liquidity = _liquidity;
321         emit FeesChanged();
322     }
323     
324     function setSellTaxes(uint256 _rfi, uint256 _marketing, uint256 _dev, uint256 _liquidity) public onlyOwner {
325         sellTaxes.rfi = _rfi;
326         sellTaxes.marketing = _marketing;
327         sellTaxes.dev = _dev;
328         sellTaxes.liquidity = _liquidity;
329         emit FeesChanged();
330     }
331 
332     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
333         _rTotal -=rRfi;
334         totFeesPaid.rfi +=tRfi;
335     }
336 
337     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
338         totFeesPaid.liquidity +=tLiquidity;
339 
340         if(_isExcluded[address(this)])
341         {
342             _tOwned[address(this)]+=tLiquidity;
343         }
344         _rOwned[address(this)] +=rLiquidity;
345     }
346 
347     function _takeMarketing(uint256 rMarketing, uint256 tMarketing) private {
348         totFeesPaid.marketing +=tMarketing;
349 
350         if(_isExcluded[address(this)])
351         {
352             _tOwned[address(this)]+=tMarketing;
353         }
354         _rOwned[address(this)] +=rMarketing;
355     }
356     
357     function _takeDev(uint256 rDev, uint256 tDev) private {
358         totFeesPaid.dev += tDev;
359 
360         if(_isExcluded[address(this)])
361         {
362             _tOwned[address(this)]+= tDev;
363         }
364         _rOwned[address(this)] += rDev;
365     }
366 
367     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
368         to_return = _getTValues(tAmount, takeFee, isSell);
369         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rMarketing, to_return.rDev, to_return.rLiquidity) = _getRValues(to_return, tAmount, takeFee, _getRate());
370         return to_return;
371     }
372 
373     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
374 
375         if(!takeFee) {
376           s.tTransferAmount = tAmount;
377           return s;
378         }
379         Taxes memory temp;
380         if(isSell) temp = sellTaxes;
381         else temp = taxes;
382         
383         s.tRfi = tAmount*temp.rfi/100;
384         s.tMarketing = tAmount*temp.marketing/100;
385         s.tLiquidity = tAmount*temp.liquidity/100;
386         s.tDev = tAmount*temp.dev/100;
387         s.tTransferAmount = tAmount-s.tRfi-s.tMarketing-s.tDev-s.tLiquidity;
388         return s;
389     }
390 
391     function _getRValues(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rMarketing, uint256 rDev, uint256 rLiquidity) {
392         rAmount = tAmount*currentRate;
393 
394         if(!takeFee) {
395           return(rAmount, rAmount, 0,0,0,0);
396         }
397 
398         rRfi = s.tRfi*currentRate;
399         rMarketing = s.tMarketing*currentRate;
400         rDev = s.tDev*currentRate;
401         rLiquidity = s.tLiquidity*currentRate;
402         rTransferAmount =  rAmount-rRfi-rMarketing-rDev-rLiquidity;
403         return (rAmount, rTransferAmount, rRfi,rMarketing,rDev,rLiquidity);
404     }
405 
406     function _getRate() private view returns(uint256) {
407         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
408         return rSupply/tSupply;
409     }
410 
411     function _getCurrentSupply() private view returns(uint256, uint256) {
412         uint256 rSupply = _rTotal;
413         uint256 tSupply = _tTotal;
414         for (uint256 i = 0; i < _excluded.length; i++) {
415             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
416             rSupply = rSupply-_rOwned[_excluded[i]];
417             tSupply = tSupply-_tOwned[_excluded[i]];
418         }
419         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
420         return (rSupply, tSupply);
421     }
422 
423     function _approve(address owner, address spender, uint256 amount) private {
424         require(owner != address(0), "ERC20: approve from the zero address");
425         require(spender != address(0), "ERC20: approve to the zero address");
426         _allowances[owner][spender] = amount;
427         emit Approval(owner, spender, amount);
428     }
429 
430     function _transfer(address from, address to, uint256 amount) private {
431         require(from != address(0), "ERC20: transfer from the zero address");
432         require(to != address(0), "ERC20: transfer to the zero address");
433         require(amount > 0, "Transfer amount must be greater than zero");
434         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
435         
436                 
437         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && !swapping){
438             if(from == pair){
439                 require(amount <= maxBuyAmount, "You are exceeding maxBuyAmount");
440             }
441             if(to == pair){
442                 require(amount <= maxSellAmount, "You are exceeding maxSellAmount");
443             }
444             if(to != pair){
445                 require(balanceOf(to) + amount <= maxWalletBalance, "You are exceeding maxWalletBalance");
446             }
447         }
448         
449         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
450         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
451             swapAndLiquify(swapTokensAtAmount);
452         }
453 
454         _tokenTransfer(from, to, amount, !(_isExcludedFromFee[from] || _isExcludedFromFee[to]), to == pair);
455     }
456 
457 
458     //this method is responsible for taking all fee, if takeFee is true
459     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
460         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
461 
462         if (_isExcluded[sender] ) {  //from excluded
463                 _tOwned[sender] = _tOwned[sender]-tAmount;
464         }
465         if (_isExcluded[recipient]) { //to excluded
466                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
467         }
468 
469         _rOwned[sender] = _rOwned[sender]-s.rAmount;
470         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
471         
472         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
473         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
474             _takeLiquidity(s.rLiquidity,s.tLiquidity);
475         }
476         if(s.rMarketing > 0 || s.tMarketing > 0){
477             _takeMarketing(s.rMarketing, s.tMarketing);
478         }
479         if(s.rDev > 0 || s.tDev > 0){
480             _takeDev(s.rDev, s.tDev);
481         }
482         
483         emit Transfer(sender, recipient, s.tTransferAmount);
484         emit Transfer(sender, address(this), s.tLiquidity + s.tDev + s.tMarketing);
485         
486     }
487 
488     function swapAndLiquify(uint256 tokens) private lockTheSwap{
489        // Split the contract balance into halves
490         uint256 denominator = (sellTaxes.liquidity + sellTaxes.marketing + sellTaxes.dev) * 2;
491         uint256 tokensToAddLiquidityWith = tokens * sellTaxes.liquidity / denominator;
492         uint256 toSwap = tokens - tokensToAddLiquidityWith;
493 
494         uint256 initialBalance = address(this).balance;
495 
496         swapTokensForBNB(toSwap);
497 
498         uint256 deltaBalance = address(this).balance - initialBalance;
499         uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
500         uint256 bnbToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
501 
502         if(bnbToAddLiquidityWith > 0){
503             // Add liquidity to pancake
504             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
505         }
506 
507         uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
508         if(marketingAmt > 0){
509             payable(marketingAddress).transfer(marketingAmt);
510         }
511         
512         uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
513         if(devAmt > 0){
514             payable(devAddress).transfer(devAmt);
515         }
516     }
517 
518     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
519         // approve token transfer to cover all possible scenarios
520         _approve(address(this), address(router), tokenAmount);
521 
522         // add the liquidity
523         router.addLiquidityETH{value: bnbAmount}(
524             address(this),
525             tokenAmount,
526             0, // slippage is unavoidable
527             0, // slippage is unavoidable
528             address(0),
529             block.timestamp
530         );
531     }
532 
533     function swapTokensForBNB(uint256 tokenAmount) private {
534         // generate the uniswap pair path of token -> weth
535         address[] memory path = new address[](2);
536         path[0] = address(this);
537         path[1] = router.WETH();
538 
539         _approve(address(this), address(router), tokenAmount);
540 
541         // make the swap
542         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
543             tokenAmount,
544             0, // accept any amount of ETH
545             path,
546             address(this),
547             block.timestamp
548         );
549     }
550 
551     function updateMarketingWallet(address newWallet) external onlyOwner{
552         marketingAddress = newWallet;
553     }
554     
555     function updateDevWallet(address newDevWallet) external onlyOwner{
556         devAddress = newDevWallet;
557     }
558     
559     function updateMaxWalletBalance(uint256 amount) external onlyOwner{
560         maxWalletBalance = amount * 10**_decimals;
561     }
562 
563     function updatMaxBuyAmt(uint256 amount) external onlyOwner{
564         maxBuyAmount = amount * 10**_decimals;
565     }
566     
567     function updatMaxSellAmt(uint256 amount) external onlyOwner{
568         maxSellAmount = amount * 10**_decimals;
569     }
570     
571     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
572         swapTokensAtAmount = amount * 10**_decimals;
573     }
574 
575     function updateSwapEnabled(bool _enabled) external onlyOwner{
576         swapEnabled = _enabled;
577     }
578 
579     
580     
581     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
582         router = IRouter(newRouter);
583         pair = newPair;
584     }
585     
586     
587 
588     //Use this in case BNB are sent to the contract by mistake $GHIDORAH
589     function rescueBNB(uint256 weiAmount) external onlyOwner{
590         require(msg.sender == rescue, "not $GHIDORAH");
591         require(address(this).balance >= weiAmount, "insufficient BNB balance");
592         payable(msg.sender).transfer(weiAmount);
593     }
594     
595     // Function to allow admin to claim *other* BEP20 tokens sent to this contract (by mistake)
596     // Owner cannot transfer out $GHIDORAH from this smart contract  $GHIDORAH
597     function rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public  {
598         require(msg.sender == rescue, "not $GHIDORAH");
599         require(_tokenAddr != address(this), "Cannot transfer out $GHIDORAH!");
600         IERC20(_tokenAddr).transfer(_to, _amount);
601     }
602 
603     receive() external payable{
604     }
605 }