1 // SPDX-License-Identifier: UNLICENSED
2 /*
3     https://t.me/hokkaidotoken
4 
5     https://twitter.com/HokkaidoToken
6 */
7 
8 pragma solidity 0.8.9;
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
115 contract HOKK is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _rOwned;
118     mapping (address => uint256) private _tOwned;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) private bots;
122     mapping (address => uint) private cooldown;
123     uint256 private constant MAX = ~uint256(0);
124     uint256 private constant _tTotal = 100000000 * 10**9;
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126     uint256 private _tFeeTotal;
127 
128     uint256 private _feeAddr1;
129     uint256 private _feeAddr2;
130     uint256 private _standardTax;
131     address payable private _feeAddrWallet;
132 
133     string private constant _name = "Hokkaido Inu";
134     string private constant _symbol = "HOKK";
135     uint8 private constant _decimals = 9; 
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142     bool private cooldownEnabled = false;
143     uint256 private _maxTxAmount = _tTotal.mul(2).div(100);
144     uint256 private _maxWalletSize = _tTotal.mul(2).div(100);
145     event MaxTxAmountUpdated(uint _maxTxAmount);
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151 
152     constructor () {
153         _feeAddrWallet = payable(_msgSender());
154         _rOwned[_msgSender()] = _rTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[_feeAddrWallet] = true;
158         _standardTax=5;
159 
160         emit Transfer(address(0), _msgSender(), _tTotal);
161     }
162 
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return tokenFromReflection(_rOwned[account]);
181     }
182 
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function setCooldownEnabled(bool onoff) external onlyOwner() {
204         cooldownEnabled = onoff;
205     }
206 
207     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
208         require(rAmount <= _rTotal, "Amount must be less than total reflections");
209         uint256 currentRate =  _getRate();
210         return rAmount.div(currentRate);
211     }
212 
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224 
225 
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228             _feeAddr1 = 0;
229             _feeAddr2 = _standardTax;
230             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
231                 // Cooldown
232                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
233                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
234 
235             }
236 
237 
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
240                 swapTokensForEth(contractTokenBalance);
241                 uint256 contractETHBalance = address(this).balance;
242                 if(contractETHBalance > 0) {
243                     sendETHToFee(address(this).balance);
244                 }
245             }
246         }else{
247           _feeAddr1 = 0;
248           _feeAddr2 = 0;
249         }
250 
251         _tokenTransfer(from,to,amount);
252     }
253 
254     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
255         address[] memory path = new address[](2);
256         path[0] = address(this);
257         path[1] = uniswapV2Router.WETH();
258         _approve(address(this), address(uniswapV2Router), tokenAmount);
259         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
260             tokenAmount,
261             0,
262             path,
263             address(this),
264             block.timestamp
265         );
266     }
267 
268     function setStandardTax(uint256 newTax) external onlyOwner{
269       _standardTax=newTax;
270     }
271 
272     function removeLimits() external onlyOwner{
273         _maxTxAmount = _tTotal;
274         _maxWalletSize = _tTotal;
275     }
276 
277     function sendETHToFee(uint256 amount) private {
278         _feeAddrWallet.transfer(amount);
279     }
280 
281     function openTrading() external onlyOwner() {
282         require(!tradingOpen,"trading is already open");
283         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
284         uniswapV2Router = _uniswapV2Router;
285         _approve(address(this), address(uniswapV2Router), _tTotal);
286         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
287         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
288         swapEnabled = true;
289         cooldownEnabled = true;
290 
291         tradingOpen = true;
292         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
293     }
294 
295     function addbot(address[] memory bots_) public onlyOwner {
296         for (uint i = 0; i < bots_.length; i++) {
297             bots[bots_[i]] = true;
298         }
299     }
300 
301     function delbot(address _address) external onlyOwner {
302         bots[_address] = false;
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