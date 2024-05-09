1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-29
3 */
4 
5 /** 
6  * HAYFEVER: PROMOTIONAL GAMING PLATFORM FOR CRYPTO
7  * 
8  * SPDX-License-Identifier: Unlicensed
9  * */
10 
11 pragma solidity ^0.8.4;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     address private _previousOwner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }  
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract HAYFEVER is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _rOwned;
122     mapping (address => uint256) private _tOwned;
123     mapping (address => uint256) private _buyMap;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     mapping (address => uint) private cooldown;
128     uint256 private constant MAX = ~uint256(0);
129     uint256 private constant _tTotal = 1e12 * 10**9;
130     uint256 private _rTotal = (MAX - (MAX % _tTotal));
131     uint256 private _tFeeTotal;
132     
133     uint256 private _feeAddr1;
134     uint256 private _feeAddr2;
135     address payable private _feeAddrWallet1;
136     address payable private _feeAddrWallet2;
137     
138     string private constant _name = "HAYFEVER";
139     string private constant _symbol = "HAY";
140     uint8 private constant _decimals = 9;   
141     
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147     bool private cooldownEnabled = false;
148     uint256 private _maxTxAmount = _tTotal;
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155     constructor () {
156         _feeAddrWallet1 = payable(0xf5e444A954E1691ACA6c07198da10e3eD2b7EA3D);
157         _feeAddrWallet2 = payable(0xFAb12Ce8daEad18BE26f9d326dDBACFc36D857C9);
158         _rOwned[_msgSender()] = _rTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_feeAddrWallet1] = true;
162         _isExcludedFromFee[_feeAddrWallet2] = true;
163         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
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
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181     
182     function originalPurchase(address account) public  view returns (uint256) {
183         return _buyMap[account];
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
210     function setCooldownEnabled(bool onoff) external onlyOwner() {
211         cooldownEnabled = onoff;
212     }
213     
214     function setMaxTx(uint256 maxTransactionAmount) external onlyOwner() {
215         _maxTxAmount = maxTransactionAmount;
216     }
217 
218     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
219         require(rAmount <= _rTotal, "Amount must be less than total reflections");
220         uint256 currentRate =  _getRate();
221         return rAmount.div(currentRate);
222     }
223 
224     function _approve(address owner, address spender, uint256 amount) private {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231     function _transfer(address from, address to, uint256 amount) private {
232         require(from != address(0), "ERC20: transfer from the zero address");
233         require(to != address(0), "ERC20: transfer to the zero address");
234         require(amount > 0, "Transfer amount must be greater than zero");
235     
236         
237         if (!_isBuy(from)) {
238             // TAX SELLERS 12% WHO SELL WITHIN 24 HOURS
239             if (_buyMap[from] != 0 &&
240                 (_buyMap[from] + (24 hours) >= block.timestamp))  {
241                 _feeAddr1 = 1;
242                 _feeAddr2 = 12;
243             } else {
244                 _feeAddr1 = 1;
245                 _feeAddr2 = 5;
246             }
247         } else {
248             if (_buyMap[to] == 0) {
249                 _buyMap[to] = block.timestamp;
250             }
251             _feeAddr1 = 1;
252             _feeAddr2 = 5;
253         }
254         
255         if (from != owner() && to != owner()) {
256             require(!bots[from] && !bots[to]);
257             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
258                 // Cooldown
259                 require(amount <= _maxTxAmount);
260                 require(cooldown[to] < block.timestamp);
261                 cooldown[to] = block.timestamp + (30 seconds);
262             }
263             
264             
265             uint256 contractTokenBalance = balanceOf(address(this));
266             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
267                 swapTokensForEth(contractTokenBalance);
268                 uint256 contractETHBalance = address(this).balance;
269                 if(contractETHBalance > 0) {
270                     sendETHToFee(address(this).balance);
271                 }
272             }
273         }
274 		
275         _tokenTransfer(from,to,amount);
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
293         _feeAddrWallet1.transfer(amount.div(2));
294         _feeAddrWallet2.transfer(amount.div(2));
295     }
296     
297     function openTrading() external onlyOwner() {
298         require(!tradingOpen,"trading is already open");
299         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
300         uniswapV2Router = _uniswapV2Router;
301         _approve(address(this), address(uniswapV2Router), _tTotal);
302         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
303         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
304         swapEnabled = true;
305         cooldownEnabled = true;
306         _maxTxAmount = 10000000000 * 10 ** 9;
307         tradingOpen = true;
308         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
309     }
310     
311     function setBots(address[] memory bots_) public onlyOwner {
312         for (uint i = 0; i < bots_.length; i++) {
313             bots[bots_[i]] = true;
314         }
315     }
316     
317     function removeStrictTxLimit() public onlyOwner {
318         _maxTxAmount = 1e12 * 10**9;
319     }
320     
321     function delBot(address notbot) public onlyOwner {
322         bots[notbot] = false;
323     }
324         
325     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
326         _transferStandard(sender, recipient, amount);
327     }
328 
329     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
330         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
331         _rOwned[sender] = _rOwned[sender].sub(rAmount);
332         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
333         _takeTeam(tTeam);
334         _reflectFee(rFee, tFee);
335         emit Transfer(sender, recipient, tTransferAmount);
336     }
337 
338     function _takeTeam(uint256 tTeam) private {
339         uint256 currentRate =  _getRate();
340         uint256 rTeam = tTeam.mul(currentRate);
341         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
342     }
343     
344     function updateMaxTx (uint256 fee) public onlyOwner {
345         _maxTxAmount = fee;
346     }
347     
348     function _reflectFee(uint256 rFee, uint256 tFee) private {
349         _rTotal = _rTotal.sub(rFee);
350         _tFeeTotal = _tFeeTotal.add(tFee);
351     }
352 
353     receive() external payable {}
354     
355     function manualswap() external {
356         require(_msgSender() == _feeAddrWallet1);
357         uint256 contractBalance = balanceOf(address(this));
358         swapTokensForEth(contractBalance);
359     }
360     
361     function manualsend() external {
362         require(_msgSender() == _feeAddrWallet1);
363         uint256 contractETHBalance = address(this).balance;
364         sendETHToFee(contractETHBalance);
365     }
366     
367 
368     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
369         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
370         uint256 currentRate =  _getRate();
371         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
372         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
373     }
374 
375     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
376         uint256 tFee = tAmount.mul(taxFee).div(100);
377         uint256 tTeam = tAmount.mul(TeamFee).div(100);
378         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
379         return (tTransferAmount, tFee, tTeam);
380     }
381 
382     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
383         uint256 rAmount = tAmount.mul(currentRate);
384         uint256 rFee = tFee.mul(currentRate);
385         uint256 rTeam = tTeam.mul(currentRate);
386         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
387         return (rAmount, rTransferAmount, rFee);
388     }
389 
390     function _isBuy(address _sender) private view returns (bool) {
391         return _sender == uniswapV2Pair;
392     }
393 
394 
395 	function _getRate() private view returns(uint256) {
396         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
397         return rSupply.div(tSupply);
398     }
399 
400     function _getCurrentSupply() private view returns(uint256, uint256) {
401         uint256 rSupply = _rTotal;
402         uint256 tSupply = _tTotal;      
403         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
404         return (rSupply, tSupply);
405     }
406 }