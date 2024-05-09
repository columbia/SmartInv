1 // SPDX-License-Identifier: UNLICENSED
2 // Twitter https://twitter.com/DaoBlackrock
3 // TG https://t.me/blackrockerc
4 // Medium https://medium.com/@blackrockdao/
5 
6 pragma solidity 0.8.7;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     address private _previousOwner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88 }
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract BlackRock is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _rOwned;
117     mapping (address => uint256) private _tOwned;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping (address => bool) private bots;
121     mapping (address => uint) private cooldown;
122     uint256 private constant MAX = ~uint256(0);
123     uint256 private constant _tTotal = 10_000_000 * 10**8;
124     uint256 private _rTotal = (MAX - (MAX % _tTotal));
125     uint256 private _tFeeTotal;
126 
127     uint256 private _feeAddr1;
128     uint256 private _feeAddr2;
129     address payable public _feeAddrWallet;
130 
131     string private constant _name = "Black Rock";
132     string private constant _symbol = "BLACKROCK";
133     uint8 private constant _decimals = 8;
134 
135     IUniswapV2Router02 private uniswapV2Router;
136     address private uniswapV2Pair;
137     bool private tradingOpen;
138     bool private inSwap = false;
139     bool private swapEnabled = false;
140     bool private cooldownEnabled = false;
141     uint256 private _maxTxAmount = 200_000 * 10**8;
142     uint256 private _maxWalletSize = 200_000 * 10**8;
143     event MaxTxAmountUpdated(uint _maxTxAmount);
144     modifier lockTheSwap {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149 
150     constructor () {
151         _feeAddrWallet = payable(_msgSender());
152         _rOwned[_msgSender()] = _rTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_feeAddrWallet] = true;
156 
157 
158         emit Transfer(address(0), _msgSender(), _tTotal);
159     }
160 
161     function name() public pure returns (string memory) {
162         return _name;
163     }
164 
165     function symbol() public pure returns (string memory) {
166         return _symbol;
167     }
168 
169     function decimals() public pure returns (uint8) {
170         return _decimals;
171     }
172 
173     function totalSupply() public pure override returns (uint256) {
174         return _tTotal;
175     }
176 
177     function balanceOf(address account) public view override returns (uint256) {
178         return tokenFromReflection(_rOwned[account]);
179     }
180 
181     function transfer(address recipient, uint256 amount) public override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     function allowance(address owner, address spender) public view override returns (uint256) {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount) public override returns (bool) {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
196         _transfer(sender, recipient, amount);
197         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
198         return true;
199     }
200 
201     function setCooldownEnabled(bool onoff) external onlyOwner() {
202         cooldownEnabled = onoff;
203     }
204 
205     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
206         require(rAmount <= _rTotal, "Amount must be less than total reflections");
207         uint256 currentRate =  _getRate();
208         return rAmount.div(currentRate);
209     }
210 
211     function _approve(address owner, address spender, uint256 amount) private {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218     function _transfer(address from, address to, uint256 amount) private {
219         require(from != address(0), "ERC20: transfer from the zero address");
220         require(to != address(0), "ERC20: transfer to the zero address");
221         require(amount > 0, "Transfer amount must be greater than zero");
222 
223 
224         if (from != owner() && to != owner()) {
225             require(!bots[from] && !bots[to]);
226             _feeAddr1 = 0;
227             _feeAddr2 = 6;
228             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
229                 // Cooldown
230                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
231                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
232                 _feeAddr1 = 0;
233                 _feeAddr2 = 0;
234             }
235 
236 
237             uint256 contractTokenBalance = balanceOf(address(this));
238             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 ) {
239                 swapTokensForEth(contractTokenBalance);
240                 uint256 contractETHBalance = address(this).balance;
241                 if(contractETHBalance > 0) {
242                     sendETHToFee(address(this).balance);
243                 }
244             }
245         }else{
246           _feeAddr1 = 0;
247           _feeAddr2 = 0;
248         }
249 
250         _tokenTransfer(from,to,amount);
251     }
252 
253     function setTaxWallet(address newTaxWallet) external {
254       require(_msgSender()==_feeAddrWallet);
255       _feeAddrWallet=payable(newTaxWallet);
256     }
257 
258     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
259         address[] memory path = new address[](2);
260         path[0] = address(this);
261         path[1] = uniswapV2Router.WETH();
262         _approve(address(this), address(uniswapV2Router), tokenAmount);
263         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
264             tokenAmount,
265             0,
266             path,
267             address(this),
268             block.timestamp
269         );
270     }
271 
272 
273     function removeLimits() external onlyOwner{
274         _maxTxAmount = _tTotal;
275         _maxWalletSize = _tTotal;
276     }
277 
278     function sendETHToFee(uint256 amount) private {
279         _feeAddrWallet.transfer(amount);
280     }
281 
282     function addBots(address[] memory bots_) public onlyOwner {
283         for (uint i = 0; i < bots_.length; i++) {
284             bots[bots_[i]] = true;
285         }
286     }
287 
288     function delBots(address[] memory notbot) public onlyOwner {
289       for (uint i = 0; i < notbot.length; i++) {
290           bots[notbot[i]] = false;
291       }
292 
293     }
294 
295     function openTrading() external onlyOwner() {
296         require(!tradingOpen,"trading is already open");
297         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
298         uniswapV2Router = _uniswapV2Router;
299         _approve(address(this), address(uniswapV2Router), _tTotal);
300         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
301         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
302         swapEnabled = true;
303         cooldownEnabled = true;
304 
305         tradingOpen = true;
306         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
307     }
308 
309     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
310         _transferStandard(sender, recipient, amount);
311     }
312 
313     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
314         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
315         _rOwned[sender] = _rOwned[sender].sub(rAmount);
316         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
317         _takeTeam(tTeam);
318         _reflectFee(rFee, tFee);
319         emit Transfer(sender, recipient, tTransferAmount);
320     }
321 
322     function _takeTeam(uint256 tTeam) private {
323         uint256 currentRate =  _getRate();
324         uint256 rTeam = tTeam.mul(currentRate);
325         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
326     }
327 
328     function _reflectFee(uint256 rFee, uint256 tFee) private {
329         _rTotal = _rTotal.sub(rFee);
330         _tFeeTotal = _tFeeTotal.add(tFee);
331     }
332 
333     receive() external payable {}
334 
335     function manualswap() external {
336         require(_msgSender() == _feeAddrWallet);
337         uint256 contractBalance = balanceOf(address(this));
338         swapTokensForEth(contractBalance);
339     }
340 
341     function manualsend() external {
342         require(_msgSender() == _feeAddrWallet);
343         uint256 contractETHBalance = address(this).balance;
344         sendETHToFee(contractETHBalance);
345     }
346 
347 
348     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
349         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
350         uint256 currentRate =  _getRate();
351         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
352         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
353     }
354 
355     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
356         uint256 tFee = tAmount.mul(taxFee).div(100);
357         uint256 tTeam = tAmount.mul(TeamFee).div(100);
358         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
359         return (tTransferAmount, tFee, tTeam);
360     }
361 
362     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
363         uint256 rAmount = tAmount.mul(currentRate);
364         uint256 rFee = tFee.mul(currentRate);
365         uint256 rTeam = tTeam.mul(currentRate);
366         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
367         return (rAmount, rTransferAmount, rFee);
368     }
369 
370 	function _getRate() private view returns(uint256) {
371         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
372         return rSupply.div(tSupply);
373     }
374 
375     function _getCurrentSupply() private view returns(uint256, uint256) {
376         uint256 rSupply = _rTotal;
377         uint256 tSupply = _tTotal;
378         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
379         return (rSupply, tSupply);
380     }
381 }