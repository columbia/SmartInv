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
189 // File: contracts/ERC1271/ERC1271.sol
190 
191 pragma solidity ^0.5.10;
192 
193 contract ERC1271 {
194 
195     /// @dev bytes4(keccak256("isValidSignature(bytes32,bytes)")
196     bytes4 internal constant ERC1271_VALIDSIGNATURE = 0x1626ba7e;
197 
198     /// @dev Should return whether the signature provided is valid for the provided data
199     /// @param hash 32-byte hash of the data that is signed
200     /// @param _signature Signature byte array associated with _data
201     ///  MUST return the bytes4 magic value 0x1626ba7e when function passes.
202     ///  MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
203     ///  MUST allow external calls
204     function isValidSignature(
205         bytes32 hash, 
206         bytes calldata _signature)
207         external
208         view 
209         returns (bytes4);
210 }
211 
212 // File: contracts/ECDSA.sol
213 
214 pragma solidity ^0.5.10;
215 
216 
217 /// @title ECDSA is a library that contains useful methods for working with ECDSA signatures
218 library ECDSA {
219 
220     /// @notice Extracts the r, s, and v components from the `sigData` field starting from the `offset`
221     /// @dev Note: does not do any bounds checking on the arguments!
222     /// @param sigData the signature data; could be 1 or more packed signatures.
223     /// @param offset the offset in sigData from which to start unpacking the signature components.
224     function extractSignature(bytes memory sigData, uint256 offset) internal pure returns  (bytes32 r, bytes32 s, uint8 v) {
225         // Divide the signature in r, s and v variables
226         // ecrecover takes the signature parameters, and the only way to get them
227         // currently is to use assembly.
228         // solium-disable-next-line security/no-inline-assembly
229         assembly {
230              let dataPointer := add(sigData, offset)
231              r := mload(add(dataPointer, 0x20))
232              s := mload(add(dataPointer, 0x40))
233              v := byte(0, mload(add(dataPointer, 0x60)))
234         }
235     
236         return (r, s, v);
237     }
238 }
239 
240 // File: contracts/Wallet/CoreWallet.sol
241 
242 pragma solidity ^0.5.10;
243 
244 
245 
246 
247 
248 
249 /// @title Core Wallet
250 /// @notice A basic smart contract wallet with cosigner functionality. The notion of "cosigner" is
251 ///  the simplest possible multisig solution, a two-of-two signature scheme. It devolves nicely
252 ///  to "one-of-one" (i.e. singlesig) by simply having the cosigner set to the same value as
253 ///  the main signer.
254 /// 
255 ///  Most "advanced" functionality (deadman's switch, multiday recovery flows, blacklisting, etc)
256 ///  can be implemented externally to this smart contract, either as an additional smart contract
257 ///  (which can be tracked as a signer without cosigner, or as a cosigner) or as an off-chain flow
258 ///  using a public/private key pair as cosigner. Of course, the basic cosigning functionality could
259 ///  also be implemented in this way, but (A) the complexity and gas cost of two-of-two multisig (as
260 ///  implemented here) is negligable even if you don't need the cosigner functionality, and
261 ///  (B) two-of-two multisig (as implemented here) handles a lot of really common use cases, most
262 ///  notably third-party gas payment and off-chain blacklisting and fraud detection.
263 contract CoreWallet is ERC721Receivable, ERC223Receiver, ERC1271 {
264 
265     using ECDSA for bytes;
266 
267     /// @notice We require that presigned transactions use the EIP-191 signing format.
268     ///  See that EIP for more info: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-191.md
269     byte public constant EIP191_VERSION_DATA = byte(0);
270     byte public constant EIP191_PREFIX = byte(0x19);
271 
272     /// @notice This is the version of the contract.
273     string public constant VERSION = "1.1.0";
274 
275     /// @notice This is a sentinel value used to determine when a delegate is set to expose 
276     ///  support for an interface containing more than a single function. See `delegates` and
277     ///  `setDelegate` for more information.
278     address public constant COMPOSITE_PLACEHOLDER = address(1);
279 
280     /// @notice A pre-shifted "1", used to increment the authVersion, so we can "prepend"
281     ///  the authVersion to an address (for lookups in the authorizations mapping)
282     ///  by using the '+' operator (which is cheaper than a shift and a mask). See the
283     ///  comment on the `authorizations` variable for how this is used.
284     uint256 public constant AUTH_VERSION_INCREMENTOR = (1 << 160);
285     
286     /// @notice The pre-shifted authVersion (to get the current authVersion as an integer,
287     ///  shift this value right by 160 bits). Starts as `1 << 160` (`AUTH_VERSION_INCREMENTOR`)
288     ///  See the comment on the `authorizations` variable for how this is used.
289     uint256 public authVersion;
290 
291     /// @notice A mapping containing all of the addresses that are currently authorized to manage
292     ///  the assets owned by this wallet.
293     ///
294     ///  The keys in this mapping are authorized addresses with a version number prepended,
295     ///  like so: (authVersion,96)(address,160). The current authVersion MUST BE included
296     ///  for each look-up; this allows us to effectively clear the entire mapping of its
297     ///  contents merely by incrementing the authVersion variable. (This is important for
298     ///  the emergencyRecovery() method.) Inspired by https://ethereum.stackexchange.com/a/42540
299     ///
300     ///  The values in this mapping are 256bit words, whose lower 20 bytes constitute "cosigners"
301     ///  for each address. If an address maps to itself, then that address is said to have no cosigner.
302     ///
303     ///  The upper 12 bytes are reserved for future meta-data purposes.  The meta-data could refer
304     ///  to the key (authorized address) or the value (cosigner) of the mapping.
305     ///
306     ///  Addresses that map to a non-zero cosigner in the current authVersion are called
307     ///  "authorized addresses".
308     mapping(uint256 => uint256) public authorizations;
309 
310     /// @notice A per-key nonce value, incremented each time a transaction is processed with that key.
311     ///  Used for replay prevention. The nonce value in the transaction must exactly equal the current
312     ///  nonce value in the wallet for that key. (This mirrors the way Ethereum's transaction nonce works.)
313     mapping(address => uint256) public nonces;
314 
315     /// @notice A mapping tracking dynamically supported interfaces and their corresponding
316     ///  implementation contracts. Keys are interface IDs and values are addresses of
317     ///  contracts that are responsible for implementing the function corresponding to the
318     ///  interface.
319     ///  
320     ///  Delegates are added (or removed) via the `setDelegate` method after the contract is
321     ///  deployed, allowing support for new interfaces to be dynamically added after deployment.
322     ///  When a delegate is added, its interface ID is considered "supported" under EIP165. 
323     ///
324     ///  For cases where an interface composed of more than a single function must be
325     ///  supported, it is necessary to manually add the composite interface ID with 
326     ///  `setDelegate(interfaceId, COMPOSITE_PLACEHOLDER)`. Interface IDs added with the
327     ///  COMPOSITE_PLACEHOLDER address are ignored when called and are only used to specify
328     ///  supported interfaces.
329     mapping(bytes4 => address) public delegates;
330 
331     /// @notice A special address that is authorized to call `emergencyRecovery()`. That function
332     ///  resets ALL authorization for this wallet, and must therefore be treated with utmost security.
333     ///  Reasonable choices for recoveryAddress include:
334     ///       - the address of a private key in cold storage
335     ///       - a physically secured hardware wallet
336     ///       - a multisig smart contract, possibly with a time-delayed challenge period
337     ///       - the zero address, if you like performing without a safety net ;-)
338     address public recoveryAddress;
339 
340     /// @notice Used to track whether or not this contract instance has been initialized. This
341     ///  is necessary since it is common for this wallet smart contract to be used as the "library
342     ///  code" for an clone contract. See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
343     ///  for more information about clone contracts.
344     bool public initialized;
345     
346     /// @notice Used to decorate methods that can only be called directly by the recovery address.
347     modifier onlyRecoveryAddress() {
348         require(msg.sender == recoveryAddress, "sender must be recovery address");
349         _;
350     }
351 
352     /// @notice Used to decorate the `init` function so this can only be called one time. Necessary
353     ///  since this contract will often be used as a "clone". (See above.)
354     modifier onlyOnce() {
355         require(!initialized, "must not already be initialized");
356         initialized = true;
357         _;
358     }
359     
360     /// @notice Used to decorate methods that can only be called indirectly via an `invoke()` method.
361     ///  In practice, it means that those methods can only be called by a signer/cosigner
362     ///  pair that is currently authorized. Theoretically, we could factor out the
363     ///  signer/cosigner verification code and use it explicitly in this modifier, but that
364     ///  would either result in duplicated code, or additional overhead in the invoke()
365     ///  calls (due to the stack manipulation for calling into the shared verification function).
366     ///  Doing it this way makes calling the administration functions more expensive (since they
367     ///  go through a explicit call() instead of just branching within the contract), but it
368     ///  makes invoke() more efficient. We assume that invoke() will be used much, much more often
369     ///  than any of the administration functions.
370     modifier onlyInvoked() {
371         require(msg.sender == address(this), "must be called from `invoke()`");
372         _;
373     }
374     
375     /// @notice Emitted when an authorized address is added, removed, or modified. When an
376     ///  authorized address is removed ("deauthorized"), cosigner will be address(0) in
377     ///  this event.
378     ///  
379     ///  NOTE: When emergencyRecovery() is called, all existing addresses are deauthorized
380     ///  WITHOUT Authorized(addr, 0) being emitted. If you are keeping an off-chain mirror of
381     ///  authorized addresses, you must also watch for EmergencyRecovery events.
382     /// @dev hash is 0xf5a7f4fb8a92356e8c8c4ae7ac3589908381450500a7e2fd08c95600021ee889
383     /// @param authorizedAddress the address to authorize or unauthorize
384     /// @param cosigner the 2-of-2 signatory (optional).
385     event Authorized(address authorizedAddress, uint256 cosigner);
386     
387     /// @notice Emitted when an emergency recovery has been performed. If this event is fired,
388     ///  ALL previously authorized addresses have been deauthorized and the only authorized
389     ///  address is the authorizedAddress indicated in this event.
390     /// @dev hash is 0xe12d0bbeb1d06d7a728031056557140afac35616f594ef4be227b5b172a604b5
391     /// @param authorizedAddress the new authorized address
392     /// @param cosigner the cosigning address for `authorizedAddress`
393     event EmergencyRecovery(address authorizedAddress, uint256 cosigner);
394 
395     /// @notice Emitted when the recovery address changes. Either (but not both) of the
396     ///  parameters may be zero.
397     /// @dev hash is 0x568ab3dedd6121f0385e007e641e74e1f49d0fa69cab2957b0b07c4c7de5abb6
398     /// @param previousRecoveryAddress the previous recovery address
399     /// @param newRecoveryAddress the new recovery address
400     event RecoveryAddressChanged(address previousRecoveryAddress, address newRecoveryAddress);
401 
402     /// @dev Emitted when this contract receives a non-zero amount ether via the fallback function
403     ///  (i.e. This event is not fired if the contract receives ether as part of a method invocation)
404     /// @param from the address which sent you ether
405     /// @param value the amount of ether sent
406     event Received(address from, uint value);
407 
408     /// @notice Emitted whenever a transaction is processed successfully from this wallet. Includes
409     ///  both simple send ether transactions, as well as other smart contract invocations.
410     /// @dev hash is 0x101214446435ebbb29893f3348e3aae5ea070b63037a3df346d09d3396a34aee
411     /// @param hash The hash of the entire operation set. 0 is returned when emitted from `invoke0()`.
412     /// @param result A bitfield of the results of the operations. A bit of 0 means success, and 1 means failure.
413     /// @param numOperations A count of the number of operations processed
414     event InvocationSuccess(
415         bytes32 hash,
416         uint256 result,
417         uint256 numOperations
418     );
419 
420     /// @notice Emitted when a delegate is added or removed.
421     /// @param interfaceId The interface ID as specified by EIP165
422     /// @param delegate The address of the contract implementing the given function. If this is
423     ///  COMPOSITE_PLACEHOLDER, we are indicating support for a composite interface.
424     event DelegateUpdated(bytes4 interfaceId, address delegate);
425 
426     /// @notice The shared initialization code used to setup the contract state regardless of whether or
427     ///  not the clone pattern is being used.
428     /// @param _authorizedAddress the initial authorized address, must not be zero!
429     /// @param _cosigner the initial cosigning address for `_authorizedAddress`, can be equal to `_authorizedAddress`
430     /// @param _recoveryAddress the initial recovery address for the wallet, can be address(0)
431     function init(address _authorizedAddress, uint256 _cosigner, address _recoveryAddress) public onlyOnce {
432         require(_authorizedAddress != _recoveryAddress, "Do not use the recovery address as an authorized address.");
433         require(address(_cosigner) != _recoveryAddress, "Do not use the recovery address as a cosigner.");
434         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
435         require(address(_cosigner) != address(0), "Initial cosigner must not be zero.");
436         
437         recoveryAddress = _recoveryAddress;
438         // set initial authorization value
439         authVersion = AUTH_VERSION_INCREMENTOR;
440         // add initial authorized address
441         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
442         
443         emit Authorized(_authorizedAddress, _cosigner);
444     }
445 
446     /// @notice The fallback function, invoked whenever we receive a transaction that doesn't call any of our
447     ///  named functions. In particular, this method is called when we are the target of a simple send
448     ///  transaction, when someone calls a method we have dynamically added a delegate for, or when someone
449     ///  tries to call a function we don't implement, either statically or dynamically.
450     ///
451     ///  A correct invocation of this method occurs in two cases:
452     ///  - someone transfers ETH to this wallet (`msg.data.length` is  0)
453     ///  - someone calls a delegated function (`msg.data.length` is greater than 0 and
454     ///    `delegates[msg.sig]` is set) 
455     ///  In all other cases, this function will revert.
456     ///
457     ///  NOTE: Some smart contracts send 0 eth as part of a more complex operation
458     ///  (-cough- CryptoKitties -cough-); ideally, we'd `require(msg.value > 0)` here when
459     ///  `msg.data.length == 0`, but to work with those kinds of smart contracts, we accept zero sends
460     ///  and just skip logging in that case.
461     function() external payable {
462         if (msg.value > 0) {
463             emit Received(msg.sender, msg.value);
464         }
465         if (msg.data.length > 0) {
466             address delegate = delegates[msg.sig]; 
467             require(delegate > COMPOSITE_PLACEHOLDER, "Invalid transaction");
468 
469             // We have found a delegate contract that is responsible for the method signature of
470             // this call. Now, pass along the calldata of this CALL to the delegate contract.  
471             assembly {
472                 calldatacopy(0, 0, calldatasize())
473                 let result := staticcall(gas, delegate, 0, calldatasize(), 0, 0)
474                 returndatacopy(0, 0, returndatasize())
475 
476                 // If the delegate reverts, we revert. If the delegate does not revert, we return the data
477                 // returned by the delegate to the original caller.
478                 switch result 
479                 case 0 {
480                     revert(0, returndatasize())
481                 } 
482                 default {
483                     return(0, returndatasize())
484                 }
485             } 
486         }    
487     }
488 
489     /// @notice Adds or removes dynamic support for an interface. Can be used in 3 ways:
490     ///   - Add a contract "delegate" that implements a single function
491     ///   - Remove delegate for a function
492     ///   - Specify that an interface ID is "supported", without adding a delegate. This is
493     ///     used for composite interfaces when the interface ID is not a single method ID.
494     /// @dev Must be called through `invoke`
495     /// @param _interfaceId The ID of the interface we are adding support for
496     /// @param _delegate Either:
497     ///    - the address of a contract that implements the function specified by `_interfaceId`
498     ///      for adding an implementation for a single function
499     ///    - 0 for removing an existing delegate
500     ///    - COMPOSITE_PLACEHOLDER for specifying support for a composite interface
501     function setDelegate(bytes4 _interfaceId, address _delegate) external onlyInvoked {
502         delegates[_interfaceId] = _delegate;
503         emit DelegateUpdated(_interfaceId, _delegate);
504     }
505     
506     /// @notice Configures an authorizable address. Can be used in four ways:
507     ///   - Add a new signer/cosigner pair (cosigner must be non-zero)
508     ///   - Set or change the cosigner for an existing signer (if authorizedAddress != cosigner)
509     ///   - Remove the cosigning requirement for a signer (if authorizedAddress == cosigner)
510     ///   - Remove a signer (if cosigner == address(0))
511     /// @dev Must be called through `invoke()`
512     /// @param _authorizedAddress the address to configure authorization
513     /// @param _cosigner the corresponding cosigning address
514     function setAuthorized(address _authorizedAddress, uint256 _cosigner) external onlyInvoked {
515         // TODO: Allowing a signer to remove itself is actually pretty terrible; it could result in the user
516         //  removing their only available authorized key. Unfortunately, due to how the invocation forwarding
517         //  works, we don't actually _know_ which signer was used to call this method, so there's no easy way
518         //  to prevent this.
519         
520         // TODO: Allowing the backup key to be set as an authorized address bypasses the recovery mechanisms.
521         //  Dapper can prevent this with offchain logic and the cosigner, but it would be nice to have 
522         //  this enforced by the smart contract logic itself.
523         
524         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
525         require(_authorizedAddress != recoveryAddress, "Do not use the recovery address as an authorized address.");
526         require(address(_cosigner) == address(0) || address(_cosigner) != recoveryAddress, "Do not use the recovery address as a cosigner.");
527  
528         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
529         emit Authorized(_authorizedAddress, _cosigner);
530     }
531     
532     /// @notice Performs an emergency recovery operation, removing all existing authorizations and setting
533     ///  a sole new authorized address with optional cosigner. THIS IS A SCORCHED EARTH SOLUTION, and great
534     ///  care should be taken to ensure that this method is never called unless it is a last resort. See the
535     ///  comments above about the proper kinds of addresses to use as the recoveryAddress to ensure this method
536     ///  is not trivially abused.
537     /// @param _authorizedAddress the new and sole authorized address
538     /// @param _cosigner the corresponding cosigner address, can be equal to _authorizedAddress
539     function emergencyRecovery(address _authorizedAddress, uint256 _cosigner) external onlyRecoveryAddress {
540         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
541         require(_authorizedAddress != recoveryAddress, "Do not use the recovery address as an authorized address.");
542         require(address(_cosigner) != address(0), "The cosigner must not be zero.");
543 
544         // Incrementing the authVersion number effectively erases the authorizations mapping. See the comments
545         // on the authorizations variable (above) for more information.
546         authVersion += AUTH_VERSION_INCREMENTOR;
547 
548         // Store the new signer/cosigner pair as the only remaining authorized address
549         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
550         emit EmergencyRecovery(_authorizedAddress, _cosigner);
551     }
552 
553     /// @notice Sets the recovery address, which can be zero (indicating that no recovery is possible)
554     ///  Can be updated by any authorized address. This address should be set with GREAT CARE. See the
555     ///  comments above about the proper kinds of addresses to use as the recoveryAddress to ensure this
556     ///  mechanism is not trivially abused.
557     /// @dev Must be called through `invoke()`
558     /// @param _recoveryAddress the new recovery address
559     function setRecoveryAddress(address _recoveryAddress) external onlyInvoked {
560         require(
561             address(authorizations[authVersion + uint256(_recoveryAddress)]) == address(0),
562             "Do not use an authorized address as the recovery address."
563         );
564  
565         address previous = recoveryAddress;
566         recoveryAddress = _recoveryAddress;
567 
568         emit RecoveryAddressChanged(previous, recoveryAddress);
569     }
570 
571     /// @notice Allows ANY caller to recover gas by way of deleting old authorization keys after
572     ///  a recovery operation. Anyone can call this method to delete the old unused storage and
573     ///  get themselves a bit of gas refund in the bargin.
574     /// @dev keys must be known to caller or else nothing is refunded
575     /// @param _version the version of the mapping which you want to delete (unshifted)
576     /// @param _keys the authorization keys to delete 
577     function recoverGas(uint256 _version, address[] calldata _keys) external {
578         // TODO: should this be 0xffffffffffffffffffffffff ?
579         require(_version > 0 && _version < 0xffffffff, "Invalid version number.");
580         
581         uint256 shiftedVersion = _version << 160;
582 
583         require(shiftedVersion < authVersion, "You can only recover gas from expired authVersions.");
584 
585         for (uint256 i = 0; i < _keys.length; ++i) {
586             delete(authorizations[shiftedVersion + uint256(_keys[i])]);
587         }
588     }
589 
590     /// @notice Should return whether the signature provided is valid for the provided data
591     ///  See https://github.com/ethereum/EIPs/issues/1271
592     /// @dev This function meets the following conditions as per the EIP:
593     ///  MUST return the bytes4 magic value `0x1626ba7e` when function passes.
594     ///  MUST NOT modify state (using `STATICCALL` for solc < 0.5, `view` modifier for solc > 0.5)
595     ///  MUST allow external calls
596     /// @param hash A 32 byte hash of the signed data.  The actual hash that is hashed however is the
597     ///  the following tightly packed arguments: `0x19,0x0,wallet_address,hash`
598     /// @param _signature Signature byte array associated with `_data`
599     /// @return Magic value `0x1626ba7e` upon success, 0 otherwise.
600     function isValidSignature(bytes32 hash, bytes calldata _signature) external view returns (bytes4) {
601         
602         // We 'hash the hash' for the following reasons:
603         // 1. `hash` is not the hash of an Ethereum transaction
604         // 2. signature must target this wallet to avoid replaying the signature for another wallet
605         // with the same key
606         // 3. Gnosis does something similar: 
607         // https://github.com/gnosis/safe-contracts/blob/102e632d051650b7c4b0a822123f449beaf95aed/contracts/GnosisSafe.sol
608         bytes32 operationHash = keccak256(
609             abi.encodePacked(
610             EIP191_PREFIX,
611             EIP191_VERSION_DATA,
612             this,
613             hash));
614 
615         bytes32[2] memory r;
616         bytes32[2] memory s;
617         uint8[2] memory v;
618         address signer;
619         address cosigner;
620 
621         // extract 1 or 2 signatures depending on length
622         if (_signature.length == 65) {
623             (r[0], s[0], v[0]) = _signature.extractSignature(0);
624             signer = ecrecover(operationHash, v[0], r[0], s[0]);
625             cosigner = signer;
626         } else if (_signature.length == 130) {
627             (r[0], s[0], v[0]) = _signature.extractSignature(0);
628             (r[1], s[1], v[1]) = _signature.extractSignature(65);
629             signer = ecrecover(operationHash, v[0], r[0], s[0]);
630             cosigner = ecrecover(operationHash, v[1], r[1], s[1]);
631         } else {
632             return 0;
633         }
634             
635         // check for valid signature
636         if (signer == address(0)) {
637             return 0;
638         }
639 
640         // check for valid signature
641         if (cosigner == address(0)) {
642             return 0;
643         }
644 
645         // check to see if this is an authorized key
646         if (address(authorizations[authVersion + uint256(signer)]) != cosigner) {
647             return 0;
648         }
649 
650         return ERC1271_VALIDSIGNATURE;
651     }
652 
653     /// @notice Query if this contract implements an interface. This function takes into account
654     ///  interfaces we implement dynamically through delegates. For interfaces that are just a
655     ///  single method, using `setDelegate` will result in that method's ID returning true from 
656     ///  `supportsInterface`. For composite interfaces that are composed of multiple functions, it is
657     ///  necessary to add the interface ID manually with `setDelegate(interfaceID,
658     ///  COMPOSITE_PLACEHOLDER)`
659     ///  IN ADDITION to adding each function of the interface as usual.
660     /// @param interfaceID The interface identifier, as specified in ERC-165
661     /// @dev Interface identification is specified in ERC-165. This function
662     ///  uses less than 30,000 gas.
663     /// @return `true` if the contract implements `interfaceID` and
664     ///  `interfaceID` is not 0xffffffff, `false` otherwise
665     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
666         // First check if the ID matches one of the interfaces we support statically.
667         if (
668             interfaceID == this.supportsInterface.selector || // ERC165
669             interfaceID == ERC721_RECEIVED_FINAL || // ERC721 Final
670             interfaceID == ERC721_RECEIVED_DRAFT || // ERC721 Draft
671             interfaceID == ERC223_ID || // ERC223
672             interfaceID == ERC1271_VALIDSIGNATURE // ERC1271
673         ) {
674             return true;
675         }
676         // If we don't support the interface statically, check whether we have added
677         // dynamic support for it.
678         return uint256(delegates[interfaceID]) > 0;
679     }
680 
681     /// @notice A version of `invoke()` that has no explicit signatures, and uses msg.sender
682     ///  as both the signer and cosigner. Will only succeed if `msg.sender` is an authorized
683     ///  signer for this wallet, with no cosigner, saving transaction size and gas in that case.
684     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
685     function invoke0(bytes calldata data) external {
686         // The nonce doesn't need to be incremented for transactions that don't include explicit signatures;
687         // the built-in nonce of the native ethereum transaction will protect against replay attacks, and we
688         // can save the gas that would be spent updating the nonce variable
689 
690         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner)
691         require(address(authorizations[authVersion + uint256(msg.sender)]) == msg.sender, "Invalid authorization.");
692 
693         internalInvoke(0, data);
694     }
695 
696     /// @notice A version of `invoke()` that has one explicit signature which is used to derive the authorized
697     ///  address. Uses `msg.sender` as the cosigner.
698     /// @param v the v value for the signature; see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
699     /// @param r the r value for the signature
700     /// @param s the s value for the signature
701     /// @param nonce the nonce value for the signature
702     /// @param authorizedAddress the address of the authorization key; this is used here so that cosigner signatures are interchangeable
703     ///  between this function and `invoke2()`
704     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
705     function invoke1CosignerSends(uint8 v, bytes32 r, bytes32 s, uint256 nonce, address authorizedAddress, bytes calldata data) external {
706         // check signature version
707         require(v == 27 || v == 28, "Invalid signature version.");
708 
709         // calculate hash
710         bytes32 operationHash = keccak256(
711             abi.encodePacked(
712             EIP191_PREFIX,
713             EIP191_VERSION_DATA,
714             this,
715             nonce,
716             authorizedAddress,
717             data));
718  
719         // recover signer
720         address signer = ecrecover(operationHash, v, r, s);
721 
722         // check for valid signature
723         require(signer != address(0), "Invalid signature.");
724 
725         // check nonce
726         require(nonce == nonces[signer], "must use correct nonce");
727 
728         // check signer
729         require(signer == authorizedAddress, "authorized addresses must be equal");
730 
731         // Get cosigner
732         address requiredCosigner = address(authorizations[authVersion + uint256(signer)]);
733         
734         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
735         // if the actual cosigner matches the required cosigner.
736         require(requiredCosigner == signer || requiredCosigner == msg.sender, "Invalid authorization.");
737 
738         // increment nonce to prevent replay attacks
739         nonces[signer] = nonce + 1;
740 
741         // call internal function
742         internalInvoke(operationHash, data);
743     }
744 
745     /// @notice A version of `invoke()` that has one explicit signature which is used to derive the cosigning
746     ///  address. Uses `msg.sender` as the authorized address.
747     /// @param v the v value for the signature; see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
748     /// @param r the r value for the signature
749     /// @param s the s value for the signature
750     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
751     function invoke1SignerSends(uint8 v, bytes32 r, bytes32 s, bytes calldata data) external {
752         // check signature version
753         // `ecrecover` will in fact return 0 if given invalid
754         // so perhaps this check is redundant
755         require(v == 27 || v == 28, "Invalid signature version.");
756         
757         uint256 nonce = nonces[msg.sender];
758 
759         // calculate hash
760         bytes32 operationHash = keccak256(
761             abi.encodePacked(
762             EIP191_PREFIX,
763             EIP191_VERSION_DATA,
764             this,
765             nonce,
766             msg.sender,
767             data));
768  
769         // recover cosigner
770         address cosigner = ecrecover(operationHash, v, r, s);
771         
772         // check for valid signature
773         require(cosigner != address(0), "Invalid signature.");
774 
775         // Get required cosigner
776         address requiredCosigner = address(authorizations[authVersion + uint256(msg.sender)]);
777         
778         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
779         // if the actual cosigner matches the required cosigner.
780         require(requiredCosigner == cosigner || requiredCosigner == msg.sender, "Invalid authorization.");
781 
782         // increment nonce to prevent replay attacks
783         nonces[msg.sender] = nonce + 1;
784  
785         internalInvoke(operationHash, data);
786     }
787 
788     /// @notice A version of `invoke()` that has two explicit signatures, the first is used to derive the authorized
789     ///  address, the second to derive the cosigner. The value of `msg.sender` is ignored.
790     /// @param v the v values for the signatures
791     /// @param r the r values for the signatures
792     /// @param s the s values for the signatures
793     /// @param nonce the nonce value for the signature
794     /// @param authorizedAddress the address of the signer; forces the signature to be unique and tied to the signers nonce 
795     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
796     function invoke2(uint8[2] calldata v, bytes32[2] calldata r, bytes32[2] calldata s, uint256 nonce, address authorizedAddress, bytes calldata data) external {
797         // check signature versions
798         // `ecrecover` will infact return 0 if given invalid
799         // so perhaps these checks are redundant
800         require(v[0] == 27 || v[0] == 28, "invalid signature version v[0]");
801         require(v[1] == 27 || v[1] == 28, "invalid signature version v[1]");
802  
803         bytes32 operationHash = keccak256(
804             abi.encodePacked(
805             EIP191_PREFIX,
806             EIP191_VERSION_DATA,
807             this,
808             nonce,
809             authorizedAddress,
810             data));
811  
812         // recover signer and cosigner
813         address signer = ecrecover(operationHash, v[0], r[0], s[0]);
814         address cosigner = ecrecover(operationHash, v[1], r[1], s[1]);
815 
816         // check for valid signatures
817         require(signer != address(0), "Invalid signature for signer.");
818         require(cosigner != address(0), "Invalid signature for cosigner.");
819 
820         // check signer address
821         require(signer == authorizedAddress, "authorized addresses must be equal");
822 
823         // check nonces
824         require(nonce == nonces[signer], "must use correct nonce for signer");
825 
826         // Get Mapping
827         address requiredCosigner = address(authorizations[authVersion + uint256(signer)]);
828         
829         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
830         // if the actual cosigner matches the required cosigner.
831         require(requiredCosigner == signer || requiredCosigner == cosigner, "Invalid authorization.");
832 
833         // increment nonce to prevent replay attacks
834         nonces[signer]++;
835 
836         internalInvoke(operationHash, data);
837     }
838 
839     /// @dev Internal invoke call, 
840     /// @param operationHash The hash of the operation
841     /// @param data The data to send to the `call()` operation
842     ///  The data is prefixed with a global 1 byte revert flag
843     ///  If revert is 1, then any revert from a `call()` operation is rethrown.
844     ///  Otherwise, the error is recorded in the `result` field of the `InvocationSuccess` event.
845     ///  Immediately following the revert byte (no padding), the data format is then is a series
846     ///  of 1 or more tightly packed tuples:
847     ///  `<target(20),amount(32),datalength(32),data>`
848     ///  If `datalength == 0`, the data field must be omitted
849     function internalInvoke(bytes32 operationHash, bytes memory data) internal {
850         // keep track of the number of operations processed
851         uint256 numOps;
852         // keep track of the result of each operation as a bit
853         uint256 result;
854 
855         // We need to store a reference to this string as a variable so we can use it as an argument to
856         // the revert call from assembly.
857         string memory invalidLengthMessage = "Data field too short";
858         string memory callFailed = "Call failed";
859 
860         // At an absolute minimum, the data field must be at least 85 bytes
861         // <revert(1), to_address(20), value(32), data_length(32)>
862         require(data.length >= 85, invalidLengthMessage);
863 
864         // Forward the call onto its actual target. Note that the target address can be `self` here, which is
865         // actually the required flow for modifying the configuration of the authorized keys and recovery address.
866         //
867         // The assembly code below loads data directly from memory, so the enclosing function must be marked `internal`
868         assembly {
869             // A cursor pointing to the revert flag, starts after the length field of the data object
870             let memPtr := add(data, 32)
871 
872             // The revert flag is the leftmost byte from memPtr
873             let revertFlag := byte(0, mload(memPtr))
874 
875             // A pointer to the end of the data object
876             let endPtr := add(memPtr, mload(data))
877 
878             // Now, memPtr is a cursor pointing to the beginning of the current sub-operation
879             memPtr := add(memPtr, 1)
880 
881             // Loop through data, parsing out the various sub-operations
882             for { } lt(memPtr, endPtr) { } {
883                 // Load the length of the call data of the current operation
884                 // 52 = to(20) + value(32)
885                 let len := mload(add(memPtr, 52))
886                 
887                 // Compute a pointer to the end of the current operation
888                 // 84 = to(20) + value(32) + size(32)
889                 let opEnd := add(len, add(memPtr, 84))
890 
891                 // Bail if the current operation's data overruns the end of the enclosing data buffer
892                 // NOTE: Comment out this bit of code and uncomment the next section if you want
893                 // the solidity-coverage tool to work.
894                 // See https://github.com/sc-forks/solidity-coverage/issues/287
895                 if gt(opEnd, endPtr) {
896                     // The computed end of this operation goes past the end of the data buffer. Not good!
897                     revert(add(invalidLengthMessage, 32), mload(invalidLengthMessage))
898                 }
899                 // NOTE: Code that is compatible with solidity-coverage
900                 // switch gt(opEnd, endPtr)
901                 // case 1 {
902                 //     revert(add(invalidLengthMessage, 32), mload(invalidLengthMessage))
903                 // }
904 
905                 // This line of code packs in a lot of functionality!
906                 //  - load the target address from memPtr, the address is only 20-bytes but mload always grabs 32-bytes,
907                 //    so we have to shr by 12 bytes.
908                 //  - load the value field, stored at memPtr+20
909                 //  - pass a pointer to the call data, stored at memPtr+84
910                 //  - use the previously loaded len field as the size of the call data
911                 //  - make the call (passing all remaining gas to the child call)
912                 //  - check the result (0 == reverted)
913                 if eq(0, call(gas, shr(96, mload(memPtr)), mload(add(memPtr, 20)), add(memPtr, 84), len, 0, 0)) {
914                     switch revertFlag
915                     case 1 {
916                         revert(add(callFailed, 32), mload(callFailed))
917                     }
918                     default {
919                         // mark this operation as failed
920                         // create the appropriate bit, 'or' with previous
921                         result := or(result, exp(2, numOps))
922                     }
923                 }
924 
925                 // increment our counter
926                 numOps := add(numOps, 1)
927              
928                 // Update mem pointer to point to the next sub-operation
929                 memPtr := opEnd
930             }
931         }
932 
933         // emit single event upon success
934         emit InvocationSuccess(operationHash, result, numOps);
935     }
936 }
937 
938 // File: contracts/Wallet/CloneableWallet.sol
939 
940 pragma solidity ^0.5.10;
941 
942 
943 
944 /// @title Cloneable Wallet
945 /// @notice This contract represents a complete but non working wallet.  
946 ///  It is meant to be deployed and serve as the contract that you clone
947 ///  in an EIP 1167 clone setup.
948 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
949 /// @dev Currently, we are seeing approximatley 933 gas overhead for using
950 ///  the clone wallet; use `FullWallet` if you think users will overtake
951 ///  the transaction threshold over the lifetime of the wallet.
952 contract CloneableWallet is CoreWallet {
953 
954     /// @dev An empty constructor that deploys a NON-FUNCTIONAL version
955     ///  of `CoreWallet`
956     constructor () public {
957         initialized = true;
958     }
959 }
960 
961 // File: contracts/Ownership/Ownable.sol
962 
963 pragma solidity ^0.5.10;
964 
965 
966 /// @title Ownable is for contracts that can be owned.
967 /// @dev The Ownable contract keeps track of an owner address,
968 ///  and provides basic authorization functions.
969 contract Ownable {
970 
971     /// @dev the owner of the contract
972     address public owner;
973 
974     /// @dev Fired when the owner to renounce ownership, leaving no one
975     ///  as the owner.
976     /// @param previousOwner The previous `owner` of this contract
977     event OwnershipRenounced(address indexed previousOwner);
978     
979     /// @dev Fired when the owner to changes ownership
980     /// @param previousOwner The previous `owner`
981     /// @param newOwner The new `owner`
982     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
983 
984     /// @dev sets the `owner` to `msg.sender`
985     constructor() public {
986         owner = msg.sender;
987     }
988 
989     /// @dev Throws if the `msg.sender` is not the current `owner`
990     modifier onlyOwner() {
991         require(msg.sender == owner, "must be owner");
992         _;
993     }
994 
995     /// @dev Allows the current `owner` to renounce ownership
996     function renounceOwnership() external onlyOwner {
997         emit OwnershipRenounced(owner);
998         owner = address(0);
999     }
1000 
1001     /// @dev Allows the current `owner` to transfer ownership
1002     /// @param _newOwner The new `owner`
1003     function transferOwnership(address _newOwner) external onlyOwner {
1004         _transferOwnership(_newOwner);
1005     }
1006 
1007     /// @dev Internal version of `transferOwnership`
1008     /// @param _newOwner The new `owner`
1009     function _transferOwnership(address _newOwner) internal {
1010         require(_newOwner != address(0), "cannot renounce ownership");
1011         emit OwnershipTransferred(owner, _newOwner);
1012         owner = _newOwner;
1013     }
1014 }
1015 
1016 // File: contracts/Ownership/HasNoEther.sol
1017 
1018 pragma solidity ^0.5.10;
1019 
1020 
1021 
1022 /// @title HasNoEther is for contracts that should not own Ether
1023 contract HasNoEther is Ownable {
1024 
1025     /// @dev This contructor rejects incoming Ether
1026     constructor() public payable {
1027         require(msg.value == 0, "must not send Ether");
1028     }
1029 
1030     /// @dev Disallows direct send by default function not being `payable`
1031     function() external {}
1032 
1033     /// @dev Transfers all Ether held by this contract to the owner.
1034     function reclaimEther() external onlyOwner {
1035         msg.sender.transfer(address(this).balance); 
1036     }
1037 }
1038 
1039 // File: contracts/WalletFactory/CloneFactory.sol
1040 
1041 pragma solidity ^0.5.10;
1042 
1043 
1044 /// @title CloneFactory - a contract that creates clones
1045 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
1046 /// @dev See https://github.com/optionality/clone-factory/blob/master/contracts/CloneFactory.sol
1047 contract CloneFactory {
1048     event CloneCreated(address indexed target, address clone);
1049 
1050     function createClone(address target) internal returns (address payable result) {
1051         bytes20 targetBytes = bytes20(target);
1052         assembly {
1053             let clone := mload(0x40)
1054             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1055             mstore(add(clone, 0x14), targetBytes)
1056             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1057             result := create(0, clone, 0x37)
1058         }
1059     }
1060 
1061     function createClone2(address target, bytes32 salt) internal returns (address payable result) {
1062         bytes20 targetBytes = bytes20(target);
1063         assembly {
1064             let clone := mload(0x40)
1065             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1066             mstore(add(clone, 0x14), targetBytes)
1067             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1068             result := create2(0, clone, 0x37, salt)
1069         }
1070     }
1071 }
1072 
1073 // File: contracts/WalletFactory/FullWalletByteCode.sol
1074 
1075 pragma solidity ^0.5.10;
1076 
1077 /// @title FullWalletByteCode
1078 /// @dev A contract containing the FullWallet bytecode, for use in deployment.
1079 contract FullWalletByteCode {
1080     /// @notice This is the raw bytecode of the full wallet. It is encoded here as a raw byte
1081     ///  array to support deployment with CREATE2, as Solidity's 'new' constructor system does
1082     ///  not support CREATE2 yet.
1083     ///
1084     ///  NOTE: Be sure to update this whenever the wallet bytecode changes!
1085     ///  Simply run `npm run build` and then copy the `"bytecode"`
1086     ///  portion from the `build/contracts/FullWallet.json` file to here,
1087     ///  then append 64x3 0's.
1088     bytes constant fullWalletBytecode = hex'60806040523480156200001157600080fd5b5060405162002b5b38038062002b5b833981810160405260608110156200003757600080fd5b50805160208201516040909201519091906200005e8383836001600160e01b036200006716565b5050506200033b565b60045474010000000000000000000000000000000000000000900460ff1615620000f257604080517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601f60248201527f6d757374206e6f7420616c726561647920626520696e697469616c697a656400604482015290519081900360640190fd5b6004805460ff60a01b1916740100000000000000000000000000000000000000001790556001600160a01b0383811690821614156200017d576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252603981526020018062002af46039913960400191505060405180910390fd5b806001600160a01b0316826001600160a01b03161415620001ea576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252602e81526020018062002b2d602e913960400191505060405180910390fd5b6001600160a01b0383166200024b576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252602681526020018062002aac6026913960400191505060405180910390fd5b6001600160a01b038216620002ac576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252602281526020018062002ad26022913960400191505060405180910390fd5b600480546001600160a01b0319166001600160a01b03838116919091179091557401000000000000000000000000000000000000000060008181559185169081018252600160209081526040928390208590558251918252810184905281517fb39b5f240c7440b58c1c6cfd328b09ff9aa18b3c8ef4b829774e4f5bad039416929181900390910190a1505050565b612761806200034b6000396000f3fe60806040526004361061019c5760003560e01c806375857eba116100ec578063a3c89c4f1161008a578063ce2d4f9611610064578063ce2d4f96146109e1578063ef009e42146109f6578063f0b9e5ba14610a78578063ffa1ad7414610b085761019c565b8063a3c89c4f14610867578063bf4fb0c0146108e2578063c0ee0b8a1461091b5761019c565b80638bf78874116100c65780638bf78874146107635780639105d9c41461077857806391aeeedc1461078d578063a0a2daf0146108335761019c565b806375857eba146106d85780637ecebe00146106ed57806388fb06e7146107205761019c565b8063210d66f81161015957806349efe5ae1161013357806349efe5ae146105aa57806357e61e29146105dd578063710eb26c1461066e578063727b7acf1461069f5761019c565b8063210d66f81461048b5780632698c20c146104c757806343fc00b8146105675761019c565b806301ffc9a71461027757806308405166146102bf578063150b7a02146102f1578063158ef93e146103c25780631626ba7e146103d75780631cd61bad14610459575b34156101dd576040805133815234602082015281517f88a5966d370b9919b20f3e2c13ff65706f196a4e32cc2c12bf57088f88525874929181900390910190a15b361561027557600080356001600160e01b0319168152600360205260409020546001600160a01b031660018111610251576040805162461bcd60e51b815260206004820152601360248201527224b73b30b634b2103a3930b739b0b1ba34b7b760691b604482015290519081900360640190fd5b3660008037600080366000845afa3d6000803e808015610270573d6000f35b3d6000fd5b005b34801561028357600080fd5b506102ab6004803603602081101561029a57600080fd5b50356001600160e01b031916610b92565b604080519115158252519081900360200190f35b3480156102cb57600080fd5b506102d4610c4d565b604080516001600160e01b03199092168252519081900360200190f35b3480156102fd57600080fd5b506102d46004803603608081101561031457600080fd5b6001600160a01b03823581169260208101359091169160408201359190810190608081016060820135600160201b81111561034e57600080fd5b82018360208201111561036057600080fd5b803590602001918460018302840111600160201b8311171561038157600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550610c58945050505050565b3480156103ce57600080fd5b506102ab610c68565b3480156103e357600080fd5b506102d4600480360360408110156103fa57600080fd5b81359190810190604081016020820135600160201b81111561041b57600080fd5b82018360208201111561042d57600080fd5b803590602001918460018302840111600160201b8311171561044e57600080fd5b509092509050610c78565b34801561046557600080fd5b5061046e610fe5565b604080516001600160f81b03199092168252519081900360200190f35b34801561049757600080fd5b506104b5600480360360208110156104ae57600080fd5b5035610fea565b60408051918252519081900360200190f35b3480156104d357600080fd5b5061027560048036036101208110156104eb57600080fd5b6040820190608083019060c0840135906001600160a01b0360e086013516908501856101208101610100820135600160201b81111561052957600080fd5b82018360208201111561053b57600080fd5b803590602001918460018302840111600160201b8311171561055c57600080fd5b509092509050610ffc565b34801561057357600080fd5b506102756004803603606081101561058a57600080fd5b506001600160a01b03813581169160208101359160409091013516611499565b3480156105b657600080fd5b50610275600480360360208110156105cd57600080fd5b50356001600160a01b03166116af565b3480156105e957600080fd5b506102756004803603608081101561060057600080fd5b60ff8235169160208101359160408201359190810190608081016060820135600160201b81111561063057600080fd5b82018360208201111561064257600080fd5b803590602001918460018302840111600160201b8311171561066357600080fd5b5090925090506117c1565b34801561067a57600080fd5b50610683611a3e565b604080516001600160a01b039092168252519081900360200190f35b3480156106ab57600080fd5b50610275600480360360408110156106c257600080fd5b506001600160a01b038135169060200135611a4d565b3480156106e457600080fd5b506104b5611c02565b3480156106f957600080fd5b506104b56004803603602081101561071057600080fd5b50356001600160a01b0316611c0a565b34801561072c57600080fd5b506102756004803603604081101561074357600080fd5b5080356001600160e01b03191690602001356001600160a01b0316611c1c565b34801561076f57600080fd5b506104b5611ce2565b34801561078457600080fd5b50610683611ce8565b34801561079957600080fd5b50610275600480360360c08110156107b057600080fd5b60ff823516916020810135916040820135916060810135916001600160a01b03608083013516919081019060c0810160a0820135600160201b8111156107f557600080fd5b82018360208201111561080757600080fd5b803590602001918460018302840111600160201b8311171561082857600080fd5b509092509050611ced565b34801561083f57600080fd5b506106836004803603602081101561085657600080fd5b50356001600160e01b03191661202c565b34801561087357600080fd5b506102756004803603602081101561088a57600080fd5b810190602081018135600160201b8111156108a457600080fd5b8201836020820111156108b657600080fd5b803590602001918460018302840111600160201b831117156108d757600080fd5b509092509050612047565b3480156108ee57600080fd5b506102756004803603604081101561090557600080fd5b506001600160a01b0381351690602001356120f7565b34801561092757600080fd5b506102756004803603606081101561093e57600080fd5b6001600160a01b0382351691602081013591810190606081016040820135600160201b81111561096d57600080fd5b82018360208201111561097f57600080fd5b803590602001918460018302840111600160201b831117156109a057600080fd5b91908080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525092955061229a945050505050565b3480156109ed57600080fd5b5061046e61229f565b348015610a0257600080fd5b5061027560048036036040811015610a1957600080fd5b81359190810190604081016020820135600160201b811115610a3a57600080fd5b820183602082011115610a4c57600080fd5b803590602001918460208302840111600160201b83111715610a6d57600080fd5b5090925090506122a7565b348015610a8457600080fd5b506102d460048036036060811015610a9b57600080fd5b6001600160a01b0382351691602081013591810190606081016040820135600160201b811115610aca57600080fd5b820183602082011115610adc57600080fd5b803590602001918460018302840111600160201b83111715610afd57600080fd5b5090925090506123ab565b348015610b1457600080fd5b50610b1d6123bb565b6040805160208082528351818301528351919283929083019185019080838360005b83811015610b57578181015183820152602001610b3f565b50505050905090810190601f168015610b845780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60006001600160e01b031982166301ffc9a760e01b1480610bc357506001600160e01b03198216630a85bd0160e11b145b80610bde57506001600160e01b0319821663785cf2dd60e11b145b80610bf957506001600160e01b0319821663607705c560e11b145b80610c1457506001600160e01b03198216630b135d3f60e11b145b15610c2157506001610c48565b506001600160e01b031981166000908152600360205260409020546001600160a01b031615155b919050565b63607705c560e11b81565b630a85bd0160e11b949350505050565b600454600160a01b900460ff1681565b60408051601960f81b6020808301919091526000602183018190523060601b602284015260368084018890528451808503909101815260569093019093528151910120610cc36125b0565b610ccb6125b0565b610cd36125b0565b6000806041881415610da457610d2960008a8a8080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929392505063ffffffff6123dc169050565b60ff908116865290865281875284518651604080516000815260208181018084528d9052939094168482015260608401949094526080830152915160019260a0808401939192601f1981019281900390910190855afa158015610d90573d6000803e3d6000fd5b505050602060405103519150819050610f48565b6082881415610f3857610df760008a8a8080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929392505063ffffffff6123dc169050565b60ff16855285528552604080516020601f8b01819004810282018101909252898152610e4a91604191908c908c9081908401838280828437600092019190915250929392505063ffffffff6123dc169050565b60ff908116602087810191909152878101929092528188019290925284518751875160408051600081528086018083528d9052939095168386015260608301919091526080820152915160019260a08082019392601f1981019281900390910190855afa158015610ebf573d6000803e3d6000fd5b505060408051601f19808201516020808901518b8201518b830151600087528387018089528f905260ff909216868801526060860152608085015293519096506001945060a08084019493928201928290030190855afa158015610f27573d6000803e3d6000fd5b505050602060405103519050610f48565b5060009550610fde945050505050565b6001600160a01b038216610f66575060009550610fde945050505050565b6001600160a01b038116610f84575060009550610fde945050505050565b806001600160a01b031660016000846001600160a01b0316600054018152602001908152602001600020546001600160a01b031614610fcd575060009550610fde945050505050565b50630b135d3f60e11b955050505050505b9392505050565b600081565b60016020526000908152604090205481565b601b60ff88351614806110135750601c60ff883516145b611064576040805162461bcd60e51b815260206004820152601e60248201527f696e76616c6964207369676e61747572652076657273696f6e20765b305d0000604482015290519081900360640190fd5b601b60ff60208901351614806110815750601c60ff602089013516145b6110d2576040805162461bcd60e51b815260206004820152601e60248201527f696e76616c6964207369676e61747572652076657273696f6e20765b315d0000604482015290519081900360640190fd5b604051601960f81b6020820181815260006021840181905230606081811b6022870152603686018a905288901b6bffffffffffffffffffffffff1916605686015290938492899189918991899190606a018383808284378083019250505097505050505050505060405160208183030381529060405280519060200120905060006001828a60006002811061116357fe5b602002013560ff168a60006002811061117857fe5b604080516000815260208181018084529690965260ff90941684820152908402919091013560608301528a3560808301525160a08083019392601f198301929081900390910190855afa1580156111d3573d6000803e3d6000fd5b505060408051601f1980820151600080845260208085018087528990528f81013560ff16858701528e81013560608601528d81013560808601529451919650945060019360a0808501949193830192918290030190855afa15801561123c573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b0382166112a4576040805162461bcd60e51b815260206004820152601d60248201527f496e76616c6964207369676e617475726520666f72207369676e65722e000000604482015290519081900360640190fd5b6001600160a01b0381166112ff576040805162461bcd60e51b815260206004820152601f60248201527f496e76616c6964207369676e617475726520666f7220636f7369676e65722e00604482015290519081900360640190fd5b856001600160a01b0316826001600160a01b03161461134f5760405162461bcd60e51b815260040180806020018281038252602281526020018061270b6022913960400191505060405180910390fd5b6001600160a01b03821660009081526002602052604090205487146113a55760405162461bcd60e51b81526004018080602001828103825260218152602001806126bc6021913960400191505060405180910390fd5b600080546001600160a01b038085169182018352600160205260409092205491821614806113e45750816001600160a01b0316816001600160a01b0316145b61142e576040805162461bcd60e51b815260206004820152601660248201527524b73b30b634b21030baba3437b934bd30ba34b7b71760511b604482015290519081900360640190fd5b6001600160a01b038316600090815260026020908152604091829020805460010190558151601f880182900482028101820190925286825261148c91869189908990819084018382808284376000920191909152506123f892505050565b5050505050505050505050565b600454600160a01b900460ff16156114f8576040805162461bcd60e51b815260206004820152601f60248201527f6d757374206e6f7420616c726561647920626520696e697469616c697a656400604482015290519081900360640190fd5b6004805460ff60a01b1916600160a01b1790556001600160a01b0383811690821614156115565760405162461bcd60e51b81526004018080602001828103825260398152602001806126836039913960400191505060405180910390fd5b806001600160a01b0316826001600160a01b031614156115a75760405162461bcd60e51b815260040180806020018281038252602e8152602001806126dd602e913960400191505060405180910390fd5b6001600160a01b0383166115ec5760405162461bcd60e51b815260040180806020018281038252602681526020018061263b6026913960400191505060405180910390fd5b6001600160a01b0382166116315760405162461bcd60e51b81526004018080602001828103825260228152602001806126616022913960400191505060405180910390fd5b600480546001600160a01b0319166001600160a01b0383811691909117909155600160a01b60008181559185169081018252600160209081526040928390208590558251918252810184905281517fb39b5f240c7440b58c1c6cfd328b09ff9aa18b3c8ef4b829774e4f5bad039416929181900390910190a1505050565b333014611703576040805162461bcd60e51b815260206004820152601e60248201527f6d7573742062652063616c6c65642066726f6d2060696e766f6b652829600000604482015290519081900360640190fd5b600080546001600160a01b0383811690910182526001602052604090912054161561175f5760405162461bcd60e51b81526004018080602001828103825260398152602001806125cf6039913960400191505060405180910390fd5b600480546001600160a01b038381166001600160a01b0319831617928390556040805192821680845293909116602083015280517f568ab3dedd6121f0385e007e641e74e1f49d0fa69cab2957b0b07c4c7de5abb69281900390910190a15050565b8460ff16601b14806117d657508460ff16601c145b611827576040805162461bcd60e51b815260206004820152601a60248201527f496e76616c6964207369676e61747572652076657273696f6e2e000000000000604482015290519081900360640190fd5b336000818152600260209081526040808320549051601960f81b9281018381526021820185905230606081811b60228501526036840185905287901b6056840152929585939287928a918a9190606a0183838082843780830192505050975050505050505050604051602081830303815290604052805190602001209050600060018289898960405160008152602001604052604051808581526020018460ff1660ff1681526020018381526020018281526020019450505050506020604051602081039080840390855afa158015611904573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b038116611961576040805162461bcd60e51b815260206004820152601260248201527124b73b30b634b21039b4b3b730ba3ab9329760711b604482015290519081900360640190fd5b6000805433018152600160205260409020546001600160a01b03818116908316148061199557506001600160a01b03811633145b6119df576040805162461bcd60e51b815260206004820152601660248201527524b73b30b634b21030baba3437b934bd30ba34b7b71760511b604482015290519081900360640190fd5b336000908152600260209081526040918290206001870190558151601f8801829004820281018201909252868252611a3391859189908990819084018382808284376000920191909152506123f892505050565b505050505050505050565b6004546001600160a01b031681565b6004546001600160a01b03163314611aac576040805162461bcd60e51b815260206004820152601f60248201527f73656e646572206d757374206265207265636f76657279206164647265737300604482015290519081900360640190fd5b6001600160a01b038216611af15760405162461bcd60e51b815260040180806020018281038252602681526020018061263b6026913960400191505060405180910390fd5b6004546001600160a01b0383811691161415611b3e5760405162461bcd60e51b81526004018080602001828103825260398152602001806126836039913960400191505060405180910390fd5b6001600160a01b038116611b99576040805162461bcd60e51b815260206004820152601e60248201527f54686520636f7369676e6572206d757374206e6f74206265207a65726f2e0000604482015290519081900360640190fd5b60008054600160a01b81810183556001600160a01b038516918201018252600160209081526040928390208490558251918252810183905281517fa9364fb2836862098c2b593d2d3f46759b4c6d5b054300f96172b0394430008a929181900390910190a15050565b600160a01b81565b60026020526000908152604090205481565b333014611c70576040805162461bcd60e51b815260206004820152601e60248201527f6d7573742062652063616c6c65642066726f6d2060696e766f6b652829600000604482015290519081900360640190fd5b6001600160e01b0319821660008181526003602090815260409182902080546001600160a01b0319166001600160a01b03861690811790915582519384529083015280517fd09b01a1a877e1a97b048725e0697d9be07bb94320c536e72b976c81016891fb9281900390910190a15050565b60005481565b600181565b8660ff16601b1480611d0257508660ff16601c145b611d53576040805162461bcd60e51b815260206004820152601a60248201527f496e76616c6964207369676e61747572652076657273696f6e2e000000000000604482015290519081900360640190fd5b604051601960f81b6020820181815260006021840181905230606081811b6022870152603686018a905288901b6bffffffffffffffffffffffff1916605686015290938492899189918991899190606a018383808284378083019250505097505050505050505060405160208183030381529060405280519060200120905060006001828a8a8a60405160008152602001604052604051808581526020018460ff1660ff1681526020018381526020018281526020019450505050506020604051602081039080840390855afa158015611e31573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b038116611e8e576040805162461bcd60e51b815260206004820152601260248201527124b73b30b634b21039b4b3b730ba3ab9329760711b604482015290519081900360640190fd5b6001600160a01b0381166000908152600260205260409020548614611ef3576040805162461bcd60e51b81526020600482015260166024820152756d7573742075736520636f7272656374206e6f6e636560501b604482015290519081900360640190fd5b846001600160a01b0316816001600160a01b031614611f435760405162461bcd60e51b815260040180806020018281038252602281526020018061270b6022913960400191505060405180910390fd5b600080546001600160a01b03808416918201835260016020526040909220549182161480611f7957506001600160a01b03811633145b611fc3576040805162461bcd60e51b815260206004820152601660248201527524b73b30b634b21030baba3437b934bd30ba34b7b71760511b604482015290519081900360640190fd5b6001600160a01b03821660009081526002602090815260409182902060018a0190558151601f870182900482028101820190925285825261202091859188908890819084018382808284376000920191909152506123f892505050565b50505050505050505050565b6003602052600090815260409020546001600160a01b031681565b6000805433908101825260016020526040909120546001600160a01b0316146120b0576040805162461bcd60e51b815260206004820152601660248201527524b73b30b634b21030baba3437b934bd30ba34b7b71760511b604482015290519081900360640190fd5b6120f36000801b83838080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152506123f892505050565b5050565b33301461214b576040805162461bcd60e51b815260206004820152601e60248201527f6d7573742062652063616c6c65642066726f6d2060696e766f6b652829600000604482015290519081900360640190fd5b6001600160a01b0382166121905760405162461bcd60e51b815260040180806020018281038252602681526020018061263b6026913960400191505060405180910390fd5b6004546001600160a01b03838116911614156121dd5760405162461bcd60e51b81526004018080602001828103825260398152602001806126836039913960400191505060405180910390fd5b6001600160a01b038116158061220157506004546001600160a01b03828116911614155b61223c5760405162461bcd60e51b815260040180806020018281038252602e8152602001806126dd602e913960400191505060405180910390fd5b600080546001600160a01b0384169081018252600160209081526040928390208490558251918252810183905281517fb39b5f240c7440b58c1c6cfd328b09ff9aa18b3c8ef4b829774e4f5bad039416929181900390910190a15050565b505050565b601960f81b81565b6000831180156122ba575063ffffffff83105b61230b576040805162461bcd60e51b815260206004820152601760248201527f496e76616c69642076657273696f6e206e756d6265722e000000000000000000604482015290519081900360640190fd5b60005460a084901b9081106123515760405162461bcd60e51b81526004018080602001828103825260338152602001806126086033913960400191505060405180910390fd5b60005b828110156123a4576001600085858481811061236c57fe5b905060200201356001600160a01b03166001600160a01b03168401815260200190815260200160002060009055806001019050612354565b5050505050565b63785cf2dd60e11b949350505050565b604051806040016040528060058152602001640312e312e360dc1b81525081565b0160208101516040820151606090920151909260009190911a90565b60008060606040518060400160405280601481526020017311185d1848199a595b19081d1bdbc81cda1bdc9d60621b815250905060606040518060400160405280600b81526020016a10d85b1b0819985a5b195960aa1b815250905060558551101582906124e45760405162461bcd60e51b81526004018080602001828103825283818151815260200191508051906020019080838360005b838110156124a9578181015183820152602001612491565b50505050905090810190601f1680156124d65780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b5060208501805160001a865182016001830192505b808310156125645760348301516054840181018281111561251c57865160208801fd5b60008083605488016014890151895160601c5af161255457836001811461254a578960020a89179850612552565b865160208801fd5b505b60018901985080945050506124f9565b5050604080518881526020810186905280820187905290517f101214446435ebbb29893f3348e3aae5ea070b63037a3df346d09d3396a34aee92509081900360600190a1505050505050565b6040518060400160405280600290602082028038833950919291505056fe446f206e6f742075736520616e20617574686f72697a6564206164647265737320617320746865207265636f7665727920616464726573732e596f752063616e206f6e6c79207265636f766572206761732066726f6d2065787069726564206175746856657273696f6e732e417574686f72697a656420616464726573736573206d757374206e6f74206265207a65726f2e496e697469616c20636f7369676e6572206d757374206e6f74206265207a65726f2e446f206e6f742075736520746865207265636f76657279206164647265737320617320616e20617574686f72697a656420616464726573732e6d7573742075736520636f7272656374206e6f6e636520666f72207369676e6572446f206e6f742075736520746865207265636f766572792061646472657373206173206120636f7369676e65722e617574686f72697a656420616464726573736573206d75737420626520657175616ca265627a7a7230582064713ad4e8ff9b65f5755c8454c099c8b69d7484774564f312cb43a41147761c64736f6c634300050a0032417574686f72697a656420616464726573736573206d757374206e6f74206265207a65726f2e496e697469616c20636f7369676e6572206d757374206e6f74206265207a65726f2e446f206e6f742075736520746865207265636f76657279206164647265737320617320616e20617574686f72697a656420616464726573732e446f206e6f742075736520746865207265636f766572792061646472657373206173206120636f7369676e65722e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
1089 }
1090 
1091 // File: contracts/WalletFactory/WalletFactory.sol
1092 
1093 pragma solidity ^0.5.10;
1094 
1095 
1096 
1097 
1098 
1099 
1100 /// @title WalletFactory
1101 /// @dev A contract for creating wallets. 
1102 contract WalletFactory is FullWalletByteCode, HasNoEther, CloneFactory {
1103 
1104     /// @dev Pointer to a pre-deployed instance of the Wallet contract. This
1105     ///  deployment contains all the Wallet code.
1106     address public cloneWalletAddress;
1107 
1108     /// @notice Emitted whenever a wallet is created
1109     /// @param wallet The address of the wallet created
1110     /// @param authorizedAddress The initial authorized address of the wallet
1111     /// @param full `true` if the deployed wallet was a full, self
1112     ///  contained wallet; `false` if the wallet is a clone wallet
1113     event WalletCreated(address wallet, address authorizedAddress, bool full);
1114 
1115     constructor(address _cloneWalletAddress) public {
1116         cloneWalletAddress = _cloneWalletAddress;
1117     }
1118 
1119     /// @notice Used to deploy a wallet clone
1120     /// @dev Reasonably cheap to run (~100K gas)
1121     /// @param _recoveryAddress the initial recovery address for the wallet
1122     /// @param _authorizedAddress an initial authorized address for the wallet
1123     /// @param _cosigner the cosigning address for the initial `_authorizedAddress`
1124     function deployCloneWallet(
1125         address _recoveryAddress,
1126         address _authorizedAddress,
1127         uint256 _cosigner
1128     )
1129         public 
1130     {
1131         // create the clone
1132         address payable clone = createClone(cloneWalletAddress);
1133         // init the clone
1134         CloneableWallet(clone).init(_authorizedAddress, _cosigner, _recoveryAddress);
1135         // emit event
1136         emit WalletCreated(clone, _authorizedAddress, false);
1137     }
1138 
1139     /// @notice Used to deploy a wallet clone
1140     /// @dev Reasonably cheap to run (~100K gas)
1141     /// @dev The clone does not require `onlyOwner` as we avoid front-running
1142     ///  attacks by hashing the salt combined with the call arguments and using
1143     ///  that as the salt we provide to `create2`. Given this constraint, a 
1144     ///  front-runner would need to use the same `_recoveryAddress`, `_authorizedAddress`,
1145     ///  and `_cosigner` parameters as the original deployer, so the original deployer
1146     ///  would have control of the wallet even if the transaction was front-run.
1147     /// @param _recoveryAddress the initial recovery address for the wallet
1148     /// @param _authorizedAddress an initial authorized address for the wallet
1149     /// @param _cosigner the cosigning address for the initial `_authorizedAddress`
1150     /// @param _salt the salt for the `create2` instruction
1151     function deployCloneWallet2(
1152         address _recoveryAddress,
1153         address _authorizedAddress,
1154         uint256 _cosigner,
1155         bytes32 _salt
1156     )
1157         public
1158     {
1159         // calculate our own salt based off of args
1160         bytes32 salt = keccak256(abi.encodePacked(_salt, _authorizedAddress, _cosigner, _recoveryAddress));
1161         // create the clone counterfactually
1162         address payable clone = createClone2(cloneWalletAddress, salt);
1163         // ensure we get an address
1164         require(clone != address(0), "wallet must have address");
1165 
1166         // check size
1167         uint256 size;
1168         // note this takes an additional 700 gas
1169         assembly {
1170             size := extcodesize(clone)
1171         }
1172 
1173         require(size > 0, "wallet must have code");
1174 
1175         // init the clone
1176         CloneableWallet(clone).init(_authorizedAddress, _cosigner, _recoveryAddress);
1177         // emit event
1178         emit WalletCreated(clone, _authorizedAddress, false);   
1179     }
1180 
1181     /// @notice Used to deploy a full wallet
1182     /// @dev This is potentially very gas intensive!
1183     /// @param _recoveryAddress The initial recovery address for the wallet
1184     /// @param _authorizedAddress An initial authorized address for the wallet
1185     /// @param _cosigner The cosigning address for the initial `_authorizedAddress`
1186     function deployFullWallet(
1187         address _recoveryAddress,
1188         address _authorizedAddress,
1189         uint256 _cosigner
1190     )
1191         public 
1192     {
1193         // Copy the bytecode of the full wallet to memory.
1194         bytes memory fullWallet = fullWalletBytecode;
1195 
1196         address full;
1197         assembly {
1198             // get start of wallet buffer
1199             let startPtr := add(fullWallet, 0x20)
1200             // get start of arguments
1201             let endPtr := sub(add(startPtr, mload(fullWallet)), 0x60)
1202             // copy constructor parameters to memory
1203             mstore(endPtr, _authorizedAddress)
1204             mstore(add(endPtr, 0x20), _cosigner)
1205             mstore(add(endPtr, 0x40), _recoveryAddress)
1206             // create the contract
1207             full := create(0, startPtr, mload(fullWallet))
1208         }
1209         
1210         // check address
1211         require(full != address(0), "wallet must have address");
1212 
1213         // check size
1214         uint256 size;
1215         // note this takes an additional 700 gas, 
1216         // which is a relatively small amount in this case
1217         assembly {
1218             size := extcodesize(full)
1219         }
1220 
1221         require(size > 0, "wallet must have code");
1222 
1223         emit WalletCreated(full, _authorizedAddress, true);
1224     }
1225 
1226     /// @notice Used to deploy a full wallet counterfactually
1227     /// @dev This is potentially very gas intensive!
1228     /// @dev As the arguments are appended to the end of the bytecode and
1229     ///  then included in the `create2` call, we are safe from front running
1230     ///  attacks and do not need to restrict the caller of this function.
1231     /// @param _recoveryAddress The initial recovery address for the wallet
1232     /// @param _authorizedAddress An initial authorized address for the wallet
1233     /// @param _cosigner The cosigning address for the initial `_authorizedAddress`
1234     /// @param _salt The salt for the `create2` instruction
1235     function deployFullWallet2(
1236         address _recoveryAddress,
1237         address _authorizedAddress,
1238         uint256 _cosigner,
1239         bytes32 _salt
1240     )
1241         public
1242     {
1243         // Note: Be sure to update this whenever the wallet bytecode changes!
1244         // Simply run `yarn run build` and then copy the `"bytecode"`
1245         // portion from the `build/contracts/FullWallet.json` file to here,
1246         // then append 64x3 0's.
1247         //
1248         // Note: By not passing in the code as an argument, we save 600,000 gas.
1249         // An alternative would be to use `extcodecopy`, but again we save
1250         // gas by not having to call `extcodecopy`.
1251         bytes memory fullWallet = fullWalletBytecode;
1252 
1253         address full;
1254         assembly {
1255             // get start of wallet buffer
1256             let startPtr := add(fullWallet, 0x20)
1257             // get start of arguments
1258             let endPtr := sub(add(startPtr, mload(fullWallet)), 0x60)
1259             // copy constructor parameters to memory
1260             mstore(endPtr, _authorizedAddress)
1261             mstore(add(endPtr, 0x20), _cosigner)
1262             mstore(add(endPtr, 0x40), _recoveryAddress)
1263             // create the contract using create2
1264             full := create2(0, startPtr, mload(fullWallet), _salt)
1265         }
1266         
1267         // check address
1268         require(full != address(0), "wallet must have address");
1269 
1270         // check size
1271         uint256 size;
1272         // note this takes an additional 700 gas, 
1273         // which is a relatively small amount in this case
1274         assembly {
1275             size := extcodesize(full)
1276         }
1277 
1278         require(size > 0, "wallet must have code");
1279 
1280         emit WalletCreated(full, _authorizedAddress, true);
1281     }
1282 }