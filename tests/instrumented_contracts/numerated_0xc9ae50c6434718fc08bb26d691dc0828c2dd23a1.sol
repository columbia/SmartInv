1 /**
2 
3 Twitter- @ExampleProtocol
4 
5 0/0
6 
7 */
8 
9 
10 pragma solidity 0.8.17;
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
118 contract ExampleProtocol is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping (address => uint) private cooldown;
126     uint256 private constant MAX = ~uint256(0);
127     uint256 private constant _tTotal = 1000000000000 * 10**9;
128     uint256 private _rTotal = (MAX - (MAX % _tTotal));
129     uint256 private _tFeeTotal;
130 
131     uint256 private _feeAddr1;
132     uint256 private _feeAddr2;
133     uint256 private _standardTax;
134     address payable private _feeAddrWallet;
135 
136     string private constant _name = "Example Protocol";
137     string private constant _symbol = "$EXAMPLE";
138     uint8 private constant _decimals = 9;
139 
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     bool private cooldownEnabled = false;
146     uint256 private _maxTxAmount = 10000000000 * 10**9;
147     uint256 private _maxWalletSize = 20000000000 * 10**9;
148     event MaxTxAmountUpdated(uint _maxTxAmount);
149     modifier lockTheSwap {
150         inSwap = true;
151         _;
152         inSwap = false;
153     }
154 
155     constructor () {
156         _feeAddrWallet = payable(_msgSender());
157         _rOwned[_msgSender()] = _rTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_feeAddrWallet] = true;
161         _standardTax=8;
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
232             _feeAddr2 = _standardTax;
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
234                 // Cooldown
235                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
236                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
237 
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
271     function setStandardTax(uint256 newTax) external onlyOwner{
272       require(newTax<_standardTax);
273       _standardTax=newTax;
274     }
275 
276     function removeLimits() external onlyOwner{
277         _maxTxAmount = _tTotal;
278         _maxWalletSize = _tTotal;
279     }
280 
281     function sendETHToFee(uint256 amount) private {
282         _feeAddrWallet.transfer(amount);
283     }
284 
285     function openTrading() external onlyOwner() {
286         require(!tradingOpen,"trading is already open");
287         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
288         uniswapV2Router = _uniswapV2Router;
289         _approve(address(this), address(uniswapV2Router), _tTotal);
290         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
291         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
292         swapEnabled = true;
293         cooldownEnabled = true;
294 
295         tradingOpen = true;
296         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
297     }
298 
299     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
300         _transferStandard(sender, recipient, amount);
301     }
302 
303     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
304         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
305         _rOwned[sender] = _rOwned[sender].sub(rAmount);
306         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
307         _takeTeam(tTeam);
308         _reflectFee(rFee, tFee);
309         emit Transfer(sender, recipient, tTransferAmount);
310     }
311 
312     function _takeTeam(uint256 tTeam) private {
313         uint256 currentRate =  _getRate();
314         uint256 rTeam = tTeam.mul(currentRate);
315         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
316     }
317 
318     function _reflectFee(uint256 rFee, uint256 tFee) private {
319         _rTotal = _rTotal.sub(rFee);
320         _tFeeTotal = _tFeeTotal.add(tFee);
321     }
322 
323     receive() external payable {}
324 
325     function manualswap() external {
326         require(_msgSender() == _feeAddrWallet);
327         uint256 contractBalance = balanceOf(address(this));
328         swapTokensForEth(contractBalance);
329     }
330 
331     function manualsend() external {
332         require(_msgSender() == _feeAddrWallet);
333         uint256 contractETHBalance = address(this).balance;
334         sendETHToFee(contractETHBalance);
335     }
336 
337 
338     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
339         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
340         uint256 currentRate =  _getRate();
341         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
342         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
343     }
344 
345     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
346         uint256 tFee = tAmount.mul(taxFee).div(100);
347         uint256 tTeam = tAmount.mul(TeamFee).div(100);
348         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
349         return (tTransferAmount, tFee, tTeam);
350     }
351 
352     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
353         uint256 rAmount = tAmount.mul(currentRate);
354         uint256 rFee = tFee.mul(currentRate);
355         uint256 rTeam = tTeam.mul(currentRate);
356         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
357         return (rAmount, rTransferAmount, rFee);
358     }
359 
360 	function _getRate() private view returns(uint256) {
361         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
362         return rSupply.div(tSupply);
363     }
364 
365     function _getCurrentSupply() private view returns(uint256, uint256) {
366         uint256 rSupply = _rTotal;
367         uint256 tSupply = _tTotal;
368         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
369         return (rSupply, tSupply);
370     }
371 }