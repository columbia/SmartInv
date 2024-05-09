1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Shibag Tools
5 ($SHIBAG) is a suite of tools provided by Shibag Tools to support the Shibarium ecosystem by offering various DAPPs that serve the Shibarium economy.
6 
7 Telegram : https://t.me/ShibagTools
8 website  : https://5hibagtools.com/
9 */
10 pragma solidity ^0.8.17;
11 
12 interface IERC20 {
13 
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return mod(a, b, "SafeMath: modulo by zero");
68     }
69 
70     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b != 0, errorMessage);
72         return a % b;
73     }
74 }
75 
76 abstract contract Context {
77     function _msgSender() internal view virtual returns (address payable) {
78         return payable(msg.sender);
79     }
80 
81     function _msgData() internal view virtual returns (bytes memory) {
82         this;
83         return msg.data;
84     }
85 }
86 
87 contract Ownable is Context {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     constructor () {
93         address msgSender = _msgSender();
94         _owner = msgSender;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(newOwner != address(0), "Ownable: new owner is the zero address");
114         emit OwnershipTransferred(_owner, newOwner);
115         _owner = newOwner;
116     }
117 }
118 
119 interface IUniswapV2Factory {
120     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
121 
122     function createPair(address tokenA, address tokenB) external returns (address pair);
123 }
124 
125 interface IUniswapV2Router02 {
126     function factory() external pure returns (address);
127     function WETH() external pure returns (address);
128 
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137 
138     function swapExactTokensForETHSupportingFeeOnTransferTokens(
139         uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external;
145 
146     function swapExactETHForTokensSupportingFeeOnTransferTokens(
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     )
152         external payable;
153 }
154 
155 interface IUniswapV2Pair {
156     function sync() external;
157 }
158 
159 contract ShibagTools is Context, IERC20, Ownable {
160     using SafeMath for uint256;
161     IUniswapV2Router02 public uniswapV2Router;
162 
163     address public uniswapV2Pair;
164     
165     mapping (address => uint256) private balances;
166     mapping (address => mapping (address => uint256)) private _allowances;
167     mapping (address => bool) private _isExcludedFromFee;
168 
169     string private constant _name = "Shibag Tools";
170     string private constant _symbol = "SHIBAG";
171     uint8 private constant _decimals = 9;
172     uint256 private _tTotal =  100000000  * 10**_decimals;
173 
174     uint256 public _maxWalletAmount = 2000000 * 10**_decimals;
175     uint256 public _maxTxAmount = 2000000 * 10**_decimals;
176     uint256 public swapTokenAtAmount = 200000 * 10**_decimals;
177     uint256 public forceSwapCount;
178 
179     address public liquidityReceiver;
180     address public marketingWallet;
181 
182     struct BuyFees{
183         uint256 liquidity;
184         uint256 marketing;
185     }
186 
187     struct SellFees{
188         uint256 liquidity;
189         uint256 marketing;
190     }
191 
192     BuyFees public buyFee;
193     SellFees public sellFee;
194 
195     uint256 private liquidityFee;
196     uint256 private marketingFee;
197 
198     bool private swapping;
199     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
200 
201     constructor (address marketingAddress, address liquidityAddress) {
202         marketingWallet = marketingAddress;
203         liquidityReceiver = liquidityAddress;
204 
205         balances[_msgSender()] = _tTotal;
206         
207         buyFee.liquidity = 2;
208         buyFee.marketing = 8;
209 
210         sellFee.liquidity = 5;
211         sellFee.marketing = 15;
212 
213         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
215 
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = _uniswapV2Pair;
218         
219         _isExcludedFromFee[msg.sender] = true;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[address(0x00)] = true;
222         _isExcludedFromFee[address(0xdead)] = true;
223 
224         
225         emit Transfer(address(0), _msgSender(), _tTotal);
226     }
227 
228     function name() public pure returns (string memory) {
229         return _name;
230     }
231 
232     function symbol() public pure returns (string memory) {
233         return _symbol;
234     }
235 
236     function decimals() public pure returns (uint8) {
237         return _decimals;
238     }
239 
240     function totalSupply() public view override returns (uint256) {
241         return _tTotal;
242     }
243 
244     function balanceOf(address account) public view override returns (uint256) {
245         return balances[account];
246     }
247 
248     function transfer(address recipient, uint256 amount) public override returns (bool) {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     function allowance(address owner, address spender) public view override returns (uint256) {
254         return _allowances[owner][spender];
255     }
256 
257     function approve(address spender, uint256 amount) public override returns (bool) {
258         _approve(_msgSender(), spender, amount);
259         return true;
260     }
261 
262     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
263         _transfer(sender, recipient, amount);
264         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
265         return true;
266     }
267 
268     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
269         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
270         return true;
271     }
272 
273     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
274         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
275         return true;
276     }
277     
278     function excludeFromFees(address account, bool excluded) public onlyOwner {
279         _isExcludedFromFee[address(account)] = excluded;
280     }
281 
282     receive() external payable {}
283     
284     function takeBuyFees(uint256 amount, address from) private returns (uint256) {
285         uint256 liquidityFeeToken = amount * buyFee.liquidity / 100; 
286         uint256 marketingFeeTokens = amount * buyFee.marketing / 100;
287 
288         balances[address(this)] += liquidityFeeToken + marketingFeeTokens;
289         emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken);
290         return (amount -liquidityFeeToken -marketingFeeTokens);
291     }
292 
293     function takeSellFees(uint256 amount, address from) private returns (uint256) {
294         uint256 liquidityFeeToken = amount * sellFee.liquidity / 100; 
295         uint256 marketingFeeTokens = amount * sellFee.marketing / 100;
296 
297         balances[address(this)] += liquidityFeeToken + marketingFeeTokens;
298         emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken );
299         return (amount -liquidityFeeToken -marketingFeeTokens);
300     }
301 
302     function isExcludedFromFee(address account) public view returns(bool) {
303         return _isExcludedFromFee[account];
304     }
305 
306     function changeFee(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _sellMarketingFee, uint256 _sellLiquidityFee) public onlyOwner {
307         require(_buyMarketingFee + _buyLiquidityFee < 25 || _sellLiquidityFee + _sellMarketingFee < 25, "Can't change fee higher than 24%");
308         
309         buyFee.liquidity = _buyLiquidityFee;
310         buyFee.marketing = _buyMarketingFee;
311 
312         sellFee.liquidity = _sellLiquidityFee;
313         sellFee.marketing = _sellMarketingFee;
314     }
315 
316     function changeMax(uint256 _maxTx, uint256 _maxWallet) public onlyOwner {
317         require(_maxTx + _maxWallet > _tTotal / 1000, "Should be bigger than 0,1%");
318         _maxTxAmount = _maxTx;
319         _maxWalletAmount = _maxWallet;
320     }
321 
322     function _approve(address owner, address spender, uint256 amount) private {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325 
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329 
330     function _transfer(
331         address from,
332         address to,
333         uint256 amount
334     ) private {
335         require(from != address(0), "ERC20: transfer from the zero address");
336         require(to != address(0), "ERC20: transfer to the zero address");
337         require(amount > 0, "Transfer amount must be greater than zero");
338         
339         balances[from] -= amount;
340         uint256 transferAmount = amount;
341         
342         bool takeFee;
343 
344         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
345             takeFee = true;
346         }
347 
348         if(takeFee){
349             if(to != uniswapV2Pair){
350                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
351                 require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
352                 transferAmount = takeBuyFees(amount, to);
353             }
354 
355             if(from != uniswapV2Pair){
356                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
357                 transferAmount = takeSellFees(amount, from);
358                 forceSwapCount += 1;
359 
360                if (balanceOf(address(this)) >= swapTokenAtAmount && !swapping) {
361                     swapping = true;
362                     swapBack(swapTokenAtAmount);
363                     swapping = false;
364                     forceSwapCount = 0;
365               }
366 
367                 if (forceSwapCount > 5 && !swapping) {
368                     swapping = true;
369                     swapBack(balanceOf(address(this)));
370                     swapping = false;
371                     forceSwapCount = 0;
372               }
373             }
374 
375             if(to != uniswapV2Pair && from != uniswapV2Pair){
376                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
377                 require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
378             }
379         }
380         
381         balances[to] += transferAmount;
382         emit Transfer(from, to, transferAmount);
383     }
384    
385     function swapBack(uint256 amount) private {
386         uint256 contractBalance = amount;
387         uint256 liquidityTokens = contractBalance * (buyFee.liquidity + sellFee.liquidity) / (buyFee.marketing + buyFee.liquidity + sellFee.marketing + sellFee.liquidity);
388         uint256 marketingTokens = contractBalance * (buyFee.marketing + sellFee.marketing) / (buyFee.marketing + buyFee.liquidity + sellFee.marketing + sellFee.liquidity);
389         uint256 totalTokensToSwap = liquidityTokens + marketingTokens;
390         
391         uint256 tokensForLiquidity = liquidityTokens.div(2);
392         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
393         uint256 initialETHBalance = address(this).balance;
394         swapTokensForEth(amountToSwapForETH); 
395         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
396         
397         uint256 ethForLiquidity = ethBalance.mul(liquidityTokens).div(totalTokensToSwap);
398         addLiquidity(tokensForLiquidity, ethForLiquidity);
399         payable(marketingWallet).transfer(address(this).balance);
400     }
401 
402     function swapTokensForEth(uint256 tokenAmount) private {
403         address[] memory path = new address[](2);
404         path[0] = address(this);
405         path[1] = uniswapV2Router.WETH();
406 
407         _approve(address(this), address(uniswapV2Router), tokenAmount);
408 
409         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
410             tokenAmount,
411             0,
412             path,
413             address(this),
414             block.timestamp
415         );
416     }
417 
418     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
419         _approve(address(this), address(uniswapV2Router), tokenAmount);
420 
421         uniswapV2Router.addLiquidityETH {value: ethAmount} (
422             address(this),
423             tokenAmount,
424             0,
425             0,
426             liquidityReceiver,
427             block.timestamp
428         );
429     }
430 }