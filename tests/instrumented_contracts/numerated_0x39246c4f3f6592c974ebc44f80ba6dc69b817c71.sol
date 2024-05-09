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