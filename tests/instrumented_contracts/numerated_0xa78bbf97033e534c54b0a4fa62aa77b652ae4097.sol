1 // File: contracts/ERC721/ERC721ReceiverDraft.sol
2 
3 pragma solidity ^0.4.24;
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
35     function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
36 }
37 
38 // File: contracts/ERC721/ERC721ReceiverFinal.sol
39 
40 pragma solidity ^0.4.24;
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
70         bytes _data
71     )
72     public
73         returns (bytes4);
74 }
75 
76 // File: contracts/ERC721/ERC721Receivable.sol
77 
78 pragma solidity ^0.4.24;
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
103     function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4) {
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
128         bytes _data
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
147 pragma solidity ^0.4.24;
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
167     function tokenFallback(address _from, uint _value, bytes _data) public pure {
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
191 pragma solidity ^0.4.24;
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
206         bytes _signature)
207         external
208         view 
209         returns (bytes4);
210 }
211 
212 // File: contracts/ECDSA.sol
213 
214 pragma solidity ^0.4.24;
215 
216 
217 /// @title ECDSA is a library that contains useful methods for working with ECDSA signatures
218 library ECDSA {
219 
220     /// @notice Extracts the r, s, and v components from the `sigData` field starting from the `offset`
221     /// @dev Note: does not do any bounds checking on the arguments!
222     /// @param sigData the signature data; could be 1 or more packed signatures.
223     /// @param offset the offset in sigData from which to start unpacking the signature components.
224     function extractSignature(bytes sigData, uint256 offset) internal pure returns  (bytes32 r, bytes32 s, uint8 v) {
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
242 pragma solidity ^0.4.24;
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
263 contract CoreWallet is ERC721Receivable, ERC223Receiver, ERC1271  {
264 
265     using ECDSA for bytes;
266 
267     /// @notice We require that presigned transactions use the EIP-191 signing format.
268     ///  See that EIP for more info: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-191.md
269     byte public constant EIP191_VERSION_DATA = byte(0);
270     byte public constant EIP191_PREFIX = byte(0x19);
271 
272     /// @notice This is the version of the contract.
273     string public constant VERSION = "1.0.0";
274 
275     /// @notice A pre-shifted "1", used to increment the authVersion, so we can "prepend"
276     ///  the authVersion to an address (for lookups in the authorizations mapping)
277     ///  by using the '+' operator (which is cheaper than a shift and a mask). See the
278     ///  comment on the `authorizations` variable for how this is used.
279     uint256 public constant AUTH_VERSION_INCREMENTOR = (1 << 160);
280     
281     /// @notice The pre-shifted authVersion (to get the current authVersion as an integer,
282     ///  shift this value right by 160 bits). Starts as `1 << 160` (`AUTH_VERSION_INCREMENTOR`)
283     ///  See the comment on the `authorizations` variable for how this is used.
284     uint256 public authVersion;
285 
286     /// @notice A mapping containing all of the addresses that are currently authorized to manage
287     ///  the assets owned by this wallet.
288     ///
289     ///  The keys in this mapping are authorized addresses with a version number prepended,
290     ///  like so: (authVersion,96)(address,160). The current authVersion MUST BE included
291     ///  for each look-up; this allows us to effectively clear the entire mapping of its
292     ///  contents merely by incrementing the authVersion variable. (This is important for
293     ///  the emergencyRecovery() method.) Inspired by https://ethereum.stackexchange.com/a/42540
294     ///
295     ///  The values in this mapping are 256bit words, whose lower 20 bytes constitute "cosigners"
296     ///  for each address. If an address maps to itself, then that address is said to have no cosigner.
297     ///
298     ///  The upper 12 bytes are reserved for future meta-data purposes.  The meta-data could refer
299     ///  to the key (authorized address) or the value (cosigner) of the mapping.
300     ///
301     ///  Addresses that map to a non-zero cosigner in the current authVersion are called
302     ///  "authorized addresses".
303     mapping(uint256 => uint256) public authorizations;
304 
305     /// @notice A per-key nonce value, incremented each time a transaction is processed with that key.
306     ///  Used for replay prevention. The nonce value in the transaction must exactly equal the current
307     ///  nonce value in the wallet for that key. (This mirrors the way Ethereum's transaction nonce works.)
308     mapping(address => uint256) public nonces;
309 
310     /// @notice A special address that is authorized to call `emergencyRecovery()`. That function
311     ///  resets ALL authorization for this wallet, and must therefore be treated with utmost security.
312     ///  Reasonable choices for recoveryAddress include:
313     ///       - the address of a private key in cold storage
314     ///       - a physically secured hardware wallet
315     ///       - a multisig smart contract, possibly with a time-delayed challenge period
316     ///       - the zero address, if you like performing without a safety net ;-)
317     address public recoveryAddress;
318 
319     /// @notice Used to track whether or not this contract instance has been initialized. This
320     ///  is necessary since it is common for this wallet smart contract to be used as the "library
321     ///  code" for an clone contract. See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
322     ///  for more information about clone contracts.
323     bool public initialized;
324     
325     /// @notice Used to decorate methods that can only be called directly by the recovery address.
326     modifier onlyRecoveryAddress() {
327         require(msg.sender == recoveryAddress, "sender must be recovery address");
328         _;
329     }
330 
331     /// @notice Used to decorate the `init` function so this can only be called one time. Necessary
332     ///  since this contract will often be used as a "clone". (See above.)
333     modifier onlyOnce() {
334         require(!initialized, "must not already be initialized");
335         initialized = true;
336         _;
337     }
338     
339     /// @notice Used to decorate methods that can only be called indirectly via an `invoke()` method.
340     ///  In practice, it means that those methods can only be called by a signer/cosigner
341     ///  pair that is currently authorized. Theoretically, we could factor out the
342     ///  signer/cosigner verification code and use it explicitly in this modifier, but that
343     ///  would either result in duplicated code, or additional overhead in the invoke()
344     ///  calls (due to the stack manipulation for calling into the shared verification function).
345     ///  Doing it this way makes calling the administration functions more expensive (since they
346     ///  go through a explict call() instead of just branching within the contract), but it
347     ///  makes invoke() more efficient. We assume that invoke() will be used much, much more often
348     ///  than any of the administration functions.
349     modifier onlyInvoked() {
350         require(msg.sender == address(this), "must be called from `invoke()`");
351         _;
352     }
353     
354     /// @notice Emitted when an authorized address is added, removed, or modified. When an
355     ///  authorized address is removed ("deauthorized"), cosigner will be address(0) in
356     ///  this event.
357     ///  
358     ///  NOTE: When emergencyRecovery() is called, all existing addresses are deauthorized
359     ///  WITHOUT Authorized(addr, 0) being emitted. If you are keeping an off-chain mirror of
360     ///  authorized addresses, you must also watch for EmergencyRecovery events.
361     /// @dev hash is 0xf5a7f4fb8a92356e8c8c4ae7ac3589908381450500a7e2fd08c95600021ee889
362     /// @param authorizedAddress the address to authorize or unauthorize
363     /// @param cosigner the 2-of-2 signatory (optional).
364     event Authorized(address authorizedAddress, uint256 cosigner);
365     
366     /// @notice Emitted when an emergency recovery has been performed. If this event is fired,
367     ///  ALL previously authorized addresses have been deauthorized and the only authorized
368     ///  address is the authorizedAddress indicated in this event.
369     /// @dev hash is 0xe12d0bbeb1d06d7a728031056557140afac35616f594ef4be227b5b172a604b5
370     /// @param authorizedAddress the new authorized address
371     /// @param cosigner the cosigning address for `authorizedAddress`
372     event EmergencyRecovery(address authorizedAddress, uint256 cosigner);
373 
374     /// @notice Emitted when the recovery address changes. Either (but not both) of the
375     ///  parameters may be zero.
376     /// @dev hash is 0x568ab3dedd6121f0385e007e641e74e1f49d0fa69cab2957b0b07c4c7de5abb6
377     /// @param previousRecoveryAddress the previous recovery address
378     /// @param newRecoveryAddress the new recovery address
379     event RecoveryAddressChanged(address previousRecoveryAddress, address newRecoveryAddress);
380 
381     /// @dev Emitted when this contract receives a non-zero amount ether via the fallback function
382     ///  (i.e. This event is not fired if the contract receives ether as part of a method invocation)
383     /// @param from the address which sent you ether
384     /// @param value the amount of ether sent
385     event Received(address from, uint value);
386 
387     /// @notice Emitted whenever a transaction is processed sucessfully from this wallet. Includes
388     ///  both simple send ether transactions, as well as other smart contract invocations.
389     /// @dev hash is 0x101214446435ebbb29893f3348e3aae5ea070b63037a3df346d09d3396a34aee
390     /// @param hash The hash of the entire operation set. 0 is returned when emitted from `invoke0()`.
391     /// @param result A bitfield of the results of the operations. A bit of 0 means success, and 1 means failure.
392     /// @param numOperations A count of the number of operations processed
393     event InvocationSuccess(
394         bytes32 hash,
395         uint256 result,
396         uint256 numOperations
397     );
398 
399     /// @notice The shared initialization code used to setup the contract state regardless of whether or
400     ///  not the clone pattern is being used.
401     /// @param _authorizedAddress the initial authorized address, must not be zero!
402     /// @param _cosigner the initial cosigning address for `_authorizedAddress`, can be equal to `_authorizedAddress`
403     /// @param _recoveryAddress the initial recovery address for the wallet, can be address(0)
404     function init(address _authorizedAddress, uint256 _cosigner, address _recoveryAddress) public onlyOnce {
405         require(_authorizedAddress != _recoveryAddress, "Do not use the recovery address as an authorized address.");
406         require(address(_cosigner) != _recoveryAddress, "Do not use the recovery address as a cosigner.");
407         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
408         require(address(_cosigner) != address(0), "Initial cosigner must not be zero.");
409         
410         recoveryAddress = _recoveryAddress;
411         // set initial authorization value
412         authVersion = AUTH_VERSION_INCREMENTOR;
413         // add initial authorized address
414         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
415         
416         emit Authorized(_authorizedAddress, _cosigner);
417     }
418 
419     /// @notice The fallback function, invoked whenever we receive a transaction that doesn't call any of our
420     ///  named functions. In particular, this method is called when we are the target of a simple send transaction
421     ///  or when someone tries to call a method that we don't implement. We assume that a "correct" invocation of
422     ///  this method only occurs when someone is trying to transfer ether to this wallet, in which case and the
423     ///  `msg.data.length` will be 0.
424     ///
425     ///  NOTE: Some smart contracts send 0 eth as part of a more complex
426     ///  operation (-cough- CryptoKitties -cough-) ; ideally, we'd `require(msg.value > 0)` here, but to work
427     ///  with those kinds of smart contracts, we accept zero sends and just skip logging in that case.
428     function() external payable {
429         require(msg.data.length == 0, "Invalid transaction.");
430         if (msg.value > 0) {
431             emit Received(msg.sender, msg.value);
432         }
433     }
434     
435     /// @notice Configures an authorizable address. Can be used in four ways:
436     ///   - Add a new signer/cosigner pair (cosigner must be non-zero)
437     ///   - Set or change the cosigner for an existing signer (if authorizedAddress != cosigner)
438     ///   - Remove the cosigning requirement for a signer (if authorizedAddress == cosigner)
439     ///   - Remove a signer (if cosigner == address(0))
440     /// @dev Must be called through `invoke()`
441     /// @param _authorizedAddress the address to configure authorization
442     /// @param _cosigner the corresponding cosigning address
443     function setAuthorized(address _authorizedAddress, uint256 _cosigner) external onlyInvoked {
444         // TODO: Allowing a signer to remove itself is actually pretty terrible; it could result in the user
445         //  removing their only available authorized key. Unfortunately, due to how the invocation forwarding
446         //  works, we don't actually _know_ which signer was used to call this method, so there's no easy way
447         //  to prevent this.
448         
449         // TODO: Allowing the backup key to be set as an authorized address bypasses the recovery mechanisms.
450         //  Dapper can prevent this with offchain logic and the cosigner, but it would be nice to have 
451         //  this enforced by the smart contract logic itself.
452         
453         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
454         require(_authorizedAddress != recoveryAddress, "Do not use the recovery address as an authorized address.");
455         require(address(_cosigner) == address(0) || address(_cosigner) != recoveryAddress, "Do not use the recovery address as a cosigner.");
456  
457         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
458         emit Authorized(_authorizedAddress, _cosigner);
459     }
460     
461     /// @notice Performs an emergency recovery operation, removing all existing authorizations and setting
462     ///  a sole new authorized address with optional cosigner. THIS IS A SCORCHED EARTH SOLUTION, and great
463     ///  care should be taken to ensure that this method is never called unless it is a last resort. See the
464     ///  comments above about the proper kinds of addresses to use as the recoveryAddress to ensure this method
465     ///  is not trivially abused.
466     /// @param _authorizedAddress the new and sole authorized address
467     /// @param _cosigner the corresponding cosigner address, can be equal to _authorizedAddress
468     function emergencyRecovery(address _authorizedAddress, uint256 _cosigner) external onlyRecoveryAddress {
469         require(_authorizedAddress != address(0), "Authorized addresses must not be zero.");
470         require(_authorizedAddress != recoveryAddress, "Do not use the recovery address as an authorized address.");
471         require(address(_cosigner) != address(0), "The cosigner must not be zero.");
472 
473         // Incrementing the authVersion number effectively erases the authorizations mapping. See the comments
474         // on the authorizations variable (above) for more information.
475         authVersion += AUTH_VERSION_INCREMENTOR;
476 
477         // Store the new signer/cosigner pair as the only remaining authorized address
478         authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
479         emit EmergencyRecovery(_authorizedAddress, _cosigner);
480     }
481 
482     /// @notice Sets the recovery address, which can be zero (indicating that no recovery is possible)
483     ///  Can be updated by any authorized address. This address should be set with GREAT CARE. See the
484     ///  comments above about the proper kinds of addresses to use as the recoveryAddress to ensure this
485     ///  mechanism is not trivially abused.
486     /// @dev Must be called through `invoke()`
487     /// @param _recoveryAddress the new recovery address
488     function setRecoveryAddress(address _recoveryAddress) external onlyInvoked {
489         require(
490             address(authorizations[authVersion + uint256(_recoveryAddress)]) == address(0),
491             "Do not use an authorized address as the recovery address."
492         );
493  
494         address previous = recoveryAddress;
495         recoveryAddress = _recoveryAddress;
496 
497         emit RecoveryAddressChanged(previous, recoveryAddress);
498     }
499 
500     /// @notice Allows ANY caller to recover gas by way of deleting old authorization keys after
501     ///  a recovery operation. Anyone can call this method to delete the old unused storage and
502     ///  get themselves a bit of gas refund in the bargin.
503     /// @dev keys must be known to caller or else nothing is refunded
504     /// @param _version the version of the mapping which you want to delete (unshifted)
505     /// @param _keys the authorization keys to delete 
506     function recoverGas(uint256 _version, address[] _keys) external {
507         // TODO: should this be 0xffffffffffffffffffffffff ?
508         require(_version > 0 && _version < 0xffffffff, "Invalid version number.");
509         
510         uint256 shiftedVersion = _version << 160;
511 
512         require(shiftedVersion < authVersion, "You can only recover gas from expired authVersions.");
513 
514         for (uint256 i = 0; i < _keys.length; ++i) {
515             delete(authorizations[shiftedVersion + uint256(_keys[i])]);
516         }
517     }
518 
519     /// @notice Should return whether the signature provided is valid for the provided data
520     ///  See https://github.com/ethereum/EIPs/issues/1271
521     /// @dev This function meets the following conditions as per the EIP:
522     ///  MUST return the bytes4 magic value `0x1626ba7e` when function passes.
523     ///  MUST NOT modify state (using `STATICCALL` for solc < 0.5, `view` modifier for solc > 0.5)
524     ///  MUST allow external calls
525     /// @param hash A 32 byte hash of the signed data.  The actual hash that is hashed however is the
526     ///  the following tightly packed arguments: `0x19,0x0,wallet_address,hash`
527     /// @param _signature Signature byte array associated with `_data`
528     /// @return Magic value `0x1626ba7e` upon success, 0 otherwise.
529     function isValidSignature(bytes32 hash, bytes _signature) external view returns (bytes4) {
530         
531         // We 'hash the hash' for the following reasons:
532         // 1. `hash` is not the hash of an Ethereum transaction
533         // 2. signature must target this wallet to avoid replaying the signature for another wallet
534         // with the same key
535         // 3. Gnosis does something similar: 
536         // https://github.com/gnosis/safe-contracts/blob/102e632d051650b7c4b0a822123f449beaf95aed/contracts/GnosisSafe.sol
537         bytes32 operationHash = keccak256(
538             abi.encodePacked(
539             EIP191_PREFIX,
540             EIP191_VERSION_DATA,
541             this,
542             hash));
543 
544         bytes32[2] memory r;
545         bytes32[2] memory s;
546         uint8[2] memory v;
547         address signer;
548         address cosigner;
549 
550         // extract 1 or 2 signatures depending on length
551         if (_signature.length == 65) {
552             (r[0], s[0], v[0]) = _signature.extractSignature(0);
553             signer = ecrecover(operationHash, v[0], r[0], s[0]);
554             cosigner = signer;
555         } else if (_signature.length == 130) {
556             (r[0], s[0], v[0]) = _signature.extractSignature(0);
557             (r[1], s[1], v[1]) = _signature.extractSignature(65);
558             signer = ecrecover(operationHash, v[0], r[0], s[0]);
559             cosigner = ecrecover(operationHash, v[1], r[1], s[1]);
560         } else {
561             return 0;
562         }
563             
564         // check for valid signature
565         if (signer == address(0)) {
566             return 0;
567         }
568 
569         // check for valid signature
570         if (cosigner == address(0)) {
571             return 0;
572         }
573 
574         // check to see if this is an authorized key
575         if (address(authorizations[authVersion + uint256(signer)]) != cosigner) {
576             return 0;
577         }
578 
579         return ERC1271_VALIDSIGNATURE;
580     }
581 
582     /// @notice Query if a contract implements an interface
583     /// @param interfaceID The interface identifier, as specified in ERC-165
584     /// @dev Interface identification is specified in ERC-165. This function
585     ///  uses less than 30,000 gas.
586     /// @return `true` if the contract implements `interfaceID` and
587     ///  `interfaceID` is not 0xffffffff, `false` otherwise
588     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
589         // I am not sure why the linter is complaining about the whitespace
590         return
591             interfaceID == this.supportsInterface.selector || // ERC165
592             interfaceID == ERC721_RECEIVED_FINAL || // ERC721 Final
593             interfaceID == ERC721_RECEIVED_DRAFT || // ERC721 Draft
594             interfaceID == ERC223_ID || // ERC223
595             interfaceID == ERC1271_VALIDSIGNATURE; // ERC1271
596     }
597 
598     /// @notice A version of `invoke()` that has no explicit signatures, and uses msg.sender
599     ///  as both the signer and cosigner. Will only succeed if `msg.sender` is an authorized
600     ///  signer for this wallet, with no cosigner, saving transaction size and gas in that case.
601     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
602     function invoke0(bytes data) external {
603         // The nonce doesn't need to be incremented for transactions that don't include explicit signatures;
604         // the built-in nonce of the native ethereum transaction will protect against replay attacks, and we
605         // can save the gas that would be spent updating the nonce variable
606 
607         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner)
608         require(address(authorizations[authVersion + uint256(msg.sender)]) == msg.sender, "Invalid authorization.");
609 
610         internalInvoke(0, data);
611     }
612 
613     /// @notice A version of `invoke()` that has one explicit signature which is used to derive the authorized
614     ///  address. Uses `msg.sender` as the cosigner.
615     /// @param v the v value for the signature; see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
616     /// @param r the r value for the signature
617     /// @param s the s value for the signature
618     /// @param nonce the nonce value for the signature
619     /// @param authorizedAddress the address of the authorization key; this is used here so that cosigner signatures are interchangeable
620     ///  between this function and `invoke2()`
621     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
622     function invoke1CosignerSends(uint8 v, bytes32 r, bytes32 s, uint256 nonce, address authorizedAddress, bytes data) external {
623         // check signature version
624         require(v == 27 || v == 28, "Invalid signature version.");
625 
626         // calculate hash
627         bytes32 operationHash = keccak256(
628             abi.encodePacked(
629             EIP191_PREFIX,
630             EIP191_VERSION_DATA,
631             this,
632             nonce,
633             authorizedAddress,
634             data));
635  
636         // recover signer
637         address signer = ecrecover(operationHash, v, r, s);
638 
639         // check for valid signature
640         require(signer != address(0), "Invalid signature.");
641 
642         // check nonce
643         require(nonce == nonces[signer], "must use correct nonce");
644 
645         // check signer
646         require(signer == authorizedAddress, "authorized addresses must be equal");
647 
648         // Get cosigner
649         address requiredCosigner = address(authorizations[authVersion + uint256(signer)]);
650         
651         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
652         // if the actual cosigner matches the required cosigner.
653         require(requiredCosigner == signer || requiredCosigner == msg.sender, "Invalid authorization.");
654 
655         // increment nonce to prevent replay attacks
656         nonces[signer] = nonce + 1;
657 
658         // call internal function
659         internalInvoke(operationHash, data);
660     }
661 
662     /// @notice A version of `invoke()` that has one explicit signature which is used to derive the cosigning
663     ///  address. Uses `msg.sender` as the authorized address.
664     /// @param v the v value for the signature; see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
665     /// @param r the r value for the signature
666     /// @param s the s value for the signature
667     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
668     function invoke1SignerSends(uint8 v, bytes32 r, bytes32 s, bytes data) external {
669         // check signature version
670         // `ecrecover` will infact return 0 if given invalid
671         // so perhaps this check is redundant
672         require(v == 27 || v == 28, "Invalid signature version.");
673         
674         uint256 nonce = nonces[msg.sender];
675 
676         // calculate hash
677         bytes32 operationHash = keccak256(
678             abi.encodePacked(
679             EIP191_PREFIX,
680             EIP191_VERSION_DATA,
681             this,
682             nonce,
683             msg.sender,
684             data));
685  
686         // recover cosigner
687         address cosigner = ecrecover(operationHash, v, r, s);
688         
689         // check for valid signature
690         require(cosigner != address(0), "Invalid signature.");
691 
692         // Get required cosigner
693         address requiredCosigner = address(authorizations[authVersion + uint256(msg.sender)]);
694         
695         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
696         // if the actual cosigner matches the required cosigner.
697         require(requiredCosigner == cosigner || requiredCosigner == msg.sender, "Invalid authorization.");
698 
699         // increment nonce to prevent replay attacks
700         nonces[msg.sender] = nonce + 1;
701  
702         internalInvoke(operationHash, data);
703     }
704 
705     /// @notice A version of `invoke()` that has two explicit signatures, the first is used to derive the authorized
706     ///  address, the second to derive the cosigner. The value of `msg.sender` is ignored.
707     /// @param v the v values for the signatures
708     /// @param r the r values for the signatures
709     /// @param s the s values for the signatures
710     /// @param nonce the nonce value for the signature
711     /// @param authorizedAddress the address of the signer; forces the signature to be unique and tied to the signers nonce 
712     /// @param data The data containing the transactions to be invoked; see internalInvoke for details.
713     function invoke2(uint8[2] v, bytes32[2] r, bytes32[2] s, uint256 nonce, address authorizedAddress, bytes data) external {
714         // check signature versions
715         // `ecrecover` will infact return 0 if given invalid
716         // so perhaps these checks are redundant
717         require(v[0] == 27 || v[0] == 28, "invalid signature version v[0]");
718         require(v[1] == 27 || v[1] == 28, "invalid signature version v[1]");
719  
720         bytes32 operationHash = keccak256(
721             abi.encodePacked(
722             EIP191_PREFIX,
723             EIP191_VERSION_DATA,
724             this,
725             nonce,
726             authorizedAddress,
727             data));
728  
729         // recover signer and cosigner
730         address signer = ecrecover(operationHash, v[0], r[0], s[0]);
731         address cosigner = ecrecover(operationHash, v[1], r[1], s[1]);
732 
733         // check for valid signatures
734         require(signer != address(0), "Invalid signature for signer.");
735         require(cosigner != address(0), "Invalid signature for cosigner.");
736 
737         // check signer address
738         require(signer == authorizedAddress, "authorized addresses must be equal");
739 
740         // check nonces
741         require(nonce == nonces[signer], "must use correct nonce for signer");
742 
743         // Get Mapping
744         address requiredCosigner = address(authorizations[authVersion + uint256(signer)]);
745         
746         // The operation should be approved if the signer address has no cosigner (i.e. signer == cosigner) or
747         // if the actual cosigner matches the required cosigner.
748         require(requiredCosigner == signer || requiredCosigner == cosigner, "Invalid authorization.");
749 
750         // increment nonce to prevent replay attacks
751         nonces[signer]++;
752 
753         internalInvoke(operationHash, data);
754     }
755 
756     /// @dev Internal invoke call, 
757     /// @param operationHash The hash of the operation
758     /// @param data The data to send to the `call()` operation
759     ///  The data is prefixed with a global 1 byte revert flag
760     ///  If revert is 1, then any revert from a `call()` operation is rethrown.
761     ///  Otherwise, the error is recorded in the `result` field of the `InvocationSuccess` event.
762     ///  Immediately following the revert byte (no padding), the data format is then is a series
763     ///  of 1 or more tightly packed tuples:
764     ///  `<target(20),amount(32),datalength(32),data>`
765     ///  If `datalength == 0`, the data field must be omitted
766     function internalInvoke(bytes32 operationHash, bytes data) internal {
767         // keep track of the number of operations processed
768         uint256 numOps;
769         // keep track of the result of each operation as a bit
770         uint256 result;
771 
772         // We need to store a reference to this string as a variable so we can use it as an argument to
773         // the revert call from assembly.
774         string memory invalidLengthMessage = "Data field too short";
775         string memory callFailed = "Call failed";
776 
777         // At an absolute minimum, the data field must be at least 85 bytes
778         // <revert(1), to_address(20), value(32), data_length(32)>
779         require(data.length >= 85, invalidLengthMessage);
780 
781         // Forward the call onto its actual target. Note that the target address can be `self` here, which is
782         // actually the required flow for modifying the configuration of the authorized keys and recovery address.
783         //
784         // The assembly code below loads data directly from memory, so the enclosing function must be marked `internal`
785         assembly {
786             // A cursor pointing to the revert flag, starts after the length field of the data object
787             let memPtr := add(data, 32)
788 
789             // The revert flag is the leftmost byte from memPtr
790             let revertFlag := byte(0, mload(memPtr))
791 
792             // A pointer to the end of the data object
793             let endPtr := add(memPtr, mload(data))
794 
795             // Now, memPtr is a cursor pointing to the begining of the current sub-operation
796             memPtr := add(memPtr, 1)
797 
798             // Loop through data, parsing out the various sub-operations
799             for { } lt(memPtr, endPtr) { } {
800                 // Load the length of the call data of the current operation
801                 // 52 = to(20) + value(32)
802                 let len := mload(add(memPtr, 52))
803                 
804                 // Compute a pointer to the end of the current operation
805                 // 84 = to(20) + value(32) + size(32)
806                 let opEnd := add(len, add(memPtr, 84))
807 
808                 // Bail if the current operation's data overruns the end of the enclosing data buffer
809                 // NOTE: Comment out this bit of code and uncomment the next section if you want
810                 // the solidity-coverage tool to work.
811                 // See https://github.com/sc-forks/solidity-coverage/issues/287
812                 if gt(opEnd, endPtr) {
813                     // The computed end of this operation goes past the end of the data buffer. Not good!
814                     revert(add(invalidLengthMessage, 32), mload(invalidLengthMessage))
815                 }
816                 // NOTE: Code that is compatible with solidity-coverage
817                 // switch gt(opEnd, endPtr)
818                 // case 1 {
819                 //     revert(add(invalidLengthMessage, 32), mload(invalidLengthMessage))
820                 // }
821 
822                 // This line of code packs in a lot of functionality!
823                 //  - load the target address from memPtr, the address is only 20-bytes but mload always grabs 32-bytes,
824                 //    so we have to divide the result by 2^96 to effectively right-shift by 12 bytes.
825                 //  - load the value field, stored at memPtr+20
826                 //  - pass a pointer to the call data, stored at memPtr+84
827                 //  - use the previously loaded len field as the size of the call data
828                 //  - make the call (passing all remaining gas to the child call)
829                 //  - check the result (0 == reverted)
830                 if eq(0, call(gas, div(mload(memPtr), exp(2, 96)), mload(add(memPtr, 20)), add(memPtr, 84), len, 0, 0)) {
831                     
832                     switch revertFlag
833                     case 1 {
834                         revert(add(callFailed, 32), mload(callFailed))
835                     }
836                     default {
837                         // mark this operation as failed
838                         // create the appropriate bit, 'or' with previous
839                         result := or(result, exp(2, numOps))
840                     }
841                 }
842 
843                 // increment our counter
844                 numOps := add(numOps, 1)
845              
846                 // Update mem pointer to point to the next sub-operation
847                 memPtr := opEnd
848             }
849         }
850 
851         // emit single event upon success
852         emit InvocationSuccess(operationHash, result, numOps);
853     }
854 }
855 
856 // File: contracts/Wallet/CloneableWallet.sol
857 
858 pragma solidity ^0.4.24;
859 
860 
861 
862 /// @title Cloneable Wallet
863 /// @notice This contract represents a complete but non working wallet.  
864 ///  It is meant to be deployed and serve as the contract that you clone
865 ///  in an EIP 1167 clone setup.
866 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
867 /// @dev Currently, we are seeing approximatley 933 gas overhead for using
868 ///  the clone wallet; use `FullWallet` if you think users will overtake
869 ///  the transaction threshold over the lifetime of the wallet.
870 contract CloneableWallet is CoreWallet {
871 
872     /// @dev An empty constructor that deploys a NON-FUNCTIONAL version
873     ///  of `CoreWallet`
874     constructor () public {
875         initialized = true;
876     }
877 }
878 
879 // File: contracts/Wallet/FullWallet.sol
880 
881 pragma solidity ^0.4.24;
882 
883 
884 
885 /// @title Full Wallet
886 /// @notice This contract represents a working contract, used if you want to deploy
887 ///  the full code and not a clone shim
888 contract FullWallet is CoreWallet {
889 
890     /// @notice A regular constructor that can be used if you wish to deploy a standalone instance of this
891     ///  smart contract wallet. Useful if you anticipate that the lifetime gas savings of being able to call
892     ///  this contract directly will outweigh the cost of deploying a complete copy of this contract.
893     ///  Comment out this constructor and use the one above if you wish to save gas deployment costs by
894     ///  using a clonable instance.
895     /// @param _authorized the initial authorized address
896     /// @param _cosigner the initial cosiging address for the `_authorized` address
897     /// @param _recoveryAddress the initial recovery address for the wallet
898     constructor (address _authorized, uint256 _cosigner, address _recoveryAddress) public {
899         init(_authorized, _cosigner, _recoveryAddress);
900     }
901 }
902 
903 // File: contracts/Ownership/Ownable.sol
904 
905 pragma solidity ^0.4.24;
906 
907 
908 /// @title Ownable is for contracts that can be owned.
909 /// @dev The Ownable contract keeps track of an owner address,
910 ///  and provides basic authorization functions.
911 contract Ownable {
912 
913     /// @dev the owner of the contract
914     address public owner;
915 
916     /// @dev Fired when the owner to renounce ownership, leaving no one
917     ///  as the owner.
918     /// @param previousOwner The previous `owner` of this contract
919     event OwnershipRenounced(address indexed previousOwner);
920     
921     /// @dev Fired when the owner to changes ownership
922     /// @param previousOwner The previous `owner`
923     /// @param newOwner The new `owner`
924     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
925 
926     /// @dev sets the `owner` to `msg.sender`
927     constructor() public {
928         owner = msg.sender;
929     }
930 
931     /// @dev Throws if the `msg.sender` is not the current `owner`
932     modifier onlyOwner() {
933         require(msg.sender == owner, "must be owner");
934         _;
935     }
936 
937     /// @dev Allows the current `owner` to renounce ownership
938     function renounceOwnership() external onlyOwner {
939         emit OwnershipRenounced(owner);
940         owner = address(0);
941     }
942 
943     /// @dev Allows the current `owner` to transfer ownership
944     /// @param _newOwner The new `owner`
945     function transferOwnership(address _newOwner) external onlyOwner {
946         _transferOwnership(_newOwner);
947     }
948 
949     /// @dev Internal version of `transferOwnership`
950     /// @param _newOwner The new `owner`
951     function _transferOwnership(address _newOwner) internal {
952         require(_newOwner != address(0), "cannot renounce ownership");
953         emit OwnershipTransferred(owner, _newOwner);
954         owner = _newOwner;
955     }
956 }
957 
958 // File: contracts/Ownership/HasNoEther.sol
959 
960 pragma solidity ^0.4.24;
961 
962 
963 
964 /// @title HasNoEther is for contracts that should not own Ether
965 contract HasNoEther is Ownable {
966 
967     /// @dev This contructor rejects incoming Ether
968     constructor() public payable {
969         require(msg.value == 0, "must not send Ether");
970     }
971 
972     /// @dev Disallows direct send by default function not being `payable`
973     function() external {}
974 
975     /// @dev Transfers all Ether held by this contract to the owner.
976     function reclaimEther() external onlyOwner {
977         owner.transfer(address(this).balance);
978     }
979 }
980 
981 // File: contracts/WalletFactory/CloneFactory.sol
982 
983 pragma solidity ^0.4.24;
984 
985 
986 /// @title CloneFactory - a contract that creates clones
987 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
988 /// @dev See https://github.com/optionality/clone-factory/blob/master/contracts/CloneFactory.sol
989 contract CloneFactory {
990     event CloneCreated(address indexed target, address clone);
991 
992     function createClone(address target) internal returns (address result) {
993         bytes20 targetBytes = bytes20(target);
994         assembly {
995             let clone := mload(0x40)
996             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
997             mstore(add(clone, 0x14), targetBytes)
998             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
999             result := create(0, clone, 0x37)
1000         }
1001     }
1002 }
1003 
1004 // File: contracts/WalletFactory/WalletFactory.sol
1005 
1006 pragma solidity ^0.4.24;
1007 
1008 
1009 
1010 
1011 
1012 /// @title WalletFactory
1013 /// @dev A contract for creating wallets. 
1014 contract WalletFactory is HasNoEther, CloneFactory {
1015     /// @dev Pointer to a pre-deployed instance of the Wallet contract. This
1016     ///  deployment contains all the Wallet code.
1017     address public cloneWalletAddress;
1018 
1019     /// @notice Emitted whenever a wallet is created
1020     /// @param wallet The address of the wallet created
1021     /// @param authorizedAddress The initial authorized address of the wallet
1022     /// @param full `true` if the deployed wallet was a full, self
1023     ///  contained wallet; `false` if the wallet is a clone wallet
1024     event WalletCreated(address wallet, address authorizedAddress, bool full);
1025 
1026     constructor(address _cloneWalletAddress) public {
1027         cloneWalletAddress = _cloneWalletAddress;
1028     }
1029 
1030     /// @notice Sets the cloneable address in case you want to change it after
1031     /// @dev No checks are done to see if this is a valid cloneable wallet
1032     /// @param _newCloneWalletAddress the new clone source
1033     function setCloneWalletAddress(address _newCloneWalletAddress) public onlyOwner {
1034         cloneWalletAddress = _newCloneWalletAddress;
1035     }
1036 
1037     /// @notice Used to deploy a wallet clone
1038     /// @dev Reasonably cheap to run (~100K gas)
1039     /// @param _recoveryAddress the initial recovery address for the wallet
1040     /// @param _authorizedAddress an initial authorized address for the wallet
1041     /// @param _cosigner the cosigning address for the initial `_authorizedAddress`
1042     function deployCloneWallet(
1043         address _recoveryAddress,
1044         address _authorizedAddress,
1045         uint256 _cosigner
1046     )
1047         public 
1048     {
1049         address clone = createClone(cloneWalletAddress);
1050         CloneableWallet(clone).init(_authorizedAddress, _cosigner, _recoveryAddress);
1051         emit WalletCreated(clone, _authorizedAddress, false);
1052     }
1053 
1054     /// @notice Used to deploy a full wallet
1055     /// @dev This is potentially very gas intensive!
1056     /// @param _recoveryAddress The initial recovery address for the wallet
1057     /// @param _authorizedAddress An initial authorized address for the wallet
1058     /// @param _cosigner The cosigning address for the initial `_authorizedAddress`
1059     function deployFullWallet(
1060         address _recoveryAddress,
1061         address _authorizedAddress,
1062         uint256 _cosigner
1063     )
1064         public 
1065     {
1066         address full = new FullWallet(_authorizedAddress, _cosigner, _recoveryAddress);
1067         emit WalletCreated(full, _authorizedAddress, true);
1068     }
1069 }