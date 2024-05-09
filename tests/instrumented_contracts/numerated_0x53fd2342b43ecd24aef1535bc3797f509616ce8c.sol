1 /**
2 
3 Anarchy - a state of disorder due to absence or non-recognition of authority or other controlling systems.
4 
5 Authorities in crypto world like 3ac, Voyager Digital, LFG and etc  captured investors' fund and gave false hope and promise to them. Eventually they never fulfil what they promised. They lied. They fled. They failed. It's time for us to build a community in anarchy way.
6 
7 We hate authority, we as the initiator of the movement will not open any "official group". Instead, please feel free to open group(s) and send the link to @anarchyinitiator. We will announce it and let you control it.
8 
9 Initial tax: 6%
10 Max tx: 2%
11 Max wallet 2%
12 
13 @anarchystatus
14 
15 */
16 
17 
18 pragma solidity 0.8.7;
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
126 contract Anarchy is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _rOwned;
129     mapping (address => uint256) private _tOwned;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) private _isExcludedFromFee;
132     mapping (address => bool) private bots;
133     mapping (address => uint) private cooldown;
134     uint256 private constant MAX = ~uint256(0);
135     uint256 private constant _tTotal = 5000000 * 10**9;
136     uint256 private _rTotal = (MAX - (MAX % _tTotal));
137     uint256 private _tFeeTotal;
138 
139     uint256 private _feeAddr1;
140     uint256 private _feeAddr2;
141     uint256 private _standardTax;
142     address payable private _feeAddrWallet;
143 
144     string private constant _name = "Anarchy";
145     string private constant _symbol = "ANARCHY";
146     uint8 private constant _decimals = 9;
147 
148     IUniswapV2Router02 private uniswapV2Router;
149     address private uniswapV2Pair;
150     bool private tradingOpen;
151     bool private inSwap = false;
152     bool private swapEnabled = false;
153     bool private cooldownEnabled = false;
154     uint256 private _maxTxAmount = 100000 * 10**9;
155     uint256 private _maxWalletSize = 100000 * 10**9;
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162 
163     constructor () {
164         _feeAddrWallet = payable(_msgSender());
165         _rOwned[_msgSender()] = _rTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_feeAddrWallet] = true;
169         _standardTax=6;
170 
171         emit Transfer(address(0), _msgSender(), _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
188     }
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return tokenFromReflection(_rOwned[account]);
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function setCooldownEnabled(bool onoff) external onlyOwner() {
215         cooldownEnabled = onoff;
216     }
217 
218     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
219         require(rAmount <= _rTotal, "Amount must be less than total reflections");
220         uint256 currentRate =  _getRate();
221         return rAmount.div(currentRate);
222     }
223 
224     function _approve(address owner, address spender, uint256 amount) private {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231     function _transfer(address from, address to, uint256 amount) private {
232         require(from != address(0), "ERC20: transfer from the zero address");
233         require(to != address(0), "ERC20: transfer to the zero address");
234         require(amount > 0, "Transfer amount must be greater than zero");
235 
236 
237         if (from != owner() && to != owner()) {
238             require(!bots[from] && !bots[to]);
239             _feeAddr1 = 0;
240             _feeAddr2 = _standardTax;
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
242                 // Cooldown
243                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
244                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
245 
246             }
247 
248 
249             uint256 contractTokenBalance = balanceOf(address(this));
250             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
251                 swapTokensForEth(contractTokenBalance);
252                 uint256 contractETHBalance = address(this).balance;
253                 if(contractETHBalance > 0) {
254                     sendETHToFee(address(this).balance);
255                 }
256             }
257         }else{
258           _feeAddr1 = 0;
259           _feeAddr2 = 0;
260         }
261 
262         _tokenTransfer(from,to,amount);
263     }
264 
265     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
266         address[] memory path = new address[](2);
267         path[0] = address(this);
268         path[1] = uniswapV2Router.WETH();
269         _approve(address(this), address(uniswapV2Router), tokenAmount);
270         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
271             tokenAmount,
272             0,
273             path,
274             address(this),
275             block.timestamp
276         );
277     }
278 
279     function setStandardTax(uint256 newTax) external onlyOwner{
280       require(newTax<_standardTax);
281       _standardTax=newTax;
282     }
283 
284     function removeLimits() external onlyOwner{
285         _maxTxAmount = _tTotal;
286         _maxWalletSize = _tTotal;
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