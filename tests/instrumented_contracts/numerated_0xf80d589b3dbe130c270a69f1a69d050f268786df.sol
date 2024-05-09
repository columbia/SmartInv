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
1196 // File: contracts/DamToken.sol
1197 
1198 pragma solidity ^0.6.0;
1199 
1200 
1201 contract DamToken is ERC777 {
1202     constructor () public ERC777("Datamine", "DAM", new address[](0)) {
1203         _mint(msg.sender, 25000000 * (10 ** 18), "", "");
1204     }
1205 }