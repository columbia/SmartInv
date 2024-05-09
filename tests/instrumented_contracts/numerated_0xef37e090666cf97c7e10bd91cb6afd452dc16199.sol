1 /*
2        When dragons grow too mighty to slay with pen or sword
3        Telegram: https://t.me/DejitaruLadon
4        Medium: https://medium.com/@LadonToken/ladon-mythology-4409ec3eab85
5 
6 */
7 
8 // SPDX-License-Identifier: UNLICENSED
9 
10 pragma solidity ^0.8.9;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     address private _previousOwner;
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91 }  
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract DejitaruLadon is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _rOwned;
120     mapping (address => uint256) private _tOwned;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping (address => uint) private cooldown;
125     uint256 private constant MAX = ~uint256(0);
126     uint256 private constant _tTotal = 100000000 * 10**9;
127     uint256 private _rTotal = (MAX - (MAX % _tTotal));
128     uint256 private _tFeeTotal;
129     
130     uint256 private _feeAddr1;
131     uint256 private _feeAddr2;
132     address payable private _feeAddrWallet;
133     string private constant _name = "Dejitaru Ladon";
134     string private constant _symbol = "LADON";
135     uint8 private constant _decimals = 9;
136     
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142     bool private cooldownEnabled = false;
143     uint256 private _maxTxAmount = _tTotal;
144     uint256 private _maxWalletSize = _tTotal;
145     event MaxTxAmountUpdated(uint _maxTxAmount);
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151 
152     constructor () {
153         _feeAddrWallet = payable(0x099C0c3262cf8146053B9d60d8d19C4a83E2A118);
154         _rOwned[_msgSender()] = _rTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[_feeAddrWallet] = true;
158         emit Transfer(address(0), _msgSender(), _tTotal);
159     }
160 
161     function name() public pure returns (string memory) {
162         return _name;
163     }
164 
165     function symbol() public pure returns (string memory) {
166         return _symbol;
167     }
168 
169     function decimals() public pure returns (uint8) {
170         return _decimals;
171     }
172 
173     function totalSupply() public pure override returns (uint256) {
174         return _tTotal;
175     }
176 
177     function balanceOf(address account) public view override returns (uint256) {
178         return tokenFromReflection(_rOwned[account]);
179     }
180 
181     function transfer(address recipient, uint256 amount) public override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     function allowance(address owner, address spender) public view override returns (uint256) {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount) public override returns (bool) {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
196         _transfer(sender, recipient, amount);
197         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
198         return true;
199     }
200 
201     function setCooldownEnabled(bool onoff) external onlyOwner() {
202         cooldownEnabled = onoff;
203     }
204 
205     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
206         require(rAmount <= _rTotal, "Amount must be less than total reflections");
207         uint256 currentRate =  _getRate();
208         return rAmount.div(currentRate);
209     }
210 
211     function _approve(address owner, address spender, uint256 amount) private {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218     function _transfer(address from, address to, uint256 amount) private {
219         require(from != address(0), "ERC20: transfer from the zero address");
220         require(to != address(0), "ERC20: transfer to the zero address");
221         require(amount > 0, "Transfer amount must be greater than zero");
222 
223         _feeAddr1 = 0;
224         _feeAddr2 = 4;
225 
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
229                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
230                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
231                 require(cooldown[to] < block.timestamp);
232                 cooldown[to] = block.timestamp + (30 seconds);
233             }
234             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
235 
236                 _feeAddr1 = 0;
237                 _feeAddr2 = 4;
238 
239             }
240             uint256 contractTokenBalance = balanceOf(address(this));
241             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
242                 swapTokensForEth(contractTokenBalance);
243                 uint256 contractETHBalance = address(this).balance;
244                 if(contractETHBalance > 0) {
245                     sendETHToFee(address(this).balance);
246                 }
247             }
248         }
249         _tokenTransfer(from,to,amount);
250     }
251 
252     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
253         address[] memory path = new address[](2);
254         path[0] = address(this);
255         path[1] = uniswapV2Router.WETH();
256         _approve(address(this), address(uniswapV2Router), tokenAmount);
257         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
258             tokenAmount,
259             0,
260             path,
261             address(this),
262             block.timestamp
263         );
264     }
265 
266     function removeLimits() external onlyOwner{
267         _maxTxAmount = _tTotal;
268         _maxWalletSize = _tTotal;
269     }
270 
271     function changeMaxTxAmount(uint256 percentage) external onlyOwner{
272         require(percentage>0);
273         _maxTxAmount = _tTotal.mul(percentage).div(100);
274     }
275 
276     function changeMaxWalletSize(uint256 percentage) external onlyOwner{
277         require(percentage>0);
278         _maxWalletSize = _tTotal.mul(percentage).div(100);
279     }
280         
281     function sendETHToFee(uint256 amount) private {
282         _feeAddrWallet.transfer(amount);
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
294         _maxTxAmount = _tTotal.mul(20).div(1000);
295         _maxWalletSize = _tTotal.mul(20).div(1000);
296         tradingOpen = true;
297         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
298     }
299     
300     function addBots(address[] memory bots_) public onlyOwner {
301         for (uint i = 0; i < bots_.length; i++) {
302             bots[bots_[i]] = true;
303         }
304     }
305     
306     function delBot(address notbot) public onlyOwner {
307         bots[notbot] = false;
308     }
309         
310     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
311         _transferStandard(sender, recipient, amount);
312     }
313 
314     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
315         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
316         _rOwned[sender] = _rOwned[sender].sub(rAmount);
317         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
318         _takeTeam(tTeam);
319         _reflectFee(rFee, tFee);
320         emit Transfer(sender, recipient, tTransferAmount);
321     }
322 
323     function _takeTeam(uint256 tTeam) private {
324         uint256 currentRate =  _getRate();
325         uint256 rTeam = tTeam.mul(currentRate);
326         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
327     }
328 
329     function _reflectFee(uint256 rFee, uint256 tFee) private {
330         _rTotal = _rTotal.sub(rFee);
331         _tFeeTotal = _tFeeTotal.add(tFee);
332     }
333 
334     receive() external payable {}
335     
336     function manualswap() external {
337         require(_msgSender() == _feeAddrWallet);
338         uint256 contractBalance = balanceOf(address(this));
339         swapTokensForEth(contractBalance);
340     }
341     
342     function manualsend() external {
343         require(_msgSender() == _feeAddrWallet);
344         uint256 contractETHBalance = address(this).balance;
345         sendETHToFee(contractETHBalance);
346     }
347     
348 
349     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
350         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
351         uint256 currentRate =  _getRate();
352         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
353         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
354     }
355 
356     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
357         uint256 tFee = tAmount.mul(taxFee).div(100);
358         uint256 tTeam = tAmount.mul(TeamFee).div(100);
359         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
360         return (tTransferAmount, tFee, tTeam);
361     }
362 
363     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
364         uint256 rAmount = tAmount.mul(currentRate);
365         uint256 rFee = tFee.mul(currentRate);
366         uint256 rTeam = tTeam.mul(currentRate);
367         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
368         return (rAmount, rTransferAmount, rFee);
369     }
370 
371 	function _getRate() private view returns(uint256) {
372         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
373         return rSupply.div(tSupply);
374     }
375 
376     function _getCurrentSupply() private view returns(uint256, uint256) {
377         uint256 rSupply = _rTotal;
378         uint256 tSupply = _tTotal;      
379         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
380         return (rSupply, tSupply);
381     }
382 }