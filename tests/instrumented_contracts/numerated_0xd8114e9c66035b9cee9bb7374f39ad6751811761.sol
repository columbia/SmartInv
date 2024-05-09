1 pragma solidity ^0.4.24;
2 
3 interface ERC165 {
4     /// @notice Query if a contract implements an interface
5     /// @param interfaceID The interface identifier, as specified in ERC-165
6     /// @dev Interface identification is specified in ERC-165. This function
7     ///  uses less than 30,000 gas.
8     /// @return `true` if the contract implements `interfaceID` and
9     ///  `interfaceID` is not 0xffffffff, `false` otherwise
10     function supportsInterface(bytes4 interfaceID) external view returns (bool);
11 }
12 
13 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
14 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
15 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
16 interface ERC721Metadata /* is ERC721 */ {
17     /// @notice A descriptive name for a collection of NFTs in this contract
18     function name() external pure returns (string _name);
19 
20     /// @notice An abbreviated name for NFTs in this contract
21     function symbol() external pure returns (string _symbol);
22 
23     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
24     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
25     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
26     ///  Metadata JSON Schema".
27     function tokenURI(uint256 _tokenId) external view returns (string);
28 }
29 
30 
31 /// @title ERC-721 Non-Fungible Token Standard
32 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
33 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
34 interface ERC721 /* is ERC165 */ {
35     /// @dev This emits when ownership of any NFT changes by any mechanism.
36     ///  This event emits when NFTs are created (`from` == 0) and destroyed
37     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
38     ///  may be created and assigned without emitting Transfer. At the time of
39     ///  any transfer, the approved address for that NFT (if any) is reset to none.
40     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
41 
42     /// @dev This emits when the approved address for an NFT is changed or
43     ///  reaffirmed. The zero address indicates there is no approved address.
44     ///  When a Transfer event emits, this also indicates that the approved
45     ///  address for that NFT (if any) is reset to none.
46     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
47 
48     /// @dev This emits when an operator is enabled or disabled for an owner.
49     ///  The operator can manage all NFTs of the owner.
50     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
51 
52     /// @notice Count all NFTs assigned to an owner
53     /// @dev NFTs assigned to the zero address are considered invalid, and this
54     ///  function throws for queries about the zero address.
55     /// @param _owner An address for whom to query the balance
56     /// @return The number of NFTs owned by `_owner`, possibly zero
57     function balanceOf(address _owner) external view returns (uint256);
58 
59     /// @notice Find the owner of an NFT
60     /// @dev NFTs assigned to zero address are considered invalid, and queries
61     ///  about them do throw.
62     /// @param _tokenId The identifier for an NFT
63     /// @return The address of the owner of the NFT
64     function ownerOf(uint256 _tokenId) external view returns (address);
65 
66     /// @notice Transfers the ownership of an NFT from one address to another address
67     /// @dev Throws unless `msg.sender` is the current owner, an authorized
68     ///  operator, or the approved address for this NFT. Throws if `_from` is
69     ///  not the current owner. Throws if `_to` is the zero address. Throws if
70     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
71     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
72     ///  `onERC721Received` on `_to` and throws if the return value is not
73     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
74     /// @param _from The current owner of the NFT
75     /// @param _to The new owner
76     /// @param _tokenId The NFT to transfer
77     /// @param data Additional data with no specified format, sent in call to `_to`
78     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
79 
80     /// @notice Transfers the ownership of an NFT from one address to another address
81     /// @dev This works identically to the other function with an extra data parameter,
82     ///  except this function just sets data to ""
83     /// @param _from The current owner of the NFT
84     /// @param _to The new owner
85     /// @param _tokenId The NFT to transfer
86     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
87 
88     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
89     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
90     ///  THEY MAY BE PERMANENTLY LOST
91     /// @dev Throws unless `msg.sender` is the current owner, an authorized
92     ///  operator, or the approved address for this NFT. Throws if `_from` is
93     ///  not the current owner. Throws if `_to` is the zero address. Throws if
94     ///  `_tokenId` is not a valid NFT.
95     /// @param _from The current owner of the NFT
96     /// @param _to The new owner
97     /// @param _tokenId The NFT to transfer
98     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
99 
100     /// @notice Set or reaffirm the approved address for an NFT
101     /// @dev The zero address indicates there is no approved address.
102     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
103     ///  operator of the current owner.
104     /// @param _approved The new approved NFT controller
105     /// @param _tokenId The NFT to approve
106     function approve(address _approved, uint256 _tokenId) external payable;
107 
108     /// @notice Enable or disable approval for a third party ("operator") to manage
109     ///  all of `msg.sender`'s assets.
110     /// @dev Emits the ApprovalForAll event. The contract MUST allow
111     ///  multiple operators per owner.
112     /// @param _operator Address to add to the set of authorized operators.
113     /// @param _approved True if the operator is approved, false to revoke approval
114     function setApprovalForAll(address _operator, bool _approved) external;
115 
116     /// @notice Get the approved address for a single NFT
117     /// @dev Throws if `_tokenId` is not a valid NFT
118     /// @param _tokenId The NFT to find the approved address for
119     /// @return The approved address for this NFT, or the zero address if there is none
120     function getApproved(uint256 _tokenId) external view returns (address);
121 
122     /// @notice Query if an address is an authorized operator for another address
123     /// @param _owner The address that owns the NFTs
124     /// @param _operator The address that acts on behalf of the owner
125     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
126     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
127 }
128 
129 /**
130  * @title ERC721 token receiver interface
131  * @dev Interface for any contract that wants to support safeTransfers
132  *  from ERC721 asset contracts.
133  */
134 contract ERC721Receiver {
135     /**
136     * @notice Handle the receipt of an NFT
137     * @dev The ERC721 smart contract calls this function on the recipient
138     *  after a `safetransfer`. This function MAY throw to revert and reject the
139     *  transfer. This function MUST use 50,000 gas or less. Return of other
140     *  than the magic value MUST result in the transaction being reverted.
141     *  Note: the contract address is always the message sender.
142     * @param _from The sending address
143     * @param _tokenId The NFT identifier which is being transfered
144     * @param _data Additional data with no specified format
145     * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
146     */
147     function onERC721Received(address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
148 }
149 
150 /**
151  * Owned contract
152  */
153 contract Owned {
154     address public owner;
155     address public newOwner;
156 
157     event OwnershipTransferred(address indexed from, address indexed to);
158 
159     /**
160      * Constructor
161      */
162     constructor() public {
163         owner = msg.sender;
164     }
165 
166     /**
167      * @dev Only the owner of contract
168      */ 
169     modifier onlyOwner {
170         require(msg.sender == owner);
171         _;
172     }
173     
174     /**
175      * @dev transfer the ownership to other
176      *      - Only the owner can operate
177      */ 
178     function transferOwnership(address _newOwner) public onlyOwner {
179         newOwner = _newOwner;
180     }
181 
182     /** 
183      * @dev Accept the ownership from last owner
184      */ 
185     function acceptOwnership() public {
186         require(msg.sender == newOwner);
187         emit OwnershipTransferred(owner, newOwner);
188         owner = newOwner;
189         newOwner = address(0);
190     }
191 }
192 
193 contract TRNData is Owned {
194     TripioRoomNightData dataSource;
195     /**
196      * Only the valid vendor and the vendor is valid
197      */ 
198     modifier onlyVendor {
199         uint256 vendorId = dataSource.vendorIds(msg.sender);
200         require(vendorId > 0);
201         (,,,bool valid) = dataSource.getVendor(vendorId);
202         require(valid);
203         _;
204     }
205 
206     /**
207      * The vendor is valid
208      */
209     modifier vendorValid(address _vendor) {
210         uint256 vendorId = dataSource.vendorIds(_vendor);
211         require(vendorId > 0);
212         (,,,bool valid) = dataSource.getVendor(vendorId);
213         require(valid);
214         _;
215     }
216 
217     /**
218      * The vendorId is valid
219      */
220     modifier vendorIdValid(uint256 _vendorId) {
221         (,,,bool valid) = dataSource.getVendor(_vendorId);
222         require(valid);
223         _;
224     }
225 
226     /**
227      * Rate plan exist.
228      */
229     modifier ratePlanExist(uint256 _vendorId, uint256 _rpid) {
230         (,,,bool valid) = dataSource.getVendor(_vendorId);
231         require(valid);
232         require(dataSource.ratePlanIsExist(_vendorId, _rpid));
233         _;
234     }
235     
236     /**
237      * Token is valid
238      */
239     modifier validToken(uint256 _tokenId) {
240         require(_tokenId > 0);
241         require(dataSource.roomNightIndexToOwner(_tokenId) != address(0));
242         _;
243     }
244 
245     /**
246      * Tokens are valid
247      */
248     modifier validTokenInBatch(uint256[] _tokenIds) {
249         for(uint256 i = 0; i < _tokenIds.length; i++) {
250             require(_tokenIds[i] > 0);
251             require(dataSource.roomNightIndexToOwner(_tokenIds[i]) != address(0));
252         }
253         _;
254     }
255 
256     /**
257      * Whether the `_tokenId` can be transfered
258      */
259     modifier canTransfer(uint256 _tokenId) {
260         address owner = dataSource.roomNightIndexToOwner(_tokenId);
261         bool isOwner = (msg.sender == owner);
262         bool isApproval = (msg.sender == dataSource.roomNightApprovals(_tokenId));
263         bool isOperator = (dataSource.operatorApprovals(owner, msg.sender));
264         require(isOwner || isApproval || isOperator);
265         _;
266     }
267 
268     /**
269      * Whether the `_tokenIds` can be transfered
270      */
271     modifier canTransferInBatch(uint256[] _tokenIds) {
272         for(uint256 i = 0; i < _tokenIds.length; i++) {
273             address owner = dataSource.roomNightIndexToOwner(_tokenIds[i]);
274             bool isOwner = (msg.sender == owner);
275             bool isApproval = (msg.sender == dataSource.roomNightApprovals(_tokenIds[i]));
276             bool isOperator = (dataSource.operatorApprovals(owner, msg.sender));
277             require(isOwner || isApproval || isOperator);
278         }
279         _;
280     }
281 
282 
283     /**
284      * Whether the `_tokenId` can be operated by `msg.sender`
285      */
286     modifier canOperate(uint256 _tokenId) {
287         address owner = dataSource.roomNightIndexToOwner(_tokenId);
288         bool isOwner = (msg.sender == owner);
289         bool isOperator = (dataSource.operatorApprovals(owner, msg.sender));
290         require(isOwner || isOperator);
291         _;
292     }
293 
294     /**
295      * Whether the `_date` is valid(no hours, no seconds)
296      */
297     modifier validDate(uint256 _date) {
298         require(_date > 0);
299         require(dateIsLegal(_date));
300         _;
301     }
302 
303     /**
304      * Whether the `_dates` are valid(no hours, no seconds)
305      */
306     modifier validDates(uint256[] _dates) {
307         for(uint256 i = 0;i < _dates.length; i++) {
308             require(_dates[i] > 0);
309             require(dateIsLegal(_dates[i]));
310         }
311         _;
312     }
313 
314     function dateIsLegal(uint256 _date) pure private returns(bool) {
315         uint256 year = _date / 10000;
316         uint256 mon = _date / 100 - year * 100;
317         uint256 day = _date - mon * 100 - year * 10000;
318         
319         if(year < 1970 || mon <= 0 || mon > 12 || day <= 0 || day > 31)
320             return false;
321 
322         if(4 == mon || 6 == mon || 9 == mon || 11 == mon){
323             if (day == 31) {
324                 return false;
325             }
326         }
327         if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
328             if(2 == mon && day > 29) {
329                 return false;
330             }
331         }else {
332             if(2 == mon && day > 28){
333                 return false;
334             }
335         }
336         return true;
337     }
338     /**
339      * Constructor
340      */
341     constructor() public {
342 
343     }
344 }
345 
346 contract TRNOwners is TRNData {
347     /**
348      * Constructor
349      */
350     constructor() public {
351 
352     }
353 
354     /**
355      * Add room night token to `_owner`'s account(from the header)
356      */
357     function _pushRoomNight(address _owner, uint256 _rnid, bool _isVendor) internal {
358         require(_owner != address(0));
359         require(_rnid != 0);
360         if (_isVendor) {
361             dataSource.pushOrderOfVendor(_owner, _rnid, false);
362         } else {
363             dataSource.pushOrderOfOwner(_owner, _rnid, false);
364         }
365     }
366 
367     /**
368      * Remove room night token from `_owner`'s account
369      */
370     function _removeRoomNight(address _owner, uint256 _rnid) internal {
371         dataSource.removeOrderOfOwner(_owner, _rnid);
372     }
373 
374     /**
375      * @dev Returns all the room nights of the `msg.sender`(Customer)
376      * @param _from The begin of room nights Id
377      * @param _limit The total room nights 
378      * @param _isVendor Is Vendor
379      * @return Room nights of the `msg.sender` and the next vernier
380      */
381     function roomNightsOfOwner(uint256 _from, uint256 _limit, bool _isVendor) 
382         external
383         view 
384         returns(uint256[], uint256) {
385         if(_isVendor) {
386             return dataSource.getOrdersOfVendor(msg.sender, _from, _limit, true);
387         }else {
388             return dataSource.getOrdersOfOwner(msg.sender, _from, _limit, true);
389         }
390     }
391 
392     /**
393      * @dev Returns the room night infomation in detail
394      * @param _rnid Room night id
395      * @return Room night infomation in detail
396      */
397     function roomNight(uint256 _rnid) 
398         external 
399         view 
400         returns(uint256 _vendorId,uint256 _rpid,uint256 _token,uint256 _price,uint256 _timestamp,uint256 _date,bytes32 _ipfs, string _name) {
401         (_vendorId, _rpid, _token, _price, _timestamp, _date, _ipfs) = dataSource.roomnights(_rnid);
402         (_name,,) = dataSource.getRatePlan(_vendorId, _rpid);
403     }
404 }
405 
406 library IPFSLib {
407     bytes constant ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
408     bytes constant HEX = "0123456789abcdef";
409 
410     /**
411      * @dev Base58 encoding
412      * @param _source Bytes data
413      * @return Encoded bytes data
414      */
415     function base58Address(bytes _source) internal pure returns (bytes) {
416         uint8[] memory digits = new uint8[](_source.length * 136/100 + 1);
417         digits[0] = 0;
418         uint8 digitlength = 1;
419         for (uint i = 0; i < _source.length; ++i) {
420             uint carry = uint8(_source[i]);
421             for (uint j = 0; j<digitlength; ++j) {
422                 carry += uint(digits[j]) * 256;
423                 digits[j] = uint8(carry % 58);
424                 carry = carry / 58;
425             }
426             
427             while (carry > 0) {
428                 digits[digitlength] = uint8(carry % 58);
429                 digitlength++;
430                 carry = carry / 58;
431             }
432         }
433         return toAlphabet(reverse(truncate(digits, digitlength)));
434     }
435 
436     /**
437      * @dev Hex encoding, convert bytes32 data to hex string
438      * @param _source Bytes32 data
439      * @return hex string bytes
440      */
441     function hexAddress(bytes32 _source) internal pure returns(bytes) {
442         uint256 value = uint256(_source);
443         bytes memory result = "0000000000000000000000000000000000000000000000000000000000000000";
444         uint8 index = 0;
445         while(value > 0) {
446             result[index] = HEX[value & 0xf];
447             index++;
448             value = value>>4;
449         }
450         bytes memory ipfsBytes = reverseBytes(result);
451         return ipfsBytes;
452     }
453 
454     /**
455      * @dev Truncate `_array` by `_length`
456      * @param _array The source array
457      * @param _length The target length of the `_array`
458      * @return The truncated array 
459      */
460     function truncate(uint8[] _array, uint8 _length) internal pure returns (uint8[]) {
461         uint8[] memory output = new uint8[](_length);
462         for (uint i = 0; i < _length; i++) {
463             output[i] = _array[i];
464         }
465         return output;
466     }
467     
468     /**
469      * @dev Reverse `_input` array 
470      * @param _input The source array 
471      * @return The reversed array 
472      */
473     function reverse(uint8[] _input) internal pure returns (uint8[]) {
474         uint8[] memory output = new uint8[](_input.length);
475         for (uint i = 0; i < _input.length; i++) {
476             output[i] = _input[_input.length - 1 - i];
477         }
478         return output;
479     }
480 
481     /**
482      * @dev Reverse `_input` bytes
483      * @param _input The source bytes
484      * @return The reversed bytes
485      */
486     function reverseBytes(bytes _input) private pure returns (bytes) {
487         bytes memory output = new bytes(_input.length);
488         for (uint8 i = 0; i < _input.length; i++) {
489             output[i] = _input[_input.length-1-i];
490         }
491         return output;
492     }
493     
494     /**
495      * @dev Convert the indices to alphabet
496      * @param _indices The indices of alphabet
497      * @return The alphabets
498      */
499     function toAlphabet(uint8[] _indices) internal pure returns (bytes) {
500         bytes memory output = new bytes(_indices.length);
501         for (uint i = 0; i < _indices.length; i++) {
502             output[i] = ALPHABET[_indices[i]];
503         }
504         return output;
505     }
506 
507     /**
508      * @dev Convert bytes32 to bytes
509      * @param _input The source bytes32
510      * @return The bytes
511      */
512     function toBytes(bytes32 _input) internal pure returns (bytes) {
513         bytes memory output = new bytes(32);
514         for (uint8 i = 0; i < 32; i++) {
515             output[i] = _input[i];
516         }
517         return output;
518     }
519 
520     /**
521      * @dev Concat two bytes to one
522      * @param _byteArray The first bytes
523      * @param _byteArray2 The second bytes
524      * @return The concated bytes
525      */
526     function concat(bytes _byteArray, bytes _byteArray2) internal pure returns (bytes) {
527         bytes memory returnArray = new bytes(_byteArray.length + _byteArray2.length);
528         for (uint16 i = 0; i < _byteArray.length; i++) {
529             returnArray[i] = _byteArray[i];
530         }
531         for (i; i < (_byteArray.length + _byteArray2.length); i++) {
532             returnArray[i] = _byteArray2[i - _byteArray.length];
533         }
534         return returnArray;
535     }
536 }
537 
538 contract TRNAsset is TRNData, ERC721Metadata {
539     using IPFSLib for bytes;
540     using IPFSLib for bytes32;
541 
542     /**
543      * Constructor
544      */
545     constructor() public {
546         
547     }
548 
549     /**
550      * @dev Descriptive name for Tripio's Room Night Token in this contract
551      * @return The name of the contract
552      */
553     function name() external pure returns (string _name) {
554         return "Tripio Room Night";
555     }
556 
557     /**
558      * @dev Abbreviated name for Tripio's Room Night Token in this contract
559      * @return The simple name of the contract
560      */
561     function symbol() external pure returns (string _symbol) {
562         return "TRN";
563     }
564 
565     /**
566      * @dev If `_tokenId` is not valid trows an exception otherwise return a URI which point to a JSON file like:
567      *      {
568      *       "name": "Identifies the asset to which this NFT represents",
569      *       "description": "Describes the asset to which this NFT represents",
570      *       "image": "A URI pointing to a resource with mime type image/* representing the asset to which this NFT represents. Consider making any images at a width between 320 and 1080 pixels and aspect ratio between 1.91:1 and 4:5 inclusive."
571      *      }
572      * @param _tokenId The RoomNight digital token
573      * @return The digital token asset uri
574      */
575     function tokenURI(uint256 _tokenId) 
576         external 
577         view 
578         validToken(_tokenId) 
579         returns (string) { 
580         bytes memory prefix = new bytes(2);
581         prefix[0] = 0x12;
582         prefix[1] = 0x20;
583         (,,,,,,bytes32 ipfs) = dataSource.roomnights(_tokenId);
584         bytes memory value = prefix.concat(ipfs.toBytes());
585         bytes memory ipfsBytes = value.base58Address();
586         bytes memory tokenBaseURIBytes = bytes(dataSource.tokenBaseURI());
587         return string(tokenBaseURIBytes.concat(ipfsBytes));
588     }
589 }
590 
591 contract TRNOwnership is TRNOwners, ERC721 {
592     /**
593      * Constructor
594      */
595     constructor() public {
596 
597     }
598 
599     /**
600      * This emits when ownership of any TRN changes by any mechanism.
601      */
602     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
603 
604     /**
605      * This emits when the approved address for an RTN is changed or reaffirmed.
606      */
607     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
608 
609     /**
610      * This emits when an operator is enabled or disabled for an owner.
611      * The operator can manage all RTNs of the owner.
612      */
613     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
614 
615     /**
616      * @dev Transfer the `_tokenId` to `_to` directly
617      * @param _tokenId The room night token
618      * @param _to The target owner
619      */
620     function _transfer(uint256 _tokenId, address _to) private {
621         // Find the FROM address
622         address from = dataSource.roomNightIndexToOwner(_tokenId);
623 
624         // Remove room night from the `from`
625         _removeRoomNight(from, _tokenId);
626 
627         // Add room night to the `_to`
628         _pushRoomNight(_to, _tokenId, false);
629 
630         // Change the owner of `_tokenId`
631         // Remove approval of `_tokenId`
632         dataSource.transferTokenTo(_tokenId, _to);
633 
634         // Emit Transfer event
635         emit Transfer(from, _to, _tokenId);
636     }
637 
638     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data)
639         private
640         validToken(_tokenId)
641         canTransfer(_tokenId) {
642         // The token's owner is equal to `_from`
643         address owner = dataSource.roomNightIndexToOwner(_tokenId);
644         require(owner == _from);
645 
646         // Avoid `_to` is equal to address(0)
647         require(_to != address(0));
648 
649         _transfer(_tokenId, _to);
650 
651         uint256 codeSize;
652         assembly { codeSize := extcodesize(_to) }
653         if (codeSize == 0) {
654             return;
655         }
656         bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
657         require (retval == dataSource.ERC721_RECEIVED());
658     }
659 
660     /**
661      * @dev Count all TRNs assigned to an owner.
662      *      Throw when `_owner` is equal to address(0)
663      * @param _owner An address for whom to query the balance.
664      * @return The number of TRNs owned by `_owner`.
665      */
666     function balanceOf(address _owner) external view returns (uint256) {
667         require(_owner != address(0));
668         return dataSource.balanceOf(_owner);
669     }
670 
671     /**
672      * @dev Find the owner of an TRN
673      *      Throw unless `_tokenId` more than zero
674      * @param _tokenId The identifier for an TRN
675      * @return The address of the owner of the TRN
676      */
677     function ownerOf(uint256 _tokenId) external view returns (address) {
678         require(_tokenId > 0);
679         return dataSource.roomNightIndexToOwner(_tokenId);
680     }
681 
682     /**
683      * @dev Transfers the ownership of an TRN from one address to another address.
684      *      Throws unless `msg.sender` is the current owner or an approved address for this TRN.
685      *      Throws if `_tokenId` is not a valid TRN. When transfer is complete, this function checks if 
686      *      `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received` on `_to` and 
687      * throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
688      * @param _from The current owner of the TRN
689      * @param _to The new owner
690      * @param _tokenId The TRN to transfer
691      * @param _data Additional data with no specified format, sent in call to `_to`
692      */
693     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external payable {
694         _safeTransferFrom(_from, _to, _tokenId, _data);
695     }
696 
697     /**
698      * @dev Same like safeTransferFrom with an extra data parameter, except this function just sets data to ""(empty)
699      * @param _from The current owner of the TRN
700      * @param _to The new owner
701      * @param _tokenId The TRN to transfer
702      */
703     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
704         _safeTransferFrom(_from, _to, _tokenId, "");
705     }
706 
707     /**
708      * @dev Transfers the ownership of an TRN from one address to another address.
709      *      Throws unless `msg.sender` is the current owner or an approved address for this TRN.
710      *      Throws if `_tokenId` is not a valid TRN.
711      * @param _from The current owner of the TRN
712      * @param _to The new owner
713      * @param _tokenId The TRN to transfer
714      */
715     function transferFrom(address _from, address _to, uint256 _tokenId) 
716         external 
717         payable
718         validToken(_tokenId)
719         canTransfer(_tokenId) {
720         // The token's owner is equal to `_from`
721         address owner = dataSource.roomNightIndexToOwner(_tokenId);
722         require(owner == _from);
723 
724         // Avoid `_to` is equal to address(0)
725         require(_to != address(0));
726 
727         _transfer(_tokenId, _to);
728     }
729 
730     /**
731      * @dev Transfers the ownership of TRNs from one address to another address.
732      *      Throws unless `msg.sender` is the current owner or an approved address for this TRN.
733      *      Throws if `_tokenIds` are not valid TRNs.
734      * @param _from The current owner of the TRN
735      * @param _to The new owner
736      * @param _tokenIds The TRNs to transfer
737      */
738     function transferFromInBatch(address _from, address _to, uint256[] _tokenIds) 
739         external
740         payable
741         validTokenInBatch(_tokenIds)
742         canTransferInBatch(_tokenIds) {
743         for(uint256 i = 0; i < _tokenIds.length; i++) {
744             // The token's owner is equal to `_from`
745             address owner = dataSource.roomNightIndexToOwner(_tokenIds[i]);
746             require(owner == _from);
747 
748             // Avoid `_to` is equal to address(0)
749             require(_to != address(0));
750 
751             _transfer(_tokenIds[i], _to);
752         }
753     }
754 
755     /**
756      * @dev Set or reaffirm the approved address for an TRN.
757      *      Throws unless `msg.sender` is the current TRN owner, or an authorized
758      * @param _approved The new approved TRN controller
759      * @param _tokenId The TRN to approve
760      */
761     function approve(address _approved, uint256 _tokenId) 
762         external 
763         payable 
764         validToken(_tokenId)
765         canOperate(_tokenId) {
766         address owner = dataSource.roomNightIndexToOwner(_tokenId);
767         
768         dataSource.approveTokenTo(_tokenId, _approved);
769         emit Approval(owner, _approved, _tokenId);
770     }
771 
772     /**
773      * @dev Enable or disable approval for a third party ("operator") to manage 
774      *      all of `msg.sender`'s assets.
775      *      Emits the ApprovalForAll event. 
776      * @param _operator Address to add to the set of authorized operators.
777      * @param _approved True if the operator is approved, false to revoke approval.
778      */
779     function setApprovalForAll(address _operator, bool _approved) external {
780         require(_operator != address(0));
781         dataSource.approveOperatorTo(_operator, msg.sender, _approved);
782         emit ApprovalForAll(msg.sender, _operator, _approved);
783     }
784 
785     /**
786      * @dev Get the approved address for a single TRN.
787      *      Throws if `_tokenId` is not a valid TRN.
788      * @param _tokenId The TRN to find the approved address for
789      * @return The approved address for this TRN, or the zero address if there is none
790      */
791     function getApproved(uint256 _tokenId) 
792         external 
793         view 
794         validToken(_tokenId)
795         returns (address) {
796         return dataSource.roomNightApprovals(_tokenId);
797     }
798 
799     /**
800      * @dev Query if an address is an authorized operator for another address.
801      * @param _owner The address that owns The TRNs
802      * @param _operator The address that acts on behalf of the owner
803      * @return True if `_operator` is an approved operator for `_owner`, false otherwise
804      */
805     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
806         return dataSource.operatorApprovals(_owner, _operator);
807     }
808 }
809 
810 
811 contract TRNSupportsInterface is TRNData, ERC165 {
812     /**
813      * Constructor
814      */
815     constructor() public {
816 
817     }
818 
819     /**
820      * @dev Query if a contract implements an interface
821      * @param interfaceID The interface identifier, as specified in ERC-165
822      * @return true if the contract implements `interfaceID` 
823      * and `interfaceID` is not 0xffffffff, false otherwise
824      */
825     function supportsInterface(bytes4 interfaceID) 
826         external 
827         view 
828         returns (bool) {
829         return ((interfaceID == dataSource.interfaceSignature_ERC165()) ||
830         (interfaceID == dataSource.interfaceSignature_ERC721Metadata()) ||
831         (interfaceID == dataSource.interfaceSignature_ERC721())) &&
832         (interfaceID != 0xffffffff);
833     }
834 }
835 /**
836  * This utility library was forked from https://github.com/o0ragman0o/LibCLL
837  */
838 library LinkedListLib {
839 
840     uint256 constant NULL = 0;
841     uint256 constant HEAD = 0;
842     bool constant PREV = false;
843     bool constant NEXT = true;
844 
845     struct LinkedList {
846         mapping (uint256 => mapping (bool => uint256)) list;
847         uint256 length;
848         uint256 index;
849     }
850 
851     /**
852      * @dev returns true if the list exists
853      * @param self stored linked list from contract
854      */
855     function listExists(LinkedList storage self)
856         internal
857         view returns (bool) {
858         return self.length > 0;
859     }
860 
861     /**
862      * @dev returns true if the node exists
863      * @param self stored linked list from contract
864      * @param _node a node to search for
865      */
866     function nodeExists(LinkedList storage self, uint256 _node)
867         internal
868         view returns (bool) {
869         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
870             if (self.list[HEAD][NEXT] == _node) {
871                 return true;
872             } else {
873                 return false;
874             }
875         } else {
876             return true;
877         }
878     }
879 
880     /**
881      * @dev Returns the number of elements in the list
882      * @param self stored linked list from contract
883      */ 
884     function sizeOf(LinkedList storage self) 
885         internal 
886         view 
887         returns (uint256 numElements) {
888         return self.length;
889     }
890 
891     /**
892      * @dev Returns the links of a node as a tuple
893      * @param self stored linked list from contract
894      * @param _node id of the node to get
895      */
896     function getNode(LinkedList storage self, uint256 _node)
897         public 
898         view 
899         returns (bool, uint256, uint256) {
900         if (!nodeExists(self,_node)) {
901             return (false, 0, 0);
902         } else {
903             return (true, self.list[_node][PREV], self.list[_node][NEXT]);
904         }
905     }
906 
907     /**
908      * @dev Returns the link of a node `_node` in direction `_direction`.
909      * @param self stored linked list from contract
910      * @param _node id of the node to step from
911      * @param _direction direction to step in
912      */
913     function getAdjacent(LinkedList storage self, uint256 _node, bool _direction)
914         public 
915         view 
916         returns (bool, uint256) {
917         if (!nodeExists(self,_node)) {
918             return (false,0);
919         } else {
920             return (true,self.list[_node][_direction]);
921         }
922     }
923 
924     /**
925      * @dev Can be used before `insert` to build an ordered list
926      * @param self stored linked list from contract
927      * @param _node an existing node to search from, e.g. HEAD.
928      * @param _value value to seek
929      * @param _direction direction to seek in
930      * @return next first node beyond '_node' in direction `_direction`
931      */
932     function getSortedSpot(LinkedList storage self, uint256 _node, uint256 _value, bool _direction)
933         public 
934         view 
935         returns (uint256) {
936         if (sizeOf(self) == 0) { 
937             return 0; 
938         }
939         require((_node == 0) || nodeExists(self,_node));
940         bool exists;
941         uint256 next;
942         (exists,next) = getAdjacent(self, _node, _direction);
943         while  ((next != 0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
944         return next;
945     }
946 
947     /**
948      * @dev Creates a bidirectional link between two nodes on direction `_direction`
949      * @param self stored linked list from contract
950      * @param _node first node for linking
951      * @param _link  node to link to in the _direction
952      */
953     function createLink(LinkedList storage self, uint256 _node, uint256 _link, bool _direction) 
954         private {
955         self.list[_link][!_direction] = _node;
956         self.list[_node][_direction] = _link;
957     }
958 
959     /**
960      * @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
961      * @param self stored linked list from contract
962      * @param _node existing node
963      * @param _new  new node to insert
964      * @param _direction direction to insert node in
965      */
966     function insert(LinkedList storage self, uint256 _node, uint256 _new, bool _direction) 
967         internal 
968         returns (bool) {
969         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
970             uint256 c = self.list[_node][_direction];
971             createLink(self, _node, _new, _direction);
972             createLink(self, _new, c, _direction);
973             self.length++;
974             return true;
975         } else {
976             return false;
977         }
978     }
979 
980     /**
981      * @dev removes an entry from the linked list
982      * @param self stored linked list from contract
983      * @param _node node to remove from the list
984      */
985     function remove(LinkedList storage self, uint256 _node) 
986         internal 
987         returns (uint256) {
988         if ((_node == NULL) || (!nodeExists(self,_node))) { 
989             return 0; 
990         }
991         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
992         delete self.list[_node][PREV];
993         delete self.list[_node][NEXT];
994         self.length--;
995         return _node;
996     }
997 
998     /**
999      * @dev pushes an enrty to the head of the linked list
1000      * @param self stored linked list from contract
1001      * @param _index The node Id
1002      * @param _direction push to the head (NEXT) or tail (PREV)
1003      */
1004     function add(LinkedList storage self, uint256 _index, bool _direction) 
1005         internal 
1006         returns (uint256) {
1007         insert(self, HEAD, _index, _direction);
1008         return self.index;
1009     }
1010 
1011     /**
1012      * @dev pushes an enrty to the head of the linked list
1013      * @param self stored linked list from contract
1014      * @param _direction push to the head (NEXT) or tail (PREV)
1015      */
1016     function push(LinkedList storage self, bool _direction) 
1017         internal 
1018         returns (uint256) {
1019         self.index++;
1020         insert(self, HEAD, self.index, _direction);
1021         return self.index;
1022     }
1023 
1024     /**
1025      * @dev pops the first entry from the linked list
1026      * @param self stored linked list from contract
1027      * @param _direction pop from the head (NEXT) or the tail (PREV)
1028      */
1029     function pop(LinkedList storage self, bool _direction) 
1030         internal 
1031         returns (uint256) {
1032         bool exists;
1033         uint256 adj;
1034         (exists,adj) = getAdjacent(self, HEAD, _direction);
1035         return remove(self, adj);
1036     }
1037 }
1038 
1039 contract TripioToken {
1040     string public name;
1041     string public symbol;
1042     uint8 public decimals;
1043     function transfer(address _to, uint256 _value) public returns (bool);
1044     function balanceOf(address who) public view returns (uint256);
1045     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
1046 }
1047 
1048 contract TripioRoomNightData is Owned {
1049     using LinkedListLib for LinkedListLib.LinkedList;
1050     // Interface signature of erc165.
1051     // bytes4(keccak256("supportsInterface(bytes4)"))
1052     bytes4 constant public interfaceSignature_ERC165 = 0x01ffc9a7;
1053 
1054     // Interface signature of erc721 metadata.
1055     // bytes4(keccak256("name()")) ^ bytes4(keccak256("symbol()")) ^ bytes4(keccak256("tokenURI(uint256)"));
1056     bytes4 constant public interfaceSignature_ERC721Metadata = 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd;
1057         
1058     // Interface signature of erc721.
1059     // bytes4(keccak256("balanceOf(address)")) ^
1060     // bytes4(keccak256("ownerOf(uint256)")) ^
1061     // bytes4(keccak256("safeTransferFrom(address,address,uint256,bytes)")) ^
1062     // bytes4(keccak256("safeTransferFrom(address,address,uint256)")) ^
1063     // bytes4(keccak256("transferFrom(address,address,uint256)")) ^
1064     // bytes4(keccak256("approve(address,uint256)")) ^
1065     // bytes4(keccak256("setApprovalForAll(address,bool)")) ^
1066     // bytes4(keccak256("getApproved(uint256)")) ^
1067     // bytes4(keccak256("isApprovedForAll(address,address)"));
1068     bytes4 constant public interfaceSignature_ERC721 = 0x70a08231 ^ 0x6352211e ^ 0xb88d4fde ^ 0x42842e0e ^ 0x23b872dd ^ 0x095ea7b3 ^ 0xa22cb465 ^ 0x081812fc ^ 0xe985e9c5;
1069 
1070     // Base URI of token asset
1071     string public tokenBaseURI;
1072 
1073     // Authorized contracts
1074     struct AuthorizedContract {
1075         string name;
1076         address acontract;
1077     }
1078     mapping (address=>uint256) public authorizedContractIds;
1079     mapping (uint256 => AuthorizedContract) public authorizedContracts;
1080     LinkedListLib.LinkedList public authorizedContractList = LinkedListLib.LinkedList(0, 0);
1081 
1082     // Rate plan prices
1083     struct Price {
1084         uint16 inventory;       // Rate plan inventory
1085         bool init;              // Whether the price is initied
1086         mapping (uint256 => uint256) tokens;
1087     }
1088 
1089     // Vendor hotel RPs
1090     struct RatePlan {
1091         string name;            // Name of rate plan.
1092         uint256 timestamp;      // Create timestamp.
1093         bytes32 ipfs;           // The address of rate plan detail on IPFS.
1094         Price basePrice;        // The base price of rate plan
1095         mapping (uint256 => Price) prices;   // date -> Price
1096     }
1097 
1098     // Vendors
1099     struct Vendor {
1100         string name;            // Name of vendor.
1101         address vendor;         // Address of vendor.
1102         uint256 timestamp;      // Create timestamp.
1103         bool valid;             // Whether the vendor is valid(default is true)
1104         LinkedListLib.LinkedList ratePlanList;
1105         mapping (uint256=>RatePlan) ratePlans;
1106     }
1107     mapping (address => uint256) public vendorIds;
1108     mapping (uint256 => Vendor) vendors;
1109     LinkedListLib.LinkedList public vendorList = LinkedListLib.LinkedList(0, 0);
1110 
1111     // Supported digital currencies
1112     mapping (uint256 => address) public tokenIndexToAddress;
1113     LinkedListLib.LinkedList public tokenList = LinkedListLib.LinkedList(0, 0);
1114 
1115     // RoomNight tokens
1116     struct RoomNight {
1117         uint256 vendorId;
1118         uint256 rpid;
1119         uint256 token;          // The digital currency token 
1120         uint256 price;          // The digital currency price
1121         uint256 timestamp;      // Create timestamp.
1122         uint256 date;           // The checkin date
1123         bytes32 ipfs;           // The address of rate plan detail on IPFS.
1124     }
1125     RoomNight[] public roomnights;
1126     // rnid -> owner
1127     mapping (uint256 => address) public roomNightIndexToOwner;
1128 
1129     // Owner Account
1130     mapping (address => LinkedListLib.LinkedList) public roomNightOwners;
1131 
1132     // Vendor Account
1133     mapping (address => LinkedListLib.LinkedList) public roomNightVendors;
1134 
1135     // The authorized address for each TRN
1136     mapping (uint256 => address) public roomNightApprovals;
1137 
1138     // The authorized operators for each address
1139     mapping (address => mapping (address => bool)) public operatorApprovals;
1140 
1141     // The applications of room night redund
1142     mapping (address => mapping (uint256 => bool)) public refundApplications;
1143 
1144     // The signature of `onERC721Received(address,uint256,bytes)`
1145     // bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
1146     bytes4 constant public ERC721_RECEIVED = 0xf0b9e5ba;
1147 
1148     /**
1149      * This emits when contract authorized
1150      */
1151     event ContractAuthorized(address _contract);
1152 
1153     /**
1154      * This emits when contract deauthorized
1155      */
1156     event ContractDeauthorized(address _contract);
1157 
1158     /**
1159      * The contract is valid
1160      */
1161     modifier authorizedContractValid(address _contract) {
1162         require(authorizedContractIds[_contract] > 0);
1163         _;
1164     }
1165 
1166     /**
1167      * The contract is valid
1168      */
1169     modifier authorizedContractIdValid(uint256 _cid) {
1170         require(authorizedContractList.nodeExists(_cid));
1171         _;
1172     }
1173 
1174     /**
1175      * Only the owner or authorized contract is valid
1176      */
1177     modifier onlyOwnerOrAuthorizedContract {
1178         require(msg.sender == owner || authorizedContractIds[msg.sender] > 0);
1179         _;
1180     }
1181 
1182     /**
1183      * Constructor
1184      */
1185     constructor() public {
1186         // Add one invalid RoomNight, avoid subscript 0
1187         roomnights.push(RoomNight(0, 0, 0, 0, 0, 0, 0));
1188     }
1189 
1190     /**
1191      * @dev Returns the node list and next node as a tuple
1192      * @param self stored linked list from contract
1193      * @param _node the begin id of the node to get
1194      * @param _limit the total nodes of one page
1195      * @param _direction direction to step in
1196      */
1197     function getNodes(LinkedListLib.LinkedList storage self, uint256 _node, uint256 _limit, bool _direction) 
1198         private
1199         view 
1200         returns (uint256[], uint256) {
1201         bool exists;
1202         uint256 i = 0;
1203         uint256 ei = 0;
1204         uint256 index = 0;
1205         uint256 count = _limit;
1206         if(count > self.length) {
1207             count = self.length;
1208         }
1209         (exists, i) = self.getAdjacent(_node, _direction);
1210         if(!exists || count == 0) {
1211             return (new uint256[](0), 0);
1212         }else {
1213             uint256[] memory temp = new uint256[](count);
1214             if(_node != 0) {
1215                 index++;
1216                 temp[0] = _node;
1217             }
1218             while (i != 0 && index < count) {
1219                 temp[index] = i;
1220                 (exists,i) = self.getAdjacent(i, _direction);
1221                 index++;
1222             }
1223             ei = i;
1224             if(index < count) {
1225                 uint256[] memory result = new uint256[](index);
1226                 for(i = 0; i < index; i++) {
1227                     result[i] = temp[i];
1228                 }
1229                 return (result, ei);
1230             }else {
1231                 return (temp, ei);
1232             }
1233         }
1234     }
1235 
1236     /**
1237      * @dev Authorize `_contract` to execute this contract's funs
1238      * @param _contract The contract address
1239      * @param _name The contract name
1240      */
1241     function authorizeContract(address _contract, string _name) 
1242         public 
1243         onlyOwner 
1244         returns(bool) {
1245         uint256 codeSize;
1246         assembly { codeSize := extcodesize(_contract) }
1247         require(codeSize != 0);
1248         // Not exists
1249         require(authorizedContractIds[_contract] == 0);
1250 
1251         // Add
1252         uint256 id = authorizedContractList.push(false);
1253         authorizedContractIds[_contract] = id;
1254         authorizedContracts[id] = AuthorizedContract(_name, _contract);
1255 
1256         // Event
1257         emit ContractAuthorized(_contract);
1258         return true;
1259     }
1260 
1261     /**
1262      * @dev Deauthorized `_contract` by address
1263      * @param _contract The contract address
1264      */
1265     function deauthorizeContract(address _contract) 
1266         public 
1267         onlyOwner
1268         authorizedContractValid(_contract)
1269         returns(bool) {
1270         uint256 id = authorizedContractIds[_contract];
1271         authorizedContractList.remove(id);
1272         authorizedContractIds[_contract] = 0;
1273         delete authorizedContracts[id];
1274         
1275         // Event 
1276         emit ContractDeauthorized(_contract);
1277         return true;
1278     }
1279 
1280     /**
1281      * @dev Deauthorized `_contract` by contract id
1282      * @param _cid The contract id
1283      */
1284     function deauthorizeContractById(uint256 _cid) 
1285         public
1286         onlyOwner
1287         authorizedContractIdValid(_cid)
1288         returns(bool) {
1289         address acontract = authorizedContracts[_cid].acontract;
1290         authorizedContractList.remove(_cid);
1291         authorizedContractIds[acontract] = 0;
1292         delete authorizedContracts[_cid];
1293 
1294         // Event 
1295         emit ContractDeauthorized(acontract);
1296         return true;
1297     }
1298 
1299     /**
1300      * @dev Get authorize contract ids by page
1301      * @param _from The begin authorize contract id
1302      * @param _limit How many authorize contract ids one page
1303      * @return The authorize contract ids and the next authorize contract id as tuple, the next page not exists when next eq 0
1304      */
1305     function getAuthorizeContractIds(uint256 _from, uint256 _limit) 
1306         external 
1307         view 
1308         returns(uint256[], uint256){
1309         return getNodes(authorizedContractList, _from, _limit, true);
1310     }
1311 
1312     /**
1313      * @dev Get authorize contract by id
1314      * @param _cid Then authorize contract id
1315      * @return The authorize contract info(_name, _acontract)
1316      */
1317     function getAuthorizeContract(uint256 _cid) 
1318         external 
1319         view 
1320         returns(string _name, address _acontract) {
1321         AuthorizedContract memory acontract = authorizedContracts[_cid]; 
1322         _name = acontract.name;
1323         _acontract = acontract.acontract;
1324     }
1325 
1326     /*************************************** GET ***************************************/
1327 
1328     /**
1329      * @dev Get the rate plan by `_vendorId` and `_rpid`
1330      * @param _vendorId The vendor id
1331      * @param _rpid The rate plan id
1332      */
1333     function getRatePlan(uint256 _vendorId, uint256 _rpid) 
1334         public 
1335         view 
1336         returns (string _name, uint256 _timestamp, bytes32 _ipfs) {
1337         _name = vendors[_vendorId].ratePlans[_rpid].name;
1338         _timestamp = vendors[_vendorId].ratePlans[_rpid].timestamp;
1339         _ipfs = vendors[_vendorId].ratePlans[_rpid].ipfs;
1340     }
1341 
1342     /**
1343      * @dev Get the rate plan price by `_vendorId`, `_rpid`, `_date` and `_tokenId`
1344      * @param _vendorId The vendor id
1345      * @param _rpid The rate plan id
1346      * @param _date The date desc (20180723)
1347      * @param _tokenId The digital token id
1348      * @return The price info(inventory, init, price)
1349      */
1350     function getPrice(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId) 
1351         public
1352         view 
1353         returns(uint16 _inventory, bool _init, uint256 _price) {
1354         _inventory = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
1355         _init = vendors[_vendorId].ratePlans[_rpid].prices[_date].init;
1356         _price = vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId];
1357         if(!_init) {
1358             // Get the base price
1359             _inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1360             _price = vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId];
1361             _init = vendors[_vendorId].ratePlans[_rpid].basePrice.init;
1362         }
1363     }
1364 
1365     /**
1366      * @dev Get the rate plan prices by `_vendorId`, `_rpid`, `_dates` and `_tokenId`
1367      * @param _vendorId The vendor id
1368      * @param _rpid The rate plan id
1369      * @param _dates The dates desc ([20180723,20180724,20180725])
1370      * @param _tokenId The digital token id
1371      * @return The price info(inventory, init, price)
1372      */
1373     function getPrices(uint256 _vendorId, uint256 _rpid, uint256[] _dates, uint256 _tokenId) 
1374         public
1375         view 
1376         returns(uint16[] _inventories, uint256[] _prices) {
1377         uint16[] memory inventories = new uint16[](_dates.length);
1378         uint256[] memory prices = new uint256[](_dates.length);
1379         uint256 date;
1380         for(uint256 i = 0; i < _dates.length; i++) {
1381             date = _dates[i];
1382             uint16 inventory = vendors[_vendorId].ratePlans[_rpid].prices[date].inventory;
1383             bool init = vendors[_vendorId].ratePlans[_rpid].prices[date].init;
1384             uint256 price = vendors[_vendorId].ratePlans[_rpid].prices[date].tokens[_tokenId];
1385             if(!init) {
1386                 // Get the base price
1387                 inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1388                 price = vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId];
1389                 init = vendors[_vendorId].ratePlans[_rpid].basePrice.init;
1390             }
1391             inventories[i] = inventory;
1392             prices[i] = price;
1393         }
1394         return (inventories, prices);
1395     }
1396 
1397     /**
1398      * @dev Get the inventory by  by `_vendorId`, `_rpid` and `_date`
1399      * @param _vendorId The vendor id
1400      * @param _rpid The rate plan id
1401      * @param _date The date desc (20180723)
1402      * @return The inventory info(inventory, init)
1403      */
1404     function getInventory(uint256 _vendorId, uint256 _rpid, uint256 _date) 
1405         public
1406         view 
1407         returns(uint16 _inventory, bool _init) {
1408         _inventory = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
1409         _init = vendors[_vendorId].ratePlans[_rpid].prices[_date].init;
1410         if(!_init) {
1411             // Get the base price
1412             _inventory = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1413         }
1414     }
1415 
1416     /**
1417      * @dev Whether the rate plan is exist
1418      * @param _vendorId The vendor id
1419      * @param _rpid The rate plan id
1420      * @return If the rate plan of the vendor is exist returns true otherwise return false
1421      */
1422     function ratePlanIsExist(uint256 _vendorId, uint256 _rpid) 
1423         public 
1424         view 
1425         returns (bool) {
1426         return vendors[_vendorId].ratePlanList.nodeExists(_rpid);
1427     }
1428 
1429     /**
1430      * @dev Get orders of owner by page
1431      * @param _owner The owner address
1432      * @param _from The begin id of the node to get
1433      * @param _limit The total nodes of one page
1434      * @param _direction Direction to step in
1435      * @return The order ids and the next id
1436      */
1437     function getOrdersOfOwner(address _owner, uint256 _from, uint256 _limit, bool _direction) 
1438         public 
1439         view 
1440         returns (uint256[], uint256) {
1441         return getNodes(roomNightOwners[_owner], _from, _limit, _direction);
1442     }
1443 
1444     /**
1445      * @dev Get orders of vendor by page
1446      * @param _owner The vendor address
1447      * @param _from The begin id of the node to get
1448      * @param _limit The total nodes of on page
1449      * @param _direction Direction to step in 
1450      * @return The order ids and the next id
1451      */
1452     function getOrdersOfVendor(address _owner, uint256 _from, uint256 _limit, bool _direction) 
1453         public 
1454         view 
1455         returns (uint256[], uint256) {
1456         return getNodes(roomNightVendors[_owner], _from, _limit, _direction);
1457     }
1458 
1459     /**
1460      * @dev Get the token count of somebody 
1461      * @param _owner The owner of token
1462      * @return The token count of `_owner`
1463      */
1464     function balanceOf(address _owner) 
1465         public 
1466         view 
1467         returns(uint256) {
1468         return roomNightOwners[_owner].length;
1469     }
1470 
1471     /**
1472      * @dev Get rate plan ids of `_vendorId`
1473      * @param _from The begin id of the node to get
1474      * @param _limit The total nodes of on page
1475      * @param _direction Direction to step in 
1476      * @return The rate plan ids and the next id
1477      */
1478     function getRatePlansOfVendor(uint256 _vendorId, uint256 _from, uint256 _limit, bool _direction) 
1479         public 
1480         view 
1481         returns(uint256[], uint256) {
1482         return getNodes(vendors[_vendorId].ratePlanList, _from, _limit, _direction);
1483     }
1484 
1485     /**
1486      * @dev Get token ids
1487      * @param _from The begin id of the node to get
1488      * @param _limit The total nodes of on page
1489      * @param _direction Direction to step in 
1490      * @return The token ids and the next id
1491      */
1492     function getTokens(uint256 _from, uint256 _limit, bool _direction) 
1493         public 
1494         view 
1495         returns(uint256[], uint256) {
1496         return getNodes(tokenList, _from, _limit, _direction);
1497     }
1498 
1499     /**
1500      * @dev Get token Info
1501      * @param _tokenId The token id
1502      * @return The token info(symbol, name, decimals)
1503      */
1504     function getToken(uint256 _tokenId)
1505         public 
1506         view 
1507         returns(string _symbol, string _name, uint8 _decimals, address _token) {
1508         _token = tokenIndexToAddress[_tokenId];
1509         TripioToken tripio = TripioToken(_token);
1510         _symbol = tripio.symbol();
1511         _name = tripio.name();
1512         _decimals = tripio.decimals();
1513     }
1514 
1515     /**
1516      * @dev Get vendor ids
1517      * @param _from The begin id of the node to get
1518      * @param _limit The total nodes of on page
1519      * @param _direction Direction to step in 
1520      * @return The vendor ids and the next id
1521      */
1522     function getVendors(uint256 _from, uint256 _limit, bool _direction) 
1523         public 
1524         view 
1525         returns(uint256[], uint256) {
1526         return getNodes(vendorList, _from, _limit, _direction);
1527     }
1528 
1529     /**
1530      * @dev Get the vendor infomation by vendorId
1531      * @param _vendorId The vendor id
1532      * @return The vendor infomation(name, vendor, timestamp, valid)
1533      */
1534     function getVendor(uint256 _vendorId) 
1535         public 
1536         view 
1537         returns(string _name, address _vendor,uint256 _timestamp, bool _valid) {
1538         _name = vendors[_vendorId].name;
1539         _vendor = vendors[_vendorId].vendor;
1540         _timestamp = vendors[_vendorId].timestamp;
1541         _valid = vendors[_vendorId].valid;
1542     }
1543 
1544     /*************************************** SET ***************************************/
1545     /**
1546      * @dev Update base uri of token metadata
1547      * @param _tokenBaseURI The base uri
1548      */
1549     function updateTokenBaseURI(string _tokenBaseURI) 
1550         public 
1551         onlyOwnerOrAuthorizedContract {
1552         tokenBaseURI = _tokenBaseURI;
1553     }
1554 
1555     /**
1556      * @dev Push order to user's order list
1557      * @param _owner The buyer address
1558      * @param _rnid The room night order id
1559      * @param _direction direction to step in
1560      */
1561     function pushOrderOfOwner(address _owner, uint256 _rnid, bool _direction) 
1562         public 
1563         onlyOwnerOrAuthorizedContract {
1564         if(!roomNightOwners[_owner].listExists()) {
1565             roomNightOwners[_owner] = LinkedListLib.LinkedList(0, 0);
1566         }
1567         roomNightOwners[_owner].add(_rnid, _direction);
1568     }
1569 
1570     /**
1571      * @dev Remove order from owner's order list
1572      * @param _owner The owner address
1573      * @param _rnid The room night order id
1574      */
1575     function removeOrderOfOwner(address _owner, uint _rnid) 
1576         public 
1577         onlyOwnerOrAuthorizedContract {
1578         require(roomNightOwners[_owner].nodeExists(_rnid));
1579         roomNightOwners[_owner].remove(_rnid);
1580     }
1581 
1582     /**
1583      * @dev Push order to the vendor's order list
1584      * @param _vendor The vendor address
1585      * @param _rnid The room night order id
1586      * @param _direction direction to step in
1587      */
1588     function pushOrderOfVendor(address _vendor, uint256 _rnid, bool _direction) 
1589         public 
1590         onlyOwnerOrAuthorizedContract {
1591         if(!roomNightVendors[_vendor].listExists()) {
1592             roomNightVendors[_vendor] = LinkedListLib.LinkedList(0, 0);
1593         }
1594         roomNightVendors[_vendor].add(_rnid, _direction);
1595     }
1596 
1597     /**
1598      * @dev Remove order from vendor's order list
1599      * @param _vendor The vendor address
1600      * @param _rnid The room night order id
1601      */
1602     function removeOrderOfVendor(address _vendor, uint256 _rnid) 
1603         public 
1604         onlyOwnerOrAuthorizedContract {
1605         require(roomNightVendors[_vendor].nodeExists(_rnid));
1606         roomNightVendors[_vendor].remove(_rnid);
1607     }
1608 
1609     /**
1610      * @dev Transfer token to somebody
1611      * @param _tokenId The token id 
1612      * @param _to The target owner of the token
1613      */
1614     function transferTokenTo(uint256 _tokenId, address _to) 
1615         public 
1616         onlyOwnerOrAuthorizedContract {
1617         roomNightIndexToOwner[_tokenId] = _to;
1618         roomNightApprovals[_tokenId] = address(0);
1619     }
1620 
1621     /**
1622      * @dev Approve `_to` to operate the `_tokenId`
1623      * @param _tokenId The token id
1624      * @param _to Somebody to be approved
1625      */
1626     function approveTokenTo(uint256 _tokenId, address _to) 
1627         public 
1628         onlyOwnerOrAuthorizedContract {
1629         roomNightApprovals[_tokenId] = _to;
1630     }
1631 
1632     /**
1633      * @dev Approve `_operator` to operate all the Token of `_to`
1634      * @param _operator The operator to be approved
1635      * @param _to The owner of tokens to be operate
1636      * @param _approved Approved or not
1637      */
1638     function approveOperatorTo(address _operator, address _to, bool _approved) 
1639         public 
1640         onlyOwnerOrAuthorizedContract {
1641         operatorApprovals[_to][_operator] = _approved;
1642     } 
1643 
1644     /**
1645      * @dev Update base price of rate plan
1646      * @param _vendorId The vendor id
1647      * @param _rpid The rate plan id
1648      * @param _tokenId The digital token id
1649      * @param _price The price to be updated
1650      */
1651     function updateBasePrice(uint256 _vendorId, uint256 _rpid, uint256 _tokenId, uint256 _price)
1652         public 
1653         onlyOwnerOrAuthorizedContract {
1654         vendors[_vendorId].ratePlans[_rpid].basePrice.init = true;
1655         vendors[_vendorId].ratePlans[_rpid].basePrice.tokens[_tokenId] = _price;
1656     }
1657 
1658     /**
1659      * @dev Update base inventory of rate plan 
1660      * @param _vendorId The vendor id
1661      * @param _rpid The rate plan id
1662      * @param _inventory The inventory to be updated
1663      */
1664     function updateBaseInventory(uint256 _vendorId, uint256 _rpid, uint16 _inventory)
1665         public 
1666         onlyOwnerOrAuthorizedContract {
1667         vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = _inventory;
1668     }
1669 
1670     /**
1671      * @dev Update price by `_vendorId`, `_rpid`, `_date`, `_tokenId` and `_price`
1672      * @param _vendorId The vendor id
1673      * @param _rpid The rate plan id
1674      * @param _date The date desc (20180723)
1675      * @param _tokenId The digital token id
1676      * @param _price The price to be updated
1677      */
1678     function updatePrice(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId, uint256 _price)
1679         public
1680         onlyOwnerOrAuthorizedContract {
1681         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1682             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1683         } else {
1684             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(0, true);
1685             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1686         }
1687     }
1688 
1689     /**
1690      * @dev Update inventory by `_vendorId`, `_rpid`, `_date`, `_inventory`
1691      * @param _vendorId The vendor id
1692      * @param _rpid The rate plan id
1693      * @param _date The date desc (20180723)
1694      * @param _inventory The inventory to be updated
1695      */
1696     function updateInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory)
1697         public 
1698         onlyOwnerOrAuthorizedContract {
1699         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1700             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = _inventory;
1701         } else {
1702             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(_inventory, true);
1703         }
1704     }
1705 
1706     /**
1707      * @dev Reduce inventories
1708      * @param _vendorId The vendor id
1709      * @param _rpid The rate plan id
1710      * @param _date The date desc (20180723)
1711      * @param _inventory The amount to be reduced
1712      */
1713     function reduceInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory) 
1714         public  
1715         onlyOwnerOrAuthorizedContract {
1716         uint16 a = 0;
1717         if(vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1718             a = vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
1719             require(_inventory <= a);
1720             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = a - _inventory;
1721         }else if(vendors[_vendorId].ratePlans[_rpid].basePrice.init){
1722             a = vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1723             require(_inventory <= a);
1724             vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = a - _inventory;
1725         }
1726     }
1727 
1728     /**
1729      * @dev Add inventories
1730      * @param _vendorId The vendor id
1731      * @param _rpid The rate plan id
1732      * @param _date The date desc (20180723)
1733      * @param _inventory The amount to be add
1734      */
1735     function addInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint16 _inventory) 
1736         public  
1737         onlyOwnerOrAuthorizedContract {
1738         uint16 c = 0;
1739         if(vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1740             c = _inventory + vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory;
1741             require(c >= _inventory);
1742             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = c;
1743         }else if(vendors[_vendorId].ratePlans[_rpid].basePrice.init) {
1744             c = _inventory + vendors[_vendorId].ratePlans[_rpid].basePrice.inventory;
1745             require(c >= _inventory);
1746             vendors[_vendorId].ratePlans[_rpid].basePrice.inventory = c;
1747         }
1748     }
1749 
1750     /**
1751      * @dev Update inventory and price by `_vendorId`, `_rpid`, `_date`, `_tokenId`, `_price` and `_inventory`
1752      * @param _vendorId The vendor id
1753      * @param _rpid The rate plan id
1754      * @param _date The date desc (20180723)
1755      * @param _tokenId The digital token id
1756      * @param _price The price to be updated
1757      * @param _inventory The inventory to be updated
1758      */
1759     function updatePriceAndInventories(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _tokenId, uint256 _price, uint16 _inventory)
1760         public 
1761         onlyOwnerOrAuthorizedContract {
1762         if (vendors[_vendorId].ratePlans[_rpid].prices[_date].init) {
1763             vendors[_vendorId].ratePlans[_rpid].prices[_date].inventory = _inventory;
1764             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1765         } else {
1766             vendors[_vendorId].ratePlans[_rpid].prices[_date] = Price(_inventory, true);
1767             vendors[_vendorId].ratePlans[_rpid].prices[_date].tokens[_tokenId] = _price;
1768         }
1769     }
1770 
1771     /**
1772      * @dev Push rate plan to `_vendorId`'s rate plan list
1773      * @param _vendorId The vendor id
1774      * @param _name The name of rate plan
1775      * @param _ipfs The rate plan IPFS address
1776      * @param _direction direction to step in
1777      */
1778     function pushRatePlan(uint256 _vendorId, string _name, bytes32 _ipfs, bool _direction) 
1779         public 
1780         onlyOwnerOrAuthorizedContract
1781         returns(uint256) {
1782         RatePlan memory rp = RatePlan(_name, uint256(now), _ipfs, Price(0, false));
1783         
1784         uint256 id = vendors[_vendorId].ratePlanList.push(_direction);
1785         vendors[_vendorId].ratePlans[id] = rp;
1786         return id;
1787     }
1788 
1789     /**
1790      * @dev Remove rate plan of `_vendorId` by `_rpid`
1791      * @param _vendorId The vendor id
1792      * @param _rpid The rate plan id
1793      */
1794     function removeRatePlan(uint256 _vendorId, uint256 _rpid) 
1795         public 
1796         onlyOwnerOrAuthorizedContract {
1797         delete vendors[_vendorId].ratePlans[_rpid];
1798         vendors[_vendorId].ratePlanList.remove(_rpid);
1799     }
1800 
1801     /**
1802      * @dev Update `_rpid` of `_vendorId` by `_name` and `_ipfs`
1803      * @param _vendorId The vendor id
1804      * @param _rpid The rate plan id
1805      * @param _name The rate plan name
1806      * @param _ipfs The rate plan IPFS address
1807      */
1808     function updateRatePlan(uint256 _vendorId, uint256 _rpid, string _name, bytes32 _ipfs)
1809         public 
1810         onlyOwnerOrAuthorizedContract {
1811         vendors[_vendorId].ratePlans[_rpid].ipfs = _ipfs;
1812         vendors[_vendorId].ratePlans[_rpid].name = _name;
1813     }
1814     
1815     /**
1816      * @dev Push token contract to the token list
1817      * @param _direction direction to step in
1818      */
1819     function pushToken(address _contract, bool _direction)
1820         public 
1821         onlyOwnerOrAuthorizedContract 
1822         returns(uint256) {
1823         uint256 id = tokenList.push(_direction);
1824         tokenIndexToAddress[id] = _contract;
1825         return id;
1826     }
1827 
1828     /**
1829      * @dev Remove token by `_tokenId`
1830      * @param _tokenId The digital token id
1831      */
1832     function removeToken(uint256 _tokenId) 
1833         public 
1834         onlyOwnerOrAuthorizedContract {
1835         delete tokenIndexToAddress[_tokenId];
1836         tokenList.remove(_tokenId);
1837     }
1838 
1839     /**
1840      * @dev Generate room night token
1841      * @param _vendorId The vendor id
1842      * @param _rpid The rate plan id
1843      * @param _date The date desc (20180723)
1844      * @param _token The token id
1845      * @param _price The token price
1846      * @param _ipfs The rate plan IPFS address
1847      */
1848     function generateRoomNightToken(uint256 _vendorId, uint256 _rpid, uint256 _date, uint256 _token, uint256 _price, bytes32 _ipfs)
1849         public 
1850         onlyOwnerOrAuthorizedContract 
1851         returns(uint256) {
1852         roomnights.push(RoomNight(_vendorId, _rpid, _token, _price, now, _date, _ipfs));
1853 
1854         // Give the token to `_customer`
1855         uint256 rnid = uint256(roomnights.length - 1);
1856         return rnid;
1857     }
1858 
1859     /**
1860      * @dev Update refund applications
1861      * @param _buyer The room night token holder
1862      * @param _rnid The room night token id
1863      * @param _isRefund Is redund or not
1864      */
1865     function updateRefundApplications(address _buyer, uint256 _rnid, bool _isRefund) 
1866         public 
1867         onlyOwnerOrAuthorizedContract {
1868         refundApplications[_buyer][_rnid] = _isRefund;
1869     }
1870 
1871     /**
1872      * @dev Push vendor info to the vendor list
1873      * @param _name The name of vendor
1874      * @param _vendor The vendor address
1875      * @param _direction direction to step in
1876      */
1877     function pushVendor(string _name, address _vendor, bool _direction)
1878         public 
1879         onlyOwnerOrAuthorizedContract 
1880         returns(uint256) {
1881         uint256 id = vendorList.push(_direction);
1882         vendorIds[_vendor] = id;
1883         vendors[id] = Vendor(_name, _vendor, uint256(now), true, LinkedListLib.LinkedList(0, 0));
1884         return id;
1885     }
1886 
1887     /**
1888      * @dev Remove vendor from vendor list
1889      * @param _vendorId The vendor id
1890      */
1891     function removeVendor(uint256 _vendorId) 
1892         public 
1893         onlyOwnerOrAuthorizedContract {
1894         vendorList.remove(_vendorId);
1895         address vendor = vendors[_vendorId].vendor;
1896         vendorIds[vendor] = 0;
1897         delete vendors[_vendorId];
1898     }
1899 
1900     /**
1901      * @dev Make vendor valid or invalid
1902      * @param _vendorId The vendor id
1903      * @param _valid The vendor is valid or not
1904      */
1905     function updateVendorValid(uint256 _vendorId, bool _valid)
1906         public 
1907         onlyOwnerOrAuthorizedContract {
1908         vendors[_vendorId].valid = _valid;
1909     }
1910 
1911     /**
1912      * @dev Modify vendor's name
1913      * @param _vendorId The vendor id
1914      * @param _name Then vendor name
1915      */
1916     function updateVendorName(uint256 _vendorId, string _name)
1917         public 
1918         onlyOwnerOrAuthorizedContract {
1919         vendors[_vendorId].name = _name;
1920     }
1921 }
1922 
1923 
1924 
1925 contract TRNTransactions is TRNOwners {
1926     /**
1927      * Constructor
1928      */
1929     constructor() public {
1930 
1931     }
1932 
1933     /**
1934      * This emits when rate plan is bought in batch
1935      */
1936     event BuyInBatch(address indexed _customer, address indexed _vendor, uint256 indexed _rpid, uint256[] _dates, uint256 _token);
1937 
1938     /**
1939      * This emits when token refund is applied 
1940      */
1941     event ApplyRefund(address _customer, uint256 indexed _rnid, bool _isRefund);
1942 
1943     /**
1944      * This emits when refunded
1945      */
1946     event Refund(address _vendor, uint256 _rnid);
1947 
1948     /**
1949      * @dev Complete the buy transaction,
1950      *      The inventory minus one and the room night token transfer to customer
1951      * @param _vendorId The vendor account
1952      * @param _rpid The vendor's rate plan id
1953      * @param _date The booking date
1954      * @param _customer The customer account
1955      * @param _token The token Id
1956      */
1957     function _buy(uint256 _vendorId, uint256 _rpid, uint256 _date, address _customer, uint256 _token) private {
1958         // Product room night token
1959         (,,uint256 _price) = dataSource.getPrice(_vendorId, _rpid, _date, _token);
1960         (,,bytes32 _ipfs) = dataSource.getRatePlan(_vendorId, _rpid);
1961         uint256 rnid = dataSource.generateRoomNightToken(_vendorId, _rpid, _date, _token, _price, _ipfs);
1962 
1963         // Give the token to `_customer`
1964         dataSource.transferTokenTo(rnid, _customer);
1965 
1966         // Record the token to `_customer` account
1967         _pushRoomNight(_customer, rnid, false);
1968 
1969         // Record the token to `_vendor` account
1970         (,address vendor,,) = dataSource.getVendor(_vendorId);
1971         _pushRoomNight(vendor, rnid, true);
1972 
1973         // The inventory minus one
1974         dataSource.reduceInventories(_vendorId, _rpid, _date, 1);
1975     }
1976 
1977     /**
1978      * @dev Complete the buy transaction in batch,
1979      *      The inventory minus one and the room night token transfer to customer
1980      * @param _vendorId The vendor account
1981      * @param _vendor Then vendor address
1982      * @param _rpid The vendor's rate plan id
1983      * @param _dates The booking date
1984      * @param _token The token Id
1985      */
1986     function _buyInBatch(uint256 _vendorId, address _vendor, uint256 _rpid, uint256[] _dates, uint256 _token) private returns(bool) {
1987         (uint16[] memory inventories, uint256[] memory values) = dataSource.getPrices(_vendorId, _rpid, _dates, _token);
1988         uint256 totalValues = 0;
1989         for(uint256 i = 0; i < _dates.length; i++) {
1990             if(inventories[i] == 0 || values[i] == 0) {
1991                 return false;
1992             }
1993             totalValues += values[i];
1994             // Transfer the room night to `msg.sender`
1995             _buy(_vendorId, _rpid, _dates[i], msg.sender, _token);
1996         }
1997         
1998         if (_token == 0) {
1999             // By through ETH
2000             require(msg.value == totalValues);
2001 
2002             // Transfer the ETH to `_vendor`
2003             _vendor.transfer(totalValues);
2004         } else {
2005             // By through other digital token
2006             address tokenAddress = dataSource.tokenIndexToAddress(_token);
2007             require(tokenAddress != address(0));
2008 
2009             // This contract transfer `price.trio` from `msg.sender` account
2010             TripioToken tripio = TripioToken(tokenAddress);
2011             tripio.transferFrom(msg.sender, _vendor, totalValues);
2012         }
2013         return true;
2014     }
2015 
2016     /**
2017      * Complete the refund transaction
2018      * Remove the `_rnid` from the owner account and the inventory plus one
2019      */
2020     function _refund(uint256 _rnid, uint256 _vendorId, uint256 _rpid, uint256 _date) private {
2021         // Remove the `_rnid` from the owner
2022         _removeRoomNight(dataSource.roomNightIndexToOwner(_rnid), _rnid);
2023 
2024         // The inventory plus one
2025         dataSource.addInventories(_vendorId, _rpid, _date, 1);
2026 
2027         // Change the owner of `_rnid`
2028         dataSource.transferTokenTo(_rnid, address(0));
2029     }
2030 
2031     /**
2032      * @dev By room nigth in batch through ETH(`_token` == 0) or other digital token(`_token != 0`)
2033      *      Throw when `_rpid` not exist
2034      *      Throw unless each inventory more than zero
2035      *      Throw unless `msg.value` equal to `price.eth`
2036      *      This method is payable, can accept ETH transfer
2037      * @param _vendorId The vendor Id
2038      * @param _rpid The _vendor's rate plan id
2039      * @param _dates The booking dates
2040      * @param _token The digital currency token 
2041      */
2042     function buyInBatch(uint256 _vendorId, uint256 _rpid, uint256[] _dates, uint256 _token) 
2043         external
2044         payable
2045         ratePlanExist(_vendorId, _rpid)
2046         validDates(_dates)
2047         returns(bool) {
2048         
2049         (,address vendor,,) = dataSource.getVendor(_vendorId);
2050         
2051         bool result = _buyInBatch(_vendorId, vendor, _rpid, _dates, _token);
2052         
2053         require(result);
2054 
2055         // Event
2056         emit BuyInBatch(msg.sender, vendor, _rpid, _dates, _token);
2057         return true;
2058     }
2059 
2060     /**
2061      * @dev Apply room night refund
2062      *      Throw unless `_rnid` is valid
2063      *      Throw unless `_rnid` can transfer
2064      * @param _rnid room night identifier
2065      * @param _isRefund if `true` the `_rnid` can transfer else not
2066      */
2067     function applyRefund(uint256 _rnid, bool _isRefund) 
2068         external
2069         validToken(_rnid)
2070         canTransfer(_rnid)
2071         returns(bool) {
2072         dataSource.updateRefundApplications(msg.sender, _rnid, _isRefund);
2073 
2074         // Event
2075         emit ApplyRefund(msg.sender, _rnid, _isRefund);
2076         return true;
2077     }
2078 
2079     /**
2080      * @dev Whether the `_rnid` is in refund applications
2081      * @param _rnid room night identifier
2082      */
2083     function isRefundApplied(uint256 _rnid) 
2084         external
2085         view
2086         validToken(_rnid) returns(bool) {
2087         return dataSource.refundApplications(dataSource.roomNightIndexToOwner(_rnid), _rnid);
2088     }
2089 
2090     /**
2091      * @dev Refund through ETH or other digital token, give the room night ETH/TOKEN to customer and take back inventory
2092      *      Throw unless `_rnid` is valid
2093      *      Throw unless `msg.sender` is vendor
2094      *      Throw unless the refund application is true
2095      *      Throw unless the `msg.value` is equal to `roomnight.eth`
2096      * @param _rnid room night identifier
2097      */
2098     function refund(uint256 _rnid) 
2099         external
2100         payable
2101         validToken(_rnid) 
2102         returns(bool) {
2103         // Refund application is true
2104         require(dataSource.refundApplications(dataSource.roomNightIndexToOwner(_rnid), _rnid));
2105 
2106         // The `msg.sender` is the vendor of the room night.
2107         (uint256 vendorId,uint256 rpid,uint256 token,uint256 price,,uint256 date,) = dataSource.roomnights(_rnid);
2108         (,address vendor,,) = dataSource.getVendor(vendorId);
2109         require(msg.sender == vendor);
2110 
2111         address ownerAddress = dataSource.roomNightIndexToOwner(_rnid);
2112 
2113         if (token == 0) {
2114             // Refund by ETH
2115 
2116             // The `msg.sender` is equal to `roomnight.eth`
2117             uint256 value = price;
2118             require(msg.value >= value);
2119 
2120             // Transfer the ETH to roomnight's owner
2121             ownerAddress.transfer(value);
2122         } else {
2123             // Refund  by TRIO
2124 
2125             // The `roomnight.trio` is more than zero
2126             require(price > 0);
2127 
2128             // This contract transfer `price.trio` from `msg.sender` account
2129             TripioToken tripio = TripioToken(dataSource.tokenIndexToAddress(token));
2130             tripio.transferFrom(msg.sender, ownerAddress, price);
2131         }
2132         // Refund
2133         _refund(_rnid, vendorId, rpid, date);
2134 
2135         // Event 
2136         emit Refund(msg.sender, _rnid);
2137         return true;
2138     }
2139 }
2140 
2141 contract TripioRoomNightCustomer is TRNAsset, TRNSupportsInterface, TRNOwnership, TRNTransactions {
2142     /**
2143      * Constructor
2144      */
2145     constructor(address _dataSource) public {
2146         // Init the data source
2147         dataSource = TripioRoomNightData(_dataSource);
2148     }
2149 
2150     /**
2151      * @dev Withdraw ETH balance from contract account, the balance will transfer to the contract owner
2152      */
2153     function withdrawBalance() external onlyOwner {
2154         owner.transfer(address(this).balance);
2155     }
2156 
2157     /**
2158      * @dev Withdraw other TOKEN balance from contract account, the balance will transfer to the contract owner
2159      * @param _token The TOKEN id
2160      */
2161     function withdrawTokenId(uint _token) external onlyOwner {
2162         TripioToken tripio = TripioToken(dataSource.tokenIndexToAddress(_token));
2163         uint256 tokens = tripio.balanceOf(address(this));
2164         tripio.transfer(owner, tokens);
2165     }
2166 
2167     /**
2168      * @dev Withdraw other TOKEN balance from contract account, the balance will transfer to the contract owner
2169      * @param _tokenAddress The TOKEN address
2170      */
2171     function withdrawToken(address _tokenAddress) external onlyOwner {
2172         TripioToken tripio = TripioToken(_tokenAddress);
2173         uint256 tokens = tripio.balanceOf(address(this));
2174         tripio.transfer(owner, tokens);
2175     }
2176 
2177     /**
2178      * @dev Destory the contract
2179      */
2180     function destroy() external onlyOwner {
2181         selfdestruct(owner);
2182     }
2183 
2184     function() external payable {
2185 
2186     }
2187 }