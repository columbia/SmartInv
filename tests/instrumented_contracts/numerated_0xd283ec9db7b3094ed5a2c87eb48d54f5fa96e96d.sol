1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-12
3 */
4 
5 // SPDX-License-Identifier: NOLICENSE
6 pragma solidity ^0.8.14;
7 
8 interface IERC20 {
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
99 contract Fmoney is Context, IERC20, Ownable {
100 
101     mapping (address => uint256) private _rOwned;
102     mapping (address => uint256) private _tOwned;
103     mapping (address => mapping (address => uint256)) private _allowances;
104     mapping (address => bool) private _isExcludedFromFee;
105     mapping (address => bool) private _isExcluded;
106     mapping (address => bool) private _isBot;
107 
108     address[] private _excluded;
109     
110     bool public swapEnabled;
111     bool private swapping;
112 
113     IRouter public router;
114     address public pair;
115 
116     uint8 private constant _decimals = 9;
117     uint256 private constant MAX = ~uint256(0);
118 
119     uint256 private _tTotal = 10e9 * 10**_decimals;
120     uint256 private _rTotal = (MAX - (MAX % _tTotal));
121 
122     
123     uint256 public swapTokensAtAmount = 5_000_000 * 10**_decimals;
124     uint256 public maxTxAmount = 5_000_000 * 10**_decimals;
125     bool private maxTxAmountFilterEnabled = true;
126     
127     // Anti Dump //
128     mapping (address => uint256) public _lastTrade;
129     bool private coolDownEnabled = true;
130     uint256 public coolDownTime = 10 seconds;
131 
132     address public treasuryAddress = 0x6cd8B2464779C8F18EC2d5576C43266d4bEE197e;
133     address public megaPoolAddress = 0x45B5AA9BB3041e69f125841E451372805f34A69D;
134     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
135     address public lpRecipient = 0x8b49089bd60B69D111FbA4cE2DaEc92316631d86;
136 
137     string private constant _name = "FMONEY TOKEN";
138     string private constant _symbol = "FMON";
139 
140     struct Taxes {
141       uint256 rfi;
142       uint256 treasury;
143       uint256 megaPool;
144       uint256 burn;
145       uint256 liquidity;
146     }
147 
148     Taxes public taxes = Taxes(10,10,10,0,0);
149 
150     struct TotFeesPaidStruct{
151         uint256 rfi;
152         uint256 treasury;
153         uint256 megaPool;
154         uint256 burn;
155         uint256 liquidity;
156     }
157     TotFeesPaidStruct public totFeesPaid;
158 
159     struct valuesFromGetValues{
160       uint256 rAmount;
161       uint256 rTransferAmount;
162       uint256 rRfi;
163       uint256 rTreasury;
164       uint256 rMegaPool;
165       uint256 rBurn;
166       uint256 rLiquidity;
167       uint256 tTransferAmount;
168       uint256 tRfi;
169       uint256 tTreasury;
170       uint256 tMegaPool;
171       uint256 tBurn;
172       uint256 tLiquidity;
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
193 
194         _rOwned[owner()] = _rTotal;
195         _isExcludedFromFee[owner()] = true;
196         _isExcludedFromFee[address(this)] = true;
197         _isExcludedFromFee[treasuryAddress]=true;
198         _isExcludedFromFee[burnAddress] = true;
199         _isExcludedFromFee[megaPoolAddress] = true;
200         _isExcludedFromFee[lpRecipient] = true;
201 
202         emit Transfer(address(0), owner(), _tTotal);
203     }
204 
205     function name() public pure returns (string memory) {
206         return _name;
207     }
208     function symbol() public pure returns (string memory) {
209         return _symbol;
210     }
211     function decimals() public pure returns (uint8) {
212         return _decimals;
213     }
214 
215     function totalSupply() public view override returns (uint256) {
216         return _tTotal;
217     }
218 
219     function balanceOf(address account) public view override returns (uint256) {
220         if (_isExcluded[account]) return _tOwned[account];
221         return tokenFromReflection(_rOwned[account]);
222     }
223 
224     function transfer(address recipient, uint256 amount) public override returns (bool) {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     function allowance(address owner, address spender) public view override returns (uint256) {
230         return _allowances[owner][spender];
231     }
232 
233     function approve(address spender, uint256 amount) public override returns (bool) {
234         _approve(_msgSender(), spender, amount);
235         return true;
236     }
237 
238     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
239         _transfer(sender, recipient, amount);
240 
241         uint256 currentAllowance = _allowances[sender][_msgSender()];
242         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
243         _approve(sender, _msgSender(), currentAllowance - amount);
244 
245         return true;
246     }
247 
248     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
249         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
250         return true;
251     }
252 
253     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
254         uint256 currentAllowance = _allowances[_msgSender()][spender];
255         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
256         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
257 
258         return true;
259     }
260 
261     function isExcludedFromReward(address account) public view returns (bool) {
262         return _isExcluded[account];
263     }
264 
265     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
266         require(tAmount <= _tTotal, "Amount must be less than supply");
267         if (!deductTransferRfi) {
268             valuesFromGetValues memory s = _getValues(tAmount, true);
269             return s.rAmount;
270         } else {
271             valuesFromGetValues memory s = _getValues(tAmount, true);
272             return s.rTransferAmount;
273         }
274     }
275 
276     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
277         require(rAmount <= _rTotal, "Amount must be less than total reflections");
278         uint256 currentRate =  _getRate();
279         return rAmount/currentRate;
280     }
281 
282     function excludeFromReward(address account) public onlyOwner() {
283         require(!_isExcluded[account], "Account is already excluded");
284         if(_rOwned[account] > 0) {
285             _tOwned[account] = tokenFromReflection(_rOwned[account]);
286         }
287         _isExcluded[account] = true;
288         _excluded.push(account);
289     }
290 
291     function includeInReward(address account) external onlyOwner() {
292         require(_isExcluded[account], "Account is not excluded");
293         require(_excluded.length <= 2000, "Excluded accounts array is too big, please consider to review it");
294         for (uint256 i = 0; i < _excluded.length; i++) {
295             if (_excluded[i] == account) {
296                 _excluded[i] = _excluded[_excluded.length - 1];
297                 _tOwned[account] = 0;
298                 _isExcluded[account] = false;
299                 _excluded.pop();
300                 break;
301             }
302         }
303     }
304 
305 
306     function excludeFromFee(address account) public onlyOwner {
307         _isExcludedFromFee[account] = true;
308     }
309 
310     function includeInFee(address account) public onlyOwner {
311         _isExcludedFromFee[account] = false;
312     }
313 
314 
315     function isExcludedFromFee(address account) public view returns(bool) {
316         return _isExcludedFromFee[account];
317     }
318 
319     function setTaxes(uint256 _rfi, uint256 _treasury, uint256 _megaPool, uint256 _burn, uint256 _liquidity) public onlyOwner {
320         taxes.rfi = _rfi;
321         taxes.treasury = _treasury;
322         taxes.megaPool = _megaPool;
323         taxes.burn = _burn;
324         taxes.liquidity = _liquidity;
325         emit FeesChanged();
326     }
327 
328 
329     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
330         _rTotal -=rRfi;
331         totFeesPaid.rfi +=tRfi;
332     }
333 
334     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
335         totFeesPaid.liquidity +=tLiquidity;
336         if(_isExcluded[address(this)]) _tOwned[address(this)]+=tLiquidity;
337         _rOwned[address(this)] +=rLiquidity;
338     }
339 
340     function _takeTreasury(uint256 rTreasury, uint256 tTreasury) private {
341         totFeesPaid.treasury +=tTreasury;
342         if(_isExcluded[treasuryAddress]) _tOwned[treasuryAddress]+=tTreasury;
343         _rOwned[treasuryAddress] +=rTreasury;
344     }
345     
346     function _takeMegaPool(uint256 rMegaPool, uint256 tMegaPool) private{
347         totFeesPaid.megaPool +=tMegaPool;
348         if(_isExcluded[megaPoolAddress]) _tOwned[megaPoolAddress]+=tMegaPool;
349         _rOwned[megaPoolAddress] +=rMegaPool;
350     }
351 
352     function _takeBurn(uint256 rBurn, uint256 tBurn) private{
353         totFeesPaid.burn +=tBurn;
354         if(_isExcluded[burnAddress])_tOwned[burnAddress]+=tBurn;
355         _rOwned[burnAddress] +=rBurn;
356     }
357 
358     function _getValues(uint256 tAmount, bool takeFee) private view returns (valuesFromGetValues memory to_return) {
359         to_return = _getTValues(tAmount, takeFee);
360         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rTreasury,to_return.rMegaPool, to_return.rBurn, to_return.rLiquidity) = _getRValues(to_return, tAmount, takeFee, _getRate());
361         return to_return;
362     }
363 
364     function _getTValues(uint256 tAmount, bool takeFee) private view returns (valuesFromGetValues memory s) {
365 
366         if(!takeFee) {
367           s.tTransferAmount = tAmount;
368           return s;
369         }
370         
371         s.tRfi = tAmount*taxes.rfi/1000;
372         s.tTreasury = tAmount*taxes.treasury/1000;
373         s.tMegaPool = tAmount*taxes.megaPool/1000;
374         s.tBurn = tAmount*taxes.burn/1000;
375         s.tLiquidity = tAmount*taxes.liquidity/1000;
376         s.tTransferAmount = tAmount-s.tRfi-s.tTreasury-s.tLiquidity-s.tMegaPool-s.tBurn;
377         return s;
378     }
379 
380     function _getRValues(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rTreasury,uint256 rMegaPool,uint256 rBurn,uint256 rLiquidity) {
381         rAmount = tAmount*currentRate;
382 
383         if(!takeFee) {
384           return(rAmount, rAmount, 0,0,0,0,0);
385         }
386 
387         rRfi = s.tRfi*currentRate;
388         rTreasury = s.tTreasury*currentRate;
389         rLiquidity = s.tLiquidity*currentRate;
390         rMegaPool = s.tMegaPool*currentRate;
391         rBurn = s.tBurn*currentRate;
392         rTransferAmount =  rAmount-rRfi-rTreasury-rLiquidity-rMegaPool-rBurn;
393         return (rAmount, rTransferAmount, rRfi,rTreasury,rMegaPool,rBurn,rLiquidity);
394     }
395 
396     function _getRate() private view returns(uint256) {
397         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
398         return rSupply/tSupply;
399     }
400 
401     function _getCurrentSupply() private view returns(uint256, uint256) {
402         require(_excluded.length <= 2000, "Excluded accounts array is too big, please consider to review it");
403         uint256 rSupply = _rTotal;
404         uint256 tSupply = _tTotal;
405         for (uint256 i = 0; i < _excluded.length; i++) {
406             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
407             rSupply = rSupply-_rOwned[_excluded[i]];
408             tSupply = tSupply-_tOwned[_excluded[i]];
409         }
410         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
411         return (rSupply, tSupply);
412     }
413 
414     function _approve(address owner, address spender, uint256 amount) private {
415         require(owner != address(0), "ERC20: approve from the zero address");
416         require(spender != address(0), "ERC20: approve to the zero address");
417         _allowances[owner][spender] = amount;
418         emit Approval(owner, spender, amount);
419     }
420 
421 
422     function _transfer(address from, address to, uint256 amount) private {
423         require(from != address(0), "ERC20: transfer from the zero address");
424         require(to != address(0), "ERC20: transfer to the zero address");
425         require(amount > 0, "Transfer amount must be greater than zero");
426         // require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
427         require(!_isBot[from] && !_isBot[to], "You are a bot");
428 
429         if((!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && !swapping) || maxTxAmountFilterEnabled){
430             require(amount <= maxTxAmount ,"Amount is exceeding maxTxAmount");
431             // _handleCoolDownFilter(from, to);
432             if(from != pair && coolDownEnabled){
433                 uint256 timePassed = block.timestamp - _lastTrade[from];
434                 require(timePassed > coolDownTime, "You must wait coolDownTime");
435                 _lastTrade[from] = block.timestamp;
436             }
437             
438             if(to != pair && coolDownEnabled){
439                 uint256 timePassed2 = block.timestamp - _lastTrade[to];
440                 require(timePassed2 > coolDownTime, "You must wait coolDownTime");
441                 _lastTrade[to] = block.timestamp;
442             }
443         }
444 
445         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
446         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
447             swapAndLiquify(swapTokensAtAmount);
448         }
449 
450         _tokenTransfer(from, to, amount, !(_isExcludedFromFee[from] || _isExcludedFromFee[to]));
451     }
452 
453     //this method is responsible for taking all fee, if takeFee is true
454     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee) private {
455 
456         valuesFromGetValues memory s = _getValues(tAmount, takeFee);
457 
458         if (_isExcluded[sender] ) {  //from excluded
459                 _tOwned[sender] = _tOwned[sender]-tAmount;
460         }
461         if (_isExcluded[recipient]) { //to excluded
462                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
463         }
464 
465         _rOwned[sender] = _rOwned[sender]-s.rAmount;
466         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
467         
468         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
469 
470         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
471             _takeLiquidity(s.rLiquidity,s.tLiquidity);
472             emit Transfer(sender, address(this), s.tLiquidity);
473         }
474         if(s.rTreasury > 0 || s.tTreasury > 0){
475             _takeTreasury(s.rTreasury, s.tTreasury);
476             emit Transfer(sender, treasuryAddress, s.tTreasury);
477         }
478         if(s.rMegaPool > 0 || s.tMegaPool > 0){
479             _takeMegaPool(s.rMegaPool, s.tMegaPool);
480             emit Transfer(sender, megaPoolAddress, s.tMegaPool);
481         }
482         if(s.rBurn > 0 || s.tBurn > 0){
483             _takeBurn(s.rBurn, s.tBurn);
484             emit Transfer(sender, burnAddress, s.tBurn);
485         }
486         
487         emit Transfer(sender, recipient, s.tTransferAmount);
488     }
489 
490     function swapAndLiquify(uint256 tokens) private lockTheSwap{
491        // Split the contract balance into halves
492         uint256 tokensToAddLiquidityWith = tokens / 2;
493         uint256 toSwap = tokens - tokensToAddLiquidityWith;
494 
495         uint256 initialBalance = address(this).balance;
496         swapTokensForETH(toSwap);
497         uint256 ETHToAddLiquidityWith = address(this).balance - initialBalance;
498 
499         if(ETHToAddLiquidityWith > 0){
500             // Add liquidity to pancake
501             addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith);
502         }
503 
504     }
505 
506     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
507         // approve token transfer to cover all possible scenarios
508         _approve(address(this), address(router), tokenAmount);
509 
510         // add the liquidity
511         router.addLiquidityETH{value: ETHAmount}(
512             address(this),
513             tokenAmount,
514             0, // slippage is unavoidable
515             0, // slippage is unavoidable
516             lpRecipient,
517             block.timestamp
518         );
519     }
520 
521     function swapTokensForETH(uint256 tokenAmount) private {
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
539     function updateTreasuryWallet(address newWallet) external onlyOwner{
540         require(treasuryAddress != newWallet ,'Wallet already set');
541         treasuryAddress = newWallet;
542         _isExcludedFromFee[treasuryAddress];
543     }
544 
545     function updateBurnWallet(address newWallet) external onlyOwner{
546         require(burnAddress != newWallet ,'Wallet already set');
547         burnAddress = newWallet;
548         _isExcludedFromFee[burnAddress];
549     }
550 
551     function updateMegaPoolWallet(address newWallet) external onlyOwner{
552         require(megaPoolAddress != newWallet ,'Wallet already set');
553         megaPoolAddress = newWallet;
554         _isExcludedFromFee[megaPoolAddress];
555     }
556 
557     function updateLPRecipient(address newWallet) external onlyOwner{
558         require(lpRecipient != newWallet ,'Wallet already set');
559         lpRecipient = newWallet;
560         _isExcludedFromFee[lpRecipient];
561     }
562 
563     function updateMaxTxAmt(uint256 amount) external onlyOwner{
564         maxTxAmount = amount * 10**_decimals;
565     }
566 
567     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
568         swapTokensAtAmount = amount * 10**_decimals;
569     }
570 
571     function updateMaxTxAmountFilterEnabled(bool _enabled) external onlyOwner{
572         maxTxAmountFilterEnabled = _enabled;
573     }
574 
575     function updateSwapEnabled(bool _enabled) external onlyOwner{
576         swapEnabled = _enabled;
577     }
578 
579     function updateCoolDownSettings(bool _enabled, uint256 _timeInSeconds) external onlyOwner{
580         coolDownEnabled = _enabled;
581         coolDownTime = _timeInSeconds * 1 seconds;
582     }
583 
584     function setAntibot(address account, bool state) external onlyOwner{
585         require(_isBot[account] != state, 'Value already set');
586         _isBot[account] = state;
587     }
588     
589     function bulkAntiBot(address[] memory accounts, bool state) external onlyOwner{
590         require(accounts.length <= 10, "This bulk only accept a length of 10 accounts");
591         for(uint256 i = 0; i < accounts.length; i++){
592             _isBot[accounts[i]] = state;
593         }
594     }
595     
596     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
597         router = IRouter(newRouter);
598         pair = newPair;
599     }
600     
601     function isBot(address account) public view returns(bool){
602         return _isBot[account];
603     }
604 
605     function getLiquidityProtectionData() public view onlyOwner returns(bool _maxTxAmountFilterEnabled, bool _coolDownEnabled){
606         return (maxTxAmountFilterEnabled, coolDownEnabled);
607     }
608     
609     function airdropTokens(address[] memory recipients, uint256[] memory amounts) external onlyOwner {
610         require(recipients.length <= 100, "This bulk only accept a length of 100 recipients");
611         require(recipients.length == amounts.length,"Invalid size");
612         address sender = msg.sender;
613         for(uint256 i; i < recipients.length; i++) {
614             if (_isExcluded[recipients[i]] == false) {
615                 address recipient = recipients[i];
616                 uint256 rAmount = amounts[i] * _getRate();
617                 _rOwned[sender] = _rOwned[sender] - rAmount;
618                 _rOwned[recipient] = _rOwned[recipient] + rAmount;
619                 emit Transfer(sender, recipient, amounts[i]);
620             }
621         }
622     }
623 
624     //Use this in case ETH are sent to the contract by mistake
625     function rescueETH(uint256 weiAmount) external onlyOwner{
626         require(address(this).balance >= weiAmount, "insufficient ETH balance");
627         payable(owner()).transfer(weiAmount);
628     }
629     
630     // Function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
631     // Owner cannot transfer out catecoin from this smart contract
632     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
633         IERC20(_tokenAddr).transfer(_to, _amount);
634     }
635 
636     receive() external payable{
637     }
638 }