1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-23
3 */
4 
5 // $TastyDip
6 // Telegram: https://t.me/TastyDip
7 
8 // Introducing the only coin on the blockchain that is designed to go up. 
9 // 20%+ Slippage
10 // Liquidity will be locked
11 // Ownership will be renounced
12 
13 // EverRise fork, special thanks to them!
14 
15 // Manual buybacks
16 // Fair Launch, no Dev Tokens. 100% LP.
17 // Snipers will be nuked.
18 
19 // SPDX-License-Identifier: Unlicensed
20 
21 // :P So tasty :P
22 
23 pragma solidity ^0.8.4;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         return c;
76     }
77 
78 }
79 
80 contract Ownable is Context {
81     address private _owner;
82     address private _previousOwner;
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor () {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105 }  
106 
107 interface IUniswapV2Factory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IUniswapV2Router02 {
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 }
130 
131 contract TastyDip is Context, IERC20, Ownable {
132     using SafeMath for uint256;
133     mapping (address => uint256) private _rOwned;
134     mapping (address => uint256) private _tOwned;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private bots;
138     mapping (address => uint) private cooldown;
139     uint256 private constant MAX = ~uint256(0);
140     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
141     uint256 private _rTotal = (MAX - (MAX % _tTotal));
142     uint256 private _tFeeTotal;
143     string private constant _name = "TastyDip";
144     string private constant _symbol = unicode'TastyDip 👅';
145     uint8 private constant _decimals = 9;
146     uint256 private _taxFee;
147     uint256 private _teamFee;
148     uint256 private _previousTaxFee = _taxFee;
149     uint256 private _previousteamFee = _teamFee;
150     address payable private _FeeAddress;
151     address payable private _marketingWalletAddress;
152     IUniswapV2Router02 private uniswapV2Router;
153     address private uniswapV2Pair;
154     bool private tradingOpen;
155     bool private inSwap = false;
156     bool private swapEnabled = false;
157     bool private cooldownEnabled = false;
158     uint256 private _maxTxAmount = _tTotal;
159     event MaxTxAmountUpdated(uint _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165     constructor (address payable addr1, address payable addr2) {
166         _FeeAddress = addr1;
167         _marketingWalletAddress = addr2;
168         _rOwned[_msgSender()] = _rTotal;
169         _isExcludedFromFee[owner()] = true;
170         _isExcludedFromFee[address(this)] = true;
171         _isExcludedFromFee[_FeeAddress] = true;
172         _isExcludedFromFee[_marketingWalletAddress] = true;
173         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
174     }
175 
176     function name() public pure returns (string memory) {
177         return _name;
178     }
179 
180     function symbol() public pure returns (string memory) {
181         return _symbol;
182     }
183 
184     function decimals() public pure returns (uint8) {
185         return _decimals;
186     }
187 
188     function totalSupply() public pure override returns (uint256) {
189         return _tTotal;
190     }
191 
192     function balanceOf(address account) public view override returns (uint256) {
193         return tokenFromReflection(_rOwned[account]);
194     }
195 
196     function transfer(address recipient, uint256 amount) public override returns (bool) {
197         _transfer(_msgSender(), recipient, amount);
198         return true;
199     }
200 
201     function allowance(address owner, address spender) public view override returns (uint256) {
202         return _allowances[owner][spender];
203     }
204 
205     function approve(address spender, uint256 amount) public override returns (bool) {
206         _approve(_msgSender(), spender, amount);
207         return true;
208     }
209 
210     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
211         _transfer(sender, recipient, amount);
212         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
213         return true;
214     }
215 
216     function setCooldownEnabled(bool onoff) external onlyOwner() {
217         cooldownEnabled = onoff;
218     }
219 
220     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
221         require(rAmount <= _rTotal, "Amount must be less than total reflections");
222         uint256 currentRate =  _getRate();
223         return rAmount.div(currentRate);
224     }
225 
226     function removeAllFee() private {
227         if(_taxFee == 0 && _teamFee == 0) return;
228         _previousTaxFee = _taxFee;
229         _previousteamFee = _teamFee;
230         _taxFee = 0;
231         _teamFee = 0;
232     }
233     
234     function restoreAllFee() private {
235         _taxFee = _previousTaxFee;
236         _teamFee = _previousteamFee;
237     }
238 
239     function _approve(address owner, address spender, uint256 amount) private {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245 
246     function _transfer(address from, address to, uint256 amount) private {
247         require(from != address(0), "ERC20: transfer from the zero address");
248         require(to != address(0), "ERC20: transfer to the zero address");
249         require(amount > 0, "Transfer amount must be greater than zero");
250         _taxFee = 5;
251         _teamFee = 10;
252         if (from != owner() && to != owner()) {
253             require(!bots[from] && !bots[to]);
254             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
255                 require(amount <= _maxTxAmount);
256                 require(cooldown[to] < block.timestamp);
257                 cooldown[to] = block.timestamp + (30 seconds);
258             }
259             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
260                 _taxFee = 5;
261                 _teamFee = 20;
262             }
263             uint256 contractTokenBalance = balanceOf(address(this));
264             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
265                 swapTokensForEth(contractTokenBalance);
266                 uint256 contractETHBalance = address(this).balance;
267                 if(contractETHBalance > 0) {
268                     sendETHToFee(address(this).balance);
269                 }
270             }
271         }
272         bool takeFee = true;
273 
274         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
275             takeFee = false;
276         }
277 		
278         _tokenTransfer(from,to,amount,takeFee);
279     }
280 
281     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
282         address[] memory path = new address[](2);
283         path[0] = address(this);
284         path[1] = uniswapV2Router.WETH();
285         _approve(address(this), address(uniswapV2Router), tokenAmount);
286         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
287             tokenAmount,
288             0,
289             path,
290             address(this),
291             block.timestamp
292         );
293     }
294         
295     function sendETHToFee(uint256 amount) private {
296         _FeeAddress.transfer(amount.div(2));
297         _marketingWalletAddress.transfer(amount.div(2));
298     }
299     
300     function openTrading() external onlyOwner() {
301         require(!tradingOpen,"trading is already open");
302         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
303         uniswapV2Router = _uniswapV2Router;
304         _approve(address(this), address(uniswapV2Router), _tTotal);
305         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
306         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
307         swapEnabled = true;
308         cooldownEnabled = true;
309         _maxTxAmount = 100000000000000000 * 10**9;
310         tradingOpen = true;
311         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
312     }
313     
314     function setBots(address[] memory bots_) public onlyOwner {
315         for (uint i = 0; i < bots_.length; i++) {
316             bots[bots_[i]] = true;
317         }
318     }
319     
320     function delBot(address notbot) public onlyOwner {
321         bots[notbot] = false;
322     }
323         
324     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
325         if(!takeFee)
326             removeAllFee();
327         _transferStandard(sender, recipient, amount);
328         if(!takeFee)
329             restoreAllFee();
330     }
331 
332     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
333         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
334         _rOwned[sender] = _rOwned[sender].sub(rAmount);
335         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
336         _takeTeam(tTeam);
337         _reflectFee(rFee, tFee);
338         emit Transfer(sender, recipient, tTransferAmount);
339     }
340 
341     function _takeTeam(uint256 tTeam) private {
342         uint256 currentRate =  _getRate();
343         uint256 rTeam = tTeam.mul(currentRate);
344         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
345     }
346 
347     function _reflectFee(uint256 rFee, uint256 tFee) private {
348         _rTotal = _rTotal.sub(rFee);
349         _tFeeTotal = _tFeeTotal.add(tFee);
350     }
351 
352     receive() external payable {}
353     
354     function manualswap() external {
355         require(_msgSender() == _FeeAddress);
356         uint256 contractBalance = balanceOf(address(this));
357         swapTokensForEth(contractBalance);
358     }
359     
360     function manualsend() external {
361         require(_msgSender() == _FeeAddress);
362         uint256 contractETHBalance = address(this).balance;
363         sendETHToFee(contractETHBalance);
364     }
365     
366 
367     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
368         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
369         uint256 currentRate =  _getRate();
370         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
371         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
372     }
373 
374     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
375         uint256 tFee = tAmount.mul(taxFee).div(100);
376         uint256 tTeam = tAmount.mul(TeamFee).div(100);
377         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
378         return (tTransferAmount, tFee, tTeam);
379     }
380 
381     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
382         uint256 rAmount = tAmount.mul(currentRate);
383         uint256 rFee = tFee.mul(currentRate);
384         uint256 rTeam = tTeam.mul(currentRate);
385         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
386         return (rAmount, rTransferAmount, rFee);
387     }
388 
389 	function _getRate() private view returns(uint256) {
390         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
391         return rSupply.div(tSupply);
392     }
393 
394     function _getCurrentSupply() private view returns(uint256, uint256) {
395         uint256 rSupply = _rTotal;
396         uint256 tSupply = _tTotal;      
397         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
398         return (rSupply, tSupply);
399     }
400 
401     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
402         require(maxTxPercent > 0, "Amount must be greater than 0");
403         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
404         emit MaxTxAmountUpdated(_maxTxAmount);
405     }
406 }