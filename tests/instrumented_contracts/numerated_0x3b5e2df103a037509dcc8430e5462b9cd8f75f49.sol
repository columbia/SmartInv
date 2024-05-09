1 /**
2 
3 https://t.me/GEMXportal
4 */
5 
6 
7 pragma solidity ^0.8.7;
8 // SPDX-License-Identifier: UNLICENSED
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     address private _previousOwner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }  
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 
115 contract GEMX is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _rOwned;
118     mapping (address => uint256) private _tOwned;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) private bots;
122     mapping (address => uint) private cooldown;
123     uint256 private constant MAX = ~uint256(0);
124     uint256 private constant _tTotal = 10000000 * 10**9;
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126     uint256 private _tFeeTotal;
127     
128     uint256 private _feeAddr1;
129     uint256 private _feeAddr2;
130     address payable private _feeAddrWallet;
131     
132     string private constant _name = "GEMX";
133     string private constant _symbol = "GEMX";
134     uint8 private constant _decimals = 9;
135     
136     IUniswapV2Router02 private uniswapV2Router;
137     address private uniswapV2Pair;
138     bool private tradingOpen;
139     bool private inSwap = false;
140     bool private swapEnabled = false;
141     bool private cooldownEnabled = false;
142     uint256 private _maxTxAmount = _tTotal;
143     uint256 private _maxWalletSize = _tTotal;
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150 
151     constructor () {
152         _feeAddrWallet = payable(0x4BF2274D1bA1B22D00Adb5dbeD22FdB7d92f5007);
153         _rOwned[_msgSender()] = _rTotal;
154         _isExcludedFromFee[owner()] = true;
155         _isExcludedFromFee[address(this)] = true;
156         _isExcludedFromFee[_feeAddrWallet] = true;
157         emit Transfer(address(0), _msgSender(), _tTotal);
158     }
159 
160     function name() public pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return tokenFromReflection(_rOwned[account]);
178     }
179 
180     function transfer(address recipient, uint256 amount) public override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(address owner, address spender) public view override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
195         _transfer(sender, recipient, amount);
196         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function setCooldownEnabled(bool onoff) external onlyOwner() {
201         cooldownEnabled = onoff;
202     }
203 
204     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
205         require(rAmount <= _rTotal, "Amount must be less than total reflections");
206         uint256 currentRate =  _getRate();
207         return rAmount.div(currentRate);
208     }
209 
210     function _approve(address owner, address spender, uint256 amount) private {
211         require(owner != address(0), "ERC20: approve from the zero address");
212         require(spender != address(0), "ERC20: approve to the zero address");
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _transfer(address from, address to, uint256 amount) private {
218         require(from != address(0), "ERC20: transfer from the zero address");
219         require(to != address(0), "ERC20: transfer to the zero address");
220         require(amount > 0, "Transfer amount must be greater than zero");
221         _feeAddr1 = 0;
222         _feeAddr2 = 5;
223         if (from != owner() && to != owner()) {
224             require(!bots[from] && !bots[to]);
225             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
226                 // Cooldown
227                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
228                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
229                 require(cooldown[to] < block.timestamp);
230                 cooldown[to] = block.timestamp + (30 seconds);
231             }
232             
233             
234             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
235                 _feeAddr1 = 0;
236                 _feeAddr2 = 5;
237             }
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
240                 swapTokensForEth(contractTokenBalance);
241                 uint256 contractETHBalance = address(this).balance;
242                 if(contractETHBalance > 0) {
243                     sendETHToFee(address(this).balance);
244                 }
245             }
246         }
247 		
248         _tokenTransfer(from,to,amount);
249     }
250 
251     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
252         address[] memory path = new address[](2);
253         path[0] = address(this);
254         path[1] = uniswapV2Router.WETH();
255         _approve(address(this), address(uniswapV2Router), tokenAmount);
256         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
257             tokenAmount,
258             0,
259             path,
260             address(this),
261             block.timestamp
262         );
263     }
264 
265     function removeLimits() external onlyOwner{
266         _maxTxAmount = _tTotal;
267         _maxWalletSize = _tTotal;
268     }
269 
270     function changeMaxTxAmount(uint256 percentage) external onlyOwner{
271         require(percentage>0);
272         _maxTxAmount = _tTotal.mul(percentage).div(100);
273     }
274 
275     function changeMaxWalletSize(uint256 percentage) external onlyOwner{
276         require(percentage>0);
277         _maxWalletSize = _tTotal.mul(percentage).div(100);
278     }
279         
280     function sendETHToFee(uint256 amount) private {
281         _feeAddrWallet.transfer(amount);
282     }  
283 
284     function openTrading() external onlyOwner() {
285         require(!tradingOpen,"trading is already open");
286         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
287         uniswapV2Router = _uniswapV2Router;
288         _approve(address(this), address(uniswapV2Router), _tTotal);
289         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
290         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
291         swapEnabled = true;
292         cooldownEnabled = true;
293         _maxTxAmount = _tTotal.mul(10).div(1000);
294         _maxWalletSize = _tTotal.mul(20).div(1000);
295         tradingOpen = true;
296         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
297     }
298     
299     function addbot(address[] memory bots_) public onlyOwner {
300         for (uint i = 0; i < bots_.length; i++) {
301             bots[bots_[i]] = true;
302         }
303     }
304     
305     function delBot(address notbot) public onlyOwner {
306         bots[notbot] = false;
307     }
308         
309     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
310         _transferStandard(sender, recipient, amount);
311     }
312 
313     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
314         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
315         _rOwned[sender] = _rOwned[sender].sub(rAmount);
316         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
317         _takeTeam(tTeam);
318         _reflectFee(rFee, tFee);
319         emit Transfer(sender, recipient, tTransferAmount);
320     }
321 
322     function _takeTeam(uint256 tTeam) private {
323         uint256 currentRate =  _getRate();
324         uint256 rTeam = tTeam.mul(currentRate);
325         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
326     }
327 
328     function _reflectFee(uint256 rFee, uint256 tFee) private {
329         _rTotal = _rTotal.sub(rFee);
330         _tFeeTotal = _tFeeTotal.add(tFee);
331     }
332 
333     receive() external payable {}
334     
335     function manualswap() external {
336         require(_msgSender() == _feeAddrWallet);
337         uint256 contractBalance = balanceOf(address(this));
338         swapTokensForEth(contractBalance);
339     }
340     
341     function manualsend() external {
342         require(_msgSender() == _feeAddrWallet);
343         uint256 contractETHBalance = address(this).balance;
344         sendETHToFee(contractETHBalance);
345     }
346     
347 
348     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
349         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
350         uint256 currentRate =  _getRate();
351         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
352         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
353     }
354 
355     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
356         uint256 tFee = tAmount.mul(taxFee).div(100);
357         uint256 tTeam = tAmount.mul(TeamFee).div(100);
358         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
359         return (tTransferAmount, tFee, tTeam);
360     }
361 
362     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
363         uint256 rAmount = tAmount.mul(currentRate);
364         uint256 rFee = tFee.mul(currentRate);
365         uint256 rTeam = tTeam.mul(currentRate);
366         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
367         return (rAmount, rTransferAmount, rFee);
368     }
369 
370 	function _getRate() private view returns(uint256) {
371         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
372         return rSupply.div(tSupply);
373     }
374 
375     function _getCurrentSupply() private view returns(uint256, uint256) {
376         uint256 rSupply = _rTotal;
377         uint256 tSupply = _tTotal;      
378         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
379         return (rSupply, tSupply);
380     }
381 }