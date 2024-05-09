1 // SPDX-License-Identifier: Unlicensed
2 
3 /*
4 medium.com/@atarashionmyoji
5 */
6 
7 pragma solidity ^0.8.4;
8 
9 interface IERC20 {
10     
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31     
32     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             if (b > a) return (false, 0);
35             return (true, a - b);
36         }
37     }
38     
39     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42             // benefit is lost if 'b' is also tested.
43             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
44             if (a == 0) return (true, 0);
45             uint256 c = a * b;
46             if (c / a != b) return (false, 0);
47             return (true, c);
48         }
49     }
50     
51     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b == 0) return (false, 0);
54             return (true, a / b);
55         }
56     }
57     
58     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b == 0) return (false, 0);
61             return (true, a % b);
62         }
63     }
64 
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         return a + b;
67     }
68 
69 
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a - b;
72     }
73 
74 
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a * b;
77     }
78     
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a / b;
81     }
82 
83 
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         return a % b;
86     }
87     
88     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         unchecked {
90             require(b <= a, errorMessage);
91             return a - b;
92         }
93     }
94     
95     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         unchecked {
97             require(b > 0, errorMessage);
98             return a / b;
99         }
100     }
101     
102     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         unchecked {
104             require(b > 0, errorMessage);
105             return a % b;
106         }
107     }
108 }
109 
110 
111 
112 
113 abstract contract Context {
114     function _msgSender() internal view virtual returns (address) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view virtual returns (bytes calldata) {
119         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
120         return msg.data;
121     }
122 }
123 
124 
125 library Address {
126     
127     function isContract(address account) internal view returns (bool) {
128         uint256 size;
129         assembly { size := extcodesize(account) }
130         return size > 0;
131     }
132 
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135         (bool success, ) = recipient.call{ value: amount }("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138     
139     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
140       return functionCall(target, data, "Address: low-level call failed");
141     }
142     
143     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
144         return functionCallWithValue(target, data, 0, errorMessage);
145     }
146     
147     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
148         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
149     }
150     
151     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
152         require(address(this).balance >= value, "Address: insufficient balance for call");
153         require(isContract(target), "Address: call to non-contract");
154         (bool success, bytes memory returndata) = target.call{ value: value }(data);
155         return _verifyCallResult(success, returndata, errorMessage);
156     }
157     
158     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
159         return functionStaticCall(target, data, "Address: low-level static call failed");
160     }
161     
162     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
163         require(isContract(target), "Address: static call to non-contract");
164         (bool success, bytes memory returndata) = target.staticcall(data);
165         return _verifyCallResult(success, returndata, errorMessage);
166     }
167 
168 
169     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
171     }
172     
173     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
174         require(isContract(target), "Address: delegate call to non-contract");
175         (bool success, bytes memory returndata) = target.delegatecall(data);
176         return _verifyCallResult(success, returndata, errorMessage);
177     }
178 
179     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
180         if (success) {
181             return returndata;
182         } else {
183             if (returndata.length > 0) {
184                  assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 
196 
197 abstract contract Ownable is Context {
198     address internal _owner;
199     address private _previousOwner;
200     uint256 public _lockTime;
201 
202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203     constructor () {
204         _owner = _msgSender();
205         emit OwnershipTransferred(address(0), _owner);
206     }
207     
208     function owner() public view virtual returns (address) {
209         return _owner;
210     }
211     
212     modifier onlyOwner() {
213         require(owner() == _msgSender(), "Ownable: caller is not the owner");
214         _;
215     }
216     
217     function renounceOwnership() public virtual onlyOwner {
218         emit OwnershipTransferred(_owner, address(0));
219         _owner = address(0);
220     }
221 
222 
223     function transferOwnership(address newOwner) public virtual onlyOwner {
224         require(newOwner != address(0), "Ownable: new owner is the zero address");
225         emit OwnershipTransferred(_owner, newOwner);
226         _owner = newOwner;
227     }
228 
229 
230         //Locks the contract for owner for the amount of time provided
231     function lock(uint256 time) public virtual onlyOwner {
232         _previousOwner = _owner;
233         _owner = address(0);
234         _lockTime = time;
235         emit OwnershipTransferred(_owner, address(0));
236     }
237     
238     //Unlocks the contract for owner when _lockTime is exceeds
239     function unlock() public virtual {
240         require(_previousOwner == msg.sender, "You don't have permission to unlock.");
241         require(block.timestamp > _lockTime , "Contract is locked.");
242         emit OwnershipTransferred(_owner, _previousOwner);
243         _owner = _previousOwner;
244     }
245 }
246 
247 interface IUniswapV2Factory {
248     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
249     function feeTo() external view returns (address);
250     function feeToSetter() external view returns (address);
251     function getPair(address tokenA, address tokenB) external view returns (address pair);
252     function allPairs(uint) external view returns (address pair);
253     function allPairsLength() external view returns (uint);
254     function createPair(address tokenA, address tokenB) external returns (address pair);
255     function setFeeTo(address) external;
256     function setFeeToSetter(address) external;
257 }
258 
259 interface IUniswapV2Pair {
260     event Approval(address indexed owner, address indexed spender, uint value);
261     event Transfer(address indexed from, address indexed to, uint value);
262     function name() external pure returns (string memory);
263     function symbol() external pure returns (string memory);
264     function decimals() external pure returns (uint8);
265     function totalSupply() external view returns (uint);
266     function balanceOf(address owner) external view returns (uint);
267     function allowance(address owner, address spender) external view returns (uint);
268     function approve(address spender, uint value) external returns (bool);
269     function transfer(address to, uint value) external returns (bool);
270     function transferFrom(address from, address to, uint value) external returns (bool);
271     function DOMAIN_SEPARATOR() external view returns (bytes32);
272     function PERMIT_TYPEHASH() external pure returns (bytes32);
273     function nonces(address owner) external view returns (uint);
274     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
275     event Mint(address indexed sender, uint amount0, uint amount1);
276     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
277     event Swap(
278         address indexed sender,
279         uint amount0In,
280         uint amount1In,
281         uint amount0Out,
282         uint amount1Out,
283         address indexed to
284     );
285     event Sync(uint112 reserve0, uint112 reserve1);
286     function MINIMUM_LIQUIDITY() external pure returns (uint);
287     function factory() external view returns (address);
288     function token0() external view returns (address);
289     function token1() external view returns (address);
290     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
291     function price0CumulativeLast() external view returns (uint);
292     function price1CumulativeLast() external view returns (uint);
293     function kLast() external view returns (uint);
294     function mint(address to) external returns (uint liquidity);
295     function burn(address to) external returns (uint amount0, uint amount1);
296     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
297     function skim(address to) external;
298     function sync() external;
299     function initialize(address, address) external;
300 }
301 
302 interface IUniswapV2Router01 {
303     function factory() external pure returns (address);
304     function WETH() external pure returns (address);
305     function addLiquidity(
306         address tokenA,
307         address tokenB,
308         uint amountADesired,
309         uint amountBDesired,
310         uint amountAMin,
311         uint amountBMin,
312         address to,
313         uint deadline
314     ) external returns (uint amountA, uint amountB, uint liquidity);
315     function addLiquidityETH(
316         address token,
317         uint amountTokenDesired,
318         uint amountTokenMin,
319         uint amountETHMin,
320         address to,
321         uint deadline
322     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
323     function removeLiquidity(
324         address tokenA,
325         address tokenB,
326         uint liquidity,
327         uint amountAMin,
328         uint amountBMin,
329         address to,
330         uint deadline
331     ) external returns (uint amountA, uint amountB);
332     function removeLiquidityETH(
333         address token,
334         uint liquidity,
335         uint amountTokenMin,
336         uint amountETHMin,
337         address to,
338         uint deadline
339     ) external returns (uint amountToken, uint amountETH);
340     function removeLiquidityWithPermit(
341         address tokenA,
342         address tokenB,
343         uint liquidity,
344         uint amountAMin,
345         uint amountBMin,
346         address to,
347         uint deadline,
348         bool approveMax, uint8 v, bytes32 r, bytes32 s
349     ) external returns (uint amountA, uint amountB);
350     function removeLiquidityETHWithPermit(
351         address token,
352         uint liquidity,
353         uint amountTokenMin,
354         uint amountETHMin,
355         address to,
356         uint deadline,
357         bool approveMax, uint8 v, bytes32 r, bytes32 s
358     ) external returns (uint amountToken, uint amountETH);
359     function swapExactTokensForTokens(
360         uint amountIn,
361         uint amountOutMin,
362         address[] calldata path,
363         address to,
364         uint deadline
365     ) external returns (uint[] memory amounts);
366     function swapTokensForExactTokens(
367         uint amountOut,
368         uint amountInMax,
369         address[] calldata path,
370         address to,
371         uint deadline
372     ) external returns (uint[] memory amounts);
373     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
374         external
375         payable
376         returns (uint[] memory amounts);
377     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
378         external
379         returns (uint[] memory amounts);
380     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
381         external
382         returns (uint[] memory amounts);
383     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
384         external
385         payable
386         returns (uint[] memory amounts);
387 
388     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
389     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
390     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
391     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
392     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
393 }
394 
395 interface IUniswapV2Router02 is IUniswapV2Router01 {
396     function removeLiquidityETHSupportingFeeOnTransferTokens(
397         address token,
398         uint liquidity,
399         uint amountTokenMin,
400         uint amountETHMin,
401         address to,
402         uint deadline
403     ) external returns (uint amountETH);
404     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
405         address token,
406         uint liquidity,
407         uint amountTokenMin,
408         uint amountETHMin,
409         address to,
410         uint deadline,
411         bool approveMax, uint8 v, bytes32 r, bytes32 s
412     ) external returns (uint amountETH);
413 
414     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
415         uint amountIn,
416         uint amountOutMin,
417         address[] calldata path,
418         address to,
419         uint deadline
420     ) external;
421     function swapExactETHForTokensSupportingFeeOnTransferTokens(
422         uint amountOutMin,
423         address[] calldata path,
424         address to,
425         uint deadline
426     ) external payable;
427     function swapExactTokensForETHSupportingFeeOnTransferTokens(
428         uint amountIn,
429         uint amountOutMin,
430         address[] calldata path,
431         address to,
432         uint deadline
433     ) external;
434 }
435 
436 contract AtarashiOnmyoji  is Context, IERC20, Ownable {
437     using SafeMath for uint256;
438     using Address for address;
439 
440     mapping (address => uint256) private _rOwned;
441     mapping (address => uint256) private _tOwned;
442     mapping (address => mapping (address => uint256)) private _allowances;
443     mapping (address => bool) private _isExcludedFromFee;
444     mapping (address => bool) private _isExcluded;
445     address[] private _excluded;
446     address public _marketingWalletAddress;     // TODO - team wallet here
447     address public _burnAddress = 0x000000000000000000000000000000000000dEaD;
448     uint256 private constant MAX = ~uint256(0);
449     uint256 private _tTotal;
450     uint256 private _rTotal;
451     uint256 private _tFeeTotal;
452     string private _name;
453     string private _symbol;
454     uint256 private _decimals;
455 
456     // Buy tax 
457     uint256 private _buyTaxFee       = 0;
458     uint256 private _buyLiquidityFee = 0;
459     uint256 private _buyMarketingFee = 0;
460 
461     // Sell tax 
462     uint256 private _sellTaxFee       = 0; 
463     uint256 private _sellLiquidityFee = 0;
464     uint256 private _sellMarketingFee = 0;
465 
466     uint256 public _taxFee = _buyTaxFee;
467     uint256 public _liquidityFee = _buyLiquidityFee;
468     uint256 public _marketingFee = _buyMarketingFee;
469 
470     uint256 private _previousTaxFee = _taxFee;
471     uint256 private _previousMarketingFee = _liquidityFee;
472     uint256 private _previousLiquidityFee = _marketingFee;
473     
474     uint256 public _maxWallet;
475     
476     IUniswapV2Router02 public uniswapV2Router;
477     address public uniswapV2Pair;
478     bool inSwapAndLiquify;
479     bool public swapAndLiquifyEnabled = true;
480     uint256 public numTokensSellToAddToLiquidity;
481     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
482     event MaxWalletUpdated(uint256 newMaxWallet);
483     event SwapAndLiquifyEnabledUpdated(bool enabled);
484     event SwapAndLiquify(
485         uint256 tokensSwapped,
486         uint256 ethReceived,
487         uint256 tokensIntoLiqudity
488     );
489     
490     modifier lockTheSwap {
491         inSwapAndLiquify = true;
492         _;
493         inSwapAndLiquify = false;
494     }
495     
496     constructor () {
497         _name = "Atarashi Onmyoji";
498         _symbol = "ONMYOJI";
499         _decimals = 9;
500         _tTotal = 10000000000 * 10 ** _decimals;
501         _rTotal = (MAX - (MAX % _tTotal));
502         numTokensSellToAddToLiquidity = 1000000 * 10 ** _decimals;
503         _marketingWalletAddress = msg.sender;
504         _maxWallet = 2 * _tTotal / 100;
505         _rOwned[_msgSender()] = _rTotal;
506         
507         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
508          // Create a uniswap pair for this new token
509         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
510             .createPair(address(this), _uniswapV2Router.WETH());
511 
512         // set the rest of the contract variables
513         uniswapV2Router = _uniswapV2Router;
514         
515         //exclude owner and this contract from fee
516         _isExcludedFromFee[_msgSender()] = true;
517         _isExcludedFromFee[address(this)] = true;
518 
519         //exclude from rewards 
520         _isExcluded[_burnAddress] = true;
521         _isExcluded[uniswapV2Pair] = true;
522     
523         _owner = _msgSender();
524         emit Transfer(address(0), _msgSender(), _tTotal);
525 		
526 		
527     }
528 
529     function name() public view returns (string memory) {
530         return _name;
531     }
532 
533     function symbol() public view returns (string memory) {
534         return _symbol;
535     }
536 
537     function decimals() public view returns (uint256) {
538         return _decimals;
539     }
540 
541     function totalSupply() public view override returns (uint256) {
542         return _tTotal;
543     }
544 
545     function balanceOf(address account) public view override returns (uint256) {
546         if (_isExcluded[account]) return _tOwned[account];
547         return tokenFromReflection(_rOwned[account]);
548     }
549 
550     function transfer(address recipient, uint256 amount) public override returns (bool) {
551         _transfer(_msgSender(), recipient, amount);
552         return true;
553     }
554 
555     function allowance(address owner, address spender) public view override returns (uint256) {
556         return _allowances[owner][spender];
557     }
558 
559     function approve(address spender, uint256 amount) public override returns (bool) {
560         _approve(_msgSender(), spender, amount);
561         return true;
562     }
563 
564     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
565         _transfer(sender, recipient, amount);
566         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
567         return true;
568     }
569 
570     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
571         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
572         return true;
573     }
574 
575     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
576         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
577         return true;
578     }
579 
580     function isExcludedFromReward(address account) public view returns (bool) {
581         return _isExcluded[account];
582     }
583 
584     function totalFees() public view returns (uint256) {
585         return _tFeeTotal;
586     }
587 
588     function deliver(uint256 tAmount) public {
589         address sender = _msgSender();
590         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
591         (uint256 rAmount,,,,,,) = _getValues(tAmount);
592         _rOwned[sender] = _rOwned[sender].sub(rAmount);
593         _rTotal = _rTotal.sub(rAmount);
594         _tFeeTotal = _tFeeTotal.add(tAmount);
595     }
596 
597     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
598         require(tAmount <= _tTotal, "Amount must be less than supply");
599         if (!deductTransferFee) {
600             (uint256 rAmount,,,,,,) = _getValues(tAmount);
601             return rAmount;
602         } else {
603             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
604             return rTransferAmount;
605         }
606     }
607 
608     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
609         require(rAmount <= _rTotal, "Amount must be less than total reflections");
610         uint256 currentRate =  _getRate();
611         return rAmount.div(currentRate);
612     }
613 
614     function excludeFromReward(address account) public onlyOwner() {
615         require(!_isExcluded[account], "Account is already excluded");
616         if(_rOwned[account] > 0) {
617             _tOwned[account] = tokenFromReflection(_rOwned[account]);
618         }
619         _isExcluded[account] = true;
620         _excluded.push(account);
621     }
622 
623     function includeInReward(address account) external onlyOwner() {
624         require(_isExcluded[account], "Account is already included");
625         for (uint256 i = 0; i < _excluded.length; i++) {
626             if (_excluded[i] == account) {
627                 _excluded[i] = _excluded[_excluded.length - 1];
628                 _tOwned[account] = 0;
629                 _isExcluded[account] = false;
630                 _excluded.pop();
631                 break;
632             }
633         }
634     }
635 
636     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
637         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
638         _tOwned[sender] = _tOwned[sender].sub(tAmount);
639         _rOwned[sender] = _rOwned[sender].sub(rAmount);
640         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
641         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
642         _takeLiquidity(tLiquidity);
643         _takeMarketing(tMarketing);
644         _reflectFee(rFee, tFee);
645         emit Transfer(sender, recipient, tTransferAmount);
646     }
647     
648     function excludeFromFee(address account) public onlyOwner {
649         _isExcludedFromFee[account] = true;
650     }
651     
652     function includeInFee(address account) public onlyOwner {
653         _isExcludedFromFee[account] = false;
654     }
655 
656     function setSellFeePercent(uint256 tFee, uint256 lFee, uint256 mFee) external onlyOwner() {
657        _sellTaxFee       = tFee; 
658        _sellLiquidityFee = lFee;
659        _sellMarketingFee = mFee;
660     }
661 
662     function setBuyFeePercent(uint256 tFee, uint256 lFee, uint256 mFee) external onlyOwner() {
663        _buyTaxFee       = tFee; 
664        _buyLiquidityFee = lFee;
665        _buyMarketingFee = mFee;
666     } 
667    
668     function setMarketingWalletAddress(address _addr) external onlyOwner {
669         _marketingWalletAddress = _addr;
670     }
671     
672     function setNumTokensSellToAddToLiquidity(uint256 amount) external onlyOwner {
673         numTokensSellToAddToLiquidity = amount * 10 **_decimals;
674 
675         emit MinTokensBeforeSwapUpdated(amount);
676     }
677     
678     function setMaxWallet(uint256 maxWallet) external onlyOwner {
679         _maxWallet = maxWallet * 10 ** _decimals;
680 
681         emit MaxWalletUpdated(maxWallet);
682     }
683 
684     function setRouterAddress(address newRouter) external onlyOwner {
685         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouter);
686         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
687         uniswapV2Router = _uniswapV2Router;
688     }
689 
690     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
691         swapAndLiquifyEnabled = _enabled;
692         emit SwapAndLiquifyEnabledUpdated(_enabled);
693     }
694     
695      //to recieve ETH from uniswapV2Router when swaping
696     receive() external payable {}
697 
698     // to withdraw stucked ETH 
699     function withdrawStuckedFunds(uint amount) external onlyOwner{
700         // This is the current recommended method to use.
701         (bool sent,) = _owner.call{value: amount}("");
702         require(sent, "Failed to send ETH");    
703         }
704 
705     function _reflectFee(uint256 rFee, uint256 tFee) private {
706         _rTotal = _rTotal.sub(rFee);
707         _tFeeTotal = _tFeeTotal.add(tFee);
708     }
709 
710     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
711         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getTValues(tAmount);
712         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, _getRate());
713         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tMarketing);
714     }
715 
716     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
717         uint256 tFee = calculateTaxFee(tAmount);
718         uint256 tLiquidity = calculateLiquidityFee(tAmount);
719         uint256 tMarketing = calculateMarketingFee(tAmount);
720         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tMarketing);
721         return (tTransferAmount, tFee, tLiquidity, tMarketing);
722     }
723 
724     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
725         uint256 rAmount = tAmount.mul(currentRate);
726         uint256 rFee = tFee.mul(currentRate);
727         uint256 rLiquidity = tLiquidity.mul(currentRate);
728         uint256 rMarketing = tMarketing.mul(currentRate);
729         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rMarketing);
730         return (rAmount, rTransferAmount, rFee);
731     }
732 
733     function _getRate() private view returns(uint256) {
734         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
735         return rSupply.div(tSupply);
736     }
737 
738     function _getCurrentSupply() private view returns(uint256, uint256) {
739         uint256 rSupply = _rTotal;
740         uint256 tSupply = _tTotal;      
741         for (uint256 i = 0; i < _excluded.length; i++) {
742             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
743             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
744             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
745         }
746         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
747         return (rSupply, tSupply);
748     }
749     
750     function _takeLiquidity(uint256 tLiquidity) private {
751         uint256 currentRate =  _getRate();
752         uint256 rLiquidity = tLiquidity.mul(currentRate);
753         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
754         if(_isExcluded[address(this)])
755             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
756     }
757     
758     function _takeMarketing(uint256 tMarketing) private {
759         uint256 currentRate =  _getRate();
760         uint256 rMarketing = tMarketing.mul(currentRate);
761         _rOwned[_marketingWalletAddress] = _rOwned[_marketingWalletAddress].add(rMarketing);
762         if(_isExcluded[_marketingWalletAddress])
763             _tOwned[_marketingWalletAddress] = _tOwned[_marketingWalletAddress].add(tMarketing);
764     }
765     
766     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
767         return _amount.mul(_taxFee).div(
768             10**2
769         );
770     }
771 
772     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
773         return _amount.mul(_marketingFee).div(
774             10**2
775         );
776     }
777 
778     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
779         return _amount.mul(_liquidityFee).div(
780             10**2
781         );
782     }
783     
784     function removeAllFee() private { 
785         _previousTaxFee = _taxFee;
786         _previousMarketingFee = _marketingFee;
787         _previousLiquidityFee = _liquidityFee;
788         
789         _taxFee = 0;
790         _marketingFee = 0;
791         _liquidityFee = 0;
792     }
793     
794     function restoreAllFee() private {
795         _taxFee = _previousTaxFee;
796         _marketingFee = _previousMarketingFee;
797         _liquidityFee = _previousLiquidityFee;
798     }
799     
800     function isExcludedFromFee(address account) public view returns(bool) {
801         return _isExcludedFromFee[account];
802     }
803 
804     function _approve(address owner, address spender, uint256 amount) private {
805         require(owner != address(0), "ERC20: approve from the zero address");
806         require(spender != address(0), "ERC20: approve to the zero address");
807 
808         _allowances[owner][spender] = amount;
809         emit Approval(owner, spender, amount);
810     }
811 
812     function _transfer(
813         address from,
814         address to,
815         uint256 amount
816     ) private {
817         require(from != address(0), "ERC20: transfer from the zero address");
818         require(to != address(0), "ERC20: transfer to the zero address");
819         require(amount > 0, "Transfer amount must be greater than zero");
820         
821         uint256 contractTokenBalance = balanceOf(address(this));
822         
823         
824         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
825         if (
826             overMinTokenBalance &&
827             !inSwapAndLiquify &&
828             from != uniswapV2Pair &&
829             swapAndLiquifyEnabled
830         ) {
831             contractTokenBalance = numTokensSellToAddToLiquidity;
832             swapAndLiquify(contractTokenBalance);
833         }
834         
835         bool takeFee = true;
836         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
837             takeFee = false;
838         }
839          else {
840 
841              if(to != uniswapV2Pair)
842                  require(amount + balanceOf(to) <= _maxWallet, "Max wallet exceeded.");
843 
844             if (from == uniswapV2Pair) { // Buy
845                 _taxFee = _buyTaxFee;
846                 _liquidityFee = _buyLiquidityFee;
847                 _marketingFee = _buyMarketingFee;
848                 }
849                  else if (to == uniswapV2Pair){ // Sell
850                 _taxFee = _sellTaxFee;
851                 _liquidityFee = _sellLiquidityFee;
852                 _marketingFee = _sellMarketingFee;
853                 }
854                  else { // Transfer
855                 _taxFee = _buyTaxFee;
856                 _liquidityFee = _buyLiquidityFee;
857                 _marketingFee = _buyMarketingFee;
858                 }
859         }
860         
861         _tokenTransfer(from,to,amount,takeFee);
862     }
863 
864     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
865         uint256 tFee = _marketingFee.add(_liquidityFee);
866         uint256 marketingTokens = contractTokenBalance.div(tFee).mul(_marketingFee);
867         uint256 liquidityTokens = contractTokenBalance.sub(marketingTokens);
868         tFee = _marketingFee.add(_liquidityFee.div(2));
869         uint256 half      = liquidityTokens.div(2);
870         uint256 otherHalf = liquidityTokens.sub(half);
871         uint256 initialBalance = address(this).balance;
872         uint256 swapTokens = marketingTokens.add(half);
873         swapTokensForEth(swapTokens);
874         uint256 newBalance = address(this).balance.sub(initialBalance);
875         uint256 marketingFunds = newBalance.div(tFee).mul(_marketingFee);
876         (bool success, ) = payable(_marketingWalletAddress).call{
877             value: marketingFunds,
878             gas: 30000}("");
879         require(success, " _marketingWalletAddress transfer is reverted");
880         uint256 halfFunds = newBalance.div(tFee).mul(_liquidityFee.div(2));
881         addLiquidity(otherHalf, halfFunds);        
882         emit SwapAndLiquify(half, halfFunds, otherHalf);
883 
884     }
885 
886     function swapTokensForEth(uint256 tokenAmount) private {
887         address[] memory path = new address[](2);
888         path[0] = address(this);
889         path[1] = uniswapV2Router.WETH();
890         _approve(address(this), address(uniswapV2Router), tokenAmount);
891         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
892             tokenAmount,
893             0, // accept any amount of ETH
894             path,
895             address(this),
896             block.timestamp
897         );
898     }
899 
900     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
901         _approve(address(this), address(uniswapV2Router), tokenAmount);
902         uniswapV2Router.addLiquidityETH{value: ethAmount}(
903             address(this),
904             tokenAmount,
905             0, // slippage is unavoidable
906             0, // slippage is unavoidable
907             owner(),
908             block.timestamp
909         );
910     }
911 
912     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
913         if(!takeFee)
914             removeAllFee();
915         
916         if (_isExcluded[sender] && !_isExcluded[recipient]) {
917             _transferFromExcluded(sender, recipient, amount);
918         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
919             _transferToExcluded(sender, recipient, amount);
920         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
921             _transferStandard(sender, recipient, amount);
922         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
923             _transferBothExcluded(sender, recipient, amount);
924         } else {
925             _transferStandard(sender, recipient, amount);
926         }
927         
928         if(!takeFee)
929             restoreAllFee();
930     }
931 
932     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
933         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
934         _rOwned[sender] = _rOwned[sender].sub(rAmount);
935         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
936         _takeLiquidity(tLiquidity);
937         _takeMarketing(tMarketing);
938         _reflectFee(rFee, tFee);
939         emit Transfer(sender, recipient, tTransferAmount);
940     }
941 
942     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
943         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
944         _rOwned[sender] = _rOwned[sender].sub(rAmount);
945         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
946         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
947         _takeLiquidity(tLiquidity);
948         _takeMarketing(tMarketing);
949         _reflectFee(rFee, tFee);
950         emit Transfer(sender, recipient, tTransferAmount);
951     }
952 
953     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
954         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
955         _tOwned[sender] = _tOwned[sender].sub(tAmount);
956         _rOwned[sender] = _rOwned[sender].sub(rAmount);
957         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
958         _takeLiquidity(tLiquidity);
959         _takeMarketing(tMarketing);
960         _reflectFee(rFee, tFee);
961         emit Transfer(sender, recipient, tTransferAmount);
962     }
963 
964 }