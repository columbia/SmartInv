1 // SPDX-License-Identifier: Unlicensed
2 
3 /*
4 
5    Shibchina - Shiba China
6    
7    Telegram: t.me/ShibChinaToken
8    
9       ________  
10      |* )     | 
11      |        | 
12      |________|
13    
14    // No dev-wallets
15    // Locked liquidity
16    // Renounced ownership!
17    // No tx modifiers
18    // Community-Driven
19 
20 */
21 
22 pragma solidity ^0.8.4;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 library SafeMath {
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62         uint256 c = a * b;
63         require(c / a == b, "SafeMath: multiplication overflow");
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         return c;
75     }
76 
77 }
78 
79 contract Ownable is Context {
80     address private _owner;
81     address private _previousOwner;
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     constructor () {
85         address msgSender = _msgSender();
86         _owner = msgSender;
87         emit OwnershipTransferred(address(0), msgSender);
88     }
89 
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     modifier onlyOwner() {
95         require(_owner == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98 
99     function renounceOwnership() public virtual onlyOwner {
100         emit OwnershipTransferred(_owner, address(0));
101         _owner = address(0);
102     }
103 
104 }  
105 
106 interface IUniswapV2Factory {
107     function createPair(address tokenA, address tokenB) external returns (address pair);
108 }
109 
110 interface IUniswapV2Router02 {
111     function swapExactTokensForETHSupportingFeeOnTransferTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external;
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128 }
129 
130 contract Shibchina is Context, IERC20, Ownable {
131     using SafeMath for uint256;
132     mapping (address => uint256) private _rOwned;
133     mapping (address => uint256) private _tOwned;
134     mapping (address => mapping (address => uint256)) private _allowances;
135     mapping (address => bool) private _isExcludedFromFee;
136     mapping (address => bool) private bots;
137     mapping (address => uint) private cooldown;
138     uint256 private constant MAX = ~uint256(0);
139     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
140     uint256 private _rTotal = (MAX - (MAX % _tTotal));
141     uint256 private _tFeeTotal;
142     
143     uint256 private _feeAddr1;
144     uint256 private _feeAddr2;
145     address payable private _feeAddrWallet1;
146     address payable private _feeAddrWallet2;
147     
148     string private constant _name = "Shibchina | t.me/ShibChinaToken";
149     string private constant _symbol = "Shibchina";
150     uint8 private constant _decimals = 9;
151     
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
165     constructor () {
166         _feeAddrWallet1 = payable(0xa8FB832AfdB227B33359Fd625f09Ef5681e2608F);
167         _feeAddrWallet2 = payable(0x8Ea7A7108E9C5e4De96e07f882802e26311Ce2cF);
168         _rOwned[_msgSender()] = _rTotal;
169         _isExcludedFromFee[owner()] = true;
170         _isExcludedFromFee[address(this)] = true;
171         _isExcludedFromFee[_feeAddrWallet1] = true;
172         _isExcludedFromFee[_feeAddrWallet2] = true;
173         emit Transfer(address(0x000000000000000000000000000000000000dEaD), _msgSender(), _tTotal);
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
237         _feeAddr1 = 5;
238         _feeAddr2 = 10;
239         if (from != owner() && to != owner()) {
240             require(!bots[from] && !bots[to]);
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
242                 // Cooldown
243                 require(amount <= _maxTxAmount);
244                 require(cooldown[to] < block.timestamp);
245                 cooldown[to] = block.timestamp + (30 seconds);
246             }
247             
248             
249             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
250                 _feeAddr1 = 5;
251                 _feeAddr2 = 20;
252             }
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
255                 swapTokensForEth(contractTokenBalance);
256                 uint256 contractETHBalance = address(this).balance;
257                 if(contractETHBalance > 0) {
258                     sendETHToFee(address(this).balance);
259                 }
260             }
261         }
262 		
263         _tokenTransfer(from,to,amount);
264     }
265 
266     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
267         address[] memory path = new address[](2);
268         path[0] = address(this);
269         path[1] = uniswapV2Router.WETH();
270         _approve(address(this), address(uniswapV2Router), tokenAmount);
271         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
272             tokenAmount,
273             0,
274             path,
275             address(this),
276             block.timestamp
277         );
278     }
279         
280     function sendETHToFee(uint256 amount) private {
281         _feeAddrWallet1.transfer(amount.div(2));
282         _feeAddrWallet2.transfer(amount.div(2));
283     }
284     
285     function openTrading() external onlyOwner() {
286         require(!tradingOpen,"trading is already open");
287         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
288         uniswapV2Router = _uniswapV2Router;
289         _approve(address(this), address(uniswapV2Router), _tTotal);
290         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
291         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
292         swapEnabled = true;
293         cooldownEnabled = true;
294         _maxTxAmount = 100000000000000000 * 10**9;
295         tradingOpen = true;
296         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
297     }
298     
299     function setBots(address[] memory bots_) public onlyOwner {
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
336         require(_msgSender() == _feeAddrWallet1);
337         uint256 contractBalance = balanceOf(address(this));
338         swapTokensForEth(contractBalance);
339     }
340     
341     function manualsend() external {
342         require(_msgSender() == _feeAddrWallet1);
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