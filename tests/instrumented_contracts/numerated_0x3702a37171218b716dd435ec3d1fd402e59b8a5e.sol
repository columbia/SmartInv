1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-03
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.8.4;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     address private _previousOwner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }  
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 
115 contract BabyPutinToken  is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _rOwned;
118     mapping (address => uint256) private _tOwned;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) private bots;
122     mapping (address => uint) private cooldown;
123     uint256 private constant MAX = ~uint256(0);
124     uint256 private constant _tTotal = 99000000000  * 10**9;
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126     uint256 private _tFeeTotal;
127     
128     uint256 private _feeAddr1;
129     uint256 private _feeAddr2;
130     address payable private _feeAddrWallet1;
131     address payable private _feeAddrWallet2;
132     address payable private _feeAddrWallet3;
133     
134     string private constant _name = "BabyPutinToken";
135     string private constant _symbol = "BabyPutin";
136     uint8 private constant _decimals = 9;
137     
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143     bool private cooldownEnabled = false;
144     uint256 private _maxTxAmount = _tTotal;
145     event MaxTxAmountUpdated(uint _maxTxAmount);
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151     constructor () {
152         _feeAddrWallet1 = payable(0xC7f12efCAF88Db4663372BDf119eA23f0965D31F);
153         _feeAddrWallet2 = payable(0xC7f12efCAF88Db4663372BDf119eA23f0965D31F);
154         _feeAddrWallet3 = payable(0xC7f12efCAF88Db4663372BDf119eA23f0965D31F);
155         _rOwned[address(this)] = _rTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_feeAddrWallet1] = true;
159         emit Transfer(address(0), address(this), _tTotal);
160     }
161 
162     function name() public pure returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public pure returns (uint8) {
171         return _decimals;
172     }
173 
174     function totalSupply() public pure override returns (uint256) {
175         return _tTotal;
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return tokenFromReflection(_rOwned[account]);
180     }
181 
182     function transfer(address recipient, uint256 amount) public override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     function allowance(address owner, address spender) public view override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function setCooldownEnabled(bool onoff) external onlyOwner() {
203         cooldownEnabled = onoff;
204     }
205 
206     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
207         require(rAmount <= _rTotal, "Amount must be less than total reflections");
208         uint256 currentRate =  _getRate();
209         return rAmount.div(currentRate);
210     }
211 
212     function _approve(address owner, address spender, uint256 amount) private {
213         require(owner != address(0), "ERC20: approve from the zero address");
214         require(spender != address(0), "ERC20: approve to the zero address");
215         _allowances[owner][spender] = amount;
216         emit Approval(owner, spender, amount);
217     }
218 
219     function _transfer(address from, address to, uint256 amount) private {
220         require(amount > 0, "Transfer amount must be greater than zero");
221         require(!bots[from]);
222         if (from != address(this)) {
223             _feeAddr1 = 2;
224             _feeAddr2 = 8;
225             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
226                 // Cooldown
227                 require(amount <= _maxTxAmount);
228             }
229 
230             uint256 contractTokenBalance = balanceOf(address(this));
231             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
232                 swapTokensForEth(contractTokenBalance);
233                 uint256 contractETHBalance = address(this).balance;
234                 if(contractETHBalance > 300000000000000000) {
235                     sendETHToFee(address(this).balance);
236                 }
237             }
238         }
239 		
240         _tokenTransfer(from,to,amount);
241     }
242 
243     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
244         address[] memory path = new address[](2);
245         path[0] = address(this);
246         path[1] = uniswapV2Router.WETH();
247         _approve(address(this), address(uniswapV2Router), tokenAmount);
248         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
249             tokenAmount,
250             0,
251             path,
252             address(this),
253             block.timestamp
254         );
255     }
256     function liftMaxTx() external onlyOwner{
257         _maxTxAmount = _tTotal;
258     }
259     function sendETHToFee(uint256 amount) private {
260         _feeAddrWallet1.transfer(amount/3);
261         _feeAddrWallet2.transfer(amount/3);
262         _feeAddrWallet3.transfer(amount/3);
263     }
264     
265     function openTrading() external onlyOwner() {
266         require(!tradingOpen,"trading is already open");
267         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
268         uniswapV2Router = _uniswapV2Router;
269         _approve(address(this), address(uniswapV2Router), _tTotal);
270         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
271         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
272         swapEnabled = true;
273         cooldownEnabled = true;
274         _maxTxAmount = 4000000000 * 10**9;
275         tradingOpen = true;
276         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
277     }
278     
279         
280     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
281         _transferStandard(sender, recipient, amount);
282     }
283 
284     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
285         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
286         _rOwned[sender] = _rOwned[sender].sub(rAmount);
287         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
288         _takeTeam(tTeam);
289         _reflectFee(rFee, tFee);
290         emit Transfer(sender, recipient, tTransferAmount);
291     }
292 
293     function _takeTeam(uint256 tTeam) private {
294         uint256 currentRate =  _getRate();
295         uint256 rTeam = tTeam.mul(currentRate);
296         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
297     }
298 
299     function _reflectFee(uint256 rFee, uint256 tFee) private {
300         _rTotal = _rTotal.sub(rFee);
301         _tFeeTotal = _tFeeTotal.add(tFee);
302     }
303 
304     receive() external payable {}
305     
306     function manualswap() external {
307         require(_msgSender() == _feeAddrWallet1);
308         uint256 contractBalance = balanceOf(address(this));
309         swapTokensForEth(contractBalance);
310     }
311     
312     function manualsend() external {
313         require(_msgSender() == _feeAddrWallet1);
314         uint256 contractETHBalance = address(this).balance;
315         sendETHToFee(contractETHBalance);
316     }
317     
318 
319     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
320         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
321         uint256 currentRate =  _getRate();
322         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
323         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
324     }
325 
326     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
327         uint256 tFee = tAmount.mul(taxFee).div(100);
328         uint256 tTeam = tAmount.mul(TeamFee).div(100);
329         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
330         return (tTransferAmount, tFee, tTeam);
331     }
332 
333     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
334         uint256 rAmount = tAmount.mul(currentRate);
335         uint256 rFee = tFee.mul(currentRate);
336         uint256 rTeam = tTeam.mul(currentRate);
337         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
338         return (rAmount, rTransferAmount, rFee);
339     }
340 
341 	function _getRate() private view returns(uint256) {
342         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
343         return rSupply.div(tSupply);
344     }
345 
346     function _getCurrentSupply() private view returns(uint256, uint256) {
347         uint256 rSupply = _rTotal;
348         uint256 tSupply = _tTotal;      
349         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
350         return (rSupply, tSupply);
351     }
352 }