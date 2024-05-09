1 // SPDX-License-Identifier: Unlicensed
2 //
3 // https://twitter.com/nodesquared
4 //
5 //
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
61 
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     address private _previousOwner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }  
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 
115 contract NodeSquared is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _rOwned;
118     mapping (address => uint256) private _tOwned;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) private bots;
122     mapping (address => uint) private cooldown;
123     uint256 private constant MAX = ~uint256(0);
124     uint256 private constant _tTotal = 1e7 * 10**9;
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126     uint256 private _tFeeTotal;
127     
128     uint256 private _feeAddr1 = 2;
129     uint256 private _previousFeeAddr1 = _feeAddr1;
130     uint256 private _feeAddr2 = 10;
131     uint256 private _previousFeeAddr2 = _feeAddr2;
132     address payable private _feeAddrWallet1;
133     address payable private _feeAddrWallet2;
134     
135     string private constant _name = "Node Squared";
136     string private constant _symbol = "N2";
137     uint8 private constant _decimals = 9;
138     
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
152     constructor () {
153         _feeAddrWallet1 = payable(0xBd74Ac0F706EE32175b8515Cb9444CBA95F55326);
154         _feeAddrWallet2 = payable(0xBd74Ac0F706EE32175b8515Cb9444CBA95F55326);
155         _rOwned[_msgSender()] = _rTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_feeAddrWallet1] = true;
159         _isExcludedFromFee[_feeAddrWallet2] = true;
160         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
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
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224         bool takeFee = false;
225         if (from != owner() && to != owner()) {
226             require(!bots[from] && !bots[to]);
227             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
228                 // Cooldown
229                 require(amount <= _maxTxAmount);
230                 require(cooldown[to] < block.timestamp);
231                 cooldown[to] = block.timestamp + (30 seconds);
232                 takeFee = true;
233             }
234             
235             
236             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
237                 takeFee = true;
238             }
239             uint256 contractTokenBalance = balanceOf(address(this));
240             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
241                 swapTokensForEth(contractTokenBalance);
242                 uint256 contractETHBalance = address(this).balance;
243                 if(contractETHBalance > 0) {
244                     sendETHToFee(address(this).balance);
245                 }
246             }
247         }
248 		
249         _tokenTransfer(from,to,amount,takeFee);
250     }
251 
252     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
253         address[] memory path = new address[](2);
254         path[0] = address(this);
255         path[1] = uniswapV2Router.WETH();
256         _approve(address(this), address(uniswapV2Router), tokenAmount);
257         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
258             tokenAmount,
259             0,
260             path,
261             address(this),
262             block.timestamp
263         );
264     }
265         
266     function sendETHToFee(uint256 amount) private {
267         _feeAddrWallet1.transfer(amount.div(2));
268         _feeAddrWallet2.transfer(amount.div(2));
269     }
270     
271     function openTrading() external onlyOwner() {
272         require(!tradingOpen,"trading is already open");
273         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
274         uniswapV2Router = _uniswapV2Router;
275         _approve(address(this), address(uniswapV2Router), _tTotal);
276         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
277         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
278         swapEnabled = true;
279         cooldownEnabled = true;
280         _maxTxAmount = 1e7 * 10**9;
281         tradingOpen = true;
282         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
283     }
284     
285     function setBots(address[] memory bots_) public onlyOwner {
286         for (uint i = 0; i < bots_.length; i++) {
287             bots[bots_[i]] = true;
288         }
289     }
290     
291     function removeStrictTxLimit() public onlyOwner {
292         _maxTxAmount = 1e7 * 10**9;
293     }
294     
295     function delBot(address notbot) public onlyOwner {
296         bots[notbot] = false;
297     }
298         
299     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
300         if(!takeFee) {
301             removeAllFee();
302         }
303         
304         _transferStandard(sender, recipient, amount);
305         
306         if(!takeFee) {
307             restoreAllFee();
308         }
309     }
310 
311     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
312         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
313         _rOwned[sender] = _rOwned[sender].sub(rAmount);
314         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
315         _takeTeam(tTeam);
316         _reflectFee(rFee, tFee);
317         emit Transfer(sender, recipient, tTransferAmount);
318     }
319 
320     function _takeTeam(uint256 tTeam) private {
321         uint256 currentRate =  _getRate();
322         uint256 rTeam = tTeam.mul(currentRate);
323         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
324     }
325 
326     function _reflectFee(uint256 rFee, uint256 tFee) private {
327         _rTotal = _rTotal.sub(rFee);
328         _tFeeTotal = _tFeeTotal.add(tFee);
329     }
330 
331     receive() external payable {}
332     
333     function manualswap() external {
334         require(_msgSender() == _feeAddrWallet1);
335         uint256 contractBalance = balanceOf(address(this));
336         swapTokensForEth(contractBalance);
337     }
338     
339     function manualsend() external {
340         require(_msgSender() == _feeAddrWallet1);
341         uint256 contractETHBalance = address(this).balance;
342         sendETHToFee(contractETHBalance);
343     }
344     
345 
346     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
347         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
348         uint256 currentRate =  _getRate();
349         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
350         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
351     }
352 
353     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
354         uint256 tFee = tAmount.mul(taxFee).div(100);
355         uint256 tTeam = tAmount.mul(TeamFee).div(100);
356         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
357         return (tTransferAmount, tFee, tTeam);
358     }
359 
360     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
361         uint256 rAmount = tAmount.mul(currentRate);
362         uint256 rFee = tFee.mul(currentRate);
363         uint256 rTeam = tTeam.mul(currentRate);
364         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
365         return (rAmount, rTransferAmount, rFee);
366     }
367 
368 	function _getRate() private view returns(uint256) {
369         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
370         return rSupply.div(tSupply);
371     }
372 
373     function _getCurrentSupply() private view returns(uint256, uint256) {
374         uint256 rSupply = _rTotal;
375         uint256 tSupply = _tTotal;      
376         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
377         return (rSupply, tSupply);
378     }
379 
380     function excludeFromFee(address account) public onlyOwner {
381         _isExcludedFromFee[account] = true;
382     }
383     
384     function includeInFee(address account) public onlyOwner {
385         _isExcludedFromFee[account] = false;
386     }
387 
388     function removeAllFee() private {
389         if(_feeAddr1 == 0 && _feeAddr2 == 0) return;
390         
391         _previousFeeAddr1 = _feeAddr1;
392         _previousFeeAddr2 = _feeAddr2;
393         
394         _feeAddr1 = 0;
395         _feeAddr2 = 0;
396     }
397     
398     function restoreAllFee() private {
399         _feeAddr1 = _previousFeeAddr1;
400         _feeAddr2 = _previousFeeAddr2;
401     }
402     
403     function setFeeAddr1(uint256 feeAddr1) external onlyOwner() {
404         require(feeAddr1 <= 10, "FeeAddr1 must be less or equal than 10");
405         _feeAddr1 = feeAddr1;
406     }
407     
408     function setFeeAddr2(uint256 feeAddr2) external onlyOwner() {
409         require(feeAddr2 <= 10, "FeeAddr2 must be less or equal than 10");
410         _feeAddr2 = feeAddr2;
411     }
412 }