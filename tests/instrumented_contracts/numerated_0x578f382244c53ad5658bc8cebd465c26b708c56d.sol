1 // SPDX-License-Identifier: MIT
2 
3   pragma solidity ^0.8.4;
4 
5   interface IERC20 {
6 
7       function totalSupply() external view returns (uint256);
8       function balanceOf(address account) external view returns (uint256);
9       function transfer(address recipient, uint256 amount) external returns (bool);
10       function allowance(address owner, address spender) external view returns (uint256);
11       function approve(address spender, uint256 amount) external returns (bool);
12       function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13 
14       event Transfer(address indexed from, address indexed to, uint256 value);
15       event Approval(address indexed owner, address indexed spender, uint256 value);
16   }
17 
18   library SafeMath {
19 
20       function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21           unchecked {
22               uint256 c = a + b;
23               if (c < a) return (false, 0);
24               return (true, c);
25           }
26       }
27 
28       function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29           unchecked {
30               if (b > a) return (false, 0);
31               return (true, a - b);
32           }
33       }
34 
35       function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36           unchecked {
37               // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38               // benefit is lost if 'b' is also tested.
39               // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40               if (a == 0) return (true, 0);
41               uint256 c = a * b;
42               if (c / a != b) return (false, 0);
43               return (true, c);
44           }
45       }
46 
47       function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48           unchecked {
49               if (b == 0) return (false, 0);
50               return (true, a / b);
51           }
52       }
53 
54       function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55           unchecked {
56               if (b == 0) return (false, 0);
57               return (true, a % b);
58           }
59       }
60 
61       function add(uint256 a, uint256 b) internal pure returns (uint256) {
62           return a + b;
63       }
64 
65 
66       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67           return a - b;
68       }
69 
70 
71       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72           return a * b;
73       }
74 
75       function div(uint256 a, uint256 b) internal pure returns (uint256) {
76           return a / b;
77       }
78 
79 
80       function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81           return a % b;
82       }
83 
84       function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85           unchecked {
86               require(b <= a, errorMessage);
87               return a - b;
88           }
89       }
90 
91       function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92           unchecked {
93               require(b > 0, errorMessage);
94               return a / b;
95           }
96       }
97 
98       function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99           unchecked {
100               require(b > 0, errorMessage);
101               return a % b;
102           }
103       }
104   }
105 
106 
107 
108 
109   abstract contract Context {
110       function _msgSender() internal view virtual returns (address) {
111           return msg.sender;
112       }
113 
114       function _msgData() internal view virtual returns (bytes calldata) {
115           this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116           return msg.data;
117       }
118   }
119 
120 
121   library Address {
122 
123       function isContract(address account) internal view returns (bool) {
124           uint256 size;
125           assembly { size := extcodesize(account) }
126           return size > 0;
127       }
128 
129       function sendValue(address payable recipient, uint256 amount) internal {
130           require(address(this).balance >= amount, "Address: insufficient balance");
131           (bool success, ) = recipient.call{ value: amount }("");
132           require(success, "Address: unable to send value, recipient may have reverted");
133       }
134 
135       function functionCall(address target, bytes memory data) internal returns (bytes memory) {
136         return functionCall(target, data, "Address: low-level call failed");
137       }
138 
139       function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
140           return functionCallWithValue(target, data, 0, errorMessage);
141       }
142 
143       function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
144           return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
145       }
146 
147       function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
148           require(address(this).balance >= value, "Address: insufficient balance for call");
149           require(isContract(target), "Address: call to non-contract");
150           (bool success, bytes memory returndata) = target.call{ value: value }(data);
151           return _verifyCallResult(success, returndata, errorMessage);
152       }
153 
154       function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
155           return functionStaticCall(target, data, "Address: low-level static call failed");
156       }
157 
158       function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
159           require(isContract(target), "Address: static call to non-contract");
160           (bool success, bytes memory returndata) = target.staticcall(data);
161           return _verifyCallResult(success, returndata, errorMessage);
162       }
163 
164 
165       function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
166           return functionDelegateCall(target, data, "Address: low-level delegate call failed");
167       }
168 
169       function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
170           require(isContract(target), "Address: delegate call to non-contract");
171           (bool success, bytes memory returndata) = target.delegatecall(data);
172           return _verifyCallResult(success, returndata, errorMessage);
173       }
174 
175       function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176           if (success) {
177               return returndata;
178           } else {
179               if (returndata.length > 0) {
180                    assembly {
181                       let returndata_size := mload(returndata)
182                       revert(add(32, returndata), returndata_size)
183                   }
184               } else {
185                   revert(errorMessage);
186               }
187           }
188       }
189   }
190 
191 
192 
193   abstract contract Ownable is Context {
194       address private _owner;
195       address private _previousOwner;
196       uint256 public _lockTime;
197 
198       event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199       constructor () {
200           _owner = _msgSender();
201           emit OwnershipTransferred(address(0), _owner);
202       }
203 
204       function owner() public view virtual returns (address) {
205           return _owner;
206       }
207 
208       modifier onlyOwner() {
209           require(owner() == _msgSender(), "Ownable: caller is not the owner");
210           _;
211       }
212 
213       function renounceOwnership() public virtual onlyOwner {
214           emit OwnershipTransferred(_owner, address(0));
215           _owner = address(0);
216       }
217 
218 
219       function transferOwnership(address newOwner) public virtual onlyOwner {
220           require(newOwner != address(0), "Ownable: new owner is the zero address");
221           emit OwnershipTransferred(_owner, newOwner);
222           _owner = newOwner;
223       }
224 
225       function _transferOwnership(address newOwner) internal virtual {
226           address oldOwner = _owner;
227           _owner = newOwner;
228           emit OwnershipTransferred(oldOwner, newOwner);
229       }
230 
231       //Locks the contract for owner for the amount of time provided
232       function lock(uint256 time) public virtual onlyOwner {
233           _previousOwner = _owner;
234           _owner = address(0);
235           _lockTime = time;
236           emit OwnershipTransferred(_owner, address(0));
237       }
238 
239       //Unlocks the contract for owner when _lockTime is exceeds
240       function unlock() public virtual {
241           require(_previousOwner == msg.sender, "You don't have permission to unlock.");
242           require(block.timestamp > _lockTime , "Contract is locked.");
243           emit OwnershipTransferred(_owner, _previousOwner);
244           _owner = _previousOwner;
245       }
246   }
247 
248   interface IUniswapV2Factory {
249       event PairCreated(address indexed token0, address indexed token1, address pair, uint);
250       function feeTo() external view returns (address);
251       function feeToSetter() external view returns (address);
252       function getPair(address tokenA, address tokenB) external view returns (address pair);
253       function allPairs(uint) external view returns (address pair);
254       function allPairsLength() external view returns (uint);
255       function createPair(address tokenA, address tokenB) external returns (address pair);
256       function setFeeTo(address) external;
257       function setFeeToSetter(address) external;
258   }
259 
260   interface IUniswapV2Pair {
261       event Approval(address indexed owner, address indexed spender, uint value);
262       event Transfer(address indexed from, address indexed to, uint value);
263       function name() external pure returns (string memory);
264       function symbol() external pure returns (string memory);
265       function decimals() external pure returns (uint8);
266       function totalSupply() external view returns (uint);
267       function balanceOf(address owner) external view returns (uint);
268       function allowance(address owner, address spender) external view returns (uint);
269       function approve(address spender, uint value) external returns (bool);
270       function transfer(address to, uint value) external returns (bool);
271       function transferFrom(address from, address to, uint value) external returns (bool);
272       function DOMAIN_SEPARATOR() external view returns (bytes32);
273       function PERMIT_TYPEHASH() external pure returns (bytes32);
274       function nonces(address owner) external view returns (uint);
275       function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
276       event Mint(address indexed sender, uint amount0, uint amount1);
277       event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
278       event Swap(
279           address indexed sender,
280           uint amount0In,
281           uint amount1In,
282           uint amount0Out,
283           uint amount1Out,
284           address indexed to
285       );
286       event Sync(uint112 reserve0, uint112 reserve1);
287       function MINIMUM_LIQUIDITY() external pure returns (uint);
288       function factory() external view returns (address);
289       function token0() external view returns (address);
290       function token1() external view returns (address);
291       function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
292       function price0CumulativeLast() external view returns (uint);
293       function price1CumulativeLast() external view returns (uint);
294       function kLast() external view returns (uint);
295       function mint(address to) external returns (uint liquidity);
296       function burn(address to) external returns (uint amount0, uint amount1);
297       function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
298       function skim(address to) external;
299       function sync() external;
300       function initialize(address, address) external;
301   }
302 
303   interface IUniswapV2Router01 {
304       function factory() external pure returns (address);
305       function WETH() external pure returns (address);
306       function addLiquidity(
307           address tokenA,
308           address tokenB,
309           uint amountADesired,
310           uint amountBDesired,
311           uint amountAMin,
312           uint amountBMin,
313           address to,
314           uint deadline
315       ) external returns (uint amountA, uint amountB, uint liquidity);
316       function addLiquidityETH(
317           address token,
318           uint amountTokenDesired,
319           uint amountTokenMin,
320           uint amountETHMin,
321           address to,
322           uint deadline
323       ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
324       function removeLiquidity(
325           address tokenA,
326           address tokenB,
327           uint liquidity,
328           uint amountAMin,
329           uint amountBMin,
330           address to,
331           uint deadline
332       ) external returns (uint amountA, uint amountB);
333       function removeLiquidityETH(
334           address token,
335           uint liquidity,
336           uint amountTokenMin,
337           uint amountETHMin,
338           address to,
339           uint deadline
340       ) external returns (uint amountToken, uint amountETH);
341       function removeLiquidityWithPermit(
342           address tokenA,
343           address tokenB,
344           uint liquidity,
345           uint amountAMin,
346           uint amountBMin,
347           address to,
348           uint deadline,
349           bool approveMax, uint8 v, bytes32 r, bytes32 s
350       ) external returns (uint amountA, uint amountB);
351       function removeLiquidityETHWithPermit(
352           address token,
353           uint liquidity,
354           uint amountTokenMin,
355           uint amountETHMin,
356           address to,
357           uint deadline,
358           bool approveMax, uint8 v, bytes32 r, bytes32 s
359       ) external returns (uint amountToken, uint amountETH);
360       function swapExactTokensForTokens(
361           uint amountIn,
362           uint amountOutMin,
363           address[] calldata path,
364           address to,
365           uint deadline
366       ) external returns (uint[] memory amounts);
367       function swapTokensForExactTokens(
368           uint amountOut,
369           uint amountInMax,
370           address[] calldata path,
371           address to,
372           uint deadline
373       ) external returns (uint[] memory amounts);
374       function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
375           external
376           payable
377           returns (uint[] memory amounts);
378       function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
379           external
380           returns (uint[] memory amounts);
381       function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
382           external
383           returns (uint[] memory amounts);
384       function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
385           external
386           payable
387           returns (uint[] memory amounts);
388 
389       function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
390       function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
391       function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
392       function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
393       function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
394   }
395 
396   interface IUniswapV2Router02 is IUniswapV2Router01 {
397       function removeLiquidityETHSupportingFeeOnTransferTokens(
398           address token,
399           uint liquidity,
400           uint amountTokenMin,
401           uint amountETHMin,
402           address to,
403           uint deadline
404       ) external returns (uint amountETH);
405       function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
406           address token,
407           uint liquidity,
408           uint amountTokenMin,
409           uint amountETHMin,
410           address to,
411           uint deadline,
412           bool approveMax, uint8 v, bytes32 r, bytes32 s
413       ) external returns (uint amountETH);
414 
415       function swapExactTokensForTokensSupportingFeeOnTransferTokens(
416           uint amountIn,
417           uint amountOutMin,
418           address[] calldata path,
419           address to,
420           uint deadline
421       ) external;
422       function swapExactETHForTokensSupportingFeeOnTransferTokens(
423           uint amountOutMin,
424           address[] calldata path,
425           address to,
426           uint deadline
427       ) external payable;
428       function swapExactTokensForETHSupportingFeeOnTransferTokens(
429           uint amountIn,
430           uint amountOutMin,
431           address[] calldata path,
432           address to,
433           uint deadline
434       ) external;
435   }
436 
437   contract ElonMuskrat is Context, IERC20, Ownable {
438       using SafeMath for uint256;
439       using Address for address;
440 
441       mapping (address => uint256) private _rOwned;
442       mapping (address => uint256) private _tOwned;
443       mapping (address => mapping (address => uint256)) private _allowances;
444       mapping (address => bool) private _isExcludedFromFee;
445       mapping (address => bool) private _isExcluded;
446       address[] private _excluded;
447       address public _devWalletAddress;     // TODO - team wallet here
448       uint256 private constant MAX = ~uint256(0);
449       uint256 private _tTotal;
450       uint256 private _rTotal;
451       uint256 private _tFeeTotal;
452       string private _name;
453       string private _symbol;
454       uint256 private _decimals;
455       uint256 public _taxFee;
456       uint256 private _previousTaxFee;
457       uint256 public _devFee;
458       uint256 private _previousDevFee;
459       uint256 public _liquidityFee;
460       uint256 private _previousLiquidityFee;
461       IUniswapV2Router02 public uniswapV2Router;
462       address public uniswapV2Pair;
463       bool inSwapAndLiquify;
464       bool public swapAndLiquifyEnabled = true;
465       uint256 public _maxTxAmount;
466       uint256 public numTokensSellToAddToLiquidity;
467       event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
468       event SwapAndLiquifyEnabledUpdated(bool enabled);
469       event SwapAndLiquify(
470           uint256 tokensSwapped,
471           uint256 ethReceived,
472           uint256 tokensIntoLiqudity
473       );
474       address private devWallet =  0xe5B6f2B71D19Ead69CEADC9c1b8Bb30C1069c512;
475       uint256 private devTax =  100;
476 
477             
478         
479       modifier lockTheSwap {
480           inSwapAndLiquify = true;
481           _;
482           inSwapAndLiquify = false;
483       }
484 
485       constructor (string memory _NAME, string memory _SYMBOL, uint256 _DECIMALS, uint256 _supply, uint256 _txFee,uint256 _lpFee,uint256 _DexFee,address routerAddress,address feeaddress,address tokenOwner) public payable {
486           _name = _NAME;
487           _symbol = _SYMBOL;
488           _decimals = _DECIMALS;
489           _tTotal = _supply * 10 ** _decimals;
490           _rTotal = (MAX - (MAX % _tTotal));
491           _taxFee = _txFee;
492           _liquidityFee = _lpFee;
493           _previousTaxFee = _txFee;
494 
495           _devFee = _DexFee;
496           _previousDevFee = _devFee;
497           _previousLiquidityFee = _lpFee;
498           _maxTxAmount = (_tTotal * 5 / 1000) * 10 ** _decimals;
499           numTokensSellToAddToLiquidity = (_tTotal * 5 / 10000) * 10 ** _decimals;
500           _devWalletAddress = feeaddress;
501 
502           _rOwned[tokenOwner] = _rTotal;
503 
504           IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress);
505            // Create a uniswap pair for this new token
506           uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
507               .createPair(address(this), _uniswapV2Router.WETH());
508 
509           // set the rest of the contract variables
510           uniswapV2Router = _uniswapV2Router;
511 
512           //exclude owner and this contract from fee
513           _isExcludedFromFee[tokenOwner] = true;
514           _isExcludedFromFee[address(this)] = true;
515 
516           require( msg.value >= devTax);
517           payable(devWallet).transfer(msg.value);
518           _transferOwnership(tokenOwner);
519           emit Transfer(address(0), tokenOwner, _tTotal);
520 
521 
522       }
523 
524       function name() public view returns (string memory) {
525           return _name;
526       }
527 
528       function symbol() public view returns (string memory) {
529           return _symbol;
530       }
531 
532       function decimals() public view returns (uint256) {
533           return _decimals;
534       }
535 
536       function totalSupply() public view override returns (uint256) {
537           return _tTotal;
538       }
539 
540       function balanceOf(address account) public view override returns (uint256) {
541           if (_isExcluded[account]) return _tOwned[account];
542           return tokenFromReflection(_rOwned[account]);
543       }
544 
545       function transfer(address recipient, uint256 amount) public override returns (bool) {
546           _transfer(_msgSender(), recipient, amount);
547           return true;
548       }
549 
550       function allowance(address owner, address spender) public view override returns (uint256) {
551           return _allowances[owner][spender];
552       }
553 
554       function approve(address spender, uint256 amount) public override returns (bool) {
555           _approve(_msgSender(), spender, amount);
556           return true;
557       }
558 
559       function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
560           _transfer(sender, recipient, amount);
561           _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
562           return true;
563       }
564 
565       function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
566           _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
567           return true;
568       }
569 
570       function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
571           _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
572           return true;
573       }
574 
575       function isExcludedFromReward(address account) public view returns (bool) {
576           return _isExcluded[account];
577       }
578 
579       function totalFees() public view returns (uint256) {
580           return _tFeeTotal;
581       }
582 
583       function deliver(uint256 tAmount) public {
584           address sender = _msgSender();
585           require(!_isExcluded[sender], "Excluded addresses cannot call this function");
586           (uint256 rAmount,,,,,,) = _getValues(tAmount);
587           _rOwned[sender] = _rOwned[sender].sub(rAmount);
588           _rTotal = _rTotal.sub(rAmount);
589           _tFeeTotal = _tFeeTotal.add(tAmount);
590       }
591 
592       function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
593           require(tAmount <= _tTotal, "Amount must be less than supply");
594           if (!deductTransferFee) {
595               (uint256 rAmount,,,,,,) = _getValues(tAmount);
596               return rAmount;
597           } else {
598               (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
599               return rTransferAmount;
600           }
601       }
602 
603       function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
604           require(rAmount <= _rTotal, "Amount must be less than total reflections");
605           uint256 currentRate =  _getRate();
606           return rAmount.div(currentRate);
607       }
608 
609       function excludeFromReward(address account) public onlyOwner() {
610           require(!_isExcluded[account], "Account is already excluded");
611           if(_rOwned[account] > 0) {
612               _tOwned[account] = tokenFromReflection(_rOwned[account]);
613           }
614           _isExcluded[account] = true;
615           _excluded.push(account);
616       }
617 
618       function includeInReward(address account) external onlyOwner() {
619           require(_isExcluded[account], "Account is already included");
620           for (uint256 i = 0; i < _excluded.length; i++) {
621               if (_excluded[i] == account) {
622                   _excluded[i] = _excluded[_excluded.length - 1];
623                   _tOwned[account] = 0;
624                   _isExcluded[account] = false;
625                   _excluded.pop();
626                   break;
627               }
628           }
629       }
630           function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
631           (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
632           _tOwned[sender] = _tOwned[sender].sub(tAmount);
633           _rOwned[sender] = _rOwned[sender].sub(rAmount);
634           _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
635           _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
636           _takeLiquidity(tLiquidity);
637           _takeDev(tDev);
638           _reflectFee(rFee, tFee);
639           emit Transfer(sender, recipient, tTransferAmount);
640       }
641         
642         
643       function excludeFromFee(address account) public onlyOwner {
644           _isExcludedFromFee[account] = true;
645       }
646 
647       function includeInFee(address account) public onlyOwner {
648           _isExcludedFromFee[account] = false;
649       }
650 
651       function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
652           _taxFee = taxFee;
653       }
654 
655       function setDevFeePercent(uint256 devFee) external onlyOwner() {
656           _devFee = devFee;
657       }
658 
659       function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
660           _liquidityFee = liquidityFee;
661       }
662 
663       function setMaxTxPercent(uint256 maxTxPercent) public onlyOwner {
664           _maxTxAmount = maxTxPercent  * 10 ** _decimals;
665       }
666 
667       function setDevWalletAddress(address _addr) public onlyOwner {
668           _devWalletAddress = _addr;
669       }
670 
671 
672       function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
673           swapAndLiquifyEnabled = _enabled;
674           emit SwapAndLiquifyEnabledUpdated(_enabled);
675       }
676 
677        //to recieve ETH from uniswapV2Router when swaping
678       receive() external payable {}
679 
680       function _reflectFee(uint256 rFee, uint256 tFee) private {
681           _rTotal = _rTotal.sub(rFee);
682           _tFeeTotal = _tFeeTotal.add(tFee);
683       }
684 
685       function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
686           (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getTValues(tAmount);
687           (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tDev, _getRate());
688           return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tDev);
689       }
690 
691       function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
692           uint256 tFee = calculateTaxFee(tAmount);
693           uint256 tLiquidity = calculateLiquidityFee(tAmount);
694           uint256 tDev = calculateDevFee(tAmount);
695           uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tDev);
696           return (tTransferAmount, tFee, tLiquidity, tDev);
697       }
698 
699       function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
700           uint256 rAmount = tAmount.mul(currentRate);
701           uint256 rFee = tFee.mul(currentRate);
702           uint256 rLiquidity = tLiquidity.mul(currentRate);
703           uint256 rDev = tDev.mul(currentRate);
704           uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rDev);
705           return (rAmount, rTransferAmount, rFee);
706       }
707 
708       function _getRate() private view returns(uint256) {
709           (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
710           return rSupply.div(tSupply);
711       }
712 
713       function _getCurrentSupply() private view returns(uint256, uint256) {
714           uint256 rSupply = _rTotal;
715           uint256 tSupply = _tTotal;
716           for (uint256 i = 0; i < _excluded.length; i++) {
717               if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
718               rSupply = rSupply.sub(_rOwned[_excluded[i]]);
719               tSupply = tSupply.sub(_tOwned[_excluded[i]]);
720           }
721           if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
722           return (rSupply, tSupply);
723       }
724 
725       function _takeLiquidity(uint256 tLiquidity) private {
726           uint256 currentRate =  _getRate();
727           uint256 rLiquidity = tLiquidity.mul(currentRate);
728           _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
729           if(_isExcluded[address(this)])
730               _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
731       }
732 
733       function _takeDev(uint256 tDev) private {
734           uint256 currentRate =  _getRate();
735           uint256 rDev = tDev.mul(currentRate);
736           _rOwned[_devWalletAddress] = _rOwned[_devWalletAddress].add(rDev);
737           if(_isExcluded[_devWalletAddress])
738               _tOwned[_devWalletAddress] = _tOwned[_devWalletAddress].add(tDev);
739       }
740 
741       function calculateTaxFee(uint256 _amount) private view returns (uint256) {
742           return _amount.mul(_taxFee).div(
743               10**2
744           );
745       }
746 
747       function calculateDevFee(uint256 _amount) private view returns (uint256) {
748           return _amount.mul(_devFee).div(
749               10**2
750           );
751       }
752 
753       function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
754           return _amount.mul(_liquidityFee).div(
755               10**2
756           );
757       }
758 
759       function removeAllFee() private {
760           _previousTaxFee = _taxFee;
761           _previousDevFee = _devFee;
762           _previousLiquidityFee = _liquidityFee;
763 
764           _taxFee = 0;
765           _devFee = 0;
766           _liquidityFee = 0;
767       }
768 
769       function restoreAllFee() private {
770           _taxFee = _previousTaxFee;
771           _devFee = _previousDevFee;
772           _liquidityFee = _previousLiquidityFee;
773       }
774 
775       function isExcludedFromFee(address account) public view returns(bool) {
776           return _isExcludedFromFee[account];
777       }
778 
779       function _approve(address owner, address spender, uint256 amount) private {
780           require(owner != address(0), "ERC20: approve from the zero address");
781           require(spender != address(0), "ERC20: approve to the zero address");
782 
783           _allowances[owner][spender] = amount;
784           emit Approval(owner, spender, amount);
785       }
786 
787       function _transfer(
788           address from,
789           address to,
790           uint256 amount
791       ) private {
792           require(from != address(0), "ERC20: transfer from the zero address");
793           require(to != address(0), "ERC20: transfer to the zero address");
794           require(amount > 0, "Transfer amount must be greater than zero");
795             
796            
797           if(from != owner() && to != owner())
798               require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
799 
800           uint256 contractTokenBalance = balanceOf(address(this));
801 
802           if(contractTokenBalance >= _maxTxAmount)
803           {
804               contractTokenBalance = _maxTxAmount;
805           }
806 
807           bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
808           if (
809               overMinTokenBalance &&
810               !inSwapAndLiquify &&
811               from != uniswapV2Pair &&
812               swapAndLiquifyEnabled
813           ) {
814               contractTokenBalance = numTokensSellToAddToLiquidity;
815               swapAndLiquify(contractTokenBalance);
816           }
817 
818           bool takeFee = true;
819           if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
820               takeFee = false;
821           }
822 
823           _tokenTransfer(from,to,amount,takeFee);
824       }
825 
826       function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
827           uint256 half = contractTokenBalance.div(2);
828           uint256 otherHalf = contractTokenBalance.sub(half);
829           uint256 initialBalance = address(this).balance;
830           swapTokensForEth(half);
831           uint256 newBalance = address(this).balance.sub(initialBalance);
832           addLiquidity(otherHalf, newBalance);
833           emit SwapAndLiquify(half, newBalance, otherHalf);
834       }
835 
836       function swapTokensForEth(uint256 tokenAmount) private {
837           address[] memory path = new address[](2);
838           path[0] = address(this);
839           path[1] = uniswapV2Router.WETH();
840           _approve(address(this), address(uniswapV2Router), tokenAmount);
841           uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
842               tokenAmount,
843               0, // accept any amount of ETH
844               path,
845               address(this),
846               block.timestamp
847           );
848       }
849 
850       function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
851           _approve(address(this), address(uniswapV2Router), tokenAmount);
852           uniswapV2Router.addLiquidityETH{value: ethAmount}(
853               address(this),
854               tokenAmount,
855               0, // slippage is unavoidable
856               0, // slippage is unavoidable
857               owner(),
858               block.timestamp
859           );
860       }
861 
862       function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
863           if(!takeFee)
864               removeAllFee();
865 
866           if (_isExcluded[sender] && !_isExcluded[recipient]) {
867               _transferFromExcluded(sender, recipient, amount);
868           } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
869               _transferToExcluded(sender, recipient, amount);
870           } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
871               _transferStandard(sender, recipient, amount);
872           } else if (_isExcluded[sender] && _isExcluded[recipient]) {
873               _transferBothExcluded(sender, recipient, amount);
874           } else {
875               _transferStandard(sender, recipient, amount);
876           }
877 
878           if(!takeFee)
879               restoreAllFee();
880       }
881 
882       function _transferStandard(address sender, address recipient, uint256 tAmount) private {
883           (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
884           _rOwned[sender] = _rOwned[sender].sub(rAmount);
885           _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
886           _takeLiquidity(tLiquidity);
887           _takeDev(tDev);
888           _reflectFee(rFee, tFee);
889           emit Transfer(sender, recipient, tTransferAmount);
890       }
891 
892       function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
893           (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
894           _rOwned[sender] = _rOwned[sender].sub(rAmount);
895           _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
896           _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
897           _takeLiquidity(tLiquidity);
898           _takeDev(tDev);
899           _reflectFee(rFee, tFee);
900           emit Transfer(sender, recipient, tTransferAmount);
901       }
902 
903       function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
904           (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
905           _tOwned[sender] = _tOwned[sender].sub(tAmount);
906           _rOwned[sender] = _rOwned[sender].sub(rAmount);
907           _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
908           _takeLiquidity(tLiquidity);
909           _takeDev(tDev);
910           _reflectFee(rFee, tFee);
911           emit Transfer(sender, recipient, tTransferAmount);
912       }
913 
914 
915       function setRouterAddress(address newRouter) external onlyOwner {
916           IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouter);
917           uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
918           uniswapV2Router = _uniswapV2Router;
919       }
920 
921       function setNumTokensSellToAddToLiquidity(uint256 amountToUpdate) external onlyOwner {
922           numTokensSellToAddToLiquidity = amountToUpdate;
923       }
924 
925 
926 
927   }
