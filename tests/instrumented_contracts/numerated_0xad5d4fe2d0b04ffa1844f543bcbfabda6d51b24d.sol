1 pragma solidity 0.8.9;
2 
3 // SPDX-License-Identifier: UNLICENSED
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
110 contract DIE is Context, IERC20, Ownable {
111     using SafeMath for uint256;
112     mapping (address => uint256) private _rOwned;
113     mapping (address => uint256) private _tOwned;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping (address => bool) private bots;
117     mapping (address => uint) private cooldown;
118     uint256 private constant MAX = ~uint256(0);
119     uint256 private constant _tTotal = 1000000 * 10**9;
120     uint256 private _rTotal = (MAX - (MAX % _tTotal));
121     uint256 private _tFeeTotal;
122 
123     uint256 private _feeAddr1;
124     uint256 private _feeAddr2;
125     uint256 private _standardTax;
126     address payable private _feeAddrWallet;
127 
128     string private constant _name = unicode"死";
129     string private constant _symbol = "$DIE";
130     uint8 private constant _decimals = 9;
131 
132     IUniswapV2Router02 private uniswapV2Router;
133     address private uniswapV2Pair;
134     bool private tradingOpen;
135     bool private inSwap = false;
136     bool private swapEnabled = false;
137     bool private cooldownEnabled = false;
138     uint256 private _maxTxAmount = _tTotal.mul(1).div(100);
139     uint256 private _maxWalletSize = _tTotal.mul(2).div(100);
140     event MaxTxAmountUpdated(uint _maxTxAmount);
141     modifier lockTheSwap {
142         inSwap = true;
143         _;
144         inSwap = false;
145     }
146 
147     constructor () {
148         _feeAddrWallet = payable(_msgSender());
149         _rOwned[_msgSender()] = _rTotal;
150         _isExcludedFromFee[owner()] = true;
151         _isExcludedFromFee[address(this)] = true;
152         _isExcludedFromFee[_feeAddrWallet] = true;
153         _standardTax=1;
154 
155         emit Transfer(address(0), _msgSender(), _tTotal);
156     }
157 
158     function name() public pure returns (string memory) {
159         return _name;
160     }
161 
162     function symbol() public pure returns (string memory) {
163         return _symbol;
164     }
165 
166     function decimals() public pure returns (uint8) {
167         return _decimals;
168     }
169 
170     function totalSupply() public pure override returns (uint256) {
171         return _tTotal;
172     }
173 
174     function balanceOf(address account) public view override returns (uint256) {
175         return tokenFromReflection(_rOwned[account]);
176     }
177 
178     function transfer(address recipient, uint256 amount) public override returns (bool) {
179         _transfer(_msgSender(), recipient, amount);
180         return true;
181     }
182 
183     function allowance(address owner, address spender) public view override returns (uint256) {
184         return _allowances[owner][spender];
185     }
186 
187     function approve(address spender, uint256 amount) public override returns (bool) {
188         _approve(_msgSender(), spender, amount);
189         return true;
190     }
191 
192     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
193         _transfer(sender, recipient, amount);
194         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
195         return true;
196     }
197 
198     function setCooldownEnabled(bool onoff) external onlyOwner() {
199         cooldownEnabled = onoff;
200     }
201 
202     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
203         require(rAmount <= _rTotal, "Amount must be less than total reflections");
204         uint256 currentRate =  _getRate();
205         return rAmount.div(currentRate);
206     }
207 
208     function _approve(address owner, address spender, uint256 amount) private {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function _transfer(address from, address to, uint256 amount) private {
216         require(from != address(0), "ERC20: transfer from the zero address");
217         require(to != address(0), "ERC20: transfer to the zero address");
218         require(amount > 0, "Transfer amount must be greater than zero");
219 
220 
221         if (from != owner() && to != owner()) {
222             require(!bots[from] && !bots[to]);
223             _feeAddr1 = 0;
224             _feeAddr2 = _standardTax;
225             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
226                 // Cooldown
227                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
228                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
229 
230             }
231 
232 
233             uint256 contractTokenBalance = balanceOf(address(this));
234             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
235                 swapTokensForEth(contractTokenBalance);
236                 uint256 contractETHBalance = address(this).balance;
237                 if(contractETHBalance > 0) {
238                     sendETHToFee(address(this).balance);
239                 }
240             }
241         }else{
242           _feeAddr1 = 0;
243           _feeAddr2 = 0;
244         }
245 
246         _tokenTransfer(from,to,amount);
247     }
248 
249     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
250         address[] memory path = new address[](2);
251         path[0] = address(this);
252         path[1] = uniswapV2Router.WETH();
253         _approve(address(this), address(uniswapV2Router), tokenAmount);
254         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
255             tokenAmount,
256             0,
257             path,
258             address(this),
259             block.timestamp
260         );
261     }
262 
263     function setStandardTax(uint256 newTax) external onlyOwner{
264       require(newTax<_standardTax);
265       _standardTax=newTax;
266     }
267 
268     function removeLimits() external onlyOwner{
269         _maxTxAmount = _tTotal;
270         _maxWalletSize = _tTotal;
271     }
272 
273     function sendETHToFee(uint256 amount) private {
274         _feeAddrWallet.transfer(amount);
275     }
276 
277     function openTrading() external onlyOwner() {
278         require(!tradingOpen,"trading is already open");
279         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
280         uniswapV2Router = _uniswapV2Router;
281         _approve(address(this), address(uniswapV2Router), _tTotal);
282         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
283         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
284         swapEnabled = true;
285         cooldownEnabled = true;
286 
287         tradingOpen = true;
288         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
289     }
290 
291         function addbot(address[] memory bots_) public onlyOwner {
292         for (uint i = 0; i < bots_.length; i++) {
293             bots[bots_[i]] = true;
294         }
295     }
296 
297     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
298         _transferStandard(sender, recipient, amount);
299     }
300 
301     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
302         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
303         _rOwned[sender] = _rOwned[sender].sub(rAmount);
304         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
305         _takeTeam(tTeam);
306         _reflectFee(rFee, tFee);
307         emit Transfer(sender, recipient, tTransferAmount);
308     }
309 
310     function _takeTeam(uint256 tTeam) private {
311         uint256 currentRate =  _getRate();
312         uint256 rTeam = tTeam.mul(currentRate);
313         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
314     }
315 
316     function _reflectFee(uint256 rFee, uint256 tFee) private {
317         _rTotal = _rTotal.sub(rFee);
318         _tFeeTotal = _tFeeTotal.add(tFee);
319     }
320 
321     receive() external payable {}
322 
323     function manualswap() external {
324         require(_msgSender() == _feeAddrWallet);
325         uint256 contractBalance = balanceOf(address(this));
326         swapTokensForEth(contractBalance);
327     }
328 
329     function manualsend() external {
330         require(_msgSender() == _feeAddrWallet);
331         uint256 contractETHBalance = address(this).balance;
332         sendETHToFee(contractETHBalance);
333     }
334 
335 
336     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
337         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
338         uint256 currentRate =  _getRate();
339         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
340         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
341     }
342 
343     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
344         uint256 tFee = tAmount.mul(taxFee).div(100);
345         uint256 tTeam = tAmount.mul(TeamFee).div(100);
346         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
347         return (tTransferAmount, tFee, tTeam);
348     }
349 
350     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
351         uint256 rAmount = tAmount.mul(currentRate);
352         uint256 rFee = tFee.mul(currentRate);
353         uint256 rTeam = tTeam.mul(currentRate);
354         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
355         return (rAmount, rTransferAmount, rFee);
356     }
357 
358 	function _getRate() private view returns(uint256) {
359         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
360         return rSupply.div(tSupply);
361     }
362 
363     function _getCurrentSupply() private view returns(uint256, uint256) {
364         uint256 rSupply = _rTotal;
365         uint256 tSupply = _tTotal;
366         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
367         return (rSupply, tSupply);
368     }
369 }