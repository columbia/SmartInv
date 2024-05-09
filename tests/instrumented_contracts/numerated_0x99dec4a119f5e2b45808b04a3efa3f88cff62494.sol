1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
117  * the optional functions; to access them see `ERC20Detailed`.
118  */
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129 
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a `Transfer` event.
136      */
137     function transfer(address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through `transferFrom`. This is
142      * zero by default.
143      *
144      * This value changes when `approve` or `transferFrom` are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * > Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an `Approval` event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a `Transfer` event.
172      */
173     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to `approve`. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 // File: openzeppelin-solidity/contracts/utils/Address.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @dev Collection of functions related to the address type,
196  */
197 library Address {
198     /**
199      * @dev Returns true if `account` is a contract.
200      *
201      * This test is non-exhaustive, and there may be false-negatives: during the
202      * execution of a contract's constructor, its address will be reported as
203      * not containing a contract.
204      *
205      * > It is unsafe to assume that an address for which this function returns
206      * false is an externally-owned account (EOA) and not a contract.
207      */
208     function isContract(address account) internal view returns (bool) {
209         // This method relies in extcodesize, which returns 0 for contracts in
210         // construction, since the code is only stored at the end of the
211         // constructor execution.
212 
213         uint256 size;
214         // solhint-disable-next-line no-inline-assembly
215         assembly { size := extcodesize(account) }
216         return size > 0;
217     }
218 }
219 
220 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
221 
222 pragma solidity ^0.5.0;
223 
224 
225 
226 
227 /**
228  * @title SafeERC20
229  * @dev Wrappers around ERC20 operations that throw on failure (when the token
230  * contract returns false). Tokens that return no value (and instead revert or
231  * throw on failure) are also supported, non-reverting calls are assumed to be
232  * successful.
233  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
234  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
235  */
236 library SafeERC20 {
237     using SafeMath for uint256;
238     using Address for address;
239 
240     function safeTransfer(IERC20 token, address to, uint256 value) internal {
241         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
242     }
243 
244     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
245         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
246     }
247 
248     function safeApprove(IERC20 token, address spender, uint256 value) internal {
249         // safeApprove should only be called when setting an initial allowance,
250         // or when resetting it to zero. To increase and decrease it, use
251         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
252         // solhint-disable-next-line max-line-length
253         require((value == 0) || (token.allowance(address(this), spender) == 0),
254             "SafeERC20: approve from non-zero to non-zero allowance"
255         );
256         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
257     }
258 
259     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
260         uint256 newAllowance = token.allowance(address(this), spender).add(value);
261         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
262     }
263 
264     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
265         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
266         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
267     }
268 
269     /**
270      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
271      * on the return value: the return value is optional (but if data is returned, it must not be false).
272      * @param token The token targeted by the call.
273      * @param data The call data (encoded using abi.encode or one of its variants).
274      */
275     function callOptionalReturn(IERC20 token, bytes memory data) private {
276         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
277         // we're implementing it ourselves.
278 
279         // A Solidity high level call has three parts:
280         //  1. The target address is checked to verify it contains contract code
281         //  2. The call itself is made, and success asserted
282         //  3. The return value is decoded, which in turn checks the size of the returned data.
283         // solhint-disable-next-line max-line-length
284         require(address(token).isContract(), "SafeERC20: call to non-contract");
285 
286         // solhint-disable-next-line avoid-low-level-calls
287         (bool success, bytes memory returndata) = address(token).call(data);
288         require(success, "SafeERC20: low-level call failed");
289 
290         if (returndata.length > 0) { // Return data is optional
291             // solhint-disable-next-line max-line-length
292             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
293         }
294     }
295 }
296 
297 // File: openzeppelin-solidity/contracts/token/ERC777/IERC777.sol
298 
299 pragma solidity ^0.5.0;
300 
301 /**
302  * @dev Interface of the ERC777Token standard as defined in the EIP.
303  *
304  * This contract uses the
305  * [ERC1820 registry standard](https://eips.ethereum.org/EIPS/eip-1820) to let
306  * token holders and recipients react to token movements by using setting implementers
307  * for the associated interfaces in said registry. See `IERC1820Registry` and
308  * `ERC1820Implementer`.
309  */
310 interface IERC777 {
311     /**
312      * @dev Returns the name of the token.
313      */
314     function name() external view returns (string memory);
315 
316     /**
317      * @dev Returns the symbol of the token, usually a shorter version of the
318      * name.
319      */
320     function symbol() external view returns (string memory);
321 
322     /**
323      * @dev Returns the smallest part of the token that is not divisible. This
324      * means all token operations (creation, movement and destruction) must have
325      * amounts that are a multiple of this number.
326      *
327      * For most token contracts, this value will equal 1.
328      */
329     function granularity() external view returns (uint256);
330 
331     /**
332      * @dev Returns the amount of tokens in existence.
333      */
334     function totalSupply() external view returns (uint256);
335 
336     /**
337      * @dev Returns the amount of tokens owned by an account (`owner`).
338      */
339     function balanceOf(address owner) external view returns (uint256);
340 
341     /**
342      * @dev Moves `amount` tokens from the caller's account to `recipient`.
343      *
344      * If send or receive hooks are registered for the caller and `recipient`,
345      * the corresponding functions will be called with `data` and empty
346      * `operatorData`. See `IERC777Sender` and `IERC777Recipient`.
347      *
348      * Emits a `Sent` event.
349      *
350      * Requirements
351      *
352      * - the caller must have at least `amount` tokens.
353      * - `recipient` cannot be the zero address.
354      * - if `recipient` is a contract, it must implement the `tokensReceived`
355      * interface.
356      */
357     function send(address recipient, uint256 amount, bytes calldata data) external;
358 
359     /**
360      * @dev Destroys `amount` tokens from the caller's account, reducing the
361      * total supply.
362      *
363      * If a send hook is registered for the caller, the corresponding function
364      * will be called with `data` and empty `operatorData`. See `IERC777Sender`.
365      *
366      * Emits a `Burned` event.
367      *
368      * Requirements
369      *
370      * - the caller must have at least `amount` tokens.
371      */
372     function burn(uint256 amount, bytes calldata data) external;
373 
374     /**
375      * @dev Returns true if an account is an operator of `tokenHolder`.
376      * Operators can send and burn tokens on behalf of their owners. All
377      * accounts are their own operator.
378      *
379      * See `operatorSend` and `operatorBurn`.
380      */
381     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
382 
383     /**
384      * @dev Make an account an operator of the caller.
385      *
386      * See `isOperatorFor`.
387      *
388      * Emits an `AuthorizedOperator` event.
389      *
390      * Requirements
391      *
392      * - `operator` cannot be calling address.
393      */
394     function authorizeOperator(address operator) external;
395 
396     /**
397      * @dev Make an account an operator of the caller.
398      *
399      * See `isOperatorFor` and `defaultOperators`.
400      *
401      * Emits a `RevokedOperator` event.
402      *
403      * Requirements
404      *
405      * - `operator` cannot be calling address.
406      */
407     function revokeOperator(address operator) external;
408 
409     /**
410      * @dev Returns the list of default operators. These accounts are operators
411      * for all token holders, even if `authorizeOperator` was never called on
412      * them.
413      *
414      * This list is immutable, but individual holders may revoke these via
415      * `revokeOperator`, in which case `isOperatorFor` will return false.
416      */
417     function defaultOperators() external view returns (address[] memory);
418 
419     /**
420      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
421      * be an operator of `sender`.
422      *
423      * If send or receive hooks are registered for `sender` and `recipient`,
424      * the corresponding functions will be called with `data` and
425      * `operatorData`. See `IERC777Sender` and `IERC777Recipient`.
426      *
427      * Emits a `Sent` event.
428      *
429      * Requirements
430      *
431      * - `sender` cannot be the zero address.
432      * - `sender` must have at least `amount` tokens.
433      * - the caller must be an operator for `sender`.
434      * - `recipient` cannot be the zero address.
435      * - if `recipient` is a contract, it must implement the `tokensReceived`
436      * interface.
437      */
438     function operatorSend(
439         address sender,
440         address recipient,
441         uint256 amount,
442         bytes calldata data,
443         bytes calldata operatorData
444     ) external;
445 
446     /**
447      * @dev Destoys `amount` tokens from `account`, reducing the total supply.
448      * The caller must be an operator of `account`.
449      *
450      * If a send hook is registered for `account`, the corresponding function
451      * will be called with `data` and `operatorData`. See `IERC777Sender`.
452      *
453      * Emits a `Burned` event.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      * - the caller must be an operator for `account`.
460      */
461     function operatorBurn(
462         address account,
463         uint256 amount,
464         bytes calldata data,
465         bytes calldata operatorData
466     ) external;
467 
468     event Sent(
469         address indexed operator,
470         address indexed from,
471         address indexed to,
472         uint256 amount,
473         bytes data,
474         bytes operatorData
475     );
476 
477     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
478 
479     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
480 
481     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
482 
483     event RevokedOperator(address indexed operator, address indexed tokenHolder);
484 }
485 
486 // File: openzeppelin-solidity/contracts/token/ERC777/IERC777Recipient.sol
487 
488 pragma solidity ^0.5.0;
489 
490 /**
491  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
492  *
493  * Accounts can be notified of `IERC777` tokens being sent to them by having a
494  * contract implement this interface (contract holders can be their own
495  * implementer) and registering it on the
496  * [ERC1820 global registry](https://eips.ethereum.org/EIPS/eip-1820).
497  *
498  * See `IERC1820Registry` and `ERC1820Implementer`.
499  */
500 interface IERC777Recipient {
501     /**
502      * @dev Called by an `IERC777` token contract whenever tokens are being
503      * moved or created into a registered account (`to`). The type of operation
504      * is conveyed by `from` being the zero address or not.
505      *
506      * This call occurs _after_ the token contract's state is updated, so
507      * `IERC777.balanceOf`, etc., can be used to query the post-operation state.
508      *
509      * This function may revert to prevent the operation from being executed.
510      */
511     function tokensReceived(
512         address operator,
513         address from,
514         address to,
515         uint amount,
516         bytes calldata userData,
517         bytes calldata operatorData
518     ) external;
519 }
520 
521 // File: openzeppelin-solidity/contracts/token/ERC777/IERC777Sender.sol
522 
523 pragma solidity ^0.5.0;
524 
525 /**
526  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
527  *
528  * `IERC777` Token holders can be notified of operations performed on their
529  * tokens by having a contract implement this interface (contract holders can be
530  *  their own implementer) and registering it on the
531  * [ERC1820 global registry](https://eips.ethereum.org/EIPS/eip-1820).
532  *
533  * See `IERC1820Registry` and `ERC1820Implementer`.
534  */
535 interface IERC777Sender {
536     /**
537      * @dev Called by an `IERC777` token contract whenever a registered holder's
538      * (`from`) tokens are about to be moved or destroyed. The type of operation
539      * is conveyed by `to` being the zero address or not.
540      *
541      * This call occurs _before_ the token contract's state is updated, so
542      * `IERC777.balanceOf`, etc., can be used to query the pre-operation state.
543      *
544      * This function may revert to prevent the operation from being executed.
545      */
546     function tokensToSend(
547         address operator,
548         address from,
549         address to,
550         uint amount,
551         bytes calldata userData,
552         bytes calldata operatorData
553     ) external;
554 }
555 
556 // File: openzeppelin-solidity/contracts/introspection/IERC1820Registry.sol
557 
558 pragma solidity ^0.5.0;
559 
560 /**
561  * @dev Interface of the global ERC1820 Registry, as defined in the
562  * [EIP](https://eips.ethereum.org/EIPS/eip-1820). Accounts may register
563  * implementers for interfaces in this registry, as well as query support.
564  *
565  * Implementers may be shared by multiple accounts, and can also implement more
566  * than a single interface for each account. Contracts can implement interfaces
567  * for themselves, but externally-owned accounts (EOA) must delegate this to a
568  * contract.
569  *
570  * `IERC165` interfaces can also be queried via the registry.
571  *
572  * For an in-depth explanation and source code analysis, see the EIP text.
573  */
574 interface IERC1820Registry {
575     /**
576      * @dev Sets `newManager` as the manager for `account`. A manager of an
577      * account is able to set interface implementers for it.
578      *
579      * By default, each account is its own manager. Passing a value of `0x0` in
580      * `newManager` will reset the manager to this initial state.
581      *
582      * Emits a `ManagerChanged` event.
583      *
584      * Requirements:
585      *
586      * - the caller must be the current manager for `account`.
587      */
588     function setManager(address account, address newManager) external;
589 
590     /**
591      * @dev Returns the manager for `account`.
592      *
593      * See `setManager`.
594      */
595     function getManager(address account) external view returns (address);
596 
597     /**
598      * @dev Sets the `implementer` contract as `account`'s implementer for
599      * `interfaceHash`.
600      *
601      * `account` being the zero address is an alias for the caller's address.
602      * The zero address can also be used in `implementer` to remove an old one.
603      *
604      * See `interfaceHash` to learn how these are created.
605      *
606      * Emits an `InterfaceImplementerSet` event.
607      *
608      * Requirements:
609      *
610      * - the caller must be the current manager for `account`.
611      * - `interfaceHash` must not be an `IERC165` interface id (i.e. it must not
612      * end in 28 zeroes).
613      * - `implementer` must implement `IERC1820Implementer` and return true when
614      * queried for support, unless `implementer` is the caller. See
615      * `IERC1820Implementer.canImplementInterfaceForAddress`.
616      */
617     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
618 
619     /**
620      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
621      * implementer is registered, returns the zero address.
622      *
623      * If `interfaceHash` is an `IERC165` interface id (i.e. it ends with 28
624      * zeroes), `account` will be queried for support of it.
625      *
626      * `account` being the zero address is an alias for the caller's address.
627      */
628     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
629 
630     /**
631      * @dev Returns the interface hash for an `interfaceName`, as defined in the
632      * corresponding
633      * [section of the EIP](https://eips.ethereum.org/EIPS/eip-1820#interface-name).
634      */
635     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
636 
637     /**
638      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
639      *  @param account Address of the contract for which to update the cache.
640      *  @param interfaceId ERC165 interface for which to update the cache.
641      */
642     function updateERC165Cache(address account, bytes4 interfaceId) external;
643 
644     /**
645      *  @notice Checks whether a contract implements an ERC165 interface or not.
646      *  If the result is not cached a direct lookup on the contract address is performed.
647      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
648      *  'updateERC165Cache' with the contract address.
649      *  @param account Address of the contract to check.
650      *  @param interfaceId ERC165 interface to check.
651      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
652      */
653     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
654 
655     /**
656      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
657      *  @param account Address of the contract to check.
658      *  @param interfaceId ERC165 interface to check.
659      *  @return True if `account.address()` implements `interfaceId`, false otherwise.
660      */
661     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
662 
663     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
664 
665     event ManagerChanged(address indexed account, address indexed newManager);
666 }
667 
668 // File: openzeppelin-solidity/contracts/token/ERC777/ERC777.sol
669 
670 pragma solidity ^0.5.0;
671 
672 
673 
674 
675 
676 
677 
678 
679 /**
680  * @dev Implementation of the `IERC777` interface.
681  *
682  * This implementation is agnostic to the way tokens are created. This means
683  * that a supply mechanism has to be added in a derived contract using `_mint`.
684  *
685  * Support for ERC20 is included in this contract, as specified by the EIP: both
686  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
687  * Both `IERC777.Sent` and `IERC20.Transfer` events are emitted on token
688  * movements.
689  *
690  * Additionally, the `granularity` value is hard-coded to `1`, meaning that there
691  * are no special restrictions in the amount of tokens that created, moved, or
692  * destroyed. This makes integration with ERC20 applications seamless.
693  */
694 contract ERC777 is IERC777, IERC20 {
695     using SafeMath for uint256;
696     using Address for address;
697 
698     IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
699 
700     mapping(address => uint256) private _balances;
701 
702     uint256 private _totalSupply;
703 
704     string private _name;
705     string private _symbol;
706 
707     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
708     // See https://github.com/ethereum/solidity/issues/4024.
709 
710     // keccak256("ERC777TokensSender")
711     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
712         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
713 
714     // keccak256("ERC777TokensRecipient")
715     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
716         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
717 
718     // This isn't ever read from - it's only used to respond to the defaultOperators query.
719     address[] private _defaultOperatorsArray;
720 
721     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
722     mapping(address => bool) private _defaultOperators;
723 
724     // For each account, a mapping of its operators and revoked default operators.
725     mapping(address => mapping(address => bool)) private _operators;
726     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
727 
728     // ERC20-allowances
729     mapping (address => mapping (address => uint256)) private _allowances;
730 
731     /**
732      * @dev `defaultOperators` may be an empty array.
733      */
734     constructor(
735         string memory name,
736         string memory symbol,
737         address[] memory defaultOperators
738     ) public {
739         _name = name;
740         _symbol = symbol;
741 
742         _defaultOperatorsArray = defaultOperators;
743         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
744             _defaultOperators[_defaultOperatorsArray[i]] = true;
745         }
746 
747         // register interfaces
748         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
749         _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
750     }
751 
752     /**
753      * @dev See `IERC777.name`.
754      */
755     function name() public view returns (string memory) {
756         return _name;
757     }
758 
759     /**
760      * @dev See `IERC777.symbol`.
761      */
762     function symbol() public view returns (string memory) {
763         return _symbol;
764     }
765 
766     /**
767      * @dev See `ERC20Detailed.decimals`.
768      *
769      * Always returns 18, as per the
770      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
771      */
772     function decimals() public pure returns (uint8) {
773         return 18;
774     }
775 
776     /**
777      * @dev See `IERC777.granularity`.
778      *
779      * This implementation always returns `1`.
780      */
781     function granularity() public view returns (uint256) {
782         return 1;
783     }
784 
785     /**
786      * @dev See `IERC777.totalSupply`.
787      */
788     function totalSupply() public view returns (uint256) {
789         return _totalSupply;
790     }
791 
792     /**
793      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
794      */
795     function balanceOf(address tokenHolder) public view returns (uint256) {
796         return _balances[tokenHolder];
797     }
798 
799     /**
800      * @dev See `IERC777.send`.
801      *
802      * Also emits a `Transfer` event for ERC20 compatibility.
803      */
804     function send(address recipient, uint256 amount, bytes calldata data) external {
805         _send(msg.sender, msg.sender, recipient, amount, data, "", true);
806     }
807 
808     /**
809      * @dev See `IERC20.transfer`.
810      *
811      * Unlike `send`, `recipient` is _not_ required to implement the `tokensReceived`
812      * interface if it is a contract.
813      *
814      * Also emits a `Sent` event.
815      */
816     function transfer(address recipient, uint256 amount) external returns (bool) {
817         require(recipient != address(0), "ERC777: transfer to the zero address");
818 
819         address from = msg.sender;
820 
821         _callTokensToSend(from, from, recipient, amount, "", "");
822 
823         _move(from, from, recipient, amount, "", "");
824 
825         _callTokensReceived(from, from, recipient, amount, "", "", false);
826 
827         return true;
828     }
829 
830     /**
831      * @dev See `IERC777.burn`.
832      *
833      * Also emits a `Transfer` event for ERC20 compatibility.
834      */
835     function burn(uint256 amount, bytes calldata data) external {
836         _burn(msg.sender, msg.sender, amount, data, "");
837     }
838 
839     /**
840      * @dev See `IERC777.isOperatorFor`.
841      */
842     function isOperatorFor(
843         address operator,
844         address tokenHolder
845     ) public view returns (bool) {
846         return operator == tokenHolder ||
847             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
848             _operators[tokenHolder][operator];
849     }
850 
851     /**
852      * @dev See `IERC777.authorizeOperator`.
853      */
854     function authorizeOperator(address operator) external {
855         require(msg.sender != operator, "ERC777: authorizing self as operator");
856 
857         if (_defaultOperators[operator]) {
858             delete _revokedDefaultOperators[msg.sender][operator];
859         } else {
860             _operators[msg.sender][operator] = true;
861         }
862 
863         emit AuthorizedOperator(operator, msg.sender);
864     }
865 
866     /**
867      * @dev See `IERC777.revokeOperator`.
868      */
869     function revokeOperator(address operator) external {
870         require(operator != msg.sender, "ERC777: revoking self as operator");
871 
872         if (_defaultOperators[operator]) {
873             _revokedDefaultOperators[msg.sender][operator] = true;
874         } else {
875             delete _operators[msg.sender][operator];
876         }
877 
878         emit RevokedOperator(operator, msg.sender);
879     }
880 
881     /**
882      * @dev See `IERC777.defaultOperators`.
883      */
884     function defaultOperators() public view returns (address[] memory) {
885         return _defaultOperatorsArray;
886     }
887 
888     /**
889      * @dev See `IERC777.operatorSend`.
890      *
891      * Emits `Sent` and `Transfer` events.
892      */
893     function operatorSend(
894         address sender,
895         address recipient,
896         uint256 amount,
897         bytes calldata data,
898         bytes calldata operatorData
899     )
900     external
901     {
902         require(isOperatorFor(msg.sender, sender), "ERC777: caller is not an operator for holder");
903         _send(msg.sender, sender, recipient, amount, data, operatorData, true);
904     }
905 
906     /**
907      * @dev See `IERC777.operatorBurn`.
908      *
909      * Emits `Sent` and `Transfer` events.
910      */
911     function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData) external {
912         require(isOperatorFor(msg.sender, account), "ERC777: caller is not an operator for holder");
913         _burn(msg.sender, account, amount, data, operatorData);
914     }
915 
916     /**
917      * @dev See `IERC20.allowance`.
918      *
919      * Note that operator and allowance concepts are orthogonal: operators may
920      * not have allowance, and accounts with allowance may not be operators
921      * themselves.
922      */
923     function allowance(address holder, address spender) public view returns (uint256) {
924         return _allowances[holder][spender];
925     }
926 
927     /**
928      * @dev See `IERC20.approve`.
929      *
930      * Note that accounts cannot have allowance issued by their operators.
931      */
932     function approve(address spender, uint256 value) external returns (bool) {
933         address holder = msg.sender;
934         _approve(holder, spender, value);
935         return true;
936     }
937 
938    /**
939     * @dev See `IERC20.transferFrom`.
940     *
941     * Note that operator and allowance concepts are orthogonal: operators cannot
942     * call `transferFrom` (unless they have allowance), and accounts with
943     * allowance cannot call `operatorSend` (unless they are operators).
944     *
945     * Emits `Sent` and `Transfer` events.
946     */
947     function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) {
948         require(recipient != address(0), "ERC777: transfer to the zero address");
949         require(holder != address(0), "ERC777: transfer from the zero address");
950 
951         address spender = msg.sender;
952 
953         _callTokensToSend(spender, holder, recipient, amount, "", "");
954 
955         _move(spender, holder, recipient, amount, "", "");
956         _approve(holder, spender, _allowances[holder][spender].sub(amount));
957 
958         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
959 
960         return true;
961     }
962 
963     /**
964      * @dev Creates `amount` tokens and assigns them to `account`, increasing
965      * the total supply.
966      *
967      * If a send hook is registered for `raccount`, the corresponding function
968      * will be called with `operator`, `data` and `operatorData`.
969      *
970      * See `IERC777Sender` and `IERC777Recipient`.
971      *
972      * Emits `Sent` and `Transfer` events.
973      *
974      * Requirements
975      *
976      * - `account` cannot be the zero address.
977      * - if `account` is a contract, it must implement the `tokensReceived`
978      * interface.
979      */
980     function _mint(
981         address operator,
982         address account,
983         uint256 amount,
984         bytes memory userData,
985         bytes memory operatorData
986     )
987     internal
988     {
989         require(account != address(0), "ERC777: mint to the zero address");
990 
991         // Update state variables
992         _totalSupply = _totalSupply.add(amount);
993         _balances[account] = _balances[account].add(amount);
994 
995         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
996 
997         emit Minted(operator, account, amount, userData, operatorData);
998         emit Transfer(address(0), account, amount);
999     }
1000 
1001     /**
1002      * @dev Send tokens
1003      * @param operator address operator requesting the transfer
1004      * @param from address token holder address
1005      * @param to address recipient address
1006      * @param amount uint256 amount of tokens to transfer
1007      * @param userData bytes extra information provided by the token holder (if any)
1008      * @param operatorData bytes extra information provided by the operator (if any)
1009      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1010      */
1011     function _send(
1012         address operator,
1013         address from,
1014         address to,
1015         uint256 amount,
1016         bytes memory userData,
1017         bytes memory operatorData,
1018         bool requireReceptionAck
1019     )
1020         private
1021     {
1022         require(from != address(0), "ERC777: send from the zero address");
1023         require(to != address(0), "ERC777: send to the zero address");
1024 
1025         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1026 
1027         _move(operator, from, to, amount, userData, operatorData);
1028 
1029         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1030     }
1031 
1032     /**
1033      * @dev Burn tokens
1034      * @param operator address operator requesting the operation
1035      * @param from address token holder address
1036      * @param amount uint256 amount of tokens to burn
1037      * @param data bytes extra information provided by the token holder
1038      * @param operatorData bytes extra information provided by the operator (if any)
1039      */
1040     function _burn(
1041         address operator,
1042         address from,
1043         uint256 amount,
1044         bytes memory data,
1045         bytes memory operatorData
1046     )
1047         private
1048     {
1049         require(from != address(0), "ERC777: burn from the zero address");
1050 
1051         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1052 
1053         // Update state variables
1054         _totalSupply = _totalSupply.sub(amount);
1055         _balances[from] = _balances[from].sub(amount);
1056 
1057         emit Burned(operator, from, amount, data, operatorData);
1058         emit Transfer(from, address(0), amount);
1059     }
1060 
1061     function _move(
1062         address operator,
1063         address from,
1064         address to,
1065         uint256 amount,
1066         bytes memory userData,
1067         bytes memory operatorData
1068     )
1069         private
1070     {
1071         _balances[from] = _balances[from].sub(amount);
1072         _balances[to] = _balances[to].add(amount);
1073 
1074         emit Sent(operator, from, to, amount, userData, operatorData);
1075         emit Transfer(from, to, amount);
1076     }
1077 
1078     function _approve(address holder, address spender, uint256 value) private {
1079         // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
1080         // currently unnecessary.
1081         //require(holder != address(0), "ERC777: approve from the zero address");
1082         require(spender != address(0), "ERC777: approve to the zero address");
1083 
1084         _allowances[holder][spender] = value;
1085         emit Approval(holder, spender, value);
1086     }
1087 
1088     /**
1089      * @dev Call from.tokensToSend() if the interface is registered
1090      * @param operator address operator requesting the transfer
1091      * @param from address token holder address
1092      * @param to address recipient address
1093      * @param amount uint256 amount of tokens to transfer
1094      * @param userData bytes extra information provided by the token holder (if any)
1095      * @param operatorData bytes extra information provided by the operator (if any)
1096      */
1097     function _callTokensToSend(
1098         address operator,
1099         address from,
1100         address to,
1101         uint256 amount,
1102         bytes memory userData,
1103         bytes memory operatorData
1104     )
1105         private
1106     {
1107         address implementer = _erc1820.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
1108         if (implementer != address(0)) {
1109             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1110         }
1111     }
1112 
1113     /**
1114      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1115      * tokensReceived() was not registered for the recipient
1116      * @param operator address operator requesting the transfer
1117      * @param from address token holder address
1118      * @param to address recipient address
1119      * @param amount uint256 amount of tokens to transfer
1120      * @param userData bytes extra information provided by the token holder (if any)
1121      * @param operatorData bytes extra information provided by the operator (if any)
1122      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1123      */
1124     function _callTokensReceived(
1125         address operator,
1126         address from,
1127         address to,
1128         uint256 amount,
1129         bytes memory userData,
1130         bytes memory operatorData,
1131         bool requireReceptionAck
1132     )
1133         private
1134     {
1135         address implementer = _erc1820.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
1136         if (implementer != address(0)) {
1137             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1138         } else if (requireReceptionAck) {
1139             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1140         }
1141     }
1142 }
1143 
1144 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1145 
1146 pragma solidity ^0.5.0;
1147 
1148 /**
1149  * @dev Contract module which provides a basic access control mechanism, where
1150  * there is an account (an owner) that can be granted exclusive access to
1151  * specific functions.
1152  *
1153  * This module is used through inheritance. It will make available the modifier
1154  * `onlyOwner`, which can be aplied to your functions to restrict their use to
1155  * the owner.
1156  */
1157 contract Ownable {
1158     address private _owner;
1159 
1160     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1161 
1162     /**
1163      * @dev Initializes the contract setting the deployer as the initial owner.
1164      */
1165     constructor () internal {
1166         _owner = msg.sender;
1167         emit OwnershipTransferred(address(0), _owner);
1168     }
1169 
1170     /**
1171      * @dev Returns the address of the current owner.
1172      */
1173     function owner() public view returns (address) {
1174         return _owner;
1175     }
1176 
1177     /**
1178      * @dev Throws if called by any account other than the owner.
1179      */
1180     modifier onlyOwner() {
1181         require(isOwner(), "Ownable: caller is not the owner");
1182         _;
1183     }
1184 
1185     /**
1186      * @dev Returns true if the caller is the current owner.
1187      */
1188     function isOwner() public view returns (bool) {
1189         return msg.sender == _owner;
1190     }
1191 
1192     /**
1193      * @dev Leaves the contract without owner. It will not be possible to call
1194      * `onlyOwner` functions anymore. Can only be called by the current owner.
1195      *
1196      * > Note: Renouncing ownership will leave the contract without an owner,
1197      * thereby removing any functionality that is only available to the owner.
1198      */
1199     function renounceOwnership() public onlyOwner {
1200         emit OwnershipTransferred(_owner, address(0));
1201         _owner = address(0);
1202     }
1203 
1204     /**
1205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1206      * Can only be called by the current owner.
1207      */
1208     function transferOwnership(address newOwner) public onlyOwner {
1209         _transferOwnership(newOwner);
1210     }
1211 
1212     /**
1213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1214      */
1215     function _transferOwnership(address newOwner) internal {
1216         require(newOwner != address(0), "Ownable: new owner is the zero address");
1217         emit OwnershipTransferred(_owner, newOwner);
1218         _owner = newOwner;
1219     }
1220 }
1221 
1222 // File: contracts/Withdrawable.sol
1223 
1224 pragma solidity ^0.5.0;
1225 
1226 
1227 
1228 
1229 contract Withdrawable is Ownable {
1230     using SafeERC20 for IERC20;
1231 
1232     function withdraw(address asset) onlyOwner public {
1233         if (asset == address(0)) {
1234             msg.sender.transfer(address(this).balance);
1235         } else {
1236             IERC20 token = IERC20(asset);
1237             token.safeTransfer(msg.sender, token.balanceOf(address(this)));
1238         }
1239     }
1240 }
1241 
1242 // File: contracts/BurnAccounting.sol
1243 
1244 pragma solidity ^0.5.0;
1245 
1246 
1247 
1248 
1249 
1250 
1251 contract BurnAccounting is Withdrawable {
1252     using SafeMath for uint256;
1253     using SafeERC20 for IERC20;
1254 
1255     address token;
1256 
1257     mapping (address => uint) public burnedBy;
1258 
1259     event Burn(address account, uint amount);
1260 
1261     constructor(address tokenAddress) public {
1262         token = tokenAddress;
1263     }
1264 
1265     function burn(uint amount) public {
1266         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1267         ERC777(token).burn(amount, '');
1268         burnedBy[msg.sender] = burnedBy[msg.sender].add(amount);
1269         emit Burn(msg.sender, amount);
1270     }
1271 
1272 }