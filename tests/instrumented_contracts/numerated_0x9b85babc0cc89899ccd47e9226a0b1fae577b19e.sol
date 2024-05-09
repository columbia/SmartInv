1 // Sources flattened with buidler v1.4.3 https://buidler.dev
2 
3 // File @openzeppelin/contracts/GSN/Context.sol@v3.1.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
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
30 
31 // File @openzeppelin/contracts/token/ERC777/IERC777.sol@v3.1.0
32 
33 pragma solidity ^0.6.0;
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
131      * @dev Revoke an account's operator status for the caller.
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
181      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
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
220 
221 // File @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol@v3.1.0
222 
223 pragma solidity ^0.6.0;
224 
225 /**
226  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
227  *
228  * Accounts can be notified of {IERC777} tokens being sent to them by having a
229  * contract implement this interface (contract holders can be their own
230  * implementer) and registering it on the
231  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
232  *
233  * See {IERC1820Registry} and {ERC1820Implementer}.
234  */
235 interface IERC777Recipient {
236     /**
237      * @dev Called by an {IERC777} token contract whenever tokens are being
238      * moved or created into a registered account (`to`). The type of operation
239      * is conveyed by `from` being the zero address or not.
240      *
241      * This call occurs _after_ the token contract's state is updated, so
242      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
243      *
244      * This function may revert to prevent the operation from being executed.
245      */
246     function tokensReceived(
247         address operator,
248         address from,
249         address to,
250         uint256 amount,
251         bytes calldata userData,
252         bytes calldata operatorData
253     ) external;
254 }
255 
256 
257 // File @openzeppelin/contracts/token/ERC777/IERC777Sender.sol@v3.1.0
258 
259 pragma solidity ^0.6.0;
260 
261 /**
262  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
263  *
264  * {IERC777} Token holders can be notified of operations performed on their
265  * tokens by having a contract implement this interface (contract holders can be
266  *  their own implementer) and registering it on the
267  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
268  *
269  * See {IERC1820Registry} and {ERC1820Implementer}.
270  */
271 interface IERC777Sender {
272     /**
273      * @dev Called by an {IERC777} token contract whenever a registered holder's
274      * (`from`) tokens are about to be moved or destroyed. The type of operation
275      * is conveyed by `to` being the zero address or not.
276      *
277      * This call occurs _before_ the token contract's state is updated, so
278      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
279      *
280      * This function may revert to prevent the operation from being executed.
281      */
282     function tokensToSend(
283         address operator,
284         address from,
285         address to,
286         uint256 amount,
287         bytes calldata userData,
288         bytes calldata operatorData
289     ) external;
290 }
291 
292 
293 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.1.0
294 
295 pragma solidity ^0.6.0;
296 
297 /**
298  * @dev Interface of the ERC20 standard as defined in the EIP.
299  */
300 interface IERC20 {
301     /**
302      * @dev Returns the amount of tokens in existence.
303      */
304     function totalSupply() external view returns (uint256);
305 
306     /**
307      * @dev Returns the amount of tokens owned by `account`.
308      */
309     function balanceOf(address account) external view returns (uint256);
310 
311     /**
312      * @dev Moves `amount` tokens from the caller's account to `recipient`.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transfer(address recipient, uint256 amount) external returns (bool);
319 
320     /**
321      * @dev Returns the remaining number of tokens that `spender` will be
322      * allowed to spend on behalf of `owner` through {transferFrom}. This is
323      * zero by default.
324      *
325      * This value changes when {approve} or {transferFrom} are called.
326      */
327     function allowance(address owner, address spender) external view returns (uint256);
328 
329     /**
330      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
331      *
332      * Returns a boolean value indicating whether the operation succeeded.
333      *
334      * IMPORTANT: Beware that changing an allowance with this method brings the risk
335      * that someone may use both the old and the new allowance by unfortunate
336      * transaction ordering. One possible solution to mitigate this race
337      * condition is to first reduce the spender's allowance to 0 and set the
338      * desired value afterwards:
339      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
340      *
341      * Emits an {Approval} event.
342      */
343     function approve(address spender, uint256 amount) external returns (bool);
344 
345     /**
346      * @dev Moves `amount` tokens from `sender` to `recipient` using the
347      * allowance mechanism. `amount` is then deducted from the caller's
348      * allowance.
349      *
350      * Returns a boolean value indicating whether the operation succeeded.
351      *
352      * Emits a {Transfer} event.
353      */
354     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
355 
356     /**
357      * @dev Emitted when `value` tokens are moved from one account (`from`) to
358      * another (`to`).
359      *
360      * Note that `value` may be zero.
361      */
362     event Transfer(address indexed from, address indexed to, uint256 value);
363 
364     /**
365      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
366      * a call to {approve}. `value` is the new allowance.
367      */
368     event Approval(address indexed owner, address indexed spender, uint256 value);
369 }
370 
371 
372 // File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0
373 
374 pragma solidity ^0.6.0;
375 
376 /**
377  * @dev Wrappers over Solidity's arithmetic operations with added overflow
378  * checks.
379  *
380  * Arithmetic operations in Solidity wrap on overflow. This can easily result
381  * in bugs, because programmers usually assume that an overflow raises an
382  * error, which is the standard behavior in high level programming languages.
383  * `SafeMath` restores this intuition by reverting the transaction when an
384  * operation overflows.
385  *
386  * Using this library instead of the unchecked operations eliminates an entire
387  * class of bugs, so it's recommended to use it always.
388  */
389 library SafeMath {
390     /**
391      * @dev Returns the addition of two unsigned integers, reverting on
392      * overflow.
393      *
394      * Counterpart to Solidity's `+` operator.
395      *
396      * Requirements:
397      *
398      * - Addition cannot overflow.
399      */
400     function add(uint256 a, uint256 b) internal pure returns (uint256) {
401         uint256 c = a + b;
402         require(c >= a, "SafeMath: addition overflow");
403 
404         return c;
405     }
406 
407     /**
408      * @dev Returns the subtraction of two unsigned integers, reverting on
409      * overflow (when the result is negative).
410      *
411      * Counterpart to Solidity's `-` operator.
412      *
413      * Requirements:
414      *
415      * - Subtraction cannot overflow.
416      */
417     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
418         return sub(a, b, "SafeMath: subtraction overflow");
419     }
420 
421     /**
422      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
423      * overflow (when the result is negative).
424      *
425      * Counterpart to Solidity's `-` operator.
426      *
427      * Requirements:
428      *
429      * - Subtraction cannot overflow.
430      */
431     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
432         require(b <= a, errorMessage);
433         uint256 c = a - b;
434 
435         return c;
436     }
437 
438     /**
439      * @dev Returns the multiplication of two unsigned integers, reverting on
440      * overflow.
441      *
442      * Counterpart to Solidity's `*` operator.
443      *
444      * Requirements:
445      *
446      * - Multiplication cannot overflow.
447      */
448     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
449         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
450         // benefit is lost if 'b' is also tested.
451         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
452         if (a == 0) {
453             return 0;
454         }
455 
456         uint256 c = a * b;
457         require(c / a == b, "SafeMath: multiplication overflow");
458 
459         return c;
460     }
461 
462     /**
463      * @dev Returns the integer division of two unsigned integers. Reverts on
464      * division by zero. The result is rounded towards zero.
465      *
466      * Counterpart to Solidity's `/` operator. Note: this function uses a
467      * `revert` opcode (which leaves remaining gas untouched) while Solidity
468      * uses an invalid opcode to revert (consuming all remaining gas).
469      *
470      * Requirements:
471      *
472      * - The divisor cannot be zero.
473      */
474     function div(uint256 a, uint256 b) internal pure returns (uint256) {
475         return div(a, b, "SafeMath: division by zero");
476     }
477 
478     /**
479      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
480      * division by zero. The result is rounded towards zero.
481      *
482      * Counterpart to Solidity's `/` operator. Note: this function uses a
483      * `revert` opcode (which leaves remaining gas untouched) while Solidity
484      * uses an invalid opcode to revert (consuming all remaining gas).
485      *
486      * Requirements:
487      *
488      * - The divisor cannot be zero.
489      */
490     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
491         require(b > 0, errorMessage);
492         uint256 c = a / b;
493         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
494 
495         return c;
496     }
497 
498     /**
499      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
500      * Reverts when dividing by zero.
501      *
502      * Counterpart to Solidity's `%` operator. This function uses a `revert`
503      * opcode (which leaves remaining gas untouched) while Solidity uses an
504      * invalid opcode to revert (consuming all remaining gas).
505      *
506      * Requirements:
507      *
508      * - The divisor cannot be zero.
509      */
510     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
511         return mod(a, b, "SafeMath: modulo by zero");
512     }
513 
514     /**
515      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
516      * Reverts with custom message when dividing by zero.
517      *
518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
519      * opcode (which leaves remaining gas untouched) while Solidity uses an
520      * invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
527         require(b != 0, errorMessage);
528         return a % b;
529     }
530 }
531 
532 
533 // File @openzeppelin/contracts/utils/Address.sol@v3.1.0
534 
535 pragma solidity ^0.6.2;
536 
537 /**
538  * @dev Collection of functions related to the address type
539  */
540 library Address {
541     /**
542      * @dev Returns true if `account` is a contract.
543      *
544      * [IMPORTANT]
545      * ====
546      * It is unsafe to assume that an address for which this function returns
547      * false is an externally-owned account (EOA) and not a contract.
548      *
549      * Among others, `isContract` will return false for the following
550      * types of addresses:
551      *
552      *  - an externally-owned account
553      *  - a contract in construction
554      *  - an address where a contract will be created
555      *  - an address where a contract lived, but was destroyed
556      * ====
557      */
558     function isContract(address account) internal view returns (bool) {
559         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
560         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
561         // for accounts without code, i.e. `keccak256('')`
562         bytes32 codehash;
563         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
564         // solhint-disable-next-line no-inline-assembly
565         assembly { codehash := extcodehash(account) }
566         return (codehash != accountHash && codehash != 0x0);
567     }
568 
569     /**
570      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
571      * `recipient`, forwarding all available gas and reverting on errors.
572      *
573      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
574      * of certain opcodes, possibly making contracts go over the 2300 gas limit
575      * imposed by `transfer`, making them unable to receive funds via
576      * `transfer`. {sendValue} removes this limitation.
577      *
578      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
579      *
580      * IMPORTANT: because control is transferred to `recipient`, care must be
581      * taken to not create reentrancy vulnerabilities. Consider using
582      * {ReentrancyGuard} or the
583      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
584      */
585     function sendValue(address payable recipient, uint256 amount) internal {
586         require(address(this).balance >= amount, "Address: insufficient balance");
587 
588         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
589         (bool success, ) = recipient.call{ value: amount }("");
590         require(success, "Address: unable to send value, recipient may have reverted");
591     }
592 
593     /**
594      * @dev Performs a Solidity function call using a low level `call`. A
595      * plain`call` is an unsafe replacement for a function call: use this
596      * function instead.
597      *
598      * If `target` reverts with a revert reason, it is bubbled up by this
599      * function (like regular Solidity function calls).
600      *
601      * Returns the raw returned data. To convert to the expected return value,
602      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
603      *
604      * Requirements:
605      *
606      * - `target` must be a contract.
607      * - calling `target` with `data` must not revert.
608      *
609      * _Available since v3.1._
610      */
611     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
612       return functionCall(target, data, "Address: low-level call failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
617      * `errorMessage` as a fallback revert reason when `target` reverts.
618      *
619      * _Available since v3.1._
620      */
621     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
622         return _functionCallWithValue(target, data, 0, errorMessage);
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
627      * but also transferring `value` wei to `target`.
628      *
629      * Requirements:
630      *
631      * - the calling contract must have an ETH balance of at least `value`.
632      * - the called Solidity function must be `payable`.
633      *
634      * _Available since v3.1._
635      */
636     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
637         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
642      * with `errorMessage` as a fallback revert reason when `target` reverts.
643      *
644      * _Available since v3.1._
645      */
646     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
647         require(address(this).balance >= value, "Address: insufficient balance for call");
648         return _functionCallWithValue(target, data, value, errorMessage);
649     }
650 
651     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
652         require(isContract(target), "Address: call to non-contract");
653 
654         // solhint-disable-next-line avoid-low-level-calls
655         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
656         if (success) {
657             return returndata;
658         } else {
659             // Look for revert reason and bubble it up if present
660             if (returndata.length > 0) {
661                 // The easiest way to bubble the revert reason is using memory via assembly
662 
663                 // solhint-disable-next-line no-inline-assembly
664                 assembly {
665                     let returndata_size := mload(returndata)
666                     revert(add(32, returndata), returndata_size)
667                 }
668             } else {
669                 revert(errorMessage);
670             }
671         }
672     }
673 }
674 
675 
676 // File @openzeppelin/contracts/introspection/IERC1820Registry.sol@v3.1.0
677 
678 pragma solidity ^0.6.0;
679 
680 /**
681  * @dev Interface of the global ERC1820 Registry, as defined in the
682  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
683  * implementers for interfaces in this registry, as well as query support.
684  *
685  * Implementers may be shared by multiple accounts, and can also implement more
686  * than a single interface for each account. Contracts can implement interfaces
687  * for themselves, but externally-owned accounts (EOA) must delegate this to a
688  * contract.
689  *
690  * {IERC165} interfaces can also be queried via the registry.
691  *
692  * For an in-depth explanation and source code analysis, see the EIP text.
693  */
694 interface IERC1820Registry {
695     /**
696      * @dev Sets `newManager` as the manager for `account`. A manager of an
697      * account is able to set interface implementers for it.
698      *
699      * By default, each account is its own manager. Passing a value of `0x0` in
700      * `newManager` will reset the manager to this initial state.
701      *
702      * Emits a {ManagerChanged} event.
703      *
704      * Requirements:
705      *
706      * - the caller must be the current manager for `account`.
707      */
708     function setManager(address account, address newManager) external;
709 
710     /**
711      * @dev Returns the manager for `account`.
712      *
713      * See {setManager}.
714      */
715     function getManager(address account) external view returns (address);
716 
717     /**
718      * @dev Sets the `implementer` contract as ``account``'s implementer for
719      * `interfaceHash`.
720      *
721      * `account` being the zero address is an alias for the caller's address.
722      * The zero address can also be used in `implementer` to remove an old one.
723      *
724      * See {interfaceHash} to learn how these are created.
725      *
726      * Emits an {InterfaceImplementerSet} event.
727      *
728      * Requirements:
729      *
730      * - the caller must be the current manager for `account`.
731      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
732      * end in 28 zeroes).
733      * - `implementer` must implement {IERC1820Implementer} and return true when
734      * queried for support, unless `implementer` is the caller. See
735      * {IERC1820Implementer-canImplementInterfaceForAddress}.
736      */
737     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
738 
739     /**
740      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
741      * implementer is registered, returns the zero address.
742      *
743      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
744      * zeroes), `account` will be queried for support of it.
745      *
746      * `account` being the zero address is an alias for the caller's address.
747      */
748     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
749 
750     /**
751      * @dev Returns the interface hash for an `interfaceName`, as defined in the
752      * corresponding
753      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
754      */
755     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
756 
757     /**
758      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
759      *  @param account Address of the contract for which to update the cache.
760      *  @param interfaceId ERC165 interface for which to update the cache.
761      */
762     function updateERC165Cache(address account, bytes4 interfaceId) external;
763 
764     /**
765      *  @notice Checks whether a contract implements an ERC165 interface or not.
766      *  If the result is not cached a direct lookup on the contract address is performed.
767      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
768      *  {updateERC165Cache} with the contract address.
769      *  @param account Address of the contract to check.
770      *  @param interfaceId ERC165 interface to check.
771      *  @return True if `account` implements `interfaceId`, false otherwise.
772      */
773     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
774 
775     /**
776      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
777      *  @param account Address of the contract to check.
778      *  @param interfaceId ERC165 interface to check.
779      *  @return True if `account` implements `interfaceId`, false otherwise.
780      */
781     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
782 
783     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
784 
785     event ManagerChanged(address indexed account, address indexed newManager);
786 }
787 
788 
789 // File @openzeppelin/contracts/token/ERC777/ERC777.sol@v3.1.0
790 
791 pragma solidity ^0.6.0;
792 
793 
794 
795 
796 
797 
798 
799 
800 
801 /**
802  * @dev Implementation of the {IERC777} interface.
803  *
804  * This implementation is agnostic to the way tokens are created. This means
805  * that a supply mechanism has to be added in a derived contract using {_mint}.
806  *
807  * Support for ERC20 is included in this contract, as specified by the EIP: both
808  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
809  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
810  * movements.
811  *
812  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
813  * are no special restrictions in the amount of tokens that created, moved, or
814  * destroyed. This makes integration with ERC20 applications seamless.
815  */
816 contract ERC777 is Context, IERC777, IERC20 {
817     using SafeMath for uint256;
818     using Address for address;
819 
820     IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
821 
822     mapping(address => uint256) private _balances;
823 
824     uint256 private _totalSupply;
825 
826     string private _name;
827     string private _symbol;
828 
829     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
830     // See https://github.com/ethereum/solidity/issues/4024.
831 
832     // keccak256("ERC777TokensSender")
833     bytes32 constant private _TOKENS_SENDER_INTERFACE_HASH =
834         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
835 
836     // keccak256("ERC777TokensRecipient")
837     bytes32 constant private _TOKENS_RECIPIENT_INTERFACE_HASH =
838         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
839 
840     // This isn't ever read from - it's only used to respond to the defaultOperators query.
841     address[] private _defaultOperatorsArray;
842 
843     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
844     mapping(address => bool) private _defaultOperators;
845 
846     // For each account, a mapping of its operators and revoked default operators.
847     mapping(address => mapping(address => bool)) private _operators;
848     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
849 
850     // ERC20-allowances
851     mapping (address => mapping (address => uint256)) private _allowances;
852 
853     /**
854      * @dev `defaultOperators` may be an empty array.
855      */
856     constructor(
857         string memory name,
858         string memory symbol,
859         address[] memory defaultOperators
860     ) public {
861         _name = name;
862         _symbol = symbol;
863 
864         _defaultOperatorsArray = defaultOperators;
865         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
866             _defaultOperators[_defaultOperatorsArray[i]] = true;
867         }
868 
869         // register interfaces
870         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
871         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
872     }
873 
874     /**
875      * @dev See {IERC777-name}.
876      */
877     function name() public view override returns (string memory) {
878         return _name;
879     }
880 
881     /**
882      * @dev See {IERC777-symbol}.
883      */
884     function symbol() public view override returns (string memory) {
885         return _symbol;
886     }
887 
888     /**
889      * @dev See {ERC20-decimals}.
890      *
891      * Always returns 18, as per the
892      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
893      */
894     function decimals() public pure returns (uint8) {
895         return 18;
896     }
897 
898     /**
899      * @dev See {IERC777-granularity}.
900      *
901      * This implementation always returns `1`.
902      */
903     function granularity() public view override returns (uint256) {
904         return 1;
905     }
906 
907     /**
908      * @dev See {IERC777-totalSupply}.
909      */
910     function totalSupply() public view override(IERC20, IERC777) returns (uint256) {
911         return _totalSupply;
912     }
913 
914     /**
915      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
916      */
917     function balanceOf(address tokenHolder) public view override(IERC20, IERC777) returns (uint256) {
918         return _balances[tokenHolder];
919     }
920 
921     /**
922      * @dev See {IERC777-send}.
923      *
924      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
925      */
926     function send(address recipient, uint256 amount, bytes memory data) public override  {
927         _send(_msgSender(), recipient, amount, data, "", true);
928     }
929 
930     /**
931      * @dev See {IERC20-transfer}.
932      *
933      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
934      * interface if it is a contract.
935      *
936      * Also emits a {Sent} event.
937      */
938     function transfer(address recipient, uint256 amount) public override returns (bool) {
939         require(recipient != address(0), "ERC777: transfer to the zero address");
940 
941         address from = _msgSender();
942 
943         _callTokensToSend(from, from, recipient, amount, "", "");
944 
945         _move(from, from, recipient, amount, "", "");
946 
947         _callTokensReceived(from, from, recipient, amount, "", "", false);
948 
949         return true;
950     }
951 
952     /**
953      * @dev See {IERC777-burn}.
954      *
955      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
956      */
957     function burn(uint256 amount, bytes memory data) public override  {
958         _burn(_msgSender(), amount, data, "");
959     }
960 
961     /**
962      * @dev See {IERC777-isOperatorFor}.
963      */
964     function isOperatorFor(
965         address operator,
966         address tokenHolder
967     ) public view override returns (bool) {
968         return operator == tokenHolder ||
969             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
970             _operators[tokenHolder][operator];
971     }
972 
973     /**
974      * @dev See {IERC777-authorizeOperator}.
975      */
976     function authorizeOperator(address operator) public override  {
977         require(_msgSender() != operator, "ERC777: authorizing self as operator");
978 
979         if (_defaultOperators[operator]) {
980             delete _revokedDefaultOperators[_msgSender()][operator];
981         } else {
982             _operators[_msgSender()][operator] = true;
983         }
984 
985         emit AuthorizedOperator(operator, _msgSender());
986     }
987 
988     /**
989      * @dev See {IERC777-revokeOperator}.
990      */
991     function revokeOperator(address operator) public override  {
992         require(operator != _msgSender(), "ERC777: revoking self as operator");
993 
994         if (_defaultOperators[operator]) {
995             _revokedDefaultOperators[_msgSender()][operator] = true;
996         } else {
997             delete _operators[_msgSender()][operator];
998         }
999 
1000         emit RevokedOperator(operator, _msgSender());
1001     }
1002 
1003     /**
1004      * @dev See {IERC777-defaultOperators}.
1005      */
1006     function defaultOperators() public view override returns (address[] memory) {
1007         return _defaultOperatorsArray;
1008     }
1009 
1010     /**
1011      * @dev See {IERC777-operatorSend}.
1012      *
1013      * Emits {Sent} and {IERC20-Transfer} events.
1014      */
1015     function operatorSend(
1016         address sender,
1017         address recipient,
1018         uint256 amount,
1019         bytes memory data,
1020         bytes memory operatorData
1021     )
1022     public override
1023     {
1024         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
1025         _send(sender, recipient, amount, data, operatorData, true);
1026     }
1027 
1028     /**
1029      * @dev See {IERC777-operatorBurn}.
1030      *
1031      * Emits {Burned} and {IERC20-Transfer} events.
1032      */
1033     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public override {
1034         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
1035         _burn(account, amount, data, operatorData);
1036     }
1037 
1038     /**
1039      * @dev See {IERC20-allowance}.
1040      *
1041      * Note that operator and allowance concepts are orthogonal: operators may
1042      * not have allowance, and accounts with allowance may not be operators
1043      * themselves.
1044      */
1045     function allowance(address holder, address spender) public view override returns (uint256) {
1046         return _allowances[holder][spender];
1047     }
1048 
1049     /**
1050      * @dev See {IERC20-approve}.
1051      *
1052      * Note that accounts cannot have allowance issued by their operators.
1053      */
1054     function approve(address spender, uint256 value) public override returns (bool) {
1055         address holder = _msgSender();
1056         _approve(holder, spender, value);
1057         return true;
1058     }
1059 
1060    /**
1061     * @dev See {IERC20-transferFrom}.
1062     *
1063     * Note that operator and allowance concepts are orthogonal: operators cannot
1064     * call `transferFrom` (unless they have allowance), and accounts with
1065     * allowance cannot call `operatorSend` (unless they are operators).
1066     *
1067     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
1068     */
1069     function transferFrom(address holder, address recipient, uint256 amount) public override returns (bool) {
1070         require(recipient != address(0), "ERC777: transfer to the zero address");
1071         require(holder != address(0), "ERC777: transfer from the zero address");
1072 
1073         address spender = _msgSender();
1074 
1075         _callTokensToSend(spender, holder, recipient, amount, "", "");
1076 
1077         _move(spender, holder, recipient, amount, "", "");
1078         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
1079 
1080         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
1081 
1082         return true;
1083     }
1084 
1085     /**
1086      * @dev Creates `amount` tokens and assigns them to `account`, increasing
1087      * the total supply.
1088      *
1089      * If a send hook is registered for `account`, the corresponding function
1090      * will be called with `operator`, `data` and `operatorData`.
1091      *
1092      * See {IERC777Sender} and {IERC777Recipient}.
1093      *
1094      * Emits {Minted} and {IERC20-Transfer} events.
1095      *
1096      * Requirements
1097      *
1098      * - `account` cannot be the zero address.
1099      * - if `account` is a contract, it must implement the {IERC777Recipient}
1100      * interface.
1101      */
1102     function _mint(
1103         address account,
1104         uint256 amount,
1105         bytes memory userData,
1106         bytes memory operatorData
1107     )
1108     internal virtual
1109     {
1110         require(account != address(0), "ERC777: mint to the zero address");
1111 
1112         address operator = _msgSender();
1113 
1114         _beforeTokenTransfer(operator, address(0), account, amount);
1115 
1116         // Update state variables
1117         _totalSupply = _totalSupply.add(amount);
1118         _balances[account] = _balances[account].add(amount);
1119 
1120         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1121 
1122         emit Minted(operator, account, amount, userData, operatorData);
1123         emit Transfer(address(0), account, amount);
1124     }
1125 
1126     /**
1127      * @dev Send tokens
1128      * @param from address token holder address
1129      * @param to address recipient address
1130      * @param amount uint256 amount of tokens to transfer
1131      * @param userData bytes extra information provided by the token holder (if any)
1132      * @param operatorData bytes extra information provided by the operator (if any)
1133      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1134      */
1135     function _send(
1136         address from,
1137         address to,
1138         uint256 amount,
1139         bytes memory userData,
1140         bytes memory operatorData,
1141         bool requireReceptionAck
1142     )
1143         internal
1144     {
1145         require(from != address(0), "ERC777: send from the zero address");
1146         require(to != address(0), "ERC777: send to the zero address");
1147 
1148         address operator = _msgSender();
1149 
1150         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1151 
1152         _move(operator, from, to, amount, userData, operatorData);
1153 
1154         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1155     }
1156 
1157     /**
1158      * @dev Burn tokens
1159      * @param from address token holder address
1160      * @param amount uint256 amount of tokens to burn
1161      * @param data bytes extra information provided by the token holder
1162      * @param operatorData bytes extra information provided by the operator (if any)
1163      */
1164     function _burn(
1165         address from,
1166         uint256 amount,
1167         bytes memory data,
1168         bytes memory operatorData
1169     )
1170         internal virtual
1171     {
1172         require(from != address(0), "ERC777: burn from the zero address");
1173 
1174         address operator = _msgSender();
1175 
1176         _beforeTokenTransfer(operator, from, address(0), amount);
1177 
1178         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1179 
1180         // Update state variables
1181         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1182         _totalSupply = _totalSupply.sub(amount);
1183 
1184         emit Burned(operator, from, amount, data, operatorData);
1185         emit Transfer(from, address(0), amount);
1186     }
1187 
1188     function _move(
1189         address operator,
1190         address from,
1191         address to,
1192         uint256 amount,
1193         bytes memory userData,
1194         bytes memory operatorData
1195     )
1196         private
1197     {
1198         _beforeTokenTransfer(operator, from, to, amount);
1199 
1200         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1201         _balances[to] = _balances[to].add(amount);
1202 
1203         emit Sent(operator, from, to, amount, userData, operatorData);
1204         emit Transfer(from, to, amount);
1205     }
1206 
1207     /**
1208      * @dev See {ERC20-_approve}.
1209      *
1210      * Note that accounts cannot have allowance issued by their operators.
1211      */
1212     function _approve(address holder, address spender, uint256 value) internal {
1213         require(holder != address(0), "ERC777: approve from the zero address");
1214         require(spender != address(0), "ERC777: approve to the zero address");
1215 
1216         _allowances[holder][spender] = value;
1217         emit Approval(holder, spender, value);
1218     }
1219 
1220     /**
1221      * @dev Call from.tokensToSend() if the interface is registered
1222      * @param operator address operator requesting the transfer
1223      * @param from address token holder address
1224      * @param to address recipient address
1225      * @param amount uint256 amount of tokens to transfer
1226      * @param userData bytes extra information provided by the token holder (if any)
1227      * @param operatorData bytes extra information provided by the operator (if any)
1228      */
1229     function _callTokensToSend(
1230         address operator,
1231         address from,
1232         address to,
1233         uint256 amount,
1234         bytes memory userData,
1235         bytes memory operatorData
1236     )
1237         private
1238     {
1239         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
1240         if (implementer != address(0)) {
1241             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1242         }
1243     }
1244 
1245     /**
1246      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1247      * tokensReceived() was not registered for the recipient
1248      * @param operator address operator requesting the transfer
1249      * @param from address token holder address
1250      * @param to address recipient address
1251      * @param amount uint256 amount of tokens to transfer
1252      * @param userData bytes extra information provided by the token holder (if any)
1253      * @param operatorData bytes extra information provided by the operator (if any)
1254      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1255      */
1256     function _callTokensReceived(
1257         address operator,
1258         address from,
1259         address to,
1260         uint256 amount,
1261         bytes memory userData,
1262         bytes memory operatorData,
1263         bool requireReceptionAck
1264     )
1265         private
1266     {
1267         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(to, _TOKENS_RECIPIENT_INTERFACE_HASH);
1268         if (implementer != address(0)) {
1269             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1270         } else if (requireReceptionAck) {
1271             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1272         }
1273     }
1274 
1275     /**
1276      * @dev Hook that is called before any token transfer. This includes
1277      * calls to {send}, {transfer}, {operatorSend}, minting and burning.
1278      *
1279      * Calling conditions:
1280      *
1281      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1282      * will be to transferred to `to`.
1283      * - when `from` is zero, `amount` tokens will be minted for `to`.
1284      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1285      * - `from` and `to` are never both zero.
1286      *
1287      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1288      */
1289     function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal virtual { }
1290 }
1291 
1292 
1293 // File contracts/PPBToken.sol
1294 
1295 
1296 pragma solidity ^0.6.0;
1297 
1298 contract PPBToken is ERC777 {
1299     constructor() public ERC777("PPBToken", "PPB", new address[](0)) {
1300         _mint(msg.sender, 21e8 * 1e18, "", "");
1301     }
1302 }