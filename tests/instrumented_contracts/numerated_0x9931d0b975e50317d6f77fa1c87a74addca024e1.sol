1 /**
2 
3 $DWEB - Dark Web
4 
5 There is a lot more to the world of cryptocurrencies under the surface. 
6 The dark web holds secrets that lead to infinite glory in the crypto world. 
7 The secrets are out there, you just need to know where to find them. 
8 Take a peak inside the dark web and unveil the mysterious paths to success, 
9 but don't get lost in it because the darkness will surround you quickly.
10 
11 🕸️🕸️🕸️🕸️
12 
13 tax: 6/6
14 
15 Telegram: https://t.me/darkwebeth
16 Twitter: https://twitter.com/DarkWebErc20
17 
18 */
19 
20 pragma solidity ^0.8.15;
21 // SPDX-License-Identifier: UNLICENSED
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     address private _dev;
80     address private _previousOwner;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     constructor () {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         _dev = msgSender;
87         emit OwnershipTransferred(address(0), msgSender);
88     }
89 
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     modifier onlyOwner() {
95         require(_owner == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98 
99     modifier onlyDev() {
100         require(_dev == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109 }  
110 
111 interface IUniswapV2Factory {
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113 }
114 
115 interface IUniswapV2Router02 {
116     function swapExactTokensForETHSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external;
123     function factory() external pure returns (address);
124     function WETH() external pure returns (address);
125     function addLiquidityETH(
126         address token,
127         uint amountTokenDesired,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
133 }
134 
135 contract DarkWeb is Context, IERC20, Ownable {
136     using SafeMath for uint256;
137     mapping (address => uint256) private _rOwned;
138     mapping (address => uint256) private _tOwned;
139     mapping (address => mapping (address => uint256)) private _allowances;
140     mapping (address => bool) private _isExcludedFromFee;
141     mapping (address => bool) private bots;
142     mapping (address => uint) private cooldown;
143     uint256 private constant MAX = ~uint256(0);
144     uint256 private constant _tTotal = 1_000_000_000 * 10**9;
145     uint256 private _rTotal = (MAX - (MAX % _tTotal));
146     uint256 private _tFeeTotal;
147     
148     struct Taxes {
149         uint256 buyFee1;
150         uint256 buyFee2;
151         uint256 sellFee1;
152         uint256 sellFee2;
153     }
154 
155     Taxes private _taxes = Taxes(0,6,0,6);
156     uint256 private initialTotalBuyFee = _taxes.buyFee1 + _taxes.buyFee2;
157     uint256 private initialTotalSellFee = _taxes.sellFee1 + _taxes.sellFee2;
158     address payable private _feeAddrWallet;
159     uint256 private _feeRate = 20;
160     
161     string private constant _name = "Dark Web";
162     string private constant _symbol = "DWEB";
163     uint8 private constant _decimals = 9;
164     
165     IUniswapV2Router02 private uniswapV2Router;
166     address private uniswapV2Pair;
167     bool private tradingOpen;
168     bool private inSwap = false;
169     bool private swapEnabled = false;
170     bool private cooldownEnabled = false;
171     bool private _isBuy = false;
172     uint256 private _maxTxAmount = _tTotal;
173     uint256 private _maxWalletSize = _tTotal;
174     event MaxTxAmountUpdated(uint _maxTxAmount);
175     modifier lockTheSwap {
176         inSwap = true;
177         _;
178         inSwap = false;
179     }
180 
181     constructor () {
182         _feeAddrWallet = payable(0x0da4a9b1Dcd12818E94ecf3d5a897561Ab048b6f);
183         _rOwned[_msgSender()] = _rTotal;
184         _isExcludedFromFee[owner()] = true;
185         _isExcludedFromFee[address(this)] = true;
186         _isExcludedFromFee[_feeAddrWallet] = true;
187         emit Transfer(address(0), _msgSender(), _tTotal);
188     }
189 
190     function name() public pure returns (string memory) {
191         return _name;
192     }
193 
194     function symbol() public pure returns (string memory) {
195         return _symbol;
196     }
197 
198     function decimals() public pure returns (uint8) {
199         return _decimals;
200     }
201 
202     function totalSupply() public pure override returns (uint256) {
203         return _tTotal;
204     }
205 
206     function balanceOf(address account) public view override returns (uint256) {
207         return tokenFromReflection(_rOwned[account]);
208     }
209 
210     function transfer(address recipient, uint256 amount) public override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     function allowance(address owner, address spender) public view override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219     function approve(address spender, uint256 amount) public override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
225         _transfer(sender, recipient, amount);
226         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
227         return true;
228     }
229 
230     function setCooldownEnabled(bool onoff) external onlyOwner() {
231         cooldownEnabled = onoff;
232     }
233 
234     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
235         require(rAmount <= _rTotal, "Amount must be less than total reflections");
236         uint256 currentRate =  _getRate();
237         return rAmount.div(currentRate);
238     }
239 
240     function _approve(address owner, address spender, uint256 amount) private {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247     function _transfer(address from, address to, uint256 amount) private {
248         require(amount > 0, "Transfer amount must be greater than zero");
249         _isBuy = true;
250 
251         if (from != owner() && to != owner()) {
252 
253             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
254                 // buy
255                 require(amount <= _maxTxAmount);
256                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
257             }
258 
259             if (from != address(uniswapV2Router) && ! _isExcludedFromFee[from] && to == uniswapV2Pair){
260                 require(!bots[from] && !bots[to]);
261                 _isBuy = false;
262             }
263 
264             uint256 contractTokenBalance = balanceOf(address(this));
265             if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
266                 contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
267             }
268 
269             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
270                 swapTokensForEth(contractTokenBalance);
271                 uint256 contractETHBalance = address(this).balance;
272                 if(contractETHBalance > 0) {
273                     sendETHToFee(address(this).balance);
274                 }
275             }
276         }
277 
278         _tokenTransfer(from,to,amount);
279     }
280 
281 
282     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
283         address[] memory path = new address[](2);
284         path[0] = address(this);
285         path[1] = uniswapV2Router.WETH();
286         _approve(address(this), address(uniswapV2Router), tokenAmount);
287         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
288             tokenAmount,
289             0,
290             path,
291             address(this),
292             block.timestamp + 60 * 1
293         );
294     }
295 
296     function getIsBuy() private view returns (bool){
297         return _isBuy;
298     }
299 
300     function removeLimits() external onlyOwner{
301         _maxTxAmount = _tTotal;
302         _maxWalletSize = _tTotal;
303     }
304 
305     function adjustFees(uint256 buyFee1, uint256 buyFee2, uint256 sellFee1, uint256 sellFee2) external onlyDev {
306         require(buyFee1 + buyFee2 <= initialTotalBuyFee);
307         require(sellFee1 + sellFee2 <= initialTotalSellFee);
308         _taxes.buyFee1 = buyFee1;
309         _taxes.buyFee2 = buyFee2;
310         _taxes.sellFee1 = sellFee1;
311         _taxes.sellFee2 = sellFee2;
312     }
313 
314     function changeMaxTxAmount(uint256 percentage) external onlyOwner{
315         require(percentage>0);
316         _maxTxAmount = _tTotal.mul(percentage).div(100);
317     }
318 
319     function changeMaxWalletSize(uint256 percentage) external onlyOwner{
320         require(percentage>0);
321         _maxWalletSize = _tTotal.mul(percentage).div(100);
322     }
323 
324     function setFeeRate(uint256 rate) external  onlyDev() {
325         require(rate<=49);
326         _feeRate = rate;
327     }
328         
329     function sendETHToFee(uint256 amount) private {
330         _feeAddrWallet.transfer(amount);
331     }  
332 
333     function openTrading() external onlyOwner() {
334         require(!tradingOpen,"trading is already open");
335         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
336         uniswapV2Router = _uniswapV2Router;
337         _approve(address(this), address(uniswapV2Router), _tTotal);
338         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
339         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
340         swapEnabled = true;
341         cooldownEnabled = true;
342         _maxTxAmount = 30_000_000 * 10**9;
343         _maxWalletSize = 30_000_000 * 10**9;
344         tradingOpen = true;
345         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
346     }
347     
348     function addBot(address[] memory _bots) public onlyOwner {
349         for (uint i = 0; i < _bots.length; i++) {
350             if (_bots[i] != address(this) && _bots[i] != uniswapV2Pair && _bots[i] != address(uniswapV2Router)){
351                 bots[_bots[i]] = true;
352             }
353         }
354     }
355     
356     function delBot(address notbot) public onlyDev {
357         bots[notbot] = false;
358     }
359         
360     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
361         _transferStandard(sender, recipient, amount);
362     }
363 
364     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
365         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
366         _rOwned[sender] = _rOwned[sender].sub(rAmount);
367         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
368         _takeTeam(tTeam);
369         _reflectFee(rFee, tFee);
370         emit Transfer(sender, recipient, tTransferAmount);
371     }
372 
373     function _takeTeam(uint256 tTeam) private {
374         uint256 currentRate =  _getRate();
375         uint256 rTeam = tTeam.mul(currentRate);
376         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
377     }
378 
379     function _reflectFee(uint256 rFee, uint256 tFee) private {
380         _rTotal = _rTotal.sub(rFee);
381         _tFeeTotal = _tFeeTotal.add(tFee);
382     }
383 
384     receive() external payable {}
385     
386     function manualswap() external onlyDev {
387         uint256 contractBalance = balanceOf(address(this));
388         swapTokensForEth(contractBalance);
389     }
390     
391     function manualsend() external onlyDev {
392         uint256 contractETHBalance = address(this).balance;
393         sendETHToFee(contractETHBalance);
394     }
395 
396     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
397         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = getIsBuy() ? _getTValues(tAmount, _taxes.buyFee1, _taxes.buyFee2) : _getTValues(tAmount, _taxes.sellFee1, _taxes.sellFee2);
398         uint256 currentRate =  _getRate();
399         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
400         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
401     }
402 
403     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
404         uint256 tFee = tAmount.mul(taxFee).div(100);
405         uint256 tTeam = tAmount.mul(TeamFee).div(100);
406         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
407         return (tTransferAmount, tFee, tTeam);
408     }
409 
410     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
411         uint256 rAmount = tAmount.mul(currentRate);
412         uint256 rFee = tFee.mul(currentRate);
413         uint256 rTeam = tTeam.mul(currentRate);
414         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
415         return (rAmount, rTransferAmount, rFee);
416     }
417 
418 	function _getRate() private view returns(uint256) {
419         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
420         return rSupply.div(tSupply);
421     }
422 
423     function _getCurrentSupply() private view returns(uint256, uint256) {
424         uint256 rSupply = _rTotal;
425         uint256 tSupply = _tTotal;      
426         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
427         return (rSupply, tSupply);
428     }
429 }