1 /****
2 https://t.me/dextradingtools
3 https://medium.com/@dextradingtools/dex-trading-tools-introduction-ac22838f928b
4 https://www.dextradingtools.info/
5 
6 SPDX-License-Identifier: UNLICENSED
7 ****/
8 
9 
10 pragma solidity 0.8.7;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
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
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     address private _previousOwner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract DEXTradingToolsToken is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping (address => uint) private cooldown;
126     uint256 private constant MAX = ~uint256(0);
127     uint256 private constant _tTotal = 100_000_000 * 10**9;
128     uint256 private _rTotal = (MAX - (MAX % _tTotal));
129     uint256 private _tFeeTotal;
130     uint256 private _feeAddr1;
131     uint256 private _feeAddr2;
132     uint256 private _initialTax;
133     uint256 private _finalTax;
134     uint256 private _reduceTaxCountdown;
135     address payable private _feeAddrWallet;
136 
137     string private constant _name = "DEX Trading Tools";
138     string private constant _symbol = "DTT";
139     uint8 private constant _decimals = 9;
140 
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     bool private tradingOpen;
144     bool private inSwap = false;
145     bool private swapEnabled = false;
146     bool private cooldownEnabled = false;
147     uint256 private _maxTxAmount = 2_000_000 * 10**9;
148     uint256 private _maxWalletSize = 3_000_000 * 10**9;
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157         _feeAddrWallet = payable(_msgSender());
158         _rOwned[_msgSender()] = _rTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_feeAddrWallet] = true;
162         _initialTax=8;
163         _finalTax=6;
164         _reduceTaxCountdown=60;
165 
166         emit Transfer(address(0), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return tokenFromReflection(_rOwned[account]);
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function setCooldownEnabled(bool onoff) external onlyOwner() {
210         cooldownEnabled = onoff;
211     }
212 
213     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
214         require(rAmount <= _rTotal, "Amount must be less than total reflections");
215         uint256 currentRate =  _getRate();
216         return rAmount.div(currentRate);
217     }
218 
219     function _approve(address owner, address spender, uint256 amount) private {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 
226     function _transfer(address from, address to, uint256 amount) private {
227         require(from != address(0), "ERC20: transfer from the zero address");
228         require(to != address(0), "ERC20: transfer to the zero address");
229         require(amount > 0, "Transfer amount must be greater than zero");
230 
231 
232         if (from != owner() && to != owner()) {
233             require(!bots[from] && !bots[to]);
234             _feeAddr1 = 0;
235             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
237                 // Cooldown
238                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
239                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
240                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
241             }
242 
243 
244             uint256 contractTokenBalance = balanceOf(address(this));
245             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
246                 swapTokensForEth(contractTokenBalance);
247                 uint256 contractETHBalance = address(this).balance;
248                 if(contractETHBalance > 0) {
249                     sendETHToFee(address(this).balance);
250                 }
251             }
252         }else{
253           _feeAddr1 = 0;
254           _feeAddr2 = 0;
255         }
256 
257         _tokenTransfer(from,to,amount);
258     }
259 
260     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = uniswapV2Router.WETH();
264         _approve(address(this), address(uniswapV2Router), tokenAmount);
265         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             tokenAmount,
267             0,
268             path,
269             address(this),
270             block.timestamp
271         );
272     }
273 
274     function addBots(address[] memory bots_) public onlyOwner {
275         for (uint i = 0; i < bots_.length; i++) {
276             bots[bots_[i]] = true;
277         }
278     }
279 
280     function delBot(address notbot) public onlyOwner {
281         bots[notbot] = false;
282     }
283 
284 
285     function removeLimits() external onlyOwner{
286         _maxTxAmount = _tTotal;
287     }
288 
289     function sendETHToFee(uint256 amount) private {
290         _feeAddrWallet.transfer(amount);
291     }
292 
293     function openTrading() external onlyOwner() {
294         require(!tradingOpen,"trading is already open");
295         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
296         uniswapV2Router = _uniswapV2Router;
297         _approve(address(this), address(uniswapV2Router), _tTotal);
298         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
299         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
300         swapEnabled = true;
301         cooldownEnabled = true;
302 
303         tradingOpen = true;
304         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
305     }
306 
307     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
308         _transferStandard(sender, recipient, amount);
309     }
310 
311     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
312         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
313         _rOwned[sender] = _rOwned[sender].sub(rAmount);
314         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
315         _takeTeam(tTeam);
316         _reflectFee(rFee, tFee);
317         emit Transfer(sender, recipient, tTransferAmount);
318     }
319 
320     function _takeTeam(uint256 tTeam) private {
321         uint256 currentRate =  _getRate();
322         uint256 rTeam = tTeam.mul(currentRate);
323         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
324     }
325 
326     function _reflectFee(uint256 rFee, uint256 tFee) private {
327         _rTotal = _rTotal.sub(rFee);
328         _tFeeTotal = _tFeeTotal.add(tFee);
329     }
330 
331     receive() external payable {}
332 
333     function manualswap() external {
334         require(_msgSender() == _feeAddrWallet);
335         uint256 contractBalance = balanceOf(address(this));
336         swapTokensForEth(contractBalance);
337     }
338 
339     function manualsend() external {
340         require(_msgSender() == _feeAddrWallet);
341         uint256 contractETHBalance = address(this).balance;
342         sendETHToFee(contractETHBalance);
343     }
344 
345 
346     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
347         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
348         uint256 currentRate =  _getRate();
349         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
350         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
351     }
352 
353     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
354         uint256 tFee = tAmount.mul(taxFee).div(100);
355         uint256 tTeam = tAmount.mul(TeamFee).div(100);
356         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
357         return (tTransferAmount, tFee, tTeam);
358     }
359 
360     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
361         uint256 rAmount = tAmount.mul(currentRate);
362         uint256 rFee = tFee.mul(currentRate);
363         uint256 rTeam = tTeam.mul(currentRate);
364         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
365         return (rAmount, rTransferAmount, rFee);
366     }
367 
368 	function _getRate() private view returns(uint256) {
369         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
370         return rSupply.div(tSupply);
371     }
372 
373     function _getCurrentSupply() private view returns(uint256, uint256) {
374         uint256 rSupply = _rTotal;
375         uint256 tSupply = _tTotal;
376         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
377         return (rSupply, tSupply);
378     }
379 }