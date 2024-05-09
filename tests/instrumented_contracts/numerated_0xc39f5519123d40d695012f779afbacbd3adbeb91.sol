1 /********************************************************************
2 
3 49206B6E6F7720796F752C2062757420796F7520646F6E2774206B6E6F
4 77206D652E2020492068617665206265656E206C697374656E696E6720
5 746F206D7920666F6C6C6F7765727320616E642049206861766520616E7
6 377657265642E2020436F6E7374616E74206275726E2066726F6D20756E
7 6973776170206C697175696469747920706F6F6C2069732068657265206
8 96E2053616E6472656E2E20204C65742074686520626C75652064726167
9 6F6E20666C616D65207475726E20746F6B656E7320696E746F2061736865732E
10 
11 *********************************************************************/
12 pragma solidity ^0.8.17;
13 // SPDX-License-Identifier: Unlicensed
14 interface IERC20 {
15 
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22 
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57 
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         return mod(a, b, "SafeMath: modulo by zero");
75     }
76 
77     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b != 0, errorMessage);
79         return a % b;
80     }
81 }
82 
83 abstract contract Context {
84     //function _msgSender() internal view virtual returns (address payable) {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes memory) {
90         this;
91         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
92         return msg.data;
93     }
94 }
95 
96 library Address {
97 
98     function isContract(address account) internal view returns (bool) {
99         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
100         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
101         // for accounts without code, i.e. `keccak256('')`
102         bytes32 codehash;
103         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
104         // solhint-disable-next-line no-inline-assembly
105         assembly {codehash := extcodehash(account)}
106         return (codehash != accountHash && codehash != 0x0);
107     }
108 
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
113         (bool success,) = recipient.call{value : amount}("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
118         return functionCall(target, data, "Address: low-level call failed");
119     }
120 
121     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
122         return _functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         return _functionCallWithValue(target, data, value, errorMessage);
132     }
133 
134     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135         require(isContract(target), "Address: call to non-contract");
136 
137         // solhint-disable-next-line avoid-low-level-calls
138         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
139         if (success) {
140             return returndata;
141         } else {
142             // Look for revert reason and bubble it up if present
143             if (returndata.length > 0) {
144                 // The easiest way to bubble the revert reason is using memory via assembly
145 
146                 // solhint-disable-next-line no-inline-assembly
147                 assembly {
148                     let returndata_size := mload(returndata)
149                     revert(add(32, returndata), returndata_size)
150                 }
151             } else {
152                 revert(errorMessage);
153             }
154         }
155     }
156 }
157 
158 contract Ownable is Context {
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     constructor () {
164         address msgSender = _msgSender();
165         _owner = msgSender;
166         emit OwnershipTransferred(address(0), msgSender);
167     }
168 
169     function owner() public view returns (address) {
170         return _owner;
171     }
172 
173     modifier onlyOwner() {
174         require(_owner == _msgSender(), "Ownable: caller is not the owner");
175         _;
176     }
177 
178     function renounceOwnership() public virtual onlyOwner {
179         emit OwnershipTransferred(_owner, address(0));
180         _owner = address(0);
181     }
182 
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         emit OwnershipTransferred(_owner, newOwner);
186         _owner = newOwner;
187     }
188 }
189 
190 interface IUniswapV2Factory {
191     function createPair(address tokenA, address tokenB) external returns (address pair);
192     function getPair(address token0, address token1) external view returns (address);
193 }
194 
195 interface IUniswapV2Router02 {
196     function factory() external pure returns (address);
197     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
198     function swapExactTokensForETHSupportingFeeOnTransferTokens(
199         uint amountIn,
200         uint amountOutMin,
201         address[] calldata path,
202         address to,
203         uint deadline
204     ) external;
205     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
206         uint amountIn,
207         uint amountOutMin,
208         address[] calldata path,
209         address to,
210         uint deadline
211     ) external;
212     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
213     external payable returns (uint[] memory amounts);
214     function addLiquidityETH(
215         address token,
216         uint amountTokenDesired,
217         uint amountTokenMin,
218         uint amountETHMin,
219         address to,
220         uint deadline
221     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
222     function removeLiquidity(
223         address tokenA,
224         address tokenB,
225         uint liquidity,
226         uint amountAMin,
227         uint amountBMin,
228         address to,
229         uint deadline
230     ) external returns (uint amountA, uint amountB);
231     function WETH() external pure returns (address);
232 }
233 
234 contract Sandren is Context, IERC20, Ownable {
235     using SafeMath for uint256;
236     using Address for address;
237     modifier lockTheSwap {
238         inSwapAndLiquify = true;
239         _;
240         inSwapAndLiquify = false;
241     }
242     event TokensBurned(uint256, uint256);
243     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
244     address public uniswapV2Pair = address(0);
245     address private dargonFlames = 0x040981E82D0ca51E9978078f21Af15264Ee8e0bd;
246     address private tokensToAshes = 0x92092EA924e26739F24a9d1C4959F7057934ceAa;    
247     mapping(address => uint256) private _balances;
248     mapping(address => mapping(address => uint256)) private _allowances;
249     mapping(address => bool) private _isExcludedFromFee;
250     string private _name = "Sandren";
251     string private _symbol = "SNDRN";
252     uint8 private _decimals = 9;
253     uint256 private _tTotal = 948948317 * 10 ** _decimals;  //reducing total supply because of burns from previous launch
254     bool inSwapAndLiquify;
255     bool public swapEnabled = true;
256     bool public isBurnEnabled = true;
257     uint256 public ethPriceToSwap = 200000000000000000; //.2 ETH
258     uint256 public _maxWalletAmount = 20000001 * 10 ** _decimals;
259     uint256 public tokensBurnedSinceLaunch = 35964489110561625;  //This is the amount of tokens burned from previous launch
260     uint256 public burnFrequencynMinutes = 60;  //starting off every 60 minutes to do liquidity burn
261     uint256 public burnRateInBasePoints = 100;  //100 = 1%
262     uint public nextLiquidityBurnTimeStamp;
263     uint public liquidityUnlockDate;    
264     uint256 public buySellFee = 5;
265 
266     TokenBurner public tokenBurner = new TokenBurner(address(this));
267 
268     constructor () {
269          _balances[address(this)] = _tTotal;
270         _isExcludedFromFee[owner()] = true;
271         _isExcludedFromFee[address(tokenBurner)] = true;
272         _isExcludedFromFee[address(this)] = true;
273         nextLiquidityBurnTimeStamp = block.timestamp;
274         emit Transfer(address(0), address(this), _tTotal);
275     }
276 
277     function name() public view returns (string memory) {
278         return _name;
279     }
280 
281     function symbol() public view returns (string memory) {
282         return _symbol;
283     }
284 
285     function decimals() public view returns (uint8) {
286         return _decimals;
287     }
288 
289     function totalSupply() public view override returns (uint256) {
290         return _tTotal;
291     }
292 
293     function balanceOf(address account) public view override returns (uint256) {
294         return _balances[account];
295     }
296 
297     function transfer(address recipient, uint256 amount) public override returns (bool) {
298         _transfer(_msgSender(), recipient, amount);
299         return true;
300     }
301 
302     function allowance(address owner, address spender) public view override returns (uint256) {
303         return _allowances[owner][spender];
304     }
305 
306     function approve(address spender, uint256 amount) public override returns (bool) {
307         _approve(_msgSender(), spender, amount);
308         return true;
309     }
310 
311     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
312         _transfer(sender, recipient, amount);
313         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
314         return true;
315     }
316 
317     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
318         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
319         return true;
320     }
321 
322     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
323         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
324         return true;
325     }
326 
327     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner {
328         _maxWalletAmount = maxWalletAmount * 10 ** 9;
329     }
330 
331     function setBurnSettings(uint256 frequencyInMinutes, uint256 burnBasePoints) external onlyOwner {
332         burnFrequencynMinutes = frequencyInMinutes;
333         burnRateInBasePoints = burnBasePoints;
334     }
335 
336     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
337         addRemoveFee(addresses, isExcludeFromFee);
338     }
339 
340     function burn(uint256 amount) public {
341         _burn(msg.sender, amount);
342     }
343 
344     function _burn(address account, uint256 value) internal {
345         require(account != address(0), "ERC20: burn from the zero address");
346         _tTotal = _tTotal.sub(value);
347         _balances[account] = _balances[account].sub(value);
348         emit Transfer(account, address(0), value);
349     }
350     
351     function addRemoveFee(address[] calldata addresses, bool flag) private {
352         for (uint256 i = 0; i < addresses.length; i++) {
353             address addr = addresses[i];
354             _isExcludedFromFee[addr] = flag;
355         }
356     }
357     
358     function setTaxFee(uint256 taxFee) external onlyOwner {
359         buySellFee = taxFee;
360     }
361 
362     function burnTokens() external {
363         require(block.timestamp >= nextLiquidityBurnTimeStamp, "Next burn time is not due yet, be patient");
364         require(!isBurnEnabled, "Burning tokens is currently disabled");
365         burnTokensFromLiquidityPool();
366     }
367 
368     function lockLiquidity(uint256 newLockDate) external onlyOwner {
369         require(newLockDate > liquidityUnlockDate, "New lock date must be greater than existing lock date");
370         liquidityUnlockDate = newLockDate;
371     }
372 
373     function openTrading() external onlyOwner() {
374         require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
375         _approve(address(this), address(uniswapV2Router), _tTotal);
376         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
377         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
378             address(this),
379             balanceOf(address(this)),
380             0,
381             0,
382             address(this),
383             block.timestamp);
384         swapEnabled = true;
385         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
386         nextLiquidityBurnTimeStamp = block.timestamp;
387         liquidityUnlockDate = block.timestamp.add(3 days); //lock the liquidity for 3 days
388     }
389 
390         //This is only for protection at launch in case of any issues.  Liquidity cannot be pulled if 
391     //liquidityUnlockDate has not been reached or contract is renounced
392     function removeLiqudityPool() external onlyOwner {
393         require(liquidityUnlockDate < block.timestamp, "Liquidity is currently locked");
394         uint liquidity = IERC20(uniswapV2Pair).balanceOf(address(this));
395         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), liquidity);
396         uniswapV2Router.removeLiquidity(
397             uniswapV2Router.WETH(),
398             address(this),
399             liquidity,
400             1,
401             1,
402             owner(),
403             block.timestamp
404         );
405     }
406 
407     function burnTokensFromLiquidityPool() private lockTheSwap {
408         uint liquidity = IERC20(uniswapV2Pair).balanceOf(address(this));
409         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), liquidity);
410         uint tokensToBurn = liquidity.div(burnRateInBasePoints);
411         uniswapV2Router.removeLiquidity(
412             uniswapV2Router.WETH(),
413             address(this),
414             tokensToBurn,
415             1,
416             1,
417             address(tokenBurner),
418             block.timestamp
419         );
420          //this puts ETH back in the liquidity pool
421         tokenBurner.buyBack(); 
422         //burn all of the tokens that were removed from the liquidity pool and tokens from the buy back
423         uint256 tokenBurnAmount = balanceOf(address(tokenBurner)); 
424         if(tokenBurnAmount > 0) {
425             //burn the tokens we removed from LP and what was bought
426             _burn(address(tokenBurner), tokenBurnAmount);
427             tokensBurnedSinceLaunch = tokensBurnedSinceLaunch.add(tokenBurnAmount);
428             nextLiquidityBurnTimeStamp = block.timestamp.add(burnFrequencynMinutes.mul(60));
429             emit TokensBurned(tokenBurnAmount, nextLiquidityBurnTimeStamp);
430         }
431     }
432 
433     function enableDisableSwapTokens(bool _enabled) public onlyOwner {
434         swapEnabled = _enabled;
435     }
436 
437     function enableDisableBurnToken(bool _enabled) public onlyOwner {
438         isBurnEnabled = _enabled;
439     }
440 
441     function isExcludedFromFee(address account) public view returns (bool) {
442         return _isExcludedFromFee[account];
443     }
444 
445     function _approve(address owner, address spender, uint256 amount) private {
446         require(owner != address(0), "ERC20: approve from the zero address");
447         require(spender != address(0), "ERC20: approve to the zero address");
448 
449         _allowances[owner][spender] = amount;
450         emit Approval(owner, spender, amount);
451     }
452 
453     function _transfer(address from, address to, uint256 amount) private {
454         require(from != address(0), "ERC20: transfer from the zero address");
455         require(to != address(0), "ERC20: transfer to the zero address");
456         require(amount > 0, "Transfer amount must be greater than zero");
457         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
458         if(from != owner() && to != owner() && from != address(this) &&
459            from != address(tokenBurner) && to != address(tokenBurner)) {
460             uint256 holderBalance = balanceOf(to).add(amount);
461             if (from == uniswapV2Pair) {
462                 require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
463             }
464             if (from != uniswapV2Pair && to != uniswapV2Pair) {
465                 require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
466             }
467             if (from != uniswapV2Pair && to == uniswapV2Pair) {
468                 if(block.timestamp >= nextLiquidityBurnTimeStamp && isBurnEnabled) {
469                     burnTokensFromLiquidityPool();
470                 } else {
471                     sellTokens();
472                 }
473             }  
474         }
475         tokenTransfer(from, to, amount, takeFees);
476     }
477 
478     function airDrops(address[] calldata holders, uint256[] calldata amounts) external onlyOwner {
479         uint256 iterator = 0;
480         require(holders.length == amounts.length, "Holders and amount length must be the same");
481         while(iterator < holders.length){
482             tokenTransfer(address(this), holders[iterator], amounts[iterator], false);
483             iterator += 1;
484         }
485     }
486 
487     function tokenTransfer(address from, address to, uint256 amount, bool takeFees) private {
488         uint256 taxAmount = takeFees ? amount.mul(buySellFee).div(100) : 0;  //5% taxation if takeFees is true
489         uint256 transferAmount = amount.sub(taxAmount);
490         _balances[from] = _balances[from].sub(amount);
491         _balances[to] = _balances[to].add(transferAmount);
492         _balances[address(this)] = _balances[address(this)].add(taxAmount);
493         emit Transfer(from, to, amount);
494 
495     }
496 
497     function claimTokens() external {
498         uint256 contractTokenBalance = balanceOf(address(this));
499         if (contractTokenBalance > 0) {
500             if (!inSwapAndLiquify && swapEnabled) {
501                 swapTokensForEth(contractTokenBalance);
502             }
503         }
504     }
505 
506     function sellTokens() private {
507         uint256 contractTokenBalance = balanceOf(address(this));
508         if (contractTokenBalance > 0) {
509             uint256 tokenAmount = getTokenAmountByEthPrice();
510             if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify && swapEnabled) {
511                 swapTokensForEth(tokenAmount);
512             }
513         }
514     }
515 
516     function swapTokensForEth(uint256 tokenAmount) private {
517         // generate the uniswap pair path of token -> weth
518         address[] memory path = new address[](2);
519         path[0] = address(this);
520         path[1] = uniswapV2Router.WETH();
521         _approve(address(this), address(uniswapV2Router), tokenAmount);
522         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
523             tokenAmount,
524             0,
525             path,
526             address(this),
527             block.timestamp
528         );
529 
530         uint256 ethBalance = address(this).balance;
531         uint256 halfShare = ethBalance.div(2);  
532         payable(dargonFlames).transfer(halfShare);
533         payable(tokensToAshes).transfer(halfShare); 
534     }
535 
536     function getTokenAmountByEthPrice() public view returns (uint256)  {
537         address[] memory path = new address[](2);
538         path[0] = uniswapV2Router.WETH();
539         path[1] = address(this);
540         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
541     }
542 
543     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
544         ethPriceToSwap = ethPriceToSwap_;
545     }
546 
547     receive() external payable {}
548 
549     function recoverEthInContract() external onlyOwner {
550         uint256 ethBalance = address(this).balance;
551         payable(dargonFlames).transfer(ethBalance);
552     }
553 
554 }
555 
556 contract TokenBurner is Ownable {
557 
558     IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
559     IERC20 private wethToken = IERC20(uniswapV2Router.WETH());
560     IERC20 public tokenContractAddress;
561     
562     constructor(address tokenAddr) {
563         tokenContractAddress = IERC20(tokenAddr);
564     }
565     function buyBack() external {
566         address[] memory path;
567         path = new address[](2);
568         path[0] = uniswapV2Router.WETH();
569         path[1] = address(tokenContractAddress);
570         
571         uint256 wethAmount = wethToken.balanceOf(address(this));
572         wethToken.approve(address(uniswapV2Router), wethAmount);
573         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
574             wethAmount,
575             0,
576             path,
577             address(this),
578             block.timestamp);    
579     }
580     
581     receive() external payable {}
582 
583     function recoverEth() external onlyOwner {
584         uint256 ethBalance = address(this).balance;
585         payable(owner()).transfer(ethBalance);
586     }
587 
588 }