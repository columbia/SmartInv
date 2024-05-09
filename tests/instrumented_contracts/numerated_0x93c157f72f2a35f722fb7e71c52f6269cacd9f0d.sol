1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     function Ownable() public {
19         owner = msg.sender;
20     }
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) public onlyOwner {
35         require(newOwner != address(0));
36         OwnershipTransferred(owner, newOwner);
37         owner = newOwner;
38     }
39 }
40 
41 
42 library AddressUtils {
43 
44     /**
45      * Returns whether the target address is a contract
46      * @dev This function will return false if invoked during the constructor of a contract,
47      *  as the code is not actually created until after the constructor finishes.
48      * @param addr address to check
49      * @return whether the target address is a contract
50      */
51     function isContract(address addr) internal view returns (bool) {
52         uint256 size;
53         // XXX Currently there is no better way to check if there is a contract in an address
54         // than to check the size of the code at that address.
55         // See https://ethereum.stackexchange.com/a/14016/36603
56         // for more details about how this works.
57         // TODO Check this again before the Serenity release, because all addresses will be
58         // contracts then.
59         // solium-disable-next-line security/no-inline-assembly
60         assembly { size := extcodesize(addr) }
61         return size > 0;
62     }
63 
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72     /**
73     * @dev Multiplies two numbers, throws on overflow.
74     */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76         if (a == 0) {
77             return 0;
78         }
79         c = a * b;
80         assert(c / a == b);
81         return c;
82     }
83 
84     /**
85     * @dev Integer division of two numbers, truncating the quotient.
86     */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // assert(b > 0); // Solidity automatically throws when dividing by 0
89         // uint256 c = a / b;
90         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91         return a / b;
92     }
93 
94     /**
95     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96     */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         assert(b <= a);
99         return a - b;
100     }
101 
102     /**
103     * @dev Adds two numbers, throws on overflow.
104     */
105     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106         c = a + b;
107         assert(c >= a);
108         return c;
109     }
110 }
111 
112 
113 contract ERC721Receiver {
114     /**
115      * @dev Magic value to be returned upon successful reception of an NFT
116      *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
117      *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
118      */
119     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
120 
121     /**
122      * @notice Handle the receipt of an NFT
123      * @dev The ERC721 smart contract calls this function on the recipient
124      *  after a `safetransfer`. This function MAY throw to revert and reject the
125      *  transfer. This function MUST use 50,000 gas or less. Return of other
126      *  than the magic value MUST result in the transaction being reverted.
127      *  Note: the contract address is always the message sender.
128      * @param _from The sending address
129      * @param _tokenId The NFT identifier which is being transfered
130      * @param _data Additional data with no specified format
131      * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
132      */
133     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
134 }
135 
136 
137 /**
138  * @title ERC721 Non-Fungible Token Standard basic interface
139  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
140  */
141 contract ERC721Basic {
142     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
143     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
144     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
145 
146     function balanceOf(address _owner) public view returns (uint256 _balance);
147     function ownerOf(uint256 _tokenId) public view returns (address _owner);
148     function exists(uint256 _tokenId) public view returns (bool _exists);
149 
150     function approve(address _to, uint256 _tokenId) public;
151     function getApproved(uint256 _tokenId) public view returns (address _operator);
152 
153     function setApprovalForAll(address _operator, bool _approved) public;
154     function isApprovedForAll(address _owner, address _operator)
155     public view returns (bool);
156 
157     function transferFrom(address _from, address _to, uint256 _tokenId) public;
158     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
159 
160     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
161 }
162 
163 
164 /**
165  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
166  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
167  */
168 contract ERC721Enumerable is ERC721Basic {
169     function totalSupply() public view returns (uint256);
170     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
171 
172     function tokenByIndex(uint256 _index) public view returns (uint256);
173 }
174 
175 
176 /**
177  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
178  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
179  */
180 contract ERC721Metadata is ERC721Basic {
181     function name() public view returns (string _name);
182     function symbol() public view returns (string _symbol);
183     function tokenURI(uint256 _tokenId) public view returns (string);
184 }
185 
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
189  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
190  */
191 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {}
192 
193 
194 /**
195  * @title ERC721 Non-Fungible Token Standard basic implementation
196  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
197  */
198 contract ERC721BasicToken is ERC721Basic {
199     using SafeMath for uint256;
200     using AddressUtils for address;
201 
202     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
203     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
204     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
205 
206     // Mapping from token ID to owner
207     mapping (uint256 => address) internal tokenOwner;
208 
209     // Mapping from token ID to approved address
210     mapping (uint256 => address) internal tokenApprovals;
211 
212     // Mapping from owner to number of owned token
213     mapping (address => uint256) internal ownedTokensCount;
214 
215     // Mapping from owner to operator approvals
216     mapping (address => mapping (address => bool)) internal operatorApprovals;
217 
218     /**
219      * @dev Guarantees msg.sender is owner of the given token
220      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
221      */
222     modifier onlyOwnerOf(uint256 _tokenId) {
223         require(ownerOf(_tokenId) == msg.sender);
224         _;
225     }
226 
227     /**
228      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
229      * @param _tokenId uint256 ID of the token to validate
230      */
231     modifier canTransfer(uint256 _tokenId) {
232         require(isApprovedOrOwner(msg.sender, _tokenId));
233         _;
234     }
235 
236     /**
237      * @dev Gets the balance of the specified address
238      * @param _owner address to query the balance of
239      * @return uint256 representing the amount owned by the passed address
240      */
241     function balanceOf(address _owner) public view returns (uint256) {
242         require(_owner != address(0));
243         return ownedTokensCount[_owner];
244     }
245 
246     /**
247      * @dev Gets the owner of the specified token ID
248      * @param _tokenId uint256 ID of the token to query the owner of
249      * @return owner address currently marked as the owner of the given token ID
250      */
251     function ownerOf(uint256 _tokenId) public view returns (address) {
252         address owner = tokenOwner[_tokenId];
253         require(owner != address(0));
254         return owner;
255     }
256 
257     /**
258      * @dev Returns whether the specified token exists
259      * @param _tokenId uint256 ID of the token to query the existence of
260      * @return whether the token exists
261      */
262     function exists(uint256 _tokenId) public view returns (bool) {
263         address owner = tokenOwner[_tokenId];
264         return owner != address(0);
265     }
266 
267     /**
268      * @dev Approves another address to transfer the given token ID
269      * @dev The zero address indicates there is no approved address.
270      * @dev There can only be one approved address per token at a given time.
271      * @dev Can only be called by the token owner or an approved operator.
272      * @param _to address to be approved for the given token ID
273      * @param _tokenId uint256 ID of the token to be approved
274      */
275     function approve(address _to, uint256 _tokenId) public {
276         address owner = ownerOf(_tokenId);
277         require(_to != owner);
278         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
279 
280         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
281             tokenApprovals[_tokenId] = _to;
282             Approval(owner, _to, _tokenId);
283         }
284     }
285 
286     /**
287      * @dev Gets the approved address for a token ID, or zero if no address set
288      * @param _tokenId uint256 ID of the token to query the approval of
289      * @return address currently approved for the given token ID
290      */
291     function getApproved(uint256 _tokenId) public view returns (address) {
292         return tokenApprovals[_tokenId];
293     }
294 
295     /**
296      * @dev Sets or unsets the approval of a given operator
297      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
298      * @param _to operator address to set the approval
299      * @param _approved representing the status of the approval to be set
300      */
301     function setApprovalForAll(address _to, bool _approved) public {
302         require(_to != msg.sender);
303         operatorApprovals[msg.sender][_to] = _approved;
304         ApprovalForAll(msg.sender, _to, _approved);
305     }
306 
307     /**
308      * @dev Tells whether an operator is approved by a given owner
309      * @param _owner owner address which you want to query the approval of
310      * @param _operator operator address which you want to query the approval of
311      * @return bool whether the given operator is approved by the given owner
312      */
313     function isApprovedForAll(address _owner, address _operator) public view returns (bool)
314     {
315         return operatorApprovals[_owner][_operator];
316     }
317 
318     /**
319      * @dev Transfers the ownership of a given token ID to another address
320      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
321      * @dev Requires the msg sender to be the owner, approved, or operator
322      * @param _from current owner of the token
323      * @param _to address to receive the ownership of the given token ID
324      * @param _tokenId uint256 ID of the token to be transferred
325     */
326     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId)
327     {
328         require(_from != address(0));
329         require(_to != address(0));
330 
331         clearApproval(_from, _tokenId);
332         removeTokenFrom(_from, _tokenId);
333         addTokenTo(_to, _tokenId);
334 
335         Transfer(_from, _to, _tokenId);
336     }
337 
338     /**
339      * @dev Safely transfers the ownership of a given token ID to another address
340      * @dev If the target address is a contract, it must implement `onERC721Received`,
341      *  which is called upon a safe transfer, and return the magic value
342      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
343      *  the transfer is reverted.
344      * @dev Requires the msg sender to be the owner, approved, or operator
345      * @param _from current owner of the token
346      * @param _to address to receive the ownership of the given token ID
347      * @param _tokenId uint256 ID of the token to be transferred
348     */
349     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId)
350     {
351         // solium-disable-next-line arg-overflow
352         safeTransferFrom(_from, _to, _tokenId, "");
353     }
354 
355     /**
356      * @dev Safely transfers the ownership of a given token ID to another address
357      * @dev If the target address is a contract, it must implement `onERC721Received`,
358      *  which is called upon a safe transfer, and return the magic value
359      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
360      *  the transfer is reverted.
361      * @dev Requires the msg sender to be the owner, approved, or operator
362      * @param _from current owner of the token
363      * @param _to address to receive the ownership of the given token ID
364      * @param _tokenId uint256 ID of the token to be transferred
365      * @param _data bytes data to send along with a safe transfer check
366      */
367     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId)
368     {
369         transferFrom(_from, _to, _tokenId);
370         // solium-disable-next-line arg-overflow
371         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
372     }
373 
374     /**
375      * @dev Returns whether the given spender can transfer a given token ID
376      * @param _spender address of the spender to query
377      * @param _tokenId uint256 ID of the token to be transferred
378      * @return bool whether the msg.sender is approved for the given token ID,
379      *  is an operator of the owner, or is the owner of the token
380      */
381     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool)
382     {
383         address owner = ownerOf(_tokenId);
384         // Disable solium check because of
385         // https://github.com/duaraghav8/Solium/issues/175
386         // solium-disable-next-line operator-whitespace
387         return (
388         _spender == owner ||
389         getApproved(_tokenId) == _spender ||
390         isApprovedForAll(owner, _spender)
391         );
392     }
393 
394     /**
395      * @dev Internal function to mint a new token
396      * @dev Reverts if the given token ID already exists
397      * @param _to The address that will own the minted token
398      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
399      */
400     function _mint(address _to, uint256 _tokenId) internal {
401         require(_to != address(0));
402         addTokenTo(_to, _tokenId);
403         Transfer(address(0), _to, _tokenId);
404     }
405 
406     /**
407      * @dev Internal function to burn a specific token
408      * @dev Reverts if the token does not exist
409      * @param _tokenId uint256 ID of the token being burned by the msg.sender
410      */
411     function _burn(address _owner, uint256 _tokenId) internal {
412         clearApproval(_owner, _tokenId);
413         removeTokenFrom(_owner, _tokenId);
414         Transfer(_owner, address(0), _tokenId);
415     }
416 
417     /**
418      * @dev Internal function to clear current approval of a given token ID
419      * @dev Reverts if the given address is not indeed the owner of the token
420      * @param _owner owner of the token
421      * @param _tokenId uint256 ID of the token to be transferred
422      */
423     function clearApproval(address _owner, uint256 _tokenId) internal {
424         require(ownerOf(_tokenId) == _owner);
425         if (tokenApprovals[_tokenId] != address(0)) {
426             tokenApprovals[_tokenId] = address(0);
427             Approval(_owner, address(0), _tokenId);
428         }
429     }
430 
431     /**
432      * @dev Internal function to add a token ID to the list of a given address
433      * @param _to address representing the new owner of the given token ID
434      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
435      */
436     function addTokenTo(address _to, uint256 _tokenId) internal {
437         require(tokenOwner[_tokenId] == address(0));
438         tokenOwner[_tokenId] = _to;
439         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
440     }
441 
442     /**
443      * @dev Internal function to remove a token ID from the list of a given address
444      * @param _from address representing the previous owner of the given token ID
445      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
446      */
447     function removeTokenFrom(address _from, uint256 _tokenId) internal {
448         require(ownerOf(_tokenId) == _from);
449         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
450         tokenOwner[_tokenId] = address(0);
451     }
452 
453     /**
454      * @dev Internal function to invoke `onERC721Received` on a target address
455      * @dev The call is not executed if the target address is not a contract
456      * @param _from address representing the previous owner of the given token ID
457      * @param _to target address that will receive the tokens
458      * @param _tokenId uint256 ID of the token to be transferred
459      * @param _data bytes optional data to send along with the call
460      * @return whether the call correctly returned the expected magic value
461      */
462     function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool)
463     {
464         if (!_to.isContract()) {
465             return true;
466         }
467         bytes4 retval = ERC721Receiver(_to).onERC721Received(
468         _from, _tokenId, _data);
469         return (retval == ERC721_RECEIVED);
470     }
471 }
472 
473 
474 
475 /**
476  * @title Full ERC721 Token
477  * This implementation includes all the required and some optional functionality of the ERC721 standard
478  * Moreover, it includes approve all functionality using operator terminology
479  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
480  */
481 contract ERC721Token is ERC721, ERC721BasicToken {
482     // Token name
483     string internal name_;
484 
485     // Token symbol
486     string internal symbol_;
487 
488     // Mapping from owner to list of owned token IDs
489     mapping(address => uint256[]) internal ownedTokens;
490 
491     // Mapping from token ID to index of the owner tokens list
492     mapping(uint256 => uint256) internal ownedTokensIndex;
493 
494     // Array with all token ids, used for enumeration
495     uint256[] internal allTokens;
496 
497     // Mapping from token id to position in the allTokens array
498     mapping(uint256 => uint256) internal allTokensIndex;
499 
500     // Optional mapping for token URIs
501     mapping(uint256 => string) internal tokenURIs;
502 
503     /**
504      * @dev Constructor function
505      */
506     function ERC721Token(string _name, string _symbol) public {
507         name_ = _name;
508         symbol_ = _symbol;
509     }
510 
511     /**
512      * @dev Gets the token name
513      * @return string representing the token name
514      */
515     function name() public view returns (string) {
516         return name_;
517     }
518 
519     /**
520      * @dev Gets the token symbol
521      * @return string representing the token symbol
522      */
523     function symbol() public view returns (string) {
524         return symbol_;
525     }
526 
527     /**
528      * @dev Returns an URI for a given token ID
529      * @dev Throws if the token ID does not exist. May return an empty string.
530      * @param _tokenId uint256 ID of the token to query
531      */
532     function tokenURI(uint256 _tokenId) public view returns (string) {
533         require(exists(_tokenId));
534         return tokenURIs[_tokenId];
535     }
536 
537     /**
538      * @dev Gets the token ID at a given index of the tokens list of the requested owner
539      * @param _owner address owning the tokens list to be accessed
540      * @param _index uint256 representing the index to be accessed of the requested tokens list
541      * @return uint256 token ID at the given index of the tokens list owned by the requested address
542      */
543     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256)
544     {
545         require(_index < balanceOf(_owner));
546         return ownedTokens[_owner][_index];
547     }
548 
549     /**
550      * @dev Gets list of tokens of the requested owner
551      * @param _owner address owning the tokens list to be accessed
552      * @return uint256[] token IDs
553      */
554     function tokensOfOwner(address _owner) public view returns (uint256[])
555     {
556         return ownedTokens[_owner];
557     }
558 
559     /**
560      * @dev Gets the total amount of tokens stored by the contract
561      * @return uint256 representing the total amount of tokens
562      */
563     function totalSupply() public view returns (uint256) {
564         return allTokens.length;
565     }
566 
567     /**
568      * @dev Gets the token ID at a given index of all the tokens in this contract
569      * @dev Reverts if the index is greater or equal to the total number of tokens
570      * @param _index uint256 representing the index to be accessed of the tokens list
571      * @return uint256 token ID at the given index of the tokens list
572      */
573     function tokenByIndex(uint256 _index) public view returns (uint256) {
574         require(_index < totalSupply());
575         return allTokens[_index];
576     }
577 
578     /**
579      * @dev Internal function to set the token URI for a given token
580      * @dev Reverts if the token ID does not exist
581      * @param _tokenId uint256 ID of the token to set its URI
582      * @param _uri string URI to assign
583      */
584     function _setTokenURI(uint256 _tokenId, string _uri) internal {
585         require(exists(_tokenId));
586         tokenURIs[_tokenId] = _uri;
587     }
588 
589     /**
590      * @dev Internal function to add a token ID to the list of a given address
591      * @param _to address representing the new owner of the given token ID
592      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
593      */
594     function addTokenTo(address _to, uint256 _tokenId) internal {
595         super.addTokenTo(_to, _tokenId);
596         uint256 length = ownedTokens[_to].length;
597         ownedTokens[_to].push(_tokenId);
598         ownedTokensIndex[_tokenId] = length;
599     }
600 
601     /**
602      * @dev Internal function to remove a token ID from the list of a given address
603      * @param _from address representing the previous owner of the given token ID
604      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
605      */
606     function removeTokenFrom(address _from, uint256 _tokenId) internal {
607         super.removeTokenFrom(_from, _tokenId);
608 
609         uint256 tokenIndex = ownedTokensIndex[_tokenId];
610         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
611         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
612 
613         ownedTokens[_from][tokenIndex] = lastToken;
614         ownedTokens[_from][lastTokenIndex] = 0;
615         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
616         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
617         // the lastToken to the first position, and then dropping the element placed in the last position of the list
618 
619         ownedTokens[_from].length--;
620         ownedTokensIndex[_tokenId] = 0;
621         ownedTokensIndex[lastToken] = tokenIndex;
622     }
623 
624     /**
625      * @dev Internal function to mint a new token
626      * @dev Reverts if the given token ID already exists
627      * @param _to address the beneficiary that will own the minted token
628      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
629      */
630     function _mint(address _to, uint256 _tokenId) internal {
631         super._mint(_to, _tokenId);
632 
633         allTokensIndex[_tokenId] = allTokens.length;
634         allTokens.push(_tokenId);
635     }
636 
637 
638     /**
639      * @dev Internal function to burn a specific token
640      * @dev Reverts if the token does not exist
641      * @param _owner owner of the token to burn
642      * @param _tokenId uint256 ID of the token being burned by the msg.sender
643      */
644     function _burn(address _owner, uint256 _tokenId) internal {
645         super._burn(_owner, _tokenId);
646 
647         // Clear metadata (if any)
648         if (bytes(tokenURIs[_tokenId]).length != 0) {
649             delete tokenURIs[_tokenId];
650         }
651 
652         // Reorg all tokens array
653         uint256 tokenIndex = allTokensIndex[_tokenId];
654         uint256 lastTokenIndex = allTokens.length.sub(1);
655         uint256 lastToken = allTokens[lastTokenIndex];
656 
657         allTokens[tokenIndex] = lastToken;
658         allTokens[lastTokenIndex] = 0;
659 
660         allTokens.length--;
661         allTokensIndex[_tokenId] = 0;
662         allTokensIndex[lastToken] = tokenIndex;
663     }
664 }
665 
666 
667 /**
668  * @title Burnable Token
669  * @dev Token that can be irreversibly burned (destroyed).
670  */
671 contract BurnableToken is ERC721BasicToken {
672     function burn(uint256 _tokenId) public {
673         _burn(msg.sender, _tokenId);
674     }
675 }
676 
677 
678 contract MintableToken is ERC721Token, Ownable {
679     event MintFinished();
680 
681     bool public mintingFinished = false;
682 
683     modifier canMint() {
684         require(!mintingFinished);
685         _;
686     }
687 
688     function mint(address _to, uint256 _tokenId) public onlyOwner canMint {
689         _mint(_to, _tokenId);
690     }
691 
692     function mintWithURI(address _to, uint256 _tokenId, string _uri) public onlyOwner canMint {
693         _mint(_to, _tokenId);
694         super._setTokenURI(_tokenId, _uri);
695     }
696 
697     /**
698      * @dev Function to stop minting new tokens.
699      * @return True if the operation was successful.
700      */
701     function finishMinting() onlyOwner canMint public returns (bool) {
702         mintingFinished = true;
703         MintFinished();
704         return true;
705     }
706 }
707 
708 /**
709  * @title Capped token
710  * @dev Mintable token with a token cap.
711  */
712 contract CappedToken is MintableToken {
713     uint256 public cap;
714 
715     function CappedToken(uint256 _cap) public {
716         require(_cap > 0);
717         cap = _cap;
718     }
719 
720     /**
721      * @dev Function to mint tokens
722      * @param _to The address that will receive the minted tokens.
723      * @param _tokenId id of the new token
724      * @return A boolean that indicates if the operation was successful.
725      */
726     function mint(address _to, uint256 _tokenId) onlyOwner canMint public {
727         require(totalSupply().add(1) <= cap);
728 
729         return super.mint(_to, _tokenId);
730     }
731 
732     function mintWithURI(address _to, uint256 _tokenId, string _uri) onlyOwner canMint public {
733         require(totalSupply().add(1) <= cap);
734 
735         return super.mintWithURI(_to, _tokenId, _uri);
736     }
737 
738 }
739 
740 /**
741  * @title Pausable
742  * @dev Base contract which allows children to implement an emergency stop mechanism.
743  */
744 contract Pausable is Ownable {
745     event Pause();
746     event Unpause();
747 
748     bool public paused = false;
749 
750     /**
751      * @dev Modifier to make a function callable only when the contract is not paused.
752      */
753     modifier whenNotPaused() {
754         require(!paused);
755         _;
756     }
757 
758     /**
759      * @dev Modifier to make a function callable only when the contract is paused.
760      */
761     modifier whenPaused() {
762         require(paused);
763         _;
764     }
765 
766     /**
767      * @dev called by the owner to pause, triggers stopped state
768      */
769     function pause() onlyOwner whenNotPaused public {
770         paused = true;
771         Pause();
772     }
773 
774     /**
775      * @dev called by the owner to unpause, returns to normal state
776      */
777     function unpause() onlyOwner whenPaused public {
778         paused = false;
779         Unpause();
780     }
781 }
782 
783 /**
784  * @title Pausable token
785  * @dev StandardToken modified with pausable transfers.
786  **/
787 contract PausableToken is ERC721BasicToken, Pausable {
788     function approve(address _to, uint256 _tokenId) public whenNotPaused {
789         return super.approve(_to, _tokenId);
790     }
791 
792     function setApprovalForAll(address _to, bool _approved) public whenNotPaused {
793         return super.setApprovalForAll(_to, _approved);
794     }
795 
796     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
797         return super.transferFrom(_from, _to, _tokenId);
798     }
799 
800     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
801         return super.safeTransferFrom(_from, _to, _tokenId);
802     }
803 
804     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public whenNotPaused {
805         return super.safeTransferFrom(_from, _to, _tokenId, _data);
806     }
807 }
808 
809 
810 /**
811  * @title PausableBurnable token
812  * @dev BurnableToken allowing to burn only when is not paused.
813  **/
814 contract BurnablePausableToken is PausableToken, BurnableToken {
815     function burn(uint256 _tokenId) public whenNotPaused {
816         super.burn(_tokenId);
817     }
818 }
819 
820 
821 contract Token is ERC721Token , MintableToken, BurnablePausableToken {
822     function Token()
823         public
824         payable
825         ERC721Token('Crypto Celebs', 'XFC')
826         
827     {
828         
829         
830     }
831 
832     function setTokenURI(uint256 _tokenId, string _uri) external onlyOwnerOf(_tokenId) {
833         super._setTokenURI(_tokenId, _uri);
834     }
835 }