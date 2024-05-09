1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 /**
6  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
7  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
8  * be specified by overriding the virtual {_implementation} function.
9  *
10  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
11  * different contract through the {_delegate} function.
12  *
13  * The success and return data of the delegated call will be returned back to the caller of the proxy.
14  */
15 abstract contract Proxy {
16     /**
17      * @dev Delegates the current call to `implementation`.
18      *
19      * This function does not return to its internall call site, it will return directly to the external caller.
20      */
21     function _delegate(address implementation) internal virtual {
22         // solhint-disable-next-line no-inline-assembly
23         assembly {
24             // Copy msg.data. We take full control of memory in this inline assembly
25             // block because it will not return to Solidity code. We overwrite the
26             // Solidity scratch pad at memory position 0.
27             calldatacopy(0, 0, calldatasize())
28 
29             // Call the implementation.
30             // out and outsize are 0 because we don't know the size yet.
31             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
32 
33             // Copy the returned data.
34             returndatacopy(0, 0, returndatasize())
35 
36             switch result
37             // delegatecall returns 0 on error.
38             case 0 { revert(0, returndatasize()) }
39             default { return(0, returndatasize()) }
40         }
41     }
42 
43     /**
44      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
45      * and {_fallback} should delegate.
46      */
47     function _implementation() internal view virtual returns (address);
48 
49     /**
50      * @dev Delegates the current call to the address returned by `_implementation()`.
51      *
52      * This function does not return to its internall call site, it will return directly to the external caller.
53      */
54     function _fallback() internal virtual {
55         _beforeFallback();
56         _delegate(_implementation());
57     }
58 
59     /**
60      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
61      * function in the contract matches the call data.
62      */
63     fallback () external payable virtual {
64         _fallback();
65     }
66 
67     /**
68      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
69      * is empty.
70      */
71     receive () external payable virtual {
72         _fallback();
73     }
74 
75     /**
76      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
77      * call, or as part of the Solidity `fallback` or `receive` functions.
78      *
79      * If overriden should call `super._beforeFallback()`.
80      */
81     function _beforeFallback() internal virtual {
82     }
83 }
84 
85 
86 
87 /**
88  * @dev Collection of functions related to the address type
89  */
90 library Address {
91     /**
92      * @dev Returns true if `account` is a contract.
93      *
94      * [IMPORTANT]
95      * ====
96      * It is unsafe to assume that an address for which this function returns
97      * false is an externally-owned account (EOA) and not a contract.
98      *
99      * Among others, `isContract` will return false for the following
100      * types of addresses:
101      *
102      *  - an externally-owned account
103      *  - a contract in construction
104      *  - an address where a contract will be created
105      *  - an address where a contract lived, but was destroyed
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize, which returns 0 for contracts in
110         // construction, since the code is only stored at the end of the
111         // constructor execution.
112 
113         uint256 size;
114         // solhint-disable-next-line no-inline-assembly
115         assembly { size := extcodesize(account) }
116         return size > 0;
117     }
118 
119     /**
120      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
121      * `recipient`, forwarding all available gas and reverting on errors.
122      *
123      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
124      * of certain opcodes, possibly making contracts go over the 2300 gas limit
125      * imposed by `transfer`, making them unable to receive funds via
126      * `transfer`. {sendValue} removes this limitation.
127      *
128      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
129      *
130      * IMPORTANT: because control is transferred to `recipient`, care must be
131      * taken to not create reentrancy vulnerabilities. Consider using
132      * {ReentrancyGuard} or the
133      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
134      */
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
139         (bool success, ) = recipient.call{ value: amount }("");
140         require(success, "Address: unable to send value, recipient may have reverted");
141     }
142 
143     /**
144      * @dev Performs a Solidity function call using a low level `call`. A
145      * plain`call` is an unsafe replacement for a function call: use this
146      * function instead.
147      *
148      * If `target` reverts with a revert reason, it is bubbled up by this
149      * function (like regular Solidity function calls).
150      *
151      * Returns the raw returned data. To convert to the expected return value,
152      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
153      *
154      * Requirements:
155      *
156      * - `target` must be a contract.
157      * - calling `target` with `data` must not revert.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
162       return functionCall(target, data, "Address: low-level call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
167      * `errorMessage` as a fallback revert reason when `target` reverts.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
192      * with `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
197         require(address(this).balance >= value, "Address: insufficient balance for call");
198         require(isContract(target), "Address: call to non-contract");
199 
200         // solhint-disable-next-line avoid-low-level-calls
201         (bool success, bytes memory returndata) = target.call{ value: value }(data);
202         return _verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but performing a static call.
208      *
209      * _Available since v3.3._
210      */
211     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
212         return functionStaticCall(target, data, "Address: low-level static call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
217      * but performing a static call.
218      *
219      * _Available since v3.3._
220      */
221     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
222         require(isContract(target), "Address: static call to non-contract");
223 
224         // solhint-disable-next-line avoid-low-level-calls
225         (bool success, bytes memory returndata) = target.staticcall(data);
226         return _verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a delegate call.
232      *
233      * _Available since v3.4._
234      */
235     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
236         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a delegate call.
242      *
243      * _Available since v3.4._
244      */
245     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
246         require(isContract(target), "Address: delegate call to non-contract");
247 
248         // solhint-disable-next-line avoid-low-level-calls
249         (bool success, bytes memory returndata) = target.delegatecall(data);
250         return _verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
254         if (success) {
255             return returndata;
256         } else {
257             // Look for revert reason and bubble it up if present
258             if (returndata.length > 0) {
259                 // The easiest way to bubble the revert reason is using memory via assembly
260 
261                 // solhint-disable-next-line no-inline-assembly
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
273 
274 /**
275  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
276  * implementation address that can be changed. This address is stored in storage in the location specified by
277  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
278  * implementation behind the proxy.
279  *
280  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
281  * {TransparentUpgradeableProxy}.
282  */
283 contract UpgradeableProxy is Proxy {
284     /**
285      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
286      *
287      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
288      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
289      */
290     constructor(address _logic, bytes memory _data) payable {
291         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
292         _setImplementation(_logic);
293         if(_data.length > 0) {
294             Address.functionDelegateCall(_logic, _data);
295         }
296     }
297 
298     /**
299      * @dev Emitted when the implementation is upgraded.
300      */
301     event Upgraded(address indexed implementation);
302 
303     /**
304      * @dev Storage slot with the address of the current implementation.
305      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
306      * validated in the constructor.
307      */
308     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
309 
310     /**
311      * @dev Returns the current implementation address.
312      */
313     function _implementation() internal view virtual override returns (address impl) {
314         bytes32 slot = _IMPLEMENTATION_SLOT;
315         // solhint-disable-next-line no-inline-assembly
316         assembly {
317             impl := sload(slot)
318         }
319     }
320 
321     /**
322      * @dev Upgrades the proxy to a new implementation.
323      *
324      * Emits an {Upgraded} event.
325      */
326     function _upgradeTo(address newImplementation) internal virtual {
327         _setImplementation(newImplementation);
328         emit Upgraded(newImplementation);
329     }
330 
331     /**
332      * @dev Stores a new address in the EIP1967 implementation slot.
333      */
334     function _setImplementation(address newImplementation) private {
335         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
336 
337         bytes32 slot = _IMPLEMENTATION_SLOT;
338 
339         // solhint-disable-next-line no-inline-assembly
340         assembly {
341             sstore(slot, newImplementation)
342         }
343     }
344 }
345 
346 
347 
348 /**
349  * @dev This contract implements a proxy that is upgradeable by an admin.
350  *
351  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
352  * clashing], which can potentially be used in an attack, this contract uses the
353  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
354  * things that go hand in hand:
355  *
356  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
357  * that call matches one of the admin functions exposed by the proxy itself.
358  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
359  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
360  * "admin cannot fallback to proxy target".
361  *
362  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
363  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
364  * to sudden errors when trying to call a function from the proxy implementation.
365  *
366  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
367  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
368  */
369 contract TransparentUpgradeableProxy is UpgradeableProxy {
370     /**
371      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
372      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
373      */
374     constructor(address _logic, address admin_, bytes memory _data) payable UpgradeableProxy(_logic, _data) {
375         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
376         _setAdmin(admin_);
377     }
378 
379     /**
380      * @dev Emitted when the admin account has changed.
381      */
382     event AdminChanged(address previousAdmin, address newAdmin);
383 
384     /**
385      * @dev Storage slot with the admin of the contract.
386      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
387      * validated in the constructor.
388      */
389     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
390 
391     /**
392      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
393      */
394     modifier ifAdmin() {
395         if (msg.sender == _admin()) {
396             _;
397         } else {
398             _fallback();
399         }
400     }
401 
402     /**
403      * @dev Returns the current admin.
404      *
405      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
406      *
407      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
408      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
409      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
410      */
411     function admin() external ifAdmin returns (address admin_) {
412         admin_ = _admin();
413     }
414 
415     /**
416      * @dev Returns the current implementation.
417      *
418      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
419      *
420      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
421      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
422      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
423      */
424     function implementation() external ifAdmin returns (address implementation_) {
425         implementation_ = _implementation();
426     }
427 
428     /**
429      * @dev Changes the admin of the proxy.
430      *
431      * Emits an {AdminChanged} event.
432      *
433      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
434      */
435     function changeAdmin(address newAdmin) external virtual ifAdmin {
436         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
437         emit AdminChanged(_admin(), newAdmin);
438         _setAdmin(newAdmin);
439     }
440 
441     /**
442      * @dev Upgrade the implementation of the proxy.
443      *
444      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
445      */
446     function upgradeTo(address newImplementation) external virtual ifAdmin {
447         _upgradeTo(newImplementation);
448     }
449 
450     /**
451      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
452      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
453      * proxied contract.
454      *
455      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
456      */
457     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable virtual ifAdmin {
458         _upgradeTo(newImplementation);
459         Address.functionDelegateCall(newImplementation, data);
460     }
461 
462     /**
463      * @dev Returns the current admin.
464      */
465     function _admin() internal view virtual returns (address adm) {
466         bytes32 slot = _ADMIN_SLOT;
467         // solhint-disable-next-line no-inline-assembly
468         assembly {
469             adm := sload(slot)
470         }
471     }
472 
473     /**
474      * @dev Stores a new address in the EIP1967 admin slot.
475      */
476     function _setAdmin(address newAdmin) private {
477         bytes32 slot = _ADMIN_SLOT;
478 
479         // solhint-disable-next-line no-inline-assembly
480         assembly {
481             sstore(slot, newAdmin)
482         }
483     }
484 
485     /**
486      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
487      */
488     function _beforeFallback() internal virtual override {
489         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
490         super._beforeFallback();
491     }
492 }