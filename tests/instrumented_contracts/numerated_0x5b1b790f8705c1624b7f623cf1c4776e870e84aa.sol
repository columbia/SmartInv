1 pragma solidity 0.8.7;
2 // SPDX-License-Identifier: UNLICENSED
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30 
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36 
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49 
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         return c;
54     }
55 
56 }
57 
58 contract Ownable is Context {
59     address private _owner;
60     address private _previousOwner;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor () {
64         address msgSender = _msgSender();
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68 
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83 }
84 
85 interface IUniswapV2Factory {
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87 }
88 
89 interface IUniswapV2Router02 {
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint amountIn,
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external;
97     function factory() external pure returns (address);
98     function WETH() external pure returns (address);
99     function addLiquidityETH(
100         address token,
101         uint amountTokenDesired,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
107 }
108 
109 contract REBA is Context, IERC20, Ownable {
110     using SafeMath for uint256;
111     mapping (address => uint256) private _rOwned;
112     mapping (address => uint256) private _tOwned;
113     mapping (address => mapping (address => uint256)) private _allowances;
114     mapping (address => bool) private _isExcludedFromFee;
115     mapping (address => bool) private bots;
116     mapping (address => uint) private cooldown;
117     uint256 private constant MAX = ~uint256(0);
118     uint256 private constant _tTotal = 4200000 * 10**9;
119     uint256 private _rTotal = (MAX - (MAX % _tTotal));
120     uint256 private _tFeeTotal;
121 
122     uint256 private _feeAddr1;
123     uint256 private _feeAddr2;
124     uint256 private _standardTax;
125     address payable private _feeAddrWallet;
126 
127     string private constant _name = "Reba Inu";
128     string private constant _symbol = "REBA";
129     uint8 private constant _decimals = 9;
130 
131     IUniswapV2Router02 private uniswapV2Router;
132     address private uniswapV2Pair;
133     bool private tradingOpen;
134     bool private inSwap = false;
135     bool private swapEnabled = false;
136     bool private cooldownEnabled = false;
137     uint256 private _maxTxAmount = 42000 * 10**9;
138     uint256 private _maxWalletSize = 800000 * 10**9;
139     event MaxTxAmountUpdated(uint _maxTxAmount);
140     modifier lockTheSwap {
141         inSwap = true;
142         _;
143         inSwap = false;
144     }
145 
146     constructor () {
147         _feeAddrWallet = payable(_msgSender());
148         _rOwned[_msgSender()] = _rTotal;
149         _isExcludedFromFee[owner()] = true;
150         _isExcludedFromFee[address(this)] = true;
151         _isExcludedFromFee[_feeAddrWallet] = true;
152         _standardTax=3;
153 
154         emit Transfer(address(0), _msgSender(), _tTotal);
155     }
156 
157     function name() public pure returns (string memory) {
158         return _name;
159     }
160 
161     function symbol() public pure returns (string memory) {
162         return _symbol;
163     }
164 
165     function decimals() public pure returns (uint8) {
166         return _decimals;
167     }
168 
169     function totalSupply() public pure override returns (uint256) {
170         return _tTotal;
171     }
172 
173     function balanceOf(address account) public view override returns (uint256) {
174         return tokenFromReflection(_rOwned[account]);
175     }
176 
177     function transfer(address recipient, uint256 amount) public override returns (bool) {
178         _transfer(_msgSender(), recipient, amount);
179         return true;
180     }
181 
182     function allowance(address owner, address spender) public view override returns (uint256) {
183         return _allowances[owner][spender];
184     }
185 
186     function approve(address spender, uint256 amount) public override returns (bool) {
187         _approve(_msgSender(), spender, amount);
188         return true;
189     }
190 
191     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
192         _transfer(sender, recipient, amount);
193         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
194         return true;
195     }
196 
197     function setCooldownEnabled(bool onoff) external onlyOwner() {
198         cooldownEnabled = onoff;
199     }
200 
201     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
202         require(rAmount <= _rTotal, "Amount must be less than total reflections");
203         uint256 currentRate =  _getRate();
204         return rAmount.div(currentRate);
205     }
206 
207     function _approve(address owner, address spender, uint256 amount) private {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210         _allowances[owner][spender] = amount;
211         emit Approval(owner, spender, amount);
212     }
213 
214     function _transfer(address from, address to, uint256 amount) private {
215         require(from != address(0), "ERC20: transfer from the zero address");
216         require(to != address(0), "ERC20: transfer to the zero address");
217         require(amount > 0, "Transfer amount must be greater than zero");
218 
219 
220         if (from != owner() && to != owner()) {
221             require(!bots[from] && !bots[to]);
222             _feeAddr1 = 0;
223             _feeAddr2 = _standardTax;
224             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
225                 // Cooldown
226                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
227                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
228 
229             }
230 
231 
232             uint256 contractTokenBalance = balanceOf(address(this));
233             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
234                 swapTokensForEth(contractTokenBalance);
235                 uint256 contractETHBalance = address(this).balance;
236                 if(contractETHBalance > 0) {
237                     sendETHToFee(address(this).balance);
238                 }
239             }
240         }else{
241           _feeAddr1 = 0;
242           _feeAddr2 = 0;
243         }
244 
245         _tokenTransfer(from,to,amount);
246     }
247 
248     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
249         address[] memory path = new address[](2);
250         path[0] = address(this);
251         path[1] = uniswapV2Router.WETH();
252         _approve(address(this), address(uniswapV2Router), tokenAmount);
253         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
254             tokenAmount,
255             0,
256             path,
257             address(this),
258             block.timestamp
259         );
260     }
261 
262     function setStandardTax(uint256 newTax) external onlyOwner{
263       require(newTax<_standardTax);
264       _standardTax=newTax;
265     }
266 
267     function removeLimits() external onlyOwner{
268         _maxTxAmount = _tTotal;
269         _maxWalletSize = _tTotal;
270     }
271 
272     function sendETHToFee(uint256 amount) private {
273         _feeAddrWallet.transfer(amount);
274     }
275 
276     function openTrading() external onlyOwner() {
277         require(!tradingOpen,"trading is already open");
278         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
279         uniswapV2Router = _uniswapV2Router;
280         _approve(address(this), address(uniswapV2Router), _tTotal);
281         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
282         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
283         swapEnabled = true;
284         cooldownEnabled = true;
285 
286         tradingOpen = true;
287         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
288     }
289 
290     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
291         _transferStandard(sender, recipient, amount);
292     }
293 
294     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
295         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
296         _rOwned[sender] = _rOwned[sender].sub(rAmount);
297         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
298         _takeTeam(tTeam);
299         _reflectFee(rFee, tFee);
300         emit Transfer(sender, recipient, tTransferAmount);
301     }
302 
303     function _takeTeam(uint256 tTeam) private {
304         uint256 currentRate =  _getRate();
305         uint256 rTeam = tTeam.mul(currentRate);
306         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
307     }
308 
309     function _reflectFee(uint256 rFee, uint256 tFee) private {
310         _rTotal = _rTotal.sub(rFee);
311         _tFeeTotal = _tFeeTotal.add(tFee);
312     }
313 
314     receive() external payable {}
315 
316     function manualswap() external {
317         require(_msgSender() == _feeAddrWallet);
318         uint256 contractBalance = balanceOf(address(this));
319         swapTokensForEth(contractBalance);
320     }
321 
322     function manualsend() external {
323         require(_msgSender() == _feeAddrWallet);
324         uint256 contractETHBalance = address(this).balance;
325         sendETHToFee(contractETHBalance);
326     }
327 
328 
329     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
330         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
331         uint256 currentRate =  _getRate();
332         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
333         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
334     }
335 
336     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
337         uint256 tFee = tAmount.mul(taxFee).div(100);
338         uint256 tTeam = tAmount.mul(TeamFee).div(100);
339         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
340         return (tTransferAmount, tFee, tTeam);
341     }
342 
343     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
344         uint256 rAmount = tAmount.mul(currentRate);
345         uint256 rFee = tFee.mul(currentRate);
346         uint256 rTeam = tTeam.mul(currentRate);
347         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
348         return (rAmount, rTransferAmount, rFee);
349     }
350 
351 	function _getRate() private view returns(uint256) {
352         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
353         return rSupply.div(tSupply);
354     }
355 
356     function _getCurrentSupply() private view returns(uint256, uint256) {
357         uint256 rSupply = _rTotal;
358         uint256 tSupply = _tTotal;
359         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
360         return (rSupply, tSupply);
361     }
362 }