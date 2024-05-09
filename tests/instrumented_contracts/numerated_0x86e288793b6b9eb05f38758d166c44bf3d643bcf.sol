1 // File: contracts\open-zeppelin-contracts\token\ERC777\IERC777.sol
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
190 // File: contracts\open-zeppelin-contracts\token\ERC777\IERC777Recipient.sol
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
225 // File: contracts\open-zeppelin-contracts\token\ERC777\IERC777Sender.sol
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
260 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
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
339 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
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
449 // File: contracts\open-zeppelin-contracts\utils\Address.sol
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
472         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
473         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
474         // for accounts without code, i.e. `keccak256('')`
475         bytes32 codehash;
476         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
477         // solhint-disable-next-line no-inline-assembly
478         assembly { codehash := extcodehash(account) }
479         return (codehash != 0x0 && codehash != accountHash);
480     }
481 
482     /**
483      * @dev Converts an `address` into `address payable`. Note that this is
484      * simply a type cast: the actual underlying value is not changed.
485      */
486     function toPayable(address account) internal pure returns (address payable) {
487         return address(uint160(account));
488     }
489 }
490 
491 // File: contracts\open-zeppelin-contracts\introspection\IERC1820Registry.sol
492 
493 pragma solidity ^0.5.0;
494 
495 /**
496  * @dev Interface of the global ERC1820 Registry, as defined in the
497  * [EIP](https://eips.ethereum.org/EIPS/eip-1820). Accounts may register
498  * implementers for interfaces in this registry, as well as query support.
499  *
500  * Implementers may be shared by multiple accounts, and can also implement more
501  * than a single interface for each account. Contracts can implement interfaces
502  * for themselves, but externally-owned accounts (EOA) must delegate this to a
503  * contract.
504  *
505  * `IERC165` interfaces can also be queried via the registry.
506  *
507  * For an in-depth explanation and source code analysis, see the EIP text.
508  */
509 interface IERC1820Registry {
510     /**
511      * @dev Sets `newManager` as the manager for `account`. A manager of an
512      * account is able to set interface implementers for it.
513      *
514      * By default, each account is its own manager. Passing a value of `0x0` in
515      * `newManager` will reset the manager to this initial state.
516      *
517      * Emits a `ManagerChanged` event.
518      *
519      * Requirements:
520      *
521      * - the caller must be the current manager for `account`.
522      */
523     function setManager(address account, address newManager) external;
524 
525     /**
526      * @dev Returns the manager for `account`.
527      *
528      * See `setManager`.
529      */
530     function getManager(address account) external view returns (address);
531 
532     /**
533      * @dev Sets the `implementer` contract as `account`'s implementer for
534      * `interfaceHash`.
535      *
536      * `account` being the zero address is an alias for the caller's address.
537      * The zero address can also be used in `implementer` to remove an old one.
538      *
539      * See `interfaceHash` to learn how these are created.
540      *
541      * Emits an `InterfaceImplementerSet` event.
542      *
543      * Requirements:
544      *
545      * - the caller must be the current manager for `account`.
546      * - `interfaceHash` must not be an `IERC165` interface id (i.e. it must not
547      * end in 28 zeroes).
548      * - `implementer` must implement `IERC1820Implementer` and return true when
549      * queried for support, unless `implementer` is the caller. See
550      * `IERC1820Implementer.canImplementInterfaceForAddress`.
551      */
552     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
553 
554     /**
555      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
556      * implementer is registered, returns the zero address.
557      *
558      * If `interfaceHash` is an `IERC165` interface id (i.e. it ends with 28
559      * zeroes), `account` will be queried for support of it.
560      *
561      * `account` being the zero address is an alias for the caller's address.
562      */
563     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
564 
565     /**
566      * @dev Returns the interface hash for an `interfaceName`, as defined in the
567      * corresponding
568      * [section of the EIP](https://eips.ethereum.org/EIPS/eip-1820#interface-name).
569      */
570     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
571 
572     /**
573      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
574      *  @param account Address of the contract for which to update the cache.
575      *  @param interfaceId ERC165 interface for which to update the cache.
576      */
577     function updateERC165Cache(address account, bytes4 interfaceId) external;
578 
579     /**
580      *  @notice Checks whether a contract implements an ERC165 interface or not.
581      *  If the result is not cached a direct lookup on the contract address is performed.
582      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
583      *  'updateERC165Cache' with the contract address.
584      *  @param account Address of the contract to check.
585      *  @param interfaceId ERC165 interface to check.
586      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
587      */
588     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
589 
590     /**
591      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
592      *  @param account Address of the contract to check.
593      *  @param interfaceId ERC165 interface to check.
594      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
595      */
596     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
597 
598     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
599 
600     event ManagerChanged(address indexed account, address indexed newManager);
601 }
602 
603 // File: contracts\open-zeppelin-contracts\token\ERC777\ERC777.sol
604 
605 pragma solidity ^0.5.0;
606 
607 
608 
609 
610 
611 
612 
613 
614 /**
615  * @dev Implementation of the `IERC777` interface.
616  *
617  * This implementation is agnostic to the way tokens are created. This means
618  * that a supply mechanism has to be added in a derived contract using `_mint`.
619  *
620  * Support for ERC20 is included in this contract, as specified by the EIP: both
621  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
622  * Both `IERC777.Sent` and `IERC20.Transfer` events are emitted on token
623  * movements.
624  *
625  * Additionally, the `granularity` value is hard-coded to `1`, meaning that there
626  * are no special restrictions in the amount of tokens that created, moved, or
627  * destroyed. This makes integration with ERC20 applications seamless.
628  */
629 contract ERC777 is IERC777, IERC20 {
630     using SafeMath for uint256;
631     using Address for address;
632 
633     IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
634 
635     mapping(address => uint256) private _balances;
636 
637     uint256 private _totalSupply;
638 
639     string private _name;
640     string private _symbol;
641 
642     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
643     // See https://github.com/ethereum/solidity/issues/4024.
644 
645     // keccak256("ERC777TokensSender")
646     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
647         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
648 
649     // keccak256("ERC777TokensRecipient")
650     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
651         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
652 
653     // This isn't ever read from - it's only used to respond to the defaultOperators query.
654     address[] private _defaultOperatorsArray;
655 
656     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
657     mapping(address => bool) private _defaultOperators;
658 
659     // For each account, a mapping of its operators and revoked default operators.
660     mapping(address => mapping(address => bool)) private _operators;
661     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
662 
663     // ERC20-allowances
664     mapping (address => mapping (address => uint256)) private _allowances;
665 
666     /**
667      * @dev `defaultOperators` may be an empty array.
668      */
669     constructor(
670         string memory name,
671         string memory symbol,
672         address[] memory defaultOperators
673     ) public {
674         _name = name;
675         _symbol = symbol;
676 
677         _defaultOperatorsArray = defaultOperators;
678         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
679             _defaultOperators[_defaultOperatorsArray[i]] = true;
680         }
681 
682         // register interfaces
683         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
684         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
685     }
686 
687     /**
688      * @dev See `IERC777.name`.
689      */
690     function name() public view returns (string memory) {
691         return _name;
692     }
693 
694     /**
695      * @dev See `IERC777.symbol`.
696      */
697     function symbol() public view returns (string memory) {
698         return _symbol;
699     }
700 
701     /**
702      * @dev See `ERC20Detailed.decimals`.
703      *
704      * Always returns 18, as per the
705      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
706      */
707     function decimals() public pure returns (uint8) {
708         return 18;
709     }
710 
711     /**
712      * @dev See `IERC777.granularity`.
713      *
714      * This implementation always returns `1`.
715      */
716     function granularity() public view returns (uint256) {
717         return 1;
718     }
719 
720     /**
721      * @dev See `IERC777.totalSupply`.
722      */
723     function totalSupply() public view returns (uint256) {
724         return _totalSupply;
725     }
726 
727     /**
728      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
729      */
730     function balanceOf(address tokenHolder) public view returns (uint256) {
731         return _balances[tokenHolder];
732     }
733 
734     /**
735      * @dev See `IERC777.send`.
736      *
737      * Also emits a `Transfer` event for ERC20 compatibility.
738      */
739     function send(address recipient, uint256 amount, bytes calldata data) external {
740         _send(msg.sender, msg.sender, recipient, amount, data, "", true);
741     }
742 
743     /**
744      * @dev See `IERC20.transfer`.
745      *
746      * Unlike `send`, `recipient` is _not_ required to implement the `tokensReceived`
747      * interface if it is a contract.
748      *
749      * Also emits a `Sent` event.
750      */
751     function transfer(address recipient, uint256 amount) external returns (bool) {
752         require(recipient != address(0), "ERC777: transfer to the zero address");
753 
754         address from = msg.sender;
755 
756         _callTokensToSend(from, from, recipient, amount, "", "");
757 
758         _move(from, from, recipient, amount, "", "");
759 
760         _callTokensReceived(from, from, recipient, amount, "", "", false);
761 
762         return true;
763     }
764 
765     /**
766      * @dev See `IERC777.burn`.
767      *
768      * Also emits a `Transfer` event for ERC20 compatibility.
769      */
770     function burn(uint256 amount, bytes calldata data) external {
771         _burn(msg.sender, msg.sender, amount, data, "");
772     }
773 
774     /**
775      * @dev See `IERC777.isOperatorFor`.
776      */
777     function isOperatorFor(
778         address operator,
779         address tokenHolder
780     ) public view returns (bool) {
781         return operator == tokenHolder ||
782             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
783             _operators[tokenHolder][operator];
784     }
785 
786     /**
787      * @dev See `IERC777.authorizeOperator`.
788      */
789     function authorizeOperator(address operator) external {
790         require(msg.sender != operator, "ERC777: authorizing self as operator");
791 
792         if (_defaultOperators[operator]) {
793             delete _revokedDefaultOperators[msg.sender][operator];
794         } else {
795             _operators[msg.sender][operator] = true;
796         }
797 
798         emit AuthorizedOperator(operator, msg.sender);
799     }
800 
801     /**
802      * @dev See `IERC777.revokeOperator`.
803      */
804     function revokeOperator(address operator) external {
805         require(operator != msg.sender, "ERC777: revoking self as operator");
806 
807         if (_defaultOperators[operator]) {
808             _revokedDefaultOperators[msg.sender][operator] = true;
809         } else {
810             delete _operators[msg.sender][operator];
811         }
812 
813         emit RevokedOperator(operator, msg.sender);
814     }
815 
816     /**
817      * @dev See `IERC777.defaultOperators`.
818      */
819     function defaultOperators() public view returns (address[] memory) {
820         return _defaultOperatorsArray;
821     }
822 
823     /**
824      * @dev See `IERC777.operatorSend`.
825      *
826      * Emits `Sent` and `Transfer` events.
827      */
828     function operatorSend(
829         address sender,
830         address recipient,
831         uint256 amount,
832         bytes calldata data,
833         bytes calldata operatorData
834     )
835     external
836     {
837         require(isOperatorFor(msg.sender, sender), "ERC777: caller is not an operator for holder");
838         _send(msg.sender, sender, recipient, amount, data, operatorData, true);
839     }
840 
841     /**
842      * @dev See `IERC777.operatorBurn`.
843      *
844      * Emits `Burned` and `Transfer` events.
845      */
846     function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData) external {
847         require(isOperatorFor(msg.sender, account), "ERC777: caller is not an operator for holder");
848         _burn(msg.sender, account, amount, data, operatorData);
849     }
850 
851     /**
852      * @dev See `IERC20.allowance`.
853      *
854      * Note that operator and allowance concepts are orthogonal: operators may
855      * not have allowance, and accounts with allowance may not be operators
856      * themselves.
857      */
858     function allowance(address holder, address spender) public view returns (uint256) {
859         return _allowances[holder][spender];
860     }
861 
862     /**
863      * @dev See `IERC20.approve`.
864      *
865      * Note that accounts cannot have allowance issued by their operators.
866      */
867     function approve(address spender, uint256 value) external returns (bool) {
868         address holder = msg.sender;
869         _approve(holder, spender, value);
870         return true;
871     }
872 
873    /**
874     * @dev See `IERC20.transferFrom`.
875     *
876     * Note that operator and allowance concepts are orthogonal: operators cannot
877     * call `transferFrom` (unless they have allowance), and accounts with
878     * allowance cannot call `operatorSend` (unless they are operators).
879     *
880     * Emits `Sent`, `Transfer` and `Approval` events.
881     */
882     function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) {
883         require(recipient != address(0), "ERC777: transfer to the zero address");
884         require(holder != address(0), "ERC777: transfer from the zero address");
885 
886         address spender = msg.sender;
887 
888         _callTokensToSend(spender, holder, recipient, amount, "", "");
889 
890         _move(spender, holder, recipient, amount, "", "");
891         _approve(holder, spender, _allowances[holder][spender].sub(amount));
892 
893         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
894 
895         return true;
896     }
897 
898     /**
899      * @dev Creates `amount` tokens and assigns them to `account`, increasing
900      * the total supply.
901      *
902      * If a send hook is registered for `account`, the corresponding function
903      * will be called with `operator`, `data` and `operatorData`.
904      *
905      * See `IERC777Sender` and `IERC777Recipient`.
906      *
907      * Emits `Minted` and `Transfer` events.
908      *
909      * Requirements
910      *
911      * - `account` cannot be the zero address.
912      * - if `account` is a contract, it must implement the `tokensReceived`
913      * interface.
914      */
915     function _mint(
916         address operator,
917         address account,
918         uint256 amount,
919         bytes memory userData,
920         bytes memory operatorData
921     )
922     internal
923     {
924         require(account != address(0), "ERC777: mint to the zero address");
925 
926         // Update state variables
927         _totalSupply = _totalSupply.add(amount);
928         _balances[account] = _balances[account].add(amount);
929 
930         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
931 
932         emit Minted(operator, account, amount, userData, operatorData);
933         emit Transfer(address(0), account, amount);
934     }
935 
936     /**
937      * @dev Send tokens
938      * @param operator address operator requesting the transfer
939      * @param from address token holder address
940      * @param to address recipient address
941      * @param amount uint256 amount of tokens to transfer
942      * @param userData bytes extra information provided by the token holder (if any)
943      * @param operatorData bytes extra information provided by the operator (if any)
944      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
945      */
946     function _send(
947         address operator,
948         address from,
949         address to,
950         uint256 amount,
951         bytes memory userData,
952         bytes memory operatorData,
953         bool requireReceptionAck
954     )
955         private
956     {
957         require(from != address(0), "ERC777: send from the zero address");
958         require(to != address(0), "ERC777: send to the zero address");
959 
960         _callTokensToSend(operator, from, to, amount, userData, operatorData);
961 
962         _move(operator, from, to, amount, userData, operatorData);
963 
964         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
965     }
966 
967     /**
968      * @dev Burn tokens
969      * @param operator address operator requesting the operation
970      * @param from address token holder address
971      * @param amount uint256 amount of tokens to burn
972      * @param data bytes extra information provided by the token holder
973      * @param operatorData bytes extra information provided by the operator (if any)
974      */
975     function _burn(
976         address operator,
977         address from,
978         uint256 amount,
979         bytes memory data,
980         bytes memory operatorData
981     )
982         private
983     {
984         require(from != address(0), "ERC777: burn from the zero address");
985 
986         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
987 
988         // Update state variables
989         _totalSupply = _totalSupply.sub(amount);
990         _balances[from] = _balances[from].sub(amount);
991 
992         emit Burned(operator, from, amount, data, operatorData);
993         emit Transfer(from, address(0), amount);
994     }
995 
996     function _move(
997         address operator,
998         address from,
999         address to,
1000         uint256 amount,
1001         bytes memory userData,
1002         bytes memory operatorData
1003     )
1004         private
1005     {
1006         _balances[from] = _balances[from].sub(amount);
1007         _balances[to] = _balances[to].add(amount);
1008 
1009         emit Sent(operator, from, to, amount, userData, operatorData);
1010         emit Transfer(from, to, amount);
1011     }
1012 
1013     function _approve(address holder, address spender, uint256 value) private {
1014         // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
1015         // currently unnecessary.
1016         //require(holder != address(0), "ERC777: approve from the zero address");
1017         require(spender != address(0), "ERC777: approve to the zero address");
1018 
1019         _allowances[holder][spender] = value;
1020         emit Approval(holder, spender, value);
1021     }
1022 
1023     /**
1024      * @dev Call from.tokensToSend() if the interface is registered
1025      * @param operator address operator requesting the transfer
1026      * @param from address token holder address
1027      * @param to address recipient address
1028      * @param amount uint256 amount of tokens to transfer
1029      * @param userData bytes extra information provided by the token holder (if any)
1030      * @param operatorData bytes extra information provided by the operator (if any)
1031      */
1032     function _callTokensToSend(
1033         address operator,
1034         address from,
1035         address to,
1036         uint256 amount,
1037         bytes memory userData,
1038         bytes memory operatorData
1039     )
1040         private
1041     {
1042         address implementer = _erc1820.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1043         if (implementer != address(0)) {
1044             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1045         }
1046     }
1047 
1048     /**
1049      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1050      * tokensReceived() was not registered for the recipient
1051      * @param operator address operator requesting the transfer
1052      * @param from address token holder address
1053      * @param to address recipient address
1054      * @param amount uint256 amount of tokens to transfer
1055      * @param userData bytes extra information provided by the token holder (if any)
1056      * @param operatorData bytes extra information provided by the operator (if any)
1057      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1058      */
1059     function _callTokensReceived(
1060         address operator,
1061         address from,
1062         address to,
1063         uint256 amount,
1064         bytes memory userData,
1065         bytes memory operatorData,
1066         bool requireReceptionAck
1067     )
1068         private
1069     {
1070         address implementer = _erc1820.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1071         if (implementer != address(0)) {
1072             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1073         } else if (requireReceptionAck) {
1074             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1075         }
1076     }
1077 }
1078 
1079 // File: contracts\ERC777\TokenMintERC777Token.sol
1080 
1081 pragma solidity ^0.5.0;
1082 
1083 
1084 /**
1085  * @title TokenMintERC777Token
1086  * @author TokenMint (visit https://tokenmint.io)
1087  *
1088  * @dev Standard ERC777 token total supply being minted on contract creation
1089  */
1090 contract TokenMintERC777Token is ERC777 {
1091 
1092     constructor(
1093       string memory name,
1094       string memory symbol,
1095       address[] memory defaultOperators,
1096       uint256 totalSupply,
1097       address payable feeReceiver
1098     )
1099     public payable
1100     ERC777(name, symbol, defaultOperators)
1101     {
1102       // mint new tokens to address that deploys contract
1103       _mint(msg.sender, msg.sender, totalSupply, "", "");
1104 
1105       // pay the service fee for contract deployment
1106       feeReceiver.transfer(msg.value);
1107     }
1108 }