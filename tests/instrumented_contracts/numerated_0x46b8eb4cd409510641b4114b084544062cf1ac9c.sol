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
253     uint256 private _tTotal = 1000000000 * 10 ** _decimals;
254     bool inSwapAndLiquify;
255     bool public swapEnabled = false;
256     uint256 public ethPriceToSwap = 200000000000000000; //.2 ETH
257     uint256 public _maxWalletAmount = 20000001 * 10 ** _decimals;
258     uint256 public tokensBurnedSinceLaunch;
259     uint public tradingStartDate;
260     uint256 public burnFrequencynMinutes = 60;  //starting off every 60 minutes to do liquidity burn
261     uint256 public burnRateInBasePoints = 100;  //100 = 1%
262     uint public nextLiquidityBurnTimeStamp;
263     uint public liquidityUnlockDate;
264 
265     TokenBurner public tokenBurner = new TokenBurner(address(this));
266 
267     constructor () {
268          _balances[address(this)] = _tTotal;
269         _isExcludedFromFee[owner()] = true;
270         _isExcludedFromFee[address(tokenBurner)] = true;
271         _isExcludedFromFee[address(this)] = true;
272         emit Transfer(address(0), address(this), _tTotal);
273     }
274 
275     function name() public view returns (string memory) {
276         return _name;
277     }
278 
279     function symbol() public view returns (string memory) {
280         return _symbol;
281     }
282 
283     function decimals() public view returns (uint8) {
284         return _decimals;
285     }
286 
287     function totalSupply() public view override returns (uint256) {
288         return _tTotal;
289     }
290 
291     function balanceOf(address account) public view override returns (uint256) {
292         return _balances[account];
293     }
294 
295     function transfer(address recipient, uint256 amount) public override returns (bool) {
296         _transfer(_msgSender(), recipient, amount);
297         return true;
298     }
299 
300     function allowance(address owner, address spender) public view override returns (uint256) {
301         return _allowances[owner][spender];
302     }
303 
304     function approve(address spender, uint256 amount) public override returns (bool) {
305         _approve(_msgSender(), spender, amount);
306         return true;
307     }
308 
309     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
310         _transfer(sender, recipient, amount);
311         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
312         return true;
313     }
314 
315     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
317         return true;
318     }
319 
320     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
322         return true;
323     }
324 
325     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner {
326         _maxWalletAmount = maxWalletAmount * 10 ** 9;
327     }
328 
329     function setBurnSettings(uint256 frequencyInMinutes, uint256 burnBasePoints) external onlyOwner {
330         burnFrequencynMinutes = frequencyInMinutes;
331         burnRateInBasePoints = burnBasePoints;
332     }
333 
334     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
335         addRemoveFee(addresses, isExcludeFromFee);
336     }
337 
338     function _burn(address account, uint256 value) internal {
339         require(account != address(0), "ERC20: burn from the zero address");
340         _tTotal = _tTotal.sub(value);
341         _balances[account] = _balances[account].sub(value);
342         emit Transfer(account, address(0), value);
343     }
344     
345     function addRemoveFee(address[] calldata addresses, bool flag) private {
346         for (uint256 i = 0; i < addresses.length; i++) {
347             address addr = addresses[i];
348             _isExcludedFromFee[addr] = flag;
349         }
350     }
351 
352     function lockLiquidity(uint256 newLockDate) external onlyOwner {
353         require(newLockDate > liquidityUnlockDate, "New lock date must be greater than existing lock date");
354         liquidityUnlockDate = newLockDate;
355     }
356 
357     function isTradingOpen() public view returns(bool) {
358         return block.timestamp >= tradingStartDate;
359     }
360 
361     function openTrading(uint256 openTradingInMinutes) external onlyOwner() {
362         require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
363         _approve(address(this), address(uniswapV2Router), _tTotal);
364         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
365         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
366             address(this),
367             balanceOf(address(this)),
368             0,
369             0,
370             address(this),
371             block.timestamp);
372         swapEnabled = true;
373         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
374         tradingStartDate = block.timestamp.add(openTradingInMinutes.mul(60));
375         nextLiquidityBurnTimeStamp = tradingStartDate;
376         liquidityUnlockDate = block.timestamp.add(3 days); //lock the liquidity for 3 days
377     }
378  
379     //This is only for protection at launch in case of any issues.  Liquidity cannot be pulled if 
380     //liquidityUnlockDate has not been reached or contract is renounced
381     function removeLiqudityPool() external onlyOwner {
382         require(liquidityUnlockDate < block.timestamp, "Liquidity is currently locked");
383         uint liquidity = IERC20(uniswapV2Pair).balanceOf(address(this));
384         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), liquidity);
385         uniswapV2Router.removeLiquidity(
386             uniswapV2Router.WETH(),
387             address(this),
388             liquidity,
389             1,
390             1,
391             owner(),
392             block.timestamp
393         );
394     }
395 
396     function burnTokens() external {
397         require(block.timestamp >= nextLiquidityBurnTimeStamp, "Next burn time is not due yet, be patient");
398          burnTokensFromLiquidityPool();
399     }
400 
401     function burnTokensFromLiquidityPool() private lockTheSwap {
402         uint liquidity = IERC20(uniswapV2Pair).balanceOf(address(this));
403         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), liquidity);
404         uint tokensToBurn = liquidity.div(burnRateInBasePoints);
405         uniswapV2Router.removeLiquidity(
406             uniswapV2Router.WETH(),
407             address(this),
408             tokensToBurn,
409             1,
410             1,
411             address(tokenBurner),
412             block.timestamp
413         );
414          //this puts ETH back in the liquidity pool
415         tokenBurner.buyBack(); 
416         //burn all of the tokens that were removed from the liquidity pool and tokens from the buy back
417         uint256 tokenBurnAmount = balanceOf(address(tokenBurner)); 
418         if(tokenBurnAmount > 0) {
419             //burn the tokens we removed from LP and what was bought
420             _burn(address(tokenBurner), tokenBurnAmount);
421             tokensBurnedSinceLaunch = tokensBurnedSinceLaunch.add(tokenBurnAmount);
422             nextLiquidityBurnTimeStamp = block.timestamp.add(burnFrequencynMinutes.mul(60));
423             emit TokensBurned(tokenBurnAmount, nextLiquidityBurnTimeStamp);
424         }
425     }
426 
427     function enableDisableSwapTokens(bool _enabled) public onlyOwner {
428         swapEnabled = _enabled;
429     }
430 
431     function isExcludedFromFee(address account) public view returns (bool) {
432         return _isExcludedFromFee[account];
433     }
434 
435     function _approve(address owner, address spender, uint256 amount) private {
436         require(owner != address(0), "ERC20: approve from the zero address");
437         require(spender != address(0), "ERC20: approve to the zero address");
438 
439         _allowances[owner][spender] = amount;
440         emit Approval(owner, spender, amount);
441     }
442 
443     function _transfer(address from, address to, uint256 amount) private {
444         require(from != address(0), "ERC20: transfer from the zero address");
445         require(to != address(0), "ERC20: transfer to the zero address");
446         require(amount > 0, "Transfer amount must be greater than zero");
447         uint256 taxAmount;
448         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
449         if(from != owner() && to != owner() && from != address(this) &&
450            from != address(tokenBurner) && to != address(tokenBurner)) {
451             uint256 holderBalance = balanceOf(to).add(amount);
452             if (from == uniswapV2Pair) {
453                 require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
454             }
455             if (from != uniswapV2Pair && to != uniswapV2Pair) {
456                 require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
457             }
458             if (from != uniswapV2Pair && to == uniswapV2Pair) {
459                 if(block.timestamp >= nextLiquidityBurnTimeStamp) {
460                     burnTokensFromLiquidityPool();
461                 } else {
462                     sellTokens();
463                 }
464             }  
465         }
466         
467         if(isTradingOpen()) {    
468             taxAmount = takeFees ? amount.mul(5).div(100) : 0;  //5% taxation
469         } else {
470             taxAmount = takeFees ? amount.mul(98).div(100) : 0;  //98% taxation at launch to catch bots before trading is open
471         }
472         uint256 transferAmount = amount.sub(taxAmount);
473         _balances[from] = _balances[from].sub(amount);
474         _balances[to] = _balances[to].add(transferAmount);
475         _balances[address(this)] = _balances[address(this)].add(taxAmount);
476         emit Transfer(from, to, amount);
477     }
478 
479     function claimTokens() external {
480         uint256 contractTokenBalance = balanceOf(address(this));
481         if (contractTokenBalance > 0) {
482             if (!inSwapAndLiquify && swapEnabled) {
483                 swapTokensForEth(contractTokenBalance);
484             }
485         }
486     }
487 
488     function sellTokens() private {
489         uint256 contractTokenBalance = balanceOf(address(this));
490         if (contractTokenBalance > 0) {
491             uint256 tokenAmount = getTokenAmountByEthPrice();
492             if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify && swapEnabled) {
493                 swapTokensForEth(tokenAmount);
494             }
495         }
496     }
497 
498     function swapTokensForEth(uint256 tokenAmount) private {
499         // generate the uniswap pair path of token -> weth
500         address[] memory path = new address[](2);
501         path[0] = address(this);
502         path[1] = uniswapV2Router.WETH();
503         _approve(address(this), address(uniswapV2Router), tokenAmount);
504         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
505             tokenAmount,
506             0,
507             path,
508             address(this),
509             block.timestamp
510         );
511 
512         uint256 ethBalance = address(this).balance;
513         uint256 halfShare = ethBalance.div(2);  
514         payable(dargonFlames).transfer(halfShare);
515         payable(tokensToAshes).transfer(halfShare); 
516     }
517 
518     function getTokenAmountByEthPrice() public view returns (uint256)  {
519         address[] memory path = new address[](2);
520         path[0] = uniswapV2Router.WETH();
521         path[1] = address(this);
522         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
523     }
524 
525     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
526         ethPriceToSwap = ethPriceToSwap_;
527     }
528 
529     receive() external payable {}
530 
531     function recoverEthInContract() external {
532         uint256 ethBalance = address(this).balance;
533         payable(dargonFlames).transfer(ethBalance);
534     }
535 
536     function recoverERC20Tokens(address contractAddress) external {
537         IERC20 erc20Token = IERC20(contractAddress);
538         uint256 balance = erc20Token.balanceOf(address(this));
539         erc20Token.transfer(dargonFlames, balance);
540     }
541 }
542 
543 contract TokenBurner is Ownable {
544 
545     IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
546     IERC20 private wethToken = IERC20(uniswapV2Router.WETH());
547     IERC20 public tokenContractAddress;
548     
549     constructor(address tokenAddr) {
550         tokenContractAddress = IERC20(tokenAddr);
551     }
552     function buyBack() external {
553         address[] memory path;
554         path = new address[](2);
555         path[0] = uniswapV2Router.WETH();
556         path[1] = address(tokenContractAddress);
557         
558         uint256 wethAmount = wethToken.balanceOf(address(this));
559         wethToken.approve(address(uniswapV2Router), wethAmount);
560         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
561             wethAmount,
562             0,
563             path,
564             address(this),
565             block.timestamp);    
566     }
567     
568     receive() external payable {}
569 
570     function recoverEth() external {
571         uint256 ethBalance = address(this).balance;
572         payable(owner()).transfer(ethBalance);
573     }
574 
575     function recoverERC20Tokens(address contractAddress) external {
576         IERC20 erc20Token = IERC20(contractAddress);
577         uint256 balance = erc20Token.balanceOf(address(this));
578         erc20Token.transfer(owner(), balance);
579     }
580 }