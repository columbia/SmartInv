1 pragma solidity ^0.4.21;
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author CryptoCollector
5 contract ERC721 {
6   // Required methods
7   function approve(address _to, uint256 _tokenId) public;
8   function balanceOf(address _owner) public view returns (uint256 balance);
9   function implementsERC721() public pure returns (bool);
10   function ownerOf(uint256 _tokenId) public view returns (address addr);
11   function takeOwnership(uint256 _tokenId) public;
12   function totalSupply() public view returns (uint256 total);
13   function transferFrom(address _from, address _to, uint256 _tokenId) public;
14   function transfer(address _to, uint256 _tokenId) public;
15 
16   event Transfer(address indexed from, address indexed to, uint256 tokenId);
17   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
18 
19   // Optional
20   // function name() public view returns (string name);
21   // function symbol() public view returns (string symbol);
22   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
23   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
24 }
25 
26 contract Ownable {
27     
28 	  // The addresses of the accounts (or contracts) that can execute actions within each roles.
29 	address public hostAddress;
30 	address public adminAddress;
31     
32     function Ownable() public {
33 		hostAddress = msg.sender;
34 		adminAddress = msg.sender;
35     }
36 
37     modifier onlyHost() {
38         require(msg.sender == hostAddress); 
39         _;
40     }
41 	
42     modifier onlyAdmin() {
43         require(msg.sender == adminAddress);
44         _;
45     }
46 	
47 	/// Access modifier for contract owner only functionality
48 	modifier onlyHostOrAdmin() {
49 		require(
50 		  msg.sender == hostAddress ||
51 		  msg.sender == adminAddress
52 		);
53 		_;
54 	}
55 
56 	function setHost(address _newHost) public onlyHost {
57 		require(_newHost != address(0));
58 
59 		hostAddress = _newHost;
60 	}
61     
62 	function setAdmin(address _newAdmin) public onlyHost {
63 		require(_newAdmin != address(0));
64 
65 		adminAddress = _newAdmin;
66 	}
67 }
68  
69 contract CryptoCollectorContract is ERC721, Ownable {
70         
71     /*** EVENTS ***/
72         
73     /// @dev The NewHero event is fired whenever a new card comes into existence.
74     event NewToken(uint256 tokenId, string name, address owner);
75         
76     /// @dev The NewTokenOwner event is fired whenever a token is sold.
77     event NewTokenOwner(uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name, uint256 tokenId);
78     
79     /// @dev The NewWildCard event is fired whenever a wild card is change.
80     event NewWildToken(uint256 wildcardPayment);
81         
82     /// @dev Transfer event as defined in current draft of ERC721. ownership is assigned, including births.
83     event Transfer(address from, address to, uint256 tokenId);
84         
85     /*** CONSTANTS ***/
86       
87     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
88     string public constant NAME = "CryptoCollectorContract"; // solhint-disable-line
89     string public constant SYMBOL = "CCC"; // solhint-disable-line
90       
91 	uint256 private killerPriceConversionFee = 0.19 ether; 
92 	
93     uint256 private startingPrice = 0.002 ether; 
94     uint256 private firstStepLimit =  0.045 ether; //5 iteration
95     uint256 private secondStepLimit =  0.45 ether; //8 iteration
96     uint256 private thirdStepLimit = 1.00 ether; //10 iteration
97         
98     /*** STORAGE ***/
99         
100     /// @dev A mapping from card IDs to the address that owns them. All cards have
101     ///  some valid owner address.
102     mapping (uint256 => address) public cardTokenToOwner;
103         
104     // @dev A mapping from owner address to count of tokens that address owns.
105     //  Used internally inside balanceOf() to resolve ownership count.
106     mapping (address => uint256) private ownershipTokenCount;
107         
108     /// @dev A mapping from CardIDs to an address that has been approved to call
109     ///  transferFrom(). Each card can only have one approved address for transfer
110     ///  at any time. A zero value means no approval is outstanding.
111     mapping (uint256 => address) public cardTokenToApproved;
112         
113     // @dev A mapping from CardIDs to the price of the token.
114     mapping (uint256 => uint256) private cardTokenToPrice;
115         
116     // @dev A mapping from CardIDs to the position of the item in array.
117     mapping (uint256 => uint256) private cardTokenToPosition;
118     
119     //@dev A mapping for user list
120     mapping (address => uint256) public userArreyPosition;
121     
122     // @dev A mapping from CardIDs to the position of the item in array.
123     mapping (uint256 => uint256) private categoryToPosition;
124      
125     
126     // @dev tokenId of Wild Card.
127     uint256 public wildcardTokenId;
128     
129     /*** STORAGE ***/
130     
131 	/*** ------------------------------- ***/
132     
133     /*** CARDS ***/
134     
135 	/*** DATATYPES ***/
136 	struct Card {
137 		uint256 token;
138 		string name;
139 		string imagepath;
140 		string category;
141 		uint256 Iswildcard;
142 		address owner;
143 		
144 	}
145 
146     struct CardUser {
147 		string name;
148 		string email;
149 	}
150     struct Category {
151         uint256 id;
152 		string name;
153 	}
154 	Card[] private cards;
155     CardUser[] private cardusers;
156     Category[] private categories;
157     
158     
159 	/// @notice Returns all the relevant information about a specific card.
160 	/// @param _tokenId The tokenId of the card of interest.
161 	function getCard(uint256 _tokenId) public view returns (
162 		string name,
163 		uint256 token,
164 		uint256 price,
165 		uint256 nextprice,
166 		string imagepath,
167 		string category,
168 		uint256 wildcard,
169 		address _owner
170 	) {
171 	    
172 	    //address owner = cardTokenToOwner[_tokenId];
173         //require(owner != address(0));
174 	    
175 	    uint256 index = cardTokenToPosition[_tokenId];
176 	    Card storage card = cards[index];
177 		name = card.name;
178 		token = card.token;
179 		price= getNextPrice( cardTokenToPrice[_tokenId]);
180 		nextprice=getNextPrice(price);
181 		imagepath=card.imagepath;
182 		category=card.category;
183 		wildcard=card.Iswildcard;
184 		_owner=card.owner;
185 		
186 	}
187     
188     /// @dev Creates a new token with the given name.
189 	function createToken(string _name,string _imagepath,string _category, uint256 _id) public onlyAdmin {
190 		_createToken(_name,_imagepath,_category, _id, address(this), startingPrice,0);
191 	}
192 	
193 	function getkillerPriceConversionFee() public view returns(uint256 fee) {
194 		return killerPriceConversionFee;
195 		
196 	}
197 	
198 	function getAdmin() public view returns(address _admin) {
199 		return adminAddress  ;
200 	}
201 	/// @dev set Wild card token.
202 	function makeWildCardToken(uint256 tokenId) public payable {
203 
204         require(msg.value == killerPriceConversionFee);		
205 		//Start New Code--for making wild card for each category
206 		uint256 index = cardTokenToPosition[tokenId];
207 	    //Card storage card = cards[index];
208 	    string storage cardCategory=cards[index].category;
209 	    uint256 totalCards = totalSupply();
210         uint256 i=0;
211           for (i = 0; i  <= totalCards-1; i++) {
212             //check for the same category
213             //StringUtils
214             if (keccak256(cards[i].category)==keccak256(cardCategory)){
215                cards[i].Iswildcard=0;
216             }
217           }
218 		cards[index].Iswildcard=1;
219 		//End New Code--
220 		
221 		//msg.sender.transfer(killerPriceConversionFee);
222 		//address(this).transfer(killerPriceConversionFee);
223 		//emit NewWildToken(wildcardTokenId);
224 	}
225     /// @dev set wild card token.
226 	function setWildCardToken(uint256 tokenId) public onlyAdmin {
227 
228 		//Start New Code--for making wild card for each category
229 		uint256 index = cardTokenToPosition[tokenId];
230 	    //Card storage card = cards[index];
231 	    string storage cardCategory=cards[index].category;
232 	    uint256 totalCards = totalSupply();
233         uint256 i=0;
234           for (i = 0; i  <= totalCards-1; i++) {
235             //check for the same category
236             //StringUtils
237             if (keccak256(cards[i].category)==keccak256(cardCategory)){
238                cards[i].Iswildcard=0;
239             }
240           }
241 		cards[index].Iswildcard=1;
242 		//End New Code--
243 		
244 		wildcardTokenId = tokenId;
245 		emit NewWildToken(wildcardTokenId);
246 	}
247 	
248 	function IsWildCardCreatedForCategory(string _category) public view returns (bool){
249 		bool iscreated=false;
250 		uint256 totalCards = totalSupply();
251         uint256 i=0;
252           for (i = 0; i  <= totalCards-1; i++) {
253             //check for the same category
254             if ((keccak256(cards[i].category)==keccak256(_category)) && (cards[i].Iswildcard==1)){
255 			   iscreated=true;
256             }
257           }
258 		return iscreated;
259 	}
260 	
261 	function unsetWildCardToken(uint256 tokenId) public onlyAdmin {
262 		
263 		//Start New Code--for making wild card for each category
264 		uint256 index = cardTokenToPosition[tokenId];
265 	    //Card storage card = cards[index];
266 	    string storage cardCategory=cards[index].category;
267 	    uint256 totalCards = totalSupply();
268         uint256 i=0;
269           for (i = 0; i  <= totalCards-1; i++) {
270             //check for the same category
271             if (keccak256(cards[i].category)==keccak256(cardCategory)){
272                cards[i].Iswildcard=0;
273             }
274           }
275 		//End New Code--
276 		wildcardTokenId = tokenId;
277 		emit NewWildToken(wildcardTokenId);
278 	}
279 	
280 	function getUser(address _owner) public view returns(
281 	    string name,
282 	    string email,
283 	    uint256 position) 
284 	    {
285 	    uint256 index = userArreyPosition[_owner];
286 	    CardUser storage user = cardusers[index];
287 		name=user.name;
288 		email=user.email;
289 		position=index;
290 	    
291 	} 
292 	function totUsers() public view returns(uint256){
293 	    return cardusers.length;
294 	}
295 	function adduser(string _name,string _email,address userAddress) public{
296 	    CardUser memory _carduser = CardUser({
297 		  name:_name,
298 		  email:_email
299 		});
300 		
301 		uint256 index = cardusers.push(_carduser) - 1;
302 		userArreyPosition[userAddress] = index;
303 	}
304 
305 	function addCategory(string _name,uint256 _id) public{
306 	    Category memory _category = Category({
307 	      id:_id,
308 		  name:_name
309 		});
310 		uint256 index = categories.push(_category) - 1;
311 		categoryToPosition[_id] = index;
312 	}
313 		function getTotalCategories() public view returns(
314 	    uint256) 
315 	    {
316 	        return categories.length;
317 	        
318 	    }
319 	function getCategory(uint256 _id) public view returns(
320 	    string name) 
321 	    {
322 	    uint256 index = categoryToPosition[_id];
323 	    Category storage cat = categories[index];
324 		name=cat.name;
325 	} 
326 		
327 	function _createToken(string _name,string _imagepath,string _category, uint256 _id, address _owner, uint256 _price,uint256 _IsWildcard) private {
328 	    
329 		Card memory _card = Card({
330 		  name: _name,
331 		  token: _id,
332 		  imagepath:_imagepath,
333 		  category:_category,
334 		  Iswildcard:_IsWildcard,
335 		  owner:adminAddress
336 		});
337 			
338 		uint256 index = cards.push(_card) - 1;
339 		cardTokenToPosition[_id] = index;
340 		// It's probably never going to happen, 4 billion tokens are A LOT, but
341 		// let's just be 100% sure we never let this happen.
342 		require(_id == uint256(uint32(_id)));
343 
344 		emit NewToken(_id, _name, _owner);
345 		cardTokenToPrice[_id] = _price;
346 		// This will assign ownership, and also emit the Transfer event as
347 		// per ERC721 draft
348 		_transfer(address(0), _owner, _id);
349 	}
350 	/*** CARDS ***/
351 	
352 	/*** ------------------------------- ***/
353 	
354 	/*** ERC721 FUNCTIONS ***/
355     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
356     /// @param _to The address to be granted transfer approval. Pass address(0) to
357     ///  clear all approvals.
358     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
359     /// @dev Required for ERC-721 compliance.
360     function approve(
361         address _to,
362         uint256 _tokenId
363       ) public {
364         // Caller must own token.
365         require(_owns(msg.sender, _tokenId));
366     
367         cardTokenToApproved[_tokenId] = _to;
368     
369         emit Approval(msg.sender, _to, _tokenId);
370     }
371     
372     /// For querying balance of a particular account
373     /// @param _owner The address for balance query
374     /// @dev Required for ERC-721 compliance.
375     function balanceOf(address _owner) public view returns (uint256 balance) {
376         return ownershipTokenCount[_owner];
377     }
378     
379     function implementsERC721() public pure returns (bool) {
380         return true;
381     }
382     
383 
384     /// For querying owner of token
385     /// @param _tokenId The tokenID for owner inquiry
386     /// @dev Required for ERC-721 compliance.
387     function ownerOf(uint256 _tokenId) public view returns (address owner) {
388         owner = cardTokenToOwner[_tokenId];
389         require(owner != address(0));
390     }
391     
392     /// @notice Allow pre-approved user to take ownership of a token
393     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
394     /// @dev Required for ERC-721 compliance.
395     function takeOwnership(uint256 _tokenId) public {
396         address newOwner = msg.sender;
397         address oldOwner = cardTokenToOwner[_tokenId];
398     
399         // Safety check to prevent against an unexpected 0x0 default.
400         require(_addressNotNull(newOwner));
401 
402         // Making sure transfer is approved
403         require(_approved(newOwner, _tokenId));
404     
405         _transfer(oldOwner, newOwner, _tokenId);
406     }
407     
408     /// For querying totalSupply of token
409     /// @dev Required for ERC-721 compliance.
410     function totalSupply() public view returns (uint256 total) {
411         return cards.length;
412     }
413     
414     /// Third-party initiates transfer of token from address _from to address _to
415     /// @param _from The address for the token to be transferred from.
416     /// @param _to The address for the token to be transferred to.
417     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
418     /// @dev Required for ERC-721 compliance.
419     function transferFrom(address _from, address _to, uint256 _tokenId) public {
420         require(_owns(_from, _tokenId));
421         require(_approved(_to, _tokenId));
422         require(_addressNotNull(_to));
423     
424         _transfer(_from, _to, _tokenId);
425     }
426 
427     /// Owner initates the transfer of the token to another account
428     /// @param _to The address for the token to be transferred to.
429     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
430     /// @dev Required for ERC-721 compliance.
431     function transfer(address _to, uint256 _tokenId) public {
432         require(_owns(msg.sender, _tokenId));
433         require(_addressNotNull(_to));
434     
435         _transfer(msg.sender, _to, _tokenId);
436     }
437     
438     /// Tranfer token to any address he want to
439 	/// @param _to the addres of token going to assign
440 	/// @param _tokenId is Id of token which is going to to transfer
441 	function tokenTransfer(address _to,uint256 _tokenId)  public onlyAdmin{
442 		address oldOwner = cardTokenToOwner[_tokenId];
443 		address newOwner = _to;
444 		uint256 index = cardTokenToPosition[_tokenId];
445 		cards[index].owner=newOwner;		
446 		_transfer(oldOwner, newOwner, _tokenId);
447 	}
448 	
449 	
450     /// @dev Required for ERC-721 compliance.
451     function name() public pure returns (string) {
452         return NAME;
453     }
454     
455     /// @dev Required for ERC-721 compliance.
456     function symbol() public pure returns (string) {
457         return SYMBOL;
458     }
459 
460 	/*** ERC721 FUNCTIONS ***/
461 	
462 	/*** ------------------------------- ***/
463 	
464 	/*** ADMINISTRATOR FUNCTIONS ***/
465 	
466 	//send balance of contract on wallet
467 	function payout(address _to) public onlyHostOrAdmin {
468 		_payout(_to);
469 	}
470 	
471 	function _payout(address _to) private {
472 		if (_to == address(0)) {
473 			hostAddress.transfer(address(this).balance);
474 		} else {
475 			_to.transfer(address(this).balance);
476 		}
477 	}
478 	
479 	/*** ADMINISTRATOR FUNCTIONS ***/
480 	
481 
482     /*** PUBLIC FUNCTIONS ***/
483 
484     function contractBalance() public  view returns (uint256 balance) {
485         return address(this).balance;
486     }
487 
488 
489 function getNextPrice(uint256 sellingPrice) private view returns (uint256){
490    
491      // Update prices
492     if (sellingPrice < firstStepLimit) {
493       // first stage
494       sellingPrice = Helper.div(Helper.mul(sellingPrice, 300), 93);
495     } else if (sellingPrice < secondStepLimit) {
496       // second stage
497       sellingPrice= Helper.div(Helper.mul(sellingPrice, 200), 93);
498     } else if (sellingPrice < thirdStepLimit) {
499       // second stage
500       sellingPrice = Helper.div(Helper.mul(sellingPrice, 120), 93);
501     } else {
502       // third stage
503       sellingPrice = Helper.div(Helper.mul(sellingPrice, 115), 93);
504     }
505     return sellingPrice;
506 } 
507 
508 //get the selling price of card based on slab.
509 function nextPriceOf(uint256 _tokenId) public view returns (uint256 price){
510     uint256 sellingPrice=cardTokenToPrice[_tokenId];
511      // Update prices
512     if (sellingPrice < firstStepLimit) {
513       // first stage
514       sellingPrice = Helper.div(Helper.mul(sellingPrice, 300), 93);
515     } else if (sellingPrice < secondStepLimit) {
516       // second stage
517       sellingPrice= Helper.div(Helper.mul(sellingPrice, 200), 93);
518     } else if (sellingPrice < thirdStepLimit) {
519       // second stage
520       sellingPrice = Helper.div(Helper.mul(sellingPrice, 120), 93);
521     } else {
522       // third stage
523       sellingPrice = Helper.div(Helper.mul(sellingPrice, 115), 93);
524     }
525     return sellingPrice;
526 } 
527 
528   function changePrice(uint256 _tokenId,uint256 _price) public onlyAdmin
529   {
530 	    // Update prices
531 		cardTokenToPrice[_tokenId] =_price;
532 	
533   }
534 
535   function transferToken(address _to, uint256 _tokenId) public onlyAdmin {
536     address oldOwner = cardTokenToOwner[_tokenId];
537     address newOwner = _to;
538 	uint256 index = cardTokenToPosition[_tokenId];
539 	//assign new owner hash
540 	cards[index].owner=newOwner;
541     _transfer(oldOwner, newOwner, _tokenId); 
542     
543   }
544 
545   //no. of tokens issued to the market
546   function numberOfTokens() public view returns (uint256) {
547     return cards.length;
548   }
549  // Allows someone to send ether and obtain the token
550  function purchase(uint256 _tokenId) public payable {
551     address oldOwner = cardTokenToOwner[_tokenId];
552     address newOwner = msg.sender;
553     
554 	
555 	//prevent repurchase 
556     require(oldOwner != address(0));
557 
558     uint256 sellingPrice =msg.value;//getNextPrice(cardTokenToPrice[_tokenId]);
559 
560     // Making sure token owner is not sending to self
561     require(oldOwner != newOwner);
562 
563     // Safety check to prevent against an unexpected 0x0 default.
564     require(_addressNotNull(newOwner));
565 
566     // Making sure sent amount is greater than or equal to the sellingPrice
567     require(msg.value >= sellingPrice);
568 
569     
570     // Update prices
571     cardTokenToPrice[_tokenId] =getNextPrice(sellingPrice);
572 
573     _transfer(oldOwner, newOwner, _tokenId);
574 
575 	//Pay Wild card commission
576     address wildcardOwner =GetWildCardOwner(_tokenId) ;//cardTokenToOwner[wildcardTokenId];
577 	uint256 wildcardPayment=uint256(Helper.div(Helper.mul(sellingPrice, 4), 100)); // 4% for wild card owner
578 	uint256 payment=uint256(Helper.div(Helper.mul(sellingPrice, 90), 100)); //90% for old owner
579     if (wildcardOwner != address(0)) {
580 		wildcardOwner.transfer(wildcardPayment);  
581 		sellingPrice=sellingPrice - wildcardPayment;  
582     }
583 	
584     // Pay previous tokenOwner if owner is not contract
585 	//address(this) = Contract Address
586     if (oldOwner != address(this)) {
587 		oldOwner.transfer(payment);  
588     }
589 	//Balance 100%- (4% + 90%) =6% will auto transfer to contract if wild card
590     //CONTRACT EVENT 
591 	uint256 index = cardTokenToPosition[_tokenId];
592 	//assign new owner hash
593 	cards[index].owner=newOwner;
594     emit NewTokenOwner(sellingPrice, cardTokenToPrice[_tokenId], oldOwner, newOwner, cards[index].name, _tokenId);
595 	 
596   }
597   
598 
599 function GetWildCardOwner(uint256 _tokenId) public view returns (address _cardowner){
600 		uint256 index=	cardTokenToPosition[_tokenId];
601 		string storage cardCategory=cards[index].category;
602 		
603 	    uint256 totalCards = totalSupply();
604         uint256 i=0;
605           for (i = 0; i  <= totalCards-1; i++) {
606             //check for the same category
607             if ((keccak256(cards[i].category)==keccak256(cardCategory)) && cards[i].Iswildcard==1){
608                return cards[i].owner;
609             }
610           }
611 }
612   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
613     return cardTokenToPrice[_tokenId];
614   }
615 
616 
617 
618   /// @param _owner The owner whose celebrity tokens we are interested in.
619   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
620   ///  expensive (it walks the entire cards array looking for cards belonging to owner),
621   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
622   ///  not contract-to-contract calls.
623   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
624     uint256 tokenCount = balanceOf(_owner);
625     if (tokenCount == 0) {
626         // Return an empty array
627       return new uint256[](0);
628     } else {
629       uint256[] memory result = new uint256[](tokenCount);
630       uint256 totalCards = totalSupply();
631       uint256 resultIndex = 0;
632 
633       uint256 index;
634       for (index = 0; index <= totalCards-1; index++) {
635         if (cardTokenToOwner[cards[index].token] == _owner) {
636           result[resultIndex] = cards[index].token;
637           resultIndex++;
638         }
639       }
640       return result;
641     }
642   }
643 
644   /*** PRIVATE FUNCTIONS ***/
645   /// Safety check on _to address to prevent against an unexpected 0x0 default.
646   function _addressNotNull(address _to) private pure returns (bool) {
647     return _to != address(0);
648   }
649 
650   /// For checking approval of transfer for address _to
651   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
652     return cardTokenToApproved[_tokenId] == _to;
653   }
654 
655   /// Check for token ownership
656   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
657     return claimant == cardTokenToOwner[_tokenId];
658   }
659 
660 
661   /// @dev Assigns ownership of a specific card to an address.
662   function _transfer(address _from, address _to, uint256 _tokenId) private {
663     // Since the number of cards is capped to 2^32 we can't overflow this
664     ownershipTokenCount[_to]++;
665     //transfer ownership
666     cardTokenToOwner[_tokenId] = _to;
667 
668     // When creating new cards _from is 0x0, but we can't account that address.
669     if (_from != address(0)) {
670       ownershipTokenCount[_from]--;
671       // clear any previously approved ownership exchange
672       delete cardTokenToApproved[_tokenId];
673     }
674 
675     // Emit the transfer event.
676     emit Transfer(_from, _to, _tokenId);
677   }
678   
679 
680     function CryptoCollectorContract() public {
681     }
682     
683 }
684 
685 library Helper {
686 
687   /**
688   * @dev Multiplies two numbers, throws on overflow.
689   */
690   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
691     if (a == 0) {
692       return 0;
693     }
694     uint256 c = a * b;
695     assert(c / a == b);
696     return c;
697   }
698 
699   /**
700   * @dev Integer division of two numbers, truncating the quotient.
701   */
702   function div(uint256 a, uint256 b) internal pure returns (uint256) {
703     // assert(b > 0); // Solidity automatically throws when dividing by 0
704     uint256 c = a / b;
705     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
706     return c;
707   }
708 
709   /**
710   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
711   */
712   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
713     assert(b <= a);
714     return a - b;
715   }
716 
717   /**
718   * @dev Adds two numbers, throws on overflow.
719   */
720   function add(uint256 a, uint256 b) internal pure returns (uint256) {
721     uint256 c = a + b;
722     assert(c >= a);
723     return c;
724   }
725 }