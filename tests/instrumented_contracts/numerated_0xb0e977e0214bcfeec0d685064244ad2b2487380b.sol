1 // SPDX-License-Identifier:MIT
2 pragma solidity ^0.8.10;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address _account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount)
18         external
19         returns (bool);
20     function allowance(address owner, address spender)
21         external
22         view
23         returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(
42         address indexed previousOwner,
43         address indexed newOwner
44     );
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _setOwner(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any _account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     function renounceOwnership() public virtual onlyOwner {
69         _setOwner(address(0));
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(
74             newOwner != address(0),
75             "Ownable: new owner is the zero address"
76         );
77         _setOwner(newOwner);
78     }
79 
80     function _setOwner(address newOwner) private {
81         address oldOwner = _owner;
82         _owner = newOwner;
83         emit OwnershipTransferred(oldOwner, newOwner);
84     }
85 }
86 
87 library SafeMath {
88 
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92 
93         return c;
94     }
95 
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103 
104         return c;
105     }
106 
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         return mod(a, b, "SafeMath: modulo by zero");
132     }
133 
134     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b != 0, errorMessage);
136         return a % b;
137     }
138 }
139 
140 interface IShibaSwapFactory {
141     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
142     function createPair(address tokenA, address tokenB) external returns (address pair);
143 }
144 
145 interface IShibaSwapPair {
146     event Approval(address indexed owner, address indexed spender, uint value);
147     event Transfer(address indexed from, address indexed to, uint value);
148 
149     function name() external pure returns (string memory);
150     function symbol() external pure returns (string memory);
151     function decimals() external pure returns (uint8);
152     function totalSupply() external view returns (uint);
153     function balanceOf(address owner) external view returns (uint);
154     function allowance(address owner, address spender) external view returns (uint);
155 
156     function approve(address spender, uint value) external returns (bool);
157     function transfer(address to, uint value) external returns (bool);
158     function transferFrom(address from, address to, uint value) external returns (bool);
159 
160     function DOMAIN_SEPARATOR() external view returns (bytes32);
161     function PERMIT_TYPEHASH() external pure returns (bytes32);
162     function nonces(address owner) external view returns (uint);
163 
164     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
165     
166     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
167     event Swap(
168         address indexed sender,
169         uint amount0In,
170         uint amount1In,
171         uint amount0Out,
172         uint amount1Out,
173         address indexed to
174     );
175     event Sync(uint112 reserve0, uint112 reserve1);
176 
177     function MINIMUM_LIQUIDITY() external pure returns (uint);
178     function factory() external view returns (address);
179     function token0() external view returns (address);
180     function token1() external view returns (address);
181     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
182     function price0CumulativeLast() external view returns (uint);
183     function price1CumulativeLast() external view returns (uint);
184     function kLast() external view returns (uint);
185 
186     function burn(address to) external returns (uint amount0, uint amount1);
187     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
188     function skim(address to) external;
189     function sync() external;
190 
191     function initialize(address, address) external;
192 }
193 
194 interface IShibaSwapRouter {
195     function factory() external pure returns (address);
196     function WETH() external pure returns (address);
197 }
198 
199 contract COLLARSWAP is Context, IERC20, Ownable {
200 
201     using SafeMath for uint256;
202 
203     string private _name = "COLLARSWAP"; // token name
204     string private _symbol = "COLLAR"; // token ticker
205     uint8 private _decimals = 18; // token decimals
206 
207     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
208     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
209 
210     address public FundsRescueWallet;
211     
212     mapping (address => uint256) _balances;
213     mapping (address => mapping (address => uint256)) private _allowances;
214 
215     mapping (address => bool) public isExcludedFromFee;
216     mapping (address => bool) public isMarketPair;
217     mapping (address => bool) public isWalletLimitExempt;
218     mapping (address => bool) public isTxLimitExempt;
219     mapping (address => bool) public isBot;
220 
221     uint256 private _totalSupply = 1_000_000_000_000 * 10**_decimals;
222 
223     uint256 denominator = 100;
224 
225     uint256 public _maxTxAmount =  _totalSupply.mul(1).div(denominator);     //1%
226     uint256 public _walletMax = _totalSupply.mul(1).div(denominator);    //1%
227 
228     bool public transferFeeEnabled = true;
229     uint256 public initalTransferFee = 99; // 99% max fees limit on inital transfer
230     uint256 public launchedAt; 
231     uint256 public snipingTime = 60 seconds; //1 min snipping time
232     bool public trading; 
233 
234     bool public EnableTxLimit = true;
235     bool public checkWalletLimit = true;
236 
237     mapping (address => bool) public isCollarWL;
238     modifier onlyGuard() {
239         require(msg.sender == FundsRescueWallet,"Error: Guarded!");
240         _;
241     }
242 
243     IShibaSwapRouter public shibaRouter;
244     address public shibaPair;
245 
246     constructor() {
247 
248         // //uniswap Swap
249         // IShibaSwapRouter _dexRouter = IShibaSwapRouter(
250         //     0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
251         // );
252 
253         //Shiba Swap
254         IShibaSwapRouter _dexRouter = IShibaSwapRouter(
255             0x03f7724180AA6b939894B5Ca4314783B0b36b329
256         );
257 
258         shibaPair = IShibaSwapFactory(_dexRouter.factory()).createPair(
259             address(this),
260             _dexRouter.WETH()
261         );
262 
263         shibaRouter = _dexRouter;
264 
265         _allowances[address(this)][address(shibaRouter)] = ~uint256(0);
266 
267         FundsRescueWallet = msg.sender;
268 
269         isExcludedFromFee[address(this)] = true;
270         isExcludedFromFee[msg.sender] = true;
271         isExcludedFromFee[address(shibaRouter)] = true;
272 
273         isCollarWL[address(msg.sender)] = true;
274         isCollarWL[address(this)] = true;
275         isCollarWL[address(shibaRouter)] = true;
276 
277         isWalletLimitExempt[msg.sender] = true;
278         isWalletLimitExempt[address(shibaPair)] = true;
279         isWalletLimitExempt[address(shibaRouter)] = true;
280         isWalletLimitExempt[address(this)] = true;
281         
282         isTxLimitExempt[msg.sender] = true;
283         isTxLimitExempt[address(this)] = true;
284         isTxLimitExempt[address(shibaRouter)] = true;
285 
286         isMarketPair[address(shibaPair)] = true;
287 
288         _balances[msg.sender] = _totalSupply;
289         emit Transfer(address(0), msg.sender, _totalSupply);
290     }
291 
292     function name() public view returns (string memory) {
293         return _name;
294     }
295 
296     function symbol() public view returns (string memory) {
297         return _symbol;
298     }
299 
300     function decimals() public view returns (uint8) {
301         return _decimals;
302     }
303 
304     function totalSupply() public view override returns (uint256) {
305         return _totalSupply;
306     }
307 
308     function balanceOf(address account) public view override returns (uint256) {
309        return _balances[account];     
310     }
311 
312     function allowance(address owner, address spender) public view override returns (uint256) {
313         return _allowances[owner][spender];
314     }
315     
316     function getCirculatingSupply() public view returns (uint256) {
317         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
318     }
319 
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
322         return true;
323     }
324 
325     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
326         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
327         return true;
328     }
329 
330     function approve(address spender, uint256 amount) public override returns (bool) {
331         _approve(_msgSender(), spender, amount);
332         return true;
333     }
334 
335     function _approve(address owner, address spender, uint256 amount) private {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338 
339         _allowances[owner][spender] = amount;
340         emit Approval(owner, spender, amount);
341     }
342 
343      //to recieve ETH from uniswapV2Router when swaping
344     receive() external payable {}
345 
346     function transfer(address recipient, uint256 amount) public override returns (bool) {
347         _transfer(_msgSender(), recipient, amount);
348         return true;
349     }
350 
351     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
352         _transfer(sender, recipient, amount);
353         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
354         return true;
355     }
356 
357     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
358 
359         require(sender != address(0), "ERC20: transfer from the zero address");
360         require(recipient != address(0), "ERC20: transfer to the zero address");
361         require(amount > 0, "Transfer amount must be greater than zero");
362         
363         require(!isBot[sender], "ERC20: Bot detected");
364         require(!isBot[msg.sender], "ERC20: Bot detected");
365         require(!isBot[tx.origin], "ERC20: Bot detected");
366 
367         if (!isCollarWL[sender] && !isCollarWL[recipient]) {
368             require(trading, "ERC20: trading not enable yet");
369 
370             if (
371                 block.timestamp < launchedAt + snipingTime &&
372                 sender != address(shibaRouter)
373             ) {
374                 if (shibaPair == sender) {
375                     isBot[recipient] = true;
376                 } else if (shibaPair == recipient) {
377                     isBot[sender] = true;
378                 }
379             }
380         }
381         
382         if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
383             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
384         } 
385         
386         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
387 
388         uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, amount);
389 
390         if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
391             require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Max Wallet Limit Exceeded!!");
392         }
393 
394         _balances[recipient] = _balances[recipient].add(finalAmount);
395 
396         emit Transfer(sender, recipient, finalAmount);
397         return true;
398 
399     }
400     
401     function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
402         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
403             return true;
404         }
405         else if (isMarketPair[sender] || isMarketPair[recipient]) {
406             return true;
407         }
408         else {
409             return false;
410         }
411     }
412 
413     function takeFee(address sender, uint256 amount) internal returns (uint256) {
414         
415         uint feeAmount;
416 
417         unchecked {
418 
419             if(transferFeeEnabled) {
420                 feeAmount = amount.mul(initalTransferFee).div(denominator);
421             }
422 
423             if(feeAmount > 0) {
424                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
425                 emit Transfer(sender, address(this), feeAmount);
426             }
427 
428             return amount.sub(feeAmount);
429         }
430         
431     }
432 
433     function startTrading() external onlyOwner {
434         require(!trading, "ERC20: Already Enabled");
435         trading = true;
436         launchedAt = block.timestamp;
437     }
438 
439     //To Rescue Stucked Balance
440     function rescueFunds() external onlyGuard { 
441         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
442         require(os,"Transaction Failed!!");
443     }
444 
445     //To Rescue Stucked Tokens
446     function rescueTokens(IERC20 adr,address recipient,uint amount) external onlyGuard {
447         adr.transfer(recipient,amount);
448     }
449 
450     function updateSetting(address[] calldata _adr, bool _status) external onlyOwner {
451         for(uint i = 0; i < _adr.length; i++){
452             isCollarWL[_adr[i]] = _status;
453         }
454     }
455 
456     function addOrRemoveBots(address[] calldata accounts, bool value)
457         external
458         onlyOwner
459     {
460         for (uint256 i = 0; i < accounts.length; i++) {
461             isBot[accounts[i]] = value;
462         }
463     }
464 
465     function disableTransferFee(bool _status) external onlyOwner {
466         transferFeeEnabled = _status;
467     }
468 
469     function enableTxLimit(bool _status) external onlyOwner {
470         EnableTxLimit = _status;
471     }
472 
473     function enableWalletLimit(bool _status) external onlyOwner {
474         checkWalletLimit = _status;
475     }
476 
477     function excludeFromFee(address _adr,bool _status) external onlyOwner {
478         isExcludedFromFee[_adr] = _status;
479     }
480 
481     function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
482         isWalletLimitExempt[_adr] = _status;
483     }
484 
485     function excludeTxLimit(address _adr,bool _status) external onlyOwner {
486         isTxLimitExempt[_adr] = _status;
487     }
488 
489     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
490         _walletMax = newLimit;
491     }
492 
493     function setTxLimit(uint256 newLimit) external onlyOwner() {
494         _maxTxAmount = newLimit;
495     }
496 
497     function setMarketPair(address _pair, bool _status) public onlyOwner {
498         isMarketPair[_pair] = _status;
499     }
500 
501     function setManualRouter(address _router) public onlyOwner {
502         shibaRouter = IShibaSwapRouter(_router);
503     }
504 
505     function setManualPair(address _pair) public onlyOwner {
506         shibaPair = _pair;
507     }
508 
509 
510 }