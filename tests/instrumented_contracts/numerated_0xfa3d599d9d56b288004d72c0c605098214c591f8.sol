1 /**
2 
3 $Anime Coin (ANIME)
4 
5 https://t.me/animecoineth
6 
7 2/2 Tax
8 
9 */
10 
11 
12 
13 pragma solidity ^0.8.7;
14 // SPDX-License-Identifier: UNLICENSED
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     address private _previousOwner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }  
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract AnimeCoin is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _rOwned;
124     mapping (address => uint256) private _tOwned;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private bots;
128     mapping (address => uint) private cooldown;
129     uint256 private constant MAX = ~uint256(0);
130     uint256 private constant _tTotal = 100000000 * 10**9;
131     uint256 private _rTotal = (MAX - (MAX % _tTotal));
132     uint256 private _tFeeTotal;
133     
134     uint256 private _feeAddr1;
135     uint256 private _feeAddr2;
136     address payable private _feeAddrWallet;
137     
138     string private constant _name = "Anime Coin";
139     string private constant _symbol = "ANIME";
140     uint8 private constant _decimals = 9;
141     
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147     bool private cooldownEnabled = false;
148     uint256 private _maxTxAmount = _tTotal;
149     uint256 private _maxWalletSize = _tTotal;
150     event MaxTxAmountUpdated(uint _maxTxAmount);
151     modifier lockTheSwap {
152         inSwap = true;
153         _;
154         inSwap = false;
155     }
156 
157     constructor () {
158         _feeAddrWallet = payable(0xdBC4e77082FA651316AF7c50B88e0006e688bC56);
159         _rOwned[_msgSender()] = _rTotal;
160         _isExcludedFromFee[owner()] = true;
161         _isExcludedFromFee[address(this)] = true;
162         _isExcludedFromFee[_feeAddrWallet] = true;
163         emit Transfer(address(0), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return tokenFromReflection(_rOwned[account]);
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function setCooldownEnabled(bool onoff) external onlyOwner() {
207         cooldownEnabled = onoff;
208     }
209 
210     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
211         require(rAmount <= _rTotal, "Amount must be less than total reflections");
212         uint256 currentRate =  _getRate();
213         return rAmount.div(currentRate);
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227         _feeAddr1 = 0;
228         _feeAddr2 = 2;
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
232                 // Cooldown
233                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235                 require(cooldown[to] < block.timestamp);
236                 cooldown[to] = block.timestamp + (30 seconds);
237             }
238             
239             
240             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
241                 _feeAddr1 = 0;
242                 _feeAddr2 = 2;
243             }
244             uint256 contractTokenBalance = balanceOf(address(this));
245             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
246                 swapTokensForEth(contractTokenBalance);
247                 uint256 contractETHBalance = address(this).balance;
248                 if(contractETHBalance > 0) {
249                     sendETHToFee(address(this).balance);
250                 }
251             }
252         }
253 		
254         _tokenTransfer(from,to,amount);
255     }
256 
257     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
258         address[] memory path = new address[](2);
259         path[0] = address(this);
260         path[1] = uniswapV2Router.WETH();
261         _approve(address(this), address(uniswapV2Router), tokenAmount);
262         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
263             tokenAmount,
264             0,
265             path,
266             address(this),
267             block.timestamp
268         );
269     }
270 
271     function removeLimits() external onlyOwner{
272         _maxTxAmount = _tTotal;
273         _maxWalletSize = _tTotal;
274     }
275 
276     function changeMaxTxAmount(uint256 percentage) external onlyOwner{
277         require(percentage>0);
278         _maxTxAmount = _tTotal.mul(percentage).div(100);
279     }
280 
281     function changeMaxWalletSize(uint256 percentage) external onlyOwner{
282         require(percentage>0);
283         _maxWalletSize = _tTotal.mul(percentage).div(100);
284     }
285         
286     function sendETHToFee(uint256 amount) private {
287         _feeAddrWallet.transfer(amount);
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
299         _maxTxAmount = _tTotal.mul(20).div(1000);
300         _maxWalletSize = _tTotal.mul(20).div(1000);
301         tradingOpen = true;
302         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
303     }
304     
305     function addbot(address[] memory bots_) public onlyOwner {
306         for (uint i = 0; i < bots_.length; i++) {
307             bots[bots_[i]] = true;
308         }
309     }
310     
311     function delBot(address notbot) public onlyOwner {
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
342         require(_msgSender() == _feeAddrWallet);
343         uint256 contractBalance = balanceOf(address(this));
344         swapTokensForEth(contractBalance);
345     }
346     
347     function manualsend() external {
348         require(_msgSender() == _feeAddrWallet);
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
381     function _getCurrentSupply() private view returns(uint256, uint256) {
382         uint256 rSupply = _rTotal;
383         uint256 tSupply = _tTotal;      
384         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
385         return (rSupply, tSupply);
386     }
387 }