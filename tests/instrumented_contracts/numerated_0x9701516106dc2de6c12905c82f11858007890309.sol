1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 library Address {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * Serials of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      */
32     function isContract(address account) internal view returns (bool) {
33         // This method relies on extcodesize, which returns 0 for contracts in
34         // construction, since the code is only stored at the end of the
35         // constructor execution.
36         uint256 size;
37         // solhint-disable-next-line no-inline-assembly
38         assembly {size := extcodesize(account)}
39         return size > 0;
40     }
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
60         (bool success,) = recipient.call{value : amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82         return functionCall(target, data, "Address: low-level call failed");
83     }
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
91         return functionCallWithValue(target, data, 0, errorMessage);
92     }
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107     /**
108      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
109      * with `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         require(isContract(target), "Address: call to non-contract");
116         // solhint-disable-next-line avoid-low-level-calls
117         (bool success, bytes memory returndata) = target.call{value : value}(data);
118         return _verifyCallResult(success, returndata, errorMessage);
119     }
120     /**
121      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
122      * but performing a static call.
123      *
124      * _Available since v3.3._
125      */
126     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
127         return functionStaticCall(target, data, "Address: low-level static call failed");
128     }
129     /**
130      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
131      * but performing a static call.
132      *
133      * _Available since v3.3._
134      */
135     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
136         require(isContract(target), "Address: static call to non-contract");
137         // solhint-disable-next-line avoid-low-level-calls
138         (bool success, bytes memory returndata) = target.staticcall(data);
139         return _verifyCallResult(success, returndata, errorMessage);
140     }
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but performing a delegate call.
144      *
145      * _Available since v3.4._
146      */
147     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
148         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
149     }
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
152      * but performing a delegate call.
153      *
154      * _Available since v3.4._
155      */
156     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
157         require(isContract(target), "Address: delegate call to non-contract");
158         // solhint-disable-next-line avoid-low-level-calls
159         (bool success, bytes memory returndata) = target.delegatecall(data);
160         return _verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns (bytes memory) {
164         if (success) {
165             return returndata;
166         } else {
167             // Look for revert reason and bubble it up if present
168             if (returndata.length > 0) {
169                 // The easiest way to bubble the revert reason is using memory via assembly
170                 // solhint-disable-next-line no-inline-assembly
171                 assembly {
172                     let returndata_size := mload(returndata)
173                     revert(add(32, returndata), returndata_size)
174                 }
175             } else {
176                 revert(errorMessage);
177             }
178         }
179     }
180 }
181 
182 library Strings {
183     /**
184      * @dev Converts a `uint256` to its ASCII `string` representation.
185      */
186     function toString(uint256 value) internal pure returns (string memory) {
187         // Inspired by OraclizeAPI's implementation - MIT licence
188         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
189         if (value == 0) {
190             return "0";
191         }
192         uint256 temp = value;
193         uint256 digits;
194         while (temp != 0) {
195             digits++;
196             temp /= 10;
197         }
198         bytes memory buffer = new bytes(digits);
199         while (value != 0) {
200             digits -= 1;
201             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
202             value /= 10;
203         }
204         return string(buffer);
205     }
206 }
207 
208 abstract contract Ownable is Context {
209     address private _owner;
210 
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212     /**
213      * @dev Initializes the contract setting the deployer as the initial owner.
214      */
215     constructor ()  {
216         address msgSender = _msgSender();
217         _owner = msgSender;
218         emit OwnershipTransferred(address(0), msgSender);
219     }
220     /**
221      * @dev Returns the address of the current owner.
222      */
223     function owner() public view virtual returns (address) {
224         return _owner;
225     }
226     /**
227      * @dev Throws if called by any account other than the owner.
228      */
229     modifier onlyOwner() {
230         require(owner() == _msgSender(), "Ownable: caller is not the owner");
231         _;
232     }
233     /**
234      * @dev Leaves the contract without owner. It will not be possible to call
235      * `onlyOwner` functions anymore. Can only be called by the current owner.
236      *
237      * NOTE: Renouncing ownership will leave the contract without an owner,
238      * thereby removing any functionality that is only available to the owner.
239      */
240     function renounceOwnership() public virtual onlyOwner {
241         emit OwnershipTransferred(_owner, address(0));
242         _owner = address(0);
243     }
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Can only be called by the current owner.
247      */
248     function transferOwnership(address newOwner) public virtual onlyOwner {
249         require(newOwner != address(0), "Ownable: new owner is the zero address");
250         emit OwnershipTransferred(_owner, newOwner);
251         _owner = newOwner;
252     }
253 }
254 
255 interface IERC20 {
256     function transfer(address recipient, uint256 amount) external returns (bool);
257 
258     function transferFrom(
259         address sender,
260         address recipient,
261         uint256 amount
262     ) external returns (bool);
263 }
264 
265 library SafeERC20 {
266     using Address for address;
267 
268     function safeTransfer(
269         IERC20 token,
270         address to,
271         uint256 value
272     ) internal {
273         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
274     }
275 
276     function safeTransferFrom(
277         IERC20 token,
278         address from,
279         address to,
280         uint256 value
281     ) internal {
282         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
283     }
284 
285     /**
286      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
287      * on the return value: the return value is optional (but if data is returned, it must not be false).
288      * @param token The token targeted by the call.
289      * @param data The call data (encoded using abi.encode or one of its variants).
290      */
291     function _callOptionalReturn(IERC20 token, bytes memory data) private {
292         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
293         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
294         // the target address contains contract code and also asserts for success in the low-level call.
295 
296         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
297         if (returndata.length > 0) {
298             // Return data is optional
299             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
300         }
301     }
302 }
303 
304 contract MetaAirdrop is Ownable {
305     using SafeERC20 for IERC20;
306     using Strings for uint256;
307 
308     IERC20 public metaToken;
309     bytes32 public merkleRoot = 0xb3d046f0bb76c505eccfe3cd475ee76e814f6014492fe71c399fb3f620b2d401;
310     mapping(address => uint256) public alreadyClaimed;
311     uint8 private unlocked = 1;
312 
313     modifier lock() {
314         require(unlocked == 1, 'Contract: LOCKED');
315         unlocked = 0;
316         _;
317         unlocked = 1;
318     }
319 
320     constructor(IERC20 _metaToken) {
321         metaToken = _metaToken;
322     }
323 
324     function claim(bytes32[] calldata merkleProof, uint256 maxCount) public lock {
325         require(tx.origin == msg.sender, 'origin is not msg sender');
326         require(alreadyClaimed[msg.sender] < maxCount, "already claim");
327         require(_verify(merkleProof, msg.sender, maxCount), "Invalid proof");
328         alreadyClaimed[msg.sender] = maxCount;
329         metaToken.safeTransfer(msg.sender, maxCount);
330     }
331 
332     function _verify(
333         bytes32[] calldata merkleProof,
334         address sender,
335         uint256 maxAmount
336     ) private view returns (bool) {
337         bytes32 leaf = keccak256(abi.encodePacked(sender, maxAmount.toString()));
338         return processProof(merkleProof, leaf) == merkleRoot;
339         //save gas
340     }
341 
342     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
343         bytes32 computedHash = leaf;
344         for (uint256 i = 0; i < proof.length; i++) {
345             bytes32 proofElement = proof[i];
346             if (computedHash <= proofElement) {
347                 // Hash(current computed hash + current element of the proof)
348                 computedHash = _efficientHash(computedHash, proofElement);
349             } else {
350                 // Hash(current element of the proof + current computed hash)
351                 computedHash = _efficientHash(proofElement, computedHash);
352             }
353         }
354         return computedHash;
355     }
356 
357     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
358         assembly {
359             mstore(0x00, a)
360             mstore(0x20, b)
361             value := keccak256(0x00, 0x40)
362         }
363     }
364 
365     function setMerkleProof(bytes32 _merkleRoot) public onlyOwner {
366         merkleRoot = _merkleRoot;
367     }
368 
369     function setMetaToken(IERC20 _metaToken) public onlyOwner {
370         metaToken = _metaToken;
371     }
372 
373     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
374         IERC20(_tokenAddress).safeTransfer(msg.sender, _tokenAmount);
375     }
376 }