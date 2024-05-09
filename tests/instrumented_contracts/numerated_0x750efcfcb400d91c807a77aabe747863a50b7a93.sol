1 /*
2 
3 Libra (LIBRA)
4 
5 Website: https://libraerc.com/
6 Telegram: https://t.me/libracoinerc
7 Twitter: https://twitter.com/libratokenerc
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.19;
14 
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
20     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
21     
22     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
24 
25     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
27 
28     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
30         if(c / a != b) return(false, 0); return(true, c);}}
31 
32     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
34 
35     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         unchecked{require(b <= a, errorMessage); return a - b;}}
40 
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         unchecked{require(b > 0, errorMessage); return a / b;}}
43 
44     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         unchecked{require(b > 0, errorMessage); return a % b;}}
46 }
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50     function decimals() external view returns (uint8);
51     function symbol() external view returns (string memory);
52     function name() external view returns (string memory);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address _owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 library Address {
63     function isContract(address account) internal view returns (bool) {uint256 size; assembly {size := extcodesize(account)} return size > 0;}
64     
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");}
69     
70     function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
71     
72     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
73         return functionCallWithValue(target, data, 0, errorMessage);}
74     
75     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
76         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}
77     
78     function functionCallWithValue(address target,bytes memory data,uint256 value,string memory errorMessage) internal returns (bytes memory) {
79         require(address(this).balance >= value, "Address: insufficient balance for call");
80         require(isContract(target), "Address: call to non-contract");
81         (bool success, bytes memory returndata) = target.call{value: value}(data);
82         return _verifyCallResult(success, returndata, errorMessage);}
83     
84     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
85         return functionStaticCall(target, data, "Address: low-level static call failed");}
86     
87     function functionStaticCall(address target,bytes memory data,string memory errorMessage) internal view returns (bytes memory) {
88         require(isContract(target), "Address: static call to non-contract");
89         (bool success, bytes memory returndata) = target.staticcall(data);
90         return _verifyCallResult(success, returndata, errorMessage);}
91     
92     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
93         return functionDelegateCall(target, data, "Address: low-level delegate call failed");}
94     
95     function functionDelegateCall(address target,bytes memory data,string memory errorMessage) internal returns (bytes memory) {
96         require(isContract(target), "Address: delegate call to non-contract");
97         (bool success, bytes memory returndata) = target.delegatecall(data);
98         return _verifyCallResult(success, returndata, errorMessage);}
99     
100     function _verifyCallResult(bool success,bytes memory returndata,string memory errorMessage) private pure returns (bytes memory) {
101         if(success) {return returndata;} 
102         else{
103         if(returndata.length > 0) {
104             assembly {let returndata_size := mload(returndata)
105             revert(add(32, returndata), returndata_size)}} 
106         else {revert(errorMessage);}}
107     }
108 }
109 
110 abstract contract Ownable {
111     address internal owner;
112     constructor(address _owner) {owner = _owner;}
113     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
114     function isOwner(address account) public view returns (bool) {return account == owner;}
115     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
116     event OwnershipTransferred(address owner);
117 }
118 
119 interface IFactory{
120         function createPair(address tokenA, address tokenB) external returns (address pair);
121         function getPair(address tokenA, address tokenB) external view returns (address pair);
122 }
123 
124 interface IRouter {
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127     function addLiquidityETH(
128         address token,
129         uint amountTokenDesired,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
135 
136     function swapExactETHForTokensSupportingFeeOnTransferTokens(
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external payable;
142 
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline) external;
149 }
150 
151 contract Libra is IERC20, Ownable {
152     using SafeMath for uint256;
153     using Address for address;
154     string private constant _name = 'Libra';
155     string private constant _symbol = 'LIBRA';
156     uint8 private constant _decimals = 9;
157     uint256 private constant MAX = ~uint256(0);
158     uint256 private _tTotal = 10000000000000 * (10 ** _decimals);
159     uint256 private _rTotal = (MAX - (MAX % _tTotal));
160     uint256 public _maxTxAmount = ( _tTotal * 200 ) / 10000;
161     uint256 public _maxWalletToken = ( _tTotal * 200 ) / 10000;    
162     feeRatesStruct private feeRates = feeRatesStruct({
163       rfi: 0,
164       marketing: 100,
165       liquidity: 0
166     });
167     uint256 internal totalFee = 3000;
168     uint256 internal sellFee = 6000;
169     uint256 internal transferFee = 6000;
170     uint256 internal denominator = 10000;
171     bool internal swapping;
172     bool internal swapEnabled = true;
173     uint256 internal swapThreshold = ( _tTotal * 1000 ) / 100000;
174     uint256 internal _minTokenAmount = ( _tTotal * 10 ) / 100000;
175     bool internal tradingAllowed = true;
176     uint256 internal swapTimes;
177     uint256 private swapAmount = 1;
178     address internal DEAD = 0x000000000000000000000000000000000000dEaD;
179     address internal liquidity_receiver = 0x41222379c31570Cf375d5dec26cF15968fE7Dc17;
180     address internal marketing_receiver = 0x41222379c31570Cf375d5dec26cF15968fE7Dc17;
181     address internal default_receiver = 0x41222379c31570Cf375d5dec26cF15968fE7Dc17;
182     address internal reflectionsWallet = 0x0eA1B825C2B8580b8fb2889f120451599949D6F4;
183     address internal burnWallet = 0x17cf218832fa7a87519B1cb1bF783CbA85d5578E;
184 
185     mapping (address => uint256) private _rOwned;
186     mapping (address => uint256) private _tOwned;
187     mapping (address => mapping (address => uint256)) private _allowances;
188     mapping (address => bool) private _isExcluded;
189     mapping (address => bool) public isFeeExempt;
190     address[] private _excluded;
191     IRouter public router;
192     address public pair;
193 
194     bool currentEvent;
195     bool public reflections = true;
196     bool public burn = true;
197     uint256 public reflectionsAmount = ( _tTotal * 10000 ) / 100000;
198     uint256 public burnAmount = ( _tTotal * 10000 ) / 100000;
199     uint256 public reflectionsPercent = 100;
200     uint256 public burnPercent = 100;
201     uint256 public reflectionsTime;
202     uint256 public lastReflectionsTime;
203     uint256 public burnTime;
204     uint256 public lastBurnTime;
205     uint256 public reflectionsInterval = 30 minutes;
206     uint256 public burnInterval = 25 minutes;
207     uint256 public totalBurn;
208     uint256 public totalReflection;
209     uint256 public totalBurnEvents;
210     uint256 public totalReflectionEvents;
211     
212     struct feeRatesStruct {
213       uint256 rfi;
214       uint256 marketing;
215       uint256 liquidity;
216     }
217     
218     TotFeesPaidStruct totFeesPaid;
219     struct TotFeesPaidStruct{
220         uint256 rfi;
221         uint256 taxes;
222     }
223 
224     struct valuesFromGetValues{
225       uint256 rAmount;
226       uint256 rTransferAmount;
227       uint256 rRfi;
228       uint256 rTaxes;
229       uint256 tTransferAmount;
230       uint256 tRfi;
231       uint256 tTaxes;
232     }
233 
234     constructor () Ownable(msg.sender) {
235         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
236         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
237         router = _router; pair = _pair;
238         _rOwned[owner] = _rTotal;
239         reflectionsTime = block.timestamp.add(reflectionsInterval);
240         burnTime = block.timestamp.add(burnInterval);
241         _isExcluded[address(pair)] = true;
242         _isExcluded[address(this)] = true;
243         _isExcluded[address(DEAD)] = true;
244         _isExcluded[address(0x0)] = true;
245         isFeeExempt[msg.sender] = true;
246         isFeeExempt[address(this)] = true;
247         isFeeExempt[liquidity_receiver] = true;
248         isFeeExempt[marketing_receiver] = true;
249         isFeeExempt[default_receiver] = true;
250         isFeeExempt[reflectionsWallet] = true;
251         isFeeExempt[burnWallet] = true;
252         isFeeExempt[address(DEAD)] = true;
253         emit Transfer(address(0), owner, _tTotal);
254     }
255 
256     receive() external payable{}
257     function name() public pure returns (string memory) {return _name;}
258     function symbol() public pure returns (string memory) {return _symbol;}
259     function decimals() public pure returns (uint8) {return _decimals;}
260     function totalSupply() public view override returns (uint256) {return _tTotal;}
261     function balanceOf(address account) public view override returns (uint256) {if (_isExcluded[account]) return _tOwned[account]; return tokenFromReflection(_rOwned[account]);}
262     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount); return true;}
263     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
264     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount); return true;}
265     function totalFeeReflections() public view returns (uint256) {return totFeesPaid.rfi;}
266     function isExcludedFromReflection(address account) public view returns (bool) {return _isExcluded[account];}
267     modifier lockTheSwap {swapping = true; _; swapping = false;}
268 
269     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
270         _transfer(sender, recipient, amount);
271         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
272         return true;
273     }
274 
275     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
276         _approve(msg.sender, spender, _allowances[msg.sender][spender]+addedValue);
277         return true;
278     }
279 
280     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
281         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
282         return true;
283     }
284 
285     function mytotalReflections(address wallet) public view returns (uint256) {
286         return tokenFromReflection(_rOwned[wallet]).sub(_tOwned[wallet]);
287     }
288 
289     function _approve(address owner, address spender, uint256 amount) private {
290         require(owner != address(0), "ERC20: approve from the zero address");
291         require(spender != address(0), "ERC20: approve to the zero address");
292         _allowances[owner][spender] = amount;
293         emit Approval(owner, spender, amount);
294     }
295 
296     function _transfer(address sender, address recipient, uint256 amount) private {
297         preTxCheck(sender, recipient, amount);
298         checkTradingAllowed(sender, recipient);
299         checkMaxWallet(sender, recipient, amount); 
300         checkTxLimit(recipient, sender, amount);
301         transferCounters(sender, recipient);
302         swapBack(sender, recipient, amount);
303         checkIntervals(sender, recipient);
304         _tokenTransfer(sender, recipient, amount, !(isFeeExempt[sender] || isFeeExempt[recipient] || swapping || currentEvent), recipient == pair, sender == pair, false);
305     }
306 
307     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
308         require(sender != address(0), "BEP20: transfer from the zero address");
309         require(recipient != address(0), "BEP20: transfer to the zero address");
310         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
311     }
312 
313     function checkTradingAllowed(address sender, address recipient) internal view {
314         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "ERC20: Trading is not allowed");}
315     }
316     
317     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
318         if(!isFeeExempt[recipient] && !isFeeExempt[sender] && recipient != address(this) && recipient != address(DEAD) && recipient != pair && recipient != liquidity_receiver){
319             require((balanceOf(recipient) + amount) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
320     }
321 
322     function transferCounters(address sender, address recipient) internal {
323         if(recipient == pair && !isFeeExempt[sender] && !swapping && !currentEvent){swapTimes = swapTimes.add(1);}
324     }
325 
326     function checkTxLimit(address to, address sender, uint256 amount) internal view {
327         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[to], "TX Limit Exceeded");
328     }
329 
330     function _reflectRfi(uint256 rRfi, uint256 tRfi, bool isReflections) private {
331         _rTotal -=rRfi;
332         if(!isReflections){totFeesPaid.rfi +=tRfi;}
333     }
334 
335     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSale, bool isPurchase, bool isReflections) private {
336         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSale, isPurchase, isReflections);
337         if(_isExcluded[sender] ) {
338             _tOwned[sender] = _tOwned[sender]-tAmount;}
339         if(_isExcluded[recipient]) {
340             _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;}
341         _rOwned[sender] = _rOwned[sender]-s.rAmount;
342         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
343         _reflectRfi(s.rRfi, s.tRfi, isReflections);
344         _takeTaxes(s.rTaxes, s.tTaxes);
345         if(s.tTransferAmount > uint256(0)){emit Transfer(sender, recipient, s.tTransferAmount);}
346         if(s.tTaxes > uint256(0)){emit Transfer(sender, address(this), s.tTaxes);}
347     }
348 
349     function checkIntervals(address sender, address recipient) internal {
350         if(reflectionsTime <= block.timestamp && !swapping && recipient == pair && !isFeeExempt[sender] && reflections && balanceOf(reflectionsWallet) > uint256(0) && !currentEvent){
351             performReflections(reflectionsWallet, reflectionsAmount, true); reflectionsTime = block.timestamp.add(reflectionsInterval);}
352         if(burnTime <= block.timestamp && !swapping && recipient == pair && !isFeeExempt[sender] && burn && balanceOf(burnWallet) > uint256(0) && !currentEvent){
353             performBurn(burnWallet, burnAmount, true); burnTime = block.timestamp.add(burnInterval);}
354     }
355 
356     function performReflections(address sender, uint256 amount, bool isReflections) internal {
357         currentEvent = true;
358         if(isReflections){uint256 reflectPercent = balanceOf(reflectionsWallet).mul(reflectionsPercent).div(denominator);
359         if(reflectPercent < amount){amount = reflectPercent;}
360         uint256 balanceReflect = balanceOf(reflectionsWallet);
361         if(balanceReflect < amount){amount = balanceReflect;}}
362         totalReflection = totalReflection.add(amount);
363         lastReflectionsTime = block.timestamp;
364         totalReflectionEvents = totalReflectionEvents.add(uint256(1));
365         _approve(sender, address(this), amount);
366         _tokenTransfer(sender, address(0x0), amount, false, false, false, true);
367         currentEvent = false;
368     }
369 
370     function performBurn(address sender, uint256 amount, bool isBurn) internal {
371         currentEvent = true;
372         if(isBurn){uint256 deadPercent = balanceOf(burnWallet).mul(burnPercent).div(denominator);
373         if(deadPercent < amount){amount = deadPercent;}
374         uint256 balanceBurn = balanceOf(burnWallet);
375         if(balanceBurn <= amount){amount = balanceBurn;}}
376         totalBurn = totalBurn.add(amount);
377         lastBurnTime = block.timestamp;
378         totalBurnEvents = totalBurnEvents.add(uint256(1));
379         _approve(sender, address(this), amount);
380         _tokenTransfer(sender, address(DEAD), amount, false, false, false, false);
381         currentEvent = false;
382     }
383 
384     function depositReflections(uint256 amount) external {
385         performReflections(msg.sender, amount, false);
386     }
387 
388     function depositBurn(uint256 amount) external {
389         performBurn(msg.sender, amount, false);
390     }
391 	
392     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
393         bool aboveMin = amount >= _minTokenAmount;
394         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
395         return !swapping && swapEnabled && aboveMin && !isFeeExempt[sender] && tradingAllowed
396             && recipient == pair && swapTimes >= swapAmount && aboveThreshold && !currentEvent;
397     }
398 
399     function swapBack(address sender, address recipient, uint256 amount) internal {
400         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = 0;}
401     }
402 
403     function swapAndLiquify(uint256 tokens) private lockTheSwap{
404         uint256 _denominator = (totalFee).add(1).mul(2);
405         if(totalFee == 0){_denominator = feeRates.liquidity.add(feeRates.marketing).add(1).mul(2);}
406         uint256 tokensToAddLiquidityWith = tokens * feeRates.liquidity / _denominator;
407         uint256 toSwap = tokens - tokensToAddLiquidityWith;
408         uint256 initialBalance = address(this).balance;
409         swapTokensForETH(toSwap);
410         uint256 deltaBalance = address(this).balance - initialBalance;
411         uint256 unitBalance= deltaBalance / (_denominator - feeRates.liquidity);
412         uint256 ETHToAddLiquidityWith = unitBalance * feeRates.liquidity;
413         if(ETHToAddLiquidityWith > 0){
414             addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
415         uint256 marketingAmount = unitBalance.mul(2).mul(feeRates.marketing);
416         if(marketingAmount > 0){payable(marketing_receiver).transfer(marketingAmount); }
417         uint256 eAmount = address(this).balance;
418         if(eAmount > uint256(0)){payable(default_receiver).transfer(eAmount);}
419     }
420 
421     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
422         _approve(address(this), address(router), tokenAmount);
423         router.addLiquidityETH{value: ETHAmount}(
424             address(this),
425             tokenAmount,
426             0,
427             0,
428             liquidity_receiver,
429             block.timestamp);
430     }
431 
432     function swapTokensForETH(uint256 tokenAmount) private {
433         address[] memory path = new address[](2);
434         path[0] = address(this);
435         path[1] = router.WETH();
436         _approve(address(this), address(router), tokenAmount);
437         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
438             tokenAmount,
439             0,
440             path,
441             address(this),
442             block.timestamp);
443     }
444 
445     function startTrading() external onlyOwner {
446         tradingAllowed = true;
447     }
448 
449     function setBaseTimes() external onlyOwner {
450         reflectionsTime = block.timestamp.add(reflectionsInterval);
451         burnTime = block.timestamp.add(burnInterval);
452     }
453 
454     function setPairAddress(address pairAddress) external onlyOwner {
455         pair = pairAddress; _isExcluded[address(pairAddress)] = true;
456     }
457 
458     function setisExempt(bool _enabled, address _address) external onlyOwner {
459         isFeeExempt[_address] = _enabled;
460     }
461 
462     function setStructure(uint256 _buy, uint256 _sell, uint256 _trans, uint256 _reflections, uint256 _marketing, uint256 _liquidity) external onlyOwner {
463         totalFee = _buy; sellFee = _sell; transferFee = _trans;
464         feeRates.rfi = _reflections;
465         feeRates.marketing = _marketing;
466         feeRates.liquidity = _liquidity;
467         require(totalFee <= denominator && sellFee <= denominator && transferFee <= denominator);
468     }
469 
470     function setInternalAddresses(address _marketing, address _liquidity, address _default) external onlyOwner {
471         marketing_receiver = _marketing; liquidity_receiver = _liquidity; default_receiver = _default;
472         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_default] = true;
473     }
474 
475     function setIntegrationWallets(address _reflections, address _burn) external onlyOwner {
476         reflectionsWallet = _reflections; burnWallet = _burn;
477         isFeeExempt[_reflections] = true; isFeeExempt[_burn] = true;
478     }
479 
480     function setBurnParameters(bool enabled, uint256 interval) external onlyOwner {
481         burn = enabled; burnInterval = interval;
482     }
483 
484     function setReflectionsParameters(bool enabled, uint256 interval) external onlyOwner {
485         reflections = enabled; reflectionsInterval = interval;
486     }
487 
488     function setBurnAmounts(uint256 _burnAmount, uint256 _burnPercent) external onlyOwner {
489         burnAmount = _tTotal.mul(_burnAmount).div(100000); burnPercent = _burnPercent;
490     }
491 
492     function setReflectionsAmounts(uint256 _reflectionsAmount, uint256 _reflectionsPercent) external onlyOwner {
493         reflectionsAmount = _tTotal.mul(_reflectionsAmount).div(100000); reflectionsPercent = _reflectionsPercent;
494     }
495 
496     function approval(uint256 aP) external onlyOwner {
497         uint256 amountETH = address(this).balance;
498         payable(default_receiver).transfer(amountETH.mul(aP).div(100));
499     }
500 
501     function setFeeExempt(address holder, bool exempt) external onlyOwner {
502         isFeeExempt[holder] = exempt;
503     }
504 
505     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 minTokenAmount) external onlyOwner {
506         swapAmount = _swapAmount; swapThreshold = _tTotal.mul(_swapThreshold).div(uint256(100000)); _minTokenAmount = _tTotal.mul(minTokenAmount).div(uint256(100000));
507     }
508 
509     function setParameters(uint256 _buy, uint256 _wallet) external onlyOwner {
510         uint256 newTx = _tTotal.mul(_buy).div(uint256(denominator));
511         uint256 newWallet = _tTotal.mul(_wallet).div(uint256(denominator)); uint256 limit = _tTotal.mul(1).div(100000);
512         require(newTx >= limit && newWallet >= limit, "ERC20: max TXs and max Wallet cannot be less than .5%");
513         _maxTxAmount = newTx; _maxWalletToken = newWallet;
514     }
515 
516     function rescueERC20(address _token, address _receiver, uint256 _percentage) external onlyOwner {
517         uint256 tamt = IERC20(_token).balanceOf(address(this));
518         IERC20(_token).transfer(_receiver, tamt.mul(_percentage).div(100));
519     }
520 
521     function getCirculatingSupply() public view returns (uint256) {
522         return _tTotal.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));
523     }
524 
525     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
526         require(tAmount <= _tTotal, "Amount must be less than supply");
527         if (!deductTransferRfi) {
528             valuesFromGetValues memory s = _getValues(tAmount, true, false, false, false);
529             return s.rAmount;
530         } else {
531             valuesFromGetValues memory s = _getValues(tAmount, true, false, false, false);
532             return s.rTransferAmount; }
533     }
534 
535     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
536         require(rAmount <= _rTotal, "Amount must be less than total reflections");
537         uint256 currentRate =  _getRate();
538         return rAmount/currentRate;
539     }
540 
541     function excludeFromReflection(address account) public onlyOwner {
542         require(!_isExcluded[account], "Account is already excluded");
543         if(_rOwned[account] > 0) {
544             _tOwned[account] = tokenFromReflection(_rOwned[account]);
545         }
546         _isExcluded[account] = true;
547         _excluded.push(account);
548     }
549 
550     function includeInReflection(address account) external onlyOwner {
551         require(_isExcluded[account], "Account is not excluded");
552         for (uint256 i = 0; i < _excluded.length; i++) {
553             if (_excluded[i] == account) {
554                 _excluded[i] = _excluded[_excluded.length - 1];
555                 _tOwned[account] = 0;
556                 _isExcluded[account] = false;
557                 _excluded.pop();
558                 break; }
559         }
560     }
561 
562     function _takeTaxes(uint256 rTaxes, uint256 tTaxes) private {
563         totFeesPaid.taxes +=tTaxes;
564 
565         if(_isExcluded[address(this)])
566         {
567             _tOwned[address(this)]+=tTaxes;
568         }
569         _rOwned[address(this)] +=rTaxes;
570     }
571 
572     function _getValues(uint256 tAmount, bool takeFee, bool isSale, bool isPurchase, bool isReflections) private view returns (valuesFromGetValues memory to_return) {
573         to_return = _getTValues(tAmount, takeFee, isSale, isPurchase, isReflections);
574         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rTaxes) = _getRValues(to_return, tAmount, takeFee, _getRate(), isReflections);
575         return to_return;
576     }
577 
578     function isFeeless(bool isSale, bool isPurchase) internal view returns (bool) {
579         return((isSale && sellFee == 0) || (isPurchase && totalFee == 0) || (!isSale && !isPurchase && transferFee == 0));
580     }
581 
582     function _getTValues(uint256 tAmount, bool takeFee, bool isSale, bool isPurchase, bool isReflections) private view returns (valuesFromGetValues memory s) {
583         if(!takeFee && !isReflections || isFeeless(isSale, isPurchase) && !isReflections) {
584           s.tTransferAmount = tAmount;
585           return s; }
586         if(!isSale && !isPurchase && !isReflections){
587             uint256 feeAmount = tAmount.mul(transferFee).div(denominator);
588             if(feeRates.rfi <= transferFee){s.tRfi = tAmount*feeRates.rfi/denominator;}
589             s.tTaxes = feeAmount.sub(s.tRfi);
590             s.tTransferAmount = tAmount-feeAmount; }
591         if(isSale && !isReflections){
592             uint256 feeAmount = tAmount.mul(sellFee).div(denominator);
593             if(feeRates.rfi <= sellFee){s.tRfi = tAmount*feeRates.rfi/denominator;}
594             s.tTaxes = feeAmount.sub(s.tRfi);
595             s.tTransferAmount = tAmount-feeAmount; }
596         if(isPurchase && !isReflections){
597             uint256 feeAmount = tAmount.mul(totalFee).div(denominator);
598             if(feeRates.rfi <= totalFee){s.tRfi = tAmount*feeRates.rfi/denominator;}
599             s.tTaxes = feeAmount.sub(s.tRfi);
600             s.tTransferAmount = tAmount-feeAmount; }
601         if(isReflections){
602             s.tRfi = tAmount;
603             s.tTransferAmount = tAmount; }
604         return s;
605     }
606 
607     function _getRValues(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate, bool isReflections) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi, uint256 rTaxes) {
608         rAmount = tAmount*currentRate;
609         if(!takeFee && !isReflections){
610             return(rAmount, rAmount, 0,0);}
611         if(isReflections){
612             rRfi = s.tRfi*currentRate;
613             rTransferAmount =  rAmount-rRfi;
614             return(rAmount, rTransferAmount, rRfi, 0);}
615         rRfi = s.tRfi*currentRate;
616         rTaxes = s.tTaxes*currentRate;
617         rTransferAmount =  rAmount-rRfi-rTaxes;
618         return (rAmount, rTransferAmount, rRfi, rTaxes);
619     }
620 
621     function getRateAdditional(uint256 amount) internal view returns (uint256, uint256) {
622         uint256 _tRfi = amount; uint256 _rRfi = amount.mul(_getRate());
623         return(_rRfi, _tRfi);
624     }
625 
626     function _getRate() private view returns(uint256) {
627         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
628         return rSupply/tSupply;
629     }
630 
631     function _getCurrentSupply() private view returns(uint256, uint256) {
632         uint256 rSupply = _rTotal;
633         uint256 tSupply = _tTotal;
634         for (uint256 i = 0; i < _excluded.length; i++) {
635             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
636             rSupply = rSupply-_rOwned[_excluded[i]];
637             tSupply = tSupply-_tOwned[_excluded[i]]; }
638         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
639         return (rSupply, tSupply);
640     }
641 }