1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.12;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15  
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27 
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49 
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         return mod(a, b, "SafeMath: modulo by zero");
60     }
61 
62     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b != 0, errorMessage);
64         return a % b;
65     }
66 }
67 
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view virtual returns (bytes memory) {
74         this;
75         return msg.data;
76     }
77 }
78 
79 library Address {
80     function isContract(address account) internal view returns (bool) {
81         bytes32 codehash;
82         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
83         assembly { codehash := extcodehash(account) }
84         return (codehash != accountHash && codehash != 0x0);
85     }
86 
87     function sendValue(address payable recipient, uint256 amount) internal {
88         require(address(this).balance >= amount, "Address: insufficient balance");
89 
90         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
91         (bool success, ) = recipient.call{ value: amount }("");
92         require(success, "Address: unable to send value, recipient may have reverted");
93     }
94 
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96       return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
100         return _functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
108         require(address(this).balance >= value, "Address: insufficient balance for call");
109         return _functionCallWithValue(target, data, value, errorMessage);
110     }
111 
112     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
113         require(isContract(target), "Address: call to non-contract");
114 
115         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
116         if (success) {
117             return returndata;
118         } else {
119             if (returndata.length > 0) {
120                 assembly {
121                     let returndata_size := mload(returndata)
122                     revert(add(32, returndata), returndata_size)
123                 }
124             } else {
125                 revert(errorMessage);
126             }
127         }
128     }
129 }
130 
131 contract Ownable is Context {
132     address private _owner;
133     address private _previousOwner;
134     uint256 private _lockTime;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     constructor () {
139         address msgSender = _msgSender();
140         _owner = msgSender;
141         emit OwnershipTransferred(address(0), msgSender);
142     }
143 
144     function owner() public view returns (address) {
145         return _owner;
146     }
147 
148     modifier onlyOwner() {
149         require(_owner == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     function renounceOwnership() public virtual onlyOwner {
154         emit OwnershipTransferred(_owner, address(0));
155         _owner = address(0);
156     }
157 
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         emit OwnershipTransferred(_owner, newOwner);
161         _owner = newOwner;
162     }
163 
164     function geUnlockTime() public view returns (uint256) {
165         return _lockTime;
166     }
167 
168     function lock(uint256 time) public virtual onlyOwner {
169         _previousOwner = _owner;
170         _owner = address(0);
171         _lockTime = block.timestamp + time;
172         emit OwnershipTransferred(_owner, address(0));
173     }
174     
175     function unlock() public virtual {
176         require(_previousOwner == msg.sender, "You don't have permission to unlock");
177         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
178         emit OwnershipTransferred(_owner, _previousOwner);
179         _owner = _previousOwner;
180     }
181 }
182 
183 interface IUniswapV2Factory {
184     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
185     function feeTo() external view returns (address);
186     function feeToSetter() external view returns (address);
187     function getPair(address tokenA, address tokenB) external view returns (address pair);
188     function allPairs(uint) external view returns (address pair);
189     function allPairsLength() external view returns (uint);
190     function createPair(address tokenA, address tokenB) external returns (address pair);
191     function setFeeTo(address) external;
192     function setFeeToSetter(address) external;
193 }
194 
195 interface IUniswapV2Pair {
196     event Approval(address indexed owner, address indexed spender, uint value);
197     event Transfer(address indexed from, address indexed to, uint value);
198     function name() external pure returns (string memory);
199     function symbol() external pure returns (string memory);
200     function decimals() external pure returns (uint8);
201     function totalSupply() external view returns (uint);
202     function balanceOf(address owner) external view returns (uint);
203     function allowance(address owner, address spender) external view returns (uint);
204     function approve(address spender, uint value) external returns (bool);
205     function transfer(address to, uint value) external returns (bool);
206     function transferFrom(address from, address to, uint value) external returns (bool);
207     function DOMAIN_SEPARATOR() external view returns (bytes32);
208     function PERMIT_TYPEHASH() external pure returns (bytes32);
209     function nonces(address owner) external view returns (uint);
210     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
211     event Mint(address indexed sender, uint amount0, uint amount1);
212     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
213     event Swap(address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);
214     event Sync(uint112 reserve0, uint112 reserve1);
215     function MINIMUM_LIQUIDITY() external pure returns (uint);
216     function factory() external view returns (address);
217     function token0() external view returns (address);
218     function token1() external view returns (address);
219     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
220     function price0CumulativeLast() external view returns (uint);
221     function price1CumulativeLast() external view returns (uint);
222     function kLast() external view returns (uint);
223     function mint(address to) external returns (uint liquidity);
224     function burn(address to) external returns (uint amount0, uint amount1);
225     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
226     function skim(address to) external;
227     function sync() external;
228     function initialize(address, address) external;
229 }
230 
231 interface IUniswapV2Router01 {
232     function factory() external pure returns (address);
233     function WETH() external pure returns (address);
234     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
235     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
236     function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
237     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
238     function removeLiquidityWithPermit(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountA, uint amountB);
239     function removeLiquidityETHWithPermit(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountToken, uint amountETH);
240     function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
241     function swapTokensForExactTokens(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
242     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
243     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
244     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
245     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
246     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
247     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
248     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
249     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
250     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
251 }
252 
253 interface IUniswapV2Router02 is IUniswapV2Router01 {
254     function removeLiquidityETHSupportingFeeOnTransferTokens(
255         address token,
256         uint liquidity,
257         uint amountTokenMin,
258         uint amountETHMin,
259         address to,
260         uint deadline
261     ) external returns (uint amountETH);
262     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
263         address token,
264         uint liquidity,
265         uint amountTokenMin,
266         uint amountETHMin,
267         address to,
268         uint deadline,
269         bool approveMax, uint8 v, bytes32 r, bytes32 s
270     ) external returns (uint amountETH);
271 
272     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
273         uint amountIn,
274         uint amountOutMin,
275         address[] calldata path,
276         address to,
277         uint deadline
278     ) external;
279     function swapExactETHForTokensSupportingFeeOnTransferTokens(
280         uint amountOutMin,
281         address[] calldata path,
282         address to,
283         uint deadline
284     ) external payable;
285     function swapExactTokensForETHSupportingFeeOnTransferTokens(
286         uint amountIn,
287         uint amountOutMin,
288         address[] calldata path,
289         address to,
290         uint deadline
291     ) external;
292 }
293 
294 interface IAirdrop {
295     function airdrop(address recipient, uint256 amount) external;
296 }
297 
298 contract Doshi is Context, IERC20, Ownable {
299     using SafeMath for uint256;
300     using Address for address;
301     
302     IUniswapV2Router02 private immutable uniswapV2Router;
303 
304     mapping (address => uint) private cooldown;
305 
306     mapping (address => uint256) private _rOwned;
307     mapping (address => uint256) private _tOwned;
308 
309     mapping (address => bool) private _isExcludedFromFee;
310     mapping (address => bool) private _isExcluded;
311     mapping (address => bool) private botWallets;
312 
313     mapping (address => mapping (address => uint256)) private _allowances;
314 
315     address[] private _excluded;
316     
317     bool botscantrade = false;
318     bool private canTrade = false;
319     bool private inSwapAndLiquify;
320     bool private swapAndLiquifyEnabled = true;
321     bool private cooldownEnabled = true;
322 
323     uint8 private _decimals = 9;
324 
325     uint256 private constant MAX = ~uint256(0);
326     uint256 private _tTotal = 1e18 * 10**(_decimals);
327     uint256 private _rTotal = (MAX - (MAX % _tTotal));
328     uint256 private _tFeeTotal;
329     uint256 private _taxFee = 1;
330     uint256 private _previousTaxFee = _taxFee;
331     uint256 private marketingFeePercent = 73;
332     uint256 private developmentFeePercent = 10;
333     uint256 private _liquidityFee = 11;
334     uint256 private _previousLiquidityFee = _liquidityFee;
335     uint256 private _maxTxAmount = 5e15 * 10**(_decimals);
336     uint256 private _numTokensSellToAddToLiquidity = 3e14 * 10**(_decimals);
337     uint256 private _maxWalletSize = 2e16 * 10**(_decimals);
338     uint256 private tradingActiveBlock = 0;
339     uint256 private blocksToBlacklist = 10;
340 
341     string private _name = "Doshi";
342     string private _symbol = "DOSHI";
343 
344     address payable private marketingWallet;
345     address payable private developmentWallet;
346     address payable private liquidityWallet;
347     address private immutable uniswapV2Pair;
348     
349     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
350     event SwapAndLiquifyEnabledUpdated(bool enabled);
351     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
352     
353     modifier lockTheSwap {
354         inSwapAndLiquify = true;
355         _;
356         inSwapAndLiquify = false;
357     }
358     
359     constructor (address addr1, address addr2, address addr3) {
360         _rOwned[_msgSender()] = _rTotal;
361         
362         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
363 
364         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
365             .createPair(address(this), _uniswapV2Router.WETH());
366         
367         uniswapV2Router = _uniswapV2Router;
368 
369         marketingWallet = payable(addr1);
370         developmentWallet = payable(addr2);
371         liquidityWallet = payable(addr3);
372         
373         _isExcludedFromFee[owner()] = true;
374         _isExcludedFromFee[address(this)] = true;
375         _isExcludedFromFee[addr1] = true;
376         _isExcludedFromFee[addr2] = true;
377         _isExcludedFromFee[addr3] = true;
378         
379         emit Transfer(address(0), _msgSender(), _tTotal);
380     }
381 
382     function name() public view returns (string memory) {
383         return _name;
384     }
385 
386     function symbol() public view returns (string memory) {
387         return _symbol;
388     }
389 
390     function decimals() public view returns (uint8) {
391         return _decimals;
392     }
393 
394     function totalSupply() public view override returns (uint256) {
395         return _tTotal;
396     }
397 
398     function balanceOf(address account) public view override returns (uint256) {
399         if (_isExcluded[account]) return _tOwned[account];
400         return tokenFromReflection(_rOwned[account]);
401     }
402 
403     function transfer(address recipient, uint256 amount) public override returns (bool) {
404         _transfer(_msgSender(), recipient, amount);
405         return true;
406     }
407 
408     function allowance(address owner, address spender) public view override returns (uint256) {
409         return _allowances[owner][spender];
410     }
411 
412     function approve(address spender, uint256 amount) public override returns (bool) {
413         _approve(_msgSender(), spender, amount);
414         return true;
415     }
416 
417     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
418         _transfer(sender, recipient, amount);
419         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
420         return true;
421     }
422 
423     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
424         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
425         return true;
426     }
427 
428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
430         return true;
431     }
432 
433     function isExcludedFromReward(address account) public view returns (bool) {
434         return _isExcluded[account];
435     }
436 
437     function totalFees() public view returns (uint256) {
438         return _tFeeTotal;
439     }
440     
441     function airdrop(address recipient, uint256 amount) external onlyOwner() {
442         removeAllFee();
443         _transfer(_msgSender(), recipient, amount * 10**9);
444         restoreAllFee();
445     }
446     
447     function airdropInternal(address recipient, uint256 amount) internal {
448         removeAllFee();
449         _transfer(_msgSender(), recipient, amount);
450         restoreAllFee();
451     }
452     
453     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
454         uint256 iterator = 0;
455         require(newholders.length == amounts.length, "must be the same length");
456         while(iterator < newholders.length){
457             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
458             iterator += 1;
459         }
460     }
461 
462     function deliver(uint256 tAmount) public {
463         address sender = _msgSender();
464         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
465         (uint256 rAmount,,,,,) = _getValues(tAmount);
466         _rOwned[sender] = _rOwned[sender].sub(rAmount);
467         _rTotal = _rTotal.sub(rAmount);
468         _tFeeTotal = _tFeeTotal.add(tAmount);
469     }
470 
471     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
472         require(tAmount <= _tTotal, "Amount must be less than supply");
473         if (!deductTransferFee) {
474             (uint256 rAmount,,,,,) = _getValues(tAmount);
475             return rAmount;
476         } else {
477             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
478             return rTransferAmount;
479         }
480     }
481 
482     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
483         require(rAmount <= _rTotal, "Amount must be less than total reflections");
484         uint256 currentRate =  _getRate();
485         return rAmount.div(currentRate);
486     }
487 
488     function excludeFromReward(address account) public onlyOwner() {
489         require(!_isExcluded[account], "Account is already excluded");
490         if(_rOwned[account] > 0) {
491             _tOwned[account] = tokenFromReflection(_rOwned[account]);
492         }
493         _isExcluded[account] = true;
494         _excluded.push(account);
495     }
496 
497     function includeInReward(address account) external onlyOwner() {
498         require(_isExcluded[account], "Account is already excluded");
499         for (uint256 i = 0; i < _excluded.length; i++) {
500             if (_excluded[i] == account) {
501                 _excluded[i] = _excluded[_excluded.length - 1];
502                 _tOwned[account] = 0;
503                 _isExcluded[account] = false;
504                 _excluded.pop();
505                 break;
506             }
507         }
508     }
509     
510     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
511         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
512         _tOwned[sender] = _tOwned[sender].sub(tAmount);
513         _rOwned[sender] = _rOwned[sender].sub(rAmount);
514         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
515         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
516         _takeLiquidity(tLiquidity);
517         _reflectFee(rFee, tFee);
518         emit Transfer(sender, recipient, tTransferAmount);
519     }
520 
521     function setExcludedFromFees(address[] memory accounts, bool exempt) public onlyOwner {
522         for (uint i = 0; i < accounts.length; i++) {
523             _isExcludedFromFee[accounts[i]] = exempt;
524         }
525     }
526     
527     function setBots(address[] memory accounts, bool exempt) public onlyOwner {
528         for (uint i = 0; i < accounts.length; i++) {
529             botWallets[accounts[i]] = exempt;
530         }
531     }
532 
533     function setMarketingFeePercent(uint256 fee) public onlyOwner {
534         marketingFeePercent = fee;
535     }
536 
537     function setMarketingWallet(address walletAddress) public onlyOwner {
538         _isExcludedFromFee[marketingWallet] = false;
539         marketingWallet = payable(walletAddress);
540         _isExcludedFromFee[marketingWallet] = true;
541     }
542 
543     function setLiquidityWallet(address walletAddress) public onlyOwner {
544         _isExcludedFromFee[liquidityWallet] = false;
545         liquidityWallet = payable(walletAddress);
546         _isExcludedFromFee[liquidityWallet] = true;
547     }
548     
549     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
550         require(taxFee < 10, "Tax fee cannot be more than 10%");
551         _taxFee = taxFee;
552     }
553     
554     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
555         require(liquidityFee < 30, "Tax fee cannot be more than 30%");
556         _liquidityFee = liquidityFee;
557     }
558 
559     function _setMaxWalletSizePercent(uint256 maxWalletSize) external onlyOwner {
560         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
561     }
562    
563     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
564         require(maxTxAmount > (1e15 * 10**(_decimals)), "Max Tx Amount cannot be less 0.1%");
565         _maxTxAmount = maxTxAmount;
566     }
567     
568     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
569         require(SwapThresholdAmount > (1e14 * 10**(_decimals)), "Swap Threshold Amount cannot be less 0.01%");
570         _numTokensSellToAddToLiquidity = SwapThresholdAmount;
571     }
572     
573     function claimTokens() public onlyOwner {
574         marketingWallet.transfer(address(this).balance);
575     }
576     
577     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
578         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
579     }
580     
581     function clearStuckBalance(address payable walletaddress) external onlyOwner() {
582         walletaddress.transfer(address(this).balance);
583     }
584     
585     function getBotWalletStatus(address botwallet) public view returns (bool) {
586         return botWallets[botwallet];
587     }
588     
589     function allowtrading() external onlyOwner() {
590         canTrade = true;
591         tradingActiveBlock = block.number;
592     }
593 
594     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
595         swapAndLiquifyEnabled = _enabled;
596         emit SwapAndLiquifyEnabledUpdated(_enabled);
597     }
598 
599     function setCooldownEnabled(bool onoff) external onlyOwner() {
600         cooldownEnabled = onoff;
601     }
602 
603     function setBlocksToBlacklist(uint256 blocks) public onlyOwner {
604         blocksToBlacklist = blocks;
605     }
606 
607     function manualswap() external onlyOwner {
608         uint256 contractBalance = balanceOf(address(this));
609         swapTokensForEth(contractBalance);
610     }
611     
612     function manualsend() external onlyOwner {
613         uint256 contractETHBalance = address(this).balance;
614         sendETHToFee(contractETHBalance);
615     }
616 
617     function withdrawStuckETH() external onlyOwner {
618         bool success;
619         (success,) = address(msg.sender).call{value: address(this).balance}("");
620     }
621     
622     receive() external payable {}
623 
624     function _reflectFee(uint256 rFee, uint256 tFee) private {
625         _rTotal = _rTotal.sub(rFee);
626         _tFeeTotal = _tFeeTotal.add(tFee);
627     }
628 
629     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
630         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
631         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
632         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
633     }
634 
635     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
636         uint256 tFee = calculateTaxFee(tAmount);
637         uint256 tLiquidity = calculateLiquidityFee(tAmount);
638         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
639         return (tTransferAmount, tFee, tLiquidity);
640     }
641 
642     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
643         uint256 rAmount = tAmount.mul(currentRate);
644         uint256 rFee = tFee.mul(currentRate);
645         uint256 rLiquidity = tLiquidity.mul(currentRate);
646         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
647         return (rAmount, rTransferAmount, rFee);
648     }
649 
650     function _getRate() private view returns(uint256) {
651         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
652         return rSupply.div(tSupply);
653     }
654 
655     function _getCurrentSupply() private view returns(uint256, uint256) {
656         uint256 rSupply = _rTotal;
657         uint256 tSupply = _tTotal;      
658         for (uint256 i = 0; i < _excluded.length; i++) {
659             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
660             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
661             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
662         }
663         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
664         return (rSupply, tSupply);
665     }
666     
667     function _takeLiquidity(uint256 tLiquidity) private {
668         uint256 currentRate =  _getRate();
669         uint256 rLiquidity = tLiquidity.mul(currentRate);
670         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
671         if(_isExcluded[address(this)])
672             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
673     }
674     
675     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
676         return _amount.mul(_taxFee).div(
677             10**2
678         );
679     }
680 
681     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
682         return _amount.mul(_liquidityFee).div(
683             10**2
684         );
685     }
686     
687     function removeAllFee() private {
688         if(_taxFee == 0 && _liquidityFee == 0) return;
689         
690         _previousTaxFee = _taxFee;
691         _previousLiquidityFee = _liquidityFee;
692         
693         _taxFee = 0;
694         _liquidityFee = 0;
695     }
696     
697     function restoreAllFee() private {
698         _taxFee = _previousTaxFee;
699         _liquidityFee = _previousLiquidityFee;
700     }
701     
702     function isExcludedFromFee(address account) public view returns(bool) {
703         return _isExcludedFromFee[account];
704     }
705 
706     function _approve(address owner, address spender, uint256 amount) private {
707         require(owner != address(0), "ERC20: approve from the zero address");
708         require(spender != address(0), "ERC20: approve to the zero address");
709 
710         _allowances[owner][spender] = amount;
711         emit Approval(owner, spender, amount);
712     }
713 
714     function _transfer(address from, address to, uint256 amount) private {
715         require(from != address(0), "ERC20: transfer from the zero address");
716         require(to != address(0), "ERC20: transfer to the zero address");
717         require(amount > 0, "Transfer amount must be greater than zero");
718 
719         if (cooldownEnabled) {
720             if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
721                 require(cooldown[tx.origin] < block.number - 1 && cooldown[to] < block.number - 1, "_transfer: Transfer Delay enabled.  Try again later.");
722                 cooldown[tx.origin] = block.number;
723                 cooldown[to] = block.number;
724             }
725         }
726 
727         if(from != owner() && to != owner()) {
728             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
729         }
730 
731         uint256 contractTokenBalance = balanceOf(address(this));
732         
733         if(contractTokenBalance >= _maxTxAmount) {
734             contractTokenBalance = _maxTxAmount;
735         }
736         
737         bool overMinTokenBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
738         if (overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
739             contractTokenBalance = _numTokensSellToAddToLiquidity;
740             swapAndLiquify(contractTokenBalance);
741         }
742         
743         bool takeFee = true;
744         
745         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
746             takeFee = false;
747         }
748 
749         if (takeFee) {
750             if (to != uniswapV2Pair) {
751                 require(amount + balanceOf(to) <= _maxWalletSize, "Recipient exceeds max wallet size.");
752             }
753         }
754         
755         _tokenTransfer(from,to,amount,takeFee);
756     }
757 
758     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
759         uint256 half = contractTokenBalance.div(2);
760         uint256 otherHalf = contractTokenBalance.sub(half);
761         
762         uint256 initialBalance = address(this).balance;
763         
764         swapTokensForEth(half);
765 
766         uint256 newBalance = address(this).balance.sub(initialBalance);
767         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
768         uint256 developmentshare = newBalance.mul(developmentFeePercent).div(100);
769 
770         marketingWallet.transfer(marketingshare);
771         developmentWallet.transfer(developmentshare);
772 
773         newBalance -= (marketingshare + developmentshare);
774         
775         addLiquidity(otherHalf, newBalance);
776         
777         emit SwapAndLiquify(half, newBalance, otherHalf);
778     }
779 
780     function swapTokensForEth(uint256 tokenAmount) private {
781         address[] memory path = new address[](2);
782         path[0] = address(this);
783         path[1] = uniswapV2Router.WETH();
784 
785         _approve(address(this), address(uniswapV2Router), tokenAmount);
786         
787         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
788     }
789 
790     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
791         _approve(address(this), address(uniswapV2Router), tokenAmount);
792         
793         uniswapV2Router.addLiquidityETH{value: ethAmount} (address(this), tokenAmount, 0, 0, liquidityWallet, block.timestamp);
794     }
795         
796     function sendETHToFee(uint256 amount) private {
797         marketingWallet.transfer(amount.div(2));
798         developmentWallet.transfer(amount.div(2));
799     }
800     
801     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
802         if(!canTrade) {
803             require(sender == owner());
804         }
805         
806         if(botWallets[sender] || botWallets[recipient]){
807             require(botscantrade, "go away bot.");
808         }
809         
810         if(!takeFee) {
811             removeAllFee();
812         } else {
813 
814             if(tradingActiveBlock + blocksToBlacklist >= block.number) {
815                 uint256 fees = amount.mul(99).div(100);
816             
817                 if(fees > 0) {
818                     _transferSuperStandard(sender, address(this), fees);
819                 }
820             
821                 amount -= fees;
822             }
823         }
824         
825         if (_isExcluded[sender] && !_isExcluded[recipient]) {
826             _transferFromExcluded(sender, recipient, amount);
827         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
828             _transferToExcluded(sender, recipient, amount);
829         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
830             _transferStandard(sender, recipient, amount);
831         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
832             _transferBothExcluded(sender, recipient, amount);
833         } else {
834             _transferStandard(sender, recipient, amount);
835         }
836         
837         if(!takeFee) {
838             restoreAllFee();
839         }
840     }
841 
842     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
843         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
844         _rOwned[sender] = _rOwned[sender].sub(rAmount);
845         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
846         _takeLiquidity(tLiquidity);
847         _reflectFee(rFee, tFee);
848         emit Transfer(sender, recipient, tTransferAmount);
849     }
850 
851     function _transferSuperStandard(address sender, address recipient, uint256 tAmount) private {
852         _rOwned[sender] = _rOwned[sender].sub(tAmount);
853         _rOwned[recipient] = _rOwned[recipient].add(tAmount);
854         emit Transfer(sender, recipient, tAmount);
855     }
856 
857     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
858         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
859         _rOwned[sender] = _rOwned[sender].sub(rAmount);
860         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
861         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
862         _takeLiquidity(tLiquidity);
863         _reflectFee(rFee, tFee);
864         emit Transfer(sender, recipient, tTransferAmount);
865     }
866 
867     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
868         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
869         _tOwned[sender] = _tOwned[sender].sub(tAmount);
870         _rOwned[sender] = _rOwned[sender].sub(rAmount);
871         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
872         _takeLiquidity(tLiquidity);
873         _reflectFee(rFee, tFee);
874         emit Transfer(sender, recipient, tTransferAmount);
875     }
876 
877 }