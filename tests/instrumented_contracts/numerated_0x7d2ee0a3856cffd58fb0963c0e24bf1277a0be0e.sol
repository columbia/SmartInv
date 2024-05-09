1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-28
3  * Join us on Telegram https://t.me/zenoinu
4  * Visit our website https://www.zenoinu.com/
5  * Prepare for liftoff
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 
10 pragma solidity ^0.8.4;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     address private _previousOwner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }  
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract ZENO is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping (address => uint) private cooldown;
126     uint256 private constant MAX = ~uint256(0);
127     uint256 private constant _tTotal = 1e12 * 10**9;
128     uint256 private _rTotal = (MAX - (MAX % _tTotal));
129     uint256 private _tFeeTotal;
130     
131     uint256 private _feeAddr1;
132     uint256 private _feeAddr2;
133     address payable private _feeAddrWallet1;
134     address payable private _feeAddrWallet2;
135     
136     string private constant _name = "Zeno Inu";
137     string private constant _symbol = "ZENO";
138     uint8 private constant _decimals = 9;
139     
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     bool private cooldownEnabled = false;
146     uint256 private _maxTxAmount = _tTotal;
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153     constructor () {
154         _feeAddrWallet1 = payable(0x4391119C8aE33Ae01A3CEE1777E7c335029bB3cc);
155         _feeAddrWallet2 = payable(0x4391119C8aE33Ae01A3CEE1777E7c335029bB3cc);
156         _rOwned[_msgSender()] = _rTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_feeAddrWallet1] = true;
160         _isExcludedFromFee[_feeAddrWallet2] = true;
161         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return tokenFromReflection(_rOwned[account]);
182     }
183 
184     function transfer(address recipient, uint256 amount) public override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function setCooldownEnabled(bool onoff) external onlyOwner() {
205         cooldownEnabled = onoff;
206     }
207 
208     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
209         require(rAmount <= _rTotal, "Amount must be less than total reflections");
210         uint256 currentRate =  _getRate();
211         return rAmount.div(currentRate);
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225         _feeAddr1 = 2;
226         _feeAddr2 = 8;
227         if (from != owner() && to != owner()) {
228             require(!bots[from] && !bots[to]);
229             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
230                 // Cooldown
231                 require(amount <= _maxTxAmount);
232                 require(cooldown[to] < block.timestamp);
233                 cooldown[to] = block.timestamp + (30 seconds);
234             }
235             
236             
237             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
238                 _feeAddr1 = 2;
239                 _feeAddr2 = 10;
240             }
241             uint256 contractTokenBalance = balanceOf(address(this));
242             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
243                 swapTokensForEth(contractTokenBalance);
244                 uint256 contractETHBalance = address(this).balance;
245                 if(contractETHBalance > 0) {
246                     sendETHToFee(address(this).balance);
247                 }
248             }
249         }
250 		
251         _tokenTransfer(from,to,amount);
252     }
253 
254     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
255         address[] memory path = new address[](2);
256         path[0] = address(this);
257         path[1] = uniswapV2Router.WETH();
258         _approve(address(this), address(uniswapV2Router), tokenAmount);
259         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
260             tokenAmount,
261             0,
262             path,
263             address(this),
264             block.timestamp
265         );
266     }
267         
268     function sendETHToFee(uint256 amount) private {
269         _feeAddrWallet1.transfer(amount.div(2));
270         _feeAddrWallet2.transfer(amount.div(2));
271     }
272     
273     function openTrading() external onlyOwner() {
274         require(!tradingOpen,"trading is already open");
275         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
276         uniswapV2Router = _uniswapV2Router;
277         _approve(address(this), address(uniswapV2Router), _tTotal);
278         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
279         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
280         swapEnabled = true;
281         cooldownEnabled = true;
282         _maxTxAmount = 1e12 * 10**9;
283         tradingOpen = true;
284         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
285     }
286     
287     function setBots(address[] memory bots_) public onlyOwner {
288         for (uint i = 0; i < bots_.length; i++) {
289             bots[bots_[i]] = true;
290         }
291     }
292     
293     function removeStrictTxLimit() public onlyOwner {
294         _maxTxAmount = 1e12 * 10**9;
295     }
296     
297     function delBot(address notbot) public onlyOwner {
298         bots[notbot] = false;
299     }
300         
301     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
302         _transferStandard(sender, recipient, amount);
303     }
304 
305     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
306         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
307         _rOwned[sender] = _rOwned[sender].sub(rAmount);
308         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
309         _takeTeam(tTeam);
310         _reflectFee(rFee, tFee);
311         emit Transfer(sender, recipient, tTransferAmount);
312     }
313 
314     function _takeTeam(uint256 tTeam) private {
315         uint256 currentRate =  _getRate();
316         uint256 rTeam = tTeam.mul(currentRate);
317         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
318     }
319 
320     function _reflectFee(uint256 rFee, uint256 tFee) private {
321         _rTotal = _rTotal.sub(rFee);
322         _tFeeTotal = _tFeeTotal.add(tFee);
323     }
324 
325     receive() external payable {}
326     
327     function manualswap() external {
328         require(_msgSender() == _feeAddrWallet1);
329         uint256 contractBalance = balanceOf(address(this));
330         swapTokensForEth(contractBalance);
331     }
332     
333     function manualsend() external {
334         require(_msgSender() == _feeAddrWallet1);
335         uint256 contractETHBalance = address(this).balance;
336         sendETHToFee(contractETHBalance);
337     }
338     
339 
340     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
341         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
342         uint256 currentRate =  _getRate();
343         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
344         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
345     }
346 
347     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
348         uint256 tFee = tAmount.mul(taxFee).div(100);
349         uint256 tTeam = tAmount.mul(TeamFee).div(100);
350         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
351         return (tTransferAmount, tFee, tTeam);
352     }
353 
354     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
355         uint256 rAmount = tAmount.mul(currentRate);
356         uint256 rFee = tFee.mul(currentRate);
357         uint256 rTeam = tTeam.mul(currentRate);
358         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
359         return (rAmount, rTransferAmount, rFee);
360     }
361 
362 	function _getRate() private view returns(uint256) {
363         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
364         return rSupply.div(tSupply);
365     }
366 
367     function _getCurrentSupply() private view returns(uint256, uint256) {
368         uint256 rSupply = _rTotal;
369         uint256 tSupply = _tTotal;      
370         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
371         return (rSupply, tSupply);
372     }
373 }