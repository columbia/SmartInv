1 // File: patterns\GSN\Context.sol
2 
3 pragma solidity 0.5.0;
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
31 // File: patterns\token\ERC777\IERC777.sol
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
218 // File: patterns\token\ERC777\IERC777Recipient.sol
219 
220 /**
221  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
222  *
223  * Accounts can be notified of {IERC777} tokens being sent to them by having a
224  * contract implement this interface (contract holders can be their own
225  * implementer) and registering it on the
226  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
227  *
228  * See {IERC1820Registry} and {ERC1820Implementer}.
229  */
230 interface IERC777Recipient {
231     /**
232      * @dev Called by an {IERC777} token contract whenever tokens are being
233      * moved or created into a registered account (`to`). The type of operation
234      * is conveyed by `from` being the zero address or not.
235      *
236      * This call occurs _after_ the token contract's state is updated, so
237      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
238      *
239      * This function may revert to prevent the operation from being executed.
240      */
241     function tokensReceived(
242         address operator,
243         address from,
244         address to,
245         uint256 amount,
246         bytes calldata userData,
247         bytes calldata operatorData
248     ) external;
249 }
250 
251 // File: patterns\token\ERC777\IERC777Sender.sol
252 
253 /**
254  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
255  *
256  * {IERC777} Token holders can be notified of operations performed on their
257  * tokens by having a contract implement this interface (contract holders can be
258  *  their own implementer) and registering it on the
259  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
260  *
261  * See {IERC1820Registry} and {ERC1820Implementer}.
262  */
263 interface IERC777Sender {
264     /**
265      * @dev Called by an {IERC777} token contract whenever a registered holder's
266      * (`from`) tokens are about to be moved or destroyed. The type of operation
267      * is conveyed by `to` being the zero address or not.
268      *
269      * This call occurs _before_ the token contract's state is updated, so
270      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
271      *
272      * This function may revert to prevent the operation from being executed.
273      */
274     function tokensToSend(
275         address operator,
276         address from,
277         address to,
278         uint256 amount,
279         bytes calldata userData,
280         bytes calldata operatorData
281     ) external;
282 }
283 
284 // File: patterns\token\ERC20\IERC20.sol
285 
286 /**
287  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
288  * the optional functions; to access them see {ERC20Detailed}.
289  */
290 interface IERC20 {
291     /**
292      * @dev Returns the amount of tokens in existence.
293      */
294     function totalSupply() external view returns (uint256);
295 
296     /**
297      * @dev Returns the amount of tokens owned by `account`.
298      */
299     function balanceOf(address account) external view returns (uint256);
300 
301     /**
302      * @dev Moves `amount` tokens from the caller's account to `recipient`.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transfer(address recipient, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Returns the remaining number of tokens that `spender` will be
312      * allowed to spend on behalf of `owner` through {transferFrom}. This is
313      * zero by default.
314      *
315      * This value changes when {approve} or {transferFrom} are called.
316      */
317     function allowance(address owner, address spender) external view returns (uint256);
318 
319     /**
320      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * IMPORTANT: Beware that changing an allowance with this method brings the risk
325      * that someone may use both the old and the new allowance by unfortunate
326      * transaction ordering. One possible solution to mitigate this race
327      * condition is to first reduce the spender's allowance to 0 and set the
328      * desired value afterwards:
329      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
330      *
331      * Emits an {Approval} event.
332      */
333     function approve(address spender, uint256 amount) external returns (bool);
334 
335     /**
336      * @dev Moves `amount` tokens from `sender` to `recipient` using the
337      * allowance mechanism. `amount` is then deducted from the caller's
338      * allowance.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * Emits a {Transfer} event.
343      */
344     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
345 
346     /**
347      * @dev Emitted when `value` tokens are moved from one account (`from`) to
348      * another (`to`).
349      *
350      * Note that `value` may be zero.
351      */
352     event Transfer(address indexed from, address indexed to, uint256 value);
353 
354     /**
355      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
356      * a call to {approve}. `value` is the new allowance.
357      */
358     event Approval(address indexed owner, address indexed spender, uint256 value);
359 }
360 
361 // File: patterns\math\SafeMath.sol
362 
363 /**
364  * @dev Wrappers over Solidity's arithmetic operations with added overflow
365  * checks.
366  *
367  * Arithmetic operations in Solidity wrap on overflow. This can easily result
368  * in bugs, because programmers usually assume that an overflow raises an
369  * error, which is the standard behavior in high level programming languages.
370  * `SafeMath` restores this intuition by reverting the transaction when an
371  * operation overflows.
372  *
373  * Using this library instead of the unchecked operations eliminates an entire
374  * class of bugs, so it's recommended to use it always.
375  */
376 library SafeMath {
377     /**
378      * @dev Returns the addition of two unsigned integers, reverting on
379      * overflow.
380      *
381      * Counterpart to Solidity's `+` operator.
382      *
383      * Requirements:
384      * - Addition cannot overflow.
385      */
386     function add(uint256 a, uint256 b) internal pure returns (uint256) {
387         uint256 c = a + b;
388         require(c >= a, "SafeMath: addition overflow");
389 
390         return c;
391     }
392 
393     /**
394      * @dev Returns the subtraction of two unsigned integers, reverting on
395      * overflow (when the result is negative).
396      *
397      * Counterpart to Solidity's `-` operator.
398      *
399      * Requirements:
400      * - Subtraction cannot overflow.
401      */
402     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
403         return sub(a, b, "SafeMath: subtraction overflow");
404     }
405 
406     /**
407      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
408      * overflow (when the result is negative).
409      *
410      * Counterpart to Solidity's `-` operator.
411      *
412      * Requirements:
413      * - Subtraction cannot overflow.
414      *
415      * _Available since v2.4.0._
416      */
417     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
418         require(b <= a, errorMessage);
419         uint256 c = a - b;
420 
421         return c;
422     }
423 
424     /**
425      * @dev Returns the multiplication of two unsigned integers, reverting on
426      * overflow.
427      *
428      * Counterpart to Solidity's `*` operator.
429      *
430      * Requirements:
431      * - Multiplication cannot overflow.
432      */
433     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
434         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
435         // benefit is lost if 'b' is also tested.
436         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
437         if (a == 0) {
438             return 0;
439         }
440 
441         uint256 c = a * b;
442         require(c / a == b, "SafeMath: multiplication overflow");
443 
444         return c;
445     }
446 
447     /**
448      * @dev Returns the integer division of two unsigned integers. Reverts on
449      * division by zero. The result is rounded towards zero.
450      *
451      * Counterpart to Solidity's `/` operator. Note: this function uses a
452      * `revert` opcode (which leaves remaining gas untouched) while Solidity
453      * uses an invalid opcode to revert (consuming all remaining gas).
454      *
455      * Requirements:
456      * - The divisor cannot be zero.
457      */
458     function div(uint256 a, uint256 b) internal pure returns (uint256) {
459         return div(a, b, "SafeMath: division by zero");
460     }
461 
462     /**
463      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
464      * division by zero. The result is rounded towards zero.
465      *
466      * Counterpart to Solidity's `/` operator. Note: this function uses a
467      * `revert` opcode (which leaves remaining gas untouched) while Solidity
468      * uses an invalid opcode to revert (consuming all remaining gas).
469      *
470      * Requirements:
471      * - The divisor cannot be zero.
472      *
473      * _Available since v2.4.0._
474      */
475     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
476         // Solidity only automatically asserts when dividing by 0
477         require(b > 0, errorMessage);
478         uint256 c = a / b;
479         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
480 
481         return c;
482     }
483 
484     /**
485      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
486      * Reverts when dividing by zero.
487      *
488      * Counterpart to Solidity's `%` operator. This function uses a `revert`
489      * opcode (which leaves remaining gas untouched) while Solidity uses an
490      * invalid opcode to revert (consuming all remaining gas).
491      *
492      * Requirements:
493      * - The divisor cannot be zero.
494      */
495     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
496         return mod(a, b, "SafeMath: modulo by zero");
497     }
498 
499     /**
500      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
501      * Reverts with custom message when dividing by zero.
502      *
503      * Counterpart to Solidity's `%` operator. This function uses a `revert`
504      * opcode (which leaves remaining gas untouched) while Solidity uses an
505      * invalid opcode to revert (consuming all remaining gas).
506      *
507      * Requirements:
508      * - The divisor cannot be zero.
509      *
510      * _Available since v2.4.0._
511      */
512     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b != 0, errorMessage);
514         return a % b;
515     }
516 }
517 
518 // File: patterns\utils\Address.sol
519 
520 /**
521  * @dev Collection of functions related to the address type
522  */
523 library Address {
524     /**
525      * @dev Returns true if `account` is a contract.
526      *
527      * This test is non-exhaustive, and there may be false-negatives: during the
528      * execution of a contract's constructor, its address will be reported as
529      * not containing a contract.
530      *
531      * IMPORTANT: It is unsafe to assume that an address for which this
532      * function returns false is an externally-owned account (EOA) and not a
533      * contract.
534      */
535     function isContract(address account) internal view returns (bool) {
536         // This method relies in extcodesize, which returns 0 for contracts in
537         // construction, since the code is only stored at the end of the
538         // constructor execution.
539 
540         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
541         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
542         // for accounts without code, i.e. `keccak256('')`
543         bytes32 codehash;
544         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
545         // solhint-disable-next-line no-inline-assembly
546         assembly { codehash := extcodehash(account) }
547         return (codehash != 0x0 && codehash != accountHash);
548     }
549 
550     /**
551      * @dev Converts an `address` into `address payable`. Note that this is
552      * simply a type cast: the actual underlying value is not changed.
553      *
554      * _Available since v2.4.0._
555      */
556     function toPayable(address account) internal pure returns (address payable) {
557         return address(uint160(account));
558     }
559 
560     /**
561      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
562      * `recipient`, forwarding all available gas and reverting on errors.
563      *
564      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
565      * of certain opcodes, possibly making contracts go over the 2300 gas limit
566      * imposed by `transfer`, making them unable to receive funds via
567      * `transfer`. {sendValue} removes this limitation.
568      *
569      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
570      *
571      * IMPORTANT: because control is transferred to `recipient`, care must be
572      * taken to not create reentrancy vulnerabilities. Consider using
573      * {ReentrancyGuard} or the
574      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
575      *
576      * _Available since v2.4.0._
577      */
578     function sendValue(address payable recipient, uint256 amount) internal {
579         require(address(this).balance >= amount, "Address: insufficient balance");
580 
581         // solhint-disable-next-line avoid-call-value
582         (bool success, ) = recipient.call.value(amount)("");
583         require(success, "Address: unable to send value, recipient may have reverted");
584     }
585 }
586 
587 // File: patterns\introspection\IERC1820Registry.sol
588 
589 /**
590  * @dev Interface of the global ERC1820 Registry, as defined in the
591  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
592  * implementers for interfaces in this registry, as well as query support.
593  *
594  * Implementers may be shared by multiple accounts, and can also implement more
595  * than a single interface for each account. Contracts can implement interfaces
596  * for themselves, but externally-owned accounts (EOA) must delegate this to a
597  * contract.
598  *
599  * {IERC165} interfaces can also be queried via the registry.
600  *
601  * For an in-depth explanation and source code analysis, see the EIP text.
602  */
603 interface IERC1820Registry {
604     /**
605      * @dev Sets `newManager` as the manager for `account`. A manager of an
606      * account is able to set interface implementers for it.
607      *
608      * By default, each account is its own manager. Passing a value of `0x0` in
609      * `newManager` will reset the manager to this initial state.
610      *
611      * Emits a {ManagerChanged} event.
612      *
613      * Requirements:
614      *
615      * - the caller must be the current manager for `account`.
616      */
617     function setManager(address account, address newManager) external;
618 
619     /**
620      * @dev Returns the manager for `account`.
621      *
622      * See {setManager}.
623      */
624     function getManager(address account) external view returns (address);
625 
626     /**
627      * @dev Sets the `implementer` contract as `account`'s implementer for
628      * `interfaceHash`.
629      *
630      * `account` being the zero address is an alias for the caller's address.
631      * The zero address can also be used in `implementer` to remove an old one.
632      *
633      * See {interfaceHash} to learn how these are created.
634      *
635      * Emits an {InterfaceImplementerSet} event.
636      *
637      * Requirements:
638      *
639      * - the caller must be the current manager for `account`.
640      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
641      * end in 28 zeroes).
642      * - `implementer` must implement {IERC1820Implementer} and return true when
643      * queried for support, unless `implementer` is the caller. See
644      * {IERC1820Implementer-canImplementInterfaceForAddress}.
645      */
646     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
647 
648     /**
649      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
650      * implementer is registered, returns the zero address.
651      *
652      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
653      * zeroes), `account` will be queried for support of it.
654      *
655      * `account` being the zero address is an alias for the caller's address.
656      */
657     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
658 
659     /**
660      * @dev Returns the interface hash for an `interfaceName`, as defined in the
661      * corresponding
662      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
663      */
664     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
665 
666     /**
667      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
668      *  @param account Address of the contract for which to update the cache.
669      *  @param interfaceId ERC165 interface for which to update the cache.
670      */
671     function updateERC165Cache(address account, bytes4 interfaceId) external;
672 
673     /**
674      *  @notice Checks whether a contract implements an ERC165 interface or not.
675      *  If the result is not cached a direct lookup on the contract address is performed.
676      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
677      *  {updateERC165Cache} with the contract address.
678      *  @param account Address of the contract to check.
679      *  @param interfaceId ERC165 interface to check.
680      *  @return True if `account` implements `interfaceId`, false otherwise.
681      */
682     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
683 
684     /**
685      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
686      *  @param account Address of the contract to check.
687      *  @param interfaceId ERC165 interface to check.
688      *  @return True if `account` implements `interfaceId`, false otherwise.
689      */
690     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
691 
692     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
693 
694     event ManagerChanged(address indexed account, address indexed newManager);
695 }
696 
697 // File: patterns\token\ERC777\ERC777.sol
698 
699 /**
700  * @dev Implementation of the {IERC777} interface.
701  *
702  * This implementation is agnostic to the way tokens are created. This means
703  * that a supply mechanism has to be added in a derived contract using {_mint}.
704  *
705  * Support for ERC20 is included in this contract, as specified by the EIP: both
706  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
707  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
708  * movements.
709  *
710  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
711  * are no special restrictions in the amount of tokens that created, moved, or
712  * destroyed. This makes integration with ERC20 applications seamless.
713  */
714 contract ERC777 is Context, IERC777, IERC20 {
715     using SafeMath for uint256;
716     using Address for address;
717 
718     IERC1820Registry constant internal _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
719 
720     mapping(address => uint256) private _balances;
721 
722     uint256 private _totalSupply;
723 
724     string private _name;
725     string private _symbol;
726 
727     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
728     // See https://github.com/ethereum/solidity/issues/4024.
729 
730     // keccak256("ERC777TokensSender")
731     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
732         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
733 
734     // keccak256("ERC777TokensRecipient")
735     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
736         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
737 
738     // This isn't ever read from - it's only used to respond to the defaultOperators query.
739     address[] private _defaultOperatorsArray;
740 
741     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
742     mapping(address => bool) private _defaultOperators;
743 
744     // For each account, a mapping of its operators and revoked default operators.
745     mapping(address => mapping(address => bool)) private _operators;
746     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
747 
748     // ERC20-allowances
749     mapping (address => mapping (address => uint256)) private _allowances;
750 
751     /**
752      * @dev `defaultOperators` may be an empty array.
753      */
754     constructor(
755         string memory name,
756         string memory symbol,
757         address[] memory defaultOperators
758     ) public {
759         _name = name;
760         _symbol = symbol;
761 
762         _defaultOperatorsArray = defaultOperators;
763         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
764             _defaultOperators[_defaultOperatorsArray[i]] = true;
765         }
766 
767         // register interfaces
768         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
769         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
770     }
771 
772     /**
773      * @dev See {IERC777-name}.
774      */
775     function name() public view returns (string memory) {
776         return _name;
777     }
778 
779     /**
780      * @dev See {IERC777-symbol}.
781      */
782     function symbol() public view returns (string memory) {
783         return _symbol;
784     }
785 
786     /**
787      * @dev See {ERC20Detailed-decimals}.
788      *
789      * Always returns 18, as per the
790      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
791      */
792     function decimals() public pure returns (uint8) {
793         return 18;
794     }
795 
796     /**
797      * @dev See {IERC777-granularity}.
798      *
799      * This implementation always returns `1`.
800      */
801     function granularity() public view returns (uint256) {
802         return 1;
803     }
804 
805     /**
806      * @dev See {IERC777-totalSupply}.
807      */
808     function totalSupply() public view returns (uint256) {
809         return _totalSupply;
810     }
811 
812     /**
813      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
814      */
815     function balanceOf(address tokenHolder) public view returns (uint256) {
816         return _balances[tokenHolder];
817     }
818 
819     /**
820      * @dev See {IERC777-send}.
821      *
822      * Also emits a {Transfer} event for ERC20 compatibility.
823      */
824     function send(address recipient, uint256 amount, bytes calldata data) external {
825         _send(_msgSender(), _msgSender(), recipient, amount, data, "", true);
826     }
827 
828     /**
829      * @dev See {IERC20-transfer}.
830      *
831      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
832      * interface if it is a contract.
833      *
834      * Also emits a {Sent} event.
835      */
836     function transfer(address recipient, uint256 amount) external returns (bool) {
837         require(recipient != address(0), "ERC777: transfer to the zero address");
838 
839         address from = _msgSender();
840 
841         _callTokensToSend(from, from, recipient, amount, "", "");
842 
843         _move(from, from, recipient, amount, "", "");
844 
845         _callTokensReceived(from, from, recipient, amount, "", "", false);
846 
847         return true;
848     }
849 
850     /**
851      * @dev See {IERC777-burn}.
852      *
853      * Also emits a {Transfer} event for ERC20 compatibility.
854      */
855     function burn(uint256 amount, bytes calldata data) external {
856         _burn(_msgSender(), _msgSender(), amount, data, "");
857     }
858 
859     /**
860      * @dev See {IERC777-isOperatorFor}.
861      */
862     function isOperatorFor(
863         address operator,
864         address tokenHolder
865     ) public view returns (bool) {
866         return operator == tokenHolder ||
867             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
868             _operators[tokenHolder][operator];
869     }
870 
871     /**
872      * @dev See {IERC777-authorizeOperator}.
873      */
874     function authorizeOperator(address operator) external {
875         _authorizeOperator(operator);
876     }
877 
878     function _authorizeOperator(address operator) internal {
879         require(_msgSender() != operator, "ERC777: authorizing self as operator");
880 
881         if (_defaultOperators[operator]) {
882             delete _revokedDefaultOperators[_msgSender()][operator];
883         } else {
884             _operators[_msgSender()][operator] = true;
885         }
886 
887         emit AuthorizedOperator(operator, _msgSender());
888     }
889 
890     /**
891      * @dev See {IERC777-revokeOperator}.
892      */
893     function revokeOperator(address operator) external {
894         _revokeOperator(operator);
895     }
896 
897     function _revokeOperator(address operator) internal {
898         require(operator != _msgSender(), "ERC777: revoking self as operator");
899 
900         if (_defaultOperators[operator]) {
901             _revokedDefaultOperators[_msgSender()][operator] = true;
902         } else {
903             delete _operators[_msgSender()][operator];
904         }
905 
906         emit RevokedOperator(operator, _msgSender());
907     }
908 
909     /**
910      * @dev See {IERC777-defaultOperators}.
911      */
912     function defaultOperators() public view returns (address[] memory) {
913         return _defaultOperatorsArray;
914     }
915 
916     /**
917      * @dev See {IERC777-operatorSend}.
918      *
919      * Emits {Sent} and {Transfer} events.
920      */
921     function operatorSend(
922         address sender,
923         address recipient,
924         uint256 amount,
925         bytes calldata data,
926         bytes calldata operatorData
927     )
928     external
929     {
930         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
931         _send(_msgSender(), sender, recipient, amount, data, operatorData, true);
932     }
933 
934     /**
935      * @dev See {IERC777-operatorBurn}.
936      *
937      * Emits {Burned} and {Transfer} events.
938      */
939     function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData) external {
940         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
941         _burn(_msgSender(), account, amount, data, operatorData);
942     }
943 
944     /**
945      * @dev See {IERC20-allowance}.
946      *
947      * Note that operator and allowance concepts are orthogonal: operators may
948      * not have allowance, and accounts with allowance may not be operators
949      * themselves.
950      */
951     function allowance(address holder, address spender) public view returns (uint256) {
952         return _allowances[holder][spender];
953     }
954 
955     /**
956      * @dev See {IERC20-approve}.
957      *
958      * Note that accounts cannot have allowance issued by their operators.
959      */
960     function approve(address spender, uint256 value) external returns (bool) {
961         address holder = _msgSender();
962         _approve(holder, spender, value);
963         return true;
964     }
965 
966    /**
967     * @dev See {IERC20-transferFrom}.
968     *
969     * Note that operator and allowance concepts are orthogonal: operators cannot
970     * call `transferFrom` (unless they have allowance), and accounts with
971     * allowance cannot call `operatorSend` (unless they are operators).
972     *
973     * Emits {Sent}, {Transfer} and {Approval} events.
974     */
975     function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) {
976         require(recipient != address(0), "ERC777: transfer to the zero address");
977         require(holder != address(0), "ERC777: transfer from the zero address");
978 
979         address spender = _msgSender();
980 
981         _callTokensToSend(spender, holder, recipient, amount, "", "");
982 
983         _move(spender, holder, recipient, amount, "", "");
984         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
985 
986         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
987 
988         return true;
989     }
990 
991     /**
992      * @dev Creates `amount` tokens and assigns them to `account`, increasing
993      * the total supply.
994      *
995      * If a send hook is registered for `account`, the corresponding function
996      * will be called with `operator`, `data` and `operatorData`.
997      *
998      * See {IERC777Sender} and {IERC777Recipient}.
999      *
1000      * Emits {Minted} and {Transfer} events.
1001      *
1002      * Requirements
1003      *
1004      * - `account` cannot be the zero address.
1005      * - if `account` is a contract, it must implement the {IERC777Recipient}
1006      * interface.
1007      */
1008     function _mint(
1009         address operator,
1010         address account,
1011         uint256 amount,
1012         bytes memory userData,
1013         bytes memory operatorData
1014     )
1015     internal
1016     {
1017         require(account != address(0), "ERC777: mint to the zero address");
1018 
1019         // Update state variables
1020         _totalSupply = _totalSupply.add(amount);
1021         _balances[account] = _balances[account].add(amount);
1022 
1023         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1024 
1025         emit Minted(operator, account, amount, userData, operatorData);
1026         emit Transfer(address(0), account, amount);
1027     }
1028 
1029     /**
1030      * @dev Send tokens
1031      * @param operator address operator requesting the transfer
1032      * @param from address token holder address
1033      * @param to address recipient address
1034      * @param amount uint256 amount of tokens to transfer
1035      * @param userData bytes extra information provided by the token holder (if any)
1036      * @param operatorData bytes extra information provided by the operator (if any)
1037      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1038      */
1039     function _send(
1040         address operator,
1041         address from,
1042         address to,
1043         uint256 amount,
1044         bytes memory userData,
1045         bytes memory operatorData,
1046         bool requireReceptionAck
1047     )
1048         internal
1049     {
1050         require(from != address(0), "ERC777: send from the zero address");
1051         require(to != address(0), "ERC777: send to the zero address");
1052 
1053         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1054 
1055         _move(operator, from, to, amount, userData, operatorData);
1056 
1057         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1058     }
1059 
1060     /**
1061      * @dev Burn tokens
1062      * @param operator address operator requesting the operation
1063      * @param from address token holder address
1064      * @param amount uint256 amount of tokens to burn
1065      * @param data bytes extra information provided by the token holder
1066      * @param operatorData bytes extra information provided by the operator (if any)
1067      */
1068     function _burn(
1069         address operator,
1070         address from,
1071         uint256 amount,
1072         bytes memory data,
1073         bytes memory operatorData
1074     )
1075         internal
1076     {
1077         require(from != address(0), "ERC777: burn from the zero address");
1078 
1079         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1080 
1081         // Update state variables
1082         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1083         _totalSupply = _totalSupply.sub(amount);
1084 
1085         emit Burned(operator, from, amount, data, operatorData);
1086         emit Transfer(from, address(0), amount);
1087     }
1088 
1089     function _move(
1090         address operator,
1091         address from,
1092         address to,
1093         uint256 amount,
1094         bytes memory userData,
1095         bytes memory operatorData
1096     )
1097         internal
1098     {
1099         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1100         _balances[to] = _balances[to].add(amount);
1101 
1102         emit Sent(operator, from, to, amount, userData, operatorData);
1103         emit Transfer(from, to, amount);
1104     }
1105 
1106     function _approve(address holder, address spender, uint256 value) internal {
1107         // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
1108         // currently unnecessary.
1109         //require(holder != address(0), "ERC777: approve from the zero address");
1110         require(spender != address(0), "ERC777: approve to the zero address");
1111 
1112         _allowances[holder][spender] = value;
1113         emit Approval(holder, spender, value);
1114     }
1115 
1116     /**
1117      * @dev Call from.tokensToSend() if the interface is registered
1118      * @param operator address operator requesting the transfer
1119      * @param from address token holder address
1120      * @param to address recipient address
1121      * @param amount uint256 amount of tokens to transfer
1122      * @param userData bytes extra information provided by the token holder (if any)
1123      * @param operatorData bytes extra information provided by the operator (if any)
1124      */
1125     function _callTokensToSend(
1126         address operator,
1127         address from,
1128         address to,
1129         uint256 amount,
1130         bytes memory userData,
1131         bytes memory operatorData
1132     )
1133         private
1134     {
1135         address implementer = _erc1820.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1136         if (implementer != address(0)) {
1137             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1138         }
1139     }
1140 
1141     /**
1142      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1143      * tokensReceived() was not registered for the recipient
1144      * @param operator address operator requesting the transfer
1145      * @param from address token holder address
1146      * @param to address recipient address
1147      * @param amount uint256 amount of tokens to transfer
1148      * @param userData bytes extra information provided by the token holder (if any)
1149      * @param operatorData bytes extra information provided by the operator (if any)
1150      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1151      */
1152     function _callTokensReceived(
1153         address operator,
1154         address from,
1155         address to,
1156         uint256 amount,
1157         bytes memory userData,
1158         bytes memory operatorData,
1159         bool requireReceptionAck
1160     )
1161         private
1162     {
1163         address implementer = _erc1820.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1164         if (implementer != address(0)) {
1165             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1166         } else if (requireReceptionAck) {
1167             require(!to.isContract(), "ERC777: token recipient contract has no implement for ERC777TokensRecipient");
1168         }
1169     }
1170 }
1171 
1172 // File: patterns\access\Roles.sol
1173 
1174 /**
1175  * @title Roles
1176  * @dev Library for managing addresses assigned to a Role.
1177  */
1178 library Roles {
1179     struct Role {
1180         mapping (address => bool) bearer;
1181     }
1182 
1183     /**
1184      * @dev Give an account access to this role.
1185      */
1186     function add(Role storage role, address account) internal {
1187         require(!has(role, account), "Roles: account already has role");
1188         role.bearer[account] = true;
1189     }
1190 
1191     /**
1192      * @dev Remove an account's access to this role.
1193      */
1194     function remove(Role storage role, address account) internal {
1195         require(has(role, account), "Roles: account does not have role");
1196         role.bearer[account] = false;
1197     }
1198 
1199     /**
1200      * @dev Check if an account has this role.
1201      * @return bool
1202      */
1203     function has(Role storage role, address account) internal view returns (bool) {
1204         require(account != address(0), "Roles: account is the zero address");
1205         return role.bearer[account];
1206     }
1207 }
1208 
1209 // File: patterns\access\roles\MinterRole.sol
1210 
1211 contract MinterRole is Context {
1212     using Roles for Roles.Role;
1213 
1214     event MinterAdded(address indexed account);
1215     event MinterRemoved(address indexed account);
1216 
1217     Roles.Role private _minters;
1218 
1219     constructor () internal {
1220         _addMinter(_msgSender());
1221     }
1222 
1223     modifier onlyMinter() {
1224         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1225         _;
1226     }
1227 
1228     function isMinter(address account) public view returns (bool) {
1229         return _minters.has(account);
1230     }
1231 
1232     function addMinter(address account) public onlyMinter {
1233         _addMinter(account);
1234     }
1235 
1236     function renounceMinter() public {
1237         _removeMinter(_msgSender());
1238     }
1239 
1240     function _addMinter(address account) internal {
1241         _minters.add(account);
1242         emit MinterAdded(account);
1243     }
1244 
1245     function _removeMinter(address account) internal {
1246         _minters.remove(account);
1247         emit MinterRemoved(account);
1248     }
1249 }
1250 
1251 // File: patterns\token\ERC777\ERC777Mintable.sol
1252 
1253 /**
1254  * @dev Extension of {ERC777} that adds a set of accounts with the {MinterRole},
1255  * which have permission to mint (create) new tokens as they see fit.
1256  *
1257  * At construction, the deployer of the contract is the only minter.
1258  */
1259 contract ERC777Mintable is ERC777, MinterRole {
1260     /**
1261      * @dev See {ERC777-_mint}.
1262      *
1263      * Requirements:
1264      *
1265      * - the caller must have the {MinterRole}.
1266      */
1267     function mint(address account, uint256 amount, bytes calldata data) external onlyMinter {
1268         super._mint(_msgSender(), account, amount, data, "");
1269     }
1270 }
1271 
1272 // File: patterns\access\roles\PauserRole.sol
1273 
1274 contract PauserRole is Context {
1275     using Roles for Roles.Role;
1276 
1277     event PauserAdded(address indexed account);
1278     event PauserRemoved(address indexed account);
1279 
1280     Roles.Role private _pausers;
1281 
1282     constructor () internal {
1283         _addPauser(_msgSender());
1284     }
1285 
1286     modifier onlyPauser() {
1287         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
1288         _;
1289     }
1290 
1291     function isPauser(address account) public view returns (bool) {
1292         return _pausers.has(account);
1293     }
1294 
1295     function addPauser(address account) public onlyPauser {
1296         _addPauser(account);
1297     }
1298 
1299     function renouncePauser() public {
1300         _removePauser(_msgSender());
1301     }
1302 
1303     function _addPauser(address account) internal {
1304         _pausers.add(account);
1305         emit PauserAdded(account);
1306     }
1307 
1308     function _removePauser(address account) internal {
1309         _pausers.remove(account);
1310         emit PauserRemoved(account);
1311     }
1312 }
1313 
1314 // File: patterns\lifecycle\Pausable.sol
1315 
1316 /**
1317  * @dev Contract module which allows children to implement an emergency stop
1318  * mechanism that can be triggered by an authorized account.
1319  *
1320  * This module is used through inheritance. It will make available the
1321  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1322  * the functions of your contract. Note that they will not be pausable by
1323  * simply including this module, only once the modifiers are put in place.
1324  */
1325 contract Pausable is Context, PauserRole {
1326     /**
1327      * @dev Emitted when the pause is triggered by a pauser (`account`).
1328      */
1329     event Paused(address account);
1330 
1331     /**
1332      * @dev Emitted when the pause is lifted by a pauser (`account`).
1333      */
1334     event Unpaused(address account);
1335 
1336     bool private _paused;
1337 
1338     /**
1339      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1340      * to the deployer.
1341      */
1342     constructor () internal {
1343         _paused = false;
1344     }
1345 
1346     /**
1347      * @dev Returns true if the contract is paused, and false otherwise.
1348      */
1349     function paused() public view returns (bool) {
1350         return _paused;
1351     }
1352 
1353     /**
1354      * @dev Modifier to make a function callable only when the contract is not paused.
1355      */
1356     modifier whenNotPaused() {
1357         require(!_paused, "Pausable: paused");
1358         _;
1359     }
1360 
1361     /**
1362      * @dev Modifier to make a function callable only when the contract is paused.
1363      */
1364     modifier whenPaused() {
1365         require(_paused, "Pausable: not paused");
1366         _;
1367     }
1368 
1369     /**
1370      * @dev Called by a pauser to pause, triggers stopped state.
1371      */
1372     function pause() public onlyPauser whenNotPaused {
1373         _paused = true;
1374         emit Paused(_msgSender());
1375     }
1376 
1377     /**
1378      * @dev Called by a pauser to unpause, returns to normal state.
1379      */
1380     function unpause() public onlyPauser whenPaused {
1381         _paused = false;
1382         emit Unpaused(_msgSender());
1383     }
1384 }
1385 
1386 // File: patterns\token\ERC777\ERC777Pausable.sol
1387 
1388 /**
1389  * @title Pausable token
1390  * @dev ERC777 with pausable operations.
1391  *
1392  * Useful if you want to stop trades until the end of a crowdsale, or have
1393  * an emergency switch for freezing all token transfers in the event of a large
1394  * bug.
1395  */
1396 contract ERC777Pausable is ERC777, Pausable {
1397     function _move(
1398         address operator,
1399         address from,
1400         address to,
1401         uint256 amount,
1402         bytes memory userData,
1403         bytes memory operatorData
1404     )
1405         internal whenNotPaused
1406     {
1407         return super._move(operator, from, to, amount, userData, operatorData);
1408     }
1409 
1410     function _approve(address holder, address spender, uint256 value) internal whenNotPaused {
1411         super._approve(holder, spender, value);
1412     }
1413 
1414     function _send(
1415         address operator,
1416         address from,
1417         address to,
1418         uint256 amount,
1419         bytes memory userData,
1420         bytes memory operatorData,
1421         bool requireReceptionAck
1422     )
1423         internal whenNotPaused
1424     {
1425         super._send(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1426     }
1427 
1428     function _mint(
1429         address operator,
1430         address account,
1431         uint256 amount,
1432         bytes memory userData,
1433         bytes memory operatorData
1434     )
1435         internal whenNotPaused
1436     {
1437         super._mint(operator, account, amount, userData, operatorData);
1438     }
1439 
1440     function _burn(
1441         address operator,
1442         address from,
1443         uint256 amount,
1444         bytes memory data,
1445         bytes memory operatorData
1446     )
1447         internal whenNotPaused
1448     {
1449         super._burn(operator, from, amount, data, operatorData);
1450     }
1451 
1452     function _authorizeOperator(address operator) internal whenNotPaused {
1453         super._authorizeOperator(operator);
1454     }
1455 
1456     function _revokeOperator(address operator) internal whenNotPaused {
1457         super._revokeOperator(operator);
1458     }
1459 }
1460 
1461 // File: patterns\token\ERC777\ERC777WithFee.sol
1462 
1463 /**
1464  * @title Token with fee
1465  * @dev ERC777 with fee operations.
1466  *
1467  * Useful if you want to charge a fee for each transaction, burning commission tokens.
1468  */
1469 contract ERC777WithFee is ERC777 {
1470     uint16 constant private _fee = 250;
1471     uint256 constant private _feeDecimals = 6;
1472     uint256 constant private _feeGrowthPeriod = 5000000 * 1 ether;
1473     
1474     function _move(
1475         address operator,
1476         address from,
1477         address to,
1478         uint256 amount,
1479         bytes memory userData,
1480         bytes memory operatorData
1481     )
1482         internal
1483     {
1484         uint256 fee = _calculateFee(amount);
1485         uint256 new_amount = amount.sub(fee, "ERC777: fee amount exceeds balance");
1486         super._burn(operator, from, fee, userData, operatorData);
1487         super._move(operator, from, to, new_amount, userData, operatorData);
1488     }
1489 
1490     function _calculateFee(uint256 amount) internal view returns (uint256)
1491     {
1492         return amount.mul(_fee).mul(this.totalSupply().div(_feeGrowthPeriod)).div(10 ** _feeDecimals);
1493     }
1494 }
1495 
1496 // File: contracts\NNCProjectToken.sol
1497 
1498 contract NNCProjectToken is
1499     ERC777WithFee,
1500     ERC777Pausable,
1501     ERC777Mintable,
1502     IERC777Recipient,
1503     IERC777Sender {
1504   constructor (
1505     string memory name,
1506     string memory symbol,
1507     address[] memory defaultOperators,
1508     uint256 totalSupply
1509   ) ERC777(name, symbol, defaultOperators) public {
1510     _mint(_msgSender(), _msgSender(), totalSupply, "Init mint", "");
1511     _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777TokensRecipient"), address(this));
1512     _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777TokensSender"), address(this));
1513   }
1514 
1515   function tokensReceived(
1516     address operator,
1517     address from,
1518     address to,
1519     uint256 amount,
1520     bytes calldata userData,
1521     bytes calldata operatorData
1522   ) external {
1523     revert("Tokens cannot be accepted");
1524   }
1525 
1526   function tokensToSend(
1527     address operator,
1528     address from,
1529     address to,
1530     uint256 amount,
1531     bytes calldata userData,
1532     bytes calldata operatorData
1533   ) external {
1534     revert("Tokens cannot be sended");
1535   }
1536 
1537   function () external payable {
1538     revert("Not payable contract");
1539   }
1540 }