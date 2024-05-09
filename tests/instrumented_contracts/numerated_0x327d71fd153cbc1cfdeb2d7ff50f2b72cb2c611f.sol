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
117 contract SYREX is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private _isBot;
125 
126     uint256 private constant _MAX = ~uint256(0);
127     uint256 private constant _tTotal = 1e8 * 10**9;
128     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
129     uint256 private _tFeeTotal;
130     
131     string private constant _name = "Syrex";
132     string private constant _symbol = "SRX";
133     
134     uint private constant _decimals = 9;
135     uint256 private _teamFee = 10;
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
149 
150     modifier lockTheSwap() {
151         _inSwap = true;
152         _;
153         _inSwap = false;
154     }
155 
156     modifier handleFees(bool takeFee) {
157         if (!takeFee) _removeAllFees();
158         _;
159         if (!takeFee) _restoreAllFees();
160     }
161     
162     constructor () {
163         _rOwned[_msgSender()] = _rTotal;
164 
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[payable(0x000000000000000000000000000000000000dEaD)] = true;
167 
168         emit Transfer(address(0), _msgSender(), _tTotal);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return _tokenFromReflection(_rOwned[account]);
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
211     function _tokenFromReflection(uint256 rAmount) private view returns(uint256) {
212         require(rAmount <= _rTotal, "Amount must be less than total reflections");
213         uint256 currentRate =  _getRate();
214         return rAmount.div(currentRate);
215     }
216 
217     function _removeAllFees() private {
218         require(_teamFee > 0);
219 
220         _previousteamFee = _teamFee;
221         _teamFee = 0;
222     }
223     
224     function _restoreAllFees() private {
225         _teamFee = _previousteamFee;
226     }
227 
228     function _approve(address owner, address spender, uint256 amount) private {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231 
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235     
236     function _transfer(address from, address to, uint256 amount) private {
237         require(from != address(0), "ERC20: transfer from the zero address");
238         require(to != address(0), "ERC20: transfer to the zero address");
239         require(amount > 0, "Transfer amount must be greater than zero");
240         require(!_isBot[from], "Your address has been marked as a bot, please contact staff to appeal your case.");
241         
242         bool takeFee = false;
243         if (
244             !_isExcludedFromFee[from] 
245             && !_isExcludedFromFee[to] 
246             && !_noTaxMode 
247             && (from == _uniswapV2Pair || to == _uniswapV2Pair)
248         ) {
249             require(_tradingOpen, 'Trading has not yet been opened.');
250             takeFee = true;
251 
252             if (block.timestamp == _launchTime) _isBot[to] = true;
253 
254             uint256 contractTokenBalance = balanceOf(address(this));
255             if (!_inSwap && from != _uniswapV2Pair) {
256                 if (contractTokenBalance > 0) {
257                     if (contractTokenBalance > balanceOf(_uniswapV2Pair).mul(5).div(100))
258                         contractTokenBalance = balanceOf(_uniswapV2Pair).mul(5).div(100);
259                     
260                     _swapTokensForEth(contractTokenBalance);
261                 }
262             }
263         }
264                 
265         _tokenTransfer(from, to, amount, takeFee);
266     }
267 
268     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap() {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = _uniswapV2Router.WETH();
272         _approve(address(this), address(_uniswapV2Router), tokenAmount);
273         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281 
282     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee) private handleFees(takeFee) {
283         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tTeam) = _getValues(tAmount);
284         _rOwned[sender] = _rOwned[sender].sub(rAmount);
285         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
286 
287         _takeTeam(tTeam);
288         emit Transfer(sender, recipient, tTransferAmount);
289     }
290 
291     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
292         (uint256 tTransferAmount, uint256 tTeam) = _getTValues(tAmount, _teamFee);
293         uint256 currentRate =  _getRate();
294         (uint256 rAmount, uint256 rTransferAmount) = _getRValues(tAmount, tTeam, currentRate);
295         return (rAmount, rTransferAmount, tTransferAmount, tTeam);
296     }
297 
298     function _getTValues(uint256 tAmount, uint256 TeamFee) private pure returns (uint256, uint256) {
299         uint256 tTeam = tAmount.mul(TeamFee).div(100);
300         uint256 tTransferAmount = tAmount.sub(tTeam);
301         return (tTransferAmount, tTeam);
302     }
303 
304     function _getRate() private view returns (uint256) {
305         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
306         return rSupply.div(tSupply);
307     }
308 
309     function _getCurrentSupply() private view returns (uint256, uint256) {
310         uint256 rSupply = _rTotal;
311         uint256 tSupply = _tTotal;
312         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
313         return (rSupply, tSupply);
314     }
315 
316     function _getRValues(uint256 tAmount, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256) {
317         uint256 rAmount = tAmount.mul(currentRate);
318         uint256 rTeam = tTeam.mul(currentRate);
319         uint256 rTransferAmount = rAmount.sub(rTeam);
320         return (rAmount, rTransferAmount);
321     }
322 
323     function _takeTeam(uint256 tTeam) private {
324         uint256 currentRate =  _getRate();
325         uint256 rTeam = tTeam.mul(currentRate);
326 
327         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
328     }
329     
330     function initContract(address payable feeAddress) external onlyOwner() {
331         require(!_initialized,"Contract has already been initialized");
332         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
333         _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
334 
335         _uniswapV2Router = uniswapV2Router;
336 
337         _feeAddress = feeAddress;
338         _isExcludedFromFee[_feeAddress] = true;
339 
340         _initialized = true;
341     }
342 
343     function openTrading() external onlyOwner() {
344         require(_initialized, "Contract must be initialized first");
345         _tradingOpen = true;
346         _launchTime = block.timestamp;
347     }
348 
349     function setFeeWallet(address payable feeWalletAddress) external onlyOwner() {
350         _isExcludedFromFee[_feeAddress] = false;
351 
352         _feeAddress = feeWalletAddress;
353         _isExcludedFromFee[_feeAddress] = true;
354     }
355 
356     function excludeFromFee(address payable ad) external onlyOwner() {
357         _isExcludedFromFee[ad] = true;
358     }
359     
360     function includeToFee(address payable ad) external onlyOwner() {
361         _isExcludedFromFee[ad] = false;
362     }
363     
364     function setNoTaxMode(bool onoff) external onlyOwner() {
365         _noTaxMode = onoff;
366     }
367     
368     function setTeamFee(uint256 fee) external onlyOwner() {
369         require(fee <= 10, "Team fee cannot be larger than 10%");
370         _teamFee = fee;
371     }
372     
373     function setBots(address[] memory bots_) public onlyOwner() {
374         for (uint i = 0; i < bots_.length; i++) {
375             if (bots_[i] != _uniswapV2Pair && bots_[i] != address(_uniswapV2Router)) {
376                 _isBot[bots_[i]] = true;
377             }
378         }
379     }
380     
381     function delBots(address[] memory bots_) public onlyOwner() {
382         for (uint i = 0; i < bots_.length; i++) {
383             _isBot[bots_[i]] = false;
384         }
385     }
386     
387     function isBot(address ad) public view returns (bool) {
388         return _isBot[ad];
389     }
390 
391     function isExcludedFromFee(address ad) public view returns (bool) {
392         return _isExcludedFromFee[ad];
393     }
394     
395     function swapFeesManual() external onlyOwner() {
396         uint256 contractBalance = balanceOf(address(this));
397         _swapTokensForEth(contractBalance);
398     }
399     
400     function withdrawFees() external onlyOwner() {
401         uint256 contractETHBalance = address(this).balance;
402         _feeAddress.transfer(contractETHBalance);
403     }
404 
405     receive() external payable {}
406 }