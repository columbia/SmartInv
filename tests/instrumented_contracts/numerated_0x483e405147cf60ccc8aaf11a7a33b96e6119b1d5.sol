1 /*
2 SPDX-License-Identifier: Mines™®©
3 */
4 
5 
6 
7 pragma solidity ^0.8.4;
8 
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
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     address private _previousOwner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor() {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 }
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint256 amountIn,
96         uint256 amountOutMin,
97         address[] calldata path,
98         address to,
99         uint256 deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103     function addLiquidityETH(
104         address token,
105         uint256 amountTokenDesired,
106         uint256 amountTokenMin,
107         uint256 amountETHMin,
108         address to,
109         uint256 deadline
110     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
111 }
112 
113 contract MetaFox is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     string private constant _name = unicode"MetaFox";
116     string private constant _symbol = "METAFOX";
117     uint8 private constant _decimals = 9;
118     mapping(address => uint256) private _rOwned;
119     mapping(address => uint256) private _tOwned;
120     mapping(address => mapping(address => uint256)) private _allowances;
121     mapping(address => bool) private _isExcludedFromFee;
122     uint256 private constant MAX = ~uint256(0);
123     uint256 private constant _tTotal = 1000000000000 * 10**9;
124     uint256 private _rTotal = (MAX - (MAX % _tTotal));
125     uint256 private _tFeeTotal;
126     uint256 private _taxFee = 7;
127     uint256 private _teamFee = 6;
128     mapping(address => bool) private bots;
129     mapping(address => uint256) private buycooldown;
130     mapping(address => uint256) private sellcooldown;
131     mapping(address => uint256) private firstsell;
132     mapping(address => uint256) private sellnumber;
133     address payable private _teamAddress;
134     address payable private _marketingFunds;
135     IUniswapV2Router02 private uniswapV2Router;
136     address private uniswapV2Pair;
137     bool private tradingOpen = false;
138     bool private liquidityAdded = false;
139     bool private inSwap = false;
140     bool private swapEnabled = false;
141     bool private cooldownEnabled = false;
142     uint256 private _maxTxAmount = _tTotal;
143     event MaxTxAmountUpdated(uint256 _maxTxAmount);
144     modifier lockTheSwap {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149     constructor(address payable addr1, address payable addr2) {
150         _teamAddress = addr1;
151         _marketingFunds = addr2;
152         _rOwned[_msgSender()] = _rTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_teamAddress] = true;
156         _isExcludedFromFee[_marketingFunds] = true;
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
196         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function setCooldownEnabled(bool onoff) external onlyOwner() {
201         cooldownEnabled = onoff;
202     }
203 
204     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
205         require(rAmount <= _rTotal,"Amount must be less than total reflections");
206         uint256 currentRate = _getRate();
207         return rAmount.div(currentRate);
208     }
209     
210     function removeAllFee() private {
211         if (_taxFee == 0 && _teamFee == 0) return;
212         _taxFee = 0;
213         _teamFee = 0;
214     }
215 
216     function restoreAllFee() private {
217         _taxFee = 7;
218         _teamFee = 6;
219     }
220     
221     function setFee(uint256 multiplier) private {
222         _taxFee = _taxFee * multiplier;
223         if (multiplier > 1) {
224             _teamFee = 10;
225         }
226         
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _transfer(address from, address to, uint256 amount) private {
237         require(from != address(0), "ERC20: transfer from the zero address");
238         require(to != address(0), "ERC20: transfer to the zero address");
239         require(amount > 0, "Transfer amount must be greater than zero");
240 
241         if (from != owner() && to != owner()) {
242             if (cooldownEnabled) {
243                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
244                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
245                 }
246             }
247             require(!bots[from] && !bots[to]);
248             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
249                 require(tradingOpen);
250                 require(amount <= _maxTxAmount);
251                 require(buycooldown[to] < block.timestamp);
252                 buycooldown[to] = block.timestamp + (30 seconds);
253                 _teamFee = 6;
254                 _taxFee = 2;
255             }
256             uint256 contractTokenBalance = balanceOf(address(this));
257             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
258                 require(amount <= balanceOf(uniswapV2Pair).mul(3).div(100) && amount <= _maxTxAmount);
259                 require(sellcooldown[from] < block.timestamp);
260                 if(firstsell[from] + (1 days) < block.timestamp){
261                     sellnumber[from] = 0;
262                 }
263                 if (sellnumber[from] == 0) {
264                     sellnumber[from]++;
265                     firstsell[from] = block.timestamp;
266                     sellcooldown[from] = block.timestamp + (1 hours);
267                 }
268                 else if (sellnumber[from] == 1) {
269                     sellnumber[from]++;
270                     sellcooldown[from] = block.timestamp + (2 hours);
271                 }
272                 else if (sellnumber[from] == 2) {
273                     sellnumber[from]++;
274                     sellcooldown[from] = block.timestamp + (6 hours);
275                 }
276                 else if (sellnumber[from] == 3) {
277                     sellnumber[from]++;
278                     sellcooldown[from] = firstsell[from] + (1 days);
279                 }
280                 swapTokensForEth(contractTokenBalance);
281                 uint256 contractETHBalance = address(this).balance;
282                 if (contractETHBalance > 0) {
283                     sendETHToFee(address(this).balance);
284                 }
285                 setFee(sellnumber[from]);
286             }
287         }
288         bool takeFee = true;
289 
290         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
291             takeFee = false;
292         }
293 
294         _tokenTransfer(from, to, amount, takeFee);
295         restoreAllFee;
296     }
297 
298     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
299         address[] memory path = new address[](2);
300         path[0] = address(this);
301         path[1] = uniswapV2Router.WETH();
302         _approve(address(this), address(uniswapV2Router), tokenAmount);
303         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
304     }
305 
306     function sendETHToFee(uint256 amount) private {
307         _teamAddress.transfer(amount.div(2));
308         _marketingFunds.transfer(amount.div(2));
309     }
310     
311     function openTrading() public onlyOwner {
312         require(liquidityAdded);
313         tradingOpen = true;
314     }
315 
316     function addLiquidity() external onlyOwner() {
317         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
318         uniswapV2Router = _uniswapV2Router;
319         _approve(address(this), address(uniswapV2Router), _tTotal);
320         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
321         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
322         swapEnabled = true;
323         cooldownEnabled = true;
324         liquidityAdded = true;
325         _maxTxAmount = 3000000000 * 10**9;
326         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
327     }
328 
329     function manualswap() external {
330         require(_msgSender() == _teamAddress);
331         uint256 contractBalance = balanceOf(address(this));
332         swapTokensForEth(contractBalance);
333     }
334 
335     function manualsend() external {
336         require(_msgSender() == _teamAddress);
337         uint256 contractETHBalance = address(this).balance;
338         sendETHToFee(contractETHBalance);
339     }
340 
341     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
342         if (!takeFee) removeAllFee();
343         _transferStandard(sender, recipient, amount);
344         if (!takeFee) restoreAllFee();
345     }
346 
347     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
348         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
349         _rOwned[sender] = _rOwned[sender].sub(rAmount);
350         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
351         _takeTeam(tTeam);
352         _reflectFee(rFee, tFee);
353         emit Transfer(sender, recipient, tTransferAmount);
354     }
355 
356     function _takeTeam(uint256 tTeam) private {
357         uint256 currentRate = _getRate();
358         uint256 rTeam = tTeam.mul(currentRate);
359         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
360     }
361 
362     function _reflectFee(uint256 rFee, uint256 tFee) private {
363         _rTotal = _rTotal.sub(rFee);
364         _tFeeTotal = _tFeeTotal.add(tFee);
365     }
366 
367     receive() external payable {}
368 
369     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
370         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
371         uint256 currentRate = _getRate();
372         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
373         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
374     }
375 
376     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
377         uint256 tFee = tAmount.mul(taxFee).div(100);
378         uint256 tTeam = tAmount.mul(teamFee).div(100);
379         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
380         return (tTransferAmount, tFee, tTeam);
381     }
382 
383     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
384         uint256 rAmount = tAmount.mul(currentRate);
385         uint256 rFee = tFee.mul(currentRate);
386         uint256 rTeam = tTeam.mul(currentRate);
387         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
388         return (rAmount, rTransferAmount, rFee);
389     }
390 
391     function _getRate() private view returns (uint256) {
392         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
393         return rSupply.div(tSupply);
394     }
395 
396     function _getCurrentSupply() private view returns (uint256, uint256) {
397         uint256 rSupply = _rTotal;
398         uint256 tSupply = _tTotal;
399         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
400         return (rSupply, tSupply);
401     }
402 
403     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
404         require(maxTxPercent > 0, "Amount must be greater than 0");
405         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
406         emit MaxTxAmountUpdated(_maxTxAmount);
407     }
408 }