1 //
2 // FormSI060719, which is part of the show "Garage Politburo" at Susan Inglett Gallery, NY.
3 // June 7, 2019 - July 26, 2019
4 
5 // For more information see https://github.com/GaragePolitburo/FormSI060719
6 
7 // Based on code by OpenZeppelin: 
8 // https://github.com/OpenZeppelin/openzeppelin-solidity/tree/master/contracts/token/ERC721
9 // Used Jan 4 2019 Open Zepplin package 76abd1a41ec7d96ef76370f3eadfe097226896a2
10 
11 // Based also on CryptoPunks by Larva Labs:
12 // https://github.com/larvalabs/cryptopunks
13 
14 // Text snippets taken from Fredric Jameson, Masha Gessen, Nisi Shawl, Margaret Thatcher, 
15 //  Leni Zumas, Philip Roth, Omar El Akkad, Wayne La Pierre, David Graeber,
16 // Walt Whitman, George Orwell, Rudyard Kipling, and Donna Haraway.
17 
18 
19 pragma solidity ^0.5.0;
20 
21 /**
22  * @title IERC165
23  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
24  */
25 interface IERC165 {
26     /**
27      * @notice Query if a contract implements an interface
28      * @param interfaceId The interface identifier, as specified in ERC-165
29      * @dev Interface identification is specified in ERC-165. This function
30      * uses less than 30,000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 /**
36  * @title ERC165
37  * @author Matt Condon (@shrugs)
38  * @dev Implements ERC165 using a lookup table.
39  */
40 contract ERC165 is IERC165 {
41     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
42     /**
43      * 0x01ffc9a7 ===
44      *     bytes4(keccak256('supportsInterface(bytes4)'))
45      */
46 
47     /**
48      * @dev a mapping of interface id to whether or not it's supported
49      */
50     mapping(bytes4 => bool) private _supportedInterfaces;
51 
52     /**
53      * @dev A contract implementing SupportsInterfaceWithLookup
54      * implement ERC165 itself
55      */
56     constructor () internal {
57         _registerInterface(_INTERFACE_ID_ERC165);
58     }
59 
60     /**
61      * @dev implement supportsInterface(bytes4) using a lookup table
62      */
63     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
64         return _supportedInterfaces[interfaceId];
65     }
66 
67     /**
68      * @dev internal method for registering an interface
69      */
70     function _registerInterface(bytes4 interfaceId) internal {
71         require(interfaceId != 0xffffffff);
72         _supportedInterfaces[interfaceId] = true;
73     }
74 }
75 
76 
77 
78 /**
79  * @title ERC721 Non-Fungible Token Standard basic interface
80  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
81  */
82 
83 contract IERC721 is IERC165 {
84     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
85     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
86     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
87 
88     function balanceOf(address owner) public view returns (uint256 balance);
89     function ownerOf(uint256 tokenId) public view returns (address owner);
90 
91     function approve(address to, uint256 tokenId) public;
92     function getApproved(uint256 tokenId) public view returns (address operator);
93 
94     function setApprovalForAll(address operator, bool _approved) public;
95     function isApprovedForAll(address owner, address operator) public view returns (bool);
96 
97     function transferFrom(address from, address to, uint256 tokenId) public;
98     function safeTransferFrom(address from, address to, uint256 tokenId) public;
99 
100     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
101 }
102 
103 /**
104  * @title ERC721 token receiver interface
105  * @dev Interface for any contract that wants to support safeTransfers
106  * from ERC721 asset contracts.
107  */
108 contract IERC721Receiver {
109     /**
110      * @notice Handle the receipt of an NFT
111      * @dev The ERC721 smart contract calls this function on the recipient
112      * after a `safeTransfer`. This function MUST return the function selector,
113      * otherwise the caller will revert the transaction. The selector to be
114      * returned can be obtained as `this.onERC721Received.selector`. This
115      * function MAY throw to revert and reject the transfer.
116      * Note: the ERC721 contract address is always the message sender.
117      * @param operator The address which called `safeTransferFrom` function
118      * @param from The address which previously owned the token
119      * @param tokenId The NFT identifier which is being transferred
120      * @param data Additional data with no specified format
121      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
122      */
123     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
124     public returns (bytes4);
125 }
126 
127 /**
128  * @title SafeMath
129  * @dev Unsigned math operations with safety checks that revert on error
130  */
131 library SafeMath {
132     /**
133     * @dev Multiplies two unsigned integers, reverts on overflow.
134     */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b);
145 
146         return c;
147     }
148 
149     /**
150     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
151     */
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Solidity only automatically asserts when dividing by 0
154         require(b > 0);
155         uint256 c = a / b;
156         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157 
158         return c;
159     }
160 
161     /**
162     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
163     */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         require(b <= a);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172     * @dev Adds two unsigned integers, reverts on overflow.
173     */
174     function add(uint256 a, uint256 b) internal pure returns (uint256) {
175         uint256 c = a + b;
176         require(c >= a);
177 
178         return c;
179     }
180 
181     /**
182     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
183     * reverts when dividing by zero.
184     */
185     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
186         require(b != 0);
187         return a % b;
188     }
189 }
190 
191 /**
192  * Utility library of inline functions on addresses
193  */
194 library Address {
195     /**
196      * Returns whether the target address is a contract
197      * @dev This function will return false if invoked during the constructor of a contract,
198      * as the code is not actually created until after the constructor finishes.
199      * @param account address of the account to check
200      * @return whether the target address is a contract
201      */
202     function isContract(address account) internal view returns (bool) {
203         uint256 size;
204         // XXX Currently there is no better way to check if there is a contract in an address
205         // than to check the size of the code at that address.
206         // See https://ethereum.stackexchange.com/a/14016/36603
207         // for more details about how this works.
208         // TODO Check this again before the Serenity release, because all addresses will be
209         // contracts then.
210         // solhint-disable-next-line no-inline-assembly
211         assembly { size := extcodesize(account) }
212         return size > 0;
213     }
214 }
215 
216 
217 /**
218  * @title ERC721 Non-Fungible Token Standard basic implementation
219  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
220  */
221 contract FormSI060719 is ERC165, IERC721 {
222     using SafeMath for uint256;
223     using Address for address;
224 
225     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
226     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
227     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
228 
229     // Mapping from token ID to owner
230     mapping (uint256 => address) private _tokenOwner;
231 
232     // Mapping from token ID to approved address
233     mapping (uint256 => address) private _tokenApprovals;
234 
235     // Mapping from owner to number of owned token
236     mapping (address => uint256) private _ownedTokensCount;
237 
238     // Mapping from owner to operator approvals
239     mapping (address => mapping (address => bool)) private _operatorApprovals;
240 
241     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
242     /*
243      * 0x80ac58cd ===
244      *     bytes4(keccak256('balanceOf(address)')) ^
245      *     bytes4(keccak256('ownerOf(uint256)')) ^
246      *     bytes4(keccak256('approve(address,uint256)')) ^
247      *     bytes4(keccak256('getApproved(uint256)')) ^
248      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
249      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
250      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
251      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
252      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
253      */
254 
255     // FORM
256     string private _name = "FormSI060719 :: Garage Politburo Tokens";
257     string private _symbol = "SIGP";
258     string[] private _theFormSI060719;
259     uint256[2][] private _theIndexToQA; //tokeId gives (questionId, textId)
260     uint256[][13] private _theQAtoIndex; // [questionId, textid] gives tokenId
261     uint256 private _totalSupply; 
262     uint256[13] private _supplyPerQ; 
263     uint256 public numberOfQuestions = 13;
264     string[] private _qSection;
265     string private _qForm;
266 
267     
268     // END FORM
269     
270     //AUCTION
271      
272     // Put list element up for sale by owner. Can be linked to specific 
273     // potential buyer
274     struct forSaleInfo {
275         bool isForSale;
276         uint256 tokenId;
277         address seller;
278         uint256 minValue;          //in wei.... everything in wei
279         address onlySellTo;     // specify to sell only to a specific person
280     }
281 
282     // Place bid for specific list element
283     struct bidInfo {
284         bool hasBid;
285         uint256 tokenId;
286         address bidder;
287         uint256 value;
288     }
289 
290     // Public info about tokens for sale.
291     mapping (uint256 => forSaleInfo) public marketForSaleInfoByIndex;
292     // Public info about highest bid for each token.
293     mapping (uint256 => bidInfo) public marketBidInfoByIndex;
294     // Information about withdrawals (in units of wei) available  
295     //  ... for addresses due to failed bids, successful sales, etc...
296     mapping (address => uint256) public marketPendingWithdrawals;
297     
298     //END AUCTION
299     
300     //EVENTS
301     
302     // In addition to Transfer, Approval, and ApprovalForAll IERC721 events
303     event QuestionAnswered(uint256 indexed questionId, uint256 indexed answerId, 
304         address indexed by);
305     event ForSaleDeclared(uint256 indexed tokenId, address indexed from, 
306         uint256 minValue,address indexed to);
307     event ForSaleWithdrawn(uint256 indexed tokenId, address indexed from);
308     event ForSaleBought(uint256 indexed tokenId, uint256 value, 
309         address indexed from, address indexed to);
310     event BidDeclared(uint256 indexed tokenId, uint256 value, 
311         address indexed from);
312     event BidWithdrawn(uint256 indexed tokenId, uint256 value, 
313         address indexed from);
314     event BidAccepted(uint256 indexed tokenId, uint256 value, 
315         address indexed from, address indexed to);
316     
317     //END EVENTS
318 
319     constructor () public {
320         // register the supported interfaces to conform to ERC721 via ERC165
321         _registerInterface(_INTERFACE_ID_ERC721);
322         _qForm = "FormSI060719 :: freeAssociationAndResponse :: ";
323         _qSection.push("Section 0-2b :: ");
324         _qSection.push("Section2-TINA :: ");
325         _qSection.push("Section2b-WS :: ");
326  
327 
328         _theFormSI060719.push("When we ask ourselves \"How are we?\" :: we really want to know ::");
329         _theQAtoIndex[0].push(0);
330         _theIndexToQA.push([0,0]);
331         _tokenOwner[0] = msg.sender;
332         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
333         _supplyPerQ[0] = 1;
334 
335         _theFormSI060719.push("How are we to ensure equitable merit-based access? :: Tried to cut down :: used more than intended :: ");
336         _theQAtoIndex[1].push(1);
337         _theIndexToQA.push([1,0]);
338         _tokenOwner[1] = msg.sender;
339         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
340         _supplyPerQ[1] = 1;
341 
342         _theFormSI060719.push("Psychoanalytic Placement Bureau ::");
343         _theQAtoIndex[2].push(2);
344         _theIndexToQA.push([2,0]);
345         _tokenOwner[2] = msg.sender;
346         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
347         _supplyPerQ[2] = 1;
348 
349         _theFormSI060719.push("Department of Aspirational Hypocrisy :: Anti-Dishumanitarian League ::");
350         _theQAtoIndex[3].push(3);
351         _theIndexToQA.push([3,0]);
352         _tokenOwner[3] = msg.sender;
353         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
354         _supplyPerQ[3] = 1;
355 
356         _theFormSI060719.push("Personhood Amendment :: Homestead 42 ::");
357         _theQAtoIndex[4].push(4);
358         _theIndexToQA.push([4,0]);
359         _tokenOwner[4] = msg.sender;
360         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
361         _supplyPerQ[4] = 1;
362 
363         _theFormSI060719.push("Joint Compensation Office :: Oh how socialists love to make lists ::");
364         _theQAtoIndex[5].push(5);
365         _theIndexToQA.push([5,0]);
366         _tokenOwner[5] = msg.sender;
367         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
368         _supplyPerQ[5] = 1;
369 
370         _theFormSI060719.push("Division of Confetti Drones and Online Community Standards ::");
371         _theQAtoIndex[6].push(6);
372         _theIndexToQA.push([6,0]);
373         _tokenOwner[6] = msg.sender;
374         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
375         _supplyPerQ[6] = 1;
376 
377         _theFormSI060719.push("The Secret Joys of Bureaucracy :: Ministry of Splendid Suns :: Ministry of Plenty :: Crime Bureau :: Aerial Board of Control :: Office of Tabletop Assumption :: Central Committee :: Division of Complicity :: Ministry of Information ::");
378         _theQAtoIndex[7].push(7);
379         _theIndexToQA.push([7,0]);
380         _tokenOwner[7] = msg.sender;
381         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
382         _supplyPerQ[7] = 1;
383 
384         _theFormSI060719.push("We seek droning bureaucracy :: glory :: digital socialist commodities ::");
385         _theQAtoIndex[8].push(8);
386         _theIndexToQA.push([8,0]);
387         _tokenOwner[8] = msg.sender;
388         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
389         _supplyPerQ[8] = 1;
390 
391         _theFormSI060719.push("Bureau of Rage Embetterment :: machines made of sunshine ::");
392         _theQAtoIndex[9].push(9);
393         _theIndexToQA.push([9,0]);
394         _tokenOwner[9] = msg.sender;
395         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
396         _supplyPerQ[9] = 1;
397 
398         _theFormSI060719.push("Office of Agency :: seize the means of bureaucratic production ::");
399         _theQAtoIndex[10].push(10);
400         _theIndexToQA.push([10,0]);
401         _tokenOwner[10] = msg.sender;
402         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
403         _supplyPerQ[10] = 1;
404 
405         _theFormSI060719.push("Garage Politburo :: Boutique Ministry ::");
406         _theQAtoIndex[11].push(11);
407         _theIndexToQA.push([11,0]);
408         _tokenOwner[11] = msg.sender;
409         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
410         _supplyPerQ[11] = 1;
411 
412         _theFormSI060719.push("Grassroots :: Tabletop :: Bureaucracy Saves! ::"); 
413         _theQAtoIndex[12].push(12);
414         _theIndexToQA.push([12,0]);
415         _tokenOwner[12] = msg.sender;
416         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
417         _supplyPerQ[12] = 1;
418 
419         _totalSupply = 13;
420         assert (_totalSupply == numberOfQuestions);
421         assert (_totalSupply == _ownedTokensCount[msg.sender]);
422         
423     }
424 
425     //Begin Form
426 
427 
428     function name() external view returns (string memory){
429        return _name;
430     }
431 
432     function totalSupply() external view returns (uint256){
433        return _totalSupply;
434     }
435 
436 
437     function symbol() external view returns (string memory){
438        return _symbol;
439     }
440 
441 
442     // questionId goes from 0 to numberOfQuestions - 1    
443     function getFormQuestion(uint256 questionId)
444         public view
445         returns (string memory){
446             
447         return (_getQAtext(questionId, 0));
448             
449     }
450     
451     // questionId goes from 0 to numberOfQuestions - 1  
452     // answerId goes from 1 to _supplyPerQ - 1
453     // If there are no answers to questionId, this function reverts
454     function getFormAnswers(uint256 questionId, uint256 answerId)
455         public view
456         returns (string memory){
457             
458         require (answerId > 0);
459         return (_getQAtext(questionId, answerId));
460             
461     }    
462 
463  
464     function _getQAtext(uint256 questionId, uint256 textId)
465         private view 
466         returns (string memory){
467     
468         require (questionId < numberOfQuestions);
469         require (textId < _supplyPerQ[questionId]);
470        
471         if (textId > 0){
472           return (_theFormSI060719[_theQAtoIndex[questionId][textId]]);
473         }
474 
475         else {
476             bytes memory qPrefix;
477             if (questionId <= 1) {
478                 qPrefix = bytes(_qSection[0]);
479             }
480             if ((questionId >= 2) && (questionId <= 6)){
481                 qPrefix = bytes(_qSection[1]);
482             }
483             if (questionId >= 7){
484                 qPrefix = bytes(_qSection[2]);
485             }
486             return (string(abi.encodePacked(bytes(_qForm), qPrefix, 
487                 bytes(_theFormSI060719[_theQAtoIndex[questionId][textId]]))));
488         }
489             
490     }
491       
492      function answerQuestion(uint256 questionId, string calldata answer)
493         external
494         returns (bool){
495 
496         require (questionId < numberOfQuestions);
497         require (bytes(answer).length != 0);
498         _theFormSI060719.push(answer);
499         _totalSupply = _totalSupply.add(1);
500         _supplyPerQ[questionId] = _supplyPerQ[questionId].add(1);
501         _theQAtoIndex[questionId].push(_totalSupply - 1);
502         _theIndexToQA.push([questionId, _supplyPerQ[questionId] - 1]);
503         _tokenOwner[_totalSupply - 1] = msg.sender;
504         _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].add(1);
505         emit QuestionAnswered(questionId, _supplyPerQ[questionId] - 1,
506             msg.sender);
507        return true;
508     }
509     
510     // Returns index of ERC721 token
511     // questionId start with index 0
512     // textId 0 returns the question text associated with questionId
513     // textId 1 returns the first answer to questionId, etc...
514     function getIndexfromQA(uint256 questionId, uint256 textId)
515         public view
516         returns (uint256) {
517             
518         require (questionId < numberOfQuestions);
519         require (textId < _supplyPerQ[questionId]);
520         return _theQAtoIndex[questionId][textId];
521     }
522 
523     // Returns (questionId, textId) 
524     // questionId starts with index 0
525     // textId starts with index 0
526     // textId = 0 corresponds to question text
527     // textId > 0 corresponts to answers
528     
529     function getQAfromIndex(uint256 tokenId)
530         public view
531         returns (uint256[2] memory) {
532             
533         require (tokenId < _totalSupply);
534         return ([_theIndexToQA[tokenId][0] ,_theIndexToQA[tokenId][1]]) ;
535     }
536         
537     function getNumberOfAnswers(uint256 questionId)
538         public view
539         returns (uint256){
540         
541         require (questionId < numberOfQuestions);
542         return (_supplyPerQ[questionId] - 1);
543         
544     }
545     //End Form
546 
547  
548     /**
549      * @dev Gets the balance of the specified address
550      * @param owner address to query the balance of
551      * @return uint256 representing the amount owned by the passed address
552      */
553     function balanceOf(address owner) public view returns (uint256) {
554         require(owner != address(0));
555         return _ownedTokensCount[owner];
556     }
557 
558     /**
559      * @dev Gets the owner of the specified token ID
560      * @param tokenId uint256 ID of the token to query the owner of
561      * @return owner address currently marked as the owner of the given token ID
562      */
563     function ownerOf(uint256 tokenId) public view returns (address) {
564         address owner = _tokenOwner[tokenId];
565         require(owner != address(0));
566         return owner;
567     }
568 
569     /**
570      * @dev Approves another address to transfer the given token ID
571      * The zero address indicates there is no approved address.
572      * There can only be one approved address per token at a given time.
573      * Can only be called by the token owner or an approved operator.
574      * @param to address to be approved for the given token ID
575      * @param tokenId uint256 ID of the token to be approved
576      */
577     function approve(address to, uint256 tokenId) public {
578         address owner = ownerOf(tokenId);
579         require(to != owner);
580         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
581 
582         _tokenApprovals[tokenId] = to;
583         emit Approval(owner, to, tokenId);
584     }
585 
586     /**
587      * @dev Gets the approved address for a token ID, or zero if no address set
588      * Reverts if the token ID does not exist.
589      * @param tokenId uint256 ID of the token to query the approval of
590      * @return address currently approved for the given token ID
591      */
592     function getApproved(uint256 tokenId) public view returns (address) {
593         require(_exists(tokenId));
594         return _tokenApprovals[tokenId];
595     }
596 
597     /**
598      * @dev Sets or unsets the approval of a given operator
599      * An operator is allowed to transfer all tokens of the sender on their behalf
600      * @param to operator address to set the approval
601      * @param approved representing the status of the approval to be set
602      */
603     function setApprovalForAll(address to, bool approved) public {
604         require(to != msg.sender);
605         _operatorApprovals[msg.sender][to] = approved;
606         emit ApprovalForAll(msg.sender, to, approved);
607     }
608 
609     /**
610      * @dev Tells whether an operator is approved by a given owner
611      * @param owner owner address which you want to query the approval of
612      * @param operator operator address which you want to query the approval of
613      * @return bool whether the given operator is approved by the given owner
614      */
615     function isApprovedForAll(address owner, address operator) public view returns (bool) {
616         return _operatorApprovals[owner][operator];
617     }
618 
619     /**
620      * @dev Transfers the ownership of a given token ID to another address
621      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
622      * Requires the msg sender to be the owner, approved, or operator
623      * @param from current owner of the token
624      * @param to address to receive the ownership of the given token ID
625      * @param tokenId uint256 ID of the token to be transferred
626     */
627     function transferFrom(address from, address to, uint256 tokenId) public {
628         // this checks if token exists
629         require(_isApprovedOrOwner(msg.sender, tokenId));
630 
631         // remove for sale, if it exists.
632         if (marketForSaleInfoByIndex[tokenId].isForSale){
633             marketForSaleInfoByIndex[tokenId] = forSaleInfo(false, tokenId, 
634              address(0), 0, address(0));
635             emit ForSaleWithdrawn(tokenId, _tokenOwner[tokenId]);
636         }
637         _transferFrom(from, to, tokenId);
638         
639         // remove bid of recipient (and now new owner), if it exists.
640         // Need to do this since marketWithdrawBid requires that msg.sender not owner.
641         if (marketBidInfoByIndex[tokenId].bidder == to){
642             _clearNewOwnerBid(to, tokenId);
643         }
644     }
645 
646     /**
647      * @dev Safely transfers the ownership of a given token ID to another address
648      * If the target address is a contract, it must implement `onERC721Received`,
649      * which is called upon a safe transfer, and return the magic value
650      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
651      * the transfer is reverted.
652      *
653      * Requires the msg sender to be the owner, approved, or operator
654      * @param from current owner of the token
655      * @param to address to receive the ownership of the given token ID
656      * @param tokenId uint256 ID of the token to be transferred
657     */
658     function safeTransferFrom(address from, address to, uint256 tokenId) public {
659         safeTransferFrom(from, to, tokenId, "");
660     }
661 
662     /**
663      * @dev Safely transfers the ownership of a given token ID to another address
664      * If the target address is a contract, it must implement `onERC721Received`,
665      * which is called upon a safe transfer, and return the magic value
666      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
667      * the transfer is reverted.
668      * Requires the msg sender to be the owner, approved, or operator
669      * @param from current owner of the token
670      * @param to address to receive the ownership of the given token ID
671      * @param tokenId uint256 ID of the token to be transferred
672      * @param _data bytes data to send along with a safe transfer check
673      */
674     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
675         transferFrom(from, to, tokenId);
676         require(_checkOnERC721Received(from, to, tokenId, _data));
677     }
678 
679     /**
680      * @dev Returns whether the specified token exists
681      * @param tokenId uint256 ID of the token to query the existence of
682      * @return whether the token exists
683      */
684     function _exists(uint256 tokenId) internal view returns (bool) {
685         address owner = _tokenOwner[tokenId];
686         return owner != address(0);
687     }
688 
689     /**
690      * @dev Returns whether the given spender can transfer a given token ID
691      * @param spender address of the spender to query
692      * @param tokenId uint256 ID of the token to be transferred
693      * @return bool whether the msg.sender is approved for the given token ID,
694      *    is an operator of the owner, or is the owner of the token
695      */
696     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
697         address owner = ownerOf(tokenId);
698         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
699     }
700 
701 
702 
703     /**
704      * @dev Internal function to transfer ownership of a given token ID to another address.
705      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
706      * @param from current owner of the token
707      * @param to address to receive the ownership of the given token ID
708      * @param tokenId uint256 ID of the token to be transferred
709     */
710     function _transferFrom(address from, address to, uint256 tokenId) internal {
711         require(ownerOf(tokenId) == from);
712         require(to != address(0));
713 
714         _clearApproval(tokenId);
715 
716         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
717         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
718 
719         _tokenOwner[tokenId] = to;
720 
721         emit Transfer(from, to, tokenId);
722     }
723 
724     /**
725      * @dev Internal function to invoke `onERC721Received` on a target address
726      * The call is not executed if the target address is not a contract
727      * @param from address representing the previous owner of the given token ID
728      * @param to target address that will receive the tokens
729      * @param tokenId uint256 ID of the token to be transferred
730      * @param _data bytes optional data to send along with the call
731      * @return whether the call correctly returned the expected magic value
732      */
733     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
734         internal returns (bool)
735     {
736         if (!to.isContract()) {
737             return true;
738         }
739 
740         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
741         return (retval == _ERC721_RECEIVED);
742     }
743 
744     /**
745      * @dev Private function to clear current approval of a given token ID
746      * @param tokenId uint256 ID of the token to be transferred
747      */
748     function _clearApproval(uint256 tokenId) private {
749         if (_tokenApprovals[tokenId] != address(0)) {
750             _tokenApprovals[tokenId] = address(0);
751         }
752     }
753     
754         //MARKET
755 
756     // Let anyone interested know that the owner put a token up for sale. 
757     // Anyone can obtain it by sending an amount of wei equal to or
758     // larger than  _minPriceInWei. 
759     // Only token owner can use this function.
760 
761     function marketDeclareForSale(uint256 tokenId, uint256 minPriceInWei) 
762             external returns (bool){
763         require (_exists(tokenId));
764         require (msg.sender == _tokenOwner[tokenId]);
765         marketForSaleInfoByIndex[tokenId] = forSaleInfo(true, tokenId, 
766             msg.sender, minPriceInWei, address(0));
767         emit ForSaleDeclared(tokenId, msg.sender, minPriceInWei, address(0));
768         return true;
769     }
770     
771     // Let anyone interested know that the owner put a token up for sale. 
772     // Only the address _to can obtain it by sending an amount of wei equal 
773     // to or larger than _minPriceInWei.
774     // Only token owner can use this function.
775 
776     function marketDeclareForSaleToAddress(uint256 tokenId, uint256 
777             minPriceInWei, address to) external returns(bool){
778         require (_exists(tokenId));
779         require (msg.sender == _tokenOwner[tokenId]);
780         marketForSaleInfoByIndex[tokenId] = forSaleInfo(true, tokenId, 
781             msg.sender, minPriceInWei, to);
782         emit ForSaleDeclared(tokenId, msg.sender, minPriceInWei, to);
783         return true;
784     }
785 
786     // Owner no longer wants token for sale, or token has changed owner, 
787     // so previously posted for sale is no longer valid.
788     // Only token owner can use this function.
789 
790     function marketWithdrawForSale(uint256 tokenId) public returns(bool){
791         require (_exists(tokenId));
792         require(msg.sender == _tokenOwner[tokenId]);
793         marketForSaleInfoByIndex[tokenId] = forSaleInfo(false, tokenId, 
794             address(0), 0, address(0));
795         emit ForSaleWithdrawn(tokenId, msg.sender);
796         return true;
797     }
798     
799     // I'll take it. Must send at least as many wei as minValue in 
800     // forSale structure.
801 
802     function marketBuyForSale(uint256 tokenId) payable external returns(bool){
803         require (_exists(tokenId));
804         forSaleInfo storage existingForSale = marketForSaleInfoByIndex[tokenId];
805         require(existingForSale.isForSale);
806         require(existingForSale.onlySellTo == address(0) || 
807             existingForSale.onlySellTo == msg.sender);
808         require(msg.value >= existingForSale.minValue);
809         address seller = _tokenOwner[tokenId];
810         require(existingForSale.seller == seller);
811         _transferFrom(seller, msg.sender, tokenId);
812         // must withdrawal for sale after transfer to make sure msg.sender
813         //  is the current owner.
814         marketWithdrawForSale(tokenId);
815         // clear bid of new owner, if it exists. 
816         if (marketBidInfoByIndex[tokenId].bidder == msg.sender){
817             _clearNewOwnerBid(msg.sender, tokenId);
818         }
819         marketPendingWithdrawals[seller] = marketPendingWithdrawals[seller].add(msg.value);
820         emit ForSaleBought(tokenId, msg.value, seller, msg.sender);
821         return true;
822     }
823     
824     // Potential buyer puts up money for a token.
825 
826     function marketDeclareBid(uint256 tokenId) payable external returns(bool){
827         require (_exists(tokenId));
828         require (_tokenOwner[tokenId] != msg.sender);
829         require (msg.value > 0);
830         bidInfo storage existingBid = marketBidInfoByIndex[tokenId];
831         // Keep only the highest bid.
832         require (msg.value > existingBid.value);
833         if (existingBid.value > 0){             
834             marketPendingWithdrawals[existingBid.bidder] = 
835             marketPendingWithdrawals[existingBid.bidder].add(existingBid.value);
836         }
837         marketBidInfoByIndex[tokenId] = bidInfo(true, tokenId, 
838             msg.sender, msg.value);
839         emit BidDeclared(tokenId, msg.value, msg.sender);
840         return true;
841     }
842     
843     // Potential buyer changes mind and withdrawals bid.
844 
845     function marketWithdrawBid(uint256 tokenId) external returns(bool){
846         require (_exists(tokenId));
847         require (_tokenOwner[tokenId] != msg.sender); 
848         bidInfo storage existingBid = marketBidInfoByIndex[tokenId];
849         require (existingBid.hasBid);
850         require (existingBid.bidder == msg.sender);
851         uint256 amount = existingBid.value;
852         // Refund
853         marketPendingWithdrawals[existingBid.bidder] =
854             marketPendingWithdrawals[existingBid.bidder].add(amount);
855         marketBidInfoByIndex[tokenId] = bidInfo(false, tokenId, address(0), 0);
856         emit BidWithdrawn(tokenId, amount, msg.sender);
857         return true;
858     }
859     
860     // Owner accepts bid, and money and token change hands. All money in wei.
861     // Only token owner can use this function.
862 
863     function marketAcceptBid(uint256 tokenId, uint256 minPrice) 
864             external returns(bool){
865         require (_exists(tokenId));
866         address seller = _tokenOwner[tokenId];
867         require (seller == msg.sender);
868         bidInfo storage existingBid = marketBidInfoByIndex[tokenId];
869         require (existingBid.hasBid);
870         require (existingBid.value >= minPrice);
871         address buyer = existingBid.bidder;
872         // Remove for sale while msg.sender still owner or approved.
873         marketWithdrawForSale(tokenId);
874         _transferFrom (seller, buyer, tokenId);
875         uint256 amount = existingBid.value;
876         // Remove bid.
877         marketBidInfoByIndex[tokenId] = bidInfo(false, tokenId, address(0),0);
878         marketPendingWithdrawals[seller] = marketPendingWithdrawals[seller].add(amount);
879         emit BidAccepted(tokenId, amount, seller, buyer);
880         return true;
881     }
882     
883     // Retrieve money to successful sale, failed bid, withdrawn bid, etc.
884     //  All in wei. Note that refunds, income, etc. are NOT automatically
885     // deposited in the user's address. The user must withdraw the funds.
886 
887     function marketWithdrawWei() external returns(bool) {
888        uint256 amount = marketPendingWithdrawals[msg.sender];
889        require (amount > 0);
890        marketPendingWithdrawals[msg.sender] = 0;
891        msg.sender.transfer(amount);
892        return true;
893     } 
894 
895     // Clears bid when become owner changes via forSaleBuy or transferFrom.
896     
897     function _clearNewOwnerBid(address to, uint256 tokenId) internal {
898 
899         uint256 amount = marketBidInfoByIndex[tokenId].value;
900         marketBidInfoByIndex[tokenId] = bidInfo(false, tokenId, 
901             address(0), 0);
902         marketPendingWithdrawals[to] = marketPendingWithdrawals[to].add(amount);
903         emit BidWithdrawn(tokenId, amount, to);
904 
905       
906     }
907     
908     
909     //END MARKET
910     
911     
912 
913 }