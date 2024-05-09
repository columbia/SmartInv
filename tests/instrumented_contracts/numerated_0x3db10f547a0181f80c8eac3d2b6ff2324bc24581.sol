1 /**
2   ______ _      ____  _   _ 
3  |  ____| |    / __ \| \ | |
4  | |__  | |   | |  | |  \| |
5  |  __| | |   | |  | | . ` |
6  | |____| |___| |__| | |\  |
7  |______|______\____/|_| \_|
8  |  \/  | |  | |/ ____| |/ /
9  | \  / | |  | | (___ | ' / 
10  | |\/| | |  | |\___ \|  <  
11  | |  | | |__| |____) | . \ 
12  |_|_ |_|\____/|_____/|_|\_\
13  |__ \ / _ \__ \| || |      
14     ) | | | | ) | || |_     
15    / /| | | |/ /|__   _|    
16   / /_| |_| / /_   | |      
17  |____|\___/____|  |_|      
18                             
19 https://t.me/VoteElonMusk
20 http://vote-elonmusk.online
21 
22 */
23 
24 // SPDX-License-Identifier: MIT
25 
26 pragma solidity 0.8.18;
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor() {
44         _transferOwnership(_msgSender());
45     }
46 
47     modifier onlyOwner() {
48         _checkOwner();
49         _;
50     }
51 
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     function _checkOwner() internal view virtual {
57         require(owner() == _msgSender(), "Ownable: caller is not the owner");
58     }
59 
60     function renounceOwnership() public virtual onlyOwner {
61         _transferOwnership(address(0));
62     }
63 
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         _transferOwnership(newOwner);
67     }
68 
69     function _transferOwnership(address newOwner) internal virtual {
70         address oldOwner = _owner;
71         _owner = newOwner;
72         emit OwnershipTransferred(oldOwner, newOwner);
73     }
74 }
75 
76 interface IERC20 {
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80     function totalSupply() external view returns (uint256);
81     function balanceOf(address account) external view returns (uint256);
82     function transfer(address to, uint256 amount) external returns (bool);
83     function allowance(address owner, address spender) external view returns (uint256);
84     function approve(address spender, uint256 amount) external returns (bool);
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 }
91 
92 interface IERC20Metadata is IERC20 {
93 
94     function name() external view returns (string memory);
95     function symbol() external view returns (string memory);
96     function decimals() external view returns (uint8);
97 }
98 
99 contract ERC20 is Context, IERC20, IERC20Metadata {
100     mapping(address => uint256) private _balances;
101 
102     mapping(address => mapping(address => uint256)) private _allowances;
103 
104     uint256 private _totalSupply;
105 
106     string private _name;
107     string private _symbol;
108 
109     constructor(string memory name_, string memory symbol_) {
110         _name = name_;
111         _symbol = symbol_;
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
200     function _mint(address account, uint256 amount) internal virtual {
201         require(account != address(0), "ERC20: mint to the zero address");
202 
203         _beforeTokenTransfer(address(0), account, amount);
204 
205         _totalSupply += amount;
206         unchecked {
207             _balances[account] += amount;
208         }
209         emit Transfer(address(0), account, amount);
210 
211         _afterTokenTransfer(address(0), account, amount);
212     }
213 
214     function _burn(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: burn from the zero address");
216 
217         _beforeTokenTransfer(account, address(0), amount);
218 
219         uint256 accountBalance = _balances[account];
220         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
221         unchecked {
222             _balances[account] = accountBalance - amount;
223             _totalSupply -= amount;
224         }
225 
226         emit Transfer(account, address(0), amount);
227 
228         _afterTokenTransfer(account, address(0), amount);
229     }
230 
231     function _approve(
232         address owner,
233         address spender,
234         uint256 amount
235     ) internal virtual {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238 
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 
243     function _spendAllowance(
244         address owner,
245         address spender,
246         uint256 amount
247     ) internal virtual {
248         uint256 currentAllowance = allowance(owner, spender);
249         if (currentAllowance != type(uint256).max) {
250             require(currentAllowance >= amount, "ERC20: insufficient allowance");
251             unchecked {
252                 _approve(owner, spender, currentAllowance - amount);
253             }
254         }
255     }
256 
257     function _beforeTokenTransfer(
258         address from,
259         address to,
260         uint256 amount
261     ) internal virtual {}
262     function _afterTokenTransfer(
263         address from,
264         address to,
265         uint256 amount
266     ) internal virtual {}
267 }
268 
269 interface IFactory{
270         function createPair(address tokenA, address tokenB) external returns (address pair);
271 }
272 
273 interface IRouter {
274     function factory() external pure returns (address);
275     function WETH() external pure returns (address);
276     function swapExactTokensForETHSupportingFeeOnTransferTokens(
277         uint amountIn,
278         uint amountOutMin,
279         address[] calldata path,
280         address to,
281         uint deadline) external;
282 }
283 
284 
285 library Address{
286     function sendValue(address payable recipient, uint256 amount) internal {
287         require(address(this).balance >= amount, "Address: insufficient balance");
288 
289         (bool success, ) = recipient.call{value: amount}("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 }
293 
294 contract ElonMusk is ERC20, Ownable{
295     using Address for address payable;
296         
297     mapping (address user => bool status) public isExcludedFromFees;
298     mapping (address user => bool status) public isBlacklisted;
299     mapping (address user => uint256 timestamp) public lastTrade;
300     
301     IRouter public router;
302     address public pair;
303     address public marketingWallet = 0x8d012DcFDb0822F673e68e809da6F2Bf9B23B187;
304 
305     bool private swapping;
306     bool public swapEnabled;
307     bool public tradingEnabled;
308     
309     uint256 public swapThreshold = 75000 * 10**9;
310     uint256 public maxWallet = 1000000 * 10**9;
311     uint256 public maxTx = 1000000 * 10**9;
312     uint256 public delay;
313     
314     struct Taxes {
315         uint256 buy;
316         uint256 sell;
317         uint256 transfer;
318     }
319 
320     Taxes public taxes = Taxes(25,25,25);
321 
322     modifier mutexLock() {
323         if (!swapping) {
324             swapping = true;
325             _;
326             swapping = false;
327         }
328     }
329   
330     constructor(address _router) ERC20("President Elon Musk", "VOTE") {
331         _mint(msg.sender, 50000000 * 10 ** 9);
332 
333         router = IRouter(_router);
334         pair = IFactory(router.factory()).createPair(address(this), router.WETH());
335 
336 
337         isExcludedFromFees[address(this)] = true;
338         isExcludedFromFees[msg.sender] = true;
339         isExcludedFromFees[marketingWallet] = true;
340 
341         _approve(address(this), address(router), type(uint256).max);
342     }
343 
344     function decimals() public view virtual override returns (uint8) {
345         return 9;
346     }
347 
348     function _transfer(address sender, address recipient, uint256 amount) internal override {
349         require(amount > 0, "Transfer amount must be greater than zero");
350 
351         if (swapping || isExcludedFromFees[sender] || isExcludedFromFees[recipient]) {
352             super._transfer(sender, recipient, amount);
353             return;
354         }
355 
356         else{
357             require(tradingEnabled, "Trading not enabled");
358             require(!isBlacklisted[sender] && !isBlacklisted[recipient], "Blacklisted address");
359             require(amount <= maxTx, "MaxTx limit exceeded");
360             if(sender != pair) {
361                 require(lastTrade[sender] + delay <= block.timestamp, "WAIT PLEASE");
362                 lastTrade[sender] = block.timestamp;
363             }
364             if(recipient != pair){
365                 require(balanceOf(recipient) + amount <= maxWallet, "Wallet limit exceeded");
366                 require(lastTrade[recipient] + delay <= block.timestamp, "WAIT PLEASE");
367                 lastTrade[recipient] = block.timestamp;
368             }
369         }
370         
371         uint256 fees;
372 
373         if(recipient == pair) fees = amount * taxes.sell / 100;
374         else if(sender == pair) fees = amount * taxes.buy / 100;
375         else fees = amount * taxes.transfer / 100; 
376 
377         if (swapEnabled && sender != pair && !swapping) swapFees();
378 
379         super._transfer(sender, recipient, amount - fees);
380         if(fees > 0){
381             super._transfer(sender, address(this), fees);
382         }
383     }
384 
385     function swapFees() private mutexLock {
386         uint256 contractBalance = balanceOf(address(this));
387         if (contractBalance >= swapThreshold) {
388             uint256 amountToSwap = swapThreshold;
389             if(contractBalance >= maxTx) amountToSwap = maxTx;
390 
391             uint256 initialBalance = address(this).balance;
392             swapTokensForEth(amountToSwap);
393             uint256 deltaBalance = address(this).balance - initialBalance;
394             payable(marketingWallet).sendValue(deltaBalance);
395         }
396     }
397 
398     function swapTokensForEth(uint256 tokenAmount) private {
399         address[] memory path = new address[](2);
400         path[0] = address(this);
401         path[1] = router.WETH();
402 
403         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
404     }
405 
406     function setSwapEnabled(bool status) external onlyOwner {
407         swapEnabled = status;
408     }
409 
410     function setSwapTreshhold(uint256 amount) external onlyOwner {
411         swapThreshold = amount * 10**9;
412     }
413     
414     function setTaxes(uint256 _buyTax, uint256 _sellTax, uint256 _transferTax) external onlyOwner {
415         taxes = Taxes(_buyTax, _sellTax, _transferTax);
416     }
417     
418     function setRouterAndPair(address newRouter, address newPair) external onlyOwner{
419         router = IRouter(newRouter);
420         pair = newPair;
421         _approve(address(this), address(newRouter), type(uint256).max);
422     }
423     
424     function frankenstein() external onlyOwner{
425         tradingEnabled = true;
426         swapEnabled = true;
427         taxes.transfer = 50;
428     }
429  
430     function removeLimits() external onlyOwner{
431         maxTx = totalSupply();
432         maxWallet = totalSupply();
433         taxes.transfer = 0;
434     }
435 
436     function setDelay(uint256 time) external onlyOwner{
437         delay = time;
438     }
439 
440     function setLimits(uint256 _maxTx, uint256 _maxWallet) external onlyOwner{
441         maxTx = _maxTx * 10**9;
442         maxWallet = _maxWallet * 10**9;
443     }
444     
445     function setMarketingWallet(address newWallet) external onlyOwner{
446         marketingWallet = newWallet;
447     }
448 
449     function setIsExcludedFromFees(address _address, bool state) external onlyOwner {
450         isExcludedFromFees[_address] = state;
451     }
452     
453     function bulkIsExcludedFromFees(address[] memory accounts, bool state) external onlyOwner{
454         for(uint256 i = 0; i < accounts.length; i++){
455             isExcludedFromFees[accounts[i]] = state;
456         }
457     }
458 
459     function setBlacklist(address[] memory accounts, bool status) external onlyOwner{
460         for(uint256 i = 0; i < accounts.length; i++){
461             isBlacklisted[accounts[i]] = status;
462         }
463     }
464 
465     function rescueETH(uint256 weiAmount) external{
466         payable(marketingWallet).sendValue(weiAmount);
467     }
468     
469     function rescueERC20(address tokenAdd, uint256 amount) external{
470         IERC20(tokenAdd).transfer(marketingWallet, amount);
471     }
472 
473     // fallbacks
474     receive() external payable {}
475 
476 }