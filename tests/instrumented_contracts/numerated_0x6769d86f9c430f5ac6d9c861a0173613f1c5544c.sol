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
95 contract KoaCombat is Context, IERC20, Ownable {
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
106     bool public swapEnabled;
107     bool private swapping;
108 
109     IRouter public router;
110     address public pair;
111 
112     uint8 private constant _decimals = 9;
113     uint256 private constant MAX = ~uint256(0);
114 
115     uint256 private _tTotal = 5e16 * 10**_decimals;
116     uint256 private _rTotal = (MAX - (MAX % _tTotal));
117 
118     
119     uint256 public swapTokensAtAmount = 500_000_000_000 * 10**_decimals;
120     uint256 public maxTxAmount = 5_000_000_000_000 * 10**_decimals;
121     
122     // Anti Dump //
123     mapping (address => uint256) public _lastTrade;
124     bool public coolDownEnabled = true;
125     uint256 public coolDownTime = 40 seconds;
126 
127     address public treasuryAddress = 0x1Fe48cF88CBad1BE2876215801B5Bb57d4941198;
128     address public charityAddress = 0xe88Eeae06aa59bd5e77aF4dB01404C591110893D;
129     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
130     address public lpRecipient = 0x87C699fe2dD97A8282F6CC4A32Fe517F57f42056;
131 
132 
133     string private constant _name = "KoaCombat";
134     string private constant _symbol = "KoaCombat";
135 
136 
137     struct Taxes {
138       uint256 rfi;
139       uint256 treasury;
140       uint256 charity;
141       uint256 burn;
142       uint256 liquidity;
143     }
144 
145     Taxes public taxes = Taxes(25,25,20,10,20);
146 
147     struct TotFeesPaidStruct{
148         uint256 rfi;
149         uint256 treasury;
150         uint256 charity;
151         uint256 burn;
152         uint256 liquidity;
153     }
154     TotFeesPaidStruct public totFeesPaid;
155 
156     struct valuesFromGetValues{
157       uint256 rAmount;
158       uint256 rTransferAmount;
159       uint256 rRfi;
160       uint256 rTreasury;
161       uint256 rCharity;
162       uint256 rBurn;
163       uint256 rLiquidity;
164       uint256 tTransferAmount;
165       uint256 tRfi;
166       uint256 tTreasury;
167       uint256 tCharity;
168       uint256 tBurn;
169       uint256 tLiquidity;
170     }
171 
172     event FeesChanged();
173     event UpdatedRouter(address oldRouter, address newRouter);
174 
175     modifier lockTheSwap {
176         swapping = true;
177         _;
178         swapping = false;
179     }
180 
181     constructor (address routerAddress) {
182         IRouter _router = IRouter(routerAddress);
183         address _pair = IFactory(_router.factory())
184             .createPair(address(this), _router.WETH());
185 
186         router = _router;
187         pair = _pair;
188         
189         excludeFromReward(pair);
190 
191         _rOwned[owner()] = _rTotal;
192         _isExcludedFromFee[owner()] = true;
193         _isExcludedFromFee[address(this)] = true;
194         _isExcludedFromFee[treasuryAddress]=true;
195         _isExcludedFromFee[burnAddress] = true;
196         _isExcludedFromFee[charityAddress] = true;
197         _isExcludedFromFee[lpRecipient] = true;
198 
199         emit Transfer(address(0), owner(), _tTotal);
200     }
201 
202     function name() public pure returns (string memory) {
203         return _name;
204     }
205     function symbol() public pure returns (string memory) {
206         return _symbol;
207     }
208     function decimals() public pure returns (uint8) {
209         return _decimals;
210     }
211 
212     function totalSupply() public view override returns (uint256) {
213         return _tTotal;
214     }
215 
216     function balanceOf(address account) public view override returns (uint256) {
217         if (_isExcluded[account]) return _tOwned[account];
218         return tokenFromReflection(_rOwned[account]);
219     }
220 
221     function transfer(address recipient, uint256 amount) public override returns (bool) {
222         _transfer(_msgSender(), recipient, amount);
223         return true;
224     }
225 
226     function allowance(address owner, address spender) public view override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     function approve(address spender, uint256 amount) public override returns (bool) {
231         _approve(_msgSender(), spender, amount);
232         return true;
233     }
234 
235     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
236         _transfer(sender, recipient, amount);
237 
238         uint256 currentAllowance = _allowances[sender][_msgSender()];
239         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
240         _approve(sender, _msgSender(), currentAllowance - amount);
241 
242         return true;
243     }
244 
245     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
246         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
247         return true;
248     }
249 
250     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
251         uint256 currentAllowance = _allowances[_msgSender()][spender];
252         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
253         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
254 
255         return true;
256     }
257 
258     function isExcludedFromReward(address account) public view returns (bool) {
259         return _isExcluded[account];
260     }
261 
262     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
263         require(tAmount <= _tTotal, "Amount must be less than supply");
264         if (!deductTransferRfi) {
265             valuesFromGetValues memory s = _getValues(tAmount, true);
266             return s.rAmount;
267         } else {
268             valuesFromGetValues memory s = _getValues(tAmount, true);
269             return s.rTransferAmount;
270         }
271     }
272 
273     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
274         require(rAmount <= _rTotal, "Amount must be less than total reflections");
275         uint256 currentRate =  _getRate();
276         return rAmount/currentRate;
277     }
278 
279     function excludeFromReward(address account) public onlyOwner() {
280         require(!_isExcluded[account], "Account is already excluded");
281         if(_rOwned[account] > 0) {
282             _tOwned[account] = tokenFromReflection(_rOwned[account]);
283         }
284         _isExcluded[account] = true;
285         _excluded.push(account);
286     }
287 
288     function includeInReward(address account) external onlyOwner() {
289         require(_isExcluded[account], "Account is not excluded");
290         for (uint256 i = 0; i < _excluded.length; i++) {
291             if (_excluded[i] == account) {
292                 _excluded[i] = _excluded[_excluded.length - 1];
293                 _tOwned[account] = 0;
294                 _isExcluded[account] = false;
295                 _excluded.pop();
296                 break;
297             }
298         }
299     }
300 
301 
302     function excludeFromFee(address account) public onlyOwner {
303         _isExcludedFromFee[account] = true;
304     }
305 
306     function includeInFee(address account) public onlyOwner {
307         _isExcludedFromFee[account] = false;
308     }
309 
310 
311     function isExcludedFromFee(address account) public view returns(bool) {
312         return _isExcludedFromFee[account];
313     }
314 
315     function setTaxes(uint256 _rfi, uint256 _treasury, uint256 _charity, uint256 _burn, uint256 _liquidity) public onlyOwner {
316         taxes.rfi = _rfi;
317         taxes.treasury = _treasury;
318         taxes.charity = _charity;
319         taxes.burn = _burn;
320         taxes.liquidity = _liquidity;
321         emit FeesChanged();
322     }
323 
324 
325     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
326         _rTotal -=rRfi;
327         totFeesPaid.rfi +=tRfi;
328     }
329 
330     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
331         totFeesPaid.liquidity +=tLiquidity;
332         if(_isExcluded[address(this)]) _tOwned[address(this)]+=tLiquidity;
333         _rOwned[address(this)] +=rLiquidity;
334     }
335 
336     function _takeTreasury(uint256 rTreasury, uint256 tTreasury) private {
337         totFeesPaid.treasury +=tTreasury;
338         if(_isExcluded[treasuryAddress]) _tOwned[treasuryAddress]+=tTreasury;
339         _rOwned[treasuryAddress] +=rTreasury;
340     }
341     
342     function _takeCharity(uint256 rCharity, uint256 tCharity) private{
343         totFeesPaid.charity +=tCharity;
344         if(_isExcluded[charityAddress]) _tOwned[charityAddress]+=tCharity;
345         _rOwned[charityAddress] +=rCharity;
346     }
347 
348     function _takeBurn(uint256 rBurn, uint256 tBurn) private{
349         totFeesPaid.burn +=tBurn;
350         if(_isExcluded[charityAddress])_tOwned[burnAddress]+=tBurn;
351         _rOwned[burnAddress] +=rBurn;
352     }
353 
354     function _getValues(uint256 tAmount, bool takeFee) private view returns (valuesFromGetValues memory to_return) {
355         to_return = _getTValues(tAmount, takeFee);
356         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rTreasury,to_return.rCharity, to_return.rBurn, to_return.rLiquidity) = _getRValues(to_return, tAmount, takeFee, _getRate());
357         return to_return;
358     }
359 
360     function _getTValues(uint256 tAmount, bool takeFee) private view returns (valuesFromGetValues memory s) {
361 
362         if(!takeFee) {
363           s.tTransferAmount = tAmount;
364           return s;
365         }
366         
367         s.tRfi = tAmount*taxes.rfi/1000;
368         s.tTreasury = tAmount*taxes.treasury/1000;
369         s.tCharity = tAmount*taxes.charity/1000;
370         s.tBurn = tAmount*taxes.burn/1000;
371         s.tLiquidity = tAmount*taxes.liquidity/1000;
372         s.tTransferAmount = tAmount-s.tRfi-s.tTreasury-s.tLiquidity-s.tCharity-s.tBurn;
373         return s;
374     }
375 
376     function _getRValues(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rTreasury,uint256 rCharity,uint256 rBurn,uint256 rLiquidity) {
377         rAmount = tAmount*currentRate;
378 
379         if(!takeFee) {
380           return(rAmount, rAmount, 0,0,0,0,0);
381         }
382 
383         rRfi = s.tRfi*currentRate;
384         rTreasury = s.tTreasury*currentRate;
385         rLiquidity = s.tLiquidity*currentRate;
386         rCharity = s.tCharity*currentRate;
387         rBurn = s.tBurn*currentRate;
388         rTransferAmount =  rAmount-rRfi-rTreasury-rLiquidity-rCharity-rBurn;
389         return (rAmount, rTransferAmount, rRfi,rTreasury,rCharity,rBurn,rLiquidity);
390     }
391 
392     function _getRate() private view returns(uint256) {
393         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
394         return rSupply/tSupply;
395     }
396 
397     function _getCurrentSupply() private view returns(uint256, uint256) {
398         uint256 rSupply = _rTotal;
399         uint256 tSupply = _tTotal;
400         for (uint256 i = 0; i < _excluded.length; i++) {
401             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
402             rSupply = rSupply-_rOwned[_excluded[i]];
403             tSupply = tSupply-_tOwned[_excluded[i]];
404         }
405         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
406         return (rSupply, tSupply);
407     }
408 
409     function _approve(address owner, address spender, uint256 amount) private {
410         require(owner != address(0), "ERC20: approve from the zero address");
411         require(spender != address(0), "ERC20: approve to the zero address");
412         _allowances[owner][spender] = amount;
413         emit Approval(owner, spender, amount);
414     }
415 
416 
417     function _transfer(address from, address to, uint256 amount) private {
418         require(from != address(0), "ERC20: transfer from the zero address");
419         require(to != address(0), "ERC20: transfer to the zero address");
420         require(amount > 0, "Transfer amount must be greater than zero");
421         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
422         require(!_isBot[from] && !_isBot[to], "You are a bot");
423         
424 
425         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && !swapping){
426             require(amount <= maxTxAmount ,"Amount is exceeding maxTxAmount");
427 
428             if(from != pair && coolDownEnabled){
429                 uint256 timePassed = block.timestamp - _lastTrade[from];
430                 require(timePassed > coolDownTime, "You must wait coolDownTime");
431                 _lastTrade[from] = block.timestamp;
432             }
433             if(to != pair && coolDownEnabled){
434                 uint256 timePassed2 = block.timestamp - _lastTrade[to];
435                 require(timePassed2 > coolDownTime, "You must wait coolDownTime");
436                 _lastTrade[to] = block.timestamp;
437             }
438         }
439         
440         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
441         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
442             swapAndLiquify(swapTokensAtAmount);
443         }
444 
445         _tokenTransfer(from, to, amount, !(_isExcludedFromFee[from] || _isExcludedFromFee[to]));
446     }
447 
448 
449     //this method is responsible for taking all fee, if takeFee is true
450     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee) private {
451 
452         valuesFromGetValues memory s = _getValues(tAmount, takeFee);
453 
454         if (_isExcluded[sender] ) {  //from excluded
455                 _tOwned[sender] = _tOwned[sender]-tAmount;
456         }
457         if (_isExcluded[recipient]) { //to excluded
458                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
459         }
460 
461         _rOwned[sender] = _rOwned[sender]-s.rAmount;
462         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
463         
464         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
465         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
466             _takeLiquidity(s.rLiquidity,s.tLiquidity);
467         }
468         if(s.rTreasury > 0 || s.tTreasury > 0){
469             _takeTreasury(s.rTreasury, s.tTreasury);
470             emit Transfer(sender, treasuryAddress, s.tCharity);
471         }
472         if(s.rCharity > 0 || s.tCharity > 0){
473             _takeCharity(s.rCharity, s.tCharity);
474             emit Transfer(sender, charityAddress, s.tCharity);
475         }
476         if(s.rBurn > 0 || s.tBurn > 0){
477             _takeBurn(s.rBurn, s.tBurn);
478             emit Transfer(sender, burnAddress, s.tBurn);
479         }
480         
481         emit Transfer(sender, recipient, s.tTransferAmount);
482         emit Transfer(sender, address(this), s.tLiquidity);
483         
484     }
485 
486     function swapAndLiquify(uint256 tokens) private lockTheSwap{
487        // Split the contract balance into halves
488         uint256 tokensToAddLiquidityWith = tokens / 2;
489         uint256 toSwap = tokens - tokensToAddLiquidityWith;
490 
491         uint256 initialBalance = address(this).balance;
492         swapTokensForETH(toSwap);
493         uint256 ETHToAddLiquidityWith = address(this).balance - initialBalance;
494 
495         if(ETHToAddLiquidityWith > 0){
496             // Add liquidity to pancake
497             addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith);
498         }
499 
500     }
501 
502     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
503         // approve token transfer to cover all possible scenarios
504         _approve(address(this), address(router), tokenAmount);
505 
506         // add the liquidity
507         router.addLiquidityETH{value: ETHAmount}(
508             address(this),
509             tokenAmount,
510             0, // slippage is unavoidable
511             0, // slippage is unavoidable
512             lpRecipient,
513             block.timestamp
514         );
515     }
516 
517     function swapTokensForETH(uint256 tokenAmount) private {
518         // generate the uniswap pair path of token -> weth
519         address[] memory path = new address[](2);
520         path[0] = address(this);
521         path[1] = router.WETH();
522 
523         _approve(address(this), address(router), tokenAmount);
524 
525         // make the swap
526         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
527             tokenAmount,
528             0, // accept any amount of ETH
529             path,
530             address(this),
531             block.timestamp
532         );
533     }
534 
535     function updateTreasuryWallet(address newWallet) external onlyOwner{
536         require(treasuryAddress != newWallet ,'Wallet already set');
537         treasuryAddress = newWallet;
538         _isExcludedFromFee[treasuryAddress];
539     }
540 
541     function updateBurnWallet(address newWallet) external onlyOwner{
542         require(burnAddress != newWallet ,'Wallet already set');
543         burnAddress = newWallet;
544         _isExcludedFromFee[burnAddress];
545     }
546 
547     function updateCharityWallet(address newWallet) external onlyOwner{
548         require(charityAddress != newWallet ,'Wallet already set');
549         charityAddress = newWallet;
550         _isExcludedFromFee[charityAddress];
551     }
552 
553     function updateLPRecipient(address newWallet) external onlyOwner{
554         require(lpRecipient != newWallet ,'Wallet already set');
555         lpRecipient = newWallet;
556         _isExcludedFromFee[lpRecipient];
557     }
558 
559     function updatMaxTxAmt(uint256 amount) external onlyOwner{
560         maxTxAmount = amount * 10**_decimals;
561     }
562 
563     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
564         swapTokensAtAmount = amount * 10**_decimals;
565     }
566 
567     function updateSwapEnabled(bool _enabled) external onlyOwner{
568         swapEnabled = _enabled;
569     }
570 
571     function updateCoolDownSettings(bool _enabled, uint256 _timeInSeconds) external onlyOwner{
572         coolDownEnabled = _enabled;
573         coolDownTime = _timeInSeconds * 1 seconds;
574     }
575 
576     function setAntibot(address account, bool state) external onlyOwner{
577         require(_isBot[account] != state, 'Value already set');
578         _isBot[account] = state;
579     }
580     
581     function bulkAntiBot(address[] memory accounts, bool state) external onlyOwner{
582         for(uint256 i = 0; i < accounts.length; i++){
583             _isBot[accounts[i]] = state;
584         }
585     }
586     
587     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
588         router = IRouter(newRouter);
589         pair = newPair;
590     }
591     
592     function isBot(address account) public view returns(bool){
593         return _isBot[account];
594     }
595     
596     function airdropTokens(address[] memory recipients, uint256[] memory amounts) external onlyOwner{
597          require(recipients.length == amounts.length,"Invalid size");
598          address sender = msg.sender;
599          for(uint256 i; i<recipients.length; i++){
600             address recipient = recipients[i];
601             uint256 rAmount = amounts[i]*_getRate();
602             _rOwned[sender] = _rOwned[sender]- rAmount;
603             _rOwned[recipient] = _rOwned[recipient] + rAmount;
604             emit Transfer(sender, recipient, amounts[i]);
605          }
606     }
607 
608     //Use this in case ETH are sent to the contract by mistake
609     function rescueETH(uint256 weiAmount) external onlyOwner{
610         require(address(this).balance >= weiAmount, "insufficient ETH balance");
611         payable(owner()).transfer(weiAmount);
612     }
613     
614     // Function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
615     // Owner cannot transfer out catecoin from this smart contract
616     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
617         IERC20(_tokenAddr).transfer(_to, _amount);
618     }
619 
620     receive() external payable{
621     }
622 }