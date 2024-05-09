1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-10
3 */
4 
5 /**
6  
7  SHAMANKINGINU $SHAMAN
8  Join Our Telegram: https://t.me/ShamanKingInu
9    
10 */
11 
12 pragma solidity ^0.8.4;
13 // SPDX-License-Identifier: UNLICENSED
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     address private _previousOwner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94 }  
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 contract SHAMAN is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _rOwned;
123     mapping (address => uint256) private _tOwned;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     mapping (address => uint) private cooldown;
128     uint256 private constant MAX = ~uint256(0);
129     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
130     uint256 private _rTotal = (MAX - (MAX % _tTotal));
131     uint256 private _tFeeTotal;
132     
133     uint256 private _feeAddr1;
134     uint256 private _feeAddr2;
135     address payable private _feeAddrWallet1;
136     address payable private _feeAddrWallet2;
137     
138     string private constant _name = "SHAMAN KING INU";
139     string private constant _symbol = "SHAMAN";
140     uint8 private constant _decimals = 9;
141     
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147     bool private cooldownEnabled = false;
148     uint256 private _maxTxAmount = _tTotal;
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155     constructor () {
156         _feeAddrWallet1 = payable(0x096F901543F256B990fa40E54E80a9fe0812E8C1);
157         _feeAddrWallet2 = payable(0xA79CbA48afd23f68e9Cc3Dc750b4f49b4d89F727);
158         _rOwned[_msgSender()] = _rTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_feeAddrWallet1] = true;
162         _isExcludedFromFee[_feeAddrWallet2] = true;
163         emit Transfer(address(0x096F901543F256B990fa40E54E80a9fe0812E8C1), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return tokenFromReflection(_rOwned[account]);
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function setCooldownEnabled(bool onoff) external onlyOwner() {
207         cooldownEnabled = onoff;
208     }
209 
210     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
211         require(rAmount <= _rTotal, "Amount must be less than total reflections");
212         uint256 currentRate =  _getRate();
213         return rAmount.div(currentRate);
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227         _feeAddr1 = 6;
228         _feeAddr2 = 4;
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
232                 // Cooldown
233                 require(amount <= _maxTxAmount);
234                 require(cooldown[to] < block.timestamp);
235                 cooldown[to] = block.timestamp + (30 seconds);
236             }
237             
238             
239             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
240                 _feeAddr1 = 10;
241                 _feeAddr2 = 2;
242             }
243             uint256 contractTokenBalance = balanceOf(address(this));
244             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
245                 swapTokensForEth(contractTokenBalance);
246                 uint256 contractETHBalance = address(this).balance;
247                 if(contractETHBalance > 0) {
248                     sendETHToFee(address(this).balance);
249                 }
250             }
251         }
252 		
253         _tokenTransfer(from,to,amount);
254     }
255 
256     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
257         address[] memory path = new address[](2);
258         path[0] = address(this);
259         path[1] = uniswapV2Router.WETH();
260         _approve(address(this), address(uniswapV2Router), tokenAmount);
261         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
262             tokenAmount,
263             0,
264             path,
265             address(this),
266             block.timestamp
267         );
268     }
269         
270     function sendETHToFee(uint256 amount) private {
271         _feeAddrWallet1.transfer(amount.div(2));
272         _feeAddrWallet2.transfer(amount.div(2));
273     }
274     
275     function openTrading() external onlyOwner() {
276         require(!tradingOpen,"trading is already open");
277         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
278         uniswapV2Router = _uniswapV2Router;
279         _approve(address(this), address(uniswapV2Router), _tTotal);
280         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
281         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
282         swapEnabled = true;
283         cooldownEnabled = true;
284         _maxTxAmount = 50000000000000000 * 10**9;
285         tradingOpen = true;
286         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
287     }
288     
289     function setBots(address[] memory bots_) public onlyOwner {
290         for (uint i = 0; i < bots_.length; i++) {
291             bots[bots_[i]] = true;
292         }
293     }
294     
295     function delBot(address notbot) public onlyOwner {
296         bots[notbot] = false;
297     }
298         
299     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
300         _transferStandard(sender, recipient, amount);
301     }
302 
303     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
304         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
305         _rOwned[sender] = _rOwned[sender].sub(rAmount);
306         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
307         _takeTeam(tTeam);
308         _reflectFee(rFee, tFee);
309         emit Transfer(sender, recipient, tTransferAmount);
310     }
311 
312     function _takeTeam(uint256 tTeam) private {
313         uint256 currentRate =  _getRate();
314         uint256 rTeam = tTeam.mul(currentRate);
315         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
316     }
317 
318     function _reflectFee(uint256 rFee, uint256 tFee) private {
319         _rTotal = _rTotal.sub(rFee);
320         _tFeeTotal = _tFeeTotal.add(tFee);
321     }
322 
323     receive() external payable {}
324     
325     function manualswap() external {
326         require(_msgSender() == _feeAddrWallet1);
327         uint256 contractBalance = balanceOf(address(this));
328         swapTokensForEth(contractBalance);
329     }
330     
331     function manualsend() external {
332         require(_msgSender() == _feeAddrWallet1);
333         uint256 contractETHBalance = address(this).balance;
334         sendETHToFee(contractETHBalance);
335     }
336     
337 
338     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
339         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
340         uint256 currentRate =  _getRate();
341         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
342         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
343     }
344 
345     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
346         uint256 tFee = tAmount.mul(taxFee).div(100);
347         uint256 tTeam = tAmount.mul(TeamFee).div(100);
348         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
349         return (tTransferAmount, tFee, tTeam);
350     }
351 
352     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
353         uint256 rAmount = tAmount.mul(currentRate);
354         uint256 rFee = tFee.mul(currentRate);
355         uint256 rTeam = tTeam.mul(currentRate);
356         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
357         return (rAmount, rTransferAmount, rFee);
358     }
359 
360 	function _getRate() private view returns(uint256) {
361         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
362         return rSupply.div(tSupply);
363     }
364 
365     function _getCurrentSupply() private view returns(uint256, uint256) {
366         uint256 rSupply = _rTotal;
367         uint256 tSupply = _tTotal;      
368         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
369         return (rSupply, tSupply);
370     }
371 }