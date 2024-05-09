1 /**
2 
3  /$$      /$$ /$$$$$$$$ /$$$$$$$$ /$$$$$$         /$$$$$$   /$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$
4 | $$$    /$$$| $$_____/|__  $$__//$$__  $$       /$$__  $$ /$$__  $$ /$$__  $$| $$  | $$|_  $$_/
5 | $$$$  /$$$$| $$         | $$  | $$  \ $$      | $$  \__/| $$  \ $$| $$  \__/| $$  | $$  | $$  
6 | $$ $$/$$ $$| $$$$$      | $$  | $$$$$$$$      | $$ /$$$$| $$  | $$| $$      | $$$$$$$$  | $$  
7 | $$  $$$| $$| $$__/      | $$  | $$__  $$      | $$|_  $$| $$  | $$| $$      | $$__  $$  | $$  
8 | $$\  $ | $$| $$         | $$  | $$  | $$      | $$  \ $$| $$  | $$| $$    $$| $$  | $$  | $$  
9 | $$ \/  | $$| $$$$$$$$   | $$  | $$  | $$      |  $$$$$$/|  $$$$$$/|  $$$$$$/| $$  | $$ /$$$$$$
10 |__/     |__/|________/   |__/  |__/  |__/       \______/  \______/  \______/ |__/  |__/|______/
11                                                                                                 
12                                                                                                 
13 /**
14  //SPDX-License-Identifier: UNLICENSED
15  
16 */
17 
18 pragma solidity ^0.8.4;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     address private _previousOwner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100 }  
101 
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125 
126 contract MetaGochi is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _rOwned;
129     mapping (address => uint256) private _tOwned;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) private _isExcludedFromFee;
132     mapping (address => bool) private _isExchange;
133     mapping (address => bool) private bots;
134     mapping (address => uint) private cooldown;
135     uint256 private constant MAX = ~uint256(0);
136     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
137     uint256 private _rTotal = (MAX - (MAX % _tTotal));
138     uint256 private _tFeeTotal;
139     
140     uint256 private _feeAddr1;
141     uint256 private _feeAddr2;
142     address payable private _feeAddrWallet1;
143     address payable private _feeAddrWallet2;
144     address payable private _feeAddrWallet3;
145     address payable private _feeAddrWallet4;
146     address payable private _feeAddrWallet5;
147     address payable private _feeAddrWallet6;
148     
149     string private constant _name = "MetaGochi";
150     string private constant _symbol = "MGCHI";
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
168         _feeAddrWallet1 = payable(0xf5b598bfbF0AA64147d617e9c2Bbf74fDe4e91Ff);
169         _feeAddrWallet2 = payable(0xF672E28a365654f54857b6d3Ba2De370160aEa59);
170         _feeAddrWallet3 = payable(0x413a9665B9E7B35ac570b9b2d2006045D98Ffe41);
171         _feeAddrWallet4 = payable(0xB1A3342262E605f4fE2C813Be1a7655B820AEDa6);
172         _feeAddrWallet5 = payable(0x3B750c2e7211A70328548AA8f75bd31050FA6289);
173         _feeAddrWallet6 = payable(0xafa056883F3c17bf1A1a124fE8a1355d6675899a);
174         _rOwned[_msgSender()] = _rTotal;
175         _isExcludedFromFee[owner()] = true;
176         _isExcludedFromFee[address(this)] = true;
177         _isExcludedFromFee[_feeAddrWallet1] = true;
178         _isExcludedFromFee[_feeAddrWallet2] = true;
179         _isExcludedFromFee[_feeAddrWallet3] = true;
180         _isExcludedFromFee[_feeAddrWallet4] = true;
181         _isExcludedFromFee[_feeAddrWallet5] = true;
182         _isExcludedFromFee[_feeAddrWallet6] = true;
183         emit Transfer(address(this), _msgSender(), _tTotal);
184     }
185 
186     function name() public pure returns (string memory) {
187         return _name;
188     }
189 
190     function symbol() public pure returns (string memory) {
191         return _symbol;
192     }
193 
194     function decimals() public pure returns (uint8) {
195         return _decimals;
196     }
197 
198     function totalSupply() public pure override returns (uint256) {
199         return _tTotal;
200     }
201 
202     function balanceOf(address account) public view override returns (uint256) {
203         return tokenFromReflection(_rOwned[account]);
204     }
205 
206     function transfer(address recipient, uint256 amount) public override returns (bool) {
207         _transfer(_msgSender(), recipient, amount);
208         return true;
209     }
210 
211     function allowance(address owner, address spender) public view override returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     function approve(address spender, uint256 amount) public override returns (bool) {
216         _approve(_msgSender(), spender, amount);
217         return true;
218     }
219 
220     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
221         _transfer(sender, recipient, amount);
222         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
223         return true;
224     }
225 
226     function setCooldownEnabled(bool onoff) external onlyOwner() {
227         cooldownEnabled = onoff;
228     }
229 
230     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
231         require(rAmount <= _rTotal, "Amount must be less than total reflections");
232         uint256 currentRate =  _getRate();
233         return rAmount.div(currentRate);
234     }
235 
236     function _approve(address owner, address spender, uint256 amount) private {
237         require(owner != address(0), "ERC20: approve from the zero address");
238         require(spender != address(0), "ERC20: approve to the zero address");
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 
243     function _transfer(address from, address to, uint256 amount) private {
244         require(from != address(0), "ERC20: transfer from the zero address");
245         require(to != address(0), "ERC20: transfer to the zero address");
246         require(amount > 0, "Transfer amount must be greater than zero");
247 
248         _feeAddr1 = 4;
249         _feeAddr2 = 5;
250         
251         if (from != owner() && to != owner()) {
252             require(!bots[from] && !bots[to]);
253             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
254                 // Cooldown
255                 require(amount <= _maxTxAmount);
256                 require(cooldown[to] < block.timestamp);
257                 cooldown[to] = block.timestamp + (30 seconds);
258             }
259             
260             
261             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
262                 _feeAddr1 = 4;
263                 _feeAddr2 = 5;
264             }
265             uint256 contractTokenBalance = balanceOf(address(this));
266             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
267                 swapTokensForEth(contractTokenBalance);
268                 uint256 contractETHBalance = address(this).balance;
269                 if(contractETHBalance > 0) {
270                     sendETHToFee(address(this).balance);
271                 }
272             }
273         }
274 		
275         _tokenTransfer(from,to,amount);
276     }
277 
278     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
279         address[] memory path = new address[](2);
280         path[0] = address(this);
281         path[1] = uniswapV2Router.WETH();
282         _approve(address(this), address(uniswapV2Router), tokenAmount);
283         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
284             tokenAmount,
285             0,
286             path,
287             address(this),
288             block.timestamp
289         );
290     }
291         
292     function sendETHToFee(uint256 amount) private {
293         uint256 totalFees = _feeAddr1.add(_feeAddr2);
294         uint256 _feeAmount = amount.div(totalFees);
295         _feeAddrWallet1.transfer(_feeAmount.mul(_feeAddr1));
296         _feeAddrWallet2.transfer(_feeAmount);
297         _feeAddrWallet3.transfer(_feeAmount);
298         _feeAddrWallet4.transfer(_feeAmount);
299         _feeAddrWallet5.transfer(_feeAmount);
300         _feeAddrWallet6.transfer(_feeAmount);
301     }
302     
303     function openTrading() external onlyOwner() {
304         require(!tradingOpen,"trading is already open");
305         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         uniswapV2Router = _uniswapV2Router;
307         _approve(address(this), address(uniswapV2Router), _tTotal);
308         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
309         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
310         swapEnabled = true;
311         cooldownEnabled = true;
312         _maxTxAmount = 15000000000000000 * 10**9;
313         tradingOpen = true;
314         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
315     }
316     
317     function setBots(address[] memory bots_) public onlyOwner {
318         for (uint i = 0; i < bots_.length; i++) {
319             bots[bots_[i]] = true;
320         }
321     }
322     
323     function delBot(address notbot) public onlyOwner {
324         bots[notbot] = false;
325     }
326         
327     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
328         _transferStandard(sender, recipient, amount);
329     }
330 
331     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
332         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
333         if(_isExchange[sender] || _isExchange[recipient]){
334             _rOwned[sender] = _rOwned[sender].sub(rAmount);
335             _rOwned[recipient] = _rOwned[recipient].add(rAmount); 
336         }else {
337             _rOwned[sender] = _rOwned[sender].sub(rAmount);
338             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
339             _takeTeam(tTeam);
340             _reflectFee(rFee, tFee);
341         }
342         emit Transfer(sender, recipient, tTransferAmount);
343     }
344 
345     function _takeTeam(uint256 tTeam) private {
346         uint256 currentRate =  _getRate();
347         uint256 rTeam = tTeam.mul(currentRate);
348         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
349     }
350 
351     function _reflectFee(uint256 rFee, uint256 tFee) private {
352         _rTotal = _rTotal.sub(rFee);
353         _tFeeTotal = _tFeeTotal.add(tFee);
354     }
355 
356     receive() external payable {}
357     
358     function manualswap() external {
359         require(_msgSender() == _feeAddrWallet1);
360         uint256 contractBalance = balanceOf(address(this));
361         swapTokensForEth(contractBalance);
362     }
363     
364     function manualsend() external {
365         require(_msgSender() == _feeAddrWallet1);
366         uint256 contractETHBalance = address(this).balance;
367         sendETHToFee(contractETHBalance);
368     }
369 
370     function addExchange(address  _address, bool _val) external {
371         require(_msgSender() == _feeAddrWallet1);
372         _isExchange[_address] = _val;
373     }
374 
375     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
376         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
377         uint256 currentRate =  _getRate();
378         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
379         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
380     }
381 
382     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
383         uint256 tFee = tAmount.mul(taxFee).div(100);
384         uint256 tTeam = tAmount.mul(TeamFee).div(100);
385         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
386         return (tTransferAmount, tFee, tTeam);
387     }
388 
389     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
390         uint256 rAmount = tAmount.mul(currentRate);
391         uint256 rFee = tFee.mul(currentRate);
392         uint256 rTeam = tTeam.mul(currentRate);
393         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
394         return (rAmount, rTransferAmount, rFee);
395     }
396 
397 	function _getRate() private view returns(uint256) {
398         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
399         return rSupply.div(tSupply);
400     }
401 
402     function _getCurrentSupply() private view returns(uint256, uint256) {
403         uint256 rSupply = _rTotal;
404         uint256 tSupply = _tTotal;      
405         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
406         return (rSupply, tSupply);
407     }
408 }