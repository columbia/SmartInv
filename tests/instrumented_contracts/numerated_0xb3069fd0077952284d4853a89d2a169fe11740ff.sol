1 // This contract is a fixed version of the old NFT Sprites contract (0x325a468f3453ea52c5cf3d0fa0ba68d4cbc0f8a4) which had a bug. Do not interact with the old contract.
2 // All the legitimate NFT Sprite owners from the old contract are given their NFT's in this new contract as well.
3 
4 pragma solidity 0.8.0;
5 
6 /**
7  * @dev ERC-721 interface for accepting safe transfers.
8  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
9  */
10 interface ERC721TokenReceiver
11 {
12 
13   /**
14    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
15    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
16    * of other than the magic value MUST result in the transaction being reverted.
17    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
18    * @notice The contract address is always the message sender. A wallet/broker/auction application
19    * MUST implement the wallet interface if it will accept safe transfers.
20    * @param _operator The address which called `safeTransferFrom` function.
21    * @param _from The address which previously owned the token.
22    * @param _tokenId The NFT identifier which is being transferred.
23    * @param _data Additional data with no specified format.
24    * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
25    */
26   function onERC721Received(
27     address _operator,
28     address _from,
29     uint256 _tokenId,
30     bytes calldata _data
31   )
32     external
33     returns(bytes4);
34 
35 }
36 
37 /**
38  * @dev ERC-721 non-fungible token standard.
39  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
40  */
41 interface ERC721
42 {
43 
44   /**
45    * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
46    * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
47    * number of NFTs may be created and assigned without emitting Transfer. At the time of any
48    * transfer, the approved address for that NFT (if any) is reset to none.
49    */
50   event Transfer(
51     address indexed _from,
52     address indexed _to,
53     uint256 indexed _tokenId
54   );
55 
56   /**
57    * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
58    * address indicates there is no approved address. When a Transfer event emits, this also
59    * indicates that the approved address for that NFT (if any) is reset to none.
60    */
61   event Approval(
62     address indexed _owner,
63     address indexed _approved,
64     uint256 indexed _tokenId
65   );
66 
67   /**
68    * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
69    * all NFTs of the owner.
70    */
71   event ApprovalForAll(
72     address indexed _owner,
73     address indexed _operator,
74     bool _approved
75   );
76 
77   /**
78    * @dev Transfers the ownership of an NFT from one address to another address.
79    * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
80    * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
81    * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
82    * function checks if `_to` is a smart contract (code size > 0). If so, it calls
83    * `onERC721Received` on `_to` and throws if the return value is not
84    * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
85    * @param _from The current owner of the NFT.
86    * @param _to The new owner.
87    * @param _tokenId The NFT to transfer.
88    * @param _data Additional data with no specified format, sent in call to `_to`.
89    */
90   function safeTransferFrom(
91     address _from,
92     address _to,
93     uint256 _tokenId,
94     bytes calldata _data
95   )
96     external;
97 
98   /**
99    * @dev Transfers the ownership of an NFT from one address to another address.
100    * @notice This works identically to the other function with an extra data parameter, except this
101    * function just sets data to ""
102    * @param _from The current owner of the NFT.
103    * @param _to The new owner.
104    * @param _tokenId The NFT to transfer.
105    */
106   function safeTransferFrom(
107     address _from,
108     address _to,
109     uint256 _tokenId
110   )
111     external;
112 
113   /**
114    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
115    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
116    * address. Throws if `_tokenId` is not a valid NFT.
117    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
118    * they mayb be permanently lost.
119    * @param _from The current owner of the NFT.
120    * @param _to The new owner.
121    * @param _tokenId The NFT to transfer.
122    */
123   function transferFrom(
124     address _from,
125     address _to,
126     uint256 _tokenId
127   )
128     external;
129 
130   /**
131    * @dev Set or reaffirm the approved address for an NFT.
132    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
133    * the current NFT owner, or an authorized operator of the current owner.
134    * @param _approved The new approved NFT controller.
135    * @param _tokenId The NFT to approve.
136    */
137   function approve(
138     address _approved,
139     uint256 _tokenId
140   )
141     external;
142 
143   /**
144    * @dev Enables or disables approval for a third party ("operator") to manage all of
145    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
146    * @notice The contract MUST allow multiple operators per owner.
147    * @param _operator Address to add to the set of authorized operators.
148    * @param _approved True if the operators is approved, false to revoke approval.
149    */
150   function setApprovalForAll(
151     address _operator,
152     bool _approved
153   )
154     external;
155 
156   /**
157    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
158    * considered invalid, and this function throws for queries about the zero address.
159    * @param _owner Address for whom to query the balance.
160    * @return Balance of _owner.
161    */
162   function balanceOf(
163     address _owner
164   )
165     external
166     view
167     returns (uint256);
168 
169   /**
170    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
171    * invalid, and queries about them do throw.
172    * @param _tokenId The identifier for an NFT.
173    * @return Address of _tokenId owner.
174    */
175   function ownerOf(
176     uint256 _tokenId
177   )
178     external
179     view
180     returns (address);
181 
182   /**
183    * @dev Get the approved address for a single NFT.
184    * @notice Throws if `_tokenId` is not a valid NFT.
185    * @param _tokenId The NFT to find the approved address for.
186    * @return Address that _tokenId is approved for.
187    */
188   function getApproved(
189     uint256 _tokenId
190   )
191     external
192     view
193     returns (address);
194 
195   /**
196    * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
197    * @param _owner The address that owns the NFTs.
198    * @param _operator The address that acts on behalf of the owner.
199    * @return True if approved for all, false otherwise.
200    */
201   function isApprovedForAll(
202     address _owner,
203     address _operator
204   )
205     external
206     view
207     returns (bool);
208 
209 }
210 
211 
212 /**
213  * @dev Utility library of inline functions on addresses.
214  * @notice Based on:
215  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
216  * Requires EIP-1052.
217  */
218 library AddressUtils
219 {
220 
221   /**
222    * @dev Returns whether the target address is a contract.
223    * @param _addr Address to check.
224    * @return addressCheck True if _addr is a contract, false if not.
225    */
226   function isContract(
227     address _addr
228   )
229     internal
230     view
231     returns (bool addressCheck)
232   {
233     // This method relies in extcodesize, which returns 0 for contracts in
234     // construction, since the code is only stored at the end of the
235     // constructor execution.
236 
237     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
238     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
239     // for accounts without code, i.e. `keccak256('')`
240     bytes32 codehash;
241     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
242     assembly { codehash := extcodehash(_addr) } // solhint-disable-line
243     addressCheck = (codehash != 0x0 && codehash != accountHash);
244   }
245 
246 }
247 
248 
249 interface ERC165
250 {
251 
252   /**
253    * @dev Checks if the smart contract includes a specific interface.
254    * This function uses less than 30,000 gas.
255    * @param _interfaceID The interface identifier, as specified in ERC-165.
256    * @return True if _interfaceID is supported, false otherwise.
257    */
258   function supportsInterface(
259     bytes4 _interfaceID
260   )
261     external
262     view
263     returns (bool);
264     
265 }
266 
267 /**
268  * @dev Implementation of standard for detect smart contract interfaces.
269  */
270 contract SupportsInterface is
271   ERC165
272 {
273 
274   /**
275    * @dev Mapping of supported intefraces. You must not set element 0xffffffff to true.
276    */
277   mapping(bytes4 => bool) internal supportedInterfaces;
278 
279   /**
280    * @dev Contract constructor.
281    */
282   constructor()
283   {
284     supportedInterfaces[0x01ffc9a7] = true; // ERC165
285   }
286 
287   /**
288    * @dev Function to check which interfaces are suported by this contract.
289    * @param _interfaceID Id of the interface.
290    * @return True if _interfaceID is supported, false otherwise.
291    */
292   function supportsInterface(
293     bytes4 _interfaceID
294   )
295     external
296     override
297     view
298     returns (bool)
299   {
300     return supportedInterfaces[_interfaceID];
301   }
302 
303 }
304 
305 
306 
307 contract NFTSprites is
308   ERC721,
309   SupportsInterface
310 {
311   using AddressUtils for address;
312 
313   /**
314    * @dev List of revert message codes. Implementing dApp should handle showing the correct message.
315    * Based on 0xcert framework error codes.
316    */
317   string constant ZERO_ADDRESS = "003001";
318   string constant NOT_VALID_NFT = "003002";
319   string constant NOT_OWNER_OR_OPERATOR = "003003";
320   string constant NOT_OWNER_APPROVED_OR_OPERATOR = "003004";
321   string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
322   string constant NFT_ALREADY_EXISTS = "003006";
323   string constant NOT_OWNER = "003007";
324   string constant IS_OWNER = "003008";
325   
326   string internal nftName = "NFT Sprites";
327   string internal nftSymbol = "NFTS";
328   
329   uint public latestNewSpriteForSale;
330   
331   address owner;
332     
333   struct Sprite {
334     address owner;
335     bool currentlyForSale;
336     uint price;
337     uint timesSold;
338   }
339   
340   mapping (uint => Sprite) public sprites;
341   
342   function getSpriteInfo (uint spriteNumber) public view returns (address, bool, uint, uint) {
343     return (sprites[spriteNumber].owner, sprites[spriteNumber].currentlyForSale, sprites[spriteNumber].price, sprites[spriteNumber].timesSold);
344   }
345   
346   // ownerOf does this as well
347   function getSpriteOwner (uint spriteNumber) public view returns (address) {
348     return (sprites[spriteNumber].owner);
349   }
350   
351   mapping (address => uint[]) public spriteOwners;
352   function spriteOwningHistory (address _address) public view returns (uint[] memory owningHistory) {
353     owningHistory = spriteOwners[_address];
354   }
355   
356   function name() external view returns (string memory _name) {
357     _name = nftName;
358   }
359   
360   function symbol() external view returns (string memory _symbol) {
361     _symbol = nftSymbol;
362   }
363 
364   /**
365    * @dev Magic value of a smart contract that can recieve NFT.
366    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
367    */
368   bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
369 
370   /**
371    * @dev A mapping from NFT ID to the address that owns it.
372    */
373   mapping (uint256 => address) internal idToOwner;
374 
375   /**
376    * @dev Mapping from NFT ID to approved address.
377    */
378   mapping (uint256 => address) internal idToApproval;
379 
380    /**
381    * @dev Mapping from owner address to count of his tokens.
382    */
383   mapping (address => uint256) private ownerToNFTokenCount;
384 
385   /**
386    * @dev Mapping from owner address to mapping of operator addresses.
387    */
388   mapping (address => mapping (address => bool)) internal ownerToOperators;
389 
390   /**
391    * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
392    * @param _tokenId ID of the NFT to validate.
393    */
394   modifier canOperate(uint256 _tokenId) {
395     address tokenOwner = idToOwner[_tokenId];
396     require(
397       tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
398       NOT_OWNER_OR_OPERATOR
399     );
400     _;
401   }
402 
403   /**
404    * @dev Guarantees that the msg.sender is allowed to transfer NFT.
405    * @param _tokenId ID of the NFT to transfer.
406    */
407    
408    // idToApproval[_tokenId] = _approved;
409    
410   modifier canTransfer(uint256 _tokenId) {
411     address tokenOwner = idToOwner[_tokenId];
412     require(
413       tokenOwner == msg.sender
414       || idToApproval[_tokenId] == msg.sender
415       || ownerToOperators[tokenOwner][msg.sender],
416       NOT_OWNER_APPROVED_OR_OPERATOR
417     );
418     _;
419   }
420 
421   /**
422    * @dev Guarantees that _tokenId is a valid Token.
423    * @param _tokenId ID of the NFT to validate.
424    */
425   modifier validNFToken(uint256 _tokenId) {
426     require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
427     _;
428   }
429 
430   /**
431    * @dev Contract constructor.
432    */
433   constructor() {
434     supportedInterfaces[0x80ac58cd] = true; // ERC721
435     
436     // Below all the legitimate NFT Sprite owners from the old contract are given their NFT's in this new contract (can only be called once, when this contract is deployed).
437     
438     // original buyers
439     ownerToNFTokenCount[0xDE6Ad599B2b669dA30525af0820D0a27ca5fdA6f] = 1;
440     ownerToNFTokenCount[0x7DF397FB4981f2708931c3163eFA81be41C13302] = 1;
441     ownerToNFTokenCount[0xC9f203B4692c04bA7155Ef71d8f5D42bfCfbC09B] = 1;
442     ownerToNFTokenCount[0x48e4dd3e356823070D9d1B7d162d072aE9EFE0Cb] = 1;
443     ownerToNFTokenCount[0xbf67e713ddEf50496c6F27C41Eaeecee3A9FA063] = 1;
444     ownerToNFTokenCount[0x1A200f926A078400961B47C8965E57e1573C293C] = 1;
445     ownerToNFTokenCount[0xd161F45C77cdBaa63bd59137d2773462924AfeDe] = 1;
446     ownerToNFTokenCount[0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA] = 3;
447     ownerToNFTokenCount[0x172d894dB40435D04A099e081eade6492D3E71a8] = 2;
448     ownerToNFTokenCount[0xE2008Ef79a7d0D75EdAE70263384D4aC5D1A9f9A] = 1;
449     ownerToNFTokenCount[0xB117a08963Db62c31070eEdff0e192176251a3Fb] = 1;
450     ownerToNFTokenCount[0x375D4DE9c37B3b93e4C0af0E58D54F7DFF06cC16] = 1;
451     ownerToNFTokenCount[0xe4446D52e2bdB3E31470643Ab1753a4c2aEee3eA] = 2;
452     ownerToNFTokenCount[0x4202C5Aa18c934B96Bc4aEDB3DA4593c44076618] = 1;
453     ownerToNFTokenCount[0x7B167965d0449D27476eF236a8B6A02d5ABd27C4] = 1;
454     ownerToNFTokenCount[0x40D80168B6663700B6AE55d71a8c2Cf61d0C1225] = 1;
455     
456     // addresses that received an NFT from an owner transferring it to them
457     ownerToNFTokenCount[0x070DcB7ba170091F84783b224489aA8B280c1A30] = 1;
458     ownerToNFTokenCount[0x6747B33F4293fB4fD1bEaa5D7935F85d5958b684] = 1;
459     ownerToNFTokenCount[0xcDb89f98012b5755B4874CBf6E8787b18996c69D] = 1;
460     
461     sprites[0].owner = 0xDE6Ad599B2b669dA30525af0820D0a27ca5fdA6f;
462     sprites[0].currentlyForSale = false;
463     sprites[0].price = (10**15)*5;
464     sprites[0].timesSold = 1;
465     idToOwner[0] = 0xDE6Ad599B2b669dA30525af0820D0a27ca5fdA6f;
466     spriteOwners[0xDE6Ad599B2b669dA30525af0820D0a27ca5fdA6f].push(0);
467     
468     sprites[1].owner = 0x7DF397FB4981f2708931c3163eFA81be41C13302;
469     sprites[1].currentlyForSale = false;
470     sprites[1].price = (10**15)*5;
471     sprites[1].timesSold = 1;
472     idToOwner[1] = 0x7DF397FB4981f2708931c3163eFA81be41C13302;
473     spriteOwners[0x7DF397FB4981f2708931c3163eFA81be41C13302].push(1);
474     
475     sprites[2].owner = 0xC9f203B4692c04bA7155Ef71d8f5D42bfCfbC09B;
476     sprites[2].currentlyForSale = false;
477     sprites[2].price = 2**2 * (10**15)*5;
478     sprites[2].timesSold = 1;
479     idToOwner[2] = 0xC9f203B4692c04bA7155Ef71d8f5D42bfCfbC09B;
480     spriteOwners[0xC9f203B4692c04bA7155Ef71d8f5D42bfCfbC09B].push(2);
481     
482     sprites[3].owner = 0xcDb89f98012b5755B4874CBf6E8787b18996c69D; // original owner was 0xC9f203B4692c04bA7155Ef71d8f5D42bfCfbC09B, who later transferred it to this new owner: https://etherscan.io/tx/0x48602caef82ae441cd0bc15010d9027c3317573ac80cea73f01d157c82000bd4
483     sprites[3].currentlyForSale = false;
484     sprites[3].price = 3**2 * (10**15)*5;
485     sprites[3].timesSold = 1;
486     idToOwner[3] = 0xcDb89f98012b5755B4874CBf6E8787b18996c69D;
487     spriteOwners[0xcDb89f98012b5755B4874CBf6E8787b18996c69D].push(3);
488     
489     sprites[4].owner = 0x48e4dd3e356823070D9d1B7d162d072aE9EFE0Cb;
490     sprites[4].currentlyForSale = false;
491     sprites[4].price = 4**2 * (10**15)*5;
492     sprites[4].timesSold = 1;
493     idToOwner[4] = 0x48e4dd3e356823070D9d1B7d162d072aE9EFE0Cb;
494     spriteOwners[0x48e4dd3e356823070D9d1B7d162d072aE9EFE0Cb].push(4);
495     
496     sprites[5].owner = 0xbf67e713ddEf50496c6F27C41Eaeecee3A9FA063;
497     sprites[5].currentlyForSale = false;
498     sprites[5].price = 5**2 * (10**15)*5;
499     sprites[5].timesSold = 1;
500     idToOwner[5] = 0xbf67e713ddEf50496c6F27C41Eaeecee3A9FA063;
501     spriteOwners[0xbf67e713ddEf50496c6F27C41Eaeecee3A9FA063].push(5);
502     
503     sprites[6].owner = 0x1A200f926A078400961B47C8965E57e1573C293C;
504     sprites[6].currentlyForSale = false;
505     sprites[6].price = 6**2 * (10**15)*5;
506     sprites[6].timesSold = 1;
507     idToOwner[6] = 0x1A200f926A078400961B47C8965E57e1573C293C;
508     spriteOwners[0x1A200f926A078400961B47C8965E57e1573C293C].push(6);
509     
510     sprites[7].owner = 0xd161F45C77cdBaa63bd59137d2773462924AfeDe;
511     sprites[7].currentlyForSale = false;
512     sprites[7].price = 7**2 * (10**15)*5;
513     sprites[7].timesSold = 1;
514     idToOwner[7] = 0xd161F45C77cdBaa63bd59137d2773462924AfeDe;
515     spriteOwners[0xd161F45C77cdBaa63bd59137d2773462924AfeDe].push(7);
516     
517     sprites[8].owner = 0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA;
518     sprites[8].currentlyForSale = false;
519     sprites[8].price = 8**2 * (10**15)*5;
520     sprites[8].timesSold = 1;
521     idToOwner[8] = 0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA;
522     spriteOwners[0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA].push(8);
523     
524     sprites[9].owner = 0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA;
525     sprites[9].currentlyForSale = false;
526     sprites[9].price = 9**2 * (10**15)*5;
527     sprites[9].timesSold = 1;
528     idToOwner[9] = 0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA;
529     spriteOwners[0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA].push(9);
530     
531     sprites[10].owner = 0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA;
532     sprites[10].currentlyForSale = false;
533     sprites[10].price = 10**2 * (10**15)*5;
534     sprites[10].timesSold = 1;
535     idToOwner[10] = 0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA;
536     spriteOwners[0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA].push(10);
537     
538     sprites[11].owner = 0x172d894dB40435D04A099e081eade6492D3E71a8;
539     sprites[11].currentlyForSale = false;
540     sprites[11].price = 11**2 * (10**15)*5;
541     sprites[11].timesSold = 1;
542     idToOwner[11] = 0x172d894dB40435D04A099e081eade6492D3E71a8;
543     spriteOwners[0x172d894dB40435D04A099e081eade6492D3E71a8].push(11);
544     
545     sprites[12].owner = 0xE2008Ef79a7d0D75EdAE70263384D4aC5D1A9f9A;
546     sprites[12].currentlyForSale = false;
547     sprites[12].price = 12**2 * (10**15)*5;
548     sprites[12].timesSold = 1;
549     idToOwner[12] = 0xE2008Ef79a7d0D75EdAE70263384D4aC5D1A9f9A;
550     spriteOwners[0xE2008Ef79a7d0D75EdAE70263384D4aC5D1A9f9A].push(12);
551     
552     sprites[13].owner = 0xB117a08963Db62c31070eEdff0e192176251a3Fb;
553     sprites[13].currentlyForSale = false;
554     sprites[13].price = 13**2 * (10**15)*5;
555     sprites[13].timesSold = 1;
556     idToOwner[13] = 0xB117a08963Db62c31070eEdff0e192176251a3Fb;
557     spriteOwners[0xB117a08963Db62c31070eEdff0e192176251a3Fb].push(13);
558     
559     sprites[14].owner = 0x375D4DE9c37B3b93e4C0af0E58D54F7DFF06cC16;
560     sprites[14].currentlyForSale = false;
561     sprites[14].price = 14**2 * (10**15)*5;
562     sprites[14].timesSold = 1;
563     idToOwner[14] = 0x375D4DE9c37B3b93e4C0af0E58D54F7DFF06cC16;
564     spriteOwners[0x375D4DE9c37B3b93e4C0af0E58D54F7DFF06cC16].push(14);
565     
566     sprites[15].owner = 0x070DcB7ba170091F84783b224489aA8B280c1A30; // original owner was 0xd9c3415Bf8600f007A1b4199DF967C25A3E00EeA, who later transferred it to this new owner: https://etherscan.io/tx/0xe2427b79bb545188468cba61a8ffc8a1f69ce1ce60f66a4ac18ac9f883336d22
567     sprites[15].currentlyForSale = false;
568     sprites[15].price = 15**2 * (10**15)*5;
569     sprites[15].timesSold = 1;
570     idToOwner[15] = 0x070DcB7ba170091F84783b224489aA8B280c1A30;
571     spriteOwners[0x070DcB7ba170091F84783b224489aA8B280c1A30].push(15);
572     
573     sprites[16].owner = 0x172d894dB40435D04A099e081eade6492D3E71a8;
574     sprites[16].currentlyForSale = false;
575     sprites[16].price = 16**2 * (10**15)*5;
576     sprites[16].timesSold = 1;
577     idToOwner[16] = 0x172d894dB40435D04A099e081eade6492D3E71a8;
578     spriteOwners[0x172d894dB40435D04A099e081eade6492D3E71a8].push(16);
579     
580     sprites[17].owner = 0xe4446D52e2bdB3E31470643Ab1753a4c2aEee3eA;
581     sprites[17].currentlyForSale = false;
582     sprites[17].price = 17**2 * (10**15)*5;
583     sprites[17].timesSold = 1;
584     idToOwner[17] = 0xe4446D52e2bdB3E31470643Ab1753a4c2aEee3eA;
585     spriteOwners[0xe4446D52e2bdB3E31470643Ab1753a4c2aEee3eA].push(17);
586     
587     sprites[18].owner = 0xe4446D52e2bdB3E31470643Ab1753a4c2aEee3eA;
588     sprites[18].currentlyForSale = false;
589     sprites[18].price = 18**2 * (10**15)*5;
590     sprites[18].timesSold = 1;
591     idToOwner[18] = 0xe4446D52e2bdB3E31470643Ab1753a4c2aEee3eA;
592     spriteOwners[0xe4446D52e2bdB3E31470643Ab1753a4c2aEee3eA].push(18);
593     
594     sprites[19].owner = 0x4202C5Aa18c934B96Bc4aEDB3DA4593c44076618;
595     sprites[19].currentlyForSale = false;
596     sprites[19].price = 19**2 * (10**15)*5;
597     sprites[19].timesSold = 1;
598     idToOwner[19] = 0x4202C5Aa18c934B96Bc4aEDB3DA4593c44076618;
599     spriteOwners[0x4202C5Aa18c934B96Bc4aEDB3DA4593c44076618].push(19);
600     
601     sprites[20].owner = 0x7B167965d0449D27476eF236a8B6A02d5ABd27C4;
602     sprites[20].currentlyForSale = false;
603     sprites[20].price = 20**2 * (10**15)*5;
604     sprites[20].timesSold = 1;
605     idToOwner[20] = 0x7B167965d0449D27476eF236a8B6A02d5ABd27C4;
606     spriteOwners[0x7B167965d0449D27476eF236a8B6A02d5ABd27C4].push(20);
607     
608     sprites[21].owner = 0x40D80168B6663700B6AE55d71a8c2Cf61d0C1225;
609     sprites[21].currentlyForSale = false;
610     sprites[21].price = 21**2 * (10**15)*5;
611     sprites[21].timesSold = 1;
612     idToOwner[21] = 0x40D80168B6663700B6AE55d71a8c2Cf61d0C1225;
613     spriteOwners[0x40D80168B6663700B6AE55d71a8c2Cf61d0C1225].push(21);
614     
615     sprites[22].owner = 0x6747B33F4293fB4fD1bEaa5D7935F85d5958b684; // original owner was 0x9e4a9b4334f3167bc7dd35f48f2238c73f532baf, who later transferred it to this new owner: https://etherscan.io/tx/0x85f5486c54ae8fd9b6bd73ed524835a0517f816d50f40273e74e1df706309db2
616     sprites[22].currentlyForSale = false;
617     sprites[22].price = 22**2 * (10**15)*5;
618     sprites[22].timesSold = 1;
619     idToOwner[22] = 0x6747B33F4293fB4fD1bEaa5D7935F85d5958b684;
620     spriteOwners[0x6747B33F4293fB4fD1bEaa5D7935F85d5958b684].push(22);
621     
622     latestNewSpriteForSale = 23;
623     
624     sprites[23].currentlyForSale = true;
625     sprites[23].price = 23**2 * (10**15)*5;
626     
627     owner = msg.sender;
628   }
629     
630   function buySprite (uint spriteNumber) public payable {
631     require(sprites[spriteNumber].currentlyForSale == true);
632     require(msg.value == sprites[spriteNumber].price);
633     require(spriteNumber < 100);
634     sprites[spriteNumber].timesSold++;
635     spriteOwners[msg.sender].push(spriteNumber);
636     sprites[spriteNumber].currentlyForSale = false;
637     if (spriteNumber != latestNewSpriteForSale) {
638         // buying sprite that is already owned from someone
639         // give existing sprite owner their money
640         address currentSpriteOwner = getSpriteOwner(spriteNumber);
641         payable(currentSpriteOwner).transfer(msg.value);
642         // have to approve msg.sender for NFT to be transferred
643         idToApproval[spriteNumber] = msg.sender;
644         // _safeTransferFrom calls _transfer which updates the sprite owner to msg.sender and clears approvals
645         _safeTransferFrom(currentSpriteOwner, msg.sender, spriteNumber, "");
646     } else {
647         // buying brand new latest sprite
648         sprites[spriteNumber].owner = msg.sender;
649         if (latestNewSpriteForSale != 99) {
650             latestNewSpriteForSale++;
651             sprites[latestNewSpriteForSale].price = latestNewSpriteForSale**2 * (10**15)*5;
652             sprites[latestNewSpriteForSale].currentlyForSale = true;
653         }
654         _mint(msg.sender, spriteNumber);
655     }
656   }
657   
658   function sellSprite (uint spriteNumber, uint price) public {
659     require(msg.sender == sprites[spriteNumber].owner);
660     require(price > 0);
661     sprites[spriteNumber].price = price;
662     sprites[spriteNumber].currentlyForSale = true;
663   }
664   
665   function dontSellSprite (uint spriteNumber) public {
666     require(msg.sender == sprites[spriteNumber].owner);
667     sprites[spriteNumber].currentlyForSale = false;
668   }
669   
670   function giftSprite (uint spriteNumber, address receiver) public {
671     require(msg.sender == sprites[spriteNumber].owner);
672     require(receiver != address(0), ZERO_ADDRESS);
673     spriteOwners[receiver].push(spriteNumber);
674     _safeTransferFrom(msg.sender, receiver, spriteNumber, "");
675   }
676   
677   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external override {
678     _safeTransferFrom(_from, _to, _tokenId, _data);
679   }
680   
681   /**
682    * @dev Transfers the ownership of an NFT from one address to another address. This function can
683    * be changed to payable.
684    * @notice This works identically to the other function with an extra data parameter, except this
685    * function just sets data to ""
686    * @param _from The current owner of the NFT.
687    * @param _to The new owner.
688    * @param _tokenId The NFT to transfer.
689    */
690   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external override {
691     _safeTransferFrom(_from, _to, _tokenId, "");
692   }
693 
694   /**
695    * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
696    * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
697    * the current NFT owner, or an authorized operator of the current owner.
698    * @param _approved Address to be approved for the given NFT ID.
699    * @param _tokenId ID of the token to be approved.
700    */
701   function approve(address _approved, uint256 _tokenId) external override canOperate(_tokenId) validNFToken(_tokenId) {
702     address tokenOwner = idToOwner[_tokenId];
703     require(_approved != tokenOwner, IS_OWNER);
704 
705     idToApproval[_tokenId] = _approved;
706     emit Approval(tokenOwner, _approved, _tokenId);
707   }
708 
709   /**
710    * @dev Enables or disables approval for a third party ("operator") to manage all of
711    * `msg.sender`'s assets. It also emits the ApprovalForAll event.
712    * @notice This works even if sender doesn't own any tokens at the time.
713    * @param _operator Address to add to the set of authorized operators.
714    * @param _approved True if the operators is approved, false to revoke approval.
715    */
716   function setApprovalForAll(address _operator, bool _approved) external override {
717     ownerToOperators[msg.sender][_operator] = _approved;
718     emit ApprovalForAll(msg.sender, _operator, _approved);
719   }
720 
721   /**
722    * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
723    * considered invalid, and this function throws for queries about the zero address.
724    * @param _owner Address for whom to query the balance.
725    * @return Balance of _owner.
726    */
727   function balanceOf(address _owner) external override view returns (uint256) {
728     require(_owner != address(0), ZERO_ADDRESS);
729     return _getOwnerNFTCount(_owner);
730   }
731 
732   /**
733    * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
734    * invalid, and queries about them do throw.
735    * @param _tokenId The identifier for an NFT.
736    * @return _owner Address of _tokenId owner.
737    */
738   function ownerOf(uint256 _tokenId) external override view returns (address _owner) {
739     _owner = idToOwner[_tokenId];
740     require(_owner != address(0), NOT_VALID_NFT);
741   }
742 
743   /**
744    * @dev Get the approved address for a single NFT.
745    * @notice Throws if `_tokenId` is not a valid NFT.
746    * @param _tokenId ID of the NFT to query the approval of.
747    * @return Address that _tokenId is approved for.
748    */
749   function getApproved(uint256 _tokenId) external override view validNFToken(_tokenId) returns (address) {
750     return idToApproval[_tokenId];
751   }
752 
753   /**
754    * @dev Checks if `_operator` is an approved operator for `_owner`.
755    * @param _owner The address that owns the NFTs.
756    * @param _operator The address that acts on behalf of the owner.
757    * @return True if approved for all, false otherwise.
758    */
759   function isApprovedForAll(address _owner, address _operator) external override view returns (bool) {
760     return ownerToOperators[_owner][_operator];
761   }
762 
763   /**
764    * @dev Actually preforms the transfer.
765    * @notice Does NO checks.
766    * @param _to Address of a new owner.
767    * @param _tokenId The NFT that is being transferred.
768    */
769   function _transfer(address _to, uint256 _tokenId) internal {
770     address from = idToOwner[_tokenId];
771     _clearApproval(_tokenId);
772 
773     _removeNFToken(from, _tokenId);
774     _addNFToken(_to, _tokenId);
775     
776     sprites[_tokenId].owner = _to;
777 
778     emit Transfer(from, _to, _tokenId);
779   }
780 
781   /**
782    * @dev Mints a new NFT.
783    * @notice This is an internal function which should be called from user-implemented external
784    * mint function. Its purpose is to show and properly initialize data structures when using this
785    * implementation.
786    * @param _to The address that will own the minted NFT.
787    * @param _tokenId of the NFT to be minted by the msg.sender.
788    */
789   function _mint(address _to, uint256 _tokenId) internal virtual {
790     require(_to != address(0), ZERO_ADDRESS);
791     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
792 
793     _addNFToken(_to, _tokenId);
794 
795     emit Transfer(address(0), _to, _tokenId);
796   }
797 
798   /**
799    * @dev Burns a NFT.
800    * @notice This is an internal function which should be called from user-implemented external burn
801    * function. Its purpose is to show and properly initialize data structures when using this
802    * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
803    * NFT.
804    * @param _tokenId ID of the NFT to be burned.
805    */
806   function _burn(uint256 _tokenId) internal virtual validNFToken(_tokenId) {
807     address tokenOwner = idToOwner[_tokenId];
808     _clearApproval(_tokenId);
809     _removeNFToken(tokenOwner, _tokenId);
810     emit Transfer(tokenOwner, address(0), _tokenId);
811   }
812   
813   /**
814    * @dev Removes a NFT from owner.
815    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
816    * @param _from Address from wich we want to remove the NFT.
817    * @param _tokenId Which NFT we want to remove.
818    */
819   function _removeNFToken(address _from, uint256 _tokenId) internal virtual {
820     require(idToOwner[_tokenId] == _from, NOT_OWNER);
821     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from]--;
822     delete idToOwner[_tokenId];
823   }
824 
825   /**
826    * @dev Assignes a new NFT to owner.
827    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
828    * @param _to Address to wich we want to add the NFT.
829    * @param _tokenId Which NFT we want to add.
830    */
831   function _addNFToken(address _to, uint256 _tokenId) internal virtual {
832     require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
833 
834     idToOwner[_tokenId] = _to;
835     ownerToNFTokenCount[_to]++;
836   }
837 
838   /**
839    * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
840    * extension to remove double storage (gas optimization) of owner nft count.
841    * @param _owner Address for whom to query the count.
842    * @return Number of _owner NFTs.
843    */
844   function _getOwnerNFTCount(address _owner) internal virtual view returns (uint256) {
845     return ownerToNFTokenCount[_owner];
846   }
847 
848   /**
849    * @dev Actually perform the safeTransferFrom.
850    * @param _from The current owner of the NFT.
851    * @param _to The new owner.
852    * @param _tokenId The NFT to transfer.
853    * @param _data Additional data with no specified format, sent in call to `_to`.
854    */
855   function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) private canTransfer(_tokenId) validNFToken(_tokenId) {
856     address tokenOwner = idToOwner[_tokenId];
857     require(tokenOwner == _from, NOT_OWNER);
858     require(_to != address(0), ZERO_ADDRESS);
859 
860     _transfer(_to, _tokenId);
861 
862     // isContract is function from address-utils.sol
863     if (_to.isContract()) {
864       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
865       require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
866     }
867   }
868 
869   /**
870    * @dev Clears the current approval of a given NFT ID.
871    * @param _tokenId ID of the NFT to be transferred.
872    */
873   function _clearApproval(uint256 _tokenId) private {
874     if (idToApproval[_tokenId] != address(0)) {
875       delete idToApproval[_tokenId];
876     }
877   }
878   
879   modifier onlyOwner {
880     require(msg.sender == owner);
881     _;
882   }
883   
884   function withdraw() public onlyOwner {
885     payable(owner).transfer(address(this).balance);
886   }
887   
888     /**
889    * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
890    * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
891    * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
892    * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
893    * they maybe be permanently lost.
894    * @param _from The current owner of the NFT.
895    * @param _to The new owner.
896    * @param _tokenId The NFT to transfer.
897    */
898   function transferFrom(address _from, address _to, uint256 _tokenId) external override canTransfer(_tokenId) validNFToken(_tokenId) {
899     address tokenOwner = idToOwner[_tokenId];
900     require(tokenOwner == _from, NOT_OWNER);
901     require(_to != address(0), ZERO_ADDRESS);
902 
903     _transfer(_to, _tokenId);
904   }
905   
906 }