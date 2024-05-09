1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract ERC721Basic {
6   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
7   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
8   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
9 
10   function balanceOf(address _owner) public view returns (uint256 _balance);
11   function ownerOf(uint256 _tokenId) public view returns (address _owner);
12   function exists(uint256 _tokenId) public view returns (bool _exists);
13 
14   function approve(address _to, uint256 _tokenId) public;
15   function getApproved(uint256 _tokenId) public view returns (address _operator);
16 
17   function setApprovalForAll(address _operator, bool _approved) public;
18   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
19 
20   function transferFrom(address _from, address _to, uint256 _tokenId) public;
21   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
22   function safeTransferFrom(
23     address _from,
24     address _to,
25     uint256 _tokenId,
26     bytes _data
27   )
28     public;
29 }
30 
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     if (a == 0) {
38       return 0;
39     }
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 contract ERC721Receiver {
74   /**
75    * @dev Magic value to be returned upon successful reception of an NFT
76    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
77    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
78    */
79   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
80 
81   /**
82    * @notice Handle the receipt of an NFT
83    * @dev The ERC721 smart contract calls this function on the recipient
84    *  after a `safetransfer`. This function MAY throw to revert and reject the
85    *  transfer. This function MUST use 50,000 gas or less. Return of other
86    *  than the magic value MUST result in the transaction being reverted.
87    *  Note: the contract address is always the message sender.
88    * @param _from The sending address
89    * @param _tokenId The NFT identifier which is being transfered
90    * @param _data Additional data with no specified format
91    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
92    */
93   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
94 }
95 
96 library AddressUtils {
97 
98   /**
99    * Returns whether the target address is a contract
100    * @dev This function will return false if invoked during the constructor of a contract,
101    *  as the code is not actually created until after the constructor finishes.
102    * @param addr address to check
103    * @return whether the target address is a contract
104    */
105   function isContract(address addr) internal view returns (bool) {
106     uint256 size;
107     // XXX Currently there is no better way to check if there is a contract in an address
108     // than to check the size of the code at that address.
109     // See https://ethereum.stackexchange.com/a/14016/36603
110     // for more details about how this works.
111     // TODO Check this again before the Serenity release, because all addresses will be
112     // contracts then.
113     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
114     return size > 0;
115   }
116 
117 }
118 
119 contract Ownable {
120   address public owner;
121 
122 
123   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125 
126   /**
127    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
128    * account.
129    */
130   function Ownable() public {
131     owner = msg.sender;
132   }
133 
134   /**
135    * @dev Throws if called by any account other than the owner.
136    */
137   modifier onlyOwner() {
138     require(msg.sender == owner);
139     _;
140   }
141 
142   /**
143    * @dev Allows the current owner to transfer control of the contract to a newOwner.
144    * @param newOwner The address to transfer ownership to.
145    */
146   function transferOwnership(address newOwner) public onlyOwner {
147     require(newOwner != address(0));
148     emit OwnershipTransferred(owner, newOwner);
149     owner = newOwner;
150   }
151 
152 }
153 
154 contract ERC20Basic {
155   function totalSupply() public view returns (uint256);
156   function balanceOf(address who) public view returns (uint256);
157   function transfer(address to, uint256 value) public returns (bool);
158   event Transfer(address indexed from, address indexed to, uint256 value);
159 }
160 
161 contract ERC721Enumerable is ERC721Basic {
162   function totalSupply() public view returns (uint256);
163   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
164   function tokenByIndex(uint256 _index) public view returns (uint256);
165 }
166 
167 
168 /**
169  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
170  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
171  */
172 contract ERC721Metadata is ERC721Basic {
173   function name() public view returns (string _name);
174   function symbol() public view returns (string _symbol);
175   function tokenURI(uint256 _tokenId) public view returns (string);
176 }
177 
178 
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
181  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
182  */
183 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
184 }
185 
186 contract ERC721BasicToken is ERC721Basic {
187   using SafeMath for uint256;
188   using AddressUtils for address;
189 
190   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
191   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
192   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
193 
194   // Mapping from token ID to owner
195   mapping (uint256 => address) internal tokenOwner;
196 
197   // Mapping from token ID to approved address
198   mapping (uint256 => address) internal tokenApprovals;
199 
200   // Mapping from owner to number of owned token
201   mapping (address => uint256) internal ownedTokensCount;
202 
203   // Mapping from owner to operator approvals
204   mapping (address => mapping (address => bool)) internal operatorApprovals;
205 
206   /**
207    * @dev Guarantees msg.sender is owner of the given token
208    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
209    */
210   modifier onlyOwnerOf(uint256 _tokenId) {
211     require(ownerOf(_tokenId) == msg.sender);
212     _;
213   }
214 
215   /**
216    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
217    * @param _tokenId uint256 ID of the token to validate
218    */
219   modifier canTransfer(uint256 _tokenId) {
220     require(isApprovedOrOwner(msg.sender, _tokenId));
221     _;
222   }
223 
224   /**
225    * @dev Gets the balance of the specified address
226    * @param _owner address to query the balance of
227    * @return uint256 representing the amount owned by the passed address
228    */
229   function balanceOf(address _owner) public view returns (uint256) {
230     require(_owner != address(0));
231     return ownedTokensCount[_owner];
232   }
233 
234   /**
235    * @dev Gets the owner of the specified token ID
236    * @param _tokenId uint256 ID of the token to query the owner of
237    * @return owner address currently marked as the owner of the given token ID
238    */
239   function ownerOf(uint256 _tokenId) public view returns (address) {
240     address owner = tokenOwner[_tokenId];
241     require(owner != address(0));
242     return owner;
243   }
244 
245   /**
246    * @dev Returns whether the specified token exists
247    * @param _tokenId uint256 ID of the token to query the existance of
248    * @return whether the token exists
249    */
250   function exists(uint256 _tokenId) public view returns (bool) {
251     address owner = tokenOwner[_tokenId];
252     return owner != address(0);
253   }
254 
255   /**
256    * @dev Approves another address to transfer the given token ID
257    * @dev The zero address indicates there is no approved address.
258    * @dev There can only be one approved address per token at a given time.
259    * @dev Can only be called by the token owner or an approved operator.
260    * @param _to address to be approved for the given token ID
261    * @param _tokenId uint256 ID of the token to be approved
262    */
263   function approve(address _to, uint256 _tokenId) public {
264     address owner = ownerOf(_tokenId);
265     require(_to != owner);
266     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
267 
268     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
269       tokenApprovals[_tokenId] = _to;
270       emit Approval(owner, _to, _tokenId);
271     }
272   }
273 
274   /**
275    * @dev Gets the approved address for a token ID, or zero if no address set
276    * @param _tokenId uint256 ID of the token to query the approval of
277    * @return address currently approved for a the given token ID
278    */
279   function getApproved(uint256 _tokenId) public view returns (address) {
280     return tokenApprovals[_tokenId];
281   }
282 
283   /**
284    * @dev Sets or unsets the approval of a given operator
285    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
286    * @param _to operator address to set the approval
287    * @param _approved representing the status of the approval to be set
288    */
289   function setApprovalForAll(address _to, bool _approved) public {
290     require(_to != msg.sender);
291     operatorApprovals[msg.sender][_to] = _approved;
292     emit ApprovalForAll(msg.sender, _to, _approved);
293   }
294 
295   /**
296    * @dev Tells whether an operator is approved by a given owner
297    * @param _owner owner address which you want to query the approval of
298    * @param _operator operator address which you want to query the approval of
299    * @return bool whether the given operator is approved by the given owner
300    */
301   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
302     return operatorApprovals[_owner][_operator];
303   }
304 
305   /**
306    * @dev Transfers the ownership of a given token ID to another address
307    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
308    * @dev Requires the msg sender to be the owner, approved, or operator
309    * @param _from current owner of the token
310    * @param _to address to receive the ownership of the given token ID
311    * @param _tokenId uint256 ID of the token to be transferred
312   */
313   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
314     require(_from != address(0));
315     require(_to != address(0));
316 
317     clearApproval(_from, _tokenId);
318     removeTokenFrom(_from, _tokenId);
319     addTokenTo(_to, _tokenId);
320 
321     emit Transfer(_from, _to, _tokenId);
322   }
323 
324   /**
325    * @dev Safely transfers the ownership of a given token ID to another address
326    * @dev If the target address is a contract, it must implement `onERC721Received`,
327    *  which is called upon a safe transfer, and return the magic value
328    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
329    *  the transfer is reverted.
330    * @dev Requires the msg sender to be the owner, approved, or operator
331    * @param _from current owner of the token
332    * @param _to address to receive the ownership of the given token ID
333    * @param _tokenId uint256 ID of the token to be transferred
334   */
335   function safeTransferFrom(
336     address _from,
337     address _to,
338     uint256 _tokenId
339   )
340     public
341     canTransfer(_tokenId)
342   {
343     // solium-disable-next-line arg-overflow
344     safeTransferFrom(_from, _to, _tokenId, "");
345   }
346 
347   /**
348    * @dev Safely transfers the ownership of a given token ID to another address
349    * @dev If the target address is a contract, it must implement `onERC721Received`,
350    *  which is called upon a safe transfer, and return the magic value
351    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
352    *  the transfer is reverted.
353    * @dev Requires the msg sender to be the owner, approved, or operator
354    * @param _from current owner of the token
355    * @param _to address to receive the ownership of the given token ID
356    * @param _tokenId uint256 ID of the token to be transferred
357    * @param _data bytes data to send along with a safe transfer check
358    */
359   function safeTransferFrom(
360     address _from,
361     address _to,
362     uint256 _tokenId,
363     bytes _data
364   )
365     public
366     canTransfer(_tokenId)
367   {
368     transferFrom(_from, _to, _tokenId);
369     // solium-disable-next-line arg-overflow
370     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
371   }
372 
373   /**
374    * @dev Returns whether the given spender can transfer a given token ID
375    * @param _spender address of the spender to query
376    * @param _tokenId uint256 ID of the token to be transferred
377    * @return bool whether the msg.sender is approved for the given token ID,
378    *  is an operator of the owner, or is the owner of the token
379    */
380   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
381     address owner = ownerOf(_tokenId);
382     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
383   }
384 
385   /**
386    * @dev Internal function to mint a new token
387    * @dev Reverts if the given token ID already exists
388    * @param _to The address that will own the minted token
389    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
390    */
391   function _mint(address _to, uint256 _tokenId) internal {
392     require(_to != address(0));
393     addTokenTo(_to, _tokenId);
394     emit Transfer(address(0), _to, _tokenId);
395   }
396 
397   /**
398    * @dev Internal function to burn a specific token
399    * @dev Reverts if the token does not exist
400    * @param _tokenId uint256 ID of the token being burned by the msg.sender
401    */
402   function _burn(address _owner, uint256 _tokenId) internal {
403     clearApproval(_owner, _tokenId);
404     removeTokenFrom(_owner, _tokenId);
405     emit Transfer(_owner, address(0), _tokenId);
406   }
407 
408   /**
409    * @dev Internal function to clear current approval of a given token ID
410    * @dev Reverts if the given address is not indeed the owner of the token
411    * @param _owner owner of the token
412    * @param _tokenId uint256 ID of the token to be transferred
413    */
414   function clearApproval(address _owner, uint256 _tokenId) internal {
415     require(ownerOf(_tokenId) == _owner);
416     if (tokenApprovals[_tokenId] != address(0)) {
417       tokenApprovals[_tokenId] = address(0);
418       emit Approval(_owner, address(0), _tokenId);
419     }
420   }
421 
422   /**
423    * @dev Internal function to add a token ID to the list of a given address
424    * @param _to address representing the new owner of the given token ID
425    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
426    */
427   function addTokenTo(address _to, uint256 _tokenId) internal {
428     require(tokenOwner[_tokenId] == address(0));
429     tokenOwner[_tokenId] = _to;
430     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
431   }
432 
433   /**
434    * @dev Internal function to remove a token ID from the list of a given address
435    * @param _from address representing the previous owner of the given token ID
436    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
437    */
438   function removeTokenFrom(address _from, uint256 _tokenId) internal {
439     require(ownerOf(_tokenId) == _from);
440     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
441     tokenOwner[_tokenId] = address(0);
442   }
443 
444   /**
445    * @dev Internal function to invoke `onERC721Received` on a target address
446    * @dev The call is not executed if the target address is not a contract
447    * @param _from address representing the previous owner of the given token ID
448    * @param _to target address that will receive the tokens
449    * @param _tokenId uint256 ID of the token to be transferred
450    * @param _data bytes optional data to send along with the call
451    * @return whether the call correctly returned the expected magic value
452    */
453   function checkAndCallSafeTransfer(
454     address _from,
455     address _to,
456     uint256 _tokenId,
457     bytes _data
458   )
459     internal
460     returns (bool)
461   {
462     if (!_to.isContract()) {
463       return true;
464     }
465     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
466     return (retval == ERC721_RECEIVED);
467   }
468 }
469 
470 contract ERC20 is ERC20Basic {
471   function allowance(address owner, address spender) public view returns (uint256);
472   function transferFrom(address from, address to, uint256 value) public returns (bool);
473   function approve(address spender, uint256 value) public returns (bool);
474   event Approval(address indexed owner, address indexed spender, uint256 value);
475 }
476 
477 contract ERC721Token is ERC721, ERC721BasicToken {
478   // Token name
479   string internal name_;
480 
481   // Token symbol
482   string internal symbol_;
483 
484   // Mapping from owner to list of owned token IDs
485   mapping (address => uint256[]) internal ownedTokens;
486 
487   // Mapping from token ID to index of the owner tokens list
488   mapping(uint256 => uint256) internal ownedTokensIndex;
489 
490   // Array with all token ids, used for enumeration
491   uint256[] internal allTokens;
492 
493   // Mapping from token id to position in the allTokens array
494   mapping(uint256 => uint256) internal allTokensIndex;
495 
496   // Optional mapping for token URIs
497   mapping(uint256 => string) internal tokenURIs;
498 
499   /**
500    * @dev Constructor function
501    */
502   function ERC721Token(string _name, string _symbol) public {
503     name_ = _name;
504     symbol_ = _symbol;
505   }
506 
507   /**
508    * @dev Gets the token name
509    * @return string representing the token name
510    */
511   function name() public view returns (string) {
512     return name_;
513   }
514 
515   /**
516    * @dev Gets the token symbol
517    * @return string representing the token symbol
518    */
519   function symbol() public view returns (string) {
520     return symbol_;
521   }
522 
523   /**
524    * @dev Returns an URI for a given token ID
525    * @dev Throws if the token ID does not exist. May return an empty string.
526    * @param _tokenId uint256 ID of the token to query
527    */
528   function tokenURI(uint256 _tokenId) public view returns (string) {
529     require(exists(_tokenId));
530     return tokenURIs[_tokenId];
531   }
532 
533   /**
534    * @dev Gets the token ID at a given index of the tokens list of the requested owner
535    * @param _owner address owning the tokens list to be accessed
536    * @param _index uint256 representing the index to be accessed of the requested tokens list
537    * @return uint256 token ID at the given index of the tokens list owned by the requested address
538    */
539   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
540     require(_index < balanceOf(_owner));
541     return ownedTokens[_owner][_index];
542   }
543 
544   /**
545    * @dev Gets the total amount of tokens stored by the contract
546    * @return uint256 representing the total amount of tokens
547    */
548   function totalSupply() public view returns (uint256) {
549     return allTokens.length;
550   }
551 
552   /**
553    * @dev Gets the token ID at a given index of all the tokens in this contract
554    * @dev Reverts if the index is greater or equal to the total number of tokens
555    * @param _index uint256 representing the index to be accessed of the tokens list
556    * @return uint256 token ID at the given index of the tokens list
557    */
558   function tokenByIndex(uint256 _index) public view returns (uint256) {
559     require(_index < totalSupply());
560     return allTokens[_index];
561   }
562 
563   /**
564    * @dev Internal function to set the token URI for a given token
565    * @dev Reverts if the token ID does not exist
566    * @param _tokenId uint256 ID of the token to set its URI
567    * @param _uri string URI to assign
568    */
569   function _setTokenURI(uint256 _tokenId, string _uri) internal {
570     require(exists(_tokenId));
571     tokenURIs[_tokenId] = _uri;
572   }
573 
574   /**
575    * @dev Internal function to add a token ID to the list of a given address
576    * @param _to address representing the new owner of the given token ID
577    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
578    */
579   function addTokenTo(address _to, uint256 _tokenId) internal {
580     super.addTokenTo(_to, _tokenId);
581     uint256 length = ownedTokens[_to].length;
582     ownedTokens[_to].push(_tokenId);
583     ownedTokensIndex[_tokenId] = length;
584   }
585 
586   /**
587    * @dev Internal function to remove a token ID from the list of a given address
588    * @param _from address representing the previous owner of the given token ID
589    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
590    */
591   function removeTokenFrom(address _from, uint256 _tokenId) internal {
592     super.removeTokenFrom(_from, _tokenId);
593 
594     uint256 tokenIndex = ownedTokensIndex[_tokenId];
595     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
596     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
597 
598     ownedTokens[_from][tokenIndex] = lastToken;
599     ownedTokens[_from][lastTokenIndex] = 0;
600     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
601     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
602     // the lastToken to the first position, and then dropping the element placed in the last position of the list
603 
604     ownedTokens[_from].length--;
605     ownedTokensIndex[_tokenId] = 0;
606     ownedTokensIndex[lastToken] = tokenIndex;
607   }
608 
609   /**
610    * @dev Internal function to mint a new token
611    * @dev Reverts if the given token ID already exists
612    * @param _to address the beneficiary that will own the minted token
613    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
614    */
615   function _mint(address _to, uint256 _tokenId) internal {
616     super._mint(_to, _tokenId);
617 
618     allTokensIndex[_tokenId] = allTokens.length;
619     allTokens.push(_tokenId);
620   }
621 
622   /**
623    * @dev Internal function to burn a specific token
624    * @dev Reverts if the token does not exist
625    * @param _owner owner of the token to burn
626    * @param _tokenId uint256 ID of the token being burned by the msg.sender
627    */
628   function _burn(address _owner, uint256 _tokenId) internal {
629     super._burn(_owner, _tokenId);
630 
631     // Clear metadata (if any)
632     if (bytes(tokenURIs[_tokenId]).length != 0) {
633       delete tokenURIs[_tokenId];
634     }
635 
636     // Reorg all tokens array
637     uint256 tokenIndex = allTokensIndex[_tokenId];
638     uint256 lastTokenIndex = allTokens.length.sub(1);
639     uint256 lastToken = allTokens[lastTokenIndex];
640 
641     allTokens[tokenIndex] = lastToken;
642     allTokens[lastTokenIndex] = 0;
643 
644     allTokens.length--;
645     allTokensIndex[_tokenId] = 0;
646     allTokensIndex[lastToken] = tokenIndex;
647   }
648 
649 }
650 
651 contract EveryDappToken is ERC721Token, Ownable {
652     using SafeMath for uint256;
653 
654     struct Ad {
655         uint32 width; //in pixels
656         uint32 height;
657         string imageUrl;
658         string href;
659         bool forSale;
660         uint256 price;
661     }
662 
663     event AdOffered(uint256 adId, uint256 price);
664     event OfferCancelled(uint256 adId);
665     event AdBought(uint256 adId);
666     event AdAdded(uint256 adId);
667 
668     mapping(uint256 => Ad) public ads;
669     mapping(uint256 => uint) public suggestedAdPrices;
670     uint256 public ownerCut; //0-10000, in 0,01% so 10000 means 100%
671     uint256 public priceProgression; //0-10000, in 0,01% so 10000 means 100%
672 
673     constructor() public ERC721Token("EveryDapp Token", "EVDT") {
674         ownerCut = 1000;
675         priceProgression = 1000;
676     }
677 
678     modifier onlyExistingAd(uint256 _adId) {
679         require(exists(_adId));
680         _;
681     }
682 
683     function adIds() public view returns (uint256[]) {
684         return allTokens;
685     }
686 
687     function transferFrom(
688         address _from,
689         address _to,
690         uint256 _adId
691     ) public {
692         ERC721BasicToken.transferFrom(_from, _to, _adId);
693 
694         _cancelOffer(_adId);
695     }
696 
697     function addAd(
698         uint32 _width,
699         uint32 _height,
700         string _imageUrl,
701         string _href,
702         uint256 _initialPrice
703     ) public onlyOwner {
704         uint256 newAdId = allTokens.length;
705         super._mint(owner, newAdId);
706         ads[newAdId] = Ad({
707             width: _width,
708             height: _height,
709             imageUrl: _imageUrl,
710             href: _href,
711             forSale: false,
712             price: 0
713         });
714         _setSuggestedAdPrice(newAdId, _initialPrice);
715 
716         emit AdAdded(newAdId);
717     }
718 
719     function setAdData(
720         uint256 _adId,
721         string _imageUrl,
722         string _href
723     ) public onlyOwnerOf(_adId) {
724         ads[_adId].imageUrl = _imageUrl;
725         ads[_adId].href = _href;
726     }
727 
728     function offerAd(uint256 _adId, uint256 _price) public onlyOwnerOf(_adId) {
729         ads[_adId].forSale = true;
730 
731         if (_price == 0) {
732             ads[_adId].price = suggestedAdPrices[_adId];
733         } else {
734             ads[_adId].price = _price;
735         }
736 
737         emit AdOffered(_adId, ads[_adId].price);
738     }
739 
740     function cancelOffer(uint256 _adId) public onlyOwnerOf(_adId) {
741         _cancelOffer(_adId);
742     }
743 
744     function buyAd(uint256 _adId) public payable onlyExistingAd(_adId) {
745         address adOwner = ownerOf(_adId);
746         uint256 adPrice = ads[_adId].price;
747 
748         require(ads[_adId].forSale);
749         require(msg.value == adPrice);
750         require(msg.sender != adOwner);
751 
752         tokenApprovals[_adId] = msg.sender;
753         safeTransferFrom(adOwner, msg.sender, _adId);
754 
755         _setSuggestedAdPrice(_adId, _progressAdPrice(adPrice));
756 
757         uint256 ownerFee = calculateOwnerFee(msg.value);
758         uint256 sellerFee = msg.value - ownerFee;
759 
760         owner.transfer(ownerFee);
761         adOwner.transfer(sellerFee);
762 
763         emit AdBought(_adId);
764     }
765 
766     function setOwnerCut(uint16 _ownerCut) public onlyOwner {
767         ownerCut = _ownerCut;
768     }
769 
770     function setPriceProgression(uint16 _priceProgression) public onlyOwner {
771         priceProgression = _priceProgression;
772     }
773 
774     function setSuggestedAdPrice(uint256 _adId, uint256 _price) public onlyOwner {
775         require(!ads[_adId].forSale);
776 
777         _setSuggestedAdPrice(_adId, _price);
778     }
779 
780     function calculateOwnerFee(uint256 _value) public view returns (uint256) {
781         return _value.mul(ownerCut).div(10000);
782     }
783 
784     function _cancelOffer(uint256 _adId) private {
785         bool wasOffered = ads[_adId].forSale;
786 
787         ads[_adId].forSale = false;
788         ads[_adId].price = 0;
789 
790         if (wasOffered) {
791             emit OfferCancelled(_adId);
792         }
793     }
794 
795     function _setSuggestedAdPrice(uint256 _adId, uint256 _price) private {
796         require(!ads[_adId].forSale);
797 
798         suggestedAdPrices[_adId] = _price;
799     }
800 
801     function _progressAdPrice(uint256 _basePrice) private view returns (uint256) {
802         return _basePrice.mul(priceProgression.add(10000)).div(10000);
803     }
804 
805     // In case of accidental ether lock on contract
806     function withdraw() public onlyOwner {
807         owner.transfer(address(this).balance);
808     }
809 
810     // In case of accidental token transfer to this address, owner can transfer it elsewhere
811     function transferERC20Token(
812         address _tokenAddress,
813         address _to,
814         uint256 _value
815     ) public onlyOwner {
816         ERC20 token = ERC20(_tokenAddress);
817         assert(token.transfer(_to, _value));
818     }
819 }