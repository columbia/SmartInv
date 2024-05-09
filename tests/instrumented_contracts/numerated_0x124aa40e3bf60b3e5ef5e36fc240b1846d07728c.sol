1 /**
2 @thelastinueth
3 */
4 
5 
6 pragma solidity 0.8.7;
7 // SPDX-License-Identifier: UNLICENSED
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
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
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     address private _previousOwner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88 }
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract TheLastInuETH is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _rOwned;
117     mapping (address => uint256) private _tOwned;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping (address => bool) private bots;
121     mapping (address => uint) private cooldown;
122     uint256 private constant MAX = ~uint256(0);
123     uint256 private constant _tTotal = 100_000_000 * 10**9;
124     uint256 private _rTotal = (MAX - (MAX % _tTotal));
125     uint256 private _tFeeTotal;
126 
127     uint256 private _feeAddr1;
128     uint256 private _feeAddr2;
129     uint256 private _initialTax;
130     uint256 private _finalTax;
131     uint256 private _reduceTaxCountdown;
132     address payable private _feeAddrWallet;
133 
134     string private constant _name = "The Last Inu";
135     string private constant _symbol = "TLI";
136     uint8 private constant _decimals = 9;
137 
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143     bool private cooldownEnabled = false;
144     uint256 private _maxTxAmount = 2_000_000 * 10**9;
145     uint256 private _maxWalletSize = 4_000_000 * 10**9;
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor () {
154         _feeAddrWallet = payable(_msgSender());
155         _rOwned[_msgSender()] = _rTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_feeAddrWallet] = true;
159         _initialTax=9;
160         _finalTax=3;
161         _reduceTaxCountdown=60;
162 
163         emit Transfer(address(0), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return tokenFromReflection(_rOwned[account]);
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function setCooldownEnabled(bool onoff) external onlyOwner() {
207         cooldownEnabled = onoff;
208     }
209 
210     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
211         require(rAmount <= _rTotal, "Amount must be less than total reflections");
212         uint256 currentRate =  _getRate();
213         return rAmount.div(currentRate);
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227 
228 
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231             _feeAddr1 = 0;
232             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
234                 // Cooldown
235                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
236                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
237                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
238             }
239 
240 
241             uint256 contractTokenBalance = balanceOf(address(this));
242             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
243                 swapTokensForEth(contractTokenBalance);
244                 uint256 contractETHBalance = address(this).balance;
245                 if(contractETHBalance > 0) {
246                     sendETHToFee(address(this).balance);
247                 }
248             }
249         }else{
250           _feeAddr1 = 0;
251           _feeAddr2 = 0;
252         }
253 
254         _tokenTransfer(from,to,amount);
255     }
256 
257     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
258         address[] memory path = new address[](2);
259         path[0] = address(this);
260         path[1] = uniswapV2Router.WETH();
261         _approve(address(this), address(uniswapV2Router), tokenAmount);
262         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
263             tokenAmount,
264             0,
265             path,
266             address(this),
267             block.timestamp
268         );
269     }
270 
271     function addBots(address[] memory bots_) public onlyOwner {
272         for (uint i = 0; i < bots_.length; i++) {
273             bots[bots_[i]] = true;
274         }
275     }
276 
277     function delBot(address notbot) public onlyOwner {
278         bots[notbot] = false;
279     }
280 
281 
282     function removeLimits() external onlyOwner{
283         _maxTxAmount = _tTotal;
284         _maxWalletSize = _tTotal;
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