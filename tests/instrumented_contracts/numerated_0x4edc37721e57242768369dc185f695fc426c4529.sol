1 // SPDX-License-Identifier: MIT LICENSE
2 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
3 pragma solidity ^0.8.0;
4 
5 library Strings {
6     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
7 
8     /**
9      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
10      */
11     function toString(uint256 value) internal pure returns (string memory) {
12         // Inspired by OraclizeAPI's implementation - MIT licence
13         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
14 
15         if (value == 0) {
16             return "0";
17         }
18         uint256 temp = value;
19         uint256 digits;
20         while (temp != 0) {
21             digits++;
22             temp /= 10;
23         }
24         bytes memory buffer = new bytes(digits);
25         while (value != 0) {
26             digits -= 1;
27             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
28             value /= 10;
29         }
30         return string(buffer);
31     }
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
35      */
36     function toHexString(uint256 value) internal pure returns (string memory) {
37         if (value == 0) {
38             return "0x00";
39         }
40         uint256 temp = value;
41         uint256 length = 0;
42         while (temp != 0) {
43             length++;
44             temp >>= 8;
45         }
46         return toHexString(value, length);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
51      */
52     function toHexString(uint256 value, uint256 length)
53         internal
54         pure
55         returns (string memory)
56     {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68 
69 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
70 pragma solidity ^0.8.1;
71 library Address {
72     /**
73      * @dev Returns true if `account` is a contract.
74      *
75      * [IMPORTANT]
76      * ====
77      * It is unsafe to assume that an address for which this function returns
78      * false is an externally-owned account (EOA) and not a contract.
79      *
80      * Among others, `isContract` will return false for the following
81      * types of addresses:
82      *
83      *  - an externally-owned account
84      *  - a contract in construction
85      *  - an address where a contract will be created
86      *  - an address where a contract lived, but was destroyed
87      * ====
88      *
89      * [IMPORTANT]
90      * ====
91      * You shouldn't rely on `isContract` to protect against flash loan attacks!
92      *
93      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
94      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
95      * constructor.
96      * ====
97      */
98     function isContract(address account) internal view returns (bool) {
99         // This method relies on extcodesize/address.code.length, which returns 0
100         // for contracts in construction, since the code is only stored at the end
101         // of the constructor execution.
102 
103         return account.code.length > 0;
104     }
105 
106     /**
107      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
108      * `recipient`, forwarding all available gas and reverting on errors.
109      *
110      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
111      * of certain opcodes, possibly making contracts go over the 2300 gas limit
112      * imposed by `transfer`, making them unable to receive funds via
113      * `transfer`. {sendValue} removes this limitation.
114      *
115      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
116      *
117      * IMPORTANT: because control is transferred to `recipient`, care must be
118      * taken to not create reentrancy vulnerabilities. Consider using
119      * {ReentrancyGuard} or the
120      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
121      */
122     function sendValue(address payable recipient, uint256 amount) internal {
123         require(
124             address(this).balance >= amount,
125             "Address: insufficient balance"
126         );
127 
128         (bool success, ) = recipient.call{value: amount}("");
129         require(
130             success,
131             "Address: unable to send value, recipient may have reverted"
132         );
133     }
134 
135     /**
136      * @dev Performs a Solidity function call using a low level `call`. A
137      * plain `call` is an unsafe replacement for a function call: use this
138      * function instead.
139      *
140      * If `target` reverts with a revert reason, it is bubbled up by this
141      * function (like regular Solidity function calls).
142      *
143      * Returns the raw returned data. To convert to the expected return value,
144      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
145      *
146      * Requirements:
147      *
148      * - `target` must be a contract.
149      * - calling `target` with `data` must not revert.
150      *
151      * _Available since v3.1._
152      */
153     function functionCall(address target, bytes memory data)
154         internal
155         returns (bytes memory)
156     {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
162      * `errorMessage` as a fallback revert reason when `target` reverts.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value
189     ) internal returns (bytes memory) {
190         return
191             functionCallWithValue(
192                 target,
193                 data,
194                 value,
195                 "Address: low-level call with value failed"
196             );
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
201      * with `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 value,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         require(
212             address(this).balance >= value,
213             "Address: insufficient balance for call"
214         );
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(
218             data
219         );
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(address target, bytes memory data)
230         internal
231         view
232         returns (bytes memory)
233     {
234         return
235             functionStaticCall(
236                 target,
237                 data,
238                 "Address: low-level static call failed"
239             );
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
244      * but performing a static call.
245      *
246      * _Available since v3.3._
247      */
248     function functionStaticCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal view returns (bytes memory) {
253         require(isContract(target), "Address: static call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.staticcall(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(address target, bytes memory data)
266         internal
267         returns (bytes memory)
268     {
269         return
270             functionDelegateCall(
271                 target,
272                 data,
273                 "Address: low-level delegate call failed"
274             );
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(isContract(target), "Address: delegate call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.delegatecall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
296      * revert reason using the provided one.
297      *
298      * _Available since v4.3._
299      */
300     function verifyCallResult(
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal pure returns (bytes memory) {
305         if (success) {
306             return returndata;
307         } else {
308             // Look for revert reason and bubble it up if present
309             if (returndata.length > 0) {
310                 // The easiest way to bubble the revert reason is using memory via assembly
311 
312                 assembly {
313                     let returndata_size := mload(returndata)
314                     revert(add(32, returndata), returndata_size)
315                 }
316             } else {
317                 revert(errorMessage);
318             }
319         }
320     }
321 }
322 
323 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
324 pragma solidity ^0.8.0;
325 abstract contract Context {
326     function _msgSender() internal view virtual returns (address) {
327         return msg.sender;
328     }
329 
330     function _msgData() internal view virtual returns (bytes calldata) {
331         return msg.data;
332     }
333 }
334 
335 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
336 pragma solidity ^0.8.0;
337 abstract contract Ownable is Context {
338     address private _owner;
339 
340     event OwnershipTransferred(
341         address indexed previousOwner,
342         address indexed newOwner
343     );
344 
345     /**
346      * @dev Initializes the contract setting the deployer as the initial owner.
347      */
348     constructor() {
349         _transferOwnership(_msgSender());
350     }
351 
352     /**
353      * @dev Returns the address of the current owner.
354      */
355     function owner() public view virtual returns (address) {
356         return _owner;
357     }
358 
359     /**
360      * @dev Throws if called by any account other than the owner.
361      */
362     modifier onlyOwner() {
363         require(owner() == _msgSender(), "Ownable: caller is not the owner");
364         _;
365     }
366 
367     /**
368      * @dev Leaves the contract without owner. It will not be possible to call
369      * `onlyOwner` functions anymore. Can only be called by the current owner.
370      *
371      * NOTE: Renouncing ownership will leave the contract without an owner,
372      * thereby removing any functionality that is only available to the owner.
373      */
374     function renounceOwnership() public virtual onlyOwner {
375         _transferOwnership(address(0));
376     }
377 
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Can only be called by the current owner.
381      */
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(
384             newOwner != address(0),
385             "Ownable: new owner is the zero address"
386         );
387         _transferOwnership(newOwner);
388     }
389 
390     /**
391      * @dev Transfers ownership of the contract to a new account (`newOwner`).
392      * Internal function without access restriction.
393      */
394     function _transferOwnership(address newOwner) internal virtual {
395         address oldOwner = _owner;
396         _owner = newOwner;
397         emit OwnershipTransferred(oldOwner, newOwner);
398     }
399 }
400 
401 pragma solidity 0.8.4;
402 contract BGFSTYXV2 is Ownable {
403 
404     address public hellspawn;
405     address public familiars;
406     address public towers;
407     bool public claimingEnabled = true;
408     bool public spendingEnabled = true;
409     mapping(address => uint256) public bank;
410 
411     function getBankBalance(address _address) public view returns (uint256) {
412         return bank[_address];
413     }
414 
415     function spendBalanceHellspawn(address _address, uint256 _amount) public {
416         require(spendingEnabled, "Balance spending functions are disabled.");
417         require(msg.sender == hellspawn, "Not Allowed.");
418         require(bank[_address] >= _amount, "Not Enough $STYX.");
419         bank[_address] -= _amount;
420     }
421 
422     function spendBalanceFamiliars(address _address, uint256 _amount) public {
423         require(spendingEnabled, "Balance spending functions are disabled.");
424         require(msg.sender == familiars, "Not Allowed.");
425         require(bank[_address] >= _amount, "Not Enough $STYX.");
426         bank[_address] -= _amount;
427     }
428 
429     function spendBalanceTowers(address _address, uint256 _amount) public {
430         require(spendingEnabled, "Balance spending functions are disabled.");
431         require(msg.sender == towers, "Not Allowed.");
432         require(bank[_address] >= _amount, "Not Enough $STYX.");
433         bank[_address] -= _amount;
434     }
435 
436     function addStyxBalance(address _address, uint256 _amount)
437         public
438         onlyOwner
439     {
440         bank[_address] += _amount;
441     }
442 
443     function decrStyxBalance(address _address, uint256 _amount)
444         public
445         onlyOwner
446     {
447         require(bank[_address] >= _amount, "Not Enough $STYX.");
448         bank[_address] -= _amount;
449     }
450 
451     function setStyxBalance(address _address, uint256 _amount)
452         public
453         onlyOwner
454     {
455         bank[_address] = _amount;
456     }
457 
458     //Only Owner
459     function setHellspawnAddress(address _address) public onlyOwner {
460         hellspawn = _address;
461     }
462 
463     function setFamiliarsAddress(address _address) public onlyOwner {
464         familiars = _address;
465     }
466 
467     function setTowersAddress(address _address) public onlyOwner {
468         towers = _address;
469     }
470 
471     function toggleSpending(bool _state) public onlyOwner {
472         spendingEnabled = _state;
473     }
474 
475 }