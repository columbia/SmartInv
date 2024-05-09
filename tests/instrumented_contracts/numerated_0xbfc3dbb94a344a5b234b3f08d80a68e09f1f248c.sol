1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 interface IFactory {
27     function createPair(address tokenA, address tokenB) external returns (address pair);
28 
29     function getPair(address tokenA, address tokenB) external view returns (address pair);
30 }
31 
32 interface IRouter {
33     function factory() external pure returns (address);
34 
35     function WETH() external pure returns (address);
36 
37     function addLiquidityETH(
38         address token,
39         uint256 amountTokenDesired,
40         uint256 amountTokenMin,
41         uint256 amountETHMin,
42         address to,
43         uint256 deadline
44     )
45         external
46         payable
47         returns (
48             uint256 amountToken,
49             uint256 amountETH,
50             uint256 liquidity
51         );
52 
53     function swapExactETHForTokensSupportingFeeOnTransferTokens(
54         uint256 amountOutMin,
55         address[] calldata path,
56         address to,
57         uint256 deadline
58     ) external payable;
59 
60     function swapExactTokensForETHSupportingFeeOnTransferTokens(
61         uint256 amountIn,
62         uint256 amountOutMin,
63         address[] calldata path,
64         address to,
65         uint256 deadline
66     ) external;
67 }
68 
69 interface IERC20Metadata is IERC20 {
70     function name() external view returns (string memory);
71 
72     function symbol() external view returns (string memory);
73 
74     function decimals() external view returns (uint8);
75 }
76 
77 library Address {
78 	function isContract(address account) internal view returns (bool) {
79 		uint256 size;
80 		assembly {
81 			size := extcodesize(account)
82 		}
83 		return size > 0;
84 	}
85 
86 	function sendValue(address payable recipient, uint256 amount) internal {
87 		require(
88 			address(this).balance >= amount,
89 			"Address: insufficient balance"
90 		);
91 
92 		(bool success, ) = recipient.call{value: amount}("");
93 		require(
94 			success,
95 			"Address: unable to send value, recipient may have reverted"
96 		);
97 	}
98 
99 	function functionCall(address target, bytes memory data)
100 	internal
101 	returns (bytes memory)
102 	{
103 		return functionCall(target, data, "Address: low-level call failed");
104 	}
105 
106 	function functionCall(
107 		address target,
108 		bytes memory data,
109 		string memory errorMessage
110 	) internal returns (bytes memory) {
111 		return functionCallWithValue(target, data, 0, errorMessage);
112 	}
113 
114 	function functionCallWithValue(
115 		address target,
116 		bytes memory data,
117 		uint256 value
118 	) internal returns (bytes memory) {
119 		return
120 		functionCallWithValue(
121 			target,
122 			data,
123 			value,
124 			"Address: low-level call with value failed"
125 		);
126 	}
127 
128 	function functionCallWithValue(
129 		address target,
130 		bytes memory data,
131 		uint256 value,
132 		string memory errorMessage
133 	) internal returns (bytes memory) {
134 		require(
135 			address(this).balance >= value,
136 			"Address: insufficient balance for call"
137 		);
138 		require(isContract(target), "Address: call to non-contract");
139 
140 		(bool success, bytes memory returndata) = target.call{value: value}(
141 		data
142 		);
143 		return _verifyCallResult(success, returndata, errorMessage);
144 	}
145 
146 	function functionStaticCall(address target, bytes memory data)
147 	internal
148 	view
149 	returns (bytes memory)
150 	{
151 		return
152 		functionStaticCall(
153 			target,
154 			data,
155 			"Address: low-level static call failed"
156 		);
157 	}
158 
159 	function functionStaticCall(
160 		address target,
161 		bytes memory data,
162 		string memory errorMessage
163 	) internal view returns (bytes memory) {
164 		require(isContract(target), "Address: static call to non-contract");
165 
166 		(bool success, bytes memory returndata) = target.staticcall(data);
167 		return _verifyCallResult(success, returndata, errorMessage);
168 	}
169 
170 	function functionDelegateCall(address target, bytes memory data)
171 	internal
172 	returns (bytes memory)
173 	{
174 		return
175 		functionDelegateCall(
176 			target,
177 			data,
178 			"Address: low-level delegate call failed"
179 		);
180 	}
181 
182 	function functionDelegateCall(
183 		address target,
184 		bytes memory data,
185 		string memory errorMessage
186 	) internal returns (bytes memory) {
187 		require(isContract(target), "Address: delegate call to non-contract");
188 
189 		(bool success, bytes memory returndata) = target.delegatecall(data);
190 		return _verifyCallResult(success, returndata, errorMessage);
191 	}
192 
193 	function _verifyCallResult(
194 		bool success,
195 		bytes memory returndata,
196 		string memory errorMessage
197 	) private pure returns (bytes memory) {
198 		if (success) {
199 			return returndata;
200 		} else {
201 			if (returndata.length > 0) {
202 				assembly {
203 					let returndata_size := mload(returndata)
204 					revert(add(32, returndata), returndata_size)
205 				}
206 			} else {
207 				revert(errorMessage);
208 			}
209 		}
210 	}
211 }
212 
213 abstract contract Context {
214     function _msgSender() internal view virtual returns (address) {
215         return msg.sender;
216     }
217 
218     function _msgData() internal view virtual returns (bytes calldata) {
219         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
220         return msg.data;
221     }
222 }
223 
224 contract Ownable is Context {
225     address private _owner;
226 
227     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229     constructor() {
230         address msgSender = _msgSender();
231         _owner = msgSender;
232         emit OwnershipTransferred(address(0), msgSender);
233     }
234 
235     function owner() public view returns (address) {
236         return _owner;
237     }
238 
239     modifier onlyOwner() {
240         require(_owner == _msgSender(), "Ownable: caller is not the owner");
241         _;
242     }
243 
244     function renounceOwnership() public virtual onlyOwner {
245         emit OwnershipTransferred(_owner, address(0));
246         _owner = address(0);
247     }
248 
249     function transferOwnership(address newOwner) public virtual onlyOwner {
250         require(newOwner != address(0), "Ownable: new owner is the zero address");
251         emit OwnershipTransferred(_owner, newOwner);
252         _owner = newOwner;
253     }
254 }
255 
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name;
264     string private _symbol;
265 
266     constructor(string memory name_, string memory symbol_) {
267         _name = name_;
268         _symbol = symbol_;
269     }
270 
271     function name() public view virtual override returns (string memory) {
272         return _name;
273     }
274 
275     function symbol() public view virtual override returns (string memory) {
276         return _symbol;
277     }
278 
279    function decimals() public view virtual override returns (uint8) {
280         return 18;
281     }
282 
283     function totalSupply() public view virtual override returns (uint256) {
284         return _totalSupply;
285     }
286 
287     function balanceOf(address account) public view virtual override returns (uint256) {
288         return _balances[account];
289     }
290 
291     function transfer(address to, uint256 amount) public virtual override returns (bool) {
292         address owner = _msgSender();
293         _transfer(owner, to, amount);
294         return true;
295     }
296 
297     function allowance(address owner, address spender) public view virtual override returns (uint256) {
298         return _allowances[owner][spender];
299     }
300 
301     function approve(address spender, uint256 amount) public virtual override returns (bool) {
302         address owner = _msgSender();
303         _approve(owner, spender, amount);
304         return true;
305     }
306 
307 
308     function transferFrom(
309         address from,
310         address to,
311         uint256 amount
312     ) public virtual override returns (bool) {
313         address spender = _msgSender();
314         _spendAllowance(from, spender, amount);
315         _transfer(from, to, amount);
316         return true;
317     }
318 
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         address owner = _msgSender();
321         _approve(owner, spender, allowance(owner, spender) + addedValue);
322         return true;
323     }
324 
325     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
326         address owner = _msgSender();
327         uint256 currentAllowance = allowance(owner, spender);
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         unchecked {
330             _approve(owner, spender, currentAllowance - subtractedValue);
331         }
332 
333         return true;
334     }
335 
336     function _transfer(
337         address from,
338         address to,
339         uint256 amount
340     ) internal virtual {
341         require(from != address(0), "ERC20: transfer from the zero address");
342         require(to != address(0), "ERC20: transfer to the zero address");
343 
344         _beforeTokenTransfer(from, to, amount);
345 
346         uint256 fromBalance = _balances[from];
347         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
348         unchecked {
349             _balances[from] = fromBalance - amount;
350             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
351             // decrementing then incrementing.
352             _balances[to] += amount;
353         }
354 
355         emit Transfer(from, to, amount);
356 
357         _afterTokenTransfer(from, to, amount);
358     }
359 
360     function _mint(address account, uint256 amount) internal virtual {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _beforeTokenTransfer(address(0), account, amount);
364 
365         _totalSupply += amount;
366         unchecked {
367             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
368             _balances[account] += amount;
369         }
370         emit Transfer(address(0), account, amount);
371 
372         _afterTokenTransfer(address(0), account, amount);
373     }
374 
375     function _burn(address account, uint256 amount) internal virtual {
376         require(account != address(0), "ERC20: burn from the zero address");
377 
378         _beforeTokenTransfer(account, address(0), amount);
379 
380         uint256 accountBalance = _balances[account];
381         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
382         unchecked {
383             _balances[account] = accountBalance - amount;
384             // Overflow not possible: amount <= accountBalance <= totalSupply.
385             _totalSupply -= amount;
386         }
387 
388         emit Transfer(account, address(0), amount);
389 
390         _afterTokenTransfer(account, address(0), amount);
391     }
392 
393     function _approve(
394         address owner,
395         address spender,
396         uint256 amount
397     ) internal virtual {
398         require(owner != address(0), "ERC20: approve from the zero address");
399         require(spender != address(0), "ERC20: approve to the zero address");
400 
401         _allowances[owner][spender] = amount;
402         emit Approval(owner, spender, amount);
403     }
404 
405     function _spendAllowance(
406         address owner,
407         address spender,
408         uint256 amount
409     ) internal virtual {
410         uint256 currentAllowance = allowance(owner, spender);
411         if (currentAllowance != type(uint256).max) {
412             require(currentAllowance >= amount, "ERC20: insufficient allowance");
413             unchecked {
414                 _approve(owner, spender, currentAllowance - amount);
415             }
416         }
417     }
418 
419     function _beforeTokenTransfer(
420         address from,
421         address to,
422         uint256 amount
423     ) internal virtual {}
424 
425     function _afterTokenTransfer(
426         address from,
427         address to,
428         uint256 amount
429     ) internal virtual {}
430 }
431 
432 contract NERDToken is Ownable, ERC20 {
433     using Address for address;
434 
435     IRouter public uniswapV2Router;
436     address public immutable uniswapV2Pair;
437 
438     string private constant _name = "NERD Token";
439     string private constant _symbol = "NERD";
440 
441     bool public isTradingEnabled;
442 
443     uint256 public initialSupply = 420690000000000 * (10**18);
444 
445     uint256 public maxWalletAmount = initialSupply * 150 / 10000;
446 
447     uint256 private _launchStartTimestamp;
448     uint256 private _launchBlockNumber;
449 
450     mapping (address => bool) private _isBlocked;
451     mapping(address => bool) private _isAllowedToTradeWhenDisabled;
452     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
453     mapping(address => bool) public automatedMarketMakerPairs;
454 
455     event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
456     event BlockedAccountChange(address indexed holder, bool indexed status);
457     event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
458     event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
459     event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
460     event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
461     event ClaimOverflow(address token, uint256 amount);
462     event TradingStatusChange(bool indexed newValue, bool indexed oldValue);
463 
464     constructor() ERC20(_name, _symbol) {
465         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
466         address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(address(this),_uniswapV2Router.WETH());
467         uniswapV2Router = _uniswapV2Router;
468         uniswapV2Pair = _uniswapV2Pair;
469         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
470 
471         _isAllowedToTradeWhenDisabled[owner()] = true;
472         _isAllowedToTradeWhenDisabled[address(this)] = true;
473 
474         _isBlocked[address(0xae2Fc483527B8EF99EB5D9B44875F005ba1FaE13)] = true;
475         _isBlocked[address(0x758E8229Dd38cF11fA9E7c0D5f790b4CA16b3B16)] = true;
476 
477         _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
478         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
479         _isExcludedFromMaxWalletLimit[address(this)] = true;
480         _isExcludedFromMaxWalletLimit[owner()] = true;
481 
482         _mint(owner(), initialSupply);
483     }
484 
485     receive() external payable {}
486 
487     function activateTrading() external onlyOwner {
488         isTradingEnabled = true;
489         if(_launchBlockNumber == 0) {
490             _launchBlockNumber = block.number;
491             _launchStartTimestamp = block.timestamp;
492         }
493         emit TradingStatusChange(true, false);
494     }
495     function deactivateTrading() external onlyOwner {
496         isTradingEnabled = false;
497         emit TradingStatusChange(false, true);
498     }
499     function _setAutomatedMarketMakerPair(address pair, bool value) private {
500         require(automatedMarketMakerPairs[pair] != value,"Nerd: Automated market maker pair is already set to that value");
501         automatedMarketMakerPairs[pair] = value;
502         emit AutomatedMarketMakerPairChange(pair, value);
503     }
504     function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
505         _isAllowedToTradeWhenDisabled[account] = allowed;
506         emit AllowedWhenTradingDisabledChange(account, allowed);
507     }
508     function blockAccount(address account) external onlyOwner {
509         require(!_isBlocked[account], "Nerd: Account is already blocked");
510         _isBlocked[account] = true;
511         emit BlockedAccountChange(account, true);
512     }
513     function unblockAccount(address account) external onlyOwner {
514         require(_isBlocked[account], "Nerd: Account is not blocked");
515         _isBlocked[account] = false;
516         emit BlockedAccountChange(account, false);
517     }
518     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
519         require(_isExcludedFromMaxWalletLimit[account] != excluded,"Nerd: Account is already the value of 'excluded'");
520         _isExcludedFromMaxWalletLimit[account] = excluded;
521         emit ExcludeFromMaxWalletChange(account, excluded);
522     }
523     function setUniswapRouter(address newAddress) external onlyOwner {
524         require(newAddress != address(uniswapV2Router),"Nerd: The router already has that address");
525         emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
526         uniswapV2Router = IRouter(newAddress);
527     }
528     function setMaxWalletAmount(uint256 newValue) external onlyOwner {
529         require(newValue != maxWalletAmount,"Nerd: Cannot update maxWalletAmount to same value");
530         emit MaxWalletAmountChange(newValue, maxWalletAmount);
531         maxWalletAmount = newValue;
532     }
533     function claimLaunchTokens() external onlyOwner {
534 		require(_launchStartTimestamp > 0, "Nerd: Launch must have occurred");
535 		require(block.number - _launchBlockNumber > 5, "Nerd: Only claim launch tokens after first 5 blocks");
536 		uint256 tokenBalance = balanceOf(address(this));
537         (bool success) = IERC20(address(this)).transfer(owner(), tokenBalance);
538         if (success){
539             emit ClaimOverflow(address(this), tokenBalance);
540         }
541     }
542     function claimETHOverflow(uint256 amount) external onlyOwner {
543         require(amount <= address(this).balance, "Nerd: Cannot send more than contract balance");
544         (bool success, ) = address(owner()).call{ value: amount }("");
545         if (success) {
546             emit ClaimOverflow(uniswapV2Router.WETH(), amount);
547         }
548     }
549     function _transfer(
550         address from,
551         address to,
552         uint256 amount
553     ) internal override {
554         require(from != address(0), "ERC20: transfer from the zero address");
555         require(to != address(0), "ERC20: transfer to the zero address");
556 
557         if (amount == 0) {
558             super._transfer(from, to, 0);
559             return;
560         }
561 
562         if (!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
563             require(isTradingEnabled, "Nerd: Trading is currently disabled.");
564             require(!_isBlocked[to], "Nerd: Account is blocked");
565             require(!_isBlocked[from], "Nerd: Account is blocked");
566             if (!_isExcludedFromMaxWalletLimit[to]) {
567                 require((balanceOf(to) + amount) <= maxWalletAmount, "Nerd: Expected wallet amount exceeds the maxWalletAmount.");
568             }
569         }
570 
571         if (_launchStartTimestamp > 0 && (block.number - _launchBlockNumber <= 5)) {
572             super._transfer(from, address(this), amount);
573         } else {
574             super._transfer(from, to, amount);
575         }
576     }
577 }