1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.7.0 <0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     address private _previousOwner;
62     event OwnershipTransferred(
63         address indexed previousOwner,
64         address indexed newOwner
65     );
66 
67     constructor() {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 
93 }
94 
95 interface IUniswapV2Pair {
96     event Approval(address indexed owner, address indexed spender, uint value);
97     event Transfer(address indexed from, address indexed to, uint value);
98 
99     function name() external pure returns (string memory);
100     function symbol() external pure returns (string memory);
101     function decimals() external pure returns (uint8);
102     function totalSupply() external view returns (uint);
103     function balanceOf(address owner) external view returns (uint);
104     function allowance(address owner, address spender) external view returns (uint);
105 
106     function approve(address spender, uint value) external returns (bool);
107     function transfer(address to, uint value) external returns (bool);
108     function transferFrom(address from, address to, uint value) external returns (bool);
109 
110     function DOMAIN_SEPARATOR() external view returns (bytes32);
111     function PERMIT_TYPEHASH() external pure returns (bytes32);
112     function nonces(address owner) external view returns (uint);
113 
114     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
115 
116     event Mint(address indexed sender, uint amount0, uint amount1);
117     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
118     event Swap(
119         address indexed sender,
120         uint amount0In,
121         uint amount1In,
122         uint amount0Out,
123         uint amount1Out,
124         address indexed to
125     );
126     event Sync(uint112 reserve0, uint112 reserve1);
127 
128     function MINIMUM_LIQUIDITY() external pure returns (uint);
129     function factory() external view returns (address);
130     function token0() external view returns (address);
131     function token1() external view returns (address);
132     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
133     function price0CumulativeLast() external view returns (uint);
134     function price1CumulativeLast() external view returns (uint);
135     function kLast() external view returns (uint);
136 
137     function mint(address to) external returns (uint liquidity);
138     function burn(address to) external returns (uint amount0, uint amount1);
139     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
140     function skim(address to) external;
141     function sync() external;
142 
143     function initialize(address, address) external;
144 }
145 
146 interface IUniswapV2Factory {
147     function createPair(address tokenA, address tokenB) external returns (address pair);
148 }
149 
150 interface IUniswapV2Router02 {
151     function swapExactTokensForETHSupportingFeeOnTransferTokens(
152         uint256 amountIn,
153         uint256 amountOutMin,
154         address[] calldata path,
155         address to,
156         uint256 deadline
157     ) external;
158     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
159         uint amountIn,
160         uint amountOutMin,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external;
165     function factory() external pure returns (address);
166     function WETH() external pure returns (address);
167     function addLiquidityETH(
168         address token,
169         uint256 amountTokenDesired,
170         uint256 amountTokenMin,
171         uint256 amountETHMin,
172         address to,
173         uint256 deadline
174     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
175     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
176     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
177     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
178     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
179     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
180 }
181 
182 contract Toshi is Context, IERC20, Ownable {
183     using SafeMath for uint256;
184     string private constant _name = "Ghost Of Ryoshi";
185     string private constant _symbol = "TOSHI";
186     uint8 private constant _decimals = 9;
187 
188     mapping(address => uint256) private _balances;
189     mapping(address => uint256) private cooldown;
190     mapping(address => bool) private bots;
191     mapping (address => uint256) private _lastTX;
192     mapping(address => mapping(address => uint256)) private _allowances;
193     mapping(address => bool) private _isExcludedFromFee;
194     
195     uint256 private constant _tTotal = 100 * 1e5 * 1e9;
196     uint256 public _maxWalletAmount = 1 * 1e5 * 1e9;
197 
198     // fees
199     uint256 public _liquidityFeeOnBuy = 0; 
200     uint256 public _marketingFeeOnBuy = 5; 
201 
202     uint256 public _liquidityFeeOnSell = 0; 
203     uint256 public _marketingFeeOnSell = 25; 
204     
205     uint256 private _previousLiquidityFee = _liquidityFee;
206     uint256 private _previousMarketingFee = _marketingFee;
207     uint256 private _liquidityFee;
208     uint256 private _marketingFee;
209     
210     struct FeeBreakdown {
211         uint256 tLiquidity;
212         uint256 tMarketing;
213         uint256 tAmount;
214     }
215 
216     address payable private dev = payable(0xd8553b5C4AB04214A6288C6FBaBe08332A487Db6);
217     address payable private mktg = payable(0xd8553b5C4AB04214A6288C6FBaBe08332A487Db6);
218 
219     IUniswapV2Router02 private uniswapV2Router;
220     address public uniswapV2Pair;
221 
222     uint256 public swapAmount;
223     uint256 private _firstBlock;
224 
225     bool public botProtection = false;
226     bool private inSwap = false;
227     bool public cooldownEnabled = false;
228     bool public swapEnabled = false;
229 
230     event FeesUpdated(uint256 _marketingFee, uint256 _liquidityFee);
231 
232     modifier lockTheSwap {
233         inSwap = true;
234         _;
235         inSwap = false;
236     }
237 
238     constructor() {
239         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
240         uniswapV2Router = _uniswapV2Router;
241         _approve(address(this), address(uniswapV2Router), _tTotal);
242         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
243         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
244         swapAmount = 3 * 1e4 * 1e9;
245         
246         _balances[_msgSender()] = _tTotal;
247         _isExcludedFromFee[owner()] = true;
248         _isExcludedFromFee[dev] = true;
249         _isExcludedFromFee[mktg] = true;
250         _isExcludedFromFee[address(this)] = true;
251         emit Transfer(address(0), _msgSender(), _tTotal);
252     }
253 
254     function name() public pure returns (string memory) {
255         return _name;
256     }
257 
258     function symbol() public pure returns (string memory) {
259         return _symbol;
260     }
261 
262     function decimals() public pure returns (uint8) {
263         return _decimals;
264     }
265 
266     function totalSupply() external pure override returns (uint256) {
267         return _tTotal;
268     }
269 
270     function balanceOf(address account) public view override returns (uint256) {
271         return _balances[account];
272     }
273     
274     function transfer(address recipient, uint256 amount) external override returns (bool) {
275         _transfer(_msgSender(), recipient, amount);
276         return true;
277     }
278 
279     function allowance(address owner, address spender) external view override returns (uint256) {
280         return _allowances[owner][spender];
281     }
282 
283     function approve(address spender, uint256 amount) external override returns (bool) {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287 
288     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
289         _transfer(sender, recipient, amount);
290         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
291         return true;
292     }
293 
294     function removeAllFee() private {
295         if (_marketingFee == 0 && _liquidityFee == 0) return;
296         _previousMarketingFee = _marketingFee;
297         _previousLiquidityFee = _liquidityFee;
298 
299         _marketingFee = 0;
300         _liquidityFee = 0;
301     }
302 
303     function setCooldownEnabled(bool onoff) external onlyOwner() {
304         cooldownEnabled = onoff;
305     }
306     
307     function restoreAllFee() private {
308         
309         _liquidityFee = _previousLiquidityFee;
310         _marketingFee = _previousMarketingFee;
311     }
312 
313     function toggleBotProtection(bool onoff) external onlyOwner() {
314         botProtection = onoff;
315     }
316 
317     function _approve(address owner, address spender, uint256 amount) private {
318         require(owner != address(0), "ERC20: approve from the zero address");
319         require(spender != address(0), "ERC20: approve to the zero address");
320         _allowances[owner][spender] = amount;
321         emit Approval(owner, spender, amount);
322     }
323     
324     function _transfer(address from, address to, uint256 amount) private {
325 
326         require(from != address(0), "ERC20: transfer from the zero address");
327         require(to != address(0), "ERC20: transfer to the zero address");
328         require(amount > 0, "Transfer amount must be greater than zero");
329 
330         if(!swapEnabled){
331             require(from == dev); // only owner allowed to trade or add liquidity
332         } 
333 
334         if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
335             if (block.number <= (_firstBlock.add(4))) {
336                 bots[to] = true;
337             } 
338         }
339         bool takeFee = true;
340         if (from != owner() && to != owner()) {
341             if (cooldownEnabled) {
342                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
343                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair, "ERR: Uniswap only");
344                 }
345             
346                 if( to != owner() && to != address(this) && to != address(uniswapV2Router) && to != uniswapV2Pair) {
347                     require(_lastTX[tx.origin] <= (block.timestamp + 5 minutes), "Cooldown in effect");
348                     _lastTX[tx.origin] = block.timestamp;
349                 }
350             }
351                     
352         }
353 
354         if (from != owner() && to != owner() && from != address(this) && to != address(this)) {
355 
356             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
357                 require(balanceOf(to).add(amount) <= _maxWalletAmount, "wallet balance after transfer must be less than max wallet amount");
358             }
359 
360             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
361                 _liquidityFee = _liquidityFeeOnBuy;
362                 _marketingFee = _marketingFeeOnBuy;
363             }
364                 
365             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
366                 if (botProtection) {
367                 require(!bots[to] && !bots[from]);
368                 }
369                 _liquidityFee = _liquidityFeeOnSell;
370                 _marketingFee = _marketingFeeOnSell;
371             }
372             
373             if (!inSwap && from != uniswapV2Pair) {
374 
375                 uint256 contractTokenBalance = balanceOf(address(this));
376 
377                 if (contractTokenBalance > swapAmount) {
378                     swapAndLiquify(contractTokenBalance);
379                 }
380 
381                 uint256 contractETHBalance = address(this).balance;
382                 if (contractETHBalance > 0) {
383                     sendETHToFee(address(this).balance);
384                 }
385                     
386             }
387         }
388 
389         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
390             takeFee = false;
391         }
392         
393         _tokenTransfer(from, to, amount, takeFee);
394         restoreAllFee();
395     }
396 
397     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
398         address[] memory path = new address[](2);
399         path[0] = address(this);
400         path[1] = uniswapV2Router.WETH();
401         _approve(address(this), address(uniswapV2Router), tokenAmount);
402         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
403     }
404     
405     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
406         _approve(address(this), address(uniswapV2Router), tokenAmount);
407 
408         // add the liquidity
409         uniswapV2Router.addLiquidityETH{value: ethAmount}(
410               address(this),
411               tokenAmount,
412               0, // slippage is unavoidable
413               0, // slippage is unavoidable
414               dev,
415               block.timestamp
416           );
417     }
418   
419     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
420         uint256 autoLPamount = _liquidityFee.mul(contractTokenBalance).div(_marketingFee.add(_liquidityFee));
421 
422         // split the contract balance into halves
423         uint256 half =  autoLPamount.div(2);
424         uint256 otherHalf = contractTokenBalance.sub(half);
425 
426         // capture the contract's current ETH balance.
427         // this is so that we can capture exactly the amount of ETH that the
428         // swap creates, and not make the liquidity event include any ETH that
429         // has been manually sent to the contract
430         uint256 initialBalance = address(this).balance;
431 
432         // swap tokens for ETH
433         swapTokensForEth(otherHalf); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
434 
435         // how much ETH did we just swap into?
436         uint256 newBalance = ((address(this).balance.sub(initialBalance)).mul(half)).div(otherHalf);
437 
438         addLiquidity(half, newBalance);
439     }
440 
441     function sendETHToFee(uint256 amount) private {
442         uint256 tfrAmt = amount.div(3);
443         mktg.transfer(tfrAmt);
444         dev.transfer(amount.sub(tfrAmt));
445 
446     }
447 
448     function delBot(address notbot) public onlyOwner {
449         bots[notbot] = false;
450     }
451 
452     function manualSwap() external {
453         require(_msgSender() == dev);
454         uint256 contractBalance = balanceOf(address(this));
455         if (contractBalance > 0) {
456             swapTokensForEth(contractBalance);
457         }
458     }
459 
460     function manualSwapandLiquify() public onlyOwner() {
461         uint contractBalance = balanceOf(address(this));
462         swapAndLiquify(contractBalance);
463     }
464 
465     function setTaxRate(uint256 liqFee, uint256 mktgFee, uint256 buyliqFee, uint256 buymktgFee) public onlyOwner() {
466         _liquidityFeeOnSell = liqFee;
467         _marketingFeeOnSell = mktgFee;
468         _liquidityFeeOnBuy = buyliqFee;
469         _marketingFeeOnBuy = buymktgFee;
470     }
471 
472     function manualSend() external {
473         require(_msgSender() == dev);
474         uint256 contractETHBalance = address(this).balance;
475         if (contractETHBalance > 0) {
476             sendETHToFee(contractETHBalance);
477         }
478     }
479 
480     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
481         if (!takeFee) { 
482                 removeAllFee();
483         }
484         _transferStandard(sender, recipient, amount);
485         restoreAllFee();
486     }
487 
488     function _transferStandard(address sender, address recipient, uint256 amount) private {
489         FeeBreakdown memory fees;
490         fees.tMarketing = amount.mul(_marketingFee).div(100);
491         fees.tLiquidity = amount.mul(_liquidityFee).div(100);
492         
493         fees.tAmount = amount.sub(fees.tMarketing).sub(fees.tLiquidity);
494         
495         _balances[sender] = _balances[sender].sub(amount);
496         _balances[recipient] = _balances[recipient].add(fees.tAmount);
497         _balances[address(this)] = _balances[address(this)].add(fees.tMarketing.add(fees.tLiquidity));
498         
499         emit Transfer(sender, recipient, fees.tAmount);
500     }
501     
502     receive() external payable {}
503 
504     function setMaxWalletAmount(uint256 maxWalletAmount) external {
505         require(_msgSender() == dev);
506         require(maxWalletAmount > _tTotal.div(200), "Amount must be greater than 0.5% of supply");
507         require(maxWalletAmount <= _tTotal, "Amount must be less than or equal to totalSupply");
508         _maxWalletAmount = maxWalletAmount;
509     }
510 
511     function setMktgaddress(address payable walletAddress) external {
512         require(_msgSender() == dev);
513         mktg = walletAddress;
514     }
515 
516     function setSwapAmount(uint256 _swapAmount) external {
517         require(_msgSender() == dev);
518         swapAmount = _swapAmount;
519     }
520 
521     function blacklistmany(address[] memory bots_) external {
522         for (uint i = 0; i < bots_.length; i++) {
523           bots[bots_[i]] = true;
524         }
525     }
526 
527     function removeFromBlacklist (address _address) external {
528         require(_msgSender() == dev);
529         bots[_address] = false;
530     }
531     
532     function getIsBlacklistedStatus (address _address) external view returns (bool) {
533         return bots[_address];
534     }
535 
536     function openTrading() external onlyOwner() {
537         require(!swapEnabled, "trading is already open");
538         _firstBlock = block.number;
539         cooldownEnabled = true;
540         swapEnabled = true;
541     }
542 
543     function claimETH (address walletaddress) external {
544         require(_msgSender() == dev);
545         payable(walletaddress).transfer(address(this).balance);
546     }
547 
548     function claimAltTokens(IERC20 tokenAddress, address walletaddress) external {
549         require(_msgSender() == dev);
550         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
551     }
552 
553 
554 }