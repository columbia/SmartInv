1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Address.sol
3 pragma solidity ^0.6.2;
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      */
25     function isContract(address account) internal view returns (bool) {
26         // This method relies in extcodesize, which returns 0 for contracts in
27         // construction, since the code is only stored at the end of the
28         // constructor execution.
29         uint256 size;
30         // solhint-disable-next-line no-inline-assembly
31         assembly { size := extcodesize(account) }
32         return size > 0;
33     }
34     /**
35      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
36      * `recipient`, forwarding all available gas and reverting on errors.
37      *
38      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
39      * of certain opcodes, possibly making contracts go over the 2300 gas limit
40      * imposed by `transfer`, making them unable to receive funds via
41      * `transfer`. {sendValue} removes this limitation.
42      *
43      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
44      *
45      * IMPORTANT: because control is transferred to `recipient`, care must be
46      * taken to not create reentrancy vulnerabilities. Consider using
47      * {ReentrancyGuard} or the
48      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
49      */
50     function sendValue(address payable recipient, uint256 amount) internal {
51         require(address(this).balance >= amount, "Address: insufficient balance");
52         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
53         (bool success, ) = recipient.call{ value: amount }("");
54         require(success, "Address: unable to send value, recipient may have reverted");
55     }
56     /**
57      * @dev Performs a Solidity function call using a low level `call`. A
58      * plain`call` is an unsafe replacement for a function call: use this
59      * function instead.
60      *
61      * If `target` reverts with a revert reason, it is bubbled up by this
62      * function (like regular Solidity function calls).
63      *
64      * Returns the raw returned data. To convert to the expected return value,
65      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
66      *
67      * Requirements:
68      *
69      * - `target` must be a contract.
70      * - calling `target` with `data` must not revert.
71      *
72      * _Available since v3.1._
73      */
74     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
75       return functionCall(target, data, "Address: low-level call failed");
76     }
77     /**
78      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
79      * `errorMessage` as a fallback revert reason when `target` reverts.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
84         return _functionCallWithValue(target, data, 0, errorMessage);
85     }
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
88      * but also transferring `value` wei to `target`.
89      *
90      * Requirements:
91      *
92      * - the calling contract must have an ETH balance of at least `value`.
93      * - the called Solidity function must be `payable`.
94      *
95      * _Available since v3.1._
96      */
97     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
99     }
100     /**
101      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
102      * with `errorMessage` as a fallback revert reason when `target` reverts.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
107         require(address(this).balance >= value, "Address: insufficient balance for call");
108         return _functionCallWithValue(target, data, value, errorMessage);
109     }
110     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
111         require(isContract(target), "Address: call to non-contract");
112         // solhint-disable-next-line avoid-low-level-calls
113         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
114         if (success) {
115             return returndata;
116         } else {
117             // Look for revert reason and bubble it up if present
118             if (returndata.length > 0) {
119                 // The easiest way to bubble the revert reason is using memory via assembly
120                 // solhint-disable-next-line no-inline-assembly
121                 assembly {
122                     let returndata_size := mload(returndata)
123                     revert(add(32, returndata), returndata_size)
124                 }
125             } else {
126                 revert(errorMessage);
127             }
128         }
129     }
130 }
131 // File: contracts/upgrade_proxy/Proxy.sol
132 pragma solidity ^0.6.0;
133 /**
134  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
135  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
136  * be specified by overriding the virtual {_implementation} function.
137  * 
138  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
139  * different contract through the {_delegate} function.
140  * 
141  * The success and return data of the delegated call will be returned back to the caller of the proxy.
142  */
143 abstract contract Proxy {
144     /**
145      * @dev Delegates the current call to `implementation`.
146      * 
147      * This function does not return to its internall call site, it will return directly to the external caller.
148      */
149     function _delegate(address implementation) internal {
150         // solhint-disable-next-line no-inline-assembly
151         assembly {
152             // Copy msg.data. We take full control of memory in this inline assembly
153             // block because it will not return to Solidity code. We overwrite the
154             // Solidity scratch pad at memory position 0.
155             calldatacopy(0, 0, calldatasize())
156             // Call the implementation.
157             // out and outsize are 0 because we don't know the size yet.
158             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
159             // Copy the returned data.
160             returndatacopy(0, 0, returndatasize())
161             switch result
162             // delegatecall returns 0 on error.
163             case 0 { revert(0, returndatasize()) }
164             default { return(0, returndatasize()) }
165         }
166     }
167     /**
168      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
169      * and {_fallback} should delegate.
170      */
171     function _implementation() internal virtual view returns (address);
172     /**
173      * @dev Delegates the current call to the address returned by `_implementation()`.
174      * 
175      * This function does not return to its internall call site, it will return directly to the external caller.
176      */
177     function _fallback() internal {
178         _beforeFallback();
179         _delegate(_implementation());
180     }
181     /**
182      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
183      * function in the contract matches the call data.
184      */
185     fallback () payable external {
186         _fallback();
187     }
188     /**
189      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
190      * is empty.
191      */
192     receive () payable external {
193         _fallback();
194     }
195     /**
196      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
197      * call, or as part of the Solidity `fallback` or `receive` functions.
198      * 
199      * If overriden should call `super._beforeFallback()`.
200      */
201     function _beforeFallback() internal virtual {
202     }
203 }
204 // File: contracts/upgrade_proxy/UpgradeableProxy.sol
205 pragma solidity ^0.6.0;
206 /**
207  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
208  * implementation address that can be changed. This address is stored in storage in the location specified by
209  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
210  * implementation behind the proxy.
211  * 
212  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
213  * {TransparentUpgradeableProxy}.
214  */
215 contract UpgradeableProxy is Proxy {
216     /**
217      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
218      * 
219      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
220      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
221      */
222     constructor(address _logic, bytes memory _data) public payable {
223         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
224         _setImplementation(_logic);
225         if(_data.length > 0) {
226             // solhint-disable-next-line avoid-low-level-calls
227             (bool success,) = _logic.delegatecall(_data);
228             require(success);
229         }
230     }
231     /**
232      * @dev Emitted when the implementation is upgraded.
233      */
234     event Upgraded(address indexed implementation);
235     /**
236      * @dev Storage slot with the address of the current implementation.
237      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
238      * validated in the constructor.
239      */
240     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
241     /**
242      * @dev Returns the current implementation address.
243      */
244     function _implementation() internal override view returns (address impl) {
245         bytes32 slot = _IMPLEMENTATION_SLOT;
246         // solhint-disable-next-line no-inline-assembly
247         assembly {
248             impl := sload(slot)
249         }
250     }
251     /**
252      * @dev Upgrades the proxy to a new implementation.
253      * 
254      * Emits an {Upgraded} event.
255      */
256     function _upgradeTo(address newImplementation) internal {
257         _setImplementation(newImplementation);
258         emit Upgraded(newImplementation);
259     }
260     /**
261      * @dev Stores a new address in the EIP1967 implementation slot.
262      */
263     function _setImplementation(address newImplementation) private {
264         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
265         bytes32 slot = _IMPLEMENTATION_SLOT;
266         // solhint-disable-next-line no-inline-assembly
267         assembly {
268             sstore(slot, newImplementation)
269         }
270     }
271 }
272 // File: contracts/upgrade_proxy/TransparentUpgradeableProxy.sol
273 pragma solidity ^0.6.0;
274 /**
275  * @dev This contract implements a proxy that is upgradeable by an admin.
276  * 
277  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
278  * clashing], which can potentially be used in an attack, this contract uses the
279  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
280  * things that go hand in hand:
281  * 
282  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
283  * that call matches one of the admin functions exposed by the proxy itself.
284  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
285  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
286  * "admin cannot fallback to proxy target".
287  * 
288  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
289  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
290  * to sudden errors when trying to call a function from the proxy implementation.
291  * 
292  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
293  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
294  */
295 contract TransparentUpgradeableProxy is UpgradeableProxy {
296     /**
297      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
298      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
299      */
300     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
301         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
302         _setAdmin(_admin);
303     }
304     /**
305      * @dev Emitted when the admin account has changed.
306      */
307     event AdminChanged(address previousAdmin, address newAdmin);
308     /**
309      * @dev Storage slot with the admin of the contract.
310      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
311      * validated in the constructor.
312      */
313     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
314     /**
315      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
316      */
317     modifier ifAdmin() {
318         if (msg.sender == _admin()) {
319             _;
320         } else {
321             _fallback();
322         }
323     }
324     /**
325      * @dev Returns the current admin.
326      * 
327      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
328      * 
329      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
330      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
331      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
332      */
333     function admin() external ifAdmin returns (address) {
334         return _admin();
335     }
336     /**
337      * @dev Returns the current implementation.
338      * 
339      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
340      * 
341      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
342      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
343      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
344      */
345     function implementation() external ifAdmin returns (address) {
346         return _implementation();
347     }
348     /**
349      * @dev Changes the admin of the proxy.
350      * 
351      * Emits an {AdminChanged} event.
352      * 
353      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
354      */
355     function changeAdmin(address newAdmin) external ifAdmin {
356         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
357         emit AdminChanged(_admin(), newAdmin);
358         _setAdmin(newAdmin);
359     }
360     /**
361      * @dev Upgrade the implementation of the proxy.
362      * 
363      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
364      */
365     function upgradeTo(address newImplementation) external ifAdmin {
366         _upgradeTo(newImplementation);
367     }
368     /**
369      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
370      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
371      * proxied contract.
372      * 
373      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
374      */
375     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
376         _upgradeTo(newImplementation);
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success,) = newImplementation.delegatecall(data);
379         require(success);
380     }
381     /**
382      * @dev Returns the current admin.
383      */
384     function _admin() internal view returns (address adm) {
385         bytes32 slot = _ADMIN_SLOT;
386         // solhint-disable-next-line no-inline-assembly
387         assembly {
388             adm := sload(slot)
389         }
390     }
391     /**
392      * @dev Stores a new address in the EIP1967 admin slot.
393      */
394     function _setAdmin(address newAdmin) private {
395         bytes32 slot = _ADMIN_SLOT;
396         // solhint-disable-next-line no-inline-assembly
397         assembly {
398             sstore(slot, newAdmin)
399         }
400     }
401     /**
402      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
403      */
404     function _beforeFallback() internal override virtual {
405         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
406         super._beforeFallback();
407     }
408 }
409 // File: contracts/Tokenlon.sol
410 pragma solidity ^0.6.0;
411 contract Tokenlon is TransparentUpgradeableProxy {
412     constructor(address _logic, address _admin, bytes memory _data) public payable TransparentUpgradeableProxy(_logic, _admin, _data) {}
413 }