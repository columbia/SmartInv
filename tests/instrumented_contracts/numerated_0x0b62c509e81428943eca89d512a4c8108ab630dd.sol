1 pragma solidity 0.8.7;
2 // SPDX-License-Identifier: UNLICENSED
3 /*
4 https://t.me/nexusnetworketh
5 https://www.nexusnetwork.online/
6 https://twitter.com/nexus_network_
7 */
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     address private _previousOwner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 
115 contract NXS is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _rOwned;
118     mapping (address => uint256) private _tOwned;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) public bots;
122     mapping (address => uint) private cooldown;
123     uint256 private constant MAX = ~uint256(0);
124     uint256 private constant _tTotal = 1_000_000 * 10**9;
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126     uint256 private _tFeeTotal;
127 
128     uint256 public lBlock = 0;
129     uint256 private dBlocks = 0;
130 
131     uint256 private _feeAddr1;
132     uint256 private _feeAddr2;
133     uint256 private _initialTax;
134     uint256 private _finalTax;
135     uint256 private _reduceTaxCountdown;
136     address payable private _feeAddrWallet;
137 
138     string private constant _name = "Nexus Network";
139     string private constant _symbol = "NXS";
140     uint8 private constant _decimals = 9;
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147     bool private cooldownEnabled = false;
148     uint256 private _maxTxAmount = 1_000_000 * 10**9;
149     uint256 private _maxWalletSize = 20_000 * 10**9;
150     event MaxTxAmountUpdated(uint _maxTxAmount);
151     modifier lockTheSwap {
152         inSwap = true;
153         _;
154         inSwap = false;
155     }
156 
157     constructor () {
158         _feeAddrWallet = payable(_msgSender());
159         _rOwned[_msgSender()] = _rTotal;
160         _isExcludedFromFee[owner()] = true;
161         _isExcludedFromFee[address(this)] = true;
162         _isExcludedFromFee[_feeAddrWallet] = true;
163         _initialTax=10;
164         _finalTax=5;
165         _reduceTaxCountdown=30;
166 
167         emit Transfer(address(0), _msgSender(), _tTotal);
168     }
169 
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public pure override returns (uint256) {
183         return _tTotal;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return tokenFromReflection(_rOwned[account]);
188     }
189 
190     function transfer(address recipient, uint256 amount) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(address owner, address spender) public view override returns (uint256) {
196         return _allowances[owner][spender];
197     }
198 
199     function approve(address spender, uint256 amount) public override returns (bool) {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210     function setCooldownEnabled(bool onoff) external onlyOwner() {
211         cooldownEnabled = onoff;
212     }
213 
214     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
215         require(rAmount <= _rTotal, "Amount must be less than total reflections");
216         uint256 currentRate =  _getRate();
217         return rAmount.div(currentRate);
218     }
219 
220     function _approve(address owner, address spender, uint256 amount) private {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 
227     function _transfer(address from, address to, uint256 amount) private {
228         require(from != address(0), "ERC20: transfer from the zero address");
229         require(to != address(0), "ERC20: transfer to the zero address");
230         require(amount > 0, "Transfer amount must be greater than zero");
231 
232 
233         if (from != owner() && to != owner()) {
234             require(!bots[from] && !bots[to], "Blacklisted.");
235             _feeAddr1 = 0;
236             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
237             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
238                 // Cooldown
239                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
240                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
241                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
242 
243                 if (block.number <= (lBlock + dBlocks)) {
244                     bots[to] = true;
245                 }
246             }
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
278     function removeLimits() external onlyOwner{
279         _maxTxAmount = _tTotal;
280         _maxWalletSize = _tTotal;
281     }
282 
283     function sendETHToFee(uint256 amount) private {
284         _feeAddrWallet.transfer(amount);
285     }
286 
287     function openTrading() external onlyOwner() {
288         require(!tradingOpen,"trading is already open");
289         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
290         uniswapV2Router = _uniswapV2Router;
291         _approve(address(this), address(uniswapV2Router), _tTotal);
292         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
293         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
294         swapEnabled = true;
295         cooldownEnabled = true;
296         lBlock = block.number;
297         tradingOpen = true;
298         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
299     }
300 
301     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
302         _transferStandard(sender, recipient, amount);
303     }
304 
305     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
306         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
307         _rOwned[sender] = _rOwned[sender].sub(rAmount);
308         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
309         _takeTeam(tTeam);
310         _reflectFee(rFee, tFee);
311         emit Transfer(sender, recipient, tTransferAmount);
312     }
313 
314     function _takeTeam(uint256 tTeam) private {
315         uint256 currentRate =  _getRate();
316         uint256 rTeam = tTeam.mul(currentRate);
317         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
318     }
319 
320     function _reflectFee(uint256 rFee, uint256 tFee) private {
321         _rTotal = _rTotal.sub(rFee);
322         _tFeeTotal = _tFeeTotal.add(tFee);
323     }
324 
325     receive() external payable {}
326 
327     function manualswap() external {
328         require(_msgSender() == _feeAddrWallet);
329         uint256 contractBalance = balanceOf(address(this));
330         swapTokensForEth(contractBalance);
331     }
332 
333     function manualsend() external {
334         require(_msgSender() == _feeAddrWallet);
335         uint256 contractETHBalance = address(this).balance;
336         sendETHToFee(contractETHBalance);
337     }
338 
339 
340     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
341         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
342         uint256 currentRate =  _getRate();
343         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
344         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
345     }
346 
347     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
348         uint256 tFee = tAmount.mul(taxFee).div(100);
349         uint256 tTeam = tAmount.mul(TeamFee).div(100);
350         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
351         return (tTransferAmount, tFee, tTeam);
352     }
353 
354     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
355         uint256 rAmount = tAmount.mul(currentRate);
356         uint256 rFee = tFee.mul(currentRate);
357         uint256 rTeam = tTeam.mul(currentRate);
358         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
359         return (rAmount, rTransferAmount, rFee);
360     }
361 
362 	function _getRate() private view returns(uint256) {
363         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
364         return rSupply.div(tSupply);
365     }
366 
367     function _getCurrentSupply() private view returns(uint256, uint256) {
368         uint256 rSupply = _rTotal;
369         uint256 tSupply = _tTotal;
370         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
371         return (rSupply, tSupply);
372     }
373 }