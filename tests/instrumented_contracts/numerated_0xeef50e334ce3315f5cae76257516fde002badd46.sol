1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-15
3 */
4 
5 /**
6  //SPDX-License-Identifier: UNLICENSED
7  
8 Follow us on Telegram! TG: t.me/ErenYeagerInu
9 */
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
119 contract ErenYeagerInu is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _rOwned;
122     mapping (address => uint256) private _tOwned;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     mapping (address => uint) private cooldown;
127     uint256 private constant MAX = ~uint256(0);
128     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
129     uint256 private _rTotal = (MAX - (MAX % _tTotal));
130     uint256 private _tFeeTotal;
131     
132     uint256 private _feeAddr1;
133     uint256 private _feeAddr2;
134     address payable private _feeAddrWallet1;
135     address payable private _feeAddrWallet2;
136     
137     string private constant _name = "Eren Yeager Inu";
138     string private constant _symbol = "ErenYeagerInu";
139     uint8 private constant _decimals = 9;
140     
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     bool private tradingOpen;
144     bool private inSwap = false;
145     bool private swapEnabled = false;
146     bool private cooldownEnabled = false;
147     uint256 private _maxTxAmount = _tTotal;
148     event MaxTxAmountUpdated(uint _maxTxAmount);
149     modifier lockTheSwap {
150         inSwap = true;
151         _;
152         inSwap = false;
153     }
154     constructor () {
155         _feeAddrWallet1 = payable(0x4070b1F0cCA286aE5f8C0954F15ff925d00C74B8);
156         _feeAddrWallet2 = payable(0x4070b1F0cCA286aE5f8C0954F15ff925d00C74B8);
157         _rOwned[_msgSender()] = _rTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_feeAddrWallet1] = true;
161         _isExcludedFromFee[_feeAddrWallet2] = true;
162         emit Transfer(address(0xbD7101dF1Cc7DC00DB4A8A014B88952e22650F93), _msgSender(), _tTotal);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return tokenFromReflection(_rOwned[account]);
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204 
205     function setCooldownEnabled(bool onoff) external onlyOwner() {
206         cooldownEnabled = onoff;
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
226         _feeAddr1 = 1;
227         _feeAddr2 = 9;
228         if (from != owner() && to != owner()) {
229             require(!bots[from] && !bots[to]);
230             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
231                 // Cooldown
232                 require(amount <= _maxTxAmount);
233                 require(cooldown[to] < block.timestamp);
234                 cooldown[to] = block.timestamp + (30 seconds);
235             }
236             
237             
238             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
239                 _feeAddr1 = 1;
240                 _feeAddr2 = 9;
241             }
242             uint256 contractTokenBalance = balanceOf(address(this));
243             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
244                 swapTokensForEth(contractTokenBalance);
245                 uint256 contractETHBalance = address(this).balance;
246                 if(contractETHBalance > 0) {
247                     sendETHToFee(address(this).balance);
248                 }
249             }
250         }
251 		
252         _tokenTransfer(from,to,amount);
253     }
254 
255     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
256         address[] memory path = new address[](2);
257         path[0] = address(this);
258         path[1] = uniswapV2Router.WETH();
259         _approve(address(this), address(uniswapV2Router), tokenAmount);
260         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
261             tokenAmount,
262             0,
263             path,
264             address(this),
265             block.timestamp
266         );
267     }
268         
269     function sendETHToFee(uint256 amount) private {
270         _feeAddrWallet1.transfer(amount.div(2));
271         _feeAddrWallet2.transfer(amount.div(2));
272     }
273     
274     function openTrading() external onlyOwner() {
275         require(!tradingOpen,"trading is already open");
276         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
277         uniswapV2Router = _uniswapV2Router;
278         _approve(address(this), address(uniswapV2Router), _tTotal);
279         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
280         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
281         swapEnabled = true;
282         cooldownEnabled = true;
283         _maxTxAmount = 20000000000000000 * 10**9;
284         tradingOpen = true;
285         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
286     }
287     
288     function setBots(address[] memory bots_) public onlyOwner {
289         for (uint i = 0; i < bots_.length; i++) {
290             bots[bots_[i]] = true;
291         }
292     }
293     
294     function delBot(address notbot) public onlyOwner {
295         bots[notbot] = false;
296     }
297         
298     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
299         _transferStandard(sender, recipient, amount);
300     }
301 
302     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
303         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
304         _rOwned[sender] = _rOwned[sender].sub(rAmount);
305         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
306         _takeTeam(tTeam);
307         _reflectFee(rFee, tFee);
308         emit Transfer(sender, recipient, tTransferAmount);
309     }
310 
311     function _takeTeam(uint256 tTeam) private {
312         uint256 currentRate =  _getRate();
313         uint256 rTeam = tTeam.mul(currentRate);
314         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
315     }
316 
317     function _reflectFee(uint256 rFee, uint256 tFee) private {
318         _rTotal = _rTotal.sub(rFee);
319         _tFeeTotal = _tFeeTotal.add(tFee);
320     }
321 
322     receive() external payable {}
323     
324     function manualswap() external {
325         require(_msgSender() == _feeAddrWallet1);
326         uint256 contractBalance = balanceOf(address(this));
327         swapTokensForEth(contractBalance);
328     }
329     
330     function manualsend() external {
331         require(_msgSender() == _feeAddrWallet1);
332         uint256 contractETHBalance = address(this).balance;
333         sendETHToFee(contractETHBalance);
334     }
335     
336 
337     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
338         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
339         uint256 currentRate =  _getRate();
340         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
341         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
342     }
343 
344     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
345         uint256 tFee = tAmount.mul(taxFee).div(100);
346         uint256 tTeam = tAmount.mul(TeamFee).div(100);
347         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
348         return (tTransferAmount, tFee, tTeam);
349     }
350 
351     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
352         uint256 rAmount = tAmount.mul(currentRate);
353         uint256 rFee = tFee.mul(currentRate);
354         uint256 rTeam = tTeam.mul(currentRate);
355         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
356         return (rAmount, rTransferAmount, rFee);
357     }
358 
359 	function _getRate() private view returns(uint256) {
360         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
361         return rSupply.div(tSupply);
362     }
363 
364     function _getCurrentSupply() private view returns(uint256, uint256) {
365         uint256 rSupply = _rTotal;
366         uint256 tSupply = _tTotal;      
367         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
368         return (rSupply, tSupply);
369     }
370 }