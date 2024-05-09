1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.7.0 <0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56 }
57 
58 contract Ownable is Context {
59     address private _owner;
60     address private _previousOwner;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor() {
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
82 }
83 
84 interface IUniswapV2Factory {
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86 }
87 
88 interface IUniswapV2Router02 {
89     function swapExactTokensForETHSupportingFeeOnTransferTokens(
90         uint256 amountIn,
91         uint256 amountOutMin,
92         address[] calldata path,
93         address to,
94         uint256 deadline
95     ) external;
96     function factory() external pure returns (address);
97     function WETH() external pure returns (address);
98     function addLiquidityETH(
99         address token,
100         uint256 amountTokenDesired,
101         uint256 amountTokenMin,
102         uint256 amountETHMin,
103         address to,
104         uint256 deadline
105     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
106 }
107 
108 contract VIRALETHEREUM is Context, IERC20, Ownable {
109     using SafeMath for uint256;
110     string private constant _name = "Viral Ethereum";
111     string private constant _symbol = "eViral \xF0\x9F\xA7\xAC";
112     uint8 private constant _decimals = 9;
113 
114     mapping(address => uint256) private _rOwned;
115     mapping(address => uint256) private _tOwned;    
116     uint256 private constant MAX = ~uint256(0);
117     uint256 private _tTotal = 2718281828459 * 10**9;
118     uint256 private _rTotal = (MAX - (MAX % _tTotal));
119     uint256 private _tFeeTotal;
120     uint256 public _eViralBurned;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123     mapping(address => bool) private _isExcludedFromFee;
124 
125     mapping(address => uint256) private buycooldown;
126     mapping(address => uint256) private sellcooldown;
127     mapping(address => uint256) private firstsell;
128     mapping(address => uint256) private sellnumber;
129 
130     address payable private _teamAddress;
131     address payable private _marketingFunds;
132     address payable private _developmentFunds;
133     IUniswapV2Router02 private uniswapV2Router;
134     address public uniswapV2Pair;
135 
136     bool public tradeAllowed = false;
137     bool private liquidityAdded = false;
138     bool private inSwap = false;
139     bool public swapEnabled = false;
140     bool private cooldownEnabled = false;
141 
142     uint256 private _maxTxAmount = _tTotal;     
143     uint256 private _reflection = 7;
144     uint256 private _teamFee = 7;
145     uint256 private _viralBurn = 1;
146 
147     event MaxTxAmountUpdated(uint256 _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153     constructor(address payable addr1, address payable addr2, address payable addr3) {
154         _teamAddress = addr1;
155         _marketingFunds = addr2;
156         _developmentFunds = addr3;
157         _rOwned[_msgSender()] = _rTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_teamAddress] = true;
161         _isExcludedFromFee[_marketingFunds] = true;
162         _isExcludedFromFee[_developmentFunds] = true;
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
178     function totalSupply() public view override returns (uint256) {
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
202         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function releaseEViral() public onlyOwner {
207         require(liquidityAdded);
208         tradeAllowed = true;
209     }
210 
211     function addLiquidity() external onlyOwner() {
212         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
213         uniswapV2Router = _uniswapV2Router;
214         _approve(address(this), address(uniswapV2Router), _tTotal);
215         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
216         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
217         swapEnabled = true;
218         cooldownEnabled = true;
219         liquidityAdded = true;
220         _maxTxAmount = 8154845485 * 10**9;
221         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
222     }
223 
224     function manualswap() external onlyOwner() {
225         uint256 contractBalance = balanceOf(address(this));
226         swapTokensForEth(contractBalance);
227     }
228 
229     function manualsend() external onlyOwner() {
230         uint256 contractETHBalance = address(this).balance;
231         sendETHToFee(contractETHBalance);
232     }
233 
234     function setCooldownEnabled(bool enable) external onlyOwner() {
235         cooldownEnabled = enable;
236     }
237 
238     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
239         require(maxTxPercent > 0, "Amount must be greater than 0");
240         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
241         emit MaxTxAmountUpdated(_maxTxAmount);
242     }
243 
244     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
245         require(rAmount <= _rTotal,"Amount must be less than total reflections");
246         uint256 currentRate = _getRate();
247         return rAmount.div(currentRate);
248     }
249 
250     function _approve(address owner, address spender, uint256 amount) private {
251         require(owner != address(0), "ERC20: approve from the zero address");
252         require(spender != address(0), "ERC20: approve to the zero address");
253         _allowances[owner][spender] = amount;
254         emit Approval(owner, spender, amount);
255     }
256 
257     function _transfer(address from, address to, uint256 amount) private {
258         require(from != address(0), "ERC20: transfer from the zero address");
259         require(to != address(0), "ERC20: transfer to the zero address");
260         require(amount > 0, "Transfer amount must be greater than zero");
261 
262         if (from != owner() && to != owner()) {
263             if (cooldownEnabled) {
264                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
265                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
266                 }
267             }
268             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
269                 require(tradeAllowed);
270                 require(amount <= _maxTxAmount);
271                 require(buycooldown[to] < block.timestamp);
272                 buycooldown[to] = block.timestamp + (45 seconds);
273                 _teamFee = 7;
274                 _reflection = 3;
275                 _viralBurn = 0;
276             }
277             uint256 contractTokenBalance = balanceOf(address(this));
278             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
279                 require(amount <= balanceOf(uniswapV2Pair).mul(271828).div(10000000) && amount <= _maxTxAmount);
280                 require(sellcooldown[from] < block.timestamp);
281                 if(firstsell[from] + (1 days) < block.timestamp){
282                     sellnumber[from] = 0;
283                 }
284                 if (sellnumber[from] == 0) {
285                     sellnumber[from]++;
286                     firstsell[from] = block.timestamp;
287                     sellcooldown[from] = block.timestamp + (1 hours);
288                 }
289                 else if (sellnumber[from] == 1) {
290                     sellnumber[from]++;
291                     sellcooldown[from] = block.timestamp + (2 hours);
292                 }
293                 else if (sellnumber[from] == 2) {
294                     sellnumber[from]++;
295                     sellcooldown[from] = block.timestamp + (3 hours);
296                 }
297                 else if (sellnumber[from] == 3) {
298                     sellnumber[from]++;
299                     sellcooldown[from] = block.timestamp + (7 hours);
300                 }                          
301                 else if (sellnumber[from] == 4) {
302                     sellnumber[from]++;
303                     sellcooldown[from] = firstsell[from] + (1 days);
304                 }
305                 swapTokensForEth(contractTokenBalance);
306                 uint256 contractETHBalance = address(this).balance;
307                 if (contractETHBalance > 0) {
308                     sendETHToFee(address(this).balance);
309                 }
310                 setFee(sellnumber[from]);
311             }
312         }
313         bool takeFee = true;
314         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
315             takeFee = false;
316         }
317         _tokenTransfer(from, to, amount, takeFee);
318         restoreAllFee;
319     }
320 
321     function removeAllFee() private {
322         if (_reflection == 0 && _teamFee == 0 && _viralBurn == 0) return;
323         _reflection = 0;
324         _teamFee = 0;
325         _viralBurn = 0;
326     }
327 
328     function restoreAllFee() private {
329         _reflection = 7;
330         _teamFee = 7;
331         _viralBurn = 1;
332     }
333     
334     function setFee(uint256 multiplier) private {
335         _reflection = _reflection.mul(multiplier);
336         _viralBurn = _viralBurn.mul(multiplier);
337         _teamFee = 7;        
338     }
339 
340     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
341         if (!takeFee) removeAllFee();
342         _transferStandard(sender, recipient, amount);
343         if (!takeFee) restoreAllFee();
344     }
345     function _transferStandard(address sender, address recipient, uint256 amount) private {
346         (uint256 tAmount, uint256 tBurn) = _viralEthBurn(amount);
347         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount, tBurn);
348         _rOwned[sender] = _rOwned[sender].sub(rAmount);
349         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
350         _takeTeam(tTeam);
351         _reflectFee(rFee, tFee);
352         emit Transfer(sender, recipient, tTransferAmount);
353     }
354 
355     function _takeTeam(uint256 tTeam) private {
356         uint256 currentRate = _getRate();
357         uint256 rTeam = tTeam.mul(currentRate);
358         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
359     }
360 
361     function _viralEthBurn(uint amount) private returns (uint, uint) {  
362         uint orgAmount = amount;
363         uint256 currentRate = _getRate();
364         uint256 tBurn = amount.mul(_viralBurn).div(100);
365         uint256 rBurn = tBurn.mul(currentRate);
366         _tTotal = _tTotal.sub(tBurn);
367         _rTotal = _rTotal.sub(rBurn);
368         _eViralBurned = _eViralBurned.add(tBurn);
369         return (orgAmount, tBurn);
370     }
371     
372     function _reflectFee(uint256 rFee, uint256 tFee) private {
373         _rTotal = _rTotal.sub(rFee);
374         _tFeeTotal = _tFeeTotal.add(tFee);
375     }
376 
377     function _getValues(uint256 tAmount, uint256 tBurn) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
378         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _reflection, _teamFee, tBurn);
379         uint256 currentRate = _getRate();
380         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
381         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
382     }
383 
384     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee, uint256 tBurn) private pure returns (uint256, uint256, uint256) {
385         uint256 tFee = tAmount.mul(taxFee).div(100);
386         uint256 tTeam = tAmount.mul(teamFee).div(100);
387         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam).sub(tBurn);
388         return (tTransferAmount, tFee, tTeam);
389     }
390 
391     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
392         uint256 rAmount = tAmount.mul(currentRate);
393         uint256 rFee = tFee.mul(currentRate);
394         uint256 rTeam = tTeam.mul(currentRate);
395         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
396         return (rAmount, rTransferAmount, rFee);
397     }
398 
399     function _getRate() private view returns (uint256) {
400         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
401         return rSupply.div(tSupply);
402     }
403 
404     function _getCurrentSupply() private view returns (uint256, uint256) {
405         uint256 rSupply = _rTotal;
406         uint256 tSupply = _tTotal;
407         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
408         return (rSupply, tSupply);
409     }
410 
411     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
412         address[] memory path = new address[](2);
413         path[0] = address(this);
414         path[1] = uniswapV2Router.WETH();
415         _approve(address(this), address(uniswapV2Router), tokenAmount);
416         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
417     }
418 
419     function sendETHToFee(uint256 amount) private {
420         _teamAddress.transfer(amount.div(3));
421         _marketingFunds.transfer(amount.div(3));
422         _developmentFunds.transfer(amount.div(3));
423     }
424 
425     receive() external payable {}
426 }