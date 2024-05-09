1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449      /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: contracts/lib/CompoundOracleInterface.sol
502 
503 pragma solidity ^0.5.0;
504 // AT MAINNET ADDRESS: 0x02557a5E05DeFeFFD4cAe6D83eA3d173B272c904
505 
506 contract CompoundOracleInterface {
507     // returns asset:eth -- to get USDC:eth, have to do 10**24/result,
508 
509 
510     constructor() public {
511     }
512 
513     /**
514   * @notice retrieves price of an asset
515   * @dev function to get price for an asset
516   * @param asset Asset for which to get the price
517   * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
518   */
519     function getPrice(address asset) public view returns (uint);
520     function getUnderlyingPrice(ERC20 cToken) public view returns (uint);
521     // function getPrice(address asset) public view returns (uint) {
522     //     return 527557000000000;
523     // }
524 
525 }
526 
527 // File: contracts/lib/UniswapExchangeInterface.sol
528 
529 pragma solidity 0.5.10;
530 
531 
532 // Solidity Interface
533 contract UniswapExchangeInterface {
534     // Address of ERC20 token sold on this exchange
535     function tokenAddress() external view returns (address token);
536     // Address of Uniswap Factory
537     function factoryAddress() external view returns (address factory);
538     // Provide Liquidity
539     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
540     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
541     // Get Prices
542     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
543     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
544     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
545     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
546     // Trade ETH to ERC20
547     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
548     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
549     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
550     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
551     // Trade ERC20 to ETH
552     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
553     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
554     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
555     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
556     // Trade ERC20 to ERC20
557     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
558     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
559     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
560     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
561     // Trade ERC20 to Custom Pool
562     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
563     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
564     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
565     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
566     // ERC20 comaptibility for liquidity tokens
567     bytes32 public name;
568     bytes32 public symbol;
569     uint256 public decimals;
570     function transfer(address _to, uint256 _value) external returns (bool);
571     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
572     function approve(address _spender, uint256 _value) external returns (bool);
573     function allowance(address _owner, address _spender) external view returns (uint256);
574     function balanceOf(address _owner) external view returns (uint256);
575     function totalSupply() external view returns (uint256);
576     // Never use
577     function setup(address token_addr) external;
578 }
579 
580 // File: contracts/lib/UniswapFactoryInterface.sol
581 
582 pragma solidity 0.5.10;
583 
584 
585 // Solidity Interface
586 contract UniswapFactoryInterface {
587     // Public Variables
588     address public exchangeTemplate;
589     uint256 public tokenCount;
590     // // Create Exchange
591     function createExchange(address token) external returns (address exchange);
592     // Get Exchange and Token Info
593     function getExchange(address token) external view returns (address exchange);
594     function getToken(address exchange) external view returns (address token);
595     function getTokenWithId(uint256 tokenId) external view returns (address token);
596     // Never use
597     function initializeFactory(address template) external;
598     // function createExchange(address token) external returns (address exchange) {
599     //     return 0x06D014475F84Bb45b9cdeD1Cf3A1b8FE3FbAf128;
600     // }
601     // // Get Exchange and Token Info
602     // function getExchange(address token) external view returns (address exchange){
603     //     return 0x06D014475F84Bb45b9cdeD1Cf3A1b8FE3FbAf128;
604     // }
605     // function getToken(address exchange) external view returns (address token) {
606     //     return 0x06D014475F84Bb45b9cdeD1Cf3A1b8FE3FbAf128;
607     // }
608     // function getTokenWithId(uint256 tokenId) external view returns (address token) {
609     //     return 0x06D014475F84Bb45b9cdeD1Cf3A1b8FE3FbAf128;
610     // }
611 }
612 
613 // File: contracts/OptionsUtils.sol
614 
615 pragma solidity 0.5.10;
616 
617 
618 
619 
620 
621 contract OptionsUtils {
622     // defauls are for mainnet
623     UniswapFactoryInterface public UNISWAP_FACTORY;
624 
625     CompoundOracleInterface public COMPOUND_ORACLE;
626 
627     constructor(address _uniswapFactory, address _compoundOracle) public {
628         UNISWAP_FACTORY = UniswapFactoryInterface(_uniswapFactory);
629         COMPOUND_ORACLE = CompoundOracleInterface(_compoundOracle);
630     }
631 
632     // TODO: for now gets Uniswap, later update to get other exchanges
633     function getExchange(address _token)
634         public
635         view
636         returns (UniswapExchangeInterface)
637     {
638         if (address(UNISWAP_FACTORY.getExchange(_token)) == address(0)) {
639             revert("No payout exchange");
640         }
641 
642         UniswapExchangeInterface exchange = UniswapExchangeInterface(
643             UNISWAP_FACTORY.getExchange(_token)
644         );
645 
646         return exchange;
647     }
648 
649     function isETH(IERC20 _ierc20) public pure returns (bool) {
650         return _ierc20 == IERC20(0);
651     }
652 }
653 
654 // File: contracts/OptionsExchange.sol
655 
656 pragma solidity 0.5.10;
657 
658 
659 
660 
661 
662 
663 contract OptionsExchange {
664     uint256 constant LARGE_BLOCK_SIZE = 1651753129000;
665     uint256 constant LARGE_APPROVAL_NUMBER = 10**30;
666 
667     UniswapFactoryInterface public UNISWAP_FACTORY;
668 
669     constructor(address _uniswapFactory) public {
670         UNISWAP_FACTORY = UniswapFactoryInterface(_uniswapFactory);
671     }
672 
673     /*** Events ***/
674     event SellOTokens(
675         address seller,
676         address payable receiver,
677         address oTokenAddress,
678         address payoutTokenAddress,
679         uint256 oTokensToSell,
680         uint256 payoutTokensReceived
681     );
682     event BuyOTokens(
683         address buyer,
684         address payable receiver,
685         address oTokenAddress,
686         address paymentTokenAddress,
687         uint256 oTokensToBuy,
688         uint256 premiumPaid
689     );
690 
691     /**
692     * @notice This function sells oTokens on Uniswap and sends back payoutTokens to the receiver
693     * @param receiver The address to send the payout tokens back to
694     * @param oTokenAddress The address of the oToken to sell
695     * @param payoutTokenAddress The address of the token to receive the premiums in
696     * @param oTokensToSell The number of oTokens to sell
697     */
698     function sellOTokens(
699         address payable receiver,
700         address oTokenAddress,
701         address payoutTokenAddress,
702         uint256 oTokensToSell
703     ) public {
704         // @note: first need to bootstrap the uniswap exchange to get the address.
705         IERC20 oToken = IERC20(oTokenAddress);
706         IERC20 payoutToken = IERC20(payoutTokenAddress);
707         oToken.transferFrom(msg.sender, address(this), oTokensToSell);
708         uint256 payoutTokensReceived = uniswapSellOToken(
709             oToken,
710             payoutToken,
711             oTokensToSell,
712             receiver
713         );
714 
715         emit SellOTokens(
716             msg.sender,
717             receiver,
718             oTokenAddress,
719             payoutTokenAddress,
720             oTokensToSell,
721             payoutTokensReceived
722         );
723     }
724 
725     /**
726     * @notice This function buys oTokens on Uniswap and using paymentTokens from the receiver
727     * @param receiver The address to send the oTokens back to
728     * @param oTokenAddress The address of the oToken to buy
729     * @param paymentTokenAddress The address of the token to pay the premiums in
730     * @param oTokensToBuy The number of oTokens to buy
731     */
732     function buyOTokens(
733         address payable receiver,
734         address oTokenAddress,
735         address paymentTokenAddress,
736         uint256 oTokensToBuy
737     ) public payable {
738         IERC20 oToken = IERC20(oTokenAddress);
739         IERC20 paymentToken = IERC20(paymentTokenAddress);
740         uniswapBuyOToken(paymentToken, oToken, oTokensToBuy, receiver);
741     }
742 
743     /**
744     * @notice This function calculates the amount of premiums that the seller
745     * will receive if they sold oTokens on Uniswap
746     * @param oTokenAddress The address of the oToken to sell
747     * @param payoutTokenAddress The address of the token to receive the premiums in
748     * @param oTokensToSell The number of oTokens to sell
749     */
750     function premiumReceived(
751         address oTokenAddress,
752         address payoutTokenAddress,
753         uint256 oTokensToSell
754     ) public view returns (uint256) {
755         // get the amount of ETH that will be paid out if oTokensToSell is sold.
756         UniswapExchangeInterface oTokenExchange = getExchange(oTokenAddress);
757         uint256 ethReceived = oTokenExchange.getTokenToEthInputPrice(
758             oTokensToSell
759         );
760 
761         if (!isETH(IERC20(payoutTokenAddress))) {
762             // get the amount of payout tokens that will be received if the ethRecieved is sold.
763             UniswapExchangeInterface payoutExchange = getExchange(
764                 payoutTokenAddress
765             );
766             return payoutExchange.getEthToTokenInputPrice(ethReceived);
767         }
768         return ethReceived;
769 
770     }
771 
772     /**
773     * @notice This function calculates the premiums to be paid if a buyer wants to
774     * buy oTokens on Uniswap
775     * @param oTokenAddress The address of the oToken to buy
776     * @param paymentTokenAddress The address of the token to pay the premiums in
777     * @param oTokensToBuy The number of oTokens to buy
778     */
779     function premiumToPay(
780         address oTokenAddress,
781         address paymentTokenAddress,
782         uint256 oTokensToBuy
783     ) public view returns (uint256) {
784         // get the amount of ETH that needs to be paid for oTokensToBuy.
785         UniswapExchangeInterface oTokenExchange = getExchange(oTokenAddress);
786         uint256 ethToPay = oTokenExchange.getEthToTokenOutputPrice(
787             oTokensToBuy
788         );
789 
790         if (!isETH(IERC20(paymentTokenAddress))) {
791             // get the amount of paymentTokens that needs to be paid to get the desired ethToPay.
792             UniswapExchangeInterface paymentTokenExchange = getExchange(
793                 paymentTokenAddress
794             );
795             return paymentTokenExchange.getTokenToEthOutputPrice(ethToPay);
796         }
797 
798         return ethToPay;
799     }
800 
801     function uniswapSellOToken(
802         IERC20 oToken,
803         IERC20 payoutToken,
804         uint256 _amt,
805         address payable _transferTo
806     ) internal returns (uint256) {
807         require(!isETH(oToken), "Can only sell oTokens");
808         UniswapExchangeInterface exchange = getExchange(address(oToken));
809 
810         if (isETH(payoutToken)) {
811             //Token to ETH
812             oToken.approve(address(exchange), _amt);
813             return
814                 exchange.tokenToEthTransferInput(
815                     _amt,
816                     1,
817                     LARGE_BLOCK_SIZE,
818                     _transferTo
819                 );
820         } else {
821             //Token to Token
822             oToken.approve(address(exchange), _amt);
823             return
824                 exchange.tokenToTokenTransferInput(
825                     _amt,
826                     1,
827                     1,
828                     LARGE_BLOCK_SIZE,
829                     _transferTo,
830                     address(payoutToken)
831                 );
832         }
833     }
834 
835     function uniswapBuyOToken(
836         IERC20 paymentToken,
837         IERC20 oToken,
838         uint256 _amt,
839         address payable _transferTo
840     ) public returns (uint256) {
841         require(!isETH(oToken), "Can only buy oTokens");
842 
843         if (!isETH(paymentToken)) {
844             UniswapExchangeInterface exchange = getExchange(
845                 address(paymentToken)
846             );
847 
848             uint256 paymentTokensToTransfer = premiumToPay(
849                 address(oToken),
850                 address(paymentToken),
851                 _amt
852             );
853             paymentToken.transferFrom(
854                 msg.sender,
855                 address(this),
856                 paymentTokensToTransfer
857             );
858 
859             // Token to Token
860             paymentToken.approve(address(exchange), LARGE_APPROVAL_NUMBER);
861 
862             emit BuyOTokens(
863                 msg.sender,
864                 _transferTo,
865                 address(oToken),
866                 address(paymentToken),
867                 _amt,
868                 paymentTokensToTransfer
869             );
870 
871             return
872                 exchange.tokenToTokenTransferInput(
873                     paymentTokensToTransfer,
874                     1,
875                     1,
876                     LARGE_BLOCK_SIZE,
877                     _transferTo,
878                     address(oToken)
879                 );
880         } else {
881             // ETH to Token
882             UniswapExchangeInterface exchange = UniswapExchangeInterface(
883                 UNISWAP_FACTORY.getExchange(address(oToken))
884             );
885 
886             uint256 ethToTransfer = exchange.getEthToTokenOutputPrice(_amt);
887 
888             emit BuyOTokens(
889                 msg.sender,
890                 _transferTo,
891                 address(oToken),
892                 address(paymentToken),
893                 _amt,
894                 ethToTransfer
895             );
896 
897             return
898                 exchange.ethToTokenTransferOutput.value(ethToTransfer)(
899                     _amt,
900                     LARGE_BLOCK_SIZE,
901                     _transferTo
902                 );
903         }
904     }
905 
906     function getExchange(address _token)
907         internal
908         view
909         returns (UniswapExchangeInterface)
910     {
911         UniswapExchangeInterface exchange = UniswapExchangeInterface(
912             UNISWAP_FACTORY.getExchange(_token)
913         );
914 
915         if (address(exchange) == address(0)) {
916             revert("No payout exchange");
917         }
918 
919         return exchange;
920     }
921 
922     function isETH(IERC20 _ierc20) internal pure returns (bool) {
923         return _ierc20 == IERC20(0);
924     }
925 
926     function() external payable {
927         // to get ether from uniswap exchanges
928     }
929 
930 }
931 
932 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
933 
934 pragma solidity ^0.5.0;
935 
936 
937 /**
938  * @dev Optional functions from the ERC20 standard.
939  */
940 contract ERC20Detailed is IERC20 {
941     string private _name;
942     string private _symbol;
943     uint8 private _decimals;
944 
945     /**
946      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
947      * these values are immutable: they can only be set once during
948      * construction.
949      */
950     constructor (string memory name, string memory symbol, uint8 decimals) public {
951         _name = name;
952         _symbol = symbol;
953         _decimals = decimals;
954     }
955 
956     /**
957      * @dev Returns the name of the token.
958      */
959     function name() public view returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev Returns the symbol of the token, usually a shorter version of the
965      * name.
966      */
967     function symbol() public view returns (string memory) {
968         return _symbol;
969     }
970 
971     /**
972      * @dev Returns the number of decimals used to get its user representation.
973      * For example, if `decimals` equals `2`, a balance of `505` tokens should
974      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
975      *
976      * Tokens usually opt for a value of 18, imitating the relationship between
977      * Ether and Wei.
978      *
979      * NOTE: This information is only used for _display_ purposes: it in
980      * no way affects any of the arithmetic of the contract, including
981      * {IERC20-balanceOf} and {IERC20-transfer}.
982      */
983     function decimals() public view returns (uint8) {
984         return _decimals;
985     }
986 }
987 
988 // File: @openzeppelin/contracts/ownership/Ownable.sol
989 
990 pragma solidity ^0.5.0;
991 
992 /**
993  * @dev Contract module which provides a basic access control mechanism, where
994  * there is an account (an owner) that can be granted exclusive access to
995  * specific functions.
996  *
997  * This module is used through inheritance. It will make available the modifier
998  * `onlyOwner`, which can be applied to your functions to restrict their use to
999  * the owner.
1000  */
1001 contract Ownable is Context {
1002     address private _owner;
1003 
1004     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1005 
1006     /**
1007      * @dev Initializes the contract setting the deployer as the initial owner.
1008      */
1009     constructor () internal {
1010         _owner = _msgSender();
1011         emit OwnershipTransferred(address(0), _owner);
1012     }
1013 
1014     /**
1015      * @dev Returns the address of the current owner.
1016      */
1017     function owner() public view returns (address) {
1018         return _owner;
1019     }
1020 
1021     /**
1022      * @dev Throws if called by any account other than the owner.
1023      */
1024     modifier onlyOwner() {
1025         require(isOwner(), "Ownable: caller is not the owner");
1026         _;
1027     }
1028 
1029     /**
1030      * @dev Returns true if the caller is the current owner.
1031      */
1032     function isOwner() public view returns (bool) {
1033         return _msgSender() == _owner;
1034     }
1035 
1036     /**
1037      * @dev Leaves the contract without owner. It will not be possible to call
1038      * `onlyOwner` functions anymore. Can only be called by the current owner.
1039      *
1040      * NOTE: Renouncing ownership will leave the contract without an owner,
1041      * thereby removing any functionality that is only available to the owner.
1042      */
1043     function renounceOwnership() public onlyOwner {
1044         emit OwnershipTransferred(_owner, address(0));
1045         _owner = address(0);
1046     }
1047 
1048     /**
1049      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1050      * Can only be called by the current owner.
1051      */
1052     function transferOwnership(address newOwner) public onlyOwner {
1053         _transferOwnership(newOwner);
1054     }
1055 
1056     /**
1057      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1058      */
1059     function _transferOwnership(address newOwner) internal {
1060         require(newOwner != address(0), "Ownable: new owner is the zero address");
1061         emit OwnershipTransferred(_owner, newOwner);
1062         _owner = newOwner;
1063     }
1064 }
1065 
1066 // File: contracts/OptionsContract.sol
1067 
1068 pragma solidity 0.5.10;
1069 
1070 
1071 
1072 
1073 
1074 
1075 
1076 
1077 
1078 
1079 
1080 /**
1081  * @title Opyn's Options Contract
1082  * @author Opyn
1083  */
1084 contract OptionsContract is Ownable, ERC20 {
1085     using SafeMath for uint256;
1086 
1087     /* represents floting point numbers, where number = value * 10 ** exponent
1088     i.e 0.1 = 10 * 10 ** -3 */
1089     struct Number {
1090         uint256 value;
1091         int32 exponent;
1092     }
1093 
1094     // Keeps track of the weighted collateral and weighted debt for each vault.
1095     struct Vault {
1096         uint256 collateral;
1097         uint256 oTokensIssued;
1098         uint256 underlying;
1099         bool owned;
1100     }
1101 
1102     OptionsExchange public optionsExchange;
1103 
1104     mapping(address => Vault) internal vaults;
1105 
1106     address payable[] internal vaultOwners;
1107 
1108     // 10 is 0.01 i.e. 1% incentive.
1109     Number public liquidationIncentive = Number(10, -3);
1110 
1111     // 100 is egs. 0.1 i.e. 10%.
1112     Number public transactionFee = Number(0, -3);
1113 
1114     /* 500 is 0.5. Max amount that a Vault can be liquidated by i.e.
1115     max collateral that can be taken in one function call */
1116     Number public liquidationFactor = Number(500, -3);
1117 
1118     /* 16 means 1.6. The minimum ratio of a Vault's collateral to insurance promised.
1119     The ratio is calculated as below:
1120     vault.collateral / (Vault.oTokensIssued * strikePrice) */
1121     Number public minCollateralizationRatio = Number(16, -1);
1122 
1123     // The amount of insurance promised per oToken
1124     Number public strikePrice;
1125 
1126     // The amount of underlying that 1 oToken protects.
1127     Number public oTokenExchangeRate;
1128 
1129     /* UNIX time.
1130     Exercise period starts at `(expiry - windowSize)` and ends at `expiry` */
1131     uint256 internal windowSize;
1132 
1133     /* The total fees accumulated in the contract any time liquidate or exercise is called */
1134     uint256 internal totalFee;
1135 
1136     // The time of expiry of the options contract
1137     uint256 public expiry;
1138 
1139     // The precision of the collateral
1140     int32 public collateralExp = -18;
1141 
1142     // The precision of the underlying
1143     int32 public underlyingExp = -18;
1144 
1145     // The collateral asset
1146     IERC20 public collateral;
1147 
1148     // The asset being protected by the insurance
1149     IERC20 public underlying;
1150 
1151     // The asset in which insurance is denominated in.
1152     IERC20 public strike;
1153 
1154     // The Oracle used for the contract
1155     CompoundOracleInterface public COMPOUND_ORACLE;
1156 
1157     // The name of  the contract
1158     string public name;
1159 
1160     // The symbol of  the contract
1161     string public symbol;
1162 
1163     // The number of decimals of the contract
1164     uint8 public decimals;
1165 
1166     /**
1167     * @param _collateral The collateral asset
1168     * @param _collExp The precision of the collateral (-18 if ETH)
1169     * @param _underlying The asset that is being protected
1170     * @param _underlyingExp The precision of the underlying asset
1171     * @param _oTokenExchangeExp The precision of the `amount of underlying` that 1 oToken protects
1172     * @param _strikePrice The amount of strike asset that will be paid out per oToken
1173     * @param _strikeExp The precision of the strike price.
1174     * @param _strike The asset in which the insurance is calculated
1175     * @param _expiry The time at which the insurance expires
1176     * @param _optionsExchange The contract which interfaces with the exchange + oracle
1177     * @param _oracleAddress The address of the oracle
1178     * @param _windowSize UNIX time. Exercise window is from `expiry - _windowSize` to `expiry`.
1179     */
1180     constructor(
1181         IERC20 _collateral,
1182         int32 _collExp,
1183         IERC20 _underlying,
1184         int32 _underlyingExp,
1185         int32 _oTokenExchangeExp,
1186         uint256 _strikePrice,
1187         int32 _strikeExp,
1188         IERC20 _strike,
1189         uint256 _expiry,
1190         OptionsExchange _optionsExchange,
1191         address _oracleAddress,
1192         uint256 _windowSize
1193     ) public {
1194         require(block.timestamp < _expiry, "Can't deploy an expired contract");
1195         require(
1196             _windowSize <= _expiry,
1197             "Exercise window can't be longer than the contract's lifespan"
1198         );
1199         require(
1200             isWithinExponentRange(_collExp),
1201             "collateral exponent not within expected range"
1202         );
1203         require(
1204             isWithinExponentRange(_underlyingExp),
1205             "underlying exponent not within expected range"
1206         );
1207         require(
1208             isWithinExponentRange(_strikeExp),
1209             "strike price exponent not within expected range"
1210         );
1211         require(
1212             isWithinExponentRange(_oTokenExchangeExp),
1213             "oToken exchange rate exponent not within expected range"
1214         );
1215 
1216         collateral = _collateral;
1217         collateralExp = _collExp;
1218 
1219         underlying = _underlying;
1220         underlyingExp = _underlyingExp;
1221         oTokenExchangeRate = Number(1, _oTokenExchangeExp);
1222 
1223         strikePrice = Number(_strikePrice, _strikeExp);
1224         strike = _strike;
1225 
1226         expiry = _expiry;
1227         COMPOUND_ORACLE = CompoundOracleInterface(_oracleAddress);
1228         optionsExchange = _optionsExchange;
1229         windowSize = _windowSize;
1230     }
1231 
1232     /*** Events ***/
1233     event VaultOpened(address payable vaultOwner);
1234     event ETHCollateralAdded(
1235         address payable vaultOwner,
1236         uint256 amount,
1237         address payer
1238     );
1239     event ERC20CollateralAdded(
1240         address payable vaultOwner,
1241         uint256 amount,
1242         address payer
1243     );
1244     event IssuedOTokens(
1245         address issuedTo,
1246         uint256 oTokensIssued,
1247         address payable vaultOwner
1248     );
1249     event Liquidate(
1250         uint256 amtCollateralToPay,
1251         address payable vaultOwner,
1252         address payable liquidator
1253     );
1254     event Exercise(
1255         uint256 amtUnderlyingToPay,
1256         uint256 amtCollateralToPay,
1257         address payable exerciser,
1258         address payable vaultExercisedFrom
1259     );
1260     event RedeemVaultBalance(
1261         uint256 amtCollateralRedeemed,
1262         uint256 amtUnderlyingRedeemed,
1263         address payable vaultOwner
1264     );
1265     event BurnOTokens(address payable vaultOwner, uint256 oTokensBurned);
1266     event RemoveCollateral(uint256 amtRemoved, address payable vaultOwner);
1267     event UpdateParameters(
1268         uint256 liquidationIncentive,
1269         uint256 liquidationFactor,
1270         uint256 transactionFee,
1271         uint256 minCollateralizationRatio,
1272         address owner
1273     );
1274     event TransferFee(address payable to, uint256 fees);
1275     event RemoveUnderlying(
1276         uint256 amountUnderlying,
1277         address payable vaultOwner
1278     );
1279 
1280     /**
1281      * @dev Throws if called Options contract is expired.
1282      */
1283     modifier notExpired() {
1284         require(!hasExpired(), "Options contract expired");
1285         _;
1286     }
1287 
1288     /**
1289      * @notice This function gets the array of vaultOwners
1290      */
1291     function getVaultOwners() public view returns (address payable[] memory) {
1292         address payable[] memory owners;
1293         uint256 index = 0;
1294         for (uint256 i = 0; i < vaultOwners.length; i++) {
1295             if (hasVault(vaultOwners[i])) {
1296                 owners[index] = vaultOwners[i];
1297                 index++;
1298             }
1299         }
1300 
1301         return owners;
1302     }
1303 
1304     /**
1305      * @notice Can only be called by owner. Used to update the fees, minminCollateralizationRatio, etc
1306      * @param _liquidationIncentive The incentive paid to liquidator. 10 is 0.01 i.e. 1% incentive.
1307      * @param _liquidationFactor Max amount that a Vault can be liquidated by. 500 is 0.5.
1308      * @param _transactionFee The fees paid to our protocol every time a execution happens. 100 is egs. 0.1 i.e. 10%.
1309      * @param _minCollateralizationRatio The minimum ratio of a Vault's collateral to insurance promised. 16 means 1.6.
1310      */
1311     function updateParameters(
1312         uint256 _liquidationIncentive,
1313         uint256 _liquidationFactor,
1314         uint256 _transactionFee,
1315         uint256 _minCollateralizationRatio
1316     ) public onlyOwner {
1317         require(
1318             _liquidationIncentive <= 200,
1319             "Can't have >20% liquidation incentive"
1320         );
1321         require(
1322             _liquidationFactor <= 1000,
1323             "Can't liquidate more than 100% of the vault"
1324         );
1325         require(_transactionFee <= 100, "Can't have transaction fee > 10%");
1326         require(
1327             _minCollateralizationRatio >= 10,
1328             "Can't have minCollateralizationRatio < 1"
1329         );
1330 
1331         liquidationIncentive.value = _liquidationIncentive;
1332         liquidationFactor.value = _liquidationFactor;
1333         transactionFee.value = _transactionFee;
1334         minCollateralizationRatio.value = _minCollateralizationRatio;
1335 
1336         emit UpdateParameters(
1337             _liquidationIncentive,
1338             _liquidationFactor,
1339             _transactionFee,
1340             _minCollateralizationRatio,
1341             owner()
1342         );
1343     }
1344 
1345     /**
1346      * @notice Can only be called by owner. Used to set the name, symbol and decimals of the contract
1347      * @param _name The name of the contract
1348      * @param _symbol The symbol of the contract
1349      */
1350     function setDetails(string memory _name, string memory _symbol)
1351         public
1352         onlyOwner
1353     {
1354         name = _name;
1355         symbol = _symbol;
1356         decimals = uint8(-1 * oTokenExchangeRate.exponent);
1357         require(
1358             decimals >= 0,
1359             "1 oToken cannot protect less than the smallest unit of the asset"
1360         );
1361     }
1362 
1363     /**
1364      * @notice Can only be called by owner. Used to take out the protocol fees from the contract.
1365      * @param _address The address to send the fee to.
1366      */
1367     function transferFee(address payable _address) public onlyOwner {
1368         uint256 fees = totalFee;
1369         totalFee = 0;
1370         transferCollateral(_address, fees);
1371 
1372         emit TransferFee(_address, fees);
1373     }
1374 
1375     /**
1376      * @notice Checks if a `owner` has already created a Vault
1377      * @param owner The address of the supposed owner
1378      * @return true or false
1379      */
1380     function hasVault(address payable owner) public view returns (bool) {
1381         return vaults[owner].owned;
1382     }
1383 
1384     /**
1385      * @notice Creates a new empty Vault and sets the owner of the vault to be the msg.sender.
1386      */
1387     function openVault() public notExpired returns (bool) {
1388         require(!hasVault(msg.sender), "Vault already created");
1389 
1390         vaults[msg.sender] = Vault(0, 0, 0, true);
1391         vaultOwners.push(msg.sender);
1392 
1393         emit VaultOpened(msg.sender);
1394         return true;
1395     }
1396 
1397     /**
1398      * @notice If the collateral type is ETH, anyone can call this function any time before
1399      * expiry to increase the amount of collateral in a Vault. Will fail if ETH is not the
1400      * collateral asset.
1401      * Remember that adding ETH collateral even if no oTokens have been created can put the owner at a
1402      * risk of losing the collateral if an exercise event happens.
1403      * Ensure that you issue and immediately sell oTokens to allow the owner to earn premiums.
1404      * (Either call the createAndSell function in the oToken contract or batch the
1405      * addERC20Collateral, issueOTokens and sell transactions and ensure they happen atomically to protect
1406      * the end user).
1407      * @param vaultOwner the index of the Vault to which collateral will be added.
1408      */
1409     function addETHCollateral(address payable vaultOwner)
1410         public
1411         payable
1412         notExpired
1413         returns (uint256)
1414     {
1415         require(isETH(collateral), "ETH is not the specified collateral type");
1416         require(hasVault(vaultOwner), "Vault does not exist");
1417 
1418         emit ETHCollateralAdded(vaultOwner, msg.value, msg.sender);
1419         return _addCollateral(vaultOwner, msg.value);
1420     }
1421 
1422     /**
1423      * @notice If the collateral type is any ERC20, anyone can call this function any time before
1424      * expiry to increase the amount of collateral in a Vault. Can only transfer in the collateral asset.
1425      * Will fail if ETH is the collateral asset.
1426      * The user has to allow the contract to handle their ERC20 tokens on his behalf before these
1427      * functions are called.
1428      * Remember that adding ERC20 collateral even if no oTokens have been created can put the owner at a
1429      * risk of losing the collateral. Ensure that you issue and immediately sell the oTokens!
1430      * (Either call the createAndSell function in the oToken contract or batch the
1431      * addERC20Collateral, issueOTokens and sell transactions and ensure they happen atomically to protect
1432      * the end user).
1433      * @param vaultOwner the index of the Vault to which collateral will be added.
1434      * @param amt the amount of collateral to be transferred in.
1435      */
1436     function addERC20Collateral(address payable vaultOwner, uint256 amt)
1437         public
1438         notExpired
1439         returns (uint256)
1440     {
1441         require(
1442             collateral.transferFrom(msg.sender, address(this), amt),
1443             "Could not transfer in collateral tokens"
1444         );
1445         require(hasVault(vaultOwner), "Vault does not exist");
1446 
1447         emit ERC20CollateralAdded(vaultOwner, amt, msg.sender);
1448         return _addCollateral(vaultOwner, amt);
1449     }
1450 
1451     /**
1452      * @notice Returns the amount of underlying to be transferred during an exercise call
1453      */
1454     function underlyingRequiredToExercise(uint256 oTokensToExercise)
1455         public
1456         view
1457         returns (uint256)
1458     {
1459         uint64 underlyingPerOTokenExp = uint64(
1460             oTokenExchangeRate.exponent - underlyingExp
1461         );
1462         return oTokensToExercise.mul(10**underlyingPerOTokenExp);
1463     }
1464 
1465     /**
1466      * @notice Returns true if exercise can be called
1467      */
1468     function isExerciseWindow() public view returns (bool) {
1469         return ((block.timestamp >= expiry.sub(windowSize)) &&
1470             (block.timestamp < expiry));
1471     }
1472 
1473     /**
1474      * @notice Returns true if the oToken contract has expired
1475      */
1476     function hasExpired() public view returns (bool) {
1477         return (block.timestamp >= expiry);
1478     }
1479 
1480     /**
1481      * @notice Called by anyone holding the oTokens and underlying during the
1482      * exercise window i.e. from `expiry - windowSize` time to `expiry` time. The caller
1483      * transfers in their oTokens and corresponding amount of underlying and gets
1484      * `strikePrice * oTokens` amount of collateral out. The collateral paid out is taken from
1485      * the each vault owner starting with the first and iterating until the oTokens to exercise
1486      * are found.
1487      * NOTE: This uses a for loop and hence could run out of gas if the array passed in is too big!
1488      * @param oTokensToExercise the number of oTokens being exercised.
1489      * @param vaultsToExerciseFrom the array of vaults to exercise from.
1490      */
1491     function exercise(
1492         uint256 oTokensToExercise,
1493         address payable[] memory vaultsToExerciseFrom
1494     ) public payable {
1495         for (uint256 i = 0; i < vaultsToExerciseFrom.length; i++) {
1496             address payable vaultOwner = vaultsToExerciseFrom[i];
1497             require(
1498                 hasVault(vaultOwner),
1499                 "Cannot exercise from a vault that doesn't exist"
1500             );
1501             Vault storage vault = vaults[vaultOwner];
1502             if (oTokensToExercise == 0) {
1503                 return;
1504             } else if (vault.oTokensIssued >= oTokensToExercise) {
1505                 _exercise(oTokensToExercise, vaultOwner);
1506                 return;
1507             } else {
1508                 oTokensToExercise = oTokensToExercise.sub(vault.oTokensIssued);
1509                 _exercise(vault.oTokensIssued, vaultOwner);
1510             }
1511         }
1512         require(
1513             oTokensToExercise == 0,
1514             "Specified vaults have insufficient collateral"
1515         );
1516     }
1517 
1518     /**
1519      * @notice This function allows the vault owner to remove their share of underlying after an exercise
1520      */
1521     function removeUnderlying() public {
1522         require(hasVault(msg.sender), "Vault does not exist");
1523         Vault storage vault = vaults[msg.sender];
1524 
1525         require(vault.underlying > 0, "No underlying balance");
1526 
1527         uint256 underlyingToTransfer = vault.underlying;
1528         vault.underlying = 0;
1529 
1530         transferUnderlying(msg.sender, underlyingToTransfer);
1531         emit RemoveUnderlying(underlyingToTransfer, msg.sender);
1532 
1533     }
1534 
1535     /**
1536      * @notice This function is called to issue the option tokens. Remember that issuing oTokens even if they
1537      * haven't been sold can put the owner at a risk of not making premiums on the oTokens. Ensure that you
1538      * issue and immidiately sell the oTokens! (Either call the createAndSell function in the oToken contract
1539      * of batch the issueOTokens transaction with a sell transaction and ensure it happens atomically).
1540      * @dev The owner of a Vault should only be able to have a max of
1541      * repo.collateral * collateralToStrike / (minminCollateralizationRatio * strikePrice) tokens issued.
1542      * @param oTokensToIssue The number of o tokens to issue
1543      * @param receiver The address to send the oTokens to
1544      */
1545     function issueOTokens(uint256 oTokensToIssue, address receiver)
1546         public
1547         notExpired
1548     {
1549         //check that we're properly collateralized to mint this number, then call _mint(address account, uint256 amount)
1550         require(hasVault(msg.sender), "Vault does not exist");
1551 
1552         Vault storage vault = vaults[msg.sender];
1553 
1554         // checks that the vault is sufficiently collateralized
1555         uint256 newOTokensBalance = vault.oTokensIssued.add(oTokensToIssue);
1556         require(isSafe(vault.collateral, newOTokensBalance), "unsafe to mint");
1557 
1558         // issue the oTokens
1559         vault.oTokensIssued = newOTokensBalance;
1560         _mint(receiver, oTokensToIssue);
1561 
1562         emit IssuedOTokens(receiver, oTokensToIssue, msg.sender);
1563         return;
1564     }
1565 
1566     /**
1567      * @notice Returns the vault for a given address
1568      * @param vaultOwner the owner of the Vault to return
1569      */
1570     function getVault(address payable vaultOwner)
1571         public
1572         view
1573         returns (uint256, uint256, uint256, bool)
1574     {
1575         Vault storage vault = vaults[vaultOwner];
1576         return (
1577             vault.collateral,
1578             vault.oTokensIssued,
1579             vault.underlying,
1580             vault.owned
1581         );
1582     }
1583 
1584     /**
1585      * @notice Returns true if the given ERC20 is ETH.
1586      * @param _ierc20 the ERC20 asset.
1587      */
1588     function isETH(IERC20 _ierc20) public pure returns (bool) {
1589         return _ierc20 == IERC20(0);
1590     }
1591 
1592     /**
1593      * @notice allows the owner to burn their oTokens to increase the collateralization ratio of
1594      * their vault.
1595      * @param amtToBurn number of oTokens to burn
1596      * @dev only want to call this function before expiry. After expiry, no benefit to calling it.
1597      */
1598     function burnOTokens(uint256 amtToBurn) public notExpired {
1599         require(hasVault(msg.sender), "Vault does not exist");
1600 
1601         Vault storage vault = vaults[msg.sender];
1602 
1603         vault.oTokensIssued = vault.oTokensIssued.sub(amtToBurn);
1604         _burn(msg.sender, amtToBurn);
1605 
1606         emit BurnOTokens(msg.sender, amtToBurn);
1607     }
1608 
1609     /**
1610      * @notice allows the owner to remove excess collateral from the vault before expiry. Removing collateral lowers
1611      * the collateralization ratio of the vault.
1612      * @param amtToRemove Amount of collateral to remove in 10^-18.
1613      */
1614     function removeCollateral(uint256 amtToRemove) public notExpired {
1615         require(amtToRemove > 0, "Cannot remove 0 collateral");
1616         require(hasVault(msg.sender), "Vault does not exist");
1617 
1618         Vault storage vault = vaults[msg.sender];
1619         require(
1620             amtToRemove <= getCollateral(msg.sender),
1621             "Can't remove more collateral than owned"
1622         );
1623 
1624         // check that vault will remain safe after removing collateral
1625         uint256 newCollateralBalance = vault.collateral.sub(amtToRemove);
1626 
1627         require(
1628             isSafe(newCollateralBalance, vault.oTokensIssued),
1629             "Vault is unsafe"
1630         );
1631 
1632         // remove the collateral
1633         vault.collateral = newCollateralBalance;
1634         transferCollateral(msg.sender, amtToRemove);
1635 
1636         emit RemoveCollateral(amtToRemove, msg.sender);
1637     }
1638 
1639     /**
1640      * @notice after expiry, each vault holder can get back their proportional share of collateral
1641      * from vaults that they own.
1642      * @dev The owner gets all of their collateral back if no exercise event took their collateral.
1643      */
1644     function redeemVaultBalance() public {
1645         require(hasExpired(), "Can't collect collateral until expiry");
1646         require(hasVault(msg.sender), "Vault does not exist");
1647 
1648         // pay out owner their share
1649         Vault storage vault = vaults[msg.sender];
1650 
1651         // To deal with lower precision
1652         uint256 collateralToTransfer = vault.collateral;
1653         uint256 underlyingToTransfer = vault.underlying;
1654 
1655         vault.collateral = 0;
1656         vault.oTokensIssued = 0;
1657         vault.underlying = 0;
1658 
1659         transferCollateral(msg.sender, collateralToTransfer);
1660         transferUnderlying(msg.sender, underlyingToTransfer);
1661 
1662         emit RedeemVaultBalance(
1663             collateralToTransfer,
1664             underlyingToTransfer,
1665             msg.sender
1666         );
1667     }
1668 
1669     /**
1670      * This function returns the maximum amount of collateral liquidatable if the given vault is unsafe
1671      * @param vaultOwner The index of the vault to be liquidated
1672      */
1673     function maxOTokensLiquidatable(address payable vaultOwner)
1674         public
1675         view
1676         returns (uint256)
1677     {
1678         if (isUnsafe(vaultOwner)) {
1679             Vault storage vault = vaults[vaultOwner];
1680             uint256 maxCollateralLiquidatable = vault
1681                 .collateral
1682                 .mul(liquidationFactor.value)
1683                 .div(10**uint256(-liquidationFactor.exponent));
1684 
1685             uint256 one = 10**uint256(-liquidationIncentive.exponent);
1686             Number memory liqIncentive = Number(
1687                 liquidationIncentive.value.add(one),
1688                 liquidationIncentive.exponent
1689             );
1690             return calculateOTokens(maxCollateralLiquidatable, liqIncentive);
1691         } else {
1692             return 0;
1693         }
1694     }
1695 
1696     /**
1697      * @notice This function can be called by anyone who notices a vault is undercollateralized.
1698      * The caller gets a reward for reducing the amount of oTokens in circulation.
1699      * @dev Liquidator comes with _oTokens. They get _oTokens * strikePrice * (incentive + fee)
1700      * amount of collateral out. They can liquidate a max of liquidationFactor * vault.collateral out
1701      * in one function call i.e. partial liquidations.
1702      * @param vaultOwner The index of the vault to be liquidated
1703      * @param oTokensToLiquidate The number of oTokens being taken out of circulation
1704      */
1705     function liquidate(address payable vaultOwner, uint256 oTokensToLiquidate)
1706         public
1707         notExpired
1708     {
1709         require(hasVault(vaultOwner), "Vault does not exist");
1710 
1711         Vault storage vault = vaults[vaultOwner];
1712 
1713         // cannot liquidate a safe vault.
1714         require(isUnsafe(vaultOwner), "Vault is safe");
1715 
1716         // Owner can't liquidate themselves
1717         require(msg.sender != vaultOwner, "Owner can't liquidate themselves");
1718 
1719         uint256 amtCollateral = calculateCollateralToPay(
1720             oTokensToLiquidate,
1721             Number(1, 0)
1722         );
1723         uint256 amtIncentive = calculateCollateralToPay(
1724             oTokensToLiquidate,
1725             liquidationIncentive
1726         );
1727         uint256 amtCollateralToPay = amtCollateral.add(amtIncentive);
1728 
1729         // calculate the maximum amount of collateral that can be liquidated
1730         uint256 maxCollateralLiquidatable = vault.collateral.mul(
1731             liquidationFactor.value
1732         );
1733 
1734         if (liquidationFactor.exponent > 0) {
1735             maxCollateralLiquidatable = maxCollateralLiquidatable.mul(
1736                 10**uint256(liquidationFactor.exponent)
1737             );
1738         } else {
1739             maxCollateralLiquidatable = maxCollateralLiquidatable.div(
1740                 10**uint256(-1 * liquidationFactor.exponent)
1741             );
1742         }
1743 
1744         require(
1745             amtCollateralToPay <= maxCollateralLiquidatable,
1746             "Can only liquidate liquidation factor at any given time"
1747         );
1748 
1749         // deduct the collateral and oTokensIssued
1750         vault.collateral = vault.collateral.sub(amtCollateralToPay);
1751         vault.oTokensIssued = vault.oTokensIssued.sub(oTokensToLiquidate);
1752 
1753         // transfer the collateral and burn the _oTokens
1754         _burn(msg.sender, oTokensToLiquidate);
1755         transferCollateral(msg.sender, amtCollateralToPay);
1756 
1757         emit Liquidate(amtCollateralToPay, vaultOwner, msg.sender);
1758     }
1759 
1760     /**
1761      * @notice checks if a vault is unsafe. If so, it can be liquidated
1762      * @param vaultOwner The number of the vault to check
1763      * @return true or false
1764      */
1765     function isUnsafe(address payable vaultOwner) public view returns (bool) {
1766         bool stillUnsafe = !isSafe(
1767             getCollateral(vaultOwner),
1768             getOTokensIssued(vaultOwner)
1769         );
1770         return stillUnsafe;
1771     }
1772 
1773     /**
1774      * @notice This function returns if an -30 <= exponent <= 30
1775      */
1776     function isWithinExponentRange(int32 val) internal pure returns (bool) {
1777         return ((val <= 30) && (val >= -30));
1778     }
1779 
1780     /**
1781      * @notice This function calculates and returns the amount of collateral in the vault
1782     */
1783     function getCollateral(address payable vaultOwner)
1784         internal
1785         view
1786         returns (uint256)
1787     {
1788         Vault storage vault = vaults[vaultOwner];
1789         return vault.collateral;
1790     }
1791 
1792     /**
1793      * @notice This function calculates and returns the amount of puts issued by the Vault
1794     */
1795     function getOTokensIssued(address payable vaultOwner)
1796         internal
1797         view
1798         returns (uint256)
1799     {
1800         Vault storage vault = vaults[vaultOwner];
1801         return vault.oTokensIssued;
1802     }
1803 
1804     /**
1805      * @notice Called by anyone holding the oTokens and underlying during the
1806      * exercise window i.e. from `expiry - windowSize` time to `expiry` time. The caller
1807      * transfers in their oTokens and corresponding amount of underlying and gets
1808      * `strikePrice * oTokens` amount of collateral out. The collateral paid out is taken from
1809      * the specified vault holder. At the end of the expiry window, the vault holder can redeem their balance
1810      * of collateral. The vault owner can withdraw their underlying at any time.
1811      * The user has to allow the contract to handle their oTokens and underlying on his behalf before these functions are called.
1812      * @param oTokensToExercise the number of oTokens being exercised.
1813      * @param vaultToExerciseFrom the address of the vaultOwner to take collateral from.
1814      * @dev oTokenExchangeRate is the number of underlying tokens that 1 oToken protects.
1815      */
1816     function _exercise(
1817         uint256 oTokensToExercise,
1818         address payable vaultToExerciseFrom
1819     ) internal {
1820         // 1. before exercise window: revert
1821         require(
1822             isExerciseWindow(),
1823             "Can't exercise outside of the exercise window"
1824         );
1825 
1826         require(hasVault(vaultToExerciseFrom), "Vault does not exist");
1827 
1828         Vault storage vault = vaults[vaultToExerciseFrom];
1829         require(oTokensToExercise > 0, "Can't exercise 0 oTokens");
1830         // Check correct amount of oTokens passed in)
1831         require(
1832             oTokensToExercise <= vault.oTokensIssued,
1833             "Can't exercise more oTokens than the owner has"
1834         );
1835         // Ensure person calling has enough oTokens
1836         require(
1837             balanceOf(msg.sender) >= oTokensToExercise,
1838             "Not enough oTokens"
1839         );
1840 
1841         // 1. Check sufficient underlying
1842         // 1.1 update underlying balances
1843         uint256 amtUnderlyingToPay = underlyingRequiredToExercise(
1844             oTokensToExercise
1845         );
1846         vault.underlying = vault.underlying.add(amtUnderlyingToPay);
1847 
1848         // 2. Calculate Collateral to pay
1849         // 2.1 Payout enough collateral to get (strikePrice * oTokens) amount of collateral
1850         uint256 amtCollateralToPay = calculateCollateralToPay(
1851             oTokensToExercise,
1852             Number(1, 0)
1853         );
1854 
1855         // 2.2 Take a small fee on every exercise
1856         uint256 amtFee = calculateCollateralToPay(
1857             oTokensToExercise,
1858             transactionFee
1859         );
1860         totalFee = totalFee.add(amtFee);
1861 
1862         uint256 totalCollateralToPay = amtCollateralToPay.add(amtFee);
1863         require(
1864             totalCollateralToPay <= vault.collateral,
1865             "Vault underwater, can't exercise"
1866         );
1867 
1868         // 3. Update collateral + oToken balances
1869         vault.collateral = vault.collateral.sub(totalCollateralToPay);
1870         vault.oTokensIssued = vault.oTokensIssued.sub(oTokensToExercise);
1871 
1872         // 4. Transfer in underlying, burn oTokens + pay out collateral
1873         // 4.1 Transfer in underlying
1874         if (isETH(underlying)) {
1875             require(msg.value == amtUnderlyingToPay, "Incorrect msg.value");
1876         } else {
1877             require(
1878                 underlying.transferFrom(
1879                     msg.sender,
1880                     address(this),
1881                     amtUnderlyingToPay
1882                 ),
1883                 "Could not transfer in tokens"
1884             );
1885         }
1886         // 4.2 burn oTokens
1887         _burn(msg.sender, oTokensToExercise);
1888 
1889         // 4.3 Pay out collateral
1890         transferCollateral(msg.sender, amtCollateralToPay);
1891 
1892         emit Exercise(
1893             amtUnderlyingToPay,
1894             amtCollateralToPay,
1895             msg.sender,
1896             vaultToExerciseFrom
1897         );
1898 
1899     }
1900 
1901     /**
1902      * @notice adds `_amt` collateral to `vaultOwner` and returns the new balance of the vault
1903      * @param vaultOwner the index of the vault
1904      * @param amt the amount of collateral to add
1905      */
1906     function _addCollateral(address payable vaultOwner, uint256 amt)
1907         internal
1908         notExpired
1909         returns (uint256)
1910     {
1911         Vault storage vault = vaults[vaultOwner];
1912         vault.collateral = vault.collateral.add(amt);
1913 
1914         return vault.collateral;
1915     }
1916 
1917     /**
1918      * @notice checks if a hypothetical vault is safe with the given collateralAmt and oTokensIssued
1919      * @param collateralAmt The amount of collateral the hypothetical vault has
1920      * @param oTokensIssued The amount of oTokens generated by the hypothetical vault
1921      * @return true or false
1922      */
1923     function isSafe(uint256 collateralAmt, uint256 oTokensIssued)
1924         internal
1925         view
1926         returns (bool)
1927     {
1928         // get price from Oracle
1929         uint256 collateralToEthPrice = getPrice(address(collateral));
1930         uint256 strikeToEthPrice = getPrice(address(strike));
1931 
1932         // check `oTokensIssued * minCollateralizationRatio * strikePrice <= collAmt * collateralToStrikePrice`
1933         uint256 leftSideVal = oTokensIssued
1934             .mul(minCollateralizationRatio.value)
1935             .mul(strikePrice.value);
1936         int32 leftSideExp = minCollateralizationRatio.exponent +
1937             strikePrice.exponent;
1938 
1939         uint256 rightSideVal = (collateralAmt.mul(collateralToEthPrice)).div(
1940             strikeToEthPrice
1941         );
1942         int32 rightSideExp = collateralExp;
1943 
1944         uint256 exp = 0;
1945         bool stillSafe = false;
1946 
1947         if (rightSideExp < leftSideExp) {
1948             exp = uint256(leftSideExp - rightSideExp);
1949             stillSafe = leftSideVal.mul(10**exp) <= rightSideVal;
1950         } else {
1951             exp = uint256(rightSideExp - leftSideExp);
1952             stillSafe = leftSideVal <= rightSideVal.mul(10**exp);
1953         }
1954 
1955         return stillSafe;
1956     }
1957 
1958     /**
1959      * This function returns the maximum amount of oTokens that can safely be issued against the specified amount of collateral.
1960      * @param collateralAmt The amount of collateral against which oTokens will be issued.
1961      */
1962     function maxOTokensIssuable(uint256 collateralAmt)
1963         public
1964         view
1965         returns (uint256)
1966     {
1967         return calculateOTokens(collateralAmt, minCollateralizationRatio);
1968 
1969     }
1970 
1971     /**
1972      * @notice This function is used to calculate the amount of tokens that can be issued.
1973      * @dev The amount of oTokens is determined by:
1974      * oTokensIssued  <= collateralAmt * collateralToStrikePrice / (proportion * strikePrice)
1975      * @param collateralAmt The amount of collateral
1976      * @param proportion The proportion of the collateral to pay out. If 100% of collateral
1977      * should be paid out, pass in Number(1, 0). The proportion might be less than 100% if
1978      * you are calculating fees.
1979      */
1980     function calculateOTokens(uint256 collateralAmt, Number memory proportion)
1981         internal
1982         view
1983         returns (uint256)
1984     {
1985         uint256 collateralToEthPrice = getPrice(address(collateral));
1986         uint256 strikeToEthPrice = getPrice(address(strike));
1987 
1988         // oTokensIssued  <= collAmt * collateralToStrikePrice / (proportion * strikePrice)
1989         uint256 denomVal = proportion.value.mul(strikePrice.value);
1990         int32 denomExp = proportion.exponent + strikePrice.exponent;
1991 
1992         uint256 numeratorVal = (collateralAmt.mul(collateralToEthPrice)).div(
1993             strikeToEthPrice
1994         );
1995         int32 numeratorExp = collateralExp;
1996 
1997         uint256 exp = 0;
1998         uint256 numOptions = 0;
1999 
2000         if (numeratorExp < denomExp) {
2001             exp = uint256(denomExp - numeratorExp);
2002             numOptions = numeratorVal.div(denomVal.mul(10**exp));
2003         } else {
2004             exp = uint256(numeratorExp - denomExp);
2005             numOptions = numeratorVal.mul(10**exp).div(denomVal);
2006         }
2007 
2008         return numOptions;
2009     }
2010 
2011     /**
2012      * @notice This function calculates the amount of collateral to be paid out.
2013      * @dev The amount of collateral to paid out is determined by:
2014      * (proportion * strikePrice * strikeToCollateralPrice * oTokens) amount of collateral.
2015      * @param _oTokens The number of oTokens.
2016      * @param proportion The proportion of the collateral to pay out. If 100% of collateral
2017      * should be paid out, pass in Number(1, 0). The proportion might be less than 100% if
2018      * you are calculating fees.
2019      */
2020     function calculateCollateralToPay(
2021         uint256 _oTokens,
2022         Number memory proportion
2023     ) internal view returns (uint256) {
2024         // Get price from oracle
2025         uint256 collateralToEthPrice = getPrice(address(collateral));
2026         uint256 strikeToEthPrice = getPrice(address(strike));
2027 
2028         // calculate how much should be paid out
2029         uint256 amtCollateralToPayInEthNum = _oTokens
2030             .mul(strikePrice.value)
2031             .mul(proportion.value)
2032             .mul(strikeToEthPrice);
2033         int32 amtCollateralToPayExp = strikePrice.exponent +
2034             proportion.exponent -
2035             collateralExp;
2036         uint256 amtCollateralToPay = 0;
2037         if (amtCollateralToPayExp > 0) {
2038             uint32 exp = uint32(amtCollateralToPayExp);
2039             amtCollateralToPay = amtCollateralToPayInEthNum.mul(10**exp).div(
2040                 collateralToEthPrice
2041             );
2042         } else {
2043             uint32 exp = uint32(-1 * amtCollateralToPayExp);
2044             amtCollateralToPay = (amtCollateralToPayInEthNum.div(10**exp)).div(
2045                 collateralToEthPrice
2046             );
2047         }
2048 
2049         return amtCollateralToPay;
2050 
2051     }
2052 
2053     /**
2054      * @notice This function transfers `amt` collateral to `_addr`
2055      * @param _addr The address to send the collateral to
2056      * @param _amt The amount of the collateral to pay out.
2057      */
2058     function transferCollateral(address payable _addr, uint256 _amt) internal {
2059         if (isETH(collateral)) {
2060             _addr.transfer(_amt);
2061         } else {
2062             collateral.transfer(_addr, _amt);
2063         }
2064     }
2065 
2066     /**
2067      * @notice This function transfers `amt` underlying to `_addr`
2068      * @param _addr The address to send the underlying to
2069      * @param _amt The amount of the underlying to pay out.
2070      */
2071     function transferUnderlying(address payable _addr, uint256 _amt) internal {
2072         if (isETH(underlying)) {
2073             _addr.transfer(_amt);
2074         } else {
2075             underlying.transfer(_addr, _amt);
2076         }
2077     }
2078 
2079     /**
2080      * @notice This function gets the price ETH (wei) to asset price.
2081      * @param asset The address of the asset to get the price of
2082      */
2083     function getPrice(address asset) internal view returns (uint256) {
2084         if (address(collateral) == address(strike)) {
2085             return 1;
2086         } else if (asset == address(0)) {
2087             return (10**18);
2088         } else {
2089             return COMPOUND_ORACLE.getPrice(asset);
2090         }
2091     }
2092 }
2093 
2094 // File: contracts/oToken.sol
2095 
2096 pragma solidity 0.5.10;
2097 
2098 
2099 /**
2100  * @title Opyn's Options Contract
2101  * @author Opyn
2102  */
2103 
2104 contract oToken is OptionsContract {
2105     /**
2106     * @param _collateral The collateral asset
2107     * @param _collExp The precision of the collateral (-18 if ETH)
2108     * @param _underlying The asset that is being protected
2109     * @param _underlyingExp The precision of the underlying asset
2110     * @param _oTokenExchangeExp The precision of the `amount of underlying` that 1 oToken protects
2111     * @param _strikePrice The amount of strike asset that will be paid out
2112     * @param _strikeExp The precision of the strike asset (-18 if ETH)
2113     * @param _strike The asset in which the insurance is calculated
2114     * @param _expiry The time at which the insurance expires
2115     * @param _optionsExchange The contract which interfaces with the exchange + oracle
2116     * @param _oracleAddress The address of the oracle
2117     * @param _windowSize UNIX time. Exercise window is from `expiry - _windowSize` to `expiry`.
2118     */
2119     constructor(
2120         IERC20 _collateral,
2121         int32 _collExp,
2122         IERC20 _underlying,
2123         int32 _underlyingExp,
2124         int32 _oTokenExchangeExp,
2125         uint256 _strikePrice,
2126         int32 _strikeExp,
2127         IERC20 _strike,
2128         uint256 _expiry,
2129         OptionsExchange _optionsExchange,
2130         address _oracleAddress,
2131         uint256 _windowSize
2132     )
2133         public
2134         OptionsContract(
2135             _collateral,
2136             _collExp,
2137             _underlying,
2138             _underlyingExp,
2139             _oTokenExchangeExp,
2140             _strikePrice,
2141             _strikeExp,
2142             _strike,
2143             _expiry,
2144             _optionsExchange,
2145             _oracleAddress,
2146             _windowSize
2147         )
2148     {}
2149 
2150     /**
2151      * @notice opens a Vault, adds ETH collateral, and mints new oTokens in one step
2152      * Remember that creating oTokens can put the owner at a risk of losing the collateral
2153      * if an exercise event happens.
2154      * The sell function provides the owner a chance to earn premiums.
2155      * Ensure that you create and immediately sell oTokens atmoically.
2156      * @param amtToCreate number of oTokens to create
2157      * @param receiver address to send the Options to
2158      */
2159     function createETHCollateralOption(uint256 amtToCreate, address receiver)
2160         external
2161         payable
2162     {
2163         openVault();
2164         addETHCollateralOption(amtToCreate, receiver);
2165     }
2166 
2167     /**
2168      * @notice adds ETH collateral, and mints new oTokens in one step to an existing Vault
2169      * Remember that creating oTokens can put the owner at a risk of losing the collateral
2170      * if an exercise event happens.
2171      * The sell function provides the owner a chance to earn premiums.
2172      * Ensure that you create and immediately sell oTokens atmoically.
2173      * @param amtToCreate number of oTokens to create
2174      * @param receiver address to send the Options to
2175      */
2176     function addETHCollateralOption(uint256 amtToCreate, address receiver)
2177         public
2178         payable
2179     {
2180         addETHCollateral(msg.sender);
2181         issueOTokens(amtToCreate, receiver);
2182     }
2183 
2184     /**
2185      * @notice opens a Vault, adds ETH collateral, mints new oTokens and sell in one step
2186      * @param amtToCreate number of oTokens to create
2187      * @param receiver address to receive the premiums
2188      */
2189     function createAndSellETHCollateralOption(
2190         uint256 amtToCreate,
2191         address payable receiver
2192     ) external payable {
2193         openVault();
2194         addETHCollateralOption(amtToCreate, address(this));
2195         this.approve(address(optionsExchange), amtToCreate);
2196         optionsExchange.sellOTokens(
2197             receiver,
2198             address(this),
2199             address(0),
2200             amtToCreate
2201         );
2202     }
2203 
2204     /**
2205      * @notice adds ETH collateral to an existing Vault, and mints new oTokens and sells the oTokens in one step
2206      * @param amtToCreate number of oTokens to create
2207      * @param receiver address to send the Options to
2208      */
2209     function addAndSellETHCollateralOption(
2210         uint256 amtToCreate,
2211         address payable receiver
2212     ) public payable {
2213         addETHCollateral(msg.sender);
2214         issueOTokens(amtToCreate, address(this));
2215         this.approve(address(optionsExchange), amtToCreate);
2216         optionsExchange.sellOTokens(
2217             receiver,
2218             address(this),
2219             address(0),
2220             amtToCreate
2221         );
2222     }
2223 
2224     /**
2225      * @notice opens a Vault, adds ERC20 collateral, and mints new oTokens in one step
2226      * Remember that creating oTokens can put the owner at a risk of losing the collateral
2227      * if an exercise event happens.
2228      * The sell function provides the owner a chance to earn premiums.
2229      * Ensure that you create and immediately sell oTokens atmoically.
2230      * @param amtToCreate number of oTokens to create
2231      * @param amtCollateral amount of collateral added
2232      * @param receiver address to send the Options to
2233      */
2234     function createERC20CollateralOption(
2235         uint256 amtToCreate,
2236         uint256 amtCollateral,
2237         address receiver
2238     ) external {
2239         openVault();
2240         addERC20CollateralOption(amtToCreate, amtCollateral, receiver);
2241     }
2242 
2243     /**
2244      * @notice adds ERC20 collateral, and mints new oTokens in one step
2245      * Remember that creating oTokens can put the owner at a risk of losing the collateral
2246      * if an exercise event happens.
2247      * The sell function provides the owner a chance to earn premiums.
2248      * Ensure that you create and immediately sell oTokens atmoically.
2249      * @param amtToCreate number of oTokens to create
2250      * @param amtCollateral amount of collateral added
2251      * @param receiver address to send the Options to
2252      */
2253     function addERC20CollateralOption(
2254         uint256 amtToCreate,
2255         uint256 amtCollateral,
2256         address receiver
2257     ) public {
2258         addERC20Collateral(msg.sender, amtCollateral);
2259         issueOTokens(amtToCreate, receiver);
2260     }
2261 
2262     /**
2263      * @notice opens a Vault, adds ERC20 collateral, mints new oTokens and sells the oTokens in one step
2264      * @param amtToCreate number of oTokens to create
2265      * @param amtCollateral amount of collateral added
2266      * @param receiver address to send the Options to
2267      */
2268     function createAndSellERC20CollateralOption(
2269         uint256 amtToCreate,
2270         uint256 amtCollateral,
2271         address payable receiver
2272     ) external {
2273         openVault();
2274         addERC20CollateralOption(amtToCreate, amtCollateral, address(this));
2275         this.approve(address(optionsExchange), amtToCreate);
2276         optionsExchange.sellOTokens(
2277             receiver,
2278             address(this),
2279             address(0),
2280             amtToCreate
2281         );
2282     }
2283 
2284     /**
2285      * @notice adds ERC20 collateral, mints new oTokens and sells the oTokens in one step
2286      * @param amtToCreate number of oTokens to create
2287      * @param amtCollateral amount of collateral added
2288      * @param receiver address to send the Options to
2289      */
2290     function addAndSellERC20CollateralOption(
2291         uint256 amtToCreate,
2292         uint256 amtCollateral,
2293         address payable receiver
2294     ) public {
2295         addERC20Collateral(msg.sender, amtCollateral);
2296         issueOTokens(amtToCreate, address(this));
2297         this.approve(address(optionsExchange), amtToCreate);
2298         optionsExchange.sellOTokens(
2299             receiver,
2300             address(this),
2301             address(0),
2302             amtToCreate
2303         );
2304     }
2305 }