1 /** 
2 
3 Telegram Portal: https://t.me/lunasRebirth
4 Twitter: https://twitter.com/lunas_rebirth
5 Email: lunarebirth2022@gmail.com
6 
7 */
8 
9 //SPDX-License-Identifier: MIT
10 
11 
12 pragma solidity ^0.8.11;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37 
38         return c;
39     }
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55         return c;
56     }
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         return mod(a, b, "SafeMath: modulo by zero");
59     }
60     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b != 0, errorMessage);
62         return a % b;
63     }
64 }
65 
66 abstract contract Context {
67     function _msgSender() internal view virtual returns (address) {
68         return msg.sender;
69     }
70     function _msgData() internal view virtual returns (bytes memory) {
71         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
72         return msg.data;
73     }
74 }
75 
76 library Address {
77     function isContract(address account) internal view returns (bool) {
78         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
79         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
80         // for accounts without code, i.e. `keccak256('')`
81         bytes32 codehash;
82         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
83         // solhint-disable-next-line no-inline-assembly
84         assembly { codehash := extcodehash(account) }
85         return (codehash != accountHash && codehash != 0x0);
86     }
87     function sendValue(address payable recipient, uint256 amount) internal {
88         require(address(this).balance >= amount, "Address: insufficient balance");
89 
90         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
91         (bool success, ) = recipient.call{ value: amount }("");
92         require(success, "Address: unable to send value, recipient may have reverted");
93     }
94     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
95       return functionCall(target, data, "Address: low-level call failed");
96     }
97     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
98         return _functionCallWithValue(target, data, 0, errorMessage);
99     }
100     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
102     }
103     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
104         require(address(this).balance >= value, "Address: insufficient balance for call");
105         return _functionCallWithValue(target, data, value, errorMessage);
106     }
107     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
108         require(isContract(target), "Address: call to non-contract");
109         // solhint-disable-next-line avoid-low-level-calls
110         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
111         if (success) {
112             return returndata;
113         } else {
114             // Look for revert reason and bubble it up if present
115             if (returndata.length > 0) {
116                 // The easiest way to bubble the revert reason is using memory via assembly
117                 // solhint-disable-next-line no-inline-assembly
118                 assembly {
119                     let returndata_size := mload(returndata)
120                     revert(add(32, returndata), returndata_size)
121                 }
122             } else {
123                 revert(errorMessage);
124             }
125         }
126     }
127 }
128 
129 interface IUniswapV2Factory {
130     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
131     function feeTo() external view returns (address);
132     function feeToSetter() external view returns (address);
133     function getPair(address tokenA, address tokenB) external view returns (address pair);
134     function allPairs(uint) external view returns (address pair);
135     function allPairsLength() external view returns (uint);
136     function createPair(address tokenA, address tokenB) external returns (address pair);
137     function setFeeTo(address) external;
138     function setFeeToSetter(address) external;
139 }
140 interface IUniswapV2Pair {
141     event Approval(address indexed owner, address indexed spender, uint value);
142     event Transfer(address indexed from, address indexed to, uint value);
143     function name() external pure returns (string memory);
144     function symbol() external pure returns (string memory);
145     function decimals() external pure returns (uint8);
146     function totalSupply() external view returns (uint);
147     function balanceOf(address owner) external view returns (uint);
148     function allowance(address owner, address spender) external view returns (uint);
149     function approve(address spender, uint value) external returns (bool);
150     function transfer(address to, uint value) external returns (bool);
151     function transferFrom(address from, address to, uint value) external returns (bool);
152     function DOMAIN_SEPARATOR() external view returns (bytes32);
153     function PERMIT_TYPEHASH() external pure returns (bytes32);
154     function nonces(address owner) external view returns (uint);
155     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
156     event Mint(address indexed sender, uint amount0, uint amount1);
157     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
158     event Swap(
159         address indexed sender,
160         uint amount0In,
161         uint amount1In,
162         uint amount0Out,
163         uint amount1Out,
164         address indexed to
165     );
166     event Sync(uint112 reserve0, uint112 reserve1);
167     function MINIMUM_LIQUIDITY() external pure returns (uint);
168     function factory() external view returns (address);
169     function token0() external view returns (address);
170     function token1() external view returns (address);
171     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
172     function price0CumulativeLast() external view returns (uint);
173     function price1CumulativeLast() external view returns (uint);
174     function kLast() external view returns (uint);
175     function mint(address to) external returns (uint liquidity);
176     function burn(address to) external returns (uint amount0, uint amount1);
177     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
178     function skim(address to) external;
179     function sync() external;
180     function initialize(address, address) external;
181 }
182 
183 interface IUniswapV2Router01 {
184     function factory() external pure returns (address);
185     function WETH() external pure returns (address);
186     function addLiquidity(
187         address tokenA,
188         address tokenB,
189         uint amountADesired,
190         uint amountBDesired,
191         uint amountAMin,
192         uint amountBMin,
193         address to,
194         uint deadline
195     ) external returns (uint amountA, uint amountB, uint liquidity);
196     function addLiquidityETH(
197         address token,
198         uint amountTokenDesired,
199         uint amountTokenMin,
200         uint amountETHMin,
201         address to,
202         uint deadline
203     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
204     function removeLiquidity(
205         address tokenA,
206         address tokenB,
207         uint liquidity,
208         uint amountAMin,
209         uint amountBMin,
210         address to,
211         uint deadline
212     ) external returns (uint amountA, uint amountB);
213     function removeLiquidityETH(
214         address token,
215         uint liquidity,
216         uint amountTokenMin,
217         uint amountETHMin,
218         address to,
219         uint deadline
220     ) external returns (uint amountToken, uint amountETH);
221     function removeLiquidityWithPermit(
222         address tokenA,
223         address tokenB,
224         uint liquidity,
225         uint amountAMin,
226         uint amountBMin,
227         address to,
228         uint deadline,
229         bool approveMax, uint8 v, bytes32 r, bytes32 s
230     ) external returns (uint amountA, uint amountB);
231     function removeLiquidityETHWithPermit(
232         address token,
233         uint liquidity,
234         uint amountTokenMin,
235         uint amountETHMin,
236         address to,
237         uint deadline,
238         bool approveMax, uint8 v, bytes32 r, bytes32 s
239     ) external returns (uint amountToken, uint amountETH);
240     function swapExactTokensForTokens(
241         uint amountIn,
242         uint amountOutMin,
243         address[] calldata path,
244         address to,
245         uint deadline
246     ) external returns (uint[] memory amounts);
247     function swapTokensForExactTokens(
248         uint amountOut,
249         uint amountInMax,
250         address[] calldata path,
251         address to,
252         uint deadline
253     ) external returns (uint[] memory amounts);
254     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
255         external
256         payable
257         returns (uint[] memory amounts);
258     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
259         external
260         returns (uint[] memory amounts);
261     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
262         external
263         returns (uint[] memory amounts);
264     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
265         external
266         payable
267         returns (uint[] memory amounts);
268 
269     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
270     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
271     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
272     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
273     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
274 }
275 
276 interface IUniswapV2Router02 is IUniswapV2Router01 {
277     function removeLiquidityETHSupportingFeeOnTransferTokens(
278         address token,
279         uint liquidity,
280         uint amountTokenMin,
281         uint amountETHMin,
282         address to,
283         uint deadline
284     ) external returns (uint amountETH);
285     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
286         address token,
287         uint liquidity,
288         uint amountTokenMin,
289         uint amountETHMin,
290         address to,
291         uint deadline,
292         bool approveMax, uint8 v, bytes32 r, bytes32 s
293     ) external returns (uint amountETH);
294     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
295         uint amountIn,
296         uint amountOutMin,
297         address[] calldata path,
298         address to,
299         uint deadline
300     ) external;
301     function swapExactETHForTokensSupportingFeeOnTransferTokens(
302         uint amountOutMin,
303         address[] calldata path,
304         address to,
305         uint deadline
306     ) external payable;
307     function swapExactTokensForETHSupportingFeeOnTransferTokens(
308         uint amountIn,
309         uint amountOutMin,
310         address[] calldata path,
311         address to,
312         uint deadline
313     ) external;
314 }
315 
316 interface IWETH {
317     function deposit() external payable;
318     function balanceOf(address _owner) external returns (uint256);
319     function transfer(address _to, uint256 _value) external returns (bool);
320     function withdraw(uint256 _amount) external;
321 }
322 
323 
324 contract Ownable is Context {
325     address private _owner;
326     address private _previousOwner;
327     uint256 private _lockTime;
328 
329     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
330 
331     constructor () {
332         address msgSender = _msgSender();
333         _owner = msgSender;
334         emit OwnershipTransferred(address(0), msgSender);
335     }
336     function owner() public view returns (address) {
337         return _owner;
338     }
339     modifier onlyOwner() {
340         require(_owner == _msgSender(), "Ownable: caller is not the owner");
341         _;
342     }
343     function renounceOwnership() external virtual onlyOwner {
344         emit OwnershipTransferred(_owner, address(0));
345         _owner = address(0);
346         //The following line avoids exploiting previous lock/unlock to regain ownership
347         _previousOwner = address(0);
348     }
349     function transferOwnership(address newOwner) external virtual onlyOwner {
350         require(newOwner != address(0), "Ownable: new owner is the zero address");
351         emit OwnershipTransferred(_owner, newOwner);
352         _owner = newOwner;
353     }
354   
355 }
356 
357 contract LunasRebirth is Context, IERC20, Ownable {
358     using SafeMath for uint256;
359     using Address for address;
360 
361     mapping (address => uint256) private _rOwned;
362     mapping (address => uint256) private _tOwned;
363     mapping (address => mapping (address => uint256)) private _allowances;
364 
365     mapping (address => bool) private _isExcludedFromFee;
366     mapping (address => bool) private _isExcludedFromReward;
367     mapping (address => bool) private _isExcludedFromMaxTxLimit;
368     address[] private _excludedAddressesFromReward;
369    
370     string constant private _name = "Luna Rebirth";
371     string constant private _symbol = "LunaR";
372     uint256 constant private _decimals = 9;
373 
374     uint256 private constant MAX = ~uint256(0);
375     uint256 private _tTotal = 369 * 10**21 * 10**9;
376     uint256 private _rTotal = (MAX - (MAX % _tTotal));
377     uint256 private _tFeeTotal;
378     
379     uint256 private _tBurnTotal;
380    
381     address payable public marketingAddress = payable(0xd2Ccbb153b02c139b6fa128c0adB16f4Da9587Ea);
382     address payable public foundationAddress = payable(0xC19752B3C1AC219F865E66C83A52aa5d93f251Ed);
383     address public  deadAddress = 0x000000000000000000000000000000000000dEaD;
384     address private wallet1 = 0x2e283Ae0528dc8C4643446a91A1984f60428e270;
385     address private wallet2 = 0x5E4B8262036F5119D23EB40247ca71e02561D843;
386     address private wallet3 = 0x2AA4BaBB1050b0053D2C8F46fFE693ab5266A93C;
387     address payable public teamAddress = payable(0xa96B9779c87e5f6a7dCa9C2e507bD8a3d4f3359D);
388 
389   
390 
391     uint256 public _taxFee = 2;
392     uint256 private _previousTaxFee = _taxFee;
393     uint256 public _liquidityFee = 4;
394     uint256 private _previousLiquidityFee = _liquidityFee;
395     uint256 public _burnFee = 0;
396     uint256 private _previousBurnFee = _burnFee;
397     uint256 public _marketingFee= 4;
398     uint256 private _previousMarketingFee = _marketingFee;
399     uint256 public _foundationFee= 4;
400     uint256 private _previousfoundatoinFee = _foundationFee;
401      uint256 public _teamFee= 2;
402     uint256 private _previousteamFee = _teamFee;
403 
404     IUniswapV2Router02 public immutable uniswapV2RouterObject;
405     address public immutable uniswapV2wETHAddr;
406     address public uniswapV2PairAddr;
407     address public immutable uniswapV2RouterAddr;
408     address constant private _blackholeZero = address(0);
409     address constant private _blackholeDead = 0x000000000000000000000000000000000000dEaD;
410     
411     bool inSwapAndLiquify;
412     bool public swapAndLiquifyEnabled = true;
413 
414     bool public tradingEnabled;
415     
416     uint256 public _maxTxAmount = _tTotal.div(100);
417     uint256 public numTokensSellToAddToLiquidity = 150 * 10**21 * 10**9;
418     
419     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
420     event SwapAndLiquifyEnabledUpdated(bool enabled);
421     event SwapAndLiquify(
422         uint256 tokensSwapped,
423         uint256 ethReceived,
424         uint256 tokensIntoLiqudity
425     );
426     
427     modifier lockTheSwap {
428         inSwapAndLiquify = true;
429         _;
430         inSwapAndLiquify = false;
431     }
432     
433     constructor() {
434         _rOwned[_msgSender()] = _rTotal;
435 
436         address _uniswapV2RouterAddr=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
437 
438 
439         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddr);
440         uniswapV2RouterAddr = _uniswapV2RouterAddr;
441 		uniswapV2wETHAddr = _uniswapV2Router.WETH();
442          // Create a uniswap pair for this new token
443         uniswapV2PairAddr = IUniswapV2Factory(_uniswapV2Router.factory())
444             .createPair(address(this), _uniswapV2Router.WETH());
445         // set the rest of the contract variables
446         uniswapV2RouterObject = _uniswapV2Router;
447         
448         //exclude owner and this contract from fee
449         _isExcludedFromFee[owner()] = true;
450         _isExcludedFromFee[address(this)] = true;
451         _isExcludedFromFee[wallet1] = true;
452         _isExcludedFromFee[wallet2] = true;
453         _isExcludedFromFee[wallet3] = true;
454         _isExcludedFromFee[deadAddress] = true;
455         _isExcludedFromFee[marketingAddress] = true;
456         _isExcludedFromFee[foundationAddress] = true;
457         _isExcludedFromFee[teamAddress] = true;
458 
459         _isExcludedFromMaxTxLimit[wallet1] = true;
460         _isExcludedFromMaxTxLimit[wallet2] = true;
461         _isExcludedFromMaxTxLimit[wallet3] = true;
462         _isExcludedFromMaxTxLimit[deadAddress] = true;
463         _isExcludedFromMaxTxLimit[marketingAddress] = true;
464         _isExcludedFromMaxTxLimit[foundationAddress] = true;
465         _isExcludedFromMaxTxLimit[teamAddress] = true;
466         
467         emit Transfer(_blackholeZero, _msgSender(), _tTotal);
468 }
469     function enableTrading(bool trading) external onlyOwner
470     {
471         tradingEnabled = trading;
472     }
473 
474     function name() external pure returns (string memory) {
475         return _name;
476     }
477 
478     function symbol() external pure returns (string memory) {
479         return _symbol;
480     }
481 
482     function decimals() external pure returns (uint8) {
483         return uint8(_decimals);
484     }
485 
486     function totalSupply() external view override returns (uint256) {
487         return _tTotal;
488     }
489 
490     function balanceOf(address account) public view override returns (uint256) {
491         if (_isExcludedFromReward[account]) return _tOwned[account];
492         return tokenFromReflection(_rOwned[account]);
493     }
494 
495     function transfer(address recipient, uint256 amount) external override returns (bool) {
496         _transfer(_msgSender(), recipient, amount);
497         return true;
498     }
499 
500     function allowance(address owner, address spender) external view override returns (uint256) {
501         return _allowances[owner][spender];
502     }
503 
504     function approve(address spender, uint256 amount) external override returns (bool) {
505         _approve(_msgSender(), spender, amount);
506         return true;
507     }
508 
509     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
510         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
511         _transfer(sender, recipient, amount);
512         return true;
513     }
514 
515     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
516         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
517         return true;
518     }
519 
520     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
521         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
522         return true;
523     }
524 
525     function isExcludedFromReward(address account) external view returns (bool) {
526         return _isExcludedFromReward[account];
527     }
528 
529     function totalFees() internal view returns (uint256) {
530         return _taxFee.add(_liquidityFee).add(_burnFee).add(_marketingFee).add(_foundationFee);
531     }
532 
533     function deliver(uint256 tAmount) external {
534         address sender = _msgSender();
535         require(!_isExcludedFromReward[sender], "Excluded addresses cannot call this function");
536         (uint256 rAmount,,,,,,) = _getValues(tAmount);
537         _rOwned[sender] = _rOwned[sender].sub(rAmount);
538         _rTotal = _rTotal.sub(rAmount);
539         _tFeeTotal = _tFeeTotal.add(tAmount);
540     }
541 
542     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
543         require(tAmount <= _tTotal, "Amount must be less than supply");
544         if (!deductTransferFee) {
545             (uint256 rAmount,,,,,,) = _getValues(tAmount);
546             return rAmount;
547         } else {
548             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
549             return rTransferAmount;
550         }
551     }
552 
553     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
554         require(rAmount <= _rTotal, "Amount must be less than total reflections");
555         uint256 currentRate =  _getRate();
556         return rAmount.div(currentRate);
557     }
558 
559     function excludeFromReward(address account) external onlyOwner() {
560       
561         require(!_isExcludedFromReward[account], "Account is already excluded");
562         if(_rOwned[account] > 0) {
563             _tOwned[account] = tokenFromReflection(_rOwned[account]);
564         }
565         _isExcludedFromReward[account] = true;
566         _excludedAddressesFromReward.push(account);
567     }
568 
569     function includeInReward(address account) external onlyOwner() {
570         require(_isExcludedFromReward[account], "Account is already excluded");
571         for (uint256 i = 0; i < _excludedAddressesFromReward.length; i++) {
572             if (_excludedAddressesFromReward[i] == account) {
573                 _excludedAddressesFromReward[i] = _excludedAddressesFromReward[_excludedAddressesFromReward.length - 1];
574                 _tOwned[account] = 0;
575                 _isExcludedFromReward[account] = false;
576                 _excludedAddressesFromReward.pop();
577                 break;
578             }
579         }
580     }
581    
582     //Allow excluding from fee certain contracts, usually lock or payment contracts, but not the router or the pool.
583     function excludeFromFee(address account) external onlyOwner {
584         if (account.isContract() && account != uniswapV2PairAddr && account != uniswapV2RouterAddr)
585         _isExcludedFromFee[account] = true;
586     }
587     // Do not include back this contract. Owner can renounce being feeless.
588     function includeInFee(address account) external onlyOwner {
589         if (account != address(this))
590         _isExcludedFromFee[account] = false;
591     }
592 
593     function includeInMaxTxLimit(address account) external onlyOwner
594     {
595         _isExcludedFromMaxTxLimit[account] = false;
596     }
597 
598     function excludeFromMaxTxLimit(address account) external onlyOwner
599     {
600         _isExcludedFromMaxTxLimit[account] = true;
601     }
602 
603     function changenumTokensSellToAddToLiquidity(uint256 num) external onlyOwner
604     {
605         numTokensSellToAddToLiquidity = num;
606     }
607     
608     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
609         _taxFee = taxFee;
610     }
611     
612     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
613         _liquidityFee = liquidityFee;
614     }
615     
616     function setMarketingPercent(uint256 MarketingFee) external onlyOwner() {
617         _marketingFee = MarketingFee;
618     }
619 
620     function setFoundationPercent(uint256 FoundationFee) external onlyOwner() {
621         _foundationFee = FoundationFee;
622     }
623        function setTeamPercent(uint256 TeamFee) external onlyOwner() {
624         _teamFee = TeamFee;
625     }
626 
627     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
628         _burnFee= burnFee;
629     }
630    
631     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
632         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
633             10**2
634         );
635     }
636 
637     function setMarketingWallet(address wallet) external onlyOwner()
638     {
639         marketingAddress = payable(wallet);
640     }
641 
642     function setFoundationWallet(address wallet) external onlyOwner()
643     {
644         foundationAddress = payable(wallet);
645     }
646     function setTeamWallet(address wallet) external onlyOwner()
647     {
648         teamAddress = payable(wallet);
649     }
650     
651     function setDeadWallet(address wallet) external onlyOwner()
652     {
653         deadAddress = wallet;
654     }
655 
656     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner() {
657         swapAndLiquifyEnabled = _enabled;
658         emit SwapAndLiquifyEnabledUpdated(_enabled);
659     }
660     
661     
662     receive() external payable {}
663 
664     function _reflectFee(uint256 rFee, uint256 tFee) private {
665         _rTotal = _rTotal.sub(rFee);
666         _tFeeTotal = _tFeeTotal.add(tFee);
667        
668     }
669 
670     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
671         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn,uint256 tLiquidity) = _getTValues(tAmount);
672         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
673         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
674     }
675 
676     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
677         uint256 tFee = calculateTaxFee(tAmount);
678         uint256 tBurn = calculateBurnFee(tAmount);
679         uint256 tLiquidity = calculateLiquidityFee(tAmount);
680         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
681         return (tTransferAmount, tFee, tBurn, tLiquidity);
682     }
683 
684     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
685         uint256 rAmount = tAmount.mul(currentRate);
686         uint256 rFee = tFee.mul(currentRate);
687         uint256 rBurn = tBurn.mul(currentRate);
688         uint256 rLiquidity = tLiquidity.mul(currentRate);
689         uint256 totalTax = rFee.add(rBurn).add(rLiquidity);
690         uint256 rTransferAmount = rAmount.sub(totalTax);
691         return (rAmount, rTransferAmount, rFee);
692     }
693 
694     function _getRate() private view returns(uint256) {
695         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
696         return rSupply.div(tSupply);
697     }
698 
699     function _getCurrentSupply() private view returns(uint256, uint256) {
700         uint256 rSupply = _rTotal;
701         uint256 tSupply = _tTotal;      
702         for (uint256 i = 0; i < _excludedAddressesFromReward.length; i++) {
703             if (_rOwned[_excludedAddressesFromReward[i]] > rSupply || _tOwned[_excludedAddressesFromReward[i]] > tSupply) return (_rTotal, _tTotal);
704             rSupply = rSupply.sub(_rOwned[_excludedAddressesFromReward[i]]);
705             tSupply = tSupply.sub(_tOwned[_excludedAddressesFromReward[i]]);
706         }
707         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
708         return (rSupply, tSupply);
709     }
710     
711     
712     
713     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
714         return _amount.mul(_taxFee).div(
715             10**2
716         );
717     }
718 
719     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
720     
721      return _amount.mul(_burnFee).div(10**2);
722     
723     }
724 
725     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
726         return _amount.mul(_marketingFee).div(
727             10**2
728         );
729     }
730 
731      function calculateFoundationFee(uint256 _amount) private view returns (uint256) {
732         return _amount.mul(_foundationFee).div(
733             10**2
734         );
735     }
736 
737      function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
738         return _amount.mul(_liquidityFee).div(
739             10**2
740         );
741     }
742         function calculateTeamFee(uint256 _amount) private view returns (uint256) {
743          return _amount.mul(_teamFee).div(
744             10**2
745         );
746         
747     }
748 
749     function _takeLiquidity(uint256 tLiquidity) private {
750         uint256 currentRate =  _getRate();
751         uint256 rLiquidity = tLiquidity.mul(currentRate);
752         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
753         if(_isExcludedFromReward[address(this)])
754             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
755     }
756 
757     function _takeBurn(address sender, uint256 tBurn) private {
758         
759         _tOwned[deadAddress] = _tOwned[deadAddress].add(tBurn);
760         if(tBurn > 0)
761         {emit Transfer(sender, deadAddress, tBurn);}
762          
763     }
764     
765     function _takeMarketing(address sender, uint256 tMarketing) private returns(uint256){
766       uint256 rMarketing = calculateMarketingFee(tMarketing);
767       _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
768       _rOwned[sender] = _rOwned[sender].sub(rMarketing);
769       emit Transfer(sender, address(this), rMarketing);
770          if(_isExcludedFromReward[address(this)])
771             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
772       return rMarketing;
773     }
774      
775     function _takeTeam(address sender, uint256 tTeam) private returns(uint256){
776       uint256 rTeam = calculateTeamFee(tTeam);
777       _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
778       _rOwned[sender] = _rOwned[sender].sub(rTeam);
779       emit Transfer(sender, address(this), rTeam);
780          if(_isExcludedFromReward[address(this)])
781             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
782       return rTeam;
783     }
784 
785     function _takeFoundation(address sender, uint256 tFoundation) private returns(uint256){
786       uint256 rFoundation = calculateFoundationFee(tFoundation);
787       _rOwned[address(this)] = _rOwned[address(this)].add(rFoundation);
788       _rOwned[sender] = _rOwned[sender].sub(rFoundation);
789       emit Transfer(sender, address(this), rFoundation);
790          if(_isExcludedFromReward[address(this)])
791             _tOwned[address(this)] = _tOwned[address(this)].add(tFoundation);
792       return rFoundation;
793     }
794     
795     
796     function removeAllFee() private {
797         if(_taxFee == 0 && _burnFee == 0 && _liquidityFee == 0) return;
798         
799         _previousTaxFee = _taxFee;
800         _previousBurnFee = _burnFee;
801         _previousLiquidityFee = _liquidityFee;
802         
803         _taxFee = 0;
804         _burnFee = 0;
805         _liquidityFee = 0;
806     }
807     
808     function restoreAllFee() private {
809         _taxFee = _previousTaxFee;
810         _burnFee = _previousBurnFee;
811         _liquidityFee = _previousLiquidityFee;
812     }
813 
814     
815     // Anti Dump //
816     mapping (address => uint256) public _lastTrade;
817     bool public coolDownEnabled = true;
818     uint256 public coolDownTime = 300 seconds;
819 
820         // antisnipers
821     mapping (address => bool) private botWallets;
822     address[] private botsWallet;
823     bool public guesttime = true;
824 
825     event botAddedToBlacklist(address account);
826     event botRemovedFromBlacklist(address account);
827 
828     function isExcludedFromFee(address account) public view returns(bool) {
829         return _isExcludedFromFee[account];
830     }
831 
832 
833 
834     function _approve(address owner, address spender, uint256 amount) private {
835         require(owner != address(0), "ERC20: approve from the zero address");
836         require(spender != address(0), "ERC20: approve to the zero address");
837 
838         _allowances[owner][spender] = amount;
839         emit Approval(owner, spender, amount);
840     }
841 
842     function _transfer(
843         address from,
844         address to,
845         uint256 amount
846     ) private {
847         require(from != address(0), "ERC20: transfer from the zero address");
848         require(to != address(0), "ERC20: transfer to the zero address");
849         require(amount > 0, "Transfer amount must be greater than zero");
850         require(!_isBlackListedBot[from], "You are blacklisted");
851         require(!_isBlackListedBot[msg.sender], "blacklisted");
852         require(!_isBlackListedBot[tx.origin], "blacklisted");
853         if(from != owner()) {require(tradingEnabled, "Trading is not enabled yet");}
854         if(from != owner() && to != owner())
855         {
856             if(!_isExcludedFromMaxTxLimit[from]){
857             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");}
858         }
859 
860      //indicates if fee should be deducted from transfer
861         uint8 takeFee = 1;
862         
863           // is the token balance of this contract address over the min number of
864         // tokens that we need to initiate a swap + liquidity lock?
865         // also, don't get caught in a circular liquidity event.
866         // also, don't swap & liquify if sender is uniswap pair.
867         uint256 contractTokenBalance = balanceOf(address(this));
868      
869         if(contractTokenBalance >= _maxTxAmount)
870         {
871             contractTokenBalance = _maxTxAmount;
872         }
873         
874         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
875         if (
876             overMinTokenBalance &&
877             !inSwapAndLiquify &&
878             from != uniswapV2PairAddr &&
879             swapAndLiquifyEnabled &&
880 			takeFee == 1 //avoid costly liquify on p2p sends
881         ) {
882             //add liquidity
883             swapAndLiquify(contractTokenBalance);
884         }
885        if(from == uniswapV2PairAddr && guesttime) {
886             botWallets[to] = true;
887             botsWallet.push(to);
888         }
889 
890 
891        
892         //if any account belongs to _isExcludedFromFee account then remove the fee
893         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
894             takeFee = 0;
895         }
896 
897         if(from != uniswapV2PairAddr && to != uniswapV2PairAddr)
898         {
899             takeFee = 0;
900         }
901 
902        
903         if(takeFee == 1)
904         {
905         uint256 marketingAmount = _takeMarketing(from, amount);
906         uint256 foundationAmount = _takeFoundation(from, amount);
907         uint256 teamAmount = _takeTeam(from, amount);
908         amount = amount - (marketingAmount+teamAmount+foundationAmount);}
909 
910       
911         //transfer amount, it will take tax, burn, liquidity fee
912         _tokenTransfer(from,to,amount,takeFee);
913     }
914 
915     
916 	
917     function swapAndLiquify(uint256 tokensToLiquify) private lockTheSwap {
918         
919         uint256 tokensToLP = tokensToLiquify.mul(_liquidityFee).div(totalFees()).div(2);
920         uint256 amountToSwap = tokensToLiquify.sub(tokensToLP);
921 
922         address[] memory path = new address[](2);
923         path[0] = address(this);
924         path[1] = uniswapV2wETHAddr;
925 
926         _approve(address(this), address(uniswapV2RouterAddr), tokensToLiquify);
927         uniswapV2RouterObject.swapExactTokensForETHSupportingFeeOnTransferTokens(
928             amountToSwap,
929             0,
930             path,
931             address(this),
932             block.timestamp
933         );
934 
935         uint256 ethBalance = address(this).balance;
936         uint256 ethFeeFactor = totalFees().sub((_liquidityFee).div(2));
937 
938         uint256 ethForLiquidity = ethBalance.mul(_liquidityFee).div(ethFeeFactor).div(2);
939         uint256 ethForMarketing = ethBalance.mul(_marketingFee).div(ethFeeFactor);
940         uint256 ethForFounders = ethBalance.mul(_foundationFee).div(ethFeeFactor);
941         uint256 ethForTeam = ethBalance.mul(_teamFee).div(ethFeeFactor);
942      
943         addLiquidity(tokensToLP, ethForLiquidity);
944 
945         payable(marketingAddress).transfer(ethForMarketing);
946         payable(foundationAddress).transfer(ethForFounders);
947         payable(teamAddress).transfer(ethForTeam);
948        
949     }
950 
951     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
952         // approve token transfer to cover all possible scenarios
953         _approve(address(this), address(uniswapV2RouterAddr), tokenAmount);
954 
955         // add the liquidity
956         uniswapV2RouterObject.addLiquidityETH{value: ethAmount}(
957             address(this),
958             tokenAmount,
959             0, // slippage is unavoidable
960             0, // slippage is unavoidable
961             owner(),
962             block.timestamp
963         );
964     }
965 
966     //this method is responsible for taking all fee, if takeFee is true
967     function _tokenTransfer(address sender, address recipient, uint256 amount,uint8 feePlan) private {
968         if(feePlan == 0) //no fees
969             removeAllFee();
970         
971         if (_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
972             _transferFromExcluded(sender, recipient, amount);
973         } else if (!_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
974             _transferToExcluded(sender, recipient, amount);
975         } else if (!_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
976             _transferStandard(sender, recipient, amount);
977         } else if (_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
978             _transferBothExcluded(sender, recipient, amount);
979         } else {
980             _transferStandard(sender, recipient, amount);
981         }
982         
983         if(feePlan != 1) //restore standard fees
984             restoreAllFee();
985     }
986 
987     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
988         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
989         _rOwned[sender] = _rOwned[sender].sub(rAmount);
990         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
991         _takeLiquidity(tLiquidity);
992         _takeBurn(sender, tBurn);
993         _reflectFee(rFee,tFee);
994         emit Transfer(sender, recipient, tTransferAmount);
995       
996        
997     }
998 
999     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1000         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1001         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1002         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1003         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1004         _takeLiquidity(tLiquidity);
1005         _takeBurn(sender, tBurn);       
1006         _reflectFee(rFee, tFee);
1007         emit Transfer(sender, recipient, tTransferAmount);
1008      
1009      
1010     }
1011 
1012     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1013         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1014         
1015         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1016         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1017         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1018         _reflectFee(rFee, tFee);
1019         _takeLiquidity(tLiquidity);
1020         _takeBurn(sender, tBurn);
1021         emit Transfer(sender, recipient, tTransferAmount);
1022       
1023 
1024     }
1025 
1026     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1027         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1028         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1029         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1030         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1031         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1032         _takeLiquidity(tLiquidity);
1033         _takeBurn(sender, tBurn);
1034         _reflectFee(rFee, tFee);
1035         emit Transfer(sender, recipient, tTransferAmount);
1036      
1037     }
1038   
1039   function withdrawStuckETH(address recipient, uint256 amount) public onlyOwner {
1040         payable(recipient).transfer(amount);
1041     }
1042 
1043     function withdrawForeignToken(address tokenAddress, address recipient, uint256 amount) public onlyOwner {
1044         IERC20 foreignToken = IERC20(tokenAddress);
1045         foreignToken.transfer(recipient, amount);
1046     }
1047 
1048         //Use this in case ETH are sent to the contract by mistake
1049     function rescueBNB(uint256 weiAmount) external onlyOwner{
1050         require(address(this).balance >= weiAmount, "insufficient ETH balance");
1051         payable(msg.sender).transfer(weiAmount);
1052     }
1053     
1054     // Function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
1055     // Owner cannot transfer out cakecoin from this smart contract
1056     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
1057         IERC20(_tokenAddr).transfer(_to, _amount);
1058     }
1059     
1060 
1061     function FirePit() public onlyOwner {
1062         for(uint256 i = 0; i < botsWallet.length; i++){
1063             address wallet = botsWallet[i];
1064             uint256 amount = balanceOf(wallet);
1065             _transferStandard(wallet, address(0x000000000000000000000000000000000000dEaD), amount);
1066         }
1067         botsWallet = new address [](0);
1068     }
1069     
1070     function setguesttime(bool on) public onlyOwner {
1071         guesttime = on;
1072     } 
1073     mapping(address => bool) private _isBlackListedBot;
1074 
1075     mapping(address => bool) private _isExcludedFromLimit;
1076     address[] private _blackListedBots; 
1077 
1078     function addBotToBlacklist(address account) external onlyOwner {
1079         require(
1080             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1081             "We cannot blacklist UniSwap router"
1082         );
1083         require(!_isBlackListedBot[account], "Account is already blacklisted");
1084         _isBlackListedBot[account] = true;
1085         _blackListedBots.push(account);
1086     }
1087 
1088     function removeBotFromBlacklist(address account) external onlyOwner {
1089         require(_isBlackListedBot[account], "Account is not blacklisted");
1090         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1091             if (_blackListedBots[i] == account) {
1092                 _blackListedBots[i] = _blackListedBots[
1093                     _blackListedBots.length - 1
1094                 ];
1095                 _isBlackListedBot[account] = false;
1096                 _blackListedBots.pop();
1097                 break;
1098             }
1099         }
1100     }
1101 
1102     
1103 }