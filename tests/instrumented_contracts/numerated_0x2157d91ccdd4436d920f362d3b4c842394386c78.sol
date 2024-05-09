1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 ShibaMaster
6 
7 Web: https://www.shibamaster.xyz/
8 Twitter: https://twitter.com/ShibaMasterETH
9 
10 Tokenomics
11 
12 5% Buy
13 5% Sell
14 
15 1% LP
16 2% ShibMaster Burn
17 2% External Burn
18 Refer to website / litepaper for detailed tokenomics on burn
19 
20 */
21 
22 pragma solidity ^0.8.13;
23 
24 interface IERC20 {
25 
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62 
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         return mod(a, b, "SafeMath: modulo by zero");
80     }
81 
82     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b != 0, errorMessage);
84         return a % b;
85     }
86 }
87 
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address payable) {
90         return payable(msg.sender);
91     }
92 
93     function _msgData() internal view virtual returns (bytes memory) {
94         this;
95         return msg.data;
96     }
97 }
98 
99 contract Ownable is Context {
100     address private _owner;
101 
102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104     constructor () {
105         address msgSender = _msgSender();
106         _owner = msgSender;
107         emit OwnershipTransferred(address(0), msgSender);
108     }
109 
110     function owner() public view returns (address) {
111         return _owner;
112     }
113 
114     modifier onlyOwner() {
115         require(_owner == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119     function renounceOwnership() public virtual onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123 
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         emit OwnershipTransferred(_owner, newOwner);
127         _owner = newOwner;
128     }
129 }
130 
131 interface IUniswapV2Factory {
132     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
133 
134     function createPair(address tokenA, address tokenB) external returns (address pair);
135 }
136 
137 interface IUniswapV2Router02 {
138     function factory() external pure returns (address);
139     function WETH() external pure returns (address);
140 
141     function addLiquidityETH(
142         address token,
143         uint amountTokenDesired,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
149 
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external;
157 
158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     )
164         external payable;
165 }
166 
167 contract ShibaMaster is Context, IERC20, Ownable {
168     using SafeMath for uint256;
169     IUniswapV2Router02 public uniswapV2Router;
170     address public uniswapV2Pair;
171     
172     mapping (address => uint256) private balances;
173     mapping (address => mapping (address => uint256)) private _allowances;
174 
175     mapping (address => bool) private _isExcludedFromFee;
176    
177     string private constant _name = "ShibaMaster";
178     string private constant _symbol = "ShibaM ";
179     uint8 private constant _decimals = 9;
180     uint256 private _tTotal = 1000000000000 * 10**_decimals;
181 
182     uint256 public _maxWalletAmount = 10000000000 * 10**_decimals;
183     uint256 public _maxTxAmount = 10000000000 * 10**_decimals;
184     uint256 public swapTokenAtAmount = 1250000000 * 10**_decimals;
185 
186     address public liquidityReceiver;
187 
188     uint256 public totalTokenBurned;
189     mapping (address => uint256) private _erc20TokenBurned;
190 
191     struct BuyFees{
192         uint256 liquidity;
193         uint256 selfBurn;
194         uint256 externalBurn;
195     }
196 
197     struct SellFees{
198         uint256 liquidity;
199         uint256 selfBurn;
200         uint256 externalBurn;
201     }
202 
203     BuyFees public buyFee;
204     SellFees public sellFee;
205 
206     uint256 private liquidityFee;
207     uint256 private selfBurnFee;
208     uint256 private externalBurnFee;
209     
210     bool private swapping;
211 
212     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
213         
214     constructor () {
215         balances[_msgSender()] = _tTotal;
216         
217         buyFee.liquidity = 4;
218         buyFee.selfBurn = 2;
219         buyFee.externalBurn = 2;
220 
221         sellFee.liquidity = 4;
222         sellFee.selfBurn = 2;
223         sellFee.externalBurn = 2;
224         
225         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
227 
228         uniswapV2Router = _uniswapV2Router;
229         uniswapV2Pair = _uniswapV2Pair;
230         
231         liquidityReceiver = msg.sender;
232         _isExcludedFromFee[msg.sender] = true;
233         _isExcludedFromFee[address(this)] = true;
234         
235         emit Transfer(address(0), _msgSender(), _tTotal);
236     }
237 
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241 
242     function symbol() public pure returns (string memory) {
243         return _symbol;
244     }
245 
246     function decimals() public pure returns (uint8) {
247         return _decimals;
248     }
249 
250     function totalSupply() public view override returns (uint256) {
251         return _tTotal;
252     }
253 
254     function balanceOf(address account) public view override returns (uint256) {
255         return balances[account];
256     }
257 
258     function transfer(address recipient, uint256 amount) public override returns (bool) {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262 
263     function allowance(address owner, address spender) public view override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     function approve(address spender, uint256 amount) public override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
273         _transfer(sender, recipient, amount);
274         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
275         return true;
276     }
277 
278     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
279         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
280         return true;
281     }
282 
283     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
284         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
285         return true;
286     }
287     
288     function excludeFromFee(address account) public onlyOwner {
289         _isExcludedFromFee[account] = true;
290     }
291     
292     function includeInFee(address account) public onlyOwner {
293         _isExcludedFromFee[account] = false;
294     }
295     
296     receive() external payable {}
297     
298     function ERC20TokenBurned(address tokenAddress) public view returns (uint256) {
299         return _erc20TokenBurned[tokenAddress];
300     }
301 
302     function takeBuyFees(uint256 amount, address from) private returns (uint256) {
303         uint256 liquidityFeeToken = amount * buyFee.liquidity / 100; 
304         uint256 selfBurnFeeToken = amount * buyFee.selfBurn / 100; 
305         uint256 externalBurnFeeToken = amount * buyFee.externalBurn / 100; 
306 
307         balances[address(this)] += liquidityFeeToken + externalBurnFeeToken;
308         balances[address(0x00)] += selfBurnFeeToken;
309         _tTotal -= selfBurnFeeToken;
310         totalTokenBurned += selfBurnFeeToken;
311 
312         emit Transfer (from, address(0x000), selfBurnFeeToken);
313         emit Transfer (from, address(this), externalBurnFeeToken + liquidityFeeToken);
314 
315         return (amount -liquidityFeeToken -selfBurnFeeToken -externalBurnFeeToken);
316     }
317 
318     function takeSellFees(uint256 amount, address from) private returns (uint256) {
319         uint256 liquidityFeeToken = amount * sellFee.liquidity / 100; 
320         uint256 selfBurnFeeToken = amount * sellFee.selfBurn / 100; 
321         uint256 externalBurnFeeToken = amount * sellFee.externalBurn / 100; 
322 
323         balances[address(this)] += liquidityFeeToken + externalBurnFeeToken;
324         balances[address(0x00)] += selfBurnFeeToken;
325         _tTotal -= selfBurnFeeToken;
326         totalTokenBurned += selfBurnFeeToken;
327 
328         emit Transfer (from, address(0x000), selfBurnFeeToken);
329         emit Transfer (from, address(this), externalBurnFeeToken + liquidityFeeToken);
330 
331         return (amount -liquidityFeeToken -selfBurnFeeToken -externalBurnFeeToken);
332     }
333 
334     function isExcludedFromFee(address account) public view returns(bool) {
335         return _isExcludedFromFee[account];
336     }
337     
338     function _approve(address owner, address spender, uint256 amount) private {
339         require(owner != address(0), "ERC20: approve from the zero address");
340         require(spender != address(0), "ERC20: approve to the zero address");
341 
342         _allowances[owner][spender] = amount;
343         emit Approval(owner, spender, amount);
344     }
345 
346     function setBuyFees(uint256 newLiquidityFee, uint256 newSelfBurnFee, uint256 newExternalBurnFee) public onlyOwner {
347         require(newLiquidityFee + newSelfBurnFee + newExternalBurnFee <= 25, "Can't set buyFee above 25%");
348         buyFee.liquidity = newLiquidityFee;
349         buyFee.selfBurn = newSelfBurnFee;
350         buyFee.externalBurn= newExternalBurnFee;
351     }
352 
353     function setSellFees(uint256 newLiquidityFee, uint256 newSelfBurnFee, uint256 newExternalBurnFee) public onlyOwner {
354         require(newLiquidityFee + newSelfBurnFee + newExternalBurnFee <= 25, "Can't set sellFee above 25%");
355         sellFee.liquidity = newLiquidityFee;
356         sellFee.selfBurn = newSelfBurnFee;
357         sellFee.externalBurn= newExternalBurnFee;
358     }
359 
360     function setMaxTxPercent(uint256 newMaxTxPercent) public onlyOwner {
361         require(newMaxTxPercent >= 1, "MaxTx atleast 1% or higher");
362         _maxTxAmount = _tTotal.mul(newMaxTxPercent).div(10**2);
363     }
364 
365     function setMaxWalletPercent(uint256 newMaxWalletPercent) public onlyOwner {
366         require(newMaxWalletPercent >= 1, "MaxWallet atleast 1% or higher");
367         _maxWalletAmount = _tTotal.mul(newMaxWalletPercent).div(10**2);    
368     }
369 
370     function setSwapTokenAtAmountPermille(uint256 newSwapTokenAmountPermille) public onlyOwner {
371         swapTokenAtAmount = _tTotal.mul(newSwapTokenAmountPermille).div(10**3);
372     }
373 
374     function buyAndBurnERC20Token(address tokenAddress, uint256 ethAmount) public onlyOwner {
375 	swapETHForExternalTokens(tokenAddress, ethAmount);
376     }
377 
378     function setLiquidityReceiver(address newLiqReceiver) public onlyOwner {
379         liquidityReceiver = newLiqReceiver;
380         _isExcludedFromFee[newLiqReceiver] = true;
381     }
382 
383     function _transfer(
384         address from,
385         address to,
386         uint256 amount
387     ) private {
388         require(from != address(0), "ERC20: transfer from the zero address");
389         require(to != address(0), "ERC20: transfer to the zero address");
390         require(amount > 0, "Transfer amount must be greater than zero");
391         
392         balances[from] -= amount;
393         uint256 transferAmount = amount;
394         
395         bool takeFee;
396 
397         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
398             takeFee = true;
399         } 
400 
401         if(takeFee){
402             if(to != uniswapV2Pair){
403                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxAmount");
404                 require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
405                  transferAmount = takeBuyFees(amount, from);
406             }
407 
408             if(from != uniswapV2Pair){
409                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxAmount");
410                 transferAmount = takeSellFees(amount, from);
411 
412                if (balanceOf(address(this)) >= swapTokenAtAmount && !swapping) {
413                     swapping = true;
414                     swapBack();
415                     swapping = false;
416               }
417             }
418 
419             if(to != uniswapV2Pair && from != uniswapV2Pair){
420                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxAmount");
421                 require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
422             }
423         }
424         
425         balances[to] += transferAmount;
426         emit Transfer(from, to, transferAmount);
427     }
428     
429     
430     function swapBack() private {
431         uint256 contractBalance = swapTokenAtAmount;
432         uint256 liquidityTokens = contractBalance * (buyFee.liquidity + sellFee.liquidity) / (buyFee.externalBurn + buyFee.liquidity + sellFee.externalBurn + sellFee.liquidity);
433         uint256 externalBurnTokens = contractBalance - liquidityTokens;
434         uint256 totalTokensToSwap = liquidityTokens + externalBurnTokens;
435         
436         uint256 tokensForLiquidity = liquidityTokens.div(2);
437         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
438         
439         uint256 initialETHBalance = address(this).balance;
440         swapTokensForEth(amountToSwapForETH); 
441         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
442         
443         uint256 ethForLiquidity = ethBalance.mul(liquidityTokens).div(totalTokensToSwap);
444 
445         addLiquidity(tokensForLiquidity, ethForLiquidity);
446     }
447 
448     function swapTokensForEth(uint256 tokenAmount) private {
449         address[] memory path = new address[](2);
450         path[0] = address(this);
451         path[1] = uniswapV2Router.WETH();
452 
453         _approve(address(this), address(uniswapV2Router), tokenAmount);
454 
455         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
456             tokenAmount,
457             0,
458             path,
459             address(this),
460             block.timestamp
461         );
462     }
463 
464     function swapETHForExternalTokens(address tokenToBuy, uint256 amount) private {
465         address[] memory path = new address[](2);
466         path[0] = uniswapV2Router.WETH();
467         path[1] = tokenToBuy;
468         
469         IERC20(uniswapV2Router.WETH()).approve(address(uniswapV2Router), amount);
470 
471         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
472             0,
473             path,
474             address(this),
475             block.timestamp
476         );
477 
478         uint256 tokenReceived = IERC20(tokenToBuy).balanceOf(address(this));
479         _erc20TokenBurned[tokenToBuy] += tokenReceived;
480         IERC20(tokenToBuy).transfer(address(0xdead), tokenReceived);
481     }
482 
483     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
484         _approve(address(this), address(uniswapV2Router), tokenAmount);
485 
486         uniswapV2Router.addLiquidityETH {value: ethAmount} (
487             address(this),
488             tokenAmount,
489             0,
490             0,
491             liquidityReceiver,
492             block.timestamp
493         );
494     }
495 }