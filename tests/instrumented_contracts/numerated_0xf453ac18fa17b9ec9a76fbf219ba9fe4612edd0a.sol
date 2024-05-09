1 // File: @openzeppelin/contracts/token/ERC777/IERC777.sol
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
190 // File: @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol
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
219         uint amount,
220         bytes calldata userData,
221         bytes calldata operatorData
222     ) external;
223 }
224 
225 // File: @openzeppelin/contracts/token/ERC777/IERC777Sender.sol
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
254         uint amount,
255         bytes calldata userData,
256         bytes calldata operatorData
257     ) external;
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
339 // File: @openzeppelin/contracts/math/SafeMath.sol
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
401         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
449 // File: @openzeppelin/contracts/utils/Address.sol
450 
451 pragma solidity ^0.5.0;
452 
453 /**
454  * @dev Collection of functions related to the address type,
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
477 }
478 
479 // File: @openzeppelin/contracts/introspection/IERC1820Registry.sol
480 
481 pragma solidity ^0.5.0;
482 
483 /**
484  * @dev Interface of the global ERC1820 Registry, as defined in the
485  * [EIP](https://eips.ethereum.org/EIPS/eip-1820). Accounts may register
486  * implementers for interfaces in this registry, as well as query support.
487  *
488  * Implementers may be shared by multiple accounts, and can also implement more
489  * than a single interface for each account. Contracts can implement interfaces
490  * for themselves, but externally-owned accounts (EOA) must delegate this to a
491  * contract.
492  *
493  * `IERC165` interfaces can also be queried via the registry.
494  *
495  * For an in-depth explanation and source code analysis, see the EIP text.
496  */
497 interface IERC1820Registry {
498     /**
499      * @dev Sets `newManager` as the manager for `account`. A manager of an
500      * account is able to set interface implementers for it.
501      *
502      * By default, each account is its own manager. Passing a value of `0x0` in
503      * `newManager` will reset the manager to this initial state.
504      *
505      * Emits a `ManagerChanged` event.
506      *
507      * Requirements:
508      *
509      * - the caller must be the current manager for `account`.
510      */
511     function setManager(address account, address newManager) external;
512 
513     /**
514      * @dev Returns the manager for `account`.
515      *
516      * See `setManager`.
517      */
518     function getManager(address account) external view returns (address);
519 
520     /**
521      * @dev Sets the `implementer` contract as `account`'s implementer for
522      * `interfaceHash`.
523      *
524      * `account` being the zero address is an alias for the caller's address.
525      * The zero address can also be used in `implementer` to remove an old one.
526      *
527      * See `interfaceHash` to learn how these are created.
528      *
529      * Emits an `InterfaceImplementerSet` event.
530      *
531      * Requirements:
532      *
533      * - the caller must be the current manager for `account`.
534      * - `interfaceHash` must not be an `IERC165` interface id (i.e. it must not
535      * end in 28 zeroes).
536      * - `implementer` must implement `IERC1820Implementer` and return true when
537      * queried for support, unless `implementer` is the caller. See
538      * `IERC1820Implementer.canImplementInterfaceForAddress`.
539      */
540     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
541 
542     /**
543      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
544      * implementer is registered, returns the zero address.
545      *
546      * If `interfaceHash` is an `IERC165` interface id (i.e. it ends with 28
547      * zeroes), `account` will be queried for support of it.
548      *
549      * `account` being the zero address is an alias for the caller's address.
550      */
551     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
552 
553     /**
554      * @dev Returns the interface hash for an `interfaceName`, as defined in the
555      * corresponding
556      * [section of the EIP](https://eips.ethereum.org/EIPS/eip-1820#interface-name).
557      */
558     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
559 
560     /**
561      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
562      *  @param account Address of the contract for which to update the cache.
563      *  @param interfaceId ERC165 interface for which to update the cache.
564      */
565     function updateERC165Cache(address account, bytes4 interfaceId) external;
566 
567     /**
568      *  @notice Checks whether a contract implements an ERC165 interface or not.
569      *  If the result is not cached a direct lookup on the contract address is performed.
570      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
571      *  'updateERC165Cache' with the contract address.
572      *  @param account Address of the contract to check.
573      *  @param interfaceId ERC165 interface to check.
574      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
575      */
576     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
577 
578     /**
579      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
580      *  @param account Address of the contract to check.
581      *  @param interfaceId ERC165 interface to check.
582      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
583      */
584     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
585 
586     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
587 
588     event ManagerChanged(address indexed account, address indexed newManager);
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC777/ERC777.sol
592 
593 pragma solidity ^0.5.0;
594 
595 
596 
597 
598 
599 
600 
601 
602 /**
603  * @dev Implementation of the `IERC777` interface.
604  *
605  * This implementation is agnostic to the way tokens are created. This means
606  * that a supply mechanism has to be added in a derived contract using `_mint`.
607  *
608  * Support for ERC20 is included in this contract, as specified by the EIP: both
609  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
610  * Both `IERC777.Sent` and `IERC20.Transfer` events are emitted on token
611  * movements.
612  *
613  * Additionally, the `granularity` value is hard-coded to `1`, meaning that there
614  * are no special restrictions in the amount of tokens that created, moved, or
615  * destroyed. This makes integration with ERC20 applications seamless.
616  */
617 contract ERC777 is IERC777, IERC20 {
618     using SafeMath for uint256;
619     using Address for address;
620 
621     IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
622 
623     mapping(address => uint256) private _balances;
624 
625     uint256 private _totalSupply;
626 
627     string private _name;
628     string private _symbol;
629 
630     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
631     // See https://github.com/ethereum/solidity/issues/4024.
632 
633     // keccak256("ERC777TokensSender")
634     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
635         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
636 
637     // keccak256("ERC777TokensRecipient")
638     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
639         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
640 
641     // This isn't ever read from - it's only used to respond to the defaultOperators query.
642     address[] private _defaultOperatorsArray;
643 
644     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
645     mapping(address => bool) private _defaultOperators;
646 
647     // For each account, a mapping of its operators and revoked default operators.
648     mapping(address => mapping(address => bool)) private _operators;
649     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
650 
651     // ERC20-allowances
652     mapping (address => mapping (address => uint256)) private _allowances;
653 
654     /**
655      * @dev `defaultOperators` may be an empty array.
656      */
657     constructor(
658         string memory name,
659         string memory symbol,
660         address[] memory defaultOperators
661     ) public {
662         _name = name;
663         _symbol = symbol;
664 
665         _defaultOperatorsArray = defaultOperators;
666         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
667             _defaultOperators[_defaultOperatorsArray[i]] = true;
668         }
669 
670         // register interfaces
671         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
672         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
673     }
674 
675     /**
676      * @dev See `IERC777.name`.
677      */
678     function name() public view returns (string memory) {
679         return _name;
680     }
681 
682     /**
683      * @dev See `IERC777.symbol`.
684      */
685     function symbol() public view returns (string memory) {
686         return _symbol;
687     }
688 
689     /**
690      * @dev See `ERC20Detailed.decimals`.
691      *
692      * Always returns 18, as per the
693      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
694      */
695     function decimals() public pure returns (uint8) {
696         return 18;
697     }
698 
699     /**
700      * @dev See `IERC777.granularity`.
701      *
702      * This implementation always returns `1`.
703      */
704     function granularity() public view returns (uint256) {
705         return 1;
706     }
707 
708     /**
709      * @dev See `IERC777.totalSupply`.
710      */
711     function totalSupply() public view returns (uint256) {
712         return _totalSupply;
713     }
714 
715     /**
716      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
717      */
718     function balanceOf(address tokenHolder) public view returns (uint256) {
719         return _balances[tokenHolder];
720     }
721 
722     /**
723      * @dev See `IERC777.send`.
724      *
725      * Also emits a `Transfer` event for ERC20 compatibility.
726      */
727     function send(address recipient, uint256 amount, bytes calldata data) external {
728         _send(msg.sender, msg.sender, recipient, amount, data, "", true);
729     }
730 
731     /**
732      * @dev See `IERC20.transfer`.
733      *
734      * Unlike `send`, `recipient` is _not_ required to implement the `tokensReceived`
735      * interface if it is a contract.
736      *
737      * Also emits a `Sent` event.
738      */
739     function transfer(address recipient, uint256 amount) external returns (bool) {
740         require(recipient != address(0), "ERC777: transfer to the zero address");
741 
742         address from = msg.sender;
743 
744         _callTokensToSend(from, from, recipient, amount, "", "");
745 
746         _move(from, from, recipient, amount, "", "");
747 
748         _callTokensReceived(from, from, recipient, amount, "", "", false);
749 
750         return true;
751     }
752 
753     /**
754      * @dev See `IERC777.burn`.
755      *
756      * Also emits a `Transfer` event for ERC20 compatibility.
757      */
758     function burn(uint256 amount, bytes calldata data) external {
759         _burn(msg.sender, msg.sender, amount, data, "");
760     }
761 
762     /**
763      * @dev See `IERC777.isOperatorFor`.
764      */
765     function isOperatorFor(
766         address operator,
767         address tokenHolder
768     ) public view returns (bool) {
769         return operator == tokenHolder ||
770             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
771             _operators[tokenHolder][operator];
772     }
773 
774     /**
775      * @dev See `IERC777.authorizeOperator`.
776      */
777     function authorizeOperator(address operator) external {
778         require(msg.sender != operator, "ERC777: authorizing self as operator");
779 
780         if (_defaultOperators[operator]) {
781             delete _revokedDefaultOperators[msg.sender][operator];
782         } else {
783             _operators[msg.sender][operator] = true;
784         }
785 
786         emit AuthorizedOperator(operator, msg.sender);
787     }
788 
789     /**
790      * @dev See `IERC777.revokeOperator`.
791      */
792     function revokeOperator(address operator) external {
793         require(operator != msg.sender, "ERC777: revoking self as operator");
794 
795         if (_defaultOperators[operator]) {
796             _revokedDefaultOperators[msg.sender][operator] = true;
797         } else {
798             delete _operators[msg.sender][operator];
799         }
800 
801         emit RevokedOperator(operator, msg.sender);
802     }
803 
804     /**
805      * @dev See `IERC777.defaultOperators`.
806      */
807     function defaultOperators() public view returns (address[] memory) {
808         return _defaultOperatorsArray;
809     }
810 
811     /**
812      * @dev See `IERC777.operatorSend`.
813      *
814      * Emits `Sent` and `Transfer` events.
815      */
816     function operatorSend(
817         address sender,
818         address recipient,
819         uint256 amount,
820         bytes calldata data,
821         bytes calldata operatorData
822     )
823     external
824     {
825         require(isOperatorFor(msg.sender, sender), "ERC777: caller is not an operator for holder");
826         _send(msg.sender, sender, recipient, amount, data, operatorData, true);
827     }
828 
829     /**
830      * @dev See `IERC777.operatorBurn`.
831      *
832      * Emits `Sent` and `Transfer` events.
833      */
834     function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData) external {
835         require(isOperatorFor(msg.sender, account), "ERC777: caller is not an operator for holder");
836         _burn(msg.sender, account, amount, data, operatorData);
837     }
838 
839     /**
840      * @dev See `IERC20.allowance`.
841      *
842      * Note that operator and allowance concepts are orthogonal: operators may
843      * not have allowance, and accounts with allowance may not be operators
844      * themselves.
845      */
846     function allowance(address holder, address spender) public view returns (uint256) {
847         return _allowances[holder][spender];
848     }
849 
850     /**
851      * @dev See `IERC20.approve`.
852      *
853      * Note that accounts cannot have allowance issued by their operators.
854      */
855     function approve(address spender, uint256 value) external returns (bool) {
856         address holder = msg.sender;
857         _approve(holder, spender, value);
858         return true;
859     }
860 
861    /**
862     * @dev See `IERC20.transferFrom`.
863     *
864     * Note that operator and allowance concepts are orthogonal: operators cannot
865     * call `transferFrom` (unless they have allowance), and accounts with
866     * allowance cannot call `operatorSend` (unless they are operators).
867     *
868     * Emits `Sent` and `Transfer` events.
869     */
870     function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) {
871         require(recipient != address(0), "ERC777: transfer to the zero address");
872         require(holder != address(0), "ERC777: transfer from the zero address");
873 
874         address spender = msg.sender;
875 
876         _callTokensToSend(spender, holder, recipient, amount, "", "");
877 
878         _move(spender, holder, recipient, amount, "", "");
879         _approve(holder, spender, _allowances[holder][spender].sub(amount));
880 
881         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
882 
883         return true;
884     }
885 
886     /**
887      * @dev Creates `amount` tokens and assigns them to `account`, increasing
888      * the total supply.
889      *
890      * If a send hook is registered for `raccount`, the corresponding function
891      * will be called with `operator`, `data` and `operatorData`.
892      *
893      * See `IERC777Sender` and `IERC777Recipient`.
894      *
895      * Emits `Sent` and `Transfer` events.
896      *
897      * Requirements
898      *
899      * - `account` cannot be the zero address.
900      * - if `account` is a contract, it must implement the `tokensReceived`
901      * interface.
902      */
903     function _mint(
904         address operator,
905         address account,
906         uint256 amount,
907         bytes memory userData,
908         bytes memory operatorData
909     )
910     internal
911     {
912         require(account != address(0), "ERC777: mint to the zero address");
913 
914         // Update state variables
915         _totalSupply = _totalSupply.add(amount);
916         _balances[account] = _balances[account].add(amount);
917 
918         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
919 
920         emit Minted(operator, account, amount, userData, operatorData);
921         emit Transfer(address(0), account, amount);
922     }
923 
924     /**
925      * @dev Send tokens
926      * @param operator address operator requesting the transfer
927      * @param from address token holder address
928      * @param to address recipient address
929      * @param amount uint256 amount of tokens to transfer
930      * @param userData bytes extra information provided by the token holder (if any)
931      * @param operatorData bytes extra information provided by the operator (if any)
932      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
933      */
934     function _send(
935         address operator,
936         address from,
937         address to,
938         uint256 amount,
939         bytes memory userData,
940         bytes memory operatorData,
941         bool requireReceptionAck
942     )
943         private
944     {
945         require(from != address(0), "ERC777: send from the zero address");
946         require(to != address(0), "ERC777: send to the zero address");
947 
948         _callTokensToSend(operator, from, to, amount, userData, operatorData);
949 
950         _move(operator, from, to, amount, userData, operatorData);
951 
952         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
953     }
954 
955     /**
956      * @dev Burn tokens
957      * @param operator address operator requesting the operation
958      * @param from address token holder address
959      * @param amount uint256 amount of tokens to burn
960      * @param data bytes extra information provided by the token holder
961      * @param operatorData bytes extra information provided by the operator (if any)
962      */
963     function _burn(
964         address operator,
965         address from,
966         uint256 amount,
967         bytes memory data,
968         bytes memory operatorData
969     )
970         private
971     {
972         require(from != address(0), "ERC777: burn from the zero address");
973 
974         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
975 
976         // Update state variables
977         _totalSupply = _totalSupply.sub(amount);
978         _balances[from] = _balances[from].sub(amount);
979 
980         emit Burned(operator, from, amount, data, operatorData);
981         emit Transfer(from, address(0), amount);
982     }
983 
984     function _move(
985         address operator,
986         address from,
987         address to,
988         uint256 amount,
989         bytes memory userData,
990         bytes memory operatorData
991     )
992         private
993     {
994         _balances[from] = _balances[from].sub(amount);
995         _balances[to] = _balances[to].add(amount);
996 
997         emit Sent(operator, from, to, amount, userData, operatorData);
998         emit Transfer(from, to, amount);
999     }
1000 
1001     function _approve(address holder, address spender, uint256 value) private {
1002         // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
1003         // currently unnecessary.
1004         //require(holder != address(0), "ERC777: approve from the zero address");
1005         require(spender != address(0), "ERC777: approve to the zero address");
1006 
1007         _allowances[holder][spender] = value;
1008         emit Approval(holder, spender, value);
1009     }
1010 
1011     /**
1012      * @dev Call from.tokensToSend() if the interface is registered
1013      * @param operator address operator requesting the transfer
1014      * @param from address token holder address
1015      * @param to address recipient address
1016      * @param amount uint256 amount of tokens to transfer
1017      * @param userData bytes extra information provided by the token holder (if any)
1018      * @param operatorData bytes extra information provided by the operator (if any)
1019      */
1020     function _callTokensToSend(
1021         address operator,
1022         address from,
1023         address to,
1024         uint256 amount,
1025         bytes memory userData,
1026         bytes memory operatorData
1027     )
1028         private
1029     {
1030         address implementer = _erc1820.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1031         if (implementer != address(0)) {
1032             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1033         }
1034     }
1035 
1036     /**
1037      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1038      * tokensReceived() was not registered for the recipient
1039      * @param operator address operator requesting the transfer
1040      * @param from address token holder address
1041      * @param to address recipient address
1042      * @param amount uint256 amount of tokens to transfer
1043      * @param userData bytes extra information provided by the token holder (if any)
1044      * @param operatorData bytes extra information provided by the operator (if any)
1045      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1046      */
1047     function _callTokensReceived(
1048         address operator,
1049         address from,
1050         address to,
1051         uint256 amount,
1052         bytes memory userData,
1053         bytes memory operatorData,
1054         bool requireReceptionAck
1055     )
1056         private
1057     {
1058         address implementer = _erc1820.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1059         if (implementer != address(0)) {
1060             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1061         } else if (requireReceptionAck) {
1062             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1063         }
1064     }
1065 }
1066 
1067 // File: @openzeppelin/contracts/ownership/Ownable.sol
1068 
1069 pragma solidity ^0.5.0;
1070 
1071 /**
1072  * @dev Contract module which provides a basic access control mechanism, where
1073  * there is an account (an owner) that can be granted exclusive access to
1074  * specific functions.
1075  *
1076  * This module is used through inheritance. It will make available the modifier
1077  * `onlyOwner`, which can be aplied to your functions to restrict their use to
1078  * the owner.
1079  */
1080 contract Ownable {
1081     address private _owner;
1082 
1083     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1084 
1085     /**
1086      * @dev Initializes the contract setting the deployer as the initial owner.
1087      */
1088     constructor () internal {
1089         _owner = msg.sender;
1090         emit OwnershipTransferred(address(0), _owner);
1091     }
1092 
1093     /**
1094      * @dev Returns the address of the current owner.
1095      */
1096     function owner() public view returns (address) {
1097         return _owner;
1098     }
1099 
1100     /**
1101      * @dev Throws if called by any account other than the owner.
1102      */
1103     modifier onlyOwner() {
1104         require(isOwner(), "Ownable: caller is not the owner");
1105         _;
1106     }
1107 
1108     /**
1109      * @dev Returns true if the caller is the current owner.
1110      */
1111     function isOwner() public view returns (bool) {
1112         return msg.sender == _owner;
1113     }
1114 
1115     /**
1116      * @dev Leaves the contract without owner. It will not be possible to call
1117      * `onlyOwner` functions anymore. Can only be called by the current owner.
1118      *
1119      * > Note: Renouncing ownership will leave the contract without an owner,
1120      * thereby removing any functionality that is only available to the owner.
1121      */
1122     function renounceOwnership() public onlyOwner {
1123         emit OwnershipTransferred(_owner, address(0));
1124         _owner = address(0);
1125     }
1126 
1127     /**
1128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1129      * Can only be called by the current owner.
1130      */
1131     function transferOwnership(address newOwner) public onlyOwner {
1132         _transferOwnership(newOwner);
1133     }
1134 
1135     /**
1136      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1137      */
1138     function _transferOwnership(address newOwner) internal {
1139         require(newOwner != address(0), "Ownable: new owner is the zero address");
1140         emit OwnershipTransferred(_owner, newOwner);
1141         _owner = newOwner;
1142     }
1143 }
1144 
1145 // File: contracts/MMM.sol
1146 
1147 pragma solidity 0.5.12;
1148 
1149 
1150 
1151 /**
1152  * @title MMM
1153  * @dev Very simple ERC777 Token example, where all tokens are pre-assigned to the creator.
1154  * Note they can later distribute these tokens as they wish using `transfer` and other
1155  * `ERC20` or `ERC777` functions.
1156  * Based on https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/examples/SimpleToken.sol
1157  */
1158 contract MMM is ERC777,Ownable {
1159 
1160     // TODO: 限制總發行量 5 億
1161     uint256 public constant _maxSupply = 5 * (10 ** 8) * (10 ** 18);
1162 
1163     modifier noOverflow(uint256 _amt) {
1164         require(_maxSupply >= totalSupply().add(_amt), 'totalSupply overflow');
1165         _;
1166     }
1167 
1168     constructor () public ERC777('dMMM', 'dMMM', new address[](0)) {
1169         return;
1170     }
1171 
1172     function mint(address _address,uint256 _amount) public noOverflow(_amount) onlyOwner {
1173         _mint(msg.sender, _address, _amount, '', '');
1174     }
1175 
1176 }