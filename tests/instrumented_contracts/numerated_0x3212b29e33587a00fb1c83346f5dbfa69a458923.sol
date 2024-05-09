1 pragma solidity 0.5.0;
2 // File: src/erc777/IERC777.sol
3 
4 
5 /**
6  * @dev Interface of the ERC777Token standard as defined in the EIP.
7  *
8  * This contract uses the
9  * [ERC1820 registry standard](https://eips.ethereum.org/EIPS/eip-1820) to let
10  * token holders and recipients react to token movements by using setting implementers
11  * for the associated interfaces in said registry. See `IERC1820Registry` and
12  * `ERC1820Implementer`.
13  */
14 interface IERC777 {
15     /**
16      * @dev Returns the name of the token.
17      */
18     function name() external view returns (string memory);
19 
20     /**
21      * @dev Returns the symbol of the token, usually a shorter version of the
22      * name.
23      */
24     function symbol() external view returns (string memory);
25 
26     /**
27      * @dev Returns the smallest part of the token that is not divisible. This
28      * means all token operations (creation, movement and destruction) must have
29      * amounts that are a multiple of this number.
30      *
31      * For most token contracts, this value will equal 1.
32      */
33     function granularity() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by an account (`owner`).
42      */
43     function balanceOf(address owner) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * If send or receive hooks are registered for the caller and `recipient`,
49      * the corresponding functions will be called with `data` and empty
50      * `operatorData`. See `IERC777Sender` and `IERC777Recipient`.
51      *
52      * Emits a `Sent` event.
53      *
54      * Requirements
55      *
56      * - the caller must have at least `amount` tokens.
57      * - `recipient` cannot be the zero address.
58      * - if `recipient` is a contract, it must implement the `tokensReceived`
59      * interface.
60      */
61     function send(address recipient, uint256 amount, bytes calldata data) external;
62 
63     /**
64      * @dev Destroys `amount` tokens from the caller's account, reducing the
65      * total supply.
66      *
67      * If a send hook is registered for the caller, the corresponding function
68      * will be called with `data` and empty `operatorData`. See `IERC777Sender`.
69      *
70      * Emits a `Burned` event.
71      *
72      * Requirements
73      *
74      * - the caller must have at least `amount` tokens.
75      */
76     function burn(uint256 amount, bytes calldata data) external;
77 
78     /**
79      * @dev Returns true if an account is an operator of `tokenHolder`.
80      * Operators can send and burn tokens on behalf of their owners. All
81      * accounts are their own operator.
82      *
83      * See `operatorSend` and `operatorBurn`.
84      */
85     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
86 
87     /**
88      * @dev Make an account an operator of the caller.
89      *
90      * See `isOperatorFor`.
91      *
92      * Emits an `AuthorizedOperator` event.
93      *
94      * Requirements
95      *
96      * - `operator` cannot be calling address.
97      */
98     function authorizeOperator(address operator) external;
99 
100     /**
101      * @dev Make an account an operator of the caller.
102      *
103      * See `isOperatorFor` and `defaultOperators`.
104      *
105      * Emits a `RevokedOperator` event.
106      *
107      * Requirements
108      *
109      * - `operator` cannot be calling address.
110      */
111     function revokeOperator(address operator) external;
112 
113     /**
114      * @dev Returns the list of default operators. These accounts are operators
115      * for all token holders, even if `authorizeOperator` was never called on
116      * them.
117      *
118      * This list is immutable, but individual holders may revoke these via
119      * `revokeOperator`, in which case `isOperatorFor` will return false.
120      */
121     function defaultOperators() external view returns (address[] memory);
122 
123     /**
124      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
125      * be an operator of `sender`.
126      *
127      * If send or receive hooks are registered for `sender` and `recipient`,
128      * the corresponding functions will be called with `data` and
129      * `operatorData`. See `IERC777Sender` and `IERC777Recipient`.
130      *
131      * Emits a `Sent` event.
132      *
133      * Requirements
134      *
135      * - `sender` cannot be the zero address.
136      * - `sender` must have at least `amount` tokens.
137      * - the caller must be an operator for `sender`.
138      * - `recipient` cannot be the zero address.
139      * - if `recipient` is a contract, it must implement the `tokensReceived`
140      * interface.
141      */
142     function operatorSend(
143         address sender,
144         address recipient,
145         uint256 amount,
146         bytes calldata data,
147         bytes calldata operatorData
148     ) external;
149 
150     /**
151      * @dev Destoys `amount` tokens from `account`, reducing the total supply.
152      * The caller must be an operator of `account`.
153      *
154      * If a send hook is registered for `account`, the corresponding function
155      * will be called with `data` and `operatorData`. See `IERC777Sender`.
156      *
157      * Emits a `Burned` event.
158      *
159      * Requirements
160      *
161      * - `account` cannot be the zero address.
162      * - `account` must have at least `amount` tokens.
163      * - the caller must be an operator for `account`.
164      */
165     function operatorBurn(
166         address account,
167         uint256 amount,
168         bytes calldata data,
169         bytes calldata operatorData
170     ) external;
171 
172     event Sent(
173         address indexed operator,
174         address indexed from,
175         address indexed to,
176         uint256 amount,
177         bytes data,
178         bytes operatorData
179     );
180 
181     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
182 
183     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
184 
185     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
186 
187     event RevokedOperator(address indexed operator, address indexed tokenHolder);
188 }
189 
190 // File: src/erc777/IERC777Recipient.sol
191 
192 
193 /**
194  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
195  *
196  * Accounts can be notified of `IERC777` tokens being sent to them by having a
197  * contract implement this interface (contract holders can be their own
198  * implementer) and registering it on the
199  * [ERC1820 global registry](https://eips.ethereum.org/EIPS/eip-1820).
200  *
201  * See `IERC1820Registry` and `ERC1820Implementer`.
202  */
203 interface IERC777Recipient {
204     /**
205      * @dev Called by an `IERC777` token contract whenever tokens are being
206      * moved or created into a registered account (`to`). The type of operation
207      * is conveyed by `from` being the zero address or not.
208      *
209      * This call occurs _after_ the token contract's state is updated, so
210      * `IERC777.balanceOf`, etc., can be used to query the post-operation state.
211      *
212      * This function may revert to prevent the operation from being executed.
213      */
214     function tokensReceived(
215         address operator,
216         address from,
217         address to,
218         uint amount,
219         bytes calldata userData,
220         bytes calldata operatorData
221     ) external;
222 }
223 
224 // File: src/erc777/IERC777Sender.sol
225 
226 
227 /**
228  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
229  *
230  * `IERC777` Token holders can be notified of operations performed on their
231  * tokens by having a contract implement this interface (contract holders can be
232  *  their own implementer) and registering it on the
233  * [ERC1820 global registry](https://eips.ethereum.org/EIPS/eip-1820).
234  *
235  * See `IERC1820Registry` and `ERC1820Implementer`.
236  */
237 interface IERC777Sender {
238     /**
239      * @dev Called by an `IERC777` token contract whenever a registered holder's
240      * (`from`) tokens are about to be moved or destroyed. The type of operation
241      * is conveyed by `to` being the zero address or not.
242      *
243      * This call occurs _before_ the token contract's state is updated, so
244      * `IERC777.balanceOf`, etc., can be used to query the pre-operation state.
245      *
246      * This function may revert to prevent the operation from being executed.
247      */
248     function tokensToSend(
249         address operator,
250         address from,
251         address to,
252         uint amount,
253         bytes calldata userData,
254         bytes calldata operatorData
255     ) external;
256 }
257 
258 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
259 
260 
261 /**
262  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
263  * the optional functions; to access them see `ERC20Detailed`.
264  */
265 interface IERC20 {
266     /**
267      * @dev Returns the amount of tokens in existence.
268      */
269     function totalSupply() external view returns (uint256);
270 
271     /**
272      * @dev Returns the amount of tokens owned by `account`.
273      */
274     function balanceOf(address account) external view returns (uint256);
275 
276     /**
277      * @dev Moves `amount` tokens from the caller's account to `recipient`.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a `Transfer` event.
282      */
283     function transfer(address recipient, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Returns the remaining number of tokens that `spender` will be
287      * allowed to spend on behalf of `owner` through `transferFrom`. This is
288      * zero by default.
289      *
290      * This value changes when `approve` or `transferFrom` are called.
291      */
292     function allowance(address owner, address spender) external view returns (uint256);
293 
294     /**
295      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * > Beware that changing an allowance with this method brings the risk
300      * that someone may use both the old and the new allowance by unfortunate
301      * transaction ordering. One possible solution to mitigate this race
302      * condition is to first reduce the spender's allowance to 0 and set the
303      * desired value afterwards:
304      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305      *
306      * Emits an `Approval` event.
307      */
308     function approve(address spender, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Moves `amount` tokens from `sender` to `recipient` using the
312      * allowance mechanism. `amount` is then deducted from the caller's
313      * allowance.
314      *
315      * Returns a boolean value indicating whether the operation succeeded.
316      *
317      * Emits a `Transfer` event.
318      */
319     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
320 
321     /**
322      * @dev Emitted when `value` tokens are moved from one account (`from`) to
323      * another (`to`).
324      *
325      * Note that `value` may be zero.
326      */
327     event Transfer(address indexed from, address indexed to, uint256 value);
328 
329     /**
330      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
331      * a call to `approve`. `value` is the new allowance.
332      */
333     event Approval(address indexed owner, address indexed spender, uint256 value);
334 }
335 
336 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
337 
338 
339 /**
340  * @dev Wrappers over Solidity's arithmetic operations with added overflow
341  * checks.
342  *
343  * Arithmetic operations in Solidity wrap on overflow. This can easily result
344  * in bugs, because programmers usually assume that an overflow raises an
345  * error, which is the standard behavior in high level programming languages.
346  * `SafeMath` restores this intuition by reverting the transaction when an
347  * operation overflows.
348  *
349  * Using this library instead of the unchecked operations eliminates an entire
350  * class of bugs, so it's recommended to use it always.
351  */
352 library SafeMath {
353     /**
354      * @dev Returns the addition of two unsigned integers, reverting on
355      * overflow.
356      *
357      * Counterpart to Solidity's `+` operator.
358      *
359      * Requirements:
360      * - Addition cannot overflow.
361      */
362     function add(uint256 a, uint256 b) internal pure returns (uint256) {
363         uint256 c = a + b;
364         require(c >= a, "SafeMath: addition overflow");
365 
366         return c;
367     }
368 
369     /**
370      * @dev Returns the subtraction of two unsigned integers, reverting on
371      * overflow (when the result is negative).
372      *
373      * Counterpart to Solidity's `-` operator.
374      *
375      * Requirements:
376      * - Subtraction cannot overflow.
377      */
378     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
379         require(b <= a, "SafeMath: subtraction overflow");
380         uint256 c = a - b;
381 
382         return c;
383     }
384 
385     /**
386      * @dev Returns the multiplication of two unsigned integers, reverting on
387      * overflow.
388      *
389      * Counterpart to Solidity's `*` operator.
390      *
391      * Requirements:
392      * - Multiplication cannot overflow.
393      */
394     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
395         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
396         // benefit is lost if 'b' is also tested.
397         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
398         if (a == 0) {
399             return 0;
400         }
401 
402         uint256 c = a * b;
403         require(c / a == b, "SafeMath: multiplication overflow");
404 
405         return c;
406     }
407 
408     /**
409      * @dev Returns the integer division of two unsigned integers. Reverts on
410      * division by zero. The result is rounded towards zero.
411      *
412      * Counterpart to Solidity's `/` operator. Note: this function uses a
413      * `revert` opcode (which leaves remaining gas untouched) while Solidity
414      * uses an invalid opcode to revert (consuming all remaining gas).
415      *
416      * Requirements:
417      * - The divisor cannot be zero.
418      */
419     function div(uint256 a, uint256 b) internal pure returns (uint256) {
420         // Solidity only automatically asserts when dividing by 0
421         require(b > 0, "SafeMath: division by zero");
422         uint256 c = a / b;
423         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
424 
425         return c;
426     }
427 
428     /**
429      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
430      * Reverts when dividing by zero.
431      *
432      * Counterpart to Solidity's `%` operator. This function uses a `revert`
433      * opcode (which leaves remaining gas untouched) while Solidity uses an
434      * invalid opcode to revert (consuming all remaining gas).
435      *
436      * Requirements:
437      * - The divisor cannot be zero.
438      */
439     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
440         require(b != 0, "SafeMath: modulo by zero");
441         return a % b;
442     }
443 }
444 
445 // File: openzeppelin-solidity/contracts/utils/Address.sol
446 
447 
448 /**
449  * @dev Collection of functions related to the address type,
450  */
451 library Address {
452     /**
453      * @dev Returns true if `account` is a contract.
454      *
455      * This test is non-exhaustive, and there may be false-negatives: during the
456      * execution of a contract's constructor, its address will be reported as
457      * not containing a contract.
458      *
459      * > It is unsafe to assume that an address for which this function returns
460      * false is an externally-owned account (EOA) and not a contract.
461      */
462     function isContract(address account) internal view returns (bool) {
463         // This method relies in extcodesize, which returns 0 for contracts in
464         // construction, since the code is only stored at the end of the
465         // constructor execution.
466 
467         uint256 size;
468         // solhint-disable-next-line no-inline-assembly
469         assembly { size := extcodesize(account) }
470         return size > 0;
471     }
472 }
473 
474 // File: openzeppelin-solidity/contracts/introspection/IERC1820Registry.sol
475 
476 
477 /**
478  * @dev Interface of the global ERC1820 Registry, as defined in the
479  * [EIP](https://eips.ethereum.org/EIPS/eip-1820). Accounts may register
480  * implementers for interfaces in this registry, as well as query support.
481  *
482  * Implementers may be shared by multiple accounts, and can also implement more
483  * than a single interface for each account. Contracts can implement interfaces
484  * for themselves, but externally-owned accounts (EOA) must delegate this to a
485  * contract.
486  *
487  * `IERC165` interfaces can also be queried via the registry.
488  *
489  * For an in-depth explanation and source code analysis, see the EIP text.
490  */
491 interface IERC1820Registry {
492     /**
493      * @dev Sets `newManager` as the manager for `account`. A manager of an
494      * account is able to set interface implementers for it.
495      *
496      * By default, each account is its own manager. Passing a value of `0x0` in
497      * `newManager` will reset the manager to this initial state.
498      *
499      * Emits a `ManagerChanged` event.
500      *
501      * Requirements:
502      *
503      * - the caller must be the current manager for `account`.
504      */
505     function setManager(address account, address newManager) external;
506 
507     /**
508      * @dev Returns the manager for `account`.
509      *
510      * See `setManager`.
511      */
512     function getManager(address account) external view returns (address);
513 
514     /**
515      * @dev Sets the `implementer` contract as `account`'s implementer for
516      * `interfaceHash`.
517      *
518      * `account` being the zero address is an alias for the caller's address.
519      * The zero address can also be used in `implementer` to remove an old one.
520      *
521      * See `interfaceHash` to learn how these are created.
522      *
523      * Emits an `InterfaceImplementerSet` event.
524      *
525      * Requirements:
526      *
527      * - the caller must be the current manager for `account`.
528      * - `interfaceHash` must not be an `IERC165` interface id (i.e. it must not
529      * end in 28 zeroes).
530      * - `implementer` must implement `IERC1820Implementer` and return true when
531      * queried for support, unless `implementer` is the caller. See
532      * `IERC1820Implementer.canImplementInterfaceForAddress`.
533      */
534     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
535 
536     /**
537      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
538      * implementer is registered, returns the zero address.
539      *
540      * If `interfaceHash` is an `IERC165` interface id (i.e. it ends with 28
541      * zeroes), `account` will be queried for support of it.
542      *
543      * `account` being the zero address is an alias for the caller's address.
544      */
545     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
546 
547     /**
548      * @dev Returns the interface hash for an `interfaceName`, as defined in the
549      * corresponding
550      * [section of the EIP](https://eips.ethereum.org/EIPS/eip-1820#interface-name).
551      */
552     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
553 
554     /**
555      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
556      *  @param account Address of the contract for which to update the cache.
557      *  @param interfaceId ERC165 interface for which to update the cache.
558      */
559     function updateERC165Cache(address account, bytes4 interfaceId) external;
560 
561     /**
562      *  @notice Checks whether a contract implements an ERC165 interface or not.
563      *  If the result is not cached a direct lookup on the contract address is performed.
564      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
565      *  'updateERC165Cache' with the contract address.
566      *  @param account Address of the contract to check.
567      *  @param interfaceId ERC165 interface to check.
568      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
569      */
570     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
571 
572     /**
573      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
574      *  @param account Address of the contract to check.
575      *  @param interfaceId ERC165 interface to check.
576      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
577      */
578     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
579 
580     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
581 
582     event ManagerChanged(address indexed account, address indexed newManager);
583 }
584 
585 // File: src/erc777/EarnERC777.sol
586 
587 
588 
589 
590 
591 
592 
593 
594 
595 contract EarnERC777 is IERC777, IERC20 {
596     using SafeMath for uint256;
597     using Address for address;
598 
599     struct Balance {
600         uint256 value;
601         uint256 exchangeRate;
602     }
603 
604     uint256 constant RATE_SCALE = 10**18;
605     uint256 constant DECIMAL_SCALE = 10**18;
606 
607     IERC1820Registry internal _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
608 
609     mapping(address => Balance) internal _balances;
610 
611     uint256 internal _totalSupply;
612     uint256 internal _exchangeRate;
613 
614     string internal _name;
615     string internal _symbol;
616     uint8 internal _decimals;
617 
618     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
619     // See https://github.com/ethereum/solidity/issues/4024.
620 
621     // keccak256("ERC777TokensSender")
622     bytes32 constant internal TOKENS_SENDER_INTERFACE_HASH =
623         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
624 
625     // keccak256("ERC777TokensRecipient")
626     bytes32 constant internal TOKENS_RECIPIENT_INTERFACE_HASH =
627         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
628 
629     //Empty, This is only used to respond the defaultOperators query.
630     address[] internal _defaultOperatorsArray;
631 
632     // For each account, a mapping of its operators and revoked default operators.
633     mapping(address => mapping(address => bool)) internal _operators;
634 
635     // ERC20-allowances
636     mapping (address => mapping (address => uint256)) internal _allowances;
637 
638     constructor(
639         string memory symbol,
640         string memory name,
641         uint8 decimals
642     ) public {
643         require(decimals <= 18, "decimals must be less or equal than 18");
644 
645         _name = name;
646         _symbol = symbol;
647         _decimals = decimals;
648 
649         _exchangeRate = 10**18;
650 
651         // register interfaces
652         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
653         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
654     }
655 
656     /**
657      * @dev See `IERC777.name`.
658      */
659     function name() external view returns (string memory) {
660         return _name;
661     }
662 
663     /**
664      * @dev See `IERC777.symbol`.
665      */
666     function symbol() external view returns (string memory) {
667         return _symbol;
668     }
669 
670     /**
671      * @dev See `ERC20Detailed.decimals`.
672      *
673      * Always returns 18, as per the
674      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
675      */
676     function decimals() external view returns (uint8) {
677         return _decimals;
678     }
679 
680     /**
681      * @dev See `IERC777.granularity`.
682      *
683      * This implementation always returns `1`.
684      */
685     function granularity() external view returns (uint256) {
686         return 1;
687     }
688 
689     /**
690      * @dev See `IERC777.totalSupply`.
691      */
692     function totalSupply() external view returns (uint256) {
693         return _totalSupply.div(DECIMAL_SCALE);
694     }
695 
696     /**
697      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
698      */
699     function balanceOf(address who) external view returns (uint256) {
700         return _balanceOf(who);
701     }
702 
703     function _balanceOf(address who) internal view returns (uint256) {
704         return _getBalance(who).value.div(DECIMAL_SCALE);
705     }
706 
707     function accuracyBalanceOf(address who) external view returns (uint256) {
708         return _getBalance(who).value ;
709     }
710 
711     /**
712      * @dev See `IERC777.send`.
713      *
714      * Also emits a `Transfer` event for ERC20 compatibility.
715      */
716     function send(address recipient, uint256 amount, bytes calldata data) external {
717         _send(msg.sender, msg.sender, recipient, amount, data, "", true);
718     }
719 
720     /**
721      * @dev See `IERC20.transfer`.
722      *
723      * Unlike `send`, `recipient` is _not_ required to implement the `tokensReceived`
724      * interface if it is a contract.
725      *
726      * Also emits a `Sent` event.
727      */
728     function transfer(address recipient, uint256 amount) external returns (bool) {
729         return _transfer(recipient, amount);
730     }
731 
732     function _transfer(address recipient, uint256 amount) internal returns (bool) {
733         require(recipient != address(0), "ERC777: transfer to the zero address");
734 
735         address from = msg.sender;
736 
737         _callTokensToSend(from, from, recipient, amount, "", "");
738 
739         _move(from, from, recipient, amount, "", "");
740 
741         _callTokensReceived(from, from, recipient, amount, "", "", false);
742 
743         return true;
744     }
745 
746     /**
747      * @dev See `IERC777.burn`.
748      *
749      * Also emits a `Transfer` event for ERC20 compatibility.
750      */
751     function burn(uint256 amount, bytes calldata data) external {
752         _burn(msg.sender, msg.sender, amount, data, "");
753     }
754 
755     /**
756      * @dev See `IERC777.isOperatorFor`.
757      */
758     function isOperatorFor(
759         address operator,
760         address tokenHolder
761     ) public view returns (bool) {
762         return operator == tokenHolder ||
763             _operators[tokenHolder][operator];
764     }
765 
766     /**
767      * @dev See `IERC777.authorizeOperator`.
768      */
769     function authorizeOperator(address operator) external {
770         require(msg.sender != operator, "ERC777: authorizing self as operator");
771 
772        _operators[msg.sender][operator] = true;
773 
774         emit AuthorizedOperator(operator, msg.sender);
775     }
776 
777     /**
778      * @dev See `IERC777.revokeOperator`.
779      */
780     function revokeOperator(address operator) external {
781         require(operator != msg.sender, "ERC777: revoking self as operator");
782 
783         delete _operators[msg.sender][operator];
784 
785         emit RevokedOperator(operator, msg.sender);
786     }
787 
788     /**
789      * @dev See `IERC777.defaultOperators`.
790      */
791     function defaultOperators() external view returns (address[] memory) {
792         return _defaultOperatorsArray;
793     }
794 
795     /**
796      * @dev See `IERC777.operatorSend`.
797      *
798      * Emits `Sent` and `Transfer` events.
799      */
800     function operatorSend(
801         address sender,
802         address recipient,
803         uint256 amount,
804         bytes calldata data,
805         bytes calldata operatorData
806     ) external {
807         require(isOperatorFor(msg.sender, sender), "ERC777: caller is not an operator for holder");
808         _send(msg.sender, sender, recipient, amount, data, operatorData, true);
809     }
810 
811     /**
812      * @dev See `IERC777.operatorBurn`.
813      *
814      * Emits `Sent` and `Transfer` events.
815      */
816     function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData) external {
817         require(isOperatorFor(msg.sender, account), "ERC777: caller is not an operator for holder");
818         _burn(msg.sender, account, amount, data, operatorData);
819     }
820 
821     /**
822      * @dev See `IERC20.allowance`.
823      *
824      * Note that operator and allowance concepts are orthogonal: operators may
825      * not have allowance, and accounts with allowance may not be operators
826      * themselves.
827      */
828     function allowance(address holder, address spender) external view returns (uint256) {
829         return _allowances[holder][spender];
830     }
831 
832     /**
833      * @dev See `IERC20.approve`.
834      *
835      * Note that accounts cannot have allowance issued by their operators.
836      */
837     function approve(address spender, uint256 value) external returns (bool) {
838         address holder = msg.sender;
839         _approve(holder, spender, value);
840         return true;
841     }
842 
843    /**
844     * @dev See `IERC20.transferFrom`.
845     *
846     * Note that operator and allowance concepts are orthogonal: operators cannot
847     * call `transferFrom` (unless they have allowance), and accounts with
848     * allowance cannot call `operatorSend` (unless they are operators).
849     *
850     * Emits `Sent` and `Transfer` events.
851     */
852     function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) {
853         return _transferFrom(holder, recipient, amount);
854     }
855 
856     function _transferFrom(address holder, address recipient, uint256 amount) internal returns (bool) {
857         require(recipient != address(0), "ERC777: transfer to the zero address");
858         require(holder != address(0), "ERC777: transfer from the zero address");
859 
860         address spender = msg.sender;
861 
862         _callTokensToSend(spender, holder, recipient, amount, "", "");
863 
864         _move(spender, holder, recipient, amount, "", "");
865 
866         _approve(holder, spender, _allowances[holder][spender].sub(amount));
867 
868         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
869 
870         return true;
871     }
872 
873     /**
874      * @dev Creates `amount` tokens and assigns them to `account`, increasing
875      * the total supply.
876      *
877      * If a send hook is registered for `raccount`, the corresponding function
878      * will be called with `operator`, `data` and `operatorData`.
879      *
880      * See `IERC777Sender` and `IERC777Recipient`.
881      *
882      * Emits `Sent` and `Transfer` events.
883      *
884      * Requirements
885      *
886      * - `account` cannot be the zero address.
887      * - if `account` is a contract, it must implement the `tokensReceived`
888      * interface.
889      */
890     function _mint(
891         address operator,
892         address account,
893         uint256 amount,
894         bytes memory userData,
895         bytes memory operatorData
896     )
897     internal
898     {
899         require(account != address(0), "ERC777: mint to the zero address");
900 
901         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, false);
902 
903         uint256 scaleAmount = amount.mul(DECIMAL_SCALE);
904         _totalSupply = _totalSupply.add(scaleAmount);
905         _addBalance(account, scaleAmount);
906 
907         emit Minted(operator, account, amount, userData, operatorData);
908         emit Transfer(address(0), account, amount);
909     }
910 
911     function _getBalance(address account) internal view returns (Balance memory) {
912         Balance memory balance = _balances[account];
913 
914         if (balance.value == uint256(0)) {
915             balance.value = 0;
916             balance.exchangeRate = _exchangeRate;
917         } else if (balance.exchangeRate != _exchangeRate) {
918             balance.value = balance.value.mul(_exchangeRate).div(balance.exchangeRate);
919             balance.exchangeRate = _exchangeRate;
920         }
921 
922         return balance;
923     }
924 
925     function _addBalance(address account, uint256 amount) internal {
926         Balance memory balance = _getBalance(account);
927 
928         balance.value = balance.value.add(amount);
929 
930         _balances[account] = balance;
931     }
932 
933     function _subBalance(address account, uint256 amount) internal {
934         Balance memory balance = _getBalance(account);
935 
936         balance.value = balance.value.sub(amount);
937 
938         _balances[account] = balance;
939     }
940 
941     /**
942      * @dev Send tokens
943      * @param operator address operator requesting the transfer
944      * @param from address token holder address
945      * @param to address recipient address
946      * @param amount uint256 amount of tokens to transfer
947      * @param userData bytes extra information provided by the token holder (if any)
948      * @param operatorData bytes extra information provided by the operator (if any)
949      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
950      */
951     function _send(
952         address operator,
953         address from,
954         address to,
955         uint256 amount,
956         bytes memory userData,
957         bytes memory operatorData,
958         bool requireReceptionAck
959     )
960         internal
961     {
962         require(from != address(0), "ERC777: send from the zero address");
963         require(to != address(0), "ERC777: send to the zero address");
964 
965         _callTokensToSend(operator, from, to, amount, userData, operatorData);
966 
967         _move(operator, from, to, amount, userData, operatorData);
968 
969         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
970     }
971 
972     /**
973      * @dev Burn tokens
974      * @param operator address operator requesting the operation
975      * @param from address token holder address
976      * @param amount uint256 amount of tokens to burn
977      * @param data bytes extra information provided by the token holder
978      * @param operatorData bytes extra information provided by the operator (if any)
979      */
980     function _burn(
981         address operator,
982         address from,
983         uint256 amount,
984         bytes memory data,
985         bytes memory operatorData
986     )
987         internal
988     {
989         require(from != address(0), "ERC777: burn from the zero address");
990 
991         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
992 
993         uint256 scaleAmount = amount.mul(DECIMAL_SCALE);
994 
995         _totalSupply = _totalSupply.sub(scaleAmount);
996         _subBalance(from, scaleAmount);
997 
998         emit Burned(operator, from, amount, data, operatorData);
999         emit Transfer(from, address(0), amount);
1000     }
1001 
1002     function _move(
1003         address operator,
1004         address from,
1005         address to,
1006         uint256 amount,
1007         bytes memory userData,
1008         bytes memory operatorData
1009     )
1010         internal
1011     {
1012         uint256 scaleAmount = amount.mul(DECIMAL_SCALE);
1013 
1014         _subBalance(from,scaleAmount);
1015         _addBalance(to,scaleAmount);
1016 
1017         emit Sent(operator, from, to, amount, userData, operatorData);
1018         emit Transfer(from, to, amount);
1019     }
1020 
1021     function _approve(address holder, address spender, uint256 value) internal {
1022         // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
1023         // currently unnecessary.
1024         //require(holder != address(0), "ERC777: approve from the zero address");
1025         require(spender != address(0), "ERC777: approve to the zero address");
1026 
1027         _allowances[holder][spender] = value;
1028         emit Approval(holder, spender, value);
1029     }
1030 
1031     /**
1032      * @dev Call from.tokensToSend() if the interface is registered
1033      * @param operator address operator requesting the transfer
1034      * @param from address token holder address
1035      * @param to address recipient address
1036      * @param amount uint256 amount of tokens to transfer
1037      * @param userData bytes extra information provided by the token holder (if any)
1038      * @param operatorData bytes extra information provided by the operator (if any)
1039      */
1040     function _callTokensToSend(
1041         address operator,
1042         address from,
1043         address to,
1044         uint256 amount,
1045         bytes memory userData,
1046         bytes memory operatorData
1047     )
1048         internal
1049     {
1050         address implementer = _erc1820.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1051         if (implementer != address(0)) {
1052             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1053         }
1054     }
1055 
1056     /**
1057      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1058      * tokensReceived() was not registered for the recipient
1059      * @param operator address operator requesting the transfer
1060      * @param from address token holder address
1061      * @param to address recipient address
1062      * @param amount uint256 amount of tokens to transfer
1063      * @param userData bytes extra information provided by the token holder (if any)
1064      * @param operatorData bytes extra information provided by the operator (if any)
1065      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1066      */
1067     function _callTokensReceived(
1068         address operator,
1069         address from,
1070         address to,
1071         uint256 amount,
1072         bytes memory userData,
1073         bytes memory operatorData,
1074         bool requireReceptionAck
1075     )
1076         internal
1077     {
1078         address implementer = _erc1820.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1079         if (implementer != address(0)) {
1080             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1081         } else if (requireReceptionAck) {
1082             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1083         }
1084     }
1085 
1086     function _distributeRevenue(address account) internal returns (bool) {
1087         uint256 value = _getBalance(account).value;
1088 
1089         require(value > 0, 'Token: the revenue balance must be large than zero');
1090         require(_totalSupply > value, 'Token: total supply must be large than revenue');
1091 
1092         delete _balances[account];
1093 
1094         _exchangeRate = _exchangeRate.mul(_totalSupply.mul(RATE_SCALE).div(_totalSupply.sub(value))).div(RATE_SCALE);
1095 
1096         emit Transfer(account, address(0), value.div(DECIMAL_SCALE));
1097         emit RevenueDistributed(account, _exchangeRate, value.div(DECIMAL_SCALE), value.mod(DECIMAL_SCALE));
1098 
1099         return true;
1100     }
1101 
1102     function exchangeRate() external view returns (uint256) {
1103         return _exchangeRate;
1104     }
1105 
1106     event RevenueDistributed(address indexed account, uint256 exchangeRate, uint256 value, uint256 remainder);
1107 }
1108 
1109 // File: openzeppelin-solidity/contracts/access/Roles.sol
1110 
1111 
1112 /**
1113  * @title Roles
1114  * @dev Library for managing addresses assigned to a Role.
1115  */
1116 library Roles {
1117     struct Role {
1118         mapping (address => bool) bearer;
1119     }
1120 
1121     /**
1122      * @dev Give an account access to this role.
1123      */
1124     function add(Role storage role, address account) internal {
1125         require(!has(role, account), "Roles: account already has role");
1126         role.bearer[account] = true;
1127     }
1128 
1129     /**
1130      * @dev Remove an account's access to this role.
1131      */
1132     function remove(Role storage role, address account) internal {
1133         require(has(role, account), "Roles: account does not have role");
1134         role.bearer[account] = false;
1135     }
1136 
1137     /**
1138      * @dev Check if an account has this role.
1139      * @return bool
1140      */
1141     function has(Role storage role, address account) internal view returns (bool) {
1142         require(account != address(0), "Roles: account is the zero address");
1143         return role.bearer[account];
1144     }
1145 }
1146 
1147 // File: src/Ownable.sol
1148 
1149 
1150 /**
1151  * @dev Contract module which provides a basic access control mechanism, where
1152  * there is an account (an owner) that can be granted exclusive access to
1153  * specific functions.
1154  *
1155  * This module is used through inheritance. It will make available the modifier
1156  * `onlyOwner`, which can be aplied to your functions to restrict their use to
1157  * the owner.
1158  */
1159 contract Ownable {
1160     address private _owner;
1161     address private _newOwner;
1162 
1163     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1164 
1165     /**
1166      * @dev Initializes the contract setting the deployer as the initial owner.
1167      */
1168     constructor () internal {
1169         _owner = msg.sender;
1170         emit OwnershipTransferred(address(0), _owner);
1171     }
1172 
1173     /**
1174      * @dev Returns the address of the current owner.
1175      */
1176     function owner() public view returns (address) {
1177         return _owner;
1178     }
1179 
1180     /**
1181      * @dev Returns the address of the new owner will be set
1182      */
1183      function newOwner() public view returns (address) {
1184         return _newOwner;
1185      }
1186 
1187     /**
1188      * @dev Throws if called by any account other than the owner.
1189      */
1190     modifier onlyOwner() {
1191         require(isOwner(), "Ownable: caller is not the owner");
1192         _;
1193     }
1194 
1195     /**
1196      * @dev Returns true if the caller is the current owner.
1197      */
1198     function isOwner() public view returns (bool) {
1199         return msg.sender == _owner;
1200     }
1201 
1202     /**
1203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1204      * Can only be called by the current owner.
1205      */
1206     function transferOwnership(address account) public onlyOwner {
1207         _transferOwnership(account);
1208     }
1209 
1210     /**
1211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1212      */
1213     function _transferOwnership(address account) internal {
1214         require(account != address(0), "Ownable: new owner is the zero address");
1215         require(account != _newOwner, "Ownable: new owner is the same as previous owner");
1216 
1217         _newOwner = account;
1218     }
1219 
1220     /**
1221      * @dev Transfers ownership of the contract to a new account (‘ newOwner ‘).
1222      * Can only be called by the current owner .
1223      */
1224     function acceptOwnership() public {
1225         require(msg.sender == _newOwner, "Ownable: msg.sender is not the same as newOwner");
1226 
1227         emit OwnershipTransferred(_owner, _newOwner);
1228 
1229         _owner = _newOwner;
1230         _newOwner = address(0);
1231     }
1232 }
1233 
1234 // File: src/MinterRole.sol
1235 
1236 
1237 
1238 
1239  contract MinterRole is Ownable {
1240      using Roles for Roles.Role;
1241 
1242      event MinterAdded(address indexed operator, address indexed account);
1243      event MinterRemoved(address indexed operator, address indexed account);
1244 
1245      Roles.Role private _minters;
1246 
1247      constructor () internal {
1248          _addMinter(msg.sender);
1249      }
1250 
1251      modifier onlyMinter() {
1252          require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
1253          _;
1254      }
1255 
1256      function isMinter(address account) public view returns (bool) {
1257          return _minters.has(account);
1258      }
1259 
1260      function addMinter(address account) public onlyOwner {
1261          _addMinter(account);
1262      }
1263 
1264      function removeMinter(address account) public onlyOwner {
1265          _removeMinter(account);
1266      }
1267 
1268      function _addMinter(address account) internal {
1269          _minters.add(account);
1270          emit MinterAdded(msg.sender, account);
1271      }
1272 
1273      function _removeMinter(address account) internal {
1274          _minters.remove(account);
1275          emit MinterRemoved(msg.sender, account);
1276      }
1277  }
1278 
1279 // File: src/Pausable.sol
1280 
1281 
1282 
1283 /**
1284  * @dev Contract module which allows children to implement an emergency stop
1285  * mechanism that can be triggered by an authorized account.
1286  *
1287  * This module is used through inheritance. It will make available the
1288  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1289  * the functions of your contract. Note that they will not be pausable by
1290  * simply including this module, only once the modifiers are put in place.
1291  */
1292 contract Pausable is Ownable {
1293     /**
1294      * @dev Emitted when the pause is triggered by a pauser (`account`).
1295      */
1296     event Paused(address indexed account);
1297 
1298     /**
1299      * @dev Emitted when the pause is lifted by a pauser (`account`).
1300      */
1301     event Unpaused(address indexed account);
1302 
1303     bool private _paused;
1304 
1305     /**
1306      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1307      * to the deployer.
1308      */
1309     constructor () internal {
1310         _paused = false;
1311     }
1312 
1313     /**
1314      * @dev Returns true if the contract is paused, and false otherwise.
1315      */
1316     function paused() public view returns (bool) {
1317         return _paused;
1318     }
1319 
1320     /**
1321      * @dev Modifier to make a function callable only when the contract is not paused.
1322      */
1323     modifier whenNotPaused() {
1324         require(!_paused, "Pausable: paused");
1325         _;
1326     }
1327 
1328     /**
1329      * @dev Modifier to make a function callable only when the contract is paused.
1330      */
1331     modifier whenPaused() {
1332         require(_paused, "Pausable: not paused");
1333         _;
1334     }
1335 
1336     /**
1337      * @dev Called by a pauser to pause, triggers stopped state.
1338      */
1339     function pause() public onlyOwner whenNotPaused {
1340         _paused = true;
1341         emit Paused(msg.sender);
1342     }
1343 
1344     /**
1345      * @dev Called by a pauser to unpause, returns to normal state.
1346      */
1347     function unpause() public onlyOwner whenPaused {
1348         _paused = false;
1349         emit Unpaused(msg.sender);
1350     }
1351 }
1352 
1353 // File: src/SwitchTransferable.sol
1354 
1355 
1356 
1357 contract SwitchTransferable is Ownable {
1358     event TransferEnabled(address indexed operator);
1359     event TransferDisabled(address indexed operator);
1360 
1361     bool private _transferable;
1362 
1363     constructor () internal {
1364         _transferable = false;
1365     }
1366 
1367     modifier whenTransferable() {
1368         require(_transferable, "transferable must be true");
1369         _;
1370     }
1371 
1372     modifier whenNotTransferable() {
1373         require(!_transferable, "transferable must not be true");
1374         _;
1375     }
1376 
1377     function transferable() public view returns (bool) {
1378         return _transferable;
1379     }
1380 
1381     function enableTransfer() public onlyOwner whenNotTransferable {
1382         _transferable = true;
1383         emit TransferEnabled(msg.sender);
1384     }
1385 
1386     function disableTransfer() public onlyOwner whenTransferable {
1387         _transferable = false;
1388         emit TransferDisabled(msg.sender);
1389     }
1390 }
1391 
1392 // File: src/IMBTC.sol
1393 
1394 
1395 
1396 
1397 
1398 
1399 contract IMBTC is EarnERC777, MinterRole, Pausable, SwitchTransferable {
1400     address internal _revenueAddress;
1401 
1402     constructor() EarnERC777("imBTC","The Tokenized Bitcoin",8) public {
1403     }
1404 
1405     function transfer(address recipient, uint256 amount) external whenNotPaused whenTransferable returns (bool) {
1406         return super._transfer(recipient, amount);
1407     }
1408 
1409     function send(address recipient, uint256 amount, bytes calldata data) external whenTransferable whenNotPaused {
1410         super._send(msg.sender, msg.sender, recipient, amount, data, "", true);
1411     }
1412 
1413     function burn(uint256 amount, bytes calldata data) external whenTransferable whenNotPaused {
1414         super._burn(msg.sender, msg.sender, amount, data, "");
1415     }
1416 
1417     function operatorSend(
1418         address sender,
1419         address recipient,
1420         uint256 amount,
1421         bytes calldata data,
1422         bytes calldata operatorData
1423     ) external whenTransferable whenNotPaused {
1424         require(isOperatorFor(msg.sender, sender), "ERC777: caller is not an operator for holder");
1425         super._send(msg.sender, sender, recipient, amount, data, operatorData, true);
1426     }
1427 
1428     function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData)
1429         external whenTransferable whenNotPaused {
1430         require(isOperatorFor(msg.sender, account), "ERC777: caller is not an operator for holder");
1431         super._burn(msg.sender, account, amount, data, operatorData);
1432     }
1433 
1434     function mint(address recipient, uint256 amount,
1435             bytes calldata userData, bytes calldata operatorData) external onlyMinter whenNotPaused {
1436         super._mint(msg.sender, recipient, amount, userData, operatorData);
1437     }
1438 
1439     function transferFrom(address holder, address recipient, uint256 amount) external whenNotPaused returns (bool) {
1440         require(transferable(), "Token: transferable must be true");
1441         return super._transferFrom(holder, recipient, amount);
1442    }
1443 
1444    function setRevenueAddress(address account) external onlyOwner {
1445        require(_allowances[account][address(this)] > 0, "Token: the allowances of account must be large than zero");
1446 
1447        _revenueAddress = account;
1448 
1449        emit RevenueAddressSet(account);
1450    }
1451 
1452    function revenueAddress() external view returns (address) {
1453        return _revenueAddress;
1454    }
1455 
1456    function revenue() external view returns (uint256) {
1457        return _balanceOf(_revenueAddress);
1458    }
1459 
1460    event RevenueAddressSet(address indexed account);
1461 
1462    function distributeRevenue() external whenNotPaused {
1463        require(_revenueAddress != address(0), 'Token: revenue address must not be zero');
1464 
1465        _distributeRevenue(_revenueAddress);
1466    }
1467 }