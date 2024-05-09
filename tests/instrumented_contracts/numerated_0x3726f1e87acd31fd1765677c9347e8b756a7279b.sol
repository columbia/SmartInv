1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-14
3 */
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
113 contract NBAINU is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     mapping (address => uint256) private _rOwned;
116     mapping (address => uint256) private _tOwned;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping (address => uint) private cooldown;
121     uint256 private constant MAX = ~uint256(0);
122     uint256 private constant _tTotal = 1_000_000 * 10**9;
123     uint256 private _rTotal = (MAX - (MAX % _tTotal));
124     uint256 private _tFeeTotal;
125 
126     uint256 private _feeAddr1;
127     uint256 private _feeAddr2;
128     uint256 private _initialTax;
129     uint256 private _finalTax;
130     uint256 private _reduceTaxCountdown;
131     address payable private _feeAddrWallet;
132 
133     string private constant _name = "NBA INU";
134     string private constant _symbol = "NBA";
135     uint8 private constant _decimals = 9;
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142     bool private cooldownEnabled = false;
143     uint256 private _maxTxAmount = 1_000_000 * 10**9;
144     uint256 private _maxWalletSize = 20_000 * 10**9;
145     event MaxTxAmountUpdated(uint _maxTxAmount);
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151 
152     constructor () {
153         _feeAddrWallet = payable(0x5ea59E17829C3698DC88bF2A4b1B7D3AAB7a4801);
154         _rOwned[_msgSender()] = _rTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[_feeAddrWallet] = true;
158         _initialTax=5;
159         _finalTax=5;
160         _reduceTaxCountdown=60;
161 
162         emit Transfer(address(0), _msgSender(), _tTotal);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return tokenFromReflection(_rOwned[account]);
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204 
205     function setCooldownEnabled(bool onoff) external onlyOwner() {
206         cooldownEnabled = onoff;
207     }
208 
209     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
210         require(rAmount <= _rTotal, "Amount must be less than total reflections");
211         uint256 currentRate =  _getRate();
212         return rAmount.div(currentRate);
213     }
214 
215     function _approve(address owner, address spender, uint256 amount) private {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _transfer(address from, address to, uint256 amount) private {
223         require(from != address(0), "ERC20: transfer from the zero address");
224         require(to != address(0), "ERC20: transfer to the zero address");
225         require(amount > 0, "Transfer amount must be greater than zero");
226 
227 
228         if (from != owner() && to != owner()) {
229             require(!bots[from] && !bots[to]);
230             _feeAddr1 = 0;
231             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
232             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
233                 // Cooldown
234                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
235                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
236                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
237             }
238 
239 
240             uint256 contractTokenBalance = balanceOf(address(this));
241             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
242                 swapTokensForEth(contractTokenBalance);
243                 uint256 contractETHBalance = address(this).balance;
244                 if(contractETHBalance > 0) {
245                     sendETHToFee(address(this).balance);
246                 }
247             }
248         }else{
249           _feeAddr1 = 0;
250           _feeAddr2 = 0;
251         }
252 
253         _tokenTransfer(from,to,amount);
254     }
255 
256     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
257         address[] memory path = new address[](2);
258         path[0] = address(this);
259         path[1] = uniswapV2Router.WETH();
260         _approve(address(this), address(uniswapV2Router), tokenAmount);
261         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
262             tokenAmount,
263             0,
264             path,
265             address(this),
266             block.timestamp
267         );
268     }
269 
270     function addBots(address[] memory bots_) public onlyOwner {
271         for (uint i = 0; i < bots_.length; i++) {
272             bots[bots_[i]] = true;
273         }
274     }
275 
276     function delBot(address notbot) public onlyOwner {
277         bots[notbot] = false;
278     }
279 
280 
281     function removeLimits() external onlyOwner{
282         _maxTxAmount = _tTotal;
283         _maxWalletSize = _tTotal;
284     }
285 
286     function sendETHToFee(uint256 amount) private {
287         _feeAddrWallet.transfer(amount);
288     }
289 
290     function openTrading() external onlyOwner() {
291         require(!tradingOpen,"trading is already open");
292         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
293         uniswapV2Router = _uniswapV2Router;
294         _approve(address(this), address(uniswapV2Router), _tTotal);
295         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
296         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
297         swapEnabled = true;
298         cooldownEnabled = true;
299 
300         tradingOpen = true;
301         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
302     }
303 
304     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
305         _transferStandard(sender, recipient, amount);
306     }
307 
308     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
309         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
310         _rOwned[sender] = _rOwned[sender].sub(rAmount);
311         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
312         _takeTeam(tTeam);
313         _reflectFee(rFee, tFee);
314         emit Transfer(sender, recipient, tTransferAmount);
315     }
316 
317     function _takeTeam(uint256 tTeam) private {
318         uint256 currentRate =  _getRate();
319         uint256 rTeam = tTeam.mul(currentRate);
320         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
321     }
322 
323     function _reflectFee(uint256 rFee, uint256 tFee) private {
324         _rTotal = _rTotal.sub(rFee);
325         _tFeeTotal = _tFeeTotal.add(tFee);
326     }
327 
328     receive() external payable {}
329 
330     function manualswap() external {
331         require(_msgSender() == _feeAddrWallet);
332         uint256 contractBalance = balanceOf(address(this));
333         swapTokensForEth(contractBalance);
334     }
335 
336     function manualsend() external {
337         require(_msgSender() == _feeAddrWallet);
338         uint256 contractETHBalance = address(this).balance;
339         sendETHToFee(contractETHBalance);
340     }
341 
342 
343     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
344         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
345         uint256 currentRate =  _getRate();
346         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
347         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
348     }
349 
350     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
351         uint256 tFee = tAmount.mul(taxFee).div(100);
352         uint256 tTeam = tAmount.mul(TeamFee).div(100);
353         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
354         return (tTransferAmount, tFee, tTeam);
355     }
356 
357     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
358         uint256 rAmount = tAmount.mul(currentRate);
359         uint256 rFee = tFee.mul(currentRate);
360         uint256 rTeam = tTeam.mul(currentRate);
361         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
362         return (rAmount, rTransferAmount, rFee);
363     }
364 
365 	function _getRate() private view returns(uint256) {
366         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
367         return rSupply.div(tSupply);
368     }
369 
370     function _getCurrentSupply() private view returns(uint256, uint256) {
371         uint256 rSupply = _rTotal;
372         uint256 tSupply = _tTotal;
373         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
374         return (rSupply, tSupply);
375     }
376 }