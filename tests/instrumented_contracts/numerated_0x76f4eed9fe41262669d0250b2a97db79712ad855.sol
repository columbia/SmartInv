1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.8;
3 
4 // @openzeppelin/contracts/utils/Context.sol
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // @openzeppelin/contracts/utils/Address.sol
27 
28 /**
29  * @dev Collection of functions related to the address type
30  */
31 library Address {
32     /**
33      * @dev Returns true if `account` is a contract.
34      *
35      * [IMPORTANT]
36      * ====
37      * It is unsafe to assume that an address for which this function returns
38      * false is an externally-owned account (EOA) and not a contract.
39      *
40      * Among others, `isContract` will return false for the following
41      * types of addresses:
42      *
43      *  - an externally-owned account
44      *  - a contract in construction
45      *  - an address where a contract will be created
46      *  - an address where a contract lived, but was destroyed
47      * ====
48      *
49      * [IMPORTANT]
50      * ====
51      * You shouldn't rely on `isContract` to protect against flash loan attacks!
52      *
53      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
54      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
55      * constructor.
56      * ====
57      */
58     function isContract(address account) internal view returns (bool) {
59         // This method relies on extcodesize/address.code.length, which returns 0
60         // for contracts in construction, since the code is only stored at the end
61         // of the constructor execution.
62 
63         return account.code.length > 0;
64     }
65 
66     /**
67      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
68      * `recipient`, forwarding all available gas and reverting on errors.
69      *
70      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
71      * of certain opcodes, possibly making contracts go over the 2300 gas limit
72      * imposed by `transfer`, making them unable to receive funds via
73      * `transfer`. {sendValue} removes this limitation.
74      *
75      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
76      *
77      * IMPORTANT: because control is transferred to `recipient`, care must be
78      * taken to not create reentrancy vulnerabilities. Consider using
79      * {ReentrancyGuard} or the
80      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
81      */
82     function sendValue(address payable recipient, uint256 amount) internal {
83         require(address(this).balance >= amount, "Address: insufficient balance");
84 
85         (bool success, ) = recipient.call{value: amount}("");
86         require(success, "Address: unable to send value, recipient may have reverted");
87     }
88 
89     /**
90      * @dev Performs a Solidity function call using a low level `call`. A
91      * plain `call` is an unsafe replacement for a function call: use this
92      * function instead.
93      *
94      * If `target` reverts with a revert reason, it is bubbled up by this
95      * function (like regular Solidity function calls).
96      *
97      * Returns the raw returned data. To convert to the expected return value,
98      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
99      *
100      * Requirements:
101      *
102      * - `target` must be a contract.
103      * - calling `target` with `data` must not revert.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
108         return functionCall(target, data, "Address: low-level call failed");
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
113      * `errorMessage` as a fallback revert reason when `target` reverts.
114      *
115      * _Available since v3.1._
116      */
117     function functionCall(
118         address target,
119         bytes memory data,
120         string memory errorMessage
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
127      * but also transferring `value` wei to `target`.
128      *
129      * Requirements:
130      *
131      * - the calling contract must have an ETH balance of at least `value`.
132      * - the called Solidity function must be `payable`.
133      *
134      * _Available since v3.1._
135      */
136     function functionCallWithValue(
137         address target,
138         bytes memory data,
139         uint256 value
140     ) internal returns (bytes memory) {
141         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
146      * with `errorMessage` as a fallback revert reason when `target` reverts.
147      *
148      * _Available since v3.1._
149      */
150     function functionCallWithValue(
151         address target,
152         bytes memory data,
153         uint256 value,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         require(address(this).balance >= value, "Address: insufficient balance for call");
157         require(isContract(target), "Address: call to non-contract");
158 
159         (bool success, bytes memory returndata) = target.call{value: value}(data);
160         return verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
170         return functionStaticCall(target, data, "Address: low-level static call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
175      * but performing a static call.
176      *
177      * _Available since v3.3._
178      */
179     function functionStaticCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal view returns (bytes memory) {
184         require(isContract(target), "Address: static call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.staticcall(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but performing a delegate call.
193      *
194      * _Available since v3.4._
195      */
196     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
197         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
202      * but performing a delegate call.
203      *
204      * _Available since v3.4._
205      */
206     function functionDelegateCall(
207         address target,
208         bytes memory data,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         require(isContract(target), "Address: delegate call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.delegatecall(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
219      * revert reason using the provided one.
220      *
221      * _Available since v4.3._
222      */
223     function verifyCallResult(
224         bool success,
225         bytes memory returndata,
226         string memory errorMessage
227     ) internal pure returns (bytes memory) {
228         if (success) {
229             return returndata;
230         } else {
231             // Look for revert reason and bubble it up if present
232             if (returndata.length > 0) {
233                 // The easiest way to bubble the revert reason is using memory via assembly
234 
235                 assembly {
236                     let returndata_size := mload(returndata)
237                     revert(add(32, returndata), returndata_size)
238                 }
239             } else {
240                 revert(errorMessage);
241             }
242         }
243     }
244 }
245 
246 // @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
247 
248 /**
249  * @title SafeERC20
250  * @dev Wrappers around ERC20 operations that throw on failure (when the token
251  * contract returns false). Tokens that return no value (and instead revert or
252  * throw on failure) are also supported, non-reverting calls are assumed to be
253  * successful.
254  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
255  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
256  */
257 library SafeERC20 {
258     using Address for address;
259 
260     function safeTransfer(
261         IERC20 token,
262         address to,
263         uint256 value
264     ) internal {
265         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
266     }
267 
268     function safeTransferFrom(
269         IERC20 token,
270         address from,
271         address to,
272         uint256 value
273     ) internal {
274         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
275     }
276 
277     /**
278      * @dev Deprecated. This function has issues similar to the ones found in
279      * {IERC20-approve}, and its usage is discouraged.
280      *
281      * Whenever possible, use {safeIncreaseAllowance} and
282      * {safeDecreaseAllowance} instead.
283      */
284     function safeApprove(
285         IERC20 token,
286         address spender,
287         uint256 value
288     ) internal {
289         // safeApprove should only be called when setting an initial allowance,
290         // or when resetting it to zero. To increase and decrease it, use
291         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
292         require(
293             (value == 0) || (token.allowance(address(this), spender) == 0),
294             "SafeERC20: approve from non-zero to non-zero allowance"
295         );
296         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
297     }
298 
299     function safeIncreaseAllowance(
300         IERC20 token,
301         address spender,
302         uint256 value
303     ) internal {
304         uint256 newAllowance = token.allowance(address(this), spender) + value;
305         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
306     }
307 
308     function safeDecreaseAllowance(
309         IERC20 token,
310         address spender,
311         uint256 value
312     ) internal {
313         unchecked {
314             uint256 oldAllowance = token.allowance(address(this), spender);
315             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
316             uint256 newAllowance = oldAllowance - value;
317             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
318         }
319     }
320 
321     /**
322      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
323      * on the return value: the return value is optional (but if data is returned, it must not be false).
324      * @param token The token targeted by the call.
325      * @param data The call data (encoded using abi.encode or one of its variants).
326      */
327     function _callOptionalReturn(IERC20 token, bytes memory data) private {
328         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
329         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
330         // the target address contains contract code and also asserts for success in the low-level call.
331 
332         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
333         if (returndata.length > 0) {
334             // Return data is optional
335             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
336         }
337     }
338 }
339 
340 // @openzeppelin/contracts/access/Ownable.sol
341 
342 /**
343  * @dev Contract module which provides a basic access control mechanism, where
344  * there is an account (an owner) that can be granted exclusive access to
345  * specific functions.
346  *
347  * By default, the owner account will be the one that deploys the contract. This
348  * can later be changed with {transferOwnership}.
349  *
350  * This module is used through inheritance. It will make available the modifier
351  * `onlyOwner`, which can be applied to your functions to restrict their use to
352  * the owner.
353  */
354 abstract contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev Initializes the contract setting the deployer as the initial owner.
361      */
362     constructor() {
363         _transferOwnership(_msgSender());
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view virtual returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
378         _;
379     }
380 
381     /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         _transferOwnership(address(0));
390     }
391 
392     /**
393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
394      * Can only be called by the current owner.
395      */
396     function transferOwnership(address newOwner) public virtual onlyOwner {
397         require(newOwner != address(0), "Ownable: new owner is the zero address");
398         _transferOwnership(newOwner);
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Internal function without access restriction.
404      */
405     function _transferOwnership(address newOwner) internal virtual {
406         address oldOwner = _owner;
407         _owner = newOwner;
408         emit OwnershipTransferred(oldOwner, newOwner);
409     }
410 }
411 
412 // @openzeppelin/contracts/token/ERC20/IERC20.sol
413 
414 /**
415  * @dev Interface of the ERC20 standard as defined in the EIP.
416  */
417 interface IERC20 {
418     /**
419      * @dev Emitted when `value` tokens are moved from one account (`from`) to
420      * another (`to`).
421      *
422      * Note that `value` may be zero.
423      */
424     event Transfer(address indexed from, address indexed to, uint256 value);
425 
426     /**
427      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
428      * a call to {approve}. `value` is the new allowance.
429      */
430     event Approval(address indexed owner, address indexed spender, uint256 value);
431 
432     /**
433      * @dev Returns the amount of tokens in existence.
434      */
435     function totalSupply() external view returns (uint256);
436 
437     /**
438      * @dev Returns the amount of tokens owned by `account`.
439      */
440     function balanceOf(address account) external view returns (uint256);
441 
442     /**
443      * @dev Moves `amount` tokens from the caller's account to `to`.
444      *
445      * Returns a boolean value indicating whether the operation succeeded.
446      *
447      * Emits a {Transfer} event.
448      */
449     function transfer(address to, uint256 amount) external returns (bool);
450 
451     /**
452      * @dev Returns the remaining number of tokens that `spender` will be
453      * allowed to spend on behalf of `owner` through {transferFrom}. This is
454      * zero by default.
455      *
456      * This value changes when {approve} or {transferFrom} are called.
457      */
458     function allowance(address owner, address spender) external view returns (uint256);
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
462      *
463      * Returns a boolean value indicating whether the operation succeeded.
464      *
465      * IMPORTANT: Beware that changing an allowance with this method brings the risk
466      * that someone may use both the old and the new allowance by unfortunate
467      * transaction ordering. One possible solution to mitigate this race
468      * condition is to first reduce the spender's allowance to 0 and set the
469      * desired value afterwards:
470      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address spender, uint256 amount) external returns (bool);
475 
476     /**
477      * @dev Moves `amount` tokens from `from` to `to` using the
478      * allowance mechanism. `amount` is then deducted from the caller's
479      * allowance.
480      *
481      * Returns a boolean value indicating whether the operation succeeded.
482      *
483      * Emits a {Transfer} event.
484      */
485     function transferFrom(
486         address from,
487         address to,
488         uint256 amount
489     ) external returns (bool);
490 }
491 
492 // @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
493 
494 /**
495  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
496  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
497  *
498  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
499  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
500  * need to send a transaction, and thus is not required to hold Ether at all.
501  */
502 interface IERC20Permit {
503     /**
504      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
505      * given ``owner``'s signed approval.
506      *
507      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
508      * ordering also apply here.
509      *
510      * Emits an {Approval} event.
511      *
512      * Requirements:
513      *
514      * - `spender` cannot be the zero address.
515      * - `deadline` must be a timestamp in the future.
516      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
517      * over the EIP712-formatted function arguments.
518      * - the signature must use ``owner``'s current nonce (see {nonces}).
519      *
520      * For more information on the signature format, see the
521      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
522      * section].
523      */
524     function permit(
525         address owner,
526         address spender,
527         uint256 value,
528         uint256 deadline,
529         uint8 v,
530         bytes32 r,
531         bytes32 s
532     ) external;
533 
534     /**
535      * @dev Returns the current nonce for `owner`. This value must be
536      * included whenever a signature is generated for {permit}.
537      *
538      * Every successful call to {permit} increases ``owner``'s nonce by one. This
539      * prevents a signature from being used multiple times.
540      */
541     function nonces(address owner) external view returns (uint256);
542 
543     /**
544      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
545      */
546     // solhint-disable-next-line func-name-mixedcase
547     function DOMAIN_SEPARATOR() external view returns (bytes32);
548 }
549 
550 interface IOdosExecutor {
551   function executePath (
552     bytes calldata bytecode,
553     uint256[] memory inputAmount
554   ) external payable;
555 }
556 
557 interface IDaiStylePermit {
558     function permit(
559       address holder,
560       address spender,
561       uint256 nonce,
562       uint256 expiry,
563       bool allowed,
564       uint8 v,
565       bytes32 r,
566       bytes32 s
567     ) external;
568 }
569 
570 /// @title Routing contract for Odos SOR
571 /// @author Semiotic AI
572 /// @notice Wrapper with security gaurentees around execution of arbitrary operations on user tokens
573 contract OdosRouter is Ownable {
574   using SafeERC20 for IERC20;
575 
576   /// @dev The zero address is uniquely used to represent eth since it is already
577   /// recognized as an invalid ERC20, and due to its gas efficiency
578   address constant _ETH = address(0);
579 
580   /// @dev Contains all information needed to describe an input token being swapped from
581   struct inputToken {
582     address tokenAddress;
583     uint256 amountIn;
584     address receiver;
585     bytes permit;
586   }
587   /// @dev Contains all information needed to describe an output token being swapped to
588   struct outputToken {
589     address tokenAddress;
590     uint256 relativeValue;
591     address receiver;
592   }
593   /// @dev Swap event logging
594   event Swapped(
595     address sender,
596     uint256[] amountsIn,
597     address[] tokensIn,
598     uint256[] amountsOut,
599     outputToken[] outputs,
600     uint256 valueOutQuote
601   );
602   /// @dev Must exist in order for contract to receive eth
603   receive() external payable { }
604 
605   /// @notice Performs a swap for a given value of some combination of specified output tokens
606   /// @param inputs list of input token structs for the path being executed
607   /// @param outputs list of output token structs for the path being executed
608   /// @param valueOutQuote value of destination tokens quoted for the path
609   /// @param valueOutMin minimum amount of value out the user will accept
610   /// @param executor Address of contract that will execute the path
611   /// @param pathDefinition Encoded path definition for executor
612   function swap(
613     inputToken[] memory inputs,
614     outputToken[] memory outputs,
615     uint256 valueOutQuote,
616     uint256 valueOutMin,
617     address executor,
618     bytes calldata pathDefinition
619   )
620     external
621     payable
622     returns (uint256[] memory amountsOut, uint256 gasLeft)
623   {
624     // Check for valid output specifications
625     require(valueOutMin <= valueOutQuote, "Minimum greater than quote");
626     require(valueOutMin > 0, "Slippage limit too low");
627 
628     // Check input specification validity and transfer input tokens to executor
629     {
630       uint256 expected_msg_value = 0;
631       for (uint256 i = 0; i < inputs.length; i++) {
632         for (uint256 j = 0; j < i; j++) {
633           require(
634             inputs[i].tokenAddress != inputs[j].tokenAddress,
635             "Duplicate source tokens"
636           );
637         }
638         for (uint256 j = 0; j < outputs.length; j++) {
639           require(
640             inputs[i].tokenAddress != outputs[j].tokenAddress,
641             "Arbitrage not supported"
642           );
643         }
644         if (inputs[i].tokenAddress == _ETH) {
645           expected_msg_value = inputs[i].amountIn;
646         }
647         else {
648           _permit(inputs[i].tokenAddress, inputs[i].permit);
649           IERC20(inputs[i].tokenAddress).safeTransferFrom(
650             msg.sender,
651             inputs[i].receiver,
652             inputs[i].amountIn
653           );
654         }
655       }
656       require(msg.value == expected_msg_value, "Invalid msg.value");
657     }
658     // Check outputs for duplicates and record balances before swap
659     uint256[] memory balancesBefore = new uint256[](outputs.length);
660     for (uint256 i = 0; i < outputs.length; i++) {
661       for (uint256 j = 0; j < i; j++) {
662         require(
663           outputs[i].tokenAddress != outputs[j].tokenAddress,
664           "Duplicate destination tokens"
665         );
666       }
667       balancesBefore[i] = _universalBalance(outputs[i].tokenAddress);
668     }
669 
670     // Extract arrays of input amount values and tokens from the inputs struct list
671     uint256[] memory amountsIn = new uint256[](inputs.length);
672     address[] memory tokensIn = new address[](inputs.length);
673     {
674       for (uint256 i = 0; i < inputs.length; i++) {
675         amountsIn[i] = inputs[i].amountIn;
676         tokensIn[i] = inputs[i].tokenAddress;
677       }
678     }
679     // Delegate the execution of the path to the specified Odos Executor
680     IOdosExecutor(executor).executePath{value: msg.value}(pathDefinition, amountsIn);
681     {
682       uint256 valueOut;
683       amountsOut = new uint256[](outputs.length);
684       for (uint256 i = 0; i < outputs.length; i++) {
685         if (valueOut == valueOutQuote) break;
686 
687         // Record the destination token balance before the path is executed
688         amountsOut[i] = _universalBalance(outputs[i].tokenAddress) - balancesBefore[i];
689         valueOut += amountsOut[i] * outputs[i].relativeValue;
690 
691         // If the value out excedes the quoted value out, transfer enough to
692         // fulfil the quote and break the loop (any other tokens will be over quote)
693         if (valueOut > valueOutQuote) {
694           amountsOut[i] -= (valueOut - valueOutQuote) / outputs[i].relativeValue;
695           valueOut = valueOutQuote;
696         }
697         _universalTransfer(
698           outputs[i].tokenAddress,
699           outputs[i].receiver,
700           amountsOut[i]
701         );
702       }
703       require(valueOut > valueOutMin, "Slippage Limit Exceeded");
704     }
705     emit Swapped(
706       msg.sender,
707       amountsIn,
708       tokensIn,
709       amountsOut,
710       outputs,
711       valueOutQuote
712     );
713     gasLeft = gasleft();
714   }
715   /// @notice Allows the owner to transfer funds held by the router contract
716   /// @param tokens List of token address to be transferred
717   /// @param amounts List of amounts of each token to be transferred
718   /// @param dest Address to which the funds should be sent
719   function transferFunds(
720     address[] calldata tokens,
721     uint256[] calldata amounts,
722     address dest
723   )
724     external
725     onlyOwner
726   {
727     require(tokens.length == amounts.length, "Invalid funds transfer");
728     for (uint256 i = 0; i < tokens.length; i++) {
729       _universalTransfer(tokens[i], dest, amounts[i]);
730     }
731   }
732   /// @notice helper function to get balance of ERC20 or native coin for this contract
733   /// @param token address of the token to check, null for native coin
734   /// @return balance of specified coin or token
735   function _universalBalance(address token) private view returns(uint256) {
736     if (token == _ETH) {
737       return address(this).balance;
738     } else {
739       return IERC20(token).balanceOf(address(this));
740     }
741   }
742   /// @notice helper function to transfer ERC20 or native coin
743   /// @param token address of the token being transferred, null for native coin
744   /// @param to address to transfer to
745   /// @param amount to transfer
746   function _universalTransfer(address token, address to, uint256 amount) private {
747     if (token == _ETH) {
748       (bool success,) = payable(to).call{value: amount}("");
749       require(success, "ETH transfer failed");
750     } else {
751       IERC20(token).safeTransfer(to, amount);
752     }
753   }
754   /// @notice Executes an ERC20 or Dai Style Permit
755   /// @param token address of token permit is for
756   /// @param permit the byte information for permit execution, 0 for no operation
757   function _permit(address token, bytes memory permit) internal {
758     if (permit.length > 0) {
759       if (permit.length == 32 * 7) {
760         (bool success,) = token.call(abi.encodePacked(IERC20Permit.permit.selector, permit));
761         require(success, "IERC20Permit failed");
762       } else if (permit.length == 32 * 8) {
763         (bool success,) = token.call(abi.encodePacked(IDaiStylePermit.permit.selector, permit));
764         require(success, "Dai Style Permit failed");
765       } else {
766         revert("Invalid Permit");
767       }
768     }
769   }
770 }