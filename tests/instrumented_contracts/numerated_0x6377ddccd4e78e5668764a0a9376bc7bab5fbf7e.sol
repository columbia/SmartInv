1 /*
2                         ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀
7                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣆⢳⡀⠀⠀⠀⠀⠀⠀
8                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣾⣷⡀⠀⠀⠀⠀⠀
9                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀
10                     ⠀⠀⠀⠀⠀⠀⠀⠠⣄⠀⢠⣿⣿⣿⣿⡎⢻⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀
11                     ⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⢸⣿⣿⣿⣿⡇⠀⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀
12                     ⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣾⣿⣿⣿⣿⠃⠀⢸⣿⣿⣿⣿⣿⣿⠀⣄⠀⠀
13                     ⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⠏⠀⠀⣸⣿⣿⣿⣿⣿⡿⢀⣿⡆⠀
14                     ⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⣿⣿⣿⣿⣿⣿⠇⣼⣿⣿⡄
15                     ⠀⢰⠀⠀⣴⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⢠⣿⣿⣿⣿⣿⡟⣼⣿⣿⣿⣧
16                     ⠀⣿⡀⢸⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⣸⡿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿
17                     ⠀⣿⣷⣼⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⢹⠃⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿
18                     ⡄⢻⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⠇
19                     ⢳⣌⢿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⠏⠀
20                     ⠀⢿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⠋⣠⠀
21                     ⠀⠈⢻⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣵⣿⠃⠀
22                     ⠀⠀⠀⠙⢿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⡿⠃⠀⠀
23                     ⠀⠀⠀⠀⠀⠙⢿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡿⠋⠀⠀⠀⠀
24                     ⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣦⣀⠀⠀⠀⠀⢀⣴⠿⠛⠁⠀⠀⠀⠀⠀⠀
25                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠓⠂⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀
26                                         
27                         ██       █████  ██████  ██████  
28                         ██      ██   ██ ██   ██ ██   ██ 
29                         ██      ███████ ██████  ██████  
30                         ██      ██   ██ ██   ██ ██      
31                         ███████ ██   ██ ██   ██ ██      
32                                 
33                                 
34 -> Telegram: https://t.me/LARPTokenERC
35 -> Twitter: https://Twitter.com/LarpTokenETH
36 -> Website: https://Larpcoin.wtf
37 
38 */
39 
40 // SPDX-License-Identifier:MIT
41 
42 pragma solidity ^0.8.16;
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes calldata) {
50         return msg.data;
51     }
52 }
53 
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56     function balanceOf(address _account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount)
58         external
59         returns (bool);
60     function allowance(address owner, address spender)
61         external
62         view
63         returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(
72         address indexed owner,
73         address indexed spender,
74         uint256 value
75     );
76 }
77 
78 abstract contract Ownable is Context {
79     address private _owner;
80 
81     event OwnershipTransferred(
82         address indexed previousOwner,
83         address indexed newOwner
84     );
85 
86     /**
87      * @dev Initializes the contract setting the deployer as the initial owner.
88      */
89     constructor() {
90         _setOwner(_msgSender());
91     }
92 
93     /**
94      * @dev Returns the address of the current owner.
95      */
96     function owner() public view virtual returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if called by any _account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(owner() == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         _setOwner(address(0));
110     }
111 
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(
114             newOwner != address(0),
115             "Ownable: new owner is the zero address"
116         );
117         _setOwner(newOwner);
118     }
119 
120     function _setOwner(address newOwner) private {
121         address oldOwner = _owner;
122         _owner = newOwner;
123         emit OwnershipTransferred(oldOwner, newOwner);
124     }
125 }
126 
127 library SafeMath {
128 
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return div(a, b, "SafeMath: division by zero");
160     }
161 
162     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b > 0, errorMessage);
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167         return c;
168     }
169 
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return mod(a, b, "SafeMath: modulo by zero");
172     }
173 
174     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b != 0, errorMessage);
176         return a % b;
177     }
178 }
179 
180 interface IDexSwapFactory {
181     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
182     function getPair(address tokenA, address tokenB) external view returns (address pair);
183     function createPair(address tokenA, address tokenB) external returns (address pair);
184 }
185 
186 interface IDexSwapPair {
187     event Approval(address indexed owner, address indexed spender, uint value);
188     event Transfer(address indexed from, address indexed to, uint value);
189 
190     function name() external pure returns (string memory);
191     function symbol() external pure returns (string memory);
192     function decimals() external pure returns (uint8);
193     function totalSupply() external view returns (uint);
194     function balanceOf(address owner) external view returns (uint);
195     function allowance(address owner, address spender) external view returns (uint);
196 
197     function approve(address spender, uint value) external returns (bool);
198     function transfer(address to, uint value) external returns (bool);
199     function transferFrom(address from, address to, uint value) external returns (bool);
200 
201     function DOMAIN_SEPARATOR() external view returns (bytes32);
202     function PERMIT_TYPEHASH() external pure returns (bytes32);
203     function nonces(address owner) external view returns (uint);
204 
205     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
206     
207     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
208     event Swap(
209         address indexed sender,
210         uint amount0In,
211         uint amount1In,
212         uint amount0Out,
213         uint amount1Out,
214         address indexed to
215     );
216     event Sync(uint112 reserve0, uint112 reserve1);
217 
218     function MINIMUM_LIQUIDITY() external pure returns (uint);
219     function factory() external view returns (address);
220     function token0() external view returns (address);
221     function token1() external view returns (address);
222     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
223     function price0CumulativeLast() external view returns (uint);
224     function price1CumulativeLast() external view returns (uint);
225     function kLast() external view returns (uint);
226 
227     function burn(address to) external returns (uint amount0, uint amount1);
228     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
229     function skim(address to) external;
230     function sync() external;
231 
232     function initialize(address, address) external;
233 }
234 
235 interface IDexSwapRouter {
236     function factory() external pure returns (address);
237     function WETH() external pure returns (address);
238     function addLiquidityETH(
239         address token,
240         uint amountTokenDesired,
241         uint amountTokenMin,
242         uint amountETHMin,
243         address to,
244         uint deadline
245     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
246     function swapExactTokensForETHSupportingFeeOnTransferTokens(
247         uint amountIn,
248         uint amountOutMin,
249         address[] calldata path,
250         address to,
251         uint deadline
252     ) external;
253 
254 }
255 
256 contract LARP is Context, IERC20, Ownable {
257 
258     using SafeMath for uint256;
259 
260     string private _name = "LARP";
261     string private _symbol = "LARP";
262     uint8 private _decimals = 8; 
263 
264     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
265     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
266 
267     uint _buyTax = 1;     
268     uint _sellTax = 1;     
269 
270     address public developmentWallet = address(0xA7014eE29D32A46cB9a5a184B7dbfB1e75526bEA);
271 
272     uint256 feedenominator = 100;
273 
274     mapping (address => uint256) _balances;
275     mapping (address => mapping (address => uint256)) private _allowances;
276 
277     mapping (address => bool) public isExcludedFromFee;
278     mapping (address => bool) public isMarketPair;
279     mapping (address => bool) public isWalletLimitExempt;
280     mapping (address => bool) public isTxLimitExempt;
281 
282     uint256 private _totalSupply = 1_000_000_000 * 10**_decimals;
283 
284     uint256 public _maxTxAmount =  _totalSupply.mul(2).div(100);     // 2%
285     uint256 public _walletMax = _totalSupply.mul(2).div(100);        // 2%
286 
287     uint256 public swapThreshold = 500_000 * 10**_decimals;
288 
289     bool public swapEnabled = true;
290     bool public swapbylimit = false;
291     bool public EnableTxLimit = true;
292     bool public checkWalletLimit = true;
293 
294     IDexSwapRouter public dexRouter;
295     address public dexPair;
296 
297     bool inSwap;
298 
299     modifier swapping() {
300         inSwap = true;
301         _;
302         inSwap = false;
303     }
304     
305     event SwapTokensForETH(
306         uint256 amountIn,
307         address[] path
308     );
309 
310     constructor() {
311 
312         IDexSwapRouter _dexRouter = IDexSwapRouter(
313             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
314         );
315 
316         dexPair = IDexSwapFactory(_dexRouter.factory())
317             .createPair(address(this), _dexRouter.WETH());
318 
319         dexRouter = _dexRouter;
320         
321         isExcludedFromFee[address(this)] = true;
322         isExcludedFromFee[msg.sender] = true;
323         isExcludedFromFee[address(dexRouter)] = true;
324 
325         isWalletLimitExempt[msg.sender] = true;
326         isWalletLimitExempt[address(dexRouter)] = true;
327         isWalletLimitExempt[address(this)] = true;
328         isWalletLimitExempt[deadAddress] = true;
329         isWalletLimitExempt[zeroAddress] = true;
330         
331         isTxLimitExempt[deadAddress] = true;
332         isTxLimitExempt[zeroAddress] = true;
333         isTxLimitExempt[msg.sender] = true;
334         isTxLimitExempt[address(this)] = true;
335         isTxLimitExempt[address(dexRouter)] = true;
336 
337         isMarketPair[address(dexPair)] = true;
338         isWalletLimitExempt[address(dexPair)] = true;
339 
340         _allowances[address(this)][address(dexPair)] = ~uint256(0);
341         _allowances[address(this)][address(dexRouter)] = ~uint256(0);
342 
343         _balances[msg.sender] = _totalSupply;
344         emit Transfer(address(0), msg.sender, _totalSupply);
345     }
346 
347     function name() public view returns (string memory) {
348         return _name;
349     }
350 
351     function symbol() public view returns (string memory) {
352         return _symbol;
353     }
354 
355     function decimals() public view returns (uint8) {
356         return _decimals;
357     }
358 
359     function totalSupply() public view override returns (uint256) {
360         return _totalSupply;
361     }
362 
363     function balanceOf(address account) public view override returns (uint256) {
364        return _balances[account];     
365     }
366 
367     function allowance(address owner, address spender) public view override returns (uint256) {
368         return _allowances[owner][spender];
369     }
370     
371     function getCirculatingSupply() public view returns (uint256) {
372         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
373     }
374 
375     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
376         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
377         return true;
378     }
379 
380     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
381         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
382         return true;
383     }
384 
385     function approve(address spender, uint256 amount) public override returns (bool) {
386         _approve(_msgSender(), spender, amount);
387         return true;
388     }
389 
390     function _approve(address owner, address spender, uint256 amount) private {
391         require(owner != address(0), "ERC20: approve from the zero address");
392         require(spender != address(0), "ERC20: approve to the zero address");
393 
394         _allowances[owner][spender] = amount;
395         emit Approval(owner, spender, amount);
396     }
397 
398      //to recieve ETH from Router when swaping
399     receive() external payable {}
400 
401     function transfer(address recipient, uint256 amount) public override returns (bool) {
402         _transfer(_msgSender(), recipient, amount);
403         return true;
404     }
405 
406     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
407         _transfer(sender, recipient, amount);
408         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: Exceeds allowance"));
409         return true;
410     }
411 
412     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
413 
414         require(sender != address(0));
415         require(recipient != address(0));
416         require(amount > 0);
417     
418         if (inSwap) {
419             return _basicTransfer(sender, recipient, amount);
420         }
421         else {
422 
423             uint256 contractTokenBalance = balanceOf(address(this));
424             bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;
425 
426             if (
427                 overMinimumTokenBalance && 
428                 !inSwap && 
429                 !isMarketPair[sender] && 
430                 swapEnabled &&
431                 !isExcludedFromFee[sender] &&
432                 !isExcludedFromFee[recipient]
433                 ) {
434                 swapBack(contractTokenBalance);
435             }
436 
437             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
438                 require(amount <= _maxTxAmount, "Exceeds maxTxAmount");
439             } 
440             
441             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
442 
443             uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
444 
445             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
446                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Exceeds Wallet");
447             }
448 
449             _balances[recipient] = _balances[recipient].add(finalAmount);
450 
451             emit Transfer(sender, recipient, finalAmount);
452             return true;
453 
454         }
455 
456     }
457 
458     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
459         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
460         _balances[recipient] = _balances[recipient].add(amount);
461         emit Transfer(sender, recipient, amount);
462         return true;
463     }
464     
465     function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
466         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
467             return true;
468         }
469         else if (isMarketPair[sender] || isMarketPair[recipient]) {
470             return false;
471         }
472         else {
473             return false;
474         }
475     }
476 
477     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
478         
479         uint feeAmount;
480 
481         unchecked {
482 
483             if(isMarketPair[sender]) { 
484                 feeAmount = amount.mul(_buyTax).div(feedenominator);
485             } 
486             else if(isMarketPair[recipient]) { 
487                 feeAmount = amount.mul(_sellTax).div(feedenominator);
488             }
489 
490             if(feeAmount > 0) {
491                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
492                 emit Transfer(sender, address(this), feeAmount);
493             }
494 
495             return amount.sub(feeAmount);
496         }
497         
498     }
499 
500     function swapBack(uint contractBalance) internal swapping {
501 
502         if(swapbylimit) contractBalance = swapThreshold;
503 
504         uint256 initialBalance = address(this).balance;
505         swapTokensForEth(contractBalance);
506         uint256 amountReceived = address(this).balance.sub(initialBalance);
507 
508         (bool os,) = payable(developmentWallet).call{value: amountReceived}("");
509         if(os) {}
510     }
511 
512     function swapTokensForEth(uint256 tokenAmount) private {
513         // generate the uniswap pair path of token -> weth
514         address[] memory path = new address[](2);
515         path[0] = address(this);
516         path[1] = dexRouter.WETH();
517 
518         _approve(address(this), address(dexRouter), tokenAmount);
519 
520         // make the swap
521         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
522             tokenAmount,
523             0, // accept any amount of ETH
524             path,
525             address(this), // The contract
526             block.timestamp
527         );
528         
529         emit SwapTokensForETH(tokenAmount, path);
530     }
531 
532     function rescueFunds() external onlyOwner { 
533         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
534         require(os,"Transaction Failed!!");
535     }
536 
537     function rescueTokens(address _token,address recipient,uint _amount) external onlyOwner {
538         (bool success, ) = address(_token).call(abi.encodeWithSignature('transfer(address,uint256)',  recipient, _amount));
539         require(success, 'Token payment failed');
540     }
541 
542     function enableTxLimit(bool _status) external onlyOwner {
543         EnableTxLimit = _status;
544     }
545 
546     function enableWalletLimit(bool _status) external onlyOwner {
547         checkWalletLimit = _status;
548     }
549 
550     function excludeFromFee(address _adr,bool _status) external onlyOwner {
551         isExcludedFromFee[_adr] = _status;
552     }
553 
554     function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
555         isWalletLimitExempt[_adr] = _status;
556     }
557 
558     function excludeTxLimit(address _adr,bool _status) external onlyOwner {
559         isTxLimitExempt[_adr] = _status;
560     }
561 
562     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
563         _walletMax = newLimit;
564     }
565 
566     function setTxLimit(uint256 newLimit) external onlyOwner() {
567         _maxTxAmount = newLimit;
568     }
569 
570     function setMarketPair(address _pair, bool _status) external onlyOwner {
571         isMarketPair[_pair] = _status;
572         if(_status) {
573             isWalletLimitExempt[_pair] = _status;
574         }
575     }
576 
577     function setDevelopmentWallet(address _addr) external onlyOwner {
578         developmentWallet = _addr;
579     }
580 
581     function setFee(uint _buy, uint _sell) external onlyOwner {
582         _buyTax = _buy;
583         _sellTax = _sell;
584     }
585     
586    
587     function setSwapBackSettings(uint _threshold, bool _enabled, bool _limited)
588         external
589         onlyOwner
590     {
591         swapEnabled = _enabled;
592         swapbylimit = _limited;
593         swapThreshold = _threshold;
594     }
595 
596     function setManualRouter(address _router) external onlyOwner {
597         dexRouter = IDexSwapRouter(_router);
598     }
599 
600     function setManualPair(address _pair) external onlyOwner {
601         dexPair = _pair;
602     }
603 
604 
605 }