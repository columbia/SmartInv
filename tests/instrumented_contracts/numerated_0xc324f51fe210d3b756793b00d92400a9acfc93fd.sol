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
110 contract FrensInu is Context, IERC20, Ownable {
111     using SafeMath for uint256;
112     mapping (address => uint256) private _rOwned;
113     mapping (address => uint256) private _tOwned;
114     mapping (address => uint256) private _buyMap;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping (address => uint) private cooldown;
119     uint256 private constant MAX = ~uint256(0);
120     uint256 private constant _tTotal = 1e11 * 10**9;
121     uint256 private _rTotal = (MAX - (MAX % _tTotal));
122     uint256 private _tFeeTotal;
123     
124     uint256 private _feeAddr1;
125     uint256 private _feeAddr2;
126     address payable private _feeAddrWallet1;
127     address payable private _feeAddrWallet2;
128     
129     string private constant _name = "FrensInu";
130     string private constant _symbol = "FRENSINU";
131     uint8 private constant _decimals = 9;   
132     
133     IUniswapV2Router02 private uniswapV2Router;
134     address private uniswapV2Pair;
135     bool private tradingOpen;
136     bool private inSwap = false;
137     bool private swapEnabled = false;
138     bool private cooldownEnabled = false;
139     uint256 private _maxTxAmount = _tTotal;
140     event MaxTxAmountUpdated(uint _maxTxAmount);
141     modifier lockTheSwap {
142         inSwap = true;
143         _;
144         inSwap = false;
145     }
146     constructor () {
147         _feeAddrWallet1 = payable(0xba09b1Ce20263Cd3fc571D900a472BaD89E482ad);
148         _feeAddrWallet2 = payable(0xba09b1Ce20263Cd3fc571D900a472BaD89E482ad);
149         _rOwned[_msgSender()] = _rTotal;
150         _isExcludedFromFee[owner()] = true;
151         _isExcludedFromFee[address(this)] = true;
152         _isExcludedFromFee[_feeAddrWallet1] = true;
153         _isExcludedFromFee[_feeAddrWallet2] = true;
154         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
155     }
156 
157     function name() public pure returns (string memory) {
158         return _name;
159     }
160 
161     function symbol() public pure returns (string memory) {
162         return _symbol;
163     }
164 
165     function decimals() public pure returns (uint8) {
166         return _decimals;
167     }
168 
169     function totalSupply() public pure override returns (uint256) {
170         return _tTotal;
171     }
172     
173     function originalPurchase(address account) public  view returns (uint256) {
174         return _buyMap[account];
175     }
176 
177     function balanceOf(address account) public view override returns (uint256) {
178         return tokenFromReflection(_rOwned[account]);
179     }
180 
181     function transfer(address recipient, uint256 amount) public override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     function allowance(address owner, address spender) public view override returns (uint256) {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount) public override returns (bool) {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
196         _transfer(sender, recipient, amount);
197         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
198         return true;
199     }
200 
201     function setCooldownEnabled(bool onoff) external onlyOwner() {
202         cooldownEnabled = onoff;
203     }
204     
205     function setMaxTx(uint256 maxTransactionAmount) external onlyOwner() {
206         _maxTxAmount = maxTransactionAmount;
207     }
208 
209     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
210         require(rAmount <= _rTotal, "Amount must be less than total reflections");
211         uint256 currentRate =  _getRate();
212         return rAmount.div(currentRate);
213     }
214 
215     function _approve(address owner, address spender, uint256 amount) private {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _transfer(address from, address to, uint256 amount) private {
223         require(from != address(0), "ERC20: transfer from the zero address");
224         require(to != address(0), "ERC20: transfer to the zero address");
225         require(amount > 0, "Transfer amount must be greater than zero");
226     
227         if (from != owner()) {
228             if (!_isBuy(from)) {
229                 // TAX SELLERS 25% WHO SELL WITHIN 24 HOURS
230                 if (_buyMap[from] != 0 &&
231                     (_buyMap[from] + (24 hours) >= block.timestamp))  {
232                     _feeAddr1 = 1;
233                     _feeAddr2 = 25;
234                 } else {
235                     _feeAddr1 = 1;
236                     _feeAddr2 = 8;
237                 }
238             } else {
239                 if (_buyMap[to] == 0) {
240                     _buyMap[to] = block.timestamp;
241                 }
242                 _feeAddr1 = 1;
243                 _feeAddr2 = 8;
244             } }
245         
246         if (from != owner() && to != owner()) {
247             require(!bots[from] && !bots[to]);
248             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
249                 // Cooldown
250                 require(amount <= _maxTxAmount);
251                 require(cooldown[to] < block.timestamp);
252                 cooldown[to] = block.timestamp + (30 seconds);
253             }
254             
255             
256             uint256 contractTokenBalance = balanceOf(address(this));
257             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
258                 swapTokensForEth(contractTokenBalance);
259                 uint256 contractETHBalance = address(this).balance;
260                 if(contractETHBalance > 0) {
261                     sendETHToFee(address(this).balance);
262                 }
263             }
264         }
265 		
266         _tokenTransfer(from,to,amount);
267     }
268 
269     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
270         address[] memory path = new address[](2);
271         path[0] = address(this);
272         path[1] = uniswapV2Router.WETH();
273         _approve(address(this), address(uniswapV2Router), tokenAmount);
274         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
275             tokenAmount,
276             0,
277             path,
278             address(this),
279             block.timestamp
280         );
281     }
282         
283     function sendETHToFee(uint256 amount) private {
284         _feeAddrWallet1.transfer(amount.div(2));
285         _feeAddrWallet2.transfer(amount.div(2));
286     }
287     
288     function openTrading() external onlyOwner() {
289         require(!tradingOpen,"trading is already open");
290         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // 
291         uniswapV2Router = _uniswapV2Router;
292         _approve(address(this), address(uniswapV2Router), _tTotal);
293         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
294         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
295         swapEnabled = true;
296         cooldownEnabled = true;
297         _maxTxAmount = 2000000000 * 10 ** 9;
298         tradingOpen = true;
299         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
300     }
301     
302     function setBots(address[] memory bots_) public onlyOwner {
303         for (uint i = 0; i < bots_.length; i++) {
304             bots[bots_[i]] = true;
305         }
306     }
307     
308     function removeStrictTxLimit() public onlyOwner {
309         _maxTxAmount = 1e11 * 10**9;
310     }
311     
312     function delBot(address notbot) public onlyOwner {
313         bots[notbot] = false;
314     }
315         
316     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
317         _transferStandard(sender, recipient, amount);
318     }
319 
320     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
321         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
322         _rOwned[sender] = _rOwned[sender].sub(rAmount);
323         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
324         _takeTeam(tTeam);
325         _reflectFee(rFee, tFee);
326         emit Transfer(sender, recipient, tTransferAmount);
327     }
328 
329     function _takeTeam(uint256 tTeam) private {
330         uint256 currentRate =  _getRate();
331         uint256 rTeam = tTeam.mul(currentRate);
332         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
333     }
334     
335     function updateMaxTx (uint256 fee) public onlyOwner {
336         _maxTxAmount = fee;
337     }
338     
339     function _reflectFee(uint256 rFee, uint256 tFee) private {
340         _rTotal = _rTotal.sub(rFee);
341         _tFeeTotal = _tFeeTotal.add(tFee);
342     }
343 
344     receive() external payable {}
345     
346     function manualswap() external {
347         require(_msgSender() == _feeAddrWallet1);
348         uint256 contractBalance = balanceOf(address(this));
349         swapTokensForEth(contractBalance);
350     }
351     
352     function manualsend() external {
353         require(_msgSender() == _feeAddrWallet1);
354         uint256 contractETHBalance = address(this).balance;
355         sendETHToFee(contractETHBalance);
356     }
357     
358 
359     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
360         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
361         uint256 currentRate =  _getRate();
362         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
363         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
364     }
365 
366     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
367         uint256 tFee = tAmount.mul(taxFee).div(100);
368         uint256 tTeam = tAmount.mul(TeamFee).div(100);
369         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
370         return (tTransferAmount, tFee, tTeam);
371     }
372 
373     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
374         uint256 rAmount = tAmount.mul(currentRate);
375         uint256 rFee = tFee.mul(currentRate);
376         uint256 rTeam = tTeam.mul(currentRate);
377         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
378         return (rAmount, rTransferAmount, rFee);
379     }
380 
381     function _isBuy(address _sender) private view returns (bool) {
382         return _sender == uniswapV2Pair;
383     }
384 
385 
386 	function _getRate() private view returns(uint256) {
387         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
388         return rSupply.div(tSupply);
389     }
390 
391     function _getCurrentSupply() private view returns(uint256, uint256) {
392         uint256 rSupply = _rTotal;
393         uint256 tSupply = _tTotal;      
394         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
395         return (rSupply, tSupply);
396     }
397 }