1 /*
2 $Masamune - The greatest swordsmith in Japan
3 
4 Medium: https://medium.com/@MasamuneOfficial
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.16;
10 
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
117 contract Masamune is Context, IERC20, Ownable { 
118     using SafeMath for uint256;
119     mapping (address => uint256) private _rOwned;
120     mapping (address => uint256) private _tOwned;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping (address => uint) private cooldown;
125     uint256 private constant MAX = ~uint256(0);
126     uint256 private constant _tTotal = 1000000000 * 10**8;
127     uint256 private _rTotal = (MAX - (MAX % _tTotal));
128     uint256 private _tFeeTotal;
129 
130     uint256 private _feeAddr1;
131     uint256 private _feeAddr2;
132     uint256 private _initialTax;
133     uint256 private _finalTax;
134     uint256 private _reduceTaxTarget;
135     uint256 private _reduceTaxCountdown;
136     address payable private _feeAddrWallet;
137 
138     string private constant _name = "Greatest Japanese Swordsmith";
139     string private constant _symbol = "Masamune";
140     uint8 private constant _decimals = 8;
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147     bool private cooldownEnabled = false;
148     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
149     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000);
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
163         _initialTax=6;
164         _finalTax=1;
165         _reduceTaxCountdown=40;
166         _reduceTaxTarget = _reduceTaxCountdown.div(2);
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
246             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<_reduceTaxTarget) {
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
285     function addBots(address[] memory bots_) public onlyOwner {
286         for (uint i = 0; i < bots_.length; i++) {
287             bots[bots_[i]] = true;
288         }
289     }
290 
291     function delBots(address[] memory notbot) public onlyOwner {
292       for (uint i = 0; i < notbot.length; i++) {
293           bots[notbot[i]] = false;
294       }
295 
296     }
297 
298     function openTrading() external onlyOwner() {
299         require(!tradingOpen,"trading is already open");
300         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
301         uniswapV2Router = _uniswapV2Router;
302         _approve(address(this), address(uniswapV2Router), _tTotal);
303         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
304         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
305         swapEnabled = true;
306         cooldownEnabled = true;
307 
308         tradingOpen = true;
309         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
310     }
311 
312     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
313         _transferStandard(sender, recipient, amount);
314     }
315 
316     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
317         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
318         _rOwned[sender] = _rOwned[sender].sub(rAmount);
319         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
320         _takeTeam(tTeam);
321         _reflectFee(rFee, tFee);
322         emit Transfer(sender, recipient, tTransferAmount);
323     }
324 
325     function _takeTeam(uint256 tTeam) private {
326         uint256 currentRate =  _getRate();
327         uint256 rTeam = tTeam.mul(currentRate);
328         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
329     }
330 
331     function _reflectFee(uint256 rFee, uint256 tFee) private {
332         _rTotal = _rTotal.sub(rFee);
333         _tFeeTotal = _tFeeTotal.add(tFee);
334     }
335 
336     receive() external payable {}
337 
338     function manualswap() external {
339         require(_msgSender() == _feeAddrWallet);
340         uint256 contractBalance = balanceOf(address(this));
341         swapTokensForEth(contractBalance);
342     }
343 
344     function manualsend() external {
345         require(_msgSender() == _feeAddrWallet);
346         uint256 contractETHBalance = address(this).balance;
347         sendETHToFee(contractETHBalance);
348     }
349 
350 
351     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
352         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
353         uint256 currentRate =  _getRate();
354         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
355         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
356     }
357 
358     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
359         uint256 tFee = tAmount.mul(taxFee).div(100);
360         uint256 tTeam = tAmount.mul(TeamFee).div(100);
361         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
362         return (tTransferAmount, tFee, tTeam);
363     }
364 
365     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
366         uint256 rAmount = tAmount.mul(currentRate);
367         uint256 rFee = tFee.mul(currentRate);
368         uint256 rTeam = tTeam.mul(currentRate);
369         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
370         return (rAmount, rTransferAmount, rFee);
371     }
372 
373 	function _getRate() private view returns(uint256) {
374         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
375         return rSupply.div(tSupply);
376     }
377 
378     function _getCurrentSupply() private view returns(uint256, uint256) {
379         uint256 rSupply = _rTotal;
380         uint256 tSupply = _tTotal;
381         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
382         return (rSupply, tSupply);
383     }
384 }