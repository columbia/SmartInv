1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.6.12;
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
21     function _delegate(address implementation) internal {
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
47     function _implementation() internal virtual view returns (address);
48 
49     /**
50      * @dev Delegates the current call to the address returned by `_implementation()`.
51      * 
52      * This function does not return to its internall call site, it will return directly to the external caller.
53      */
54     function _fallback() internal {
55         _beforeFallback();
56         _delegate(_implementation());
57     }
58 
59     /**
60      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
61      * function in the contract matches the call data.
62      */
63     fallback () payable external {
64         _fallback();
65     }
66 
67     /**
68      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
69      * is empty.
70      */
71     receive () payable external {
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
85 // File: openzeppelin-solidity/contracts/utils/Address.sol
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
109         // This method relies in extcodesize, which returns 0 for contracts in
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
172         return _functionCallWithValue(target, data, 0, errorMessage);
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
198         return _functionCallWithValue(target, data, value, errorMessage);
199     }
200 
201     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
202         require(isContract(target), "Address: call to non-contract");
203 
204         // solhint-disable-next-line avoid-low-level-calls
205         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
206         if (success) {
207             return returndata;
208         } else {
209             // Look for revert reason and bubble it up if present
210             if (returndata.length > 0) {
211                 // The easiest way to bubble the revert reason is using memory via assembly
212 
213                 // solhint-disable-next-line no-inline-assembly
214                 assembly {
215                     let returndata_size := mload(returndata)
216                     revert(add(32, returndata), returndata_size)
217                 }
218             } else {
219                 revert(errorMessage);
220             }
221         }
222     }
223 }
224 
225 // File: openzeppelin-solidity/contracts/proxy/UpgradeableProxy.sol
226 
227 /**
228  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
229  * implementation address that can be changed. This address is stored in storage in the location specified by
230  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
231  * implementation behind the proxy.
232  * 
233  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
234  * {TransparentUpgradeableProxy}.
235  */
236 contract UpgradeableProxy is Proxy {
237     /**
238      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
239      * 
240      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
241      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
242      */
243     constructor(address _logic, bytes memory _data) public payable {
244         require(_logic != address(0), "Invalid logic address");
245         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
246         _setImplementation(_logic);
247         if(_data.length > 0) {
248             // solhint-disable-next-line avoid-low-level-calls
249             (bool success,) = _logic.delegatecall(_data);
250             require(success);
251         }
252     }
253 
254     /**
255      * @dev Emitted when the implementation is upgraded.
256      */
257     event Upgraded(address indexed implementation);
258 
259     /**
260      * @dev Storage slot with the address of the current implementation.
261      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
262      * validated in the constructor.
263      */
264     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
265 
266     /**
267      * @dev Returns the current implementation address.
268      */
269     function _implementation() internal override view returns (address impl) {
270         bytes32 slot = _IMPLEMENTATION_SLOT;
271         // solhint-disable-next-line no-inline-assembly
272         assembly {
273             impl := sload(slot)
274         }
275     }
276 
277     /**
278      * @dev Upgrades the proxy to a new implementation.
279      * 
280      * Emits an {Upgraded} event.
281      */
282     function _upgradeTo(address newImplementation) internal {
283         _setImplementation(newImplementation);
284         emit Upgraded(newImplementation);
285     }
286 
287     /**
288      * @dev Stores a new address in the EIP1967 implementation slot.
289      */
290     function _setImplementation(address newImplementation) private {
291         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
292 
293         bytes32 slot = _IMPLEMENTATION_SLOT;
294 
295         // solhint-disable-next-line no-inline-assembly
296         assembly {
297             sstore(slot, newImplementation)
298         }
299     }
300 }
301 
302 // File: openzeppelin-solidity/contracts/proxy/TransparentUpgradeableProxy.sol
303 
304 /**
305  * @dev This contract implements a proxy that is upgradeable by an admin.
306  * 
307  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
308  * clashing], which can potentially be used in an attack, this contract uses the
309  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
310  * things that go hand in hand:
311  * 
312  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
313  * that call matches one of the admin functions exposed by the proxy itself.
314  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
315  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
316  * "admin cannot fallback to proxy target".
317  * 
318  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
319  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
320  * to sudden errors when trying to call a function from the proxy implementation.
321  * 
322  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
323  * you should think of the `ProxyAdmin` instance as the real administrative inerface of your proxy.
324  */
325 contract TransparentUpgradeableProxy is UpgradeableProxy {
326     /**
327      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
328      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
329      */
330     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
331         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
332         _setAdmin(_admin);
333     }
334 
335     /**
336      * @dev Emitted when the admin account has changed.
337      */
338     event AdminChanged(address previousAdmin, address newAdmin);
339 
340     /**
341      * @dev Storage slot with the admin of the contract.
342      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
343      * validated in the constructor.
344      */
345     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
346 
347     /**
348      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
349      */
350     modifier ifAdmin() {
351         if (msg.sender == _admin()) {
352             _;
353         } else {
354             _fallback();
355         }
356     }
357 
358     /**
359      * @dev Returns the current admin.
360      * 
361      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
362      * 
363      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
364      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
365      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
366      */
367     function admin() external ifAdmin returns (address) {
368         return _admin();
369     }
370 
371     /**
372      * @dev Returns the current implementation.
373      * 
374      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
375      * 
376      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
377      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
378      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
379      */
380     function implementation() external ifAdmin returns (address) {
381         return _implementation();
382     }
383 
384     /**
385      * @dev Changes the admin of the proxy.
386      * 
387      * Emits an {AdminChanged} event.
388      * 
389      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
390      */
391     function changeAdmin(address newAdmin) external ifAdmin {
392         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
393         emit AdminChanged(_admin(), newAdmin);
394         _setAdmin(newAdmin);
395     }
396 
397     /**
398      * @dev Upgrade the implementation of the proxy.
399      * 
400      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
401      */
402     function upgradeTo(address newImplementation) external ifAdmin {
403         _upgradeTo(newImplementation);
404     }
405 
406     /**
407      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
408      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
409      * proxied contract.
410      * 
411      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
412      */
413     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
414         require(newImplementation != address(0), "Invalid newImplementation address");
415         _upgradeTo(newImplementation);
416         // solhint-disable-next-line avoid-low-level-calls
417         (bool success,) = newImplementation.delegatecall(data);
418         require(success);
419     }
420 
421     /**
422      * @dev Returns the current admin.
423      */
424     function _admin() internal view returns (address adm) {
425         bytes32 slot = _ADMIN_SLOT;
426         // solhint-disable-next-line no-inline-assembly
427         assembly {
428             adm := sload(slot)
429         }
430     }
431 
432     /**
433      * @dev Stores a new address in the EIP1967 admin slot.
434      */
435     function _setAdmin(address newAdmin) private {
436         bytes32 slot = _ADMIN_SLOT;
437 
438         // solhint-disable-next-line no-inline-assembly
439         assembly {
440             sstore(slot, newAdmin)
441         }
442     }
443 
444     /**
445      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
446      */
447     function _beforeFallback() internal override virtual {
448         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
449         super._beforeFallback();
450     }
451 }
452 
453 // File: contracts/AdminUpgradeabilityProxy.sol
454 contract AdminUpgradeabilityProxy is TransparentUpgradeableProxy {
455 
456     constructor(address logic, address admin, bytes memory data) TransparentUpgradeableProxy(logic, admin, data) public {
457     }
458 }