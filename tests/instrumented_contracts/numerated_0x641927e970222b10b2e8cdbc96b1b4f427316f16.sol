1 // Sources flattened with hardhat v2.0.11 https://hardhat.org
2 
3 // File contracts/solidity/proxy/IBeacon.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev This is the interface that {BeaconProxy} expects of its beacon.
11  */
12 interface IBeacon {
13     /**
14      * @dev Must return an address that can be used as a delegate call target.
15      *
16      * {BeaconProxy} will check that this address is a contract.
17      */
18     function childImplementation() external view returns (address);
19     function upgradeChildTo(address newImplementation) external;
20 }
21 
22 
23 // File contracts/solidity/proxy/Proxy.sol
24 
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
31  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
32  * be specified by overriding the virtual {_implementation} function.
33  *
34  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
35  * different contract through the {_delegate} function.
36  *
37  * The success and return data of the delegated call will be returned back to the caller of the proxy.
38  */
39 abstract contract Proxy {
40     /**
41      * @dev Delegates the current call to `implementation`.
42      *
43      * This function does not return to its internall call site, it will return directly to the external caller.
44      */
45     function _delegate(address implementation) internal virtual {
46         // solhint-disable-next-line no-inline-assembly
47         assembly {
48             // Copy msg.data. We take full control of memory in this inline assembly
49             // block because it will not return to Solidity code. We overwrite the
50             // Solidity scratch pad at memory position 0.
51             calldatacopy(0, 0, calldatasize())
52 
53             // Call the implementation.
54             // out and outsize are 0 because we don't know the size yet.
55             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
56 
57             // Copy the returned data.
58             returndatacopy(0, 0, returndatasize())
59 
60             switch result
61             // delegatecall returns 0 on error.
62             case 0 { revert(0, returndatasize()) }
63             default { return(0, returndatasize()) }
64         }
65     }
66 
67     /**
68      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
69      * and {_fallback} should delegate.
70      */
71     function _implementation() internal view virtual returns (address);
72 
73     /**
74      * @dev Delegates the current call to the address returned by `_implementation()`.
75      *
76      * This function does not return to its internall call site, it will return directly to the external caller.
77      */
78     function _fallback() internal virtual {
79         _beforeFallback();
80         _delegate(_implementation());
81     }
82 
83     /**
84      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
85      * function in the contract matches the call data.
86      */
87     fallback () external payable virtual {
88         _fallback();
89     }
90 
91     /**
92      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
93      * is empty.
94      */
95     receive () external payable virtual {
96         _fallback();
97     }
98 
99     /**
100      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
101      * call, or as part of the Solidity `fallback` or `receive` functions.
102      *
103      * If overriden should call `super._beforeFallback()`.
104      */
105     function _beforeFallback() internal virtual {
106     }
107 }
108 
109 
110 // File contracts/solidity/util/Address.sol
111 
112 
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev Collection of functions related to the address type
118  */
119 library Address {
120     /**
121      * @dev Returns true if `account` is a contract.
122      *
123      * [IMPORTANT]
124      * ====
125      * It is unsafe to assume that an address for which this function returns
126      * false is an externally-owned account (EOA) and not a contract.
127      *
128      * Among others, `isContract` will return false for the following
129      * types of addresses:
130      *
131      *  - an externally-owned account
132      *  - a contract in construction
133      *  - an address where a contract will be created
134      *  - an address where a contract lived, but was destroyed
135      * ====
136      */
137     function isContract(address account) internal view returns (bool) {
138         // This method relies on extcodesize, which returns 0 for contracts in
139         // construction, since the code is only stored at the end of the
140         // constructor execution.
141 
142         uint256 size;
143         // solhint-disable-next-line no-inline-assembly
144         assembly { size := extcodesize(account) }
145         return size > 0;
146     }
147 
148     /**
149      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
150      * `recipient`, forwarding all available gas and reverting on errors.
151      *
152      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
153      * of certain opcodes, possibly making contracts go over the 2300 gas limit
154      * imposed by `transfer`, making them unable to receive funds via
155      * `transfer`. {sendValue} removes this limitation.
156      *
157      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
158      *
159      * IMPORTANT: because control is transferred to `recipient`, care must be
160      * taken to not create reentrancy vulnerabilities. Consider using
161      * {ReentrancyGuard} or the
162      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
163      */
164     function sendValue(address payable recipient, uint256 amount) internal {
165         require(address(this).balance >= amount, "Address: insufficient balance");
166 
167         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
168         (bool success, ) = recipient.call{ value: amount }("");
169         require(success, "Address: unable to send value, recipient may have reverted");
170     }
171 
172     /**
173      * @dev Performs a Solidity function call using a low level `call`. A
174      * plain`call` is an unsafe replacement for a function call: use this
175      * function instead.
176      *
177      * If `target` reverts with a revert reason, it is bubbled up by this
178      * function (like regular Solidity function calls).
179      *
180      * Returns the raw returned data. To convert to the expected return value,
181      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
182      *
183      * Requirements:
184      *
185      * - `target` must be a contract.
186      * - calling `target` with `data` must not revert.
187      *
188      * _Available since v3.1._
189      */
190     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
191       return functionCall(target, data, "Address: low-level call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
196      * `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, 0, errorMessage);
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
206      * but also transferring `value` wei to `target`.
207      *
208      * Requirements:
209      *
210      * - the calling contract must have an ETH balance of at least `value`.
211      * - the called Solidity function must be `payable`.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
216         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
221      * with `errorMessage` as a fallback revert reason when `target` reverts.
222      *
223      * _Available since v3.1._
224      */
225     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
226         require(address(this).balance >= value, "Address: insufficient balance for call");
227         require(isContract(target), "Address: call to non-contract");
228 
229         // solhint-disable-next-line avoid-low-level-calls
230         (bool success, bytes memory returndata) = target.call{ value: value }(data);
231         return _verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
241         return functionStaticCall(target, data, "Address: low-level static call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
246      * but performing a static call.
247      *
248      * _Available since v3.3._
249      */
250     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
251         require(isContract(target), "Address: static call to non-contract");
252 
253         // solhint-disable-next-line avoid-low-level-calls
254         (bool success, bytes memory returndata) = target.staticcall(data);
255         return _verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
275         require(isContract(target), "Address: delegate call to non-contract");
276 
277         // solhint-disable-next-line avoid-low-level-calls
278         (bool success, bytes memory returndata) = target.delegatecall(data);
279         return _verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
283         if (success) {
284             return returndata;
285         } else {
286             // Look for revert reason and bubble it up if present
287             if (returndata.length > 0) {
288                 // The easiest way to bubble the revert reason is using memory via assembly
289 
290                 // solhint-disable-next-line no-inline-assembly
291                 assembly {
292                     let returndata_size := mload(returndata)
293                     revert(add(32, returndata), returndata_size)
294                 }
295             } else {
296                 revert(errorMessage);
297             }
298         }
299     }
300 }
301 
302 
303 // File contracts/solidity/proxy/BeaconProxy.sol
304 
305 
306 
307 pragma solidity ^0.8.0;
308 
309 
310 
311 /**
312  * @dev This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
313  *
314  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
315  * conflict with the storage layout of the implementation behind the proxy.
316  *
317  * _Available since v3.4._
318  */
319 contract BeaconProxy is Proxy {
320     /**
321      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
322      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
323      */
324     bytes32 private constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
325 
326     /**
327      * @dev Initializes the proxy with `beacon`.
328      *
329      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
330      * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
331      * constructor.
332      *
333      * Requirements:
334      *
335      * - `beacon` must be a contract with the interface {IBeacon}.
336      */
337     constructor(address beacon, bytes memory data) payable {
338         assert(_BEACON_SLOT == bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1));
339         _setBeacon(beacon, data);
340     }
341 
342     /**
343      * @dev Returns the current beacon address.
344      */
345     function _beacon() internal view virtual returns (address beacon) {
346         bytes32 slot = _BEACON_SLOT;
347         // solhint-disable-next-line no-inline-assembly
348         assembly {
349             beacon := sload(slot)
350         }
351     }
352 
353     /**
354      * @dev Returns the current implementation address of the associated beacon.
355      */
356     function _implementation() internal view virtual override returns (address) {
357         return IBeacon(_beacon()).childImplementation();
358     }
359 
360     /**
361      * @dev Changes the proxy to use a new beacon.
362      *
363      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
364      *
365      * Requirements:
366      *
367      * - `beacon` must be a contract.
368      * - The implementation returned by `beacon` must be a contract.
369      */
370     function _setBeacon(address beacon, bytes memory data) internal virtual {
371         require(
372             Address.isContract(beacon),
373             "BeaconProxy: beacon is not a contract"
374         );
375         require(
376             Address.isContract(IBeacon(beacon).childImplementation()),
377             "BeaconProxy: beacon implementation is not a contract"
378         );
379         bytes32 slot = _BEACON_SLOT;
380 
381         // solhint-disable-next-line no-inline-assembly
382         assembly {
383             sstore(slot, beacon)
384         }
385 
386         if (data.length > 0) {
387             Address.functionDelegateCall(_implementation(), data, "BeaconProxy: function call failed");
388         }
389     }
390 }