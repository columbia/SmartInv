1 // SPDX-License-Identifier: MIT
2 // Made with love by Mai
3 pragma solidity >=0.8.14;
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
52     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
53         bytes memory buffer = new bytes(2 * length + 2);
54         buffer[0] = "0";
55         buffer[1] = "x";
56         for (uint256 i = 2 * length + 1; i > 1; --i) {
57             buffer[i] = _HEX_SYMBOLS[value & 0xf];
58             value >>= 4;
59         }
60         require(value == 0, "Strings: hex length insufficient");
61         return string(buffer);
62     }
63 }
64 
65 
66 /**
67  * @dev Collection of functions related to the address type
68  */
69 library Address {
70     /**
71      * @dev Returns true if `account` is a contract.
72      *
73      * [IMPORTANT]
74      * ====
75      * It is unsafe to assume that an address for which this function returns
76      * false is an externally-owned account (EOA) and not a contract.
77      *
78      * Among others, `isContract` will return false for the following
79      * types of addresses:
80      *
81      *  - an externally-owned account
82      *  - a contract in construction
83      *  - an address where a contract will be created
84      *  - an address where a contract lived, but was destroyed
85      * ====
86      *
87      * [IMPORTANT]
88      * ====
89      * You shouldn't rely on `isContract` to protect against flash loan attacks!
90      *
91      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
92      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
93      * constructor.
94      * ====
95      */
96     function isContract(address account) internal view returns (bool) {
97         // This method relies on extcodesize/address.code.length, which returns 0
98         // for contracts in construction, since the code is only stored at the end
99         // of the constructor execution.
100 
101         return account.code.length > 0;
102     }
103 
104     /**
105      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
106      * `recipient`, forwarding all available gas and reverting on errors.
107      *
108      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
109      * of certain opcodes, possibly making contracts go over the 2300 gas limit
110      * imposed by `transfer`, making them unable to receive funds via
111      * `transfer`. {sendValue} removes this limitation.
112      *
113      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
114      *
115      * IMPORTANT: because control is transferred to `recipient`, care must be
116      * taken to not create reentrancy vulnerabilities. Consider using
117      * {ReentrancyGuard} or the
118      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
119      */
120     function sendValue(address payable recipient, uint256 amount) internal {
121         require(address(this).balance >= amount, "Address: insufficient balance");
122 
123         (bool success, ) = recipient.call{value: amount}("");
124         require(success, "Address: unable to send value, recipient may have reverted");
125     }
126 
127     /**
128      * @dev Performs a Solidity function call using a low level `call`. A
129      * plain `call` is an unsafe replacement for a function call: use this
130      * function instead.
131      *
132      * If `target` reverts with a revert reason, it is bubbled up by this
133      * function (like regular Solidity function calls).
134      *
135      * Returns the raw returned data. To convert to the expected return value,
136      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
137      *
138      * Requirements:
139      *
140      * - `target` must be a contract.
141      * - calling `target` with `data` must not revert.
142      *
143      * _Available since v3.1._
144      */
145     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
146         return functionCall(target, data, "Address: low-level call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
151      * `errorMessage` as a fallback revert reason when `target` reverts.
152      *
153      * _Available since v3.1._
154      */
155     function functionCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal returns (bytes memory) {
160         return functionCallWithValue(target, data, 0, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but also transferring `value` wei to `target`.
166      *
167      * Requirements:
168      *
169      * - the calling contract must have an ETH balance of at least `value`.
170      * - the called Solidity function must be `payable`.
171      *
172      * _Available since v3.1._
173      */
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
184      * with `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(address(this).balance >= value, "Address: insufficient balance for call");
195         require(isContract(target), "Address: call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.call{value: value}(data);
198         return verifyCallResult(success, returndata, errorMessage);
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
217     function functionStaticCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal view returns (bytes memory) {
222         require(isContract(target), "Address: static call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.staticcall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a delegate call.
231      *
232      * _Available since v3.4._
233      */
234     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
235         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a delegate call.
241      *
242      * _Available since v3.4._
243      */
244     function functionDelegateCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal returns (bytes memory) {
249         require(isContract(target), "Address: delegate call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.delegatecall(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
257      * revert reason using the provided one.
258      *
259      * _Available since v4.3._
260      */
261     function verifyCallResult(
262         bool success,
263         bytes memory returndata,
264         string memory errorMessage
265     ) internal pure returns (bytes memory) {
266         if (success) {
267             return returndata;
268         } else {
269             // Look for revert reason and bubble it up if present
270             if (returndata.length > 0) {
271                 // The easiest way to bubble the revert reason is using memory via assembly
272 
273                 assembly {
274                     let returndata_size := mload(returndata)
275                     revert(add(32, returndata), returndata_size)
276                 }
277             } else {
278                 revert(errorMessage);
279             }
280         }
281     }
282 }
283 
284 interface ILayerZeroUserApplicationConfig {
285     // @notice set the configuration of the LayerZero messaging library of the specified version
286     // @param _version - messaging library version
287     // @param _chainId - the chainId for the pending config change
288     // @param _configType - type of configuration. every messaging library has its own convention.
289     // @param _config - configuration in the bytes. can encode arbitrary content.
290     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
291 
292     // @notice set the send() LayerZero messaging library version to _version
293     // @param _version - new messaging library version
294     function setSendVersion(uint16 _version) external;
295 
296     // @notice set the lzReceive() LayerZero messaging library version to _version
297     // @param _version - new messaging library version
298     function setReceiveVersion(uint16 _version) external;
299 
300     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
301     // @param _srcChainId - the chainId of the source chain
302     // @param _srcAddress - the contract address of the source contract at the source chain
303     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
304 }
305 
306 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
307     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
308     // @param _dstChainId - the destination chain identifier
309     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
310     // @param _payload - a custom bytes payload to send to the destination contract
311     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
312     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
313     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
314     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
315 
316     // @notice used by the messaging library to publish verified payload
317     // @param _srcChainId - the source chain identifier
318     // @param _srcAddress - the source contract (as bytes) at the source chain
319     // @param _dstAddress - the address on destination chain
320     // @param _nonce - the unbound message ordering nonce
321     // @param _gasLimit - the gas limit for external contract execution
322     // @param _payload - verified payload to send to the destination contract
323     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
324 
325     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
326     // @param _srcChainId - the source chain identifier
327     // @param _srcAddress - the source chain contract address
328     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
329 
330     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
331     // @param _srcAddress - the source chain contract address
332     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
333 
334     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
335     // @param _dstChainId - the destination chain identifier
336     // @param _userApplication - the user app address on this EVM chain
337     // @param _payload - the custom message to send over LayerZero
338     // @param _payInZRO - if false, user app pays the protocol fee in native token
339     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
340     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
341 
342     // @notice get this Endpoint's immutable source identifier
343     function getChainId() external view returns (uint16);
344 
345     // @notice the interface to retry failed message on this Endpoint destination
346     // @param _srcChainId - the source chain identifier
347     // @param _srcAddress - the source chain contract address
348     // @param _payload - the payload to be retried
349     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
350 
351     // @notice query if any STORED payload (message blocking) at the endpoint.
352     // @param _srcChainId - the source chain identifier
353     // @param _srcAddress - the source chain contract address
354     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
355 
356     // @notice query if the _libraryAddress is valid for sending msgs.
357     // @param _userApplication - the user app address on this EVM chain
358     function getSendLibraryAddress(address _userApplication) external view returns (address);
359 
360     // @notice query if the _libraryAddress is valid for receiving msgs.
361     // @param _userApplication - the user app address on this EVM chain
362     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
363 
364     // @notice query if the non-reentrancy guard for send() is on
365     // @return true if the guard is on. false otherwise
366     function isSendingPayload() external view returns (bool);
367 
368     // @notice query if the non-reentrancy guard for receive() is on
369     // @return true if the guard is on. false otherwise
370     function isReceivingPayload() external view returns (bool);
371 
372     // @notice get the configuration of the LayerZero messaging library of the specified version
373     // @param _version - messaging library version
374     // @param _chainId - the chainId for the pending config change
375     // @param _userApplication - the contract address of the user application
376     // @param _configType - type of configuration. every messaging library has its own convention.
377     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
378 
379     // @notice get the send() LayerZero messaging library version
380     // @param _userApplication - the contract address of the user application
381     function getSendVersion(address _userApplication) external view returns (uint16);
382 
383     // @notice get the lzReceive() LayerZero messaging library version
384     // @param _userApplication - the contract address of the user application
385     function getReceiveVersion(address _userApplication) external view returns (uint16);
386 }
387 
388 error CallerNotOwner();
389 error NewOwnerAddressZero();
390 
391 abstract contract ERC721Omni {
392     using Address for address;
393     using Strings for uint256;
394 
395     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
396     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
397     event Transfer(address indexed from, address indexed to, uint256 indexed id);
398     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     string public name;
402     string public symbol;
403     address public owner;
404     ILayerZeroEndpoint internal endpoint;
405 
406     struct FailedMessages {
407         uint payloadLength;
408         bytes32 payloadHash;
409     }
410 
411     struct addressData {
412         uint128 balance;
413         uint128 huntlistMinted;
414     }
415 
416     struct tokenData {
417         address tokenHolder;
418         uint96 timestampHolder;//Maybe if you guys like your hunters we can do cool stuff with this
419     }
420 
421     mapping(uint256 => tokenData) internal _ownerOf;
422     mapping(address => addressData) internal _addressData;
423 
424     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
425     mapping(uint16 => bytes) public trustedRemoteLookup;
426     mapping(uint256 => address) public getApproved;
427     mapping(address => mapping(address => bool)) public isApprovedForAll;
428 
429     constructor(string memory _name, string memory _symbol) {
430         name = _name;
431         symbol = _symbol;
432         _transferOwnership(msg.sender);
433     }
434 
435     function ownerOf(uint256 id) public view virtual returns (address) {
436         require(_ownerOf[id].tokenHolder != address(0), "Nonexistent Token");
437         return _ownerOf[id].tokenHolder;
438     }
439 
440     function balanceOf(address _owner) public view virtual returns (uint256) {
441         require(_owner != address(0), "Zero Address");
442         return _addressData[_owner].balance;
443     }
444 
445     function durationTimestamp(uint256 tokenId) public view virtual returns (uint256) {
446         return _ownerOf[tokenId].timestampHolder;
447     }
448 
449     function huntlistMinted(address _owner) public view virtual returns (uint256) {
450         require(_owner != address(0), "Zero Address");
451         return _addressData[_owner].huntlistMinted;
452     }
453 
454     function transferFrom(address from, address to, uint256 tokenId) public {
455         require(from == _ownerOf[tokenId].tokenHolder, "Non Owner");
456         require(to != address(0), "Zero Address");
457 
458         require(msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[tokenId],
459             "Lacks Permissions"
460         );
461 
462         unchecked {
463             _addressData[from].balance--;
464             _addressData[to].balance++;
465         }
466 
467         _ownerOf[tokenId].tokenHolder = to;
468         _ownerOf[tokenId].timestampHolder = uint96(block.timestamp);
469         delete getApproved[tokenId];
470         emit Transfer(from, to, tokenId);
471     }
472 
473     function safeTransferFrom(address from, address to, uint256 tokenId) public {
474         transferFrom(from, to, tokenId);
475 
476         require(to.code.length == 0 ||
477                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, tokenId, "") ==
478                 ERC721TokenReceiver.onERC721Received.selector,
479             "Unsafe Transfer"
480         );
481     }
482 
483     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public {
484         transferFrom(from, to, tokenId);
485 
486         require(to.code.length == 0 ||
487                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, tokenId, data) ==
488                 ERC721TokenReceiver.onERC721Received.selector,
489             "Unsafe Transfer"
490         );
491     }
492 
493     function setApprovalForAll(address operator, bool approved) public {
494         isApprovedForAll[msg.sender][operator] = approved;
495         emit ApprovalForAll(msg.sender, operator, approved);
496     }
497 
498     function approve(address spender, uint256 tokenId) public {
499         address _owner = _ownerOf[tokenId].tokenHolder;
500         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender], "Lacks Permissions");
501 
502         getApproved[tokenId] = spender;
503         emit Approval(_owner, spender, tokenId);
504     }
505 
506     function _mint(address to, uint256 tokenId) internal {
507         require(to != address(0), "Zero Address");
508         require(_ownerOf[tokenId].tokenHolder == address(0), "Already Exists");
509 
510         unchecked {
511             _addressData[to].balance++;
512         }
513 
514         _ownerOf[tokenId].tokenHolder = to;
515         _ownerOf[tokenId].timestampHolder = uint96(block.timestamp);
516         emit Transfer(address(0), to, tokenId);
517     }
518 
519     function _safeMint(address to, uint256 tokenId) internal {
520         _mint(to, tokenId);
521 
522         require(to.code.length == 0 ||
523                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), tokenId, "") ==
524                 ERC721TokenReceiver.onERC721Received.selector,
525             "Unsafe Mint"
526         );
527     }
528 
529     function _safeMint(address to, uint256 tokenId, bytes memory data) internal {
530         _mint(to, tokenId);
531 
532         require(to.code.length == 0 ||
533                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), tokenId, data) ==
534                 ERC721TokenReceiver.onERC721Received.selector,
535             "Unsafe Mint"
536         );
537     }
538 
539     function _burn(uint256 tokenId) internal {
540         address _owner = _ownerOf[tokenId].tokenHolder;
541         require(_owner != address(0), "Nonexistent Token");
542 
543         unchecked {
544             _addressData[_owner].balance--;
545         }
546 
547         delete _ownerOf[tokenId];
548         delete getApproved[tokenId];
549 
550         emit Transfer(_owner, address(0), tokenId);
551     }
552 
553     function baseURI() public view virtual returns (string memory) {
554         return '';
555     }
556 
557     function tokenURI(uint256 tokenId) public view returns (string memory) {
558         require(_ownerOf[tokenId].tokenHolder != address(0), "Nonexistent Token");
559         string memory _baseURI = baseURI();
560         return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenId.toString())) : '';
561     }
562 
563     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
564         return
565             interfaceId == 0x01ffc9a7 ||
566             interfaceId == 0x80ac58cd ||
567             interfaceId == 0x5b5e139f;
568     }
569 
570     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external {
571         require(msg.sender == address(endpoint)); 
572         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]), 
573             "NonblockingReceiver: invalid source sending contract");
574 
575         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
576         } catch {
577             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
578             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
579         }
580     }
581 
582     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
583         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
584         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
585     }
586 
587     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
588 
589     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
590         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
591     }
592 
593     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
594         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
595         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
596         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
597         failedMsg.payloadLength = 0;
598         failedMsg.payloadHash = bytes32(0);
599         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
600     }
601 
602     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
603         trustedRemoteLookup[_chainId] = _trustedRemote;
604     }
605 
606     function renounceOwnership() public onlyOwner {
607         _transferOwnership(address(0));
608     }
609 
610     function transferOwnership(address newOwner) public onlyOwner {
611         if (newOwner == address(0)) revert NewOwnerAddressZero();
612         _transferOwnership(newOwner);
613     }
614 
615     function _transferOwnership(address newOwner) internal {
616         address oldOwner = owner;
617         owner = newOwner;
618         emit OwnershipTransferred(oldOwner, newOwner);
619     }
620 
621     modifier onlyOwner() {
622         if (owner != msg.sender) revert CallerNotOwner();
623         _;
624     }
625 
626 }
627 
628 abstract contract ERC721TokenReceiver {
629     function onERC721Received(address, address, uint256, bytes calldata) external virtual returns (bytes4) {
630         return ERC721TokenReceiver.onERC721Received.selector;
631     }
632 }
633 
634 contract Cyber is ERC721Omni {
635 
636     string private _baseURI = "ipfs://QmS84uLAUvGLverNnvyU8YhsHKJi6E3WnfvuD7qmRmBos2/";
637     uint256 private constant maximumSupply = 6600;
638     uint256 public publicMintedCap = 1980;
639 
640     uint256 public totalSupply;
641     uint256 public publicMinted;
642     uint256 public gasForLzReceive = 350000;
643     bool public depreciatedMint;
644     bool public publicStatus;
645     bool public huntlistStatus;
646     bytes32 public merkleRoot = 0xd6fbbe52742f9b344f0cec438e6e560e182c4aec6a42bbf8e944f227632ba0b3;
647 
648     constructor(address _lzEndpoint) ERC721Omni("Cyber", "Hunters") { 
649         endpoint = ILayerZeroEndpoint(_lzEndpoint); 
650     }
651 
652     modifier callerIsUser() {
653         require(tx.origin == msg.sender, "Contract Caller");
654         _;
655     }
656 
657     function donate() external payable {
658         // thank you friend!
659     }
660 
661     function traverseChains(uint16 _chainId, uint tokenId) public payable {
662         require(msg.sender == ownerOf(tokenId), "You must own the token to traverse");
663         require(trustedRemoteLookup[_chainId].length > 0, "This chain is currently unavailable for travel");
664 
665         _burn(tokenId);
666         totalSupply--;
667 
668         bytes memory payload = abi.encode(msg.sender, tokenId);
669         uint16 version = 1;
670         bytes memory adapterParams = abi.encodePacked(version, gasForLzReceive);
671 
672         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
673         
674         require(msg.value >= messageFee, "msg.value cannot cover messageFee. Requires additional gas");
675 
676         endpoint.send{value: msg.value}(
677             _chainId,                           // Endpoint chainId
678             trustedRemoteLookup[_chainId],      // Endpoint contract
679             payload,                            // Encoded bytes
680             payable(msg.sender),                // Excess fund destination address
681             address(0x0),                       // Unused
682             adapterParams                       // Transaction Parameters 
683         );
684     }
685 
686     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) override internal {
687         (address toAddr, uint tokenId) = abi.decode(_payload, (address, uint));
688         _mint(toAddr, tokenId);
689         totalSupply++;
690     }
691 
692     function publicMint() external callerIsUser {
693         require(publicStatus, "Public mint not active");
694         require(totalSupply < maximumSupply, "Will exceed maximum supply");
695 
696         unchecked {
697             require(publicMinted++ < publicMintedCap, "Public supply depleted");
698             _mint(msg.sender, totalSupply++);
699         }
700    }
701 
702    function huntlistMint(bytes32[] calldata _proof) external callerIsUser {
703        require(huntlistStatus, "Huntlist mint not active");
704         require(verifyProof(_proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not on Huntlist");
705         uint256 temporarySupply = totalSupply;
706         unchecked {
707             require(temporarySupply + 1 < maximumSupply, "Will exceed max supply");
708             require(_addressData[msg.sender].huntlistMinted == 0, "Insufficient Mints Remaining");
709             _addressData[msg.sender].huntlistMinted += uint128(2);
710         }
711         _mint(msg.sender, temporarySupply++);
712         _mint(msg.sender, temporarySupply++);
713         totalSupply = temporarySupply;
714    }
715 
716    function verifyProof(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
717         bytes32 computedHash = leaf;
718 
719         uint256 iterations = proof.length;
720         for (uint256 i; i < iterations; ) {
721             bytes32 proofElement = proof[i++];
722 
723             if (computedHash <= proofElement) {
724                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
725             } else {
726                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
727             }
728 
729         }
730         return computedHash == root;
731     }
732 
733     function burnHunter(uint256 tokenId) external {
734        require(depreciatedMint, "Mint is still active.");
735        require(msg.sender == ownerOf(tokenId) || isApprovedForAll[ownerOf(tokenId)][msg.sender] || msg.sender == getApproved[tokenId], "Lacks Permissions");
736        _burn(tokenId);
737        totalSupply--;
738    }
739 
740    function setPublicState(bool _state) external onlyOwner {
741        require(!depreciatedMint, "Mint is depreciated.");
742        publicStatus = _state;
743    }
744 
745    function setHuntlistState(bool _state) external onlyOwner {
746        require(!depreciatedMint, "Mint is depreciated.");
747        huntlistStatus = _state;
748    }
749 
750    function setPublicMintSupply(uint256 _supply) external onlyOwner {
751        require(!depreciatedMint, "Mint is depreciated.");
752        require(_supply > publicMintedCap, "Cannot reduce mint supply");
753        require(_supply <= maximumSupply, "Cannot exceed maximum supply");
754        publicMintedCap = _supply;
755    }
756 
757   function setRoot(bytes32 _newROOT) external onlyOwner {
758         merkleRoot = _newROOT;
759     }
760 
761   function depreciateMint() external onlyOwner {
762       require(!depreciatedMint, "Mint is already depreciated.");
763       delete publicStatus;
764       delete huntlistStatus;
765       depreciatedMint = true;
766       address deployer = msg.sender;
767       uint256 timestamp = block.timestamp;
768 
769         for (uint256 i; i < 66; ){
770             _ownerOf[i].tokenHolder = deployer;
771             _ownerOf[i].timestampHolder = uint96(timestamp);
772             unchecked {
773                 emit Transfer(address(0), deployer, i++);
774             }
775         }
776 
777         unchecked {
778             _addressData[deployer].balance += 66;
779             totalSupply += 66;
780         }
781   }
782 
783   function setBaseURI(string memory _newURI) external onlyOwner {
784       _baseURI = _newURI;
785   }
786 
787   function setGasForDestinationLzReceive(uint _newGasValue) external onlyOwner {
788       gasForLzReceive = _newGasValue;
789   }
790 
791   function setLzEndpoint(address _lzEndpoint) external onlyOwner {
792       endpoint = ILayerZeroEndpoint(_lzEndpoint);
793   }
794 
795   function baseURI() override public view returns (string memory) {
796       return _baseURI;
797   }
798 
799   function withdrawDonations() external onlyOwner {
800       uint256 currentBalance = address(this).balance;
801       (bool sent, ) = address(msg.sender).call{value: currentBalance}('');
802       require(sent, "Transfer Error");    
803   }
804 
805 }