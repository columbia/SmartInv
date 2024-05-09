1 /*                                                                                                             
2      _ __       _,.---._         _ __        ,----.                   ,----.             ,----.              _,.---._     .-._         
3   .-`.' ,`.   ,-.' , -  `.    .-`.' ,`.   ,-.--` , \ ,--.-.  .-,--.,-.--` , \         ,-.--` , \   _.-.    ,-.' , -  `.  /==/ \  .-._  
4  /==/, -   \ /==/_,  ,  - \  /==/, -   \ |==|-  _.-`/==/- / /=/_ /|==|-  _.-`        |==|-  _.-` .-,.'|   /==/_,  ,  - \ |==|, \/ /, / 
5 |==| _ .=. ||==|   .=.     ||==| _ .=. | |==|   `.-.\==\, \/=/. / |==|   `.-.        |==|   `.-.|==|, |  |==|   .=.     ||==|-  \|  |  
6 |==| , '=',||==|_ : ;=:  - ||==| , '=',|/==/_ ,    / \==\  \/ -/ /==/_ ,    /       /==/_ ,    /|==|- |  |==|_ : ;=:  - ||==| ,  | -|  
7 |==|-  '..' |==| , '='     ||==|-  '..' |==|    .-'   |==|  ,_/  |==|    .-'        |==|    .-' |==|, |  |==| , '='     ||==| -   _ |  
8 |==|,  |     \==\ -    ,_ / |==|,  |    |==|_  ,`-._  \==\-, /   |==|_  ,`-._       |==|_  ,`-._|==|- `-._\==\ -    ,_ / |==|  /\ , |  
9 /==/ - |      '.='. -   .'  /==/ - |    /==/ ,     /  /==/._/    /==/ ,     /       /==/ ,     //==/ - , ,/'.='. -   .'  /==/, | |- |  
10 `--`---'        `--`--''    `--`---'    `--`-----``   `--`-`     `--`-----``        `--`-----`` `--`-----'   `--`--''    `--`./  `--`                                          
11 
12 
13 "I'm strong till the finich, 'cause I eats me spinach, I'm Elon the SpaceX Man (thoo thoo)."
14 -- Popeye Elon, Early Januray 2022
15 
16 
17 */                                                                           
18 
19 
20 
21 pragma solidity >=0.7.0 <0.8.0;
22 // SPDX-License-Identifier: Unlicensed
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 library SafeMath {
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62         uint256 c = a * b;
63         require(c / a == b, "SafeMath: multiplication overflow");
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         return c;
75     }
76 }
77 
78 contract Ownable is Context {
79     address private _owner;
80     address private _previousOwner;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     constructor() {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         emit OwnershipTransferred(address(0), msgSender);
87     }
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint256 amountIn,
111         uint256 amountOutMin,
112         address[] calldata path,
113         address to,
114         uint256 deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118     function addLiquidityETH(
119         address token,
120         uint256 amountTokenDesired,
121         uint256 amountTokenMin,
122         uint256 amountETHMin,
123         address to,
124         uint256 deadline
125     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
126 }
127 
128 
129 contract POPELON is Context, IERC20, Ownable {
130     using SafeMath for uint256;
131 
132     mapping (address => uint256) private _balance;
133     mapping (address => uint256) private _lastTX;
134     mapping (address => mapping (address => uint256)) private _allowances;
135 
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private _isExcluded;
138     mapping (address => bool) private _isBlacklisted;
139 
140     address[] private _excluded;  
141     bool public tradingLive = false;
142 
143     uint256 private _totalSupply = 1300000000 * 10**9;
144     uint256 public _totalBurned;
145 
146     string private _name = "Popeye Elon";
147     string private _symbol = "POPELON";
148     uint8 private _decimals = 9;
149     
150     address payable private _projWallet;
151 
152     uint256 public firstLiveBlock;
153     uint256 public _spinach = 3; 
154     uint256 public _liquidityMarketingFee = 10;
155     uint256 private _previousSpinach = _spinach;
156     uint256 private _previousLiquidityMarketingFee = _liquidityMarketingFee;
157 
158     IUniswapV2Router02 public immutable uniswapV2Router;
159     address public immutable uniswapV2Pair;
160     
161     bool inSwapAndLiquify;
162     bool public swapAndLiquifyEnabled = true;
163     bool public antiBotLaunch = true;
164     
165     uint256 public _maxTxAmount = 6500000 * 10**9;
166     uint256 public _maxHoldings = 65000000 * 10**9;
167     bool public maxHoldingsEnabled = true;
168     bool public maxTXEnabled = true;
169     bool public antiSnipe = true;
170     bool public extraCalories = true;
171     bool public cooldown = true;
172     uint256 public numTokensSellToAddToLiquidity = 13000000 * 10**9;
173     
174 
175     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
176     event SwapAndLiquifyEnabledUpdated(bool enabled);
177     event SwapAndLiquify(
178         uint256 tokensSwapped,
179         uint256 ethReceived,
180         uint256 tokensIntoLiqudity
181     );
182     
183     modifier lockTheSwap {
184         inSwapAndLiquify = true;
185         _;
186         inSwapAndLiquify = false;
187     }
188     
189     constructor () {
190         _balance[_msgSender()] = _totalSupply;
191 
192         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uni V2
193          // Create a uniswap pair for this new token
194         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
195 
196         // set the rest of the contract variables
197         uniswapV2Router = _uniswapV2Router;
198         
199         //exclude owner and this contract from fee
200         _isExcludedFromFee[owner()] = true;
201         _isExcludedFromFee[address(this)] = true;
202 
203         emit Transfer(address(0), _msgSender(), _totalSupply);
204     }
205 
206     function name() public view returns (string memory) {
207         return _name;
208     }
209 
210     function symbol() public view returns (string memory) {
211         return _symbol;
212     }
213 
214     function decimals() public view returns (uint8) {
215         return _decimals;
216     }
217 
218     function totalSupply() public view override returns (uint256) {
219         return _totalSupply;
220     }
221 
222     function balanceOf(address account) public view override returns (uint256) {
223         return _balance[account];
224     }
225 
226     function transfer(address recipient, uint256 amount) public override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     function allowance(address owner, address spender) public view override returns (uint256) {
232         return _allowances[owner][spender];
233     }
234 
235     function approve(address spender, uint256 amount) public override returns (bool) {
236         _approve(_msgSender(), spender, amount);
237         return true;
238     }
239 
240     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
241         _transfer(sender, recipient, amount);
242         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
243         return true;
244     }
245 
246     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
247         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
248         return true;
249     }
250 
251     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
252         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
253         return true;
254     }
255 
256 
257     function totalBurned() public view returns (uint256) {
258         return _totalBurned;
259     }
260     
261     
262     function excludeFromFee(address account) external onlyOwner {
263         _isExcludedFromFee[account] = true;
264     }
265     
266     function includeInFee(address account) external onlyOwner {
267         _isExcludedFromFee[account] = false;
268     }
269 
270     function setProjWallet(address payable _address) external onlyOwner {
271         _projWallet = _address;
272     }
273        
274     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
275         _maxTxAmount = maxTxAmount * 10**9;
276     }
277 
278     function setMaxHoldings(uint256 maxHoldings) external onlyOwner() {
279         _maxHoldings = maxHoldings * 10**9;
280     }
281     function setMaxTXEnabled(bool enabled) external onlyOwner() {
282         maxTXEnabled = enabled;
283     }
284     
285     function setMaxHoldingsEnabled(bool enabled) external onlyOwner() {
286         maxHoldingsEnabled = enabled;
287     }
288     
289     function setAntiSnipe(bool enabled) external onlyOwner() {
290         antiSnipe = enabled;
291     }
292     function setCooldown(bool enabled) external onlyOwner() {
293         cooldown = enabled;
294     }
295     function setExtraCalories(bool enabled) external onlyOwner() {
296         extraCalories = enabled;
297     }
298     
299     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
300         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
301     }
302     
303     function claimETH (address walletaddress) external onlyOwner {
304         // make sure we capture all ETH that may or may not be sent to this contract
305         payable(walletaddress).transfer(address(this).balance);
306     }
307     
308     function claimAltTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
309         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
310     }
311     
312     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
313         walletaddress.transfer(address(this).balance);
314     }
315     
316     function blacklist(address _address) external onlyOwner() {
317         _isBlacklisted[_address] = true;
318     }
319     
320     function removeFromBlacklist(address _address) external onlyOwner() {
321         _isBlacklisted[_address] = false;
322     }
323     
324     function getIsBlacklistedStatus(address _address) external view returns (bool) {
325         return _isBlacklisted[_address];
326     }
327     
328     function allowtrading() external onlyOwner() {
329         tradingLive = true;
330         firstLiveBlock = block.number;        
331     }
332 
333     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
334         swapAndLiquifyEnabled = _enabled;
335         emit SwapAndLiquifyEnabledUpdated(_enabled);
336     }
337     
338      //to recieve ETH from uniswapV2Router when swaping
339     receive() external payable {}
340 
341     
342     
343     function isExcludedFromFee(address account) public view returns(bool) {
344         return _isExcludedFromFee[account];
345     }
346 
347     function _approve(address owner, address spender, uint256 amount) private {
348         require(owner != address(0), "ERC20: approve from the zero address");
349         require(spender != address(0), "ERC20: approve to the zero address");
350         _allowances[owner][spender] = amount;
351         emit Approval(owner, spender, amount);
352     }
353 
354     function _eatSpinach(address _account, uint _amount) private {  
355         require( _amount <= balanceOf(_account));
356         _balance[_account] = _balance[_account].sub(_amount);
357         _totalSupply = _totalSupply.sub(_amount);
358         _totalBurned = _totalBurned.add(_amount);
359         emit Transfer(_account, address(0), _amount);
360     }
361 
362     function _projectBoost(uint _amount) private {
363         _balance[address(this)] = _balance[address(this)].add(_amount);
364     }
365     
366     function removeAllFee() private {
367         if(_spinach == 0 && _liquidityMarketingFee == 0) return;
368         
369         _previousSpinach = _spinach;
370         _previousLiquidityMarketingFee = _liquidityMarketingFee;
371         
372         _spinach = 0;
373         _liquidityMarketingFee = 0;
374     }
375     
376     function restoreAllFee() private {
377         _spinach = _previousSpinach;
378         _liquidityMarketingFee = _previousLiquidityMarketingFee;
379     }
380 
381     function _transfer(address from, address to, uint256 amount) private {
382         require(from != address(0), "ERC20: transfer from the zero address");
383         require(to != address(0), "ERC20: transfer to the zero address");
384         require(amount > 0, "Transfer amount must be greater than zero");
385         require(!_isBlacklisted[from] && !_isBlacklisted[to]);
386         if(!tradingLive){
387             require(from == owner()); // only owner allowed to trade or add liquidity
388         }       
389 
390         if(maxTXEnabled){
391             if(from != owner() && to != owner()){
392                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
393             }
394         }
395         if(cooldown){
396             if( to != owner() && to != address(this) && to != address(uniswapV2Router) && to != uniswapV2Pair) {
397                 require(_lastTX[tx.origin] <= (block.timestamp + 30 seconds), "Cooldown in effect");
398                 _lastTX[tx.origin] = block.timestamp;
399             }
400         }
401 
402         if(antiSnipe){
403             if(from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){
404             require( tx.origin == to);
405             }
406         }
407 
408         if(maxHoldingsEnabled){
409             if(from == uniswapV2Pair && from != owner() && to != owner() && to != address(uniswapV2Router) && to != address(this)) {
410                 uint balance = balanceOf(to);
411                 require(balance.add(amount) <= _maxHoldings);
412                 
413             }
414         }
415 
416         uint256 contractTokenBalance = balanceOf(address(this));        
417         if(contractTokenBalance >= _maxTxAmount){
418             contractTokenBalance = _maxTxAmount;
419         }
420         
421         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
422         if ( overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
423             contractTokenBalance = numTokensSellToAddToLiquidity;
424             swapAndLiquify(contractTokenBalance);
425         }
426 
427         bool takeFee = true;        
428         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
429             takeFee = false;
430         }
431 
432         if(from == uniswapV2Pair && to != address(this) && to != address(uniswapV2Router)){            
433             _spinach = 3; 
434             _liquidityMarketingFee = 10;
435         } else {
436             _spinach = 10; 
437             _liquidityMarketingFee = 3;
438         }
439 
440         _tokenTransfer(from,to,amount,takeFee);
441     }
442 
443     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {        
444         if(antiBotLaunch){
445             if(block.number <= firstLiveBlock && sender == uniswapV2Pair && recipient != address(uniswapV2Router) && recipient != address(this)){
446                 _isBlacklisted[recipient] = true;
447             }
448         }
449 
450         if(!takeFee) removeAllFee();
451 
452         uint256 spinachToEat = amount.mul(_spinach).div(100);
453         uint256 projectBoost = amount.mul(_liquidityMarketingFee).div(100);
454         uint256 amountWithNoSpinach = amount.sub(spinachToEat);
455         uint256 amountTransferred = amount.sub(projectBoost).sub(spinachToEat);
456 
457         _eatSpinach(sender, spinachToEat);
458         _projectBoost(projectBoost);        
459         _balance[sender] = _balance[sender].sub(amountWithNoSpinach);
460         _balance[recipient] = _balance[recipient].add(amountTransferred);
461 
462         if(extraCalories && sender != uniswapV2Pair && sender != address(this) && sender != address(uniswapV2Router) && (recipient == address(uniswapV2Router) || recipient == uniswapV2Pair)) {
463             _eatSpinach(uniswapV2Pair, spinachToEat);
464         }
465         
466         emit Transfer(sender, recipient, amountTransferred);
467         
468         if(!takeFee) restoreAllFee();
469     }
470 
471     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
472         uint256 tokensForLiq = (contractTokenBalance.div(5));
473         uint256 half = tokensForLiq.div(2);
474         uint256 toSwap = contractTokenBalance.sub(half);
475         uint256 initialBalance = address(this).balance;
476         swapTokensForEth(toSwap);
477         uint256 newBalance = address(this).balance.sub(initialBalance);
478         addLiquidity(half, newBalance);
479 
480         payable(_projWallet).transfer(address(this).balance);   
481         
482         emit SwapAndLiquify(half, newBalance, half);
483     }
484 
485     function swapTokensForEth(uint256 tokenAmount) private {
486         // generate the uniswap pair path of token -> weth
487         address[] memory path = new address[](2);
488         path[0] = address(this);
489         path[1] = uniswapV2Router.WETH();
490 
491         _approve(address(this), address(uniswapV2Router), tokenAmount);
492 
493         // make the swap
494         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
495             tokenAmount,
496             0, // accept any amount of ETH
497             path,
498             address(this),
499             block.timestamp
500         );
501     }
502 
503     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
504         // approve token transfer to cover all possible scenarios
505         _approve(address(this), address(uniswapV2Router), tokenAmount);
506 
507         // add the liquidity
508         uniswapV2Router.addLiquidityETH{value: ethAmount}(
509             address(this),
510             tokenAmount,
511             0, // slippage is unavoidable
512             0, // slippage is unavoidable
513             owner(),
514             block.timestamp
515         );
516     }
517 }