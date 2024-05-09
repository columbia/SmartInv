1 // File: @openzeppelin/contracts/proxy/Proxy.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
65     fallback () payable external {
66         _fallback();
67     }
68 
69     /**
70      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
71      * is empty.
72      */
73     receive () payable external {
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
91 pragma solidity ^0.6.2;
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
115         // This method relies in extcodesize, which returns 0 for contracts in
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
178         return _functionCallWithValue(target, data, 0, errorMessage);
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
204         return _functionCallWithValue(target, data, value, errorMessage);
205     }
206 
207     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
208         require(isContract(target), "Address: call to non-contract");
209 
210         // solhint-disable-next-line avoid-low-level-calls
211         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
212         if (success) {
213             return returndata;
214         } else {
215             // Look for revert reason and bubble it up if present
216             if (returndata.length > 0) {
217                 // The easiest way to bubble the revert reason is using memory via assembly
218 
219                 // solhint-disable-next-line no-inline-assembly
220                 assembly {
221                     let returndata_size := mload(returndata)
222                     revert(add(32, returndata), returndata_size)
223                 }
224             } else {
225                 revert(errorMessage);
226             }
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/proxy/UpgradeableProxy.sol
232 
233 // SPDX-License-Identifier: MIT
234 
235 pragma solidity ^0.6.0;
236 
237 
238 
239 /**
240  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
241  * implementation address that can be changed. This address is stored in storage in the location specified by
242  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
243  * implementation behind the proxy.
244  * 
245  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
246  * {TransparentUpgradeableProxy}.
247  */
248 contract UpgradeableProxy is Proxy {
249     /**
250      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
251      * 
252      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
253      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
254      */
255     constructor(address _logic, bytes memory _data) public payable {
256         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
257         _setImplementation(_logic);
258         if(_data.length > 0) {
259             // solhint-disable-next-line avoid-low-level-calls
260             (bool success,) = _logic.delegatecall(_data);
261             require(success);
262         }
263     }
264 
265     /**
266      * @dev Emitted when the implementation is upgraded.
267      */
268     event Upgraded(address indexed implementation);
269 
270     /**
271      * @dev Storage slot with the address of the current implementation.
272      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
273      * validated in the constructor.
274      */
275     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
276 
277     /**
278      * @dev Returns the current implementation address.
279      */
280     function _implementation() internal override view returns (address impl) {
281         bytes32 slot = _IMPLEMENTATION_SLOT;
282         // solhint-disable-next-line no-inline-assembly
283         assembly {
284             impl := sload(slot)
285         }
286     }
287 
288     /**
289      * @dev Upgrades the proxy to a new implementation.
290      * 
291      * Emits an {Upgraded} event.
292      */
293     function _upgradeTo(address newImplementation) internal {
294         _setImplementation(newImplementation);
295         emit Upgraded(newImplementation);
296     }
297 
298     /**
299      * @dev Stores a new address in the EIP1967 implementation slot.
300      */
301     function _setImplementation(address newImplementation) private {
302         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
303 
304         bytes32 slot = _IMPLEMENTATION_SLOT;
305 
306         // solhint-disable-next-line no-inline-assembly
307         assembly {
308             sstore(slot, newImplementation)
309         }
310     }
311 }
312 
313 // File: @openzeppelin/contracts/proxy/TransparentUpgradeableProxy.sol
314 
315 // SPDX-License-Identifier: MIT
316 
317 pragma solidity ^0.6.0;
318 
319 
320 /**
321  * @dev This contract implements a proxy that is upgradeable by an admin.
322  * 
323  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
324  * clashing], which can potentially be used in an attack, this contract uses the
325  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
326  * things that go hand in hand:
327  * 
328  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
329  * that call matches one of the admin functions exposed by the proxy itself.
330  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
331  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
332  * "admin cannot fallback to proxy target".
333  * 
334  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
335  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
336  * to sudden errors when trying to call a function from the proxy implementation.
337  * 
338  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
339  * you should think of the `ProxyAdmin` instance as the real administrative inerface of your proxy.
340  */
341 contract TransparentUpgradeableProxy is UpgradeableProxy {
342     /**
343      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
344      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
345      */
346     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
347         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
348         _setAdmin(_admin);
349     }
350 
351     /**
352      * @dev Emitted when the admin account has changed.
353      */
354     event AdminChanged(address previousAdmin, address newAdmin);
355 
356     /**
357      * @dev Storage slot with the admin of the contract.
358      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
359      * validated in the constructor.
360      */
361     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
362 
363     /**
364      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
365      */
366     modifier ifAdmin() {
367         if (msg.sender == _admin()) {
368             _;
369         } else {
370             _fallback();
371         }
372     }
373 
374     /**
375      * @dev Returns the current admin.
376      * 
377      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
378      * 
379      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
380      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
381      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
382      */
383     function admin() external ifAdmin returns (address) {
384         return _admin();
385     }
386 
387     /**
388      * @dev Returns the current implementation.
389      * 
390      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
391      * 
392      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
393      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
394      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
395      */
396     function implementation() external ifAdmin returns (address) {
397         return _implementation();
398     }
399 
400     /**
401      * @dev Changes the admin of the proxy.
402      * 
403      * Emits an {AdminChanged} event.
404      * 
405      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
406      */
407     function changeAdmin(address newAdmin) external ifAdmin {
408         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
409         emit AdminChanged(_admin(), newAdmin);
410         _setAdmin(newAdmin);
411     }
412 
413     /**
414      * @dev Upgrade the implementation of the proxy.
415      * 
416      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
417      */
418     function upgradeTo(address newImplementation) external ifAdmin {
419         _upgradeTo(newImplementation);
420     }
421 
422     /**
423      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
424      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
425      * proxied contract.
426      * 
427      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
428      */
429     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
430         _upgradeTo(newImplementation);
431         // solhint-disable-next-line avoid-low-level-calls
432         (bool success,) = newImplementation.delegatecall(data);
433         require(success);
434     }
435 
436     /**
437      * @dev Returns the current admin.
438      */
439     function _admin() internal view returns (address adm) {
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
462     function _beforeFallback() internal override virtual {
463         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
464         super._beforeFallback();
465     }
466 }