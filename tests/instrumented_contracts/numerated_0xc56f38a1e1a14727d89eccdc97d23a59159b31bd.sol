1 /**
2  
3  Beavis and Butthead Moonshot!!!
4  $BBH
5  TG: https://t.me/BeavisAndButtHeadETH
6  
7      ________________                                 ______________
8     /                \                               / /            \-___
9    / /          \ \   \                             |     -    -         \
10    |                  |                             | /         -   \  _  |
11   /                  /                              \    /  /   //    __   \
12  |      ___\ \| | / /                                \/ // // / ///  /      \
13  |      /         \                                  |             //\ __   |
14  |      |           \                                \              ///     \
15 /       |      _    |                                 \               //  \ |
16 |       |       \   |                                  \   /--          //  |
17 |       |       _\ /|                                   / (o-            / \|
18 |      __\     <_o)\o-                                 /            __   /\ |
19 |     |             \                                 /               )  /  |
20  \    ||             \                               /   __          |/ / \ |
21   |   |__          _  \                             (____ *)         -  |   |
22   |   |           (*___)                                /               |   |
23   |   |       _     |                                   (____            |  |
24   |   |    //_______/                                     ####\           | |
25   |  /       | UUUUU__                                    ____/ )         |_/
26    \|        \_nnnnnn_\-\                                 (___             /
27     |       ____________/                                  \____          |
28     |      /                                                  \           |
29     |_____/                                                    \___________\
30 
31    /\/\/\/\/\/\/\/\/\                            /\/\/\/\/\/\/\/\/\/\/\/\/\
32   /                  \                          /                          \
33  <     B E A V I S    >          AND           <     B U T T - H E A D      >
34   \                  /                          \                          /
35    \/\/\/\/\/\/\/\/\/                            \/\/\/\/\/\/\/\/\/\/\/\/\/
36    
37    
38 */
39 
40 pragma solidity ^0.8.4;
41 // SPDX-License-Identifier: UNLICENSED
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 }
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 library SafeMath {
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73         return c;
74     }
75 
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         if (a == 0) {
78             return 0;
79         }
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82         return c;
83     }
84 
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b > 0, errorMessage);
91         uint256 c = a / b;
92         return c;
93     }
94 
95 }
96 
97 contract Ownable is Context {
98     address private _owner;
99     address private _previousOwner;
100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     constructor () {
103         address msgSender = _msgSender();
104         _owner = msgSender;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107 
108     function owner() public view returns (address) {
109         return _owner;
110     }
111 
112     modifier onlyOwner() {
113         require(_owner == _msgSender(), "Ownable: caller is not the owner");
114         _;
115     }
116 
117     function renounceOwnership() public virtual onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121 
122 }  
123 
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB) external returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136     function factory() external pure returns (address);
137     function WETH() external pure returns (address);
138     function addLiquidityETH(
139         address token,
140         uint amountTokenDesired,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
146 }
147 
148 contract BeavisButtHead is Context, IERC20, Ownable {
149     using SafeMath for uint256;
150     mapping (address => uint256) private _rOwned;
151     mapping (address => uint256) private _tOwned;
152     mapping (address => mapping (address => uint256)) private _allowances;
153     mapping (address => bool) private _isExcludedFromFee;
154     mapping (address => bool) private bots;
155     mapping (address => uint) private cooldown;
156     uint256 private constant MAX = ~uint256(0);
157     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
158     uint256 private _rTotal = (MAX - (MAX % _tTotal));
159     uint256 private _tFeeTotal;
160     
161     uint256 private _feeAddr1;
162     uint256 private _feeAddr2;
163     address payable private _feeAddrWallet1;
164     address payable private _feeAddrWallet2;
165     
166     string private constant _name = "Beavis and Butthead";
167     string private constant _symbol = "$BBH";
168     uint8 private constant _decimals = 9;
169     
170     IUniswapV2Router02 private uniswapV2Router;
171     address private uniswapV2Pair;
172     bool private tradingOpen;
173     bool private inSwap = false;
174     bool private swapEnabled = false;
175     bool private cooldownEnabled = false;
176     uint256 private _maxTxAmount = _tTotal;
177     event MaxTxAmountUpdated(uint _maxTxAmount);
178     modifier lockTheSwap {
179         inSwap = true;
180         _;
181         inSwap = false;
182     }
183     constructor () {
184         _feeAddrWallet1 = payable(0x533fB11d7BB5A80631f81529aa69FDE6481468de);
185         _feeAddrWallet2 = payable(0x533fB11d7BB5A80631f81529aa69FDE6481468de);
186         _rOwned[_msgSender()] = _rTotal;
187         _isExcludedFromFee[owner()] = true;
188         _isExcludedFromFee[address(this)] = true;
189         _isExcludedFromFee[_feeAddrWallet1] = true;
190         _isExcludedFromFee[_feeAddrWallet2] = true;
191         emit Transfer(address(0x44e546987C2bD48FC3AFD034354628cD442AFbc6), _msgSender(), _tTotal);
192     }
193 
194     function name() public pure returns (string memory) {
195         return _name;
196     }
197 
198     function symbol() public pure returns (string memory) {
199         return _symbol;
200     }
201 
202     function decimals() public pure returns (uint8) {
203         return _decimals;
204     }
205 
206     function totalSupply() public pure override returns (uint256) {
207         return _tTotal;
208     }
209 
210     function balanceOf(address account) public view override returns (uint256) {
211         return tokenFromReflection(_rOwned[account]);
212     }
213 
214     function transfer(address recipient, uint256 amount) public override returns (bool) {
215         _transfer(_msgSender(), recipient, amount);
216         return true;
217     }
218 
219     function allowance(address owner, address spender) public view override returns (uint256) {
220         return _allowances[owner][spender];
221     }
222 
223     function approve(address spender, uint256 amount) public override returns (bool) {
224         _approve(_msgSender(), spender, amount);
225         return true;
226     }
227 
228     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
229         _transfer(sender, recipient, amount);
230         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
231         return true;
232     }
233 
234     function setCooldownEnabled(bool onoff) external onlyOwner() {
235         cooldownEnabled = onoff;
236     }
237 
238     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
239         require(rAmount <= _rTotal, "Amount must be less than total reflections");
240         uint256 currentRate =  _getRate();
241         return rAmount.div(currentRate);
242     }
243 
244     function _approve(address owner, address spender, uint256 amount) private {
245         require(owner != address(0), "ERC20: approve from the zero address");
246         require(spender != address(0), "ERC20: approve to the zero address");
247         _allowances[owner][spender] = amount;
248         emit Approval(owner, spender, amount);
249     }
250 
251     function _transfer(address from, address to, uint256 amount) private {
252         require(from != address(0), "ERC20: transfer from the zero address");
253         require(to != address(0), "ERC20: transfer to the zero address");
254         require(amount > 0, "Transfer amount must be greater than zero");
255         _feeAddr1 = 2;
256         _feeAddr2 = 8;
257         if (from != owner() && to != owner()) {
258             require(!bots[from] && !bots[to]);
259             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
260                 // Cooldown
261                 require(amount <= _maxTxAmount);
262                 require(cooldown[to] < block.timestamp);
263                 cooldown[to] = block.timestamp + (30 seconds);
264             }
265             
266             
267             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
268                 _feeAddr1 = 2;
269                 _feeAddr2 = 10;
270             }
271             uint256 contractTokenBalance = balanceOf(address(this));
272             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
273                 swapTokensForEth(contractTokenBalance);
274                 uint256 contractETHBalance = address(this).balance;
275                 if(contractETHBalance > 0) {
276                     sendETHToFee(address(this).balance);
277                 }
278             }
279         }
280 		
281         _tokenTransfer(from,to,amount);
282     }
283 
284     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
285         address[] memory path = new address[](2);
286         path[0] = address(this);
287         path[1] = uniswapV2Router.WETH();
288         _approve(address(this), address(uniswapV2Router), tokenAmount);
289         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
290             tokenAmount,
291             0,
292             path,
293             address(this),
294             block.timestamp
295         );
296     }
297         
298     function sendETHToFee(uint256 amount) private {
299         _feeAddrWallet1.transfer(amount.div(2));
300         _feeAddrWallet2.transfer(amount.div(2));
301     }
302     
303     function openTrading() external onlyOwner() {
304         require(!tradingOpen,"trading is already open");
305         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         uniswapV2Router = _uniswapV2Router;
307         _approve(address(this), address(uniswapV2Router), _tTotal);
308         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
309         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
310         swapEnabled = true;
311         cooldownEnabled = true;
312         _maxTxAmount = 50000000000000000 * 10**9;
313         tradingOpen = true;
314         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
315     }
316     
317     function setBots(address[] memory bots_) public onlyOwner {
318         for (uint i = 0; i < bots_.length; i++) {
319             bots[bots_[i]] = true;
320         }
321     }
322     
323     function delBot(address notbot) public onlyOwner {
324         bots[notbot] = false;
325     }
326         
327     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
328         _transferStandard(sender, recipient, amount);
329     }
330 
331     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
332         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
333         _rOwned[sender] = _rOwned[sender].sub(rAmount);
334         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
335         _takeTeam(tTeam);
336         _reflectFee(rFee, tFee);
337         emit Transfer(sender, recipient, tTransferAmount);
338     }
339 
340     function _takeTeam(uint256 tTeam) private {
341         uint256 currentRate =  _getRate();
342         uint256 rTeam = tTeam.mul(currentRate);
343         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
344     }
345 
346     function _reflectFee(uint256 rFee, uint256 tFee) private {
347         _rTotal = _rTotal.sub(rFee);
348         _tFeeTotal = _tFeeTotal.add(tFee);
349     }
350 
351     receive() external payable {}
352     
353     function manualswap() external {
354         require(_msgSender() == _feeAddrWallet1);
355         uint256 contractBalance = balanceOf(address(this));
356         swapTokensForEth(contractBalance);
357     }
358     
359     function manualsend() external {
360         require(_msgSender() == _feeAddrWallet1);
361         uint256 contractETHBalance = address(this).balance;
362         sendETHToFee(contractETHBalance);
363     }
364     
365 
366     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
367         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
368         uint256 currentRate =  _getRate();
369         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
370         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
371     }
372 
373     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
374         uint256 tFee = tAmount.mul(taxFee).div(100);
375         uint256 tTeam = tAmount.mul(TeamFee).div(100);
376         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
377         return (tTransferAmount, tFee, tTeam);
378     }
379 
380     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
381         uint256 rAmount = tAmount.mul(currentRate);
382         uint256 rFee = tFee.mul(currentRate);
383         uint256 rTeam = tTeam.mul(currentRate);
384         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
385         return (rAmount, rTransferAmount, rFee);
386     }
387 
388 	function _getRate() private view returns(uint256) {
389         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
390         return rSupply.div(tSupply);
391     }
392 
393     function _getCurrentSupply() private view returns(uint256, uint256) {
394         uint256 rSupply = _rTotal;
395         uint256 tSupply = _tTotal;      
396         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
397         return (rSupply, tSupply);
398     }
399 }