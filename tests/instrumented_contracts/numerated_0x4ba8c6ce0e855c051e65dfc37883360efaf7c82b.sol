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
679         uint256 oTokensToSell
680     );
681     event BuyOTokens(
682         address buyer,
683         address payable receiver,
684         address oTokenAddress,
685         address paymentTokenAddress,
686         uint256 oTokensToBuy,
687         uint256 premiumPaid
688     );
689 
690     /**
691     * @notice This function sells oTokens on Uniswap and sends back payoutTokens to the receiver
692     * @param receiver The address to send the payout tokens back to
693     * @param oTokenAddress The address of the oToken to sell
694     * @param payoutTokenAddress The address of the token to receive the premiums in
695     * @param oTokensToSell The number of oTokens to sell
696     */
697     function sellOTokens(
698         address payable receiver,
699         address oTokenAddress,
700         address payoutTokenAddress,
701         uint256 oTokensToSell
702     ) public {
703         // @note: first need to bootstrap the uniswap exchange to get the address.
704         IERC20 oToken = IERC20(oTokenAddress);
705         IERC20 payoutToken = IERC20(payoutTokenAddress);
706         oToken.transferFrom(msg.sender, address(this), oTokensToSell);
707         uniswapSellOToken(oToken, payoutToken, oTokensToSell, receiver);
708 
709         emit SellOTokens(
710             msg.sender,
711             receiver,
712             oTokenAddress,
713             payoutTokenAddress,
714             oTokensToSell
715         );
716     }
717 
718     /**
719     * @notice This function buys oTokens on Uniswap and using paymentTokens from the receiver
720     * @param receiver The address to send the oTokens back to
721     * @param oTokenAddress The address of the oToken to buy
722     * @param paymentTokenAddress The address of the token to pay the premiums in
723     * @param oTokensToBuy The number of oTokens to buy
724     */
725     function buyOTokens(
726         address payable receiver,
727         address oTokenAddress,
728         address paymentTokenAddress,
729         uint256 oTokensToBuy
730     ) public payable {
731         IERC20 oToken = IERC20(oTokenAddress);
732         IERC20 paymentToken = IERC20(paymentTokenAddress);
733         uniswapBuyOToken(paymentToken, oToken, oTokensToBuy, receiver);
734     }
735 
736     /**
737     * @notice This function calculates the amount of premiums that the seller
738     * will receive if they sold oTokens on Uniswap
739     * @param oTokenAddress The address of the oToken to sell
740     * @param payoutTokenAddress The address of the token to receive the premiums in
741     * @param oTokensToSell The number of oTokens to sell
742     */
743     function premiumReceived(
744         address oTokenAddress,
745         address payoutTokenAddress,
746         uint256 oTokensToSell
747     ) public view returns (uint256) {
748         // get the amount of ETH that will be paid out if oTokensToSell is sold.
749         UniswapExchangeInterface oTokenExchange = getExchange(oTokenAddress);
750         uint256 ethReceived = oTokenExchange.getTokenToEthInputPrice(
751             oTokensToSell
752         );
753 
754         if (!isETH(IERC20(payoutTokenAddress))) {
755             // get the amount of payout tokens that will be received if the ethRecieved is sold.
756             UniswapExchangeInterface payoutExchange = getExchange(
757                 payoutTokenAddress
758             );
759             return payoutExchange.getEthToTokenInputPrice(ethReceived);
760         }
761         return ethReceived;
762 
763     }
764 
765     /**
766     * @notice This function calculates the premiums to be paid if a buyer wants to
767     * buy oTokens on Uniswap
768     * @param oTokenAddress The address of the oToken to buy
769     * @param paymentTokenAddress The address of the token to pay the premiums in
770     * @param oTokensToBuy The number of oTokens to buy
771     */
772     function premiumToPay(
773         address oTokenAddress,
774         address paymentTokenAddress,
775         uint256 oTokensToBuy
776     ) public view returns (uint256) {
777         // get the amount of ETH that needs to be paid for oTokensToBuy.
778         UniswapExchangeInterface oTokenExchange = getExchange(oTokenAddress);
779         uint256 ethToPay = oTokenExchange.getEthToTokenOutputPrice(
780             oTokensToBuy
781         );
782 
783         if (!isETH(IERC20(paymentTokenAddress))) {
784             // get the amount of paymentTokens that needs to be paid to get the desired ethToPay.
785             UniswapExchangeInterface paymentTokenExchange = getExchange(
786                 paymentTokenAddress
787             );
788             return paymentTokenExchange.getTokenToEthOutputPrice(ethToPay);
789         }
790 
791         return ethToPay;
792     }
793 
794     function uniswapSellOToken(
795         IERC20 oToken,
796         IERC20 payoutToken,
797         uint256 _amt,
798         address payable _transferTo
799     ) internal returns (uint256) {
800         require(!isETH(oToken), "Can only sell oTokens");
801         UniswapExchangeInterface exchange = getExchange(address(oToken));
802 
803         if (isETH(payoutToken)) {
804             //Token to ETH
805             oToken.approve(address(exchange), _amt);
806             return
807                 exchange.tokenToEthTransferInput(
808                     _amt,
809                     1,
810                     LARGE_BLOCK_SIZE,
811                     _transferTo
812                 );
813         } else {
814             //Token to Token
815             oToken.approve(address(exchange), _amt);
816             return
817                 exchange.tokenToTokenTransferInput(
818                     _amt,
819                     1,
820                     1,
821                     LARGE_BLOCK_SIZE,
822                     _transferTo,
823                     address(payoutToken)
824                 );
825         }
826     }
827 
828     function uniswapBuyOToken(
829         IERC20 paymentToken,
830         IERC20 oToken,
831         uint256 _amt,
832         address payable _transferTo
833     ) public returns (uint256) {
834         require(!isETH(oToken), "Can only buy oTokens");
835 
836         if (!isETH(paymentToken)) {
837             UniswapExchangeInterface exchange = getExchange(
838                 address(paymentToken)
839             );
840 
841             uint256 paymentTokensToTransfer = premiumToPay(
842                 address(oToken),
843                 address(paymentToken),
844                 _amt
845             );
846             paymentToken.transferFrom(
847                 msg.sender,
848                 address(this),
849                 paymentTokensToTransfer
850             );
851 
852             // Token to Token
853             paymentToken.approve(address(exchange), LARGE_APPROVAL_NUMBER);
854 
855             emit BuyOTokens(
856                 msg.sender,
857                 _transferTo,
858                 address(oToken),
859                 address(paymentToken),
860                 _amt,
861                 paymentTokensToTransfer
862             );
863 
864             return
865                 exchange.tokenToTokenTransferInput(
866                     paymentTokensToTransfer,
867                     1,
868                     1,
869                     LARGE_BLOCK_SIZE,
870                     _transferTo,
871                     address(oToken)
872                 );
873         } else {
874             // ETH to Token
875             UniswapExchangeInterface exchange = UniswapExchangeInterface(
876                 UNISWAP_FACTORY.getExchange(address(oToken))
877             );
878 
879             uint256 ethToTransfer = exchange.getEthToTokenOutputPrice(_amt);
880 
881             emit BuyOTokens(
882                 msg.sender,
883                 _transferTo,
884                 address(oToken),
885                 address(paymentToken),
886                 _amt,
887                 ethToTransfer
888             );
889 
890             return
891                 exchange.ethToTokenTransferOutput.value(ethToTransfer)(
892                     _amt,
893                     LARGE_BLOCK_SIZE,
894                     _transferTo
895                 );
896         }
897     }
898 
899     function getExchange(address _token)
900         internal
901         view
902         returns (UniswapExchangeInterface)
903     {
904         UniswapExchangeInterface exchange = UniswapExchangeInterface(
905             UNISWAP_FACTORY.getExchange(_token)
906         );
907 
908         if (address(exchange) == address(0)) {
909             revert("No payout exchange");
910         }
911 
912         return exchange;
913     }
914 
915     function isETH(IERC20 _ierc20) internal pure returns (bool) {
916         return _ierc20 == IERC20(0);
917     }
918 
919     function() external payable {
920         // to get ether from uniswap exchanges
921     }
922 
923 }
924 
925 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
926 
927 pragma solidity ^0.5.0;
928 
929 
930 /**
931  * @dev Optional functions from the ERC20 standard.
932  */
933 contract ERC20Detailed is IERC20 {
934     string private _name;
935     string private _symbol;
936     uint8 private _decimals;
937 
938     /**
939      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
940      * these values are immutable: they can only be set once during
941      * construction.
942      */
943     constructor (string memory name, string memory symbol, uint8 decimals) public {
944         _name = name;
945         _symbol = symbol;
946         _decimals = decimals;
947     }
948 
949     /**
950      * @dev Returns the name of the token.
951      */
952     function name() public view returns (string memory) {
953         return _name;
954     }
955 
956     /**
957      * @dev Returns the symbol of the token, usually a shorter version of the
958      * name.
959      */
960     function symbol() public view returns (string memory) {
961         return _symbol;
962     }
963 
964     /**
965      * @dev Returns the number of decimals used to get its user representation.
966      * For example, if `decimals` equals `2`, a balance of `505` tokens should
967      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
968      *
969      * Tokens usually opt for a value of 18, imitating the relationship between
970      * Ether and Wei.
971      *
972      * NOTE: This information is only used for _display_ purposes: it in
973      * no way affects any of the arithmetic of the contract, including
974      * {IERC20-balanceOf} and {IERC20-transfer}.
975      */
976     function decimals() public view returns (uint8) {
977         return _decimals;
978     }
979 }
980 
981 // File: @openzeppelin/contracts/ownership/Ownable.sol
982 
983 pragma solidity ^0.5.0;
984 
985 /**
986  * @dev Contract module which provides a basic access control mechanism, where
987  * there is an account (an owner) that can be granted exclusive access to
988  * specific functions.
989  *
990  * This module is used through inheritance. It will make available the modifier
991  * `onlyOwner`, which can be applied to your functions to restrict their use to
992  * the owner.
993  */
994 contract Ownable is Context {
995     address private _owner;
996 
997     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
998 
999     /**
1000      * @dev Initializes the contract setting the deployer as the initial owner.
1001      */
1002     constructor () internal {
1003         _owner = _msgSender();
1004         emit OwnershipTransferred(address(0), _owner);
1005     }
1006 
1007     /**
1008      * @dev Returns the address of the current owner.
1009      */
1010     function owner() public view returns (address) {
1011         return _owner;
1012     }
1013 
1014     /**
1015      * @dev Throws if called by any account other than the owner.
1016      */
1017     modifier onlyOwner() {
1018         require(isOwner(), "Ownable: caller is not the owner");
1019         _;
1020     }
1021 
1022     /**
1023      * @dev Returns true if the caller is the current owner.
1024      */
1025     function isOwner() public view returns (bool) {
1026         return _msgSender() == _owner;
1027     }
1028 
1029     /**
1030      * @dev Leaves the contract without owner. It will not be possible to call
1031      * `onlyOwner` functions anymore. Can only be called by the current owner.
1032      *
1033      * NOTE: Renouncing ownership will leave the contract without an owner,
1034      * thereby removing any functionality that is only available to the owner.
1035      */
1036     function renounceOwnership() public onlyOwner {
1037         emit OwnershipTransferred(_owner, address(0));
1038         _owner = address(0);
1039     }
1040 
1041     /**
1042      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1043      * Can only be called by the current owner.
1044      */
1045     function transferOwnership(address newOwner) public onlyOwner {
1046         _transferOwnership(newOwner);
1047     }
1048 
1049     /**
1050      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1051      */
1052     function _transferOwnership(address newOwner) internal {
1053         require(newOwner != address(0), "Ownable: new owner is the zero address");
1054         emit OwnershipTransferred(_owner, newOwner);
1055         _owner = newOwner;
1056     }
1057 }
1058 
1059 // File: contracts/OptionsContract.sol
1060 
1061 pragma solidity 0.5.10;
1062 
1063 
1064 
1065 
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 /**
1074  * @title Opyn's Options Contract
1075  * @author Opyn
1076  */
1077 contract OptionsContract is Ownable, ERC20 {
1078     using SafeMath for uint256;
1079 
1080     /* represents floting point numbers, where number = value * 10 ** exponent
1081     i.e 0.1 = 10 * 10 ** -3 */
1082     struct Number {
1083         uint256 value;
1084         int32 exponent;
1085     }
1086 
1087     // Keeps track of the weighted collateral and weighted debt for each vault.
1088     struct Vault {
1089         uint256 collateral;
1090         uint256 oTokensIssued;
1091         uint256 underlying;
1092         bool owned;
1093     }
1094 
1095     OptionsExchange public optionsExchange;
1096 
1097     mapping(address => Vault) internal vaults;
1098 
1099     address payable[] internal vaultOwners;
1100 
1101     // 10 is 0.01 i.e. 1% incentive.
1102     Number public liquidationIncentive = Number(10, -3);
1103 
1104     // 100 is egs. 0.1 i.e. 10%.
1105     Number public transactionFee = Number(0, -3);
1106 
1107     /* 500 is 0.5. Max amount that a Vault can be liquidated by i.e.
1108     max collateral that can be taken in one function call */
1109     Number public liquidationFactor = Number(500, -3);
1110 
1111     /* 16 means 1.6. The minimum ratio of a Vault's collateral to insurance promised.
1112     The ratio is calculated as below:
1113     vault.collateral / (Vault.oTokensIssued * strikePrice) */
1114     Number public minCollateralizationRatio = Number(16, -1);
1115 
1116     // The amount of insurance promised per oToken
1117     Number public strikePrice;
1118 
1119     // The amount of underlying that 1 oToken protects.
1120     Number public oTokenExchangeRate;
1121 
1122     /* UNIX time.
1123     Exercise period starts at `(expiry - windowSize)` and ends at `expiry` */
1124     uint256 internal windowSize;
1125 
1126     /* The total fees accumulated in the contract any time liquidate or exercise is called */
1127     uint256 internal totalFee;
1128 
1129     // The time of expiry of the options contract
1130     uint256 public expiry;
1131 
1132     // The precision of the collateral
1133     int32 public collateralExp = -18;
1134 
1135     // The precision of the underlying
1136     int32 public underlyingExp = -18;
1137 
1138     // The collateral asset
1139     IERC20 public collateral;
1140 
1141     // The asset being protected by the insurance
1142     IERC20 public underlying;
1143 
1144     // The asset in which insurance is denominated in.
1145     IERC20 public strike;
1146 
1147     // The Oracle used for the contract
1148     CompoundOracleInterface public COMPOUND_ORACLE;
1149 
1150     // The name of  the contract
1151     string public name;
1152 
1153     // The symbol of  the contract
1154     string public symbol;
1155 
1156     // The number of decimals of the contract
1157     uint8 public decimals;
1158 
1159     /**
1160     * @param _collateral The collateral asset
1161     * @param _collExp The precision of the collateral (-18 if ETH)
1162     * @param _underlying The asset that is being protected
1163     * @param _underlyingExp The precision of the underlying asset
1164     * @param _oTokenExchangeExp The precision of the `amount of underlying` that 1 oToken protects
1165     * @param _strikePrice The amount of strike asset that will be paid out per oToken
1166     * @param _strikeExp The precision of the strike price.
1167     * @param _strike The asset in which the insurance is calculated
1168     * @param _expiry The time at which the insurance expires
1169     * @param _optionsExchange The contract which interfaces with the exchange + oracle
1170     * @param _oracleAddress The address of the oracle
1171     * @param _windowSize UNIX time. Exercise window is from `expiry - _windowSize` to `expiry`.
1172     */
1173     constructor(
1174         IERC20 _collateral,
1175         int32 _collExp,
1176         IERC20 _underlying,
1177         int32 _underlyingExp,
1178         int32 _oTokenExchangeExp,
1179         uint256 _strikePrice,
1180         int32 _strikeExp,
1181         IERC20 _strike,
1182         uint256 _expiry,
1183         OptionsExchange _optionsExchange,
1184         address _oracleAddress,
1185         uint256 _windowSize
1186     ) public {
1187         require(block.timestamp < _expiry, "Can't deploy an expired contract");
1188         require(
1189             _windowSize <= _expiry,
1190             "Exercise window can't be longer than the contract's lifespan"
1191         );
1192         require(
1193             isWithinExponentRange(_collExp),
1194             "collateral exponent not within expected range"
1195         );
1196         require(
1197             isWithinExponentRange(_underlyingExp),
1198             "underlying exponent not within expected range"
1199         );
1200         require(
1201             isWithinExponentRange(_strikeExp),
1202             "strike price exponent not within expected range"
1203         );
1204         require(
1205             isWithinExponentRange(_oTokenExchangeExp),
1206             "oToken exchange rate exponent not within expected range"
1207         );
1208 
1209         collateral = _collateral;
1210         collateralExp = _collExp;
1211 
1212         underlying = _underlying;
1213         underlyingExp = _underlyingExp;
1214         oTokenExchangeRate = Number(1, _oTokenExchangeExp);
1215 
1216         strikePrice = Number(_strikePrice, _strikeExp);
1217         strike = _strike;
1218 
1219         expiry = _expiry;
1220         COMPOUND_ORACLE = CompoundOracleInterface(_oracleAddress);
1221         optionsExchange = _optionsExchange;
1222         windowSize = _windowSize;
1223     }
1224 
1225     /*** Events ***/
1226     event VaultOpened(address payable vaultOwner);
1227     event ETHCollateralAdded(
1228         address payable vaultOwner,
1229         uint256 amount,
1230         address payer
1231     );
1232     event ERC20CollateralAdded(
1233         address payable vaultOwner,
1234         uint256 amount,
1235         address payer
1236     );
1237     event IssuedOTokens(
1238         address issuedTo,
1239         uint256 oTokensIssued,
1240         address payable vaultOwner
1241     );
1242     event Liquidate(
1243         uint256 amtCollateralToPay,
1244         address payable vaultOwner,
1245         address payable liquidator
1246     );
1247     event Exercise(
1248         uint256 amtUnderlyingToPay,
1249         uint256 amtCollateralToPay,
1250         address payable exerciser,
1251         address payable vaultExercisedFrom
1252     );
1253     event RedeemVaultBalance(
1254         uint256 amtCollateralRedeemed,
1255         uint256 amtUnderlyingRedeemed,
1256         address payable vaultOwner
1257     );
1258     event BurnOTokens(address payable vaultOwner, uint256 oTokensBurned);
1259     event RemoveCollateral(uint256 amtRemoved, address payable vaultOwner);
1260     event UpdateParameters(
1261         uint256 liquidationIncentive,
1262         uint256 liquidationFactor,
1263         uint256 transactionFee,
1264         uint256 minCollateralizationRatio,
1265         address owner
1266     );
1267     event TransferFee(address payable to, uint256 fees);
1268     event RemoveUnderlying(
1269         uint256 amountUnderlying,
1270         address payable vaultOwner
1271     );
1272 
1273     /**
1274      * @dev Throws if called Options contract is expired.
1275      */
1276     modifier notExpired() {
1277         require(!hasExpired(), "Options contract expired");
1278         _;
1279     }
1280 
1281     /**
1282      * @notice This function gets the array of vaultOwners
1283      */
1284     function getVaultOwners() public view returns (address payable[] memory) {
1285         address payable[] memory owners;
1286         uint256 index = 0;
1287         for (uint256 i = 0; i < vaultOwners.length; i++) {
1288             if (hasVault(vaultOwners[i])) {
1289                 owners[index] = vaultOwners[i];
1290                 index++;
1291             }
1292         }
1293 
1294         return owners;
1295     }
1296 
1297     /**
1298      * @notice Can only be called by owner. Used to update the fees, minminCollateralizationRatio, etc
1299      * @param _liquidationIncentive The incentive paid to liquidator. 10 is 0.01 i.e. 1% incentive.
1300      * @param _liquidationFactor Max amount that a Vault can be liquidated by. 500 is 0.5.
1301      * @param _transactionFee The fees paid to our protocol every time a execution happens. 100 is egs. 0.1 i.e. 10%.
1302      * @param _minCollateralizationRatio The minimum ratio of a Vault's collateral to insurance promised. 16 means 1.6.
1303      */
1304     function updateParameters(
1305         uint256 _liquidationIncentive,
1306         uint256 _liquidationFactor,
1307         uint256 _transactionFee,
1308         uint256 _minCollateralizationRatio
1309     ) public onlyOwner {
1310         require(
1311             _liquidationIncentive <= 200,
1312             "Can't have >20% liquidation incentive"
1313         );
1314         require(
1315             _liquidationFactor <= 1000,
1316             "Can't liquidate more than 100% of the vault"
1317         );
1318         require(_transactionFee <= 100, "Can't have transaction fee > 10%");
1319         require(
1320             _minCollateralizationRatio >= 10,
1321             "Can't have minCollateralizationRatio < 1"
1322         );
1323 
1324         liquidationIncentive.value = _liquidationIncentive;
1325         liquidationFactor.value = _liquidationFactor;
1326         transactionFee.value = _transactionFee;
1327         minCollateralizationRatio.value = _minCollateralizationRatio;
1328 
1329         emit UpdateParameters(
1330             _liquidationIncentive,
1331             _liquidationFactor,
1332             _transactionFee,
1333             _minCollateralizationRatio,
1334             owner()
1335         );
1336     }
1337 
1338     /**
1339      * @notice Can only be called by owner. Used to set the name, symbol and decimals of the contract
1340      * @param _name The name of the contract
1341      * @param _symbol The symbol of the contract
1342      */
1343     function setDetails(string memory _name, string memory _symbol)
1344         public
1345         onlyOwner
1346     {
1347         name = _name;
1348         symbol = _symbol;
1349         decimals = uint8(-1 * oTokenExchangeRate.exponent);
1350         require(
1351             decimals >= 0,
1352             "1 oToken cannot protect less than the smallest unit of the asset"
1353         );
1354     }
1355 
1356     /**
1357      * @notice Can only be called by owner. Used to take out the protocol fees from the contract.
1358      * @param _address The address to send the fee to.
1359      */
1360     function transferFee(address payable _address) public onlyOwner {
1361         uint256 fees = totalFee;
1362         totalFee = 0;
1363         transferCollateral(_address, fees);
1364 
1365         emit TransferFee(_address, fees);
1366     }
1367 
1368     /**
1369      * @notice Checks if a `owner` has already created a Vault
1370      * @param owner The address of the supposed owner
1371      * @return true or false
1372      */
1373     function hasVault(address payable owner) public view returns (bool) {
1374         return vaults[owner].owned;
1375     }
1376 
1377     /**
1378      * @notice Creates a new empty Vault and sets the owner of the vault to be the msg.sender.
1379      */
1380     function openVault() public notExpired returns (bool) {
1381         require(!hasVault(msg.sender), "Vault already created");
1382 
1383         vaults[msg.sender] = Vault(0, 0, 0, true);
1384         vaultOwners.push(msg.sender);
1385 
1386         emit VaultOpened(msg.sender);
1387         return true;
1388     }
1389 
1390     /**
1391      * @notice If the collateral type is ETH, anyone can call this function any time before
1392      * expiry to increase the amount of collateral in a Vault. Will fail if ETH is not the
1393      * collateral asset.
1394      * Remember that adding ETH collateral even if no oTokens have been created can put the owner at a
1395      * risk of losing the collateral if an exercise event happens.
1396      * Ensure that you issue and immediately sell oTokens to allow the owner to earn premiums.
1397      * (Either call the createAndSell function in the oToken contract or batch the
1398      * addERC20Collateral, issueOTokens and sell transactions and ensure they happen atomically to protect
1399      * the end user).
1400      * @param vaultOwner the index of the Vault to which collateral will be added.
1401      */
1402     function addETHCollateral(address payable vaultOwner)
1403         public
1404         payable
1405         notExpired
1406         returns (uint256)
1407     {
1408         require(isETH(collateral), "ETH is not the specified collateral type");
1409         require(hasVault(vaultOwner), "Vault does not exist");
1410 
1411         emit ETHCollateralAdded(vaultOwner, msg.value, msg.sender);
1412         return _addCollateral(vaultOwner, msg.value);
1413     }
1414 
1415     /**
1416      * @notice If the collateral type is any ERC20, anyone can call this function any time before
1417      * expiry to increase the amount of collateral in a Vault. Can only transfer in the collateral asset.
1418      * Will fail if ETH is the collateral asset.
1419      * The user has to allow the contract to handle their ERC20 tokens on his behalf before these
1420      * functions are called.
1421      * Remember that adding ERC20 collateral even if no oTokens have been created can put the owner at a
1422      * risk of losing the collateral. Ensure that you issue and immediately sell the oTokens!
1423      * (Either call the createAndSell function in the oToken contract or batch the
1424      * addERC20Collateral, issueOTokens and sell transactions and ensure they happen atomically to protect
1425      * the end user).
1426      * @param vaultOwner the index of the Vault to which collateral will be added.
1427      * @param amt the amount of collateral to be transferred in.
1428      */
1429     function addERC20Collateral(address payable vaultOwner, uint256 amt)
1430         public
1431         notExpired
1432         returns (uint256)
1433     {
1434         require(
1435             collateral.transferFrom(msg.sender, address(this), amt),
1436             "Could not transfer in collateral tokens"
1437         );
1438         require(hasVault(vaultOwner), "Vault does not exist");
1439 
1440         emit ERC20CollateralAdded(vaultOwner, amt, msg.sender);
1441         return _addCollateral(vaultOwner, amt);
1442     }
1443 
1444     /**
1445      * @notice Returns the amount of underlying to be transferred during an exercise call
1446      */
1447     function underlyingRequiredToExercise(uint256 oTokensToExercise)
1448         public
1449         view
1450         returns (uint256)
1451     {
1452         uint64 underlyingPerOTokenExp = uint64(
1453             oTokenExchangeRate.exponent - underlyingExp
1454         );
1455         return oTokensToExercise.mul(10**underlyingPerOTokenExp);
1456     }
1457 
1458     /**
1459      * @notice Returns true if exercise can be called
1460      */
1461     function isExerciseWindow() public view returns (bool) {
1462         return ((block.timestamp >= expiry.sub(windowSize)) &&
1463             (block.timestamp < expiry));
1464     }
1465 
1466     /**
1467      * @notice Returns true if the oToken contract has expired
1468      */
1469     function hasExpired() public view returns (bool) {
1470         return (block.timestamp >= expiry);
1471     }
1472 
1473     /**
1474      * @notice Called by anyone holding the oTokens and underlying during the
1475      * exercise window i.e. from `expiry - windowSize` time to `expiry` time. The caller
1476      * transfers in their oTokens and corresponding amount of underlying and gets
1477      * `strikePrice * oTokens` amount of collateral out. The collateral paid out is taken from
1478      * the each vault owner starting with the first and iterating until the oTokens to exercise
1479      * are found.
1480      * NOTE: This uses a for loop and hence could run out of gas if the array passed in is too big!
1481      * @param oTokensToExercise the number of oTokens being exercised.
1482      * @param vaultsToExerciseFrom the array of vaults to exercise from.
1483      */
1484     function exercise(
1485         uint256 oTokensToExercise,
1486         address payable[] memory vaultsToExerciseFrom
1487     ) public payable {
1488         for (uint256 i = 0; i < vaultsToExerciseFrom.length; i++) {
1489             address payable vaultOwner = vaultsToExerciseFrom[i];
1490             require(
1491                 hasVault(vaultOwner),
1492                 "Cannot exercise from a vault that doesn't exist"
1493             );
1494             Vault storage vault = vaults[vaultOwner];
1495             if (oTokensToExercise == 0) {
1496                 return;
1497             } else if (vault.oTokensIssued >= oTokensToExercise) {
1498                 _exercise(oTokensToExercise, vaultOwner);
1499                 return;
1500             } else {
1501                 oTokensToExercise = oTokensToExercise.sub(vault.oTokensIssued);
1502                 _exercise(vault.oTokensIssued, vaultOwner);
1503             }
1504         }
1505         require(
1506             oTokensToExercise == 0,
1507             "Specified vaults have insufficient collateral"
1508         );
1509     }
1510 
1511     /**
1512      * @notice This function allows the vault owner to remove their share of underlying after an exercise
1513      */
1514     function removeUnderlying() public {
1515         require(hasVault(msg.sender), "Vault does not exist");
1516         Vault storage vault = vaults[msg.sender];
1517 
1518         require(vault.underlying > 0, "No underlying balance");
1519 
1520         uint256 underlyingToTransfer = vault.underlying;
1521         vault.underlying = 0;
1522 
1523         transferUnderlying(msg.sender, underlyingToTransfer);
1524         emit RemoveUnderlying(underlyingToTransfer, msg.sender);
1525 
1526     }
1527 
1528     /**
1529      * @notice This function is called to issue the option tokens. Remember that issuing oTokens even if they
1530      * haven't been sold can put the owner at a risk of not making premiums on the oTokens. Ensure that you
1531      * issue and immidiately sell the oTokens! (Either call the createAndSell function in the oToken contract
1532      * of batch the issueOTokens transaction with a sell transaction and ensure it happens atomically).
1533      * @dev The owner of a Vault should only be able to have a max of
1534      * repo.collateral * collateralToStrike / (minminCollateralizationRatio * strikePrice) tokens issued.
1535      * @param oTokensToIssue The number of o tokens to issue
1536      * @param receiver The address to send the oTokens to
1537      */
1538     function issueOTokens(uint256 oTokensToIssue, address receiver)
1539         public
1540         notExpired
1541     {
1542         //check that we're properly collateralized to mint this number, then call _mint(address account, uint256 amount)
1543         require(hasVault(msg.sender), "Vault does not exist");
1544 
1545         Vault storage vault = vaults[msg.sender];
1546 
1547         // checks that the vault is sufficiently collateralized
1548         uint256 newOTokensBalance = vault.oTokensIssued.add(oTokensToIssue);
1549         require(isSafe(vault.collateral, newOTokensBalance), "unsafe to mint");
1550 
1551         // issue the oTokens
1552         vault.oTokensIssued = newOTokensBalance;
1553         _mint(receiver, oTokensToIssue);
1554 
1555         emit IssuedOTokens(receiver, oTokensToIssue, msg.sender);
1556         return;
1557     }
1558 
1559     /**
1560      * @notice Returns the vault for a given address
1561      * @param vaultOwner the owner of the Vault to return
1562      */
1563     function getVault(address payable vaultOwner)
1564         public
1565         view
1566         returns (uint256, uint256, uint256, bool)
1567     {
1568         Vault storage vault = vaults[vaultOwner];
1569         return (
1570             vault.collateral,
1571             vault.oTokensIssued,
1572             vault.underlying,
1573             vault.owned
1574         );
1575     }
1576 
1577     /**
1578      * @notice Returns true if the given ERC20 is ETH.
1579      * @param _ierc20 the ERC20 asset.
1580      */
1581     function isETH(IERC20 _ierc20) public pure returns (bool) {
1582         return _ierc20 == IERC20(0);
1583     }
1584 
1585     /**
1586      * @notice allows the owner to burn their oTokens to increase the collateralization ratio of
1587      * their vault.
1588      * @param amtToBurn number of oTokens to burn
1589      * @dev only want to call this function before expiry. After expiry, no benefit to calling it.
1590      */
1591     function burnOTokens(uint256 amtToBurn) public notExpired {
1592         require(hasVault(msg.sender), "Vault does not exist");
1593 
1594         Vault storage vault = vaults[msg.sender];
1595 
1596         vault.oTokensIssued = vault.oTokensIssued.sub(amtToBurn);
1597         _burn(msg.sender, amtToBurn);
1598 
1599         emit BurnOTokens(msg.sender, amtToBurn);
1600     }
1601 
1602     /**
1603      * @notice allows the owner to remove excess collateral from the vault before expiry. Removing collateral lowers
1604      * the collateralization ratio of the vault.
1605      * @param amtToRemove Amount of collateral to remove in 10^-18.
1606      */
1607     function removeCollateral(uint256 amtToRemove) public notExpired {
1608         require(amtToRemove > 0, "Cannot remove 0 collateral");
1609         require(hasVault(msg.sender), "Vault does not exist");
1610 
1611         Vault storage vault = vaults[msg.sender];
1612         require(
1613             amtToRemove <= getCollateral(msg.sender),
1614             "Can't remove more collateral than owned"
1615         );
1616 
1617         // check that vault will remain safe after removing collateral
1618         uint256 newCollateralBalance = vault.collateral.sub(amtToRemove);
1619 
1620         require(
1621             isSafe(newCollateralBalance, vault.oTokensIssued),
1622             "Vault is unsafe"
1623         );
1624 
1625         // remove the collateral
1626         vault.collateral = newCollateralBalance;
1627         transferCollateral(msg.sender, amtToRemove);
1628 
1629         emit RemoveCollateral(amtToRemove, msg.sender);
1630     }
1631 
1632     /**
1633      * @notice after expiry, each vault holder can get back their proportional share of collateral
1634      * from vaults that they own.
1635      * @dev The owner gets all of their collateral back if no exercise event took their collateral.
1636      */
1637     function redeemVaultBalance() public {
1638         require(hasExpired(), "Can't collect collateral until expiry");
1639         require(hasVault(msg.sender), "Vault does not exist");
1640 
1641         // pay out owner their share
1642         Vault storage vault = vaults[msg.sender];
1643 
1644         // To deal with lower precision
1645         uint256 collateralToTransfer = vault.collateral;
1646         uint256 underlyingToTransfer = vault.underlying;
1647 
1648         vault.collateral = 0;
1649         vault.oTokensIssued = 0;
1650         vault.underlying = 0;
1651 
1652         transferCollateral(msg.sender, collateralToTransfer);
1653         transferUnderlying(msg.sender, underlyingToTransfer);
1654 
1655         emit RedeemVaultBalance(
1656             collateralToTransfer,
1657             underlyingToTransfer,
1658             msg.sender
1659         );
1660     }
1661 
1662     /**
1663      * This function returns the maximum amount of collateral liquidatable if the given vault is unsafe
1664      * @param vaultOwner The index of the vault to be liquidated
1665      */
1666     function maxOTokensLiquidatable(address payable vaultOwner)
1667         public
1668         view
1669         returns (uint256)
1670     {
1671         if (isUnsafe(vaultOwner)) {
1672             Vault storage vault = vaults[vaultOwner];
1673             uint256 maxCollateralLiquidatable = vault
1674                 .collateral
1675                 .mul(liquidationFactor.value)
1676                 .div(10**uint256(-liquidationFactor.exponent));
1677 
1678             uint256 one = 10**uint256(-liquidationIncentive.exponent);
1679             Number memory liqIncentive = Number(
1680                 liquidationIncentive.value.add(one),
1681                 liquidationIncentive.exponent
1682             );
1683             return calculateOTokens(maxCollateralLiquidatable, liqIncentive);
1684         } else {
1685             return 0;
1686         }
1687     }
1688 
1689     /**
1690      * @notice This function can be called by anyone who notices a vault is undercollateralized.
1691      * The caller gets a reward for reducing the amount of oTokens in circulation.
1692      * @dev Liquidator comes with _oTokens. They get _oTokens * strikePrice * (incentive + fee)
1693      * amount of collateral out. They can liquidate a max of liquidationFactor * vault.collateral out
1694      * in one function call i.e. partial liquidations.
1695      * @param vaultOwner The index of the vault to be liquidated
1696      * @param oTokensToLiquidate The number of oTokens being taken out of circulation
1697      */
1698     function liquidate(address payable vaultOwner, uint256 oTokensToLiquidate)
1699         public
1700         notExpired
1701     {
1702         require(hasVault(vaultOwner), "Vault does not exist");
1703 
1704         Vault storage vault = vaults[vaultOwner];
1705 
1706         // cannot liquidate a safe vault.
1707         require(isUnsafe(vaultOwner), "Vault is safe");
1708 
1709         // Owner can't liquidate themselves
1710         require(msg.sender != vaultOwner, "Owner can't liquidate themselves");
1711 
1712         uint256 amtCollateral = calculateCollateralToPay(
1713             oTokensToLiquidate,
1714             Number(1, 0)
1715         );
1716         uint256 amtIncentive = calculateCollateralToPay(
1717             oTokensToLiquidate,
1718             liquidationIncentive
1719         );
1720         uint256 amtCollateralToPay = amtCollateral.add(amtIncentive);
1721 
1722         // calculate the maximum amount of collateral that can be liquidated
1723         uint256 maxCollateralLiquidatable = vault.collateral.mul(
1724             liquidationFactor.value
1725         );
1726 
1727         if (liquidationFactor.exponent > 0) {
1728             maxCollateralLiquidatable = maxCollateralLiquidatable.mul(
1729                 10**uint256(liquidationFactor.exponent)
1730             );
1731         } else {
1732             maxCollateralLiquidatable = maxCollateralLiquidatable.div(
1733                 10**uint256(-1 * liquidationFactor.exponent)
1734             );
1735         }
1736 
1737         require(
1738             amtCollateralToPay <= maxCollateralLiquidatable,
1739             "Can only liquidate liquidation factor at any given time"
1740         );
1741 
1742         // deduct the collateral and oTokensIssued
1743         vault.collateral = vault.collateral.sub(amtCollateralToPay);
1744         vault.oTokensIssued = vault.oTokensIssued.sub(oTokensToLiquidate);
1745 
1746         // transfer the collateral and burn the _oTokens
1747         _burn(msg.sender, oTokensToLiquidate);
1748         transferCollateral(msg.sender, amtCollateralToPay);
1749 
1750         emit Liquidate(amtCollateralToPay, vaultOwner, msg.sender);
1751     }
1752 
1753     /**
1754      * @notice checks if a vault is unsafe. If so, it can be liquidated
1755      * @param vaultOwner The number of the vault to check
1756      * @return true or false
1757      */
1758     function isUnsafe(address payable vaultOwner) public view returns (bool) {
1759         bool stillUnsafe = !isSafe(
1760             getCollateral(vaultOwner),
1761             getOTokensIssued(vaultOwner)
1762         );
1763         return stillUnsafe;
1764     }
1765 
1766     /**
1767      * @notice This function returns if an -30 <= exponent <= 30
1768      */
1769     function isWithinExponentRange(int32 val) internal pure returns (bool) {
1770         return ((val <= 30) && (val >= -30));
1771     }
1772 
1773     /**
1774      * @notice This function calculates and returns the amount of collateral in the vault
1775     */
1776     function getCollateral(address payable vaultOwner)
1777         internal
1778         view
1779         returns (uint256)
1780     {
1781         Vault storage vault = vaults[vaultOwner];
1782         return vault.collateral;
1783     }
1784 
1785     /**
1786      * @notice This function calculates and returns the amount of puts issued by the Vault
1787     */
1788     function getOTokensIssued(address payable vaultOwner)
1789         internal
1790         view
1791         returns (uint256)
1792     {
1793         Vault storage vault = vaults[vaultOwner];
1794         return vault.oTokensIssued;
1795     }
1796 
1797     /**
1798      * @notice Called by anyone holding the oTokens and underlying during the
1799      * exercise window i.e. from `expiry - windowSize` time to `expiry` time. The caller
1800      * transfers in their oTokens and corresponding amount of underlying and gets
1801      * `strikePrice * oTokens` amount of collateral out. The collateral paid out is taken from
1802      * the specified vault holder. At the end of the expiry window, the vault holder can redeem their balance
1803      * of collateral. The vault owner can withdraw their underlying at any time.
1804      * The user has to allow the contract to handle their oTokens and underlying on his behalf before these functions are called.
1805      * @param oTokensToExercise the number of oTokens being exercised.
1806      * @param vaultToExerciseFrom the address of the vaultOwner to take collateral from.
1807      * @dev oTokenExchangeRate is the number of underlying tokens that 1 oToken protects.
1808      */
1809     function _exercise(
1810         uint256 oTokensToExercise,
1811         address payable vaultToExerciseFrom
1812     ) internal {
1813         // 1. before exercise window: revert
1814         require(
1815             isExerciseWindow(),
1816             "Can't exercise outside of the exercise window"
1817         );
1818 
1819         require(hasVault(vaultToExerciseFrom), "Vault does not exist");
1820 
1821         Vault storage vault = vaults[vaultToExerciseFrom];
1822         require(oTokensToExercise > 0, "Can't exercise 0 oTokens");
1823         // Check correct amount of oTokens passed in)
1824         require(
1825             oTokensToExercise <= vault.oTokensIssued,
1826             "Can't exercise more oTokens than the owner has"
1827         );
1828         // Ensure person calling has enough oTokens
1829         require(
1830             balanceOf(msg.sender) >= oTokensToExercise,
1831             "Not enough oTokens"
1832         );
1833 
1834         // 1. Check sufficient underlying
1835         // 1.1 update underlying balances
1836         uint256 amtUnderlyingToPay = underlyingRequiredToExercise(
1837             oTokensToExercise
1838         );
1839         vault.underlying = vault.underlying.add(amtUnderlyingToPay);
1840 
1841         // 2. Calculate Collateral to pay
1842         // 2.1 Payout enough collateral to get (strikePrice * oTokens) amount of collateral
1843         uint256 amtCollateralToPay = calculateCollateralToPay(
1844             oTokensToExercise,
1845             Number(1, 0)
1846         );
1847 
1848         // 2.2 Take a small fee on every exercise
1849         uint256 amtFee = calculateCollateralToPay(
1850             oTokensToExercise,
1851             transactionFee
1852         );
1853         totalFee = totalFee.add(amtFee);
1854 
1855         uint256 totalCollateralToPay = amtCollateralToPay.add(amtFee);
1856         require(
1857             totalCollateralToPay <= vault.collateral,
1858             "Vault underwater, can't exercise"
1859         );
1860 
1861         // 3. Update collateral + oToken balances
1862         vault.collateral = vault.collateral.sub(totalCollateralToPay);
1863         vault.oTokensIssued = vault.oTokensIssued.sub(oTokensToExercise);
1864 
1865         // 4. Transfer in underlying, burn oTokens + pay out collateral
1866         // 4.1 Transfer in underlying
1867         if (isETH(underlying)) {
1868             require(msg.value == amtUnderlyingToPay, "Incorrect msg.value");
1869         } else {
1870             require(
1871                 underlying.transferFrom(
1872                     msg.sender,
1873                     address(this),
1874                     amtUnderlyingToPay
1875                 ),
1876                 "Could not transfer in tokens"
1877             );
1878         }
1879         // 4.2 burn oTokens
1880         _burn(msg.sender, oTokensToExercise);
1881 
1882         // 4.3 Pay out collateral
1883         transferCollateral(msg.sender, amtCollateralToPay);
1884 
1885         emit Exercise(
1886             amtUnderlyingToPay,
1887             amtCollateralToPay,
1888             msg.sender,
1889             vaultToExerciseFrom
1890         );
1891 
1892     }
1893 
1894     /**
1895      * @notice adds `_amt` collateral to `vaultOwner` and returns the new balance of the vault
1896      * @param vaultOwner the index of the vault
1897      * @param amt the amount of collateral to add
1898      */
1899     function _addCollateral(address payable vaultOwner, uint256 amt)
1900         internal
1901         notExpired
1902         returns (uint256)
1903     {
1904         Vault storage vault = vaults[vaultOwner];
1905         vault.collateral = vault.collateral.add(amt);
1906 
1907         return vault.collateral;
1908     }
1909 
1910     /**
1911      * @notice checks if a hypothetical vault is safe with the given collateralAmt and oTokensIssued
1912      * @param collateralAmt The amount of collateral the hypothetical vault has
1913      * @param oTokensIssued The amount of oTokens generated by the hypothetical vault
1914      * @return true or false
1915      */
1916     function isSafe(uint256 collateralAmt, uint256 oTokensIssued)
1917         internal
1918         view
1919         returns (bool)
1920     {
1921         // get price from Oracle
1922         uint256 collateralToEthPrice = getPrice(address(collateral));
1923         uint256 strikeToEthPrice = getPrice(address(strike));
1924 
1925         // check `oTokensIssued * minCollateralizationRatio * strikePrice <= collAmt * collateralToStrikePrice`
1926         uint256 leftSideVal = oTokensIssued
1927             .mul(minCollateralizationRatio.value)
1928             .mul(strikePrice.value);
1929         int32 leftSideExp = minCollateralizationRatio.exponent +
1930             strikePrice.exponent;
1931 
1932         uint256 rightSideVal = (collateralAmt.mul(collateralToEthPrice)).div(
1933             strikeToEthPrice
1934         );
1935         int32 rightSideExp = collateralExp;
1936 
1937         uint256 exp = 0;
1938         bool stillSafe = false;
1939 
1940         if (rightSideExp < leftSideExp) {
1941             exp = uint256(leftSideExp - rightSideExp);
1942             stillSafe = leftSideVal.mul(10**exp) <= rightSideVal;
1943         } else {
1944             exp = uint256(rightSideExp - leftSideExp);
1945             stillSafe = leftSideVal <= rightSideVal.mul(10**exp);
1946         }
1947 
1948         return stillSafe;
1949     }
1950 
1951     /**
1952      * This function returns the maximum amount of oTokens that can safely be issued against the specified amount of collateral.
1953      * @param collateralAmt The amount of collateral against which oTokens will be issued.
1954      */
1955     function maxOTokensIssuable(uint256 collateralAmt)
1956         public
1957         view
1958         returns (uint256)
1959     {
1960         return calculateOTokens(collateralAmt, minCollateralizationRatio);
1961 
1962     }
1963 
1964     /**
1965      * @notice This function is used to calculate the amount of tokens that can be issued.
1966      * @dev The amount of oTokens is determined by:
1967      * oTokensIssued  <= collateralAmt * collateralToStrikePrice / (proportion * strikePrice)
1968      * @param collateralAmt The amount of collateral
1969      * @param proportion The proportion of the collateral to pay out. If 100% of collateral
1970      * should be paid out, pass in Number(1, 0). The proportion might be less than 100% if
1971      * you are calculating fees.
1972      */
1973     function calculateOTokens(uint256 collateralAmt, Number memory proportion)
1974         internal
1975         view
1976         returns (uint256)
1977     {
1978         // get price from Oracle
1979         uint256 collateralToEthPrice = getPrice(address(collateral));
1980         uint256 strikeToEthPrice = getPrice(address(strike));
1981 
1982         // oTokensIssued  <= collAmt * collateralToStrikePrice / (proportion * strikePrice)
1983         uint256 denomVal = proportion.value.mul(strikePrice.value);
1984         int32 denomExp = proportion.exponent + strikePrice.exponent;
1985 
1986         uint256 numeratorVal = (collateralAmt.mul(collateralToEthPrice)).div(
1987             strikeToEthPrice
1988         );
1989         int32 numeratorExp = collateralExp;
1990 
1991         uint256 exp = 0;
1992         uint256 numOptions = 0;
1993 
1994         if (numeratorExp < denomExp) {
1995             exp = uint256(denomExp - numeratorExp);
1996             numOptions = numeratorVal.div(denomVal.mul(10**exp));
1997         } else {
1998             exp = uint256(numeratorExp - denomExp);
1999             numOptions = numeratorVal.mul(10**exp).div(denomVal);
2000         }
2001 
2002         return numOptions;
2003     }
2004 
2005     /**
2006      * @notice This function calculates the amount of collateral to be paid out.
2007      * @dev The amount of collateral to paid out is determined by:
2008      * (proportion * strikePrice * strikeToCollateralPrice * oTokens) amount of collateral.
2009      * @param _oTokens The number of oTokens.
2010      * @param proportion The proportion of the collateral to pay out. If 100% of collateral
2011      * should be paid out, pass in Number(1, 0). The proportion might be less than 100% if
2012      * you are calculating fees.
2013      */
2014     function calculateCollateralToPay(
2015         uint256 _oTokens,
2016         Number memory proportion
2017     ) internal view returns (uint256) {
2018         // Get price from oracle
2019         uint256 collateralToEthPrice = getPrice(address(collateral));
2020         uint256 strikeToEthPrice = getPrice(address(strike));
2021 
2022         // calculate how much should be paid out
2023         uint256 amtCollateralToPayInEthNum = _oTokens
2024             .mul(strikePrice.value)
2025             .mul(proportion.value)
2026             .mul(strikeToEthPrice);
2027         int32 amtCollateralToPayExp = strikePrice.exponent +
2028             proportion.exponent -
2029             collateralExp;
2030         uint256 amtCollateralToPay = 0;
2031         if (amtCollateralToPayExp > 0) {
2032             uint32 exp = uint32(amtCollateralToPayExp);
2033             amtCollateralToPay = amtCollateralToPayInEthNum.mul(10**exp).div(
2034                 collateralToEthPrice
2035             );
2036         } else {
2037             uint32 exp = uint32(-1 * amtCollateralToPayExp);
2038             amtCollateralToPay = (amtCollateralToPayInEthNum.div(10**exp)).div(
2039                 collateralToEthPrice
2040             );
2041         }
2042 
2043         return amtCollateralToPay;
2044 
2045     }
2046 
2047     /**
2048      * @notice This function transfers `amt` collateral to `_addr`
2049      * @param _addr The address to send the collateral to
2050      * @param _amt The amount of the collateral to pay out.
2051      */
2052     function transferCollateral(address payable _addr, uint256 _amt) internal {
2053         if (isETH(collateral)) {
2054             _addr.transfer(_amt);
2055         } else {
2056             collateral.transfer(_addr, _amt);
2057         }
2058     }
2059 
2060     /**
2061      * @notice This function transfers `amt` underlying to `_addr`
2062      * @param _addr The address to send the underlying to
2063      * @param _amt The amount of the underlying to pay out.
2064      */
2065     function transferUnderlying(address payable _addr, uint256 _amt) internal {
2066         if (isETH(underlying)) {
2067             _addr.transfer(_amt);
2068         } else {
2069             underlying.transfer(_addr, _amt);
2070         }
2071     }
2072 
2073     /**
2074      * @notice This function gets the price ETH (wei) to asset price.
2075      * @param asset The address of the asset to get the price of
2076      */
2077     function getPrice(address asset) internal view returns (uint256) {
2078         if (asset == address(0)) {
2079             return (10**18);
2080         } else {
2081             return COMPOUND_ORACLE.getPrice(asset);
2082         }
2083     }
2084 }
2085 
2086 // File: contracts/oToken.sol
2087 
2088 pragma solidity 0.5.10;
2089 
2090 
2091 /**
2092  * @title Opyn's Options Contract
2093  * @author Opyn
2094  */
2095 
2096 contract oToken is OptionsContract {
2097     /**
2098     * @param _collateral The collateral asset
2099     * @param _collExp The precision of the collateral (-18 if ETH)
2100     * @param _underlying The asset that is being protected
2101     * @param _underlyingExp The precision of the underlying asset
2102     * @param _oTokenExchangeExp The precision of the `amount of underlying` that 1 oToken protects
2103     * @param _strikePrice The amount of strike asset that will be paid out
2104     * @param _strikeExp The precision of the strike asset (-18 if ETH)
2105     * @param _strike The asset in which the insurance is calculated
2106     * @param _expiry The time at which the insurance expires
2107     * @param _optionsExchange The contract which interfaces with the exchange + oracle
2108     * @param _oracleAddress The address of the oracle
2109     * @param _windowSize UNIX time. Exercise window is from `expiry - _windowSize` to `expiry`.
2110     */
2111     constructor(
2112         IERC20 _collateral,
2113         int32 _collExp,
2114         IERC20 _underlying,
2115         int32 _underlyingExp,
2116         int32 _oTokenExchangeExp,
2117         uint256 _strikePrice,
2118         int32 _strikeExp,
2119         IERC20 _strike,
2120         uint256 _expiry,
2121         OptionsExchange _optionsExchange,
2122         address _oracleAddress,
2123         uint256 _windowSize
2124     )
2125         public
2126         OptionsContract(
2127             _collateral,
2128             _collExp,
2129             _underlying,
2130             _underlyingExp,
2131             _oTokenExchangeExp,
2132             _strikePrice,
2133             _strikeExp,
2134             _strike,
2135             _expiry,
2136             _optionsExchange,
2137             _oracleAddress,
2138             _windowSize
2139         )
2140     {}
2141 
2142     /**
2143      * @notice opens a Vault, adds ETH collateral, and mints new oTokens in one step
2144      * Remember that creating oTokens can put the owner at a risk of losing the collateral
2145      * if an exercise event happens.
2146      * The sell function provides the owner a chance to earn premiums.
2147      * Ensure that you create and immediately sell oTokens atmoically.
2148      * @param amtToCreate number of oTokens to create
2149      * @param receiver address to send the Options to
2150      */
2151     function createETHCollateralOption(uint256 amtToCreate, address receiver)
2152         external
2153         payable
2154     {
2155         openVault();
2156         addETHCollateralOption(amtToCreate, receiver);
2157     }
2158 
2159     /**
2160      * @notice adds ETH collateral, and mints new oTokens in one step to an existing Vault
2161      * Remember that creating oTokens can put the owner at a risk of losing the collateral
2162      * if an exercise event happens.
2163      * The sell function provides the owner a chance to earn premiums.
2164      * Ensure that you create and immediately sell oTokens atmoically.
2165      * @param amtToCreate number of oTokens to create
2166      * @param receiver address to send the Options to
2167      */
2168     function addETHCollateralOption(uint256 amtToCreate, address receiver)
2169         public
2170         payable
2171     {
2172         addETHCollateral(msg.sender);
2173         issueOTokens(amtToCreate, receiver);
2174     }
2175 
2176     /**
2177      * @notice opens a Vault, adds ETH collateral, mints new oTokens and sell in one step
2178      * @param amtToCreate number of oTokens to create
2179      * @param receiver address to receive the premiums
2180      */
2181     function createAndSellETHCollateralOption(
2182         uint256 amtToCreate,
2183         address payable receiver
2184     ) external payable {
2185         openVault();
2186         addETHCollateralOption(amtToCreate, address(this));
2187         this.approve(address(optionsExchange), amtToCreate);
2188         optionsExchange.sellOTokens(
2189             receiver,
2190             address(this),
2191             address(0),
2192             amtToCreate
2193         );
2194     }
2195 
2196     /**
2197      * @notice adds ETH collateral to an existing Vault, and mints new oTokens and sells the oTokens in one step
2198      * @param amtToCreate number of oTokens to create
2199      * @param receiver address to send the Options to
2200      */
2201     function addAndSellETHCollateralOption(
2202         uint256 amtToCreate,
2203         address payable receiver
2204     ) public payable {
2205         addETHCollateral(msg.sender);
2206         issueOTokens(amtToCreate, address(this));
2207         this.approve(address(optionsExchange), amtToCreate);
2208         optionsExchange.sellOTokens(
2209             receiver,
2210             address(this),
2211             address(0),
2212             amtToCreate
2213         );
2214     }
2215 
2216     /**
2217      * @notice opens a Vault, adds ERC20 collateral, and mints new oTokens in one step
2218      * Remember that creating oTokens can put the owner at a risk of losing the collateral
2219      * if an exercise event happens.
2220      * The sell function provides the owner a chance to earn premiums.
2221      * Ensure that you create and immediately sell oTokens atmoically.
2222      * @param amtToCreate number of oTokens to create
2223      * @param amtCollateral amount of collateral added
2224      * @param receiver address to send the Options to
2225      */
2226     function createERC20CollateralOption(
2227         uint256 amtToCreate,
2228         uint256 amtCollateral,
2229         address receiver
2230     ) external {
2231         openVault();
2232         addERC20CollateralOption(amtToCreate, amtCollateral, receiver);
2233     }
2234 
2235     /**
2236      * @notice adds ERC20 collateral, and mints new oTokens in one step
2237      * Remember that creating oTokens can put the owner at a risk of losing the collateral
2238      * if an exercise event happens.
2239      * The sell function provides the owner a chance to earn premiums.
2240      * Ensure that you create and immediately sell oTokens atmoically.
2241      * @param amtToCreate number of oTokens to create
2242      * @param amtCollateral amount of collateral added
2243      * @param receiver address to send the Options to
2244      */
2245     function addERC20CollateralOption(
2246         uint256 amtToCreate,
2247         uint256 amtCollateral,
2248         address receiver
2249     ) public {
2250         addERC20Collateral(msg.sender, amtCollateral);
2251         issueOTokens(amtToCreate, receiver);
2252     }
2253 
2254     /**
2255      * @notice opens a Vault, adds ERC20 collateral, mints new oTokens and sells the oTokens in one step
2256      * @param amtToCreate number of oTokens to create
2257      * @param amtCollateral amount of collateral added
2258      * @param receiver address to send the Options to
2259      */
2260     function createAndSellERC20CollateralOption(
2261         uint256 amtToCreate,
2262         uint256 amtCollateral,
2263         address payable receiver
2264     ) external {
2265         openVault();
2266         addERC20CollateralOption(amtToCreate, amtCollateral, address(this));
2267         this.approve(address(optionsExchange), amtToCreate);
2268         optionsExchange.sellOTokens(
2269             receiver,
2270             address(this),
2271             address(0),
2272             amtToCreate
2273         );
2274     }
2275 
2276     /**
2277      * @notice adds ERC20 collateral, mints new oTokens and sells the oTokens in one step
2278      * @param amtToCreate number of oTokens to create
2279      * @param amtCollateral amount of collateral added
2280      * @param receiver address to send the Options to
2281      */
2282     function addAndSellERC20CollateralOption(
2283         uint256 amtToCreate,
2284         uint256 amtCollateral,
2285         address payable receiver
2286     ) public {
2287         addERC20Collateral(msg.sender, amtCollateral);
2288         issueOTokens(amtToCreate, address(this));
2289         this.approve(address(optionsExchange), amtToCreate);
2290         optionsExchange.sellOTokens(
2291             receiver,
2292             address(this),
2293             address(0),
2294             amtToCreate
2295         );
2296     }
2297 }