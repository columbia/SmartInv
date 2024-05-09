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
31 // File: @openzeppelin/contracts/token/ERC777/IERC777.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC777Token standard as defined in the EIP.
37  *
38  * This contract uses the
39  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
40  * token holders and recipients react to token movements by using setting implementers
41  * for the associated interfaces in said registry. See {IERC1820Registry} and
42  * {ERC1820Implementer}.
43  */
44 interface IERC777 {
45     /**
46      * @dev Returns the name of the token.
47      */
48     function name() external view returns (string memory);
49 
50     /**
51      * @dev Returns the symbol of the token, usually a shorter version of the
52      * name.
53      */
54     function symbol() external view returns (string memory);
55 
56     /**
57      * @dev Returns the smallest part of the token that is not divisible. This
58      * means all token operations (creation, movement and destruction) must have
59      * amounts that are a multiple of this number.
60      *
61      * For most token contracts, this value will equal 1.
62      */
63     function granularity() external view returns (uint256);
64 
65     /**
66      * @dev Returns the amount of tokens in existence.
67      */
68     function totalSupply() external view returns (uint256);
69 
70     /**
71      * @dev Returns the amount of tokens owned by an account (`owner`).
72      */
73     function balanceOf(address owner) external view returns (uint256);
74 
75     /**
76      * @dev Moves `amount` tokens from the caller's account to `recipient`.
77      *
78      * If send or receive hooks are registered for the caller and `recipient`,
79      * the corresponding functions will be called with `data` and empty
80      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
81      *
82      * Emits a {Sent} event.
83      *
84      * Requirements
85      *
86      * - the caller must have at least `amount` tokens.
87      * - `recipient` cannot be the zero address.
88      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
89      * interface.
90      */
91     function send(address recipient, uint256 amount, bytes calldata data) external;
92 
93     /**
94      * @dev Destroys `amount` tokens from the caller's account, reducing the
95      * total supply.
96      *
97      * If a send hook is registered for the caller, the corresponding function
98      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
99      *
100      * Emits a {Burned} event.
101      *
102      * Requirements
103      *
104      * - the caller must have at least `amount` tokens.
105      */
106     function burn(uint256 amount, bytes calldata data) external;
107 
108     /**
109      * @dev Returns true if an account is an operator of `tokenHolder`.
110      * Operators can send and burn tokens on behalf of their owners. All
111      * accounts are their own operator.
112      *
113      * See {operatorSend} and {operatorBurn}.
114      */
115     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
116 
117     /**
118      * @dev Make an account an operator of the caller.
119      *
120      * See {isOperatorFor}.
121      *
122      * Emits an {AuthorizedOperator} event.
123      *
124      * Requirements
125      *
126      * - `operator` cannot be calling address.
127      */
128     function authorizeOperator(address operator) external;
129 
130     /**
131      * @dev Make an account an operator of the caller.
132      *
133      * See {isOperatorFor} and {defaultOperators}.
134      *
135      * Emits a {RevokedOperator} event.
136      *
137      * Requirements
138      *
139      * - `operator` cannot be calling address.
140      */
141     function revokeOperator(address operator) external;
142 
143     /**
144      * @dev Returns the list of default operators. These accounts are operators
145      * for all token holders, even if {authorizeOperator} was never called on
146      * them.
147      *
148      * This list is immutable, but individual holders may revoke these via
149      * {revokeOperator}, in which case {isOperatorFor} will return false.
150      */
151     function defaultOperators() external view returns (address[] memory);
152 
153     /**
154      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
155      * be an operator of `sender`.
156      *
157      * If send or receive hooks are registered for `sender` and `recipient`,
158      * the corresponding functions will be called with `data` and
159      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
160      *
161      * Emits a {Sent} event.
162      *
163      * Requirements
164      *
165      * - `sender` cannot be the zero address.
166      * - `sender` must have at least `amount` tokens.
167      * - the caller must be an operator for `sender`.
168      * - `recipient` cannot be the zero address.
169      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
170      * interface.
171      */
172     function operatorSend(
173         address sender,
174         address recipient,
175         uint256 amount,
176         bytes calldata data,
177         bytes calldata operatorData
178     ) external;
179 
180     /**
181      * @dev Destoys `amount` tokens from `account`, reducing the total supply.
182      * The caller must be an operator of `account`.
183      *
184      * If a send hook is registered for `account`, the corresponding function
185      * will be called with `data` and `operatorData`. See {IERC777Sender}.
186      *
187      * Emits a {Burned} event.
188      *
189      * Requirements
190      *
191      * - `account` cannot be the zero address.
192      * - `account` must have at least `amount` tokens.
193      * - the caller must be an operator for `account`.
194      */
195     function operatorBurn(
196         address account,
197         uint256 amount,
198         bytes calldata data,
199         bytes calldata operatorData
200     ) external;
201 
202     event Sent(
203         address indexed operator,
204         address indexed from,
205         address indexed to,
206         uint256 amount,
207         bytes data,
208         bytes operatorData
209     );
210 
211     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
212 
213     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
214 
215     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
216 
217     event RevokedOperator(address indexed operator, address indexed tokenHolder);
218 }
219 
220 // File: @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol
221 
222 pragma solidity ^0.5.0;
223 
224 /**
225  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
226  *
227  * Accounts can be notified of {IERC777} tokens being sent to them by having a
228  * contract implement this interface (contract holders can be their own
229  * implementer) and registering it on the
230  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
231  *
232  * See {IERC1820Registry} and {ERC1820Implementer}.
233  */
234 interface IERC777Recipient {
235     /**
236      * @dev Called by an {IERC777} token contract whenever tokens are being
237      * moved or created into a registered account (`to`). The type of operation
238      * is conveyed by `from` being the zero address or not.
239      *
240      * This call occurs _after_ the token contract's state is updated, so
241      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
242      *
243      * This function may revert to prevent the operation from being executed.
244      */
245     function tokensReceived(
246         address operator,
247         address from,
248         address to,
249         uint256 amount,
250         bytes calldata userData,
251         bytes calldata operatorData
252     ) external;
253 }
254 
255 // File: @openzeppelin/contracts/token/ERC777/IERC777Sender.sol
256 
257 pragma solidity ^0.5.0;
258 
259 /**
260  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
261  *
262  * {IERC777} Token holders can be notified of operations performed on their
263  * tokens by having a contract implement this interface (contract holders can be
264  *  their own implementer) and registering it on the
265  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
266  *
267  * See {IERC1820Registry} and {ERC1820Implementer}.
268  */
269 interface IERC777Sender {
270     /**
271      * @dev Called by an {IERC777} token contract whenever a registered holder's
272      * (`from`) tokens are about to be moved or destroyed. The type of operation
273      * is conveyed by `to` being the zero address or not.
274      *
275      * This call occurs _before_ the token contract's state is updated, so
276      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
277      *
278      * This function may revert to prevent the operation from being executed.
279      */
280     function tokensToSend(
281         address operator,
282         address from,
283         address to,
284         uint256 amount,
285         bytes calldata userData,
286         bytes calldata operatorData
287     ) external;
288 }
289 
290 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
291 
292 pragma solidity ^0.5.0;
293 
294 /**
295  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
296  * the optional functions; to access them see {ERC20Detailed}.
297  */
298 interface IERC20 {
299     /**
300      * @dev Returns the amount of tokens in existence.
301      */
302     function totalSupply() external view returns (uint256);
303 
304     /**
305      * @dev Returns the amount of tokens owned by `account`.
306      */
307     function balanceOf(address account) external view returns (uint256);
308 
309     /**
310      * @dev Moves `amount` tokens from the caller's account to `recipient`.
311      *
312      * Returns a boolean value indicating whether the operation succeeded.
313      *
314      * Emits a {Transfer} event.
315      */
316     function transfer(address recipient, uint256 amount) external returns (bool);
317 
318     /**
319      * @dev Returns the remaining number of tokens that `spender` will be
320      * allowed to spend on behalf of `owner` through {transferFrom}. This is
321      * zero by default.
322      *
323      * This value changes when {approve} or {transferFrom} are called.
324      */
325     function allowance(address owner, address spender) external view returns (uint256);
326 
327     /**
328      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
329      *
330      * Returns a boolean value indicating whether the operation succeeded.
331      *
332      * IMPORTANT: Beware that changing an allowance with this method brings the risk
333      * that someone may use both the old and the new allowance by unfortunate
334      * transaction ordering. One possible solution to mitigate this race
335      * condition is to first reduce the spender's allowance to 0 and set the
336      * desired value afterwards:
337      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
338      *
339      * Emits an {Approval} event.
340      */
341     function approve(address spender, uint256 amount) external returns (bool);
342 
343     /**
344      * @dev Moves `amount` tokens from `sender` to `recipient` using the
345      * allowance mechanism. `amount` is then deducted from the caller's
346      * allowance.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Emitted when `value` tokens are moved from one account (`from`) to
356      * another (`to`).
357      *
358      * Note that `value` may be zero.
359      */
360     event Transfer(address indexed from, address indexed to, uint256 value);
361 
362     /**
363      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
364      * a call to {approve}. `value` is the new allowance.
365      */
366     event Approval(address indexed owner, address indexed spender, uint256 value);
367 }
368 
369 // File: @openzeppelin/contracts/math/SafeMath.sol
370 
371 pragma solidity ^0.5.0;
372 
373 /**
374  * @dev Wrappers over Solidity's arithmetic operations with added overflow
375  * checks.
376  *
377  * Arithmetic operations in Solidity wrap on overflow. This can easily result
378  * in bugs, because programmers usually assume that an overflow raises an
379  * error, which is the standard behavior in high level programming languages.
380  * `SafeMath` restores this intuition by reverting the transaction when an
381  * operation overflows.
382  *
383  * Using this library instead of the unchecked operations eliminates an entire
384  * class of bugs, so it's recommended to use it always.
385  */
386 library SafeMath {
387     /**
388      * @dev Returns the addition of two unsigned integers, reverting on
389      * overflow.
390      *
391      * Counterpart to Solidity's `+` operator.
392      *
393      * Requirements:
394      * - Addition cannot overflow.
395      */
396     function add(uint256 a, uint256 b) internal pure returns (uint256) {
397         uint256 c = a + b;
398         require(c >= a, "SafeMath: addition overflow");
399 
400         return c;
401     }
402 
403     /**
404      * @dev Returns the subtraction of two unsigned integers, reverting on
405      * overflow (when the result is negative).
406      *
407      * Counterpart to Solidity's `-` operator.
408      *
409      * Requirements:
410      * - Subtraction cannot overflow.
411      */
412     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
413         return sub(a, b, "SafeMath: subtraction overflow");
414     }
415 
416     /**
417      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
418      * overflow (when the result is negative).
419      *
420      * Counterpart to Solidity's `-` operator.
421      *
422      * Requirements:
423      * - Subtraction cannot overflow.
424      *
425      * _Available since v2.4.0._
426      */
427     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
428         require(b <= a, errorMessage);
429         uint256 c = a - b;
430 
431         return c;
432     }
433 
434     /**
435      * @dev Returns the multiplication of two unsigned integers, reverting on
436      * overflow.
437      *
438      * Counterpart to Solidity's `*` operator.
439      *
440      * Requirements:
441      * - Multiplication cannot overflow.
442      */
443     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
444         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
445         // benefit is lost if 'b' is also tested.
446         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
447         if (a == 0) {
448             return 0;
449         }
450 
451         uint256 c = a * b;
452         require(c / a == b, "SafeMath: multiplication overflow");
453 
454         return c;
455     }
456 
457     /**
458      * @dev Returns the integer division of two unsigned integers. Reverts on
459      * division by zero. The result is rounded towards zero.
460      *
461      * Counterpart to Solidity's `/` operator. Note: this function uses a
462      * `revert` opcode (which leaves remaining gas untouched) while Solidity
463      * uses an invalid opcode to revert (consuming all remaining gas).
464      *
465      * Requirements:
466      * - The divisor cannot be zero.
467      */
468     function div(uint256 a, uint256 b) internal pure returns (uint256) {
469         return div(a, b, "SafeMath: division by zero");
470     }
471 
472     /**
473      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
474      * division by zero. The result is rounded towards zero.
475      *
476      * Counterpart to Solidity's `/` operator. Note: this function uses a
477      * `revert` opcode (which leaves remaining gas untouched) while Solidity
478      * uses an invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      * - The divisor cannot be zero.
482      *
483      * _Available since v2.4.0._
484      */
485     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
486         // Solidity only automatically asserts when dividing by 0
487         require(b > 0, errorMessage);
488         uint256 c = a / b;
489         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
490 
491         return c;
492     }
493 
494     /**
495      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
496      * Reverts when dividing by zero.
497      *
498      * Counterpart to Solidity's `%` operator. This function uses a `revert`
499      * opcode (which leaves remaining gas untouched) while Solidity uses an
500      * invalid opcode to revert (consuming all remaining gas).
501      *
502      * Requirements:
503      * - The divisor cannot be zero.
504      */
505     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
506         return mod(a, b, "SafeMath: modulo by zero");
507     }
508 
509     /**
510      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
511      * Reverts with custom message when dividing by zero.
512      *
513      * Counterpart to Solidity's `%` operator. This function uses a `revert`
514      * opcode (which leaves remaining gas untouched) while Solidity uses an
515      * invalid opcode to revert (consuming all remaining gas).
516      *
517      * Requirements:
518      * - The divisor cannot be zero.
519      *
520      * _Available since v2.4.0._
521      */
522     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
523         require(b != 0, errorMessage);
524         return a % b;
525     }
526 }
527 
528 // File: @openzeppelin/contracts/utils/Address.sol
529 
530 pragma solidity ^0.5.5;
531 
532 /**
533  * @dev Collection of functions related to the address type
534  */
535 library Address {
536     /**
537      * @dev Returns true if `account` is a contract.
538      *
539      * [IMPORTANT]
540      * ====
541      * It is unsafe to assume that an address for which this function returns
542      * false is an externally-owned account (EOA) and not a contract.
543      *
544      * Among others, `isContract` will return false for the following 
545      * types of addresses:
546      *
547      *  - an externally-owned account
548      *  - a contract in construction
549      *  - an address where a contract will be created
550      *  - an address where a contract lived, but was destroyed
551      * ====
552      */
553     function isContract(address account) internal view returns (bool) {
554         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
555         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
556         // for accounts without code, i.e. `keccak256('')`
557         bytes32 codehash;
558         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
559         // solhint-disable-next-line no-inline-assembly
560         assembly { codehash := extcodehash(account) }
561         return (codehash != accountHash && codehash != 0x0);
562     }
563 
564     /**
565      * @dev Converts an `address` into `address payable`. Note that this is
566      * simply a type cast: the actual underlying value is not changed.
567      *
568      * _Available since v2.4.0._
569      */
570     function toPayable(address account) internal pure returns (address payable) {
571         return address(uint160(account));
572     }
573 
574     /**
575      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
576      * `recipient`, forwarding all available gas and reverting on errors.
577      *
578      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
579      * of certain opcodes, possibly making contracts go over the 2300 gas limit
580      * imposed by `transfer`, making them unable to receive funds via
581      * `transfer`. {sendValue} removes this limitation.
582      *
583      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
584      *
585      * IMPORTANT: because control is transferred to `recipient`, care must be
586      * taken to not create reentrancy vulnerabilities. Consider using
587      * {ReentrancyGuard} or the
588      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
589      *
590      * _Available since v2.4.0._
591      */
592     function sendValue(address payable recipient, uint256 amount) internal {
593         require(address(this).balance >= amount, "Address: insufficient balance");
594 
595         // solhint-disable-next-line avoid-call-value
596         (bool success, ) = recipient.call.value(amount)("");
597         require(success, "Address: unable to send value, recipient may have reverted");
598     }
599 }
600 
601 // File: @openzeppelin/contracts/introspection/IERC1820Registry.sol
602 
603 pragma solidity ^0.5.0;
604 
605 /**
606  * @dev Interface of the global ERC1820 Registry, as defined in the
607  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
608  * implementers for interfaces in this registry, as well as query support.
609  *
610  * Implementers may be shared by multiple accounts, and can also implement more
611  * than a single interface for each account. Contracts can implement interfaces
612  * for themselves, but externally-owned accounts (EOA) must delegate this to a
613  * contract.
614  *
615  * {IERC165} interfaces can also be queried via the registry.
616  *
617  * For an in-depth explanation and source code analysis, see the EIP text.
618  */
619 interface IERC1820Registry {
620     /**
621      * @dev Sets `newManager` as the manager for `account`. A manager of an
622      * account is able to set interface implementers for it.
623      *
624      * By default, each account is its own manager. Passing a value of `0x0` in
625      * `newManager` will reset the manager to this initial state.
626      *
627      * Emits a {ManagerChanged} event.
628      *
629      * Requirements:
630      *
631      * - the caller must be the current manager for `account`.
632      */
633     function setManager(address account, address newManager) external;
634 
635     /**
636      * @dev Returns the manager for `account`.
637      *
638      * See {setManager}.
639      */
640     function getManager(address account) external view returns (address);
641 
642     /**
643      * @dev Sets the `implementer` contract as `account`'s implementer for
644      * `interfaceHash`.
645      *
646      * `account` being the zero address is an alias for the caller's address.
647      * The zero address can also be used in `implementer` to remove an old one.
648      *
649      * See {interfaceHash} to learn how these are created.
650      *
651      * Emits an {InterfaceImplementerSet} event.
652      *
653      * Requirements:
654      *
655      * - the caller must be the current manager for `account`.
656      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
657      * end in 28 zeroes).
658      * - `implementer` must implement {IERC1820Implementer} and return true when
659      * queried for support, unless `implementer` is the caller. See
660      * {IERC1820Implementer-canImplementInterfaceForAddress}.
661      */
662     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
663 
664     /**
665      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
666      * implementer is registered, returns the zero address.
667      *
668      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
669      * zeroes), `account` will be queried for support of it.
670      *
671      * `account` being the zero address is an alias for the caller's address.
672      */
673     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
674 
675     /**
676      * @dev Returns the interface hash for an `interfaceName`, as defined in the
677      * corresponding
678      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
679      */
680     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
681 
682     /**
683      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
684      *  @param account Address of the contract for which to update the cache.
685      *  @param interfaceId ERC165 interface for which to update the cache.
686      */
687     function updateERC165Cache(address account, bytes4 interfaceId) external;
688 
689     /**
690      *  @notice Checks whether a contract implements an ERC165 interface or not.
691      *  If the result is not cached a direct lookup on the contract address is performed.
692      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
693      *  {updateERC165Cache} with the contract address.
694      *  @param account Address of the contract to check.
695      *  @param interfaceId ERC165 interface to check.
696      *  @return True if `account` implements `interfaceId`, false otherwise.
697      */
698     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
699 
700     /**
701      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
702      *  @param account Address of the contract to check.
703      *  @param interfaceId ERC165 interface to check.
704      *  @return True if `account` implements `interfaceId`, false otherwise.
705      */
706     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
707 
708     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
709 
710     event ManagerChanged(address indexed account, address indexed newManager);
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC777/ERC777.sol
714 
715 pragma solidity ^0.5.0;
716 
717 
718 
719 
720 
721 
722 
723 
724 
725 /**
726  * @dev Implementation of the {IERC777} interface.
727  *
728  * This implementation is agnostic to the way tokens are created. This means
729  * that a supply mechanism has to be added in a derived contract using {_mint}.
730  *
731  * Support for ERC20 is included in this contract, as specified by the EIP: both
732  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
733  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
734  * movements.
735  *
736  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
737  * are no special restrictions in the amount of tokens that created, moved, or
738  * destroyed. This makes integration with ERC20 applications seamless.
739  */
740 contract ERC777 is Context, IERC777, IERC20 {
741     using SafeMath for uint256;
742     using Address for address;
743 
744     IERC1820Registry constant internal ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
745 
746     mapping(address => uint256) private _balances;
747 
748     uint256 private _totalSupply;
749 
750     string private _name;
751     string private _symbol;
752 
753     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
754     // See https://github.com/ethereum/solidity/issues/4024.
755 
756     // keccak256("ERC777TokensSender")
757     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
758         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
759 
760     // keccak256("ERC777TokensRecipient")
761     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
762         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
763 
764     // This isn't ever read from - it's only used to respond to the defaultOperators query.
765     address[] private _defaultOperatorsArray;
766 
767     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
768     mapping(address => bool) private _defaultOperators;
769 
770     // For each account, a mapping of its operators and revoked default operators.
771     mapping(address => mapping(address => bool)) private _operators;
772     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
773 
774     // ERC20-allowances
775     mapping (address => mapping (address => uint256)) private _allowances;
776 
777     /**
778      * @dev `defaultOperators` may be an empty array.
779      */
780     constructor(
781         string memory name,
782         string memory symbol,
783         address[] memory defaultOperators
784     ) public {
785         _name = name;
786         _symbol = symbol;
787 
788         _defaultOperatorsArray = defaultOperators;
789         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
790             _defaultOperators[_defaultOperatorsArray[i]] = true;
791         }
792 
793         // register interfaces
794         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
795         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
796     }
797 
798     /**
799      * @dev See {IERC777-name}.
800      */
801     function name() public view returns (string memory) {
802         return _name;
803     }
804 
805     /**
806      * @dev See {IERC777-symbol}.
807      */
808     function symbol() public view returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev See {ERC20Detailed-decimals}.
814      *
815      * Always returns 18, as per the
816      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
817      */
818     function decimals() public pure returns (uint8) {
819         return 18;
820     }
821 
822     /**
823      * @dev See {IERC777-granularity}.
824      *
825      * This implementation always returns `1`.
826      */
827     function granularity() public view returns (uint256) {
828         return 1;
829     }
830 
831     /**
832      * @dev See {IERC777-totalSupply}.
833      */
834     function totalSupply() public view returns (uint256) {
835         return _totalSupply;
836     }
837 
838     /**
839      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
840      */
841     function balanceOf(address tokenHolder) public view returns (uint256) {
842         return _balances[tokenHolder];
843     }
844 
845     /**
846      * @dev See {IERC777-send}.
847      *
848      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
849      */
850     function send(address recipient, uint256 amount, bytes memory data) public {
851         _send(_msgSender(), _msgSender(), recipient, amount, data, "", true);
852     }
853 
854     /**
855      * @dev See {IERC20-transfer}.
856      *
857      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
858      * interface if it is a contract.
859      *
860      * Also emits a {Sent} event.
861      */
862     function transfer(address recipient, uint256 amount) public returns (bool) {
863         require(recipient != address(0), "ERC777: transfer to the zero address");
864 
865         address from = _msgSender();
866 
867         _callTokensToSend(from, from, recipient, amount, "", "");
868 
869         _move(from, from, recipient, amount, "", "");
870 
871         _callTokensReceived(from, from, recipient, amount, "", "", false);
872 
873         return true;
874     }
875 
876     /**
877      * @dev See {IERC777-burn}.
878      *
879      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
880      */
881     function burn(uint256 amount, bytes memory data) public {
882         _burn(_msgSender(), _msgSender(), amount, data, "");
883     }
884 
885     /**
886      * @dev See {IERC777-isOperatorFor}.
887      */
888     function isOperatorFor(
889         address operator,
890         address tokenHolder
891     ) public view returns (bool) {
892         return operator == tokenHolder ||
893             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
894             _operators[tokenHolder][operator];
895     }
896 
897     /**
898      * @dev See {IERC777-authorizeOperator}.
899      */
900     function authorizeOperator(address operator) public {
901         require(_msgSender() != operator, "ERC777: authorizing self as operator");
902 
903         if (_defaultOperators[operator]) {
904             delete _revokedDefaultOperators[_msgSender()][operator];
905         } else {
906             _operators[_msgSender()][operator] = true;
907         }
908 
909         emit AuthorizedOperator(operator, _msgSender());
910     }
911 
912     /**
913      * @dev See {IERC777-revokeOperator}.
914      */
915     function revokeOperator(address operator) public {
916         require(operator != _msgSender(), "ERC777: revoking self as operator");
917 
918         if (_defaultOperators[operator]) {
919             _revokedDefaultOperators[_msgSender()][operator] = true;
920         } else {
921             delete _operators[_msgSender()][operator];
922         }
923 
924         emit RevokedOperator(operator, _msgSender());
925     }
926 
927     /**
928      * @dev See {IERC777-defaultOperators}.
929      */
930     function defaultOperators() public view returns (address[] memory) {
931         return _defaultOperatorsArray;
932     }
933 
934     /**
935      * @dev See {IERC777-operatorSend}.
936      *
937      * Emits {Sent} and {IERC20-Transfer} events.
938      */
939     function operatorSend(
940         address sender,
941         address recipient,
942         uint256 amount,
943         bytes memory data,
944         bytes memory operatorData
945     )
946     public
947     {
948         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
949         _send(_msgSender(), sender, recipient, amount, data, operatorData, true);
950     }
951 
952     /**
953      * @dev See {IERC777-operatorBurn}.
954      *
955      * Emits {Burned} and {IERC20-Transfer} events.
956      */
957     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public {
958         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
959         _burn(_msgSender(), account, amount, data, operatorData);
960     }
961 
962     /**
963      * @dev See {IERC20-allowance}.
964      *
965      * Note that operator and allowance concepts are orthogonal: operators may
966      * not have allowance, and accounts with allowance may not be operators
967      * themselves.
968      */
969     function allowance(address holder, address spender) public view returns (uint256) {
970         return _allowances[holder][spender];
971     }
972 
973     /**
974      * @dev See {IERC20-approve}.
975      *
976      * Note that accounts cannot have allowance issued by their operators.
977      */
978     function approve(address spender, uint256 value) public returns (bool) {
979         address holder = _msgSender();
980         _approve(holder, spender, value);
981         return true;
982     }
983 
984    /**
985     * @dev See {IERC20-transferFrom}.
986     *
987     * Note that operator and allowance concepts are orthogonal: operators cannot
988     * call `transferFrom` (unless they have allowance), and accounts with
989     * allowance cannot call `operatorSend` (unless they are operators).
990     *
991     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
992     */
993     function transferFrom(address holder, address recipient, uint256 amount) public returns (bool) {
994         require(recipient != address(0), "ERC777: transfer to the zero address");
995         require(holder != address(0), "ERC777: transfer from the zero address");
996 
997         address spender = _msgSender();
998 
999         _callTokensToSend(spender, holder, recipient, amount, "", "");
1000 
1001         _move(spender, holder, recipient, amount, "", "");
1002         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
1003 
1004         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
1005 
1006         return true;
1007     }
1008 
1009     /**
1010      * @dev Creates `amount` tokens and assigns them to `account`, increasing
1011      * the total supply.
1012      *
1013      * If a send hook is registered for `account`, the corresponding function
1014      * will be called with `operator`, `data` and `operatorData`.
1015      *
1016      * See {IERC777Sender} and {IERC777Recipient}.
1017      *
1018      * Emits {Minted} and {IERC20-Transfer} events.
1019      *
1020      * Requirements
1021      *
1022      * - `account` cannot be the zero address.
1023      * - if `account` is a contract, it must implement the {IERC777Recipient}
1024      * interface.
1025      */
1026     function _mint(
1027         address operator,
1028         address account,
1029         uint256 amount,
1030         bytes memory userData,
1031         bytes memory operatorData
1032     )
1033     internal
1034     {
1035         require(account != address(0), "ERC777: mint to the zero address");
1036 
1037         // Update state variables
1038         _totalSupply = _totalSupply.add(amount);
1039         _balances[account] = _balances[account].add(amount);
1040 
1041         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1042 
1043         emit Minted(operator, account, amount, userData, operatorData);
1044         emit Transfer(address(0), account, amount);
1045     }
1046 
1047     /**
1048      * @dev Send tokens
1049      * @param operator address operator requesting the transfer
1050      * @param from address token holder address
1051      * @param to address recipient address
1052      * @param amount uint256 amount of tokens to transfer
1053      * @param userData bytes extra information provided by the token holder (if any)
1054      * @param operatorData bytes extra information provided by the operator (if any)
1055      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1056      */
1057     function _send(
1058         address operator,
1059         address from,
1060         address to,
1061         uint256 amount,
1062         bytes memory userData,
1063         bytes memory operatorData,
1064         bool requireReceptionAck
1065     )
1066         internal
1067     {
1068         require(from != address(0), "ERC777: send from the zero address");
1069         require(to != address(0), "ERC777: send to the zero address");
1070 
1071         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1072 
1073         _move(operator, from, to, amount, userData, operatorData);
1074 
1075         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1076     }
1077 
1078     /**
1079      * @dev Burn tokens
1080      * @param operator address operator requesting the operation
1081      * @param from address token holder address
1082      * @param amount uint256 amount of tokens to burn
1083      * @param data bytes extra information provided by the token holder
1084      * @param operatorData bytes extra information provided by the operator (if any)
1085      */
1086     function _burn(
1087         address operator,
1088         address from,
1089         uint256 amount,
1090         bytes memory data,
1091         bytes memory operatorData
1092     )
1093         internal
1094     {
1095         require(from != address(0), "ERC777: burn from the zero address");
1096 
1097         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1098 
1099         // Update state variables
1100         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1101         _totalSupply = _totalSupply.sub(amount);
1102 
1103         emit Burned(operator, from, amount, data, operatorData);
1104         emit Transfer(from, address(0), amount);
1105     }
1106 
1107     function _move(
1108         address operator,
1109         address from,
1110         address to,
1111         uint256 amount,
1112         bytes memory userData,
1113         bytes memory operatorData
1114     )
1115         private
1116     {
1117         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1118         _balances[to] = _balances[to].add(amount);
1119 
1120         emit Sent(operator, from, to, amount, userData, operatorData);
1121         emit Transfer(from, to, amount);
1122     }
1123 
1124     function _approve(address holder, address spender, uint256 value) internal {
1125         // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
1126         // currently unnecessary.
1127         //require(holder != address(0), "ERC777: approve from the zero address");
1128         require(spender != address(0), "ERC777: approve to the zero address");
1129 
1130         _allowances[holder][spender] = value;
1131         emit Approval(holder, spender, value);
1132     }
1133 
1134     /**
1135      * @dev Call from.tokensToSend() if the interface is registered
1136      * @param operator address operator requesting the transfer
1137      * @param from address token holder address
1138      * @param to address recipient address
1139      * @param amount uint256 amount of tokens to transfer
1140      * @param userData bytes extra information provided by the token holder (if any)
1141      * @param operatorData bytes extra information provided by the operator (if any)
1142      */
1143     function _callTokensToSend(
1144         address operator,
1145         address from,
1146         address to,
1147         uint256 amount,
1148         bytes memory userData,
1149         bytes memory operatorData
1150     )
1151         internal
1152     {
1153         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1154         if (implementer != address(0)) {
1155             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1156         }
1157     }
1158 
1159     /**
1160      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1161      * tokensReceived() was not registered for the recipient
1162      * @param operator address operator requesting the transfer
1163      * @param from address token holder address
1164      * @param to address recipient address
1165      * @param amount uint256 amount of tokens to transfer
1166      * @param userData bytes extra information provided by the token holder (if any)
1167      * @param operatorData bytes extra information provided by the operator (if any)
1168      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1169      */
1170     function _callTokensReceived(
1171         address operator,
1172         address from,
1173         address to,
1174         uint256 amount,
1175         bytes memory userData,
1176         bytes memory operatorData,
1177         bool requireReceptionAck
1178     )
1179         internal
1180     {
1181         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1182         if (implementer != address(0)) {
1183             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1184         } else if (requireReceptionAck) {
1185             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1186         }
1187     }
1188 }
1189 
1190 // File: contracts/pToken.sol
1191 
1192 pragma solidity ^0.5.0;
1193 
1194 
1195 contract PToken is ERC777 {
1196 
1197     address public pNetwork;
1198 
1199     event Redeem(
1200         address indexed redeemer,
1201         uint256 value,
1202         string underlyingAssetRecipient
1203     );
1204 
1205     constructor(
1206         string memory tokenName,
1207         string memory tokenSymbol,
1208         address[] memory defaultOperators
1209     )
1210         ERC777(tokenName, tokenSymbol, defaultOperators)
1211         public
1212     {
1213         pNetwork = _msgSender();
1214     }
1215 
1216     function changePNetwork(
1217         address newPNetwork
1218     )
1219         external
1220     {
1221         require(
1222             _msgSender() == pNetwork,
1223             "Only the pNetwork can change the `pNetwork` account!"
1224         );
1225         require(
1226             _msgSender() != address(0),
1227             "pNetwork cannot be the zero address!"
1228         );
1229         pNetwork = newPNetwork;
1230     }
1231 
1232     function mint(
1233         address recipient,
1234         uint256 value
1235     )
1236         external
1237         returns (bool)
1238     {
1239         mint(recipient, value, "", "");
1240         return true;
1241     }
1242 
1243     function mint(
1244         address recipient,
1245         uint256 value,
1246         bytes memory userData,
1247         bytes memory operatorData
1248     )
1249         public
1250         returns (bool)
1251     {
1252         require(
1253             _msgSender() == pNetwork,
1254             "Only the pNetwork can mint tokens!"
1255         );
1256         require(
1257             recipient != address(0),
1258             "pToken: Cannot mint to the zero address!"
1259         );
1260         _mint(pNetwork, recipient, value, userData, operatorData);
1261         return true;
1262     }
1263 
1264     function redeem(
1265         uint256 amount,
1266         string calldata underlyingAssetRecipient
1267     )
1268         external
1269         returns (bool)
1270     {
1271         redeem(amount, "", underlyingAssetRecipient);
1272         return true;
1273     }
1274 
1275     function redeem(
1276         uint256 amount,
1277         bytes memory data,
1278         string memory underlyingAssetRecipient
1279     )
1280         public
1281     {
1282         _burn(_msgSender(), _msgSender(), amount, data, "");
1283         emit Redeem(msg.sender, amount, underlyingAssetRecipient);
1284     }
1285 
1286     function operatorRedeem(
1287         address account,
1288         uint256 amount,
1289         bytes calldata data,
1290         bytes calldata operatorData,
1291         string calldata underlyingAssetRecipient
1292     )
1293         external
1294     {
1295         require(
1296             isOperatorFor(_msgSender(), account),
1297             "ERC777: caller is not an operator for holder"
1298         );
1299         _burn(_msgSender(), account, amount, data, operatorData);
1300         emit Redeem(account, amount, underlyingAssetRecipient);
1301     }
1302 }