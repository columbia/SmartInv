1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-26
3 */
4 
5 // Sources flattened with hardhat v2.9.2 https://hardhat.org
6 
7 // File @rari-capital/solmate/src/tokens/ERC20.sol@v6.2.0
8 
9 
10 
11 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
12 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
13 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
14 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
15 abstract contract ERC20 {
16     /*///////////////////////////////////////////////////////////////
17                                   EVENTS
18     //////////////////////////////////////////////////////////////*/
19 
20     event Transfer(address indexed from, address indexed to, uint256 amount);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 amount);
23 
24     /*///////////////////////////////////////////////////////////////
25                              METADATA STORAGE
26     //////////////////////////////////////////////////////////////*/
27 
28     string public name;
29 
30     string public symbol;
31 
32     uint8 public immutable decimals;
33 
34     /*///////////////////////////////////////////////////////////////
35                               ERC20 STORAGE
36     //////////////////////////////////////////////////////////////*/
37 
38     uint256 public totalSupply;
39 
40     mapping(address => uint256) public balanceOf;
41 
42     mapping(address => mapping(address => uint256)) public allowance;
43 
44     /*///////////////////////////////////////////////////////////////
45                              EIP-2612 STORAGE
46     //////////////////////////////////////////////////////////////*/
47 
48     bytes32 public constant PERMIT_TYPEHASH =
49         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
50 
51     uint256 internal immutable INITIAL_CHAIN_ID;
52 
53     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
54 
55     mapping(address => uint256) public nonces;
56 
57     /*///////////////////////////////////////////////////////////////
58                                CONSTRUCTOR
59     //////////////////////////////////////////////////////////////*/
60 
61     constructor(
62         string memory _name,
63         string memory _symbol,
64         uint8 _decimals
65     ) {
66         name = _name;
67         symbol = _symbol;
68         decimals = _decimals;
69 
70         INITIAL_CHAIN_ID = block.chainid;
71         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
72     }
73 
74     /*///////////////////////////////////////////////////////////////
75                               ERC20 LOGIC
76     //////////////////////////////////////////////////////////////*/
77 
78     function approve(address spender, uint256 amount) public virtual returns (bool) {
79         allowance[msg.sender][spender] = amount;
80 
81         emit Approval(msg.sender, spender, amount);
82 
83         return true;
84     }
85 
86     function transfer(address to, uint256 amount) public virtual returns (bool) {
87         balanceOf[msg.sender] -= amount;
88 
89         // Cannot overflow because the sum of all user
90         // balances can't exceed the max uint256 value.
91         unchecked {
92             balanceOf[to] += amount;
93         }
94 
95         emit Transfer(msg.sender, to, amount);
96 
97         return true;
98     }
99 
100     function transferFrom(
101         address from,
102         address to,
103         uint256 amount
104     ) public virtual returns (bool) {
105         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
106 
107         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
108 
109         balanceOf[from] -= amount;
110 
111         // Cannot overflow because the sum of all user
112         // balances can't exceed the max uint256 value.
113         unchecked {
114             balanceOf[to] += amount;
115         }
116 
117         emit Transfer(from, to, amount);
118 
119         return true;
120     }
121 
122     /*///////////////////////////////////////////////////////////////
123                               EIP-2612 LOGIC
124     //////////////////////////////////////////////////////////////*/
125 
126     function permit(
127         address owner,
128         address spender,
129         uint256 value,
130         uint256 deadline,
131         uint8 v,
132         bytes32 r,
133         bytes32 s
134     ) public virtual {
135         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
136 
137         // Unchecked because the only math done is incrementing
138         // the owner's nonce which cannot realistically overflow.
139         unchecked {
140             bytes32 digest = keccak256(
141                 abi.encodePacked(
142                     "\x19\x01",
143                     DOMAIN_SEPARATOR(),
144                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
145                 )
146             );
147 
148             address recoveredAddress = ecrecover(digest, v, r, s);
149 
150             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
151 
152             allowance[recoveredAddress][spender] = value;
153         }
154 
155         emit Approval(owner, spender, value);
156     }
157 
158     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
159         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
160     }
161 
162     function computeDomainSeparator() internal view virtual returns (bytes32) {
163         return
164             keccak256(
165                 abi.encode(
166                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
167                     keccak256(bytes(name)),
168                     keccak256("1"),
169                     block.chainid,
170                     address(this)
171                 )
172             );
173     }
174 
175     /*///////////////////////////////////////////////////////////////
176                        INTERNAL MINT/BURN LOGIC
177     //////////////////////////////////////////////////////////////*/
178 
179     function _mint(address to, uint256 amount) internal virtual {
180         totalSupply += amount;
181 
182         // Cannot overflow because the sum of all user
183         // balances can't exceed the max uint256 value.
184         unchecked {
185             balanceOf[to] += amount;
186         }
187 
188         emit Transfer(address(0), to, amount);
189     }
190 
191     function _burn(address from, uint256 amount) internal virtual {
192         balanceOf[from] -= amount;
193 
194         // Cannot underflow because a user's balance
195         // will never be larger than the total supply.
196         unchecked {
197             totalSupply -= amount;
198         }
199 
200         emit Transfer(from, address(0), amount);
201     }
202 }
203 
204 
205 // File @rari-capital/solmate/src/utils/SafeTransferLib.sol@v6.2.0
206 
207 
208 
209 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
210 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol)
211 /// @author Modified from Gnosis (https://github.com/gnosis/gp-v2-contracts/blob/main/src/contracts/libraries/GPv2SafeERC20.sol)
212 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
213 library SafeTransferLib {
214     /*///////////////////////////////////////////////////////////////
215                             ETH OPERATIONS
216     //////////////////////////////////////////////////////////////*/
217 
218     function safeTransferETH(address to, uint256 amount) internal {
219         bool callStatus;
220 
221         assembly {
222             // Transfer the ETH and store if it succeeded or not.
223             callStatus := call(gas(), to, amount, 0, 0, 0, 0)
224         }
225 
226         require(callStatus, "ETH_TRANSFER_FAILED");
227     }
228 
229     /*///////////////////////////////////////////////////////////////
230                            ERC20 OPERATIONS
231     //////////////////////////////////////////////////////////////*/
232 
233     function safeTransferFrom(
234         ERC20 token,
235         address from,
236         address to,
237         uint256 amount
238     ) internal {
239         bool callStatus;
240 
241         assembly {
242             // Get a pointer to some free memory.
243             let freeMemoryPointer := mload(0x40)
244 
245             // Write the abi-encoded calldata to memory piece by piece:
246             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
247             mstore(add(freeMemoryPointer, 4), and(from, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "from" argument.
248             mstore(add(freeMemoryPointer, 36), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
249             mstore(add(freeMemoryPointer, 68), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
250 
251             // Call the token and store if it succeeded or not.
252             // We use 100 because the calldata length is 4 + 32 * 3.
253             callStatus := call(gas(), token, 0, freeMemoryPointer, 100, 0, 0)
254         }
255 
256         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FROM_FAILED");
257     }
258 
259     function safeTransfer(
260         ERC20 token,
261         address to,
262         uint256 amount
263     ) internal {
264         bool callStatus;
265 
266         assembly {
267             // Get a pointer to some free memory.
268             let freeMemoryPointer := mload(0x40)
269 
270             // Write the abi-encoded calldata to memory piece by piece:
271             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
272             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
273             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
274 
275             // Call the token and store if it succeeded or not.
276             // We use 68 because the calldata length is 4 + 32 * 2.
277             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
278         }
279 
280         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FAILED");
281     }
282 
283     function safeApprove(
284         ERC20 token,
285         address to,
286         uint256 amount
287     ) internal {
288         bool callStatus;
289 
290         assembly {
291             // Get a pointer to some free memory.
292             let freeMemoryPointer := mload(0x40)
293 
294             // Write the abi-encoded calldata to memory piece by piece:
295             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
296             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
297             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
298 
299             // Call the token and store if it succeeded or not.
300             // We use 68 because the calldata length is 4 + 32 * 2.
301             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
302         }
303 
304         require(didLastOptionalReturnCallSucceed(callStatus), "APPROVE_FAILED");
305     }
306 
307     /*///////////////////////////////////////////////////////////////
308                          INTERNAL HELPER LOGIC
309     //////////////////////////////////////////////////////////////*/
310 
311     function didLastOptionalReturnCallSucceed(bool callStatus) private pure returns (bool success) {
312         assembly {
313             // Get how many bytes the call returned.
314             let returnDataSize := returndatasize()
315 
316             // If the call reverted:
317             if iszero(callStatus) {
318                 // Copy the revert message into memory.
319                 returndatacopy(0, 0, returnDataSize)
320 
321                 // Revert with the same message.
322                 revert(0, returnDataSize)
323             }
324 
325             switch returnDataSize
326             case 32 {
327                 // Copy the return data into memory.
328                 returndatacopy(0, 0, returnDataSize)
329 
330                 // Set success to whether it returned true.
331                 success := iszero(iszero(mload(0)))
332             }
333             case 0 {
334                 // There was no return data.
335                 success := 1
336             }
337             default {
338                 // It returned some malformed input.
339                 success := 0
340             }
341         }
342     }
343 }
344 
345 
346 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
347 
348 // 
349 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
350 
351 
352 
353 /**
354  * @dev Interface of the ERC20 standard as defined in the EIP.
355  */
356 interface IERC20 {
357     /**
358      * @dev Returns the amount of tokens in existence.
359      */
360     function totalSupply() external view returns (uint256);
361 
362     /**
363      * @dev Returns the amount of tokens owned by `account`.
364      */
365     function balanceOf(address account) external view returns (uint256);
366 
367     /**
368      * @dev Moves `amount` tokens from the caller's account to `to`.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * Emits a {Transfer} event.
373      */
374     function transfer(address to, uint256 amount) external returns (bool);
375 
376     /**
377      * @dev Returns the remaining number of tokens that `spender` will be
378      * allowed to spend on behalf of `owner` through {transferFrom}. This is
379      * zero by default.
380      *
381      * This value changes when {approve} or {transferFrom} are called.
382      */
383     function allowance(address owner, address spender) external view returns (uint256);
384 
385     /**
386      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * IMPORTANT: Beware that changing an allowance with this method brings the risk
391      * that someone may use both the old and the new allowance by unfortunate
392      * transaction ordering. One possible solution to mitigate this race
393      * condition is to first reduce the spender's allowance to 0 and set the
394      * desired value afterwards:
395      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
396      *
397      * Emits an {Approval} event.
398      */
399     function approve(address spender, uint256 amount) external returns (bool);
400 
401     /**
402      * @dev Moves `amount` tokens from `from` to `to` using the
403      * allowance mechanism. `amount` is then deducted from the caller's
404      * allowance.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 amount
414     ) external returns (bool);
415 
416     /**
417      * @dev Emitted when `value` tokens are moved from one account (`from`) to
418      * another (`to`).
419      *
420      * Note that `value` may be zero.
421      */
422     event Transfer(address indexed from, address indexed to, uint256 value);
423 
424     /**
425      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
426      * a call to {approve}. `value` is the new allowance.
427      */
428     event Approval(address indexed owner, address indexed spender, uint256 value);
429 }
430 
431 
432 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
433 
434 // 
435 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
436 
437 
438 
439 /**
440  * @dev Collection of functions related to the address type
441  */
442 library Address {
443     /**
444      * @dev Returns true if `account` is a contract.
445      *
446      * [IMPORTANT]
447      * ====
448      * It is unsafe to assume that an address for which this function returns
449      * false is an externally-owned account (EOA) and not a contract.
450      *
451      * Among others, `isContract` will return false for the following
452      * types of addresses:
453      *
454      *  - an externally-owned account
455      *  - a contract in construction
456      *  - an address where a contract will be created
457      *  - an address where a contract lived, but was destroyed
458      * ====
459      *
460      * [IMPORTANT]
461      * ====
462      * You shouldn't rely on `isContract` to protect against flash loan attacks!
463      *
464      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
465      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
466      * constructor.
467      * ====
468      */
469     function isContract(address account) internal view returns (bool) {
470         // This method relies on extcodesize/address.code.length, which returns 0
471         // for contracts in construction, since the code is only stored at the end
472         // of the constructor execution.
473 
474         return account.code.length > 0;
475     }
476 
477     /**
478      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
479      * `recipient`, forwarding all available gas and reverting on errors.
480      *
481      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
482      * of certain opcodes, possibly making contracts go over the 2300 gas limit
483      * imposed by `transfer`, making them unable to receive funds via
484      * `transfer`. {sendValue} removes this limitation.
485      *
486      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
487      *
488      * IMPORTANT: because control is transferred to `recipient`, care must be
489      * taken to not create reentrancy vulnerabilities. Consider using
490      * {ReentrancyGuard} or the
491      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
492      */
493     function sendValue(address payable recipient, uint256 amount) internal {
494         require(address(this).balance >= amount, "Address: insufficient balance");
495 
496         (bool success, ) = recipient.call{value: amount}("");
497         require(success, "Address: unable to send value, recipient may have reverted");
498     }
499 
500     /**
501      * @dev Performs a Solidity function call using a low level `call`. A
502      * plain `call` is an unsafe replacement for a function call: use this
503      * function instead.
504      *
505      * If `target` reverts with a revert reason, it is bubbled up by this
506      * function (like regular Solidity function calls).
507      *
508      * Returns the raw returned data. To convert to the expected return value,
509      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
510      *
511      * Requirements:
512      *
513      * - `target` must be a contract.
514      * - calling `target` with `data` must not revert.
515      *
516      * _Available since v3.1._
517      */
518     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
519         return functionCall(target, data, "Address: low-level call failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
524      * `errorMessage` as a fallback revert reason when `target` reverts.
525      *
526      * _Available since v3.1._
527      */
528     function functionCall(
529         address target,
530         bytes memory data,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         return functionCallWithValue(target, data, 0, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but also transferring `value` wei to `target`.
539      *
540      * Requirements:
541      *
542      * - the calling contract must have an ETH balance of at least `value`.
543      * - the called Solidity function must be `payable`.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(
548         address target,
549         bytes memory data,
550         uint256 value
551     ) internal returns (bytes memory) {
552         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
557      * with `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         require(address(this).balance >= value, "Address: insufficient balance for call");
568         require(isContract(target), "Address: call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.call{value: value}(data);
571         return verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a static call.
577      *
578      * _Available since v3.3._
579      */
580     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
581         return functionStaticCall(target, data, "Address: low-level static call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a static call.
587      *
588      * _Available since v3.3._
589      */
590     function functionStaticCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal view returns (bytes memory) {
595         require(isContract(target), "Address: static call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.staticcall(data);
598         return verifyCallResult(success, returndata, errorMessage);
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
603      * but performing a delegate call.
604      *
605      * _Available since v3.4._
606      */
607     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
608         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
613      * but performing a delegate call.
614      *
615      * _Available since v3.4._
616      */
617     function functionDelegateCall(
618         address target,
619         bytes memory data,
620         string memory errorMessage
621     ) internal returns (bytes memory) {
622         require(isContract(target), "Address: delegate call to non-contract");
623 
624         (bool success, bytes memory returndata) = target.delegatecall(data);
625         return verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     /**
629      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
630      * revert reason using the provided one.
631      *
632      * _Available since v4.3._
633      */
634     function verifyCallResult(
635         bool success,
636         bytes memory returndata,
637         string memory errorMessage
638     ) internal pure returns (bytes memory) {
639         if (success) {
640             return returndata;
641         } else {
642             // Look for revert reason and bubble it up if present
643             if (returndata.length > 0) {
644                 // The easiest way to bubble the revert reason is using memory via assembly
645 
646                 assembly {
647                     let returndata_size := mload(returndata)
648                     revert(add(32, returndata), returndata_size)
649                 }
650             } else {
651                 revert(errorMessage);
652             }
653         }
654     }
655 }
656 
657 
658 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
659 
660 // 
661 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
662 
663 
664 
665 
666 /**
667  * @title SafeERC20
668  * @dev Wrappers around ERC20 operations that throw on failure (when the token
669  * contract returns false). Tokens that return no value (and instead revert or
670  * throw on failure) are also supported, non-reverting calls are assumed to be
671  * successful.
672  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
673  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
674  */
675 library SafeERC20 {
676     using Address for address;
677 
678     function safeTransfer(
679         IERC20 token,
680         address to,
681         uint256 value
682     ) internal {
683         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
684     }
685 
686     function safeTransferFrom(
687         IERC20 token,
688         address from,
689         address to,
690         uint256 value
691     ) internal {
692         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
693     }
694 
695     /**
696      * @dev Deprecated. This function has issues similar to the ones found in
697      * {IERC20-approve}, and its usage is discouraged.
698      *
699      * Whenever possible, use {safeIncreaseAllowance} and
700      * {safeDecreaseAllowance} instead.
701      */
702     function safeApprove(
703         IERC20 token,
704         address spender,
705         uint256 value
706     ) internal {
707         // safeApprove should only be called when setting an initial allowance,
708         // or when resetting it to zero. To increase and decrease it, use
709         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
710         require(
711             (value == 0) || (token.allowance(address(this), spender) == 0),
712             "SafeERC20: approve from non-zero to non-zero allowance"
713         );
714         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
715     }
716 
717     function safeIncreaseAllowance(
718         IERC20 token,
719         address spender,
720         uint256 value
721     ) internal {
722         uint256 newAllowance = token.allowance(address(this), spender) + value;
723         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
724     }
725 
726     function safeDecreaseAllowance(
727         IERC20 token,
728         address spender,
729         uint256 value
730     ) internal {
731         unchecked {
732             uint256 oldAllowance = token.allowance(address(this), spender);
733             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
734             uint256 newAllowance = oldAllowance - value;
735             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
736         }
737     }
738 
739     /**
740      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
741      * on the return value: the return value is optional (but if data is returned, it must not be false).
742      * @param token The token targeted by the call.
743      * @param data The call data (encoded using abi.encode or one of its variants).
744      */
745     function _callOptionalReturn(IERC20 token, bytes memory data) private {
746         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
747         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
748         // the target address contains contract code and also asserts for success in the low-level call.
749 
750         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
751         if (returndata.length > 0) {
752             // Return data is optional
753             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
754         }
755     }
756 }
757 
758 
759 // File contracts/interfaces/IStaking.sol
760 
761 // 
762 
763 
764 interface IStaking {
765     function stake(uint256 _amount, address _recipient) external returns (bool);
766 
767     function claim(address recipient) external;
768 
769     function unstake(uint256 _amount, bool _trigger) external;
770 
771     function index() external view returns (uint256);
772 }
773 
774 
775 // File contracts/interfaces/IWXBTRFLY.sol
776 
777 // 
778 
779 
780 interface IWXBTRFLY is IERC20 {
781     function wrapFromBTRFLY(uint256 _amount) external returns (uint256);
782 
783     function unwrapToBTRFLY(uint256 _amount) external returns (uint256);
784 
785     function wrapFromxBTRFLY(uint256 _amount) external returns (uint256);
786 
787     function unwrapToxBTRFLY(uint256 _amount) external returns (uint256);
788 
789     function xBTRFLYValue(uint256 _amount) external view returns (uint256);
790 
791     function wBTRFLYValue(uint256 _amount) external view returns (uint256);
792 
793     function realIndex() external view returns (uint256);
794 }
795 
796 
797 // File contracts/interfaces/IBTRFLY.sol
798 
799 // 
800 
801 
802 interface IBTRFLY is IERC20 {
803     function mint(address account_, uint256 amount_) external;
804 
805     function burn(uint256 amount) external;
806 
807     function burnFrom(address account_, uint256 amount_) external;
808 }
809 
810 
811 // File contracts/interfaces/IMariposa.sol
812 
813 // 
814 
815 
816 interface IMariposa {
817     function mintFor(address _recipient, uint256 amount) external;
818 }
819 
820 
821 // File @rari-capital/solmate/src/utils/ReentrancyGuard.sol@v6.2.0
822 
823 
824 
825 /// @notice Gas optimized reentrancy protection for smart contracts.
826 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
827 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
828 abstract contract ReentrancyGuard {
829     uint256 private reentrancyStatus = 1;
830 
831     modifier nonReentrant() {
832         require(reentrancyStatus == 1, "REENTRANCY");
833 
834         reentrancyStatus = 2;
835 
836         _;
837 
838         reentrancyStatus = 1;
839     }
840 }
841 
842 
843 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
844 
845 // 
846 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
847 
848 
849 
850 /**
851  * @dev Provides information about the current execution context, including the
852  * sender of the transaction and its data. While these are generally available
853  * via msg.sender and msg.data, they should not be accessed in such a direct
854  * manner, since when dealing with meta-transactions the account sending and
855  * paying for execution may not be the actual sender (as far as an application
856  * is concerned).
857  *
858  * This contract is only required for intermediate, library-like contracts.
859  */
860 abstract contract Context {
861     function _msgSender() internal view virtual returns (address) {
862         return msg.sender;
863     }
864 
865     function _msgData() internal view virtual returns (bytes calldata) {
866         return msg.data;
867     }
868 }
869 
870 
871 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
872 
873 // 
874 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
875 
876 
877 
878 /**
879  * @dev Contract module which provides a basic access control mechanism, where
880  * there is an account (an owner) that can be granted exclusive access to
881  * specific functions.
882  *
883  * By default, the owner account will be the one that deploys the contract. This
884  * can later be changed with {transferOwnership}.
885  *
886  * This module is used through inheritance. It will make available the modifier
887  * `onlyOwner`, which can be applied to your functions to restrict their use to
888  * the owner.
889  */
890 abstract contract Ownable is Context {
891     address private _owner;
892 
893     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
894 
895     /**
896      * @dev Initializes the contract setting the deployer as the initial owner.
897      */
898     constructor() {
899         _transferOwnership(_msgSender());
900     }
901 
902     /**
903      * @dev Returns the address of the current owner.
904      */
905     function owner() public view virtual returns (address) {
906         return _owner;
907     }
908 
909     /**
910      * @dev Throws if called by any account other than the owner.
911      */
912     modifier onlyOwner() {
913         require(owner() == _msgSender(), "Ownable: caller is not the owner");
914         _;
915     }
916 
917     /**
918      * @dev Leaves the contract without owner. It will not be possible to call
919      * `onlyOwner` functions anymore. Can only be called by the current owner.
920      *
921      * NOTE: Renouncing ownership will leave the contract without an owner,
922      * thereby removing any functionality that is only available to the owner.
923      */
924     function renounceOwnership() public virtual onlyOwner {
925         _transferOwnership(address(0));
926     }
927 
928     /**
929      * @dev Transfers ownership of the contract to a new account (`newOwner`).
930      * Can only be called by the current owner.
931      */
932     function transferOwnership(address newOwner) public virtual onlyOwner {
933         require(newOwner != address(0), "Ownable: new owner is the zero address");
934         _transferOwnership(newOwner);
935     }
936 
937     /**
938      * @dev Transfers ownership of the contract to a new account (`newOwner`).
939      * Internal function without access restriction.
940      */
941     function _transferOwnership(address newOwner) internal virtual {
942         address oldOwner = _owner;
943         _owner = newOwner;
944         emit OwnershipTransferred(oldOwner, newOwner);
945     }
946 }
947 
948 
949 // File contracts/core/RLBTRFLY.sol
950 
951 // 
952 
953 
954 
955 
956 
957 /// @title RLBTRFLY
958 /// @author ████
959 
960 /**
961     @notice
962     Partially adapted from Convex's CvxLockerV2 contract with some modifications and optimizations for the BTRFLY V2 requirements
963 */
964 
965 contract RLBTRFLY is ReentrancyGuard, Ownable {
966     using SafeTransferLib for ERC20;
967 
968     /**
969         @notice Lock balance details
970         @param  amount      uint224  Locked amount in the lock
971         @param  unlockTime  uint32   Unlock time of the lock
972      */
973     struct LockedBalance {
974         uint224 amount;
975         uint32 unlockTime;
976     }
977 
978     /**
979         @notice Balance details
980         @param  locked           uint224          Overall locked amount
981         @param  nextUnlockIndex  uint32           Index of earliest next unlock
982         @param  lockedBalances   LockedBalance[]  List of locked balances data
983      */
984     struct Balance {
985         uint224 locked;
986         uint32 nextUnlockIndex;
987         LockedBalance[] lockedBalances;
988     }
989 
990     // 1 epoch = 1 week
991     uint32 public constant EPOCH_DURATION = 1 weeks;
992     // Full lock duration = 16 epochs
993     uint256 public constant LOCK_DURATION = 16 * EPOCH_DURATION;
994 
995     ERC20 public immutable btrflyV2;
996 
997     uint256 public lockedSupply;
998 
999     mapping(address => Balance) public balances;
1000 
1001     bool public isShutdown;
1002 
1003     string public constant name = "Revenue-Locked BTRFLY";
1004     string public constant symbol = "rlBTRFLY";
1005     uint8 public constant decimals = 18;
1006 
1007     event Shutdown();
1008     event Locked(
1009         address indexed account,
1010         uint256 indexed epoch,
1011         uint256 amount
1012     );
1013     event Withdrawn(address indexed account, uint256 amount, bool relock);
1014 
1015     error ZeroAddress();
1016     error ZeroAmount();
1017     error IsShutdown();
1018     error InvalidNumber(uint256 value);
1019 
1020     /**
1021         @param  _btrflyV2  address  BTRFLYV2 token address
1022      */
1023     constructor(address _btrflyV2) {
1024         if (_btrflyV2 == address(0)) revert ZeroAddress();
1025         btrflyV2 = ERC20(_btrflyV2);
1026     }
1027 
1028     /**
1029         @notice Emergency method to shutdown the current locker contract which also force-unlock all locked tokens
1030      */
1031     function shutdown() external onlyOwner {
1032         if (isShutdown) revert IsShutdown();
1033 
1034         isShutdown = true;
1035 
1036         emit Shutdown();
1037     }
1038 
1039     /**
1040         @notice Locked balance of the specified account including those with expired locks
1041         @param  account  address  Account
1042         @return amount   uint256  Amount
1043      */
1044     function lockedBalanceOf(address account)
1045         external
1046         view
1047         returns (uint256 amount)
1048     {
1049         return balances[account].locked;
1050     }
1051 
1052     /**
1053         @notice Balance of the specified account by only including tokens in active locks
1054         @param  account  address  Account
1055         @return amount   uint256  Amount
1056      */
1057     function balanceOf(address account) external view returns (uint256 amount) {
1058         // Using storage as it's actually cheaper than allocating a new memory based variable
1059         Balance storage userBalance = balances[account];
1060         LockedBalance[] storage locks = userBalance.lockedBalances;
1061         uint256 nextUnlockIndex = userBalance.nextUnlockIndex;
1062 
1063         amount = balances[account].locked;
1064 
1065         uint256 locksLength = locks.length;
1066 
1067         // Skip all old records
1068         for (uint256 i = nextUnlockIndex; i < locksLength; ++i) {
1069             if (locks[i].unlockTime <= block.timestamp) {
1070                 amount -= locks[i].amount;
1071             } else {
1072                 break;
1073             }
1074         }
1075 
1076         // Remove amount locked in the next epoch
1077         if (
1078             locksLength > 0 &&
1079             uint256(locks[locksLength - 1].unlockTime) - LOCK_DURATION >
1080             getCurrentEpoch()
1081         ) {
1082             amount -= locks[locksLength - 1].amount;
1083         }
1084 
1085         return amount;
1086     }
1087 
1088     /**
1089         @notice Pending locked amount at the specified account
1090         @param  account  address  Account
1091         @return amount   uint256  Amount
1092      */
1093     function pendingLockOf(address account)
1094         external
1095         view
1096         returns (uint256 amount)
1097     {
1098         LockedBalance[] storage locks = balances[account].lockedBalances;
1099 
1100         uint256 locksLength = locks.length;
1101 
1102         if (
1103             locksLength > 0 &&
1104             uint256(locks[locksLength - 1].unlockTime) - LOCK_DURATION >
1105             getCurrentEpoch()
1106         ) {
1107             return locks[locksLength - 1].amount;
1108         }
1109 
1110         return 0;
1111     }
1112 
1113     /**
1114         @notice Locked balances details for the specifed account
1115         @param  account     address          Account
1116         @return total       uint256          Total amount
1117         @return unlockable  uint256          Unlockable amount
1118         @return locked      uint256          Locked amount
1119         @return lockData    LockedBalance[]  List of active locks
1120      */
1121     function lockedBalances(address account)
1122         external
1123         view
1124         returns (
1125             uint256 total,
1126             uint256 unlockable,
1127             uint256 locked,
1128             LockedBalance[] memory lockData
1129         )
1130     {
1131         Balance storage userBalance = balances[account];
1132         LockedBalance[] storage locks = userBalance.lockedBalances;
1133         uint256 nextUnlockIndex = userBalance.nextUnlockIndex;
1134         uint256 idx;
1135 
1136         for (uint256 i = nextUnlockIndex; i < locks.length; ++i) {
1137             if (locks[i].unlockTime > block.timestamp) {
1138                 if (idx == 0) {
1139                     lockData = new LockedBalance[](locks.length - i);
1140                 }
1141 
1142                 lockData[idx] = locks[i];
1143                 locked += lockData[idx].amount;
1144                 ++idx;
1145             } else {
1146                 unlockable += locks[i].amount;
1147             }
1148         }
1149 
1150         return (userBalance.locked, unlockable, locked, lockData);
1151     }
1152 
1153     /**
1154         @notice Get current epoch
1155         @return uint256  Current epoch
1156      */
1157     function getCurrentEpoch() public view returns (uint256) {
1158         return (block.timestamp / EPOCH_DURATION) * EPOCH_DURATION;
1159     }
1160 
1161     /**
1162         @notice Locked tokens cannot be withdrawn for the entire lock duration and are eligible to receive rewards
1163         @param  account  address  Account
1164         @param  amount   uint256  Amount
1165      */
1166     function lock(address account, uint256 amount) external nonReentrant {
1167         if (account == address(0)) revert ZeroAddress();
1168         if (amount == 0) revert ZeroAmount();
1169 
1170         btrflyV2.safeTransferFrom(msg.sender, address(this), amount);
1171 
1172         _lock(account, amount);
1173     }
1174 
1175     /**
1176         @notice Perform the actual lock
1177         @param  account  address  Account
1178         @param  amount   uint256  Amount
1179      */
1180     function _lock(address account, uint256 amount) internal {
1181         if (isShutdown) revert IsShutdown();
1182 
1183         Balance storage balance = balances[account];
1184 
1185         uint224 lockAmount = _toUint224(amount);
1186 
1187         balance.locked += lockAmount;
1188         lockedSupply += lockAmount;
1189 
1190         uint256 lockEpoch = getCurrentEpoch() + EPOCH_DURATION;
1191         uint256 unlockTime = lockEpoch + LOCK_DURATION;
1192         LockedBalance[] storage locks = balance.lockedBalances;
1193         uint256 idx = locks.length;
1194 
1195         // If the latest user lock is smaller than this lock, add a new entry to the end of the list
1196         // else, append it to the latest user lock
1197         if (idx == 0 || locks[idx - 1].unlockTime < unlockTime) {
1198             locks.push(
1199                 LockedBalance({
1200                     amount: lockAmount,
1201                     unlockTime: _toUint32(unlockTime)
1202                 })
1203             );
1204         } else {
1205             locks[idx - 1].amount += lockAmount;
1206         }
1207 
1208         emit Locked(account, lockEpoch, amount);
1209     }
1210 
1211     /**
1212         @notice Withdraw all currently locked tokens where the unlock time has passed
1213         @param  account     address  Account
1214         @param  relock      bool     Whether should relock
1215         @param  withdrawTo  address  Target receiver
1216      */
1217     function _processExpiredLocks(
1218         address account,
1219         bool relock,
1220         address withdrawTo
1221     ) internal {
1222         // Using storage as it's actually cheaper than allocating a new memory based variable
1223         Balance storage userBalance = balances[account];
1224         LockedBalance[] storage locks = userBalance.lockedBalances;
1225         uint224 locked;
1226         uint256 length = locks.length;
1227 
1228         if (isShutdown || locks[length - 1].unlockTime <= block.timestamp) {
1229             locked = userBalance.locked;
1230             userBalance.nextUnlockIndex = _toUint32(length);
1231         } else {
1232             // Using nextUnlockIndex to reduce the number of loops
1233             uint32 nextUnlockIndex = userBalance.nextUnlockIndex;
1234 
1235             for (uint256 i = nextUnlockIndex; i < length; ++i) {
1236                 // Unlock time must be less or equal to time
1237                 if (locks[i].unlockTime > block.timestamp) break;
1238 
1239                 // Add to cumulative amounts
1240                 locked += locks[i].amount;
1241                 ++nextUnlockIndex;
1242             }
1243 
1244             // Update the account's next unlock index
1245             userBalance.nextUnlockIndex = nextUnlockIndex;
1246         }
1247 
1248         if (locked == 0) revert ZeroAmount();
1249 
1250         // Update user balances and total supplies
1251         userBalance.locked -= locked;
1252         lockedSupply -= locked;
1253 
1254         emit Withdrawn(account, locked, relock);
1255 
1256         // Relock or return to user
1257         if (relock) {
1258             _lock(withdrawTo, locked);
1259         } else {
1260             btrflyV2.safeTransfer(withdrawTo, locked);
1261         }
1262     }
1263 
1264     /**
1265         @notice Withdraw expired locks to a different address
1266         @param  to  address  Target receiver
1267      */
1268     function withdrawExpiredLocksTo(address to) external nonReentrant {
1269         if (to == address(0)) revert ZeroAddress();
1270 
1271         _processExpiredLocks(msg.sender, false, to);
1272     }
1273 
1274     /**
1275         @notice Withdraw/relock all currently locked tokens where the unlock time has passed
1276         @param  relock  bool  Whether should relock
1277      */
1278     function processExpiredLocks(bool relock) external nonReentrant {
1279         _processExpiredLocks(msg.sender, relock, msg.sender);
1280     }
1281 
1282     /**
1283         @notice Validate and cast a uint256 integer to uint224
1284         @param  value  uint256  Value
1285         @return        uint224  Casted value
1286      */
1287     function _toUint224(uint256 value) internal pure returns (uint224) {
1288         if (value > type(uint224).max) revert InvalidNumber(value);
1289 
1290         return uint224(value);
1291     }
1292 
1293     /**
1294         @notice Validate and cast a uint256 integer to uint32
1295         @param  value  uint256  Value
1296         @return        uint32   Casted value
1297      */
1298     function _toUint32(uint256 value) internal pure returns (uint32) {
1299         if (value > type(uint32).max) revert InvalidNumber(value);
1300 
1301         return uint32(value);
1302     }
1303 }
1304 
1305 
1306 // File contracts/core/TokenMigrator.sol
1307 
1308 // SPDX-License-Identifier: MIT
1309 pragma solidity 0.8.12;
1310 
1311 
1312 
1313 
1314 
1315 
1316 
1317 
1318 /// @title BTRFLY V1 => V2 Token Migrator
1319 /// @author Realkinando
1320 
1321 /**
1322     @notice
1323     Enables users to convert BTRFLY, xBTRFLY & wxBTRFLY to BTRFLYV2, at a rate based on the wxStaking Index.
1324     Dependent on the contract having a sufficient allowance from Mariposa.
1325 
1326     receives btrfly/xBtrfly/wxBtrfly --> requests wx value for recipient --> unwraps btrfly and burns
1327 */
1328 
1329 contract TokenMigrator {
1330     using SafeERC20 for IBTRFLY;
1331     using SafeERC20 for IWXBTRFLY;
1332     using SafeTransferLib for ERC20;
1333 
1334     IWXBTRFLY public immutable wxBtrfly;
1335     ERC20 public immutable xBtrfly;
1336     ERC20 public immutable btrflyV2;
1337     IBTRFLY public immutable btrfly;
1338     IMariposa public immutable mariposa;
1339     IStaking public immutable staking;
1340     RLBTRFLY public immutable rlBtrfly;
1341 
1342     error ZeroAddress();
1343 
1344     event Migrate(
1345         uint256 wxAmount,
1346         uint256 xAmount,
1347         uint256 v1Amount,
1348         address indexed recipient,
1349         bool indexed lock,
1350         address indexed caller
1351     );
1352 
1353     /**
1354         @param wxBtrfly_  address  wxBTRFLY token address
1355         @param xBtrfly_   address  xBTRFLY token address
1356         @param btrflyV2_  address  BTRFLYV2 token address
1357         @param btrfly_    address  BTRFLY token address
1358         @param mariposa_  address  Mariposa contract address
1359         @param staking_   address  Staking contract address
1360         @param rlBtrfly_  address  rlBTRFLY token address
1361      */
1362     constructor(
1363         address wxBtrfly_,
1364         address xBtrfly_,
1365         address btrflyV2_,
1366         address btrfly_,
1367         address mariposa_,
1368         address staking_,
1369         address rlBtrfly_
1370     ) {
1371         if (wxBtrfly_ == address(0)) revert ZeroAddress();
1372         if (xBtrfly_ == address(0)) revert ZeroAddress();
1373         if (btrflyV2_ == address(0)) revert ZeroAddress();
1374         if (btrfly_ == address(0)) revert ZeroAddress();
1375         if (mariposa_ == address(0)) revert ZeroAddress();
1376         if (staking_ == address(0)) revert ZeroAddress();
1377         if (rlBtrfly_ == address(0)) revert ZeroAddress();
1378 
1379         wxBtrfly = IWXBTRFLY(wxBtrfly_);
1380         xBtrfly = ERC20(xBtrfly_);
1381         btrflyV2 = ERC20(btrflyV2_);
1382         btrfly = IBTRFLY(btrfly_);
1383         mariposa = IMariposa(mariposa_);
1384         staking = IStaking(staking_);
1385         rlBtrfly = RLBTRFLY(rlBtrfly_);
1386 
1387         xBtrfly.safeApprove(staking_, type(uint256).max);
1388         btrflyV2.safeApprove(rlBtrfly_, type(uint256).max);
1389     }
1390 
1391     /**
1392         @notice Migrate wxBTRFLY to BTRFLYV2
1393         @param  amount  uint256  Amount of wxBTRFLY to convert to BTRFLYV2
1394         @return         uint256  Amount of BTRFLY to burn
1395      */
1396     function _migrateWxBtrfly(uint256 amount) internal returns (uint256) {
1397         // Take custody of wxBTRFLY and unwrap to BTRFLY
1398         wxBtrfly.safeTransferFrom(msg.sender, address(this), amount);
1399 
1400         return wxBtrfly.unwrapToBTRFLY(amount);
1401     }
1402 
1403     /**
1404         @notice Migrate xBTRFLY to BTRFLYV2
1405         @param  amount      uint256  Amount of xBTRFLY to convert to BTRFLYV2
1406         @return mintAmount  uint256  Amount of BTRFLYV2 to mint
1407      */
1408     function _migrateXBtrfly(uint256 amount)
1409         internal
1410         returns (uint256 mintAmount)
1411     {
1412         // Unstake xBTRFLY
1413         xBtrfly.safeTransferFrom(msg.sender, address(this), amount);
1414         staking.unstake(amount, false);
1415 
1416         return wxBtrfly.wBTRFLYValue(amount);
1417     }
1418 
1419     /**
1420         @notice Migrate BTRFLY to BTRFLYV2
1421         @param  amount      uint256  Amount of BTRFLY to convert to BTRFLYV2
1422         @return mintAmount  uint256  Amount of BTRFLYV2 to mint
1423      */
1424     function _migrateBtrfly(uint256 amount)
1425         internal
1426         returns (uint256 mintAmount)
1427     {
1428         btrfly.safeTransferFrom(msg.sender, address(this), amount);
1429 
1430         return wxBtrfly.wBTRFLYValue(amount);
1431     }
1432 
1433     /**
1434         @notice Migrates multiple different BTRFLY token types to V2
1435         @param  wxAmount   uint256  Amount of wxBTRFLY
1436         @param  xAmount    uint256  Amount of xBTRFLY
1437         @param  v1Amount   uint256  Amount of BTRFLY
1438         @param  recipient  address  Address receiving V2 BTRFLY
1439         @param  lock       bool     Whether or not to lock
1440      */
1441     function migrate(
1442         uint256 wxAmount,
1443         uint256 xAmount,
1444         uint256 v1Amount,
1445         address recipient,
1446         bool lock
1447     ) external {
1448         if (recipient == address(0)) revert ZeroAddress();
1449 
1450         emit Migrate(wxAmount, xAmount, v1Amount, recipient, lock, msg.sender);
1451 
1452         uint256 burnAmount;
1453         uint256 mintAmount;
1454 
1455         if (wxAmount != 0) {
1456             burnAmount = _migrateWxBtrfly(wxAmount);
1457             mintAmount = wxAmount;
1458         }
1459 
1460         if (xAmount != 0) {
1461             burnAmount += xAmount;
1462             mintAmount += _migrateXBtrfly(xAmount);
1463         }
1464 
1465         if (v1Amount != 0) {
1466             burnAmount += v1Amount;
1467             mintAmount += _migrateBtrfly(v1Amount);
1468         }
1469 
1470         btrfly.burn(burnAmount);
1471         _mintBtrflyV2(mintAmount, recipient, lock);
1472     }
1473 
1474     /**
1475         @notice Mint BTRFLYV2 and (optionally) lock
1476         @param  amount     uint256  Amount of BTRFLYV2 to mint
1477         @param  recipient  address  Address to receive V2 BTRFLY
1478         @param  lock       bool     Whether or not to lock
1479      */
1480     function _mintBtrflyV2(
1481         uint256 amount,
1482         address recipient,
1483         bool lock
1484     ) internal {
1485         // If locking, mint BTRFLYV2 for TokenMigrator, who will lock on behalf of recipient
1486         mariposa.mintFor(lock ? address(this) : recipient, amount);
1487 
1488         if (lock) rlBtrfly.lock(recipient, amount);
1489     }
1490 }