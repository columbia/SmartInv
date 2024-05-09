1 /*
2 To all the degens that missed out on MYOBU, this is your chance to redeem yourself! Lock + Renounce
3 
4 https://t.me/SeishinFox
5 
6 http://seishinfox.io
7 
8 
9 Token Information
10 1. 1,000,000,000,000 Total Supply
11 3. Developer provides LP
12 4. Fair launch for everyone! 
13 5. 0,2% transaction limit on launch
14 6. Buy limit lifted after launch
15 7. Sells limited to 3% of the Liquidity Pool, <2.9% price impact 
16 8. Sell cooldown increases on consecutive sells, 4 sells within a 4 hours period are allowed, refreshes every 24hrs.
17 9. 2% redistribution to holders on all buys
18 10. 7% redistribution to holders on the first sell, increases 2x, 3x, 4x on consecutive sells
19 11. Redistribution actually works!
20 12. 5-6% developer fee split within the team
21 
22 SPDX-License-Identifier: Mines™®©
23 */
24 
25 
26 
27 pragma solidity ^0.8.4;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37     function balanceOf(address account) external view returns (uint256);
38     function transfer(address recipient, uint256 amount) external returns (bool);
39     function allowance(address owner, address spender) external view returns (uint256);
40     function approve(address spender, uint256 amount) external returns (bool);
41     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         return c;
80     }
81 }
82 
83 contract Ownable is Context {
84     address private _owner;
85     address private _previousOwner;
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     constructor() {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     modifier onlyOwner() {
99         require(_owner == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     function renounceOwnership() public virtual onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 }
108 
109 interface IUniswapV2Factory {
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 }
112 
113 interface IUniswapV2Router02 {
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint256 amountIn,
116         uint256 amountOutMin,
117         address[] calldata path,
118         address to,
119         uint256 deadline
120     ) external;
121     function factory() external pure returns (address);
122     function WETH() external pure returns (address);
123     function addLiquidityETH(
124         address token,
125         uint256 amountTokenDesired,
126         uint256 amountTokenMin,
127         uint256 amountETHMin,
128         address to,
129         uint256 deadline
130     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
131 }
132 
133 contract Seishin is Context, IERC20, Ownable {
134     using SafeMath for uint256;
135     string private constant _name = unicode"Seishin";
136     string private constant _symbol = "SEISHIN";
137     uint8 private constant _decimals = 9;
138     mapping(address => uint256) private _rOwned;
139     mapping(address => uint256) private _tOwned;
140     mapping(address => mapping(address => uint256)) private _allowances;
141     mapping(address => bool) private _isExcludedFromFee;
142     uint256 private constant MAX = ~uint256(0);
143     uint256 private constant _tTotal = 1000000000000 * 10**9;
144     uint256 private _rTotal = (MAX - (MAX % _tTotal));
145     uint256 private _tFeeTotal;
146     uint256 private _taxFee = 7;
147     uint256 private _teamFee = 5;
148     mapping(address => bool) private bots;
149     mapping(address => uint256) private buycooldown;
150     mapping(address => uint256) private sellcooldown;
151     mapping(address => uint256) private firstsell;
152     mapping(address => uint256) private sellnumber;
153     address payable private _teamAddress;
154     address payable private _marketingFunds;
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool private tradingOpen = false;
158     bool private liquidityAdded = false;
159     bool private inSwap = false;
160     bool private swapEnabled = false;
161     bool private cooldownEnabled = false;
162     uint256 private _maxTxAmount = _tTotal;
163     event MaxTxAmountUpdated(uint256 _maxTxAmount);
164     modifier lockTheSwap {
165         inSwap = true;
166         _;
167         inSwap = false;
168     }
169     constructor(address payable addr1, address payable addr2) {
170         _teamAddress = addr1;
171         _marketingFunds = addr2;
172         _rOwned[_msgSender()] = _rTotal;
173         _isExcludedFromFee[owner()] = true;
174         _isExcludedFromFee[address(this)] = true;
175         _isExcludedFromFee[_teamAddress] = true;
176         _isExcludedFromFee[_marketingFunds] = true;
177         emit Transfer(address(0), _msgSender(), _tTotal);
178     }
179 
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public pure returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public pure returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public pure override returns (uint256) {
193         return _tTotal;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return tokenFromReflection(_rOwned[account]);
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219 
220     function setCooldownEnabled(bool onoff) external onlyOwner() {
221         cooldownEnabled = onoff;
222     }
223 
224     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
225         require(rAmount <= _rTotal,"Amount must be less than total reflections");
226         uint256 currentRate = _getRate();
227         return rAmount.div(currentRate);
228     }
229     
230     function removeAllFee() private {
231         if (_taxFee == 0 && _teamFee == 0) return;
232         _taxFee = 0;
233         _teamFee = 0;
234     }
235 
236     function restoreAllFee() private {
237         _taxFee = 7;
238         _teamFee = 5;
239     }
240     
241     function setFee(uint256 multiplier) private {
242         _taxFee = _taxFee * multiplier;
243         if (multiplier > 1) {
244             _teamFee = 10;
245         }
246         
247     }
248 
249     function _approve(address owner, address spender, uint256 amount) private {
250         require(owner != address(0), "ERC20: approve from the zero address");
251         require(spender != address(0), "ERC20: approve to the zero address");
252         _allowances[owner][spender] = amount;
253         emit Approval(owner, spender, amount);
254     }
255 
256     function _transfer(address from, address to, uint256 amount) private {
257         require(from != address(0), "ERC20: transfer from the zero address");
258         require(to != address(0), "ERC20: transfer to the zero address");
259         require(amount > 0, "Transfer amount must be greater than zero");
260 
261         if (from != owner() && to != owner()) {
262             if (cooldownEnabled) {
263                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
264                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
265                 }
266             }
267             require(!bots[from] && !bots[to]);
268             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
269                 require(tradingOpen);
270                 require(amount <= _maxTxAmount);
271                 require(buycooldown[to] < block.timestamp);
272                 buycooldown[to] = block.timestamp + (30 seconds);
273                 _teamFee = 6;
274                 _taxFee = 2;
275             }
276             uint256 contractTokenBalance = balanceOf(address(this));
277             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
278                 require(amount <= balanceOf(uniswapV2Pair).mul(3).div(100) && amount <= _maxTxAmount);
279                 require(sellcooldown[from] < block.timestamp);
280                 if(firstsell[from] + (1 days) < block.timestamp){
281                     sellnumber[from] = 0;
282                 }
283                 if (sellnumber[from] == 0) {
284                     sellnumber[from]++;
285                     firstsell[from] = block.timestamp;
286                     sellcooldown[from] = block.timestamp + (1 hours);
287                 }
288                 else if (sellnumber[from] == 1) {
289                     sellnumber[from]++;
290                     sellcooldown[from] = block.timestamp + (2 hours);
291                 }
292                 else if (sellnumber[from] == 2) {
293                     sellnumber[from]++;
294                     sellcooldown[from] = block.timestamp + (3 hours);
295                 }
296                 else if (sellnumber[from] == 3) {
297                     sellnumber[from]++;
298                     sellcooldown[from] = firstsell[from] + (1 days);
299                 }
300                 swapTokensForEth(contractTokenBalance);
301                 uint256 contractETHBalance = address(this).balance;
302                 if (contractETHBalance > 0) {
303                     sendETHToFee(address(this).balance);
304                 }
305                 setFee(sellnumber[from]);
306             }
307         }
308         bool takeFee = true;
309 
310         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
311             takeFee = false;
312         }
313 
314         _tokenTransfer(from, to, amount, takeFee);
315         restoreAllFee;
316     }
317 
318     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
319         address[] memory path = new address[](2);
320         path[0] = address(this);
321         path[1] = uniswapV2Router.WETH();
322         _approve(address(this), address(uniswapV2Router), tokenAmount);
323         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
324     }
325 
326     function sendETHToFee(uint256 amount) private {
327         _teamAddress.transfer(amount.div(2));
328         _marketingFunds.transfer(amount.div(2));
329     }
330     
331     function openTrading() public onlyOwner {
332         require(liquidityAdded);
333         tradingOpen = true;
334     }
335 
336     function addLiquidity() external onlyOwner() {
337         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
338         uniswapV2Router = _uniswapV2Router;
339         _approve(address(this), address(uniswapV2Router), _tTotal);
340         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
341         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
342         swapEnabled = true;
343         cooldownEnabled = true;
344         liquidityAdded = true;
345         _maxTxAmount = 3000000000 * 10**9;
346         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
347     }
348 
349     function manualswap() external {
350         require(_msgSender() == _teamAddress);
351         uint256 contractBalance = balanceOf(address(this));
352         swapTokensForEth(contractBalance);
353     }
354 
355     function manualsend() external {
356         require(_msgSender() == _teamAddress);
357         uint256 contractETHBalance = address(this).balance;
358         sendETHToFee(contractETHBalance);
359     }
360 
361     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
362         if (!takeFee) removeAllFee();
363         _transferStandard(sender, recipient, amount);
364         if (!takeFee) restoreAllFee();
365     }
366 
367     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
368         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
369         _rOwned[sender] = _rOwned[sender].sub(rAmount);
370         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
371         _takeTeam(tTeam);
372         _reflectFee(rFee, tFee);
373         emit Transfer(sender, recipient, tTransferAmount);
374     }
375 
376     function _takeTeam(uint256 tTeam) private {
377         uint256 currentRate = _getRate();
378         uint256 rTeam = tTeam.mul(currentRate);
379         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
380     }
381 
382     function _reflectFee(uint256 rFee, uint256 tFee) private {
383         _rTotal = _rTotal.sub(rFee);
384         _tFeeTotal = _tFeeTotal.add(tFee);
385     }
386 
387     receive() external payable {}
388 
389     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
390         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
391         uint256 currentRate = _getRate();
392         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
393         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
394     }
395 
396     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
397         uint256 tFee = tAmount.mul(taxFee).div(100);
398         uint256 tTeam = tAmount.mul(teamFee).div(100);
399         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
400         return (tTransferAmount, tFee, tTeam);
401     }
402 
403     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
404         uint256 rAmount = tAmount.mul(currentRate);
405         uint256 rFee = tFee.mul(currentRate);
406         uint256 rTeam = tTeam.mul(currentRate);
407         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
408         return (rAmount, rTransferAmount, rFee);
409     }
410 
411     function _getRate() private view returns (uint256) {
412         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
413         return rSupply.div(tSupply);
414     }
415 
416     function _getCurrentSupply() private view returns (uint256, uint256) {
417         uint256 rSupply = _rTotal;
418         uint256 tSupply = _tTotal;
419         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
420         return (rSupply, tSupply);
421     }
422 
423     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
424         require(maxTxPercent > 0, "Amount must be greater than 0");
425         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
426         emit MaxTxAmountUpdated(_maxTxAmount);
427     }
428 }