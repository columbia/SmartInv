1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-02
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-07-29
7 */
8 
9 // File: @openzeppelin/contracts/GSN/Context.sol
10 
11 pragma solidity ^0.5.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 contract Context {
24     // Empty internal constructor, to prevent people from mistakenly deploying
25     // an instance of this contract, which should be used via inheritance.
26     constructor () internal { }
27     // solhint-disable-previous-line no-empty-blocks
28 
29     function _msgSender() internal view returns (address payable) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view returns (bytes memory) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 // File: @openzeppelin/contracts/token/ERC777/IERC777.sol
40 
41 pragma solidity ^0.5.0;
42 
43 /**
44  * @dev Interface of the ERC777Token standard as defined in the EIP.
45  *
46  * This contract uses the
47  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
48  * token holders and recipients react to token movements by using setting implementers
49  * for the associated interfaces in said registry. See {IERC1820Registry} and
50  * {ERC1820Implementer}.
51  */
52 interface IERC777 {
53     /**
54      * @dev Returns the name of the token.
55      */
56     function name() external view returns (string memory);
57 
58     /**
59      * @dev Returns the symbol of the token, usually a shorter version of the
60      * name.
61      */
62     function symbol() external view returns (string memory);
63 
64     /**
65      * @dev Returns the smallest part of the token that is not divisible. This
66      * means all token operations (creation, movement and destruction) must have
67      * amounts that are a multiple of this number.
68      *
69      * For most token contracts, this value will equal 1.
70      */
71     function granularity() external view returns (uint256);
72 
73     /**
74      * @dev Returns the amount of tokens in existence.
75      */
76     function totalSupply() external view returns (uint256);
77 
78     /**
79      * @dev Returns the amount of tokens owned by an account (`owner`).
80      */
81     function balanceOf(address owner) external view returns (uint256);
82 
83     /**
84      * @dev Moves `amount` tokens from the caller's account to `recipient`.
85      *
86      * If send or receive hooks are registered for the caller and `recipient`,
87      * the corresponding functions will be called with `data` and empty
88      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
89      *
90      * Emits a {Sent} event.
91      *
92      * Requirements
93      *
94      * - the caller must have at least `amount` tokens.
95      * - `recipient` cannot be the zero address.
96      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
97      * interface.
98      */
99     function send(address recipient, uint256 amount, bytes calldata data) external;
100 
101     /**
102      * @dev Destroys `amount` tokens from the caller's account, reducing the
103      * total supply.
104      *
105      * If a send hook is registered for the caller, the corresponding function
106      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
107      *
108      * Emits a {Burned} event.
109      *
110      * Requirements
111      *
112      * - the caller must have at least `amount` tokens.
113      */
114     function burn(uint256 amount, bytes calldata data) external;
115 
116     /**
117      * @dev Returns true if an account is an operator of `tokenHolder`.
118      * Operators can send and burn tokens on behalf of their owners. All
119      * accounts are their own operator.
120      *
121      * See {operatorSend} and {operatorBurn}.
122      */
123     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
124 
125     /**
126      * @dev Make an account an operator of the caller.
127      *
128      * See {isOperatorFor}.
129      *
130      * Emits an {AuthorizedOperator} event.
131      *
132      * Requirements
133      *
134      * - `operator` cannot be calling address.
135      */
136     function authorizeOperator(address operator) external;
137 
138     /**
139      * @dev Make an account an operator of the caller.
140      *
141      * See {isOperatorFor} and {defaultOperators}.
142      *
143      * Emits a {RevokedOperator} event.
144      *
145      * Requirements
146      *
147      * - `operator` cannot be calling address.
148      */
149     function revokeOperator(address operator) external;
150 
151     /**
152      * @dev Returns the list of default operators. These accounts are operators
153      * for all token holders, even if {authorizeOperator} was never called on
154      * them.
155      *
156      * This list is immutable, but individual holders may revoke these via
157      * {revokeOperator}, in which case {isOperatorFor} will return false.
158      */
159     function defaultOperators() external view returns (address[] memory);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
163      * be an operator of `sender`.
164      *
165      * If send or receive hooks are registered for `sender` and `recipient`,
166      * the corresponding functions will be called with `data` and
167      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
168      *
169      * Emits a {Sent} event.
170      *
171      * Requirements
172      *
173      * - `sender` cannot be the zero address.
174      * - `sender` must have at least `amount` tokens.
175      * - the caller must be an operator for `sender`.
176      * - `recipient` cannot be the zero address.
177      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
178      * interface.
179      */
180     function operatorSend(
181         address sender,
182         address recipient,
183         uint256 amount,
184         bytes calldata data,
185         bytes calldata operatorData
186     ) external;
187 
188     /**
189      * @dev Destoys `amount` tokens from `account`, reducing the total supply.
190      * The caller must be an operator of `account`.
191      *
192      * If a send hook is registered for `account`, the corresponding function
193      * will be called with `data` and `operatorData`. See {IERC777Sender}.
194      *
195      * Emits a {Burned} event.
196      *
197      * Requirements
198      *
199      * - `account` cannot be the zero address.
200      * - `account` must have at least `amount` tokens.
201      * - the caller must be an operator for `account`.
202      */
203     function operatorBurn(
204         address account,
205         uint256 amount,
206         bytes calldata data,
207         bytes calldata operatorData
208     ) external;
209 
210     event Sent(
211         address indexed operator,
212         address indexed from,
213         address indexed to,
214         uint256 amount,
215         bytes data,
216         bytes operatorData
217     );
218 
219     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
220 
221     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
222 
223     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
224 
225     event RevokedOperator(address indexed operator, address indexed tokenHolder);
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol
229 
230 pragma solidity ^0.5.0;
231 
232 /**
233  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
234  *
235  * Accounts can be notified of {IERC777} tokens being sent to them by having a
236  * contract implement this interface (contract holders can be their own
237  * implementer) and registering it on the
238  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
239  *
240  * See {IERC1820Registry} and {ERC1820Implementer}.
241  */
242 interface IERC777Recipient {
243     /**
244      * @dev Called by an {IERC777} token contract whenever tokens are being
245      * moved or created into a registered account (`to`). The type of operation
246      * is conveyed by `from` being the zero address or not.
247      *
248      * This call occurs _after_ the token contract's state is updated, so
249      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
250      *
251      * This function may revert to prevent the operation from being executed.
252      */
253     function tokensReceived(
254         address operator,
255         address from,
256         address to,
257         uint256 amount,
258         bytes calldata userData,
259         bytes calldata operatorData
260     ) external;
261 }
262 
263 // File: @openzeppelin/contracts/token/ERC777/IERC777Sender.sol
264 
265 pragma solidity ^0.5.0;
266 
267 /**
268  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
269  *
270  * {IERC777} Token holders can be notified of operations performed on their
271  * tokens by having a contract implement this interface (contract holders can be
272  *  their own implementer) and registering it on the
273  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
274  *
275  * See {IERC1820Registry} and {ERC1820Implementer}.
276  */
277 interface IERC777Sender {
278     /**
279      * @dev Called by an {IERC777} token contract whenever a registered holder's
280      * (`from`) tokens are about to be moved or destroyed. The type of operation
281      * is conveyed by `to` being the zero address or not.
282      *
283      * This call occurs _before_ the token contract's state is updated, so
284      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
285      *
286      * This function may revert to prevent the operation from being executed.
287      */
288     function tokensToSend(
289         address operator,
290         address from,
291         address to,
292         uint256 amount,
293         bytes calldata userData,
294         bytes calldata operatorData
295     ) external;
296 }
297 
298 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
299 
300 pragma solidity ^0.5.0;
301 
302 /**
303  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
304  * the optional functions; to access them see {ERC20Detailed}.
305  */
306 interface IERC20 {
307     /**
308      * @dev Returns the amount of tokens in existence.
309      */
310     function totalSupply() external view returns (uint256);
311 
312     /**
313      * @dev Returns the amount of tokens owned by `account`.
314      */
315     function balanceOf(address account) external view returns (uint256);
316 
317     /**
318      * @dev Moves `amount` tokens from the caller's account to `recipient`.
319      *
320      * Returns a boolean value indicating whether the operation succeeded.
321      *
322      * Emits a {Transfer} event.
323      */
324     function transfer(address recipient, uint256 amount) external returns (bool);
325 
326     /**
327      * @dev Returns the remaining number of tokens that `spender` will be
328      * allowed to spend on behalf of `owner` through {transferFrom}. This is
329      * zero by default.
330      *
331      * This value changes when {approve} or {transferFrom} are called.
332      */
333     function allowance(address owner, address spender) external view returns (uint256);
334 
335     /**
336      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
337      *
338      * Returns a boolean value indicating whether the operation succeeded.
339      *
340      * IMPORTANT: Beware that changing an allowance with this method brings the risk
341      * that someone may use both the old and the new allowance by unfortunate
342      * transaction ordering. One possible solution to mitigate this race
343      * condition is to first reduce the spender's allowance to 0 and set the
344      * desired value afterwards:
345      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
346      *
347      * Emits an {Approval} event.
348      */
349     function approve(address spender, uint256 amount) external returns (bool);
350 
351     /**
352      * @dev Moves `amount` tokens from `sender` to `recipient` using the
353      * allowance mechanism. `amount` is then deducted from the caller's
354      * allowance.
355      *
356      * Returns a boolean value indicating whether the operation succeeded.
357      *
358      * Emits a {Transfer} event.
359      */
360     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
361 
362     /**
363      * @dev Emitted when `value` tokens are moved from one account (`from`) to
364      * another (`to`).
365      *
366      * Note that `value` may be zero.
367      */
368     event Transfer(address indexed from, address indexed to, uint256 value);
369 
370     /**
371      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
372      * a call to {approve}. `value` is the new allowance.
373      */
374     event Approval(address indexed owner, address indexed spender, uint256 value);
375 }
376 
377 // File: @openzeppelin/contracts/math/SafeMath.sol
378 
379 pragma solidity ^0.5.0;
380 
381 /**
382  * @dev Wrappers over Solidity's arithmetic operations with added overflow
383  * checks.
384  *
385  * Arithmetic operations in Solidity wrap on overflow. This can easily result
386  * in bugs, because programmers usually assume that an overflow raises an
387  * error, which is the standard behavior in high level programming languages.
388  * `SafeMath` restores this intuition by reverting the transaction when an
389  * operation overflows.
390  *
391  * Using this library instead of the unchecked operations eliminates an entire
392  * class of bugs, so it's recommended to use it always.
393  */
394 library SafeMath {
395     /**
396      * @dev Returns the addition of two unsigned integers, reverting on
397      * overflow.
398      *
399      * Counterpart to Solidity's `+` operator.
400      *
401      * Requirements:
402      * - Addition cannot overflow.
403      */
404     function add(uint256 a, uint256 b) internal pure returns (uint256) {
405         uint256 c = a + b;
406         require(c >= a, "SafeMath: addition overflow");
407 
408         return c;
409     }
410 
411     /**
412      * @dev Returns the subtraction of two unsigned integers, reverting on
413      * overflow (when the result is negative).
414      *
415      * Counterpart to Solidity's `-` operator.
416      *
417      * Requirements:
418      * - Subtraction cannot overflow.
419      */
420     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
421         return sub(a, b, "SafeMath: subtraction overflow");
422     }
423 
424     /**
425      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
426      * overflow (when the result is negative).
427      *
428      * Counterpart to Solidity's `-` operator.
429      *
430      * Requirements:
431      * - Subtraction cannot overflow.
432      *
433      * _Available since v2.4.0._
434      */
435     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
436         require(b <= a, errorMessage);
437         uint256 c = a - b;
438 
439         return c;
440     }
441 
442     /**
443      * @dev Returns the multiplication of two unsigned integers, reverting on
444      * overflow.
445      *
446      * Counterpart to Solidity's `*` operator.
447      *
448      * Requirements:
449      * - Multiplication cannot overflow.
450      */
451     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
452         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
453         // benefit is lost if 'b' is also tested.
454         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
455         if (a == 0) {
456             return 0;
457         }
458 
459         uint256 c = a * b;
460         require(c / a == b, "SafeMath: multiplication overflow");
461 
462         return c;
463     }
464 
465     /**
466      * @dev Returns the integer division of two unsigned integers. Reverts on
467      * division by zero. The result is rounded towards zero.
468      *
469      * Counterpart to Solidity's `/` operator. Note: this function uses a
470      * `revert` opcode (which leaves remaining gas untouched) while Solidity
471      * uses an invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      * - The divisor cannot be zero.
475      */
476     function div(uint256 a, uint256 b) internal pure returns (uint256) {
477         return div(a, b, "SafeMath: division by zero");
478     }
479 
480     /**
481      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
482      * division by zero. The result is rounded towards zero.
483      *
484      * Counterpart to Solidity's `/` operator. Note: this function uses a
485      * `revert` opcode (which leaves remaining gas untouched) while Solidity
486      * uses an invalid opcode to revert (consuming all remaining gas).
487      *
488      * Requirements:
489      * - The divisor cannot be zero.
490      *
491      * _Available since v2.4.0._
492      */
493     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
494         // Solidity only automatically asserts when dividing by 0
495         require(b > 0, errorMessage);
496         uint256 c = a / b;
497         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
498 
499         return c;
500     }
501 
502     /**
503      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
504      * Reverts when dividing by zero.
505      *
506      * Counterpart to Solidity's `%` operator. This function uses a `revert`
507      * opcode (which leaves remaining gas untouched) while Solidity uses an
508      * invalid opcode to revert (consuming all remaining gas).
509      *
510      * Requirements:
511      * - The divisor cannot be zero.
512      */
513     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
514         return mod(a, b, "SafeMath: modulo by zero");
515     }
516 
517     /**
518      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
519      * Reverts with custom message when dividing by zero.
520      *
521      * Counterpart to Solidity's `%` operator. This function uses a `revert`
522      * opcode (which leaves remaining gas untouched) while Solidity uses an
523      * invalid opcode to revert (consuming all remaining gas).
524      *
525      * Requirements:
526      * - The divisor cannot be zero.
527      *
528      * _Available since v2.4.0._
529      */
530     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
531         require(b != 0, errorMessage);
532         return a % b;
533     }
534 }
535 
536 // File: @openzeppelin/contracts/utils/Address.sol
537 
538 pragma solidity ^0.5.5;
539 
540 /**
541  * @dev Collection of functions related to the address type
542  */
543 library Address {
544     /**
545      * @dev Returns true if `account` is a contract.
546      *
547      * [IMPORTANT]
548      * ====
549      * It is unsafe to assume that an address for which this function returns
550      * false is an externally-owned account (EOA) and not a contract.
551      *
552      * Among others, `isContract` will return false for the following 
553      * types of addresses:
554      *
555      *  - an externally-owned account
556      *  - a contract in construction
557      *  - an address where a contract will be created
558      *  - an address where a contract lived, but was destroyed
559      * ====
560      */
561     function isContract(address account) internal view returns (bool) {
562         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
563         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
564         // for accounts without code, i.e. `keccak256('')`
565         bytes32 codehash;
566         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
567         // solhint-disable-next-line no-inline-assembly
568         assembly { codehash := extcodehash(account) }
569         return (codehash != accountHash && codehash != 0x0);
570     }
571 
572     /**
573      * @dev Converts an `address` into `address payable`. Note that this is
574      * simply a type cast: the actual underlying value is not changed.
575      *
576      * _Available since v2.4.0._
577      */
578     function toPayable(address account) internal pure returns (address payable) {
579         return address(uint160(account));
580     }
581 
582     /**
583      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
584      * `recipient`, forwarding all available gas and reverting on errors.
585      *
586      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
587      * of certain opcodes, possibly making contracts go over the 2300 gas limit
588      * imposed by `transfer`, making them unable to receive funds via
589      * `transfer`. {sendValue} removes this limitation.
590      *
591      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
592      *
593      * IMPORTANT: because control is transferred to `recipient`, care must be
594      * taken to not create reentrancy vulnerabilities. Consider using
595      * {ReentrancyGuard} or the
596      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
597      *
598      * _Available since v2.4.0._
599      */
600     function sendValue(address payable recipient, uint256 amount) internal {
601         require(address(this).balance >= amount, "Address: insufficient balance");
602 
603         // solhint-disable-next-line avoid-call-value
604         (bool success, ) = recipient.call.value(amount)("");
605         require(success, "Address: unable to send value, recipient may have reverted");
606     }
607 }
608 
609 // File: @openzeppelin/contracts/introspection/IERC1820Registry.sol
610 
611 pragma solidity ^0.5.0;
612 
613 /**
614  * @dev Interface of the global ERC1820 Registry, as defined in the
615  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
616  * implementers for interfaces in this registry, as well as query support.
617  *
618  * Implementers may be shared by multiple accounts, and can also implement more
619  * than a single interface for each account. Contracts can implement interfaces
620  * for themselves, but externally-owned accounts (EOA) must delegate this to a
621  * contract.
622  *
623  * {IERC165} interfaces can also be queried via the registry.
624  *
625  * For an in-depth explanation and source code analysis, see the EIP text.
626  */
627 interface IERC1820Registry {
628     /**
629      * @dev Sets `newManager` as the manager for `account`. A manager of an
630      * account is able to set interface implementers for it.
631      *
632      * By default, each account is its own manager. Passing a value of `0x0` in
633      * `newManager` will reset the manager to this initial state.
634      *
635      * Emits a {ManagerChanged} event.
636      *
637      * Requirements:
638      *
639      * - the caller must be the current manager for `account`.
640      */
641     function setManager(address account, address newManager) external;
642 
643     /**
644      * @dev Returns the manager for `account`.
645      *
646      * See {setManager}.
647      */
648     function getManager(address account) external view returns (address);
649 
650     /**
651      * @dev Sets the `implementer` contract as `account`'s implementer for
652      * `interfaceHash`.
653      *
654      * `account` being the zero address is an alias for the caller's address.
655      * The zero address can also be used in `implementer` to remove an old one.
656      *
657      * See {interfaceHash} to learn how these are created.
658      *
659      * Emits an {InterfaceImplementerSet} event.
660      *
661      * Requirements:
662      *
663      * - the caller must be the current manager for `account`.
664      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
665      * end in 28 zeroes).
666      * - `implementer` must implement {IERC1820Implementer} and return true when
667      * queried for support, unless `implementer` is the caller. See
668      * {IERC1820Implementer-canImplementInterfaceForAddress}.
669      */
670     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
671 
672     /**
673      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
674      * implementer is registered, returns the zero address.
675      *
676      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
677      * zeroes), `account` will be queried for support of it.
678      *
679      * `account` being the zero address is an alias for the caller's address.
680      */
681     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
682 
683     /**
684      * @dev Returns the interface hash for an `interfaceName`, as defined in the
685      * corresponding
686      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
687      */
688     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
689 
690     /**
691      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
692      *  @param account Address of the contract for which to update the cache.
693      *  @param interfaceId ERC165 interface for which to update the cache.
694      */
695     function updateERC165Cache(address account, bytes4 interfaceId) external;
696 
697     /**
698      *  @notice Checks whether a contract implements an ERC165 interface or not.
699      *  If the result is not cached a direct lookup on the contract address is performed.
700      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
701      *  {updateERC165Cache} with the contract address.
702      *  @param account Address of the contract to check.
703      *  @param interfaceId ERC165 interface to check.
704      *  @return True if `account` implements `interfaceId`, false otherwise.
705      */
706     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
707 
708     /**
709      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
710      *  @param account Address of the contract to check.
711      *  @param interfaceId ERC165 interface to check.
712      *  @return True if `account` implements `interfaceId`, false otherwise.
713      */
714     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
715 
716     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
717 
718     event ManagerChanged(address indexed account, address indexed newManager);
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC777/ERC777.sol
722 
723 pragma solidity ^0.5.0;
724 
725 
726 
727 
728 
729 
730 
731 
732 
733 /**
734  * @dev Implementation of the {IERC777} interface.
735  *
736  * This implementation is agnostic to the way tokens are created. This means
737  * that a supply mechanism has to be added in a derived contract using {_mint}.
738  *
739  * Support for ERC20 is included in this contract, as specified by the EIP: both
740  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
741  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
742  * movements.
743  *
744  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
745  * are no special restrictions in the amount of tokens that created, moved, or
746  * destroyed. This makes integration with ERC20 applications seamless.
747  */
748 contract ERC777 is Context, IERC777, IERC20 {
749     using SafeMath for uint256;
750     using Address for address;
751 
752     IERC1820Registry constant internal ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
753 
754     mapping(address => uint256) private _balances;
755 
756     uint256 private _totalSupply;
757 
758     string private _name;
759     string private _symbol;
760 
761     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
762     // See https://github.com/ethereum/solidity/issues/4024.
763 
764     // keccak256("ERC777TokensSender")
765     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
766         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
767 
768     // keccak256("ERC777TokensRecipient")
769     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
770         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
771 
772     // This isn't ever read from - it's only used to respond to the defaultOperators query.
773     address[] private _defaultOperatorsArray;
774 
775     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
776     mapping(address => bool) private _defaultOperators;
777 
778     // For each account, a mapping of its operators and revoked default operators.
779     mapping(address => mapping(address => bool)) private _operators;
780     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
781 
782     // ERC20-allowances
783     mapping (address => mapping (address => uint256)) private _allowances;
784 
785     /**
786      * @dev `defaultOperators` may be an empty array.
787      */
788     constructor(
789         string memory name,
790         string memory symbol,
791         address[] memory defaultOperators
792     ) public {
793         _name = name;
794         _symbol = symbol;
795 
796         _defaultOperatorsArray = defaultOperators;
797         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
798             _defaultOperators[_defaultOperatorsArray[i]] = true;
799         }
800 
801         // register interfaces
802         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
803         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
804     }
805 
806     /**
807      * @dev See {IERC777-name}.
808      */
809     function name() public view returns (string memory) {
810         return _name;
811     }
812 
813     /**
814      * @dev See {IERC777-symbol}.
815      */
816     function symbol() public view returns (string memory) {
817         return _symbol;
818     }
819 
820     /**
821      * @dev See {ERC20Detailed-decimals}.
822      *
823      * Always returns 18, as per the
824      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
825      */
826     function decimals() public pure returns (uint8) {
827         return 18;
828     }
829 
830     /**
831      * @dev See {IERC777-granularity}.
832      *
833      * This implementation always returns `1`.
834      */
835     function granularity() public view returns (uint256) {
836         return 1;
837     }
838 
839     /**
840      * @dev See {IERC777-totalSupply}.
841      */
842     function totalSupply() public view returns (uint256) {
843         return _totalSupply;
844     }
845 
846     /**
847      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
848      */
849     function balanceOf(address tokenHolder) public view returns (uint256) {
850         return _balances[tokenHolder];
851     }
852 
853     /**
854      * @dev See {IERC777-send}.
855      *
856      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
857      */
858     function send(address recipient, uint256 amount, bytes memory data) public {
859         _send(_msgSender(), _msgSender(), recipient, amount, data, "", true);
860     }
861 
862     /**
863      * @dev See {IERC20-transfer}.
864      *
865      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
866      * interface if it is a contract.
867      *
868      * Also emits a {Sent} event.
869      */
870     function transfer(address recipient, uint256 amount) public returns (bool) {
871         require(recipient != address(0), "ERC777: transfer to the zero address");
872 
873         address from = _msgSender();
874 
875         _callTokensToSend(from, from, recipient, amount, "", "");
876 
877         _move(from, from, recipient, amount, "", "");
878 
879         _callTokensReceived(from, from, recipient, amount, "", "", false);
880 
881         return true;
882     }
883 
884     /**
885      * @dev See {IERC777-burn}.
886      *
887      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
888      */
889     function burn(uint256 amount, bytes memory data) public {
890         _burn(_msgSender(), _msgSender(), amount, data, "");
891     }
892 
893     /**
894      * @dev See {IERC777-isOperatorFor}.
895      */
896     function isOperatorFor(
897         address operator,
898         address tokenHolder
899     ) public view returns (bool) {
900         return operator == tokenHolder ||
901             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
902             _operators[tokenHolder][operator];
903     }
904 
905     /**
906      * @dev See {IERC777-authorizeOperator}.
907      */
908     function authorizeOperator(address operator) public {
909         require(_msgSender() != operator, "ERC777: authorizing self as operator");
910 
911         if (_defaultOperators[operator]) {
912             delete _revokedDefaultOperators[_msgSender()][operator];
913         } else {
914             _operators[_msgSender()][operator] = true;
915         }
916 
917         emit AuthorizedOperator(operator, _msgSender());
918     }
919 
920     /**
921      * @dev See {IERC777-revokeOperator}.
922      */
923     function revokeOperator(address operator) public {
924         require(operator != _msgSender(), "ERC777: revoking self as operator");
925 
926         if (_defaultOperators[operator]) {
927             _revokedDefaultOperators[_msgSender()][operator] = true;
928         } else {
929             delete _operators[_msgSender()][operator];
930         }
931 
932         emit RevokedOperator(operator, _msgSender());
933     }
934 
935     /**
936      * @dev See {IERC777-defaultOperators}.
937      */
938     function defaultOperators() public view returns (address[] memory) {
939         return _defaultOperatorsArray;
940     }
941 
942     /**
943      * @dev See {IERC777-operatorSend}.
944      *
945      * Emits {Sent} and {IERC20-Transfer} events.
946      */
947     function operatorSend(
948         address sender,
949         address recipient,
950         uint256 amount,
951         bytes memory data,
952         bytes memory operatorData
953     )
954     public
955     {
956         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
957         _send(_msgSender(), sender, recipient, amount, data, operatorData, true);
958     }
959 
960     /**
961      * @dev See {IERC777-operatorBurn}.
962      *
963      * Emits {Burned} and {IERC20-Transfer} events.
964      */
965     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public {
966         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
967         _burn(_msgSender(), account, amount, data, operatorData);
968     }
969 
970     /**
971      * @dev See {IERC20-allowance}.
972      *
973      * Note that operator and allowance concepts are orthogonal: operators may
974      * not have allowance, and accounts with allowance may not be operators
975      * themselves.
976      */
977     function allowance(address holder, address spender) public view returns (uint256) {
978         return _allowances[holder][spender];
979     }
980 
981     /**
982      * @dev See {IERC20-approve}.
983      *
984      * Note that accounts cannot have allowance issued by their operators.
985      */
986     function approve(address spender, uint256 value) public returns (bool) {
987         address holder = _msgSender();
988         _approve(holder, spender, value);
989         return true;
990     }
991 
992    /**
993     * @dev See {IERC20-transferFrom}.
994     *
995     * Note that operator and allowance concepts are orthogonal: operators cannot
996     * call `transferFrom` (unless they have allowance), and accounts with
997     * allowance cannot call `operatorSend` (unless they are operators).
998     *
999     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
1000     */
1001     function transferFrom(address holder, address recipient, uint256 amount) public returns (bool) {
1002         require(recipient != address(0), "ERC777: transfer to the zero address");
1003         require(holder != address(0), "ERC777: transfer from the zero address");
1004 
1005         address spender = _msgSender();
1006 
1007         _callTokensToSend(spender, holder, recipient, amount, "", "");
1008 
1009         _move(spender, holder, recipient, amount, "", "");
1010         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
1011 
1012         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
1013 
1014         return true;
1015     }
1016 
1017     /**
1018      * @dev Creates `amount` tokens and assigns them to `account`, increasing
1019      * the total supply.
1020      *
1021      * If a send hook is registered for `account`, the corresponding function
1022      * will be called with `operator`, `data` and `operatorData`.
1023      *
1024      * See {IERC777Sender} and {IERC777Recipient}.
1025      *
1026      * Emits {Minted} and {IERC20-Transfer} events.
1027      *
1028      * Requirements
1029      *
1030      * - `account` cannot be the zero address.
1031      * - if `account` is a contract, it must implement the {IERC777Recipient}
1032      * interface.
1033      */
1034     function _mint(
1035         address operator,
1036         address account,
1037         uint256 amount,
1038         bytes memory userData,
1039         bytes memory operatorData
1040     )
1041     internal
1042     {
1043         require(account != address(0), "ERC777: mint to the zero address");
1044 
1045         // Update state variables
1046         _totalSupply = _totalSupply.add(amount);
1047         _balances[account] = _balances[account].add(amount);
1048 
1049         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1050 
1051         emit Minted(operator, account, amount, userData, operatorData);
1052         emit Transfer(address(0), account, amount);
1053     }
1054 
1055     /**
1056      * @dev Send tokens
1057      * @param operator address operator requesting the transfer
1058      * @param from address token holder address
1059      * @param to address recipient address
1060      * @param amount uint256 amount of tokens to transfer
1061      * @param userData bytes extra information provided by the token holder (if any)
1062      * @param operatorData bytes extra information provided by the operator (if any)
1063      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1064      */
1065     function _send(
1066         address operator,
1067         address from,
1068         address to,
1069         uint256 amount,
1070         bytes memory userData,
1071         bytes memory operatorData,
1072         bool requireReceptionAck
1073     )
1074         internal
1075     {
1076         require(operator != address(0), "ERC777: operator is the zero address");
1077         require(from != address(0), "ERC777: send from the zero address");
1078         require(to != address(0), "ERC777: send to the zero address");
1079 
1080         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1081 
1082         _move(operator, from, to, amount, userData, operatorData);
1083 
1084         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1085     }
1086 
1087     /**
1088      * @dev Burn tokens
1089      * @param operator address operator requesting the operation
1090      * @param from address token holder address
1091      * @param amount uint256 amount of tokens to burn
1092      * @param data bytes extra information provided by the token holder
1093      * @param operatorData bytes extra information provided by the operator (if any)
1094      */
1095     function _burn(
1096         address operator,
1097         address from,
1098         uint256 amount,
1099         bytes memory data,
1100         bytes memory operatorData
1101     )
1102         internal
1103     {
1104         require(from != address(0), "ERC777: burn from the zero address");
1105 
1106         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1107 
1108         // Update state variables
1109         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1110         _totalSupply = _totalSupply.sub(amount);
1111 
1112         emit Burned(operator, from, amount, data, operatorData);
1113         emit Transfer(from, address(0), amount);
1114     }
1115 
1116     function _move(
1117         address operator,
1118         address from,
1119         address to,
1120         uint256 amount,
1121         bytes memory userData,
1122         bytes memory operatorData
1123     )
1124         private
1125     {
1126         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1127         _balances[to] = _balances[to].add(amount);
1128 
1129         emit Sent(operator, from, to, amount, userData, operatorData);
1130         emit Transfer(from, to, amount);
1131     }
1132 
1133     /**
1134      * @dev See {ERC20-_approve}.
1135      *
1136      * Note that accounts cannot have allowance issued by their operators.
1137      */
1138     function _approve(address holder, address spender, uint256 value) internal {
1139         require(holder != address(0), "ERC777: approve from the zero address");
1140         require(spender != address(0), "ERC777: approve to the zero address");
1141 
1142         _allowances[holder][spender] = value;
1143         emit Approval(holder, spender, value);
1144     }
1145 
1146     /**
1147      * @dev Call from.tokensToSend() if the interface is registered
1148      * @param operator address operator requesting the transfer
1149      * @param from address token holder address
1150      * @param to address recipient address
1151      * @param amount uint256 amount of tokens to transfer
1152      * @param userData bytes extra information provided by the token holder (if any)
1153      * @param operatorData bytes extra information provided by the operator (if any)
1154      */
1155     function _callTokensToSend(
1156         address operator,
1157         address from,
1158         address to,
1159         uint256 amount,
1160         bytes memory userData,
1161         bytes memory operatorData
1162     )
1163         internal
1164     {
1165         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1166         if (implementer != address(0)) {
1167             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1168         }
1169     }
1170 
1171     /**
1172      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1173      * tokensReceived() was not registered for the recipient
1174      * @param operator address operator requesting the transfer
1175      * @param from address token holder address
1176      * @param to address recipient address
1177      * @param amount uint256 amount of tokens to transfer
1178      * @param userData bytes extra information provided by the token holder (if any)
1179      * @param operatorData bytes extra information provided by the operator (if any)
1180      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1181      */
1182     function _callTokensReceived(
1183         address operator,
1184         address from,
1185         address to,
1186         uint256 amount,
1187         bytes memory userData,
1188         bytes memory operatorData,
1189         bool requireReceptionAck
1190     )
1191         internal
1192     {
1193         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1194         if (implementer != address(0)) {
1195             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1196         } else if (requireReceptionAck) {
1197             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1198         }
1199     }
1200 }
1201 
1202 // File: contracts/AbstractOwnable.sol
1203 
1204 pragma solidity ^0.5.0;
1205 
1206 contract AbstractOwnable {
1207   /**
1208    * @dev Returns the address of the current owner.
1209    */
1210   function owner() internal view returns (address);
1211 
1212   /**
1213    * @dev Throws if called by any account other than the owner.
1214    */
1215   modifier onlyOwner() {
1216     require(isOwner(), "Caller is not the owner");
1217     _;
1218   }
1219 
1220   /**
1221    * @dev Returns true if the caller is the current owner.
1222    */
1223   function isOwner() internal view returns (bool) {
1224     return msg.sender == owner();
1225   }
1226 
1227 }
1228 
1229 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
1230 
1231 pragma solidity ^0.5.0;
1232 
1233 /**
1234  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1235  *
1236  * These functions can be used to verify that a message was signed by the holder
1237  * of the private keys of a given address.
1238  */
1239 library ECDSA {
1240     /**
1241      * @dev Returns the address that signed a hashed message (`hash`) with
1242      * `signature`. This address can then be used for verification purposes.
1243      *
1244      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1245      * this function rejects them by requiring the `s` value to be in the lower
1246      * half order, and the `v` value to be either 27 or 28.
1247      *
1248      * NOTE: This call _does not revert_ if the signature is invalid, or
1249      * if the signer is otherwise unable to be retrieved. In those scenarios,
1250      * the zero address is returned.
1251      *
1252      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1253      * verification to be secure: it is possible to craft signatures that
1254      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1255      * this is by receiving a hash of the original message (which may otherwise
1256      * be too long), and then calling {toEthSignedMessageHash} on it.
1257      */
1258     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1259         // Check the signature length
1260         if (signature.length != 65) {
1261             return (address(0));
1262         }
1263 
1264         // Divide the signature in r, s and v variables
1265         bytes32 r;
1266         bytes32 s;
1267         uint8 v;
1268 
1269         // ecrecover takes the signature parameters, and the only way to get them
1270         // currently is to use assembly.
1271         // solhint-disable-next-line no-inline-assembly
1272         assembly {
1273             r := mload(add(signature, 0x20))
1274             s := mload(add(signature, 0x40))
1275             v := byte(0, mload(add(signature, 0x60)))
1276         }
1277 
1278         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1279         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1280         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1281         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1282         //
1283         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1284         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1285         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1286         // these malleable signatures as well.
1287         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1288             return address(0);
1289         }
1290 
1291         if (v != 27 && v != 28) {
1292             return address(0);
1293         }
1294 
1295         // If the signature is valid (and not malleable), return the signer address
1296         return ecrecover(hash, v, r, s);
1297     }
1298 
1299     /**
1300      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1301      * replicates the behavior of the
1302      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
1303      * JSON-RPC method.
1304      *
1305      * See {recover}.
1306      */
1307     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1308         // 32 is the length in bytes of hash,
1309         // enforced by the type signature above
1310         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1311     }
1312 }
1313 
1314 // File: @openzeppelin/contracts/GSN/IRelayRecipient.sol
1315 
1316 pragma solidity ^0.5.0;
1317 
1318 /**
1319  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
1320  *
1321  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
1322  */
1323 interface IRelayRecipient {
1324     /**
1325      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
1326      */
1327     function getHubAddr() external view returns (address);
1328 
1329     /**
1330      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
1331      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
1332      *
1333      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
1334      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
1335      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
1336      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
1337      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
1338      * over all or some of the previous values.
1339      *
1340      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
1341      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
1342      *
1343      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
1344      * rejected. A regular revert will also trigger a rejection.
1345      */
1346     function acceptRelayedCall(
1347         address relay,
1348         address from,
1349         bytes calldata encodedFunction,
1350         uint256 transactionFee,
1351         uint256 gasPrice,
1352         uint256 gasLimit,
1353         uint256 nonce,
1354         bytes calldata approvalData,
1355         uint256 maxPossibleCharge
1356     )
1357         external
1358         view
1359         returns (uint256, bytes memory);
1360 
1361     /**
1362      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
1363      * pre-charge the sender of the transaction.
1364      *
1365      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
1366      *
1367      * Returns a value to be passed to {postRelayedCall}.
1368      *
1369      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
1370      * will not be executed, but the recipient will still be charged for the transaction's cost.
1371      */
1372     function preRelayedCall(bytes calldata context) external returns (bytes32);
1373 
1374     /**
1375      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
1376      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
1377      * contract-specific bookkeeping.
1378      *
1379      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
1380      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
1381      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
1382      *
1383      *
1384      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
1385      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
1386      * transaction's cost.
1387      */
1388     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
1389 }
1390 
1391 // File: @openzeppelin/contracts/GSN/IRelayHub.sol
1392 
1393 pragma solidity ^0.5.0;
1394 
1395 /**
1396  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
1397  * directly.
1398  *
1399  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
1400  * how to deploy an instance of `RelayHub` on your local test network.
1401  */
1402 interface IRelayHub {
1403     // Relay management
1404 
1405     /**
1406      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
1407      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
1408      * cannot be its own owner.
1409      *
1410      * All Ether in this function call will be added to the relay's stake.
1411      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
1412      *
1413      * Emits a {Staked} event.
1414      */
1415     function stake(address relayaddr, uint256 unstakeDelay) external payable;
1416 
1417     /**
1418      * @dev Emitted when a relay's stake or unstakeDelay are increased
1419      */
1420     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
1421 
1422     /**
1423      * @dev Registers the caller as a relay.
1424      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
1425      *
1426      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
1427      * `transactionFee` is not enforced by {relayCall}.
1428      *
1429      * Emits a {RelayAdded} event.
1430      */
1431     function registerRelay(uint256 transactionFee, string calldata url) external;
1432 
1433     /**
1434      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
1435      * {RelayRemoved} events) lets a client discover the list of available relays.
1436      */
1437     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
1438 
1439     /**
1440      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
1441      *
1442      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
1443      * callable.
1444      *
1445      * Emits a {RelayRemoved} event.
1446      */
1447     function removeRelayByOwner(address relay) external;
1448 
1449     /**
1450      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
1451      */
1452     event RelayRemoved(address indexed relay, uint256 unstakeTime);
1453 
1454     /** Deletes the relay from the system, and gives back its stake to the owner.
1455      *
1456      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
1457      *
1458      * Emits an {Unstaked} event.
1459      */
1460     function unstake(address relay) external;
1461 
1462     /**
1463      * @dev Emitted when a relay is unstaked for, including the returned stake.
1464      */
1465     event Unstaked(address indexed relay, uint256 stake);
1466 
1467     // States a relay can be in
1468     enum RelayState {
1469         Unknown, // The relay is unknown to the system: it has never been staked for
1470         Staked, // The relay has been staked for, but it is not yet active
1471         Registered, // The relay has registered itself, and is active (can relay calls)
1472         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
1473     }
1474 
1475     /**
1476      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
1477      * to return an empty entry.
1478      */
1479     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
1480 
1481     // Balance management
1482 
1483     /**
1484      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
1485      *
1486      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
1487      *
1488      * Emits a {Deposited} event.
1489      */
1490     function depositFor(address target) external payable;
1491 
1492     /**
1493      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
1494      */
1495     event Deposited(address indexed recipient, address indexed from, uint256 amount);
1496 
1497     /**
1498      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
1499      */
1500     function balanceOf(address target) external view returns (uint256);
1501 
1502     /**
1503      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
1504      * contracts can use it to reduce their funding.
1505      *
1506      * Emits a {Withdrawn} event.
1507      */
1508     function withdraw(uint256 amount, address payable dest) external;
1509 
1510     /**
1511      * @dev Emitted when an account withdraws funds from `RelayHub`.
1512      */
1513     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
1514 
1515     // Relaying
1516 
1517     /**
1518      * @dev Checks if the `RelayHub` will accept a relayed operation.
1519      * Multiple things must be true for this to happen:
1520      *  - all arguments must be signed for by the sender (`from`)
1521      *  - the sender's nonce must be the current one
1522      *  - the recipient must accept this transaction (via {acceptRelayedCall})
1523      *
1524      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
1525      * code if it returns one in {acceptRelayedCall}.
1526      */
1527     function canRelay(
1528         address relay,
1529         address from,
1530         address to,
1531         bytes calldata encodedFunction,
1532         uint256 transactionFee,
1533         uint256 gasPrice,
1534         uint256 gasLimit,
1535         uint256 nonce,
1536         bytes calldata signature,
1537         bytes calldata approvalData
1538     ) external view returns (uint256 status, bytes memory recipientContext);
1539 
1540     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
1541     enum PreconditionCheck {
1542         OK,                         // All checks passed, the call can be relayed
1543         WrongSignature,             // The transaction to relay is not signed by requested sender
1544         WrongNonce,                 // The provided nonce has already been used by the sender
1545         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
1546         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
1547     }
1548 
1549     /**
1550      * @dev Relays a transaction.
1551      *
1552      * For this to succeed, multiple conditions must be met:
1553      *  - {canRelay} must `return PreconditionCheck.OK`
1554      *  - the sender must be a registered relay
1555      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
1556      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
1557      * recipient) use all gas available to them
1558      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
1559      * spent)
1560      *
1561      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
1562      * function and {postRelayedCall} will be called in that order.
1563      *
1564      * Parameters:
1565      *  - `from`: the client originating the request
1566      *  - `to`: the target {IRelayRecipient} contract
1567      *  - `encodedFunction`: the function call to relay, including data
1568      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
1569      *  - `gasPrice`: gas price the client is willing to pay
1570      *  - `gasLimit`: gas to forward when calling the encoded function
1571      *  - `nonce`: client's nonce
1572      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
1573      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
1574      * `RelayHub`, but it still can be used for e.g. a signature.
1575      *
1576      * Emits a {TransactionRelayed} event.
1577      */
1578     function relayCall(
1579         address from,
1580         address to,
1581         bytes calldata encodedFunction,
1582         uint256 transactionFee,
1583         uint256 gasPrice,
1584         uint256 gasLimit,
1585         uint256 nonce,
1586         bytes calldata signature,
1587         bytes calldata approvalData
1588     ) external;
1589 
1590     /**
1591      * @dev Emitted when an attempt to relay a call failed.
1592      *
1593      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
1594      * actual relayed call was not executed, and the recipient not charged.
1595      *
1596      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
1597      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
1598      */
1599     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
1600 
1601     /**
1602      * @dev Emitted when a transaction is relayed. 
1603      * Useful when monitoring a relay's operation and relayed calls to a contract
1604      *
1605      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
1606      *
1607      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
1608      */
1609     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
1610 
1611     // Reason error codes for the TransactionRelayed event
1612     enum RelayCallStatus {
1613         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
1614         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
1615         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
1616         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
1617         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
1618     }
1619 
1620     /**
1621      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
1622      * spend up to `relayedCallStipend` gas.
1623      */
1624     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
1625 
1626     /**
1627      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
1628      */
1629     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
1630 
1631      // Relay penalization. 
1632      // Any account can penalize relays, removing them from the system immediately, and rewarding the
1633     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
1634     // still loses half of its stake.
1635 
1636     /**
1637      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
1638      * different data (gas price, gas limit, etc. may be different).
1639      *
1640      * The (unsigned) transaction data and signature for both transactions must be provided.
1641      */
1642     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
1643 
1644     /**
1645      * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
1646      */
1647     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
1648 
1649     /**
1650      * @dev Emitted when a relay is penalized.
1651      */
1652     event Penalized(address indexed relay, address sender, uint256 amount);
1653 
1654     /**
1655      * @dev Returns an account's nonce in `RelayHub`.
1656      */
1657     function getNonce(address from) external view returns (uint256);
1658 }
1659 
1660 // File: @openzeppelin/contracts/GSN/GSNRecipient.sol
1661 
1662 pragma solidity ^0.5.0;
1663 
1664 
1665 
1666 
1667 /**
1668  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
1669  * and enables GSN support on all contracts in the inheritance tree.
1670  *
1671  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
1672  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
1673  * provided by derived contracts. See the
1674  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
1675  * information on how to use the pre-built {GSNRecipientSignature} and
1676  * {GSNRecipientERC20Fee}, or how to write your own.
1677  */
1678 contract GSNRecipient is IRelayRecipient, Context {
1679     // Default RelayHub address, deployed on mainnet and all testnets at the same address
1680     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
1681 
1682     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
1683     uint256 constant private RELAYED_CALL_REJECTED = 11;
1684 
1685     // How much gas is forwarded to postRelayedCall
1686     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
1687 
1688     /**
1689      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
1690      */
1691     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
1692 
1693     /**
1694      * @dev Returns the address of the {IRelayHub} contract for this recipient.
1695      */
1696     function getHubAddr() public view returns (address) {
1697         return _relayHub;
1698     }
1699 
1700     /**
1701      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
1702      * use the default instance.
1703      *
1704      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
1705      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
1706      */
1707     function _upgradeRelayHub(address newRelayHub) internal {
1708         address currentRelayHub = _relayHub;
1709         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
1710         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
1711 
1712         emit RelayHubChanged(currentRelayHub, newRelayHub);
1713 
1714         _relayHub = newRelayHub;
1715     }
1716 
1717     /**
1718      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
1719      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
1720      */
1721     // This function is view for future-proofing, it may require reading from
1722     // storage in the future.
1723     function relayHubVersion() public view returns (string memory) {
1724         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1725         return "1.0.0";
1726     }
1727 
1728     /**
1729      * @dev Withdraws the recipient's deposits in `RelayHub`.
1730      *
1731      * Derived contracts should expose this in an external interface with proper access control.
1732      */
1733     function _withdrawDeposits(uint256 amount, address payable payee) internal {
1734         IRelayHub(_relayHub).withdraw(amount, payee);
1735     }
1736 
1737     // Overrides for Context's functions: when called from RelayHub, sender and
1738     // data require some pre-processing: the actual sender is stored at the end
1739     // of the call data, which in turns means it needs to be removed from it
1740     // when handling said data.
1741 
1742     /**
1743      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
1744      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
1745      *
1746      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
1747      */
1748     function _msgSender() internal view returns (address payable) {
1749         if (msg.sender != _relayHub) {
1750             return msg.sender;
1751         } else {
1752             return _getRelayedCallSender();
1753         }
1754     }
1755 
1756     /**
1757      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1758      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
1759      *
1760      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1761      */
1762     function _msgData() internal view returns (bytes memory) {
1763         if (msg.sender != _relayHub) {
1764             return msg.data;
1765         } else {
1766             return _getRelayedCallData();
1767         }
1768     }
1769 
1770     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
1771     // internal hook.
1772 
1773     /**
1774      * @dev See `IRelayRecipient.preRelayedCall`.
1775      *
1776      * This function should not be overriden directly, use `_preRelayedCall` instead.
1777      *
1778      * * Requirements:
1779      *
1780      * - the caller must be the `RelayHub` contract.
1781      */
1782     function preRelayedCall(bytes calldata context) external returns (bytes32) {
1783         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1784         return _preRelayedCall(context);
1785     }
1786 
1787     /**
1788      * @dev See `IRelayRecipient.preRelayedCall`.
1789      *
1790      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1791      * must implement this function with any relayed-call preprocessing they may wish to do.
1792      *
1793      */
1794     function _preRelayedCall(bytes memory context) internal returns (bytes32);
1795 
1796     /**
1797      * @dev See `IRelayRecipient.postRelayedCall`.
1798      *
1799      * This function should not be overriden directly, use `_postRelayedCall` instead.
1800      *
1801      * * Requirements:
1802      *
1803      * - the caller must be the `RelayHub` contract.
1804      */
1805     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
1806         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1807         _postRelayedCall(context, success, actualCharge, preRetVal);
1808     }
1809 
1810     /**
1811      * @dev See `IRelayRecipient.postRelayedCall`.
1812      *
1813      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1814      * must implement this function with any relayed-call postprocessing they may wish to do.
1815      *
1816      */
1817     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
1818 
1819     /**
1820      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
1821      * will be charged a fee by RelayHub
1822      */
1823     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
1824         return _approveRelayedCall("");
1825     }
1826 
1827     /**
1828      * @dev See `GSNRecipient._approveRelayedCall`.
1829      *
1830      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
1831      */
1832     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
1833         return (RELAYED_CALL_ACCEPTED, context);
1834     }
1835 
1836     /**
1837      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
1838      */
1839     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
1840         return (RELAYED_CALL_REJECTED + errorCode, "");
1841     }
1842 
1843     /*
1844      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
1845      * `serviceFee`.
1846      */
1847     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
1848         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
1849         // charged for 1.4 times the spent amount.
1850         return (gas * gasPrice * (100 + serviceFee)) / 100;
1851     }
1852 
1853     function _getRelayedCallSender() private pure returns (address payable result) {
1854         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
1855         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
1856         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
1857         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
1858         // bytes. This can always be done due to the 32-byte prefix.
1859 
1860         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
1861         // easiest/most-efficient way to perform this operation.
1862 
1863         // These fields are not accessible from assembly
1864         bytes memory array = msg.data;
1865         uint256 index = msg.data.length;
1866 
1867         // solhint-disable-next-line no-inline-assembly
1868         assembly {
1869             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1870             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1871         }
1872         return result;
1873     }
1874 
1875     function _getRelayedCallData() private pure returns (bytes memory) {
1876         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
1877         // we must strip the last 20 bytes (length of an address type) from it.
1878 
1879         uint256 actualDataLength = msg.data.length - 20;
1880         bytes memory actualData = new bytes(actualDataLength);
1881 
1882         for (uint256 i = 0; i < actualDataLength; ++i) {
1883             actualData[i] = msg.data[i];
1884         }
1885 
1886         return actualData;
1887     }
1888 }
1889 
1890 // File: contracts/ERC777GSN.sol
1891 
1892 pragma solidity ^0.5.0;
1893 
1894 
1895 
1896 
1897 
1898 contract ERC777GSN is AbstractOwnable, GSNRecipient, ERC777 {
1899   using ECDSA for bytes32;
1900   uint256 constant GSN_RATE_UNIT = 10**18;
1901 
1902   enum GSNErrorCodes {
1903     INVALID_SIGNER,
1904     INSUFFICIENT_BALANCE
1905   }
1906 
1907   address public gsnTrustedSigner;
1908   address public gsnFeeTarget;
1909   uint256 public gsnExtraGas = 40000; // the gas cost of _postRelayedCall()
1910 
1911   constructor(
1912     address _gsnTrustedSigner,
1913     address _gsnFeeTarget
1914   )
1915     public
1916   {
1917     require(_gsnTrustedSigner != address(0), "trusted signer is the zero address");
1918     gsnTrustedSigner = _gsnTrustedSigner;
1919     require(_gsnFeeTarget != address(0), "fee target is the zero address");
1920     gsnFeeTarget = _gsnFeeTarget;
1921   }
1922 
1923   function _msgSender() internal view returns (address payable) {
1924     return GSNRecipient._msgSender();
1925   }
1926 
1927   function _msgData() internal view returns (bytes memory) {
1928     return GSNRecipient._msgData();
1929   }
1930 
1931 
1932   function setTrustedSigner(address _gsnTrustedSigner) public onlyOwner {
1933     require(_gsnTrustedSigner != address(0), "trusted signer is the zero address");
1934     gsnTrustedSigner = _gsnTrustedSigner;
1935   }
1936 
1937   function setFeeTarget(address _gsnFeeTarget) public onlyOwner {
1938     require(_gsnFeeTarget != address(0), "fee target is the zero address");
1939     gsnFeeTarget = _gsnFeeTarget;
1940   }
1941 
1942   function setGSNExtraGas(uint _gsnExtraGas) public onlyOwner {
1943     gsnExtraGas = _gsnExtraGas;
1944   }
1945 
1946 
1947   /**
1948  * @dev Ensures that only transactions with a trusted signature can be relayed through the GSN.
1949  */
1950   function acceptRelayedCall(
1951     address relay,
1952     address from,
1953     bytes memory encodedFunction,
1954     uint256 transactionFee,
1955     uint256 gasPrice,
1956     uint256 gasLimit,
1957     uint256 nonce,
1958     bytes memory approvalData,
1959     uint256 /* maxPossibleCharge */
1960   )
1961     public
1962     view
1963     returns (uint256, bytes memory)
1964   {
1965     (uint256 feeRate, bytes memory signature) = abi.decode(approvalData, (uint, bytes));
1966     bytes memory blob = abi.encodePacked(
1967       feeRate,
1968       relay,
1969       from,
1970       encodedFunction,
1971       transactionFee,
1972       gasPrice,
1973       gasLimit,
1974       nonce, // Prevents replays on RelayHub
1975       getHubAddr(), // Prevents replays in multiple RelayHubs
1976       address(this) // Prevents replays in multiple recipients
1977     );
1978     if (keccak256(blob).toEthSignedMessageHash().recover(signature) == gsnTrustedSigner) {
1979       return _approveRelayedCall(abi.encode(feeRate, from, transactionFee, gasPrice));
1980     } else {
1981       return _rejectRelayedCall(uint256(GSNErrorCodes.INVALID_SIGNER));
1982     }
1983   }
1984 
1985   function _preRelayedCall(bytes memory context) internal returns (bytes32) {}
1986 
1987   function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
1988     (uint256 feeRate, address from, uint256 transactionFee, uint256 gasPrice) =
1989       abi.decode(context, (uint256, address, uint256, uint256));
1990 
1991     // actualCharge is an _estimated_ charge, which assumes postRelayedCall will use all available gas.
1992     // This implementation's gas cost can be roughly estimated as 10k gas, for the two SSTORE operations in an
1993     // ERC20 transfer.
1994     uint256 overestimation = _computeCharge(POST_RELAYED_CALL_MAX_GAS.sub(gsnExtraGas), gasPrice, transactionFee);
1995     uint fee = actualCharge.sub(overestimation).mul(feeRate).div(GSN_RATE_UNIT);
1996 
1997     if (fee > 0) {
1998       _send(_msgSender(), from, gsnFeeTarget, fee, "", "", false);
1999     }
2000   }
2001 }
2002 
2003 // File: contracts/ERC777WithAdminOperator.sol
2004 
2005 pragma solidity ^0.5.0;
2006 
2007 
2008 contract ERC777WithAdminOperator is ERC777 {
2009 
2010   address public adminOperator;
2011 
2012   event AdminOperatorChange(address oldOperator, address newOperator);
2013   event AdminTransferInvoked(address operator);
2014 
2015   constructor(address _adminOperator) public {
2016     adminOperator = _adminOperator;
2017   }
2018 
2019   /**
2020  * @dev Similar to {IERC777-operatorSend}.
2021  *
2022  * Emits {Sent} and {IERC20-Transfer} events.
2023  */
2024   function adminTransfer(
2025     address sender,
2026     address recipient,
2027     uint256 amount,
2028     bytes memory data,
2029     bytes memory operatorData
2030   )
2031   public
2032   {
2033     require(_msgSender() == adminOperator, "caller is not the admin operator");
2034     _send(adminOperator, sender, recipient, amount, data, operatorData, false);
2035     emit AdminTransferInvoked(adminOperator);
2036   }
2037 
2038   /**
2039    * @dev Only the actual admin operator can change the address
2040    */
2041   function setAdminOperator(address adminOperator_) public {
2042     require(msg.sender == adminOperator, "Only the actual admin operator can change the address");
2043     emit AdminOperatorChange(adminOperator, adminOperator_);
2044     adminOperator = adminOperator_;
2045   }
2046 
2047 
2048 }
2049 
2050 // File: contracts/ERC777OptionalAckOnMint.sol
2051 
2052 pragma solidity ^0.5.0;
2053 
2054 
2055 contract ERC777OptionalAckOnMint is ERC777 {
2056   bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
2057     0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
2058 
2059   /**
2060  * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
2061  * tokensReceived() was not registered for the recipient
2062  * @param operator address operator requesting the transfer
2063  * @param from address token holder address
2064  * @param to address recipient address
2065  * @param amount uint256 amount of tokens to transfer
2066  * @param userData bytes extra information provided by the token holder (if any)
2067  * @param operatorData bytes extra information provided by the operator (if any)
2068  * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
2069  */
2070   function _callTokensReceived(
2071     address operator,
2072     address from,
2073     address to,
2074     uint256 amount,
2075     bytes memory userData,
2076     bytes memory operatorData,
2077     bool requireReceptionAck
2078   )
2079     internal
2080   {
2081     address implementer = ERC1820_REGISTRY.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
2082     if (implementer != address(0)) {
2083       IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
2084     } else if (requireReceptionAck && from != address(0)) {
2085       require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
2086     }
2087   }
2088 }
2089 
2090 // File: contracts/pToken.sol
2091 
2092 pragma solidity ^0.5.0;
2093 
2094 
2095 
2096 
2097 
2098 
2099 contract PToken is
2100     AbstractOwnable,
2101     ERC777,
2102     ERC777OptionalAckOnMint,
2103     ERC777GSN,
2104     ERC777WithAdminOperator
2105 {
2106 
2107     address public pNetwork;
2108 
2109     event Redeem(
2110         address indexed redeemer,
2111         uint256 value,
2112         string underlyingAssetRecipient
2113     );
2114 
2115     constructor(
2116         string memory tokenName,
2117         string memory tokenSymbol,
2118         address[] memory defaultOperators
2119     )
2120         ERC777(tokenName, tokenSymbol, defaultOperators)
2121         ERC777GSN(msg.sender, msg.sender)
2122         ERC777WithAdminOperator(msg.sender)
2123         public
2124     {
2125         pNetwork = _msgSender();
2126     }
2127 
2128     function owner() internal view returns (address) {
2129         return pNetwork;
2130     }
2131 
2132     function changePNetwork(
2133         address newPNetwork
2134     )
2135         external
2136     {
2137         require(
2138             _msgSender() == pNetwork,
2139             "Only the pNetwork can change the `pNetwork` account!"
2140         );
2141         require(
2142             newPNetwork != address(0),
2143             "pNetwork cannot be the zero address!"
2144         );
2145         pNetwork = newPNetwork;
2146     }
2147 
2148     function mint(
2149         address recipient,
2150         uint256 value
2151     )
2152         external
2153         returns (bool)
2154     {
2155         mint(recipient, value, "", "");
2156         return true;
2157     }
2158 
2159     function mint(
2160         address recipient,
2161         uint256 value,
2162         bytes memory userData,
2163         bytes memory operatorData
2164     )
2165         public
2166         returns (bool)
2167     {
2168         require(
2169             _msgSender() == pNetwork,
2170             "Only the pNetwork can mint tokens!"
2171         );
2172         require(
2173             recipient != address(0),
2174             "pToken: Cannot mint to the zero address!"
2175         );
2176         _mint(pNetwork, recipient, value, userData, operatorData);
2177         return true;
2178     }
2179 
2180     function redeem(
2181         uint256 amount,
2182         string calldata underlyingAssetRecipient
2183     )
2184         external
2185         returns (bool)
2186     {
2187         redeem(amount, "", underlyingAssetRecipient);
2188         return true;
2189     }
2190 
2191     function redeem(
2192         uint256 amount,
2193         bytes memory data,
2194         string memory underlyingAssetRecipient
2195     )
2196         public
2197     {
2198         _burn(_msgSender(), _msgSender(), amount, data, "");
2199         emit Redeem(msg.sender, amount, underlyingAssetRecipient);
2200     }
2201 
2202     function operatorRedeem(
2203         address account,
2204         uint256 amount,
2205         bytes calldata data,
2206         bytes calldata operatorData,
2207         string calldata underlyingAssetRecipient
2208     )
2209         external
2210     {
2211         require(
2212             isOperatorFor(_msgSender(), account),
2213             "ERC777: caller is not an operator for holder"
2214         );
2215         _burn(_msgSender(), account, amount, data, operatorData);
2216         emit Redeem(account, amount, underlyingAssetRecipient);
2217     }
2218 }