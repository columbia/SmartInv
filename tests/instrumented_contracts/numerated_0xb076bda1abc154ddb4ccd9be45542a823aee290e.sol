1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor () {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(owner() == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * NOTE: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 }
91 
92 contract LGEWhitelisted is Context {
93     struct WhitelistRound {
94         uint256 duration;
95         uint256 amountMax;
96         mapping(address => bool) addresses;
97         mapping(address => uint256) purchased;
98     }
99 
100     WhitelistRound[] public _lgeWhitelistRounds;
101 
102     uint256 public _lgeTimestamp;
103     address public _lgePairAddress;
104 
105     address public _whitelister;
106 
107     event WhitelisterTransferred(address indexed previousWhitelister, address indexed newWhitelister);
108 
109     constructor() {
110         _whitelister = _msgSender();
111     }
112 
113     modifier onlyWhitelister() {
114         require(_whitelister == _msgSender(), "Caller is not the whitelister");
115         _;
116     }
117 
118     function renounceWhitelister() external onlyWhitelister {
119         emit WhitelisterTransferred(_whitelister, address(0));
120         _whitelister = address(0);
121     }
122 
123     function transferWhitelister(address newWhitelister) external onlyWhitelister {
124         _transferWhitelister(newWhitelister);
125     }
126 
127     function _transferWhitelister(address newWhitelister) internal {
128         require(newWhitelister != address(0), "New whitelister is the zero address");
129         emit WhitelisterTransferred(_whitelister, newWhitelister);
130         _whitelister = newWhitelister;
131     }
132 
133     /*
134      * createLGEWhitelist - Call this after initial Token Generation Event (TGE)
135      *
136      * pairAddress - address generated from createPair() event on DEX
137      * durations - array of durations (seconds) for each whitelist rounds
138      * amountsMax - array of max amounts (TOKEN decimals) for each whitelist round
139      *
140      */
141 
142     function createLGEWhitelist(
143         address pairAddress,
144         uint256[] calldata durations,
145         uint256[] calldata amountsMax
146     ) external onlyWhitelister() {
147         require(durations.length == amountsMax.length, "Invalid whitelist(s)");
148 
149         _lgePairAddress = pairAddress;
150 
151         if (durations.length > 0) {
152             delete _lgeWhitelistRounds;
153 
154             for (uint256 i = 0; i < durations.length; i++) {
155                 WhitelistRound storage whitelistRound = _lgeWhitelistRounds.push();
156                 whitelistRound.duration = durations[i];
157                 whitelistRound.amountMax = amountsMax[i];
158             }
159         }
160     }
161 
162     /*
163      * modifyLGEWhitelistAddresses - Define what addresses are included/excluded from a whitelist round
164      *
165      * index - 0-based index of round to modify whitelist
166      * duration - period in seconds from LGE event or previous whitelist round
167      * amountMax - max amount (TOKEN decimals) for each whitelist round
168      *
169      */
170 
171     function modifyLGEWhitelist(
172         uint256 index,
173         uint256 duration,
174         uint256 amountMax,
175         address[] calldata addresses,
176         bool enabled
177     ) external onlyWhitelister() {
178         require(index < _lgeWhitelistRounds.length, "Invalid index");
179         require(amountMax > 0, "Invalid amountMax");
180 
181         if (duration != _lgeWhitelistRounds[index].duration) _lgeWhitelistRounds[index].duration = duration;
182 
183         if (amountMax != _lgeWhitelistRounds[index].amountMax) _lgeWhitelistRounds[index].amountMax = amountMax;
184 
185         for (uint256 i = 0; i < addresses.length; i++) {
186             _lgeWhitelistRounds[index].addresses[addresses[i]] = enabled;
187         }
188     }
189 
190     /*
191      *  getLGEWhitelistRound
192      *
193      *  returns:
194      *
195      *  1. whitelist round number ( 0 = no active round now )
196      *  2. duration, in seconds, current whitelist round is active for
197      *  3. timestamp current whitelist round closes at
198      *  4. maximum amount a whitelister can purchase in this round
199      *  5. is caller whitelisted
200      *  6. how much caller has purchased in current whitelist round
201      *
202      */
203 
204     function getLGEWhitelistRound()
205         public
206         view
207         returns (
208             uint256,
209             uint256,
210             uint256,
211             uint256,
212             bool,
213             uint256
214         )
215     {
216         if (_lgeTimestamp > 0) {
217             uint256 wlCloseTimestampLast = _lgeTimestamp;
218 
219             for (uint256 i = 0; i < _lgeWhitelistRounds.length; i++) {
220                 WhitelistRound storage wlRound = _lgeWhitelistRounds[i];
221 
222                 wlCloseTimestampLast = wlCloseTimestampLast + wlRound.duration;
223                 if (block.timestamp <= wlCloseTimestampLast)
224                     return (
225                         i + 1,
226                         wlRound.duration,
227                         wlCloseTimestampLast,
228                         wlRound.amountMax,
229                         wlRound.addresses[_msgSender()],
230                         wlRound.purchased[_msgSender()]
231                     );
232             }
233         }
234 
235         return (0, 0, 0, 0, false, 0);
236     }
237 
238     /*
239      * _applyLGEWhitelist - internal function to be called initially before any transfers
240      *
241      */
242 
243     function _applyLGEWhitelist(
244         address sender,
245         address recipient,
246         uint256 amount
247     ) internal {
248         if (_lgePairAddress == address(0) || _lgeWhitelistRounds.length == 0) return;
249 
250         if (_lgeTimestamp == 0 && sender != _lgePairAddress && recipient == _lgePairAddress && amount > 0)
251             _lgeTimestamp = block.timestamp;
252 
253         if (sender == _lgePairAddress && recipient != _lgePairAddress) {
254             //buying
255 
256             (uint256 wlRoundNumber, , , , , ) = getLGEWhitelistRound();
257 
258             if (wlRoundNumber > 0) {
259                 WhitelistRound storage wlRound = _lgeWhitelistRounds[wlRoundNumber - 1];
260 
261                 require(wlRound.addresses[recipient], "LGE - Buyer is not whitelisted");
262 
263                 uint256 amountRemaining = 0;
264 
265                 if (wlRound.purchased[recipient] < wlRound.amountMax)
266                     amountRemaining = wlRound.amountMax - wlRound.purchased[recipient];
267 
268                 require(amount <= amountRemaining, "LGE - Amount exceeds whitelist maximum");
269                 wlRound.purchased[recipient] = wlRound.purchased[recipient] + amount;
270             }
271         }
272     }
273 }
274 
275 interface IERC20 {
276     function totalSupply() external view returns (uint256);
277     function decimals() external view returns (uint8);
278     function symbol() external view returns (string memory);
279     function name() external view returns (string memory);
280     function balanceOf(address account) external view returns (uint256);
281     function transfer(address recipient, uint256 amount) external returns (bool);
282     function allowance(address _owner, address spender) external view returns (uint256);
283     function approve(address spender, uint256 amount) external returns (bool);
284     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
285     event Transfer(address indexed from, address indexed to, uint256 value);
286     event Approval(address indexed owner, address indexed spender, uint256 value);
287 }
288 
289 interface IUniswapV2Factory {
290     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
291 
292     function feeTo() external view returns (address);
293     function feeToSetter() external view returns (address);
294 
295     function getPair(address tokenA, address tokenB) external view returns (address pair);
296     function allPairs(uint) external view returns (address pair);
297     function allPairsLength() external view returns (uint);
298 
299     function createPair(address tokenA, address tokenB) external returns (address pair);
300 
301     function setFeeTo(address) external;
302     function setFeeToSetter(address) external;
303 }
304 
305 interface IUniswapV2Router01 {
306     function factory() external pure returns (address);
307     function WETH() external pure returns (address);
308 
309     function addLiquidity(
310         address tokenA,
311         address tokenB,
312         uint amountADesired,
313         uint amountBDesired,
314         uint amountAMin,
315         uint amountBMin,
316         address to,
317         uint deadline
318     ) external returns (uint amountA, uint amountB, uint liquidity);
319     function addLiquidityETH(
320         address token,
321         uint amountTokenDesired,
322         uint amountTokenMin,
323         uint amountETHMin,
324         address to,
325         uint deadline
326     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
327     function removeLiquidity(
328         address tokenA,
329         address tokenB,
330         uint liquidity,
331         uint amountAMin,
332         uint amountBMin,
333         address to,
334         uint deadline
335     ) external returns (uint amountA, uint amountB);
336     function removeLiquidityETH(
337         address token,
338         uint liquidity,
339         uint amountTokenMin,
340         uint amountETHMin,
341         address to,
342         uint deadline
343     ) external returns (uint amountToken, uint amountETH);
344     function removeLiquidityWithPermit(
345         address tokenA,
346         address tokenB,
347         uint liquidity,
348         uint amountAMin,
349         uint amountBMin,
350         address to,
351         uint deadline,
352         bool approveMax, uint8 v, bytes32 r, bytes32 s
353     ) external returns (uint amountA, uint amountB);
354     function removeLiquidityETHWithPermit(
355         address token,
356         uint liquidity,
357         uint amountTokenMin,
358         uint amountETHMin,
359         address to,
360         uint deadline,
361         bool approveMax, uint8 v, bytes32 r, bytes32 s
362     ) external returns (uint amountToken, uint amountETH);
363     function swapExactTokensForTokens(
364         uint amountIn,
365         uint amountOutMin,
366         address[] calldata path,
367         address to,
368         uint deadline
369     ) external returns (uint[] memory amounts);
370     function swapTokensForExactTokens(
371         uint amountOut,
372         uint amountInMax,
373         address[] calldata path,
374         address to,
375         uint deadline
376     ) external returns (uint[] memory amounts);
377     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
378         external
379         payable
380         returns (uint[] memory amounts);
381     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
382         external
383         returns (uint[] memory amounts);
384     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
385         external
386         returns (uint[] memory amounts);
387     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
388         external
389         payable
390         returns (uint[] memory amounts);
391 
392     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
393     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
394     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
395     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
396     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
397 }
398 
399 
400 interface IUniswapV2Router02 is IUniswapV2Router01 {
401     function removeLiquidityETHSupportingFeeOnTransferTokens(
402         address token,
403         uint liquidity,
404         uint amountTokenMin,
405         uint amountETHMin,
406         address to,
407         uint deadline
408     ) external returns (uint amountETH);
409     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
410         address token,
411         uint liquidity,
412         uint amountTokenMin,
413         uint amountETHMin,
414         address to,
415         uint deadline,
416         bool approveMax, uint8 v, bytes32 r, bytes32 s
417     ) external returns (uint amountETH);
418 
419     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
420         uint amountIn,
421         uint amountOutMin,
422         address[] calldata path,
423         address to,
424         uint deadline
425     ) external;
426     function swapExactETHForTokensSupportingFeeOnTransferTokens(
427         uint amountOutMin,
428         address[] calldata path,
429         address to,
430         uint deadline
431     ) external payable;
432     function swapExactTokensForETHSupportingFeeOnTransferTokens(
433         uint amountIn,
434         uint amountOutMin,
435         address[] calldata path,
436         address to,
437         uint deadline
438     ) external;
439 }
440 
441 contract FLEX is IERC20, Ownable, LGEWhitelisted {
442 
443     mapping (address => uint256) private _balances;
444 
445     mapping (address => mapping (address => uint256)) private _allowances;
446 
447     uint256 private _totalSupply;
448 
449     string private _name;
450     string private _symbol;
451     uint8 private _decimals;
452     
453     mapping(address => bool) public _feeExcluded;
454 
455 	uint256 public _feeBurnPct;
456 	uint256 public _feeRewardPct;
457 	
458 	address public _feeRewardAddress;
459 
460 	mapping(address => bool) public _pair;
461 	
462 	address public _router;
463 	
464 	address[] public _feeRewardSwapPath;
465 
466     constructor(uint256 feeBurnPct, uint256 feeRewardPct, address feeRewardAddress, address router) {
467 
468         _name = "FlexMeme";
469         _symbol = "FLEX";
470 
471         _decimals = 18;
472         _totalSupply = 1000000000000e18;
473 
474 		IUniswapV2Router02 r = IUniswapV2Router02(router);
475 		IUniswapV2Factory f = IUniswapV2Factory(r.factory());
476 		
477         setPair(f.createPair(address(this), r.WETH()), true);
478         
479         address[] memory feeRewardSwapPath = new address[](2);
480             
481         feeRewardSwapPath[0] = address(this);
482         feeRewardSwapPath[1] = r.WETH();
483 		
484 		setFees(feeBurnPct, feeRewardPct, feeRewardSwapPath, feeRewardAddress);
485 		
486 		_router = router;
487 		
488 		setFeeExcluded(_msgSender(), true);
489 		setFeeExcluded(address(this), true);
490 
491         _balances[_msgSender()] = _totalSupply;
492         emit Transfer(address(0), _msgSender(), _totalSupply);
493     }
494 
495     function setRouter(address r) public onlyOwner {
496         _router = r;
497     }
498     
499     function setFees(uint256 feeBurnPct, uint256 feeRewardPct, address[] memory feeRewardSwapPath, address feeRewardAddress) public onlyOwner {
500         require((feeBurnPct+feeRewardPct) <= 2000, "Fees must not total more than 20%");
501         require(feeRewardSwapPath.length > 1, "Invalid path");
502 		require(feeRewardAddress != address(0), "Fee reward address must not be zero address");
503 		
504 		_feeBurnPct = feeBurnPct;
505 		_feeRewardPct = feeRewardPct;
506 		_feeRewardSwapPath = feeRewardSwapPath;
507 		_feeRewardAddress = feeRewardAddress;
508 		
509     }
510 
511 	function setPair(address a, bool pair) public onlyOwner {
512         require(a != address(0), "Pair address must not be zero address");
513         _pair[a] = pair;
514     }
515 
516 	function setFeeExcluded(address a, bool excluded) public onlyOwner {
517         require(a != address(0), "Fee excluded address must not be zero address");
518         _feeExcluded[a] = excluded;
519     }
520 
521     function burn(uint256 amount) external {
522         _burn(_msgSender(), amount);
523     }
524 
525     /**
526      * @dev Destroys `amount` tokens from `account`, reducing the
527      * total supply.
528      *
529      * Emits a {Transfer} event with `to` set to the zero address.
530      *
531      * Requirements:
532      *
533      * - `account` cannot be the zero address.
534      * - `account` must have at least `amount` tokens.
535      */
536     function _burn(address account, uint256 amount) internal virtual {
537         require(account != address(0), "ERC20: burn from the zero address");
538 
539         _beforeTokenTransfer(account, address(0), amount);
540 
541         uint256 accountBalance = _balances[account];
542         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
543         unchecked {
544             _balances[account] = accountBalance - amount;
545             // Overflow not possible: amount <= accountBalance <= totalSupply.
546             _totalSupply -= amount;
547         }
548 
549         emit Transfer(account, address(0), amount);
550 
551         _afterTokenTransfer(account, address(0), amount);
552     }
553 
554     /**
555      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
556      *
557      * This internal function is equivalent to `approve`, and can be used to
558      * e.g. set automatic allowances for certain subsystems, etc.
559      *
560      * Emits an {Approval} event.
561      *
562      * Requirements:
563      *
564      * - `owner` cannot be the zero address.
565      * - `spender` cannot be the zero address.
566      */
567     function _approve(address owner, address spender, uint256 amount) internal virtual {
568         require(owner != address(0), "ERC20: approve from the zero address");
569         require(spender != address(0), "ERC20: approve to the zero address");
570 
571         _allowances[owner][spender] = amount;
572         emit Approval(owner, spender, amount);
573     }
574 
575     function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal {
576 		LGEWhitelisted._applyLGEWhitelist(sender, recipient, amount);
577     }
578 
579     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
580 	
581 	function _transfer(address sender, address recipient, uint256 amount) internal {
582         require(sender != address(0), "ERC20: transfer from the zero address");
583         require(recipient != address(0), "ERC20: transfer to the zero address");
584 		
585         _beforeTokenTransfer(sender, recipient, amount);
586 		
587 		_balances[sender] -= amount;
588 		
589 		if(_pair[recipient] && !_feeExcluded[sender]) {
590 			
591 			uint256 feeBurnAmount = 0;
592 			
593 			if(_feeBurnPct > 0) {
594 			
595 				feeBurnAmount = (amount*_feeBurnPct)/10000;
596 				
597 				_totalSupply -= feeBurnAmount;
598 				emit Transfer(sender, address(0), feeBurnAmount);
599 				
600 			}
601 			
602 			uint256 feeRewardAmount = 0;
603 			
604 			if(_feeRewardPct > 0 && _feeRewardAddress != address(0))  {
605 			    
606 				feeRewardAmount = (amount*_feeRewardPct)/10000;
607 				
608 				if(_router != address(0)) {
609 				    
610     				_balances[address(this)] += feeRewardAmount;
611     				
612     				emit Transfer(sender, address(this), feeRewardAmount);
613     				
614     				IUniswapV2Router02 r = IUniswapV2Router02(_router);
615                     
616                     _approve(address(this), _router, feeRewardAmount);
617     
618                     r.swapExactTokensForTokensSupportingFeeOnTransferTokens(
619                         feeRewardAmount,
620                         0,
621                         _feeRewardSwapPath,
622                         _feeRewardAddress,
623                         block.timestamp
624                     );
625                 
626 				} else {
627 				    _balances[_feeRewardAddress] += feeRewardAmount;
628 				    emit Transfer(sender, _feeRewardAddress, feeRewardAmount);
629 				}
630 				
631 			}
632 			
633 			amount -= (feeBurnAmount+feeRewardAmount);
634 			
635 		}
636 
637         _balances[recipient] += amount;
638         emit Transfer(sender, recipient, amount);
639     }
640 
641     function name() public view override returns (string memory) {
642         return _name;
643     }
644 
645     function symbol() public view override returns (string memory) {
646         return _symbol;
647     }
648 
649     function decimals() public view override returns (uint8) {
650         return _decimals;
651     }
652 
653     function totalSupply() public view override returns (uint256) {
654         return _totalSupply;
655     }
656 
657     function balanceOf(address account) public view override returns (uint256) {
658         return _balances[account];
659     }
660 
661     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
662         _transfer(_msgSender(), recipient, amount);
663         return true;
664     }
665 
666     function allowance(address owner, address spender) public view virtual override returns (uint256) {
667         return _allowances[owner][spender];
668     }
669 
670     function approve(address spender, uint256 amount) public virtual override returns (bool) {
671         _approve(_msgSender(), spender, amount);
672         return true;
673     }
674 
675     /**
676      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
677      *
678      * Does not update the allowance amount in case of infinite allowance.
679      * Revert if not enough allowance is available.
680      *
681      * Might emit an {Approval} event.
682      */
683     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
684         uint256 currentAllowance = allowance(owner, spender);
685         if (currentAllowance != type(uint256).max) {
686             require(currentAllowance >= amount, "ERC20: insufficient allowance");
687             unchecked {
688                 _approve(owner, spender, currentAllowance - amount);
689             }
690         }
691     }
692     
693 /**
694      * @dev See {IERC20-transferFrom}.
695      *
696      * Emits an {Approval} event indicating the updated allowance. This is not
697      * required by the EIP. See the note at the beginning of {ERC20}.
698      *
699      * NOTE: Does not update the allowance if the current allowance
700      * is the maximum `uint256`.
701      *
702      * Requirements:
703      *
704      * - `from` and `to` cannot be the zero address.
705      * - `from` must have a balance of at least `amount`.
706      * - the caller must have allowance for ``from``'s tokens of at least
707      * `amount`.
708      */
709     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
710         address spender = _msgSender();
711         _spendAllowance(from, spender, amount);
712         _transfer(from, to, amount);
713         return true;
714     }
715 
716     /**
717      * @dev Atomically increases the allowance granted to `spender` by the caller.
718      *
719      * This is an alternative to {approve} that can be used as a mitigation for
720      * problems described in {IERC20-approve}.
721      *
722      * Emits an {Approval} event indicating the updated allowance.
723      *
724      * Requirements:
725      *
726      * - `spender` cannot be the zero address.
727      */
728     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
729         address owner = _msgSender();
730         _approve(owner, spender, allowance(owner, spender) + addedValue);
731         return true;
732     }
733 
734     /**
735      * @dev Atomically decreases the allowance granted to `spender` by the caller.
736      *
737      * This is an alternative to {approve} that can be used as a mitigation for
738      * problems described in {IERC20-approve}.
739      *
740      * Emits an {Approval} event indicating the updated allowance.
741      *
742      * Requirements:
743      *
744      * - `spender` cannot be the zero address.
745      * - `spender` must have allowance for the caller of at least
746      * `subtractedValue`.
747      */
748     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
749         address owner = _msgSender();
750         uint256 currentAllowance = allowance(owner, spender);
751         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
752         unchecked {
753             _approve(owner, spender, currentAllowance - subtractedValue);
754         }
755 
756         return true;
757     }
758 
759 }