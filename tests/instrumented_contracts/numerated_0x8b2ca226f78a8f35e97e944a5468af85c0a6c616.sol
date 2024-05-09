1 /**
2 ---------------------------------------------------------------------
3 Batman Token
4 T.me/BatmanERC
5 
6 Batman aspires to establish a decentralized project where the investor is an active contributor to the project. All investors in the pack will be working together to reach the moon and beyond. Every investor is able to vote and create ideas that can improve the ecosystem. Every investor has a chance to build on the project with other contributors. 
7 
8 🦇1% Redistribution 
9 🦇4% Marketing 
10 🦇5% Game Development
11 🔓Contract locked via team.finance
12 */
13 
14 // SPDX-License-Identifier: Unlicensed
15 
16 pragma solidity ^0.8.4;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 
71 }
72 
73 contract Ownable is Context {
74     address private _owner;
75     address private _previousOwner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }  
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract batman  is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _rOwned;
127     mapping (address => uint256) private _tOwned;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     mapping (address => uint) private cooldown;
132     uint256 private constant MAX = ~uint256(0);
133     uint256 private constant _tTotal = 75000000000  * 10**9;
134     uint256 private _rTotal = (MAX - (MAX % _tTotal));
135     uint256 private _tFeeTotal;
136     
137     uint256 private _feeAddr1;
138     uint256 private _feeAddr2;
139     address payable private _feeAddrWallet1;
140     address payable private _feeAddrWallet2;
141     address payable private _feeAddrWallet3;
142     
143     string private constant _name = "BATMAN";
144     string private constant _symbol = "BATMAN";
145     uint8 private constant _decimals = 9;
146     
147     IUniswapV2Router02 private uniswapV2Router;
148     address private uniswapV2Pair;
149     bool private tradingOpen;
150     bool private inSwap = false;
151     bool private swapEnabled = false;
152     bool private cooldownEnabled = false;
153     uint256 private _maxTxAmount = _tTotal;
154     event MaxTxAmountUpdated(uint _maxTxAmount);
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160     constructor () {
161         _feeAddrWallet1 = payable(0xf2737058C34f46588C0190C54c3a681081D1869E);
162         _feeAddrWallet2 = payable(0xf2737058C34f46588C0190C54c3a681081D1869E);
163         _feeAddrWallet3 = payable(0xf2737058C34f46588C0190C54c3a681081D1869E);
164         _rOwned[address(this)] = _rTotal;
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         _isExcludedFromFee[_feeAddrWallet1] = true;
168         emit Transfer(address(0), address(this), _tTotal);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return tokenFromReflection(_rOwned[account]);
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
211     function setCooldownEnabled(bool onoff) external onlyOwner() {
212         cooldownEnabled = onoff;
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
229         require(amount > 0, "Transfer amount must be greater than zero");
230         require(!bots[from]);
231         if (from != address(this)) {
232             _feeAddr1 = 1;
233             _feeAddr2 = 9;
234             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
235                 // Cooldown
236                 require(amount <= _maxTxAmount);
237             }
238 
239             uint256 contractTokenBalance = balanceOf(address(this));
240             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
241                 swapTokensForEth(contractTokenBalance);
242                 uint256 contractETHBalance = address(this).balance;
243                 if(contractETHBalance > 300000000000000000) {
244                     sendETHToFee(address(this).balance);
245                 }
246             }
247         }
248 		
249         _tokenTransfer(from,to,amount);
250     }
251 
252     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
253         address[] memory path = new address[](2);
254         path[0] = address(this);
255         path[1] = uniswapV2Router.WETH();
256         _approve(address(this), address(uniswapV2Router), tokenAmount);
257         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
258             tokenAmount,
259             0,
260             path,
261             address(this),
262             block.timestamp
263         );
264     }
265     function liftMaxTx() external onlyOwner{
266         _maxTxAmount = _tTotal;
267     }
268     function sendETHToFee(uint256 amount) private {
269         _feeAddrWallet1.transfer(amount/3);
270         _feeAddrWallet2.transfer(amount/3);
271         _feeAddrWallet3.transfer(amount/3);
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
283         _maxTxAmount = 7500000000 * 10**9;
284         tradingOpen = true;
285         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
286     }
287     
288         
289     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
290         _transferStandard(sender, recipient, amount);
291     }
292 
293     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
294         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
295         _rOwned[sender] = _rOwned[sender].sub(rAmount);
296         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
297         _takeTeam(tTeam);
298         _reflectFee(rFee, tFee);
299         emit Transfer(sender, recipient, tTransferAmount);
300     }
301 
302     function _takeTeam(uint256 tTeam) private {
303         uint256 currentRate =  _getRate();
304         uint256 rTeam = tTeam.mul(currentRate);
305         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
306     }
307 
308     function _reflectFee(uint256 rFee, uint256 tFee) private {
309         _rTotal = _rTotal.sub(rFee);
310         _tFeeTotal = _tFeeTotal.add(tFee);
311     }
312 
313     receive() external payable {}
314     
315     function manualswap() external {
316         require(_msgSender() == _feeAddrWallet1);
317         uint256 contractBalance = balanceOf(address(this));
318         swapTokensForEth(contractBalance);
319     }
320     
321     function manualsend() external {
322         require(_msgSender() == _feeAddrWallet1);
323         uint256 contractETHBalance = address(this).balance;
324         sendETHToFee(contractETHBalance);
325     }
326     
327 
328     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
329         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
330         uint256 currentRate =  _getRate();
331         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
332         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
333     }
334 
335     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
336         uint256 tFee = tAmount.mul(taxFee).div(100);
337         uint256 tTeam = tAmount.mul(TeamFee).div(100);
338         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
339         return (tTransferAmount, tFee, tTeam);
340     }
341 
342     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
343         uint256 rAmount = tAmount.mul(currentRate);
344         uint256 rFee = tFee.mul(currentRate);
345         uint256 rTeam = tTeam.mul(currentRate);
346         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
347         return (rAmount, rTransferAmount, rFee);
348     }
349 
350 	function _getRate() private view returns(uint256) {
351         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
352         return rSupply.div(tSupply);
353     }
354 
355     function _getCurrentSupply() private view returns(uint256, uint256) {
356         uint256 rSupply = _rTotal;
357         uint256 tSupply = _tTotal;      
358         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
359         return (rSupply, tSupply);
360     }
361 }