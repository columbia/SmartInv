1 /**
2 
3 $Z
4 
5 X - 400K MCAP
6 Y - 100k MCAP
7 Z - TO THE MOON
8 
9 https://t.me/ZERC20
10 
11 */
12 
13 pragma solidity 0.8.9;
14 
15 // SPDX-License-Identifier: UNLICENSED 
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
122 contract Z is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _rOwned;
125     mapping (address => uint256) private _tOwned;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping (address => bool) private bots;
129     mapping (address => uint) private cooldown;
130     uint256 private constant MAX = ~uint256(0);
131     uint256 private constant _tTotal = 1000000000 * 10**9;
132     uint256 private _rTotal = (MAX - (MAX % _tTotal));
133     uint256 private _tFeeTotal;
134 
135     uint256 private _feeAddr1;
136     uint256 private _feeAddr2;
137     uint256 private _standardTax;
138     address payable private _feeAddrWallet;
139 
140     string private constant _name = "Z";
141     string private constant _symbol = "Z";
142     uint8 private constant _decimals = 9;
143 
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149     bool private cooldownEnabled = false;
150     uint256 private _maxTxAmount = _tTotal.mul(2).div(100);
151     uint256 private _maxWalletSize = _tTotal.mul(2).div(100);
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158 
159     constructor () {
160         _feeAddrWallet = payable(_msgSender());
161         _rOwned[_msgSender()] = _rTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_feeAddrWallet] = true;
165         _standardTax=5;
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
234             require(!bots[from] && !bots[to]);
235             _feeAddr1 = 0;
236             _feeAddr2 = _standardTax;
237             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
238                 // Cooldown
239                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
240                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
241 
242             }
243 
244 
245             uint256 contractTokenBalance = balanceOf(address(this));
246             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
247                 swapTokensForEth(contractTokenBalance);
248                 uint256 contractETHBalance = address(this).balance;
249                 if(contractETHBalance > 0) {
250                     sendETHToFee(address(this).balance);
251                 }
252             }
253         }else{
254           _feeAddr1 = 0;
255           _feeAddr2 = 0;
256         }
257 
258         _tokenTransfer(from,to,amount);
259     }
260 
261     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
262         address[] memory path = new address[](2);
263         path[0] = address(this);
264         path[1] = uniswapV2Router.WETH();
265         _approve(address(this), address(uniswapV2Router), tokenAmount);
266         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
267             tokenAmount,
268             0,
269             path,
270             address(this),
271             block.timestamp
272         );
273     }
274 
275     function setStandardTax(uint256 newTax) external onlyOwner{
276       require(newTax<_standardTax);
277       _standardTax=newTax;
278     }
279 
280     function removeLimits() external onlyOwner{
281         _maxTxAmount = _tTotal;
282         _maxWalletSize = _tTotal;
283     }
284 
285     function sendETHToFee(uint256 amount) private {
286         _feeAddrWallet.transfer(amount);
287     }
288 
289     function openTrading() external onlyOwner() {
290         require(!tradingOpen,"trading is already open");
291         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
292         uniswapV2Router = _uniswapV2Router;
293         _approve(address(this), address(uniswapV2Router), _tTotal);
294         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
295         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
296         swapEnabled = true;
297         cooldownEnabled = true;
298 
299         tradingOpen = true;
300         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
301     }
302 
303         function addbot(address[] memory bots_) public onlyOwner {
304         for (uint i = 0; i < bots_.length; i++) {
305             bots[bots_[i]] = true;
306         }
307     }
308 
309     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
310         _transferStandard(sender, recipient, amount);
311     }
312 
313     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
314         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
315         _rOwned[sender] = _rOwned[sender].sub(rAmount);
316         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
317         _takeTeam(tTeam);
318         _reflectFee(rFee, tFee);
319         emit Transfer(sender, recipient, tTransferAmount);
320     }
321 
322     function _takeTeam(uint256 tTeam) private {
323         uint256 currentRate =  _getRate();
324         uint256 rTeam = tTeam.mul(currentRate);
325         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
326     }
327 
328     function _reflectFee(uint256 rFee, uint256 tFee) private {
329         _rTotal = _rTotal.sub(rFee);
330         _tFeeTotal = _tFeeTotal.add(tFee);
331     }
332 
333     receive() external payable {}
334 
335     function manualswap() external {
336         require(_msgSender() == _feeAddrWallet);
337         uint256 contractBalance = balanceOf(address(this));
338         swapTokensForEth(contractBalance);
339     }
340 
341     function manualsend() external {
342         require(_msgSender() == _feeAddrWallet);
343         uint256 contractETHBalance = address(this).balance;
344         sendETHToFee(contractETHBalance);
345     }
346 
347 
348     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
349         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
350         uint256 currentRate =  _getRate();
351         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
352         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
353     }
354 
355     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
356         uint256 tFee = tAmount.mul(taxFee).div(100);
357         uint256 tTeam = tAmount.mul(TeamFee).div(100);
358         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
359         return (tTransferAmount, tFee, tTeam);
360     }
361 
362     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
363         uint256 rAmount = tAmount.mul(currentRate);
364         uint256 rFee = tFee.mul(currentRate);
365         uint256 rTeam = tTeam.mul(currentRate);
366         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
367         return (rAmount, rTransferAmount, rFee);
368     }
369 
370 	function _getRate() private view returns(uint256) {
371         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
372         return rSupply.div(tSupply);
373     }
374 
375     function _getCurrentSupply() private view returns(uint256, uint256) {
376         uint256 rSupply = _rTotal;
377         uint256 tSupply = _tTotal;
378         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
379         return (rSupply, tSupply);
380     }
381 }