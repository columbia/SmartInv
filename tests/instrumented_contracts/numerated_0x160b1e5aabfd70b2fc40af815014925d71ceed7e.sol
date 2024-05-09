1 pragma solidity ^0.6.2;
2 
3 /**
4  * @dev Collection of functions related to the address type
5  */
6 library Address {
7     /**
8      * @dev Returns true if `account` is a contract.
9      *
10      * [IMPORTANT]
11      * ====
12      * It is unsafe to assume that an address for which this function returns
13      * false is an externally-owned account (EOA) and not a contract.
14      *
15      * Among others, `isContract` will return false for the following
16      * types of addresses:
17      *
18      *  - an externally-owned account
19      *  - a contract in construction
20      *  - an address where a contract will be created
21      *  - an address where a contract lived, but was destroyed
22      * ====
23      */
24     function isContract(address account) internal view returns (bool) {
25         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
26         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
27         // for accounts without code, i.e. `keccak256('')`
28         bytes32 codehash;
29         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
30         // solhint-disable-next-line no-inline-assembly
31         assembly { codehash := extcodehash(account) }
32         return (codehash != accountHash && codehash != 0x0);
33     }
34 
35     /**
36      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
37      * `recipient`, forwarding all available gas and reverting on errors.
38      *
39      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
40      * of certain opcodes, possibly making contracts go over the 2300 gas limit
41      * imposed by `transfer`, making them unable to receive funds via
42      * `transfer`. {sendValue} removes this limitation.
43      *
44      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
45      *
46      * IMPORTANT: because control is transferred to `recipient`, care must be
47      * taken to not create reentrancy vulnerabilities. Consider using
48      * {ReentrancyGuard} or the
49      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
50      */
51     function sendValue(address payable recipient, uint256 amount) internal {
52         require(address(this).balance >= amount, "Address: insufficient balance");
53 
54         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
55         (bool success, ) = recipient.call{ value: amount }("");
56         require(success, "Address: unable to send value, recipient may have reverted");
57     }
58 
59     /**
60      * @dev Performs a Solidity function call using a low level `call`. A
61      * plain`call` is an unsafe replacement for a function call: use this
62      * function instead.
63      *
64      * If `target` reverts with a revert reason, it is bubbled up by this
65      * function (like regular Solidity function calls).
66      *
67      * Returns the raw returned data. To convert to the expected return value,
68      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
69      *
70      * Requirements:
71      *
72      * - `target` must be a contract.
73      * - calling `target` with `data` must not revert.
74      *
75      * _Available since v3.1._
76      */
77     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
78       return functionCall(target, data, "Address: low-level call failed");
79     }
80 
81     /**
82      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
83      * `errorMessage` as a fallback revert reason when `target` reverts.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
88         return _functionCallWithValue(target, data, 0, errorMessage);
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
93      * but also transferring `value` wei to `target`.
94      *
95      * Requirements:
96      *
97      * - the calling contract must have an ETH balance of at least `value`.
98      * - the called Solidity function must be `payable`.
99      *
100      * _Available since v3.1._
101      */
102     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
108      * with `errorMessage` as a fallback revert reason when `target` reverts.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
113         require(address(this).balance >= value, "Address: insufficient balance for call");
114         return _functionCallWithValue(target, data, value, errorMessage);
115     }
116 
117     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
122         if (success) {
123             return returndata;
124         } else {
125             // Look for revert reason and bubble it up if present
126             if (returndata.length > 0) {
127                 // The easiest way to bubble the revert reason is using memory via assembly
128 
129                 // solhint-disable-next-line no-inline-assembly
130                 assembly {
131                     let returndata_size := mload(returndata)
132                     revert(add(32, returndata), returndata_size)
133                 }
134             } else {
135                 revert(errorMessage);
136             }
137         }
138     }
139 }
140 
141 pragma solidity ^0.6.0;
142 
143 /**
144  * @title Proxy
145  * @dev Implements delegation of calls to other contracts, with proper
146  * forwarding of return values and bubbling of failures.
147  * It defines a fallback function that delegates all calls to the address
148  * returned by the abstract _implementation() internal function.
149  */
150 abstract contract Proxy {
151   /**
152    * @dev Fallback function.
153    * Implemented entirely in `_fallback`.
154    */
155   fallback () payable external {
156     _fallback();
157   }
158 
159   /**
160    * @dev Receive function.
161    * Implemented entirely in `_fallback`.
162    */
163   receive () payable external {
164     _fallback();
165   }
166 
167   /**
168    * @return The Address of the implementation.
169    */
170   function _implementation() internal virtual view returns (address);
171 
172   /**
173    * @dev Delegates execution to an implementation contract.
174    * This is a low level function that doesn't return to its internal call site.
175    * It will return to the external caller whatever the implementation returns.
176    * @param implementation Address to delegate.
177    */
178   function _delegate(address implementation) internal {
179     assembly {
180       // Copy msg.data. We take full control of memory in this inline assembly
181       // block because it will not return to Solidity code. We overwrite the
182       // Solidity scratch pad at memory position 0.
183       calldatacopy(0, 0, calldatasize())
184 
185       // Call the implementation.
186       // out and outsize are 0 because we don't know the size yet.
187       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
188 
189       // Copy the returned data.
190       returndatacopy(0, 0, returndatasize())
191 
192       switch result
193       // delegatecall returns 0 on error.
194       case 0 { revert(0, returndatasize()) }
195       default { return(0, returndatasize()) }
196     }
197   }
198 
199   /**
200    * @dev Function that is run as the first thing in the fallback function.
201    * Can be redefined in derived contracts to add functionality.
202    * Redefinitions must call super._willFallback().
203    */
204   function _willFallback() internal virtual {
205   }
206 
207   /**
208    * @dev fallback implementation.
209    * Extracted to enable manual triggering.
210    */
211   function _fallback() internal {
212     _willFallback();
213     _delegate(_implementation());
214   }
215 }
216 
217 pragma solidity ^0.6.0;
218 
219 /**
220  * @title UpgradeabilityProxy
221  * @dev This contract implements a proxy that allows to change the
222  * implementation address to which it will delegate.
223  * Such a change is called an implementation upgrade.
224  */
225 contract UpgradeabilityProxy is Proxy {
226   /**
227    * @dev Contract constructor.
228    * @param _logic Address of the initial implementation.
229    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
230    * It should include the signature and the parameters of the function to be called, as described in
231    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
232    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
233    */
234   constructor(address _logic, bytes memory _data) public payable {
235     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
236     _setImplementation(_logic);
237     if(_data.length > 0) {
238       (bool success,) = _logic.delegatecall(_data);
239       require(success);
240     }
241   }  
242 
243   /**
244    * @dev Emitted when the implementation is upgraded.
245    * @param implementation Address of the new implementation.
246    */
247   event Upgraded(address indexed implementation);
248 
249   /**
250    * @dev Storage slot with the address of the current implementation.
251    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
252    * validated in the constructor.
253    */
254   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
255 
256   /**
257    * @dev Returns the current implementation.
258    * @return impl Address of the current implementation
259    */
260   function _implementation() internal override view returns (address impl) {
261     bytes32 slot = IMPLEMENTATION_SLOT;
262     assembly {
263       impl := sload(slot)
264     }
265   }
266 
267   /**
268    * @dev Upgrades the proxy to a new implementation.
269    * @param newImplementation Address of the new implementation.
270    */
271   function _upgradeTo(address newImplementation) internal {
272     _setImplementation(newImplementation);
273     emit Upgraded(newImplementation);
274   }
275 
276   /**
277    * @dev Sets the implementation address of the proxy.
278    * @param newImplementation Address of the new implementation.
279    */
280   function _setImplementation(address newImplementation) internal {
281     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
282 
283     bytes32 slot = IMPLEMENTATION_SLOT;
284 
285     assembly {
286       sstore(slot, newImplementation)
287     }
288   }
289 }
290 
291 pragma solidity ^0.6.0;
292 
293 /**
294  * @title AdminUpgradeabilityProxy
295  * @dev This contract combines an upgradeability proxy with an authorization
296  * mechanism for administrative tasks.
297  * All external functions in this contract must be guarded by the
298  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
299  * feature proposal that would enable this to be done automatically.
300  */
301 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
302   /**
303    * Contract constructor.
304    * @param _logic address of the initial implementation.
305    * @param _admin Address of the proxy administrator.
306    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
307    * It should include the signature and the parameters of the function to be called, as described in
308    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
309    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
310    */
311   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
312     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
313     _setAdmin(_admin);
314   }
315 
316   /**
317    * @dev Emitted when the administration has been transferred.
318    * @param previousAdmin Address of the previous admin.
319    * @param newAdmin Address of the new admin.
320    */
321   event AdminChanged(address previousAdmin, address newAdmin);
322 
323   /**
324    * @dev Storage slot with the admin of the contract.
325    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
326    * validated in the constructor.
327    */
328 
329   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
330 
331   /**
332    * @dev Modifier to check whether the `msg.sender` is the admin.
333    * If it is, it will run the function. Otherwise, it will delegate the call
334    * to the implementation.
335    */
336   modifier ifAdmin() {
337     if (msg.sender == _admin()) {
338       _;
339     } else {
340       _fallback();
341     }
342   }
343 
344   /**
345    * @return The address of the proxy admin.
346    */
347   function admin() external ifAdmin returns (address) {
348     return _admin();
349   }
350 
351   /**
352    * @return The address of the implementation.
353    */
354   function implementation() external ifAdmin returns (address) {
355     return _implementation();
356   }
357 
358   /**
359    * @dev Changes the admin of the proxy.
360    * Only the current admin can call this function.
361    * @param newAdmin Address to transfer proxy administration to.
362    */
363   function changeAdmin(address newAdmin) external ifAdmin {
364     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
365     emit AdminChanged(_admin(), newAdmin);
366     _setAdmin(newAdmin);
367   }
368 
369   /**
370    * @dev Upgrade the backing implementation of the proxy.
371    * Only the admin can call this function.
372    * @param newImplementation Address of the new implementation.
373    */
374   function upgradeTo(address newImplementation) external ifAdmin {
375     _upgradeTo(newImplementation);
376   }
377 
378   /**
379    * @dev Upgrade the backing implementation of the proxy and call a function
380    * on the new implementation.
381    * This is useful to initialize the proxied contract.
382    * @param newImplementation Address of the new implementation.
383    * @param data Data to send as msg.data in the low level call.
384    * It should include the signature and the parameters of the function to be called, as described in
385    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
386    */
387   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
388     _upgradeTo(newImplementation);
389     (bool success,) = newImplementation.delegatecall(data);
390     require(success);
391   }
392 
393   /**
394    * @return adm The admin slot.
395    */
396   function _admin() internal view returns (address adm) {
397     bytes32 slot = ADMIN_SLOT;
398     assembly {
399       adm := sload(slot)
400     }
401   }
402 
403   /**
404    * @dev Sets the address of the proxy admin.
405    * @param newAdmin Address of the new proxy admin.
406    */
407   function _setAdmin(address newAdmin) internal {
408     bytes32 slot = ADMIN_SLOT;
409 
410     assembly {
411       sstore(slot, newAdmin)
412     }
413   }
414 
415   /**
416    * @dev Only fall back when the sender is not the admin.
417    */
418   function _willFallback() internal override virtual {
419     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
420     super._willFallback();
421   }
422 }