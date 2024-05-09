1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 interface IERC20 {
6     
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13     
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 library SafeMath {
19     
20     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25         }
26     }
27     
28     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {
30             if (b > a) return (false, 0);
31             return (true, a - b);
32         }
33     }
34     
35     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38             // benefit is lost if 'b' is also tested.
39             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40             if (a == 0) return (true, 0);
41             uint256 c = a * b;
42             if (c / a != b) return (false, 0);
43             return (true, c);
44         }
45     }
46     
47     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             if (b == 0) return (false, 0);
50             return (true, a / b);
51         }
52     }
53     
54     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             if (b == 0) return (false, 0);
57             return (true, a % b);
58         }
59     }
60 
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         return a + b;
63     }
64 
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a - b;
68     }
69 
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a * b;
73     }
74     
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a / b;
77     }
78 
79 
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         return a % b;
82     }
83     
84     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         unchecked {
86             require(b <= a, errorMessage);
87             return a - b;
88         }
89     }
90     
91     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         unchecked {
93             require(b > 0, errorMessage);
94             return a / b;
95         }
96     }
97     
98     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         unchecked {
100             require(b > 0, errorMessage);
101             return a % b;
102         }
103     }
104 }
105 
106 
107 
108 
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes calldata) {
115         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116         return msg.data;
117     }
118 }
119 
120 
121 library Address {
122     
123     function isContract(address account) internal view returns (bool) {
124         uint256 size;
125         assembly { size := extcodesize(account) }
126         return size > 0;
127     }
128 
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131         (bool success, ) = recipient.call{ value: amount }("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134     
135     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
136       return functionCall(target, data, "Address: low-level call failed");
137     }
138     
139     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
140         return functionCallWithValue(target, data, 0, errorMessage);
141     }
142     
143     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
144         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
145     }
146     
147     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
148         require(address(this).balance >= value, "Address: insufficient balance for call");
149         require(isContract(target), "Address: call to non-contract");
150         (bool success, bytes memory returndata) = target.call{ value: value }(data);
151         return _verifyCallResult(success, returndata, errorMessage);
152     }
153     
154     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
155         return functionStaticCall(target, data, "Address: low-level static call failed");
156     }
157     
158     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
159         require(isContract(target), "Address: static call to non-contract");
160         (bool success, bytes memory returndata) = target.staticcall(data);
161         return _verifyCallResult(success, returndata, errorMessage);
162     }
163 
164 
165     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
167     }
168     
169     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
170         require(isContract(target), "Address: delegate call to non-contract");
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             if (returndata.length > 0) {
180                  assembly {
181                     let returndata_size := mload(returndata)
182                     revert(add(32, returndata), returndata_size)
183                 }
184             } else {
185                 revert(errorMessage);
186             }
187         }
188     }
189 }
190 
191 
192 
193 abstract contract Ownable is Context {
194     address internal _owner;
195     address private _previousOwner;
196     uint256 public _lockTime;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199     constructor () {
200         _owner = _msgSender();
201         emit OwnershipTransferred(address(0), _owner);
202     }
203     
204     function owner() public view virtual returns (address) {
205         return _owner;
206     }
207     
208     modifier onlyOwner() {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212     
213     function renounceOwnership() public virtual onlyOwner {
214         emit OwnershipTransferred(_owner, address(0));
215         _owner = address(0);
216     }
217 
218 
219     function transferOwnership(address newOwner) public virtual onlyOwner {
220         require(newOwner != address(0), "Ownable: new owner is the zero address");
221         emit OwnershipTransferred(_owner, newOwner);
222         _owner = newOwner;
223     }
224 
225 
226         //Locks the contract for owner for the amount of time provided
227     function lock(uint256 time) public virtual onlyOwner {
228         _previousOwner = _owner;
229         _owner = address(0);
230         _lockTime = time;
231         emit OwnershipTransferred(_owner, address(0));
232     }
233     
234     //Unlocks the contract for owner when _lockTime is exceeds
235     function unlock() public virtual {
236         require(_previousOwner == msg.sender, "You don't have permission to unlock.");
237         require(block.timestamp > _lockTime , "Contract is locked.");
238         emit OwnershipTransferred(_owner, _previousOwner);
239         _owner = _previousOwner;
240     }
241 }
242 
243 interface IUniswapV2Factory {
244     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
245     function feeTo() external view returns (address);
246     function feeToSetter() external view returns (address);
247     function getPair(address tokenA, address tokenB) external view returns (address pair);
248     function allPairs(uint) external view returns (address pair);
249     function allPairsLength() external view returns (uint);
250     function createPair(address tokenA, address tokenB) external returns (address pair);
251     function setFeeTo(address) external;
252     function setFeeToSetter(address) external;
253 }
254 
255 interface IUniswapV2Pair {
256     event Approval(address indexed owner, address indexed spender, uint value);
257     event Transfer(address indexed from, address indexed to, uint value);
258     function name() external pure returns (string memory);
259     function symbol() external pure returns (string memory);
260     function decimals() external pure returns (uint8);
261     function totalSupply() external view returns (uint);
262     function balanceOf(address owner) external view returns (uint);
263     function allowance(address owner, address spender) external view returns (uint);
264     function approve(address spender, uint value) external returns (bool);
265     function transfer(address to, uint value) external returns (bool);
266     function transferFrom(address from, address to, uint value) external returns (bool);
267     function DOMAIN_SEPARATOR() external view returns (bytes32);
268     function PERMIT_TYPEHASH() external pure returns (bytes32);
269     function nonces(address owner) external view returns (uint);
270     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
271     event Mint(address indexed sender, uint amount0, uint amount1);
272     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
273     event Swap(
274         address indexed sender,
275         uint amount0In,
276         uint amount1In,
277         uint amount0Out,
278         uint amount1Out,
279         address indexed to
280     );
281     event Sync(uint112 reserve0, uint112 reserve1);
282     function MINIMUM_LIQUIDITY() external pure returns (uint);
283     function factory() external view returns (address);
284     function token0() external view returns (address);
285     function token1() external view returns (address);
286     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
287     function price0CumulativeLast() external view returns (uint);
288     function price1CumulativeLast() external view returns (uint);
289     function kLast() external view returns (uint);
290     function mint(address to) external returns (uint liquidity);
291     function burn(address to) external returns (uint amount0, uint amount1);
292     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
293     function skim(address to) external;
294     function sync() external;
295     function initialize(address, address) external;
296 }
297 
298 interface IUniswapV2Router01 {
299     function factory() external pure returns (address);
300     function WETH() external pure returns (address);
301     function addLiquidity(
302         address tokenA,
303         address tokenB,
304         uint amountADesired,
305         uint amountBDesired,
306         uint amountAMin,
307         uint amountBMin,
308         address to,
309         uint deadline
310     ) external returns (uint amountA, uint amountB, uint liquidity);
311     function addLiquidityETH(
312         address token,
313         uint amountTokenDesired,
314         uint amountTokenMin,
315         uint amountETHMin,
316         address to,
317         uint deadline
318     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
319     function removeLiquidity(
320         address tokenA,
321         address tokenB,
322         uint liquidity,
323         uint amountAMin,
324         uint amountBMin,
325         address to,
326         uint deadline
327     ) external returns (uint amountA, uint amountB);
328     function removeLiquidityETH(
329         address token,
330         uint liquidity,
331         uint amountTokenMin,
332         uint amountETHMin,
333         address to,
334         uint deadline
335     ) external returns (uint amountToken, uint amountETH);
336     function removeLiquidityWithPermit(
337         address tokenA,
338         address tokenB,
339         uint liquidity,
340         uint amountAMin,
341         uint amountBMin,
342         address to,
343         uint deadline,
344         bool approveMax, uint8 v, bytes32 r, bytes32 s
345     ) external returns (uint amountA, uint amountB);
346     function removeLiquidityETHWithPermit(
347         address token,
348         uint liquidity,
349         uint amountTokenMin,
350         uint amountETHMin,
351         address to,
352         uint deadline,
353         bool approveMax, uint8 v, bytes32 r, bytes32 s
354     ) external returns (uint amountToken, uint amountETH);
355     function swapExactTokensForTokens(
356         uint amountIn,
357         uint amountOutMin,
358         address[] calldata path,
359         address to,
360         uint deadline
361     ) external returns (uint[] memory amounts);
362     function swapTokensForExactTokens(
363         uint amountOut,
364         uint amountInMax,
365         address[] calldata path,
366         address to,
367         uint deadline
368     ) external returns (uint[] memory amounts);
369     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
370         external
371         payable
372         returns (uint[] memory amounts);
373     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
374         external
375         returns (uint[] memory amounts);
376     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
377         external
378         returns (uint[] memory amounts);
379     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
380         external
381         payable
382         returns (uint[] memory amounts);
383 
384     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
385     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
386     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
387     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
388     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
389 }
390 
391 interface IUniswapV2Router02 is IUniswapV2Router01 {
392     function removeLiquidityETHSupportingFeeOnTransferTokens(
393         address token,
394         uint liquidity,
395         uint amountTokenMin,
396         uint amountETHMin,
397         address to,
398         uint deadline
399     ) external returns (uint amountETH);
400     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
401         address token,
402         uint liquidity,
403         uint amountTokenMin,
404         uint amountETHMin,
405         address to,
406         uint deadline,
407         bool approveMax, uint8 v, bytes32 r, bytes32 s
408     ) external returns (uint amountETH);
409 
410     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
411         uint amountIn,
412         uint amountOutMin,
413         address[] calldata path,
414         address to,
415         uint deadline
416     ) external;
417     function swapExactETHForTokensSupportingFeeOnTransferTokens(
418         uint amountOutMin,
419         address[] calldata path,
420         address to,
421         uint deadline
422     ) external payable;
423     function swapExactTokensForETHSupportingFeeOnTransferTokens(
424         uint amountIn,
425         uint amountOutMin,
426         address[] calldata path,
427         address to,
428         uint deadline
429     ) external;
430 }
431 
432 contract TOKEN is Context, IERC20, Ownable {
433     using SafeMath for uint256;
434     using Address for address;
435 
436     mapping (address => uint256) private _rOwned;
437     mapping (address => uint256) private _tOwned;
438     mapping (address => mapping (address => uint256)) private _allowances;
439     mapping (address => bool) private _isExcludedFromFee;
440     mapping (address => bool) private _isExcluded;
441     address[] private _excluded;
442     address public _marketingWalletAddress;     // TODO - team wallet here
443     address public _burnAddress = 0x000000000000000000000000000000000000dEaD;
444     uint256 private constant MAX = ~uint256(0);
445     uint256 private _tTotal;
446     uint256 private _rTotal;
447     uint256 private _tFeeTotal;
448     string private _name;
449     string private _symbol;
450     uint256 private _decimals;
451 
452     // Buy tax 
453     uint256 private _buyTaxFee       = 1;
454     uint256 private _buyLiquidityFee = 7;
455     uint256 private _buyMarketingFee = 1;
456 
457     // Sell tax 
458     uint256 private _sellTaxFee       = 1; 
459     uint256 private _sellLiquidityFee = 7;
460     uint256 private _sellMarketingFee = 1;
461 
462     uint256 public _taxFee = _buyTaxFee;
463     uint256 public _liquidityFee = _buyLiquidityFee;
464     uint256 public _marketingFee = _buyMarketingFee;
465 
466     uint256 private _previousTaxFee = _taxFee;
467     uint256 private _previousMarketingFee = _liquidityFee;
468     uint256 private _previousLiquidityFee = _marketingFee;
469     
470     
471     
472     IUniswapV2Router02 public uniswapV2Router;
473     address public uniswapV2Pair;
474     bool inSwapAndLiquify;
475     bool public swapAndLiquifyEnabled = true;
476     uint256 public numTokensSellToAddToLiquidity;
477     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
478     event SwapAndLiquifyEnabledUpdated(bool enabled);
479     event SwapAndLiquify(
480         uint256 tokensSwapped,
481         uint256 ethReceived,
482         uint256 tokensIntoLiqudity
483     );
484     
485     modifier lockTheSwap {
486         inSwapAndLiquify = true;
487         _;
488         inSwapAndLiquify = false;
489     }
490     
491     constructor () {
492         _name = "Floki Classic";
493         _symbol = "FlokiC";
494         _decimals = 9;
495         _tTotal = 10000000000 * 10 ** _decimals;
496         _rTotal = (MAX - (MAX % _tTotal));
497         numTokensSellToAddToLiquidity = 1000000 * 10 ** _decimals;
498         _marketingWalletAddress = 0xcDC81570D069B181Ce32c84003aee6782b38FDF1;
499         
500         _rOwned[_msgSender()] = _rTotal;
501         
502         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
503          // Create a uniswap pair for this new token
504         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
505             .createPair(address(this), _uniswapV2Router.WETH());
506 
507         // set the rest of the contract variables
508         uniswapV2Router = _uniswapV2Router;
509         
510         //exclude owner and this contract from fee
511         _isExcludedFromFee[_msgSender()] = true;
512         _isExcludedFromFee[address(this)] = true;
513 
514         //exclude from rewards 
515         _isExcluded[_burnAddress] = true;
516         _isExcluded[uniswapV2Pair] = true;
517     
518         _owner = _msgSender();
519         emit Transfer(address(0), _msgSender(), _tTotal);
520 		
521 		
522     }
523 
524     function name() public view returns (string memory) {
525         return _name;
526     }
527 
528     function symbol() public view returns (string memory) {
529         return _symbol;
530     }
531 
532     function decimals() public view returns (uint256) {
533         return _decimals;
534     }
535 
536     function totalSupply() public view override returns (uint256) {
537         return _tTotal;
538     }
539 
540     function balanceOf(address account) public view override returns (uint256) {
541         if (_isExcluded[account]) return _tOwned[account];
542         return tokenFromReflection(_rOwned[account]);
543     }
544 
545     function transfer(address recipient, uint256 amount) public override returns (bool) {
546         _transfer(_msgSender(), recipient, amount);
547         return true;
548     }
549 
550     function allowance(address owner, address spender) public view override returns (uint256) {
551         return _allowances[owner][spender];
552     }
553 
554     function approve(address spender, uint256 amount) public override returns (bool) {
555         _approve(_msgSender(), spender, amount);
556         return true;
557     }
558 
559     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
560         _transfer(sender, recipient, amount);
561         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
562         return true;
563     }
564 
565     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
566         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
567         return true;
568     }
569 
570     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
571         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
572         return true;
573     }
574 
575     function isExcludedFromReward(address account) public view returns (bool) {
576         return _isExcluded[account];
577     }
578 
579     function totalFees() public view returns (uint256) {
580         return _tFeeTotal;
581     }
582 
583     function deliver(uint256 tAmount) public {
584         address sender = _msgSender();
585         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
586         (uint256 rAmount,,,,,,) = _getValues(tAmount);
587         _rOwned[sender] = _rOwned[sender].sub(rAmount);
588         _rTotal = _rTotal.sub(rAmount);
589         _tFeeTotal = _tFeeTotal.add(tAmount);
590     }
591 
592     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
593         require(tAmount <= _tTotal, "Amount must be less than supply");
594         if (!deductTransferFee) {
595             (uint256 rAmount,,,,,,) = _getValues(tAmount);
596             return rAmount;
597         } else {
598             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
599             return rTransferAmount;
600         }
601     }
602 
603     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
604         require(rAmount <= _rTotal, "Amount must be less than total reflections");
605         uint256 currentRate =  _getRate();
606         return rAmount.div(currentRate);
607     }
608 
609     function excludeFromReward(address account) public onlyOwner() {
610         require(!_isExcluded[account], "Account is already excluded");
611         if(_rOwned[account] > 0) {
612             _tOwned[account] = tokenFromReflection(_rOwned[account]);
613         }
614         _isExcluded[account] = true;
615         _excluded.push(account);
616     }
617 
618     function includeInReward(address account) external onlyOwner() {
619         require(_isExcluded[account], "Account is already included");
620         for (uint256 i = 0; i < _excluded.length; i++) {
621             if (_excluded[i] == account) {
622                 _excluded[i] = _excluded[_excluded.length - 1];
623                 _tOwned[account] = 0;
624                 _isExcluded[account] = false;
625                 _excluded.pop();
626                 break;
627             }
628         }
629     }
630         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
631         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
632         _tOwned[sender] = _tOwned[sender].sub(tAmount);
633         _rOwned[sender] = _rOwned[sender].sub(rAmount);
634         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
635         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
636         _takeLiquidity(tLiquidity);
637         _takeMarketing(tMarketing);
638         _reflectFee(rFee, tFee);
639         emit Transfer(sender, recipient, tTransferAmount);
640     }
641     
642     function excludeFromFee(address account) public onlyOwner {
643         _isExcludedFromFee[account] = true;
644     }
645     
646     function includeInFee(address account) public onlyOwner {
647         _isExcludedFromFee[account] = false;
648     }
649 
650     function setSellFeePercent(uint256 tFee, uint256 lFee, uint256 mFee) external onlyOwner() {
651        _sellTaxFee       = tFee; 
652        _sellLiquidityFee = lFee;
653        _sellMarketingFee = mFee;
654        }
655 
656     function setBuyFeePercent(uint256 tFee, uint256 lFee, uint256 mFee) external onlyOwner() {
657        _buyTaxFee       = tFee; 
658        _buyLiquidityFee = lFee;
659        _buyMarketingFee = mFee;
660        } 
661    
662     function setMarketingWalletAddress(address _addr) external onlyOwner {
663         _marketingWalletAddress = _addr;
664     }
665     
666     function setNumTokensSellToAddToLiquidity(uint256 amount) external onlyOwner {
667         numTokensSellToAddToLiquidity = amount * 10 **_decimals;
668     }
669 
670     function setRouterAddress(address newRouter) external onlyOwner {
671         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouter);
672         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
673         uniswapV2Router = _uniswapV2Router;
674     }
675 
676     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
677         swapAndLiquifyEnabled = _enabled;
678         emit SwapAndLiquifyEnabledUpdated(_enabled);
679     }
680     
681      //to recieve ETH from uniswapV2Router when swaping
682     receive() external payable {}
683 
684     // to withdraw stucked ETH 
685     function withdrawStuckedFunds(uint amount) external onlyOwner{
686         // This is the current recommended method to use.
687         (bool sent,) = _owner.call{value: amount}("");
688         require(sent, "Failed to send ETH");    
689         }
690 
691     function _reflectFee(uint256 rFee, uint256 tFee) private {
692         _rTotal = _rTotal.sub(rFee);
693         _tFeeTotal = _tFeeTotal.add(tFee);
694     }
695 
696     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
697         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getTValues(tAmount);
698         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, _getRate());
699         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tMarketing);
700     }
701 
702     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
703         uint256 tFee = calculateTaxFee(tAmount);
704         uint256 tLiquidity = calculateLiquidityFee(tAmount);
705         uint256 tMarketing = calculateMarketingFee(tAmount);
706         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tMarketing);
707         return (tTransferAmount, tFee, tLiquidity, tMarketing);
708     }
709 
710     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
711         uint256 rAmount = tAmount.mul(currentRate);
712         uint256 rFee = tFee.mul(currentRate);
713         uint256 rLiquidity = tLiquidity.mul(currentRate);
714         uint256 rMarketing = tMarketing.mul(currentRate);
715         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rMarketing);
716         return (rAmount, rTransferAmount, rFee);
717     }
718 
719     function _getRate() private view returns(uint256) {
720         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
721         return rSupply.div(tSupply);
722     }
723 
724     function _getCurrentSupply() private view returns(uint256, uint256) {
725         uint256 rSupply = _rTotal;
726         uint256 tSupply = _tTotal;      
727         for (uint256 i = 0; i < _excluded.length; i++) {
728             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
729             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
730             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
731         }
732         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
733         return (rSupply, tSupply);
734     }
735     
736     function _takeLiquidity(uint256 tLiquidity) private {
737         uint256 currentRate =  _getRate();
738         uint256 rLiquidity = tLiquidity.mul(currentRate);
739         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
740         if(_isExcluded[address(this)])
741             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
742     }
743     
744     function _takeMarketing(uint256 tMarketing) private {
745         uint256 currentRate =  _getRate();
746         uint256 rMarketing = tMarketing.mul(currentRate);
747         _rOwned[_marketingWalletAddress] = _rOwned[_marketingWalletAddress].add(rMarketing);
748         if(_isExcluded[_marketingWalletAddress])
749             _tOwned[_marketingWalletAddress] = _tOwned[_marketingWalletAddress].add(tMarketing);
750     }
751     
752     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
753         return _amount.mul(_taxFee).div(
754             10**2
755         );
756     }
757 
758     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
759         return _amount.mul(_marketingFee).div(
760             10**2
761         );
762     }
763 
764     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
765         return _amount.mul(_liquidityFee).div(
766             10**2
767         );
768     }
769     
770     function removeAllFee() private { 
771         _previousTaxFee = _taxFee;
772         _previousMarketingFee = _marketingFee;
773         _previousLiquidityFee = _liquidityFee;
774         
775         _taxFee = 0;
776         _marketingFee = 0;
777         _liquidityFee = 0;
778     }
779     
780     function restoreAllFee() private {
781         _taxFee = _previousTaxFee;
782         _marketingFee = _previousMarketingFee;
783         _liquidityFee = _previousLiquidityFee;
784     }
785     
786     function isExcludedFromFee(address account) public view returns(bool) {
787         return _isExcludedFromFee[account];
788     }
789 
790     function _approve(address owner, address spender, uint256 amount) private {
791         require(owner != address(0), "ERC20: approve from the zero address");
792         require(spender != address(0), "ERC20: approve to the zero address");
793 
794         _allowances[owner][spender] = amount;
795         emit Approval(owner, spender, amount);
796     }
797 
798     function _transfer(
799         address from,
800         address to,
801         uint256 amount
802     ) private {
803         require(from != address(0), "ERC20: transfer from the zero address");
804         require(to != address(0), "ERC20: transfer to the zero address");
805         require(amount > 0, "Transfer amount must be greater than zero");
806         
807         uint256 contractTokenBalance = balanceOf(address(this));
808         
809         
810         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
811         if (
812             overMinTokenBalance &&
813             !inSwapAndLiquify &&
814             from != uniswapV2Pair &&
815             swapAndLiquifyEnabled
816         ) {
817             contractTokenBalance = numTokensSellToAddToLiquidity;
818             swapAndLiquify(contractTokenBalance);
819         }
820         
821         bool takeFee = true;
822         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
823             takeFee = false;
824         }
825          else {
826 
827             if (from == uniswapV2Pair) { // Buy
828                 _taxFee = _buyTaxFee;
829                 _liquidityFee = _buyLiquidityFee;
830                 _marketingFee = _buyMarketingFee;
831                 }
832                  else if (to == uniswapV2Pair){ // Sell
833                 _taxFee = _sellTaxFee;
834                 _liquidityFee = _sellLiquidityFee;
835                 _marketingFee = _sellMarketingFee;
836                 }
837                  else { // Transfer
838                 _taxFee = _buyTaxFee;
839                 _liquidityFee = _buyLiquidityFee;
840                 _marketingFee = _buyMarketingFee;
841                 }
842         }
843         
844         _tokenTransfer(from,to,amount,takeFee);
845     }
846 
847     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
848         uint256 tFee = _marketingFee.add(_liquidityFee);
849         uint256 marketingTokens = contractTokenBalance.div(tFee).mul(_marketingFee);
850         uint256 liquidityTokens = contractTokenBalance.sub(marketingTokens);
851         tFee = _marketingFee.add(_liquidityFee.div(2));
852         uint256 half      = liquidityTokens.div(2);
853         uint256 otherHalf = liquidityTokens.sub(half);
854         uint256 initialBalance = address(this).balance;
855         uint256 swapTokens = marketingTokens.add(half);
856         swapTokensForEth(swapTokens);
857         uint256 newBalance = address(this).balance.sub(initialBalance);
858         uint256 marketingFunds = newBalance.div(tFee).mul(_marketingFee);
859         (bool success, ) = payable(_marketingWalletAddress).call{
860             value: marketingFunds,
861             gas: 30000}("");
862         require(success, " _marketingWalletAddress transfer is reverted");
863         uint256 halfFunds = newBalance.div(tFee).mul(_liquidityFee.div(2));
864         addLiquidity(otherHalf, halfFunds);        
865         emit SwapAndLiquify(half, halfFunds, otherHalf);
866 
867     }
868 
869     function swapTokensForEth(uint256 tokenAmount) private {
870         address[] memory path = new address[](2);
871         path[0] = address(this);
872         path[1] = uniswapV2Router.WETH();
873         _approve(address(this), address(uniswapV2Router), tokenAmount);
874         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
875             tokenAmount,
876             0, // accept any amount of ETH
877             path,
878             address(this),
879             block.timestamp
880         );
881     }
882 
883     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
884         _approve(address(this), address(uniswapV2Router), tokenAmount);
885         uniswapV2Router.addLiquidityETH{value: ethAmount}(
886             address(this),
887             tokenAmount,
888             0, // slippage is unavoidable
889             0, // slippage is unavoidable
890             owner(),
891             block.timestamp
892         );
893     }
894 
895     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
896         if(!takeFee)
897             removeAllFee();
898         
899         if (_isExcluded[sender] && !_isExcluded[recipient]) {
900             _transferFromExcluded(sender, recipient, amount);
901         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
902             _transferToExcluded(sender, recipient, amount);
903         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
904             _transferStandard(sender, recipient, amount);
905         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
906             _transferBothExcluded(sender, recipient, amount);
907         } else {
908             _transferStandard(sender, recipient, amount);
909         }
910         
911         if(!takeFee)
912             restoreAllFee();
913     }
914 
915     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
916         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
917         _rOwned[sender] = _rOwned[sender].sub(rAmount);
918         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
919         _takeLiquidity(tLiquidity);
920         _takeMarketing(tMarketing);
921         _reflectFee(rFee, tFee);
922         emit Transfer(sender, recipient, tTransferAmount);
923     }
924 
925     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
926         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
927         _rOwned[sender] = _rOwned[sender].sub(rAmount);
928         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
929         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
930         _takeLiquidity(tLiquidity);
931         _takeMarketing(tMarketing);
932         _reflectFee(rFee, tFee);
933         emit Transfer(sender, recipient, tTransferAmount);
934     }
935 
936     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
937         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
938         _tOwned[sender] = _tOwned[sender].sub(tAmount);
939         _rOwned[sender] = _rOwned[sender].sub(rAmount);
940         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
941         _takeLiquidity(tLiquidity);
942         _takeMarketing(tMarketing);
943         _reflectFee(rFee, tFee);
944         emit Transfer(sender, recipient, tTransferAmount);
945     }
946 
947 }