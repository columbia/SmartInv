1 pragma solidity 0.6.6;
2 
3 // SPDX-License-Identifier: Unlicensed
4 
5 
6 // SPDX-License-Identifier: Unlicensed
7 
8 // SPDX-License-Identifier: MIT
9 
10 
11 // SPDX-License-Identifier: MIT
12 
13 
14 // SPDX-License-Identifier: MIT
15 
16 
17 /**
18  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
19  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
20  * be specified by overriding the virtual {_implementation} function.
21  * 
22  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
23  * different contract through the {_delegate} function.
24  * 
25  * The success and return data of the delegated call will be returned back to the caller of the proxy.
26  */
27 abstract contract Proxy {
28     /**
29      * @dev Delegates the current call to `implementation`.
30      * 
31      * This function does not return to its internall call site, it will return directly to the external caller.
32      */
33     function _delegate(address implementation) internal {
34         // solhint-disable-next-line no-inline-assembly
35         assembly {
36             // Copy msg.data. We take full control of memory in this inline assembly
37             // block because it will not return to Solidity code. We overwrite the
38             // Solidity scratch pad at memory position 0.
39             calldatacopy(0, 0, calldatasize())
40 
41             // Call the implementation.
42             // out and outsize are 0 because we don't know the size yet.
43             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
44 
45             // Copy the returned data.
46             returndatacopy(0, 0, returndatasize())
47 
48             switch result
49             // delegatecall returns 0 on error.
50             case 0 { revert(0, returndatasize()) }
51             default { return(0, returndatasize()) }
52         }
53     }
54 
55     /**
56      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
57      * and {_fallback} should delegate.
58      */
59     function _implementation() internal virtual view returns (address);
60 
61     /**
62      * @dev Delegates the current call to the address returned by `_implementation()`.
63      * 
64      * This function does not return to its internall call site, it will return directly to the external caller.
65      */
66     function _fallback() internal {
67         _beforeFallback();
68         _delegate(_implementation());
69     }
70 
71     /**
72      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
73      * function in the contract matches the call data.
74      */
75     fallback () payable external {
76         _fallback();
77     }
78 
79     /**
80      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
81      * is empty.
82      */
83     receive () payable external {
84         _fallback();
85     }
86 
87     /**
88      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
89      * call, or as part of the Solidity `fallback` or `receive` functions.
90      * 
91      * If overriden should call `super._beforeFallback()`.
92      */
93     function _beforeFallback() internal virtual {
94     }
95 }
96 // SPDX-License-Identifier: MIT
97 
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      */
120     function isContract(address account) internal view returns (bool) {
121         // This method relies in extcodesize, which returns 0 for contracts in
122         // construction, since the code is only stored at the end of the
123         // constructor execution.
124 
125         uint256 size;
126         // solhint-disable-next-line no-inline-assembly
127         assembly { size := extcodesize(account) }
128         return size > 0;
129     }
130 
131     /**
132      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
133      * `recipient`, forwarding all available gas and reverting on errors.
134      *
135      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
136      * of certain opcodes, possibly making contracts go over the 2300 gas limit
137      * imposed by `transfer`, making them unable to receive funds via
138      * `transfer`. {sendValue} removes this limitation.
139      *
140      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
141      *
142      * IMPORTANT: because control is transferred to `recipient`, care must be
143      * taken to not create reentrancy vulnerabilities. Consider using
144      * {ReentrancyGuard} or the
145      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
151         (bool success, ) = recipient.call{ value: amount }("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain`call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174       return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
184         return _functionCallWithValue(target, data, 0, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but also transferring `value` wei to `target`.
190      *
191      * Requirements:
192      *
193      * - the calling contract must have an ETH balance of at least `value`.
194      * - the called Solidity function must be `payable`.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         return _functionCallWithValue(target, data, value, errorMessage);
211     }
212 
213     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
214         require(isContract(target), "Address: call to non-contract");
215 
216         // solhint-disable-next-line avoid-low-level-calls
217         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
218         if (success) {
219             return returndata;
220         } else {
221             // Look for revert reason and bubble it up if present
222             if (returndata.length > 0) {
223                 // The easiest way to bubble the revert reason is using memory via assembly
224 
225                 // solhint-disable-next-line no-inline-assembly
226                 assembly {
227                     let returndata_size := mload(returndata)
228                     revert(add(32, returndata), returndata_size)
229                 }
230             } else {
231                 revert(errorMessage);
232             }
233         }
234     }
235 }
236 
237 /**
238  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
239  * implementation address that can be changed. This address is stored in storage in the location specified by
240  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
241  * implementation behind the proxy.
242  * 
243  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
244  * {TransparentUpgradeableProxy}.
245  */
246 contract UpgradeableProxy is Proxy {
247     /**
248      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
249      * 
250      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
251      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
252      */
253     constructor(address _logic, bytes memory _data) public payable {
254         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
255         _setImplementation(_logic);
256         if(_data.length > 0) {
257             // solhint-disable-next-line avoid-low-level-calls
258             (bool success,) = _logic.delegatecall(_data);
259             require(success);
260         }
261     }
262 
263     /**
264      * @dev Emitted when the implementation is upgraded.
265      */
266     event Upgraded(address indexed implementation);
267 
268     /**
269      * @dev Storage slot with the address of the current implementation.
270      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
271      * validated in the constructor.
272      */
273     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
274 
275     /**
276      * @dev Returns the current implementation address.
277      */
278     function _implementation() internal override view returns (address impl) {
279         bytes32 slot = _IMPLEMENTATION_SLOT;
280         // solhint-disable-next-line no-inline-assembly
281         assembly {
282             impl := sload(slot)
283         }
284     }
285 
286     /**
287      * @dev Upgrades the proxy to a new implementation.
288      * 
289      * Emits an {Upgraded} event.
290      */
291     function _upgradeTo(address newImplementation) internal {
292         _setImplementation(newImplementation);
293         emit Upgraded(newImplementation);
294     }
295 
296     /**
297      * @dev Stores a new address in the EIP1967 implementation slot.
298      */
299     function _setImplementation(address newImplementation) private {
300         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
301 
302         bytes32 slot = _IMPLEMENTATION_SLOT;
303 
304         // solhint-disable-next-line no-inline-assembly
305         assembly {
306             sstore(slot, newImplementation)
307         }
308     }
309 }
310 
311 /**
312  * @dev This contract implements a proxy that is upgradeable by an admin.
313  * 
314  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
315  * clashing], which can potentially be used in an attack, this contract uses the
316  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
317  * things that go hand in hand:
318  * 
319  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
320  * that call matches one of the admin functions exposed by the proxy itself.
321  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
322  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
323  * "admin cannot fallback to proxy target".
324  * 
325  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
326  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
327  * to sudden errors when trying to call a function from the proxy implementation.
328  * 
329  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
330  * you should think of the `ProxyAdmin` instance as the real administrative inerface of your proxy.
331  */
332 contract TransparentUpgradeableProxy is UpgradeableProxy {
333     /**
334      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
335      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
336      */
337     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
338         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
339         _setAdmin(_admin);
340     }
341 
342     /**
343      * @dev Emitted when the admin account has changed.
344      */
345     event AdminChanged(address previousAdmin, address newAdmin);
346 
347     /**
348      * @dev Storage slot with the admin of the contract.
349      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
350      * validated in the constructor.
351      */
352     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
353 
354     /**
355      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
356      */
357     modifier ifAdmin() {
358         if (msg.sender == _admin()) {
359             _;
360         } else {
361             _fallback();
362         }
363     }
364 
365     /**
366      * @dev Returns the current admin.
367      * 
368      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
369      * 
370      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
371      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
372      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
373      */
374     function admin() external ifAdmin returns (address) {
375         return _admin();
376     }
377 
378     /**
379      * @dev Returns the current implementation.
380      * 
381      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
382      * 
383      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
384      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
385      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
386      */
387     function implementation() external ifAdmin returns (address) {
388         return _implementation();
389     }
390 
391     /**
392      * @dev Changes the admin of the proxy.
393      * 
394      * Emits an {AdminChanged} event.
395      * 
396      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
397      */
398     function changeAdmin(address newAdmin) external ifAdmin {
399         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
400         emit AdminChanged(_admin(), newAdmin);
401         _setAdmin(newAdmin);
402     }
403 
404     /**
405      * @dev Upgrade the implementation of the proxy.
406      * 
407      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
408      */
409     function upgradeTo(address newImplementation) external ifAdmin {
410         _upgradeTo(newImplementation);
411     }
412 
413     /**
414      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
415      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
416      * proxied contract.
417      * 
418      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
419      */
420     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
421         _upgradeTo(newImplementation);
422         // solhint-disable-next-line avoid-low-level-calls
423         (bool success,) = newImplementation.delegatecall(data);
424         require(success);
425     }
426 
427     /**
428      * @dev Returns the current admin.
429      */
430     function _admin() internal view returns (address adm) {
431         bytes32 slot = _ADMIN_SLOT;
432         // solhint-disable-next-line no-inline-assembly
433         assembly {
434             adm := sload(slot)
435         }
436     }
437 
438     /**
439      * @dev Stores a new address in the EIP1967 admin slot.
440      */
441     function _setAdmin(address newAdmin) private {
442         bytes32 slot = _ADMIN_SLOT;
443 
444         // solhint-disable-next-line no-inline-assembly
445         assembly {
446             sstore(slot, newAdmin)
447         }
448     }
449 
450     /**
451      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
452      */
453     function _beforeFallback() internal override virtual {
454         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
455         super._beforeFallback();
456     }
457 }
458 
459 contract HProxy is TransparentUpgradeableProxy {
460     
461     /***************************************************************************************
462      * An encoded function call can optionally be passed as _data. 
463      * For example, the implementation contract init() functions can be called to 
464      * initialized the HodlDex and TokenReserve in a constructor-like way.
465      * 
466      * HodlDex: function init(ITokenReserve _tokenReserve, IERC20 _token, IOracle _oracle)
467      * TokenReserve: function init(address dexContract)
468      ***************************************************************************************/
469     
470     constructor(address _logic, address _admin, bytes memory _data) 
471         TransparentUpgradeableProxy(_logic, _admin, _data)
472         internal 
473         payable 
474     {
475         
476     }
477 }
478 
479 contract HodlDexProxy is HProxy {
480 
481     constructor(address _logic, address _admin, bytes memory _data)
482         HProxy (_logic, _admin, _data) public 
483     {}
484 }