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
1068         require(operator != address(0), "ERC777: operator is the zero address");
1069         require(from != address(0), "ERC777: send from the zero address");
1070         require(to != address(0), "ERC777: send to the zero address");
1071 
1072         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1073 
1074         _move(operator, from, to, amount, userData, operatorData);
1075 
1076         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1077     }
1078 
1079     /**
1080      * @dev Burn tokens
1081      * @param operator address operator requesting the operation
1082      * @param from address token holder address
1083      * @param amount uint256 amount of tokens to burn
1084      * @param data bytes extra information provided by the token holder
1085      * @param operatorData bytes extra information provided by the operator (if any)
1086      */
1087     function _burn(
1088         address operator,
1089         address from,
1090         uint256 amount,
1091         bytes memory data,
1092         bytes memory operatorData
1093     )
1094         internal
1095     {
1096         require(from != address(0), "ERC777: burn from the zero address");
1097 
1098         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1099 
1100         // Update state variables
1101         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1102         _totalSupply = _totalSupply.sub(amount);
1103 
1104         emit Burned(operator, from, amount, data, operatorData);
1105         emit Transfer(from, address(0), amount);
1106     }
1107 
1108     function _move(
1109         address operator,
1110         address from,
1111         address to,
1112         uint256 amount,
1113         bytes memory userData,
1114         bytes memory operatorData
1115     )
1116         private
1117     {
1118         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1119         _balances[to] = _balances[to].add(amount);
1120 
1121         emit Sent(operator, from, to, amount, userData, operatorData);
1122         emit Transfer(from, to, amount);
1123     }
1124 
1125     /**
1126      * @dev See {ERC20-_approve}.
1127      *
1128      * Note that accounts cannot have allowance issued by their operators.
1129      */
1130     function _approve(address holder, address spender, uint256 value) internal {
1131         require(holder != address(0), "ERC777: approve from the zero address");
1132         require(spender != address(0), "ERC777: approve to the zero address");
1133 
1134         _allowances[holder][spender] = value;
1135         emit Approval(holder, spender, value);
1136     }
1137 
1138     /**
1139      * @dev Call from.tokensToSend() if the interface is registered
1140      * @param operator address operator requesting the transfer
1141      * @param from address token holder address
1142      * @param to address recipient address
1143      * @param amount uint256 amount of tokens to transfer
1144      * @param userData bytes extra information provided by the token holder (if any)
1145      * @param operatorData bytes extra information provided by the operator (if any)
1146      */
1147     function _callTokensToSend(
1148         address operator,
1149         address from,
1150         address to,
1151         uint256 amount,
1152         bytes memory userData,
1153         bytes memory operatorData
1154     )
1155         internal
1156     {
1157         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1158         if (implementer != address(0)) {
1159             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1160         }
1161     }
1162 
1163     /**
1164      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1165      * tokensReceived() was not registered for the recipient
1166      * @param operator address operator requesting the transfer
1167      * @param from address token holder address
1168      * @param to address recipient address
1169      * @param amount uint256 amount of tokens to transfer
1170      * @param userData bytes extra information provided by the token holder (if any)
1171      * @param operatorData bytes extra information provided by the operator (if any)
1172      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1173      */
1174     function _callTokensReceived(
1175         address operator,
1176         address from,
1177         address to,
1178         uint256 amount,
1179         bytes memory userData,
1180         bytes memory operatorData,
1181         bool requireReceptionAck
1182     )
1183         internal
1184     {
1185         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1186         if (implementer != address(0)) {
1187             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1188         } else if (requireReceptionAck) {
1189             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1190         }
1191     }
1192 }
1193 
1194 // File: contracts/AbstractOwnable.sol
1195 
1196 pragma solidity ^0.5.0;
1197 
1198 contract AbstractOwnable {
1199   /**
1200    * @dev Returns the address of the current owner.
1201    */
1202   function owner() internal view returns (address);
1203 
1204   /**
1205    * @dev Throws if called by any account other than the owner.
1206    */
1207   modifier onlyOwner() {
1208     require(isOwner(), "Caller is not the owner");
1209     _;
1210   }
1211 
1212   /**
1213    * @dev Returns true if the caller is the current owner.
1214    */
1215   function isOwner() internal view returns (bool) {
1216     return msg.sender == owner();
1217   }
1218 
1219 }
1220 
1221 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
1222 
1223 pragma solidity ^0.5.0;
1224 
1225 /**
1226  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1227  *
1228  * These functions can be used to verify that a message was signed by the holder
1229  * of the private keys of a given address.
1230  */
1231 library ECDSA {
1232     /**
1233      * @dev Returns the address that signed a hashed message (`hash`) with
1234      * `signature`. This address can then be used for verification purposes.
1235      *
1236      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1237      * this function rejects them by requiring the `s` value to be in the lower
1238      * half order, and the `v` value to be either 27 or 28.
1239      *
1240      * NOTE: This call _does not revert_ if the signature is invalid, or
1241      * if the signer is otherwise unable to be retrieved. In those scenarios,
1242      * the zero address is returned.
1243      *
1244      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1245      * verification to be secure: it is possible to craft signatures that
1246      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1247      * this is by receiving a hash of the original message (which may otherwise
1248      * be too long), and then calling {toEthSignedMessageHash} on it.
1249      */
1250     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1251         // Check the signature length
1252         if (signature.length != 65) {
1253             return (address(0));
1254         }
1255 
1256         // Divide the signature in r, s and v variables
1257         bytes32 r;
1258         bytes32 s;
1259         uint8 v;
1260 
1261         // ecrecover takes the signature parameters, and the only way to get them
1262         // currently is to use assembly.
1263         // solhint-disable-next-line no-inline-assembly
1264         assembly {
1265             r := mload(add(signature, 0x20))
1266             s := mload(add(signature, 0x40))
1267             v := byte(0, mload(add(signature, 0x60)))
1268         }
1269 
1270         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1271         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1272         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1273         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1274         //
1275         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1276         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1277         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1278         // these malleable signatures as well.
1279         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1280             return address(0);
1281         }
1282 
1283         if (v != 27 && v != 28) {
1284             return address(0);
1285         }
1286 
1287         // If the signature is valid (and not malleable), return the signer address
1288         return ecrecover(hash, v, r, s);
1289     }
1290 
1291     /**
1292      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1293      * replicates the behavior of the
1294      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
1295      * JSON-RPC method.
1296      *
1297      * See {recover}.
1298      */
1299     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1300         // 32 is the length in bytes of hash,
1301         // enforced by the type signature above
1302         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1303     }
1304 }
1305 
1306 // File: @openzeppelin/contracts/GSN/IRelayRecipient.sol
1307 
1308 pragma solidity ^0.5.0;
1309 
1310 /**
1311  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
1312  *
1313  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
1314  */
1315 interface IRelayRecipient {
1316     /**
1317      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
1318      */
1319     function getHubAddr() external view returns (address);
1320 
1321     /**
1322      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
1323      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
1324      *
1325      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
1326      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
1327      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
1328      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
1329      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
1330      * over all or some of the previous values.
1331      *
1332      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
1333      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
1334      *
1335      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
1336      * rejected. A regular revert will also trigger a rejection.
1337      */
1338     function acceptRelayedCall(
1339         address relay,
1340         address from,
1341         bytes calldata encodedFunction,
1342         uint256 transactionFee,
1343         uint256 gasPrice,
1344         uint256 gasLimit,
1345         uint256 nonce,
1346         bytes calldata approvalData,
1347         uint256 maxPossibleCharge
1348     )
1349         external
1350         view
1351         returns (uint256, bytes memory);
1352 
1353     /**
1354      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
1355      * pre-charge the sender of the transaction.
1356      *
1357      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
1358      *
1359      * Returns a value to be passed to {postRelayedCall}.
1360      *
1361      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
1362      * will not be executed, but the recipient will still be charged for the transaction's cost.
1363      */
1364     function preRelayedCall(bytes calldata context) external returns (bytes32);
1365 
1366     /**
1367      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
1368      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
1369      * contract-specific bookkeeping.
1370      *
1371      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
1372      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
1373      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
1374      *
1375      *
1376      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
1377      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
1378      * transaction's cost.
1379      */
1380     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
1381 }
1382 
1383 // File: @openzeppelin/contracts/GSN/IRelayHub.sol
1384 
1385 pragma solidity ^0.5.0;
1386 
1387 /**
1388  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
1389  * directly.
1390  *
1391  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
1392  * how to deploy an instance of `RelayHub` on your local test network.
1393  */
1394 interface IRelayHub {
1395     // Relay management
1396 
1397     /**
1398      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
1399      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
1400      * cannot be its own owner.
1401      *
1402      * All Ether in this function call will be added to the relay's stake.
1403      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
1404      *
1405      * Emits a {Staked} event.
1406      */
1407     function stake(address relayaddr, uint256 unstakeDelay) external payable;
1408 
1409     /**
1410      * @dev Emitted when a relay's stake or unstakeDelay are increased
1411      */
1412     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
1413 
1414     /**
1415      * @dev Registers the caller as a relay.
1416      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
1417      *
1418      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
1419      * `transactionFee` is not enforced by {relayCall}.
1420      *
1421      * Emits a {RelayAdded} event.
1422      */
1423     function registerRelay(uint256 transactionFee, string calldata url) external;
1424 
1425     /**
1426      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
1427      * {RelayRemoved} events) lets a client discover the list of available relays.
1428      */
1429     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
1430 
1431     /**
1432      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
1433      *
1434      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
1435      * callable.
1436      *
1437      * Emits a {RelayRemoved} event.
1438      */
1439     function removeRelayByOwner(address relay) external;
1440 
1441     /**
1442      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
1443      */
1444     event RelayRemoved(address indexed relay, uint256 unstakeTime);
1445 
1446     /** Deletes the relay from the system, and gives back its stake to the owner.
1447      *
1448      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
1449      *
1450      * Emits an {Unstaked} event.
1451      */
1452     function unstake(address relay) external;
1453 
1454     /**
1455      * @dev Emitted when a relay is unstaked for, including the returned stake.
1456      */
1457     event Unstaked(address indexed relay, uint256 stake);
1458 
1459     // States a relay can be in
1460     enum RelayState {
1461         Unknown, // The relay is unknown to the system: it has never been staked for
1462         Staked, // The relay has been staked for, but it is not yet active
1463         Registered, // The relay has registered itself, and is active (can relay calls)
1464         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
1465     }
1466 
1467     /**
1468      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
1469      * to return an empty entry.
1470      */
1471     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
1472 
1473     // Balance management
1474 
1475     /**
1476      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
1477      *
1478      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
1479      *
1480      * Emits a {Deposited} event.
1481      */
1482     function depositFor(address target) external payable;
1483 
1484     /**
1485      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
1486      */
1487     event Deposited(address indexed recipient, address indexed from, uint256 amount);
1488 
1489     /**
1490      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
1491      */
1492     function balanceOf(address target) external view returns (uint256);
1493 
1494     /**
1495      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
1496      * contracts can use it to reduce their funding.
1497      *
1498      * Emits a {Withdrawn} event.
1499      */
1500     function withdraw(uint256 amount, address payable dest) external;
1501 
1502     /**
1503      * @dev Emitted when an account withdraws funds from `RelayHub`.
1504      */
1505     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
1506 
1507     // Relaying
1508 
1509     /**
1510      * @dev Checks if the `RelayHub` will accept a relayed operation.
1511      * Multiple things must be true for this to happen:
1512      *  - all arguments must be signed for by the sender (`from`)
1513      *  - the sender's nonce must be the current one
1514      *  - the recipient must accept this transaction (via {acceptRelayedCall})
1515      *
1516      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
1517      * code if it returns one in {acceptRelayedCall}.
1518      */
1519     function canRelay(
1520         address relay,
1521         address from,
1522         address to,
1523         bytes calldata encodedFunction,
1524         uint256 transactionFee,
1525         uint256 gasPrice,
1526         uint256 gasLimit,
1527         uint256 nonce,
1528         bytes calldata signature,
1529         bytes calldata approvalData
1530     ) external view returns (uint256 status, bytes memory recipientContext);
1531 
1532     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
1533     enum PreconditionCheck {
1534         OK,                         // All checks passed, the call can be relayed
1535         WrongSignature,             // The transaction to relay is not signed by requested sender
1536         WrongNonce,                 // The provided nonce has already been used by the sender
1537         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
1538         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
1539     }
1540 
1541     /**
1542      * @dev Relays a transaction.
1543      *
1544      * For this to succeed, multiple conditions must be met:
1545      *  - {canRelay} must `return PreconditionCheck.OK`
1546      *  - the sender must be a registered relay
1547      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
1548      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
1549      * recipient) use all gas available to them
1550      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
1551      * spent)
1552      *
1553      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
1554      * function and {postRelayedCall} will be called in that order.
1555      *
1556      * Parameters:
1557      *  - `from`: the client originating the request
1558      *  - `to`: the target {IRelayRecipient} contract
1559      *  - `encodedFunction`: the function call to relay, including data
1560      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
1561      *  - `gasPrice`: gas price the client is willing to pay
1562      *  - `gasLimit`: gas to forward when calling the encoded function
1563      *  - `nonce`: client's nonce
1564      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
1565      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
1566      * `RelayHub`, but it still can be used for e.g. a signature.
1567      *
1568      * Emits a {TransactionRelayed} event.
1569      */
1570     function relayCall(
1571         address from,
1572         address to,
1573         bytes calldata encodedFunction,
1574         uint256 transactionFee,
1575         uint256 gasPrice,
1576         uint256 gasLimit,
1577         uint256 nonce,
1578         bytes calldata signature,
1579         bytes calldata approvalData
1580     ) external;
1581 
1582     /**
1583      * @dev Emitted when an attempt to relay a call failed.
1584      *
1585      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
1586      * actual relayed call was not executed, and the recipient not charged.
1587      *
1588      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
1589      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
1590      */
1591     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
1592 
1593     /**
1594      * @dev Emitted when a transaction is relayed. 
1595      * Useful when monitoring a relay's operation and relayed calls to a contract
1596      *
1597      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
1598      *
1599      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
1600      */
1601     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
1602 
1603     // Reason error codes for the TransactionRelayed event
1604     enum RelayCallStatus {
1605         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
1606         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
1607         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
1608         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
1609         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
1610     }
1611 
1612     /**
1613      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
1614      * spend up to `relayedCallStipend` gas.
1615      */
1616     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
1617 
1618     /**
1619      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
1620      */
1621     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
1622 
1623      // Relay penalization. 
1624      // Any account can penalize relays, removing them from the system immediately, and rewarding the
1625     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
1626     // still loses half of its stake.
1627 
1628     /**
1629      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
1630      * different data (gas price, gas limit, etc. may be different).
1631      *
1632      * The (unsigned) transaction data and signature for both transactions must be provided.
1633      */
1634     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
1635 
1636     /**
1637      * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
1638      */
1639     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
1640 
1641     /**
1642      * @dev Emitted when a relay is penalized.
1643      */
1644     event Penalized(address indexed relay, address sender, uint256 amount);
1645 
1646     /**
1647      * @dev Returns an account's nonce in `RelayHub`.
1648      */
1649     function getNonce(address from) external view returns (uint256);
1650 }
1651 
1652 // File: @openzeppelin/contracts/GSN/GSNRecipient.sol
1653 
1654 pragma solidity ^0.5.0;
1655 
1656 
1657 
1658 
1659 /**
1660  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
1661  * and enables GSN support on all contracts in the inheritance tree.
1662  *
1663  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
1664  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
1665  * provided by derived contracts. See the
1666  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
1667  * information on how to use the pre-built {GSNRecipientSignature} and
1668  * {GSNRecipientERC20Fee}, or how to write your own.
1669  */
1670 contract GSNRecipient is IRelayRecipient, Context {
1671     // Default RelayHub address, deployed on mainnet and all testnets at the same address
1672     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
1673 
1674     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
1675     uint256 constant private RELAYED_CALL_REJECTED = 11;
1676 
1677     // How much gas is forwarded to postRelayedCall
1678     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
1679 
1680     /**
1681      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
1682      */
1683     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
1684 
1685     /**
1686      * @dev Returns the address of the {IRelayHub} contract for this recipient.
1687      */
1688     function getHubAddr() public view returns (address) {
1689         return _relayHub;
1690     }
1691 
1692     /**
1693      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
1694      * use the default instance.
1695      *
1696      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
1697      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
1698      */
1699     function _upgradeRelayHub(address newRelayHub) internal {
1700         address currentRelayHub = _relayHub;
1701         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
1702         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
1703 
1704         emit RelayHubChanged(currentRelayHub, newRelayHub);
1705 
1706         _relayHub = newRelayHub;
1707     }
1708 
1709     /**
1710      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
1711      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
1712      */
1713     // This function is view for future-proofing, it may require reading from
1714     // storage in the future.
1715     function relayHubVersion() public view returns (string memory) {
1716         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1717         return "1.0.0";
1718     }
1719 
1720     /**
1721      * @dev Withdraws the recipient's deposits in `RelayHub`.
1722      *
1723      * Derived contracts should expose this in an external interface with proper access control.
1724      */
1725     function _withdrawDeposits(uint256 amount, address payable payee) internal {
1726         IRelayHub(_relayHub).withdraw(amount, payee);
1727     }
1728 
1729     // Overrides for Context's functions: when called from RelayHub, sender and
1730     // data require some pre-processing: the actual sender is stored at the end
1731     // of the call data, which in turns means it needs to be removed from it
1732     // when handling said data.
1733 
1734     /**
1735      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
1736      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
1737      *
1738      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
1739      */
1740     function _msgSender() internal view returns (address payable) {
1741         if (msg.sender != _relayHub) {
1742             return msg.sender;
1743         } else {
1744             return _getRelayedCallSender();
1745         }
1746     }
1747 
1748     /**
1749      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1750      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
1751      *
1752      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1753      */
1754     function _msgData() internal view returns (bytes memory) {
1755         if (msg.sender != _relayHub) {
1756             return msg.data;
1757         } else {
1758             return _getRelayedCallData();
1759         }
1760     }
1761 
1762     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
1763     // internal hook.
1764 
1765     /**
1766      * @dev See `IRelayRecipient.preRelayedCall`.
1767      *
1768      * This function should not be overriden directly, use `_preRelayedCall` instead.
1769      *
1770      * * Requirements:
1771      *
1772      * - the caller must be the `RelayHub` contract.
1773      */
1774     function preRelayedCall(bytes calldata context) external returns (bytes32) {
1775         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1776         return _preRelayedCall(context);
1777     }
1778 
1779     /**
1780      * @dev See `IRelayRecipient.preRelayedCall`.
1781      *
1782      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1783      * must implement this function with any relayed-call preprocessing they may wish to do.
1784      *
1785      */
1786     function _preRelayedCall(bytes memory context) internal returns (bytes32);
1787 
1788     /**
1789      * @dev See `IRelayRecipient.postRelayedCall`.
1790      *
1791      * This function should not be overriden directly, use `_postRelayedCall` instead.
1792      *
1793      * * Requirements:
1794      *
1795      * - the caller must be the `RelayHub` contract.
1796      */
1797     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
1798         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1799         _postRelayedCall(context, success, actualCharge, preRetVal);
1800     }
1801 
1802     /**
1803      * @dev See `IRelayRecipient.postRelayedCall`.
1804      *
1805      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1806      * must implement this function with any relayed-call postprocessing they may wish to do.
1807      *
1808      */
1809     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
1810 
1811     /**
1812      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
1813      * will be charged a fee by RelayHub
1814      */
1815     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
1816         return _approveRelayedCall("");
1817     }
1818 
1819     /**
1820      * @dev See `GSNRecipient._approveRelayedCall`.
1821      *
1822      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
1823      */
1824     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
1825         return (RELAYED_CALL_ACCEPTED, context);
1826     }
1827 
1828     /**
1829      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
1830      */
1831     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
1832         return (RELAYED_CALL_REJECTED + errorCode, "");
1833     }
1834 
1835     /*
1836      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
1837      * `serviceFee`.
1838      */
1839     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
1840         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
1841         // charged for 1.4 times the spent amount.
1842         return (gas * gasPrice * (100 + serviceFee)) / 100;
1843     }
1844 
1845     function _getRelayedCallSender() private pure returns (address payable result) {
1846         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
1847         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
1848         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
1849         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
1850         // bytes. This can always be done due to the 32-byte prefix.
1851 
1852         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
1853         // easiest/most-efficient way to perform this operation.
1854 
1855         // These fields are not accessible from assembly
1856         bytes memory array = msg.data;
1857         uint256 index = msg.data.length;
1858 
1859         // solhint-disable-next-line no-inline-assembly
1860         assembly {
1861             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1862             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1863         }
1864         return result;
1865     }
1866 
1867     function _getRelayedCallData() private pure returns (bytes memory) {
1868         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
1869         // we must strip the last 20 bytes (length of an address type) from it.
1870 
1871         uint256 actualDataLength = msg.data.length - 20;
1872         bytes memory actualData = new bytes(actualDataLength);
1873 
1874         for (uint256 i = 0; i < actualDataLength; ++i) {
1875             actualData[i] = msg.data[i];
1876         }
1877 
1878         return actualData;
1879     }
1880 }
1881 
1882 // File: contracts/ERC777GSN.sol
1883 
1884 pragma solidity ^0.5.0;
1885 
1886 
1887 
1888 
1889 
1890 contract ERC777GSN is AbstractOwnable, GSNRecipient, ERC777 {
1891   using ECDSA for bytes32;
1892   uint256 constant GSN_RATE_UNIT = 10**18;
1893 
1894   enum GSNErrorCodes {
1895     INVALID_SIGNER,
1896     INSUFFICIENT_BALANCE
1897   }
1898 
1899   address public gsnTrustedSigner;
1900   address public gsnFeeTarget;
1901   uint256 public gsnExtraGas = 40000; // the gas cost of _postRelayedCall()
1902 
1903   constructor(
1904     address _gsnTrustedSigner,
1905     address _gsnFeeTarget
1906   )
1907     public
1908   {
1909     require(_gsnTrustedSigner != address(0), "trusted signer is the zero address");
1910     gsnTrustedSigner = _gsnTrustedSigner;
1911     require(_gsnFeeTarget != address(0), "fee target is the zero address");
1912     gsnFeeTarget = _gsnFeeTarget;
1913   }
1914 
1915   function _msgSender() internal view returns (address payable) {
1916     return GSNRecipient._msgSender();
1917   }
1918 
1919   function _msgData() internal view returns (bytes memory) {
1920     return GSNRecipient._msgData();
1921   }
1922 
1923 
1924   function setTrustedSigner(address _gsnTrustedSigner) public onlyOwner {
1925     require(_gsnTrustedSigner != address(0), "trusted signer is the zero address");
1926     gsnTrustedSigner = _gsnTrustedSigner;
1927   }
1928 
1929   function setFeeTarget(address _gsnFeeTarget) public onlyOwner {
1930     require(_gsnFeeTarget != address(0), "fee target is the zero address");
1931     gsnFeeTarget = _gsnFeeTarget;
1932   }
1933 
1934   function setGSNExtraGas(uint _gsnExtraGas) public onlyOwner {
1935     gsnExtraGas = _gsnExtraGas;
1936   }
1937 
1938 
1939   /**
1940  * @dev Ensures that only transactions with a trusted signature can be relayed through the GSN.
1941  */
1942   function acceptRelayedCall(
1943     address relay,
1944     address from,
1945     bytes memory encodedFunction,
1946     uint256 transactionFee,
1947     uint256 gasPrice,
1948     uint256 gasLimit,
1949     uint256 nonce,
1950     bytes memory approvalData,
1951     uint256 /* maxPossibleCharge */
1952   )
1953     public
1954     view
1955     returns (uint256, bytes memory)
1956   {
1957     (uint256 feeRate, bytes memory signature) = abi.decode(approvalData, (uint, bytes));
1958     bytes memory blob = abi.encodePacked(
1959       feeRate,
1960       relay,
1961       from,
1962       encodedFunction,
1963       transactionFee,
1964       gasPrice,
1965       gasLimit,
1966       nonce, // Prevents replays on RelayHub
1967       getHubAddr(), // Prevents replays in multiple RelayHubs
1968       address(this) // Prevents replays in multiple recipients
1969     );
1970     if (keccak256(blob).toEthSignedMessageHash().recover(signature) == gsnTrustedSigner) {
1971       return _approveRelayedCall(abi.encode(feeRate, from, transactionFee, gasPrice));
1972     } else {
1973       return _rejectRelayedCall(uint256(GSNErrorCodes.INVALID_SIGNER));
1974     }
1975   }
1976 
1977   function _preRelayedCall(bytes memory context) internal returns (bytes32) {}
1978 
1979   function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
1980     (uint256 feeRate, address from, uint256 transactionFee, uint256 gasPrice) =
1981       abi.decode(context, (uint256, address, uint256, uint256));
1982 
1983     // actualCharge is an _estimated_ charge, which assumes postRelayedCall will use all available gas.
1984     // This implementation's gas cost can be roughly estimated as 10k gas, for the two SSTORE operations in an
1985     // ERC20 transfer.
1986     uint256 overestimation = _computeCharge(POST_RELAYED_CALL_MAX_GAS.sub(gsnExtraGas), gasPrice, transactionFee);
1987     uint fee = actualCharge.sub(overestimation).mul(feeRate).div(GSN_RATE_UNIT);
1988 
1989     if (fee > 0) {
1990       _send(_msgSender(), from, gsnFeeTarget, fee, "", "", false);
1991     }
1992   }
1993 }
1994 
1995 // File: contracts/ERC777WithAdminOperator.sol
1996 
1997 pragma solidity ^0.5.0;
1998 
1999 
2000 contract ERC777WithAdminOperator is ERC777 {
2001 
2002   address public adminOperator;
2003 
2004   event AdminOperatorChange(address oldOperator, address newOperator);
2005   event AdminTransferInvoked(address operator);
2006 
2007   constructor(address _adminOperator) public {
2008     adminOperator = _adminOperator;
2009   }
2010 
2011   /**
2012  * @dev Similar to {IERC777-operatorSend}.
2013  *
2014  * Emits {Sent} and {IERC20-Transfer} events.
2015  */
2016   function adminTransfer(
2017     address sender,
2018     address recipient,
2019     uint256 amount,
2020     bytes memory data,
2021     bytes memory operatorData
2022   )
2023   public
2024   {
2025     require(_msgSender() == adminOperator, "caller is not the admin operator");
2026     _send(adminOperator, sender, recipient, amount, data, operatorData, false);
2027     emit AdminTransferInvoked(adminOperator);
2028   }
2029 
2030   /**
2031    * @dev Only the actual admin operator can change the address
2032    */
2033   function setAdminOperator(address adminOperator_) public {
2034     require(msg.sender == adminOperator, "Only the actual admin operator can change the address");
2035     emit AdminOperatorChange(adminOperator, adminOperator_);
2036     adminOperator = adminOperator_;
2037   }
2038 
2039 
2040 }
2041 
2042 // File: contracts/ERC777OptionalAckOnMint.sol
2043 
2044 pragma solidity ^0.5.0;
2045 
2046 
2047 contract ERC777OptionalAckOnMint is ERC777 {
2048   bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
2049     0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
2050 
2051   /**
2052  * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
2053  * tokensReceived() was not registered for the recipient
2054  * @param operator address operator requesting the transfer
2055  * @param from address token holder address
2056  * @param to address recipient address
2057  * @param amount uint256 amount of tokens to transfer
2058  * @param userData bytes extra information provided by the token holder (if any)
2059  * @param operatorData bytes extra information provided by the operator (if any)
2060  * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
2061  */
2062   function _callTokensReceived(
2063     address operator,
2064     address from,
2065     address to,
2066     uint256 amount,
2067     bytes memory userData,
2068     bytes memory operatorData,
2069     bool requireReceptionAck
2070   )
2071     internal
2072   {
2073     address implementer = ERC1820_REGISTRY.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
2074     if (implementer != address(0)) {
2075       IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
2076     } else if (requireReceptionAck && from != address(0)) {
2077       require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
2078     }
2079   }
2080 }
2081 
2082 // File: contracts/pToken.sol
2083 
2084 pragma solidity ^0.5.0;
2085 
2086 
2087 
2088 
2089 
2090 
2091 contract PToken is
2092     AbstractOwnable,
2093     ERC777,
2094     ERC777OptionalAckOnMint,
2095     ERC777GSN,
2096     ERC777WithAdminOperator
2097 {
2098 
2099     address public pNetwork;
2100 
2101     event Redeem(
2102         address indexed redeemer,
2103         uint256 value,
2104         string underlyingAssetRecipient
2105     );
2106 
2107     constructor(
2108         string memory tokenName,
2109         string memory tokenSymbol,
2110         address[] memory defaultOperators
2111     )
2112         ERC777(tokenName, tokenSymbol, defaultOperators)
2113         ERC777GSN(msg.sender, msg.sender)
2114         ERC777WithAdminOperator(msg.sender)
2115         public
2116     {
2117         pNetwork = _msgSender();
2118     }
2119 
2120     function owner() internal view returns (address) {
2121         return pNetwork;
2122     }
2123 
2124     function changePNetwork(
2125         address newPNetwork
2126     )
2127         external
2128     {
2129         require(
2130             _msgSender() == pNetwork,
2131             "Only the pNetwork can change the `pNetwork` account!"
2132         );
2133         require(
2134             newPNetwork != address(0),
2135             "pNetwork cannot be the zero address!"
2136         );
2137         pNetwork = newPNetwork;
2138     }
2139 
2140     function mint(
2141         address recipient,
2142         uint256 value
2143     )
2144         external
2145         returns (bool)
2146     {
2147         mint(recipient, value, "", "");
2148         return true;
2149     }
2150 
2151     function mint(
2152         address recipient,
2153         uint256 value,
2154         bytes memory userData,
2155         bytes memory operatorData
2156     )
2157         public
2158         returns (bool)
2159     {
2160         require(
2161             _msgSender() == pNetwork,
2162             "Only the pNetwork can mint tokens!"
2163         );
2164         require(
2165             recipient != address(0),
2166             "pToken: Cannot mint to the zero address!"
2167         );
2168         _mint(pNetwork, recipient, value, userData, operatorData);
2169         return true;
2170     }
2171 
2172     function redeem(
2173         uint256 amount,
2174         string calldata underlyingAssetRecipient
2175     )
2176         external
2177         returns (bool)
2178     {
2179         redeem(amount, "", underlyingAssetRecipient);
2180         return true;
2181     }
2182 
2183     function redeem(
2184         uint256 amount,
2185         bytes memory data,
2186         string memory underlyingAssetRecipient
2187     )
2188         public
2189     {
2190         _burn(_msgSender(), _msgSender(), amount, data, "");
2191         emit Redeem(msg.sender, amount, underlyingAssetRecipient);
2192     }
2193 
2194     function operatorRedeem(
2195         address account,
2196         uint256 amount,
2197         bytes calldata data,
2198         bytes calldata operatorData,
2199         string calldata underlyingAssetRecipient
2200     )
2201         external
2202     {
2203         require(
2204             isOperatorFor(_msgSender(), account),
2205             "ERC777: caller is not an operator for holder"
2206         );
2207         _burn(_msgSender(), account, amount, data, operatorData);
2208         emit Redeem(account, amount, underlyingAssetRecipient);
2209     }
2210 }