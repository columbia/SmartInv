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
216 contract SprintToken is Context, IERC20, Ownable {
217 
218     using SafeMath for uint256;
219 
220     string private _name = "The Great Sprint";
221     string private _symbol = "Sprint";
222     uint8 private _decimals = 18; 
223 
224     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
225     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
226 
227     uint256 public _buyTreasuryFee = 5;
228     uint256 public _sellTreasuryFee = 5;
229 
230     address public Treasury = address(0xC9e69B35f4b12c43627Ba3628801aFEfF1A2Caa6);
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
242     uint256 private _totalSupply = 10_000_000 * 10**_decimals;
243 
244     uint256 public _maxTxAmount =  _totalSupply.mul(1).div(100);     // 1%
245     uint256 public _walletMax = _totalSupply.mul(1).div(100);        // 1%
246 
247     uint256 public swapThreshold = 20_000 * 10**_decimals;
248 
249     bool public swapEnabled = true;
250     bool public swapbylimit = true;
251     bool public EnableTxLimit = true;
252     bool public checkWalletLimit = true;
253 
254     IDexSwapRouter public dexRouter;
255     address public dexPair;
256 
257     bool inSwap;
258 
259     modifier swapping() {
260         inSwap = true;
261         _;
262         inSwap = false;
263     }
264     
265     event SwapTokensForETH(
266         uint256 amountIn,
267         address[] path
268     );
269 
270     constructor() {
271 
272         address _owner = address(0x69A1C6b73799F4b80B51f89eEcd0207230a1De70);
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
286         isExcludedFromFee[_owner] = true;
287         isExcludedFromFee[address(dexRouter)] = true;
288 
289         isWalletLimitExempt[_owner] = true;
290         isWalletLimitExempt[address(dexPair)] = true;
291         isWalletLimitExempt[address(dexRouter)] = true;
292         isWalletLimitExempt[address(this)] = true;
293         isWalletLimitExempt[deadAddress] = true;
294         isWalletLimitExempt[zeroAddress] = true;
295         
296         isTxLimitExempt[deadAddress] = true;
297         isTxLimitExempt[zeroAddress] = true;
298         isTxLimitExempt[_owner] = true;
299         isTxLimitExempt[address(this)] = true;
300         isTxLimitExempt[address(dexRouter)] = true;
301 
302         isMarketPair[address(dexPair)] = true;
303 
304         _allowances[address(this)][address(dexRouter)] = ~uint256(0);
305         _allowances[address(this)][address(dexPair)] = ~uint256(0);
306 
307         _balances[_owner] = _totalSupply;
308         emit Transfer(address(0), _owner, _totalSupply);
309     }
310 
311     function name() public view returns (string memory) {
312         return _name;
313     }
314 
315     function symbol() public view returns (string memory) {
316         return _symbol;
317     }
318 
319     function decimals() public view returns (uint8) {
320         return _decimals;
321     }
322 
323     function totalSupply() public view override returns (uint256) {
324         return _totalSupply;
325     }
326 
327     function balanceOf(address account) public view override returns (uint256) {
328        return _balances[account];     
329     }
330 
331     function allowance(address owner, address spender) public view override returns (uint256) {
332         return _allowances[owner][spender];
333     }
334     
335     function getCirculatingSupply() public view returns (uint256) {
336         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
337     }
338 
339     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
340         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
341         return true;
342     }
343 
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
346         return true;
347     }
348 
349     function approve(address spender, uint256 amount) public override returns (bool) {
350         _approve(_msgSender(), spender, amount);
351         return true;
352     }
353 
354     function _approve(address owner, address spender, uint256 amount) private {
355         require(owner != address(0), "ERC20: approve from the zero address");
356         require(spender != address(0), "ERC20: approve to the zero address");
357 
358         _allowances[owner][spender] = amount;
359         emit Approval(owner, spender, amount);
360     }
361 
362      //to recieve ETH from Router when swaping
363     receive() external payable {}
364 
365     function transfer(address recipient, uint256 amount) public override returns (bool) {
366         _transfer(_msgSender(), recipient, amount);
367         return true;
368     }
369 
370     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
371         _transfer(sender, recipient, amount);
372         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
373         return true;
374     }
375 
376     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
377 
378         require(sender != address(0), "ERC20: transfer from the zero address");
379         require(recipient != address(0), "ERC20: transfer to the zero address");
380         require(amount > 0, "Transfer amount must be greater than zero");
381     
382         if (inSwap) {
383             return _basicTransfer(sender, recipient, amount);
384         }
385         else {
386 
387             uint256 contractTokenBalance = balanceOf(address(this));
388             bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;
389 
390             if (overMinimumTokenBalance && !inSwap && !isMarketPair[sender] && swapEnabled) {
391                 swapBack(contractTokenBalance);
392             }
393 
394             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
395                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
396             } 
397             
398             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
399 
400             uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
401 
402             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
403                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Max Wallet Limit Exceeded!!");
404             }
405 
406             _balances[recipient] = _balances[recipient].add(finalAmount);
407 
408             emit Transfer(sender, recipient, finalAmount);
409             return true;
410 
411         }
412 
413     }
414 
415     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
416         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419         return true;
420     }
421     
422     function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
423         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
424             return true;
425         }
426         else if (isMarketPair[sender] || isMarketPair[recipient]) {
427             return false;
428         }
429         else {
430             return false;
431         }
432     }
433 
434     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
435         
436         uint feeAmount;
437 
438         unchecked {
439 
440             if(isMarketPair[sender]) { 
441                 feeAmount = amount.mul(_buyTreasuryFee).div(feedenominator);
442             } 
443             else if(isMarketPair[recipient]) { 
444                 feeAmount = amount.mul(_sellTreasuryFee).div(feedenominator);
445             }
446 
447             if(feeAmount > 0) {
448                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
449                 emit Transfer(sender, address(this), feeAmount);
450             }
451 
452             return amount.sub(feeAmount);
453         }
454         
455     }
456 
457     function swapBack(uint contractBalance) internal swapping {
458 
459         if(swapbylimit) contractBalance = swapThreshold;
460 
461         uint256 initialBalance = address(this).balance;
462         swapTokensForEth(contractBalance);
463         uint256 amountReceived = address(this).balance.sub(initialBalance);
464 
465        if(amountReceived > 0) payable(Treasury).transfer(amountReceived);
466 
467     }
468 
469     function swapTokensForEth(uint256 tokenAmount) private {
470         // generate the uniswap pair path of token -> weth
471         address[] memory path = new address[](2);
472         path[0] = address(this);
473         path[1] = dexRouter.WETH();
474 
475         _approve(address(this), address(dexRouter), tokenAmount);
476 
477         // make the swap
478         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
479             tokenAmount,
480             0, // accept any amount of ETH
481             path,
482             address(this), // The contract
483             block.timestamp
484         );
485         
486         emit SwapTokensForETH(tokenAmount, path);
487     }
488 
489     function rescueFunds() external onlyOwner { 
490         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
491         require(os,"Transaction Failed!!");
492     }
493 
494     function rescueTokens(address _token,address recipient,uint _amount) external onlyOwner {
495         (bool success, ) = address(_token).call(abi.encodeWithSignature('transfer(address,uint256)',  recipient, _amount));
496         require(success, 'Token payment failed');
497     }
498 
499     function setFee(uint _buyFee, uint _sellFee) external onlyOwner {    
500         _buyTreasuryFee = _buyFee;
501         _sellTreasuryFee = _sellFee;
502     }
503 
504     function enableTxLimit(bool _status) external onlyOwner {
505         EnableTxLimit = _status;
506     }
507 
508     function enableWalletLimit(bool _status) external onlyOwner {
509         checkWalletLimit = _status;
510     }
511 
512     function excludeFromFee(address _adr,bool _status) external onlyOwner {
513         isExcludedFromFee[_adr] = _status;
514     }
515 
516     function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
517         isWalletLimitExempt[_adr] = _status;
518     }
519 
520     function excludeTxLimit(address _adr,bool _status) external onlyOwner {
521         isTxLimitExempt[_adr] = _status;
522     }
523 
524     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
525         _walletMax = newLimit;
526     }
527 
528     function setTxLimit(uint256 newLimit) external onlyOwner() {
529         _maxTxAmount = newLimit;
530     }
531     
532     function setTreasuryWallet(address _newWallet) external onlyOwner {
533         Treasury = _newWallet;
534     }
535 
536     function setMarketPair(address _pair, bool _status) external onlyOwner {
537         isMarketPair[_pair] = _status;
538         if(_status) {
539             isWalletLimitExempt[_pair] = _status;
540         }
541     }
542 
543     function setSwapBackSettings(bool _enabled, bool _limited)
544         external
545         onlyOwner
546     {
547         swapEnabled = _enabled;
548         swapbylimit = _limited;
549     }
550 
551     function setSwapthreshold(uint _threshold) external onlyOwner {
552         swapThreshold = _threshold;
553     }
554 
555     function setManualRouter(address _router) external onlyOwner {
556         dexRouter = IDexSwapRouter(_router);
557     }
558 
559     function setManualPair(address _pair) external onlyOwner {
560         dexPair = _pair;
561     }
562 
563 
564 }