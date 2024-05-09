1 // SPDX-License-Identifier: Apache License, Version 2.0
2 
3 pragma solidity 0.7.6;
4 
5 
6 
7 // Part: Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // Part: Proxy
196 
197 /**
198  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
199  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
200  * be specified by overriding the virtual {_implementation} function.
201  *
202  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
203  * different contract through the {_delegate} function.
204  *
205  * The success and return data of the delegated call will be returned back to the caller of the proxy.
206  */
207 abstract contract Proxy {
208     /**
209      * @dev Delegates the current call to `implementation`.
210      *
211      * This function does not return to its internall call site, it will return directly to the external caller.
212      */
213     function _delegate(address implementation) internal virtual {
214         // solhint-disable-next-line no-inline-assembly
215         assembly {
216             // Copy msg.data. We take full control of memory in this inline assembly
217             // block because it will not return to Solidity code. We overwrite the
218             // Solidity scratch pad at memory position 0.
219             calldatacopy(0, 0, calldatasize())
220 
221             // Call the implementation.
222             // out and outsize are 0 because we don't know the size yet.
223             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
224 
225             // Copy the returned data.
226             returndatacopy(0, 0, returndatasize())
227 
228             switch result
229             // delegatecall returns 0 on error.
230             case 0 { revert(0, returndatasize()) }
231             default { return(0, returndatasize()) }
232         }
233     }
234 
235     /**
236      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
237      * and {_fallback} should delegate.
238      */
239     function _implementation() internal view virtual returns (address);
240 
241     /**
242      * @dev Delegates the current call to the address returned by `_implementation()`.
243      *
244      * This function does not return to its internall call site, it will return directly to the external caller.
245      */
246     function _fallback() internal virtual {
247         _beforeFallback();
248         _delegate(_implementation());
249     }
250 
251     /**
252      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
253      * function in the contract matches the call data.
254      */
255     fallback () external payable virtual {
256         _fallback();
257     }
258 
259     /**
260      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
261      * is empty.
262      */
263     receive () external payable virtual {
264         _fallback();
265     }
266 
267     /**
268      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
269      * call, or as part of the Solidity `fallback` or `receive` functions.
270      *
271      * If overriden should call `super._beforeFallback()`.
272      */
273     function _beforeFallback() internal virtual {
274     }
275 }
276 
277 // Part: UpgradeableProxy
278 
279 /**
280  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
281  * implementation address that can be changed. This address is stored in storage in the location specified by
282  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
283  * implementation behind the proxy.
284  *
285  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
286  * {TransparentUpgradeableProxy}.
287  */
288 contract UpgradeableProxy is Proxy {
289     /**
290      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
291      *
292      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
293      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
294      */
295     constructor(address _logic, bytes memory _data) public payable {
296         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
297         _setImplementation(_logic);
298         if(_data.length > 0) {
299             Address.functionDelegateCall(_logic, _data);
300         }
301     }
302 
303     /**
304      * @dev Emitted when the implementation is upgraded.
305      */
306     event Upgraded(address indexed implementation);
307 
308     /**
309      * @dev Storage slot with the address of the current implementation.
310      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
311      * validated in the constructor.
312      */
313     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
314 
315     /**
316      * @dev Returns the current implementation address.
317      */
318     function _implementation() internal view virtual override returns (address impl) {
319         bytes32 slot = _IMPLEMENTATION_SLOT;
320         // solhint-disable-next-line no-inline-assembly
321         assembly {
322             impl := sload(slot)
323         }
324     }
325 
326     /**
327      * @dev Upgrades the proxy to a new implementation.
328      *
329      * Emits an {Upgraded} event.
330      */
331     function _upgradeTo(address newImplementation) internal virtual {
332         _setImplementation(newImplementation);
333         emit Upgraded(newImplementation);
334     }
335 
336     /**
337      * @dev Stores a new address in the EIP1967 implementation slot.
338      */
339     function _setImplementation(address newImplementation) private {
340         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
341 
342         bytes32 slot = _IMPLEMENTATION_SLOT;
343 
344         // solhint-disable-next-line no-inline-assembly
345         assembly {
346             sstore(slot, newImplementation)
347         }
348     }
349 }
350 
351 // Part: TransparentUpgradeableProxy
352 
353 /**
354  * @dev This contract implements a proxy that is upgradeable by an admin.
355  *
356  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
357  * clashing], which can potentially be used in an attack, this contract uses the
358  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
359  * things that go hand in hand:
360  *
361  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
362  * that call matches one of the admin functions exposed by the proxy itself.
363  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
364  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
365  * "admin cannot fallback to proxy target".
366  *
367  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
368  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
369  * to sudden errors when trying to call a function from the proxy implementation.
370  *
371  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
372  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
373  */
374 contract TransparentUpgradeableProxy is UpgradeableProxy {
375     /**
376      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
377      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
378      */
379     constructor(address _logic, address admin_, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
380         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
381         _setAdmin(admin_);
382     }
383 
384     /**
385      * @dev Emitted when the admin account has changed.
386      */
387     event AdminChanged(address previousAdmin, address newAdmin);
388 
389     /**
390      * @dev Storage slot with the admin of the contract.
391      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
392      * validated in the constructor.
393      */
394     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
395 
396     /**
397      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
398      */
399     modifier ifAdmin() {
400         if (msg.sender == _admin()) {
401             _;
402         } else {
403             _fallback();
404         }
405     }
406 
407     /**
408      * @dev Returns the current admin.
409      *
410      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
411      *
412      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
413      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
414      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
415      */
416     function admin() external ifAdmin returns (address admin_) {
417         admin_ = _admin();
418     }
419 
420     /**
421      * @dev Returns the current implementation.
422      *
423      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
424      *
425      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
426      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
427      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
428      */
429     function implementation() external ifAdmin returns (address implementation_) {
430         implementation_ = _implementation();
431     }
432 
433     /**
434      * @dev Changes the admin of the proxy.
435      *
436      * Emits an {AdminChanged} event.
437      *
438      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
439      */
440     function changeAdmin(address newAdmin) external virtual ifAdmin {
441         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
442         emit AdminChanged(_admin(), newAdmin);
443         _setAdmin(newAdmin);
444     }
445 
446     /**
447      * @dev Upgrade the implementation of the proxy.
448      *
449      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
450      */
451     function upgradeTo(address newImplementation) external virtual ifAdmin {
452         _upgradeTo(newImplementation);
453     }
454 
455     /**
456      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
457      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
458      * proxied contract.
459      *
460      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
461      */
462     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable virtual ifAdmin {
463         _upgradeTo(newImplementation);
464         Address.functionDelegateCall(newImplementation, data);
465     }
466 
467     /**
468      * @dev Returns the current admin.
469      */
470     function _admin() internal view virtual returns (address adm) {
471         bytes32 slot = _ADMIN_SLOT;
472         // solhint-disable-next-line no-inline-assembly
473         assembly {
474             adm := sload(slot)
475         }
476     }
477 
478     /**
479      * @dev Stores a new address in the EIP1967 admin slot.
480      */
481     function _setAdmin(address newAdmin) private {
482         bytes32 slot = _ADMIN_SLOT;
483 
484         // solhint-disable-next-line no-inline-assembly
485         assembly {
486             sstore(slot, newAdmin)
487         }
488     }
489 
490     /**
491      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
492      */
493     function _beforeFallback() internal virtual override {
494         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
495         super._beforeFallback();
496     }
497 }
498 
499 // File: StarNFTProxy.sol
500 
501 /**
502  * There is a vulnerability SWC-106 which implicitly caused by delegation to self-destruct call which will results in
503  * anyone could destruct the real-contract.
504  */
505 contract StarNFTProxy is TransparentUpgradeableProxy {
506 
507     constructor(address _implement, address _owner, bytes memory _data) TransparentUpgradeableProxy(_implement, _owner, _data) {}
508 
509     function proxyImplementation() external view returns (address) {
510         return _implementation();
511     }
512 
513     function proxyAdmin() external view returns (address) {
514         return _admin();
515     }
516 }
