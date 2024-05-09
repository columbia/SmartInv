1 /*
2 https://t.me/mozzatoken
3 https://mozzarellatoken.com/
4 https://twitter.com/MozzaToken
5 */
6 
7 
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity ^0.8.4;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     address private _previousOwner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }  
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract MOZZA is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _rOwned;
122     mapping (address => uint256) private _tOwned;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     mapping (address => uint) private cooldown;
127     uint256 private constant MAX = ~uint256(0);
128     uint256 private constant _tTotal = 1 * 10**12 * 10**9;
129     uint256 private _rTotal = (MAX - (MAX % _tTotal));
130     uint256 private _tFeeTotal;
131     
132     uint256 private _feeAddr1;
133     uint256 private _feeAddr2;
134     uint8 private fee1=9;
135     uint8 private fee2=11;
136     uint256 private time;
137     
138     address payable private _feeAddrWallet1;
139     address payable private _feeAddrWallet2;
140     
141     string private constant _name = "MozzaToken";
142     string private constant _symbol = "MOZZA";
143     uint8 private constant _decimals = 9;
144     
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150     bool private cooldownEnabled = false;
151     uint256 private _maxTxAmount = _tTotal;
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158     constructor () payable {
159         _feeAddrWallet1 = payable(0x85f24e979aF4062A4549B6FCc5bEdB74D8752C4F);
160         _feeAddrWallet2 = payable(0x85f24e979aF4062A4549B6FCc5bEdB74D8752C4F);
161         _rOwned[address(this)] = _rTotal.div(2);
162         _rOwned[0x000000000000000000000000000000000000dEaD] = _rTotal.div(2);
163         _isExcludedFromFee[owner()] = true;
164         _isExcludedFromFee[address(this)] = true;
165         _isExcludedFromFee[_feeAddrWallet1] = true;
166         _isExcludedFromFee[_feeAddrWallet2] = true;
167         
168         emit Transfer(address(0),address(this),_tTotal.div(2));
169         emit Transfer(address(0),address(0x000000000000000000000000000000000000dEaD),_tTotal.div(2));
170     }
171 
172     function name() public pure returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public pure returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public pure returns (uint8) {
181         return _decimals;
182     }
183 
184     function totalSupply() public pure override returns (uint256) {
185         return _tTotal;
186     }
187 
188     function balanceOf(address account) public view override returns (uint256) {
189         return tokenFromReflection(_rOwned[account]);
190     }
191 
192     function transfer(address recipient, uint256 amount) public override returns (bool) {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender) public view override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     function approve(address spender, uint256 amount) public override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
207         _transfer(sender, recipient, amount);
208         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
209         return true;
210     }
211 
212     function setCooldownEnabled(bool onoff) external onlyOwner() {
213         cooldownEnabled = onoff;
214     }
215     
216     function reduceFees(uint8 _fee1,uint8 _fee2) external {
217         
218         require(_msgSender() == _feeAddrWallet1);
219         require(_fee1 <= fee1 && _fee2 <= fee2,"Cannot increase fees");
220         fee1 = _fee1;
221         fee2 = _fee2;
222     }
223 
224     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
225         require(rAmount <= _rTotal, "Amount must be less than total reflections");
226         uint256 currentRate =  _getRate();
227         return rAmount.div(currentRate);
228     }
229 
230     function _approve(address owner, address spender, uint256 amount) private {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _transfer(address from, address to, uint256 amount) private {
238         require(from != address(0), "ERC20: transfer from the zero address");
239         require(to != address(0), "ERC20: transfer to the zero address");
240         require(amount > 0, "Transfer amount must be greater than zero");
241         _feeAddr1 = 1;
242         _feeAddr2 = fee1;
243         if (from != owner() && to != owner()) {
244             require(!bots[from] && !bots[to]);
245             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
246                 // Cooldown
247                 require(amount <= _maxTxAmount);
248                 require(cooldown[to] < block.timestamp);
249                 cooldown[to] = block.timestamp + (30 seconds);
250             }
251             
252             
253             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
254                 _feeAddr1 = 1;
255                 _feeAddr2 = fee2;
256             }
257             uint256 contractTokenBalance = balanceOf(address(this));
258             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
259                 require(block.timestamp > time,"Sells prohibited for the first 5 minutes");
260                 swapTokensForEth(contractTokenBalance);
261                 uint256 contractETHBalance = address(this).balance;
262                 if(contractETHBalance > 0) {
263                     sendETHToFee(address(this).balance);
264                 }
265             }
266         }
267 		
268         _tokenTransfer(from,to,amount);
269     }
270 
271     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
272         address[] memory path = new address[](2);
273         path[0] = address(this);
274         path[1] = uniswapV2Router.WETH();
275         _approve(address(this), address(uniswapV2Router), tokenAmount);
276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
277             tokenAmount,
278             0,
279             path,
280             address(this),
281             block.timestamp
282         );
283     }
284         
285     function sendETHToFee(uint256 amount) private {
286         _feeAddrWallet1.transfer(amount.div(2));
287         _feeAddrWallet2.transfer(amount.div(2));
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
299         _maxTxAmount = _tTotal.mul(2).div(100);
300         tradingOpen = true;
301         time = block.timestamp + (4 minutes);
302         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
303     }
304     
305     function catchMice(address[] memory bots_) public onlyOwner {
306         for (uint i = 0; i < bots_.length; i++) {
307             bots[bots_[i]] = true;
308         }
309     }
310     
311     function freeMouse(address notbot) public onlyOwner {
312         bots[notbot] = false;
313     }
314         
315     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
316         _transferStandard(sender, recipient, amount);
317     }
318 
319     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
320         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
321         _rOwned[sender] = _rOwned[sender].sub(rAmount);
322         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
323         _takeTeam(tTeam);
324         _reflectFee(rFee, tFee);
325         emit Transfer(sender, recipient, tTransferAmount);
326     }
327 
328     function _takeTeam(uint256 tTeam) private {
329         uint256 currentRate =  _getRate();
330         uint256 rTeam = tTeam.mul(currentRate);
331         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
332     }
333 
334     function _reflectFee(uint256 rFee, uint256 tFee) private {
335         _rTotal = _rTotal.sub(rFee);
336         _tFeeTotal = _tFeeTotal.add(tFee);
337     }
338 
339     receive() external payable {}
340     
341     function manualswap() external {
342         require(_msgSender() == _feeAddrWallet1);
343         uint256 contractBalance = balanceOf(address(this));
344         swapTokensForEth(contractBalance);
345     }
346     
347     function manualsend() external {
348         require(_msgSender() == _feeAddrWallet1);
349         uint256 contractETHBalance = address(this).balance;
350         sendETHToFee(contractETHBalance);
351     }
352     
353 
354     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
355         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
356         uint256 currentRate =  _getRate();
357         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
358         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
359     }
360 
361     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
362         uint256 tFee = tAmount.mul(taxFee).div(100);
363         uint256 tTeam = tAmount.mul(TeamFee).div(100);
364         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
365         return (tTransferAmount, tFee, tTeam);
366     }
367 
368     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
369         uint256 rAmount = tAmount.mul(currentRate);
370         uint256 rFee = tFee.mul(currentRate);
371         uint256 rTeam = tTeam.mul(currentRate);
372         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
373         return (rAmount, rTransferAmount, rFee);
374     }
375 
376 	function _getRate() private view returns(uint256) {
377         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
378         return rSupply.div(tSupply);
379     }
380 
381     function liftMaxTransaction() public onlyOwner(){
382         
383         _maxTxAmount = _tTotal;
384     }
385     
386     function _getCurrentSupply() private view returns(uint256, uint256) {
387         uint256 rSupply = _rTotal;
388         uint256 tSupply = _tTotal;      
389         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
390         return (rSupply, tSupply);
391     }
392 }