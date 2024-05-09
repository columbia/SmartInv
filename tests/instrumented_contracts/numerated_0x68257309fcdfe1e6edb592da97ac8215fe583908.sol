1 /**
2  * 
3  * 
4  * !! Welcome to Gorilla Inu !!
5  * 
6  *   The king of all ape inus
7  * 
8  * 
9  * A meme coin from and for r/WallStreetBetsCrypto
10  * 
11  * 
12  * Apes Together Strong!
13  * 
14  * 
15 */
16 
17 
18 
19 /**
20  //SPDX-License-Identifier: UNLICENSED
21  
22 */
23 
24 pragma solidity ^0.8.4;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 library SafeMath {
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57         return c;
58     }
59 
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         if (a == 0) {
62             return 0;
63         }
64         uint256 c = a * b;
65         require(c / a == b, "SafeMath: multiplication overflow");
66         return c;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return div(a, b, "SafeMath: division by zero");
71     }
72 
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76         return c;
77     }
78 
79 }
80 
81 contract Ownable is Context {
82     address private _owner;
83     address private _previousOwner;
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86     constructor () {
87         address msgSender = _msgSender();
88         _owner = msgSender;
89         emit OwnershipTransferred(address(0), msgSender);
90     }
91 
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     modifier onlyOwner() {
97         require(_owner == _msgSender(), "Ownable: caller is not the owner");
98         _;
99     }
100 
101     function renounceOwnership() public virtual onlyOwner {
102         emit OwnershipTransferred(_owner, address(0));
103         _owner = address(0);
104     }
105 
106 }  
107 
108 interface IUniswapV2Factory {
109     function createPair(address tokenA, address tokenB) external returns (address pair);
110 }
111 
112 interface IUniswapV2Router02 {
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120     function factory() external pure returns (address);
121     function WETH() external pure returns (address);
122     function addLiquidityETH(
123         address token,
124         uint amountTokenDesired,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline
129     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
130 }
131 
132 contract GorillaInu is Context, IERC20, Ownable {
133     using SafeMath for uint256;
134     mapping (address => uint256) private _rOwned;
135     mapping (address => uint256) private _tOwned;
136     mapping (address => mapping (address => uint256)) private _allowances;
137     mapping (address => bool) private _isExcludedFromFee;
138     mapping (address => bool) private bots;
139     mapping (address => uint) private cooldown;
140     uint256 private constant MAX = ~uint256(0);
141     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
142     uint256 private _rTotal = (MAX - (MAX % _tTotal));
143     uint256 private _tFeeTotal;
144     
145     uint256 private _feeAddr1;
146     uint256 private _feeAddr2;
147     address payable private _feeAddrWallet1;
148     address payable private _feeAddrWallet2;
149     
150     string private constant _name = "Gorilla Inu | Apes Together Strong";
151     string private constant _symbol = "Gorilla Inu";
152     uint8 private constant _decimals = 9;
153     
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159     bool private cooldownEnabled = false;
160     uint256 private _maxTxAmount = _tTotal;
161     event MaxTxAmountUpdated(uint _maxTxAmount);
162     modifier lockTheSwap {
163         inSwap = true;
164         _;
165         inSwap = false;
166     }
167     constructor () {
168         _feeAddrWallet1 = payable(0x0E41F2B9BF724392a60e5B874505d3b82C27A650);   
169         _feeAddrWallet2 = payable(0x0E41F2B9BF724392a60e5B874505d3b82C27A650);
170         _rOwned[_msgSender()] = _rTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_feeAddrWallet1] = true;
174         _isExcludedFromFee[_feeAddrWallet2] = true;
175         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);  
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return tokenFromReflection(_rOwned[account]);
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function setCooldownEnabled(bool onoff) external onlyOwner() {
219         cooldownEnabled = onoff;
220     }
221 
222     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
223         require(rAmount <= _rTotal, "Amount must be less than total reflections");
224         uint256 currentRate =  _getRate();
225         return rAmount.div(currentRate);
226     }
227 
228     function _approve(address owner, address spender, uint256 amount) private {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 
235     function _transfer(address from, address to, uint256 amount) private {
236         require(from != address(0), "ERC20: transfer from the zero address");
237         require(to != address(0), "ERC20: transfer to the zero address");
238         require(amount > 0, "Transfer amount must be greater than zero");
239         _feeAddr1 = 1;     //
240         _feeAddr2 = 9;     //
241         if (from != owner() && to != owner()) {
242             require(!bots[from] && !bots[to]);
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
244                 // Cooldown
245                 require(amount <= _maxTxAmount);
246                 require(cooldown[to] < block.timestamp);
247                 cooldown[to] = block.timestamp + (30 seconds);
248             }
249             
250             
251             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
252                 _feeAddr1 = 1;     //
253                 _feeAddr2 = 9;     //
254             }
255             uint256 contractTokenBalance = balanceOf(address(this));
256             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
257                 swapTokensForEth(contractTokenBalance);
258                 uint256 contractETHBalance = address(this).balance;
259                 if(contractETHBalance > 0) {
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
296         _maxTxAmount = 50000000000000000 * 10**9;
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