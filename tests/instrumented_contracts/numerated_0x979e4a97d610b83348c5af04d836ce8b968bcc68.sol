1 // Written by Jesse Busman (jesse@jesbus.com) in january 2018 and june 2018 and december 2018 and january 2019 and february 2019
2 // This is the back end of https://etherprime.jesbus.com/
3 
4 pragma solidity 0.5.4;
5 
6 
7 // ----------------------------------------------------------------------------
8 // ERC Token Standard #20 Interface
9 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
10 // ----------------------------------------------------------------------------
11 interface ERC20
12 {
13     function totalSupply() external view returns (uint);
14     function balanceOf(address tokenOwner) external view returns (uint balance);
15     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
16     function transfer(address to, uint tokens) external returns (bool success);
17     function approve(address spender, uint tokens) external returns (bool success);
18     function transferFrom(address from, address to, uint tokens) external returns (bool success);
19     
20     event Transfer(address indexed from, address indexed to, uint tokens);
21     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
22     
23     function name() external pure returns (string memory);
24     function symbol() external pure returns (string memory);
25     function decimals() external pure returns (uint8);
26 }
27 
28 
29 interface ERC165
30 {
31     /// @notice Query if a contract implements an interface
32     /// @param interfaceID The interface identifier, as specified in ERC-165
33     /// @dev Interface identification is specified in ERC-165. This function
34     ///  uses less than 30,000 gas.
35     /// @return `true` if the contract implements `interfaceID` and
36     ///  `interfaceID` is not 0xffffffff, `false` otherwise
37     function supportsInterface(bytes4 interfaceID) external pure returns (bool);
38 }
39 
40 
41 
42 /// @title ERC-721 Non-Fungible Token Standard
43 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
44 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
45 interface ERC721 /*is ERC165*/
46 {
47     /// @dev This emits when ownership of any NFT changes by any mechanism.
48     ///  This event emits when NFTs are created (`from` == 0) and destroyed
49     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
50     ///  may be created and assigned without emitting Transfer. At the time of
51     ///  any transfer, the approved address for that NFT (if any) is reset to none.
52     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
53     
54     /// @dev This emits when the approved address for an NFT is changed or
55     ///  reaffirmed. The zero address indicates there is no approved address.
56     ///  When a Transfer event emits, this also indicates that the approved
57     ///  address for that NFT (if any) is reset to none.
58     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
59     
60     /// @dev This emits when an operator is enabled or disabled for an owner.
61     ///  The operator can manage all NFTs of the owner.
62     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
63     
64     /// @notice Count all NFTs assigned to an owner
65     /// @dev NFTs assigned to the zero address are considered invalid, and this
66     ///  function throws for queries about the zero address.
67     /// @param _owner An address for whom to query the balance
68     /// @return The number of NFTs owned by `_owner`, possibly zero
69     function balanceOf(address _owner) external view returns (uint256);
70     
71     /// @notice Find the owner of an NFT
72     /// @dev NFTs assigned to zero address are considered invalid, and queries
73     ///  about them do throw.
74     /// @param _tokenId The identifier for an NFT
75     /// @return The address of the owner of the NFT
76     function ownerOf(uint256 _tokenId) external view returns (address);
77     
78     /// @notice Transfers the ownership of an NFT from one address to another address
79     /// @dev Throws unless `msg.sender` is the current owner, an authorized
80     ///  operator, or the approved address for this NFT. Throws if `_from` is
81     ///  not the current owner. Throws if `_to` is the zero address. Throws if
82     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
83     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
84     ///  `onERC721Received` on `_to` and throws if the return value is not
85     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
86     /// @param _from The current owner of the NFT
87     /// @param _to The new owner
88     /// @param _tokenId The NFT to transfer
89     /// @param data Additional data with no specified format, sent in call to `_to`
90     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external returns (bool);
91     
92     /// @notice Transfers the ownership of an NFT from one address to another address
93     /// @dev This works identically to the other function with an extra data parameter,
94     ///  except this function just sets data to ""
95     /// @param _from The current owner of the NFT
96     /// @param _to The new owner
97     /// @param _tokenId The NFT to transfer
98     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external returns (bool);
99     
100     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
101     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
102     ///  THEY MAY BE PERMANENTLY LOST
103     /// @dev Throws unless `msg.sender` is the current owner, an authorized
104     ///  operator, or the approved address for this NFT. Throws if `_from` is
105     ///  not the current owner. Throws if `_to` is the zero address. Throws if
106     ///  `_tokenId` is not a valid NFT.
107     /// @param _from The current owner of the NFT
108     /// @param _to The new owner
109     /// @param _tokenId The NFT to transfer
110     function transferFrom(address _from, address _to, uint256 _tokenId) external returns (bool);
111     
112     /// @notice Set or reaffirm the approved address for an NFT
113     /// @dev The zero address indicates there is no approved address.
114     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
115     ///  operator of the current owner.
116     /// @param _approved The new approved NFT controller
117     /// @param _tokenId The NFT to approve
118     function approve(address _approved, uint256 _tokenId) external returns (bool);
119     
120     /// @notice Enable or disable approval for a third party ("operator") to manage
121     ///  all of `msg.sender`'s assets.
122     /// @dev Emits the ApprovalForAll event. The contract MUST allow
123     ///  multiple operators per owner.
124     /// @param _operator Address to add to the set of authorized operators.
125     /// @param _approved True if the operator is approved, false to revoke approval
126     function setApprovalForAll(address _operator, bool _approved) external returns (bool);
127     
128     /// @notice Get the approved address for a single NFT
129     /// @dev Throws if `_tokenId` is not a valid NFT
130     /// @param _tokenId The NFT to find the approved address for
131     /// @return The approved address for this NFT, or the zero address if there is none
132     function getApproved(uint256 _tokenId) external view returns (address);
133     
134     /// @notice Query if an address is an authorized operator for another address
135     /// @param _owner The address that owns the NFTs
136     /// @param _operator The address that acts on behalf of the owner
137     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
138     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
139 }
140 
141 interface ERC721Enumerable
142 {
143     function totalSupply() external view returns (uint256);
144     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId);
145     function tokenByIndex(uint256 _index) external view returns (uint256);
146 }
147 
148 
149 /**
150  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
151  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
152  */
153 interface ERC721Metadata
154 {
155     function name() external pure returns (string memory _name);
156     function symbol() external pure returns (string memory _symbol);
157     function tokenURI(uint256 _tokenId) external view returns (string memory _uri);
158 }
159 
160 
161 interface ERC721TokenReceiver
162 {
163     /// @notice Handle the receipt of an NFT
164     /// @dev The ERC721 smart contract calls this function on the
165     /// recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
166     /// of other than the magic value MUST result in the transaction being reverted.
167     /// @notice The contract address is always the message sender.
168     /// @param _operator The address which called `safeTransferFrom` function
169     /// @param _from The address which previously owned the token
170     /// @param _tokenId The NFT identifier which is being transferred
171     /// @param _data Additional data with no specified format
172     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
173     /// unless throwing
174     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
175 }
176 
177 
178 
179 
180 interface ERC223
181 {
182     function balanceOf(address who) external view returns (uint256);
183     
184     function name() external pure returns (string memory _name);
185     function symbol() external pure returns (string memory _symbol);
186     function decimals() external pure returns (uint8 _decimals);
187     function totalSupply() external view returns (uint256 _supply);
188     
189     function transfer(address to, uint value) external returns (bool ok);
190     function transfer(address to, uint value, bytes calldata data) external returns (bool ok);
191 
192     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
193 }
194 
195 
196 
197 interface ERC223Receiver
198 {
199     function tokenFallback(address _from, uint256 _value, bytes calldata _data) external;
200 }
201 
202 
203 
204 interface ERC777TokensRecipient
205 {
206     function tokensReceived(
207         address operator,
208         address from,
209         address to,
210         uint256 amount,
211         bytes calldata data,
212         bytes calldata operatorData
213     ) external;
214 }
215 
216 
217 interface ERC777TokensSender
218 {
219     function tokensToSend(
220         address operator,
221         address from,
222         address to,
223         uint256 amount,
224         bytes calldata data,
225         bytes calldata operatorData
226     ) external;
227 }
228 
229 
230 
231 
232 contract EtherPrime is ERC20, ERC721, ERC721Enumerable, ERC721Metadata, ERC165, ERC223
233 {
234     ////////////////////////////////////////////////////////////
235     ////////////////////////////////////////////////////////////
236     ////////////                                    ////////////
237     ////////////          State variables           ////////////
238     ////////////                                    ////////////
239     ////////////////////////////////////////////////////////////
240     ////////////////////////////////////////////////////////////
241     
242     // Array of definite prime numbers
243     uint256[] public definitePrimes;
244     
245     // Array of probable primes
246     uint256[] public probablePrimes;
247     
248     // Allowances
249     mapping(uint256 => address) public primeToAllowedAddress;
250     
251     // Allowed operators
252     mapping(address => mapping(address => bool)) private ownerToOperators;
253     
254     // Ownership of primes
255     mapping(address => uint256[]) private ownerToPrimes;
256     
257     // Number data contains:
258     // - Index of prime in ownerToPrimes array
259     // - Index of prime in definitePrimes or probablePrimes array
260     // - NumberType
261     // - Owner of prime
262     mapping(uint256 => bytes32) private numberToNumberdata;
263     
264     // Store known non-2 divisors of non-primes
265     mapping(uint256 => uint256) private numberToNonTwoDivisor;
266     
267     // List of all participants
268     address[] public participants;
269     mapping(address => uint256) private addressToParticipantsArrayIndex;
270     
271     // Statistics
272     mapping(address => uint256) public addressToGasSpent;
273     mapping(address => uint256) public addressToEtherSpent;
274     mapping(address => uint256) public addressToProbablePrimesClaimed;
275     mapping(address => uint256) public addressToProbablePrimesDisprovenBy;
276     mapping(address => uint256) public addressToProbablePrimesDisprovenFrom;
277 
278     // Prime calculator state
279     uint256 public numberBeingTested;
280     uint256 public divisorIndexBeingTested;
281     
282     // Prime trading
283     mapping(address => uint256) public addressToEtherBalance;
284     mapping(uint256 => uint256) public primeToSellOrderPrice;
285     mapping(uint256 => BuyOrder[]) private primeToBuyOrders;
286 
287     
288     
289     
290     
291     ////////////////////////////////////////////////////////////
292     ////////////////////////////////////////////////////////////
293     ////////////                                    ////////////
294     ////////////               Events               ////////////
295     ////////////                                    ////////////
296     ////////////////////////////////////////////////////////////
297     ////////////////////////////////////////////////////////////
298     
299     // Prime generation
300     event DefinitePrimeDiscovered(uint256 indexed prime, address indexed discoverer, uint256 indexed definitePrimesArrayIndex);
301     event ProbablePrimeDiscovered(uint256 indexed prime, address indexed discoverer, uint256 indexed probablePrimesArrayIndex);
302     event ProbablePrimeDisproven(uint256 indexed prime, uint256 divisor, address indexed owner, address indexed disprover, uint256 probablePrimesArrayIndex);
303     
304     // Token
305     event Transfer(address indexed from, address indexed to, uint256 prime);
306     event Approval(address indexed owner, address indexed spender, uint256 prime);
307     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
308     
309     // Trading
310     event BuyOrderCreated(address indexed buyer, uint256 indexed prime, uint256 indexed buyOrdersArrayIndex, uint256 bid);
311     event BuyOrderDestroyed(address indexed buyer, uint256 indexed prime, uint256 indexed buyOrdersArrayIndex);
312     event SellPriceSet(address indexed seller, uint256 indexed prime, uint256 price);
313     event PrimeTraded(address indexed seller, address indexed buyer, uint256 indexed prime, uint256 buyOrdersArrayIndex, uint256 price);
314     event EtherDeposited(address indexed depositer, uint256 amount);
315     event EtherWithdrawn(address indexed withdrawer, uint256 amount);
316     
317     
318     
319     
320     
321     
322     
323     
324     ////////////////////////////////////////////////////////////
325     ////////////////////////////////////////////////////////////
326     ////////////                                    ////////////
327     ////////////  Internal functions that write to  ////////////
328     ////////////          state variables           ////////////
329     ////////////                                    ////////////
330     ////////////////////////////////////////////////////////////
331     ////////////////////////////////////////////////////////////
332     
333     function _addParticipant(address _newParticipant) private
334     {
335         // Add the participant to the list, but only if they are not 0x0 and they are not already in the list.
336         if (_newParticipant != address(0x0) && addressToParticipantsArrayIndex[_newParticipant] == 0)
337         {
338             addressToParticipantsArrayIndex[_newParticipant] = participants.length;
339             participants.push(_newParticipant);
340         }
341     }
342     
343     ////////////////////////////////////
344     //////// Internal functions to change ownership of a prime
345     
346     function _removePrimeFromOwnerPrimesArray(uint256 _prime) private
347     {
348         bytes32 numberdata = numberToNumberdata[_prime];
349         uint256[] storage ownerPrimes = ownerToPrimes[numberdataToOwner(numberdata)];
350         uint256 primeIndex = numberdataToOwnerPrimesIndex(numberdata);
351         
352         // Move the last one backwards into the freed slot
353         uint256 otherPrimeBeingMoved = ownerPrimes[ownerPrimes.length-1];
354         ownerPrimes[primeIndex] = otherPrimeBeingMoved;
355         _numberdataSetOwnerPrimesIndex(otherPrimeBeingMoved, uint40(primeIndex));
356         
357         // Refund gas by setting the now unused array slot to 0
358         // Advantage: Current transaction gets a gas refund of 15000
359         // Disadvantage: Next transaction that gives a prime to this owner will cost 15000 more gas
360         ownerPrimes[ownerPrimes.length-1] = 0; // Refund some gas
361         
362         // Decrease the length of the array
363         ownerPrimes.length--;
364     }
365     
366     function _setOwner(uint256 _prime, address _newOwner) private
367     {
368         _setOwner(_prime, _newOwner, "", address(0x0), "");
369     }
370     
371     function _setOwner(uint256 _prime, address _newOwner, bytes memory _data, address _operator, bytes memory _operatorData) private
372     {
373         // getOwner does not throw, so previousOwner can be 0x0
374         address previousOwner = getOwner(_prime);
375         
376         if (_operator == address(0x0))
377         {
378             _operator = previousOwner;
379         }
380         
381         // Shortcut in case we don't need to do anything
382         if (previousOwner == _newOwner)
383         {
384             return;
385         }
386         
387         // Delete _prime from ownerToPrimes[previousOwner]
388         if (previousOwner != address(0x0))
389         {
390             _removePrimeFromOwnerPrimesArray(_prime);
391         }
392         
393         // Store the new ownerPrimes array index and the new owner in the numberdata
394         _numberdataSetOwnerAndOwnerPrimesIndex(_prime, _newOwner, uint40(ownerToPrimes[_newOwner].length));
395         
396         // Add _prime to ownerToPrimes[_newOwner]
397         ownerToPrimes[_newOwner].push(_prime);
398         
399         // Delete any existing allowance
400         if (primeToAllowedAddress[_prime] != address(0x0))
401         {
402             primeToAllowedAddress[_prime] = address(0x0);
403         }
404         
405         // Delete any existing sell order
406         if (primeToSellOrderPrice[_prime] != 0)
407         {
408             primeToSellOrderPrice[_prime] = 0;
409             emit SellPriceSet(_newOwner, _prime, 0);
410         }
411         
412         // Add the new owner to the list of EtherPrime participants
413         _addParticipant(_newOwner);
414         
415         // If the new owner is a contract, try to notify them of the received token.
416         if (isContract(_newOwner))
417         {
418             bool success;
419             bytes32 returnValue;
420             
421             // Try to call onERC721Received (as per ERC721)
422             
423             (success, returnValue) = _tryCall(_newOwner, abi.encodeWithSelector(ERC721TokenReceiver(_newOwner).onERC721Received.selector, _operator, previousOwner, _prime, _data));
424             
425             if (!success || returnValue != bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")))
426             {
427                 // If ERC721::onERC721Received failed, try to call tokenFallback (as per ERC223)
428                 
429                 (success, returnValue) = _tryCall(_newOwner, abi.encodeWithSelector(ERC223Receiver(_newOwner).tokenFallback.selector, previousOwner, _prime, 0x0));
430                 
431                 if (!success)
432                 {
433                     // If ERC223::tokenFallback failed, try to call tokensReceived (as per ERC777)
434                     
435                     (success, returnValue) = _tryCall(_newOwner, abi.encodeWithSelector(ERC777TokensRecipient(_newOwner).tokensReceived.selector, _operator, previousOwner, _newOwner, _prime, _data, _operatorData));
436                     
437                     if (!success)
438                     {
439                         // If all token fallback calls failed, give up and just give them their token.
440                         return;
441                     }
442                 }
443             }
444         }
445         
446         emit Transfer(previousOwner, _newOwner, _prime);
447     }
448     
449     function _createPrime(uint256 _prime, address _owner, bool _isDefinitePrime) private
450     {
451         // Create the prime
452         _numberdataSetAllPrimesIndexAndNumberType(
453             _prime,
454             uint48(_isDefinitePrime ? definitePrimes.length : probablePrimes.length),
455             _isDefinitePrime ? NumberType.DEFINITE_PRIME : NumberType.PROBABLE_PRIME
456         );
457         if (_isDefinitePrime)
458         {
459             emit DefinitePrimeDiscovered(_prime, msg.sender, definitePrimes.length);
460             definitePrimes.push(_prime);
461         }
462         else
463         {
464             emit ProbablePrimeDiscovered(_prime, msg.sender, probablePrimes.length);
465             probablePrimes.push(_prime);
466         }
467         
468         // Give it to its new owner
469         _setOwner(_prime, _owner);
470     }
471     
472     
473     
474     
475     
476     
477     ////////////////////////////////////////////////////////////
478     ////////////////////////////////////////////////////////////
479     ////////////                                    ////////////
480     ////////////    Bitwise stuff on numberdata     ////////////
481     ////////////                                    ////////////
482     ////////////////////////////////////////////////////////////
483     ////////////////////////////////////////////////////////////
484     
485     enum NumberType
486     {
487         NOT_PRIME_IF_PASSED,
488         NOT_PRIME,
489         PROBABLE_PRIME,
490         DEFINITE_PRIME
491     }
492     
493     // Number data format:
494     
495     // MSB                                                                                                                                           LSB
496     // [  40 bits for owner primes array index  ] [  48 bits for all primes array index  ] [  8 bits for number type  ] [  160 bits for owner address  ]
497     //   ^                                            ^                                               ^                            ^
498     //   ^ the index in ownerToPrimes array           ^ index in definitePrimes or probablePrimes     ^ a NumberType value         ^ owner of the number
499     
500     uint256 private constant NUMBERDATA_OWNER_PRIME_INDEX_SIZE = 40;
501     uint256 private constant NUMBERDATA_OWNER_PRIME_INDEX_SHIFT = NUMBERDATA_ALL_PRIME_INDEX_SHIFT + NUMBERDATA_ALL_PRIME_INDEX_SIZE;
502     bytes32 private constant NUMBERDATA_OWNER_PRIME_INDEX_MASK = bytes32(uint256(~uint40(0)) << NUMBERDATA_OWNER_PRIME_INDEX_SHIFT);
503     
504     uint256 private constant NUMBERDATA_ALL_PRIME_INDEX_SIZE = 48;
505     uint256 private constant NUMBERDATA_ALL_PRIME_INDEX_SHIFT = NUMBERDATA_NUMBER_TYPE_SHIFT + NUMBERDATA_NUMBER_TYPE_SIZE;
506     bytes32 private constant NUMBERDATA_ALL_PRIME_INDEX_MASK = bytes32(uint256(~uint48(0)) << NUMBERDATA_ALL_PRIME_INDEX_SHIFT);
507     
508     uint256 private constant NUMBERDATA_NUMBER_TYPE_SIZE = 8;
509     uint256 private constant NUMBERDATA_NUMBER_TYPE_SHIFT = NUMBERDATA_OWNER_ADDRESS_SHIFT + NUMBERDATA_OWNER_ADDRESS_SIZE;
510     bytes32 private constant NUMBERDATA_NUMBER_TYPE_MASK = bytes32(uint256(~uint8(0)) << NUMBERDATA_NUMBER_TYPE_SHIFT);
511     
512     uint256 private constant NUMBERDATA_OWNER_ADDRESS_SIZE = 160;
513     uint256 private constant NUMBERDATA_OWNER_ADDRESS_SHIFT = 0;
514     bytes32 private constant NUMBERDATA_OWNER_ADDRESS_MASK = bytes32(uint256(~uint160(0)) << NUMBERDATA_OWNER_ADDRESS_SHIFT);
515     
516     function numberdataToOwnerPrimesIndex(bytes32 _numberdata) private pure returns (uint40)
517     {
518         return uint40(uint256(_numberdata & NUMBERDATA_OWNER_PRIME_INDEX_MASK) >> NUMBERDATA_OWNER_PRIME_INDEX_SHIFT);
519     }
520     
521     function numberdataToAllPrimesIndex(bytes32 _numberdata) private pure returns (uint48)
522     {
523         return uint48(uint256(_numberdata & NUMBERDATA_ALL_PRIME_INDEX_MASK) >> NUMBERDATA_ALL_PRIME_INDEX_SHIFT);
524     }
525     
526     function numberdataToNumberType(bytes32 _numberdata) private pure returns (NumberType)
527     {
528         return NumberType(uint256(_numberdata & NUMBERDATA_NUMBER_TYPE_MASK) >> NUMBERDATA_NUMBER_TYPE_SHIFT);
529     }
530     
531     function numberdataToOwner(bytes32 _numberdata) private pure returns (address)
532     {
533         return address(uint160(uint256(_numberdata & NUMBERDATA_OWNER_ADDRESS_MASK) >> NUMBERDATA_OWNER_ADDRESS_SHIFT));
534     }
535     
536     function ownerPrimesIndex_allPrimesIndex_numberType_owner__toNumberdata(uint40 _ownerPrimesIndex, uint48 _allPrimesIndex, NumberType _numberType, address _owner) private pure returns (bytes32)
537     {
538         return
539             bytes32(
540                 (uint256(_ownerPrimesIndex) << NUMBERDATA_OWNER_PRIME_INDEX_SHIFT) |
541                 (uint256(_allPrimesIndex) << NUMBERDATA_ALL_PRIME_INDEX_SHIFT) |
542                 (uint256(uint8(_numberType)) << NUMBERDATA_NUMBER_TYPE_SHIFT) |
543                 (uint256(uint160(_owner)) << NUMBERDATA_OWNER_ADDRESS_SHIFT)
544             );
545     }
546     
547     function _numberdataSetOwnerPrimesIndex(uint256 _number, uint40 _ownerPrimesIndex) private
548     {
549         bytes32 numberdata = numberToNumberdata[_number];
550         numberdata &= ~NUMBERDATA_OWNER_PRIME_INDEX_MASK;
551         numberdata |= bytes32(uint256(_ownerPrimesIndex)) << NUMBERDATA_OWNER_PRIME_INDEX_SHIFT;
552         numberToNumberdata[_number] = numberdata;
553     }
554     
555     function _numberdataSetAllPrimesIndex(uint256 _number, uint48 _allPrimesIndex) private
556     {
557         bytes32 numberdata = numberToNumberdata[_number];
558         numberdata &= ~NUMBERDATA_ALL_PRIME_INDEX_MASK;
559         numberdata |= bytes32(uint256(_allPrimesIndex)) << NUMBERDATA_ALL_PRIME_INDEX_SHIFT;
560         numberToNumberdata[_number] = numberdata;
561     }
562     
563     function _numberdataSetNumberType(uint256 _number, NumberType _numberType) private
564     {
565         bytes32 numberdata = numberToNumberdata[_number];
566         numberdata &= ~NUMBERDATA_NUMBER_TYPE_MASK;
567         numberdata |= bytes32(uint256(uint8(_numberType))) << NUMBERDATA_NUMBER_TYPE_SHIFT;
568         numberToNumberdata[_number] = numberdata;
569     }
570     
571     /*function _numberdataSetOwner(uint256 _number, address _owner) private
572     {
573         bytes32 numberdata = numberToNumberdata[_number];
574         numberdata &= ~NUMBERDATA_OWNER_ADDRESS_MASK;
575         numberdata |= bytes32(uint256(uint160(_owner))) << NUMBERDATA_OWNER_ADDRESS_SHIFT;
576         numberToNumberdata[_number] = numberdata;
577     }*/
578     
579     function _numberdataSetOwnerAndOwnerPrimesIndex(uint256 _number, address _owner, uint40 _ownerPrimesIndex) private
580     {
581         bytes32 numberdata = numberToNumberdata[_number];
582         
583         numberdata &= ~NUMBERDATA_OWNER_ADDRESS_MASK;
584         numberdata |= bytes32(uint256(uint160(_owner))) << NUMBERDATA_OWNER_ADDRESS_SHIFT;
585         
586         numberdata &= ~NUMBERDATA_OWNER_PRIME_INDEX_MASK;
587         numberdata |= bytes32(uint256(_ownerPrimesIndex)) << NUMBERDATA_OWNER_PRIME_INDEX_SHIFT;
588         
589         numberToNumberdata[_number] = bytes32(numberdata);
590     }
591 
592     function _numberdataSetAllPrimesIndexAndNumberType(uint256 _number, uint48 _allPrimesIndex, NumberType _numberType) private
593     {
594         bytes32 numberdata = numberToNumberdata[_number];
595         
596         numberdata &= ~NUMBERDATA_ALL_PRIME_INDEX_MASK;
597         numberdata |= bytes32(uint256(_allPrimesIndex)) << NUMBERDATA_ALL_PRIME_INDEX_SHIFT;
598         
599         numberdata &= ~NUMBERDATA_NUMBER_TYPE_MASK;
600         numberdata |= bytes32(uint256(uint8(_numberType))) << NUMBERDATA_NUMBER_TYPE_SHIFT;
601         
602         numberToNumberdata[_number] = bytes32(numberdata);
603     }
604     
605 
606     
607     
608 
609     
610     
611     
612     
613     
614     
615     
616     
617     ////////////////////////////////////////////////////////////
618     ////////////////////////////////////////////////////////////
619     ////////////                                    ////////////
620     ////////////       Utility functions for        ////////////
621     ////////////       ERC721 implementation        ////////////
622     ////////////                                    ////////////
623     ////////////////////////////////////////////////////////////
624     ////////////////////////////////////////////////////////////
625     
626     function isValidNFT(uint256 _prime) private view returns (bool)
627     {
628         NumberType numberType = numberdataToNumberType(numberToNumberdata[_prime]);
629         return numberType == NumberType.PROBABLE_PRIME || numberType == NumberType.DEFINITE_PRIME;
630     }
631     
632     function isApprovedFor(address _operator, uint256 _prime) private view returns (bool)
633     {
634         address owner = getOwner(_prime);
635         
636         return
637             (owner == _operator) ||
638             (primeToAllowedAddress[_prime] == _operator) ||
639             (ownerToOperators[owner][_operator] == true);
640     }
641     
642     function isContract(address _addr) private view returns (bool)
643     {
644         uint256 addrCodesize;
645         assembly { addrCodesize := extcodesize(_addr) }
646         return addrCodesize != 0;
647     }
648     
649     function _tryCall(address _contract, bytes memory _selectorAndArguments) private returns (bool _success, bytes32 _returnData)
650     {
651         bytes32[1] memory returnDataArray;
652         uint256 dataLengthBytes = _selectorAndArguments.length;
653         
654         assembly
655         {
656             // call(gas, address, value, arg_ptr, arg_size, return_ptr, return_max_size)
657             _success := call(gas(), _contract, 0, _selectorAndArguments, dataLengthBytes, returnDataArray, 32)
658         }
659         
660         _returnData = returnDataArray[0];
661     }
662     
663     // Does not throw if prime does not exist or has no owner
664     function getOwner(uint256 _prime) public view returns (address)
665     {
666         return numberdataToOwner(numberToNumberdata[_prime]);
667     }
668     
669     
670     
671     
672     
673     
674     
675     
676     
677     ////////////////////////////////////////////////////////////
678     ////////////////////////////////////////////////////////////
679     ////////////                                    ////////////
680     ////////////        Token implementation        ////////////
681     ////////////                                    ////////////
682     ////////////////////////////////////////////////////////////
683     ////////////////////////////////////////////////////////////
684     
685     function name() external pure returns (string memory)
686     {
687         return "Prime number";
688     }
689     
690     function symbol() external pure returns (string memory)
691     {
692         return "PRIME";
693     }
694     
695     function decimals() external pure returns (uint8)
696     {
697         return 0;
698     }
699     
700     function tokenURI(uint256 _tokenId) external view returns (string memory _uri)
701     {
702         require(isValidNFT(_tokenId));
703         
704         _uri = "https://etherprime.jesbus.com/#search:";
705         
706         uint256 baseURIlen = bytes(_uri).length;
707 
708         // Count the amount of digits required to represent the prime number
709         uint256 digits = 0;
710         uint256 _currentNum = _tokenId;
711         while (_currentNum != 0)
712         {
713             _currentNum /= 10;
714             digits++;
715         }
716         
717         uint256 divisor = 10 ** (digits-1);
718         _currentNum = _tokenId;
719         
720         for (uint256 i=0; i<digits; i++)
721         {
722             uint8 digit = 0x30 + uint8(_currentNum / divisor);
723             
724             assembly { mstore8(add(add(_uri, 0x20), add(baseURIlen, i)), digit) }
725             
726             _currentNum %= divisor;
727             divisor /= 10;
728         }
729         
730         assembly { mstore(_uri, add(baseURIlen, digits)) }
731     }
732     
733     function totalSupply() external view returns (uint256)
734     {
735         return definitePrimes.length + probablePrimes.length;
736     }
737     
738     function balanceOf(address _owner) external view returns (uint256)
739     {
740         // According to ERC721 we should throw on queries about the 0x0 address
741         require(_owner != address(0x0), "balanceOf error: owner may not be 0x0");
742         
743         return ownerToPrimes[_owner].length;
744     }
745     
746     function addressPrimeCount(address _owner) external view returns (uint256)
747     {
748         return ownerToPrimes[_owner].length;
749     }
750     
751     function allowance(address _owner, address _spender) external view returns (uint256)
752     {
753         uint256 total = 0;
754         uint256[] storage primes = ownerToPrimes[_owner];
755         uint256 primesLength = primes.length;
756         for (uint256 i=0; i<primesLength; i++)
757         {
758             uint256 prime = primes[i];
759             if (primeToAllowedAddress[prime] == _spender)
760             {
761                 total += prime;
762             }
763         }
764         return total;
765     }
766     
767     // Throws if prime has no owner or does not exist
768     function ownerOf(uint256 _prime) external view returns (address)
769     {
770         address owner = getOwner(_prime);
771         require(owner != address(0x0), "ownerOf error: owner is set to 0x0");
772         return owner;
773     }
774     
775     function safeTransferFrom(address _from, address _to, uint256 _prime, bytes memory _data) public returns (bool)
776     {
777         require(getOwner(_prime) == _from, "safeTransferFrom error: from address does not own that prime");
778         require(isApprovedFor(msg.sender, _prime), "safeTransferFrom error: you do not have approval from the owner of that prime");
779         _setOwner(_prime, _to, _data, msg.sender, "");
780         return true;
781     }
782     
783     function safeTransferFrom(address _from, address _to, uint256 _prime) external returns (bool)
784     {
785         return safeTransferFrom(_from, _to, _prime, "");
786     }
787     
788     function transferFrom(address _from, address _to, uint256 _prime) external returns (bool)
789     {
790         return safeTransferFrom(_from, _to, _prime, "");
791     }
792     
793     function approve(address _to, uint256 _prime) external returns (bool)
794     {
795         require(isApprovedFor(msg.sender, _prime), "approve error: you do not have approval from the owner of that prime");
796         primeToAllowedAddress[_prime] = _to;
797         emit Approval(msg.sender, _to, _prime);
798         return true;
799     }
800     
801     function setApprovalForAll(address _operator, bool _allowed) external returns (bool)
802     {
803         ownerToOperators[msg.sender][_operator] = _allowed;
804         emit ApprovalForAll(msg.sender, _operator, _allowed);
805         return true;
806     }
807     
808     function getApproved(uint256 _prime) external view returns (address)
809     {
810         require(isValidNFT(_prime), "getApproved error: prime does not exist");
811         return primeToAllowedAddress[_prime];
812     }
813     
814     function isApprovedForAll(address _owner, address _operator) external view returns (bool)
815     {
816         return ownerToOperators[_owner][_operator];
817     }
818     
819     function takeOwnership(uint256 _prime) external returns (bool)
820     {
821         require(isApprovedFor(msg.sender, _prime), "takeOwnership error: you do not have approval from the owner of that prime");
822         _setOwner(_prime, msg.sender);
823         return true;
824     }
825     
826     function transfer(address _to, uint256 _prime) external returns (bool)
827     {
828         require(isApprovedFor(msg.sender, _prime), "transfer error: you do not have approval from the owner of that prime");
829         _setOwner(_prime, _to);
830         return true;
831     }
832     
833     function transfer(address _to, uint _prime, bytes calldata _data) external returns (bool ok)
834     {
835         require(isApprovedFor(msg.sender, _prime), "transfer error: you do not have approval from the owner of that prime");
836         _setOwner(_prime, _to, _data, msg.sender, "");
837         return true;
838     }
839     
840     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256)
841     {
842         uint256[] storage ownerPrimes = ownerToPrimes[_owner];
843         require(_index < ownerPrimes.length, "tokenOfOwnerByIndex: index out of bounds");
844         return ownerPrimes[_index];
845     }
846     
847     function tokenByIndex(uint256 _index) external view returns (uint256)
848     {
849         if (_index < definitePrimes.length) return definitePrimes[_index];
850         else if (_index < definitePrimes.length + probablePrimes.length) return probablePrimes[_index - definitePrimes.length];
851         else revert("tokenByIndex error: index out of bounds");
852     }
853     
854     function tokensOf(address _owner) external view returns (uint256[] memory)
855     {
856         return ownerToPrimes[_owner];
857     }
858     
859     function implementsERC721() external pure returns (bool)
860     {
861         return true;
862     }
863     
864     function supportsInterface(bytes4 _interfaceID) external pure returns (bool)
865     {
866         
867         if (_interfaceID == 0x01ffc9a7) return true; // ERC165
868         if (_interfaceID == 0x80ac58cd) return true; // ERC721
869         if (_interfaceID == 0x5b5e139f) return true; // ERC721Metadata
870         if (_interfaceID == 0x780e9d63) return true; // ERC721Enumerable
871         return false;
872     }
873     
874     
875     
876     
877     
878     
879     
880     ////////////////////////////////////////////////////////////
881     ////////////////////////////////////////////////////////////
882     ////////////                                    ////////////
883     ////////////           View functions           ////////////
884     ////////////                                    ////////////
885     ////////////////////////////////////////////////////////////
886     ////////////////////////////////////////////////////////////
887     
888     // numberToDivisor returns 0 if no divisor was found
889     function numberToDivisor(uint256 _number) public view returns (uint256)
890     {
891         if (_number == 0) return 0;
892         else if ((_number & 1) == 0) return 2;
893         else return numberToNonTwoDivisor[_number];
894     }
895     
896     function isPrime(uint256 _number) public view returns (Booly)
897     {
898         NumberType numberType = numberdataToNumberType(numberToNumberdata[_number]);
899         if (numberType == NumberType.DEFINITE_PRIME) return DEFINITELY;
900         else if (numberType == NumberType.PROBABLE_PRIME) return PROBABLY;
901         else if (numberType == NumberType.NOT_PRIME_IF_PASSED)
902         {
903             if (_number < numberBeingTested)
904             {
905                 return DEFINITELY_NOT;
906             }
907             else
908             {
909                 return UNKNOWN;
910             }
911         }
912         else if (numberType == NumberType.NOT_PRIME) return DEFINITELY_NOT;
913         else revert();
914     }
915     
916     function getPrimeFactors(uint256 _number) external view returns (bool _success, uint256[] memory _primeFactors)
917     {
918         _primeFactors = new uint256[](0);
919         if (_number == 0) { _success = false; return (_success, _primeFactors); }
920         
921         // Track length of primeFactors array
922         uint256 amount = 0;
923         
924         
925         uint256 currentNumber = _number;
926         
927         while (true)
928         {
929             // If we've divided to 1, we're done :)
930             if (currentNumber == 1) { _success = true; return (_success, _primeFactors); }
931             
932             uint256 divisor = numberToDivisor(currentNumber);
933             
934             if (divisor == 0)
935             {
936                 if (isPrime(currentNumber) == DEFINITELY)
937                 {
938                     // If we couldn't find a divisor and the current number is a definite prime,
939                     // then the current prime is itself the divisor.
940                     // It will be added to primeFactors, currentNumber will go to one,
941                     // and we will exit successfully on the next iteration.
942                     divisor = currentNumber;
943                 }
944                 else
945                 {
946                     // If we don't know a divisor and we don't know for sure that the
947                     // current number is a definite prime, exit with failure.
948                     _success = false;
949                     return (_success, _primeFactors);
950                 }
951             }
952             else
953             {
954                 while (isPrime(divisor) != DEFINITELY)
955                 {
956                     divisor = numberToDivisor(divisor);
957                     if (divisor == 0) { _success = false; return (_success, _primeFactors); }
958                 }
959             }
960             
961             currentNumber /= divisor;
962             
963             // This in effect does: primeFactors.push(primeFactor)
964             {
965                 amount++;
966                 assembly
967                 {
968                     mstore(0x40, add(mload(0x40), 0x20)) // dirty: extend usable memory
969                     mstore(_primeFactors, amount) // dirty: set memory array size
970                 }
971                 _primeFactors[amount-1] = divisor;
972             }
973         }
974     }
975     
976     /*function isKnownNotPrime(uint256 _number) external view returns (bool)
977     {
978         return numberdataToNumberType(numberToNumberdata[_number]) == NumberType.NOT_PRIME;
979     }
980     
981     function isKnownDefinitePrime(uint256 _number) public view returns (bool)
982     {
983         return numberdataToNumberType(numberToNumberdata[_number]) == NumberType.DEFINITE_PRIME;
984     }
985     
986     function isKnownProbablePrime(uint256 _number) public view returns (bool)
987     {
988         return numberdataToNumberType(numberToNumberdata[_number]) == NumberType.PROBABLE_PRIME;
989     }*/
990 
991     function amountOfParticipants() external view returns (uint256)
992     {
993         return participants.length;
994     }
995     
996     function amountOfPrimesOwnedByOwner(address owner) external view returns (uint256)
997     {
998         return ownerToPrimes[owner].length;
999     }
1000     
1001     function amountOfPrimesFound() external view returns (uint256)
1002     {
1003         return definitePrimes.length + probablePrimes.length;
1004     }
1005     
1006     function amountOfDefinitePrimesFound() external view returns (uint256)
1007     {
1008         return definitePrimes.length;
1009     }
1010     
1011     function amountOfProbablePrimesFound() external view returns (uint256)
1012     {
1013         return probablePrimes.length;
1014     }
1015     
1016     function largestDefinitePrimeFound() public view returns (uint256)
1017     {
1018         return definitePrimes[definitePrimes.length-1];
1019     }
1020     
1021     function getInsecureRandomDefinitePrime() external view returns (uint256)
1022     {
1023         return definitePrimes[insecureRand()%definitePrimes.length];
1024     }
1025     
1026     function getInsecureRandomProbablePrime() external view returns (uint256)
1027     {
1028         return probablePrimes[insecureRand()%probablePrimes.length];
1029     }
1030 
1031 
1032 
1033     
1034     ////////////////////////////////////////////////////////////
1035     ////////////////////////////////////////////////////////////
1036     ////////////                                    ////////////
1037     ////////////            Constructor             ////////////
1038     ////////////                                    ////////////
1039     ////////////////////////////////////////////////////////////
1040     ////////////////////////////////////////////////////////////
1041     
1042     constructor() public
1043     {
1044         participants.push(address(0x0));
1045         
1046         // Let's start with 2.
1047         _createPrime(2, msg.sender, true);
1048         
1049         // The next one up for prime checking will be 3.
1050         numberBeingTested = 3;
1051         divisorIndexBeingTested = 0;
1052         
1053         new EtherPrimeChat(this);
1054     }
1055     
1056     
1057 
1058     
1059     
1060     
1061     ////////////////////////////////////////////////////////////
1062     ////////////////////////////////////////////////////////////
1063     ////////////                                    ////////////
1064     ////////////     Definite prime generation      ////////////
1065     ////////////                                    ////////////
1066     ////////////////////////////////////////////////////////////
1067     ////////////////////////////////////////////////////////////
1068     
1069     // Call these function to help calculate prime numbers.
1070     // The reward shall be your immortalized glory.
1071     
1072     uint256 private constant DEFAULT_PRIMES_TO_MEMORIZE = 0;
1073     uint256 private constant DEFAULT_LOW_LEVEL_GAS = 200000;
1074     
1075     function () external
1076     {
1077         computeWithParams(definitePrimes.length/2, DEFAULT_LOW_LEVEL_GAS, msg.sender);
1078     }
1079     
1080     function compute() external
1081     {
1082         computeWithParams(definitePrimes.length/2, DEFAULT_LOW_LEVEL_GAS, msg.sender);
1083     }
1084     
1085     function computeAndGiveTo(address _recipient) external
1086     {
1087         computeWithParams(definitePrimes.length/2, DEFAULT_LOW_LEVEL_GAS, _recipient);
1088     }
1089     
1090     function computeWithPrimesToMemorize(uint256 _primesToMemorize) external
1091     {
1092         computeWithParams(_primesToMemorize, DEFAULT_LOW_LEVEL_GAS, msg.sender);
1093     }
1094     
1095     function computeWithPrimesToMemorizeAndLowLevelGas(uint256 _primesToMemorize, uint256 _lowLevelGas) external
1096     {
1097         computeWithParams(_primesToMemorize, _lowLevelGas, msg.sender);
1098     }
1099     
1100     function computeWithParams(uint256 _primesToMemorize, uint256 _lowLevelGas, address _recipient) public
1101     {
1102         require(_primesToMemorize <= definitePrimes.length, "computeWithParams error: _primesToMemorize out of bounds");
1103         
1104         uint256 startGas = gasleft();
1105         
1106         // We need to continue where we stopped last time.
1107         uint256 number = numberBeingTested;
1108         uint256 divisorIndex = divisorIndexBeingTested;
1109         
1110         // Read this in advance so we don't have to keep SLOAD'ing it
1111         uint256 totalPrimes = definitePrimes.length;
1112         
1113         // Load some discovered definite primes into memory
1114         uint256[] memory definitePrimesCache = new uint256[](_primesToMemorize);
1115         for (uint256 i=0; i<_primesToMemorize; i++)
1116         {
1117             definitePrimesCache[i] = definitePrimes[i];
1118         }
1119         
1120         for (; ; number += 2)
1121         {
1122             // Save state and stop if remaining gas is too low
1123             if (gasleft() < _lowLevelGas)
1124             {
1125                 numberBeingTested = number;
1126                 divisorIndexBeingTested = divisorIndex;
1127                 uint256 gasSpent = startGas - gasleft();
1128                 addressToGasSpent[msg.sender] += gasSpent;
1129                 addressToEtherSpent[msg.sender] += gasSpent * tx.gasprice;
1130                 return;
1131             }
1132             
1133             if (isPrime(number) != DEFINITELY_NOT)
1134             {
1135                 uint256 sqrtNumberRoundedDown = sqrtRoundedDown(number);
1136                 
1137                 bool numberCanStillBePrime = true;
1138                 uint256 divisor;
1139                 
1140                 for (; divisorIndex<totalPrimes; divisorIndex++)
1141                 {
1142                     // Save state and stop if remaining gas is too low
1143                     if (gasleft() < _lowLevelGas)
1144                     {
1145                         numberBeingTested = number;
1146                         divisorIndexBeingTested = divisorIndex;
1147                         uint256 gasSpent = startGas - gasleft();
1148                         addressToGasSpent[msg.sender] += gasSpent;
1149                         addressToEtherSpent[msg.sender] += gasSpent * tx.gasprice;
1150                         return;
1151                     }
1152                     
1153                     if (divisorIndex < definitePrimesCache.length) divisor = definitePrimesCache[divisorIndex];
1154                     else divisor = definitePrimes[divisorIndex];
1155                     
1156                     if (number % divisor == 0)
1157                     {
1158                         numberCanStillBePrime = false;
1159                         break;
1160                     }
1161                     
1162                     // We don't have to try to divide by numbers higher than the
1163                     // square root of the number. Why? Well, suppose you're testing
1164                     // if 29 is prime. You've already tried dividing by 2, 3, 4, 5
1165                     // and found that you couldn't, so now you move on to 6.
1166                     // Trying to divide it by 6 is futile, because if 29 were
1167                     // divisible by 6, it would logically also be divisible by 29/6
1168                     // which you should already have found at that point, because
1169                     // 29/6 < 6, because 6 > sqrt(29)
1170                     if (divisor > sqrtNumberRoundedDown)
1171                     {
1172                         break;
1173                     }
1174                 }
1175                 
1176                 if (numberCanStillBePrime)
1177                 {
1178                     _createPrime(number, _recipient, true);
1179                     totalPrimes++;
1180                 }
1181                 else
1182                 {
1183                     numberToNonTwoDivisor[number] = divisor;
1184                 }
1185                 
1186                 // Start trying to divide by 3.
1187                 // We skip all the even numbers so we don't have to bother dividing by 2.
1188                 divisorIndex = 1;
1189             }
1190         }
1191         
1192         // This point should be unreachable.
1193         revert("computeWithParams error: This point should never be reached.");
1194     }
1195     
1196     // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
1197     function sqrtRoundedDown(uint256 x) private pure returns (uint256 y)
1198     {
1199         if (x == ~uint256(0)) return 340282366920938463463374607431768211455;
1200         
1201         uint256 z = (x + 1) >> 1;
1202         y = x;
1203         while (z < y)
1204         {
1205             y = z;
1206             z = ((x / z) + z) >> 1;
1207         }
1208         return y;
1209     }
1210     
1211     
1212     
1213     
1214     
1215     
1216     ////////////////////////////////////////////////////////////
1217     ////////////////////////////////////////////////////////////
1218     ////////////                                    ////////////
1219     ////////////            Prime classes           ////////////
1220     ////////////                                    ////////////
1221     ////////////////////////////////////////////////////////////
1222     ////////////////////////////////////////////////////////////
1223     
1224     // Balanced primes are exactly in the middle between the two surrounding primes
1225     function isBalancedPrime(uint256 _prime) external view returns (Booly result, uint256 lowerPrime, uint256 higherPrime)
1226     {
1227         Booly primality = isPrime(_prime);
1228         if (primality == DEFINITELY_NOT)
1229         {
1230             return (DEFINITELY_NOT, 0, 0);
1231         }
1232         else if (primality == PROBABLY_NOT)
1233         {
1234             return (PROBABLY_NOT, 0, 0);
1235         }
1236         else if (primality == UNKNOWN)
1237         {
1238             return (UNKNOWN, 0, 0);
1239         }
1240         else if (primality == PROBABLY)
1241         {
1242             return (UNKNOWN, 0, 0);
1243         }
1244         else if (primality == DEFINITELY)
1245         {
1246             uint256 index = numberdataToAllPrimesIndex(numberToNumberdata[_prime]);
1247             if (index == 0)
1248             {
1249                 // 2 is not a balanced prime, because there is no prime before it
1250                 return (DEFINITELY_NOT, 0, 0);
1251             }
1252             else if (index == definitePrimes.length-1)
1253             {
1254                 // We cannot determine this property for the last prime we've found
1255                 return (UNKNOWN, 0, 0);
1256             }
1257             else
1258             {
1259                 uint256 primeBefore = definitePrimes[index-1];
1260                 uint256 primeAfter = definitePrimes[index+1];
1261                 if (_prime - primeBefore == primeAfter - _prime) return (DEFINITELY, primeBefore, primeAfter);
1262                 else return (DEFINITELY_NOT, primeBefore, primeAfter);
1263             }
1264         }
1265         else
1266         {
1267             revert();
1268         }
1269     }
1270     
1271     // NTuple mersenne primes:
1272     // n=0 => primes                                            returns []
1273     // n=1 => mersenne primes of form 2^p-1                     returns [p]
1274     // n=2 => double mersenne primes of form 2^(2^p-1)-1        returns [2^p-1, p]
1275     // n=3 => triple mersenne primes of form 2^(2^(2^p-1)-1)-1  returns [2^(2^p-1)-1, 2^p-1, p]
1276     // etc..
1277     function isNTupleMersennePrime(uint256 _number, uint256 _n) external view returns (Booly _result, uint256[] memory _powers)
1278     {
1279         _powers = new uint256[](_n);
1280         
1281         // Prevent overflow on _number+1
1282         if (_number+1 < _number) return (UNKNOWN, _powers);
1283         
1284         _result = isPrime(_number);
1285         if (_result == DEFINITELY_NOT) { return (DEFINITELY_NOT, _powers); }
1286         
1287         uint256 currentNumber = _number;
1288         
1289         for (uint256 i=0; i<_n; i++)
1290         {
1291             Booly powerOf2ity = isPowerOf2(currentNumber+1) ? DEFINITELY : DEFINITELY_NOT;
1292             if (powerOf2ity == DEFINITELY_NOT) { return (DEFINITELY_NOT, _powers); }
1293             
1294             _powers[i] = currentNumber = log2ofPowerOf2(currentNumber+1);
1295         }
1296         
1297         return (_result, _powers);
1298     }
1299     
1300     // A good prime's square is greater than the product of all equally distant (by index) primes
1301     function isGoodPrime(uint256 _number) external view returns (Booly)
1302     {
1303         // 2 is defined not to be a good prime.
1304         if (_number == 2) return DEFINITELY_NOT;
1305         
1306         Booly primality = isPrime(_number);
1307         if (primality == DEFINITELY)
1308         {
1309             uint256 index = numberdataToAllPrimesIndex(numberToNumberdata[_number]);
1310             
1311             if (index*2 >= definitePrimes.length)
1312             {
1313                 // We haven't found enough definite primes yet to determine this property
1314                 return UNKNOWN;
1315             }
1316             else
1317             {
1318                 uint256 squareOfInput;
1319                 bool mulSuccess;
1320                 
1321                 (squareOfInput, mulSuccess) = TRY_MUL(_number, _number);
1322                 if (!mulSuccess) return UNKNOWN;
1323                 
1324                 for (uint256 i=1; i<=index; i++)
1325                 {
1326                     uint256 square;
1327                     (square, mulSuccess) = TRY_MUL(definitePrimes[index-i], definitePrimes[index+i]);
1328                     if (!mulSuccess) return UNKNOWN;
1329                     if (square >= squareOfInput)
1330                     {
1331                         return DEFINITELY_NOT;
1332                     }
1333                 }
1334                 return DEFINITELY;
1335             }
1336         }
1337         else if (primality == PROBABLY || primality == UNKNOWN)
1338         {
1339             // We can't determine it
1340             return UNKNOWN;
1341         }
1342         else if (primality == DEFINITELY_NOT)
1343         {
1344             return DEFINITELY_NOT;
1345         }
1346         else if (primality == PROBABLY_NOT)
1347         {
1348             return PROBABLY_NOT;
1349         }
1350         else
1351         {
1352             // This should never happen
1353             revert();
1354         }
1355     }
1356     
1357     // Factorial primes are of the form n!+delta where delta = +1 or delta = -1
1358     function isFactorialPrime(uint256 _number) external view returns (Booly _result, uint256 _n, int256 _delta)
1359     {
1360         // Prevent underflow on _number-1
1361         if (_number == 0) return (DEFINITELY_NOT, 0, 0);
1362         
1363         // Prevent overflow on _number+1
1364         if (_number == ~uint256(0)) return (DEFINITELY_NOT, 0, 0);
1365         
1366         
1367         Booly primality = isPrime(_number);
1368         
1369         if (primality == DEFINITELY_NOT) return (DEFINITELY_NOT, 0, 0);
1370         
1371         bool factorialityOfPrimePlus1;
1372         uint256 primePlus1n;
1373 
1374         // Detect factorial primes of the form n!-1
1375         (primePlus1n, factorialityOfPrimePlus1) = reverseFactorial(_number+1);
1376         if (factorialityOfPrimePlus1) return (AND(primality, factorialityOfPrimePlus1), primePlus1n, -1);
1377 
1378         bool factorialityOfPrimeMinus1;
1379         uint256 primeMinus1n;
1380         
1381         (primeMinus1n, factorialityOfPrimeMinus1) = reverseFactorial(_number-1);
1382         if (factorialityOfPrimeMinus1) return (AND(primality, factorialityOfPrimeMinus1), primeMinus1n, 1);
1383         
1384         return (DEFINITELY_NOT, 0, 0);
1385     }
1386     
1387     // Cullen primes are of the form n * 2^n + 1
1388     function isCullenPrime(uint256 _number) external pure returns (Booly _result, uint256 _n)
1389     {
1390         // There are only two cullen primes that fit in a 256-bit integer
1391         if (_number == 3)  // n = 1
1392         {
1393             return (DEFINITELY, 1);
1394         }
1395         else if (_number == 393050634124102232869567034555427371542904833) // n = 141
1396         {
1397             return (DEFINITELY, 141);
1398         }
1399         else
1400         {
1401             return (DEFINITELY_NOT, 0);
1402         }
1403     }
1404     
1405     // Fermat primes are of the form 2^(2^n)+1
1406     // Conjecturally, 3, 5, 17, 257, 65537 are the only ones
1407     function isFermatPrime(uint256 _number) external view returns (Booly result, uint256 _2_pow_n, uint256 _n)
1408     {
1409         // Prevent underflow on _number-1
1410         if (_number == 0) return (DEFINITELY_NOT, 0, 0);
1411         
1412         
1413         Booly primality = isPrime(_number);
1414         
1415         if (primality == DEFINITELY_NOT) return (DEFINITELY_NOT, 0, 0);
1416         
1417         bool is__2_pow_2_pow_n__powerOf2 = isPowerOf2(_number-1);
1418         
1419         if (!is__2_pow_2_pow_n__powerOf2) return (DEFINITELY_NOT, 0, 0);
1420         
1421         _2_pow_n = log2ofPowerOf2(_number-1);
1422         
1423         bool is__2_pow_n__powerOf2 = isPowerOf2(_2_pow_n);
1424         
1425         if (!is__2_pow_n__powerOf2) return (DEFINITELY_NOT, _2_pow_n, 0);
1426         
1427         _n = log2ofPowerOf2(_2_pow_n);
1428     }
1429     
1430     // Super-primes are primes with a prime index in the sequence of prime numbers. (indexed starting with 1)
1431     function isSuperPrime(uint256 _number) public view returns (Booly _result, uint256 _indexStartAtOne)
1432     {
1433         Booly primality = isPrime(_number);
1434         if (primality == DEFINITELY)
1435         {
1436             _indexStartAtOne = numberdataToAllPrimesIndex(numberToNumberdata[_number]) + 1;
1437             _result = isPrime(_indexStartAtOne);
1438             return (_result, _indexStartAtOne);
1439         }
1440         else if (primality == DEFINITELY_NOT)
1441         {
1442             return (DEFINITELY_NOT, 0);
1443         }
1444         else if (primality == UNKNOWN)
1445         {
1446             return (UNKNOWN, 0);
1447         }
1448         else if (primality == PROBABLY)
1449         {
1450             return (UNKNOWN, 0);
1451         }
1452         else if (primality == PROBABLY_NOT)
1453         {
1454             return (PROBABLY_NOT, 0);
1455         }
1456         else
1457         {
1458             revert();
1459         }
1460     }
1461     
1462     function isFibonacciPrime(uint256 _number) public view returns (Booly _result)
1463     {
1464         return AND_F(isPrime, isFibonacciNumber, _number);
1465     }
1466     
1467     
1468     
1469     
1470     
1471     
1472     
1473     
1474     ////////////////////////////////////////////////////////////
1475     ////////////////////////////////////////////////////////////
1476     ////////////                                    ////////////
1477     ////////////          Number classes            ////////////
1478     ////////////                                    ////////////
1479     ////////////////////////////////////////////////////////////
1480     ////////////////////////////////////////////////////////////
1481     
1482     function isFibonacciNumber(uint256 _number) public pure returns (Booly _result)
1483     {
1484         // If _number doesn't fit inside a uint126, we can't perform the computations necessary to check fibonaccality.
1485         // We need to be able to square it, multiply by 5 then add 4.
1486         // Adding 4 removes 1 bit of room: uint256 -> uint255
1487         // Multiplying by 5 removes 3 bits of room: uint255 -> uint252
1488         // Squaring removes 50% of room: uint252 -> uint126
1489         // Rounding down to the nearest solidity type: uint126 -> uint120
1490 
1491         if (uint256(uint120(_number)) != _number) return UNKNOWN;
1492         
1493         uint256 squareOfNumber = _number * _number;
1494         uint256 squareTimes5 = squareOfNumber * 5;
1495         uint256 squareTimes5plus4 = squareTimes5 + 4;
1496         
1497         bool squareTimes5plus4squarality;
1498         (squareTimes5plus4squarality, ) = isSquareNumber(squareTimes5plus4);
1499         
1500         if (squareTimes5plus4squarality) return DEFINITELY;
1501         
1502         uint256 squareTimes5minus4 = squareTimes5 - 4;
1503         
1504         bool squareTimes5minus4squarality;
1505         
1506         // Check underflow
1507         if (squareTimes5minus4 > squareTimes5) 
1508         {
1509             squareTimes5minus4squarality = false;
1510         }
1511         else
1512         {
1513             (squareTimes5minus4squarality, ) = isSquareNumber(squareTimes5minus4);
1514         }
1515         
1516         return (squareTimes5plus4squarality || squareTimes5minus4squarality) ? DEFINITELY : DEFINITELY_NOT;
1517     }
1518     
1519     function isSquareNumber(uint256 _number) private pure returns (bool _result, uint256 _squareRoot)
1520     {
1521         uint256 rootRoundedDown = sqrtRoundedDown(_number);
1522         return (rootRoundedDown * rootRoundedDown == _number, rootRoundedDown);
1523     }
1524     
1525 
1526 
1527 
1528 
1529 
1530 
1531     
1532     ////////////////////////////////////////////////////////////
1533     ////////////////////////////////////////////////////////////
1534     ////////////                                    ////////////
1535     ////////////           Math functions           ////////////
1536     ////////////                                    ////////////
1537     ////////////////////////////////////////////////////////////
1538     ////////////////////////////////////////////////////////////
1539     
1540     function reverseFactorial(uint256 _number) private pure returns (uint256 output, bool success)
1541     {
1542         // 0 = immediate failure
1543         if (_number == 0) return (0, false);
1544         
1545         uint256 divisor = 1;
1546         while (_number > 1)
1547         {
1548             divisor++;
1549             uint256 remainder = _number % divisor;
1550             if (remainder != 0) return (divisor, false);
1551             _number /= divisor;
1552         }
1553         
1554         return (divisor, true);
1555     }
1556     
1557     function isPowerOf2(uint256 _number) private pure returns (bool)
1558     {
1559         if (_number == 0) return false;
1560         else return ((_number-1) & _number) == 0;
1561     }
1562     
1563     // Performs a log2 on a power of 2.
1564     // This function will throw if the input was not a power of 2.
1565     function log2ofPowerOf2(uint256 _powerOf2) private pure returns (uint256)
1566     {
1567         require(_powerOf2 != 0, "log2ofPowerOf2 error: 0 is not a power of 2");
1568         uint256 iterations = 0;
1569         while (true)
1570         {
1571             if (_powerOf2 == 1) return iterations;
1572             require((_powerOf2 & 1) == 0, "log2ofPowerOf2 error: argument is not a power of 2"); // The current number must be divisible by 2
1573             _powerOf2 >>= 1; // Divide by 2
1574             iterations++;
1575         }
1576     }
1577     
1578     // Generate a random number with low gas cost.
1579     // This RNG is not secure and can be influenced!
1580     function insecureRand() private view returns (uint256)
1581     {
1582         return uint256(keccak256(abi.encodePacked(
1583             largestDefinitePrimeFound(),
1584             probablePrimes.length,
1585             block.coinbase,
1586             block.timestamp,
1587             block.number,
1588             block.difficulty,
1589             tx.origin,
1590             tx.gasprice,
1591             msg.sender,
1592             now,
1593             gasleft()
1594         )));
1595     }
1596     
1597     // TRY_POW_MOD function defines 0^0 % n = 1
1598     function TRY_POW_MOD(uint256 _base, uint256 _power, uint256 _modulus) private pure returns (uint256 result, bool success)
1599     {
1600         if (_modulus == 0) return (0, false);
1601         
1602         bool mulSuccess;
1603         _base %= _modulus;
1604         result = 1;
1605         while (_power > 0)
1606         {
1607             if (_power & uint256(1) != 0)
1608             {
1609                 (result, mulSuccess) = TRY_MUL(result, _base);
1610                 if (!mulSuccess) return (0, false);
1611                 result %= _modulus;
1612             }
1613             (_base, mulSuccess) = TRY_MUL(_base, _base);
1614             if (!mulSuccess) return (0, false);
1615             _base = _base % _modulus;
1616             _power >>= 1;
1617         }
1618         success = true;
1619     }
1620     
1621     function TRY_MUL(uint256 _i, uint256 _j) private pure returns (uint256 result, bool success)
1622     {
1623         if (_i == 0) { return (0, true); }
1624         uint256 ret = _i * _j;
1625         if (ret / _i == _j) return (ret, true);
1626         else return (ret, false);
1627     }
1628 
1629 
1630 
1631 
1632     
1633     ////////////////////////////////////////////////////////////
1634     ////////////////////////////////////////////////////////////
1635     ////////////                                    ////////////
1636     ////////////           Miller-rabin             ////////////
1637     ////////////                                    ////////////
1638     ////////////////////////////////////////////////////////////
1639     ////////////////////////////////////////////////////////////
1640     
1641     // This function runs one trial. It returns false if n is
1642     // definitely composite and true if n is probably prime.
1643     // d must be an odd number such that d*2^r = n-1 for some r >= 1
1644     function probabilisticTest(uint256 d, uint256 _number, uint256 _random) private pure returns (bool result, bool success)
1645     {
1646         // Check d
1647         assert(d & 1 == 1); // d is odd
1648         assert((_number-1) % d == 0); // n-1 divisible by d
1649         uint256 nMinusOneOverD = (_number-1) / d;
1650         assert(isPowerOf2(nMinusOneOverD)); // (n-1)/d is power of 2
1651         assert(nMinusOneOverD >= 1); // 2^r >= 2 therefore r >= 1
1652         
1653         // Make sure we can subtract 4 from _number
1654         if (_number < 4) return (false, false);
1655         
1656         // Pick a random number in [2..n-2]
1657         uint256 a = 2 + _random % (_number - 4);
1658         
1659         // Compute a^d % n
1660         uint256 x;
1661         (x, success) = TRY_POW_MOD(a, d, _number);
1662         if (!success) return (false, false);
1663         
1664         if (x == 1 || x == _number-1)
1665         {
1666             return (true, true);
1667         }
1668         
1669         // Keep squaring x while one of the following doesn't
1670         // happen
1671         // (i)   d does not reach n-1
1672         // (ii)  (x^2) % n is not 1
1673         // (iii) (x^2) % n is not n-1
1674         while (d != _number-1)
1675         {
1676             (x, success) = TRY_MUL(x, x);
1677             if (!success) return (false, false);
1678             
1679             x %= _number;
1680             
1681             (d, success) = TRY_MUL(d, 2);
1682             if (!success) return (false, false);
1683             
1684             
1685             if (x == 1) return (false, true);
1686             if (x == _number-1) return (true, true);
1687         }
1688      
1689         // Return composite
1690         return (false, true);
1691     }
1692     
1693     // This functions runs multiple miller-rabin trials.
1694     // It returns false if _number is definitely composite and
1695     // true if _number is probably prime.
1696     function isPrime_probabilistic(uint256 _number) public view returns (Booly)
1697     {
1698         // 40 iterations is heuristically enough for extremely high certainty
1699         uint256 probabilistic_iterations = 40;
1700         
1701         // Corner cases
1702         if (_number == 0 || _number == 1 || _number == 4)  return DEFINITELY_NOT;
1703         if (_number == 2 || _number == 3) return DEFINITELY;
1704         
1705         // Find d such that _number == 2^d * r + 1 for some r >= 1
1706         uint256 d = _number - 1;
1707         while ((d & 1) == 0)
1708         {
1709             d >>= 1;
1710         }
1711         
1712         uint256 random = insecureRand();
1713         
1714         // Run the probabilistic test many times with different randomness
1715         for (uint256 i = 0; i < probabilistic_iterations; i++)
1716         {
1717             bool result;
1718             bool success;
1719             (result, success) = probabilisticTest(d, _number, random);
1720             if (success == false)
1721             {
1722                 return UNKNOWN;
1723             }
1724             if (result == false)
1725             {
1726                 return DEFINITELY_NOT;
1727             }
1728             
1729             // Shuffle bits
1730             random *= 22777;
1731             random ^= (random >> 7);
1732             random *= 71879;
1733             random ^= (random >> 11);
1734         }
1735         
1736         return PROBABLY;
1737     }
1738     
1739     
1740     
1741     
1742     
1743     
1744     ////////////////////////////////////////////////////////////
1745     ////////////////////////////////////////////////////////////
1746     ////////////                                    ////////////
1747     ////////////  Claim & disprove probable primes  ////////////
1748     ////////////                                    ////////////
1749     ////////////////////////////////////////////////////////////
1750     ////////////////////////////////////////////////////////////
1751     
1752     function claimProbablePrime(uint256 _number) public
1753     {
1754         require(tryClaimProbablePrime(_number), "claimProbablePrime error: that number is not prime or has already been claimed");
1755     }
1756     
1757     function tryClaimProbablePrime(uint256 _number) public returns (bool _success)
1758     {
1759         uint256 startGas = gasleft();
1760         
1761         Booly primality = isPrime(_number);
1762         
1763         // If we already have knowledge about the provided number, cancel the claim attempt.
1764         if (primality != UNKNOWN)
1765         {
1766             _success = false;
1767         }
1768         else
1769         {
1770             primality = isPrime_probabilistic(_number);
1771             
1772             if (primality == DEFINITELY_NOT)
1773             {
1774                 // If it's not prime, remember it as such
1775                 _numberdataSetNumberType(_number, NumberType.NOT_PRIME);
1776                 
1777                  _success = false;
1778             }
1779             else if (primality == PROBABLY)
1780             {
1781                 _createPrime(_number, msg.sender, false);
1782                 
1783                 addressToProbablePrimesClaimed[msg.sender]++;
1784                 
1785                  _success = true;
1786             }
1787             else
1788             {
1789                  _success = false;
1790             }
1791         }
1792         
1793         uint256 gasSpent = startGas - gasleft();
1794         addressToGasSpent[msg.sender] += gasSpent;
1795         addressToEtherSpent[msg.sender] += gasSpent * tx.gasprice;
1796     }
1797     
1798     function disproveProbablePrime(uint256 _prime, uint256 _divisor) external
1799     {
1800         require(_divisor > 1 && _divisor < _prime, "disproveProbablePrime error: divisor must be greater than 1 and smaller than prime");
1801         
1802         bytes32 numberdata = numberToNumberdata[_prime];
1803         
1804         // If _prime is a probable prime...
1805         require(numberdataToNumberType(numberdata) == NumberType.PROBABLE_PRIME, "disproveProbablePrime error: that prime is not a probable prime");
1806         
1807         // ... and _prime is divisible by _divisor ...
1808         require((_prime % _divisor) == 0, "disproveProbablePrime error: that prime is not divisible by that divisor");
1809         
1810         address owner = numberdataToOwner(numberdata);
1811         
1812         // Statistics
1813         addressToProbablePrimesDisprovenFrom[owner]++;
1814         addressToProbablePrimesDisprovenBy[msg.sender]++;
1815         
1816         _setOwner(_prime, address(0x0));
1817         
1818         _numberdataSetNumberType(_prime, NumberType.NOT_PRIME);
1819         
1820         // Remove it from the probablePrimes array
1821         uint256 primeIndex = numberdataToAllPrimesIndex(numberdata);
1822         
1823         // If the prime we're removing is not the last one in the probablePrimes array...
1824         if (primeIndex < probablePrimes.length-1)
1825         {
1826             // ...move the last one back into its slot.
1827             uint256 otherPrimeBeingMoved = probablePrimes[probablePrimes.length-1];
1828             _numberdataSetAllPrimesIndex(otherPrimeBeingMoved, uint48(primeIndex));
1829             probablePrimes[primeIndex] = otherPrimeBeingMoved;
1830         }
1831         probablePrimes[probablePrimes.length-1] = 0; // Refund some gas
1832         probablePrimes.length--;
1833         
1834         // Broadcast event
1835         emit ProbablePrimeDisproven(_prime, _divisor, owner, msg.sender, primeIndex);
1836         
1837         // Store the divisor
1838         numberToNonTwoDivisor[_prime] = _divisor;
1839     }
1840     
1841     function claimProbablePrimeInRange(uint256 _start, uint256 _end) external returns (bool _success, uint256 _prime)
1842     {
1843         for (uint256 currentNumber = _start; currentNumber <= _end; currentNumber++)
1844         {
1845             if (tryClaimProbablePrime(currentNumber)) { return (true, currentNumber); }
1846         }
1847         return (false, 0);
1848     }
1849     
1850     
1851     
1852     
1853     
1854     ////////////////////////////////////////////////////////////
1855     ////////////////////////////////////////////////////////////
1856     ////////////                                    ////////////
1857     ////////////      Try to stop people from       ////////////
1858     ////////////    accidentally sending tokens     ////////////
1859     ////////////         to this contract           ////////////
1860     ////////////                                    ////////////
1861     ////////////////////////////////////////////////////////////
1862     ////////////////////////////////////////////////////////////
1863     
1864     function onERC721Received(address, address, uint256, bytes calldata) external pure // ERC721
1865     {
1866         revert("EtherPrime contract should not receive tokens");
1867     }
1868     
1869     function tokenFallback(address, uint256, bytes calldata) external pure // ERC223
1870     {
1871         revert("EtherPrime contract should not receive tokens");
1872     }
1873     
1874     function tokensReceived(address, address, address, uint, bytes calldata, bytes calldata) external pure // ERC777
1875     {
1876         revert("EtherPrime contract should not receive tokens");
1877     }
1878     
1879     
1880     
1881     
1882     
1883     
1884     
1885     ////////////////////////////////////////////////////////////
1886     ////////////////////////////////////////////////////////////
1887     ////////////                                    ////////////
1888     ////////////            Booly stuff             ////////////
1889     ////////////                                    ////////////
1890     ////////////////////////////////////////////////////////////
1891     ////////////////////////////////////////////////////////////
1892     
1893     // Penta-state logic implementation
1894     
1895     enum Booly
1896     {
1897         DEFINITELY_NOT,
1898         PROBABLY_NOT,
1899         UNKNOWN,
1900         PROBABLY,
1901         DEFINITELY
1902     }
1903     
1904     Booly public constant DEFINITELY_NOT = Booly.DEFINITELY_NOT;
1905     Booly public constant PROBABLY_NOT = Booly.PROBABLY_NOT;
1906     Booly public constant UNKNOWN = Booly.UNKNOWN;
1907     Booly public constant PROBABLY = Booly.PROBABLY;
1908     Booly public constant DEFINITELY = Booly.DEFINITELY;
1909     
1910     function OR(Booly a, Booly b) internal pure returns (Booly)
1911     {
1912         if (a == DEFINITELY || b == DEFINITELY) return DEFINITELY;
1913         else if (a == PROBABLY || b == PROBABLY) return PROBABLY;
1914         else if (a == UNKNOWN || b == UNKNOWN) return UNKNOWN;
1915         else if (a == PROBABLY_NOT || b == PROBABLY_NOT) return PROBABLY_NOT;
1916         else if (a == DEFINITELY_NOT && b == DEFINITELY_NOT) return DEFINITELY_NOT;
1917         else revert();
1918     }
1919     
1920     function NOT(Booly a) internal pure returns (Booly)
1921     {
1922         if (a == DEFINITELY_NOT) return DEFINITELY;
1923         else if (a == PROBABLY_NOT) return PROBABLY;
1924         else if (a == UNKNOWN) return UNKNOWN;
1925         else if (a == PROBABLY) return PROBABLY_NOT;
1926         else if (a == DEFINITELY) return DEFINITELY_NOT;
1927         else revert();
1928     }
1929     
1930     function AND(Booly a, Booly b) internal pure returns (Booly)
1931     {
1932         if (a == DEFINITELY_NOT || b == DEFINITELY_NOT) return DEFINITELY_NOT;
1933         else if (a == PROBABLY_NOT || b == PROBABLY_NOT) return PROBABLY_NOT;
1934         else if (a == UNKNOWN || b == UNKNOWN) return UNKNOWN;
1935         else if (a == PROBABLY || b == PROBABLY) return PROBABLY;
1936         else if (a == DEFINITELY && b == DEFINITELY) return DEFINITELY;
1937         else revert();
1938     }
1939     
1940     function AND(Booly a, bool b) internal pure returns (Booly)
1941     {
1942         if (b == true) return a;
1943         else return DEFINITELY_NOT;
1944     }
1945     
1946     function XOR(Booly a, Booly b) internal pure returns (Booly)
1947     {
1948         return AND(OR(a, b), NOT(AND(a, b)));
1949     }
1950     
1951     function NAND(Booly a, Booly b) internal pure returns (Booly)
1952     {
1953         return NOT(AND(a, b));
1954     }
1955     
1956     function NOR(Booly a, Booly b) internal pure returns (Booly)
1957     {
1958         return NOT(OR(a, b));
1959     }
1960     
1961     function XNOR(Booly a, Booly b) internal pure returns (Booly)
1962     {
1963         return NOT(XOR(a, b));
1964     }
1965     
1966     function AND_F(function(uint256)view returns(Booly) aFunc, function(uint256)view returns(Booly) bFunc, uint256 _arg) internal view returns (Booly)
1967     {
1968         Booly a = aFunc(_arg);
1969         if (a == DEFINITELY_NOT) return DEFINITELY_NOT;
1970         else
1971         {
1972             Booly b = bFunc(_arg);
1973             if (b == DEFINITELY_NOT) return DEFINITELY_NOT;
1974             else if (a == PROBABLY_NOT) return PROBABLY_NOT;
1975             else if (b == PROBABLY_NOT) return PROBABLY_NOT;
1976             else if (a == UNKNOWN || b == UNKNOWN) return UNKNOWN;
1977             else if (a == PROBABLY || b == PROBABLY) return PROBABLY;
1978             else if (a == DEFINITELY && b == DEFINITELY) return DEFINITELY;
1979             else revert();
1980         }
1981     }
1982     
1983     function OR_F(function(uint256)view returns(Booly) aFunc, function(uint256)view returns(Booly) bFunc, uint256 _arg) internal view returns (Booly)
1984     {
1985         Booly a = aFunc(_arg);
1986         if (a == DEFINITELY) return DEFINITELY;
1987         else
1988         {
1989             Booly b = bFunc(_arg);
1990             if (b == DEFINITELY) return DEFINITELY;
1991             else if (a == PROBABLY || b == PROBABLY) return PROBABLY;
1992             else if (a == UNKNOWN || b == UNKNOWN) return UNKNOWN;
1993             else if (a == PROBABLY_NOT || b == PROBABLY_NOT) return PROBABLY_NOT;
1994             else if (a == DEFINITELY_NOT && b == DEFINITELY_NOT) return DEFINITELY_NOT;
1995             else revert();
1996         }
1997     }
1998     
1999     
2000     
2001     
2002     
2003     
2004     
2005     
2006     ////////////////////////////////////////////////////////////
2007     ////////////////////////////////////////////////////////////
2008     ////////////                                    ////////////
2009     ////////////           Trading stuff            ////////////
2010     ////////////                                    ////////////
2011     ////////////////////////////////////////////////////////////
2012     ////////////////////////////////////////////////////////////
2013     
2014     // depositEther() should only be called at the start of 'external payable' functions.
2015     function depositEther() public payable
2016     {
2017         addressToEtherBalance[msg.sender] += msg.value;
2018         
2019         emit EtherDeposited(msg.sender, msg.value);
2020     }
2021     
2022     function withdrawEther(uint256 _amount) public
2023     {
2024         require(addressToEtherBalance[msg.sender] >= _amount, "withdrawEther error: insufficient balance to withdraw that much ether");
2025         addressToEtherBalance[msg.sender] -= _amount;
2026         msg.sender.transfer(_amount);
2027         
2028         emit EtherWithdrawn(msg.sender, _amount);
2029     }
2030     
2031     struct BuyOrder
2032     {
2033         address buyer;
2034         uint256 bid;
2035     }
2036     
2037     function depositEtherAndCreateBuyOrder(uint256 _prime, uint256 _bid, uint256 _indexHint) external payable
2038     {
2039         depositEther();
2040         
2041         require(_bid > 0, "createBuyOrder error: bid must be greater than 0");
2042         require(_prime >= 2, "createBuyOrder error: prime must be greater than or equal to 2");
2043         
2044         BuyOrder[] storage buyOrders = primeToBuyOrders[_prime];
2045 
2046         uint256 _index;
2047         
2048         if (_indexHint == buyOrders.length)
2049         {
2050             _index = _indexHint;
2051         }
2052         else if (_indexHint < buyOrders.length &&
2053                  buyOrders[_indexHint].buyer == address(0x0) &&
2054                  buyOrders[_indexHint].bid == 0)
2055         {
2056             _index = _indexHint;
2057         }
2058         else
2059         {
2060             _index = findFreeBuyOrderSlot(_prime);
2061         }
2062         
2063         if (_index == buyOrders.length)
2064         {
2065             buyOrders.length++;
2066         }
2067         
2068         BuyOrder storage buyOrder = buyOrders[_index];
2069         
2070         buyOrder.buyer = msg.sender;
2071         buyOrder.bid = _bid;
2072         
2073         emit BuyOrderCreated(msg.sender, _prime, _index, _bid);
2074         
2075         tryMatchSellAndBuyOrdersRange(_prime, _index, _index);
2076     }
2077     
2078     function modifyBuyOrder(uint256 _prime, uint256 _index, uint256 _newBid) external
2079     {
2080         BuyOrder[] storage buyOrders = primeToBuyOrders[_prime];
2081         require(_index < buyOrders.length, "modifyBuyOrder error: index out of bounds");
2082         
2083         BuyOrder storage buyOrder = buyOrders[_index];
2084         require(buyOrder.buyer == msg.sender, "modifyBuyOrder error: you do not own that buy order");
2085         
2086         emit BuyOrderDestroyed(msg.sender, _prime, _index);
2087         
2088         buyOrder.bid = _newBid;
2089         
2090         emit BuyOrderCreated(msg.sender, _prime, _index, _newBid);
2091     }
2092     
2093 
2094     function tryCancelBuyOrders(uint256[] memory _primes, uint256[] memory _buyOrderIndices) public returns (uint256 _amountCancelled)
2095     {
2096         require(_primes.length == _buyOrderIndices.length, "tryCancelBuyOrders error: invalid input, arrays are not the same length");
2097         
2098         _amountCancelled = 0;
2099         
2100         for (uint256 i=0; i<_primes.length; i++)
2101         {
2102             uint256 index = _buyOrderIndices[i];
2103             uint256 prime = _primes[i];
2104             
2105             BuyOrder[] storage buyOrders = primeToBuyOrders[prime];
2106             if (index < buyOrders.length)
2107             {
2108                 BuyOrder storage buyOrder = buyOrders[index];
2109                 if (buyOrder.buyer == msg.sender)
2110                 {
2111                     emit BuyOrderDestroyed(msg.sender, prime, index);
2112                     
2113                     buyOrder.buyer = address(0x0);
2114                     buyOrder.bid = 0;
2115                     
2116                     _amountCancelled++;
2117                 }
2118             }
2119         }
2120     }
2121 
2122     function setSellPrice(uint256 _prime, uint256 _price, uint256 _matchStartBuyOrderIndex, uint256 _matchEndBuyOrderIndex) external returns (bool _sold)
2123     {
2124         require(isApprovedFor(msg.sender, _prime), "createSellOrder error: you do not have ownership of or approval for that prime");
2125         
2126         primeToSellOrderPrice[_prime] = _price;
2127         
2128         emit SellPriceSet(msg.sender, _prime, _price);
2129         
2130         if (_matchStartBuyOrderIndex != ~uint256(0))
2131         {
2132             return tryMatchSellAndBuyOrdersRange(_prime, _matchStartBuyOrderIndex, _matchEndBuyOrderIndex);
2133         }
2134         else
2135         {
2136             return false;
2137         }
2138     }
2139 
2140     function tryMatchSellAndBuyOrdersRange(uint256 _prime, uint256 _startBuyOrderIndex, uint256 _endBuyOrderIndex) public returns (bool _sold)
2141     {
2142         uint256 sellOrderPrice = primeToSellOrderPrice[_prime];
2143         address seller = getOwner(_prime);
2144         
2145         if (sellOrderPrice == 0 ||
2146             seller == address(0x0))
2147         {
2148             return false;
2149         }
2150         else
2151         {
2152             BuyOrder[] storage buyOrders = primeToBuyOrders[_prime];
2153             
2154             uint256 buyOrders_length = buyOrders.length;
2155 
2156             if (_startBuyOrderIndex > _endBuyOrderIndex ||
2157                 _endBuyOrderIndex >= buyOrders.length)
2158             {
2159                 return false;
2160             }
2161             else
2162             {
2163                 for (uint256 i=_startBuyOrderIndex; i<=_endBuyOrderIndex && i<buyOrders_length; i++)
2164                 {
2165                     BuyOrder storage buyOrder = buyOrders[i];
2166                     address buyer = buyOrder.buyer;
2167                     uint256 bid = buyOrder.bid;
2168                     
2169                     if (bid >= sellOrderPrice &&
2170                         addressToEtherBalance[buyer] >= bid)
2171                     {
2172                         addressToEtherBalance[buyer] -= bid;
2173                         addressToEtherBalance[seller] += bid;
2174                         
2175                         _setOwner(_prime, buyer); // _setOwner sets primeToSellOrderPrice[_prime] = 0
2176                         
2177                         emit BuyOrderDestroyed(buyer, _prime, i);
2178                         emit PrimeTraded(seller, buyer, _prime, i, bid);
2179                         
2180                         buyOrder.buyer = address(0x0);
2181                         buyOrder.bid = 0;
2182                         return true;
2183                     }
2184                 }
2185                 return false;
2186             }
2187         }
2188     }
2189     
2190     
2191     
2192     
2193     
2194     
2195     
2196     
2197     
2198     
2199     
2200     
2201     
2202     ////////////////////////////////////////////////////////////
2203     ////////////////////////////////////////////////////////////
2204     ////////////                                    ////////////
2205     ////////////       Trading view functions       ////////////
2206     ////////////                                    ////////////
2207     ////////////////////////////////////////////////////////////
2208     ////////////////////////////////////////////////////////////
2209     
2210     function countPrimeBuyOrders(uint256 _prime) external view returns (uint256 _amountOfBuyOrders)
2211     {
2212         _amountOfBuyOrders = 0;
2213         
2214         BuyOrder[] storage buyOrders = primeToBuyOrders[_prime];
2215         for (uint256 i=0; i<buyOrders.length; i++)
2216         {
2217             if (buyOrders[i].buyer != address(0x0))
2218             {
2219                 _amountOfBuyOrders++;
2220             }
2221         }
2222     }
2223     
2224     function lengthOfPrimeBuyOrdersArray(uint256 _prime) external view returns (uint256 _lengthOfPrimeBuyOrdersArray)
2225     {
2226         return primeToBuyOrders[_prime].length;
2227     }
2228     
2229     function getPrimeBuyOrder(uint256 _prime, uint256 _index) external view returns (address _buyer, uint256 _bid, bool _buyerHasEnoughFunds)
2230     {
2231        BuyOrder storage buyOrder = primeToBuyOrders[_prime][_index];
2232        
2233        _buyer = buyOrder.buyer;
2234        _bid = buyOrder.bid;
2235        
2236        require(_buyer != address(0x0) && _bid != 0);
2237        
2238        _buyerHasEnoughFunds = addressToEtherBalance[_buyer] >= _bid;
2239     }
2240     
2241     function findFreeBuyOrderSlot(uint256 _prime) public view returns (uint256 _buyOrderSlotIndex)
2242     {
2243         BuyOrder[] storage buyOrders = primeToBuyOrders[_prime];
2244         uint256 len = buyOrders.length;
2245         
2246         for (uint256 i=0; i<len; i++)
2247         {
2248             if (buyOrders[i].buyer == address(0x0) &&
2249                 buyOrders[i].bid == 0)
2250             {
2251                 return i;
2252             }
2253         }
2254         
2255         return len;
2256     }  
2257 
2258     function findHighestBidBuyOrder(uint256 _prime) public view returns (bool _found, uint256 _buyOrderIndex, address _buyer, uint256 _bid)
2259     {
2260         BuyOrder[] storage buyOrders = primeToBuyOrders[_prime];
2261         uint256 highestBidBuyOrderIndexFound = 0;
2262         uint256 highestBidFound = 0;
2263         address highestBidAddress = address(0x0);
2264         for (uint256 i=0; i<buyOrders.length; i++)
2265         {
2266             BuyOrder storage buyOrder = buyOrders[i];
2267             if (buyOrder.bid > highestBidFound &&
2268                 addressToEtherBalance[buyOrder.buyer] >= buyOrder.bid)
2269             {
2270                 highestBidBuyOrderIndexFound = i;
2271                 highestBidFound = buyOrder.bid;
2272                 highestBidAddress = buyOrder.buyer;
2273             }
2274         }
2275         if (highestBidFound == 0)
2276         {
2277             return (false, 0, address(0x0), 0);
2278         }
2279         else
2280         {
2281             return (true, highestBidBuyOrderIndexFound, highestBidAddress, highestBidFound);
2282         }
2283     }
2284     
2285     function findBuyOrdersOfUserOnPrime(address _user, uint256 _prime) external view returns (uint256[] memory _buyOrderIndices, uint256[] memory _bids)
2286     {
2287         BuyOrder[] storage buyOrders = primeToBuyOrders[_prime];
2288         
2289         _buyOrderIndices = new uint256[](buyOrders.length);
2290         _bids = new uint256[](buyOrders.length);
2291         
2292         uint256 amountOfBuyOrdersFound = 0;
2293 
2294         for (uint256 i=0; i<buyOrders.length; i++)
2295         {
2296             BuyOrder storage buyOrder = buyOrders[i];
2297             if (buyOrder.buyer == _user)
2298             {
2299                 _buyOrderIndices[amountOfBuyOrdersFound] = i;
2300                 _bids[amountOfBuyOrdersFound] = buyOrder.bid;
2301                 amountOfBuyOrdersFound++;
2302             }
2303         }
2304         
2305         assembly
2306         {
2307             // _buyOrderIndices.length = amountOfBuyOrdersFound;
2308             mstore(_buyOrderIndices, amountOfBuyOrdersFound)
2309             
2310             // _bids.length = amountOfBuyOrdersFound;
2311             mstore(_bids, amountOfBuyOrdersFound)
2312         }
2313     }
2314     
2315     function findBuyOrdersOnUsersPrimes(address _user) external view returns (uint256[] memory _primes, uint256[] memory _buyOrderIndices, address[] memory _buyers, uint256[] memory _bids, bool[] memory _buyersHaveEnoughFunds)
2316     {
2317         uint256[] storage userPrimes = ownerToPrimes[_user];
2318         
2319         _primes = new uint256[](userPrimes.length);
2320         _buyOrderIndices = new uint256[](userPrimes.length);
2321         _buyers = new address[](userPrimes.length);
2322         _bids = new uint256[](userPrimes.length);
2323         _buyersHaveEnoughFunds = new bool[](userPrimes.length);
2324         
2325         uint256 amountOfBuyOrdersFound = 0;
2326 
2327         for (uint256 i=0; i<userPrimes.length; i++)
2328         {
2329             uint256 prime = userPrimes[i];
2330             
2331             bool found; uint256 buyOrderIndex; address buyer; uint256 bid;
2332             (found, buyOrderIndex, buyer, bid) = findHighestBidBuyOrder(prime);
2333             
2334             if (found == true)
2335             {
2336                 _primes[amountOfBuyOrdersFound] = prime;
2337                 _buyers[amountOfBuyOrdersFound] = buyer;
2338                 _buyOrderIndices[amountOfBuyOrdersFound] = buyOrderIndex;
2339                 _bids[amountOfBuyOrdersFound] = bid;
2340                 _buyersHaveEnoughFunds[amountOfBuyOrdersFound] = addressToEtherBalance[buyer] >= bid;
2341                 amountOfBuyOrdersFound++;
2342             }
2343         }
2344         
2345         assembly
2346         {
2347             // _primes.length = amountOfBuyOrdersFound;
2348             mstore(_primes, amountOfBuyOrdersFound)
2349             
2350             // _buyOrderIndices.length = amountOfBuyOrdersFound;
2351             mstore(_buyOrderIndices, amountOfBuyOrdersFound)
2352             
2353             // _buyers.length = amountOfBuyOrdersFound;
2354             mstore(_buyers, amountOfBuyOrdersFound)
2355             
2356             // _bids.length = amountOfBuyOrdersFound;
2357             mstore(_bids, amountOfBuyOrdersFound)
2358             
2359             // _buyersHaveEnoughFunds.length = amountOfBuyOrdersFound;
2360             mstore(_buyersHaveEnoughFunds, amountOfBuyOrdersFound)
2361         }
2362     }
2363     
2364     
2365     
2366     
2367     
2368     
2369     
2370     
2371     ////////////////////////////////////////////////////////////
2372     ////////////////////////////////////////////////////////////
2373     ////////////                                    ////////////
2374     ////////////   Trading convenience functions    ////////////
2375     ////////////                                    ////////////
2376     ////////////////////////////////////////////////////////////
2377     ////////////////////////////////////////////////////////////
2378     
2379     // These functions don't directly modify state variables.
2380     // They only serve as a wrapper for other functions.
2381     // They do not introduce new state transitions.
2382     
2383     /*function withdrawAllEther() external
2384     {
2385         withdrawEther(addressToEtherBalance[msg.sender]);
2386     }*/
2387     
2388     /*function cancelBuyOrders(uint256[] calldata _primes, uint256[] calldata _buyOrderIndices) external
2389     {
2390         require(tryCancelBuyOrders(_primes, _buyOrderIndices) == _primes.length, "cancelBuyOrders error: not all buy orders could be cancelled");
2391     }*/
2392     
2393     function tryCancelBuyOrdersAndWithdrawEther(uint256[] calldata _primes, uint256[] calldata _buyOrderIndices, uint256 _amountToWithdraw) external returns (uint256 _amountCancelled)
2394     {
2395         withdrawEther(_amountToWithdraw);
2396         return tryCancelBuyOrders(_primes, _buyOrderIndices);
2397     }
2398 }
2399 
2400 contract EtherPrimeChat
2401 {
2402     EtherPrime etherPrime;
2403     
2404     constructor(EtherPrime _etherPrime) public
2405     {
2406         etherPrime = _etherPrime;
2407     }
2408     
2409     // Social
2410     mapping(address => bytes32) public addressToUsername;
2411     mapping(bytes32 => address) public usernameToAddress;
2412     mapping(address => uint256) public addressToGasUsedTowardsChatMessage;
2413     uint256 public constant GAS_PER_CHAT_MESSAGE = 1000000;
2414     address[] public chatMessageSenders;
2415     uint256[] public chatMessageReplyToIndices;
2416     string[] public chatMessages;
2417     
2418     event UsernameSet(address user, bytes32 username);
2419     event ChatMessageSent(address indexed sender, uint256 indexed index, uint256 indexed replyToIndex);
2420     
2421     function setUsername(bytes32 _username) external
2422     {
2423         require(_username[0] != 0x00);
2424         
2425         bool seen0x00 = false;
2426         for (uint256 i=0; i<32; i++)
2427         {
2428             if (_username[i] == 0x00)
2429             {
2430                 seen0x00 = true;
2431             }
2432             
2433             // If there's a non-0x00 after an 0x00, this is not a valid string.
2434             else if (seen0x00)
2435             {
2436                 revert("setUsername error: invalid string; character present after null terminator");
2437             }
2438         }
2439         
2440         require(usernameToAddress[_username] == address(0x0), "setUsername error: that username already exists");
2441         
2442         usernameToAddress[_username] = msg.sender;
2443         addressToUsername[msg.sender] = _username;
2444         
2445         emit UsernameSet(msg.sender, _username);
2446     }
2447     
2448     function amountOfChatMessages() external view returns (uint256)
2449     {
2450         return chatMessages.length;
2451     }
2452     
2453     function getChatMessage(uint256 _index) external view returns (address _sender, string memory _message, uint256 _replyToIndex)
2454     {
2455         require(_index < chatMessages.length, "getChatMessage error: index out of bounds");
2456         
2457         _sender = chatMessageSenders[_index];
2458         _message = chatMessages[_index];
2459         _replyToIndex = chatMessageReplyToIndices[_replyToIndex];
2460     }
2461     
2462     function sendChatMessage(string calldata _message, uint256 _replyToIndex) external
2463     {
2464         require(etherPrime.addressToGasSpent(msg.sender) - addressToGasUsedTowardsChatMessage[msg.sender] >= GAS_PER_CHAT_MESSAGE, "sendChatMessage error: you need to spend more gas on compute() to send a chat message");
2465         require(_replyToIndex == ~uint256(0) || _replyToIndex < chatMessages.length, "sendChatMessage error: invalid reply index");
2466         
2467         addressToGasUsedTowardsChatMessage[msg.sender] += GAS_PER_CHAT_MESSAGE;
2468         
2469         emit ChatMessageSent(msg.sender, chatMessages.length, _replyToIndex);
2470         
2471         chatMessageReplyToIndices.push(_replyToIndex);
2472         chatMessageSenders.push(msg.sender);
2473         chatMessages.push(_message);
2474     }
2475 }