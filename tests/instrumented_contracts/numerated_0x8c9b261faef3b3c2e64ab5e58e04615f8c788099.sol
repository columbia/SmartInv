1 /**
2  * Created on 2018-06-05 16:37
3  * @summary: Our NFT Minting Contract which inherits ERC721 capability from LSNFT
4  * @author: Fazri Zubair & Farhan Khwaja
5  */
6 pragma solidity ^0.4.23;
7 
8 pragma solidity ^0.4.23;
9 
10 /* NFT Metadata Schema 
11 {
12     "title": "Asset Metadata",
13     "type": "object",
14     "properties": {
15         "name": {
16             "type": "string",
17             "description": "Identifies the asset to which this NFT represents",
18         },
19         "description": {
20             "type": "string",
21             "description": "Describes the asset to which this NFT represents",
22         },
23         "image": {
24             "type": "string",
25             "description": "A URI pointing to a resource with mime type image/* representing the asset to which this NFT represents. Consider making any images at a width between 320 and 1080 pixels and aspect ratio between 1.91:1 and 4:5 inclusive.",
26         }
27     }
28 }
29 */
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that revert on error
34  */
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, reverts on overflow.
39   */
40   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42     // benefit is lost if 'b' is also tested.
43     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44     if (_a == 0) {
45       return 0;
46     }
47 
48     uint256 c = _a * _b;
49     require(c / _a == _b);
50 
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
56   */
57   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
58     require(_b > 0); // Solidity only automatically asserts when dividing by 0
59     uint256 c = _a / _b;
60     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
61 
62     return c;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
69     require(_b <= _a);
70     uint256 c = _a - _b;
71 
72     return c;
73   }
74 
75   /**
76   * @dev Adds two numbers, reverts on overflow.
77   */
78   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
79     uint256 c = _a + _b;
80     require(c >= _a);
81 
82     return c;
83   }
84 }
85 
86 /**
87  * Utility library of inline functions on addresses
88  */
89 library AddressUtils {
90 
91     /**
92     * Returns whether the target address is a contract
93     * @dev This function will return false if invoked during the constructor of a contract,
94     *  as the code is not actually created until after the constructor finishes.
95     * @param addr address to check
96     * @return whether the target address is a contract
97     */
98     function isContract(address addr) internal view returns (bool) {
99         uint256 size;
100         // XXX Currently there is no better way to check if there is a contract in an address
101         // than to check the size of the code at that address.
102         // See https://ethereum.stackexchange.com/a/14016/36603
103         // for more details about how this works.
104         // TODO Check this again before the Serenity release, because all addresses will be
105         // contracts then.
106         // solium-disable-next-line security/no-inline-assembly
107         assembly { size := extcodesize(addr) }
108         return size > 0;
109     }
110 
111 }
112 
113 /**
114  * @title ERC721 Non-Fungible Token Standard basic interface
115  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
116  */
117 contract ERC721Basic {
118     event Transfer(
119         address indexed _from,
120         address indexed _to,
121         uint256 indexed _tokenId
122     );
123     event Approval(
124         address indexed _owner,
125         address indexed _approved,
126         uint256 indexed _tokenId
127     );
128     event ApprovalForAll(
129         address indexed _owner,
130         address indexed _operator,
131         bool _approved
132     );
133 
134     function balanceOf(address _owner) public view returns (uint256 _balance);
135     function ownerOf(uint256 _tokenId) public view returns (address _owner);
136     function exists(uint256 _tokenId) public view returns (bool _exists);
137 
138     function approve(address _to, uint256 _tokenId) public;
139     function getApproved(uint256 _tokenId)
140         public view returns (address _operator);
141 
142     function setApprovalForAll(address _operator, bool _approved) public;
143     function isApprovedForAll(address _owner, address _operator)
144         public view returns (bool);
145 
146     function transferFrom(address _from, address _to, uint256 _tokenId) public;
147     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
148 
149     function safeTransferFrom(
150         address _from,
151         address _to,
152         uint256 _tokenId,
153         bytes _data
154     )
155         public;
156 }
157 
158 /**
159  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
160  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
161  */
162 contract ERC721Enumerable is ERC721Basic {
163     function totalSupply() public view returns (uint256);
164     function tokenOfOwnerByIndex(
165         address _owner,
166         uint256 _index
167     )
168         public
169         view
170         returns (uint256 _tokenId);
171 
172     function tokenByIndex(uint256 _index) public view returns (uint256);
173 }
174 
175 /**
176  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
177  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
178  */
179 contract ERC721Metadata is ERC721Basic {
180     function name() public view returns (string _name);
181     function symbol() public view returns (string _symbol);
182     function tokenURI(uint256 _tokenId) public view returns (string);
183 }
184 
185 /**
186  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
187  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
188  */
189 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
190 }
191 
192 /**
193  * @title ERC721 Non-Fungible Token Standard basic implementation
194  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
195  */
196 contract ERC721BasicToken is ERC721Basic {
197     using SafeMath for uint256;
198     using AddressUtils for address;
199 
200     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
201     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
202     bytes4 public constant ERC721_RECEIVED = 0x150b7a02;
203 
204     // Mapping from token ID to owner
205     mapping (uint256 => address) internal tokenOwner;
206 
207     // Mapping from token ID to approved address
208     mapping (uint256 => address) internal tokenApprovals;
209 
210     // Mapping from owner to number of owned token
211     mapping (address => uint256) internal ownedTokensCount;
212 
213     // Mapping from owner to operator approvals
214     mapping (address => mapping (address => bool)) internal operatorApprovals;
215 
216     /**
217     * @dev Guarantees msg.sender is owner of the given token
218     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
219     */
220     modifier onlyOwnerOf(uint256 _tokenId) {
221         require (ownerOf(_tokenId) == msg.sender);
222         _;
223     }
224 
225     /**
226     * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
227     * @param _tokenId uint256 ID of the token to validate
228     */
229     modifier canTransfer(uint256 _tokenId) {
230         require (isApprovedOrOwner(msg.sender, _tokenId));
231         _;
232     }
233 
234     /**
235     * @dev Gets the balance of the specified address
236     * @param _owner address to query the balance of
237     * @return uint256 representing the amount owned by the passed address
238     */
239     function balanceOf(address _owner) public view returns (uint256) {
240         require (_owner != address(0));
241         return ownedTokensCount[_owner];
242     }
243 
244     /**
245     * @dev Gets the owner of the specified token ID
246     * @param _tokenId uint256 ID of the token to query the owner of
247     * @return owner address currently marked as the owner of the given token ID
248     */
249     function ownerOf(uint256 _tokenId) public view returns (address) {
250         address owner = tokenOwner[_tokenId];
251         require (owner != address(0));
252         return owner;
253     }
254 
255     /**
256     * @dev Returns whether the specified token exists
257     * @param _tokenId uint256 ID of the token to query the existence of
258     * @return whether the token exists
259     */
260     function exists(uint256 _tokenId) public view returns (bool) {
261         address owner = tokenOwner[_tokenId];
262         return owner != address(0);
263     }
264 
265     /**
266     * @dev Approves another address to transfer the given token ID
267     * @dev The zero address indicates there is no approved address.
268     * @dev There can only be one approved address per token at a given time.
269     * @dev Can only be called by the token owner or an approved operator.
270     * @param _to address to be approved for the given token ID
271     * @param _tokenId uint256 ID of the token to be approved
272     */
273     function approve(address _to, uint256 _tokenId) public {
274         address owner = ownerOf(_tokenId);
275         require (_to != owner);
276         require (msg.sender == owner || isApprovedForAll(owner, msg.sender));
277 
278         tokenApprovals[_tokenId] = _to;
279         emit Approval(owner, _to, _tokenId);
280     }
281 
282     /**
283     * @dev Gets the approved address for a token ID, or zero if no address set
284     * @param _tokenId uint256 ID of the token to query the approval of
285     * @return address currently approved for the given token ID
286     */
287     function getApproved(uint256 _tokenId) public view returns (address) {
288         return tokenApprovals[_tokenId];
289     }
290 
291     /**
292     * @dev Sets or unsets the approval of a given operator
293     * @dev An operator is allowed to transfer all tokens of the sender on their behalf
294     * @param _to operator address to set the approval
295     * @param _approved representing the status of the approval to be set
296     */
297     function setApprovalForAll(address _to, bool _approved) public {
298         require (_to != msg.sender);
299         operatorApprovals[msg.sender][_to] = _approved;
300         emit ApprovalForAll(msg.sender, _to, _approved);
301     }
302 
303     /**
304     * @dev Tells whether an operator is approved by a given owner
305     * @param _owner owner address which you want to query the approval of
306     * @param _operator operator address which you want to query the approval of
307     * @return bool whether the given operator is approved by the given owner
308     */
309     function isApprovedForAll(
310         address _owner,
311         address _operator
312     )
313         public
314         view
315         returns (bool)
316     {
317         return operatorApprovals[_owner][_operator];
318     }
319 
320     /**
321     * @dev Transfers the ownership of a given token ID to another address
322     * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
323     * @dev Requires the msg sender to be the owner, approved, or operator
324     * @param _from current owner of the token
325     * @param _to address to receive the ownership of the given token ID
326     * @param _tokenId uint256 ID of the token to be transferred
327     */
328     function transferFrom(
329         address _from,
330         address _to,
331         uint256 _tokenId
332     )
333         public
334         canTransfer(_tokenId)
335     {
336         require (_from != address(0));
337         require (_to != address(0));
338 
339         clearApproval(_from, _tokenId);
340         removeTokenFrom(_from, _tokenId);
341         addTokenTo(_to, _tokenId);
342 
343         emit Transfer(_from, _to, _tokenId);
344     }
345 
346     /**
347     * @dev Safely transfers the ownership of a given token ID to another address
348     * @dev If the target address is a contract, it must implement `onERC721Received`,
349     *  which is called upon a safe transfer, and return the magic value
350     *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
351     *  the transfer is reverted.
352     * @dev Requires the msg sender to be the owner, approved, or operator
353     * @param _from current owner of the token
354     * @param _to address to receive the ownership of the given token ID
355     * @param _tokenId uint256 ID of the token to be transferred
356     */
357     function safeTransferFrom(
358         address _from,
359         address _to,
360         uint256 _tokenId
361     )
362         public
363         canTransfer(_tokenId)
364     {
365         // solium-disable-next-line arg-overflow
366         safeTransferFrom(_from, _to, _tokenId, "");
367     }
368 
369     /**
370     * @dev Safely transfers the ownership of a given token ID to another address
371     * @dev If the target address is a contract, it must implement `onERC721Received`,
372     *  which is called upon a safe transfer, and return the magic value
373     *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
374     *  the transfer is reverted.
375     * @dev Requires the msg sender to be the owner, approved, or operator
376     * @param _from current owner of the token
377     * @param _to address to receive the ownership of the given token ID
378     * @param _tokenId uint256 ID of the token to be transferred
379     * @param _data bytes data to send along with a safe transfer check
380     */
381     function safeTransferFrom(
382         address _from,
383         address _to,
384         uint256 _tokenId,
385         bytes _data
386     )
387         public
388         canTransfer(_tokenId)
389     {
390         transferFrom(_from, _to, _tokenId);
391         // solium-disable-next-line arg-overflow
392         require (checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
393     }
394 
395     /**
396     * @dev Returns whether the given spender can transfer a given token ID
397     * @param _spender address of the spender to query
398     * @param _tokenId uint256 ID of the token to be transferred
399     * @return bool whether the msg.sender is approved for the given token ID,
400     *  is an operator of the owner, or is the owner of the token
401     */
402     function isApprovedOrOwner(
403         address _spender,
404         uint256 _tokenId
405     )
406         internal
407         view
408         returns (bool)
409     {
410         address owner = ownerOf(_tokenId);
411         // Disable solium check because of
412         // https://github.com/duaraghav8/Solium/issues/175
413         // solium-disable-next-line operator-whitespace
414         return (
415         _spender == owner ||
416         getApproved(_tokenId) == _spender ||
417         isApprovedForAll(owner, _spender)
418         );
419     }
420 
421     /**
422     * @dev Internal function to mint a new token
423     * @dev Reverts if the given token ID already exists
424     * @param _to The address that will own the minted token
425     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
426     */
427     function _mint(address _to, uint256 _tokenId) internal {
428         require (_to != address(0));
429         addTokenTo(_to, _tokenId);
430         emit Transfer(address(0), _to, _tokenId);
431     }
432 
433     /**
434     * @dev Internal function to burn a specific token
435     * @dev Reverts if the token does not exist
436     * @param _tokenId uint256 ID of the token being burned by the msg.sender
437     */
438     function _burn(address _owner, uint256 _tokenId) internal {
439         clearApproval(_owner, _tokenId);
440         removeTokenFrom(_owner, _tokenId);
441         emit Transfer(_owner, address(0), _tokenId);
442     }
443 
444     /**
445     * @dev Internal function to clear current approval of a given token ID
446     * @dev Reverts if the given address is not indeed the owner of the token
447     * @param _owner owner of the token
448     * @param _tokenId uint256 ID of the token to be transferred
449     */
450     function clearApproval(address _owner, uint256 _tokenId) internal {
451         require (ownerOf(_tokenId) == _owner);
452         if (tokenApprovals[_tokenId] != address(0)) {
453             tokenApprovals[_tokenId] = address(0);
454         }
455     }
456 
457     /**
458     * @dev Internal function to add a token ID to the list of a given address
459     * @param _to address representing the new owner of the given token ID
460     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
461     */
462     function addTokenTo(address _to, uint256 _tokenId) internal {
463         require (tokenOwner[_tokenId] == address(0));
464         tokenOwner[_tokenId] = _to;
465         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
466     }
467 
468     /**
469     * @dev Internal function to remove a token ID from the list of a given address
470     * @param _from address representing the previous owner of the given token ID
471     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
472     */
473     function removeTokenFrom(address _from, uint256 _tokenId) internal {
474         require (ownerOf(_tokenId) == _from);
475         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
476         tokenOwner[_tokenId] = address(0);
477     }
478 
479     /**
480     * @dev Internal function to invoke `onERC721Received` on a target address
481     * @dev The call is not executed if the target address is not a contract
482     * @param _from address representing the previous owner of the given token ID
483     * @param _to target address that will receive the tokens
484     * @param _tokenId uint256 ID of the token to be transferred
485     * @param _data bytes optional data to send along with the call
486     * @return whether the call correctly returned the expected magic value
487     */
488     function checkAndCallSafeTransfer(
489         address _from,
490         address _to,
491         uint256 _tokenId,
492         bytes _data
493     )
494         internal
495         returns (bool)
496     {
497         if (!_to.isContract()) {
498             return true;
499         }
500         bytes4 retval = ERC721Receiver(_to).onERC721Received(
501             msg.sender, _from, _tokenId, _data);
502         return (retval == ERC721_RECEIVED);
503     }
504 }
505 
506 /**
507  * @title ERC721 token receiver interface
508  * @dev Interface for any contract that wants to support safeTransfers
509  *  from ERC721 asset contracts.
510  */
511 contract ERC721Receiver {
512     /**
513     * @dev Magic value to be returned upon successful reception of an NFT
514     *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
515     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
516     */
517     bytes4 public constant ERC721_RECEIVED = 0x150b7a02;
518 
519     /**
520     * @notice Handle the receipt of an NFT
521     * @dev The ERC721 smart contract calls this function on the recipient
522     *  after a `safetransfer`. This function MAY throw to revert and reject the
523     *  transfer. This function MUST use 50,000 gas or less. Return of other
524     *  than the magic value MUST result in the transaction being reverted.
525     *  Note: the contract address is always the message sender.
526     * @param _from The sending address
527     * @param _tokenId The NFT identifier which is being transfered
528     * @param _data Additional data with no specified format
529     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
530     */
531     function onERC721Received(
532         address _operator,
533         address _from,
534         uint256 _tokenId,
535         bytes _data
536     )
537         public
538         returns(bytes4);
539 }
540 
541 contract ERC721Holder is ERC721Receiver {
542     function onERC721Received(
543         address,
544         address,
545         uint256,
546         bytes
547     ) 
548         public
549         returns(bytes4)
550         {
551             return ERC721_RECEIVED;
552         }
553 }
554 
555 /**
556  * @title Full ERC721 Token
557  * This implementation includes all the required and some optional functionality of the ERC721 standard
558  * Moreover, it includes approve all functionality using operator terminology
559  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
560  */
561 contract ERC721Token is ERC721, ERC721BasicToken {
562 
563     // Token name
564     string internal name_;
565 
566     // Token symbol
567     string internal symbol_;
568 
569     // Mapping from owner to list of owned token IDs
570     mapping(address => uint256[]) internal ownedTokens;
571 
572     // Mapping from token ID to index of the owner tokens list
573     mapping(uint256 => uint256) internal ownedTokensIndex;
574 
575     // Array with all token ids, used for enumeration
576     uint256[] internal allTokens;
577 
578     // Mapping from token id to position in the allTokens array
579     mapping(uint256 => uint256) internal allTokensIndex;
580 
581     // Base Server Address for Token MetaData URI
582     string internal tokenURIBase;
583 
584     /**
585     * @dev Returns an URI for a given token ID
586     * @dev Throws if the token ID does not exist. May return an empty string.
587     * @notice The user/developper needs to add the tokenID, in the end of URL, to 
588     * use the URI and get all details. Ex. www.<apiURL>.com/token/<tokenID>
589     * @param _tokenId uint256 ID of the token to query
590     */
591     function tokenURI(uint256 _tokenId) public view returns (string) {
592         require (exists(_tokenId));
593         return tokenURIBase;
594     }
595 
596     /**
597     * @dev Gets the token ID at a given index of the tokens list of the requested owner
598     * @param _owner address owning the tokens list to be accessed
599     * @param _index uint256 representing the index to be accessed of the requested tokens list
600     * @return uint256 token ID at the given index of the tokens list owned by the requested address
601     */
602     function tokenOfOwnerByIndex(
603         address _owner,
604         uint256 _index
605     )
606         public
607         view
608         returns (uint256)
609     {
610         require (_index < balanceOf(_owner));
611         return ownedTokens[_owner][_index];
612     }
613 
614     /**
615     * @dev Gets the total amount of tokens stored by the contract
616     * @return uint256 representing the total amount of tokens
617     */
618     function totalSupply() public view returns (uint256) {
619         return allTokens.length;
620     }
621 
622     /**
623     * @dev Gets the token ID at a given index of all the tokens in this contract
624     * @dev Reverts if the index is greater or equal to the total number of tokens
625     * @param _index uint256 representing the index to be accessed of the tokens list
626     * @return uint256 token ID at the given index of the tokens list
627     */
628     function tokenByIndex(uint256 _index) public view returns (uint256) {
629         require (_index < totalSupply());
630         return allTokens[_index];
631     }
632 
633 
634     /**
635     * @dev Internal function to set the token URI for a given token
636     * @dev Reverts if the token ID does not exist
637     * @param _uri string URI to assign
638     */
639     function _setTokenURIBase(string _uri) internal {
640         tokenURIBase = _uri;
641     }
642 
643     /**
644     * @dev Internal function to add a token ID to the list of a given address
645     * @param _to address representing the new owner of the given token ID
646     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
647     */
648     function addTokenTo(address _to, uint256 _tokenId) internal {
649         super.addTokenTo(_to, _tokenId);
650         uint256 length = ownedTokens[_to].length;
651         ownedTokens[_to].push(_tokenId);
652         ownedTokensIndex[_tokenId] = length;
653     }
654 
655     /**
656     * @dev Internal function to remove a token ID from the list of a given address
657     * @param _from address representing the previous owner of the given token ID
658     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
659     */
660     function removeTokenFrom(address _from, uint256 _tokenId) internal {
661         super.removeTokenFrom(_from, _tokenId);
662 
663         // To prevent a gap in the array, we store the last token in the index of the token to delete, and
664         // then delete the last slot.
665         uint256 tokenIndex = ownedTokensIndex[_tokenId];
666         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
667         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
668 
669         ownedTokens[_from][tokenIndex] = lastToken;
670         // This also deletes the contents at the last position of the array
671         ownedTokens[_from].length--;
672 
673         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
674         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
675         // the lastToken to the first position, and then dropping the element placed in the last position of the list
676 
677         ownedTokensIndex[_tokenId] = 0;
678         ownedTokensIndex[lastToken] = tokenIndex;
679     }
680 
681     /**
682     * @dev Gets the token name
683     * @return string representing the token name
684     */
685     function name() public view returns (string) {
686         return name_;
687     }
688 
689     /**
690     * @dev Gets the token symbol
691     * @return string representing the token symbol
692     */
693     function symbol() public view returns (string) {
694         return symbol_;
695     }
696 
697     /**
698     * @dev Internal function to mint a new token
699     * @dev Reverts if the given token ID already exists
700     * @param _to address the beneficiary that will own the minted token
701     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
702     */
703     function _mint(address _to, uint256 _tokenId) internal {
704         super._mint(_to, _tokenId);
705 
706         allTokensIndex[_tokenId] = allTokens.length;
707         allTokens.push(_tokenId);
708     }
709 
710     /**
711     * @dev Internal function to burn a specific token
712     * @dev Reverts if the token does not exist
713     * @param _owner owner of the token to burn
714     * @param _tokenId uint256 ID of the token being burned by the msg.sender
715     */
716     function _burn(address _owner, uint256 _tokenId) internal {
717         super._burn(_owner, _tokenId);
718 
719         // Reorg all tokens array
720         uint256 tokenIndex = allTokensIndex[_tokenId];
721         uint256 lastTokenIndex = allTokens.length.sub(1);
722         uint256 lastToken = allTokens[lastTokenIndex];
723 
724         allTokens[tokenIndex] = lastToken;
725         allTokens[lastTokenIndex] = 0;
726 
727         allTokens.length--;
728         allTokensIndex[_tokenId] = 0;
729         allTokensIndex[lastToken] = tokenIndex;
730     }
731 
732     bytes4 constant InterfaceSignature_ERC165 = 0x01ffc9a7;
733     /*
734     bytes4(keccak256('supportsInterface(bytes4)'));
735     */
736 
737     bytes4 constant InterfaceSignature_ERC721Enumerable = 0x780e9d63;
738     /*
739     bytes4(keccak256('totalSupply()')) ^
740     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
741     bytes4(keccak256('tokenByIndex(uint256)'));
742     */
743 
744     bytes4 constant InterfaceSignature_ERC721Metadata = 0x5b5e139f;
745     /*
746     bytes4(keccak256('name()')) ^
747     bytes4(keccak256('symbol()')) ^
748     bytes4(keccak256('tokenURI(uint256)'));
749     */
750 
751     bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
752     /*
753     bytes4(keccak256('balanceOf(address)')) ^
754     bytes4(keccak256('ownerOf(uint256)')) ^
755     bytes4(keccak256('approve(address,uint256)')) ^
756     bytes4(keccak256('getApproved(uint256)')) ^
757     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
758     bytes4(keccak256('isApprovedForAll(address,address)')) ^
759     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
760     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
761     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'));
762     */
763 
764     bytes4 public constant InterfaceSignature_ERC721Optional =- 0x4f558e79;
765     /*
766     bytes4(keccak256('exists(uint256)'));
767     */
768 
769     /**
770     * @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
771     * @dev Returns true for any standardized interfaces implemented by this contract.
772     * @param _interfaceID bytes4 the interface to check for
773     * @return true for any standardized interfaces implemented by this contract.
774     */
775     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
776     {
777         return ((_interfaceID == InterfaceSignature_ERC165)
778         || (_interfaceID == InterfaceSignature_ERC721)
779         || (_interfaceID == InterfaceSignature_ERC721Enumerable)
780         || (_interfaceID == InterfaceSignature_ERC721Metadata));
781     }
782 
783     function implementsERC721() public pure returns (bool) {
784         return true;
785     }
786 
787 }
788 /* Lucid Sight, Inc. ERC-721 Collectibles. 
789  * @title LSNFT - Lucid Sight, Inc. Non-Fungible Token
790  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
791  */
792 contract LSNFT is ERC721Token {
793   
794   /*** EVENTS ***/
795 
796   /// @dev The Created event is fired whenever a new collectible comes into existence.
797   event Created(address owner, uint256 tokenId);
798   
799   /*** DATATYPES ***/
800   
801   struct NFT {
802     // The sequence of potential attributes a Collectible has and can provide in creation events. Used in Creation logic to spwan new Cryptos
803     uint256 attributes;
804 
805     // Current Game Card identifier
806     uint256 currentGameCardId;
807 
808     // MLB Game Identifier (if asset generated as a game reward)
809     uint256 mlbGameId;
810 
811     // player orverride identifier
812     uint256 playerOverrideId;
813 
814     // official MLB Player ID
815     uint256 mlbPlayerId;
816 
817     // earnedBy : In some instances we may want to retroactively write which MLB player triggered
818     // the event that created a Legendary Trophy. This optional field should be able to be written
819     // to after generation if we determine an event was newsworthy enough
820     uint256 earnedBy;
821     
822     // asset metadata
823     uint256 assetDetails;
824     
825     // Attach/Detach Flag
826     uint256 isAttached;
827   }
828 
829   NFT[] allNFTs;
830 
831   function isLSNFT() public view returns (bool) {
832     return true;
833   }
834 
835   /// For creating NFT
836   function _createNFT (
837     uint256[5] _nftData,
838     address _owner,
839     uint256 _isAttached)
840     internal
841     returns(uint256) {
842 
843     NFT memory _lsnftObj = NFT({
844         attributes : _nftData[1],
845         currentGameCardId : 0,
846         mlbGameId : _nftData[2],
847         playerOverrideId : _nftData[3],
848         assetDetails: _nftData[0],
849         isAttached: _isAttached,
850         mlbPlayerId: _nftData[4],
851         earnedBy: 0
852     });
853 
854     uint256 newLSNFTId = allNFTs.push(_lsnftObj) - 1;
855 
856     _mint(_owner, newLSNFTId);
857     
858     // Created event
859     emit Created(_owner, newLSNFTId);
860 
861     return newLSNFTId;
862   }
863 
864   /// @dev Gets attributes of NFT  
865   function _getAttributesOfToken(uint256 _tokenId) internal returns(NFT) {
866     NFT storage lsnftObj = allNFTs[_tokenId];  
867     return lsnftObj;
868   }
869 
870   function _approveForSale(address _owner, address _to, uint256 _tokenId) internal {
871     address owner = ownerOf(_tokenId);
872     require (_to != owner);
873     require (_owner == owner || isApprovedForAll(owner, _owner));
874 
875     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
876         tokenApprovals[_tokenId] = _to;
877         emit Approval(_owner, _to, _tokenId);
878     }
879   }
880 }
881 
882 /** Controls state and access rights for contract functions
883  * @title Operational Control
884  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
885  * Inspired and adapted from contract created by OpenZeppelin 
886  * Ref: https://github.com/OpenZeppelin/zeppelin-solidity/
887  */
888 contract OperationalControl {
889     /// Facilitates access & control for the game.
890     /// Roles:
891     ///  -The Managers (Primary/Secondary): Has universal control of all elements (No ability to withdraw)
892     ///  -The Banker: The Bank can withdraw funds and adjust fees / prices.
893     ///  -otherManagers: Contracts that need access to functions for gameplay
894 
895     /// @dev Emited when contract is upgraded
896     event ContractUpgrade(address newContract);
897 
898     /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles.
899     address public managerPrimary;
900     address public managerSecondary;
901     address public bankManager;
902 
903     // Contracts that require access for gameplay
904     mapping(address => uint8) public otherManagers;
905 
906     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
907     bool public paused = false;
908 
909     // @dev Keeps track whether the contract erroredOut. When that is true, most actions are blocked & refund can be claimed
910     bool public error = false;
911 
912     /**
913      * @dev Operation modifiers for limiting access only to Managers
914      */
915     modifier onlyManager() {
916         require (msg.sender == managerPrimary || msg.sender == managerSecondary);
917         _;
918     }
919 
920     /**
921      * @dev Operation modifiers for limiting access to only Banker
922      */
923     modifier onlyBanker() {
924         require (msg.sender == bankManager);
925         _;
926     }
927 
928     /**
929      * @dev Operation modifiers for any Operators
930      */
931     modifier anyOperator() {
932         require (
933             msg.sender == managerPrimary ||
934             msg.sender == managerSecondary ||
935             msg.sender == bankManager ||
936             otherManagers[msg.sender] == 1
937         );
938         _;
939     }
940 
941     /**
942      * @dev        Operation modifier for any Other Manager
943      */
944     modifier onlyOtherManagers() {
945         require (otherManagers[msg.sender] == 1);
946         _;
947     }
948 
949     /**
950      * @dev Assigns a new address to act as the Primary Manager.
951      * @param _newGM    New primary manager address
952      */
953     function setPrimaryManager(address _newGM) external onlyManager {
954         require (_newGM != address(0));
955 
956         managerPrimary = _newGM;
957     }
958 
959     /**
960      * @dev Assigns a new address to act as the Secondary Manager.
961      * @param _newGM    New Secondary Manager Address
962      */
963     function setSecondaryManager(address _newGM) external onlyManager {
964         require (_newGM != address(0));
965 
966         managerSecondary = _newGM;
967     }
968 
969     /**
970      * @dev Assigns a new address to act as the Banker.
971      * @param _newBK    New Banker Address
972      */
973     function setBanker(address _newBK) external onlyManager {
974         require (_newBK != address(0));
975 
976         bankManager = _newBK;
977     }
978 
979     /// @dev Assigns a new address to act as the Other Manager. (State = 1 is active, 0 is disabled)
980     function setOtherManager(address _newOp, uint8 _state) external onlyManager {
981         require (_newOp != address(0));
982 
983         otherManagers[_newOp] = _state;
984     }
985 
986     /*** Pausable functionality adapted from OpenZeppelin ***/
987 
988     /// @dev Modifier to allow actions only when the contract IS NOT paused
989     modifier whenNotPaused() {
990         require (!paused);
991         _;
992     }
993 
994     /// @dev Modifier to allow actions only when the contract IS paused
995     modifier whenPaused {
996         require (paused);
997         _;
998     }
999 
1000     /// @dev Modifier to allow actions only when the contract has Error
1001     modifier whenError {
1002         require (error);
1003         _;
1004     }
1005 
1006     /**
1007      * @dev Called by any Operator role to pause the contract.
1008      * Used only if a bug or exploit is discovered (Here to limit losses / damage)
1009      */
1010     function pause() external onlyManager whenNotPaused {
1011         paused = true;
1012     }
1013 
1014     /**
1015      * @dev Unpauses the smart contract. Can only be called by the Game Master
1016      */
1017     function unpause() public onlyManager whenPaused {
1018         // can't unpause if contract was upgraded
1019         paused = false;
1020     }
1021 
1022     /**
1023      * @dev Errors out the contract thus mkaing the contract non-functionable
1024      */
1025     function hasError() public onlyManager whenPaused {
1026         error = true;
1027     }
1028 
1029     /**
1030      * @dev Removes the Error Hold from the contract and resumes it for working
1031      */
1032     function noError() public onlyManager whenPaused {
1033         error = false;
1034     }
1035 }
1036 
1037 /** Base contract for MLBNFT Collectibles. Holds all commons, events and base variables.
1038  * @title Lucid Sight MLB NFT 2018
1039  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
1040  */
1041 contract CollectibleBase is LSNFT {
1042 
1043     /*** EVENTS ***/
1044 
1045     /// @dev Event emitted when an attribute of the player is updated
1046     event AssetUpdated(uint256 tokenId);
1047 
1048     /*** STORAGE ***/
1049 
1050     /// @dev A mapping of Team Id to Team Sequence Number to Collectible
1051     mapping (uint256 => mapping (uint32 => uint256) ) public nftTeamIdToSequenceIdToCollectible;
1052 
1053     /// @dev A mapping from Team IDs to the Sequqence Number .
1054     mapping (uint256 => uint32) public nftTeamIndexToCollectibleCount;
1055 
1056     /// @dev Array to hold details on attachment for each LS NFT Collectible
1057     mapping(uint256 => uint256[]) public nftCollectibleAttachments;
1058 
1059     /// @dev Mapping to control the asset generation per season.
1060     mapping(uint256 => uint256) public generationSeasonController;
1061 
1062     /// @dev Mapping for generation Season Dict.
1063     mapping(uint256 => uint256) public generationSeasonDict;
1064 
1065     /// @dev internal function to update player override id
1066     function _updatePlayerOverrideId(uint256 _tokenId, uint256 _newPlayerOverrideId) internal {
1067 
1068         // Get Token Obj
1069         NFT storage lsnftObj = allNFTs[_tokenId];
1070         lsnftObj.playerOverrideId = _newPlayerOverrideId;
1071 
1072         // Update Token Data with new updated attributes
1073         allNFTs[_tokenId] = lsnftObj;
1074 
1075         emit AssetUpdated(_tokenId);
1076     }
1077 
1078     /**
1079      * @dev An internal method that helps in generation of new NFT Collectibles
1080      * @param _teamId           teamId of the asset/token/collectible
1081      * @param _attributes       attributes of asset/token/collectible
1082      * @param _owner            owner of asset/token/collectible
1083      * @param _isAttached       State of the asset (attached or dettached)
1084      * @param _nftData          Array of data required for creation
1085      */
1086     function _createNFTCollectible(
1087         uint8 _teamId,
1088         uint256 _attributes,
1089         address _owner,
1090         uint256 _isAttached,
1091         uint256[5] _nftData
1092     )
1093         internal
1094         returns (uint256)
1095     {
1096         uint256 generationSeason = (_attributes % 1000000).div(1000);
1097         require (generationSeasonController[generationSeason] == 1);
1098 
1099         uint32 _sequenceId = getSequenceId(_teamId);
1100 
1101         uint256 newNFTCryptoId = _createNFT(_nftData, _owner, _isAttached);
1102         
1103         nftTeamIdToSequenceIdToCollectible[_teamId][_sequenceId] = newNFTCryptoId;
1104         nftTeamIndexToCollectibleCount[_teamId] = _sequenceId;
1105 
1106         return newNFTCryptoId;
1107     }
1108     
1109     function getSequenceId(uint256 _teamId) internal returns (uint32) {
1110         return (nftTeamIndexToCollectibleCount[_teamId] + 1);
1111     }
1112 
1113     /**
1114      * @dev Internal function, Helps in updating the Creation Stop Time
1115      * @param _season    Season UINT Code
1116      * @param _value    0 - Not allowed, 1 - Allowed
1117      */
1118     function _updateGenerationSeasonFlag(uint256 _season, uint8 _value) internal {
1119         generationSeasonController[_season] = _value;
1120     }
1121 
1122     /** @param _owner The owner whose ships tokens we are interested in.
1123       * @dev This method MUST NEVER be called by smart contract code. First, it's fairly
1124       *  expensive (it walks the entire Collectibles owners array looking for NFT belonging to owner)
1125     */      
1126     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
1127         uint256 tokenCount = balanceOf(_owner);
1128 
1129         if (tokenCount == 0) {
1130             // Return an empty array
1131             return new uint256[](0);
1132         } else {
1133             uint256[] memory result = new uint256[](tokenCount);
1134             uint256 totalItems = balanceOf(_owner);
1135             uint256 resultIndex = 0;
1136 
1137             // We count on the fact that all Collectible have IDs starting at 0 and increasing
1138             // sequentially up to the total count.
1139             uint256 _assetId;
1140 
1141             for (_assetId = 0; _assetId < totalItems; _assetId++) {
1142                 result[resultIndex] = tokenOfOwnerByIndex(_owner,_assetId);
1143                 resultIndex++;
1144             }
1145 
1146             return result;
1147         }
1148     }
1149 
1150     /// @dev internal function to update MLB player id
1151     function _updateMLBPlayerId(uint256 _tokenId, uint256 _newMLBPlayerId) internal {
1152 
1153         // Get Token Obj
1154         NFT storage lsnftObj = allNFTs[_tokenId];
1155         
1156         lsnftObj.mlbPlayerId = _newMLBPlayerId;
1157 
1158         // Update Token Data with new updated attributes
1159         allNFTs[_tokenId] = lsnftObj;
1160 
1161         emit AssetUpdated(_tokenId);
1162     }
1163 
1164     /// @dev internal function to update asset earnedBy value for an asset/token
1165     function _updateEarnedBy(uint256 _tokenId, uint256 _earnedBy) internal {
1166 
1167         // Get Token Obj
1168         NFT storage lsnftObj = allNFTs[_tokenId];
1169         
1170         lsnftObj.earnedBy = _earnedBy;
1171 
1172         // Update Token Data with new updated attributes
1173         allNFTs[_tokenId] = lsnftObj;
1174 
1175         emit AssetUpdated(_tokenId);
1176     }
1177 }
1178 
1179 /* Handles creating new Collectibles for promo and seed.
1180  * @title CollectibleMinting Minting
1181  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
1182  * Inspired and adapted from KittyCore.sol created by Axiom Zen
1183  * Ref: ETH Contract - 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d
1184  */
1185 contract CollectibleMinting is CollectibleBase, OperationalControl {
1186 
1187     uint256 public rewardsRedeemed = 0;
1188 
1189     /// @dev Counts the number of promo collectibles that can be made per-team
1190     uint256[31]  public promoCreatedCount;
1191     
1192     /// @dev Counts the number of seed collectibles that can be made in total
1193     uint256 public seedCreatedCount;
1194 
1195     /// @dev Bool to toggle batch support
1196     bool public isBatchSupported = true;
1197     
1198     /// @dev A mapping of contracts that can trigger functions
1199     mapping (address => bool) public contractsApprovedList;
1200     
1201     /**
1202      * @dev        Helps to toggle batch supported flag
1203      * @param      _flag  The flag
1204      */
1205     function updateBatchSupport(bool _flag) public onlyManager {
1206         isBatchSupported = _flag;
1207     }
1208 
1209     modifier canCreate() { 
1210         require (contractsApprovedList[msg.sender] || 
1211             msg.sender == managerPrimary ||
1212             msg.sender == managerSecondary); 
1213         _; 
1214     }
1215     
1216     /**
1217      * @dev Add an address to the Approved List
1218      * @param _newAddress   The new address to be approved for interaction with the contract
1219      */
1220     function addToApproveList(address _newAddress) public onlyManager {
1221         
1222         require (!contractsApprovedList[_newAddress]);
1223         contractsApprovedList[_newAddress] = true;
1224     }
1225 
1226     /**
1227      * @dev Remove an address from Approved List
1228      * @param _newAddress   The new address to be approved for interaction with the contract
1229      */
1230     function removeFromApproveList(address _newAddress) public onlyManager {
1231         require (contractsApprovedList[_newAddress]);
1232         delete contractsApprovedList[_newAddress];
1233     }
1234 
1235     
1236     /**
1237      * @dev Generates promo collectibles. Only callable by Game Master, with isAttached as 0.
1238      * @notice The generation of an asset if limited via the generationSeasonController
1239      * @param _teamId           teamId of the asset/token/collectible
1240      * @param _posId            position of the asset/token/collectible
1241      * @param _attributes       attributes of asset/token/collectible
1242      * @param _owner            owner of asset/token/collectible
1243      * @param _gameId          mlb game Identifier
1244      * @param _playerOverrideId player override identifier
1245      * @param _mlbPlayerId      official mlb player identifier
1246      */
1247     function createPromoCollectible(
1248         uint8 _teamId,
1249         uint8 _posId,
1250         uint256 _attributes,
1251         address _owner,
1252         uint256 _gameId,
1253         uint256 _playerOverrideId,
1254         uint256 _mlbPlayerId)
1255         external
1256         canCreate
1257         whenNotPaused
1258         returns (uint256)
1259         {
1260 
1261         address nftOwner = _owner;
1262         if (nftOwner == address(0)) {
1263              nftOwner = managerPrimary;
1264         }
1265 
1266         if(allNFTs.length > 0) {
1267             promoCreatedCount[_teamId]++;
1268         }
1269         
1270         uint32 _sequenceId = getSequenceId(_teamId);
1271         
1272         uint256 assetDetails = uint256(uint64(now));
1273         assetDetails |= uint256(_sequenceId)<<64;
1274         assetDetails |= uint256(_teamId)<<96;
1275         assetDetails |= uint256(_posId)<<104;
1276 
1277         uint256[5] memory _nftData = [assetDetails, _attributes, _gameId, _playerOverrideId, _mlbPlayerId];
1278         
1279         return _createNFTCollectible(_teamId, _attributes, nftOwner, 0, _nftData);
1280     }
1281 
1282     /**
1283      * @dev Generaes a new single seed Collectible, with isAttached as 0.
1284      * @notice Helps in creating seed collectible.The generation of an asset if limited via the generationSeasonController
1285      * @param _teamId           teamId of the asset/token/collectible
1286      * @param _posId            position of the asset/token/collectible
1287      * @param _attributes       attributes of asset/token/collectible
1288      * @param _owner            owner of asset/token/collectible
1289      * @param _gameId          mlb game Identifier
1290      * @param _playerOverrideId player override identifier
1291      * @param _mlbPlayerId      official mlb player identifier
1292      */
1293     function createSeedCollectible(
1294         uint8 _teamId,
1295         uint8 _posId,
1296         uint256 _attributes,
1297         address _owner,
1298         uint256 _gameId,
1299         uint256 _playerOverrideId,
1300         uint256 _mlbPlayerId)
1301         external
1302         canCreate
1303         whenNotPaused
1304         returns (uint256) {
1305 
1306         address nftOwner = _owner;
1307         
1308         if (nftOwner == address(0)) {
1309              nftOwner = managerPrimary;
1310         }
1311         
1312         seedCreatedCount++;
1313         uint32 _sequenceId = getSequenceId(_teamId);
1314         
1315         uint256 assetDetails = uint256(uint64(now));
1316         assetDetails |= uint256(_sequenceId)<<64;
1317         assetDetails |= uint256(_teamId)<<96;
1318         assetDetails |= uint256(_posId)<<104;
1319 
1320         uint256[5] memory _nftData = [assetDetails, _attributes, _gameId, _playerOverrideId, _mlbPlayerId];
1321         
1322         return _createNFTCollectible(_teamId, _attributes, nftOwner, 0, _nftData);
1323     }
1324 
1325     /**
1326      * @dev Generate new Reward Collectible and transfer it to the owner, with isAttached as 0.
1327      * @notice Helps in redeeming the Rewards using our Oracle. Creates & transfers the asset to the redeemer (_owner)
1328      * The generation of an asset if limited via the generationSeasonController
1329      * @param _teamId           teamId of the asset/token/collectible
1330      * @param _posId            position of the asset/token/collectible
1331      * @param _attributes       attributes of asset/token/collectible
1332      * @param _owner            owner (redeemer) of asset/token/collectible
1333      * @param _gameId           mlb game Identifier
1334      * @param _playerOverrideId player override identifier
1335      * @param _mlbPlayerId      official mlb player identifier
1336      */
1337     function createRewardCollectible (
1338         uint8 _teamId,
1339         uint8 _posId,
1340         uint256 _attributes,
1341         address _owner,
1342         uint256 _gameId,
1343         uint256 _playerOverrideId,
1344         uint256 _mlbPlayerId)
1345         external
1346         canCreate
1347         whenNotPaused
1348         returns (uint256) {
1349 
1350         address nftOwner = _owner;
1351         
1352         if (nftOwner == address(0)) {
1353              nftOwner = managerPrimary;
1354         }
1355         
1356         rewardsRedeemed++;
1357         uint32 _sequenceId = getSequenceId(_teamId);
1358         
1359         uint256 assetDetails = uint256(uint64(now));
1360         assetDetails |= uint256(_sequenceId)<<64;
1361         assetDetails |= uint256(_teamId)<<96;
1362         assetDetails |= uint256(_posId)<<104;
1363 
1364         uint256[5] memory _nftData = [assetDetails, _attributes, _gameId, _playerOverrideId, _mlbPlayerId];
1365         
1366         return _createNFTCollectible(_teamId, _attributes, nftOwner, 0, _nftData);
1367     }
1368 
1369     /**
1370      * @dev Generate new ETH Card Collectible, with isAttached as 2.
1371      * @notice Helps to generate Collectibles/Tokens/Asset and transfer to ETH Cards,
1372      * which can be redeemed using our web-app.The generation of an asset if limited via the generationSeasonController
1373      * @param _teamId           teamId of the asset/token/collectible
1374      * @param _posId            position of the asset/token/collectible
1375      * @param _attributes       attributes of asset/token/collectible
1376      * @param _owner            owner of asset/token/collectible
1377      * @param _gameId           mlb game Identifier
1378      * @param _playerOverrideId player override identifier
1379      * @param _mlbPlayerId      official mlb player identifier
1380      */
1381     function createETHCardCollectible (
1382         uint8 _teamId,
1383         uint8 _posId,
1384         uint256 _attributes,
1385         address _owner,
1386         uint256 _gameId,
1387         uint256 _playerOverrideId,
1388         uint256 _mlbPlayerId)
1389         external
1390         canCreate
1391         whenNotPaused
1392         returns (uint256) {
1393 
1394         address nftOwner = _owner;
1395         
1396         if (nftOwner == address(0)) {
1397              nftOwner = managerPrimary;
1398         }
1399         
1400         rewardsRedeemed++;
1401         uint32 _sequenceId = getSequenceId(_teamId);
1402         
1403         uint256 assetDetails = uint256(uint64(now));
1404         assetDetails |= uint256(_sequenceId)<<64;
1405         assetDetails |= uint256(_teamId)<<96;
1406         assetDetails |= uint256(_posId)<<104;
1407 
1408         uint256[5] memory _nftData = [assetDetails, _attributes, _gameId, _playerOverrideId, _mlbPlayerId];
1409         
1410         return _createNFTCollectible(_teamId, _attributes, nftOwner, 2, _nftData);
1411     }
1412 }
1413 
1414 /* @title Interface for MLBNFT Contract
1415  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
1416  */
1417 contract SaleManager {
1418     function createSale(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _owner) external;
1419 }
1420 
1421 /**
1422  * MLBNFT manages all aspects of the Lucid Sight, Inc. CryptoBaseball.
1423  * @title MLBNFT
1424  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
1425  */
1426 contract MLBNFT is CollectibleMinting {
1427     
1428     /// @dev Set in case the MLBNFT contract requires an upgrade
1429     address public newContractAddress;
1430 
1431     string public constant MLB_Legal = "Major League Baseball trademarks and copyrights are used with permission of the applicable MLB entity.  All rights reserved.";
1432 
1433     // Time LS Oracle has to respond to detach requests
1434     uint32 public detachmentTime = 0;
1435 
1436     // Indicates if attached system is Active (Transfers will be blocked if attached and active)
1437     bool public attachedSystemActive;
1438 
1439     // Sale Manager Contract
1440     SaleManager public saleManagerAddress;
1441 
1442     /**
1443      * @dev MLBNFT constructor.
1444      */
1445     constructor() public {
1446         // Starts paused.
1447         paused = true;
1448         managerPrimary = msg.sender;
1449         managerSecondary = msg.sender;
1450         bankManager = msg.sender;
1451         name_ = "LucidSight-MLB-NFT";
1452         symbol_ = "MLBCB";
1453     }
1454 
1455     /**
1456      * @dev        Sets the address for the NFT Contract
1457      * @param      _saleManagerAddress  The nft address
1458      */
1459     function setSaleManagerAddress(address _saleManagerAddress) public onlyManager {
1460         require (_saleManagerAddress != address(0));
1461         saleManagerAddress = SaleManager(_saleManagerAddress);
1462     }
1463 
1464     /**
1465     * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
1466     * @param _tokenId uint256 ID of the token to validate
1467     */
1468     modifier canTransfer(uint256 _tokenId) {
1469         uint256 isAttached = checkIsAttached(_tokenId);
1470         if(isAttached == 2) {
1471             //One-Time Auth for Physical Card Transfers
1472             require (msg.sender == managerPrimary ||
1473                 msg.sender == managerSecondary ||
1474                 msg.sender == bankManager ||
1475                 otherManagers[msg.sender] == 1
1476             );
1477             updateIsAttached(_tokenId, 0);
1478         } else if(attachedSystemActive == true && isAttached >= 1) {
1479             require (msg.sender == managerPrimary ||
1480                 msg.sender == managerSecondary ||
1481                 msg.sender == bankManager ||
1482                 otherManagers[msg.sender] == 1
1483             );
1484         }
1485         else {
1486             require (isApprovedOrOwner(msg.sender, _tokenId));
1487         }
1488     _;
1489     }
1490 
1491     /**
1492      * @dev Used to mark the smart contract as upgraded, in case of a issue
1493      * @param _v2Address    The new contract address
1494      */
1495     function setNewAddress(address _v2Address) external onlyManager {
1496         require (_v2Address != address(0));
1497         newContractAddress = _v2Address;
1498         emit ContractUpgrade(_v2Address);
1499     }
1500 
1501     /**
1502      * @dev Returns all the relevant information about a specific Collectible.
1503      * @notice Get details about your collectible
1504      * @param _tokenId              The token identifier
1505      * @return isAttached           Is Object attached
1506      * @return teamId               team identifier of the asset/token/collectible
1507      * @return positionId           position identifier of the asset/token/collectible
1508      * @return creationTime         creation timestamp
1509      * @return attributes           attribute of the asset/token/collectible
1510      * @return currentGameCardId    current game card of the asset/token/collectible
1511      * @return mlbGameID            mlb game identifier in which the asset/token/collectible was generated
1512      * @return playerOverrideId     player override identifier of the asset/token/collectible
1513      * @return playerStatus         status of the player (Rookie/Veteran/Historical)
1514      * @return playerHandedness     handedness of the asset
1515      * @return mlbPlayerId          official MLB Player Identifier
1516      */
1517     function getCollectibleDetails(uint256 _tokenId)
1518         external
1519         view
1520         returns (
1521         uint256 isAttached,
1522         uint32 sequenceId,
1523         uint8 teamId,
1524         uint8 positionId,
1525         uint64 creationTime,
1526         uint256 attributes,
1527         uint256 playerOverrideId,
1528         uint256 mlbGameId,
1529         uint256 currentGameCardId,
1530         uint256 mlbPlayerId,
1531         uint256 earnedBy,
1532         uint256 generationSeason
1533         ) {
1534         NFT memory obj  = _getAttributesOfToken(_tokenId);
1535         
1536         attributes = obj.attributes;
1537         currentGameCardId = obj.currentGameCardId;
1538         mlbGameId = obj.mlbGameId;
1539         playerOverrideId = obj.playerOverrideId;
1540         mlbPlayerId = obj.mlbPlayerId;
1541 
1542         creationTime = uint64(obj.assetDetails);
1543         sequenceId = uint32(obj.assetDetails>>64);
1544         teamId = uint8(obj.assetDetails>>96);
1545         positionId = uint8(obj.assetDetails>>104);
1546         isAttached = obj.isAttached;
1547         earnedBy = obj.earnedBy;
1548 
1549         generationSeason = generationSeasonDict[(obj.attributes % 1000000) / 1000];
1550     }
1551 
1552     
1553     /**
1554      * @dev This is public rather than external so we can call super.unpause
1555      * without using an expensive CALL.
1556      */
1557     function unpause() public onlyManager {
1558         /// Actually unpause the contract.
1559         super.unpause();
1560     }
1561 
1562     /**
1563      * @dev Helper function to get the teamID of a collectible.To avoid using getCollectibleDetails
1564      * @notice Returns the teamID associated with the asset/collectible/token
1565      * @param _tokenId  The token identifier
1566      */
1567     function getTeamId(uint256 _tokenId) external view returns (uint256) {
1568         NFT memory obj  = _getAttributesOfToken(_tokenId);
1569 
1570         uint256 teamId = uint256(uint8(obj.assetDetails>>96));
1571         return uint256(teamId);
1572     }
1573 
1574     /**
1575      * @dev Helper function to get the position of a collectible.To avoid using getCollectibleDetails
1576      * @notice Returns the position of the asset/collectible/token
1577      * @param _tokenId  The token identifier
1578      */
1579     function getPositionId(uint256 _tokenId) external view returns (uint256) {
1580         NFT memory obj  = _getAttributesOfToken(_tokenId);
1581 
1582         uint256 positionId = uint256(uint8(obj.assetDetails>>104));
1583 
1584         return positionId;
1585     }
1586 
1587     /**
1588      * @dev Helper function to get the game card. To avoid using getCollectibleDetails
1589      * @notice Returns the gameCard associated with the asset/collectible/token
1590      * @param _tokenId  The token identifier
1591      */
1592     function getGameCardId(uint256 _tokenId) public view returns (uint256) {
1593         NFT memory obj  = _getAttributesOfToken(_tokenId);
1594         return obj.currentGameCardId;
1595     }
1596 
1597     /**
1598      * @dev Returns isAttached property value for an asset/collectible/token
1599      * @param _tokenId  The token identifier
1600      */
1601     function checkIsAttached(uint256 _tokenId) public view returns (uint256) {
1602         NFT memory obj  = _getAttributesOfToken(_tokenId);
1603         return obj.isAttached;
1604     }
1605 
1606     /**
1607      * @dev Helper function to get the attirbute of the collectible.To avoid using getCollectibleDetails
1608      * @notice Returns the ability of an asset/collectible/token from attributes.
1609      * @param _tokenId  The token identifier
1610      * @return ability  ability of the asset
1611      */
1612     function getAbilitiesForCollectibleId(uint256 _tokenId) external view returns (uint256 ability) {
1613         NFT memory obj  = _getAttributesOfToken(_tokenId);
1614         uint256 _attributes = uint256(obj.attributes);
1615         ability = (_attributes % 1000);
1616     }
1617 
1618     /**
1619      * @dev Only allows trasnctions to go throught if the msg.sender is in the apporved list
1620      * @notice Updates the gameCardID properrty of the asset
1621      * @param _gameCardNumber  The game card number
1622      * @param _playerId        The player identifier
1623      */
1624     function updateCurrentGameCardId(uint256 _gameCardNumber, uint256 _playerId) public whenNotPaused {
1625         require (contractsApprovedList[msg.sender]);
1626 
1627         NFT memory obj  = _getAttributesOfToken(_playerId);
1628         
1629         obj.currentGameCardId = _gameCardNumber;
1630         
1631         if ( _gameCardNumber == 0 ) {
1632             obj.isAttached = 0;
1633         } else {
1634             obj.isAttached = 1;
1635         }
1636 
1637         allNFTs[_playerId] = obj;
1638     }
1639 
1640     /**
1641      * @dev Only Manager can add an attachment (special events) to the collectible
1642      * @notice Adds an attachment to collectible.
1643      * @param _tokenId  The token identifier
1644      * @param _attachment  The attachment
1645      */
1646     function addAttachmentToCollectible ( 
1647         uint256 _tokenId,
1648         uint256 _attachment)
1649         external
1650         onlyManager
1651         whenNotPaused {
1652         require (exists(_tokenId));
1653 
1654         nftCollectibleAttachments[_tokenId].push(_attachment);
1655         emit AssetUpdated(_tokenId);
1656     }
1657 
1658     /**
1659      * @dev It will remove the attachment form the collectible. We will need to re-add all attachment(s) if removed.
1660      * @notice Removes all attachments from collectible.
1661      * @param _tokenId  The token identifier
1662      */
1663     function removeAllAttachmentsFromCollectible(uint256 _tokenId)
1664         external
1665         onlyManager
1666         whenNotPaused {
1667 
1668         require (exists(_tokenId));
1669         
1670         delete nftCollectibleAttachments[_tokenId];
1671         emit AssetUpdated(_tokenId);
1672     }
1673 
1674     /**
1675      * @notice Transfers the ownership of NFT from one address to another address
1676      * @dev responsible for gifting assets to other user.
1677      * @param _to       to address
1678      * @param _tokenId  The token identifier
1679      */
1680     function giftAsset(address _to, uint256 _tokenId) public whenNotPaused {        
1681         safeTransferFrom(msg.sender, _to, _tokenId);
1682     }
1683     
1684     /**
1685      * @dev responsible for setting the tokenURI.
1686      * @notice The user/developper needs to add the tokenID, in the end of URL, to 
1687      * use the URI and get all details. Ex. www.<apiURL>.com/token/<tokenID>
1688      * @param _tokenURI  The token uri
1689      */
1690     function setTokenURIBase (string _tokenURI) public anyOperator {
1691         _setTokenURIBase(_tokenURI);
1692     }
1693 
1694     /**
1695      * @dev Allowed to be called by onlyGameManager to update a certain collectible playerOverrideID
1696      * @notice Sets the player override identifier.
1697      * @param _tokenId      The token identifier
1698      * @param _newOverrideId     The new player override identifier
1699      */
1700     function setPlayerOverrideId(uint256 _tokenId, uint256 _newOverrideId) public onlyManager whenNotPaused {
1701         require (exists(_tokenId));
1702 
1703         _updatePlayerOverrideId(_tokenId, _newOverrideId);
1704     }
1705 
1706     /**
1707      * @notice Updates the Generation Season Controller.
1708      * @dev Allowed to be called by onlyGameManager to update the generation season.
1709      * this helps to control the generation of collectible.
1710      * @param _season    Season UINT representation
1711      * @param _value    0-Not allowed, 1-open, >=2 Locked Forever
1712      */
1713     function updateGenerationStopTime(uint256 _season, uint8 _value ) public  onlyManager whenNotPaused {
1714         require (generationSeasonController[_season] == 1 && _value != 0);
1715         _updateGenerationSeasonFlag(_season, _value);
1716     }
1717 
1718     /**
1719      * @dev set Generation Season Controller, can only be called by Managers._season can be [0,1,2,3..] and 
1720      * _value can be [0,1,N].
1721      * @notice _value of 1: means generation of collectible is allowed. anything, apart from 1, wont allow generating assets for that season.
1722      * @param _season    Season UINT representation
1723      */
1724     function setGenerationSeasonController(uint256 _season) public onlyManager whenNotPaused {
1725         require (generationSeasonController[_season] == 0);
1726         _updateGenerationSeasonFlag(_season, 1);
1727     }
1728 
1729     /**
1730      * @dev Adding value to DICT helps in showing the season value in getCollectibleDetails
1731      * @notice Updates the Generation Season Dict.
1732      * @param _season    Season UINT representation
1733      * @param _value    0-Not allowed,1-allowed
1734      */
1735     function updateGenerationDict(uint256 _season, uint64 _value) public onlyManager whenNotPaused {
1736         require (generationSeasonDict[_season] <= 1);
1737         generationSeasonDict[_season] = _value;
1738     }
1739 
1740     /**
1741      * @dev Helper function to avoid calling getCollectibleDetails
1742      * @notice Gets the MLB player Id from the player attributes
1743      * @param _tokenId  The token identifier
1744      * @return playerId  MLB Player Identifier
1745      */
1746     function getPlayerId(uint256 _tokenId) external view returns (uint256 playerId) {
1747         NFT memory obj  = _getAttributesOfToken(_tokenId);
1748         playerId = ((obj.attributes.div(100000000000000000)) % 1000);
1749     }
1750     
1751     /**
1752      * @dev Helper function to avoid calling getCollectibleDetails
1753      * @notice Gets the attachments for an asset
1754      * @param _tokenId  The token identifier
1755      * @return attachments
1756      */
1757     function getAssetAttachment(uint256 _tokenId) external view returns (uint256[]) {
1758         uint256[] _attachments = nftCollectibleAttachments[_tokenId];
1759         uint256[] attachments;
1760         for(uint i=0;i<_attachments.length;i++){
1761             attachments.push(_attachments[i]);
1762         }
1763         
1764         return attachments;
1765     }
1766 
1767     /**
1768      * @dev Can only be trigerred by Managers. Updates the earnedBy property of the NFT
1769      * @notice Helps in updating the earned _by property of an asset/token.
1770      * @param  _tokenId        asser/token identifier
1771      * @param  _earnedBy       New asset/token DNA
1772      */
1773     function updateEarnedBy(uint256 _tokenId, uint256 _earnedBy) public onlyManager whenNotPaused {
1774         require (exists(_tokenId));
1775 
1776         _updateEarnedBy(_tokenId, _earnedBy);
1777     }
1778 
1779     /**
1780      * @dev A batch function to facilitate batching of asset creation. canCreate modifier
1781      * helps in controlling who can call the function
1782      * @notice Batch Function to Create Assets
1783      * @param      _teamId            The team identifier
1784      * @param      _attributes        The attributes
1785      * @param      _playerOverrideId  The player override identifier
1786      * @param      _mlbPlayerId       The mlb player identifier
1787      * @param      _to                To Address
1788      */
1789     function batchCreateAsset(
1790         uint8[] _teamId,
1791         uint256[] _attributes,
1792         uint256[] _playerOverrideId,
1793         uint256[] _mlbPlayerId,
1794         address[] _to)
1795         external
1796         canCreate
1797         whenNotPaused {
1798             require (isBatchSupported);
1799 
1800             require (_teamId.length > 0 && _attributes.length > 0 && 
1801                 _playerOverrideId.length > 0 && _mlbPlayerId.length > 0 && 
1802                 _to.length > 0);
1803 
1804             uint256 assetDetails;
1805             uint256[5] memory _nftData;
1806             
1807             for(uint ii = 0; ii < _attributes.length; ii++){
1808                 require (_to[ii] != address(0) && _teamId[ii] != 0 && _attributes.length != 0 && 
1809                     _mlbPlayerId[ii] != 0);
1810                 
1811                 assetDetails = uint256(uint64(now));
1812                 assetDetails |= uint256(getSequenceId(_teamId[ii]))<<64;
1813                 assetDetails |= uint256(_teamId[ii])<<96;
1814                 assetDetails |= uint256((_attributes[ii]/1000000000000000000000000000000000000000)-800)<<104;
1815         
1816                 _nftData = [assetDetails, _attributes[ii], 0, _playerOverrideId[ii], _mlbPlayerId[ii]];
1817                 
1818                 _createNFTCollectible(_teamId[ii], _attributes[ii], _to[ii], 0, _nftData);
1819             }
1820         }
1821 
1822     /**
1823      * @dev A batch function to facilitate batching of asset creation for ETH Cards. canCreate modifier
1824      * helps in controlling who can call the function
1825      * @notice        Batch Function to Create Assets
1826      * @param      _teamId            The team identifier
1827      * @param      _attributes        The attributes
1828      * @param      _playerOverrideId  The player override identifier
1829      * @param      _mlbPlayerId       The mlb player identifier
1830      * @param      _to                { parameter_description }
1831      */
1832     function batchCreateETHCardAsset(
1833         uint8[] _teamId,
1834         uint256[] _attributes,
1835         uint256[] _playerOverrideId,
1836         uint256[] _mlbPlayerId,
1837         address[] _to)
1838         external
1839         canCreate
1840         whenNotPaused {
1841             require (isBatchSupported);
1842 
1843             require (_teamId.length > 0 && _attributes.length > 0
1844                         && _playerOverrideId.length > 0 &&
1845                         _mlbPlayerId.length > 0 && _to.length > 0);
1846 
1847             uint256 assetDetails;
1848             uint256[5] memory _nftData;
1849 
1850             for(uint ii = 0; ii < _attributes.length; ii++){
1851 
1852                 require (_to[ii] != address(0) && _teamId[ii] != 0 && _attributes.length != 0 && 
1853                     _mlbPlayerId[ii] != 0);
1854         
1855                 assetDetails = uint256(uint64(now));
1856                 assetDetails |= uint256(getSequenceId(_teamId[ii]))<<64;
1857                 assetDetails |= uint256(_teamId[ii])<<96;
1858                 assetDetails |= uint256((_attributes[ii]/1000000000000000000000000000000000000000)-800)<<104;
1859         
1860                 _nftData = [assetDetails, _attributes[ii], 0, _playerOverrideId[ii], _mlbPlayerId[ii]];
1861                 
1862                 _createNFTCollectible(_teamId[ii], _attributes[ii], _to[ii], 2, _nftData);
1863             }
1864         }
1865 
1866     /**
1867      * @dev        Overriden TransferFrom, with the modifier canTransfer which uses our attachment system
1868      * @notice     Helps in trasnferring assets
1869      * @param      _from     the address sending from
1870      * @param      _to       the address sending to
1871      * @param      _tokenId  The token identifier
1872      */
1873     function transferFrom(
1874         address _from,
1875         address _to,
1876         uint256 _tokenId
1877     )
1878         public
1879         canTransfer(_tokenId)
1880     {
1881         // Asset should not be in play
1882         require (checkIsAttached(_tokenId) == 0);
1883         
1884         require (_from != address(0));
1885 
1886         require (_to != address(0));
1887 
1888         clearApproval(_from, _tokenId);
1889         removeTokenFrom(_from, _tokenId);
1890         addTokenTo(_to, _tokenId);
1891 
1892         emit Transfer(_from, _to, _tokenId);
1893     }
1894 
1895     /**
1896      * @dev     Facilitates batch trasnfer of collectible with multiple TO Address, depending if batch is supported on contract.
1897      * @notice  Batch Trasnfer with multpple TO addresses
1898      * @param      _tokenIds  The token identifiers
1899      * @param      _fromB     the address sending from
1900      * @param      _toB       the address sending to
1901      */
1902     function multiBatchTransferFrom(
1903         uint256[] _tokenIds, 
1904         address[] _fromB, 
1905         address[] _toB) 
1906         public
1907     {
1908         require (isBatchSupported);
1909 
1910         require (_tokenIds.length > 0 && _fromB.length > 0 && _toB.length > 0);
1911 
1912         uint256 _id;
1913         address _to;
1914         address _from;
1915         
1916         for (uint256 i = 0; i < _tokenIds.length; ++i) {
1917 
1918             require (_tokenIds[i] != 0 && _fromB[i] != 0 && _toB[i] != 0);
1919 
1920             _id = _tokenIds[i];
1921             _to = _toB[i];
1922             _from = _fromB[i];
1923 
1924             transferFrom(_from, _to, _id);
1925         }
1926         
1927     }
1928     
1929     /**
1930      * @dev     Facilitates batch trasnfer of collectible, depending if batch is supported on contract
1931      * @notice        Batch TransferFrom with the same to & from address
1932      * @param      _tokenIds  The asset identifiers
1933      * @param      _from      the address sending from
1934      * @param      _to        the address sending to
1935      */
1936     function batchTransferFrom(uint256[] _tokenIds, address _from, address _to) 
1937         public
1938     {
1939         require (isBatchSupported);
1940 
1941         require (_tokenIds.length > 0 && _from != address(0) && _to != address(0));
1942 
1943         uint256 _id;
1944         
1945         for (uint256 i = 0; i < _tokenIds.length; ++i) {
1946             
1947             require (_tokenIds[i] != 0);
1948 
1949             _id = _tokenIds[i];
1950 
1951             transferFrom(_from, _to, _id);
1952         }
1953     }
1954     
1955     /**
1956      * @dev     Facilitates batch trasnfer of collectible, depending if batch is supported on contract.
1957      * Checks for collectible 0,address 0 and then performs the transfer
1958      * @notice        Batch SafeTransferFrom with multiple From and to Addresses
1959      * @param      _tokenIds  The asset identifiers
1960      * @param      _fromB     the address sending from
1961      * @param      _toB       the address sending to
1962      */
1963     function multiBatchSafeTransferFrom(
1964         uint256[] _tokenIds, 
1965         address[] _fromB, 
1966         address[] _toB
1967         )
1968         public
1969     {
1970         require (isBatchSupported);
1971 
1972         require (_tokenIds.length > 0 && _fromB.length > 0 && _toB.length > 0);
1973 
1974         uint256 _id;
1975         address _to;
1976         address _from;
1977         
1978         for (uint256 i = 0; i < _tokenIds.length; ++i) {
1979 
1980             require (_tokenIds[i] != 0 && _fromB[i] != 0 && _toB[i] != 0);
1981 
1982             _id = _tokenIds[i];
1983             _to  = _toB[i];
1984             _from  = _fromB[i];
1985 
1986             safeTransferFrom(_from, _to, _id);
1987         }
1988     }
1989 
1990     /**
1991      * @dev     Facilitates batch trasnfer of collectible, depending if batch is supported on contract.
1992      * Checks for collectible 0,address 0 and then performs the transfer
1993      * @notice        Batch SafeTransferFrom from a single address to another address
1994      * @param      _tokenIds  The asset identifiers
1995      * @param      _from     the address sending from
1996      * @param      _to       the address sending to
1997      */
1998     function batchSafeTransferFrom(
1999         uint256[] _tokenIds, 
2000         address _from, 
2001         address _to
2002         )
2003         public
2004     {   
2005         require (isBatchSupported);
2006 
2007         require (_tokenIds.length > 0 && _from != address(0) && _to != address(0));
2008 
2009         uint256 _id;
2010         for (uint256 i = 0; i < _tokenIds.length; ++i) {
2011             require (_tokenIds[i] != 0);
2012             _id = _tokenIds[i];
2013             safeTransferFrom(_from, _to, _id);
2014         }
2015     }
2016 
2017     /**
2018      * @notice     Batch Function to approve the spender
2019      * @dev        Helps to approve a batch of collectibles 
2020      * @param      _tokenIds  The asset identifiers
2021      * @param      _spender   The spender
2022      */
2023     function batchApprove(
2024         uint256[] _tokenIds, 
2025         address _spender
2026         )
2027         public
2028     {   
2029         require (isBatchSupported);
2030 
2031         require (_tokenIds.length > 0 && _spender != address(0));
2032         
2033         uint256 _id;
2034         for (uint256 i = 0; i < _tokenIds.length; ++i) {
2035 
2036             require (_tokenIds[i] != 0);
2037             
2038             _id = _tokenIds[i];
2039             approve(_spender, _id);
2040         }
2041         
2042     }
2043 
2044     /**
2045      * @dev        Batch Function to mark spender for approved for all. Does a check
2046      * for address(0) and throws if true
2047      * @notice     Facilitates batch approveAll
2048      * @param      _spenders  The spenders
2049      * @param      _approved  The approved
2050      */
2051     function batchSetApprovalForAll(
2052         address[] _spenders,
2053         bool _approved
2054         )
2055         public
2056     {   
2057         require (isBatchSupported);
2058 
2059         require (_spenders.length > 0);
2060 
2061         address _spender;
2062         for (uint256 i = 0; i < _spenders.length; ++i) {        
2063 
2064             require (address(_spenders[i]) != address(0));
2065                 
2066             _spender = _spenders[i];
2067             setApprovalForAll(_spender, _approved);
2068         }
2069     }  
2070     
2071     /**
2072      * @dev        Function to request Detachment from our Contract
2073      * @notice     a wallet can request to detach it collectible, so, that it can be used in other third-party contracts.
2074      * @param      _tokenId  The token identifier
2075      */
2076     function requestDetachment(
2077         uint256 _tokenId
2078     )
2079         public
2080     {
2081         //Request can only be made by owner or approved address
2082         require (isApprovedOrOwner(msg.sender, _tokenId));
2083 
2084         uint256 isAttached = checkIsAttached(_tokenId);
2085 
2086         //If collectible is on a gamecard prevent detachment
2087         require(getGameCardId(_tokenId) == 0);
2088 
2089         require (isAttached >= 1);
2090 
2091         if(attachedSystemActive == true) {
2092             //Checks to see if request was made and if time elapsed
2093             if(isAttached > 1 && block.timestamp - isAttached > detachmentTime) {
2094                 isAttached = 0;
2095             } else if(isAttached > 1) {
2096                 //Forces Tx Fail if time is already set for attachment and not less than detachmentTime
2097                 require (isAttached == 1);
2098             } else {
2099                 //Is attached, set detachment time and make request to detach
2100                 // emit AssetUpdated(_tokenId);
2101                 isAttached = block.timestamp;
2102             }
2103         } else {
2104             isAttached = 0;
2105         }
2106 
2107         updateIsAttached(_tokenId, isAttached);
2108     }
2109 
2110     /**
2111      * @dev        Function to attach the asset, thus, restricting transfer
2112      * @notice     Attaches the collectible to our contract
2113      * @param      _tokenId  The token identifier
2114      */
2115     function attachAsset(
2116         uint256 _tokenId
2117     )
2118         public
2119         canTransfer(_tokenId)
2120     {
2121         uint256 isAttached = checkIsAttached(_tokenId);
2122 
2123         require (isAttached == 0);
2124         isAttached = 1;
2125 
2126         updateIsAttached(_tokenId, isAttached);
2127 
2128         emit AssetUpdated(_tokenId);
2129     }
2130 
2131     /**
2132      * @dev        Batch attach function
2133      * @param      _tokenIds  The identifiers
2134      */
2135     function batchAttachAssets(uint256[] _tokenIds) public {
2136         require (isBatchSupported);
2137 
2138         for(uint i = 0; i < _tokenIds.length; i++) {
2139             attachAsset(_tokenIds[i]);
2140         }
2141     }
2142 
2143     /**
2144      * @dev        Batch detach function
2145      * @param      _tokenIds  The identifiers
2146      */
2147     function batchDetachAssets(uint256[] _tokenIds) public {
2148         require (isBatchSupported);
2149 
2150         for(uint i = 0; i < _tokenIds.length; i++) {
2151             requestDetachment(_tokenIds[i]);
2152         }
2153     }
2154 
2155     /**
2156      * @dev        Function to facilitate detachment when contract is paused
2157      * @param      _tokenId  The identifiers
2158      */
2159     function requestDetachmentOnPause (uint256 _tokenId) public whenPaused {
2160         //Request can only be made by owner or approved address
2161         require (isApprovedOrOwner(msg.sender, _tokenId));
2162 
2163         updateIsAttached(_tokenId, 0);
2164     }
2165 
2166     /**
2167      * @dev        Toggle the Attachment Switch
2168      * @param      _state  The state
2169      */
2170     function toggleAttachedEnforcement (bool _state) public onlyManager {
2171         attachedSystemActive = _state;
2172     }
2173 
2174     /**
2175      * @dev        Set Attachment Time Period (this restricts user from continuously trigger detachment)
2176      * @param      _time  The time
2177      */
2178     function setDetachmentTime (uint256 _time) public onlyManager {
2179         //Detactment Time can not be set greater than 2 weeks.
2180         require (_time <= 1209600);
2181         detachmentTime = uint32(_time);
2182     }
2183 
2184     /**
2185      * @dev        Detach Asset From System
2186      * @param      _tokenId  The token iddentifier
2187      */
2188     function setNFTDetached(uint256 _tokenId) public anyOperator {
2189         require (checkIsAttached(_tokenId) > 0);
2190 
2191         updateIsAttached(_tokenId, 0);
2192     }
2193 
2194     /**
2195      * @dev        Batch function to detach multiple assets
2196      * @param      _tokenIds  The token identifiers
2197      */
2198     function setBatchDetachCollectibles(uint256[] _tokenIds) public anyOperator {
2199         uint256 _id;
2200         for(uint i = 0; i < _tokenIds.length; i++) {
2201             _id = _tokenIds[i];
2202             setNFTDetached(_id);
2203         }
2204     }
2205 
2206     /**
2207      * @dev        Function to update attach value
2208      * @param      _tokenId     The asset id
2209      * @param      _isAttached  Indicates if attached
2210      */
2211     function updateIsAttached(uint256 _tokenId, uint256 _isAttached) internal {
2212         NFT memory obj  = _getAttributesOfToken(_tokenId);
2213         
2214         obj.isAttached = _isAttached;
2215     
2216         allNFTs[_tokenId] = obj;
2217         emit AssetUpdated(_tokenId);
2218     }
2219 
2220     /**
2221     * @dev   Facilitates Creating Sale using the Sale Contract. Forces owner check & collectibleId check
2222     * @notice Helps a wallet to create a sale using our Sale Contract
2223     * @param      _tokenId        The token identifier
2224     * @param      _startingPrice  The starting price
2225     * @param      _endingPrice    The ending price
2226     * @param      _duration       The duration
2227     */
2228     function initiateCreateSale(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external {
2229         require (_tokenId != 0);
2230         
2231         // If MLBNFT is already on any sale, this will throw
2232         // because it will be owned by the sale contract.
2233         address owner = ownerOf(_tokenId);
2234         require (owner == msg.sender);
2235 
2236         // Sale contract checks input sizes
2237         require (_startingPrice == _startingPrice);
2238         require (_endingPrice == _endingPrice);
2239         require (_duration == _duration);
2240 
2241         require (checkIsAttached(_tokenId) == 0);
2242         
2243         // One time approval for the tokenID
2244         _approveForSale(msg.sender, address(saleManagerAddress), _tokenId);
2245 
2246         saleManagerAddress.createSale(_tokenId, _startingPrice, _endingPrice, _duration, msg.sender);
2247     }
2248 
2249     /**
2250      * @dev        Facilitates batch auction of collectibles, and enforeces strict checking on the collectibleId,starting/ending price, duration.
2251      * @notice     Batch function to put 10 or less collectibles on sale
2252      * @param      _tokenIds        The token identifier
2253      * @param      _startingPrices  The starting price
2254      * @param      _endingPrices    The ending price
2255      * @param      _durations       The duration
2256      */
2257     function batchCreateAssetSale(uint256[] _tokenIds, uint256[] _startingPrices, uint256[] _endingPrices, uint256[] _durations) external whenNotPaused {
2258 
2259         require (_tokenIds.length > 0 && _startingPrices.length > 0 && _endingPrices.length > 0 && _durations.length > 0);
2260         
2261         // Sale contract checks input sizes
2262         for(uint ii = 0; ii < _tokenIds.length; ii++){
2263 
2264             // Do not process for tokenId 0
2265             require (_tokenIds[ii] != 0);
2266             
2267             require (_startingPrices[ii] == _startingPrices[ii]);
2268             require (_endingPrices[ii] == _endingPrices[ii]);
2269             require (_durations[ii] == _durations[ii]);
2270 
2271             // If MLBNFT is already on any sale, this will throw
2272             // because it will be owned by the sale contract.
2273             address _owner = ownerOf(_tokenIds[ii]);
2274             address _msgSender = msg.sender;
2275             require (_owner == _msgSender);
2276 
2277             // Check whether the collectible is inPlay. If inPlay cant put it on Sale
2278             require (checkIsAttached(_tokenIds[ii]) == 0);
2279             
2280             // approve token to for Sale creation
2281             _approveForSale(msg.sender, address(saleManagerAddress), _tokenIds[ii]);
2282             
2283             saleManagerAddress.createSale(_tokenIds[ii], _startingPrices[ii], _endingPrices[ii], _durations[ii], msg.sender);
2284         }
2285     }
2286 }