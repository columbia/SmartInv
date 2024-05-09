1 /**
2 
3  _______  _       _________ _______  _______ 
4 (  ___  )| \    /\\__   __/(  ____ )(  ___  )
5 | (   ) ||  \  / /   ) (   | (    )|| (   ) |
6 | (___) ||  (_/ /    | |   | (____)|| (___) |
7 |  ___  ||   _ (     | |   |     __)|  ___  |
8 | (   ) ||  ( \ \    | |   | (\ (   | (   ) |
9 | )   ( ||  /  \ \___) (___| ) \ \__| )   ( |
10 |/     \||_/    \/\_______/|/   \__/|/     \|
11                                              
12                                        
13 
14 ---------------------------------------------------------------------------
15 AKIRA ERC20 
16 www.AkiraERC.com
17 t.me/AkiraERC
18 
19 Tokenomics
20 Supply: 10,000,000,000
21 Max TXN: 8%
22 1% Redistrubiton
23 9% Marketing/Dev
24 100% Locked
25 Renounced Contract
26 ---------------------------------------------------------------------------
27 
28 */
29 
30 // SPDX-License-Identifier: Unlicensed
31 
32 pragma solidity ^0.8.4;
33 
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 }
39 
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address account) external view returns (uint256);
43     function transfer(address recipient, uint256 amount) external returns (bool);
44     function allowance(address owner, address spender) external view returns (uint256);
45     function approve(address spender, uint256 amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 library SafeMath {
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65         return c;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         if (a == 0) {
70             return 0;
71         }
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74         return c;
75     }
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b > 0, errorMessage);
83         uint256 c = a / b;
84         return c;
85     }
86 
87 }
88 
89 contract Ownable is Context {
90     address private _owner;
91     address private _previousOwner;
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     constructor () {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 
114 }  
115 
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB) external returns (address pair);
118 }
119 
120 interface IUniswapV2Router02 {
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external;
128     function factory() external pure returns (address);
129     function WETH() external pure returns (address);
130     function addLiquidityETH(
131         address token,
132         uint amountTokenDesired,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
138 }
139 
140 contract AKIRA  is Context, IERC20, Ownable {
141     using SafeMath for uint256;
142     mapping (address => uint256) private _rOwned;
143     mapping (address => uint256) private _tOwned;
144     mapping (address => mapping (address => uint256)) private _allowances;
145     mapping (address => bool) private _isExcludedFromFee;
146     mapping (address => bool) private bots;
147     mapping (address => uint) private cooldown;
148     uint256 private constant MAX = ~uint256(0);
149     uint256 private constant _tTotal = 10000000000  * 10**9;
150     uint256 private _rTotal = (MAX - (MAX % _tTotal));
151     uint256 private _tFeeTotal;
152     
153     uint256 private _feeAddr1;
154     uint256 private _feeAddr2;
155     address payable private _feeAddrWallet1;
156     address payable private _feeAddrWallet2;
157     address payable private _feeAddrWallet3;
158     
159     string private constant _name = "AKIRA";
160     string private constant _symbol = "AKIRA";
161     uint8 private constant _decimals = 9;
162     
163     IUniswapV2Router02 private uniswapV2Router;
164     address private uniswapV2Pair;
165     bool private tradingOpen;
166     bool private inSwap = false;
167     bool private swapEnabled = false;
168     bool private cooldownEnabled = false;
169     uint256 private _maxTxAmount = _tTotal;
170     event MaxTxAmountUpdated(uint _maxTxAmount);
171     modifier lockTheSwap {
172         inSwap = true;
173         _;
174         inSwap = false;
175     }
176     constructor () {
177         _feeAddrWallet1 = payable(0xE8A7d88390ebE184ABF5227e43Aa54Da9653128e);
178         _feeAddrWallet2 = payable(0xE8A7d88390ebE184ABF5227e43Aa54Da9653128e);
179         _feeAddrWallet3 = payable(0xE8A7d88390ebE184ABF5227e43Aa54Da9653128e);
180         _rOwned[address(this)] = _rTotal;
181         _isExcludedFromFee[owner()] = true;
182         _isExcludedFromFee[address(this)] = true;
183         _isExcludedFromFee[_feeAddrWallet1] = true;
184         emit Transfer(address(0), address(this), _tTotal);
185     }
186 
187     function name() public pure returns (string memory) {
188         return _name;
189     }
190 
191     function symbol() public pure returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public pure returns (uint8) {
196         return _decimals;
197     }
198 
199     function totalSupply() public pure override returns (uint256) {
200         return _tTotal;
201     }
202 
203     function balanceOf(address account) public view override returns (uint256) {
204         return tokenFromReflection(_rOwned[account]);
205     }
206 
207     function transfer(address recipient, uint256 amount) public override returns (bool) {
208         _transfer(_msgSender(), recipient, amount);
209         return true;
210     }
211 
212     function allowance(address owner, address spender) public view override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     function approve(address spender, uint256 amount) public override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
222         _transfer(sender, recipient, amount);
223         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
224         return true;
225     }
226 
227     function setCooldownEnabled(bool onoff) external onlyOwner() {
228         cooldownEnabled = onoff;
229     }
230 
231     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
232         require(rAmount <= _rTotal, "Amount must be less than total reflections");
233         uint256 currentRate =  _getRate();
234         return rAmount.div(currentRate);
235     }
236 
237     function _approve(address owner, address spender, uint256 amount) private {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240         _allowances[owner][spender] = amount;
241         emit Approval(owner, spender, amount);
242     }
243 
244     function _transfer(address from, address to, uint256 amount) private {
245         require(amount > 0, "Transfer amount must be greater than zero");
246         require(!bots[from]);
247         if (from != address(this)) {
248             _feeAddr1 = 1;
249             _feeAddr2 = 9;
250             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
251                 // Cooldown
252                 require(amount <= _maxTxAmount);
253             }
254 
255             uint256 contractTokenBalance = balanceOf(address(this));
256             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
257                 swapTokensForEth(contractTokenBalance);
258                 uint256 contractETHBalance = address(this).balance;
259                 if(contractETHBalance > 300000000000000000) {
260                     sendETHToFee(address(this).balance);
261                 }
262             }
263         }
264 		
265         _tokenTransfer(from,to,amount);
266     }
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
281     function liftMaxTx() external onlyOwner{
282         _maxTxAmount = _tTotal;
283     }
284     function sendETHToFee(uint256 amount) private {
285         _feeAddrWallet1.transfer(amount/3);
286         _feeAddrWallet2.transfer(amount/3);
287         _feeAddrWallet3.transfer(amount/3);
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
299         _maxTxAmount = 800000000 * 10**9;
300         tradingOpen = true;
301         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
302     }
303     
304         
305     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
306         _transferStandard(sender, recipient, amount);
307     }
308 
309     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
310         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
311         _rOwned[sender] = _rOwned[sender].sub(rAmount);
312         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
313         _takeTeam(tTeam);
314         _reflectFee(rFee, tFee);
315         emit Transfer(sender, recipient, tTransferAmount);
316     }
317 
318     function _takeTeam(uint256 tTeam) private {
319         uint256 currentRate =  _getRate();
320         uint256 rTeam = tTeam.mul(currentRate);
321         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
322     }
323 
324     function _reflectFee(uint256 rFee, uint256 tFee) private {
325         _rTotal = _rTotal.sub(rFee);
326         _tFeeTotal = _tFeeTotal.add(tFee);
327     }
328 
329     receive() external payable {}
330     
331     function manualswap() external {
332         require(_msgSender() == _feeAddrWallet1);
333         uint256 contractBalance = balanceOf(address(this));
334         swapTokensForEth(contractBalance);
335     }
336     
337     function manualsend() external {
338         require(_msgSender() == _feeAddrWallet1);
339         uint256 contractETHBalance = address(this).balance;
340         sendETHToFee(contractETHBalance);
341     }
342     
343 
344     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
345         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
346         uint256 currentRate =  _getRate();
347         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
348         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
349     }
350 
351     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
352         uint256 tFee = tAmount.mul(taxFee).div(100);
353         uint256 tTeam = tAmount.mul(TeamFee).div(100);
354         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
355         return (tTransferAmount, tFee, tTeam);
356     }
357 
358     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
359         uint256 rAmount = tAmount.mul(currentRate);
360         uint256 rFee = tFee.mul(currentRate);
361         uint256 rTeam = tTeam.mul(currentRate);
362         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
363         return (rAmount, rTransferAmount, rFee);
364     }
365 
366 	function _getRate() private view returns(uint256) {
367         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
368         return rSupply.div(tSupply);
369     }
370 
371     function _getCurrentSupply() private view returns(uint256, uint256) {
372         uint256 rSupply = _rTotal;
373         uint256 tSupply = _tTotal;      
374         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
375         return (rSupply, tSupply);
376     }
377 }