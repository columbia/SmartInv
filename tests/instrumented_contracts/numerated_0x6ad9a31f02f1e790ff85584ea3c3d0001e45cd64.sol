1 /**
2  ______ _______ _    _          _   _ ______ 
3  |  ____|__   __| |  | |   /\   | \ | |  ____|
4  | |__     | |  | |__| |  /  \  |  \| | |__   
5  |  __|    | |  |  __  | / /\ \ | . ` |  __|  
6  | |____   | |  | |  | |/ ____ \| |\  | |____ 
7  |______|  |_|  |_|  |_/_/    \_\_| \_|______|
8                                               
9                                          
10 
11     > https://ethane.app/
12     > https://t.me/EthaneErc
13     > https://twitter.com/EthaneErc
14 
15 */
16 
17 // SPDX-License-Identifier: MIT
18  
19 pragma solidity 0.8.18;
20  
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25  
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30  
31 abstract contract Ownable is Context {
32     address private _owner;
33  
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35  
36     constructor() {
37         _transferOwnership(_msgSender());
38     }
39  
40     modifier onlyOwner() {
41         _checkOwner();
42         _;
43     }
44  
45     function owner() public view virtual returns (address) {
46         return _owner;
47     }
48  
49     function _checkOwner() internal view virtual {
50         require(owner() == _msgSender(), "Ownable: caller is not the owner");
51     }
52  
53     function renounceOwnership() public virtual onlyOwner {
54         _transferOwnership(address(0));
55     }
56  
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _transferOwnership(newOwner);
60     }
61  
62     function _transferOwnership(address newOwner) internal virtual {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68  
69 interface IERC20 {
70  
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73     function totalSupply() external view returns (uint256);
74     function balanceOf(address account) external view returns (uint256);
75     function transfer(address to, uint256 amount) external returns (bool);
76     function allowance(address owner, address spender) external view returns (uint256);
77     function approve(address spender, uint256 amount) external returns (bool);
78     function transferFrom(
79         address from,
80         address to,
81         uint256 amount
82     ) external returns (bool);
83 }
84  
85 interface IERC20Metadata is IERC20 {
86  
87     function name() external view returns (string memory);
88     function symbol() external view returns (string memory);
89     function decimals() external view returns (uint8);
90 }
91  
92 contract ERC20 is Context, IERC20, IERC20Metadata {
93     mapping(address => uint256) private _balances;
94  
95     mapping(address => mapping(address => uint256)) private _allowances;
96  
97     uint256 private _totalSupply;
98  
99     string private _name;
100     string private _symbol;
101 
102     uint256 internal immutable INITIAL_CHAIN_ID;
103     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
104     mapping(address => uint256) public nonces;
105  
106     constructor(string memory name_, string memory symbol_) {
107         _name = name_;
108         _symbol = symbol_;
109 
110         INITIAL_CHAIN_ID = block.chainid;
111         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
112     }
113  
114     function name() public view virtual override returns (string memory) {
115         return _name;
116     }
117  
118     function symbol() public view virtual override returns (string memory) {
119         return _symbol;
120     }
121  
122     function decimals() public view virtual override returns (uint8) {
123         return 18;
124     }
125  
126     function totalSupply() public view virtual override returns (uint256) {
127         return _totalSupply;
128     }
129  
130     function balanceOf(address account) public view virtual override returns (uint256) {
131         return _balances[account];
132     }
133  
134     function transfer(address to, uint256 amount) public virtual override returns (bool) {
135         address owner = _msgSender();
136         _transfer(owner, to, amount);
137         return true;
138     }
139  
140     function allowance(address owner, address spender) public view virtual override returns (uint256) {
141         return _allowances[owner][spender];
142     }
143  
144     function approve(address spender, uint256 amount) public virtual override returns (bool) {
145         address owner = _msgSender();
146         _approve(owner, spender, amount);
147         return true;
148     }
149  
150     function transferFrom(
151         address from,
152         address to,
153         uint256 amount
154     ) public virtual override returns (bool) {
155         address spender = _msgSender();
156         _spendAllowance(from, spender, amount);
157         _transfer(from, to, amount);
158         return true;
159     }
160  
161     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
162         address owner = _msgSender();
163         _approve(owner, spender, allowance(owner, spender) + addedValue);
164         return true;
165     }
166  
167     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
168         address owner = _msgSender();
169         uint256 currentAllowance = allowance(owner, spender);
170         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
171         unchecked {
172             _approve(owner, spender, currentAllowance - subtractedValue);
173         }
174  
175         return true;
176     }
177  
178     function _transfer(
179         address from,
180         address to,
181         uint256 amount
182     ) internal virtual {
183         require(from != address(0), "ERC20: transfer from the zero address");
184         require(to != address(0), "ERC20: transfer to the zero address");
185  
186         _beforeTokenTransfer(from, to, amount);
187  
188         uint256 fromBalance = _balances[from];
189         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
190         unchecked {
191             _balances[from] = fromBalance - amount;
192             _balances[to] += amount;
193         }
194  
195         emit Transfer(from, to, amount);
196  
197         _afterTokenTransfer(from, to, amount);
198     }
199 
200     function permit(
201         address owner,
202         address spender,
203         uint256 value,
204         uint256 deadline,
205         uint8 v,
206         bytes32 r,
207         bytes32 s
208     ) public virtual {
209         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
210 
211         // Unchecked because the only math done is incrementing
212         // the owner's nonce which cannot realistically overflow.
213         unchecked {
214             address recoveredAddress = ecrecover(
215                 keccak256(
216                     abi.encodePacked(
217                         "\x19\x01",
218                         DOMAIN_SEPARATOR(),
219                         keccak256(
220                             abi.encode(
221                                 keccak256(
222                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
223                                 ),
224                                 owner,
225                                 spender,
226                                 value,
227                                 nonces[owner]++,
228                                 deadline
229                             )
230                         )
231                     )
232                 ),
233                 v,
234                 r,
235                 s
236             );
237 
238             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
239 
240             _allowances[recoveredAddress][spender] = value;
241         }
242 
243         emit Approval(owner, spender, value);
244     }
245 
246     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
247         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
248     }
249 
250     function computeDomainSeparator() internal view virtual returns (bytes32) {
251         return
252             keccak256(
253                 abi.encode(
254                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
255                     keccak256(bytes(_name)),
256                     keccak256("1"),
257                     block.chainid,
258                     address(this)
259                 )
260             );
261     }
262  
263     function _mint(address account, uint256 amount) internal virtual {
264         require(account != address(0), "ERC20: mint to the zero address");
265  
266         _beforeTokenTransfer(address(0), account, amount);
267  
268         _totalSupply += amount;
269         unchecked {
270             _balances[account] += amount;
271         }
272         emit Transfer(address(0), account, amount);
273  
274         _afterTokenTransfer(address(0), account, amount);
275     }
276  
277     function _burn(address account, uint256 amount) internal virtual {
278         require(account != address(0), "ERC20: burn from the zero address");
279  
280         _beforeTokenTransfer(account, address(0), amount);
281  
282         uint256 accountBalance = _balances[account];
283         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
284         unchecked {
285             _balances[account] = accountBalance - amount;
286             _totalSupply -= amount;
287         }
288  
289         emit Transfer(account, address(0), amount);
290  
291         _afterTokenTransfer(account, address(0), amount);
292     }
293  
294     function _approve(
295         address owner,
296         address spender,
297         uint256 amount
298     ) internal virtual {
299         require(owner != address(0), "ERC20: approve from the zero address");
300         require(spender != address(0), "ERC20: approve to the zero address");
301  
302         _allowances[owner][spender] = amount;
303         emit Approval(owner, spender, amount);
304     }
305  
306     function _spendAllowance(
307         address owner,
308         address spender,
309         uint256 amount
310     ) internal virtual {
311         uint256 currentAllowance = allowance(owner, spender);
312         if (currentAllowance != type(uint256).max) {
313             require(currentAllowance >= amount, "ERC20: insufficient allowance");
314             unchecked {
315                 _approve(owner, spender, currentAllowance - amount);
316             }
317         }
318     }
319  
320     function _beforeTokenTransfer(
321         address from,
322         address to,
323         uint256 amount
324     ) internal virtual {}
325     function _afterTokenTransfer(
326         address from,
327         address to,
328         uint256 amount
329     ) internal virtual {}
330 }
331  
332 interface IFactory{
333         function createPair(address tokenA, address tokenB) external returns (address pair);
334 }
335  
336 interface IRouter {
337     function factory() external pure returns (address);
338     function WETH() external pure returns (address);
339     function swapExactTokensForETHSupportingFeeOnTransferTokens(
340         uint amountIn,
341         uint amountOutMin,
342         address[] calldata path,
343         address to,
344         uint deadline) external;
345 }
346  
347  
348 library Address{
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351  
352         (bool success, ) = recipient.call{value: amount}("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 }
356  
357 contract Ethane is ERC20, Ownable{
358     using Address for address payable;
359  
360     mapping (address user => bool status) public isExcludedFromFees;
361     mapping (address buyer => bool status) public whitelistedBuyer;
362     mapping (address buyer => bool status) public earlyBuyer;
363     mapping (address buyer => uint256 amount) public earlyBuyerDailySell;
364     mapping (address user => bool status) public isBlacklisted;
365     mapping (address user => uint256 timestamp) public lastTrade;
366  
367     IRouter public router;
368     address public pair;
369     address public marketingWallet = 0x97C3cFa5B0f6A33D6a22fa29c728882Dd6aA8237;
370  
371     bool private swapping;
372     bool public swapEnabled;
373     bool public tradingEnabled;
374     bool public finalTaxSet;
375  
376     uint256 public swapThreshold;
377     uint256 public maxWallet = 10000 * 10**9;
378     uint256 public maxTx = 10000 * 10**9;
379     uint256 public earlyBuyerDailyMaxSell;
380     uint256 public delay;
381     uint256 public deadBlocks = 1;
382     uint256 public whitelistPeriod = 0 minutes;
383     uint256 public launchBlock;
384     uint256 public launchTimestamp;
385     uint256 public finalTaxTimestamp = 1 hours;
386  
387  
388     struct Taxes {
389         uint256 buy;
390         uint256 sell;
391         uint256 transfer;
392     }
393  
394     Taxes public taxes = Taxes(20,20,0);
395  
396     modifier mutexLock() {
397         if (!swapping) {
398             swapping = true;
399             _;
400             swapping = false;
401         }
402     }
403  
404     constructor(address _router) ERC20("Ethane", "C2H6") {
405         _mint(msg.sender, 1000000 * 10 ** 9);
406  
407         router = IRouter(_router);
408         pair = IFactory(router.factory()).createPair(address(this), router.WETH());
409  
410  
411         isExcludedFromFees[address(this)] = true;
412         isExcludedFromFees[msg.sender] = true;
413         isExcludedFromFees[marketingWallet] = true;
414       
415         swapThreshold = maxWallet;
416         earlyBuyerDailyMaxSell = totalSupply() * 5 / 1000;
417  
418         _approve(address(this), address(router), type(uint256).max);
419     }
420  
421     function decimals() public view virtual override returns (uint8) {
422         return 9;
423     }
424  
425     function _transfer(address sender, address recipient, uint256 amount) internal override {
426         require(amount > 0, "Transfer amount must be greater than zero");
427  
428         if (swapping || isExcludedFromFees[sender] || isExcludedFromFees[recipient]) {
429             super._transfer(sender, recipient, amount);
430             return;
431         }
432  
433         else{
434             require(tradingEnabled, "Trading not enabled");
435             require(!isBlacklisted[sender] && !isBlacklisted[recipient], "Blacklisted address");
436             if(!finalTaxSet && finalTaxTimestamp + launchTimestamp < block.timestamp){
437                 finalTaxSet = true;
438                 taxes = Taxes(3, 3, 0); // set final tax after 1 hour
439             }
440  
441             if(launchTimestamp + whitelistPeriod > block.timestamp){
442                 if(!whitelistedBuyer[sender] && !whitelistedBuyer[recipient]) require(amount <= maxTx, "MaxTx limit exceeded");
443             }
444             else require(amount <= maxTx, "MaxTx limit exceeded");
445  
446             if(sender != pair) {
447                 if(earlyBuyer[sender]){
448                     if(block.timestamp - lastTrade[sender] >= 1 days){
449                         earlyBuyerDailyMaxSell = 0;
450                     }
451                     require(earlyBuyerDailySell[sender] + amount <= earlyBuyerDailyMaxSell, "Early buyer sell limit exceeded");
452                     earlyBuyerDailySell[sender] += amount;
453                 }
454                 require(lastTrade[sender] + delay <= block.timestamp, "WAIT PLEASE");
455                 lastTrade[sender] = block.timestamp;
456             }
457             if(recipient != pair){
458                 if(launchTimestamp + whitelistPeriod > block.timestamp && !whitelistedBuyer[recipient]){
459                     isBlacklisted[recipient] == true;
460                 }
461                 require(balanceOf(recipient) + amount <= maxWallet, "Wallet limit exceeded");
462                 require(lastTrade[recipient] + delay <= block.timestamp, "WAIT PLEASE");
463                 lastTrade[recipient] = block.timestamp;
464             }
465         }
466  
467         if(whitelistedBuyer[recipient] && sender == pair && launchTimestamp + whitelistPeriod > block.timestamp){
468             earlyBuyer[recipient] = true;
469         }
470  
471         uint256 fees;
472  
473         if(recipient == pair) fees = amount * taxes.sell / 100;
474         else if(sender == pair && !whitelistedBuyer[recipient]) fees = amount * taxes.buy / 100;
475         else fees = amount * taxes.transfer / 100; 
476  
477         if (swapEnabled && recipient == pair && !swapping) swapFees();
478  
479         super._transfer(sender, recipient, amount - fees);
480         if(fees > 0){
481             super._transfer(sender, address(this), fees);
482         }
483     }
484  
485     function swapFees() private mutexLock {
486         uint256 contractBalance = balanceOf(address(this));
487         if (contractBalance >= swapThreshold) {
488             uint256 amountToSwap = swapThreshold;
489             if(contractBalance >= maxTx && swapThreshold != maxWallet) amountToSwap = maxTx;
490  
491             if(swapThreshold == maxWallet) swapThreshold = totalSupply() * 25 / 10000; // 0.25%
492  
493             uint256 initialBalance = address(this).balance;
494             swapTokensForEth(amountToSwap);
495             uint256 deltaBalance = address(this).balance - initialBalance;
496             payable(marketingWallet).sendValue(deltaBalance);
497         }
498     }
499  
500     function swapTokensForEth(uint256 tokenAmount) private {
501         address[] memory path = new address[](2);
502         path[0] = address(this);
503         path[1] = router.WETH();
504  
505         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
506     }
507  
508     function setSwapEnabled(bool status) external onlyOwner {
509         swapEnabled = status;
510     }
511  
512     function setSwapTreshhold(uint256 amount) external onlyOwner {
513         swapThreshold = amount * 10**9;
514     }
515  
516     function setTaxes(uint256 _buyTax, uint256 _sellTax, uint256 _transferTax) external onlyOwner {
517         taxes = Taxes(_buyTax, _sellTax, _transferTax);
518     }
519  
520     function setRouterAndPair(address newRouter, address newPair) external onlyOwner{
521         router = IRouter(newRouter);
522         pair = newPair;
523         _approve(address(this), address(newRouter), type(uint256).max);
524     }
525  
526     function enableTrading() external onlyOwner{
527         require(!tradingEnabled, "Already enabled");
528         tradingEnabled = true;
529         swapEnabled = true;
530         taxes.transfer = 50;
531         launchBlock = block.number;
532         launchTimestamp = block.timestamp;
533     }
534  
535     function removeLimits() external onlyOwner{
536         maxTx = totalSupply();
537         maxWallet = totalSupply();
538         taxes.transfer = 0;
539     }
540  
541     function setDelay(uint256 time) external onlyOwner{
542         delay = time;
543     }
544  
545     function setLimits(uint256 _maxTx, uint256 _maxWallet) external onlyOwner{
546         maxTx = _maxTx * 10**9;
547         maxWallet = _maxWallet * 10**9;
548     }
549  
550     function setMarketingWallet(address newWallet) external onlyOwner{
551         marketingWallet = newWallet;
552     }
553  
554     function setIsExcludedFromFees(address _address, bool state) external onlyOwner {
555         isExcludedFromFees[_address] = state;
556     }
557  
558     function bulkIsExcludedFromFees(address[] memory accounts, bool state) external onlyOwner{
559         for(uint256 i = 0; i < accounts.length; i++){
560             isExcludedFromFees[accounts[i]] = state;
561         }
562     }
563  
564     function setBlacklist(address[] memory accounts, bool status) external onlyOwner{
565         for(uint256 i = 0; i < accounts.length; i++){
566             isBlacklisted[accounts[i]] = status;
567         }
568     }
569  
570     function rescueETH(uint256 weiAmount) external{
571         payable(marketingWallet).sendValue(weiAmount);
572     }
573  
574     function rescueERC20(address tokenAdd, uint256 amount) external{
575         IERC20(tokenAdd).transfer(marketingWallet, amount);
576     }
577  
578     // fallbacks
579     receive() external payable {}
580  
581 }