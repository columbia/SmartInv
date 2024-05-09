1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title ERC721 interface
7  * @dev see https://github.com/ethereum/eips/issues/721
8  */
9 contract ERC721 {
10   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
11   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
12 
13   function balanceOf(address _owner) public view returns (uint256 _balance);
14   function ownerOf(uint256 _tokenId) public view returns (address _owner);
15   function transfer(address _to, uint256 _tokenId) public;
16   function approve(address _to, uint256 _tokenId) public;
17   function takeOwnership(uint256 _tokenId) public;
18 }
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   /**
49   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256) {
60     uint256 c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 
67 /**
68  * @title ERC721Token
69  * Generic implementation for the required functionality of the ERC721 standard
70  */
71 contract ERC721Token is ERC721 {
72   using SafeMath for uint256;
73 
74   // Total amount of tokens
75   uint256 private totalTokens;
76 
77   // Mapping from token ID to owner
78   mapping (uint256 => address) private tokenOwner;
79 
80   // Mapping from token ID to approved address
81   mapping (uint256 => address) private tokenApprovals;
82 
83   // Mapping from owner to list of owned token IDs
84   mapping (address => uint256[]) private ownedTokens;
85 
86   // Mapping from token ID to index of the owner tokens list
87   mapping(uint256 => uint256) private ownedTokensIndex;
88 
89   /**
90   * @dev Guarantees msg.sender is owner of the given token
91   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
92   */
93   modifier onlyOwnerOf(uint256 _tokenId) {
94     require(ownerOf(_tokenId) == msg.sender);
95     _;
96   }
97 
98   /**
99   * @dev Gets the total amount of tokens stored by the contract
100   * @return uint256 representing the total amount of tokens
101   */
102   function totalSupply() public view returns (uint256) {
103     return totalTokens;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address
108   * @param _owner address to query the balance of
109   * @return uint256 representing the amount owned by the passed address
110   */
111   function balanceOf(address _owner) public view returns (uint256) {
112     return ownedTokens[_owner].length;
113   }
114 
115   /**
116   * @dev Gets the list of tokens owned by a given address
117   * @param _owner address to query the tokens of
118   * @return uint256[] representing the list of tokens owned by the passed address
119   */
120   function tokensOf(address _owner) public view returns (uint256[]) {
121     return ownedTokens[_owner];
122   }
123 
124   /**
125   * @dev Gets the owner of the specified token ID
126   * @param _tokenId uint256 ID of the token to query the owner of
127   * @return owner address currently marked as the owner of the given token ID
128   */
129   function ownerOf(uint256 _tokenId) public view returns (address) {
130     address owner = tokenOwner[_tokenId];
131     require(owner != address(0));
132     return owner;
133   }
134 
135   /**
136    * @dev Gets the approved address to take ownership of a given token ID
137    * @param _tokenId uint256 ID of the token to query the approval of
138    * @return address currently approved to take ownership of the given token ID
139    */
140   function approvedFor(uint256 _tokenId) public view returns (address) {
141     return tokenApprovals[_tokenId];
142   }
143 
144   /**
145   * @dev Transfers the ownership of a given token ID to another address
146   * @param _to address to receive the ownership of the given token ID
147   * @param _tokenId uint256 ID of the token to be transferred
148   */
149   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
150     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
151   }
152 
153   /**
154   * @dev Approves another address to claim for the ownership of the given token ID
155   * @param _to address to be approved for the given token ID
156   * @param _tokenId uint256 ID of the token to be approved
157   */
158   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
159     address owner = ownerOf(_tokenId);
160     require(_to != owner);
161     if (approvedFor(_tokenId) != 0 || _to != 0) {
162       tokenApprovals[_tokenId] = _to;
163       Approval(owner, _to, _tokenId);
164     }
165   }
166 
167   /**
168   * @dev Claims the ownership of a given token ID
169   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
170   */
171   function takeOwnership(uint256 _tokenId) public {
172     require(isApprovedFor(msg.sender, _tokenId));
173     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
174   }
175 
176   /**
177   * @dev Mint token function
178   * @param _to The address that will own the minted token
179   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
180   */
181   function _mint(address _to, uint256 _tokenId) internal {
182     require(_to != address(0));
183     addToken(_to, _tokenId);
184     Transfer(0x0, _to, _tokenId);
185   }
186 
187   /**
188   * @dev Burns a specific token
189   * @param _tokenId uint256 ID of the token being burned by the msg.sender
190   */
191   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
192     if (approvedFor(_tokenId) != 0) {
193       clearApproval(msg.sender, _tokenId);
194     }
195     removeToken(msg.sender, _tokenId);
196     Transfer(msg.sender, 0x0, _tokenId);
197   }
198 
199   /**
200    * @dev Tells whether the msg.sender is approved for the given token ID or not
201    * This function is not private so it can be extended in further implementations like the operatable ERC721
202    * @param _owner address of the owner to query the approval of
203    * @param _tokenId uint256 ID of the token to query the approval of
204    * @return bool whether the msg.sender is approved for the given token ID or not
205    */
206   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
207     return approvedFor(_tokenId) == _owner;
208   }
209 
210   /**
211   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
212   * @param _from address which you want to send tokens from
213   * @param _to address which you want to transfer the token to
214   * @param _tokenId uint256 ID of the token to be transferred
215   */
216   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
217     require(_to != address(0));
218     require(_to != ownerOf(_tokenId));
219     require(ownerOf(_tokenId) == _from);
220 
221     clearApproval(_from, _tokenId);
222     removeToken(_from, _tokenId);
223     addToken(_to, _tokenId);
224     Transfer(_from, _to, _tokenId);
225   }
226 
227   /**
228   * @dev Internal function to clear current approval of a given token ID
229   * @param _tokenId uint256 ID of the token to be transferred
230   */
231   function clearApproval(address _owner, uint256 _tokenId) private {
232     require(ownerOf(_tokenId) == _owner);
233     tokenApprovals[_tokenId] = 0;
234     Approval(_owner, 0, _tokenId);
235   }
236 
237   /**
238   * @dev Internal function to add a token ID to the list of a given address
239   * @param _to address representing the new owner of the given token ID
240   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
241   */
242   function addToken(address _to, uint256 _tokenId) private {
243     require(tokenOwner[_tokenId] == address(0));
244     tokenOwner[_tokenId] = _to;
245     uint256 length = balanceOf(_to);
246     ownedTokens[_to].push(_tokenId);
247     ownedTokensIndex[_tokenId] = length;
248     totalTokens = totalTokens.add(1);
249   }
250 
251   /**
252   * @dev Internal function to remove a token ID from the list of a given address
253   * @param _from address representing the previous owner of the given token ID
254   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
255   */
256   function removeToken(address _from, uint256 _tokenId) private {
257     require(ownerOf(_tokenId) == _from);
258 
259     uint256 tokenIndex = ownedTokensIndex[_tokenId];
260     uint256 lastTokenIndex = balanceOf(_from).sub(1);
261     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
262 
263     tokenOwner[_tokenId] = 0;
264     ownedTokens[_from][tokenIndex] = lastToken;
265     ownedTokens[_from][lastTokenIndex] = 0;
266     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
267     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
268     // the lastToken to the first position, and then dropping the element placed in the last position of the list
269 
270     ownedTokens[_from].length--;
271     ownedTokensIndex[_tokenId] = 0;
272     ownedTokensIndex[lastToken] = tokenIndex;
273     totalTokens = totalTokens.sub(1);
274   }
275 }
276 
277 
278 
279 /**
280  * @title Ownable
281  * @dev The Ownable contract has an owner address, and provides basic authorization control
282  * functions, this simplifies the implementation of "user permissions".
283  */
284 contract Ownable {
285   address public owner;
286 
287 
288   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290 
291   /**
292    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
293    * account.
294    */
295   function Ownable() public {
296     owner = msg.sender;
297   }
298 
299   /**
300    * @dev Throws if called by any account other than the owner.
301    */
302   modifier onlyOwner() {
303     require(msg.sender == owner);
304     _;
305   }
306 
307   /**
308    * @dev Allows the current owner to transfer control of the contract to a newOwner.
309    * @param newOwner The address to transfer ownership to.
310    */
311   function transferOwnership(address newOwner) public onlyOwner {
312     require(newOwner != address(0));
313     OwnershipTransferred(owner, newOwner);
314     owner = newOwner;
315   }
316 
317 }
318 
319 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
320 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
321 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
322 interface ERC721Metadata /* is ERC721 */ {
323   /// @notice A descriptive name for a collection of NFTs in this contract
324   function name() external pure returns (string _name);
325 
326   /// @notice An abbreviated name for NFTs in this contract
327   function symbol() external pure returns (string _symbol);
328 
329   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
330   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
331   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
332   ///  Metadata JSON Schema".
333   function tokenURI(uint256 _tokenId) external view returns (string);
334 }
335 
336 
337 contract SupeRare is ERC721Token, Ownable, ERC721Metadata {
338     using SafeMath for uint256;
339     
340     // Percentage to owner of SupeRare. (* 10) to allow for < 1% 
341     uint256 public maintainerPercentage = 30; 
342     
343     // Percentage to creator of artwork. (* 10) to allow for tens decimal. 
344     uint256 public creatorPercentage = 100; 
345     
346     // Mapping from token ID to the address bidding
347     mapping(uint256 => address) private tokenBidder;
348 
349     // Mapping from token ID to the current bid amount
350     mapping(uint256 => uint256) private tokenCurrentBid;
351     
352     // Mapping from token ID to the owner sale price
353     mapping(uint256 => uint256) private tokenSalePrice;
354 
355     // Mapping from token ID to the creator's address
356     mapping(uint256 => address) private tokenCreator;
357   
358     // Mapping from token ID to the metadata uri
359     mapping(uint256 => string) private tokenToURI;
360     
361     // Mapping from metadata uri to the token ID
362     mapping(string => uint256) private uriOriginalToken;
363     
364     // Mapping from token ID to whether the token has been sold before.
365     mapping(uint256 => bool) private tokenSold;
366 
367     // Mapping of address to boolean indicating whether the add
368     mapping(address => bool) private creatorWhitelist;
369 
370 
371     event WhitelistCreator(address indexed _creator);
372     event Bid(address indexed _bidder, uint256 indexed _amount, uint256 indexed _tokenId);
373     event AcceptBid(address indexed _bidder, address indexed _seller, uint256 _amount, uint256 indexed _tokenId);
374     event CancelBid(address indexed _bidder, uint256 indexed _amount, uint256 indexed _tokenId);
375     event Sold(address indexed _buyer, address indexed _seller, uint256 _amount, uint256 indexed _tokenId);
376     event SalePriceSet(uint256 indexed _tokenId, uint256 indexed _price);
377 
378     /**
379      * @dev Guarantees _uri has not been used with a token already
380      * @param _uri string of the metadata uri associated with the token
381      */
382     modifier uniqueURI(string _uri) {
383         require(uriOriginalToken[_uri] == 0);
384         _;
385     }
386 
387     /**
388      * @dev Guarantees msg.sender is not the owner of the given token
389      * @param _tokenId uint256 ID of the token to validate its ownership does not belongs to msg.sender
390      */
391     modifier notOwnerOf(uint256 _tokenId) {
392         require(ownerOf(_tokenId) != msg.sender);
393         _;
394     }
395 
396     /**
397      * @dev Guarantees msg.sender is a whitelisted creator of SupeRare
398      */
399     modifier onlyCreator() {
400         require(creatorWhitelist[msg.sender] == true);
401         _;
402     }
403 
404     /**
405      * @dev Transfers the ownership of a given token ID to another address.
406      * Sets the token to be on its second sale.
407      * @param _to address to receive the ownership of the given token ID
408      * @param _tokenId uint256 ID of the token to be transferred
409      */
410     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
411         tokenSold[_tokenId] = true;
412         tokenSalePrice[_tokenId] = 0;
413         clearApprovalAndTransfer(msg.sender, _to, _tokenId);
414     }
415 
416     /**
417      * @dev Adds a new unique token to the supply
418      * @param _uri string metadata uri associated with the token
419      */
420     function addNewToken(string _uri) public uniqueURI(_uri) onlyCreator {
421         uint256 newId = createToken(_uri, msg.sender);
422         uriOriginalToken[_uri] = newId;
423     }
424 
425     /**
426      * @dev Adds a new unique token to the supply with N editions. The sale price is set for all editions
427      * @param _uri string metadata uri associated with the token.
428      * @param _editions uint256 number of editions to create.
429      * @param _salePrice uint256 wei price of editions.
430      */
431     function addNewTokenWithEditions(string _uri, uint256 _editions, uint256 _salePrice) public uniqueURI(_uri) onlyCreator {
432       uint256 originalId = createToken(_uri, msg.sender);
433       uriOriginalToken[_uri] = originalId;
434 
435       for (uint256 i=0; i<_editions; i++){
436         uint256 newId = createToken(_uri, msg.sender);
437         tokenSalePrice[newId] = _salePrice;
438         SalePriceSet(newId, _salePrice);
439       }
440     }
441 
442     /**
443     * @dev Bids on the token, replacing the bid if the bid is higher than the current bid. You cannot bid on a token you already own.
444     * @param _tokenId uint256 ID of the token to bid on
445     */
446     function bid(uint256 _tokenId) public payable notOwnerOf(_tokenId) {
447         require(isGreaterBid(_tokenId));
448         returnCurrentBid(_tokenId);
449         tokenBidder[_tokenId] = msg.sender;
450         tokenCurrentBid[_tokenId] = msg.value;
451         Bid(msg.sender, msg.value, _tokenId);
452     }
453 
454     /**
455      * @dev Accept the bid on the token, transferring ownership to the current bidder and paying out the owner.
456      * @param _tokenId uint256 ID of the token with the standing bid
457      */
458     function acceptBid(uint256 _tokenId) public onlyOwnerOf(_tokenId) {
459         uint256 currentBid = tokenCurrentBid[_tokenId];
460         address currentBidder = tokenBidder[_tokenId];
461         address tokenOwner = ownerOf(_tokenId);
462         address creator = tokenCreator[_tokenId];
463         clearApprovalAndTransfer(msg.sender, currentBidder, _tokenId);
464         payout(currentBid, owner, creator, tokenOwner, _tokenId);
465         clearBid(_tokenId);
466         AcceptBid(currentBidder, tokenOwner, currentBid, _tokenId);
467         tokenSalePrice[_tokenId] = 0;
468     }
469     
470     /**
471      * @dev Cancels the bid on the token, returning the bid amount to the bidder.
472      * @param _tokenId uint256 ID of the token with a bid
473      */
474     function cancelBid(uint256 _tokenId) public {
475         address bidder = tokenBidder[_tokenId];
476         require(msg.sender == bidder);
477         uint256 bidAmount = tokenCurrentBid[_tokenId];
478         msg.sender.transfer(bidAmount);
479         clearBid(_tokenId);
480         CancelBid(bidder, bidAmount, _tokenId);
481     }
482     
483     /**
484      * @dev Purchase the token if there is a sale price; transfers ownership to buyer and pays out owner.
485      * @param _tokenId uint256 ID of the token to be purchased
486      */
487     function buy(uint256 _tokenId) public payable notOwnerOf(_tokenId) {
488         uint256 salePrice = tokenSalePrice[_tokenId];
489         uint256 sentPrice = msg.value;
490         address buyer = msg.sender;
491         address tokenOwner = ownerOf(_tokenId);
492         address creator = tokenCreator[_tokenId];
493         require(salePrice > 0);
494         require(sentPrice >= salePrice);
495         returnCurrentBid(_tokenId);
496         clearBid(_tokenId);
497         clearApprovalAndTransfer(tokenOwner, buyer, _tokenId);
498         payout(sentPrice, owner, creator, tokenOwner, _tokenId);
499         tokenSalePrice[_tokenId] = 0;
500         Sold(buyer, tokenOwner, sentPrice, _tokenId);
501     }
502 
503     /**
504      * @dev Set the sale price of the token
505      * @param _tokenId uint256 ID of the token with the standing bid
506      */
507     function setSalePrice(uint256 _tokenId, uint256 _salePrice) public onlyOwnerOf(_tokenId) {
508         uint256 currentBid = tokenCurrentBid[_tokenId];
509         require(_salePrice > currentBid);
510         tokenSalePrice[_tokenId] = _salePrice;
511         SalePriceSet(_tokenId, _salePrice);
512     }
513 
514     /**
515      * @dev Adds the provided address to the whitelist of creators
516      * @param _creator address to be added to the whitelist
517      */
518     function whitelistCreator(address _creator) public onlyOwner {
519       creatorWhitelist[_creator] = true;
520       WhitelistCreator(_creator);
521     }
522     
523     /**
524      * @dev Set the maintainer Percentage. Needs to be 10 * target percentage
525      * @param _percentage uint256 percentage * 10.
526      */
527     function setMaintainerPercentage(uint256 _percentage) public onlyOwner() {
528        maintainerPercentage = _percentage;
529     }
530     
531     /**
532      * @dev Set the creator Percentage. Needs to be 10 * target percentage
533      * @param _percentage uint256 percentage * 10.
534      */
535     function setCreatorPercentage(uint256 _percentage) public onlyOwner() {
536        creatorPercentage = _percentage;
537     }
538     
539     /**
540      * @notice A descriptive name for a collection of NFTs in this contract
541      */
542     function name() external pure returns (string _name) {
543         return 'SupeRare';
544     }
545 
546     /**
547      * @notice An abbreviated name for NFTs in this contract
548      */
549     function symbol() external pure returns (string _symbol) {
550         return 'SUPR';
551     }
552 
553     /**
554      * @notice approve is not a supported function for this contract
555      */
556     function approve(address _to, uint256 _tokenId) public {
557         revert();
558     }
559 
560     /** 
561      * @dev Returns whether the creator is whitelisted
562      * @param _creator address to check
563      * @return bool 
564      */
565     function isWhitelisted(address _creator) external view returns (bool) {
566       return creatorWhitelist[_creator];
567     }
568 
569     /** 
570      * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
571      * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
572      * 3986. The URI may point to a JSON file that conforms to the "ERC721
573      * Metadata JSON Schema".
574      */
575     function tokenURI(uint256 _tokenId) external view returns (string) {
576         ownerOf(_tokenId);
577         return tokenToURI[_tokenId];
578     }
579 
580     /**
581     * @dev Gets the specified token ID of the uri. It only
582     * returns ids of originals.
583     * Throw if not connected to a token ID.
584     * @param _uri string uri of metadata
585     * @return uint256 token ID
586     */
587     function originalTokenOfUri(string _uri) public view returns (uint256) {
588         uint256 tokenId = uriOriginalToken[_uri];
589         ownerOf(tokenId);
590         return tokenId;
591     }
592 
593     /**
594     * @dev Gets the current bid and bidder of the token
595     * @param _tokenId uint256 ID of the token to get bid details
596     * @return bid amount and bidder address of token
597     */
598     function currentBidDetailsOfToken(uint256 _tokenId) public view returns (uint256, address) {
599         return (tokenCurrentBid[_tokenId], tokenBidder[_tokenId]);
600     }
601 
602     /**
603     * @dev Gets the creator of the token
604     * @param _tokenId uint256 ID of the token
605     * @return address of the creator
606     */
607     function creatorOfToken(uint256 _tokenId) public view returns (address) {
608         return tokenCreator[_tokenId];
609     }
610     
611     /**
612     * @dev Gets the sale price of the token
613     * @param _tokenId uint256 ID of the token
614     * @return sale price of the token
615     */
616     function salePriceOfToken(uint256 _tokenId) public view returns (uint256) {
617         return tokenSalePrice[_tokenId];
618     }
619     
620     /**
621     * @dev Internal function to return funds to current bidder.
622     * @param _tokenId uint256 ID of the token with the standing bid
623     */
624     function returnCurrentBid(uint256 _tokenId) private {
625         uint256 currentBid = tokenCurrentBid[_tokenId];
626         address currentBidder = tokenBidder[_tokenId];
627         if(currentBidder != address(0)) {
628             currentBidder.transfer(currentBid);
629         }
630     }
631     
632     /**
633     * @dev Internal function to check that the bid is larger than current bid
634     * @param _tokenId uint256 ID of the token with the standing bid
635     */
636     function isGreaterBid(uint256 _tokenId) private view returns (bool) {
637         return msg.value > tokenCurrentBid[_tokenId];
638     }
639     
640     /**
641     * @dev Internal function to clear bid
642     * @param _tokenId uint256 ID of the token with the standing bid
643     */
644     function clearBid(uint256 _tokenId) private {
645         tokenBidder[_tokenId] = address(0);
646         tokenCurrentBid[_tokenId] = 0;
647     }
648     
649     /**
650     * @dev Internal function to pay the bidder, creator, and maintainer
651     * @param _val uint256 value to be split
652     * @param _maintainer address of account maintaining SupeRare
653     * @param _creator address of the creator of token
654     * @param _maintainer address of the owner of token
655     */
656     function payout(uint256 _val, address _maintainer, address _creator, address _tokenOwner, uint256 _tokenId) private {
657         uint256 maintainerPayment;
658         uint256 creatorPayment;
659         uint256 ownerPayment;
660         if (tokenSold[_tokenId]) {
661             maintainerPayment = _val.mul(maintainerPercentage).div(1000);
662             creatorPayment = _val.mul(creatorPercentage).div(1000);
663             ownerPayment = _val.sub(creatorPayment).sub(maintainerPayment); 
664         } else {
665             maintainerPayment = 0;
666             creatorPayment = _val;
667             ownerPayment = 0;
668             tokenSold[_tokenId] = true;
669         }
670         _maintainer.transfer(maintainerPayment);
671         _creator.transfer(creatorPayment);
672         _tokenOwner.transfer(ownerPayment);
673       
674     }
675 
676     /**
677      * @dev Internal function creating a new token.
678      * @param _uri string metadata uri associated with the token
679      */
680     function createToken(string _uri, address _creator) private  returns (uint256){
681       uint256 newId = totalSupply() + 1;
682       _mint(_creator, newId);
683       tokenCreator[newId] = _creator;
684       tokenToURI[newId] = _uri;
685       return newId;
686     }
687 
688 }