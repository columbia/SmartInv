1 /**
2  * SPDX-License-Identifier: MIT
3  */
4 pragma solidity ^0.8.4;
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 interface IERC20Metadata is IERC20 {
17     function name() external view returns (string memory);
18     function symbol() external view returns (string memory);
19     function decimals() external view returns (uint8);
20 }
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {return msg.sender;}
23     function _msgData() internal view virtual returns (bytes calldata) {this; return msg.data;}
24 }
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
30     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         unchecked { require(b <= a, errorMessage); return a - b; }
33     }
34 }
35 library Address {
36     function isContract(address account) internal view returns (bool) { uint256 size; assembly { size := extcodesize(account) } return size > 0;}
37     function sendValue(address payable recipient, uint256 amount) internal {
38         require(address(this).balance >= amount, "Address: insufficient balance");(bool success, ) = recipient.call{ value: amount }("");
39         require(success, "Address: unable to send value, recipient may have reverted");
40     }
41     function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
42     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}
43     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}
44     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
45         require(address(this).balance >= value, "Address: insufficient balance for call");
46         require(isContract(target), "Address: call to non-contract");
47         (bool success, bytes memory returndata) = target.call{ value: value }(data);
48         return _verifyCallResult(success, returndata, errorMessage);
49     }
50     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
51         return functionStaticCall(target, data, "Address: low-level static call failed");
52     }
53     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
54         require(isContract(target), "Address: static call to non-contract");
55         (bool success, bytes memory returndata) = target.staticcall(data);
56         return _verifyCallResult(success, returndata, errorMessage);
57     }
58     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
59         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
60     }
61     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
62         require(isContract(target), "Address: delegate call to non-contract");
63         (bool success, bytes memory returndata) = target.delegatecall(data);
64         return _verifyCallResult(success, returndata, errorMessage);
65     }
66     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
67         if (success) { return returndata; } else {
68             if (returndata.length > 0) {
69                 assembly {
70                     let returndata_size := mload(returndata)
71                     revert(add(32, returndata), returndata_size)
72                 }
73             } else {revert(errorMessage);}
74         }
75     }
76 }
77 abstract contract Ownable is Context {
78     address private _owner;
79     address private _previousOwner;
80     uint256 private _lockTime;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87     function owner() public view returns (address) {
88         return _owner;
89     }
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         emit OwnershipTransferred(_owner, newOwner);
101         _owner = newOwner;
102     }
103     function getUnlockTime() public view returns (uint256) {
104         return _lockTime;
105     }
106     function lock(uint256 time) public virtual onlyOwner {
107         _previousOwner = _owner;
108         _owner = address(0);
109         _lockTime = block.timestamp + time;
110         emit OwnershipTransferred(_owner, address(0));
111     }
112     function unlock() public virtual {
113         require(_previousOwner == msg.sender, "Only the previous owner can unlock onwership");
114         require(block.timestamp > _lockTime , "The contract is still locked");
115         emit OwnershipTransferred(_owner, _previousOwner);
116         _owner = _previousOwner;
117     }
118 }
119 abstract contract Manageable is Context {
120     address private _manager;
121     event ManagementTransferred(address indexed previousManager, address indexed newManager);
122     constructor(){
123         address msgSender = _msgSender();
124         _manager = msgSender;
125         emit ManagementTransferred(address(0), msgSender);
126     }
127     function manager() public view returns(address){ return _manager; }
128     modifier onlyManager(){
129         require(_manager == _msgSender(), "Manageable: caller is not the manager");
130         _;
131     }
132     function transferManagement(address newManager) external virtual onlyManager {
133         emit ManagementTransferred(_manager, newManager);
134         _manager = newManager;
135     }
136 }
137 interface IUniswapV2Factory {
138     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
139     function createPair(address tokenA, address tokenB) external returns (address pair);
140 }
141 interface IUniswapV2Router {
142     function factory() external pure returns (address);
143     function WETH() external pure returns (address);
144     function addLiquidityETH(
145         address token,
146         uint amountTokenDesired,
147         uint amountTokenMin,
148         uint amountETHMin,
149         address to,
150         uint deadline
151     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
152     function swapExactTokensForETHSupportingFeeOnTransferTokens(
153         uint amountIn,
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external;
159 }
160 /**
161  * Tokenomics:
162  * 
163  * Redistribution    2%
164  * Burn             14%
165  * Dev/Marketing     4%
166  */
167 
168 abstract contract Tokenomics {
169     
170     using SafeMath for uint256;
171     
172     string internal constant NAME = "CRYPTO PHOENIX";
173     string internal constant SYMBOL = "$CPHX";
174     
175     uint16 internal constant FEES_DIVISOR = 10**3;
176     uint8 internal constant DECIMALS = 18;
177     uint256 internal constant ZEROES = 10**DECIMALS;
178     
179     uint256 private constant MAX = ~uint256(0);
180     uint256 internal constant TOTAL_SUPPLY = 1000000000000000 * ZEROES;
181     uint256 internal _reflectedSupply = (MAX - (MAX % TOTAL_SUPPLY));
182 
183     uint256 internal constant maxTransactionAmount = TOTAL_SUPPLY / 40; // 2.5% of the total supply
184     
185     uint256 internal constant maxWalletBalance = TOTAL_SUPPLY / 20; // 5% of the total supply
186 
187     address internal dev1Address = 0x75d9ea6fAfdBEdB2Ce00B76622Aa0DF1B68CaaF6; 
188     address internal dev2Address = 0x35EF633803aE3918f37571AF741bC39Ad11e3Eaa; 
189     address internal dev3Address = 0xfdAF289C815701d2b1b7b34340af584A9fABD2D8;
190     address internal dev4Address = 0x641E8274ce7513e2df215FcAD97515165019C497; 
191 
192     address internal burnAddress = 0x0000000000000000000000000000000000000000;
193 
194     enum FeeType { Antiwhale, Burn, Rfi, External, ExternalToETH }
195     struct Fee {
196         FeeType name;
197         uint256 value;
198         address recipient;
199         uint256 total;
200     }
201 
202     Fee[] internal fees;
203     uint256 internal sumOfFees;
204 
205     constructor() {
206         _addFees();
207     }
208 
209     function _addFee(FeeType name, uint256 value, address recipient) private {
210         fees.push( Fee(name, value, recipient, 0 ) );
211         sumOfFees += value;
212     }
213 
214     function _addFees() private {
215 
216         _addFee(FeeType.Rfi, 20, address(this) ); 
217 
218         _addFee(FeeType.Burn, 160, burnAddress );
219         _addFee(FeeType.External, 10, dev1Address );
220         _addFee(FeeType.External, 10, dev2Address );
221         _addFee(FeeType.External, 10, dev3Address );
222         _addFee(FeeType.External, 10, dev4Address );
223 
224     }
225 
226     function _getFeesCount() internal view returns (uint256){ return fees.length; }
227 
228     function _getFeeStruct(uint256 index) private view returns(Fee storage){
229         require( index >= 0 && index < fees.length, "FeesSettings._getFeeStruct: Fee index out of bounds");
230         return fees[index];
231     }
232     function _getFee(uint256 index) internal view returns (FeeType, uint256, address, uint256){
233         Fee memory fee = _getFeeStruct(index);
234         return ( fee.name, fee.value, fee.recipient, fee.total );
235     }
236     function _addFeeCollectedAmount(uint256 index, uint256 amount) internal {
237         Fee storage fee = _getFeeStruct(index);
238         fee.total = fee.total.add(amount);
239     }
240 
241     function getCollectedFeeTotal(uint256 index) internal view returns (uint256){
242         Fee memory fee = _getFeeStruct(index);
243         return fee.total;
244     }
245 }
246 
247 abstract contract Presaleable is Manageable {
248     bool internal isInPresale;
249     function setPreseableEnabled(bool value) external onlyManager {
250         isInPresale = value;
251     }
252 }
253 
254 abstract contract BaseRfiToken is IERC20, IERC20Metadata, Ownable, Presaleable, Tokenomics {
255 
256     using SafeMath for uint256;
257     using Address for address;
258 
259     mapping (address => uint256) internal _reflectedBalances;
260     mapping (address => uint256) internal _balances;
261     mapping (address => mapping (address => uint256)) internal _allowances;
262     
263     mapping (address => bool) internal _isExcludedFromFee;
264     mapping (address => bool) internal _isExcludedFromRewards;
265     address[] private _excluded;
266     constructor(){
267         
268         _reflectedBalances[owner()] = _reflectedSupply;
269         
270         _isExcludedFromFee[owner()] = true;
271         _isExcludedFromFee[address(this)] = true;
272         
273         _exclude(owner());
274         _exclude(address(this));
275 
276         emit Transfer(address(0), owner(), TOTAL_SUPPLY);
277         
278     }
279     
280         function name() external pure override returns (string memory) { return NAME; }
281         function symbol() external pure override returns (string memory) { return SYMBOL; }
282         function decimals() external pure override returns (uint8) { return DECIMALS; }
283         
284         function totalSupply() external pure override returns (uint256) {
285             return TOTAL_SUPPLY;
286         }
287         
288         function balanceOf(address account) public view override returns (uint256){
289             if (_isExcludedFromRewards[account]) return _balances[account];
290             return tokenFromReflection(_reflectedBalances[account]);
291         }
292         
293         function transfer(address recipient, uint256 amount) external override returns (bool){
294             _transfer(_msgSender(), recipient, amount);
295             return true;
296         }
297         
298         function allowance(address owner, address spender) external view override returns (uint256){
299             return _allowances[owner][spender];
300         }
301     
302         function approve(address spender, uint256 amount) external override returns (bool) {
303             _approve(_msgSender(), spender, amount);
304             return true;
305         }
306         
307         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool){
308             _transfer(sender, recipient, amount);
309             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
310             return true;
311         }
312 
313     function burn(uint256 amount) external {
314 
315         address sender = _msgSender();
316         require(sender != address(0), "BaseRfiToken: burn from the zero address");
317         require(sender != address(burnAddress), "BaseRfiToken: burn from the burn address");
318 
319         uint256 balance = balanceOf(sender);
320         require(balance >= amount, "BaseRfiToken: burn amount exceeds balance");
321 
322         uint256 reflectedAmount = amount.mul(_getCurrentRate());
323 
324         _reflectedBalances[sender] = _reflectedBalances[sender].sub(reflectedAmount);
325         if (_isExcludedFromRewards[sender])
326             _balances[sender] = _balances[sender].sub(amount);
327 
328         _burnTokens( sender, amount, reflectedAmount );
329     }
330     
331     function _burnTokens(address sender, uint256 tBurn, uint256 rBurn) internal {
332 
333         _reflectedBalances[burnAddress] = _reflectedBalances[burnAddress].add(rBurn);
334         if (_isExcludedFromRewards[burnAddress])
335             _balances[burnAddress] = _balances[burnAddress].add(tBurn);
336 
337         emit Transfer(sender, burnAddress, tBurn);
338     }
339 
340     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
341         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
342         return true;
343     }
344     
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
347         return true;
348     }
349     
350     function isExcludedFromReward(address account) external view returns (bool) {
351         return _isExcludedFromRewards[account];
352     }
353 
354     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
355         require(tAmount <= TOTAL_SUPPLY, "Amount must be less than supply");
356         if (!deductTransferFee) {
357             (uint256 rAmount,,,,) = _getValues(tAmount,0);
358             return rAmount;
359         } else {
360             (,uint256 rTransferAmount,,,) = _getValues(tAmount,_getSumOfFees(_msgSender(), tAmount));
361             return rTransferAmount;
362         }
363     }
364 
365     function tokenFromReflection(uint256 rAmount) internal view returns(uint256) {
366         require(rAmount <= _reflectedSupply, "Amount must be less than total reflections");
367         uint256 currentRate = _getCurrentRate();
368         return rAmount.div(currentRate);
369     }
370     
371     function excludeFromReward(address account) external onlyOwner() {
372         require(!_isExcludedFromRewards[account], "Account is not included");
373         _exclude(account);
374     }
375     
376     function _exclude(address account) internal {
377         if(_reflectedBalances[account] > 0) {
378             _balances[account] = tokenFromReflection(_reflectedBalances[account]);
379         }
380         _isExcludedFromRewards[account] = true;
381         _excluded.push(account);
382     }
383 
384     function includeInReward(address account) external onlyOwner() {
385         require(_isExcludedFromRewards[account], "Account is not excluded");
386         for (uint256 i = 0; i < _excluded.length; i++) {
387             if (_excluded[i] == account) {
388                 _excluded[i] = _excluded[_excluded.length - 1];
389                 _balances[account] = 0;
390                 _isExcludedFromRewards[account] = false;
391                 _excluded.pop();
392                 break;
393             }
394         }
395     }
396     
397     function setExcludedFromFee(address account, bool value) external onlyOwner { _isExcludedFromFee[account] = value; }
398     function isExcludedFromFee(address account) public view returns(bool) { return _isExcludedFromFee[account]; }
399     
400     function _approve(address owner, address spender, uint256 amount) internal {
401         require(owner != address(0), "BaseRfiToken: approve from the zero address");
402         require(spender != address(0), "BaseRfiToken: approve to the zero address");
403 
404         _allowances[owner][spender] = amount;
405         emit Approval(owner, spender, amount);
406     }
407     
408     function _isUnlimitedSender(address account) internal view returns(bool){
409         return (account == owner());
410     }
411 
412     function _isUnlimitedRecipient(address account) internal view returns(bool){
413         return (account == owner() || account == burnAddress);
414     }
415 
416     function _transfer(address sender, address recipient, uint256 amount) private {
417 
418         require(sender != address(0), "BaseRfiToken: transfer from the zero address");
419         require(recipient != address(0), "BaseRfiToken: transfer to the zero address");
420         require(sender != address(burnAddress), "BaseRfiToken: transfer from the burn address");
421         require(amount > 0, "Transfer amount must be greater than zero");
422         
423         bool takeFee = true;
424 
425         if ( isInPresale ){ takeFee = false; }
426         else {
427 
428             if ( amount > maxTransactionAmount && !_isUnlimitedSender(sender) && !_isUnlimitedRecipient(recipient) ){
429                 revert("Transfer amount exceeds the maxTxAmount.");
430             }
431 
432             if ( maxWalletBalance > 0 && !_isUnlimitedSender(sender) && !_isUnlimitedRecipient(recipient) && !_isV2Pair(recipient) ){
433                 uint256 recipientBalance = balanceOf(recipient);
434                 require(recipientBalance + amount <= maxWalletBalance, "New balance would exceed the maxWalletBalance");
435             }
436         }
437 
438         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){ takeFee = false; }
439 
440         _transferTokens(sender, recipient, amount, takeFee);
441         
442     }
443 
444     function _transferTokens(address sender, address recipient, uint256 amount, bool takeFee) private {
445     
446         uint256 sumOfFees = _getSumOfFees(sender, amount);
447         if ( !takeFee ){ sumOfFees = 0; }
448         
449         (uint256 rAmount, uint256 rTransferAmount, uint256 tAmount, uint256 tTransferAmount, uint256 currentRate ) = _getValues(amount, sumOfFees);
450         
451         _reflectedBalances[sender] = _reflectedBalances[sender].sub(rAmount);
452         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rTransferAmount);
453 
454         if (_isExcludedFromRewards[sender]){ _balances[sender] = _balances[sender].sub(tAmount); }
455         if (_isExcludedFromRewards[recipient] ){ _balances[recipient] = _balances[recipient].add(tTransferAmount); }
456         
457         _takeFees( amount, currentRate, sumOfFees );
458         emit Transfer(sender, recipient, tTransferAmount);
459     }
460     
461     function _takeFees(uint256 amount, uint256 currentRate, uint256 sumOfFees ) private {
462         if ( sumOfFees > 0 && !isInPresale ){
463             _takeTransactionFees(amount, currentRate);
464         }
465     }
466     
467     function _getValues(uint256 tAmount, uint256 feesSum) internal view returns (uint256, uint256, uint256, uint256, uint256) {
468         
469         uint256 tTotalFees = tAmount.mul(feesSum).div(FEES_DIVISOR);
470         uint256 tTransferAmount = tAmount.sub(tTotalFees);
471         uint256 currentRate = _getCurrentRate();
472         uint256 rAmount = tAmount.mul(currentRate);
473         uint256 rTotalFees = tTotalFees.mul(currentRate);
474         uint256 rTransferAmount = rAmount.sub(rTotalFees);
475         
476         return (rAmount, rTransferAmount, tAmount, tTransferAmount, currentRate);
477     }
478     
479     function _getCurrentRate() internal view returns(uint256) {
480         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
481         return rSupply.div(tSupply);
482     }
483     
484     function _getCurrentSupply() internal view returns(uint256, uint256) {
485         uint256 rSupply = _reflectedSupply;
486         uint256 tSupply = TOTAL_SUPPLY;  
487 
488         for (uint256 i = 0; i < _excluded.length; i++) {
489             if (_reflectedBalances[_excluded[i]] > rSupply || _balances[_excluded[i]] > tSupply) return (_reflectedSupply, TOTAL_SUPPLY);
490             rSupply = rSupply.sub(_reflectedBalances[_excluded[i]]);
491             tSupply = tSupply.sub(_balances[_excluded[i]]);
492         }
493         if (tSupply == 0 || rSupply < _reflectedSupply.div(TOTAL_SUPPLY)) return (_reflectedSupply, TOTAL_SUPPLY);
494         return (rSupply, tSupply);
495     }
496     
497     function _getSumOfFees(address sender, uint256 amount) internal view virtual returns (uint256);
498 
499     function _isV2Pair(address account) internal view virtual returns(bool);
500 
501     function _redistribute(uint256 amount, uint256 currentRate, uint256 fee, uint256 index) internal {
502         uint256 tFee = amount.mul(fee).div(FEES_DIVISOR);
503         uint256 rFee = tFee.mul(currentRate);
504 
505         _reflectedSupply = _reflectedSupply.sub(rFee);
506         _addFeeCollectedAmount(index, tFee);
507     }
508 
509     function _takeTransactionFees(uint256 amount, uint256 currentRate) internal virtual;
510 }
511 
512 abstract contract UniHelper is Ownable, Manageable {
513 
514     using SafeMath for uint256;
515 
516     uint256 private withdrawableBalance;
517 
518     enum Env {Testnet, MainnetV2, MainnetV3}
519     Env private _env;
520 
521     address private _mainnetRouterV2Address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
522 
523     IUniswapV2Router internal _router;
524     address internal _pair;
525 
526     uint256 private maxTransactionAmount;
527 
528     event RouterSet(address indexed router);
529 
530     receive() external payable {}
531 
532     function initializeRouterPair(Env env, uint256 maxTx) internal {
533         _env = env;
534         _setRouterAddress(_mainnetRouterV2Address);
535 
536         maxTransactionAmount = maxTx;
537     }
538 
539     function _setRouterAddress(address router) private {
540         IUniswapV2Router _newUniswapRouter = IUniswapV2Router(router);
541         _pair = IUniswapV2Factory(_newUniswapRouter.factory()).createPair(address(this), _newUniswapRouter.WETH());
542         _router = _newUniswapRouter;
543         emit RouterSet(router);
544     }
545 
546     function setRouterAddress(address router) external onlyManager() {
547         _setRouterAddress(router);
548     }
549 
550     function _approveDelegate(address owner, address spender, uint256 amount) internal virtual;
551 
552 }
553 
554 abstract contract Antiwhale is Tokenomics {
555 
556     function _getAntiwhaleFees(uint256, uint256) internal view returns (uint256){
557         return sumOfFees;
558     }
559 }
560 
561 abstract contract PhoenixAbstract is BaseRfiToken, UniHelper, Antiwhale {
562     
563     using SafeMath for uint256;
564 
565     constructor(Env _env){
566 
567         initializeRouterPair(_env, maxTransactionAmount);
568 
569         _exclude(_pair);
570         _exclude(burnAddress);
571     }
572     
573     function _isV2Pair(address account) internal view override returns(bool){
574         return (account == _pair);
575     }
576 
577     function _getSumOfFees(address sender, uint256 amount) internal view override returns (uint256){ 
578         return _getAntiwhaleFees(balanceOf(sender), amount); 
579     }
580     
581     function _takeTransactionFees(uint256 amount, uint256 currentRate) internal override {
582         
583         if( isInPresale ){ return; }
584 
585         uint256 feesCount = _getFeesCount();
586         for (uint256 index = 0; index < feesCount; index++ ){
587             (FeeType name, uint256 value, address recipient,) = _getFee(index);
588             if ( value == 0 ) continue;
589 
590             if ( name == FeeType.Rfi ){
591                 _redistribute( amount, currentRate, value, index );
592             }
593             else if ( name == FeeType.Burn ){
594                 _burn( amount, currentRate, value, index );
595             }
596             else {
597                 _takeFee( amount, currentRate, value, recipient, index );
598             }
599         }
600     }
601 
602     function _burn(uint256 amount, uint256 currentRate, uint256 fee, uint256 index) private {
603         uint256 tBurn = amount.mul(fee).div(FEES_DIVISOR);
604         uint256 rBurn = tBurn.mul(currentRate);
605 
606         _burnTokens(address(this), tBurn, rBurn);
607         _addFeeCollectedAmount(index, tBurn);
608     }
609 
610     function _takeFee(uint256 amount, uint256 currentRate, uint256 fee, address recipient, uint256 index) private {
611 
612         uint256 tAmount = amount.mul(fee).div(FEES_DIVISOR);
613         uint256 rAmount = tAmount.mul(currentRate);
614 
615         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rAmount);
616         if(_isExcludedFromRewards[recipient])
617             _balances[recipient] = _balances[recipient].add(tAmount);
618 
619         _addFeeCollectedAmount(index, tAmount);
620     }
621     
622     function _approveDelegate(address owner, address spender, uint256 amount) internal override {
623         _approve(owner, spender, amount);
624     }
625 }
626 
627 contract CRYPTOPHOENIX is PhoenixAbstract{
628 
629     constructor() PhoenixAbstract(Env.MainnetV2){
630         _approve(owner(),address(_router), ~uint256(0));
631     }
632 }