1 pragma solidity ^0.5.10;
2 
3 /**
4  * @dev Interface of the ERC777Token standard as defined in the EIP.
5  *
6  * This contract uses the
7  * [ERC1820 registry standard](https://eips.ethereum.org/EIPS/eip-1820) to let
8  * token holders and recipients react to token movements by using setting implementers
9  * for the associated interfaces in said registry. See `IERC1820Registry` and
10  * `ERC1820Implementer`.
11  */
12 interface IERC777 {
13     /**
14      * @dev Returns the name of the token.
15      */
16     function name() external view returns (string memory);
17 
18     /**
19      * @dev Returns the symbol of the token, usually a shorter version of the
20      * name.
21      */
22     function symbol() external view returns (string memory);
23 
24     /**
25      * @dev Returns the smallest part of the token that is not divisible. This
26      * means all token operations (creation, movement and destruction) must have
27      * amounts that are a multiple of this number.
28      *
29      * For most token contracts, this value will equal 1.
30      */
31     function granularity() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by an account (`owner`).
40      */
41     function balanceOf(address owner) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * If send or receive hooks are registered for the caller and `recipient`,
47      * the corresponding functions will be called with `data` and empty
48      * `operatorData`. See `IERC777Sender` and `IERC777Recipient`.
49      *
50      * Emits a `Sent` event.
51      *
52      * Requirements
53      *
54      * - the caller must have at least `amount` tokens.
55      * - `recipient` cannot be the zero address.
56      * - if `recipient` is a contract, it must implement the `tokensReceived`
57      * interface.
58      */
59     function send(address recipient, uint256 amount, bytes calldata data) external;
60 
61     /**
62      * @dev Destroys `amount` tokens from the caller's account, reducing the
63      * total supply.
64      *
65      * If a send hook is registered for the caller, the corresponding function
66      * will be called with `data` and empty `operatorData`. See `IERC777Sender`.
67      *
68      * Emits a `Burned` event.
69      *
70      * Requirements
71      *
72      * - the caller must have at least `amount` tokens.
73      */
74     function burn(uint256 amount, bytes calldata data) external;
75 
76     /**
77      * @dev Returns true if an account is an operator of `tokenHolder`.
78      * Operators can send and burn tokens on behalf of their owners. All
79      * accounts are their own operator.
80      *
81      * See `operatorSend` and `operatorBurn`.
82      */
83     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
84 
85     /**
86      * @dev Make an account an operator of the caller.
87      *
88      * See `isOperatorFor`.
89      *
90      * Emits an `AuthorizedOperator` event.
91      *
92      * Requirements
93      *
94      * - `operator` cannot be calling address.
95      */
96     function authorizeOperator(address operator) external;
97 
98     /**
99      * @dev Make an account an operator of the caller.
100      *
101      * See `isOperatorFor` and `defaultOperators`.
102      *
103      * Emits a `RevokedOperator` event.
104      *
105      * Requirements
106      *
107      * - `operator` cannot be calling address.
108      */
109     function revokeOperator(address operator) external;
110 
111     /**
112      * @dev Returns the list of default operators. These accounts are operators
113      * for all token holders, even if `authorizeOperator` was never called on
114      * them.
115      *
116      * This list is immutable, but individual holders may revoke these via
117      * `revokeOperator`, in which case `isOperatorFor` will return false.
118      */
119     function defaultOperators() external view returns (address[] memory);
120 
121     /**
122      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
123      * be an operator of `sender`.
124      *
125      * If send or receive hooks are registered for `sender` and `recipient`,
126      * the corresponding functions will be called with `data` and
127      * `operatorData`. See `IERC777Sender` and `IERC777Recipient`.
128      *
129      * Emits a `Sent` event.
130      *
131      * Requirements
132      *
133      * - `sender` cannot be the zero address.
134      * - `sender` must have at least `amount` tokens.
135      * - the caller must be an operator for `sender`.
136      * - `recipient` cannot be the zero address.
137      * - if `recipient` is a contract, it must implement the `tokensReceived`
138      * interface.
139      */
140     function operatorSend(
141         address sender,
142         address recipient,
143         uint256 amount,
144         bytes calldata data,
145         bytes calldata operatorData
146     ) external;
147 
148     /**
149      * @dev Destoys `amount` tokens from `account`, reducing the total supply.
150      * The caller must be an operator of `account`.
151      *
152      * If a send hook is registered for `account`, the corresponding function
153      * will be called with `data` and `operatorData`. See `IERC777Sender`.
154      *
155      * Emits a `Burned` event.
156      *
157      * Requirements
158      *
159      * - `account` cannot be the zero address.
160      * - `account` must have at least `amount` tokens.
161      * - the caller must be an operator for `account`.
162      */
163     function operatorBurn(
164         address account,
165         uint256 amount,
166         bytes calldata data,
167         bytes calldata operatorData
168     ) external;
169 
170     event Sent(
171         address indexed operator,
172         address indexed from,
173         address indexed to,
174         uint256 amount,
175         bytes data,
176         bytes operatorData
177     );
178 
179     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
180 
181     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
182 
183     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
184 
185     event RevokedOperator(address indexed operator, address indexed tokenHolder);
186 }
187 
188 /**
189  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
190  *
191  * Accounts can be notified of `IERC777` tokens being sent to them by having a
192  * contract implement this interface (contract holders can be their own
193  * implementer) and registering it on the
194  * [ERC1820 global registry](https://eips.ethereum.org/EIPS/eip-1820).
195  *
196  * See `IERC1820Registry` and `ERC1820Implementer`.
197  */
198 interface IERC777Recipient {
199     /**
200      * @dev Called by an `IERC777` token contract whenever tokens are being
201      * moved or created into a registered account (`to`). The type of operation
202      * is conveyed by `from` being the zero address or not.
203      *
204      * This call occurs _after_ the token contract's state is updated, so
205      * `IERC777.balanceOf`, etc., can be used to query the post-operation state.
206      *
207      * This function may revert to prevent the operation from being executed.
208      */
209     function tokensReceived(
210         address operator,
211         address from,
212         address to,
213         uint amount,
214         bytes calldata userData,
215         bytes calldata operatorData
216     ) external;
217 }
218 
219 /**
220  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
221  *
222  * `IERC777` Token holders can be notified of operations performed on their
223  * tokens by having a contract implement this interface (contract holders can be
224  *  their own implementer) and registering it on the
225  * [ERC1820 global registry](https://eips.ethereum.org/EIPS/eip-1820).
226  *
227  * See `IERC1820Registry` and `ERC1820Implementer`.
228  */
229 interface IERC777Sender {
230     /**
231      * @dev Called by an `IERC777` token contract whenever a registered holder's
232      * (`from`) tokens are about to be moved or destroyed. The type of operation
233      * is conveyed by `to` being the zero address or not.
234      *
235      * This call occurs _before_ the token contract's state is updated, so
236      * `IERC777.balanceOf`, etc., can be used to query the pre-operation state.
237      *
238      * This function may revert to prevent the operation from being executed.
239      */
240     function tokensToSend(
241         address operator,
242         address from,
243         address to,
244         uint amount,
245         bytes calldata userData,
246         bytes calldata operatorData
247     ) external;
248 }
249 
250 /**
251  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
252  * the optional functions; to access them see `ERC20Detailed`.
253  */
254 interface IERC20 {
255     /**
256      * @dev Returns the amount of tokens in existence.
257      */
258     function totalSupply() external view returns (uint256);
259 
260     /**
261      * @dev Returns the amount of tokens owned by `account`.
262      */
263     function balanceOf(address account) external view returns (uint256);
264 
265     /**
266      * @dev Moves `amount` tokens from the caller's account to `recipient`.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a `Transfer` event.
271      */
272     function transfer(address recipient, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Returns the remaining number of tokens that `spender` will be
276      * allowed to spend on behalf of `owner` through `transferFrom`. This is
277      * zero by default.
278      *
279      * This value changes when `approve` or `transferFrom` are called.
280      */
281     function allowance(address owner, address spender) external view returns (uint256);
282 
283     /**
284      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * > Beware that changing an allowance with this method brings the risk
289      * that someone may use both the old and the new allowance by unfortunate
290      * transaction ordering. One possible solution to mitigate this race
291      * condition is to first reduce the spender's allowance to 0 and set the
292      * desired value afterwards:
293      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294      *
295      * Emits an `Approval` event.
296      */
297     function approve(address spender, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Moves `amount` tokens from `sender` to `recipient` using the
301      * allowance mechanism. `amount` is then deducted from the caller's
302      * allowance.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a `Transfer` event.
307      */
308     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Emitted when `value` tokens are moved from one account (`from`) to
312      * another (`to`).
313      *
314      * Note that `value` may be zero.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 value);
317 
318     /**
319      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
320      * a call to `approve`. `value` is the new allowance.
321      */
322     event Approval(address indexed owner, address indexed spender, uint256 value);
323 }
324 
325 /**
326  * @dev Wrappers over Solidity's arithmetic operations with added overflow
327  * checks.
328  *
329  * Arithmetic operations in Solidity wrap on overflow. This can easily result
330  * in bugs, because programmers usually assume that an overflow raises an
331  * error, which is the standard behavior in high level programming languages.
332  * `SafeMath` restores this intuition by reverting the transaction when an
333  * operation overflows.
334  *
335  * Using this library instead of the unchecked operations eliminates an entire
336  * class of bugs, so it's recommended to use it always.
337  */
338 library SafeMath {
339     /**
340      * @dev Returns the addition of two unsigned integers, reverting on
341      * overflow.
342      *
343      * Counterpart to Solidity's `+` operator.
344      *
345      * Requirements:
346      * - Addition cannot overflow.
347      */
348     function add(uint256 a, uint256 b) internal pure returns (uint256) {
349         uint256 c = a + b;
350         require(c >= a, "SafeMath: addition overflow");
351 
352         return c;
353     }
354 
355     /**
356      * @dev Returns the subtraction of two unsigned integers, reverting on
357      * overflow (when the result is negative).
358      *
359      * Counterpart to Solidity's `-` operator.
360      *
361      * Requirements:
362      * - Subtraction cannot overflow.
363      */
364     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
365         require(b <= a, "SafeMath: subtraction overflow");
366         uint256 c = a - b;
367 
368         return c;
369     }
370 
371     /**
372      * @dev Returns the multiplication of two unsigned integers, reverting on
373      * overflow.
374      *
375      * Counterpart to Solidity's `*` operator.
376      *
377      * Requirements:
378      * - Multiplication cannot overflow.
379      */
380     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
381         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
382         // benefit is lost if 'b' is also tested.
383         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
384         if (a == 0) {
385             return 0;
386         }
387 
388         uint256 c = a * b;
389         require(c / a == b, "SafeMath: multiplication overflow");
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the integer division of two unsigned integers. Reverts on
396      * division by zero. The result is rounded towards zero.
397      *
398      * Counterpart to Solidity's `/` operator. Note: this function uses a
399      * `revert` opcode (which leaves remaining gas untouched) while Solidity
400      * uses an invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      * - The divisor cannot be zero.
404      */
405     function div(uint256 a, uint256 b) internal pure returns (uint256) {
406         // Solidity only automatically asserts when dividing by 0
407         require(b > 0, "SafeMath: division by zero");
408         uint256 c = a / b;
409         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
410 
411         return c;
412     }
413 
414     /**
415      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
416      * Reverts when dividing by zero.
417      *
418      * Counterpart to Solidity's `%` operator. This function uses a `revert`
419      * opcode (which leaves remaining gas untouched) while Solidity uses an
420      * invalid opcode to revert (consuming all remaining gas).
421      *
422      * Requirements:
423      * - The divisor cannot be zero.
424      */
425     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
426         require(b != 0, "SafeMath: modulo by zero");
427         return a % b;
428     }
429 }
430 
431 // File: contracts\zeppelin\utils\Address.sol
432 
433 pragma solidity ^0.5.0;
434 
435 /**
436  * @dev Collection of functions related to the address type,
437  */
438 library Address {
439     /**
440      * @dev Returns true if `account` is a contract.
441      *
442      * This test is non-exhaustive, and there may be false-negatives: during the
443      * execution of a contract's constructor, its address will be reported as
444      * not containing a contract.
445      *
446      * > It is unsafe to assume that an address for which this function returns
447      * false is an externally-owned account (EOA) and not a contract.
448      */
449     function isContract(address account) internal view returns (bool) {
450         // This method relies in extcodesize, which returns 0 for contracts in
451         // construction, since the code is only stored at the end of the
452         // constructor execution.
453 
454         uint256 size;
455         // solhint-disable-next-line no-inline-assembly
456         assembly { size := extcodesize(account) }
457         return size > 0;
458     }
459 }
460 
461 /**
462  * @dev Interface of the global ERC1820 Registry, as defined in the
463  * [EIP](https://eips.ethereum.org/EIPS/eip-1820). Accounts may register
464  * implementers for interfaces in this registry, as well as query support.
465  *
466  * Implementers may be shared by multiple accounts, and can also implement more
467  * than a single interface for each account. Contracts can implement interfaces
468  * for themselves, but externally-owned accounts (EOA) must delegate this to a
469  * contract.
470  *
471  * `IERC165` interfaces can also be queried via the registry.
472  *
473  * For an in-depth explanation and source code analysis, see the EIP text.
474  */
475 interface IERC1820Registry {
476     /**
477      * @dev Sets `newManager` as the manager for `account`. A manager of an
478      * account is able to set interface implementers for it.
479      *
480      * By default, each account is its own manager. Passing a value of `0x0` in
481      * `newManager` will reset the manager to this initial state.
482      *
483      * Emits a `ManagerChanged` event.
484      *
485      * Requirements:
486      *
487      * - the caller must be the current manager for `account`.
488      */
489     function setManager(address account, address newManager) external;
490 
491     /**
492      * @dev Returns the manager for `account`.
493      *
494      * See `setManager`.
495      */
496     function getManager(address account) external view returns (address);
497 
498     /**
499      * @dev Sets the `implementer` contract as `account`'s implementer for
500      * `interfaceHash`.
501      *
502      * `account` being the zero address is an alias for the caller's address.
503      * The zero address can also be used in `implementer` to remove an old one.
504      *
505      * See `interfaceHash` to learn how these are created.
506      *
507      * Emits an `InterfaceImplementerSet` event.
508      *
509      * Requirements:
510      *
511      * - the caller must be the current manager for `account`.
512      * - `interfaceHash` must not be an `IERC165` interface id (i.e. it must not
513      * end in 28 zeroes).
514      * - `implementer` must implement `IERC1820Implementer` and return true when
515      * queried for support, unless `implementer` is the caller. See
516      * `IERC1820Implementer.canImplementInterfaceForAddress`.
517      */
518     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
519 
520     /**
521      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
522      * implementer is registered, returns the zero address.
523      *
524      * If `interfaceHash` is an `IERC165` interface id (i.e. it ends with 28
525      * zeroes), `account` will be queried for support of it.
526      *
527      * `account` being the zero address is an alias for the caller's address.
528      */
529     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
530 
531     /**
532      * @dev Returns the interface hash for an `interfaceName`, as defined in the
533      * corresponding
534      * [section of the EIP](https://eips.ethereum.org/EIPS/eip-1820#interface-name).
535      */
536     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
537 
538     /**
539      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
540      *  @param account Address of the contract for which to update the cache.
541      *  @param interfaceId ERC165 interface for which to update the cache.
542      */
543     function updateERC165Cache(address account, bytes4 interfaceId) external;
544 
545     /**
546      *  @notice Checks whether a contract implements an ERC165 interface or not.
547      *  If the result is not cached a direct lookup on the contract address is performed.
548      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
549      *  'updateERC165Cache' with the contract address.
550      *  @param account Address of the contract to check.
551      *  @param interfaceId ERC165 interface to check.
552      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
553      */
554     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
555 
556     /**
557      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
558      *  @param account Address of the contract to check.
559      *  @param interfaceId ERC165 interface to check.
560      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
561      */
562     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
563 
564     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
565 
566     event ManagerChanged(address indexed account, address indexed newManager);
567 }
568 
569 /**
570  * @dev Implementation of the `IERC777` interface.
571  *
572  * This implementation is agnostic to the way tokens are created. This means
573  * that a supply mechanism has to be added in a derived contract using `_mint`.
574  *
575  * Support for ERC20 is included in this contract, as specified by the EIP: both
576  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
577  * Both `IERC777.Sent` and `IERC20.Transfer` events are emitted on token
578  * movements.
579  *
580  * Additionally, the `granularity` value is hard-coded to `1`, meaning that there
581  * are no special restrictions in the amount of tokens that created, moved, or
582  * destroyed. This makes integration with ERC20 applications seamless.
583  */
584 contract ERC777 is IERC777, IERC20 {
585     using SafeMath for uint256;
586     using Address for address;
587 
588     IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
589 
590     mapping(address => uint256) private _balances;
591 
592     uint256 private _totalSupply;
593 
594     string private _name;
595     string private _symbol;
596 
597     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
598     // See https://github.com/ethereum/solidity/issues/4024.
599 
600     // keccak256("ERC777TokensSender")
601     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
602         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
603 
604     // keccak256("ERC777TokensRecipient")
605     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
606         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
607 
608     // This isn't ever read from - it's only used to respond to the defaultOperators query.
609     address[] private _defaultOperatorsArray;
610 
611     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
612     mapping(address => bool) private _defaultOperators;
613 
614     // For each account, a mapping of its operators and revoked default operators.
615     mapping(address => mapping(address => bool)) private _operators;
616     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
617 
618     // ERC20-allowances
619     mapping (address => mapping (address => uint256)) private _allowances;
620 
621     /**
622      * @dev `defaultOperators` may be an empty array.
623      */
624     constructor(
625         string memory name,
626         string memory symbol,
627         address[] memory defaultOperators
628     ) public {
629         _name = name;
630         _symbol = symbol;
631 
632         _defaultOperatorsArray = defaultOperators;
633         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
634             _defaultOperators[_defaultOperatorsArray[i]] = true;
635         }
636 
637         // register interfaces
638         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
639         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
640     }
641 
642     /**
643      * @dev See `IERC777.name`.
644      */
645     function name() public view returns (string memory) {
646         return _name;
647     }
648 
649     /**
650      * @dev See `IERC777.symbol`.
651      */
652     function symbol() public view returns (string memory) {
653         return _symbol;
654     }
655 
656     /**
657      * @dev See `ERC20Detailed.decimals`.
658      *
659      * Always returns 18, as per the
660      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
661      */
662     function decimals() public pure returns (uint8) {
663         return 18;
664     }
665 
666     /**
667      * @dev See `IERC777.granularity`.
668      *
669      * This implementation always returns `1`.
670      */
671     function granularity() public view returns (uint256) {
672         return 1;
673     }
674 
675     /**
676      * @dev See `IERC777.totalSupply`.
677      */
678     function totalSupply() public view returns (uint256) {
679         return _totalSupply;
680     }
681 
682     /**
683      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
684      */
685     function balanceOf(address tokenHolder) public view returns (uint256) {
686         return _balances[tokenHolder];
687     }
688 
689     /**
690      * @dev See `IERC777.send`.
691      *
692      * Also emits a `Transfer` event for ERC20 compatibility.
693      */
694     function send(address recipient, uint256 amount, bytes memory data) public {
695         _send(msg.sender, msg.sender, recipient, amount, data, "", true);
696     }
697 
698     /**
699      * @dev See `IERC20.transfer`.
700      *
701      * Unlike `send`, `recipient` is _not_ required to implement the `tokensReceived`
702      * interface if it is a contract.
703      *
704      * Also emits a `Sent` event.
705      */
706     function transfer(address recipient, uint256 amount) public returns (bool) {
707         require(recipient != address(0), "ERC777: transfer to the zero address");
708 
709         address from = msg.sender;
710 
711         _callTokensToSend(from, from, recipient, amount, "", "");
712 
713         _move(from, from, recipient, amount, "", "");
714 
715         _callTokensReceived(from, from, recipient, amount, "", "", false);
716 
717         return true;
718     }
719 
720     /**
721      * @dev See `IERC777.burn`.
722      *
723      * Also emits a `Transfer` event for ERC20 compatibility.
724      */
725     function burn(uint256 amount, bytes memory data) public {
726         _burn(msg.sender, msg.sender, amount, data, "");
727     }
728 
729     /**
730      * @dev See `IERC777.isOperatorFor`.
731      */
732     function isOperatorFor(
733         address operator,
734         address tokenHolder
735     ) public view returns (bool) {
736         return operator == tokenHolder ||
737             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
738             _operators[tokenHolder][operator];
739     }
740 
741     /**
742      * @dev See `IERC777.authorizeOperator`.
743      */
744     function authorizeOperator(address operator) external {
745         require(msg.sender != operator, "ERC777: authorizing self as operator");
746 
747         if (_defaultOperators[operator]) {
748             delete _revokedDefaultOperators[msg.sender][operator];
749         } else {
750             _operators[msg.sender][operator] = true;
751         }
752 
753         emit AuthorizedOperator(operator, msg.sender);
754     }
755 
756     /**
757      * @dev See `IERC777.revokeOperator`.
758      */
759     function revokeOperator(address operator) external {
760         require(operator != msg.sender, "ERC777: revoking self as operator");
761 
762         if (_defaultOperators[operator]) {
763             _revokedDefaultOperators[msg.sender][operator] = true;
764         } else {
765             delete _operators[msg.sender][operator];
766         }
767 
768         emit RevokedOperator(operator, msg.sender);
769     }
770 
771     /**
772      * @dev See `IERC777.defaultOperators`.
773      */
774     function defaultOperators() public view returns (address[] memory) {
775         return _defaultOperatorsArray;
776     }
777 
778     /**
779      * @dev See `IERC777.operatorSend`.
780      *
781      * Emits `Sent` and `Transfer` events.
782      */
783     function operatorSend(
784         address sender,
785         address recipient,
786         uint256 amount,
787         bytes memory data,
788         bytes memory operatorData
789     )
790     public
791     {
792         require(isOperatorFor(msg.sender, sender), "ERC777: caller is not an operator for holder");
793         _send(msg.sender, sender, recipient, amount, data, operatorData, true);
794     }
795 
796     /**
797      * @dev See `IERC777.operatorBurn`.
798      *
799      * Emits `Sent` and `Transfer` events.
800      */
801     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public {
802         require(isOperatorFor(msg.sender, account), "ERC777: caller is not an operator for holder");
803         _burn(msg.sender, account, amount, data, operatorData);
804     }
805 
806     /**
807      * @dev See `IERC20.allowance`.
808      *
809      * Note that operator and allowance concepts are orthogonal: operators may
810      * not have allowance, and accounts with allowance may not be operators
811      * themselves.
812      */
813     function allowance(address holder, address spender) public view returns (uint256) {
814         return _allowances[holder][spender];
815     }
816 
817     /**
818      * @dev See `IERC20.approve`.
819      *
820      * Note that accounts cannot have allowance issued by their operators.
821      */
822     function approve(address spender, uint256 value) external returns (bool) {
823         address holder = msg.sender;
824         _approve(holder, spender, value);
825         return true;
826     }
827 
828    /**
829     * @dev See `IERC20.transferFrom`.
830     *
831     * Note that operator and allowance concepts are orthogonal: operators cannot
832     * call `transferFrom` (unless they have allowance), and accounts with
833     * allowance cannot call `operatorSend` (unless they are operators).
834     *
835     * Emits `Sent` and `Transfer` events.
836     */
837     function transferFrom(address holder, address recipient, uint256 amount) public returns (bool) {
838         require(recipient != address(0), "ERC777: transfer to the zero address");
839         require(holder != address(0), "ERC777: transfer from the zero address");
840 
841         address spender = msg.sender;
842 
843         _callTokensToSend(spender, holder, recipient, amount, "", "");
844 
845         _move(spender, holder, recipient, amount, "", "");
846         _approve(holder, spender, _allowances[holder][spender].sub(amount));
847 
848         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
849 
850         return true;
851     }
852 
853     /**
854      * @dev Creates `amount` tokens and assigns them to `account`, increasing
855      * the total supply.
856      *
857      * If a send hook is registered for `raccount`, the corresponding function
858      * will be called with `operator`, `data` and `operatorData`.
859      *
860      * See `IERC777Sender` and `IERC777Recipient`.
861      *
862      * Emits `Sent` and `Transfer` events.
863      *
864      * Requirements
865      *
866      * - `account` cannot be the zero address.
867      * - if `account` is a contract, it must implement the `tokensReceived`
868      * interface.
869      */
870     function _mint(
871         address operator,
872         address account,
873         uint256 amount,
874         bytes memory userData,
875         bytes memory operatorData
876     )
877     internal
878     {
879         require(account != address(0), "ERC777: mint to the zero address");
880 
881         // Update state variables
882         _totalSupply = _totalSupply.add(amount);
883         _balances[account] = _balances[account].add(amount);
884 
885         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
886 
887         emit Minted(operator, account, amount, userData, operatorData);
888         emit Transfer(address(0), account, amount);
889     }
890 
891     /**
892      * @dev Send tokens
893      * @param operator address operator requesting the transfer
894      * @param from address token holder address
895      * @param to address recipient address
896      * @param amount uint256 amount of tokens to transfer
897      * @param userData bytes extra information provided by the token holder (if any)
898      * @param operatorData bytes extra information provided by the operator (if any)
899      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
900      */
901     function _send(
902         address operator,
903         address from,
904         address to,
905         uint256 amount,
906         bytes memory userData,
907         bytes memory operatorData,
908         bool requireReceptionAck
909     )
910         private
911     {
912         require(from != address(0), "ERC777: send from the zero address");
913         require(to != address(0), "ERC777: send to the zero address");
914 
915         _callTokensToSend(operator, from, to, amount, userData, operatorData);
916 
917         _move(operator, from, to, amount, userData, operatorData);
918 
919         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
920     }
921 
922     /**
923      * @dev Burn tokens
924      * @param operator address operator requesting the operation
925      * @param from address token holder address
926      * @param amount uint256 amount of tokens to burn
927      * @param data bytes extra information provided by the token holder
928      * @param operatorData bytes extra information provided by the operator (if any)
929      */
930     function _burn(
931         address operator,
932         address from,
933         uint256 amount,
934         bytes memory data,
935         bytes memory operatorData
936     )
937         private
938     {
939         require(from != address(0), "ERC777: burn from the zero address");
940 
941         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
942 
943         // Update state variables
944         _totalSupply = _totalSupply.sub(amount);
945         _balances[from] = _balances[from].sub(amount);
946 
947         emit Burned(operator, from, amount, data, operatorData);
948         emit Transfer(from, address(0), amount);
949     }
950 
951     function _move(
952         address operator,
953         address from,
954         address to,
955         uint256 amount,
956         bytes memory userData,
957         bytes memory operatorData
958     )
959         private
960     {
961         _balances[from] = _balances[from].sub(amount);
962         _balances[to] = _balances[to].add(amount);
963 
964         emit Sent(operator, from, to, amount, userData, operatorData);
965         emit Transfer(from, to, amount);
966     }
967 
968     function _approve(address holder, address spender, uint256 value) private {
969         // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
970         // currently unnecessary.
971         //require(holder != address(0), "ERC777: approve from the zero address");
972         require(spender != address(0), "ERC777: approve to the zero address");
973 
974         _allowances[holder][spender] = value;
975         emit Approval(holder, spender, value);
976     }
977 
978     /**
979      * @dev Call from.tokensToSend() if the interface is registered
980      * @param operator address operator requesting the transfer
981      * @param from address token holder address
982      * @param to address recipient address
983      * @param amount uint256 amount of tokens to transfer
984      * @param userData bytes extra information provided by the token holder (if any)
985      * @param operatorData bytes extra information provided by the operator (if any)
986      */
987     function _callTokensToSend(
988         address operator,
989         address from,
990         address to,
991         uint256 amount,
992         bytes memory userData,
993         bytes memory operatorData
994     )
995         private
996     {
997         address implementer = _erc1820.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
998         if (implementer != address(0)) {
999             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1000         }
1001     }
1002 
1003     /**
1004      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1005      * tokensReceived() was not registered for the recipient
1006      * @param operator address operator requesting the transfer
1007      * @param from address token holder address
1008      * @param to address recipient address
1009      * @param amount uint256 amount of tokens to transfer
1010      * @param userData bytes extra information provided by the token holder (if any)
1011      * @param operatorData bytes extra information provided by the operator (if any)
1012      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1013      */
1014     function _callTokensReceived(
1015         address operator,
1016         address from,
1017         address to,
1018         uint256 amount,
1019         bytes memory userData,
1020         bytes memory operatorData,
1021         bool requireReceptionAck
1022     )
1023         private
1024     {
1025         address implementer = _erc1820.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1026         if (implementer != address(0)) {
1027             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1028         } else if (requireReceptionAck) {
1029             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1030         }
1031     }
1032 }
1033 
1034 /**
1035  * @title Roles
1036  * @dev Library for managing addresses assigned to a Role.
1037  */
1038 library Roles {
1039     struct Role {
1040         mapping (address => bool) bearer;
1041     }
1042 
1043     /**
1044      * @dev Give an account access to this role.
1045      */
1046     function add(Role storage role, address account) internal {
1047         require(!has(role, account), "Roles: account already has role");
1048         role.bearer[account] = true;
1049     }
1050 
1051     /**
1052      * @dev Remove an account's access to this role.
1053      */
1054     function remove(Role storage role, address account) internal {
1055         require(has(role, account), "Roles: account does not have role");
1056         role.bearer[account] = false;
1057     }
1058 
1059     /**
1060      * @dev Check if an account has this role.
1061      * @return bool
1062      */
1063     function has(Role storage role, address account) internal view returns (bool) {
1064         require(account != address(0), "Roles: account is the zero address");
1065         return role.bearer[account];
1066     }
1067 }
1068 
1069 contract PauserRole {
1070     using Roles for Roles.Role;
1071 
1072     event PauserAdded(address indexed account);
1073     event PauserRemoved(address indexed account);
1074 
1075     Roles.Role private _pausers;
1076 
1077     constructor () internal {
1078         _addPauser(msg.sender);
1079     }
1080 
1081     modifier onlyPauser() {
1082         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
1083         _;
1084     }
1085 
1086     function isPauser(address account) public view returns (bool) {
1087         return _pausers.has(account);
1088     }
1089 
1090     function addPauser(address account) public onlyPauser {
1091         _addPauser(account);
1092     }
1093 
1094     function renouncePauser() public {
1095         _removePauser(msg.sender);
1096     }
1097 
1098     function _addPauser(address account) internal {
1099         _pausers.add(account);
1100         emit PauserAdded(account);
1101     }
1102 
1103     function _removePauser(address account) internal {
1104         _pausers.remove(account);
1105         emit PauserRemoved(account);
1106     }
1107 }
1108 
1109 /**
1110  * @dev Contract module which allows children to implement an emergency stop
1111  * mechanism that can be triggered by an authorized account.
1112  *
1113  * This module is used through inheritance. It will make available the
1114  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1115  * the functions of your contract. Note that they will not be pausable by
1116  * simply including this module, only once the modifiers are put in place.
1117  */
1118 contract Pausable is PauserRole {
1119     /**
1120      * @dev Emitted when the pause is triggered by a pauser (`account`).
1121      */
1122     event Paused(address account);
1123 
1124     /**
1125      * @dev Emitted when the pause is lifted by a pauser (`account`).
1126      */
1127     event Unpaused(address account);
1128 
1129     bool private _paused;
1130 
1131     /**
1132      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1133      * to the deployer.
1134      */
1135     constructor () internal {
1136         _paused = false;
1137     }
1138 
1139     /**
1140      * @dev Returns true if the contract is paused, and false otherwise.
1141      */
1142     function paused() public view returns (bool) {
1143         return _paused;
1144     }
1145 
1146     /**
1147      * @dev Modifier to make a function callable only when the contract is not paused.
1148      */
1149     modifier whenNotPaused() {
1150         require(!_paused, "Pausable: paused");
1151         _;
1152     }
1153 
1154     /**
1155      * @dev Modifier to make a function callable only when the contract is paused.
1156      */
1157     modifier whenPaused() {
1158         require(_paused, "Pausable: not paused");
1159         _;
1160     }
1161 
1162     /**
1163      * @dev Called by a pauser to pause, triggers stopped state.
1164      */
1165     function pause() public onlyPauser whenNotPaused {
1166         _paused = true;
1167         emit Paused(msg.sender);
1168     }
1169 
1170     /**
1171      * @dev Called by a pauser to unpause, returns to normal state.
1172      */
1173     function unpause() public onlyPauser whenPaused {
1174         _paused = false;
1175         emit Unpaused(msg.sender);
1176     }
1177 }
1178 
1179 /**
1180  * @title Pausable token
1181  * @dev ERC20 modified with pausable transfers.
1182  */
1183 contract ERC777Pausable is ERC777, Pausable {
1184 
1185     constructor(string memory name, string memory symbol, address[] memory defaultOperators) 
1186         ERC777(name, symbol, defaultOperators) public {}
1187 
1188     //== Pause ERC20 transfers ==
1189     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
1190         return super.transfer(to, value);
1191     }
1192 
1193     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
1194         return super.transferFrom(from, to, value);
1195     }
1196 
1197     function burn(uint256 amount, bytes memory data) public whenNotPaused {
1198         super.burn(amount, data);
1199     }
1200 
1201     //== Pause ERC777 transfers ==
1202     function send(address recipient, uint256 amount, bytes memory data) public whenNotPaused{
1203         super.send(recipient, amount, data);
1204     }
1205 
1206     function operatorSend(address sender, address recipient, uint256 amount, bytes memory data, bytes memory operatorData) public whenNotPaused {
1207         super.operatorSend(sender, recipient, amount, data, operatorData);
1208     }
1209 
1210     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public whenNotPaused {
1211         super.operatorBurn(account, amount, data, operatorData);
1212     }
1213 
1214 }
1215 
1216 contract ZDRToken is ERC777Pausable {
1217     string constant NAME    = 'Zloadr Token';
1218     string constant SYMBOL  = 'ZDR';
1219     uint8 constant  DECIMALS= 18;   //Required by ERC777
1220     uint256 constant TOTAL_SUPPLY = 100_000_000 * (uint256(10)**DECIMALS);
1221 
1222     constructor(address[] memory defaultOperators) ERC777Pausable(NAME, SYMBOL, defaultOperators) public {
1223         _mint(msg.sender, msg.sender, TOTAL_SUPPLY, '', '');
1224     }
1225 }