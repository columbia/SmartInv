1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.6;
5 pragma experimental ABIEncoderV2;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address account) external view returns (uint256);
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 library SafeMath {
20     
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {
31             if (b > a) return (false, 0);
32             return (true, a - b);
33         }
34     }
35 
36     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (a == 0) return (true, 0);
39             uint256 c = a * b;
40             if (c / a != b) return (false, 0);
41             return (true, c);
42         }
43     }
44 
45     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             if (b == 0) return (false, 0);
48             return (true, a / b);
49         }
50     }
51 
52     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             if (b == 0) return (false, 0);
55             return (true, a % b);
56         }
57     }
58 
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a + b;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a - b;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a * b;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a / b;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a % b;
77     }
78 
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         unchecked {
81             require(b <= a, errorMessage);
82             return a - b;
83         }
84     }
85 
86     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         unchecked {
88             require(b > 0, errorMessage);
89             return a / b;
90         }
91     }
92 
93     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         unchecked {
95             require(b > 0, errorMessage);
96             return a % b;
97         }
98     }
99 }
100 
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 abstract contract Ownable is Context {
112     address private _owner;
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115     constructor() {
116         _setOwner(_msgSender());
117     }
118 
119     function owner() public view virtual returns (address) {
120         return _owner;
121     }
122 
123     modifier onlyOwner() {
124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     function renounceOwnership() public virtual onlyOwner {
129         _setOwner(address(0));
130     }
131 
132     function transferOwnership(address newOwner) public virtual onlyOwner {
133         require(newOwner != address(0), "Ownable: new owner is the zero address");
134         _setOwner(newOwner);
135     }
136 
137     function _setOwner(address newOwner) private {
138         address oldOwner = _owner;
139         _owner = newOwner;
140         emit OwnershipTransferred(oldOwner, newOwner);
141     }
142 }
143 
144 library Address {
145     function isContract(address account) internal view returns (bool) {
146         uint256 size;
147         assembly {
148             size := extcodesize(account)
149         }
150         return size > 0;
151     }
152 
153     function sendValue(address payable recipient, uint256 amount) internal {
154         require(address(this).balance >= amount, "Address: insufficient balance");
155 
156         (bool success, ) = recipient.call{value: amount}("");
157         require(success, "Address: unable to send value, recipient may have reverted");
158     }
159 
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     function functionCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     function functionCallWithValue(
172         address target,
173         bytes memory data,
174         uint256 value) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
176     }
177 
178     function functionCallWithValue(
179         address target,
180         bytes memory data,
181         uint256 value,
182         string memory errorMessage) internal returns (bytes memory) {
183         require(address(this).balance >= value, "Address: insufficient balance for call");
184         require(isContract(target), "Address: call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.call{value: value}(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
191         return functionStaticCall(target, data, "Address: low-level static call failed");
192     }
193 
194     function functionStaticCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage) internal view returns (bytes memory) {
198         require(isContract(target), "Address: static call to non-contract");
199 
200         (bool success, bytes memory returndata) = target.staticcall(data);
201         return verifyCallResult(success, returndata, errorMessage);
202     }
203 
204     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
206     }
207 
208     function functionDelegateCall(
209         address target,
210         bytes memory data,
211         string memory errorMessage) internal returns (bytes memory) {
212         require(isContract(target), "Address: delegate call to non-contract");
213 
214         (bool success, bytes memory returndata) = target.delegatecall(data);
215         return verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     function verifyCallResult(
219         bool success,
220         bytes memory returndata,
221         string memory errorMessage) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             if (returndata.length > 0) {
226 
227                 assembly {
228                     let returndata_size := mload(returndata)
229                     revert(add(32, returndata), returndata_size)
230                 }
231             } else {
232                 revert(errorMessage);
233             }
234         }
235     }
236 }
237 
238 interface IUniswapV2Factory {
239     function createPair(address tokenA, address tokenB)
240         external
241         returns (address pair);
242     function getPair(address tokenA, address tokenB) external view returns (address pair);
243 }
244 
245 interface IUniswapV2Pair {
246     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
247     function factory() external view returns (address);
248     function token0() external view returns (address);
249     function token1() external view returns (address);
250     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
251     
252     event Swap(
253         address indexed sender,
254         uint amount0In,
255         uint amount1In,
256         uint amount0Out,
257         uint amount1Out,
258         address indexed to
259     );
260 }
261 
262 interface IUniswapV2Router02 {
263     function factory() external pure returns (address);
264 
265     function WETH() external pure returns (address);
266 
267     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
268         uint amountIn,
269         uint amountOutMin,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external;
274     function swapExactETHForTokensSupportingFeeOnTransferTokens(
275         uint amountOutMin,
276         address[] calldata path,
277         address to,
278         uint deadline
279     ) external payable;
280     function swapETHForExactTokens(
281         uint amountOut, 
282         address[] calldata path, 
283         address to, 
284         uint deadline
285     ) external payable returns (uint[] memory amounts);
286     function swapExactETHForTokens(
287         uint amountOutMin, 
288         address[] calldata path, 
289         address to, 
290         uint deadline
291     ) external payable returns (uint[] memory amounts);
292     function swapExactTokensForETHSupportingFeeOnTransferTokens(
293         uint amountIn,
294         uint amountOutMin,
295         address[] calldata path,
296         address to,
297         uint deadline
298     ) external;
299     function swapTokensForExactETH(
300         uint amountOut, 
301         uint amountInMax, 
302         address[] calldata path, 
303         address to, 
304         uint deadline
305     ) external returns (uint[] memory amounts);
306     function addLiquidityETH(
307         address token,
308         uint amountTokenDesired,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline
313     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
314      function addLiquidity(
315         address tokenA,
316         address tokenB,
317         uint256 amountADesired,
318         uint256 amountBDesired,
319         uint256 amountAMin,
320         uint256 amountBMin,
321         address to,
322         uint256 deadline
323     )external
324         returns (
325             uint256 amountA,
326             uint256 amountB,
327             uint256 liquidity
328         );
329     function removeLiquidity(
330         address tokenA,
331         address tokenB,
332         uint liquidity,
333         uint amountAMin,
334         uint amountBMin,
335         address to,
336         uint deadline
337         ) external returns (uint amountA, uint amountB);
338 }
339 
340 
341 contract PEQI2 is Context, IERC20, Ownable {
342     using SafeMath for uint256;
343     using Address for address;
344 
345     mapping (address => uint256) private _tOwned;
346     mapping (address => mapping (address => uint256)) private _allowances;
347 
348     mapping (address => bool) public _isExcludedFromFee;
349    
350     uint8 private _decimals = 18;
351     uint256 private _tTotal;
352     uint256 public supply = 3200000 * (10 ** 8) * (10 ** 18);
353 
354     string private _name = "Peppa2.0";
355     string private _symbol = "Peppa2.0";
356 
357     uint256 public _marketFee = 1;
358 
359     address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
360     address public marketAddress = 0x7e8acB38dcaB5667a5Be98b6f5Ff68602819581b ;
361 
362     address public initPoolAddress = 0x0eFf467a676A3593098DE4644A7b3e1386F423A1;
363 
364     IUniswapV2Router02 public uniswapV2Router;
365 
366     mapping(address => bool) public ammPairs;
367 
368     IERC20 public uniswapV2Pair;
369     address public weth;
370 
371     mapping(address => bool) public isBlackList;
372 
373     address constant rootAddress = address(0x000000000000000000000000000000000000dEaD);
374     address ethPair;
375 
376     uint256 currentIndex;
377     uint256 distributorGas = 500000;
378 
379     uint256 tradingAmountLimit = 1000 * (10 ** 8) * (10 ** 18);
380     uint256 addTradingLimit = 2000 * (10 ** 8) * (10 ** 18);
381 
382     uint256 launchedBlock;
383     bool openTransaction;
384     uint256 private firstTime = 3;
385     uint256 private secondTime = 10;
386 
387     bool public swapEnabled = true;
388     uint256 public swapThreshold = supply / 100000;
389     bool inSwap;
390     modifier swapping() { inSwap = true; _; inSwap = false; }
391     
392     constructor () {
393         _tOwned[initPoolAddress] = supply;
394         _tTotal = supply;
395         
396         _isExcludedFromFee[address(this)] = true;
397         _isExcludedFromFee[address(msg.sender)] = true;
398         _isExcludedFromFee[rootAddress] = true;
399         _isExcludedFromFee[initPoolAddress] = true;
400         _isExcludedFromFee[marketAddress] = true;
401 
402         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
403         uniswapV2Router = _uniswapV2Router;
404 
405         ethPair = IUniswapV2Factory(_uniswapV2Router.factory())
406             .createPair(address(this), _uniswapV2Router.WETH());
407         weth = _uniswapV2Router.WETH();
408 
409         uniswapV2Pair = IERC20(ethPair);
410         ammPairs[ethPair] = true;
411 
412         emit Transfer(address(0), initPoolAddress, _tTotal);
413     }
414 
415     function name() public view returns (string memory) {
416         return _name;
417     }
418 
419     function symbol() public view returns (string memory) {
420         return _symbol;
421     }
422 
423     function decimals() public view returns (uint8) {
424         return _decimals;
425     }
426 
427     function totalSupply() public view override returns (uint256) {
428         return _tTotal;
429     }
430 
431     function balanceOf(address account) public view override returns (uint256) {
432         return _tOwned[account];
433     }
434 
435     function transfer(address recipient, uint256 amount) public override returns (bool) {
436         _transfer(_msgSender(), recipient, amount);
437         return true;
438     }
439 
440     function allowance(address owner, address spender) public view override returns (uint256) {
441         return _allowances[owner][spender];
442     }
443 
444     function approve(address spender, uint256 amount) public override returns (bool) {
445         _approve(_msgSender(), spender, amount);
446         return true;
447     }
448 
449     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
450         _transfer(sender, recipient, amount);
451         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
452         return true;
453     }
454 
455     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
456         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
457         return true;
458     }
459 
460     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
462         return true;
463     }
464 
465     function _approve(address owner, address spender, uint256 amount) private {
466         require(owner != address(0), "ERC20: approve from the zero address");
467         require(spender != address(0), "ERC20: approve to the zero address");
468 
469         _allowances[owner][spender] = amount;
470         emit Approval(owner, spender, amount);
471     }
472 
473     function _take(uint256 tValue,address from,address to) private {
474         _tOwned[to] = _tOwned[to].add(tValue);
475         emit Transfer(from, to, tValue);
476     }
477 
478     receive() external payable {}
479 
480     function isContract(address account) internal view returns (bool) {
481         uint256 size;
482         assembly {
483             size := extcodesize(account)
484         }
485         return size > 0;
486     }
487 
488     struct Param{
489         bool takeFee;
490         uint tTransferAmount;
491         uint tContract;
492     }
493 
494     function _initParam(uint256 tAmount,Param memory param) private view  {
495         uint tFee;
496         
497         if (block.number - launchedBlock > firstTime) {
498             tFee = tAmount * _marketFee / 100;
499         } else {
500             tFee = tAmount * 90 / 100;  
501         }
502         param.tContract = tFee;
503         param.tTransferAmount = tAmount.sub(tFee);
504     }
505 
506     function _takeFee(Param memory param,address from)private {
507         if( param.tContract > 0 ){
508             _take(param.tContract, from, address(this));
509         }
510     }
511 
512     function shouldSwapBack(address to) internal view returns (bool) {
513         return (ammPairs[to]) 
514         && !inSwap
515         && swapEnabled
516         && balanceOf(address(this)) >= swapThreshold;
517     }
518 
519     function swapBack() internal swapping {
520         _allowances[address(this)][address(uniswapV2Router)] = swapThreshold;
521         
522         address[] memory path = new address[](2);
523         path[0] = address(this);
524         path[1] = weth;
525         uint256 balanceBefore = address(this).balance;
526 
527         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
528             swapThreshold,
529             0,
530             path,
531             address(this),
532             block.timestamp
533         );
534 
535         uint256 amountEth = address(this).balance.sub(balanceBefore);
536 
537         payable(marketAddress).transfer(amountEth); 
538     }
539 
540     function _transfer(
541         address from,
542         address to,
543         uint256 amount
544     ) private {
545         require(from != address(0), "ERC20: transfer from the zero address");
546         require(amount > 0, "ERC20: transfer amount must be greater than zero");
547 
548         bool takeFee;
549         Param memory param;
550         param.tTransferAmount = amount;
551 
552         if( ammPairs[to] && IERC20(to).totalSupply() == 0  ){
553             require(from == initPoolAddress,"Not allow init");
554         }
555 
556         if(inSwap || _isExcludedFromFee[from] || _isExcludedFromFee[to]){
557             return _tokenTransfer(from,to,amount,param); 
558         }
559 
560         require(openTransaction && !isBlackList[from],"Not allow");
561 
562         uint256 currentBlock = block.number;
563 
564         if (currentBlock - launchedBlock < firstTime && ammPairs[from]) {
565             isBlackList[to] = true;
566         }
567 
568         if (currentBlock - launchedBlock < secondTime) {
569             if (ammPairs[from]) {
570                 require(amount <= tradingAmountLimit.add((currentBlock - launchedBlock).mul(addTradingLimit)), "Trading amount limit exceeded");
571             }
572         }    
573 
574         if(ammPairs[to] || ammPairs[from]){
575             takeFee = true;
576         }
577 
578         if(shouldSwapBack(to)){ swapBack(); }
579 
580         param.takeFee = takeFee;
581         if( takeFee ){
582             _initParam(amount,param);
583         }
584         
585         _tokenTransfer(from,to,amount,param);
586     }
587 
588     function _tokenTransfer(address sender, address recipient, uint256 tAmount,Param memory param) private {
589         _tOwned[sender] = _tOwned[sender].sub(tAmount);
590         _tOwned[recipient] = _tOwned[recipient].add(param.tTransferAmount);
591 
592         emit Transfer(sender, recipient, param.tTransferAmount);
593 
594         if(param.takeFee == true){
595             _takeFee(param,sender);
596         }
597     }
598 
599     function setOpenTransaction() external onlyOwner {
600         require(openTransaction == false, "Already opened");
601         openTransaction = true;
602         launchedBlock = block.number;
603     }
604 
605     function muliSetExcludeFromFee(address[] calldata users, bool _isExclude) external onlyOwner {
606         for (uint i = 0; i < users.length; i++) {
607             _isExcludedFromFee[users[i]] = _isExclude;
608         }
609     }
610 
611     function muliSetBlackList(address[] calldata users, bool _isBlackList) external onlyOwner {
612         for (uint i = 0; i < users.length; i++) {
613             isBlackList[users[i]] = _isBlackList;
614         }
615     }
616 
617     function setTradingLimit(uint256 _tradingAmountLimit, uint256 _addTradingLimit) external onlyOwner {
618         tradingAmountLimit = _tradingAmountLimit;
619         addTradingLimit = _addTradingLimit;
620     }
621 
622     function setTimes(uint256 _firstTime, uint256 _secondTime) external onlyOwner {
623         firstTime = _firstTime;
624         secondTime = _secondTime;
625     }
626 
627     function setAmmPair(address pair,bool hasPair) external onlyOwner {
628         ammPairs[pair] = hasPair;
629     }
630 
631     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
632         swapEnabled = _enabled;
633         swapThreshold = _amount;
634     }
635 
636     function setFee(uint256 marketFee) external onlyOwner {
637         _marketFee = marketFee;
638     }
639 
640 }