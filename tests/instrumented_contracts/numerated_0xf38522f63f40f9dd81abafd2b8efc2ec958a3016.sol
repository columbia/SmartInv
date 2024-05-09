1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.8.2;
3 
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
85 /**
86  * @dev Collection of functions related to the address type
87  */
88 library Address {
89     /**
90      * @dev Returns true if `account` is a contract.
91      *
92      * [IMPORTANT]
93      * ====
94      * It is unsafe to assume that an address for which this function returns
95      * false is an externally-owned account (EOA) and not a contract.
96      *
97      * Among others, `isContract` will return false for the following
98      * types of addresses:
99      *
100      *  - an externally-owned account
101      *  - a contract in construction
102      *  - an address where a contract will be created
103      *  - an address where a contract lived, but was destroyed
104      * ====
105      */
106     function isContract(address account) internal view returns (bool) {
107         // This method relies on extcodesize, which returns 0 for contracts in
108         // construction, since the code is only stored at the end of the
109         // constructor execution.
110 
111         uint256 size;
112         // solhint-disable-next-line no-inline-assembly
113         assembly { size := extcodesize(account) }
114         return size > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
137         (bool success, ) = recipient.call{ value: amount }("");
138         require(success, "Address: unable to send value, recipient may have reverted");
139     }
140 
141     /**
142      * @dev Performs a Solidity function call using a low level `call`. A
143      * plain`call` is an unsafe replacement for a function call: use this
144      * function instead.
145      *
146      * If `target` reverts with a revert reason, it is bubbled up by this
147      * function (like regular Solidity function calls).
148      *
149      * Returns the raw returned data. To convert to the expected return value,
150      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
151      *
152      * Requirements:
153      *
154      * - `target` must be a contract.
155      * - calling `target` with `data` must not revert.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160       return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
165      * `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
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
184     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
190      * with `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
195         require(address(this).balance >= value, "Address: insufficient balance for call");
196         require(isContract(target), "Address: call to non-contract");
197 
198         // solhint-disable-next-line avoid-low-level-calls
199         (bool success, bytes memory returndata) = target.call{ value: value }(data);
200         return _verifyCallResult(success, returndata, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but performing a static call.
206      *
207      * _Available since v3.3._
208      */
209     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
210         return functionStaticCall(target, data, "Address: low-level static call failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
220         require(isContract(target), "Address: static call to non-contract");
221 
222         // solhint-disable-next-line avoid-low-level-calls
223         (bool success, bytes memory returndata) = target.staticcall(data);
224         return _verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a delegate call.
230      *
231      * _Available since v3.4._
232      */
233     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
244         require(isContract(target), "Address: delegate call to non-contract");
245 
246         // solhint-disable-next-line avoid-low-level-calls
247         (bool success, bytes memory returndata) = target.delegatecall(data);
248         return _verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
252         if (success) {
253             return returndata;
254         } else {
255             // Look for revert reason and bubble it up if present
256             if (returndata.length > 0) {
257                 // The easiest way to bubble the revert reason is using memory via assembly
258 
259                 // solhint-disable-next-line no-inline-assembly
260                 assembly {
261                     let returndata_size := mload(returndata)
262                     revert(add(32, returndata), returndata_size)
263                 }
264             } else {
265                 revert(errorMessage);
266             }
267         }
268     }
269 }
270 
271 /**
272  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
273  * implementation address that can be changed. This address is stored in storage in the location specified by
274  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
275  * implementation behind the proxy.
276  *
277  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
278  * {TransparentUpgradeableProxy}.
279  */
280 contract UpgradeableProxy is Proxy {
281     /**
282      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
283      *
284      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
285      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
286      */
287     constructor(address _logic, bytes memory _data) payable {
288         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
289         _setImplementation(_logic);
290         if(_data.length > 0) {
291             Address.functionDelegateCall(_logic, _data);
292         }
293     }
294 
295     /**
296      * @dev Emitted when the implementation is upgraded.
297      */
298     event Upgraded(address indexed implementation);
299 
300     /**
301      * @dev Storage slot with the address of the current implementation.
302      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
303      * validated in the constructor.
304      */
305     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
306 
307     /**
308      * @dev Returns the current implementation address.
309      */
310     function _implementation() internal view virtual override returns (address impl) {
311         bytes32 slot = _IMPLEMENTATION_SLOT;
312         // solhint-disable-next-line no-inline-assembly
313         assembly {
314             impl := sload(slot)
315         }
316     }
317 
318     /**
319      * @dev Upgrades the proxy to a new implementation.
320      *
321      * Emits an {Upgraded} event.
322      */
323     function _upgradeTo(address newImplementation) internal virtual {
324         _setImplementation(newImplementation);
325         emit Upgraded(newImplementation);
326     }
327 
328     /**
329      * @dev Stores a new address in the EIP1967 implementation slot.
330      */
331     function _setImplementation(address newImplementation) private {
332         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
333 
334         bytes32 slot = _IMPLEMENTATION_SLOT;
335 
336         // solhint-disable-next-line no-inline-assembly
337         assembly {
338             sstore(slot, newImplementation)
339         }
340     }
341 }
342 
343 contract TransparentUpgradeableProxy is UpgradeableProxy {
344     /**
345      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
346      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
347      */
348     constructor(address _logic, address admin_, bytes memory _data) payable UpgradeableProxy(_logic, _data) {
349         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
350         _setAdmin(admin_);
351     }
352 
353     /**
354      * @dev Emitted when the admin account has changed.
355      */
356     event AdminChanged(address previousAdmin, address newAdmin);
357 
358     /**
359      * @dev Storage slot with the admin of the contract.
360      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
361      * validated in the constructor.
362      */
363     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
364 
365     /**
366      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
367      */
368     modifier ifAdmin() {
369         if (msg.sender == _admin()) {
370             _;
371         } else {
372             _fallback();
373         }
374     }
375 
376     /**
377      * @dev Returns the current admin.
378      *
379      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
380      *
381      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
382      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
383      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
384      */
385     function admin() external ifAdmin returns (address admin_) {
386         admin_ = _admin();
387     }
388 
389     /**
390      * @dev Returns the current implementation.
391      *
392      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
393      *
394      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
395      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
396      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
397      */
398     function implementation() external ifAdmin returns (address implementation_) {
399         implementation_ = _implementation();
400     }
401 
402     /**
403      * @dev Changes the admin of the proxy.
404      *
405      * Emits an {AdminChanged} event.
406      *
407      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
408      */
409     function changeAdmin(address newAdmin) external virtual ifAdmin {
410         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
411         emit AdminChanged(_admin(), newAdmin);
412         _setAdmin(newAdmin);
413     }
414 
415     /**
416      * @dev Upgrade the implementation of the proxy.
417      *
418      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
419      */
420     function upgradeTo(address newImplementation) external virtual ifAdmin {
421         _upgradeTo(newImplementation);
422     }
423 
424     /**
425      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
426      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
427      * proxied contract.
428      *
429      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
430      */
431     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable virtual ifAdmin {
432         _upgradeTo(newImplementation);
433         Address.functionDelegateCall(newImplementation, data);
434     }
435 
436     /**
437      * @dev Returns the current admin.
438      */
439     function _admin() internal view virtual returns (address adm) {
440         bytes32 slot = _ADMIN_SLOT;
441         // solhint-disable-next-line no-inline-assembly
442         assembly {
443             adm := sload(slot)
444         }
445     }
446 
447     /**
448      * @dev Stores a new address in the EIP1967 admin slot.
449      */
450     function _setAdmin(address newAdmin) private {
451         bytes32 slot = _ADMIN_SLOT;
452 
453         // solhint-disable-next-line no-inline-assembly
454         assembly {
455             sstore(slot, newAdmin)
456         }
457     }
458 
459     /**
460      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
461      */
462     function _beforeFallback() internal virtual override {
463         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
464         super._beforeFallback();
465     }
466 }
467 
468 // import { InitializableAdminUpgradeabilityProxy } from "../shared/@openzeppelin-2.5/upgrades/InitializableAdminUpgradeabilityProxy.sol";
469 /**
470  * @notice AssetProxy delegates calls to a Masset implementation
471  * @dev    Extending on OpenZeppelin's InitializableAdminUpgradabilityProxy
472  * means that the proxy is upgradable through a ProxyAdmin. AssetProxy upgrades
473  * are implemented by a DelayedProxyAdmin, which enforces a 1 week opt-out period.
474  * All upgrades are governed through the current mStable governance.
475  */
476 contract AssetProxy is TransparentUpgradeableProxy {
477     constructor(
478         address _logic,
479         address admin_,
480         bytes memory _data
481     ) payable TransparentUpgradeableProxy(_logic, admin_, _data) {}
482 }