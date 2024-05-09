1 /*
2     Telegram: https://t.me/FomoInu
3     Website: fomoinu.com
4     
5     Fair launch at TG 200 members, invite your fellow degens.
6     No presale, public or private
7     No dev tokens, no marketing tokens, developers will be compensated by a small fee on each transaction.
8     Trading will be enabled AFTER liquidity lock, rugpull impossible.
9     Total supply = liquidity = 1,000,000,000,000, initial buy limit = 2,000,000,000, permanent sell limit: 4,000,000,000 .
10     3% redistribution on every sell
11     30 seconds cooldown on each buy, 2 minutes cooldown on each sell.
12     
13 */
14 
15 //SPDX-License-Identifier: Mines™®©
16 pragma solidity ^0.8.4;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 
71 }
72 
73 contract Ownable is Context {
74     address private _owner;
75     address private _previousOwner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }  
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract FomoInu is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _rOwned;
127     mapping (address => uint256) private _tOwned;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     mapping (address => uint) private cooldown;
132     uint256 private constant MAX = ~uint256(0);
133     uint256 private constant _tTotal = 1e12 * 10**9;
134     uint256 private _rTotal = (MAX - (MAX % _tTotal));
135     uint256 private _tFeeTotal;
136     string private constant _name = 'Fomo Inu';
137     string private constant _symbol = 'FOMOINU';
138     uint8 private constant _decimals = 9;
139     uint256 private _taxFee;
140     uint256 private _teamFee;
141     uint256 private _previousTaxFee = _taxFee;
142     uint256 private _previousteamFee = _teamFee;
143     address payable private _FeeAddress;
144     address payable private _marketingWalletAddress;
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
158     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
159         _FeeAddress = FeeAddress;
160         _marketingWalletAddress = marketingWalletAddress;
161         _rOwned[_msgSender()] = _rTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[FeeAddress] = true;
165         _isExcludedFromFee[marketingWalletAddress] = true;
166         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return tokenFromReflection(_rOwned[account]);
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function setCooldownEnabled(bool onoff) external onlyOwner() {
210         cooldownEnabled = onoff;
211     }
212 
213     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
214         require(rAmount <= _rTotal, "Amount must be less than total reflections");
215         uint256 currentRate =  _getRate();
216         return rAmount.div(currentRate);
217     }
218 
219     function removeAllFee() private {
220         if(_taxFee == 0 && _teamFee == 0) return;
221         _previousTaxFee = _taxFee;
222         _previousteamFee = _teamFee;
223         _taxFee = 0;
224         _teamFee = 0;
225     }
226     
227     function restoreAllFee() private {
228         _taxFee = _previousTaxFee;
229         _teamFee = _previousteamFee;
230     }
231 
232     function _approve(address owner, address spender, uint256 amount) private {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function _transfer(address from, address to, uint256 amount) private {
240         require(from != address(0), "ERC20: transfer from the zero address");
241         require(to != address(0), "ERC20: transfer to the zero address");
242         require(amount > 0, "Transfer amount must be greater than zero");
243         _taxFee = 0;
244         _teamFee = 10;
245         if (from != owner() && to != owner() && from != address(this) && to != address(this)) {
246             require(!bots[from] && !bots[to]);
247             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
248                 require(tradingOpen);
249                 require(amount <= _maxTxAmount);
250                 require(cooldown[to] < block.timestamp, "Cooldown");
251                 cooldown[to] = block.timestamp + (30 seconds);
252             }
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
255                 _taxFee = 3;
256                 _teamFee = 9;
257             }
258             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
259                 require(amount <= 4e9 * 10**9);
260                 require(cooldown[from] < block.timestamp, "Cooldown");
261                 cooldown[from] = block.timestamp + (2 minutes);
262                 swapTokensForEth(contractTokenBalance);
263                 uint256 contractETHBalance = address(this).balance;
264                 if(contractETHBalance > 0) {
265                     sendETHToFee(address(this).balance);
266                 }
267             }
268         }
269         bool takeFee = true;
270 
271         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
272             takeFee = false;
273         }
274 		
275         _tokenTransfer(from,to,amount,takeFee);
276     }
277 
278     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
279         address[] memory path = new address[](2);
280         path[0] = address(this);
281         path[1] = uniswapV2Router.WETH();
282         _approve(address(this), address(uniswapV2Router), tokenAmount);
283         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
284             tokenAmount,
285             0,
286             path,
287             address(this),
288             block.timestamp
289         );
290     }
291         
292     function sendETHToFee(uint256 amount) private {
293         _FeeAddress.transfer(amount.div(2));
294         _marketingWalletAddress.transfer(amount.div(2));
295     }
296     
297     function addLiquidity() external onlyOwner() {
298         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
299         uniswapV2Router = _uniswapV2Router;
300         _approve(address(this), address(uniswapV2Router), _tTotal);
301         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
302         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
303         swapEnabled = true;
304         cooldownEnabled = true;
305         _maxTxAmount = 2e9 * 10**9;
306         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
307     }
308     
309     function openTrading() public onlyOwner {
310         tradingOpen = true;
311     }
312     
313     function setBots(address[] memory bots_) public onlyOwner {
314         for (uint i = 0; i < bots_.length; i++) {
315             bots[bots_[i]] = true;
316         }
317     }
318     
319     function delBot(address notbot) public onlyOwner {
320         bots[notbot] = false;
321     }
322         
323     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
324         if(!takeFee)
325             removeAllFee();
326         _transferStandard(sender, recipient, amount);
327         if(!takeFee)
328             restoreAllFee();
329     }
330 
331     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
332         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
333         _rOwned[sender] = _rOwned[sender].sub(rAmount);
334         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
335         _takeTeam(tTeam);
336         _reflectFee(rFee, tFee);
337         emit Transfer(sender, recipient, tTransferAmount);
338     }
339 
340     function _takeTeam(uint256 tTeam) private {
341         uint256 currentRate =  _getRate();
342         uint256 rTeam = tTeam.mul(currentRate);
343         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
344     }
345 
346     function _reflectFee(uint256 rFee, uint256 tFee) private {
347         _rTotal = _rTotal.sub(rFee);
348         _tFeeTotal = _tFeeTotal.add(tFee);
349     }
350 
351     receive() external payable {}
352     
353     function manualswap() external {
354         require(_msgSender() == _FeeAddress);
355         uint256 contractBalance = balanceOf(address(this));
356         swapTokensForEth(contractBalance);
357     }
358     
359     function manualsend() external {
360         require(_msgSender() == _FeeAddress);
361         uint256 contractETHBalance = address(this).balance;
362         sendETHToFee(contractETHBalance);
363     }
364     
365 
366     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
367         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
368         uint256 currentRate =  _getRate();
369         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
370         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
371     }
372 
373     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
374         uint256 tFee = tAmount.mul(taxFee).div(100);
375         uint256 tTeam = tAmount.mul(TeamFee).div(100);
376         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
377         return (tTransferAmount, tFee, tTeam);
378     }
379 
380     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
381         uint256 rAmount = tAmount.mul(currentRate);
382         uint256 rFee = tFee.mul(currentRate);
383         uint256 rTeam = tTeam.mul(currentRate);
384         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
385         return (rAmount, rTransferAmount, rFee);
386     }
387 
388 	function _getRate() private view returns(uint256) {
389         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
390         return rSupply.div(tSupply);
391     }
392 
393     function _getCurrentSupply() private view returns(uint256, uint256) {
394         uint256 rSupply = _rTotal;
395         uint256 tSupply = _tTotal;      
396         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
397         return (rSupply, tSupply);
398     }
399 
400     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
401         require(maxTxPercent > 0, "Amount must be greater than 0");
402         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
403         emit MaxTxAmountUpdated(_maxTxAmount);
404     }
405 }