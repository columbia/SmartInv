1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
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
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC777Token standard as defined in the EIP.
28  *
29  * This contract uses the
30  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
31  * token holders and recipients react to token movements by using setting implementers
32  * for the associated interfaces in said registry. See {IERC1820Registry} and
33  * {ERC1820Implementer}.
34  */
35 interface IERC777 {
36     /**
37      * @dev Returns the name of the token.
38      */
39     function name() external view returns (string memory);
40 
41     /**
42      * @dev Returns the symbol of the token, usually a shorter version of the
43      * name.
44      */
45     function symbol() external view returns (string memory);
46 
47     /**
48      * @dev Returns the smallest part of the token that is not divisible. This
49      * means all token operations (creation, movement and destruction) must have
50      * amounts that are a multiple of this number.
51      *
52      * For most token contracts, this value will equal 1.
53      */
54     function granularity() external view returns (uint256);
55 
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by an account (`owner`).
63      */
64     function balanceOf(address owner) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `recipient`.
68      *
69      * If send or receive hooks are registered for the caller and `recipient`,
70      * the corresponding functions will be called with `data` and empty
71      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
72      *
73      * Emits a {Sent} event.
74      *
75      * Requirements
76      *
77      * - the caller must have at least `amount` tokens.
78      * - `recipient` cannot be the zero address.
79      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
80      * interface.
81      */
82     function send(address recipient, uint256 amount, bytes calldata data) external;
83 
84     /**
85      * @dev Destroys `amount` tokens from the caller's account, reducing the
86      * total supply.
87      *
88      * If a send hook is registered for the caller, the corresponding function
89      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
90      *
91      * Emits a {Burned} event.
92      *
93      * Requirements
94      *
95      * - the caller must have at least `amount` tokens.
96      */
97     function burn(uint256 amount, bytes calldata data) external;
98 
99     /**
100      * @dev Returns true if an account is an operator of `tokenHolder`.
101      * Operators can send and burn tokens on behalf of their owners. All
102      * accounts are their own operator.
103      *
104      * See {operatorSend} and {operatorBurn}.
105      */
106     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
107 
108     /**
109      * @dev Make an account an operator of the caller.
110      *
111      * See {isOperatorFor}.
112      *
113      * Emits an {AuthorizedOperator} event.
114      *
115      * Requirements
116      *
117      * - `operator` cannot be calling address.
118      */
119     function authorizeOperator(address operator) external;
120 
121     /**
122      * @dev Revoke an account's operator status for the caller.
123      *
124      * See {isOperatorFor} and {defaultOperators}.
125      *
126      * Emits a {RevokedOperator} event.
127      *
128      * Requirements
129      *
130      * - `operator` cannot be calling address.
131      */
132     function revokeOperator(address operator) external;
133 
134     /**
135      * @dev Returns the list of default operators. These accounts are operators
136      * for all token holders, even if {authorizeOperator} was never called on
137      * them.
138      *
139      * This list is immutable, but individual holders may revoke these via
140      * {revokeOperator}, in which case {isOperatorFor} will return false.
141      */
142     function defaultOperators() external view returns (address[] memory);
143 
144     /**
145      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
146      * be an operator of `sender`.
147      *
148      * If send or receive hooks are registered for `sender` and `recipient`,
149      * the corresponding functions will be called with `data` and
150      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
151      *
152      * Emits a {Sent} event.
153      *
154      * Requirements
155      *
156      * - `sender` cannot be the zero address.
157      * - `sender` must have at least `amount` tokens.
158      * - the caller must be an operator for `sender`.
159      * - `recipient` cannot be the zero address.
160      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
161      * interface.
162      */
163     function operatorSend(
164         address sender,
165         address recipient,
166         uint256 amount,
167         bytes calldata data,
168         bytes calldata operatorData
169     ) external;
170 
171     /**
172      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
173      * The caller must be an operator of `account`.
174      *
175      * If a send hook is registered for `account`, the corresponding function
176      * will be called with `data` and `operatorData`. See {IERC777Sender}.
177      *
178      * Emits a {Burned} event.
179      *
180      * Requirements
181      *
182      * - `account` cannot be the zero address.
183      * - `account` must have at least `amount` tokens.
184      * - the caller must be an operator for `account`.
185      */
186     function operatorBurn(
187         address account,
188         uint256 amount,
189         bytes calldata data,
190         bytes calldata operatorData
191     ) external;
192 
193     event Sent(
194         address indexed operator,
195         address indexed from,
196         address indexed to,
197         uint256 amount,
198         bytes data,
199         bytes operatorData
200     );
201 
202     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
203 
204     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
205 
206     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
207 
208     event RevokedOperator(address indexed operator, address indexed tokenHolder);
209 }
210 
211 /**
212  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
213  *
214  * Accounts can be notified of {IERC777} tokens being sent to them by having a
215  * contract implement this interface (contract holders can be their own
216  * implementer) and registering it on the
217  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
218  *
219  * See {IERC1820Registry} and {ERC1820Implementer}.
220  */
221 interface IERC777Recipient {
222     /**
223      * @dev Called by an {IERC777} token contract whenever tokens are being
224      * moved or created into a registered account (`to`). The type of operation
225      * is conveyed by `from` being the zero address or not.
226      *
227      * This call occurs _after_ the token contract's state is updated, so
228      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
229      *
230      * This function may revert to prevent the operation from being executed.
231      */
232     function tokensReceived(
233         address operator,
234         address from,
235         address to,
236         uint256 amount,
237         bytes calldata userData,
238         bytes calldata operatorData
239     ) external;
240 }
241 
242 /**
243  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
244  *
245  * {IERC777} Token holders can be notified of operations performed on their
246  * tokens by having a contract implement this interface (contract holders can be
247  *  their own implementer) and registering it on the
248  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
249  *
250  * See {IERC1820Registry} and {ERC1820Implementer}.
251  */
252 interface IERC777Sender {
253     /**
254      * @dev Called by an {IERC777} token contract whenever a registered holder's
255      * (`from`) tokens are about to be moved or destroyed. The type of operation
256      * is conveyed by `to` being the zero address or not.
257      *
258      * This call occurs _before_ the token contract's state is updated, so
259      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
260      *
261      * This function may revert to prevent the operation from being executed.
262      */
263     function tokensToSend(
264         address operator,
265         address from,
266         address to,
267         uint256 amount,
268         bytes calldata userData,
269         bytes calldata operatorData
270     ) external;
271 }
272 
273 /**
274  * @dev Interface of the ERC20 standard as defined in the EIP.
275  */
276 interface IERC20 {
277     /**
278      * @dev Returns the amount of tokens in existence.
279      */
280     function totalSupply() external view returns (uint256);
281 
282     /**
283      * @dev Returns the amount of tokens owned by `account`.
284      */
285     function balanceOf(address account) external view returns (uint256);
286 
287     /**
288      * @dev Moves `amount` tokens from the caller's account to `recipient`.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transfer(address recipient, uint256 amount) external returns (bool);
295 
296     /**
297      * @dev Returns the remaining number of tokens that `spender` will be
298      * allowed to spend on behalf of `owner` through {transferFrom}. This is
299      * zero by default.
300      *
301      * This value changes when {approve} or {transferFrom} are called.
302      */
303     function allowance(address owner, address spender) external view returns (uint256);
304 
305     /**
306      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
307      *
308      * Returns a boolean value indicating whether the operation succeeded.
309      *
310      * IMPORTANT: Beware that changing an allowance with this method brings the risk
311      * that someone may use both the old and the new allowance by unfortunate
312      * transaction ordering. One possible solution to mitigate this race
313      * condition is to first reduce the spender's allowance to 0 and set the
314      * desired value afterwards:
315      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316      *
317      * Emits an {Approval} event.
318      */
319     function approve(address spender, uint256 amount) external returns (bool);
320 
321     /**
322      * @dev Moves `amount` tokens from `sender` to `recipient` using the
323      * allowance mechanism. `amount` is then deducted from the caller's
324      * allowance.
325      *
326      * Returns a boolean value indicating whether the operation succeeded.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
331 
332     /**
333      * @dev Emitted when `value` tokens are moved from one account (`from`) to
334      * another (`to`).
335      *
336      * Note that `value` may be zero.
337      */
338     event Transfer(address indexed from, address indexed to, uint256 value);
339 
340     /**
341      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
342      * a call to {approve}. `value` is the new allowance.
343      */
344     event Approval(address indexed owner, address indexed spender, uint256 value);
345 }
346 
347 /**
348  * @dev Wrappers over Solidity's arithmetic operations with added overflow
349  * checks.
350  *
351  * Arithmetic operations in Solidity wrap on overflow. This can easily result
352  * in bugs, because programmers usually assume that an overflow raises an
353  * error, which is the standard behavior in high level programming languages.
354  * `SafeMath` restores this intuition by reverting the transaction when an
355  * operation overflows.
356  *
357  * Using this library instead of the unchecked operations eliminates an entire
358  * class of bugs, so it's recommended to use it always.
359  */
360 library SafeMath {
361     /**
362      * @dev Returns the addition of two unsigned integers, reverting on
363      * overflow.
364      *
365      * Counterpart to Solidity's `+` operator.
366      *
367      * Requirements:
368      *
369      * - Addition cannot overflow.
370      */
371     function add(uint256 a, uint256 b) internal pure returns (uint256) {
372         uint256 c = a + b;
373         require(c >= a, "SafeMath: addition overflow");
374 
375         return c;
376     }
377 
378     /**
379      * @dev Returns the subtraction of two unsigned integers, reverting on
380      * overflow (when the result is negative).
381      *
382      * Counterpart to Solidity's `-` operator.
383      *
384      * Requirements:
385      *
386      * - Subtraction cannot overflow.
387      */
388     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
389         return sub(a, b, "SafeMath: subtraction overflow");
390     }
391 
392     /**
393      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
394      * overflow (when the result is negative).
395      *
396      * Counterpart to Solidity's `-` operator.
397      *
398      * Requirements:
399      *
400      * - Subtraction cannot overflow.
401      */
402     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
403         require(b <= a, errorMessage);
404         uint256 c = a - b;
405 
406         return c;
407     }
408 
409     /**
410      * @dev Returns the multiplication of two unsigned integers, reverting on
411      * overflow.
412      *
413      * Counterpart to Solidity's `*` operator.
414      *
415      * Requirements:
416      *
417      * - Multiplication cannot overflow.
418      */
419     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
420         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
421         // benefit is lost if 'b' is also tested.
422         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
423         if (a == 0) {
424             return 0;
425         }
426 
427         uint256 c = a * b;
428         require(c / a == b, "SafeMath: multiplication overflow");
429 
430         return c;
431     }
432 
433     /**
434      * @dev Returns the integer division of two unsigned integers. Reverts on
435      * division by zero. The result is rounded towards zero.
436      *
437      * Counterpart to Solidity's `/` operator. Note: this function uses a
438      * `revert` opcode (which leaves remaining gas untouched) while Solidity
439      * uses an invalid opcode to revert (consuming all remaining gas).
440      *
441      * Requirements:
442      *
443      * - The divisor cannot be zero.
444      */
445     function div(uint256 a, uint256 b) internal pure returns (uint256) {
446         return div(a, b, "SafeMath: division by zero");
447     }
448 
449     /**
450      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
451      * division by zero. The result is rounded towards zero.
452      *
453      * Counterpart to Solidity's `/` operator. Note: this function uses a
454      * `revert` opcode (which leaves remaining gas untouched) while Solidity
455      * uses an invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      *
459      * - The divisor cannot be zero.
460      */
461     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
462         require(b > 0, errorMessage);
463         uint256 c = a / b;
464         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
465 
466         return c;
467     }
468 
469     /**
470      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
471      * Reverts when dividing by zero.
472      *
473      * Counterpart to Solidity's `%` operator. This function uses a `revert`
474      * opcode (which leaves remaining gas untouched) while Solidity uses an
475      * invalid opcode to revert (consuming all remaining gas).
476      *
477      * Requirements:
478      *
479      * - The divisor cannot be zero.
480      */
481     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
482         return mod(a, b, "SafeMath: modulo by zero");
483     }
484 
485     /**
486      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
487      * Reverts with custom message when dividing by zero.
488      *
489      * Counterpart to Solidity's `%` operator. This function uses a `revert`
490      * opcode (which leaves remaining gas untouched) while Solidity uses an
491      * invalid opcode to revert (consuming all remaining gas).
492      *
493      * Requirements:
494      *
495      * - The divisor cannot be zero.
496      */
497     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
498         require(b != 0, errorMessage);
499         return a % b;
500     }
501 }
502 
503 /**
504  * @dev Collection of functions related to the address type
505  */
506 library Address {
507     /**
508      * @dev Returns true if `account` is a contract.
509      *
510      * [IMPORTANT]
511      * ====
512      * It is unsafe to assume that an address for which this function returns
513      * false is an externally-owned account (EOA) and not a contract.
514      *
515      * Among others, `isContract` will return false for the following
516      * types of addresses:
517      *
518      *  - an externally-owned account
519      *  - a contract in construction
520      *  - an address where a contract will be created
521      *  - an address where a contract lived, but was destroyed
522      * ====
523      */
524     function isContract(address account) internal view returns (bool) {
525         // This method relies on extcodesize, which returns 0 for contracts in
526         // construction, since the code is only stored at the end of the
527         // constructor execution.
528 
529         uint256 size;
530         // solhint-disable-next-line no-inline-assembly
531         assembly { size := extcodesize(account) }
532         return size > 0;
533     }
534 
535     /**
536      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
537      * `recipient`, forwarding all available gas and reverting on errors.
538      *
539      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
540      * of certain opcodes, possibly making contracts go over the 2300 gas limit
541      * imposed by `transfer`, making them unable to receive funds via
542      * `transfer`. {sendValue} removes this limitation.
543      *
544      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
545      *
546      * IMPORTANT: because control is transferred to `recipient`, care must be
547      * taken to not create reentrancy vulnerabilities. Consider using
548      * {ReentrancyGuard} or the
549      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
550      */
551     function sendValue(address payable recipient, uint256 amount) internal {
552         require(address(this).balance >= amount, "Address: insufficient balance");
553 
554         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
555         (bool success, ) = recipient.call{ value: amount }("");
556         require(success, "Address: unable to send value, recipient may have reverted");
557     }
558 
559     /**
560      * @dev Performs a Solidity function call using a low level `call`. A
561      * plain`call` is an unsafe replacement for a function call: use this
562      * function instead.
563      *
564      * If `target` reverts with a revert reason, it is bubbled up by this
565      * function (like regular Solidity function calls).
566      *
567      * Returns the raw returned data. To convert to the expected return value,
568      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
569      *
570      * Requirements:
571      *
572      * - `target` must be a contract.
573      * - calling `target` with `data` must not revert.
574      *
575      * _Available since v3.1._
576      */
577     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
578       return functionCall(target, data, "Address: low-level call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
583      * `errorMessage` as a fallback revert reason when `target` reverts.
584      *
585      * _Available since v3.1._
586      */
587     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
588         return functionCallWithValue(target, data, 0, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but also transferring `value` wei to `target`.
594      *
595      * Requirements:
596      *
597      * - the calling contract must have an ETH balance of at least `value`.
598      * - the called Solidity function must be `payable`.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
603         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
608      * with `errorMessage` as a fallback revert reason when `target` reverts.
609      *
610      * _Available since v3.1._
611      */
612     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
613         require(address(this).balance >= value, "Address: insufficient balance for call");
614         require(isContract(target), "Address: call to non-contract");
615 
616         // solhint-disable-next-line avoid-low-level-calls
617         (bool success, bytes memory returndata) = target.call{ value: value }(data);
618         return _verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
628         return functionStaticCall(target, data, "Address: low-level static call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
633      * but performing a static call.
634      *
635      * _Available since v3.3._
636      */
637     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
638         require(isContract(target), "Address: static call to non-contract");
639 
640         // solhint-disable-next-line avoid-low-level-calls
641         (bool success, bytes memory returndata) = target.staticcall(data);
642         return _verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
646         if (success) {
647             return returndata;
648         } else {
649             // Look for revert reason and bubble it up if present
650             if (returndata.length > 0) {
651                 // The easiest way to bubble the revert reason is using memory via assembly
652 
653                 // solhint-disable-next-line no-inline-assembly
654                 assembly {
655                     let returndata_size := mload(returndata)
656                     revert(add(32, returndata), returndata_size)
657                 }
658             } else {
659                 revert(errorMessage);
660             }
661         }
662     }
663 }
664 
665 /**
666  * @dev Interface of the global ERC1820 Registry, as defined in the
667  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
668  * implementers for interfaces in this registry, as well as query support.
669  *
670  * Implementers may be shared by multiple accounts, and can also implement more
671  * than a single interface for each account. Contracts can implement interfaces
672  * for themselves, but externally-owned accounts (EOA) must delegate this to a
673  * contract.
674  *
675  * {IERC165} interfaces can also be queried via the registry.
676  *
677  * For an in-depth explanation and source code analysis, see the EIP text.
678  */
679 interface IERC1820Registry {
680     /**
681      * @dev Sets `newManager` as the manager for `account`. A manager of an
682      * account is able to set interface implementers for it.
683      *
684      * By default, each account is its own manager. Passing a value of `0x0` in
685      * `newManager` will reset the manager to this initial state.
686      *
687      * Emits a {ManagerChanged} event.
688      *
689      * Requirements:
690      *
691      * - the caller must be the current manager for `account`.
692      */
693     function setManager(address account, address newManager) external;
694 
695     /**
696      * @dev Returns the manager for `account`.
697      *
698      * See {setManager}.
699      */
700     function getManager(address account) external view returns (address);
701 
702     /**
703      * @dev Sets the `implementer` contract as ``account``'s implementer for
704      * `interfaceHash`.
705      *
706      * `account` being the zero address is an alias for the caller's address.
707      * The zero address can also be used in `implementer` to remove an old one.
708      *
709      * See {interfaceHash} to learn how these are created.
710      *
711      * Emits an {InterfaceImplementerSet} event.
712      *
713      * Requirements:
714      *
715      * - the caller must be the current manager for `account`.
716      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
717      * end in 28 zeroes).
718      * - `implementer` must implement {IERC1820Implementer} and return true when
719      * queried for support, unless `implementer` is the caller. See
720      * {IERC1820Implementer-canImplementInterfaceForAddress}.
721      */
722     function setInterfaceImplementer(address account, bytes32 _interfaceHash, address implementer) external;
723 
724     /**
725      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
726      * implementer is registered, returns the zero address.
727      *
728      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
729      * zeroes), `account` will be queried for support of it.
730      *
731      * `account` being the zero address is an alias for the caller's address.
732      */
733     function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);
734 
735     /**
736      * @dev Returns the interface hash for an `interfaceName`, as defined in the
737      * corresponding
738      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
739      */
740     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
741 
742     /**
743      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
744      *  @param account Address of the contract for which to update the cache.
745      *  @param interfaceId ERC165 interface for which to update the cache.
746      */
747     function updateERC165Cache(address account, bytes4 interfaceId) external;
748 
749     /**
750      *  @notice Checks whether a contract implements an ERC165 interface or not.
751      *  If the result is not cached a direct lookup on the contract address is performed.
752      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
753      *  {updateERC165Cache} with the contract address.
754      *  @param account Address of the contract to check.
755      *  @param interfaceId ERC165 interface to check.
756      *  @return True if `account` implements `interfaceId`, false otherwise.
757      */
758     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
759 
760     /**
761      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
762      *  @param account Address of the contract to check.
763      *  @param interfaceId ERC165 interface to check.
764      *  @return True if `account` implements `interfaceId`, false otherwise.
765      */
766     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
767 
768     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
769 
770     event ManagerChanged(address indexed account, address indexed newManager);
771 }
772 
773 /**
774  * @dev Implementation of the {IERC777} interface.
775  *
776  * This implementation is agnostic to the way tokens are created. This means
777  * that a supply mechanism has to be added in a derived contract using {_mint}.
778  *
779  * Support for ERC20 is included in this contract, as specified by the EIP: both
780  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
781  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
782  * movements.
783  *
784  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
785  * are no special restrictions in the amount of tokens that created, moved, or
786  * destroyed. This makes integration with ERC20 applications seamless.
787  */
788 contract ERC777 is Context, IERC777, IERC20 {
789     using SafeMath for uint256;
790     using Address for address;
791 
792     IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
793 
794     mapping(address => uint256) private _balances;
795 
796     uint256 private _totalSupply;
797 
798     string private _name;
799     string private _symbol;
800 
801     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
802     // See https://github.com/ethereum/solidity/issues/4024.
803 
804     // keccak256("ERC777TokensSender")
805     bytes32 constant private _TOKENS_SENDER_INTERFACE_HASH =
806         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
807 
808     // keccak256("ERC777TokensRecipient")
809     bytes32 constant private _TOKENS_RECIPIENT_INTERFACE_HASH =
810         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
811 
812     // This isn't ever read from - it's only used to respond to the defaultOperators query.
813     address[] private _defaultOperatorsArray;
814 
815     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
816     mapping(address => bool) private _defaultOperators;
817 
818     // For each account, a mapping of its operators and revoked default operators.
819     mapping(address => mapping(address => bool)) private _operators;
820     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
821 
822     // ERC20-allowances
823     mapping (address => mapping (address => uint256)) private _allowances;
824 
825     /**
826      * @dev `defaultOperators` may be an empty array.
827      */
828     constructor(
829         string memory name_,
830         string memory symbol_,
831         address[] memory defaultOperators_
832     ) public {
833         _name = name_;
834         _symbol = symbol_;
835 
836         _defaultOperatorsArray = defaultOperators_;
837         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
838             _defaultOperators[_defaultOperatorsArray[i]] = true;
839         }
840 
841         // register interfaces
842         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
843         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
844     }
845 
846     /**
847      * @dev See {IERC777-name}.
848      */
849     function name() public view override returns (string memory) {
850         return _name;
851     }
852 
853     /**
854      * @dev See {IERC777-symbol}.
855      */
856     function symbol() public view override returns (string memory) {
857         return _symbol;
858     }
859 
860     /**
861      * @dev See {ERC20-decimals}.
862      *
863      * Always returns 18, as per the
864      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
865      */
866     function decimals() public pure returns (uint8) {
867         return 18;
868     }
869 
870     /**
871      * @dev See {IERC777-granularity}.
872      *
873      * This implementation always returns `1`.
874      */
875     function granularity() public view override returns (uint256) {
876         return 1;
877     }
878 
879     /**
880      * @dev See {IERC777-totalSupply}.
881      */
882     function totalSupply() public view override(IERC20, IERC777) returns (uint256) {
883         return _totalSupply;
884     }
885 
886     /**
887      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
888      */
889     function balanceOf(address tokenHolder) public view override(IERC20, IERC777) returns (uint256) {
890         return _balances[tokenHolder];
891     }
892 
893     /**
894      * @dev See {IERC777-send}.
895      *
896      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
897      */
898     function send(address recipient, uint256 amount, bytes memory data) public override  {
899         _send(_msgSender(), recipient, amount, data, "", true);
900     }
901 
902     /**
903      * @dev See {IERC20-transfer}.
904      *
905      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
906      * interface if it is a contract.
907      *
908      * Also emits a {Sent} event.
909      */
910     function transfer(address recipient, uint256 amount) public override returns (bool) {
911         require(recipient != address(0), "ERC777: transfer to the zero address");
912 
913         address from = _msgSender();
914 
915         _callTokensToSend(from, from, recipient, amount, "", "");
916 
917         _move(from, from, recipient, amount, "", "");
918 
919         _callTokensReceived(from, from, recipient, amount, "", "", false);
920 
921         return true;
922     }
923 
924     /**
925      * @dev See {IERC777-burn}.
926      *
927      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
928      */
929     function burn(uint256 amount, bytes memory data) public override  {
930         _burn(_msgSender(), amount, data, "");
931     }
932 
933     /**
934      * @dev See {IERC777-isOperatorFor}.
935      */
936     function isOperatorFor(
937         address operator,
938         address tokenHolder
939     ) public view override returns (bool) {
940         return operator == tokenHolder ||
941             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
942             _operators[tokenHolder][operator];
943     }
944 
945     /**
946      * @dev See {IERC777-authorizeOperator}.
947      */
948     function authorizeOperator(address operator) public override  {
949         require(_msgSender() != operator, "ERC777: authorizing self as operator");
950 
951         if (_defaultOperators[operator]) {
952             delete _revokedDefaultOperators[_msgSender()][operator];
953         } else {
954             _operators[_msgSender()][operator] = true;
955         }
956 
957         emit AuthorizedOperator(operator, _msgSender());
958     }
959 
960     /**
961      * @dev See {IERC777-revokeOperator}.
962      */
963     function revokeOperator(address operator) public override  {
964         require(operator != _msgSender(), "ERC777: revoking self as operator");
965 
966         if (_defaultOperators[operator]) {
967             _revokedDefaultOperators[_msgSender()][operator] = true;
968         } else {
969             delete _operators[_msgSender()][operator];
970         }
971 
972         emit RevokedOperator(operator, _msgSender());
973     }
974 
975     /**
976      * @dev See {IERC777-defaultOperators}.
977      */
978     function defaultOperators() public view override returns (address[] memory) {
979         return _defaultOperatorsArray;
980     }
981 
982     /**
983      * @dev See {IERC777-operatorSend}.
984      *
985      * Emits {Sent} and {IERC20-Transfer} events.
986      */
987     function operatorSend(
988         address sender,
989         address recipient,
990         uint256 amount,
991         bytes memory data,
992         bytes memory operatorData
993     )
994     public override
995     {
996         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
997         _send(sender, recipient, amount, data, operatorData, true);
998     }
999 
1000     /**
1001      * @dev See {IERC777-operatorBurn}.
1002      *
1003      * Emits {Burned} and {IERC20-Transfer} events.
1004      */
1005     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public override {
1006         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
1007         _burn(account, amount, data, operatorData);
1008     }
1009 
1010     /**
1011      * @dev See {IERC20-allowance}.
1012      *
1013      * Note that operator and allowance concepts are orthogonal: operators may
1014      * not have allowance, and accounts with allowance may not be operators
1015      * themselves.
1016      */
1017     function allowance(address holder, address spender) public view override returns (uint256) {
1018         return _allowances[holder][spender];
1019     }
1020 
1021     /**
1022      * @dev See {IERC20-approve}.
1023      *
1024      * Note that accounts cannot have allowance issued by their operators.
1025      */
1026     function approve(address spender, uint256 value) public override returns (bool) {
1027         address holder = _msgSender();
1028         _approve(holder, spender, value);
1029         return true;
1030     }
1031 
1032    /**
1033     * @dev See {IERC20-transferFrom}.
1034     *
1035     * Note that operator and allowance concepts are orthogonal: operators cannot
1036     * call `transferFrom` (unless they have allowance), and accounts with
1037     * allowance cannot call `operatorSend` (unless they are operators).
1038     *
1039     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
1040     */
1041     function transferFrom(address holder, address recipient, uint256 amount) public override returns (bool) {
1042         require(recipient != address(0), "ERC777: transfer to the zero address");
1043         require(holder != address(0), "ERC777: transfer from the zero address");
1044 
1045         address spender = _msgSender();
1046 
1047         _callTokensToSend(spender, holder, recipient, amount, "", "");
1048 
1049         _move(spender, holder, recipient, amount, "", "");
1050         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
1051 
1052         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
1053 
1054         return true;
1055     }
1056 
1057     /**
1058      * @dev Creates `amount` tokens and assigns them to `account`, increasing
1059      * the total supply.
1060      *
1061      * If a send hook is registered for `account`, the corresponding function
1062      * will be called with `operator`, `data` and `operatorData`.
1063      *
1064      * See {IERC777Sender} and {IERC777Recipient}.
1065      *
1066      * Emits {Minted} and {IERC20-Transfer} events.
1067      *
1068      * Requirements
1069      *
1070      * - `account` cannot be the zero address.
1071      * - if `account` is a contract, it must implement the {IERC777Recipient}
1072      * interface.
1073      */
1074     function _mint(
1075         address account,
1076         uint256 amount,
1077         bytes memory userData,
1078         bytes memory operatorData
1079     )
1080     internal virtual
1081     {
1082         require(account != address(0), "ERC777: mint to the zero address");
1083 
1084         address operator = _msgSender();
1085 
1086         _beforeTokenTransfer(operator, address(0), account, amount);
1087 
1088         // Update state variables
1089         _totalSupply = _totalSupply.add(amount);
1090         _balances[account] = _balances[account].add(amount);
1091 
1092         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1093 
1094         emit Minted(operator, account, amount, userData, operatorData);
1095         emit Transfer(address(0), account, amount);
1096     }
1097 
1098     /**
1099      * @dev Send tokens
1100      * @param from address token holder address
1101      * @param to address recipient address
1102      * @param amount uint256 amount of tokens to transfer
1103      * @param userData bytes extra information provided by the token holder (if any)
1104      * @param operatorData bytes extra information provided by the operator (if any)
1105      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1106      */
1107     function _send(
1108         address from,
1109         address to,
1110         uint256 amount,
1111         bytes memory userData,
1112         bytes memory operatorData,
1113         bool requireReceptionAck
1114     )
1115         internal
1116     {
1117         require(from != address(0), "ERC777: send from the zero address");
1118         require(to != address(0), "ERC777: send to the zero address");
1119 
1120         address operator = _msgSender();
1121 
1122         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1123 
1124         _move(operator, from, to, amount, userData, operatorData);
1125 
1126         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1127     }
1128 
1129     /**
1130      * @dev Burn tokens
1131      * @param from address token holder address
1132      * @param amount uint256 amount of tokens to burn
1133      * @param data bytes extra information provided by the token holder
1134      * @param operatorData bytes extra information provided by the operator (if any)
1135      */
1136     function _burn(
1137         address from,
1138         uint256 amount,
1139         bytes memory data,
1140         bytes memory operatorData
1141     )
1142         internal virtual
1143     {
1144         require(from != address(0), "ERC777: burn from the zero address");
1145 
1146         address operator = _msgSender();
1147 
1148         _beforeTokenTransfer(operator, from, address(0), amount);
1149 
1150         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1151 
1152         // Update state variables
1153         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1154         _totalSupply = _totalSupply.sub(amount);
1155 
1156         emit Burned(operator, from, amount, data, operatorData);
1157         emit Transfer(from, address(0), amount);
1158     }
1159 
1160     function _move(
1161         address operator,
1162         address from,
1163         address to,
1164         uint256 amount,
1165         bytes memory userData,
1166         bytes memory operatorData
1167     )
1168         private
1169     {
1170         _beforeTokenTransfer(operator, from, to, amount);
1171 
1172         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1173         _balances[to] = _balances[to].add(amount);
1174 
1175         emit Sent(operator, from, to, amount, userData, operatorData);
1176         emit Transfer(from, to, amount);
1177     }
1178 
1179     /**
1180      * @dev See {ERC20-_approve}.
1181      *
1182      * Note that accounts cannot have allowance issued by their operators.
1183      */
1184     function _approve(address holder, address spender, uint256 value) internal {
1185         require(holder != address(0), "ERC777: approve from the zero address");
1186         require(spender != address(0), "ERC777: approve to the zero address");
1187 
1188         _allowances[holder][spender] = value;
1189         emit Approval(holder, spender, value);
1190     }
1191 
1192     /**
1193      * @dev Call from.tokensToSend() if the interface is registered
1194      * @param operator address operator requesting the transfer
1195      * @param from address token holder address
1196      * @param to address recipient address
1197      * @param amount uint256 amount of tokens to transfer
1198      * @param userData bytes extra information provided by the token holder (if any)
1199      * @param operatorData bytes extra information provided by the operator (if any)
1200      */
1201     function _callTokensToSend(
1202         address operator,
1203         address from,
1204         address to,
1205         uint256 amount,
1206         bytes memory userData,
1207         bytes memory operatorData
1208     )
1209         private
1210     {
1211         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
1212         if (implementer != address(0)) {
1213             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1214         }
1215     }
1216 
1217     /**
1218      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1219      * tokensReceived() was not registered for the recipient
1220      * @param operator address operator requesting the transfer
1221      * @param from address token holder address
1222      * @param to address recipient address
1223      * @param amount uint256 amount of tokens to transfer
1224      * @param userData bytes extra information provided by the token holder (if any)
1225      * @param operatorData bytes extra information provided by the operator (if any)
1226      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1227      */
1228     function _callTokensReceived(
1229         address operator,
1230         address from,
1231         address to,
1232         uint256 amount,
1233         bytes memory userData,
1234         bytes memory operatorData,
1235         bool requireReceptionAck
1236     )
1237         private
1238     {
1239         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(to, _TOKENS_RECIPIENT_INTERFACE_HASH);
1240         if (implementer != address(0)) {
1241             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1242         } else if (requireReceptionAck) {
1243             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1244         }
1245     }
1246 
1247     /**
1248      * @dev Hook that is called before any token transfer. This includes
1249      * calls to {send}, {transfer}, {operatorSend}, minting and burning.
1250      *
1251      * Calling conditions:
1252      *
1253      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1254      * will be to transferred to `to`.
1255      * - when `from` is zero, `amount` tokens will be minted for `to`.
1256      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1257      * - `from` and `to` are never both zero.
1258      *
1259      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1260      */
1261     function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal virtual { }
1262 }
1263 
1264 /**
1265  * @dev Contract module which allows children to implement an emergency stop
1266  * mechanism that can be triggered by an authorized account.
1267  *
1268  * This module is used through inheritance. It will make available the
1269  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1270  * the functions of your contract. Note that they will not be pausable by
1271  * simply including this module, only once the modifiers are put in place.
1272  */
1273 abstract contract Pausable is Context {
1274     /**
1275      * @dev Emitted when the pause is triggered by `account`.
1276      */
1277     event Paused(address account);
1278 
1279     /**
1280      * @dev Emitted when the pause is lifted by `account`.
1281      */
1282     event Unpaused(address account);
1283 
1284     bool private _paused;
1285 
1286     /**
1287      * @dev Initializes the contract in unpaused state.
1288      */
1289     constructor () internal {
1290         _paused = false;
1291     }
1292 
1293     /**
1294      * @dev Returns true if the contract is paused, and false otherwise.
1295      */
1296     function paused() public view returns (bool) {
1297         return _paused;
1298     }
1299 
1300     /**
1301      * @dev Modifier to make a function callable only when the contract is not paused.
1302      *
1303      * Requirements:
1304      *
1305      * - The contract must not be paused.
1306      */
1307     modifier whenNotPaused() {
1308         require(!_paused, "Pausable: paused");
1309         _;
1310     }
1311 
1312     /**
1313      * @dev Modifier to make a function callable only when the contract is paused.
1314      *
1315      * Requirements:
1316      *
1317      * - The contract must be paused.
1318      */
1319     modifier whenPaused() {
1320         require(_paused, "Pausable: not paused");
1321         _;
1322     }
1323 
1324     /**
1325      * @dev Triggers stopped state.
1326      *
1327      * Requirements:
1328      *
1329      * - The contract must not be paused.
1330      */
1331     function _pause() internal virtual whenNotPaused {
1332         _paused = true;
1333         emit Paused(_msgSender());
1334     }
1335 
1336     /**
1337      * @dev Returns to normal state.
1338      *
1339      * Requirements:
1340      *
1341      * - The contract must be paused.
1342      */
1343     function _unpause() internal virtual whenPaused {
1344         _paused = false;
1345         emit Unpaused(_msgSender());
1346     }
1347 }
1348 
1349 /**
1350  * @dev Library for managing
1351  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1352  * types.
1353  *
1354  * Sets have the following properties:
1355  *
1356  * - Elements are added, removed, and checked for existence in constant time
1357  * (O(1)).
1358  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1359  *
1360  * ```
1361  * contract Example {
1362  *     // Add the library methods
1363  *     using EnumerableSet for EnumerableSet.AddressSet;
1364  *
1365  *     // Declare a set state variable
1366  *     EnumerableSet.AddressSet private mySet;
1367  * }
1368  * ```
1369  *
1370  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1371  * and `uint256` (`UintSet`) are supported.
1372  */
1373 library EnumerableSet {
1374     // To implement this library for multiple types with as little code
1375     // repetition as possible, we write it in terms of a generic Set type with
1376     // bytes32 values.
1377     // The Set implementation uses private functions, and user-facing
1378     // implementations (such as AddressSet) are just wrappers around the
1379     // underlying Set.
1380     // This means that we can only create new EnumerableSets for types that fit
1381     // in bytes32.
1382 
1383     struct Set {
1384         // Storage of set values
1385         bytes32[] _values;
1386 
1387         // Position of the value in the `values` array, plus 1 because index 0
1388         // means a value is not in the set.
1389         mapping (bytes32 => uint256) _indexes;
1390     }
1391 
1392     /**
1393      * @dev Add a value to a set. O(1).
1394      *
1395      * Returns true if the value was added to the set, that is if it was not
1396      * already present.
1397      */
1398     function _add(Set storage set, bytes32 value) private returns (bool) {
1399         if (!_contains(set, value)) {
1400             set._values.push(value);
1401             // The value is stored at length-1, but we add 1 to all indexes
1402             // and use 0 as a sentinel value
1403             set._indexes[value] = set._values.length;
1404             return true;
1405         } else {
1406             return false;
1407         }
1408     }
1409 
1410     /**
1411      * @dev Removes a value from a set. O(1).
1412      *
1413      * Returns true if the value was removed from the set, that is if it was
1414      * present.
1415      */
1416     function _remove(Set storage set, bytes32 value) private returns (bool) {
1417         // We read and store the value's index to prevent multiple reads from the same storage slot
1418         uint256 valueIndex = set._indexes[value];
1419 
1420         if (valueIndex != 0) { // Equivalent to contains(set, value)
1421             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1422             // the array, and then remove the last element (sometimes called as 'swap and pop').
1423             // This modifies the order of the array, as noted in {at}.
1424 
1425             uint256 toDeleteIndex = valueIndex - 1;
1426             uint256 lastIndex = set._values.length - 1;
1427 
1428             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1429             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1430 
1431             bytes32 lastvalue = set._values[lastIndex];
1432 
1433             // Move the last value to the index where the value to delete is
1434             set._values[toDeleteIndex] = lastvalue;
1435             // Update the index for the moved value
1436             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1437 
1438             // Delete the slot where the moved value was stored
1439             set._values.pop();
1440 
1441             // Delete the index for the deleted slot
1442             delete set._indexes[value];
1443 
1444             return true;
1445         } else {
1446             return false;
1447         }
1448     }
1449 
1450     /**
1451      * @dev Returns true if the value is in the set. O(1).
1452      */
1453     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1454         return set._indexes[value] != 0;
1455     }
1456 
1457     /**
1458      * @dev Returns the number of values on the set. O(1).
1459      */
1460     function _length(Set storage set) private view returns (uint256) {
1461         return set._values.length;
1462     }
1463 
1464    /**
1465     * @dev Returns the value stored at position `index` in the set. O(1).
1466     *
1467     * Note that there are no guarantees on the ordering of values inside the
1468     * array, and it may change when more values are added or removed.
1469     *
1470     * Requirements:
1471     *
1472     * - `index` must be strictly less than {length}.
1473     */
1474     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1475         require(set._values.length > index, "EnumerableSet: index out of bounds");
1476         return set._values[index];
1477     }
1478 
1479     // Bytes32Set
1480 
1481     struct Bytes32Set {
1482         Set _inner;
1483     }
1484 
1485     /**
1486      * @dev Add a value to a set. O(1).
1487      *
1488      * Returns true if the value was added to the set, that is if it was not
1489      * already present.
1490      */
1491     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1492         return _add(set._inner, value);
1493     }
1494 
1495     /**
1496      * @dev Removes a value from a set. O(1).
1497      *
1498      * Returns true if the value was removed from the set, that is if it was
1499      * present.
1500      */
1501     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1502         return _remove(set._inner, value);
1503     }
1504 
1505     /**
1506      * @dev Returns true if the value is in the set. O(1).
1507      */
1508     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1509         return _contains(set._inner, value);
1510     }
1511 
1512     /**
1513      * @dev Returns the number of values in the set. O(1).
1514      */
1515     function length(Bytes32Set storage set) internal view returns (uint256) {
1516         return _length(set._inner);
1517     }
1518 
1519    /**
1520     * @dev Returns the value stored at position `index` in the set. O(1).
1521     *
1522     * Note that there are no guarantees on the ordering of values inside the
1523     * array, and it may change when more values are added or removed.
1524     *
1525     * Requirements:
1526     *
1527     * - `index` must be strictly less than {length}.
1528     */
1529     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1530         return _at(set._inner, index);
1531     }
1532 
1533     // AddressSet
1534 
1535     struct AddressSet {
1536         Set _inner;
1537     }
1538 
1539     /**
1540      * @dev Add a value to a set. O(1).
1541      *
1542      * Returns true if the value was added to the set, that is if it was not
1543      * already present.
1544      */
1545     function add(AddressSet storage set, address value) internal returns (bool) {
1546         return _add(set._inner, bytes32(uint256(value)));
1547     }
1548 
1549     /**
1550      * @dev Removes a value from a set. O(1).
1551      *
1552      * Returns true if the value was removed from the set, that is if it was
1553      * present.
1554      */
1555     function remove(AddressSet storage set, address value) internal returns (bool) {
1556         return _remove(set._inner, bytes32(uint256(value)));
1557     }
1558 
1559     /**
1560      * @dev Returns true if the value is in the set. O(1).
1561      */
1562     function contains(AddressSet storage set, address value) internal view returns (bool) {
1563         return _contains(set._inner, bytes32(uint256(value)));
1564     }
1565 
1566     /**
1567      * @dev Returns the number of values in the set. O(1).
1568      */
1569     function length(AddressSet storage set) internal view returns (uint256) {
1570         return _length(set._inner);
1571     }
1572 
1573    /**
1574     * @dev Returns the value stored at position `index` in the set. O(1).
1575     *
1576     * Note that there are no guarantees on the ordering of values inside the
1577     * array, and it may change when more values are added or removed.
1578     *
1579     * Requirements:
1580     *
1581     * - `index` must be strictly less than {length}.
1582     */
1583     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1584         return address(uint256(_at(set._inner, index)));
1585     }
1586 
1587 
1588     // UintSet
1589 
1590     struct UintSet {
1591         Set _inner;
1592     }
1593 
1594     /**
1595      * @dev Add a value to a set. O(1).
1596      *
1597      * Returns true if the value was added to the set, that is if it was not
1598      * already present.
1599      */
1600     function add(UintSet storage set, uint256 value) internal returns (bool) {
1601         return _add(set._inner, bytes32(value));
1602     }
1603 
1604     /**
1605      * @dev Removes a value from a set. O(1).
1606      *
1607      * Returns true if the value was removed from the set, that is if it was
1608      * present.
1609      */
1610     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1611         return _remove(set._inner, bytes32(value));
1612     }
1613 
1614     /**
1615      * @dev Returns true if the value is in the set. O(1).
1616      */
1617     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1618         return _contains(set._inner, bytes32(value));
1619     }
1620 
1621     /**
1622      * @dev Returns the number of values on the set. O(1).
1623      */
1624     function length(UintSet storage set) internal view returns (uint256) {
1625         return _length(set._inner);
1626     }
1627 
1628    /**
1629     * @dev Returns the value stored at position `index` in the set. O(1).
1630     *
1631     * Note that there are no guarantees on the ordering of values inside the
1632     * array, and it may change when more values are added or removed.
1633     *
1634     * Requirements:
1635     *
1636     * - `index` must be strictly less than {length}.
1637     */
1638     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1639         return uint256(_at(set._inner, index));
1640     }
1641 }
1642 
1643 /**
1644  * @dev Contract module that allows children to implement role-based access
1645  * control mechanisms.
1646  *
1647  * Roles are referred to by their `bytes32` identifier. These should be exposed
1648  * in the external API and be unique. The best way to achieve this is by
1649  * using `public constant` hash digests:
1650  *
1651  * ```
1652  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1653  * ```
1654  *
1655  * Roles can be used to represent a set of permissions. To restrict access to a
1656  * function call, use {hasRole}:
1657  *
1658  * ```
1659  * function foo() public {
1660  *     require(hasRole(MY_ROLE, msg.sender));
1661  *     ...
1662  * }
1663  * ```
1664  *
1665  * Roles can be granted and revoked dynamically via the {grantRole} and
1666  * {revokeRole} functions. Each role has an associated admin role, and only
1667  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1668  *
1669  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1670  * that only accounts with this role will be able to grant or revoke other
1671  * roles. More complex role relationships can be created by using
1672  * {_setRoleAdmin}.
1673  *
1674  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1675  * grant and revoke this role. Extra precautions should be taken to secure
1676  * accounts that have been granted it.
1677  */
1678 abstract contract AccessControl is Context {
1679     using EnumerableSet for EnumerableSet.AddressSet;
1680     using Address for address;
1681 
1682     struct RoleData {
1683         EnumerableSet.AddressSet members;
1684         bytes32 adminRole;
1685     }
1686 
1687     mapping (bytes32 => RoleData) private _roles;
1688 
1689     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1690 
1691     /**
1692      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1693      *
1694      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1695      * {RoleAdminChanged} not being emitted signaling this.
1696      *
1697      * _Available since v3.1._
1698      */
1699     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1700 
1701     /**
1702      * @dev Emitted when `account` is granted `role`.
1703      *
1704      * `sender` is the account that originated the contract call, an admin role
1705      * bearer except when using {_setupRole}.
1706      */
1707     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1708 
1709     /**
1710      * @dev Emitted when `account` is revoked `role`.
1711      *
1712      * `sender` is the account that originated the contract call:
1713      *   - if using `revokeRole`, it is the admin role bearer
1714      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1715      */
1716     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1717 
1718     /**
1719      * @dev Returns `true` if `account` has been granted `role`.
1720      */
1721     function hasRole(bytes32 role, address account) public view returns (bool) {
1722         return _roles[role].members.contains(account);
1723     }
1724 
1725     /**
1726      * @dev Returns the number of accounts that have `role`. Can be used
1727      * together with {getRoleMember} to enumerate all bearers of a role.
1728      */
1729     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1730         return _roles[role].members.length();
1731     }
1732 
1733     /**
1734      * @dev Returns one of the accounts that have `role`. `index` must be a
1735      * value between 0 and {getRoleMemberCount}, non-inclusive.
1736      *
1737      * Role bearers are not sorted in any particular way, and their ordering may
1738      * change at any point.
1739      *
1740      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1741      * you perform all queries on the same block. See the following
1742      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1743      * for more information.
1744      */
1745     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1746         return _roles[role].members.at(index);
1747     }
1748 
1749     /**
1750      * @dev Returns the admin role that controls `role`. See {grantRole} and
1751      * {revokeRole}.
1752      *
1753      * To change a role's admin, use {_setRoleAdmin}.
1754      */
1755     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1756         return _roles[role].adminRole;
1757     }
1758 
1759     /**
1760      * @dev Grants `role` to `account`.
1761      *
1762      * If `account` had not been already granted `role`, emits a {RoleGranted}
1763      * event.
1764      *
1765      * Requirements:
1766      *
1767      * - the caller must have ``role``'s admin role.
1768      */
1769     function grantRole(bytes32 role, address account) public virtual {
1770         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1771 
1772         _grantRole(role, account);
1773     }
1774 
1775     /**
1776      * @dev Revokes `role` from `account`.
1777      *
1778      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1779      *
1780      * Requirements:
1781      *
1782      * - the caller must have ``role``'s admin role.
1783      */
1784     function revokeRole(bytes32 role, address account) public virtual {
1785         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1786 
1787         _revokeRole(role, account);
1788     }
1789 
1790     /**
1791      * @dev Revokes `role` from the calling account.
1792      *
1793      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1794      * purpose is to provide a mechanism for accounts to lose their privileges
1795      * if they are compromised (such as when a trusted device is misplaced).
1796      *
1797      * If the calling account had been granted `role`, emits a {RoleRevoked}
1798      * event.
1799      *
1800      * Requirements:
1801      *
1802      * - the caller must be `account`.
1803      */
1804     function renounceRole(bytes32 role, address account) public virtual {
1805         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1806 
1807         _revokeRole(role, account);
1808     }
1809 
1810     /**
1811      * @dev Grants `role` to `account`.
1812      *
1813      * If `account` had not been already granted `role`, emits a {RoleGranted}
1814      * event. Note that unlike {grantRole}, this function doesn't perform any
1815      * checks on the calling account.
1816      *
1817      * [WARNING]
1818      * ====
1819      * This function should only be called from the constructor when setting
1820      * up the initial roles for the system.
1821      *
1822      * Using this function in any other way is effectively circumventing the admin
1823      * system imposed by {AccessControl}.
1824      * ====
1825      */
1826     function _setupRole(bytes32 role, address account) internal virtual {
1827         _grantRole(role, account);
1828     }
1829 
1830     /**
1831      * @dev Sets `adminRole` as ``role``'s admin role.
1832      *
1833      * Emits a {RoleAdminChanged} event.
1834      */
1835     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1836         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1837         _roles[role].adminRole = adminRole;
1838     }
1839 
1840     function _grantRole(bytes32 role, address account) private {
1841         if (_roles[role].members.add(account)) {
1842             emit RoleGranted(role, account, _msgSender());
1843         }
1844     }
1845 
1846     function _revokeRole(bytes32 role, address account) private {
1847         if (_roles[role].members.remove(account)) {
1848             emit RoleRevoked(role, account, _msgSender());
1849         }
1850     }
1851 }
1852 
1853 /**
1854  * @dev ERC777 token with pausable token transfers, minting and burning.
1855  *
1856  * Useful for scenarios such as preventing trades until the end of an evaluation
1857  * period, or having an emergency switch for freezing all token transfers in the
1858  * event of a large bug.
1859  *
1860  * _Available since v3.1._
1861  */
1862 abstract contract ERC777MintablePausableBlocklistable is Context, AccessControl, ERC777, Pausable {
1863     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1864     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1865     bytes32 public constant BLOCK_ROLE = keccak256("BLOCK_ROLE");
1866 
1867     bool public _mintingFinished = false;
1868 
1869     mapping(address => bool) _blocklist;
1870     
1871     event Blocked(address account);
1872     event Unblocked(address account);
1873     event MintFinished();
1874 
1875     /**
1876      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, and `PAUSER_ROLE` to the account that
1877      * deploys the contract.
1878      */
1879     constructor(        
1880         string memory name,
1881         string memory symbol,
1882         address[] memory defaultOperators
1883     ) 
1884         public ERC777(name, symbol, defaultOperators) 
1885     {
1886         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1887 
1888         _setupRole(MINTER_ROLE, _msgSender());
1889         _setupRole(PAUSER_ROLE, _msgSender());
1890         _setupRole(BLOCK_ROLE, _msgSender());
1891     }
1892 
1893     /**
1894      * @dev Pauses all token transfers.
1895      *
1896      * See {Pausable-_pause}.
1897      *
1898      * Requirements:
1899      *
1900      * - the caller must have the `PAUSER_ROLE`.
1901      */
1902     function pause() public virtual {
1903         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC777MintablePausableBlacklistable: must have pauser role to pause");
1904         _pause();
1905     }
1906 
1907     /**
1908      * @dev Unpauses all token transfers.
1909      *
1910      * See {Pausable-_unpause}.
1911      *
1912      * Requirements:
1913      *
1914      * - the caller must have the `PAUSER_ROLE`.
1915      */
1916     function unpause() public virtual {
1917         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC777MintablePausableBlocklistable: must have pauser role to unpause");
1918         _unpause();
1919     }
1920 
1921     /**
1922      * @dev Block account
1923      *
1924      * Requirements:
1925      *
1926      * - the caller must have the `BLOCK_ROLE`.
1927      */
1928     function blockAccount(address account) public virtual {
1929         require(hasRole(BLOCK_ROLE, _msgSender()), "ERC777MintablePausableBlocklistable: must have block role to block");
1930         _blocklist[account] = true;
1931         emit Blocked(account);
1932     }
1933     
1934     /**
1935      * @dev Unblock account
1936      *
1937      * Requirements:
1938      *
1939      * - the caller must have the `BLOCK_ROLE`.
1940      */    
1941     function unblockAccount(address account) public virtual {
1942         require(hasRole(BLOCK_ROLE, _msgSender()), "ERC777MintablePausableBlocklistable: must have block role to unblock");
1943         _blocklist[account] = false;
1944         emit Unblocked(account);
1945     }
1946 
1947    /**
1948     * @return true if the user is blocked
1949     */
1950     function isBlockListed(address account) public view returns (bool) {
1951         return _blocklist[account];
1952     }
1953 
1954     /**
1955      * @dev See {ERC777-_mint}.
1956      *
1957      * Requirements:
1958      *
1959      * - the caller must have the {MinterRole}.
1960      */
1961     function mint(
1962         address account,
1963         uint256 amount,
1964         bytes memory userData,
1965         bytes memory operatorData
1966     ) public virtual {
1967         require(hasRole(MINTER_ROLE, _msgSender()), "ERC777MintablePausableBlocklistable: must have minter role to mint");
1968         require(!_mintingFinished, "ERC777MintablePausableBlocklistable: mint finished");
1969         
1970         _mint(account, amount, userData, operatorData);
1971     }
1972 
1973    /**
1974     * @return true if the minting is finished
1975     */
1976     function isFinishedMinting() public view returns (bool) {
1977         return _mintingFinished;
1978     }
1979 
1980     /**
1981     * @dev Function to stop minting new tokens.
1982     * @return True if the operation was successful.
1983     */
1984     function finishMinting() public returns (bool) {
1985         require(hasRole(MINTER_ROLE, _msgSender()), "ERC777MintablePausableBlocklistable: must have minter role to finish minting");
1986         _mintingFinished = true;
1987 
1988         emit MintFinished();
1989         return true;
1990     }
1991 
1992     /**
1993      * @dev See {ERC777-_beforeTokenTransfer}.
1994      *
1995      * Requirements:
1996      *
1997      * - the contract must not be paused.
1998      */
1999     function _beforeTokenTransfer(
2000         address operator, 
2001         address from, 
2002         address to, 
2003         uint256 amount
2004     )
2005 
2006         internal virtual override
2007     {
2008         super._beforeTokenTransfer(operator, from, to, amount);
2009 
2010         require(!paused(), "ERC20MintablePausableBlocklistable: token transfer while paused");
2011         require(!isBlockListed(operator), "ERC20MintablePausableBlocklistable: account is blocked");
2012         require(!isBlockListed(from), "ERC20MintablePausableBlocklistable: account is blocked");
2013         require(!isBlockListed(to), "ERC20MintablePausableBlocklistable: account is blocked");
2014     }
2015 
2016 }
2017 
2018 /**
2019  * @title VraToken
2020  */
2021 contract VraToken is ERC777MintablePausableBlocklistable {
2022 
2023     /**
2024      * @dev Constructor that gives msg.sender all of existing tokens.
2025      */
2026     constructor () public ERC777MintablePausableBlocklistable("VERA", "VRA", new address[](0)) {
2027         _mint(msg.sender, 10356466694667075153057994000, "", "");
2028     }  
2029 }