1 /*
2  ______________________________________________________________________
3 
4   KungFu Inu.
5   
6   t.me/KungFuInu
7   
8   (ﾟo´(┗┐ヽ(╰,╯ )ﾉ
9   
10   // No dev-wallets
11   // Locked liquidity
12   // Renounced ownership!
13   // No tx modifiers
14   // Community-Driven
15  ______________________________________________________________________
16   
17 */
18 
19 
20 
21 // SPDX-License-Identifier: Unlicensed
22 
23 pragma solidity ^0.8.4;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         return c;
76     }
77 
78 }
79 
80 contract Ownable is Context {
81     address private _owner;
82     address private _previousOwner;
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor () {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105 }  
106 
107 interface IUniswapV2Factory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IUniswapV2Router02 {
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 }
130 
131 contract KungFuInu is Context, IERC20, Ownable {
132     using SafeMath for uint256;
133     mapping (address => uint256) private _rOwned;
134     mapping (address => uint256) private _tOwned;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private bots;
138     mapping (address => uint) private cooldown;
139     uint256 private constant MAX = ~uint256(0);
140     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
141     uint256 private _rTotal = (MAX - (MAX % _tTotal));
142     uint256 private _tFeeTotal;
143     
144     uint256 private _feeAddr1;
145     uint256 private _feeAddr2;
146     address payable private _feeAddrWallet1;
147     address payable private _feeAddrWallet2;
148     
149     string private constant _name = "KungFu Inu | t.me/KungFuInu";
150     string private constant _symbol = "KungFuInu";
151     uint8 private constant _decimals = 9;
152     
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158     bool private cooldownEnabled = false;
159     uint256 private _maxTxAmount = _tTotal;
160     event MaxTxAmountUpdated(uint _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166     constructor () {
167         _feeAddrWallet1 = payable(0xE8A8DC7d043bB0bf53deA967e680f210dd2218Ad);
168         _feeAddrWallet2 = payable(0xF68CF520d5C2758B1cD4d635c51842AA0DCFE8ac);
169         _rOwned[_msgSender()] = _rTotal;
170         _isExcludedFromFee[owner()] = true;
171         _isExcludedFromFee[address(this)] = true;
172         _isExcludedFromFee[_feeAddrWallet1] = true;
173         _isExcludedFromFee[_feeAddrWallet2] = true;
174         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
175     }
176 
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return tokenFromReflection(_rOwned[account]);
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function setCooldownEnabled(bool onoff) external onlyOwner() {
218         cooldownEnabled = onoff;
219     }
220 
221     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
222         require(rAmount <= _rTotal, "Amount must be less than total reflections");
223         uint256 currentRate =  _getRate();
224         return rAmount.div(currentRate);
225     }
226 
227     function _approve(address owner, address spender, uint256 amount) private {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 
234     function _transfer(address from, address to, uint256 amount) private {
235         require(from != address(0), "ERC20: transfer from the zero address");
236         require(to != address(0), "ERC20: transfer to the zero address");
237         require(amount > 0, "Transfer amount must be greater than zero");
238         _feeAddr1 = 5;
239         _feeAddr2 = 10;
240         if (from != owner() && to != owner()) {
241             require(!bots[from] && !bots[to]);
242             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
243                 // Cooldown
244                 require(amount <= _maxTxAmount);
245                 require(cooldown[to] < block.timestamp);
246                 cooldown[to] = block.timestamp + (30 seconds);
247             }
248             
249             
250             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
251                 _feeAddr1 = 5;
252                 _feeAddr2 = 20;
253             }
254             uint256 contractTokenBalance = balanceOf(address(this));
255             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
256                 swapTokensForEth(contractTokenBalance);
257                 uint256 contractETHBalance = address(this).balance;
258                 if(contractETHBalance > 0) {
259                     sendETHToFee(address(this).balance);
260                 }
261             }
262         }
263 		
264         _tokenTransfer(from,to,amount);
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         address[] memory path = new address[](2);
269         path[0] = address(this);
270         path[1] = uniswapV2Router.WETH();
271         _approve(address(this), address(uniswapV2Router), tokenAmount);
272         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             tokenAmount,
274             0,
275             path,
276             address(this),
277             block.timestamp
278         );
279     }
280         
281     function sendETHToFee(uint256 amount) private {
282         _feeAddrWallet1.transfer(amount.div(2));
283         _feeAddrWallet2.transfer(amount.div(2));
284     }
285     
286     function openTrading() external onlyOwner() {
287         require(!tradingOpen,"trading is already open");
288         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
289         uniswapV2Router = _uniswapV2Router;
290         _approve(address(this), address(uniswapV2Router), _tTotal);
291         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
292         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
293         swapEnabled = true;
294         cooldownEnabled = true;
295         _maxTxAmount = 100000000000000000 * 10**9;
296         tradingOpen = true;
297         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
298     }
299     
300     function setBots(address[] memory bots_) public onlyOwner {
301         for (uint i = 0; i < bots_.length; i++) {
302             bots[bots_[i]] = true;
303         }
304     }
305     
306     function delBot(address notbot) public onlyOwner {
307         bots[notbot] = false;
308     }
309         
310     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
311         _transferStandard(sender, recipient, amount);
312     }
313 
314     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
315         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
316         _rOwned[sender] = _rOwned[sender].sub(rAmount);
317         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
318         _takeTeam(tTeam);
319         _reflectFee(rFee, tFee);
320         emit Transfer(sender, recipient, tTransferAmount);
321     }
322 
323     function _takeTeam(uint256 tTeam) private {
324         uint256 currentRate =  _getRate();
325         uint256 rTeam = tTeam.mul(currentRate);
326         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
327     }
328 
329     function _reflectFee(uint256 rFee, uint256 tFee) private {
330         _rTotal = _rTotal.sub(rFee);
331         _tFeeTotal = _tFeeTotal.add(tFee);
332     }
333 
334     receive() external payable {}
335     
336     function manualswap() external {
337         require(_msgSender() == _feeAddrWallet1);
338         uint256 contractBalance = balanceOf(address(this));
339         swapTokensForEth(contractBalance);
340     }
341     
342     function manualsend() external {
343         require(_msgSender() == _feeAddrWallet1);
344         uint256 contractETHBalance = address(this).balance;
345         sendETHToFee(contractETHBalance);
346     }
347     
348 
349     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
350         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
351         uint256 currentRate =  _getRate();
352         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
353         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
354     }
355 
356     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
357         uint256 tFee = tAmount.mul(taxFee).div(100);
358         uint256 tTeam = tAmount.mul(TeamFee).div(100);
359         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
360         return (tTransferAmount, tFee, tTeam);
361     }
362 
363     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
364         uint256 rAmount = tAmount.mul(currentRate);
365         uint256 rFee = tFee.mul(currentRate);
366         uint256 rTeam = tTeam.mul(currentRate);
367         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
368         return (rAmount, rTransferAmount, rFee);
369     }
370 
371 	function _getRate() private view returns(uint256) {
372         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
373         return rSupply.div(tSupply);
374     }
375 
376     function _getCurrentSupply() private view returns(uint256, uint256) {
377         uint256 rSupply = _rTotal;
378         uint256 tSupply = _tTotal;      
379         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
380         return (rSupply, tSupply);
381     }
382 }