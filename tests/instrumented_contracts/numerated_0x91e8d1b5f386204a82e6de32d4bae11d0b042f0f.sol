1 // SPDX-License-Identifier: Unlicensed
2 // Kimetsu
3 
4 pragma solidity ^0.8.4;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 
59 }
60 
61 contract Ownable is Context {
62     address private _owner;
63     address private _previousOwner;
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     constructor () {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86 }  
87 
88 interface IUniswapV2Factory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IUniswapV2Router02 {
93     function swapExactTokensForETHSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     function addLiquidityETH(
103         address token,
104         uint amountTokenDesired,
105         uint amountTokenMin,
106         uint amountETHMin,
107         address to,
108         uint deadline
109     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
110 }
111 
112 contract Kimetsu is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _rOwned;
115     mapping (address => uint256) private _tOwned;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) private _isExcludedFromFee;
118     mapping (address => bool) private bots;
119     mapping (address => uint) private cooldown;
120     uint256 private constant MAX = ~uint256(0);
121     uint256 private constant _tTotal = 1e12 * 10**9;
122     uint256 private _rTotal = (MAX - (MAX % _tTotal));
123     uint256 private _tFeeTotal;
124     
125     uint256 public _feeAddr1 = 0;
126     uint256 public _feeAddr2 = 12;
127     address payable private _feeAddrWallet1;
128     address payable private _feeAddrWallet2;
129     
130     string private constant _name = "Kimetsu Inu";
131     string private constant _symbol = "Kimetsu";
132     uint8 private constant _decimals = 9;
133     
134     IUniswapV2Router02 private uniswapV2Router;
135     address private uniswapV2Pair;
136     bool private tradingOpen;
137     bool private inSwap = false;
138     bool private swapEnabled = false;
139     bool private cooldownEnabled = false;
140     uint256 private _maxTxAmount = _tTotal;
141     event MaxTxAmountUpdated(uint _maxTxAmount);
142     modifier lockTheSwap {
143         inSwap = true;
144         _;
145         inSwap = false;
146     }
147     constructor () {
148         _feeAddrWallet1 = payable(0x30DcaF3064e1828DF81F7FE00996B6D59408528C);
149         _feeAddrWallet2 = payable(0x30DcaF3064e1828DF81F7FE00996B6D59408528C);
150         _rOwned[_msgSender()] = _rTotal;
151         _isExcludedFromFee[owner()] = true;
152         _isExcludedFromFee[address(this)] = true;
153         _isExcludedFromFee[_feeAddrWallet1] = true;
154         _isExcludedFromFee[_feeAddrWallet2] = true;
155         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
156     }
157 
158     function name() public pure returns (string memory) {
159         return _name;
160     }
161 
162     function symbol() public pure returns (string memory) {
163         return _symbol;
164     }
165 
166     function decimals() public pure returns (uint8) {
167         return _decimals;
168     }
169 
170     function totalSupply() public pure override returns (uint256) {
171         return _tTotal;
172     }
173 
174     function balanceOf(address account) public view override returns (uint256) {
175         return tokenFromReflection(_rOwned[account]);
176     }
177 
178     function transfer(address recipient, uint256 amount) public override returns (bool) {
179         _transfer(_msgSender(), recipient, amount);
180         return true;
181     }
182 
183     function allowance(address owner, address spender) public view override returns (uint256) {
184         return _allowances[owner][spender];
185     }
186 
187     function approve(address spender, uint256 amount) public override returns (bool) {
188         _approve(_msgSender(), spender, amount);
189         return true;
190     }
191 
192     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
193         _transfer(sender, recipient, amount);
194         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
195         return true;
196     }
197 
198     function setCooldownEnabled(bool onoff) external onlyOwner() {
199         cooldownEnabled = onoff;
200     }
201 
202     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
203         require(rAmount <= _rTotal, "Amount must be less than total reflections");
204         uint256 currentRate =  _getRate();
205         return rAmount.div(currentRate);
206     }
207 
208     function _approve(address owner, address spender, uint256 amount) private {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function _transfer(address from, address to, uint256 amount) private {
216         require(from != address(0), "ERC20: transfer from the zero address");
217         require(to != address(0), "ERC20: transfer to the zero address");
218         require(amount > 0, "Transfer amount must be greater than zero");
219         
220         if (from != owner() && to != owner()) {
221             require(!bots[from] && !bots[to]);
222             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
223                 // Cooldown
224                 require(amount <= _maxTxAmount);
225                 require(cooldown[to] < block.timestamp);
226                 cooldown[to] = block.timestamp + (15 seconds);
227             }
228             
229             uint256 contractTokenBalance = balanceOf(address(this));
230             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
231                 swapTokensForEth(contractTokenBalance);
232                 uint256 contractETHBalance = address(this).balance;
233                 if(contractETHBalance > 0) {
234                     sendETHToFee(address(this).balance);
235                 }
236             }
237         }
238 		
239         _tokenTransfer(from,to,amount);
240     }
241 
242     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
243         address[] memory path = new address[](2);
244         path[0] = address(this);
245         path[1] = uniswapV2Router.WETH();
246         _approve(address(this), address(uniswapV2Router), tokenAmount);
247         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
248             tokenAmount,
249             0,
250             path,
251             address(this),
252             block.timestamp
253         );
254     }
255         
256     function sendETHToFee(uint256 amount) private {
257         _feeAddrWallet1.transfer(amount.div(2));
258         _feeAddrWallet2.transfer(amount.div(2));
259     }
260     
261     function openTrading() external onlyOwner() {
262         require(!tradingOpen,"trading is already open");
263         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
264         uniswapV2Router = _uniswapV2Router;
265         _approve(address(this), address(uniswapV2Router), _tTotal);
266         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
267         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
268         swapEnabled = true;
269         cooldownEnabled = true;
270         _maxTxAmount = 1e10 * 10**9;
271         tradingOpen = true;
272         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
273     }
274     
275     function setBots(address[] memory bots_) public onlyOwner {
276         for (uint i = 0; i < bots_.length; i++) {
277             bots[bots_[i]] = true;
278         }
279     }
280     
281     function removeStrictTxLimit() public onlyOwner {
282         _maxTxAmount = 1e12 * 10**9;
283     }
284     
285     function delBot(address notbot) public onlyOwner {
286         bots[notbot] = false;
287     }
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