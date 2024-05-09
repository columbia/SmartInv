1 /**
2 
3 \ / _        _       ___         
4  X |_) _  \/|_) __ _  |  _  _ |_ 
5 / \|  (_| / |   | (_) | (/_(_ | |
6 
7 XPAY PRO TECH
8 A simple and highly secure way to Crypto Payments and Send/Receive/Request Crypto Online.
9 
10 Website: https://xpaypro.tech
11 Telegram: https://t.me/XPayProTech
12 App: https://app.xpaypro.tech/
13 Bot: https://t.me/XPayProTech_Bot
14 Whitepaper: https://docs.xpaypro.tech/
15 
16 **/
17 
18 pragma solidity 0.8.20;
19 // SPDX-License-Identifier: UNLICENSED
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
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
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     address private _previousOwner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100 }
101 
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125 
126 contract XPPT is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _rOwned;
129     mapping (address => uint256) private _tOwned;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) private _isExcludedFromFee;
132     mapping (address => uint) private cooldown;
133     uint256 private constant MAX = ~uint256(0);
134     uint256 private constant _tTotal = 1_000_000 * 10**4;
135     uint256 private _rTotal = (MAX - (MAX % _tTotal));
136     uint256 private _tFeeTotal;
137 
138     uint256 private _feeAddr1;
139     uint256 private _feeAddr2;
140     uint256 private _initialTax;
141     uint256 private _finalTax;
142     uint256 private _reduceTaxCountdown;
143     address payable private _feeAddrWallet;
144 
145     string private constant _name = "XPayPro.Tech";
146     string private constant _symbol = unicode"XPPT";
147     uint8 private constant _decimals = 4;
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private inSwap = false;
153     bool private swapEnabled = false;
154     bool private cooldownEnabled = false;
155     uint256 private _maxTxAmount = 1_000_000 * 10**4;
156     uint256 private _maxWalletSize = 20_000 * 10**4;
157     event MaxTxAmountUpdated(uint _maxTxAmount);
158     modifier lockTheSwap {
159         inSwap = true;
160         _;
161         inSwap = false;
162     }
163 
164     constructor () {
165         _feeAddrWallet = payable(_msgSender());
166         _rOwned[_msgSender()] = _rTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_feeAddrWallet] = true;
170         _initialTax=50;
171         _finalTax=4;
172         _reduceTaxCountdown=100;
173 
174         emit Transfer(address(0), _msgSender(), _tTotal);
175     }
176 
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return tokenFromReflection(_rOwned[account]);
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function setCooldownEnabled(bool onoff) external onlyOwner() {
218         cooldownEnabled = onoff;
219     }
220 
221     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
222         require(rAmount <= _rTotal, "Amount must be less than total reflections");
223         uint256 currentRate =  _getRate();
224         return rAmount.div(currentRate);
225     }
226 
227     function _approve(address owner, address spender, uint256 amount) private {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 
234     function _transfer(address from, address to, uint256 amount) private {
235         require(from != address(0), "ERC20: transfer from the zero address");
236         require(to != address(0), "ERC20: transfer to the zero address");
237         require(amount > 0, "Transfer amount must be greater than zero");
238 
239 
240         if (from != owner() && to != owner()) {
241             _feeAddr1 = 0;
242             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
244                 // Cooldown
245                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
246                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
247                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
248 
249            
250             }
251 
252             uint256 contractTokenBalance = balanceOf(address(this));
253             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
254                 swapTokensForEth(contractTokenBalance);
255                 uint256 contractETHBalance = address(this).balance;
256                 if(contractETHBalance > 0) {
257                     sendETHToFee(address(this).balance);
258                 }
259             }
260         }else{
261           _feeAddr1 = 0;
262           _feeAddr2 = 0;
263         }
264 
265         _tokenTransfer(from,to,amount);
266     }
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281 
282     function removeLimits() external onlyOwner{
283         _maxTxAmount = _tTotal;
284         _maxWalletSize = _tTotal;
285     }
286 
287         function setLowerTax(uint256 newTax) external onlyOwner{
288         _initialTax = (newTax);
289     }
290 
291   
292 
293     function sendETHToFee(uint256 amount) private {
294         _feeAddrWallet.transfer(amount);
295     }
296 
297     function openTrading() external onlyOwner() {
298         require(!tradingOpen,"trading is already open");
299         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
300         uniswapV2Router = _uniswapV2Router;
301         _approve(address(this), address(uniswapV2Router), _tTotal);
302         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
303         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
304         swapEnabled = true;
305         cooldownEnabled = true;
306         tradingOpen = true;
307         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
308     }
309 
310     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
311         _transferStandard(sender, recipient, amount);
312     }
313 
314     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
315         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
316         _rOwned[sender] = _rOwned[sender].sub(rAmount);
317         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
318         _takeTeam(tTeam);
319         _reflectFee(rFee, tFee);
320         emit Transfer(sender, recipient, tTransferAmount);
321     }
322 
323     function _takeTeam(uint256 tTeam) private {
324         uint256 currentRate =  _getRate();
325         uint256 rTeam = tTeam.mul(currentRate);
326         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
327     }
328 
329     function _reflectFee(uint256 rFee, uint256 tFee) private {
330         _rTotal = _rTotal.sub(rFee);
331         _tFeeTotal = _tFeeTotal.add(tFee);
332     }
333 
334     receive() external payable {}
335 
336     function manualswap() external {
337         require(_msgSender() == _feeAddrWallet);
338         uint256 contractBalance = balanceOf(address(this));
339         swapTokensForEth(contractBalance);
340     }
341 
342     function manualsend() external {
343         require(_msgSender() == _feeAddrWallet);
344         uint256 contractETHBalance = address(this).balance;
345         sendETHToFee(contractETHBalance);
346     }
347 
348 
349     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
350         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
351         uint256 currentRate =  _getRate();
352         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
353         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
354     }
355 
356     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
357         uint256 tFee = tAmount.mul(taxFee).div(100);
358         uint256 tTeam = tAmount.mul(TeamFee).div(100);
359         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
360         return (tTransferAmount, tFee, tTeam);
361     }
362 
363     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
364         uint256 rAmount = tAmount.mul(currentRate);
365         uint256 rFee = tFee.mul(currentRate);
366         uint256 rTeam = tTeam.mul(currentRate);
367         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
368         return (rAmount, rTransferAmount, rFee);
369     }
370 
371 	function _getRate() private view returns(uint256) {
372         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
373         return rSupply.div(tSupply);
374     }
375 
376     function _getCurrentSupply() private view returns(uint256, uint256) {
377         uint256 rSupply = _rTotal;
378         uint256 tSupply = _tTotal;
379         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
380         return (rSupply, tSupply);
381     }
382 }