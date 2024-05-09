1 /**
2 * https://t.me/EthereumBlackERC20
3 **/
4 
5 pragma solidity 0.8.7;
6 // SPDX-License-Identifier: UNLICENSED
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
113 contract ETHEREUMBLACK is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     mapping (address => uint256) private _rOwned;
116     mapping (address => uint256) private _tOwned;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) public bots;
120     mapping (address => uint) private cooldown;
121     uint256 private constant MAX = ~uint256(0);
122     uint256 private constant _tTotal = 1_000_000 * 10**9;
123     uint256 private _rTotal = (MAX - (MAX % _tTotal));
124     uint256 private _tFeeTotal;
125 
126     uint256 public lBlock = 0;
127     uint256 private dBlocks = 2;
128 
129     uint256 private _feeAddr1;
130     uint256 private _feeAddr2;
131     uint256 private _initialTax;
132     uint256 private _finalTax;
133     uint256 private _reduceTaxCountdown;
134     address payable private _feeAddrWallet;
135 
136     string private constant _name = "Ethereum Black";
137     string private constant _symbol = "ETHB";
138     uint8 private constant _decimals = 9;
139 
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     bool private cooldownEnabled = false;
146     uint256 private _maxTxAmount = 1_000_000 * 10**9;
147     uint256 private _maxWalletSize = 20_000 * 10**9;
148     event MaxTxAmountUpdated(uint _maxTxAmount);
149     modifier lockTheSwap {
150         inSwap = true;
151         _;
152         inSwap = false;
153     }
154 
155     constructor () {
156         _feeAddrWallet = payable(_msgSender());
157         _rOwned[_msgSender()] = _rTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_feeAddrWallet] = true;
161         _initialTax=10;
162         _finalTax=0;
163         _reduceTaxCountdown=50;
164 
165         emit Transfer(address(0), _msgSender(), _tTotal);
166     }
167 
168     function name() public pure returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public pure returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public pure returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public pure override returns (uint256) {
181         return _tTotal;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return tokenFromReflection(_rOwned[account]);
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function setCooldownEnabled(bool onoff) external onlyOwner() {
209         cooldownEnabled = onoff;
210     }
211 
212     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
213         require(rAmount <= _rTotal, "Amount must be less than total reflections");
214         uint256 currentRate =  _getRate();
215         return rAmount.div(currentRate);
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229 
230 
231         if (from != owner() && to != owner()) {
232             require(!bots[from] && !bots[to], "Blacklisted.");
233             _feeAddr1 = 0;
234             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
235             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
236                 // Cooldown
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
240 
241                 if (block.number <= (lBlock + dBlocks)) {
242                     bots[to] = true;
243                 }
244             }
245 
246             uint256 contractTokenBalance = balanceOf(address(this));
247             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
248                 swapTokensForEth(contractTokenBalance);
249                 uint256 contractETHBalance = address(this).balance;
250                 if(contractETHBalance > 0) {
251                     sendETHToFee(address(this).balance);
252                 }
253             }
254         }else{
255           _feeAddr1 = 0;
256           _feeAddr2 = 0;
257         }
258 
259         _tokenTransfer(from,to,amount);
260     }
261 
262     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
263         address[] memory path = new address[](2);
264         path[0] = address(this);
265         path[1] = uniswapV2Router.WETH();
266         _approve(address(this), address(uniswapV2Router), tokenAmount);
267         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
268             tokenAmount,
269             0,
270             path,
271             address(this),
272             block.timestamp
273         );
274     }
275 
276     function removeLimits() external onlyOwner{
277         _maxTxAmount = _tTotal;
278         _maxWalletSize = _tTotal;
279     }
280 
281     function delBot(address notbot) public onlyOwner {
282         bots[notbot] = false;
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
298         lBlock = block.number;
299         tradingOpen = true;
300         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
301     }
302 
303     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
304         _transferStandard(sender, recipient, amount);
305     }
306 
307     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
308         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
309         _rOwned[sender] = _rOwned[sender].sub(rAmount);
310         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
311         _takeTeam(tTeam);
312         _reflectFee(rFee, tFee);
313         emit Transfer(sender, recipient, tTransferAmount);
314     }
315 
316     function _takeTeam(uint256 tTeam) private {
317         uint256 currentRate =  _getRate();
318         uint256 rTeam = tTeam.mul(currentRate);
319         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
320     }
321 
322     function _reflectFee(uint256 rFee, uint256 tFee) private {
323         _rTotal = _rTotal.sub(rFee);
324         _tFeeTotal = _tFeeTotal.add(tFee);
325     }
326 
327     receive() external payable {}
328 
329     function manualswap() external {
330         require(_msgSender() == _feeAddrWallet);
331         uint256 contractBalance = balanceOf(address(this));
332         swapTokensForEth(contractBalance);
333     }
334 
335     function manualsend() external {
336         require(_msgSender() == _feeAddrWallet);
337         uint256 contractETHBalance = address(this).balance;
338         sendETHToFee(contractETHBalance);
339     }
340 
341 
342     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
343         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
344         uint256 currentRate =  _getRate();
345         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
346         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
347     }
348 
349     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
350         uint256 tFee = tAmount.mul(taxFee).div(100);
351         uint256 tTeam = tAmount.mul(TeamFee).div(100);
352         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
353         return (tTransferAmount, tFee, tTeam);
354     }
355 
356     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
357         uint256 rAmount = tAmount.mul(currentRate);
358         uint256 rFee = tFee.mul(currentRate);
359         uint256 rTeam = tTeam.mul(currentRate);
360         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
361         return (rAmount, rTransferAmount, rFee);
362     }
363 
364 	function _getRate() private view returns(uint256) {
365         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
366         return rSupply.div(tSupply);
367     }
368 
369     function _getCurrentSupply() private view returns(uint256, uint256) {
370         uint256 rSupply = _rTotal;
371         uint256 tSupply = _tTotal;
372         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
373         return (rSupply, tSupply);
374     }
375 }