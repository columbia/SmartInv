1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.17;
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56 
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     address private _previousOwner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor () {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84 }
85 
86 interface IUniswapV2Factory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IUniswapV2Router02 {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98     function factory() external pure returns (address);
99     function WETH() external pure returns (address);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 }
109 
110 contract Protocol is Context, IERC20, Ownable {
111     using SafeMath for uint256;
112     mapping (address => uint256) private _rOwned;
113     mapping (address => uint256) private _tOwned;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping (address => uint) private cooldown;
117     uint256 private constant MAX = ~uint256(0);
118     uint256 private constant _tTotal = 1000000 * 10**9;
119     uint256 private _rTotal = (MAX - (MAX % _tTotal));
120     uint256 private _tFeeTotal;
121 
122     uint256 private _feeAddr1;
123     uint256 private _feeAddr2;
124     uint256 private _standardTax;
125     address payable private _feeAddrWallet;
126 
127     string private constant _name = "Neuralink Protocol";
128     string private constant _symbol = "Neuralink";
129     uint8 private constant _decimals = 9;
130 
131     IUniswapV2Router02 private uniswapV2Router;
132     address private uniswapV2Pair;
133     bool private tradingOpen;
134     bool private inSwap = false;
135     bool private swapEnabled = false;
136     bool private cooldownEnabled = false;
137     uint256 private _maxTxAmount = _tTotal.mul(2).div(100);
138     uint256 private _maxWalletSize = _tTotal.mul(2).div(100);
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
152         _standardTax=5;
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
221             _feeAddr1 = 0;
222             _feeAddr2 = _standardTax;
223             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
224                 // Cooldown
225                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
226                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
227 
228             }
229 
230 
231             uint256 contractTokenBalance = balanceOf(address(this));
232             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
233                 swapTokensForEth(contractTokenBalance);
234                 uint256 contractETHBalance = address(this).balance;
235                 if(contractETHBalance > 0) {
236                     sendETHToFee(address(this).balance);
237                 }
238             }
239         }else{
240           _feeAddr1 = 0;
241           _feeAddr2 = 0;
242         }
243 
244         _tokenTransfer(from,to,amount);
245     }
246 
247     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
248         address[] memory path = new address[](2);
249         path[0] = address(this);
250         path[1] = uniswapV2Router.WETH();
251         _approve(address(this), address(uniswapV2Router), tokenAmount);
252         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
253             tokenAmount,
254             0,
255             path,
256             address(this),
257             block.timestamp
258         );
259     }
260 
261     function setStandardTax(uint256 newTax) external onlyOwner{
262       require(newTax<_standardTax);
263       _standardTax=newTax;
264     }
265 
266     function removeLimits() external onlyOwner{
267         _maxTxAmount = _tTotal;
268         _maxWalletSize = _tTotal;
269     }
270 
271     function sendETHToFee(uint256 amount) private {
272         _feeAddrWallet.transfer(amount);
273     }
274 
275     function openTrading() external onlyOwner() {
276         require(!tradingOpen,"trading is already open");
277         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
278         uniswapV2Router = _uniswapV2Router;
279         _approve(address(this), address(uniswapV2Router), _tTotal);
280         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
281         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
282         swapEnabled = true;
283         cooldownEnabled = true;
284 
285         tradingOpen = true;
286         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
287     }
288 
289     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
290         _transferStandard(sender, recipient, amount);
291     }
292 
293     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
294         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
295         _rOwned[sender] = _rOwned[sender].sub(rAmount);
296         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
297         _takeTeam(tTeam);
298         _reflectFee(rFee, tFee);
299         emit Transfer(sender, recipient, tTransferAmount);
300     }
301 
302     function _takeTeam(uint256 tTeam) private {
303         uint256 currentRate =  _getRate();
304         uint256 rTeam = tTeam.mul(currentRate);
305         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
306     }
307 
308     function _reflectFee(uint256 rFee, uint256 tFee) private {
309         _rTotal = _rTotal.sub(rFee);
310         _tFeeTotal = _tFeeTotal.add(tFee);
311     }
312 
313     receive() external payable {}
314 
315     function manualswap() external {
316         require(_msgSender() == _feeAddrWallet);
317         uint256 contractBalance = balanceOf(address(this));
318         swapTokensForEth(contractBalance);
319     }
320 
321     function manualsend() external {
322         require(_msgSender() == _feeAddrWallet);
323         uint256 contractETHBalance = address(this).balance;
324         sendETHToFee(contractETHBalance);
325     }
326 
327 
328     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
329         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
330         uint256 currentRate =  _getRate();
331         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
332         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
333     }
334 
335     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
336         uint256 tFee = tAmount.mul(taxFee).div(100);
337         uint256 tTeam = tAmount.mul(TeamFee).div(100);
338         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
339         return (tTransferAmount, tFee, tTeam);
340     }
341 
342     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
343         uint256 rAmount = tAmount.mul(currentRate);
344         uint256 rFee = tFee.mul(currentRate);
345         uint256 rTeam = tTeam.mul(currentRate);
346         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
347         return (rAmount, rTransferAmount, rFee);
348     }
349 
350 	function _getRate() private view returns(uint256) {
351         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
352         return rSupply.div(tSupply);
353     }
354 
355     function _getCurrentSupply() private view returns(uint256, uint256) {
356         uint256 rSupply = _rTotal;
357         uint256 tSupply = _tTotal;
358         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
359         return (rSupply, tSupply);
360     }
361 }