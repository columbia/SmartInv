1 /**
2 
3 http://zeetox.io
4 
5 @zeetox
6 
7 */
8 
9 
10 pragma solidity 0.8.7;
11 // SPDX-License-Identifier: UNLICENSED
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
118 contract Zeetox is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping (address => uint) private cooldown;
126     uint256 private constant MAX = ~uint256(0);
127     uint256 private constant _tTotal = 10_000_000 * 10**9;
128     uint256 private _rTotal = (MAX - (MAX % _tTotal));
129     uint256 private _tFeeTotal;
130 
131     uint256 private _feeAddr1;
132     uint256 private _feeAddr2;
133     address payable private _feeAddrWallet;
134 
135     string private constant _name = "Zeetox";
136     string private constant _symbol = "ZEETOX";
137     uint8 private constant _decimals = 9;
138 
139     IUniswapV2Router02 private uniswapV2Router;
140     address private uniswapV2Pair;
141     bool private tradingOpen;
142     bool private inSwap = false;
143     bool private swapEnabled = false;
144     bool private cooldownEnabled = false;
145     uint256 private _maxTxAmount = 200_000 * 10**9;
146     uint256 private _maxWalletSize = 400_000 * 10**9;
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153 
154     constructor () {
155         _feeAddrWallet = payable(_msgSender());
156         _rOwned[_msgSender()] = _rTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_feeAddrWallet] = true;
160 
161         emit Transfer(address(0), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return tokenFromReflection(_rOwned[account]);
182     }
183 
184     function transfer(address recipient, uint256 amount) public override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function setCooldownEnabled(bool onoff) external onlyOwner() {
205         cooldownEnabled = onoff;
206     }
207 
208     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
209         require(rAmount <= _rTotal, "Amount must be less than total reflections");
210         uint256 currentRate =  _getRate();
211         return rAmount.div(currentRate);
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225 
226 
227         if (from != owner() && to != owner()) {
228             require(!bots[from] && !bots[to]);
229             _feeAddr1 = 0;
230             _feeAddr2 = 6;
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
232                 // Cooldown
233                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235 
236             }
237 
238 
239             uint256 contractTokenBalance = balanceOf(address(this));
240             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
241                 swapTokensForEth(contractTokenBalance);
242                 uint256 contractETHBalance = address(this).balance;
243                 if(contractETHBalance > 0) {
244                     sendETHToFee(address(this).balance);
245                 }
246             }
247         }else{
248           _feeAddr1 = 0;
249           _feeAddr2 = 0;
250         }
251 
252         _tokenTransfer(from,to,amount);
253     }
254 
255     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
256         address[] memory path = new address[](2);
257         path[0] = address(this);
258         path[1] = uniswapV2Router.WETH();
259         _approve(address(this), address(uniswapV2Router), tokenAmount);
260         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
261             tokenAmount,
262             0,
263             path,
264             address(this),
265             block.timestamp
266         );
267     }
268 
269 
270 
271     function removeLimits() external onlyOwner{
272         _maxTxAmount = _tTotal;
273         _maxWalletSize = _tTotal;
274     }
275 
276     function sendETHToFee(uint256 amount) private {
277         _feeAddrWallet.transfer(amount);
278     }
279 
280     function openTrading() external onlyOwner() {
281         require(!tradingOpen,"trading is already open");
282         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
283         uniswapV2Router = _uniswapV2Router;
284         _approve(address(this), address(uniswapV2Router), _tTotal);
285         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
286         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
287         swapEnabled = true;
288         cooldownEnabled = true;
289 
290         tradingOpen = true;
291         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
292     }
293 
294     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
295         _transferStandard(sender, recipient, amount);
296     }
297 
298     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
299         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
300         _rOwned[sender] = _rOwned[sender].sub(rAmount);
301         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
302         _takeTeam(tTeam);
303         _reflectFee(rFee, tFee);
304         emit Transfer(sender, recipient, tTransferAmount);
305     }
306 
307     function _takeTeam(uint256 tTeam) private {
308         uint256 currentRate =  _getRate();
309         uint256 rTeam = tTeam.mul(currentRate);
310         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
311     }
312 
313     function _reflectFee(uint256 rFee, uint256 tFee) private {
314         _rTotal = _rTotal.sub(rFee);
315         _tFeeTotal = _tFeeTotal.add(tFee);
316     }
317 
318     receive() external payable {}
319 
320     function manualswap() external {
321         require(_msgSender() == _feeAddrWallet);
322         uint256 contractBalance = balanceOf(address(this));
323         swapTokensForEth(contractBalance);
324     }
325 
326     function manualsend() external {
327         require(_msgSender() == _feeAddrWallet);
328         uint256 contractETHBalance = address(this).balance;
329         sendETHToFee(contractETHBalance);
330     }
331 
332 
333     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
334         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
335         uint256 currentRate =  _getRate();
336         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
337         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
338     }
339 
340     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
341         uint256 tFee = tAmount.mul(taxFee).div(100);
342         uint256 tTeam = tAmount.mul(TeamFee).div(100);
343         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
344         return (tTransferAmount, tFee, tTeam);
345     }
346 
347     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
348         uint256 rAmount = tAmount.mul(currentRate);
349         uint256 rFee = tFee.mul(currentRate);
350         uint256 rTeam = tTeam.mul(currentRate);
351         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
352         return (rAmount, rTransferAmount, rFee);
353     }
354 
355 	function _getRate() private view returns(uint256) {
356         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
357         return rSupply.div(tSupply);
358     }
359 
360     function _getCurrentSupply() private view returns(uint256, uint256) {
361         uint256 rSupply = _rTotal;
362         uint256 tSupply = _tTotal;
363         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
364         return (rSupply, tSupply);
365     }
366 }