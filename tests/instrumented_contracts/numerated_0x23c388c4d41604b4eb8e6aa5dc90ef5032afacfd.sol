1 /**
2 
3 $PEPEBOT - utillity token
4 
5 Telegram: https://t.me/pepebottools
6 
7 BOT: https://pepebottools.com/
8 Setup manual: https://medium.com/@pepetools/pepebot-manual-f733ea322d55
9 
10 SPDX-License-Identifier: UNLICENSED
11 ****/
12 
13 
14 pragma solidity 0.8.7;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     address private _previousOwner;
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     constructor () {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96 }
97 
98 interface IUniswapV2Factory {
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IUniswapV2Router02 {
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110     function factory() external pure returns (address);
111     function WETH() external pure returns (address);
112     function addLiquidityETH(
113         address token,
114         uint amountTokenDesired,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
120 }
121 
122 contract PEPEBOT is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _rOwned;
125     mapping (address => uint256) private _tOwned;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping (address => bool) private bots;
129     mapping (address => uint) private cooldown;
130     uint256 private constant MAX = ~uint256(0);
131     uint256 private constant _tTotal = 100_000_000 * 10**9;
132     uint256 private _rTotal = (MAX - (MAX % _tTotal));
133     uint256 private _tFeeTotal;
134     uint256 private _feeAddr1;
135     uint256 private _feeAddr2;
136     uint256 private _initialTax;
137     uint256 private _finalTax;
138     uint256 private _reduceTaxCountdown;
139     address payable private _feeAddrWallet;
140 
141     string private constant _name = "PepeBot";
142     string private constant _symbol = "PEPEBOT";
143     uint8 private constant _decimals = 9;
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150     bool private cooldownEnabled = false;
151     uint256 private _maxTxAmount = 3_000_000 * 10**9;
152     uint256 private _maxWalletSize = 4_000_000 * 10**9;
153     event MaxTxAmountUpdated(uint _maxTxAmount);
154     modifier lockTheSwap {
155         inSwap = true;
156         _;
157         inSwap = false;
158     }
159 
160     constructor () {
161         _feeAddrWallet = payable(_msgSender());
162         _rOwned[_msgSender()] = _rTotal;
163         _isExcludedFromFee[owner()] = true;
164         _isExcludedFromFee[address(this)] = true;
165         _isExcludedFromFee[_feeAddrWallet] = true;
166         _initialTax=15;
167         _finalTax=5;
168         _reduceTaxCountdown=300;
169 
170         emit Transfer(address(0), _msgSender(), _tTotal);
171     }
172 
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180 
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public pure override returns (uint256) {
186         return _tTotal;
187     }
188 
189     function balanceOf(address account) public view override returns (uint256) {
190         return tokenFromReflection(_rOwned[account]);
191     }
192 
193     function transfer(address recipient, uint256 amount) public override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender) public view override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(address spender, uint256 amount) public override returns (bool) {
203         _approve(_msgSender(), spender, amount);
204         return true;
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
210         return true;
211     }
212 
213     function setCooldownEnabled(bool onoff) external onlyOwner() {
214         cooldownEnabled = onoff;
215     }
216 
217     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
218         require(rAmount <= _rTotal, "Amount must be less than total reflections");
219         uint256 currentRate =  _getRate();
220         return rAmount.div(currentRate);
221     }
222 
223     function _approve(address owner, address spender, uint256 amount) private {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _transfer(address from, address to, uint256 amount) private {
231         require(from != address(0), "ERC20: transfer from the zero address");
232         require(to != address(0), "ERC20: transfer to the zero address");
233         require(amount > 0, "Transfer amount must be greater than zero");
234 
235 
236         if (from != owner() && to != owner()) {
237             require(!bots[from] && !bots[to]);
238             _feeAddr1 = 0;
239             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
241                 // Cooldown
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
245             }
246 
247 
248             uint256 contractTokenBalance = balanceOf(address(this));
249             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
250                 swapTokensForEth(contractTokenBalance);
251                 uint256 contractETHBalance = address(this).balance;
252                 if(contractETHBalance > 0) {
253                     sendETHToFee(address(this).balance);
254                 }
255             }
256         }else{
257           _feeAddr1 = 0;
258           _feeAddr2 = 0;
259         }
260 
261         _tokenTransfer(from,to,amount);
262     }
263 
264     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
265         address[] memory path = new address[](2);
266         path[0] = address(this);
267         path[1] = uniswapV2Router.WETH();
268         _approve(address(this), address(uniswapV2Router), tokenAmount);
269         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
270             tokenAmount,
271             0,
272             path,
273             address(this),
274             block.timestamp
275         );
276     }
277 
278     function setOperationsTax(uint256 tax) external onlyOwner{
279         _initialTax = tax;
280         _finalTax = tax;
281     }
282 
283     function removeLimits() external onlyOwner{
284         _maxTxAmount = _tTotal;
285     }
286 
287     function sendETHToFee(uint256 amount) private {
288         _feeAddrWallet.transfer(amount);
289     }
290 
291     function openTrading() external onlyOwner() {
292         require(!tradingOpen,"trading is already open");
293         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
294         uniswapV2Router = _uniswapV2Router;
295         _approve(address(this), address(uniswapV2Router), _tTotal);
296         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
297         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
298         swapEnabled = true;
299         cooldownEnabled = true;
300 
301         tradingOpen = true;
302         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
303     }
304 
305     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
306         _transferStandard(sender, recipient, amount);
307     }
308 
309     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
310         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
311         _rOwned[sender] = _rOwned[sender].sub(rAmount);
312         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
313         _takeTeam(tTeam);
314         _reflectFee(rFee, tFee);
315         emit Transfer(sender, recipient, tTransferAmount);
316     }
317 
318     function _takeTeam(uint256 tTeam) private {
319         uint256 currentRate =  _getRate();
320         uint256 rTeam = tTeam.mul(currentRate);
321         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
322     }
323 
324     function _reflectFee(uint256 rFee, uint256 tFee) private {
325         _rTotal = _rTotal.sub(rFee);
326         _tFeeTotal = _tFeeTotal.add(tFee);
327     }
328 
329     receive() external payable {}
330 
331     function manualswap() external {
332         require(_msgSender() == _feeAddrWallet);
333         uint256 contractBalance = balanceOf(address(this));
334         swapTokensForEth(contractBalance);
335     }
336 
337     function manualsend() external {
338         require(_msgSender() == _feeAddrWallet);
339         uint256 contractETHBalance = address(this).balance;
340         sendETHToFee(contractETHBalance);
341     }
342 
343 
344     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
345         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
346         uint256 currentRate =  _getRate();
347         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
348         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
349     }
350 
351     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
352         uint256 tFee = tAmount.mul(taxFee).div(100);
353         uint256 tTeam = tAmount.mul(TeamFee).div(100);
354         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
355         return (tTransferAmount, tFee, tTeam);
356     }
357 
358     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
359         uint256 rAmount = tAmount.mul(currentRate);
360         uint256 rFee = tFee.mul(currentRate);
361         uint256 rTeam = tTeam.mul(currentRate);
362         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
363         return (rAmount, rTransferAmount, rFee);
364     }
365 
366 	function _getRate() private view returns(uint256) {
367         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
368         return rSupply.div(tSupply);
369     }
370 
371     function _getCurrentSupply() private view returns(uint256, uint256) {
372         uint256 rSupply = _rTotal;
373         uint256 tSupply = _tTotal;
374         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
375         return (rSupply, tSupply);
376     }
377 }