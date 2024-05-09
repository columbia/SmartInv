1 // File: contracts/interfaces/IMerkleDistributor.sol
2 
3 
4 pragma solidity >=0.5.0;
5 
6 // Allows anyone to claim a token if they exist in a merkle root.
7 interface IMerkleDistributor {
8     // Returns the address of the token distributed by this contract.
9     function token() external view returns (address);
10     // Returns the merkle root of the merkle tree containing account balances available to claim.
11     function merkleRoot() external view returns (bytes32);
12     // Returns true if the index has been marked claimed.
13     function isClaimed(uint256 index) external view returns (bool);
14     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
15     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
16 
17     // This event is triggered whenever a call to #claim succeeds.
18     event Claimed(uint256 index, address account, uint256 amount);
19 }
20 // File: contracts/MerkleProof.sol
21 
22 pragma solidity =0.8.4;
23 
24 /**
25  * @dev These functions deal with verification of Merkle trees (hash trees),
26  */
27 library MerkleProof {
28     /**
29      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
30      * defined by `root`. For this, a `proof` must be provided, containing
31      * sibling hashes on the branch from the leaf to the root of the tree. Each
32      * pair of leaves and each pair of pre-images are assumed to be sorted.
33      */
34     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
35         bytes32 computedHash = leaf;
36 
37         for (uint256 i = 0; i < proof.length; i++) {
38             bytes32 proofElement = proof[i];
39 
40             if (computedHash < proofElement) {
41                 // Hash(current computed hash + current element of the proof)
42                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
43             } else {
44                 // Hash(current element of the proof + current computed hash)
45                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
46             }
47         }
48 
49         // Check if the computed hash (root) is equal to the provided root
50         return computedHash == root;
51     }
52 }
53 // File: @openzeppelin/contracts/utils/Address.sol
54 
55 
56 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev Collection of functions related to the address type
62  */
63 library Address {
64     /**
65      * @dev Returns true if `account` is a contract.
66      *
67      * [IMPORTANT]
68      * ====
69      * It is unsafe to assume that an address for which this function returns
70      * false is an externally-owned account (EOA) and not a contract.
71      *
72      * Among others, `isContract` will return false for the following
73      * types of addresses:
74      *
75      *  - an externally-owned account
76      *  - a contract in construction
77      *  - an address where a contract will be created
78      *  - an address where a contract lived, but was destroyed
79      * ====
80      */
81     function isContract(address account) internal view returns (bool) {
82         // This method relies on extcodesize, which returns 0 for contracts in
83         // construction, since the code is only stored at the end of the
84         // constructor execution.
85 
86         uint256 size;
87         assembly {
88             size := extcodesize(account)
89         }
90         return size > 0;
91     }
92 
93     /**
94      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
95      * `recipient`, forwarding all available gas and reverting on errors.
96      *
97      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
98      * of certain opcodes, possibly making contracts go over the 2300 gas limit
99      * imposed by `transfer`, making them unable to receive funds via
100      * `transfer`. {sendValue} removes this limitation.
101      *
102      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
103      *
104      * IMPORTANT: because control is transferred to `recipient`, care must be
105      * taken to not create reentrancy vulnerabilities. Consider using
106      * {ReentrancyGuard} or the
107      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
108      */
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         (bool success, ) = recipient.call{value: amount}("");
113         require(success, "Address: unable to send value, recipient may have reverted");
114     }
115 
116     /**
117      * @dev Performs a Solidity function call using a low level `call`. A
118      * plain `call` is an unsafe replacement for a function call: use this
119      * function instead.
120      *
121      * If `target` reverts with a revert reason, it is bubbled up by this
122      * function (like regular Solidity function calls).
123      *
124      * Returns the raw returned data. To convert to the expected return value,
125      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
126      *
127      * Requirements:
128      *
129      * - `target` must be a contract.
130      * - calling `target` with `data` must not revert.
131      *
132      * _Available since v3.1._
133      */
134     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
135         return functionCall(target, data, "Address: low-level call failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
140      * `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCall(
145         address target,
146         bytes memory data,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         return functionCallWithValue(target, data, 0, errorMessage);
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
154      * but also transferring `value` wei to `target`.
155      *
156      * Requirements:
157      *
158      * - the calling contract must have an ETH balance of at least `value`.
159      * - the called Solidity function must be `payable`.
160      *
161      * _Available since v3.1._
162      */
163     function functionCallWithValue(
164         address target,
165         bytes memory data,
166         uint256 value
167     ) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
173      * with `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCallWithValue(
178         address target,
179         bytes memory data,
180         uint256 value,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         require(address(this).balance >= value, "Address: insufficient balance for call");
184         require(isContract(target), "Address: call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.call{value: value}(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but performing a static call.
193      *
194      * _Available since v3.3._
195      */
196     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
197         return functionStaticCall(target, data, "Address: low-level static call failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
202      * but performing a static call.
203      *
204      * _Available since v3.3._
205      */
206     function functionStaticCall(
207         address target,
208         bytes memory data,
209         string memory errorMessage
210     ) internal view returns (bytes memory) {
211         require(isContract(target), "Address: static call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.staticcall(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but performing a delegate call.
220      *
221      * _Available since v3.4._
222      */
223     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
224         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a delegate call.
230      *
231      * _Available since v3.4._
232      */
233     function functionDelegateCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         require(isContract(target), "Address: delegate call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.delegatecall(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
246      * revert reason using the provided one.
247      *
248      * _Available since v4.3._
249      */
250     function verifyCallResult(
251         bool success,
252         bytes memory returndata,
253         string memory errorMessage
254     ) internal pure returns (bytes memory) {
255         if (success) {
256             return returndata;
257         } else {
258             // Look for revert reason and bubble it up if present
259             if (returndata.length > 0) {
260                 // The easiest way to bubble the revert reason is using memory via assembly
261 
262                 assembly {
263                     let returndata_size := mload(returndata)
264                     revert(add(32, returndata), returndata_size)
265                 }
266             } else {
267                 revert(errorMessage);
268             }
269         }
270     }
271 }
272 
273 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
274 
275 
276 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
277 
278 pragma solidity ^0.8.0;
279 
280 /**
281  * @dev Interface of the ERC20 standard as defined in the EIP.
282  */
283 interface IERC20 {
284     /**
285      * @dev Returns the amount of tokens in existence.
286      */
287     function totalSupply() external view returns (uint256);
288 
289     /**
290      * @dev Returns the amount of tokens owned by `account`.
291      */
292     function balanceOf(address account) external view returns (uint256);
293 
294     /**
295      * @dev Moves `amount` tokens from the caller's account to `recipient`.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transfer(address recipient, uint256 amount) external returns (bool);
302 
303     /**
304      * @dev Returns the remaining number of tokens that `spender` will be
305      * allowed to spend on behalf of `owner` through {transferFrom}. This is
306      * zero by default.
307      *
308      * This value changes when {approve} or {transferFrom} are called.
309      */
310     function allowance(address owner, address spender) external view returns (uint256);
311 
312     /**
313      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
314      *
315      * Returns a boolean value indicating whether the operation succeeded.
316      *
317      * IMPORTANT: Beware that changing an allowance with this method brings the risk
318      * that someone may use both the old and the new allowance by unfortunate
319      * transaction ordering. One possible solution to mitigate this race
320      * condition is to first reduce the spender's allowance to 0 and set the
321      * desired value afterwards:
322      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323      *
324      * Emits an {Approval} event.
325      */
326     function approve(address spender, uint256 amount) external returns (bool);
327 
328     /**
329      * @dev Moves `amount` tokens from `sender` to `recipient` using the
330      * allowance mechanism. `amount` is then deducted from the caller's
331      * allowance.
332      *
333      * Returns a boolean value indicating whether the operation succeeded.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transferFrom(
338         address sender,
339         address recipient,
340         uint256 amount
341     ) external returns (bool);
342 
343     /**
344      * @dev Emitted when `value` tokens are moved from one account (`from`) to
345      * another (`to`).
346      *
347      * Note that `value` may be zero.
348      */
349     event Transfer(address indexed from, address indexed to, uint256 value);
350 
351     /**
352      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
353      * a call to {approve}. `value` is the new allowance.
354      */
355     event Approval(address indexed owner, address indexed spender, uint256 value);
356 }
357 
358 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
359 
360 
361 // OpenZeppelin Contracts v4.4.0 (token/ERC20/utils/SafeERC20.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 
366 
367 /**
368  * @title SafeERC20
369  * @dev Wrappers around ERC20 operations that throw on failure (when the token
370  * contract returns false). Tokens that return no value (and instead revert or
371  * throw on failure) are also supported, non-reverting calls are assumed to be
372  * successful.
373  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
374  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
375  */
376 library SafeERC20 {
377     using Address for address;
378 
379     function safeTransfer(
380         IERC20 token,
381         address to,
382         uint256 value
383     ) internal {
384         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
385     }
386 
387     function safeTransferFrom(
388         IERC20 token,
389         address from,
390         address to,
391         uint256 value
392     ) internal {
393         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
394     }
395 
396     /**
397      * @dev Deprecated. This function has issues similar to the ones found in
398      * {IERC20-approve}, and its usage is discouraged.
399      *
400      * Whenever possible, use {safeIncreaseAllowance} and
401      * {safeDecreaseAllowance} instead.
402      */
403     function safeApprove(
404         IERC20 token,
405         address spender,
406         uint256 value
407     ) internal {
408         // safeApprove should only be called when setting an initial allowance,
409         // or when resetting it to zero. To increase and decrease it, use
410         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
411         require(
412             (value == 0) || (token.allowance(address(this), spender) == 0),
413             "SafeERC20: approve from non-zero to non-zero allowance"
414         );
415         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
416     }
417 
418     function safeIncreaseAllowance(
419         IERC20 token,
420         address spender,
421         uint256 value
422     ) internal {
423         uint256 newAllowance = token.allowance(address(this), spender) + value;
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
425     }
426 
427     function safeDecreaseAllowance(
428         IERC20 token,
429         address spender,
430         uint256 value
431     ) internal {
432         unchecked {
433             uint256 oldAllowance = token.allowance(address(this), spender);
434             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
435             uint256 newAllowance = oldAllowance - value;
436             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437         }
438     }
439 
440     /**
441      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
442      * on the return value: the return value is optional (but if data is returned, it must not be false).
443      * @param token The token targeted by the call.
444      * @param data The call data (encoded using abi.encode or one of its variants).
445      */
446     function _callOptionalReturn(IERC20 token, bytes memory data) private {
447         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
448         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
449         // the target address contains contract code and also asserts for success in the low-level call.
450 
451         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
452         if (returndata.length > 0) {
453             // Return data is optional
454             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
455         }
456     }
457 }
458 
459 // File: contracts/MerkleDistributor.sol
460 
461 
462 pragma solidity =0.8.4;
463 
464 
465 //import "./MerkleProof.sol";
466 
467 
468 
469 contract MerkleDistributor is IMerkleDistributor {
470     address public immutable override token;
471     bytes32 public immutable override merkleRoot;
472     using SafeERC20 for IERC20;
473 
474 
475     // This is a packed array of booleans.
476     mapping(uint256 => uint256) private claimedBitMap;
477 
478     constructor(address token_, bytes32 merkleRoot_) public {
479         token = token_;
480         merkleRoot = merkleRoot_;
481     }
482 
483     function isClaimed(uint256 index) public view override returns (bool) {
484         uint256 claimedWordIndex = index / 256;
485         uint256 claimedBitIndex = index % 256;
486         uint256 claimedWord = claimedBitMap[claimedWordIndex];
487         uint256 mask = (1 << claimedBitIndex);
488         return claimedWord & mask == mask;
489     }
490 
491     function _setClaimed(uint256 index) private {
492         uint256 claimedWordIndex = index / 256;
493         uint256 claimedBitIndex = index % 256;
494         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
495     }
496 
497     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
498         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
499 
500         // Verify the merkle proof.
501         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
502         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
503 
504         // Mark it claimed and send the token.
505         _setClaimed(index);
506         //require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
507         SafeERC20.safeTransfer(IERC20(token), account, amount);
508 
509         emit Claimed(index, account, amount);
510     }
511 }