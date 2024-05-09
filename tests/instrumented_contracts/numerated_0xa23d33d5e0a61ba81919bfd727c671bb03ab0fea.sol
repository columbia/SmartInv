1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC777/IERC777.sol
30 
31 pragma solidity ^0.5.0;
32 
33 /**
34  * @dev Interface of the ERC777Token standard as defined in the EIP.
35  *
36  * This contract uses the
37  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
38  * token holders and recipients react to token movements by using setting implementers
39  * for the associated interfaces in said registry. See {IERC1820Registry} and
40  * {ERC1820Implementer}.
41  */
42 interface IERC777 {
43     /**
44      * @dev Returns the name of the token.
45      */
46     function name() external view returns (string memory);
47 
48     /**
49      * @dev Returns the symbol of the token, usually a shorter version of the
50      * name.
51      */
52     function symbol() external view returns (string memory);
53 
54     /**
55      * @dev Returns the smallest part of the token that is not divisible. This
56      * means all token operations (creation, movement and destruction) must have
57      * amounts that are a multiple of this number.
58      *
59      * For most token contracts, this value will equal 1.
60      */
61     function granularity() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens in existence.
65      */
66     function totalSupply() external view returns (uint256);
67 
68     /**
69      * @dev Returns the amount of tokens owned by an account (`owner`).
70      */
71     function balanceOf(address owner) external view returns (uint256);
72 
73     /**
74      * @dev Moves `amount` tokens from the caller's account to `recipient`.
75      *
76      * If send or receive hooks are registered for the caller and `recipient`,
77      * the corresponding functions will be called with `data` and empty
78      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
79      *
80      * Emits a {Sent} event.
81      *
82      * Requirements
83      *
84      * - the caller must have at least `amount` tokens.
85      * - `recipient` cannot be the zero address.
86      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
87      * interface.
88      */
89     function send(address recipient, uint256 amount, bytes calldata data) external;
90 
91     /**
92      * @dev Destroys `amount` tokens from the caller's account, reducing the
93      * total supply.
94      *
95      * If a send hook is registered for the caller, the corresponding function
96      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
97      *
98      * Emits a {Burned} event.
99      *
100      * Requirements
101      *
102      * - the caller must have at least `amount` tokens.
103      */
104     function burn(uint256 amount, bytes calldata data) external;
105 
106     /**
107      * @dev Returns true if an account is an operator of `tokenHolder`.
108      * Operators can send and burn tokens on behalf of their owners. All
109      * accounts are their own operator.
110      *
111      * See {operatorSend} and {operatorBurn}.
112      */
113     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
114 
115     /**
116      * @dev Make an account an operator of the caller.
117      *
118      * See {isOperatorFor}.
119      *
120      * Emits an {AuthorizedOperator} event.
121      *
122      * Requirements
123      *
124      * - `operator` cannot be calling address.
125      */
126     function authorizeOperator(address operator) external;
127 
128     /**
129      * @dev Make an account an operator of the caller.
130      *
131      * See {isOperatorFor} and {defaultOperators}.
132      *
133      * Emits a {RevokedOperator} event.
134      *
135      * Requirements
136      *
137      * - `operator` cannot be calling address.
138      */
139     function revokeOperator(address operator) external;
140 
141     /**
142      * @dev Returns the list of default operators. These accounts are operators
143      * for all token holders, even if {authorizeOperator} was never called on
144      * them.
145      *
146      * This list is immutable, but individual holders may revoke these via
147      * {revokeOperator}, in which case {isOperatorFor} will return false.
148      */
149     function defaultOperators() external view returns (address[] memory);
150 
151     /**
152      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
153      * be an operator of `sender`.
154      *
155      * If send or receive hooks are registered for `sender` and `recipient`,
156      * the corresponding functions will be called with `data` and
157      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
158      *
159      * Emits a {Sent} event.
160      *
161      * Requirements
162      *
163      * - `sender` cannot be the zero address.
164      * - `sender` must have at least `amount` tokens.
165      * - the caller must be an operator for `sender`.
166      * - `recipient` cannot be the zero address.
167      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
168      * interface.
169      */
170     function operatorSend(
171         address sender,
172         address recipient,
173         uint256 amount,
174         bytes calldata data,
175         bytes calldata operatorData
176     ) external;
177 
178     /**
179      * @dev Destoys `amount` tokens from `account`, reducing the total supply.
180      * The caller must be an operator of `account`.
181      *
182      * If a send hook is registered for `account`, the corresponding function
183      * will be called with `data` and `operatorData`. See {IERC777Sender}.
184      *
185      * Emits a {Burned} event.
186      *
187      * Requirements
188      *
189      * - `account` cannot be the zero address.
190      * - `account` must have at least `amount` tokens.
191      * - the caller must be an operator for `account`.
192      */
193     function operatorBurn(
194         address account,
195         uint256 amount,
196         bytes calldata data,
197         bytes calldata operatorData
198     ) external;
199 
200     event Sent(
201         address indexed operator,
202         address indexed from,
203         address indexed to,
204         uint256 amount,
205         bytes data,
206         bytes operatorData
207     );
208 
209     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
210 
211     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
212 
213     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
214 
215     event RevokedOperator(address indexed operator, address indexed tokenHolder);
216 }
217 
218 // File: @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol
219 
220 pragma solidity ^0.5.0;
221 
222 /**
223  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
224  *
225  * Accounts can be notified of {IERC777} tokens being sent to them by having a
226  * contract implement this interface (contract holders can be their own
227  * implementer) and registering it on the
228  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
229  *
230  * See {IERC1820Registry} and {ERC1820Implementer}.
231  */
232 interface IERC777Recipient {
233     /**
234      * @dev Called by an {IERC777} token contract whenever tokens are being
235      * moved or created into a registered account (`to`). The type of operation
236      * is conveyed by `from` being the zero address or not.
237      *
238      * This call occurs _after_ the token contract's state is updated, so
239      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
240      *
241      * This function may revert to prevent the operation from being executed.
242      */
243     function tokensReceived(
244         address operator,
245         address from,
246         address to,
247         uint256 amount,
248         bytes calldata userData,
249         bytes calldata operatorData
250     ) external;
251 }
252 
253 // File: @openzeppelin/contracts/token/ERC777/IERC777Sender.sol
254 
255 pragma solidity ^0.5.0;
256 
257 /**
258  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
259  *
260  * {IERC777} Token holders can be notified of operations performed on their
261  * tokens by having a contract implement this interface (contract holders can be
262  *  their own implementer) and registering it on the
263  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
264  *
265  * See {IERC1820Registry} and {ERC1820Implementer}.
266  */
267 interface IERC777Sender {
268     /**
269      * @dev Called by an {IERC777} token contract whenever a registered holder's
270      * (`from`) tokens are about to be moved or destroyed. The type of operation
271      * is conveyed by `to` being the zero address or not.
272      *
273      * This call occurs _before_ the token contract's state is updated, so
274      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
275      *
276      * This function may revert to prevent the operation from being executed.
277      */
278     function tokensToSend(
279         address operator,
280         address from,
281         address to,
282         uint256 amount,
283         bytes calldata userData,
284         bytes calldata operatorData
285     ) external;
286 }
287 
288 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
289 
290 pragma solidity ^0.5.0;
291 
292 /**
293  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
294  * the optional functions; to access them see {ERC20Detailed}.
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
369 pragma solidity ^0.5.0;
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
422      *
423      * _Available since v2.4.0._
424      */
425     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
426         require(b <= a, errorMessage);
427         uint256 c = a - b;
428 
429         return c;
430     }
431 
432     /**
433      * @dev Returns the multiplication of two unsigned integers, reverting on
434      * overflow.
435      *
436      * Counterpart to Solidity's `*` operator.
437      *
438      * Requirements:
439      * - Multiplication cannot overflow.
440      */
441     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
442         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
443         // benefit is lost if 'b' is also tested.
444         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
445         if (a == 0) {
446             return 0;
447         }
448 
449         uint256 c = a * b;
450         require(c / a == b, "SafeMath: multiplication overflow");
451 
452         return c;
453     }
454 
455     /**
456      * @dev Returns the integer division of two unsigned integers. Reverts on
457      * division by zero. The result is rounded towards zero.
458      *
459      * Counterpart to Solidity's `/` operator. Note: this function uses a
460      * `revert` opcode (which leaves remaining gas untouched) while Solidity
461      * uses an invalid opcode to revert (consuming all remaining gas).
462      *
463      * Requirements:
464      * - The divisor cannot be zero.
465      */
466     function div(uint256 a, uint256 b) internal pure returns (uint256) {
467         return div(a, b, "SafeMath: division by zero");
468     }
469 
470     /**
471      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
472      * division by zero. The result is rounded towards zero.
473      *
474      * Counterpart to Solidity's `/` operator. Note: this function uses a
475      * `revert` opcode (which leaves remaining gas untouched) while Solidity
476      * uses an invalid opcode to revert (consuming all remaining gas).
477      *
478      * Requirements:
479      * - The divisor cannot be zero.
480      *
481      * _Available since v2.4.0._
482      */
483     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
484         // Solidity only automatically asserts when dividing by 0
485         require(b > 0, errorMessage);
486         uint256 c = a / b;
487         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
494      * Reverts when dividing by zero.
495      *
496      * Counterpart to Solidity's `%` operator. This function uses a `revert`
497      * opcode (which leaves remaining gas untouched) while Solidity uses an
498      * invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      * - The divisor cannot be zero.
502      */
503     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
504         return mod(a, b, "SafeMath: modulo by zero");
505     }
506 
507     /**
508      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
509      * Reverts with custom message when dividing by zero.
510      *
511      * Counterpart to Solidity's `%` operator. This function uses a `revert`
512      * opcode (which leaves remaining gas untouched) while Solidity uses an
513      * invalid opcode to revert (consuming all remaining gas).
514      *
515      * Requirements:
516      * - The divisor cannot be zero.
517      *
518      * _Available since v2.4.0._
519      */
520     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
521         require(b != 0, errorMessage);
522         return a % b;
523     }
524 }
525 
526 // File: @openzeppelin/contracts/utils/Address.sol
527 
528 pragma solidity ^0.5.5;
529 
530 /**
531  * @dev Collection of functions related to the address type
532  */
533 library Address {
534     /**
535      * @dev Returns true if `account` is a contract.
536      *
537      * [IMPORTANT]
538      * ====
539      * It is unsafe to assume that an address for which this function returns
540      * false is an externally-owned account (EOA) and not a contract.
541      *
542      * Among others, `isContract` will return false for the following
543      * types of addresses:
544      *
545      *  - an externally-owned account
546      *  - a contract in construction
547      *  - an address where a contract will be created
548      *  - an address where a contract lived, but was destroyed
549      * ====
550      */
551     function isContract(address account) internal view returns (bool) {
552         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
553         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
554         // for accounts without code, i.e. `keccak256('')`
555         bytes32 codehash;
556         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
557         // solhint-disable-next-line no-inline-assembly
558         assembly { codehash := extcodehash(account) }
559         return (codehash != accountHash && codehash != 0x0);
560     }
561 
562     /**
563      * @dev Converts an `address` into `address payable`. Note that this is
564      * simply a type cast: the actual underlying value is not changed.
565      *
566      * _Available since v2.4.0._
567      */
568     function toPayable(address account) internal pure returns (address payable) {
569         return address(uint160(account));
570     }
571 
572     /**
573      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
574      * `recipient`, forwarding all available gas and reverting on errors.
575      *
576      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
577      * of certain opcodes, possibly making contracts go over the 2300 gas limit
578      * imposed by `transfer`, making them unable to receive funds via
579      * `transfer`. {sendValue} removes this limitation.
580      *
581      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
582      *
583      * IMPORTANT: because control is transferred to `recipient`, care must be
584      * taken to not create reentrancy vulnerabilities. Consider using
585      * {ReentrancyGuard} or the
586      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
587      *
588      * _Available since v2.4.0._
589      */
590     function sendValue(address payable recipient, uint256 amount) internal {
591         require(address(this).balance >= amount, "Address: insufficient balance");
592 
593         // solhint-disable-next-line avoid-call-value
594         (bool success, ) = recipient.call.value(amount)("");
595         require(success, "Address: unable to send value, recipient may have reverted");
596     }
597 }
598 
599 // File: @openzeppelin/contracts/introspection/IERC1820Registry.sol
600 
601 pragma solidity ^0.5.0;
602 
603 /**
604  * @dev Interface of the global ERC1820 Registry, as defined in the
605  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
606  * implementers for interfaces in this registry, as well as query support.
607  *
608  * Implementers may be shared by multiple accounts, and can also implement more
609  * than a single interface for each account. Contracts can implement interfaces
610  * for themselves, but externally-owned accounts (EOA) must delegate this to a
611  * contract.
612  *
613  * {IERC165} interfaces can also be queried via the registry.
614  *
615  * For an in-depth explanation and source code analysis, see the EIP text.
616  */
617 interface IERC1820Registry {
618     /**
619      * @dev Sets `newManager` as the manager for `account`. A manager of an
620      * account is able to set interface implementers for it.
621      *
622      * By default, each account is its own manager. Passing a value of `0x0` in
623      * `newManager` will reset the manager to this initial state.
624      *
625      * Emits a {ManagerChanged} event.
626      *
627      * Requirements:
628      *
629      * - the caller must be the current manager for `account`.
630      */
631     function setManager(address account, address newManager) external;
632 
633     /**
634      * @dev Returns the manager for `account`.
635      *
636      * See {setManager}.
637      */
638     function getManager(address account) external view returns (address);
639 
640     /**
641      * @dev Sets the `implementer` contract as `account`'s implementer for
642      * `interfaceHash`.
643      *
644      * `account` being the zero address is an alias for the caller's address.
645      * The zero address can also be used in `implementer` to remove an old one.
646      *
647      * See {interfaceHash} to learn how these are created.
648      *
649      * Emits an {InterfaceImplementerSet} event.
650      *
651      * Requirements:
652      *
653      * - the caller must be the current manager for `account`.
654      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
655      * end in 28 zeroes).
656      * - `implementer` must implement {IERC1820Implementer} and return true when
657      * queried for support, unless `implementer` is the caller. See
658      * {IERC1820Implementer-canImplementInterfaceForAddress}.
659      */
660     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
661 
662     /**
663      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
664      * implementer is registered, returns the zero address.
665      *
666      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
667      * zeroes), `account` will be queried for support of it.
668      *
669      * `account` being the zero address is an alias for the caller's address.
670      */
671     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
672 
673     /**
674      * @dev Returns the interface hash for an `interfaceName`, as defined in the
675      * corresponding
676      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
677      */
678     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
679 
680     /**
681      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
682      *  @param account Address of the contract for which to update the cache.
683      *  @param interfaceId ERC165 interface for which to update the cache.
684      */
685     function updateERC165Cache(address account, bytes4 interfaceId) external;
686 
687     /**
688      *  @notice Checks whether a contract implements an ERC165 interface or not.
689      *  If the result is not cached a direct lookup on the contract address is performed.
690      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
691      *  {updateERC165Cache} with the contract address.
692      *  @param account Address of the contract to check.
693      *  @param interfaceId ERC165 interface to check.
694      *  @return True if `account` implements `interfaceId`, false otherwise.
695      */
696     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
697 
698     /**
699      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
700      *  @param account Address of the contract to check.
701      *  @param interfaceId ERC165 interface to check.
702      *  @return True if `account` implements `interfaceId`, false otherwise.
703      */
704     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
705 
706     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
707 
708     event ManagerChanged(address indexed account, address indexed newManager);
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC777/ERC777.sol
712 
713 pragma solidity ^0.5.0;
714 
715 
716 
717 
718 
719 
720 
721 
722 
723 /**
724  * @dev Implementation of the {IERC777} interface.
725  *
726  * This implementation is agnostic to the way tokens are created. This means
727  * that a supply mechanism has to be added in a derived contract using {_mint}.
728  *
729  * Support for ERC20 is included in this contract, as specified by the EIP: both
730  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
731  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
732  * movements.
733  *
734  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
735  * are no special restrictions in the amount of tokens that created, moved, or
736  * destroyed. This makes integration with ERC20 applications seamless.
737  */
738 contract ERC777 is Context, IERC777, IERC20 {
739     using SafeMath for uint256;
740     using Address for address;
741 
742     IERC1820Registry constant internal ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
743 
744     mapping(address => uint256) private _balances;
745 
746     uint256 private _totalSupply;
747 
748     string private _name;
749     string private _symbol;
750 
751     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
752     // See https://github.com/ethereum/solidity/issues/4024.
753 
754     // keccak256("ERC777TokensSender")
755     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
756         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
757 
758     // keccak256("ERC777TokensRecipient")
759     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
760         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
761 
762     // This isn't ever read from - it's only used to respond to the defaultOperators query.
763     address[] private _defaultOperatorsArray;
764 
765     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
766     mapping(address => bool) private _defaultOperators;
767 
768     // For each account, a mapping of its operators and revoked default operators.
769     mapping(address => mapping(address => bool)) private _operators;
770     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
771 
772     // ERC20-allowances
773     mapping (address => mapping (address => uint256)) private _allowances;
774 
775     /**
776      * @dev `defaultOperators` may be an empty array.
777      */
778     constructor(
779         string memory name,
780         string memory symbol,
781         address[] memory defaultOperators
782     ) public {
783         _name = name;
784         _symbol = symbol;
785 
786         _defaultOperatorsArray = defaultOperators;
787         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
788             _defaultOperators[_defaultOperatorsArray[i]] = true;
789         }
790 
791         // register interfaces
792         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
793         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
794     }
795 
796     /**
797      * @dev See {IERC777-name}.
798      */
799     function name() public view returns (string memory) {
800         return _name;
801     }
802 
803     /**
804      * @dev See {IERC777-symbol}.
805      */
806     function symbol() public view returns (string memory) {
807         return _symbol;
808     }
809 
810     /**
811      * @dev See {ERC20Detailed-decimals}.
812      *
813      * Always returns 18, as per the
814      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
815      */
816     function decimals() public pure returns (uint8) {
817         return 18;
818     }
819 
820     /**
821      * @dev See {IERC777-granularity}.
822      *
823      * This implementation always returns `1`.
824      */
825     function granularity() public view returns (uint256) {
826         return 1;
827     }
828 
829     /**
830      * @dev See {IERC777-totalSupply}.
831      */
832     function totalSupply() public view returns (uint256) {
833         return _totalSupply;
834     }
835 
836     /**
837      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
838      */
839     function balanceOf(address tokenHolder) public view returns (uint256) {
840         return _balances[tokenHolder];
841     }
842 
843     /**
844      * @dev See {IERC777-send}.
845      *
846      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
847      */
848     function send(address recipient, uint256 amount, bytes memory data) public {
849         _send(_msgSender(), _msgSender(), recipient, amount, data, "", true);
850     }
851 
852     /**
853      * @dev See {IERC20-transfer}.
854      *
855      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
856      * interface if it is a contract.
857      *
858      * Also emits a {Sent} event.
859      */
860     function transfer(address recipient, uint256 amount) public returns (bool) {
861         require(recipient != address(0), "ERC777: transfer to the zero address");
862 
863         address from = _msgSender();
864 
865         _callTokensToSend(from, from, recipient, amount, "", "");
866 
867         _move(from, from, recipient, amount, "", "");
868 
869         _callTokensReceived(from, from, recipient, amount, "", "", false);
870 
871         return true;
872     }
873 
874     /**
875      * @dev See {IERC777-burn}.
876      *
877      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
878      */
879     function burn(uint256 amount, bytes memory data) public {
880         _burn(_msgSender(), _msgSender(), amount, data, "");
881     }
882 
883     /**
884      * @dev See {IERC777-isOperatorFor}.
885      */
886     function isOperatorFor(
887         address operator,
888         address tokenHolder
889     ) public view returns (bool) {
890         return operator == tokenHolder ||
891             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
892             _operators[tokenHolder][operator];
893     }
894 
895     /**
896      * @dev See {IERC777-authorizeOperator}.
897      */
898     function authorizeOperator(address operator) public {
899         require(_msgSender() != operator, "ERC777: authorizing self as operator");
900 
901         if (_defaultOperators[operator]) {
902             delete _revokedDefaultOperators[_msgSender()][operator];
903         } else {
904             _operators[_msgSender()][operator] = true;
905         }
906 
907         emit AuthorizedOperator(operator, _msgSender());
908     }
909 
910     /**
911      * @dev See {IERC777-revokeOperator}.
912      */
913     function revokeOperator(address operator) public {
914         require(operator != _msgSender(), "ERC777: revoking self as operator");
915 
916         if (_defaultOperators[operator]) {
917             _revokedDefaultOperators[_msgSender()][operator] = true;
918         } else {
919             delete _operators[_msgSender()][operator];
920         }
921 
922         emit RevokedOperator(operator, _msgSender());
923     }
924 
925     /**
926      * @dev See {IERC777-defaultOperators}.
927      */
928     function defaultOperators() public view returns (address[] memory) {
929         return _defaultOperatorsArray;
930     }
931 
932     /**
933      * @dev See {IERC777-operatorSend}.
934      *
935      * Emits {Sent} and {IERC20-Transfer} events.
936      */
937     function operatorSend(
938         address sender,
939         address recipient,
940         uint256 amount,
941         bytes memory data,
942         bytes memory operatorData
943     )
944     public
945     {
946         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
947         _send(_msgSender(), sender, recipient, amount, data, operatorData, true);
948     }
949 
950     /**
951      * @dev See {IERC777-operatorBurn}.
952      *
953      * Emits {Burned} and {IERC20-Transfer} events.
954      */
955     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public {
956         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
957         _burn(_msgSender(), account, amount, data, operatorData);
958     }
959 
960     /**
961      * @dev See {IERC20-allowance}.
962      *
963      * Note that operator and allowance concepts are orthogonal: operators may
964      * not have allowance, and accounts with allowance may not be operators
965      * themselves.
966      */
967     function allowance(address holder, address spender) public view returns (uint256) {
968         return _allowances[holder][spender];
969     }
970 
971     /**
972      * @dev See {IERC20-approve}.
973      *
974      * Note that accounts cannot have allowance issued by their operators.
975      */
976     function approve(address spender, uint256 value) public returns (bool) {
977         address holder = _msgSender();
978         _approve(holder, spender, value);
979         return true;
980     }
981 
982    /**
983     * @dev See {IERC20-transferFrom}.
984     *
985     * Note that operator and allowance concepts are orthogonal: operators cannot
986     * call `transferFrom` (unless they have allowance), and accounts with
987     * allowance cannot call `operatorSend` (unless they are operators).
988     *
989     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
990     */
991     function transferFrom(address holder, address recipient, uint256 amount) public returns (bool) {
992         require(recipient != address(0), "ERC777: transfer to the zero address");
993         require(holder != address(0), "ERC777: transfer from the zero address");
994 
995         address spender = _msgSender();
996 
997         _callTokensToSend(spender, holder, recipient, amount, "", "");
998 
999         _move(spender, holder, recipient, amount, "", "");
1000         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
1001 
1002         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
1003 
1004         return true;
1005     }
1006 
1007     /**
1008      * @dev Creates `amount` tokens and assigns them to `account`, increasing
1009      * the total supply.
1010      *
1011      * If a send hook is registered for `account`, the corresponding function
1012      * will be called with `operator`, `data` and `operatorData`.
1013      *
1014      * See {IERC777Sender} and {IERC777Recipient}.
1015      *
1016      * Emits {Minted} and {IERC20-Transfer} events.
1017      *
1018      * Requirements
1019      *
1020      * - `account` cannot be the zero address.
1021      * - if `account` is a contract, it must implement the {IERC777Recipient}
1022      * interface.
1023      */
1024     function _mint(
1025         address operator,
1026         address account,
1027         uint256 amount,
1028         bytes memory userData,
1029         bytes memory operatorData
1030     )
1031     internal
1032     {
1033         require(account != address(0), "ERC777: mint to the zero address");
1034 
1035         // Update state variables
1036         _totalSupply = _totalSupply.add(amount);
1037         _balances[account] = _balances[account].add(amount);
1038 
1039         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1040 
1041         emit Minted(operator, account, amount, userData, operatorData);
1042         emit Transfer(address(0), account, amount);
1043     }
1044 
1045     /**
1046      * @dev Send tokens
1047      * @param operator address operator requesting the transfer
1048      * @param from address token holder address
1049      * @param to address recipient address
1050      * @param amount uint256 amount of tokens to transfer
1051      * @param userData bytes extra information provided by the token holder (if any)
1052      * @param operatorData bytes extra information provided by the operator (if any)
1053      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1054      */
1055     function _send(
1056         address operator,
1057         address from,
1058         address to,
1059         uint256 amount,
1060         bytes memory userData,
1061         bytes memory operatorData,
1062         bool requireReceptionAck
1063     )
1064         internal
1065     {
1066         require(operator != address(0), "ERC777: operator is the zero address");
1067         require(from != address(0), "ERC777: send from the zero address");
1068         require(to != address(0), "ERC777: send to the zero address");
1069 
1070         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1071 
1072         _move(operator, from, to, amount, userData, operatorData);
1073 
1074         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1075     }
1076 
1077     /**
1078      * @dev Burn tokens
1079      * @param operator address operator requesting the operation
1080      * @param from address token holder address
1081      * @param amount uint256 amount of tokens to burn
1082      * @param data bytes extra information provided by the token holder
1083      * @param operatorData bytes extra information provided by the operator (if any)
1084      */
1085     function _burn(
1086         address operator,
1087         address from,
1088         uint256 amount,
1089         bytes memory data,
1090         bytes memory operatorData
1091     )
1092         internal
1093     {
1094         require(from != address(0), "ERC777: burn from the zero address");
1095 
1096         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1097 
1098         // Update state variables
1099         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1100         _totalSupply = _totalSupply.sub(amount);
1101 
1102         emit Burned(operator, from, amount, data, operatorData);
1103         emit Transfer(from, address(0), amount);
1104     }
1105 
1106     function _move(
1107         address operator,
1108         address from,
1109         address to,
1110         uint256 amount,
1111         bytes memory userData,
1112         bytes memory operatorData
1113     )
1114         private
1115     {
1116         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1117         _balances[to] = _balances[to].add(amount);
1118 
1119         emit Sent(operator, from, to, amount, userData, operatorData);
1120         emit Transfer(from, to, amount);
1121     }
1122 
1123     /**
1124      * @dev See {ERC20-_approve}.
1125      *
1126      * Note that accounts cannot have allowance issued by their operators.
1127      */
1128     function _approve(address holder, address spender, uint256 value) internal {
1129         require(holder != address(0), "ERC777: approve from the zero address");
1130         require(spender != address(0), "ERC777: approve to the zero address");
1131 
1132         _allowances[holder][spender] = value;
1133         emit Approval(holder, spender, value);
1134     }
1135 
1136     /**
1137      * @dev Call from.tokensToSend() if the interface is registered
1138      * @param operator address operator requesting the transfer
1139      * @param from address token holder address
1140      * @param to address recipient address
1141      * @param amount uint256 amount of tokens to transfer
1142      * @param userData bytes extra information provided by the token holder (if any)
1143      * @param operatorData bytes extra information provided by the operator (if any)
1144      */
1145     function _callTokensToSend(
1146         address operator,
1147         address from,
1148         address to,
1149         uint256 amount,
1150         bytes memory userData,
1151         bytes memory operatorData
1152     )
1153         internal
1154     {
1155         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1156         if (implementer != address(0)) {
1157             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1158         }
1159     }
1160 
1161     /**
1162      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1163      * tokensReceived() was not registered for the recipient
1164      * @param operator address operator requesting the transfer
1165      * @param from address token holder address
1166      * @param to address recipient address
1167      * @param amount uint256 amount of tokens to transfer
1168      * @param userData bytes extra information provided by the token holder (if any)
1169      * @param operatorData bytes extra information provided by the operator (if any)
1170      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1171      */
1172     function _callTokensReceived(
1173         address operator,
1174         address from,
1175         address to,
1176         uint256 amount,
1177         bytes memory userData,
1178         bytes memory operatorData,
1179         bool requireReceptionAck
1180     )
1181         internal
1182     {
1183         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1184         if (implementer != address(0)) {
1185             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1186         } else if (requireReceptionAck) {
1187             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1188         }
1189     }
1190 }
1191 
1192 // File: contracts/AbstractOwnable.sol
1193 
1194 pragma solidity ^0.5.0;
1195 
1196 contract AbstractOwnable {
1197   /**
1198    * @dev Returns the address of the current owner.
1199    */
1200   function owner() internal view returns (address);
1201 
1202   /**
1203    * @dev Throws if called by any account other than the owner.
1204    */
1205   modifier onlyOwner() {
1206     require(isOwner(), "Caller is not the owner");
1207     _;
1208   }
1209 
1210   /**
1211    * @dev Returns true if the caller is the current owner.
1212    */
1213   function isOwner() internal view returns (bool) {
1214     return msg.sender == owner();
1215   }
1216 
1217 }
1218 
1219 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
1220 
1221 pragma solidity ^0.5.0;
1222 
1223 /**
1224  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1225  *
1226  * These functions can be used to verify that a message was signed by the holder
1227  * of the private keys of a given address.
1228  */
1229 library ECDSA {
1230     /**
1231      * @dev Returns the address that signed a hashed message (`hash`) with
1232      * `signature`. This address can then be used for verification purposes.
1233      *
1234      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1235      * this function rejects them by requiring the `s` value to be in the lower
1236      * half order, and the `v` value to be either 27 or 28.
1237      *
1238      * NOTE: This call _does not revert_ if the signature is invalid, or
1239      * if the signer is otherwise unable to be retrieved. In those scenarios,
1240      * the zero address is returned.
1241      *
1242      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1243      * verification to be secure: it is possible to craft signatures that
1244      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1245      * this is by receiving a hash of the original message (which may otherwise
1246      * be too long), and then calling {toEthSignedMessageHash} on it.
1247      */
1248     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1249         // Check the signature length
1250         if (signature.length != 65) {
1251             return (address(0));
1252         }
1253 
1254         // Divide the signature in r, s and v variables
1255         bytes32 r;
1256         bytes32 s;
1257         uint8 v;
1258 
1259         // ecrecover takes the signature parameters, and the only way to get them
1260         // currently is to use assembly.
1261         // solhint-disable-next-line no-inline-assembly
1262         assembly {
1263             r := mload(add(signature, 0x20))
1264             s := mload(add(signature, 0x40))
1265             v := byte(0, mload(add(signature, 0x60)))
1266         }
1267 
1268         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1269         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1270         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1271         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1272         //
1273         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1274         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1275         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1276         // these malleable signatures as well.
1277         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1278             return address(0);
1279         }
1280 
1281         if (v != 27 && v != 28) {
1282             return address(0);
1283         }
1284 
1285         // If the signature is valid (and not malleable), return the signer address
1286         return ecrecover(hash, v, r, s);
1287     }
1288 
1289     /**
1290      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1291      * replicates the behavior of the
1292      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
1293      * JSON-RPC method.
1294      *
1295      * See {recover}.
1296      */
1297     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1298         // 32 is the length in bytes of hash,
1299         // enforced by the type signature above
1300         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1301     }
1302 }
1303 
1304 // File: @openzeppelin/contracts/GSN/IRelayRecipient.sol
1305 
1306 pragma solidity ^0.5.0;
1307 
1308 /**
1309  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
1310  *
1311  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
1312  */
1313 interface IRelayRecipient {
1314     /**
1315      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
1316      */
1317     function getHubAddr() external view returns (address);
1318 
1319     /**
1320      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
1321      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
1322      *
1323      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
1324      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
1325      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
1326      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
1327      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
1328      * over all or some of the previous values.
1329      *
1330      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
1331      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
1332      *
1333      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
1334      * rejected. A regular revert will also trigger a rejection.
1335      */
1336     function acceptRelayedCall(
1337         address relay,
1338         address from,
1339         bytes calldata encodedFunction,
1340         uint256 transactionFee,
1341         uint256 gasPrice,
1342         uint256 gasLimit,
1343         uint256 nonce,
1344         bytes calldata approvalData,
1345         uint256 maxPossibleCharge
1346     )
1347         external
1348         view
1349         returns (uint256, bytes memory);
1350 
1351     /**
1352      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
1353      * pre-charge the sender of the transaction.
1354      *
1355      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
1356      *
1357      * Returns a value to be passed to {postRelayedCall}.
1358      *
1359      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
1360      * will not be executed, but the recipient will still be charged for the transaction's cost.
1361      */
1362     function preRelayedCall(bytes calldata context) external returns (bytes32);
1363 
1364     /**
1365      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
1366      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
1367      * contract-specific bookkeeping.
1368      *
1369      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
1370      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
1371      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
1372      *
1373      *
1374      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
1375      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
1376      * transaction's cost.
1377      */
1378     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
1379 }
1380 
1381 // File: @openzeppelin/contracts/GSN/IRelayHub.sol
1382 
1383 pragma solidity ^0.5.0;
1384 
1385 /**
1386  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
1387  * directly.
1388  *
1389  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
1390  * how to deploy an instance of `RelayHub` on your local test network.
1391  */
1392 interface IRelayHub {
1393     // Relay management
1394 
1395     /**
1396      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
1397      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
1398      * cannot be its own owner.
1399      *
1400      * All Ether in this function call will be added to the relay's stake.
1401      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
1402      *
1403      * Emits a {Staked} event.
1404      */
1405     function stake(address relayaddr, uint256 unstakeDelay) external payable;
1406 
1407     /**
1408      * @dev Emitted when a relay's stake or unstakeDelay are increased
1409      */
1410     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
1411 
1412     /**
1413      * @dev Registers the caller as a relay.
1414      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
1415      *
1416      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
1417      * `transactionFee` is not enforced by {relayCall}.
1418      *
1419      * Emits a {RelayAdded} event.
1420      */
1421     function registerRelay(uint256 transactionFee, string calldata url) external;
1422 
1423     /**
1424      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
1425      * {RelayRemoved} events) lets a client discover the list of available relays.
1426      */
1427     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
1428 
1429     /**
1430      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
1431      *
1432      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
1433      * callable.
1434      *
1435      * Emits a {RelayRemoved} event.
1436      */
1437     function removeRelayByOwner(address relay) external;
1438 
1439     /**
1440      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
1441      */
1442     event RelayRemoved(address indexed relay, uint256 unstakeTime);
1443 
1444     /** Deletes the relay from the system, and gives back its stake to the owner.
1445      *
1446      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
1447      *
1448      * Emits an {Unstaked} event.
1449      */
1450     function unstake(address relay) external;
1451 
1452     /**
1453      * @dev Emitted when a relay is unstaked for, including the returned stake.
1454      */
1455     event Unstaked(address indexed relay, uint256 stake);
1456 
1457     // States a relay can be in
1458     enum RelayState {
1459         Unknown, // The relay is unknown to the system: it has never been staked for
1460         Staked, // The relay has been staked for, but it is not yet active
1461         Registered, // The relay has registered itself, and is active (can relay calls)
1462         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
1463     }
1464 
1465     /**
1466      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
1467      * to return an empty entry.
1468      */
1469     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
1470 
1471     // Balance management
1472 
1473     /**
1474      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
1475      *
1476      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
1477      *
1478      * Emits a {Deposited} event.
1479      */
1480     function depositFor(address target) external payable;
1481 
1482     /**
1483      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
1484      */
1485     event Deposited(address indexed recipient, address indexed from, uint256 amount);
1486 
1487     /**
1488      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
1489      */
1490     function balanceOf(address target) external view returns (uint256);
1491 
1492     /**
1493      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
1494      * contracts can use it to reduce their funding.
1495      *
1496      * Emits a {Withdrawn} event.
1497      */
1498     function withdraw(uint256 amount, address payable dest) external;
1499 
1500     /**
1501      * @dev Emitted when an account withdraws funds from `RelayHub`.
1502      */
1503     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
1504 
1505     // Relaying
1506 
1507     /**
1508      * @dev Checks if the `RelayHub` will accept a relayed operation.
1509      * Multiple things must be true for this to happen:
1510      *  - all arguments must be signed for by the sender (`from`)
1511      *  - the sender's nonce must be the current one
1512      *  - the recipient must accept this transaction (via {acceptRelayedCall})
1513      *
1514      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
1515      * code if it returns one in {acceptRelayedCall}.
1516      */
1517     function canRelay(
1518         address relay,
1519         address from,
1520         address to,
1521         bytes calldata encodedFunction,
1522         uint256 transactionFee,
1523         uint256 gasPrice,
1524         uint256 gasLimit,
1525         uint256 nonce,
1526         bytes calldata signature,
1527         bytes calldata approvalData
1528     ) external view returns (uint256 status, bytes memory recipientContext);
1529 
1530     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
1531     enum PreconditionCheck {
1532         OK,                         // All checks passed, the call can be relayed
1533         WrongSignature,             // The transaction to relay is not signed by requested sender
1534         WrongNonce,                 // The provided nonce has already been used by the sender
1535         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
1536         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
1537     }
1538 
1539     /**
1540      * @dev Relays a transaction.
1541      *
1542      * For this to succeed, multiple conditions must be met:
1543      *  - {canRelay} must `return PreconditionCheck.OK`
1544      *  - the sender must be a registered relay
1545      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
1546      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
1547      * recipient) use all gas available to them
1548      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
1549      * spent)
1550      *
1551      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
1552      * function and {postRelayedCall} will be called in that order.
1553      *
1554      * Parameters:
1555      *  - `from`: the client originating the request
1556      *  - `to`: the target {IRelayRecipient} contract
1557      *  - `encodedFunction`: the function call to relay, including data
1558      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
1559      *  - `gasPrice`: gas price the client is willing to pay
1560      *  - `gasLimit`: gas to forward when calling the encoded function
1561      *  - `nonce`: client's nonce
1562      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
1563      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
1564      * `RelayHub`, but it still can be used for e.g. a signature.
1565      *
1566      * Emits a {TransactionRelayed} event.
1567      */
1568     function relayCall(
1569         address from,
1570         address to,
1571         bytes calldata encodedFunction,
1572         uint256 transactionFee,
1573         uint256 gasPrice,
1574         uint256 gasLimit,
1575         uint256 nonce,
1576         bytes calldata signature,
1577         bytes calldata approvalData
1578     ) external;
1579 
1580     /**
1581      * @dev Emitted when an attempt to relay a call failed.
1582      *
1583      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
1584      * actual relayed call was not executed, and the recipient not charged.
1585      *
1586      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
1587      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
1588      */
1589     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
1590 
1591     /**
1592      * @dev Emitted when a transaction is relayed.
1593      * Useful when monitoring a relay's operation and relayed calls to a contract
1594      *
1595      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
1596      *
1597      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
1598      */
1599     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
1600 
1601     // Reason error codes for the TransactionRelayed event
1602     enum RelayCallStatus {
1603         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
1604         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
1605         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
1606         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
1607         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
1608     }
1609 
1610     /**
1611      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
1612      * spend up to `relayedCallStipend` gas.
1613      */
1614     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
1615 
1616     /**
1617      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
1618      */
1619     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
1620 
1621      // Relay penalization.
1622      // Any account can penalize relays, removing them from the system immediately, and rewarding the
1623     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
1624     // still loses half of its stake.
1625 
1626     /**
1627      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
1628      * different data (gas price, gas limit, etc. may be different).
1629      *
1630      * The (unsigned) transaction data and signature for both transactions must be provided.
1631      */
1632     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
1633 
1634     /**
1635      * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
1636      */
1637     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
1638 
1639     /**
1640      * @dev Emitted when a relay is penalized.
1641      */
1642     event Penalized(address indexed relay, address sender, uint256 amount);
1643 
1644     /**
1645      * @dev Returns an account's nonce in `RelayHub`.
1646      */
1647     function getNonce(address from) external view returns (uint256);
1648 }
1649 
1650 // File: @openzeppelin/contracts/GSN/GSNRecipient.sol
1651 
1652 pragma solidity ^0.5.0;
1653 
1654 
1655 
1656 
1657 /**
1658  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
1659  * and enables GSN support on all contracts in the inheritance tree.
1660  *
1661  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
1662  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
1663  * provided by derived contracts. See the
1664  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
1665  * information on how to use the pre-built {GSNRecipientSignature} and
1666  * {GSNRecipientERC20Fee}, or how to write your own.
1667  */
1668 contract GSNRecipient is IRelayRecipient, Context {
1669     // Default RelayHub address, deployed on mainnet and all testnets at the same address
1670     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
1671 
1672     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
1673     uint256 constant private RELAYED_CALL_REJECTED = 11;
1674 
1675     // How much gas is forwarded to postRelayedCall
1676     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
1677 
1678     /**
1679      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
1680      */
1681     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
1682 
1683     /**
1684      * @dev Returns the address of the {IRelayHub} contract for this recipient.
1685      */
1686     function getHubAddr() public view returns (address) {
1687         return _relayHub;
1688     }
1689 
1690     /**
1691      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
1692      * use the default instance.
1693      *
1694      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
1695      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
1696      */
1697     function _upgradeRelayHub(address newRelayHub) internal {
1698         address currentRelayHub = _relayHub;
1699         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
1700         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
1701 
1702         emit RelayHubChanged(currentRelayHub, newRelayHub);
1703 
1704         _relayHub = newRelayHub;
1705     }
1706 
1707     /**
1708      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
1709      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
1710      */
1711     // This function is view for future-proofing, it may require reading from
1712     // storage in the future.
1713     function relayHubVersion() public view returns (string memory) {
1714         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1715         return "1.0.0";
1716     }
1717 
1718     /**
1719      * @dev Withdraws the recipient's deposits in `RelayHub`.
1720      *
1721      * Derived contracts should expose this in an external interface with proper access control.
1722      */
1723     function _withdrawDeposits(uint256 amount, address payable payee) internal {
1724         IRelayHub(_relayHub).withdraw(amount, payee);
1725     }
1726 
1727     // Overrides for Context's functions: when called from RelayHub, sender and
1728     // data require some pre-processing: the actual sender is stored at the end
1729     // of the call data, which in turns means it needs to be removed from it
1730     // when handling said data.
1731 
1732     /**
1733      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
1734      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
1735      *
1736      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
1737      */
1738     function _msgSender() internal view returns (address payable) {
1739         if (msg.sender != _relayHub) {
1740             return msg.sender;
1741         } else {
1742             return _getRelayedCallSender();
1743         }
1744     }
1745 
1746     /**
1747      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1748      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
1749      *
1750      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1751      */
1752     function _msgData() internal view returns (bytes memory) {
1753         if (msg.sender != _relayHub) {
1754             return msg.data;
1755         } else {
1756             return _getRelayedCallData();
1757         }
1758     }
1759 
1760     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
1761     // internal hook.
1762 
1763     /**
1764      * @dev See `IRelayRecipient.preRelayedCall`.
1765      *
1766      * This function should not be overriden directly, use `_preRelayedCall` instead.
1767      *
1768      * * Requirements:
1769      *
1770      * - the caller must be the `RelayHub` contract.
1771      */
1772     function preRelayedCall(bytes calldata context) external returns (bytes32) {
1773         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1774         return _preRelayedCall(context);
1775     }
1776 
1777     /**
1778      * @dev See `IRelayRecipient.preRelayedCall`.
1779      *
1780      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1781      * must implement this function with any relayed-call preprocessing they may wish to do.
1782      *
1783      */
1784     function _preRelayedCall(bytes memory context) internal returns (bytes32);
1785 
1786     /**
1787      * @dev See `IRelayRecipient.postRelayedCall`.
1788      *
1789      * This function should not be overriden directly, use `_postRelayedCall` instead.
1790      *
1791      * * Requirements:
1792      *
1793      * - the caller must be the `RelayHub` contract.
1794      */
1795     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
1796         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1797         _postRelayedCall(context, success, actualCharge, preRetVal);
1798     }
1799 
1800     /**
1801      * @dev See `IRelayRecipient.postRelayedCall`.
1802      *
1803      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1804      * must implement this function with any relayed-call postprocessing they may wish to do.
1805      *
1806      */
1807     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
1808 
1809     /**
1810      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
1811      * will be charged a fee by RelayHub
1812      */
1813     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
1814         return _approveRelayedCall("");
1815     }
1816 
1817     /**
1818      * @dev See `GSNRecipient._approveRelayedCall`.
1819      *
1820      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
1821      */
1822     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
1823         return (RELAYED_CALL_ACCEPTED, context);
1824     }
1825 
1826     /**
1827      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
1828      */
1829     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
1830         return (RELAYED_CALL_REJECTED + errorCode, "");
1831     }
1832 
1833     /*
1834      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
1835      * `serviceFee`.
1836      */
1837     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
1838         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
1839         // charged for 1.4 times the spent amount.
1840         return (gas * gasPrice * (100 + serviceFee)) / 100;
1841     }
1842 
1843     function _getRelayedCallSender() private pure returns (address payable result) {
1844         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
1845         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
1846         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
1847         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
1848         // bytes. This can always be done due to the 32-byte prefix.
1849 
1850         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
1851         // easiest/most-efficient way to perform this operation.
1852 
1853         // These fields are not accessible from assembly
1854         bytes memory array = msg.data;
1855         uint256 index = msg.data.length;
1856 
1857         // solhint-disable-next-line no-inline-assembly
1858         assembly {
1859             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1860             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1861         }
1862         return result;
1863     }
1864 
1865     function _getRelayedCallData() private pure returns (bytes memory) {
1866         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
1867         // we must strip the last 20 bytes (length of an address type) from it.
1868 
1869         uint256 actualDataLength = msg.data.length - 20;
1870         bytes memory actualData = new bytes(actualDataLength);
1871 
1872         for (uint256 i = 0; i < actualDataLength; ++i) {
1873             actualData[i] = msg.data[i];
1874         }
1875 
1876         return actualData;
1877     }
1878 }
1879 
1880 // File: contracts/ERC777GSN.sol
1881 
1882 pragma solidity ^0.5.0;
1883 
1884 
1885 
1886 
1887 
1888 contract ERC777GSN is AbstractOwnable, GSNRecipient, ERC777 {
1889   using ECDSA for bytes32;
1890   uint256 constant GSN_RATE_UNIT = 10**18;
1891 
1892   enum GSNErrorCodes {
1893     INVALID_SIGNER,
1894     INSUFFICIENT_BALANCE
1895   }
1896 
1897   address public gsnTrustedSigner;
1898   address public gsnFeeTarget;
1899   uint256 public gsnExtraGas = 40000; // the gas cost of _postRelayedCall()
1900 
1901   constructor(
1902     address _gsnTrustedSigner,
1903     address _gsnFeeTarget
1904   )
1905     public
1906   {
1907     require(_gsnTrustedSigner != address(0), "trusted signer is the zero address");
1908     gsnTrustedSigner = _gsnTrustedSigner;
1909     require(_gsnFeeTarget != address(0), "fee target is the zero address");
1910     gsnFeeTarget = _gsnFeeTarget;
1911   }
1912 
1913   function _msgSender() internal view returns (address payable) {
1914     return GSNRecipient._msgSender();
1915   }
1916 
1917   function _msgData() internal view returns (bytes memory) {
1918     return GSNRecipient._msgData();
1919   }
1920 
1921 
1922   function setTrustedSigner(address _gsnTrustedSigner) public onlyOwner {
1923     require(_gsnTrustedSigner != address(0), "trusted signer is the zero address");
1924     gsnTrustedSigner = _gsnTrustedSigner;
1925   }
1926 
1927   function setFeeTarget(address _gsnFeeTarget) public onlyOwner {
1928     require(_gsnFeeTarget != address(0), "fee target is the zero address");
1929     gsnFeeTarget = _gsnFeeTarget;
1930   }
1931 
1932   function setGSNExtraGas(uint _gsnExtraGas) public onlyOwner {
1933     gsnExtraGas = _gsnExtraGas;
1934   }
1935 
1936 
1937   /**
1938  * @dev Ensures that only transactions with a trusted signature can be relayed through the GSN.
1939  */
1940   function acceptRelayedCall(
1941     address relay,
1942     address from,
1943     bytes memory encodedFunction,
1944     uint256 transactionFee,
1945     uint256 gasPrice,
1946     uint256 gasLimit,
1947     uint256 nonce,
1948     bytes memory approvalData,
1949     uint256 /* maxPossibleCharge */
1950   )
1951     public
1952     view
1953     returns (uint256, bytes memory)
1954   {
1955     (uint256 feeRate, bytes memory signature) = abi.decode(approvalData, (uint, bytes));
1956     bytes memory blob = abi.encodePacked(
1957       feeRate,
1958       relay,
1959       from,
1960       encodedFunction,
1961       transactionFee,
1962       gasPrice,
1963       gasLimit,
1964       nonce, // Prevents replays on RelayHub
1965       getHubAddr(), // Prevents replays in multiple RelayHubs
1966       address(this) // Prevents replays in multiple recipients
1967     );
1968     if (keccak256(blob).toEthSignedMessageHash().recover(signature) == gsnTrustedSigner) {
1969       return _approveRelayedCall(abi.encode(feeRate, from, transactionFee, gasPrice));
1970     } else {
1971       return _rejectRelayedCall(uint256(GSNErrorCodes.INVALID_SIGNER));
1972     }
1973   }
1974 
1975   function _preRelayedCall(bytes memory context) internal returns (bytes32) {}
1976 
1977   function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
1978     (uint256 feeRate, address from, uint256 transactionFee, uint256 gasPrice) =
1979       abi.decode(context, (uint256, address, uint256, uint256));
1980 
1981     // actualCharge is an _estimated_ charge, which assumes postRelayedCall will use all available gas.
1982     // This implementation's gas cost can be roughly estimated as 10k gas, for the two SSTORE operations in an
1983     // ERC20 transfer.
1984     uint256 overestimation = _computeCharge(POST_RELAYED_CALL_MAX_GAS.sub(gsnExtraGas), gasPrice, transactionFee);
1985     uint fee = actualCharge.sub(overestimation).mul(feeRate).div(GSN_RATE_UNIT);
1986 
1987     if (fee > 0) {
1988       _send(_msgSender(), from, gsnFeeTarget, fee, "", "", false);
1989     }
1990   }
1991 }
1992 
1993 // File: contracts/ERC777WithAdminOperator.sol
1994 
1995 pragma solidity ^0.5.0;
1996 
1997 
1998 contract ERC777WithAdminOperator is ERC777 {
1999 
2000   address public adminOperator;
2001 
2002   event AdminOperatorChange(address oldOperator, address newOperator);
2003   event AdminTransferInvoked(address operator);
2004 
2005   constructor(address _adminOperator) public {
2006     adminOperator = _adminOperator;
2007   }
2008 
2009   /**
2010  * @dev Similar to {IERC777-operatorSend}.
2011  *
2012  * Emits {Sent} and {IERC20-Transfer} events.
2013  */
2014   function adminTransfer(
2015     address sender,
2016     address recipient,
2017     uint256 amount,
2018     bytes memory data,
2019     bytes memory operatorData
2020   )
2021   public
2022   {
2023     require(_msgSender() == adminOperator, "caller is not the admin operator");
2024     _send(adminOperator, sender, recipient, amount, data, operatorData, false);
2025     emit AdminTransferInvoked(adminOperator);
2026   }
2027 
2028   /**
2029    * @dev Only the actual admin operator can change the address
2030    */
2031   function setAdminOperator(address adminOperator_) public {
2032     require(msg.sender == adminOperator, "Only the actual admin operator can change the address");
2033     emit AdminOperatorChange(adminOperator, adminOperator_);
2034     adminOperator = adminOperator_;
2035   }
2036 
2037 
2038 }
2039 
2040 // File: contracts/ERC777OptionalAckOnMint.sol
2041 
2042 pragma solidity ^0.5.0;
2043 
2044 
2045 contract ERC777OptionalAckOnMint is ERC777 {
2046   bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
2047     0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
2048 
2049   /**
2050  * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
2051  * tokensReceived() was not registered for the recipient
2052  * @param operator address operator requesting the transfer
2053  * @param from address token holder address
2054  * @param to address recipient address
2055  * @param amount uint256 amount of tokens to transfer
2056  * @param userData bytes extra information provided by the token holder (if any)
2057  * @param operatorData bytes extra information provided by the operator (if any)
2058  * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
2059  */
2060   function _callTokensReceived(
2061     address operator,
2062     address from,
2063     address to,
2064     uint256 amount,
2065     bytes memory userData,
2066     bytes memory operatorData,
2067     bool requireReceptionAck
2068   )
2069     internal
2070   {
2071     address implementer = ERC1820_REGISTRY.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
2072     if (implementer != address(0)) {
2073       IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
2074     } else if (requireReceptionAck && from != address(0)) {
2075       require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
2076     }
2077   }
2078 }
2079 
2080 // File: contracts/pToken.sol
2081 
2082 pragma solidity ^0.5.0;
2083 
2084 
2085 
2086 
2087 
2088 
2089 contract PToken is
2090     AbstractOwnable,
2091     ERC777,
2092     ERC777OptionalAckOnMint,
2093     ERC777GSN,
2094     ERC777WithAdminOperator
2095 {
2096 
2097     address public pNetwork;
2098 
2099     event Redeem(
2100         address indexed redeemer,
2101         uint256 value,
2102         string underlyingAssetRecipient
2103     );
2104 
2105     constructor(
2106         string memory tokenName,
2107         string memory tokenSymbol,
2108         address[] memory defaultOperators
2109     )
2110         ERC777(tokenName, tokenSymbol, defaultOperators)
2111         ERC777GSN(msg.sender, msg.sender)
2112         ERC777WithAdminOperator(msg.sender)
2113         public
2114     {
2115         pNetwork = _msgSender();
2116     }
2117 
2118     function owner() internal view returns (address) {
2119         return pNetwork;
2120     }
2121 
2122     function changePNetwork(
2123         address newPNetwork
2124     )
2125         external
2126     {
2127         require(
2128             _msgSender() == pNetwork,
2129             "Only the pNetwork can change the `pNetwork` account!"
2130         );
2131         require(
2132             newPNetwork != address(0),
2133             "pNetwork cannot be the zero address!"
2134         );
2135         pNetwork = newPNetwork;
2136     }
2137 
2138     function mint(
2139         address recipient,
2140         uint256 value
2141     )
2142         external
2143         returns (bool)
2144     {
2145         mint(recipient, value, "", "");
2146         return true;
2147     }
2148 
2149     function mint(
2150         address recipient,
2151         uint256 value,
2152         bytes memory userData,
2153         bytes memory operatorData
2154     )
2155         public
2156         returns (bool)
2157     {
2158         require(
2159             _msgSender() == pNetwork,
2160             "Only the pNetwork can mint tokens!"
2161         );
2162         require(
2163             recipient != address(0),
2164             "pToken: Cannot mint to the zero address!"
2165         );
2166         _mint(pNetwork, recipient, value, userData, operatorData);
2167         return true;
2168     }
2169 
2170     function redeem(
2171         uint256 amount,
2172         string calldata underlyingAssetRecipient
2173     )
2174         external
2175         returns (bool)
2176     {
2177         redeem(amount, "", underlyingAssetRecipient);
2178         return true;
2179     }
2180 
2181     function redeem(
2182         uint256 amount,
2183         bytes memory data,
2184         string memory underlyingAssetRecipient
2185     )
2186         public
2187     {
2188         _burn(_msgSender(), _msgSender(), amount, data, "");
2189         emit Redeem(msg.sender, amount, underlyingAssetRecipient);
2190     }
2191 
2192     function operatorRedeem(
2193         address account,
2194         uint256 amount,
2195         bytes calldata data,
2196         bytes calldata operatorData,
2197         string calldata underlyingAssetRecipient
2198     )
2199         external
2200     {
2201         require(
2202             isOperatorFor(_msgSender(), account),
2203             "ERC777: caller is not an operator for holder"
2204         );
2205         _burn(_msgSender(), account, amount, data, operatorData);
2206         emit Redeem(account, amount, underlyingAssetRecipient);
2207     }
2208 }