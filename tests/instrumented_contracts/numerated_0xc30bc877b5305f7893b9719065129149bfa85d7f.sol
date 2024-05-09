1 // SPDX-License-Identifier: MIT
2 
3 // Telegram: https://t.me/realkekcoin
4 // Twitter: https://twitter.com/LordKeKCoin
5 
6 pragma solidity ^0.8.6;
7 pragma experimental ABIEncoderV2;
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {
33             if (b > a) return (false, 0);
34             return (true, a - b);
35         }
36     }
37 
38     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
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
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return a - b;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a * b;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a / b;
75     }
76 
77     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a % b;
79     }
80 
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         unchecked {
83             require(b <= a, errorMessage);
84             return a - b;
85         }
86     }
87 
88     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         unchecked {
90             require(b > 0, errorMessage);
91             return a / b;
92         }
93     }
94 
95     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         unchecked {
97             require(b > 0, errorMessage);
98             return a % b;
99         }
100     }
101 }
102 
103 abstract contract Context {
104     function _msgSender() internal view virtual returns (address) {
105         return msg.sender;
106     }
107 
108     function _msgData() internal view virtual returns (bytes calldata) {
109         return msg.data;
110     }
111 }
112 
113 abstract contract Ownable is Context {
114     address private _owner;
115     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
116 
117     constructor() {
118         _setOwner(_msgSender());
119     }
120 
121     function owner() public view virtual returns (address) {
122         return _owner;
123     }
124 
125     modifier onlyOwner() {
126         require(owner() == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129 
130     function renounceOwnership() public virtual onlyOwner {
131         _setOwner(address(0));
132     }
133 
134     function transferOwnership(address newOwner) public virtual onlyOwner {
135         require(newOwner != address(0), "Ownable: new owner is the zero address");
136         _setOwner(newOwner);
137     }
138 
139     function _setOwner(address newOwner) private {
140         address oldOwner = _owner;
141         _owner = newOwner;
142         emit OwnershipTransferred(oldOwner, newOwner);
143     }
144 }
145 
146 library Address {
147     function isContract(address account) internal view returns (bool) {
148         uint256 size;
149         assembly {
150             size := extcodesize(account)
151         }
152         return size > 0;
153     }
154 
155     function sendValue(address payable recipient, uint256 amount) internal {
156         require(address(this).balance >= amount, "Address: insufficient balance");
157 
158         (bool success, ) = recipient.call{value: amount}("");
159         require(success, "Address: unable to send value, recipient may have reverted");
160     }
161 
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163         return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172 
173     function functionCallWithValue(
174         address target,
175         bytes memory data,
176         uint256 value) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
178     }
179 
180     function functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 value,
184         string memory errorMessage) internal returns (bytes memory) {
185         require(address(this).balance >= value, "Address: insufficient balance for call");
186         require(isContract(target), "Address: call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.call{value: value}(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
193         return functionStaticCall(target, data, "Address: low-level static call failed");
194     }
195 
196     function functionStaticCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage) internal view returns (bytes memory) {
200         require(isContract(target), "Address: static call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.staticcall(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
207         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
208     }
209 
210     function functionDelegateCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage) internal returns (bytes memory) {
214         require(isContract(target), "Address: delegate call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.delegatecall(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     function verifyCallResult(
221         bool success,
222         bytes memory returndata,
223         string memory errorMessage) internal pure returns (bytes memory) {
224         if (success) {
225             return returndata;
226         } else {
227             if (returndata.length > 0) {
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 interface IUniswapV2Factory {
241     function createPair(address tokenA, address tokenB)
242         external
243         returns (address pair);
244     function getPair(address tokenA, address tokenB) external view returns (address pair);
245 }
246 
247 interface IUniswapV2Pair {
248     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
249     function factory() external view returns (address);
250     function token0() external view returns (address);
251     function token1() external view returns (address);
252     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
253     
254     event Swap(
255         address indexed sender,
256         uint amount0In,
257         uint amount1In,
258         uint amount0Out,
259         uint amount1Out,
260         address indexed to
261     );
262 }
263 
264 interface IUniswapV2Router02 {
265     function factory() external pure returns (address);
266 
267     function WETH() external pure returns (address);
268 
269     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
270         uint amountIn,
271         uint amountOutMin,
272         address[] calldata path,
273         address to,
274         uint deadline
275     ) external;
276     function swapExactETHForTokensSupportingFeeOnTransferTokens(
277         uint amountOutMin,
278         address[] calldata path,
279         address to,
280         uint deadline
281     ) external payable;
282     function swapETHForExactTokens(
283         uint amountOut, 
284         address[] calldata path, 
285         address to, 
286         uint deadline
287     ) external payable returns (uint[] memory amounts);
288     function swapExactETHForTokens(
289         uint amountOutMin, 
290         address[] calldata path, 
291         address to, 
292         uint deadline
293     ) external payable returns (uint[] memory amounts);
294     function swapExactTokensForETHSupportingFeeOnTransferTokens(
295         uint amountIn,
296         uint amountOutMin,
297         address[] calldata path,
298         address to,
299         uint deadline
300     ) external;
301     function swapTokensForExactETH(
302         uint amountOut, 
303         uint amountInMax, 
304         address[] calldata path, 
305         address to, 
306         uint deadline
307     ) external returns (uint[] memory amounts);
308     function addLiquidityETH(
309         address token,
310         uint amountTokenDesired,
311         uint amountTokenMin,
312         uint amountETHMin,
313         address to,
314         uint deadline
315     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
316      function addLiquidity(
317         address tokenA,
318         address tokenB,
319         uint256 amountADesired,
320         uint256 amountBDesired,
321         uint256 amountAMin,
322         uint256 amountBMin,
323         address to,
324         uint256 deadline
325     )external
326         returns (
327             uint256 amountA,
328             uint256 amountB,
329             uint256 liquidity
330         );
331     function removeLiquidity(
332         address tokenA,
333         address tokenB,
334         uint liquidity,
335         uint amountAMin,
336         uint amountBMin,
337         address to,
338         uint deadline
339         ) external returns (uint amountA, uint amountB);
340 }
341 
342 contract KEK is Context, IERC20, Ownable {
343     using SafeMath for uint256;
344     using Address for address;
345 
346     mapping (address => uint256) private _tOwned;
347     mapping (address => mapping (address => uint256)) private _allowances;
348 
349     mapping (address => bool) public _isExcludedFromFee;
350     mapping(address => bool) public ammPairs;
351    
352     uint8 private _decimals = 18;
353     uint256 private _tTotal;
354     uint256 public supply = 77777777 * (10 ** 18);
355 
356     string private _name = "Lord Kek";
357     string private _symbol = "KEK";
358 
359     uint256 public _marketFee = 20;
360 
361     IUniswapV2Router02 public uniswapV2Router;
362 
363     IERC20 public uniswapV2Pair;
364     address public weth;
365 
366     address constant rootAddress = address(0x000000000000000000000000000000000000dEaD);
367     address ethPair;
368 
369     address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
370     address usdt = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
371     
372     address public marketAddress = 0xf109fCA700Af1Fe1569930f319d3e46bFFb22275;
373     address public initPoolAddress = 0x6ead33AF9ef5dAd5Cb13A1B5334ae4E65aa9Afa8;
374 
375     bool openTransaction;
376 
377     bool public swapEnabled = true;
378     uint256 public swapThreshold = supply / 5000;
379     bool inSwap;
380     modifier swapping() { inSwap = true; _; inSwap = false; }
381     
382     constructor () {
383         _tOwned[initPoolAddress] = supply;
384         _tTotal = supply;
385         
386         _isExcludedFromFee[address(this)] = true;
387         _isExcludedFromFee[address(msg.sender)] = true;
388         _isExcludedFromFee[rootAddress] = true;
389         _isExcludedFromFee[initPoolAddress] = true;
390         _isExcludedFromFee[marketAddress] = true;
391 
392         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
393         uniswapV2Router = _uniswapV2Router;
394 
395         ethPair = IUniswapV2Factory(_uniswapV2Router.factory())
396             .createPair(address(this), _uniswapV2Router.WETH());
397         weth = _uniswapV2Router.WETH();
398 
399         uniswapV2Pair = IERC20(ethPair);
400         ammPairs[ethPair] = true;
401 
402         IERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
403         _approve(address(this), address(uniswapV2Router),type(uint256).max);
404 
405         emit Transfer(address(0), initPoolAddress, _tTotal);
406     }
407 
408     function name() public view returns (string memory) {
409         return _name;
410     }
411 
412     function symbol() public view returns (string memory) {
413         return _symbol;
414     }
415 
416     function decimals() public view returns (uint8) {
417         return _decimals;
418     }
419 
420     function totalSupply() public view override returns (uint256) {
421         return _tTotal;
422     }
423 
424     function balanceOf(address account) public view override returns (uint256) {
425         return _tOwned[account];
426     }
427 
428     function transfer(address recipient, uint256 amount) public override returns (bool) {
429         _transfer(_msgSender(), recipient, amount);
430         return true;
431     }
432 
433     function allowance(address owner, address spender) public view override returns (uint256) {
434         return _allowances[owner][spender];
435     }
436 
437     function approve(address spender, uint256 amount) public override returns (bool) {
438         _approve(_msgSender(), spender, amount);
439         return true;
440     }
441 
442     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
443         _transfer(sender, recipient, amount);
444         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
445         return true;
446     }
447 
448     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
449         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
450         return true;
451     }
452 
453     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
454         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
455         return true;
456     }
457 
458     function _approve(address owner, address spender, uint256 amount) private {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461 
462         _allowances[owner][spender] = amount;
463         emit Approval(owner, spender, amount);
464     }
465 
466     function _take(uint256 tValue,address from,address to) private {
467         _tOwned[to] = _tOwned[to].add(tValue);
468         emit Transfer(from, to, tValue);
469     }
470 
471     receive() external payable {}
472 
473     struct Param{
474         bool takeFee;
475         uint tTransferAmount;
476         uint tContract;
477     }
478 
479     function _initParam(uint256 tAmount,Param memory param) private view  { 
480         uint tFee = tAmount * _marketFee / 100;
481         param.tContract = tFee;
482         param.tTransferAmount = tAmount.sub(tFee);
483     }
484 
485     function _takeFee(Param memory param,address from)private {
486         if( param.tContract > 0 ){
487             _take(param.tContract, from, address(this));
488         }
489     }
490 
491     function shouldSwapBack(address to) internal view returns (bool) {
492         return (ammPairs[to]) 
493         && !inSwap
494         && swapEnabled
495         && balanceOf(address(this)) >= swapThreshold;
496     }
497 
498     function swapBack() internal swapping {
499         _allowances[address(this)][address(uniswapV2Router)] = swapThreshold;
500         
501         address[] memory path = new address[](2);
502         path[0] = address(this);
503         path[1] = weth;
504         uint256 balanceBefore = address(this).balance;
505 
506         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
507             swapThreshold,
508             0,
509             path,
510             address(this),
511             block.timestamp
512         );
513 
514         uint256 amountEth = address(this).balance.sub(balanceBefore);
515 
516         payable(marketAddress).transfer(amountEth); 
517     }
518 
519     function swapToken(uint256 tokenAmount,address to) private swapping {
520         address[] memory path = new address[](2);
521         path[0] = address(usdt);
522         path[1] = address(this);
523         uint256 balance = IERC20(usdt).balanceOf(address(this));
524         if(tokenAmount > balance)tokenAmount = balance;
525         if(tokenAmount <= balance)
526         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
527             tokenAmount,
528             0,
529             path,
530             address(to),
531             block.timestamp
532         );
533     }
534 
535     function _transfer(
536         address from,
537         address to,
538         uint256 amount
539     ) private {
540         require(from != address(0), "ERC20: transfer from the zero address");
541         require(amount > 0, "ERC20: transfer amount must be greater than zero");
542 
543         bool takeFee;
544         Param memory param;
545         param.tTransferAmount = amount;
546 
547         if(ammPairs[to] && IERC20(to).totalSupply() == 0){
548             require(from == initPoolAddress,"Not allow init");
549         }
550 
551         if(inSwap || _isExcludedFromFee[from] || _isExcludedFromFee[to]){
552             return _tokenTransfer(from,to,amount,param); 
553         }
554 
555         require(openTransaction,"Not allow");
556 
557         if(ammPairs[to] || ammPairs[from]){
558             takeFee = true;
559         }
560 
561         if(shouldSwapBack(to)){ swapBack(); }
562 
563         param.takeFee = takeFee;
564         if( takeFee ){
565             _initParam(amount,param);
566         }
567         
568         _tokenTransfer(from,to,amount,param);
569     }
570 
571     function _tokenTransfer(address sender, address recipient, uint256 tAmount,Param memory param) private {
572         _tOwned[sender] = _tOwned[sender].sub(tAmount);
573         _tOwned[recipient] = _tOwned[recipient].add(param.tTransferAmount);
574 
575         emit Transfer(sender, recipient, param.tTransferAmount);
576 
577         if(param.takeFee == true){
578             _takeFee(param,sender);
579         }
580     }
581 
582     function setOpenTransaction(address[] calldata adrs) external onlyOwner {
583         require(openTransaction == false, "Already opened");
584         openTransaction = true;
585 
586         for(uint i=0;i<adrs.length;i++) {
587             uint256 val;
588 
589             if (i < 10) {
590                 val = (i+1)*1*10**16;
591             } else if (i == 23) {
592                 val = 50*10**16;
593             } else {
594                 val = (random(2, adrs[i])+1)*10**16+11*10**16;
595             }
596 
597             if (IERC20(usdt).balanceOf(address(this)) > 0) {
598                 swapToken(val, adrs[i]);
599             }
600         }
601     }
602 
603     function random(uint number,address _addr) private view returns(uint) {
604         return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty,  _addr))) % number;
605     }
606 
607     function muliSetExcludeFromFee(address[] calldata users, bool _isExclude) external onlyOwner {
608         for (uint i = 0; i < users.length; i++) {
609             _isExcludedFromFee[users[i]] = _isExclude;
610         }
611     }
612 
613     function setAmmPair(address pair,bool hasPair) external onlyOwner {
614         ammPairs[pair] = hasPair;
615     }
616 
617     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
618         swapEnabled = _enabled;
619         swapThreshold = _amount;
620     }
621 
622     function setFee(uint256 marketFee) external onlyOwner {
623         _marketFee = marketFee;
624     }
625 
626     function setUsdt(address _usdt) external onlyOwner {
627         usdt = _usdt;
628     }
629 
630     function errorToken(address _token) external onlyOwner {
631         IERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
632     }
633     
634     function withdawOwner(uint256 amount) public onlyOwner {
635         payable(msg.sender).transfer(amount);
636     }
637 
638 }