1 /**
2  *
3  * UniCat token https://t.me/unicattoken
4  * 
5 */
6 
7 // SPDX-License-Identifier: UNLICENSED 
8 
9 pragma solidity ^0.8.4;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if(a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         return mod(a, b, "SafeMath: modulo by zero");
66     }
67 
68     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b != 0, errorMessage);
70         return a % b;
71     }
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     address private _previousOwner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99 }  
100 
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract UNICAT is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _rOwned;
128     mapping (address => uint256) private _tOwned;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private _bots;
132     uint256 private constant MAX = ~uint256(0);
133     uint256 private constant _tTotal = 1e12 * 10**9;
134     uint256 private _rTotal = (MAX - (MAX % _tTotal));
135     uint256 private _tFeeTotal;
136     
137     string private constant _name = unicode"UniCat Token";
138     string private constant _symbol = unicode"UNICAT";
139     
140     uint8 private constant _decimals = 9;
141     uint256 private _taxFee = 2;
142     uint256 private _teamFee = 6;
143     uint256 private _previousTaxFee = _taxFee;
144     uint256 private _previousteamFee = _teamFee;
145     address payable private _FeeAddress;
146     address payable private _marketingWalletAddress;
147     IUniswapV2Router02 private uniswapV2Router;
148     address private uniswapV2Pair;
149     bool private tradingOpen = false;
150     bool private _noTaxMode = false;
151     bool private inSwap = false;
152     uint256 private walletLimitDuration;
153 
154     modifier lockTheSwap {
155         inSwap = true;
156         _;
157         inSwap = false;
158     }
159         constructor (address payable FeeAddress, address payable marketingWalletAddress) {
160         _FeeAddress = FeeAddress;
161         _marketingWalletAddress = marketingWalletAddress;
162         _rOwned[_msgSender()] = _rTotal;
163         _isExcludedFromFee[owner()] = true;
164         _isExcludedFromFee[address(this)] = true;
165         _isExcludedFromFee[FeeAddress] = true;
166         _isExcludedFromFee[marketingWalletAddress] = true;
167         emit Transfer(address(0), _msgSender(), _tTotal);
168     }
169 
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public pure override returns (uint256) {
183         return _tTotal;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return tokenFromReflection(_rOwned[account]);
188     }
189 
190     function transfer(address recipient, uint256 amount) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(address owner, address spender) public view override returns (uint256) {
196         return _allowances[owner][spender];
197     }
198 
199     function approve(address spender, uint256 amount) public override returns (bool) {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
211         require(rAmount <= _rTotal, "Amount must be less than total reflections");
212         uint256 currentRate =  _getRate();
213         return rAmount.div(currentRate);
214     }
215 
216     function removeAllFee() private {
217         if(_taxFee == 0 && _teamFee == 0) return;
218         _previousTaxFee = _taxFee;
219         _previousteamFee = _teamFee;
220         _taxFee = 0;
221         _teamFee = 0;
222     }
223     
224     function restoreAllFee() private {
225         _taxFee = _previousTaxFee;
226         _teamFee = _previousteamFee;
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
241         if(from != owner() && to != owner()) {
242             
243             require(!_bots[from] && !_bots[to]);
244             
245             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
246                 require(tradingOpen, "Trading not yet enabled.");
247                 
248                 if (walletLimitDuration > block.timestamp) {
249                     uint walletBalance = balanceOf(address(to));
250                     require(amount.add(walletBalance) <= _tTotal.mul(2).div(100));
251                 }
252             }
253             uint256 contractTokenBalance = balanceOf(address(this));
254 
255             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
256                 if(contractTokenBalance > 0) {
257                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(5).div(100)) {
258                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(5).div(100);
259                     }
260                     swapTokensForEth(contractTokenBalance);
261                 }
262                 uint256 contractETHBalance = address(this).balance;
263                 if(contractETHBalance > 0) {
264                     sendETHToFee(address(this).balance);
265                 }
266             }
267         }
268         bool takeFee = true;
269 
270         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || _noTaxMode){
271             takeFee = false;
272         }
273         
274         _tokenTransfer(from,to,amount,takeFee);
275     }
276 
277     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = uniswapV2Router.WETH();
281         _approve(address(this), address(uniswapV2Router), tokenAmount);
282         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
283             tokenAmount,
284             0,
285             path,
286             address(this),
287             block.timestamp
288         );
289     }
290         
291     function sendETHToFee(uint256 amount) private {
292         _FeeAddress.transfer(amount.div(2));
293         _marketingWalletAddress.transfer(amount.div(2));
294     }
295     
296     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
297         if(!takeFee)
298             removeAllFee();
299         _transferStandard(sender, recipient, amount);
300         if(!takeFee)
301             restoreAllFee();
302     }
303 
304     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
305         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
306         _rOwned[sender] = _rOwned[sender].sub(rAmount);
307         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
308 
309         _takeTeam(tTeam);
310         _reflectFee(rFee, tFee);
311         emit Transfer(sender, recipient, tTransferAmount);
312     }
313 
314     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
315         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
316         uint256 currentRate =  _getRate();
317         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
318         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
319     }
320 
321     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
322         uint256 tFee = tAmount.mul(taxFee).div(100);
323         uint256 tTeam = tAmount.mul(TeamFee).div(100);
324         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
325         return (tTransferAmount, tFee, tTeam);
326     }
327 
328     function _getRate() private view returns(uint256) {
329         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
330         return rSupply.div(tSupply);
331     }
332 
333     function _getCurrentSupply() private view returns(uint256, uint256) {
334         uint256 rSupply = _rTotal;
335         uint256 tSupply = _tTotal;
336         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
337         return (rSupply, tSupply);
338     }
339 
340     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
341         uint256 rAmount = tAmount.mul(currentRate);
342         uint256 rFee = tFee.mul(currentRate);
343         uint256 rTeam = tTeam.mul(currentRate);
344         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
345         return (rAmount, rTransferAmount, rFee);
346     }
347 
348     function _takeTeam(uint256 tTeam) private {
349         uint256 currentRate =  _getRate();
350         uint256 rTeam = tTeam.mul(currentRate);
351 
352         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
353     }
354 
355     function _reflectFee(uint256 rFee, uint256 tFee) private {
356         _rTotal = _rTotal.sub(rFee);
357         _tFeeTotal = _tFeeTotal.add(tFee);
358     }
359 
360     receive() external payable {}
361     
362     function openTrading() external onlyOwner() {
363         require(!tradingOpen,"trading is already open");
364         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
365         uniswapV2Router = _uniswapV2Router;
366         _approve(address(this), address(uniswapV2Router), _tTotal);
367         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
368         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
369         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
370         tradingOpen = true;
371         walletLimitDuration = block.timestamp + (60 minutes);
372     }
373     
374     function setMarketingWallet (address payable marketingWalletAddress) external {
375         require(_msgSender() == _FeeAddress);
376         _isExcludedFromFee[_marketingWalletAddress] = false;
377         _marketingWalletAddress = marketingWalletAddress;
378         _isExcludedFromFee[marketingWalletAddress] = true;
379     }
380 
381     function excludeFromFee (address payable ad) external {
382         require(_msgSender() == _FeeAddress);
383         _isExcludedFromFee[ad] = true;
384     }
385     
386     function includeToFee (address payable ad) external {
387         require(_msgSender() == _FeeAddress);
388         _isExcludedFromFee[ad] = false;
389     }
390     
391     function setNoTaxMode(bool onoff) external {
392         require(_msgSender() == _FeeAddress);
393         _noTaxMode = onoff;
394     }
395     
396     function setTeamFee(uint256 team) external {
397         require(_msgSender() == _FeeAddress);
398         require(team <= 6);
399         _teamFee = team;
400     }
401         
402     function setTaxFee(uint256 tax) external {
403         require(_msgSender() == _FeeAddress);
404         require(tax <= 2);
405         _taxFee = tax;
406     }
407     
408     function setBots(address[] memory bots_) public onlyOwner {
409         for (uint i = 0; i < bots_.length; i++) {
410             if (bots_[i] != uniswapV2Pair && bots_[i] != address(uniswapV2Router)) {
411                 _bots[bots_[i]] = true;
412             }
413         }
414     }
415     
416     function delBot(address notbot) public onlyOwner {
417         _bots[notbot] = false;
418     }
419     
420     function isBot(address ad) public view returns (bool) {
421         return _bots[ad];
422     }
423     
424     function manualswap() external {
425         require(_msgSender() == _FeeAddress);
426         uint256 contractBalance = balanceOf(address(this));
427         swapTokensForEth(contractBalance);
428     }
429     
430     function manualsend() external {
431         require(_msgSender() == _FeeAddress);
432         uint256 contractETHBalance = address(this).balance;
433         sendETHToFee(contractETHBalance);
434     }
435 
436     function thisBalance() public view returns (uint) {
437         return balanceOf(address(this));
438     }
439 
440     function amountInPool() public view returns (uint) {
441         return balanceOf(uniswapV2Pair);
442     }
443 }