1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two numbers, throws on overflow.
11      */
12     function mul(uint a, uint b) internal pure returns(uint) {
13         if (a == 0) {
14             return 0;
15         }
16         uint c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      */
23     function div(uint a, uint b) internal pure returns(uint) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29     /**
30      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31      */
32     function sub(uint a, uint b) internal pure returns(uint) {
33         assert(b <= a);
34         return a - b;
35     }
36     /**
37      * @dev Adds two numbers, throws on overflow.
38      */
39     function add(uint a, uint b) internal pure returns(uint) {
40         uint c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
47 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
48 
49 contract ERC721 {
50     // Required methods
51     function approve(address _to, uint _tokenId) public;
52     function balanceOf(address _owner) public view returns(uint balance);
53     function implementsERC721() public pure returns(bool);
54     function ownerOf(uint _tokenId) public view returns(address addr);
55     function takeOwnership(uint _tokenId) public;
56     function totalSupply() public view returns(uint total);
57     function transferFrom(address _from, address _to, uint _tokenId) public;
58     function transfer(address _to, uint _tokenId) public;
59 
60     //event Transfer(uint tokenId, address indexed from, address indexed to);
61     event Approval(uint tokenId, address indexed owner, address indexed approved);
62     
63     // Optional
64     // function name() public view returns (string name);
65     // function symbol() public view returns (string symbol);
66     // function tokenOfOwnerByIndex(address _owner, uint _index) external view returns (uint tokenId);
67     // function tokenMetadata(uint _tokenId) public view returns (string infoUrl);
68 }
69 contract CryptoCovfefes is ERC721 {
70     /*** CONSTANTS ***/
71     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
72     string public constant NAME = "CryptoCovfefes";
73     string public constant SYMBOL = "Covfefe Token";
74     
75     uint private constant startingPrice = 0.001 ether;
76     
77     uint private constant PROMO_CREATION_LIMIT = 5000;
78     uint private constant CONTRACT_CREATION_LIMIT = 45000;
79     uint private constant SaleCooldownTime = 12 hours;
80     
81     uint private randNonce = 0;
82     uint private constant duelVictoryProbability = 51;
83     uint private constant duelFee = .001 ether;
84     
85     uint private addMeaningFee = .001 ether;
86 
87     /*** EVENTS ***/
88         /// @dev The Creation event is fired whenever a new Covfefe comes into existence.
89     event NewCovfefeCreated(uint tokenId, string term, string meaning, uint generation, address owner);
90     
91     /// @dev The Meaning added event is fired whenever a Covfefe is defined
92     event CovfefeMeaningAdded(uint tokenId, string term, string meaning);
93     
94     /// @dev The CovfefeSold event is fired whenever a token is bought and sold.
95     event CovfefeSold(uint tokenId, string term, string meaning, uint generation, uint sellingpPice, uint currentPrice, address buyer, address seller);
96     
97      /// @dev The Add Value To Covfefe event is fired whenever value is added to the Covfefe token
98     event AddedValueToCovfefe(uint tokenId, string term, string meaning, uint generation, uint currentPrice);
99     
100      /// @dev The Transfer Covfefe event is fired whenever a Covfefe token is transferred
101      event CovfefeTransferred(uint tokenId, address from, address to);
102      
103     /// @dev The ChallengerWinsCovfefeDuel event is fired whenever the Challenging Covfefe wins a duel
104     event ChallengerWinsCovfefeDuel(uint tokenIdChallenger, string termChallenger, uint tokenIdDefender, string termDefender);
105     
106     /// @dev The DefenderWinsCovfefeDuel event is fired whenever the Challenging Covfefe wins a duel
107     event DefenderWinsCovfefeDuel(uint tokenIdDefender, string termDefender, uint tokenIdChallenger, string termChallenger);
108 
109     /*** STORAGE ***/
110     /// @dev A mapping from covfefe IDs to the address that owns them. All covfefes have
111     ///  some valid owner address.
112     mapping(uint => address) public covfefeIndexToOwner;
113     
114     // @dev A mapping from owner address to count of tokens that address owns.
115     //  Used internally inside balanceOf() to resolve ownership count.
116     mapping(address => uint) private ownershipTokenCount;
117     
118     /// @dev A mapping from CovfefeIDs to an address that has been approved to call
119     ///  transferFrom(). Each Covfefe can only have one approved address for transfer
120     ///  at any time. A zero value means no approval is outstanding.
121     mapping(uint => address) public covfefeIndexToApproved;
122     
123     // @dev A mapping from CovfefeIDs to the price of the token.
124     mapping(uint => uint) private covfefeIndexToPrice;
125     
126     // @dev A mapping from CovfefeIDs to the price of the token.
127     mapping(uint => uint) private covfefeIndexToLastPrice;
128     
129     // The addresses of the accounts (or contracts) that can execute actions within each roles.
130     address public covmanAddress;
131     address public covmanagerAddress;
132     uint public promoCreatedCount;
133     uint public contractCreatedCount;
134     
135     /*** DATATYPES ***/
136     struct Covfefe {
137         string term;
138         string meaning;
139         uint16 generation;
140         uint16 winCount;
141         uint16 lossCount;
142         uint64 saleReadyTime;
143     }
144     
145     Covfefe[] private covfefes;
146     /*** ACCESS MODIFIERS ***/
147     /// @dev Access modifier for Covman-only functionality
148     modifier onlyCovman() {
149         require(msg.sender == covmanAddress);
150         _;
151     }
152     /// @dev Access modifier for Covmanager-only functionality
153     modifier onlyCovmanager() {
154         require(msg.sender == covmanagerAddress);
155         _;
156     }
157     /// Access modifier for contract owner only functionality
158     modifier onlyCovDwellers() {
159         require(msg.sender == covmanAddress || msg.sender == covmanagerAddress);
160         _;
161     }
162     
163     /*** CONSTRUCTOR ***/
164     function CryptoCovfefes() public {
165         covmanAddress = msg.sender;
166         covmanagerAddress = msg.sender;
167     }
168     /*** PUBLIC FUNCTIONS ***/
169     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
170     /// @param _to The address to be granted transfer approval. Pass address(0) to
171     ///  clear all approvals.
172     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
173     /// @dev Required for ERC-721 compliance.
174     function approve(address _to, uint _tokenId) public {
175         // Caller must own token.
176         require(_owns(msg.sender, _tokenId));
177         covfefeIndexToApproved[_tokenId] = _to;
178         emit Approval(_tokenId, msg.sender, _to);
179     }
180     
181     /// For querying balance of a particular account
182     /// @param _owner The address for balance query
183     /// @dev Required for ERC-721 compliance.
184     function balanceOf(address _owner) public view returns(uint balance) {
185         return ownershipTokenCount[_owner];
186     }
187     ///////////////////Create Covfefe///////////////////////////
188 
189     /// @dev Creates a new promo Covfefe with the given term, with given _price and assignes it to an address.
190     function createPromoCovfefe(address _owner, string _term, string _meaning, uint16 _generation, uint _price) public onlyCovmanager {
191         require(promoCreatedCount < PROMO_CREATION_LIMIT);
192         address covfefeOwner = _owner;
193         if (covfefeOwner == address(0)) {
194             covfefeOwner = covmanagerAddress;
195         }
196         if (_price <= 0) {
197             _price = startingPrice;
198         }
199         promoCreatedCount++;
200         _createCovfefe(_term, _meaning, _generation, covfefeOwner, _price);
201     }
202     
203     /// @dev Creates a new Covfefe with the given term.
204     function createContractCovfefe(string _term, string _meaning, uint16 _generation) public onlyCovmanager {
205         require(contractCreatedCount < CONTRACT_CREATION_LIMIT);
206         contractCreatedCount++;
207         _createCovfefe(_term, _meaning, _generation, address(this), startingPrice);
208     }
209 
210     function _triggerSaleCooldown(Covfefe storage _covfefe) internal {
211         _covfefe.saleReadyTime = uint64(now + SaleCooldownTime);
212     }
213 
214     function _ripeForSale(Covfefe storage _covfefe) internal view returns(bool) {
215         return (_covfefe.saleReadyTime <= now);
216     }
217     /// @notice Returns all the relevant information about a specific covfefe.
218     /// @param _tokenId The tokenId of the covfefe of interest.
219     function getCovfefe(uint _tokenId) public view returns(string Term, string Meaning, uint Generation, uint ReadyTime, uint WinCount, uint LossCount, uint CurrentPrice, uint LastPrice, address Owner) {
220         Covfefe storage covfefe = covfefes[_tokenId];
221         Term = covfefe.term;
222         Meaning = covfefe.meaning;
223         Generation = covfefe.generation;
224         ReadyTime = covfefe.saleReadyTime;
225         WinCount = covfefe.winCount;
226         LossCount = covfefe.lossCount;
227         CurrentPrice = covfefeIndexToPrice[_tokenId];
228         LastPrice = covfefeIndexToLastPrice[_tokenId];
229         Owner = covfefeIndexToOwner[_tokenId];
230     }
231 
232     function implementsERC721() public pure returns(bool) {
233         return true;
234     }
235     /// @dev Required for ERC-721 compliance.
236     function name() public pure returns(string) {
237         return NAME;
238     }
239     
240     /// For querying owner of token
241     /// @param _tokenId The tokenID for owner inquiry
242     /// @dev Required for ERC-721 compliance.
243     
244     function ownerOf(uint _tokenId)
245     public
246     view
247     returns(address owner) {
248         owner = covfefeIndexToOwner[_tokenId];
249         require(owner != address(0));
250     }
251     modifier onlyOwnerOf(uint _tokenId) {
252         require(msg.sender == covfefeIndexToOwner[_tokenId]);
253         _;
254     }
255     
256     ///////////////////Add Meaning /////////////////////
257     
258     function addMeaningToCovfefe(uint _tokenId, string _newMeaning) external payable onlyOwnerOf(_tokenId) {
259         
260         /// Making sure the transaction is not from another smart contract
261         require(!isContract(msg.sender));
262         
263         /// Making sure the addMeaningFee is included
264         require(msg.value == addMeaningFee);
265         
266         /// Add the new meaning
267         covfefes[_tokenId].meaning = _newMeaning;
268     
269         /// Emit the term meaning added event.
270         emit CovfefeMeaningAdded(_tokenId, covfefes[_tokenId].term, _newMeaning);
271     }
272 
273     function payout(address _to) public onlyCovDwellers {
274         _payout(_to);
275     }
276     /////////////////Buy Token ////////////////////
277     
278     // Allows someone to send ether and obtain the token
279     function buyCovfefe(uint _tokenId) public payable {
280         address oldOwner = covfefeIndexToOwner[_tokenId];
281         address newOwner = msg.sender;
282         
283         // Making sure sale cooldown is not in effect
284         Covfefe storage myCovfefe = covfefes[_tokenId];
285         require(_ripeForSale(myCovfefe));
286         
287         // Making sure the transaction is not from another smart contract
288         require(!isContract(msg.sender));
289         
290         covfefeIndexToLastPrice[_tokenId] = covfefeIndexToPrice[_tokenId];
291         uint sellingPrice = covfefeIndexToPrice[_tokenId];
292         
293         // Making sure token owner is not sending to self
294         require(oldOwner != newOwner);
295         
296         // Safety check to prevent against an unexpected 0x0 default.
297         require(_addressNotNull(newOwner));
298         
299         // Making sure sent amount is greater than or equal to the sellingPrice
300         require(msg.value >= sellingPrice);
301         uint payment = uint(SafeMath.div(SafeMath.mul(sellingPrice, 95), 100));
302         uint purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
303         
304         // Update prices
305         covfefeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 95);
306         _transfer(oldOwner, newOwner, _tokenId);
307         
308         ///Trigger Sale cooldown
309         _triggerSaleCooldown(myCovfefe);
310         
311         // Pay previous tokenOwner if owner is not contract
312         if (oldOwner != address(this)) {
313             oldOwner.transfer(payment); //(1-0.05)
314         }
315         
316         emit CovfefeSold(_tokenId, covfefes[_tokenId].term, covfefes[_tokenId].meaning, covfefes[_tokenId].generation, covfefeIndexToLastPrice[_tokenId], covfefeIndexToPrice[_tokenId], newOwner, oldOwner);
317         msg.sender.transfer(purchaseExcess);
318     }
319 
320     function priceOf(uint _tokenId) public view returns(uint price) {
321         return covfefeIndexToPrice[_tokenId];
322     }
323 
324     function lastPriceOf(uint _tokenId) public view returns(uint price) {
325         return covfefeIndexToLastPrice[_tokenId];
326     }
327     
328     /// @dev Assigns a new address to act as the Covman. Only available to the current Covman
329     /// @param _newCovman The address of the new Covman
330     function setCovman(address _newCovman) public onlyCovman {
331         require(_newCovman != address(0));
332         covmanAddress = _newCovman;
333     }
334     
335     /// @dev Assigns a new address to act as the Covmanager. Only available to the current Covman
336     /// @param _newCovmanager The address of the new Covmanager
337     function setCovmanager(address _newCovmanager) public onlyCovman {
338         require(_newCovmanager != address(0));
339         covmanagerAddress = _newCovmanager;
340     }
341     
342     /// @dev Required for ERC-721 compliance.
343     function symbol() public pure returns(string) {
344         return SYMBOL;
345     }
346     
347     /// @notice Allow pre-approved user to take ownership of a token
348     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
349     /// @dev Required for ERC-721 compliance.
350     function takeOwnership(uint _tokenId) public {
351         address newOwner = msg.sender;
352         address oldOwner = covfefeIndexToOwner[_tokenId];
353         // Safety check to prevent against an unexpected 0x0 default.
354         require(_addressNotNull(newOwner));
355         // Making sure transfer is approved
356         require(_approved(newOwner, _tokenId));
357         _transfer(oldOwner, newOwner, _tokenId);
358     }
359     
360     ///////////////////Add Value to Covfefe/////////////////////////////
361     //////////////There's no fee for adding value//////////////////////
362 
363     function addValueToCovfefe(uint _tokenId) external payable onlyOwnerOf(_tokenId) {
364         
365         // Making sure the transaction is not from another smart contract
366         require(!isContract(msg.sender));
367         
368         //Making sure amount is within the min and max range
369         require(msg.value >= 0.001 ether);
370         require(msg.value <= 9999.000 ether);
371         
372         //Keeping a record of lastprice before updating price
373         covfefeIndexToLastPrice[_tokenId] = covfefeIndexToPrice[_tokenId];
374         
375         uint newValue = msg.value;
376 
377         // Update prices
378         newValue = SafeMath.div(SafeMath.mul(newValue, 115), 100);
379         covfefeIndexToPrice[_tokenId] = SafeMath.add(newValue, covfefeIndexToPrice[_tokenId]);
380         
381         ///Emit the AddValueToCovfefe event
382         emit AddedValueToCovfefe(_tokenId, covfefes[_tokenId].term, covfefes[_tokenId].meaning, covfefes[_tokenId].generation, covfefeIndexToPrice[_tokenId]);
383     }
384     
385     /// @param _owner The owner whose covfefe tokens we are interested in.
386     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
387     ///  expensive (it walks the entire Covfefes array looking for covfefes belonging to owner),
388     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
389     ///  not contract-to-contract calls.
390     
391     function getTokensOfOwner(address _owner) external view returns(uint[] ownerTokens) {
392         uint tokenCount = balanceOf(_owner);
393         if (tokenCount == 0) {
394             // Return an empty array
395             return new uint[](0);
396         } else {
397             uint[] memory result = new uint[](tokenCount);
398             uint totalCovfefes = totalSupply();
399             uint resultIndex = 0;
400             uint covfefeId;
401             for (covfefeId = 0; covfefeId <= totalCovfefes; covfefeId++) {
402                 if (covfefeIndexToOwner[covfefeId] == _owner) {
403                     result[resultIndex] = covfefeId;
404                     resultIndex++;
405                 }
406             }
407             return result;
408         }
409     }
410     
411     /// For querying totalSupply of token
412     /// @dev Required for ERC-721 compliance.
413     function totalSupply() public view returns(uint total) {
414         return covfefes.length;
415     }
416     /// Owner initates the transfer of the token to another account
417     /// @param _to The address for the token to be transferred to.
418     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
419     /// @dev Required for ERC-721 compliance.
420     function transfer(address _to, uint _tokenId) public {
421         require(_owns(msg.sender, _tokenId));
422         require(_addressNotNull(_to));
423         _transfer(msg.sender, _to, _tokenId);
424     }
425     /// Third-party initiates transfer of token from address _from to address _to
426     /// @param _from The address for the token to be transferred from.
427     /// @param _to The address for the token to be transferred to.
428     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
429     /// @dev Required for ERC-721 compliance.
430     function transferFrom(address _from, address _to, uint _tokenId) public {
431         require(_owns(_from, _tokenId));
432         require(_approved(_to, _tokenId));
433         require(_addressNotNull(_to));
434         _transfer(_from, _to, _tokenId);
435     }
436     /*** PRIVATE FUNCTIONS ***/
437     /// Safety check on _to address to prevent against an unexpected 0x0 default.
438     function _addressNotNull(address _to) private pure returns(bool) {
439         return _to != address(0);
440     }
441     /// For checking approval of transfer for address _to
442     function _approved(address _to, uint _tokenId) private view returns(bool) {
443         return covfefeIndexToApproved[_tokenId] == _to;
444     }
445     
446     /////////////Covfefe Creation////////////
447     
448     function _createCovfefe(string _term, string _meaning, uint16 _generation, address _owner, uint _price) private {
449         Covfefe memory _covfefe = Covfefe({
450             term: _term,
451             meaning: _meaning,
452             generation: _generation,
453             saleReadyTime: uint64(now),
454             winCount: 0,
455             lossCount: 0
456         });
457         
458         uint newCovfefeId = covfefes.push(_covfefe) - 1;
459         // It's probably never going to happen, 4 billion tokens are A LOT, but
460         // let's just be 100% sure we never let this happen.
461         require(newCovfefeId == uint(uint32(newCovfefeId)));
462         
463         //Emit the Covfefe creation event
464         emit NewCovfefeCreated(newCovfefeId, _term, _meaning, _generation, _owner);
465         
466         covfefeIndexToPrice[newCovfefeId] = _price;
467         
468         // This will assign ownership, and also emit the Transfer event as
469         // per ERC721 draft
470         _transfer(address(0), _owner, newCovfefeId);
471     }
472     
473     /// Check for token ownership
474     function _owns(address claimant, uint _tokenId) private view returns(bool) {
475         return claimant == covfefeIndexToOwner[_tokenId];
476     }
477     
478     /// For paying out balance on contract
479     function _payout(address _to) private {
480         if (_to == address(0)) {
481             covmanAddress.transfer(address(this).balance);
482         } else {
483             _to.transfer(address(this).balance);
484         }
485     }
486     
487     /////////////////////Transfer//////////////////////
488     /// @dev Transfer event as defined in current draft of ERC721. 
489     ///  ownership is assigned, including births.
490     
491     /// @dev Assigns ownership of a specific Covfefe to an address.
492     function _transfer(address _from, address _to, uint _tokenId) private {
493         // Since the number of covfefes is capped to 2^32 we can't overflow this
494         ownershipTokenCount[_to]++;
495         //transfer ownership
496         covfefeIndexToOwner[_tokenId] = _to;
497         // When creating new covfefes _from is 0x0, but we can't account that address.
498         if (_from != address(0)) {
499             ownershipTokenCount[_from]--;
500             // clear any previously approved ownership exchange
501             delete covfefeIndexToApproved[_tokenId];
502         }
503         // Emit the transfer event.
504         emit CovfefeTransferred(_tokenId, _from, _to);
505     }
506     
507     ///////////////////Covfefe Duel System//////////////////////
508     
509     //Simple Randomizer for the covfefe duelling system
510     function randMod(uint _modulus) internal returns(uint) {
511         randNonce++;
512         return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
513     }
514     
515     function duelAnotherCovfefe(uint _tokenId, uint _targetId) external payable onlyOwnerOf(_tokenId) {
516         //Load the covfefes from storage
517         Covfefe storage myCovfefe = covfefes[_tokenId];
518         
519         // Making sure the transaction is not from another smart contract
520         require(!isContract(msg.sender));
521         
522         //Making sure the duelling fee is included
523         require(msg.value == duelFee);
524         
525         //
526         Covfefe storage enemyCovfefe = covfefes[_targetId];
527         uint rand = randMod(100);
528         
529         if (rand <= duelVictoryProbability) {
530             myCovfefe.winCount++;
531             enemyCovfefe.lossCount++;
532         
533         ///Emit the ChallengerWins event
534             emit ChallengerWinsCovfefeDuel(_tokenId, covfefes[_tokenId].term, _targetId, covfefes[_targetId].term);
535             
536         } else {
537         
538             myCovfefe.lossCount++;
539             enemyCovfefe.winCount++;
540         
541             ///Emit the DefenderWins event
542             emit DefenderWinsCovfefeDuel(_targetId, covfefes[_targetId].term, _tokenId, covfefes[_tokenId].term);
543         }
544     }
545     
546     ////////////////// Utility //////////////////
547     
548     function isContract(address addr) internal view returns(bool) {
549         uint size;
550         assembly {
551             size: = extcodesize(addr)
552         }
553         return size > 0;
554     }
555 }