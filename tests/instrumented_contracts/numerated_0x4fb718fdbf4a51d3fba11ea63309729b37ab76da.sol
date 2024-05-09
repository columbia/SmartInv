1 pragma solidity ^0.4.20; // solhint-disable-line
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
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
19 
20   // Optional
21   // function name() public view returns (string name);
22   // function symbol() public view returns (string symbol);
23   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
24   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
25 }
26 
27 
28 contract AVStarsToken is ERC721 {
29   using SafeMath for uint256;
30   /*** EVENTS ***/
31 
32   /// @dev The Birth event is fired whenever a new person comes into existence.
33   event Birth(
34     uint256 tokenId, 
35     string name, 
36     uint64 satisfaction,
37     uint64 cooldownTime,
38     string slogan,
39     address owner);
40 
41   /// @dev The TokenSold event is fired whenever a token is sold.
42   event TokenSold(
43     uint256 tokenId, 
44     uint256 oldPrice, 
45     uint256 newPrice, 
46     address prevOwner, 
47     address winner, 
48     string name);
49 
50   /// @dev Transfer event as defined in current draft of ERC721. 
51   ///  ownership is assigned, including births.
52   event Transfer(address from, address to, uint256 tokenId);
53 
54   event MoreActivity(uint256 tokenId, address Owner, uint64 startTime, uint64 cooldownTime, uint256 _type);
55   event ChangeSlogan(string slogan);
56 
57   /*** CONSTANTS ***/
58 
59   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
60   string public constant NAME = "AVStars"; // solhint-disable-line
61   string public constant SYMBOL = "AVS"; // solhint-disable-line
62 
63   uint256 private startingPrice = 0.3 ether;
64   uint256 private constant PROMO_CREATION_LIMIT = 30000;
65   uint256 private firstStepLimit =  1.6 ether;
66   /*** STORAGE ***/
67 
68   /// @dev A mapping from person IDs to the address that owns them. All persons have
69   ///  some valid owner address.
70   mapping (uint256 => address) public personIndexToOwner;
71 
72   // @dev A mapping from owner address to count of tokens that address owns.
73   //  Used internally inside balanceOf() to resolve ownership count.
74   mapping (address => uint256) private ownershipTokenCount;
75 
76   /// @dev A mapping from PersonIDs to an address that has been approved to call
77   ///  transferFrom(). Each Person can only have one approved address for transfer
78   ///  at any time. A zero value means no approval is outstanding.
79   mapping (uint256 => address) public personIndexToApproved;
80 
81   // @dev A mapping from PersonIDs to the price of the token.
82   mapping (uint256 => uint256) private personIndexToPrice;
83 
84 
85   // The addresses of the accounts (or contracts) that can execute actions within each roles.
86   address public ceoAddress;
87   address public cooAddress;
88   uint256 public promoCreatedCount;
89   bool isPaused;
90     
91 
92   /*** DATATYPES ***/
93   struct Person {
94     string name;
95     uint256 satisfaction;
96     uint64 cooldownTime;
97     string slogan;
98     uint256 basePrice;
99   }
100 
101   Person[] private persons;
102 
103   /*** ACCESS MODIFIERS ***/
104   /// @dev Access modifier for CEO-only functionality
105   modifier onlyCEO() {
106     require(msg.sender == ceoAddress);
107     _;
108   }
109 
110   /// @dev Access modifier for COO-only functionality
111   modifier onlyCOO() {
112     require(msg.sender == cooAddress);
113     _;
114   }
115 
116   /// Access modifier for contract owner only functionality
117   modifier onlyCLevel() {
118     require(
119       msg.sender == ceoAddress ||
120       msg.sender == cooAddress
121     );
122     _;
123   }
124 
125   /*** CONSTRUCTOR ***/
126   function AVStarsToken() public {
127     ceoAddress = msg.sender;
128     cooAddress = msg.sender;
129     isPaused = false;
130   }
131 
132   /*** PUBLIC FUNCTIONS ***/
133   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
134   /// @param _to The address to be granted transfer approval. Pass address(0) to
135   ///  clear all approvals.
136   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
137   /// @dev Required for ERC-721 compliance.
138   function approve(
139     address _to,
140     uint256 _tokenId
141   ) public {
142     // Caller must own token.
143     require(_owns(msg.sender, _tokenId));
144 
145     personIndexToApproved[_tokenId] = _to;
146 
147     Approval(msg.sender, _to, _tokenId);
148   }
149 
150   /// For querying balance of a particular account
151   /// @param _owner The address for balance query
152   /// @dev Required for ERC-721 compliance.
153   function balanceOf(address _owner) public view returns (uint256 balance) {
154     return ownershipTokenCount[_owner];
155   }
156 
157   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
158   function createPromoPerson(
159     address _owner, 
160     string _name, 
161     uint64 _satisfaction,
162     uint64 _cooldownTime,
163     string _slogan,
164     uint256 _price) public onlyCOO {
165     require(promoCreatedCount < PROMO_CREATION_LIMIT);
166 
167     address personOwner = _owner;
168     if (personOwner == address(0)) {
169       personOwner = cooAddress;
170     }
171 
172     if (_price <= 0) {
173       _price = startingPrice;
174     }
175 
176     promoCreatedCount++;
177     _createPerson(
178       _name, 
179       _satisfaction,
180       _cooldownTime,
181       _slogan,
182       personOwner, 
183       _price);
184   }
185 
186   /// @dev Creates a new Person with the given name.
187   function createContractPerson(string _name) public onlyCOO {
188     _createPerson(
189       _name,
190       0,
191       uint64(now),
192       "", 
193       address(this), 
194       startingPrice);
195   }
196 
197   /// @notice Returns all the relevant information about a specific person.
198   /// @param _tokenId The tokenId of the person of interest.
199   function getPerson(uint256 _tokenId) public view returns (
200     string personName,
201     uint64 satisfaction,
202     uint64 cooldownTime,
203     string slogan,
204     uint256 basePrice,
205     uint256 sellingPrice,
206     address owner
207   ) {
208     Person storage person = persons[_tokenId];
209     personName = person.name;
210     satisfaction = uint64(person.satisfaction);
211     cooldownTime = uint64(person.cooldownTime);
212     slogan = person.slogan;
213     basePrice = person.basePrice;
214     sellingPrice = personIndexToPrice[_tokenId];
215     owner = personIndexToOwner[_tokenId];
216   }
217 
218   function implementsERC721() public pure returns (bool) {
219     return true;
220   }
221 
222   /// @dev Required for ERC-721 compliance.
223   function name() public pure returns (string) {
224     return NAME;
225   }
226 
227   /*
228   We use the following functions to pause and unpause the game.
229   */
230   function pauseGame() public onlyCLevel {
231       isPaused = true;
232   }
233   function unPauseGame() public onlyCLevel {
234       isPaused = false;
235   }
236   function GetIsPauded() public view returns(bool) {
237      return(isPaused);
238   }
239 
240 
241   /// For querying owner of token
242   /// @param _tokenId The tokenID for owner inquiry
243   /// @dev Required for ERC-721 compliance.
244   function ownerOf(uint256 _tokenId)
245     public
246     view
247     returns (address owner)
248   {
249     owner = personIndexToOwner[_tokenId];
250     require(owner != address(0));
251   }
252 
253   function payout(address _to) public onlyCLevel {
254     _payout(_to);
255   }
256 
257   // Allows someone to send ether and obtain the token
258   function purchase(uint256 _tokenId) public payable {
259     require(isPaused == false);
260     address oldOwner = personIndexToOwner[_tokenId];
261     address newOwner = msg.sender;
262 
263     uint256 sellingPrice = personIndexToPrice[_tokenId];
264 
265     // Making sure token owner is not sending to self
266     require(oldOwner != newOwner);
267     require(_addressNotNull(newOwner));
268     require(msg.value >= sellingPrice);
269 
270     Person storage person = persons[_tokenId];
271     require(person.cooldownTime<uint64(now));
272     uint256 payment = sellingPrice.mul(95).div(100);
273     uint256 devCut = msg.value.sub(payment);
274 
275     // Update prices
276     if (sellingPrice < firstStepLimit) {
277       // first stage
278       person.basePrice = personIndexToPrice[_tokenId];
279       personIndexToPrice[_tokenId] = sellingPrice.mul(300).div(200);
280       
281     } else {
282       // second stage
283       person.satisfaction = person.satisfaction.mul(50).div(100);
284       person.basePrice = personIndexToPrice[_tokenId];
285       personIndexToPrice[_tokenId] = sellingPrice.mul(120).div(100);
286       person.cooldownTime = uint64(now + 15 minutes);
287     }
288 
289     _transfer(oldOwner, newOwner, _tokenId);
290     if (oldOwner != address(this)) {
291       oldOwner.transfer(payment); 
292     }
293     ceoAddress.transfer(devCut);
294     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, persons[_tokenId].name);
295   }
296 
297   function activity(uint256 _tokenId, uint256 _type) public payable {
298     require(isPaused == false);
299     require(personIndexToOwner[_tokenId] == msg.sender);
300     require(personIndexToPrice[_tokenId] >= 2000000000000000000);
301     require(_type <= 2);
302     uint256 _hours;
303 
304     // type, 0 for movie, 1 for beach, 2 for trip 
305     if ( _type == 0 ) {
306       _hours = 6;
307     } else if (_type == 1) {
308       _hours = 12;
309     } else {
310       _hours = 48;
311     }
312 
313     uint256 payment = personIndexToPrice[_tokenId].div(80).mul(_hours);
314     require(msg.value >= payment);
315     uint64 startTime;
316 
317     Person storage person = persons[_tokenId];
318     
319     person.satisfaction += _hours.mul(1);
320     if (person.satisfaction > 100) {
321       person.satisfaction = 100;
322     }
323     uint256 newPrice;
324     person.basePrice = person.basePrice.add(payment);
325     newPrice = person.basePrice.mul(120+uint256(person.satisfaction)).div(100);
326     personIndexToPrice[_tokenId] = newPrice;
327     if (person.cooldownTime > now) {
328       startTime = person.cooldownTime;
329       person.cooldownTime = startTime +  uint64(_hours) * 1 hours;
330       
331     } else {
332       startTime = uint64(now);
333       person.cooldownTime = startTime+ uint64(_hours) * 1 hours;
334     }
335     ceoAddress.transfer(msg.value);
336     MoreActivity(_tokenId, msg.sender, startTime, person.cooldownTime, _type);
337   }
338 
339   function modifySlogan(uint256 _tokenId, string _slogan) public payable {
340     require(personIndexToOwner[_tokenId]==msg.sender);
341     Person storage person = persons[_tokenId];
342     person.slogan = _slogan;
343     msg.sender.transfer(msg.value);
344     ChangeSlogan(person.slogan);
345   }
346 
347   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
348     return personIndexToPrice[_tokenId];
349   }
350 
351   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
352   /// @param _newCEO The address of the new CEO
353   function setCEO(address _newCEO) public onlyCEO {
354     require(_newCEO != address(0));
355 
356     ceoAddress = _newCEO;
357   }
358 
359   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
360   /// @param _newCOO The address of the new COO
361   function setCOO(address _newCOO) public onlyCEO {
362     require(_newCOO != address(0));
363 
364     cooAddress = _newCOO;
365   }
366 
367   /// @dev Required for ERC-721 compliance.
368   function symbol() public pure returns (string) {
369     return SYMBOL;
370   }
371 
372   /// @notice Allow pre-approved user to take ownership of a token
373   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
374   /// @dev Required for ERC-721 compliance.
375   function takeOwnership(uint256 _tokenId) public {
376     address newOwner = msg.sender;
377     address oldOwner = personIndexToOwner[_tokenId];
378 
379     // Safety check to prevent against an unexpected 0x0 default.
380     require(_addressNotNull(newOwner));
381 
382     // Making sure transfer is approved
383     require(_approved(newOwner, _tokenId));
384 
385     _transfer(oldOwner, newOwner, _tokenId);
386   }
387 
388   /// @param _owner The owner whose celebrity tokens we are interested in.
389   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
390   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
391   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
392   ///  not contract-to-contract calls.
393   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
394     uint256 tokenCount = balanceOf(_owner);
395     if (tokenCount == 0) {
396         // Return an empty array
397       return new uint256[](0);
398     } else {
399       uint256[] memory result = new uint256[](tokenCount);
400       uint256 totalPersons = totalSupply();
401       uint256 resultIndex = 0;
402 
403       uint256 personId;
404       for (personId = 0; personId <= totalPersons; personId++) {
405         if (personIndexToOwner[personId] == _owner) {
406           result[resultIndex] = personId;
407           resultIndex++;
408         }
409       }
410       return result;
411     }
412   }
413 
414   /// For querying totalSupply of token
415   /// @dev Required for ERC-721 compliance.
416   function totalSupply() public view returns (uint256 total) {
417     return persons.length;
418   }
419 
420   /// Owner initates the transfer of the token to another account
421   /// @param _to The address for the token to be transferred to.
422   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
423   /// @dev Required for ERC-721 compliance.
424   function transfer(
425     address _to,
426     uint256 _tokenId
427   ) public {
428     require(_owns(msg.sender, _tokenId));
429     require(_addressNotNull(_to));
430 
431     _transfer(msg.sender, _to, _tokenId);
432   }
433 
434   /// Third-party initiates transfer of token from address _from to address _to
435   /// @param _from The address for the token to be transferred from.
436   /// @param _to The address for the token to be transferred to.
437   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
438   /// @dev Required for ERC-721 compliance.
439   function transferFrom(
440     address _from,
441     address _to,
442     uint256 _tokenId
443   ) public {
444     require(_owns(_from, _tokenId));
445     require(_approved(_to, _tokenId));
446     require(_addressNotNull(_to));
447 
448     _transfer(_from, _to, _tokenId);
449   }
450 
451   /*** PRIVATE FUNCTIONS ***/
452   /// Safety check on _to address to prevent against an unexpected 0x0 default.
453   function _addressNotNull(address _to) private pure returns (bool) {
454     return _to != address(0);
455   }
456 
457   /// For checking approval of transfer for address _to
458   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
459     return personIndexToApproved[_tokenId] == _to;
460   }
461 
462   /// For creating Person
463   function _createPerson(
464     string _name,     
465     uint64 _satisfaction,
466     uint64 _cooldownTime,
467     string _slogan,
468     address _owner, 
469     uint256 _basePrice) private {
470     Person memory _person = Person({
471       name: _name,
472       satisfaction: _satisfaction,
473       cooldownTime: _cooldownTime,
474       slogan:_slogan,
475       basePrice:_basePrice
476     });
477     uint256 newPersonId = persons.push(_person) - 1;
478 
479     // It's probably never going to happen, 4 billion tokens are A LOT, but
480     // let's just be 100% sure we never let this happen.
481     require(newPersonId == uint256(uint32(newPersonId)));
482 
483     Birth(
484       newPersonId, 
485       _name, 
486       _satisfaction,
487       _cooldownTime,
488       _slogan,
489       _owner);
490 
491     personIndexToPrice[newPersonId] = _basePrice;
492 
493     // This will assign ownership, and also emit the Transfer event as
494     // per ERC721 draft
495     _transfer(address(0), _owner, newPersonId);
496   }
497 
498   /// Check for token ownership
499   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
500     return claimant == personIndexToOwner[_tokenId];
501   }
502 
503   /// For paying out balance on contract
504   function _payout(address _to) private {
505     if (_to == address(0)) {
506       ceoAddress.transfer(this.balance);
507     } else {
508       _to.transfer(this.balance);
509     }
510   }
511 
512   /// @dev Assigns ownership of a specific Person to an address.
513   function _transfer(address _from, address _to, uint256 _tokenId) private {
514     // Since the number of persons is capped to 2^32 we can't overflow this
515     ownershipTokenCount[_to]++;
516     //transfer ownership
517     personIndexToOwner[_tokenId] = _to;
518 
519     // When creating new persons _from is 0x0, but we can't account that address.
520     if (_from != address(0)) {
521       ownershipTokenCount[_from]--;
522       // clear any previously approved ownership exchange
523       delete personIndexToApproved[_tokenId];
524     }
525 
526     // Emit the transfer event.
527     Transfer(_from, _to, _tokenId);
528   }
529 }
530 library SafeMath {
531 
532   /**
533   * @dev Multiplies two numbers, throws on overflow.
534   */
535   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
536     if (a == 0) {
537       return 0;
538     }
539     uint256 c = a * b;
540     assert(c / a == b);
541     return c;
542   }
543 
544   /**
545   * @dev Integer division of two numbers, truncating the quotient.
546   */
547   function div(uint256 a, uint256 b) internal pure returns (uint256) {
548     // assert(b > 0); // Solidity automatically throws when dividing by 0
549     uint256 c = a / b;
550     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
551     return c;
552   }
553 
554   /**
555   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
556   */
557   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
558     assert(b <= a);
559     return a - b;
560   }
561 
562   /**
563   * @dev Adds two numbers, throws on overflow.
564   */
565   function add(uint256 a, uint256 b) internal pure returns (uint256) {
566     uint256 c = a + b;
567     assert(c >= a);
568     return c;
569   }
570 }