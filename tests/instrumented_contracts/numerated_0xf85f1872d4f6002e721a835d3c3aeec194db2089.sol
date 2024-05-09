1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-26
3 */
4 
5 /** 
6  * DEGEN APE CLUB.
7  * https://t.me/DACETH
8  * 
9  * 
10  * SPDX-License-Identifier: Unlicensed
11  * */
12 
13 pragma solidity ^0.8.4;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     address private _previousOwner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }  
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract DegenApeClub is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _rOwned;
124     mapping (address => uint256) private _tOwned;
125     mapping (address => uint256) private _buyMap;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping (address => bool) private bots;
129     mapping (address => uint) private cooldown;
130     uint256 private constant MAX = ~uint256(0);
131     uint256 private constant _tTotal = 1e12 * 10**9;
132     uint256 private _rTotal = (MAX - (MAX % _tTotal));
133     uint256 private _tFeeTotal;
134     
135     uint256 private _feeAddr1;
136     uint256 private _feeAddr2;
137     address payable private _feeAddrWallet1;
138     address payable private _feeAddrWallet2;
139     
140     string private constant _name = "Degen Ape Club";
141     string private constant _symbol = "DAC";
142     uint8 private constant _decimals = 9;   
143     
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149     bool private cooldownEnabled = false;
150     uint256 private _maxTxAmount = _tTotal;
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157     constructor () {
158         _feeAddrWallet1 = payable(0x34B365C3a98D0ec12A680047FE299aff2a032554);
159         _feeAddrWallet2 = payable(0x34B365C3a98D0ec12A680047FE299aff2a032554);
160         _rOwned[_msgSender()] = _rTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_feeAddrWallet1] = true;
164         _isExcludedFromFee[_feeAddrWallet2] = true;
165         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
166     }
167 
168     function name() public pure returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public pure returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public pure returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public pure override returns (uint256) {
181         return _tTotal;
182     }
183     
184     function originalPurchase(address account) public  view returns (uint256) {
185         return _buyMap[account];
186     }
187 
188     function balanceOf(address account) public view override returns (uint256) {
189         return tokenFromReflection(_rOwned[account]);
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
212     function setCooldownEnabled(bool onoff) external onlyOwner() {
213         cooldownEnabled = onoff;
214     }
215     
216     function setMaxTx(uint256 maxTransactionAmount) external onlyOwner() {
217         _maxTxAmount = maxTransactionAmount;
218     }
219 
220     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
221         require(rAmount <= _rTotal, "Amount must be less than total reflections");
222         uint256 currentRate =  _getRate();
223         return rAmount.div(currentRate);
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
237     
238         
239         if (!_isBuy(from)) {
240             // TAX SELLERS 25% WHO SELL WITHIN 24 HOURS
241             if (_buyMap[from] != 0 &&
242                 (_buyMap[from] + (24 hours) >= block.timestamp))  {
243                 _feeAddr1 = 1;
244                 _feeAddr2 = 25;
245             } else {
246                 _feeAddr1 = 1;
247                 _feeAddr2 = 8;
248             }
249         } else {
250             if (_buyMap[to] == 0) {
251                 _buyMap[to] = block.timestamp;
252             }
253             _feeAddr1 = 1;
254             _feeAddr2 = 8;
255         }
256         
257         if (_isExcludedFromFee[to]) {
258             _feeAddr2 = 0;
259             _feeAddr1 = 0;
260         }
261         
262         if (from != owner() && to != owner()) {
263             require(!bots[from] && !bots[to]);
264             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
265                 // Cooldown
266                 require(amount <= _maxTxAmount);
267                 require(cooldown[to] < block.timestamp);
268                 cooldown[to] = block.timestamp + (30 seconds);
269             }
270             
271             
272             uint256 contractTokenBalance = balanceOf(address(this));
273             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
274                 swapTokensForEth(contractTokenBalance);
275                 uint256 contractETHBalance = address(this).balance;
276                 if(contractETHBalance > 0) {
277                     sendETHToFee(address(this).balance);
278                 }
279             }
280         }
281 		
282         _tokenTransfer(from,to,amount);
283     }
284     
285     function setIsExcluded(address excluded) external onlyOwner {
286         _isExcludedFromFee[excluded] = true;
287     }
288     
289     function setIsNotExcluded(address excluded) external onlyOwner {
290         _isExcludedFromFee[excluded] = false;
291     }
292 
293     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
294         address[] memory path = new address[](2);
295         path[0] = address(this);
296         path[1] = uniswapV2Router.WETH();
297         _approve(address(this), address(uniswapV2Router), tokenAmount);
298         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
299             tokenAmount,
300             0,
301             path,
302             address(this),
303             block.timestamp
304         );
305     }
306         
307     function sendETHToFee(uint256 amount) private {
308         _feeAddrWallet1.transfer(amount.div(2));
309         _feeAddrWallet2.transfer(amount.div(2));
310     }
311     
312     function openTrading() external onlyOwner() {
313         require(!tradingOpen,"trading is already open");
314         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
315         uniswapV2Router = _uniswapV2Router;
316         _approve(address(this), address(uniswapV2Router), _tTotal);
317         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
318         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
319         swapEnabled = true;
320         cooldownEnabled = true;
321         _maxTxAmount = 20000000000 * 10 ** 9;
322         tradingOpen = true;
323         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
324     }
325     
326     function setBots(address[] memory bots_) public onlyOwner {
327         for (uint i = 0; i < bots_.length; i++) {
328             bots[bots_[i]] = true;
329         }
330     }
331     
332     function removeStrictTxLimit() public onlyOwner {
333         _maxTxAmount = 1e12 * 10**9;
334     }
335     
336     function delBot(address notbot) public onlyOwner {
337         bots[notbot] = false;
338     }
339         
340     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
341         _transferStandard(sender, recipient, amount);
342     }
343 
344     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
345         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
346         _rOwned[sender] = _rOwned[sender].sub(rAmount);
347         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
348         _takeTeam(tTeam);
349         _reflectFee(rFee, tFee);
350         emit Transfer(sender, recipient, tTransferAmount);
351     }
352 
353     function _takeTeam(uint256 tTeam) private {
354         uint256 currentRate =  _getRate();
355         uint256 rTeam = tTeam.mul(currentRate);
356         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
357     }
358     
359     function updateMaxTx (uint256 fee) public onlyOwner {
360         _maxTxAmount = fee;
361     }
362     
363     function _reflectFee(uint256 rFee, uint256 tFee) private {
364         _rTotal = _rTotal.sub(rFee);
365         _tFeeTotal = _tFeeTotal.add(tFee);
366     }
367 
368     receive() external payable {}
369     
370     function manualswap() external {
371         require(_msgSender() == _feeAddrWallet1);
372         uint256 contractBalance = balanceOf(address(this));
373         swapTokensForEth(contractBalance);
374     }
375     
376     function manualsend() external {
377         require(_msgSender() == _feeAddrWallet1);
378         uint256 contractETHBalance = address(this).balance;
379         sendETHToFee(contractETHBalance);
380     }
381     
382 
383     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
384         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
385         uint256 currentRate =  _getRate();
386         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
387         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
388     }
389 
390     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
391         uint256 tFee = tAmount.mul(taxFee).div(100);
392         uint256 tTeam = tAmount.mul(TeamFee).div(100);
393         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
394         return (tTransferAmount, tFee, tTeam);
395     }
396 
397     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
398         uint256 rAmount = tAmount.mul(currentRate);
399         uint256 rFee = tFee.mul(currentRate);
400         uint256 rTeam = tTeam.mul(currentRate);
401         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
402         return (rAmount, rTransferAmount, rFee);
403     }
404 
405     function _isBuy(address _sender) private view returns (bool) {
406         return _sender == uniswapV2Pair;
407     }
408 
409 
410 	function _getRate() private view returns(uint256) {
411         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
412         return rSupply.div(tSupply);
413     }
414 
415     function _getCurrentSupply() private view returns(uint256, uint256) {
416         uint256 rSupply = _rTotal;
417         uint256 tSupply = _tTotal;      
418         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
419         return (rSupply, tSupply);
420     }
421 }