1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4     abstract contract Context {
5         function _msgSender() internal view virtual returns (address payable) {
6             return msg.sender;
7         }
8 
9         function _msgData() internal view virtual returns (bytes memory) {
10             this; 
11             return msg.data;
12         }
13     }
14 
15     interface IERC20 {
16         //Return total supply
17         function totalSupply() external view returns (uint256);
18 
19         //Return amount of tokens owned by 'account'
20         function balanceOf(address account) external view returns (uint256);
21 
22         //Moves 'amount' tokens from the caller's account to 'recipient'
23         function transfer(address recipient, uint256 amount) external returns (bool);
24         //Returns a boolean value indicating whether the operation succeeded.
25 
26         //Returns the remaining number of tokens that 'spender' will be allowed to spend
27         function allowance(address owner, address spender) external view returns (uint256);
28 
29 
30         //Sets 'amount' as the allowance of 'spender' over the caller's tokens
31         function approve(address spender, uint256 amount) external returns (bool);
32 
33         //Moves 'ammount' of tokens from 'spender' to 'recipient'. Then deducts from callers allowance.
34         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35 
36         event Transfer(address indexed from, address indexed to, uint256 value);
37 
38         event Approval(address indexed owner, address indexed spender, uint256 value);
39     }
40 
41     library SafeMath {
42         function add(uint256 a, uint256 b) internal pure returns (uint256) {
43             uint256 c = a + b;
44             require(c >= a, "SafeMath: addition overflow");
45 
46             return c;
47         }
48 
49         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50             return sub(a, b, "SafeMath: subtraction overflow");
51         }
52 
53         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54             require(b <= a, errorMessage);
55             uint256 c = a - b;
56 
57             return c;
58         }
59 
60         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62             // benefit is lost if 'b' is also tested.
63             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64             if (a == 0) {
65                 return 0;
66             }
67 
68             uint256 c = a * b;
69             require(c / a == b, "SafeMath: multiplication overflow");
70 
71             return c;
72         }
73 
74         function div(uint256 a, uint256 b) internal pure returns (uint256) {
75             return div(a, b, "SafeMath: division by zero");
76         }
77 
78         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79             require(b > 0, errorMessage);
80             uint256 c = a / b;
81             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82 
83             return c;
84         }
85 
86         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87             return mod(a, b, "SafeMath: modulo by zero");
88         }
89 
90         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91             require(b != 0, errorMessage);
92             return a % b;
93         }
94     }
95 
96     library Address {
97         function isContract(address account) internal view returns (bool) {
98             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
99             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
100             // for accounts without code, i.e. 'keccak256('')'
101             bytes32 codehash;
102             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
103             // solhint-disable-next-line no-inline-assembly
104             assembly { codehash := extcodehash(account) }
105             return (codehash != accountHash && codehash != 0x0);
106         }
107 
108         function sendValue(address payable recipient, uint256 amount) internal {
109             require(address(this).balance >= amount, "Address: insufficient balance");
110 
111             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
112             (bool success, ) = recipient.call{ value: amount }("");
113             require(success, "Address: unable to send value, recipient may have reverted");
114         }
115 
116         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
117         return functionCall(target, data, "Address: low-level call failed");
118         }
119 
120 
121         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
122             return _functionCallWithValue(target, data, 0, errorMessage);
123         }
124 
125         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
126             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127         }
128 
129         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130             require(address(this).balance >= value, "Address: insufficient balance for call");
131             return _functionCallWithValue(target, data, value, errorMessage);
132         }
133 
134         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135             require(isContract(target), "Address: call to non-contract");
136 
137             // solhint-disable-next-line avoid-low-level-calls
138             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
139             if (success) {
140                 return returndata;
141             } else {
142                 // Look for revert reason and bubble it up if present
143                 if (returndata.length > 0) {
144                     // The easiest way to bubble the revert reason is using memory via assembly
145 
146                     // solhint-disable-next-line no-inline-assembly
147                     assembly {
148                         let returndata_size := mload(returndata)
149                         revert(add(32, returndata), returndata_size)
150                     }
151                 } else {
152                     revert(errorMessage);
153                 }
154             }
155         }
156     }
157 
158     contract Ownable is Context {
159         address private _owner;
160         address private _previousOwner;
161         uint256 private _lockTime;
162 
163         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
164 
165         //Initializes the contract setting the deployer as the initial owner.
166         constructor () internal {
167             address msgSender = _msgSender();
168             _owner = msgSender;
169             emit OwnershipTransferred(address(0), msgSender);
170         }
171 
172         //Returns the address of the current owner.
173         function owner() public view returns (address) {
174             return _owner;
175         }
176 
177         //Throws if called by any account other than the owner.
178         modifier onlyOwner() {
179             require(_owner == _msgSender(), "Ownable: caller is not the owner");
180             _;
181         }
182 
183         /**
184         * Leaves the contract without owner. It will not be possible to call
185         * 'onlyOwner' functions anymore. Can only be called by the current owner.
186         *
187         * NOTE: Renouncing ownership will leave the contract without an owner,
188         * thereby removing any functionality that is only available to the owner.
189         */
190         function renounceOwnership() public virtual onlyOwner {
191             emit OwnershipTransferred(_owner, address(0));
192             _owner = address(0);
193         }
194 
195         //Transfers ownership of the contract to a new account ('newOwner'), Can only be called by the current owner.
196         function transferOwnership(address newOwner) public virtual onlyOwner {
197             require(newOwner != address(0), "Ownable: new owner is the zero address");
198             emit OwnershipTransferred(_owner, newOwner);
199             _owner = newOwner;
200         }
201 
202         function getUnlockTime() public view returns (uint256) {
203             return _lockTime;
204         }
205 
206     }
207 
208     interface IUniswapV2Factory {
209         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
210 
211         function feeTo() external view returns (address);
212         function feeToSetter() external view returns (address);
213 
214         function getPair(address tokenA, address tokenB) external view returns (address pair);
215         function allPairs(uint) external view returns (address pair);
216         function allPairsLength() external view returns (uint);
217 
218         function createPair(address tokenA, address tokenB) external returns (address pair);
219 
220         function setFeeTo(address) external;
221         function setFeeToSetter(address) external;
222     }
223 
224     interface IUniswapV2Pair {
225         event Approval(address indexed owner, address indexed spender, uint value);
226         event Transfer(address indexed from, address indexed to, uint value);
227 
228         function name() external pure returns (string memory);
229         function symbol() external pure returns (string memory);
230         function decimals() external pure returns (uint8);
231         function totalSupply() external view returns (uint);
232         function balanceOf(address owner) external view returns (uint);
233         function allowance(address owner, address spender) external view returns (uint);
234 
235         function approve(address spender, uint value) external returns (bool);
236         function transfer(address to, uint value) external returns (bool);
237         function transferFrom(address from, address to, uint value) external returns (bool);
238 
239         function DOMAIN_SEPARATOR() external view returns (bytes32);
240         function PERMIT_TYPEHASH() external pure returns (bytes32);
241         function nonces(address owner) external view returns (uint);
242 
243         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
244 
245         event Mint(address indexed sender, uint amount0, uint amount1);
246         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
247         event Swap(
248             address indexed sender,
249             uint amount0In,
250             uint amount1In,
251             uint amount0Out,
252             uint amount1Out,
253             address indexed to
254         );
255         event Sync(uint112 reserve0, uint112 reserve1);
256 
257         function MINIMUM_LIQUIDITY() external pure returns (uint);
258         function factory() external view returns (address);
259         function token0() external view returns (address);
260         function token1() external view returns (address);
261         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
262         function price0CumulativeLast() external view returns (uint);
263         function price1CumulativeLast() external view returns (uint);
264         function kLast() external view returns (uint);
265 
266         function mint(address to) external returns (uint liquidity);
267         function burn(address to) external returns (uint amount0, uint amount1);
268         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
269         function skim(address to) external;
270         function sync() external;
271 
272         function initialize(address, address) external;
273     }
274 
275     interface IUniswapV2Router01 {
276         function factory() external pure returns (address);
277         function WETH() external pure returns (address);
278 
279         function addLiquidity(
280             address tokenA,
281             address tokenB,
282             uint amountADesired,
283             uint amountBDesired,
284             uint amountAMin,
285             uint amountBMin,
286             address to,
287             uint deadline
288         ) external returns (uint amountA, uint amountB, uint liquidity);
289         function addLiquidityETH(
290             address token,
291             uint amountTokenDesired,
292             uint amountTokenMin,
293             uint amountETHMin,
294             address to,
295             uint deadline
296         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
297         function removeLiquidity(
298             address tokenA,
299             address tokenB,
300             uint liquidity,
301             uint amountAMin,
302             uint amountBMin,
303             address to,
304             uint deadline
305         ) external returns (uint amountA, uint amountB);
306         function removeLiquidityETH(
307             address token,
308             uint liquidity,
309             uint amountTokenMin,
310             uint amountETHMin,
311             address to,
312             uint deadline
313         ) external returns (uint amountToken, uint amountETH);
314         function removeLiquidityWithPermit(
315             address tokenA,
316             address tokenB,
317             uint liquidity,
318             uint amountAMin,
319             uint amountBMin,
320             address to,
321             uint deadline,
322             bool approveMax, uint8 v, bytes32 r, bytes32 s
323         ) external returns (uint amountA, uint amountB);
324         function removeLiquidityETHWithPermit(
325             address token,
326             uint liquidity,
327             uint amountTokenMin,
328             uint amountETHMin,
329             address to,
330             uint deadline,
331             bool approveMax, uint8 v, bytes32 r, bytes32 s
332         ) external returns (uint amountToken, uint amountETH);
333         function swapExactTokensForTokens(
334             uint amountIn,
335             uint amountOutMin,
336             address[] calldata path,
337             address to,
338             uint deadline
339         ) external returns (uint[] memory amounts);
340         function swapTokensForExactTokens(
341             uint amountOut,
342             uint amountInMax,
343             address[] calldata path,
344             address to,
345             uint deadline
346         ) external returns (uint[] memory amounts);
347         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
348             external
349             payable
350             returns (uint[] memory amounts);
351         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
352             external
353             returns (uint[] memory amounts);
354         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
355             external
356             returns (uint[] memory amounts);
357         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
358             external
359             payable
360             returns (uint[] memory amounts);
361 
362         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
363         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
364         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
365         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
366         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
367     }
368 
369     interface IUniswapV2Router02 is IUniswapV2Router01 {
370         function removeLiquidityETHSupportingFeeOnTransferTokens(
371             address token,
372             uint liquidity,
373             uint amountTokenMin,
374             uint amountETHMin,
375             address to,
376             uint deadline
377         ) external returns (uint amountETH);
378         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
379             address token,
380             uint liquidity,
381             uint amountTokenMin,
382             uint amountETHMin,
383             address to,
384             uint deadline,
385             bool approveMax, uint8 v, bytes32 r, bytes32 s
386         ) external returns (uint amountETH);
387 
388         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
389             uint amountIn,
390             uint amountOutMin,
391             address[] calldata path,
392             address to,
393             uint deadline
394         ) external;
395         function swapExactETHForTokensSupportingFeeOnTransferTokens(
396             uint amountOutMin,
397             address[] calldata path,
398             address to,
399             uint deadline
400         ) external payable;
401         function swapExactTokensForETHSupportingFeeOnTransferTokens(
402             uint amountIn,
403             uint amountOutMin,
404             address[] calldata path,
405             address to,
406             uint deadline
407         ) external;
408     }
409 
410     contract Quantum is Context, IERC20, Ownable {
411         using SafeMath for uint256;
412         using Address for address;
413 
414         mapping (address => uint256) private _rOwned;
415         mapping (address => uint256) private _tOwned;
416         mapping (address => mapping (address => uint256)) private _allowances;
417 
418         mapping (address => bool) private _isExcludedFromFee;
419 
420         mapping (address => bool) private _isExcluded;
421         address[] private _excluded;
422         mapping (address => bool) private _isBlackListedBot;
423         address[] private _blackListedBots;
424 
425         uint256 private constant MAX = ~uint256(0);
426         uint256 private constant _tTotal = 4000000000000 * 10**18;
427         uint256 private _rTotal = (MAX - (MAX % _tTotal));
428         uint256 private _tFeeTotal;
429 
430         string private constant _name = 'Quantum';
431         string private constant _symbol = 'QNTM';
432         uint8 private constant _decimals = 18;
433 
434         uint256 private _marketingFee = 5;
435         uint256 private _devFee = 2;
436         uint256 private _useCaseFee = 2;
437         uint256 private _useCaseFee2 = 2;
438         uint256 private _useCaseFee3 = 1;
439 
440         uint256 private _taxFee = _useCaseFee + _useCaseFee2 + _useCaseFee3;
441         uint256 private _teamFee = _marketingFee + _devFee;
442         uint256 private _totalFee = _marketingFee + _devFee + _useCaseFee + _useCaseFee2 + _useCaseFee3;
443 
444         uint256 private _previousTaxFee = _taxFee;
445         uint256 private _previousTeamFee = _teamFee;
446         uint256 private _previousMarketingFee;
447         uint256 private _previousDevFee;
448         uint256 private _previousUseCase;
449         uint256 private _previousUseCase2;
450         uint256 private _previousUseCase3;
451 
452         address payable public _marketingWalletAddress;
453         address payable public _devWalletAddress;
454         address payable public _useCaseWallet;
455         address payable public _useCaseWallet2;
456         address payable public _useCaseWallet3;             
457 
458         IUniswapV2Router02 public immutable uniswapV2Router;
459         address public immutable uniswapV2Pair;
460 
461         bool inSwap = false;
462         bool public swapEnabled = true;
463         bool public tradingActive = true;
464 
465         uint256 private _maxTxAmount = 30000000000 * 10**18;
466         uint256 private constant _numOfTokensToExchangeForTeam = 5357142 * 10**18;
467         uint256 private _maxWalletSize = 4000000000000 * 10**18;
468 
469         event botAddedToBlacklist(address account);
470         event botRemovedFromBlacklist(address account);
471 
472         modifier lockTheSwap {
473             inSwap = true;
474             _;
475             inSwap = false;
476         }
477 
478         constructor (address payable UseCaseWallet3) public {
479             _marketingWalletAddress = 0x8d4dF17D8ffB71ADD7d347de9f1a3950aaC42A38;
480             _devWalletAddress = 0xeDf1db5459Ad8c94e4e9C3552da55c8062939B13;
481             _useCaseWallet = 0x415f59DE964952de86074046370EAA4fb5b0F901;
482             _useCaseWallet2 = 0xDEA167FCecbFA4dfD2B9D9125B6aBcD5a7237ECB;
483             _useCaseWallet3 = UseCaseWallet3;
484 
485             _rOwned[_msgSender()] = _rTotal;
486 
487             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
488             // Create a uniswap pair for this new token
489             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
490                 .createPair(address(this), _uniswapV2Router.WETH());
491 
492             // set the rest of the contract variables
493             uniswapV2Router = _uniswapV2Router;
494 
495             // Exclude owner and this contract from fee
496             _isExcludedFromFee[owner()] = true;
497             _isExcludedFromFee[address(this)] = true;
498 
499             emit Transfer(address(0), _msgSender(), _tTotal);
500         }
501 
502         function name() public pure returns (string memory) {
503             return _name;
504         }
505 
506         function symbol() public pure returns (string memory) {
507             return _symbol;
508         }
509 
510         function decimals() public pure returns (uint8) {
511             return _decimals;
512         }
513 
514         function totalSupply() public view override returns (uint256) {
515             return _tTotal;
516         }
517 
518         function balanceOf(address account) public view override returns (uint256) {
519             if (_isExcluded[account]) return _tOwned[account];
520             return tokenFromReflection(_rOwned[account]);
521         }
522 
523         function transfer(address recipient, uint256 amount) public override returns (bool) {
524             _transfer(_msgSender(), recipient, amount);
525             return true;
526         }
527 
528         function allowance(address owner, address spender) public view override returns (uint256) {
529             return _allowances[owner][spender];
530         }
531 
532         function approve(address spender, uint256 amount) public override returns (bool) {
533             _approve(_msgSender(), spender, amount);
534             return true;
535         }
536 
537         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
538             _transfer(sender, recipient, amount);
539             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
540             return true;
541         }
542 
543         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
544             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
545             return true;
546         }
547 
548         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
549             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
550             return true;
551         }
552 
553         function isExcluded(address account) public view returns (bool) {
554             return _isExcluded[account];
555         }
556 
557         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
558             _isExcludedFromFee[account] = excluded;
559         }
560 
561         function totalFees() public view returns (uint256) {
562             return _tFeeTotal;
563         }
564 
565         function deliver(uint256 tAmount) public {
566             address sender = _msgSender();
567             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
568             (uint256 rAmount,,,,,) = _getValues(tAmount);
569             _rOwned[sender] = _rOwned[sender].sub(rAmount);
570             _rTotal = _rTotal.sub(rAmount);
571             _tFeeTotal = _tFeeTotal.add(tAmount);
572         }
573 
574         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
575             require(tAmount <= _tTotal, "Amount must be less than supply");
576             if (!deductTransferFee) {
577                 (uint256 rAmount,,,,,) = _getValues(tAmount);
578                 return rAmount;
579             } else {
580                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
581                 return rTransferAmount;
582             }
583         }
584 
585         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
586             require(rAmount <= _rTotal, "Amount must be less than total reflections");
587             uint256 currentRate =  _getRate();
588             return rAmount.div(currentRate);
589         }
590 
591         function addBotToBlacklist (address account) external onlyOwner() {
592            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
593            require (!_isBlackListedBot[account], 'Account is already blacklisted');
594            _isBlackListedBot[account] = true;
595            _blackListedBots.push(account);
596         }
597 
598         function removeBotFromBlacklist(address account) external onlyOwner() {
599           require (_isBlackListedBot[account], 'Account is not blacklisted');
600           for (uint256 i = 0; i < _blackListedBots.length; i++) {
601                  if (_blackListedBots[i] == account) {
602                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
603                      _isBlackListedBot[account] = false;
604                      _blackListedBots.pop();
605                      break;
606                  }
607            }
608        }
609 
610         function excludeAccount(address account) external onlyOwner() {
611             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
612             require(!_isExcluded[account], "Account is already excluded");
613             if(_rOwned[account] > 0) {
614                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
615             }
616             _isExcluded[account] = true;
617             _excluded.push(account);
618         }
619 
620         function includeAccount(address account) external onlyOwner() {
621             require(_isExcluded[account], "Account is not excluded");
622             for (uint256 i = 0; i < _excluded.length; i++) {
623                 if (_excluded[i] == account) {
624                     _excluded[i] = _excluded[_excluded.length - 1];
625                     _tOwned[account] = 0;
626                     _isExcluded[account] = false;
627                     _excluded.pop();
628                     break;
629                 }
630             }
631         }
632 
633         function removeAllFee() private {
634             if(_taxFee == 0 && _teamFee == 0) return;
635 
636             _previousTaxFee = _taxFee;
637             _previousTeamFee = _teamFee;
638 
639             _previousMarketingFee = _marketingFee;
640             _previousDevFee = _devFee;
641             _previousUseCase = _useCaseFee;
642             _previousUseCase2 = _useCaseFee2;
643             _previousUseCase3 = _useCaseFee3;
644 
645             _marketingFee = 0;
646             _devFee = 0;
647             _useCaseFee = 0;
648             _useCaseFee2 = 0;
649             _useCaseFee3 = 0;
650 
651             _taxFee = 0;
652             _teamFee = 0;
653         }
654 
655         function restoreAllFee() private {
656             _taxFee = _previousTaxFee;
657             _teamFee = _previousTeamFee;
658 
659             _marketingFee = _previousMarketingFee;
660             _devFee = _previousDevFee;
661             _useCaseFee = _previousUseCase;
662             _useCaseFee2 = _previousUseCase2;
663             _useCaseFee3 = _previousUseCase3;
664         }
665 
666         function isExcludedFromFee(address account) public view returns(bool) {
667             return _isExcludedFromFee[account];
668         }
669 
670         function _approve(address owner, address spender, uint256 amount) private {
671             require(owner != address(0), "ERC20: approve from the zero address");
672             require(spender != address(0), "ERC20: approve to the zero address");
673 
674             _allowances[owner][spender] = amount;
675             emit Approval(owner, spender, amount);
676         }
677 
678         function _transfer(address sender, address recipient, uint256 amount) private {
679             require(sender != address(0), "ERC20: transfer from the zero address");
680             require(recipient != address(0), "ERC20: transfer to the zero address");
681             require(amount > 0, "Transfer amount must be greater than zero");
682             require(!_isBlackListedBot[sender], "You are blacklisted");
683             require(!_isBlackListedBot[msg.sender], "You are blacklisted");
684             require(!_isBlackListedBot[tx.origin], "You are blacklisted");
685             require(tradingActive || (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]), "Trading is currently not active");
686             if(sender != owner() && recipient != owner()) {
687                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
688             }
689             if(sender != owner() && recipient != owner() && recipient != uniswapV2Pair && recipient != address(0xdead)) {
690                 uint256 tokenBalanceRecipient = balanceOf(recipient);
691                 require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
692             }
693             // is the token balance of this contract address over the min number of
694             // tokens that we need to initiate a swap?
695             // also, don't get caught in a circular team event.
696             // also, don't swap if sender is uniswap pair.
697             uint256 contractTokenBalance = balanceOf(address(this));
698 
699             if(contractTokenBalance >= _maxTxAmount)
700             {
701                 contractTokenBalance = _maxTxAmount;
702             }
703 
704             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
705             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
706                 // Swap tokens for ETH and send to resepctive wallets
707                 swapTokensForEth(contractTokenBalance);
708 
709                 uint256 contractETHBalance = address(this).balance;
710                 if(contractETHBalance > 0) {
711                     sendETHToTeam(address(this).balance);
712                 }
713             }
714 
715             //indicates if fee should be deducted from transfer
716             bool takeFee = true;
717 
718             //if any account belongs to _isExcludedFromFee account then remove the fee
719             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
720                 takeFee = false;
721             }
722 
723             //transfer amount, it will take tax and team fee
724             _tokenTransfer(sender,recipient,amount,takeFee);
725         }
726 
727         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
728             // generate the uniswap pair path of token -> weth
729             address[] memory path = new address[](2);
730             path[0] = address(this);
731             path[1] = uniswapV2Router.WETH();
732 
733             _approve(address(this), address(uniswapV2Router), tokenAmount);
734 
735             // make the swap
736             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
737                 tokenAmount,
738                 0, // accept any amount of ETH
739                 path,
740                 address(this),
741                 block.timestamp
742             );
743         }
744 
745         function sendETHToTeam(uint256 amount) private {
746             _marketingWalletAddress.transfer(amount.div(_totalFee).mul(_marketingFee));
747             _devWalletAddress.transfer(amount.div(_totalFee).mul(_devFee));
748             _useCaseWallet.transfer(amount.div(_totalFee).mul(_useCaseFee));
749             _useCaseWallet2.transfer(amount.div(_totalFee).mul(_useCaseFee2));
750             _useCaseWallet3.transfer(amount.div(_totalFee).mul(_useCaseFee3));
751         }
752 
753         function manualSwap() external onlyOwner() {
754             uint256 contractBalance = balanceOf(address(this));
755             swapTokensForEth(contractBalance);
756         }
757 
758         function manualSend() external onlyOwner() {
759             uint256 contractETHBalance = address(this).balance;
760             sendETHToTeam(contractETHBalance);
761         }
762 
763         function setSwapEnabled(bool enabled) external onlyOwner(){
764             swapEnabled = enabled;
765         }
766 
767         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
768             if(!takeFee)
769                 removeAllFee();
770 
771             if (_isExcluded[sender] && !_isExcluded[recipient]) {
772                 _transferFromExcluded(sender, recipient, amount);
773             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
774                 _transferToExcluded(sender, recipient, amount);
775             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
776                 _transferStandard(sender, recipient, amount);
777             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
778                 _transferBothExcluded(sender, recipient, amount);
779             } else {
780                 _transferStandard(sender, recipient, amount);
781             }
782 
783             if(!takeFee)
784                 restoreAllFee();
785         }
786 
787         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
788             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
789             _rOwned[sender] = _rOwned[sender].sub(rAmount);
790             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
791             _takeTeam(tTeam);
792             _reflectFee(rFee, tFee);
793             emit Transfer(sender, recipient, tTransferAmount);
794         }
795 
796         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
797             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
798             _rOwned[sender] = _rOwned[sender].sub(rAmount);
799             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
800             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
801             _takeTeam(tTeam);
802             _reflectFee(rFee, tFee);
803             emit Transfer(sender, recipient, tTransferAmount);
804         }
805 
806         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
807             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
808             _tOwned[sender] = _tOwned[sender].sub(tAmount);
809             _rOwned[sender] = _rOwned[sender].sub(rAmount);
810             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
811             _takeTeam(tTeam);
812             _reflectFee(rFee, tFee);
813             emit Transfer(sender, recipient, tTransferAmount);
814         }
815 
816         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
817             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
818             _tOwned[sender] = _tOwned[sender].sub(tAmount);
819             _rOwned[sender] = _rOwned[sender].sub(rAmount);
820             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
821             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
822             _takeTeam(tTeam);
823             _reflectFee(rFee, tFee);
824             emit Transfer(sender, recipient, tTransferAmount);
825         }
826 
827         function _takeTeam(uint256 tTeam) private {
828             uint256 currentRate =  _getRate();
829             uint256 rTeam = tTeam.mul(currentRate);
830             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
831             if(_isExcluded[address(this)])
832                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
833         }
834 
835         function _reflectFee(uint256 rFee, uint256 tFee) private {
836             _rTotal = _rTotal.sub(rFee);
837             _tFeeTotal = _tFeeTotal.add(tFee);
838         }
839 
840          //to recieve ETH from uniswapV2Router when swaping
841         receive() external payable {}
842 
843         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
844         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
845         uint256 currentRate = _getRate();
846         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
847         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
848     }
849 
850         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
851             uint256 tFee = tAmount.mul(taxFee).div(100);
852             uint256 tTeam = tAmount.mul(teamFee).div(100);
853             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
854             return (tTransferAmount, tFee, tTeam);
855         }
856 
857         function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
858             uint256 rAmount = tAmount.mul(currentRate);
859             uint256 rFee = tFee.mul(currentRate);
860             uint256 rTeam = tTeam.mul(currentRate);
861             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
862             return (rAmount, rTransferAmount, rFee);
863         }
864 
865         function _getRate() private view returns(uint256) {
866             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
867             return rSupply.div(tSupply);
868         }
869 
870         function _getCurrentSupply() private view returns(uint256, uint256) {
871             uint256 rSupply = _rTotal;
872             uint256 tSupply = _tTotal;
873             for (uint256 i = 0; i < _excluded.length; i++) {
874                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
875                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
876                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
877             }
878             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
879             return (rSupply, tSupply);
880         }
881 
882         function _getTaxFee() public view returns(uint256) {
883             return _taxFee;
884         }
885 
886         function _getTeamFee() public view returns (uint256) {
887             return _teamFee;
888         }
889 
890         function _getMarketingFee() public view returns (uint256) {
891             return _marketingFee;
892         }
893 
894         function _getDevFee() public view returns (uint256) {
895             return _devFee;
896         }
897 
898         function _geUseCaseFee() public view returns (uint256) {
899             return _useCaseFee;
900         }
901 
902         function _getUseCaseFee2() public view returns (uint256) {
903             return _useCaseFee2;
904         }
905 
906         function _getUseCaseFee3() public view returns (uint256) {
907             return _useCaseFee3;
908         }
909 
910         function _getETHBalance() public view returns(uint256 balance) {
911             return address(this).balance;
912         }
913 
914         function _getMaxTxAmount() public view returns (uint256) {
915             return _maxTxAmount;
916         }
917 
918         function _getMaxWalletSize () public view returns (uint256) {
919             return _maxWalletSize;
920         }
921 
922         function _setMarketingFee(uint256 marketingFee) external onlyOwner() {
923             require(marketingFee >= 1 && marketingFee <= 6, 'marketingFee should be in 1 - 6');
924             _marketingFee = marketingFee;
925         }
926 
927         function _setDevFee(uint256 devFee) external onlyOwner() {
928             require(devFee >= 1 && devFee <= 6, 'devFee should be in 1 - 6');
929             _devFee = devFee;
930         }
931 
932         function _setUseCaseFee(uint256 useCaseFee) external onlyOwner() {
933             require(useCaseFee >= 1 && useCaseFee <= 6, 'useCaseFee should be in 1 - 6');
934             _useCaseFee = useCaseFee;
935         }
936 
937         function _setUseCaseFee2(uint256 useCaseFee2) external onlyOwner() {
938             require(useCaseFee2 >= 1 && useCaseFee2 <= 6, 'useCaseFee2 should be in 1 - 6');
939             _useCaseFee2 = useCaseFee2;
940         }
941 
942         function _setUseCaseFee3(uint256 useCaseFee3) external onlyOwner() {
943             require(useCaseFee3 >= 1 && useCaseFee3 <= 6, 'useCaseFee3 should be in 1 - 6');
944             _useCaseFee3 = useCaseFee3;
945         }
946 
947         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
948             _maxTxAmount = maxTxAmount;
949         }
950 
951         function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
952           _maxWalletSize = maxWalletSize;
953         }
954 
955         function _setUseCaseWallet3(address payable UseCaseWallet3) external onlyOwner() {
956             _useCaseWallet3 = UseCaseWallet3;
957         }
958 
959         // Enable Trading
960         function enableTrading() external onlyOwner {
961             tradingActive = true;
962             swapEnabled = true;
963         }
964 
965         // Disable Trading
966         function disableTrading() external onlyOwner {
967             tradingActive = false;
968             swapEnabled = false;
969         }
970     }