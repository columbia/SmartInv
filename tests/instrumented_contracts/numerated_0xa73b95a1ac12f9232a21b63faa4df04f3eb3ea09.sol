1 /**
2 
3 SNIPEBOT - sniper utillity token
4 
5 Telegram: https://t.me/snipebotportal
6 Web: https://snipebot.org/
7 
8 SPDX-License-Identifier: UNLICENSED
9 ****/
10 
11 pragma solidity 0.8.7;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     address private _previousOwner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract SNIPEBOT is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _rOwned;
122     mapping (address => uint256) private _tOwned;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     mapping (address => uint) private cooldown;
127     uint256 private constant MAX = ~uint256(0);
128     uint256 private constant _tTotal = 100_000_000 * 10**9;
129     uint256 private _rTotal = (MAX - (MAX % _tTotal));
130     uint256 private _tFeeTotal;
131     uint256 private _feeAddr1;
132     uint256 private _feeAddr2;
133     uint256 private _initialTax;
134     uint256 private _finalTax;
135     uint256 private _reduceTaxCountdown;
136     address payable private _feeAddrWallet;
137 
138     string private constant _name = "SnipeBot";
139     string private constant _symbol = "SNIPEBOT";
140     uint8 private constant _decimals = 9;
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147     bool private cooldownEnabled = false;
148     uint256 private _maxTxAmount = 3_100_000 * 10**9;
149     uint256 private _maxWalletSize = 4_000_000 * 10**9;
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
163         _initialTax=16;
164         _finalTax=5;
165         _reduceTaxCountdown=300;
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
236             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
237             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
238                 // Cooldown
239                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
240                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
241                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
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
275     function setMarketingAndDevelopmentTax(uint256 tax) external onlyOwner{
276         _initialTax = tax;
277         _finalTax = tax;
278     }
279 
280     function removeTransactionLimits() external onlyOwner{
281         _maxTxAmount = _tTotal;
282     }
283 
284     function sendETHToFee(uint256 amount) private {
285         _feeAddrWallet.transfer(amount);
286     }
287 
288     function openTrading() external onlyOwner() {
289         require(!tradingOpen,"trading is already open");
290         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
291         uniswapV2Router = _uniswapV2Router;
292         _approve(address(this), address(uniswapV2Router), _tTotal);
293         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
294         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
295         swapEnabled = true;
296         cooldownEnabled = true;
297 
298         tradingOpen = true;
299         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
300     }
301 
302     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
303         _transferStandard(sender, recipient, amount);
304     }
305 
306     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
307         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
308         _rOwned[sender] = _rOwned[sender].sub(rAmount);
309         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
310         _takeTeam(tTeam);
311         _reflectFee(rFee, tFee);
312         emit Transfer(sender, recipient, tTransferAmount);
313     }
314 
315     function _takeTeam(uint256 tTeam) private {
316         uint256 currentRate =  _getRate();
317         uint256 rTeam = tTeam.mul(currentRate);
318         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
319     }
320 
321     function _reflectFee(uint256 rFee, uint256 tFee) private {
322         _rTotal = _rTotal.sub(rFee);
323         _tFeeTotal = _tFeeTotal.add(tFee);
324     }
325 
326     receive() external payable {}
327 
328     function manualswap() external {
329         require(_msgSender() == _feeAddrWallet);
330         uint256 contractBalance = balanceOf(address(this));
331         swapTokensForEth(contractBalance);
332     }
333 
334     function manualsend() external {
335         require(_msgSender() == _feeAddrWallet);
336         uint256 contractETHBalance = address(this).balance;
337         sendETHToFee(contractETHBalance);
338     }
339 
340 
341     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
342         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
343         uint256 currentRate =  _getRate();
344         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
345         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
346     }
347 
348     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
349         uint256 tFee = tAmount.mul(taxFee).div(100);
350         uint256 tTeam = tAmount.mul(TeamFee).div(100);
351         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
352         return (tTransferAmount, tFee, tTeam);
353     }
354 
355     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
356         uint256 rAmount = tAmount.mul(currentRate);
357         uint256 rFee = tFee.mul(currentRate);
358         uint256 rTeam = tTeam.mul(currentRate);
359         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
360         return (rAmount, rTransferAmount, rFee);
361     }
362 
363 	function _getRate() private view returns(uint256) {
364         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
365         return rSupply.div(tSupply);
366     }
367 
368     function _getCurrentSupply() private view returns(uint256, uint256) {
369         uint256 rSupply = _rTotal;
370         uint256 tSupply = _tTotal;
371         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
372         return (rSupply, tSupply);
373     }
374 }