1 // SPDX-License-Identifier: Unlicensed
2 
3 /*
4         _      _ ___ _  _ ___ ___ 
5   _ __ (_)_ _ (_) __| || |_ _| _ )
6  | '  \| | ' \| \__ \ __ || || _ \
7  |_|_|_|_|_||_|_|___/_||_|___|___/
8                                  
9 */
10 
11 //TG: minishiberc20
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
121 contract miniSHIB  is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _rOwned;
124     mapping (address => uint256) private _tOwned;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private bots;
128     mapping (address => uint) private cooldown;
129     uint256 private constant MAX = ~uint256(0);
130     uint256 private constant _tTotal = 1000000000  * 10**9;
131     uint256 private _rTotal = (MAX - (MAX % _tTotal));
132     uint256 private _tFeeTotal;
133     
134     uint256 private _feeAddr1;
135     uint256 private _feeAddr2;
136     address payable private _feeAddrWallet1;
137     address payable private _feeAddrWallet2;
138     address payable private _feeAddrWallet3;
139     
140     string private constant _name = "miniSHIB";
141     string private constant _symbol = "miniSHIB";
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
158         _feeAddrWallet1 = payable(0x82636eE411aeD712E66C29214833275546aF508A);
159         _feeAddrWallet2 = payable(0x82636eE411aeD712E66C29214833275546aF508A);
160         _feeAddrWallet3 = payable(0x82636eE411aeD712E66C29214833275546aF508A);
161         _rOwned[address(this)] = _rTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_feeAddrWallet1] = true;
165         emit Transfer(address(0), address(this), _tTotal);
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
184     function balanceOf(address account) public view override returns (uint256) {
185         return tokenFromReflection(_rOwned[account]);
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function setCooldownEnabled(bool onoff) external onlyOwner() {
209         cooldownEnabled = onoff;
210     }
211 
212     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
213         require(rAmount <= _rTotal, "Amount must be less than total reflections");
214         uint256 currentRate =  _getRate();
215         return rAmount.div(currentRate);
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(amount > 0, "Transfer amount must be greater than zero");
227         require(!bots[from]);
228         if (from != address(this)) {
229             _feeAddr1 = 1;
230             _feeAddr2 = 7;
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
232                 // Cooldown
233                 require(amount <= _maxTxAmount);
234             }
235 
236             uint256 contractTokenBalance = balanceOf(address(this));
237             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
238                 swapTokensForEth(contractTokenBalance);
239                 uint256 contractETHBalance = address(this).balance;
240                 if(contractETHBalance > 300000000000000000) {
241                     sendETHToFee(address(this).balance);
242                 }
243             }
244         }
245 		
246         _tokenTransfer(from,to,amount);
247     }
248 
249     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
250         address[] memory path = new address[](2);
251         path[0] = address(this);
252         path[1] = uniswapV2Router.WETH();
253         _approve(address(this), address(uniswapV2Router), tokenAmount);
254         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
255             tokenAmount,
256             0,
257             path,
258             address(this),
259             block.timestamp
260         );
261     }
262     function liftMaxTx() external onlyOwner{
263         _maxTxAmount = _tTotal;
264     }
265     function sendETHToFee(uint256 amount) private {
266         _feeAddrWallet1.transfer(amount/3);
267         _feeAddrWallet2.transfer(amount/3);
268         _feeAddrWallet3.transfer(amount/3);
269     }
270     
271     function openTrading() external onlyOwner() {
272         require(!tradingOpen,"trading is already open");
273         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
274         uniswapV2Router = _uniswapV2Router;
275         _approve(address(this), address(uniswapV2Router), _tTotal);
276         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
277         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
278         swapEnabled = true;
279         cooldownEnabled = true;
280         _maxTxAmount = 10000000* 10**9;
281         tradingOpen = true;
282         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
283     }
284     
285         
286     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
287         _transferStandard(sender, recipient, amount);
288     }
289 
290     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
291         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
292         _rOwned[sender] = _rOwned[sender].sub(rAmount);
293         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
294         _takeTeam(tTeam);
295         _reflectFee(rFee, tFee);
296         emit Transfer(sender, recipient, tTransferAmount);
297     }
298 
299     function _takeTeam(uint256 tTeam) private {
300         uint256 currentRate =  _getRate();
301         uint256 rTeam = tTeam.mul(currentRate);
302         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
303     }
304 
305     function _reflectFee(uint256 rFee, uint256 tFee) private {
306         _rTotal = _rTotal.sub(rFee);
307         _tFeeTotal = _tFeeTotal.add(tFee);
308     }
309 
310     receive() external payable {}
311     
312     function manualswap() external {
313         require(_msgSender() == _feeAddrWallet1);
314         uint256 contractBalance = balanceOf(address(this));
315         swapTokensForEth(contractBalance);
316     }
317     
318     function manualsend() external {
319         require(_msgSender() == _feeAddrWallet1);
320         uint256 contractETHBalance = address(this).balance;
321         sendETHToFee(contractETHBalance);
322     }
323     
324 
325     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
326         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
327         uint256 currentRate =  _getRate();
328         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
329         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
330     }
331 
332     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
333         uint256 tFee = tAmount.mul(taxFee).div(100);
334         uint256 tTeam = tAmount.mul(TeamFee).div(100);
335         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
336         return (tTransferAmount, tFee, tTeam);
337     }
338 
339     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
340         uint256 rAmount = tAmount.mul(currentRate);
341         uint256 rFee = tFee.mul(currentRate);
342         uint256 rTeam = tTeam.mul(currentRate);
343         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
344         return (rAmount, rTransferAmount, rFee);
345     }
346 
347 	function _getRate() private view returns(uint256) {
348         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
349         return rSupply.div(tSupply);
350     }
351 
352     function _getCurrentSupply() private view returns(uint256, uint256) {
353         uint256 rSupply = _rTotal;
354         uint256 tSupply = _tTotal;      
355         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
356         return (rSupply, tSupply);
357     }
358 }