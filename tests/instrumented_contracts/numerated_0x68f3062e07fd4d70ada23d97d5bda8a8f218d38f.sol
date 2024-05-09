1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.10;
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
56 
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         return mod(a, b, "SafeMath: modulo by zero");
59     }
60 
61     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b != 0, errorMessage);
63         return a % b;
64     }
65 }
66 
67 abstract contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor() {
73         _transferOwnership(_msgSender());
74     }
75 
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner() {
86         _transferOwnership(address(0));
87     }
88 
89     function transferOwnership(address newOwner) public virtual onlyOwner() {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
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
115 }
116 
117 contract WITCHERINU is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private _isBot;
125 
126     uint256 private constant _MAX = ~uint256(0);
127     uint256 private constant _tTotal = 1e11 * 10**9;
128     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
129     uint256 private _tFeeTotal;
130     
131     string private constant _name = "Witcher Inu";
132     string private constant _symbol = "WINU";
133     
134     uint private constant _decimals = 9;
135     uint256 private _teamFee = 5;
136     uint256 private _previousteamFee = _teamFee;
137 
138     address payable private _feeAddress;
139 
140     // Uniswap Pair
141     IUniswapV2Router02 private _uniswapV2Router;
142     address private _uniswapV2Pair;
143 
144     bool private _initialized = false;
145     bool private _noTaxMode = false;
146     bool private _inSwap = false;
147     bool private _tradingOpen = false;
148     uint256 private _launchTime;
149     uint256 private _initialLimitDuration;
150 
151     modifier lockTheSwap() {
152         _inSwap = true;
153         _;
154         _inSwap = false;
155     }
156 
157     modifier handleFees(bool takeFee) {
158         if (!takeFee) _removeAllFees();
159         _;
160         if (!takeFee) _restoreAllFees();
161     }
162     
163     constructor () {
164         _rOwned[_msgSender()] = _rTotal;
165 
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[payable(0x000000000000000000000000000000000000dEaD)] = true;
168 
169         emit Transfer(address(0), _msgSender(), _tTotal);
170     }
171 
172     function name() public pure returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public pure returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public pure returns (uint) {
181         return _decimals;
182     }
183 
184     function totalSupply() public pure override returns (uint256) {
185         return _tTotal;
186     }
187 
188     function balanceOf(address account) public view override returns (uint256) {
189         return _tokenFromReflection(_rOwned[account]);
190     }
191 
192     function transfer(address recipient, uint256 amount) public override returns (bool) {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender) public view override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     function approve(address spender, uint256 amount) public override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
207         _transfer(sender, recipient, amount);
208         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
209         return true;
210     }
211 
212     function _tokenFromReflection(uint256 rAmount) private view returns(uint256) {
213         require(rAmount <= _rTotal, "Amount must be less than total reflections");
214         uint256 currentRate =  _getRate();
215         return rAmount.div(currentRate);
216     }
217 
218     function _removeAllFees() private {
219         require(_teamFee > 0);
220 
221         _previousteamFee = _teamFee;
222         _teamFee = 0;
223     }
224     
225     function _restoreAllFees() private {
226         _teamFee = _previousteamFee;
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232 
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236     
237     function _transfer(address from, address to, uint256 amount) private {
238         require(from != address(0), "ERC20: transfer from the zero address");
239         require(to != address(0), "ERC20: transfer to the zero address");
240         require(amount > 0, "Transfer amount must be greater than zero");
241         require(!_isBot[from], "Your address has been marked as a bot, please contact staff to appeal your case.");
242         
243         bool takeFee = false;
244         if (
245             !_isExcludedFromFee[from] 
246             && !_isExcludedFromFee[to] 
247             && !_noTaxMode 
248             && (from == _uniswapV2Pair || to == _uniswapV2Pair)
249         ) {
250             require(_tradingOpen, 'Trading has not yet been opened.');
251             takeFee = true;
252 
253             if (from == _uniswapV2Pair && to != address(_uniswapV2Router) && _initialLimitDuration > block.timestamp) {
254                 uint walletBalance = balanceOf(address(to));
255                 require(amount.add(walletBalance) <= _tTotal.mul(5).div(100));
256             }
257 
258             if (block.timestamp == _launchTime) _isBot[to] = true;
259 
260             uint256 contractTokenBalance = balanceOf(address(this));
261             if (!_inSwap && from != _uniswapV2Pair) {
262                 if (contractTokenBalance > 0) {
263                     if (contractTokenBalance > balanceOf(_uniswapV2Pair).mul(5).div(100))
264                         contractTokenBalance = balanceOf(_uniswapV2Pair).mul(5).div(100);
265                     
266                     _swapTokensForEth(contractTokenBalance);
267                 }
268             }
269         }
270                 
271         _tokenTransfer(from, to, amount, takeFee);
272     }
273 
274     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap() {
275         address[] memory path = new address[](2);
276         path[0] = address(this);
277         path[1] = _uniswapV2Router.WETH();
278         _approve(address(this), address(_uniswapV2Router), tokenAmount);
279         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
280             tokenAmount,
281             0,
282             path,
283             address(this),
284             block.timestamp
285         );
286     }
287 
288     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee) private handleFees(takeFee) {
289         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tTeam) = _getValues(tAmount);
290         _rOwned[sender] = _rOwned[sender].sub(rAmount);
291         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
292 
293         _takeTeam(tTeam);
294         emit Transfer(sender, recipient, tTransferAmount);
295     }
296 
297     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
298         (uint256 tTransferAmount, uint256 tTeam) = _getTValues(tAmount, _teamFee);
299         uint256 currentRate =  _getRate();
300         (uint256 rAmount, uint256 rTransferAmount) = _getRValues(tAmount, tTeam, currentRate);
301         return (rAmount, rTransferAmount, tTransferAmount, tTeam);
302     }
303 
304     function _getTValues(uint256 tAmount, uint256 TeamFee) private pure returns (uint256, uint256) {
305         uint256 tTeam = tAmount.mul(TeamFee).div(100);
306         uint256 tTransferAmount = tAmount.sub(tTeam);
307         return (tTransferAmount, tTeam);
308     }
309 
310     function _getRate() private view returns (uint256) {
311         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
312         return rSupply.div(tSupply);
313     }
314 
315     function _getCurrentSupply() private view returns (uint256, uint256) {
316         uint256 rSupply = _rTotal;
317         uint256 tSupply = _tTotal;
318         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
319         return (rSupply, tSupply);
320     }
321 
322     function _getRValues(uint256 tAmount, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256) {
323         uint256 rAmount = tAmount.mul(currentRate);
324         uint256 rTeam = tTeam.mul(currentRate);
325         uint256 rTransferAmount = rAmount.sub(rTeam);
326         return (rAmount, rTransferAmount);
327     }
328 
329     function _takeTeam(uint256 tTeam) private {
330         uint256 currentRate =  _getRate();
331         uint256 rTeam = tTeam.mul(currentRate);
332 
333         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
334     }
335     
336     function initContract(address payable feeAddress) external onlyOwner() {
337         require(!_initialized,"Contract has already been initialized");
338         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
339         _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
340 
341         _uniswapV2Router = uniswapV2Router;
342 
343         _feeAddress = feeAddress;
344         _isExcludedFromFee[_feeAddress] = true;
345 
346         _initialized = true;
347     }
348 
349     function openTrading() external onlyOwner() {
350         require(_initialized, "Contract must be initialized first");
351         _tradingOpen = true;
352         _launchTime = block.timestamp;
353         _initialLimitDuration = _launchTime + (60 minutes);
354     }
355 
356     function setFeeWallet(address payable feeWalletAddress) external onlyOwner() {
357         _isExcludedFromFee[_feeAddress] = false;
358 
359         _feeAddress = feeWalletAddress;
360         _isExcludedFromFee[_feeAddress] = true;
361     }
362 
363     function excludeFromFee(address payable ad) external onlyOwner() {
364         _isExcludedFromFee[ad] = true;
365     }
366     
367     function includeToFee(address payable ad) external onlyOwner() {
368         _isExcludedFromFee[ad] = false;
369     }
370     
371     function setNoTaxMode(bool onoff) external onlyOwner() {
372         _noTaxMode = onoff;
373     }
374     
375     function setTeamFee(uint256 fee) external onlyOwner() {
376         require(fee <= 10, "Team fee cannot be larger than 10%");
377         _teamFee = fee;
378     }
379     
380     function setBots(address[] memory bots_) public onlyOwner() {
381         for (uint i = 0; i < bots_.length; i++) {
382             if (bots_[i] != _uniswapV2Pair && bots_[i] != address(_uniswapV2Router)) {
383                 _isBot[bots_[i]] = true;
384             }
385         }
386     }
387     
388     function delBots(address[] memory bots_) public onlyOwner() {
389         for (uint i = 0; i < bots_.length; i++) {
390             _isBot[bots_[i]] = false;
391         }
392     }
393     
394     function isBot(address ad) public view returns (bool) {
395         return _isBot[ad];
396     }
397 
398     function isExcludedFromFee(address ad) public view returns (bool) {
399         return _isExcludedFromFee[ad];
400     }
401     
402     function swapFeesManual() external onlyOwner() {
403         uint256 contractBalance = balanceOf(address(this));
404         _swapTokensForEth(contractBalance);
405     }
406     
407     function withdrawFees() external {
408         uint256 contractETHBalance = address(this).balance;
409         _feeAddress.transfer(contractETHBalance);
410     }
411 
412     receive() external payable {}
413 }