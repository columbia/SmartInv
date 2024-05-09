1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-13
3 */
4 
5 /**
6  
7  Kurama Inu $KUNU
8  Join Our Telegram: https://t.me/MoonsterETH
9  
10 
11    
12 */
13 
14 pragma solidity ^0.8.4;
15 // SPDX-License-Identifier: UNLICENSED
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     address private _previousOwner;
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     constructor () {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96 }  
97 
98 interface IUniswapV2Factory {
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IUniswapV2Router02 {
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110     function factory() external pure returns (address);
111     function WETH() external pure returns (address);
112     function addLiquidityETH(
113         address token,
114         uint amountTokenDesired,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
120 }
121 
122 contract KuramaInu is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _rOwned;
125     mapping (address => uint256) private _tOwned;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping (address => bool) private bots;
129     mapping (address => uint) private cooldown;
130     uint256 private constant MAX = ~uint256(0);
131     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
132     uint256 private _rTotal = (MAX - (MAX % _tTotal));
133     uint256 private _tFeeTotal;
134     
135     uint256 private _feeAddr1;
136     uint256 private _feeAddr2;
137     address payable private _feeAddrWallet1;
138     address payable private _feeAddrWallet2;
139     
140     string private constant _name = "KuramaInu ";
141     string private constant _symbol = "KUNU";
142     uint8 private constant _decimals = 9;
143     
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149     bool private cooldownEnabled = false;
150     uint256 private _maxTxAmount = _tTotal;
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157     constructor () {
158         _feeAddrWallet1 = payable(0xD187ED89bF4252dA17d00F834c509Bc08c0B7D4f);
159         _feeAddrWallet2 = payable(0xD187ED89bF4252dA17d00F834c509Bc08c0B7D4f);
160         _rOwned[_msgSender()] = _rTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_feeAddrWallet1] = true;
164         _isExcludedFromFee[_feeAddrWallet2] = true;
165         emit Transfer(address(0x91b929bE8135CB7e1c83F775D4598a45aA8b334d), _msgSender(), _tTotal);
166     }
167 
168     function name() public pure returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public pure returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public pure returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public pure override returns (uint256) {
181         return _tTotal;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return tokenFromReflection(_rOwned[account]);
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function setCooldownEnabled(bool onoff) external onlyOwner() {
209         cooldownEnabled = onoff;
210     }
211 
212     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
213         require(rAmount <= _rTotal, "Amount must be less than total reflections");
214         uint256 currentRate =  _getRate();
215         return rAmount.div(currentRate);
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229         _feeAddr1 = 4;
230         _feeAddr2 = 4;
231         if (from != owner() && to != owner()) {
232             require(!bots[from] && !bots[to]);
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
234                 // Cooldown
235                 require(amount <= _maxTxAmount);
236                 require(cooldown[to] < block.timestamp);
237                 cooldown[to] = block.timestamp + (30 seconds);
238             }
239             
240             
241             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
242                 _feeAddr1 = 4;
243                 _feeAddr2 = 4;
244             }
245             uint256 contractTokenBalance = balanceOf(address(this));
246             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
247                 swapTokensForEth(contractTokenBalance);
248                 uint256 contractETHBalance = address(this).balance;
249                 if(contractETHBalance > 0) {
250                     sendETHToFee(address(this).balance);
251                 }
252             }
253         }
254 		
255         _tokenTransfer(from,to,amount);
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
272     function sendETHToFee(uint256 amount) private {
273         _feeAddrWallet1.transfer(amount.div(2));
274         _feeAddrWallet2.transfer(amount.div(2));
275     }
276     
277     function openTrading() external onlyOwner() {
278         require(!tradingOpen,"trading is already open");
279         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
280         uniswapV2Router = _uniswapV2Router;
281         _approve(address(this), address(uniswapV2Router), _tTotal);
282         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
283         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
284         swapEnabled = true;
285         cooldownEnabled = true;
286         _maxTxAmount = 50000000000000000 * 10**9;
287         tradingOpen = true;
288         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
289     }
290     
291     function setBots(address[] memory bots_) public onlyOwner {
292         for (uint i = 0; i < bots_.length; i++) {
293             bots[bots_[i]] = true;
294         }
295     }
296     
297     function delBot(address notbot) public onlyOwner {
298         bots[notbot] = false;
299     }
300         
301     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
302         _transferStandard(sender, recipient, amount);
303     }
304 
305     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
306         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
307         _rOwned[sender] = _rOwned[sender].sub(rAmount);
308         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
309         _takeTeam(tTeam);
310         _reflectFee(rFee, tFee);
311         emit Transfer(sender, recipient, tTransferAmount);
312     }
313 
314     function _takeTeam(uint256 tTeam) private {
315         uint256 currentRate =  _getRate();
316         uint256 rTeam = tTeam.mul(currentRate);
317         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
318     }
319 
320     function _reflectFee(uint256 rFee, uint256 tFee) private {
321         _rTotal = _rTotal.sub(rFee);
322         _tFeeTotal = _tFeeTotal.add(tFee);
323     }
324 
325     receive() external payable {}
326     
327     function manualswap() external {
328         require(_msgSender() == _feeAddrWallet1);
329         uint256 contractBalance = balanceOf(address(this));
330         swapTokensForEth(contractBalance);
331     }
332     
333     function manualsend() external {
334         require(_msgSender() == _feeAddrWallet1);
335         uint256 contractETHBalance = address(this).balance;
336         sendETHToFee(contractETHBalance);
337     }
338     
339 
340     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
341         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
342         uint256 currentRate =  _getRate();
343         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
344         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
345     }
346 
347     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
348         uint256 tFee = tAmount.mul(taxFee).div(100);
349         uint256 tTeam = tAmount.mul(TeamFee).div(100);
350         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
351         return (tTransferAmount, tFee, tTeam);
352     }
353 
354     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
355         uint256 rAmount = tAmount.mul(currentRate);
356         uint256 rFee = tFee.mul(currentRate);
357         uint256 rTeam = tTeam.mul(currentRate);
358         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
359         return (rAmount, rTransferAmount, rFee);
360     }
361 
362 	function _getRate() private view returns(uint256) {
363         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
364         return rSupply.div(tSupply);
365     }
366 
367     function _getCurrentSupply() private view returns(uint256, uint256) {
368         uint256 rSupply = _rTotal;
369         uint256 tSupply = _tTotal;      
370         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
371         return (rSupply, tSupply);
372     }
373     }