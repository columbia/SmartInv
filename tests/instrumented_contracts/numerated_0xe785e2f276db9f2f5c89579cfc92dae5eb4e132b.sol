1 // SPDX-License-Identifier:MIT
2 
3 pragma solidity =0.8.9;
4 
5 /**
6  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
7  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
8  *
9  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
10  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
11  * need to send a transaction, and thus is not required to hold Ether at all.
12  */
13 interface IERC20Permit {
14     /**
15      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
16      * given ``owner``'s signed approval.
17      *
18      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
19      * ordering also apply here.
20      *
21      * Emits an {Approval} event.
22      *
23      * Requirements:
24      *
25      * - `spender` cannot be the zero address.
26      * - `deadline` must be a timestamp in the future.
27      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
28      * over the EIP712-formatted function arguments.
29      * - the signature must use ``owner``'s current nonce (see {nonces}).
30      *
31      * For more information on the signature format, see the
32      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
33      * section].
34      */
35     function permit(
36         address owner,
37         address spender,
38         uint256 value,
39         uint256 deadline,
40         uint8 v,
41         bytes32 r,
42         bytes32 s
43     ) external;
44 
45     /**
46      * @dev Returns the current nonce for `owner`. This value must be
47      * included whenever a signature is generated for {permit}.
48      *
49      * Every successful call to {permit} increases ``owner``'s nonce by one. This
50      * prevents a signature from being used multiple times.
51      */
52     function nonces(address owner) external view returns (uint256);
53 
54     /**
55      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
56      */
57     // solhint-disable-next-line func-name-mixedcase
58     function DOMAIN_SEPARATOR() external view returns (bytes32);
59 }
60 
61 /**
62  * @dev Interface of the ERC20 standard as defined in the EIP.
63  */
64 interface IERC20 {
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 
79     /**
80      * @dev Returns the amount of tokens in existence.
81      */
82     function totalSupply() external view returns (uint256);
83 
84     /**
85      * @dev Returns the amount of tokens owned by `account`.
86      */
87     function balanceOf(address account) external view returns (uint256);
88 
89     /**
90      * @dev Moves `amount` tokens from the caller's account to `to`.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transfer(address to, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Returns the remaining number of tokens that `spender` will be
100      * allowed to spend on behalf of `owner` through {transferFrom}. This is
101      * zero by default.
102      *
103      * This value changes when {approve} or {transferFrom} are called.
104      */
105     function allowance(address owner, address spender) external view returns (uint256);
106 
107     /**
108      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * IMPORTANT: Beware that changing an allowance with this method brings the risk
113      * that someone may use both the old and the new allowance by unfortunate
114      * transaction ordering. One possible solution to mitigate this race
115      * condition is to first reduce the spender's allowance to 0 and set the
116      * desired value afterwards:
117      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address spender, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Moves `amount` tokens from `from` to `to` using the
125      * allowance mechanism. `amount` is then deducted from the caller's
126      * allowance.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(
133         address from,
134         address to,
135         uint256 amount
136     ) external returns (bool);
137 }
138 
139 /**
140  * @dev Collection of functions related to the address type
141  */
142 library Address {
143     /**
144      * @dev Returns true if `account` is a contract.
145      *
146      * [IMPORTANT]
147      * ====
148      * It is unsafe to assume that an address for which this function returns
149      * false is an externally-owned account (EOA) and not a contract.
150      *
151      * Among others, `isContract` will return false for the following
152      * types of addresses:
153      *
154      *  - an externally-owned account
155      *  - a contract in construction
156      *  - an address where a contract will be created
157      *  - an address where a contract lived, but was destroyed
158      * ====
159      *
160      * [IMPORTANT]
161      * ====
162      * You shouldn't rely on `isContract` to protect against flash loan attacks!
163      *
164      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
165      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
166      * constructor.
167      * ====
168      */
169     function isContract(address account) internal view returns (bool) {
170         // This method relies on extcodesize/address.code.length, which returns 0
171         // for contracts in construction, since the code is only stored at the end
172         // of the constructor execution.
173 
174         return account.code.length > 0;
175     }
176 
177     /**
178      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
179      * `recipient`, forwarding all available gas and reverting on errors.
180      *
181      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
182      * of certain opcodes, possibly making contracts go over the 2300 gas limit
183      * imposed by `transfer`, making them unable to receive funds via
184      * `transfer`. {sendValue} removes this limitation.
185      *
186      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
187      *
188      * IMPORTANT: because control is transferred to `recipient`, care must be
189      * taken to not create reentrancy vulnerabilities. Consider using
190      * {ReentrancyGuard} or the
191      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
192      */
193     function sendValue(address payable recipient, uint256 amount) internal {
194         require(address(this).balance >= amount, "Address: insufficient balance");
195 
196         (bool success, ) = recipient.call{value: amount}("");
197         require(success, "Address: unable to send value, recipient may have reverted");
198     }
199 
200     /**
201      * @dev Performs a Solidity function call using a low level `call`. A
202      * plain `call` is an unsafe replacement for a function call: use this
203      * function instead.
204      *
205      * If `target` reverts with a revert reason, it is bubbled up by this
206      * function (like regular Solidity function calls).
207      *
208      * Returns the raw returned data. To convert to the expected return value,
209      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
210      *
211      * Requirements:
212      *
213      * - `target` must be a contract.
214      * - calling `target` with `data` must not revert.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
224      * `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but also transferring `value` wei to `target`.
239      *
240      * Requirements:
241      *
242      * - the calling contract must have an ETH balance of at least `value`.
243      * - the called Solidity function must be `payable`.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value
251     ) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
257      * with `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(address(this).balance >= value, "Address: insufficient balance for call");
268         (bool success, bytes memory returndata) = target.call{value: value}(data);
269         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but performing a static call.
275      *
276      * _Available since v3.3._
277      */
278     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
279         return functionStaticCall(target, data, "Address: low-level static call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
284      * but performing a static call.
285      *
286      * _Available since v3.3._
287      */
288     function functionStaticCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal view returns (bytes memory) {
293         (bool success, bytes memory returndata) = target.staticcall(data);
294         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but performing a delegate call.
300      *
301      * _Available since v3.4._
302      */
303     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
309      * but performing a delegate call.
310      *
311      * _Available since v3.4._
312      */
313     function functionDelegateCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         (bool success, bytes memory returndata) = target.delegatecall(data);
319         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
324      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
325      *
326      * _Available since v4.8._
327      */
328     function verifyCallResultFromTarget(
329         address target,
330         bool success,
331         bytes memory returndata,
332         string memory errorMessage
333     ) internal view returns (bytes memory) {
334         if (success) {
335             if (returndata.length == 0) {
336                 // only check isContract if the call was successful and the return data is empty
337                 // otherwise we already know that it was a contract
338                 require(isContract(target), "Address: call to non-contract");
339             }
340             return returndata;
341         } else {
342             _revert(returndata, errorMessage);
343         }
344     }
345 
346     /**
347      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
348      * revert reason or using the provided one.
349      *
350      * _Available since v4.3._
351      */
352     function verifyCallResult(
353         bool success,
354         bytes memory returndata,
355         string memory errorMessage
356     ) internal pure returns (bytes memory) {
357         if (success) {
358             return returndata;
359         } else {
360             _revert(returndata, errorMessage);
361         }
362     }
363 
364     function _revert(bytes memory returndata, string memory errorMessage) private pure {
365         // Look for revert reason and bubble it up if present
366         if (returndata.length > 0) {
367             // The easiest way to bubble the revert reason is using memory via assembly
368             /// @solidity memory-safe-assembly
369             assembly {
370                 let returndata_size := mload(returndata)
371                 revert(add(32, returndata), returndata_size)
372             }
373         } else {
374             revert(errorMessage);
375         }
376     }
377 }
378 
379 /**
380  * @title SafeERC20
381  * @dev Wrappers around ERC20 operations that throw on failure (when the token
382  * contract returns false). Tokens that return no value (and instead revert or
383  * throw on failure) are also supported, non-reverting calls are assumed to be
384  * successful.
385  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
386  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
387  */
388 library SafeERC20 {
389     using Address for address;
390 
391     function safeTransfer(
392         IERC20 token,
393         address to,
394         uint256 value
395     ) internal {
396         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
397     }
398 
399     function safeTransferFrom(
400         IERC20 token,
401         address from,
402         address to,
403         uint256 value
404     ) internal {
405         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
406     }
407 
408     /**
409      * @dev Deprecated. This function has issues similar to the ones found in
410      * {IERC20-approve}, and its usage is discouraged.
411      *
412      * Whenever possible, use {safeIncreaseAllowance} and
413      * {safeDecreaseAllowance} instead.
414      */
415     function safeApprove(
416         IERC20 token,
417         address spender,
418         uint256 value
419     ) internal {
420         // safeApprove should only be called when setting an initial allowance,
421         // or when resetting it to zero. To increase and decrease it, use
422         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
423         require(
424             (value == 0) || (token.allowance(address(this), spender) == 0),
425             "SafeERC20: approve from non-zero to non-zero allowance"
426         );
427         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
428     }
429 
430     function safeIncreaseAllowance(
431         IERC20 token,
432         address spender,
433         uint256 value
434     ) internal {
435         uint256 newAllowance = token.allowance(address(this), spender) + value;
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     function safeDecreaseAllowance(
440         IERC20 token,
441         address spender,
442         uint256 value
443     ) internal {
444         unchecked {
445             uint256 oldAllowance = token.allowance(address(this), spender);
446             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
447             uint256 newAllowance = oldAllowance - value;
448             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
449         }
450     }
451 
452     function safePermit(
453         IERC20Permit token,
454         address owner,
455         address spender,
456         uint256 value,
457         uint256 deadline,
458         uint8 v,
459         bytes32 r,
460         bytes32 s
461     ) internal {
462         uint256 nonceBefore = token.nonces(owner);
463         token.permit(owner, spender, value, deadline, v, r, s);
464         uint256 nonceAfter = token.nonces(owner);
465         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
466     }
467 
468     /**
469      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
470      * on the return value: the return value is optional (but if data is returned, it must not be false).
471      * @param token The token targeted by the call.
472      * @param data The call data (encoded using abi.encode or one of its variants).
473      */
474     function _callOptionalReturn(IERC20 token, bytes memory data) private {
475         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
476         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
477         // the target address contains contract code and also asserts for success in the low-level call.
478 
479         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
480         if (returndata.length > 0) {
481             // Return data is optional
482             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
483         }
484     }
485 }
486 
487 contract Claimer {
488     using SafeERC20 for IERC20;
489 
490     address public admin_;
491 
492     address public token_;
493 
494     bytes32 public merkleRootHash_;
495     uint256 public merkleTreeHeight_;
496 
497     mapping(address => bool) public claimed_;
498 
499     constructor(address _admin, address _token, bytes32 _merkleRootHash, uint256 _merkleTreeHeight) {
500         admin_ = _admin;
501         token_ = _token;
502         merkleRootHash_ = _merkleRootHash;
503         merkleTreeHeight_ = _merkleTreeHeight;
504     }
505 
506     function execute(address _contract, bytes calldata _data) external {
507         require(msg.sender == admin_, "Auth failed");
508 
509         require(_contract != address(0), "Zero contract address");
510         require(_data.length != 0, "Zero data");
511 
512         (bool success,) = _contract.call(_data);
513         require(success, "Data exec failed");
514     }
515 
516     function withdrawToken(uint256 _amount, address _to) external {
517         require(msg.sender == admin_, "Auth failed");
518 
519         IERC20(token_).safeTransfer(_to, _amount);
520     }
521 
522     function setMerkleTree(bytes32 _merkleRootHash, uint256 _merkleTreeHeight) external {
523         require(msg.sender == admin_, "Auth failed");
524 
525         merkleRootHash_ = _merkleRootHash;
526         merkleTreeHeight_ = _merkleTreeHeight;
527     }
528 
529     function claim(uint256 _amount, uint256 _index, bytes32[] calldata _merkleProof) external {
530         require(verifyMerkleProof(msg.sender, _amount, _index, _merkleProof), "Merkle proof verification failed");
531 
532         require(!claimed_[msg.sender], "Already claimed");
533         claimed_[msg.sender] = true;
534 
535         IERC20(token_).safeTransfer(msg.sender, _amount);
536     }
537 
538     function verifyMerkleProof(
539         address _user,
540         uint256 _amount,
541         uint256 _index,
542         bytes32[] calldata _merkleProof
543     ) public view returns (bool) {
544         if (_merkleProof.length != merkleTreeHeight_) {
545             return false;
546         }
547 
548         uint256 path = _index;
549         bytes32 nodeHash = keccak256(abi.encode(_index, _user, _amount, _amount));
550 
551         for (uint256 i = 0; i < _merkleProof.length; ++i) {
552             if ((path & 0x01) == 0) {
553                 nodeHash = keccak256(abi.encode(nodeHash, _merkleProof[i]));
554             } else {
555                 nodeHash = keccak256(abi.encode(_merkleProof[i], nodeHash));
556             }
557             path = path >> 1;
558         }
559 
560         return nodeHash == merkleRootHash_;
561     }
562 }