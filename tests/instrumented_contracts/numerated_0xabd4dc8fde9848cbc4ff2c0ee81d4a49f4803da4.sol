1 /* Created by Josh */
2 // Squeeze Token _ _ _ The official short squeeze token of cryptocurrency
3 // #STOPRUGS
4 /* https://t.me/SqueezeToken */
5 
6 pragma solidity ^0.8.4;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     address private _previousOwner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88 }  
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(        address token,
105 
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract Squeeze is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _rOwned;
117     mapping (address => uint256) private _tOwned;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping (address => bool) private bots;
121     mapping (address => uint) private cooldown;
122     uint256 private constant MAX = ~uint256(0);
123     uint256 private constant _tTotal = 100000000000000 * 10 ** 9;
124 
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126     uint256 private _tFeeTotal;
127     
128     uint256 private _feeAddr1;
129     uint256 private _feeAddr2;
130     address payable private _feeAddrWallet1;
131     address payable private _feeAddrWallet2;
132     
133     string private constant _name = "SQUEEZE";
134     string private constant _symbol = "SQUEEZE TOKEN";
135     uint8 private constant _decimals = 9;
136     
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142     bool private cooldownEnabled = false;
143     uint256 private _maxTxAmount = _tTotal;
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150 
151     constructor () {
152         _feeAddrWallet1 = payable(0x6672C7bb6E698145abA8b2f35CBE20a6901687A9);
153         _feeAddrWallet2 = payable(0x6672C7bb6E698145abA8b2f35CBE20a6901687A9);
154         _rOwned[_msgSender()] = _rTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[_feeAddrWallet1] = true;
158         _isExcludedFromFee[_feeAddrWallet2] = true;
159         emit Transfer(address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), _msgSender(), _tTotal);
160     }
161 
162     function name() public pure returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public pure returns (uint8) {
171         return _decimals;
172     }
173 
174     function totalSupply() public pure override returns (uint256) {
175         return _tTotal;
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
206     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
207         require(rAmount <= _rTotal, "Amount must be less than total reflections");
208         uint256 currentRate =  _getRate();
209         return rAmount.div(currentRate);
210     }
211     
212     function _approve(address owner, address spender, uint256 amount) private {
213         require(owner != address(0), "ERC20: approve from the zero address");
214         require(spender != address(0), "ERC20: approve to the zero address");
215         _allowances[owner][spender] = amount;
216         emit Approval(owner, spender, amount);
217     }
218     
219     function _transfer(address from, address to, uint256 amount) private {
220         require(from != address(0), "ERC20: transfer from the zero address");
221         require(to != address(0), "ERC20: transfer to the zero address");
222         require(amount > 0, "Transfer amount must be greater than zero");
223         
224         _feeAddr1 = 8;
225         _feeAddr2 = 3;
226         
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
238                 _feeAddr1 = 8;
239                 _feeAddr2 = 3;
240             }
241             
242             uint256 contractTokenBalance = balanceOf(address(this));
243             
244             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
245                 swapTokensForEth(contractTokenBalance);
246                 uint256 contractETHBalance = address(this).balance;
247                 if(contractETHBalance > 0) {
248                     sendETHToFee(address(this).balance);
249                 }
250             }
251             
252         }
253         _tokenTransfer(from,to,amount);
254     }
255 
256     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
257         address[] memory path = new address[](2);
258         path[0] = address(this);
259         path[1] = uniswapV2Router.WETH();
260         _approve(address(this), address(uniswapV2Router), tokenAmount);
261         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
262             tokenAmount,
263             0,
264             path,
265             address(this),
266             block.timestamp
267         );
268     }
269     function sendETHToFee(uint256 amount) private {
270         _feeAddrWallet1.transfer(amount.div(2));
271         _feeAddrWallet2.transfer(amount.div(2));
272     }
273    function openSwapTrading() external onlyOwner() {
274         require(!tradingOpen,"trading is already open");
275         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
276         uniswapV2Router = _uniswapV2Router;
277         _approve(address(this), address(uniswapV2Router), _tTotal);
278         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
279         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
280         swapEnabled = true;
281         cooldownEnabled = true;
282         _maxTxAmount = 10000000000000 * 10**9;
283         tradingOpen = true;
284         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
285     }
286     
287     function setSwapEnabled (bool enabled) external {
288         swapEnabled = enabled;
289     }
290     function setBots(address[] memory bots_) public onlyOwner {
291         for (uint i = 0; i < bots_.length; i++) {
292             bots[bots_[i]] = true;
293         }
294     }
295     function delBot(address notbot) public onlyOwner {
296         bots[notbot] = false;
297     }
298     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
299         _transferStandard(sender, recipient, amount);
300     }
301     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
302         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
303         _rOwned[sender] = _rOwned[sender].sub(rAmount);
304         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
305         _takeTeam(tTeam);
306         _reflectFee(rFee, tFee);
307         emit Transfer(sender, recipient, tTransferAmount);
308     }
309     function _takeTeam(uint256 tTeam) private {
310         uint256 currentRate =  _getRate();
311         uint256 rTeam = tTeam.mul(currentRate);
312         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
313     }
314     function _reflectFee(uint256 rFee, uint256 tFee) private {
315         _rTotal = _rTotal.sub(rFee);
316         _tFeeTotal = _tFeeTotal.add(tFee);
317     }
318     receive() external payable {}
319     function manualswap() external {
320         require(_msgSender() == _feeAddrWallet1);
321         uint256 contractBalance = balanceOf(address(this));
322         swapTokensForEth(contractBalance);
323     }
324     function manualsend() external {
325         require(_msgSender() == _feeAddrWallet1);
326         uint256 contractETHBalance = address(this).balance;
327         sendETHToFee(contractETHBalance);
328     }
329     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
330         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
331         uint256 currentRate =  _getRate();
332 
333         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
334         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
335     }
336     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
337         uint256 tFee = tAmount.mul(taxFee).div(100);
338         uint256 tTeam = tAmount.mul(TeamFee).div(100);
339         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
340         return (tTransferAmount, tFee, tTeam);
341     }
342     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
343         uint256 rAmount = tAmount.mul(currentRate);
344         uint256 rFee = tFee.mul(currentRate);
345         uint256 rTeam = tTeam.mul(currentRate);
346         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
347         return (rAmount, rTransferAmount, rFee);
348     }
349 	function _getRate() private view returns(uint256) {
350         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
351         return rSupply.div(tSupply);
352     }
353     function _getCurrentSupply() private view returns(uint256, uint256) {
354         uint256 rSupply = _rTotal;
355         uint256 tSupply = _tTotal;      
356         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
357         return (rSupply, tSupply);
358     }
359 }