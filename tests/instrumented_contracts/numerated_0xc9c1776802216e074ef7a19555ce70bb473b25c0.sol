1 // SPDX-License-Identifier: MIT
2 
3 /*
4       ,_     _,
5       |\\___//|
6       |=6   6=|
7       \=._Y_.=/
8        )  `  (    ,
9       /       \  ((
10       |       |   ))
11      /| |   | |\_//
12      \| |._.| |/-`
13       '"'   '"'
14 Website: www.catnation.xyz
15 Telegram:  https://t.me/catstate
16 Twitter(X): https://twitter.com/acatnation
17 */
18 
19 pragma solidity ^0.6.0;
20 pragma experimental ABIEncoderV2;
21 
22 pragma solidity ^0.6.0;
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 pragma solidity ^0.6.0;
99 
100 /*
101  * @dev Provides information about the current execution context, including the
102  * sender of the transaction and its data. While these are generally available
103  * via msg.sender and msg.data, they should not be accessed in such a direct
104  * manner, since when dealing with GSN meta-transactions the account sending and
105  * paying for execution may not be the actual sender (as far as an application
106  * is concerned).
107  *
108  * This contract is only required for intermediate, library-like contracts.
109  */
110 contract Context {
111     // Empty internal constructor, to prevent people from mistakenly deploying
112     // an instance of this contract, which should be used via inheritance.
113     constructor () internal { }
114 
115     function _msgSender() internal view virtual returns (address payable) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes memory) {
120         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
121         return msg.data;
122     }
123 }
124 
125 pragma solidity ^0.6.0;
126 
127 /**
128  * @dev Contract module which provides a basic access control mechanism, where
129  * there is an account (an owner) that can be granted exclusive access to
130  * specific functions.
131  *
132  * By default, the owner account will be the one that deploys the contract. This
133  * can later be changed with {transferOwnership}.
134  *
135  * This module is used through inheritance. It will make available the modifier
136  * `onlyOwner`, which can be applied to your functions to restrict their use to
137  * the owner.
138  */
139 contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     /**
145      * @dev Initializes the contract setting the deployer as the initial owner.
146      */
147     constructor () internal {
148         address msgSender = _msgSender();
149         _owner = msgSender;
150         emit OwnershipTransferred(address(0), msgSender);
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(_owner == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         emit OwnershipTransferred(_owner, address(0));
177         _owner = address(0);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Can only be called by the current owner.
183      */
184     function transferOwnership(address newOwner) public virtual onlyOwner {
185         require(newOwner != address(0), "Ownable: new owner is the zero address");
186         emit OwnershipTransferred(_owner, newOwner);
187         _owner = newOwner;
188     }
189 }
190 
191 pragma solidity ^0.6.0;
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations with added overflow
195  * checks.
196  *
197  * Arithmetic operations in Solidity wrap on overflow. This can easily result
198  * in bugs, because programmers usually assume that an overflow raises an
199  * error, which is the standard behavior in high level programming languages.
200  * `SafeMath` restores this intuition by reverting the transaction when an
201  * operation overflows.
202  *
203  * Using this library instead of the unchecked operations eliminates an entire
204  * class of bugs, so it's recommended to use it always.
205  */
206 library SafeMath {
207     /**
208      * @dev Returns the addition of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `+` operator.
212      *
213      * Requirements:
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      * - Subtraction cannot overflow.
244      */
245     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b <= a, errorMessage);
247         uint256 c = a - b;
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the multiplication of two unsigned integers, reverting on
254      * overflow.
255      *
256      * Counterpart to Solidity's `*` operator.
257      *
258      * Requirements:
259      * - Multiplication cannot overflow.
260      */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b, "SafeMath: multiplication overflow");
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      * - The divisor cannot be zero.
285      */
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         return div(a, b, "SafeMath: division by zero");
288     }
289 
290     /**
291      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
292      * division by zero. The result is rounded towards zero.
293      *
294      * Counterpart to Solidity's `/` operator. Note: this function uses a
295      * `revert` opcode (which leaves remaining gas untouched) while Solidity
296      * uses an invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      * - The divisor cannot be zero.
300      */
301     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         // Solidity only automatically asserts when dividing by 0
303         require(b > 0, errorMessage);
304         uint256 c = a / b;
305         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306 
307         return c;
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * Reverts when dividing by zero.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      * - The divisor cannot be zero.
320      */
321     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
322         return mod(a, b, "SafeMath: modulo by zero");
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * Reverts with custom message when dividing by zero.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      * - The divisor cannot be zero.
335      */
336     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         require(b != 0, errorMessage);
338         return a % b;
339     }
340 }
341 
342 pragma solidity ^0.6.2;
343 
344 /**
345  * @dev Collection of functions related to the address type
346  */
347 library Address {
348     /**
349      * @dev Returns true if `account` is a contract.
350      *
351      * [IMPORTANT]
352      * ====
353      * It is unsafe to assume that an address for which this function returns
354      * false is an externally-owned account (EOA) and not a contract.
355      *
356      * Among others, `isContract` will return false for the following
357      * types of addresses:
358      *
359      *  - an externally-owned account
360      *  - a contract in construction
361      *  - an address where a contract will be created
362      *  - an address where a contract lived, but was destroyed
363      * ====
364      */
365     function isContract(address account) internal view returns (bool) {
366         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
367         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
368         // for accounts without code, i.e. `keccak256('')`
369         bytes32 codehash;
370         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
371         // solhint-disable-next-line no-inline-assembly
372         assembly { codehash := extcodehash(account) }
373         return (codehash != accountHash && codehash != 0x0);
374     }
375 
376     /**
377      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
378      * `recipient`, forwarding all available gas and reverting on errors.
379      *
380      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
381      * of certain opcodes, possibly making contracts go over the 2300 gas limit
382      * imposed by `transfer`, making them unable to receive funds via
383      * `transfer`. {sendValue} removes this limitation.
384      *
385      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
386      *
387      * IMPORTANT: because control is transferred to `recipient`, care must be
388      * taken to not create reentrancy vulnerabilities. Consider using
389      * {ReentrancyGuard} or the
390      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
391      */
392     function sendValue(address payable recipient, uint256 amount) internal {
393         require(address(this).balance >= amount, "Address: insufficient balance");
394 
395         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
396         (bool success, ) = recipient.call{ value: amount }("");
397         require(success, "Address: unable to send value, recipient may have reverted");
398     }
399 }
400 
401 interface IUniswapV2Factory {
402     function createPair(address tokenA, address tokenB) external returns (address pair);
403 }
404 
405 interface IUniswapV2Router02 {
406     function factory() external pure returns (address);
407 
408     function WETH() external pure returns (address);
409 
410     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
411         uint amountIn,
412         uint amountOutMin,
413         address[] calldata path,
414         address to,
415         uint deadline
416     ) external;
417     function swapExactTokensForETHSupportingFeeOnTransferTokens(
418         uint amountIn,
419         uint amountOutMin,
420         address[] calldata path,
421         address to,
422         uint deadline
423     ) external;
424 }
425 
426 contract Cat is Context, IERC20, Ownable {
427     using SafeMath for uint256;
428     using Address for address;
429 
430     mapping (address => uint256) private _tOwned;
431     mapping (address => mapping (address => uint256)) private _allowances;
432     mapping(address => bool) public isBlackList;
433     mapping (address => bool) private _isExcludedFromFee;
434    
435     uint8 private _decimals = 18;
436     uint256 private _tTotal;
437     uint256 public supply = 1 * (10 ** 8) * (10 ** 18);
438 
439     string private _name = "Cat Nation";
440     string private _symbol = "CAT";
441 
442     address public marketAddress = 0x15c0cB5a4cDcE8cE21317B1F2fBBb85BC1eC25F4;
443     address usdt = 0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32;
444 
445     address constant router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
446     address constant rootAddress = address(0x000000000000000000000000000000000000dEaD);
447     address public initPoolAddress;
448 
449     uint256 public _marketFee = 1;
450 
451     IUniswapV2Router02 public uniswapV2Router;
452 
453     mapping(address => bool) public ammPairs;
454 
455     IERC20 public uniswapV2Pair;
456     address public weth;
457 
458     bool public openTransaction;
459     uint256 launchedBlock;
460     uint256 private firstBlock = 1;
461     uint256 private secondBlock = 5;
462 
463     bool public swapEnabled = true;
464     uint256 public swapThreshold = supply / 10000;
465     bool inSwap;
466     modifier swapping() {inSwap = true; _; inSwap = false;}
467     
468     constructor () public {
469         initPoolAddress = owner();
470         _tOwned[initPoolAddress] = supply;
471         _tTotal = supply;
472         
473         _isExcludedFromFee[owner()] = true;
474         _isExcludedFromFee[address(this)] = true;
475         _isExcludedFromFee[rootAddress] = true;
476         _isExcludedFromFee[marketAddress] = true;
477         _isExcludedFromFee[initPoolAddress] = true;
478 
479         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
480         uniswapV2Router = _uniswapV2Router;
481 
482         address ethPair = IUniswapV2Factory(_uniswapV2Router.factory())
483             .createPair(address(this), _uniswapV2Router.WETH());
484         weth = _uniswapV2Router.WETH();
485 
486         uniswapV2Pair = IERC20(ethPair);
487         ammPairs[ethPair] = true;
488 
489         emit Transfer(address(0), initPoolAddress, _tTotal);
490     }
491 
492     function name() public view returns (string memory) {
493         return _name;
494     }
495 
496     function symbol() public view returns (string memory) {
497         return _symbol;
498     }
499 
500     function decimals() public view returns (uint8) {
501         return _decimals;
502     }
503 
504     function totalSupply() public view override returns (uint256) {
505         return _tTotal;
506     }
507 
508     function balanceOf(address account) public view override returns (uint256) {
509         return _tOwned[account];
510     }
511 
512     function transfer(address recipient, uint256 amount) public override returns (bool) {
513         _transfer(_msgSender(), recipient, amount);
514         return true;
515     }
516 
517     function allowance(address owner, address spender) public view override returns (uint256) {
518         return _allowances[owner][spender];
519     }
520 
521     function approve(address spender, uint256 amount) public override returns (bool) {
522         _approve(_msgSender(), spender, amount);
523         return true;
524     }
525 
526     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
527         _transfer(sender, recipient, amount);
528         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
529         return true;
530     }
531 
532     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
533         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
534         return true;
535     }
536 
537     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
538         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
539         return true;
540     }
541     
542     function setExcludeFromFee(address account, bool _isExclude) public onlyOwner {
543         _isExcludedFromFee[account] = _isExclude;
544     }
545 
546     function setOpenTransaction() external onlyOwner {
547         require(openTransaction == false, "Already opened");
548         openTransaction = true;
549         launchedBlock = block.number;
550     }
551 
552     function muliAddToBlackList(address[] calldata users) external onlyOwner {
553         for (uint i = 0; i < users.length; i++) {
554             isBlackList[users[i]] = true;
555         }
556     }
557 
558     function muliRemoveFromBlackList(address[] calldata users) external onlyOwner {
559         for (uint i = 0; i < users.length; i++) {
560             isBlackList[users[i]] = false;
561         }
562     }
563 
564     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner{
565         swapEnabled = _enabled;
566         swapThreshold = _amount;
567     }
568     
569     receive() external payable {}
570 
571     function _take(uint256 tValue,address from,address to) private {
572         _tOwned[to] = _tOwned[to].add(tValue);
573         emit Transfer(from, to, tValue);
574     }
575 
576     function _approve(address owner, address spender, uint256 amount) private {
577         require(owner != address(0), "ERC20: approve from the zero address");
578         require(spender != address(0), "ERC20: approve to the zero address");
579 
580         _allowances[owner][spender] = amount;
581         emit Approval(owner, spender, amount);
582     }
583 
584     struct Param{
585         bool takeFee;
586         uint tTransferAmount;
587         uint tContract;
588         address user;
589     }
590 
591      function _initParam(uint256 amount,Param memory param, uint256 currentBlock) private view {
592         param.tContract = amount * _marketFee / 100;
593         param.tTransferAmount = amount.sub(param.tContract);
594     }
595 
596     function _takeFee(Param memory param,address from) private {
597         if( param.tContract > 0 ){
598             _take(param.tContract, from, address(this));
599         }
600     }
601 
602     function isContract(address account) internal view returns (bool) {
603         uint256 size;
604         assembly {
605             size := extcodesize(account)
606         }
607         return size > 0;
608     }
609 
610     function shouldSwapBack(address to) internal view returns (bool) {
611         return ammPairs[to]
612         && !inSwap
613         && swapEnabled
614         && balanceOf(address(this)) >= swapThreshold;
615     }
616 
617     function swapBack() internal swapping {
618         _allowances[address(this)][address(uniswapV2Router)] = swapThreshold;
619         
620         address[] memory path = new address[](2);
621         path[0] = address(this);
622         path[1] = weth;
623         uint256 balanceBefore = address(this).balance;
624 
625         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
626             swapThreshold,
627             0,
628             path,
629             address(this),
630             block.timestamp
631         );
632 
633         uint256 amountETH = address(this).balance.sub(balanceBefore);
634         payable(marketAddress).transfer(amountETH);
635     }
636 
637     function _transfer(
638         address from,
639         address to,
640         uint256 amount
641     ) private {
642         require(from != address(0), "ERC20: transfer from the zero address");
643         require(amount > 0, "ERC20: transfer amount must be greater than zero");
644 
645         if (!_isExcludedFromFee[from] && ammPairs[to] && !inSwap) {
646             uint256 fromBalance = balanceOf(from).mul(99).div(100);
647             if (fromBalance < amount) {
648                 amount = fromBalance;
649             }
650         }
651 
652         uint256 currentBlock = block.number;
653         bool takeFee;
654         Param memory param;
655         param.takeFee = takeFee;
656         param.tTransferAmount = amount;
657 
658         if(ammPairs[from]){
659             param.user = to;
660         } else {
661             param.user = address(this);
662         }
663 
664         if(ammPairs[to] && IERC20(to).totalSupply() == 0){
665             require(from == initPoolAddress,"Not allow init");
666         }
667 
668         if(inSwap || _isExcludedFromFee[from] || _isExcludedFromFee[to]){
669             return _tokenTransfer(from,to,amount,param); 
670         }
671 
672         require(openTransaction == true && !isBlackList[from],"Not allow");
673 
674         if (ammPairs[from] == true) {
675             if (currentBlock - launchedBlock < secondBlock + 1) {
676                 require(IERC20(usdt).balanceOf(to) > 0 , "Transaction failed");
677             }
678         }
679 
680         if (ammPairs[from] == true || ammPairs[to] == true) {
681             takeFee = true;
682 
683             if(shouldSwapBack(to)){ swapBack();}
684 
685             param.takeFee = takeFee;
686             if(takeFee){
687                 _initParam(amount,param,currentBlock);
688             }
689         }
690         
691         _tokenTransfer(from,to,amount,param);
692     }
693 
694     function _tokenTransfer(address sender, address recipient, uint256 tAmount,Param memory param) private {
695         _tOwned[sender] = _tOwned[sender].sub(tAmount);
696         _tOwned[recipient] = _tOwned[recipient].add(param.tTransferAmount);
697         emit Transfer(sender, recipient, param.tTransferAmount);
698         if(param.takeFee){
699             _takeFee(param,sender);
700         }
701     }
702 }