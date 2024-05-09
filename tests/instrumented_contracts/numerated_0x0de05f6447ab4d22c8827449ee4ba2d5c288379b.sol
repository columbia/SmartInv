1 /**
2  * Copyright 2017-2021, OokiDao. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      */
31     function isContract(address account) internal view returns (bool) {
32         // This method relies on extcodesize, which returns 0 for contracts in
33         // construction, since the code is only stored at the end of the
34         // constructor execution.
35 
36         uint256 size;
37         assembly {
38             size := extcodesize(account)
39         }
40         return size > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         (bool success, ) = recipient.call{value: amount}("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     /**
67      * @dev Performs a Solidity function call using a low level `call`. A
68      * plain `call` is an unsafe replacement for a function call: use this
69      * function instead.
70      *
71      * If `target` reverts with a revert reason, it is bubbled up by this
72      * function (like regular Solidity function calls).
73      *
74      * Returns the raw returned data. To convert to the expected return value,
75      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
76      *
77      * Requirements:
78      *
79      * - `target` must be a contract.
80      * - calling `target` with `data` must not revert.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85         return functionCall(target, data, "Address: low-level call failed");
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
90      * `errorMessage` as a fallback revert reason when `target` reverts.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(
95         address target,
96         bytes memory data,
97         string memory errorMessage
98     ) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, 0, errorMessage);
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
104      * but also transferring `value` wei to `target`.
105      *
106      * Requirements:
107      *
108      * - the calling contract must have an ETH balance of at least `value`.
109      * - the called Solidity function must be `payable`.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(
114         address target,
115         bytes memory data,
116         uint256 value
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
123      * with `errorMessage` as a fallback revert reason when `target` reverts.
124      *
125      * _Available since v3.1._
126      */
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         require(address(this).balance >= value, "Address: insufficient balance for call");
134         require(isContract(target), "Address: call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.call{value: value}(data);
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
142      * but performing a static call.
143      *
144      * _Available since v3.3._
145      */
146     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
147         return functionStaticCall(target, data, "Address: low-level static call failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
152      * but performing a static call.
153      *
154      * _Available since v3.3._
155      */
156     function functionStaticCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal view returns (bytes memory) {
161         require(isContract(target), "Address: static call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a delegate call.
170      *
171      * _Available since v3.4._
172      */
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         require(isContract(target), "Address: delegate call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.delegatecall(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
196      * revert reason using the provided one.
197      *
198      * _Available since v4.3._
199      */
200     function verifyCallResult(
201         bool success,
202         bytes memory returndata,
203         string memory errorMessage
204     ) internal pure returns (bytes memory) {
205         if (success) {
206             return returndata;
207         } else {
208             // Look for revert reason and bubble it up if present
209             if (returndata.length > 0) {
210                 // The easiest way to bubble the revert reason is using memory via assembly
211 
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 }
222 
223 /**
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes calldata) {
239         return msg.data;
240     }
241 }
242 
243 /**
244  * @dev Contract module which provides a basic access control mechanism, where
245  * there is an account (an owner) that can be granted exclusive access to
246  * specific functions.
247  *
248  * By default, the owner account will be the one that deploys the contract. This
249  * can later be changed with {transferOwnership}.
250  *
251  * This module is used through inheritance. It will make available the modifier
252  * `onlyOwner`, which can be applied to your functions to restrict their use to
253  * the owner.
254  */
255 abstract contract Ownable is Context {
256     address private _owner;
257 
258     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
259 
260     /**
261      * @dev Initializes the contract setting the deployer as the initial owner.
262      */
263     constructor() {
264         _setOwner(_msgSender());
265     }
266 
267     /**
268      * @dev Returns the address of the current owner.
269      */
270     function owner() public view virtual returns (address) {
271         return _owner;
272     }
273 
274     /**
275      * @dev Throws if called by any account other than the owner.
276      */
277     modifier onlyOwner() {
278         require(owner() == _msgSender(), "Ownable: caller is not the owner");
279         _;
280     }
281 
282     /**
283      * @dev Leaves the contract without owner. It will not be possible to call
284      * `onlyOwner` functions anymore. Can only be called by the current owner.
285      *
286      * NOTE: Renouncing ownership will leave the contract without an owner,
287      * thereby removing any functionality that is only available to the owner.
288      */
289     function renounceOwnership() public virtual onlyOwner {
290         _setOwner(address(0));
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Can only be called by the current owner.
296      */
297     function transferOwnership(address newOwner) public virtual onlyOwner {
298         require(newOwner != address(0), "Ownable: new owner is the zero address");
299         _setOwner(newOwner);
300     }
301 
302     function _setOwner(address newOwner) private {
303         address oldOwner = _owner;
304         _owner = newOwner;
305         emit OwnershipTransferred(oldOwner, newOwner);
306     }
307 }
308 
309 contract Upgradeable_0_8 is Ownable {
310     address public implementation;
311 }
312 
313 contract OokiTokenProxy is Upgradeable_0_8 {
314     constructor(address _impl) public {
315         replaceImplementation(_impl);
316     }
317 
318     fallback() external {
319         address impl = implementation;
320         assembly {
321             calldatacopy(0, 0, calldatasize())
322             let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
323             returndatacopy(0, 0, returndatasize())
324             switch result
325             case 0 {
326                 revert(0, returndatasize())
327             }
328             default {
329                 return(0, returndatasize())
330             }
331         }
332     }
333 
334     function replaceImplementation(address impl) public onlyOwner {
335         require(Address.isContract(impl), "not a contract");
336         implementation = impl;
337     }
338 }