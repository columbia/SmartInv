1 //SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.4;
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
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     address private _previousOwner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor () {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84 }  
85 
86 interface IUniswapV2Factory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IUniswapV2Router02 {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98     function factory() external pure returns (address);
99     function WETH() external pure returns (address);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 }
109 
110 contract MEWN is Context, IERC20, Ownable {
111     using SafeMath for uint256;
112     mapping (address => uint256) private _rOwned;
113     mapping (address => uint256) private _tOwned;
114     mapping (address => uint256) private _buyMap;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping (address => uint) private cooldown;
119     uint256 private constant MAX = ~uint256(0);
120     uint256 private constant _tTotal = 1e12 * 10**9;
121     uint256 private _rTotal = (MAX - (MAX % _tTotal));
122     uint256 private _tFeeTotal;
123     
124     uint256 private _feeAddr1;
125     uint256 private _feeAddr2;
126     address payable private _feeAddrWallet1;
127     address payable private _feeAddrWallet2;
128     
129     string private constant _name = "Mewn Inu";
130     string private constant _symbol = "MEWN";
131     uint8 private constant _decimals = 9;   
132     
133     IUniswapV2Router02 private uniswapV2Router;
134     address private uniswapV2Pair;
135     bool private tradingOpen;
136     bool private inSwap = false;
137     bool private swapEnabled = false;
138     bool private cooldownEnabled = false;
139     uint256 private _maxTxAmount = _tTotal;
140     uint256 private maxWalletAmount = _tTotal * 30 / 1000;
141     event MaxTxAmountUpdated(uint _maxTxAmount);
142     modifier lockTheSwap {
143         inSwap = true;
144         _;
145         inSwap = false;
146     }
147     constructor () {
148         _feeAddrWallet1 = payable(0x1096DAcD8c3745055057EFeE9Ae84FDb2324FAE4);
149         _feeAddrWallet2 = payable(0x03442529eB6d44c87612CEc169c77494566cCF19);
150         _rOwned[_msgSender()] = _rTotal;
151         _isExcludedFromFee[owner()] = true;
152         _isExcludedFromFee[address(this)] = true;
153         _isExcludedFromFee[_feeAddrWallet1] = true;
154         _isExcludedFromFee[_feeAddrWallet2] = true;
155         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
156     }
157 
158     function name() public pure returns (string memory) {
159         return _name;
160     }
161 
162     function symbol() public pure returns (string memory) {
163         return _symbol;
164     }
165 
166     function decimals() public pure returns (uint8) {
167         return _decimals;
168     }
169 
170     function totalSupply() public pure override returns (uint256) {
171         return _tTotal;
172     }
173     
174     function originalPurchase(address account) public  view returns (uint256) {
175         return _buyMap[account];
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return tokenFromReflection(_rOwned[account]);
180     }
181 
182     function transfer(address recipient, uint256 amount) public override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     function allowance(address owner, address spender) public view override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function setCooldownEnabled(bool onoff) external onlyOwner() {
203         cooldownEnabled = onoff;
204     }
205     
206     function setMaxTx(uint256 maxTransactionAmount) external onlyOwner() {
207         _maxTxAmount = maxTransactionAmount;
208     }
209 
210     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
211         require(rAmount <= _rTotal, "Amount must be less than total reflections");
212         uint256 currentRate =  _getRate();
213         return rAmount.div(currentRate);
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227     
228         
229         if (!_isBuy(from)) {
230             // TAX SELLERS 30% WHO SELL WITHIN 12 HOURS
231             if (_buyMap[from] != 0 &&
232                 (_buyMap[from] + (12 hours) >= block.timestamp))  {
233                 _feeAddr1 = 2;
234                 _feeAddr2 = 18;
235             } else {
236                 _feeAddr1 = 2;
237                 _feeAddr2 = 8;
238             }
239         } else {
240             if (_buyMap[to] == 0) {
241                 _buyMap[to] = block.timestamp;
242             }
243             _feeAddr1 = 2;
244             _feeAddr2 = 8;
245         }
246         
247         if (from != owner() && to != owner()) {
248             require(!bots[from] && !bots[to]);
249             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
250                 // Cooldown
251                 require(cooldown[to] < block.timestamp);
252                 require(amount <= _maxTxAmount);
253                 require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet exceeded");
254                 cooldown[to] = block.timestamp + (30 seconds);
255             }
256             
257             
258             uint256 contractTokenBalance = balanceOf(address(this));
259             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
260                 swapTokensForEth(contractTokenBalance);
261                 uint256 contractETHBalance = address(this).balance;
262                 if(contractETHBalance > 0) {
263                     sendETHToFee(address(this).balance);
264                 }
265             }
266         }
267 		
268         _tokenTransfer(from,to,amount);
269     }
270 
271     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
272         address[] memory path = new address[](2);
273         path[0] = address(this);
274         path[1] = uniswapV2Router.WETH();
275         _approve(address(this), address(uniswapV2Router), tokenAmount);
276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
277             tokenAmount,
278             0,
279             path,
280             address(this),
281             block.timestamp
282         );
283     }
284         
285     function sendETHToFee(uint256 amount) private {
286         _feeAddrWallet1.transfer(amount.div(2));
287         _feeAddrWallet2.transfer(amount.div(2));
288     }
289     
290     function openTrading() external onlyOwner() {
291         require(!tradingOpen,"trading is already open");
292         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
293         uniswapV2Router = _uniswapV2Router;
294         _approve(address(this), address(uniswapV2Router), _tTotal);
295         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
296         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
297         swapEnabled = true;
298         cooldownEnabled = true;
299         _maxTxAmount = 10000000000 * 10 ** 9;
300         tradingOpen = true;
301         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
302     }
303     
304     function setBots(address[] memory bots_) public onlyOwner {
305         for (uint i = 0; i < bots_.length; i++) {
306             bots[bots_[i]] = true;
307         }
308     }
309     
310     function removeStrictTxLimit() public onlyOwner {
311         _maxTxAmount = 1e12 * 10**9;
312     }
313     
314     function delBot(address notbot) public onlyOwner {
315         bots[notbot] = false;
316     }
317         
318     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
319         _transferStandard(sender, recipient, amount);
320     }
321 
322     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
323         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
324         _rOwned[sender] = _rOwned[sender].sub(rAmount);
325         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
326         _takeTeam(tTeam);
327         _reflectFee(rFee, tFee);
328         emit Transfer(sender, recipient, tTransferAmount);
329     }
330 
331     function _takeTeam(uint256 tTeam) private {
332         uint256 currentRate =  _getRate();
333         uint256 rTeam = tTeam.mul(currentRate);
334         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
335     }
336     
337     function updateMaxTx (uint256 fee) public onlyOwner {
338         _maxTxAmount = fee;
339     }
340     
341     function _reflectFee(uint256 rFee, uint256 tFee) private {
342         _rTotal = _rTotal.sub(rFee);
343         _tFeeTotal = _tFeeTotal.add(tFee);
344     }
345 
346     receive() external payable {}
347     
348     function manualswap() external {
349         require(_msgSender() == _feeAddrWallet1);
350         uint256 contractBalance = balanceOf(address(this));
351         swapTokensForEth(contractBalance);
352     }
353     
354     function manualsend() external {
355         require(_msgSender() == _feeAddrWallet1);
356         uint256 contractETHBalance = address(this).balance;
357         sendETHToFee(contractETHBalance);
358     }
359     
360 
361     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
362         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
363         uint256 currentRate =  _getRate();
364         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
365         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
366     }
367 
368     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
369         uint256 tFee = tAmount.mul(taxFee).div(100);
370         uint256 tTeam = tAmount.mul(TeamFee).div(100);
371         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
372         return (tTransferAmount, tFee, tTeam);
373     }
374 
375     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
376         uint256 rAmount = tAmount.mul(currentRate);
377         uint256 rFee = tFee.mul(currentRate);
378         uint256 rTeam = tTeam.mul(currentRate);
379         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
380         return (rAmount, rTransferAmount, rFee);
381     }
382 
383     function _isBuy(address _sender) private view returns (bool) {
384         return _sender == uniswapV2Pair;
385     }
386 
387 
388 	function _getRate() private view returns(uint256) {
389         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
390         return rSupply.div(tSupply);
391     }
392 
393     function _getCurrentSupply() private view returns(uint256, uint256) {
394         uint256 rSupply = _rTotal;
395         uint256 tSupply = _tTotal;      
396         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
397         return (rSupply, tSupply);
398     }
399 }