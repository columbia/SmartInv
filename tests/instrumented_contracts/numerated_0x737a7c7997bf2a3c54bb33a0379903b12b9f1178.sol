1 // SPDX-License-Identifier:MIT
2 
3 pragma solidity ^0.8.10;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address _account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount)
19         external
20         returns (bool);
21     function allowance(address owner, address spender)
22         external
23         view
24         returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _setOwner(_msgSender());
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any _account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(owner() == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         _setOwner(address(0));
71     }
72 
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(
75             newOwner != address(0),
76             "Ownable: new owner is the zero address"
77         );
78         _setOwner(newOwner);
79     }
80 
81     function _setOwner(address newOwner) private {
82         address oldOwner = _owner;
83         _owner = newOwner;
84         emit OwnershipTransferred(oldOwner, newOwner);
85     }
86 }
87 
88 library SafeMath {
89 
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93 
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100 
101     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b <= a, errorMessage);
103         uint256 c = a - b;
104 
105         return c;
106     }
107 
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         if (a == 0) {
110             return 0;
111         }
112 
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115 
116         return c;
117     }
118 
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b != 0, errorMessage);
137         return a % b;
138     }
139 }
140 
141 interface IDexSwapFactory {
142     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
143     function createPair(address tokenA, address tokenB) external returns (address pair);
144 }
145 
146 interface IDexSwapPair {
147     event Approval(address indexed owner, address indexed spender, uint value);
148     event Transfer(address indexed from, address indexed to, uint value);
149 
150     function name() external pure returns (string memory);
151     function symbol() external pure returns (string memory);
152     function decimals() external pure returns (uint8);
153     function totalSupply() external view returns (uint);
154     function balanceOf(address owner) external view returns (uint);
155     function allowance(address owner, address spender) external view returns (uint);
156 
157     function approve(address spender, uint value) external returns (bool);
158     function transfer(address to, uint value) external returns (bool);
159     function transferFrom(address from, address to, uint value) external returns (bool);
160 
161     function DOMAIN_SEPARATOR() external view returns (bytes32);
162     function PERMIT_TYPEHASH() external pure returns (bytes32);
163     function nonces(address owner) external view returns (uint);
164 
165     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
166     
167     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
168     event Swap(
169         address indexed sender,
170         uint amount0In,
171         uint amount1In,
172         uint amount0Out,
173         uint amount1Out,
174         address indexed to
175     );
176     event Sync(uint112 reserve0, uint112 reserve1);
177 
178     function MINIMUM_LIQUIDITY() external pure returns (uint);
179     function factory() external view returns (address);
180     function token0() external view returns (address);
181     function token1() external view returns (address);
182     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
183     function price0CumulativeLast() external view returns (uint);
184     function price1CumulativeLast() external view returns (uint);
185     function kLast() external view returns (uint);
186 
187     function burn(address to) external returns (uint amount0, uint amount1);
188     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
189     function skim(address to) external;
190     function sync() external;
191 
192     function initialize(address, address) external;
193 }
194 
195 interface IDexSwapRouter {
196     function factory() external pure returns (address);
197     function WETH() external pure returns (address);
198     function addLiquidityETH(
199         address token,
200         uint amountTokenDesired,
201         uint amountTokenMin,
202         uint amountETHMin,
203         address to,
204         uint deadline
205     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
206     function swapExactTokensForETHSupportingFeeOnTransferTokens(
207         uint amountIn,
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external;
213 
214 }
215 
216 contract PrestigeWorldwideToken is Context, IERC20, Ownable {
217 
218     using SafeMath for uint256;
219 
220     string private _name = "PrestigeWorldwide";
221     string private _symbol = "CC";
222     uint8 private _decimals = 18; 
223 
224     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
225     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
226 
227     uint256 public _buyTaxFee = 5;
228     uint256 public _sellTaxFee = 5;
229 
230     address public FeeWallet = address(0xF8509abD805D814d9E478BC257949Fac270d23b5);
231     
232     uint256 feedenominator = 100;
233 
234     mapping (address => uint256) _balances;
235     mapping (address => mapping (address => uint256)) private _allowances;
236 
237     mapping (address => bool) public isExcludedFromFee;
238     mapping (address => bool) public isMarketPair;
239     mapping (address => bool) public isWalletLimitExempt;
240     mapping (address => bool) public isTxLimitExempt;
241 
242     uint256 private _totalSupply = 6_942_000_000_000 * 10**_decimals;
243 
244     uint256 public swapThreshold = _totalSupply.mul(5).div(10000);     //0.05%
245     
246     uint256 public _maxTxAmount =  _totalSupply.mul(10).div(1000);     // 1%
247     uint256 public _walletMax = _totalSupply.mul(10).div(1000);        // 1%
248 
249     bool public swapEnabled = true;
250     bool public swapbylimit = false;
251     bool public EnableTxLimit = true;
252     bool public checkWalletLimit = true;
253 
254     bool public activeTrade;
255 
256     IDexSwapRouter public dexRouter;
257     address public dexPair;
258 
259     bool inSwap;
260 
261     modifier swapping() {
262         inSwap = true;
263         _;
264         inSwap = false;
265     }
266     
267     event SwapTokensForETH(
268         uint256 amountIn,
269         address[] path
270     );
271 
272     constructor() {
273 
274         IDexSwapRouter _dexRouter = IDexSwapRouter(
275             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
276         );
277 
278         dexPair = IDexSwapFactory(_dexRouter.factory()).createPair(
279             address(this),
280             _dexRouter.WETH()
281         );
282 
283         dexRouter = _dexRouter;
284 
285         isExcludedFromFee[address(this)] = true;
286         isExcludedFromFee[msg.sender] = true;
287 
288         isWalletLimitExempt[msg.sender] = true;
289         isWalletLimitExempt[address(dexPair)] = true;
290         isWalletLimitExempt[address(dexRouter)] = true;
291         isWalletLimitExempt[address(this)] = true;
292         isWalletLimitExempt[deadAddress] = true;
293         isWalletLimitExempt[zeroAddress] = true;
294         
295         isTxLimitExempt[deadAddress] = true;
296         isTxLimitExempt[zeroAddress] = true;
297         isTxLimitExempt[msg.sender] = true;
298         isTxLimitExempt[address(this)] = true;
299         isTxLimitExempt[address(dexRouter)] = true;
300 
301         isMarketPair[address(dexPair)] = true;
302 
303         _allowances[address(this)][address(dexRouter)] = ~uint256(0);
304         _allowances[address(this)][address(dexPair)] = ~uint256(0);
305 
306         _balances[msg.sender] = _totalSupply;
307         emit Transfer(address(0), msg.sender, _totalSupply);
308     }
309 
310     function name() public view returns (string memory) {
311         return _name;
312     }
313 
314     function symbol() public view returns (string memory) {
315         return _symbol;
316     }
317 
318     function decimals() public view returns (uint8) {
319         return _decimals;
320     }
321 
322     function totalSupply() public view override returns (uint256) {
323         return _totalSupply;
324     }
325 
326     function balanceOf(address account) public view override returns (uint256) {
327        return _balances[account];     
328     }
329 
330     function allowance(address owner, address spender) public view override returns (uint256) {
331         return _allowances[owner][spender];
332     }
333     
334     function getCirculatingSupply() public view returns (uint256) {
335         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
336     }
337 
338     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
339         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
340         return true;
341     }
342 
343     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
344         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
345         return true;
346     }
347 
348     function approve(address spender, uint256 amount) public override returns (bool) {
349         _approve(_msgSender(), spender, amount);
350         return true;
351     }
352 
353     function _approve(address owner, address spender, uint256 amount) private {
354         require(owner != address(0), "ERC20: approve from the zero address");
355         require(spender != address(0), "ERC20: approve to the zero address");
356 
357         _allowances[owner][spender] = amount;
358         emit Approval(owner, spender, amount);
359     }
360 
361      //to recieve ETH from Router when swaping
362     receive() external payable {}
363 
364     function transfer(address recipient, uint256 amount) public override returns (bool) {
365         _transfer(_msgSender(), recipient, amount);
366         return true;
367     }
368 
369     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
370         _transfer(sender, recipient, amount);
371         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
372         return true;
373     }
374 
375     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
376 
377         require(sender != address(0), "ERC20: transfer from the zero address");
378         require(recipient != address(0), "ERC20: transfer to the zero address");
379         require(amount > 0, "Transfer amount must be greater than zero");
380 
381         if(!activeTrade) {
382             require(isExcludedFromFee[sender] || isExcludedFromFee[recipient],"Trading is not enable yet!");
383         }
384     
385         if (inSwap) {
386             return _basicTransfer(sender, recipient, amount);
387         }
388         else {
389 
390             uint256 contractTokenBalance = balanceOf(address(this));
391             bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;
392 
393             if (overMinimumTokenBalance && !inSwap && !isMarketPair[sender] && swapEnabled) {
394                 swapBack(contractTokenBalance);
395             }
396 
397             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
398                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
399             } 
400             
401             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
402 
403             uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
404 
405             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
406                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Max Wallet Limit Exceeded!!");
407             }
408 
409             _balances[recipient] = _balances[recipient].add(finalAmount);
410 
411             emit Transfer(sender, recipient, finalAmount);
412             return true;
413 
414         }
415 
416     }
417 
418     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
419         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
420         _balances[recipient] = _balances[recipient].add(amount);
421         emit Transfer(sender, recipient, amount);
422         return true;
423     }
424     
425     function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
426         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
427             return true;
428         }
429         else if (isMarketPair[sender] || isMarketPair[recipient]) {
430             return false;
431         }
432         else {
433             return false;
434         }
435     }
436 
437     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
438         
439         uint feeAmount;
440 
441         unchecked {
442 
443             if(isMarketPair[sender]) { 
444                 feeAmount = amount.mul(_buyTaxFee).div(feedenominator);
445             } 
446             else if(isMarketPair[recipient]) { 
447                 feeAmount = amount.mul(_sellTaxFee).div(feedenominator);
448             }
449 
450             if(feeAmount > 0) {
451                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
452                 emit Transfer(sender, address(this), feeAmount);
453             }
454 
455             return amount.sub(feeAmount);
456         }
457         
458     }
459 
460     function openTrade() external onlyOwner {
461         require(!activeTrade,"Trade Already Active!");
462         activeTrade = true;
463         _buyTaxFee = 30;
464         _sellTaxFee = 70;
465     }
466 
467     function swapBack(uint contractBalance) internal swapping {
468 
469         if(swapbylimit) contractBalance = swapThreshold;
470 
471         uint256 initialBalance = address(this).balance;
472         swapTokensForEth(contractBalance);
473         uint256 amountReceived = address(this).balance.sub(initialBalance);
474 
475         if(amountReceived > 0) payable(FeeWallet).transfer(amountReceived);
476 
477     }
478 
479     function swapTokensForEth(uint256 tokenAmount) private {
480         // generate the uniswap pair path of token -> weth
481         address[] memory path = new address[](2);
482         path[0] = address(this);
483         path[1] = dexRouter.WETH();
484 
485         _approve(address(this), address(dexRouter), tokenAmount);
486 
487         // make the swap
488         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
489             tokenAmount,
490             0, // accept any amount of ETH
491             path,
492             address(this), // The contract
493             block.timestamp
494         );
495         
496         emit SwapTokensForETH(tokenAmount, path);
497     }
498 
499     function rescueFunds() external onlyOwner { 
500         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
501         require(os,"Transaction Failed!!");
502     }
503 
504     function rescueTokens(address _token,address recipient,uint _amount) external onlyOwner {
505         (bool success, ) = address(_token).call(abi.encodeWithSignature('transfer(address,uint256)',  recipient, _amount));
506         require(success, 'Token payment failed');
507     }
508 
509     function setFee(uint _BuySide, uint _SellSide) external onlyOwner {    
510         _buyTaxFee = _BuySide;
511         _sellTaxFee = _SellSide;
512     }
513 
514     function enableTxLimit(bool _status) external onlyOwner {
515         EnableTxLimit = _status;
516     }
517 
518     function enableWalletLimit(bool _status) external onlyOwner {
519         checkWalletLimit = _status;
520     }
521 
522     function excludeFromFee(address _adr,bool _status) external onlyOwner {
523         isExcludedFromFee[_adr] = _status;
524     }
525 
526     function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
527         isWalletLimitExempt[_adr] = _status;
528     }
529 
530     function excludeTxLimit(address _adr,bool _status) external onlyOwner {
531         isTxLimitExempt[_adr] = _status;
532     }
533 
534     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
535         _walletMax = newLimit;
536     }
537 
538     function setTxLimit(uint256 newLimit) external onlyOwner() {
539         _maxTxAmount = newLimit;
540     }
541 
542     function setFeeWallet(address _newWallet) external onlyOwner {
543         FeeWallet = _newWallet;
544     }
545 
546     function setMarketPair(address _pair, bool _status) external onlyOwner {
547         isMarketPair[_pair] = _status;
548         if(_status) {
549             isWalletLimitExempt[_pair] = _status;
550         }
551     }
552 
553     function setSwapBackSettings(bool _enabled, bool _limited)
554         external
555         onlyOwner
556     {
557         swapEnabled = _enabled;
558         swapbylimit = _limited;
559     }
560 
561     function setSwapthreshold(uint _threshold) external onlyOwner {
562         swapThreshold = _threshold;
563     }
564 
565     function setManualRouter(address _router) external onlyOwner {
566         dexRouter = IDexSwapRouter(_router);
567     }
568 
569     function setManualPair(address _pair) external onlyOwner {
570         dexPair = _pair;
571     }
572 
573 
574 }