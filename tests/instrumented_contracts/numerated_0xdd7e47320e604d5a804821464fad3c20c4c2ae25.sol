1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Xile Protocol - $XILE
5 Xile Protocol effectively tracks unusual on-chain behavior,
6 thawing fraudulent transactions, and recovering stolen funds by integrating community-driven threat recognition algorithms with a special stake-based reporting system.
7 Xile Protocol adds a new layer of blockchain transaction security, shielding selected projects and communities from malicious exploits and financial loss.
8 
9 Telegram : https://t.me/XileProtocol
10 website  : https://xileprotocol.com/
11 */
12 pragma solidity ^0.8.17;
13 
14 interface IERC20 {
15 
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49 
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52 
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64 
65         return c;
66     }
67 
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         return mod(a, b, "SafeMath: modulo by zero");
70     }
71 
72     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b != 0, errorMessage);
74         return a % b;
75     }
76 }
77 
78 abstract contract Context {
79     function _msgSender() internal view virtual returns (address payable) {
80         return payable(msg.sender);
81     }
82 
83     function _msgData() internal view virtual returns (bytes memory) {
84         this;
85         return msg.data;
86     }
87 }
88 
89 contract Ownable is Context {
90     address private _owner;
91 
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     constructor () {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 
114     function transferOwnership(address newOwner) public virtual onlyOwner {
115         require(newOwner != address(0), "Ownable: new owner is the zero address");
116         emit OwnershipTransferred(_owner, newOwner);
117         _owner = newOwner;
118     }
119 }
120 
121 interface IUniswapV2Factory {
122     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
123 
124     function createPair(address tokenA, address tokenB) external returns (address pair);
125 }
126 
127 interface IUniswapV2Router02 {
128     function factory() external pure returns (address);
129     function WETH() external pure returns (address);
130 
131     function addLiquidityETH(
132         address token,
133         uint amountTokenDesired,
134         uint amountTokenMin,
135         uint amountETHMin,
136         address to,
137         uint deadline
138     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
139 
140     function swapExactTokensForETHSupportingFeeOnTransferTokens(
141         uint amountIn,
142         uint amountOutMin,
143         address[] calldata path,
144         address to,
145         uint deadline
146     ) external;
147 
148     function swapExactETHForTokensSupportingFeeOnTransferTokens(
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     )
154         external payable;
155 }
156 
157 interface IUniswapV2Pair {
158     function sync() external;
159 }
160 
161 contract XileProtocol is Context, IERC20, Ownable {
162     using SafeMath for uint256;
163     IUniswapV2Router02 public uniswapV2Router;
164 
165     address public uniswapV2Pair;
166     
167     mapping (address => uint256) private balances;
168     mapping (address => mapping (address => uint256)) private _allowances;
169     mapping (address => bool) private _isExcludedFromFee;
170 
171     string private constant _name = "Xile Protocol";
172     string private constant _symbol = "XILE";
173     uint8 private constant _decimals = 9;
174     uint256 private _tTotal =  1000000000  * 10**_decimals;
175 
176     uint256 public _maxWalletAmount = 20000000 * 10**_decimals;
177     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
178     uint256 public swapTokenAtAmount = 10000000 * 10**_decimals;
179     uint256 public forceSwapCount;
180 
181     address public liquidityReceiver;
182     address public marketingWallet;
183 
184     struct BuyFees{
185         uint256 liquidity;
186         uint256 marketing;
187     }
188 
189     struct SellFees{
190         uint256 liquidity;
191         uint256 marketing;
192     }
193 
194     BuyFees public buyFee;
195     SellFees public sellFee;
196 
197     uint256 private liquidityFee;
198     uint256 private marketingFee;
199 
200     bool private swapping;
201     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
202 
203     constructor (address marketingAddress, address liquidityAddress) {
204         marketingWallet = marketingAddress;
205         liquidityReceiver = liquidityAddress;
206 
207         balances[_msgSender()] = _tTotal;
208         
209         buyFee.liquidity = 2;
210         buyFee.marketing = 13;
211 
212         sellFee.liquidity = 5;
213         sellFee.marketing = 15;
214 
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
216         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
217 
218         uniswapV2Router = _uniswapV2Router;
219         uniswapV2Pair = _uniswapV2Pair;
220         
221         _isExcludedFromFee[msg.sender] = true;
222         _isExcludedFromFee[address(this)] = true;
223         _isExcludedFromFee[address(0x00)] = true;
224         _isExcludedFromFee[address(0xdead)] = true;
225 
226         
227         emit Transfer(address(0), _msgSender(), _tTotal);
228     }
229 
230     function name() public pure returns (string memory) {
231         return _name;
232     }
233 
234     function symbol() public pure returns (string memory) {
235         return _symbol;
236     }
237 
238     function decimals() public pure returns (uint8) {
239         return _decimals;
240     }
241 
242     function totalSupply() public view override returns (uint256) {
243         return _tTotal;
244     }
245 
246     function balanceOf(address account) public view override returns (uint256) {
247         return balances[account];
248     }
249 
250     function transfer(address recipient, uint256 amount) public override returns (bool) {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     function allowance(address owner, address spender) public view override returns (uint256) {
256         return _allowances[owner][spender];
257     }
258 
259     function approve(address spender, uint256 amount) public override returns (bool) {
260         _approve(_msgSender(), spender, amount);
261         return true;
262     }
263 
264     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
265         _transfer(sender, recipient, amount);
266         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
267         return true;
268     }
269 
270     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
271         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
272         return true;
273     }
274 
275     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
276         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
277         return true;
278     }
279     
280     function excludeFromFees(address account, bool excluded) public onlyOwner {
281         _isExcludedFromFee[address(account)] = excluded;
282     }
283 
284     receive() external payable {}
285     
286     function takeBuyFees(uint256 amount, address from) private returns (uint256) {
287         uint256 liquidityFeeToken = amount * buyFee.liquidity / 100; 
288         uint256 marketingFeeTokens = amount * buyFee.marketing / 100;
289 
290         balances[address(this)] += liquidityFeeToken + marketingFeeTokens;
291         emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken);
292         return (amount -liquidityFeeToken -marketingFeeTokens);
293     }
294 
295     function takeSellFees(uint256 amount, address from) private returns (uint256) {
296         uint256 liquidityFeeToken = amount * sellFee.liquidity / 100; 
297         uint256 marketingFeeTokens = amount * sellFee.marketing / 100;
298 
299         balances[address(this)] += liquidityFeeToken + marketingFeeTokens;
300         emit Transfer (from, address(this), marketingFeeTokens + liquidityFeeToken );
301         return (amount -liquidityFeeToken -marketingFeeTokens);
302     }
303 
304     function isExcludedFromFee(address account) public view returns(bool) {
305         return _isExcludedFromFee[account];
306     }
307 
308     function changeFee(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _sellMarketingFee, uint256 _sellLiquidityFee) public onlyOwner {
309         require(_buyMarketingFee + _buyLiquidityFee < 25 || _sellLiquidityFee + _sellMarketingFee < 25, "Can't change fee higher than 24%");
310         
311         buyFee.liquidity = _buyLiquidityFee;
312         buyFee.marketing = _buyMarketingFee;
313 
314         sellFee.liquidity = _sellLiquidityFee;
315         sellFee.marketing = _sellMarketingFee;
316     }
317 
318     function changeMax(uint256 _maxTx, uint256 _maxWallet) public onlyOwner {
319         require(_maxTx + _maxWallet > _tTotal / 1000, "Should be bigger than 0,1%");
320         _maxTxAmount = _maxTx;
321         _maxWalletAmount = _maxWallet;
322     }
323 
324     function _approve(address owner, address spender, uint256 amount) private {
325         require(owner != address(0), "ERC20: approve from the zero address");
326         require(spender != address(0), "ERC20: approve to the zero address");
327 
328         _allowances[owner][spender] = amount;
329         emit Approval(owner, spender, amount);
330     }
331 
332     function _transfer(
333         address from,
334         address to,
335         uint256 amount
336     ) private {
337         require(from != address(0), "ERC20: transfer from the zero address");
338         require(to != address(0), "ERC20: transfer to the zero address");
339         require(amount > 0, "Transfer amount must be greater than zero");
340         
341         balances[from] -= amount;
342         uint256 transferAmount = amount;
343         
344         bool takeFee;
345 
346         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
347             takeFee = true;
348         }
349 
350         if(takeFee){
351             if(to != uniswapV2Pair){
352                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
353                 require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
354                 transferAmount = takeBuyFees(amount, to);
355             }
356 
357             if(from != uniswapV2Pair){
358                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
359                 transferAmount = takeSellFees(amount, from);
360                 forceSwapCount += 1;
361 
362                if (balanceOf(address(this)) >= swapTokenAtAmount && !swapping) {
363                     swapping = true;
364                     swapBack(swapTokenAtAmount);
365                     swapping = false;
366                     forceSwapCount = 0;
367               }
368 
369                 if (forceSwapCount > 5 && !swapping) {
370                     swapping = true;
371                     swapBack(balanceOf(address(this)));
372                     swapping = false;
373                     forceSwapCount = 0;
374               }
375             }
376 
377             if(to != uniswapV2Pair && from != uniswapV2Pair){
378                 require(amount <= _maxTxAmount, "Transfer Amount exceeds the maxTxnsAmount");
379                 require(balanceOf(to) + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
380             }
381         }
382         
383         balances[to] += transferAmount;
384         emit Transfer(from, to, transferAmount);
385     }
386    
387     function swapBack(uint256 amount) private {
388         uint256 contractBalance = amount;
389         uint256 liquidityTokens = contractBalance * (buyFee.liquidity + sellFee.liquidity) / (buyFee.marketing + buyFee.liquidity + sellFee.marketing + sellFee.liquidity);
390         uint256 marketingTokens = contractBalance * (buyFee.marketing + sellFee.marketing) / (buyFee.marketing + buyFee.liquidity + sellFee.marketing + sellFee.liquidity);
391         uint256 totalTokensToSwap = liquidityTokens + marketingTokens;
392         
393         uint256 tokensForLiquidity = liquidityTokens.div(2);
394         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
395         uint256 initialETHBalance = address(this).balance;
396         swapTokensForEth(amountToSwapForETH); 
397         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
398         
399         uint256 ethForLiquidity = ethBalance.mul(liquidityTokens).div(totalTokensToSwap);
400         addLiquidity(tokensForLiquidity, ethForLiquidity);
401         payable(marketingWallet).transfer(address(this).balance);
402     }
403 
404     function swapTokensForEth(uint256 tokenAmount) private {
405         address[] memory path = new address[](2);
406         path[0] = address(this);
407         path[1] = uniswapV2Router.WETH();
408 
409         _approve(address(this), address(uniswapV2Router), tokenAmount);
410 
411         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
412             tokenAmount,
413             0,
414             path,
415             address(this),
416             block.timestamp
417         );
418     }
419 
420     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
421         _approve(address(this), address(uniswapV2Router), tokenAmount);
422 
423         uniswapV2Router.addLiquidityETH {value: ethAmount} (
424             address(this),
425             tokenAmount,
426             0,
427             0,
428             liquidityReceiver,
429             block.timestamp
430         );
431     }
432 }