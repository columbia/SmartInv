1 // File: @openzeppelin/contracts/introspection/IERC1820Registry.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the global ERC1820 Registry, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
10  * implementers for interfaces in this registry, as well as query support.
11  *
12  * Implementers may be shared by multiple accounts, and can also implement more
13  * than a single interface for each account. Contracts can implement interfaces
14  * for themselves, but externally-owned accounts (EOA) must delegate this to a
15  * contract.
16  *
17  * {IERC165} interfaces can also be queried via the registry.
18  *
19  * For an in-depth explanation and source code analysis, see the EIP text.
20  */
21 interface IERC1820Registry {
22     /**
23      * @dev Sets `newManager` as the manager for `account`. A manager of an
24      * account is able to set interface implementers for it.
25      *
26      * By default, each account is its own manager. Passing a value of `0x0` in
27      * `newManager` will reset the manager to this initial state.
28      *
29      * Emits a {ManagerChanged} event.
30      *
31      * Requirements:
32      *
33      * - the caller must be the current manager for `account`.
34      */
35     function setManager(address account, address newManager) external;
36 
37     /**
38      * @dev Returns the manager for `account`.
39      *
40      * See {setManager}.
41      */
42     function getManager(address account) external view returns (address);
43 
44     /**
45      * @dev Sets the `implementer` contract as ``account``'s implementer for
46      * `interfaceHash`.
47      *
48      * `account` being the zero address is an alias for the caller's address.
49      * The zero address can also be used in `implementer` to remove an old one.
50      *
51      * See {interfaceHash} to learn how these are created.
52      *
53      * Emits an {InterfaceImplementerSet} event.
54      *
55      * Requirements:
56      *
57      * - the caller must be the current manager for `account`.
58      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
59      * end in 28 zeroes).
60      * - `implementer` must implement {IERC1820Implementer} and return true when
61      * queried for support, unless `implementer` is the caller. See
62      * {IERC1820Implementer-canImplementInterfaceForAddress}.
63      */
64     function setInterfaceImplementer(address account, bytes32 _interfaceHash, address implementer) external;
65 
66     /**
67      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
68      * implementer is registered, returns the zero address.
69      *
70      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
71      * zeroes), `account` will be queried for support of it.
72      *
73      * `account` being the zero address is an alias for the caller's address.
74      */
75     function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);
76 
77     /**
78      * @dev Returns the interface hash for an `interfaceName`, as defined in the
79      * corresponding
80      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
81      */
82     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
83 
84     /**
85      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
86      *  @param account Address of the contract for which to update the cache.
87      *  @param interfaceId ERC165 interface for which to update the cache.
88      */
89     function updateERC165Cache(address account, bytes4 interfaceId) external;
90 
91     /**
92      *  @notice Checks whether a contract implements an ERC165 interface or not.
93      *  If the result is not cached a direct lookup on the contract address is performed.
94      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
95      *  {updateERC165Cache} with the contract address.
96      *  @param account Address of the contract to check.
97      *  @param interfaceId ERC165 interface to check.
98      *  @return True if `account` implements `interfaceId`, false otherwise.
99      */
100     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
101 
102     /**
103      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
104      *  @param account Address of the contract to check.
105      *  @param interfaceId ERC165 interface to check.
106      *  @return True if `account` implements `interfaceId`, false otherwise.
107      */
108     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
109 
110     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
111 
112     event ManagerChanged(address indexed account, address indexed newManager);
113 }
114 
115 // File: @openzeppelin/contracts/utils/Address.sol
116 
117 
118 
119 pragma solidity >=0.6.2 <0.8.0;
120 
121 /**
122  * @dev Collection of functions related to the address type
123  */
124 library Address {
125     /**
126      * @dev Returns true if `account` is a contract.
127      *
128      * [IMPORTANT]
129      * ====
130      * It is unsafe to assume that an address for which this function returns
131      * false is an externally-owned account (EOA) and not a contract.
132      *
133      * Among others, `isContract` will return false for the following
134      * types of addresses:
135      *
136      *  - an externally-owned account
137      *  - a contract in construction
138      *  - an address where a contract will be created
139      *  - an address where a contract lived, but was destroyed
140      * ====
141      */
142     function isContract(address account) internal view returns (bool) {
143         // This method relies on extcodesize, which returns 0 for contracts in
144         // construction, since the code is only stored at the end of the
145         // constructor execution.
146 
147         uint256 size;
148         // solhint-disable-next-line no-inline-assembly
149         assembly { size := extcodesize(account) }
150         return size > 0;
151     }
152 
153     /**
154      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
155      * `recipient`, forwarding all available gas and reverting on errors.
156      *
157      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
158      * of certain opcodes, possibly making contracts go over the 2300 gas limit
159      * imposed by `transfer`, making them unable to receive funds via
160      * `transfer`. {sendValue} removes this limitation.
161      *
162      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
163      *
164      * IMPORTANT: because control is transferred to `recipient`, care must be
165      * taken to not create reentrancy vulnerabilities. Consider using
166      * {ReentrancyGuard} or the
167      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
168      */
169     function sendValue(address payable recipient, uint256 amount) internal {
170         require(address(this).balance >= amount, "Address: insufficient balance");
171 
172         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
173         (bool success, ) = recipient.call{ value: amount }("");
174         require(success, "Address: unable to send value, recipient may have reverted");
175     }
176 
177     /**
178      * @dev Performs a Solidity function call using a low level `call`. A
179      * plain`call` is an unsafe replacement for a function call: use this
180      * function instead.
181      *
182      * If `target` reverts with a revert reason, it is bubbled up by this
183      * function (like regular Solidity function calls).
184      *
185      * Returns the raw returned data. To convert to the expected return value,
186      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
187      *
188      * Requirements:
189      *
190      * - `target` must be a contract.
191      * - calling `target` with `data` must not revert.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
196       return functionCall(target, data, "Address: low-level call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
201      * `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, 0, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but also transferring `value` wei to `target`.
212      *
213      * Requirements:
214      *
215      * - the calling contract must have an ETH balance of at least `value`.
216      * - the called Solidity function must be `payable`.
217      *
218      * _Available since v3.1._
219      */
220     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
226      * with `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
231         require(address(this).balance >= value, "Address: insufficient balance for call");
232         require(isContract(target), "Address: call to non-contract");
233 
234         // solhint-disable-next-line avoid-low-level-calls
235         (bool success, bytes memory returndata) = target.call{ value: value }(data);
236         return _verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
246         return functionStaticCall(target, data, "Address: low-level static call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a static call.
252      *
253      * _Available since v3.3._
254      */
255     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
256         require(isContract(target), "Address: static call to non-contract");
257 
258         // solhint-disable-next-line avoid-low-level-calls
259         (bool success, bytes memory returndata) = target.staticcall(data);
260         return _verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but performing a delegate call.
266      *
267      * _Available since v3.4._
268      */
269     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
270         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
275      * but performing a delegate call.
276      *
277      * _Available since v3.4._
278      */
279     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
280         require(isContract(target), "Address: delegate call to non-contract");
281 
282         // solhint-disable-next-line avoid-low-level-calls
283         (bool success, bytes memory returndata) = target.delegatecall(data);
284         return _verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294 
295                 // solhint-disable-next-line no-inline-assembly
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 // File: @openzeppelin/contracts/math/SafeMath.sol
308 
309 
310 
311 pragma solidity >=0.6.0 <0.8.0;
312 
313 /**
314  * @dev Wrappers over Solidity's arithmetic operations with added overflow
315  * checks.
316  *
317  * Arithmetic operations in Solidity wrap on overflow. This can easily result
318  * in bugs, because programmers usually assume that an overflow raises an
319  * error, which is the standard behavior in high level programming languages.
320  * `SafeMath` restores this intuition by reverting the transaction when an
321  * operation overflows.
322  *
323  * Using this library instead of the unchecked operations eliminates an entire
324  * class of bugs, so it's recommended to use it always.
325  */
326 library SafeMath {
327     /**
328      * @dev Returns the addition of two unsigned integers, with an overflow flag.
329      *
330      * _Available since v3.4._
331      */
332     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
333         uint256 c = a + b;
334         if (c < a) return (false, 0);
335         return (true, c);
336     }
337 
338     /**
339      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
340      *
341      * _Available since v3.4._
342      */
343     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
344         if (b > a) return (false, 0);
345         return (true, a - b);
346     }
347 
348     /**
349      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
350      *
351      * _Available since v3.4._
352      */
353     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
354         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
355         // benefit is lost if 'b' is also tested.
356         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
357         if (a == 0) return (true, 0);
358         uint256 c = a * b;
359         if (c / a != b) return (false, 0);
360         return (true, c);
361     }
362 
363     /**
364      * @dev Returns the division of two unsigned integers, with a division by zero flag.
365      *
366      * _Available since v3.4._
367      */
368     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
369         if (b == 0) return (false, 0);
370         return (true, a / b);
371     }
372 
373     /**
374      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
375      *
376      * _Available since v3.4._
377      */
378     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
379         if (b == 0) return (false, 0);
380         return (true, a % b);
381     }
382 
383     /**
384      * @dev Returns the addition of two unsigned integers, reverting on
385      * overflow.
386      *
387      * Counterpart to Solidity's `+` operator.
388      *
389      * Requirements:
390      *
391      * - Addition cannot overflow.
392      */
393     function add(uint256 a, uint256 b) internal pure returns (uint256) {
394         uint256 c = a + b;
395         require(c >= a, "SafeMath: addition overflow");
396         return c;
397     }
398 
399     /**
400      * @dev Returns the subtraction of two unsigned integers, reverting on
401      * overflow (when the result is negative).
402      *
403      * Counterpart to Solidity's `-` operator.
404      *
405      * Requirements:
406      *
407      * - Subtraction cannot overflow.
408      */
409     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
410         require(b <= a, "SafeMath: subtraction overflow");
411         return a - b;
412     }
413 
414     /**
415      * @dev Returns the multiplication of two unsigned integers, reverting on
416      * overflow.
417      *
418      * Counterpart to Solidity's `*` operator.
419      *
420      * Requirements:
421      *
422      * - Multiplication cannot overflow.
423      */
424     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
425         if (a == 0) return 0;
426         uint256 c = a * b;
427         require(c / a == b, "SafeMath: multiplication overflow");
428         return c;
429     }
430 
431     /**
432      * @dev Returns the integer division of two unsigned integers, reverting on
433      * division by zero. The result is rounded towards zero.
434      *
435      * Counterpart to Solidity's `/` operator. Note: this function uses a
436      * `revert` opcode (which leaves remaining gas untouched) while Solidity
437      * uses an invalid opcode to revert (consuming all remaining gas).
438      *
439      * Requirements:
440      *
441      * - The divisor cannot be zero.
442      */
443     function div(uint256 a, uint256 b) internal pure returns (uint256) {
444         require(b > 0, "SafeMath: division by zero");
445         return a / b;
446     }
447 
448     /**
449      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
450      * reverting when dividing by zero.
451      *
452      * Counterpart to Solidity's `%` operator. This function uses a `revert`
453      * opcode (which leaves remaining gas untouched) while Solidity uses an
454      * invalid opcode to revert (consuming all remaining gas).
455      *
456      * Requirements:
457      *
458      * - The divisor cannot be zero.
459      */
460     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
461         require(b > 0, "SafeMath: modulo by zero");
462         return a % b;
463     }
464 
465     /**
466      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
467      * overflow (when the result is negative).
468      *
469      * CAUTION: This function is deprecated because it requires allocating memory for the error
470      * message unnecessarily. For custom revert reasons use {trySub}.
471      *
472      * Counterpart to Solidity's `-` operator.
473      *
474      * Requirements:
475      *
476      * - Subtraction cannot overflow.
477      */
478     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
479         require(b <= a, errorMessage);
480         return a - b;
481     }
482 
483     /**
484      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
485      * division by zero. The result is rounded towards zero.
486      *
487      * CAUTION: This function is deprecated because it requires allocating memory for the error
488      * message unnecessarily. For custom revert reasons use {tryDiv}.
489      *
490      * Counterpart to Solidity's `/` operator. Note: this function uses a
491      * `revert` opcode (which leaves remaining gas untouched) while Solidity
492      * uses an invalid opcode to revert (consuming all remaining gas).
493      *
494      * Requirements:
495      *
496      * - The divisor cannot be zero.
497      */
498     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
499         require(b > 0, errorMessage);
500         return a / b;
501     }
502 
503     /**
504      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
505      * reverting with custom message when dividing by zero.
506      *
507      * CAUTION: This function is deprecated because it requires allocating memory for the error
508      * message unnecessarily. For custom revert reasons use {tryMod}.
509      *
510      * Counterpart to Solidity's `%` operator. This function uses a `revert`
511      * opcode (which leaves remaining gas untouched) while Solidity uses an
512      * invalid opcode to revert (consuming all remaining gas).
513      *
514      * Requirements:
515      *
516      * - The divisor cannot be zero.
517      */
518     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
519         require(b > 0, errorMessage);
520         return a % b;
521     }
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
525 
526 
527 
528 pragma solidity >=0.6.0 <0.8.0;
529 
530 /**
531  * @dev Interface of the ERC20 standard as defined in the EIP.
532  */
533 interface IERC20 {
534     /**
535      * @dev Returns the amount of tokens in existence.
536      */
537     function totalSupply() external view returns (uint256);
538 
539     /**
540      * @dev Returns the amount of tokens owned by `account`.
541      */
542     function balanceOf(address account) external view returns (uint256);
543 
544     /**
545      * @dev Moves `amount` tokens from the caller's account to `recipient`.
546      *
547      * Returns a boolean value indicating whether the operation succeeded.
548      *
549      * Emits a {Transfer} event.
550      */
551     function transfer(address recipient, uint256 amount) external returns (bool);
552 
553     /**
554      * @dev Returns the remaining number of tokens that `spender` will be
555      * allowed to spend on behalf of `owner` through {transferFrom}. This is
556      * zero by default.
557      *
558      * This value changes when {approve} or {transferFrom} are called.
559      */
560     function allowance(address owner, address spender) external view returns (uint256);
561 
562     /**
563      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
564      *
565      * Returns a boolean value indicating whether the operation succeeded.
566      *
567      * IMPORTANT: Beware that changing an allowance with this method brings the risk
568      * that someone may use both the old and the new allowance by unfortunate
569      * transaction ordering. One possible solution to mitigate this race
570      * condition is to first reduce the spender's allowance to 0 and set the
571      * desired value afterwards:
572      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
573      *
574      * Emits an {Approval} event.
575      */
576     function approve(address spender, uint256 amount) external returns (bool);
577 
578     /**
579      * @dev Moves `amount` tokens from `sender` to `recipient` using the
580      * allowance mechanism. `amount` is then deducted from the caller's
581      * allowance.
582      *
583      * Returns a boolean value indicating whether the operation succeeded.
584      *
585      * Emits a {Transfer} event.
586      */
587     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
588 
589     /**
590      * @dev Emitted when `value` tokens are moved from one account (`from`) to
591      * another (`to`).
592      *
593      * Note that `value` may be zero.
594      */
595     event Transfer(address indexed from, address indexed to, uint256 value);
596 
597     /**
598      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
599      * a call to {approve}. `value` is the new allowance.
600      */
601     event Approval(address indexed owner, address indexed spender, uint256 value);
602 }
603 
604 // File: @openzeppelin/contracts/token/ERC777/IERC777Sender.sol
605 
606 
607 
608 pragma solidity >=0.6.0 <0.8.0;
609 
610 /**
611  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
612  *
613  * {IERC777} Token holders can be notified of operations performed on their
614  * tokens by having a contract implement this interface (contract holders can be
615  *  their own implementer) and registering it on the
616  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
617  *
618  * See {IERC1820Registry} and {ERC1820Implementer}.
619  */
620 interface IERC777Sender {
621     /**
622      * @dev Called by an {IERC777} token contract whenever a registered holder's
623      * (`from`) tokens are about to be moved or destroyed. The type of operation
624      * is conveyed by `to` being the zero address or not.
625      *
626      * This call occurs _before_ the token contract's state is updated, so
627      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
628      *
629      * This function may revert to prevent the operation from being executed.
630      */
631     function tokensToSend(
632         address operator,
633         address from,
634         address to,
635         uint256 amount,
636         bytes calldata userData,
637         bytes calldata operatorData
638     ) external;
639 }
640 
641 // File: @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol
642 
643 
644 
645 pragma solidity >=0.6.0 <0.8.0;
646 
647 /**
648  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
649  *
650  * Accounts can be notified of {IERC777} tokens being sent to them by having a
651  * contract implement this interface (contract holders can be their own
652  * implementer) and registering it on the
653  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
654  *
655  * See {IERC1820Registry} and {ERC1820Implementer}.
656  */
657 interface IERC777Recipient {
658     /**
659      * @dev Called by an {IERC777} token contract whenever tokens are being
660      * moved or created into a registered account (`to`). The type of operation
661      * is conveyed by `from` being the zero address or not.
662      *
663      * This call occurs _after_ the token contract's state is updated, so
664      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
665      *
666      * This function may revert to prevent the operation from being executed.
667      */
668     function tokensReceived(
669         address operator,
670         address from,
671         address to,
672         uint256 amount,
673         bytes calldata userData,
674         bytes calldata operatorData
675     ) external;
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC777/IERC777.sol
679 
680 
681 
682 pragma solidity >=0.6.0 <0.8.0;
683 
684 /**
685  * @dev Interface of the ERC777Token standard as defined in the EIP.
686  *
687  * This contract uses the
688  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
689  * token holders and recipients react to token movements by using setting implementers
690  * for the associated interfaces in said registry. See {IERC1820Registry} and
691  * {ERC1820Implementer}.
692  */
693 interface IERC777 {
694     /**
695      * @dev Returns the name of the token.
696      */
697     function name() external view returns (string memory);
698 
699     /**
700      * @dev Returns the symbol of the token, usually a shorter version of the
701      * name.
702      */
703     function symbol() external view returns (string memory);
704 
705     /**
706      * @dev Returns the smallest part of the token that is not divisible. This
707      * means all token operations (creation, movement and destruction) must have
708      * amounts that are a multiple of this number.
709      *
710      * For most token contracts, this value will equal 1.
711      */
712     function granularity() external view returns (uint256);
713 
714     /**
715      * @dev Returns the amount of tokens in existence.
716      */
717     function totalSupply() external view returns (uint256);
718 
719     /**
720      * @dev Returns the amount of tokens owned by an account (`owner`).
721      */
722     function balanceOf(address owner) external view returns (uint256);
723 
724     /**
725      * @dev Moves `amount` tokens from the caller's account to `recipient`.
726      *
727      * If send or receive hooks are registered for the caller and `recipient`,
728      * the corresponding functions will be called with `data` and empty
729      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
730      *
731      * Emits a {Sent} event.
732      *
733      * Requirements
734      *
735      * - the caller must have at least `amount` tokens.
736      * - `recipient` cannot be the zero address.
737      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
738      * interface.
739      */
740     function send(address recipient, uint256 amount, bytes calldata data) external;
741 
742     /**
743      * @dev Destroys `amount` tokens from the caller's account, reducing the
744      * total supply.
745      *
746      * If a send hook is registered for the caller, the corresponding function
747      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
748      *
749      * Emits a {Burned} event.
750      *
751      * Requirements
752      *
753      * - the caller must have at least `amount` tokens.
754      */
755     function burn(uint256 amount, bytes calldata data) external;
756 
757     /**
758      * @dev Returns true if an account is an operator of `tokenHolder`.
759      * Operators can send and burn tokens on behalf of their owners. All
760      * accounts are their own operator.
761      *
762      * See {operatorSend} and {operatorBurn}.
763      */
764     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
765 
766     /**
767      * @dev Make an account an operator of the caller.
768      *
769      * See {isOperatorFor}.
770      *
771      * Emits an {AuthorizedOperator} event.
772      *
773      * Requirements
774      *
775      * - `operator` cannot be calling address.
776      */
777     function authorizeOperator(address operator) external;
778 
779     /**
780      * @dev Revoke an account's operator status for the caller.
781      *
782      * See {isOperatorFor} and {defaultOperators}.
783      *
784      * Emits a {RevokedOperator} event.
785      *
786      * Requirements
787      *
788      * - `operator` cannot be calling address.
789      */
790     function revokeOperator(address operator) external;
791 
792     /**
793      * @dev Returns the list of default operators. These accounts are operators
794      * for all token holders, even if {authorizeOperator} was never called on
795      * them.
796      *
797      * This list is immutable, but individual holders may revoke these via
798      * {revokeOperator}, in which case {isOperatorFor} will return false.
799      */
800     function defaultOperators() external view returns (address[] memory);
801 
802     /**
803      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
804      * be an operator of `sender`.
805      *
806      * If send or receive hooks are registered for `sender` and `recipient`,
807      * the corresponding functions will be called with `data` and
808      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
809      *
810      * Emits a {Sent} event.
811      *
812      * Requirements
813      *
814      * - `sender` cannot be the zero address.
815      * - `sender` must have at least `amount` tokens.
816      * - the caller must be an operator for `sender`.
817      * - `recipient` cannot be the zero address.
818      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
819      * interface.
820      */
821     function operatorSend(
822         address sender,
823         address recipient,
824         uint256 amount,
825         bytes calldata data,
826         bytes calldata operatorData
827     ) external;
828 
829     /**
830      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
831      * The caller must be an operator of `account`.
832      *
833      * If a send hook is registered for `account`, the corresponding function
834      * will be called with `data` and `operatorData`. See {IERC777Sender}.
835      *
836      * Emits a {Burned} event.
837      *
838      * Requirements
839      *
840      * - `account` cannot be the zero address.
841      * - `account` must have at least `amount` tokens.
842      * - the caller must be an operator for `account`.
843      */
844     function operatorBurn(
845         address account,
846         uint256 amount,
847         bytes calldata data,
848         bytes calldata operatorData
849     ) external;
850 
851     event Sent(
852         address indexed operator,
853         address indexed from,
854         address indexed to,
855         uint256 amount,
856         bytes data,
857         bytes operatorData
858     );
859 
860     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
861 
862     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
863 
864     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
865 
866     event RevokedOperator(address indexed operator, address indexed tokenHolder);
867 }
868 
869 // File: @openzeppelin/contracts/utils/Context.sol
870 
871 
872 
873 pragma solidity >=0.6.0 <0.8.0;
874 
875 /*
876  * @dev Provides information about the current execution context, including the
877  * sender of the transaction and its data. While these are generally available
878  * via msg.sender and msg.data, they should not be accessed in such a direct
879  * manner, since when dealing with GSN meta-transactions the account sending and
880  * paying for execution may not be the actual sender (as far as an application
881  * is concerned).
882  *
883  * This contract is only required for intermediate, library-like contracts.
884  */
885 abstract contract Context {
886     function _msgSender() internal view virtual returns (address payable) {
887         return msg.sender;
888     }
889 
890     function _msgData() internal view virtual returns (bytes memory) {
891         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
892         return msg.data;
893     }
894 }
895 
896 // File: contracts/OwnableV2.sol
897 
898 
899 pragma solidity >=0.6.0 <0.8.0;
900 
901 
902 /**
903  * @dev Contract module which provides a basic access control mechanism, where
904  * there is an account (an owner) that can be granted exclusive access to
905  * specific functions.
906  *
907  * By default, the owner account will be the one that deploys the contract. This
908  * can later be changed with {transferOwnership}.
909  *
910  * This module is used through inheritance. It will make available the modifier
911  * `onlyOwner`, which can be applied to your functions to restrict their use to
912  * the owner.
913  */
914 abstract contract OwnableV2 is Context {
915     address private _owner;
916 
917     event OwnershipTransferred(
918         address indexed previousOwner,
919         address indexed newOwner
920     );
921 
922     /**
923      * @dev Returns the address of the current owner.
924      */
925     function owner() public view virtual returns (address) {
926         return _owner;
927     }
928 
929     /**
930      * @dev Throws if called by any account other than the owner.
931      */
932     modifier onlyOwner() {
933         require(owner() == _msgSender(), "Ownable: caller is not the owner");
934         _;
935     }
936 
937     /**
938      * @dev Leaves the contract without owner. It will not be possible to call
939      * `onlyOwner` functions anymore. Can only be called by the current owner.
940      *
941      * NOTE: Renouncing ownership will leave the contract without an owner,
942      * thereby removing any functionality that is only available to the owner.
943      */
944     function renounceOwnership() public virtual onlyOwner {
945         emit OwnershipTransferred(_owner, address(0));
946         _owner = address(0);
947     }
948 
949     /**
950      * @dev Transfers ownership of the contract to a new account (`newOwner`).
951      * Can only be called by the current owner.
952      */
953     function transferOwnership(address newOwner) public virtual onlyOwner {
954         require(
955             newOwner != address(0),
956             "Ownable: new owner is the zero address"
957         );
958         emit OwnershipTransferred(_owner, newOwner);
959         _owner = newOwner;
960     }
961 
962     function setOwner(address newOwner) internal {
963         _owner = newOwner;
964     }
965 }
966 
967 // File: contracts/Pausable.sol
968 
969 
970 pragma solidity 0.6.12;
971 
972 
973 /**
974  * @title Pausable
975  * @dev Base contract which allows children to implement an emergency stop mechanism.
976  */
977 contract Pausable is OwnableV2 {
978     event Pause();
979     event Unpause();
980 
981     bool public paused = false;
982 
983     /**
984      * @dev Modifier to make a function callable only when the contract is not paused.
985      */
986     modifier whenNotPaused() {
987         require(!paused);
988         _;
989     }
990 
991     /**
992      * @dev Modifier to make a function callable only when the contract is paused.
993      */
994     modifier whenPaused() {
995         require(paused);
996         _;
997     }
998 
999     /**
1000      * @dev called by the owner to pause, triggers stopped state
1001      */
1002     function pause() public onlyOwner whenNotPaused {
1003         paused = true;
1004         emit Pause();
1005     }
1006 
1007     /**
1008      * @dev called by the owner to unpause, returns to normal state
1009      */
1010     function unpause() public onlyOwner whenPaused {
1011         paused = false;
1012         emit Unpause();
1013     }
1014 }
1015 
1016 // File: @openzeppelin/contracts/token/ERC777/ERC777.sol
1017 
1018 
1019 
1020 pragma solidity >=0.6.0 <0.8.0;
1021 
1022 
1023 
1024 
1025 
1026 
1027 
1028 
1029 
1030 /**
1031  * @dev Implementation of the {IERC777} interface.
1032  *
1033  * This implementation is agnostic to the way tokens are created. This means
1034  * that a supply mechanism has to be added in a derived contract using {_mint}.
1035  *
1036  * Support for ERC20 is included in this contract, as specified by the EIP: both
1037  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
1038  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
1039  * movements.
1040  *
1041  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
1042  * are no special restrictions in the amount of tokens that created, moved, or
1043  * destroyed. This makes integration with ERC20 applications seamless.
1044  */
1045 contract ERC777 is Context, IERC777, IERC20 {
1046     using SafeMath for uint256;
1047     using Address for address;
1048 
1049     IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
1050 
1051     mapping(address => uint256) private _balances;
1052 
1053     uint256 private _totalSupply;
1054 
1055     string private _name;
1056     string private _symbol;
1057 
1058     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
1059     // See https://github.com/ethereum/solidity/issues/4024.
1060 
1061     // keccak256("ERC777TokensSender")
1062     bytes32 constant private _TOKENS_SENDER_INTERFACE_HASH =
1063         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
1064 
1065     // keccak256("ERC777TokensRecipient")
1066     bytes32 constant private _TOKENS_RECIPIENT_INTERFACE_HASH =
1067         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
1068 
1069     // This isn't ever read from - it's only used to respond to the defaultOperators query.
1070     address[] private _defaultOperatorsArray;
1071 
1072     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
1073     mapping(address => bool) private _defaultOperators;
1074 
1075     // For each account, a mapping of its operators and revoked default operators.
1076     mapping(address => mapping(address => bool)) private _operators;
1077     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
1078 
1079     // ERC20-allowances
1080     mapping (address => mapping (address => uint256)) private _allowances;
1081 
1082     /**
1083      * @dev `defaultOperators` may be an empty array.
1084      */
1085     constructor(
1086         string memory name_,
1087         string memory symbol_,
1088         address[] memory defaultOperators_
1089     )
1090         public
1091     {
1092         _name = name_;
1093         _symbol = symbol_;
1094 
1095         _defaultOperatorsArray = defaultOperators_;
1096         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
1097             _defaultOperators[_defaultOperatorsArray[i]] = true;
1098         }
1099 
1100         // register interfaces
1101         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
1102         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
1103     }
1104 
1105     /**
1106      * @dev See {IERC777-name}.
1107      */
1108     function name() public view virtual override returns (string memory) {
1109         return _name;
1110     }
1111 
1112     /**
1113      * @dev See {IERC777-symbol}.
1114      */
1115     function symbol() public view virtual override returns (string memory) {
1116         return _symbol;
1117     }
1118 
1119     /**
1120      * @dev See {ERC20-decimals}.
1121      *
1122      * Always returns 18, as per the
1123      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
1124      */
1125     function decimals() public pure virtual returns (uint8) {
1126         return 18;
1127     }
1128 
1129     /**
1130      * @dev See {IERC777-granularity}.
1131      *
1132      * This implementation always returns `1`.
1133      */
1134     function granularity() public view virtual override returns (uint256) {
1135         return 1;
1136     }
1137 
1138     /**
1139      * @dev See {IERC777-totalSupply}.
1140      */
1141     function totalSupply() public view virtual override(IERC20, IERC777) returns (uint256) {
1142         return _totalSupply;
1143     }
1144 
1145     /**
1146      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
1147      */
1148     function balanceOf(address tokenHolder) public view virtual override(IERC20, IERC777) returns (uint256) {
1149         return _balances[tokenHolder];
1150     }
1151 
1152     /**
1153      * @dev See {IERC777-send}.
1154      *
1155      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
1156      */
1157     function send(address recipient, uint256 amount, bytes memory data) public virtual override  {
1158         _send(_msgSender(), recipient, amount, data, "", true);
1159     }
1160 
1161     /**
1162      * @dev See {IERC20-transfer}.
1163      *
1164      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
1165      * interface if it is a contract.
1166      *
1167      * Also emits a {Sent} event.
1168      */
1169     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1170         require(recipient != address(0), "ERC777: transfer to the zero address");
1171 
1172         address from = _msgSender();
1173 
1174         _callTokensToSend(from, from, recipient, amount, "", "");
1175 
1176         _move(from, from, recipient, amount, "", "");
1177 
1178         _callTokensReceived(from, from, recipient, amount, "", "", false);
1179 
1180         return true;
1181     }
1182 
1183     /**
1184      * @dev See {IERC777-burn}.
1185      *
1186      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
1187      */
1188     function burn(uint256 amount, bytes memory data) public virtual override  {
1189         _burn(_msgSender(), amount, data, "");
1190     }
1191 
1192     /**
1193      * @dev See {IERC777-isOperatorFor}.
1194      */
1195     function isOperatorFor(address operator, address tokenHolder) public view virtual override returns (bool) {
1196         return operator == tokenHolder ||
1197             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
1198             _operators[tokenHolder][operator];
1199     }
1200 
1201     /**
1202      * @dev See {IERC777-authorizeOperator}.
1203      */
1204     function authorizeOperator(address operator) public virtual override  {
1205         require(_msgSender() != operator, "ERC777: authorizing self as operator");
1206 
1207         if (_defaultOperators[operator]) {
1208             delete _revokedDefaultOperators[_msgSender()][operator];
1209         } else {
1210             _operators[_msgSender()][operator] = true;
1211         }
1212 
1213         emit AuthorizedOperator(operator, _msgSender());
1214     }
1215 
1216     /**
1217      * @dev See {IERC777-revokeOperator}.
1218      */
1219     function revokeOperator(address operator) public virtual override  {
1220         require(operator != _msgSender(), "ERC777: revoking self as operator");
1221 
1222         if (_defaultOperators[operator]) {
1223             _revokedDefaultOperators[_msgSender()][operator] = true;
1224         } else {
1225             delete _operators[_msgSender()][operator];
1226         }
1227 
1228         emit RevokedOperator(operator, _msgSender());
1229     }
1230 
1231     /**
1232      * @dev See {IERC777-defaultOperators}.
1233      */
1234     function defaultOperators() public view virtual override returns (address[] memory) {
1235         return _defaultOperatorsArray;
1236     }
1237 
1238     /**
1239      * @dev See {IERC777-operatorSend}.
1240      *
1241      * Emits {Sent} and {IERC20-Transfer} events.
1242      */
1243     function operatorSend(
1244         address sender,
1245         address recipient,
1246         uint256 amount,
1247         bytes memory data,
1248         bytes memory operatorData
1249     )
1250         public
1251         virtual
1252         override
1253     {
1254         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
1255         _send(sender, recipient, amount, data, operatorData, true);
1256     }
1257 
1258     /**
1259      * @dev See {IERC777-operatorBurn}.
1260      *
1261      * Emits {Burned} and {IERC20-Transfer} events.
1262      */
1263     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public virtual override {
1264         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
1265         _burn(account, amount, data, operatorData);
1266     }
1267 
1268     /**
1269      * @dev See {IERC20-allowance}.
1270      *
1271      * Note that operator and allowance concepts are orthogonal: operators may
1272      * not have allowance, and accounts with allowance may not be operators
1273      * themselves.
1274      */
1275     function allowance(address holder, address spender) public view virtual override returns (uint256) {
1276         return _allowances[holder][spender];
1277     }
1278 
1279     /**
1280      * @dev See {IERC20-approve}.
1281      *
1282      * Note that accounts cannot have allowance issued by their operators.
1283      */
1284     function approve(address spender, uint256 value) public virtual override returns (bool) {
1285         address holder = _msgSender();
1286         _approve(holder, spender, value);
1287         return true;
1288     }
1289 
1290    /**
1291     * @dev See {IERC20-transferFrom}.
1292     *
1293     * Note that operator and allowance concepts are orthogonal: operators cannot
1294     * call `transferFrom` (unless they have allowance), and accounts with
1295     * allowance cannot call `operatorSend` (unless they are operators).
1296     *
1297     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
1298     */
1299     function transferFrom(address holder, address recipient, uint256 amount) public virtual override returns (bool) {
1300         require(recipient != address(0), "ERC777: transfer to the zero address");
1301         require(holder != address(0), "ERC777: transfer from the zero address");
1302 
1303         address spender = _msgSender();
1304 
1305         _callTokensToSend(spender, holder, recipient, amount, "", "");
1306 
1307         _move(spender, holder, recipient, amount, "", "");
1308         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
1309 
1310         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
1311 
1312         return true;
1313     }
1314 
1315     /**
1316      * @dev Creates `amount` tokens and assigns them to `account`, increasing
1317      * the total supply.
1318      *
1319      * If a send hook is registered for `account`, the corresponding function
1320      * will be called with `operator`, `data` and `operatorData`.
1321      *
1322      * See {IERC777Sender} and {IERC777Recipient}.
1323      *
1324      * Emits {Minted} and {IERC20-Transfer} events.
1325      *
1326      * Requirements
1327      *
1328      * - `account` cannot be the zero address.
1329      * - if `account` is a contract, it must implement the {IERC777Recipient}
1330      * interface.
1331      */
1332     function _mint(
1333         address account,
1334         uint256 amount,
1335         bytes memory userData,
1336         bytes memory operatorData
1337     )
1338         internal
1339         virtual
1340     {
1341         require(account != address(0), "ERC777: mint to the zero address");
1342 
1343         address operator = _msgSender();
1344 
1345         _beforeTokenTransfer(operator, address(0), account, amount);
1346 
1347         // Update state variables
1348         _totalSupply = _totalSupply.add(amount);
1349         _balances[account] = _balances[account].add(amount);
1350 
1351         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1352 
1353         emit Minted(operator, account, amount, userData, operatorData);
1354         emit Transfer(address(0), account, amount);
1355     }
1356 
1357     /**
1358      * @dev Send tokens
1359      * @param from address token holder address
1360      * @param to address recipient address
1361      * @param amount uint256 amount of tokens to transfer
1362      * @param userData bytes extra information provided by the token holder (if any)
1363      * @param operatorData bytes extra information provided by the operator (if any)
1364      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1365      */
1366     function _send(
1367         address from,
1368         address to,
1369         uint256 amount,
1370         bytes memory userData,
1371         bytes memory operatorData,
1372         bool requireReceptionAck
1373     )
1374         internal
1375         virtual
1376     {
1377         require(from != address(0), "ERC777: send from the zero address");
1378         require(to != address(0), "ERC777: send to the zero address");
1379 
1380         address operator = _msgSender();
1381 
1382         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1383 
1384         _move(operator, from, to, amount, userData, operatorData);
1385 
1386         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1387     }
1388 
1389     /**
1390      * @dev Burn tokens
1391      * @param from address token holder address
1392      * @param amount uint256 amount of tokens to burn
1393      * @param data bytes extra information provided by the token holder
1394      * @param operatorData bytes extra information provided by the operator (if any)
1395      */
1396     function _burn(
1397         address from,
1398         uint256 amount,
1399         bytes memory data,
1400         bytes memory operatorData
1401     )
1402         internal
1403         virtual
1404     {
1405         require(from != address(0), "ERC777: burn from the zero address");
1406 
1407         address operator = _msgSender();
1408 
1409         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1410 
1411         _beforeTokenTransfer(operator, from, address(0), amount);
1412 
1413         // Update state variables
1414         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1415         _totalSupply = _totalSupply.sub(amount);
1416 
1417         emit Burned(operator, from, amount, data, operatorData);
1418         emit Transfer(from, address(0), amount);
1419     }
1420 
1421     function _move(
1422         address operator,
1423         address from,
1424         address to,
1425         uint256 amount,
1426         bytes memory userData,
1427         bytes memory operatorData
1428     )
1429         private
1430     {
1431         _beforeTokenTransfer(operator, from, to, amount);
1432 
1433         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1434         _balances[to] = _balances[to].add(amount);
1435 
1436         emit Sent(operator, from, to, amount, userData, operatorData);
1437         emit Transfer(from, to, amount);
1438     }
1439 
1440     /**
1441      * @dev See {ERC20-_approve}.
1442      *
1443      * Note that accounts cannot have allowance issued by their operators.
1444      */
1445     function _approve(address holder, address spender, uint256 value) internal {
1446         require(holder != address(0), "ERC777: approve from the zero address");
1447         require(spender != address(0), "ERC777: approve to the zero address");
1448 
1449         _allowances[holder][spender] = value;
1450         emit Approval(holder, spender, value);
1451     }
1452 
1453     /**
1454      * @dev Call from.tokensToSend() if the interface is registered
1455      * @param operator address operator requesting the transfer
1456      * @param from address token holder address
1457      * @param to address recipient address
1458      * @param amount uint256 amount of tokens to transfer
1459      * @param userData bytes extra information provided by the token holder (if any)
1460      * @param operatorData bytes extra information provided by the operator (if any)
1461      */
1462     function _callTokensToSend(
1463         address operator,
1464         address from,
1465         address to,
1466         uint256 amount,
1467         bytes memory userData,
1468         bytes memory operatorData
1469     )
1470         private
1471     {
1472         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
1473         if (implementer != address(0)) {
1474             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1475         }
1476     }
1477 
1478     /**
1479      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1480      * tokensReceived() was not registered for the recipient
1481      * @param operator address operator requesting the transfer
1482      * @param from address token holder address
1483      * @param to address recipient address
1484      * @param amount uint256 amount of tokens to transfer
1485      * @param userData bytes extra information provided by the token holder (if any)
1486      * @param operatorData bytes extra information provided by the operator (if any)
1487      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1488      */
1489     function _callTokensReceived(
1490         address operator,
1491         address from,
1492         address to,
1493         uint256 amount,
1494         bytes memory userData,
1495         bytes memory operatorData,
1496         bool requireReceptionAck
1497     )
1498         private
1499     {
1500         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(to, _TOKENS_RECIPIENT_INTERFACE_HASH);
1501         if (implementer != address(0)) {
1502             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1503         } else if (requireReceptionAck) {
1504             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1505         }
1506     }
1507 
1508     /**
1509      * @dev Hook that is called before any token transfer. This includes
1510      * calls to {send}, {transfer}, {operatorSend}, minting and burning.
1511      *
1512      * Calling conditions:
1513      *
1514      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1515      * will be to transferred to `to`.
1516      * - when `from` is zero, `amount` tokens will be minted for `to`.
1517      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1518      * - `from` and `to` are never both zero.
1519      *
1520      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1521      */
1522     function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal virtual { }
1523 }
1524 
1525 // File: contracts/ClearToken.sol
1526 
1527 
1528 pragma solidity 0.6.12;
1529 
1530 
1531 
1532 contract ClearToken is ERC777, Pausable {
1533     mapping(address => bool) public greyList;
1534 
1535     event AddGreyList(address indexed user);
1536     event RemoveGreyList(address indexed user);
1537 
1538     /**
1539      * @dev `defaultOperators` may be an empty array.
1540      */
1541     constructor(
1542         string memory name_,
1543         string memory symbol_,
1544         address[] memory defaultOperators_,
1545         uint256[] memory initAmount,
1546         address[] memory initReceiver,
1547         address _owner
1548     ) public ERC777(name_, symbol_, defaultOperators_) {
1549         setOwner(_owner);
1550         for (uint256 i = 0; i < initAmount.length; i++) {
1551             _mint(initReceiver[i], initAmount[i], "", "");
1552         }
1553     }
1554 
1555     function operatorMint(
1556         address account,
1557         uint256 amount,
1558         bytes memory userData,
1559         bytes memory operatorData
1560     ) external onlyOwner {
1561         _mint(account, amount, userData, operatorData);
1562     }
1563 
1564     function addGreyList(address _user) external onlyOwner {
1565         require(_user != address(0), "zero address");
1566         require(!greyList[_user], "in the list");
1567         greyList[_user] = true;
1568         emit AddGreyList(_user);
1569     }
1570 
1571     function removeGreyList(address _user) external onlyOwner {
1572         require(_user != address(0), "zero address");
1573         require(greyList[_user], "removed");
1574         greyList[_user] = false;
1575         emit RemoveGreyList(_user);
1576     }
1577 
1578     function _beforeTokenTransfer(
1579         address,
1580         address from,
1581         address,
1582         uint256
1583     ) internal override whenNotPaused {
1584         require(!greyList[from], "in greyList");
1585     }
1586 }