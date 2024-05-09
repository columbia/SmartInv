1 /**
2 
3 PEACE WAS NEVER AN OPTION
4 
5 https://knowyourmeme.com/memes/peace-was-never-an-option
6 
7 Socials:
8 
9 🌐 https://www.pwnao.com/
10 🐦 https://twitter.com/pwnaoERC20
11 💬 https://t.me/pwnao
12 
13 1 Million Supply
14 Final 1/1 Tax
15 
16 */
17 
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity ^0.8.0;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 pragma solidity ^0.8.0;
33 
34 abstract contract Ownable is Context {
35     address private _owner;
36 
37     event OwnershipTransferred(
38         address indexed previousOwner,
39         address indexed newOwner
40     );
41 
42     constructor() {
43         _transferOwnership(_msgSender());
44     }
45 
46     modifier onlyOwner() {
47         _checkOwner();
48         _;
49     }
50 
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
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
65         require(
66             newOwner != address(0),
67             "Ownable: new owner is the zero address"
68         );
69         _transferOwnership(newOwner);
70     }
71 
72     function _transferOwnership(address newOwner) internal virtual {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }
78 
79 
80 pragma solidity ^0.8.0;
81 
82 interface IERC20 {
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(
87         address indexed owner,
88         address indexed spender,
89         uint256 value
90     );
91 
92     function totalSupply() external view returns (uint256);
93 
94     function balanceOf(address account) external view returns (uint256);
95 
96     function transfer(address to, uint256 amount) external returns (bool);
97 
98     function allowance(
99         address owner,
100         address spender
101     ) external view returns (uint256);
102 
103     function approve(address spender, uint256 amount) external returns (bool);
104 
105     function transferFrom(
106         address from,
107         address to,
108         uint256 amount
109     ) external returns (bool);
110 }
111 
112 pragma solidity ^0.8.0;
113 
114 interface IERC20Metadata is IERC20 {
115  
116     function name() external view returns (string memory);
117 
118     function symbol() external view returns (string memory);
119 
120     function decimals() external view returns (uint8);
121 }
122 
123 pragma solidity ^0.8.0;
124 
125 contract ERC20 is Context, IERC20, IERC20Metadata {
126     mapping(address => uint256) private _balances;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131 
132     string private _name;
133     string private _symbol;
134 
135     constructor(string memory name_, string memory symbol_) {
136         _name = name_;
137         _symbol = symbol_;
138     }
139 
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     function symbol() public view virtual override returns (string memory) {
145         return _symbol;
146     }
147 
148     function decimals() public view virtual override returns (uint8) {
149         return 18;
150     }
151 
152     function totalSupply() public view virtual override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(
157         address account
158     ) public view virtual override returns (uint256) {
159         return _balances[account];
160     }
161 
162     function transfer(
163         address to,
164         uint256 amount
165     ) public virtual override returns (bool) {
166         address owner = _msgSender();
167         _transfer(owner, to, amount);
168         return true;
169     }
170 
171     function allowance(
172         address owner,
173         address spender
174     ) public view virtual override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     function approve(
179         address spender,
180         uint256 amount
181     ) public virtual override returns (bool) {
182         address owner = _msgSender();
183         _approve(owner, spender, amount);
184         return true;
185     }
186 
187     function transferFrom(
188         address from,
189         address to,
190         uint256 amount
191     ) public virtual override returns (bool) {
192         address spender = _msgSender();
193         _spendAllowance(from, spender, amount);
194         _transfer(from, to, amount);
195         return true;
196     }
197 
198     function increaseAllowance(
199         address spender,
200         uint256 addedValue
201     ) public virtual returns (bool) {
202         address owner = _msgSender();
203         _approve(owner, spender, allowance(owner, spender) + addedValue);
204         return true;
205     }
206 
207     function decreaseAllowance(
208         address spender,
209         uint256 subtractedValue
210     ) public virtual returns (bool) {
211         address owner = _msgSender();
212         uint256 currentAllowance = allowance(owner, spender);
213         require(
214             currentAllowance >= subtractedValue,
215             "ERC20: decreased allowance below zero"
216         );
217         unchecked {
218             _approve(owner, spender, currentAllowance - subtractedValue);
219         }
220 
221         return true;
222     }
223 
224     function _transfer(
225         address from,
226         address to,
227         uint256 amount
228     ) internal virtual {
229         require(from != address(0), "ERC20: transfer from the zero address");
230         require(to != address(0), "ERC20: transfer to the zero address");
231 
232         _beforeTokenTransfer(from, to, amount);
233 
234         uint256 fromBalance = _balances[from];
235         require(
236             fromBalance >= amount,
237             "ERC20: transfer amount exceeds balance"
238         );
239         unchecked {
240             _balances[from] = fromBalance - amount;
241 
242             _balances[to] += amount;
243         }
244 
245         emit Transfer(from, to, amount);
246 
247         _afterTokenTransfer(from, to, amount);
248     }
249 
250 
251     function _mint(address account, uint256 amount) internal virtual {
252         require(account != address(0), "ERC20: mint to the zero address");
253 
254         _beforeTokenTransfer(address(0), account, amount);
255 
256         _totalSupply += amount;
257         unchecked {
258             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
259             _balances[account] += amount;
260         }
261         emit Transfer(address(0), account, amount);
262 
263         _afterTokenTransfer(address(0), account, amount);
264     }
265 
266 
267     function _burn(address account, uint256 amount) internal virtual {
268         require(account != address(0), "ERC20: burn from the zero address");
269 
270         _beforeTokenTransfer(account, address(0), amount);
271 
272         uint256 accountBalance = _balances[account];
273         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
274         unchecked {
275             _balances[account] = accountBalance - amount;
276             // Overflow not possible: amount <= accountBalance <= totalSupply.
277             _totalSupply -= amount;
278         }
279 
280         emit Transfer(account, address(0), amount);
281 
282         _afterTokenTransfer(account, address(0), amount);
283     }
284 
285     function _approve(
286         address owner,
287         address spender,
288         uint256 amount
289     ) internal virtual {
290         require(owner != address(0), "ERC20: approve from the zero address");
291         require(spender != address(0), "ERC20: approve to the zero address");
292 
293         _allowances[owner][spender] = amount;
294         emit Approval(owner, spender, amount);
295     }
296 
297     function _spendAllowance(
298         address owner,
299         address spender,
300         uint256 amount
301     ) internal virtual {
302         uint256 currentAllowance = allowance(owner, spender);
303         if (currentAllowance != type(uint256).max) {
304             require(
305                 currentAllowance >= amount,
306                 "ERC20: insufficient allowance"
307             );
308             unchecked {
309                 _approve(owner, spender, currentAllowance - amount);
310             }
311         }
312     }
313 
314     function _beforeTokenTransfer(
315         address from,
316         address to,
317         uint256 amount
318     ) internal virtual {}
319 
320 
321     function _afterTokenTransfer(
322         address from,
323         address to,
324         uint256 amount
325     ) internal virtual {}
326 }
327 
328 pragma solidity ^0.8.9;
329 
330 interface IUniswapV2Factory {
331     function createPair(
332         address tokenA,
333         address tokenB
334     ) external returns (address pair);
335 }
336 
337 pragma solidity ^0.8.9;
338 
339 interface IUniswapV2Router02 {
340     function swapExactTokensForETHSupportingFeeOnTransferTokens(
341         uint256 amountIn,
342         uint256 amountOutMin,
343         address[] calldata path,
344         address to,
345         uint256 deadline
346     ) external;
347 
348     function factory() external pure returns (address);
349 
350     function WETH() external pure returns (address);
351 }
352 
353 pragma solidity ^0.8.19;
354 
355 contract PWNAO is ERC20, Ownable {
356     uint256 public _maxTxAmount = 20000 * 10 ** decimals();
357     uint256 public _maxWalletSize = 20000 * 10 ** decimals();
358     uint256 public _swapTokensAtAmount = 10000 * 10 ** decimals();
359     uint256 public _amountToSwap = 10000 * 10 ** decimals();
360 
361     uint256 private _taxFeeOnBuy = 1;
362     uint256 private _taxFeeOnSell = 1;
363 
364     mapping(address => bool) private _isExcludedFromFee;
365 
366     address payable private constant _feeAddress =
367         payable(0x2Ba97157aBe10B6b7C478759a91Ceaea9F0B1Cd3);
368 
369     IUniswapV2Router02 public constant uniswapV2Router =
370         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
371 
372     address public uniswapV2Pair;
373 
374     bool private inSwap = false;
375 
376     modifier lockTheSwap() {
377         inSwap = true;
378         _;
379         inSwap = false;
380     }
381 
382     constructor() ERC20("PWNAO", "PWNAO") {
383         _mint(msg.sender, 1000000 * 10 ** decimals());
384 
385         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
386                 address(this),
387                 uniswapV2Router.WETH()
388             );
389 
390         _isExcludedFromFee[owner()] = true;
391         _isExcludedFromFee[address(this)] = true;
392         _isExcludedFromFee[address(uniswapV2Router)] = true;
393         _isExcludedFromFee[_feeAddress] = true;
394     }
395 
396     function _transfer(
397         address from,
398         address to,
399         uint256 amount
400     ) internal override {
401         if (from != owner() && to != owner()) {
402             if (to != _feeAddress && from != _feeAddress) {
403                 require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
404             }
405 
406             if (
407                 to != uniswapV2Pair && to != _feeAddress && from != _feeAddress
408             ) {
409                 require(
410                     balanceOf(to) + amount <= _maxWalletSize,
411                     "TOKEN: Balance exceeds wallet size!"
412                 );
413             }
414             uint256 contractTokenBalance = balanceOf(address(this));
415             bool shouldSwap = contractTokenBalance >= _swapTokensAtAmount;
416 
417             if (contractTokenBalance >= _amountToSwap) {
418                 contractTokenBalance = _amountToSwap;
419             }
420 
421             if (
422                 shouldSwap &&
423                 !inSwap &&
424                 from != uniswapV2Pair &&
425                 !_isExcludedFromFee[from] &&
426                 !_isExcludedFromFee[to]
427             ) {
428                 swapTokensForEth(contractTokenBalance);
429 
430                 uint256 contractETHBalance = address(this).balance;
431                 if (contractETHBalance > 0) {
432                     _feeAddress.transfer(contractETHBalance);
433                 }
434             }
435         }
436 
437         //Transfer Tokens
438         uint256 _taxFee = 0;
439         if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
440             _taxFee = _taxFeeOnBuy;
441         }
442 
443         if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
444             _taxFee = _taxFeeOnSell;
445         }
446 
447         if (
448             (_isExcludedFromFee[from] || _isExcludedFromFee[to]) ||
449             (from != uniswapV2Pair && to != uniswapV2Pair)
450         ) {
451             _taxFee = 0;
452         }
453 
454         uint256 tTeam = (amount * _taxFee) / 100;
455         uint256 tTransferAmount = amount - tTeam;
456         if (tTeam > 0) {
457             super._transfer(from, address(this), tTeam);
458         }
459         super._transfer(from, to, tTransferAmount);
460     }
461 
462     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
463         address[] memory path = new address[](2);
464         path[0] = address(this);
465         path[1] = uniswapV2Router.WETH();
466         _approve(address(this), address(uniswapV2Router), tokenAmount);
467         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
468             tokenAmount,
469             0,
470             path,
471             address(this),
472             block.timestamp
473         );
474     }
475 
476     // external onlyOwner
477 
478     function setSwapTokensAtAmount(
479         uint256 swapTokensAtAmount
480     ) external onlyOwner {
481         _swapTokensAtAmount = swapTokensAtAmount;
482     }
483 
484     function setAmountToSwap(uint256 amountToSwap) external onlyOwner {
485         _amountToSwap = amountToSwap;
486     }
487 
488     function excludeAccountsFromFees(
489         address[] calldata accounts,
490         bool excluded
491     ) external onlyOwner {
492         for (uint256 i = 0; i < accounts.length; i++) {
493             _isExcludedFromFee[accounts[i]] = excluded;
494         }
495     }
496 
497     function launchlimits()  external onlyOwner {
498         _maxTxAmount = 20000 * 10 ** decimals();
499 	    _maxWalletSize = 20000 * 10 ** decimals();
500 	    _swapTokensAtAmount = 10000 * 10 ** decimals();
501 	    _amountToSwap = 9999 * 10 ** decimals();
502 	    _taxFeeOnBuy = 25;
503 	    _taxFeeOnSell = 25;
504     }
505 
506     function launchlimits2()  external onlyOwner {
507         _maxTxAmount = 20000 * 10 ** decimals();
508 	    _maxWalletSize = 20000 * 10 ** decimals();
509 	    _swapTokensAtAmount = 10000 * 10 ** decimals();
510 	    _amountToSwap = 9999 * 10 ** decimals();
511 	    _taxFeeOnBuy = 1;
512 	    _taxFeeOnSell = 15;
513     }
514 
515         function finallimits()  external onlyOwner {
516         _maxTxAmount = 1000000 * 10 ** decimals();
517 	    _maxWalletSize = 1000000 * 10 ** decimals();
518 	    _swapTokensAtAmount = 5000 * 10 ** decimals();
519 	    _amountToSwap = 4000 * 10 ** decimals();
520 	    _taxFeeOnBuy = 1;
521 	    _taxFeeOnSell = 1;
522     }
523 
524 
525 
526     // Send the current ETH and token balance to the marketing address
527 
528     function cleanContract() external {
529         uint256 contractETHBalance = address(this).balance;
530         if (contractETHBalance > 0) {
531             _feeAddress.transfer(contractETHBalance);
532         }
533         uint256 contractTokenBalance = balanceOf(address(this));
534         if (contractTokenBalance > 0) {
535             _transfer(address(this), _feeAddress, contractTokenBalance);
536         }
537     }
538 
539     receive() external payable {}
540 }