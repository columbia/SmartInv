1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity 0.8.2;
5 
6 interface IERC165 {
7     /**
8      * @dev Returns true ifa this contract implements the interface defined by
9      * `interfaceId`. See the corresponding
10      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
11      * to learn more about how these ids are created.
12      *
13      * This function call must use less than 30 000 gas.
14      */
15     function supportsInterface(bytes4 interfaceId) external view returns (bool);
16 }
17 interface IERC721 {
18     function safeTransferFrom(address from, address to, uint256 tokenId) external;
19     function setApprovalForAll(address operator, bool _approved) external;
20 }
21 interface NFT2D {
22     function getTokenDetails(uint256 index) external view returns (uint128 lastvalue, uint32 aType, uint32 customDetails, uint32 lastTx, uint32 lastPayment);
23 }
24 interface NFT3D {
25     function getTokenDetails(uint256 index) external view returns (uint32 aType, uint32 customDetails, uint32 lastTx, uint32 lastPayment, uint256 initialvalue, string memory coin);
26 }
27 abstract contract ERC165 is IERC165 {
28     /**
29      * @dev Mapping of interface ids to whether or not it's supported.
30      */
31     mapping(bytes4 => bool) private _supportedInterfaces;
32 
33     constructor () {
34         // Derived contracts need only register support for their own interfaces,
35         // we register support for ERC165 itself here
36         _registerInterface(type(IERC165).interfaceId);
37     }
38 
39     /**
40      * @dev See {IERC165-supportsInterface}.
41      *
42      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45         return _supportedInterfaces[interfaceId];
46     }
47 
48     /**
49      * @dev Registers the contract as an implementer of the interface defined by
50      * `interfaceId`. Support of the actual ERC165 interface is automatic and
51      * registering its interface id is not required.
52      *
53      * See {IERC165-supportsInterface}.
54      *
55      * Requirements:
56      *
57      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
58      */
59     function _registerInterface(bytes4 interfaceId) internal virtual {
60         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
61         _supportedInterfaces[interfaceId] = true;
62     }
63 }
64 
65 library ECDSA {
66     /**
67      * @dev Returns the address that signed a hashed message (`hash`) with
68      * `signature`. This address can then be used for verification purposes.
69      *
70      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
71      * this function rejects them by requiring the `s` value to be in the lower
72      * half order, and the `v` value to be either 27 or 28.
73      *
74      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
75      * verification to be secure: it is possible to craft signatures that
76      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
77      * this is by receiving a hash of the original message (which may otherwise
78      * be too long), and then calling {toEthSignedMessageHash} on it.
79      *
80      * Documentation for signature generation:
81      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
82      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
83      */
84     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
85         // Divide the signature in r, s and v variables
86         bytes32 r;
87         bytes32 s;
88         uint8 v;
89 
90         // Check the signature length
91         // - case 65: r,s,v signature (standard)
92         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
93         if (signature.length == 65) {
94             // ecrecover takes the signature parameters, and the only way to get them
95             // currently is to use assembly.
96             // solhint-disable-next-line no-inline-assembly
97             assembly {
98                 r := mload(add(signature, 0x20))
99                 s := mload(add(signature, 0x40))
100                 v := byte(0, mload(add(signature, 0x60)))
101             }
102         } else if (signature.length == 64) {
103             // ecrecover takes the signature parameters, and the only way to get them
104             // currently is to use assembly.
105             // solhint-disable-next-line no-inline-assembly
106             assembly {
107                 let vs := mload(add(signature, 0x40))
108                 r := mload(add(signature, 0x20))
109                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
110                 v := add(shr(255, vs), 27)
111             }
112         } else {
113             revert("ECDSA: invalid signature length");
114         }
115 
116         return recover(hash, v, r, s);
117     }
118 
119     /**
120      * @dev Overload of {ECDSA-recover} that receives the `v`,
121      * `r` and `s` signature fields separately.
122      */
123     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
124         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
125         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
126         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
127         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
128         //
129         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
130         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
131         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
132         // these malleable signatures as well.
133         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
134         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
135 
136         // If the signature is valid (and not malleable), return the signer address
137         address signer = ecrecover(hash, v, r, s);
138         require(signer != address(0), "ECDSA: invalid signature");
139 
140         return signer;
141     }
142 
143     /**
144      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
145      * produces hash corresponding to the one signed with the
146      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
147      * JSON-RPC method as part of EIP-191.
148      *
149      * See {recover}.
150      */
151     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
152         // 32 is the length in bytes of hash,
153         // enforced by the type signature above
154         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
155     }
156 
157     /**
158      * @dev Returns an Ethereum Signed Typed Data, created from a
159      * `domainSeparator` and a `structHash`. This produces hash corresponding
160      * to the one signed with the
161      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
162      * JSON-RPC method as part of EIP-712.
163      *
164      * See {recover}.
165      */
166     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
167         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
168     }
169 }
170 
171 library Address {
172 
173     function isContract(address account) internal view returns (bool) {
174         // This method relies on extcodesize, which returns 0 for contracts in
175         // construction, since the code is only stored at the end of the
176         // constructor execution.
177 
178         uint256 size;
179         // solhint-disable-next-line no-inline-assembly
180         assembly { size := extcodesize(account) }
181         return size > 0;
182     }
183 
184 
185     function sendValue(address payable recipient, uint256 amount) internal {
186         require(address(this).balance >= amount, "Address: insufficient balance");
187 
188         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
189         (bool success, ) = recipient.call{ value: amount }("");
190         require(success, "Address: unable to send value, recipient may have reverted");
191     }
192 
193    
194     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
195       return functionCall(target, data, "Address: low-level call failed");
196     }
197 
198     
199     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, errorMessage);
201     }
202 
203     
204     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
205         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
206     }
207 
208     
209     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
210         require(address(this).balance >= value, "Address: insufficient balance for call");
211         require(isContract(target), "Address: call to non-contract");
212 
213         // solhint-disable-next-line avoid-low-level-calls
214         (bool success, bytes memory returndata) = target.call{ value: value }(data);
215         return _verifyCallResult(success, returndata, errorMessage);
216     }
217 
218    
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     
224     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
225         require(isContract(target), "Address: static call to non-contract");
226 
227         // solhint-disable-next-line avoid-low-level-calls
228         (bool success, bytes memory returndata) = target.staticcall(data);
229         return _verifyCallResult(success, returndata, errorMessage);
230     }
231 
232    
233     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
235     }
236 
237   
238     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
239         require(isContract(target), "Address: delegate call to non-contract");
240 
241         // solhint-disable-next-line avoid-low-level-calls
242         (bool success, bytes memory returndata) = target.delegatecall(data);
243         return _verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
247         if (success) {
248             return returndata;
249         } else {
250             // Look for revert reason and bubble it up if present
251             if (returndata.length > 0) {
252                 // The easiest way to bubble the revert reason is using memory via assembly
253 
254                 // solhint-disable-next-line no-inline-assembly
255                 assembly {
256                     let returndata_size := mload(returndata)
257                     revert(add(32, returndata), returndata_size)
258                 }
259             } else {
260                 revert(errorMessage);
261             }
262         }
263     }
264 }
265 
266 abstract contract Context {
267     function _msgSender() internal view virtual returns (address) {
268         return msg.sender;
269     }
270 
271     function _msgData() internal view virtual returns (bytes calldata) {
272         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
273         return msg.data;
274     }
275 }
276 
277 contract NFTBridgeTransfers is Context, ERC165 {
278 
279     address payable public bankVault;
280     address public nftVault;
281     address public NFT2DAddress;
282     address public NFT3DAddress;
283     uint256 public gasFee;
284     address public unlocker;
285     mapping (uint8 => address) public managers;
286     mapping (bytes32 => bool) public executedTask;
287 
288     uint16 public taskIndex;
289     
290     uint256 public depositIndex;
291     
292     struct Deposit {
293         uint256 assetId;
294         address sender;
295         uint128 value;
296         uint32 lastTrade;
297         uint32 lastPayment;
298         uint32 typeDetail;
299         uint32 customDetails;
300     } 
301     
302     mapping (uint256 => Deposit) public deposits;
303     
304     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
305     
306     modifier isManager() {
307         require(managers[0] == msg.sender || managers[1] == msg.sender || managers[2] == msg.sender, "Not manager");
308         _;
309     }
310     
311     constructor() {
312         NFT2DAddress = 0x57E9a39aE8eC404C08f88740A9e6E306f50c937f;
313         NFT3DAddress = 0xB20217bf3d89667Fa15907971866acD6CcD570C8;
314         bankVault = payable(0xf7A9F6001ff8b499149569C54852226d719f2D76);
315         nftVault = address(this);
316         
317         managers[0] = msg.sender;
318         managers[1] = 0xeA50CE6EBb1a5E4A8F90Bfb35A2fb3c3F0C673ec;
319         managers[2] = 0xB1A951141F1b3A16824241f687C3741459E33225;
320         gasFee = (1 gwei)*70000;
321         
322         _registerInterface(_ERC721_RECEIVED);
323     }
324 
325     function bridgeSend(uint256 _assetId, address _nftAddress) public payable returns (bool) {
326         require((_nftAddress == NFT2DAddress) || (_nftAddress == NFT3DAddress), "Invalid NFT Contract");
327         require(msg.value >= gasFee, "Invalid gas fee");
328         Address.sendValue(bankVault, msg.value);
329         uint32 assetType;
330         uint32 lastTransfer;
331         uint32 lastPayment;
332         uint32 customDetails;
333         uint256 value;
334         if (_nftAddress == NFT2DAddress) {
335             (value, assetType, customDetails, lastTransfer, lastPayment ) = NFT2D(NFT2DAddress).getTokenDetails(_assetId);
336         } else {
337             (assetType, customDetails, lastTransfer, lastPayment, value, ) = NFT3D(NFT3DAddress).getTokenDetails(_assetId);
338         }
339         deposits[depositIndex].assetId = _assetId;
340         deposits[depositIndex].sender = msg.sender;
341         deposits[depositIndex].value = uint128(value);
342         deposits[depositIndex].lastTrade = lastTransfer;
343         deposits[depositIndex].lastPayment = lastPayment;
344         deposits[depositIndex].typeDetail = assetType;
345         deposits[depositIndex].customDetails = customDetails;
346         depositIndex += 1;
347         IERC721(_nftAddress).safeTransferFrom(msg.sender, nftVault, _assetId);
348         return true;
349     }
350     
351     function setBankVault(address _vault, bytes memory _sig) public isManager {
352         uint8 mId = 1;
353         bytes32 taskHash = keccak256(abi.encode(_vault, taskIndex, mId));
354         verifyApproval(taskHash, _sig);
355         bankVault = payable(_vault);
356     }
357     
358     function setGasFee(uint256 _fee, bytes memory _sig) public isManager {
359         uint8 mId = 2;
360         bytes32 taskHash = keccak256(abi.encode(_fee, taskIndex, mId));
361         verifyApproval(taskHash, _sig);
362         gasFee = _fee;
363     }
364     
365     function setUnlocker(address _unlocker, bytes memory _sig) public isManager {
366         uint8 mId = 3;
367         bytes32 taskHash = keccak256(abi.encode(_unlocker, taskIndex, mId));
368         verifyApproval(taskHash, _sig);
369         unlocker = _unlocker;
370     }
371     
372     function setUnlockerApproval(bool _approval, bytes memory _sig) public isManager {
373         uint8 mId = 4;
374         bytes32 taskHash = keccak256(abi.encode(_approval, taskIndex, mId));
375         verifyApproval(taskHash, _sig);
376         IERC721(NFT2DAddress).setApprovalForAll(unlocker, _approval);
377         IERC721(NFT3DAddress).setApprovalForAll(unlocker, _approval);
378     }
379     
380     function verifyApproval(bytes32 _taskHash, bytes memory _sig) private {
381         require(executedTask[_taskHash] == false, "Task already executed");
382         address mSigner = ECDSA.recover(ECDSA.toEthSignedMessageHash(_taskHash), _sig);
383         require(mSigner == managers[0] || mSigner == managers[1] || mSigner == managers[2], "Invalid signature"  );
384         require(mSigner != msg.sender, "Signature from different managers required");
385         executedTask[_taskHash] = true;
386         taskIndex += 1;
387     }
388     
389     function changeManager(address _manager, uint8 _index, bytes memory _sig) public isManager {
390         require(_index >= 0 && _index <= 2, "Invalid index");
391         uint8 mId = 100;
392         bytes32 taskHash = keccak256(abi.encode(_manager, taskIndex, mId));
393         verifyApproval(taskHash, _sig);
394         managers[_index] = _manager;
395     }
396     
397 
398     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) public returns (bytes4) {
399         return _ERC721_RECEIVED;
400     }
401     
402 
403     
404 }