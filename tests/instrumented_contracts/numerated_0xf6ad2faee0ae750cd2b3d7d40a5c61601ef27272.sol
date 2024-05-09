1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 
6 // 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // 
29 /**
30  * @dev Interface of the ERC777Token standard as defined in the EIP.
31  *
32  * This contract uses the
33  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
34  * token holders and recipients react to token movements by using setting implementers
35  * for the associated interfaces in said registry. See {IERC1820Registry} and
36  * {ERC1820Implementer}.
37  */
38 interface IERC777 {
39     /**
40      * @dev Returns the name of the token.
41      */
42     function name() external view returns (string memory);
43 
44     /**
45      * @dev Returns the symbol of the token, usually a shorter version of the
46      * name.
47      */
48     function symbol() external view returns (string memory);
49 
50     /**
51      * @dev Returns the smallest part of the token that is not divisible. This
52      * means all token operations (creation, movement and destruction) must have
53      * amounts that are a multiple of this number.
54      *
55      * For most token contracts, this value will equal 1.
56      */
57     function granularity() external view returns (uint256);
58 
59     /**
60      * @dev Returns the amount of tokens in existence.
61      */
62     function totalSupply() external view returns (uint256);
63 
64     /**
65      * @dev Returns the amount of tokens owned by an account (`owner`).
66      */
67     function balanceOf(address owner) external view returns (uint256);
68 
69     /**
70      * @dev Moves `amount` tokens from the caller's account to `recipient`.
71      *
72      * If send or receive hooks are registered for the caller and `recipient`,
73      * the corresponding functions will be called with `data` and empty
74      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
75      *
76      * Emits a {Sent} event.
77      *
78      * Requirements
79      *
80      * - the caller must have at least `amount` tokens.
81      * - `recipient` cannot be the zero address.
82      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
83      * interface.
84      */
85     function send(address recipient, uint256 amount, bytes calldata data) external;
86 
87     /**
88      * @dev Destroys `amount` tokens from the caller's account, reducing the
89      * total supply.
90      *
91      * If a send hook is registered for the caller, the corresponding function
92      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
93      *
94      * Emits a {Burned} event.
95      *
96      * Requirements
97      *
98      * - the caller must have at least `amount` tokens.
99      */
100     function burn(uint256 amount, bytes calldata data) external;
101 
102     /**
103      * @dev Returns true if an account is an operator of `tokenHolder`.
104      * Operators can send and burn tokens on behalf of their owners. All
105      * accounts are their own operator.
106      *
107      * See {operatorSend} and {operatorBurn}.
108      */
109     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
110 
111     /**
112      * @dev Make an account an operator of the caller.
113      *
114      * See {isOperatorFor}.
115      *
116      * Emits an {AuthorizedOperator} event.
117      *
118      * Requirements
119      *
120      * - `operator` cannot be calling address.
121      */
122     function authorizeOperator(address operator) external;
123 
124     /**
125      * @dev Revoke an account's operator status for the caller.
126      *
127      * See {isOperatorFor} and {defaultOperators}.
128      *
129      * Emits a {RevokedOperator} event.
130      *
131      * Requirements
132      *
133      * - `operator` cannot be calling address.
134      */
135     function revokeOperator(address operator) external;
136 
137     /**
138      * @dev Returns the list of default operators. These accounts are operators
139      * for all token holders, even if {authorizeOperator} was never called on
140      * them.
141      *
142      * This list is immutable, but individual holders may revoke these via
143      * {revokeOperator}, in which case {isOperatorFor} will return false.
144      */
145     function defaultOperators() external view returns (address[] memory);
146 
147     /**
148      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
149      * be an operator of `sender`.
150      *
151      * If send or receive hooks are registered for `sender` and `recipient`,
152      * the corresponding functions will be called with `data` and
153      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
154      *
155      * Emits a {Sent} event.
156      *
157      * Requirements
158      *
159      * - `sender` cannot be the zero address.
160      * - `sender` must have at least `amount` tokens.
161      * - the caller must be an operator for `sender`.
162      * - `recipient` cannot be the zero address.
163      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
164      * interface.
165      */
166     function operatorSend(
167         address sender,
168         address recipient,
169         uint256 amount,
170         bytes calldata data,
171         bytes calldata operatorData
172     ) external;
173 
174     /**
175      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
176      * The caller must be an operator of `account`.
177      *
178      * If a send hook is registered for `account`, the corresponding function
179      * will be called with `data` and `operatorData`. See {IERC777Sender}.
180      *
181      * Emits a {Burned} event.
182      *
183      * Requirements
184      *
185      * - `account` cannot be the zero address.
186      * - `account` must have at least `amount` tokens.
187      * - the caller must be an operator for `account`.
188      */
189     function operatorBurn(
190         address account,
191         uint256 amount,
192         bytes calldata data,
193         bytes calldata operatorData
194     ) external;
195 
196     event Sent(
197         address indexed operator,
198         address indexed from,
199         address indexed to,
200         uint256 amount,
201         bytes data,
202         bytes operatorData
203     );
204 
205     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
206 
207     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
208 
209     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
210 
211     event RevokedOperator(address indexed operator, address indexed tokenHolder);
212 }
213 
214 // 
215 /**
216  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
217  *
218  * Accounts can be notified of {IERC777} tokens being sent to them by having a
219  * contract implement this interface (contract holders can be their own
220  * implementer) and registering it on the
221  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
222  *
223  * See {IERC1820Registry} and {ERC1820Implementer}.
224  */
225 interface IERC777Recipient {
226     /**
227      * @dev Called by an {IERC777} token contract whenever tokens are being
228      * moved or created into a registered account (`to`). The type of operation
229      * is conveyed by `from` being the zero address or not.
230      *
231      * This call occurs _after_ the token contract's state is updated, so
232      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
233      *
234      * This function may revert to prevent the operation from being executed.
235      */
236     function tokensReceived(
237         address operator,
238         address from,
239         address to,
240         uint256 amount,
241         bytes calldata userData,
242         bytes calldata operatorData
243     ) external;
244 }
245 
246 // 
247 /**
248  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
249  *
250  * {IERC777} Token holders can be notified of operations performed on their
251  * tokens by having a contract implement this interface (contract holders can be
252  *  their own implementer) and registering it on the
253  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
254  *
255  * See {IERC1820Registry} and {ERC1820Implementer}.
256  */
257 interface IERC777Sender {
258     /**
259      * @dev Called by an {IERC777} token contract whenever a registered holder's
260      * (`from`) tokens are about to be moved or destroyed. The type of operation
261      * is conveyed by `to` being the zero address or not.
262      *
263      * This call occurs _before_ the token contract's state is updated, so
264      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
265      *
266      * This function may revert to prevent the operation from being executed.
267      */
268     function tokensToSend(
269         address operator,
270         address from,
271         address to,
272         uint256 amount,
273         bytes calldata userData,
274         bytes calldata operatorData
275     ) external;
276 }
277 
278 // 
279 /**
280  * @dev Interface of the ERC20 standard as defined in the EIP.
281  */
282 interface IERC20 {
283     /**
284      * @dev Returns the amount of tokens in existence.
285      */
286     function totalSupply() external view returns (uint256);
287 
288     /**
289      * @dev Returns the amount of tokens owned by `account`.
290      */
291     function balanceOf(address account) external view returns (uint256);
292 
293     /**
294      * @dev Moves `amount` tokens from the caller's account to `recipient`.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transfer(address recipient, uint256 amount) external returns (bool);
301 
302     /**
303      * @dev Returns the remaining number of tokens that `spender` will be
304      * allowed to spend on behalf of `owner` through {transferFrom}. This is
305      * zero by default.
306      *
307      * This value changes when {approve} or {transferFrom} are called.
308      */
309     function allowance(address owner, address spender) external view returns (uint256);
310 
311     /**
312      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * IMPORTANT: Beware that changing an allowance with this method brings the risk
317      * that someone may use both the old and the new allowance by unfortunate
318      * transaction ordering. One possible solution to mitigate this race
319      * condition is to first reduce the spender's allowance to 0 and set the
320      * desired value afterwards:
321      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
322      *
323      * Emits an {Approval} event.
324      */
325     function approve(address spender, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Moves `amount` tokens from `sender` to `recipient` using the
329      * allowance mechanism. `amount` is then deducted from the caller's
330      * allowance.
331      *
332      * Returns a boolean value indicating whether the operation succeeded.
333      *
334      * Emits a {Transfer} event.
335      */
336     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
337 
338     /**
339      * @dev Emitted when `value` tokens are moved from one account (`from`) to
340      * another (`to`).
341      *
342      * Note that `value` may be zero.
343      */
344     event Transfer(address indexed from, address indexed to, uint256 value);
345 
346     /**
347      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
348      * a call to {approve}. `value` is the new allowance.
349      */
350     event Approval(address indexed owner, address indexed spender, uint256 value);
351 }
352 
353 // 
354 /**
355  * @dev Wrappers over Solidity's arithmetic operations with added overflow
356  * checks.
357  *
358  * Arithmetic operations in Solidity wrap on overflow. This can easily result
359  * in bugs, because programmers usually assume that an overflow raises an
360  * error, which is the standard behavior in high level programming languages.
361  * `SafeMath` restores this intuition by reverting the transaction when an
362  * operation overflows.
363  *
364  * Using this library instead of the unchecked operations eliminates an entire
365  * class of bugs, so it's recommended to use it always.
366  */
367 library SafeMath {
368     /**
369      * @dev Returns the addition of two unsigned integers, reverting on
370      * overflow.
371      *
372      * Counterpart to Solidity's `+` operator.
373      *
374      * Requirements:
375      *
376      * - Addition cannot overflow.
377      */
378     function add(uint256 a, uint256 b) internal pure returns (uint256) {
379         uint256 c = a + b;
380         require(c >= a, "SafeMath: addition overflow");
381 
382         return c;
383     }
384 
385     /**
386      * @dev Returns the subtraction of two unsigned integers, reverting on
387      * overflow (when the result is negative).
388      *
389      * Counterpart to Solidity's `-` operator.
390      *
391      * Requirements:
392      *
393      * - Subtraction cannot overflow.
394      */
395     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
396         return sub(a, b, "SafeMath: subtraction overflow");
397     }
398 
399     /**
400      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
401      * overflow (when the result is negative).
402      *
403      * Counterpart to Solidity's `-` operator.
404      *
405      * Requirements:
406      *
407      * - Subtraction cannot overflow.
408      */
409     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
410         require(b <= a, errorMessage);
411         uint256 c = a - b;
412 
413         return c;
414     }
415 
416     /**
417      * @dev Returns the multiplication of two unsigned integers, reverting on
418      * overflow.
419      *
420      * Counterpart to Solidity's `*` operator.
421      *
422      * Requirements:
423      *
424      * - Multiplication cannot overflow.
425      */
426     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
427         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
428         // benefit is lost if 'b' is also tested.
429         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
430         if (a == 0) {
431             return 0;
432         }
433 
434         uint256 c = a * b;
435         require(c / a == b, "SafeMath: multiplication overflow");
436 
437         return c;
438     }
439 
440     /**
441      * @dev Returns the integer division of two unsigned integers. Reverts on
442      * division by zero. The result is rounded towards zero.
443      *
444      * Counterpart to Solidity's `/` operator. Note: this function uses a
445      * `revert` opcode (which leaves remaining gas untouched) while Solidity
446      * uses an invalid opcode to revert (consuming all remaining gas).
447      *
448      * Requirements:
449      *
450      * - The divisor cannot be zero.
451      */
452     function div(uint256 a, uint256 b) internal pure returns (uint256) {
453         return div(a, b, "SafeMath: division by zero");
454     }
455 
456     /**
457      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
458      * division by zero. The result is rounded towards zero.
459      *
460      * Counterpart to Solidity's `/` operator. Note: this function uses a
461      * `revert` opcode (which leaves remaining gas untouched) while Solidity
462      * uses an invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
469         require(b > 0, errorMessage);
470         uint256 c = a / b;
471         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
472 
473         return c;
474     }
475 
476     /**
477      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
478      * Reverts when dividing by zero.
479      *
480      * Counterpart to Solidity's `%` operator. This function uses a `revert`
481      * opcode (which leaves remaining gas untouched) while Solidity uses an
482      * invalid opcode to revert (consuming all remaining gas).
483      *
484      * Requirements:
485      *
486      * - The divisor cannot be zero.
487      */
488     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
489         return mod(a, b, "SafeMath: modulo by zero");
490     }
491 
492     /**
493      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
494      * Reverts with custom message when dividing by zero.
495      *
496      * Counterpart to Solidity's `%` operator. This function uses a `revert`
497      * opcode (which leaves remaining gas untouched) while Solidity uses an
498      * invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b != 0, errorMessage);
506         return a % b;
507     }
508 }
509 
510 // 
511 /**
512  * @dev Collection of functions related to the address type
513  */
514 library Address {
515     /**
516      * @dev Returns true if `account` is a contract.
517      *
518      * [IMPORTANT]
519      * ====
520      * It is unsafe to assume that an address for which this function returns
521      * false is an externally-owned account (EOA) and not a contract.
522      *
523      * Among others, `isContract` will return false for the following
524      * types of addresses:
525      *
526      *  - an externally-owned account
527      *  - a contract in construction
528      *  - an address where a contract will be created
529      *  - an address where a contract lived, but was destroyed
530      * ====
531      */
532     function isContract(address account) internal view returns (bool) {
533         // This method relies in extcodesize, which returns 0 for contracts in
534         // construction, since the code is only stored at the end of the
535         // constructor execution.
536 
537         uint256 size;
538         // solhint-disable-next-line no-inline-assembly
539         assembly { size := extcodesize(account) }
540         return size > 0;
541     }
542 
543     /**
544      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
545      * `recipient`, forwarding all available gas and reverting on errors.
546      *
547      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
548      * of certain opcodes, possibly making contracts go over the 2300 gas limit
549      * imposed by `transfer`, making them unable to receive funds via
550      * `transfer`. {sendValue} removes this limitation.
551      *
552      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
553      *
554      * IMPORTANT: because control is transferred to `recipient`, care must be
555      * taken to not create reentrancy vulnerabilities. Consider using
556      * {ReentrancyGuard} or the
557      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
558      */
559     function sendValue(address payable recipient, uint256 amount) internal {
560         require(address(this).balance >= amount, "Address: insufficient balance");
561 
562         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
563         (bool success, ) = recipient.call{ value: amount }("");
564         require(success, "Address: unable to send value, recipient may have reverted");
565     }
566 
567     /**
568      * @dev Performs a Solidity function call using a low level `call`. A
569      * plain`call` is an unsafe replacement for a function call: use this
570      * function instead.
571      *
572      * If `target` reverts with a revert reason, it is bubbled up by this
573      * function (like regular Solidity function calls).
574      *
575      * Returns the raw returned data. To convert to the expected return value,
576      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
577      *
578      * Requirements:
579      *
580      * - `target` must be a contract.
581      * - calling `target` with `data` must not revert.
582      *
583      * _Available since v3.1._
584      */
585     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
586       return functionCall(target, data, "Address: low-level call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
591      * `errorMessage` as a fallback revert reason when `target` reverts.
592      *
593      * _Available since v3.1._
594      */
595     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
596         return _functionCallWithValue(target, data, 0, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but also transferring `value` wei to `target`.
602      *
603      * Requirements:
604      *
605      * - the calling contract must have an ETH balance of at least `value`.
606      * - the called Solidity function must be `payable`.
607      *
608      * _Available since v3.1._
609      */
610     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
611         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
616      * with `errorMessage` as a fallback revert reason when `target` reverts.
617      *
618      * _Available since v3.1._
619      */
620     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
621         require(address(this).balance >= value, "Address: insufficient balance for call");
622         return _functionCallWithValue(target, data, value, errorMessage);
623     }
624 
625     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
626         require(isContract(target), "Address: call to non-contract");
627 
628         // solhint-disable-next-line avoid-low-level-calls
629         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
630         if (success) {
631             return returndata;
632         } else {
633             // Look for revert reason and bubble it up if present
634             if (returndata.length > 0) {
635                 // The easiest way to bubble the revert reason is using memory via assembly
636 
637                 // solhint-disable-next-line no-inline-assembly
638                 assembly {
639                     let returndata_size := mload(returndata)
640                     revert(add(32, returndata), returndata_size)
641                 }
642             } else {
643                 revert(errorMessage);
644             }
645         }
646     }
647 }
648 
649 // 
650 /**
651  * @dev Interface of the global ERC1820 Registry, as defined in the
652  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
653  * implementers for interfaces in this registry, as well as query support.
654  *
655  * Implementers may be shared by multiple accounts, and can also implement more
656  * than a single interface for each account. Contracts can implement interfaces
657  * for themselves, but externally-owned accounts (EOA) must delegate this to a
658  * contract.
659  *
660  * {IERC165} interfaces can also be queried via the registry.
661  *
662  * For an in-depth explanation and source code analysis, see the EIP text.
663  */
664 interface IERC1820Registry {
665     /**
666      * @dev Sets `newManager` as the manager for `account`. A manager of an
667      * account is able to set interface implementers for it.
668      *
669      * By default, each account is its own manager. Passing a value of `0x0` in
670      * `newManager` will reset the manager to this initial state.
671      *
672      * Emits a {ManagerChanged} event.
673      *
674      * Requirements:
675      *
676      * - the caller must be the current manager for `account`.
677      */
678     function setManager(address account, address newManager) external;
679 
680     /**
681      * @dev Returns the manager for `account`.
682      *
683      * See {setManager}.
684      */
685     function getManager(address account) external view returns (address);
686 
687     /**
688      * @dev Sets the `implementer` contract as ``account``'s implementer for
689      * `interfaceHash`.
690      *
691      * `account` being the zero address is an alias for the caller's address.
692      * The zero address can also be used in `implementer` to remove an old one.
693      *
694      * See {interfaceHash} to learn how these are created.
695      *
696      * Emits an {InterfaceImplementerSet} event.
697      *
698      * Requirements:
699      *
700      * - the caller must be the current manager for `account`.
701      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
702      * end in 28 zeroes).
703      * - `implementer` must implement {IERC1820Implementer} and return true when
704      * queried for support, unless `implementer` is the caller. See
705      * {IERC1820Implementer-canImplementInterfaceForAddress}.
706      */
707     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
708 
709     /**
710      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
711      * implementer is registered, returns the zero address.
712      *
713      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
714      * zeroes), `account` will be queried for support of it.
715      *
716      * `account` being the zero address is an alias for the caller's address.
717      */
718     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
719 
720     /**
721      * @dev Returns the interface hash for an `interfaceName`, as defined in the
722      * corresponding
723      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
724      */
725     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
726 
727     /**
728      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
729      *  @param account Address of the contract for which to update the cache.
730      *  @param interfaceId ERC165 interface for which to update the cache.
731      */
732     function updateERC165Cache(address account, bytes4 interfaceId) external;
733 
734     /**
735      *  @notice Checks whether a contract implements an ERC165 interface or not.
736      *  If the result is not cached a direct lookup on the contract address is performed.
737      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
738      *  {updateERC165Cache} with the contract address.
739      *  @param account Address of the contract to check.
740      *  @param interfaceId ERC165 interface to check.
741      *  @return True if `account` implements `interfaceId`, false otherwise.
742      */
743     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
744 
745     /**
746      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
747      *  @param account Address of the contract to check.
748      *  @param interfaceId ERC165 interface to check.
749      *  @return True if `account` implements `interfaceId`, false otherwise.
750      */
751     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
752 
753     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
754 
755     event ManagerChanged(address indexed account, address indexed newManager);
756 }
757 
758 // 
759 /**
760  * @dev Implementation of the {IERC777} interface.
761  *
762  * This implementation is agnostic to the way tokens are created. This means
763  * that a supply mechanism has to be added in a derived contract using {_mint}.
764  *
765  * Support for ERC20 is included in this contract, as specified by the EIP: both
766  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
767  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
768  * movements.
769  *
770  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
771  * are no special restrictions in the amount of tokens that created, moved, or
772  * destroyed. This makes integration with ERC20 applications seamless.
773  */
774 contract ERC777 is Context, IERC777, IERC20 {
775     using SafeMath for uint256;
776     using Address for address;
777 
778     IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
779 
780     mapping(address => uint256) private _balances;
781 
782     uint256 private _totalSupply;
783 
784     string private _name;
785     string private _symbol;
786 
787     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
788     // See https://github.com/ethereum/solidity/issues/4024.
789 
790     // keccak256("ERC777TokensSender")
791     bytes32 constant private _TOKENS_SENDER_INTERFACE_HASH =
792         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
793 
794     // keccak256("ERC777TokensRecipient")
795     bytes32 constant private _TOKENS_RECIPIENT_INTERFACE_HASH =
796         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
797 
798     // This isn't ever read from - it's only used to respond to the defaultOperators query.
799     address[] private _defaultOperatorsArray;
800 
801     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
802     mapping(address => bool) private _defaultOperators;
803 
804     // For each account, a mapping of its operators and revoked default operators.
805     mapping(address => mapping(address => bool)) private _operators;
806     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
807 
808     // ERC20-allowances
809     mapping (address => mapping (address => uint256)) private _allowances;
810 
811     /**
812      * @dev `defaultOperators` may be an empty array.
813      */
814     constructor(
815         string memory name,
816         string memory symbol,
817         address[] memory defaultOperators
818     ) public {
819         _name = name;
820         _symbol = symbol;
821 
822         _defaultOperatorsArray = defaultOperators;
823         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
824             _defaultOperators[_defaultOperatorsArray[i]] = true;
825         }
826 
827         // register interfaces
828         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
829         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
830     }
831 
832     /**
833      * @dev See {IERC777-name}.
834      */
835     function name() public view override returns (string memory) {
836         return _name;
837     }
838 
839     /**
840      * @dev See {IERC777-symbol}.
841      */
842     function symbol() public view override returns (string memory) {
843         return _symbol;
844     }
845 
846     /**
847      * @dev See {ERC20-decimals}.
848      *
849      * Always returns 18, as per the
850      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
851      */
852     function decimals() public pure returns (uint8) {
853         return 18;
854     }
855 
856     /**
857      * @dev See {IERC777-granularity}.
858      *
859      * This implementation always returns `1`.
860      */
861     function granularity() public view override returns (uint256) {
862         return 1;
863     }
864 
865     /**
866      * @dev See {IERC777-totalSupply}.
867      */
868     function totalSupply() public view override(IERC20, IERC777) returns (uint256) {
869         return _totalSupply;
870     }
871 
872     /**
873      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
874      */
875     function balanceOf(address tokenHolder) public view override(IERC20, IERC777) returns (uint256) {
876         return _balances[tokenHolder];
877     }
878 
879     /**
880      * @dev See {IERC777-send}.
881      *
882      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
883      */
884     function send(address recipient, uint256 amount, bytes memory data) public override  {
885         _send(_msgSender(), recipient, amount, data, "", true);
886     }
887 
888     /**
889      * @dev See {IERC20-transfer}.
890      *
891      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
892      * interface if it is a contract.
893      *
894      * Also emits a {Sent} event.
895      */
896     function transfer(address recipient, uint256 amount) public override returns (bool) {
897         require(recipient != address(0), "ERC777: transfer to the zero address");
898 
899         address from = _msgSender();
900 
901         _callTokensToSend(from, from, recipient, amount, "", "");
902 
903         _move(from, from, recipient, amount, "", "");
904 
905         _callTokensReceived(from, from, recipient, amount, "", "", false);
906 
907         return true;
908     }
909 
910     /**
911      * @dev See {IERC777-burn}.
912      *
913      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
914      */
915     function burn(uint256 amount, bytes memory data) public override  {
916         _burn(_msgSender(), amount, data, "");
917     }
918 
919     /**
920      * @dev See {IERC777-isOperatorFor}.
921      */
922     function isOperatorFor(
923         address operator,
924         address tokenHolder
925     ) public view override returns (bool) {
926         return operator == tokenHolder ||
927             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
928             _operators[tokenHolder][operator];
929     }
930 
931     /**
932      * @dev See {IERC777-authorizeOperator}.
933      */
934     function authorizeOperator(address operator) public override  {
935         require(_msgSender() != operator, "ERC777: authorizing self as operator");
936 
937         if (_defaultOperators[operator]) {
938             delete _revokedDefaultOperators[_msgSender()][operator];
939         } else {
940             _operators[_msgSender()][operator] = true;
941         }
942 
943         emit AuthorizedOperator(operator, _msgSender());
944     }
945 
946     /**
947      * @dev See {IERC777-revokeOperator}.
948      */
949     function revokeOperator(address operator) public override  {
950         require(operator != _msgSender(), "ERC777: revoking self as operator");
951 
952         if (_defaultOperators[operator]) {
953             _revokedDefaultOperators[_msgSender()][operator] = true;
954         } else {
955             delete _operators[_msgSender()][operator];
956         }
957 
958         emit RevokedOperator(operator, _msgSender());
959     }
960 
961     /**
962      * @dev See {IERC777-defaultOperators}.
963      */
964     function defaultOperators() public view override returns (address[] memory) {
965         return _defaultOperatorsArray;
966     }
967 
968     /**
969      * @dev See {IERC777-operatorSend}.
970      *
971      * Emits {Sent} and {IERC20-Transfer} events.
972      */
973     function operatorSend(
974         address sender,
975         address recipient,
976         uint256 amount,
977         bytes memory data,
978         bytes memory operatorData
979     )
980     public override
981     {
982         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
983         _send(sender, recipient, amount, data, operatorData, true);
984     }
985 
986     /**
987      * @dev See {IERC777-operatorBurn}.
988      *
989      * Emits {Burned} and {IERC20-Transfer} events.
990      */
991     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public override {
992         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
993         _burn(account, amount, data, operatorData);
994     }
995 
996     /**
997      * @dev See {IERC20-allowance}.
998      *
999      * Note that operator and allowance concepts are orthogonal: operators may
1000      * not have allowance, and accounts with allowance may not be operators
1001      * themselves.
1002      */
1003     function allowance(address holder, address spender) public view override returns (uint256) {
1004         return _allowances[holder][spender];
1005     }
1006 
1007     /**
1008      * @dev See {IERC20-approve}.
1009      *
1010      * Note that accounts cannot have allowance issued by their operators.
1011      */
1012     function approve(address spender, uint256 value) public override returns (bool) {
1013         address holder = _msgSender();
1014         _approve(holder, spender, value);
1015         return true;
1016     }
1017 
1018    /**
1019     * @dev See {IERC20-transferFrom}.
1020     *
1021     * Note that operator and allowance concepts are orthogonal: operators cannot
1022     * call `transferFrom` (unless they have allowance), and accounts with
1023     * allowance cannot call `operatorSend` (unless they are operators).
1024     *
1025     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
1026     */
1027     function transferFrom(address holder, address recipient, uint256 amount) public override returns (bool) {
1028         require(recipient != address(0), "ERC777: transfer to the zero address");
1029         require(holder != address(0), "ERC777: transfer from the zero address");
1030 
1031         address spender = _msgSender();
1032 
1033         _callTokensToSend(spender, holder, recipient, amount, "", "");
1034 
1035         _move(spender, holder, recipient, amount, "", "");
1036         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
1037 
1038         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
1039 
1040         return true;
1041     }
1042 
1043     /**
1044      * @dev Creates `amount` tokens and assigns them to `account`, increasing
1045      * the total supply.
1046      *
1047      * If a send hook is registered for `account`, the corresponding function
1048      * will be called with `operator`, `data` and `operatorData`.
1049      *
1050      * See {IERC777Sender} and {IERC777Recipient}.
1051      *
1052      * Emits {Minted} and {IERC20-Transfer} events.
1053      *
1054      * Requirements
1055      *
1056      * - `account` cannot be the zero address.
1057      * - if `account` is a contract, it must implement the {IERC777Recipient}
1058      * interface.
1059      */
1060     function _mint(
1061         address account,
1062         uint256 amount,
1063         bytes memory userData,
1064         bytes memory operatorData
1065     )
1066     internal virtual
1067     {
1068         require(account != address(0), "ERC777: mint to the zero address");
1069 
1070         address operator = _msgSender();
1071 
1072         _beforeTokenTransfer(operator, address(0), account, amount);
1073 
1074         // Update state variables
1075         _totalSupply = _totalSupply.add(amount);
1076         _balances[account] = _balances[account].add(amount);
1077 
1078         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1079 
1080         emit Minted(operator, account, amount, userData, operatorData);
1081         emit Transfer(address(0), account, amount);
1082     }
1083 
1084     /**
1085      * @dev Send tokens
1086      * @param from address token holder address
1087      * @param to address recipient address
1088      * @param amount uint256 amount of tokens to transfer
1089      * @param userData bytes extra information provided by the token holder (if any)
1090      * @param operatorData bytes extra information provided by the operator (if any)
1091      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1092      */
1093     function _send(
1094         address from,
1095         address to,
1096         uint256 amount,
1097         bytes memory userData,
1098         bytes memory operatorData,
1099         bool requireReceptionAck
1100     )
1101         internal
1102     {
1103         require(from != address(0), "ERC777: send from the zero address");
1104         require(to != address(0), "ERC777: send to the zero address");
1105 
1106         address operator = _msgSender();
1107 
1108         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1109 
1110         _move(operator, from, to, amount, userData, operatorData);
1111 
1112         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1113     }
1114 
1115     /**
1116      * @dev Burn tokens
1117      * @param from address token holder address
1118      * @param amount uint256 amount of tokens to burn
1119      * @param data bytes extra information provided by the token holder
1120      * @param operatorData bytes extra information provided by the operator (if any)
1121      */
1122     function _burn(
1123         address from,
1124         uint256 amount,
1125         bytes memory data,
1126         bytes memory operatorData
1127     )
1128         internal virtual
1129     {
1130         require(from != address(0), "ERC777: burn from the zero address");
1131 
1132         address operator = _msgSender();
1133 
1134         _beforeTokenTransfer(operator, from, address(0), amount);
1135 
1136         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1137 
1138         // Update state variables
1139         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1140         _totalSupply = _totalSupply.sub(amount);
1141 
1142         emit Burned(operator, from, amount, data, operatorData);
1143         emit Transfer(from, address(0), amount);
1144     }
1145 
1146     function _move(
1147         address operator,
1148         address from,
1149         address to,
1150         uint256 amount,
1151         bytes memory userData,
1152         bytes memory operatorData
1153     )
1154         private
1155     {
1156         _beforeTokenTransfer(operator, from, to, amount);
1157 
1158         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1159         _balances[to] = _balances[to].add(amount);
1160 
1161         emit Sent(operator, from, to, amount, userData, operatorData);
1162         emit Transfer(from, to, amount);
1163     }
1164 
1165     /**
1166      * @dev See {ERC20-_approve}.
1167      *
1168      * Note that accounts cannot have allowance issued by their operators.
1169      */
1170     function _approve(address holder, address spender, uint256 value) internal {
1171         require(holder != address(0), "ERC777: approve from the zero address");
1172         require(spender != address(0), "ERC777: approve to the zero address");
1173 
1174         _allowances[holder][spender] = value;
1175         emit Approval(holder, spender, value);
1176     }
1177 
1178     /**
1179      * @dev Call from.tokensToSend() if the interface is registered
1180      * @param operator address operator requesting the transfer
1181      * @param from address token holder address
1182      * @param to address recipient address
1183      * @param amount uint256 amount of tokens to transfer
1184      * @param userData bytes extra information provided by the token holder (if any)
1185      * @param operatorData bytes extra information provided by the operator (if any)
1186      */
1187     function _callTokensToSend(
1188         address operator,
1189         address from,
1190         address to,
1191         uint256 amount,
1192         bytes memory userData,
1193         bytes memory operatorData
1194     )
1195         private
1196     {
1197         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
1198         if (implementer != address(0)) {
1199             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1200         }
1201     }
1202 
1203     /**
1204      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1205      * tokensReceived() was not registered for the recipient
1206      * @param operator address operator requesting the transfer
1207      * @param from address token holder address
1208      * @param to address recipient address
1209      * @param amount uint256 amount of tokens to transfer
1210      * @param userData bytes extra information provided by the token holder (if any)
1211      * @param operatorData bytes extra information provided by the operator (if any)
1212      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1213      */
1214     function _callTokensReceived(
1215         address operator,
1216         address from,
1217         address to,
1218         uint256 amount,
1219         bytes memory userData,
1220         bytes memory operatorData,
1221         bool requireReceptionAck
1222     )
1223         private
1224     {
1225         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(to, _TOKENS_RECIPIENT_INTERFACE_HASH);
1226         if (implementer != address(0)) {
1227             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1228         } else if (requireReceptionAck) {
1229             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1230         }
1231     }
1232 
1233     /**
1234      * @dev Hook that is called before any token transfer. This includes
1235      * calls to {send}, {transfer}, {operatorSend}, minting and burning.
1236      *
1237      * Calling conditions:
1238      *
1239      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1240      * will be to transferred to `to`.
1241      * - when `from` is zero, `amount` tokens will be minted for `to`.
1242      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1243      * - `from` and `to` are never both zero.
1244      *
1245      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1246      */
1247     function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal virtual { }
1248 }
1249 
1250 // 
1251 // Created by devysq@gmail.com
1252 contract TokenTimeLock is IERC777Recipient {
1253     using SafeMath for uint256;
1254     uint256  private constant THREEMONTH  = 90 days;
1255 
1256 
1257     // ERC777 basic token contract being held
1258     IERC777 public token;
1259 
1260     // admin work for lock
1261     address private admin;
1262     // lock info
1263     mapping(address=>lockInfo) public balanceOf;
1264     // release time
1265     uint256 public releaseTime;
1266 
1267     // token lock abount one locked account;
1268     struct lockInfo{
1269         uint256 amount;
1270         uint256 balance;
1271         uint256 lastReleaseTime;
1272     }
1273 
1274     constructor (IERC777 _token,uint256 _releaseTime) public {
1275         // solhint-disable-next-line not-rely-on-time
1276         require(_releaseTime > block.timestamp, "release time is before current time");
1277 
1278         token = _token;
1279         releaseTime = _releaseTime;
1280         admin=msg.sender;
1281 
1282         IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24)
1283         .setInterfaceImplementer(
1284             address(this),
1285             0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b,//keccak256("ERC777TokensRecipient")
1286             address(this));
1287     }
1288 
1289     /**
1290      * @notice Transfers tokens held by timelock to beneficiary.
1291      */
1292     function release(address beneficiary) public   {
1293         require(beneficiary !=address(0),"beneficiary address is empty" );
1294 
1295         // solhint-disable-next-line not-rely-on-time
1296         require(block.timestamp >= releaseTime, "current time is before release time");
1297 
1298         lockInfo storage info = balanceOf[beneficiary];
1299         require(info.balance>0,"no tokens to release");
1300 
1301         uint256 amount=  info.amount.mul(10).div(100);//10%
1302         if(amount>info.balance){
1303             amount= info.balance;
1304         }
1305         require(token.balanceOf(address(this))>=amount,"no tokens to release" );
1306         // solhint-disable-next-line not-rely-on-time
1307         require(block.timestamp >= info.lastReleaseTime.add(THREEMONTH), "current time is before release time (three month)");
1308 
1309         token.send(beneficiary, amount,"");
1310         uint256 newBalance = info.balance.sub(amount);
1311         if(newBalance==0){
1312             delete balanceOf[beneficiary];//clear
1313             return;
1314         }
1315         info.balance=newBalance;
1316         // solhint-disable-next-line not-rely-on-time
1317         info.lastReleaseTime=block.timestamp;
1318     }
1319 
1320     /**
1321       @notice lock tokens to beneficiary;
1322      */
1323     function lock(address beneficiary,uint256 amount) public{
1324         require(msg.sender==admin,"msg.sender is not token address");
1325 
1326         require(balanceOf[beneficiary].balance==0,"repeat lock");
1327 
1328         // not check balance;
1329         balanceOf[beneficiary] = lockInfo({
1330             balance:amount,
1331             amount:amount,lastReleaseTime:0 });
1332     }
1333     /**
1334      * @dev Called by an {IERC777} token contract whenever tokens are being
1335      * moved or created into a registered account (`to`). The type of operation
1336      * is conveyed by `from` being the zero address or not.
1337      *
1338      * This call occurs _after_ the token contract's state is updated, so
1339      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
1340      *
1341      * This function may revert to prevent the operation from being executed.
1342      */
1343     function tokensReceived(
1344         address operator,
1345         address from,
1346         address to,
1347         uint256 amount,
1348         bytes calldata userData,
1349         bytes calldata operatorData
1350     ) override public {
1351         operator;from;to;amount;userData;operatorData;
1352         require(msg.sender==address(token),"received token is not Token target");
1353     }
1354 }
1355 
1356 // 
1357 // Created by devysq@gmail.com
1358 contract Token is ERC777 {
1359 
1360     TokenTimeLock public   locker;
1361 
1362     constructor() public ERC777("Business universal services Chain","BUS",new address[](0))   {
1363 
1364         uint256 releaseTime= block.timestamp + 1095 days;// three years: 365*3
1365         locker = new TokenTimeLock(this,releaseTime);
1366 
1367         // 基金会5%  技术团队3%  机构12%  合计20%锁仓3年（36个月）
1368         // 第37个月开始释放10%，每三个月释放一次，每次释放10%，两年半释放完毕
1369         // 1	0xd5e7a36DA04C136B3a03beeAAE4E1Da8dC52a192	投资机构1	3%	300万枚
1370         // 2	0xaEb3b44732E59e0F9B77316E1Df29be518F486bC	投资机构2	1.5%	150万枚
1371         // 3	0xe9df36cF551bdbfE9CdFbbf2904f56A20D8B8dC1	投资机构3	2%	200万枚
1372         // 4	0xB869C2903D3248F40f61773eb9Cf4c2cFf17a5d5	投资机构4	2.5%	250万枚
1373         // 5	0x43401ae3ebcD9c6Ce252e9646373AA90DB588DCA	投资机构5	1%	100万枚
1374         // 6	0x3b2Ac663c495A19aE2Fe1272B06e4f9d421Fe041	投资机构6	2%	200万枚
1375         // 7	0x4dF5675fA8106296E73Dd7246C0d2fa51049117d	基金会	5%	500万枚
1376         // 8	0xfea7d3dFA4625E9000D8DbaA0137d385CF699AFb	技术团队	3%	300万枚
1377         // unlock
1378         // 9	0x1Fa09e46492172ef5E8c99F870cc7a4958d5E41c	DeFi	35%	3500万枚
1379         // 10	0x4a204002d1AC965EB6A502DDB718834603553D4d	星际空间站	30%	3000万枚
1380         // 11	0x85B51B91c072EA86BbD7290D68c43d8999381C67	跨链网关	10%	1000万枚
1381         // 12	0x85A444ACFc0205c5eE6EaA4005074856bF1C2BF4	链上公益	5%	500万枚
1382 
1383         // lock
1384         _mint(address(locker),2000*10000*1e18,"","");
1385         locker.lock(0xd5e7a36DA04C136B3a03beeAAE4E1Da8dC52a192,300*10000*1e18);
1386         locker.lock(0xaEb3b44732E59e0F9B77316E1Df29be518F486bC,150*10000*1e18);
1387         locker.lock(0xe9df36cF551bdbfE9CdFbbf2904f56A20D8B8dC1,200*10000*1e18);
1388         locker.lock(0xB869C2903D3248F40f61773eb9Cf4c2cFf17a5d5,250*10000*1e18);
1389         locker.lock(0x43401ae3ebcD9c6Ce252e9646373AA90DB588DCA,100*10000*1e18);
1390         locker.lock(0x3b2Ac663c495A19aE2Fe1272B06e4f9d421Fe041,200*10000*1e18);
1391         locker.lock(0x4dF5675fA8106296E73Dd7246C0d2fa51049117d,500*10000*1e18);
1392         locker.lock(0xfea7d3dFA4625E9000D8DbaA0137d385CF699AFb,300*10000*1e18);
1393 
1394          //unlock
1395         _mint(0x1Fa09e46492172ef5E8c99F870cc7a4958d5E41c,3500*10000*1e18,"","");
1396         _mint(0x4a204002d1AC965EB6A502DDB718834603553D4d,3000*10000*1e18,"","");
1397         _mint(0x85B51B91c072EA86BbD7290D68c43d8999381C67,1000*10000*1e18,"","");
1398         _mint(0x85A444ACFc0205c5eE6EaA4005074856bF1C2BF4,500*10000*1e18,"","");
1399     }
1400 }