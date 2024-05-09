1 /*
2 Roketto - The Senders Wish
3 Make a wish and hold tight, Roketto will bring senders to the infinity and beyond!
4 
5 Tax@0/0
6 No Community
7 No Website
8 No Twitter
9 
10 Everything on: https://medium.com/@rokettoerc
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity 0.8.16;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         return c;
68     }
69 
70 }
71 
72 contract Ownable is Context {
73     address private _owner;
74     address private _previousOwner;
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     constructor () {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(_owner == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97 }
98 
99 interface IUniswapV2Factory {
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101 }
102 
103 interface IUniswapV2Router02 {
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113     function addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121 }
122 
123 contract Senders is Context, IERC20, Ownable { 
124     using SafeMath for uint256;
125     mapping (address => uint256) private _rOwned;
126     mapping (address => uint256) private _tOwned;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping (address => uint) private cooldown;
131     uint256 private constant MAX = ~uint256(0);
132     uint256 private constant _tTotal = 1000000000 * 10**8;
133     uint256 private _rTotal = (MAX - (MAX % _tTotal));
134     uint256 private _tFeeTotal;
135 
136     uint256 private _feeAddr1;
137     uint256 private _feeAddr2;
138     uint256 private _initialTax;
139     uint256 private _finalTax;
140     uint256 private _reduceTaxTarget;
141     uint256 private _reduceTaxCountdown;
142     address payable private _feeAddrWallet;
143 
144     string private constant _name = "The Senders Wish";
145     string private constant _symbol = "Roketto";
146     uint8 private constant _decimals = 8;
147 
148     IUniswapV2Router02 private uniswapV2Router;
149     address private uniswapV2Pair;
150     bool private tradingOpen;
151     bool private inSwap = false;
152     bool private swapEnabled = false;
153     bool private cooldownEnabled = false;
154     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
155     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000);
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
169         _initialTax=6;
170         _finalTax=0;
171         _reduceTaxCountdown=49;
172         _reduceTaxTarget = _reduceTaxCountdown.div(2);
173         emit Transfer(address(0), _msgSender(), _tTotal);
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
226     function _approve(address owner, address spender, uint256 amount) private {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function _transfer(address from, address to, uint256 amount) private {
234         require(from != address(0), "ERC20: transfer from the zero address");
235         require(to != address(0), "ERC20: transfer to the zero address");
236         require(amount > 0, "Transfer amount must be greater than zero");
237 
238 
239         if (from != owner() && to != owner()) {
240             require(!bots[from] && !bots[to]);
241             _feeAddr1 = 0;
242             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
244                 // Cooldown
245                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
246                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
247                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
248             }
249 
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<_reduceTaxTarget) {
253                 swapTokensForEth(contractTokenBalance);
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }else{
260           _feeAddr1 = 0;
261           _feeAddr2 = 0;
262         }
263 
264         _tokenTransfer(from,to,amount);
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         address[] memory path = new address[](2);
269         path[0] = address(this);
270         path[1] = uniswapV2Router.WETH();
271         _approve(address(this), address(uniswapV2Router), tokenAmount);
272         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             tokenAmount,
274             0,
275             path,
276             address(this),
277             block.timestamp
278         );
279     }
280 
281 
282     function removeLimits() external onlyOwner{
283         _maxTxAmount = _tTotal;
284         _maxWalletSize = _tTotal;
285     }
286 
287     function sendETHToFee(uint256 amount) private {
288         _feeAddrWallet.transfer(amount);
289     }
290 
291     function addBots(address[] memory bots_) public onlyOwner {
292         for (uint i = 0; i < bots_.length; i++) {
293             bots[bots_[i]] = true;
294         }
295     }
296 
297     function delBots(address[] memory notbot) public onlyOwner {
298       for (uint i = 0; i < notbot.length; i++) {
299           bots[notbot[i]] = false;
300       }
301 
302     }
303 
304     function openTrading() external onlyOwner() {
305         require(!tradingOpen,"trading is already open");
306         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
307         uniswapV2Router = _uniswapV2Router;
308         _approve(address(this), address(uniswapV2Router), _tTotal);
309         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
310         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
311         swapEnabled = true;
312         cooldownEnabled = true;
313 
314         tradingOpen = true;
315         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
316     }
317 
318     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
319         _transferStandard(sender, recipient, amount);
320     }
321 
322     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
323         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
324         _rOwned[sender] = _rOwned[sender].sub(rAmount);
325         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
326         _takeTeam(tTeam);
327         _reflectFee(rFee, tFee);
328         emit Transfer(sender, recipient, tTransferAmount);
329     }
330 
331     function _takeTeam(uint256 tTeam) private {
332         uint256 currentRate =  _getRate();
333         uint256 rTeam = tTeam.mul(currentRate);
334         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
335     }
336 
337     function _reflectFee(uint256 rFee, uint256 tFee) private {
338         _rTotal = _rTotal.sub(rFee);
339         _tFeeTotal = _tFeeTotal.add(tFee);
340     }
341 
342     receive() external payable {}
343 
344     function manualswap() external {
345         require(_msgSender() == _feeAddrWallet);
346         uint256 contractBalance = balanceOf(address(this));
347         swapTokensForEth(contractBalance);
348     }
349 
350     function manualsend() external {
351         require(_msgSender() == _feeAddrWallet);
352         uint256 contractETHBalance = address(this).balance;
353         sendETHToFee(contractETHBalance);
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