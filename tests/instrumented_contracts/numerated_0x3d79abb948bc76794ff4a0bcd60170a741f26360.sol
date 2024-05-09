1 /**
2  
3  Tails $TAILS
4  Join Our Telegram: https://t.me/TAILSToken
5  
6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@%***@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@******@@
9 @@@@@@@@@@*******@@@@@@@@@@@@@@@@@@@@***********@@
10 @@@@@@@@@@***********@@@@@@@@@@@@***************@@
11 @@@@@@@@@@**************@@@@@@******************@@
12 @@@@@@@@&***************************************@@
13 @@@@*******************************************@@@
14 @***%@@@@@@@***********************************@@@
15 @@@@@@@@@@@*******************.***************@@@@
16 @@@@@@@@@**********   *****      ************@@@@@
17 @@@@@@@@***@@@****   *****     *  *********@@@@@@@
18 @@@@@@@**@@@@@@**   ******    *** ********@@****@@
19 @@@@@@@**********   ******    *** ************@@@@
20 @@@@@@@@@@******** ** *****   *****************@@@
21 @@@@@@@@@*****************************************
22 @@@@@@@@@************************************@@@@@
23 @@@@@@@@***@@**********************************@@@
24 @@@@@@@@@@@@**@@@@@@@@@@@@@@@@@@@@@@@@****@@@@@@@@
25 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@**@@@@@@@@
26 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
27    
28    
29 */
30 
31 pragma solidity ^0.8.4;
32 // SPDX-License-Identifier: UNLICENSED
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 }
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73         return c;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79 
80     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 
86 }
87 
88 contract Ownable is Context {
89     address private _owner;
90     address private _previousOwner;
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor () {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113 }  
114 
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB) external returns (address pair);
117 }
118 
119 interface IUniswapV2Router02 {
120     function swapExactTokensForETHSupportingFeeOnTransferTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external;
127     function factory() external pure returns (address);
128     function WETH() external pure returns (address);
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137 }
138 
139 contract TAILS is Context, IERC20, Ownable {
140     using SafeMath for uint256;
141     mapping (address => uint256) private _rOwned;
142     mapping (address => uint256) private _tOwned;
143     mapping (address => mapping (address => uint256)) private _allowances;
144     mapping (address => bool) private _isExcludedFromFee;
145     mapping (address => bool) private bots;
146     mapping (address => uint) private cooldown;
147     uint256 private constant MAX = ~uint256(0);
148     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
149     uint256 private _rTotal = (MAX - (MAX % _tTotal));
150     uint256 private _tFeeTotal;
151     
152     uint256 private _feeAddr1;
153     uint256 private _feeAddr2;
154     address payable private _feeAddrWallet1;
155     address payable private _feeAddrWallet2;
156     
157     string private constant _name = "TAILS";
158     string private constant _symbol = "TAILS";
159     uint8 private constant _decimals = 9;
160     
161     IUniswapV2Router02 private uniswapV2Router;
162     address private uniswapV2Pair;
163     bool private tradingOpen;
164     bool private inSwap = false;
165     bool private swapEnabled = false;
166     bool private cooldownEnabled = false;
167     uint256 private _maxTxAmount = _tTotal;
168     event MaxTxAmountUpdated(uint _maxTxAmount);
169     modifier lockTheSwap {
170         inSwap = true;
171         _;
172         inSwap = false;
173     }
174     constructor () {
175         _feeAddrWallet1 = payable(0xb1ad4ed9952025EacC264A0855233B3CE6F13eb7);
176         _feeAddrWallet2 = payable(0xb1ad4ed9952025EacC264A0855233B3CE6F13eb7);
177         _rOwned[_msgSender()] = _rTotal;
178         _isExcludedFromFee[owner()] = true;
179         _isExcludedFromFee[address(this)] = true;
180         _isExcludedFromFee[_feeAddrWallet1] = true;
181         _isExcludedFromFee[_feeAddrWallet2] = true;
182         emit Transfer(address(0x91b929bE8135CB7e1c83F775D4598a45aA8b334d), _msgSender(), _tTotal);
183     }
184 
185     function name() public pure returns (string memory) {
186         return _name;
187     }
188 
189     function symbol() public pure returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public pure returns (uint8) {
194         return _decimals;
195     }
196 
197     function totalSupply() public pure override returns (uint256) {
198         return _tTotal;
199     }
200 
201     function balanceOf(address account) public view override returns (uint256) {
202         return tokenFromReflection(_rOwned[account]);
203     }
204 
205     function transfer(address recipient, uint256 amount) public override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     function allowance(address owner, address spender) public view override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     function approve(address spender, uint256 amount) public override returns (bool) {
215         _approve(_msgSender(), spender, amount);
216         return true;
217     }
218 
219     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
220         _transfer(sender, recipient, amount);
221         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
222         return true;
223     }
224 
225     function setCooldownEnabled(bool onoff) external onlyOwner() {
226         cooldownEnabled = onoff;
227     }
228 
229     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
230         require(rAmount <= _rTotal, "Amount must be less than total reflections");
231         uint256 currentRate =  _getRate();
232         return rAmount.div(currentRate);
233     }
234 
235     function _approve(address owner, address spender, uint256 amount) private {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function _transfer(address from, address to, uint256 amount) private {
243         require(from != address(0), "ERC20: transfer from the zero address");
244         require(to != address(0), "ERC20: transfer to the zero address");
245         require(amount > 0, "Transfer amount must be greater than zero");
246         _feeAddr1 = 2;
247         _feeAddr2 = 8;
248         if (from != owner() && to != owner()) {
249             require(!bots[from] && !bots[to]);
250             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
251                 // Cooldown
252                 require(amount <= _maxTxAmount);
253                 require(cooldown[to] < block.timestamp);
254                 cooldown[to] = block.timestamp + (30 seconds);
255             }
256             
257             
258             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
259                 _feeAddr1 = 2;
260                 _feeAddr2 = 10;
261             }
262             uint256 contractTokenBalance = balanceOf(address(this));
263             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
264                 swapTokensForEth(contractTokenBalance);
265                 uint256 contractETHBalance = address(this).balance;
266                 if(contractETHBalance > 0) {
267                     sendETHToFee(address(this).balance);
268                 }
269             }
270         }
271 		
272         _tokenTransfer(from,to,amount);
273     }
274 
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         address[] memory path = new address[](2);
277         path[0] = address(this);
278         path[1] = uniswapV2Router.WETH();
279         _approve(address(this), address(uniswapV2Router), tokenAmount);
280         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(this),
285             block.timestamp
286         );
287     }
288         
289     function sendETHToFee(uint256 amount) private {
290         _feeAddrWallet1.transfer(amount.div(2));
291         _feeAddrWallet2.transfer(amount.div(2));
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
303         _maxTxAmount = 50000000000000000 * 10**9;
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
324         _rOwned[sender] = _rOwned[sender].sub(rAmount);
325         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
326         _takeTeam(tTeam);
327         _reflectFee(rFee, tFee);
328         emit Transfer(sender, recipient, tTransferAmount);
329     }
330 
331     function _takeTeam(uint256 tTeam) private {
332         uint256 currentRate =  _getRate();
333         uint256 rTeam = tTeam.mul(currentRate);
334         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
335     }
336 
337     function _reflectFee(uint256 rFee, uint256 tFee) private {
338         _rTotal = _rTotal.sub(rFee);
339         _tFeeTotal = _tFeeTotal.add(tFee);
340     }
341 
342     receive() external payable {}
343     
344     function manualswap() external {
345         require(_msgSender() == _feeAddrWallet1);
346         uint256 contractBalance = balanceOf(address(this));
347         swapTokensForEth(contractBalance);
348     }
349     
350     function manualsend() external {
351         require(_msgSender() == _feeAddrWallet1);
352         uint256 contractETHBalance = address(this).balance;
353         sendETHToFee(contractETHBalance);
354     }
355     
356 
357     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
358         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
359         uint256 currentRate =  _getRate();
360         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
361         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
362     }
363 
364     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
365         uint256 tFee = tAmount.mul(taxFee).div(100);
366         uint256 tTeam = tAmount.mul(TeamFee).div(100);
367         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
368         return (tTransferAmount, tFee, tTeam);
369     }
370 
371     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
372         uint256 rAmount = tAmount.mul(currentRate);
373         uint256 rFee = tFee.mul(currentRate);
374         uint256 rTeam = tTeam.mul(currentRate);
375         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
376         return (rAmount, rTransferAmount, rFee);
377     }
378 
379 	function _getRate() private view returns(uint256) {
380         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
381         return rSupply.div(tSupply);
382     }
383 
384     function _getCurrentSupply() private view returns(uint256, uint256) {
385         uint256 rSupply = _rTotal;
386         uint256 tSupply = _tTotal;      
387         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
388         return (rSupply, tSupply);
389     }
390 }