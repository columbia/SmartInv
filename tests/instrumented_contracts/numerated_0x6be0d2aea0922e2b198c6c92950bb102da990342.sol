1 pragma solidity ^0.4.19; // solhint-disable-line
2 
3 /**
4   * Interface for contracts conforming to ERC-721: Non-Fungible Tokens
5   * @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
6   */
7 contract ERC721 {
8   // Required methods
9   function approve(address _to, uint256 _tokenId) public;
10   function balanceOf(address _owner) public view returns (uint256 balance);
11   function implementsERC721() public pure returns (bool);
12   function ownerOf(uint256 _tokenId) public view returns (address addr);
13   function takeOwnership(uint256 _tokenId) public;
14   function totalSupply() public view returns (uint256 total);
15   function transferFrom(address _from, address _to, uint256 _tokenId) public;
16   function transfer(address _to, uint256 _tokenId) public;
17 
18   event Transfer(address indexed from, address indexed to, uint256 tokenId);
19   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
20 
21   // Optional
22   // function name() public view returns (string name);
23   // function symbol() public view returns (string symbol);
24   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
25   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
26 }
27 
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   /**
53   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 contract LibraryToken is ERC721 {
71   using SafeMath for uint256;
72 
73   /*** EVENTS ***/
74 
75   /**
76     * @dev The Created event is fired whenever a new library comes into existence.
77     */
78   event Created(uint256 indexed _tokenId, string _language, string _name, address indexed _owner);
79 
80   /**
81     * @dev The Sold event is fired whenever a token is sold.
82     */
83   event Sold(uint256 indexed _tokenId, address indexed _owner, uint256 indexed _price);
84 
85   /**
86     * @dev The Bought event is fired whenever a token is bought.
87     */
88   event Bought(uint256 indexed _tokenId, address indexed _owner, uint256 indexed _price);
89 
90   /**
91     * @dev Transfer event as defined in current draft of ERC721.
92     */
93   event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
94 
95   /**
96     * @dev Approval event as defined in current draft of ERC721.
97     */
98   event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
99 
100   /**
101     * @dev FounderSet event fired when founder is set.
102     */
103   event FounderSet(address indexed _founder, uint256 indexed _tokenId);
104 
105 
106 
107 
108   /*** CONSTANTS ***/
109 
110   /**
111     * @notice Name and symbol of the non-fungible token, as defined in ERC721.
112     */
113   string public constant NAME = "CryptoLibraries"; // solhint-disable-line
114   string public constant SYMBOL = "CL"; // solhint-disable-line
115 
116   /**
117     * @dev Increase tiers to deterine how much price have to be changed
118     */
119   uint256 private startingPrice = 0.002 ether;
120   uint256 private developersCut = 0 ether;
121   uint256 private TIER1 = 0.02 ether;
122   uint256 private TIER2 = 0.5 ether;
123   uint256 private TIER3 = 2.0 ether;
124   uint256 private TIER4 = 5.0 ether;
125 
126   /*** STORAGE ***/
127 
128   /**
129     * @dev A mapping from library IDs to the address that owns them.
130     * All libraries have some valid owner address.
131     */
132   mapping (uint256 => address) public libraryIndexToOwner;
133 
134   /**
135     * @dev A mapping from library IDs to the address that founder of library.
136     */
137   mapping (uint256 => address) public libraryIndexToFounder;
138 
139   /**
140     * @dev A mapping from founder address to token count.
141   */
142   mapping (address => uint256) public libraryIndexToFounderCount;
143 
144   /**
145     * @dev A mapping from owner address to count of tokens that address owns.
146     * Used internally inside balanceOf() to resolve ownership count.
147     */
148   mapping (address => uint256) private ownershipTokenCount;
149 
150   /**
151     * @dev A mapping from LibraryIDs to an address that has been approved to call
152     * transferFrom(). Each Library can only have one approved address for transfer
153     * at any time. A zero value means no approval is outstanding.
154     */
155   mapping (uint256 => address) public libraryIndexToApproved;
156 
157   /**
158     * @dev A mapping from LibraryIDs to the price of the token.
159     */
160   mapping (uint256 => uint256) private libraryIndexToPrice;
161 
162   /**
163     * @dev A mapping from LibraryIDs to the funds avaialble for founder.
164     */
165   mapping (uint256 => uint256) private libraryIndexToFunds;
166 
167   /**
168     * The addresses of the owner that can execute actions within each roles.
169     */
170   address public owner;
171 
172 
173 
174   /*** DATATYPES ***/
175   struct Library {
176     string language;
177     string name;
178   }
179 
180   Library[] private libraries;
181 
182 
183 
184   /*** ACCESS MODIFIERS ***/
185 
186   /**
187     * @dev Access modifier for owner functionality.
188     */
189   modifier onlyOwner() {
190     require(msg.sender == owner);
191     _;
192   }
193 
194   /**
195     * @dev Access modifier for founder of library.
196     */
197   modifier onlyFounder(uint256 _tokenId) {
198     require(msg.sender == founderOf(_tokenId));
199     _;
200   }
201 
202 
203 
204   /*** CONSTRUCTOR ***/
205 
206   function LibraryToken() public {
207     owner = msg.sender;
208   }
209 
210 
211 
212   /*** PUBLIC FUNCTIONS ERC-721 COMPILANCE ***/
213 
214   /**
215     * @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
216     * @param _to The address to be granted transfer approval. Pass address(0) to
217     * clear all approvals.
218     * @param _tokenId The ID of the Token that can be transferred if this call succeeds.
219     */
220   function approve(
221     address _to,
222     uint256 _tokenId
223   )
224     public
225   {
226     // Caller can't be approver of request
227     require(msg.sender != _to);
228 
229     // Caller must own token.
230     require(_owns(msg.sender, _tokenId));
231 
232     libraryIndexToApproved[_tokenId] = _to;
233 
234     Approval(msg.sender, _to, _tokenId);
235   }
236 
237   /**
238     * For querying balance of a particular account
239     * @param _owner The address for balance query
240     * @return balance The number of tokens owned by owner
241     */
242   function balanceOf(address _owner) public view returns (uint256 balance) {
243     return ownershipTokenCount[_owner];
244   }
245 
246   /**
247     * @dev Required for ERC-721 compliance.
248     * @return bool
249     */
250   function implementsERC721() public pure returns (bool) {
251     return true;
252   }
253 
254   /**
255     * For querying owner of token
256     * @dev Required for ERC-721 compliance.
257     * @param _tokenId The tokenID for owner inquiry
258     * @return tokenOwner address of token owner
259     */
260   function ownerOf(uint256 _tokenId) public view returns (address tokenOwner) {
261     tokenOwner = libraryIndexToOwner[_tokenId];
262     require(tokenOwner != address(0));
263   }
264 
265   /**
266     * @notice Allow pre-approved user to take ownership of a token
267     * @dev Required for ERC-721 compliance.
268     * @param _tokenId The ID of the Token that can be transferred if this call succeeds.
269     */
270   function takeOwnership(uint256 _tokenId) public {
271     // Safety check to prevent against an unexpected 0x0 default.
272     require(_addressNotNull(newOwner));
273 
274     // Making sure transfer is approved
275     require(_approved(newOwner, _tokenId));
276 
277     address newOwner = msg.sender;
278     address oldOwner = libraryIndexToOwner[_tokenId];
279 
280     _transfer(oldOwner, newOwner, _tokenId);
281   }
282 
283   /**
284     * totalSupply
285     * For querying total numbers of tokens
286     * @return total The total supply of tokens
287     */
288   function totalSupply() public view returns (uint256 total) {
289     return libraries.length;
290   }
291 
292   /**
293     * transferFro
294     * Third-party initiates transfer of token from address _from to address _to
295     * @param _from The address for the token to be transferred from.
296     * @param _to The address for the token to be transferred to.
297     * @param _tokenId The ID of the Token that can be transferred if this call succeeds.
298     */
299   function transferFrom(
300     address _from,
301     address _to,
302     uint256 _tokenId
303   )
304     public
305   {
306     require(_owns(_from, _tokenId));
307     require(_approved(_to, _tokenId));
308     require(_addressNotNull(_to));
309 
310     _transfer(_from, _to, _tokenId);
311   }
312 
313   /**
314     * Owner initates the transfer of the token to another account
315     * @param _to The address for the token to be transferred to.
316     * @param _tokenId The ID of the Token that can be transferred if this call succeeds.
317     */
318   function transfer(
319     address _to,
320     uint256 _tokenId
321   )
322     public
323   {
324     require(_owns(msg.sender, _tokenId));
325     require(_addressNotNull(_to));
326 
327     _transfer(msg.sender, _to, _tokenId);
328   }
329 
330   /**
331     * @dev Required for ERC-721 compliance.
332     */
333   function name() public pure returns (string) {
334     return NAME;
335   }
336 
337   /**
338     * @dev Required for ERC-721 compliance.
339     */
340   function symbol() public pure returns (string) {
341     return SYMBOL;
342   }
343 
344 
345 
346   /*** PUBLIC FUNCTIONS ***/
347 
348   /**
349     * @dev Creates a new Library with the given language and name.
350     * @param _language The library language
351     * @param _name The name of library/framework
352     */
353   function createLibrary(string _language, string _name) public onlyOwner {
354     _createLibrary(_language, _name, address(this), address(0), 0, startingPrice);
355   }
356 
357   /**
358     * @dev Creates a new Library with the given language and name and founder address.
359     * @param _language The library language
360     * @param _name The name of library/framework
361     * @param _founder The founder of library/framework
362     */
363   function createLibraryWithFounder(string _language, string _name, address _founder) public onlyOwner {
364     require(_addressNotNull(_founder));
365     _createLibrary(_language, _name, address(this), _founder, 0, startingPrice);
366   }
367 
368   /**
369     * @dev Creates a new Library with the given language and name and owner address and starting price.
370     * Itd be used for various bounties prize.
371     * @param _language The library language
372     * @param _name The name of library/framework
373     * @param _owner The owner of library token
374     * @param _startingPrice The starting price of library token
375     */
376   function createLibraryBounty(string _language, string _name, address _owner, uint256 _startingPrice) public onlyOwner {
377     require(_addressNotNull(_owner));
378     _createLibrary(_language, _name, _owner, address(0), 0, _startingPrice);
379   }
380 
381   /**
382     * @notice Returns all the relevant information about a specific library.
383     * @param _tokenId The tokenId of the library of interest.
384     */
385   function getLibrary(uint256 _tokenId) public view returns (
386     string language,
387     string libraryName,
388     uint256 tokenPrice,
389     uint256 funds,
390     address tokenOwner,
391     address founder
392   ) {
393     Library storage x = libraries[_tokenId];
394     libraryName = x.name;
395     language = x.language;
396     founder = libraryIndexToFounder[_tokenId];
397     funds = libraryIndexToFunds[_tokenId];
398     tokenPrice = libraryIndexToPrice[_tokenId];
399     tokenOwner = libraryIndexToOwner[_tokenId];
400   }
401 
402   /**
403     * For querying price of token
404     * @param _tokenId The tokenID for owner inquiry
405     * @return _price The current price of token
406     */
407   function priceOf(uint256 _tokenId) public view returns (uint256 _price) {
408     return libraryIndexToPrice[_tokenId];
409   }
410 
411   /**
412     * For querying next price of token
413     * @param _tokenId The tokenID for owner inquiry
414     * @return _nextPrice The next price of token
415     */
416   function nextPriceOf(uint256 _tokenId) public view returns (uint256 _nextPrice) {
417     return calculateNextPrice(priceOf(_tokenId));
418   }
419 
420   /**
421     * For querying founder of library
422     * @param _tokenId The tokenID for founder inquiry
423     * @return _founder The address of library founder
424     */
425   function founderOf(uint256 _tokenId) public view returns (address _founder) {
426     _founder = libraryIndexToFounder[_tokenId];
427     require(_founder != address(0));
428   }
429 
430   /**
431     * For querying founder funds of library
432     * @param _tokenId The tokenID for founder inquiry
433     * @return _funds The funds availale for a fo
434     */
435   function fundsOf(uint256 _tokenId) public view returns (uint256 _funds) {
436     _funds = libraryIndexToFunds[_tokenId];
437   }
438 
439   /**
440     * For querying next price of token
441     * @param _price The token actual price
442     * @return _nextPrice The next price
443     */
444   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
445     if (_price < TIER1) {
446       return _price.mul(200).div(95);
447     } else if (_price < TIER2) {
448       return _price.mul(135).div(96);
449     } else if (_price < TIER3) {
450       return _price.mul(125).div(97);
451     } else if (_price < TIER4) {
452       return _price.mul(117).div(97);
453     } else {
454       return _price.mul(115).div(98);
455     }
456   }
457 
458   /**
459     * For querying developer's cut which is left in the contract by `purchase`
460     * @param _price The token actual price
461     * @return _devCut The developer's cut
462     */
463   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
464     if (_price < TIER1) {
465       return _price.mul(5).div(100); // 5%
466     } else if (_price < TIER2) {
467       return _price.mul(4).div(100); // 4%
468     } else if (_price < TIER3) {
469       return _price.mul(3).div(100); // 3%
470     } else if (_price < TIER4) {
471       return _price.mul(3).div(100); // 3%
472     } else {
473       return _price.mul(2).div(100); // 2%
474     }
475   }
476 
477   /**
478     * For querying founder cut which is left in the contract by `purchase`
479     * @param _price The token actual price
480     */
481   function calculateFounderCut (uint256 _price) public pure returns (uint256 _founderCut) {
482     return _price.mul(1).div(100);
483   }
484 
485   /**
486     * @dev This function withdrawing all of developer's cut which is left in the contract by `purchase`.
487     * User funds are immediately sent to the old owner in `purchase`, no user funds are left in the contract
488     * expect funds that stay in the contract that are waiting to be sent to a founder of a library when we would assign him.
489     */
490   function withdrawAll () onlyOwner() public {
491     owner.transfer(developersCut);
492     // Set developersCut to 0 to reset counter of possible funds
493     developersCut = 0;
494   }
495 
496   /**
497     * @dev This function withdrawing selected amount of developer's cut which is left in the contract by `purchase`.
498     * User funds are immediately sent to the old owner in `purchase`, no user funds are left in the contract
499     * expect funds that stay in the contract that are waiting to be sent to a founder of a library when we would assign him.
500     * @param _amount The amount to withdraw
501     */
502   function withdrawAmount (uint256 _amount) onlyOwner() public {
503     require(_amount >= developersCut);
504 
505     owner.transfer(_amount);
506     developersCut = developersCut.sub(_amount);
507   }
508 
509     /**
510     * @dev This function withdrawing selected amount of developer's cut which is left in the contract by `purchase`.
511     * User funds are immediately sent to the old owner in `purchase`, no user funds are left in the contract
512     * expect funds that stay in the contract that are waiting to be sent to a founder of a library when we would assign him.
513     */
514   function withdrawFounderFunds (uint256 _tokenId) onlyFounder(_tokenId) public {
515     address founder = founderOf(_tokenId);
516     uint256 funds = fundsOf(_tokenId);
517     founder.transfer(funds);
518 
519     // Set funds to 0 after transfer since founder can only withdraw all funts
520     libraryIndexToFunds[_tokenId] = 0;
521   }
522 
523   /*
524      Purchase a library directly from the contract for the calculated price
525      which ensures that the owner gets a profit.  All libraries that
526      have been listed can be bought by this method. User funds are sent
527      directly to the previous owner and are never stored in the contract.
528   */
529   function purchase(uint256 _tokenId) public payable {
530     address oldOwner = libraryIndexToOwner[_tokenId];
531     address newOwner = msg.sender;
532     // Making sure token owner is not sending to self
533     require(oldOwner != newOwner);
534 
535     // Safety check to prevent against an unexpected 0x0 default.
536     require(_addressNotNull(newOwner));
537 
538     // Making sure sent amount is greater than or equal to the sellingPrice
539     uint256 price = libraryIndexToPrice[_tokenId];
540     require(msg.value >= price);
541 
542     uint256 excess = msg.value.sub(price);
543 
544     _transfer(oldOwner, newOwner, _tokenId);
545     libraryIndexToPrice[_tokenId] = nextPriceOf(_tokenId);
546 
547     Bought(_tokenId, newOwner, price);
548     Sold(_tokenId, oldOwner, price);
549 
550     // Devevloper's cut which is left in contract and accesed by
551     // `withdrawAll` and `withdrawAmount` methods.
552     uint256 devCut = calculateDevCut(price);
553     developersCut = developersCut.add(devCut);
554 
555     // Founders cut which is left in contract and accesed by
556     // `withdrawFounderFunds` methods.
557     uint256 founderCut = calculateFounderCut(price);
558     libraryIndexToFunds[_tokenId] = libraryIndexToFunds[_tokenId].add(founderCut);
559 
560     // Pay previous tokenOwner if owner is not contract
561     if (oldOwner != address(this)) {
562       oldOwner.transfer(price.sub(devCut.add(founderCut)));
563     }
564 
565     if (excess > 0) {
566       newOwner.transfer(excess);
567     }
568   }
569 
570   /**
571     * @dev This method MUST NEVER be called by smart contract code. First, it's fairly
572     * expensive (it walks the entire Cities array looking for cities belonging to owner),
573     * but it also returns a dynamic array, which is only supported for web3 calls, and
574     * not contract-to-contract calls.
575     * @param _owner The owner whose library tokens we are interested in.
576     * @return []ownerTokens The tokens of owner
577     */
578   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
579     uint256 tokenCount = balanceOf(_owner);
580     if (tokenCount == 0) {
581         // Return an empty array
582       return new uint256[](0);
583     } else {
584       uint256[] memory result = new uint256[](tokenCount);
585       uint256 totalLibraries = totalSupply();
586       uint256 resultIndex = 0;
587 
588       uint256 libraryId;
589       for (libraryId = 0; libraryId <= totalLibraries; libraryId++) {
590         if (libraryIndexToOwner[libraryId] == _owner) {
591           result[resultIndex] = libraryId;
592           resultIndex++;
593         }
594       }
595       return result;
596     }
597   }
598 
599     /**
600     * @dev This method MUST NEVER be called by smart contract code. First, it's fairly
601     * expensive (it walks the entire Cities array looking for cities belonging to owner),
602     * but it also returns a dynamic array, which is only supported for web3 calls, and
603     * not contract-to-contract calls.
604     * @param _founder The owner whose library tokens we are interested in.
605     * @return []founderTokens The tokens of owner
606     */
607   function tokensOfFounder(address _founder) public view returns(uint256[] founderTokens) {
608     uint256 tokenCount = libraryIndexToFounderCount[_founder];
609     if (tokenCount == 0) {
610         // Return an empty array
611       return new uint256[](0);
612     } else {
613       uint256[] memory result = new uint256[](tokenCount);
614       uint256 totalLibraries = totalSupply();
615       uint256 resultIndex = 0;
616 
617       uint256 libraryId;
618       for (libraryId = 0; libraryId <= totalLibraries; libraryId++) {
619         if (libraryIndexToFounder[libraryId] == _founder) {
620           result[resultIndex] = libraryId;
621           resultIndex++;
622         }
623       }
624       return result;
625     }
626   }
627 
628 
629     /**
630     * @dev 
631     * @return []_libraries All tokens
632     */
633   function allTokens() public pure returns(Library[] _libraries) {
634     return _libraries;
635   }
636 
637   /**
638     * @dev Assigns a new address to act as the Owner. Only available to the current Owner.
639     * @param _newOwner The address of the new owner
640     */
641   function setOwner(address _newOwner) public onlyOwner {
642     require(_newOwner != address(0));
643 
644     owner = _newOwner;
645   }
646 
647     /**
648     * @dev Assigns a new address to act as the founder of library to let him withdraw collected funds of his library.
649     * @param _tokenId The id of a Token
650     * @param _newFounder The address of the new owner
651     */
652   function setFounder(uint256 _tokenId, address _newFounder) public onlyOwner {
653     require(_newFounder != address(0));
654 
655     address oldFounder = founderOf(_tokenId);
656 
657     libraryIndexToFounder[_tokenId] = _newFounder;
658     FounderSet(_newFounder, _tokenId);
659 
660     libraryIndexToFounderCount[_newFounder] = libraryIndexToFounderCount[_newFounder].add(1);
661     libraryIndexToFounderCount[oldFounder] = libraryIndexToFounderCount[oldFounder].sub(1);
662   }
663 
664 
665 
666   /*** PRIVATE FUNCTIONS ***/
667 
668   /**
669     * Safety check on _to address to prevent against an unexpected 0x0 default.
670     * @param _to The address to validate if not null
671     * @return bool The result of check
672     */
673   function _addressNotNull(address _to) private pure returns (bool) {
674     return _to != address(0);
675   }
676 
677   /**
678     * For checking approval of transfer for address _to
679     * @param _to The address to validate if approved
680     * @param _tokenId The token id to validate if approved
681     * @return bool The result of validation
682     */
683   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
684     return libraryIndexToApproved[_tokenId] == _to;
685   }
686 
687   /**
688     * Function to create a new Library
689     * @param _language The language (etc. Python, JavaScript) of library
690     * @param _name The name of library/framework (etc. Anguar, Redux, Flask)
691     * @param _owner The current owner of Token
692     * @param _founder The founder of library/framework
693     * @param _funds The funds available to founder of library/framework
694     * @param _price The current price of a Token
695     */
696   function _createLibrary(
697     string _language,
698     string _name,
699     address _owner,
700     address _founder,
701     uint256 _funds,
702     uint256 _price
703   )
704     private
705   {
706     Library memory _library = Library({
707       name: _name,
708       language: _language
709     });
710     uint256 newLibraryId = libraries.push(_library) - 1;
711 
712     Created(newLibraryId, _language, _name, _owner);
713 
714     libraryIndexToPrice[newLibraryId] = _price;
715     libraryIndexToFounder[newLibraryId] = _founder;
716     libraryIndexToFunds[newLibraryId] = _funds;
717 
718     // This will assign ownership, and also emit the Transfer event as per ERC721 draft
719     _transfer(address(0), _owner, newLibraryId);
720   }
721 
722   /**
723     * Check for token ownership
724     * @param claimant The claimant
725     * @param _tokenId The token id to check claim
726     * @return bool The result of validation
727     */
728   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
729     return claimant == libraryIndexToOwner[_tokenId];
730   }
731 
732   /**
733     * @dev Assigns ownership of a specific Library to an address.
734     * @param _from The old owner of token
735     * @param _to The new owner of token
736     * @param _tokenId The id of token to change owner
737     */
738   function _transfer(address _from, address _to, uint256 _tokenId) private {
739     // Since the number of library is capped to 2^32 we can't overflow this
740     ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);
741 
742     //transfer ownership
743     libraryIndexToOwner[_tokenId] = _to;
744 
745     // When creating new libraries _from is 0x0, but we can't account that address.
746     if (_from != address(0)) {
747       ownershipTokenCount[_from] = ownershipTokenCount[_from].sub(1);
748 
749       // clear any previously approved ownership exchange
750       delete libraryIndexToApproved[_tokenId];
751     }
752 
753     // Emit the transfer event.
754     Transfer(_from, _to, _tokenId);
755   }
756 }