1 pragma solidity ^0.4.23;
2 
3 
4 /**contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata
5  * Utility library of inline functions on addresses
6  */
7 library AddressUtils {
8 
9   /**
10    * Returns whether the target address is a contract
11    * @dev This function will return false if invoked during the constructor of a contract,
12    *  as the code is not actually created until after the constructor finishes.
13    * @param addr address to check
14    * @return whether the target address is a contract
15    */
16   function isContract(address addr) internal view returns (bool) {
17     uint256 size;
18     // XXX Currently there is no better way to check if there is a contract in an address
19     // than to check the size of the code at that address.
20     // See https://ethereum.stackexchange.com/a/14016/36603
21     // for more details about how this works.
22     // TODO Check this again before the Serenity release, because all addresses will be
23     // contracts then.
24     // solium-disable-next-line security/no-inline-assembly
25     assembly { size := extcodesize(addr) }
26     return size > 0;
27   }
28 
29 }
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
37     // benefit is lost if 'b' is also tested.
38     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39     if (a == 0) {
40       return 0;
41     }
42 
43     c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers, truncating the quotient.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     // uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return a / b;
56   }
57 
58   /**
59   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60   */
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   /**
67   * @dev Adds two numbers, throws on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 contract ERC721Basic {
77   event Transfer(
78     address indexed _from,
79     address indexed _to,
80     uint256 _tokenId
81   );
82   event Approval(
83     address indexed _owner,
84     address indexed _approved,
85     uint256 _tokenId
86   );
87   event ApprovalForAll(
88     address indexed _owner,
89     address indexed _operator,
90     bool _approved
91   );
92 
93   function balanceOf(address _owner) public view returns (uint256 _balance);
94   function ownerOf(uint256 _tokenId) public view returns (address _owner);
95   function exists(uint256 _tokenId) public view returns (bool _exists);
96 
97   function approve(address _to, uint256 _tokenId) public;
98   function getApproved(uint256 _tokenId)
99     public view returns (address _operator);
100 
101   function setApprovalForAll(address _operator, bool _approved) public;
102   function isApprovedForAll(address _owner, address _operator)
103     public view returns (bool);
104 
105   function transferFrom(address _from, address _to, uint256 _tokenId) public;
106   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
107     public;
108 
109   function safeTransferFrom(
110     address _from,
111     address _to,
112     uint256 _tokenId,
113     bytes _data
114   )
115     public;
116 }
117 
118 contract ERC721Receiver {
119   /**
120    * @dev Magic value to be returned upon successful reception of an NFT
121    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
122    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
123    */
124   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
125 
126   /**
127    * @notice Handle the receipt of an NFT
128    * @dev The ERC721 smart contract calls this function on the recipient
129    *  after a `safetransfer`. This function MAY throw to revert and reject the
130    *  transfer. This function MUST use 50,000 gas or less. Return of other
131    *  than the magic value MUST result in the transaction being reverted.
132    *  Note: the contract address is always the message sender.
133    * @param _from The sending address
134    * @param _tokenId The NFT identifier which is being transfered
135    * @param _data Additional data with no specified format
136    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
137    */
138   function onERC721Received(
139     address _from,
140     uint256 _tokenId,
141     bytes _data
142   )
143     public
144     returns(bytes4);
145 }
146 contract ERC721BasicToken is ERC721Basic {
147   using SafeMath for uint256;
148   using AddressUtils for address;
149 
150   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
151   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
152   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
153 
154   // Mapping from token ID to owner
155   mapping (uint256 => address) internal tokenOwner;
156 
157   // Mapping from token ID to approved address
158   mapping (uint256 => address) internal tokenApprovals;
159 
160   // Mapping from owner to number of owned token
161   mapping (address => uint256) internal ownedTokensCount;
162 
163   // Mapping from owner to operator approvals
164   mapping (address => mapping (address => bool)) internal operatorApprovals;
165 
166   /**
167    * @dev Guarantees msg.sender is owner of the given token
168    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
169    */
170   modifier onlyOwnerOf(uint256 _tokenId) {
171     require(ownerOf(_tokenId) == msg.sender);
172     _;
173   }
174 
175   /**
176    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
177    * @param _tokenId uint256 ID of the token to validate
178    */
179   modifier canTransfer(uint256 _tokenId) {
180     require(isApprovedOrOwner(msg.sender, _tokenId));
181     _;
182   }
183 
184   /**
185    * @dev Gets the balance of the specified address
186    * @param _owner address to query the balance of
187    * @return uint256 representing the amount owned by the passed address
188    */
189   function balanceOf(address _owner) public view returns (uint256) {
190     require(_owner != address(0));
191     return ownedTokensCount[_owner];
192   }
193 
194   /**
195    * @dev Gets the owner of the specified token ID
196    * @param _tokenId uint256 ID of the token to query the owner of
197    * @return owner address currently marked as the owner of the given token ID
198    */
199   function ownerOf(uint256 _tokenId) public view returns (address) {
200     address owner = tokenOwner[_tokenId];
201     require(owner != address(0));
202     return owner;
203   }
204 
205   /**
206    * @dev Returns whether the specified token exists
207    * @param _tokenId uint256 ID of the token to query the existence of
208    * @return whether the token exists
209    */
210   function exists(uint256 _tokenId) public view returns (bool) {
211     address owner = tokenOwner[_tokenId];
212     return owner != address(0);
213   }
214 
215   /**
216    * @dev Approves another address to transfer the given token ID
217    * @dev The zero address indicates there is no approved address.
218    * @dev There can only be one approved address per token at a given time.
219    * @dev Can only be called by the token owner or an approved operator.
220    * @param _to address to be approved for the given token ID
221    * @param _tokenId uint256 ID of the token to be approved
222    */
223   function approve(address _to, uint256 _tokenId) public {
224     address owner = ownerOf(_tokenId);
225     require(_to != owner);
226     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
227 
228     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
229       tokenApprovals[_tokenId] = _to;
230       emit Approval(owner, _to, _tokenId);
231     }
232   }
233 
234   /**
235    * @dev Gets the approved address for a token ID, or zero if no address set
236    * @param _tokenId uint256 ID of the token to query the approval of
237    * @return address currently approved for the given token ID
238    */
239   function getApproved(uint256 _tokenId) public view returns (address) {
240     return tokenApprovals[_tokenId];
241   }
242 
243   /**
244    * @dev Sets or unsets the approval of a given operator
245    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
246    * @param _to operator address to set the approval
247    * @param _approved representing the status of the approval to be set
248    */
249   function setApprovalForAll(address _to, bool _approved) public {
250     require(_to != msg.sender);
251     operatorApprovals[msg.sender][_to] = _approved;
252     emit ApprovalForAll(msg.sender, _to, _approved);
253   }
254 
255   /**
256    * @dev Tells whether an operator is approved by a given owner
257    * @param _owner owner address which you want to query the approval of
258    * @param _operator operator address which you want to query the approval of
259    * @return bool whether the given operator is approved by the given owner
260    */
261   function isApprovedForAll(
262     address _owner,
263     address _operator
264   )
265     public
266     view
267     returns (bool)
268   {
269     return operatorApprovals[_owner][_operator];
270   }
271 
272   /**
273    * @dev Transfers the ownership of a given token ID to another address
274    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
275    * @dev Requires the msg sender to be the owner, approved, or operator
276    * @param _from current owner of the token
277    * @param _to address to receive the ownership of the given token ID
278    * @param _tokenId uint256 ID of the token to be transferred
279   */
280   function transferFrom(
281     address _from,
282     address _to,
283     uint256 _tokenId
284   )
285     public
286     canTransfer(_tokenId)
287   {
288     require(_from != address(0));
289     require(_to != address(0));
290 
291     clearApproval(_from, _tokenId);
292     removeTokenFrom(_from, _tokenId);
293     addTokenTo(_to, _tokenId);
294 
295     emit Transfer(_from, _to, _tokenId);
296   }
297 
298   /**
299    * @dev Safely transfers the ownership of a given token ID to another address
300    * @dev If the target address is a contract, it must implement `onERC721Received`,
301    *  which is called upon a safe transfer, and return the magic value
302    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
303    *  the transfer is reverted.
304    * @dev Requires the msg sender to be the owner, approved, or operator
305    * @param _from current owner of the token
306    * @param _to address to receive the ownership of the given token ID
307    * @param _tokenId uint256 ID of the token to be transferred
308   */
309   function safeTransferFrom(
310     address _from,
311     address _to,
312     uint256 _tokenId
313   )
314     public
315     canTransfer(_tokenId)
316   {
317     // solium-disable-next-line arg-overflow
318     safeTransferFrom(_from, _to, _tokenId, "");
319   }
320 
321   /**
322    * @dev Safely transfers the ownership of a given token ID to another address
323    * @dev If the target address is a contract, it must implement `onERC721Received`,
324    *  which is called upon a safe transfer, and return the magic value
325    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
326    *  the transfer is reverted.
327    * @dev Requires the msg sender to be the owner, approved, or operator
328    * @param _from current owner of the token
329    * @param _to address to receive the ownership of the given token ID
330    * @param _tokenId uint256 ID of the token to be transferred
331    * @param _data bytes data to send along with a safe transfer check
332    */
333   function safeTransferFrom(
334     address _from,
335     address _to,
336     uint256 _tokenId,
337     bytes _data
338   )
339     public
340     canTransfer(_tokenId)
341   {
342     transferFrom(_from, _to, _tokenId);
343     // solium-disable-next-line arg-overflow
344     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
345   }
346 
347   /**
348    * @dev Returns whether the given spender can transfer a given token ID
349    * @param _spender address of the spender to query
350    * @param _tokenId uint256 ID of the token to be transferred
351    * @return bool whether the msg.sender is approved for the given token ID,
352    *  is an operator of the owner, or is the owner of the token
353    */
354   function isApprovedOrOwner(
355     address _spender,
356     uint256 _tokenId
357   )
358     internal
359     view
360     returns (bool)
361   {
362     address owner = ownerOf(_tokenId);
363     // Disable solium check because of
364     // https://github.com/duaraghav8/Solium/issues/175
365     // solium-disable-next-line operator-whitespace
366     return (
367       _spender == owner ||
368       getApproved(_tokenId) == _spender ||
369       isApprovedForAll(owner, _spender)
370     );
371   }
372 
373   /**
374    * @dev Internal function to mint a new token
375    * @dev Reverts if the given token ID already exists
376    * @param _to The address that will own the minted token
377    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
378    */
379   function _mint(address _to, uint256 _tokenId) internal {
380     require(_to != address(0));
381     addTokenTo(_to, _tokenId);
382     emit Transfer(address(0), _to, _tokenId);
383   }
384 
385   /**
386    * @dev Internal function to burn a specific token
387    * @dev Reverts if the token does not exist
388    * @param _tokenId uint256 ID of the token being burned by the msg.sender
389    */
390   function _burn(address _owner, uint256 _tokenId) internal {
391     clearApproval(_owner, _tokenId);
392     removeTokenFrom(_owner, _tokenId);
393     emit Transfer(_owner, address(0), _tokenId);
394   }
395 
396   /**
397    * @dev Internal function to clear current approval of a given token ID
398    * @dev Reverts if the given address is not indeed the owner of the token
399    * @param _owner owner of the token
400    * @param _tokenId uint256 ID of the token to be transferred
401    */
402   function clearApproval(address _owner, uint256 _tokenId) internal {
403     require(ownerOf(_tokenId) == _owner);
404     if (tokenApprovals[_tokenId] != address(0)) {
405       tokenApprovals[_tokenId] = address(0);
406       emit Approval(_owner, address(0), _tokenId);
407     }
408   }
409 
410   /**
411    * @dev Internal function to add a token ID to the list of a given address
412    * @param _to address representing the new owner of the given token ID
413    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
414    */
415   function addTokenTo(address _to, uint256 _tokenId) internal {
416     require(tokenOwner[_tokenId] == address(0));
417     tokenOwner[_tokenId] = _to;
418     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
419   }
420 
421   /**
422    * @dev Internal function to remove a token ID from the list of a given address
423    * @param _from address representing the previous owner of the given token ID
424    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
425    */
426   function removeTokenFrom(address _from, uint256 _tokenId) internal {
427     require(ownerOf(_tokenId) == _from);
428     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
429     tokenOwner[_tokenId] = address(0);
430   }
431 
432   /**
433    * @dev Internal function to invoke `onERC721Received` on a target address
434    * @dev The call is not executed if the target address is not a contract
435    * @param _from address representing the previous owner of the given token ID
436    * @param _to target address that will receive the tokens
437    * @param _tokenId uint256 ID of the token to be transferred
438    * @param _data bytes optional data to send along with the call
439    * @return whether the call correctly returned the expected magic value
440    */
441   function checkAndCallSafeTransfer(
442     address _from,
443     address _to,
444     uint256 _tokenId,
445     bytes _data
446   )
447     internal
448     returns (bool)
449   {
450     if (!_to.isContract()) {
451       return true;
452     }
453     bytes4 retval = ERC721Receiver(_to).onERC721Received(
454       _from, _tokenId, _data);
455     return (retval == ERC721_RECEIVED);
456   }
457 }
458 
459 contract Ownable {
460   address public owner;
461 
462 
463   event OwnershipRenounced(address indexed previousOwner);
464   event OwnershipTransferred(
465     address indexed previousOwner,
466     address indexed newOwner
467   );
468 
469 
470   /**
471    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
472    * account.
473    */
474   constructor() public {
475     owner = msg.sender;
476   }
477 
478   /**
479    * @dev Throws if called by any account other than the owner.
480    */
481   modifier onlyOwner() {
482     require(msg.sender == owner);
483     _;
484   }
485 
486   /**
487    * @dev Allows the current owner to relinquish control of the contract.
488    */
489   function renounceOwnership() public onlyOwner {
490     emit OwnershipRenounced(owner);
491     owner = address(0);
492   }
493 
494   /**
495    * @dev Allows the current owner to transfer control of the contract to a newOwner.
496    * @param _newOwner The address to transfer ownership to.
497    */
498   function transferOwnership(address _newOwner) public onlyOwner {
499     _transferOwnership(_newOwner);
500   }
501 
502   /**
503    * @dev Transfers control of the contract to a newOwner.
504    * @param _newOwner The address to transfer ownership to.
505    */
506   function _transferOwnership(address _newOwner) internal {
507     require(_newOwner != address(0));
508     emit OwnershipTransferred(owner, _newOwner);
509     owner = _newOwner;
510   }
511 }
512 
513 contract CryptoPunksMarket {
514 
515     function imageHash() public  returns(string){
516         
517     }
518 
519     function standard() public  returns(string){
520         
521     }
522 
523     function name() public  returns(string){
524         
525     }
526 
527     function symbol() public  returns (string){
528         
529     }
530 
531     function decimals() public  returns(uint8){
532         
533     }
534 
535     function totalSupply() public  returns(uint256){
536         
537     }
538 
539     //function addressToPunkIndex(address) public  returns (uint){}
540 
541     function punkIndexToAddress(uint) public  returns(address){
542         
543     }
544 
545     function balanceOf(address) public  returns(uint256){
546         
547     }
548 
549     function pendingWithdrawals(address) public  returns (uint){
550         
551     }
552 
553     function transferPunk(address to, uint punkIndex) public {
554     }
555 
556     function punkNoLongerForSale(uint punkIndex) public {
557         
558     }
559 
560     function offerPunkForSale(uint punkIndex, uint minSalePriceInWei) public {
561         
562     }
563    
564     function offerPunkForSaleToAddress(uint punkIndex, uint minSalePriceInWei, address toAddress) {}
565     
566 
567     function buyPunk(uint punkIndex) public payable {}
568 
569     function withdraw() public {}
570    
571     function enterBidForPunk(uint punkIndex) public payable { }
572    
573 
574     function acceptBidForPunk(uint punkIndex, uint minPrice) { }
575     
576 
577     function withdrawBidForPunk(uint punkIndex) public {    }
578    
579 
580 }
581 
582 /**
583  * @title Full ERC721 Token
584  * This implementation includes all the required and some optional functionality of the ERC721 standard
585  * Moreover, it includes approve all functionality using operator terminology
586  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
587  */
588 
589 /**
590  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
591  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
592  */
593 contract ERC721Enumerable is ERC721Basic {
594   function totalSupply() public view returns (uint256);
595   function tokenOfOwnerByIndex(
596     address _owner,
597     uint256 _index
598   )
599     public
600     view
601     returns (uint256 _tokenId);
602 
603   function tokenByIndex(uint256 _index) public view returns (uint256);
604 }
605 
606 
607 /**
608  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
609  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
610  */
611 contract ERC721Metadata is ERC721Basic {
612   function name() public view returns (string _name);
613   function symbol() public view returns (string _symbol);
614   function tokenURI(uint256 _tokenId) public view returns (string);
615 }
616 
617 
618 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
619 }
620 
621 contract ERC721PUNK is ERC721, ERC721BasicToken, Ownable{
622     
623     
624   // Token name
625   string internal name_;
626 
627   // Token symbol
628   string internal symbol_;
629 
630   // Mapping from owner to list of owned token IDs
631   mapping(address => uint256[]) internal ownedTokens;
632 
633   // Mapping from token ID to index of the owner tokens list
634   mapping(uint256 => uint256) internal ownedTokensIndex;
635 
636   // Array with all token ids, used for enumeration
637   uint256[] internal allTokens;
638 
639   // Mapping from token id to position in the allTokens array
640   mapping(uint256 => uint256) internal allTokensIndex;
641 
642   // Optional mapping for token URIs
643   mapping(uint256 => string) internal tokenURIs;
644   
645   //Mapping for PunkId to tokenId
646   mapping(uint256 => uint256) internal punkToTokenId;
647   
648   //mapping for tokenId's to PunkId
649   mapping(uint256 => uint256) internal tokenIdToPunk;
650   
651   //Mapping for Punk Exists in contract
652   mapping(uint256 => bool) internal punkExists;
653 
654   uint256 internal totalPunksInContract;
655   /**
656    * @dev Constructor function
657    */
658   constructor(string _name, string _symbol) public {
659     name_ = _name;
660     symbol_ = _symbol;
661   }
662   
663   
664   //CRYPTO PUNK INTERFACE
665       CryptoPunksMarket punk;
666     
667     function Existing(address _t) onlyOwner public {
668         punk = CryptoPunksMarket(_t);
669     }
670     
671     
672     function indexToAddress(uint256 _index) public view returns(address){
673         return punk.punkIndexToAddress(_index);
674     }
675     
676     
677     function totalPunkSupply() public view returns(uint256){
678 
679         return punk.totalSupply();
680     }
681     
682     function transfer(address _to, uint _punk) onlyOwner public{
683         
684         punk.transferPunk(_to, _punk);
685         
686     }
687 
688     function balanceOf(address _address) public view returns(uint256){
689         return punk.balanceOf(_address);
690     }
691     
692 //ADD punk
693 
694     
695   
696   function makeToken(uint _tokenId, uint256 _punkId) onlyOwner public {
697       require(indexToAddress(_punkId) == address(this), "Punk not owned by this Contract");
698       require(_tokenId == _punkId);
699       require(!(punkIsHere(_punkId)));
700       _mint(msg.sender, _tokenId);
701       punkToTokenId[_punkId] = _tokenId;
702       tokenIdToPunk[_tokenId] = _punkId;
703       punkExists[_punkId] = true;
704       totalPunksInContract++;
705       
706   }
707   
708   function seturi(uint tokenId, string uri) onlyOwner public {
709       _setTokenURI(tokenId, uri);
710   }
711   
712   
713   function tokenToPunk(uint _tokenId) public view returns(uint256){
714       return tokenIdToPunk[_tokenId];
715   }
716   
717   function punkToToken(uint _punkId) public view returns(uint256){
718       return punkToTokenId[_punkId];
719   }
720   function punkIsHere(uint _punkId) public view returns(bool){
721       if (punkExists[_punkId] == true){
722           return true;
723       }else {return false;}
724   }
725 
726   /**
727    * @dev Gets the token name
728    * @return string representing the token name
729    */
730   function name() public view returns (string) {
731     return name_;
732   }
733 
734   /**
735    * @dev Gets the token symbol
736    * @return string representing the token symbol
737    */
738   function symbol() public view returns (string) {
739     return symbol_;
740   }
741 
742   /**
743    * @dev Returns an URI for a given token ID
744    * @dev Throws if the token ID does not exist. May return an empty string.
745    * @param _tokenId uint256 ID of the token to query
746    */
747   function tokenURI(uint256 _tokenId) public view returns (string) {
748     require(exists(_tokenId));
749     return tokenURIs[_tokenId];
750   }
751 
752   /**
753    * @dev Gets the token ID at a given index of the tokens list of the requested owner
754    * @param _owner address owning the tokens list to be accessed
755    * @param _index uint256 representing the index to be accessed of the requested tokens list
756    * @return uint256 token ID at the given index of the tokens list owned by the requested address
757    */
758   function tokenOfOwnerByIndex(
759     address _owner,
760     uint256 _index
761   )
762     public
763     view
764     returns (uint256)
765   {
766     require(_index < balanceOf(_owner));
767     return ownedTokens[_owner][_index];
768   }
769 
770   /**
771    * @dev Gets the total amount of tokens stored by the contract
772    * @return uint256 representing the total amount of tokens
773    */
774   function totalSupply() public view returns (uint256) {
775     return allTokens.length;
776   }
777 
778   /**
779    * @dev Gets the token ID at a given index of all the tokens in this contract
780    * @dev Reverts if the index is greater or equal to the total number of tokens
781    * @param _index uint256 representing the index to be accessed of the tokens list
782    * @return uint256 token ID at the given index of the tokens list
783    */
784   function tokenByIndex(uint256 _index) public view returns (uint256) {
785     require(_index < totalSupply());
786     return allTokens[_index];
787   }
788 
789   /**
790    * @dev Internal function to set the token URI for a given token
791    * @dev Reverts if the token ID does not exist
792    * @param _tokenId uint256 ID of the token to set its URI
793    * @param _uri string URI to assign
794    */
795   function _setTokenURI(uint256 _tokenId, string _uri) internal {
796     require(exists(_tokenId));
797     tokenURIs[_tokenId] = _uri;
798   }
799 
800   /**
801    * @dev Internal function to add a token ID to the list of a given address
802    * @param _to address representing the new owner of the given token ID
803    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
804    */
805   function addTokenTo(address _to, uint256 _tokenId) internal {
806     super.addTokenTo(_to, _tokenId);
807     uint256 length = ownedTokens[_to].length;
808     ownedTokens[_to].push(_tokenId);
809     ownedTokensIndex[_tokenId] = length;
810   }
811 
812   /**
813    * @dev Internal function to remove a token ID from the list of a given address
814    * @param _from address representing the previous owner of the given token ID
815    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
816    */
817   function removeTokenFrom(address _from, uint256 _tokenId) internal {
818     super.removeTokenFrom(_from, _tokenId);
819 
820     uint256 tokenIndex = ownedTokensIndex[_tokenId];
821     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
822     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
823 
824     ownedTokens[_from][tokenIndex] = lastToken;
825     ownedTokens[_from][lastTokenIndex] = 0;
826     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
827     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
828     // the lastToken to the first position, and then dropping the element placed in the last position of the list
829 
830     ownedTokens[_from].length--;
831     ownedTokensIndex[_tokenId] = 0;
832     ownedTokensIndex[lastToken] = tokenIndex;
833   }
834 
835   /**
836    * @dev Internal function to mint a new token
837    * @dev Reverts if the given token ID already exists
838    * @param _to address the beneficiary that will own the minted token
839    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
840    */
841   function _mint(address _to, uint256 _tokenId) internal {
842     super._mint(_to, _tokenId);
843 
844     allTokensIndex[_tokenId] = allTokens.length;
845     allTokens.push(_tokenId);
846   }
847 
848   /**
849    * @dev Internal function to burn a specific token
850    * @dev Reverts if the token does not exist
851    * @param _owner owner of the token to burn
852    * @param _tokenId uint256 ID of the token being burned by the msg.sender
853    */
854   function _burn(address _owner, uint256 _tokenId) internal {
855     super._burn(_owner, _tokenId);
856 
857     // Clear metadata (if any)
858     if (bytes(tokenURIs[_tokenId]).length != 0) {
859       delete tokenURIs[_tokenId];
860     }
861 
862     // Reorg all tokens array
863     uint256 tokenIndex = allTokensIndex[_tokenId];
864     uint256 lastTokenIndex = allTokens.length.sub(1);
865     uint256 lastToken = allTokens[lastTokenIndex];
866 
867     allTokens[tokenIndex] = lastToken;
868     allTokens[lastTokenIndex] = 0;
869 
870     allTokens.length--;
871     allTokensIndex[_tokenId] = 0;
872     allTokensIndex[lastToken] = tokenIndex;
873   }
874 
875 }