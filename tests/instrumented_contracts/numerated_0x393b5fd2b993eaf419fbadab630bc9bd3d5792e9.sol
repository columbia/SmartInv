1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
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
28 
29 contract OpinionToken is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new opinion comes into existence.
34   event Birth(uint256 tokenId, string name, address owner);
35 
36   /// @dev The TokenSold event is fired whenever a token is sold.
37   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
38 
39   /// @dev Transfer event as defined in current draft of ERC721. 
40   ///  ownership is assigned, including births.
41   event Transfer(address from, address to, uint256 tokenId);
42 
43   /*** CONSTANTS ***/
44 
45   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
46   string public constant NAME = "Cryptopinions"; // solhint-disable-line
47   string public constant SYMBOL = "OpinionToken"; // solhint-disable-line
48   string public constant DEFAULT_TEXT = "";
49 
50   uint256 private firstStepLimit =  0.053613 ether;
51   uint256 private secondStepLimit = 0.564957 ether;
52   uint256 private numIssued=5; //number of tokens issued initially
53   uint256 private constant stepMultiplier=2;//multiplier for initial opinion registration cost, not sponsorship
54   uint256 private startingPrice = 0.001 ether; //will increase every token issued by stepMultiplier times
55   uint256 private sponsorStartingCost=0.01 ether;//initial cost to sponsor an opinion
56   //uint256 private currentIssueRemaining;
57   /*** STORAGE ***/
58 
59   /// @dev A mapping from opinion IDs to the address that owns them. All opinions have
60   ///  some valid owner address.
61   mapping (uint256 => address) public opinionIndexToOwner;
62 
63   // @dev A mapping from owner address to count of tokens that address owns.
64   //  Used internally inside balanceOf() to resolve ownership count.
65   mapping (address => uint256) private ownershipTokenCount;
66 
67   /// @dev A mapping from opinionIDs to an address that has been approved to call
68   ///  transferFrom(). Each opinion can only have one approved address for transfer
69   ///  at any time. A zero value means no approval is outstanding.
70   mapping (uint256 => address) public opinionIndexToApproved;
71 
72   // @dev A mapping from opinionIDs to the price of the token.
73   mapping (uint256 => uint256) private opinionIndexToPrice;
74   
75   // The addresses of the accounts (or contracts) that can execute actions within each roles.
76   address public ceoAddress;
77   address public cooAddress;
78 
79   /*** DATATYPES ***/
80   struct Opinion {
81     string text;
82     bool claimed;
83     bool deleted;
84     uint8 comment;
85     address sponsor;
86     address antisponsor;
87     uint256 totalsponsored;
88     uint256 totalantisponsored;
89     uint256 timestamp;
90   }
91 
92   Opinion[] private opinions;
93 
94   /*** ACCESS MODIFIERS ***/
95   /// @dev Access modifier for CEO-only functionality
96   modifier onlyCEO() {
97     require(msg.sender == ceoAddress);
98     _;
99   }
100 
101   /// @dev Access modifier for COO-only functionality
102   modifier onlyCOO() {
103     require(msg.sender == cooAddress);
104     _;
105   }
106 
107   /// Access modifier for contract owner only functionality
108   modifier onlyCLevel() {
109     require(
110       msg.sender == ceoAddress ||
111       msg.sender == cooAddress
112     );
113     _;
114   }
115 
116   /*** CONSTRUCTOR ***/
117   function OpinionToken() public {
118     ceoAddress = msg.sender;
119     cooAddress = msg.sender;
120   }
121 
122   /*** PUBLIC FUNCTIONS ***/
123   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
124   /// @param _to The address to be granted transfer approval. Pass address(0) to
125   ///  clear all approvals.
126   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
127   /// @dev Required for ERC-721 compliance.
128   function approve(
129     address _to,
130     uint256 _tokenId
131   ) public {
132     // Caller must own token.
133     require(_owns(msg.sender, _tokenId));
134 
135     opinionIndexToApproved[_tokenId] = _to;
136 
137     Approval(msg.sender, _to, _tokenId);
138   }
139 
140   /// For querying balance of a particular account
141   /// @param _owner The address for balance query
142   /// @dev Required for ERC-721 compliance.
143   function balanceOf(address _owner) public view returns (uint256 balance) {
144     return ownershipTokenCount[_owner];
145   }
146   /// @dev Creates initial set of opinions. Can only be called once.
147   function createInitialItems() public onlyCOO {
148     require(opinions.length==0);
149     _createOpinionSet();
150   }
151 
152   /// @notice Returns all the relevant information about a specific opinion.
153   /// @param _tokenId The tokenId of the opinion of interest.
154   function getOpinion(uint256 _tokenId) public view returns (
155     uint256 sellingPrice,
156     address owner,
157     address sponsor,
158     address antisponsor,
159     uint256 amountsponsored,
160     uint256 amountantisponsored,
161     uint8 acomment,
162     uint256 timestamp,
163     string opinionText
164   ) {
165     Opinion storage opinion = opinions[_tokenId];
166     opinionText = opinion.text;
167     sellingPrice = opinionIndexToPrice[_tokenId];
168     owner = opinionIndexToOwner[_tokenId];
169     acomment=opinion.comment;
170     sponsor=opinion.sponsor;
171     antisponsor=opinion.antisponsor;
172     amountsponsored=opinion.totalsponsored;
173     amountantisponsored=opinion.totalantisponsored;
174     timestamp=opinion.timestamp;
175   }
176 
177   function compareStrings (string a, string b) public pure returns (bool){
178        return keccak256(a) == keccak256(b);
179    }
180   
181   function hasDuplicate(string _tocheck) public view returns (bool){
182     return hasPriorDuplicate(_tocheck,opinions.length);
183   }
184   
185   function hasPriorDuplicate(string _tocheck,uint256 index) public view returns (bool){
186     for(uint i = 0; i<index; i++){
187         if(compareStrings(_tocheck,opinions[i].text)){
188             return true;
189         }
190     }
191     return false;
192   }
193   
194   function implementsERC721() public pure returns (bool) {
195     return true;
196   }
197 
198   /// @dev Required for ERC-721 compliance.
199   function name() public pure returns (string) {
200     return NAME;
201   }
202 
203   /// For querying owner of token
204   /// @param _tokenId The tokenID for owner inquiry
205   /// @dev Required for ERC-721 compliance.
206   function ownerOf(uint256 _tokenId)
207     public
208     view
209     returns (address owner)
210   {
211     owner = opinionIndexToOwner[_tokenId];
212     require(owner != address(0));
213   }
214 
215   function payout(address _to) public onlyCLevel {
216     _payout(_to);
217   }
218 
219   function sponsorOpinion(uint256 _tokenId,uint8 comment,bool _likesOpinion) public payable {
220       //ensure comment corresponds to status of token. Tokens with a comment of 0 are unregistered.
221       require(comment!=0);
222       require((_likesOpinion && comment<100) || (!_likesOpinion && comment>100));
223       address sponsorAdr = msg.sender;
224       require(_addressNotNull(sponsorAdr));
225       // Making sure sent amount is greater than or equal to the sellingPrice
226       uint256 sellingPrice = opinionIndexToPrice[_tokenId];
227       address currentOwner=opinionIndexToOwner[_tokenId];
228       address newOwner = msg.sender;
229       require(_addressNotNull(newOwner));
230       require(_addressNotNull(currentOwner));
231       require(msg.value >= sellingPrice);
232       uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 90), 100));
233       uint256 ownerTake=uint256(SafeMath.div(SafeMath.mul(sellingPrice, 10), 100));
234       uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
235           // Update prices
236     if (sellingPrice < firstStepLimit) {
237       // first stage
238       opinionIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 90);
239     } else if (sellingPrice < secondStepLimit) {
240       // second stage
241       opinionIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 90);
242     } else {
243       // third stage
244       opinionIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 90);
245     }
246     Opinion storage opinion = opinions[_tokenId];
247     require(opinion.claimed);
248     require(sponsorAdr!=opinion.sponsor);
249     require(sponsorAdr!=opinion.antisponsor);
250     require(sponsorAdr!=currentOwner);
251     opinion.comment=comment;
252     if(_likesOpinion){
253         if(_addressNotNull(opinion.sponsor)){
254             opinion.sponsor.transfer(payment);
255             currentOwner.transfer(ownerTake);
256         }
257         else{
258             currentOwner.transfer(sellingPrice);
259         }
260         opinion.sponsor=sponsorAdr;
261         opinion.totalsponsored=SafeMath.add(opinion.totalsponsored,sellingPrice);
262     }
263     else{
264         if(_addressNotNull(opinion.sponsor)){
265             opinion.antisponsor.transfer(payment);
266             ceoAddress.transfer(ownerTake);
267         }
268         else{
269             ceoAddress.transfer(sellingPrice); //eth for initial antisponsor goes to Cryptopinions, because you wouldn't want it to go to the creator of an opinion you don't like
270         }
271         opinion.antisponsor=sponsorAdr;
272         opinion.totalantisponsored=SafeMath.add(opinion.totalantisponsored,sellingPrice);
273     }
274     msg.sender.transfer(purchaseExcess);
275   }
276   
277   //lets you permanently delete someone elses opinion.
278   function deleteThis(uint256 _tokenId) public payable{
279     //Cost is 1 eth or five times the current valuation of the opinion, whichever is higher.
280     uint256 sellingPrice = SafeMath.mul(opinionIndexToPrice[_tokenId],5);
281     if(sellingPrice<1 ether){
282         sellingPrice=1 ether;
283     }
284     require(msg.value >= sellingPrice);
285     ceoAddress.transfer(sellingPrice);
286     Opinion storage opinion = opinions[_tokenId];
287     opinion.deleted=true;
288     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
289     msg.sender.transfer(purchaseExcess);
290   }
291   
292   // Allows someone to send ether and obtain the (unclaimed only) token
293   function registerOpinion(uint256 _tokenId,string _newOpinion) public payable {
294     
295     //Set opinion to the new opinion
296     _initOpinion(_tokenId,_newOpinion);
297     
298     address oldOwner = opinionIndexToOwner[_tokenId];
299     address newOwner = msg.sender;
300 
301     uint256 sellingPrice = opinionIndexToPrice[_tokenId];
302 
303     // Making sure token owner is not sending to self
304     require(oldOwner != newOwner);
305 
306     // Safety check to prevent against an unexpected 0x0 default.
307     require(_addressNotNull(newOwner));
308 
309     // Making sure sent amount is greater than or equal to the sellingPrice
310     require(msg.value >= sellingPrice);
311     
312     uint256 payment = sellingPrice;
313     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
314     opinionIndexToPrice[_tokenId] = sponsorStartingCost; //initial cost to sponsor
315 
316     _transfer(oldOwner, newOwner, _tokenId);
317 
318     ceoAddress.transfer(payment);
319 
320     TokenSold(_tokenId, sellingPrice, opinionIndexToPrice[_tokenId], oldOwner, newOwner, opinions[_tokenId].text);
321 
322     msg.sender.transfer(purchaseExcess);
323   }
324 
325   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
326     return opinionIndexToPrice[_tokenId];
327   }
328 
329   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
330   /// @param _newCEO The address of the new CEO
331   function setCEO(address _newCEO) public onlyCEO {
332     _setCEO(_newCEO);
333   }
334    function _setCEO(address _newCEO) private{
335          require(_newCEO != address(0));
336          ceoAddress = _newCEO;
337    }
338   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
339   /// @param _newCOO The address of the new COO
340   function setCOO(address _newCOO) public onlyCEO {
341     require(_newCOO != address(0));
342 
343     cooAddress = _newCOO;
344   }
345 
346   /// @dev Required for ERC-721 compliance.
347   function symbol() public pure returns (string) {
348     return SYMBOL;
349   }
350 
351   /// @notice Allow pre-approved user to take ownership of a token
352   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
353   /// @dev Required for ERC-721 compliance.
354   function takeOwnership(uint256 _tokenId) public {
355     address newOwner = msg.sender;
356     address oldOwner = opinionIndexToOwner[_tokenId];
357 
358     // Safety check to prevent against an unexpected 0x0 default.
359     require(_addressNotNull(newOwner));
360 
361     // Making sure transfer is approved
362     require(_approved(newOwner, _tokenId));
363 
364     _transfer(oldOwner, newOwner, _tokenId);
365   }
366 
367   /// @param _owner The owner whose celebrity tokens we are interested in.
368   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
369   ///  expensive (it walks the entire opinions array looking for opinions belonging to owner),
370   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
371   ///  not contract-to-contract calls.
372   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
373     uint256 tokenCount = balanceOf(_owner);
374     if (tokenCount == 0) {
375         // Return an empty array
376       return new uint256[](0);
377     } else {
378       uint256[] memory result = new uint256[](tokenCount);
379       uint256 totalOpinions = totalSupply();
380       uint256 resultIndex = 0;
381 
382       uint256 opinionId;
383       for (opinionId = 0; opinionId <= totalOpinions; opinionId++) {
384         if (opinionIndexToOwner[opinionId] == _owner) {
385           result[resultIndex] = opinionId;
386           resultIndex++;
387         }
388       }
389       return result;
390     }
391   }
392 
393   /// For querying totalSupply of token
394   /// @dev Required for ERC-721 compliance.
395   function totalSupply() public view returns (uint256 total) {
396     return opinions.length;
397   }
398 
399   /// Owner initates the transfer of the token to another account
400   /// @param _to The address for the token to be transferred to.
401   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
402   /// @dev Required for ERC-721 compliance.
403   function transfer(
404     address _to,
405     uint256 _tokenId
406   ) public {
407     require(_owns(msg.sender, _tokenId));
408     require(_addressNotNull(_to));
409 
410     _transfer(msg.sender, _to, _tokenId);
411   }
412 
413   /// Third-party initiates transfer of token from address _from to address _to
414   /// @param _from The address for the token to be transferred from.
415   /// @param _to The address for the token to be transferred to.
416   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
417   /// @dev Required for ERC-721 compliance.
418   function transferFrom(
419     address _from,
420     address _to,
421     uint256 _tokenId
422   ) public {
423     require(_owns(_from, _tokenId));
424     require(_approved(_to, _tokenId));
425     require(_addressNotNull(_to));
426 
427     _transfer(_from, _to, _tokenId);
428   }
429   
430 //Allows purchase of the entire contract. All revenue provisioned to ceoAddress will go to the new address specified.
431 //If you contact us following purchase we will transfer domain, website source code etc. to you free of charge, otherwise we will continue to maintain the frontend site for 1 year.
432 uint256 contractPrice=300 ether;
433 function buyCryptopinions(address _newCEO) payable public{
434     require(msg.value >= contractPrice);
435     ceoAddress.transfer(msg.value);
436     _setCEO(_newCEO);
437     _setPrice(9999999 ether);
438 }
439 function setPrice(uint256 newprice) public onlyCEO{
440     _setPrice(newprice);
441 }
442 function _setPrice(uint256 newprice) private{
443     contractPrice=newprice;
444 }
445 
446   /*** PRIVATE FUNCTIONS ***/
447   /// Safety check on _to address to prevent against an unexpected 0x0 default.
448   function _addressNotNull(address _to) private pure returns (bool) {
449     return _to != address(0);
450   }
451 
452   /// For checking approval of transfer for address _to
453   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
454     return opinionIndexToApproved[_tokenId] == _to;
455   }
456   
457   function _createOpinionSet() private {
458       for(uint i = 0; i<numIssued; i++){
459         _createOpinion(DEFAULT_TEXT,ceoAddress,startingPrice);
460       }
461       //startingPrice = SafeMath.mul(startingPrice,stepMultiplier); //increase the price for the next set of tokens
462       //currentIssueRemaining=numIssued;
463       
464   }
465   
466   //for registering an Opinion
467   function _initOpinion(uint256 _tokenId,string _newOpinion) private {
468       Opinion storage opinion = opinions[_tokenId];
469       opinion.timestamp=now;
470       opinion.text=_newOpinion;
471       opinion.comment=1;
472       require(!opinion.claimed);
473         uint256 newprice=SafeMath.mul(stepMultiplier,opinionIndexToPrice[_tokenId]);
474         //max price 1 eth
475         if(newprice > 0.1 ether){ //max price for a new opinion, 1 ether
476             newprice=0.1 ether;
477         }
478         _createOpinion("",ceoAddress,newprice); //make a new opinion for someone else to buy
479         opinion.claimed=true;
480       
481           //currentIssueRemaining=SafeMath.sub(currentIssueRemaining,1);
482           //if this is the last remaining token for sale, issue more
483           //if(currentIssueRemaining == 0){
484           //    _createOpinionSet();
485           //}
486       
487       
488   }
489   
490   /// For creating Opinion
491   function _createOpinion(string _name, address _owner, uint256 _price) private {
492     Opinion memory _opinion = Opinion({
493       text: _name,
494       claimed: false,
495       deleted: false,
496       comment: 0,
497       sponsor: _owner,
498       antisponsor: ceoAddress,
499       totalsponsored:0,
500       totalantisponsored:0,
501       timestamp:now
502     });
503     uint256 newOpinionId = opinions.push(_opinion) - 1;
504 
505     // It's probably never going to happen, 4 billion tokens are A LOT, but
506     // let's just be 100% sure we never let this happen.
507     require(newOpinionId == uint256(uint32(newOpinionId)));
508 
509     Birth(newOpinionId, _name, _owner);
510 
511     opinionIndexToPrice[newOpinionId] = _price;
512 
513     // This will assign ownership, and also emit the Transfer event as
514     // per ERC721 draft
515     _transfer(address(0), _owner, newOpinionId);
516   }
517 
518   /// Check for token ownership
519   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
520     return claimant == opinionIndexToOwner[_tokenId];
521   }
522 
523   /// For paying out balance on contract
524   function _payout(address _to) private {
525     if (_to == address(0)) {
526       ceoAddress.transfer(this.balance);
527     } else {
528       _to.transfer(this.balance);
529     }
530   }
531 
532   /// @dev Assigns ownership of a specific opinion to an address.
533   function _transfer(address _from, address _to, uint256 _tokenId) private {
534     // Since the number of opinions is capped to 2^32 we can't overflow this
535     ownershipTokenCount[_to]++;
536     //transfer ownership
537     opinionIndexToOwner[_tokenId] = _to;
538 
539     // When creating new opinions _from is 0x0, but we can't account that address.
540     if (_from != address(0)) {
541       ownershipTokenCount[_from]--;
542       // clear any previously approved ownership exchange
543       delete opinionIndexToApproved[_tokenId];
544     }
545 
546     // Emit the transfer event.
547     Transfer(_from, _to, _tokenId);
548   }
549 }
550 library SafeMath {
551 
552   /**
553   * @dev Multiplies two numbers, throws on overflow.
554   */
555   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
556     if (a == 0) {
557       return 0;
558     }
559     uint256 c = a * b;
560     assert(c / a == b);
561     return c;
562   }
563 
564   /**
565   * @dev Integer division of two numbers, truncating the quotient.
566   */
567   function div(uint256 a, uint256 b) internal pure returns (uint256) {
568     // assert(b > 0); // Solidity automatically throws when dividing by 0
569     uint256 c = a / b;
570     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
571     return c;
572   }
573 
574   /**
575   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
576   */
577   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
578     assert(b <= a);
579     return a - b;
580   }
581 
582   /**
583   * @dev Adds two numbers, throws on overflow.
584   */
585   function add(uint256 a, uint256 b) internal pure returns (uint256) {
586     uint256 c = a + b;
587     assert(c >= a);
588     return c;
589   }
590 }