1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 abstract contract Ownable is Context {
61     address private _owner;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor() {
69         _setOwner(_msgSender());
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     /**
88      * @dev Leaves the contract without owner. It will not be possible to call
89      * `onlyOwner` functions anymore. Can only be called by the current owner.
90      *
91      * NOTE: Renouncing ownership will leave the contract without an owner,
92      * thereby removing any functionality that is only available to the owner.
93      */
94     function renounceOwnership() public virtual onlyOwner {
95         _setOwner(address(0));
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _setOwner(newOwner);
105     }
106 
107     function _setOwner(address newOwner) private {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 interface IUniswapV2Factory {
115     function createPair(address tokenA, address tokenB) external returns (address pair);
116 }
117 
118 interface IUniswapV2Router02 {
119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126     function factory() external pure returns (address);
127     function WETH() external pure returns (address);
128     function addLiquidityETH(
129         address token,
130         uint amountTokenDesired,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
136 }
137 
138 contract CyOpProtocol is Context, IERC20, Ownable {
139     using SafeMath for uint256;
140     mapping (address => uint256) private _rOwned;
141     mapping (address => uint256) private _tOwned;
142     mapping (address => mapping (address => uint256)) private _allowances;
143     mapping (address => bool) public isExcludedFromFee;
144     mapping (address => bool) private bots;
145     uint256 private constant MAX = ~uint256(0);
146     uint256 private constant _tTotal = 100e12 * 10**9; //100 trillion
147     uint256 private _rTotal = (MAX - (MAX % _tTotal));
148     uint256 private _tFeeTotal;
149     uint256 private zeroFee; //0%
150     uint256 public treasury1Fee = 4; //4%
151     uint256 public treasury2Fee = 6; //6%
152     uint256 public protocolFee = 10; //gowth hacking(4%) + protocol(6%)
153     uint256 private prevProtocolFee; //gowth hacking(4%) + protocol(6%)
154     address payable public treasury1; //4%
155     address payable public treasury2; //6%
156     
157     string private constant _name = "CyOp | Protocol";
158     string private constant _symbol = "CyOp";
159     uint8 private constant _decimals = 9;
160     
161     IUniswapV2Router02 private uniswapV2Router;
162     address private uniswapV2Pair;
163 
164     bool private inSwap;
165     bool public sellingEnabled;
166     bool public swapEnabled;
167     
168     uint256 public contractStartTime;
169     uint256 public maxTxAmount = 3e12 * 10**9; //3%-3 trillion
170     
171     event MaxTxAmountUpdated(uint maxTxAmount);
172 
173     modifier lockTheSwap {
174         inSwap = true;
175         _;
176         inSwap = false;
177     }
178 
179     constructor (address _treasury1, address _treasury2) {
180     	uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
181         treasury1 = payable(_treasury1);
182         treasury2 = payable(_treasury2);
183         contractStartTime = block.timestamp;
184         _rOwned[_msgSender()] = _rTotal;
185         isExcludedFromFee[owner()] = true;
186         isExcludedFromFee[address(this)] = true;
187         isExcludedFromFee[treasury1] = true;
188         isExcludedFromFee[treasury2] = true;
189         swapEnabled = true;
190         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
191     }
192 
193     function name() public pure returns (string memory) {
194         return _name;
195     }
196 
197     function symbol() public pure returns (string memory) {
198         return _symbol;
199     }
200 
201     function decimals() public pure returns (uint8) {
202         return _decimals;
203     }
204 
205     function totalSupply() public pure override returns (uint256) {
206         return _tTotal;
207     }
208 
209     function balanceOf(address account) public view override returns (uint256) {
210         return tokenFromReflection(_rOwned[account]);
211     }
212 
213     function transfer(address recipient, uint256 amount) public override returns (bool) {
214         _transfer(_msgSender(), recipient, amount);
215         return true;
216     }
217 
218     function allowance(address owner, address spender) public view override returns (uint256) {
219         return _allowances[owner][spender];
220     }
221 
222     function approve(address spender, uint256 amount) public override returns (bool) {
223         _approve(_msgSender(), spender, amount);
224         return true;
225     }
226 
227     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
228         _transfer(sender, recipient, amount);
229         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
230         return true;
231     }
232 
233     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
234         require(rAmount <= _rTotal, "Amount must be less than total reflections");
235         uint256 currentRate =  _getRate();
236         return rAmount.div(currentRate);
237     }
238 
239     function _approve(address owner, address spender, uint256 amount) private {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242         require (owner == Ownable.owner() ||  block.timestamp > contractStartTime + 20 minutes, "Selling is disabled.");
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247     function _transfer(address from, address to, uint256 amount) private {
248         require(from != address(0), "ERC20: transfer from the zero address");
249         require(to != address(0), "ERC20: transfer to the zero address");
250         require(amount > 0, "Transfer amount must be greater than zero");
251         
252         if (from != owner() && to != owner()) {
253             require(!bots[from] && !bots[to]);
254             require(amount <= maxTxAmount);
255 
256             uint256 contractTokenBalance = balanceOf(address(this));
257             if (!inSwap && contractTokenBalance > 0 && from != uniswapV2Pair && swapEnabled) {
258                 swapTokensForEth(contractTokenBalance);
259                 uint256 contractETHBalance = address(this).balance;
260                 if(contractETHBalance > 0) {
261                     sendETHToTreasury(contractETHBalance);
262                 }
263             }
264         }
265 
266         bool takeFee = true;
267 
268         //if any account belongs to isExcludedFromFee account then remove the fee
269         if(isExcludedFromFee[from] || isExcludedFromFee[to]){
270             takeFee = false;
271         }
272 
273         if(!takeFee)
274             removeAllFee();
275 		
276         _tokenTransfer(from,to,amount);
277 
278         if(!takeFee)
279             restoreAllFee();
280     }
281 
282     function removeAllFee() private {
283         if(protocolFee == 0) return;
284         
285         prevProtocolFee = protocolFee;
286         protocolFee = 0;
287     }
288 
289     function restoreAllFee() private {
290         protocolFee = prevProtocolFee;
291     }
292 
293     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
294         address[] memory path = new address[](2);
295         path[0] = address(this);
296         path[1] = uniswapV2Router.WETH();
297         _approve(address(this), address(uniswapV2Router), tokenAmount);
298         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
299             tokenAmount,
300             0,
301             path,
302             address(this),
303             block.timestamp
304         );
305     }
306         
307     function sendETHToTreasury(uint256 amount) private {
308         treasury1.transfer((amount.mul(treasury1Fee).mul(100).div(protocolFee)).div(100));
309         treasury2.transfer((amount.mul(treasury2Fee).mul(100).div(protocolFee)).div(100));
310     }
311 
312     function setFee(uint256 _treasury1Fee, uint256 _treasury2Fee) external onlyOwner {
313         treasury1Fee = _treasury1Fee;
314         treasury2Fee = _treasury2Fee;
315         protocolFee = treasury1Fee + treasury2Fee;
316     }
317 
318     function updateTreasury(address _treasury1, address _treasury2) external onlyOwner {
319         treasury1 = payable(_treasury1);
320         treasury2 = payable(_treasury2);
321     }
322 
323     function excludeFromFee(address account) public onlyOwner {
324         isExcludedFromFee[account] = true;
325     }
326     
327     function includeInFee(address account) public onlyOwner {
328         isExcludedFromFee[account] = false;
329     }
330     
331     function setBots(address[] memory bots_) public onlyOwner {
332         for (uint i = 0; i < bots_.length; i++) {
333             bots[bots_[i]] = true;
334         }
335     }
336     
337     //in percentages
338     function setMaxTxLimit(uint256 _maxPercent) external onlyOwner {
339         maxTxAmount = (_tTotal * _maxPercent) / 100;
340     }
341     
342     function delBot(address notbot) external onlyOwner {
343         bots[notbot] = false;
344     }
345 
346     function enableSwap(bool enabled) external onlyOwner {	
347 	    swapEnabled = enabled;	
348     }
349 
350     function setPairAddress(address _uniswapV2Pair) external onlyOwner {	
351 	    uniswapV2Pair = _uniswapV2Pair;	
352     }
353         
354     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
355         _transferStandard(sender, recipient, amount);
356     }
357 
358     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
359         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tProtocol) = _getValues(tAmount);
360         _rOwned[sender] = _rOwned[sender].sub(rAmount);
361         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
362         _takeProtocol(tProtocol);
363         _reflectFee(rFee, tFee);
364         emit Transfer(sender, recipient, tTransferAmount);
365     }
366 
367     function _takeProtocol(uint256 tProtocol) private {
368         uint256 currentRate =  _getRate();
369         uint256 rProtocol = tProtocol.mul(currentRate);
370         _rOwned[address(this)] = _rOwned[address(this)].add(rProtocol);
371     }
372 
373     function _reflectFee(uint256 rFee, uint256 tFee) private {
374         _rTotal = _rTotal.sub(rFee);
375         _tFeeTotal = _tFeeTotal.add(tFee);
376     }
377 
378     receive() external payable {}
379     
380     function manualswapTreasury() external {
381         require(_msgSender() == treasury1 || _msgSender() == treasury2);
382         uint256 contractBalance = balanceOf(address(this));
383         swapTokensForEth(contractBalance);
384         manualsend();
385     }
386     
387     function manualsend() internal {
388         uint256 contractETHBalance = address(this).balance;
389         sendETHToTreasury(contractETHBalance);
390     }
391 
392     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
393         (uint256 tTransferAmount, uint256 tFee, uint256 tProtocol) = _getTValues(tAmount, zeroFee, protocolFee);
394         uint256 currentRate =  _getRate();
395         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tProtocol, currentRate);
396         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tProtocol);
397     }
398 
399     function _getTValues(uint256 _tAmount, uint256 taxFee, uint256 _protocolFee) private pure returns (uint256, uint256, uint256) {
400         uint256 tFee = _tAmount.mul(taxFee).div(100);
401         uint256 tProtocol = _tAmount.mul(_protocolFee).div(100);
402         uint256 tTransferAmount = _tAmount.sub(tFee).sub(tProtocol);
403         return (tTransferAmount, tFee, tProtocol);
404     }
405 
406     function _getRValues(uint256 _tAmount, uint256 _tFee, uint256 _tProtocol, uint256 _currentRate) private pure returns (uint256, uint256, uint256) {
407         uint256 rAmount = _tAmount.mul(_currentRate);
408         uint256 rFee = _tFee.mul(_currentRate);
409         uint256 rProtocol = _tProtocol.mul(_currentRate);
410         uint256 rTransferAmount = rAmount.sub(rFee).sub(rProtocol);
411         return (rAmount, rTransferAmount, rFee);
412     }
413 
414 	function _getRate() private view returns(uint256) {
415         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
416         return rSupply.div(tSupply);
417     }
418 
419     function _getCurrentSupply() private view returns(uint256, uint256) {
420         uint256 rSupply = _rTotal;
421         uint256 tSupply = _tTotal;      
422         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
423         return (rSupply, tSupply);
424     }
425 }