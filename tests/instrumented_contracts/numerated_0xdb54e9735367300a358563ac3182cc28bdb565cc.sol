1 /*
2 Submitted for verification at Etherscan.io on 2021-06-09
3 
4 https://cowboyshiba.com
5 
6 Tokenomics @ Launch:
7 1. 1,000,000,000,000 Total Supply
8 2. 20% - Burned
9 3. 3% - Marketing
10 4. 2.5% - Dev
11 5. 1% - Charity
12 6. 2% - AirDrops
13 7. 71.5% - Liquidity Locked Forever
14 8. 0.3% Buy Limit (until lifted)
15 9. Ownership Renounced
16 
17 Tokenomics Taxation:
18 1. Sells limited to 2% of the Liquidity Pool, <1.9% price impact 
19 2. 3% - Pool
20 3. 2% - Redistribution sent to all holders for all buys
21 4. 2% - Marketing
22 5. 1% - Charity
23 6. 1% - Burned
24 
25 SPDX-License-Identifier: MIT
26 */
27 
28 pragma solidity ^0.8.4;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 }
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61         return c;
62     }
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76 
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b > 0, errorMessage);
79         uint256 c = a / b;
80         return c;
81     }
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86     address private _previousOwner;
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     constructor() {
90         address msgSender = _msgSender();
91         _owner = msgSender;
92         emit OwnershipTransferred(address(0), msgSender);
93     }
94 
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103     
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 
110     function renounceOwnership() public virtual onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = address(0);
113     }
114 }
115 
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB) external returns (address pair);
118 }
119 
120 interface IUniswapV2Router02 {
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint256 amountIn,
123         uint256 amountOutMin,
124         address[] calldata path,
125         address to,
126         uint256 deadline
127     ) external;
128     function factory() external pure returns (address);
129     function WETH() external pure returns (address);
130     function addLiquidityETH(
131         address token,
132         uint256 amountTokenDesired,
133         uint256 amountTokenMin,
134         uint256 amountETHMin,
135         address to,
136         uint256 deadline
137     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
138 }
139 
140 contract CowboyShiba is Context, IERC20, Ownable {
141     using SafeMath for uint256;
142     string private constant _name = "Cowboy Shiba";
143     string private constant _symbol = "CBSHIB";
144     uint8 private constant _decimals = 9;
145     mapping(address => bool) private bots;
146     mapping(address => uint256) private _rOwned;
147     mapping(address => uint256) private _tOwned;
148     mapping(address => mapping(address => uint256)) private _allowances;
149     mapping(address => bool) private _isExcludedFromFee;
150     uint256 private constant MAX = ~uint256(0);
151     uint256 private  _tTotal = 1000000000000 * 10**9;
152     uint256 private _rTotal = (MAX - (MAX % _tTotal));
153     uint256 private _tFeeTotal;
154     uint256 private _dynamicFee = 3; //value used as "pool_fee", "marketing_fee" "tax_fee", "charity_fee", "burn_fee" respectfully using safemath in functions
155     mapping(address => uint256) private buycooldown;
156     address private _devAddress;
157     address private _marketingAddress;
158     address private _charityAddress;
159     address private _burnAddress;
160     address private _poolAddress;
161     IUniswapV2Router02 private uniswapV2Router;
162     address private uniswapV2Pair;
163     bool private tradingOpen = false;
164     bool private liquidityAdded = false;
165     bool private inSwap = false;
166     bool private swapEnabled = false;
167     uint256 private _maxTxPct = 3;
168     event MaxTxPctUpdated(uint256 _maxTxPct);
169     modifier lockTheSwap {
170         inSwap = true;
171         _;
172         inSwap = false;
173     }
174     
175     constructor () {
176         _isExcludedFromFee[owner()] = true;
177         _isExcludedFromFee[address(this)] = true;
178         _rOwned[_msgSender()] = _rTotal;
179         emit Transfer(address(0), _msgSender(), _tTotal);
180     }
181 
182     function name() public pure returns (string memory) {
183         return _name;
184     }
185 
186     function symbol() public pure returns (string memory) {
187         return _symbol;
188     }
189 
190     function decimals() public pure returns (uint8) {
191         return _decimals;
192     }
193 
194     function totalSupply() public view override returns (uint256) {
195         return _tTotal;
196     }
197 
198     function balanceOf(address account) public view override returns (uint256) {
199         return tokenFromReflection(_rOwned[account]);
200     }
201 
202     function transfer(address recipient, uint256 amount) public override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     function allowance(address owner, address spender) public view override returns (uint256) {
208         return _allowances[owner][spender];
209     }
210 
211     function approve(address spender, uint256 amount) public override returns (bool) {
212         _approve(_msgSender(), spender, amount);
213         return true;
214     }
215 
216     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
217         _transfer(sender, recipient, amount);
218         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
219         return true;
220     }
221 
222     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
223         require(rAmount <= _rTotal,"Amount must be less than total reflections");
224         uint256 currentRate = _getRate();
225         return rAmount.div(currentRate);
226     }
227     
228     function removeAllFee() private {
229         if (_dynamicFee == 0) return;
230         _dynamicFee = 0;
231     }
232 
233     function restoreAllFee() private {
234         _dynamicFee = 3;
235     }
236 
237     function _approve(address owner, address spender, uint256 amount) private {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240         _allowances[owner][spender] = amount;
241         emit Approval(owner, spender, amount);
242     }
243 
244     function _transfer(address from, address to, uint256 amount) private {
245         require(from != address(0), "ERC20: transfer from the zero address");
246         require(to != address(0), "ERC20: transfer to the zero address");
247         require(amount > 0, "Transfer amount must be greater than zero");
248 
249         if (from != owner() && to != owner()) {
250             require(!bots[from] && !bots[to]);
251             uint256 maxTxAmount = _tTotal.mul(_maxTxPct).div(10**3);
252             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
253                 require(tradingOpen);
254                 require(amount <= maxTxAmount);
255                 require(buycooldown[to] < block.timestamp);
256                 buycooldown[to] = block.timestamp + (30 seconds);
257             }
258             uint256 contractTokenBalance = balanceOf(address(this));
259             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
260                 require(amount <= balanceOf(uniswapV2Pair).mul(2).div(100));
261                 if (from != address(this) && to != address(this) && contractTokenBalance > 0) {
262                     if (_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair) {
263                         swapTokensForEth(contractTokenBalance);
264                     }
265                 }
266             }
267         }
268         bool takeFee = true;
269 
270         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
271             takeFee = false;
272         }
273 
274         _tokenTransfer(from, to, amount, takeFee);
275         restoreAllFee;
276     }
277 
278     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
279         address[] memory path = new address[](2);
280         path[0] = address(this);
281         path[1] = uniswapV2Router.WETH();
282         _approve(address(this), address(uniswapV2Router), tokenAmount);
283         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
284     }
285     
286     function openTrading() public onlyOwner {
287         require(liquidityAdded);
288         tradingOpen = true;
289     }
290     
291     function maxTxAmount() public view returns (uint256) {
292        return _tTotal.mul(_maxTxPct).div(10**3);
293     }
294     
295     function isMarketing(address account) public view returns (bool) {
296         return account == _marketingAddress;
297     }
298     function isDev(address account) public view returns (bool) {
299         return account == _devAddress;
300     }
301     function isCharity(address account) public view returns (bool) {
302         return account == _charityAddress;
303     }
304     function isPool(address account) public view returns (bool) {
305         return account == _poolAddress;
306     }
307     
308     function setBotAddress(address account) external onlyOwner() {
309         require(!bots[account], "Account is already identified as a bot");
310         bots[account] = true;
311     }
312     function revertSetBotAddress(address account) external onlyOwner() {
313         require(bots[account], "Account is not identified as a bot");
314         bots[account] = false;
315     }
316     
317     function setCharityAddress(address charityAddress) external onlyOwner {
318         _isExcludedFromFee[_charityAddress] = false;
319         _charityAddress = charityAddress;
320         _isExcludedFromFee[_charityAddress] = true;
321     }
322 
323     function setBurnAddress(address burnAddress) external onlyOwner {
324         _isExcludedFromFee[_burnAddress] = false;
325         _burnAddress = burnAddress;
326         _isExcludedFromFee[_burnAddress] = true;
327     }
328     
329     function setDevAddress(address devAddress) external onlyOwner {
330         _isExcludedFromFee[_devAddress] = false;
331         _devAddress = devAddress;
332         _isExcludedFromFee[_devAddress] = true;
333     }
334     
335     function setMarketingAddress(address marketingAddress) external onlyOwner {
336         _isExcludedFromFee[_marketingAddress] = false;
337         _marketingAddress = marketingAddress;
338         _isExcludedFromFee[_marketingAddress] = true;
339     }
340     
341     function setPoolAddress(address poolAddress) external onlyOwner {
342         _isExcludedFromFee[_poolAddress] = false;
343         _poolAddress = poolAddress;
344         _isExcludedFromFee[_poolAddress] = true;
345     }
346 
347     function addLiquidity() external onlyOwner() {
348         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
349         uniswapV2Router = _uniswapV2Router;
350         _approve(address(this), address(uniswapV2Router), _tTotal);
351         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
352         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
353         swapEnabled = true;
354         liquidityAdded = true;
355         _maxTxPct = 3;
356         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
357     }
358 
359     function manualswap() external {
360         require(_msgSender() == owner());
361         uint256 contractBalance = balanceOf(address(this));
362         swapTokensForEth(contractBalance);
363     }
364 
365     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
366         if (!takeFee) removeAllFee();
367         _transferStandard(sender, recipient, amount);
368         if (!takeFee) restoreAllFee();
369     }
370 
371     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
372         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tDynamic) = _getValues(tAmount);
373         _rOwned[sender] = _rOwned[sender].sub(rAmount);
374         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
375         _transferFees(sender, tDynamic);
376         _reflectFee(rFee, tDynamic);
377         emit Transfer(sender, recipient, tTransferAmount);
378     }
379 
380     function _transferFees(address sender, uint256 tDynamic) private {
381         uint256 currentRate = _getRate();
382         
383         if (tDynamic == 0) return;
384             
385         uint256 tDynamicOneThird = tDynamic.div(3);
386         
387         uint256 tMarketing = tDynamic.sub(tDynamicOneThird);
388         uint256 rMarketing = tMarketing.mul(currentRate);
389         _tOwned[_marketingAddress] = _tOwned[_marketingAddress].add(tMarketing);
390         _rOwned[_marketingAddress] = _rOwned[_marketingAddress].add(rMarketing);
391         emit Transfer(sender, _marketingAddress, tMarketing);
392         
393         uint256 tCharity = tDynamic.sub(tDynamicOneThird).sub(tDynamicOneThird);
394         uint256 rCharity = tCharity.mul(currentRate);
395         _tOwned[_charityAddress] = _tOwned[_charityAddress].add(tCharity);
396         _rOwned[_charityAddress] = _rOwned[_charityAddress].add(rCharity);
397         emit Transfer(sender, _charityAddress, tCharity);
398         
399         uint256 rPool = tDynamic.mul(currentRate); // tDynamic == tPool == 3%
400         _tOwned[_poolAddress] = _tOwned[_poolAddress].add(tDynamic);
401         _rOwned[_poolAddress] = _rOwned[_poolAddress].add(rPool);
402         emit Transfer(sender, _poolAddress, tDynamic);
403         
404         uint256 rBurn = rCharity;
405         _tOwned[_burnAddress] = _tOwned[_burnAddress].add(tCharity);
406         _rOwned[_burnAddress] = _rOwned[_burnAddress].add(rBurn);
407         emit Transfer(sender, _burnAddress, tCharity); // tCharity == tBurn == 1%
408         
409     }
410     
411     function _reflectFee(uint256 rFee, uint256 tDynamic) private {
412         _rTotal = _rTotal.sub(rFee);
413         
414         if (tDynamic != 0)
415             _tFeeTotal = _tFeeTotal.add(tDynamic.sub(tDynamic.div(3)));
416     }
417 
418     receive() external payable {}
419 
420     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
421         (uint256 tTransferAmount, uint256 tDynamic) = _getTValues(tAmount, _dynamicFee);
422         uint256 currentRate = _getRate();
423         (uint256 rAmount, uint256 rTransferAmount, uint256 rDynamic) = _getRValues(tAmount, tDynamic, currentRate);
424         return (rAmount, rTransferAmount, rDynamic, tTransferAmount, tDynamic);
425     }
426 
427     function _getTValues(uint256 tAmount, uint256 dynamicFee) private pure returns (uint256, uint256) {
428         if (dynamicFee == 0)
429             return (tAmount, dynamicFee);
430         uint256 tDynamic = tAmount.mul(dynamicFee).div(100);
431         uint256 tTransferAmount = tAmount
432         .sub(tDynamic)  //pool fee
433         .sub(tDynamic)  //charity + marketing
434         .sub(tDynamic); //burn + redistribution
435         return (tTransferAmount, tDynamic);
436     }
437 
438     function _getRValues(uint256 tAmount, uint256 tDynamic, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
439         uint256 rAmount = tAmount.mul(currentRate);
440         
441         if (tDynamic == 0)
442             return (rAmount, rAmount, tDynamic);
443         uint256 rDynamic = tDynamic.mul(currentRate);
444         uint256 rTransferAmount = rAmount
445         .sub(rDynamic) //pool fee
446         .sub(rDynamic)  //charity + marketing
447         .sub(rDynamic); //burn + redistribution
448         return (rAmount, rTransferAmount, rDynamic);
449     }
450 
451     function _getRate() private view returns (uint256) {
452         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
453         return rSupply.div(tSupply);
454     }
455 
456     function _getCurrentSupply() private view returns (uint256, uint256) {
457         uint256 rSupply = _rTotal;
458         uint256 tSupply = _tTotal;
459         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
460         return (rSupply, tSupply);
461     }
462 
463     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
464         require(maxTxPercent > 0, "Amount must be greater than 0");
465         _maxTxPct = maxTxPercent * 10;
466         emit MaxTxPctUpdated(_maxTxPct);
467     }
468 }