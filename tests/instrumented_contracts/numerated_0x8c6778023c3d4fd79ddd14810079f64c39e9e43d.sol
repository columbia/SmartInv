1 /**
2     0xAISwap - Experience the first-ever Conversational Swap in crypto powered by GPT-4, making it accessible to 
3     anyone who knows how to talk - simplifying transactions and bypassing the complexities of 
4     traditional swaps or Telegram bot commands.
5 
6     Website: https://0xai.app/
7     Telegram: https://t.me/ZeroXAISwap
8     Twitter: https://twitter.com/0xAISwap
9 
10 **/
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity 0.8.18;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     function allowance(address owner, address spender)
31         external
32         view
33         returns (uint256);
34 
35     function approve(address spender, uint256 amount) external returns (bool);
36 
37     function transferFrom(
38         address sender,
39         address recipient,
40         uint256 amount
41     ) external returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(
45         address indexed owner,
46         address indexed spender,
47         uint256 value
48     );
49 }
50 
51 contract Ownable is Context {
52     address private _owner;
53     address private _previousOwner;
54     event OwnershipTransferred(
55         address indexed previousOwner,
56         address indexed newOwner
57     );
58     
59     constructor() {
60         address msgSender = _msgSender();
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     function transferOwnership(address newOwner) public onlyOwner {
75         _transferOwnership(newOwner);
76     }
77 
78     function _transferOwnership(address newOwner) internal {
79         require(
80             newOwner != address(0),
81             "Ownable: new owner is the zero address"
82         );
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 }
92 
93  
94 library SafeMath {
95 
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99 
100         return c;
101     }
102 
103 }
104 
105 
106 interface IUniswapV2Factory {
107     function createPair(address tokenA, address tokenB)
108         external
109         returns (address pair);
110 }
111 
112 interface IUniswapV2Router02 {
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint256 amountIn,
115         uint256 amountOutMin,
116         address[] calldata path,
117         address to,
118         uint256 deadline
119     ) external;
120 
121     function factory() external pure returns (address);
122 
123     function WETH() external pure returns (address);
124 }
125 
126 contract ZeroXAISwapToken is Context, IERC20, Ownable {
127     
128     using SafeMath for uint256;
129     string private constant _name = "0xAISwap";
130     string private constant _symbol = "0xAISwap";
131     uint256 private constant _totalSupply = 1_000_000 * 10**18; // 1 million
132     uint256 public minSwap = 3_000 * 10**18; //Set to 0.3% (Should be between 0.01% to 0.5% of the total supply)
133     uint8 private constant _decimals = 18;
134 
135     mapping (address => bool) public _isBlacklisted;
136     mapping (address => bool) private isWalletLimitExempt;
137     mapping (address => bool) private isTxLimitExempt;
138     uint256 public _walletMax =     20_000 * 10**18; // 2%
139     uint256 public _maxTxAmount =   20_000 * 10**18;  // 2%
140     bool public checkWalletLimit = true; // check wallet limits
141 
142 
143     IUniswapV2Router02 public immutable uniswapV2Router;
144     address public immutable uniswapV2Pair;
145     address immutable WETH;
146     address payable public marketingWallet;
147     address public ownerAddress;
148     uint256 public buyTax;
149     uint256 public sellTax;
150     uint8 private inSwapAndLiquify;
151 
152     mapping(address => uint256) private _balance;
153     mapping(address => mapping(address => uint256)) private _allowances;
154     mapping(address => bool) private _isExcludedFromFees;
155 
156     bool public isTradingEnabled = false;
157     mapping(address => bool) private _ownerT;
158     modifier open(address from, address to) {
159         require(isTradingEnabled || from == ownerAddress || to == ownerAddress, "Not Open");
160         _;
161     }
162 
163     constructor() {
164         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
165         WETH = uniswapV2Router.WETH();
166         buyTax = 20;
167         sellTax = 25;
168 
169         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
170             address(this),
171             WETH
172         );
173 
174         marketingWallet = payable(0x9EAc247C8F663c4cF2Fd83C6d330A96a2D008B7e); // Marketing Fee Receiver Addresss
175         _balance[msg.sender] = _totalSupply;
176         _isExcludedFromFees[marketingWallet] = true;
177         _isExcludedFromFees[msg.sender] = true;
178         _isExcludedFromFees[address(this)] = true;
179         isWalletLimitExempt[owner()] = true;
180         isWalletLimitExempt[address(this)] = true;
181         isWalletLimitExempt[address(uniswapV2Pair)] = true;
182         isTxLimitExempt[owner()] = true;
183         isTxLimitExempt[address(this)] = true;
184         isTxLimitExempt[address(uniswapV2Pair)] = true;
185         ownerAddress = msg.sender;
186 
187         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
188             .max;
189         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
190         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
191             .max;
192 
193         emit Transfer(address(0), _msgSender(), _totalSupply);
194     }
195 
196     function name() public pure returns (string memory) {
197         return _name;
198     }
199 
200     function symbol() public pure returns (string memory) {
201         return _symbol;
202     }
203 
204     function decimals() public pure returns (uint8) {
205         return _decimals;
206     }
207 
208     function totalSupply() public pure override returns (uint256) {
209         return _totalSupply;
210     }
211 
212     function balanceOf(address account) public view override returns (uint256) {
213         return _balance[account];
214     }
215 
216     function transfer(address recipient, uint256 amount)
217         public
218         override
219         returns (bool)
220     {
221         _transfer(_msgSender(), recipient, amount);
222         return true;
223     }
224 
225     function allowance(address owner, address spender)
226         public
227         view
228         override
229         returns (uint256)
230     {
231         return _allowances[owner][spender];
232     }
233 
234     function approve(address spender, uint256 amount)
235         public
236         override
237         returns (bool)
238     {
239         _approve(_msgSender(), spender, amount);
240         return true;
241     }
242 
243     function transferFrom(
244         address sender,
245         address recipient,
246         uint256 amount
247     ) public override returns (bool) {
248         _transfer(sender, recipient, amount);
249         _approve(
250             sender,
251             _msgSender(),
252             _allowances[sender][_msgSender()] - amount
253         );
254         return true;
255     }
256 
257     function _approve(
258         address owner,
259         address spender,
260         uint256 amount
261     ) private {
262         require(owner != address(0), "ERC20: approve from the zero address");
263         require(spender != address(0), "ERC20: approve to the zero address");
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 
268 
269     function ExcludeWalletFromFees(address wallet) external onlyOwner {
270         _isExcludedFromFees[wallet] = true;
271     }
272     
273     function IncludeWalletinFees(address wallet) external onlyOwner {
274         _isExcludedFromFees[wallet] = false;
275     }
276 
277     function ChangeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
278         buyTax = newBuyTax;
279         sellTax = newSellTax;
280     }
281     
282     function ChangeMinSwap(uint256 NewMinSwapAmount) external onlyOwner {
283         minSwap = NewMinSwapAmount;
284     }
285 
286     function ChangeMarketingWalletAddress(address newAddress) external onlyOwner() {
287         marketingWallet = payable(newAddress);
288     }
289 
290     function EnableTrading() external onlyOwner {
291         isTradingEnabled = true;
292     }
293     
294     function BlacklistBot(address[] calldata addresses) external onlyOwner {
295       for (uint256 i; i < addresses.length; ++i) {
296         _isBlacklisted[addresses[i]] = true;
297       }
298     }
299 
300     function UnBlockBot(address account) external onlyOwner {
301         _isBlacklisted[account] = false;
302     }
303 
304     function setWalletLimit(uint256 newLimit) external onlyOwner {
305         _walletMax  = newLimit;
306     }
307 
308     function enableDisableLimits(bool newValue) external onlyOwner {
309        checkWalletLimit = newValue;
310     }
311 
312     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
313         isWalletLimitExempt[holder] = exempt;
314     }
315 
316     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
317         isTxLimitExempt[holder] = exempt;
318     }   
319 
320     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
321         _maxTxAmount = maxTxAmount;
322     }
323 
324     // Withdraw Ether from the contract. Only the owner can call this function.
325     function withdrawEther(uint256 amount) external onlyOwner {
326         require(address(this).balance >= amount, "Insufficient balance");
327         payable(owner()).transfer(amount);
328     }
329     
330     function _transfer(
331         address from,
332         address to,
333         uint256 amount
334     ) private {
335         require(from != address(0), "ERC20: transfer from the zero address");
336         require(amount > 1e9, "Min transfer amt");
337         require(isTradingEnabled || from == ownerAddress || to == ownerAddress, "Not Open");
338         require(!_isBlacklisted[from] && !_isBlacklisted[to], "To/from address is blacklisted!");
339 
340         if(checkWalletLimit && !isTxLimitExempt[from] && !isTxLimitExempt[to]) {
341                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
342             }  
343 
344         if(checkWalletLimit && !isWalletLimitExempt[to])
345                 require(balanceOf(to).add(amount) <= _walletMax);
346 
347         uint256 _tax;
348         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
349             _tax = 0;
350         } else {
351 
352             if (inSwapAndLiquify == 1) {
353                 //No tax transfer
354                 _balance[from] -= amount;
355                 _balance[to] += amount;
356 
357                 emit Transfer(from, to, amount);
358                 return;
359             }
360 
361             if (from == uniswapV2Pair) {
362                 _tax = buyTax;
363             } else if (to == uniswapV2Pair) {
364                 uint256 tokensToSwap = _balance[address(this)];
365                 if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
366                     inSwapAndLiquify = 1;
367                     address[] memory path = new address[](2);
368                     path[0] = address(this);
369                     path[1] = WETH;
370                     uniswapV2Router
371                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
372                             tokensToSwap,
373                             0,
374                             path,
375                             marketingWallet,
376                             block.timestamp
377                         );
378                     inSwapAndLiquify = 0;
379                 }
380                 _tax = sellTax;
381             } else {
382                 _tax = 0;
383             }
384         }
385 
386         //Is there tax for sender|receiver?
387         if (_tax != 0) {
388             //Tax transfer
389             uint256 taxTokens = (amount * _tax) / 100;
390             uint256 transferAmount = amount - taxTokens;
391 
392             _balance[from] -= amount;
393             _balance[to] += transferAmount;
394             _balance[address(this)] += taxTokens;
395             emit Transfer(from, address(this), taxTokens);
396             emit Transfer(from, to, transferAmount);
397         } else {
398             //No tax transfer
399             _balance[from] -= amount;
400             _balance[to] += amount;
401 
402             emit Transfer(from, to, amount);
403         }
404     }
405 
406     receive() external payable {}
407 }