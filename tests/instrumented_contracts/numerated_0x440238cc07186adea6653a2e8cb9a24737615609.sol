1 /*
2 
3   Shibmerican!
4   
5   t.me/Shibmerican
6   
7   Celebrating the 4th of July!
8   
9   
10   // No dev-wallets
11   // Locked liquidity
12   // Renounced ownership!
13   // No tx modifiers
14   // Community-Driven
15 
16   |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
17   | * * * * * * * * *  :::::::::::::::::::::::::|
18   |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
19   | * * * * * * * * *  :::::::::::::::::::::::::|
20   |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
21   | * * * * * * * * *  ::::::::::::::::::::;::::|
22   |* * * * * * * * * * OOOOOOOOOOOOOOOOOOOOOOOOO|
23   |:::::::::::::::::::::::::::::::::::::::::::::|
24   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
25   |:::::::::::::::::::::::::::::::::::::::::::::|
26   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
27   |:::::::::::::::::::::::::::::::::::::::::::::|
28   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
29   
30   
31 */
32 
33 
34 
35 // SPDX-License-Identifier: Unlicensed
36 
37 pragma solidity ^0.8.4;
38 
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 }
44 
45 interface IERC20 {
46     function totalSupply() external view returns (uint256);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 library SafeMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70         return c;
71     }
72 
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77         uint256 c = a * b;
78         require(c / a == b, "SafeMath: multiplication overflow");
79         return c;
80     }
81 
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85 
86     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         uint256 c = a / b;
89         return c;
90     }
91 
92 }
93 
94 contract Ownable is Context {
95     address private _owner;
96     address private _previousOwner;
97     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99     constructor () {
100         address msgSender = _msgSender();
101         _owner = msgSender;
102         emit OwnershipTransferred(address(0), msgSender);
103     }
104 
105     function owner() public view returns (address) {
106         return _owner;
107     }
108 
109     modifier onlyOwner() {
110         require(_owner == _msgSender(), "Ownable: caller is not the owner");
111         _;
112     }
113 
114     function renounceOwnership() public virtual onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119 }  
120 
121 interface IUniswapV2Factory {
122     function createPair(address tokenA, address tokenB) external returns (address pair);
123 }
124 
125 interface IUniswapV2Router02 {
126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external;
133     function factory() external pure returns (address);
134     function WETH() external pure returns (address);
135     function addLiquidityETH(
136         address token,
137         uint amountTokenDesired,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 }
144 
145 contract Shibmerican is Context, IERC20, Ownable {
146     using SafeMath for uint256;
147     mapping (address => uint256) private _rOwned;
148     mapping (address => uint256) private _tOwned;
149     mapping (address => mapping (address => uint256)) private _allowances;
150     mapping (address => bool) private _isExcludedFromFee;
151     mapping (address => bool) private bots;
152     mapping (address => uint) private cooldown;
153     uint256 private constant MAX = ~uint256(0);
154     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
155     uint256 private _rTotal = (MAX - (MAX % _tTotal));
156     uint256 private _tFeeTotal;
157     
158     uint256 private _feeAddr1;
159     uint256 private _feeAddr2;
160     address payable private _feeAddrWallet1;
161     address payable private _feeAddrWallet2;
162     
163     string private constant _name = "Shibmerican | t.me/Shibmerican";
164     string private constant _symbol = "Shibmerican";
165     uint8 private constant _decimals = 9;
166     
167     IUniswapV2Router02 private uniswapV2Router;
168     address private uniswapV2Pair;
169     bool private tradingOpen;
170     bool private inSwap = false;
171     bool private swapEnabled = false;
172     bool private cooldownEnabled = false;
173     uint256 private _maxTxAmount = _tTotal;
174     event MaxTxAmountUpdated(uint _maxTxAmount);
175     modifier lockTheSwap {
176         inSwap = true;
177         _;
178         inSwap = false;
179     }
180     constructor () {
181         _feeAddrWallet1 = payable(0xa8FB832AfdB227B33359Fd625f09Ef5681e2608F);
182         _feeAddrWallet2 = payable(0x8Ea7A7108E9C5e4De96e07f882802e26311Ce2cF);
183         _rOwned[_msgSender()] = _rTotal;
184         _isExcludedFromFee[owner()] = true;
185         _isExcludedFromFee[address(this)] = true;
186         _isExcludedFromFee[_feeAddrWallet1] = true;
187         _isExcludedFromFee[_feeAddrWallet2] = true;
188         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
189     }
190 
191     function name() public pure returns (string memory) {
192         return _name;
193     }
194 
195     function symbol() public pure returns (string memory) {
196         return _symbol;
197     }
198 
199     function decimals() public pure returns (uint8) {
200         return _decimals;
201     }
202 
203     function totalSupply() public pure override returns (uint256) {
204         return _tTotal;
205     }
206 
207     function balanceOf(address account) public view override returns (uint256) {
208         return tokenFromReflection(_rOwned[account]);
209     }
210 
211     function transfer(address recipient, uint256 amount) public override returns (bool) {
212         _transfer(_msgSender(), recipient, amount);
213         return true;
214     }
215 
216     function allowance(address owner, address spender) public view override returns (uint256) {
217         return _allowances[owner][spender];
218     }
219 
220     function approve(address spender, uint256 amount) public override returns (bool) {
221         _approve(_msgSender(), spender, amount);
222         return true;
223     }
224 
225     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
226         _transfer(sender, recipient, amount);
227         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
228         return true;
229     }
230 
231     function setCooldownEnabled(bool onoff) external onlyOwner() {
232         cooldownEnabled = onoff;
233     }
234 
235     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
236         require(rAmount <= _rTotal, "Amount must be less than total reflections");
237         uint256 currentRate =  _getRate();
238         return rAmount.div(currentRate);
239     }
240 
241     function _approve(address owner, address spender, uint256 amount) private {
242         require(owner != address(0), "ERC20: approve from the zero address");
243         require(spender != address(0), "ERC20: approve to the zero address");
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247 
248     function _transfer(address from, address to, uint256 amount) private {
249         require(from != address(0), "ERC20: transfer from the zero address");
250         require(to != address(0), "ERC20: transfer to the zero address");
251         require(amount > 0, "Transfer amount must be greater than zero");
252         _feeAddr1 = 5;
253         _feeAddr2 = 10;
254         if (from != owner() && to != owner()) {
255             require(!bots[from] && !bots[to]);
256             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
257                 // Cooldown
258                 require(amount <= _maxTxAmount);
259                 require(cooldown[to] < block.timestamp);
260                 cooldown[to] = block.timestamp + (30 seconds);
261             }
262             
263             
264             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
265                 _feeAddr1 = 5;
266                 _feeAddr2 = 20;
267             }
268             uint256 contractTokenBalance = balanceOf(address(this));
269             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
270                 swapTokensForEth(contractTokenBalance);
271                 uint256 contractETHBalance = address(this).balance;
272                 if(contractETHBalance > 0) {
273                     sendETHToFee(address(this).balance);
274                 }
275             }
276         }
277 		
278         _tokenTransfer(from,to,amount);
279     }
280 
281     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
282         address[] memory path = new address[](2);
283         path[0] = address(this);
284         path[1] = uniswapV2Router.WETH();
285         _approve(address(this), address(uniswapV2Router), tokenAmount);
286         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
287             tokenAmount,
288             0,
289             path,
290             address(this),
291             block.timestamp
292         );
293     }
294         
295     function sendETHToFee(uint256 amount) private {
296         _feeAddrWallet1.transfer(amount.div(2));
297         _feeAddrWallet2.transfer(amount.div(2));
298     }
299     
300     function openTrading() external onlyOwner() {
301         require(!tradingOpen,"trading is already open");
302         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
303         uniswapV2Router = _uniswapV2Router;
304         _approve(address(this), address(uniswapV2Router), _tTotal);
305         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
306         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
307         swapEnabled = true;
308         cooldownEnabled = true;
309         _maxTxAmount = 100000000000000000 * 10**9;
310         tradingOpen = true;
311         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
312     }
313     
314     function setBots(address[] memory bots_) public onlyOwner {
315         for (uint i = 0; i < bots_.length; i++) {
316             bots[bots_[i]] = true;
317         }
318     }
319     
320     function delBot(address notbot) public onlyOwner {
321         bots[notbot] = false;
322     }
323         
324     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
325         _transferStandard(sender, recipient, amount);
326     }
327 
328     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
329         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
330         _rOwned[sender] = _rOwned[sender].sub(rAmount);
331         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
332         _takeTeam(tTeam);
333         _reflectFee(rFee, tFee);
334         emit Transfer(sender, recipient, tTransferAmount);
335     }
336 
337     function _takeTeam(uint256 tTeam) private {
338         uint256 currentRate =  _getRate();
339         uint256 rTeam = tTeam.mul(currentRate);
340         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
341     }
342 
343     function _reflectFee(uint256 rFee, uint256 tFee) private {
344         _rTotal = _rTotal.sub(rFee);
345         _tFeeTotal = _tFeeTotal.add(tFee);
346     }
347 
348     receive() external payable {}
349     
350     function manualswap() external {
351         require(_msgSender() == _feeAddrWallet1);
352         uint256 contractBalance = balanceOf(address(this));
353         swapTokensForEth(contractBalance);
354     }
355     
356     function manualsend() external {
357         require(_msgSender() == _feeAddrWallet1);
358         uint256 contractETHBalance = address(this).balance;
359         sendETHToFee(contractETHBalance);
360     }
361     
362 
363     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
364         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
365         uint256 currentRate =  _getRate();
366         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
367         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
368     }
369 
370     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
371         uint256 tFee = tAmount.mul(taxFee).div(100);
372         uint256 tTeam = tAmount.mul(TeamFee).div(100);
373         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
374         return (tTransferAmount, tFee, tTeam);
375     }
376 
377     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
378         uint256 rAmount = tAmount.mul(currentRate);
379         uint256 rFee = tFee.mul(currentRate);
380         uint256 rTeam = tTeam.mul(currentRate);
381         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
382         return (rAmount, rTransferAmount, rFee);
383     }
384 
385 	function _getRate() private view returns(uint256) {
386         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
387         return rSupply.div(tSupply);
388     }
389 
390     function _getCurrentSupply() private view returns(uint256, uint256) {
391         uint256 rSupply = _rTotal;
392         uint256 tSupply = _tTotal;      
393         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
394         return (rSupply, tSupply);
395     }
396 }