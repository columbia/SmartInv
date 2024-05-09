1 /**
2 TG: https://t.me/NGMIGA
3 */
4 
5 pragma solidity ^0.8.4;
6 // SPDX-License-Identifier: UNLICENSED
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         return c;
58     }
59 
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     address private _previousOwner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87 }  
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 }
112 
113 contract NGMIGA is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     mapping (address => uint256) private _rOwned;
116     mapping (address => uint256) private _tOwned;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping (address => uint) private cooldown;
121     uint256 private constant MAX = ~uint256(0);
122     uint256 private constant _tTotal = 1000000000000 * 10**9;
123     uint256 private _rTotal = (MAX - (MAX % _tTotal));
124     uint256 private _tFeeTotal;
125     
126     uint256 private _feeAddr1;
127     uint256 private _feeAddr2;
128     address payable private _feeAddrWallet1;
129     address payable private _feeAddrWallet2;
130     
131     string private constant _name = "GA";
132     string private constant _symbol = "GA";
133     uint8 private constant _decimals = 9;
134     
135     IUniswapV2Router02 private uniswapV2Router;
136     address private uniswapV2Pair;
137     bool private tradingOpen;
138     bool private inSwap = false;
139     bool private swapEnabled = false;
140     bool private cooldownEnabled = false;
141     uint256 private _maxTxAmount = _tTotal;
142     event MaxTxAmountUpdated(uint _maxTxAmount);
143     modifier lockTheSwap {
144         inSwap = true;
145         _;
146         inSwap = false;
147     }
148     constructor () {
149         _feeAddrWallet1 = payable(0x89779e7A0446B0c506DCF40Fb6DB14F85CfA00Cc);
150         _feeAddrWallet2 = payable(0x89779e7A0446B0c506DCF40Fb6DB14F85CfA00Cc);
151         _rOwned[_msgSender()] = _rTotal;
152         _isExcludedFromFee[owner()] = true;
153         _isExcludedFromFee[address(this)] = true;
154         _isExcludedFromFee[_feeAddrWallet1] = true;
155         _isExcludedFromFee[_feeAddrWallet2] = true;
156         emit Transfer(address(0xd55FF395A7360be0c79D3556b0f65ef44b319575), _msgSender(), _tTotal);
157     }
158 
159     function name() public pure returns (string memory) {
160         return _name;
161     }
162 
163     function symbol() public pure returns (string memory) {
164         return _symbol;
165     }
166 
167     function decimals() public pure returns (uint8) {
168         return _decimals;
169     }
170 
171     function totalSupply() public pure override returns (uint256) {
172         return _tTotal;
173     }
174 
175     function balanceOf(address account) public view override returns (uint256) {
176         return tokenFromReflection(_rOwned[account]);
177     }
178 
179     function transfer(address recipient, uint256 amount) public override returns (bool) {
180         _transfer(_msgSender(), recipient, amount);
181         return true;
182     }
183 
184     function allowance(address owner, address spender) public view override returns (uint256) {
185         return _allowances[owner][spender];
186     }
187 
188     function approve(address spender, uint256 amount) public override returns (bool) {
189         _approve(_msgSender(), spender, amount);
190         return true;
191     }
192 
193     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
194         _transfer(sender, recipient, amount);
195         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
196         return true;
197     }
198 
199     function setCooldownEnabled(bool onoff) external onlyOwner() {
200         cooldownEnabled = onoff;
201     }
202 
203     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
204         require(rAmount <= _rTotal, "Amount must be less than total reflections");
205         uint256 currentRate =  _getRate();
206         return rAmount.div(currentRate);
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) private {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function _transfer(address from, address to, uint256 amount) private {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219         require(amount > 0, "Transfer amount must be greater than zero");
220         _feeAddr1 = 2;
221         _feeAddr2 = 10;
222         if (from != owner() && to != owner()) {
223             require(!bots[from] && !bots[to]);
224             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
225                 // Cooldown
226                 require(amount <= _maxTxAmount);
227                 require(cooldown[to] < block.timestamp);
228                 cooldown[to] = block.timestamp + (30 seconds);
229             }
230             
231             
232             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
233                 _feeAddr1 = 2;
234                 _feeAddr2 = 10;
235             }
236             uint256 contractTokenBalance = balanceOf(address(this));
237             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
238                 swapTokensForEth(contractTokenBalance);
239                 uint256 contractETHBalance = address(this).balance;
240                 if(contractETHBalance > 0) {
241                     sendETHToFee(address(this).balance);
242                 }
243             }
244         }
245 		
246         _tokenTransfer(from,to,amount);
247     }
248 
249     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
250         address[] memory path = new address[](2);
251         path[0] = address(this);
252         path[1] = uniswapV2Router.WETH();
253         _approve(address(this), address(uniswapV2Router), tokenAmount);
254         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
255             tokenAmount,
256             0,
257             path,
258             address(this),
259             block.timestamp
260         );
261     }
262         
263     function sendETHToFee(uint256 amount) private {
264         _feeAddrWallet1.transfer(amount.div(2));
265         _feeAddrWallet2.transfer(amount.div(2));
266     }
267     
268     function openTrading() external onlyOwner() {
269         require(!tradingOpen,"trading is already open");
270         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
271         uniswapV2Router = _uniswapV2Router;
272         _approve(address(this), address(uniswapV2Router), _tTotal);
273         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
274         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
275         swapEnabled = true;
276         cooldownEnabled = true;
277         _maxTxAmount = 50000000000 * 10**9;
278         tradingOpen = true;
279         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
280     }
281     
282     function setBots(address[] memory bots_) public onlyOwner {
283         for (uint i = 0; i < bots_.length; i++) {
284             bots[bots_[i]] = true;
285         }
286     }
287     
288     function delBot(address notbot) public onlyOwner {
289         bots[notbot] = false;
290     }
291         
292     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
293         _transferStandard(sender, recipient, amount);
294     }
295 
296     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
297         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
298         _rOwned[sender] = _rOwned[sender].sub(rAmount);
299         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
300         _takeTeam(tTeam);
301         _reflectFee(rFee, tFee);
302         emit Transfer(sender, recipient, tTransferAmount);
303     }
304 
305     function _takeTeam(uint256 tTeam) private {
306         uint256 currentRate =  _getRate();
307         uint256 rTeam = tTeam.mul(currentRate);
308         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
309     }
310 
311     function _reflectFee(uint256 rFee, uint256 tFee) private {
312         _rTotal = _rTotal.sub(rFee);
313         _tFeeTotal = _tFeeTotal.add(tFee);
314     }
315 
316     receive() external payable {}
317     
318     function manualswap() external {
319         require(_msgSender() == _feeAddrWallet1);
320         uint256 contractBalance = balanceOf(address(this));
321         swapTokensForEth(contractBalance);
322     }
323     
324     function manualsend() external {
325         require(_msgSender() == _feeAddrWallet1);
326         uint256 contractETHBalance = address(this).balance;
327         sendETHToFee(contractETHBalance);
328     }
329     
330 
331     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
332         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
333         uint256 currentRate =  _getRate();
334         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
335         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
336     }
337 
338     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
339         uint256 tFee = tAmount.mul(taxFee).div(100);
340         uint256 tTeam = tAmount.mul(TeamFee).div(100);
341         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
342         return (tTransferAmount, tFee, tTeam);
343     }
344 
345     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
346         uint256 rAmount = tAmount.mul(currentRate);
347         uint256 rFee = tFee.mul(currentRate);
348         uint256 rTeam = tTeam.mul(currentRate);
349         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
350         return (rAmount, rTransferAmount, rFee);
351     }
352 
353 	function _getRate() private view returns(uint256) {
354         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
355         return rSupply.div(tSupply);
356     }
357 
358     function _getCurrentSupply() private view returns(uint256, uint256) {
359         uint256 rSupply = _rTotal;
360         uint256 tSupply = _tTotal;      
361         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
362         return (rSupply, tSupply);
363     }
364 }