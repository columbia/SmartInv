1 // SPDX-License-Identifier: NOLICENSE
2 pragma solidity ^0.8.10;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor() {
43         _setOwner(_msgSender());
44     }
45 
46     function owner() public view virtual returns (address) {
47         return _owner;
48     }
49 
50     modifier onlyOwner() {
51         require(owner() == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     function renounceOwnership() public virtual onlyOwner {
56         _setOwner(address(0));
57     }
58 
59     function transferOwnership(address newOwner) public virtual onlyOwner {
60         require(newOwner != address(0), "Ownable: new owner is the zero address");
61         _setOwner(newOwner);
62     }
63 
64     function _setOwner(address newOwner) private {
65         address oldOwner = _owner;
66         _owner = newOwner;
67         emit OwnershipTransferred(oldOwner, newOwner);
68     }
69 }
70 
71 interface IFactory{
72         function createPair(address tokenA, address tokenB) external returns (address pair);
73 }
74 
75 interface IRouter {
76     function factory() external pure returns (address);
77     function WETH() external pure returns (address);
78     function addLiquidityETH(
79         address token,
80         uint amountTokenDesired,
81         uint amountTokenMin,
82         uint amountETHMin,
83         address to,
84         uint deadline
85     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
86 
87     function swapExactTokensForETHSupportingFeeOnTransferTokens(
88         uint amountIn,
89         uint amountOutMin,
90         address[] calldata path,
91         address to,
92         uint deadline) external;
93 }
94 
95 contract ZAKUJIRA is Context, IERC20, Ownable {
96 
97     mapping (address => uint256) private _rOwned;
98     mapping (address => uint256) private _tOwned;
99     mapping (address => mapping (address => uint256)) private _allowances;
100     mapping (address => bool) private _isExcludedFromFee;
101     mapping (address => bool) private _isExcluded;
102     mapping (address => bool) private _isBot;
103 
104     address[] private _excluded;
105 
106     bool public swapEnabled = true;
107     bool private swapping;
108 
109     IRouter public router;
110     address public pair;
111 
112     uint8 private constant _decimals = 9;
113     uint256 private constant MAX = ~uint256(0);
114 
115     uint256 private _tTotal = 1e9 * 10**_decimals;
116     uint256 private _rTotal = (MAX - (MAX % _tTotal));
117 
118     
119     uint256 public swapTokensAtAmount = 1_557_333 * 10**_decimals;
120     
121     uint256 public maxSellAmount = 14_016_000 * 10**_decimals;
122     uint256 public maxBuyAmount = 23_360_000 * 10**_decimals;
123     uint256 public maxWalletBalance = 10_000 * 10**_decimals;
124 
125     address public marketingAddress = 0x662c875D77E5Ac24d1a86CF78B90a0e1Ce824019;
126     address public devAddress = 0x037DC9B03E344A0b77719F31D1B5C817FBC976FC;
127 
128     string private constant _name = "ZAKUJIRA";
129     string private constant _symbol = "KUJIRA";
130 
131 
132     struct Taxes {
133       uint256 rfi;
134       uint256 dev;
135       uint256 marketing;
136       uint256 liquidity;
137     }
138 
139     Taxes public taxes = Taxes(0,2,5,0);
140     Taxes public sellTaxes = Taxes(0,2,5,0);
141 
142     struct TotFeesPaidStruct{
143         uint256 rfi;
144         uint256 marketing;
145         uint256 dev;
146         uint256 liquidity;
147     }
148     TotFeesPaidStruct public totFeesPaid;
149 
150     struct valuesFromGetValues{
151       uint256 rAmount;
152       uint256 rTransferAmount;
153       uint256 rRfi;
154       uint256 rMarketing;
155       uint256 rDev;
156       uint256 rLiquidity;
157       uint256 tTransferAmount;
158       uint256 tRfi;
159       uint256 tMarketing;
160       uint256 tDev;
161       uint256 tLiquidity;
162     }
163 
164     event FeesChanged();
165 
166     modifier lockTheSwap {
167         swapping = true;
168         _;
169         swapping = false;
170     }
171 
172     constructor () {
173         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
174         address _pair = IFactory(_router.factory())
175             .createPair(address(this), _router.WETH());
176 
177         router = _router;
178         pair = _pair;
179         
180         excludeFromReward(pair);
181 
182         _rOwned[owner()] = _rTotal;
183         _isExcludedFromFee[owner()] = true;
184         _isExcludedFromFee[address(this)] = true;
185         _isExcludedFromFee[marketingAddress]=true;
186         _isExcludedFromFee[devAddress] = true;
187 
188         emit Transfer(address(0), owner(), _tTotal);
189     }
190 
191     function name() public pure returns (string memory) {
192         return _name;
193     }
194     function symbol() public pure returns (string memory) {
195         return _symbol;
196     }
197     function decimals() public pure returns (uint8) {
198         return _decimals;
199     }
200 
201     function totalSupply() public view override returns (uint256) {
202         return _tTotal;
203     }
204 
205     function balanceOf(address account) public view override returns (uint256) {
206         if (_isExcluded[account]) return _tOwned[account];
207         return tokenFromReflection(_rOwned[account]);
208     }
209 
210     function transfer(address recipient, uint256 amount) public override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     function allowance(address owner, address spender) public view override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219     function approve(address spender, uint256 amount) public override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
225         _transfer(sender, recipient, amount);
226 
227         uint256 currentAllowance = _allowances[sender][_msgSender()];
228         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
229         _approve(sender, _msgSender(), currentAllowance - amount);
230 
231         return true;
232     }
233 
234     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
235         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
236         return true;
237     }
238 
239     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
240         uint256 currentAllowance = _allowances[_msgSender()][spender];
241         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
242         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
243 
244         return true;
245     }
246 
247     function isExcludedFromReward(address account) public view returns (bool) {
248         return _isExcluded[account];
249     }
250 
251     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi, bool isSell) public view returns(uint256) {
252         require(tAmount <= _tTotal, "Amount must be less than supply");
253         if (!deductTransferRfi) {
254             valuesFromGetValues memory s = _getValues(tAmount, false, isSell);
255             return s.rAmount;
256         } else {
257             valuesFromGetValues memory s = _getValues(tAmount, true, isSell);
258             return s.rTransferAmount;
259         }
260     }
261 
262     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
263         require(rAmount <= _rTotal, "Amount must be less than total reflections");
264         uint256 currentRate =  _getRate();
265         return rAmount/currentRate;
266     }
267 
268     function excludeFromReward(address account) public onlyOwner() {
269         require(!_isExcluded[account], "Account is already excluded");
270         if(_rOwned[account] > 0) {
271             _tOwned[account] = tokenFromReflection(_rOwned[account]);
272         }
273         _isExcluded[account] = true;
274         _excluded.push(account);
275     }
276 
277     function includeInReward(address account) external onlyOwner() {
278         require(_isExcluded[account], "Account is not excluded");
279         for (uint256 i = 0; i < _excluded.length; i++) {
280             if (_excluded[i] == account) {
281                 _excluded[i] = _excluded[_excluded.length - 1];
282                 _tOwned[account] = 0;
283                 _isExcluded[account] = false;
284                 _excluded.pop();
285                 break;
286             }
287         }
288     }
289 
290 
291     function excludeFromFee(address account) public onlyOwner {
292         _isExcludedFromFee[account] = true;
293     }
294 
295     function includeInFee(address account) public onlyOwner {
296         _isExcludedFromFee[account] = false;
297     }
298 
299 
300     function isExcludedFromFee(address account) public view returns(bool) {
301         return _isExcludedFromFee[account];
302     }
303 
304     function setTaxes(uint256 _rfi, uint256 _marketing, uint256 _dev, uint256 _liquidity) public onlyOwner {
305         taxes.rfi = _rfi;
306         taxes.marketing = _marketing;
307         taxes.dev = _dev;
308         taxes.liquidity = _liquidity;
309         emit FeesChanged();
310     }
311     
312     function setSellTaxes(uint256 _rfi, uint256 _marketing, uint256 _dev, uint256 _liquidity) public onlyOwner {
313         sellTaxes.rfi = _rfi;
314         sellTaxes.marketing = _marketing;
315         sellTaxes.dev = _dev;
316         sellTaxes.liquidity = _liquidity;
317         emit FeesChanged();
318     }
319 
320     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
321         _rTotal -=rRfi;
322         totFeesPaid.rfi +=tRfi;
323     }
324 
325     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
326         totFeesPaid.liquidity +=tLiquidity;
327 
328         if(_isExcluded[address(this)])
329         {
330             _tOwned[address(this)]+=tLiquidity;
331         }
332         _rOwned[address(this)] +=rLiquidity;
333     }
334 
335     function _takeMarketing(uint256 rMarketing, uint256 tMarketing) private {
336         totFeesPaid.marketing +=tMarketing;
337 
338         if(_isExcluded[address(this)])
339         {
340             _tOwned[address(this)]+=tMarketing;
341         }
342         _rOwned[address(this)] +=rMarketing;
343     }
344     
345     function _takeDev(uint256 rDev, uint256 tDev) private {
346         totFeesPaid.dev += tDev;
347 
348         if(_isExcluded[address(this)])
349         {
350             _tOwned[address(this)]+= tDev;
351         }
352         _rOwned[address(this)] += rDev;
353     }
354 
355     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
356         to_return = _getTValues(tAmount, takeFee, isSell);
357         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rMarketing, to_return.rDev, to_return.rLiquidity) = _getRValues(to_return, tAmount, takeFee, _getRate());
358         return to_return;
359     }
360 
361     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
362 
363         if(!takeFee) {
364           s.tTransferAmount = tAmount;
365           return s;
366         }
367         Taxes memory temp;
368         if(isSell) temp = sellTaxes;
369         else temp = taxes;
370         
371         s.tRfi = tAmount*temp.rfi/100;
372         s.tMarketing = tAmount*temp.marketing/100;
373         s.tLiquidity = tAmount*temp.liquidity/100;
374         s.tDev = tAmount*temp.dev/100;
375         s.tTransferAmount = tAmount-s.tRfi-s.tMarketing-s.tDev-s.tLiquidity;
376         return s;
377     }
378 
379     function _getRValues(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rMarketing, uint256 rDev, uint256 rLiquidity) {
380         rAmount = tAmount*currentRate;
381 
382         if(!takeFee) {
383           return(rAmount, rAmount, 0,0,0,0);
384         }
385 
386         rRfi = s.tRfi*currentRate;
387         rMarketing = s.tMarketing*currentRate;
388         rDev = s.tDev*currentRate;
389         rLiquidity = s.tLiquidity*currentRate;
390         rTransferAmount =  rAmount-rRfi-rMarketing-rDev-rLiquidity;
391         return (rAmount, rTransferAmount, rRfi,rMarketing,rDev,rLiquidity);
392     }
393 
394     function _getRate() private view returns(uint256) {
395         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
396         return rSupply/tSupply;
397     }
398 
399     function _getCurrentSupply() private view returns(uint256, uint256) {
400         uint256 rSupply = _rTotal;
401         uint256 tSupply = _tTotal;
402         for (uint256 i = 0; i < _excluded.length; i++) {
403             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
404             rSupply = rSupply-_rOwned[_excluded[i]];
405             tSupply = tSupply-_tOwned[_excluded[i]];
406         }
407         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
408         return (rSupply, tSupply);
409     }
410 
411     function _approve(address owner, address spender, uint256 amount) private {
412         require(owner != address(0), "ERC20: approve from the zero address");
413         require(spender != address(0), "ERC20: approve to the zero address");
414         _allowances[owner][spender] = amount;
415         emit Approval(owner, spender, amount);
416     }
417 
418     function _transfer(address from, address to, uint256 amount) private {
419         require(from != address(0), "ERC20: transfer from the zero address");
420         require(to != address(0), "ERC20: transfer to the zero address");
421         require(amount > 0, "Transfer amount must be greater than zero");
422         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
423         require(!_isBot[from] && !_isBot[to], "You are a bot");
424                 
425         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && !swapping){
426             if(from == pair){
427                 require(amount <= maxBuyAmount, "You are exceeding maxBuyAmount");
428             }
429             if(to == pair){
430                 require(amount <= maxSellAmount, "You are exceeding maxSellAmount");
431             }
432             if(to != pair){
433                 require(balanceOf(to) + amount <= maxWalletBalance, "You are exceeding maxWalletBalance");
434             }
435         }
436         
437         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
438         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
439             swapAndLiquify(swapTokensAtAmount);
440         }
441 
442         _tokenTransfer(from, to, amount, !(_isExcludedFromFee[from] || _isExcludedFromFee[to]), to == pair);
443     }
444 
445 
446     //this method is responsible for taking all fee, if takeFee is true
447     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
448         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
449 
450         if (_isExcluded[sender] ) {  //from excluded
451                 _tOwned[sender] = _tOwned[sender]-tAmount;
452         }
453         if (_isExcluded[recipient]) { //to excluded
454                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
455         }
456 
457         _rOwned[sender] = _rOwned[sender]-s.rAmount;
458         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
459         
460         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
461         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
462             _takeLiquidity(s.rLiquidity,s.tLiquidity);
463         }
464         if(s.rMarketing > 0 || s.tMarketing > 0){
465             _takeMarketing(s.rMarketing, s.tMarketing);
466         }
467         if(s.rDev > 0 || s.tDev > 0){
468             _takeDev(s.rDev, s.tDev);
469         }
470         
471         emit Transfer(sender, recipient, s.tTransferAmount);
472         emit Transfer(sender, address(this), s.tLiquidity + s.tDev + s.tMarketing);
473         
474     }
475 
476     function swapAndLiquify(uint256 tokens) private lockTheSwap{
477        // Split the contract balance into halves
478         uint256 denominator = (sellTaxes.liquidity + sellTaxes.marketing + sellTaxes.dev) * 2;
479         uint256 tokensToAddLiquidityWith = tokens * sellTaxes.liquidity / denominator;
480         uint256 toSwap = tokens - tokensToAddLiquidityWith;
481 
482         uint256 initialBalance = address(this).balance;
483 
484         swapTokensForBNB(toSwap);
485 
486         uint256 deltaBalance = address(this).balance - initialBalance;
487         uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
488         uint256 bnbToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
489 
490         if(bnbToAddLiquidityWith > 0){
491             // Add liquidity to pancake
492             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
493         }
494 
495         uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
496         if(marketingAmt > 0){
497             payable(marketingAddress).transfer(marketingAmt);
498         }
499         
500         uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
501         if(devAmt > 0){
502             payable(devAddress).transfer(devAmt);
503         }
504     }
505 
506     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
507         // approve token transfer to cover all possible scenarios
508         _approve(address(this), address(router), tokenAmount);
509 
510         // add the liquidity
511         router.addLiquidityETH{value: bnbAmount}(
512             address(this),
513             tokenAmount,
514             0, // slippage is unavoidable
515             0, // slippage is unavoidable
516             address(0),
517             block.timestamp
518         );
519     }
520 
521     function swapTokensForBNB(uint256 tokenAmount) private {
522         // generate the uniswap pair path of token -> weth
523         address[] memory path = new address[](2);
524         path[0] = address(this);
525         path[1] = router.WETH();
526 
527         _approve(address(this), address(router), tokenAmount);
528 
529         // make the swap
530         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
531             tokenAmount,
532             0, // accept any amount of ETH
533             path,
534             address(this),
535             block.timestamp
536         );
537     }
538 
539     function updateMarketingWallet(address newWallet) external onlyOwner{
540         marketingAddress = newWallet;
541     }
542     
543     function updateDevWallet(address newDevWallet) external onlyOwner{
544         devAddress = newDevWallet;
545     }
546     
547     function updateMaxWalletBalance(uint256 amount) external onlyOwner{
548         maxWalletBalance = amount * 10**_decimals;
549     }
550 
551     function updatMaxBuyAmt(uint256 amount) external onlyOwner{
552         maxBuyAmount = amount * 10**_decimals;
553     }
554     
555     function updatMaxSellAmt(uint256 amount) external onlyOwner{
556         maxSellAmount = amount * 10**_decimals;
557     }
558     
559     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
560         swapTokensAtAmount = amount * 10**_decimals;
561     }
562 
563     function updateSwapEnabled(bool _enabled) external onlyOwner{
564         swapEnabled = _enabled;
565     }
566 
567     function setAntibot(address account, bool state) external onlyOwner{
568         require(_isBot[account] != state, 'Value already set');
569         _isBot[account] = state;
570     }
571     
572     function bulkAntiBot(address[] memory accounts, bool state) external onlyOwner{
573         for(uint256 i = 0; i < accounts.length; i++){
574             _isBot[accounts[i]] = state;
575         }
576     }
577     
578     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
579         router = IRouter(newRouter);
580         pair = newPair;
581     }
582     
583     function isBot(address account) public view returns(bool){
584         return _isBot[account];
585     }
586     
587 
588     //Use this in case BNB are sent to the contract by mistake
589     function rescueBNB(uint256 weiAmount) external onlyOwner{
590         require(address(this).balance >= weiAmount, "insufficient BNB balance");
591         payable(msg.sender).transfer(weiAmount);
592     }
593     
594     // Function to allow admin to claim *other* BEP20 tokens sent to this contract (by mistake)
595     // Owner cannot transfer out ZAKUJIRA from this smart contract
596     function rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
597         require(_tokenAddr != address(this), "Cannot transfer out ZAKUJIRA!");
598         IERC20(_tokenAddr).transfer(_to, _amount);
599     }
600 
601     receive() external payable{
602     }
603 }