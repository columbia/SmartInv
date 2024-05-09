1 // fork from https://github.com/dapperlabs/dapper-contracts. portto did some modification.
2 
3 // File: contracts/ERC721/ERC721ReceiverDraft.sol
4 
5 pragma solidity ^0.5.10;
6 
7 
8 /// @title ERC721ReceiverDraft
9 /// @dev Interface for any contract that wants to support safeTransfers from
10 ///  ERC721 asset contracts.
11 /// @dev Note: this is the interface defined from 
12 ///  https://github.com/ethereum/EIPs/commit/2bddd126def7c046e1e62408dc2b51bdd9e57f0f
13 ///  to https://github.com/ethereum/EIPs/commit/27788131d5975daacbab607076f2ee04624f9dbb 
14 ///  and is not the final interface.
15 ///  Due to the extended period of time this revision was specified in the draft,
16 ///  we are supporting both this and the newer (final) interface in order to be 
17 ///  compatible with any ERC721 implementations that may have used this interface.
18 contract ERC721ReceiverDraft {
19 
20     /// @dev Magic value to be returned upon successful reception of an NFT
21     ///  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
22     ///  which can be also obtained as `ERC721ReceiverDraft(0).onERC721Received.selector`
23     /// @dev see https://github.com/ethereum/EIPs/commit/2bddd126def7c046e1e62408dc2b51bdd9e57f0f
24     bytes4 internal constant ERC721_RECEIVED_DRAFT = 0xf0b9e5ba;
25 
26     /// @notice Handle the receipt of an NFT
27     /// @dev The ERC721 smart contract calls this function on the recipient
28     ///  after a `transfer`. This function MAY throw to revert and reject the
29     ///  transfer. This function MUST use 50,000 gas or less. Return of other
30     ///  than the magic value MUST result in the transaction being reverted.
31     ///  Note: the contract address is always the message sender.
32     /// @param _from The sending address 
33     /// @param _tokenId The NFT identifier which is being transfered
34     /// @param data Additional data with no specified format
35     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
36     ///  unless throwing
37     function onERC721Received(address _from, uint256 _tokenId, bytes calldata data) external returns(bytes4);
38 }
39 
40 // File: contracts/ERC721/ERC721ReceiverFinal.sol
41 
42 pragma solidity ^0.5.10;
43 
44 
45 /// @title ERC721ReceiverFinal
46 /// @notice Interface for any contract that wants to support safeTransfers from
47 ///  ERC721 asset contracts.
48 ///  @dev Note: this is the final interface as defined at http://erc721.org
49 contract ERC721ReceiverFinal {
50 
51     /// @dev Magic value to be returned upon successful reception of an NFT
52     ///  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
53     ///  which can be also obtained as `ERC721ReceiverFinal(0).onERC721Received.selector`
54     /// @dev see https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.12.0/contracts/token/ERC721/ERC721Receiver.sol
55     bytes4 internal constant ERC721_RECEIVED_FINAL = 0x150b7a02;
56 
57     /// @notice Handle the receipt of an NFT
58     /// @dev The ERC721 smart contract calls this function on the recipient
59     /// after a `safetransfer`. This function MAY throw to revert and reject the
60     /// transfer. Return of other than the magic value MUST result in the
61     /// transaction being reverted.
62     /// Note: the contract address is always the message sender.
63     /// @param _operator The address which called `safeTransferFrom` function
64     /// @param _from The address which previously owned the token
65     /// @param _tokenId The NFT identifier which is being transferred
66     /// @param _data Additional data with no specified format
67     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
68     function onERC721Received(
69         address _operator,
70         address _from,
71         uint256 _tokenId,
72         bytes memory _data
73     )
74     public
75         returns (bytes4);
76 }
77 
78 // File: contracts/ERC721/ERC721Receivable.sol
79 
80 pragma solidity ^0.5.10;
81 
82 
83 
84 /// @title ERC721Receivable handles the reception of ERC721 tokens
85 ///  See ERC721 specification
86 /// @author Christopher Scott
87 /// @dev These functions are public, and could be called by anyone, even in the case
88 ///  where no NFTs have been transferred. Since it's not a reliable source of
89 ///  truth about ERC721 tokens being transferred, we save the gas and don't
90 ///  bother emitting a (potentially spurious) event as found in 
91 ///  https://github.com/OpenZeppelin/openzeppelin-solidity/blob/5471fc808a17342d738853d7bf3e9e5ef3108074/contracts/mocks/ERC721ReceiverMock.sol
92 contract ERC721Receivable is ERC721ReceiverDraft, ERC721ReceiverFinal {
93 
94     /// @notice Handle the receipt of an NFT
95     /// @dev The ERC721 smart contract calls this function on the recipient
96     ///  after a `transfer`. This function MAY throw to revert and reject the
97     ///  transfer. This function MUST use 50,000 gas or less. Return of other
98     ///  than the magic value MUST result in the transaction being reverted.
99     ///  Note: the contract address is always the message sender.
100     /// @param _from The sending address 
101     /// @param _tokenId The NFT identifier which is being transfered
102     /// @param data Additional data with no specified format
103     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
104     ///  unless throwing
105     function onERC721Received(address _from, uint256 _tokenId, bytes calldata data) external returns(bytes4) {
106         _from;
107         _tokenId;
108         data;
109 
110         // emit ERC721Received(_operator, _from, _tokenId, _data, gasleft());
111 
112         return ERC721_RECEIVED_DRAFT;
113     }
114 
115     /// @notice Handle the receipt of an NFT
116     /// @dev The ERC721 smart contract calls this function on the recipient
117     /// after a `safetransfer`. This function MAY throw to revert and reject the
118     /// transfer. Return of other than the magic value MUST result in the
119     /// transaction being reverted.
120     /// Note: the contract address is always the message sender.
121     /// @param _operator The address which called `safeTransferFrom` function
122     /// @param _from The address which previously owned the token
123     /// @param _tokenId The NFT identifier which is being transferred
124     /// @param _data Additional data with no specified format
125     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
126     function onERC721Received(
127         address _operator,
128         address _from,
129         uint256 _tokenId,
130         bytes memory _data
131     )
132         public
133         returns(bytes4)
134     {
135         _operator;
136         _from;
137         _tokenId;
138         _data;
139 
140         // emit ERC721Received(_operator, _from, _tokenId, _data, gasleft());
141 
142         return ERC721_RECEIVED_FINAL;
143     }
144 
145 }
146 
147 // File: contracts/ERC223/ERC223Receiver.sol
148 
149 pragma solidity ^0.5.10;
150 
151 
152 /// @title ERC223Receiver ensures we are ERC223 compatible
153 /// @author Christopher Scott
154 contract ERC223Receiver {
155     
156     bytes4 public constant ERC223_ID = 0xc0ee0b8a;
157 
158     struct TKN {
159         address sender;
160         uint value;
161         bytes data;
162         bytes4 sig;
163     }
164     
165     /// @notice tokenFallback is called from an ERC223 compatible contract
166     /// @param _from the address from which the token was sent
167     /// @param _value the amount of tokens sent
168     /// @param _data the data sent with the transaction
169     function tokenFallback(address _from, uint _value, bytes memory _data) public pure {
170         _from;
171         _value;
172         _data;
173     //   TKN memory tkn;
174     //   tkn.sender = _from;
175     //   tkn.value = _value;
176     //   tkn.data = _data;
177     //   uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
178     //   tkn.sig = bytes4(u);
179       
180       /* tkn variable is analogue of msg variable of Ether transaction
181       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
182       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
183       *  tkn.data is data of token transaction   (analogue of msg.data)
184       *  tkn.sig is 4 bytes signature of function
185       *  if data of token transaction is a function execution
186       */
187 
188     }
189 }
190 
191 // File: contracts/ERC1271/ERC1271.sol
192 
193 pragma solidity ^0.5.10;
194 
195 contract ERC1271 {
196 
197     /// @dev bytes4(keccak256("isValidSignature(bytes32,bytes)")
198     bytes4 internal constant ERC1271_VALIDSIGNATURE = 0x1626ba7e;
199 
200     /// @dev Should return whether the signature provided is valid for the provided data
201     /// @param hash 32-byte hash of the data that is signed
202     /// @param _signature Signature byte array associated with _data
203     ///  MUST return the bytes4 magic value 0x1626ba7e when function passes.
204     ///  MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
205     ///  MUST allow external calls
206     function isValidSignature(
207         bytes32 hash, 
208         bytes calldata _signature)
209         external
210         view 
211         returns (bytes4);
212 }
213 
214 // File: contracts/ECDSA.sol
215 
216 pragma solidity ^0.5.10;
217 
218 
219 /// @title ECDSA is a library that contains useful methods for working with ECDSA signatures
220 library ECDSA {
221 
222     /// @notice Extracts the r, s, and v components from the `sigData` field starting from the `offset`
223     /// @dev Note: does not do any bounds checking on the arguments!
224     /// @param sigData the signature data; could be 1 or more packed signatures.
225     /// @param offset the offset in sigData from which to start unpacking the signature components.
226     function extractSignature(bytes memory sigData, uint256 offset) internal pure returns  (bytes32 r, bytes32 s, uint8 v) {
227         // Divide the signature in r, s and v variables
228         // ecrecover takes the signature parameters, and the only way to get them
229         // currently is to use assembly.
230         // solium-disable-next-line security/no-inline-assembly
231         assembly {
232              let dataPointer := add(sigData, offset)
233              r := mload(add(dataPointer, 0x20))
234              s := mload(add(dataPointer, 0x40))
235              v := byte(0, mload(add(dataPointer, 0x60)))
236         }
237     
238         return (r, s, v);
239     }
240 }
241 
242 // File: contracts/Wallet/CoreWallet.sol
243 
244 pragma solidity ^0.5.10;
245 
246 
247 
248 
249 
250 
251 /// @title Core Wallet
252 /// @notice A basic smart contract wallet with cosigner functionality. The notion of "cosigner" is
253 ///  the simplest possible multisig solution, a two-of-two signature scheme. It devolves nicely
254 ///  to "one-of-one" (i.e. singlesig) by simply having the cosigner set to the same value as
255 ///  the main signer.
256 /// 
257 ///  Most "advanced" functionality (deadman's switch, multiday recovery flows, blacklisting, etc)
258 ///  can be implemented externally to this smart contract, either as an additional smart contract
259 ///  (which can be tracked as a signer without cosigner, or as a cosigner) or as an off-chain flow
260 ///  using a public/private key pair as cosigner. Of course, the basic cosigning functionality could
261 ///  also be implemented in this way, but (A) the complexity and gas cost of two-of-two multisig (as
262 ///  implemented here) is negligable even if you don't need the cosigner functionality, and
263 ///  (B) two-of-two multisig (as implemented here) handles a lot of really common use cases, most
264 ///  notably third-party gas payment and off-chain blacklisting and fraud detection.
265 contract CoreWallet is ERC721Receivable, ERC223Receiver, ERC1271 {
266 
267     using ECDSA for bytes;
268 
269     /// @notice We require that presigned transactions use the EIP-191 signing format.
270     ///  See that EIP for more info: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-191.md
271     byte public constant EIP191_VERSION_DATA = byte(0);
272     byte public constant EIP191_PREFIX = byte(0x19);
273 
274     /// @notice This is the version of the contract.
275     string public constant VERSION = "1.1.0";
276 
277     /// @notice This is a sentinel value used to determine when a delegate is set to expose 
278     ///  support for an interface containing more than a single function. See `delegates` and
279     ///  `setDelegate` for more information.
280     address public constant COMPOSITE_PLACEHOLDER = address(1);
281 
282     /// @notice A pre-shifted "1", used to increment the authVersion, so we can "prepend"
283     ///  the authVersion to an address (for lookups in the authorizations mapping)
284     ///  by using the '+' operator (which is cheaper than a shift and a mask). See the
285     ///  comment on the `authorizations` variable for how this is used.
286     uint256 public constant AUTH_VERSION_INCREMENTOR = (1 << 160);
287     
288     /// @notice The pre-shifted authVersion (to get the current authVersion as an integer,
289     ///  shift this value right by 160 bits). Starts as `1 << 160` (`AUTH_VERSION_INCREMENTOR`)
290     ///  See the comment on the `authorizations` variable for how this is used.
291     uint256 public authVersion;
292 
293     /// @notice A mapping containing all of the addresses that are currently authorized to manage
294     ///  the assets owned by this wallet.
295     ///
296     ///  The keys in this mapping are authorized addresses with a version number prepended,
297     ///  like so: (authVersion,96)(address,160). The current authVersion MUST BE included
298     ///  for each look-up; this allows us to effectively clear the entire mapping of its
299     ///  contents merely by incrementing the authVersion variable. (This is important for
300     ///  the emergencyRecovery() method.) Inspired by https://ethereum.stackexchange.com/a/42540
301     ///
302     ///  The values in this mapping are 256bit words, whose lower 20 bytes constitute "cosigners"
303     ///  for each address. If an address maps to itself, then that address is said to have no cosigner.
304     ///
305     ///  The upper 12 bytes are reserved for future meta-data purposes.  The meta-data could refer
306     ///  to the key (authorized address) or the value (cosigner) of the mapping.
307     ///
308     ///  Addresses that map to a non-zero cosigner in the current authVersion are called
309     ///  "authorized addresses".
310     mapping(uint256 => uint256) public authorizations;
311 
312     /// @notice A per-key nonce value, incremented each time a transaction is processed with that key.
313     ///  Used for replay prevention. The nonce value in the transaction must exactly equal the current
314     ///  nonce value in the wallet for that key. (This mirrors the way Ethereum's transaction nonce works.)
315     mapping(address => uint256) public nonces;
316 
317     /// @notice A mapping tracking dynamically supported interfaces and their corresponding
318     ///  implementation contracts. Keys are interface IDs and values are addresses of
319     ///  contracts that are responsible for implementing the function corresponding to the
320     ///  interface.
321     ///  
322     ///  Delegates are added (or removed) via the `setDelegate` method after the contract is
323     ///  deployed, allowing support for new interfaces to be dynamically added after deployment.
324     ///  When a delegate is added, its interface ID is considered "supported" under EIP165. 
325     ///
326     ///  For cases where an interface composed of more than a single function must be
327     ///  supported, it is necessary to manually add the composite interface ID with 
328     ///  `setDelegate(interfaceId, COMPOSITE_PLACEHOLDER)`. Interface IDs added with the
329     ///  COMPOSITE_PLACEHOLDER address are ignored when called and are only used to specify
330     ///  supported interfaces.
331     mapping(bytes4 => address) public delegates;
332 
333     /// @notice A special address that is authorized to call `emergencyRecovery()`. That function
334     ///  resets ALL authorization for this wallet, and must therefore be treated with utmost security.
335     ///  Reasonable choices for recoveryAddress include:
336     ///       - the address of a private key in cold storage
337     ///       - a physically secured hardware wallet
338     ///       - a multisig smart contract, possibly with a time-delayed challenge period
339     ///       - the zero address, if you like performing without a safety net ;-)
340     address public recoveryAddress;
341 
342     /// @notice Used to track whether or not this contract instance has been initialized. This
343     ///  is necessary since it is common for this wallet smart contract to be used as the "library
344     ///  code" for an clone contract. See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
345     ///  for more information about clone contracts.
346     bool public initialized;
347     
348     /// @notice Used to decorate methods that can only be called directly by the recovery address.
349     modifier onlyRecoveryAddress() {
350         require(msg.sender == recoveryAddress, "sender must be recovery address");
351         _;
352     }
353 
354     /// @notice Used to decorate the `init` function so this can only be called one time. Necessary
355     ///  since this contract will often be used as a "clone". (See above.)
356     modifier onlyOnce() {
357         require(!initialized, "must not already be initialized");
358         initialized = true;
359         _;
360     }
361     
362     /// @notice Used to decorate methods that can only be called indirectly via an `invoke()` method.
363     ///  In practice, it means that those methods can only be called by a signer/cosigner
364     ///  pair that is currently authorized. Theoretically, we could factor out the
365     ///  signer/cosigner verification code and use it explicitly in this modifier, but that
366     ///  would either result in duplicated code, or additional overhead in the invoke()
367     ///  calls (due to the stack manipulation for calling into the shared verification function).
368     ///  Doing it this way makes calling the administration functions more expensive (since they
369     ///  go through a explicit call() instead of just branching within the contract), but it
370     ///  makes invoke() more efficient. We assume that invoke() will be used much, much more often
371     ///  than any of the administration functions.
372     modifier onlyInvoked() {
373         require(msg.sender == address(this), "must be called from `invoke()`");
374         _;
375     }
376     
377     /// @notice Emitted when an authorized address is added, removed, or modified. When an
378     ///  authorized address is removed ("deauthorized"), cosigner will be address(0) in
379     ///  this event.
380     ///  
381     ///  NOTE: When emergencyRecovery() is called, all existing addresses are deauthorized
382     ///  WITHOUT Authorized(addr, 0) being emitted. If you are keeping an off-chain mirror of
383     ///  authorized addresses, you must also watch for EmergencyRecovery events.
384     /// @dev hash is 0xf5a7f4fb8a92356e8c8c4ae7ac3589908381450500a7e2fd08c95600021ee889
385     /// @param authorizedAddress the address to authorize or unauthorize
386     /// @param cosigner the 2-of-2 signatory (optional).
387     event Authorized(address authorizedAddress, uint256 cosigner);
388     
389     /// @notice Emitted when an emergency recovery has been performed. If this event is fired,
390     ///  ALL previously authorized addresses have been deauthorized and the only authorized
391     ///  address is the authorizedAddress indicated in this event.
392     /// @dev hash is 0xe12d0bbeb1d06d7a728031056557140afac35616f594ef4be227b5b172a604b5
393     /// @param authorizedAddress the new authorized address
394     /// @param cosigner the cosigning address for `authorizedAddress`
395     event EmergencyRecovery(address authorizedAddress, uint256 cosigner);
396 
397     /// @notice Emitted when the recovery address changes. Either (but not both) of the
398     ///  parameters may be zero.
399     /// @dev hash is 0x568ab3dedd6121f0385e007e641e74e1f49d0fa69cab2957b0b07c4c7de5abb6
400     /// @param previousRecoveryAddress the previous recovery address
401     /// @param newRecoveryAddress the new recovery address
402     event RecoveryAddressChanged(address previousRecoveryAddress, address newRecoveryAddress);
403 
404     /// @dev Emitted when this contract receives a non-zero amount ether via the fallback function
405     ///  (i.e. This event is not fired if the contract receives ether as part of a method invocation)
406     /// @param from the address which sent you ether
407     /// @param value the amount of ether sent
408     event Received(address from, uint value);
409 
410     /// @notice Emitted whenever a transaction is processed successfully from this wallet. Includes
411     ///  both simple send ether transactions, as well as other smart contract invocations.
412     /// @dev hash is 0x101214446435ebbb29893f3348e3aae5ea070b63037a3df346d09d3396a34aee
413     /// @param hash The hash of the entire operation set. 0 is returned when emitted from `invoke0()`.
414     /// @param result A bitfield of the results of the operations. A bit of 0 means success, and 1 means failure.
415     /// @param numOperations A count of the number of operations processed
416     event InvocationSuccess(
417         bytes32 hash,
418         uint256 result,
419         uint256 numOperations
420     );
421 
422     /// @notice Emitted when a delegate is added or removed.
423     /// @param interfaceId The interface ID as specified by EIP165
424     /// @param delegate The address of the contract implementing the given function. If this is
425     ///  COMPOSITE_PLACEHOLDER, we are indicating support for a composite interface.
426     event DelegateUpdated(bytes4 interfaceId, address delegate);
427 
428     /// @notice The shared initialization code used to setup the contract state regardless of whether or
429     ///  not the clone pattern is being used.
430     /// @param _authorizedAddress the initial authorized address, must not be zero!
431     /// @param _cosigner the initial cosigning address for `_authorizedAddress`, can be equal to `_authorizedAddress`
432     /// @param _recoveryAddress the initial recovery address for the wallet, can be address(0)
433     function init(address _authorizedAddress, uint256 _cosigner, address _recoveryAddress) public onlyOnce {
434         require(_authorizedAddress != _recoveryAddress, "Do not use the recovery address as an authorized address.");
435         require(address(_cosigner) != _recoveryAddress, "Do not use the recovery address as a cosigner.");
436         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
437         require(address(_cosigner) != address(0), "Initial cosigner must not be zero.");
438         
439         recoveryAddress = _recoveryAddress;
440         // set initial authorization value
441         authVersion = AUTH_VERSION_INCREMENTOR;
442         // add initial authorized address
443         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
444         
445         emit Authorized(_authorizedAddress, _cosigner);
446     }
447 
448     /// @notice The fallback function, invoked whenever we receive a transaction that doesn't call any of our
449     ///  named functions. In particular, this method is called when we are the target of a simple send
450     ///  transaction, when someone calls a method we have dynamically added a delegate for, or when someone
451     ///  tries to call a function we don't implement, either statically or dynamically.
452     ///
453     ///  A correct invocation of this method occurs in two cases:
454     ///  - someone transfers ETH to this wallet (`msg.data.length` is  0)
455     ///  - someone calls a delegated function (`msg.data.length` is greater than 0 and
456     ///    `delegates[msg.sig]` is set) 
457     ///  In all other cases, this function will revert.
458     ///
459     ///  NOTE: Some smart contracts send 0 eth as part of a more complex operation
460     ///  (-cough- CryptoKitties -cough-); ideally, we'd `require(msg.value > 0)` here when
461     ///  `msg.data.length == 0`, but to work with those kinds of smart contracts, we accept zero sends
462     ///  and just skip logging in that case.
463     function() external payable {
464         if (msg.value > 0) {
465             emit Received(msg.sender, msg.value);
466         }
467         if (msg.data.length > 0) {
468             address delegate = delegates[msg.sig]; 
469             require(delegate > COMPOSITE_PLACEHOLDER, "Invalid transaction");
470 
471             // We have found a delegate contract that is responsible for the method signature of
472             // this call. Now, pass along the calldata of this CALL to the delegate contract.  
473             assembly {
474                 calldatacopy(0, 0, calldatasize())
475                 let result := staticcall(gas, delegate, 0, calldatasize(), 0, 0)
476                 returndatacopy(0, 0, returndatasize())
477 
478                 // If the delegate reverts, we revert. If the delegate does not revert, we return the data
479                 // returned by the delegate to the original caller.
480                 switch result 
481                 case 0 {
482                     revert(0, returndatasize())
483                 } 
484                 default {
485                     return(0, returndatasize())
486                 }
487             } 
488         }    
489     }
490 
491     /// @notice Adds or removes dynamic support for an interface. Can be used in 3 ways:
492     ///   - Add a contract "delegate" that implements a single function
493     ///   - Remove delegate for a function
494     ///   - Specify that an interface ID is "supported", without adding a delegate. This is
495     ///     used for composite interfaces when the interface ID is not a single method ID.
496     /// @dev Must be called through `invoke`
497     /// @param _interfaceId The ID of the interface we are adding support for
498     /// @param _delegate Either:
499     ///    - the address of a contract that implements the function specified by `_interfaceId`
500     ///      for adding an implementation for a single function
501     ///    - 0 for removing an existing delegate
502     ///    - COMPOSITE_PLACEHOLDER for specifying support for a composite interface
503     function setDelegate(bytes4 _interfaceId, address _delegate) external onlyInvoked {
504         delegates[_interfaceId] = _delegate;
505         emit DelegateUpdated(_interfaceId, _delegate);
506     }
507     
508     /// @notice Configures an authorizable address. Can be used in four ways:
509     ///   - Add a new signer/cosigner pair (cosigner must be non-zero)
510     ///   - Set or change the cosigner for an existing signer (if authorizedAddress != cosigner)
511     ///   - Remove the cosigning requirement for a signer (if authorizedAddress == cosigner)
512     ///   - Remove a signer (if cosigner == address(0))
513     /// @dev Must be called through `invoke()`
514     /// @param _authorizedAddress the address to configure authorization
515     /// @param _cosigner the corresponding cosigning address
516     function setAuthorized(address _authorizedAddress, uint256 _cosigner) external onlyInvoked {
517         // TODO: Allowing a signer to remove itself is actually pretty terrible; it could result in the user
518         //  removing their only available authorized key. Unfortunately, due to how the invocation forwarding
519         //  works, we don't actually _know_ which signer was used to call this method, so there's no easy way
520         //  to prevent this.
521         
522         // TODO: Allowing the backup key to be set as an authorized address bypasses the recovery mechanisms.
523         //  Dapper can prevent this with offchain logic and the cosigner, but it would be nice to have 
524         //  this enforced by the smart contract logic itself.
525         
526         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
527         require(_authorizedAddress != recoveryAddress, "Do not use the recovery address as an authorized address.");
528         require(address(_cosigner) == address(0) || address(_cosigner) != recoveryAddress, "Do not use the recovery address as a cosigner.");
529  
530         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
531         emit Authorized(_authorizedAddress, _cosigner);
532     }
533     
534     /// @notice Performs an emergency recovery operation, removing all existing authorizations and setting
535     ///  a sole new authorized address with optional cosigner. THIS IS A SCORCHED EARTH SOLUTION, and great
536     ///  care should be taken to ensure that this method is never called unless it is a last resort. See the
537     ///  comments above about the proper kinds of addresses to use as the recoveryAddress to ensure this method
538     ///  is not trivially abused.
539     /// @param _authorizedAddress the new and sole authorized address
540     /// @param _cosigner the corresponding cosigner address, can be equal to _authorizedAddress
541     function emergencyRecovery(address _authorizedAddress, uint256 _cosigner) external onlyRecoveryAddress {
542         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
543         require(_authorizedAddress != recoveryAddress, "Do not use the recovery address as an authorized address.");
544         require(address(_cosigner) != address(0), "The cosigner must not be zero.");
545 
546         // Incrementing the authVersion number effectively erases the authorizations mapping. See the comments
547         // on the authorizations variable (above) for more information.
548         authVersion += AUTH_VERSION_INCREMENTOR;
549 
550         // Store the new signer/cosigner pair as the only remaining authorized address
551         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
552         emit EmergencyRecovery(_authorizedAddress, _cosigner);
553     }
554 
555     function emergencyRecovery2(address _authorizedAddress, uint256 _cosigner, address _recoveryAddress) external onlyRecoveryAddress {
556             require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
557             require(_authorizedAddress != _recoveryAddress, "Do not use the recovery address as an authorized address.");
558             require(address(_cosigner) != address(0), "The cosigner must not be zero.");
559 
560             // Incrementing the authVersion number effectively erases the authorizations mapping. See the comments
561             // on the authorizations variable (above) for more information.
562             authVersion += AUTH_VERSION_INCREMENTOR;
563 
564             // Store the new signer/cosigner pair as the only remaining authorized address
565             authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
566 
567             // set new recovery address
568             address previous = recoveryAddress;
569             recoveryAddress = _recoveryAddress;
570 
571             emit RecoveryAddressChanged(previous, recoveryAddress);
572             emit EmergencyRecovery(_authorizedAddress, _cosigner);
573      }
574 
575     /// @notice Sets the recovery address, which can be zero (indicating that no recovery is possible)
576     ///  Can be updated by any authorized address. This address should be set with GREAT CARE. See the
577     ///  comments above about the proper kinds of addresses to use as the recoveryAddress to ensure this
578     ///  mechanism is not trivially abused.
579     /// @dev Must be called through `invoke()`
580     /// @param _recoveryAddress the new recovery address
581     function setRecoveryAddress(address _recoveryAddress) external onlyInvoked {
582         require(
583             address(authorizations[authVersion + uint256(_recoveryAddress)]) == address(0),
584             "Do not use an authorized address as the recovery address."
585         );
586  
587         address previous = recoveryAddress;
588         recoveryAddress = _recoveryAddress;
589 
590         emit RecoveryAddressChanged(previous, recoveryAddress);
591     }
592 
593     /// @notice Allows ANY caller to recover gas by way of deleting old authorization keys after
594     ///  a recovery operation. Anyone can call this method to delete the old unused storage and
595     ///  get themselves a bit of gas refund in the bargin.
596     /// @dev keys must be known to caller or else nothing is refunded
597     /// @param _version the version of the mapping which you want to delete (unshifted)
598     /// @param _keys the authorization keys to delete 
599     function recoverGas(uint256 _version, address[] calldata _keys) external {
600         // TODO: should this be 0xffffffffffffffffffffffff ?
601         require(_version > 0 && _version < 0xffffffff, "Invalid version number.");
602         
603         uint256 shiftedVersion = _version << 160;
604 
605         require(shiftedVersion < authVersion, "You can only recover gas from expired authVersions.");
606 
607         for (uint256 i = 0; i < _keys.length; ++i) {
608             delete(authorizations[shiftedVersion + uint256(_keys[i])]);
609         }
610     }
611 
612     /// @notice Should return whether the signature provided is valid for the provided data
613     ///  See https://github.com/ethereum/EIPs/issues/1271
614     /// @dev This function meets the following conditions as per the EIP:
615     ///  MUST return the bytes4 magic value `0x1626ba7e` when function passes.
616     ///  MUST NOT modify state (using `STATICCALL` for solc < 0.5, `view` modifier for solc > 0.5)
617     ///  MUST allow external calls
618     /// @param hash A 32 byte hash of the signed data.  The actual hash that is hashed however is the
619     ///  the following tightly packed arguments: `0x19,0x0,wallet_address,hash`
620     /// @param _signature Signature byte array associated with `_data`
621     /// @return Magic value `0x1626ba7e` upon success, 0 otherwise.
622     function isValidSignature(bytes32 hash, bytes calldata _signature) external view returns (bytes4) {
623         
624         // We 'hash the hash' for the following reasons:
625         // 1. `hash` is not the hash of an Ethereum transaction
626         // 2. signature must target this wallet to avoid replaying the signature for another wallet
627         // with the same key
628         // 3. Gnosis does something similar: 
629         // https://github.com/gnosis/safe-contracts/blob/102e632d051650b7c4b0a822123f449beaf95aed/contracts/GnosisSafe.sol
630         bytes32 operationHash = keccak256(
631             abi.encodePacked(
632             EIP191_PREFIX,
633             EIP191_VERSION_DATA,
634             this,
635             hash));
636 
637         bytes32[2] memory r;
638         bytes32[2] memory s;
639         uint8[2] memory v;
640         address signer;
641         address cosigner;
642 
643         // extract 1 or 2 signatures depending on length
644         if (_signature.length == 65) {
645             (r[0], s[0], v[0]) = _signature.extractSignature(0);
646             signer = ecrecover(operationHash, v[0], r[0], s[0]);
647             cosigner = signer;
648         } else if (_signature.length == 130) {
649             (r[0], s[0], v[0]) = _signature.extractSignature(0);
650             (r[1], s[1], v[1]) = _signature.extractSignature(65);
651             signer = ecrecover(operationHash, v[0], r[0], s[0]);
652             cosigner = ecrecover(operationHash, v[1], r[1], s[1]);
653         } else {
654             return 0;
655         }
656             
657         // check for valid signature
658         if (signer == address(0)) {
659             return 0;
660         }
661 
662         // check for valid signature
663         if (cosigner == address(0)) {
664             return 0;
665         }
666 
667         // check to see if this is an authorized key
668         if (address(authorizations[authVersion + uint256(signer)]) != cosigner) {
669             return 0;
670         }
671 
672         return ERC1271_VALIDSIGNATURE;
673     }
674 
675     /// @notice Query if this contract implements an interface. This function takes into account
676     ///  interfaces we implement dynamically through delegates. For interfaces that are just a
677     ///  single method, using `setDelegate` will result in that method's ID returning true from 
678     ///  `supportsInterface`. For composite interfaces that are composed of multiple functions, it is
679     ///  necessary to add the interface ID manually with `setDelegate(interfaceID,
680     ///  COMPOSITE_PLACEHOLDER)`
681     ///  IN ADDITION to adding each function of the interface as usual.
682     /// @param interfaceID The interface identifier, as specified in ERC-165
683     /// @dev Interface identification is specified in ERC-165. This function
684     ///  uses less than 30,000 gas.
685     /// @return `true` if the contract implements `interfaceID` and
686     ///  `interfaceID` is not 0xffffffff, `false` otherwise
687     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
688         // First check if the ID matches one of the interfaces we support statically.
689         if (
690             interfaceID == this.supportsInterface.selector || // ERC165
691             interfaceID == ERC721_RECEIVED_FINAL || // ERC721 Final
692             interfaceID == ERC721_RECEIVED_DRAFT || // ERC721 Draft
693             interfaceID == ERC223_ID || // ERC223
694             interfaceID == ERC1271_VALIDSIGNATURE // ERC1271
695         ) {
696             return true;
697         }
698         // If we don't support the interface statically, check whether we have added
699         // dynamic support for it.
700         return uint256(delegates[interfaceID]) > 0;
701     }
702 
703     /// @notice A version of `invoke()` that has no explicit signatures, and uses msg.sender
704     ///  as both the signer and cosigner. Will only succeed if `msg.sender` is an authorized
705     ///  signer for this wallet, with no cosigner, saving transaction size and gas in that case.
706     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
707     function invoke0(bytes calldata data) external {
708         // The nonce doesn't need to be incremented for transactions that don't include explicit signatures;
709         // the built-in nonce of the native ethereum transaction will protect against replay attacks, and we
710         // can save the gas that would be spent updating the nonce variable
711 
712         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner)
713         require(address(authorizations[authVersion + uint256(msg.sender)]) == msg.sender, "Invalid authorization.");
714 
715         internalInvoke(0, data);
716     }
717 
718     /// @notice A version of `invoke()` that has one explicit signature which is used to derive the authorized
719     ///  address. Uses `msg.sender` as the cosigner.
720     /// @param v the v value for the signature; see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
721     /// @param r the r value for the signature
722     /// @param s the s value for the signature
723     /// @param nonce the nonce value for the signature
724     /// @param authorizedAddress the address of the authorization key; this is used here so that cosigner signatures are interchangeable
725     ///  between this function and `invoke2()`
726     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
727     function invoke1CosignerSends(uint8 v, bytes32 r, bytes32 s, uint256 nonce, address authorizedAddress, bytes calldata data) external {
728         // check signature version
729         require(v == 27 || v == 28, "Invalid signature version.");
730 
731         // calculate hash
732         bytes32 operationHash = keccak256(
733             abi.encodePacked(
734             EIP191_PREFIX,
735             EIP191_VERSION_DATA,
736             this,
737             nonce,
738             authorizedAddress,
739             data));
740  
741         // recover signer
742         address signer = ecrecover(operationHash, v, r, s);
743 
744         // check for valid signature
745         require(signer != address(0), "Invalid signature.");
746 
747         // check nonce
748         require(nonce > nonces[signer], "must use valid nonce for signer");
749 
750         // check signer
751         require(signer == authorizedAddress, "authorized addresses must be equal");
752 
753         // Get cosigner
754         address requiredCosigner = address(authorizations[authVersion + uint256(signer)]);
755         
756         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
757         // if the actual cosigner matches the required cosigner.
758         require(requiredCosigner == signer || requiredCosigner == msg.sender, "Invalid authorization.");
759 
760         // increment nonce to prevent replay attacks
761         nonces[signer] = nonce;
762 
763         // call internal function
764         internalInvoke(operationHash, data);
765     }
766 
767     /// @notice A version of `invoke()` that has one explicit signature which is used to derive the cosigning
768     ///  address. Uses `msg.sender` as the authorized address.
769     /// @param v the v value for the signature; see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
770     /// @param r the r value for the signature
771     /// @param s the s value for the signature
772     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
773     function invoke1SignerSends(uint8 v, bytes32 r, bytes32 s, bytes calldata data) external {
774         // check signature version
775         // `ecrecover` will in fact return 0 if given invalid
776         // so perhaps this check is redundant
777         require(v == 27 || v == 28, "Invalid signature version.");
778         
779         uint256 nonce = nonces[msg.sender];
780 
781         // calculate hash
782         bytes32 operationHash = keccak256(
783             abi.encodePacked(
784             EIP191_PREFIX,
785             EIP191_VERSION_DATA,
786             this,
787             nonce,
788             msg.sender,
789             data));
790  
791         // recover cosigner
792         address cosigner = ecrecover(operationHash, v, r, s);
793         
794         // check for valid signature
795         require(cosigner != address(0), "Invalid signature.");
796 
797         // Get required cosigner
798         address requiredCosigner = address(authorizations[authVersion + uint256(msg.sender)]);
799         
800         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
801         // if the actual cosigner matches the required cosigner.
802         require(requiredCosigner == cosigner || requiredCosigner == msg.sender, "Invalid authorization.");
803 
804         // increment nonce to prevent replay attacks
805         nonces[msg.sender] = nonce + 1;
806  
807         internalInvoke(operationHash, data);
808     }
809 
810     /// @notice A version of `invoke()` that has two explicit signatures, the first is used to derive the authorized
811     ///  address, the second to derive the cosigner. The value of `msg.sender` is ignored.
812     /// @param v the v values for the signatures
813     /// @param r the r values for the signatures
814     /// @param s the s values for the signatures
815     /// @param nonce the nonce value for the signature
816     /// @param authorizedAddress the address of the signer; forces the signature to be unique and tied to the signers nonce 
817     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
818     function invoke2(uint8[2] calldata v, bytes32[2] calldata r, bytes32[2] calldata s, uint256 nonce, address authorizedAddress, bytes calldata data) external {
819         // check signature versions
820         // `ecrecover` will infact return 0 if given invalid
821         // so perhaps these checks are redundant
822         require(v[0] == 27 || v[0] == 28, "invalid signature version v[0]");
823         require(v[1] == 27 || v[1] == 28, "invalid signature version v[1]");
824  
825         bytes32 operationHash = keccak256(
826             abi.encodePacked(
827             EIP191_PREFIX,
828             EIP191_VERSION_DATA,
829             this,
830             nonce,
831             authorizedAddress,
832             data));
833  
834         // recover signer and cosigner
835         address signer = ecrecover(operationHash, v[0], r[0], s[0]);
836         address cosigner = ecrecover(operationHash, v[1], r[1], s[1]);
837 
838         // check for valid signatures
839         require(signer != address(0), "Invalid signature for signer.");
840         require(cosigner != address(0), "Invalid signature for cosigner.");
841 
842         // check signer address
843         require(signer == authorizedAddress, "authorized addresses must be equal");
844 
845         // check nonces
846         require(nonce > nonces[signer], "must use valid nonce for signer");
847 
848         // Get Mapping
849         address requiredCosigner = address(authorizations[authVersion + uint256(signer)]);
850         
851         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
852         // if the actual cosigner matches the required cosigner.
853         require(requiredCosigner == signer || requiredCosigner == cosigner, "Invalid authorization.");
854 
855         // increment nonce to prevent replay attacks
856         nonces[signer] = nonce;
857 
858         internalInvoke(operationHash, data);
859     }
860 
861     /// @dev Internal invoke call, 
862     /// @param operationHash The hash of the operation
863     /// @param data The data to send to the `call()` operation
864     ///  The data is prefixed with a global 1 byte revert flag
865     ///  If revert is 1, then any revert from a `call()` operation is rethrown.
866     ///  Otherwise, the error is recorded in the `result` field of the `InvocationSuccess` event.
867     ///  Immediately following the revert byte (no padding), the data format is then is a series
868     ///  of 1 or more tightly packed tuples:
869     ///  `<target(20),amount(32),datalength(32),data>`
870     ///  If `datalength == 0`, the data field must be omitted
871     function internalInvoke(bytes32 operationHash, bytes memory data) internal {
872         // keep track of the number of operations processed
873         uint256 numOps;
874         // keep track of the result of each operation as a bit
875         uint256 result;
876 
877         // We need to store a reference to this string as a variable so we can use it as an argument to
878         // the revert call from assembly.
879         string memory invalidLengthMessage = "Data field too short";
880         string memory callFailed = "Call failed";
881 
882         // At an absolute minimum, the data field must be at least 85 bytes
883         // <revert(1), to_address(20), value(32), data_length(32)>
884         require(data.length >= 85, invalidLengthMessage);
885 
886         // Forward the call onto its actual target. Note that the target address can be `self` here, which is
887         // actually the required flow for modifying the configuration of the authorized keys and recovery address.
888         //
889         // The assembly code below loads data directly from memory, so the enclosing function must be marked `internal`
890         assembly {
891             // A cursor pointing to the revert flag, starts after the length field of the data object
892             let memPtr := add(data, 32)
893 
894             // The revert flag is the leftmost byte from memPtr
895             let revertFlag := byte(0, mload(memPtr))
896 
897             // A pointer to the end of the data object
898             let endPtr := add(memPtr, mload(data))
899 
900             // Now, memPtr is a cursor pointing to the beginning of the current sub-operation
901             memPtr := add(memPtr, 1)
902 
903             // Loop through data, parsing out the various sub-operations
904             for { } lt(memPtr, endPtr) { } {
905                 // Load the length of the call data of the current operation
906                 // 52 = to(20) + value(32)
907                 let len := mload(add(memPtr, 52))
908                 
909                 // Compute a pointer to the end of the current operation
910                 // 84 = to(20) + value(32) + size(32)
911                 let opEnd := add(len, add(memPtr, 84))
912 
913                 // Bail if the current operation's data overruns the end of the enclosing data buffer
914                 // NOTE: Comment out this bit of code and uncomment the next section if you want
915                 // the solidity-coverage tool to work.
916                 // See https://github.com/sc-forks/solidity-coverage/issues/287
917                 if gt(opEnd, endPtr) {
918                     // The computed end of this operation goes past the end of the data buffer. Not good!
919                     revert(add(invalidLengthMessage, 32), mload(invalidLengthMessage))
920                 }
921                 // NOTE: Code that is compatible with solidity-coverage
922                 // switch gt(opEnd, endPtr)
923                 // case 1 {
924                 //     revert(add(invalidLengthMessage, 32), mload(invalidLengthMessage))
925                 // }
926 
927                 // This line of code packs in a lot of functionality!
928                 //  - load the target address from memPtr, the address is only 20-bytes but mload always grabs 32-bytes,
929                 //    so we have to shr by 12 bytes.
930                 //  - load the value field, stored at memPtr+20
931                 //  - pass a pointer to the call data, stored at memPtr+84
932                 //  - use the previously loaded len field as the size of the call data
933                 //  - make the call (passing all remaining gas to the child call)
934                 //  - check the result (0 == reverted)
935                 if eq(0, call(gas, shr(96, mload(memPtr)), mload(add(memPtr, 20)), add(memPtr, 84), len, 0, 0)) {
936                     switch revertFlag
937                     case 1 {
938                         revert(add(callFailed, 32), mload(callFailed))
939                     }
940                     default {
941                         // mark this operation as failed
942                         // create the appropriate bit, 'or' with previous
943                         result := or(result, exp(2, numOps))
944                     }
945                 }
946 
947                 // increment our counter
948                 numOps := add(numOps, 1)
949              
950                 // Update mem pointer to point to the next sub-operation
951                 memPtr := opEnd
952             }
953         }
954 
955         // emit single event upon success
956         emit InvocationSuccess(operationHash, result, numOps);
957     }
958 }
959 
960 // File: contracts/Wallet/CloneableWallet.sol
961 
962 pragma solidity ^0.5.10;
963 
964 
965 
966 /// @title Cloneable Wallet
967 /// @notice This contract represents a complete but non working wallet.  
968 ///  It is meant to be deployed and serve as the contract that you clone
969 ///  in an EIP 1167 clone setup.
970 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
971 /// @dev Currently, we are seeing approximatley 933 gas overhead for using
972 ///  the clone wallet; use `FullWallet` if you think users will overtake
973 ///  the transaction threshold over the lifetime of the wallet.
974 contract CloneableWallet is CoreWallet {
975 
976     /// @dev An empty constructor that deploys a NON-FUNCTIONAL version
977     ///  of `CoreWallet`
978     constructor () public {
979         initialized = true;
980     }
981 }