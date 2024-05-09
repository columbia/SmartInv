1 // SPDX-License-Identifier: NOLICENSE
2 pragma solidity ^0.8.7;
3  
4 ////////////////////////////////////////////////////////
5 //  ___    _                  _    _                  //
6 // | . | _| | _ _  ___ ._ _ _| |_ <_> ___             //
7 // |   |/ . || | |<_> || ' | | |  | |<_-<             // 
8 // |_|_|\___||__/ <___||_|_| |_|  |_|/__/             //
9 //                                                    //
10 // Advantis AI Token Analysis Tool www.advantis.ai    // 
11 // Advantis Token www.advantistoken.com               //
12 //                                                    // 
13 ////////////////////////////////////////////////////////
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
106 contract ADVT is Context, IERC20, Ownable {
107  
108     mapping (address => uint256) private _rOwned;
109     mapping (address => uint256) private _tOwned;
110     mapping (address => mapping (address => uint256)) private _allowances;
111     mapping (address => bool) private _isExcludedFromFee;
112     mapping (address => bool) private _isExcluded;
113     mapping (address => bool) private _isBot;
114  
115     address[] private _excluded;
116  
117     bool public swapEnabled;
118     bool private swapping;
119  
120     IRouter public router;
121     address public pair;
122  
123     uint8 private constant _decimals = 9;
124     uint256 private constant MAX = ~uint256(0);
125  
126     uint256 private _tTotal = 1e12 * 10**_decimals;
127     uint256 private _rTotal = (MAX - (MAX % _tTotal));
128  
129  
130     uint256 public swapTokensAtAmount = 200_000 * 10**_decimals;
131     uint256 public maxTxAmount = 1e9 * 10**_decimals;
132  
133     // Anti Dump //
134     mapping (address => uint256) public _lastTrade;
135     bool public coolDownEnabled = true;
136     uint256 public coolDownTime = 40 seconds;
137  
138     address public constant deadAddress = 0x000000000000000000000000000000000000dEaD;
139     address public devAddress = 0x266423eba1a324305c62578483AE7413E5eba5FA;
140  
141     string private constant _name = "Advantis Token";
142     string private constant _symbol = "ADVT";
143  
144  
145     struct Taxes {
146       uint256 rfi;
147       uint256 dev;
148       uint256 liquidity;
149       uint256 burn;
150     }
151  
152     Taxes public taxes = Taxes(1,1,1,1);
153     struct TotFeesPaidStruct{
154         uint256 rfi;
155         uint256 dev;
156         uint256 liquidity;
157         uint256 burn;
158     }
159     TotFeesPaidStruct public totFeesPaid;
160  
161     struct valuesFromGetValues{
162       uint256 rAmount;
163       uint256 rTransferAmount;
164       uint256 rRfi;
165       uint256 rDev;
166       uint256 rLiquidity;
167       uint256 rBurn;
168       uint256 tTransferAmount;
169       uint256 tRfi;
170       uint256 tDev;
171       uint256 tLiquidity;
172       uint256 tBurn;
173     }
174  
175     event FeesChanged();
176     event UpdatedRouter(address oldRouter, address newRouter);
177  
178     modifier lockTheSwap {
179         swapping = true;
180         _;
181         swapping = false;
182     }
183  
184     constructor (address routerAddress) {
185         IRouter _router = IRouter(routerAddress);
186         address _pair = IFactory(_router.factory())
187             .createPair(address(this), _router.WETH());
188  
189         router = _router;
190         pair = _pair;
191  
192         excludeFromReward(pair);
193         excludeFromReward(deadAddress);
194  
195         _rOwned[owner()] = _rTotal;
196         _isExcludedFromFee[owner()] = true;
197         _isExcludedFromFee[address(this)] = true;
198         _isExcludedFromFee[devAddress]=true;
199         _isExcludedFromFee[deadAddress] = true;
200  
201         emit Transfer(address(0), owner(), _tTotal);
202     }
203  
204     function name() public pure returns (string memory) {
205         return _name;
206     }
207     function symbol() public pure returns (string memory) {
208         return _symbol;
209     }
210     function decimals() public pure returns (uint8) {
211         return _decimals;
212     }
213  
214     function totalSupply() public view override returns (uint256) {
215         return _tTotal;
216     }
217  
218     function balanceOf(address account) public view override returns (uint256) {
219         if (_isExcluded[account]) return _tOwned[account];
220         return tokenFromReflection(_rOwned[account]);
221     }
222  
223     function transfer(address recipient, uint256 amount) public override returns (bool) {
224         _transfer(_msgSender(), recipient, amount);
225         return true;
226     }
227  
228     function allowance(address owner, address spender) public view override returns (uint256) {
229         return _allowances[owner][spender];
230     }
231  
232     function approve(address spender, uint256 amount) public override returns (bool) {
233         _approve(_msgSender(), spender, amount);
234         return true;
235     }
236  
237     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
238         _transfer(sender, recipient, amount);
239  
240         uint256 currentAllowance = _allowances[sender][_msgSender()];
241         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
242         _approve(sender, _msgSender(), currentAllowance - amount);
243  
244         return true;
245     }
246  
247     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
248         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
249         return true;
250     }
251  
252     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
253         uint256 currentAllowance = _allowances[_msgSender()][spender];
254         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
255         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
256  
257         return true;
258     }
259  
260     function isExcludedFromReward(address account) public view returns (bool) {
261         return _isExcluded[account];
262     }
263  
264     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
265         require(tAmount <= _tTotal, "Amount must be less than supply");
266         if (!deductTransferRfi) {
267             valuesFromGetValues memory s = _getValues(tAmount, true);
268             return s.rAmount;
269         } else {
270             valuesFromGetValues memory s = _getValues(tAmount, true);
271             return s.rTransferAmount;
272         }
273     }
274  
275     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
276         require(rAmount <= _rTotal, "Amount must be less than total reflections");
277         uint256 currentRate =  _getRate();
278         return rAmount/currentRate;
279     }
280  
281     function excludeFromReward(address account) public onlyOwner() {
282         require(!_isExcluded[account], "Account is already excluded");
283         if(_rOwned[account] > 0) {
284             _tOwned[account] = tokenFromReflection(_rOwned[account]);
285         }
286         _isExcluded[account] = true;
287         _excluded.push(account);
288     }
289  
290     function includeInReward(address account) external onlyOwner() {
291         require(_isExcluded[account], "Account is not excluded");
292         for (uint256 i = 0; i < _excluded.length; i++) {
293             if (_excluded[i] == account) {
294                 _excluded[i] = _excluded[_excluded.length - 1];
295                 _tOwned[account] = 0;
296                 _isExcluded[account] = false;
297                 _excluded.pop();
298                 break;
299             }
300         }
301     }
302  
303  
304     function excludeFromFee(address account) public onlyOwner {
305         _isExcludedFromFee[account] = true;
306     }
307  
308     function includeInFee(address account) public onlyOwner {
309         _isExcludedFromFee[account] = false;
310     }
311  
312  
313     function isExcludedFromFee(address account) public view returns(bool) {
314         return _isExcludedFromFee[account];
315     }
316  
317     function setTaxes(uint256 _rfi, uint256 _dev, uint256 _liquidity, uint256 _burn) public onlyOwner {
318         require( _rfi + _dev + _liquidity + _burn <= 6, "Max Fee reached");
319         taxes = Taxes(_rfi, _dev, _liquidity, _burn);
320         emit FeesChanged();
321     }
322  
323  
324     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
325         _rTotal -=rRfi;
326         totFeesPaid.rfi +=tRfi;
327     }
328  
329     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
330         totFeesPaid.liquidity +=tLiquidity;
331  
332         if(_isExcluded[address(this)])
333         {
334             _tOwned[address(this)]+=tLiquidity;
335         }
336         _rOwned[address(this)] +=rLiquidity;
337     }
338  
339     function _takeDev(uint256 rDev, uint256 tDev) private {
340         totFeesPaid.dev +=tDev;
341  
342         if(_isExcluded[address(this)])
343         {
344             _tOwned[address(this)]+=tDev;
345         }
346         _rOwned[address(this)] +=rDev;
347     }
348  
349     function _takeBurn(uint256 rBurn, uint256 tBurn) private{
350         totFeesPaid.burn +=tBurn;
351  
352         if(_isExcluded[deadAddress])
353         {
354             _tOwned[deadAddress]+=tBurn;
355         }
356         _rOwned[deadAddress] +=rBurn;
357     }
358  
359     function _getValues(uint256 tAmount, bool takeFee) private view returns (valuesFromGetValues memory to_return) {
360         to_return = _getTValues(tAmount, takeFee);
361         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rDev, to_return.rLiquidity, to_return.rBurn) = _getRValues(to_return, tAmount, takeFee, _getRate());
362         return to_return;
363     }
364  
365     function _getTValues(uint256 tAmount, bool takeFee) private view returns (valuesFromGetValues memory s) {
366  
367         if(!takeFee) {
368           s.tTransferAmount = tAmount;
369           return s;
370         }
371  
372         s.tRfi = tAmount*taxes.rfi/100;
373         s.tDev = tAmount*taxes.dev/100;
374         s.tLiquidity = tAmount*taxes.liquidity/100;
375         s.tBurn = tAmount*taxes.burn/100;
376         s.tTransferAmount = tAmount-s.tRfi-s.tDev-s.tLiquidity-s.tBurn;
377         return s;
378     }
379  
380     function _getRValues(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rDev, uint256 rLiquidity, uint256 rBurn) {
381         rAmount = tAmount*currentRate;
382  
383         if(!takeFee) {
384           return(rAmount, rAmount, 0,0,0,0);
385         }
386  
387         rRfi = s.tRfi*currentRate;
388         rDev = s.tDev*currentRate;
389         rLiquidity = s.tLiquidity*currentRate;
390         rBurn = s.rBurn*currentRate;
391         rTransferAmount =  rAmount-rRfi-rDev-rLiquidity-rBurn;
392         return (rAmount, rTransferAmount, rRfi,rDev,rLiquidity, rBurn);
393     }
394  
395     function _getRate() private view returns(uint256) {
396         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
397         return rSupply/tSupply;
398     }
399  
400     function _getCurrentSupply() private view returns(uint256, uint256) {
401         uint256 rSupply = _rTotal;
402         uint256 tSupply = _tTotal;
403         for (uint256 i = 0; i < _excluded.length; i++) {
404             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
405             rSupply = rSupply-_rOwned[_excluded[i]];
406             tSupply = tSupply-_tOwned[_excluded[i]];
407         }
408         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
409         return (rSupply, tSupply);
410     }
411  
412     function _approve(address owner, address spender, uint256 amount) private {
413         require(owner != address(0), "ERC20: approve from the zero address");
414         require(spender != address(0), "ERC20: approve to the zero address");
415         _allowances[owner][spender] = amount;
416         emit Approval(owner, spender, amount);
417     }
418  
419  
420     function _transfer(address from, address to, uint256 amount) private {
421         require(from != address(0), "ERC20: transfer from the zero address");
422         require(to != address(0), "ERC20: transfer to the zero address");
423         require(amount > 0, "Transfer amount must be greater than zero");
424         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
425         require(!_isBot[from] && !_isBot[to], "You are a bot");
426  
427  
428         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && !swapping){
429             require(amount <= maxTxAmount ,"Amount is exceeding maxTxAmount");
430  
431             if(from != pair && coolDownEnabled){
432                 uint256 timePassed = block.timestamp - _lastTrade[from];
433                 require(timePassed > coolDownTime, "You must wait coolDownTime");
434                 _lastTrade[from] = block.timestamp;
435             }
436             if(to != pair && coolDownEnabled){
437                 uint256 timePassed2 = block.timestamp - _lastTrade[to];
438                 require(timePassed2 > coolDownTime, "You must wait coolDownTime");
439                 _lastTrade[to] = block.timestamp;
440             }
441         }
442  
443         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
444         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
445             swapAndLiquify(swapTokensAtAmount);
446         }
447  
448         bool takeFee = true;
449  
450         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || swapping || (from != pair && to != pair) ){
451             takeFee = false;
452         }
453  
454         _tokenTransfer(from, to, amount, takeFee);
455     }
456  
457  
458     //this method is responsible for taking all fee, if takeFee is true
459     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee) private {
460  
461         valuesFromGetValues memory s = _getValues(tAmount, takeFee);
462  
463         if (_isExcluded[sender] ) {  //from excluded
464                 _tOwned[sender] = _tOwned[sender]-tAmount;
465         }
466         if (_isExcluded[recipient]) { //to excluded
467                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
468         }
469  
470         _rOwned[sender] = _rOwned[sender]-s.rAmount;
471         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
472  
473         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
474         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
475             _takeLiquidity(s.rLiquidity,s.tLiquidity);
476         }
477         if(s.rDev > 0 || s.tDev > 0){
478             _takeDev(s.rDev, s.tDev);
479         }
480         if(s.rBurn > 0 || s.tBurn > 0){
481             _takeBurn(s.rBurn, s.tBurn);
482             emit Transfer(sender, deadAddress, s.tBurn);
483         }
484  
485         emit Transfer(sender, recipient, s.tTransferAmount);
486         emit Transfer(sender, address(this), s.tLiquidity + s.tDev);
487  
488     }
489  
490     function swapAndLiquify(uint256 tokens) private lockTheSwap{
491        // Split the contract balance into halves
492         uint256 denominator = (taxes.liquidity + taxes.dev ) * 2;
493         uint256 tokensToAddLiquidityWith = tokens * taxes.liquidity / denominator;
494         uint256 toSwap = tokens - tokensToAddLiquidityWith;
495  
496         uint256 initialBalance = address(this).balance;
497  
498         swapTokensForETH(toSwap);
499  
500         uint256 deltaBalance = address(this).balance - initialBalance;
501         uint256 unitBalance= deltaBalance / (denominator - taxes.liquidity);
502         uint256 ethToAddLiquidityWith = unitBalance * taxes.liquidity;
503  
504         if(ethToAddLiquidityWith > 0){
505             // Add liquidity to Uniswap
506             addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
507         }
508  
509         uint256 devAmt = unitBalance * 2 * taxes.dev;
510         if(devAmt > 0){
511             payable(devAddress).transfer(devAmt);
512         }
513  
514     }
515  
516     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
517         // approve token transfer to cover all possible scenarios
518         _approve(address(this), address(router), tokenAmount);
519  
520         // add the liquidity
521         router.addLiquidityETH{value: ethAmount}(
522             address(this),
523             tokenAmount,
524             0, // slippage is unavoidable
525             0, // slippage is unavoidable
526             owner(),
527             block.timestamp
528         );
529     }
530  
531     function swapTokensForETH(uint256 tokenAmount) private {
532         // generate the uniswap pair path of token -> weth
533         address[] memory path = new address[](2);
534         path[0] = address(this);
535         path[1] = router.WETH();
536  
537         _approve(address(this), address(router), tokenAmount);
538  
539         // make the swap
540         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
541             tokenAmount,
542             0, // accept any amount of ETH
543             path,
544             address(this),
545             block.timestamp
546         );
547     }
548  
549     function updatedevWallet(address newWallet) external onlyOwner{
550         require(devAddress != newWallet ,'Wallet already set');
551         devAddress = newWallet;
552         _isExcludedFromFee[devAddress];
553     }
554  
555     function updatMaxTxAmt(uint256 amount) external onlyOwner{
556         maxTxAmount = amount * 10**_decimals;
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
567     function updateCoolDownSettings(bool _enabled, uint256 _timeInSeconds) external onlyOwner{
568         coolDownEnabled = _enabled;
569         coolDownTime = _timeInSeconds * 1 seconds;
570     }
571  
572     function setAntibot(address account, bool state) external onlyOwner{
573         require(_isBot[account] != state, 'Value already set');
574         _isBot[account] = state;
575     }
576  
577     function bulkAntiBot(address[] memory accounts, bool state) external onlyOwner{
578         for(uint256 i = 0; i < accounts.length; i++){
579             _isBot[accounts[i]] = state;
580         }
581     }
582  
583     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
584         router = IRouter(newRouter);
585         pair = newPair;
586     }
587  
588     function isBot(address account) public view returns(bool){
589         return _isBot[account];
590     }
591  
592  
593     //Use this in case  ETH are sent to the contract by mistake
594     function rescueETH(uint256 weiAmount) external onlyOwner{
595         require(address(this).balance >= weiAmount, "insufficient ETH balance");
596         payable(msg.sender).transfer(weiAmount);
597     }
598  
599     // Function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
600     // Owner cannot transfer out catecoin from this smart contract
601     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
602         IERC20(_tokenAddr).transfer(_to, _amount);
603     }
604  
605     receive() external payable{
606     }
607 }