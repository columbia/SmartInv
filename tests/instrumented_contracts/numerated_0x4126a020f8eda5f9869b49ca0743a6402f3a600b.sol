1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.16;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     address private _previousOwner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85 }
86 
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract Hunters is Context, IERC20, Ownable { 
112     using SafeMath for uint256;
113     mapping (address => uint256) private _rOwned;
114     mapping (address => uint256) private _tOwned;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping (address => uint) private cooldown;
119     uint256 private constant MAX = ~uint256(0);
120     uint256 private constant _tTotal = 1000000000 * 10**8;
121     uint256 private _rTotal = (MAX - (MAX % _tTotal));
122     uint256 private _tFeeTotal;
123 
124     uint256 private _feeAddr1;
125     uint256 private _feeAddr2;
126     uint256 private _initialTax;
127     uint256 private _finalTax;
128     uint256 private _reduceTaxTarget;
129     uint256 private _reduceTaxCountdown;
130     address payable private _feeAddrWallet;
131 
132     string private constant _name = "A Hunters Desire";
133     string private constant _symbol = "Yajirushi";
134     uint8 private constant _decimals = 8;
135 
136     IUniswapV2Router02 private uniswapV2Router;
137     address private uniswapV2Pair;
138     bool private tradingOpen;
139     bool private inSwap = false;
140     bool private swapEnabled = false;
141     bool private cooldownEnabled = false;
142     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
143     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000);
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150 
151     constructor () {
152         _feeAddrWallet = payable(_msgSender());
153         _rOwned[_msgSender()] = _rTotal;
154         _isExcludedFromFee[owner()] = true;
155         _isExcludedFromFee[address(this)] = true;
156         _isExcludedFromFee[_feeAddrWallet] = true;
157         _initialTax=6;
158         _finalTax=0;
159         _reduceTaxCountdown=39;
160         _reduceTaxTarget = _reduceTaxCountdown.div(2);
161         emit Transfer(address(0), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return tokenFromReflection(_rOwned[account]);
182     }
183 
184     function transfer(address recipient, uint256 amount) public override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function setCooldownEnabled(bool onoff) external onlyOwner() {
205         cooldownEnabled = onoff;
206     }
207 
208     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
209         require(rAmount <= _rTotal, "Amount must be less than total reflections");
210         uint256 currentRate =  _getRate();
211         return rAmount.div(currentRate);
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225 
226 
227         if (from != owner() && to != owner()) {
228             require(!bots[from] && !bots[to]);
229             _feeAddr1 = 0;
230             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
232                 // Cooldown
233                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
236             }
237 
238 
239             uint256 contractTokenBalance = balanceOf(address(this));
240             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<_reduceTaxTarget) {
241                 swapTokensForEth(contractTokenBalance);
242                 uint256 contractETHBalance = address(this).balance;
243                 if(contractETHBalance > 0) {
244                     sendETHToFee(address(this).balance);
245                 }
246             }
247         }else{
248           _feeAddr1 = 0;
249           _feeAddr2 = 0;
250         }
251 
252         _tokenTransfer(from,to,amount);
253     }
254 
255     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
256         address[] memory path = new address[](2);
257         path[0] = address(this);
258         path[1] = uniswapV2Router.WETH();
259         _approve(address(this), address(uniswapV2Router), tokenAmount);
260         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
261             tokenAmount,
262             0,
263             path,
264             address(this),
265             block.timestamp
266         );
267     }
268 
269 
270     function removeLimits() external onlyOwner{
271         _maxTxAmount = _tTotal;
272         _maxWalletSize = _tTotal;
273     }
274 
275     function sendETHToFee(uint256 amount) private {
276         _feeAddrWallet.transfer(amount);
277     }
278 
279     function addBots(address[] memory bots_) public onlyOwner {
280         for (uint i = 0; i < bots_.length; i++) {
281             bots[bots_[i]] = true;
282         }
283     }
284 
285     function delBots(address[] memory notbot) public onlyOwner {
286       for (uint i = 0; i < notbot.length; i++) {
287           bots[notbot[i]] = false;
288       }
289 
290     }
291 
292     function openTrading() external onlyOwner() {
293         require(!tradingOpen,"trading is already open");
294         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
295         uniswapV2Router = _uniswapV2Router;
296         _approve(address(this), address(uniswapV2Router), _tTotal);
297         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
298         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
299         swapEnabled = true;
300         cooldownEnabled = true;
301 
302         tradingOpen = true;
303         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
304     }
305 
306     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
307         _transferStandard(sender, recipient, amount);
308     }
309 
310     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
311         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
312         _rOwned[sender] = _rOwned[sender].sub(rAmount);
313         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
314         _takeTeam(tTeam);
315         _reflectFee(rFee, tFee);
316         emit Transfer(sender, recipient, tTransferAmount);
317     }
318 
319     function _takeTeam(uint256 tTeam) private {
320         uint256 currentRate =  _getRate();
321         uint256 rTeam = tTeam.mul(currentRate);
322         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
323     }
324 
325     function _reflectFee(uint256 rFee, uint256 tFee) private {
326         _rTotal = _rTotal.sub(rFee);
327         _tFeeTotal = _tFeeTotal.add(tFee);
328     }
329 
330     receive() external payable {}
331 
332     function manualswap() external {
333         require(_msgSender() == _feeAddrWallet);
334         uint256 contractBalance = balanceOf(address(this));
335         swapTokensForEth(contractBalance);
336     }
337 
338     function manualsend() external {
339         require(_msgSender() == _feeAddrWallet);
340         uint256 contractETHBalance = address(this).balance;
341         sendETHToFee(contractETHBalance);
342     }
343 
344 
345     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
346         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
347         uint256 currentRate =  _getRate();
348         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
349         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
350     }
351 
352     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
353         uint256 tFee = tAmount.mul(taxFee).div(100);
354         uint256 tTeam = tAmount.mul(TeamFee).div(100);
355         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
356         return (tTransferAmount, tFee, tTeam);
357     }
358 
359     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
360         uint256 rAmount = tAmount.mul(currentRate);
361         uint256 rFee = tFee.mul(currentRate);
362         uint256 rTeam = tTeam.mul(currentRate);
363         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
364         return (rAmount, rTransferAmount, rFee);
365     }
366 
367 	function _getRate() private view returns(uint256) {
368         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
369         return rSupply.div(tSupply);
370     }
371 
372     function _getCurrentSupply() private view returns(uint256, uint256) {
373         uint256 rSupply = _rTotal;
374         uint256 tSupply = _tTotal;
375         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
376         return (rSupply, tSupply);
377     }
378 }