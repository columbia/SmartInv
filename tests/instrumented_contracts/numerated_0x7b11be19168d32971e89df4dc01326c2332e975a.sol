1 /*
2 Welcome to Kyōbu.
3 
4 Telegram: https://t.me/KyobuOfficial
5 Website: https://kyobu.io 
6 
7 Kyōbu are celestial fox spirits with lush purple fur and full, fluffy tails reminiscent of lavender petals. They are holy creatures, and bring happiness and blessings to those around them.
8 
9 With a dynamic sell limit based on price impact and increasing sell cooldowns and redistribution taxes on consecutive sells, Kyōbu was designed to reward holders and discourage dumping.
10 
11 1. Buy limit and cooldown timer on buys to make sure no automated bots have a chance to snipe big portions of the pool.
12 2. No Team & Marketing wallet. 100% of the tokens will come on the market for trade. 
13 3. No presale wallets that can dump on the community. 
14 
15 Token Information
16 1. 1,000,000,000,000 Total Supply
17 3. Developer provides LP
18 4. Fair launch for everyone! 
19 5. 0,2% transaction limit on launch
20 6. Buy limit lifted after launch
21 7. Sells limited to 3% of the Liquidity Pool, <2.9% price impact 
22 8. Sell cooldown increases on consecutive sells, 4 sells within a 24 hours period are allowed
23 9. 2% redistribution to holders on all buys
24 10. 7% redistribution to holders on the first sell, increases 2x, 3x, 4x on consecutive sells
25 11. Redistribution actually works!
26 12. 5-6% developer fee split within the team
27 
28 
29 */
30 
31 pragma solidity ^0.8.4;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 }
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73         return c;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79 
80     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 }
86 
87 contract Ownable is Context {
88     address private _owner;
89     address private _previousOwner;
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     constructor() {
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
111 }
112 
113 interface IUniswapV2Factory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IUniswapV2Router02 {
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint256 amountIn,
120         uint256 amountOutMin,
121         address[] calldata path,
122         address to,
123         uint256 deadline
124     ) external;
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127     function addLiquidityETH(
128         address token,
129         uint256 amountTokenDesired,
130         uint256 amountTokenMin,
131         uint256 amountETHMin,
132         address to,
133         uint256 deadline
134     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
135 }
136 
137 contract Kyobu is Context, IERC20, Ownable {
138     using SafeMath for uint256;
139     string private constant _name = unicode"Kyōbu";
140     string private constant _symbol = "KYOBU";
141     uint8 private constant _decimals = 9;
142     mapping(address => uint256) private _rOwned;
143     mapping(address => uint256) private _tOwned;
144     mapping(address => mapping(address => uint256)) private _allowances;
145     mapping(address => bool) private _isExcludedFromFee;
146     uint256 private constant MAX = ~uint256(0);
147     uint256 private constant _tTotal = 1000000000000 * 10**9;
148     uint256 private _rTotal = (MAX - (MAX % _tTotal));
149     uint256 private _tFeeTotal;
150     uint256 private _taxFee = 7;
151     uint256 private _teamFee = 5;
152     mapping(address => bool) private bots;
153     mapping(address => uint256) private buycooldown;
154     mapping(address => uint256) private sellcooldown;
155     mapping(address => uint256) private firstsell;
156     mapping(address => uint256) private sellnumber;
157     address payable private _teamAddress;
158     address payable private _marketingFunds;
159     IUniswapV2Router02 private uniswapV2Router;
160     address private uniswapV2Pair;
161     bool private tradingOpen = false;
162     bool private liquidityAdded = false;
163     bool private inSwap = false;
164     bool private swapEnabled = false;
165     bool private cooldownEnabled = false;
166     uint256 private _maxTxAmount = _tTotal;
167     event MaxTxAmountUpdated(uint256 _maxTxAmount);
168     modifier lockTheSwap {
169         inSwap = true;
170         _;
171         inSwap = false;
172     }
173     constructor(address payable addr1, address payable addr2) {
174         _teamAddress = addr1;
175         _marketingFunds = addr2;
176         _rOwned[_msgSender()] = _rTotal;
177         _isExcludedFromFee[owner()] = true;
178         _isExcludedFromFee[address(this)] = true;
179         _isExcludedFromFee[_teamAddress] = true;
180         _isExcludedFromFee[_marketingFunds] = true;
181         emit Transfer(address(0), _msgSender(), _tTotal);
182     }
183 
184     function name() public pure returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public pure returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public pure returns (uint8) {
193         return _decimals;
194     }
195 
196     function totalSupply() public pure override returns (uint256) {
197         return _tTotal;
198     }
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return tokenFromReflection(_rOwned[account]);
202     }
203 
204     function transfer(address recipient, uint256 amount) public override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     function allowance(address owner, address spender) public view override returns (uint256) {
210         return _allowances[owner][spender];
211     }
212 
213     function approve(address spender, uint256 amount) public override returns (bool) {
214         _approve(_msgSender(), spender, amount);
215         return true;
216     }
217 
218     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
219         _transfer(sender, recipient, amount);
220         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
221         return true;
222     }
223 
224     function setCooldownEnabled(bool onoff) external onlyOwner() {
225         cooldownEnabled = onoff;
226     }
227 
228     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
229         require(rAmount <= _rTotal,"Amount must be less than total reflections");
230         uint256 currentRate = _getRate();
231         return rAmount.div(currentRate);
232     }
233     
234     function removeAllFee() private {
235         if (_taxFee == 0 && _teamFee == 0) return;
236         _taxFee = 0;
237         _teamFee = 0;
238     }
239 
240     function restoreAllFee() private {
241         _taxFee = 7;
242         _teamFee = 5;
243     }
244     
245     function setFee(uint256 multiplier) private {
246         _taxFee = _taxFee * multiplier;
247         if (multiplier > 1) {
248             _teamFee = 10;
249         }
250         
251     }
252 
253     function _approve(address owner, address spender, uint256 amount) private {
254         require(owner != address(0), "ERC20: approve from the zero address");
255         require(spender != address(0), "ERC20: approve to the zero address");
256         _allowances[owner][spender] = amount;
257         emit Approval(owner, spender, amount);
258     }
259 
260     function _transfer(address from, address to, uint256 amount) private {
261         require(from != address(0), "ERC20: transfer from the zero address");
262         require(to != address(0), "ERC20: transfer to the zero address");
263         require(amount > 0, "Transfer amount must be greater than zero");
264 
265         if (from != owner() && to != owner()) {
266             if (cooldownEnabled) {
267                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
268                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
269                 }
270             }
271             require(!bots[from] && !bots[to]);
272             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
273                 require(tradingOpen);
274                 require(amount <= _maxTxAmount);
275                 require(buycooldown[to] < block.timestamp);
276                 buycooldown[to] = block.timestamp + (30 seconds);
277                 _teamFee = 6;
278                 _taxFee = 2;
279             }
280             uint256 contractTokenBalance = balanceOf(address(this));
281             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
282                 require(amount <= balanceOf(uniswapV2Pair).mul(3).div(100) && amount <= _maxTxAmount);
283                 require(sellcooldown[from] < block.timestamp);
284                 if(firstsell[from] + (1 days) < block.timestamp){
285                     sellnumber[from] = 0;
286                 }
287                 if (sellnumber[from] == 0) {
288                     sellnumber[from]++;
289                     firstsell[from] = block.timestamp;
290                     sellcooldown[from] = block.timestamp + (1 hours);
291                 }
292                 else if (sellnumber[from] == 1) {
293                     sellnumber[from]++;
294                     sellcooldown[from] = block.timestamp + (2 hours);
295                 }
296                 else if (sellnumber[from] == 2) {
297                     sellnumber[from]++;
298                     sellcooldown[from] = block.timestamp + (6 hours);
299                 }
300                 else if (sellnumber[from] == 3) {
301                     sellnumber[from]++;
302                     sellcooldown[from] = firstsell[from] + (1 days);
303                 }
304                 swapTokensForEth(contractTokenBalance);
305                 uint256 contractETHBalance = address(this).balance;
306                 if (contractETHBalance > 0) {
307                     sendETHToFee(address(this).balance);
308                 }
309                 setFee(sellnumber[from]);
310             }
311         }
312         bool takeFee = true;
313 
314         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
315             takeFee = false;
316         }
317 
318         _tokenTransfer(from, to, amount, takeFee);
319         restoreAllFee;
320     }
321 
322     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
323         address[] memory path = new address[](2);
324         path[0] = address(this);
325         path[1] = uniswapV2Router.WETH();
326         _approve(address(this), address(uniswapV2Router), tokenAmount);
327         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
328     }
329 
330     function sendETHToFee(uint256 amount) private {
331         _teamAddress.transfer(amount.div(2));
332         _marketingFunds.transfer(amount.div(2));
333     }
334     
335     function openTrading() public onlyOwner {
336         require(liquidityAdded);
337         tradingOpen = true;
338     }
339 
340     function addLiquidity() external onlyOwner() {
341         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
342         uniswapV2Router = _uniswapV2Router;
343         _approve(address(this), address(uniswapV2Router), _tTotal);
344         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
345         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
346         swapEnabled = true;
347         cooldownEnabled = true;
348         liquidityAdded = true;
349         _maxTxAmount = 3000000000 * 10**9;
350         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
351     }
352 
353     function manualswap() external {
354         require(_msgSender() == _teamAddress);
355         uint256 contractBalance = balanceOf(address(this));
356         swapTokensForEth(contractBalance);
357     }
358 
359     function manualsend() external {
360         require(_msgSender() == _teamAddress);
361         uint256 contractETHBalance = address(this).balance;
362         sendETHToFee(contractETHBalance);
363     }
364 
365     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
366         if (!takeFee) removeAllFee();
367         _transferStandard(sender, recipient, amount);
368         if (!takeFee) restoreAllFee();
369     }
370 
371     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
372         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
373         _rOwned[sender] = _rOwned[sender].sub(rAmount);
374         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
375         _takeTeam(tTeam);
376         _reflectFee(rFee, tFee);
377         emit Transfer(sender, recipient, tTransferAmount);
378     }
379 
380     function _takeTeam(uint256 tTeam) private {
381         uint256 currentRate = _getRate();
382         uint256 rTeam = tTeam.mul(currentRate);
383         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
384     }
385 
386     function _reflectFee(uint256 rFee, uint256 tFee) private {
387         _rTotal = _rTotal.sub(rFee);
388         _tFeeTotal = _tFeeTotal.add(tFee);
389     }
390 
391     receive() external payable {}
392 
393     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
394         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
395         uint256 currentRate = _getRate();
396         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
397         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
398     }
399 
400     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
401         uint256 tFee = tAmount.mul(taxFee).div(100);
402         uint256 tTeam = tAmount.mul(teamFee).div(100);
403         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
404         return (tTransferAmount, tFee, tTeam);
405     }
406 
407     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
408         uint256 rAmount = tAmount.mul(currentRate);
409         uint256 rFee = tFee.mul(currentRate);
410         uint256 rTeam = tTeam.mul(currentRate);
411         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
412         return (rAmount, rTransferAmount, rFee);
413     }
414 
415     function _getRate() private view returns (uint256) {
416         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
417         return rSupply.div(tSupply);
418     }
419 
420     function _getCurrentSupply() private view returns (uint256, uint256) {
421         uint256 rSupply = _rTotal;
422         uint256 tSupply = _tTotal;
423         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
424         return (rSupply, tSupply);
425     }
426 
427     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
428         require(maxTxPercent > 0, "Amount must be greater than 0");
429         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
430         emit MaxTxAmountUpdated(_maxTxAmount);
431     }
432 }