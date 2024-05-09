1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 abstract contract Proxy {
13     /**
14      * @dev Fallback function.
15      * Implemented entirely in `_fallback`.
16      */
17     fallback() external payable {
18         _fallback();
19     }
20 
21     /**
22      * @dev Receive function.
23      * Implemented entirely in `_fallback`.
24      */
25     receive() external payable {
26         _fallback();
27     }
28 
29     /**
30      * @return The Address of the implementation.
31      */
32     function _implementation() internal view virtual returns (address);
33 
34     /**
35      * @dev Delegates execution to an implementation contract.
36      * This is a low level function that doesn't return to its internal call site.
37      * It will return to the external caller whatever the implementation returns.
38      * @param implementation Address to delegate.
39      */
40     function _delegate(address implementation) internal {
41         assembly {
42             // Copy msg.data. We take full control of memory in this inline assembly
43             // block because it will not return to Solidity code. We overwrite the
44             // Solidity scratch pad at memory position 0.
45             calldatacopy(0, 0, calldatasize())
46 
47             // Call the implementation.
48             // out and outsize are 0 because we don't know the size yet.
49             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
50 
51             // Copy the returned data.
52             returndatacopy(0, 0, returndatasize())
53 
54             switch result
55                 // delegatecall returns 0 on error.
56                 case 0 {
57                     revert(0, returndatasize())
58                 }
59                 default {
60                     return(0, returndatasize())
61                 }
62         }
63     }
64 
65     /**
66      * @dev Function that is run as the first thing in the fallback function.
67      * Can be redefined in derived contracts to add functionality.
68      * Redefinitions must call super._willFallback().
69      */
70     function _willFallback() internal virtual {}
71 
72     /**
73      * @dev fallback implementation.
74      * Extracted to enable manual triggering.
75      */
76     function _fallback() internal {
77         _willFallback();
78         _delegate(_implementation());
79     }
80 }
81 
82 /**
83  * @dev Collection of functions related to the address type
84  */
85 library Address {
86     /**
87      * @dev Returns true if `account` is a contract.
88      *
89      * [IMPORTANT]
90      * ====
91      * It is unsafe to assume that an address for which this function returns
92      * false is an externally-owned account (EOA) and not a contract.
93      *
94      * Among others, `isContract` will return false for the following
95      * types of addresses:
96      *
97      *  - an externally-owned account
98      *  - a contract in construction
99      *  - an address where a contract will be created
100      *  - an address where a contract lived, but was destroyed
101      * ====
102      */
103     function isContract(address account) internal view returns (bool) {
104         // This method relies in extcodesize, which returns 0 for contracts in
105         // construction, since the code is only stored at the end of the
106         // constructor execution.
107 
108         uint256 size;
109         // solhint-disable-next-line no-inline-assembly
110         assembly {
111             size := extcodesize(account)
112         }
113         return size > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
136         (bool success, ) = recipient.call{value: amount}("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain`call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return _functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
197      * with `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         return _functionCallWithValue(target, data, value, errorMessage);
209     }
210 
211     function _functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 weiValue,
215         string memory errorMessage
216     ) private returns (bytes memory) {
217         require(isContract(target), "Address: call to non-contract");
218 
219         // solhint-disable-next-line avoid-low-level-calls
220         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
221         if (success) {
222             return returndata;
223         } else {
224             // Look for revert reason and bubble it up if present
225             if (returndata.length > 0) {
226                 // The easiest way to bubble the revert reason is using memory via assembly
227 
228                 // solhint-disable-next-line no-inline-assembly
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 /**
241  * @title UpgradeabilityProxy
242  * @dev This contract implements a proxy that allows to change the
243  * implementation address to which it will delegate.
244  * Such a change is called an implementation upgrade.
245  */
246 contract UpgradeabilityProxy is Proxy {
247     /**
248      * @dev Contract constructor.
249      * @param _logic Address of the initial implementation.
250      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
251      * It should include the signature and the parameters of the function to be called, as described in
252      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
253      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
254      */
255     constructor(address _logic, bytes memory _data) public payable {
256         assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
257         _setImplementation(_logic);
258         if (_data.length > 0) {
259             (bool success, ) = _logic.delegatecall(_data);
260             require(success);
261         }
262     }
263 
264     /**
265      * @dev Emitted when the implementation is upgraded.
266      * @param implementation Address of the new implementation.
267      */
268     event Upgraded(address indexed implementation);
269 
270     /**
271      * @dev Storage slot with the address of the current implementation.
272      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
273      * validated in the constructor.
274      */
275     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
276 
277     /**
278      * @dev Returns the current implementation.
279      * @return impl Address of the current implementation
280      */
281     function _implementation() internal view override returns (address impl) {
282         bytes32 slot = IMPLEMENTATION_SLOT;
283         assembly {
284             impl := sload(slot)
285         }
286     }
287 
288     /**
289      * @dev Upgrades the proxy to a new implementation.
290      * @param newImplementation Address of the new implementation.
291      */
292     function _upgradeTo(address newImplementation) internal {
293         _setImplementation(newImplementation);
294         emit Upgraded(newImplementation);
295     }
296 
297     /**
298      * @dev Sets the implementation address of the proxy.
299      * @param newImplementation Address of the new implementation.
300      */
301     function _setImplementation(address newImplementation) internal {
302         require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
303 
304         bytes32 slot = IMPLEMENTATION_SLOT;
305 
306         assembly {
307             sstore(slot, newImplementation)
308         }
309     }
310 }
311 
312 /**
313  * @title AdminUpgradeabilityProxy
314  * @dev This contract combines an upgradeability proxy with an authorization
315  * mechanism for administrative tasks.
316  * All external functions in this contract must be guarded by the
317  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
318  * feature proposal that would enable this to be done automatically.
319  */
320 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
321     /**
322      * Contract constructor.
323      * @param _logic address of the initial implementation.
324      * @param _admin Address of the proxy administrator.
325      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
326      * It should include the signature and the parameters of the function to be called, as described in
327      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
328      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
329      */
330     constructor(
331         address _logic,
332         address _admin,
333         bytes memory _data
334     ) public payable UpgradeabilityProxy(_logic, _data) {
335         assert(ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
336         _setAdmin(_admin);
337     }
338 
339     /**
340      * @dev Emitted when the administration has been transferred.
341      * @param previousAdmin Address of the previous admin.
342      * @param newAdmin Address of the new admin.
343      */
344     event AdminChanged(address previousAdmin, address newAdmin);
345 
346     /**
347      * @dev Storage slot with the admin of the contract.
348      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
349      * validated in the constructor.
350      */
351 
352     bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
353 
354     /**
355      * @dev Modifier to check whether the `msg.sender` is the admin.
356      * If it is, it will run the function. Otherwise, it will delegate the call
357      * to the implementation.
358      */
359     modifier ifAdmin() {
360         if (msg.sender == _admin()) {
361             _;
362         } else {
363             _fallback();
364         }
365     }
366 
367     /**
368      * @return The address of the proxy admin.
369      */
370     function admin() external ifAdmin returns (address) {
371         return _admin();
372     }
373 
374     /**
375      * @return The address of the implementation.
376      */
377     function implementation() external ifAdmin returns (address) {
378         return _implementation();
379     }
380 
381     /**
382      * @dev Changes the admin of the proxy.
383      * Only the current admin can call this function.
384      * @param newAdmin Address to transfer proxy administration to.
385      */
386     function changeAdmin(address newAdmin) external ifAdmin {
387         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
388         emit AdminChanged(_admin(), newAdmin);
389         _setAdmin(newAdmin);
390     }
391 
392     /**
393      * @dev Upgrade the backing implementation of the proxy.
394      * Only the admin can call this function.
395      * @param newImplementation Address of the new implementation.
396      */
397     function upgradeTo(address newImplementation) external ifAdmin {
398         _upgradeTo(newImplementation);
399     }
400 
401     /**
402      * @dev Upgrade the backing implementation of the proxy and call a function
403      * on the new implementation.
404      * This is useful to initialize the proxied contract.
405      * @param newImplementation Address of the new implementation.
406      * @param data Data to send as msg.data in the low level call.
407      * It should include the signature and the parameters of the function to be called, as described in
408      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
409      */
410     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
411         _upgradeTo(newImplementation);
412         (bool success, ) = newImplementation.delegatecall(data);
413         require(success);
414     }
415 
416     /**
417      * @return adm The admin slot.
418      */
419     function _admin() internal view returns (address adm) {
420         bytes32 slot = ADMIN_SLOT;
421         assembly {
422             adm := sload(slot)
423         }
424     }
425 
426     /**
427      * @dev Sets the address of the proxy admin.
428      * @param newAdmin Address of the new proxy admin.
429      */
430     function _setAdmin(address newAdmin) internal {
431         bytes32 slot = ADMIN_SLOT;
432 
433         assembly {
434             sstore(slot, newAdmin)
435         }
436     }
437 
438     /**
439      * @dev Only fall back when the sender is not the admin.
440      */
441     function _willFallback() internal virtual override {
442         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
443         super._willFallback();
444     }
445 }