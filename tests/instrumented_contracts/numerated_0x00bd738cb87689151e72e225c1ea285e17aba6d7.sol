1 // SPDX-License-Identifier: UNLICENSED
2 /**
3 
4 Pepe Ape Yacht Club Coin $PAYCC
5 
6 https://t.me/PAYCC_PORTAL
7 https://twitter.com/PAYCC_ERC20
8 https://paycceth.com
9 
10 **/
11 
12 pragma solidity 0.8.20;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     address private _previousOwner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94 }
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 contract PAYCC is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _rOwned;
123     mapping (address => uint256) private _tOwned;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     mapping (address => uint) private cooldown;
128     uint256 private constant MAX = ~uint256(0);
129 
130     uint256 private _rTotal = (MAX - (MAX % _tTotal));
131     uint256 private _tFeeTotal;
132 
133     uint256 private _feeAddr1;
134     uint256 private _feeAddr2;
135     uint256 private _initialTax=20;
136     uint256 private _finalTax=1;
137     uint256 private _reduceTaxAt=1;
138     uint256 private _startLiquidateAt=40;
139     uint256 private _buyCount=0;
140     address payable private _feeAddrWallet;
141 
142     string private constant _name = unicode"Pepe Ape Yacht Club Coin";
143     string private constant _symbol = unicode"PAYCC";
144     uint8 private constant _decimals = 9;
145 
146     IUniswapV2Router02 private uniswapV2Router;
147     address private uniswapV2Pair;
148     bool private tradingOpen;
149     bool private inSwap = false;
150     bool private swapEnabled = false;
151     bool private cooldownEnabled = false;
152     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
153     uint256 private _maxTxAmount = 20000000 * 10**_decimals;
154     uint256 private _maxWalletSize = 20000000 * 10**_decimals;
155     uint256 private _swapThreshold=5000000*10**_decimals;
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162 
163     constructor () {
164         _feeAddrWallet = payable(_msgSender());
165         _rOwned[_msgSender()] = _rTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_feeAddrWallet] = true;
169 
170         emit Transfer(address(0), _msgSender(), _tTotal);
171     }
172 
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180 
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public pure override returns (uint256) {
186         return _tTotal;
187     }
188 
189     function balanceOf(address account) public view override returns (uint256) {
190         return tokenFromReflection(_rOwned[account]);
191     }
192 
193     function transfer(address recipient, uint256 amount) public override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender) public view override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(address spender, uint256 amount) public override returns (bool) {
203         _approve(_msgSender(), spender, amount);
204         return true;
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
210         return true;
211     }
212 
213     function setCooldownEnabled(bool onoff) external onlyOwner() {
214         cooldownEnabled = onoff;
215     }
216 
217     function addBots(address[] memory bots_) public onlyOwner {
218         for (uint i = 0; i < bots_.length; i++) {
219             bots[bots_[i]] = true;
220         }
221     }
222 
223     function delBots(address[] memory notbot) public onlyOwner {
224       for (uint i = 0; i < notbot.length; i++) {
225           bots[notbot[i]] = false;
226       }
227     }
228 
229     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
230         require(rAmount <= _rTotal, "Amount must be less than total reflections");
231         uint256 currentRate =  _getRate();
232         return rAmount.div(currentRate);
233     }
234 
235     function _approve(address owner, address spender, uint256 amount) private {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function _transfer(address from, address to, uint256 amount) private {
243         require(from != address(0), "ERC20: transfer from the zero address");
244         require(to != address(0), "ERC20: transfer to the zero address");
245         require(amount > 0, "Transfer amount must be greater than zero");
246 
247 
248         if (from != owner() && to != owner()) {
249             require(!bots[from] && !bots[to]);
250             _feeAddr1 = 1;
251             _feeAddr2 = (_buyCount>=_reduceTaxAt)?_finalTax:_initialTax;
252             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
253                 // Cooldown
254                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
255                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
256                 _buyCount++;
257             }
258 
259 
260             uint256 contractTokenBalance = balanceOf(address(this));
261             if (!inSwap &&  to  == uniswapV2Pair && swapEnabled && contractTokenBalance>=_swapThreshold && _buyCount>_startLiquidateAt) {
262                 swapTokensForEth(_swapThreshold>amount?amount:_swapThreshold);
263                 uint256 contractETHBalance = address(this).balance;
264                 if(contractETHBalance > 0) {
265                     sendETHToFee(address(this).balance);
266                 }
267             }
268         }else{
269           _feeAddr1 = 0;
270           _feeAddr2 = 0;
271         }
272 
273         _tokenTransfer(from,to,amount);
274     }
275 
276     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
277         address[] memory path = new address[](2);
278         path[0] = address(this);
279         path[1] = uniswapV2Router.WETH();
280         _approve(address(this), address(uniswapV2Router), tokenAmount);
281         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
282             tokenAmount,
283             0,
284             path,
285             address(this),
286             block.timestamp
287         );
288     }
289 
290 
291     function removeLimits() external onlyOwner{
292         _maxTxAmount = _tTotal;
293         _maxWalletSize = _tTotal;
294     }
295 
296     function sendETHToFee(uint256 amount) private {
297         _feeAddrWallet.transfer(amount);
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
309 
310         tradingOpen = true;
311         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
312     }
313 
314     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
315         _transferStandard(sender, recipient, amount);
316     }
317 
318     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
319         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
320         _rOwned[sender] = _rOwned[sender].sub(rAmount);
321         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
322         _takeTeam(tTeam);
323         _reflectFee(rFee, tFee);
324         emit Transfer(sender, recipient, tTransferAmount);
325     }
326 
327     function _takeTeam(uint256 tTeam) private {
328         uint256 currentRate =  _getRate();
329         uint256 rTeam = tTeam.mul(currentRate);
330         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
331     }
332 
333     function _reflectFee(uint256 rFee, uint256 tFee) private {
334         _rTotal = _rTotal.sub(rFee);
335         _tFeeTotal = _tFeeTotal.add(tFee);
336     }
337 
338     receive() external payable {}
339 
340     function manualSwap() external {
341         require(_msgSender()==_feeAddrWallet);
342         uint256 tokenBalance=balanceOf(address(this));
343         if(tokenBalance>0){
344           swapTokensForEth(tokenBalance);
345         }
346         uint256 ethBalance=address(this).balance;
347         if(ethBalance>0){
348           sendETHToFee(ethBalance);
349         }
350     }
351 
352     function isBot(address a) public view returns (bool){
353       return bots[a];
354     }
355 
356 
357     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
358         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
359         uint256 currentRate =  _getRate();
360         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
361         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
362     }
363 
364     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
365         uint256 tFee = tAmount.mul(taxFee).div(100);
366         uint256 tTeam = tAmount.mul(TeamFee).div(100);
367         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
368         return (tTransferAmount, tFee, tTeam);
369     }
370 
371     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
372         uint256 rAmount = tAmount.mul(currentRate);
373         uint256 rFee = tFee.mul(currentRate);
374         uint256 rTeam = tTeam.mul(currentRate);
375         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
376         return (rAmount, rTransferAmount, rFee);
377     }
378 
379 	function _getRate() private view returns(uint256) {
380         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
381         return rSupply.div(tSupply);
382     }
383 
384     function _getCurrentSupply() private view returns(uint256, uint256) {
385         uint256 rSupply = _rTotal;
386         uint256 tSupply = _tTotal;
387         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
388         return (rSupply, tSupply);
389     }
390 }