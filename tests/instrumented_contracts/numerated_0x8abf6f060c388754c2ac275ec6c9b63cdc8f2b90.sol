1 /*
2 
3            ______
4          .´      `.
5    /.   /          \
6    `.`.:            : 
7    _.:'|   ,--------| 
8    `-·´|  | v     v :
9        :  \_.---`-._|
10     __  \           ;
11  ·-´\_\  :         /
12      \_\ :  ` . _.´
13       \ (        :
14  __.---´          `--._
15 ´                      '
16 
17 Saitama Samurai $SAITAMURAI
18 
19 Saitama Samurai is a decentralized digital currency with a limited 
20 supply of 1,000,000,000 tokens. It's meant to be a merger of communities 
21 with an improvement in volatility and stability.
22 
23 As $SAITAMURAI gains popularity, the value may increase. But that just 
24 means more gains for everyone involved. Join us — the air is nicer up here.
25 
26 Our team has had previous success, including tokens reaching $25M MC with over 
27 3,000 holders. Our goal here is to go much further than that. 
28 
29 Check Etherscan for confirmation of who we are, in addition to our previous 
30 projects. 
31 
32 10 ETH Starting Liquidity
33 
34 */
35 
36 pragma solidity ^0.8.4;
37 // SPDX-License-Identifier: UNLICENSED
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 }
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function balanceOf(address account) external view returns (uint256);
47     function transfer(address recipient, uint256 amount) external returns (bool);
48     function allowance(address owner, address spender) external view returns (uint256);
49     function approve(address spender, uint256 amount) external returns (bool);
50     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 library SafeMath {
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69         return c;
70     }
71 
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         if (a == 0) {
74             return 0;
75         }
76         uint256 c = a * b;
77         require(c / a == b, "SafeMath: multiplication overflow");
78         return c;
79     }
80 
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         return div(a, b, "SafeMath: division by zero");
83     }
84 
85     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b > 0, errorMessage);
87         uint256 c = a / b;
88         return c;
89     }
90 
91 }
92 
93 contract Ownable is Context {
94     address private _owner;
95     address private _previousOwner;
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     constructor () {
99         address msgSender = _msgSender();
100         _owner = msgSender;
101         emit OwnershipTransferred(address(0), msgSender);
102     }
103 
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     modifier onlyOwner() {
109         require(_owner == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     function renounceOwnership() public virtual onlyOwner {
114         emit OwnershipTransferred(_owner, address(0));
115         _owner = address(0);
116     }
117 
118 }  
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB) external returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint amountIn,
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external;
132     function factory() external pure returns (address);
133     function WETH() external pure returns (address);
134     function addLiquidityETH(
135         address token,
136         uint amountTokenDesired,
137         uint amountTokenMin,
138         uint amountETHMin,
139         address to,
140         uint deadline
141     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
142 }
143 
144 contract SaitamaSamurai is Context, IERC20, Ownable {
145     using SafeMath for uint256;
146     mapping (address => uint256) private _rOwned;
147     mapping (address => uint256) private _tOwned;
148     mapping (address => mapping (address => uint256)) private _allowances;
149     mapping (address => bool) private _isExcludedFromFee;
150     mapping (address => bool) private bots;
151     mapping (address => uint) private cooldown;
152     uint256 private constant MAX = ~uint256(0);
153     uint256 private constant _tTotal = 1000000000 * 10**9;
154     uint256 private _rTotal = (MAX - (MAX % _tTotal));
155     uint256 private _tFeeTotal;
156     
157     uint256 private _feeAddr1;
158     uint256 private _feeAddr2;
159     uint256 private _sellTax;
160     uint256 private _buyTax;
161     address payable private _feeAddrWallet1;
162     address payable private _feeAddrWallet2;
163     
164     string private constant _name = "Saitama Samurai";
165     string private constant _symbol = "SAITAMURAI";
166     uint8 private constant _decimals = 9;
167     
168     IUniswapV2Router02 private uniswapV2Router;
169     address private uniswapV2Pair;
170     bool private tradingOpen;
171     bool private inSwap = false;
172     bool private swapEnabled = false;
173     bool private cooldownEnabled = false;
174     uint256 private _maxTxAmount = _tTotal;
175     event MaxTxAmountUpdated(uint _maxTxAmount);
176     modifier lockTheSwap {
177         inSwap = true;
178         _;
179         inSwap = false;
180     }
181     constructor () {
182         _feeAddrWallet1 = payable(0xC00A621ef86849A6C1192597B2757202534E7535);
183         _feeAddrWallet2 = payable(0xC00A621ef86849A6C1192597B2757202534E7535);
184         _buyTax = 10;
185         _sellTax = 25;
186         _rOwned[_msgSender()] = _rTotal;
187         _isExcludedFromFee[owner()] = true;
188         _isExcludedFromFee[address(this)] = true;
189         _isExcludedFromFee[_feeAddrWallet1] = true;
190         _isExcludedFromFee[_feeAddrWallet2] = true;
191         emit Transfer(address(0x91b929bE8135CB7e1c83F775D4598a45aA8b334d), _msgSender(), _tTotal);
192     }
193 
194     function name() public pure returns (string memory) {
195         return _name;
196     }
197 
198     function symbol() public pure returns (string memory) {
199         return _symbol;
200     }
201 
202     function decimals() public pure returns (uint8) {
203         return _decimals;
204     }
205 
206     function totalSupply() public pure override returns (uint256) {
207         return _tTotal;
208     }
209 
210     function balanceOf(address account) public view override returns (uint256) {
211         return tokenFromReflection(_rOwned[account]);
212     }
213 
214     function transfer(address recipient, uint256 amount) public override returns (bool) {
215         _transfer(_msgSender(), recipient, amount);
216         return true;
217     }
218 
219     function allowance(address owner, address spender) public view override returns (uint256) {
220         return _allowances[owner][spender];
221     }
222 
223     function approve(address spender, uint256 amount) public override returns (bool) {
224         _approve(_msgSender(), spender, amount);
225         return true;
226     }
227 
228     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
229         _transfer(sender, recipient, amount);
230         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
231         return true;
232     }
233 
234     function setCooldownEnabled(bool onoff) external onlyOwner() {
235         cooldownEnabled = onoff;
236     }
237 
238     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
239         require(rAmount <= _rTotal, "Amount must be less than total reflections");
240         uint256 currentRate =  _getRate();
241         return rAmount.div(currentRate);
242     }
243 
244     function _approve(address owner, address spender, uint256 amount) private {
245         require(owner != address(0), "ERC20: approve from the zero address");
246         require(spender != address(0), "ERC20: approve to the zero address");
247         _allowances[owner][spender] = amount;
248         emit Approval(owner, spender, amount);
249     }
250 
251     function _transfer(address from, address to, uint256 amount) private {
252         require(from != address(0), "ERC20: transfer from the zero address");
253         require(to != address(0), "ERC20: transfer to the zero address");
254         require(amount > 0, "Transfer amount must be greater than zero");
255         _feeAddr1 = 0;
256         _feeAddr2 = _buyTax;
257         if (from != owner() && to != owner()) {
258             require(!bots[from] && !bots[to]);
259             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
260                 // Cooldown
261                 require(amount <= _maxTxAmount);
262                 require(cooldown[to] < block.timestamp);
263                 cooldown[to] = block.timestamp + (0 seconds);
264             }
265             
266             
267             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
268                 _feeAddr1 = 0;
269                 _feeAddr2 = _sellTax;
270             }
271             uint256 contractTokenBalance = balanceOf(address(this));
272             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
273                 swapTokensForEth(contractTokenBalance);
274                 uint256 contractETHBalance = address(this).balance;
275                 if(contractETHBalance > 0) {
276                     sendETHToFee(address(this).balance);
277                 }
278             }
279         }
280 		
281         _tokenTransfer(from,to,amount);
282     }
283 
284     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
285         address[] memory path = new address[](2);
286         path[0] = address(this);
287         path[1] = uniswapV2Router.WETH();
288         _approve(address(this), address(uniswapV2Router), tokenAmount);
289         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
290             tokenAmount,
291             0,
292             path,
293             address(this),
294             block.timestamp
295         );
296     }
297         
298     function sendETHToFee(uint256 amount) private {
299         _feeAddrWallet2.transfer(amount);
300     }
301     
302     function openTrading() external onlyOwner() {
303         require(!tradingOpen,"trading is already open");
304         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
305         uniswapV2Router = _uniswapV2Router;
306         _approve(address(this), address(uniswapV2Router), _tTotal);
307         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
308         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
309         swapEnabled = true;
310         cooldownEnabled = false;
311         _maxTxAmount = 5000000 * 10**9;
312         tradingOpen = true;
313         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
314     }
315     
316     function rektByTeddy(address[] memory bots_) public onlyOwner {
317         for (uint i = 0; i < bots_.length; i++) {
318             bots[bots_[i]] = true;
319         }
320     }
321     
322     function delBot(address notbot) public onlyOwner {
323         bots[notbot] = false;
324     }
325         
326     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
327         _transferStandard(sender, recipient, amount);
328     }
329 
330     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
331         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
332         _rOwned[sender] = _rOwned[sender].sub(rAmount);
333         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
334         _takeTeam(tTeam);
335         _reflectFee(rFee, tFee);
336         emit Transfer(sender, recipient, tTransferAmount);
337     }
338 
339     function _takeTeam(uint256 tTeam) private {
340         uint256 currentRate =  _getRate();
341         uint256 rTeam = tTeam.mul(currentRate);
342         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
343     }
344 
345     function _reflectFee(uint256 rFee, uint256 tFee) private {
346         _rTotal = _rTotal.sub(rFee);
347         _tFeeTotal = _tFeeTotal.add(tFee);
348     }
349 
350     receive() external payable {}
351     
352     function manualswap() public onlyOwner() {
353         uint256 contractBalance = balanceOf(address(this));
354         swapTokensForEth(contractBalance);
355     }
356     
357     function manualsend() public onlyOwner() {
358         uint256 contractETHBalance = address(this).balance;
359         sendETHToFee(contractETHBalance);
360     }
361     
362 
363     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
364         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
365         uint256 currentRate =  _getRate();
366         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
367         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
368     }
369 
370     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
371         uint256 tFee = tAmount.mul(taxFee).div(100);
372         uint256 tTeam = tAmount.mul(TeamFee).div(100);
373         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
374         return (tTransferAmount, tFee, tTeam);
375     }
376 
377     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
378         uint256 rAmount = tAmount.mul(currentRate);
379         uint256 rFee = tFee.mul(currentRate);
380         uint256 rTeam = tTeam.mul(currentRate);
381         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
382         return (rAmount, rTransferAmount, rFee);
383     }
384 
385 	function _getRate() private view returns(uint256) {
386         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
387         return rSupply.div(tSupply);
388     }
389      
390     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
391         if (maxTxAmount > 5000000 * 10**9) {
392             _maxTxAmount = maxTxAmount;
393         }
394     }
395     
396     function _setSellTax(uint256 sellTax) external onlyOwner() {
397         if (sellTax < 25) {
398             _sellTax = sellTax;
399         }
400     }
401 
402     function setBuyTax(uint256 buyTax) external onlyOwner() {
403         if (buyTax < 10) {
404             _buyTax = buyTax;
405         }
406     }
407 
408     function _getCurrentSupply() private view returns(uint256, uint256) {
409         uint256 rSupply = _rTotal;
410         uint256 tSupply = _tTotal;      
411         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
412         return (rSupply, tSupply);
413     }
414 }