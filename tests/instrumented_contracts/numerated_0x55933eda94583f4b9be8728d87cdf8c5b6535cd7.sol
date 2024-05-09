1 // SPDX-License-Identifier: UNLICENSED
2 /**
3 
4 Zombie Pepe |  $ZEPE
5 
6 $ZEPE, the pioneering undead frog coin hailing from the kingdom of Pepe Frog.
7 
8 Would you let $ZEPE to bite you?
9 
10 https://t.me/ZEPE_PORTAL
11 https://zombiepepecoineth.com/
12 
13 **/
14 
15 pragma solidity 0.8.20;
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
123 contract ZombiePepe is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping (address => uint256) private _rOwned;
126     mapping (address => uint256) private _tOwned;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping (address => uint) private cooldown;
131     uint256 private constant MAX = ~uint256(0);
132 
133     uint256 private _rTotal = (MAX - (MAX % _tTotal));
134     uint256 private _tFeeTotal;
135 
136     uint256 private _feeAddr1;
137     uint256 private _feeAddr2;
138     uint256 private _initialTax=20;
139     uint256 private _finalTax=1;
140     uint256 private _reduceTaxAt=1;
141     uint256 private _startLiquidateAt=40;
142     uint256 private _buyCount=0;
143     address payable private _feeAddrWallet;
144 
145     string private constant _name = unicode"Zombie Pepe";
146     string private constant _symbol = unicode"ZEPE";
147     uint8 private constant _decimals = 9;
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private inSwap = false;
153     bool private swapEnabled = false;
154     bool private cooldownEnabled = false;
155     uint256 private constant _tTotal = 1000000000000 * 10**_decimals;
156     uint256 private _maxTxAmount = 20000000000 * 10**_decimals;
157     uint256 private _maxWalletSize = 20000000000 * 10**_decimals;
158     uint256 private _swapThreshold=5000000000*10**_decimals;
159     event MaxTxAmountUpdated(uint _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165 
166     constructor () {
167         _feeAddrWallet = payable(_msgSender());
168         _rOwned[_msgSender()] = _rTotal;
169         _isExcludedFromFee[owner()] = true;
170         _isExcludedFromFee[address(this)] = true;
171         _isExcludedFromFee[_feeAddrWallet] = true;
172 
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
220     function addBots(address[] memory bots_) public onlyOwner {
221         for (uint i = 0; i < bots_.length; i++) {
222             bots[bots_[i]] = true;
223         }
224     }
225 
226     function delBots(address[] memory notbot) public onlyOwner {
227       for (uint i = 0; i < notbot.length; i++) {
228           bots[notbot[i]] = false;
229       }
230     }
231 
232     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
233         require(rAmount <= _rTotal, "Amount must be less than total reflections");
234         uint256 currentRate =  _getRate();
235         return rAmount.div(currentRate);
236     }
237 
238     function _approve(address owner, address spender, uint256 amount) private {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244 
245     function _transfer(address from, address to, uint256 amount) private {
246         require(from != address(0), "ERC20: transfer from the zero address");
247         require(to != address(0), "ERC20: transfer to the zero address");
248         require(amount > 0, "Transfer amount must be greater than zero");
249 
250 
251         if (from != owner() && to != owner()) {
252             require(!bots[from] && !bots[to]);
253             _feeAddr1 = 1;
254             _feeAddr2 = (_buyCount>=_reduceTaxAt)?_finalTax:_initialTax;
255             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
256                 // Cooldown
257                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
258                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
259                 _buyCount++;
260             }
261 
262 
263             uint256 contractTokenBalance = balanceOf(address(this));
264             if (!inSwap &&  to  == uniswapV2Pair && swapEnabled && contractTokenBalance>=_swapThreshold && _buyCount>_startLiquidateAt) {
265                 swapTokensForEth(_swapThreshold>amount?amount:_swapThreshold);
266                 uint256 contractETHBalance = address(this).balance;
267                 if(contractETHBalance > 0) {
268                     sendETHToFee(address(this).balance);
269                 }
270             }
271         }else{
272           _feeAddr1 = 0;
273           _feeAddr2 = 0;
274         }
275 
276         _tokenTransfer(from,to,amount);
277     }
278 
279     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
280         address[] memory path = new address[](2);
281         path[0] = address(this);
282         path[1] = uniswapV2Router.WETH();
283         _approve(address(this), address(uniswapV2Router), tokenAmount);
284         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
285             tokenAmount,
286             0,
287             path,
288             address(this),
289             block.timestamp
290         );
291     }
292 
293 
294     function removeLimits() external onlyOwner{
295         _maxTxAmount = _tTotal;
296         _maxWalletSize = _tTotal;
297     }
298 
299     function sendETHToFee(uint256 amount) private {
300         _feeAddrWallet.transfer(amount);
301     }
302 
303     function openTrading() external onlyOwner() {
304         require(!tradingOpen,"trading is already open");
305         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         uniswapV2Router = _uniswapV2Router;
307         _approve(address(this), address(uniswapV2Router), _tTotal);
308         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
309         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
310         swapEnabled = true;
311         cooldownEnabled = true;
312 
313         tradingOpen = true;
314         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
315     }
316 
317     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
318         _transferStandard(sender, recipient, amount);
319     }
320 
321     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
322         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
323         _rOwned[sender] = _rOwned[sender].sub(rAmount);
324         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
325         _takeTeam(tTeam);
326         _reflectFee(rFee, tFee);
327         emit Transfer(sender, recipient, tTransferAmount);
328     }
329 
330     function _takeTeam(uint256 tTeam) private {
331         uint256 currentRate =  _getRate();
332         uint256 rTeam = tTeam.mul(currentRate);
333         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
334     }
335 
336     function _reflectFee(uint256 rFee, uint256 tFee) private {
337         _rTotal = _rTotal.sub(rFee);
338         _tFeeTotal = _tFeeTotal.add(tFee);
339     }
340 
341     receive() external payable {}
342 
343     function manualSwap() external {
344         require(_msgSender()==_feeAddrWallet);
345         uint256 tokenBalance=balanceOf(address(this));
346         if(tokenBalance>0){
347           swapTokensForEth(tokenBalance);
348         }
349         uint256 ethBalance=address(this).balance;
350         if(ethBalance>0){
351           sendETHToFee(ethBalance);
352         }
353     }
354 
355     function isBot(address a) public view returns (bool){
356       return bots[a];
357     }
358 
359 
360     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
361         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
362         uint256 currentRate =  _getRate();
363         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
364         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
365     }
366 
367     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
368         uint256 tFee = tAmount.mul(taxFee).div(100);
369         uint256 tTeam = tAmount.mul(TeamFee).div(100);
370         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
371         return (tTransferAmount, tFee, tTeam);
372     }
373 
374     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
375         uint256 rAmount = tAmount.mul(currentRate);
376         uint256 rFee = tFee.mul(currentRate);
377         uint256 rTeam = tTeam.mul(currentRate);
378         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
379         return (rAmount, rTransferAmount, rFee);
380     }
381 
382 	function _getRate() private view returns(uint256) {
383         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
384         return rSupply.div(tSupply);
385     }
386 
387     function _getCurrentSupply() private view returns(uint256, uint256) {
388         uint256 rSupply = _rTotal;
389         uint256 tSupply = _tTotal;
390         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
391         return (rSupply, tSupply);
392     }
393 }