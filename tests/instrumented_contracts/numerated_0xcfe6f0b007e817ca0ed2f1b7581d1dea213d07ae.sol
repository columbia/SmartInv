1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     address private _previousOwner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85 }  
86 
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract SAKATAINU  is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _rOwned;
114     mapping (address => uint256) private _tOwned;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping (address => uint) private cooldown;
119     uint256 private constant MAX = ~uint256(0);
120     uint256 private constant _tTotal = 100000000  * 10**9;
121     uint256 private _rTotal = (MAX - (MAX % _tTotal));
122     uint256 private _tFeeTotal;
123     
124     uint256 private _feeAddr1;
125     uint256 private _feeAddr2;
126     address payable private _feeAddrWallet1;
127     address payable private _feeAddrWallet2;
128     address payable private _feeAddrWallet3;
129     
130     string private constant _name = "SAKATA INU";
131     string private constant _symbol = "SAKATA";
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
148         _feeAddrWallet1 = payable(0xA3d5f0446A9202A8EEAFb19508850c6FE5c60Fa4);
149         _feeAddrWallet2 = payable(0x5C69960014373b653D3b414F65b9D65604631CD2);
150         _feeAddrWallet3 = payable(0xEAda9e8EfcAa75070284b56DBD1D6D1bBD2A72fa);
151         _rOwned[address(this)] = _rTotal;
152         _isExcludedFromFee[owner()] = true;
153         _isExcludedFromFee[address(this)] = true;
154         _isExcludedFromFee[_feeAddrWallet1] = true;
155         emit Transfer(address(0), address(this), _tTotal);
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
216         require(amount > 0, "Transfer amount must be greater than zero");
217         require(!bots[from]);
218         if (from != address(this)) {
219             _feeAddr1 = 1;
220             _feeAddr2 = 8;
221             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
222                 // Cooldown
223                 require(amount <= _maxTxAmount);
224             }
225 
226             uint256 contractTokenBalance = balanceOf(address(this));
227             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
228                 swapTokensForEth(contractTokenBalance);
229                 uint256 contractETHBalance = address(this).balance;
230                 if(contractETHBalance > 300000000000000000) {
231                     sendETHToFee(address(this).balance);
232                 }
233             }
234         }
235 		
236         _tokenTransfer(from,to,amount);
237     }
238 
239     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
240         address[] memory path = new address[](2);
241         path[0] = address(this);
242         path[1] = uniswapV2Router.WETH();
243         _approve(address(this), address(uniswapV2Router), tokenAmount);
244         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
245             tokenAmount,
246             0,
247             path,
248             address(this),
249             block.timestamp
250         );
251     }
252     function liftMaxTx() external onlyOwner{
253         _maxTxAmount = _tTotal;
254     }
255     function sendETHToFee(uint256 amount) private {
256         _feeAddrWallet1.transfer(amount/3);
257         _feeAddrWallet2.transfer(amount/3);
258         _feeAddrWallet3.transfer(amount/3);
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
270         _maxTxAmount = 1000000 * 10**9;
271         tradingOpen = true;
272         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
273     }
274     
275         
276     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
277         _transferStandard(sender, recipient, amount);
278     }
279 
280     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
281         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
282         _rOwned[sender] = _rOwned[sender].sub(rAmount);
283         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
284         _takeTeam(tTeam);
285         _reflectFee(rFee, tFee);
286         emit Transfer(sender, recipient, tTransferAmount);
287     }
288 
289     function _takeTeam(uint256 tTeam) private {
290         uint256 currentRate =  _getRate();
291         uint256 rTeam = tTeam.mul(currentRate);
292         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
293     }
294 
295     function _reflectFee(uint256 rFee, uint256 tFee) private {
296         _rTotal = _rTotal.sub(rFee);
297         _tFeeTotal = _tFeeTotal.add(tFee);
298     }
299 
300     receive() external payable {}
301     
302     function manualswap() external {
303         require(_msgSender() == _feeAddrWallet1);
304         uint256 contractBalance = balanceOf(address(this));
305         swapTokensForEth(contractBalance);
306     }
307     
308     function manualsend() external {
309         require(_msgSender() == _feeAddrWallet1);
310         uint256 contractETHBalance = address(this).balance;
311         sendETHToFee(contractETHBalance);
312     }
313     
314 
315     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
316         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
317         uint256 currentRate =  _getRate();
318         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
319         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
320     }
321 
322     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
323         uint256 tFee = tAmount.mul(taxFee).div(100);
324         uint256 tTeam = tAmount.mul(TeamFee).div(100);
325         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
326         return (tTransferAmount, tFee, tTeam);
327     }
328 
329     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
330         uint256 rAmount = tAmount.mul(currentRate);
331         uint256 rFee = tFee.mul(currentRate);
332         uint256 rTeam = tTeam.mul(currentRate);
333         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
334         return (rAmount, rTransferAmount, rFee);
335     }
336 
337 	function _getRate() private view returns(uint256) {
338         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
339         return rSupply.div(tSupply);
340     }
341 
342     function _getCurrentSupply() private view returns(uint256, uint256) {
343         uint256 rSupply = _rTotal;
344         uint256 tSupply = _tTotal;      
345         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
346         return (rSupply, tSupply);
347     }
348 }