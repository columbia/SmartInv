1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.11;
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
20         return c;
21     }
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
26         require(b <= a, errorMessage);
27         uint256 c = a - b;
28 
29         return c;
30     }
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37         return c;
38     }
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return c;
47     }
48     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
49         return mod(a, b, "SafeMath: modulo by zero");
50     }
51     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b != 0, errorMessage);
53         return a % b;
54     }
55 }
56 
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61     function _msgData() internal view virtual returns (bytes memory) {
62         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
63         return msg.data;
64     }
65 }
66 
67 library Address {
68     function isContract(address account) internal view returns (bool) {
69         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
70         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
71         // for accounts without code, i.e. `keccak256('')`
72         bytes32 codehash;
73         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
74         // solhint-disable-next-line no-inline-assembly
75         assembly { codehash := extcodehash(account) }
76         return (codehash != accountHash && codehash != 0x0);
77     }
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
82         (bool success, ) = recipient.call{ value: amount }("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
86       return functionCall(target, data, "Address: low-level call failed");
87     }
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return _functionCallWithValue(target, data, 0, errorMessage);
90     }
91     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
93     }
94     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
95         require(address(this).balance >= value, "Address: insufficient balance for call");
96         return _functionCallWithValue(target, data, value, errorMessage);
97     }
98     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
99         require(isContract(target), "Address: call to non-contract");
100         // solhint-disable-next-line avoid-low-level-calls
101         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
102         if (success) {
103             return returndata;
104         } else {
105             // Look for revert reason and bubble it up if present
106             if (returndata.length > 0) {
107                 // The easiest way to bubble the revert reason is using memory via assembly
108                 // solhint-disable-next-line no-inline-assembly
109                 assembly {
110                     let returndata_size := mload(returndata)
111                     revert(add(32, returndata), returndata_size)
112                 }
113             } else {
114                 revert(errorMessage);
115             }
116         }
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
122     function feeTo() external view returns (address);
123     function feeToSetter() external view returns (address);
124     function getPair(address tokenA, address tokenB) external view returns (address pair);
125     function allPairs(uint) external view returns (address pair);
126     function allPairsLength() external view returns (uint);
127     function createPair(address tokenA, address tokenB) external returns (address pair);
128     function setFeeTo(address) external;
129     function setFeeToSetter(address) external;
130 }
131 interface IUniswapV2Pair {
132     event Approval(address indexed owner, address indexed spender, uint value);
133     event Transfer(address indexed from, address indexed to, uint value);
134     function name() external pure returns (string memory);
135     function symbol() external pure returns (string memory);
136     function decimals() external pure returns (uint8);
137     function totalSupply() external view returns (uint);
138     function balanceOf(address owner) external view returns (uint);
139     function allowance(address owner, address spender) external view returns (uint);
140     function approve(address spender, uint value) external returns (bool);
141     function transfer(address to, uint value) external returns (bool);
142     function transferFrom(address from, address to, uint value) external returns (bool);
143     function DOMAIN_SEPARATOR() external view returns (bytes32);
144     function PERMIT_TYPEHASH() external pure returns (bytes32);
145     function nonces(address owner) external view returns (uint);
146     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
147     event Mint(address indexed sender, uint amount0, uint amount1);
148     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
149     event Swap(
150         address indexed sender,
151         uint amount0In,
152         uint amount1In,
153         uint amount0Out,
154         uint amount1Out,
155         address indexed to
156     );
157     event Sync(uint112 reserve0, uint112 reserve1);
158     function MINIMUM_LIQUIDITY() external pure returns (uint);
159     function factory() external view returns (address);
160     function token0() external view returns (address);
161     function token1() external view returns (address);
162     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
163     function price0CumulativeLast() external view returns (uint);
164     function price1CumulativeLast() external view returns (uint);
165     function kLast() external view returns (uint);
166     function mint(address to) external returns (uint liquidity);
167     function burn(address to) external returns (uint amount0, uint amount1);
168     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
169     function skim(address to) external;
170     function sync() external;
171     function initialize(address, address) external;
172 }
173 
174 interface IUniswapV2Router01 {
175     function factory() external pure returns (address);
176     function WETH() external pure returns (address);
177     function addLiquidity(
178         address tokenA,
179         address tokenB,
180         uint amountADesired,
181         uint amountBDesired,
182         uint amountAMin,
183         uint amountBMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountA, uint amountB, uint liquidity);
187     function addLiquidityETH(
188         address token,
189         uint amountTokenDesired,
190         uint amountTokenMin,
191         uint amountETHMin,
192         address to,
193         uint deadline
194     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
195     function removeLiquidity(
196         address tokenA,
197         address tokenB,
198         uint liquidity,
199         uint amountAMin,
200         uint amountBMin,
201         address to,
202         uint deadline
203     ) external returns (uint amountA, uint amountB);
204     function removeLiquidityETH(
205         address token,
206         uint liquidity,
207         uint amountTokenMin,
208         uint amountETHMin,
209         address to,
210         uint deadline
211     ) external returns (uint amountToken, uint amountETH);
212     function removeLiquidityWithPermit(
213         address tokenA,
214         address tokenB,
215         uint liquidity,
216         uint amountAMin,
217         uint amountBMin,
218         address to,
219         uint deadline,
220         bool approveMax, uint8 v, bytes32 r, bytes32 s
221     ) external returns (uint amountA, uint amountB);
222     function removeLiquidityETHWithPermit(
223         address token,
224         uint liquidity,
225         uint amountTokenMin,
226         uint amountETHMin,
227         address to,
228         uint deadline,
229         bool approveMax, uint8 v, bytes32 r, bytes32 s
230     ) external returns (uint amountToken, uint amountETH);
231     function swapExactTokensForTokens(
232         uint amountIn,
233         uint amountOutMin,
234         address[] calldata path,
235         address to,
236         uint deadline
237     ) external returns (uint[] memory amounts);
238     function swapTokensForExactTokens(
239         uint amountOut,
240         uint amountInMax,
241         address[] calldata path,
242         address to,
243         uint deadline
244     ) external returns (uint[] memory amounts);
245     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
246         external
247         payable
248         returns (uint[] memory amounts);
249     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
250         external
251         returns (uint[] memory amounts);
252     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
253         external
254         returns (uint[] memory amounts);
255     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
256         external
257         payable
258         returns (uint[] memory amounts);
259 
260     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
261     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
262     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
263     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
264     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
265 }
266 
267 interface IUniswapV2Router02 is IUniswapV2Router01 {
268     function removeLiquidityETHSupportingFeeOnTransferTokens(
269         address token,
270         uint liquidity,
271         uint amountTokenMin,
272         uint amountETHMin,
273         address to,
274         uint deadline
275     ) external returns (uint amountETH);
276     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
277         address token,
278         uint liquidity,
279         uint amountTokenMin,
280         uint amountETHMin,
281         address to,
282         uint deadline,
283         bool approveMax, uint8 v, bytes32 r, bytes32 s
284     ) external returns (uint amountETH);
285     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
286         uint amountIn,
287         uint amountOutMin,
288         address[] calldata path,
289         address to,
290         uint deadline
291     ) external;
292     function swapExactETHForTokensSupportingFeeOnTransferTokens(
293         uint amountOutMin,
294         address[] calldata path,
295         address to,
296         uint deadline
297     ) external payable;
298     function swapExactTokensForETHSupportingFeeOnTransferTokens(
299         uint amountIn,
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external;
305 }
306 
307 interface IWETH {
308     function deposit() external payable;
309     function balanceOf(address _owner) external returns (uint256);
310     function transfer(address _to, uint256 _value) external returns (bool);
311     function withdraw(uint256 _amount) external;
312 }
313 
314 
315 contract Ownable is Context {
316     address private _owner;
317     address private _previousOwner;
318     uint256 private _lockTime;
319 
320     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
321 
322     constructor () {
323         address msgSender = _msgSender();
324         _owner = msgSender;
325         emit OwnershipTransferred(address(0), msgSender);
326     }
327     function owner() public view returns (address) {
328         return _owner;
329     }
330     modifier onlyOwner() {
331         require(_owner == _msgSender(), "Ownable: caller is not the owner");
332         _;
333     }
334     function renounceOwnership() external virtual onlyOwner {
335         emit OwnershipTransferred(_owner, address(0));
336         _owner = address(0);
337         //The following line avoids exploiting previous lock/unlock to regain ownership
338         _previousOwner = address(0);
339     }
340     function transferOwnership(address newOwner) external virtual onlyOwner {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         emit OwnershipTransferred(_owner, newOwner);
343         _owner = newOwner;
344     }
345   
346 }
347 
348 contract Lilly is Context, IERC20, Ownable {
349     using SafeMath for uint256;
350     using Address for address;
351 
352     mapping (address => uint256) private _rOwned;
353     mapping (address => uint256) private _tOwned;
354     mapping (address => mapping (address => uint256)) private _allowances;
355 
356     mapping (address => bool) private _isExcludedFromFee;
357     mapping (address => bool) private _isExcludedFromReward;
358     mapping (address => bool) private _isExcludedFromMaxTxLimit;
359     address[] private _excludedAddressesFromReward;
360    
361     string constant private _name = "Lilly Finance";
362     string constant private _symbol = "Ly";
363     uint256 constant private _decimals = 9;
364 
365     uint256 private constant MAX = ~uint256(0);
366     uint256 private _tTotal = 120000000000000000  * 10**9;
367     uint256 private _rTotal = (MAX - (MAX % _tTotal));
368     uint256 private _tFeeTotal;
369     uint256 private _tBurnTotal;
370    
371     address payable public marketingAddress = payable(0xF6a88B388D253dF0e3C1223A055a7682F8c680aA);
372     address payable public foundationAddress = payable(0x6312839503eb9298d037687C1492ab815888dC31);
373     address public  deadAddress = 0x000000000000000000000000000000000000dEaD;
374     address private wallet1 = 0xEd2B288bCc7CE04fC120b05b87E1D91a4f8c4ffF;
375     address private wallet2 = 0xC014D92ce5c35268188294924b3d7179aEAb8876;
376     address private wallet3 = 0x598961cf3a6905E684b85136C7D7b7cF3a961Cff;
377   
378 
379     uint256 public _taxFee = 3;
380     uint256 private _previousTaxFee = _taxFee;
381     uint256 public _liquidityFee = 1;
382     uint256 private _previousLiquidityFee = _liquidityFee;
383     uint256 public _burnFee = 2;
384     uint256 private _previousBurnFee = _burnFee;
385     uint256 public _marketingFee= 3;
386     uint256 private _previousMarketingFee = _marketingFee;
387     uint256 public _foundationFee= 1;
388     uint256 private _previousfoundatoinFee = _foundationFee;
389 
390     IUniswapV2Router02 public immutable uniswapV2RouterObject;
391     address public immutable uniswapV2wETHAddr;
392     address public uniswapV2PairAddr;
393     address public immutable uniswapV2RouterAddr;
394     address constant private _blackholeZero = address(0);
395     address constant private _blackholeDead = 0x000000000000000000000000000000000000dEaD;
396     
397     bool inSwapAndLiquify;
398     bool public swapAndLiquifyEnabled = true;
399 
400     bool public tradingEnabled;
401     
402     uint256 public _maxTxAmount = _tTotal.div(100);
403     uint256 public numTokensSellToAddToLiquidity = 12000000000 * 10**9;
404     
405     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
406     event SwapAndLiquifyEnabledUpdated(bool enabled);
407     event SwapAndLiquify(
408         uint256 tokensSwapped,
409         uint256 ethReceived,
410         uint256 tokensIntoLiqudity
411     );
412     
413     modifier lockTheSwap {
414         inSwapAndLiquify = true;
415         _;
416         inSwapAndLiquify = false;
417     }
418     
419     constructor() {
420         _rOwned[_msgSender()] = _rTotal;
421 
422         address _uniswapV2RouterAddr=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
423 
424 
425         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddr);
426         uniswapV2RouterAddr = _uniswapV2RouterAddr;
427 		uniswapV2wETHAddr = _uniswapV2Router.WETH();
428          // Create a uniswap pair for this new token
429         uniswapV2PairAddr = IUniswapV2Factory(_uniswapV2Router.factory())
430             .createPair(address(this), _uniswapV2Router.WETH());
431         // set the rest of the contract variables
432         uniswapV2RouterObject = _uniswapV2Router;
433         
434         //exclude owner and this contract from fee
435         _isExcludedFromFee[owner()] = true;
436         _isExcludedFromFee[address(this)] = true;
437         _isExcludedFromFee[wallet1] = true;
438         _isExcludedFromFee[wallet2] = true;
439         _isExcludedFromFee[wallet3] = true;
440         _isExcludedFromFee[deadAddress] = true;
441         _isExcludedFromFee[marketingAddress] = true;
442         _isExcludedFromFee[foundationAddress] = true;
443 
444         _isExcludedFromMaxTxLimit[wallet1] = true;
445         _isExcludedFromMaxTxLimit[wallet2] = true;
446         _isExcludedFromMaxTxLimit[wallet3] = true;
447         _isExcludedFromMaxTxLimit[deadAddress] = true;
448         _isExcludedFromMaxTxLimit[marketingAddress] = true;
449         _isExcludedFromMaxTxLimit[foundationAddress] = true;
450         
451         emit Transfer(_blackholeZero, _msgSender(), _tTotal);
452 }
453     function enableTrading(bool trading) external onlyOwner
454     {
455         tradingEnabled = trading;
456     }
457 
458     function name() external pure returns (string memory) {
459         return _name;
460     }
461 
462     function symbol() external pure returns (string memory) {
463         return _symbol;
464     }
465 
466     function decimals() external pure returns (uint8) {
467         return uint8(_decimals);
468     }
469 
470     function totalSupply() external view override returns (uint256) {
471         return _tTotal;
472     }
473 
474     function balanceOf(address account) public view override returns (uint256) {
475         if (_isExcludedFromReward[account]) return _tOwned[account];
476         return tokenFromReflection(_rOwned[account]);
477     }
478 
479     function transfer(address recipient, uint256 amount) external override returns (bool) {
480         _transfer(_msgSender(), recipient, amount);
481         return true;
482     }
483 
484     function allowance(address owner, address spender) external view override returns (uint256) {
485         return _allowances[owner][spender];
486     }
487 
488     function approve(address spender, uint256 amount) external override returns (bool) {
489         _approve(_msgSender(), spender, amount);
490         return true;
491     }
492 
493     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
494         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
495         _transfer(sender, recipient, amount);
496         return true;
497     }
498 
499     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
501         return true;
502     }
503 
504     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
505         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
506         return true;
507     }
508 
509     function isExcludedFromReward(address account) external view returns (bool) {
510         return _isExcludedFromReward[account];
511     }
512 
513     function totalFees() internal view returns (uint256) {
514         return _taxFee.add(_liquidityFee).add(_burnFee).add(_marketingFee).add(_foundationFee);
515     }
516 
517     function deliver(uint256 tAmount) external {
518         address sender = _msgSender();
519         require(!_isExcludedFromReward[sender], "Excluded addresses cannot call this function");
520         (uint256 rAmount,,,,,,) = _getValues(tAmount);
521         _rOwned[sender] = _rOwned[sender].sub(rAmount);
522         _rTotal = _rTotal.sub(rAmount);
523         _tFeeTotal = _tFeeTotal.add(tAmount);
524     }
525 
526     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
527         require(tAmount <= _tTotal, "Amount must be less than supply");
528         if (!deductTransferFee) {
529             (uint256 rAmount,,,,,,) = _getValues(tAmount);
530             return rAmount;
531         } else {
532             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
533             return rTransferAmount;
534         }
535     }
536 
537     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
538         require(rAmount <= _rTotal, "Amount must be less than total reflections");
539         uint256 currentRate =  _getRate();
540         return rAmount.div(currentRate);
541     }
542 
543     function excludeFromReward(address account) external onlyOwner() {
544       
545         require(!_isExcludedFromReward[account], "Account is already excluded");
546         if(_rOwned[account] > 0) {
547             _tOwned[account] = tokenFromReflection(_rOwned[account]);
548         }
549         _isExcludedFromReward[account] = true;
550         _excludedAddressesFromReward.push(account);
551     }
552 
553     function includeInReward(address account) external onlyOwner() {
554         require(_isExcludedFromReward[account], "Account is already excluded");
555         for (uint256 i = 0; i < _excludedAddressesFromReward.length; i++) {
556             if (_excludedAddressesFromReward[i] == account) {
557                 _excludedAddressesFromReward[i] = _excludedAddressesFromReward[_excludedAddressesFromReward.length - 1];
558                 _tOwned[account] = 0;
559                 _isExcludedFromReward[account] = false;
560                 _excludedAddressesFromReward.pop();
561                 break;
562             }
563         }
564     }
565    
566     //Allow excluding from fee certain contracts, usually lock or payment contracts, but not the router or the pool.
567     function excludeFromFee(address account) external onlyOwner {
568         if (account.isContract() && account != uniswapV2PairAddr && account != uniswapV2RouterAddr)
569         _isExcludedFromFee[account] = true;
570     }
571     // Do not include back this contract. Owner can renounce being feeless.
572     function includeInFee(address account) external onlyOwner {
573         if (account != address(this))
574         _isExcludedFromFee[account] = false;
575     }
576 
577     function includeInMaxTxLimit(address account) external onlyOwner
578     {
579         _isExcludedFromMaxTxLimit[account] = false;
580     }
581 
582     function excludeFromMaxTxLimit(address account) external onlyOwner
583     {
584         _isExcludedFromMaxTxLimit[account] = true;
585     }
586 
587     function changenumTokensSellToAddToLiquidity(uint256 num) external onlyOwner
588     {
589         numTokensSellToAddToLiquidity = num;
590     }
591     
592     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
593         _taxFee = taxFee;
594     }
595     
596     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
597         _liquidityFee = liquidityFee;
598     }
599     
600     function setMarketingPercent(uint256 MarketingFee) external onlyOwner() {
601         _marketingFee = MarketingFee;
602     }
603 
604     function setFoundationPercent(uint256 FoundationFee) external onlyOwner() {
605         _foundationFee = FoundationFee;
606     }
607 
608     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
609         _burnFee= burnFee;
610     }
611    
612     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
613         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
614             10**2
615         );
616     }
617 
618     function setMarketingWallet(address wallet) external onlyOwner()
619     {
620         marketingAddress = payable(wallet);
621     }
622 
623     function setFoundationWallet(address wallet) external onlyOwner()
624     {
625         foundationAddress = payable(wallet);
626     }
627 
628     
629     function setDeadWallet(address wallet) external onlyOwner()
630     {
631         deadAddress = wallet;
632     }
633 
634     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner() {
635         swapAndLiquifyEnabled = _enabled;
636         emit SwapAndLiquifyEnabledUpdated(_enabled);
637     }
638     
639     
640     receive() external payable {}
641 
642     function _reflectFee(uint256 rFee, uint256 tFee) private {
643         _rTotal = _rTotal.sub(rFee);
644         _tFeeTotal = _tFeeTotal.add(tFee);
645        
646     }
647 
648     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
649         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn,uint256 tLiquidity) = _getTValues(tAmount);
650         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
651         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
652     }
653 
654     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
655         uint256 tFee = calculateTaxFee(tAmount);
656         uint256 tBurn = calculateBurnFee(tAmount);
657         uint256 tLiquidity = calculateLiquidityFee(tAmount);
658         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
659         return (tTransferAmount, tFee, tBurn, tLiquidity);
660     }
661 
662     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
663         uint256 rAmount = tAmount.mul(currentRate);
664         uint256 rFee = tFee.mul(currentRate);
665         uint256 rBurn = tBurn.mul(currentRate);
666         uint256 rLiquidity = tLiquidity.mul(currentRate);
667         uint256 totalTax = rFee.add(rBurn).add(rLiquidity);
668         uint256 rTransferAmount = rAmount.sub(totalTax);
669         return (rAmount, rTransferAmount, rFee);
670     }
671 
672     function _getRate() private view returns(uint256) {
673         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
674         return rSupply.div(tSupply);
675     }
676 
677     function _getCurrentSupply() private view returns(uint256, uint256) {
678         uint256 rSupply = _rTotal;
679         uint256 tSupply = _tTotal;      
680         for (uint256 i = 0; i < _excludedAddressesFromReward.length; i++) {
681             if (_rOwned[_excludedAddressesFromReward[i]] > rSupply || _tOwned[_excludedAddressesFromReward[i]] > tSupply) return (_rTotal, _tTotal);
682             rSupply = rSupply.sub(_rOwned[_excludedAddressesFromReward[i]]);
683             tSupply = tSupply.sub(_tOwned[_excludedAddressesFromReward[i]]);
684         }
685         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
686         return (rSupply, tSupply);
687     }
688     
689     
690     
691     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
692         return _amount.mul(_taxFee).div(
693             10**2
694         );
695     }
696 
697     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
698     
699      return _amount.mul(_burnFee).div(10**2);
700     
701     }
702 
703     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
704         return _amount.mul(_marketingFee).div(
705             10**2
706         );
707     }
708 
709      function calculateFoundationFee(uint256 _amount) private view returns (uint256) {
710         return _amount.mul(_foundationFee).div(
711             10**2
712         );
713     }
714 
715      function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
716         return _amount.mul(_liquidityFee).div(
717             10**2
718         );
719     }
720 
721     function _takeLiquidity(uint256 tLiquidity) private {
722         uint256 currentRate =  _getRate();
723         uint256 rLiquidity = tLiquidity.mul(currentRate);
724         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
725         if(_isExcludedFromReward[address(this)])
726             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
727     }
728 
729     function _takeBurn(address sender, uint256 tBurn) private {
730         
731         _tOwned[deadAddress] = _tOwned[deadAddress].add(tBurn);
732         if(tBurn > 0)
733         {emit Transfer(sender, deadAddress, tBurn);}
734          
735     }
736     
737     function _takeMarketing(address sender, uint256 tMarketing) private returns(uint256){
738       uint256 rMarketing = calculateMarketingFee(tMarketing);
739       _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
740       _rOwned[sender] = _rOwned[sender].sub(rMarketing);
741       emit Transfer(sender, address(this), rMarketing);
742          if(_isExcludedFromReward[address(this)])
743             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
744       return rMarketing;
745     }
746 
747     function _takeFoundation(address sender, uint256 tFoundation) private returns(uint256){
748       uint256 rFoundation = calculateFoundationFee(tFoundation);
749       _rOwned[address(this)] = _rOwned[address(this)].add(rFoundation);
750       _rOwned[sender] = _rOwned[sender].sub(rFoundation);
751       emit Transfer(sender, address(this), rFoundation);
752          if(_isExcludedFromReward[address(this)])
753             _tOwned[address(this)] = _tOwned[address(this)].add(tFoundation);
754       return rFoundation;
755     }
756     
757     
758     function removeAllFee() private {
759         if(_taxFee == 0 && _burnFee == 0 && _liquidityFee == 0) return;
760         
761         _previousTaxFee = _taxFee;
762         _previousBurnFee = _burnFee;
763         _previousLiquidityFee = _liquidityFee;
764         
765         _taxFee = 0;
766         _burnFee = 0;
767         _liquidityFee = 0;
768     }
769     
770     function restoreAllFee() private {
771         _taxFee = _previousTaxFee;
772         _burnFee = _previousBurnFee;
773         _liquidityFee = _previousLiquidityFee;
774     }
775 
776     
777 
778     function isExcludedFromFee(address account) public view returns(bool) {
779         return _isExcludedFromFee[account];
780     }
781 
782     function _approve(address owner, address spender, uint256 amount) private {
783         require(owner != address(0), "ERC20: approve from the zero address");
784         require(spender != address(0), "ERC20: approve to the zero address");
785 
786         _allowances[owner][spender] = amount;
787         emit Approval(owner, spender, amount);
788     }
789 
790     function _transfer(
791         address from,
792         address to,
793         uint256 amount
794     ) private {
795         require(from != address(0), "ERC20: transfer from the zero address");
796         require(to != address(0), "ERC20: transfer to the zero address");
797         require(amount > 0, "Transfer amount must be greater than zero");
798         if(from != owner()) {require(tradingEnabled, "Trading is not enabled yet");}
799         if(from != owner() && to != owner())
800         {
801             if(!_isExcludedFromMaxTxLimit[from]){
802             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");}
803         }
804      //indicates if fee should be deducted from transfer
805         uint8 takeFee = 1;
806         
807           // is the token balance of this contract address over the min number of
808         // tokens that we need to initiate a swap + liquidity lock?
809         // also, don't get caught in a circular liquidity event.
810         // also, don't swap & liquify if sender is uniswap pair.
811         uint256 contractTokenBalance = balanceOf(address(this));
812      
813         if(contractTokenBalance >= _maxTxAmount)
814         {
815             contractTokenBalance = _maxTxAmount;
816         }
817         
818         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
819         if (
820             overMinTokenBalance &&
821             !inSwapAndLiquify &&
822             from != uniswapV2PairAddr &&
823             swapAndLiquifyEnabled &&
824 			takeFee == 1 //avoid costly liquify on p2p sends
825         ) {
826             //add liquidity
827             swapAndLiquify(contractTokenBalance);
828         }
829        
830 
831        
832         //if any account belongs to _isExcludedFromFee account then remove the fee
833         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
834             takeFee = 0;
835         }
836 
837         if(from != uniswapV2PairAddr && to != uniswapV2PairAddr)
838         {
839             takeFee = 0;
840         }
841 
842        
843         if(takeFee == 1)
844         {
845         uint256 marketingAmount = _takeMarketing(from, amount);
846         uint256 foundationAmount = _takeFoundation(from, amount);
847         amount = amount - (marketingAmount+foundationAmount);}
848 
849       
850         //transfer amount, it will take tax, burn, liquidity fee
851         _tokenTransfer(from,to,amount,takeFee);
852     }
853 
854     
855 	
856     function swapAndLiquify(uint256 tokensToLiquify) private lockTheSwap {
857         
858         uint256 tokensToLP = tokensToLiquify.mul(_liquidityFee).div(totalFees()).div(2);
859         uint256 amountToSwap = tokensToLiquify.sub(tokensToLP);
860 
861         address[] memory path = new address[](2);
862         path[0] = address(this);
863         path[1] = uniswapV2wETHAddr;
864 
865         _approve(address(this), address(uniswapV2RouterAddr), tokensToLiquify);
866         uniswapV2RouterObject.swapExactTokensForETHSupportingFeeOnTransferTokens(
867             amountToSwap,
868             0,
869             path,
870             address(this),
871             block.timestamp
872         );
873 
874         uint256 ethBalance = address(this).balance;
875         uint256 ethFeeFactor = totalFees().sub((_liquidityFee).div(2));
876 
877         uint256 ethForLiquidity = ethBalance.mul(_liquidityFee).div(ethFeeFactor).div(2);
878         uint256 ethForMarketing = ethBalance.mul(_marketingFee).div(ethFeeFactor);
879         uint256 ethForFounders = ethBalance.mul(_foundationFee).div(ethFeeFactor);
880      
881         addLiquidity(tokensToLP, ethForLiquidity);
882 
883         payable(marketingAddress).transfer(ethForMarketing);
884         payable(foundationAddress).transfer(ethForFounders);
885        
886     }
887 
888     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
889         // approve token transfer to cover all possible scenarios
890         _approve(address(this), address(uniswapV2RouterAddr), tokenAmount);
891 
892         // add the liquidity
893         uniswapV2RouterObject.addLiquidityETH{value: ethAmount}(
894             address(this),
895             tokenAmount,
896             0, // slippage is unavoidable
897             0, // slippage is unavoidable
898             owner(),
899             block.timestamp
900         );
901     }
902 
903     //this method is responsible for taking all fee, if takeFee is true
904     function _tokenTransfer(address sender, address recipient, uint256 amount,uint8 feePlan) private {
905         if(feePlan == 0) //no fees
906             removeAllFee();
907         
908         if (_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
909             _transferFromExcluded(sender, recipient, amount);
910         } else if (!_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
911             _transferToExcluded(sender, recipient, amount);
912         } else if (!_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
913             _transferStandard(sender, recipient, amount);
914         } else if (_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
915             _transferBothExcluded(sender, recipient, amount);
916         } else {
917             _transferStandard(sender, recipient, amount);
918         }
919         
920         if(feePlan != 1) //restore standard fees
921             restoreAllFee();
922     }
923 
924     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
925         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
926         _rOwned[sender] = _rOwned[sender].sub(rAmount);
927         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
928         _takeLiquidity(tLiquidity);
929         _takeBurn(sender, tBurn);
930         _reflectFee(rFee,tFee);
931         emit Transfer(sender, recipient, tTransferAmount);
932       
933        
934     }
935 
936     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
937         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
938         _rOwned[sender] = _rOwned[sender].sub(rAmount);
939         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
940         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
941         _takeLiquidity(tLiquidity);
942         _takeBurn(sender, tBurn);       
943         _reflectFee(rFee, tFee);
944         emit Transfer(sender, recipient, tTransferAmount);
945      
946      
947     }
948 
949     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
950         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
951         
952         _tOwned[sender] = _tOwned[sender].sub(tAmount);
953         _rOwned[sender] = _rOwned[sender].sub(rAmount);
954         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
955         _reflectFee(rFee, tFee);
956         _takeLiquidity(tLiquidity);
957         _takeBurn(sender, tBurn);
958         emit Transfer(sender, recipient, tTransferAmount);
959       
960 
961     }
962 
963     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
964         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
965         _tOwned[sender] = _tOwned[sender].sub(tAmount);
966         _rOwned[sender] = _rOwned[sender].sub(rAmount);
967         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
968         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
969         _takeLiquidity(tLiquidity);
970         _takeBurn(sender, tBurn);
971         _reflectFee(rFee, tFee);
972         emit Transfer(sender, recipient, tTransferAmount);
973      
974     }
975 
976 }