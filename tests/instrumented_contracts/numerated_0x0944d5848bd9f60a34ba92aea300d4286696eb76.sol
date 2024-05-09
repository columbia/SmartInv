1 pragma solidity ^0.6.0;
2 
3 library Address {
4     /**
5      * @dev Returns true if `account` is a contract.
6      *
7      * [IMPORTANT]
8      * ====
9      * It is unsafe to assume that an address for which this function returns
10      * false is an externally-owned account (EOA) and not a contract.
11      *
12      * Among others, `isContract` will return false for the following
13      * types of addresses:
14      *
15      *  - an externally-owned account
16      *  - a contract in construction
17      *  - an address where a contract will be created
18      *  - an address where a contract lived, but was destroyed
19      * ====
20      */
21     function isContract(address account) internal view returns (bool) {
22         // This method relies in extcodesize, which returns 0 for contracts in
23         // construction, since the code is only stored at the end of the
24         // constructor execution.
25 
26         uint256 size;
27         // solhint-disable-next-line no-inline-assembly
28         assembly { size := extcodesize(account) }
29         return size > 0;
30     }
31 
32     /**
33      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
34      * `recipient`, forwarding all available gas and reverting on errors.
35      *
36      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
37      * of certain opcodes, possibly making contracts go over the 2300 gas limit
38      * imposed by `transfer`, making them unable to receive funds via
39      * `transfer`. {sendValue} removes this limitation.
40      *
41      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
42      *
43      * IMPORTANT: because control is transferred to `recipient`, care must be
44      * taken to not create reentrancy vulnerabilities. Consider using
45      * {ReentrancyGuard} or the
46      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
47      */
48     function sendValue(address payable recipient, uint256 amount) internal {
49         require(address(this).balance >= amount, "Address: insufficient balance");
50 
51         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
52         (bool success, ) = recipient.call{ value: amount }("");
53         require(success, "Address: unable to send value, recipient may have reverted");
54     }
55 
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
77 
78     /**
79      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
80      * `errorMessage` as a fallback revert reason when `target` reverts.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
85         return _functionCallWithValue(target, data, 0, errorMessage);
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
90      * but also transferring `value` wei to `target`.
91      *
92      * Requirements:
93      *
94      * - the calling contract must have an ETH balance of at least `value`.
95      * - the called Solidity function must be `payable`.
96      *
97      * _Available since v3.1._
98      */
99     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
105      * with `errorMessage` as a fallback revert reason when `target` reverts.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
110         require(address(this).balance >= value, "Address: insufficient balance for call");
111         return _functionCallWithValue(target, data, value, errorMessage);
112     }
113 
114     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
115         require(isContract(target), "Address: call to non-contract");
116 
117         // solhint-disable-next-line avoid-low-level-calls
118         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
119         if (success) {
120             return returndata;
121         } else {
122             // Look for revert reason and bubble it up if present
123             if (returndata.length > 0) {
124                 // The easiest way to bubble the revert reason is using memory via assembly
125 
126                 // solhint-disable-next-line no-inline-assembly
127                 assembly {
128                     let returndata_size := mload(returndata)
129                     revert(add(32, returndata), returndata_size)
130                 }
131             } else {
132                 revert(errorMessage);
133             }
134         }
135     }
136 }
137 
138 abstract contract Proxy {
139     /**
140      * @dev Delegates the current call to `implementation`.
141      * 
142      * This function does not return to its internall call site, it will return directly to the external caller.
143      */
144     function _delegate(address implementation) internal {
145         // solhint-disable-next-line no-inline-assembly
146         assembly {
147             // Copy msg.data. We take full control of memory in this inline assembly
148             // block because it will not return to Solidity code. We overwrite the
149             // Solidity scratch pad at memory position 0.
150             calldatacopy(0, 0, calldatasize())
151 
152             // Call the implementation.
153             // out and outsize are 0 because we don't know the size yet.
154             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
155 
156             // Copy the returned data.
157             returndatacopy(0, 0, returndatasize())
158 
159             switch result
160             // delegatecall returns 0 on error.
161             case 0 { revert(0, returndatasize()) }
162             default { return(0, returndatasize()) }
163         }
164     }
165 
166     /**
167      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
168      * and {_fallback} should delegate.
169      */
170     function _implementation() internal virtual view returns (address);
171 
172     /**
173      * @dev Delegates the current call to the address returned by `_implementation()`.
174      * 
175      * This function does not return to its internall call site, it will return directly to the external caller.
176      */
177     function _fallback() internal {
178         _beforeFallback();
179         _delegate(_implementation());
180     }
181 
182     /**
183      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
184      * function in the contract matches the call data.
185      */
186     fallback () payable external {
187         _fallback();
188     }
189 
190     /**
191      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
192      * is empty.
193      */
194     receive () payable external {
195         _fallback();
196     }
197 
198     /**
199      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
200      * call, or as part of the Solidity `fallback` or `receive` functions.
201      * 
202      * If overriden should call `super._beforeFallback()`.
203      */
204     function _beforeFallback() internal virtual {
205     }
206 }
207 
208 contract UpgradeableProxy is Proxy {
209     /**
210      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
211      * 
212      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
213      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
214      */
215     constructor(address _logic, bytes memory _data) public payable {
216         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
217         _setImplementation(_logic);
218         if(_data.length > 0) {
219             // solhint-disable-next-line avoid-low-level-calls
220             (bool success,) = _logic.delegatecall(_data);
221             require(success);
222         }
223     }
224 
225     /**
226      * @dev Emitted when the implementation is upgraded.
227      */
228     event Upgraded(address indexed implementation);
229 
230     /**
231      * @dev Storage slot with the address of the current implementation.
232      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
233      * validated in the constructor.
234      */
235     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
236 
237     /**
238      * @dev Returns the current implementation address.
239      */
240     function _implementation() internal override view returns (address impl) {
241         bytes32 slot = _IMPLEMENTATION_SLOT;
242         // solhint-disable-next-line no-inline-assembly
243         assembly {
244             impl := sload(slot)
245         }
246     }
247 
248     /**
249      * @dev Upgrades the proxy to a new implementation.
250      * 
251      * Emits an {Upgraded} event.
252      */
253     function _upgradeTo(address newImplementation) internal {
254         _setImplementation(newImplementation);
255         emit Upgraded(newImplementation);
256     }
257 
258     /**
259      * @dev Stores a new address in the EIP1967 implementation slot.
260      */
261     function _setImplementation(address newImplementation) private {
262         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
263 
264         bytes32 slot = _IMPLEMENTATION_SLOT;
265 
266         // solhint-disable-next-line no-inline-assembly
267         assembly {
268             sstore(slot, newImplementation)
269         }
270     }
271 }
272 
273 contract TransparentUpgradeableProxy is UpgradeableProxy {
274     /**
275      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
276      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
277      */
278     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
279         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
280         _setAdmin(_admin);
281     }
282 
283     /**
284      * @dev Emitted when the admin account has changed.
285      */
286     event AdminChanged(address previousAdmin, address newAdmin);
287 
288     /**
289      * @dev Storage slot with the admin of the contract.
290      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
291      * validated in the constructor.
292      */
293     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
294 
295     /**
296      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
297      */
298     modifier ifAdmin() {
299         if (msg.sender == _admin()) {
300             _;
301         } else {
302             _fallback();
303         }
304     }
305 
306     /**
307      * @dev Returns the current admin.
308      * 
309      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
310      * 
311      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
312      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
313      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
314      */
315     function admin() external ifAdmin returns (address) {
316         return _admin();
317     }
318 
319     /**
320      * @dev Returns the current implementation.
321      * 
322      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
323      * 
324      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
325      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
326      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
327      */
328     function implementation() external ifAdmin returns (address) {
329         return _implementation();
330     }
331 
332     /**
333      * @dev Changes the admin of the proxy.
334      * 
335      * Emits an {AdminChanged} event.
336      * 
337      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
338      */
339     function changeAdmin(address newAdmin) external ifAdmin {
340         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
341         emit AdminChanged(_admin(), newAdmin);
342         _setAdmin(newAdmin);
343     }
344 
345     /**
346      * @dev Upgrade the implementation of the proxy.
347      * 
348      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
349      */
350     function upgradeTo(address newImplementation) external ifAdmin {
351         _upgradeTo(newImplementation);
352     }
353 
354     /**
355      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
356      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
357      * proxied contract.
358      * 
359      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
360      */
361     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
362         _upgradeTo(newImplementation);
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success,) = newImplementation.delegatecall(data);
365         require(success);
366     }
367 
368     /**
369      * @dev Returns the current admin.
370      */
371     function _admin() internal view returns (address adm) {
372         bytes32 slot = _ADMIN_SLOT;
373         // solhint-disable-next-line no-inline-assembly
374         assembly {
375             adm := sload(slot)
376         }
377     }
378 
379     /**
380      * @dev Stores a new address in the EIP1967 admin slot.
381      */
382     function _setAdmin(address newAdmin) private {
383         bytes32 slot = _ADMIN_SLOT;
384 
385         // solhint-disable-next-line no-inline-assembly
386         assembly {
387             sstore(slot, newAdmin)
388         }
389     }
390 
391     /**
392      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
393      */
394     function _beforeFallback() internal override virtual {
395         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
396         super._beforeFallback();
397     }
398 }