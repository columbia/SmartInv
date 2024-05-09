1 /*
2 
3     Bunny Rocket!
4     
5     t.me/BunnyRocketToken
6     
7     (\_/)
8     ( •_•)
9     / >
10     
11 */
12 
13 
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity ^0.8.4;
18 
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
125 contract BUNNYROCKET is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _rOwned;
128     mapping (address => uint256) private _tOwned;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private bots;
132     mapping (address => uint) private cooldown;
133     uint256 private constant MAX = ~uint256(0);
134     uint256 private constant _tTotal = 1e12 * 10**9;
135     uint256 private _rTotal = (MAX - (MAX % _tTotal));
136     uint256 private _tFeeTotal;
137     
138     uint256 private _feeAddr1;
139     uint256 private _feeAddr2;
140     address payable private _feeAddrWallet1;
141     address payable private _feeAddrWallet2;
142     
143     string private constant _name = "BunnyRocket";
144     string private constant _symbol = "BUNNYROCKET";
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
161         _feeAddrWallet1 = payable(0x3c24E70546e63EEcbab35C8Ee43B2df200325cA2);
162         _feeAddrWallet2 = payable(0x3c24E70546e63EEcbab35C8Ee43B2df200325cA2);
163         _rOwned[_msgSender()] = _rTotal;
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[_feeAddrWallet1] = true;
167         _isExcludedFromFee[_feeAddrWallet2] = true;
168         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
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
229         require(from != address(0), "ERC20: transfer from the zero address");
230         require(to != address(0), "ERC20: transfer to the zero address");
231         require(amount > 0, "Transfer amount must be greater than zero");
232         _feeAddr1 = 2;
233         _feeAddr2 = 8;
234         if (from != owner() && to != owner()) {
235             require(!bots[from] && !bots[to]);
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
237                 // Cooldown
238                 require(amount <= _maxTxAmount);
239                 require(cooldown[to] < block.timestamp);
240                 cooldown[to] = block.timestamp + (30 seconds);
241             }
242             
243             
244             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
245                 _feeAddr1 = 2;
246                 _feeAddr2 = 10;
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
275     function sendETHToFee(uint256 amount) private {
276         _feeAddrWallet1.transfer(amount.div(2));
277         _feeAddrWallet2.transfer(amount.div(2));
278     }
279     
280     function openTrading() external onlyOwner() {
281         require(!tradingOpen,"trading is already open");
282         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
283         uniswapV2Router = _uniswapV2Router;
284         _approve(address(this), address(uniswapV2Router), _tTotal);
285         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
286         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
287         swapEnabled = true;
288         cooldownEnabled = true;
289         _maxTxAmount = 1e12 * 10**9;
290         tradingOpen = true;
291         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
292     }
293     
294     function setBots(address[] memory bots_) public onlyOwner {
295         for (uint i = 0; i < bots_.length; i++) {
296             bots[bots_[i]] = true;
297         }
298     }
299     
300     function removeStrictTxLimit() public onlyOwner {
301         _maxTxAmount = 1e12 * 10**9;
302     }
303     
304     function delBot(address notbot) public onlyOwner {
305         bots[notbot] = false;
306     }
307         
308     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
309         _transferStandard(sender, recipient, amount);
310     }
311 
312     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
313         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
314         _rOwned[sender] = _rOwned[sender].sub(rAmount);
315         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
316         _takeTeam(tTeam);
317         _reflectFee(rFee, tFee);
318         emit Transfer(sender, recipient, tTransferAmount);
319     }
320 
321     function _takeTeam(uint256 tTeam) private {
322         uint256 currentRate =  _getRate();
323         uint256 rTeam = tTeam.mul(currentRate);
324         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
325     }
326 
327     function _reflectFee(uint256 rFee, uint256 tFee) private {
328         _rTotal = _rTotal.sub(rFee);
329         _tFeeTotal = _tFeeTotal.add(tFee);
330     }
331 
332     receive() external payable {}
333     
334     function manualswap() external {
335         require(_msgSender() == _feeAddrWallet1);
336         uint256 contractBalance = balanceOf(address(this));
337         swapTokensForEth(contractBalance);
338     }
339     
340     function manualsend() external {
341         require(_msgSender() == _feeAddrWallet1);
342         uint256 contractETHBalance = address(this).balance;
343         sendETHToFee(contractETHBalance);
344     }
345     
346 
347     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
348         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
349         uint256 currentRate =  _getRate();
350         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
351         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
352     }
353 
354     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
355         uint256 tFee = tAmount.mul(taxFee).div(100);
356         uint256 tTeam = tAmount.mul(TeamFee).div(100);
357         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
358         return (tTransferAmount, tFee, tTeam);
359     }
360 
361     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
362         uint256 rAmount = tAmount.mul(currentRate);
363         uint256 rFee = tFee.mul(currentRate);
364         uint256 rTeam = tTeam.mul(currentRate);
365         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
366         return (rAmount, rTransferAmount, rFee);
367     }
368 
369 	function _getRate() private view returns(uint256) {
370         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
371         return rSupply.div(tSupply);
372     }
373 
374     function _getCurrentSupply() private view returns(uint256, uint256) {
375         uint256 rSupply = _rTotal;
376         uint256 tSupply = _tTotal;      
377         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
378         return (rSupply, tSupply);
379     }
380 }