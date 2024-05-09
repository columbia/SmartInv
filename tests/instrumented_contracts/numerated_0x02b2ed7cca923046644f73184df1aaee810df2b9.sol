1 /*
2 
3 World of Otterhound Fighters $WOOF
4 
5 UFC became the sports arm of DONALD TRUMP.  
6 With his comeback on Twitter soon, $WOOF will be his only best friend supporting fighters. 
7 
8 With the new reign of the otterhound dog breed. We aim to become the next Doge and Shiba rivalry by delivering a Block Chain Project and Charity.
9 
10 Would you love to support our mission too?
11 
12 Telegram: https://t.me/WOOFPORTAL
13 Twitter: https://twitter.com/WOOFERC20
14 Website: https://otterhoundwoof.com/
15 
16 */
17 
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity 0.8.16;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     address private _previousOwner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118     function addLiquidityETH(
119         address token,
120         uint amountTokenDesired,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126 }
127 
128 contract WOOF is Context, IERC20, Ownable { 
129     using SafeMath for uint256;
130     mapping (address => uint256) private _rOwned;
131     mapping (address => uint256) private _tOwned;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) private _isExcludedFromFee;
134     mapping (address => bool) private bots;
135     mapping (address => uint) private cooldown;
136     uint256 private constant MAX = ~uint256(0);
137     uint256 private constant _tTotal = 1000000 * 10**8;
138     uint256 private _rTotal = (MAX - (MAX % _tTotal));
139     uint256 private _tFeeTotal;
140 
141     uint256 private _feeAddr1;
142     uint256 private _feeAddr2;
143     uint256 private _initialTax;
144     uint256 private _finalTax;
145     uint256 private _reduceTaxTarget;
146     uint256 private _reduceTaxCountdown;
147     address payable private _feeAddrWallet;
148 
149     string private constant _name = "World of Otterhound Fighters";
150     string private constant _symbol = "WOOF";
151     uint8 private constant _decimals = 8;
152 
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158     bool private cooldownEnabled = false;
159     uint256 public _maxTxAmount = _tTotal.mul(2).div(100); 
160     uint256 public _maxWalletSize = _tTotal.mul(2).div(100);
161     event MaxTxAmountUpdated(uint _maxTxAmount);
162     modifier lockTheSwap {
163         inSwap = true;
164         _;
165         inSwap = false;
166     }
167 
168     constructor () {
169         _feeAddrWallet = payable(_msgSender());
170         _rOwned[_msgSender()] = _rTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_feeAddrWallet] = true;
174         _initialTax=7;
175         _finalTax=5;
176         _reduceTaxCountdown=60;
177         _reduceTaxTarget = _reduceTaxCountdown.div(2);
178         emit Transfer(address(0), _msgSender(), _tTotal);
179     }
180 
181     function name() public pure returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public pure returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public pure returns (uint8) {
190         return _decimals;
191     }
192 
193     function totalSupply() public pure override returns (uint256) {
194         return _tTotal;
195     }
196 
197     function balanceOf(address account) public view override returns (uint256) {
198         return tokenFromReflection(_rOwned[account]);
199     }
200 
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public override returns (bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220 
221     function setCooldownEnabled(bool onoff) external onlyOwner() {
222         cooldownEnabled = onoff;
223     }
224 
225     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
226         require(rAmount <= _rTotal, "Amount must be less than total reflections");
227         uint256 currentRate =  _getRate();
228         return rAmount.div(currentRate);
229     }
230 
231     function _approve(address owner, address spender, uint256 amount) private {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 
238     function _transfer(address from, address to, uint256 amount) private {
239         require(from != address(0), "ERC20: transfer from the zero address");
240         require(to != address(0), "ERC20: transfer to the zero address");
241         require(amount > 0, "Transfer amount must be greater than zero");
242 
243 
244         if (from != owner() && to != owner()) {
245             require(!bots[from] && !bots[to]);
246             _feeAddr1 = 0;
247             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
248             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
249                 // Cooldown
250                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
251                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
252                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
253             }
254 
255 
256             uint256 contractTokenBalance = balanceOf(address(this));
257             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<_reduceTaxTarget) {
258                 swapTokensForEth(contractTokenBalance);
259                 uint256 contractETHBalance = address(this).balance;
260                 if(contractETHBalance > 0) {
261                     sendETHToFee(address(this).balance);
262                 }
263             }
264         }else{
265           _feeAddr1 = 0;
266           _feeAddr2 = 0;
267         }
268 
269         _tokenTransfer(from,to,amount);
270     }
271 
272     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             address(this),
282             block.timestamp
283         );
284     }
285 
286 
287     function removeLimits() external onlyOwner{
288         _maxTxAmount = _tTotal;
289         _maxWalletSize = _tTotal;
290     }
291 
292     function sendETHToFee(uint256 amount) private {
293         _feeAddrWallet.transfer(amount);
294     }
295 
296     function addBots(address[] memory bots_) public onlyOwner {
297         for (uint i = 0; i < bots_.length; i++) {
298             bots[bots_[i]] = true;
299         }
300     }
301 
302     function delBots(address[] memory notbot) public onlyOwner {
303       for (uint i = 0; i < notbot.length; i++) {
304           bots[notbot[i]] = false;
305       }
306 
307     }
308 
309     function openTrading() external onlyOwner() {
310         require(!tradingOpen,"trading is already open");
311         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
312         uniswapV2Router = _uniswapV2Router;
313         _approve(address(this), address(uniswapV2Router), _tTotal);
314         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
315         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
316         swapEnabled = true;
317         cooldownEnabled = true;
318 
319         tradingOpen = true;
320         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
321     }
322 
323     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
324         _transferStandard(sender, recipient, amount);
325     }
326 
327     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
328         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
329         _rOwned[sender] = _rOwned[sender].sub(rAmount);
330         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
331         _takeTeam(tTeam);
332         _reflectFee(rFee, tFee);
333         emit Transfer(sender, recipient, tTransferAmount);
334     }
335 
336     function _takeTeam(uint256 tTeam) private {
337         uint256 currentRate =  _getRate();
338         uint256 rTeam = tTeam.mul(currentRate);
339         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
340     }
341 
342     function _reflectFee(uint256 rFee, uint256 tFee) private {
343         _rTotal = _rTotal.sub(rFee);
344         _tFeeTotal = _tFeeTotal.add(tFee);
345     }
346 
347     receive() external payable {}
348 
349     function manualswap() external {
350         require(_msgSender() == _feeAddrWallet);
351         uint256 contractBalance = balanceOf(address(this));
352         swapTokensForEth(contractBalance);
353     }
354 
355     function manualsend() external {
356         require(_msgSender() == _feeAddrWallet);
357         uint256 contractETHBalance = address(this).balance;
358         sendETHToFee(contractETHBalance);
359     }
360 
361 
362     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
363         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
364         uint256 currentRate =  _getRate();
365         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
366         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
367     }
368 
369     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
370         uint256 tFee = tAmount.mul(taxFee).div(100);
371         uint256 tTeam = tAmount.mul(TeamFee).div(100);
372         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
373         return (tTransferAmount, tFee, tTeam);
374     }
375 
376     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
377         uint256 rAmount = tAmount.mul(currentRate);
378         uint256 rFee = tFee.mul(currentRate);
379         uint256 rTeam = tTeam.mul(currentRate);
380         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
381         return (rAmount, rTransferAmount, rFee);
382     }
383 
384 	function _getRate() private view returns(uint256) {
385         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
386         return rSupply.div(tSupply);
387     }
388 
389     function _getCurrentSupply() private view returns(uint256, uint256) {
390         uint256 rSupply = _rTotal;
391         uint256 tSupply = _tTotal;
392         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
393         return (rSupply, tSupply);
394     }
395 }