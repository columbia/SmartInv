1 pragma solidity ^0.8.17;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17 
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28 
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b <= a, errorMessage);
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46 
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return mod(a, b, "SafeMath: modulo by zero");
64     }
65 
66     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 abstract contract Context {
73     //function _msgSender() internal view virtual returns (address payable) {
74     function _msgSender() internal view virtual returns (address) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view virtual returns (bytes memory) {
79         this;
80         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
81         return msg.data;
82     }
83 }
84 
85 library Address {
86 
87     function isContract(address account) internal view returns (bool) {
88         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
89         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
90         // for accounts without code, i.e. `keccak256('')`
91         bytes32 codehash;
92         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
93         // solhint-disable-next-line no-inline-assembly
94         assembly {codehash := extcodehash(account)}
95         return (codehash != accountHash && codehash != 0x0);
96     }
97 
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100 
101         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
102         (bool success,) = recipient.call{value : amount}("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105 
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107         return functionCall(target, data, "Address: low-level call failed");
108     }
109 
110     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
111         return _functionCallWithValue(target, data, 0, errorMessage);
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 contract Ownable is Context {
148     address private _owner;
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     constructor () {
153         address msgSender = _msgSender();
154         _owner = msgSender;
155         emit OwnershipTransferred(address(0), msgSender);
156     }
157 
158     function owner() public view returns (address) {
159         return _owner;
160     }
161 
162     modifier onlyOwner() {
163         require(_owner == _msgSender(), "Ownable: caller is not the owner");
164         _;
165     }
166 
167     function renounceOwnership() public virtual onlyOwner {
168         emit OwnershipTransferred(_owner, address(0));
169         _owner = address(0);
170     }
171 
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         emit OwnershipTransferred(_owner, newOwner);
175         _owner = newOwner;
176     }
177 }
178 
179 
180 
181 interface IUniswapV2Pair {
182     event Approval(
183         address indexed owner,
184         address indexed spender,
185         uint256 value
186     );
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     function name() external pure returns (string memory);
190 
191     function symbol() external pure returns (string memory);
192 
193     function decimals() external pure returns (uint8);
194 
195     function totalSupply() external view returns (uint256);
196 
197     function balanceOf(address owner) external view returns (uint256);
198 
199     function allowance(address owner, address spender)
200         external
201         view
202         returns (uint256);
203 
204     function approve(address spender, uint256 value) external returns (bool);
205 
206     function transfer(address to, uint256 value) external returns (bool);
207 
208     function transferFrom(
209         address from,
210         address to,
211         uint256 value
212     ) external returns (bool);
213 
214     function DOMAIN_SEPARATOR() external view returns (bytes32);
215 
216     function PERMIT_TYPEHASH() external pure returns (bytes32);
217 
218     function nonces(address owner) external view returns (uint256);
219 
220     function permit(
221         address owner,
222         address spender,
223         uint256 value,
224         uint256 deadline,
225         uint8 v,
226         bytes32 r,
227         bytes32 s
228     ) external;
229 
230     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
231     event Burn(
232         address indexed sender,
233         uint256 amount0,
234         uint256 amount1,
235         address indexed to
236     );
237     event Swap(
238         address indexed sender,
239         uint256 amount0In,
240         uint256 amount1In,
241         uint256 amount0Out,
242         uint256 amount1Out,
243         address indexed to
244     );
245     event Sync(uint112 reserve0, uint112 reserve1);
246 
247     function MINIMUM_LIQUIDITY() external pure returns (uint256);
248 
249     function factory() external view returns (address);
250 
251     function token0() external view returns (address);
252 
253     function token1() external view returns (address);
254 
255     function getReserves()
256         external
257         view
258         returns (
259             uint112 reserve0,
260             uint112 reserve1,
261             uint32 blockTimestampLast
262         );
263 
264     function price0CumulativeLast() external view returns (uint256);
265 
266     function price1CumulativeLast() external view returns (uint256);
267 
268     function kLast() external view returns (uint256);
269 
270     function mint(address to) external returns (uint256 liquidity);
271 
272     function burn(address to)
273         external
274         returns (uint256 amount0, uint256 amount1);
275 
276     function swap(
277         uint256 amount0Out,
278         uint256 amount1Out,
279         address to,
280         bytes calldata data
281     ) external;
282 
283     function skim(address to) external;
284 
285     function sync() external;
286 
287     function initialize(address, address) external;
288 }
289 
290 interface IUniswapV2Factory {
291     function createPair(address tokenA, address tokenB) external returns (address pair);
292     function getPair(address token0, address token1) external view returns (address);
293 }
294 
295 interface IUniswapV2Router02 {
296     function factory() external pure returns (address);
297     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
298     function swapExactTokensForETHSupportingFeeOnTransferTokens(
299         uint amountIn,
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external;
305     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
306         uint amountIn,
307         uint amountOutMin,
308         address[] calldata path,
309         address to,
310         uint deadline
311     ) external;
312     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
313     external payable returns (uint[] memory amounts);
314     function addLiquidityETH(
315         address token,
316         uint amountTokenDesired,
317         uint amountTokenMin,
318         uint amountETHMin,
319         address to,
320         uint deadline
321     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
322     function removeLiquidity(
323         address tokenA,
324         address tokenB,
325         uint liquidity,
326         uint amountAMin,
327         uint amountBMin,
328         address to,
329         uint deadline
330     ) external returns (uint amountA, uint amountB);
331     function WETH() external pure returns (address);
332 }
333 
334 contract ETHFIRE is Context, IERC20, Ownable {
335     using SafeMath for uint256;
336     using Address for address;
337     modifier lockTheSwap {
338         inSwapAndLiquify = true;
339         _;
340         inSwapAndLiquify = false;
341     }
342     event TokensBurned(uint256, uint256);
343     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
344     address public marketPair = address(0);
345     IUniswapV2Pair private v2Pair;
346     address private feeOne = 0x82f1dDa2aaE8E086600da180FE6Fa87C423e0B87;
347     mapping(address => uint256) private _balances;
348     mapping(address => mapping(address => uint256)) private _allowances;
349     mapping(address => bool) private _isExcludedFromFee;
350     string private _name = "ETH FIRE";
351     string private _symbol = "EFIRE";
352     uint8 private _decimals = 18;
353     uint256 private _tTotal = 1e8 * 1e18;
354     uint256 public _maxWalletAmount = (_tTotal * 2) / 100;
355     bool inSwapAndLiquify;
356     uint256 public buyFee = 5;
357     uint256 public sellFee = 5;
358     address public deployer;
359     uint256 public ethPriceToSwap = 0.01 ether; 
360     bool public isBurnEnabled = true;
361     uint256 public burnFrequencynMinutes = 30;  
362     uint256 public burnRateInBasePoints = 100;  //100 = 1%
363     uint256 public tokensBurnedSinceLaunch = 0;
364     uint public nextLiquidityBurnTimeStamp;
365 
366     uint256 totalShare = 50;
367     uint256 feeShare = 30;
368     uint256 lpShare = 20;
369    
370     constructor () {
371         address tokenOwner = 0x6B72750Fdae81972A095b8600FE69683C1E19c74;
372          _balances[tokenOwner] = _tTotal;
373         _isExcludedFromFee[owner()] = true;
374         _isExcludedFromFee[msg.sender] = true;
375         _isExcludedFromFee[address(uniswapV2Router)] = true;
376         _isExcludedFromFee[address(this)] = true;
377         _isExcludedFromFee[tokenOwner] = true;
378         _isExcludedFromFee[feeOne] = true;
379 
380         deployer = tokenOwner;
381         transferOwnership(deployer);
382         emit Transfer(address(0), tokenOwner, _tTotal);
383     }
384 
385     function name() public view returns (string memory) {
386         return _name;
387     }
388 
389     function symbol() public view returns (string memory) {
390         return _symbol;
391     }
392 
393     function decimals() public view returns (uint8) {
394         return _decimals;
395     }
396 
397     function totalSupply() public view override returns (uint256) {
398         return _tTotal;
399     }
400 
401     function balanceOf(address account) public view override returns (uint256) {
402         return _balances[account];
403     }
404 
405     function transfer(address recipient, uint256 amount) public override returns (bool) {
406         _transfer(_msgSender(), recipient, amount);
407         return true;
408     }
409 
410     function allowance(address owner, address spender) public view override returns (uint256) {
411         return _allowances[owner][spender];
412     }
413 
414     function approve(address spender, uint256 amount) public override returns (bool) {
415         _approve(_msgSender(), spender, amount);
416         return true;
417     }
418 
419     function setShares(uint256 _feeShar, uint256 _lpShare) public onlyOwner{
420         lpShare = _lpShare;
421         feeShare = _feeShar;
422         totalShare = _lpShare + _feeShar;
423     }
424 
425     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
426         _transfer(sender, recipient, amount);
427         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
428         return true;
429     }
430 
431     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
432         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
433         return true;
434     }
435 
436     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
437         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
438         return true;
439     }
440 
441     function setTaxFees(uint256 buy, uint256 sell) external onlyOwner {
442         buyFee = buy;
443         sellFee = sell;
444     }
445 
446    function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
447         addRemoveFee(addresses, isExcludeFromFee);
448     }
449 
450    function setBurnSettings(uint256 frequencyInMinutes, uint256 burnBasePoints) external onlyOwner {
451         burnFrequencynMinutes = frequencyInMinutes;
452         burnRateInBasePoints = burnBasePoints;
453     }
454 
455     function burnTokensFromLiquidityPool() private lockTheSwap {
456         uint liquidity = balanceOf(marketPair);
457         uint tokenBurnAmount = liquidity.div(burnRateInBasePoints);
458         if(tokenBurnAmount > 0) {
459             //burn tokens from LP and update liquidity pool price
460             _burn(marketPair, tokenBurnAmount);
461             v2Pair.sync();
462             tokensBurnedSinceLaunch = tokensBurnedSinceLaunch.add(tokenBurnAmount);
463             nextLiquidityBurnTimeStamp = block.timestamp.add(burnFrequencynMinutes.mul(60));
464             emit TokensBurned(tokenBurnAmount, nextLiquidityBurnTimeStamp);
465         }
466     }
467 
468     function enableDisableBurnToken(bool _enabled) public onlyOwner {
469         isBurnEnabled = _enabled;
470     }
471 
472     function burnTokens() external {
473         require(block.timestamp >= nextLiquidityBurnTimeStamp, "Next burn time is not due yet, be patient");
474         require(isBurnEnabled, "Burning tokens is currently disabled");
475         burnTokensFromLiquidityPool();
476     }
477 
478     function addRemoveFee(address[] calldata addresses, bool flag) private {
479         for (uint256 i = 0; i < addresses.length; i++) {
480             address addr = addresses[i];
481             _isExcludedFromFee[addr] = flag;
482         }
483     }
484 
485     function _burn(address account, uint256 value) internal {
486         require(account != address(0), "ERC20: burn from the zero address");
487         _tTotal = _tTotal.sub(value);
488         _balances[account] = _balances[account].sub(value);
489         emit Transfer(account, address(0), value);
490     }
491     
492     function openTrading(address _pair) external onlyOwner() {
493         require(marketPair == address(0),"UniswapV2Pair has already been set");
494         _approve(address(this), address(uniswapV2Router), _tTotal);
495         marketPair = _pair; 
496         v2Pair = IUniswapV2Pair(marketPair);
497         nextLiquidityBurnTimeStamp = block.timestamp;
498     }
499 
500     function isExcludedFromFee(address account) public view returns (bool) {
501         return _isExcludedFromFee[account];
502     }
503 
504     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
505         _maxWalletAmount = maxWalletAmount;
506     }
507 
508     function _approve(address owner, address spender, uint256 amount) private {
509         require(owner != address(0), "ERC20: approve from the zero address");
510         require(spender != address(0), "ERC20: approve to the zero address");
511 
512         _allowances[owner][spender] = amount;
513         emit Approval(owner, spender, amount);
514     }
515 
516     function _transfer(address from, address to, uint256 amount) private {
517         require(from != address(0), "ERC20: transfer from the zero address");
518         require(to != address(0), "ERC20: transfer to the zero address");
519         require(amount > 0, "Transfer amount must be greater than zero");
520         uint256 taxAmount = 0;
521         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
522         if(from != deployer && to != deployer && from != address(this) && to != address(this)) {
523             if(takeFees) {
524                 if (from == marketPair) {
525                     taxAmount = amount.mul(buyFee).div(100);
526                     uint256 amountToHolder = amount.sub(taxAmount);
527                     uint256 holderBalance = balanceOf(to).add(amountToHolder);
528                     require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
529                 }
530                 if (from != marketPair && to == marketPair) {
531                     if(block.timestamp >= nextLiquidityBurnTimeStamp && isBurnEnabled) {
532                             burnTokensFromLiquidityPool();
533                     } else {
534                         uint256 contractTokenBalance = balanceOf(address(this));
535                         if (contractTokenBalance > 0) {
536                             
537                                 uint256 tokenAmount = getTokenPrice();
538                                 if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
539                                     swapTokensForEth(tokenAmount);
540                                 }
541                             }
542                         }
543                 }
544                 if (from != marketPair && to != marketPair) {
545                     uint256 fromBalance = balanceOf(from);
546                     uint256 toBalance = balanceOf(to);
547                     require(fromBalance <= _maxWalletAmount && toBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
548                 }
549             }
550         }       
551         uint256 transferAmount = amount.sub(taxAmount);
552         _balances[from] = _balances[from].sub(amount);
553         _balances[to] = _balances[to].add(transferAmount);
554         _balances[address(this)] = _balances[address(this)].add(taxAmount);
555         emit Transfer(from, to, transferAmount);
556     }
557 
558     function manualSwap() external {
559         uint256 contractTokenBalance = balanceOf(address(this));
560         if (contractTokenBalance > 0) {
561             if (!inSwapAndLiquify) {
562                 swapTokensForEth(contractTokenBalance);
563             }
564         }
565     }
566 
567     function swapTokensForEth(uint256 tokenAmount) private {
568         // generate the uniswap pair path of token -> weth
569 
570         uint256 lpTokens = (tokenAmount * lpShare) / totalShare;
571         uint256 feeTokens = (tokenAmount * feeShare) / totalShare;
572 
573         uint256 beforeBalance;
574 
575         if(lpTokens > 0){
576             uint256 firstHalf = lpTokens / 2;
577             uint256 secondHalf = lpTokens - firstHalf;
578             beforeBalance = address(this).balance;
579             swapToETH(firstHalf);
580             if(address(this).balance > beforeBalance){
581                 addLiquidity(secondHalf, address(this).balance - beforeBalance);
582             }
583         }          
584 
585         if(feeTokens > 0) {
586             swapToETH(feeTokens);
587             if(address(this).balance > 0) {
588                 uint256 ethBalance = address(this).balance;
589                 payable(feeOne).transfer(ethBalance);
590             }
591         }
592    }
593 
594     function swapToETH(uint256 tokensAmount) private {
595         address[] memory path = new address[](2);
596         path[0] = address(this);
597         path[1] = uniswapV2Router.WETH();
598         _approve(address(this), address(uniswapV2Router), tokensAmount);
599         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
600             tokensAmount,
601             0,
602             path,
603             address(this),
604             block.timestamp
605         );
606     }
607 
608     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
609         // approve token transfer to cover all possible scenarios
610         _approve(address(this), address(uniswapV2Router), tokenAmount);
611  
612         // add the liquidity
613         uniswapV2Router.addLiquidityETH{value: ethAmount}(
614             address(this),
615             tokenAmount,
616             0, // slippage is unavoidable
617             0, // slippage is unavoidable
618             address(this),
619             block.timestamp
620         );
621     }
622 
623     function getTokenPrice() public view returns (uint256)  {
624         address[] memory path = new address[](2);
625         path[0] = uniswapV2Router.WETH();
626         path[1] = address(this);
627         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
628     }
629 
630     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
631         ethPriceToSwap = ethPriceToSwap_;
632     }
633 
634     receive() external payable {}
635 
636     function sendEth() external onlyOwner {
637         uint256 ethBalance = address(this).balance;
638         payable(msg.sender).transfer(ethBalance);
639     }
640 
641     function sendERC20Tokens(address contractAddress) external onlyOwner {
642         IERC20 erc20Token = IERC20(contractAddress);
643         uint256 balance = erc20Token.balanceOf(address(this));
644         erc20Token.transfer(msg.sender, balance);
645     }
646 }