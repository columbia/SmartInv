1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies on extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { size := extcodesize(account) }
34         return size > 0;
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         require(isContract(target), "Address: call to non-contract");
117 
118         // solhint-disable-next-line avoid-low-level-calls
119         (bool success, bytes memory returndata) = target.call{ value: value }(data);
120         return _verifyCallResult(success, returndata, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
125      * but performing a static call.
126      *
127      * _Available since v3.3._
128      */
129     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
130         return functionStaticCall(target, data, "Address: low-level static call failed");
131     }
132 
133     /**
134      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
135      * but performing a static call.
136      *
137      * _Available since v3.3._
138      */
139     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
140         require(isContract(target), "Address: static call to non-contract");
141 
142         // solhint-disable-next-line avoid-low-level-calls
143         (bool success, bytes memory returndata) = target.staticcall(data);
144         return _verifyCallResult(success, returndata, errorMessage);
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
149      * but performing a delegate call.
150      *
151      * _Available since v3.4._
152      */
153     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
159      * but performing a delegate call.
160      *
161      * _Available since v3.4._
162      */
163     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
164         require(isContract(target), "Address: delegate call to non-contract");
165 
166         // solhint-disable-next-line avoid-low-level-calls
167         (bool success, bytes memory returndata) = target.delegatecall(data);
168         return _verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
172         if (success) {
173             return returndata;
174         } else {
175             // Look for revert reason and bubble it up if present
176             if (returndata.length > 0) {
177                 // The easiest way to bubble the revert reason is using memory via assembly
178 
179                 // solhint-disable-next-line no-inline-assembly
180                 assembly {
181                     let returndata_size := mload(returndata)
182                     revert(add(32, returndata), returndata_size)
183                 }
184             } else {
185                 revert(errorMessage);
186             }
187         }
188     }
189 }
190 
191 
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
197  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
198  * be specified by overriding the virtual {_implementation} function.
199  *
200  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
201  * different contract through the {_delegate} function.
202  *
203  * The success and return data of the delegated call will be returned back to the caller of the proxy.
204  */
205 abstract contract Proxy {
206     /**
207      * @dev Delegates the current call to `implementation`.
208      *
209      * This function does not return to its internall call site, it will return directly to the external caller.
210      */
211     function _delegate(address implementation) internal virtual {
212         // solhint-disable-next-line no-inline-assembly
213         assembly {
214             // Copy msg.data. We take full control of memory in this inline assembly
215             // block because it will not return to Solidity code. We overwrite the
216             // Solidity scratch pad at memory position 0.
217             calldatacopy(0, 0, calldatasize())
218 
219             // Call the implementation.
220             // out and outsize are 0 because we don't know the size yet.
221             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
222 
223             // Copy the returned data.
224             returndatacopy(0, 0, returndatasize())
225 
226             switch result
227             // delegatecall returns 0 on error.
228             case 0 { revert(0, returndatasize()) }
229             default { return(0, returndatasize()) }
230         }
231     }
232 
233     /**
234      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
235      * and {_fallback} should delegate.
236      */
237     function _implementation() internal view virtual returns (address);
238 
239     /**
240      * @dev Delegates the current call to the address returned by `_implementation()`.
241      *
242      * This function does not return to its internall call site, it will return directly to the external caller.
243      */
244     function _fallback() internal virtual {
245         _beforeFallback();
246         _delegate(_implementation());
247     }
248 
249     /**
250      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
251      * function in the contract matches the call data.
252      */
253     fallback () external payable virtual {
254         _fallback();
255     }
256 
257     /**
258      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
259      * is empty.
260      */
261     receive () external payable virtual {
262         _fallback();
263     }
264 
265     /**
266      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
267      * call, or as part of the Solidity `fallback` or `receive` functions.
268      *
269      * If overriden should call `super._beforeFallback()`.
270      */
271     function _beforeFallback() internal virtual {
272     }
273 }
274 
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
280  * implementation address that can be changed. This address is stored in storage in the location specified by
281  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
282  * implementation behind the proxy.
283  *
284  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
285  * {TransparentUpgradeableProxy}.
286  */
287 contract ERC1967Proxy is Proxy {
288     /**
289      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
290      *
291      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
292      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
293      */
294     constructor(address _logic, bytes memory _data) payable {
295         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
296         _setImplementation(_logic);
297         if(_data.length > 0) {
298             Address.functionDelegateCall(_logic, _data);
299         }
300     }
301 
302     /**
303      * @dev Emitted when the implementation is upgraded.
304      */
305     event Upgraded(address indexed implementation);
306 
307     /**
308      * @dev Storage slot with the address of the current implementation.
309      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
310      * validated in the constructor.
311      */
312     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
313 
314     /**
315      * @dev Returns the current implementation address.
316      */
317     function _implementation() internal view virtual override returns (address impl) {
318         bytes32 slot = _IMPLEMENTATION_SLOT;
319         // solhint-disable-next-line no-inline-assembly
320         assembly {
321             impl := sload(slot)
322         }
323     }
324 
325     /**
326      * @dev Upgrades the proxy to a new implementation.
327      *
328      * Emits an {Upgraded} event.
329      */
330     function _upgradeTo(address newImplementation) internal virtual {
331         _setImplementation(newImplementation);
332         emit Upgraded(newImplementation);
333     }
334 
335     /**
336      * @dev Stores a new address in the EIP1967 implementation slot.
337      */
338     function _setImplementation(address newImplementation) private {
339         require(Address.isContract(newImplementation), "ERC1967Proxy: new implementation is not a contract");
340 
341         bytes32 slot = _IMPLEMENTATION_SLOT;
342 
343         // solhint-disable-next-line no-inline-assembly
344         assembly {
345             sstore(slot, newImplementation)
346         }
347     }
348 }
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev This contract implements a proxy that is upgradeable by an admin.
354  *
355  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
356  * clashing], which can potentially be used in an attack, this contract uses the
357  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
358  * things that go hand in hand:
359  *
360  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
361  * that call matches one of the admin functions exposed by the proxy itself.
362  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
363  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
364  * "admin cannot fallback to proxy target".
365  *
366  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
367  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
368  * to sudden errors when trying to call a function from the proxy implementation.
369  *
370  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
371  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
372  */
373 contract TransparentUpgradeableProxy is ERC1967Proxy {
374     /**
375      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
376      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
377      */
378     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
379         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
380         _setAdmin(admin_);
381     }
382 
383     /**
384      * @dev Emitted when the admin account has changed.
385      */
386     event AdminChanged(address previousAdmin, address newAdmin);
387 
388     /**
389      * @dev Storage slot with the admin of the contract.
390      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
391      * validated in the constructor.
392      */
393     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
394 
395     /**
396      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
397      */
398     modifier ifAdmin() {
399         if (msg.sender == _admin()) {
400             _;
401         } else {
402             _fallback();
403         }
404     }
405 
406     /**
407      * @dev Returns the current admin.
408      *
409      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
410      *
411      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
412      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
413      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
414      */
415     function admin() external ifAdmin returns (address admin_) {
416         admin_ = _admin();
417     }
418 
419     /**
420      * @dev Returns the current implementation.
421      *
422      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
423      *
424      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
425      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
426      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
427      */
428     function implementation() external ifAdmin returns (address implementation_) {
429         implementation_ = _implementation();
430     }
431 
432     /**
433      * @dev Changes the admin of the proxy.
434      *
435      * Emits an {AdminChanged} event.
436      *
437      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
438      */
439     function changeAdmin(address newAdmin) external virtual ifAdmin {
440         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
441         emit AdminChanged(_admin(), newAdmin);
442         _setAdmin(newAdmin);
443     }
444 
445     /**
446      * @dev Upgrade the implementation of the proxy.
447      *
448      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
449      */
450     function upgradeTo(address newImplementation) external virtual ifAdmin {
451         _upgradeTo(newImplementation);
452     }
453 
454     /**
455      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
456      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
457      * proxied contract.
458      *
459      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
460      */
461     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable virtual ifAdmin {
462         _upgradeTo(newImplementation);
463         Address.functionDelegateCall(newImplementation, data);
464     }
465 
466     /**
467      * @dev Returns the current admin.
468      */
469     function _admin() internal view virtual returns (address adm) {
470         bytes32 slot = _ADMIN_SLOT;
471         // solhint-disable-next-line no-inline-assembly
472         assembly {
473             adm := sload(slot)
474         }
475     }
476 
477     /**
478      * @dev Stores a new address in the EIP1967 admin slot.
479      */
480     function _setAdmin(address newAdmin) private {
481         bytes32 slot = _ADMIN_SLOT;
482 
483         // solhint-disable-next-line no-inline-assembly
484         assembly {
485             sstore(slot, newAdmin)
486         }
487     }
488 
489     /**
490      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
491      */
492     function _beforeFallback() internal virtual override {
493         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
494         super._beforeFallback();
495     }
496 }