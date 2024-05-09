1 // SPDX-License-Identifier: Unlicensed
2 //taking over the Esports scene!!!
3 //@devs Fid and Hamp
4 //remake of first contract cuz of code failure
5 //projectfeenix.games 
6 //https://t.me/projectfeenix 
7 //all the links http://linktr.ee/projectfeenix
8 pragma solidity ^0.6.12;
9     abstract contract Context {
10         function _msgSender() internal view virtual returns (address payable) {
11             return msg.sender;
12         }
13         function _msgData() internal view virtual returns (bytes memory) {
14             this;
15              msg.data;
16         }
17     }
18     interface IERC20 {
19         function totalSupply() external view returns (uint256);
20         function balanceOf(address account) external view returns (uint256);
21         function transfer(address recipient, uint256 amount) external returns (bool);
22         function allowance(address owner, address spender) external view returns (uint256);
23         function approve(address spender, uint256 amount) external returns (bool);
24         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25         event Transfer(address indexed from, address indexed to, uint256 value);
26         event Approval(address indexed owner, address indexed spender, uint256 value);
27     }
28 
29     //safemath is copied cuz why reinvent the wheel:) omegalul
30     library SafeMath {
31         /**
32         * @dev Returns the addition of two unsigned integers, reverting on
33         * overflow.
34         *
35         * Counterpart to Solidity's `+` operator.
36         *
37         * Requirements:
38         *
39         * - Addition cannot overflow.
40         */
41         function add(uint256 a, uint256 b) internal pure returns (uint256) {
42             uint256 c = a + b;
43             require(c >= a, "SafeMath: addition overflow");
44 
45             return c;
46         }
47 
48         /**
49         * @dev Returns the subtraction of two unsigned integers, reverting on
50         * overflow (when the result is negative).
51         *
52         * Counterpart to Solidity's `-` operator.
53         *
54         * Requirements:
55         *
56         * - Subtraction cannot overflow.
57         */
58         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59             return sub(a, b, "SafeMath: subtraction overflow");
60         }
61 
62         /**
63         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
64         * overflow (when the result is negative).
65         *
66         * Counterpart to Solidity's `-` operator.
67         *
68         * Requirements:
69         *
70         * - Subtraction cannot overflow.
71         */
72         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73             require(b <= a, errorMessage);
74             uint256 c = a - b;
75 
76             return c;
77         }
78 
79         /**
80         * @dev Returns the multiplication of two unsigned integers, reverting on
81         * overflow.
82         *
83         * Counterpart to Solidity's `*` operator.
84         *
85         * Requirements:
86         *
87         * - Multiplication cannot overflow.
88         */
89         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91             // benefit is lost if 'b' is also tested.
92             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
93             if (a == 0) {
94                 return 0;
95             }
96 
97             uint256 c = a * b;
98             require(c / a == b, "SafeMath: multiplication overflow");
99 
100             return c;
101         }
102 
103         /**
104         * @dev Returns the integer division of two unsigned integers. Reverts on
105         * division by zero. The result is rounded towards zero.
106         *
107         * Counterpart to Solidity's `/` operator. Note: this function uses a
108         * `revert` opcode (which leaves remaining gas untouched) while Solidity
109         * uses an invalid opcode to revert (consuming all remaining gas).
110         *
111         * Requirements:
112         *
113         * - The divisor cannot be zero.
114         */
115         function div(uint256 a, uint256 b) internal pure returns (uint256) {
116             return div(a, b, "SafeMath: division by zero");
117         }
118 
119         /**
120         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
121         * division by zero. The result is rounded towards zero.
122         *
123         * Counterpart to Solidity's `/` operator. Note: this function uses a
124         * `revert` opcode (which leaves remaining gas untouched) while Solidity
125         * uses an invalid opcode to revert (consuming all remaining gas).
126         *
127         * Requirements:
128         *
129         * - The divisor cannot be zero.
130         */
131         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132             require(b > 0, errorMessage);
133             uint256 c = a / b;
134             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136             return c;
137         }
138 
139         /**
140         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141         * Reverts when dividing by zero.
142         *
143         * Counterpart to Solidity's `%` operator. This function uses a `revert`
144         * opcode (which leaves remaining gas untouched) while Solidity uses an
145         * invalid opcode to revert (consuming all remaining gas).
146         *
147         * Requirements:
148         *
149         * - The divisor cannot be zero.
150         */
151         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152             return mod(a, b, "SafeMath: modulo by zero");
153         }
154 
155         /**
156         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157         * Reverts with custom message when dividing by zero.
158         *
159         * Counterpart to Solidity's `%` operator. This function uses a `revert`
160         * opcode (which leaves remaining gas untouched) while Solidity uses an
161         * invalid opcode to revert (consuming all remaining gas).
162         *
163         * Requirements:
164         *
165         * - The divisor cannot be zero.
166         */
167         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168             require(b != 0, errorMessage);
169             return a % b;
170         }
171     }
172     //same with lib
173     library Address {
174         function isContract(address account) internal view returns (bool) {
175             bytes32 codehash;
176             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
177             assembly { codehash := extcodehash(account) }
178             return (codehash != accountHash && codehash != 0x0);
179         }
180         function sendValue(address payable recipient, uint256 amount) internal {
181             require(address(this).balance >= amount, "Address: insufficient balance");
182             (bool success, ) = recipient.call{ value: amount }("");
183             require(success, "Address: unable to send value, recipient may have reverted");
184         }
185         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionCall(target, data, "Address: low-level call failed");
187         }
188         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
189             return _functionCallWithValue(target, data, 0, errorMessage);
190         }
191         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
192             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193         }
194         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
195             require(address(this).balance >= value, "Address: insufficient balance for call");
196             return _functionCallWithValue(target, data, value, errorMessage);
197         }
198 
199         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
200             require(isContract(target), "Address: call to non-contract");
201             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
202             if (success) {
203                 return returndata;
204             } else {
205                 if (returndata.length > 0) {
206                     assembly {
207                         let returndata_size := mload(returndata)
208                         revert(add(32, returndata), returndata_size)
209                     }
210                 } else {
211                     revert(errorMessage);
212                 }
213             }
214         }
215     }
216     contract Ownable is Context {
217         address private _owner;
218         address private _previousOwner;
219 
220         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221         constructor () internal {
222             address msgSender = _msgSender();
223             _owner = msgSender;
224             emit OwnershipTransferred(address(0), msgSender);
225         }
226         function owner() public view returns (address) {
227             return _owner;
228         }
229         modifier onlyOwner() {
230             require(_owner == _msgSender(), "Ownable: caller is not the owner");
231             _;
232         }
233         function renounceOwnership() public virtual onlyOwner {
234             emit OwnershipTransferred(_owner, address(0));
235             _owner = address(0);
236         }
237         function transferOwnership(address newOwner) public virtual onlyOwner {
238             require(newOwner != address(0), "Ownable: new owner is the zero address");
239             emit OwnershipTransferred(_owner, newOwner);
240             _owner = newOwner;
241         }
242     }  
243 
244     interface IUniswapV2Factory {
245         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
246 
247         function feeTo() external view returns (address);
248         function feeToSetter() external view returns (address);
249         function getPair(address tokenA, address tokenB) external view returns (address pair);
250         function allPairs(uint) external view returns (address pair);
251         function allPairsLength() external view returns (uint);
252         function createPair(address tokenA, address tokenB) external returns (address pair);
253         function setFeeTo(address) external;
254         function setFeeToSetter(address) external;
255     } 
256     interface IUniswapV2Pair {
257         event Approval(address indexed owner, address indexed spender, uint value);
258         event Transfer(address indexed from, address indexed to, uint value);
259 
260         function name() external pure returns (string memory);
261         function symbol() external pure returns (string memory);
262         function decimals() external pure returns (uint8);
263         function totalSupply() external view returns (uint);
264         function balanceOf(address owner) external view returns (uint);
265         function allowance(address owner, address spender) external view returns (uint);
266         function approve(address spender, uint value) external returns (bool);
267         function transfer(address to, uint value) external returns (bool);
268         function transferFrom(address from, address to, uint value) external returns (bool);
269         function DOMAIN_SEPARATOR() external view returns (bytes32);
270         function PERMIT_TYPEHASH() external pure returns (bytes32);
271         function nonces(address owner) external view returns (uint);
272         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
273         event Swap(
274             address indexed sender,
275             uint amount0In,
276             uint amount1In,
277             uint amount0Out,
278             uint amount1Out,
279             address indexed to
280         );
281         event Sync(uint112 reserve0, uint112 reserve1);
282         function MINIMUM_LIQUIDITY() external pure returns (uint);
283         function factory() external view returns (address);
284         function token0() external view returns (address);
285         function token1() external view returns (address);
286         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
287         function price0CumulativeLast() external view returns (uint);
288         function price1CumulativeLast() external view returns (uint);
289         function kLast() external view returns (uint);
290         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
291         function skim(address to) external;
292         function sync() external;
293         function initialize(address, address) external;
294     }
295 
296     interface IUniswapV2Router01 {
297         function factory() external pure returns (address);
298         function WETH() external pure returns (address);
299 
300         function addLiquidity(
301             address tokenA,
302             address tokenB,
303             uint amountADesired,
304             uint amountBDesired,
305             uint amountAMin,
306             uint amountBMin,
307             address to,
308             uint deadline
309         ) external returns (uint amountA, uint amountB, uint liquidity);
310         function addLiquidityETH(
311             address token,
312             uint amountTokenDesired,
313             uint amountTokenMin,
314             uint amountETHMin,
315             address to,
316             uint deadline
317         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
318         function swapExactTokensForTokens(
319             uint amountIn,
320             uint amountOutMin,
321             address[] calldata path,
322             address to,
323             uint deadline
324         ) external returns (uint[] memory amounts);
325         function swapTokensForExactTokens(
326             uint amountOut,
327             uint amountInMax,
328             address[] calldata path,
329             address to,
330             uint deadline
331         ) external returns (uint[] memory amounts);
332         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
333             external
334             payable
335             returns (uint[] memory amounts);
336         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
337             external
338             returns (uint[] memory amounts);
339         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
340             external
341             returns (uint[] memory amounts);
342         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
343             external
344             payable
345             returns (uint[] memory amounts);
346 
347         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
348         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
349         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
350         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
351         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
352     }
353 
354     interface IUniswapV2Router02 is IUniswapV2Router01 {
355         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
356             uint amountIn,
357             uint amountOutMin,
358             address[] calldata path,
359             address to,
360             uint deadline
361         ) external;
362         function swapExactETHForTokensSupportingFeeOnTransferTokens(
363             uint amountOutMin,
364             address[] calldata path,
365             address to,
366             uint deadline
367         ) external payable;
368         function swapExactTokensForETHSupportingFeeOnTransferTokens(
369             uint amountIn,
370             uint amountOutMin,
371             address[] calldata path,
372             address to,
373             uint deadline
374         ) external;
375     }
376 
377     // Contract Feenix starts
378     contract ProjectFeenixv2 is Context, IERC20, Ownable {
379 
380         using SafeMath for uint256;
381         using Address for address;
382         //strings
383         string private _name = 'ProjectFeenixv2';
384         string private _symbol = 'FeenixV2';
385         uint8 private _decimals = 9;
386         uint256 private _taxFee = 2; 
387         uint256 private _devFee = 5;
388         //tax fee
389         uint256 private _previousTaxFee = _taxFee;
390         uint256 private _previousdevFee = _devFee;
391         uint256 private constant MAX = ~uint256(0);
392         uint256 private _tTotal = 700000000000000e9;
393         uint256 private _rTotal = (MAX - (MAX % _tTotal));
394         uint256 private _tFeeTotal;
395         uint256 private _maxTxAmount = 5000000000000e9;
396         //mapping
397         mapping (address => uint256) private _rOwned;
398         mapping (address => uint256) private _tOwned;
399         mapping (address => mapping (address => uint256)) private _allowances;
400         mapping (address => bool) private _isExcludedFromFee;
401         mapping (address => bool) private _isExcluded;
402         address[] private _excluded;  
403         address payable public _developmentWalletAddress;
404 
405         IUniswapV2Router02 public immutable uniswapV2Router;
406         address public immutable uniswapV2Pair;
407 
408         bool inSwap = false;
409         bool public swapEnabled = true;
410 
411         //minimum amount of tokens to be swaped => 1M
412         uint256 private _numOfTokensToExchangeFordevFee = 1 * 10**6 * 10**9;
413         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
414         event SwapEnabledUpdated(bool enabled);
415         modifier lockTheSwap {
416             inSwap = true;
417             _;
418             inSwap = false;
419         }
420         constructor (address payable developmentWalletAddress) public {
421             _developmentWalletAddress = developmentWalletAddress;
422             _rOwned[_msgSender()] = _rTotal;
423 
424             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
425             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
426                 .createPair(address(this), _uniswapV2Router.WETH());
427             uniswapV2Router = _uniswapV2Router;
428             _isExcludedFromFee[owner()] = true;
429             _isExcludedFromFee[address(this)] = true;
430 
431             emit Transfer(address(0), _msgSender(), _tTotal);
432         }
433         function name() public view returns (string memory) {
434             return _name;
435         }
436         function symbol() public view returns (string memory) {
437             return _symbol;
438         }
439         function decimals() public view returns (uint8) {
440             return _decimals;
441         }
442         function totalSupply() public view override returns (uint256) {
443             return _tTotal;
444         }
445         function balanceOf(address account) public view override returns (uint256) {
446             if (_isExcluded[account]) return _tOwned[account];
447             return tokenFromReflection(_rOwned[account]);
448         }
449         function transfer(address recipient, uint256 amount) public override returns (bool) {
450             _transfer(_msgSender(), recipient, amount);
451             return true;
452         }
453         function allowance(address owner, address spender) public view override returns (uint256) {
454             return _allowances[owner][spender];
455         }
456         function approve(address spender, uint256 amount) public override returns (bool) {
457             _approve(_msgSender(), spender, amount);
458             return true;
459         }
460         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
461             _transfer(sender, recipient, amount);
462             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
463             return true;
464         }
465         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
466             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
467             return true;
468         }
469         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
470             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
471             return true;
472         }
473         function isExcluded(address account) public view returns (bool) {
474             return _isExcluded[account];
475         }
476         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
477             _isExcludedFromFee[account] = excluded;
478         }
479         function totalFees() public view returns (uint256) {
480             return _tFeeTotal;
481         }
482         function deliver(uint256 tAmount) public {
483             address sender = _msgSender();
484             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
485             (uint256 rAmount,,,,,) = _getValues(tAmount);
486             _rOwned[sender] = _rOwned[sender].sub(rAmount);
487             _rTotal = _rTotal.sub(rAmount);
488             _tFeeTotal = _tFeeTotal.add(tAmount);
489         }
490         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
491             require(tAmount <= _tTotal, "Amount must be less than supply");
492             if (!deductTransferFee) {
493                 (uint256 rAmount,,,,,) = _getValues(tAmount);
494                 return rAmount;
495             } else {
496                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
497                 return rTransferAmount;
498             }
499         }
500         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
501             require(rAmount <= _rTotal, "Amount must be less than total reflections");
502             uint256 currentRate =  _getRate();
503             return rAmount.div(currentRate);
504         }
505         function excludeAccount(address account) external onlyOwner() {
506             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
507             require(!_isExcluded[account], "Account is already excluded");
508             if(_rOwned[account] > 0) {
509                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
510             }
511             _isExcluded[account] = true;
512             _excluded.push(account);
513         }
514         function includeAccount(address account) external onlyOwner() {
515             require(_isExcluded[account], "Account is already excluded");
516             for (uint256 i = 0; i < _excluded.length; i++) {
517                 if (_excluded[i] == account) {
518                     _excluded[i] = _excluded[_excluded.length - 1];
519                     _tOwned[account] = 0;
520                     _isExcluded[account] = false;
521                     _excluded.pop();
522                     break;
523                 }
524             }
525         }
526         function removeAllFee() private {
527             if(_taxFee == 0 && _devFee == 0) return;
528             _previousTaxFee = _taxFee;
529             _previousdevFee = _devFee;
530             _taxFee = 0;
531             _devFee = 0;
532         }
533         function restoreAllFee() private {
534             _taxFee = _previousTaxFee;
535             _devFee = _previousdevFee;
536         }
537         function isExcludedFromFee(address account) public view returns(bool) {
538             return _isExcludedFromFee[account];
539         }
540         function _approve(address owner, address spender, uint256 amount) private {
541             require(owner != address(0), "ERC20: approve from the zero address");
542             require(spender != address(0), "ERC20: approve to the zero address");
543             _allowances[owner][spender] = amount;
544             emit Approval(owner, spender, amount);
545         }
546         function _transfer(address sender, address recipient, uint256 amount) private {
547             require(sender != address(0), "ERC20: transfer from the zero address");
548             require(recipient != address(0), "ERC20: transfer to the zero address");
549             require(amount > 0, "Transfer amount must be greater than zero");  
550             if(sender != owner() && recipient != owner())
551                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
552 
553             uint256 contractTokenBalance = balanceOf(address(this));
554             if(contractTokenBalance >= _maxTxAmount)
555             {
556                 contractTokenBalance = _maxTxAmount;
557             }
558             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeFordevFee;
559             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
560                 swapTokensForEth(contractTokenBalance);
561                 
562                 uint256 contractETHBalance = address(this).balance;
563                 if(contractETHBalance > 0) {
564                     sendETHTodevelopmentWalletAddress(address(this).balance);
565                 }
566             }
567             bool takeFee = true;
568             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
569                 takeFee = false;
570             }
571             _tokenTransfer(sender,recipient,amount,takeFee);
572         }
573         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
574             address[] memory path = new address[](2);
575             path[0] = address(this);
576             path[1] = uniswapV2Router.WETH();
577             _approve(address(this), address(uniswapV2Router), tokenAmount);
578             // swapping
579             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
580                 tokenAmount,
581                 0,
582                 path,
583                 address(this),
584                 block.timestamp
585             );
586         }
587         //devwallet tax to eth function
588         function sendETHTodevelopmentWalletAddress(uint256 amount) private {
589             _developmentWalletAddress.transfer(amount);
590         }
591         function manualSwap() external onlyOwner() {
592             uint256 contractBalance = balanceOf(address(this));
593             swapTokensForEth(contractBalance);
594         }
595         function manualSend() external onlyOwner() {
596             uint256 contractETHBalance = address(this).balance;
597             sendETHTodevelopmentWalletAddress(contractETHBalance);
598         }
599         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
600             if(!takeFee)
601                 removeAllFee();
602 
603             if (_isExcluded[sender] && !_isExcluded[recipient]) {
604                 _transferFromExcluded(sender, recipient, amount);
605             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
606                 _transferToExcluded(sender, recipient, amount);
607             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
608                 _transferStandard(sender, recipient, amount);
609             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
610                 _transferBothExcluded(sender, recipient, amount);
611             } else {
612                 _transferStandard(sender, recipient, amount);
613             }
614 
615             if(!takeFee)
616                 restoreAllFee();
617         }
618         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
619             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdevelopmentWalletAddress) = _getValues(tAmount);
620             _rOwned[sender] = _rOwned[sender].sub(rAmount);
621             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
622             _takedevfee(tdevelopmentWalletAddress); 
623             _reflectFee(rFee, tFee);
624             emit Transfer(sender, recipient, tTransferAmount);
625         }
626         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
627             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdevfee) = _getValues(tAmount);
628             _rOwned[sender] = _rOwned[sender].sub(rAmount);
629             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
630             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
631             _takedevfee(tdevfee);           
632             _reflectFee(rFee, tFee);
633             emit Transfer(sender, recipient, tTransferAmount);
634         }
635         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
636             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdevfee) = _getValues(tAmount);
637             _tOwned[sender] = _tOwned[sender].sub(tAmount);
638             _rOwned[sender] = _rOwned[sender].sub(rAmount);
639             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
640             _takedevfee(tdevfee);   
641             _reflectFee(rFee, tFee);
642             emit Transfer(sender, recipient, tTransferAmount);
643         }
644         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
645             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdevfee) = _getValues(tAmount);
646             _tOwned[sender] = _tOwned[sender].sub(tAmount);
647             _rOwned[sender] = _rOwned[sender].sub(rAmount);
648             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
649             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
650             _takedevfee(tdevfee);         
651             _reflectFee(rFee, tFee);
652             emit Transfer(sender, recipient, tTransferAmount);
653         }
654         function _takedevfee(uint256 tdevfee) private {
655             uint256 currentRate =  _getRate();
656             uint256 rdevfee = tdevfee.mul(currentRate);
657             _rOwned[address(this)] = _rOwned[address(this)].add(rdevfee);
658             if(_isExcluded[address(this)])
659                 _tOwned[address(this)] = _tOwned[address(this)].add(tdevfee);
660         }
661         function _reflectFee(uint256 rFee, uint256 tFee) private {
662             _rTotal = _rTotal.sub(rFee);
663             _tFeeTotal = _tFeeTotal.add(tFee);
664         }
665         receive() external payable {}
666         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
667             (uint256 tTransferAmount, uint256 tFee, uint256 tdevfee) = _getTValues(tAmount, _taxFee, _devFee);
668             uint256 currentRate =  _getRate();
669             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
670             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tdevfee);
671         }
672         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 devFee) private pure returns (uint256, uint256, uint256) {
673             uint256 tFee = tAmount.mul(taxFee).div(100);
674             uint256 tdevfee = tAmount.mul(devFee).div(100);
675             uint256 tTransferAmount = tAmount.sub(tFee).sub(tdevfee);
676             return (tTransferAmount, tFee, tdevfee);
677         }
678         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
679             uint256 rAmount = tAmount.mul(currentRate);
680             uint256 rFee = tFee.mul(currentRate);
681             uint256 rTransferAmount = rAmount.sub(rFee);
682             return (rAmount, rTransferAmount, rFee);
683         }
684         function _getRate() private view returns(uint256) {
685             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
686             return rSupply.div(tSupply);
687         }
688         function _getCurrentSupply() private view returns(uint256, uint256) {
689             uint256 rSupply = _rTotal;
690             uint256 tSupply = _tTotal;      
691             for (uint256 i = 0; i < _excluded.length; i++) {
692                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
693                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
694                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
695             }
696             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
697             return (rSupply, tSupply);
698         }
699         function _getTaxFee() private view returns(uint256) {
700             return _taxFee;
701         }
702         function _getMaxTxAmount() private view returns(uint256) {
703             return _maxTxAmount;
704         }
705         function _getETHBalance() public view returns(uint256 balance) {
706             return address(this).balance;
707         }
708         function _setTaxFee(uint256 taxFee) external onlyOwner() {
709             require(taxFee >= 0 && taxFee <= 10, 'taxFee should be in 0 - 10');
710             _taxFee = taxFee;
711         }
712         function _setdevFee(uint256 devFee) external onlyOwner() {
713             require(devFee >= 1 && devFee <= 5, 'devFee should be in 1 - 5');
714             _devFee = devFee;
715         }
716         function _setdevelopmentWalletAddress(address payable developmentWalletAddress) external onlyOwner() {
717             _developmentWalletAddress = developmentWalletAddress;
718         }
719         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
720             require(maxTxAmount >= 700000000000000e9 , 'maxTxAmount should be greater than 700000000000000e9');
721             _maxTxAmount = maxTxAmount;
722         }
723     }