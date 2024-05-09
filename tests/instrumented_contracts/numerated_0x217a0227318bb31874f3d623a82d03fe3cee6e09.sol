1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-01
3 */
4 
5 /**
6 
7 AriesSwap
8 
9 http://www.ariesswap.xyz
10 https://twitter.com/AriesSwap
11 https://t.me/AriesSwap
12 
13 */
14 
15 
16 
17 pragma solidity ^0.8.7;
18 // SPDX-License-Identifier: UNLICENSED
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65 
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b > 0, errorMessage);
68         uint256 c = a / b;
69         return c;
70     }
71 
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     address private _previousOwner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99 }  
100 
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract AriesSwap is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _rOwned;
128     mapping (address => uint256) private _tOwned;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private bots;
132     mapping (address => uint) private cooldown;
133     uint256 private constant MAX = ~uint256(0);
134     uint256 private constant _tTotal = 1000000000 * 10**9;
135     uint256 private _rTotal = (MAX - (MAX % _tTotal));
136     uint256 private _tFeeTotal;
137     
138     uint256 private _feeAddr1;
139     uint256 private _feeAddr2;
140     address payable private _feeAddrWallet;
141     
142     string private constant _name = "AriesSwap";
143     string private constant _symbol = "ARIES";
144     uint8 private constant _decimals = 9;
145     
146     IUniswapV2Router02 private uniswapV2Router;
147     address private uniswapV2Pair;
148     bool private tradingOpen;
149     bool private inSwap = false;
150     bool private swapEnabled = false;
151     bool private cooldownEnabled = false;
152     uint256 private _maxTxAmount = _tTotal;
153     uint256 private _maxWalletSize = _tTotal;
154     event MaxTxAmountUpdated(uint _maxTxAmount);
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor () {
162         _feeAddrWallet = payable(0xdE79773449eB5909725fe5DD6707bD56BC41B7a1);
163         _rOwned[_msgSender()] = _rTotal;
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[_feeAddrWallet] = true;
167         emit Transfer(address(0), _msgSender(), _tTotal);
168     }
169 
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public pure override returns (uint256) {
183         return _tTotal;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return tokenFromReflection(_rOwned[account]);
188     }
189 
190     function transfer(address recipient, uint256 amount) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(address owner, address spender) public view override returns (uint256) {
196         return _allowances[owner][spender];
197     }
198 
199     function approve(address spender, uint256 amount) public override returns (bool) {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210     function setCooldownEnabled(bool onoff) external onlyOwner() {
211         cooldownEnabled = onoff;
212     }
213 
214     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
215         require(rAmount <= _rTotal, "Amount must be less than total reflections");
216         uint256 currentRate =  _getRate();
217         return rAmount.div(currentRate);
218     }
219 
220     function _approve(address owner, address spender, uint256 amount) private {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 
227     function _transfer(address from, address to, uint256 amount) private {
228         require(from != address(0), "ERC20: transfer from the zero address");
229         require(to != address(0), "ERC20: transfer to the zero address");
230         require(amount > 0, "Transfer amount must be greater than zero");
231         _feeAddr1 = 0;
232         _feeAddr2 = 3;
233         if (from != owner() && to != owner()) {
234             require(!bots[from] && !bots[to]);
235             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
236                 // Cooldown
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239                 require(cooldown[to] < block.timestamp);
240                 cooldown[to] = block.timestamp + (30 seconds);
241             }
242             
243             
244             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
245                 _feeAddr1 = 0;
246                 _feeAddr2 = 3;
247             }
248             uint256 contractTokenBalance = balanceOf(address(this));
249             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
250                 swapTokensForEth(contractTokenBalance);
251                 uint256 contractETHBalance = address(this).balance;
252                 if(contractETHBalance > 0) {
253                     sendETHToFee(address(this).balance);
254                 }
255             }
256         }
257 		
258         _tokenTransfer(from,to,amount);
259     }
260 
261     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
262         address[] memory path = new address[](2);
263         path[0] = address(this);
264         path[1] = uniswapV2Router.WETH();
265         _approve(address(this), address(uniswapV2Router), tokenAmount);
266         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
267             tokenAmount,
268             0,
269             path,
270             address(this),
271             block.timestamp
272         );
273     }
274 
275     function removeLimits() external onlyOwner{
276         _maxTxAmount = _tTotal;
277         _maxWalletSize = _tTotal;
278     }
279 
280     function changeMaxTxAmount(uint256 percentage) external onlyOwner{
281         require(percentage>0);
282         _maxTxAmount = _tTotal.mul(percentage).div(100);
283     }
284 
285     function changeMaxWalletSize(uint256 percentage) external onlyOwner{
286         require(percentage>0);
287         _maxWalletSize = _tTotal.mul(percentage).div(100);
288     }
289         
290     function sendETHToFee(uint256 amount) private {
291         _feeAddrWallet.transfer(amount);
292     }  
293 
294     function openTrading() external onlyOwner() {
295         require(!tradingOpen,"trading is already open");
296         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
297         uniswapV2Router = _uniswapV2Router;
298         _approve(address(this), address(uniswapV2Router), _tTotal);
299         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
300         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
301         swapEnabled = true;
302         cooldownEnabled = true;
303         _maxTxAmount = _tTotal.mul(20).div(1000);
304         _maxWalletSize = _tTotal.mul(30).div(1000);
305         tradingOpen = true;
306         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
307     }
308     
309     function addbot(address[] memory bots_) public onlyOwner {
310         for (uint i = 0; i < bots_.length; i++) {
311             bots[bots_[i]] = true;
312         }
313     }
314     
315     function delBot(address notbot) public onlyOwner {
316         bots[notbot] = false;
317     }
318         
319     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
320         _transferStandard(sender, recipient, amount);
321     }
322 
323     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
324         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
325         _rOwned[sender] = _rOwned[sender].sub(rAmount);
326         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
327         _takeTeam(tTeam);
328         _reflectFee(rFee, tFee);
329         emit Transfer(sender, recipient, tTransferAmount);
330     }
331 
332     function _takeTeam(uint256 tTeam) private {
333         uint256 currentRate =  _getRate();
334         uint256 rTeam = tTeam.mul(currentRate);
335         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
336     }
337 
338     function _reflectFee(uint256 rFee, uint256 tFee) private {
339         _rTotal = _rTotal.sub(rFee);
340         _tFeeTotal = _tFeeTotal.add(tFee);
341     }
342 
343     receive() external payable {}
344     
345     function manualswap() external {
346         require(_msgSender() == _feeAddrWallet);
347         uint256 contractBalance = balanceOf(address(this));
348         swapTokensForEth(contractBalance);
349     }
350     
351     function manualsend() external {
352         require(_msgSender() == _feeAddrWallet);
353         uint256 contractETHBalance = address(this).balance;
354         sendETHToFee(contractETHBalance);
355     }
356     
357 
358     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
359         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
360         uint256 currentRate =  _getRate();
361         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
362         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
363     }
364 
365     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
366         uint256 tFee = tAmount.mul(taxFee).div(100);
367         uint256 tTeam = tAmount.mul(TeamFee).div(100);
368         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
369         return (tTransferAmount, tFee, tTeam);
370     }
371 
372     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
373         uint256 rAmount = tAmount.mul(currentRate);
374         uint256 rFee = tFee.mul(currentRate);
375         uint256 rTeam = tTeam.mul(currentRate);
376         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
377         return (rAmount, rTransferAmount, rFee);
378     }
379 
380 	function _getRate() private view returns(uint256) {
381         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
382         return rSupply.div(tSupply);
383     }
384 
385     function _getCurrentSupply() private view returns(uint256, uint256) {
386         uint256 rSupply = _rTotal;
387         uint256 tSupply = _tTotal;      
388         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
389         return (rSupply, tSupply);
390     }
391 }