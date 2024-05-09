1 /** 
2  * https://t.me/KibaInuETH
3  * 
4  * 
5  * SPDX-License-Identifier: Unlicensed
6  * */
7 
8 pragma solidity ^0.8.4;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     address private _previousOwner;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90 }  
91 
92 interface IUniswapV2Factory {
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114 }
115 
116 contract KibaInu is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _rOwned;
119     mapping (address => uint256) private _tOwned;
120     mapping (address => uint256) private _buyMap;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping (address => uint) private cooldown;
125     uint256 private constant MAX = ~uint256(0);
126     uint256 private constant _tTotal = 1e12 * 10**9;
127     uint256 private _rTotal = (MAX - (MAX % _tTotal));
128     uint256 private _tFeeTotal;
129     
130     uint256 private _feeAddr1;
131     uint256 private _feeAddr2;
132     address payable private _feeAddrWallet1;
133     address payable private _feeAddrWallet2;
134     
135     string private constant _name = "Kiba Inu";
136     string private constant _symbol = "KIBA";
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
153         _feeAddrWallet1 = payable(0x001da4f27b8e5B75AA5621a77307cf0BC6d98381);
154         _feeAddrWallet2 = payable(0x2c5B9dd42d0510C43f1d6d672bD56A7DE0716c91);
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
179     function originalPurchase(address account) public  view returns (uint256) {
180         return _buyMap[account];
181     }
182 
183     function balanceOf(address account) public view override returns (uint256) {
184         return tokenFromReflection(_rOwned[account]);
185     }
186 
187     function transfer(address recipient, uint256 amount) public override returns (bool) {
188         _transfer(_msgSender(), recipient, amount);
189         return true;
190     }
191 
192     function allowance(address owner, address spender) public view override returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     function approve(address spender, uint256 amount) public override returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
202         _transfer(sender, recipient, amount);
203         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
204         return true;
205     }
206 
207     function setCooldownEnabled(bool onoff) external onlyOwner() {
208         cooldownEnabled = onoff;
209     }
210     
211     function setMaxTx(uint256 maxTransactionAmount) external onlyOwner() {
212         _maxTxAmount = maxTransactionAmount;
213     }
214 
215     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
216         require(rAmount <= _rTotal, "Amount must be less than total reflections");
217         uint256 currentRate =  _getRate();
218         return rAmount.div(currentRate);
219     }
220 
221     function _approve(address owner, address spender, uint256 amount) private {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _transfer(address from, address to, uint256 amount) private {
229         require(from != address(0), "ERC20: transfer from the zero address");
230         require(to != address(0), "ERC20: transfer to the zero address");
231         require(amount > 0, "Transfer amount must be greater than zero");
232     
233         
234         if (!_isBuy(from)) {
235             // TAX SELLERS 25% WHO SELL WITHIN 24 HOURS
236             if (_buyMap[from] != 0 &&
237                 (_buyMap[from] + (24 hours) >= block.timestamp))  {
238                 _feeAddr1 = 1;
239                 _feeAddr2 = 25;
240             } else {
241                 _feeAddr1 = 1;
242                 _feeAddr2 = 8;
243             }
244         } else {
245             if (_buyMap[to] == 0) {
246                 _buyMap[to] = block.timestamp;
247             }
248             _feeAddr1 = 1;
249             _feeAddr2 = 8;
250         }
251         
252         if (from != owner() && to != owner()) {
253             require(!bots[from] && !bots[to]);
254             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
255                 // Cooldown
256                 require(amount <= _maxTxAmount);
257                 require(cooldown[to] < block.timestamp);
258                 cooldown[to] = block.timestamp + (30 seconds);
259             }
260             
261             
262             uint256 contractTokenBalance = balanceOf(address(this));
263             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
264                 swapTokensForEth(contractTokenBalance);
265                 uint256 contractETHBalance = address(this).balance;
266                 if(contractETHBalance > 0) {
267                     sendETHToFee(address(this).balance);
268                 }
269             }
270         }
271 		
272         _tokenTransfer(from,to,amount);
273     }
274 
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         address[] memory path = new address[](2);
277         path[0] = address(this);
278         path[1] = uniswapV2Router.WETH();
279         _approve(address(this), address(uniswapV2Router), tokenAmount);
280         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(this),
285             block.timestamp
286         );
287     }
288         
289     function sendETHToFee(uint256 amount) private {
290         _feeAddrWallet1.transfer(amount.div(2));
291         _feeAddrWallet2.transfer(amount.div(2));
292     }
293     
294     function openTrading() external onlyOwner() {
295         require(!tradingOpen,"trading is already open");
296         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
297         uniswapV2Router = _uniswapV2Router;
298         _approve(address(this), address(uniswapV2Router), _tTotal);
299         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
300         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
301         swapEnabled = true;
302         cooldownEnabled = true;
303         _maxTxAmount = 20000000000 * 10 ** 9;
304         tradingOpen = true;
305         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
306     }
307     
308     function setBots(address[] memory bots_) public onlyOwner {
309         for (uint i = 0; i < bots_.length; i++) {
310             bots[bots_[i]] = true;
311         }
312     }
313     
314     function removeStrictTxLimit() public onlyOwner {
315         _maxTxAmount = 1e12 * 10**9;
316     }
317     
318     function delBot(address notbot) public onlyOwner {
319         bots[notbot] = false;
320     }
321         
322     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
323         _transferStandard(sender, recipient, amount);
324     }
325 
326     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
327         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
328         _rOwned[sender] = _rOwned[sender].sub(rAmount);
329         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
330         _takeTeam(tTeam);
331         _reflectFee(rFee, tFee);
332         emit Transfer(sender, recipient, tTransferAmount);
333     }
334 
335     function _takeTeam(uint256 tTeam) private {
336         uint256 currentRate =  _getRate();
337         uint256 rTeam = tTeam.mul(currentRate);
338         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
339     }
340     
341     function updateMaxTx (uint256 fee) public onlyOwner {
342         _maxTxAmount = fee;
343     }
344     
345     function _reflectFee(uint256 rFee, uint256 tFee) private {
346         _rTotal = _rTotal.sub(rFee);
347         _tFeeTotal = _tFeeTotal.add(tFee);
348     }
349 
350     receive() external payable {}
351     
352     function manualswap() external {
353         require(_msgSender() == _feeAddrWallet1);
354         uint256 contractBalance = balanceOf(address(this));
355         swapTokensForEth(contractBalance);
356     }
357     
358     function manualsend() external {
359         require(_msgSender() == _feeAddrWallet1);
360         uint256 contractETHBalance = address(this).balance;
361         sendETHToFee(contractETHBalance);
362     }
363     
364 
365     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
366         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
367         uint256 currentRate =  _getRate();
368         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
369         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
370     }
371 
372     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
373         uint256 tFee = tAmount.mul(taxFee).div(100);
374         uint256 tTeam = tAmount.mul(TeamFee).div(100);
375         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
376         return (tTransferAmount, tFee, tTeam);
377     }
378 
379     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
380         uint256 rAmount = tAmount.mul(currentRate);
381         uint256 rFee = tFee.mul(currentRate);
382         uint256 rTeam = tTeam.mul(currentRate);
383         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
384         return (rAmount, rTransferAmount, rFee);
385     }
386 
387     function _isBuy(address _sender) private view returns (bool) {
388         return _sender == uniswapV2Pair;
389     }
390 
391 
392 	function _getRate() private view returns(uint256) {
393         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
394         return rSupply.div(tSupply);
395     }
396 
397     function _getCurrentSupply() private view returns(uint256, uint256) {
398         uint256 rSupply = _rTotal;
399         uint256 tSupply = _tTotal;      
400         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
401         return (rSupply, tSupply);
402     }
403 }