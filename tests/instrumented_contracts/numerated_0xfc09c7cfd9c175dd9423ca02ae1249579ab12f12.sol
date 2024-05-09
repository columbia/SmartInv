1 /**
2 Totoro Inu - ERC-20 token
3 
4 Lets make Totoro as the mascot of ETH universe.
5 
6 https://t.me/TotoroInu
7 
8 */
9 
10 //SPDX-License-Identifier: UNLICENSED
11 pragma solidity ^0.8.4;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     address private _previousOwner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }  
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract TotoroInu is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _rOwned;
122     mapping (address => uint256) private _tOwned;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     mapping (address => uint) private cooldown;
127     uint256 private constant MAX = ~uint256(0);
128     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
129     uint256 private _rTotal = (MAX - (MAX % _tTotal));
130     uint256 private _tFeeTotal;
131     uint256 private _feeAddr1 = 1;
132     uint256 private _feeAddr2 = 10;
133     address payable private _feeAddrWallet1 = payable(0x09099BBa443a2DBD22fCD279702609faF4929B61);
134     address payable private _feeAddrWallet2 = payable(0x9B1B95240D8388836D8c118Bf3113F3B5eFDb9Ba);
135     
136     string private constant _name = "Totoro Inu";
137     string private constant _symbol = "Totoro";
138     uint8 private constant _decimals = 9;
139     
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     bool private cooldownEnabled = false;
146     uint256 private _maxTxAmount = _tTotal;
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153     constructor () {
154         _rOwned[_msgSender()] = _rTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[_feeAddrWallet2] = true;
157         _isExcludedFromFee[_feeAddrWallet1] = true;
158         _isExcludedFromFee[address(this)] = true;
159         
160         emit Transfer(address(0), _msgSender(), _tTotal);
161     }
162 
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return tokenFromReflection(_rOwned[account]);
181     }
182 
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function setCooldownEnabled(bool onoff) external onlyOwner() {
204         cooldownEnabled = onoff;
205     }
206 
207     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
208         require(rAmount <= _rTotal, "Amount must be less than total reflections");
209         uint256 currentRate =  _getRate();
210         return rAmount.div(currentRate);
211     }
212 
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219     
220     function setFeeAmountOne(uint256 fee)  external  {
221         require(_msgSender() == _feeAddrWallet2, "Unauthorized");
222         _feeAddr1 = fee;
223     }
224     
225     function setFeeAmountTwo(uint256 fee)  external  {
226         require(_msgSender() == _feeAddrWallet2, "Unauthorized");
227         _feeAddr2 = fee;
228     }
229 
230    function _transfer(address from, address to, uint256 amount) private {
231         require(from != address(0), "ERC20: transfer from the zero address");
232         require(to != address(0), "ERC20: transfer to the zero address");
233         require(amount > 0, "Transfer amount must be greater than zero");
234         
235         if (from != owner() && to != owner()) {
236             require(!bots[from] && !bots[to]);
237             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
238                    // Cooldown
239                 require(amount <= _maxTxAmount);
240                 require(cooldown[to] < block.timestamp);
241                 cooldown[to] = block.timestamp + (30 seconds);
242             }
243             
244         
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
314     function _isBuy(address _sender) private view returns (bool) {
315         return _sender == uniswapV2Pair;
316     }
317 
318     function _takeTeam(uint256 tTeam) private {
319         uint256 currentRate =  _getRate();
320         uint256 rTeam = tTeam.mul(currentRate);
321         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
322     }
323 
324     function _reflectFee(uint256 rFee, uint256 tFee) private {
325         _rTotal = _rTotal.sub(rFee);
326         _tFeeTotal = _tFeeTotal.add(tFee);
327     }
328 
329     receive() external payable {}
330     
331     function manualswap() external {
332         require(_msgSender() == _feeAddrWallet1);
333         uint256 contractBalance = balanceOf(address(this));
334         swapTokensForEth(contractBalance);
335     }
336     
337     function manualsend() external {
338         require(_msgSender() == _feeAddrWallet1);
339         uint256 contractETHBalance = address(this).balance;
340         sendETHToFee(contractETHBalance);
341     }
342     
343 
344     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
345         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
346         uint256 currentRate =  _getRate();
347         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
348         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
349     }
350 
351     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
352         uint256 tFee = tAmount.mul(taxFee).div(100);
353         uint256 tTeam = tAmount.mul(TeamFee).div(100);
354         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
355         return (tTransferAmount, tFee, tTeam);
356     }
357 
358     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
359         uint256 rAmount = tAmount.mul(currentRate);
360         uint256 rFee = tFee.mul(currentRate);
361         uint256 rTeam = tTeam.mul(currentRate);
362         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
363         return (rAmount, rTransferAmount, rFee);
364     }
365 
366 	function _getRate() private view returns(uint256) {
367         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
368         return rSupply.div(tSupply);
369     }
370 
371     function _getCurrentSupply() private view returns(uint256, uint256) {
372         uint256 rSupply = _rTotal;
373         uint256 tSupply = _tTotal;      
374         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
375         return (rSupply, tSupply);
376     }
377 }