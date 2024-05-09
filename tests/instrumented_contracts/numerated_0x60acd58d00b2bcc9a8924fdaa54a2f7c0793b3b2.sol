1 pragma solidity ^0.6.6;
2 
3 /**
4  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
5  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
6  * be specified by overriding the virtual {_implementation} function.
7  *
8  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
9  * different contract through the {_delegate} function.
10  *
11  * The success and return data of the delegated call will be returned back to the caller of the proxy.
12  */
13 abstract contract Proxy {
14     /**
15      * @dev Delegates the current call to `implementation`.
16      *
17      * This function does not return to its internall call site, it will return directly to the external caller.
18      */
19     function _delegate(address implementation) internal virtual {
20         // solhint-disable-next-line no-inline-assembly
21         assembly {
22             // Copy msg.data. We take full control of memory in this inline assembly
23             // block because it will not return to Solidity code. We overwrite the
24             // Solidity scratch pad at memory position 0.
25             calldatacopy(0, 0, calldatasize())
26 
27             // Call the implementation.
28             // out and outsize are 0 because we don't know the size yet.
29             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
30 
31             // Copy the returned data.
32             returndatacopy(0, 0, returndatasize())
33 
34             switch result
35             // delegatecall returns 0 on error.
36             case 0 { revert(0, returndatasize()) }
37             default { return(0, returndatasize()) }
38         }
39     }
40 
41     /**
42      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
43      * and {_fallback} should delegate.
44      */
45     function _implementation() internal view virtual returns (address);
46 
47     /**
48      * @dev Delegates the current call to the address returned by `_implementation()`.
49      *
50      * This function does not return to its internall call site, it will return directly to the external caller.
51      */
52     function _fallback() internal virtual {
53         _beforeFallback();
54         _delegate(_implementation());
55     }
56 
57     /**
58      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
59      * function in the contract matches the call data.
60      */
61     fallback () external payable virtual {
62         _fallback();
63     }
64 
65     /**
66      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
67      * is empty.
68      */
69     receive () external payable virtual {
70         _fallback();
71     }
72 
73     /**
74      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
75      * call, or as part of the Solidity `fallback` or `receive` functions.
76      *
77      * If overriden should call `super._beforeFallback()`.
78      */
79     function _beforeFallback() internal virtual {
80     }
81 }
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
105         // This method relies on extcodesize, which returns 0 for contracts in
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
168         return functionCallWithValue(target, data, 0, errorMessage);
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
194         require(isContract(target), "Address: call to non-contract");
195 
196         // solhint-disable-next-line avoid-low-level-calls
197         (bool success, bytes memory returndata) = target.call{ value: value }(data);
198         return _verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but performing a static call.
204      *
205      * _Available since v3.3._
206      */
207     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
208         return functionStaticCall(target, data, "Address: low-level static call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
213      * but performing a static call.
214      *
215      * _Available since v3.3._
216      */
217     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
218         require(isContract(target), "Address: static call to non-contract");
219 
220         // solhint-disable-next-line avoid-low-level-calls
221         (bool success, bytes memory returndata) = target.staticcall(data);
222         return _verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227      * but performing a delegate call.
228      *
229      * _Available since v3.4._
230      */
231     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
232         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
242         require(isContract(target), "Address: delegate call to non-contract");
243 
244         // solhint-disable-next-line avoid-low-level-calls
245         (bool success, bytes memory returndata) = target.delegatecall(data);
246         return _verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
250         if (success) {
251             return returndata;
252         } else {
253             // Look for revert reason and bubble it up if present
254             if (returndata.length > 0) {
255                 // The easiest way to bubble the revert reason is using memory via assembly
256 
257                 // solhint-disable-next-line no-inline-assembly
258                 assembly {
259                     let returndata_size := mload(returndata)
260                     revert(add(32, returndata), returndata_size)
261                 }
262             } else {
263                 revert(errorMessage);
264             }
265         }
266     }
267 }
268 
269 
270 /**
271  * @dev This is the interface that {BeaconProxy} expects of its beacon.
272  */
273 interface IBeacon {
274     /**
275      * @dev Must return an address that can be used as a delegate call target.
276      *
277      * {BeaconProxy} will check that this address is a contract.
278      */
279     function implementation() external view returns (address);
280 }
281 
282 /**
283  * @dev This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
284  *
285  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
286  * conflict with the storage layout of the implementation behind the proxy.
287  *
288  * _Available since v3.4._
289  */
290 contract BeaconProxy is Proxy {
291     /**
292      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
293      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
294      */
295     bytes32 private constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
296 
297     /**
298      * @dev Initializes the proxy with `beacon`.
299      *
300      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
301      * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
302      * constructor.
303      *
304      * Requirements:
305      *
306      * - `beacon` must be a contract with the interface {IBeacon}.
307      */
308     constructor(address beacon, bytes memory data) public payable {
309         assert(_BEACON_SLOT == bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1));
310         _setBeacon(beacon, data);
311     }
312 
313     /**
314      * @dev Returns the current beacon address.
315      */
316     function _beacon() internal view virtual returns (address beacon) {
317         bytes32 slot = _BEACON_SLOT;
318         // solhint-disable-next-line no-inline-assembly
319         assembly {
320             beacon := sload(slot)
321         }
322     }
323 
324     /**
325      * @dev Returns the current implementation address of the associated beacon.
326      */
327     function _implementation() internal view virtual override returns (address) {
328         return IBeacon(_beacon()).implementation();
329     }
330 
331     /**
332      * @dev Changes the proxy to use a new beacon.
333      *
334      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
335      *
336      * Requirements:
337      *
338      * - `beacon` must be a contract.
339      * - The implementation returned by `beacon` must be a contract.
340      */
341     function _setBeacon(address beacon, bytes memory data) internal virtual {
342         require(
343             Address.isContract(beacon),
344             "BeaconProxy: beacon is not a contract"
345         );
346         require(
347             Address.isContract(IBeacon(beacon).implementation()),
348             "BeaconProxy: beacon implementation is not a contract"
349         );
350         bytes32 slot = _BEACON_SLOT;
351 
352         // solhint-disable-next-line no-inline-assembly
353         assembly {
354             sstore(slot, beacon)
355         }
356 
357         if (data.length > 0) {
358             Address.functionDelegateCall(_implementation(), data, "BeaconProxy: function call failed");
359         }
360     }
361 }