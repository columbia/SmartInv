1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-18
3 */
4 
5 /**
6  //SPDX-License-Identifier: UNLICENSED
7  
8 */
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
118 contract CaptainInu is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping (address => uint) private cooldown;
126     uint256 private constant MAX = ~uint256(0);
127 
128     uint256 private constant _tTotal = (10**_liquidityOOM) * 10**_decimals;
129     uint256 private _rTotal = (MAX - (MAX % _tTotal));
130     uint256 private _tFeeTotal;
131     
132     uint256 private _feeAddr1 = 1;
133     uint256 private _feeAddr2 = 9;
134     address payable private _feeAddrWallet1;
135     address payable private _feeAddrWallet2;
136     
137     string private constant _name = "Captain Inu";
138     string private constant _symbol = "CPTINU";
139     uint8 private constant _decimals = 18;
140     uint8 private constant _liquidityOOM = 15;
141     
142     IUniswapV2Router02 private uniswapV2Router;
143     address public uniswapV2Pair;
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
156         _feeAddrWallet1 = payable(0x0d2117e5e63a3F692B5Ff35aC8Cd006d756Acb28);
157         _feeAddrWallet2 = payable(0x0d2117e5e63a3F692B5Ff35aC8Cd006d756Acb28);
158         _rOwned[_msgSender()] = _rTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_feeAddrWallet1] = true;
162         _isExcludedFromFee[_feeAddrWallet2] = true;
163         emit Transfer(address(0x0d2117e5e63a3F692B5Ff35aC8Cd006d756Acb28), _msgSender(), _tTotal);
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
182     function reflectionOwned(address index) public view returns (uint256){
183         return _rOwned[index];
184     } 
185     
186     function tokenOwned(address index) public view returns (uint256){
187         return _tOwned[index];
188     } 
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return tokenFromReflection(_rOwned[account]);
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function setCooldownEnabled(bool onoff) external onlyOwner() {
215         cooldownEnabled = onoff;
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
231     function lowerFees(uint256 newFeeAddr1 , uint256 newFeeAddr2) public onlyOwner() {
232         //rgm cryptum
233         require((newFeeAddr1 + newFeeAddr2) <= 10, "Fee cannot be set higher than 10%");
234         _feeAddr1 = newFeeAddr1;
235         _feeAddr2 = newFeeAddr2;
236     }
237 
238     function _transfer(address from, address to, uint256 amount) private {
239         
240         require(from != address(0), "ERC20: transfer from the zero address");
241         require(to != address(0), "ERC20: transfer to the zero address");
242         require(amount > 0, "Transfer amount must be greater than zero");
243         if (from != owner() && to != owner()) {
244             require(!bots[from] && !bots[to]);
245             // Cooldown
246             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
247                 require(amount <= _maxTxAmount,"Amount must be smaller than max amount");
248                 require(cooldown[to] < block.timestamp, "cooldown is enabled. pls wait and try again");
249                 cooldown[to] = block.timestamp + (30 seconds);
250             }
251             
252             // initial liq provide tokens not active after open trading.
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
255                 // check token balance of current account, swap to eth, send it to this wallet
256                 swapTokensForEth(contractTokenBalance);
257                 uint256 contractETHBalance = address(this).balance;
258                 if(contractETHBalance > 0) {
259                     sendETHToFee(address(this).balance); // send this adrs eth to marketing wallet
260                 }
261             }
262         }
263 		
264         _tokenTransfer(from,to,amount);
265     }
266 
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281         
282     function sendETHToFee(uint256 amount) private {
283         _feeAddrWallet1.transfer(amount.div(2));
284         _feeAddrWallet2.transfer(amount.div(2));
285     }
286     
287     function openTrading() external onlyOwner() {
288         require(!tradingOpen,"trading is already open");
289         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
290         uniswapV2Router = _uniswapV2Router;
291         _approve(address(this), address(uniswapV2Router), _tTotal);
292         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
293         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
294         swapEnabled = true;
295         cooldownEnabled = true;
296         _maxTxAmount = _tTotal.div(25) * 10**_decimals;
297         tradingOpen = true;
298         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
299     }
300     
301     function setBots(address[] memory bots_) public onlyOwner {
302         for (uint i = 0; i < bots_.length; i++) {
303             bots[bots_[i]] = true;
304         }
305     }
306     
307     function delBot(address notbot) public onlyOwner {
308         bots[notbot] = false;
309     }
310         
311     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
312         _transferStandard(sender, recipient, amount);
313     }
314 
315     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
316         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
317         _rOwned[sender] = _rOwned[sender].sub(rAmount);
318         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
319         _takeTeam(tTeam);
320         _reflectFee(rFee, tFee);
321         emit Transfer(sender, recipient, tTransferAmount);
322     }
323 
324     function _takeTeam(uint256 tTeam) private {
325         uint256 currentRate =  _getRate();
326         uint256 rTeam = tTeam.mul(currentRate);
327         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
328     }
329 
330     function _reflectFee(uint256 rFee, uint256 tFee) private {
331         _rTotal = _rTotal.sub(rFee);
332         _tFeeTotal = _tFeeTotal.add(tFee);
333     }
334 
335     receive() external payable {}
336     
337     function manualswap() external {
338         require(_msgSender() == _feeAddrWallet1);
339         uint256 contractBalance = balanceOf(address(this));
340         swapTokensForEth(contractBalance);
341     }
342     
343     function manualsend() external {
344         require(_msgSender() == _feeAddrWallet1);
345         uint256 contractETHBalance = address(this).balance;
346         sendETHToFee(contractETHBalance);
347     }
348     
349 
350     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
351         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
352         uint256 currentRate =  _getRate();
353         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
354         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
355     }
356 
357     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
358         uint256 tFee = tAmount.mul(taxFee).div(100);
359         uint256 tTeam = tAmount.mul(TeamFee).div(100);
360         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
361         return (tTransferAmount, tFee, tTeam);
362     }
363 
364     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
365         uint256 rAmount = tAmount.mul(currentRate);
366         uint256 rFee = tFee.mul(currentRate);
367         uint256 rTeam = tTeam.mul(currentRate);
368         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
369         return (rAmount, rTransferAmount, rFee);
370     }
371 
372 	function _getRate() private view returns(uint256) {
373         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
374         return rSupply.div(tSupply);
375     }
376 
377     function _getCurrentSupply() private view returns(uint256, uint256) {
378         uint256 rSupply = _rTotal;
379         uint256 tSupply = _tTotal;      
380         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
381         return (rSupply, tSupply);
382     }
383 }