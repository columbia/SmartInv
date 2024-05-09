1 // File: contracts/proxy/Proxy.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @title Proxy
9  * @dev Implements delegation of calls to other contracts, with proper
10  * forwarding of return values and bubbling of failures.
11  * It defines a fallback function that delegates all calls to the address
12  * returned by the abstract _implementation() internal function.
13  */
14 abstract contract Proxy {
15     /**
16      * @dev Fallback function.
17      * Implemented entirely in `_fallback`.
18      */
19     fallback () payable external {
20         _fallback();
21     }
22 
23     /**
24      * @dev Receive function.
25      * Implemented entirely in `_fallback`.
26      */
27     receive () payable external {
28         _fallback();
29     }
30 
31     /**
32      * @return The Address of the implementation.
33      */
34     function _implementation() internal virtual view returns (address);
35 
36     /**
37      * @dev Delegates execution to an implementation contract.
38      * This is a low level function that doesn't return to its internal call site.
39      * It will return to the external caller whatever the implementation returns.
40      * @param implementation Address to delegate.
41      */
42     function _delegate(address implementation) internal {
43         assembly {
44         // Copy msg.data. We take full control of memory in this inline assembly
45         // block because it will not return to Solidity code. We overwrite the
46         // Solidity scratch pad at memory position 0.
47             calldatacopy(0, 0, calldatasize())
48 
49         // Call the implementation.
50         // out and outsize are 0 because we don't know the size yet.
51             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
52 
53         // Copy the returned data.
54             returndatacopy(0, 0, returndatasize())
55 
56             switch result
57             // delegatecall returns 0 on error.
58             case 0 { revert(0, returndatasize()) }
59             default { return(0, returndatasize()) }
60         }
61     }
62 
63     /**
64      * @dev Function that is run as the first thing in the fallback function.
65      * Can be redefined in derived contracts to add functionality.
66      * Redefinitions must call super._willFallback().
67      */
68     function _willFallback() internal virtual {
69     }
70 
71     /**
72      * @dev fallback implementation.
73      * Extracted to enable manual triggering.
74      */
75     function _fallback() internal {
76         _willFallback();
77         _delegate(_implementation());
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Address.sol
82 
83 /**
84  * @dev Collection of functions related to the address type
85  */
86 library Address {
87     /**
88      * @dev Returns true if `account` is a contract.
89      *
90      * [IMPORTANT]
91      * ====
92      * It is unsafe to assume that an address for which this function returns
93      * false is an externally-owned account (EOA) and not a contract.
94      *
95      * Among others, `isContract` will return false for the following
96      * types of addresses:
97      *
98      *  - an externally-owned account
99      *  - a contract in construction
100      *  - an address where a contract will be created
101      *  - an address where a contract lived, but was destroyed
102      * ====
103      */
104     function isContract(address account) internal view returns (bool) {
105         // This method relies in extcodesize, which returns 0 for contracts in
106         // construction, since the code is only stored at the end of the
107         // constructor execution.
108 
109         uint256 size;
110         // solhint-disable-next-line no-inline-assembly
111         assembly { size := extcodesize(account) }
112         return size > 0;
113     }
114 
115     /**
116      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
117      * `recipient`, forwarding all available gas and reverting on errors.
118      *
119      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
120      * of certain opcodes, possibly making contracts go over the 2300 gas limit
121      * imposed by `transfer`, making them unable to receive funds via
122      * `transfer`. {sendValue} removes this limitation.
123      *
124      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
125      *
126      * IMPORTANT: because control is transferred to `recipient`, care must be
127      * taken to not create reentrancy vulnerabilities. Consider using
128      * {ReentrancyGuard} or the
129      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
130      */
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
135         (bool success, ) = recipient.call{ value: amount }("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain`call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158       return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         return _functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but also transferring `value` wei to `target`.
174      *
175      * Requirements:
176      *
177      * - the calling contract must have an ETH balance of at least `value`.
178      * - the called Solidity function must be `payable`.
179      *
180      * _Available since v3.1._
181      */
182     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
188      * with `errorMessage` as a fallback revert reason when `target` reverts.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
193         require(address(this).balance >= value, "Address: insufficient balance for call");
194         return _functionCallWithValue(target, data, value, errorMessage);
195     }
196 
197     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
198         require(isContract(target), "Address: call to non-contract");
199 
200         // solhint-disable-next-line avoid-low-level-calls
201         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
202         if (success) {
203             return returndata;
204         } else {
205             // Look for revert reason and bubble it up if present
206             if (returndata.length > 0) {
207                 // The easiest way to bubble the revert reason is using memory via assembly
208 
209                 // solhint-disable-next-line no-inline-assembly
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 // File: contracts/proxy/UpgradeabilityProxy.sol
222 
223 
224 /**
225  * @title UpgradeabilityProxy
226  * @dev This contract implements a proxy that allows to change the
227  * implementation address to which it will delegate.
228  * Such a change is called an implementation upgrade.
229  */
230 contract UpgradeabilityProxy is Proxy {
231     /**
232      * @dev Contract constructor.
233      * @param _logic Address of the initial implementation.
234      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
235      * It should include the signature and the parameters of the function to be called, as described in
236      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
237      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
238      */
239     constructor(address _logic, bytes memory _data) public payable {
240         assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
241         _setImplementation(_logic);
242         if(_data.length > 0) {
243             (bool success,) = _logic.delegatecall(_data);
244             require(success);
245         }
246     }
247 
248     /**
249      * @dev Emitted when the implementation is upgraded.
250      * @param implementation Address of the new implementation.
251      */
252     event Upgraded(address indexed implementation);
253 
254     /**
255      * @dev Storage slot with the address of the current implementation.
256      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
257      * validated in the constructor.
258      */
259     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
260 
261     /**
262      * @dev Returns the current implementation.
263      * @return impl Address of the current implementation
264      */
265     function _implementation() internal override view returns (address impl) {
266         bytes32 slot = IMPLEMENTATION_SLOT;
267         assembly {
268             impl := sload(slot)
269         }
270     }
271 
272     /**
273      * @dev Upgrades the proxy to a new implementation.
274      * @param newImplementation Address of the new implementation.
275      */
276     function _upgradeTo(address newImplementation) internal {
277         _setImplementation(newImplementation);
278         emit Upgraded(newImplementation);
279     }
280 
281     /**
282      * @dev Sets the implementation address of the proxy.
283      * @param newImplementation Address of the new implementation.
284      */
285     function _setImplementation(address newImplementation) internal {
286         require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
287 
288         bytes32 slot = IMPLEMENTATION_SLOT;
289 
290         assembly {
291             sstore(slot, newImplementation)
292         }
293     }
294 }
295 
296 // File: contracts/proxy/AdminUpgradeabilityProxy.sol
297 
298 /**
299  * @title AdminUpgradeabilityProxy
300  * @dev This contract combines an upgradeability proxy with an authorization
301  * mechanism for administrative tasks.
302  * All external functions in this contract must be guarded by the
303  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
304  * feature proposal that would enable this to be done automatically.
305  */
306 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
307     /**
308      * Contract constructor.
309      * @param _logic address of the initial implementation.
310      * @param _admin Address of the proxy administrator.
311      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
312      * It should include the signature and the parameters of the function to be called, as described in
313      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
314      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
315      */
316     constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
317         assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
318         _setAdmin(_admin);
319     }
320 
321     /**
322      * @dev Emitted when the administration has been transferred.
323      * @param previousAdmin Address of the previous admin.
324      * @param newAdmin Address of the new admin.
325      */
326     event AdminChanged(address previousAdmin, address newAdmin);
327 
328     /**
329      * @dev Storage slot with the admin of the contract.
330      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
331      * validated in the constructor.
332      */
333 
334     bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
335 
336     /**
337      * @dev Modifier to check whether the `msg.sender` is the admin.
338      * If it is, it will run the function. Otherwise, it will delegate the call
339      * to the implementation.
340      */
341     modifier ifAdmin() {
342         if (msg.sender == _admin()) {
343             _;
344         } else {
345             _fallback();
346         }
347     }
348 
349     /**
350      * @return The address of the proxy admin.
351      */
352     function admin() external ifAdmin returns (address) {
353         return _admin();
354     }
355 
356     /**
357      * @return The address of the implementation.
358      */
359     function implementation() external ifAdmin returns (address) {
360         return _implementation();
361     }
362 
363     /**
364      * @dev Changes the admin of the proxy.
365      * Only the current admin can call this function.
366      * @param newAdmin Address to transfer proxy administration to.
367      */
368     function changeAdmin(address newAdmin) external ifAdmin {
369         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
370         emit AdminChanged(_admin(), newAdmin);
371         _setAdmin(newAdmin);
372     }
373 
374     /**
375      * @dev Upgrade the backing implementation of the proxy.
376      * Only the admin can call this function.
377      * @param newImplementation Address of the new implementation.
378      */
379     function upgradeTo(address newImplementation) external ifAdmin {
380         _upgradeTo(newImplementation);
381     }
382 
383     /**
384      * @dev Upgrade the backing implementation of the proxy and call a function
385      * on the new implementation.
386      * This is useful to initialize the proxied contract.
387      * @param newImplementation Address of the new implementation.
388      * @param data Data to send as msg.data in the low level call.
389      * It should include the signature and the parameters of the function to be called, as described in
390      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
391      */
392     function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
393         _upgradeTo(newImplementation);
394         (bool success,) = newImplementation.delegatecall(data);
395         require(success);
396     }
397 
398     /**
399      * @return adm The admin slot.
400      */
401     function _admin() internal view returns (address adm) {
402         bytes32 slot = ADMIN_SLOT;
403         assembly {
404             adm := sload(slot)
405         }
406     }
407 
408     /**
409      * @dev Sets the address of the proxy admin.
410      * @param newAdmin Address of the new proxy admin.
411      */
412     function _setAdmin(address newAdmin) internal {
413         bytes32 slot = ADMIN_SLOT;
414 
415         assembly {
416             sstore(slot, newAdmin)
417         }
418     }
419 
420     /**
421      * @dev Only fall back when the sender is not the admin.
422      */
423     function _willFallback() internal override virtual {
424         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
425         super._willFallback();
426     }
427 }