1 /* 
2 みんな風をほめたたえます。風の神は本物です。
3 
4 風に
5 
6                                 ▓▓██████▓▓░░                                
7                             ▒▒▓▓░░      ▒▒██▒▒                              
8                             ██            ▒▒██                              
9                         ████                ██▓▓██▓▓                        
10                       ▓▓▓▓                  ░░  ▒▒██▓▓                      
11             ░░▓▓▒▒░░  ▓▓                          ██▓▓                      
12             ██░░    ░░░░                          ██████▓▓░░  ▒▒▓▓▒▒░░      
13           ░░██        ░░                        ░░  ░░░░▓▓██▓▓░░  ░░▓▓▓▓    
14           ░░▓▓                                            ░░          ▓▓▒▒  
15     ░░██                                                              ▒▒██  
16   ▒▒██░░                                                              ▓▓▓▓  
17   ████                                                                  ▒▒  
18   ████                                                                  ░░██
19   ████                                                                    ██
20   ░░██▓▓                                                                  ▓▓
21     ░░██████░░            ▒▒▒▒▒▒░░░░                                      ▓▓
22           ▓▓████████████▓▓░░▒▒▓▓████████                                  ██
23               ▓▓▓▓▓▓▓▓▒▒              ▓▓          ░░              ░░▒▒░░▓▓██
24                           ░░  ▒▒░░    ▒▒▓▓▒▒▒▒▓▓████▒▒          ▒▒▓▓▓▓██▓▓░░
25                       ░░▒▒  ▒▒░░        ▒▒▒▒░░▒▒░░░░▓▓██▓▓▓▓████▒▒          
26               ▓▓▓▓  ▒▒    ▓▓                                                
27                 ▓▓▒▒    ▓▓        ▒▒  ░░        ░░                          
28               ▒▒▒▒  ▓▓░░        ▓▓  ░░        ▒▒                            
29                   ▓▓  ░░      ▒▒  ░░▒▒      ▒▒░░                            
30 ░░▒▒▒▒░░      ▒▒░░  ▓▓      ▒▒  ▒▒░░      ▓▓                                
31 ▓▓░░  ▓▓    ░░░░    ▓▓▒▒░░▒▒░░▓▓░░      ▒▒░░                                
32 ▓▓▓▓▓▓░░  ░░░░      ░░▓▓▓▓░░▒▒          ░░                                  
33 ▒▒      ▓▓    ▒▒  ░░      ▓▓░░        ▓▓                                    
34   ▒▒▓▓▓▓      ░░  ▒▒    ░░    ░░▓▓                                          
35               ░░▒▒    ▒▒░░    ▓▓▒▒  ▓▓                                      
36               ▒▒    ▓▓░░      ▒▒░░▓▓                                        
37 
38 */
39 
40 // SPDX-License-Identifier: Unlicensed
41 pragma solidity ^0.8.4;
42 
43 
44 abstract contract Context {
45 
46     function _msgSender() internal view virtual returns (address payable) {
47         return payable(msg.sender);
48     }
49 
50     function _msgData() internal view virtual returns (bytes memory) {
51         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
52         return msg.data;
53     }
54 }
55 
56 interface IERC20 {
57 
58     function totalSupply() external view returns (uint256);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 library SafeMath {
69 
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73 
74         return c;
75     }
76 
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
112         return mod(a, b, "SafeMath: modulo by zero");
113     }
114 
115     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b != 0, errorMessage);
117         return a % b;
118     }
119 }
120 
121 library Address {
122 
123     function isContract(address account) internal view returns (bool) {
124         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
125         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
126         // for accounts without code, i.e. `keccak256('')`
127         bytes32 codehash;
128         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
129         // solhint-disable-next-line no-inline-assembly
130         assembly { codehash := extcodehash(account) }
131         return (codehash != accountHash && codehash != 0x0);
132     }
133 
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
138         (bool success, ) = recipient.call{ value: amount }("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
143       return functionCall(target, data, "Address: low-level call failed");
144     }
145 
146     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
147         return _functionCallWithValue(target, data, 0, errorMessage);
148     }
149 
150     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
151         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
152     }
153 
154     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
155         require(address(this).balance >= value, "Address: insufficient balance for call");
156         return _functionCallWithValue(target, data, value, errorMessage);
157     }
158 
159     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
160         require(isContract(target), "Address: call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
163         if (success) {
164             return returndata;
165         } else {
166             
167             if (returndata.length > 0) {
168                 assembly {
169                     let returndata_size := mload(returndata)
170                     revert(add(32, returndata), returndata_size)
171                 }
172             } else {
173                 revert(errorMessage);
174             }
175         }
176     }
177 }
178 
179 contract Ownable is Context {
180     address private _owner;
181     address private _previousOwner;
182 
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185     constructor () {
186         address msgSender = _msgSender();
187         _owner = msgSender;
188         emit OwnershipTransferred(address(0), msgSender);
189     }
190 
191     function owner() public view returns (address) {
192         return _owner;
193     }   
194     
195     modifier onlyOwner() {
196         require(_owner == _msgSender(), "Ownable: caller is not the owner");
197         _;
198     }
199     
200     function waiveOwnership() public virtual onlyOwner {
201         emit OwnershipTransferred(_owner, address(0));
202         _owner = address(0);
203     }
204 
205     function transferOwnership(address newOwner) public virtual onlyOwner {
206         require(newOwner != address(0), "Ownable: new owner is the zero address");
207         emit OwnershipTransferred(_owner, newOwner);
208         _owner = newOwner;
209     }
210 }
211 
212 interface IUniswapV2Factory {
213     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
214 
215     function feeTo() external view returns (address);
216     function feeToSetter() external view returns (address);
217 
218     function getPair(address tokenA, address tokenB) external view returns (address pair);
219     function allPairs(uint) external view returns (address pair);
220     function allPairsLength() external view returns (uint);
221 
222     function createPair(address tokenA, address tokenB) external returns (address pair);
223 
224     function setFeeTo(address) external;
225     function setFeeToSetter(address) external;
226 }
227 
228 interface IUniswapV2Pair {
229     event Approval(address indexed owner, address indexed spender, uint value);
230     event Transfer(address indexed from, address indexed to, uint value);
231 
232     function name() external pure returns (string memory);
233     function symbol() external pure returns (string memory);
234     function decimals() external pure returns (uint8);
235     function totalSupply() external view returns (uint);
236     function balanceOf(address owner) external view returns (uint);
237     function allowance(address owner, address spender) external view returns (uint);
238 
239     function approve(address spender, uint value) external returns (bool);
240     function transfer(address to, uint value) external returns (bool);
241     function transferFrom(address from, address to, uint value) external returns (bool);
242 
243     function DOMAIN_SEPARATOR() external view returns (bytes32);
244     function PERMIT_TYPEHASH() external pure returns (bytes32);
245     function nonces(address owner) external view returns (uint);
246 
247     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
248     
249     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
250     event Swap(
251         address indexed sender,
252         uint amount0In,
253         uint amount1In,
254         uint amount0Out,
255         uint amount1Out,
256         address indexed to
257     );
258     event Sync(uint112 reserve0, uint112 reserve1);
259 
260     function MINIMUM_LIQUIDITY() external pure returns (uint);
261     function factory() external view returns (address);
262     function token0() external view returns (address);
263     function token1() external view returns (address);
264     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
265     function price0CumulativeLast() external view returns (uint);
266     function price1CumulativeLast() external view returns (uint);
267     function kLast() external view returns (uint);
268 
269     function burn(address to) external returns (uint amount0, uint amount1);
270     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
271     function skim(address to) external;
272     function sync() external;
273 
274     function initialize(address, address) external;
275 }
276 
277 interface IUniswapV2Router01 {
278     function factory() external pure returns (address);
279     function WETH() external pure returns (address);
280 
281     function addLiquidity(
282         address tokenA,
283         address tokenB,
284         uint amountADesired,
285         uint amountBDesired,
286         uint amountAMin,
287         uint amountBMin,
288         address to,
289         uint deadline
290     ) external returns (uint amountA, uint amountB, uint liquidity);
291     function addLiquidityETH(
292         address token,
293         uint amountTokenDesired,
294         uint amountTokenMin,
295         uint amountETHMin,
296         address to,
297         uint deadline
298     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
299     function removeLiquidity(
300         address tokenA,
301         address tokenB,
302         uint liquidity,
303         uint amountAMin,
304         uint amountBMin,
305         address to,
306         uint deadline
307     ) external returns (uint amountA, uint amountB);
308     function removeLiquidityETH(
309         address token,
310         uint liquidity,
311         uint amountTokenMin,
312         uint amountETHMin,
313         address to,
314         uint deadline
315     ) external returns (uint amountToken, uint amountETH);
316     function removeLiquidityWithPermit(
317         address tokenA,
318         address tokenB,
319         uint liquidity,
320         uint amountAMin,
321         uint amountBMin,
322         address to,
323         uint deadline,
324         bool approveMax, uint8 v, bytes32 r, bytes32 s
325     ) external returns (uint amountA, uint amountB);
326     function removeLiquidityETHWithPermit(
327         address token,
328         uint liquidity,
329         uint amountTokenMin,
330         uint amountETHMin,
331         address to,
332         uint deadline,
333         bool approveMax, uint8 v, bytes32 r, bytes32 s
334     ) external returns (uint amountToken, uint amountETH);
335     function swapExactTokensForTokens(
336         uint amountIn,
337         uint amountOutMin,
338         address[] calldata path,
339         address to,
340         uint deadline
341     ) external returns (uint[] memory amounts);
342     function swapTokensForExactTokens(
343         uint amountOut,
344         uint amountInMax,
345         address[] calldata path,
346         address to,
347         uint deadline
348     ) external returns (uint[] memory amounts);
349     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
350         external
351         payable
352         returns (uint[] memory amounts);
353     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
354         external
355         returns (uint[] memory amounts);
356     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
357         external
358         returns (uint[] memory amounts);
359     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
360         external
361         payable
362         returns (uint[] memory amounts);
363 
364     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
365     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
366     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
367     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
368     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
369 }
370 
371 interface IUniswapV2Router02 is IUniswapV2Router01 {
372     function removeLiquidityETHSupportingFeeOnTransferTokens(
373         address token,
374         uint liquidity,
375         uint amountTokenMin,
376         uint amountETHMin,
377         address to,
378         uint deadline
379     ) external returns (uint amountETH);
380     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
381         address token,
382         uint liquidity,
383         uint amountTokenMin,
384         uint amountETHMin,
385         address to,
386         uint deadline,
387         bool approveMax, uint8 v, bytes32 r, bytes32 s
388     ) external returns (uint amountETH);
389 
390     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
391         uint amountIn,
392         uint amountOutMin,
393         address[] calldata path,
394         address to,
395         uint deadline
396     ) external;
397     function swapExactETHForTokensSupportingFeeOnTransferTokens(
398         uint amountOutMin,
399         address[] calldata path,
400         address to,
401         uint deadline
402     ) external payable;
403     function swapExactTokensForETHSupportingFeeOnTransferTokens(
404         uint amountIn,
405         uint amountOutMin,
406         address[] calldata path,
407         address to,
408         uint deadline
409     ) external;
410 }
411 
412 contract Fujin is Context, IERC20, Ownable {
413     
414     using SafeMath for uint256;
415     using Address for address;
416     
417     string private _name = "Fujin O Hara";
418     string private _symbol = "FUJIN";
419     uint8 private _decimals = 9;
420 
421     address payable private taxWallet1 = payable(0xE1581bb4af5F06718075208bF4Cc5e6FBbd7a6aD);
422     address payable private taxWallet2 = payable(0xE1581bb4af5F06718075208bF4Cc5e6FBbd7a6aD);
423     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
424     
425     mapping (address => uint256) _balances;
426     mapping (address => mapping (address => uint256)) private _allowances;
427     
428     mapping (address => bool) public checkExcludedFromFees;
429     mapping (address => bool) public checkWalletLimitExcept;
430     mapping (address => bool) public checkTxLimitExcept;
431     mapping (address => bool) public checkMarketPair;
432 
433     uint256 public _buyLiquidityFees = 1;
434     uint256 public _buyMarketingFees = 1;
435     uint256 public _buyDevelopmentFees = 1;
436     uint256 public _sellLiquidityFees = 1;
437     uint256 public _sellMarketingFees = 1;
438     uint256 public _sellDevelopmentFees = 1;
439 
440     uint256 public _liquidityShares = 2;
441     uint256 public _marketingShares = 10;
442     uint256 public _developmentShares = 10;
443 
444     uint256 public _totalTaxIfBuying = 10;
445     uint256 public _totalTaxIfSelling = 10;
446     uint256 public _totalDistributionShares = 22;
447 
448     uint256 private _totalSupply = 1000 * 10**6 * 10**9;
449     uint256 public _maxTxAmount = 30 * 10**6 * 10**9;
450     uint256 public _walletMax = 30 * 10**6 * 10**9;
451     uint256 private minimumTokensBeforeSwap = 10 * 10**9; 
452 
453     IUniswapV2Router02 public uniswapV2Router;
454     address public uniswapPair;
455     
456     bool inSwapAndLiquify;
457     bool public swapAndLiquifyEnabled = true;
458     bool public swapAndLiquifyByLimitOnly = false;
459     bool public checkWalletLimit = true;
460 
461     event SwapAndLiquifyEnabledUpdated(bool enabled);
462     event SwapAndLiquify(
463         uint256 tokensSwapped,
464         uint256 ethReceived,
465         uint256 tokensIntoLiqudity
466     );
467     
468     event SwapETHForTokens(
469         uint256 amountIn,
470         address[] path
471     );
472     
473     event SwapTokensForETH(
474         uint256 amountIn,
475         address[] path
476     );
477     
478     modifier lockTheSwap {
479         inSwapAndLiquify = true;
480         _;
481         inSwapAndLiquify = false;
482     }
483     
484     constructor () {
485         
486         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
487 
488         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
489             .createPair(address(this), _uniswapV2Router.WETH());
490 
491         uniswapV2Router = _uniswapV2Router;
492         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
493 
494         checkExcludedFromFees[owner()] = true;
495         checkExcludedFromFees[address(this)] = true;
496         
497         _totalTaxIfBuying = _buyLiquidityFees.add(_buyMarketingFees).add(_buyDevelopmentFees);
498         _totalTaxIfSelling = _sellLiquidityFees.add(_sellMarketingFees).add(_sellDevelopmentFees);
499         _totalDistributionShares = _liquidityShares.add(_marketingShares).add(_developmentShares);
500 
501         checkWalletLimitExcept[owner()] = true;
502         checkWalletLimitExcept[address(uniswapPair)] = true;
503         checkWalletLimitExcept[address(this)] = true;
504         
505         checkTxLimitExcept[owner()] = true;
506         checkTxLimitExcept[address(this)] = true;
507 
508         checkMarketPair[address(uniswapPair)] = true;
509 
510         _balances[_msgSender()] = _totalSupply;
511         emit Transfer(address(0), _msgSender(), _totalSupply);
512     }
513 
514     function name() public view returns (string memory) {
515         return _name;
516     }
517 
518     function symbol() public view returns (string memory) {
519         return _symbol;
520     }
521 
522     function decimals() public view returns (uint8) {
523         return _decimals;
524     }
525 
526     function totalSupply() public view override returns (uint256) {
527         return _totalSupply;
528     }
529 
530     function balanceOf(address account) public view override returns (uint256) {
531         return _balances[account];
532     }
533 
534     function allowance(address owner, address spender) public view override returns (uint256) {
535         return _allowances[owner][spender];
536     }
537 
538     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
539         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
540         return true;
541     }
542 
543     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
544         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
545         return true;
546     }
547 
548     function approve(address spender, uint256 amount) public override returns (bool) {
549         _approve(_msgSender(), spender, amount);
550         return true;
551     }
552 
553     function _approve(address owner, address spender, uint256 amount) private {
554         require(owner != address(0), "ERC20: approve from the zero address");
555         require(spender != address(0), "ERC20: approve to the zero address");
556 
557         _allowances[owner][spender] = amount;
558         emit Approval(owner, spender, amount);
559     }
560 
561     function addMarketPair(address account) public onlyOwner {
562         checkMarketPair[account] = true;
563     }
564 
565     function setcheckTxLimitExcept(address holder, bool exempt) external onlyOwner {
566         checkTxLimitExcept[holder] = exempt;
567     }
568     
569     function setcheckExcludedFromFees(address account, bool newValue) public onlyOwner {
570         checkExcludedFromFees[account] = newValue;
571     }
572 
573     function setBuyFee(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
574         _buyLiquidityFees = newLiquidityTax;
575         _buyMarketingFees = newMarketingTax;
576         _buyDevelopmentFees = newDevelopmentTax;
577 
578         _totalTaxIfBuying = _buyLiquidityFees.add(_buyMarketingFees).add(_buyDevelopmentFees);
579     }
580 
581     function setSellFee(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
582         _sellLiquidityFees = newLiquidityTax;
583         _sellMarketingFees = newMarketingTax;
584         _sellDevelopmentFees = newDevelopmentTax;
585 
586         _totalTaxIfSelling = _sellLiquidityFees.add(_sellMarketingFees).add(_sellDevelopmentFees);
587     }
588     
589     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newDevelopmentShare) external onlyOwner() {
590         _liquidityShares = newLiquidityShare;
591         _marketingShares = newMarketingShare;
592         _developmentShares = newDevelopmentShare;
593 
594         _totalDistributionShares = _liquidityShares.add(_marketingShares).add(_developmentShares);
595     }
596     
597     function adjustMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
598         require(maxTxAmount <= (1000 * 10**6 * 10**9), "Max wallet should be less or euqal to 4% totalSupply");
599         _maxTxAmount = maxTxAmount;
600     }
601 
602     function enableDisableWalletLimit(bool newValue) external onlyOwner {
603        checkWalletLimit = newValue;
604     }
605 
606     function setcheckWalletLimitExcept(address holder, bool exempt) external onlyOwner {
607         checkWalletLimitExcept[holder] = exempt;
608     }
609 
610     function setWalletLimit(uint256 newLimit) external onlyOwner {
611         _walletMax  = newLimit;
612     }
613 
614     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
615         minimumTokensBeforeSwap = newLimit;
616     }
617 
618     function settaxWallet1(address newAddress) external onlyOwner() {
619         taxWallet1 = payable(newAddress);
620     }
621 
622     function settaxWallet2(address newAddress) external onlyOwner() {
623         taxWallet2 = payable(newAddress);
624     }
625 
626     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
627         swapAndLiquifyEnabled = _enabled;
628         emit SwapAndLiquifyEnabledUpdated(_enabled);
629     }
630 
631     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
632         swapAndLiquifyByLimitOnly = newValue;
633     }
634     
635     function getCirculatingSupply() public view returns (uint256) {
636         return _totalSupply.sub(balanceOf(deadAddress));
637     }
638 
639     function transferToAddressETH(address payable recipient, uint256 amount) private {
640         recipient.transfer(amount);
641     }
642     
643     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
644 
645         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
646 
647         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
648 
649         if(newPairAddress == address(0)) //Create If Doesnt exist
650         {
651             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
652                 .createPair(address(this), _uniswapV2Router.WETH());
653         }
654 
655         uniswapPair = newPairAddress; //Set new pair address
656         uniswapV2Router = _uniswapV2Router; //Set new router address
657 
658         checkWalletLimitExcept[address(uniswapPair)] = true;
659         checkMarketPair[address(uniswapPair)] = true;
660     }
661 
662      //to recieve ETH from uniswapV2Router when swaping
663     receive() external payable {}
664 
665     function transfer(address recipient, uint256 amount) public override returns (bool) {
666         _transfer(_msgSender(), recipient, amount);
667         return true;
668     }
669 
670     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
671         _transfer(sender, recipient, amount);
672         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
673         return true;
674     }
675 
676     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
677 
678         require(sender != address(0), "ERC20: transfer from the zero address");
679         require(recipient != address(0), "ERC20: transfer to the zero address");
680 
681         if(inSwapAndLiquify)
682         { 
683             return _basicTransfer(sender, recipient, amount); 
684         }
685         else
686         {
687             if(!checkTxLimitExcept[sender] && !checkTxLimitExcept[recipient]) {
688                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
689             }            
690 
691             uint256 contractTokenBalance = balanceOf(address(this));
692             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
693             
694             if (overMinimumTokenBalance && !inSwapAndLiquify && !checkMarketPair[sender] && swapAndLiquifyEnabled) 
695             {
696                 if(swapAndLiquifyByLimitOnly)
697                     contractTokenBalance = minimumTokensBeforeSwap;
698                 swapAndLiquify(contractTokenBalance);    
699             }
700 
701             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
702 
703             uint256 finalAmount = (checkExcludedFromFees[sender] || checkExcludedFromFees[recipient]) ? 
704                                          amount : takeFee(sender, recipient, amount);
705 
706             if(checkWalletLimit && !checkWalletLimitExcept[recipient])
707                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
708 
709             _balances[recipient] = _balances[recipient].add(finalAmount);
710 
711             emit Transfer(sender, recipient, finalAmount);
712             return true;
713         }
714     }
715 
716     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
717         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
718         _balances[recipient] = _balances[recipient].add(amount);
719         emit Transfer(sender, recipient, amount);
720         return true;
721     }
722 
723     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
724         
725         uint256 tokensForLP = tAmount.mul(_liquidityShares).div(_totalDistributionShares).div(2);
726         uint256 tokensForSwap = tAmount.sub(tokensForLP);
727 
728         swapTokensForEth(tokensForSwap);
729         uint256 amountReceived = address(this).balance;
730 
731         uint256 totalETHFee = _totalDistributionShares.sub(_liquidityShares.div(2));
732         
733         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShares).div(totalETHFee).div(2);
734         uint256 amountETHDevelopment = amountReceived.mul(_developmentShares).div(totalETHFee);
735         uint256 amountETHMarketing = amountReceived.sub(amountETHLiquidity).sub(amountETHDevelopment);
736 
737         if(amountETHMarketing > 0)
738             transferToAddressETH(taxWallet1, amountETHMarketing);
739 
740         if(amountETHDevelopment > 0)
741             transferToAddressETH(taxWallet2, amountETHDevelopment);
742 
743         if(amountETHLiquidity > 0 && tokensForLP > 0)
744             addLiquidity(tokensForLP, amountETHLiquidity);
745     }
746     
747     function swapTokensForEth(uint256 tokenAmount) private {
748         // generate the uniswap pair path of token -> weth
749         address[] memory path = new address[](2);
750         path[0] = address(this);
751         path[1] = uniswapV2Router.WETH();
752 
753         _approve(address(this), address(uniswapV2Router), tokenAmount);
754 
755         // make the swap
756         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
757             tokenAmount,
758             0, // accept any amount of ETH
759             path,
760             address(this), // The contract
761             block.timestamp
762         );
763         
764         emit SwapTokensForETH(tokenAmount, path);
765     }
766 
767     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
768         // approve token transfer to cover all possible scenarios
769         _approve(address(this), address(uniswapV2Router), tokenAmount);
770 
771         // add the liquidity
772         uniswapV2Router.addLiquidityETH{value: ethAmount}(
773             address(this),
774             tokenAmount,
775             0, // slippage is unavoidable
776             0, // slippage is unavoidable
777             owner(),
778             block.timestamp
779         );
780     }
781 
782     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
783         
784         uint256 feeAmount = 0;
785         
786         if(checkMarketPair[sender]) {
787             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
788         }
789         else if(checkMarketPair[recipient]) {
790             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
791         }
792         
793         if(feeAmount > 0) {
794             _balances[address(this)] = _balances[address(this)].add(feeAmount);
795             emit Transfer(sender, address(this), feeAmount);
796         }
797 
798         return amount.sub(feeAmount);
799     }
800     
801 }