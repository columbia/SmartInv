1 /**
2 
3 $Y
4 
5 WAGMI
6 
7 🐦 https://mobile.twitter.com/YethOfficial
8 🌐 https://t.me/YethOfficial
9 
10 */
11 
12 pragma solidity 0.8.9;
13 
14 // SPDX-License-Identifier: UNLICENSED 
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
121 contract Y is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _rOwned;
124     mapping (address => uint256) private _tOwned;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private bots;
128     mapping (address => uint) private cooldown;
129     uint256 private constant MAX = ~uint256(0);
130     uint256 private constant _tTotal = 1000000 * 10**9;
131     uint256 private _rTotal = (MAX - (MAX % _tTotal));
132     uint256 private _tFeeTotal;
133 
134     uint256 private _feeAddr1;
135     uint256 private _feeAddr2;
136     uint256 private _standardTax;
137     address payable private _feeAddrWallet;
138 
139     string private constant _name = "Y";
140     string private constant _symbol = "Y";
141     uint8 private constant _decimals = 9;
142 
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148     bool private cooldownEnabled = false;
149     uint256 private _maxTxAmount = _tTotal.mul(2).div(100);
150     uint256 private _maxWalletSize = _tTotal.mul(2).div(100);
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157 
158     constructor () {
159         _feeAddrWallet = payable(_msgSender());
160         _rOwned[_msgSender()] = _rTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_feeAddrWallet] = true;
164         _standardTax=3;
165 
166         emit Transfer(address(0), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return tokenFromReflection(_rOwned[account]);
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function setCooldownEnabled(bool onoff) external onlyOwner() {
210         cooldownEnabled = onoff;
211     }
212 
213     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
214         require(rAmount <= _rTotal, "Amount must be less than total reflections");
215         uint256 currentRate =  _getRate();
216         return rAmount.div(currentRate);
217     }
218 
219     function _approve(address owner, address spender, uint256 amount) private {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 
226     function _transfer(address from, address to, uint256 amount) private {
227         require(from != address(0), "ERC20: transfer from the zero address");
228         require(to != address(0), "ERC20: transfer to the zero address");
229         require(amount > 0, "Transfer amount must be greater than zero");
230 
231 
232         if (from != owner() && to != owner()) {
233             require(!bots[from] && !bots[to]);
234             _feeAddr1 = 0;
235             _feeAddr2 = _standardTax;
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
237                 // Cooldown
238                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
239                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
240 
241             }
242 
243 
244             uint256 contractTokenBalance = balanceOf(address(this));
245             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
246                 swapTokensForEth(contractTokenBalance);
247                 uint256 contractETHBalance = address(this).balance;
248                 if(contractETHBalance > 0) {
249                     sendETHToFee(address(this).balance);
250                 }
251             }
252         }else{
253           _feeAddr1 = 0;
254           _feeAddr2 = 0;
255         }
256 
257         _tokenTransfer(from,to,amount);
258     }
259 
260     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = uniswapV2Router.WETH();
264         _approve(address(this), address(uniswapV2Router), tokenAmount);
265         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             tokenAmount,
267             0,
268             path,
269             address(this),
270             block.timestamp
271         );
272     }
273 
274     function setStandardTax(uint256 newTax) external onlyOwner{
275       require(newTax<_standardTax);
276       _standardTax=newTax;
277     }
278 
279     function removeLimits() external onlyOwner{
280         _maxTxAmount = _tTotal;
281         _maxWalletSize = _tTotal;
282     }
283 
284     function sendETHToFee(uint256 amount) private {
285         _feeAddrWallet.transfer(amount);
286     }
287 
288     function openTrading() external onlyOwner() {
289         require(!tradingOpen,"trading is already open");
290         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
291         uniswapV2Router = _uniswapV2Router;
292         _approve(address(this), address(uniswapV2Router), _tTotal);
293         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
294         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
295         swapEnabled = true;
296         cooldownEnabled = true;
297 
298         tradingOpen = true;
299         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
300     }
301 
302         function addbot(address[] memory bots_) public onlyOwner {
303         for (uint i = 0; i < bots_.length; i++) {
304             bots[bots_[i]] = true;
305         }
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
335         require(_msgSender() == _feeAddrWallet);
336         uint256 contractBalance = balanceOf(address(this));
337         swapTokensForEth(contractBalance);
338     }
339 
340     function manualsend() external {
341         require(_msgSender() == _feeAddrWallet);
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