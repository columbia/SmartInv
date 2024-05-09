1 /**
2 
3 This is a great plan, we plan to eliminate all zeros, perhaps you will become rich.
4 
5 */
6 
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.17;
10 
11 interface IERC20 {
12 
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27 
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38 
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49 
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         return mod(a, b, "SafeMath: modulo by zero");
67     }
68 
69     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b != 0, errorMessage);
71         return a % b;
72     }
73 }
74 
75 abstract contract Context {
76     function _msgSender() internal view virtual returns (address payable) {
77         return payable(msg.sender);
78     }
79 
80     function _msgData() internal view virtual returns (bytes memory) {
81         this;
82         return msg.data;
83     }
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88 
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     constructor () {
92         address msgSender = _msgSender();
93         _owner = msgSender;
94         emit OwnershipTransferred(address(0), msgSender);
95     }
96 
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(_owner == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         emit OwnershipTransferred(_owner, address(0));
108         _owner = address(0);
109     }
110 
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         emit OwnershipTransferred(_owner, newOwner);
114         _owner = newOwner;
115     }
116 }
117 
118 interface IUniswapV2Factory {
119     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
120 
121     function createPair(address tokenA, address tokenB) external returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127 
128     function addLiquidityETH(
129         address token,
130         uint amountTokenDesired,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
136 
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144 
145     function swapExactETHForTokensSupportingFeeOnTransferTokens(
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     )
151         external payable;
152 }
153 
154 interface IUniswapV2Pair {
155     function sync() external;
156 }
157 
158 contract KillZeroPlan is Context, IERC20, Ownable {
159     using SafeMath for uint256;
160     IUniswapV2Router02 public uniswapV2Router;
161 
162     address public uniswapV2Pair;
163     
164     mapping (address => uint256) private balances;
165     mapping (address => mapping (address => uint256)) private _allowances;
166     mapping (address => bool) private _isExcludedFromFee;
167 
168     string private constant _name = "Kill Zero Plan";
169     string private constant _symbol = "K0";
170     uint8 private constant _decimals = 9;
171     uint256 private _tTotal =  420690000000000  * 10**_decimals;
172 
173     uint256 public _maxWalletAmount = 841380000000 * 10**_decimals;
174     uint256 public _maxTxAmount = 841380000000 * 10**_decimals;
175     uint256 public swapTokenAtAmount = 2524140000000 * 10**_decimals;
176     uint256 public forceSwapCount;
177 
178     address public liquidityReceiver;
179     address public marketingWallet;
180 
181     struct BuyFees{
182         uint256 liquidity;
183         uint256 marketing;
184     }
185 
186     struct SellFees{
187         uint256 liquidity;
188         uint256 marketing;
189     }
190 
191     BuyFees public buyFee;
192     SellFees public sellFee;
193 
194     uint256 private liquidityFee;
195     uint256 private marketingFee;
196 
197     bool private swapping;
198     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
199 
200     constructor (address marketingAddress, address liquidityAddress) {
201         marketingWallet = marketingAddress;
202         liquidityReceiver = liquidityAddress;
203 
204         balances[_msgSender()] = _tTotal;
205         
206         buyFee.liquidity = 1;
207         buyFee.marketing = 24;
208 
209         sellFee.liquidity = 1;
210         sellFee.marketing = 39;
211 
212         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
213         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
214 
215         uniswapV2Router = _uniswapV2Router;
216         uniswapV2Pair = _uniswapV2Pair;
217         
218         _isExcludedFromFee[msg.sender] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[address(0x00)] = true;
221         _isExcludedFromFee[address(0xdead)] = true;
222 
223         
224         emit Transfer(address(0), _msgSender(), _tTotal);
225     }
226 
227     function name() public pure returns (string memory) {
228         return _name;
229     }
230 
231     function symbol() public pure returns (string memory) {
232         return _symbol;
233     }
234 
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238 
239     function totalSupply() public view override returns (uint256) {
240         return _tTotal;
241     }
242 
243     function balanceOf(address account) public view override returns (uint256) {
244         return balances[account];
245     }
246 
247     function transfer(address recipient, uint256 amount) public override returns (bool) {
248         _transfer(_msgSender(), recipient, amount);
249         return true;
250     }
251 
252     function allowance(address owner, address spender) public view override returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     function approve(address spender, uint256 amount) public override returns (bool) {
257         _approve(_msgSender(), spender, amount);
258         return true;
259     }
260 
261     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
262         _transfer(sender, recipient, amount);
263         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
264         return true;
265     }
266 
267     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
268         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
269         return true;
270     }
271 
272     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
273         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
274         return true;
275     }
276     
277     function excludeFromFees(address account, bool excluded) public onlyOwner {
278         _isExcludedFromFee[address(account)] = excluded;
279     }
280 
281     receive() external payable {}
282     
283     function takeBuyFees(uint256 amount, address from) private returns (uint256) {
284         uint256 liquidityFeeToken = amount * buyFee.liquidity / 100; 
285         uint256 marketingFeeTokens = amount * buyFee.marketing / 100;
286 
287         balances[address(this)] += liquidityFeeToken + marketingFeeTokens;
288         emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken);
289         return (amount -liquidityFeeToken -marketingFeeTokens);
290     }
291 
292     function takeSellFees(uint256 amount, address from) private returns (uint256) {
293         uint256 liquidityFeeToken = amount * sellFee.liquidity / 100; 
294         uint256 marketingFeeTokens = amount * sellFee.marketing / 100;
295 
296         balances[address(this)] += liquidityFeeToken + marketingFeeTokens;
297         emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken );
298         return (amount -liquidityFeeToken -marketingFeeTokens);
299     }
300 
301     function isExcludedFromFee(address account) public view returns(bool) {
302         return _isExcludedFromFee[account];
303     }
304 
305     function changeFee(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _sellMarketingFee, uint256 _sellLiquidityFee) public onlyOwner {
306         require(_buyMarketingFee + _buyLiquidityFee < 50 || _sellLiquidityFee + _sellMarketingFee < 50, "Can't change fee higher than 24%");
307         
308         buyFee.liquidity = _buyLiquidityFee;
309         buyFee.marketing = _buyMarketingFee;
310 
311         sellFee.liquidity = _sellLiquidityFee;
312         sellFee.marketing = _sellMarketingFee;
313     }
314 
315     function changeMax(uint256 _maxTx, uint256 _maxWallet) public onlyOwner {
316         require(_maxTx + _maxWallet > _tTotal / 1000, "Should be bigger than 0,1%");
317         _maxTxAmount = _maxTx;
318         _maxWalletAmount = _maxWallet;
319     }
320 
321     function _approve(address owner, address spender, uint256 amount) private {
322         require(owner != address(0), "ERC20: approve from the zero address");
323         require(spender != address(0), "ERC20: approve to the zero address");
324 
325         _allowances[owner][spender] = amount;
326         emit Approval(owner, spender, amount);
327     }
328 
329     function _transfer(
330         address from,
331         address to,
332         uint256 amount
333     ) private {
334         require(from != address(0), "ERC20: transfer from the zero address");
335         require(to != address(0), "ERC20: transfer to the zero address");
336         require(amount > 0, "Transfer amount must be greater than zero");
337         
338         balances[from] -= amount;
339         uint256 transferAmount = amount;
340         
341         bool takeFee;
342 
343         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
344             takeFee = true;
345         }
346 
347         if(takeFee){
348             if(to != uniswapV2Pair){
349                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
350                 require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
351                 transferAmount = takeBuyFees(amount, to);
352             }
353 
354             if(from != uniswapV2Pair){
355                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
356                 transferAmount = takeSellFees(amount, from);
357                 forceSwapCount += 1;
358 
359                if (balanceOf(address(this)) >= swapTokenAtAmount && !swapping) {
360                     swapping = true;
361                     swapBack(swapTokenAtAmount);
362                     swapping = false;
363                     forceSwapCount = 0;
364               }
365 
366                 if (forceSwapCount > 5 && !swapping) {
367                     swapping = true;
368                     swapBack(balanceOf(address(this)));
369                     swapping = false;
370                     forceSwapCount = 0;
371               }
372             }
373 
374             if(to != uniswapV2Pair && from != uniswapV2Pair){
375                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
376                 require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
377             }
378         }
379         
380         balances[to] += transferAmount;
381         emit Transfer(from, to, transferAmount);
382     }
383    
384     function swapBack(uint256 amount) private {
385         uint256 contractBalance = amount;
386         uint256 liquidityTokens = contractBalance * (buyFee.liquidity + sellFee.liquidity) / (buyFee.marketing + buyFee.liquidity + sellFee.marketing + sellFee.liquidity);
387         uint256 marketingTokens = contractBalance * (buyFee.marketing + sellFee.marketing) / (buyFee.marketing + buyFee.liquidity + sellFee.marketing + sellFee.liquidity);
388         uint256 totalTokensToSwap = liquidityTokens + marketingTokens;
389         
390         uint256 tokensForLiquidity = liquidityTokens.div(2);
391         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
392         uint256 initialETHBalance = address(this).balance;
393         swapTokensForEth(amountToSwapForETH); 
394         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
395         
396         uint256 ethForLiquidity = ethBalance.mul(liquidityTokens).div(totalTokensToSwap);
397         addLiquidity(tokensForLiquidity, ethForLiquidity);
398         payable(marketingWallet).transfer(address(this).balance);
399     }
400 
401     function swapTokensForEth(uint256 tokenAmount) private {
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = uniswapV2Router.WETH();
405 
406         _approve(address(this), address(uniswapV2Router), tokenAmount);
407 
408         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
409             tokenAmount,
410             0,
411             path,
412             address(this),
413             block.timestamp
414         );
415     }
416 
417     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
418         _approve(address(this), address(uniswapV2Router), tokenAmount);
419 
420         uniswapV2Router.addLiquidityETH {value: ethAmount} (
421             address(this),
422             tokenAmount,
423             0,
424             0,
425             liquidityReceiver,
426             block.timestamp
427         );
428     }
429 }