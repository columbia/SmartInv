1 /**
2 
3 https://twitter.com/VitalikButerin/status/1580981360499757056
4 
5 $THE is made
6 
7 */
8 
9 pragma solidity 0.8.17;
10 // SPDX-License-Identifier: UNLICENSED
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     address private _previousOwner;
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91 }
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract THEProtocol is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _rOwned;
120     mapping (address => uint256) private _tOwned;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping (address => uint) private cooldown;
125     uint256 private constant MAX = ~uint256(0);
126     uint256 private constant _tTotal = 1000000000 * 10**9;
127     uint256 private _rTotal = (MAX - (MAX % _tTotal));
128     uint256 private _tFeeTotal;
129 
130     uint256 private _feeAddr1;
131     uint256 private _feeAddr2;
132     uint256 private _standardTax;
133     address payable private _feeAddrWallet;
134 
135     string private constant _name = "THE Protocol";
136     string private constant _symbol = "THE";
137     uint8 private constant _decimals = 9;
138 
139     IUniswapV2Router02 private uniswapV2Router;
140     address private uniswapV2Pair;
141     bool private tradingOpen;
142     bool private inSwap = false;
143     bool private swapEnabled = false;
144     bool private cooldownEnabled = false;
145     uint256 private _maxTxAmount = 20000000 * 10**9;
146     uint256 private _maxWalletSize = 30000000 * 10**9;
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
160         _standardTax = 7;
161 
162         emit Transfer(address(0), _msgSender(), _tTotal);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return tokenFromReflection(_rOwned[account]);
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204 
205     function setCooldownEnabled(bool onoff) external onlyOwner() {
206         cooldownEnabled = onoff;
207     }
208 
209     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
210         require(rAmount <= _rTotal, "Amount must be less than total reflections");
211         uint256 currentRate =  _getRate();
212         return rAmount.div(currentRate);
213     }
214 
215     function _approve(address owner, address spender, uint256 amount) private {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _transfer(address from, address to, uint256 amount) private {
223         require(from != address(0), "ERC20: transfer from the zero address");
224         require(to != address(0), "ERC20: transfer to the zero address");
225         require(amount > 0, "Transfer amount must be greater than zero");
226 
227 
228         if (from != owner() && to != owner()) {
229             require(!bots[from] && !bots[to]);
230             _feeAddr1 = 0;
231             _feeAddr2 = _standardTax;
232             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
233                 // Cooldown
234                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
235                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
236 
237             }
238 
239 
240             uint256 contractTokenBalance = balanceOf(address(this));
241             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
242                 swapTokensForEth(contractTokenBalance);
243                 uint256 contractETHBalance = address(this).balance;
244                 if(contractETHBalance > 0) {
245                     sendETHToFee(address(this).balance);
246                 }
247             }
248         }else{
249           _feeAddr1 = 0;
250           _feeAddr2 = 0;
251         }
252 
253         _tokenTransfer(from,to,amount);
254     }
255 
256     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
257         address[] memory path = new address[](2);
258         path[0] = address(this);
259         path[1] = uniswapV2Router.WETH();
260         _approve(address(this), address(uniswapV2Router), tokenAmount);
261         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
262             tokenAmount,
263             0,
264             path,
265             address(this),
266             block.timestamp
267         );
268     }
269 
270     function setStandardTax(uint256 newTax) external onlyOwner{
271       require(newTax<_standardTax);
272       _standardTax=newTax;
273     }
274 
275     function removeLimits() external onlyOwner{
276         _maxTxAmount = _tTotal;
277         _maxWalletSize = _tTotal;
278     }
279 
280     function sendETHToFee(uint256 amount) private {
281         _feeAddrWallet.transfer(amount);
282     }
283 
284     function openTrading() external onlyOwner() {
285         require(!tradingOpen,"trading is already open");
286         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
287         uniswapV2Router = _uniswapV2Router;
288         _approve(address(this), address(uniswapV2Router), _tTotal);
289         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
290         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
291         swapEnabled = true;
292         cooldownEnabled = true;
293 
294         tradingOpen = true;
295         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
296     }
297 
298     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
299         _transferStandard(sender, recipient, amount);
300     }
301 
302     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
303         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
304         _rOwned[sender] = _rOwned[sender].sub(rAmount);
305         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
306         _takeTeam(tTeam);
307         _reflectFee(rFee, tFee);
308         emit Transfer(sender, recipient, tTransferAmount);
309     }
310 
311     function _takeTeam(uint256 tTeam) private {
312         uint256 currentRate =  _getRate();
313         uint256 rTeam = tTeam.mul(currentRate);
314         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
315     }
316 
317     function _reflectFee(uint256 rFee, uint256 tFee) private {
318         _rTotal = _rTotal.sub(rFee);
319         _tFeeTotal = _tFeeTotal.add(tFee);
320     }
321 
322     receive() external payable {}
323 
324     function manualswap() external {
325         require(_msgSender() == _feeAddrWallet);
326         uint256 contractBalance = balanceOf(address(this));
327         swapTokensForEth(contractBalance);
328     }
329 
330     function manualsend() external {
331         require(_msgSender() == _feeAddrWallet);
332         uint256 contractETHBalance = address(this).balance;
333         sendETHToFee(contractETHBalance);
334     }
335 
336 
337     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
338         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
339         uint256 currentRate =  _getRate();
340         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
341         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
342     }
343 
344     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
345         uint256 tFee = tAmount.mul(taxFee).div(100);
346         uint256 tTeam = tAmount.mul(TeamFee).div(100);
347         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
348         return (tTransferAmount, tFee, tTeam);
349     }
350 
351     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
352         uint256 rAmount = tAmount.mul(currentRate);
353         uint256 rFee = tFee.mul(currentRate);
354         uint256 rTeam = tTeam.mul(currentRate);
355         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
356         return (rAmount, rTransferAmount, rFee);
357     }
358 
359 	function _getRate() private view returns(uint256) {
360         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
361         return rSupply.div(tSupply);
362     }
363 
364     function _getCurrentSupply() private view returns(uint256, uint256) {
365         uint256 rSupply = _rTotal;
366         uint256 tSupply = _tTotal;
367         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
368         return (rSupply, tSupply);
369     }
370 }