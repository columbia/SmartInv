1 //Boost V2
2 // Developed by Elevate Software
3 // elevatesoftware.io
4 // @elevatesoftware
5 
6 // SPDX-License-Identifier: Unlicensed
7 pragma solidity ^0.6.12;
8 
9     abstract contract Context {
10         function _msgSender() internal view virtual returns (address payable) {
11             return msg.sender;
12         }
13 
14         function _msgData() internal view virtual returns (bytes memory) {
15             this; 
16             return msg.data;
17         }
18     }
19 
20     interface IERC20 {
21         //Return total supply
22         function totalSupply() external view returns (uint256);
23 
24         //Return amount of tokens owned by 'account'
25         function balanceOf(address account) external view returns (uint256);
26 
27         //Moves 'amount' tokens from the caller's account to 'recipient'
28         function transfer(address recipient, uint256 amount) external returns (bool);
29         //Returns a boolean value indicating whether the operation succeeded.
30 
31         //Returns the remaining number of tokens that 'spender' will be allowed to spend
32         function allowance(address owner, address spender) external view returns (uint256);
33 
34 
35         //Sets 'amount' as the allowance of 'spender' over the caller's tokens
36         function approve(address spender, uint256 amount) external returns (bool);
37 
38         //Moves 'ammount' of tokens from 'spender' to 'recipient'. Then deducts from callers allowance.
39         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
40 
41         event Transfer(address indexed from, address indexed to, uint256 value);
42 
43         event Approval(address indexed owner, address indexed spender, uint256 value);
44     }
45 
46     library SafeMath {
47         function add(uint256 a, uint256 b) internal pure returns (uint256) {
48             uint256 c = a + b;
49             require(c >= a, "SafeMath: addition overflow");
50 
51             return c;
52         }
53 
54         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55             return sub(a, b, "SafeMath: subtraction overflow");
56         }
57 
58         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59             require(b <= a, errorMessage);
60             uint256 c = a - b;
61 
62             return c;
63         }
64 
65         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67             // benefit is lost if 'b' is also tested.
68             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
69             if (a == 0) {
70                 return 0;
71             }
72 
73             uint256 c = a * b;
74             require(c / a == b, "SafeMath: multiplication overflow");
75 
76             return c;
77         }
78 
79         function div(uint256 a, uint256 b) internal pure returns (uint256) {
80             return div(a, b, "SafeMath: division by zero");
81         }
82 
83         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84             require(b > 0, errorMessage);
85             uint256 c = a / b;
86             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87 
88             return c;
89         }
90 
91         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92             return mod(a, b, "SafeMath: modulo by zero");
93         }
94 
95         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96             require(b != 0, errorMessage);
97             return a % b;
98         }
99     }
100 
101     library Address {
102         function isContract(address account) internal view returns (bool) {
103             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
104             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
105             // for accounts without code, i.e. 'keccak256('')'
106             bytes32 codehash;
107             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
108             // solhint-disable-next-line no-inline-assembly
109             assembly { codehash := extcodehash(account) }
110             return (codehash != accountHash && codehash != 0x0);
111         }
112 
113         function sendValue(address payable recipient, uint256 amount) internal {
114             require(address(this).balance >= amount, "Address: insufficient balance");
115 
116             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
117             (bool success, ) = recipient.call{ value: amount }("");
118             require(success, "Address: unable to send value, recipient may have reverted");
119         }
120 
121         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
122         return functionCall(target, data, "Address: low-level call failed");
123         }
124 
125 
126         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
127             return _functionCallWithValue(target, data, 0, errorMessage);
128         }
129 
130         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
131             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
132         }
133 
134         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
135             require(address(this).balance >= value, "Address: insufficient balance for call");
136             return _functionCallWithValue(target, data, value, errorMessage);
137         }
138 
139         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
140             require(isContract(target), "Address: call to non-contract");
141 
142             // solhint-disable-next-line avoid-low-level-calls
143             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
144             if (success) {
145                 return returndata;
146             } else {
147                 // Look for revert reason and bubble it up if present
148                 if (returndata.length > 0) {
149                     // The easiest way to bubble the revert reason is using memory via assembly
150 
151                     // solhint-disable-next-line no-inline-assembly
152                     assembly {
153                         let returndata_size := mload(returndata)
154                         revert(add(32, returndata), returndata_size)
155                     }
156                 } else {
157                     revert(errorMessage);
158                 }
159             }
160         }
161     }
162 
163     contract Ownable is Context {
164         address private _owner;
165         address private _previousOwner;
166         uint256 private _lockTime;
167 
168         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170         //Initializes the contract setting the deployer as the initial owner.
171         constructor () internal {
172             address msgSender = _msgSender();
173             _owner = msgSender;
174             emit OwnershipTransferred(address(0), msgSender);
175         }
176 
177         //Returns the address of the current owner.
178         function owner() public view returns (address) {
179             return _owner;
180         }
181 
182         //Throws if called by any account other than the owner.
183         modifier onlyOwner() {
184             require(_owner == _msgSender(), "Ownable: caller is not the owner");
185             _;
186         }
187 
188         /**
189         * Leaves the contract without owner. It will not be possible to call
190         * 'onlyOwner' functions anymore. Can only be called by the current owner.
191         *
192         * NOTE: Renouncing ownership will leave the contract without an owner,
193         * thereby removing any functionality that is only available to the owner.
194         */
195         function renounceOwnership() public virtual onlyOwner {
196             emit OwnershipTransferred(_owner, address(0));
197             _owner = address(0);
198         }
199 
200         //Transfers ownership of the contract to a new account ('newOwner'), Can only be called by the current owner.
201         function transferOwnership(address newOwner) public virtual onlyOwner {
202             require(newOwner != address(0), "Ownable: new owner is the zero address");
203             emit OwnershipTransferred(_owner, newOwner);
204             _owner = newOwner;
205         }
206 
207         function getUnlockTime() public view returns (uint256) {
208             return _lockTime;
209         }
210 
211     }
212 
213     interface IUniswapV2Factory {
214         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
215 
216         function feeTo() external view returns (address);
217         function feeToSetter() external view returns (address);
218 
219         function getPair(address tokenA, address tokenB) external view returns (address pair);
220         function allPairs(uint) external view returns (address pair);
221         function allPairsLength() external view returns (uint);
222 
223         function createPair(address tokenA, address tokenB) external returns (address pair);
224 
225         function setFeeTo(address) external;
226         function setFeeToSetter(address) external;
227     }
228 
229     interface IUniswapV2Pair {
230         event Approval(address indexed owner, address indexed spender, uint value);
231         event Transfer(address indexed from, address indexed to, uint value);
232 
233         function name() external pure returns (string memory);
234         function symbol() external pure returns (string memory);
235         function decimals() external pure returns (uint8);
236         function totalSupply() external view returns (uint);
237         function balanceOf(address owner) external view returns (uint);
238         function allowance(address owner, address spender) external view returns (uint);
239 
240         function approve(address spender, uint value) external returns (bool);
241         function transfer(address to, uint value) external returns (bool);
242         function transferFrom(address from, address to, uint value) external returns (bool);
243 
244         function DOMAIN_SEPARATOR() external view returns (bytes32);
245         function PERMIT_TYPEHASH() external pure returns (bytes32);
246         function nonces(address owner) external view returns (uint);
247 
248         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
249 
250         event Mint(address indexed sender, uint amount0, uint amount1);
251         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
252         event Swap(
253             address indexed sender,
254             uint amount0In,
255             uint amount1In,
256             uint amount0Out,
257             uint amount1Out,
258             address indexed to
259         );
260         event Sync(uint112 reserve0, uint112 reserve1);
261 
262         function MINIMUM_LIQUIDITY() external pure returns (uint);
263         function factory() external view returns (address);
264         function token0() external view returns (address);
265         function token1() external view returns (address);
266         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
267         function price0CumulativeLast() external view returns (uint);
268         function price1CumulativeLast() external view returns (uint);
269         function kLast() external view returns (uint);
270 
271         function mint(address to) external returns (uint liquidity);
272         function burn(address to) external returns (uint amount0, uint amount1);
273         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
274         function skim(address to) external;
275         function sync() external;
276 
277         function initialize(address, address) external;
278     }
279 
280     interface IUniswapV2Router01 {
281         function factory() external pure returns (address);
282         function WETH() external pure returns (address);
283 
284         function addLiquidity(
285             address tokenA,
286             address tokenB,
287             uint amountADesired,
288             uint amountBDesired,
289             uint amountAMin,
290             uint amountBMin,
291             address to,
292             uint deadline
293         ) external returns (uint amountA, uint amountB, uint liquidity);
294         function addLiquidityETH(
295             address token,
296             uint amountTokenDesired,
297             uint amountTokenMin,
298             uint amountETHMin,
299             address to,
300             uint deadline
301         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
302         function removeLiquidity(
303             address tokenA,
304             address tokenB,
305             uint liquidity,
306             uint amountAMin,
307             uint amountBMin,
308             address to,
309             uint deadline
310         ) external returns (uint amountA, uint amountB);
311         function removeLiquidityETH(
312             address token,
313             uint liquidity,
314             uint amountTokenMin,
315             uint amountETHMin,
316             address to,
317             uint deadline
318         ) external returns (uint amountToken, uint amountETH);
319         function removeLiquidityWithPermit(
320             address tokenA,
321             address tokenB,
322             uint liquidity,
323             uint amountAMin,
324             uint amountBMin,
325             address to,
326             uint deadline,
327             bool approveMax, uint8 v, bytes32 r, bytes32 s
328         ) external returns (uint amountA, uint amountB);
329         function removeLiquidityETHWithPermit(
330             address token,
331             uint liquidity,
332             uint amountTokenMin,
333             uint amountETHMin,
334             address to,
335             uint deadline,
336             bool approveMax, uint8 v, bytes32 r, bytes32 s
337         ) external returns (uint amountToken, uint amountETH);
338         function swapExactTokensForTokens(
339             uint amountIn,
340             uint amountOutMin,
341             address[] calldata path,
342             address to,
343             uint deadline
344         ) external returns (uint[] memory amounts);
345         function swapTokensForExactTokens(
346             uint amountOut,
347             uint amountInMax,
348             address[] calldata path,
349             address to,
350             uint deadline
351         ) external returns (uint[] memory amounts);
352         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
353             external
354             payable
355             returns (uint[] memory amounts);
356         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
357             external
358             returns (uint[] memory amounts);
359         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
360             external
361             returns (uint[] memory amounts);
362         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
363             external
364             payable
365             returns (uint[] memory amounts);
366 
367         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
368         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
369         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
370         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
371         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
372     }
373 
374     interface IUniswapV2Router02 is IUniswapV2Router01 {
375         function removeLiquidityETHSupportingFeeOnTransferTokens(
376             address token,
377             uint liquidity,
378             uint amountTokenMin,
379             uint amountETHMin,
380             address to,
381             uint deadline
382         ) external returns (uint amountETH);
383         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
384             address token,
385             uint liquidity,
386             uint amountTokenMin,
387             uint amountETHMin,
388             address to,
389             uint deadline,
390             bool approveMax, uint8 v, bytes32 r, bytes32 s
391         ) external returns (uint amountETH);
392 
393         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
394             uint amountIn,
395             uint amountOutMin,
396             address[] calldata path,
397             address to,
398             uint deadline
399         ) external;
400         function swapExactETHForTokensSupportingFeeOnTransferTokens(
401             uint amountOutMin,
402             address[] calldata path,
403             address to,
404             uint deadline
405         ) external payable;
406         function swapExactTokensForETHSupportingFeeOnTransferTokens(
407             uint amountIn,
408             uint amountOutMin,
409             address[] calldata path,
410             address to,
411             uint deadline
412         ) external;
413     }
414 
415     contract Boost2 is Context, IERC20, Ownable {
416         using SafeMath for uint256;
417         using Address for address;
418 
419         mapping (address => uint256) private _rOwned;
420         mapping (address => uint256) private _tOwned;
421         mapping (address => mapping (address => uint256)) private _allowances;
422 
423         mapping (address => bool) private _isExcludedFromFee;
424 
425         mapping (address => bool) private _isExcluded;
426         address[] private _excluded;
427         mapping (address => bool) private _isBlackListedBot;
428         address[] private _blackListedBots;
429 
430         uint256 private constant MAX = ~uint256(0);
431         uint256 private constant _tTotal = 300000 * 10**18;
432         uint256 private _rTotal = (MAX - (MAX % _tTotal));
433         uint256 private _tFeeTotal;
434 
435         string private constant _name = 'Boost2';
436         string private constant _symbol = 'BOOST2';
437         uint8 private constant _decimals = 18;
438 
439         uint256 private _taxFee = 1;
440         uint256 private _teamFee = 6;
441         uint256 private _previousTaxFee = _taxFee;
442         uint256 private _previousTeamFee = _teamFee;
443 
444         address payable public _devWalletAddress;
445         address payable public _marketingWalletAddress;
446         address payable public _useWalletAddress;
447 
448         IUniswapV2Router02 public immutable uniswapV2Router;
449         address public immutable uniswapV2Pair;
450 
451         bool inSwap = false;
452         bool public swapEnabled = true;
453 
454         uint256 private _maxTxAmount = 7000 * 10**18;
455         uint256 private constant _numOfTokensToExchangeForTeam = 1.25 * 10**18;
456         uint256 private _maxWalletSize = 300000 * 10**18;
457 
458         event botAddedToBlacklist(address account);
459         event botRemovedFromBlacklist(address account);
460 
461         modifier lockTheSwap {
462             inSwap = true;
463             _;
464             inSwap = false;
465         }
466 
467         constructor (address payable marketingWalletAddress, address payable useWalletAddress) public {
468             _devWalletAddress = 0x5A549a2D20aC5ca20D04259474c0166082872955;
469             _marketingWalletAddress = marketingWalletAddress;
470             _useWalletAddress = useWalletAddress;
471 
472             _rOwned[_msgSender()] = _rTotal;
473 
474             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
475             // Create a uniswap pair for this new token
476             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
477                 .createPair(address(this), _uniswapV2Router.WETH());
478 
479             // set the rest of the contract variables
480             uniswapV2Router = _uniswapV2Router;
481 
482             // Exclude owner and this contract from fee
483             _isExcludedFromFee[owner()] = true;
484             _isExcludedFromFee[address(this)] = true;
485 
486             emit Transfer(address(0), _msgSender(), _tTotal);
487         }
488 
489         function name() public pure returns (string memory) {
490             return _name;
491         }
492 
493         function symbol() public pure returns (string memory) {
494             return _symbol;
495         }
496 
497         function decimals() public pure returns (uint8) {
498             return _decimals;
499         }
500 
501         function totalSupply() public view override returns (uint256) {
502             return _tTotal;
503         }
504 
505         function balanceOf(address account) public view override returns (uint256) {
506             if (_isExcluded[account]) return _tOwned[account];
507             return tokenFromReflection(_rOwned[account]);
508         }
509 
510         function transfer(address recipient, uint256 amount) public override returns (bool) {
511             _transfer(_msgSender(), recipient, amount);
512             return true;
513         }
514 
515         function allowance(address owner, address spender) public view override returns (uint256) {
516             return _allowances[owner][spender];
517         }
518 
519         function approve(address spender, uint256 amount) public override returns (bool) {
520             _approve(_msgSender(), spender, amount);
521             return true;
522         }
523 
524         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
525             _transfer(sender, recipient, amount);
526             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
527             return true;
528         }
529 
530         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
531             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
532             return true;
533         }
534 
535         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
536             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
537             return true;
538         }
539 
540         function isExcluded(address account) public view returns (bool) {
541             return _isExcluded[account];
542         }
543 
544         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
545             _isExcludedFromFee[account] = excluded;
546         }
547 
548         function totalFees() public view returns (uint256) {
549             return _tFeeTotal;
550         }
551 
552         function deliver(uint256 tAmount) public {
553             address sender = _msgSender();
554             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
555             (uint256 rAmount,,,,,) = _getValues(tAmount);
556             _rOwned[sender] = _rOwned[sender].sub(rAmount);
557             _rTotal = _rTotal.sub(rAmount);
558             _tFeeTotal = _tFeeTotal.add(tAmount);
559         }
560 
561         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
562             require(tAmount <= _tTotal, "Amount must be less than supply");
563             if (!deductTransferFee) {
564                 (uint256 rAmount,,,,,) = _getValues(tAmount);
565                 return rAmount;
566             } else {
567                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
568                 return rTransferAmount;
569             }
570         }
571 
572         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
573             require(rAmount <= _rTotal, "Amount must be less than total reflections");
574             uint256 currentRate =  _getRate();
575             return rAmount.div(currentRate);
576         }
577 
578         function addBotToBlacklist (address account) external onlyOwner() {
579            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
580            require (!_isBlackListedBot[account], 'Account is already blacklisted');
581            _isBlackListedBot[account] = true;
582            _blackListedBots.push(account);
583         }
584 
585         function removeBotFromBlacklist(address account) external onlyOwner() {
586           require (_isBlackListedBot[account], 'Account is not blacklisted');
587           for (uint256 i = 0; i < _blackListedBots.length; i++) {
588                  if (_blackListedBots[i] == account) {
589                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
590                      _isBlackListedBot[account] = false;
591                      _blackListedBots.pop();
592                      break;
593                  }
594            }
595        }
596 
597         function excludeAccount(address account) external onlyOwner() {
598             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
599             require(!_isExcluded[account], "Account is already excluded");
600             if(_rOwned[account] > 0) {
601                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
602             }
603             _isExcluded[account] = true;
604             _excluded.push(account);
605         }
606 
607         function includeAccount(address account) external onlyOwner() {
608             require(_isExcluded[account], "Account is not excluded");
609             for (uint256 i = 0; i < _excluded.length; i++) {
610                 if (_excluded[i] == account) {
611                     _excluded[i] = _excluded[_excluded.length - 1];
612                     _tOwned[account] = 0;
613                     _isExcluded[account] = false;
614                     _excluded.pop();
615                     break;
616                 }
617             }
618         }
619 
620         function removeAllFee() private {
621             if(_taxFee == 0 && _teamFee == 0) return;
622 
623             _previousTaxFee = _taxFee;
624             _previousTeamFee = _teamFee;
625 
626             _taxFee = 0;
627             _teamFee = 0;
628         }
629 
630         function restoreAllFee() private {
631             _taxFee = _previousTaxFee;
632             _teamFee = _previousTeamFee;
633         }
634 
635         function isExcludedFromFee(address account) public view returns(bool) {
636             return _isExcludedFromFee[account];
637         }
638 
639         function _approve(address owner, address spender, uint256 amount) private {
640             require(owner != address(0), "ERC20: approve from the zero address");
641             require(spender != address(0), "ERC20: approve to the zero address");
642 
643             _allowances[owner][spender] = amount;
644             emit Approval(owner, spender, amount);
645         }
646 
647         function _transfer(address sender, address recipient, uint256 amount) private {
648             require(sender != address(0), "ERC20: transfer from the zero address");
649             require(recipient != address(0), "ERC20: transfer to the zero address");
650             require(amount > 0, "Transfer amount must be greater than zero");
651             require(!_isBlackListedBot[sender], "You are blacklisted");
652             require(!_isBlackListedBot[msg.sender], "You are blacklisted");
653             require(!_isBlackListedBot[tx.origin], "You are blacklisted");
654             if(sender != owner() && recipient != owner()) {
655                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
656             }
657             if(sender != owner() && recipient != owner() && recipient != uniswapV2Pair && recipient != address(0xdead)) {
658                 uint256 tokenBalanceRecipient = balanceOf(recipient);
659                 require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
660             }
661             // is the token balance of this contract address over the min number of
662             // tokens that we need to initiate a swap?
663             // also, don't get caught in a circular team event.
664             // also, don't swap if sender is uniswap pair.
665             uint256 contractTokenBalance = balanceOf(address(this));
666 
667             if(contractTokenBalance >= _maxTxAmount)
668             {
669                 contractTokenBalance = _maxTxAmount;
670             }
671 
672             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
673             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
674                 // Swap tokens for ETH and send to resepctive wallets
675                 swapTokensForEth(contractTokenBalance);
676 
677                 uint256 contractETHBalance = address(this).balance;
678                 if(contractETHBalance > 0) {
679                     sendETHToTeam(address(this).balance);
680                 }
681             }
682 
683             //indicates if fee should be deducted from transfer
684             bool takeFee = true;
685 
686             //if any account belongs to _isExcludedFromFee account then remove the fee
687             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
688                 takeFee = false;
689             }
690 
691             //transfer amount, it will take tax and team fee
692             _tokenTransfer(sender,recipient,amount,takeFee);
693         }
694 
695         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
696             // generate the uniswap pair path of token -> weth
697             address[] memory path = new address[](2);
698             path[0] = address(this);
699             path[1] = uniswapV2Router.WETH();
700 
701             _approve(address(this), address(uniswapV2Router), tokenAmount);
702 
703             // make the swap
704             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
705                 tokenAmount,
706                 0, // accept any amount of ETH
707                 path,
708                 address(this),
709                 block.timestamp
710             );
711         }
712 
713         function sendETHToTeam(uint256 amount) private {
714             _devWalletAddress.transfer(amount.div(7));
715             _marketingWalletAddress.transfer(amount.div(7));
716             _useWalletAddress.transfer(amount.div(7).mul(5));
717         }
718 
719         function manualSwap() external onlyOwner() {
720             uint256 contractBalance = balanceOf(address(this));
721             swapTokensForEth(contractBalance);
722         }
723 
724         function manualSend() external onlyOwner() {
725             uint256 contractETHBalance = address(this).balance;
726             sendETHToTeam(contractETHBalance);
727         }
728 
729         function setSwapEnabled(bool enabled) external onlyOwner(){
730             swapEnabled = enabled;
731         }
732 
733         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
734             if(!takeFee)
735                 removeAllFee();
736 
737             if (_isExcluded[sender] && !_isExcluded[recipient]) {
738                 _transferFromExcluded(sender, recipient, amount);
739             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
740                 _transferToExcluded(sender, recipient, amount);
741             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
742                 _transferStandard(sender, recipient, amount);
743             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
744                 _transferBothExcluded(sender, recipient, amount);
745             } else {
746                 _transferStandard(sender, recipient, amount);
747             }
748 
749             if(!takeFee)
750                 restoreAllFee();
751         }
752 
753         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
754             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
755             _rOwned[sender] = _rOwned[sender].sub(rAmount);
756             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
757             _takeTeam(tTeam);
758             _reflectFee(rFee, tFee);
759             emit Transfer(sender, recipient, tTransferAmount);
760         }
761 
762         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
763             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
764             _rOwned[sender] = _rOwned[sender].sub(rAmount);
765             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
766             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
767             _takeTeam(tTeam);
768             _reflectFee(rFee, tFee);
769             emit Transfer(sender, recipient, tTransferAmount);
770         }
771 
772         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
773             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
774             _tOwned[sender] = _tOwned[sender].sub(tAmount);
775             _rOwned[sender] = _rOwned[sender].sub(rAmount);
776             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
777             _takeTeam(tTeam);
778             _reflectFee(rFee, tFee);
779             emit Transfer(sender, recipient, tTransferAmount);
780         }
781 
782         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
783             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
784             _tOwned[sender] = _tOwned[sender].sub(tAmount);
785             _rOwned[sender] = _rOwned[sender].sub(rAmount);
786             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
787             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
788             _takeTeam(tTeam);
789             _reflectFee(rFee, tFee);
790             emit Transfer(sender, recipient, tTransferAmount);
791         }
792 
793         function _takeTeam(uint256 tTeam) private {
794             uint256 currentRate =  _getRate();
795             uint256 rTeam = tTeam.mul(currentRate);
796             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
797             if(_isExcluded[address(this)])
798                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
799         }
800 
801         function _reflectFee(uint256 rFee, uint256 tFee) private {
802             _rTotal = _rTotal.sub(rFee);
803             _tFeeTotal = _tFeeTotal.add(tFee);
804         }
805 
806          //to recieve ETH from uniswapV2Router when swaping
807         receive() external payable {}
808 
809         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
810         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
811         uint256 currentRate = _getRate();
812         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
813         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
814     }
815 
816         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
817             uint256 tFee = tAmount.mul(taxFee).div(100);
818             uint256 tTeam = tAmount.mul(teamFee).div(100);
819             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
820             return (tTransferAmount, tFee, tTeam);
821         }
822 
823         function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
824             uint256 rAmount = tAmount.mul(currentRate);
825             uint256 rFee = tFee.mul(currentRate);
826             uint256 rTeam = tTeam.mul(currentRate);
827             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
828             return (rAmount, rTransferAmount, rFee);
829         }
830 
831         function _getRate() private view returns(uint256) {
832             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
833             return rSupply.div(tSupply);
834         }
835 
836         function _getCurrentSupply() private view returns(uint256, uint256) {
837             uint256 rSupply = _rTotal;
838             uint256 tSupply = _tTotal;
839             for (uint256 i = 0; i < _excluded.length; i++) {
840                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
841                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
842                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
843             }
844             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
845             return (rSupply, tSupply);
846         }
847 
848         function _getTaxFee() public view returns(uint256) {
849             return _taxFee;
850         }
851 
852         function _getTeamFee() public view returns (uint256) {
853           return _teamFee;
854         }
855 
856         function _getMaxTxAmount() public view returns(uint256) {
857             return _maxTxAmount;
858         }
859 
860         function _getETHBalance() public view returns(uint256 balance) {
861             return address(this).balance;
862         }
863 
864         function _setTaxFee(uint256 taxFee) external onlyOwner() {
865             require(taxFee >= 1 && taxFee <= 3, 'taxFee should be in 1 - 3');
866             _taxFee = taxFee;
867         }
868 
869         function _setTeamFee(uint256 teamFee) external onlyOwner() {
870             require(teamFee >= 1 && teamFee <= 8, 'teamFee should be in 1 - 8');
871             _teamFee = teamFee;
872         }
873 
874         function _setMarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
875             _marketingWalletAddress = marketingWalletAddress;
876         }
877 
878         function _setUseWallet(address payable useWalletAddress) external onlyOwner() {
879             _useWalletAddress = useWalletAddress;
880         }
881 
882         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
883             _maxTxAmount = maxTxAmount;
884         }
885 
886         function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
887           _maxWalletSize = maxWalletSize;
888         }
889     }