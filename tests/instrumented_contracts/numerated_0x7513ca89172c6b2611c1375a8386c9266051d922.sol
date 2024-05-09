1 // SPDX-License-Identifier: MIT
2 
3 // Crtl-C (COPY)
4 
5 pragma solidity 0.8.16;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         return c;
58     }
59 
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     address private _previousOwner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87 }
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 }
112 
113 contract CtrlC is Context, IERC20, Ownable {  
114     using SafeMath for uint256;
115     mapping (address => uint256) private _rOwned;
116     mapping (address => uint256) private _tOwned;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping (address => uint) private cooldown;
121     uint256 private constant MAX = ~uint256(0);
122     uint256 private constant _tTotal = 1000000000 * 10**8;
123     uint256 private _rTotal = (MAX - (MAX % _tTotal));
124     uint256 private _tFeeTotal;
125 
126     uint256 private _feeAddr1;
127     uint256 private _feeAddr2;
128     uint256 private _initialTax;
129     uint256 private _finalTax;
130     uint256 private _reduceTaxTarget;
131     uint256 private _reduceTaxCountdown;
132     address payable private _feeAddrWallet;
133 
134     string private constant _name = "Ctrl-C";
135     string private constant _symbol = "COPY";
136     uint8 private constant _decimals = 8;
137 
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143     bool private cooldownEnabled = false;
144     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
145     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000);
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor () {
154         _feeAddrWallet = payable(_msgSender());
155         _rOwned[_msgSender()] = _rTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_feeAddrWallet] = true;
159         _initialTax=5;
160         _finalTax=0;
161         _reduceTaxCountdown=40;
162         _reduceTaxTarget = _reduceTaxCountdown.div(2);
163         emit Transfer(address(0), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return tokenFromReflection(_rOwned[account]);
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function setCooldownEnabled(bool onoff) external onlyOwner() {
207         cooldownEnabled = onoff;
208     }
209 
210     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
211         require(rAmount <= _rTotal, "Amount must be less than total reflections");
212         uint256 currentRate =  _getRate();
213         return rAmount.div(currentRate);
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227 
228 
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231             _feeAddr1 = 0;
232             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
234                 // Cooldown
235                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
236                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
237                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
238             }
239 
240 
241             uint256 contractTokenBalance = balanceOf(address(this));
242             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<_reduceTaxTarget) {
243                 swapTokensForEth(contractTokenBalance);
244                 uint256 contractETHBalance = address(this).balance;
245                 if(contractETHBalance > 0) {
246                     sendETHToFee(address(this).balance);
247                 }
248             }
249         }else{
250           _feeAddr1 = 0;
251           _feeAddr2 = 0;
252         }
253 
254         _tokenTransfer(from,to,amount);
255     }
256 
257     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
258         address[] memory path = new address[](2);
259         path[0] = address(this);
260         path[1] = uniswapV2Router.WETH();
261         _approve(address(this), address(uniswapV2Router), tokenAmount);
262         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
263             tokenAmount,
264             0,
265             path,
266             address(this),
267             block.timestamp
268         );
269     }
270 
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
281     function addBots(address[] memory bots_) public onlyOwner {
282         for (uint i = 0; i < bots_.length; i++) {
283             bots[bots_[i]] = true;
284         }
285     }
286 
287     function delBots(address[] memory notbot) public onlyOwner {
288       for (uint i = 0; i < notbot.length; i++) {
289           bots[notbot[i]] = false;
290       }
291 
292     }
293 
294     function openTrading() external onlyOwner() {
295         require(!tradingOpen,"trading is already open");
296         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
297         uniswapV2Router = _uniswapV2Router;
298         _approve(address(this), address(uniswapV2Router), _tTotal);
299         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
300         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
301         swapEnabled = true;
302         cooldownEnabled = true;
303 
304         tradingOpen = true;
305         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
306     }
307 
308     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
309         _transferStandard(sender, recipient, amount);
310     }
311 
312     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
313         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
314         _rOwned[sender] = _rOwned[sender].sub(rAmount);
315         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
316         _takeTeam(tTeam);
317         _reflectFee(rFee, tFee);
318         emit Transfer(sender, recipient, tTransferAmount);
319     }
320 
321     function _takeTeam(uint256 tTeam) private {
322         uint256 currentRate =  _getRate();
323         uint256 rTeam = tTeam.mul(currentRate);
324         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
325     }
326 
327     function _reflectFee(uint256 rFee, uint256 tFee) private {
328         _rTotal = _rTotal.sub(rFee);
329         _tFeeTotal = _tFeeTotal.add(tFee);
330     }
331 
332     receive() external payable {}
333 
334     function manualswap() external {
335         require(_msgSender() == _feeAddrWallet);
336         uint256 contractBalance = balanceOf(address(this));
337         swapTokensForEth(contractBalance);
338     }
339 
340     function manualsend() external {
341         require(_msgSender() == _feeAddrWallet);
342         uint256 contractETHBalance = address(this).balance;
343         sendETHToFee(contractETHBalance);
344     }
345 
346 
347     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
348         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
349         uint256 currentRate =  _getRate();
350         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
351         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
352     }
353 
354     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
355         uint256 tFee = tAmount.mul(taxFee).div(100);
356         uint256 tTeam = tAmount.mul(TeamFee).div(100);
357         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
358         return (tTransferAmount, tFee, tTeam);
359     }
360 
361     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
362         uint256 rAmount = tAmount.mul(currentRate);
363         uint256 rFee = tFee.mul(currentRate);
364         uint256 rTeam = tTeam.mul(currentRate);
365         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
366         return (rAmount, rTransferAmount, rFee);
367     }
368 
369 	function _getRate() private view returns(uint256) {
370         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
371         return rSupply.div(tSupply);
372     }
373 
374     function _getCurrentSupply() private view returns(uint256, uint256) {
375         uint256 rSupply = _rTotal;
376         uint256 tSupply = _tTotal;
377         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
378         return (rSupply, tSupply);
379     }
380 }