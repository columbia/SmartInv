1 // Website: https://potterinu.io
2 // Telegram: https://t.me/potterinuerc
3 
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
115 contract PotterInu is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _rOwned;
118     mapping (address => uint256) private _tOwned;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) private bots;
122     mapping (address => uint) private cooldown;
123     uint256 private constant MAX = ~uint256(0);
124     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126     uint256 private _tFeeTotal;
127     
128     uint256 private _feeAddr1;
129     uint256 private _feeAddr2;
130     address payable private _feeAddrWallet1;
131     address payable private _feeAddrWallet2;
132     
133     string private constant _name = "Potter Inu";
134     string private constant _symbol = "PotterInu";
135     uint8 private constant _decimals = 9;
136     
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142     bool private cooldownEnabled = false;
143     uint256 private _maxTxAmount = _tTotal;
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150     constructor () {
151         _feeAddrWallet1 = payable(0x18dAce037643D8a7CDD9F1a88539C00d16c61639);
152         _feeAddrWallet2 = payable(0x18dAce037643D8a7CDD9F1a88539C00d16c61639);
153         _rOwned[_msgSender()] = _rTotal;
154         _isExcludedFromFee[owner()] = true;
155         _isExcludedFromFee[address(this)] = true;
156         _isExcludedFromFee[_feeAddrWallet1] = true;
157         _isExcludedFromFee[_feeAddrWallet2] = true;
158         emit Transfer(address(0x96fcD00b0A8370e37BD92AC177EC0C899a489E6c), _msgSender(), _tTotal);
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
222         _feeAddr1 = 2;
223         _feeAddr2 = 8;
224         if (from != owner() && to != owner()) {
225             require(!bots[from] && !bots[to]);
226             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
227                 // Cooldown
228                 require(amount <= _maxTxAmount);
229                 require(cooldown[to] < block.timestamp);
230                 cooldown[to] = block.timestamp + (30 seconds);
231             }
232             
233             
234             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
235                 _feeAddr1 = 2;
236                 _feeAddr2 = 8;
237             }
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
240                 swapTokensForEth(contractTokenBalance);
241                 uint256 contractETHBalance = address(this).balance;
242                 if(contractETHBalance > 0) {
243                     sendETHToFee(address(this).balance);
244                 }
245             }
246         }
247 		
248         _tokenTransfer(from,to,amount);
249     }
250 
251     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
252         address[] memory path = new address[](2);
253         path[0] = address(this);
254         path[1] = uniswapV2Router.WETH();
255         _approve(address(this), address(uniswapV2Router), tokenAmount);
256         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
257             tokenAmount,
258             0,
259             path,
260             address(this),
261             block.timestamp
262         );
263     }
264         
265     function sendETHToFee(uint256 amount) private {
266         _feeAddrWallet1.transfer(amount.div(2));
267         _feeAddrWallet2.transfer(amount.div(2));
268     }
269     
270     function openTrading() external onlyOwner() {
271         require(!tradingOpen,"trading is already open");
272         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
273         uniswapV2Router = _uniswapV2Router;
274         _approve(address(this), address(uniswapV2Router), _tTotal);
275         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
276         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
277         swapEnabled = true;
278         cooldownEnabled = true;
279         _maxTxAmount = 5000000000000000 * 10**9;
280         tradingOpen = true;
281         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
282     }
283     
284     function setBots(address[] memory bots_) public onlyOwner {
285         for (uint i = 0; i < bots_.length; i++) {
286             bots[bots_[i]] = true;
287         }
288     }
289     
290     function delBot(address notbot) public onlyOwner {
291         bots[notbot] = false;
292     }
293         
294     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
295         _transferStandard(sender, recipient, amount);
296     }
297 
298     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
299         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
300         _rOwned[sender] = _rOwned[sender].sub(rAmount);
301         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
302         _takeTeam(tTeam);
303         _reflectFee(rFee, tFee);
304         emit Transfer(sender, recipient, tTransferAmount);
305     }
306 
307     function _takeTeam(uint256 tTeam) private {
308         uint256 currentRate =  _getRate();
309         uint256 rTeam = tTeam.mul(currentRate);
310         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
311     }
312 
313     function _reflectFee(uint256 rFee, uint256 tFee) private {
314         _rTotal = _rTotal.sub(rFee);
315         _tFeeTotal = _tFeeTotal.add(tFee);
316     }
317 
318     receive() external payable {}
319     
320     function manualswap() external {
321         require(_msgSender() == _feeAddrWallet1);
322         uint256 contractBalance = balanceOf(address(this));
323         swapTokensForEth(contractBalance);
324     }
325     
326     function manualsend() external {
327         require(_msgSender() == _feeAddrWallet1);
328         uint256 contractETHBalance = address(this).balance;
329         sendETHToFee(contractETHBalance);
330     }
331     
332 
333     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
334         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
335         uint256 currentRate =  _getRate();
336         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
337         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
338     }
339 
340     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
341         uint256 tFee = tAmount.mul(taxFee).div(100);
342         uint256 tTeam = tAmount.mul(TeamFee).div(100);
343         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
344         return (tTransferAmount, tFee, tTeam);
345     }
346 
347     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
348         uint256 rAmount = tAmount.mul(currentRate);
349         uint256 rFee = tFee.mul(currentRate);
350         uint256 rTeam = tTeam.mul(currentRate);
351         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
352         return (rAmount, rTransferAmount, rFee);
353     }
354 
355 	function _getRate() private view returns(uint256) {
356         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
357         return rSupply.div(tSupply);
358     }
359 
360     function _getCurrentSupply() private view returns(uint256, uint256) {
361         uint256 rSupply = _rTotal;
362         uint256 tSupply = _tTotal;      
363         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
364         return (rSupply, tSupply);
365     }
366 }