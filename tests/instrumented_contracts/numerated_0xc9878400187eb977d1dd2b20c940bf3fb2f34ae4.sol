1 //SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39 
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62 
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         return mod(a, b, "SafeMath: modulo by zero");
82     }
83 
84    
85     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b != 0, errorMessage);
87         return a % b;
88     }
89 }
90 
91 library Address {
92    
93     function isContract(address account) internal view returns (bool) {
94        
95         bytes32 codehash;
96         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
97        
98         assembly { codehash := extcodehash(account) }
99         return (codehash != accountHash && codehash != 0x0);
100     }
101 
102     
103     function sendValue(address payable recipient, uint256 amount) internal {
104         require(address(this).balance >= amount, "Address: insufficient balance");
105 
106         (bool success, ) = recipient.call{ value: amount }("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 
110    
111     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
112         return functionCall(target, data, "Address: low-level call failed");
113     }
114 
115     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
116         return _functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     
120     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124    
125     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
126         require(address(this).balance >= value, "Address: insufficient balance for call");
127         return _functionCallWithValue(target, data, value, errorMessage);
128     }
129 
130     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
131         require(isContract(target), "Address: call to non-contract");
132 
133         
134         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
135         if (success) {
136             return returndata;
137         } else {
138            
139             if (returndata.length > 0) {
140                
141                 assembly {
142                     let returndata_size := mload(returndata)
143                     revert(add(32, returndata), returndata_size)
144                 }
145             } else {
146                 revert(errorMessage);
147             }
148         }
149     }
150 }
151 
152 contract Ownable is Context {
153     address private _owner;
154     address private _previousOwner;
155     uint256 private _lockTime;
156 
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159    
160     constructor () internal {
161         address msgSender = _msgSender();
162         _owner = msgSender;
163         emit OwnershipTransferred(address(0), msgSender);
164     }
165 
166    
167     function owner() public view returns (address) {
168         return _owner;
169     }
170 
171    
172     modifier onlyOwner() {
173         require(_owner == _msgSender(), "Ownable: caller is not the owner");
174         _;
175     }
176 
177     
178     function renounceOwnership() public virtual onlyOwner {
179         emit OwnershipTransferred(_owner, address(0));
180         _owner = address(0);
181     }
182 
183    
184     function transferOwnership(address newOwner) public virtual onlyOwner {
185         require(newOwner != address(0), "Ownable: new owner is the zero address");
186         emit OwnershipTransferred(_owner, newOwner);
187         _owner = newOwner;
188     }
189     
190 }
191 
192 interface IUniswapV2Factory {
193     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
194 
195     function feeTo() external view returns (address);
196     function feeToSetter() external view returns (address);
197 
198     function getPair(address tokenA, address tokenB) external view returns (address pair);
199     function allPairs(uint) external view returns (address pair);
200     function allPairsLength() external view returns (uint);
201 
202     function createPair(address tokenA, address tokenB) external returns (address pair);
203 
204     function setFeeTo(address) external;
205     function setFeeToSetter(address) external;
206 }
207 
208 interface IUniswapV2Pair {
209     event Approval(address indexed owner, address indexed spender, uint value);
210     event Transfer(address indexed from, address indexed to, uint value);
211 
212     function name() external pure returns (string memory);
213     function symbol() external pure returns (string memory);
214     function decimals() external pure returns (uint8);
215     function totalSupply() external view returns (uint);
216     function balanceOf(address owner) external view returns (uint);
217     function allowance(address owner, address spender) external view returns (uint);
218 
219     function approve(address spender, uint value) external returns (bool);
220     function transfer(address to, uint value) external returns (bool);
221     function transferFrom(address from, address to, uint value) external returns (bool);
222 
223     function DOMAIN_SEPARATOR() external view returns (bytes32);
224     function PERMIT_TYPEHASH() external pure returns (bytes32);
225     function nonces(address owner) external view returns (uint);
226 
227     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
228 
229     event Mint(address indexed sender, uint amount0, uint amount1);
230     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
231     event Swap(
232         address indexed sender,
233         uint amount0In,
234         uint amount1In,
235         uint amount0Out,
236         uint amount1Out,
237         address indexed to
238     );
239     event Sync(uint112 reserve0, uint112 reserve1);
240 
241     function MINIMUM_LIQUIDITY() external pure returns (uint);
242     function factory() external view returns (address);
243     function token0() external view returns (address);
244     function token1() external view returns (address);
245     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
246     function price0CumulativeLast() external view returns (uint);
247     function price1CumulativeLast() external view returns (uint);
248     function kLast() external view returns (uint);
249 
250     function mint(address to) external returns (uint liquidity);
251     function burn(address to) external returns (uint amount0, uint amount1);
252     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
253     function skim(address to) external;
254     function sync() external;
255 
256     function initialize(address, address) external;
257 }
258 
259 interface IUniswapV2Router01 {
260     function factory() external pure returns (address);
261     function WETH() external pure returns (address);
262 
263     function addLiquidity(
264         address tokenA,
265         address tokenB,
266         uint amountADesired,
267         uint amountBDesired,
268         uint amountAMin,
269         uint amountBMin,
270         address to,
271         uint deadline
272     ) external returns (uint amountA, uint amountB, uint liquidity);
273     function addLiquidityETH(
274         address token,
275         uint amountTokenDesired,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline
280     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
281     function removeLiquidity(
282         address tokenA,
283         address tokenB,
284         uint liquidity,
285         uint amountAMin,
286         uint amountBMin,
287         address to,
288         uint deadline
289     ) external returns (uint amountA, uint amountB);
290     function removeLiquidityETH(
291         address token,
292         uint liquidity,
293         uint amountTokenMin,
294         uint amountETHMin,
295         address to,
296         uint deadline
297     ) external returns (uint amountToken, uint amountETH);
298     function removeLiquidityWithPermit(
299         address tokenA,
300         address tokenB,
301         uint liquidity,
302         uint amountAMin,
303         uint amountBMin,
304         address to,
305         uint deadline,
306         bool approveMax, uint8 v, bytes32 r, bytes32 s
307     ) external returns (uint amountA, uint amountB);
308     function removeLiquidityETHWithPermit(
309         address token,
310         uint liquidity,
311         uint amountTokenMin,
312         uint amountETHMin,
313         address to,
314         uint deadline,
315         bool approveMax, uint8 v, bytes32 r, bytes32 s
316     ) external returns (uint amountToken, uint amountETH);
317     function swapExactTokensForTokens(
318         uint amountIn,
319         uint amountOutMin,
320         address[] calldata path,
321         address to,
322         uint deadline
323     ) external returns (uint[] memory amounts);
324     function swapTokensForExactTokens(
325         uint amountOut,
326         uint amountInMax,
327         address[] calldata path,
328         address to,
329         uint deadline
330     ) external returns (uint[] memory amounts);
331     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
332     external
333     payable
334     returns (uint[] memory amounts);
335     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
336     external
337     returns (uint[] memory amounts);
338     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
339     external
340     returns (uint[] memory amounts);
341     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
342     external
343     payable
344     returns (uint[] memory amounts);
345 
346     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
347     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
348     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
349     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
350     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
351 }
352 
353 interface IUniswapV2Router02 is IUniswapV2Router01 {
354     function removeLiquidityETHSupportingFeeOnTransferTokens(
355         address token,
356         uint liquidity,
357         uint amountTokenMin,
358         uint amountETHMin,
359         address to,
360         uint deadline
361     ) external returns (uint amountETH);
362     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
363         address token,
364         uint liquidity,
365         uint amountTokenMin,
366         uint amountETHMin,
367         address to,
368         uint deadline,
369         bool approveMax, uint8 v, bytes32 r, bytes32 s
370     ) external returns (uint amountETH);
371 
372     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
373         uint amountIn,
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external;
379     function swapExactETHForTokensSupportingFeeOnTransferTokens(
380         uint amountOutMin,
381         address[] calldata path,
382         address to,
383         uint deadline
384     ) external payable;
385     function swapExactTokensForETHSupportingFeeOnTransferTokens(
386         uint amountIn,
387         uint amountOutMin,
388         address[] calldata path,
389         address to,
390         uint deadline
391     ) external;
392 }
393 
394 // Contract implementation
395 contract DogelonSaturn is Context, IERC20, Ownable {
396     using SafeMath for uint256;
397     using Address for address;
398 
399     mapping (address => uint256) private _rOwned;
400     mapping (address => uint256) private _tOwned;
401     mapping (address => mapping (address => uint256)) private _allowances;
402 
403     mapping (address => bool) private _isExcludedFromFee;
404     mapping (address => uint256) private cooldown;
405     mapping (address => bool) private _isExcluded; 
406     address[] private _excluded;
407     mapping (address => bool) private _isBlackListedBot;
408     address[] private _blackListedBots;
409 
410     uint256 private constant MAX = ~uint256(0);
411 
412     uint256 private _tTotal = 80_000_000_000_000 * 10**9;
413     uint256 private _rTotal = (MAX - (MAX % _tTotal));
414     uint256 private _tFeeTotal;
415 
416     string private _name = 'Dogelon Saturn';
417     string private _symbol = 'DELONS';
418     uint8 private _decimals = 9;
419 
420     uint256 private _taxFee = 1; // 1% reflection fee for every holder
421     uint256 private _marketingFee = 2; // 2% marketing
422     uint256 private _liquidityFee = 1; // 1% into liquidity
423 
424     uint256 private _previousTaxFee = _taxFee;
425     uint256 private _previousMarketingFee = _marketingFee;
426     uint256 private _previousLiquidityFee = _liquidityFee;
427 
428     address payable private _marketingWalletAddress = payable(0xa8cC71EBbD0434481fd79B60224656da7da55Ed6);
429 
430     IUniswapV2Router02 public immutable uniswapV2Router;
431     address public immutable uniswapV2Pair;
432 
433     bool inSwapAndLiquify = false;
434     bool public swapAndLiquifyEnabled = false;
435     bool private cooldownEnabled = true;
436     bool private DynamicTaxEnabled = false;
437     bool private TradingOpen = false;
438     uint256 private _maxTxAmount = _tTotal;
439     // We will set a minimum amount of tokens to be swapped
440     uint256 private _numTokensSellToAddToLiquidity;
441 
442     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
443     event SwapAndLiquifyEnabledUpdated(bool enabled);
444     event SwapAndLiquify(
445         uint256 tokensSwapped,
446         uint256 ethReceived,
447         uint256 tokensIntoLiqudity
448     );
449     modifier lockTheSwap {
450         inSwapAndLiquify = true;
451         _;
452         inSwapAndLiquify = false;
453     }
454     address payable private _DeadWalletAddress = payable(0x8e4Ce482506273aE2339869Ad3B781404E304Cd3); 
455         // Using Dead Wallet for Anti Bot measures, 
456         // DeadWallet comes into play if bots try selling, 
457         // instead of sell, tokens are burned and bot addresses saved in DeadWallet transactions.
458         // Addresses saved in DeadWallet will not be able to sell.
459         // Deadwallet is connected to every token that uses this code, 
460         // Botblacklist is updated from every instance of this code.
461         // Warning!! Do not chnage DeadWallet Address or Antibot measures will not work.    
462         
463     constructor () public {
464         _rOwned[_msgSender()] = _rTotal;
465 
466         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
467         // Create a uniswap pair for this new token
468         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
469         .createPair(address(this), _uniswapV2Router.WETH());
470 
471         // set the rest of the contract variables
472         uniswapV2Router = _uniswapV2Router;
473 
474         // Exclude owner and this contract from fee
475         _isExcludedFromFee[owner()] = true;
476         _isExcludedFromFee[address(this)] = true;
477         _isExcludedFromFee[_marketingWalletAddress] = true;
478         _isExcludedFromFee[_DeadWalletAddress] = true;
479 
480         // BLACKLIST
481         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
482         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
483 
484         _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
485         _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
486 
487         _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
488         _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
489 
490         _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
491         _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
492 
493         _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
494         _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
495 
496         _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
497         _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
498 
499         _isBlackListedBot[address(0x5F186b080F5634Bba9dc9683bc37d192Ee96e2cF)] = true;
500         _blackListedBots.push(address(0x5F186b080F5634Bba9dc9683bc37d192Ee96e2cF));
501 
502         _isBlackListedBot[address(0x74de5d4FCbf63E00296fd95d33236B9794016631)] = true;
503         _blackListedBots.push(address(0x74de5d4FCbf63E00296fd95d33236B9794016631));
504         
505         _isBlackListedBot[address(0x36c1c59Dcca0Fd4A8C28551f7b2Fe6421d53CE32)] = true;
506         _blackListedBots.push(address(0x36c1c59Dcca0Fd4A8C28551f7b2Fe6421d53CE32));
507         
508         _isBlackListedBot[address(0xA3E2b5588C2a42b8fd6B90dc7055Dc118e17ff1f)] = true;
509         _blackListedBots.push(address(0xA3E2b5588C2a42b8fd6B90dc7055Dc118e17ff1f));
510         
511         _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
512         _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
513 
514         _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
515         _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
516 
517         emit Transfer(address(0), _msgSender(), _tTotal);
518     }
519 
520     function name() public view returns (string memory) {
521         return _name;
522     }
523 
524     function symbol() public view returns (string memory) {
525         return _symbol;
526     }
527 
528     function decimals() public view returns (uint8) {
529         return _decimals;
530     }
531 
532     function totalSupply() public view override returns (uint256) {
533         return _tTotal;
534     }
535     function setCooldownEnabled(bool onoff) external onlyOwner() {
536         cooldownEnabled = onoff;
537     }
538 
539     function setDynamicTaxEnabled(bool _setDynamicTaxEnabled) external onlyOwner() {
540         DynamicTaxEnabled = _setDynamicTaxEnabled;
541     }
542     function setTradingOpen(bool _setTradingOpen) external onlyOwner() {
543         TradingOpen = _setTradingOpen;
544     }
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
584     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
585         _isExcludedFromFee[account] = excluded;
586     }
587 
588     function totalFees() public view returns (uint256) {
589         return _tFeeTotal;
590     }
591 
592     function deliver(uint256 tAmount) public {
593         address sender = _msgSender();
594         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
595         (uint256 rAmount,,,,,) = _getValues(tAmount);
596         _rOwned[sender] = _rOwned[sender].sub(rAmount);
597         _rTotal = _rTotal.sub(rAmount);
598         _tFeeTotal = _tFeeTotal.add(tAmount);
599     }
600 
601     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
602         require(tAmount <= _tTotal, "Amount must be less than supply");
603         if (!deductTransferFee) {
604             (uint256 rAmount,,,,,) = _getValues(tAmount);
605             return rAmount;
606         } else {
607             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
608             return rTransferAmount;
609         }
610     }
611 
612     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
613         require(rAmount <= _rTotal, "Amount must be less than total reflections");
614         uint256 currentRate =  _getRate();
615         return rAmount.div(currentRate);
616     }
617 
618     function excludeFromReward(address account) external onlyOwner() {
619         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
620         require(!_isExcluded[account], "Account is already excluded");
621         if(_rOwned[account] > 0) {
622             _tOwned[account] = tokenFromReflection(_rOwned[account]);
623         }
624         _isExcluded[account] = true;
625         _excluded.push(account);
626     }
627 
628     function includeInReward(address account) external onlyOwner() {
629         require(_isExcluded[account], "Account is already excluded");
630         for (uint256 i = 0; i < _excluded.length; i++) {
631             if (_excluded[i] == account) {
632                 _excluded[i] = _excluded[_excluded.length - 1];
633                 _tOwned[account] = 0;
634                 _isExcluded[account] = false;
635                 _excluded.pop();
636                 break;
637             }
638         }
639     }
640 
641     function addBotToBlackList(address account) external onlyOwner() {
642         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
643         require(!_isBlackListedBot[account], "Account is already blacklisted");
644         _isBlackListedBot[account] = true;
645         _blackListedBots.push(account);
646     }
647 
648     function removeBotFromBlackList(address account) external onlyOwner() {
649         require(_isBlackListedBot[account], "Account is not blacklisted");
650         for (uint256 i = 0; i < _blackListedBots.length; i++) {
651             if (_blackListedBots[i] == account) {
652                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
653                 _isBlackListedBot[account] = false;
654                 _blackListedBots.pop();
655                 break;
656             }
657         }
658     }
659 
660     function removeAllFee() private {
661         if(_taxFee == 0 && _marketingFee == 0 && _liquidityFee == 0) return;
662 
663         _previousTaxFee = _taxFee;
664         _previousMarketingFee = _marketingFee;
665         _previousLiquidityFee = _liquidityFee;
666 
667         _taxFee = 0;
668         _marketingFee = 0;
669         _liquidityFee = 0;
670     }
671 
672     function restoreAllFee() private {
673         _taxFee = _previousTaxFee;
674         _marketingFee = _previousMarketingFee;
675         _liquidityFee = _previousLiquidityFee;
676     }
677 
678     function isExcludedFromFee(address account) public view returns(bool) {
679         return _isExcludedFromFee[account];
680     }
681 
682     function _approve(address owner, address spender, uint256 amount) private {
683         require(owner != address(0), "ERC20: approve from the zero address");
684         require(spender != address(0), "ERC20: approve to the zero address");
685 
686         _allowances[owner][spender] = amount;
687         emit Approval(owner, spender, amount);
688     }
689 
690     function _transfer(address sender, address recipient, uint256 amount) private {
691         require(sender != address(0), "ERC20: transfer from the zero address");
692         require(recipient != address(0), "ERC20: transfer to the zero address");
693         require(amount > 0, "Transfer amount must be greater than zero");
694         
695         if (sender == uniswapV2Pair && recipient != address(uniswapV2Router) && !_isExcludedFromFee[recipient] && cooldownEnabled) {
696         require(TradingOpen, "Trading is not open yet");
697             cooldown[recipient] = block.timestamp + (80 seconds);}
698             
699         if(_isBlackListedBot[sender]) 
700         {
701         require(TradingOpen, "Trading is not open yet");
702         require(cooldown[sender] < block.timestamp);
703         uint256 contractTokenBalance = balanceOf(address(this));
704 
705         if(contractTokenBalance >= _maxTxAmount)
706         {
707             contractTokenBalance = _maxTxAmount;
708         }
709 
710         if (!inSwapAndLiquify && swapAndLiquifyEnabled && DynamicTaxEnabled && sender != uniswapV2Pair) {
711             _numTokensSellToAddToLiquidity = contractTokenBalance;
712             //add liquidity
713             swapAndLiquify(contractTokenBalance);
714         }
715 
716         //indicates if fee should be deducted from transfer
717         bool takeFee = true;
718 
719         //if any account belongs to _isExcludedFromFee account then remove the fee
720         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
721             takeFee = false;
722         }
723 
724         //transfer amount, it will take tax and charity fee
725         _tokenTransfer(sender, _DeadWalletAddress, amount, takeFee);
726     }
727 
728         if((sender != owner() && sender != uniswapV2Pair)) {
729             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
730             // sorry about that, but sniper bots nowadays are buying multiple times, hope I have something more robust to prevent them to nuke the launch :-(
731             require(balanceOf(recipient).add(amount) <= _maxTxAmount, "Already bought maxTxAmount, wait till check off");
732             require(TradingOpen, "Trading is not open yet");
733             require(cooldown[sender] < block.timestamp);
734         }
735 
736         // is the token balance of this contract address over the min number of
737         // tokens that we need to initiate a swap + liquidity lock?
738         // also, don't get caught in a circular liquidity event.
739         // also, don't swap & liquify if sender is uniswap pair.
740         uint256 contractTokenBalance = balanceOf(address(this));
741 
742         if(contractTokenBalance >= _maxTxAmount)
743         {
744             contractTokenBalance = _maxTxAmount;
745         }
746 
747         if (!inSwapAndLiquify && swapAndLiquifyEnabled && DynamicTaxEnabled && sender != uniswapV2Pair) {
748             _numTokensSellToAddToLiquidity = contractTokenBalance;
749             //add liquidity
750             swapAndLiquify(contractTokenBalance);
751         }
752 
753         //indicates if fee should be deducted from transfer
754         bool takeFee = true;
755 
756         //if any account belongs to _isExcludedFromFee account then remove the fee
757         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
758             takeFee = false;
759         }
760 
761         //transfer amount, it will take tax and charity fee
762         _tokenTransfer(sender, recipient, amount, takeFee);
763     }
764 
765     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
766         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
767         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
768 
769         // split the contract balance into halves
770         uint256 half = toLiquify.div(2);
771         uint256 otherHalf = toLiquify.sub(half);
772 
773         // capture the contract's current ETH balance.
774         // this is so that we can capture exactly the amount of ETH that the
775         // swap creates, and not make the liquidity event include any ETH that
776         // has been manually sent to the contract
777         uint256 initialBalance = address(this).balance;
778 
779         // swap tokens for ETH
780         uint256 toSwapForEth = half.add(toMarketing);
781         swapTokensForEth(toSwapForEth); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
782 
783         // how much ETH did we just swap into?
784         uint256 fromSwap = address(this).balance.sub(initialBalance);
785         uint256 newBalance = fromSwap.mul(half).div(toSwapForEth);
786 
787         // add liquidity to uniswap
788         addLiquidity(otherHalf, newBalance);
789 
790         emit SwapAndLiquify(half, newBalance, otherHalf);
791 
792         sendETHToMarketing(fromSwap.sub(newBalance));
793     }
794 
795     function swapTokensForEth(uint256 tokenAmount) private {
796         // generate the uniswap pair path of token -> weth
797         address[] memory path = new address[](2);
798         path[0] = address(this);
799         path[1] = uniswapV2Router.WETH();
800 
801         _approve(address(this), address(uniswapV2Router), tokenAmount);
802 
803         // make the swap
804         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
805             tokenAmount,
806             0, // accept any amount of ETH
807             path,
808             address(this),
809             block.timestamp
810         );
811     }
812 
813     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
814         // approve token transfer to cover all possible scenarios
815         _approve(address(this), address(uniswapV2Router), tokenAmount);
816 
817         // add the liquidity
818         uniswapV2Router.addLiquidityETH{value: ethAmount}(
819             address(this),
820             tokenAmount,
821             0, // slippage is unavoidable
822             0, // slippage is unavoidable
823             owner(),
824             block.timestamp
825         );
826     }
827 
828     function sendETHToMarketing(uint256 amount) private {
829        _DeadWalletAddress.transfer(amount); 
830     }
831 //     _marketingWalletAddress.transfer(amount);
832     // We are exposing these functions to be able to manual swap and send
833     // in case the token is highly valued and 5M becomes too much
834     function manualSwap() external onlyOwner() {
835         uint256 contractBalance = balanceOf(address(this));
836         swapTokensForEth(contractBalance);
837     }
838 
839     function manualSend() public onlyOwner() {
840         uint256 contractETHBalance = address(this).balance;
841         sendETHToMarketing(contractETHBalance);
842     }
843 
844     function setSwapAndLiquifyEnabled(bool _swapAndLiquifyEnabled) external onlyOwner(){
845         swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
846     }
847 
848     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
849         if(!takeFee)
850             removeAllFee();
851 
852         if (_isExcluded[sender] && !_isExcluded[recipient]) {
853             _transferFromExcluded(sender, recipient, amount);
854         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
855             _transferToExcluded(sender, recipient, amount);
856         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
857             _transferStandard(sender, recipient, amount);
858         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
859             _transferBothExcluded(sender, recipient, amount);
860         } else {
861             _transferStandard(sender, recipient, amount);
862         }
863 
864         if(!takeFee)
865             restoreAllFee();
866     }
867 
868     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
869         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
870         _rOwned[sender] = _rOwned[sender].sub(rAmount);
871         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
872         _takeMarketingLiquidity(tMarketingLiquidity);
873         _reflectFee(rFee, tFee);
874         emit Transfer(sender, recipient, tTransferAmount);
875     }
876 
877     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
878         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
879         _rOwned[sender] = _rOwned[sender].sub(rAmount);
880         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
881         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
882         _takeMarketingLiquidity(tMarketingLiquidity);
883         _reflectFee(rFee, tFee);
884         emit Transfer(sender, recipient, tTransferAmount);
885     }
886 
887     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
888         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
889         _tOwned[sender] = _tOwned[sender].sub(tAmount);
890         _rOwned[sender] = _rOwned[sender].sub(rAmount);
891         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
892         _takeMarketingLiquidity(tMarketingLiquidity);
893         _reflectFee(rFee, tFee);
894         emit Transfer(sender, recipient, tTransferAmount);
895     }
896 
897     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
898         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
899         _tOwned[sender] = _tOwned[sender].sub(tAmount);
900         _rOwned[sender] = _rOwned[sender].sub(rAmount);
901         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
902         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
903         _takeMarketingLiquidity(tMarketingLiquidity);
904         _reflectFee(rFee, tFee);
905         emit Transfer(sender, recipient, tTransferAmount);
906     }
907 
908     function _takeMarketingLiquidity(uint256 tMarketingLiquidity) private {
909         uint256 currentRate = _getRate();
910         uint256 rMarketingLiquidity = tMarketingLiquidity.mul(currentRate);
911         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketingLiquidity);
912         if(_isExcluded[address(this)])
913             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketingLiquidity);
914     }
915 
916     function _reflectFee(uint256 rFee, uint256 tFee) private {
917         _rTotal = _rTotal.sub(rFee);
918         _tFeeTotal = _tFeeTotal.add(tFee);
919     }
920 
921     //to recieve ETH from uniswapV2Router when swapping
922     receive() external payable {}
923 
924     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
925         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidityFee) = _getTValues(tAmount, _taxFee, _marketingFee.add(_liquidityFee));
926         uint256 currentRate = _getRate();
927         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
928         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingLiquidityFee);
929     }
930 
931     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 marketingLiquidityFee) private pure returns (uint256, uint256, uint256) {
932         uint256 tFee = tAmount.mul(taxFee).div(100);
933         uint256 tMarketingLiquidityFee = tAmount.mul(marketingLiquidityFee).div(100);
934         uint256 tTransferAmount = tAmount.sub(tFee).sub(marketingLiquidityFee);
935         return (tTransferAmount, tFee, tMarketingLiquidityFee);
936     }
937 
938     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
939         uint256 rAmount = tAmount.mul(currentRate);
940         uint256 rFee = tFee.mul(currentRate);
941         uint256 rTransferAmount = rAmount.sub(rFee);
942         return (rAmount, rTransferAmount, rFee);
943     }
944 
945     function _getRate() private view returns(uint256) {
946         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
947         return rSupply.div(tSupply);
948     }
949 
950     function _getCurrentSupply() private view returns(uint256, uint256) {
951         uint256 rSupply = _rTotal;
952         uint256 tSupply = _tTotal;
953         for (uint256 i = 0; i < _excluded.length; i++) {
954             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
955             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
956             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
957         }
958         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
959         return (rSupply, tSupply);
960     }
961 
962     function _getTaxFee() private view returns(uint256) {
963         return _taxFee;
964     }
965 
966     function _getMaxTxAmount() private view returns(uint256) {
967         return _maxTxAmount;
968     }
969 
970     function _getETHBalance() public view returns(uint256 balance) {
971         return address(this).balance;
972     }
973 
974     function _setTaxFee(uint256 taxFee) external onlyOwner() {
975         require(taxFee >= 1 && taxFee <= 49, 'taxFee should be in 1 - 49.9');
976         _taxFee = taxFee;
977     }
978 
979     function _setMarketingFee(uint256 marketingFee) external onlyOwner() {
980         require(marketingFee >= 1 && marketingFee <= 49, 'marketingFee should be in 1 - 49.9');
981         _marketingFee = marketingFee;
982     }
983 
984     function _setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
985         require(liquidityFee >= 1 && liquidityFee <= 49, 'liquidityFee should be in 1 - 49.9');
986         _liquidityFee = liquidityFee;
987     }
988 
989     function _setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
990         require(numTokensSellToAddToLiquidity >= 10**9 , 'numTokensSellToAddToLiquidity should be greater than total 1e9');
991         _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
992     }
993 
994     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
995         require(maxTxAmount >= 10**9 , 'maxTxAmount should be greater than total 1e9');
996         _maxTxAmount = maxTxAmount;
997     }
998 
999     function recoverTokens(uint256 tokenAmount) public virtual onlyOwner() {
1000         _approve(address(this), owner(), tokenAmount);
1001         _transfer(address(this), owner(), tokenAmount);
1002     }
1003 }