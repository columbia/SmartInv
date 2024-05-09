1 // File: @openzeppelin/contracts/proxy/Proxy.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
9  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
10  * be specified by overriding the virtual {_implementation} function.
11  *
12  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
13  * different contract through the {_delegate} function.
14  *
15  * The success and return data of the delegated call will be returned back to the caller of the proxy.
16  */
17 abstract contract Proxy {
18     /**
19      * @dev Delegates the current call to `implementation`.
20      *
21      * This function does not return to its internall call site, it will return directly to the external caller.
22      */
23     function _delegate(address implementation) internal {
24         // solhint-disable-next-line no-inline-assembly
25         assembly {
26             // Copy msg.data. We take full control of memory in this inline assembly
27             // block because it will not return to Solidity code. We overwrite the
28             // Solidity scratch pad at memory position 0.
29             calldatacopy(0, 0, calldatasize())
30 
31             // Call the implementation.
32             // out and outsize are 0 because we don't know the size yet.
33             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
34 
35             // Copy the returned data.
36             returndatacopy(0, 0, returndatasize())
37 
38             switch result
39             // delegatecall returns 0 on error.
40             case 0 { revert(0, returndatasize()) }
41             default { return(0, returndatasize()) }
42         }
43     }
44 
45     /**
46      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
47      * and {_fallback} should delegate.
48      */
49     function _implementation() internal virtual view returns (address);
50 
51     /**
52      * @dev Delegates the current call to the address returned by `_implementation()`.
53      *
54      * This function does not return to its internall call site, it will return directly to the external caller.
55      */
56     function _fallback() internal {
57         _beforeFallback();
58         _delegate(_implementation());
59     }
60 
61     /**
62      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
63      * function in the contract matches the call data.
64      */
65     fallback () external payable {
66         _fallback();
67     }
68 
69     /**
70      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
71      * is empty.
72      */
73     receive () external payable {
74         _fallback();
75     }
76 
77     /**
78      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
79      * call, or as part of the Solidity `fallback` or `receive` functions.
80      *
81      * If overriden should call `super._beforeFallback()`.
82      */
83     function _beforeFallback() internal virtual {
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Address.sol
88 
89 // SPDX-License-Identifier: MIT
90 
91 pragma solidity >=0.6.2 <0.8.0;
92 
93 /**
94  * @dev Collection of functions related to the address type
95  */
96 library Address {
97     /**
98      * @dev Returns true if `account` is a contract.
99      *
100      * [IMPORTANT]
101      * ====
102      * It is unsafe to assume that an address for which this function returns
103      * false is an externally-owned account (EOA) and not a contract.
104      *
105      * Among others, `isContract` will return false for the following
106      * types of addresses:
107      *
108      *  - an externally-owned account
109      *  - a contract in construction
110      *  - an address where a contract will be created
111      *  - an address where a contract lived, but was destroyed
112      * ====
113      */
114     function isContract(address account) internal view returns (bool) {
115         // This method relies on extcodesize, which returns 0 for contracts in
116         // construction, since the code is only stored at the end of the
117         // constructor execution.
118 
119         uint256 size;
120         // solhint-disable-next-line no-inline-assembly
121         assembly { size := extcodesize(account) }
122         return size > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
145         (bool success, ) = recipient.call{ value: amount }("");
146         require(success, "Address: unable to send value, recipient may have reverted");
147     }
148 
149     /**
150      * @dev Performs a Solidity function call using a low level `call`. A
151      * plain`call` is an unsafe replacement for a function call: use this
152      * function instead.
153      *
154      * If `target` reverts with a revert reason, it is bubbled up by this
155      * function (like regular Solidity function calls).
156      *
157      * Returns the raw returned data. To convert to the expected return value,
158      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
159      *
160      * Requirements:
161      *
162      * - `target` must be a contract.
163      * - calling `target` with `data` must not revert.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168       return functionCall(target, data, "Address: low-level call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
173      * `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but also transferring `value` wei to `target`.
184      *
185      * Requirements:
186      *
187      * - the calling contract must have an ETH balance of at least `value`.
188      * - the called Solidity function must be `payable`.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
198      * with `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
203         require(address(this).balance >= value, "Address: insufficient balance for call");
204         require(isContract(target), "Address: call to non-contract");
205 
206         // solhint-disable-next-line avoid-low-level-calls
207         (bool success, bytes memory returndata) = target.call{ value: value }(data);
208         return _verifyCallResult(success, returndata, errorMessage);
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
227     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
228         require(isContract(target), "Address: static call to non-contract");
229 
230         // solhint-disable-next-line avoid-low-level-calls
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return _verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
236         if (success) {
237             return returndata;
238         } else {
239             // Look for revert reason and bubble it up if present
240             if (returndata.length > 0) {
241                 // The easiest way to bubble the revert reason is using memory via assembly
242 
243                 // solhint-disable-next-line no-inline-assembly
244                 assembly {
245                     let returndata_size := mload(returndata)
246                     revert(add(32, returndata), returndata_size)
247                 }
248             } else {
249                 revert(errorMessage);
250             }
251         }
252     }
253 }
254 
255 // File: @openzeppelin/contracts/proxy/UpgradeableProxy.sol
256 
257 // SPDX-License-Identifier: MIT
258 
259 pragma solidity >=0.6.0 <0.8.0;
260 
261 
262 
263 /**
264  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
265  * implementation address that can be changed. This address is stored in storage in the location specified by
266  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
267  * implementation behind the proxy.
268  *
269  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
270  * {TransparentUpgradeableProxy}.
271  */
272 contract UpgradeableProxy is Proxy {
273     /**
274      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
275      *
276      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
277      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
278      */
279     constructor(address _logic, bytes memory _data) public payable {
280         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
281         _setImplementation(_logic);
282         if(_data.length > 0) {
283             // solhint-disable-next-line avoid-low-level-calls
284             (bool success,) = _logic.delegatecall(_data);
285             require(success);
286         }
287     }
288 
289     /**
290      * @dev Emitted when the implementation is upgraded.
291      */
292     event Upgraded(address indexed implementation);
293 
294     /**
295      * @dev Storage slot with the address of the current implementation.
296      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
297      * validated in the constructor.
298      */
299     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
300 
301     /**
302      * @dev Returns the current implementation address.
303      */
304     function _implementation() internal override view returns (address impl) {
305         bytes32 slot = _IMPLEMENTATION_SLOT;
306         // solhint-disable-next-line no-inline-assembly
307         assembly {
308             impl := sload(slot)
309         }
310     }
311 
312     /**
313      * @dev Upgrades the proxy to a new implementation.
314      *
315      * Emits an {Upgraded} event.
316      */
317     function _upgradeTo(address newImplementation) internal {
318         _setImplementation(newImplementation);
319         emit Upgraded(newImplementation);
320     }
321 
322     /**
323      * @dev Stores a new address in the EIP1967 implementation slot.
324      */
325     function _setImplementation(address newImplementation) private {
326         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
327 
328         bytes32 slot = _IMPLEMENTATION_SLOT;
329 
330         // solhint-disable-next-line no-inline-assembly
331         assembly {
332             sstore(slot, newImplementation)
333         }
334     }
335 }
336 
337 // File: @openzeppelin/contracts/proxy/TransparentUpgradeableProxy.sol
338 
339 // SPDX-License-Identifier: MIT
340 
341 pragma solidity >=0.6.0 <0.8.0;
342 
343 
344 /**
345  * @dev This contract implements a proxy that is upgradeable by an admin.
346  *
347  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
348  * clashing], which can potentially be used in an attack, this contract uses the
349  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
350  * things that go hand in hand:
351  *
352  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
353  * that call matches one of the admin functions exposed by the proxy itself.
354  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
355  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
356  * "admin cannot fallback to proxy target".
357  *
358  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
359  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
360  * to sudden errors when trying to call a function from the proxy implementation.
361  *
362  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
363  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
364  */
365 contract TransparentUpgradeableProxy is UpgradeableProxy {
366     /**
367      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
368      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
369      */
370     constructor(address _logic, address admin_, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
371         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
372         _setAdmin(admin_);
373     }
374 
375     /**
376      * @dev Emitted when the admin account has changed.
377      */
378     event AdminChanged(address previousAdmin, address newAdmin);
379 
380     /**
381      * @dev Storage slot with the admin of the contract.
382      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
383      * validated in the constructor.
384      */
385     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
386 
387     /**
388      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
389      */
390     modifier ifAdmin() {
391         if (msg.sender == _admin()) {
392             _;
393         } else {
394             _fallback();
395         }
396     }
397 
398     /**
399      * @dev Returns the current admin.
400      *
401      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
402      *
403      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
404      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
405      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
406      */
407     function admin() external ifAdmin returns (address admin_) {
408         admin_ = _admin();
409     }
410 
411     /**
412      * @dev Returns the current implementation.
413      *
414      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
415      *
416      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
417      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
418      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
419      */
420     function implementation() external ifAdmin returns (address implementation_) {
421         implementation_ = _implementation();
422     }
423 
424     /**
425      * @dev Changes the admin of the proxy.
426      *
427      * Emits an {AdminChanged} event.
428      *
429      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
430      */
431     function changeAdmin(address newAdmin) external ifAdmin {
432         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
433         emit AdminChanged(_admin(), newAdmin);
434         _setAdmin(newAdmin);
435     }
436 
437     /**
438      * @dev Upgrade the implementation of the proxy.
439      *
440      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
441      */
442     function upgradeTo(address newImplementation) external ifAdmin {
443         _upgradeTo(newImplementation);
444     }
445 
446     /**
447      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
448      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
449      * proxied contract.
450      *
451      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
452      */
453     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
454         _upgradeTo(newImplementation);
455         // solhint-disable-next-line avoid-low-level-calls
456         (bool success,) = newImplementation.delegatecall(data);
457         require(success);
458     }
459 
460     /**
461      * @dev Returns the current admin.
462      */
463     function _admin() internal view returns (address adm) {
464         bytes32 slot = _ADMIN_SLOT;
465         // solhint-disable-next-line no-inline-assembly
466         assembly {
467             adm := sload(slot)
468         }
469     }
470 
471     /**
472      * @dev Stores a new address in the EIP1967 admin slot.
473      */
474     function _setAdmin(address newAdmin) private {
475         bytes32 slot = _ADMIN_SLOT;
476 
477         // solhint-disable-next-line no-inline-assembly
478         assembly {
479             sstore(slot, newAdmin)
480         }
481     }
482 
483     /**
484      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
485      */
486     function _beforeFallback() internal override virtual {
487         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
488         super._beforeFallback();
489     }
490 }
491 
492 // File: contracts/proxies/xKNCProxy.sol
493 
494 pragma solidity 0.6.2;
495 pragma experimental ABIEncoderV2;
496 
497 
498 contract xKNCProxy is TransparentUpgradeableProxy {
499     constructor(address _logic, address _proxyAdmin)
500         public
501         TransparentUpgradeableProxy(
502             _logic,
503             _proxyAdmin,
504             ""
505         )
506     {}
507 }