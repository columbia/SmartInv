1 /** 
2  * SPDX-License-Identifier: Unlicensed
3 
4 $Shineko Inu is the cutest token
5 that is going to launch on Ethereum network!
6 
7  * Twitter: https://twitter.com/SHINEKOINU
8 
9  * Telegram: https://t.me/shinekoinu
10 
11  * Website: https://shinekoinu.com/
12 
13  * */
14 
15  pragma solidity ^0.8.4;
16 
17  abstract contract Context {
18      function _msgSender() internal view virtual returns (address) {
19          return msg.sender;
20      }
21  }
22  
23  interface IERC20 {
24      function totalSupply() external view returns (uint256);
25      function balanceOf(address account) external view returns (uint256);
26      function transfer(address recipient, uint256 amount) external returns (bool);
27      function allowance(address owner, address spender) external view returns (uint256);
28      function approve(address spender, uint256 amount) external returns (bool);
29      function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30      event Transfer(address indexed from, address indexed to, uint256 value);
31      event Approval(address indexed owner, address indexed spender, uint256 value);
32  }
33  
34  library SafeMath {
35      function add(uint256 a, uint256 b) internal pure returns (uint256) {
36          uint256 c = a + b;
37          require(c >= a, "SafeMath: addition overflow");
38          return c;
39      }
40  
41      function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42          return sub(a, b, "SafeMath: subtraction overflow");
43      }
44  
45      function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46          require(b <= a, errorMessage);
47          uint256 c = a - b;
48          return c;
49      }
50  
51      function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52          if (a == 0) {
53              return 0;
54          }
55          uint256 c = a * b;
56          require(c / a == b, "SafeMath: multiplication overflow");
57          return c;
58      }
59  
60      function div(uint256 a, uint256 b) internal pure returns (uint256) {
61          return div(a, b, "SafeMath: division by zero");
62      }
63  
64      function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65          require(b > 0, errorMessage);
66          uint256 c = a / b;
67          return c;
68      }
69  
70  }
71  
72  contract Ownable is Context {
73      address private _owner;
74      address private _previousOwner;
75      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76  
77      constructor () {
78          address msgSender = _msgSender();
79          _owner = msgSender;
80          emit OwnershipTransferred(address(0), msgSender);
81      }
82  
83      function owner() public view returns (address) {
84          return _owner;
85      }
86  
87      modifier onlyOwner() {
88          require(_owner == _msgSender(), "Ownable: caller is not the owner");
89          _;
90      }
91  
92      function renounceOwnership() public virtual onlyOwner {
93          emit OwnershipTransferred(_owner, address(0));
94          _owner = address(0);
95      }
96  
97  }  
98  
99  interface IUniswapV2Factory {
100      function createPair(address tokenA, address tokenB) external returns (address pair);
101  }
102  
103  interface IUniswapV2Router02 {
104      function swapExactTokensForETHSupportingFeeOnTransferTokens(
105          uint amountIn,
106          uint amountOutMin,
107          address[] calldata path,
108          address to,
109          uint deadline
110      ) external;
111      function factory() external pure returns (address);
112      function WETH() external pure returns (address);
113      function addLiquidityETH(
114          address token,
115          uint amountTokenDesired,
116          uint amountTokenMin,
117          uint amountETHMin,
118          address to,
119          uint deadline
120      ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121  }
122  
123  contract Shineko is Context, IERC20, Ownable {
124      using SafeMath for uint256;
125      mapping (address => uint256) private _rOwned;
126      mapping (address => uint256) private _tOwned;
127      mapping (address => uint256) private _buyMap;
128      mapping (address => mapping (address => uint256)) private _allowances;
129      mapping (address => bool) private _isExcludedFromFee;
130      mapping (address => bool) private bots;
131      mapping (address => uint) private cooldown;
132      uint256 private constant MAX = ~uint256(0);
133      uint256 private constant _tTotal = 1e12 * 10**9;
134      uint256 private _rTotal = (MAX - (MAX % _tTotal));
135      uint256 private _tFeeTotal;
136      
137      uint256 private _feeAddr1;
138      uint256 private _feeAddr2;
139      address payable private _feeAddrWallet1;
140      address payable private _feeAddrWallet2;
141      
142      string private constant _name = "Shineko Inu";
143      string private constant _symbol = "Shineko";
144      uint8 private constant _decimals = 9;   
145      
146      IUniswapV2Router02 private uniswapV2Router;
147      address private uniswapV2Pair;
148      bool private tradingOpen;
149      bool private inSwap = false;
150      bool private swapEnabled = false;
151      bool private cooldownEnabled = false;
152      uint256 private _maxTxAmount = _tTotal;
153      event MaxTxAmountUpdated(uint _maxTxAmount);
154      modifier lockTheSwap {
155          inSwap = true;
156          _;
157          inSwap = false;
158      }
159      constructor () {
160          _feeAddrWallet1 = payable(0xd82A14149A16dc1765607A07aFC8fc5A8Ef90669);
161          _feeAddrWallet2 = payable(0xd82A14149A16dc1765607A07aFC8fc5A8Ef90669);
162          _rOwned[_msgSender()] = _rTotal;
163          _isExcludedFromFee[owner()] = true;
164          _isExcludedFromFee[address(this)] = true;
165          _isExcludedFromFee[_feeAddrWallet1] = true;
166          _isExcludedFromFee[_feeAddrWallet2] = true;
167          emit Transfer(address(0xd82A14149A16dc1765607A07aFC8fc5A8Ef90669), _msgSender(), _tTotal);
168      }
169  
170      function name() public pure returns (string memory) {
171          return _name;
172      }
173  
174      function symbol() public pure returns (string memory) {
175          return _symbol;
176      }
177  
178      function decimals() public pure returns (uint8) {
179          return _decimals;
180      }
181  
182      function totalSupply() public pure override returns (uint256) {
183          return _tTotal;
184      }
185      
186      function originalPurchase(address account) public  view returns (uint256) {
187          return _buyMap[account];
188      }
189  
190      function balanceOf(address account) public view override returns (uint256) {
191          return tokenFromReflection(_rOwned[account]);
192      }
193  
194      function transfer(address recipient, uint256 amount) public override returns (bool) {
195          _transfer(_msgSender(), recipient, amount);
196          return true;
197      }
198  
199      function allowance(address owner, address spender) public view override returns (uint256) {
200          return _allowances[owner][spender];
201      }
202  
203      function approve(address spender, uint256 amount) public override returns (bool) {
204          _approve(_msgSender(), spender, amount);
205          return true;
206      }
207  
208      function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209          _transfer(sender, recipient, amount);
210          _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211          return true;
212      }
213  
214      function setCooldownEnabled(bool onoff) external onlyOwner() {
215          cooldownEnabled = onoff;
216      }
217      
218      function setMaxTx(uint256 maxTransactionAmount) external onlyOwner() {
219          _maxTxAmount = maxTransactionAmount;
220      }
221  
222      function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
223          require(rAmount <= _rTotal, "Amount must be less than total reflections");
224          uint256 currentRate =  _getRate();
225          return rAmount.div(currentRate);
226      }
227  
228      function _approve(address owner, address spender, uint256 amount) private {
229          require(owner != address(0), "ERC20: approve from the zero address");
230          require(spender != address(0), "ERC20: approve to the zero address");
231          _allowances[owner][spender] = amount;
232          emit Approval(owner, spender, amount);
233      }
234  
235      function _transfer(address from, address to, uint256 amount) private {
236          require(from != address(0), "ERC20: transfer from the zero address");
237          require(to != address(0), "ERC20: transfer to the zero address");
238          require(amount > 0, "Transfer amount must be greater than zero");
239      
240          
241          if (!_isBuy(from)) {
242              // TAX SELLERS 25% WHO SELL WITHIN 4 HOURS
243              if (_buyMap[from] != 0 &&
244                  (_buyMap[from] + (4 hours) >= block.timestamp))  {
245                  _feeAddr1 = 1;
246                  _feeAddr2 = 25;
247              } else {   
248                  _feeAddr1 = 2;
249                  _feeAddr2 = 12;
250              }
251          } else {
252              if (_buyMap[to] == 0) {
253                  _buyMap[to] = block.timestamp;
254              }
255              _feeAddr1 = 2;
256              _feeAddr2 = 12;
257          }
258          
259          if (from != owner() && to != owner()) {
260              require(!bots[from] && !bots[to]);
261              if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
262                  // Cooldown
263                  require(amount <= _maxTxAmount);
264                  require(cooldown[to] < block.timestamp);
265                  cooldown[to] = block.timestamp + (30 seconds);
266              }
267              
268              
269              uint256 contractTokenBalance = balanceOf(address(this));
270              if (!inSwap && from != uniswapV2Pair && swapEnabled) {
271                  swapTokensForEth(contractTokenBalance);
272                  uint256 contractETHBalance = address(this).balance;
273                  if(contractETHBalance > 0) {
274                      sendETHToFee(address(this).balance);
275                  }
276              }
277          }
278          
279          _tokenTransfer(from,to,amount);
280      }
281  
282      function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
283          address[] memory path = new address[](2);
284          path[0] = address(this);
285          path[1] = uniswapV2Router.WETH();
286          _approve(address(this), address(uniswapV2Router), tokenAmount);
287          uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
288              tokenAmount,
289              0,
290              path,
291              address(this),
292              block.timestamp
293          );
294      }
295          
296      function sendETHToFee(uint256 amount) private {
297          _feeAddrWallet1.transfer(amount.div(2));
298          _feeAddrWallet2.transfer(amount.div(2));
299      }
300      
301      function openTrading() external onlyOwner() {
302          require(!tradingOpen,"trading is already open");
303          IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
304          uniswapV2Router = _uniswapV2Router;
305          _approve(address(this), address(uniswapV2Router), _tTotal);
306          uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
307          uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
308          swapEnabled = true;
309          cooldownEnabled = true;
310          _maxTxAmount = 10000000000 * 10 ** 9;
311          tradingOpen = true;
312          IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
313      }
314      
315      function setBots(address[] memory bots_) public onlyOwner {
316          for (uint i = 0; i < bots_.length; i++) {
317              bots[bots_[i]] = true;
318          }
319      }
320      
321      function removeStrictTxLimit() public onlyOwner {
322          _maxTxAmount = 1e12 * 10**9;
323      }
324      
325      function delBot(address notbot) public onlyOwner {
326          bots[notbot] = false;
327      }
328          
329      function _tokenTransfer(address sender, address recipient, uint256 amount) private {
330          _transferStandard(sender, recipient, amount);
331      }
332  
333      function _transferStandard(address sender, address recipient, uint256 tAmount) private {
334          (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
335          _rOwned[sender] = _rOwned[sender].sub(rAmount);
336          _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
337          _takeTeam(tTeam);
338          _reflectFee(rFee, tFee);
339          emit Transfer(sender, recipient, tTransferAmount);
340      }
341  
342      function _takeTeam(uint256 tTeam) private {
343          uint256 currentRate =  _getRate();
344          uint256 rTeam = tTeam.mul(currentRate);
345          _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
346      }
347      
348      function updateMaxTx (uint256 fee) public onlyOwner {
349          _maxTxAmount = fee;
350      }
351      
352      function _reflectFee(uint256 rFee, uint256 tFee) private {
353          _rTotal = _rTotal.sub(rFee);
354          _tFeeTotal = _tFeeTotal.add(tFee);
355      }
356  
357      receive() external payable {}
358      
359      function manualswap() external {
360          require(_msgSender() == _feeAddrWallet1);
361          uint256 contractBalance = balanceOf(address(this));
362          swapTokensForEth(contractBalance);
363      }
364      
365      function manualsend() external {
366          require(_msgSender() == _feeAddrWallet1);
367          uint256 contractETHBalance = address(this).balance;
368          sendETHToFee(contractETHBalance);
369      }
370      
371  
372      function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
373          (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
374          uint256 currentRate =  _getRate();
375          (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
376          return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
377      }
378  
379      function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
380          uint256 tFee = tAmount.mul(taxFee).div(100);
381          uint256 tTeam = tAmount.mul(TeamFee).div(100);
382          uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
383          return (tTransferAmount, tFee, tTeam);
384      }
385  
386      function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
387          uint256 rAmount = tAmount.mul(currentRate);
388          uint256 rFee = tFee.mul(currentRate);
389          uint256 rTeam = tTeam.mul(currentRate);
390          uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
391          return (rAmount, rTransferAmount, rFee);
392      }
393  
394      function _isBuy(address _sender) private view returns (bool) {
395          return _sender == uniswapV2Pair;
396      }
397  
398  
399      function _getRate() private view returns(uint256) {
400          (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
401          return rSupply.div(tSupply);
402      }
403  
404      function _getCurrentSupply() private view returns(uint256, uint256) {
405          uint256 rSupply = _rTotal;
406          uint256 tSupply = _tTotal;      
407          if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
408          return (rSupply, tSupply);
409      }
410  }