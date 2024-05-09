1 // File: contracts/ERC721/ERC721ReceiverDraft.sol
2 
3 pragma solidity ^0.5.10;
4 
5 
6 /// @title ERC721ReceiverDraft
7 /// @dev Interface for any contract that wants to support safeTransfers from
8 ///  ERC721 asset contracts.
9 /// @dev Note: this is the interface defined from 
10 ///  https://github.com/ethereum/EIPs/commit/2bddd126def7c046e1e62408dc2b51bdd9e57f0f
11 ///  to https://github.com/ethereum/EIPs/commit/27788131d5975daacbab607076f2ee04624f9dbb 
12 ///  and is not the final interface.
13 ///  Due to the extended period of time this revision was specified in the draft,
14 ///  we are supporting both this and the newer (final) interface in order to be 
15 ///  compatible with any ERC721 implementations that may have used this interface.
16 contract ERC721ReceiverDraft {
17 
18     /// @dev Magic value to be returned upon successful reception of an NFT
19     ///  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
20     ///  which can be also obtained as `ERC721ReceiverDraft(0).onERC721Received.selector`
21     /// @dev see https://github.com/ethereum/EIPs/commit/2bddd126def7c046e1e62408dc2b51bdd9e57f0f
22     bytes4 internal constant ERC721_RECEIVED_DRAFT = 0xf0b9e5ba;
23 
24     /// @notice Handle the receipt of an NFT
25     /// @dev The ERC721 smart contract calls this function on the recipient
26     ///  after a `transfer`. This function MAY throw to revert and reject the
27     ///  transfer. This function MUST use 50,000 gas or less. Return of other
28     ///  than the magic value MUST result in the transaction being reverted.
29     ///  Note: the contract address is always the message sender.
30     /// @param _from The sending address 
31     /// @param _tokenId The NFT identifier which is being transfered
32     /// @param data Additional data with no specified format
33     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
34     ///  unless throwing
35     function onERC721Received(address _from, uint256 _tokenId, bytes calldata data) external returns(bytes4);
36 }
37 
38 // File: contracts/ERC721/ERC721ReceiverFinal.sol
39 
40 pragma solidity ^0.5.10;
41 
42 
43 /// @title ERC721ReceiverFinal
44 /// @notice Interface for any contract that wants to support safeTransfers from
45 ///  ERC721 asset contracts.
46 ///  @dev Note: this is the final interface as defined at http://erc721.org
47 contract ERC721ReceiverFinal {
48 
49     /// @dev Magic value to be returned upon successful reception of an NFT
50     ///  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
51     ///  which can be also obtained as `ERC721ReceiverFinal(0).onERC721Received.selector`
52     /// @dev see https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.12.0/contracts/token/ERC721/ERC721Receiver.sol
53     bytes4 internal constant ERC721_RECEIVED_FINAL = 0x150b7a02;
54 
55     /// @notice Handle the receipt of an NFT
56     /// @dev The ERC721 smart contract calls this function on the recipient
57     /// after a `safetransfer`. This function MAY throw to revert and reject the
58     /// transfer. Return of other than the magic value MUST result in the
59     /// transaction being reverted.
60     /// Note: the contract address is always the message sender.
61     /// @param _operator The address which called `safeTransferFrom` function
62     /// @param _from The address which previously owned the token
63     /// @param _tokenId The NFT identifier which is being transferred
64     /// @param _data Additional data with no specified format
65     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
66     function onERC721Received(
67         address _operator,
68         address _from,
69         uint256 _tokenId,
70         bytes memory _data
71     )
72     public
73         returns (bytes4);
74 }
75 
76 // File: contracts/ERC721/ERC721Receivable.sol
77 
78 pragma solidity ^0.5.10;
79 
80 
81 
82 /// @title ERC721Receivable handles the reception of ERC721 tokens
83 ///  See ERC721 specification
84 /// @author Christopher Scott
85 /// @dev These functions are public, and could be called by anyone, even in the case
86 ///  where no NFTs have been transferred. Since it's not a reliable source of
87 ///  truth about ERC721 tokens being transferred, we save the gas and don't
88 ///  bother emitting a (potentially spurious) event as found in 
89 ///  https://github.com/OpenZeppelin/openzeppelin-solidity/blob/5471fc808a17342d738853d7bf3e9e5ef3108074/contracts/mocks/ERC721ReceiverMock.sol
90 contract ERC721Receivable is ERC721ReceiverDraft, ERC721ReceiverFinal {
91 
92     /// @notice Handle the receipt of an NFT
93     /// @dev The ERC721 smart contract calls this function on the recipient
94     ///  after a `transfer`. This function MAY throw to revert and reject the
95     ///  transfer. This function MUST use 50,000 gas or less. Return of other
96     ///  than the magic value MUST result in the transaction being reverted.
97     ///  Note: the contract address is always the message sender.
98     /// @param _from The sending address 
99     /// @param _tokenId The NFT identifier which is being transfered
100     /// @param data Additional data with no specified format
101     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
102     ///  unless throwing
103     function onERC721Received(address _from, uint256 _tokenId, bytes calldata data) external returns(bytes4) {
104         _from;
105         _tokenId;
106         data;
107 
108         // emit ERC721Received(_operator, _from, _tokenId, _data, gasleft());
109 
110         return ERC721_RECEIVED_DRAFT;
111     }
112 
113     /// @notice Handle the receipt of an NFT
114     /// @dev The ERC721 smart contract calls this function on the recipient
115     /// after a `safetransfer`. This function MAY throw to revert and reject the
116     /// transfer. Return of other than the magic value MUST result in the
117     /// transaction being reverted.
118     /// Note: the contract address is always the message sender.
119     /// @param _operator The address which called `safeTransferFrom` function
120     /// @param _from The address which previously owned the token
121     /// @param _tokenId The NFT identifier which is being transferred
122     /// @param _data Additional data with no specified format
123     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
124     function onERC721Received(
125         address _operator,
126         address _from,
127         uint256 _tokenId,
128         bytes memory _data
129     )
130         public
131         returns(bytes4)
132     {
133         _operator;
134         _from;
135         _tokenId;
136         _data;
137 
138         // emit ERC721Received(_operator, _from, _tokenId, _data, gasleft());
139 
140         return ERC721_RECEIVED_FINAL;
141     }
142 
143 }
144 
145 // File: contracts/ERC223/ERC223Receiver.sol
146 
147 pragma solidity ^0.5.10;
148 
149 
150 /// @title ERC223Receiver ensures we are ERC223 compatible
151 /// @author Christopher Scott
152 contract ERC223Receiver {
153     
154     bytes4 public constant ERC223_ID = 0xc0ee0b8a;
155 
156     struct TKN {
157         address sender;
158         uint value;
159         bytes data;
160         bytes4 sig;
161     }
162     
163     /// @notice tokenFallback is called from an ERC223 compatible contract
164     /// @param _from the address from which the token was sent
165     /// @param _value the amount of tokens sent
166     /// @param _data the data sent with the transaction
167     function tokenFallback(address _from, uint _value, bytes memory _data) public pure {
168         _from;
169         _value;
170         _data;
171     //   TKN memory tkn;
172     //   tkn.sender = _from;
173     //   tkn.value = _value;
174     //   tkn.data = _data;
175     //   uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
176     //   tkn.sig = bytes4(u);
177       
178       /* tkn variable is analogue of msg variable of Ether transaction
179       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
180       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
181       *  tkn.data is data of token transaction   (analogue of msg.data)
182       *  tkn.sig is 4 bytes signature of function
183       *  if data of token transaction is a function execution
184       */
185 
186     }
187 }
188 
189 // File: contracts/ERC1155/ERC1155TokenReceiver.sol
190 
191 pragma solidity ^0.5.10;
192 
193 contract ERC1155TokenReceiver {
194     /// @dev `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)")) ^
195     /// bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
196     bytes4 internal constant ERC1155_TOKEN_RECIEVER = 0x4e2312e0;
197 
198     /**
199         @notice Handle the receipt of a single ERC1155 token type.
200         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.        
201         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
202         This function MUST revert if it rejects the transfer.
203         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
204         @param _operator  The address which initiated the transfer (i.e. msg.sender)
205         @param _from      The address which previously owned the token
206         @param _id        The ID of the token being transferred
207         @param _value     The amount of tokens being transferred
208         @param _data      Additional data with no specified format
209         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
210     */
211     function onERC1155Received(
212         address _operator,
213         address _from,
214         uint256 _id,
215         uint256 _value,
216         bytes calldata _data
217     ) external pure returns (bytes4) {
218         _operator;
219         _from;
220         _id;
221         _value;
222         _data;
223 
224         return 0xf23a6e61;
225     }
226 
227     /**
228         @notice Handle the receipt of multiple ERC1155 token types.
229         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.        
230         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
231         This function MUST revert if it rejects the transfer(s).
232         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
233         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
234         @param _from      The address which previously owned the token
235         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
236         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
237         @param _data      Additional data with no specified format
238         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
239     */
240     function onERC1155BatchReceived(
241         address _operator,
242         address _from,
243         uint256[] calldata _ids,
244         uint256[] calldata _values,
245         bytes calldata _data
246     ) external pure returns (bytes4) {
247         _operator;
248         _from;
249         _ids;
250         _values;
251         _data;
252 
253         return 0xbc197c81;
254     }
255 }
256 
257 // File: contracts/ERC1271/ERC1271.sol
258 
259 pragma solidity ^0.5.10;
260 
261 contract ERC1271 {
262 
263     /// @dev bytes4(keccak256("isValidSignature(bytes32,bytes)")
264     bytes4 internal constant ERC1271_VALIDSIGNATURE = 0x1626ba7e;
265 
266     /// @dev Should return whether the signature provided is valid for the provided data
267     /// @param hash 32-byte hash of the data that is signed
268     /// @param _signature Signature byte array associated with _data
269     ///  MUST return the bytes4 magic value 0x1626ba7e when function passes.
270     ///  MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
271     ///  MUST allow external calls
272     function isValidSignature(
273         bytes32 hash, 
274         bytes calldata _signature)
275         external
276         view 
277         returns (bytes4);
278 }
279 
280 // File: contracts/ECDSA.sol
281 
282 pragma solidity ^0.5.10;
283 
284 
285 /// @title ECDSA is a library that contains useful methods for working with ECDSA signatures
286 library ECDSA {
287 
288     /// @notice Extracts the r, s, and v components from the `sigData` field starting from the `offset`
289     /// @dev Note: does not do any bounds checking on the arguments!
290     /// @param sigData the signature data; could be 1 or more packed signatures.
291     /// @param offset the offset in sigData from which to start unpacking the signature components.
292     function extractSignature(bytes memory sigData, uint256 offset) internal pure returns  (bytes32 r, bytes32 s, uint8 v) {
293         // Divide the signature in r, s and v variables
294         // ecrecover takes the signature parameters, and the only way to get them
295         // currently is to use assembly.
296         // solium-disable-next-line security/no-inline-assembly
297         assembly {
298              let dataPointer := add(sigData, offset)
299              r := mload(add(dataPointer, 0x20))
300              s := mload(add(dataPointer, 0x40))
301              v := byte(0, mload(add(dataPointer, 0x60)))
302         }
303     
304         return (r, s, v);
305     }
306 }
307 
308 // File: contracts/Wallet/CoreWallet.sol
309 
310 pragma solidity ^0.5.10;
311 
312 
313 
314 
315 
316 
317 
318 /// @title Core Wallet
319 /// @notice A basic smart contract wallet with cosigner functionality. The notion of "cosigner" is
320 ///  the simplest possible multisig solution, a two-of-two signature scheme. It devolves nicely
321 ///  to "one-of-one" (i.e. singlesig) by simply having the cosigner set to the same value as
322 ///  the main signer.
323 /// 
324 ///  Most "advanced" functionality (deadman's switch, multiday recovery flows, blacklisting, etc)
325 ///  can be implemented externally to this smart contract, either as an additional smart contract
326 ///  (which can be tracked as a signer without cosigner, or as a cosigner) or as an off-chain flow
327 ///  using a public/private key pair as cosigner. Of course, the basic cosigning functionality could
328 ///  also be implemented in this way, but (A) the complexity and gas cost of two-of-two multisig (as
329 ///  implemented here) is negligable even if you don't need the cosigner functionality, and
330 ///  (B) two-of-two multisig (as implemented here) handles a lot of really common use cases, most
331 ///  notably third-party gas payment and off-chain blacklisting and fraud detection.
332 contract CoreWallet is ERC721Receivable, ERC223Receiver, ERC1271, ERC1155TokenReceiver {
333 
334     using ECDSA for bytes;
335 
336     /// @notice We require that presigned transactions use the EIP-191 signing format.
337     ///  See that EIP for more info: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-191.md
338     byte public constant EIP191_VERSION_DATA = byte(0);
339     byte public constant EIP191_PREFIX = byte(0x19);
340 
341     /// @notice This is the version of the contract.
342     string public constant VERSION = "1.1.0";
343 
344     /// @notice This is a sentinel value used to determine when a delegate is set to expose 
345     ///  support for an interface containing more than a single function. See `delegates` and
346     ///  `setDelegate` for more information.
347     address public constant COMPOSITE_PLACEHOLDER = address(1);
348 
349     /// @notice A pre-shifted "1", used to increment the authVersion, so we can "prepend"
350     ///  the authVersion to an address (for lookups in the authorizations mapping)
351     ///  by using the '+' operator (which is cheaper than a shift and a mask). See the
352     ///  comment on the `authorizations` variable for how this is used.
353     uint256 public constant AUTH_VERSION_INCREMENTOR = (1 << 160);
354     
355     /// @notice The pre-shifted authVersion (to get the current authVersion as an integer,
356     ///  shift this value right by 160 bits). Starts as `1 << 160` (`AUTH_VERSION_INCREMENTOR`)
357     ///  See the comment on the `authorizations` variable for how this is used.
358     uint256 public authVersion;
359 
360     /// @notice A mapping containing all of the addresses that are currently authorized to manage
361     ///  the assets owned by this wallet.
362     ///
363     ///  The keys in this mapping are authorized addresses with a version number prepended,
364     ///  like so: (authVersion,96)(address,160). The current authVersion MUST BE included
365     ///  for each look-up; this allows us to effectively clear the entire mapping of its
366     ///  contents merely by incrementing the authVersion variable. (This is important for
367     ///  the emergencyRecovery() method.) Inspired by https://ethereum.stackexchange.com/a/42540
368     ///
369     ///  The values in this mapping are 256bit words, whose lower 20 bytes constitute "cosigners"
370     ///  for each address. If an address maps to itself, then that address is said to have no cosigner.
371     ///
372     ///  The upper 12 bytes are reserved for future meta-data purposes.  The meta-data could refer
373     ///  to the key (authorized address) or the value (cosigner) of the mapping.
374     ///
375     ///  Addresses that map to a non-zero cosigner in the current authVersion are called
376     ///  "authorized addresses".
377     mapping(uint256 => uint256) public authorizations;
378 
379     /// @notice A per-key nonce value, incremented each time a transaction is processed with that key.
380     ///  Used for replay prevention. The nonce value in the transaction must exactly equal the current
381     ///  nonce value in the wallet for that key. (This mirrors the way Ethereum's transaction nonce works.)
382     mapping(address => uint256) public nonces;
383 
384     /// @notice A mapping tracking dynamically supported interfaces and their corresponding
385     ///  implementation contracts. Keys are interface IDs and values are addresses of
386     ///  contracts that are responsible for implementing the function corresponding to the
387     ///  interface.
388     ///  
389     ///  Delegates are added (or removed) via the `setDelegate` method after the contract is
390     ///  deployed, allowing support for new interfaces to be dynamically added after deployment.
391     ///  When a delegate is added, its interface ID is considered "supported" under EIP165. 
392     ///
393     ///  For cases where an interface composed of more than a single function must be
394     ///  supported, it is necessary to manually add the composite interface ID with 
395     ///  `setDelegate(interfaceId, COMPOSITE_PLACEHOLDER)`. Interface IDs added with the
396     ///  COMPOSITE_PLACEHOLDER address are ignored when called and are only used to specify
397     ///  supported interfaces.
398     mapping(bytes4 => address) public delegates;
399 
400     /// @notice A special address that is authorized to call `emergencyRecovery()`. That function
401     ///  resets ALL authorization for this wallet, and must therefore be treated with utmost security.
402     ///  Reasonable choices for recoveryAddress include:
403     ///       - the address of a private key in cold storage
404     ///       - a physically secured hardware wallet
405     ///       - a multisig smart contract, possibly with a time-delayed challenge period
406     ///       - the zero address, if you like performing without a safety net ;-)
407     address public recoveryAddress;
408 
409     /// @notice Used to track whether or not this contract instance has been initialized. This
410     ///  is necessary since it is common for this wallet smart contract to be used as the "library
411     ///  code" for an clone contract. See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
412     ///  for more information about clone contracts.
413     bool public initialized;
414     
415     /// @notice Used to decorate methods that can only be called directly by the recovery address.
416     modifier onlyRecoveryAddress() {
417         require(msg.sender == recoveryAddress, "sender must be recovery address");
418         _;
419     }
420 
421     /// @notice Used to decorate the `init` function so this can only be called one time. Necessary
422     ///  since this contract will often be used as a "clone". (See above.)
423     modifier onlyOnce() {
424         require(!initialized, "must not already be initialized");
425         initialized = true;
426         _;
427     }
428     
429     /// @notice Used to decorate methods that can only be called indirectly via an `invoke()` method.
430     ///  In practice, it means that those methods can only be called by a signer/cosigner
431     ///  pair that is currently authorized. Theoretically, we could factor out the
432     ///  signer/cosigner verification code and use it explicitly in this modifier, but that
433     ///  would either result in duplicated code, or additional overhead in the invoke()
434     ///  calls (due to the stack manipulation for calling into the shared verification function).
435     ///  Doing it this way makes calling the administration functions more expensive (since they
436     ///  go through a explicit call() instead of just branching within the contract), but it
437     ///  makes invoke() more efficient. We assume that invoke() will be used much, much more often
438     ///  than any of the administration functions.
439     modifier onlyInvoked() {
440         require(msg.sender == address(this), "must be called from `invoke()`");
441         _;
442     }
443     
444     /// @notice Emitted when an authorized address is added, removed, or modified. When an
445     ///  authorized address is removed ("deauthorized"), cosigner will be address(0) in
446     ///  this event.
447     ///  
448     ///  NOTE: When emergencyRecovery() is called, all existing addresses are deauthorized
449     ///  WITHOUT Authorized(addr, 0) being emitted. If you are keeping an off-chain mirror of
450     ///  authorized addresses, you must also watch for EmergencyRecovery events.
451     /// @dev hash is 0xf5a7f4fb8a92356e8c8c4ae7ac3589908381450500a7e2fd08c95600021ee889
452     /// @param authorizedAddress the address to authorize or unauthorize
453     /// @param cosigner the 2-of-2 signatory (optional).
454     event Authorized(address authorizedAddress, uint256 cosigner);
455     
456     /// @notice Emitted when an emergency recovery has been performed. If this event is fired,
457     ///  ALL previously authorized addresses have been deauthorized and the only authorized
458     ///  address is the authorizedAddress indicated in this event.
459     /// @dev hash is 0xe12d0bbeb1d06d7a728031056557140afac35616f594ef4be227b5b172a604b5
460     /// @param authorizedAddress the new authorized address
461     /// @param cosigner the cosigning address for `authorizedAddress`
462     event EmergencyRecovery(address authorizedAddress, uint256 cosigner);
463 
464     /// @notice Emitted when the recovery address changes. Either (but not both) of the
465     ///  parameters may be zero.
466     /// @dev hash is 0x568ab3dedd6121f0385e007e641e74e1f49d0fa69cab2957b0b07c4c7de5abb6
467     /// @param previousRecoveryAddress the previous recovery address
468     /// @param newRecoveryAddress the new recovery address
469     event RecoveryAddressChanged(address previousRecoveryAddress, address newRecoveryAddress);
470 
471     /// @dev Emitted when this contract receives a non-zero amount ether via the fallback function
472     ///  (i.e. This event is not fired if the contract receives ether as part of a method invocation)
473     /// @param from the address which sent you ether
474     /// @param value the amount of ether sent
475     event Received(address from, uint value);
476 
477     /// @notice Emitted whenever a transaction is processed successfully from this wallet. Includes
478     ///  both simple send ether transactions, as well as other smart contract invocations.
479     /// @dev hash is 0x101214446435ebbb29893f3348e3aae5ea070b63037a3df346d09d3396a34aee
480     /// @param hash The hash of the entire operation set. 0 is returned when emitted from `invoke0()`.
481     /// @param result A bitfield of the results of the operations. A bit of 0 means success, and 1 means failure.
482     /// @param numOperations A count of the number of operations processed
483     event InvocationSuccess(
484         bytes32 hash,
485         uint256 result,
486         uint256 numOperations
487     );
488 
489     /// @notice Emitted when a delegate is added or removed.
490     /// @param interfaceId The interface ID as specified by EIP165
491     /// @param delegate The address of the contract implementing the given function. If this is
492     ///  COMPOSITE_PLACEHOLDER, we are indicating support for a composite interface.
493     event DelegateUpdated(bytes4 interfaceId, address delegate);
494 
495     /// @notice The shared initialization code used to setup the contract state regardless of whether or
496     ///  not the clone pattern is being used.
497     /// @param _authorizedAddress the initial authorized address, must not be zero!
498     /// @param _cosigner the initial cosigning address for `_authorizedAddress`, can be equal to `_authorizedAddress`
499     /// @param _recoveryAddress the initial recovery address for the wallet, can be address(0)
500     function init(address _authorizedAddress, uint256 _cosigner, address _recoveryAddress) public onlyOnce {
501         require(_authorizedAddress != _recoveryAddress, "Do not use the recovery address as an authorized address.");
502         require(address(_cosigner) != _recoveryAddress, "Do not use the recovery address as a cosigner.");
503         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
504         require(address(_cosigner) != address(0), "Initial cosigner must not be zero.");
505         
506         recoveryAddress = _recoveryAddress;
507         // set initial authorization value
508         authVersion = AUTH_VERSION_INCREMENTOR;
509         // add initial authorized address
510         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
511         
512         emit Authorized(_authorizedAddress, _cosigner);
513     }
514 
515     function bytesToAddresses(bytes memory bys) private pure returns (address[] memory addresses) {
516             addresses = new address[](bys.length/20);
517             for (uint i=0; i < bys.length; i+=20) {
518                 address addr;
519                 uint end = i+20;
520                 assembly {
521                   addr := mload(add(bys,end))
522                 }
523                 addresses[i/20] = addr;
524             }
525         }
526 
527     function init2(bytes memory _authorizedAddresses, uint256 _cosigner, address _recoveryAddress) public onlyOnce {
528         address[] memory addresses = bytesToAddresses(_authorizedAddresses);
529         for (uint i=0; i < addresses.length; i++) {
530             address _authorizedAddress = addresses[i];
531             require(_authorizedAddress != _recoveryAddress, "Do not use the recovery address as an authorized address.");
532             require(address(_cosigner) != _recoveryAddress, "Do not use the recovery address as a cosigner.");
533             require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
534             require(address(_cosigner) != address(0), "Initial cosigner must not be zero.");
535 
536             recoveryAddress = _recoveryAddress;
537             // set initial authorization value
538             authVersion = AUTH_VERSION_INCREMENTOR;
539             // add initial authorized address
540             authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
541 
542             emit Authorized(_authorizedAddress, _cosigner);
543         }
544     }
545 
546     /// @notice The fallback function, invoked whenever we receive a transaction that doesn't call any of our
547     ///  named functions. In particular, this method is called when we are the target of a simple send
548     ///  transaction, when someone calls a method we have dynamically added a delegate for, or when someone
549     ///  tries to call a function we don't implement, either statically or dynamically.
550     ///
551     ///  A correct invocation of this method occurs in two cases:
552     ///  - someone transfers ETH to this wallet (`msg.data.length` is  0)
553     ///  - someone calls a delegated function (`msg.data.length` is greater than 0 and
554     ///    `delegates[msg.sig]` is set) 
555     ///  In all other cases, this function will revert.
556     ///
557     ///  NOTE: Some smart contracts send 0 eth as part of a more complex operation
558     ///  (-cough- CryptoKitties -cough-); ideally, we'd `require(msg.value > 0)` here when
559     ///  `msg.data.length == 0`, but to work with those kinds of smart contracts, we accept zero sends
560     ///  and just skip logging in that case.
561     function() external payable {
562         if (msg.value > 0) {
563             emit Received(msg.sender, msg.value);
564         }
565         if (msg.data.length > 0) {
566             address delegate = delegates[msg.sig]; 
567             require(delegate > COMPOSITE_PLACEHOLDER, "Invalid transaction");
568 
569             // We have found a delegate contract that is responsible for the method signature of
570             // this call. Now, pass along the calldata of this CALL to the delegate contract.  
571             assembly {
572                 calldatacopy(0, 0, calldatasize())
573                 let result := staticcall(gas, delegate, 0, calldatasize(), 0, 0)
574                 returndatacopy(0, 0, returndatasize())
575 
576                 // If the delegate reverts, we revert. If the delegate does not revert, we return the data
577                 // returned by the delegate to the original caller.
578                 switch result 
579                 case 0 {
580                     revert(0, returndatasize())
581                 } 
582                 default {
583                     return(0, returndatasize())
584                 }
585             } 
586         }    
587     }
588 
589     /// @notice Adds or removes dynamic support for an interface. Can be used in 3 ways:
590     ///   - Add a contract "delegate" that implements a single function
591     ///   - Remove delegate for a function
592     ///   - Specify that an interface ID is "supported", without adding a delegate. This is
593     ///     used for composite interfaces when the interface ID is not a single method ID.
594     /// @dev Must be called through `invoke`
595     /// @param _interfaceId The ID of the interface we are adding support for
596     /// @param _delegate Either:
597     ///    - the address of a contract that implements the function specified by `_interfaceId`
598     ///      for adding an implementation for a single function
599     ///    - 0 for removing an existing delegate
600     ///    - COMPOSITE_PLACEHOLDER for specifying support for a composite interface
601     function setDelegate(bytes4 _interfaceId, address _delegate) external onlyInvoked {
602         delegates[_interfaceId] = _delegate;
603         emit DelegateUpdated(_interfaceId, _delegate);
604     }
605     
606     /// @notice Configures an authorizable address. Can be used in four ways:
607     ///   - Add a new signer/cosigner pair (cosigner must be non-zero)
608     ///   - Set or change the cosigner for an existing signer (if authorizedAddress != cosigner)
609     ///   - Remove the cosigning requirement for a signer (if authorizedAddress == cosigner)
610     ///   - Remove a signer (if cosigner == address(0))
611     /// @dev Must be called through `invoke()`
612     /// @param _authorizedAddress the address to configure authorization
613     /// @param _cosigner the corresponding cosigning address
614     function setAuthorized(address _authorizedAddress, uint256 _cosigner) external onlyInvoked {
615         // TODO: Allowing a signer to remove itself is actually pretty terrible; it could result in the user
616         //  removing their only available authorized key. Unfortunately, due to how the invocation forwarding
617         //  works, we don't actually _know_ which signer was used to call this method, so there's no easy way
618         //  to prevent this.
619         
620         // TODO: Allowing the backup key to be set as an authorized address bypasses the recovery mechanisms.
621         //  Dapper can prevent this with offchain logic and the cosigner, but it would be nice to have 
622         //  this enforced by the smart contract logic itself.
623         
624         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
625         require(_authorizedAddress != recoveryAddress, "Do not use the recovery address as an authorized address.");
626         require(address(_cosigner) == address(0) || address(_cosigner) != recoveryAddress, "Do not use the recovery address as a cosigner.");
627  
628         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
629         emit Authorized(_authorizedAddress, _cosigner);
630     }
631     
632     /// @notice Performs an emergency recovery operation, removing all existing authorizations and setting
633     ///  a sole new authorized address with optional cosigner. THIS IS A SCORCHED EARTH SOLUTION, and great
634     ///  care should be taken to ensure that this method is never called unless it is a last resort. See the
635     ///  comments above about the proper kinds of addresses to use as the recoveryAddress to ensure this method
636     ///  is not trivially abused.
637     /// @param _authorizedAddress the new and sole authorized address
638     /// @param _cosigner the corresponding cosigner address, can be equal to _authorizedAddress
639     function emergencyRecovery(address _authorizedAddress, uint256 _cosigner) external onlyRecoveryAddress {
640         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
641         require(_authorizedAddress != recoveryAddress, "Do not use the recovery address as an authorized address.");
642         require(address(_cosigner) != address(0), "The cosigner must not be zero.");
643 
644         // Incrementing the authVersion number effectively erases the authorizations mapping. See the comments
645         // on the authorizations variable (above) for more information.
646         authVersion += AUTH_VERSION_INCREMENTOR;
647 
648         // Store the new signer/cosigner pair as the only remaining authorized address
649         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
650         emit EmergencyRecovery(_authorizedAddress, _cosigner);
651     }
652 
653     function emergencyRecovery2(address _authorizedAddress, uint256 _cosigner, address _recoveryAddress) external onlyRecoveryAddress {
654             require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
655             require(_authorizedAddress != _recoveryAddress, "Do not use the recovery address as an authorized address.");
656             require(address(_cosigner) != address(0), "The cosigner must not be zero.");
657 
658             // Incrementing the authVersion number effectively erases the authorizations mapping. See the comments
659             // on the authorizations variable (above) for more information.
660             authVersion += AUTH_VERSION_INCREMENTOR;
661 
662             // Store the new signer/cosigner pair as the only remaining authorized address
663             authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
664 
665             // set new recovery address
666             address previous = recoveryAddress;
667             recoveryAddress = _recoveryAddress;
668 
669             emit RecoveryAddressChanged(previous, recoveryAddress);
670             emit EmergencyRecovery(_authorizedAddress, _cosigner);
671      }
672 
673     /// @notice Sets the recovery address, which can be zero (indicating that no recovery is possible)
674     ///  Can be updated by any authorized address. This address should be set with GREAT CARE. See the
675     ///  comments above about the proper kinds of addresses to use as the recoveryAddress to ensure this
676     ///  mechanism is not trivially abused.
677     /// @dev Must be called through `invoke()`
678     /// @param _recoveryAddress the new recovery address
679     function setRecoveryAddress(address _recoveryAddress) external onlyInvoked {
680         require(
681             address(authorizations[authVersion + uint256(_recoveryAddress)]) == address(0),
682             "Do not use an authorized address as the recovery address."
683         );
684  
685         address previous = recoveryAddress;
686         recoveryAddress = _recoveryAddress;
687 
688         emit RecoveryAddressChanged(previous, recoveryAddress);
689     }
690 
691     /// @notice Allows ANY caller to recover gas by way of deleting old authorization keys after
692     ///  a recovery operation. Anyone can call this method to delete the old unused storage and
693     ///  get themselves a bit of gas refund in the bargin.
694     /// @dev keys must be known to caller or else nothing is refunded
695     /// @param _version the version of the mapping which you want to delete (unshifted)
696     /// @param _keys the authorization keys to delete 
697     function recoverGas(uint256 _version, address[] calldata _keys) external {
698         // TODO: should this be 0xffffffffffffffffffffffff ?
699         require(_version > 0 && _version < 0xffffffff, "Invalid version number.");
700         
701         uint256 shiftedVersion = _version << 160;
702 
703         require(shiftedVersion < authVersion, "You can only recover gas from expired authVersions.");
704 
705         for (uint256 i = 0; i < _keys.length; ++i) {
706             delete(authorizations[shiftedVersion + uint256(_keys[i])]);
707         }
708     }
709 
710     /// @notice Should return whether the signature provided is valid for the provided data
711     ///  See https://github.com/ethereum/EIPs/issues/1271
712     /// @dev This function meets the following conditions as per the EIP:
713     ///  MUST return the bytes4 magic value `0x1626ba7e` when function passes.
714     ///  MUST NOT modify state (using `STATICCALL` for solc < 0.5, `view` modifier for solc > 0.5)
715     ///  MUST allow external calls
716     /// @param hash A 32 byte hash of the signed data.  The actual hash that is hashed however is the
717     ///  the following tightly packed arguments: `0x19,0x0,wallet_address,hash`
718     /// @param _signature Signature byte array associated with `_data`
719     /// @return Magic value `0x1626ba7e` upon success, 0 otherwise.
720     function isValidSignature(bytes32 hash, bytes calldata _signature) external view returns (bytes4) {
721         
722         // We 'hash the hash' for the following reasons:
723         // 1. `hash` is not the hash of an Ethereum transaction
724         // 2. signature must target this wallet to avoid replaying the signature for another wallet
725         // with the same key
726         // 3. Gnosis does something similar: 
727         // https://github.com/gnosis/safe-contracts/blob/102e632d051650b7c4b0a822123f449beaf95aed/contracts/GnosisSafe.sol
728         bytes32 operationHash = keccak256(
729             abi.encodePacked(
730             EIP191_PREFIX,
731             EIP191_VERSION_DATA,
732             this,
733             hash));
734 
735         bytes32[2] memory r;
736         bytes32[2] memory s;
737         uint8[2] memory v;
738         address signer;
739         address cosigner;
740 
741         // extract 1 or 2 signatures depending on length
742         if (_signature.length == 65) {
743             (r[0], s[0], v[0]) = _signature.extractSignature(0);
744             signer = ecrecover(operationHash, v[0], r[0], s[0]);
745             cosigner = signer;
746         } else if (_signature.length == 130) {
747             (r[0], s[0], v[0]) = _signature.extractSignature(0);
748             (r[1], s[1], v[1]) = _signature.extractSignature(65);
749             signer = ecrecover(operationHash, v[0], r[0], s[0]);
750             cosigner = ecrecover(operationHash, v[1], r[1], s[1]);
751         } else {
752             return 0;
753         }
754             
755         // check for valid signature
756         if (signer == address(0)) {
757             return 0;
758         }
759 
760         // check for valid signature
761         if (cosigner == address(0)) {
762             return 0;
763         }
764 
765         // check to see if this is an authorized key
766         if (address(authorizations[authVersion + uint256(signer)]) != cosigner) {
767             return 0;
768         }
769 
770         return ERC1271_VALIDSIGNATURE;
771     }
772 
773     /// @notice Query if this contract implements an interface. This function takes into account
774     ///  interfaces we implement dynamically through delegates. For interfaces that are just a
775     ///  single method, using `setDelegate` will result in that method's ID returning true from 
776     ///  `supportsInterface`. For composite interfaces that are composed of multiple functions, it is
777     ///  necessary to add the interface ID manually with `setDelegate(interfaceID,
778     ///  COMPOSITE_PLACEHOLDER)`
779     ///  IN ADDITION to adding each function of the interface as usual.
780     /// @param interfaceID The interface identifier, as specified in ERC-165
781     /// @dev Interface identification is specified in ERC-165. This function
782     ///  uses less than 30,000 gas.
783     /// @return `true` if the contract implements `interfaceID` and
784     ///  `interfaceID` is not 0xffffffff, `false` otherwise
785     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
786         // First check if the ID matches one of the interfaces we support statically.
787         if (
788             interfaceID == this.supportsInterface.selector || // ERC165
789             interfaceID == ERC721_RECEIVED_FINAL || // ERC721 Final
790             interfaceID == ERC721_RECEIVED_DRAFT || // ERC721 Draft
791             interfaceID == ERC223_ID || // ERC223
792             interfaceID == ERC1155_TOKEN_RECIEVER || // ERC1155 Token Reciever
793             interfaceID == ERC1271_VALIDSIGNATURE // ERC1271
794         ) {
795             return true;
796         }
797         // If we don't support the interface statically, check whether we have added
798         // dynamic support for it.
799         return uint256(delegates[interfaceID]) > 0;
800     }
801 
802     /// @notice A version of `invoke()` that has no explicit signatures, and uses msg.sender
803     ///  as both the signer and cosigner. Will only succeed if `msg.sender` is an authorized
804     ///  signer for this wallet, with no cosigner, saving transaction size and gas in that case.
805     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
806     function invoke0(bytes calldata data) external {
807         // The nonce doesn't need to be incremented for transactions that don't include explicit signatures;
808         // the built-in nonce of the native ethereum transaction will protect against replay attacks, and we
809         // can save the gas that would be spent updating the nonce variable
810 
811         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner)
812         require(address(authorizations[authVersion + uint256(msg.sender)]) == msg.sender, "Invalid authorization.");
813 
814         internalInvoke(0, data);
815     }
816 
817     /// @notice A version of `invoke()` that has one explicit signature which is used to derive the authorized
818     ///  address. Uses `msg.sender` as the cosigner.
819     /// @param v the v value for the signature; see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
820     /// @param r the r value for the signature
821     /// @param s the s value for the signature
822     /// @param nonce the nonce value for the signature
823     /// @param authorizedAddress the address of the authorization key; this is used here so that cosigner signatures are interchangeable
824     ///  between this function and `invoke2()`
825     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
826     function invoke1CosignerSends(uint8 v, bytes32 r, bytes32 s, uint256 nonce, address authorizedAddress, bytes calldata data) external {
827         // check signature version
828         require(v == 27 || v == 28, "Invalid signature version.");
829 
830         // calculate hash
831         bytes32 operationHash = keccak256(
832             abi.encodePacked(
833             EIP191_PREFIX,
834             EIP191_VERSION_DATA,
835             this,
836             nonce,
837             authorizedAddress,
838             data));
839  
840         // recover signer
841         address signer = ecrecover(operationHash, v, r, s);
842 
843         // check for valid signature
844         require(signer != address(0), "Invalid signature.");
845 
846         // check nonce
847         require(nonce > nonces[signer], "must use valid nonce for signer");
848 
849         // check signer
850         require(signer == authorizedAddress, "authorized addresses must be equal");
851 
852         // Get cosigner
853         address requiredCosigner = address(authorizations[authVersion + uint256(signer)]);
854         
855         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
856         // if the actual cosigner matches the required cosigner.
857         require(requiredCosigner == signer || requiredCosigner == msg.sender, "Invalid authorization.");
858 
859         // increment nonce to prevent replay attacks
860         nonces[signer] = nonce;
861 
862         // call internal function
863         internalInvoke(operationHash, data);
864     }
865 
866     /// @notice A version of `invoke()` that has one explicit signature which is used to derive the cosigning
867     ///  address. Uses `msg.sender` as the authorized address.
868     /// @param v the v value for the signature; see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
869     /// @param r the r value for the signature
870     /// @param s the s value for the signature
871     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
872     function invoke1SignerSends(uint8 v, bytes32 r, bytes32 s, bytes calldata data) external {
873         // check signature version
874         // `ecrecover` will in fact return 0 if given invalid
875         // so perhaps this check is redundant
876         require(v == 27 || v == 28, "Invalid signature version.");
877         
878         uint256 nonce = nonces[msg.sender];
879 
880         // calculate hash
881         bytes32 operationHash = keccak256(
882             abi.encodePacked(
883             EIP191_PREFIX,
884             EIP191_VERSION_DATA,
885             this,
886             nonce,
887             msg.sender,
888             data));
889  
890         // recover cosigner
891         address cosigner = ecrecover(operationHash, v, r, s);
892         
893         // check for valid signature
894         require(cosigner != address(0), "Invalid signature.");
895 
896         // Get required cosigner
897         address requiredCosigner = address(authorizations[authVersion + uint256(msg.sender)]);
898         
899         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
900         // if the actual cosigner matches the required cosigner.
901         require(requiredCosigner == cosigner || requiredCosigner == msg.sender, "Invalid authorization.");
902 
903         // increment nonce to prevent replay attacks
904         nonces[msg.sender] = nonce + 1;
905  
906         internalInvoke(operationHash, data);
907     }
908 
909     /// @notice A version of `invoke()` that has two explicit signatures, the first is used to derive the authorized
910     ///  address, the second to derive the cosigner. The value of `msg.sender` is ignored.
911     /// @param v the v values for the signatures
912     /// @param r the r values for the signatures
913     /// @param s the s values for the signatures
914     /// @param nonce the nonce value for the signature
915     /// @param authorizedAddress the address of the signer; forces the signature to be unique and tied to the signers nonce 
916     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
917     function invoke2(uint8[2] calldata v, bytes32[2] calldata r, bytes32[2] calldata s, uint256 nonce, address authorizedAddress, bytes calldata data) external {
918         // check signature versions
919         // `ecrecover` will infact return 0 if given invalid
920         // so perhaps these checks are redundant
921         require(v[0] == 27 || v[0] == 28, "invalid signature version v[0]");
922         require(v[1] == 27 || v[1] == 28, "invalid signature version v[1]");
923  
924         bytes32 operationHash = keccak256(
925             abi.encodePacked(
926             EIP191_PREFIX,
927             EIP191_VERSION_DATA,
928             this,
929             nonce,
930             authorizedAddress,
931             data));
932  
933         // recover signer and cosigner
934         address signer = ecrecover(operationHash, v[0], r[0], s[0]);
935         address cosigner = ecrecover(operationHash, v[1], r[1], s[1]);
936 
937         // check for valid signatures
938         require(signer != address(0), "Invalid signature for signer.");
939         require(cosigner != address(0), "Invalid signature for cosigner.");
940 
941         // check signer address
942         require(signer == authorizedAddress, "authorized addresses must be equal");
943 
944         // check nonces
945         require(nonce > nonces[signer], "must use valid nonce for signer");
946 
947         // Get Mapping
948         address requiredCosigner = address(authorizations[authVersion + uint256(signer)]);
949         
950         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
951         // if the actual cosigner matches the required cosigner.
952         require(requiredCosigner == signer || requiredCosigner == cosigner, "Invalid authorization.");
953 
954         // increment nonce to prevent replay attacks
955         nonces[signer] = nonce;
956 
957         internalInvoke(operationHash, data);
958     }
959 
960     /// @dev Internal invoke call, 
961     /// @param operationHash The hash of the operation
962     /// @param data The data to send to the `call()` operation
963     ///  The data is prefixed with a global 1 byte revert flag
964     ///  If revert is 1, then any revert from a `call()` operation is rethrown.
965     ///  Otherwise, the error is recorded in the `result` field of the `InvocationSuccess` event.
966     ///  Immediately following the revert byte (no padding), the data format is then is a series
967     ///  of 1 or more tightly packed tuples:
968     ///  `<target(20),amount(32),datalength(32),data>`
969     ///  If `datalength == 0`, the data field must be omitted
970     function internalInvoke(bytes32 operationHash, bytes memory data) internal {
971         // keep track of the number of operations processed
972         uint256 numOps;
973         // keep track of the result of each operation as a bit
974         uint256 result;
975 
976         // We need to store a reference to this string as a variable so we can use it as an argument to
977         // the revert call from assembly.
978         string memory invalidLengthMessage = "Data field too short";
979         string memory callFailed = "Call failed";
980 
981         // At an absolute minimum, the data field must be at least 85 bytes
982         // <revert(1), to_address(20), value(32), data_length(32)>
983         require(data.length >= 85, invalidLengthMessage);
984 
985         // Forward the call onto its actual target. Note that the target address can be `self` here, which is
986         // actually the required flow for modifying the configuration of the authorized keys and recovery address.
987         //
988         // The assembly code below loads data directly from memory, so the enclosing function must be marked `internal`
989         assembly {
990             // A cursor pointing to the revert flag, starts after the length field of the data object
991             let memPtr := add(data, 32)
992 
993             // The revert flag is the leftmost byte from memPtr
994             let revertFlag := byte(0, mload(memPtr))
995 
996             // A pointer to the end of the data object
997             let endPtr := add(memPtr, mload(data))
998 
999             // Now, memPtr is a cursor pointing to the beginning of the current sub-operation
1000             memPtr := add(memPtr, 1)
1001 
1002             // Loop through data, parsing out the various sub-operations
1003             for { } lt(memPtr, endPtr) { } {
1004                 // Load the length of the call data of the current operation
1005                 // 52 = to(20) + value(32)
1006                 let len := mload(add(memPtr, 52))
1007                 
1008                 // Compute a pointer to the end of the current operation
1009                 // 84 = to(20) + value(32) + size(32)
1010                 let opEnd := add(len, add(memPtr, 84))
1011 
1012                 // Bail if the current operation's data overruns the end of the enclosing data buffer
1013                 // NOTE: Comment out this bit of code and uncomment the next section if you want
1014                 // the solidity-coverage tool to work.
1015                 // See https://github.com/sc-forks/solidity-coverage/issues/287
1016                 if gt(opEnd, endPtr) {
1017                     // The computed end of this operation goes past the end of the data buffer. Not good!
1018                     revert(add(invalidLengthMessage, 32), mload(invalidLengthMessage))
1019                 }
1020                 // NOTE: Code that is compatible with solidity-coverage
1021                 // switch gt(opEnd, endPtr)
1022                 // case 1 {
1023                 //     revert(add(invalidLengthMessage, 32), mload(invalidLengthMessage))
1024                 // }
1025 
1026                 // This line of code packs in a lot of functionality!
1027                 //  - load the target address from memPtr, the address is only 20-bytes but mload always grabs 32-bytes,
1028                 //    so we have to shr by 12 bytes.
1029                 //  - load the value field, stored at memPtr+20
1030                 //  - pass a pointer to the call data, stored at memPtr+84
1031                 //  - use the previously loaded len field as the size of the call data
1032                 //  - make the call (passing all remaining gas to the child call)
1033                 //  - check the result (0 == reverted)
1034                 if eq(0, call(gas, shr(96, mload(memPtr)), mload(add(memPtr, 20)), add(memPtr, 84), len, 0, 0)) {
1035                     switch revertFlag
1036                     case 1 {
1037                         revert(add(callFailed, 32), mload(callFailed))
1038                     }
1039                     default {
1040                         // mark this operation as failed
1041                         // create the appropriate bit, 'or' with previous
1042                         result := or(result, exp(2, numOps))
1043                     }
1044                 }
1045 
1046                 // increment our counter
1047                 numOps := add(numOps, 1)
1048              
1049                 // Update mem pointer to point to the next sub-operation
1050                 memPtr := opEnd
1051             }
1052         }
1053 
1054         // emit single event upon success
1055         emit InvocationSuccess(operationHash, result, numOps);
1056     }
1057 }
1058 
1059 // File: contracts/Wallet/CloneableWallet.sol
1060 
1061 pragma solidity ^0.5.10;
1062 
1063 
1064 
1065 /// @title Cloneable Wallet
1066 /// @notice This contract represents a complete but non working wallet.  
1067 ///  It is meant to be deployed and serve as the contract that you clone
1068 ///  in an EIP 1167 clone setup.
1069 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
1070 /// @dev Currently, we are seeing approximatley 933 gas overhead for using
1071 ///  the clone wallet; use `FullWallet` if you think users will overtake
1072 ///  the transaction threshold over the lifetime of the wallet.
1073 contract CloneableWallet is CoreWallet {
1074 
1075     /// @dev An empty constructor that deploys a NON-FUNCTIONAL version
1076     ///  of `CoreWallet`
1077     constructor () public {
1078         initialized = true;
1079     }
1080 }
1081 
1082 // File: contracts/Ownership/Ownable.sol
1083 
1084 pragma solidity ^0.5.10;
1085 
1086 
1087 /// @title Ownable is for contracts that can be owned.
1088 /// @dev The Ownable contract keeps track of an owner address,
1089 ///  and provides basic authorization functions.
1090 contract Ownable {
1091 
1092     /// @dev the owner of the contract
1093     address public owner;
1094 
1095     /// @dev Fired when the owner to renounce ownership, leaving no one
1096     ///  as the owner.
1097     /// @param previousOwner The previous `owner` of this contract
1098     event OwnershipRenounced(address indexed previousOwner);
1099     
1100     /// @dev Fired when the owner to changes ownership
1101     /// @param previousOwner The previous `owner`
1102     /// @param newOwner The new `owner`
1103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1104 
1105     /// @dev sets the `owner` to `msg.sender`
1106     constructor() public {
1107         owner = msg.sender;
1108     }
1109 
1110     /// @dev Throws if the `msg.sender` is not the current `owner`
1111     modifier onlyOwner() {
1112         require(msg.sender == owner, "must be owner");
1113         _;
1114     }
1115 
1116     /// @dev Allows the current `owner` to renounce ownership
1117     function renounceOwnership() external onlyOwner {
1118         emit OwnershipRenounced(owner);
1119         owner = address(0);
1120     }
1121 
1122     /// @dev Allows the current `owner` to transfer ownership
1123     /// @param _newOwner The new `owner`
1124     function transferOwnership(address _newOwner) external onlyOwner {
1125         _transferOwnership(_newOwner);
1126     }
1127 
1128     /// @dev Internal version of `transferOwnership`
1129     /// @param _newOwner The new `owner`
1130     function _transferOwnership(address _newOwner) internal {
1131         require(_newOwner != address(0), "cannot renounce ownership");
1132         emit OwnershipTransferred(owner, _newOwner);
1133         owner = _newOwner;
1134     }
1135 }
1136 
1137 // File: contracts/Ownership/HasNoEther.sol
1138 
1139 pragma solidity ^0.5.10;
1140 
1141 
1142 
1143 /// @title HasNoEther is for contracts that should not own Ether
1144 contract HasNoEther is Ownable {
1145 
1146     /// @dev This contructor rejects incoming Ether
1147     constructor() public payable {
1148         require(msg.value == 0, "must not send Ether");
1149     }
1150 
1151     /// @dev Disallows direct send by default function not being `payable`
1152     function() external {}
1153 
1154     /// @dev Transfers all Ether held by this contract to the owner.
1155     function reclaimEther() external onlyOwner {
1156         msg.sender.transfer(address(this).balance); 
1157     }
1158 }
1159 
1160 // File: contracts/WalletFactory/CloneFactory.sol
1161 
1162 pragma solidity ^0.5.10;
1163 
1164 
1165 /// @title CloneFactory - a contract that creates clones
1166 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
1167 /// @dev See https://github.com/optionality/clone-factory/blob/master/contracts/CloneFactory.sol
1168 contract CloneFactory {
1169     event CloneCreated(address indexed target, address clone);
1170 
1171     function createClone(address target) internal returns (address payable result) {
1172         bytes20 targetBytes = bytes20(target);
1173         assembly {
1174             let clone := mload(0x40)
1175             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1176             mstore(add(clone, 0x14), targetBytes)
1177             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1178             result := create(0, clone, 0x37)
1179         }
1180     }
1181 
1182     function createClone2(address target, bytes32 salt) internal returns (address payable result) {
1183         bytes20 targetBytes = bytes20(target);
1184         assembly {
1185             let clone := mload(0x40)
1186             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1187             mstore(add(clone, 0x14), targetBytes)
1188             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1189             result := create2(0, clone, 0x37, salt)
1190         }
1191     }
1192 }
1193 
1194 // File: contracts/WalletFactory/FullWalletByteCode.sol
1195 
1196 pragma solidity ^0.5.10;
1197 
1198 /// @title FullWalletByteCode
1199 /// @dev A contract containing the FullWallet bytecode, for use in deployment.
1200 contract FullWalletByteCode {
1201     /// @notice This is the raw bytecode of the full wallet. It is encoded here as a raw byte
1202     ///  array to support deployment with CREATE2, as Solidity's 'new' constructor system does
1203     ///  not support CREATE2 yet.
1204     ///
1205     ///  NOTE: Be sure to update this whenever the wallet bytecode changes!
1206     ///  Simply run `npm run build` and then copy the `"bytecode"`
1207     ///  portion from the `build/contracts/FullWallet.json` file to here,
1208     ///  then append 64x3 0's.
1209     bytes constant fullWalletBytecode = hex'60806040523480156200001157600080fd5b50604051620033a7380380620033a7833981810160405260608110156200003757600080fd5b50805160208201516040909201519091906200005e8383836001600160e01b036200006716565b5050506200033b565b60045474010000000000000000000000000000000000000000900460ff1615620000f257604080517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601f60248201527f6d757374206e6f7420616c726561647920626520696e697469616c697a656400604482015290519081900360640190fd5b6004805460ff60a01b1916740100000000000000000000000000000000000000001790556001600160a01b0383811690821614156200017d576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401808060200182810382526039815260200180620033406039913960400191505060405180910390fd5b806001600160a01b0316826001600160a01b03161415620001ea576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252602e81526020018062003379602e913960400191505060405180910390fd5b6001600160a01b0383166200024b576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401808060200182810382526026815260200180620032f86026913960400191505060405180910390fd5b6001600160a01b038216620002ac576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260228152602001806200331e6022913960400191505060405180910390fd5b600480546001600160a01b0319166001600160a01b03838116919091179091557401000000000000000000000000000000000000000060008181559185169081018252600160209081526040928390208590558251918252810184905281517fb39b5f240c7440b58c1c6cfd328b09ff9aa18b3c8ef4b829774e4f5bad039416929181900390910190a1505050565b612fad806200034b6000396000f3fe6080604052600436106101d85760003560e01c80637ecebe0011610102578063bc197c8111610095578063ef009e4211610064578063ef009e4214610c68578063f0b9e5ba14610cea578063f23a6e6114610d7a578063ffa1ad7414610e1a576101d8565b8063bc197c8114610a20578063bf4fb0c014610b54578063c0ee0b8a14610b8d578063ce2d4f9614610c53576101d8565b80639105d9c4116100d15780639105d9c4146108b657806391aeeedc146108cb578063a0a2daf014610971578063a3c89c4f146109a5576101d8565b80637ecebe00146107e857806388fb06e71461081b5780638bf788741461085e5780638fd45d1a14610873576101d8565b8063210d66f81161017a57806357e61e291161014957806357e61e29146106d8578063710eb26c14610769578063727b7acf1461079a57806375857eba146107d3576101d8565b8063210d66f8146105865780632698c20c146105c257806343fc00b81461066257806349efe5ae146106a5576101d8565b8063157ca6e4116101b6578063157ca6e4146103fe578063158ef93e146104bd5780631626ba7e146104d25780631cd61bad14610554576101d8565b806301ffc9a7146102b357806308405166146102fb578063150b7a021461032d575b3415610219576040805133815234602082015281517f88a5966d370b9919b20f3e2c13ff65706f196a4e32cc2c12bf57088f88525874929181900390910190a15b36156102b157600080356001600160e01b0319168152600360205260409020546001600160a01b03166001811161028d576040805162461bcd60e51b815260206004820152601360248201527224b73b30b634b2103a3930b739b0b1ba34b7b760691b604482015290519081900360640190fd5b3660008037600080366000845afa3d6000803e8080156102ac573d6000f35b3d6000fd5b005b3480156102bf57600080fd5b506102e7600480360360208110156102d657600080fd5b50356001600160e01b031916610ea4565b604080519115158252519081900360200190f35b34801561030757600080fd5b50610310610f7a565b604080516001600160e01b03199092168252519081900360200190f35b34801561033957600080fd5b506103106004803603608081101561035057600080fd5b6001600160a01b03823581169260208101359091169160408201359190810190608081016060820135600160201b81111561038a57600080fd5b82018360208201111561039c57600080fd5b803590602001918460018302840111600160201b831117156103bd57600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550610f85945050505050565b34801561040a57600080fd5b506102b16004803603606081101561042157600080fd5b810190602081018135600160201b81111561043b57600080fd5b82018360208201111561044d57600080fd5b803590602001918460018302840111600160201b8311171561046e57600080fd5b91908080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525092955050823593505050602001356001600160a01b0316610f95565b3480156104c957600080fd5b506102e76111ed565b3480156104de57600080fd5b50610310600480360360408110156104f557600080fd5b81359190810190604081016020820135600160201b81111561051657600080fd5b82018360208201111561052857600080fd5b803590602001918460018302840111600160201b8311171561054957600080fd5b5090925090506111fd565b34801561056057600080fd5b5061056961156a565b604080516001600160f81b03199092168252519081900360200190f35b34801561059257600080fd5b506105b0600480360360208110156105a957600080fd5b503561156f565b60408051918252519081900360200190f35b3480156105ce57600080fd5b506102b160048036036101208110156105e657600080fd5b6040820190608083019060c0840135906001600160a01b0360e086013516908501856101208101610100820135600160201b81111561062457600080fd5b82018360208201111561063657600080fd5b803590602001918460018302840111600160201b8311171561065757600080fd5b509092509050611581565b34801561066e57600080fd5b506102b16004803603606081101561068557600080fd5b506001600160a01b03813581169160208101359160409091013516611a30565b3480156106b157600080fd5b506102b1600480360360208110156106c857600080fd5b50356001600160a01b0316611c46565b3480156106e457600080fd5b506102b1600480360360808110156106fb57600080fd5b60ff8235169160208101359160408201359190810190608081016060820135600160201b81111561072b57600080fd5b82018360208201111561073d57600080fd5b803590602001918460018302840111600160201b8311171561075e57600080fd5b509092509050611d58565b34801561077557600080fd5b5061077e611fd5565b604080516001600160a01b039092168252519081900360200190f35b3480156107a657600080fd5b506102b1600480360360408110156107bd57600080fd5b506001600160a01b038135169060200135611fe4565b3480156107df57600080fd5b506105b0612199565b3480156107f457600080fd5b506105b06004803603602081101561080b57600080fd5b50356001600160a01b03166121a1565b34801561082757600080fd5b506102b16004803603604081101561083e57600080fd5b5080356001600160e01b03191690602001356001600160a01b03166121b3565b34801561086a57600080fd5b506105b0612279565b34801561087f57600080fd5b506102b16004803603606081101561089657600080fd5b506001600160a01b0381358116916020810135916040909101351661227f565b3480156108c257600080fd5b5061077e61249e565b3480156108d757600080fd5b506102b1600480360360c08110156108ee57600080fd5b60ff823516916020810135916040820135916060810135916001600160a01b03608083013516919081019060c0810160a0820135600160201b81111561093357600080fd5b82018360208201111561094557600080fd5b803590602001918460018302840111600160201b8311171561096657600080fd5b5090925090506124a3565b34801561097d57600080fd5b5061077e6004803603602081101561099457600080fd5b50356001600160e01b0319166127e6565b3480156109b157600080fd5b506102b1600480360360208110156109c857600080fd5b810190602081018135600160201b8111156109e257600080fd5b8201836020820111156109f457600080fd5b803590602001918460018302840111600160201b83111715610a1557600080fd5b509092509050612801565b348015610a2c57600080fd5b50610310600480360360a0811015610a4357600080fd5b6001600160a01b038235811692602081013590911691810190606081016040820135600160201b811115610a7657600080fd5b820183602082011115610a8857600080fd5b803590602001918460208302840111600160201b83111715610aa957600080fd5b919390929091602081019035600160201b811115610ac657600080fd5b820183602082011115610ad857600080fd5b803590602001918460208302840111600160201b83111715610af957600080fd5b919390929091602081019035600160201b811115610b1657600080fd5b820183602082011115610b2857600080fd5b803590602001918460018302840111600160201b83111715610b4957600080fd5b5090925090506128b1565b348015610b6057600080fd5b506102b160048036036040811015610b7757600080fd5b506001600160a01b0381351690602001356128c5565b348015610b9957600080fd5b506102b160048036036060811015610bb057600080fd5b6001600160a01b0382351691602081013591810190606081016040820135600160201b811115610bdf57600080fd5b820183602082011115610bf157600080fd5b803590602001918460018302840111600160201b83111715610c1257600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550612a68945050505050565b348015610c5f57600080fd5b50610569612a6d565b348015610c7457600080fd5b506102b160048036036040811015610c8b57600080fd5b81359190810190604081016020820135600160201b811115610cac57600080fd5b820183602082011115610cbe57600080fd5b803590602001918460208302840111600160201b83111715610cdf57600080fd5b509092509050612a75565b348015610cf657600080fd5b5061031060048036036060811015610d0d57600080fd5b6001600160a01b0382351691602081013591810190606081016040820135600160201b811115610d3c57600080fd5b820183602082011115610d4e57600080fd5b803590602001918460018302840111600160201b83111715610d6f57600080fd5b509092509050612b72565b348015610d8657600080fd5b50610310600480360360a0811015610d9d57600080fd5b6001600160a01b03823581169260208101359091169160408201359160608101359181019060a081016080820135600160201b811115610ddc57600080fd5b820183602082011115610dee57600080fd5b803590602001918460018302840111600160201b83111715610e0f57600080fd5b509092509050612b82565b348015610e2657600080fd5b50610e2f612b94565b6040805160208082528351818301528351919283929083019185019080838360005b83811015610e69578181015183820152602001610e51565b50505050905090810190601f168015610e965780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60006001600160e01b031982166301ffc9a760e01b1480610ed557506001600160e01b03198216630a85bd0160e11b145b80610ef057506001600160e01b0319821663785cf2dd60e11b145b80610f0b57506001600160e01b0319821663607705c560e11b145b80610f2657506001600160e01b03198216630271189760e51b145b80610f4157506001600160e01b03198216630b135d3f60e11b145b15610f4e57506001610f75565b506001600160e01b031981166000908152600360205260409020546001600160a01b031615155b919050565b63607705c560e11b81565b630a85bd0160e11b949350505050565b600454600160a01b900460ff1615610ff4576040805162461bcd60e51b815260206004820152601f60248201527f6d757374206e6f7420616c726561647920626520696e697469616c697a656400604482015290519081900360640190fd5b6004805460ff60a01b1916600160a01b179055606061101284612bb5565b905060005b81518110156111e657600082828151811061102e57fe5b60200260200101519050836001600160a01b0316816001600160a01b031614156110895760405162461bcd60e51b8152600401808060200182810382526039815260200180612ef06039913960400191505060405180910390fd5b836001600160a01b0316856001600160a01b031614156110da5760405162461bcd60e51b815260040180806020018281038252602e815260200180612f29602e913960400191505060405180910390fd5b6001600160a01b03811661111f5760405162461bcd60e51b8152600401808060200182810382526026815260200180612ea86026913960400191505060405180910390fd5b6001600160a01b0385166111645760405162461bcd60e51b8152600401808060200182810382526022815260200180612ece6022913960400191505060405180910390fd5b600480546001600160a01b0319166001600160a01b0386811691909117909155600160a01b60008181559183169081018252600160209081526040928390208890558251918252810187905281517fb39b5f240c7440b58c1c6cfd328b09ff9aa18b3c8ef4b829774e4f5bad039416929181900390910190a150600101611017565b5050505050565b600454600160a01b900460ff1681565b60408051601960f81b6020808301919091526000602183018190523060601b602284015260368084018890528451808503909101815260569093019093528151910120611248612e1d565b611250612e1d565b611258612e1d565b6000806041881415611329576112ae60008a8a8080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929392505063ffffffff612c49169050565b60ff908116865290865281875284518651604080516000815260208181018084528d9052939094168482015260608401949094526080830152915160019260a0808401939192601f1981019281900390910190855afa158015611315573d6000803e3d6000fd5b5050506020604051035191508190506114cd565b60828814156114bd5761137c60008a8a8080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929392505063ffffffff612c49169050565b60ff16855285528552604080516020601f8b018190048102820181019092528981526113cf91604191908c908c9081908401838280828437600092019190915250929392505063ffffffff612c49169050565b60ff908116602087810191909152878101929092528188019290925284518751875160408051600081528086018083528d9052939095168386015260608301919091526080820152915160019260a08082019392601f1981019281900390910190855afa158015611444573d6000803e3d6000fd5b505060408051601f19808201516020808901518b8201518b830151600087528387018089528f905260ff909216868801526060860152608085015293519096506001945060a08084019493928201928290030190855afa1580156114ac573d6000803e3d6000fd5b5050506020604051035190506114cd565b5060009550611563945050505050565b6001600160a01b0382166114eb575060009550611563945050505050565b6001600160a01b038116611509575060009550611563945050505050565b806001600160a01b031660016000846001600160a01b0316600054018152602001908152602001600020546001600160a01b031614611552575060009550611563945050505050565b50630b135d3f60e11b955050505050505b9392505050565b600081565b60016020526000908152604090205481565b601b60ff88351614806115985750601c60ff883516145b6115e9576040805162461bcd60e51b815260206004820152601e60248201527f696e76616c6964207369676e61747572652076657273696f6e20765b305d0000604482015290519081900360640190fd5b601b60ff60208901351614806116065750601c60ff602089013516145b611657576040805162461bcd60e51b815260206004820152601e60248201527f696e76616c6964207369676e61747572652076657273696f6e20765b315d0000604482015290519081900360640190fd5b604051601960f81b6020820181815260006021840181905230606081811b6022870152603686018a905288901b6bffffffffffffffffffffffff1916605686015290938492899189918991899190606a018383808284378083019250505097505050505050505060405160208183030381529060405280519060200120905060006001828a6000600281106116e857fe5b602002013560ff168a6000600281106116fd57fe5b604080516000815260208181018084529690965260ff90941684820152908402919091013560608301528a3560808301525160a08083019392601f198301929081900390910190855afa158015611758573d6000803e3d6000fd5b505060408051601f1980820151600080845260208085018087528990528f81013560ff16858701528e81013560608601528d81013560808601529451919650945060019360a0808501949193830192918290030190855afa1580156117c1573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b038216611829576040805162461bcd60e51b815260206004820152601d60248201527f496e76616c6964207369676e617475726520666f72207369676e65722e000000604482015290519081900360640190fd5b6001600160a01b038116611884576040805162461bcd60e51b815260206004820152601f60248201527f496e76616c6964207369676e617475726520666f7220636f7369676e65722e00604482015290519081900360640190fd5b856001600160a01b0316826001600160a01b0316146118d45760405162461bcd60e51b8152600401808060200182810382526022815260200180612f576022913960400191505060405180910390fd5b6001600160a01b0382166000908152600260205260409020548711611940576040805162461bcd60e51b815260206004820152601f60248201527f6d757374207573652076616c6964206e6f6e636520666f72207369676e657200604482015290519081900360640190fd5b600080546001600160a01b0380851691820183526001602052604090922054918216148061197f5750816001600160a01b0316816001600160a01b0316145b6119c9576040805162461bcd60e51b815260206004820152601660248201527524b73b30b634b21030baba3437b934bd30ba34b7b71760511b604482015290519081900360640190fd5b6001600160a01b0383166000908152600260209081526040918290208a90558151601f8801829004820281018201909252868252611a239186918990899081908401838280828437600092019190915250612c6592505050565b5050505050505050505050565b600454600160a01b900460ff1615611a8f576040805162461bcd60e51b815260206004820152601f60248201527f6d757374206e6f7420616c726561647920626520696e697469616c697a656400604482015290519081900360640190fd5b6004805460ff60a01b1916600160a01b1790556001600160a01b038381169082161415611aed5760405162461bcd60e51b8152600401808060200182810382526039815260200180612ef06039913960400191505060405180910390fd5b806001600160a01b0316826001600160a01b03161415611b3e5760405162461bcd60e51b815260040180806020018281038252602e815260200180612f29602e913960400191505060405180910390fd5b6001600160a01b038316611b835760405162461bcd60e51b8152600401808060200182810382526026815260200180612ea86026913960400191505060405180910390fd5b6001600160a01b038216611bc85760405162461bcd60e51b8152600401808060200182810382526022815260200180612ece6022913960400191505060405180910390fd5b600480546001600160a01b0319166001600160a01b0383811691909117909155600160a01b60008181559185169081018252600160209081526040928390208590558251918252810184905281517fb39b5f240c7440b58c1c6cfd328b09ff9aa18b3c8ef4b829774e4f5bad039416929181900390910190a1505050565b333014611c9a576040805162461bcd60e51b815260206004820152601e60248201527f6d7573742062652063616c6c65642066726f6d2060696e766f6b652829600000604482015290519081900360640190fd5b600080546001600160a01b03838116909101825260016020526040909120541615611cf65760405162461bcd60e51b8152600401808060200182810382526039815260200180612e3c6039913960400191505060405180910390fd5b600480546001600160a01b038381166001600160a01b0319831617928390556040805192821680845293909116602083015280517f568ab3dedd6121f0385e007e641e74e1f49d0fa69cab2957b0b07c4c7de5abb69281900390910190a15050565b8460ff16601b1480611d6d57508460ff16601c145b611dbe576040805162461bcd60e51b815260206004820152601a60248201527f496e76616c6964207369676e61747572652076657273696f6e2e000000000000604482015290519081900360640190fd5b336000818152600260209081526040808320549051601960f81b9281018381526021820185905230606081811b60228501526036840185905287901b6056840152929585939287928a918a9190606a0183838082843780830192505050975050505050505050604051602081830303815290604052805190602001209050600060018289898960405160008152602001604052604051808581526020018460ff1660ff1681526020018381526020018281526020019450505050506020604051602081039080840390855afa158015611e9b573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b038116611ef8576040805162461bcd60e51b815260206004820152601260248201527124b73b30b634b21039b4b3b730ba3ab9329760711b604482015290519081900360640190fd5b6000805433018152600160205260409020546001600160a01b038181169083161480611f2c57506001600160a01b03811633145b611f76576040805162461bcd60e51b815260206004820152601660248201527524b73b30b634b21030baba3437b934bd30ba34b7b71760511b604482015290519081900360640190fd5b336000908152600260209081526040918290206001870190558151601f8801829004820281018201909252868252611fca9185918990899081908401838280828437600092019190915250612c6592505050565b505050505050505050565b6004546001600160a01b031681565b6004546001600160a01b03163314612043576040805162461bcd60e51b815260206004820152601f60248201527f73656e646572206d757374206265207265636f76657279206164647265737300604482015290519081900360640190fd5b6001600160a01b0382166120885760405162461bcd60e51b8152600401808060200182810382526026815260200180612ea86026913960400191505060405180910390fd5b6004546001600160a01b03838116911614156120d55760405162461bcd60e51b8152600401808060200182810382526039815260200180612ef06039913960400191505060405180910390fd5b6001600160a01b038116612130576040805162461bcd60e51b815260206004820152601e60248201527f54686520636f7369676e6572206d757374206e6f74206265207a65726f2e0000604482015290519081900360640190fd5b60008054600160a01b81810183556001600160a01b038516918201018252600160209081526040928390208490558251918252810183905281517fa9364fb2836862098c2b593d2d3f46759b4c6d5b054300f96172b0394430008a929181900390910190a15050565b600160a01b81565b60026020526000908152604090205481565b333014612207576040805162461bcd60e51b815260206004820152601e60248201527f6d7573742062652063616c6c65642066726f6d2060696e766f6b652829600000604482015290519081900360640190fd5b6001600160e01b0319821660008181526003602090815260409182902080546001600160a01b0319166001600160a01b03861690811790915582519384529083015280517fd09b01a1a877e1a97b048725e0697d9be07bb94320c536e72b976c81016891fb9281900390910190a15050565b60005481565b6004546001600160a01b031633146122de576040805162461bcd60e51b815260206004820152601f60248201527f73656e646572206d757374206265207265636f76657279206164647265737300604482015290519081900360640190fd5b6001600160a01b0383166123235760405162461bcd60e51b8152600401808060200182810382526026815260200180612ea86026913960400191505060405180910390fd5b806001600160a01b0316836001600160a01b031614156123745760405162461bcd60e51b8152600401808060200182810382526039815260200180612ef06039913960400191505060405180910390fd5b6001600160a01b0382166123cf576040805162461bcd60e51b815260206004820152601e60248201527f54686520636f7369676e6572206d757374206e6f74206265207a65726f2e0000604482015290519081900360640190fd5b60008054600160a01b81810183556001600160a01b0380871690920101825260016020908152604092839020859055600480548584166001600160a01b03198216179182905584519084168082529190931691830191909152825190927f568ab3dedd6121f0385e007e641e74e1f49d0fa69cab2957b0b07c4c7de5abb6928290030190a1604080516001600160a01b03861681526020810185905281517fa9364fb2836862098c2b593d2d3f46759b4c6d5b054300f96172b0394430008a929181900390910190a150505050565b600181565b8660ff16601b14806124b857508660ff16601c145b612509576040805162461bcd60e51b815260206004820152601a60248201527f496e76616c6964207369676e61747572652076657273696f6e2e000000000000604482015290519081900360640190fd5b604051601960f81b6020820181815260006021840181905230606081811b6022870152603686018a905288901b6bffffffffffffffffffffffff1916605686015290938492899189918991899190606a018383808284378083019250505097505050505050505060405160208183030381529060405280519060200120905060006001828a8a8a60405160008152602001604052604051808581526020018460ff1660ff1681526020018381526020018281526020019450505050506020604051602081039080840390855afa1580156125e7573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b038116612644576040805162461bcd60e51b815260206004820152601260248201527124b73b30b634b21039b4b3b730ba3ab9329760711b604482015290519081900360640190fd5b6001600160a01b03811660009081526002602052604090205486116126b0576040805162461bcd60e51b815260206004820152601f60248201527f6d757374207573652076616c6964206e6f6e636520666f72207369676e657200604482015290519081900360640190fd5b846001600160a01b0316816001600160a01b0316146127005760405162461bcd60e51b8152600401808060200182810382526022815260200180612f576022913960400191505060405180910390fd5b600080546001600160a01b0380841691820183526001602052604090922054918216148061273657506001600160a01b03811633145b612780576040805162461bcd60e51b815260206004820152601660248201527524b73b30b634b21030baba3437b934bd30ba34b7b71760511b604482015290519081900360640190fd5b6001600160a01b0382166000908152600260209081526040918290208990558151601f87018290048202810182019092528582526127da9185918890889081908401838280828437600092019190915250612c6592505050565b50505050505050505050565b6003602052600090815260409020546001600160a01b031681565b6000805433908101825260016020526040909120546001600160a01b03161461286a576040805162461bcd60e51b815260206004820152601660248201527524b73b30b634b21030baba3437b934bd30ba34b7b71760511b604482015290519081900360640190fd5b6128ad6000801b83838080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250612c6592505050565b5050565b63bc197c8160e01b98975050505050505050565b333014612919576040805162461bcd60e51b815260206004820152601e60248201527f6d7573742062652063616c6c65642066726f6d2060696e766f6b652829600000604482015290519081900360640190fd5b6001600160a01b03821661295e5760405162461bcd60e51b8152600401808060200182810382526026815260200180612ea86026913960400191505060405180910390fd5b6004546001600160a01b03838116911614156129ab5760405162461bcd60e51b8152600401808060200182810382526039815260200180612ef06039913960400191505060405180910390fd5b6001600160a01b03811615806129cf57506004546001600160a01b03828116911614155b612a0a5760405162461bcd60e51b815260040180806020018281038252602e815260200180612f29602e913960400191505060405180910390fd5b600080546001600160a01b0384169081018252600160209081526040928390208490558251918252810183905281517fb39b5f240c7440b58c1c6cfd328b09ff9aa18b3c8ef4b829774e4f5bad039416929181900390910190a15050565b505050565b601960f81b81565b600083118015612a88575063ffffffff83105b612ad9576040805162461bcd60e51b815260206004820152601760248201527f496e76616c69642076657273696f6e206e756d6265722e000000000000000000604482015290519081900360640190fd5b60005460a084901b908110612b1f5760405162461bcd60e51b8152600401808060200182810382526033815260200180612e756033913960400191505060405180910390fd5b60005b828110156111e65760016000858584818110612b3a57fe5b905060200201356001600160a01b03166001600160a01b03168401815260200190815260200160002060009055806001019050612b22565b63785cf2dd60e11b949350505050565b63f23a6e6160e01b9695505050505050565b604051806040016040528060058152602001640312e312e360dc1b81525081565b60606014825181612bc257fe5b04604051908082528060200260200182016040528015612bec578160200160208202803883390190505b50905060005b8251811015612c4357600080826014019050808501519150818460148581612c1657fe5b0481518110612c2157fe5b6001600160a01b03909216602092830291909101909101525050601401612bf2565b50919050565b0160208101516040820151606090920151909260009190911a90565b60008060606040518060400160405280601481526020017311185d1848199a595b19081d1bdbc81cda1bdc9d60621b815250905060606040518060400160405280600b81526020016a10d85b1b0819985a5b195960aa1b81525090506055855110158290612d515760405162461bcd60e51b81526004018080602001828103825283818151815260200191508051906020019080838360005b83811015612d16578181015183820152602001612cfe565b50505050905090810190601f168015612d435780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b5060208501805160001a865182016001830192505b80831015612dd157603483015160548401810182811115612d8957865160208801fd5b60008083605488016014890151895160601c5af1612dc1578360018114612db7578960020a89179850612dbf565b865160208801fd5b505b6001890198508094505050612d66565b5050604080518881526020810186905280820187905290517f101214446435ebbb29893f3348e3aae5ea070b63037a3df346d09d3396a34aee92509081900360600190a1505050505050565b6040518060400160405280600290602082028038833950919291505056fe446f206e6f742075736520616e20617574686f72697a6564206164647265737320617320746865207265636f7665727920616464726573732e596f752063616e206f6e6c79207265636f766572206761732066726f6d2065787069726564206175746856657273696f6e732e417574686f72697a656420616464726573736573206d757374206e6f74206265207a65726f2e496e697469616c20636f7369676e6572206d757374206e6f74206265207a65726f2e446f206e6f742075736520746865207265636f76657279206164647265737320617320616e20617574686f72697a656420616464726573732e446f206e6f742075736520746865207265636f766572792061646472657373206173206120636f7369676e65722e617574686f72697a656420616464726573736573206d75737420626520657175616ca265627a7a723058202bf5771700693f16c2ca90585279bc0b2313fd2ebde70ff6d3e41bd74a5838a964736f6c634300050a0032417574686f72697a656420616464726573736573206d757374206e6f74206265207a65726f2e496e697469616c20636f7369676e6572206d757374206e6f74206265207a65726f2e446f206e6f742075736520746865207265636f76657279206164647265737320617320616e20617574686f72697a656420616464726573732e446f206e6f742075736520746865207265636f766572792061646472657373206173206120636f7369676e65722e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
1210 }
1211 
1212 // File: contracts/WalletFactory/WalletFactory.sol
1213 
1214 pragma solidity ^0.5.10;
1215 
1216 
1217 
1218 
1219 
1220 
1221 /// @title WalletFactory
1222 /// @dev A contract for creating wallets. 
1223 contract WalletFactory is FullWalletByteCode, HasNoEther, CloneFactory {
1224 
1225     /// @dev Pointer to a pre-deployed instance of the Wallet contract. This
1226     ///  deployment contains all the Wallet code.
1227     address public cloneWalletAddress;
1228 
1229     /// @notice Emitted whenever a wallet is created
1230     /// @param wallet The address of the wallet created
1231     /// @param authorizedAddress The initial authorized address of the wallet
1232     /// @param full `true` if the deployed wallet was a full, self
1233     ///  contained wallet; `false` if the wallet is a clone wallet
1234     event WalletCreated(address wallet, address authorizedAddress, bool full);
1235 
1236     constructor(address _cloneWalletAddress) public {
1237         cloneWalletAddress = _cloneWalletAddress;
1238     }
1239 
1240     /// @notice Used to deploy a wallet clone
1241     /// @dev Reasonably cheap to run (~100K gas)
1242     /// @param _recoveryAddress the initial recovery address for the wallet
1243     /// @param _authorizedAddress an initial authorized address for the wallet
1244     /// @param _cosigner the cosigning address for the initial `_authorizedAddress`
1245     function deployCloneWallet(
1246         address _recoveryAddress,
1247         address _authorizedAddress,
1248         uint256 _cosigner
1249     )
1250         public 
1251     {
1252         // create the clone
1253         address payable clone = createClone(cloneWalletAddress);
1254         // init the clone
1255         CloneableWallet(clone).init(_authorizedAddress, _cosigner, _recoveryAddress);
1256         // emit event
1257         emit WalletCreated(clone, _authorizedAddress, false);
1258     }
1259 
1260     /// @notice Used to deploy a wallet clone
1261     /// @dev Reasonably cheap to run (~100K gas)
1262     /// @dev The clone does not require `onlyOwner` as we avoid front-running
1263     ///  attacks by hashing the salt combined with the call arguments and using
1264     ///  that as the salt we provide to `create2`. Given this constraint, a 
1265     ///  front-runner would need to use the same `_recoveryAddress`, `_authorizedAddress`,
1266     ///  and `_cosigner` parameters as the original deployer, so the original deployer
1267     ///  would have control of the wallet even if the transaction was front-run.
1268     /// @param _recoveryAddress the initial recovery address for the wallet
1269     /// @param _authorizedAddress an initial authorized address for the wallet
1270     /// @param _cosigner the cosigning address for the initial `_authorizedAddress`
1271     /// @param _salt the salt for the `create2` instruction
1272     function deployCloneWallet2(
1273         address _recoveryAddress,
1274         address _authorizedAddress,
1275         uint256 _cosigner,
1276         bytes32 _salt
1277     )
1278         public
1279     {
1280         // calculate our own salt based off of args
1281         bytes32 salt = keccak256(abi.encodePacked(_salt, _authorizedAddress, _cosigner, _recoveryAddress));
1282         // create the clone counterfactually
1283         address payable clone = createClone2(cloneWalletAddress, salt);
1284         // ensure we get an address
1285         require(clone != address(0), "wallet must have address");
1286 
1287         // check size
1288         uint256 size;
1289         // note this takes an additional 700 gas
1290         assembly {
1291             size := extcodesize(clone)
1292         }
1293 
1294         require(size > 0, "wallet must have code");
1295 
1296         // init the clone
1297         CloneableWallet(clone).init(_authorizedAddress, _cosigner, _recoveryAddress);
1298         // emit event
1299         emit WalletCreated(clone, _authorizedAddress, false);   
1300     }
1301 
1302     function deployCloneWallet2WithMultiAuthorizedAddress(
1303             address _recoveryAddress,
1304             bytes memory _authorizedAddresses,
1305             uint256 _cosigner,
1306             bytes32 _salt
1307         )
1308             public
1309         {
1310             require(_authorizedAddresses.length / 20 > 0 && _authorizedAddresses.length % 20 == 0, "invalid address byte array");
1311             address[] memory addresses = bytesToAddresses(_authorizedAddresses);
1312 
1313             // calculate our own salt based off of args
1314             bytes32 salt = keccak256(abi.encodePacked(_salt, addresses[0], _cosigner, _recoveryAddress));
1315             // create the clone counterfactually
1316             address payable clone = createClone2(cloneWalletAddress, salt);
1317             // ensure we get an address
1318             require(clone != address(0), "wallet must have address");
1319 
1320             // check size
1321             uint256 size;
1322             // note this takes an additional 700 gas
1323             assembly {
1324                 size := extcodesize(clone)
1325             }
1326 
1327             require(size > 0, "wallet must have code");
1328 
1329             // init the clone
1330             CloneableWallet(clone).init2(_authorizedAddresses, _cosigner, _recoveryAddress);
1331             // emit event
1332             emit WalletCreated(clone, addresses[0], false);
1333         }
1334 
1335     function bytesToAddresses(bytes memory bys) private pure returns (address[] memory addresses) {
1336         addresses = new address[](bys.length/20);
1337         for (uint i=0; i < bys.length; i+=20) {
1338             address addr;
1339             uint end = i+20;
1340             assembly {
1341               addr := mload(add(bys,end))
1342             }
1343             addresses[i/20] = addr;
1344         }
1345     }
1346 
1347     /// @notice Used to deploy a full wallet
1348     /// @dev This is potentially very gas intensive!
1349     /// @param _recoveryAddress The initial recovery address for the wallet
1350     /// @param _authorizedAddress An initial authorized address for the wallet
1351     /// @param _cosigner The cosigning address for the initial `_authorizedAddress`
1352     function deployFullWallet(
1353         address _recoveryAddress,
1354         address _authorizedAddress,
1355         uint256 _cosigner
1356     )
1357         public 
1358     {
1359         // Copy the bytecode of the full wallet to memory.
1360         bytes memory fullWallet = fullWalletBytecode;
1361 
1362         address full;
1363         assembly {
1364             // get start of wallet buffer
1365             let startPtr := add(fullWallet, 0x20)
1366             // get start of arguments
1367             let endPtr := sub(add(startPtr, mload(fullWallet)), 0x60)
1368             // copy constructor parameters to memory
1369             mstore(endPtr, _authorizedAddress)
1370             mstore(add(endPtr, 0x20), _cosigner)
1371             mstore(add(endPtr, 0x40), _recoveryAddress)
1372             // create the contract
1373             full := create(0, startPtr, mload(fullWallet))
1374         }
1375         
1376         // check address
1377         require(full != address(0), "wallet must have address");
1378 
1379         // check size
1380         uint256 size;
1381         // note this takes an additional 700 gas, 
1382         // which is a relatively small amount in this case
1383         assembly {
1384             size := extcodesize(full)
1385         }
1386 
1387         require(size > 0, "wallet must have code");
1388 
1389         emit WalletCreated(full, _authorizedAddress, true);
1390     }
1391 
1392     /// @notice Used to deploy a full wallet counterfactually
1393     /// @dev This is potentially very gas intensive!
1394     /// @dev As the arguments are appended to the end of the bytecode and
1395     ///  then included in the `create2` call, we are safe from front running
1396     ///  attacks and do not need to restrict the caller of this function.
1397     /// @param _recoveryAddress The initial recovery address for the wallet
1398     /// @param _authorizedAddress An initial authorized address for the wallet
1399     /// @param _cosigner The cosigning address for the initial `_authorizedAddress`
1400     /// @param _salt The salt for the `create2` instruction
1401     function deployFullWallet2(
1402         address _recoveryAddress,
1403         address _authorizedAddress,
1404         uint256 _cosigner,
1405         bytes32 _salt
1406     )
1407         public
1408     {
1409         // Note: Be sure to update this whenever the wallet bytecode changes!
1410         // Simply run `yarn run build` and then copy the `"bytecode"`
1411         // portion from the `build/contracts/FullWallet.json` file to here,
1412         // then append 64x3 0's.
1413         //
1414         // Note: By not passing in the code as an argument, we save 600,000 gas.
1415         // An alternative would be to use `extcodecopy`, but again we save
1416         // gas by not having to call `extcodecopy`.
1417         bytes memory fullWallet = fullWalletBytecode;
1418 
1419         address full;
1420         assembly {
1421             // get start of wallet buffer
1422             let startPtr := add(fullWallet, 0x20)
1423             // get start of arguments
1424             let endPtr := sub(add(startPtr, mload(fullWallet)), 0x60)
1425             // copy constructor parameters to memory
1426             mstore(endPtr, _authorizedAddress)
1427             mstore(add(endPtr, 0x20), _cosigner)
1428             mstore(add(endPtr, 0x40), _recoveryAddress)
1429             // create the contract using create2
1430             full := create2(0, startPtr, mload(fullWallet), _salt)
1431         }
1432         
1433         // check address
1434         require(full != address(0), "wallet must have address");
1435 
1436         // check size
1437         uint256 size;
1438         // note this takes an additional 700 gas, 
1439         // which is a relatively small amount in this case
1440         assembly {
1441             size := extcodesize(full)
1442         }
1443 
1444         require(size > 0, "wallet must have code");
1445 
1446         emit WalletCreated(full, _authorizedAddress, true);
1447     }
1448 }