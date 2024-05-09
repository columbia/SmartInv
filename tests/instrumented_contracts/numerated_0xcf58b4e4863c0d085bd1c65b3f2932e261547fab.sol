1 // Telegram:  https://t.me/lordeedgetoken
2 // SPDX-License-Identifier: Unlicensed
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
112 contract LordeEdge is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _rOwned;
115     mapping (address => uint256) private _tOwned;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) private _isExcludedFromFee;
118     mapping (address => bool) private bots;
119     mapping (address => uint) private cooldown;
120     uint256 private constant MAX = ~uint256(0);
121     uint256 private constant _tTotal = 1 * 10**12 * 10**9;
122     uint256 private _rTotal = (MAX - (MAX % _tTotal));
123     uint256 private _tFeeTotal;
124     
125     uint256 private _feeAddr1;
126     uint256 private _feeAddr2;
127     address payable private _feeAddrWallet1;
128     address payable private _feeAddrWallet2;
129     
130     string private constant _name = "Lorde Edge";
131     string private constant _symbol = "EDGELON";
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
148         _feeAddrWallet1 = payable(0x15b72A1D37E2C21Ad3Fa0D6ec183D7F7120395b3);
149         _feeAddrWallet2 = payable(0x15b72A1D37E2C21Ad3Fa0D6ec183D7F7120395b3);
150         _rOwned[address(this)] = _rTotal.div(2);
151         _rOwned[0x000000000000000000000000000000000000dEaD] = _rTotal.div(2);
152         _isExcludedFromFee[owner()] = true;
153         _isExcludedFromFee[address(this)] = true;
154         _isExcludedFromFee[_feeAddrWallet1] = true;
155         _isExcludedFromFee[_feeAddrWallet2] = true;
156         
157         emit Transfer(address(0),address(this),_tTotal.div(2));
158         emit Transfer(address(0),address(0x000000000000000000000000000000000000dEaD),_tTotal.div(2));
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
222         _feeAddr1 = 1;
223         _feeAddr2 = 9;
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
235                 _feeAddr1 = 1;
236                 _feeAddr2 = 9;
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
279         _maxTxAmount = 50000000000 * 10**9;
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