1 /*
2   ･
3    *　★
4       ･ ｡
5         　･　ﾟ☆ ｡
6   　　　 *　★ ﾟ･｡ *  ｡
7           　　* ☆ ｡･ﾟ*.｡
8       　　　ﾟ *.｡☆｡★　･
9 ​
10                       `                     .-:::::-.`              `-::---...```
11                      `-:`               .:+ssssoooo++//:.`       .-/+shhhhhhhhhhhhhyyyssooo:
12                     .--::.            .+ossso+/////++/:://-`   .////+shhhhhhhhhhhhhhhhhhhhhy
13                   `-----::.         `/+////+++///+++/:--:/+/-  -////+shhhhhhhhhhhhhhhhhhhhhy
14                  `------:::-`      `//-.``.-/+ooosso+:-.-/oso- -////+shhhhhhhhhhhhhhhhhhhhhy
15                 .--------:::-`     :+:.`  .-/osyyyyyyso++syhyo.-////+shhhhhhhhhhhhhhhhhhhhhy
16               `-----------:::-.    +o+:-.-:/oyhhhhhhdhhhhhdddy:-////+shhhhhhhhhhhhhhhhhhhhhy
17              .------------::::--  `oys+/::/+shhhhhhhdddddddddy/-////+shhhhhhhhhhhhhhhhhhhhhy
18             .--------------:::::-` +ys+////+yhhhhhhhddddddddhy:-////+yhhhhhhhhhhhhhhhhhhhhhy
19           `----------------::::::-`.ss+/:::+oyhhhhhhhhhhhhhhho`-////+shhhhhhhhhhhhhhhhhhhhhy
20          .------------------:::::::.-so//::/+osyyyhhhhhhhhhys` -////+shhhhhhhhhhhhhhhhhhhhhy
21        `.-------------------::/:::::..+o+////+oosssyyyyyyys+`  .////+shhhhhhhhhhhhhhhhhhhhhy
22        .--------------------::/:::.`   -+o++++++oooosssss/.     `-//+shhhhhhhhhhhhhhhhhhhhyo
23      .-------   ``````.......--`        `-/+ooooosso+/-`          `./++++///:::--...``hhhhyo
24                                               `````
25    *　
26       ･ ｡
27 　　　　･　　ﾟ☆ ｡
28   　　　 *　★ ﾟ･｡ *  ｡
29           　　* ☆ ｡･ﾟ*.｡
30       　　　ﾟ *.｡☆｡★　･
31     *　　ﾟ｡·*･｡ ﾟ*
32   　　　☆ﾟ･｡°*. ﾟ
33 　 ･ ﾟ*｡･ﾟ★｡
34 　　･ *ﾟ｡　　 *
35 　･ﾟ*｡★･
36  ☆∴｡　*
37 ･ ｡
38 */
39 
40 // File: ../proxy-contracts/Proxy.sol
41 
42 // SPDX-License-Identifier: MIT
43 
44 pragma solidity ^0.6.0;
45 
46 /**
47  * @title Proxy
48  * @dev Implements delegation of calls to other contracts, with proper
49  * forwarding of return values and bubbling of failures.
50  * It defines a fallback function that delegates all calls to the address
51  * returned by the abstract _implementation() internal function.
52  */
53 abstract contract Proxy {
54   /**
55    * @dev Fallback function.
56    * Implemented entirely in `_fallback`.
57    */
58   fallback () payable external {
59     _fallback();
60   }
61 
62   /**
63    * @dev Receive function.
64    * Implemented entirely in `_fallback`.
65    */
66   receive () payable external {
67     _fallback();
68   }
69 
70   /**
71    * @return The Address of the implementation.
72    */
73   function _implementation() internal virtual view returns (address);
74 
75   /**
76    * @dev Delegates execution to an implementation contract.
77    * This is a low level function that doesn't return to its internal call site.
78    * It will return to the external caller whatever the implementation returns.
79    * @param implementation Address to delegate.
80    */
81   function _delegate(address implementation) internal {
82     assembly {
83       // Copy msg.data. We take full control of memory in this inline assembly
84       // block because it will not return to Solidity code. We overwrite the
85       // Solidity scratch pad at memory position 0.
86       calldatacopy(0, 0, calldatasize())
87 
88       // Call the implementation.
89       // out and outsize are 0 because we don't know the size yet.
90       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
91 
92       // Copy the returned data.
93       returndatacopy(0, 0, returndatasize())
94 
95       switch result
96       // delegatecall returns 0 on error.
97       case 0 { revert(0, returndatasize()) }
98       default { return(0, returndatasize()) }
99     }
100   }
101 
102   /**
103    * @dev Function that is run as the first thing in the fallback function.
104    * Can be redefined in derived contracts to add functionality.
105    * Redefinitions must call super._willFallback().
106    */
107   function _willFallback() internal virtual {
108   }
109 
110   /**
111    * @dev fallback implementation.
112    * Extracted to enable manual triggering.
113    */
114   function _fallback() internal {
115     _willFallback();
116     _delegate(_implementation());
117   }
118 }
119 
120 // File: @openzeppelin/contracts/utils/Address.sol
121 
122 
123 
124 pragma solidity ^0.6.2;
125 
126 /**
127  * @dev Collection of functions related to the address type
128  */
129 library Address {
130     /**
131      * @dev Returns true if `account` is a contract.
132      *
133      * [IMPORTANT]
134      * ====
135      * It is unsafe to assume that an address for which this function returns
136      * false is an externally-owned account (EOA) and not a contract.
137      *
138      * Among others, `isContract` will return false for the following
139      * types of addresses:
140      *
141      *  - an externally-owned account
142      *  - a contract in construction
143      *  - an address where a contract will be created
144      *  - an address where a contract lived, but was destroyed
145      * ====
146      */
147     function isContract(address account) internal view returns (bool) {
148         // This method relies in extcodesize, which returns 0 for contracts in
149         // construction, since the code is only stored at the end of the
150         // constructor execution.
151 
152         uint256 size;
153         // solhint-disable-next-line no-inline-assembly
154         assembly { size := extcodesize(account) }
155         return size > 0;
156     }
157 
158     /**
159      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
160      * `recipient`, forwarding all available gas and reverting on errors.
161      *
162      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
163      * of certain opcodes, possibly making contracts go over the 2300 gas limit
164      * imposed by `transfer`, making them unable to receive funds via
165      * `transfer`. {sendValue} removes this limitation.
166      *
167      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
168      *
169      * IMPORTANT: because control is transferred to `recipient`, care must be
170      * taken to not create reentrancy vulnerabilities. Consider using
171      * {ReentrancyGuard} or the
172      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
173      */
174     function sendValue(address payable recipient, uint256 amount) internal {
175         require(address(this).balance >= amount, "Address: insufficient balance");
176 
177         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
178         (bool success, ) = recipient.call{ value: amount }("");
179         require(success, "Address: unable to send value, recipient may have reverted");
180     }
181 
182     /**
183      * @dev Performs a Solidity function call using a low level `call`. A
184      * plain`call` is an unsafe replacement for a function call: use this
185      * function instead.
186      *
187      * If `target` reverts with a revert reason, it is bubbled up by this
188      * function (like regular Solidity function calls).
189      *
190      * Returns the raw returned data. To convert to the expected return value,
191      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
192      *
193      * Requirements:
194      *
195      * - `target` must be a contract.
196      * - calling `target` with `data` must not revert.
197      *
198      * _Available since v3.1._
199      */
200     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
201       return functionCall(target, data, "Address: low-level call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
206      * `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
211         return _functionCallWithValue(target, data, 0, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but also transferring `value` wei to `target`.
217      *
218      * Requirements:
219      *
220      * - the calling contract must have an ETH balance of at least `value`.
221      * - the called Solidity function must be `payable`.
222      *
223      * _Available since v3.1._
224      */
225     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
231      * with `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
236         require(address(this).balance >= value, "Address: insufficient balance for call");
237         return _functionCallWithValue(target, data, value, errorMessage);
238     }
239 
240     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
241         require(isContract(target), "Address: call to non-contract");
242 
243         // solhint-disable-next-line avoid-low-level-calls
244         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
245         if (success) {
246             return returndata;
247         } else {
248             // Look for revert reason and bubble it up if present
249             if (returndata.length > 0) {
250                 // The easiest way to bubble the revert reason is using memory via assembly
251 
252                 // solhint-disable-next-line no-inline-assembly
253                 assembly {
254                     let returndata_size := mload(returndata)
255                     revert(add(32, returndata), returndata_size)
256                 }
257             } else {
258                 revert(errorMessage);
259             }
260         }
261     }
262 }
263 
264 // File: ../proxy-contracts/UpgradeabilityProxy.sol
265 
266 
267 
268 pragma solidity ^0.6.0;
269 
270 
271 
272 /**
273  * @title UpgradeabilityProxy
274  * @dev This contract implements a proxy that allows to change the
275  * implementation address to which it will delegate.
276  * Such a change is called an implementation upgrade.
277  */
278 contract UpgradeabilityProxy is Proxy {
279   /**
280    * @dev Contract constructor.
281    * @param _logic Address of the initial implementation.
282    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
283    * It should include the signature and the parameters of the function to be called, as described in
284    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
285    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
286    */
287   constructor(address _logic, bytes memory _data) public payable {
288     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
289     _setImplementation(_logic);
290     if(_data.length > 0) {
291       (bool success,) = _logic.delegatecall(_data);
292       require(success);
293     }
294   }
295 
296   /**
297    * @dev Emitted when the implementation is upgraded.
298    * @param implementation Address of the new implementation.
299    */
300   event Upgraded(address indexed implementation);
301 
302   /**
303    * @dev Storage slot with the address of the current implementation.
304    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
305    * validated in the constructor.
306    */
307   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
308 
309   /**
310    * @dev Returns the current implementation.
311    * @return impl Address of the current implementation
312    */
313   function _implementation() internal override view returns (address impl) {
314     bytes32 slot = IMPLEMENTATION_SLOT;
315     assembly {
316       impl := sload(slot)
317     }
318   }
319 
320   /**
321    * @dev Upgrades the proxy to a new implementation.
322    * @param newImplementation Address of the new implementation.
323    */
324   function _upgradeTo(address newImplementation) internal {
325     _setImplementation(newImplementation);
326     emit Upgraded(newImplementation);
327   }
328 
329   /**
330    * @dev Sets the implementation address of the proxy.
331    * @param newImplementation Address of the new implementation.
332    */
333   function _setImplementation(address newImplementation) internal {
334     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
335 
336     bytes32 slot = IMPLEMENTATION_SLOT;
337 
338     assembly {
339       sstore(slot, newImplementation)
340     }
341   }
342 }
343 
344 // File: ../proxy-contracts/AdminUpgradeabilityProxy.sol
345 
346 
347 
348 pragma solidity ^0.6.0;
349 
350 
351 /**
352  * @title AdminUpgradeabilityProxy
353  * @dev This contract combines an upgradeability proxy with an authorization
354  * mechanism for administrative tasks.
355  * All external functions in this contract must be guarded by the
356  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
357  * feature proposal that would enable this to be done automatically.
358  */
359 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
360   /**
361    * Contract constructor.
362    * @param _logic address of the initial implementation.
363    * @param _admin Address of the proxy administrator.
364    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
365    * It should include the signature and the parameters of the function to be called, as described in
366    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
367    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
368    */
369   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
370     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
371     _setAdmin(_admin);
372   }
373 
374   /**
375    * @dev Emitted when the administration has been transferred.
376    * @param previousAdmin Address of the previous admin.
377    * @param newAdmin Address of the new admin.
378    */
379   event AdminChanged(address previousAdmin, address newAdmin);
380 
381   /**
382    * @dev Storage slot with the admin of the contract.
383    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
384    * validated in the constructor.
385    */
386 
387   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
388 
389   /**
390    * @dev Modifier to check whether the `msg.sender` is the admin.
391    * If it is, it will run the function. Otherwise, it will delegate the call
392    * to the implementation.
393    */
394   modifier ifAdmin() {
395     if (msg.sender == _admin()) {
396       _;
397     } else {
398       _fallback();
399     }
400   }
401 
402   /**
403    * @return The address of the proxy admin.
404    */
405   function admin() external ifAdmin returns (address) {
406     return _admin();
407   }
408 
409   /**
410    * @return The address of the implementation.
411    */
412   function implementation() external ifAdmin returns (address) {
413     return _implementation();
414   }
415 
416   /**
417    * @dev Changes the admin of the proxy.
418    * Only the current admin can call this function.
419    * @param newAdmin Address to transfer proxy administration to.
420    */
421   function changeAdmin(address newAdmin) external ifAdmin {
422     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
423     emit AdminChanged(_admin(), newAdmin);
424     _setAdmin(newAdmin);
425   }
426 
427   /**
428    * @dev Upgrade the backing implementation of the proxy.
429    * Only the admin can call this function.
430    * @param newImplementation Address of the new implementation.
431    */
432   function upgradeTo(address newImplementation) external ifAdmin {
433     _upgradeTo(newImplementation);
434   }
435 
436   /**
437    * @dev Upgrade the backing implementation of the proxy and call a function
438    * on the new implementation.
439    * This is useful to initialize the proxied contract.
440    * @param newImplementation Address of the new implementation.
441    * @param data Data to send as msg.data in the low level call.
442    * It should include the signature and the parameters of the function to be called, as described in
443    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
444    */
445   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
446     _upgradeTo(newImplementation);
447     (bool success,) = newImplementation.delegatecall(data);
448     require(success);
449   }
450 
451   /**
452    * @return adm The admin slot.
453    */
454   function _admin() internal view returns (address adm) {
455     bytes32 slot = ADMIN_SLOT;
456     assembly {
457       adm := sload(slot)
458     }
459   }
460 
461   /**
462    * @dev Sets the address of the proxy admin.
463    * @param newAdmin Address of the new proxy admin.
464    */
465   function _setAdmin(address newAdmin) internal {
466     bytes32 slot = ADMIN_SLOT;
467 
468     assembly {
469       sstore(slot, newAdmin)
470     }
471   }
472 
473   /**
474    * @dev Only fall back when the sender is not the admin.
475    */
476   function _willFallback() internal override virtual {
477     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
478     super._willFallback();
479   }
480 }