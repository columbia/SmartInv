1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.20;
3 
4 abstract contract Ownable {
5     address private _owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     constructor() {
10         _transferOwnership(msg.sender);
11     }
12 
13     modifier onlyOwner() {
14         _checkOwner();
15         _;
16     }
17 
18     function owner() public view virtual returns (address) {
19         return _owner;
20     }
21 
22     function transferOwnership(address newOwner) public virtual onlyOwner {
23         require(newOwner != address(0), "Ownable: new owner is the zero address");
24         _transferOwnership(newOwner);
25     }
26 
27     function renounceOwnership() public virtual onlyOwner {
28         _transferOwnership(address(0));
29     }
30 
31     function _checkOwner() internal view virtual {
32         require(owner() == msg.sender, "Ownable: caller is not the owner");
33     }
34 
35     function _transferOwnership(address newOwner) internal virtual {
36         address oldOwner = _owner;
37         _owner = newOwner;
38         emit OwnershipTransferred(oldOwner, newOwner);
39     }
40 }
41 
42 interface IERC20 {
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45     function balanceOf(address account) external view returns (uint256);
46     function totalSupply() external view returns (uint256);
47     function transfer(address to, uint256 amount) external returns (bool);
48     function approve(address spender, uint256 amount) external returns (bool);
49     function allowance(address owner, address spender) external view returns (uint256);
50     function transferFrom(address from, address to, uint256 amount) external returns (bool);
51 }
52 
53 interface IERC20Metadata is IERC20 {
54     function symbol() external view returns (string memory);
55     function name() external view returns (string memory);
56     function decimals() external view returns (uint8);
57 }
58 
59 contract ERC20 is IERC20, IERC20Metadata {
60     mapping(address => mapping(address => uint256)) private _allowances;
61     mapping(address => uint256) private _balances;
62     string private _name;
63     string private _symbol;
64     uint256 private _totalSupply;
65 
66     constructor(string memory name_, string memory symbol_) {
67         _symbol = symbol_;
68         _name = name_;
69     }
70 
71     function name() public view virtual override returns (string memory) {
72         return _name;
73     }
74 
75     function decimals() public view virtual override returns (uint8) {
76         return 18;
77     }
78 
79     function symbol() public view virtual override returns (string memory) {
80         return _symbol;
81     }
82 
83     function balanceOf(address account) public view virtual override returns (uint256) {
84         return _balances[account];
85     }
86 
87     function totalSupply() public view virtual override returns (uint256) {
88         return _totalSupply;
89     }
90 
91     function transfer(address to, uint256 amount) public virtual override returns (bool) {
92         address owner = msg.sender;
93         _transfer(owner, to, amount);
94         return true;
95     }
96 
97     function approve(address spender, uint256 amount) public virtual override returns (bool) {
98         address owner = msg.sender;
99         _approve(owner, spender, amount);
100         return true;
101     }
102 
103     function allowance(address owner, address spender) public view virtual override returns (uint256) {
104         return _allowances[owner][spender];
105     }
106 
107     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
108         address spender = msg.sender;
109         _spendAllowance(from, spender, amount);
110         _transfer(from, to, amount);
111         return true;
112     }
113 
114     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
115         address owner = msg.sender;
116         uint256 currentAllowance = allowance(owner, spender);
117         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
118         unchecked {
119             _approve(owner, spender, currentAllowance - subtractedValue);
120         }
121 
122         return true;
123     }
124 
125     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
126         address owner = msg.sender;
127         _approve(owner, spender, allowance(owner, spender) + addedValue);
128         return true;
129     }
130 
131     function _transfer(address from, address to, uint256 amount) internal virtual {
132         require(from != address(0), "ERC20: transfer from the zero address");
133         require(to != address(0), "ERC20: transfer to the zero address");
134 
135         uint256 fromBalance = _balances[from];
136         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
137         unchecked {
138             _balances[from] = fromBalance - amount;
139             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
140             // decrementing then incrementing.
141             _balances[to] += amount;
142         }
143 
144         emit Transfer(from, to, amount);
145     }
146 
147     function _mint(address account, uint256 amount) internal virtual {
148         require(account != address(0), "ERC20: mint to the zero address");
149 
150         _totalSupply += amount;
151         unchecked {
152             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
153             _balances[account] += amount;
154         }
155         emit Transfer(address(0), account, amount);
156     }
157 
158     function _burn(address account, uint256 amount) internal virtual {
159         require(account != address(0), "ERC20: burn from the zero address");
160 
161         uint256 accountBalance = _balances[account];
162         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
163         unchecked {
164             _balances[account] = accountBalance - amount;
165             // Overflow not possible: amount <= accountBalance <= totalSupply.
166             _totalSupply -= amount;
167         }
168 
169         emit Transfer(account, address(0), amount);
170     }
171 
172     function _approve(address owner, address spender, uint256 amount) internal virtual {
173         require(owner != address(0), "ERC20: approve from the zero address");
174         require(spender != address(0), "ERC20: approve to the zero address");
175 
176         _allowances[owner][spender] = amount;
177         emit Approval(owner, spender, amount);
178     }
179 
180     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
181         uint256 currentAllowance = allowance(owner, spender);
182         if (currentAllowance != type(uint256).max) {
183             require(currentAllowance >= amount, "ERC20: insufficient allowance");
184             unchecked {
185                 _approve(owner, spender, currentAllowance - amount);
186             }
187         }
188     }
189 }
190 
191 interface IPair {
192     function mint(address to) external returns (uint liquidity);
193 }
194 
195 interface IRouter {
196     function swapExactTokensForETHSupportingFeeOnTransferTokens(
197         uint amountIn,
198         uint amountOutMin,
199         address[] calldata path,
200         address to,
201         uint deadline
202     ) external;
203 }
204 
205 interface IWETH is IERC20 {
206     function deposit() external payable;
207 }
208 
209 contract FrensCoin is ERC20, Ownable {
210 
211     // Cannot be unset. Useful for DEX pairs and CEX wallets.
212     mapping (address => bool) isLimitExempt;
213 
214     uint256 public maxTxnAmount = type(uint256).max;
215     uint256 public txnLimitDenominator = 10000;
216     uint256 public txnLimitNumerator;
217 
218     // Cannot be set lower than 0.5% of supply
219     uint256 public minTxnLimitNumerator = 50;
220 
221     uint256 public maxWalletAmount = type(uint256).max;
222     uint256 public walletLimitDenominator = 10000;
223     uint256 public walletLimitNumerator;
224 
225     // Cannot be set lower than 1% of supply
226     uint256 public minWalletLimitNumerator = 100;
227 
228     bool public limitsEnabled;
229     uint256 earliestBlock;
230 
231     bool public airdropComplete = false;
232     bool public vestingFinished = false;
233 
234     mapping(address => uint256) public airdropAmount;
235     uint256 public launchTime;
236     uint256 public vestingPeriods = 30;
237     uint256 public vestingPercent = 3;
238 
239     bool private inFeeLiquidation = false;
240     bool public feesEnabled;
241     uint256 public collectedFees;
242 
243     uint256 public buyFeeNumerator;
244     uint256 public sellFeeNumerator;
245 
246     address public liquidationAMM;
247     address public feeRecipient;
248     address public weth;
249     IRouter public router;
250 
251     receive() external payable {}
252 
253     constructor() Ownable() ERC20("Frens", "FRENS") {
254         _mint(address(this), 10**12 * 10**18);
255     }
256 
257     function setIsLimitExempt(address _contract) external onlyOwner {
258         isLimitExempt[_contract] = true;
259     }
260 
261     function setTxnLimit(uint256 numerator) external onlyOwner {
262         require(numerator >= minTxnLimitNumerator);
263         txnLimitNumerator = numerator;
264         maxTxnAmount = totalSupply() * numerator  / txnLimitDenominator;
265     }
266 
267     function setWalletLimit(uint256 numerator) external onlyOwner {
268         require(numerator >= minWalletLimitNumerator);
269         walletLimitNumerator = numerator;
270         maxWalletAmount = totalSupply() * numerator / walletLimitDenominator;
271     }
272 
273     function toggleLimits() external onlyOwner {
274         limitsEnabled = !limitsEnabled;
275     }
276 
277     function permanentlyDisableFees() external onlyOwner {
278         require(!feesEnabled);
279         feesEnabled = false;
280     }
281 
282     function setFees(uint256 _buyFeeNumerator, uint256 _sellFeeNumerator) external onlyOwner {
283         require(_buyFeeNumerator <= buyFeeNumerator && _sellFeeNumerator <= sellFeeNumerator);
284         buyFeeNumerator = _buyFeeNumerator;
285         sellFeeNumerator = _sellFeeNumerator;
286     }
287 
288     function airdropTokens(address[] calldata holders, uint256[] calldata amounts) external onlyOwner {
289         require(!airdropComplete);
290 
291         for (uint i=0; i<holders.length; i++) {
292             super._transfer(address(this), holders[i], amounts[i]);
293             airdropAmount[holders[i]] += amounts[i];
294         }
295     }
296 
297     function finalizeAirdrop() external onlyOwner {
298         require(!airdropComplete);
299         airdropComplete = true;
300     }
301 
302     function _transfer(address from, address to, uint256 amount) internal override {
303         if (amount == 0 || inFeeLiquidation) {
304             super._transfer(from, to, amount);
305             return;
306         }
307 
308         if (limitsEnabled && from != address(this)) {
309             // Enforce TXN limit
310             require(amount <= maxTxnAmount, "Exceeded Max TXN Limit");
311 
312             // Enforce Wallet Limit
313             if (!isLimitExempt[to]) {
314                 require(amount + balanceOf(to) <= maxWalletAmount, "Exceeded Max Wallet Limit");
315             }
316 
317             // Enforce block delay
318             require(block.number >= earliestBlock, "No trading before liquidity add cooldown");
319         }
320 
321         // Sell
322         if (to == liquidationAMM) {
323             if (collectedFees > 0) {
324                 inFeeLiquidation = true;
325                 swapTokensForEth(collectedFees);
326                 collectedFees = 0;
327                 inFeeLiquidation = false;
328             }
329 
330             if (feesEnabled) {
331                 uint256 feeAmount = amount * sellFeeNumerator / 100;
332                 amount = amount - feeAmount;
333                 super._transfer(from, address(this), feeAmount);
334                 collectedFees += feeAmount;
335             }
336         }
337 
338         // Buy
339         if (from == liquidationAMM && feesEnabled) {
340             uint256 feeAmount = amount * buyFeeNumerator / 100;
341             amount = amount - feeAmount;
342             super._transfer(from, address(this), feeAmount);
343             collectedFees += feeAmount;
344         }
345 
346         if (!vestingFinished) {
347             uint256 airdroppedTokenAmount = airdropAmount[from];
348 
349             if (airdroppedTokenAmount > 0) {
350 
351                 uint256 elapsedPeriods = (block.timestamp - launchTime) / 86400;
352 
353                 if (elapsedPeriods < vestingPeriods) {
354                     uint256 minimumBalance = airdroppedTokenAmount - (
355                     // a number ranging from 0 to 100
356                     elapsedPeriods * vestingPercent
357                     * airdroppedTokenAmount
358                     / 100
359                     );
360                     require(balanceOf(from) - amount >= minimumBalance);
361                 } else {
362                     vestingFinished = true;
363                 }
364             }
365         }
366 
367         super._transfer(from, to, amount);
368     }
369 
370     function launch(
371         address _router,
372         address AMM,
373         address _weth,
374         uint256 _delay,
375         uint256 launchTokenAmount,
376         address lpReceiver,
377         address _feeRecipient,
378         uint256 _buyFeeNumerator,
379         uint256 _sellFeeNumerator,
380         uint256 _maxTxnNumerator,
381         uint256 _maxWalletNumerator
382     ) external payable onlyOwner {
383         require(launchTokenAmount <= balanceOf(address(this)));
384 
385         router = IRouter(_router);
386         liquidationAMM = AMM;
387         isLimitExempt[AMM] = true;
388         weth = _weth;
389 
390         limitsEnabled = true;
391         feesEnabled = true;
392 
393         buyFeeNumerator = _buyFeeNumerator;
394         sellFeeNumerator = _sellFeeNumerator;
395 
396         txnLimitNumerator = _maxTxnNumerator;
397         maxTxnAmount = totalSupply() * _maxTxnNumerator  / txnLimitDenominator;
398 
399         walletLimitNumerator = _maxWalletNumerator;
400         maxWalletAmount = totalSupply() * _maxWalletNumerator / walletLimitDenominator;
401 
402         feeRecipient = _feeRecipient;
403         launchTime = block.timestamp;
404 
405         // Token Reserves for Operations
406         super._transfer(address(this), _feeRecipient, 11250000000000000000000000000);
407 
408         // Token Reserve for Centralized Exchanges
409         super._transfer(address(this), _feeRecipient, 50000000000000000000000000000);
410 
411         // Deposit WETH for liquidity
412         IWETH WETH = IWETH(_weth);
413         WETH.deposit{value: msg.value}();
414 
415         // Transfer launchTokenAmount tokens to the pool
416         super._transfer(address(this), AMM, launchTokenAmount);
417 
418         // Transfer initial liquidity into the AMM
419         WETH.transfer(AMM, msg.value);
420 
421         // Mint LP tokens to the LP Receiver
422         IPair(AMM).mint(lpReceiver);
423 
424         // Set the earliestBlock to annoy snipers.
425         earliestBlock = block.number + _delay;
426     }
427 
428     function swapTokensForEth(uint256 tokenAmount) internal {
429         address[] memory path = new address[](2);
430         path[0] = address(this);
431         path[1] = weth;
432         _approve(address(this), address(router), tokenAmount);
433         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
434             tokenAmount,
435             0,
436             path,
437             feeRecipient,
438             block.timestamp
439         );
440     }
441 }