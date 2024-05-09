1 // File: @openzeppelin/contracts@4.6.0/utils/Create2.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Create2.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
10  * `CREATE2` can be used to compute in advance the address where a smart
11  * contract will be deployed, which allows for interesting new mechanisms known
12  * as 'counterfactual interactions'.
13  *
14  * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
15  * information.
16  */
17 library Create2 {
18     /**
19      * @dev Deploys a contract using `CREATE2`. The address where the contract
20      * will be deployed can be known in advance via {computeAddress}.
21      *
22      * The bytecode for a contract can be obtained from Solidity with
23      * `type(contractName).creationCode`.
24      *
25      * Requirements:
26      *
27      * - `bytecode` must not be empty.
28      * - `salt` must have not been used for `bytecode` already.
29      * - the factory must have a balance of at least `amount`.
30      * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
31      */
32     function deploy(
33         uint256 amount,
34         bytes32 salt,
35         bytes memory bytecode
36     ) internal returns (address) {
37         address addr;
38         require(address(this).balance >= amount, "Create2: insufficient balance");
39         require(bytecode.length != 0, "Create2: bytecode length is zero");
40         assembly {
41             addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
42         }
43         require(addr != address(0), "Create2: Failed on deploy");
44         return addr;
45     }
46 
47     /**
48      * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
49      * `bytecodeHash` or `salt` will result in a new destination address.
50      */
51     function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
52         return computeAddress(salt, bytecodeHash, address(this));
53     }
54 
55     /**
56      * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
57      * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
58      */
59     function computeAddress(
60         bytes32 salt,
61         bytes32 bytecodeHash,
62         address deployer
63     ) internal pure returns (address) {
64         bytes32 _data = keccak256(abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash));
65         return address(uint160(uint256(_data)));
66     }
67 }
68 
69 // File: @openzeppelin/contracts@4.6.0/utils/Address.sol
70 
71 
72 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
73 
74 pragma solidity ^0.8.1;
75 
76 /**
77  * @dev Collection of functions related to the address type
78  */
79 library Address {
80     /**
81      * @dev Returns true if `account` is a contract.
82      *
83      * [IMPORTANT]
84      * ====
85      * It is unsafe to assume that an address for which this function returns
86      * false is an externally-owned account (EOA) and not a contract.
87      *
88      * Among others, `isContract` will return false for the following
89      * types of addresses:
90      *
91      *  - an externally-owned account
92      *  - a contract in construction
93      *  - an address where a contract will be created
94      *  - an address where a contract lived, but was destroyed
95      * ====
96      *
97      * [IMPORTANT]
98      * ====
99      * You shouldn't rely on `isContract` to protect against flash loan attacks!
100      *
101      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
102      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
103      * constructor.
104      * ====
105      */
106     function isContract(address account) internal view returns (bool) {
107         // This method relies on extcodesize/address.code.length, which returns 0
108         // for contracts in construction, since the code is only stored at the end
109         // of the constructor execution.
110 
111         return account.code.length > 0;
112     }
113 
114     /**
115      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
116      * `recipient`, forwarding all available gas and reverting on errors.
117      *
118      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
119      * of certain opcodes, possibly making contracts go over the 2300 gas limit
120      * imposed by `transfer`, making them unable to receive funds via
121      * `transfer`. {sendValue} removes this limitation.
122      *
123      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
124      *
125      * IMPORTANT: because control is transferred to `recipient`, care must be
126      * taken to not create reentrancy vulnerabilities. Consider using
127      * {ReentrancyGuard} or the
128      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
129      */
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, "Address: insufficient balance");
132 
133         (bool success, ) = recipient.call{value: amount}("");
134         require(success, "Address: unable to send value, recipient may have reverted");
135     }
136 
137     /**
138      * @dev Performs a Solidity function call using a low level `call`. A
139      * plain `call` is an unsafe replacement for a function call: use this
140      * function instead.
141      *
142      * If `target` reverts with a revert reason, it is bubbled up by this
143      * function (like regular Solidity function calls).
144      *
145      * Returns the raw returned data. To convert to the expected return value,
146      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
147      *
148      * Requirements:
149      *
150      * - `target` must be a contract.
151      * - calling `target` with `data` must not revert.
152      *
153      * _Available since v3.1._
154      */
155     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionCall(target, data, "Address: low-level call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
161      * `errorMessage` as a fallback revert reason when `target` reverts.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but also transferring `value` wei to `target`.
176      *
177      * Requirements:
178      *
179      * - the calling contract must have an ETH balance of at least `value`.
180      * - the called Solidity function must be `payable`.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
194      * with `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(
199         address target,
200         bytes memory data,
201         uint256 value,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(address(this).balance >= value, "Address: insufficient balance for call");
205         require(isContract(target), "Address: call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.call{value: value}(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
213      * but performing a static call.
214      *
215      * _Available since v3.3._
216      */
217     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
218         return functionStaticCall(target, data, "Address: low-level static call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal view returns (bytes memory) {
232         require(isContract(target), "Address: static call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.staticcall(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but performing a delegate call.
241      *
242      * _Available since v3.4._
243      */
244     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
245         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         require(isContract(target), "Address: delegate call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.delegatecall(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     /**
266      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
267      * revert reason using the provided one.
268      *
269      * _Available since v4.3._
270      */
271     function verifyCallResult(
272         bool success,
273         bytes memory returndata,
274         string memory errorMessage
275     ) internal pure returns (bytes memory) {
276         if (success) {
277             return returndata;
278         } else {
279             // Look for revert reason and bubble it up if present
280             if (returndata.length > 0) {
281                 // The easiest way to bubble the revert reason is using memory via assembly
282 
283                 assembly {
284                     let returndata_size := mload(returndata)
285                     revert(add(32, returndata), returndata_size)
286                 }
287             } else {
288                 revert(errorMessage);
289             }
290         }
291     }
292 }
293 
294 // File: @openzeppelin/contracts@4.6.0/security/ReentrancyGuard.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Contract module that helps prevent reentrant calls to a function.
303  *
304  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
305  * available, which can be applied to functions to make sure there are no nested
306  * (reentrant) calls to them.
307  *
308  * Note that because there is a single `nonReentrant` guard, functions marked as
309  * `nonReentrant` may not call one another. This can be worked around by making
310  * those functions `private`, and then adding `external` `nonReentrant` entry
311  * points to them.
312  *
313  * TIP: If you would like to learn more about reentrancy and alternative ways
314  * to protect against it, check out our blog post
315  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
316  */
317 abstract contract ReentrancyGuard {
318     // Booleans are more expensive than uint256 or any type that takes up a full
319     // word because each write operation emits an extra SLOAD to first read the
320     // slot's contents, replace the bits taken up by the boolean, and then write
321     // back. This is the compiler's defense against contract upgrades and
322     // pointer aliasing, and it cannot be disabled.
323 
324     // The values being non-zero value makes deployment a bit more expensive,
325     // but in exchange the refund on every call to nonReentrant will be lower in
326     // amount. Since refunds are capped to a percentage of the total
327     // transaction's gas, it is best to keep them low in cases like this one, to
328     // increase the likelihood of the full refund coming into effect.
329     uint256 private constant _NOT_ENTERED = 1;
330     uint256 private constant _ENTERED = 2;
331 
332     uint256 private _status;
333 
334     constructor() {
335         _status = _NOT_ENTERED;
336     }
337 
338     /**
339      * @dev Prevents a contract from calling itself, directly or indirectly.
340      * Calling a `nonReentrant` function from another `nonReentrant`
341      * function is not supported. It is possible to prevent this from happening
342      * by making the `nonReentrant` function external, and making it call a
343      * `private` function that does the actual work.
344      */
345     modifier nonReentrant() {
346         // On the first call to nonReentrant, _notEntered will be true
347         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
348 
349         // Any calls to nonReentrant after this point will fail
350         _status = _ENTERED;
351 
352         _;
353 
354         // By storing the original value once again, a refund is triggered (see
355         // https://eips.ethereum.org/EIPS/eip-2200)
356         _status = _NOT_ENTERED;
357     }
358 }
359 
360 // File: my/recycle.sol
361 
362 
363 pragma solidity ^0.8.0;
364 
365 
366 
367 
368 contract RecycleFactory is ReentrancyGuard {
369     function recycle(address payable to,uint[] calldata uids, address[] calldata erc20) nonReentrant external {
370         uint n=uids.length;
371         for (uint i=0; i < n; i++) {
372             uint uid=uids[i];
373             address recycleContract = computeAddress(msg.sender,uid);
374             if(!Address.isContract(recycleContract)){
375                 bytes32 salt = keccak256(abi.encode(msg.sender, uid));
376                 bytes memory bytecode = type(Recycle).creationCode;
377                 recycleContract=Create2.deploy(0,salt,bytecode);
378                 Recycle(payable(recycleContract)).init(address(this));
379             }
380             Recycle(payable(recycleContract)).recycle(to,erc20);
381         }
382     }
383 
384     function computeAddress(address sender,uint uid) public view returns(address) {
385         bytes32 salt = keccak256(abi.encode(sender, uid));
386         bytes32 bytecodeHash = keccak256(type(Recycle).creationCode);
387         return Create2.computeAddress(salt,bytecodeHash);
388     }
389 }
390 
391 contract Recycle is ReentrancyGuard {
392     address public factory;
393 
394     function init(address _factory) external {
395         require(factory==address(0),"Recycle: cannot init");
396         factory=_factory;
397     }
398 
399 
400     function recycle(address payable recycler, address[] calldata erc20) external nonReentrant {
401         require(msg.sender==factory,"Recycle: must factory");
402         uint n=erc20.length;
403         for (uint i; i < n; i++) {
404             RecyleHelper.transfer(erc20[i],recycler);
405         }
406         uint balance=address(this).balance;
407         if(balance>0) {
408             recycler.transfer(balance);
409         }
410     }
411 
412     receive() external payable {
413     }
414 }
415 
416 library RecyleHelper {
417     function transfer(address token, address to) internal returns (bool) {
418         uint value = balanceOf(token);
419         if (value > 0){
420             (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
421             return success && (data.length == 0 || abi.decode(data, (bool)));
422         }
423         return true;
424     }
425     
426     function balanceOf(address token) internal returns (uint) {
427         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x70a08231, address(this)));
428         if (!success || data.length == 0) return 0;
429         return abi.decode(data, (uint));
430     }
431 }