1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 
6 contract ERC721 {
7   // Required methods
8   function approve(address _to, uint256 _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function implementsERC721() public pure returns (bool);
11   function ownerOf(uint256 _tokenId) public view returns (address addr);
12   function takeOwnership(uint256 _tokenId) public;
13   function totalSupply() public view returns (uint256 total);
14   function transferFrom(address _from, address _to, uint256 _tokenId) public;
15   function transfer(address _to, uint256 _tokenId) public;
16 
17   event Transfer(address indexed from, address indexed to, uint256 tokenId);
18   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19   event Dissolved(address  owner, uint256 tokenId);
20   event TransferDissolved(address indexed from, address indexed to, uint256 tokenId);
21   
22 }
23 
24 
25 contract CryptoStamps is ERC721 {
26 
27   
28   /*** EVENTS ***/
29 
30   
31   /// @dev The Birth event is fired whenever a new stamp is created.
32   event stampBirth(uint256 tokenId,  address owner);
33 
34   /// @dev The TokenSold event is fired whenever a stamp is sold.
35   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner);
36 
37   /// @dev Transfer event as defined in current draft of ERC721. 
38   ///  ownership is assigned, including births.
39   event Transfer(address from, address to, uint256 tokenId);
40 
41 
42 
43   
44   /*** CONSTANTS ***/
45 
46 
47   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
48   string public constant NAME = "CryptoStamps"; // 
49   string public constant SYMBOL = "CS"; // 
50   
51   // @dev firstStepLimit for the change in rate of price increase
52   uint256 private firstStepLimit =  1.28 ether;
53   
54 
55 
56   
57   
58   /*** STORAGE ***/
59 
60 
61 
62   /// @dev A mapping from stamp IDs to the address that owns them. All stamps have
63   ///  some valid owner address.
64   mapping (uint256 => address) public stampIndexToOwner;
65   
66 
67   // @dev A mapping from owner address to count of stamps that address owns.
68   //  Used internally inside balanceOf() to resolve ownership count.
69   mapping (address => uint256) private ownershipTokenCount;
70 
71   /// @dev A mapping from stamp IDs to an address that has been approved to call
72   ///  transferFrom(). Each stamp can only have one approved address for transfer
73   ///  at any time. A zero value means no approval is outstanding.
74   mapping (uint256 => address) public stampIndexToApproved;
75 
76   // @dev A mapping from stamp IDs to the price of the token.
77   mapping (uint256 => uint256) private stampIndexToPrice;
78   
79   
80   
81   //@dev A mapping from stamp IDs to the number of transactions that the stamp has gone through. 
82   mapping(uint256 => uint256) public stampIndextotransactions;
83   
84   //@dev To calculate the total ethers transacted in the game.
85   uint256 public totaletherstransacted;
86 
87   //@dev To calculate the total transactions in the game.
88   uint256 public totaltransactions;
89   
90   //@dev To calculate the total stamps created.
91   uint256 public stampCreatedCount;
92   
93   
94   
95 
96  /*** STORAGE FOR DISSOLVED ***/
97  
98  
99  //@dev A mapping from stamp IDs to their dissolved status.
100   //Initially all values are set to false by default
101   mapping (uint256 => bool) public stampIndextodissolved;
102  
103  
104  //@dev A mapping from dissolved stamp IDs to their approval status.
105   //Initially all values are set to false by default
106  mapping (uint256 => address) public dissolvedIndexToApproved;
107  
108   
109   
110   
111   /*** DATATYPES ***/
112   
113   struct Stamp {
114     uint256 birthtime;
115   }
116   
117   
118 
119   Stamp[] private stamps;
120 
121  
122  
123  
124  
125   
126   
127   
128   /*** ACCESS MODIFIERS ***/
129   
130   /// @dev Access modifier for CEO-only functionality
131   
132   
133   // The addresses of the accounts (or contracts) that can execute actions within each roles.
134   address public ceoAddress;
135   address public cooAddress;
136   bool private paused;
137   
138   modifier onlyCEO() {
139     require(msg.sender == ceoAddress);
140     _;
141   }
142 
143   /// @dev Access modifier for COO-only functionality
144   modifier onlyCOO() {
145     require(msg.sender == cooAddress);
146     _;
147   }
148 
149   /// Access modifier for contract owner only functionality
150   modifier onlyCLevel() {
151     require(
152       msg.sender == ceoAddress ||
153       msg.sender == cooAddress
154     );
155     _;
156   }
157 
158   
159   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
160   /// @param _newCEO The address of the new CEO
161   
162   function setCEO(address _newCEO) public onlyCEO {
163     require(_newCEO != address(0));
164 
165     ceoAddress = _newCEO;
166   }
167 
168  
169  
170   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
171   /// @param _newCOO The address of the new COO
172   
173   function setCOO(address _newCOO) public onlyCEO {
174     require(_newCOO != address(0));
175 
176     cooAddress = _newCOO;
177   }
178   
179   
180   
181   /*** CONSTRUCTOR ***/
182   function CryptoStamps() public {
183     ceoAddress = msg.sender;
184     cooAddress = msg.sender;
185     paused = false;
186   }
187 
188   
189   
190   
191   
192   /*** PUBLIC FUNCTIONS ***/
193   /// @notice Grant another address the right to transfer stamp via takeOwnership() and transferFrom().
194   
195   ///  clear all approvals.
196   
197   /// @dev Required for ERC-721 compliance.
198   
199   
200   //@dev to pause and unpause the contract in emergency situations
201   function pausecontract() public onlyCLevel
202   {
203       paused = true;
204   }
205   
206   
207   
208   function unpausecontract() public onlyCEO
209   {
210       paused = false;
211       
212   }
213   
214   
215   
216   function approve(
217     address _to,
218     uint256 _tokenId
219   ) public {
220     // Caller must own token.
221     require(paused == false);
222     require(_owns(msg.sender, _tokenId));
223 
224     stampIndexToApproved[_tokenId] = _to;
225 
226     Approval(msg.sender, _to, _tokenId);
227   }
228 
229   
230   
231   /// For querying balance of a particular account
232   /// @param _owner The address for balance query
233   /// @dev Required for ERC-721 compliance.
234   
235   
236   
237   
238   function balanceOf(address _owner) public view returns (uint256 balance) {
239     return ownershipTokenCount[_owner];
240   }
241 
242   
243   
244   //@dev To create a stamp.
245   function createStamp(address _owner,  uint256 _price) public onlyCOO {
246     
247     require(paused == false);
248     address stampOwner = _owner;
249     if (stampOwner == address(0)) {
250       stampOwner = cooAddress;
251     }
252 
253     require(_price >= 0);
254 
255     stampCreatedCount++;
256     _createStamp( stampOwner, _price);
257   }
258 
259   
260  
261   //@dev To get stamp information
262   
263   function getStamp(uint256 _tokenId) public view returns (
264     uint256 birthtimestamp,
265     uint256 sellingPrice,
266     address owner
267   ) {
268     Stamp storage stamp = stamps[_tokenId];
269     birthtimestamp = stamp.birthtime;
270     sellingPrice = stampIndexToPrice[_tokenId];
271     owner = stampIndexToOwner[_tokenId];
272   }
273 
274   
275   
276   
277   function implementsERC721() public pure returns (bool) {
278     return true;
279   }
280 
281   
282   
283   /// @dev Required for ERC-721 compliance.
284   
285   
286   
287   
288   function name() public pure returns (string) {
289     return NAME;
290   }
291 
292   
293   
294   /// For querying owner of stamp
295   /// @param _tokenId The tokenID for owner inquiry
296   /// @dev Required for ERC-721 compliance.
297   
298   
299   
300   function ownerOf(uint256 _tokenId)
301     public
302     view
303     returns (address owner)
304   {
305     owner = stampIndexToOwner[_tokenId];
306     require(owner != address(0));
307   }
308 
309   
310   
311   //@dev To payout to an address
312   
313   function payout(address _to) public onlyCLevel {
314     _payout(_to);
315   }
316   
317   
318   
319   
320   
321   
322   //@ To set the cut received by smart contract
323   uint256 private cut;
324   
325   
326   
327   
328   function setcut(uint256 cutowner) onlyCEO public returns(uint256)
329   { 
330       cut = cutowner;
331       return(cut);
332       
333   }
334 
335   
336   
337   
338   
339   // Allows someone to send ether and obtain the token
340   
341   function purchase(uint256 _tokenId) public payable {
342     address oldOwner = stampIndexToOwner[_tokenId];
343     address newOwner = msg.sender;
344     require(stampIndextodissolved[_tokenId] == false);
345     require(paused == false);
346     uint256 sellingPrice = stampIndexToPrice[_tokenId];
347     totaletherstransacted = totaletherstransacted + sellingPrice;
348 
349     // Making sure token owner is not sending to self
350     require(oldOwner != newOwner);
351 
352     // Safety check to prevent against an unexpected 0x0 default.
353     require(_addressNotNull(newOwner));
354 
355     // Making sure sent amount is greater than or equal to the sellingPrice
356     require(msg.value >= sellingPrice);
357 
358     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, cut), 100));
359     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
360 
361     // Update prices
362     if (sellingPrice < firstStepLimit) {
363       // first stage
364       stampIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), cut);
365     } 
366     else {
367       
368       stampIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), cut);
369     }
370 
371     _transfer(oldOwner, newOwner, _tokenId);
372 
373     // Pay previous tokenOwner if owner is not contract
374     if (oldOwner != address(this)) {
375       oldOwner.transfer(payment); //(1-0.06)
376     }
377 
378     TokenSold(_tokenId, sellingPrice, stampIndexToPrice[_tokenId], oldOwner, newOwner);
379 
380     msg.sender.transfer(purchaseExcess);
381   }
382 
383   
384   
385   
386   //@dev To get price of a stamp
387   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
388     return stampIndexToPrice[_tokenId];
389   }
390 
391   
392   
393   //@dev To get the next price of a stamp
394   function nextpriceOf(uint256 _tokenId) public view returns (uint256 price) {
395     uint256 currentsellingPrice = stampIndexToPrice[_tokenId];
396     
397     if (currentsellingPrice < firstStepLimit) {
398       // first stage
399       return SafeMath.div(SafeMath.mul(currentsellingPrice, 200), cut);
400     } 
401     else {
402       
403       return SafeMath.div(SafeMath.mul(currentsellingPrice, 125), cut);
404     }
405     
406   }
407 
408   
409   
410   
411   
412   
413   /// @dev Required for ERC-721 compliance.
414   
415   
416   function symbol() public pure returns (string) {
417     return SYMBOL;
418   }
419 
420   
421   /// @notice Allow pre-approved user to take ownership of a token
422   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
423   /// @dev Required for ERC-721 compliance.
424   
425   
426   function takeOwnership(uint256 _tokenId) public {
427     address newOwner = msg.sender;
428     address oldOwner = stampIndexToOwner[_tokenId];
429     require(paused == false);
430     // Safety check to prevent against an unexpected 0x0 default.
431     require(_addressNotNull(newOwner));
432 
433     // Making sure transfer is approved
434     require(_approved(newOwner, _tokenId));
435 
436     _transfer(oldOwner, newOwner, _tokenId);
437   }
438 
439   
440   
441   
442   /// @param _owner The owner of the stamp
443   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
444   ///  expensive (it walks the entire Stamps array looking for stamps belonging to owner),
445   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
446   ///  not contract-to-contract calls.
447   
448   
449   
450   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
451     uint256 tokenCount = balanceOf(_owner);
452     if (tokenCount == 0) {
453         // Return an empty array
454       return new uint256[](0);
455     } else {
456       uint256[] memory result = new uint256[](tokenCount);
457       uint256 totalStamps = totalSupply();
458       uint256 resultIndex = 0;
459 
460       uint256 stampId;
461       for (stampId = 0; stampId <= totalStamps; stampId++) {
462         if (stampIndexToOwner[stampId] == _owner) {
463           result[resultIndex] = stampId;
464           resultIndex++;
465         }
466       }
467       return result;
468     }
469   }
470 
471   
472   
473   /// For querying totalSupply of token
474   /// @dev Required for ERC-721 compliance.
475   
476   
477   
478   function totalSupply() public view returns (uint256 total) {
479     return stamps.length;
480   }
481 
482   /// Owner initates the transfer of the token to another account
483   /// @param _to The address for the token to be transferred to.
484   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
485   /// @dev Required for ERC-721 compliance.
486   
487   
488   
489   function transfer(
490     address _to,
491     uint256 _tokenId
492   ) public {
493     require(_owns(msg.sender, _tokenId));
494     require(_addressNotNull(_to));
495     require(paused == false);
496 
497     _transfer(msg.sender, _to, _tokenId);
498   }
499 
500   /// Third-party initiates transfer of token from address _from to address _to
501   /// @param _from The address for the token to be transferred from.
502   /// @param _to The address for the token to be transferred to.
503   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
504   /// @dev Required for ERC-721 compliance.
505   
506   
507   
508   function transferFrom(
509     address _from,
510     address _to,
511     uint256 _tokenId
512   ) public {
513     require(_owns(_from, _tokenId));
514     require(_approved(_to, _tokenId));
515     require(_addressNotNull(_to));
516 
517     _transfer(_from, _to, _tokenId);
518   }
519   
520   
521   //@dev To set the number in which the stamp gets dissolved into.
522   uint256 private num;
523   
524   
525   
526   function setnumber(uint256 number) onlyCEO public returns(uint256)
527   {
528       num = number;
529       return num;
530   }
531   
532   
533   //@dev To set the price at which dissolution starts.
534    uint256 private priceatdissolution;
535   
536   
537   
538   function setdissolveprice(uint256 number) onlyCEO public returns(uint256)
539   {
540       priceatdissolution = number;
541       return priceatdissolution;
542   }
543   
544   
545   //@ To set the address to which dissolved stamp is sent.
546   address private addressatdissolution;
547   
548   
549   
550   function setdissolveaddress(address dissolveaddress) onlyCEO public returns(address)
551   {
552       addressatdissolution = dissolveaddress;
553       return addressatdissolution;
554   }
555   
556   
557   //@dev for emergency purposes
558   function controlstampdissolution(bool control,uint256 _tokenId) onlyCEO public
559   {
560       stampIndextodissolved[_tokenId] = control;
561       
562   }
563   
564   
565   //@dev Dissolve function which mines new stamps.
566   function dissolve(uint256 _tokenId) public
567   {   require(paused == false);
568       require(stampIndexToOwner[_tokenId] == msg.sender);
569       require(priceOf(_tokenId)>= priceatdissolution );
570       require(stampIndextodissolved[_tokenId] == false);
571       address reciever = stampIndexToOwner[_tokenId];
572       
573       uint256 price = priceOf(_tokenId);
574       uint256 newprice = SafeMath.div(price,num);
575       
576       approve(addressatdissolution, _tokenId);
577       transfer(addressatdissolution,_tokenId);
578       stampIndextodissolved[_tokenId] = true;
579       
580       uint256 i;
581       for(i = 0; i<num; i++)
582       {
583       _createStamp( reciever, newprice);
584           
585       }
586       Dissolved(msg.sender,_tokenId);
587     
588   }
589   
590  //@dev The contract which is used to interact with dissolved stamps.
591  address private dissolvedcontract; 
592  
593  
594  
595  
596  /*** PUBLIC FUNCTIONS FOR DISSOLVED STAMPS ***/
597  
598  
599  function setdissolvedcontract(address dissolvedaddress) onlyCEO public returns(address)
600  {
601      
602      dissolvedcontract = dissolvedaddress;
603      return dissolvedcontract;
604  }
605  
606  //@dev To transfer dissolved stamp. Requires the contract assigned for dissolution management to send message.
607  function transferdissolvedFrom(
608     address _from,
609     address _to,
610     uint256 _tokenId
611   ) public {
612     require(_owns(_from, _tokenId));
613     require(_addressNotNull(_to));
614     require(msg.sender == dissolvedcontract);
615 
616     _transferdissolved(_from, _to, _tokenId);
617   }
618   
619   
620 
621 
622   
623   
624   
625   
626   
627   /*** PRIVATE FUNCTIONS ***/
628   /// Safety check on _to address to prevent against an unexpected 0x0 default.
629   function _addressNotNull(address _to) private pure returns (bool) {
630     return _to != address(0);
631   }
632 
633   
634   
635   /// For checking approval of transfer for address _to
636   
637   
638   
639   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
640     return stampIndexToApproved[_tokenId] == _to;
641   }
642 
643   
644   /// For creating Stamp
645   
646   
647   function _createStamp(address _owner, uint256 _price) private {
648     Stamp memory _stamp = Stamp({
649       birthtime: now
650     });
651     uint256 newStampId = stamps.push(_stamp) - 1;
652 
653     // It's probably never going to happen, 4 billion tokens are A LOT, but
654     // let's just be 100% sure we never let this happen.
655     require(newStampId == uint256(uint32(newStampId)));
656 
657     stampBirth(newStampId, _owner);
658 
659     stampIndexToPrice[newStampId] = _price;
660 
661     // This will assign ownership, and also emit the Transfer event as
662     // per ERC721 draft
663     _transfer(address(0), _owner, newStampId);
664   }
665 
666   
667   
668   /// Check for token ownership
669   
670   
671   
672   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
673     return claimant == stampIndexToOwner[_tokenId];
674   }
675 
676   
677   
678   /// For paying out balance on contract
679   
680   
681   
682   function _payout(address _to) private {
683     if (_to == address(0)) {
684       ceoAddress.transfer(this.balance);
685     } else {
686       _to.transfer(this.balance);
687     }
688   }
689 
690   
691   
692   
693   /// @dev Assigns ownership of a specific Stamp to an address.
694   
695   
696   
697   function _transfer(address _from, address _to, uint256 _tokenId) private {
698    
699     require(paused == false);
700     ownershipTokenCount[_to]++;
701     stampIndextotransactions[_tokenId] = stampIndextotransactions[_tokenId] + 1;
702     totaltransactions++;
703     //transfer ownership
704     stampIndexToOwner[_tokenId] = _to;
705     
706 
707     // When creating new stamps _from is 0x0, but we can't account that address.
708     if (_from != address(0)) {
709       ownershipTokenCount[_from]--;
710       // clear any previously approved ownership exchange
711       delete stampIndexToApproved[_tokenId];
712     }
713 
714     // Emit the transfer event.
715     Transfer(_from, _to, _tokenId);
716   }
717   
718   
719   
720 /*** PRIVATE FUNCTIONS FOR DISSOLVED STAMPS***/  
721   
722   
723   
724   //@ To transfer a dissolved stamp.
725   function _transferdissolved(address _from, address _to, uint256 _tokenId) private {
726     
727     require(stampIndextodissolved[_tokenId] == true);
728     require(paused == false);
729     ownershipTokenCount[_to]++;
730     stampIndextotransactions[_tokenId] = stampIndextotransactions[_tokenId] + 1;
731     //transfer ownership
732     stampIndexToOwner[_tokenId] = _to;
733     totaltransactions++;
734     
735 
736     // When creating new stamp _from is 0x0, but we can't account that address.
737     if (_from != address(0)) {
738       ownershipTokenCount[_from]--;
739       // clear any previously approved ownership exchange
740       
741     }
742 
743     // Emit the transfer event.
744     TransferDissolved(_from, _to, _tokenId);
745   }
746   
747   
748   
749 }
750 
751 
752 
753 library SafeMath {
754 
755   /**
756   * @dev Multiplies two numbers, throws on overflow.
757   */
758   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
759     if (a == 0) {
760       return 0;
761     }
762     uint256 c = a * b;
763     assert(c / a == b);
764     return c;
765   }
766 
767   /**
768   * @dev Integer division of two numbers, truncating the quotient.
769   */
770   function div(uint256 a, uint256 b) internal pure returns (uint256) {
771     // assert(b > 0); // Solidity automatically throws when dividing by 0
772     uint256 c = a / b;
773     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
774     return c;
775   }
776 
777   /**
778   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
779   */
780   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
781     assert(b <= a);
782     return a - b;
783   }
784 
785   /**
786   * @dev Adds two numbers, throws on overflow.
787   */
788   function add(uint256 a, uint256 b) internal pure returns (uint256) {
789     uint256 c = a + b;
790     assert(c >= a);
791     return c;
792   }
793 }