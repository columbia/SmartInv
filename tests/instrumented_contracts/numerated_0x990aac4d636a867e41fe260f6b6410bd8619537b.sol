1 /*
2 TELEGRAM : https://t.me/kekisfine
3 TWITTER: https://x.com/kekisfine
4 WEBSITE: http://kekisfine.vip/
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.10;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address _account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount)
25         external
26         returns (bool);
27     function allowance(address owner, address spender)
28         external
29         view
30         returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(
49         address indexed previousOwner,
50         address indexed newOwner
51     );
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _setOwner(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any _account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     function renounceOwnership() public virtual onlyOwner {
76         _setOwner(address(0));
77     }
78 
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(
81             newOwner != address(0),
82             "Ownable: new owner is the zero address"
83         );
84         _setOwner(newOwner);
85     }
86 
87     function _setOwner(address newOwner) private {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 library SafeMath {
95 
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99 
100         return c;
101     }
102 
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         return sub(a, b, "SafeMath: subtraction overflow");
105     }
106 
107     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         require(b <= a, errorMessage);
109         uint256 c = a - b;
110 
111         return c;
112     }
113 
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121 
122         return c;
123     }
124 
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b > 0, errorMessage);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b != 0, errorMessage);
143         return a % b;
144     }
145 }
146 
147 interface IDexSwapFactory {
148     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
149     function getPair(address tokenA, address tokenB) external view returns (address pair);
150     function createPair(address tokenA, address tokenB) external returns (address pair);
151 }
152 
153 interface IDexSwapPair {
154     event Approval(address indexed owner, address indexed spender, uint value);
155     event Transfer(address indexed from, address indexed to, uint value);
156 
157     function name() external pure returns (string memory);
158     function symbol() external pure returns (string memory);
159     function decimals() external pure returns (uint8);
160     function totalSupply() external view returns (uint);
161     function balanceOf(address owner) external view returns (uint);
162     function allowance(address owner, address spender) external view returns (uint);
163 
164     function approve(address spender, uint value) external returns (bool);
165     function transfer(address to, uint value) external returns (bool);
166     function transferFrom(address from, address to, uint value) external returns (bool);
167 
168     function DOMAIN_SEPARATOR() external view returns (bytes32);
169     function PERMIT_TYPEHASH() external pure returns (bytes32);
170     function nonces(address owner) external view returns (uint);
171 
172     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
173     
174     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
175     event Swap(
176         address indexed sender,
177         uint amount0In,
178         uint amount1In,
179         uint amount0Out,
180         uint amount1Out,
181         address indexed to
182     );
183     event Sync(uint112 reserve0, uint112 reserve1);
184 
185     function MINIMUM_LIQUIDITY() external pure returns (uint);
186     function factory() external view returns (address);
187     function token0() external view returns (address);
188     function token1() external view returns (address);
189     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
190     function price0CumulativeLast() external view returns (uint);
191     function price1CumulativeLast() external view returns (uint);
192     function kLast() external view returns (uint);
193 
194     function burn(address to) external returns (uint amount0, uint amount1);
195     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
196     function skim(address to) external;
197     function sync() external;
198 
199     function initialize(address, address) external;
200 }
201 
202 interface IDexSwapRouter {
203     function factory() external pure returns (address);
204     function WETH() external pure returns (address);
205     function addLiquidityETH(
206         address token,
207         uint amountTokenDesired,
208         uint amountTokenMin,
209         uint amountETHMin,
210         address to,
211         uint deadline
212     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
213     function swapExactTokensForETHSupportingFeeOnTransferTokens(
214         uint amountIn,
215         uint amountOutMin,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external;
220 
221 }
222 
223 contract KEKISFINE is Context, IERC20, Ownable {
224 
225     using SafeMath for uint256;
226 
227     address public developmentWallet;
228     
229     string private _name = "Kek is Fine";
230     string private _symbol = unicode"KEK";
231     uint8 private _decimals = 18; 
232     uint256 private _totalSupply = 1000_000_000 * 10**_decimals;
233     uint256 public _maxTxAmount =  _totalSupply.mul(2).div(100);     // 2%
234     uint256 public _walletMax = _totalSupply.mul(2).div(100);        // 2%
235     uint256 feedenominator = 100;
236 
237     mapping (address => uint256) _balances;
238     mapping (address => mapping (address => uint256)) private _allowances;
239 
240     mapping (address => bool) public isExcludedFromFee;
241     mapping (address => bool) public isMarketPair;
242     mapping (address => bool) public isWalletLimitExempt;
243     mapping (address => bool) public isTxLimitExempt;
244 
245     uint256 public swapThreshold = _totalSupply.mul(1).div(100);
246 
247     bool public swapEnabled = true;
248     bool public swapbylimit = true;
249     bool public EnableTxLimit = true;
250     bool public checkWalletLimit = true;
251 
252     uint public buyTax = 25;
253     uint public sellTax = 35;
254 
255     IDexSwapRouter public dexRouter;
256     address public dexPair;
257 
258     bool public tradingEnable; 
259     uint256 public launchedAt;
260 
261     bool inSwap;
262 
263     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
264     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
265 
266     modifier onlyGuard() {
267         require(msg.sender == developmentWallet,"Invalid Caller");
268         _;
269     }
270 
271     modifier swapping() {
272         inSwap = true;
273         _;
274         inSwap = false;
275     }
276     
277     event SwapTokensForETH(
278         uint256 amountIn,
279         address[] path
280     );
281 
282     constructor() {
283 
284         developmentWallet = msg.sender;
285 
286         IDexSwapRouter _dexRouter = IDexSwapRouter(
287             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
288         );
289 
290         dexPair = IDexSwapFactory(_dexRouter.factory())
291             .createPair(address(this), _dexRouter.WETH());
292 
293         dexRouter = _dexRouter;
294         
295         isExcludedFromFee[address(this)] = true;
296         isExcludedFromFee[msg.sender] = true;
297         isExcludedFromFee[address(dexRouter)] = true;
298 
299         isWalletLimitExempt[msg.sender] = true;
300         isWalletLimitExempt[address(dexRouter)] = true;
301         isWalletLimitExempt[address(this)] = true;
302         isWalletLimitExempt[deadAddress] = true;
303         isWalletLimitExempt[zeroAddress] = true;
304         isWalletLimitExempt[address(dexPair)] = true;
305         
306         isTxLimitExempt[deadAddress] = true;
307         isTxLimitExempt[zeroAddress] = true;
308         isTxLimitExempt[msg.sender] = true;
309         isTxLimitExempt[address(this)] = true;
310         isTxLimitExempt[address(dexRouter)] = true;
311 
312         isMarketPair[address(dexPair)] = true;
313 
314         _allowances[address(this)][address(dexPair)] = ~uint256(0);
315         _allowances[address(this)][address(dexRouter)] = ~uint256(0);
316 
317         _balances[msg.sender] = _totalSupply;
318         emit Transfer(address(0), msg.sender, _totalSupply);
319     }
320 
321     function name() public view returns (string memory) {
322         return _name;
323     }
324 
325     function symbol() public view returns (string memory) {
326         return _symbol;
327     }
328 
329     function decimals() public view returns (uint8) {
330         return _decimals;
331     }
332 
333     function totalSupply() public view override returns (uint256) {
334         return _totalSupply;
335     }
336 
337     function balanceOf(address account) public view override returns (uint256) {
338        return _balances[account];     
339     }
340 
341     function allowance(address owner, address spender) public view override returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
347         return true;
348     }
349 
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
352         return true;
353     }
354 
355     function approve(address spender, uint256 amount) public override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     function _approve(address owner, address spender, uint256 amount) private {
361         require(owner != address(0), "ERC20: approve from the zero address");
362         require(spender != address(0), "ERC20: approve to the zero address");
363 
364         _allowances[owner][spender] = amount;
365         emit Approval(owner, spender, amount);
366     }
367 
368      //to recieve ETH from Router when swaping
369     receive() external payable {}
370 
371     function transfer(address recipient, uint256 amount) public override returns (bool) {
372         _transfer(_msgSender(), recipient, amount);
373         return true;
374     }
375 
376     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
377         _transfer(sender, recipient, amount);
378         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: Exceeds allowance"));
379         return true;
380     }
381 
382     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
383 
384         require(sender != address(0));
385         require(recipient != address(0));
386         require(amount > 0);
387     
388         if (inSwap) {
389             return _basicTransfer(sender, recipient, amount);
390         }
391         else {
392 
393             if(!tradingEnable) {
394                 require(isExcludedFromFee[sender] || isExcludedFromFee[recipient], "Trading Paused"); 
395             }
396 
397             uint256 contractTokenBalance = balanceOf(address(this));
398             bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;
399 
400             if (
401                 overMinimumTokenBalance && 
402                 !inSwap && 
403                 !isMarketPair[sender] && 
404                 swapEnabled &&
405                 !isExcludedFromFee[sender] &&
406                 !isExcludedFromFee[recipient]
407                 ) {
408                 swapBack(contractTokenBalance);
409             }
410 
411             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
412                 require(amount <= _maxTxAmount, "Exceeds maxTxAmount");
413             } 
414             
415             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
416 
417             uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
418 
419             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
420                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Exceeds Wallet");
421             }
422 
423             _balances[recipient] = _balances[recipient].add(finalAmount);
424 
425             emit Transfer(sender, recipient, finalAmount);
426             return true;
427 
428         }
429 
430     }
431 
432     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
433         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
434         _balances[recipient] = _balances[recipient].add(amount);
435         emit Transfer(sender, recipient, amount);
436         return true;
437     }
438     
439     function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
440         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
441             return true;
442         }
443         else if (isMarketPair[sender] || isMarketPair[recipient]) {
444             return false;
445         }
446         else {
447             return false;
448         }
449     }
450 
451     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
452         
453         uint feeAmount;
454 
455         unchecked {
456 
457             if(isMarketPair[sender]) { 
458                 feeAmount = amount.mul(buyTax).div(feedenominator);
459             } 
460             else if(isMarketPair[recipient]) { 
461                 feeAmount = amount.mul(sellTax).div(feedenominator);
462             }
463 
464             if(feeAmount > 0) {
465                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
466                 emit Transfer(sender, address(this), feeAmount);
467             }
468 
469             return amount.sub(feeAmount);
470         }
471         
472     }
473 
474 
475     function swapBack(uint contractBalance) internal swapping {
476 
477         if(swapbylimit) contractBalance = swapThreshold;
478 
479         uint256 initialBalance = address(this).balance;
480         swapTokensForEth(contractBalance);
481         uint256 amountReceived = address(this).balance.sub(initialBalance);
482 
483         if(amountReceived > 0)
484             payable(developmentWallet).transfer(amountReceived);
485 
486     }
487 
488 
489     function swapTokensForEth(uint256 tokenAmount) private {
490         // generate the uniswap pair path of token -> weth
491         address[] memory path = new address[](2);
492         path[0] = address(this);
493         path[1] = dexRouter.WETH();
494 
495         _approve(address(this), address(dexRouter), tokenAmount);
496 
497         // make the swap
498         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
499             tokenAmount,
500             0, // accept any amount of ETH
501             path,
502             address(this), // The contract
503             block.timestamp
504         );
505         
506         emit SwapTokensForETH(tokenAmount, path);
507     }
508 
509     function rescueFunds() external onlyGuard { 
510         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
511         require(os,"Transaction Failed!!");
512     }
513 
514     function rescueTokens(address _token,address recipient,uint _amount) external onlyGuard {
515         (bool success, ) = address(_token).call(abi.encodeWithSignature('transfer(address,uint256)',  recipient, _amount));
516         require(success, 'Token payment failed');
517     }
518 
519     function setBuyFee(uint _buySide, uint _sellSide) external onlyOwner {    
520         buyTax = _buySide;
521         sellTax = _sellSide;
522     }
523 
524     function removeLimits() external onlyGuard {
525         EnableTxLimit = false;
526         checkWalletLimit =  false;
527     }
528 
529     function enableTxLimit(bool _status) external onlyOwner {
530         EnableTxLimit = _status;
531     }
532 
533     function enableWalletLimit(bool _status) external onlyOwner {
534         checkWalletLimit = _status;
535     }
536 
537     function excludeFromFee(address _adr,bool _status) external onlyOwner {
538         isExcludedFromFee[_adr] = _status;
539     }
540 
541     function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
542         isWalletLimitExempt[_adr] = _status;
543     }
544 
545     function excludeTxLimit(address _adr,bool _status) external onlyOwner {
546         isTxLimitExempt[_adr] = _status;
547     }
548 
549     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
550         _walletMax = newLimit;
551     }
552 
553     function setTxLimit(uint256 newLimit) external onlyOwner() {
554         _maxTxAmount = newLimit;
555     }
556     
557     function setDevelopmentWallet(address _newWallet) external onlyOwner {
558         developmentWallet = _newWallet;
559     }
560 
561     function setSwapBackSettings(uint _threshold, bool _enabled, bool _limited)
562         external
563         onlyGuard
564     {
565         swapEnabled = _enabled;
566         swapbylimit = _limited;
567         swapThreshold = _threshold;
568     }
569 
570     function enableTrading() external onlyOwner {
571         require(!tradingEnable, "Trade Enabled!");
572 
573         tradingEnable = true;
574         launchedAt = block.timestamp;
575     }
576 
577     function setMarketPair(address _pair, bool _status) external onlyOwner {
578         isMarketPair[_pair] = _status;
579         if(_status) {
580             isWalletLimitExempt[_pair] = _status;
581         }
582     }
583 
584 }