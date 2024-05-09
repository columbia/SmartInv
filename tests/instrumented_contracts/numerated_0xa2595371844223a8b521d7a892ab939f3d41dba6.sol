1 /**
2 
3 
4 
5            _____ _______ _____ _____ _    _ _   _  ____    _____ _   _ _    _ 
6      /\   |  __ \__   __|_   _/ ____| |  | | \ | |/ __ \  |_   _| \ | | |  | |
7     /  \  | |__) | | |    | || |    | |  | |  \| | |  | |   | | |  \| | |  | |
8    / /\ \ |  _  /  | |    | || |    | |  | | . ` | |  | |   | | | . ` | |  | |
9   / ____ \| | \ \  | |   _| || |____| |__| | |\  | |__| |  _| |_| |\  | |__| |
10  /_/    \_\_|  \_\ |_|  |_____\_____|\____/|_| \_|\____/  |_____|_| \_|\____/ 
11                                                                               
12                                                                               
13 
14 Website: https://articunoinu.com/
15 Telegram: https://t.me/ArticunoInu
16 Twitter: https://twitter.com/ArticunoInu
17 
18 */
19 
20 pragma solidity ^0.8.4;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     address private _previousOwner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102 }  
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118     function addLiquidityETH(
119         address token,
120         uint amountTokenDesired,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126 }
127 
128 contract ArticunoInu is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130     mapping (address => uint256) private _rOwned;
131     mapping (address => uint256) private _tOwned;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) private _isExcludedFromFee;
134     mapping (address => bool) private bots;
135     mapping (address => uint) private cooldown;
136     uint256 private constant MAX = ~uint256(0);
137     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
138     uint256 private _rTotal = (MAX - (MAX % _tTotal));
139     uint256 private _tFeeTotal;
140     
141     uint256 private _feeAddr1;
142     uint256 private _feeAddr2;
143     address payable private _feeAddrWallet1;
144     address payable private _feeAddrWallet2;
145     
146     string private constant _name = "Articuno Inu";
147     string private constant _symbol = "ARTICUNO";
148     uint8 private constant _decimals = 9;
149     
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155     bool private cooldownEnabled = false;
156     uint256 private _maxTxAmount = _tTotal;
157     event MaxTxAmountUpdated(uint _maxTxAmount);
158     modifier lockTheSwap {
159         inSwap = true;
160         _;
161         inSwap = false;
162     }
163     constructor () {
164         _feeAddrWallet1 = payable(0xD77D362A5BdebB5C067f5991Ac5d4Efe8115943f);
165         _feeAddrWallet2 = payable(0xD77D362A5BdebB5C067f5991Ac5d4Efe8115943f);
166         _rOwned[_msgSender()] = _rTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_feeAddrWallet1] = true;
170         _isExcludedFromFee[_feeAddrWallet2] = true;
171         emit Transfer(address(0x17d76587046Bf4c96581bcfDd424668eEAb98613), _msgSender(), _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
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
231     function _transfer(address from, address to, uint256 amount) private {
232         require(from != address(0), "ERC20: transfer from the zero address");
233         require(to != address(0), "ERC20: transfer to the zero address");
234         require(amount > 0, "Transfer amount must be greater than zero");
235         _feeAddr1 = 2;
236         _feeAddr2 = 9;
237         if (from != owner() && to != owner()) {
238             require(!bots[from] && !bots[to]);
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
240                 // Cooldown
241                 require(amount <= _maxTxAmount);
242                 require(cooldown[to] < block.timestamp);
243                 cooldown[to] = block.timestamp + (30 seconds);
244             }
245             
246             
247             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
248                 _feeAddr1 = 2;
249                 _feeAddr2 = 9;
250             }
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
253                 swapTokensForEth(contractTokenBalance);
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }
260 		
261         _tokenTransfer(from,to,amount);
262     }
263 
264     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
265         address[] memory path = new address[](2);
266         path[0] = address(this);
267         path[1] = uniswapV2Router.WETH();
268         _approve(address(this), address(uniswapV2Router), tokenAmount);
269         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
270             tokenAmount,
271             0,
272             path,
273             address(this),
274             block.timestamp
275         );
276     }
277         
278     function sendETHToFee(uint256 amount) private {
279         _feeAddrWallet1.transfer(amount.div(2));
280         _feeAddrWallet2.transfer(amount.div(2));
281     }
282     
283     function openTrading() external onlyOwner() {
284         require(!tradingOpen,"trading is already open");
285         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
286         uniswapV2Router = _uniswapV2Router;
287         _approve(address(this), address(uniswapV2Router), _tTotal);
288         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
289         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
290         swapEnabled = true;
291         cooldownEnabled = true;
292         _maxTxAmount = 23000000000000000 * 10**9;
293         tradingOpen = true;
294         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
295     }
296     
297     function setBots(address[] memory bots_) public onlyOwner {
298         for (uint i = 0; i < bots_.length; i++) {
299             bots[bots_[i]] = true;
300         }
301     }
302     
303     function delBot(address notbot) public onlyOwner {
304         bots[notbot] = false;
305     }
306         
307     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
308         _transferStandard(sender, recipient, amount);
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
379 }