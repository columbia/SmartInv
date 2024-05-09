1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-23
3 */
4 
5 // $RapInu
6 // Telegram: https://t.me/RapInuToken
7 
8 // SPDX-License-Identifier: Unlicensed
9 
10 pragma solidity ^0.8.4;
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
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     address private _previousOwner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }  
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract RapInu is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping (address => uint) private cooldown;
126     uint256 private constant MAX = ~uint256(0);
127     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
128     uint256 private _rTotal = (MAX - (MAX % _tTotal));
129     uint256 private _tFeeTotal;
130     string private constant _name = "RapInu";
131     string private constant _symbol = "RapInu";
132     uint8 private constant _decimals = 9;
133     uint256 private _taxFee;
134     uint256 private _teamFee;
135     uint256 private _previousTaxFee = _taxFee;
136     uint256 private _previousteamFee = _teamFee;
137     address payable private _FeeAddress;
138     address payable private _marketingWalletAddress;
139     IUniswapV2Router02 private uniswapV2Router;
140     address private uniswapV2Pair;
141     bool private tradingOpen;
142     bool private inSwap = false;
143     bool private swapEnabled = false;
144     bool private cooldownEnabled = false;
145     uint256 private _maxTxAmount = _tTotal;
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152     constructor (address payable addr1, address payable addr2) {
153         _FeeAddress = addr1;
154         _marketingWalletAddress = addr2;
155         _rOwned[_msgSender()] = _rTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_FeeAddress] = true;
159         _isExcludedFromFee[_marketingWalletAddress] = true;
160         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
161     }
162 
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return tokenFromReflection(_rOwned[account]);
181     }
182 
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function setCooldownEnabled(bool onoff) external onlyOwner() {
204         cooldownEnabled = onoff;
205     }
206 
207     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
208         require(rAmount <= _rTotal, "Amount must be less than total reflections");
209         uint256 currentRate =  _getRate();
210         return rAmount.div(currentRate);
211     }
212 
213     function removeAllFee() private {
214         if(_taxFee == 0 && _teamFee == 0) return;
215         _previousTaxFee = _taxFee;
216         _previousteamFee = _teamFee;
217         _taxFee = 0;
218         _teamFee = 0;
219     }
220     
221     function restoreAllFee() private {
222         _taxFee = _previousTaxFee;
223         _teamFee = _previousteamFee;
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
237         _taxFee = 3;
238         _teamFee = 10;
239         if (from != owner() && to != owner()) {
240             require(!bots[from] && !bots[to]);
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
242                 require(amount <= _maxTxAmount);
243                 require(cooldown[to] < block.timestamp);
244                 cooldown[to] = block.timestamp + (30 seconds);
245             }
246             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
247                 _taxFee = 3;
248                 _teamFee = 20;
249             }
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
252                 swapTokensForEth(contractTokenBalance);
253                 uint256 contractETHBalance = address(this).balance;
254                 if(contractETHBalance > 0) {
255                     sendETHToFee(address(this).balance);
256                 }
257             }
258         }
259         bool takeFee = true;
260 
261         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
262             takeFee = false;
263         }
264 		
265         _tokenTransfer(from,to,amount,takeFee);
266     }
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281         
282     function sendETHToFee(uint256 amount) private {
283         _FeeAddress.transfer(amount.div(2));
284         _marketingWalletAddress.transfer(amount.div(2));
285     }
286     
287     function openTrading() external onlyOwner() {
288         require(!tradingOpen,"trading is already open");
289         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
290         uniswapV2Router = _uniswapV2Router;
291         _approve(address(this), address(uniswapV2Router), _tTotal);
292         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
293         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
294         swapEnabled = true;
295         cooldownEnabled = true;
296         _maxTxAmount = 100000000000000000 * 10**9;
297         tradingOpen = true;
298         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
299     }
300     
301     function setBots(address[] memory bots_) public onlyOwner {
302         for (uint i = 0; i < bots_.length; i++) {
303             bots[bots_[i]] = true;
304         }
305     }
306     
307     function delBot(address notbot) public onlyOwner {
308         bots[notbot] = false;
309     }
310         
311     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
312         if(!takeFee)
313             removeAllFee();
314         _transferStandard(sender, recipient, amount);
315         if(!takeFee)
316             restoreAllFee();
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
342         require(_msgSender() == _FeeAddress);
343         uint256 contractBalance = balanceOf(address(this));
344         swapTokensForEth(contractBalance);
345     }
346     
347     function manualsend() external {
348         require(_msgSender() == _FeeAddress);
349         uint256 contractETHBalance = address(this).balance;
350         sendETHToFee(contractETHBalance);
351     }
352     
353 
354     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
355         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
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
387 
388     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
389         require(maxTxPercent > 0, "Amount must be greater than 0");
390         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
391         emit MaxTxAmountUpdated(_maxTxAmount);
392     }
393 }