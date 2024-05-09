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
432 contract BabySuzume  is Context, IERC20, Ownable {
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
453     uint256 private _buyTaxFee       = 0;
454     uint256 private _buyLiquidityFee = 0;
455     uint256 private _buyMarketingFee = 0;
456 
457     // Sell tax 
458     uint256 private _sellTaxFee       = 0; 
459     uint256 private _sellLiquidityFee = 0;
460     uint256 private _sellMarketingFee = 0;
461 
462     uint256 public _taxFee = _buyTaxFee;
463     uint256 public _liquidityFee = _buyLiquidityFee;
464     uint256 public _marketingFee = _buyMarketingFee;
465 
466     uint256 private _previousTaxFee = _taxFee;
467     uint256 private _previousMarketingFee = _liquidityFee;
468     uint256 private _previousLiquidityFee = _marketingFee;
469     
470     uint256 public _maxWallet;
471     
472     IUniswapV2Router02 public uniswapV2Router;
473     address public uniswapV2Pair;
474     bool inSwapAndLiquify;
475     bool public swapAndLiquifyEnabled = true;
476     uint256 public numTokensSellToAddToLiquidity;
477     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
478     event MaxWalletUpdated(uint256 newMaxWallet);
479     event SwapAndLiquifyEnabledUpdated(bool enabled);
480     event SwapAndLiquify(
481         uint256 tokensSwapped,
482         uint256 ethReceived,
483         uint256 tokensIntoLiqudity
484     );
485     
486     modifier lockTheSwap {
487         inSwapAndLiquify = true;
488         _;
489         inSwapAndLiquify = false;
490     }
491     
492     constructor () {
493         _name = "BabySuzume";
494         _symbol = "SUZU";
495         _decimals = 9;
496         _tTotal = 10000000000 * 10 ** _decimals;
497         _rTotal = (MAX - (MAX % _tTotal));
498         numTokensSellToAddToLiquidity = 1000000 * 10 ** _decimals;
499         _marketingWalletAddress = msg.sender;
500         _maxWallet = 2 * _tTotal / 100;
501         _rOwned[_msgSender()] = _rTotal;
502         
503         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
504          // Create a uniswap pair for this new token
505         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
506             .createPair(address(this), _uniswapV2Router.WETH());
507 
508         // set the rest of the contract variables
509         uniswapV2Router = _uniswapV2Router;
510         
511         //exclude owner and this contract from fee
512         _isExcludedFromFee[_msgSender()] = true;
513         _isExcludedFromFee[address(this)] = true;
514 
515         //exclude from rewards 
516         _isExcluded[_burnAddress] = true;
517         _isExcluded[uniswapV2Pair] = true;
518     
519         _owner = _msgSender();
520         emit Transfer(address(0), _msgSender(), _tTotal);
521 		
522 		
523     }
524 
525     function name() public view returns (string memory) {
526         return _name;
527     }
528 
529     function symbol() public view returns (string memory) {
530         return _symbol;
531     }
532 
533     function decimals() public view returns (uint256) {
534         return _decimals;
535     }
536 
537     function totalSupply() public view override returns (uint256) {
538         return _tTotal;
539     }
540 
541     function balanceOf(address account) public view override returns (uint256) {
542         if (_isExcluded[account]) return _tOwned[account];
543         return tokenFromReflection(_rOwned[account]);
544     }
545 
546     function transfer(address recipient, uint256 amount) public override returns (bool) {
547         _transfer(_msgSender(), recipient, amount);
548         return true;
549     }
550 
551     function allowance(address owner, address spender) public view override returns (uint256) {
552         return _allowances[owner][spender];
553     }
554 
555     function approve(address spender, uint256 amount) public override returns (bool) {
556         _approve(_msgSender(), spender, amount);
557         return true;
558     }
559 
560     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
561         _transfer(sender, recipient, amount);
562         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
563         return true;
564     }
565 
566     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
567         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
568         return true;
569     }
570 
571     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
573         return true;
574     }
575 
576     function isExcludedFromReward(address account) public view returns (bool) {
577         return _isExcluded[account];
578     }
579 
580     function totalFees() public view returns (uint256) {
581         return _tFeeTotal;
582     }
583 
584     function deliver(uint256 tAmount) public {
585         address sender = _msgSender();
586         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
587         (uint256 rAmount,,,,,,) = _getValues(tAmount);
588         _rOwned[sender] = _rOwned[sender].sub(rAmount);
589         _rTotal = _rTotal.sub(rAmount);
590         _tFeeTotal = _tFeeTotal.add(tAmount);
591     }
592 
593     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
594         require(tAmount <= _tTotal, "Amount must be less than supply");
595         if (!deductTransferFee) {
596             (uint256 rAmount,,,,,,) = _getValues(tAmount);
597             return rAmount;
598         } else {
599             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
600             return rTransferAmount;
601         }
602     }
603 
604     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
605         require(rAmount <= _rTotal, "Amount must be less than total reflections");
606         uint256 currentRate =  _getRate();
607         return rAmount.div(currentRate);
608     }
609 
610     function excludeFromReward(address account) public onlyOwner() {
611         require(!_isExcluded[account], "Account is already excluded");
612         if(_rOwned[account] > 0) {
613             _tOwned[account] = tokenFromReflection(_rOwned[account]);
614         }
615         _isExcluded[account] = true;
616         _excluded.push(account);
617     }
618 
619     function includeInReward(address account) external onlyOwner() {
620         require(_isExcluded[account], "Account is already included");
621         for (uint256 i = 0; i < _excluded.length; i++) {
622             if (_excluded[i] == account) {
623                 _excluded[i] = _excluded[_excluded.length - 1];
624                 _tOwned[account] = 0;
625                 _isExcluded[account] = false;
626                 _excluded.pop();
627                 break;
628             }
629         }
630     }
631 
632     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
633         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
634         _tOwned[sender] = _tOwned[sender].sub(tAmount);
635         _rOwned[sender] = _rOwned[sender].sub(rAmount);
636         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
637         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
638         _takeLiquidity(tLiquidity);
639         _takeMarketing(tMarketing);
640         _reflectFee(rFee, tFee);
641         emit Transfer(sender, recipient, tTransferAmount);
642     }
643     
644     function excludeFromFee(address account) public onlyOwner {
645         _isExcludedFromFee[account] = true;
646     }
647     
648     function includeInFee(address account) public onlyOwner {
649         _isExcludedFromFee[account] = false;
650     }
651 
652     function setSellFeePercent(uint256 tFee, uint256 lFee, uint256 mFee) external onlyOwner() {
653        _sellTaxFee       = tFee; 
654        _sellLiquidityFee = lFee;
655        _sellMarketingFee = mFee;
656     }
657 
658     function setBuyFeePercent(uint256 tFee, uint256 lFee, uint256 mFee) external onlyOwner() {
659        _buyTaxFee       = tFee; 
660        _buyLiquidityFee = lFee;
661        _buyMarketingFee = mFee;
662     } 
663    
664     function setMarketingWalletAddress(address _addr) external onlyOwner {
665         _marketingWalletAddress = _addr;
666     }
667     
668     function setNumTokensSellToAddToLiquidity(uint256 amount) external onlyOwner {
669         numTokensSellToAddToLiquidity = amount * 10 **_decimals;
670 
671         emit MinTokensBeforeSwapUpdated(amount);
672     }
673     
674     function setMaxWallet(uint256 maxWallet) external onlyOwner {
675         _maxWallet = maxWallet * 10 ** _decimals;
676 
677         emit MaxWalletUpdated(maxWallet);
678     }
679 
680     function setRouterAddress(address newRouter) external onlyOwner {
681         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouter);
682         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
683         uniswapV2Router = _uniswapV2Router;
684     }
685 
686     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
687         swapAndLiquifyEnabled = _enabled;
688         emit SwapAndLiquifyEnabledUpdated(_enabled);
689     }
690     
691      //to recieve ETH from uniswapV2Router when swaping
692     receive() external payable {}
693 
694     // to withdraw stucked ETH 
695     function withdrawStuckedFunds(uint amount) external onlyOwner{
696         // This is the current recommended method to use.
697         (bool sent,) = _owner.call{value: amount}("");
698         require(sent, "Failed to send ETH");    
699         }
700 
701     function _reflectFee(uint256 rFee, uint256 tFee) private {
702         _rTotal = _rTotal.sub(rFee);
703         _tFeeTotal = _tFeeTotal.add(tFee);
704     }
705 
706     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
707         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getTValues(tAmount);
708         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, _getRate());
709         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tMarketing);
710     }
711 
712     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
713         uint256 tFee = calculateTaxFee(tAmount);
714         uint256 tLiquidity = calculateLiquidityFee(tAmount);
715         uint256 tMarketing = calculateMarketingFee(tAmount);
716         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tMarketing);
717         return (tTransferAmount, tFee, tLiquidity, tMarketing);
718     }
719 
720     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
721         uint256 rAmount = tAmount.mul(currentRate);
722         uint256 rFee = tFee.mul(currentRate);
723         uint256 rLiquidity = tLiquidity.mul(currentRate);
724         uint256 rMarketing = tMarketing.mul(currentRate);
725         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rMarketing);
726         return (rAmount, rTransferAmount, rFee);
727     }
728 
729     function _getRate() private view returns(uint256) {
730         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
731         return rSupply.div(tSupply);
732     }
733 
734     function _getCurrentSupply() private view returns(uint256, uint256) {
735         uint256 rSupply = _rTotal;
736         uint256 tSupply = _tTotal;      
737         for (uint256 i = 0; i < _excluded.length; i++) {
738             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
739             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
740             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
741         }
742         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
743         return (rSupply, tSupply);
744     }
745     
746     function _takeLiquidity(uint256 tLiquidity) private {
747         uint256 currentRate =  _getRate();
748         uint256 rLiquidity = tLiquidity.mul(currentRate);
749         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
750         if(_isExcluded[address(this)])
751             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
752     }
753     
754     function _takeMarketing(uint256 tMarketing) private {
755         uint256 currentRate =  _getRate();
756         uint256 rMarketing = tMarketing.mul(currentRate);
757         _rOwned[_marketingWalletAddress] = _rOwned[_marketingWalletAddress].add(rMarketing);
758         if(_isExcluded[_marketingWalletAddress])
759             _tOwned[_marketingWalletAddress] = _tOwned[_marketingWalletAddress].add(tMarketing);
760     }
761     
762     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
763         return _amount.mul(_taxFee).div(
764             10**2
765         );
766     }
767 
768     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
769         return _amount.mul(_marketingFee).div(
770             10**2
771         );
772     }
773 
774     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
775         return _amount.mul(_liquidityFee).div(
776             10**2
777         );
778     }
779     
780     function removeAllFee() private { 
781         _previousTaxFee = _taxFee;
782         _previousMarketingFee = _marketingFee;
783         _previousLiquidityFee = _liquidityFee;
784         
785         _taxFee = 0;
786         _marketingFee = 0;
787         _liquidityFee = 0;
788     }
789     
790     function restoreAllFee() private {
791         _taxFee = _previousTaxFee;
792         _marketingFee = _previousMarketingFee;
793         _liquidityFee = _previousLiquidityFee;
794     }
795     
796     function isExcludedFromFee(address account) public view returns(bool) {
797         return _isExcludedFromFee[account];
798     }
799 
800     function _approve(address owner, address spender, uint256 amount) private {
801         require(owner != address(0), "ERC20: approve from the zero address");
802         require(spender != address(0), "ERC20: approve to the zero address");
803 
804         _allowances[owner][spender] = amount;
805         emit Approval(owner, spender, amount);
806     }
807 
808     function _transfer(
809         address from,
810         address to,
811         uint256 amount
812     ) private {
813         require(from != address(0), "ERC20: transfer from the zero address");
814         require(to != address(0), "ERC20: transfer to the zero address");
815         require(amount > 0, "Transfer amount must be greater than zero");
816         
817         uint256 contractTokenBalance = balanceOf(address(this));
818         
819         
820         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
821         if (
822             overMinTokenBalance &&
823             !inSwapAndLiquify &&
824             from != uniswapV2Pair &&
825             swapAndLiquifyEnabled
826         ) {
827             contractTokenBalance = numTokensSellToAddToLiquidity;
828             swapAndLiquify(contractTokenBalance);
829         }
830         
831         bool takeFee = true;
832         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
833             takeFee = false;
834         }
835          else {
836 
837              if(to != uniswapV2Pair)
838                  require(amount + balanceOf(to) <= _maxWallet, "Max wallet exceeded.");
839 
840             if (from == uniswapV2Pair) { // Buy
841                 _taxFee = _buyTaxFee;
842                 _liquidityFee = _buyLiquidityFee;
843                 _marketingFee = _buyMarketingFee;
844                 }
845                  else if (to == uniswapV2Pair){ // Sell
846                 _taxFee = _sellTaxFee;
847                 _liquidityFee = _sellLiquidityFee;
848                 _marketingFee = _sellMarketingFee;
849                 }
850                  else { // Transfer
851                 _taxFee = _buyTaxFee;
852                 _liquidityFee = _buyLiquidityFee;
853                 _marketingFee = _buyMarketingFee;
854                 }
855         }
856         
857         _tokenTransfer(from,to,amount,takeFee);
858     }
859 
860     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
861         uint256 tFee = _marketingFee.add(_liquidityFee);
862         uint256 marketingTokens = contractTokenBalance.div(tFee).mul(_marketingFee);
863         uint256 liquidityTokens = contractTokenBalance.sub(marketingTokens);
864         tFee = _marketingFee.add(_liquidityFee.div(2));
865         uint256 half      = liquidityTokens.div(2);
866         uint256 otherHalf = liquidityTokens.sub(half);
867         uint256 initialBalance = address(this).balance;
868         uint256 swapTokens = marketingTokens.add(half);
869         swapTokensForEth(swapTokens);
870         uint256 newBalance = address(this).balance.sub(initialBalance);
871         uint256 marketingFunds = newBalance.div(tFee).mul(_marketingFee);
872         (bool success, ) = payable(_marketingWalletAddress).call{
873             value: marketingFunds,
874             gas: 30000}("");
875         require(success, " _marketingWalletAddress transfer is reverted");
876         uint256 halfFunds = newBalance.div(tFee).mul(_liquidityFee.div(2));
877         addLiquidity(otherHalf, halfFunds);        
878         emit SwapAndLiquify(half, halfFunds, otherHalf);
879 
880     }
881 
882     function swapTokensForEth(uint256 tokenAmount) private {
883         address[] memory path = new address[](2);
884         path[0] = address(this);
885         path[1] = uniswapV2Router.WETH();
886         _approve(address(this), address(uniswapV2Router), tokenAmount);
887         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
888             tokenAmount,
889             0, // accept any amount of ETH
890             path,
891             address(this),
892             block.timestamp
893         );
894     }
895 
896     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
897         _approve(address(this), address(uniswapV2Router), tokenAmount);
898         uniswapV2Router.addLiquidityETH{value: ethAmount}(
899             address(this),
900             tokenAmount,
901             0, // slippage is unavoidable
902             0, // slippage is unavoidable
903             owner(),
904             block.timestamp
905         );
906     }
907 
908     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
909         if(!takeFee)
910             removeAllFee();
911         
912         if (_isExcluded[sender] && !_isExcluded[recipient]) {
913             _transferFromExcluded(sender, recipient, amount);
914         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
915             _transferToExcluded(sender, recipient, amount);
916         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
917             _transferStandard(sender, recipient, amount);
918         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
919             _transferBothExcluded(sender, recipient, amount);
920         } else {
921             _transferStandard(sender, recipient, amount);
922         }
923         
924         if(!takeFee)
925             restoreAllFee();
926     }
927 
928     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
929         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
930         _rOwned[sender] = _rOwned[sender].sub(rAmount);
931         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
932         _takeLiquidity(tLiquidity);
933         _takeMarketing(tMarketing);
934         _reflectFee(rFee, tFee);
935         emit Transfer(sender, recipient, tTransferAmount);
936     }
937 
938     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
939         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
940         _rOwned[sender] = _rOwned[sender].sub(rAmount);
941         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
942         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
943         _takeLiquidity(tLiquidity);
944         _takeMarketing(tMarketing);
945         _reflectFee(rFee, tFee);
946         emit Transfer(sender, recipient, tTransferAmount);
947     }
948 
949     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
950         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
951         _tOwned[sender] = _tOwned[sender].sub(tAmount);
952         _rOwned[sender] = _rOwned[sender].sub(rAmount);
953         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
954         _takeLiquidity(tLiquidity);
955         _takeMarketing(tMarketing);
956         _reflectFee(rFee, tFee);
957         emit Transfer(sender, recipient, tTransferAmount);
958     }
959 
960 }