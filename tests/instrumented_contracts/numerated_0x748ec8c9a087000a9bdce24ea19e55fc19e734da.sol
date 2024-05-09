1 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
9  *
10  * These functions can be used to verify that a message was signed by the holder
11  * of the private keys of a given address.
12  */
13 library ECDSA {
14     /**
15      * @dev Returns the address that signed a hashed message (`hash`) with
16      * `signature`. This address can then be used for verification purposes.
17      *
18      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
19      * this function rejects them by requiring the `s` value to be in the lower
20      * half order, and the `v` value to be either 27 or 28.
21      *
22      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
23      * verification to be secure: it is possible to craft signatures that
24      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
25      * this is by receiving a hash of the original message (which may otherwise
26      * be too long), and then calling {toEthSignedMessageHash} on it.
27      */
28     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
29         // Divide the signature in r, s and v variables
30         bytes32 r;
31         bytes32 s;
32         uint8 v;
33 
34         // Check the signature length
35         // - case 65: r,s,v signature (standard)
36         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
37         if (signature.length == 65) {
38             // ecrecover takes the signature parameters, and the only way to get them
39             // currently is to use assembly.
40             // solhint-disable-next-line no-inline-assembly
41             assembly {
42                 r := mload(add(signature, 0x20))
43                 s := mload(add(signature, 0x40))
44                 v := byte(0, mload(add(signature, 0x60)))
45             }
46         } else if (signature.length == 64) {
47             // ecrecover takes the signature parameters, and the only way to get them
48             // currently is to use assembly.
49             // solhint-disable-next-line no-inline-assembly
50             assembly {
51                 let vs := mload(add(signature, 0x40))
52                 r := mload(add(signature, 0x20))
53                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
54                 v := add(shr(255, vs), 27)
55             }
56         } else {
57             revert("ECDSA: invalid signature length");
58         }
59 
60         return recover(hash, v, r, s);
61     }
62 
63     /**
64      * @dev Overload of {ECDSA-recover} that receives the `v`,
65      * `r` and `s` signature fields separately.
66      */
67     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
68         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
69         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
70         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
71         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
72         //
73         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
74         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
75         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
76         // these malleable signatures as well.
77         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
78         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
79 
80         // If the signature is valid (and not malleable), return the signer address
81         address signer = ecrecover(hash, v, r, s);
82         require(signer != address(0), "ECDSA: invalid signature");
83 
84         return signer;
85     }
86 
87     /**
88      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
89      * produces hash corresponding to the one signed with the
90      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
91      * JSON-RPC method as part of EIP-191.
92      *
93      * See {recover}.
94      */
95     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
96         // 32 is the length in bytes of hash,
97         // enforced by the type signature above
98         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
99     }
100 
101     /**
102      * @dev Returns an Ethereum Signed Typed Data, created from a
103      * `domainSeparator` and a `structHash`. This produces hash corresponding
104      * to the one signed with the
105      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
106      * JSON-RPC method as part of EIP-712.
107      *
108      * See {recover}.
109      */
110     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
111         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
112     }
113 }
114 
115 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
116 
117 
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Contract module that helps prevent reentrant calls to a function.
123  *
124  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
125  * available, which can be applied to functions to make sure there are no nested
126  * (reentrant) calls to them.
127  *
128  * Note that because there is a single `nonReentrant` guard, functions marked as
129  * `nonReentrant` may not call one another. This can be worked around by making
130  * those functions `private`, and then adding `external` `nonReentrant` entry
131  * points to them.
132  *
133  * TIP: If you would like to learn more about reentrancy and alternative ways
134  * to protect against it, check out our blog post
135  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
136  */
137 abstract contract ReentrancyGuard {
138     // Booleans are more expensive than uint256 or any type that takes up a full
139     // word because each write operation emits an extra SLOAD to first read the
140     // slot's contents, replace the bits taken up by the boolean, and then write
141     // back. This is the compiler's defense against contract upgrades and
142     // pointer aliasing, and it cannot be disabled.
143 
144     // The values being non-zero value makes deployment a bit more expensive,
145     // but in exchange the refund on every call to nonReentrant will be lower in
146     // amount. Since refunds are capped to a percentage of the total
147     // transaction's gas, it is best to keep them low in cases like this one, to
148     // increase the likelihood of the full refund coming into effect.
149     uint256 private constant _NOT_ENTERED = 1;
150     uint256 private constant _ENTERED = 2;
151 
152     uint256 private _status;
153 
154     constructor () {
155         _status = _NOT_ENTERED;
156     }
157 
158     /**
159      * @dev Prevents a contract from calling itself, directly or indirectly.
160      * Calling a `nonReentrant` function from another `nonReentrant`
161      * function is not supported. It is possible to prevent this from happening
162      * by making the `nonReentrant` function external, and make it call a
163      * `private` function that does the actual work.
164      */
165     modifier nonReentrant() {
166         // On the first call to nonReentrant, _notEntered will be true
167         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
168 
169         // Any calls to nonReentrant after this point will fail
170         _status = _ENTERED;
171 
172         _;
173 
174         // By storing the original value once again, a refund is triggered (see
175         // https://eips.ethereum.org/EIPS/eip-2200)
176         _status = _NOT_ENTERED;
177     }
178 }
179 
180 // File: @openzeppelin/contracts/utils/Address.sol
181 
182 
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @dev Collection of functions related to the address type
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * [IMPORTANT]
194      * ====
195      * It is unsafe to assume that an address for which this function returns
196      * false is an externally-owned account (EOA) and not a contract.
197      *
198      * Among others, `isContract` will return false for the following
199      * types of addresses:
200      *
201      *  - an externally-owned account
202      *  - a contract in construction
203      *  - an address where a contract will be created
204      *  - an address where a contract lived, but was destroyed
205      * ====
206      */
207     function isContract(address account) internal view returns (bool) {
208         // This method relies on extcodesize, which returns 0 for contracts in
209         // construction, since the code is only stored at the end of the
210         // constructor execution.
211 
212         uint256 size;
213         // solhint-disable-next-line no-inline-assembly
214         assembly { size := extcodesize(account) }
215         return size > 0;
216     }
217 
218     /**
219      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
220      * `recipient`, forwarding all available gas and reverting on errors.
221      *
222      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
223      * of certain opcodes, possibly making contracts go over the 2300 gas limit
224      * imposed by `transfer`, making them unable to receive funds via
225      * `transfer`. {sendValue} removes this limitation.
226      *
227      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
228      *
229      * IMPORTANT: because control is transferred to `recipient`, care must be
230      * taken to not create reentrancy vulnerabilities. Consider using
231      * {ReentrancyGuard} or the
232      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
233      */
234     function sendValue(address payable recipient, uint256 amount) internal {
235         require(address(this).balance >= amount, "Address: insufficient balance");
236 
237         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
238         (bool success, ) = recipient.call{ value: amount }("");
239         require(success, "Address: unable to send value, recipient may have reverted");
240     }
241 
242     /**
243      * @dev Performs a Solidity function call using a low level `call`. A
244      * plain`call` is an unsafe replacement for a function call: use this
245      * function instead.
246      *
247      * If `target` reverts with a revert reason, it is bubbled up by this
248      * function (like regular Solidity function calls).
249      *
250      * Returns the raw returned data. To convert to the expected return value,
251      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
252      *
253      * Requirements:
254      *
255      * - `target` must be a contract.
256      * - calling `target` with `data` must not revert.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
261       return functionCall(target, data, "Address: low-level call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
266      * `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
271         return functionCallWithValue(target, data, 0, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but also transferring `value` wei to `target`.
277      *
278      * Requirements:
279      *
280      * - the calling contract must have an ETH balance of at least `value`.
281      * - the called Solidity function must be `payable`.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
291      * with `errorMessage` as a fallback revert reason when `target` reverts.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
296         require(address(this).balance >= value, "Address: insufficient balance for call");
297         require(isContract(target), "Address: call to non-contract");
298 
299         // solhint-disable-next-line avoid-low-level-calls
300         (bool success, bytes memory returndata) = target.call{ value: value }(data);
301         return _verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but performing a static call.
307      *
308      * _Available since v3.3._
309      */
310     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
311         return functionStaticCall(target, data, "Address: low-level static call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
321         require(isContract(target), "Address: static call to non-contract");
322 
323         // solhint-disable-next-line avoid-low-level-calls
324         (bool success, bytes memory returndata) = target.staticcall(data);
325         return _verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but performing a delegate call.
331      *
332      * _Available since v3.4._
333      */
334     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
335         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a delegate call.
341      *
342      * _Available since v3.4._
343      */
344     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
345         require(isContract(target), "Address: delegate call to non-contract");
346 
347         // solhint-disable-next-line avoid-low-level-calls
348         (bool success, bytes memory returndata) = target.delegatecall(data);
349         return _verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
353         if (success) {
354             return returndata;
355         } else {
356             // Look for revert reason and bubble it up if present
357             if (returndata.length > 0) {
358                 // The easiest way to bubble the revert reason is using memory via assembly
359 
360                 // solhint-disable-next-line no-inline-assembly
361                 assembly {
362                     let returndata_size := mload(returndata)
363                     revert(add(32, returndata), returndata_size)
364                 }
365             } else {
366                 revert(errorMessage);
367             }
368         }
369     }
370 }
371 
372 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
373 
374 
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev Interface of the ERC20 standard as defined in the EIP.
380  */
381 interface IERC20 {
382     /**
383      * @dev Returns the amount of tokens in existence.
384      */
385     function totalSupply() external view returns (uint256);
386 
387     /**
388      * @dev Returns the amount of tokens owned by `account`.
389      */
390     function balanceOf(address account) external view returns (uint256);
391 
392     /**
393      * @dev Moves `amount` tokens from the caller's account to `recipient`.
394      *
395      * Returns a boolean value indicating whether the operation succeeded.
396      *
397      * Emits a {Transfer} event.
398      */
399     function transfer(address recipient, uint256 amount) external returns (bool);
400 
401     /**
402      * @dev Returns the remaining number of tokens that `spender` will be
403      * allowed to spend on behalf of `owner` through {transferFrom}. This is
404      * zero by default.
405      *
406      * This value changes when {approve} or {transferFrom} are called.
407      */
408     function allowance(address owner, address spender) external view returns (uint256);
409 
410     /**
411      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
412      *
413      * Returns a boolean value indicating whether the operation succeeded.
414      *
415      * IMPORTANT: Beware that changing an allowance with this method brings the risk
416      * that someone may use both the old and the new allowance by unfortunate
417      * transaction ordering. One possible solution to mitigate this race
418      * condition is to first reduce the spender's allowance to 0 and set the
419      * desired value afterwards:
420      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
421      *
422      * Emits an {Approval} event.
423      */
424     function approve(address spender, uint256 amount) external returns (bool);
425 
426     /**
427      * @dev Moves `amount` tokens from `sender` to `recipient` using the
428      * allowance mechanism. `amount` is then deducted from the caller's
429      * allowance.
430      *
431      * Returns a boolean value indicating whether the operation succeeded.
432      *
433      * Emits a {Transfer} event.
434      */
435     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
436 
437     /**
438      * @dev Emitted when `value` tokens are moved from one account (`from`) to
439      * another (`to`).
440      *
441      * Note that `value` may be zero.
442      */
443     event Transfer(address indexed from, address indexed to, uint256 value);
444 
445     /**
446      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
447      * a call to {approve}. `value` is the new allowance.
448      */
449     event Approval(address indexed owner, address indexed spender, uint256 value);
450 }
451 
452 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
453 
454 
455 
456 pragma solidity ^0.8.0;
457 
458 
459 
460 /**
461  * @title SafeERC20
462  * @dev Wrappers around ERC20 operations that throw on failure (when the token
463  * contract returns false). Tokens that return no value (and instead revert or
464  * throw on failure) are also supported, non-reverting calls are assumed to be
465  * successful.
466  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
467  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
468  */
469 library SafeERC20 {
470     using Address for address;
471 
472     function safeTransfer(IERC20 token, address to, uint256 value) internal {
473         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
474     }
475 
476     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
477         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
478     }
479 
480     /**
481      * @dev Deprecated. This function has issues similar to the ones found in
482      * {IERC20-approve}, and its usage is discouraged.
483      *
484      * Whenever possible, use {safeIncreaseAllowance} and
485      * {safeDecreaseAllowance} instead.
486      */
487     function safeApprove(IERC20 token, address spender, uint256 value) internal {
488         // safeApprove should only be called when setting an initial allowance,
489         // or when resetting it to zero. To increase and decrease it, use
490         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
491         // solhint-disable-next-line max-line-length
492         require((value == 0) || (token.allowance(address(this), spender) == 0),
493             "SafeERC20: approve from non-zero to non-zero allowance"
494         );
495         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
496     }
497 
498     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
499         uint256 newAllowance = token.allowance(address(this), spender) + value;
500         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501     }
502 
503     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
504         unchecked {
505             uint256 oldAllowance = token.allowance(address(this), spender);
506             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
507             uint256 newAllowance = oldAllowance - value;
508             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
509         }
510     }
511 
512     /**
513      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
514      * on the return value: the return value is optional (but if data is returned, it must not be false).
515      * @param token The token targeted by the call.
516      * @param data The call data (encoded using abi.encode or one of its variants).
517      */
518     function _callOptionalReturn(IERC20 token, bytes memory data) private {
519         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
520         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
521         // the target address contains contract code and also asserts for success in the low-level call.
522 
523         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
524         if (returndata.length > 0) { // Return data is optional
525             // solhint-disable-next-line max-line-length
526             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
527         }
528     }
529 }
530 
531 // File: contracts/AngryMining.sol
532 
533 
534 pragma solidity ^0.8.4;
535 
536 
537 
538 
539 contract AngryMining is ReentrancyGuard{
540     using SafeERC20 for IERC20;
541     using ECDSA for bytes32;
542     
543     struct UserInfo {
544         uint256 amount; // How many LP tokens the user has provided.
545         uint256 rewardDebt; // Reward debt. See explanation below.
546         uint256 reward;
547     }
548     // Info of each pool.
549     struct PoolInfo {
550         IERC20 lpToken; // Address of LP token contract.
551         uint256 allocPoint; // How many allocation points assigned to this pool. ANGRYs to distribute per block.
552         uint256 lastRewardBlock; // Last block number that ANGRYs distribution occurs.
553         uint256 accAngryPerShare; // Accumulated ANGRYs per share, times 1e12. See below.
554         uint256 stakeAmount;
555     }
556     struct PoolItem {
557         uint256 pid;
558         uint256 allocPoint;
559         address lpToken;
560     }
561     struct BonusPeriod{
562         uint256 beginBlock;
563         uint256 endBlock;
564     }
565     struct LpMiningInfo{
566         uint256 pid;
567         address lpToken;
568         uint256 amount;
569         uint256 reward;
570     }
571     bool public bInited;
572     address public owner;
573     IERC20 public angryToken;
574     // ANGRY tokens created per block.
575     uint256 public angryPerBlock;
576     // Bonus muliplier for early angry makers.
577     uint256 public constant BONUS_MULTIPLIER = 2;
578     // Info of each pool.
579     PoolInfo[] public poolInfo;
580     // Info of each user that stakes LP tokens.
581     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
582     // Total allocation points. Must be the sum of all allocation points in all pools.
583     uint256 public totalAllocPoint;
584     BonusPeriod[] public bonusPeriods;
585     mapping(address => bool) public executorList;
586     address[5] public adminList;
587     mapping(string => bool) public usedUUIDs;
588     
589     event ExecutorAdd(address _newAddr);
590     event ExecutorDel(address _oldAddr);
591     event BonusPeriodAdd(uint256 _beginBlock, uint256 _endBlock);
592     event LpDeposit(address indexed user, uint256 indexed pid, uint256 amount);
593     event LpWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
594     event PoolAdd(uint256 _allocPoint, address indexed _lpToken, uint256 _pid);
595     event PoolChange(uint256 indexed pid, uint256 _allocPoint);
596     event LpMiningRewardHarvest(address _user, uint256 _pid, uint256 _amount);
597     event AdminChange(address _oldAddr, address _newAddr);
598     event RewardsPerBlockChange(uint256 _oldValue, uint256 _newValue);
599     
600     modifier onlyOwner {
601         require(msg.sender == owner);
602         _;
603     }
604     
605     modifier onlyExecutor {
606         require(executorList[msg.sender]);
607         _;
608     }
609     
610     modifier validPool(uint256 _pid) {
611         require( _pid < poolInfo.length, "pool not exists!" );
612         _;
613     }
614     
615     modifier checkSig(string memory _uuid, bytes[] memory _sigs) {
616         require( !usedUUIDs[_uuid], "UUID exists!" );
617         bool[5] memory flags = [false,false,false,false,false];
618         bytes32 hash = keccak256(abi.encodePacked(_uuid));
619         for(uint256 i = 0;i < _sigs.length; i++){
620             address signer = hash.recover(_sigs[i]);
621             if(signer == adminList[0]){
622                 flags[0] = true;
623             }else if(signer == adminList[1]){
624                 flags[1] = true;
625             }else if(signer == adminList[2]){
626                 flags[2] = true;
627             }else if(signer == adminList[3]){
628                 flags[3] = true;
629             }else if(signer == adminList[4]){
630                 flags[4] = true;
631             }
632         }
633         uint256 cnt = 0; 
634         for(uint256 i = 0; i < 5; i++){
635           if(flags[i]) cnt += 1;
636         }
637         usedUUIDs[_uuid] = true;
638         require( cnt >= 3, "Not enough sigs!" );
639         _;
640     }
641     
642     constructor(address _angryTokenAddr, uint256 _angryPerBlock, address _admin1, address _admin2, address _admin3, address _admin4, address _admin5) {
643         initialize(_angryTokenAddr, _angryPerBlock, _admin1, _admin2, _admin3, _admin4, _admin5);
644     }
645     
646     function initialize(address _angryTokenAddr, uint256 _angryPerBlock, address _admin1, address _admin2, address _admin3, address _admin4, address _admin5) public {
647         require(!bInited, "already Inited!");
648         bInited = true;
649         owner = msg.sender;
650         executorList[msg.sender] = true;
651         angryToken = IERC20(_angryTokenAddr);
652         angryPerBlock = _angryPerBlock;
653         adminList[0] = _admin1;
654         adminList[1] = _admin2;
655         adminList[2] = _admin3;
656         adminList[3] = _admin4;
657         adminList[4] = _admin5;
658         emit ExecutorAdd(msg.sender);
659     }
660     
661     function addExecutor(address _newExecutor) onlyOwner public {
662         executorList[_newExecutor] = true;
663         emit ExecutorAdd(_newExecutor);
664     }
665     
666     function delExecutor(address _oldExecutor) onlyOwner public {
667         executorList[_oldExecutor] = false;
668         emit ExecutorDel(_oldExecutor);
669     }
670     
671     function checkPoolDuplicate(IERC20 _lpToken) internal view {
672         uint256 length = poolInfo.length;
673         for(uint256 pid = 0; pid < length; ++pid){
674             require( poolInfo[pid].lpToken != _lpToken, "duplicate pool!" );
675         }
676     }
677     
678     function addBonusPeriod(uint256 _beginBlock, uint256 _endBlock) public onlyExecutor {
679         require( _beginBlock < _endBlock );
680         uint256 length = bonusPeriods.length;
681         for(uint256 i = 0;i < length; i++){
682             require(_endBlock < bonusPeriods[i].beginBlock || _beginBlock > bonusPeriods[i].endBlock, "BO");
683         }
684         massUpdatePools();
685         BonusPeriod memory bp;
686         bp.beginBlock = _beginBlock;
687         bp.endBlock = _endBlock;
688         bonusPeriods.push(bp);
689         emit BonusPeriodAdd(_beginBlock, _endBlock);
690     }
691     
692     function addPool(
693         uint256 _allocPoint,
694         address _lpToken,
695         string memory _uuid, 
696         bytes[] memory _sigs
697     ) public checkSig(_uuid, _sigs) {
698         checkPoolDuplicate(IERC20(_lpToken));
699         massUpdatePools();
700         totalAllocPoint = totalAllocPoint + _allocPoint;
701         poolInfo.push(
702             PoolInfo({
703                 lpToken: IERC20(_lpToken),
704                 allocPoint: _allocPoint,
705                 lastRewardBlock: block.number,
706                 accAngryPerShare: 0,
707                 stakeAmount: 0
708             })
709         );
710         emit PoolAdd(_allocPoint,_lpToken, poolInfo.length-1);
711     }
712     
713     function changePool(
714         uint256 _pid,
715         uint256 _allocPoint,
716         string memory _uuid, 
717         bytes[] memory _sigs
718     ) public validPool(_pid) checkSig(_uuid, _sigs) {
719         require( _allocPoint > 0, "invalid allocPoint!" );
720         massUpdatePools();
721         totalAllocPoint = totalAllocPoint - poolInfo[_pid].allocPoint + _allocPoint;
722         poolInfo[_pid].allocPoint = _allocPoint;
723         emit PoolChange(_pid, _allocPoint);
724     }
725     
726     function getMultiplier(uint256 _from, uint256 _to)
727         public
728         view
729         returns (uint256)
730     {
731         uint256 bonusBeginBlock = 0;
732         uint256 bonusEndBlock = 0;
733         uint256 length = bonusPeriods.length;
734         uint256 reward = 0;
735         uint256 totalBlocks = _to - _from;
736         uint256 bonusBlocks = 0;
737     
738         for(uint256 i = 0;i < length; i++){
739             bonusBeginBlock = bonusPeriods[i].beginBlock;
740             bonusEndBlock = bonusPeriods[i].endBlock;
741             if (_to >= bonusBeginBlock && _from <= bonusEndBlock){
742                 uint256 a = _from > bonusBeginBlock ? _from : bonusBeginBlock;
743                 uint256 b = _to > bonusEndBlock ? bonusEndBlock : _to;
744                 if(b > a){
745                     bonusBlocks += (b - a);
746                     reward += (b - a) * BONUS_MULTIPLIER;
747                 }
748             }
749         }
750         if(totalBlocks > bonusBlocks){
751             reward += (totalBlocks - bonusBlocks);
752         }
753         return reward;
754     }
755     
756     function getLpMiningReward(uint256 _pid, address _user)
757         public
758         validPool(_pid)
759         view
760         returns (uint256)
761     {
762         PoolInfo storage pool = poolInfo[_pid];
763         UserInfo storage user = userInfo[_pid][_user];
764         uint256 accAngryPerShare = pool.accAngryPerShare;
765         uint256 lpSupply = pool.stakeAmount;
766         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
767             uint256 multiplier =
768                 getMultiplier(pool.lastRewardBlock, block.number);
769             uint256 angryReward =
770                 multiplier * angryPerBlock * pool.allocPoint / totalAllocPoint;
771             accAngryPerShare = accAngryPerShare + angryReward * (1e12) / lpSupply;
772         }
773         return user.amount * accAngryPerShare / (1e12) - user.rewardDebt + user.reward;
774     }
775     
776     function getPoolList() public view returns(PoolItem[] memory _pools){
777         uint256 length = poolInfo.length;
778         _pools = new PoolItem[](length);
779         for (uint256 pid = 0; pid < length; ++pid) {
780             _pools[pid].pid = pid;
781             _pools[pid].lpToken = address(poolInfo[pid].lpToken);
782             _pools[pid].allocPoint = poolInfo[pid].allocPoint;
783         }
784     }
785     
786     function getPoolListArr() public view returns(uint256[] memory _pids,address[] memory _tokenAddrs, uint256[] memory _allocPoints){
787         uint256 length = poolInfo.length;
788         _pids = new uint256[](length);
789         _tokenAddrs = new address[](length);
790         _allocPoints = new uint256[](length);
791         for (uint256 pid = 0; pid < length; ++pid) {
792             _pids[pid] = pid;
793             _tokenAddrs[pid] = address(poolInfo[pid].lpToken);
794             _allocPoints[pid] = poolInfo[pid].allocPoint;
795         }
796     }
797     
798     function massUpdatePools() public {
799         uint256 length = poolInfo.length;
800         for (uint256 pid = 0; pid < length; ++pid) {
801             updatePool(pid);
802         }
803     }
804     
805     function getAccountLpMinings(address _addr) public view returns(LpMiningInfo[] memory _infos){
806         uint256 length = poolInfo.length;
807         _infos = new LpMiningInfo[](length);
808         for (uint256 pid = 0; pid < length; ++pid) {
809             UserInfo storage user = userInfo[pid][_addr];
810             _infos[pid].pid = pid;
811             _infos[pid].lpToken = address(poolInfo[pid].lpToken);
812             _infos[pid].amount = user.amount;
813             _infos[pid].reward = getLpMiningReward(pid,_addr);
814         }
815     }
816     
817     function updatePool(uint256 _pid) public validPool(_pid) {
818         PoolInfo storage pool = poolInfo[_pid];
819         if (block.number <= pool.lastRewardBlock) {
820             return;
821         }
822         uint256 lpSupply = pool.stakeAmount;
823         if (lpSupply == 0) {
824             pool.lastRewardBlock = block.number;
825             return;
826         }
827         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
828         uint256 angryReward =
829             multiplier * angryPerBlock * pool.allocPoint / totalAllocPoint;
830         pool.accAngryPerShare = pool.accAngryPerShare + angryReward * (1e12) / lpSupply;
831         pool.lastRewardBlock = block.number;
832     }
833     
834     function depositLP(uint256 _pid, uint256 _amount) public nonReentrant validPool(_pid) {
835         PoolInfo storage pool = poolInfo[_pid];
836         UserInfo storage user = userInfo[_pid][msg.sender];
837         updatePool(_pid);
838         if (user.amount > 0) {
839             uint256 pending =
840                 user.amount * pool.accAngryPerShare / (1e12) - user.rewardDebt;
841             //safeAngryTransfer(msg.sender, pending);
842             user.reward += pending;
843         }
844         pool.lpToken.safeTransferFrom(
845             address(msg.sender),
846             address(this),
847             _amount
848         );
849         pool.stakeAmount += _amount;
850         user.amount = user.amount + _amount;
851         user.rewardDebt = user.amount * pool.accAngryPerShare / (1e12);
852         emit LpDeposit(msg.sender, _pid, _amount);
853     }
854     
855     function withdrawLP(uint256 _pid, uint256 _amount) public nonReentrant validPool(_pid) {
856         PoolInfo storage pool = poolInfo[_pid];
857         UserInfo storage user = userInfo[_pid][msg.sender];
858         require(user.amount >= _amount, "AE");
859         updatePool(_pid);
860         uint256 pending =
861             user.amount * pool.accAngryPerShare / (1e12) - user.rewardDebt;
862         //safeAngryTransfer(msg.sender, pending);
863         user.reward += pending;
864         user.amount = user.amount - _amount;
865         user.rewardDebt = user.amount * pool.accAngryPerShare / (1e12);
866         pool.lpToken.safeTransfer(address(msg.sender), _amount);
867         pool.stakeAmount -= _amount;
868         if(user.amount == 0){
869             safeAngryTransfer(msg.sender, user.reward);
870             user.reward = 0;
871         }
872         emit LpWithdraw(msg.sender, _pid, _amount);
873     }
874     
875     function harvestLpMiningReward(uint256 _pid) public nonReentrant validPool(_pid){
876         PoolInfo storage pool = poolInfo[_pid];
877         UserInfo storage user = userInfo[_pid][msg.sender];
878         updatePool(_pid);
879         uint256 pending =
880             user.amount * pool.accAngryPerShare / (1e12) - user.rewardDebt;
881         user.reward += pending;
882         user.rewardDebt = user.amount * pool.accAngryPerShare / (1e12);
883         safeAngryTransfer(msg.sender, user.reward);
884         emit LpMiningRewardHarvest(msg.sender, _pid, user.reward);
885         user.reward = 0;
886     }
887     
888     function safeAngryTransfer(address _to, uint256 _amount) internal {
889         angryToken.safeTransfer(_to, _amount);
890     }
891     
892     function getAdminList() public view returns (address[] memory _admins){
893         _admins = new address[](adminList.length);
894         for(uint256 i = 0; i < adminList.length; i++){
895             _admins[i] = adminList[i];
896         }
897     }
898     
899     function changeAdmin(uint256 _index, address _newAddress, string memory _uuid, bytes[] memory _sigs) public checkSig(_uuid, _sigs) {
900         require(_index < adminList.length, "index out of range!");
901         emit AdminChange(adminList[_index], _newAddress);
902         adminList[_index] = _newAddress;
903     }
904     
905     function changeRewardsPerBlock(uint256 _angryPerBlock, string memory _uuid, bytes[] memory _sigs) public checkSig(_uuid, _sigs){
906         emit RewardsPerBlockChange(angryPerBlock,_angryPerBlock);
907         angryPerBlock = _angryPerBlock;
908     }
909 }