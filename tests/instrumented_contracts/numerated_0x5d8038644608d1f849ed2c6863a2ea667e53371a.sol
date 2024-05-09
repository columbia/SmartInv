1 /**
2                                                                 
3 @@@  @@@  @@@  @@@  @@@   @@@@@@@@   @@@@@@   @@@@@@@@@@   @@@  
4 @@@  @@@@ @@@  @@@  @@@  @@@@@@@@@  @@@@@@@@  @@@@@@@@@@@  @@@  
5 @@!  @@!@!@@@  @@!  @@@  !@@        @@!  @@@  @@! @@! @@!  @@!  
6 !@!  !@!!@!@!  !@!  @!@  !@!        !@!  @!@  !@! !@! !@!  !@!  
7 !!@  @!@ !!@!  @!@  !@!  !@! @!@!@  @!@!@!@!  @!! !!@ @!@  !!@  
8 !!!  !@!  !!!  !@!  !!!  !!! !!@!!  !!!@!!!!  !@!   ! !@!  !!!  
9 !!:  !!:  !!!  !!:  !!!  :!!   !!:  !!:  !!!  !!:     !!:  !!:  
10 :!:  :!:  !:!  :!:  !:!  :!:   !::  :!:  !:!  :!:     :!:  :!:  
11  ::   ::   ::  ::::: ::   ::: ::::  ::   :::  :::     ::    ::  
12 :    ::    :    : :  :    :: :: :    :   : :   :      :    :    
13                                                                 
14                                                                                                 
15                                                                                                 
16 /**
17  //SPDX-License-Identifier: UNLICENSED
18  
19 */
20 
21 pragma solidity ^0.8.4;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 
76 }
77 
78 contract Ownable is Context {
79     address private _owner;
80     address private _previousOwner;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     constructor () {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         emit OwnershipTransferred(address(0), msgSender);
87     }
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103 }  
104 
105 interface IUniswapV2Factory {
106     function createPair(address tokenA, address tokenB) external returns (address pair);
107 }
108 
109 interface IUniswapV2Router02 {
110     function swapExactTokensForETHSupportingFeeOnTransferTokens(
111         uint amountIn,
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external;
117     function factory() external pure returns (address);
118     function WETH() external pure returns (address);
119     function addLiquidityETH(
120         address token,
121         uint amountTokenDesired,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline
126     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
127 }
128 
129 contract INUGAMI is Context, IERC20, Ownable {
130     using SafeMath for uint256;
131     mapping (address => uint256) private _rOwned;
132     mapping (address => uint256) private _tOwned;
133     mapping (address => mapping (address => uint256)) private _allowances;
134     mapping (address => bool) private _isExcludedFromFee;
135     mapping (address => bool) private _isExchange;
136     mapping (address => bool) private bots;
137     mapping (address => uint) private cooldown;
138     uint256 private constant MAX = ~uint256(0);
139     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
140     uint256 private _rTotal = (MAX - (MAX % _tTotal));
141     uint256 private _tFeeTotal;
142     
143     uint256 private _feeAddr1;
144     uint256 private _feeAddr2;
145     address payable private _feeAddrWallet1;
146     address payable private _feeAddrWallet2;
147     address payable private _feeAddrWallet3;
148     
149     string private constant _name = "INUGAMI";
150     string private constant _symbol = "INUGAMI";
151     uint8 private constant _decimals = 9;
152     
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158     bool private cooldownEnabled = false;
159     uint256 private _maxTxAmount = _tTotal;
160     event MaxTxAmountUpdated(uint _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166     
167     constructor () {
168         _feeAddrWallet1 = payable(0x2B5dBa7870727e1c319aFe3a5865Fd8444859ad8);
169         _feeAddrWallet2 = payable(0xB773111B2362607707B02818D4D18677C647Cab3);
170         _feeAddrWallet3 = payable(0x9952102dBDB0Db86a3AecfDA0707F5bcdBDB69c5);
171         _rOwned[_msgSender()] = _rTotal;
172         _isExcludedFromFee[owner()] = true;
173         _isExcludedFromFee[address(this)] = true;
174         _isExcludedFromFee[_feeAddrWallet1] = true;
175         _isExcludedFromFee[_feeAddrWallet2] = true;
176         _isExcludedFromFee[_feeAddrWallet3] = true;
177         emit Transfer(address(this), _msgSender(), _tTotal);
178     }
179 
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public pure returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public pure returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public pure override returns (uint256) {
193         return _tTotal;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return tokenFromReflection(_rOwned[account]);
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219 
220     function setCooldownEnabled(bool onoff) external onlyOwner() {
221         cooldownEnabled = onoff;
222     }
223 
224     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
225         require(rAmount <= _rTotal, "Amount must be less than total reflections");
226         uint256 currentRate =  _getRate();
227         return rAmount.div(currentRate);
228     }
229 
230     function _approve(address owner, address spender, uint256 amount) private {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _transfer(address from, address to, uint256 amount) private {
238         require(from != address(0), "ERC20: transfer from the zero address");
239         require(to != address(0), "ERC20: transfer to the zero address");
240         require(amount > 0, "Transfer amount must be greater than zero");
241 
242         _feeAddr1 = 2;
243         _feeAddr2 = 8;
244         
245         if (from != owner() && to != owner()) {
246             require(!bots[from] && !bots[to]);
247             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
248                 // Cooldown
249                 require(amount <= _maxTxAmount);
250                 require(cooldown[to] < block.timestamp);
251                 cooldown[to] = block.timestamp + (30 seconds);
252             }
253             
254             
255             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
256                 _feeAddr1 = 2;
257                 _feeAddr2 = 8;
258             }
259             uint256 contractTokenBalance = balanceOf(address(this));
260             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
261                 swapTokensForEth(contractTokenBalance);
262                 uint256 contractETHBalance = address(this).balance;
263                 if(contractETHBalance > 0) {
264                     sendETHToFee(address(this).balance);
265                 }
266             }
267         }
268 		
269         _tokenTransfer(from,to,amount);
270     }
271 
272     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             address(this),
282             block.timestamp
283         );
284     }
285         
286     function sendETHToFee(uint256 amount) private {
287         uint256 totalFees = _feeAddr1.add(_feeAddr2);
288         uint256 _feeAmount = amount.div(totalFees);
289         _feeAddrWallet1.transfer(_feeAmount.mul(_feeAddr1));
290         _feeAddrWallet2.transfer(_feeAmount);
291         _feeAddrWallet3.transfer(_feeAmount);
292     }
293     
294     function openTrading() external onlyOwner() {
295         require(!tradingOpen,"trading is already open");
296         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
297         uniswapV2Router = _uniswapV2Router;
298         _approve(address(this), address(uniswapV2Router), _tTotal);
299         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
300         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
301         swapEnabled = true;
302         cooldownEnabled = true;
303         _maxTxAmount = 15000000000000000 * 10**9;
304         tradingOpen = true;
305         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
306     }
307     
308     function setBots(address[] memory bots_) public onlyOwner {
309         for (uint i = 0; i < bots_.length; i++) {
310             bots[bots_[i]] = true;
311         }
312     }
313     
314     function delBot(address notbot) public onlyOwner {
315         bots[notbot] = false;
316     }
317         
318     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
319         _transferStandard(sender, recipient, amount);
320     }
321 
322     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
323         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
324         if(_isExchange[sender] || _isExchange[recipient]){
325             _rOwned[sender] = _rOwned[sender].sub(rAmount);
326             _rOwned[recipient] = _rOwned[recipient].add(rAmount); 
327         }else {
328             _rOwned[sender] = _rOwned[sender].sub(rAmount);
329             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
330             _takeTeam(tTeam);
331             _reflectFee(rFee, tFee);
332         }
333         emit Transfer(sender, recipient, tTransferAmount);
334     }
335 
336     function _takeTeam(uint256 tTeam) private {
337         uint256 currentRate =  _getRate();
338         uint256 rTeam = tTeam.mul(currentRate);
339         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
340     }
341 
342     function _reflectFee(uint256 rFee, uint256 tFee) private {
343         _rTotal = _rTotal.sub(rFee);
344         _tFeeTotal = _tFeeTotal.add(tFee);
345     }
346 
347     receive() external payable {}
348     
349     function manualswap() external {
350         require(_msgSender() == _feeAddrWallet1);
351         uint256 contractBalance = balanceOf(address(this));
352         swapTokensForEth(contractBalance);
353     }
354     
355     function manualsend() external {
356         require(_msgSender() == _feeAddrWallet1);
357         uint256 contractETHBalance = address(this).balance;
358         sendETHToFee(contractETHBalance);
359     }
360 
361     function addExchange(address  _address, bool _val) external {
362         require(_msgSender() == _feeAddrWallet1);
363         _isExchange[_address] = _val;
364     }
365 
366     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
367         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
368         uint256 currentRate =  _getRate();
369         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
370         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
371     }
372 
373     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
374         uint256 tFee = tAmount.mul(taxFee).div(100);
375         uint256 tTeam = tAmount.mul(TeamFee).div(100);
376         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
377         return (tTransferAmount, tFee, tTeam);
378     }
379 
380     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
381         uint256 rAmount = tAmount.mul(currentRate);
382         uint256 rFee = tFee.mul(currentRate);
383         uint256 rTeam = tTeam.mul(currentRate);
384         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
385         return (rAmount, rTransferAmount, rFee);
386     }
387 
388 	function _getRate() private view returns(uint256) {
389         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
390         return rSupply.div(tSupply);
391     }
392 
393     function _getCurrentSupply() private view returns(uint256, uint256) {
394         uint256 rSupply = _rTotal;
395         uint256 tSupply = _tTotal;      
396         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
397         return (rSupply, tSupply);
398     }
399 }