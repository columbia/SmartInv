1 /**
2     _  _   _______  _            _    _                   ____          _                        
3   _| || |_|__   __|| |          | |  | |                 |  _ \        | |                       
4  |_  __  _|  | |   | |__  __  __| |__| |  ___  _ __  ___ | |_) |  ___  | |__    __ _  _ __  __ _ 
5   _| || |_   | |   | '_ \ \ \/ /|  __  | / _ \| '__|/ _ \|  _ <  / _ \ | '_ \  / _` || '__|/ _` |
6  |_  __  _|  | |   | | | | >  < | |  | ||  __/| |  |  __/| |_) || (_) || |_) || (_| || |  | (_| |
7    |_||_|    |_|   |_| |_|/_/\_\|_|  |_| \___||_|   \___||____/  \___/ |_.__/  \__,_||_|   \__,_|
8                                                                                                  
9 $BOBARA is a zero-tax token powered by @ThxHereBobara Twitter bot, with a renounced contract and burned liquidity.
10 
11 Official Links:
12 https://twitter.com/ThxHereBobara
13 https://twitter.com/BobaraToken
14 https://t.me/BobaraToken    
15 https://bobara.love                                                                            
16 **/
17 
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity ^0.8.7;
21 
22 abstract contract Context {
23     function _msgSender() internal view returns (address payable) {
24         return payable(msg.sender);
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this;
29         return msg.data;
30     }
31 }
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35 
36     function balanceOf(address account) external view returns (uint256);
37 
38     function transfer(address recipient, uint256 amount)
39         external
40         returns (bool);
41 
42     function allowance(address owner, address spender)
43         external
44         view
45         returns (uint256);
46 
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     function transferFrom(
50         address sender,
51         address recipient,
52         uint256 amount
53     ) external returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(
57         address indexed owner,
58         address indexed spender,
59         uint256 value
60     );
61 }
62 
63 interface IDEXFactory {
64     function createPair(address tokenA, address tokenB)
65         external
66         returns (address pair);
67 }
68 
69 interface IDEXRouter {
70     function factory() external pure returns (address);
71 
72     function WETH() external pure returns (address);
73 
74     function addLiquidityETH(
75         address token,
76         uint256 amountTokenDesired,
77         uint256 amountTokenMin,
78         uint256 amountETHMin,
79         address to,
80         uint256 deadline
81     )
82         external
83         payable
84         returns (
85             uint256 amountToken,
86             uint256 amountETH,
87             uint256 liquidity
88         );
89 
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint256 amountIn,
92         uint256 amountOutMin,
93         address[] calldata path,
94         address to,
95         uint256 deadline
96     ) external;
97 }
98 
99 contract Ownable is Context {
100     address private _owner;
101 
102     event OwnershipTransferred(
103         address indexed previousOwner,
104         address indexed newOwner
105     );
106 
107     constructor() {
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
118         require(_owner == _msgSender(), "Ownable: caller is not the owner");
119         _;
120     }
121 
122     function renounceOwnership() public virtual onlyOwner {
123         emit OwnershipTransferred(_owner, address(0));
124         _owner = address(0);
125     }
126 
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(
129             newOwner != address(0),
130             "Ownable: new owner is the zero address"
131         );
132         emit OwnershipTransferred(_owner, newOwner);
133         _owner = newOwner;
134     }
135 }
136 
137 contract Bobara is IERC20, Ownable {
138     address DEAD = 0x000000000000000000000000000000000000dEaD;
139     address ZERO = 0x0000000000000000000000000000000000000000;
140 
141     string constant _name = "Bobara";
142     string constant _symbol = "BOBARA";
143     uint8 constant _decimals = 18;
144 
145     uint256 _totalSupply = 1_000_000_000 * (10**_decimals);
146 
147     uint256 public maxWalletSize = (_totalSupply * 2) / 100;
148 
149     mapping(address => uint256) _balances;
150     mapping(address => mapping(address => uint256)) _allowances;
151 
152     mapping(address => bool) isFeeExempt;
153     mapping(address => bool) liquidityCreator;
154 
155     uint256 marketingFee = 5000;
156     uint256 feeDenominator = 10000;
157 
158     IDEXRouter public router;
159     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
160     mapping(address => bool) liquidityPools;
161 
162     address public pair;
163 
164     uint256 public launchedAt;
165     bool public swapEnabled = false;
166     bool startBullRun = false;
167 
168     bool inSwap;
169     modifier swapping() {
170         inSwap = true;
171         _;
172         inSwap = false;
173     }
174 
175     modifier walletSizeLimit(address recipient, uint256 amount) {
176         if (
177             recipient != pair &&
178             !liquidityCreator[recipient] &&
179             !isFeeExempt[recipient]
180         ) {
181             require(
182                 _balances[recipient] + amount <= maxWalletSize,
183                 "Exceeds maximum wallet size"
184             );
185         }
186         _;
187     }
188 
189     address devWallet;
190     modifier onlyTeam() {
191         require(_msgSender() == devWallet, "Caller is not a team member");
192         _;
193     }
194 
195     event FundsDistributed(uint256 marketingFee);
196 
197     constructor() {
198         router = IDEXRouter(routerAddress);
199         pair = IDEXFactory(router.factory()).createPair(
200             router.WETH(),
201             address(this)
202         );
203         liquidityPools[pair] = true;
204         _allowances[owner()][routerAddress] = type(uint256).max;
205         _allowances[address(this)][routerAddress] = type(uint256).max;
206 
207         isFeeExempt[owner()] = true;
208         isFeeExempt[address(this)] = true;
209         liquidityCreator[owner()] = true;
210 
211         _balances[owner()] = _totalSupply;
212 
213         emit Transfer(address(0), owner(), _totalSupply);
214     }
215 
216     receive() external payable {}
217 
218     function totalSupply() external view override returns (uint256) {
219         return _totalSupply;
220     }
221 
222     function decimals() external pure returns (uint8) {
223         return _decimals;
224     }
225 
226     function symbol() external pure returns (string memory) {
227         return _symbol;
228     }
229 
230     function name() external pure returns (string memory) {
231         return _name;
232     }
233 
234     function getOwner() external view returns (address) {
235         return owner();
236     }
237 
238     function balanceOf(address account) public view override returns (uint256) {
239         return _balances[account];
240     }
241 
242     function allowance(address holder, address spender)
243         external
244         view
245         override
246         returns (uint256)
247     {
248         return _allowances[holder][spender];
249     }
250 
251     function approve(address spender, uint256 amount)
252         public
253         override
254         returns (bool)
255     {
256         _allowances[msg.sender][spender] = amount;
257         emit Approval(msg.sender, spender, amount);
258         return true;
259     }
260 
261     function approveMaximum(address spender) external returns (bool) {
262         return approve(spender, type(uint256).max);
263     }
264 
265     function setTeamWallet(address _team) external onlyOwner {
266         devWallet = _team;
267     }
268 
269     function setTaxFee(uint256 newTaxFee) external onlyOwner {
270         require(
271             newTaxFee >= 0 && newTaxFee <= feeDenominator,
272             "Invalid tax fee"
273         );
274         marketingFee = newTaxFee;
275     }
276 
277     function feeWithdrawal(uint256 amount) external onlyTeam {
278         uint256 amountETH = address(this).balance;
279         payable(devWallet).transfer((amountETH * amount) / 100);
280     }
281 
282     function launchTrading() external onlyOwner {
283         require(!startBullRun);
284         startBullRun = true;
285         launchedAt = block.number;
286     }
287 
288     function transfer(address recipient, uint256 amount)
289         external
290         override
291         returns (bool)
292     {
293         return _transferFrom(msg.sender, recipient, amount);
294     }
295 
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) external override returns (bool) {
301         if (_allowances[sender][msg.sender] != type(uint256).max) {
302             _allowances[sender][msg.sender] =
303                 _allowances[sender][msg.sender] -
304                 amount;
305         }
306 
307         return _transferFrom(sender, recipient, amount);
308     }
309 
310     function _transferFrom(
311         address sender,
312         address recipient,
313         uint256 amount
314     ) internal walletSizeLimit(recipient, amount) returns (bool) {
315         require(sender != address(0), "ERC20: transfer from 0x0");
316         require(recipient != address(0), "ERC20: transfer to 0x0");
317         require(amount > 0, "Amount must be > zero");
318         require(_balances[sender] >= amount, "Insufficient balance");
319 
320         if (!launched() && liquidityPools[recipient]) {
321             require(liquidityCreator[sender], "Liquidity not added yet.");
322             launch();
323         }
324 
325         if (!startBullRun) {
326             require(
327                 liquidityCreator[sender] || liquidityCreator[recipient],
328                 "Trading not open yet."
329             );
330         }
331 
332         if (inSwap) {
333             return _basicTransfer(sender, recipient, amount);
334         }
335 
336         _balances[sender] = _balances[sender] - amount;
337 
338         uint256 amountReceived = feeExcluded(sender)
339             ? takeFee(recipient, amount)
340             : amount;
341 
342         if (shouldSwapBack(recipient)) {
343             if (amount > 0) swapBack();
344         }
345 
346         _balances[recipient] = _balances[recipient] + amountReceived;
347 
348         emit Transfer(sender, recipient, amountReceived);
349         return true;
350     }
351 
352     function launched() internal view returns (bool) {
353         return launchedAt != 0;
354     }
355 
356     function launch() internal {
357         launchedAt = block.number;
358         swapEnabled = true;
359     }
360 
361     function _basicTransfer(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) internal returns (bool) {
366         _balances[sender] = _balances[sender] - amount;
367         _balances[recipient] = _balances[recipient] + amount;
368         emit Transfer(sender, recipient, amount);
369         return true;
370     }
371 
372     function feeExcluded(address sender) internal view returns (bool) {
373         return !isFeeExempt[sender];
374     }
375 
376     function isPurchaseOrSale(address sender, address recipient)
377         internal
378         view
379         returns (bool)
380     {
381         return sender == pair || recipient == pair;
382     }
383 
384     function takeFee(address recipient, uint256 amount)
385         internal
386         returns (uint256)
387     {
388         if (!isPurchaseOrSale(msg.sender, recipient)) {
389             return amount;
390         }
391 
392         uint256 feeAmount = (amount * marketingFee) / feeDenominator;
393         _balances[address(this)] += feeAmount;
394 
395         return amount - feeAmount;
396     }
397 
398     function shouldSwapBack(address recipient) internal view returns (bool) {
399         return
400             !liquidityPools[msg.sender] &&
401             !inSwap &&
402             swapEnabled &&
403             liquidityPools[recipient];
404     }
405 
406     function swapBack() internal swapping {
407         if (_balances[address(this)] > 0) {
408             uint256 amountToSwap = _balances[address(this)];
409 
410             address[] memory path = new address[](2);
411             path[0] = address(this);
412             path[1] = router.WETH();
413 
414             router.swapExactTokensForETHSupportingFeeOnTransferTokens(
415                 amountToSwap,
416                 0,
417                 path,
418                 address(this),
419                 block.timestamp
420             );
421 
422             emit FundsDistributed(amountToSwap);
423         }
424     }
425 
426     function addLiquidityCreator(address _liquidityCreator) external onlyOwner {
427         liquidityCreator[_liquidityCreator] = true;
428     }
429 
430     function changeSettings(bool _enabled) external onlyOwner {
431         swapEnabled = _enabled;
432     }
433 
434     function getCurrentSupply() public view returns (uint256) {
435         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
436     }
437 }