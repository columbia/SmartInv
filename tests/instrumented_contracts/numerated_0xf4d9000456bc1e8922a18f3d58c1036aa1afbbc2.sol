1 pragma solidity ^0.4.24;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library Address {
7 
8   /**
9    * Returns whether the target address is a contract
10    * @dev This function will return false if invoked during the constructor of a contract,
11    * as the code is not actually created until after the constructor finishes.
12    * @param account address of the account to check
13    * @return whether the target address is a contract
14    */
15     function isContract(address account) internal view returns (bool) {
16         uint256 size;
17         // XXX Currently there is no better way to check if there is a contract in an address
18         // than to check the size of the code at that address.
19         // See https://ethereum.stackexchange.com/a/14016/36603
20         // for more details about how this works.
21         // TODO Check this again before the Serenity release, because all addresses will be
22         // contracts then.
23         // solium-disable-next-line security/no-inline-assembly
24         assembly { size := extcodesize(account) }
25         return size > 0;
26     }
27 
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that revert on error
33  */
34 library SafeMath {
35 
36   /**
37   * @dev Multiplies two numbers, reverts on overflow.
38   */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41     // benefit is lost if 'b' is also tested.
42     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53   /**
54   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
55   */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b > 0); // Solidity only automatically asserts when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64   /**
65   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
66   */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b <= a);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74   /**
75   * @dev Adds two numbers, reverts on overflow.
76   */
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a);
80 
81         return c;
82     }
83 
84   /**
85   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
86   * reverts when dividing by zero.
87   */
88     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b != 0);
90         return a % b;
91     }
92 }
93 
94 /**
95  * @title IERC165
96  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
97  */
98 interface IERC165 {
99 
100   /**
101    * @notice Query if a contract implements an interface
102    * @param interfaceId The interface identifier, as specified in ERC-165
103    * @dev Interface identification is specified in ERC-165. This function
104    * uses less than 30,000 gas.
105    */
106   function supportsInterface(bytes4 interfaceId)
107     external
108     view
109     returns (bool);
110 }
111 
112 /**
113  * @title ERC165
114  * @author Matt Condon (@shrugs)
115  * @dev Implements ERC165 using a lookup table.
116  */
117 contract ERC165 is IERC165 {
118 
119     bytes4 private constant _InterfaceId_ERC165 = 0x80ac58cd;
120   /**
121    * 0x01ffc9a7 ===
122    *   bytes4(keccak256('supportsInterface(bytes4)'))
123    */
124 
125   /**
126    * @dev a mapping of interface id to whether or not it's supported
127    */
128     mapping(bytes4 => bool) private _supportedInterfaces;
129 
130   /**
131    * @dev A contract implementing SupportsInterfaceWithLookup
132    * implement ERC165 itself
133    */
134     constructor() public
135     {
136         _registerInterface(_InterfaceId_ERC165);
137     }
138 
139   /**
140    * @dev implement supportsInterface(bytes4) using a lookup table
141    */
142     function supportsInterface(bytes4 interfaceId) external view
143     returns (bool)
144     {
145         return _supportedInterfaces[interfaceId];
146     }
147 
148   /**
149    * @dev internal method for registering an interface
150    */
151     function _registerInterface(bytes4 interfaceId) internal
152     {
153         require(interfaceId != 0xffffffff);
154         _supportedInterfaces[interfaceId] = true;
155     }
156 }
157 
158 /**
159  * @title ERC721 token receiver interface
160  * @dev Interface for any contract that wants to support safeTransfers
161  * from ERC721 asset contracts.
162  */
163 contract IERC721Receiver {
164   /**
165    * @notice Handle the receipt of an NFT
166    * @dev The ERC721 smart contract calls this function on the recipient
167    * after a `safeTransfer`. This function MUST return the function selector,
168    * otherwise the caller will revert the transaction. The selector to be
169    * returned can be obtained as `this.onERC721Received.selector`. This
170    * function MAY throw to revert and reject the transfer.
171    * Note: the ERC721 contract address is always the message sender.
172    * @param operator The address which called `safeTransferFrom` function
173    * @param from The address which previously owned the token
174    * @param tokenId The NFT identifier which is being transferred
175    * @param data Additional data with no specified format
176    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
177    */
178     function onERC721Received(
179         address operator,
180         address from,
181         uint256 tokenId,
182         bytes data
183     )
184     public
185         returns(bytes4);
186 }
187 
188 /**
189  * @title ERC721 Non-Fungible Token Standard basic interface
190  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
191  */
192 contract IERC721 is IERC165 {
193 
194     event Transfer(
195         address indexed _from,
196         address indexed _to,
197         uint256 indexed _tokenId
198     );
199     event Approval(
200         address indexed _owner,
201         address indexed _approved,
202         uint256 indexed _tokenId
203     );
204     event ApprovalForAll(
205         address indexed _owner,
206         address indexed _operator,
207         bool _approved
208     );
209 
210     function balanceOf(address owner) external view returns (uint256 balance);
211     function ownerOf(uint256 tokenId) external view returns (address owner);
212 
213     function approve(address to, uint256 tokenId) external payable;
214     function getApproved(uint256 tokenId) external view returns (address operator);
215 
216     function setApprovalForAll(address operator, bool _approved) external;
217     function isApprovedForAll(address owner, address operator) external view returns (bool);
218 
219     function transferFrom(address from, address to, uint256 tokenId) external payable;
220     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
221 
222     function safeTransferFrom(
223         address _from,
224         address _to,
225         uint256 _tokenId,
226         bytes data
227         ) external payable;
228 }
229 
230 /**
231  * @title ERC721 Non-Fungible Token Standard basic implementation
232  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
233  */
234 contract ERC721 is ERC165, IERC721 {
235 
236     using SafeMath for uint256;
237     using Address for address;
238 
239     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
240     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
241     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
242 
243     // Mapping from token ID to owner
244     mapping (uint256 => address) private _tokenOwner;
245 
246     // Mapping from token ID to approved address
247     mapping (uint256 => address) private _tokenApprovals;
248 
249     // Mapping from owner to number of owned token
250     mapping (address => uint256) private _ownedTokensCount;
251 
252     // Mapping from owner to operator approvals
253     mapping (address => mapping (address => bool)) private _operatorApprovals;
254 
255     bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
256     /*
257     * 0x80ac58cd ===
258     *   bytes4(keccak256('balanceOf(address)')) ^
259     *   bytes4(keccak256('ownerOf(uint256)')) ^
260     *   bytes4(keccak256('approve(address,uint256)')) ^
261     *   bytes4(keccak256('getApproved(uint256)')) ^
262     *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
263     *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
264     *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
265     *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
266     *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
267     */
268 
269     constructor() public
270     {
271     // register the supported interfaces to conform to ERC721 via ERC165
272         _registerInterface(_InterfaceId_ERC721);
273     }
274 
275     /**
276     * @dev Gets the balance of the specified address
277     * @param owner address to query the balance of
278     * @return uint256 representing the amount owned by the passed address
279     */
280     function balanceOf(address owner) external view returns (uint256) {
281         require(owner != address(0));
282         return _ownedTokensCount[owner];
283     }
284 
285   /**
286    * @dev Gets the owner of the specified token ID
287    * @param tokenId uint256 ID of the token to query the owner of
288    * @return owner address currently marked as the owner of the given token ID
289    */
290     function ownerOf(uint256 tokenId) external view returns (address) {
291         _ownerOf(tokenId);
292     }
293   
294     function _ownerOf(uint256 tokenId) internal view returns (address owner) {
295         owner = _tokenOwner[tokenId];
296         require(owner != address(0));
297         return owner;
298     }
299 
300     /**
301     * @dev Approves another address to transfer the given token ID
302     * The zero address indicates there is no approved address.
303     * There can only be one approved address per token at a given time.
304     * Can only be called by the token owner or an approved operator.
305     * @param to address to be approved for the given token ID
306     * @param tokenId uint256 ID of the token to be approved
307     */
308     function approve(address to, uint256 tokenId) external payable {
309         address owner = _tokenOwner[tokenId];
310         require(to != owner);
311         require(msg.sender == owner || _operatorApprovals[owner][msg.sender]);
312 
313         _tokenApprovals[tokenId] = to;
314         emit Approval(owner, to, tokenId);
315     }
316 
317     /**
318     * @dev Gets the approved address for a token ID, or zero if no address set
319     * Reverts if the token ID does not exist.
320     * @param tokenId uint256 ID of the token to query the approval of
321     * @return address currently approved for the given token ID
322     */
323     function getApproved(uint256 tokenId) external view returns (address) {
324         _getApproved(tokenId);
325     }
326   
327     function _getApproved(uint256 tokenId) internal view returns (address) {
328         require(_exists(tokenId));
329         return _tokenApprovals[tokenId];
330     }
331     /**
332     * @dev Sets or unsets the approval of a given operator
333     * An operator is allowed to transfer all tokens of the sender on their behalf
334     * @param to operator address to set the approval
335     * @param approved representing the status of the approval to be set
336     */
337     function setApprovalForAll(address to, bool approved) external {
338         require(to != msg.sender);
339         _operatorApprovals[msg.sender][to] = approved;
340         emit ApprovalForAll(msg.sender, to, approved);
341     }
342 
343     /**
344     * @dev Tells whether an operator is approved by a given owner
345     * @param owner owner address which you want to query the approval of
346     * @param operator operator address which you want to query the approval of
347     * @return bool whether the given operator is approved by the given owner
348     */
349     function isApprovedForAll(
350         address owner,
351         address operator
352     )
353         external
354         view
355         returns (bool)
356     {
357         return _operatorApprovals[owner][operator];
358     }
359 
360     /**
361     * @dev Transfers the ownership of a given token ID to another address
362     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
363     * Requires the msg sender to be the owner, approved, or operator
364     * @param from current owner of the token
365     * @param to address to receive the ownership of the given token ID
366     * @param tokenId uint256 ID of the token to be transferred
367     */
368     function transferFrom(
369         address from,
370         address to,
371         uint256 tokenId
372     )
373         external payable
374     {
375         _transferFrom(from, to, tokenId);
376     }
377     
378     function _transferFrom(
379         address from, 
380         address to,
381         uint256 tokenId) internal {
382         require(_isApprovedOrOwner(msg.sender, tokenId));
383         require(to != address(0));
384         
385         _clearApproval(from, tokenId);
386         _removeTokenFrom(from, tokenId);
387         _addTokenTo(to, tokenId);
388         
389         emit Transfer(from, to, tokenId);
390     }
391 
392     /**
393     * @dev Safely transfers the ownership of a given token ID to another address
394     * If the target address is a contract, it must implement `onERC721Received`,
395     * which is called upon a safe transfer, and return the magic value
396     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
397     * the transfer is reverted.
398     *
399     * Requires the msg sender to be the owner, approved, or operator
400     * @param from current owner of the token
401     * @param to address to receive the ownership of the given token ID
402     * @param tokenId uint256 ID of the token to be transferred
403     */
404     function safeTransferFrom(
405         address from,
406         address to,
407         uint256 tokenId
408     )
409         external payable
410     {
411         // solium-disable-next-line arg-overflow
412         _safeTransferFrom(from, to, tokenId, "");
413     }
414 
415     /**
416     * @dev Safely transfers the ownership of a given token ID to another address
417     * If the target address is a contract, it must implement `onERC721Received`,
418     * which is called upon a safe transfer, and return the magic value
419     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
420     * the transfer is reverted.
421     * Requires the msg sender to be the owner, approved, or operator
422     * @param from current owner of the token
423     * @param to address to receive the ownership of the given token ID
424     * @param tokenId uint256 ID of the token to be transferred
425     * @param _data bytes data to send along with a safe transfer check
426     */
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId,
431         bytes _data
432     )
433         external payable
434     {
435         _safeTransferFrom(from, to, tokenId, _data);
436     }
437     
438     function _safeTransferFrom(
439         address from,
440         address to,
441         uint256 tokenId,
442         bytes _data)
443         internal
444     {
445         _transferFrom(from, to, tokenId);
446         // solium-disable-next-line arg-overflow
447         require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
448     }
449 
450     /**
451     * @dev Returns whether the specified token exists
452     * @param tokenId uint256 ID of the token to query the existence of
453     * @return whether the token exists
454     */
455     function _exists(uint256 tokenId) internal view returns (bool) {
456         address owner = _tokenOwner[tokenId];
457         return owner != address(0);
458     }
459 
460     /**
461     * @dev Returns whether the given spender can transfer a given token ID
462     * @param spender address of the spender to query
463     * @param tokenId uint256 ID of the token to be transferred
464     * @return bool whether the msg.sender is approved for the given token ID,
465     *  is an operator of the owner, or is the owner of the token
466     */
467     function _isApprovedOrOwner(
468         address spender,
469         uint256 tokenId
470     )
471         internal
472         view
473         returns (bool)
474     {
475         address owner = _tokenOwner[tokenId];
476         // Disable solium check because of
477         // https://github.com/duaraghav8/Solium/issues/175
478         // solium-disable-next-line operator-whitespace
479         return (
480         spender == owner ||
481         _getApproved(tokenId) == spender ||
482         _operatorApprovals[owner][spender]
483         );
484     }
485 
486     /**
487     * @dev Internal function to mint a new token
488     * Reverts if the given token ID already exists
489     * @param to The address that will own the minted token
490     * @param tokenId uint256 ID of the token to be minted by the msg.sender
491     */
492     function _mint(address to, uint256 tokenId) internal {
493         require(to != address(0));
494         _addTokenTo(to, tokenId);
495         emit Transfer(address(0), to, tokenId);
496     }
497 
498     /**
499     * @dev Internal function to burn a specific token
500     * Reverts if the token does not exist
501     * @param tokenId uint256 ID of the token being burned by the msg.sender
502     */
503     function _burn(address owner, uint256 tokenId) internal {
504         _clearApproval(owner, tokenId);
505         _removeTokenFrom(owner, tokenId);
506         emit Transfer(owner, address(0), tokenId);
507     }
508 
509     /**
510     * @dev Internal function to clear current approval of a given token ID
511     * Reverts if the given address is not indeed the owner of the token
512     * @param owner owner of the token
513     * @param tokenId uint256 ID of the token to be transferred
514     */
515     function _clearApproval(address owner, uint256 tokenId) internal {
516         require(_ownerOf(tokenId) == owner);
517         if (_tokenApprovals[tokenId] != address(0)) {
518             _tokenApprovals[tokenId] = address(0);
519         }
520     }
521 
522     /**
523     * @dev Internal function to add a token ID to the list of a given address
524     * @param to address representing the new owner of the given token ID
525     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
526     */
527     function _addTokenTo(address to, uint256 tokenId) internal {
528         require(_tokenOwner[tokenId] == address(0));
529         _tokenOwner[tokenId] = to;
530         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
531     }
532 
533     /**
534     * @dev Internal function to remove a token ID from the list of a given address
535     * @param from address representing the previous owner of the given token ID
536     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
537     */
538     function _removeTokenFrom(address from, uint256 tokenId) internal {
539         require(_ownerOf(tokenId) == from);
540         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
541         _tokenOwner[tokenId] = address(0);
542     }
543 
544     /**
545     * @dev Internal function to invoke `onERC721Received` on a target address
546     * The call is not executed if the target address is not a contract
547     * @param from address representing the previous owner of the given token ID
548     * @param to target address that will receive the tokens
549     * @param tokenId uint256 ID of the token to be transferred
550     * @param _data bytes optional data to send along with the call
551     * @return whether the call correctly returned the expected magic value
552     */
553     function _checkAndCallSafeTransfer(
554         address from,
555         address to,
556         uint256 tokenId,
557         bytes _data
558     )
559         internal
560         returns (bool)
561     {
562         if (!to.isContract()) {
563             return true;
564         }
565         bytes4 retval = IERC721Receiver(to).onERC721Received(
566         msg.sender, from, tokenId, _data);
567         return (retval == _ERC721_RECEIVED);
568     }
569 }
570 
571 contract Bloccelerator is ERC721 {
572     
573     mapping (uint256 => string) public Courses;
574     
575       // The data structure of the example deed
576     struct Certificate {
577         string name;
578         uint256 courseID;
579         uint256 date;
580         bytes32 registrationCode;
581     }
582 
583   /* Events */
584 
585     // When a certificate is created by an admin.
586     event Creation(uint256 indexed c_id, string indexed c_name, string indexed c_course);
587     
588     // Mapping from participants to certificates
589     mapping (uint256 => Certificate) private participants;
590     mapping (bytes32 => uint256[]) private studentDetail;
591 
592     // Needed to make all deeds discoverable. The length of this array also serves as our deed ID.
593     uint256[] private certificates;
594     uint256[] private courseIDs;
595     address private owner;
596     string public constant name = "Bloccelerator";
597     string public constant symbol = "BLOC";
598   
599     constructor()
600     public
601     {
602         owner = msg.sender;
603     }
604   
605     modifier onlyContractOwner {
606         require(msg.sender == owner);
607         _;
608     }
609     
610     // The contract owner creates deeds. Newly created deeds are initialised with a name and a beneficiary.
611     function create(address _to, string _name, uint256 _course, uint256 _date, bytes32 _userCode) 
612     public
613     onlyContractOwner
614     returns (uint256 certificateID)  {
615         certificateID = certificates.length;
616         certificates.push(certificateID);
617         super._mint(_to, certificateID);
618         participants[certificateID] = Certificate({
619             name: _name,
620             courseID: _course,
621             date: _date,
622             registrationCode: _userCode
623         });
624         studentDetail[_userCode].push(certificateID);
625         
626         emit Creation(certificateID, _name, Courses[_course]);
627     }
628   
629     function addCourse(string _name) public onlyContractOwner returns (uint256 courseID) {
630         require(verifyCourseExists(_name) != true);
631         uint _courseCount = courseIDs.length;
632         courseIDs.push(_courseCount);
633         Courses[_courseCount] = _name;
634         return _courseCount;
635     }
636   
637     function verifyCourseExists(string _name) internal view returns (bool exists) {
638         uint numberofCourses = courseIDs.length;
639         for (uint i=0; i<numberofCourses; i++) {
640             if (keccak256(abi.encodePacked(Courses[i])) == keccak256(abi.encodePacked(_name)))
641             {
642                 return true;
643             }
644         }
645         return false;
646     }
647   
648     function getMyCertIDs(string IDNumber) public view returns (string _name, uint[] _certIDs) {
649         bytes32 hashedID = keccak256(abi.encodePacked(IDNumber));
650         uint[] storage ownedCerts = studentDetail[hashedID];
651         require(verifyOwner(ownedCerts));
652         
653         _certIDs = studentDetail[hashedID];      
654         _name = participants[_certIDs[0]].name;
655     }
656   
657     function getCertInfo(uint256 certificateNumber) public view returns (string _name, string _courseName, uint256 _issueDate) {
658         _name = participants[certificateNumber].name;
659         _courseName = Courses[participants[certificateNumber].courseID];
660         _issueDate = participants[certificateNumber].date;
661     }
662   
663     function verifyOwner(uint[] _certIDs) internal view returns (bool isOwner) {
664         uint _numberOfCerts = _certIDs.length;
665         bool allCorrect = false;
666         for (uint i=0; i<_numberOfCerts; i++) {
667             allCorrect = (true && (_ownerOf(_certIDs[i]) == msg.sender));
668         }
669         return allCorrect;
670     }
671 }