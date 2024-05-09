1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-26
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 /* 
7 
8 
9 ███╗░░░███╗███████╗██╗░░░██╗██╗░░██╗██╗██╗░░░░░██╗░░░░░███████╗██████╗░
10 ████╗░████║██╔════╝██║░░░██║██║░██╔╝██║██║░░░░░██║░░░░░██╔════╝██╔══██╗
11 ██╔████╔██║█████╗░░╚██╗░██╔╝█████═╝░██║██║░░░░░██║░░░░░█████╗░░██████╔╝
12 ██║╚██╔╝██║██╔══╝░░░╚████╔╝░██╔═██╗░██║██║░░░░░██║░░░░░██╔══╝░░██╔══██╗
13 ██║░╚═╝░██║███████╗░░╚██╔╝░░██║░╚██╗██║███████╗███████╗███████╗██║░░██║
14 ╚═╝░░░░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═╝░░╚═╝
15 
16 Tokenomics: 1% on to reflections on Buy/Sell, The real tokenomics are 1% buy and 10% sell
17 
18 Contract taxes are based off of rTotal instead of the delivered tTotal. 
19 Slippage is maintained at 1% while real tax taken on transfer from a non-excluded address(user -> uniswap LP, user -> user) is 10%(sell 100 tokens, 
20 taxed 10% with 1% slippage making it received funds of 90 tokens sold). 
21 The 10% is reserved to only be on sells, on buys you will not be taxed as it’s from an excluded address(uniswap LP -> user). 
22 The reserved tokens for marketing tax are sent to the contract to then be swap and liquified. 
23 The benefit of this method and transparency around the tax allows us to take advantage of mev bots volume and taxation. 
24 Just like users paying taxes, they will and since the slippage is low, 
25 they will not realize they are being taxed at 8% on sells until it has already occurred and profits are missed. 
26 This highly beneficial for the protocol to grow and use the volume to garner new heights.
27 */
28 pragma solidity ^0.6.12;
29 
30     abstract contract Context {
31         function _msgSender() internal view virtual returns (address payable) {
32             return msg.sender;
33         }
34         function _msgData() internal view virtual returns (bytes memory) {
35             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36             return msg.data;
37         }
38     }
39 
40     interface IERC20 {
41         function totalSupply() external view returns (uint256);
42         function balanceOf(address account) external view returns (uint256);
43         function transfer(address recipient, uint256 amount) external returns (bool);
44         function allowance(address owner, address spender) external view returns (uint256);
45         function approve(address spender, uint256 amount) external returns (bool);
46         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47         event Transfer(address indexed from, address indexed to, uint256 value);
48         event Approval(address indexed owner, address indexed spender, uint256 value);
49     }
50 
51     library SafeMath {
52         function add(uint256 a, uint256 b) internal pure returns (uint256) {
53             uint256 c = a + b;
54             require(c >= a, "SafeMath: addition overflow");
55             return c;
56         }
57         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58             return sub(a, b, "SafeMath: subtraction overflow");
59         }
60         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61             require(b <= a, errorMessage);
62             uint256 c = a - b;
63             return c;
64         }
65         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66             if (a == 0) {
67                 return 0;
68             }
69             uint256 c = a * b;
70             require(c / a == b, "SafeMath: multiplication overflow");
71             return c;
72         }
73         function div(uint256 a, uint256 b) internal pure returns (uint256) {
74             return div(a, b, "SafeMath: division by zero");
75         }
76         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77             require(b > 0, errorMessage);
78             uint256 c = a / b;
79             return c;
80         }
81         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82             return mod(a, b, "SafeMath: modulo by zero");
83         }
84         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85             require(b != 0, errorMessage);
86             return a % b;
87         }
88     }
89 
90     library Address {
91         function isContract(address account) internal view returns (bool) {
92             bytes32 codehash;
93             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
94             assembly { codehash := extcodehash(account) }
95             return (codehash != accountHash && codehash != 0x0);
96         }
97         function sendValue(address payable recipient, uint256 amount) internal {
98             require(address(this).balance >= amount, "Address: insufficient balance");
99             (bool success, ) = recipient.call{ value: amount }("");
100             require(success, "Address: unable to send value, recipient may have reverted");
101         }
102         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103         return functionCall(target, data, "Address: low-level call failed");
104         }
105         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
106             return _functionCallWithValue(target, data, 0, errorMessage);
107         }
108         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110         }
111         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
112             require(address(this).balance >= value, "Address: insufficient balance for call");
113             return _functionCallWithValue(target, data, value, errorMessage);
114         }
115         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
116             require(isContract(target), "Address: call to non-contract");
117             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
118             if (success) {
119                 return returndata;
120             } else {
121                 if (returndata.length > 0) {
122                     assembly {
123                         let returndata_size := mload(returndata)
124                         revert(add(32, returndata), returndata_size)
125                     }
126                 } else {
127                     revert(errorMessage);
128                 }
129             }
130         }
131     }
132 
133     contract Ownable is Context {
134         address private _owner;
135         address private _previousOwner;
136         uint256 private _lockTime;
137         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138         constructor () internal {
139             address msgSender = _msgSender();
140             _owner = msgSender;
141             emit OwnershipTransferred(address(0), msgSender);
142         }
143         function owner() public view returns (address) {
144             return _owner;
145         }
146         modifier onlyOwner() {
147             require(_owner == _msgSender(), "Ownable: caller is not the owner");
148             _;
149         }
150         function renounceOwnership() public virtual onlyOwner {
151             emit OwnershipTransferred(_owner, address(0));
152             _owner = address(0);
153         }
154         function transferOwnership(address newOwner) public virtual onlyOwner {
155             require(newOwner != address(0), "Ownable: new owner is the zero address");
156             emit OwnershipTransferred(_owner, newOwner);
157             _owner = newOwner;
158         }
159         function geUnlockTime() public view returns (uint256) {
160             return _lockTime;
161         }
162         function lock(uint256 time) public virtual onlyOwner {
163             _previousOwner = _owner;
164             _owner = address(0);
165             _lockTime = now + time;
166             emit OwnershipTransferred(_owner, address(0));
167         }
168         function unlock() public virtual {
169             require(_previousOwner == msg.sender, "You don't have permission to unlock");
170             require(now > _lockTime , "Contract is locked until 7 days");
171             emit OwnershipTransferred(_owner, _previousOwner);
172             _owner = _previousOwner;
173         }
174     }  
175 
176     interface IUniswapV2Factory {
177         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
178         function feeTo() external view returns (address);
179         function feeToSetter() external view returns (address);
180         function getPair(address tokenA, address tokenB) external view returns (address pair);
181         function allPairs(uint) external view returns (address pair);
182         function allPairsLength() external view returns (uint);
183         function createPair(address tokenA, address tokenB) external returns (address pair);
184         function setFeeTo(address) external;
185         function setFeeToSetter(address) external;
186     } 
187 
188     interface IUniswapV2Pair {
189         event Approval(address indexed owner, address indexed spender, uint value);
190         event Transfer(address indexed from, address indexed to, uint value);
191         function name() external pure returns (string memory);
192         function symbol() external pure returns (string memory);
193         function decimals() external pure returns (uint8);
194         function totalSupply() external view returns (uint);
195         function balanceOf(address owner) external view returns (uint);
196         function allowance(address owner, address spender) external view returns (uint);
197         function approve(address spender, uint value) external returns (bool);
198         function transfer(address to, uint value) external returns (bool);
199         function transferFrom(address from, address to, uint value) external returns (bool);
200         function DOMAIN_SEPARATOR() external view returns (bytes32);
201         function PERMIT_TYPEHASH() external pure returns (bytes32);
202         function nonces(address owner) external view returns (uint);
203         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
204         event Mint(address indexed sender, uint amount0, uint amount1);
205         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
206         event Swap(
207             address indexed sender,
208             uint amount0In,
209             uint amount1In,
210             uint amount0Out,
211             uint amount1Out,
212             address indexed to
213         );
214         event Sync(uint112 reserve0, uint112 reserve1);
215         function MINIMUM_LIQUIDITY() external pure returns (uint);
216         function factory() external view returns (address);
217         function token0() external view returns (address);
218         function token1() external view returns (address);
219         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
220         function price0CumulativeLast() external view returns (uint);
221         function price1CumulativeLast() external view returns (uint);
222         function kLast() external view returns (uint);
223         function mint(address to) external returns (uint liquidity);
224         function burn(address to) external returns (uint amount0, uint amount1);
225         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
226         function skim(address to) external;
227         function sync() external;
228         function initialize(address, address) external;
229     }
230 
231     interface IUniswapV2Router01 {
232         function factory() external pure returns (address);
233         function WETH() external pure returns (address);
234         function addLiquidity(
235             address tokenA,
236             address tokenB,
237             uint amountADesired,
238             uint amountBDesired,
239             uint amountAMin,
240             uint amountBMin,
241             address to,
242             uint deadline
243         ) external returns (uint amountA, uint amountB, uint liquidity);
244         function addLiquidityETH(
245             address token,
246             uint amountTokenDesired,
247             uint amountTokenMin,
248             uint amountETHMin,
249             address to,
250             uint deadline
251         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
252         function removeLiquidity(
253             address tokenA,
254             address tokenB,
255             uint liquidity,
256             uint amountAMin,
257             uint amountBMin,
258             address to,
259             uint deadline
260         ) external returns (uint amountA, uint amountB);
261         function removeLiquidityETH(
262             address token,
263             uint liquidity,
264             uint amountTokenMin,
265             uint amountETHMin,
266             address to,
267             uint deadline
268         ) external returns (uint amountToken, uint amountETH);
269         function removeLiquidityWithPermit(
270             address tokenA,
271             address tokenB,
272             uint liquidity,
273             uint amountAMin,
274             uint amountBMin,
275             address to,
276             uint deadline,
277             bool approveMax, uint8 v, bytes32 r, bytes32 s
278         ) external returns (uint amountA, uint amountB);
279         function removeLiquidityETHWithPermit(
280             address token,
281             uint liquidity,
282             uint amountTokenMin,
283             uint amountETHMin,
284             address to,
285             uint deadline,
286             bool approveMax, uint8 v, bytes32 r, bytes32 s
287         ) external returns (uint amountToken, uint amountETH);
288         function swapExactTokensForTokens(
289             uint amountIn,
290             uint amountOutMin,
291             address[] calldata path,
292             address to,
293             uint deadline
294         ) external returns (uint[] memory amounts);
295         function swapTokensForExactTokens(
296             uint amountOut,
297             uint amountInMax,
298             address[] calldata path,
299             address to,
300             uint deadline
301         ) external returns (uint[] memory amounts);
302         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
303             external
304             payable
305             returns (uint[] memory amounts);
306         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
307             external
308             returns (uint[] memory amounts);
309         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
310             external
311             returns (uint[] memory amounts);
312         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
313             external
314             payable
315             returns (uint[] memory amounts);
316 
317         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
318         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
319         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
320         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
321         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
322     }
323 
324     interface IUniswapV2Router02 is IUniswapV2Router01 {
325         function removeLiquidityETHSupportingFeeOnTransferTokens(
326             address token,
327             uint liquidity,
328             uint amountTokenMin,
329             uint amountETHMin,
330             address to,
331             uint deadline
332         ) external returns (uint amountETH);
333         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
334             address token,
335             uint liquidity,
336             uint amountTokenMin,
337             uint amountETHMin,
338             address to,
339             uint deadline,
340             bool approveMax, uint8 v, bytes32 r, bytes32 s
341         ) external returns (uint amountETH);
342 
343         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
344             uint amountIn,
345             uint amountOutMin,
346             address[] calldata path,
347             address to,
348             uint deadline
349         ) external;
350         function swapExactETHForTokensSupportingFeeOnTransferTokens(
351             uint amountOutMin,
352             address[] calldata path,
353             address to,
354             uint deadline
355         ) external payable;
356         function swapExactTokensForETHSupportingFeeOnTransferTokens(
357             uint amountIn,
358             uint amountOutMin,
359             address[] calldata path,
360             address to,
361             uint deadline
362         ) external;
363     }
364 
365     contract MEVKiller is Context, IERC20, Ownable {
366         using SafeMath for uint256;
367         using Address for address;
368 
369         mapping (address => bool) public _isBlacklisted;
370         mapping (address => uint256) private _rOwned;
371         mapping (address => uint256) private _tOwned;
372         mapping (address => mapping (address => uint256)) private _allowances;
373         mapping (address => bool) private _isExcludedFromFee;
374 
375         mapping (address => bool) private _isExcluded;
376         address[] private _excluded;
377     
378         uint256 private constant MAX = ~uint256(0);
379         uint256 private _tTotal = 10000000000 * 10**9;
380         uint256 private _rTotal = (MAX - (MAX % _tTotal));
381         uint256 private _tFeeTotal;
382 
383         string private _name = 'MEV Killer';
384         string private _symbol = 'MEVKILLER';
385         uint8 private _decimals = 9;
386 
387         uint256 private _taxFee = 1; 
388         uint256 private _MarketingFee = 10;
389         uint256 private _previousTaxFee = _taxFee;
390         uint256 private _previousMarketingFee = _MarketingFee;
391 
392         address payable public _MarketingWalletAddress;
393         
394         IUniswapV2Router02 public immutable uniswapV2Router;
395         address public immutable uniswapV2Pair;
396 
397         bool inSwap = false;
398         bool public swapEnabled = true;
399 
400         uint256 private _maxTxAmount = 200000000e9;
401         // We will set a minimum amount of tokens to be swaped => 5M
402         uint256 private _numOfTokensToExchangeForMarketing = 5 * 10**3 * 10**9;
403 
404         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
405         event SwapEnabledUpdated(bool enabled);
406 
407         modifier lockTheSwap {
408             inSwap = true;
409             _;
410             inSwap = false;
411         }
412 
413         constructor (address payable MarketingWalletAddress) public {
414             _MarketingWalletAddress = MarketingWalletAddress;
415             _rOwned[_msgSender()] = _rTotal;
416 
417             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
418             // Create a uniswap pair for this new token
419             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
420                 .createPair(address(this), _uniswapV2Router.WETH());
421 
422             // set the rest of the contract variables
423             uniswapV2Router = _uniswapV2Router;
424 
425             // Exclude owner and this contract from fee
426             _isExcludedFromFee[owner()] = true;
427             _isExcludedFromFee[address(this)] = true;
428             _isExcludedFromFee[_MarketingWalletAddress] = true;
429        
430 
431             emit Transfer(address(0), _msgSender(), _tTotal);
432         }
433 
434         function name() public view returns (string memory) {return _name;}
435         function symbol() public view returns (string memory) {return _symbol;}
436         function decimals() public view returns (uint8) {return _decimals;}
437         function totalSupply() public view override returns (uint256) {return _tTotal;}
438 
439         function balanceOf(address account) public view override returns (uint256) {
440             if (_isExcluded[account]) return _tOwned[account];
441             return tokenFromReflection(_rOwned[account]);
442         }
443 
444         function transfer(address recipient, uint256 amount) public override returns (bool) {
445         _transfer(_msgSender(), recipient, amount);
446         return true;
447         }
448 
449         function allowance(address owner, address spender) public view override returns (uint256) {
450             return _allowances[owner][spender];
451         }
452 
453         function approve(address spender, uint256 amount) public override returns (bool) {
454             _approve(_msgSender(), spender, amount);
455             return true;
456         }
457 
458         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
459             _transfer(sender, recipient, amount);
460             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
461             return true;
462         }
463 
464         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
465             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
466             return true;
467         }
468 
469         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
470             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
471             return true;
472         }
473 
474         function isExcluded(address account) public view returns (bool) {
475             return _isExcluded[account];
476         }
477 
478         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
479             _isExcludedFromFee[account] = excluded;
480         }
481 
482         function totalFees() public view returns (uint256) {return _tFeeTotal;}
483 
484         function deliver(uint256 tAmount) public {
485             address sender = _msgSender();
486             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
487             (uint256 rAmount,,,,,) = _getValues(tAmount);
488             _rOwned[sender] = _rOwned[sender].sub(rAmount);
489             _rTotal = _rTotal.sub(rAmount);
490             _tFeeTotal = _tFeeTotal.add(tAmount);
491         }
492 
493         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
494             require(tAmount <= _tTotal, "Amount must be less than supply");
495             if (!deductTransferFee) {
496                 (uint256 rAmount,,,,,) = _getValues(tAmount);
497                 return rAmount;
498             } else {
499                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
500                 return rTransferAmount;
501             }
502         }
503 
504         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
505             require(rAmount <= _rTotal, "Amount must be less than total reflections");
506             uint256 currentRate =  _getRate();
507             return rAmount.div(currentRate);
508         }
509 
510         function excludeAccount(address account) external onlyOwner() {
511             require(account != 0x50e617C888934F49054e8D0D23E8EED62b7a4395, 'We can not exclude Uniswap router.');
512             require(!_isExcluded[account], "Account is already excluded");
513             if(_rOwned[account] > 0) {
514                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
515             }
516             _isExcluded[account] = true;
517             _excluded.push(account);
518         }
519 
520         function includeAccount(address account) external onlyOwner() {
521             require(_isExcluded[account], "Account is already excluded");
522             for (uint256 i = 0; i < _excluded.length; i++) {
523                 if (_excluded[i] == account) {
524                     _excluded[i] = _excluded[_excluded.length - 1];
525                     _tOwned[account] = 0;
526                     _isExcluded[account] = false;
527                     _excluded.pop();
528                     break;
529                 }
530             }
531         }
532 
533         function removeAllFee() private {
534             if(_taxFee == 0 && _MarketingFee == 0) return;
535             
536             _previousTaxFee = _taxFee;
537             _previousMarketingFee = _MarketingFee;
538             
539             _taxFee = 0;
540             _MarketingFee = 0;
541         }
542     
543         function restoreAllFee() private {
544             _taxFee = _previousTaxFee;
545             _MarketingFee = _previousMarketingFee;
546         }
547     
548         function isExcludedFromFee(address account) public view returns(bool) {
549             return _isExcludedFromFee[account];
550         }
551 
552         function _approve(address owner, address spender, uint256 amount) private {
553             require(owner != address(0), "ERC20: approve from the zero address");
554             require(spender != address(0), "ERC20: approve to the zero address");
555 
556             _allowances[owner][spender] = amount;
557             emit Approval(owner, spender, amount);
558         }
559 
560         function _transfer(address sender, address recipient, uint256 amount) private {
561             //blacklisted addresses can not buy! If you have ever used a bot, or scammed anybody, then you're wallet address will probably be blacklisted.
562             require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "This address is blacklisted");
563             require(sender != address(0), "ERC20: transfer from the zero address");
564             require(recipient != address(0), "ERC20: transfer to the zero address");
565             require(amount > 0, "Transfer amount must be greater than zero");
566             
567             if(sender != owner() && recipient != owner())
568                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
569 
570             // is the token balance of this contract address over the min number of
571             // tokens that we need to initiate a swap?
572             // also, don't swap if sender is uniswap pair.
573             uint256 contractTokenBalance = balanceOf(address(this));
574             
575             if(contractTokenBalance >= _maxTxAmount)
576             {
577                 contractTokenBalance = _maxTxAmount;
578             }
579             
580             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForMarketing;
581             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
582                 // We need to swap the current tokens to ETH and send to the Marketing wallet
583                 swapTokensForEth(contractTokenBalance);
584                 
585                 uint256 contractETHBalance = address(this).balance;
586                 if(contractETHBalance > 0) {
587                     sendETHToMarketing(address(this).balance);
588                 }
589             }
590             
591             //indicates if fee should be deducted from transfer
592             bool takeFee = true;
593             
594             //if any account belongs to _isExcludedFromFee account then remove the fee
595             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
596                 takeFee = false;
597             }
598             
599             //transfer amount, it will take tax and Marketing fee
600             _tokenTransfer(sender,recipient,amount,takeFee);
601         }
602 
603         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
604             // generate the uniswap pair path of token -> weth
605             address[] memory path = new address[](2);
606             path[0] = address(this);
607             path[1] = uniswapV2Router.WETH();
608 
609             _approve(address(this), address(uniswapV2Router), tokenAmount);
610 
611             // make the swap
612             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
613                 tokenAmount,
614                 0, // accept any amount of ETH
615                 path,
616                 address(this),
617                 block.timestamp
618             );
619         }
620         
621         function sendETHToMarketing(uint256 amount) private {
622             _MarketingWalletAddress.transfer(amount.mul(3).div(8));
623           
624         }
625         
626         // We are exposing these functions to be able to manual swap and send
627         // in case the token is highly valued and 5M becomes too much
628         function manualSwap() external onlyOwner() {
629             uint256 contractBalance = balanceOf(address(this));
630             swapTokensForEth(contractBalance);
631         }
632         
633         function manualSend() external {
634             require(msg.sender==_MarketingWalletAddress);
635             uint256 contractETHBalance = address(this).balance;
636             sendETHToMarketing(contractETHBalance);
637         }
638 
639         function setSwapEnabled(bool enabled) external onlyOwner(){
640             swapEnabled = enabled;
641         }
642         
643         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
644             if(!takeFee)
645                 removeAllFee();
646 
647             if (_isExcluded[sender] && !_isExcluded[recipient]) {
648                 _transferFromExcluded(sender, recipient, amount);
649             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
650                 _transferToExcluded(sender, recipient, amount);
651             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
652                 _transferStandard(sender, recipient, amount);
653             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
654                 _transferBothExcluded(sender, recipient, amount);
655             } else {
656                 _transferStandard(sender, recipient, amount);
657             }
658 
659             if(!takeFee)
660                 restoreAllFee();
661         }
662 
663         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
664             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
665             _rOwned[sender] = _rOwned[sender].sub(rAmount);
666             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
667             _takeMarketing(tMarketing); 
668             _reflectFee(rFee, tFee);
669             emit Transfer(sender, recipient, tTransferAmount);
670         }
671 
672         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
673             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
674             _rOwned[sender] = _rOwned[sender].sub(rAmount);
675             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
676             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
677             _takeMarketing(tMarketing);           
678             _reflectFee(rFee, tFee);
679             emit Transfer(sender, recipient, tTransferAmount);
680         }
681 
682         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
683             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
684             _tOwned[sender] = _tOwned[sender].sub(tAmount);
685             _rOwned[sender] = _rOwned[sender].sub(rAmount);
686             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
687             _takeMarketing(tMarketing);   
688             _reflectFee(rFee, tFee);
689             emit Transfer(sender, recipient, tTransferAmount);
690         }
691 
692         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
693             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
694             _tOwned[sender] = _tOwned[sender].sub(tAmount);
695             _rOwned[sender] = _rOwned[sender].sub(rAmount);
696             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
697             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
698             _takeMarketing(tMarketing);         
699             _reflectFee(rFee, tFee);
700             emit Transfer(sender, recipient, tTransferAmount);
701         }
702 
703         function _takeMarketing(uint256 tMarketing) private {
704             uint256 currentRate =  _getRate();
705             uint256 rMarketing = tMarketing.mul(currentRate);
706             _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
707             if(_isExcluded[address(this)])
708                 _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
709         }
710 
711         function _reflectFee(uint256 rFee, uint256 tFee) private {
712             _rTotal = _rTotal.sub(rFee);
713             _tFeeTotal = _tFeeTotal.add(tFee);
714         }
715 
716          //to recieve ETH from uniswapV2Router when swaping
717         receive() external payable {}
718 
719         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
720             (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount, _taxFee, _MarketingFee);
721             uint256 currentRate =  _getRate();
722             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
723             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
724         }
725 
726         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 MarketingFee) private pure returns (uint256, uint256, uint256) {
727             uint256 tFee = tAmount.mul(taxFee).div(100);
728             uint256 tMarketing = tAmount.mul(MarketingFee).div(100);
729             uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
730             return (tTransferAmount, tFee, tMarketing);
731         }
732 
733         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
734             uint256 rAmount = tAmount.mul(currentRate);
735             uint256 rFee = tFee.mul(currentRate);
736             uint256 rTransferAmount = rAmount.sub(rFee);
737             return (rAmount, rTransferAmount, rFee);
738         }
739 
740         function _getRate() private view returns(uint256) {
741             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
742             return rSupply.div(tSupply);
743         }
744 
745         function _getCurrentSupply() private view returns(uint256, uint256) {
746             uint256 rSupply = _rTotal;
747             uint256 tSupply = _tTotal;      
748             for (uint256 i = 0; i < _excluded.length; i++) {
749                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
750                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
751                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
752             }
753             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
754             return (rSupply, tSupply);
755         }
756         
757         function _getTaxFee() private view returns(uint256) {return _taxFee;}
758         function _getMaxTxAmount() public view returns(uint256) {return _maxTxAmount;}
759         function _getETHBalance() public view returns(uint256 balance) {return address(this).balance;}
760         
761         function _setTaxFee(uint256 taxFee) external onlyOwner() {
762             require(taxFee >= 0 && taxFee <= 10, 'taxFee should be in 0 - 10');
763             _taxFee = taxFee;
764         }
765 
766         function _setMarketingFee(uint256 MarketingFee) external onlyOwner() {
767             require(MarketingFee >= 1 && MarketingFee <= 10, 'MarketingFee should be in 1 - 10');
768             _MarketingFee = MarketingFee;
769         }
770         
771         function _setMarketingWallet(address payable MarketingWalletAddress) external onlyOwner() {
772             _MarketingWalletAddress = MarketingWalletAddress;
773         }
774         
775         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {_maxTxAmount = maxTxAmount;}
776         function removeFromBlackList(address account) external onlyOwner{_isBlacklisted[account] = false;}
777 
778          //adding multiple address to the blacklist - used to manually block known bots and scammers
779         function addToBlackList(address[] calldata  addresses) external onlyOwner {
780         for(uint256 i; i < addresses.length; ++i) {
781             _isBlacklisted[addresses[i]] = true;
782             }
783         }
784    
785     }