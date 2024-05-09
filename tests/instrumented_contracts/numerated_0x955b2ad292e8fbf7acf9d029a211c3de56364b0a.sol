1 // File: src\contracts\open-zeppelin-contracts\token\ERC777\IERC777.sol
2 
3 pragma solidity ^0.5.0;
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
190 // File: src\contracts\open-zeppelin-contracts\token\ERC777\IERC777Recipient.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
196  *
197  * Accounts can be notified of `IERC777` tokens being sent to them by having a
198  * contract implement this interface (contract holders can be their own
199  * implementer) and registering it on the
200  * [ERC1820 global registry](https://eips.ethereum.org/EIPS/eip-1820).
201  *
202  * See `IERC1820Registry` and `ERC1820Implementer`.
203  */
204 interface IERC777Recipient {
205     /**
206      * @dev Called by an `IERC777` token contract whenever tokens are being
207      * moved or created into a registered account (`to`). The type of operation
208      * is conveyed by `from` being the zero address or not.
209      *
210      * This call occurs _after_ the token contract's state is updated, so
211      * `IERC777.balanceOf`, etc., can be used to query the post-operation state.
212      *
213      * This function may revert to prevent the operation from being executed.
214      */
215     function tokensReceived(
216         address operator,
217         address from,
218         address to,
219         uint256 amount,
220         bytes calldata userData,
221         bytes calldata operatorData
222     ) external;
223 }
224 
225 // File: src\contracts\open-zeppelin-contracts\token\ERC777\IERC777Sender.sol
226 
227 pragma solidity ^0.5.0;
228 
229 /**
230  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
231  *
232  * `IERC777` Token holders can be notified of operations performed on their
233  * tokens by having a contract implement this interface (contract holders can be
234  *  their own implementer) and registering it on the
235  * [ERC1820 global registry](https://eips.ethereum.org/EIPS/eip-1820).
236  *
237  * See `IERC1820Registry` and `ERC1820Implementer`.
238  */
239 interface IERC777Sender {
240     /**
241      * @dev Called by an `IERC777` token contract whenever a registered holder's
242      * (`from`) tokens are about to be moved or destroyed. The type of operation
243      * is conveyed by `to` being the zero address or not.
244      *
245      * This call occurs _before_ the token contract's state is updated, so
246      * `IERC777.balanceOf`, etc., can be used to query the pre-operation state.
247      *
248      * This function may revert to prevent the operation from being executed.
249      */
250     function tokensToSend(
251         address operator,
252         address from,
253         address to,
254         uint256 amount,
255         bytes calldata userData,
256         bytes calldata operatorData
257     ) external;
258 }
259 
260 // File: src\contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
261 
262 pragma solidity ^0.5.0;
263 
264 /**
265  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
266  * the optional functions; to access them see `ERC20Detailed`.
267  */
268 interface IERC20 {
269     /**
270      * @dev Returns the amount of tokens in existence.
271      */
272     function totalSupply() external view returns (uint256);
273 
274     /**
275      * @dev Returns the amount of tokens owned by `account`.
276      */
277     function balanceOf(address account) external view returns (uint256);
278 
279     /**
280      * @dev Moves `amount` tokens from the caller's account to `recipient`.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * Emits a `Transfer` event.
285      */
286     function transfer(address recipient, uint256 amount) external returns (bool);
287 
288     /**
289      * @dev Returns the remaining number of tokens that `spender` will be
290      * allowed to spend on behalf of `owner` through `transferFrom`. This is
291      * zero by default.
292      *
293      * This value changes when `approve` or `transferFrom` are called.
294      */
295     function allowance(address owner, address spender) external view returns (uint256);
296 
297     /**
298      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * > Beware that changing an allowance with this method brings the risk
303      * that someone may use both the old and the new allowance by unfortunate
304      * transaction ordering. One possible solution to mitigate this race
305      * condition is to first reduce the spender's allowance to 0 and set the
306      * desired value afterwards:
307      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308      *
309      * Emits an `Approval` event.
310      */
311     function approve(address spender, uint256 amount) external returns (bool);
312 
313     /**
314      * @dev Moves `amount` tokens from `sender` to `recipient` using the
315      * allowance mechanism. `amount` is then deducted from the caller's
316      * allowance.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * Emits a `Transfer` event.
321      */
322     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Emitted when `value` tokens are moved from one account (`from`) to
326      * another (`to`).
327      *
328      * Note that `value` may be zero.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 value);
331 
332     /**
333      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
334      * a call to `approve`. `value` is the new allowance.
335      */
336     event Approval(address indexed owner, address indexed spender, uint256 value);
337 }
338 
339 // File: src\contracts\open-zeppelin-contracts\math\SafeMath.sol
340 
341 pragma solidity ^0.5.0;
342 
343 /**
344  * @dev Wrappers over Solidity's arithmetic operations with added overflow
345  * checks.
346  *
347  * Arithmetic operations in Solidity wrap on overflow. This can easily result
348  * in bugs, because programmers usually assume that an overflow raises an
349  * error, which is the standard behavior in high level programming languages.
350  * `SafeMath` restores this intuition by reverting the transaction when an
351  * operation overflows.
352  *
353  * Using this library instead of the unchecked operations eliminates an entire
354  * class of bugs, so it's recommended to use it always.
355  */
356 library SafeMath {
357     /**
358      * @dev Returns the addition of two unsigned integers, reverting on
359      * overflow.
360      *
361      * Counterpart to Solidity's `+` operator.
362      *
363      * Requirements:
364      * - Addition cannot overflow.
365      */
366     function add(uint256 a, uint256 b) internal pure returns (uint256) {
367         uint256 c = a + b;
368         require(c >= a, "SafeMath: addition overflow");
369 
370         return c;
371     }
372 
373     /**
374      * @dev Returns the subtraction of two unsigned integers, reverting on
375      * overflow (when the result is negative).
376      *
377      * Counterpart to Solidity's `-` operator.
378      *
379      * Requirements:
380      * - Subtraction cannot overflow.
381      */
382     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
383         require(b <= a, "SafeMath: subtraction overflow");
384         uint256 c = a - b;
385 
386         return c;
387     }
388 
389     /**
390      * @dev Returns the multiplication of two unsigned integers, reverting on
391      * overflow.
392      *
393      * Counterpart to Solidity's `*` operator.
394      *
395      * Requirements:
396      * - Multiplication cannot overflow.
397      */
398     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
399         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
400         // benefit is lost if 'b' is also tested.
401         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
402         if (a == 0) {
403             return 0;
404         }
405 
406         uint256 c = a * b;
407         require(c / a == b, "SafeMath: multiplication overflow");
408 
409         return c;
410     }
411 
412     /**
413      * @dev Returns the integer division of two unsigned integers. Reverts on
414      * division by zero. The result is rounded towards zero.
415      *
416      * Counterpart to Solidity's `/` operator. Note: this function uses a
417      * `revert` opcode (which leaves remaining gas untouched) while Solidity
418      * uses an invalid opcode to revert (consuming all remaining gas).
419      *
420      * Requirements:
421      * - The divisor cannot be zero.
422      */
423     function div(uint256 a, uint256 b) internal pure returns (uint256) {
424         // Solidity only automatically asserts when dividing by 0
425         require(b > 0, "SafeMath: division by zero");
426         uint256 c = a / b;
427         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
428 
429         return c;
430     }
431 
432     /**
433      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
434      * Reverts when dividing by zero.
435      *
436      * Counterpart to Solidity's `%` operator. This function uses a `revert`
437      * opcode (which leaves remaining gas untouched) while Solidity uses an
438      * invalid opcode to revert (consuming all remaining gas).
439      *
440      * Requirements:
441      * - The divisor cannot be zero.
442      */
443     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
444         require(b != 0, "SafeMath: modulo by zero");
445         return a % b;
446     }
447 }
448 
449 // File: src\contracts\open-zeppelin-contracts\utils\Address.sol
450 
451 pragma solidity ^0.5.0;
452 
453 /**
454  * @dev Collection of functions related to the address type
455  */
456 library Address {
457     /**
458      * @dev Returns true if `account` is a contract.
459      *
460      * This test is non-exhaustive, and there may be false-negatives: during the
461      * execution of a contract's constructor, its address will be reported as
462      * not containing a contract.
463      *
464      * > It is unsafe to assume that an address for which this function returns
465      * false is an externally-owned account (EOA) and not a contract.
466      */
467     function isContract(address account) internal view returns (bool) {
468         // This method relies in extcodesize, which returns 0 for contracts in
469         // construction, since the code is only stored at the end of the
470         // constructor execution.
471 
472         uint256 size;
473         // solhint-disable-next-line no-inline-assembly
474         assembly { size := extcodesize(account) }
475         return size > 0;
476     }
477 
478     /**
479      * @dev Converts an `address` into `address payable`. Note that this is
480      * simply a type cast: the actual underlying value is not changed.
481      */
482     function toPayable(address account) internal pure returns (address payable) {
483         return address(uint160(account));
484     }
485 }
486 
487 // File: src\contracts\open-zeppelin-contracts\introspection\IERC1820Registry.sol
488 
489 pragma solidity ^0.5.0;
490 
491 /**
492  * @dev Interface of the global ERC1820 Registry, as defined in the
493  * [EIP](https://eips.ethereum.org/EIPS/eip-1820). Accounts may register
494  * implementers for interfaces in this registry, as well as query support.
495  *
496  * Implementers may be shared by multiple accounts, and can also implement more
497  * than a single interface for each account. Contracts can implement interfaces
498  * for themselves, but externally-owned accounts (EOA) must delegate this to a
499  * contract.
500  *
501  * `IERC165` interfaces can also be queried via the registry.
502  *
503  * For an in-depth explanation and source code analysis, see the EIP text.
504  */
505 interface IERC1820Registry {
506     /**
507      * @dev Sets `newManager` as the manager for `account`. A manager of an
508      * account is able to set interface implementers for it.
509      *
510      * By default, each account is its own manager. Passing a value of `0x0` in
511      * `newManager` will reset the manager to this initial state.
512      *
513      * Emits a `ManagerChanged` event.
514      *
515      * Requirements:
516      *
517      * - the caller must be the current manager for `account`.
518      */
519     function setManager(address account, address newManager) external;
520 
521     /**
522      * @dev Returns the manager for `account`.
523      *
524      * See `setManager`.
525      */
526     function getManager(address account) external view returns (address);
527 
528     /**
529      * @dev Sets the `implementer` contract as `account`'s implementer for
530      * `interfaceHash`.
531      *
532      * `account` being the zero address is an alias for the caller's address.
533      * The zero address can also be used in `implementer` to remove an old one.
534      *
535      * See `interfaceHash` to learn how these are created.
536      *
537      * Emits an `InterfaceImplementerSet` event.
538      *
539      * Requirements:
540      *
541      * - the caller must be the current manager for `account`.
542      * - `interfaceHash` must not be an `IERC165` interface id (i.e. it must not
543      * end in 28 zeroes).
544      * - `implementer` must implement `IERC1820Implementer` and return true when
545      * queried for support, unless `implementer` is the caller. See
546      * `IERC1820Implementer.canImplementInterfaceForAddress`.
547      */
548     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
549 
550     /**
551      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
552      * implementer is registered, returns the zero address.
553      *
554      * If `interfaceHash` is an `IERC165` interface id (i.e. it ends with 28
555      * zeroes), `account` will be queried for support of it.
556      *
557      * `account` being the zero address is an alias for the caller's address.
558      */
559     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
560 
561     /**
562      * @dev Returns the interface hash for an `interfaceName`, as defined in the
563      * corresponding
564      * [section of the EIP](https://eips.ethereum.org/EIPS/eip-1820#interface-name).
565      */
566     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
567 
568     /**
569      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
570      *  @param account Address of the contract for which to update the cache.
571      *  @param interfaceId ERC165 interface for which to update the cache.
572      */
573     function updateERC165Cache(address account, bytes4 interfaceId) external;
574 
575     /**
576      *  @notice Checks whether a contract implements an ERC165 interface or not.
577      *  If the result is not cached a direct lookup on the contract address is performed.
578      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
579      *  'updateERC165Cache' with the contract address.
580      *  @param account Address of the contract to check.
581      *  @param interfaceId ERC165 interface to check.
582      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
583      */
584     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
585 
586     /**
587      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
588      *  @param account Address of the contract to check.
589      *  @param interfaceId ERC165 interface to check.
590      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
591      */
592     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
593 
594     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
595 
596     event ManagerChanged(address indexed account, address indexed newManager);
597 }
598 
599 // File: src\contracts\open-zeppelin-contracts\token\ERC777\ERC777.sol
600 
601 pragma solidity ^0.5.0;
602 
603 
604 
605 
606 
607 
608 
609 
610 /**
611  * @dev Implementation of the `IERC777` interface.
612  *
613  * This implementation is agnostic to the way tokens are created. This means
614  * that a supply mechanism has to be added in a derived contract using `_mint`.
615  *
616  * Support for ERC20 is included in this contract, as specified by the EIP: both
617  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
618  * Both `IERC777.Sent` and `IERC20.Transfer` events are emitted on token
619  * movements.
620  *
621  * Additionally, the `granularity` value is hard-coded to `1`, meaning that there
622  * are no special restrictions in the amount of tokens that created, moved, or
623  * destroyed. This makes integration with ERC20 applications seamless.
624  */
625 contract ERC777 is IERC777, IERC20 {
626     using SafeMath for uint256;
627     using Address for address;
628 
629     IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
630 
631     mapping(address => uint256) private _balances;
632 
633     uint256 private _totalSupply;
634 
635     string private _name;
636     string private _symbol;
637 
638     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
639     // See https://github.com/ethereum/solidity/issues/4024.
640 
641     // keccak256("ERC777TokensSender")
642     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
643         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
644 
645     // keccak256("ERC777TokensRecipient")
646     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
647         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
648 
649     // This isn't ever read from - it's only used to respond to the defaultOperators query.
650     address[] private _defaultOperatorsArray;
651 
652     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
653     mapping(address => bool) private _defaultOperators;
654 
655     // For each account, a mapping of its operators and revoked default operators.
656     mapping(address => mapping(address => bool)) private _operators;
657     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
658 
659     // ERC20-allowances
660     mapping (address => mapping (address => uint256)) private _allowances;
661 
662     /**
663      * @dev `defaultOperators` may be an empty array.
664      */
665     constructor(
666         string memory name,
667         string memory symbol,
668         address[] memory defaultOperators
669     ) public {
670         _name = name;
671         _symbol = symbol;
672 
673         _defaultOperatorsArray = defaultOperators;
674         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
675             _defaultOperators[_defaultOperatorsArray[i]] = true;
676         }
677 
678         // register interfaces
679         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
680         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
681     }
682 
683     /**
684      * @dev See `IERC777.name`.
685      */
686     function name() public view returns (string memory) {
687         return _name;
688     }
689 
690     /**
691      * @dev See `IERC777.symbol`.
692      */
693     function symbol() public view returns (string memory) {
694         return _symbol;
695     }
696 
697     /**
698      * @dev See `ERC20Detailed.decimals`.
699      *
700      * Always returns 18, as per the
701      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
702      */
703     function decimals() public pure returns (uint8) {
704         return 18;
705     }
706 
707     /**
708      * @dev See `IERC777.granularity`.
709      *
710      * This implementation always returns `1`.
711      */
712     function granularity() public view returns (uint256) {
713         return 1;
714     }
715 
716     /**
717      * @dev See `IERC777.totalSupply`.
718      */
719     function totalSupply() public view returns (uint256) {
720         return _totalSupply;
721     }
722 
723     /**
724      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
725      */
726     function balanceOf(address tokenHolder) public view returns (uint256) {
727         return _balances[tokenHolder];
728     }
729 
730     /**
731      * @dev See `IERC777.send`.
732      *
733      * Also emits a `Transfer` event for ERC20 compatibility.
734      */
735     function send(address recipient, uint256 amount, bytes calldata data) external {
736         _send(msg.sender, msg.sender, recipient, amount, data, "", true);
737     }
738 
739     /**
740      * @dev See `IERC20.transfer`.
741      *
742      * Unlike `send`, `recipient` is _not_ required to implement the `tokensReceived`
743      * interface if it is a contract.
744      *
745      * Also emits a `Sent` event.
746      */
747     function transfer(address recipient, uint256 amount) external returns (bool) {
748         require(recipient != address(0), "ERC777: transfer to the zero address");
749 
750         address from = msg.sender;
751 
752         _callTokensToSend(from, from, recipient, amount, "", "");
753 
754         _move(from, from, recipient, amount, "", "");
755 
756         _callTokensReceived(from, from, recipient, amount, "", "", false);
757 
758         return true;
759     }
760 
761     /**
762      * @dev See `IERC777.burn`.
763      *
764      * Also emits a `Transfer` event for ERC20 compatibility.
765      */
766     function burn(uint256 amount, bytes calldata data) external {
767         _burn(msg.sender, msg.sender, amount, data, "");
768     }
769 
770     /**
771      * @dev See `IERC777.isOperatorFor`.
772      */
773     function isOperatorFor(
774         address operator,
775         address tokenHolder
776     ) public view returns (bool) {
777         return operator == tokenHolder ||
778             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
779             _operators[tokenHolder][operator];
780     }
781 
782     /**
783      * @dev See `IERC777.authorizeOperator`.
784      */
785     function authorizeOperator(address operator) external {
786         require(msg.sender != operator, "ERC777: authorizing self as operator");
787 
788         if (_defaultOperators[operator]) {
789             delete _revokedDefaultOperators[msg.sender][operator];
790         } else {
791             _operators[msg.sender][operator] = true;
792         }
793 
794         emit AuthorizedOperator(operator, msg.sender);
795     }
796 
797     /**
798      * @dev See `IERC777.revokeOperator`.
799      */
800     function revokeOperator(address operator) external {
801         require(operator != msg.sender, "ERC777: revoking self as operator");
802 
803         if (_defaultOperators[operator]) {
804             _revokedDefaultOperators[msg.sender][operator] = true;
805         } else {
806             delete _operators[msg.sender][operator];
807         }
808 
809         emit RevokedOperator(operator, msg.sender);
810     }
811 
812     /**
813      * @dev See `IERC777.defaultOperators`.
814      */
815     function defaultOperators() public view returns (address[] memory) {
816         return _defaultOperatorsArray;
817     }
818 
819     /**
820      * @dev See `IERC777.operatorSend`.
821      *
822      * Emits `Sent` and `Transfer` events.
823      */
824     function operatorSend(
825         address sender,
826         address recipient,
827         uint256 amount,
828         bytes calldata data,
829         bytes calldata operatorData
830     )
831     external
832     {
833         require(isOperatorFor(msg.sender, sender), "ERC777: caller is not an operator for holder");
834         _send(msg.sender, sender, recipient, amount, data, operatorData, true);
835     }
836 
837     /**
838      * @dev See `IERC777.operatorBurn`.
839      *
840      * Emits `Burned` and `Transfer` events.
841      */
842     function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData) external {
843         require(isOperatorFor(msg.sender, account), "ERC777: caller is not an operator for holder");
844         _burn(msg.sender, account, amount, data, operatorData);
845     }
846 
847     /**
848      * @dev See `IERC20.allowance`.
849      *
850      * Note that operator and allowance concepts are orthogonal: operators may
851      * not have allowance, and accounts with allowance may not be operators
852      * themselves.
853      */
854     function allowance(address holder, address spender) public view returns (uint256) {
855         return _allowances[holder][spender];
856     }
857 
858     /**
859      * @dev See `IERC20.approve`.
860      *
861      * Note that accounts cannot have allowance issued by their operators.
862      */
863     function approve(address spender, uint256 value) external returns (bool) {
864         address holder = msg.sender;
865         _approve(holder, spender, value);
866         return true;
867     }
868 
869    /**
870     * @dev See `IERC20.transferFrom`.
871     *
872     * Note that operator and allowance concepts are orthogonal: operators cannot
873     * call `transferFrom` (unless they have allowance), and accounts with
874     * allowance cannot call `operatorSend` (unless they are operators).
875     *
876     * Emits `Sent`, `Transfer` and `Approval` events.
877     */
878     function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) {
879         require(recipient != address(0), "ERC777: transfer to the zero address");
880         require(holder != address(0), "ERC777: transfer from the zero address");
881 
882         address spender = msg.sender;
883 
884         _callTokensToSend(spender, holder, recipient, amount, "", "");
885 
886         _move(spender, holder, recipient, amount, "", "");
887         _approve(holder, spender, _allowances[holder][spender].sub(amount));
888 
889         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
890 
891         return true;
892     }
893 
894     /**
895      * @dev Creates `amount` tokens and assigns them to `account`, increasing
896      * the total supply.
897      *
898      * If a send hook is registered for `account`, the corresponding function
899      * will be called with `operator`, `data` and `operatorData`.
900      *
901      * See `IERC777Sender` and `IERC777Recipient`.
902      *
903      * Emits `Minted` and `Transfer` events.
904      *
905      * Requirements
906      *
907      * - `account` cannot be the zero address.
908      * - if `account` is a contract, it must implement the `tokensReceived`
909      * interface.
910      */
911     function _mint(
912         address operator,
913         address account,
914         uint256 amount,
915         bytes memory userData,
916         bytes memory operatorData
917     )
918     internal
919     {
920         require(account != address(0), "ERC777: mint to the zero address");
921 
922         // Update state variables
923         _totalSupply = _totalSupply.add(amount);
924         _balances[account] = _balances[account].add(amount);
925 
926         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
927 
928         emit Minted(operator, account, amount, userData, operatorData);
929         emit Transfer(address(0), account, amount);
930     }
931 
932     /**
933      * @dev Send tokens
934      * @param operator address operator requesting the transfer
935      * @param from address token holder address
936      * @param to address recipient address
937      * @param amount uint256 amount of tokens to transfer
938      * @param userData bytes extra information provided by the token holder (if any)
939      * @param operatorData bytes extra information provided by the operator (if any)
940      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
941      */
942     function _send(
943         address operator,
944         address from,
945         address to,
946         uint256 amount,
947         bytes memory userData,
948         bytes memory operatorData,
949         bool requireReceptionAck
950     )
951         private
952     {
953         require(from != address(0), "ERC777: send from the zero address");
954         require(to != address(0), "ERC777: send to the zero address");
955 
956         _callTokensToSend(operator, from, to, amount, userData, operatorData);
957 
958         _move(operator, from, to, amount, userData, operatorData);
959 
960         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
961     }
962 
963     /**
964      * @dev Burn tokens
965      * @param operator address operator requesting the operation
966      * @param from address token holder address
967      * @param amount uint256 amount of tokens to burn
968      * @param data bytes extra information provided by the token holder
969      * @param operatorData bytes extra information provided by the operator (if any)
970      */
971     function _burn(
972         address operator,
973         address from,
974         uint256 amount,
975         bytes memory data,
976         bytes memory operatorData
977     )
978         private
979     {
980         require(from != address(0), "ERC777: burn from the zero address");
981 
982         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
983 
984         // Update state variables
985         _totalSupply = _totalSupply.sub(amount);
986         _balances[from] = _balances[from].sub(amount);
987 
988         emit Burned(operator, from, amount, data, operatorData);
989         emit Transfer(from, address(0), amount);
990     }
991 
992     function _move(
993         address operator,
994         address from,
995         address to,
996         uint256 amount,
997         bytes memory userData,
998         bytes memory operatorData
999     )
1000         private
1001     {
1002         _balances[from] = _balances[from].sub(amount);
1003         _balances[to] = _balances[to].add(amount);
1004 
1005         emit Sent(operator, from, to, amount, userData, operatorData);
1006         emit Transfer(from, to, amount);
1007     }
1008 
1009     function _approve(address holder, address spender, uint256 value) private {
1010         // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
1011         // currently unnecessary.
1012         //require(holder != address(0), "ERC777: approve from the zero address");
1013         require(spender != address(0), "ERC777: approve to the zero address");
1014 
1015         _allowances[holder][spender] = value;
1016         emit Approval(holder, spender, value);
1017     }
1018 
1019     /**
1020      * @dev Call from.tokensToSend() if the interface is registered
1021      * @param operator address operator requesting the transfer
1022      * @param from address token holder address
1023      * @param to address recipient address
1024      * @param amount uint256 amount of tokens to transfer
1025      * @param userData bytes extra information provided by the token holder (if any)
1026      * @param operatorData bytes extra information provided by the operator (if any)
1027      */
1028     function _callTokensToSend(
1029         address operator,
1030         address from,
1031         address to,
1032         uint256 amount,
1033         bytes memory userData,
1034         bytes memory operatorData
1035     )
1036         private
1037     {
1038         address implementer = _erc1820.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1039         if (implementer != address(0)) {
1040             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1041         }
1042     }
1043 
1044     /**
1045      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1046      * tokensReceived() was not registered for the recipient
1047      * @param operator address operator requesting the transfer
1048      * @param from address token holder address
1049      * @param to address recipient address
1050      * @param amount uint256 amount of tokens to transfer
1051      * @param userData bytes extra information provided by the token holder (if any)
1052      * @param operatorData bytes extra information provided by the operator (if any)
1053      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1054      */
1055     function _callTokensReceived(
1056         address operator,
1057         address from,
1058         address to,
1059         uint256 amount,
1060         bytes memory userData,
1061         bytes memory operatorData,
1062         bool requireReceptionAck
1063     )
1064         private
1065     {
1066         address implementer = _erc1820.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1067         if (implementer != address(0)) {
1068             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1069         } else if (requireReceptionAck) {
1070             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1071         }
1072     }
1073 }
1074 
1075 // File: src\contracts\erc777\TokenMintERC777Token.sol
1076 
1077 pragma solidity ^0.5.0;
1078 
1079 
1080 /**
1081  * @title TokenMintERC777Token
1082  * @author TokenMint (visit https://tokenmint.io)
1083  *
1084  * @dev Standard ERC777 token total supply being minted on contract creation
1085  */
1086 contract TokenMintERC777Token is ERC777 {
1087 
1088     constructor(
1089       string memory name, 
1090       string memory symbol, 
1091       address[] memory defaultOperators, 
1092       uint256 totalSupply
1093     ) 
1094     public 
1095     ERC777(name, symbol, defaultOperators)
1096     {
1097       // mint new tokens to address that deploys contract
1098       _mint(msg.sender, msg.sender, totalSupply, "", "");
1099     }
1100 }