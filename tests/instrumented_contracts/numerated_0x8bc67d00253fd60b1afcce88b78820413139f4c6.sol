1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, reverts on overflow.
7     */
8     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (_a == 0) {
13             return 0;
14         }
15 
16         uint256 c = _a * _b;
17         require(c / _a == _b);
18 
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24     */
25     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26         require(_b > 0); // Solidity only automatically asserts when dividing by 0
27         uint256 c = _a / _b;
28         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
37         require(_b <= _a);
38         uint256 c = _a - _b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two numbers, reverts on overflow.
45     */
46     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
47         uint256 c = _a + _b;
48         require(c >= _a);
49 
50         return c;
51     }
52 }
53 
54 library AddressUtils {
55 
56     /**
57     * Returns whether the target address is a contract
58     * @dev This function will return false if invoked during the constructor of a contract,
59     *  as the code is not actually created until after the constructor finishes.
60     * @param addr address to check
61     * @return whether the target address is a contract
62     */
63     function isContract(address addr) internal view returns (bool) {
64         uint256 size;
65         // XXX Currently there is no better way to check if there is a contract in an address
66         // than to check the size of the code at that address.
67         // See https://ethereum.stackexchange.com/a/14016/36603
68         // for more details about how this works.
69         // TODO Check this again before the Serenity release, because all addresses will be
70         // contracts then.
71         // solium-disable-next-line security/no-inline-assembly
72         assembly { size := extcodesize(addr) }
73         return size > 0;
74     }
75 
76 }
77 
78 contract Ownable {
79     address public owner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor() public {
83         owner = msg.sender;
84     }
85 
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function transferOwnership(address newOwner) public onlyOwner {
92         require(newOwner != address(0));
93         owner = newOwner;
94         emit OwnershipTransferred(owner, newOwner);
95     }
96 }
97 
98 contract ERC721Basic {
99     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
100     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
101     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
102 
103     function balanceOf(address _owner) public view returns (uint256 _balance);
104     function ownerOf(uint256 _tokenId) public view returns (address _owner);
105     function exists(uint256 _tokenId) public view returns (bool _exists);
106 
107     function approve(address _to, uint256 _tokenId) public;
108     function getApproved(uint256 _tokenId) public view returns (address _operator);
109 
110     function setApprovalForAll(address _operator, bool _approved) public;
111     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
112 
113     function transferFrom(address _from, address _to, uint256 _tokenId) public;
114     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
115 
116     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
117 }
118 
119 /**
120  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
121  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
122  */
123 contract ERC721Enumerable is ERC721Basic {
124     function totalSupply() public view returns (uint256);
125     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
126     function tokenByIndex(uint256 _index) public view returns (uint256);
127 }
128 
129 /**
130  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
131  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
132  */
133 contract ERC721Metadata is ERC721Basic {
134     function name() public view returns (string _name);
135     function symbol() public view returns (string _symbol);
136     function tokenURI(uint256 _tokenId) public view returns (string);
137 }
138 
139 /**
140  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
141  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
142  */
143 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
144 }
145 
146 /**
147  * @title ERC721 Non-Fungible Token Standard basic implementation
148  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
149  */
150 contract ERC721BasicToken is ERC721Basic {
151     using SafeMath for uint256;
152     using AddressUtils for address;
153 
154     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
155     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
156     bytes4 public constant ERC721_RECEIVED = 0x150b7a02;
157 
158     // Mapping from token ID to owner
159     mapping (uint256 => address) internal tokenOwner;
160 
161     // Mapping from token ID to approved address
162     mapping (uint256 => address) internal tokenApprovals;
163 
164     // Mapping from owner to number of owned token
165     mapping (address => uint256) internal ownedTokensCount;
166 
167     // Mapping from owner to operator approvals
168     mapping (address => mapping (address => bool)) internal operatorApprovals;
169 
170     /**
171     * @dev Guarantees msg.sender is owner of the given token
172     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
173     */
174     modifier onlyOwnerOf(uint256 _tokenId) {
175         require (ownerOf(_tokenId) == msg.sender);
176         _;
177     }
178 
179     /**
180     * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
181     * @param _tokenId uint256 ID of the token to validate
182     */
183     modifier canTransfer(uint256 _tokenId) {
184         require (isApprovedOrOwner(msg.sender, _tokenId));
185         _;
186     }
187 
188     /**
189     * @dev Gets the balance of the specified address
190     * @param _owner address to query the balance of
191     * @return uint256 representing the amount owned by the passed address
192     */
193     function balanceOf(address _owner) public view returns (uint256) {
194         require (_owner != address(0));
195         return ownedTokensCount[_owner];
196     }
197 
198     /**
199     * @dev Gets the owner of the specified token ID
200     * @param _tokenId uint256 ID of the token to query the owner of
201     * @return owner address currently marked as the owner of the given token ID
202     */
203     function ownerOf(uint256 _tokenId) public view returns (address) {
204         address owner = tokenOwner[_tokenId];
205         require(owner != address(0));
206         return owner;
207     }
208 
209     function isOwnerOf(address _owner, uint256 _tokenId) public view returns (bool) {
210         address owner = ownerOf(_tokenId);
211         return owner == _owner;
212     }
213 
214     /**
215     * @dev Returns whether the specified token exists
216     * @param _tokenId uint256 ID of the token to query the existence of
217     * @return whether the token exists
218     */
219     function exists(uint256 _tokenId) public view returns (bool) {
220         address owner = tokenOwner[_tokenId];
221         return owner != address(0);
222     }
223 
224     /**
225     * @dev Approves another address to transfer the given token ID
226     * @dev The zero address indicates there is no approved address.
227     * @dev There can only be one approved address per token at a given time.
228     * @dev Can only be called by the token owner or an approved operator.
229     * @param _to address to be approved for the given token ID
230     * @param _tokenId uint256 ID of the token to be approved
231     */
232     function approve(address _to, uint256 _tokenId) public {
233         address owner = ownerOf(_tokenId);
234         require (_to != owner);
235         require (msg.sender == owner || isApprovedForAll(owner, msg.sender));
236 
237         tokenApprovals[_tokenId] = _to;
238         emit Approval(owner, _to, _tokenId);
239     }
240 
241     /**
242     * @dev Gets the approved address for a token ID, or zero if no address set
243     * @param _tokenId uint256 ID of the token to query the approval of
244     * @return address currently approved for the given token ID
245     */
246     function getApproved(uint256 _tokenId) public view returns (address) {
247         return tokenApprovals[_tokenId];
248     }
249 
250     /**
251     * @dev Sets or unsets the approval of a given operator
252     * @dev An operator is allowed to transfer all tokens of the sender on their behalf
253     * @param _to operator address to set the approval
254     * @param _approved representing the status of the approval to be set
255     */
256     function setApprovalForAll(address _to, bool _approved) public {
257         require (_to != msg.sender);
258         operatorApprovals[msg.sender][_to] = _approved;
259         emit ApprovalForAll(msg.sender, _to, _approved);
260     }
261 
262     /**
263     * @dev Tells whether an operator is approved by a given owner
264     * @param _owner owner address which you want to query the approval of
265     * @param _operator operator address which you want to query the approval of
266     * @return bool whether the given operator is approved by the given owner
267     */
268     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
269         return operatorApprovals[_owner][_operator];
270     }
271 
272     /**
273     * @dev Transfers the ownership of a given token ID to another address
274     * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
275     * @dev Requires the msg sender to be the owner, approved, or operator
276     * @param _from current owner of the token
277     * @param _to address to receive the ownership of the given token ID
278     * @param _tokenId uint256 ID of the token to be transferred
279     */
280     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
281         require (_from != address(0));
282         require (_to != address(0));
283 
284         clearApproval(_from, _tokenId);
285         removeTokenFrom(_from, _tokenId);
286         addTokenTo(_to, _tokenId);
287 
288         emit Transfer(_from, _to, _tokenId);
289     }
290 
291     /**
292     * @dev Safely transfers the ownership of a given token ID to another address
293     * @dev If the target address is a contract, it must implement `onERC721Received`,
294     *  which is called upon a safe transfer, and return the magic value
295     *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
296     *  the transfer is reverted.
297     * @dev Requires the msg sender to be the owner, approved, or operator
298     * @param _from current owner of the token
299     * @param _to address to receive the ownership of the given token ID
300     * @param _tokenId uint256 ID of the token to be transferred
301     */
302     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
303         // solium-disable-next-line arg-overflow
304         safeTransferFrom(_from, _to, _tokenId, "");
305     }
306 
307     /**
308     * @dev Safely transfers the ownership of a given token ID to another address
309     * @dev If the target address is a contract, it must implement `onERC721Received`,
310     *  which is called upon a safe transfer, and return the magic value
311     *  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
312     *  the transfer is reverted.
313     * @dev Requires the msg sender to be the owner, approved, or operator
314     * @param _from current owner of the token
315     * @param _to address to receive the ownership of the given token ID
316     * @param _tokenId uint256 ID of the token to be transferred
317     * @param _data bytes data to send along with a safe transfer check
318     */
319     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
320         transferFrom(_from, _to, _tokenId);
321         // solium-disable-next-line arg-overflow
322         require (checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
323     }
324 
325     /**
326     * @dev Returns whether the given spender can transfer a given token ID
327     * @param _spender address of the spender to query
328     * @param _tokenId uint256 ID of the token to be transferred
329     * @return bool whether the msg.sender is approved for the given token ID,
330     *  is an operator of the owner, or is the owner of the token
331     */
332     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
333         address owner = ownerOf(_tokenId);
334         // Disable solium check because of
335         // https://github.com/duaraghav8/Solium/issues/175
336         // solium-disable-next-line operator-whitespace
337         return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
338     }
339 
340     /**
341     * @dev Internal function to mint a new token
342     * @dev Reverts if the given token ID already exists
343     * @param _to The address that will own the minted token
344     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
345     */
346     function _mint(address _to, uint256 _tokenId) internal {
347         //require (_to != address(0));
348         addTokenTo(_to, _tokenId);
349         emit Transfer(address(0), _to, _tokenId);
350     }
351 
352     /**
353     * @dev Internal function to burn a specific token
354     * @dev Reverts if the token does not exist
355     * @param _tokenId uint256 ID of the token being burned by the msg.sender
356     */
357     function _burn(address _owner, uint256 _tokenId) internal {
358         clearApproval(_owner, _tokenId);
359         removeTokenFrom(_owner, _tokenId);
360         emit Transfer(_owner, address(0), _tokenId);
361     }
362 
363     /**
364     * @dev Internal function to clear current approval of a given token ID
365     * @dev Reverts if the given address is not indeed the owner of the token
366     * @param _owner owner of the token
367     * @param _tokenId uint256 ID of the token to be transferred
368     */
369     function clearApproval(address _owner, uint256 _tokenId) internal {
370         require (ownerOf(_tokenId) == _owner);
371         if (tokenApprovals[_tokenId] != address(0)) {
372             tokenApprovals[_tokenId] = address(0);
373         }
374     }
375 
376     /**
377     * @dev Internal function to add a token ID to the list of a given address
378     * @param _to address representing the new owner of the given token ID
379     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
380     */
381     function addTokenTo(address _to, uint256 _tokenId) internal {
382         //        require (tokenOwner[_tokenId] == address(0));
383         tokenOwner[_tokenId] = _to;
384         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
385     }
386 
387     /**
388     * @dev Internal function to remove a token ID from the list of a given address
389     * @param _from address representing the previous owner of the given token ID
390     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
391     */
392     function removeTokenFrom(address _from, uint256 _tokenId) internal {
393         require (ownerOf(_tokenId) == _from);
394         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
395         tokenOwner[_tokenId] = address(0);
396     }
397 
398     /**
399     * @dev Internal function to invoke `onERC721Received` on a target address
400     * @dev The call is not executed if the target address is not a contract
401     * @param _from address representing the previous owner of the given token ID
402     * @param _to target address that will receive the tokens
403     * @param _tokenId uint256 ID of the token to be transferred
404     * @param _data bytes optional data to send along with the call
405     * @return whether the call correctly returned the expected magic value
406     */
407     function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
408         if (!_to.isContract()) {
409             return true;
410         }
411         bytes4 retval = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
412         return (retval == ERC721_RECEIVED);
413     }
414 }
415 
416 /**
417  * @title ERC721 token receiver interface
418  * @dev Interface for any contract that wants to support safeTransfers
419  *  from ERC721 asset contracts.
420  */
421 contract ERC721Receiver {
422     /**
423     * @dev Magic value to be returned upon successful reception of an NFT
424     *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
425     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
426     */
427     bytes4 public constant ERC721_RECEIVED = 0x150b7a02;
428 
429     /**
430     * @notice Handle the receipt of an NFT
431     * @dev The ERC721 smart contract calls this function on the recipient
432     *  after a `safetransfer`. This function MAY throw to revert and reject the
433     *  transfer. This function MUST use 50,000 gas or less. Return of other
434     *  than the magic value MUST result in the transaction being reverted.
435     *  Note: the contract address is always the message sender.
436     * @param _from The sending address
437     * @param _tokenId The NFT identifier which is being transfered
438     * @param _data Additional data with no specified format
439     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
440     */
441     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
442 }
443 
444 contract ERC721Holder is ERC721Receiver {
445     function onERC721Received(address, address, uint256, bytes) public returns(bytes4) {
446         return ERC721_RECEIVED;
447     }
448 }
449 
450 /**
451  * @title Full ERC721 Token
452  * This implementation includes all the required and some optional functionality of the ERC721 standard
453  * Moreover, it includes approve all functionality using operator terminology
454  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
455  */
456 contract ERC721Token is ERC721, ERC721BasicToken {
457 
458     // Token name
459     string internal name_ = "CryptoFlowers";
460 
461     // Token symbol
462     string internal symbol_ = "CF";
463 
464     // Mapping from owner to list of owned token IDs
465     mapping(address => uint256[]) internal ownedTokens;
466 
467     // Mapping from token ID to index of the owner tokens list
468     mapping(uint256 => uint256) internal ownedTokensIndex;
469 
470     // Array with all token ids, used for enumeration
471     uint256[] internal allTokens;
472 
473     // Mapping from token id to position in the allTokens array
474     mapping(uint256 => uint256) internal allTokensIndex;
475 
476     function uint2str(uint i) internal pure returns (string){
477         if (i == 0) return "0";
478         uint j = i;
479         uint length;
480         while (j != 0){
481             length++;
482             j /= 10;
483         }
484         bytes memory bstr = new bytes(length);
485         uint k = length - 1;
486         while (i != 0){
487             bstr[k--] = byte(48 + i % 10);
488             i /= 10;
489         }
490         return string(bstr);
491     }
492 
493     function strConcat(string _a, string _b) internal pure returns (string) {
494         bytes memory _ba = bytes(_a);
495         bytes memory _bb = bytes(_b);
496         string memory ab = new string(_ba.length + _bb.length);
497         bytes memory bab = bytes(ab);
498         uint k = 0;
499         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
500         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
501 
502         return string(bab);
503     }
504 
505     /**
506     * @dev Returns an URI for a given token ID
507     * @dev Throws if the token ID does not exist. May return an empty string.
508     * @notice The user/developper needs to add the tokenID, in the end of URL, to
509     * use the URI and get all details. Ex. www.<apiURL>.com/token/<tokenID>
510     * @param _tokenId uint256 ID of the token to query
511     */
512     function tokenURI(uint256 _tokenId) public view returns (string) {
513         require(exists(_tokenId));
514         string memory infoUrl;
515         infoUrl = strConcat('https://cryptoflowers.io/v/', uint2str(_tokenId));
516         return infoUrl;
517     }
518 
519     /**
520     * @dev Gets the token ID at a given index of the tokens list of the requested owner
521     * @param _owner address owning the tokens list to be accessed
522     * @param _index uint256 representing the index to be accessed of the requested tokens list
523     * @return uint256 token ID at the given index of the tokens list owned by the requested address
524     */
525     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
526         require (_index < balanceOf(_owner));
527         return ownedTokens[_owner][_index];
528     }
529 
530     /**
531     * @dev Gets the total amount of tokens stored by the contract
532     * @return uint256 representing the total amount of tokens
533     */
534     function totalSupply() public view returns (uint256) {
535         return allTokens.length - 1;
536     }
537 
538     /**
539     * @dev Gets the token ID at a given index of all the tokens in this contract
540     * @dev Reverts if the index is greater or equal to the total number of tokens
541     * @param _index uint256 representing the index to be accessed of the tokens list
542     * @return uint256 token ID at the given index of the tokens list
543     */
544     function tokenByIndex(uint256 _index) public view returns (uint256) {
545         require (_index <= totalSupply());
546         return allTokens[_index];
547     }
548 
549 
550     /**
551     * @dev Internal function to add a token ID to the list of a given address
552     * @param _to address representing the new owner of the given token ID
553     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
554     */
555     function addTokenTo(address _to, uint256 _tokenId) internal {
556         super.addTokenTo(_to, _tokenId);
557         uint256 length = ownedTokens[_to].length;
558         ownedTokens[_to].push(_tokenId);
559         ownedTokensIndex[_tokenId] = length;
560     }
561 
562     /**
563     * @dev Internal function to remove a token ID from the list of a given address
564     * @param _from address representing the previous owner of the given token ID
565     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
566     */
567     function removeTokenFrom(address _from, uint256 _tokenId) internal {
568         super.removeTokenFrom(_from, _tokenId);
569 
570         // To prevent a gap in the array, we store the last token in the index of the token to delete, and
571         // then delete the last slot.
572         uint256 tokenIndex = ownedTokensIndex[_tokenId];
573         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
574         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
575 
576         ownedTokens[_from][tokenIndex] = lastToken;
577         // This also deletes the contents at the last position of the array
578         ownedTokens[_from].length--;
579 
580         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
581         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
582         // the lastToken to the first position, and then dropping the element placed in the last position of the list
583 
584         ownedTokensIndex[_tokenId] = 0;
585         ownedTokensIndex[lastToken] = tokenIndex;
586     }
587 
588     /**
589     * @dev Gets the token name
590     * @return string representing the token name
591     */
592     function name() public view returns (string) {
593         return name_;
594     }
595 
596     /**
597     * @dev Gets the token symbol
598     * @return string representing the token symbol
599     */
600     function symbol() public view returns (string) {
601         return symbol_;
602     }
603 
604     /**
605     * @dev Internal function to mint a new token
606     * @dev Reverts if the given token ID already exists
607     * @param _to address the beneficiary that will own the minted token
608     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
609     */
610     function _mint(address _to, uint256 _tokenId) internal {
611         super._mint(_to, _tokenId);
612 
613         allTokensIndex[_tokenId] = allTokens.length;
614         allTokens.push(_tokenId);
615     }
616 
617     /**
618     * @dev Internal function to burn a specific token
619     * @dev Reverts if the token does not exist
620     * @param _owner owner of the token to burn
621     * @param _tokenId uint256 ID of the token being burned by the msg.sender
622     */
623     function _burn(address _owner, uint256 _tokenId) internal {
624         super._burn(_owner, _tokenId);
625 
626         // Reorg all tokens array
627         uint256 tokenIndex = allTokensIndex[_tokenId];
628         uint256 lastTokenIndex = allTokens.length.sub(1);
629         uint256 lastToken = allTokens[lastTokenIndex];
630 
631         allTokens[tokenIndex] = lastToken;
632         allTokens[lastTokenIndex] = 0;
633 
634         allTokens.length--;
635         allTokensIndex[_tokenId] = 0;
636         allTokensIndex[lastToken] = tokenIndex;
637     }
638 
639     bytes4 constant InterfaceSignature_ERC165 = 0x01ffc9a7;
640     /*
641     bytes4(keccak256('supportsInterface(bytes4)'));
642     */
643 
644     bytes4 constant InterfaceSignature_ERC721Enumerable = 0x780e9d63;
645     /*
646     bytes4(keccak256('totalSupply()')) ^
647     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
648     bytes4(keccak256('tokenByIndex(uint256)'));
649     */
650 
651     bytes4 constant InterfaceSignature_ERC721Metadata = 0x5b5e139f;
652     /*
653     bytes4(keccak256('name()')) ^
654     bytes4(keccak256('symbol()')) ^
655     bytes4(keccak256('tokenURI(uint256)'));
656     */
657 
658     bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
659     /*
660     bytes4(keccak256('balanceOf(address)')) ^
661     bytes4(keccak256('ownerOf(uint256)')) ^
662     bytes4(keccak256('approve(address,uint256)')) ^
663     bytes4(keccak256('getApproved(uint256)')) ^
664     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
665     bytes4(keccak256('isApprovedForAll(address,address)')) ^
666     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
667     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
668     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'));
669     */
670 
671     bytes4 public constant InterfaceSignature_ERC721Optional =- 0x4f558e79;
672     /*
673     bytes4(keccak256('exists(uint256)'));
674     */
675 
676     /**
677     * @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
678     * @dev Returns true for any standardized interfaces implemented by this contract.
679     * @param _interfaceID bytes4 the interface to check for
680     * @return true for any standardized interfaces implemented by this contract.
681     */
682     function supportsInterface(bytes4 _interfaceID) external pure returns (bool)
683     {
684         return ((_interfaceID == InterfaceSignature_ERC165)
685         || (_interfaceID == InterfaceSignature_ERC721)
686         || (_interfaceID == InterfaceSignature_ERC721Enumerable)
687         || (_interfaceID == InterfaceSignature_ERC721Metadata));
688     }
689 
690     function implementsERC721() public pure returns (bool) {
691         return true;
692     }
693 
694 }
695 
696 contract GenomeInterface {
697     function isGenome() public pure returns (bool);
698     function mixGenes(uint256 genes1, uint256 genes2) public returns (uint256);
699 }
700 
701 contract FlowerAdminAccess {
702     address public rootAddress;
703     address public adminAddress;
704 
705     event ContractUpgrade(address newContract);
706 
707     address public gen0SellerAddress;
708     address public giftHolderAddress;
709 
710     bool public stopped = false;
711 
712     modifier onlyRoot() {
713         require(msg.sender == rootAddress);
714         _;
715     }
716 
717     modifier onlyAdmin()  {
718         require(msg.sender == adminAddress);
719         _;
720     }
721 
722     modifier onlyAdministrator() {
723         require(msg.sender == rootAddress || msg.sender == adminAddress);
724         _;
725     }
726 
727     function setRoot(address _newRoot) external onlyAdministrator {
728         require(_newRoot != address(0));
729         rootAddress = _newRoot;
730     }
731 
732     function setAdmin(address _newAdmin) external onlyRoot {
733         require(_newAdmin != address(0));
734         adminAddress = _newAdmin;
735     }
736 
737     modifier whenNotStopped() {
738         require(!stopped);
739         _;
740     }
741 
742     modifier whenStopped {
743         require(stopped);
744         _;
745     }
746 
747     function setStop() public onlyAdministrator whenNotStopped {
748         stopped = true;
749     }
750 
751     function setStart() public onlyAdministrator whenStopped {
752         stopped = false;
753     }
754 }
755 
756 contract FlowerBase is ERC721Token {
757 
758     struct Flower {
759         uint256 genes;
760         uint64 birthTime;
761         uint64 cooldownEndBlock;
762         uint32 matronId;
763         uint32 sireId;
764         uint16 cooldownIndex;
765         uint16 generation;
766     }
767 
768     Flower[] flowers;
769 
770     mapping (uint256 => uint256) genomeFlowerIds;
771 
772     // Сooldown duration
773     uint32[14] public cooldowns = [
774     uint32(1 minutes),
775     uint32(2 minutes),
776     uint32(5 minutes),
777     uint32(10 minutes),
778     uint32(30 minutes),
779     uint32(1 hours),
780     uint32(2 hours),
781     uint32(4 hours),
782     uint32(8 hours),
783     uint32(16 hours),
784     uint32(1 days),
785     uint32(2 days),
786     uint32(4 days),
787     uint32(7 days)
788     ];
789 
790     event Birth(address owner, uint256 flowerId, uint256 matronId, uint256 sireId, uint256 genes);
791     event Transfer(address from, address to, uint256 tokenId);
792     event Money(address from, string actionType, uint256 sum, uint256 cut, uint256 tokenId, uint256 blockNumber);
793 
794     function _createFlower(uint256 _matronId, uint256 _sireId, uint256 _generation, uint256 _genes, address _owner) internal returns (uint) {
795         require(_matronId == uint256(uint32(_matronId)));
796         require(_sireId == uint256(uint32(_sireId)));
797         require(_generation == uint256(uint16(_generation)));
798         require(checkUnique(_genes));
799 
800         uint16 cooldownIndex = uint16(_generation / 2);
801         if (cooldownIndex > 13) {
802             cooldownIndex = 13;
803         }
804 
805         Flower memory _flower = Flower({
806             genes: _genes,
807             birthTime: uint64(now),
808             cooldownEndBlock: 0,
809             matronId: uint32(_matronId),
810             sireId: uint32(_sireId),
811             cooldownIndex: cooldownIndex,
812             generation: uint16(_generation)
813             });
814 
815         uint256 newFlowerId = flowers.push(_flower) - 1;
816 
817         require(newFlowerId == uint256(uint32(newFlowerId)));
818 
819         genomeFlowerIds[_genes] = newFlowerId;
820 
821         emit Birth(_owner, newFlowerId, uint256(_flower.matronId), uint256(_flower.sireId), _flower.genes);
822 
823         _mint(_owner, newFlowerId);
824 
825         return newFlowerId;
826     }
827 
828     function checkUnique(uint256 _genome) public view returns (bool) {
829         uint256 _flowerId = uint256(genomeFlowerIds[_genome]);
830         return !(_flowerId > 0);
831     }
832 }
833 
834 contract FlowerOwnership is FlowerBase, FlowerAdminAccess {
835     SaleClockAuction public saleAuction;
836     BreedingClockAuction public breedingAuction;
837 
838     uint256 public secondsPerBlock = 15;
839 
840     function setSecondsPerBlock(uint256 secs) external onlyAdministrator {
841         require(secs < cooldowns[0]);
842         secondsPerBlock = secs;
843     }
844 }
845 
846 contract ClockAuctionBase {
847 
848     struct Auction {
849         address seller;
850         uint128 startingPrice;
851         uint128 endingPrice;
852         uint64 duration;
853         uint64 startedAt;
854     }
855 
856     ERC721Token public nonFungibleContract;
857 
858     uint256 public ownerCut;
859 
860     mapping (uint256 => Auction) tokenIdToAuction;
861 
862     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
863     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
864     event AuctionCancelled(uint256 tokenId);
865     event Money(address from, string actionType, uint256 sum, uint256 cut, uint256 tokenId, uint256 blockNumber);
866 
867     function isOwnerOf(address _claimant, uint256 _tokenId) internal view returns (bool) {
868         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
869     }
870 
871     function _escrow(address _owner, uint256 _tokenId) internal {
872         nonFungibleContract.transferFrom(_owner, this, _tokenId);
873     }
874 
875     function _transfer(address _receiver, uint256 _tokenId) internal {
876         nonFungibleContract.transferFrom(this, _receiver, _tokenId);
877     }
878 
879     function _addAuction(uint256 _tokenId, Auction _auction) internal {
880         require(_auction.duration >= 1 minutes);
881 
882         tokenIdToAuction[_tokenId] = _auction;
883 
884         emit AuctionCreated(uint256(_tokenId), uint256(_auction.startingPrice), uint256(_auction.endingPrice), uint256(_auction.duration));
885     }
886 
887     function _cancelAuction(uint256 _tokenId, address _seller) internal {
888         _removeAuction(_tokenId);
889         _transfer(_seller, _tokenId);
890         emit AuctionCancelled(_tokenId);
891     }
892 
893     function _bid(uint256 _tokenId, uint256 _bidAmount, address _sender) internal returns (uint256) {
894         Auction storage auction = tokenIdToAuction[_tokenId];
895 
896         require(_isOnAuction(auction));
897 
898         uint256 price = _currentPrice(auction);
899         require(_bidAmount >= price);
900 
901         address seller = auction.seller;
902 
903         _removeAuction(_tokenId);
904 
905         if (price > 0) {
906             uint256 auctioneerCut = _computeCut(price);
907             uint256 sellerProceeds = price - auctioneerCut;
908             seller.transfer(sellerProceeds);
909 
910             emit Money(_sender, "AuctionSuccessful", price, auctioneerCut, _tokenId, block.number);
911         }
912 
913         uint256 bidExcess = _bidAmount - price;
914 
915         _sender.transfer(bidExcess);
916 
917         emit AuctionSuccessful(_tokenId, price, _sender);
918 
919         return price;
920     }
921 
922     function _removeAuction(uint256 _tokenId) internal {
923         delete tokenIdToAuction[_tokenId];
924     }
925 
926     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
927         return (_auction.startedAt > 0 && _auction.startedAt < now);
928     }
929 
930     function _currentPrice(Auction storage _auction) internal view returns (uint256) {
931         uint256 secondsPassed = 0;
932 
933         if (now > _auction.startedAt) {
934             secondsPassed = now - _auction.startedAt;
935         }
936 
937         return _computeCurrentPrice(_auction.startingPrice, _auction.endingPrice, _auction.duration, secondsPassed);
938     }
939 
940     function _computeCurrentPrice(uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, uint256 _secondsPassed) internal pure returns (uint256) {
941         if (_secondsPassed >= _duration) {
942             return _endingPrice;
943         } else {
944             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
945 
946             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
947 
948             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
949 
950             return uint256(currentPrice);
951         }
952     }
953 
954     function _computeCut(uint256 _price) internal view returns (uint256) {
955         return uint256(_price * ownerCut / 10000);
956     }
957 }
958 
959 contract Pausable is Ownable {
960     event Pause();
961     event Unpause();
962 
963     bool public paused = false;
964 
965     modifier whenNotPaused() {
966         require(!paused);
967         _;
968     }
969 
970     modifier whenPaused {
971         require(paused);
972         _;
973     }
974 
975     function pause() public onlyOwner whenNotPaused returns (bool) {
976         paused = true;
977         emit Pause();
978         return true;
979     }
980 
981     function unpause() public onlyOwner whenPaused returns (bool) {
982         paused = false;
983         emit Unpause();
984         return true;
985     }
986 }
987 
988 contract ClockAuction is Pausable, ClockAuctionBase {
989     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x80ac58cd);
990     constructor(address _nftAddress, uint256 _cut) public {
991         require(_cut <= 10000);
992         ownerCut = _cut;
993 
994         ERC721Token candidateContract = ERC721Token(_nftAddress);
995         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
996         nonFungibleContract = candidateContract;
997     }
998 
999     function withdrawBalance() external {
1000         address nftAddress = address(nonFungibleContract);
1001         require(msg.sender == owner || msg.sender == nftAddress);
1002         owner.transfer(address(this).balance);
1003     }
1004 
1005     function createAuction(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _seller, uint64 _startAt) external whenNotPaused {
1006         require(_startingPrice == uint256(uint128(_startingPrice)));
1007         require(_endingPrice == uint256(uint128(_endingPrice)));
1008         require(_duration == uint256(uint64(_duration)));
1009         require(isOwnerOf(msg.sender, _tokenId));
1010         _escrow(msg.sender, _tokenId);
1011         uint64 startAt = _startAt;
1012         if (_startAt == 0) {
1013             startAt = uint64(now);
1014         }
1015         Auction memory auction = Auction(
1016             _seller,
1017             uint128(_startingPrice),
1018             uint128(_endingPrice),
1019             uint64(_duration),
1020             uint64(startAt)
1021         );
1022         _addAuction(_tokenId, auction);
1023     }
1024 
1025     function bid(uint256 _tokenId, address _sender) external payable whenNotPaused {
1026         _bid(_tokenId, msg.value, _sender);
1027         _transfer(_sender, _tokenId);
1028     }
1029 
1030     function cancelAuction(uint256 _tokenId) external {
1031         Auction storage auction = tokenIdToAuction[_tokenId];
1032         require(_isOnAuction(auction));
1033         address seller = auction.seller;
1034         require(msg.sender == seller);
1035         _cancelAuction(_tokenId, seller);
1036     }
1037 
1038     function cancelAuctionByAdmin(uint256 _tokenId) onlyOwner external {
1039         Auction storage auction = tokenIdToAuction[_tokenId];
1040         require(_isOnAuction(auction));
1041         _cancelAuction(_tokenId, auction.seller);
1042     }
1043 
1044     function getAuction(uint256 _tokenId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt) {
1045         Auction storage auction = tokenIdToAuction[_tokenId];
1046         require(_isOnAuction(auction));
1047         return (auction.seller, auction.startingPrice, auction.endingPrice, auction.duration, auction.startedAt);
1048     }
1049 
1050     function getCurrentPrice(uint256 _tokenId) external view returns (uint256){
1051         Auction storage auction = tokenIdToAuction[_tokenId];
1052         require(_isOnAuction(auction));
1053         return _currentPrice(auction);
1054     }
1055 
1056     // TMP
1057     function getContractBalance() onlyOwner external view returns (uint256) {
1058         return address(this).balance;
1059     }
1060 }
1061 
1062 contract BreedingClockAuction is ClockAuction {
1063 
1064     bool public isBreedingClockAuction = true;
1065 
1066     constructor(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
1067 
1068     function bid(uint256 _tokenId, address _sender) external payable {
1069         require(msg.sender == address(nonFungibleContract));
1070         address seller = tokenIdToAuction[_tokenId].seller;
1071         _bid(_tokenId, msg.value, _sender);
1072         _transfer(seller, _tokenId);
1073     }
1074 
1075     function getCurrentPrice(uint256 _tokenId) external view returns (uint256) {
1076         Auction storage auction = tokenIdToAuction[_tokenId];
1077         require(_isOnAuction(auction));
1078         return _currentPrice(auction);
1079     }
1080 
1081     function createAuction(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _seller, uint64 _startAt) external {
1082         require(_startingPrice == uint256(uint128(_startingPrice)));
1083         require(_endingPrice == uint256(uint128(_endingPrice)));
1084         require(_duration == uint256(uint64(_duration)));
1085 
1086         require(msg.sender == address(nonFungibleContract));
1087         _escrow(_seller, _tokenId);
1088         uint64 startAt = _startAt;
1089         if (_startAt == 0) {
1090             startAt = uint64(now);
1091         }
1092         Auction memory auction = Auction(_seller, uint128(_startingPrice), uint128(_endingPrice), uint64(_duration), uint64(startAt));
1093         _addAuction(_tokenId, auction);
1094     }
1095 }
1096 
1097 
1098 
1099 
1100 
1101 contract SaleClockAuction is ClockAuction {
1102 
1103     bool public isSaleClockAuction = true;
1104 
1105     uint256 public gen0SaleCount;
1106     uint256[5] public lastGen0SalePrices;
1107 
1108     constructor(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
1109 
1110     address public gen0SellerAddress;
1111     function setGen0SellerAddress(address _newAddress) external {
1112         require(msg.sender == address(nonFungibleContract));
1113         gen0SellerAddress = _newAddress;
1114     }
1115 
1116     function createAuction(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _seller, uint64 _startAt) external {
1117         require(_startingPrice == uint256(uint128(_startingPrice)));
1118         require(_endingPrice == uint256(uint128(_endingPrice)));
1119         require(_duration == uint256(uint64(_duration)));
1120 
1121         require(msg.sender == address(nonFungibleContract));
1122         _escrow(_seller, _tokenId);
1123         uint64 startAt = _startAt;
1124         if (_startAt == 0) {
1125             startAt = uint64(now);
1126         }
1127         Auction memory auction = Auction(_seller, uint128(_startingPrice), uint128(_endingPrice), uint64(_duration), uint64(startAt));
1128         _addAuction(_tokenId, auction);
1129     }
1130 
1131     function bid(uint256 _tokenId) external payable {
1132         // _bid verifies token ID size
1133         address seller = tokenIdToAuction[_tokenId].seller;
1134         uint256 price = _bid(_tokenId, msg.value, msg.sender);
1135         _transfer(msg.sender, _tokenId);
1136 
1137         // If not a gen0 auction, exit
1138         if (seller == address(gen0SellerAddress)) {
1139             // Track gen0 sale prices
1140             lastGen0SalePrices[gen0SaleCount % 5] = price;
1141             gen0SaleCount++;
1142         }
1143     }
1144 
1145     function bidGift(uint256 _tokenId, address _to) external payable {
1146         // _bid verifies token ID size
1147         address seller = tokenIdToAuction[_tokenId].seller;
1148         uint256 price = _bid(_tokenId, msg.value, msg.sender);
1149         _transfer(_to, _tokenId);
1150 
1151         // If not a gen0 auction, exit
1152         if (seller == address(gen0SellerAddress)) {
1153             // Track gen0 sale prices
1154             lastGen0SalePrices[gen0SaleCount % 5] = price;
1155             gen0SaleCount++;
1156         }
1157     }
1158 
1159     function averageGen0SalePrice() external view returns (uint256) {
1160         uint256 sum = 0;
1161         for (uint256 i = 0; i < 5; i++) {
1162             sum += lastGen0SalePrices[i];
1163         }
1164         return sum / 5;
1165     }
1166 
1167     function computeCut(uint256 _price) public view returns (uint256) {
1168         return _computeCut(_price);
1169     }
1170 
1171     function getSeller(uint256 _tokenId) public view returns (address) {
1172         return address(tokenIdToAuction[_tokenId].seller);
1173     }
1174 }
1175 
1176 // Flowers crossing
1177 contract FlowerBreeding is FlowerOwnership {
1178 
1179     // Fee for breeding
1180     uint256 public autoBirthFee = 2 finney;
1181     uint256 public giftFee = 2 finney;
1182 
1183     GenomeInterface public geneScience;
1184 
1185     // Set Genome contract address
1186     function setGenomeContractAddress(address _address) external onlyAdministrator {
1187         geneScience = GenomeInterface(_address);
1188     }
1189 
1190     function _isReadyToAction(Flower _flower) internal view returns (bool) {
1191         return _flower.cooldownEndBlock <= uint64(block.number);
1192     }
1193 
1194     function isReadyToAction(uint256 _flowerId) public view returns (bool) {
1195         require(_flowerId > 0);
1196         Flower storage flower = flowers[_flowerId];
1197         return _isReadyToAction(flower);
1198     }
1199 
1200     function _setCooldown(Flower storage _flower) internal {
1201         _flower.cooldownEndBlock = uint64((cooldowns[_flower.cooldownIndex]/secondsPerBlock) + block.number);
1202 
1203         if (_flower.cooldownIndex < 13) {
1204             _flower.cooldownIndex += 1;
1205         }
1206     }
1207 
1208     function setAutoBirthFee(uint256 val) external onlyAdministrator {
1209         autoBirthFee = val;
1210     }
1211 
1212     function setGiftFee(uint256 _fee) external onlyAdministrator {
1213         giftFee = _fee;
1214     }
1215 
1216     // Check if a given sire and matron are a valid crossing pair
1217     function _isValidPair(Flower storage _matron, uint256 _matronId, Flower storage _sire, uint256 _sireId) private view returns(bool) {
1218         if (_matronId == _sireId) {
1219             return false;
1220         }
1221 
1222         // Generation zero can crossing
1223         if (_sire.matronId == 0 || _matron.matronId == 0) {
1224             return true;
1225         }
1226 
1227         // Do not crossing with it parrents
1228         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
1229             return false;
1230         }
1231         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
1232             return false;
1233         }
1234 
1235         // Can't crossing with brothers and sisters
1236         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
1237             return false;
1238         }
1239         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
1240             return false;
1241         }
1242 
1243         return true;
1244     }
1245 
1246     function canBreedWith(uint256 _matronId, uint256 _sireId) external view returns (bool) {
1247         return _canBreedWith(_matronId, _sireId);
1248     }
1249 
1250     function _canBreedWith(uint256 _matronId, uint256 _sireId) internal view returns (bool) {
1251         require(_matronId > 0);
1252         require(_sireId > 0);
1253         Flower storage matron = flowers[_matronId];
1254         Flower storage sire = flowers[_sireId];
1255         return _isValidPair(matron, _matronId, sire, _sireId);
1256     }
1257 
1258     function _born(uint256 _matronId, uint256 _sireId) internal {
1259         Flower storage sire = flowers[_sireId];
1260         Flower storage matron = flowers[_matronId];
1261 
1262         uint16 parentGen = matron.generation;
1263         if (sire.generation > matron.generation) {
1264             parentGen = sire.generation;
1265         }
1266 
1267         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes);
1268         address owner = ownerOf(_matronId);
1269         uint256 flowerId = _createFlower(_matronId, _sireId, parentGen + 1, childGenes, owner);
1270 
1271         Flower storage child = flowers[flowerId];
1272 
1273         _setCooldown(sire);
1274         _setCooldown(matron);
1275         _setCooldown(child);
1276     }
1277 
1278     // Crossing two of owner flowers
1279     function breedOwn(uint256 _matronId, uint256 _sireId) external payable whenNotStopped {
1280         require(msg.value >= autoBirthFee);
1281         require(isOwnerOf(msg.sender, _matronId));
1282         require(isOwnerOf(msg.sender, _sireId));
1283 
1284         Flower storage matron = flowers[_matronId];
1285         require(_isReadyToAction(matron));
1286 
1287         Flower storage sire = flowers[_sireId];
1288         require(_isReadyToAction(sire));
1289 
1290         require(_isValidPair(matron, _matronId, sire, _sireId));
1291 
1292         _born(_matronId, _sireId);
1293 
1294         gen0SellerAddress.transfer(autoBirthFee);
1295 
1296         emit Money(msg.sender, "BirthFee-own", autoBirthFee, autoBirthFee, _sireId, block.number);
1297     }
1298 }
1299 
1300 // Handles creating auctions for sale and siring
1301 contract FlowerAuction is FlowerBreeding {
1302 
1303     // Set sale auction contract address
1304     function setSaleAuctionAddress(address _address) external onlyAdministrator {
1305         SaleClockAuction candidateContract = SaleClockAuction(_address);
1306         require(candidateContract.isSaleClockAuction());
1307         saleAuction = candidateContract;
1308     }
1309 
1310     // Set siring auction contract address
1311     function setBreedingAuctionAddress(address _address) external onlyAdministrator {
1312         BreedingClockAuction candidateContract = BreedingClockAuction(_address);
1313         require(candidateContract.isBreedingClockAuction());
1314         breedingAuction = candidateContract;
1315     }
1316 
1317     // Flower sale auction
1318     function createSaleAuction(uint256 _flowerId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external whenNotStopped {
1319         require(isOwnerOf(msg.sender, _flowerId));
1320         require(isReadyToAction(_flowerId));
1321         approve(saleAuction, _flowerId);
1322         saleAuction.createAuction(_flowerId, _startingPrice, _endingPrice, _duration, msg.sender, 0);
1323     }
1324 
1325     // Create siring auction
1326     function createBreedingAuction(uint256 _flowerId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external whenNotStopped {
1327         require(isOwnerOf(msg.sender, _flowerId));
1328         require(isReadyToAction(_flowerId));
1329         approve(breedingAuction, _flowerId);
1330         breedingAuction.createAuction(_flowerId, _startingPrice, _endingPrice, _duration, msg.sender, 0);
1331     }
1332 
1333     // Siring auction complete
1334     function bidOnBreedingAuction(uint256 _sireId, uint256 _matronId) external payable whenNotStopped {
1335         require(isOwnerOf(msg.sender, _matronId));
1336         require(isReadyToAction(_matronId));
1337         require(isReadyToAction(_sireId));
1338         require(_canBreedWith(_matronId, _sireId));
1339 
1340         uint256 currentPrice = breedingAuction.getCurrentPrice(_sireId);
1341         require(msg.value >= currentPrice + autoBirthFee);
1342 
1343         // Siring auction will throw if the bid fails.
1344         breedingAuction.bid.value(msg.value - autoBirthFee)(_sireId, msg.sender);
1345         _born(uint32(_matronId), uint32(_sireId));
1346         gen0SellerAddress.transfer(autoBirthFee);
1347         emit Money(msg.sender, "BirthFee-bid", autoBirthFee, autoBirthFee, _sireId, block.number);
1348     }
1349 
1350     // Transfers the balance of the sale auction contract to the Core contract
1351     function withdrawAuctionBalances() external onlyAdministrator {
1352         saleAuction.withdrawBalance();
1353         breedingAuction.withdrawBalance();
1354     }
1355 
1356     function sendGift(uint256 _flowerId, address _to) external payable whenNotStopped {
1357         require(isOwnerOf(msg.sender, _flowerId));
1358         require(isReadyToAction(_flowerId));
1359 
1360         transferFrom(msg.sender, _to, _flowerId);
1361     }
1362 
1363     function makeGift(uint256 _flowerId) external payable whenNotStopped {
1364         require(isOwnerOf(msg.sender, _flowerId));
1365         require(isReadyToAction(_flowerId));
1366         require(msg.value >= giftFee);
1367 
1368         transferFrom(msg.sender, giftHolderAddress, _flowerId);
1369         giftHolderAddress.transfer(msg.value);
1370 
1371         emit Money(msg.sender, "MakeGift", msg.value, msg.value, _flowerId, block.number);
1372     }
1373 }
1374 
1375 contract FlowerMinting is FlowerAuction {
1376     // Constants for gen0 auctions.
1377     uint256 public constant GEN0_STARTING_PRICE = 10 finney;
1378     uint256 public constant GEN0_AUCTION_DURATION = 1 days;
1379     // Counts the number of cats the contract owner has created
1380     uint256 public promoCreatedCount;
1381     uint256 public gen0CreatedCount;
1382 
1383     // Create promo flower
1384     function createPromoFlower(uint256 _genes, address _owner) external onlyAdministrator {
1385         address flowerOwner = _owner;
1386         if (flowerOwner == address(0)) {
1387             flowerOwner = adminAddress;
1388         }
1389         promoCreatedCount++;
1390         gen0CreatedCount++;
1391         _createFlower(0, 0, 0, _genes, flowerOwner);
1392     }
1393 
1394     function createGen0Auction(uint256 _genes, uint64 _auctionStartAt) external onlyAdministrator {
1395         uint256 flowerId = _createFlower(0, 0, 0, _genes, address(gen0SellerAddress));
1396         tokenApprovals[flowerId] = saleAuction;
1397         //approve(saleAuction, flowerId);
1398 
1399         gen0CreatedCount++;
1400 
1401         saleAuction.createAuction(flowerId, _computeNextGen0Price(), 0, GEN0_AUCTION_DURATION, address(gen0SellerAddress), _auctionStartAt);
1402     }
1403 
1404     // Computes the next gen0 auction starting price, given the average of the past 5 prices + 50%.
1405     function _computeNextGen0Price() internal view returns (uint256) {
1406         uint256 avePrice = saleAuction.averageGen0SalePrice();
1407 
1408         // Sanity check to ensure we don't overflow arithmetic
1409         require(avePrice == uint256(uint128(avePrice)));
1410 
1411         uint256 nextPrice = avePrice + (avePrice / 2);
1412 
1413         // We never auction for less than starting price
1414         if (nextPrice < GEN0_STARTING_PRICE) {
1415             nextPrice = GEN0_STARTING_PRICE;
1416         }
1417 
1418         return nextPrice;
1419     }
1420 
1421     function setGen0SellerAddress(address _newAddress) external onlyAdministrator {
1422         gen0SellerAddress = _newAddress;
1423         saleAuction.setGen0SellerAddress(_newAddress);
1424     }
1425 
1426     function setGiftHolderAddress(address _newAddress) external onlyAdministrator {
1427         giftHolderAddress = _newAddress;
1428     }
1429 }
1430 
1431 contract FlowerCore is FlowerMinting {
1432 
1433     constructor() public {
1434         stopped = true;
1435         rootAddress = msg.sender;
1436         adminAddress = msg.sender;
1437         _createFlower(0, 0, 0, uint256(-1), address(0));
1438     }
1439 
1440     // Get flower information
1441     function getFlower(uint256 _id) external view returns (bool isReady, uint256 cooldownIndex, uint256 nextActionAt, uint256 birthTime, uint256 matronId, uint256 sireId, uint256 generation, uint256 genes) {
1442         Flower storage flower = flowers[_id];
1443         isReady = (flower.cooldownEndBlock <= block.number);
1444         cooldownIndex = uint256(flower.cooldownIndex);
1445         nextActionAt = uint256(flower.cooldownEndBlock);
1446         birthTime = uint256(flower.birthTime);
1447         matronId = uint256(flower.matronId);
1448         sireId = uint256(flower.sireId);
1449         generation = uint256(flower.generation);
1450         genes = flower.genes;
1451     }
1452 
1453     // Start the game
1454     function unstop() public onlyAdministrator whenStopped {
1455         require(geneScience != address(0));
1456 
1457         super.setStart();
1458     }
1459 
1460     function withdrawBalance() external onlyAdministrator {
1461         rootAddress.transfer(address(this).balance);
1462     }
1463 }