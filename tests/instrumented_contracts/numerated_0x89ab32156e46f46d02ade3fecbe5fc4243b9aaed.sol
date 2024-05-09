1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.6.0;
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
19 
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC777/IERC777.sol
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Interface of the ERC777Token standard as defined in the EIP.
36  *
37  * This contract uses the
38  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
39  * token holders and recipients react to token movements by using setting implementers
40  * for the associated interfaces in said registry. See {IERC1820Registry} and
41  * {ERC1820Implementer}.
42  */
43 interface IERC777 {
44     /**
45      * @dev Returns the name of the token.
46      */
47     function name() external view returns (string memory);
48 
49     /**
50      * @dev Returns the symbol of the token, usually a shorter version of the
51      * name.
52      */
53     function symbol() external view returns (string memory);
54 
55     /**
56      * @dev Returns the smallest part of the token that is not divisible. This
57      * means all token operations (creation, movement and destruction) must have
58      * amounts that are a multiple of this number.
59      *
60      * For most token contracts, this value will equal 1.
61      */
62     function granularity() external view returns (uint256);
63 
64     /**
65      * @dev Returns the amount of tokens in existence.
66      */
67     function totalSupply() external view returns (uint256);
68 
69     /**
70      * @dev Returns the amount of tokens owned by an account (`owner`).
71      */
72     function balanceOf(address owner) external view returns (uint256);
73 
74     /**
75      * @dev Moves `amount` tokens from the caller's account to `recipient`.
76      *
77      * If send or receive hooks are registered for the caller and `recipient`,
78      * the corresponding functions will be called with `data` and empty
79      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
80      *
81      * Emits a {Sent} event.
82      *
83      * Requirements
84      *
85      * - the caller must have at least `amount` tokens.
86      * - `recipient` cannot be the zero address.
87      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
88      * interface.
89      */
90     function send(address recipient, uint256 amount, bytes calldata data) external;
91 
92     /**
93      * @dev Destroys `amount` tokens from the caller's account, reducing the
94      * total supply.
95      *
96      * If a send hook is registered for the caller, the corresponding function
97      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
98      *
99      * Emits a {Burned} event.
100      *
101      * Requirements
102      *
103      * - the caller must have at least `amount` tokens.
104      */
105     function burn(uint256 amount, bytes calldata data) external;
106 
107     /**
108      * @dev Returns true if an account is an operator of `tokenHolder`.
109      * Operators can send and burn tokens on behalf of their owners. All
110      * accounts are their own operator.
111      *
112      * See {operatorSend} and {operatorBurn}.
113      */
114     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
115 
116     /**
117      * @dev Make an account an operator of the caller.
118      *
119      * See {isOperatorFor}.
120      *
121      * Emits an {AuthorizedOperator} event.
122      *
123      * Requirements
124      *
125      * - `operator` cannot be calling address.
126      */
127     function authorizeOperator(address operator) external;
128 
129     /**
130      * @dev Revoke an account's operator status for the caller.
131      *
132      * See {isOperatorFor} and {defaultOperators}.
133      *
134      * Emits a {RevokedOperator} event.
135      *
136      * Requirements
137      *
138      * - `operator` cannot be calling address.
139      */
140     function revokeOperator(address operator) external;
141 
142     /**
143      * @dev Returns the list of default operators. These accounts are operators
144      * for all token holders, even if {authorizeOperator} was never called on
145      * them.
146      *
147      * This list is immutable, but individual holders may revoke these via
148      * {revokeOperator}, in which case {isOperatorFor} will return false.
149      */
150     function defaultOperators() external view returns (address[] memory);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
154      * be an operator of `sender`.
155      *
156      * If send or receive hooks are registered for `sender` and `recipient`,
157      * the corresponding functions will be called with `data` and
158      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
159      *
160      * Emits a {Sent} event.
161      *
162      * Requirements
163      *
164      * - `sender` cannot be the zero address.
165      * - `sender` must have at least `amount` tokens.
166      * - the caller must be an operator for `sender`.
167      * - `recipient` cannot be the zero address.
168      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
169      * interface.
170      */
171     function operatorSend(
172         address sender,
173         address recipient,
174         uint256 amount,
175         bytes calldata data,
176         bytes calldata operatorData
177     ) external;
178 
179     /**
180      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
181      * The caller must be an operator of `account`.
182      *
183      * If a send hook is registered for `account`, the corresponding function
184      * will be called with `data` and `operatorData`. See {IERC777Sender}.
185      *
186      * Emits a {Burned} event.
187      *
188      * Requirements
189      *
190      * - `account` cannot be the zero address.
191      * - `account` must have at least `amount` tokens.
192      * - the caller must be an operator for `account`.
193      */
194     function operatorBurn(
195         address account,
196         uint256 amount,
197         bytes calldata data,
198         bytes calldata operatorData
199     ) external;
200 
201     event Sent(
202         address indexed operator,
203         address indexed from,
204         address indexed to,
205         uint256 amount,
206         bytes data,
207         bytes operatorData
208     );
209 
210     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
211 
212     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
213 
214     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
215 
216     event RevokedOperator(address indexed operator, address indexed tokenHolder);
217 }
218 
219 // File: @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol
220 
221 pragma solidity ^0.6.0;
222 
223 /**
224  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
225  *
226  * Accounts can be notified of {IERC777} tokens being sent to them by having a
227  * contract implement this interface (contract holders can be their own
228  * implementer) and registering it on the
229  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
230  *
231  * See {IERC1820Registry} and {ERC1820Implementer}.
232  */
233 interface IERC777Recipient {
234     /**
235      * @dev Called by an {IERC777} token contract whenever tokens are being
236      * moved or created into a registered account (`to`). The type of operation
237      * is conveyed by `from` being the zero address or not.
238      *
239      * This call occurs _after_ the token contract's state is updated, so
240      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
241      *
242      * This function may revert to prevent the operation from being executed.
243      */
244     function tokensReceived(
245         address operator,
246         address from,
247         address to,
248         uint256 amount,
249         bytes calldata userData,
250         bytes calldata operatorData
251     ) external;
252 }
253 
254 // File: @openzeppelin/contracts/token/ERC777/IERC777Sender.sol
255 
256 pragma solidity ^0.6.0;
257 
258 /**
259  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
260  *
261  * {IERC777} Token holders can be notified of operations performed on their
262  * tokens by having a contract implement this interface (contract holders can be
263  *  their own implementer) and registering it on the
264  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
265  *
266  * See {IERC1820Registry} and {ERC1820Implementer}.
267  */
268 interface IERC777Sender {
269     /**
270      * @dev Called by an {IERC777} token contract whenever a registered holder's
271      * (`from`) tokens are about to be moved or destroyed. The type of operation
272      * is conveyed by `to` being the zero address or not.
273      *
274      * This call occurs _before_ the token contract's state is updated, so
275      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
276      *
277      * This function may revert to prevent the operation from being executed.
278      */
279     function tokensToSend(
280         address operator,
281         address from,
282         address to,
283         uint256 amount,
284         bytes calldata userData,
285         bytes calldata operatorData
286     ) external;
287 }
288 
289 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
290 
291 pragma solidity ^0.6.0;
292 
293 /**
294  * @dev Interface of the ERC20 standard as defined in the EIP.
295  */
296 interface IERC20 {
297     /**
298      * @dev Returns the amount of tokens in existence.
299      */
300     function totalSupply() external view returns (uint256);
301 
302     /**
303      * @dev Returns the amount of tokens owned by `account`.
304      */
305     function balanceOf(address account) external view returns (uint256);
306 
307     /**
308      * @dev Moves `amount` tokens from the caller's account to `recipient`.
309      *
310      * Returns a boolean value indicating whether the operation succeeded.
311      *
312      * Emits a {Transfer} event.
313      */
314     function transfer(address recipient, uint256 amount) external returns (bool);
315 
316     /**
317      * @dev Returns the remaining number of tokens that `spender` will be
318      * allowed to spend on behalf of `owner` through {transferFrom}. This is
319      * zero by default.
320      *
321      * This value changes when {approve} or {transferFrom} are called.
322      */
323     function allowance(address owner, address spender) external view returns (uint256);
324 
325     /**
326      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
327      *
328      * Returns a boolean value indicating whether the operation succeeded.
329      *
330      * IMPORTANT: Beware that changing an allowance with this method brings the risk
331      * that someone may use both the old and the new allowance by unfortunate
332      * transaction ordering. One possible solution to mitigate this race
333      * condition is to first reduce the spender's allowance to 0 and set the
334      * desired value afterwards:
335      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
336      *
337      * Emits an {Approval} event.
338      */
339     function approve(address spender, uint256 amount) external returns (bool);
340 
341     /**
342      * @dev Moves `amount` tokens from `sender` to `recipient` using the
343      * allowance mechanism. `amount` is then deducted from the caller's
344      * allowance.
345      *
346      * Returns a boolean value indicating whether the operation succeeded.
347      *
348      * Emits a {Transfer} event.
349      */
350     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
351 
352     /**
353      * @dev Emitted when `value` tokens are moved from one account (`from`) to
354      * another (`to`).
355      *
356      * Note that `value` may be zero.
357      */
358     event Transfer(address indexed from, address indexed to, uint256 value);
359 
360     /**
361      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
362      * a call to {approve}. `value` is the new allowance.
363      */
364     event Approval(address indexed owner, address indexed spender, uint256 value);
365 }
366 
367 // File: @openzeppelin/contracts/math/SafeMath.sol
368 
369 pragma solidity ^0.6.0;
370 
371 /**
372  * @dev Wrappers over Solidity's arithmetic operations with added overflow
373  * checks.
374  *
375  * Arithmetic operations in Solidity wrap on overflow. This can easily result
376  * in bugs, because programmers usually assume that an overflow raises an
377  * error, which is the standard behavior in high level programming languages.
378  * `SafeMath` restores this intuition by reverting the transaction when an
379  * operation overflows.
380  *
381  * Using this library instead of the unchecked operations eliminates an entire
382  * class of bugs, so it's recommended to use it always.
383  */
384 library SafeMath {
385     /**
386      * @dev Returns the addition of two unsigned integers, reverting on
387      * overflow.
388      *
389      * Counterpart to Solidity's `+` operator.
390      *
391      * Requirements:
392      * - Addition cannot overflow.
393      */
394     function add(uint256 a, uint256 b) internal pure returns (uint256) {
395         uint256 c = a + b;
396         require(c >= a, "SafeMath: addition overflow");
397 
398         return c;
399     }
400 
401     /**
402      * @dev Returns the subtraction of two unsigned integers, reverting on
403      * overflow (when the result is negative).
404      *
405      * Counterpart to Solidity's `-` operator.
406      *
407      * Requirements:
408      * - Subtraction cannot overflow.
409      */
410     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
411         return sub(a, b, "SafeMath: subtraction overflow");
412     }
413 
414     /**
415      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
416      * overflow (when the result is negative).
417      *
418      * Counterpart to Solidity's `-` operator.
419      *
420      * Requirements:
421      * - Subtraction cannot overflow.
422      */
423     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
424         require(b <= a, errorMessage);
425         uint256 c = a - b;
426 
427         return c;
428     }
429 
430     /**
431      * @dev Returns the multiplication of two unsigned integers, reverting on
432      * overflow.
433      *
434      * Counterpart to Solidity's `*` operator.
435      *
436      * Requirements:
437      * - Multiplication cannot overflow.
438      */
439     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
440         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
441         // benefit is lost if 'b' is also tested.
442         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
443         if (a == 0) {
444             return 0;
445         }
446 
447         uint256 c = a * b;
448         require(c / a == b, "SafeMath: multiplication overflow");
449 
450         return c;
451     }
452 
453     /**
454      * @dev Returns the integer division of two unsigned integers. Reverts on
455      * division by zero. The result is rounded towards zero.
456      *
457      * Counterpart to Solidity's `/` operator. Note: this function uses a
458      * `revert` opcode (which leaves remaining gas untouched) while Solidity
459      * uses an invalid opcode to revert (consuming all remaining gas).
460      *
461      * Requirements:
462      * - The divisor cannot be zero.
463      */
464     function div(uint256 a, uint256 b) internal pure returns (uint256) {
465         return div(a, b, "SafeMath: division by zero");
466     }
467 
468     /**
469      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
470      * division by zero. The result is rounded towards zero.
471      *
472      * Counterpart to Solidity's `/` operator. Note: this function uses a
473      * `revert` opcode (which leaves remaining gas untouched) while Solidity
474      * uses an invalid opcode to revert (consuming all remaining gas).
475      *
476      * Requirements:
477      * - The divisor cannot be zero.
478      */
479     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
480         // Solidity only automatically asserts when dividing by 0
481         require(b > 0, errorMessage);
482         uint256 c = a / b;
483         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
484 
485         return c;
486     }
487 
488     /**
489      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
490      * Reverts when dividing by zero.
491      *
492      * Counterpart to Solidity's `%` operator. This function uses a `revert`
493      * opcode (which leaves remaining gas untouched) while Solidity uses an
494      * invalid opcode to revert (consuming all remaining gas).
495      *
496      * Requirements:
497      * - The divisor cannot be zero.
498      */
499     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
500         return mod(a, b, "SafeMath: modulo by zero");
501     }
502 
503     /**
504      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
505      * Reverts with custom message when dividing by zero.
506      *
507      * Counterpart to Solidity's `%` operator. This function uses a `revert`
508      * opcode (which leaves remaining gas untouched) while Solidity uses an
509      * invalid opcode to revert (consuming all remaining gas).
510      *
511      * Requirements:
512      * - The divisor cannot be zero.
513      */
514     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
515         require(b != 0, errorMessage);
516         return a % b;
517     }
518 }
519 
520 // File: @openzeppelin/contracts/utils/Address.sol
521 
522 pragma solidity ^0.6.2;
523 
524 /**
525  * @dev Collection of functions related to the address type
526  */
527 library Address {
528     /**
529      * @dev Returns true if `account` is a contract.
530      *
531      * [IMPORTANT]
532      * ====
533      * It is unsafe to assume that an address for which this function returns
534      * false is an externally-owned account (EOA) and not a contract.
535      *
536      * Among others, `isContract` will return false for the following
537      * types of addresses:
538      *
539      *  - an externally-owned account
540      *  - a contract in construction
541      *  - an address where a contract will be created
542      *  - an address where a contract lived, but was destroyed
543      * ====
544      */
545     function isContract(address account) internal view returns (bool) {
546         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
547         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
548         // for accounts without code, i.e. `keccak256('')`
549         bytes32 codehash;
550         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
551         // solhint-disable-next-line no-inline-assembly
552         assembly { codehash := extcodehash(account) }
553         return (codehash != accountHash && codehash != 0x0);
554     }
555 
556     /**
557      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
558      * `recipient`, forwarding all available gas and reverting on errors.
559      *
560      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
561      * of certain opcodes, possibly making contracts go over the 2300 gas limit
562      * imposed by `transfer`, making them unable to receive funds via
563      * `transfer`. {sendValue} removes this limitation.
564      *
565      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
566      *
567      * IMPORTANT: because control is transferred to `recipient`, care must be
568      * taken to not create reentrancy vulnerabilities. Consider using
569      * {ReentrancyGuard} or the
570      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
571      */
572     function sendValue(address payable recipient, uint256 amount) internal {
573         require(address(this).balance >= amount, "Address: insufficient balance");
574 
575         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
576         (bool success, ) = recipient.call{ value: amount }("");
577         require(success, "Address: unable to send value, recipient may have reverted");
578     }
579 }
580 
581 // File: @openzeppelin/contracts/introspection/IERC1820Registry.sol
582 
583 pragma solidity ^0.6.0;
584 
585 /**
586  * @dev Interface of the global ERC1820 Registry, as defined in the
587  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
588  * implementers for interfaces in this registry, as well as query support.
589  *
590  * Implementers may be shared by multiple accounts, and can also implement more
591  * than a single interface for each account. Contracts can implement interfaces
592  * for themselves, but externally-owned accounts (EOA) must delegate this to a
593  * contract.
594  *
595  * {IERC165} interfaces can also be queried via the registry.
596  *
597  * For an in-depth explanation and source code analysis, see the EIP text.
598  */
599 interface IERC1820Registry {
600     /**
601      * @dev Sets `newManager` as the manager for `account`. A manager of an
602      * account is able to set interface implementers for it.
603      *
604      * By default, each account is its own manager. Passing a value of `0x0` in
605      * `newManager` will reset the manager to this initial state.
606      *
607      * Emits a {ManagerChanged} event.
608      *
609      * Requirements:
610      *
611      * - the caller must be the current manager for `account`.
612      */
613     function setManager(address account, address newManager) external;
614 
615     /**
616      * @dev Returns the manager for `account`.
617      *
618      * See {setManager}.
619      */
620     function getManager(address account) external view returns (address);
621 
622     /**
623      * @dev Sets the `implementer` contract as ``account``'s implementer for
624      * `interfaceHash`.
625      *
626      * `account` being the zero address is an alias for the caller's address.
627      * The zero address can also be used in `implementer` to remove an old one.
628      *
629      * See {interfaceHash} to learn how these are created.
630      *
631      * Emits an {InterfaceImplementerSet} event.
632      *
633      * Requirements:
634      *
635      * - the caller must be the current manager for `account`.
636      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
637      * end in 28 zeroes).
638      * - `implementer` must implement {IERC1820Implementer} and return true when
639      * queried for support, unless `implementer` is the caller. See
640      * {IERC1820Implementer-canImplementInterfaceForAddress}.
641      */
642     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
643 
644     /**
645      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
646      * implementer is registered, returns the zero address.
647      *
648      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
649      * zeroes), `account` will be queried for support of it.
650      *
651      * `account` being the zero address is an alias for the caller's address.
652      */
653     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
654 
655     /**
656      * @dev Returns the interface hash for an `interfaceName`, as defined in the
657      * corresponding
658      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
659      */
660     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
661 
662     /**
663      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
664      *  @param account Address of the contract for which to update the cache.
665      *  @param interfaceId ERC165 interface for which to update the cache.
666      */
667     function updateERC165Cache(address account, bytes4 interfaceId) external;
668 
669     /**
670      *  @notice Checks whether a contract implements an ERC165 interface or not.
671      *  If the result is not cached a direct lookup on the contract address is performed.
672      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
673      *  {updateERC165Cache} with the contract address.
674      *  @param account Address of the contract to check.
675      *  @param interfaceId ERC165 interface to check.
676      *  @return True if `account` implements `interfaceId`, false otherwise.
677      */
678     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
679 
680     /**
681      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
682      *  @param account Address of the contract to check.
683      *  @param interfaceId ERC165 interface to check.
684      *  @return True if `account` implements `interfaceId`, false otherwise.
685      */
686     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
687 
688     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
689 
690     event ManagerChanged(address indexed account, address indexed newManager);
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC777/ERC777.sol
694 
695 pragma solidity ^0.6.0;
696 
697 
698 
699 
700 
701 
702 
703 
704 
705 /**
706  * @dev Implementation of the {IERC777} interface.
707  *
708  * This implementation is agnostic to the way tokens are created. This means
709  * that a supply mechanism has to be added in a derived contract using {_mint}.
710  *
711  * Support for ERC20 is included in this contract, as specified by the EIP: both
712  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
713  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
714  * movements.
715  *
716  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
717  * are no special restrictions in the amount of tokens that created, moved, or
718  * destroyed. This makes integration with ERC20 applications seamless.
719  */
720 contract ERC777 is Context, IERC777, IERC20 {
721     using SafeMath for uint256;
722     using Address for address;
723 
724     IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
725 
726     mapping(address => uint256) private _balances;
727 
728     uint256 private _totalSupply;
729 
730     string private _name;
731     string private _symbol;
732 
733     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
734     // See https://github.com/ethereum/solidity/issues/4024.
735 
736     // keccak256("ERC777TokensSender")
737     bytes32 constant private _TOKENS_SENDER_INTERFACE_HASH =
738         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
739 
740     // keccak256("ERC777TokensRecipient")
741     bytes32 constant private _TOKENS_RECIPIENT_INTERFACE_HASH =
742         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
743 
744     // This isn't ever read from - it's only used to respond to the defaultOperators query.
745     address[] private _defaultOperatorsArray;
746 
747     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
748     mapping(address => bool) private _defaultOperators;
749 
750     // For each account, a mapping of its operators and revoked default operators.
751     mapping(address => mapping(address => bool)) private _operators;
752     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
753 
754     // ERC20-allowances
755     mapping (address => mapping (address => uint256)) private _allowances;
756 
757     /**
758      * @dev `defaultOperators` may be an empty array.
759      */
760     constructor(
761         string memory name,
762         string memory symbol,
763         address[] memory defaultOperators
764     ) public {
765         _name = name;
766         _symbol = symbol;
767 
768         _defaultOperatorsArray = defaultOperators;
769         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
770             _defaultOperators[_defaultOperatorsArray[i]] = true;
771         }
772 
773         // register interfaces
774         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
775         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
776     }
777 
778     /**
779      * @dev See {IERC777-name}.
780      */
781     function name() public view override returns (string memory) {
782         return _name;
783     }
784 
785     /**
786      * @dev See {IERC777-symbol}.
787      */
788     function symbol() public view override returns (string memory) {
789         return _symbol;
790     }
791 
792     /**
793      * @dev See {ERC20-decimals}.
794      *
795      * Always returns 18, as per the
796      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
797      */
798     function decimals() public pure returns (uint8) {
799         return 18;
800     }
801 
802     /**
803      * @dev See {IERC777-granularity}.
804      *
805      * This implementation always returns `1`.
806      */
807     function granularity() public view override returns (uint256) {
808         return 1;
809     }
810 
811     /**
812      * @dev See {IERC777-totalSupply}.
813      */
814     function totalSupply() public view override(IERC20, IERC777) returns (uint256) {
815         return _totalSupply;
816     }
817 
818     /**
819      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
820      */
821     function balanceOf(address tokenHolder) public view override(IERC20, IERC777) returns (uint256) {
822         return _balances[tokenHolder];
823     }
824 
825     /**
826      * @dev See {IERC777-send}.
827      *
828      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
829      */
830     function send(address recipient, uint256 amount, bytes memory data) public override  {
831         _send(_msgSender(), recipient, amount, data, "", true);
832     }
833 
834     /**
835      * @dev See {IERC20-transfer}.
836      *
837      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
838      * interface if it is a contract.
839      *
840      * Also emits a {Sent} event.
841      */
842     function transfer(address recipient, uint256 amount) public override returns (bool) {
843         require(recipient != address(0), "ERC777: transfer to the zero address");
844 
845         address from = _msgSender();
846 
847         _callTokensToSend(from, from, recipient, amount, "", "");
848 
849         _move(from, from, recipient, amount, "", "");
850 
851         _callTokensReceived(from, from, recipient, amount, "", "", false);
852 
853         return true;
854     }
855 
856     /**
857      * @dev See {IERC777-burn}.
858      *
859      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
860      */
861     function burn(uint256 amount, bytes memory data) public override  {
862         _burn(_msgSender(), amount, data, "");
863     }
864 
865     /**
866      * @dev See {IERC777-isOperatorFor}.
867      */
868     function isOperatorFor(
869         address operator,
870         address tokenHolder
871     ) public view override returns (bool) {
872         return operator == tokenHolder ||
873             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
874             _operators[tokenHolder][operator];
875     }
876 
877     /**
878      * @dev See {IERC777-authorizeOperator}.
879      */
880     function authorizeOperator(address operator) public override  {
881         require(_msgSender() != operator, "ERC777: authorizing self as operator");
882 
883         if (_defaultOperators[operator]) {
884             delete _revokedDefaultOperators[_msgSender()][operator];
885         } else {
886             _operators[_msgSender()][operator] = true;
887         }
888 
889         emit AuthorizedOperator(operator, _msgSender());
890     }
891 
892     /**
893      * @dev See {IERC777-revokeOperator}.
894      */
895     function revokeOperator(address operator) public override  {
896         require(operator != _msgSender(), "ERC777: revoking self as operator");
897 
898         if (_defaultOperators[operator]) {
899             _revokedDefaultOperators[_msgSender()][operator] = true;
900         } else {
901             delete _operators[_msgSender()][operator];
902         }
903 
904         emit RevokedOperator(operator, _msgSender());
905     }
906 
907     /**
908      * @dev See {IERC777-defaultOperators}.
909      */
910     function defaultOperators() public view override returns (address[] memory) {
911         return _defaultOperatorsArray;
912     }
913 
914     /**
915      * @dev See {IERC777-operatorSend}.
916      *
917      * Emits {Sent} and {IERC20-Transfer} events.
918      */
919     function operatorSend(
920         address sender,
921         address recipient,
922         uint256 amount,
923         bytes memory data,
924         bytes memory operatorData
925     )
926     public override
927     {
928         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
929         _send(sender, recipient, amount, data, operatorData, true);
930     }
931 
932     /**
933      * @dev See {IERC777-operatorBurn}.
934      *
935      * Emits {Burned} and {IERC20-Transfer} events.
936      */
937     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public override {
938         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
939         _burn(account, amount, data, operatorData);
940     }
941 
942     /**
943      * @dev See {IERC20-allowance}.
944      *
945      * Note that operator and allowance concepts are orthogonal: operators may
946      * not have allowance, and accounts with allowance may not be operators
947      * themselves.
948      */
949     function allowance(address holder, address spender) public view override returns (uint256) {
950         return _allowances[holder][spender];
951     }
952 
953     /**
954      * @dev See {IERC20-approve}.
955      *
956      * Note that accounts cannot have allowance issued by their operators.
957      */
958     function approve(address spender, uint256 value) public override returns (bool) {
959         address holder = _msgSender();
960         _approve(holder, spender, value);
961         return true;
962     }
963 
964    /**
965     * @dev See {IERC20-transferFrom}.
966     *
967     * Note that operator and allowance concepts are orthogonal: operators cannot
968     * call `transferFrom` (unless they have allowance), and accounts with
969     * allowance cannot call `operatorSend` (unless they are operators).
970     *
971     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
972     */
973     function transferFrom(address holder, address recipient, uint256 amount) public override returns (bool) {
974         require(recipient != address(0), "ERC777: transfer to the zero address");
975         require(holder != address(0), "ERC777: transfer from the zero address");
976 
977         address spender = _msgSender();
978 
979         _callTokensToSend(spender, holder, recipient, amount, "", "");
980 
981         _move(spender, holder, recipient, amount, "", "");
982         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
983 
984         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
985 
986         return true;
987     }
988 
989     /**
990      * @dev Creates `amount` tokens and assigns them to `account`, increasing
991      * the total supply.
992      *
993      * If a send hook is registered for `account`, the corresponding function
994      * will be called with `operator`, `data` and `operatorData`.
995      *
996      * See {IERC777Sender} and {IERC777Recipient}.
997      *
998      * Emits {Minted} and {IERC20-Transfer} events.
999      *
1000      * Requirements
1001      *
1002      * - `account` cannot be the zero address.
1003      * - if `account` is a contract, it must implement the {IERC777Recipient}
1004      * interface.
1005      */
1006     function _mint(
1007         address account,
1008         uint256 amount,
1009         bytes memory userData,
1010         bytes memory operatorData
1011     )
1012     internal virtual
1013     {
1014         require(account != address(0), "ERC777: mint to the zero address");
1015 
1016         address operator = _msgSender();
1017 
1018         _beforeTokenTransfer(operator, address(0), account, amount);
1019 
1020         // Update state variables
1021         _totalSupply = _totalSupply.add(amount);
1022         _balances[account] = _balances[account].add(amount);
1023 
1024         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1025 
1026         emit Minted(operator, account, amount, userData, operatorData);
1027         emit Transfer(address(0), account, amount);
1028     }
1029 
1030     /**
1031      * @dev Send tokens
1032      * @param from address token holder address
1033      * @param to address recipient address
1034      * @param amount uint256 amount of tokens to transfer
1035      * @param userData bytes extra information provided by the token holder (if any)
1036      * @param operatorData bytes extra information provided by the operator (if any)
1037      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1038      */
1039     function _send(
1040         address from,
1041         address to,
1042         uint256 amount,
1043         bytes memory userData,
1044         bytes memory operatorData,
1045         bool requireReceptionAck
1046     )
1047         internal
1048     {
1049         require(from != address(0), "ERC777: send from the zero address");
1050         require(to != address(0), "ERC777: send to the zero address");
1051 
1052         address operator = _msgSender();
1053 
1054         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1055 
1056         _move(operator, from, to, amount, userData, operatorData);
1057 
1058         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1059     }
1060 
1061     /**
1062      * @dev Burn tokens
1063      * @param from address token holder address
1064      * @param amount uint256 amount of tokens to burn
1065      * @param data bytes extra information provided by the token holder
1066      * @param operatorData bytes extra information provided by the operator (if any)
1067      */
1068     function _burn(
1069         address from,
1070         uint256 amount,
1071         bytes memory data,
1072         bytes memory operatorData
1073     )
1074         internal virtual
1075     {
1076         require(from != address(0), "ERC777: burn from the zero address");
1077 
1078         address operator = _msgSender();
1079 
1080         _beforeTokenTransfer(operator, from, address(0), amount);
1081 
1082         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1083 
1084         // Update state variables
1085         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1086         _totalSupply = _totalSupply.sub(amount);
1087 
1088         emit Burned(operator, from, amount, data, operatorData);
1089         emit Transfer(from, address(0), amount);
1090     }
1091 
1092     function _move(
1093         address operator,
1094         address from,
1095         address to,
1096         uint256 amount,
1097         bytes memory userData,
1098         bytes memory operatorData
1099     )
1100         private
1101     {
1102         _beforeTokenTransfer(operator, from, to, amount);
1103 
1104         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1105         _balances[to] = _balances[to].add(amount);
1106 
1107         emit Sent(operator, from, to, amount, userData, operatorData);
1108         emit Transfer(from, to, amount);
1109     }
1110 
1111     /**
1112      * @dev See {ERC20-_approve}.
1113      *
1114      * Note that accounts cannot have allowance issued by their operators.
1115      */
1116     function _approve(address holder, address spender, uint256 value) internal {
1117         require(holder != address(0), "ERC777: approve from the zero address");
1118         require(spender != address(0), "ERC777: approve to the zero address");
1119 
1120         _allowances[holder][spender] = value;
1121         emit Approval(holder, spender, value);
1122     }
1123 
1124     /**
1125      * @dev Call from.tokensToSend() if the interface is registered
1126      * @param operator address operator requesting the transfer
1127      * @param from address token holder address
1128      * @param to address recipient address
1129      * @param amount uint256 amount of tokens to transfer
1130      * @param userData bytes extra information provided by the token holder (if any)
1131      * @param operatorData bytes extra information provided by the operator (if any)
1132      */
1133     function _callTokensToSend(
1134         address operator,
1135         address from,
1136         address to,
1137         uint256 amount,
1138         bytes memory userData,
1139         bytes memory operatorData
1140     )
1141         private
1142     {
1143         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
1144         if (implementer != address(0)) {
1145             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1146         }
1147     }
1148 
1149     /**
1150      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1151      * tokensReceived() was not registered for the recipient
1152      * @param operator address operator requesting the transfer
1153      * @param from address token holder address
1154      * @param to address recipient address
1155      * @param amount uint256 amount of tokens to transfer
1156      * @param userData bytes extra information provided by the token holder (if any)
1157      * @param operatorData bytes extra information provided by the operator (if any)
1158      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1159      */
1160     function _callTokensReceived(
1161         address operator,
1162         address from,
1163         address to,
1164         uint256 amount,
1165         bytes memory userData,
1166         bytes memory operatorData,
1167         bool requireReceptionAck
1168     )
1169         private
1170     {
1171         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(to, _TOKENS_RECIPIENT_INTERFACE_HASH);
1172         if (implementer != address(0)) {
1173             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1174         } else if (requireReceptionAck) {
1175             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1176         }
1177     }
1178 
1179     /**
1180      * @dev Hook that is called before any token transfer. This includes
1181      * calls to {send}, {transfer}, {operatorSend}, minting and burning.
1182      *
1183      * Calling conditions:
1184      *
1185      * - when `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1186      * transferred to `to`.
1187      * - when `from` is zero, `tokenId` will be minted for `to`.
1188      * - when `to` is zero, ``from``'s `tokenId` will be burned.
1189      * - `from` and `to` are never both zero.
1190      *
1191      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1192      */
1193     function _beforeTokenTransfer(address operator, address from, address to, uint256 tokenId) internal virtual { }
1194 }
1195 
1196 // File: @openzeppelin/contracts/access/Ownable.sol
1197 
1198 pragma solidity ^0.6.0;
1199 
1200 /**
1201  * @dev Contract module which provides a basic access control mechanism, where
1202  * there is an account (an owner) that can be granted exclusive access to
1203  * specific functions.
1204  *
1205  * By default, the owner account will be the one that deploys the contract. This
1206  * can later be changed with {transferOwnership}.
1207  *
1208  * This module is used through inheritance. It will make available the modifier
1209  * `onlyOwner`, which can be applied to your functions to restrict their use to
1210  * the owner.
1211  */
1212 contract Ownable is Context {
1213     address private _owner;
1214 
1215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1216 
1217     /**
1218      * @dev Initializes the contract setting the deployer as the initial owner.
1219      */
1220     constructor () internal {
1221         address msgSender = _msgSender();
1222         _owner = msgSender;
1223         emit OwnershipTransferred(address(0), msgSender);
1224     }
1225 
1226     /**
1227      * @dev Returns the address of the current owner.
1228      */
1229     function owner() public view returns (address) {
1230         return _owner;
1231     }
1232 
1233     /**
1234      * @dev Throws if called by any account other than the owner.
1235      */
1236     modifier onlyOwner() {
1237         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1238         _;
1239     }
1240 
1241     /**
1242      * @dev Leaves the contract without owner. It will not be possible to call
1243      * `onlyOwner` functions anymore. Can only be called by the current owner.
1244      *
1245      * NOTE: Renouncing ownership will leave the contract without an owner,
1246      * thereby removing any functionality that is only available to the owner.
1247      */
1248     function renounceOwnership() public virtual onlyOwner {
1249         emit OwnershipTransferred(_owner, address(0));
1250         _owner = address(0);
1251     }
1252 
1253     /**
1254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1255      * Can only be called by the current owner.
1256      */
1257     function transferOwnership(address newOwner) public virtual onlyOwner {
1258         require(newOwner != address(0), "Ownable: new owner is the zero address");
1259         emit OwnershipTransferred(_owner, newOwner);
1260         _owner = newOwner;
1261     }
1262 }
1263 
1264 // File: @openzeppelin/contracts/GSN/IRelayRecipient.sol
1265 
1266 pragma solidity ^0.6.0;
1267 
1268 /**
1269  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
1270  *
1271  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
1272  */
1273 interface IRelayRecipient {
1274     /**
1275      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
1276      */
1277     function getHubAddr() external view returns (address);
1278 
1279     /**
1280      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
1281      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
1282      *
1283      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
1284      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
1285      * and the transaction executed with a gas price of at least `gasPrice`. ``relay``'s fee is `transactionFee`, and the
1286      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
1287      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
1288      * over all or some of the previous values.
1289      *
1290      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
1291      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
1292      *
1293      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
1294      * rejected. A regular revert will also trigger a rejection.
1295      */
1296     function acceptRelayedCall(
1297         address relay,
1298         address from,
1299         bytes calldata encodedFunction,
1300         uint256 transactionFee,
1301         uint256 gasPrice,
1302         uint256 gasLimit,
1303         uint256 nonce,
1304         bytes calldata approvalData,
1305         uint256 maxPossibleCharge
1306     )
1307         external
1308         view
1309         returns (uint256, bytes memory);
1310 
1311     /**
1312      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
1313      * pre-charge the sender of the transaction.
1314      *
1315      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
1316      *
1317      * Returns a value to be passed to {postRelayedCall}.
1318      *
1319      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
1320      * will not be executed, but the recipient will still be charged for the transaction's cost.
1321      */
1322     function preRelayedCall(bytes calldata context) external returns (bytes32);
1323 
1324     /**
1325      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
1326      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
1327      * contract-specific bookkeeping.
1328      *
1329      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
1330      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
1331      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
1332      *
1333      *
1334      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
1335      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
1336      * transaction's cost.
1337      */
1338     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
1339 }
1340 
1341 // File: @openzeppelin/contracts/GSN/IRelayHub.sol
1342 
1343 pragma solidity ^0.6.0;
1344 
1345 /**
1346  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
1347  * directly.
1348  *
1349  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
1350  * how to deploy an instance of `RelayHub` on your local test network.
1351  */
1352 interface IRelayHub {
1353     // Relay management
1354 
1355     /**
1356      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
1357      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
1358      * cannot be its own owner.
1359      *
1360      * All Ether in this function call will be added to the relay's stake.
1361      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
1362      *
1363      * Emits a {Staked} event.
1364      */
1365     function stake(address relayaddr, uint256 unstakeDelay) external payable;
1366 
1367     /**
1368      * @dev Emitted when a relay's stake or unstakeDelay are increased
1369      */
1370     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
1371 
1372     /**
1373      * @dev Registers the caller as a relay.
1374      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
1375      *
1376      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
1377      * `transactionFee` is not enforced by {relayCall}.
1378      *
1379      * Emits a {RelayAdded} event.
1380      */
1381     function registerRelay(uint256 transactionFee, string calldata url) external;
1382 
1383     /**
1384      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
1385      * {RelayRemoved} events) lets a client discover the list of available relays.
1386      */
1387     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
1388 
1389     /**
1390      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
1391      *
1392      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
1393      * callable.
1394      *
1395      * Emits a {RelayRemoved} event.
1396      */
1397     function removeRelayByOwner(address relay) external;
1398 
1399     /**
1400      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
1401      */
1402     event RelayRemoved(address indexed relay, uint256 unstakeTime);
1403 
1404     /** Deletes the relay from the system, and gives back its stake to the owner.
1405      *
1406      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
1407      *
1408      * Emits an {Unstaked} event.
1409      */
1410     function unstake(address relay) external;
1411 
1412     /**
1413      * @dev Emitted when a relay is unstaked for, including the returned stake.
1414      */
1415     event Unstaked(address indexed relay, uint256 stake);
1416 
1417     // States a relay can be in
1418     enum RelayState {
1419         Unknown, // The relay is unknown to the system: it has never been staked for
1420         Staked, // The relay has been staked for, but it is not yet active
1421         Registered, // The relay has registered itself, and is active (can relay calls)
1422         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
1423     }
1424 
1425     /**
1426      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
1427      * to return an empty entry.
1428      */
1429     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
1430 
1431     // Balance management
1432 
1433     /**
1434      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
1435      *
1436      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
1437      *
1438      * Emits a {Deposited} event.
1439      */
1440     function depositFor(address target) external payable;
1441 
1442     /**
1443      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
1444      */
1445     event Deposited(address indexed recipient, address indexed from, uint256 amount);
1446 
1447     /**
1448      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
1449      */
1450     function balanceOf(address target) external view returns (uint256);
1451 
1452     /**
1453      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
1454      * contracts can use it to reduce their funding.
1455      *
1456      * Emits a {Withdrawn} event.
1457      */
1458     function withdraw(uint256 amount, address payable dest) external;
1459 
1460     /**
1461      * @dev Emitted when an account withdraws funds from `RelayHub`.
1462      */
1463     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
1464 
1465     // Relaying
1466 
1467     /**
1468      * @dev Checks if the `RelayHub` will accept a relayed operation.
1469      * Multiple things must be true for this to happen:
1470      *  - all arguments must be signed for by the sender (`from`)
1471      *  - the sender's nonce must be the current one
1472      *  - the recipient must accept this transaction (via {acceptRelayedCall})
1473      *
1474      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
1475      * code if it returns one in {acceptRelayedCall}.
1476      */
1477     function canRelay(
1478         address relay,
1479         address from,
1480         address to,
1481         bytes calldata encodedFunction,
1482         uint256 transactionFee,
1483         uint256 gasPrice,
1484         uint256 gasLimit,
1485         uint256 nonce,
1486         bytes calldata signature,
1487         bytes calldata approvalData
1488     ) external view returns (uint256 status, bytes memory recipientContext);
1489 
1490     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
1491     enum PreconditionCheck {
1492         OK,                         // All checks passed, the call can be relayed
1493         WrongSignature,             // The transaction to relay is not signed by requested sender
1494         WrongNonce,                 // The provided nonce has already been used by the sender
1495         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
1496         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
1497     }
1498 
1499     /**
1500      * @dev Relays a transaction.
1501      *
1502      * For this to succeed, multiple conditions must be met:
1503      *  - {canRelay} must `return PreconditionCheck.OK`
1504      *  - the sender must be a registered relay
1505      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
1506      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
1507      * recipient) use all gas available to them
1508      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
1509      * spent)
1510      *
1511      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
1512      * function and {postRelayedCall} will be called in that order.
1513      *
1514      * Parameters:
1515      *  - `from`: the client originating the request
1516      *  - `to`: the target {IRelayRecipient} contract
1517      *  - `encodedFunction`: the function call to relay, including data
1518      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
1519      *  - `gasPrice`: gas price the client is willing to pay
1520      *  - `gasLimit`: gas to forward when calling the encoded function
1521      *  - `nonce`: client's nonce
1522      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
1523      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
1524      * `RelayHub`, but it still can be used for e.g. a signature.
1525      *
1526      * Emits a {TransactionRelayed} event.
1527      */
1528     function relayCall(
1529         address from,
1530         address to,
1531         bytes calldata encodedFunction,
1532         uint256 transactionFee,
1533         uint256 gasPrice,
1534         uint256 gasLimit,
1535         uint256 nonce,
1536         bytes calldata signature,
1537         bytes calldata approvalData
1538     ) external;
1539 
1540     /**
1541      * @dev Emitted when an attempt to relay a call failed.
1542      *
1543      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
1544      * actual relayed call was not executed, and the recipient not charged.
1545      *
1546      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
1547      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
1548      */
1549     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
1550 
1551     /**
1552      * @dev Emitted when a transaction is relayed.
1553      * Useful when monitoring a relay's operation and relayed calls to a contract
1554      *
1555      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
1556      *
1557      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
1558      */
1559     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
1560 
1561     // Reason error codes for the TransactionRelayed event
1562     enum RelayCallStatus {
1563         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
1564         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
1565         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
1566         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
1567         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
1568     }
1569 
1570     /**
1571      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
1572      * spend up to `relayedCallStipend` gas.
1573      */
1574     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
1575 
1576     /**
1577      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
1578      */
1579     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
1580 
1581      // Relay penalization.
1582      // Any account can penalize relays, removing them from the system immediately, and rewarding the
1583     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
1584     // still loses half of its stake.
1585 
1586     /**
1587      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
1588      * different data (gas price, gas limit, etc. may be different).
1589      *
1590      * The (unsigned) transaction data and signature for both transactions must be provided.
1591      */
1592     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
1593 
1594     /**
1595      * @dev Penalize a relay that sent a transaction that didn't target ``RelayHub``'s {registerRelay} or {relayCall}.
1596      */
1597     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
1598 
1599     /**
1600      * @dev Emitted when a relay is penalized.
1601      */
1602     event Penalized(address indexed relay, address sender, uint256 amount);
1603 
1604     /**
1605      * @dev Returns an account's nonce in `RelayHub`.
1606      */
1607     function getNonce(address from) external view returns (uint256);
1608 }
1609 
1610 // File: @openzeppelin/contracts/GSN/GSNRecipient.sol
1611 
1612 pragma solidity ^0.6.0;
1613 
1614 
1615 
1616 
1617 /**
1618  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
1619  * and enables GSN support on all contracts in the inheritance tree.
1620  *
1621  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
1622  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
1623  * provided by derived contracts. See the
1624  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
1625  * information on how to use the pre-built {GSNRecipientSignature} and
1626  * {GSNRecipientERC20Fee}, or how to write your own.
1627  */
1628 abstract contract GSNRecipient is IRelayRecipient, Context {
1629     // Default RelayHub address, deployed on mainnet and all testnets at the same address
1630     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
1631 
1632     uint256 constant private _RELAYED_CALL_ACCEPTED = 0;
1633     uint256 constant private _RELAYED_CALL_REJECTED = 11;
1634 
1635     // How much gas is forwarded to postRelayedCall
1636     uint256 constant internal _POST_RELAYED_CALL_MAX_GAS = 100000;
1637 
1638     /**
1639      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
1640      */
1641     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
1642 
1643     /**
1644      * @dev Returns the address of the {IRelayHub} contract for this recipient.
1645      */
1646     function getHubAddr() public view override returns (address) {
1647         return _relayHub;
1648     }
1649 
1650     /**
1651      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
1652      * use the default instance.
1653      *
1654      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
1655      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
1656      */
1657     function _upgradeRelayHub(address newRelayHub) internal virtual {
1658         address currentRelayHub = _relayHub;
1659         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
1660         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
1661 
1662         emit RelayHubChanged(currentRelayHub, newRelayHub);
1663 
1664         _relayHub = newRelayHub;
1665     }
1666 
1667     /**
1668      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
1669      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
1670      */
1671     // This function is view for future-proofing, it may require reading from
1672     // storage in the future.
1673     function relayHubVersion() public view returns (string memory) {
1674         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1675         return "1.0.0";
1676     }
1677 
1678     /**
1679      * @dev Withdraws the recipient's deposits in `RelayHub`.
1680      *
1681      * Derived contracts should expose this in an external interface with proper access control.
1682      */
1683     function _withdrawDeposits(uint256 amount, address payable payee) internal virtual {
1684         IRelayHub(_relayHub).withdraw(amount, payee);
1685     }
1686 
1687     // Overrides for Context's functions: when called from RelayHub, sender and
1688     // data require some pre-processing: the actual sender is stored at the end
1689     // of the call data, which in turns means it needs to be removed from it
1690     // when handling said data.
1691 
1692     /**
1693      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
1694      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
1695      *
1696      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
1697      */
1698     function _msgSender() internal view virtual override returns (address payable) {
1699         if (msg.sender != _relayHub) {
1700             return msg.sender;
1701         } else {
1702             return _getRelayedCallSender();
1703         }
1704     }
1705 
1706     /**
1707      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1708      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
1709      *
1710      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1711      */
1712     function _msgData() internal view virtual override returns (bytes memory) {
1713         if (msg.sender != _relayHub) {
1714             return msg.data;
1715         } else {
1716             return _getRelayedCallData();
1717         }
1718     }
1719 
1720     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
1721     // internal hook.
1722 
1723     /**
1724      * @dev See `IRelayRecipient.preRelayedCall`.
1725      *
1726      * This function should not be overriden directly, use `_preRelayedCall` instead.
1727      *
1728      * * Requirements:
1729      *
1730      * - the caller must be the `RelayHub` contract.
1731      */
1732     function preRelayedCall(bytes memory context) public virtual override returns (bytes32) {
1733         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1734         return _preRelayedCall(context);
1735     }
1736 
1737     /**
1738      * @dev See `IRelayRecipient.preRelayedCall`.
1739      *
1740      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1741      * must implement this function with any relayed-call preprocessing they may wish to do.
1742      *
1743      */
1744     function _preRelayedCall(bytes memory context) internal virtual returns (bytes32);
1745 
1746     /**
1747      * @dev See `IRelayRecipient.postRelayedCall`.
1748      *
1749      * This function should not be overriden directly, use `_postRelayedCall` instead.
1750      *
1751      * * Requirements:
1752      *
1753      * - the caller must be the `RelayHub` contract.
1754      */
1755     function postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) public virtual override {
1756         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1757         _postRelayedCall(context, success, actualCharge, preRetVal);
1758     }
1759 
1760     /**
1761      * @dev See `IRelayRecipient.postRelayedCall`.
1762      *
1763      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1764      * must implement this function with any relayed-call postprocessing they may wish to do.
1765      *
1766      */
1767     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal virtual;
1768 
1769     /**
1770      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
1771      * will be charged a fee by RelayHub
1772      */
1773     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
1774         return _approveRelayedCall("");
1775     }
1776 
1777     /**
1778      * @dev See `GSNRecipient._approveRelayedCall`.
1779      *
1780      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
1781      */
1782     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
1783         return (_RELAYED_CALL_ACCEPTED, context);
1784     }
1785 
1786     /**
1787      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
1788      */
1789     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
1790         return (_RELAYED_CALL_REJECTED + errorCode, "");
1791     }
1792 
1793     /*
1794      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
1795      * `serviceFee`.
1796      */
1797     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
1798         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
1799         // charged for 1.4 times the spent amount.
1800         return (gas * gasPrice * (100 + serviceFee)) / 100;
1801     }
1802 
1803     function _getRelayedCallSender() private pure returns (address payable result) {
1804         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
1805         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
1806         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
1807         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
1808         // bytes. This can always be done due to the 32-byte prefix.
1809 
1810         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
1811         // easiest/most-efficient way to perform this operation.
1812 
1813         // These fields are not accessible from assembly
1814         bytes memory array = msg.data;
1815         uint256 index = msg.data.length;
1816 
1817         // solhint-disable-next-line no-inline-assembly
1818         assembly {
1819             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1820             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1821         }
1822         return result;
1823     }
1824 
1825     function _getRelayedCallData() private pure returns (bytes memory) {
1826         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
1827         // we must strip the last 20 bytes (length of an address type) from it.
1828 
1829         uint256 actualDataLength = msg.data.length - 20;
1830         bytes memory actualData = new bytes(actualDataLength);
1831 
1832         for (uint256 i = 0; i < actualDataLength; ++i) {
1833             actualData[i] = msg.data[i];
1834         }
1835 
1836         return actualData;
1837     }
1838 }
1839 
1840 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
1841 
1842 pragma solidity ^0.6.0;
1843 
1844 /**
1845  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1846  *
1847  * These functions can be used to verify that a message was signed by the holder
1848  * of the private keys of a given address.
1849  */
1850 library ECDSA {
1851     /**
1852      * @dev Returns the address that signed a hashed message (`hash`) with
1853      * `signature`. This address can then be used for verification purposes.
1854      *
1855      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1856      * this function rejects them by requiring the `s` value to be in the lower
1857      * half order, and the `v` value to be either 27 or 28.
1858      *
1859      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1860      * verification to be secure: it is possible to craft signatures that
1861      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1862      * this is by receiving a hash of the original message (which may otherwise
1863      * be too long), and then calling {toEthSignedMessageHash} on it.
1864      */
1865     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1866         // Check the signature length
1867         if (signature.length != 65) {
1868             revert("ECDSA: invalid signature length");
1869         }
1870 
1871         // Divide the signature in r, s and v variables
1872         bytes32 r;
1873         bytes32 s;
1874         uint8 v;
1875 
1876         // ecrecover takes the signature parameters, and the only way to get them
1877         // currently is to use assembly.
1878         // solhint-disable-next-line no-inline-assembly
1879         assembly {
1880             r := mload(add(signature, 0x20))
1881             s := mload(add(signature, 0x40))
1882             v := byte(0, mload(add(signature, 0x60)))
1883         }
1884 
1885         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1886         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1887         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1888         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1889         //
1890         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1891         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1892         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1893         // these malleable signatures as well.
1894         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1895             revert("ECDSA: invalid signature 's' value");
1896         }
1897 
1898         if (v != 27 && v != 28) {
1899             revert("ECDSA: invalid signature 'v' value");
1900         }
1901 
1902         // If the signature is valid (and not malleable), return the signer address
1903         address signer = ecrecover(hash, v, r, s);
1904         require(signer != address(0), "ECDSA: invalid signature");
1905 
1906         return signer;
1907     }
1908 
1909     /**
1910      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1911      * replicates the behavior of the
1912      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
1913      * JSON-RPC method.
1914      *
1915      * See {recover}.
1916      */
1917     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1918         // 32 is the length in bytes of hash,
1919         // enforced by the type signature above
1920         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1921     }
1922 }
1923 
1924 // File: @openzeppelin/contracts/utils/Pausable.sol
1925 
1926 pragma solidity ^0.6.0;
1927 
1928 
1929 /**
1930  * @dev Contract module which allows children to implement an emergency stop
1931  * mechanism that can be triggered by an authorized account.
1932  *
1933  * This module is used through inheritance. It will make available the
1934  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1935  * the functions of your contract. Note that they will not be pausable by
1936  * simply including this module, only once the modifiers are put in place.
1937  */
1938 contract Pausable is Context {
1939     /**
1940      * @dev Emitted when the pause is triggered by `account`.
1941      */
1942     event Paused(address account);
1943 
1944     /**
1945      * @dev Emitted when the pause is lifted by `account`.
1946      */
1947     event Unpaused(address account);
1948 
1949     bool private _paused;
1950 
1951     /**
1952      * @dev Initializes the contract in unpaused state.
1953      */
1954     constructor () internal {
1955         _paused = false;
1956     }
1957 
1958     /**
1959      * @dev Returns true if the contract is paused, and false otherwise.
1960      */
1961     function paused() public view returns (bool) {
1962         return _paused;
1963     }
1964 
1965     /**
1966      * @dev Modifier to make a function callable only when the contract is not paused.
1967      */
1968     modifier whenNotPaused() {
1969         require(!_paused, "Pausable: paused");
1970         _;
1971     }
1972 
1973     /**
1974      * @dev Modifier to make a function callable only when the contract is paused.
1975      */
1976     modifier whenPaused() {
1977         require(_paused, "Pausable: not paused");
1978         _;
1979     }
1980 
1981     /**
1982      * @dev Triggers stopped state.
1983      */
1984     function _pause() internal virtual whenNotPaused {
1985         _paused = true;
1986         emit Paused(_msgSender());
1987     }
1988 
1989     /**
1990      * @dev Returns to normal state.
1991      */
1992     function _unpause() internal virtual whenPaused {
1993         _paused = false;
1994         emit Unpaused(_msgSender());
1995     }
1996 }
1997 
1998 // File: contracts/PNT.sol
1999 
2000 pragma solidity ^0.6.0;
2001 
2002 
2003 
2004 
2005 
2006 
2007 
2008 contract PNT is Ownable, Pausable, GSNRecipient, ERC777 {
2009   using ECDSA for bytes32;
2010   uint256 constant GSN_RATE_UNIT = 10**18;
2011 
2012   enum GSNErrorCodes {
2013     INVALID_SIGNER,
2014     INSUFFICIENT_BALANCE
2015   }
2016 
2017   address public gsnTrustedSigner;
2018   address public gsnFeeTarget;
2019   uint256 public gsnExtraGas = 40000; // the gas cost of _postRelayedCall()
2020 
2021   address public inflationOwner;
2022   uint256 public inflationWithdrawnAmount;
2023   uint256 public inflationStartTime;
2024   uint256[] public inflationTimeSpans;
2025   uint256[] public inflationAmounts;
2026 
2027   address public adminOperator;
2028 
2029   event InflationMint(uint256 currentAccruedInflation, uint256 withdrawn, address target);
2030   event AdminOperatorChange(address oldOperator, address newOperator);
2031   event AdminTransferInvoked(address operator);
2032 
2033   constructor(
2034     uint256 initialSupply,
2035     address _gsnTrustedSigner,
2036     address _gsnFeeTarget,
2037     uint256[] memory _inflationTimeSpans,
2038     uint256[] memory _inflationsAmounts,
2039     address _adminOperator
2040   )
2041     public
2042     ERC777("pNetwork Token", "PNT", new address[](0))
2043   {
2044     require(_inflationTimeSpans.length == _inflationsAmounts.length, "_inflationTimeSpans.length != _inflationsAmounts.length");
2045     setTrustedSigner(_gsnTrustedSigner);
2046     setFeeTarget(_gsnFeeTarget);
2047     inflationTimeSpans = _inflationTimeSpans;
2048     inflationAmounts = _inflationsAmounts;
2049     inflationStartTime = now;
2050     adminOperator = _adminOperator;
2051     _mint(msg.sender, initialSupply, "", "");
2052   }
2053 
2054   function _msgSender() internal view virtual override(Context, GSNRecipient) returns (address payable) {
2055     return GSNRecipient._msgSender();
2056   }
2057 
2058   function _msgData() internal view virtual override(Context, GSNRecipient) returns (bytes memory) {
2059     return GSNRecipient._msgData();
2060   }
2061 
2062   /**
2063      * @dev See {ERC777-_beforeTokenTransfer}.
2064      *
2065      * Requirements:
2066      *
2067      * - the contract must not be paused.
2068      */
2069   function _beforeTokenTransfer(address operator, address from, address to, uint256 tokenId) internal virtual override {
2070     super._beforeTokenTransfer(operator, from, to, tokenId);
2071     require(!paused(), "Transfer forbidden while paused");
2072   }
2073 
2074   function pause() public onlyOwner  {
2075     super._pause();
2076   }
2077 
2078   function unpause() public onlyOwner {
2079     super._unpause();
2080   }
2081 
2082   /**
2083    * @dev Similar to {IERC777-operatorSend}.
2084    *
2085    * Emits {Sent} and {IERC20-Transfer} events.
2086    */
2087   function adminTransfer(
2088     address sender,
2089     address recipient,
2090     uint256 amount,
2091     bytes memory data,
2092     bytes memory operatorData
2093   )
2094     public
2095   {
2096     require(_msgSender() == adminOperator, "caller is not the admin operator");
2097     _send(sender, recipient, amount, data, operatorData, false);
2098     emit AdminTransferInvoked(adminOperator);
2099   }
2100 
2101   /**
2102    * @dev Only the actual admin operator can change the address
2103    */
2104   function setAdminOperator(address adminOperator_) public {
2105     require(msg.sender == adminOperator, "Only the actual admin operator can change the address");
2106     emit AdminOperatorChange(adminOperator, adminOperator_);
2107     adminOperator = adminOperator_;
2108   }
2109 
2110   function setTrustedSigner(address _gsnTrustedSigner) public onlyOwner {
2111     require(_gsnTrustedSigner != address(0), "trusted signer is the zero address");
2112     gsnTrustedSigner = _gsnTrustedSigner;
2113   }
2114 
2115   function setFeeTarget(address _gsnFeeTarget) public onlyOwner {
2116     require(_gsnFeeTarget != address(0), "fee target is the zero address");
2117     gsnFeeTarget = _gsnFeeTarget;
2118   }
2119 
2120   function setGSNExtraGas(uint _gsnExtraGas) public onlyOwner {
2121     gsnExtraGas = _gsnExtraGas;
2122   }
2123 
2124   modifier onlyInflationOwner() {
2125     require(msg.sender == inflationOwner, "msg.sender != inflationOwner");
2126     _;
2127   }
2128 
2129   function setInflationOwner(address newOwner) public onlyOwner {
2130     inflationOwner = newOwner;
2131   }
2132 
2133   function getInflation() public view returns(uint256 inflation) {
2134     inflation = 0;
2135     uint256 start = inflationStartTime;
2136     uint256 i = 0;
2137     while (start < now && i < inflationTimeSpans.length) {
2138       uint256 length = inflationTimeSpans[i];
2139       uint256 elapsed = now - start; // safe math not required
2140       uint256 accrued = (elapsed >= length)
2141         ? inflationAmounts[i]
2142         : inflationAmounts[i].mul(elapsed).div(length);
2143       inflation = inflation.add(accrued);
2144       start = start.add(length);
2145       i++;
2146     }
2147   }
2148 
2149   function withdrawInflation() public onlyInflationOwner {
2150     uint256 accrued = getInflation();
2151     uint256 amount = accrued.sub(inflationWithdrawnAmount);
2152     if (amount > 0) {
2153       inflationWithdrawnAmount = inflationWithdrawnAmount.add(amount);
2154       _mint(inflationOwner, amount, "", "");
2155       emit InflationMint(accrued, amount, inflationOwner);
2156     }
2157   }
2158 
2159   /**
2160  * @dev Ensures that only transactions with a trusted signature can be relayed through the GSN.
2161  */
2162   function acceptRelayedCall(
2163     address relay,
2164     address from,
2165     bytes memory encodedFunction,
2166     uint256 transactionFee,
2167     uint256 gasPrice,
2168     uint256 gasLimit,
2169     uint256 nonce,
2170     bytes memory approvalData,
2171     uint256 /* maxPossibleCharge */
2172   )
2173     public
2174     view
2175     virtual
2176     override
2177     returns (uint256, bytes memory)
2178   {
2179     (uint256 feeRate, bytes memory signature) = abi.decode(approvalData, (uint, bytes));
2180     bytes memory blob = abi.encodePacked(
2181       feeRate,
2182       relay,
2183       from,
2184       encodedFunction,
2185       transactionFee,
2186       gasPrice,
2187       gasLimit,
2188       nonce, // Prevents replays on RelayHub
2189       getHubAddr(), // Prevents replays in multiple RelayHubs
2190       address(this) // Prevents replays in multiple recipients
2191     );
2192     if (keccak256(blob).toEthSignedMessageHash().recover(signature) == gsnTrustedSigner) {
2193       return _approveRelayedCall(abi.encode(feeRate, from, transactionFee, gasPrice));
2194     } else {
2195       return _rejectRelayedCall(uint256(GSNErrorCodes.INVALID_SIGNER));
2196     }
2197   }
2198 
2199   function _preRelayedCall(bytes memory context) internal virtual override returns (bytes32) {}
2200 
2201   function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal virtual override {
2202     (uint256 feeRate, address from, uint256 transactionFee, uint256 gasPrice) =
2203       abi.decode(context, (uint256, address, uint256, uint256));
2204 
2205     // actualCharge is an _estimated_ charge, which assumes postRelayedCall will use all available gas.
2206     // This implementation's gas cost can be roughly estimated as 10k gas, for the two SSTORE operations in an
2207     // ERC20 transfer.
2208     uint256 overestimation = _computeCharge(_POST_RELAYED_CALL_MAX_GAS.sub(gsnExtraGas), gasPrice, transactionFee);
2209     uint fee = actualCharge.sub(overestimation).mul(feeRate).div(GSN_RATE_UNIT);
2210 
2211     if (fee > 0) {
2212       _send(from, gsnFeeTarget, fee, "", "", false);
2213     }
2214   }
2215 }