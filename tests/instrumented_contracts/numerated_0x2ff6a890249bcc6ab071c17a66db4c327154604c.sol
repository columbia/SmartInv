1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity ^0.8.0;
4 
5 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Q&Rdq6qKDWQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QRXt<~'`          ._^cag@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@k*,                         `!jQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@U;                                 ,}Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@g;                                     'w@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@i                                         ~Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@L                  '*Ij}i~                  :@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
17 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@k                  7@@@@@@@D                  =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
18 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!                  k@@@@@@@@                  `Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
19 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;                  k@@@@@@@@                  `Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
20 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;                  k@@@@@@@@                  `Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
21 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@t^^^^^^^^^^^^;~'`  k@@@@@@@@                  `Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
22 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QUz+:'`    k@@@@@@@@                  '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
23 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@K?'           k@@@@@@@@                  X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
24 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b;              k@@@@@@@@                 f@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Q;                k@@@@@@@@               =Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
26 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Q'                 k@@@@@@@@           `;5Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
27 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@7                  k@@@@@@@@       ,~|ZQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
28 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;                  k@@@@@@@@  `',;><<<<<<<<<<<?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
29 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;                  k@@@@@@@@                  `Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
30 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;                  k@@@@@@@@                  `Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
31 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!                  k@@@@@@@@                  `Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
32 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@f                  y@@@@@@@Q                  ~@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
33 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;                  +obDdhL`                 `Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
34 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?                                         :Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
35 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a'                                     `L@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
36 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@k;                                 ,YQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
37 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@QP>'                         `;}Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
38 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Rj7^,`             `';iZWQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
39 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Q#RdqAAKDWQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
40 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
41 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
42 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
43 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
44 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
45 
46 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
47 
48 /**
49  * @dev Interface of the ERC165 standard, as defined in the
50  * https://eips.ethereum.org/EIPS/eip-165[EIP].
51  *
52  * Implementers can declare support of contract interfaces, which can then be
53  * queried by others ({ERC165Checker}).
54  *
55  * For an implementation, see {ERC165}.
56  */
57 interface IERC165 {
58     /**
59      * @dev Returns true if this contract implements the interface defined by
60      * `interfaceId`. See the corresponding
61      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
62      * to learn more about how these ids are created.
63      *
64      * This function call must use less than 30 000 gas.
65      */
66     function supportsInterface(bytes4 interfaceId) external view returns (bool);
67 }
68 
69 /**
70  * @dev Interface of the ONFT Core standard
71  */
72 interface IONFT721Core is IERC165 {
73     /**
74      * @dev Emitted when `_tokenIds[]` are moved from the `_sender` to (`_dstChainId`, `_toAddress`)
75      * `_nonce` is the outbound nonce from
76      */
77     event SendToChain(uint16 indexed _dstChainId, address indexed _from, bytes indexed _toAddress, uint[] _tokenIds);
78     event ReceiveFromChain(uint16 indexed _srcChainId, bytes indexed _srcAddress, address indexed _toAddress, uint[] _tokenIds);
79     event SetMinGasToTransferAndStore(uint256 _minGasToTransferAndStore);
80     event SetDstChainIdToTransferGas(uint16 _dstChainId, uint256 _dstChainIdToTransferGas);
81     event SetDstChainIdToBatchLimit(uint16 _dstChainId, uint256 _dstChainIdToBatchLimit);
82 
83     /**
84      * @dev Emitted when `_payload` was received from lz, but not enough gas to deliver all tokenIds
85      */
86     event CreditStored(bytes32 _hashedPayload, bytes _payload);
87     /**
88      * @dev Emitted when `_hashedPayload` has been completely delivered
89      */
90     event CreditCleared(bytes32 _hashedPayload);
91 
92     /**
93      * @dev send token `_tokenId` to (`_dstChainId`, `_toAddress`) from `_from`
94      * `_toAddress` can be any size depending on the `dstChainId`.
95      * `_zroPaymentAddress` set to address(0x0) if not paying in ZRO (LayerZero Token)
96      * `_adapterParams` is a flexible bytes array to indicate messaging adapter services
97      */
98     function sendFrom(address _from, uint16 _dstChainId, bytes calldata _toAddress, uint _tokenId, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
99     /**
100      * @dev send tokens `_tokenIds[]` to (`_dstChainId`, `_toAddress`) from `_from`
101      * `_toAddress` can be any size depending on the `dstChainId`.
102      * `_zroPaymentAddress` set to address(0x0) if not paying in ZRO (LayerZero Token)
103      * `_adapterParams` is a flexible bytes array to indicate messaging adapter services
104      */
105     function sendBatchFrom(address _from, uint16 _dstChainId, bytes calldata _toAddress, uint[] calldata _tokenIds, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
106 
107     /**
108      * @dev estimate send token `_tokenId` to (`_dstChainId`, `_toAddress`)
109      * _dstChainId - L0 defined chain id to send tokens too
110      * _toAddress - dynamic bytes array which contains the address to whom you are sending tokens to on the dstChain
111      * _tokenId - token Id to transfer
112      * _useZro - indicates to use zro to pay L0 fees
113      * _adapterParams - flexible bytes array to indicate messaging adapter services in L0
114      */
115     function estimateSendFee(uint16 _dstChainId, bytes calldata _toAddress, uint _tokenId, bool _useZro, bytes calldata _adapterParams) external view returns (uint nativeFee, uint zroFee);
116     /**
117      * @dev estimate send token `_tokenId` to (`_dstChainId`, `_toAddress`)
118      * _dstChainId - L0 defined chain id to send tokens too
119      * _toAddress - dynamic bytes array which contains the address to whom you are sending tokens to on the dstChain
120      * _tokenIds[] - token Ids to transfer
121      * _useZro - indicates to use zro to pay L0 fees
122      * _adapterParams - flexible bytes array to indicate messaging adapter services in L0
123      */
124     function estimateSendBatchFee(uint16 _dstChainId, bytes calldata _toAddress, uint[] calldata _tokenIds, bool _useZro, bytes calldata _adapterParams) external view returns (uint nativeFee, uint zroFee);
125 }
126 
127 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
128 
129 /**
130  * @dev Required interface of an ERC721 compliant contract.
131  */
132 interface IERC721 is IERC165 {
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in ``owner``'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
176 
177     /**
178      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
179      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must exist and be owned by `from`.
186      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
188      *
189      * Emits a {Transfer} event.
190      */
191     function safeTransferFrom(address from, address to, uint256 tokenId) external;
192 
193     /**
194      * @dev Transfers `tokenId` token from `from` to `to`.
195      *
196      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
197      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
198      * understand this adds an external call which potentially creates a reentrancy vulnerability.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(address from, address to, uint256 tokenId) external;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external;
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 }
254 
255 /**
256  * @dev Interface of the ONFT standard
257  */
258 interface IONFT721 is IONFT721Core, IERC721 {
259 
260 }
261 
262 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
263 
264 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
265 
266 /**
267  * @dev Provides information about the current execution context, including the
268  * sender of the transaction and its data. While these are generally available
269  * via msg.sender and msg.data, they should not be accessed in such a direct
270  * manner, since when dealing with meta-transactions the account sending and
271  * paying for execution may not be the actual sender (as far as an application
272  * is concerned).
273  *
274  * This contract is only required for intermediate, library-like contracts.
275  */
276 abstract contract Context {
277     function _msgSender() internal view virtual returns (address) {
278         return msg.sender;
279     }
280 
281     function _msgData() internal view virtual returns (bytes calldata) {
282         return msg.data;
283     }
284 }
285 
286 /**
287  * @dev Contract module which provides a basic access control mechanism, where
288  * there is an account (an owner) that can be granted exclusive access to
289  * specific functions.
290  *
291  * By default, the owner account will be the one that deploys the contract. This
292  * can later be changed with {transferOwnership}.
293  *
294  * This module is used through inheritance. It will make available the modifier
295  * `onlyOwner`, which can be applied to your functions to restrict their use to
296  * the owner.
297  */
298 abstract contract Ownable is Context {
299     address private _owner;
300 
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303     /**
304      * @dev Initializes the contract setting the deployer as the initial owner.
305      */
306     constructor() {
307         _transferOwnership(_msgSender());
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         _checkOwner();
315         _;
316     }
317 
318     /**
319      * @dev Returns the address of the current owner.
320      */
321     function owner() public view virtual returns (address) {
322         return _owner;
323     }
324 
325     /**
326      * @dev Throws if the sender is not the owner.
327      */
328     function _checkOwner() internal view virtual {
329         require(owner() == _msgSender(), "Ownable: caller is not the owner");
330     }
331 
332     /**
333      * @dev Leaves the contract without owner. It will not be possible to call
334      * `onlyOwner` functions. Can only be called by the current owner.
335      *
336      * NOTE: Renouncing ownership will leave the contract without an owner,
337      * thereby disabling any functionality that is only available to the owner.
338      */
339     function renounceOwnership() public virtual onlyOwner {
340         _transferOwnership(address(0));
341     }
342 
343     /**
344      * @dev Transfers ownership of the contract to a new account (`newOwner`).
345      * Can only be called by the current owner.
346      */
347     function transferOwnership(address newOwner) public virtual onlyOwner {
348         require(newOwner != address(0), "Ownable: new owner is the zero address");
349         _transferOwnership(newOwner);
350     }
351 
352     /**
353      * @dev Transfers ownership of the contract to a new account (`newOwner`).
354      * Internal function without access restriction.
355      */
356     function _transferOwnership(address newOwner) internal virtual {
357         address oldOwner = _owner;
358         _owner = newOwner;
359         emit OwnershipTransferred(oldOwner, newOwner);
360     }
361 }
362 
363 interface ILayerZeroReceiver {
364     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
365     // @param _srcChainId - the source endpoint identifier
366     // @param _srcAddress - the source sending contract address from the source chain
367     // @param _nonce - the ordered message nonce
368     // @param _payload - the signed payload is the UA bytes has encoded to be sent
369     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
370 }
371 
372 interface ILayerZeroUserApplicationConfig {
373     // @notice set the configuration of the LayerZero messaging library of the specified version
374     // @param _version - messaging library version
375     // @param _chainId - the chainId for the pending config change
376     // @param _configType - type of configuration. every messaging library has its own convention.
377     // @param _config - configuration in the bytes. can encode arbitrary content.
378     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
379 
380     // @notice set the send() LayerZero messaging library version to _version
381     // @param _version - new messaging library version
382     function setSendVersion(uint16 _version) external;
383 
384     // @notice set the lzReceive() LayerZero messaging library version to _version
385     // @param _version - new messaging library version
386     function setReceiveVersion(uint16 _version) external;
387 
388     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
389     // @param _srcChainId - the chainId of the source chain
390     // @param _srcAddress - the contract address of the source contract at the source chain
391     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
392 }
393 
394 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
395     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
396     // @param _dstChainId - the destination chain identifier
397     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
398     // @param _payload - a custom bytes payload to send to the destination contract
399     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
400     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
401     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
402     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
403 
404     // @notice used by the messaging library to publish verified payload
405     // @param _srcChainId - the source chain identifier
406     // @param _srcAddress - the source contract (as bytes) at the source chain
407     // @param _dstAddress - the address on destination chain
408     // @param _nonce - the unbound message ordering nonce
409     // @param _gasLimit - the gas limit for external contract execution
410     // @param _payload - verified payload to send to the destination contract
411     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
412 
413     // @notice get the inboundNonce of a lzApp from a source chain which could be EVM or non-EVM chain
414     // @param _srcChainId - the source chain identifier
415     // @param _srcAddress - the source chain contract address
416     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
417 
418     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
419     // @param _srcAddress - the source chain contract address
420     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
421 
422     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
423     // @param _dstChainId - the destination chain identifier
424     // @param _userApplication - the user app address on this EVM chain
425     // @param _payload - the custom message to send over LayerZero
426     // @param _payInZRO - if false, user app pays the protocol fee in native token
427     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
428     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
429 
430     // @notice get this Endpoint's immutable source identifier
431     function getChainId() external view returns (uint16);
432 
433     // @notice the interface to retry failed message on this Endpoint destination
434     // @param _srcChainId - the source chain identifier
435     // @param _srcAddress - the source chain contract address
436     // @param _payload - the payload to be retried
437     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
438 
439     // @notice query if any STORED payload (message blocking) at the endpoint.
440     // @param _srcChainId - the source chain identifier
441     // @param _srcAddress - the source chain contract address
442     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
443 
444     // @notice query if the _libraryAddress is valid for sending msgs.
445     // @param _userApplication - the user app address on this EVM chain
446     function getSendLibraryAddress(address _userApplication) external view returns (address);
447 
448     // @notice query if the _libraryAddress is valid for receiving msgs.
449     // @param _userApplication - the user app address on this EVM chain
450     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
451 
452     // @notice query if the non-reentrancy guard for send() is on
453     // @return true if the guard is on. false otherwise
454     function isSendingPayload() external view returns (bool);
455 
456     // @notice query if the non-reentrancy guard for receive() is on
457     // @return true if the guard is on. false otherwise
458     function isReceivingPayload() external view returns (bool);
459 
460     // @notice get the configuration of the LayerZero messaging library of the specified version
461     // @param _version - messaging library version
462     // @param _chainId - the chainId for the pending config change
463     // @param _userApplication - the contract address of the user application
464     // @param _configType - type of configuration. every messaging library has its own convention.
465     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
466 
467     // @notice get the send() LayerZero messaging library version
468     // @param _userApplication - the contract address of the user application
469     function getSendVersion(address _userApplication) external view returns (uint16);
470 
471     // @notice get the lzReceive() LayerZero messaging library version
472     // @param _userApplication - the contract address of the user application
473     function getReceiveVersion(address _userApplication) external view returns (uint16);
474 }
475 
476 /*
477  * @title Solidity Bytes Arrays Utils
478  * @author Gonçalo Sá <goncalo.sa@consensys.net>
479  *
480  * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
481  *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
482  */
483 
484 library BytesLib {
485     function concat(
486         bytes memory _preBytes,
487         bytes memory _postBytes
488     )
489     internal
490     pure
491     returns (bytes memory)
492     {
493         bytes memory tempBytes;
494 
495         assembly {
496         // Get a location of some free memory and store it in tempBytes as
497         // Solidity does for memory variables.
498             tempBytes := mload(0x40)
499 
500         // Store the length of the first bytes array at the beginning of
501         // the memory for tempBytes.
502             let length := mload(_preBytes)
503             mstore(tempBytes, length)
504 
505         // Maintain a memory counter for the current write location in the
506         // temp bytes array by adding the 32 bytes for the array length to
507         // the starting location.
508             let mc := add(tempBytes, 0x20)
509         // Stop copying when the memory counter reaches the length of the
510         // first bytes array.
511             let end := add(mc, length)
512 
513             for {
514             // Initialize a copy counter to the start of the _preBytes data,
515             // 32 bytes into its memory.
516                 let cc := add(_preBytes, 0x20)
517             } lt(mc, end) {
518             // Increase both counters by 32 bytes each iteration.
519                 mc := add(mc, 0x20)
520                 cc := add(cc, 0x20)
521             } {
522             // Write the _preBytes data into the tempBytes memory 32 bytes
523             // at a time.
524                 mstore(mc, mload(cc))
525             }
526 
527         // Add the length of _postBytes to the current length of tempBytes
528         // and store it as the new length in the first 32 bytes of the
529         // tempBytes memory.
530             length := mload(_postBytes)
531             mstore(tempBytes, add(length, mload(tempBytes)))
532 
533         // Move the memory counter back from a multiple of 0x20 to the
534         // actual end of the _preBytes data.
535             mc := end
536         // Stop copying when the memory counter reaches the new combined
537         // length of the arrays.
538             end := add(mc, length)
539 
540             for {
541                 let cc := add(_postBytes, 0x20)
542             } lt(mc, end) {
543                 mc := add(mc, 0x20)
544                 cc := add(cc, 0x20)
545             } {
546                 mstore(mc, mload(cc))
547             }
548 
549         // Update the free-memory pointer by padding our last write location
550         // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
551         // next 32 byte block, then round down to the nearest multiple of
552         // 32. If the sum of the length of the two arrays is zero then add
553         // one before rounding down to leave a blank 32 bytes (the length block with 0).
554             mstore(0x40, and(
555             add(add(end, iszero(add(length, mload(_preBytes)))), 31),
556             not(31) // Round down to the nearest 32 bytes.
557             ))
558         }
559 
560         return tempBytes;
561     }
562 
563     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
564         assembly {
565         // Read the first 32 bytes of _preBytes storage, which is the length
566         // of the array. (We don't need to use the offset into the slot
567         // because arrays use the entire slot.)
568             let fslot := sload(_preBytes.slot)
569         // Arrays of 31 bytes or less have an even value in their slot,
570         // while longer arrays have an odd value. The actual length is
571         // the slot divided by two for odd values, and the lowest order
572         // byte divided by two for even values.
573         // If the slot is even, bitwise and the slot with 255 and divide by
574         // two to get the length. If the slot is odd, bitwise and the slot
575         // with -1 and divide by two.
576             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
577             let mlength := mload(_postBytes)
578             let newlength := add(slength, mlength)
579         // slength can contain both the length and contents of the array
580         // if length < 32 bytes so let's prepare for that
581         // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
582             switch add(lt(slength, 32), lt(newlength, 32))
583             case 2 {
584             // Since the new array still fits in the slot, we just need to
585             // update the contents of the slot.
586             // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
587                 sstore(
588                 _preBytes.slot,
589                 // all the modifications to the slot are inside this
590                 // next block
591                 add(
592                 // we can just add to the slot contents because the
593                 // bytes we want to change are the LSBs
594                 fslot,
595                 add(
596                 mul(
597                 div(
598                 // load the bytes from memory
599                 mload(add(_postBytes, 0x20)),
600                 // zero all bytes to the right
601                 exp(0x100, sub(32, mlength))
602                 ),
603                 // and now shift left the number of bytes to
604                 // leave space for the length in the slot
605                 exp(0x100, sub(32, newlength))
606                 ),
607                 // increase length by the double of the memory
608                 // bytes length
609                 mul(mlength, 2)
610                 )
611                 )
612                 )
613             }
614             case 1 {
615             // The stored value fits in the slot, but the combined value
616             // will exceed it.
617             // get the keccak hash to get the contents of the array
618                 mstore(0x0, _preBytes.slot)
619                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
620 
621             // save new length
622                 sstore(_preBytes.slot, add(mul(newlength, 2), 1))
623 
624             // The contents of the _postBytes array start 32 bytes into
625             // the structure. Our first read should obtain the `submod`
626             // bytes that can fit into the unused space in the last word
627             // of the stored array. To get this, we read 32 bytes starting
628             // from `submod`, so the data we read overlaps with the array
629             // contents by `submod` bytes. Masking the lowest-order
630             // `submod` bytes allows us to add that value directly to the
631             // stored value.
632 
633                 let submod := sub(32, slength)
634                 let mc := add(_postBytes, submod)
635                 let end := add(_postBytes, mlength)
636                 let mask := sub(exp(0x100, submod), 1)
637 
638                 sstore(
639                 sc,
640                 add(
641                 and(
642                 fslot,
643                 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
644                 ),
645                 and(mload(mc), mask)
646                 )
647                 )
648 
649                 for {
650                     mc := add(mc, 0x20)
651                     sc := add(sc, 1)
652                 } lt(mc, end) {
653                     sc := add(sc, 1)
654                     mc := add(mc, 0x20)
655                 } {
656                     sstore(sc, mload(mc))
657                 }
658 
659                 mask := exp(0x100, sub(mc, end))
660 
661                 sstore(sc, mul(div(mload(mc), mask), mask))
662             }
663             default {
664             // get the keccak hash to get the contents of the array
665                 mstore(0x0, _preBytes.slot)
666             // Start copying to the last used word of the stored array.
667                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
668 
669             // save new length
670                 sstore(_preBytes.slot, add(mul(newlength, 2), 1))
671 
672             // Copy over the first `submod` bytes of the new data as in
673             // case 1 above.
674                 let slengthmod := mod(slength, 32)
675                 let mlengthmod := mod(mlength, 32)
676                 let submod := sub(32, slengthmod)
677                 let mc := add(_postBytes, submod)
678                 let end := add(_postBytes, mlength)
679                 let mask := sub(exp(0x100, submod), 1)
680 
681                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
682 
683                 for {
684                     sc := add(sc, 1)
685                     mc := add(mc, 0x20)
686                 } lt(mc, end) {
687                     sc := add(sc, 1)
688                     mc := add(mc, 0x20)
689                 } {
690                     sstore(sc, mload(mc))
691                 }
692 
693                 mask := exp(0x100, sub(mc, end))
694 
695                 sstore(sc, mul(div(mload(mc), mask), mask))
696             }
697         }
698     }
699 
700     function slice(
701         bytes memory _bytes,
702         uint256 _start,
703         uint256 _length
704     )
705     internal
706     pure
707     returns (bytes memory)
708     {
709         require(_length + 31 >= _length, "slice_overflow");
710         require(_bytes.length >= _start + _length, "slice_outOfBounds");
711 
712         bytes memory tempBytes;
713 
714         assembly {
715             switch iszero(_length)
716             case 0 {
717             // Get a location of some free memory and store it in tempBytes as
718             // Solidity does for memory variables.
719                 tempBytes := mload(0x40)
720 
721             // The first word of the slice result is potentially a partial
722             // word read from the original array. To read it, we calculate
723             // the length of that partial word and start copying that many
724             // bytes into the array. The first word we copy will start with
725             // data we don't care about, but the last `lengthmod` bytes will
726             // land at the beginning of the contents of the new array. When
727             // we're done copying, we overwrite the full first word with
728             // the actual length of the slice.
729                 let lengthmod := and(_length, 31)
730 
731             // The multiplication in the next line is necessary
732             // because when slicing multiples of 32 bytes (lengthmod == 0)
733             // the following copy loop was copying the origin's length
734             // and then ending prematurely not copying everything it should.
735                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
736                 let end := add(mc, _length)
737 
738                 for {
739                 // The multiplication in the next line has the same exact purpose
740                 // as the one above.
741                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
742                 } lt(mc, end) {
743                     mc := add(mc, 0x20)
744                     cc := add(cc, 0x20)
745                 } {
746                     mstore(mc, mload(cc))
747                 }
748 
749                 mstore(tempBytes, _length)
750 
751             //update free-memory pointer
752             //allocating the array padded to 32 bytes like the compiler does now
753                 mstore(0x40, and(add(mc, 31), not(31)))
754             }
755             //if we want a zero-length slice let's just return a zero-length array
756             default {
757                 tempBytes := mload(0x40)
758             //zero out the 32 bytes slice we are about to return
759             //we need to do it because Solidity does not garbage collect
760                 mstore(tempBytes, 0)
761 
762                 mstore(0x40, add(tempBytes, 0x20))
763             }
764         }
765 
766         return tempBytes;
767     }
768 
769     function toAddress(bytes memory _bytes, uint256 _start) internal pure returns (address) {
770         require(_bytes.length >= _start + 20, "toAddress_outOfBounds");
771         address tempAddress;
772 
773         assembly {
774             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
775         }
776 
777         return tempAddress;
778     }
779 
780     function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
781         require(_bytes.length >= _start + 1 , "toUint8_outOfBounds");
782         uint8 tempUint;
783 
784         assembly {
785             tempUint := mload(add(add(_bytes, 0x1), _start))
786         }
787 
788         return tempUint;
789     }
790 
791     function toUint16(bytes memory _bytes, uint256 _start) internal pure returns (uint16) {
792         require(_bytes.length >= _start + 2, "toUint16_outOfBounds");
793         uint16 tempUint;
794 
795         assembly {
796             tempUint := mload(add(add(_bytes, 0x2), _start))
797         }
798 
799         return tempUint;
800     }
801 
802     function toUint32(bytes memory _bytes, uint256 _start) internal pure returns (uint32) {
803         require(_bytes.length >= _start + 4, "toUint32_outOfBounds");
804         uint32 tempUint;
805 
806         assembly {
807             tempUint := mload(add(add(_bytes, 0x4), _start))
808         }
809 
810         return tempUint;
811     }
812 
813     function toUint64(bytes memory _bytes, uint256 _start) internal pure returns (uint64) {
814         require(_bytes.length >= _start + 8, "toUint64_outOfBounds");
815         uint64 tempUint;
816 
817         assembly {
818             tempUint := mload(add(add(_bytes, 0x8), _start))
819         }
820 
821         return tempUint;
822     }
823 
824     function toUint96(bytes memory _bytes, uint256 _start) internal pure returns (uint96) {
825         require(_bytes.length >= _start + 12, "toUint96_outOfBounds");
826         uint96 tempUint;
827 
828         assembly {
829             tempUint := mload(add(add(_bytes, 0xc), _start))
830         }
831 
832         return tempUint;
833     }
834 
835     function toUint128(bytes memory _bytes, uint256 _start) internal pure returns (uint128) {
836         require(_bytes.length >= _start + 16, "toUint128_outOfBounds");
837         uint128 tempUint;
838 
839         assembly {
840             tempUint := mload(add(add(_bytes, 0x10), _start))
841         }
842 
843         return tempUint;
844     }
845 
846     function toUint256(bytes memory _bytes, uint256 _start) internal pure returns (uint256) {
847         require(_bytes.length >= _start + 32, "toUint256_outOfBounds");
848         uint256 tempUint;
849 
850         assembly {
851             tempUint := mload(add(add(_bytes, 0x20), _start))
852         }
853 
854         return tempUint;
855     }
856 
857     function toBytes32(bytes memory _bytes, uint256 _start) internal pure returns (bytes32) {
858         require(_bytes.length >= _start + 32, "toBytes32_outOfBounds");
859         bytes32 tempBytes32;
860 
861         assembly {
862             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
863         }
864 
865         return tempBytes32;
866     }
867 
868     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
869         bool success = true;
870 
871         assembly {
872             let length := mload(_preBytes)
873 
874         // if lengths don't match the arrays are not equal
875             switch eq(length, mload(_postBytes))
876             case 1 {
877             // cb is a circuit breaker in the for loop since there's
878             //  no said feature for inline assembly loops
879             // cb = 1 - don't breaker
880             // cb = 0 - break
881                 let cb := 1
882 
883                 let mc := add(_preBytes, 0x20)
884                 let end := add(mc, length)
885 
886                 for {
887                     let cc := add(_postBytes, 0x20)
888                 // the next line is the loop condition:
889                 // while(uint256(mc < end) + cb == 2)
890                 } eq(add(lt(mc, end), cb), 2) {
891                     mc := add(mc, 0x20)
892                     cc := add(cc, 0x20)
893                 } {
894                 // if any of these checks fails then arrays are not equal
895                     if iszero(eq(mload(mc), mload(cc))) {
896                     // unsuccess:
897                         success := 0
898                         cb := 0
899                     }
900                 }
901             }
902             default {
903             // unsuccess:
904                 success := 0
905             }
906         }
907 
908         return success;
909     }
910 
911     function equalStorage(
912         bytes storage _preBytes,
913         bytes memory _postBytes
914     )
915     internal
916     view
917     returns (bool)
918     {
919         bool success = true;
920 
921         assembly {
922         // we know _preBytes_offset is 0
923             let fslot := sload(_preBytes.slot)
924         // Decode the length of the stored array like in concatStorage().
925             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
926             let mlength := mload(_postBytes)
927 
928         // if lengths don't match the arrays are not equal
929             switch eq(slength, mlength)
930             case 1 {
931             // slength can contain both the length and contents of the array
932             // if length < 32 bytes so let's prepare for that
933             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
934                 if iszero(iszero(slength)) {
935                     switch lt(slength, 32)
936                     case 1 {
937                     // blank the last byte which is the length
938                         fslot := mul(div(fslot, 0x100), 0x100)
939 
940                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
941                         // unsuccess:
942                             success := 0
943                         }
944                     }
945                     default {
946                     // cb is a circuit breaker in the for loop since there's
947                     //  no said feature for inline assembly loops
948                     // cb = 1 - don't breaker
949                     // cb = 0 - break
950                         let cb := 1
951 
952                     // get the keccak hash to get the contents of the array
953                         mstore(0x0, _preBytes.slot)
954                         let sc := keccak256(0x0, 0x20)
955 
956                         let mc := add(_postBytes, 0x20)
957                         let end := add(mc, mlength)
958 
959                     // the next line is the loop condition:
960                     // while(uint256(mc < end) + cb == 2)
961                         for {} eq(add(lt(mc, end), cb), 2) {
962                             sc := add(sc, 1)
963                             mc := add(mc, 0x20)
964                         } {
965                             if iszero(eq(sload(sc), mload(mc))) {
966                             // unsuccess:
967                                 success := 0
968                                 cb := 0
969                             }
970                         }
971                     }
972                 }
973             }
974             default {
975             // unsuccess:
976                 success := 0
977             }
978         }
979 
980         return success;
981     }
982 }
983 
984 /*
985  * a generic LzReceiver implementation
986  */
987 abstract contract LzApp is Ownable, ILayerZeroReceiver, ILayerZeroUserApplicationConfig {
988     using BytesLib for bytes;
989 
990     // ua can not send payload larger than this by default, but it can be changed by the ua owner
991     uint constant public DEFAULT_PAYLOAD_SIZE_LIMIT = 10000;
992 
993     ILayerZeroEndpoint public immutable lzEndpoint;
994     mapping(uint16 => bytes) public trustedRemoteLookup;
995     mapping(uint16 => mapping(uint16 => uint)) public minDstGasLookup;
996     mapping(uint16 => uint) public payloadSizeLimitLookup;
997     address public precrime;
998 
999     event SetPrecrime(address precrime);
1000     event SetTrustedRemote(uint16 _remoteChainId, bytes _path);
1001     event SetTrustedRemoteAddress(uint16 _remoteChainId, bytes _remoteAddress);
1002     event SetMinDstGas(uint16 _dstChainId, uint16 _type, uint _minDstGas);
1003 
1004     constructor(address _endpoint) {
1005         lzEndpoint = ILayerZeroEndpoint(_endpoint);
1006     }
1007 
1008     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public virtual override {
1009         // lzReceive must be called by the endpoint for security
1010         require(_msgSender() == address(lzEndpoint), "LzApp: invalid endpoint caller");
1011 
1012         bytes memory trustedRemote = trustedRemoteLookup[_srcChainId];
1013         // if will still block the message pathway from (srcChainId, srcAddress). should not receive message from untrusted remote.
1014         require(_srcAddress.length == trustedRemote.length && trustedRemote.length > 0 && keccak256(_srcAddress) == keccak256(trustedRemote), "LzApp: invalid source sending contract");
1015 
1016         _blockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1017     }
1018 
1019     // abstract function - the default behaviour of LayerZero is blocking. See: NonblockingLzApp if you dont need to enforce ordered messaging
1020     function _blockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual;
1021 
1022     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _adapterParams, uint _nativeFee) internal virtual {
1023         bytes memory trustedRemote = trustedRemoteLookup[_dstChainId];
1024         require(trustedRemote.length != 0, "LzApp: destination chain is not a trusted source");
1025         _checkPayloadSize(_dstChainId, _payload.length);
1026         lzEndpoint.send{value: _nativeFee}(_dstChainId, trustedRemote, _payload, _refundAddress, _zroPaymentAddress, _adapterParams);
1027     }
1028 
1029     function _checkGasLimit(uint16 _dstChainId, uint16 _type, bytes memory _adapterParams, uint _extraGas) internal view virtual {
1030         uint providedGasLimit = _getGasLimit(_adapterParams);
1031         uint minGasLimit = minDstGasLookup[_dstChainId][_type] + _extraGas;
1032         require(minGasLimit > 0, "LzApp: minGasLimit not set");
1033         require(providedGasLimit >= minGasLimit, "LzApp: gas limit is too low");
1034     }
1035 
1036     function _getGasLimit(bytes memory _adapterParams) internal pure virtual returns (uint gasLimit) {
1037         require(_adapterParams.length >= 34, "LzApp: invalid adapterParams");
1038         assembly {
1039             gasLimit := mload(add(_adapterParams, 34))
1040         }
1041     }
1042 
1043     function _checkPayloadSize(uint16 _dstChainId, uint _payloadSize) internal view virtual {
1044         uint payloadSizeLimit = payloadSizeLimitLookup[_dstChainId];
1045         if (payloadSizeLimit == 0) { // use default if not set
1046             payloadSizeLimit = DEFAULT_PAYLOAD_SIZE_LIMIT;
1047         }
1048         require(_payloadSize <= payloadSizeLimit, "LzApp: payload size is too large");
1049     }
1050 
1051     //---------------------------UserApplication config----------------------------------------
1052     function getConfig(uint16 _version, uint16 _chainId, address, uint _configType) external view returns (bytes memory) {
1053         return lzEndpoint.getConfig(_version, _chainId, address(this), _configType);
1054     }
1055 
1056     // generic config for LayerZero user Application
1057     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external override onlyOwner {
1058         lzEndpoint.setConfig(_version, _chainId, _configType, _config);
1059     }
1060 
1061     function setSendVersion(uint16 _version) external override onlyOwner {
1062         lzEndpoint.setSendVersion(_version);
1063     }
1064 
1065     function setReceiveVersion(uint16 _version) external override onlyOwner {
1066         lzEndpoint.setReceiveVersion(_version);
1067     }
1068 
1069     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external override onlyOwner {
1070         lzEndpoint.forceResumeReceive(_srcChainId, _srcAddress);
1071     }
1072 
1073     // _path = abi.encodePacked(remoteAddress, localAddress)
1074     // this function set the trusted path for the cross-chain communication
1075     function setTrustedRemote(uint16 _remoteChainId, bytes calldata _path) external onlyOwner {
1076         trustedRemoteLookup[_remoteChainId] = _path;
1077         emit SetTrustedRemote(_remoteChainId, _path);
1078     }
1079 
1080     function setTrustedRemoteAddress(uint16 _remoteChainId, bytes calldata _remoteAddress) external onlyOwner {
1081         trustedRemoteLookup[_remoteChainId] = abi.encodePacked(_remoteAddress, address(this));
1082         emit SetTrustedRemoteAddress(_remoteChainId, _remoteAddress);
1083     }
1084 
1085     function getTrustedRemoteAddress(uint16 _remoteChainId) external view returns (bytes memory) {
1086         bytes memory path = trustedRemoteLookup[_remoteChainId];
1087         require(path.length != 0, "LzApp: no trusted path record");
1088         return path.slice(0, path.length - 20); // the last 20 bytes should be address(this)
1089     }
1090 
1091     function setPrecrime(address _precrime) external onlyOwner {
1092         precrime = _precrime;
1093         emit SetPrecrime(_precrime);
1094     }
1095 
1096     function setMinDstGas(uint16 _dstChainId, uint16 _packetType, uint _minGas) external onlyOwner {
1097         require(_minGas > 0, "LzApp: invalid minGas");
1098         minDstGasLookup[_dstChainId][_packetType] = _minGas;
1099         emit SetMinDstGas(_dstChainId, _packetType, _minGas);
1100     }
1101 
1102     // if the size is 0, it means default size limit
1103     function setPayloadSizeLimit(uint16 _dstChainId, uint _size) external onlyOwner {
1104         payloadSizeLimitLookup[_dstChainId] = _size;
1105     }
1106 
1107     //--------------------------- VIEW FUNCTION ----------------------------------------
1108     function isTrustedRemote(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool) {
1109         bytes memory trustedSource = trustedRemoteLookup[_srcChainId];
1110         return keccak256(trustedSource) == keccak256(_srcAddress);
1111     }
1112 }
1113 
1114 library ExcessivelySafeCall {
1115     uint256 constant LOW_28_MASK =
1116     0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
1117 
1118     /// @notice Use when you _really_ really _really_ don't trust the called
1119     /// contract. This prevents the called contract from causing reversion of
1120     /// the caller in as many ways as we can.
1121     /// @dev The main difference between this and a solidity low-level call is
1122     /// that we limit the number of bytes that the callee can cause to be
1123     /// copied to caller memory. This prevents stupid things like malicious
1124     /// contracts returning 10,000,000 bytes causing a local OOG when copying
1125     /// to memory.
1126     /// @param _target The address to call
1127     /// @param _gas The amount of gas to forward to the remote contract
1128     /// @param _maxCopy The maximum number of bytes of returndata to copy
1129     /// to memory.
1130     /// @param _calldata The data to send to the remote contract
1131     /// @return success and returndata, as `.call()`. Returndata is capped to
1132     /// `_maxCopy` bytes.
1133     function excessivelySafeCall(
1134         address _target,
1135         uint256 _gas,
1136         uint16 _maxCopy,
1137         bytes memory _calldata
1138     ) internal returns (bool, bytes memory) {
1139         // set up for assembly call
1140         uint256 _toCopy;
1141         bool _success;
1142         bytes memory _returnData = new bytes(_maxCopy);
1143         // dispatch message to recipient
1144         // by assembly calling "handle" function
1145         // we call via assembly to avoid memcopying a very large returndata
1146         // returned by a malicious contract
1147         assembly {
1148             _success := call(
1149             _gas, // gas
1150             _target, // recipient
1151             0, // ether value
1152             add(_calldata, 0x20), // inloc
1153             mload(_calldata), // inlen
1154             0, // outloc
1155             0 // outlen
1156             )
1157         // limit our copy to 256 bytes
1158             _toCopy := returndatasize()
1159             if gt(_toCopy, _maxCopy) {
1160                 _toCopy := _maxCopy
1161             }
1162         // Store the length of the copied bytes
1163             mstore(_returnData, _toCopy)
1164         // copy the bytes from returndata[0:_toCopy]
1165             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
1166         }
1167         return (_success, _returnData);
1168     }
1169 
1170     /// @notice Use when you _really_ really _really_ don't trust the called
1171     /// contract. This prevents the called contract from causing reversion of
1172     /// the caller in as many ways as we can.
1173     /// @dev The main difference between this and a solidity low-level call is
1174     /// that we limit the number of bytes that the callee can cause to be
1175     /// copied to caller memory. This prevents stupid things like malicious
1176     /// contracts returning 10,000,000 bytes causing a local OOG when copying
1177     /// to memory.
1178     /// @param _target The address to call
1179     /// @param _gas The amount of gas to forward to the remote contract
1180     /// @param _maxCopy The maximum number of bytes of returndata to copy
1181     /// to memory.
1182     /// @param _calldata The data to send to the remote contract
1183     /// @return success and returndata, as `.call()`. Returndata is capped to
1184     /// `_maxCopy` bytes.
1185     function excessivelySafeStaticCall(
1186         address _target,
1187         uint256 _gas,
1188         uint16 _maxCopy,
1189         bytes memory _calldata
1190     ) internal view returns (bool, bytes memory) {
1191         // set up for assembly call
1192         uint256 _toCopy;
1193         bool _success;
1194         bytes memory _returnData = new bytes(_maxCopy);
1195         // dispatch message to recipient
1196         // by assembly calling "handle" function
1197         // we call via assembly to avoid memcopying a very large returndata
1198         // returned by a malicious contract
1199         assembly {
1200             _success := staticcall(
1201             _gas, // gas
1202             _target, // recipient
1203             add(_calldata, 0x20), // inloc
1204             mload(_calldata), // inlen
1205             0, // outloc
1206             0 // outlen
1207             )
1208         // limit our copy to 256 bytes
1209             _toCopy := returndatasize()
1210             if gt(_toCopy, _maxCopy) {
1211                 _toCopy := _maxCopy
1212             }
1213         // Store the length of the copied bytes
1214             mstore(_returnData, _toCopy)
1215         // copy the bytes from returndata[0:_toCopy]
1216             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
1217         }
1218         return (_success, _returnData);
1219     }
1220 
1221     /**
1222      * @notice Swaps function selectors in encoded contract calls
1223      * @dev Allows reuse of encoded calldata for functions with identical
1224      * argument types but different names. It simply swaps out the first 4 bytes
1225      * for the new selector. This function modifies memory in place, and should
1226      * only be used with caution.
1227      * @param _newSelector The new 4-byte selector
1228      * @param _buf The encoded contract args
1229      */
1230     function swapSelector(bytes4 _newSelector, bytes memory _buf)
1231     internal
1232     pure
1233     {
1234         require(_buf.length >= 4);
1235         uint256 _mask = LOW_28_MASK;
1236         assembly {
1237         // load the first word of
1238             let _word := mload(add(_buf, 0x20))
1239         // mask out the top 4 bytes
1240         // /x
1241             _word := and(_word, _mask)
1242             _word := or(_newSelector, _word)
1243             mstore(add(_buf, 0x20), _word)
1244         }
1245     }
1246 }
1247 
1248 /*
1249  * the default LayerZero messaging behaviour is blocking, i.e. any failed message will block the channel
1250  * this abstract class try-catch all fail messages and store locally for future retry. hence, non-blocking
1251  * NOTE: if the srcAddress is not configured properly, it will still block the message pathway from (srcChainId, srcAddress)
1252  */
1253 abstract contract NonblockingLzApp is LzApp {
1254     using ExcessivelySafeCall for address;
1255 
1256     constructor(address _endpoint) LzApp(_endpoint) {}
1257 
1258     mapping(uint16 => mapping(bytes => mapping(uint64 => bytes32))) public failedMessages;
1259 
1260     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload, bytes _reason);
1261     event RetryMessageSuccess(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes32 _payloadHash);
1262 
1263     // overriding the virtual function in LzReceiver
1264     function _blockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual override {
1265         (bool success, bytes memory reason) = address(this).excessivelySafeCall(gasleft(), 150, abi.encodeWithSelector(this.nonblockingLzReceive.selector, _srcChainId, _srcAddress, _nonce, _payload));
1266         // try-catch all errors/exceptions
1267         if (!success) {
1268             _storeFailedMessage(_srcChainId, _srcAddress, _nonce, _payload, reason);
1269         }
1270     }
1271 
1272     function _storeFailedMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload, bytes memory _reason) internal virtual {
1273         failedMessages[_srcChainId][_srcAddress][_nonce] = keccak256(_payload);
1274         emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload, _reason);
1275     }
1276 
1277     function nonblockingLzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public virtual {
1278         // only internal transaction
1279         require(_msgSender() == address(this), "NonblockingLzApp: caller must be LzApp");
1280         _nonblockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1281     }
1282 
1283     //@notice override this function
1284     function _nonblockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual;
1285 
1286     function retryMessage(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public payable virtual {
1287         // assert there is message to retry
1288         bytes32 payloadHash = failedMessages[_srcChainId][_srcAddress][_nonce];
1289         require(payloadHash != bytes32(0), "NonblockingLzApp: no stored message");
1290         require(keccak256(_payload) == payloadHash, "NonblockingLzApp: invalid payload");
1291         // clear the stored message
1292         failedMessages[_srcChainId][_srcAddress][_nonce] = bytes32(0);
1293         // execute the message. revert if it fails again
1294         _nonblockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1295         emit RetryMessageSuccess(_srcChainId, _srcAddress, _nonce, payloadHash);
1296     }
1297 }
1298 
1299 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1300 
1301 /**
1302  * @dev Implementation of the {IERC165} interface.
1303  *
1304  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1305  * for the additional interface id that will be supported. For example:
1306  *
1307  * ```solidity
1308  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1309  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1310  * }
1311  * ```
1312  *
1313  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1314  */
1315 abstract contract ERC165 is IERC165 {
1316     /**
1317      * @dev See {IERC165-supportsInterface}.
1318      */
1319     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1320         return interfaceId == type(IERC165).interfaceId;
1321     }
1322 }
1323 
1324 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
1325 
1326 /**
1327  * @dev Contract module that helps prevent reentrant calls to a function.
1328  *
1329  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1330  * available, which can be applied to functions to make sure there are no nested
1331  * (reentrant) calls to them.
1332  *
1333  * Note that because there is a single `nonReentrant` guard, functions marked as
1334  * `nonReentrant` may not call one another. This can be worked around by making
1335  * those functions `private`, and then adding `external` `nonReentrant` entry
1336  * points to them.
1337  *
1338  * TIP: If you would like to learn more about reentrancy and alternative ways
1339  * to protect against it, check out our blog post
1340  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1341  */
1342 abstract contract ReentrancyGuard {
1343     // Booleans are more expensive than uint256 or any type that takes up a full
1344     // word because each write operation emits an extra SLOAD to first read the
1345     // slot's contents, replace the bits taken up by the boolean, and then write
1346     // back. This is the compiler's defense against contract upgrades and
1347     // pointer aliasing, and it cannot be disabled.
1348 
1349     // The values being non-zero value makes deployment a bit more expensive,
1350     // but in exchange the refund on every call to nonReentrant will be lower in
1351     // amount. Since refunds are capped to a percentage of the total
1352     // transaction's gas, it is best to keep them low in cases like this one, to
1353     // increase the likelihood of the full refund coming into effect.
1354     uint256 private constant _NOT_ENTERED = 1;
1355     uint256 private constant _ENTERED = 2;
1356 
1357     uint256 private _status;
1358 
1359     constructor() {
1360         _status = _NOT_ENTERED;
1361     }
1362 
1363     /**
1364      * @dev Prevents a contract from calling itself, directly or indirectly.
1365      * Calling a `nonReentrant` function from another `nonReentrant`
1366      * function is not supported. It is possible to prevent this from happening
1367      * by making the `nonReentrant` function external, and making it call a
1368      * `private` function that does the actual work.
1369      */
1370     modifier nonReentrant() {
1371         _nonReentrantBefore();
1372         _;
1373         _nonReentrantAfter();
1374     }
1375 
1376     function _nonReentrantBefore() private {
1377         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1378         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1379 
1380         // Any calls to nonReentrant after this point will fail
1381         _status = _ENTERED;
1382     }
1383 
1384     function _nonReentrantAfter() private {
1385         // By storing the original value once again, a refund is triggered (see
1386         // https://eips.ethereum.org/EIPS/eip-2200)
1387         _status = _NOT_ENTERED;
1388     }
1389 
1390     /**
1391      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1392      * `nonReentrant` function in the call stack.
1393      */
1394     function _reentrancyGuardEntered() internal view returns (bool) {
1395         return _status == _ENTERED;
1396     }
1397 }
1398 
1399 abstract contract ONFT721Core is NonblockingLzApp, ERC165, ReentrancyGuard, IONFT721Core {
1400     uint16 public constant FUNCTION_TYPE_SEND = 1;
1401 
1402     struct StoredCredit {
1403         uint16 srcChainId;
1404         address toAddress;
1405         uint256 index; // which index of the tokenIds remain
1406         bool creditsRemain;
1407     }
1408 
1409     uint256 public minGasToTransferAndStore; // min amount of gas required to transfer, and also store the payload
1410     mapping(uint16 => uint256) public dstChainIdToBatchLimit;
1411     mapping(uint16 => uint256) public dstChainIdToTransferGas; // per transfer amount of gas required to mint/transfer on the dst
1412     mapping(bytes32 => StoredCredit) public storedCredits;
1413 
1414     constructor(uint256 _minGasToTransferAndStore, address _lzEndpoint) NonblockingLzApp(_lzEndpoint) {
1415         require(_minGasToTransferAndStore > 0, "minGasToTransferAndStore must be > 0");
1416         minGasToTransferAndStore = _minGasToTransferAndStore;
1417     }
1418 
1419     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1420         return interfaceId == type(IONFT721Core).interfaceId || super.supportsInterface(interfaceId);
1421     }
1422 
1423     function estimateSendFee(uint16 _dstChainId, bytes memory _toAddress, uint _tokenId, bool _useZro, bytes memory _adapterParams) public view virtual override returns (uint nativeFee, uint zroFee) {
1424         return estimateSendBatchFee(_dstChainId, _toAddress, _toSingletonArray(_tokenId), _useZro, _adapterParams);
1425     }
1426 
1427     function estimateSendBatchFee(uint16 _dstChainId, bytes memory _toAddress, uint[] memory _tokenIds, bool _useZro, bytes memory _adapterParams) public view virtual override returns (uint nativeFee, uint zroFee) {
1428         bytes memory payload = abi.encode(_toAddress, _tokenIds);
1429         return lzEndpoint.estimateFees(_dstChainId, address(this), payload, _useZro, _adapterParams);
1430     }
1431 
1432     function sendFrom(address _from, uint16 _dstChainId, bytes memory _toAddress, uint _tokenId, address payable _refundAddress, address _zroPaymentAddress, bytes memory _adapterParams) public payable virtual override {
1433         _send(_from, _dstChainId, _toAddress, _toSingletonArray(_tokenId), _refundAddress, _zroPaymentAddress, _adapterParams);
1434     }
1435 
1436     function sendBatchFrom(address _from, uint16 _dstChainId, bytes memory _toAddress, uint[] memory _tokenIds, address payable _refundAddress, address _zroPaymentAddress, bytes memory _adapterParams) public payable virtual override {
1437         _send(_from, _dstChainId, _toAddress, _tokenIds, _refundAddress, _zroPaymentAddress, _adapterParams);
1438     }
1439 
1440     function _send(address _from, uint16 _dstChainId, bytes memory _toAddress, uint[] memory _tokenIds, address payable _refundAddress, address _zroPaymentAddress, bytes memory _adapterParams) internal virtual {
1441         // allow 1 by default
1442         require(_tokenIds.length > 0, "tokenIds[] is empty");
1443         require(_tokenIds.length == 1 || _tokenIds.length <= dstChainIdToBatchLimit[_dstChainId], "batch size exceeds dst batch limit");
1444 
1445         for (uint i = 0; i < _tokenIds.length; i++) {
1446             _debitFrom(_from, _dstChainId, _toAddress, _tokenIds[i]);
1447         }
1448 
1449         bytes memory payload = abi.encode(_toAddress, _tokenIds);
1450 
1451         _checkGasLimit(_dstChainId, FUNCTION_TYPE_SEND, _adapterParams, dstChainIdToTransferGas[_dstChainId] * _tokenIds.length);
1452         _lzSend(_dstChainId, payload, _refundAddress, _zroPaymentAddress, _adapterParams, msg.value);
1453         emit SendToChain(_dstChainId, _from, _toAddress, _tokenIds);
1454     }
1455 
1456     function _nonblockingLzReceive(
1457         uint16 _srcChainId,
1458         bytes memory _srcAddress,
1459         uint64, /*_nonce*/
1460         bytes memory _payload
1461     ) internal virtual override {
1462         // decode and load the toAddress
1463         (bytes memory toAddressBytes, uint[] memory tokenIds) = abi.decode(_payload, (bytes, uint[]));
1464 
1465         address toAddress;
1466         assembly {
1467             toAddress := mload(add(toAddressBytes, 20))
1468         }
1469 
1470         uint nextIndex = _creditTill(_srcChainId, toAddress, 0, tokenIds);
1471         if (nextIndex < tokenIds.length) {
1472             // not enough gas to complete transfers, store to be cleared in another tx
1473             bytes32 hashedPayload = keccak256(_payload);
1474             storedCredits[hashedPayload] = StoredCredit(_srcChainId, toAddress, nextIndex, true);
1475             emit CreditStored(hashedPayload, _payload);
1476         }
1477 
1478         emit ReceiveFromChain(_srcChainId, _srcAddress, toAddress, tokenIds);
1479     }
1480 
1481     // Public function for anyone to clear and deliver the remaining batch sent tokenIds
1482     function clearCredits(bytes memory _payload) external virtual nonReentrant {
1483         bytes32 hashedPayload = keccak256(_payload);
1484         require(storedCredits[hashedPayload].creditsRemain, "no credits stored");
1485 
1486         (, uint[] memory tokenIds) = abi.decode(_payload, (bytes, uint[]));
1487 
1488         uint nextIndex = _creditTill(storedCredits[hashedPayload].srcChainId, storedCredits[hashedPayload].toAddress, storedCredits[hashedPayload].index, tokenIds);
1489         require(nextIndex > storedCredits[hashedPayload].index, "not enough gas to process credit transfer");
1490 
1491         if (nextIndex == tokenIds.length) {
1492             // cleared the credits, delete the element
1493             delete storedCredits[hashedPayload];
1494             emit CreditCleared(hashedPayload);
1495         } else {
1496             // store the next index to mint
1497             storedCredits[hashedPayload] = StoredCredit(storedCredits[hashedPayload].srcChainId, storedCredits[hashedPayload].toAddress, nextIndex, true);
1498         }
1499     }
1500 
1501     // When a srcChain has the ability to transfer more chainIds in a single tx than the dst can do.
1502     // Needs the ability to iterate and stop if the minGasToTransferAndStore is not met
1503     function _creditTill(uint16 _srcChainId, address _toAddress, uint _startIndex, uint[] memory _tokenIds) internal returns (uint256){
1504         uint i = _startIndex;
1505         while (i < _tokenIds.length) {
1506             // if not enough gas to process, store this index for next loop
1507             if (gasleft() < minGasToTransferAndStore) break;
1508 
1509             _creditTo(_srcChainId, _toAddress, _tokenIds[i]);
1510             i++;
1511         }
1512 
1513         // indicates the next index to send of tokenIds,
1514         // if i == tokenIds.length, we are finished
1515         return i;
1516     }
1517 
1518     function setMinGasToTransferAndStore(uint256 _minGasToTransferAndStore) external onlyOwner {
1519         require(_minGasToTransferAndStore > 0, "minGasToTransferAndStore must be > 0");
1520         minGasToTransferAndStore = _minGasToTransferAndStore;
1521         emit SetMinGasToTransferAndStore(_minGasToTransferAndStore);
1522     }
1523 
1524     // ensures enough gas in adapter params to handle batch transfer gas amounts on the dst
1525     function setDstChainIdToTransferGas(uint16 _dstChainId, uint256 _dstChainIdToTransferGas) external onlyOwner {
1526         require(_dstChainIdToTransferGas > 0, "dstChainIdToTransferGas must be > 0");
1527         dstChainIdToTransferGas[_dstChainId] = _dstChainIdToTransferGas;
1528         emit SetDstChainIdToTransferGas(_dstChainId, _dstChainIdToTransferGas);
1529     }
1530 
1531     // limit on src the amount of tokens to batch send
1532     function setDstChainIdToBatchLimit(uint16 _dstChainId, uint256 _dstChainIdToBatchLimit) external onlyOwner {
1533         require(_dstChainIdToBatchLimit > 0, "dstChainIdToBatchLimit must be > 0");
1534         dstChainIdToBatchLimit[_dstChainId] = _dstChainIdToBatchLimit;
1535         emit SetDstChainIdToBatchLimit(_dstChainId, _dstChainIdToBatchLimit);
1536     }
1537 
1538     function _debitFrom(address _from, uint16 _dstChainId, bytes memory _toAddress, uint _tokenId) internal virtual;
1539 
1540     function _creditTo(uint16 _srcChainId, address _toAddress, uint _tokenId) internal virtual;
1541 
1542     function _toSingletonArray(uint element) internal pure returns (uint[] memory) {
1543         uint[] memory array = new uint[](1);
1544         array[0] = element;
1545         return array;
1546     }
1547 }
1548 
1549 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/ERC721.sol)
1550 
1551 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1552 
1553 /**
1554  * @title ERC721 token receiver interface
1555  * @dev Interface for any contract that wants to support safeTransfers
1556  * from ERC721 asset contracts.
1557  */
1558 interface IERC721Receiver {
1559     /**
1560      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1561      * by `operator` from `from`, this function is called.
1562      *
1563      * It must return its Solidity selector to confirm the token transfer.
1564      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1565      *
1566      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1567      */
1568     function onERC721Received(
1569         address operator,
1570         address from,
1571         uint256 tokenId,
1572         bytes calldata data
1573     ) external returns (bytes4);
1574 }
1575 
1576 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1577 
1578 /**
1579  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1580  * @dev See https://eips.ethereum.org/EIPS/eip-721
1581  */
1582 interface IERC721Metadata is IERC721 {
1583     /**
1584      * @dev Returns the token collection name.
1585      */
1586     function name() external view returns (string memory);
1587 
1588     /**
1589      * @dev Returns the token collection symbol.
1590      */
1591     function symbol() external view returns (string memory);
1592 
1593     /**
1594      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1595      */
1596     function tokenURI(uint256 tokenId) external view returns (string memory);
1597 }
1598 
1599 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
1600 
1601 /**
1602  * @dev Collection of functions related to the address type
1603  */
1604 library Address {
1605     /**
1606      * @dev Returns true if `account` is a contract.
1607      *
1608      * [IMPORTANT]
1609      * ====
1610      * It is unsafe to assume that an address for which this function returns
1611      * false is an externally-owned account (EOA) and not a contract.
1612      *
1613      * Among others, `isContract` will return false for the following
1614      * types of addresses:
1615      *
1616      *  - an externally-owned account
1617      *  - a contract in construction
1618      *  - an address where a contract will be created
1619      *  - an address where a contract lived, but was destroyed
1620      *
1621      * Furthermore, `isContract` will also return true if the target contract within
1622      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
1623      * which only has an effect at the end of a transaction.
1624      * ====
1625      *
1626      * [IMPORTANT]
1627      * ====
1628      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1629      *
1630      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1631      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1632      * constructor.
1633      * ====
1634      */
1635     function isContract(address account) internal view returns (bool) {
1636         // This method relies on extcodesize/address.code.length, which returns 0
1637         // for contracts in construction, since the code is only stored at the end
1638         // of the constructor execution.
1639 
1640         return account.code.length > 0;
1641     }
1642 
1643     /**
1644      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1645      * `recipient`, forwarding all available gas and reverting on errors.
1646      *
1647      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1648      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1649      * imposed by `transfer`, making them unable to receive funds via
1650      * `transfer`. {sendValue} removes this limitation.
1651      *
1652      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1653      *
1654      * IMPORTANT: because control is transferred to `recipient`, care must be
1655      * taken to not create reentrancy vulnerabilities. Consider using
1656      * {ReentrancyGuard} or the
1657      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1658      */
1659     function sendValue(address payable recipient, uint256 amount) internal {
1660         require(address(this).balance >= amount, "Address: insufficient balance");
1661 
1662         (bool success, ) = recipient.call{value: amount}("");
1663         require(success, "Address: unable to send value, recipient may have reverted");
1664     }
1665 
1666     /**
1667      * @dev Performs a Solidity function call using a low level `call`. A
1668      * plain `call` is an unsafe replacement for a function call: use this
1669      * function instead.
1670      *
1671      * If `target` reverts with a revert reason, it is bubbled up by this
1672      * function (like regular Solidity function calls).
1673      *
1674      * Returns the raw returned data. To convert to the expected return value,
1675      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1676      *
1677      * Requirements:
1678      *
1679      * - `target` must be a contract.
1680      * - calling `target` with `data` must not revert.
1681      *
1682      * _Available since v3.1._
1683      */
1684     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1685         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1686     }
1687 
1688     /**
1689      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1690      * `errorMessage` as a fallback revert reason when `target` reverts.
1691      *
1692      * _Available since v3.1._
1693      */
1694     function functionCall(
1695         address target,
1696         bytes memory data,
1697         string memory errorMessage
1698     ) internal returns (bytes memory) {
1699         return functionCallWithValue(target, data, 0, errorMessage);
1700     }
1701 
1702     /**
1703      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1704      * but also transferring `value` wei to `target`.
1705      *
1706      * Requirements:
1707      *
1708      * - the calling contract must have an ETH balance of at least `value`.
1709      * - the called Solidity function must be `payable`.
1710      *
1711      * _Available since v3.1._
1712      */
1713     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1714         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1715     }
1716 
1717     /**
1718      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1719      * with `errorMessage` as a fallback revert reason when `target` reverts.
1720      *
1721      * _Available since v3.1._
1722      */
1723     function functionCallWithValue(
1724         address target,
1725         bytes memory data,
1726         uint256 value,
1727         string memory errorMessage
1728     ) internal returns (bytes memory) {
1729         require(address(this).balance >= value, "Address: insufficient balance for call");
1730         (bool success, bytes memory returndata) = target.call{value: value}(data);
1731         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1732     }
1733 
1734     /**
1735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1736      * but performing a static call.
1737      *
1738      * _Available since v3.3._
1739      */
1740     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1741         return functionStaticCall(target, data, "Address: low-level static call failed");
1742     }
1743 
1744     /**
1745      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1746      * but performing a static call.
1747      *
1748      * _Available since v3.3._
1749      */
1750     function functionStaticCall(
1751         address target,
1752         bytes memory data,
1753         string memory errorMessage
1754     ) internal view returns (bytes memory) {
1755         (bool success, bytes memory returndata) = target.staticcall(data);
1756         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1757     }
1758 
1759     /**
1760      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1761      * but performing a delegate call.
1762      *
1763      * _Available since v3.4._
1764      */
1765     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1766         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1767     }
1768 
1769     /**
1770      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1771      * but performing a delegate call.
1772      *
1773      * _Available since v3.4._
1774      */
1775     function functionDelegateCall(
1776         address target,
1777         bytes memory data,
1778         string memory errorMessage
1779     ) internal returns (bytes memory) {
1780         (bool success, bytes memory returndata) = target.delegatecall(data);
1781         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1782     }
1783 
1784     /**
1785      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1786      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1787      *
1788      * _Available since v4.8._
1789      */
1790     function verifyCallResultFromTarget(
1791         address target,
1792         bool success,
1793         bytes memory returndata,
1794         string memory errorMessage
1795     ) internal view returns (bytes memory) {
1796         if (success) {
1797             if (returndata.length == 0) {
1798                 // only check isContract if the call was successful and the return data is empty
1799                 // otherwise we already know that it was a contract
1800                 require(isContract(target), "Address: call to non-contract");
1801             }
1802             return returndata;
1803         } else {
1804             _revert(returndata, errorMessage);
1805         }
1806     }
1807 
1808     /**
1809      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1810      * revert reason or using the provided one.
1811      *
1812      * _Available since v4.3._
1813      */
1814     function verifyCallResult(
1815         bool success,
1816         bytes memory returndata,
1817         string memory errorMessage
1818     ) internal pure returns (bytes memory) {
1819         if (success) {
1820             return returndata;
1821         } else {
1822             _revert(returndata, errorMessage);
1823         }
1824     }
1825 
1826     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1827         // Look for revert reason and bubble it up if present
1828         if (returndata.length > 0) {
1829             // The easiest way to bubble the revert reason is using memory via assembly
1830             /// @solidity memory-safe-assembly
1831             assembly {
1832                 let returndata_size := mload(returndata)
1833                 revert(add(32, returndata), returndata_size)
1834             }
1835         } else {
1836             revert(errorMessage);
1837         }
1838     }
1839 }
1840 
1841 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
1842 
1843 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
1844 
1845 /**
1846  * @dev Standard math utilities missing in the Solidity language.
1847  */
1848 library Math {
1849     enum Rounding {
1850         Down, // Toward negative infinity
1851         Up, // Toward infinity
1852         Zero // Toward zero
1853     }
1854 
1855     /**
1856      * @dev Returns the largest of two numbers.
1857      */
1858     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1859         return a > b ? a : b;
1860     }
1861 
1862     /**
1863      * @dev Returns the smallest of two numbers.
1864      */
1865     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1866         return a < b ? a : b;
1867     }
1868 
1869     /**
1870      * @dev Returns the average of two numbers. The result is rounded towards
1871      * zero.
1872      */
1873     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1874         // (a + b) / 2 can overflow.
1875         return (a & b) + (a ^ b) / 2;
1876     }
1877 
1878     /**
1879      * @dev Returns the ceiling of the division of two numbers.
1880      *
1881      * This differs from standard division with `/` in that it rounds up instead
1882      * of rounding down.
1883      */
1884     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1885         // (a + b - 1) / b can overflow on addition, so we distribute.
1886         return a == 0 ? 0 : (a - 1) / b + 1;
1887     }
1888 
1889     /**
1890      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1891      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1892      * with further edits by Uniswap Labs also under MIT license.
1893      */
1894     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
1895         unchecked {
1896             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1897             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1898             // variables such that product = prod1 * 2^256 + prod0.
1899             uint256 prod0; // Least significant 256 bits of the product
1900             uint256 prod1; // Most significant 256 bits of the product
1901             assembly {
1902                 let mm := mulmod(x, y, not(0))
1903                 prod0 := mul(x, y)
1904                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1905             }
1906 
1907             // Handle non-overflow cases, 256 by 256 division.
1908             if (prod1 == 0) {
1909                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
1910                 // The surrounding unchecked block does not change this fact.
1911                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
1912                 return prod0 / denominator;
1913             }
1914 
1915             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1916             require(denominator > prod1, "Math: mulDiv overflow");
1917 
1918             ///////////////////////////////////////////////
1919             // 512 by 256 division.
1920             ///////////////////////////////////////////////
1921 
1922             // Make division exact by subtracting the remainder from [prod1 prod0].
1923             uint256 remainder;
1924             assembly {
1925                 // Compute remainder using mulmod.
1926                 remainder := mulmod(x, y, denominator)
1927 
1928                 // Subtract 256 bit number from 512 bit number.
1929                 prod1 := sub(prod1, gt(remainder, prod0))
1930                 prod0 := sub(prod0, remainder)
1931             }
1932 
1933             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1934             // See https://cs.stackexchange.com/q/138556/92363.
1935 
1936             // Does not overflow because the denominator cannot be zero at this stage in the function.
1937             uint256 twos = denominator & (~denominator + 1);
1938             assembly {
1939                 // Divide denominator by twos.
1940                 denominator := div(denominator, twos)
1941 
1942                 // Divide [prod1 prod0] by twos.
1943                 prod0 := div(prod0, twos)
1944 
1945                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1946                 twos := add(div(sub(0, twos), twos), 1)
1947             }
1948 
1949             // Shift in bits from prod1 into prod0.
1950             prod0 |= prod1 * twos;
1951 
1952             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1953             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1954             // four bits. That is, denominator * inv = 1 mod 2^4.
1955             uint256 inverse = (3 * denominator) ^ 2;
1956 
1957             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1958             // in modular arithmetic, doubling the correct bits in each step.
1959             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1960             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1961             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1962             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1963             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1964             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1965 
1966             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1967             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1968             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1969             // is no longer required.
1970             result = prod0 * inverse;
1971             return result;
1972         }
1973     }
1974 
1975     /**
1976      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1977      */
1978     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
1979         uint256 result = mulDiv(x, y, denominator);
1980         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1981             result += 1;
1982         }
1983         return result;
1984     }
1985 
1986     /**
1987      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1988      *
1989      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1990      */
1991     function sqrt(uint256 a) internal pure returns (uint256) {
1992         if (a == 0) {
1993             return 0;
1994         }
1995 
1996         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1997         //
1998         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1999         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
2000         //
2001         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
2002         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
2003         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
2004         //
2005         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
2006         uint256 result = 1 << (log2(a) >> 1);
2007 
2008         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2009         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2010         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2011         // into the expected uint128 result.
2012         unchecked {
2013             result = (result + a / result) >> 1;
2014             result = (result + a / result) >> 1;
2015             result = (result + a / result) >> 1;
2016             result = (result + a / result) >> 1;
2017             result = (result + a / result) >> 1;
2018             result = (result + a / result) >> 1;
2019             result = (result + a / result) >> 1;
2020             return min(result, a / result);
2021         }
2022     }
2023 
2024     /**
2025      * @notice Calculates sqrt(a), following the selected rounding direction.
2026      */
2027     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2028         unchecked {
2029             uint256 result = sqrt(a);
2030             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2031         }
2032     }
2033 
2034     /**
2035      * @dev Return the log in base 2, rounded down, of a positive value.
2036      * Returns 0 if given 0.
2037      */
2038     function log2(uint256 value) internal pure returns (uint256) {
2039         uint256 result = 0;
2040         unchecked {
2041             if (value >> 128 > 0) {
2042                 value >>= 128;
2043                 result += 128;
2044             }
2045             if (value >> 64 > 0) {
2046                 value >>= 64;
2047                 result += 64;
2048             }
2049             if (value >> 32 > 0) {
2050                 value >>= 32;
2051                 result += 32;
2052             }
2053             if (value >> 16 > 0) {
2054                 value >>= 16;
2055                 result += 16;
2056             }
2057             if (value >> 8 > 0) {
2058                 value >>= 8;
2059                 result += 8;
2060             }
2061             if (value >> 4 > 0) {
2062                 value >>= 4;
2063                 result += 4;
2064             }
2065             if (value >> 2 > 0) {
2066                 value >>= 2;
2067                 result += 2;
2068             }
2069             if (value >> 1 > 0) {
2070                 result += 1;
2071             }
2072         }
2073         return result;
2074     }
2075 
2076     /**
2077      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2078      * Returns 0 if given 0.
2079      */
2080     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2081         unchecked {
2082             uint256 result = log2(value);
2083             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2084         }
2085     }
2086 
2087     /**
2088      * @dev Return the log in base 10, rounded down, of a positive value.
2089      * Returns 0 if given 0.
2090      */
2091     function log10(uint256 value) internal pure returns (uint256) {
2092         uint256 result = 0;
2093         unchecked {
2094             if (value >= 10 ** 64) {
2095                 value /= 10 ** 64;
2096                 result += 64;
2097             }
2098             if (value >= 10 ** 32) {
2099                 value /= 10 ** 32;
2100                 result += 32;
2101             }
2102             if (value >= 10 ** 16) {
2103                 value /= 10 ** 16;
2104                 result += 16;
2105             }
2106             if (value >= 10 ** 8) {
2107                 value /= 10 ** 8;
2108                 result += 8;
2109             }
2110             if (value >= 10 ** 4) {
2111                 value /= 10 ** 4;
2112                 result += 4;
2113             }
2114             if (value >= 10 ** 2) {
2115                 value /= 10 ** 2;
2116                 result += 2;
2117             }
2118             if (value >= 10 ** 1) {
2119                 result += 1;
2120             }
2121         }
2122         return result;
2123     }
2124 
2125     /**
2126      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2127      * Returns 0 if given 0.
2128      */
2129     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2130         unchecked {
2131             uint256 result = log10(value);
2132             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
2133         }
2134     }
2135 
2136     /**
2137      * @dev Return the log in base 256, rounded down, of a positive value.
2138      * Returns 0 if given 0.
2139      *
2140      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2141      */
2142     function log256(uint256 value) internal pure returns (uint256) {
2143         uint256 result = 0;
2144         unchecked {
2145             if (value >> 128 > 0) {
2146                 value >>= 128;
2147                 result += 16;
2148             }
2149             if (value >> 64 > 0) {
2150                 value >>= 64;
2151                 result += 8;
2152             }
2153             if (value >> 32 > 0) {
2154                 value >>= 32;
2155                 result += 4;
2156             }
2157             if (value >> 16 > 0) {
2158                 value >>= 16;
2159                 result += 2;
2160             }
2161             if (value >> 8 > 0) {
2162                 result += 1;
2163             }
2164         }
2165         return result;
2166     }
2167 
2168     /**
2169      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
2170      * Returns 0 if given 0.
2171      */
2172     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2173         unchecked {
2174             uint256 result = log256(value);
2175             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
2176         }
2177     }
2178 }
2179 
2180 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
2181 
2182 /**
2183  * @dev Standard signed math utilities missing in the Solidity language.
2184  */
2185 library SignedMath {
2186     /**
2187      * @dev Returns the largest of two signed numbers.
2188      */
2189     function max(int256 a, int256 b) internal pure returns (int256) {
2190         return a > b ? a : b;
2191     }
2192 
2193     /**
2194      * @dev Returns the smallest of two signed numbers.
2195      */
2196     function min(int256 a, int256 b) internal pure returns (int256) {
2197         return a < b ? a : b;
2198     }
2199 
2200     /**
2201      * @dev Returns the average of two signed numbers without overflow.
2202      * The result is rounded towards zero.
2203      */
2204     function average(int256 a, int256 b) internal pure returns (int256) {
2205         // Formula from the book "Hacker's Delight"
2206         int256 x = (a & b) + ((a ^ b) >> 1);
2207         return x + (int256(uint256(x) >> 255) & (a ^ b));
2208     }
2209 
2210     /**
2211      * @dev Returns the absolute unsigned value of a signed value.
2212      */
2213     function abs(int256 n) internal pure returns (uint256) {
2214         unchecked {
2215             // must be unchecked in order to support `n = type(int256).min`
2216             return uint256(n >= 0 ? n : -n);
2217         }
2218     }
2219 }
2220 
2221 /**
2222  * @dev String operations.
2223  */
2224 library Strings {
2225     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2226     uint8 private constant _ADDRESS_LENGTH = 20;
2227 
2228     /**
2229      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2230      */
2231     function toString(uint256 value) internal pure returns (string memory) {
2232         unchecked {
2233             uint256 length = Math.log10(value) + 1;
2234             string memory buffer = new string(length);
2235             uint256 ptr;
2236             /// @solidity memory-safe-assembly
2237             assembly {
2238                 ptr := add(buffer, add(32, length))
2239             }
2240             while (true) {
2241                 ptr--;
2242                 /// @solidity memory-safe-assembly
2243                 assembly {
2244                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2245                 }
2246                 value /= 10;
2247                 if (value == 0) break;
2248             }
2249             return buffer;
2250         }
2251     }
2252 
2253     /**
2254      * @dev Converts a `int256` to its ASCII `string` decimal representation.
2255      */
2256     function toString(int256 value) internal pure returns (string memory) {
2257         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
2258     }
2259 
2260     /**
2261      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2262      */
2263     function toHexString(uint256 value) internal pure returns (string memory) {
2264         unchecked {
2265             return toHexString(value, Math.log256(value) + 1);
2266         }
2267     }
2268 
2269     /**
2270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2271      */
2272     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2273         bytes memory buffer = new bytes(2 * length + 2);
2274         buffer[0] = "0";
2275         buffer[1] = "x";
2276         for (uint256 i = 2 * length + 1; i > 1; --i) {
2277             buffer[i] = _SYMBOLS[value & 0xf];
2278             value >>= 4;
2279         }
2280         require(value == 0, "Strings: hex length insufficient");
2281         return string(buffer);
2282     }
2283 
2284     /**
2285      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2286      */
2287     function toHexString(address addr) internal pure returns (string memory) {
2288         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2289     }
2290 
2291     /**
2292      * @dev Returns true if the two strings are equal.
2293      */
2294     function equal(string memory a, string memory b) internal pure returns (bool) {
2295         return keccak256(bytes(a)) == keccak256(bytes(b));
2296     }
2297 }
2298 
2299 /**
2300  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2301  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2302  * {ERC721Enumerable}.
2303  */
2304 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2305     using Address for address;
2306     using Strings for uint256;
2307 
2308     // Token name
2309     string private _name;
2310 
2311     // Token symbol
2312     string private _symbol;
2313 
2314     // Mapping from token ID to owner address
2315     mapping(uint256 => address) private _owners;
2316 
2317     // Mapping owner address to token count
2318     mapping(address => uint256) private _balances;
2319 
2320     // Mapping from token ID to approved address
2321     mapping(uint256 => address) private _tokenApprovals;
2322 
2323     // Mapping from owner to operator approvals
2324     mapping(address => mapping(address => bool)) private _operatorApprovals;
2325 
2326     /**
2327      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2328      */
2329     constructor(string memory name_, string memory symbol_) {
2330         _name = name_;
2331         _symbol = symbol_;
2332     }
2333 
2334     /**
2335      * @dev See {IERC165-supportsInterface}.
2336      */
2337     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2338         return
2339             interfaceId == type(IERC721).interfaceId ||
2340             interfaceId == type(IERC721Metadata).interfaceId ||
2341             super.supportsInterface(interfaceId);
2342     }
2343 
2344     /**
2345      * @dev See {IERC721-balanceOf}.
2346      */
2347     function balanceOf(address owner) public view virtual override returns (uint256) {
2348         require(owner != address(0), "ERC721: address zero is not a valid owner");
2349         return _balances[owner];
2350     }
2351 
2352     /**
2353      * @dev See {IERC721-ownerOf}.
2354      */
2355     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2356         address owner = _ownerOf(tokenId);
2357         require(owner != address(0), "ERC721: invalid token ID");
2358         return owner;
2359     }
2360 
2361     /**
2362      * @dev See {IERC721Metadata-name}.
2363      */
2364     function name() public view virtual override returns (string memory) {
2365         return _name;
2366     }
2367 
2368     /**
2369      * @dev See {IERC721Metadata-symbol}.
2370      */
2371     function symbol() public view virtual override returns (string memory) {
2372         return _symbol;
2373     }
2374 
2375     /**
2376      * @dev See {IERC721Metadata-tokenURI}.
2377      */
2378     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2379         _requireMinted(tokenId);
2380 
2381         string memory baseURI = _baseURI();
2382         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2383     }
2384 
2385     /**
2386      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2387      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2388      * by default, can be overridden in child contracts.
2389      */
2390     function _baseURI() internal view virtual returns (string memory) {
2391         return "";
2392     }
2393 
2394     /**
2395      * @dev See {IERC721-approve}.
2396      */
2397     function approve(address to, uint256 tokenId) public virtual override {
2398         address owner = ERC721.ownerOf(tokenId);
2399         require(to != owner, "ERC721: approval to current owner");
2400 
2401         require(
2402             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2403             "ERC721: approve caller is not token owner or approved for all"
2404         );
2405 
2406         _approve(to, tokenId);
2407     }
2408 
2409     /**
2410      * @dev See {IERC721-getApproved}.
2411      */
2412     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2413         _requireMinted(tokenId);
2414 
2415         return _tokenApprovals[tokenId];
2416     }
2417 
2418     /**
2419      * @dev See {IERC721-setApprovalForAll}.
2420      */
2421     function setApprovalForAll(address operator, bool approved) public virtual override {
2422         _setApprovalForAll(_msgSender(), operator, approved);
2423     }
2424 
2425     /**
2426      * @dev See {IERC721-isApprovedForAll}.
2427      */
2428     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2429         return _operatorApprovals[owner][operator];
2430     }
2431 
2432     /**
2433      * @dev See {IERC721-transferFrom}.
2434      */
2435     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
2436         //solhint-disable-next-line max-line-length
2437         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2438 
2439         _transfer(from, to, tokenId);
2440     }
2441 
2442     /**
2443      * @dev See {IERC721-safeTransferFrom}.
2444      */
2445     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
2446         safeTransferFrom(from, to, tokenId, "");
2447     }
2448 
2449     /**
2450      * @dev See {IERC721-safeTransferFrom}.
2451      */
2452     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
2453         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2454         _safeTransfer(from, to, tokenId, data);
2455     }
2456 
2457     /**
2458      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2459      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2460      *
2461      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2462      *
2463      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2464      * implement alternative mechanisms to perform token transfer, such as signature-based.
2465      *
2466      * Requirements:
2467      *
2468      * - `from` cannot be the zero address.
2469      * - `to` cannot be the zero address.
2470      * - `tokenId` token must exist and be owned by `from`.
2471      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2472      *
2473      * Emits a {Transfer} event.
2474      */
2475     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
2476         _transfer(from, to, tokenId);
2477         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2478     }
2479 
2480     /**
2481      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
2482      */
2483     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
2484         return _owners[tokenId];
2485     }
2486 
2487     /**
2488      * @dev Returns whether `tokenId` exists.
2489      *
2490      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2491      *
2492      * Tokens start existing when they are minted (`_mint`),
2493      * and stop existing when they are burned (`_burn`).
2494      */
2495     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2496         return _ownerOf(tokenId) != address(0);
2497     }
2498 
2499     /**
2500      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2501      *
2502      * Requirements:
2503      *
2504      * - `tokenId` must exist.
2505      */
2506     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2507         address owner = ERC721.ownerOf(tokenId);
2508         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2509     }
2510 
2511     /**
2512      * @dev Safely mints `tokenId` and transfers it to `to`.
2513      *
2514      * Requirements:
2515      *
2516      * - `tokenId` must not exist.
2517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2518      *
2519      * Emits a {Transfer} event.
2520      */
2521     function _safeMint(address to, uint256 tokenId) internal virtual {
2522         _safeMint(to, tokenId, "");
2523     }
2524 
2525     /**
2526      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2527      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2528      */
2529     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
2530         _mint(to, tokenId);
2531         require(
2532             _checkOnERC721Received(address(0), to, tokenId, data),
2533             "ERC721: transfer to non ERC721Receiver implementer"
2534         );
2535     }
2536 
2537     /**
2538      * @dev Mints `tokenId` and transfers it to `to`.
2539      *
2540      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2541      *
2542      * Requirements:
2543      *
2544      * - `tokenId` must not exist.
2545      * - `to` cannot be the zero address.
2546      *
2547      * Emits a {Transfer} event.
2548      */
2549     function _mint(address to, uint256 tokenId) internal virtual {
2550         require(to != address(0), "ERC721: mint to the zero address");
2551         require(!_exists(tokenId), "ERC721: token already minted");
2552 
2553         _beforeTokenTransfer(address(0), to, tokenId, 1);
2554 
2555         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
2556         require(!_exists(tokenId), "ERC721: token already minted");
2557 
2558         unchecked {
2559             // Will not overflow unless all 2**256 token ids are minted to the same owner.
2560             // Given that tokens are minted one by one, it is impossible in practice that
2561             // this ever happens. Might change if we allow batch minting.
2562             // The ERC fails to describe this case.
2563             _balances[to] += 1;
2564         }
2565 
2566         _owners[tokenId] = to;
2567 
2568         emit Transfer(address(0), to, tokenId);
2569 
2570         _afterTokenTransfer(address(0), to, tokenId, 1);
2571     }
2572 
2573     /**
2574      * @dev Destroys `tokenId`.
2575      * The approval is cleared when the token is burned.
2576      * This is an internal function that does not check if the sender is authorized to operate on the token.
2577      *
2578      * Requirements:
2579      *
2580      * - `tokenId` must exist.
2581      *
2582      * Emits a {Transfer} event.
2583      */
2584     function _burn(uint256 tokenId) internal virtual {
2585         address owner = ERC721.ownerOf(tokenId);
2586 
2587         _beforeTokenTransfer(owner, address(0), tokenId, 1);
2588 
2589         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
2590         owner = ERC721.ownerOf(tokenId);
2591 
2592         // Clear approvals
2593         delete _tokenApprovals[tokenId];
2594 
2595         unchecked {
2596             // Cannot overflow, as that would require more tokens to be burned/transferred
2597             // out than the owner initially received through minting and transferring in.
2598             _balances[owner] -= 1;
2599         }
2600         delete _owners[tokenId];
2601 
2602         emit Transfer(owner, address(0), tokenId);
2603 
2604         _afterTokenTransfer(owner, address(0), tokenId, 1);
2605     }
2606 
2607     /**
2608      * @dev Transfers `tokenId` from `from` to `to`.
2609      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2610      *
2611      * Requirements:
2612      *
2613      * - `to` cannot be the zero address.
2614      * - `tokenId` token must be owned by `from`.
2615      *
2616      * Emits a {Transfer} event.
2617      */
2618     function _transfer(address from, address to, uint256 tokenId) internal virtual {
2619         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2620         require(to != address(0), "ERC721: transfer to the zero address");
2621 
2622         _beforeTokenTransfer(from, to, tokenId, 1);
2623 
2624         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
2625         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2626 
2627         // Clear approvals from the previous owner
2628         delete _tokenApprovals[tokenId];
2629 
2630         unchecked {
2631             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
2632             // `from`'s balance is the number of token held, which is at least one before the current
2633             // transfer.
2634             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
2635             // all 2**256 token ids to be minted, which in practice is impossible.
2636             _balances[from] -= 1;
2637             _balances[to] += 1;
2638         }
2639         _owners[tokenId] = to;
2640 
2641         emit Transfer(from, to, tokenId);
2642 
2643         _afterTokenTransfer(from, to, tokenId, 1);
2644     }
2645 
2646     /**
2647      * @dev Approve `to` to operate on `tokenId`
2648      *
2649      * Emits an {Approval} event.
2650      */
2651     function _approve(address to, uint256 tokenId) internal virtual {
2652         _tokenApprovals[tokenId] = to;
2653         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2654     }
2655 
2656     /**
2657      * @dev Approve `operator` to operate on all of `owner` tokens
2658      *
2659      * Emits an {ApprovalForAll} event.
2660      */
2661     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
2662         require(owner != operator, "ERC721: approve to caller");
2663         _operatorApprovals[owner][operator] = approved;
2664         emit ApprovalForAll(owner, operator, approved);
2665     }
2666 
2667     /**
2668      * @dev Reverts if the `tokenId` has not been minted yet.
2669      */
2670     function _requireMinted(uint256 tokenId) internal view virtual {
2671         require(_exists(tokenId), "ERC721: invalid token ID");
2672     }
2673 
2674     /**
2675      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2676      * The call is not executed if the target address is not a contract.
2677      *
2678      * @param from address representing the previous owner of the given token ID
2679      * @param to target address that will receive the tokens
2680      * @param tokenId uint256 ID of the token to be transferred
2681      * @param data bytes optional data to send along with the call
2682      * @return bool whether the call correctly returned the expected magic value
2683      */
2684     function _checkOnERC721Received(
2685         address from,
2686         address to,
2687         uint256 tokenId,
2688         bytes memory data
2689     ) private returns (bool) {
2690         if (to.isContract()) {
2691             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2692                 return retval == IERC721Receiver.onERC721Received.selector;
2693             } catch (bytes memory reason) {
2694                 if (reason.length == 0) {
2695                     revert("ERC721: transfer to non ERC721Receiver implementer");
2696                 } else {
2697                     /// @solidity memory-safe-assembly
2698                     assembly {
2699                         revert(add(32, reason), mload(reason))
2700                     }
2701                 }
2702             }
2703         } else {
2704             return true;
2705         }
2706     }
2707 
2708     /**
2709      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2710      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2711      *
2712      * Calling conditions:
2713      *
2714      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
2715      * - When `from` is zero, the tokens will be minted for `to`.
2716      * - When `to` is zero, ``from``'s tokens will be burned.
2717      * - `from` and `to` are never both zero.
2718      * - `batchSize` is non-zero.
2719      *
2720      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2721      */
2722     function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
2723 
2724     /**
2725      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2726      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2727      *
2728      * Calling conditions:
2729      *
2730      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
2731      * - When `from` is zero, the tokens were minted for `to`.
2732      * - When `to` is zero, ``from``'s tokens were burned.
2733      * - `from` and `to` are never both zero.
2734      * - `batchSize` is non-zero.
2735      *
2736      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2737      */
2738     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
2739 
2740     /**
2741      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
2742      *
2743      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
2744      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
2745      * that `ownerOf(tokenId)` is `a`.
2746      */
2747     // solhint-disable-next-line func-name-mixedcase
2748     function __unsafe_increaseBalance(address account, uint256 amount) internal {
2749         _balances[account] += amount;
2750     }
2751 }
2752 
2753 // NOTE: this ONFT contract has no public minting logic.
2754 // must implement your own minting logic in child classes
2755 contract ONFT721 is ONFT721Core, ERC721, IONFT721 {
2756     constructor(string memory _name, string memory _symbol, uint256 _minGasToTransfer, address _lzEndpoint) ERC721(_name, _symbol) ONFT721Core(_minGasToTransfer, _lzEndpoint) {}
2757 
2758     function supportsInterface(bytes4 interfaceId) public view virtual override(ONFT721Core, ERC721, IERC165) returns (bool) {
2759         return interfaceId == type(IONFT721).interfaceId || super.supportsInterface(interfaceId);
2760     }
2761 
2762     function _debitFrom(address _from, uint16, bytes memory, uint _tokenId) internal virtual override {
2763         require(_isApprovedOrOwner(_msgSender(), _tokenId), "ONFT721: send caller is not owner nor approved");
2764         require(ERC721.ownerOf(_tokenId) == _from, "ONFT721: send from incorrect owner");
2765         _transfer(_from, address(this), _tokenId);
2766     }
2767 
2768     function _creditTo(uint16, address _toAddress, uint _tokenId) internal virtual override {
2769         require(!_exists(_tokenId) || (_exists(_tokenId) && ERC721.ownerOf(_tokenId) == address(this)));
2770         if (!_exists(_tokenId)) {
2771             _safeMint(_toAddress, _tokenId);
2772         } else {
2773             _transfer(address(this), _toAddress, _tokenId);
2774         }
2775     }
2776 }
2777 
2778 /// @title Interface of the UniversalONFT standard
2779 contract UniversalONFT721 is ONFT721 {
2780     uint public nextMintId;
2781     uint public maxMintId;
2782     uint public fee;
2783 
2784     /// @notice Constructor for the UniversalONFT
2785     /// @param _name the name of the token
2786     /// @param _symbol the token symbol
2787     /// @param _layerZeroEndpoint handles message transmission across chains
2788     /// @param _startMintId the starting mint number on this chain
2789     /// @param _endMintId the max number of mints on this chain
2790     constructor(
2791     string memory _name,
2792     string memory _symbol,
2793     uint256 _minGasToTransfer,
2794     address _layerZeroEndpoint,
2795     uint _startMintId,
2796     uint _endMintId) ONFT721(_name, _symbol, _minGasToTransfer, _layerZeroEndpoint) {
2797         nextMintId = _startMintId;
2798         maxMintId = _endMintId;
2799         fee = 0.00031 ether; // half a buck
2800     }
2801 
2802     /// @notice Mint your ONFT
2803     function mint() external payable {
2804         require(nextMintId <= maxMintId, "L2Marathon: max mint limit reached");
2805         require(msg.value >= fee, "Not enough ETH sent: check fee.");
2806         uint newId = nextMintId;
2807         nextMintId++;
2808 
2809         _safeMint(msg.sender, newId);
2810     }
2811 
2812     function withdrawETH() external onlyOwner returns(bool) {
2813         (bool success,)= payable(msg.sender).call{value: address(this).balance}("");
2814         return success;
2815     }
2816 
2817     function setFee(uint _fee) external onlyOwner {
2818         fee = _fee;
2819     }
2820 }
2821 
2822 /// @title A LayerZero UniversalONFT example
2823 /// @notice You can use this to mint ONFT and send nftIds across chain.
2824 ///  Each contract deployed to a chain should carefully set a `_startMintIndex` and a `_maxMint`
2825 ///  value to set a range of allowed mintable nftIds (so that no two chains can mint the same id!)
2826 contract L2Marathon is UniversalONFT721 {
2827     constructor(uint256 _minGasToStore, address _layerZeroEndpoint, uint _startMintId, uint _endMintId) UniversalONFT721("L2Marathon", "MarathonRunner", _minGasToStore, _layerZeroEndpoint, _startMintId, _endMintId) {}
2828 }