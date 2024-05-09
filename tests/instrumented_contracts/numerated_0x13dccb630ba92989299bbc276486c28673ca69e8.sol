1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint a, uint b) internal pure returns (uint) {
12         if (a == 0) {
13         return 0;
14         }
15         uint c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint a, uint b) internal pure returns (uint) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     /**
31     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint a, uint b) internal pure returns (uint) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint a, uint b) internal pure returns (uint) {
42         uint c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54     address public owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60     * account.
61     */
62     function Ownable() public {
63         owner = msg.sender;
64     }
65 
66     /**
67     * @dev Throws if called by any account other than the owner.
68     */
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     /**
75     * @dev Allows the current owner to transfer control of the contract to a newOwner.
76     * @param newOwner The address to transfer ownership to.
77     */
78     function transferOwnership(address newOwner) public onlyOwner {
79         require(newOwner != address(0));
80         OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82     }
83 }
84 
85 /**
86  * @title Heritable
87  * @dev The Heritable contract provides ownership transfer capabilities, in the
88  * case that the current owner stops "heartbeating". Only the heir can pronounce the
89  * owner's death.
90  */
91 contract Heritable is Ownable {
92     address public heir;
93 
94     // Time window the owner has to notify they are alive.
95     uint public heartbeatTimeout;
96 
97     // Timestamp of the owner's death, as pronounced by the heir.
98     uint public timeOfDeath;
99 
100     event HeirChanged(address indexed owner, address indexed newHeir);
101     event OwnerHeartbeated(address indexed owner);
102     event OwnerProclaimedDead(address indexed owner, address indexed heir, uint timeOfDeath);
103     event HeirOwnershipClaimed(address indexed previousOwner, address indexed newOwner);
104 
105 
106     /**
107     * @dev Throw an exception if called by any account other than the heir's.
108     */
109     modifier onlyHeir() {
110         require(msg.sender == heir);
111         _;
112     }
113 
114 
115     /**
116     * @notice Create a new Heritable Contract with heir address 0x0.
117     * @param _heartbeatTimeout time available for the owner to notify they are alive,
118     * before the heir can take ownership.
119     */
120     function Heritable(uint _heartbeatTimeout) public {
121         setHeartbeatTimeout(_heartbeatTimeout);
122     }
123 
124     function setHeir(address newHeir) public onlyOwner {
125         require(newHeir != owner);
126         heartbeat();
127         HeirChanged(owner, newHeir);
128         heir = newHeir;
129     }
130 
131     /**
132     * @dev set heir = 0x0
133     */
134     function removeHeir() public onlyOwner {
135         heartbeat();
136         heir = 0;
137     }
138 
139     /**
140     * @dev Heir can pronounce the owners death. To claim the ownership, they will
141     * have to wait for `heartbeatTimeout` seconds.
142     */
143     function proclaimDeath() public onlyHeir {
144         require(owner != heir); // added
145         require(ownerLives());
146         OwnerProclaimedDead(owner, heir, timeOfDeath);
147         timeOfDeath = now;
148     }
149 
150     /**
151     * @dev Owner can send a heartbeat if they were mistakenly pronounced dead.
152     */
153     function heartbeat() public onlyOwner {
154         OwnerHeartbeated(owner);
155         timeOfDeath = 0;
156     }
157 
158     /**
159     * @dev Allows heir to transfer ownership only if heartbeat has timed out.
160     */
161     function claimHeirOwnership() public onlyHeir {
162         require(!ownerLives());
163         require(now >= timeOfDeath + heartbeatTimeout);
164         OwnershipTransferred(owner, heir);
165         HeirOwnershipClaimed(owner, heir);
166         owner = heir;
167         timeOfDeath = 0;
168     }
169 
170     function setHeartbeatTimeout(uint newHeartbeatTimeout) internal onlyOwner {
171         require(ownerLives());
172         heartbeatTimeout = newHeartbeatTimeout;
173     }
174 
175     function ownerLives() internal view returns (bool) {
176         return timeOfDeath == 0;
177     }
178 }
179 
180 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
181 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
182 contract ERC721 {
183     // Required methods
184     function approve(address _to, uint _tokenId) public;
185     function balanceOf(address _owner) public view returns (uint balance);
186     function implementsERC721() public pure returns (bool);
187     function ownerOf(uint _tokenId) public view returns (address addr);
188     function takeOwnership(uint _tokenId) public;
189     function totalSupply() public view returns (uint total);
190     function transferFrom(address _from, address _to, uint _tokenId) public;
191     function transfer(address _to, uint _tokenId) public;
192 
193     event Transfer(address indexed from, address indexed to, uint tokenId);
194     event Approval(address indexed owner, address indexed approved, uint tokenId);
195 
196     // Optional
197     // function name() public view returns (string name);
198     // function symbol() public view returns (string symbol);
199     // function tokenOfOwnerByIndex(address _owner, uint _index) external view returns (uint tokenId);
200     // function tokenMetadata(uint _tokenId) public view returns (string infoUrl);
201 }
202 
203 contract BitArtToken is Heritable, ERC721 {
204     string public constant NAME = "BitGallery";
205     string public constant SYMBOL = "BitArt";
206 
207     struct Art {
208         bytes32 data;
209     }
210 
211     Art[] internal arts;
212 
213     mapping (uint => address) public tokenOwner;
214     mapping (address => uint) public ownedTokenCount;
215     mapping (uint => address) public tokenApprovals;
216 
217     event Transfer(address from, address to, uint tokenId);
218     event Approval(address owner, address approved, uint tokenId);
219 
220     // 30 days to change owner
221     function BitArtToken() Heritable(2592000) public {}
222 
223     function tokensOf(address _owner) external view returns(uint[]) {
224         uint tokenCount = balanceOf(_owner);
225 
226         if (tokenCount == 0) {
227             return new uint[](0);
228         } else {
229             uint[] memory result = new uint[](tokenCount);
230             uint totaltokens = totalSupply();
231             uint index = 0;
232             
233             for (uint tokenId = 0; tokenId < totaltokens; tokenId++) {
234                 if (tokenOwner[tokenId] == _owner) {
235                     result[index] = tokenId;
236                     index++;
237                 }
238             }
239             
240             return result;
241         }
242     }
243 
244     function approve(address _to, uint _tokenId) public {
245         require(_owns(msg.sender, _tokenId));
246         tokenApprovals[_tokenId] = _to;
247         Approval(msg.sender, _to, _tokenId);
248     }
249 
250     function balanceOf(address _owner) public view returns (uint balance) {
251         return ownedTokenCount[_owner];
252     }
253 
254     function getArts() public view returns (bytes32[]) {
255         uint count = totalSupply();
256         bytes32[] memory result = new bytes32[](count);
257 
258         for (uint i = 0; i < count; i++) {
259             result[i] = arts[i].data;
260         }
261 
262         return result;
263     }
264 
265     function implementsERC721() public pure returns (bool) {
266         return true;
267     }
268 
269     function name() public pure returns (string) {
270         return NAME;
271     }
272 
273     function ownerOf(uint _tokenId) public view returns (address owner) {
274         owner = tokenOwner[_tokenId];
275         require(_addressNotNull(owner));
276     }
277 
278     function symbol() public pure returns (string) {
279         return SYMBOL;
280     }
281 
282     function takeOwnership(uint _tokenId) public {
283         address newOwner = msg.sender;
284         require(_addressNotNull(newOwner));
285         require(_approved(newOwner, _tokenId));
286         address oldOwner = tokenOwner[_tokenId];
287 
288         _transfer(oldOwner, newOwner, _tokenId);
289     }
290 
291     function totalSupply() public view returns (uint total) {
292         return arts.length;
293     }
294 
295     function transfer(address _to, uint _tokenId) public {
296         require(_owns(msg.sender, _tokenId));
297         require(_addressNotNull(_to));
298 
299         _transfer(msg.sender, _to, _tokenId);
300     }
301 
302     function transferFrom(address _from, address _to, uint _tokenId) public {
303         require(_owns(_from, _tokenId));
304         require(_approved(_to, _tokenId));
305         require(_addressNotNull(_to));
306 
307         _transfer(_from, _to, _tokenId);
308     }
309 
310     function _mint(address _to, uint256 _tokenId) internal {
311         require(_to != address(0));
312         require(tokenOwner[_tokenId] == address(0));
313 
314         _transfer(0x0, _to, _tokenId);
315     }
316 
317     function _transfer(address _from, address _to, uint _tokenId) internal {
318         require(_from != _to);
319         ownedTokenCount[_to]++;
320         tokenOwner[_tokenId] = _to;
321 
322         if (_addressNotNull(_from)) {
323             ownedTokenCount[_from]--;
324             delete tokenApprovals[_tokenId];
325         }
326 
327         Transfer(_from, _to, _tokenId);
328     }
329 
330     function _addressNotNull(address _address) private pure returns (bool) {
331         return _address != address(0);
332     }
333 
334     function _approved(address _to, uint _tokenId) private view returns (bool) {
335         return tokenApprovals[_tokenId] == _to;
336     }
337 
338     function _owns(address _claimant, uint _tokenId) private view returns (bool) {
339         return _claimant == tokenOwner[_tokenId];
340     }
341 }
342 
343 contract BitAuction is BitArtToken {
344     using SafeMath for uint;
345 
346     struct Auction {
347         uint basePrice;
348         uint64 time1;
349         uint64 time2;
350         uint8 pct1;
351         uint8 pct2;
352         uint8 discount;
353     }
354 
355     uint internal _auctionStartsAfter;
356     uint internal _auctionDuration;
357     uint internal _auctionFee;
358 
359     mapping (uint => Auction) public tokenAuction;
360 
361     event AuctionRulesChanged(uint startsAfter, uint duration, uint fee);
362     event NewAuction(uint tokenId, uint discount);
363     event NewSaleDiscount(uint tokenId, uint discount);
364 
365     function BitAuction() public { }
366 
367     function setSaleDiscount(uint _tokenId, uint _discount) external {      
368         require(ownerOf(_tokenId) == msg.sender);
369         require(_discount <= 90);
370         require(_discount >= 10);
371 
372         Auction storage auction = tokenAuction[_tokenId];
373         require(auction.basePrice > 0);        
374         require(auction.time2 <= now);
375         auction.discount = uint8(_discount);
376 
377         NewSaleDiscount(_tokenId, _discount);
378     }
379 
380     function canPurchase(uint _tokenId) public view returns (bool) {
381         Auction storage auction = tokenAuction[_tokenId];
382         require(auction.time1 > 0);
383         return (now >= auction.time1 && priceOf(_tokenId) > 0);
384     }
385 
386     function getPrices(uint[] _ids) public view returns (uint[]) {
387         uint count = _ids.length;
388         bool isEmpty = count == 0;
389 
390         if (isEmpty) {
391             count = totalSupply();
392         }
393 
394         uint[] memory result = new uint[](count);
395         
396         for (uint i = 0; i < count; i++) {
397             uint tokenId = isEmpty ? i : _ids[i];
398             result[i] = priceOf(tokenId);
399         }        
400         
401         return result;
402     }
403 
404     function priceOf(uint _tokenId) public view returns (uint) {
405         Auction storage auction = tokenAuction[_tokenId];
406         return _currentPrice(auction);
407     }
408 
409     function setAuctionDurationRules(uint _timeAfter, uint _duration, uint _fee) public onlyOwner {  
410         require(_timeAfter >= 0 seconds);
411         require(_timeAfter <= 7 days);
412         require(_duration >= 24 hours);
413         require(_duration <= 30 days);
414         require(_fee >= 1);
415         require(_fee <= 5);
416         
417         _auctionStartsAfter = _timeAfter;
418         _auctionDuration = _duration;
419         _auctionFee = _fee;
420 
421         AuctionRulesChanged(_timeAfter, _duration, _fee);
422     }
423 
424     function _createCustomAuction(uint _tokenId, uint _basePrice, uint _time1, uint _time2, uint _pct1, uint _pct2) private {
425         require(_time1 >= now);
426         require(_time2 >= _time1);
427         require(_pct1 > 0);
428         require(_pct2 > 0);
429         
430         Auction memory auction = Auction({
431             basePrice: _basePrice, 
432             time1: uint64(_time1), 
433             time2: uint64(_time2), 
434             pct1: uint8(_pct1), 
435             pct2: uint8(_pct2), 
436             discount: 0           
437         });
438 
439         tokenAuction[_tokenId] = auction;
440     }
441 
442     function _createNewTokenAuction(uint _tokenId, uint _basePrice) internal {
443         _createCustomAuction(_tokenId, _basePrice, now, now + _auctionStartsAfter + _auctionDuration, 100, 10);
444     }
445 
446     function _createStandartAuction(uint _tokenId, uint _basePrice) internal {
447         uint start = now + _auctionStartsAfter;
448         _createCustomAuction(_tokenId, _basePrice, start, start + _auctionDuration, 200, 110);
449     }
450 
451     function _currentPrice(Auction _auction) internal view returns (uint) {
452         if (_auction.discount > 0) {
453             return uint((_auction.basePrice * (100 - _auction.discount)) / 100);
454         }
455 
456         uint _startingPrice = uint((_auction.basePrice * _auction.pct1) / 100);
457 
458         if (_auction.time1 > now) {
459             return _startingPrice;
460         }
461 
462         uint _secondsPassed = uint(now - _auction.time1);
463         uint _duration = uint(_auction.time2 - _auction.time1);
464         uint _endingPrice = uint((_auction.basePrice * _auction.pct2) / 100);
465 
466         if (_secondsPassed >= _duration) {
467             return _endingPrice;
468         } else {
469             int totalPriceChange = int(_endingPrice) - int(_startingPrice);
470             int currentPriceChange = totalPriceChange * int(_secondsPassed) / int(_duration);
471             int currentPrice = int(_startingPrice) + currentPriceChange;
472 
473             return uint(currentPrice);
474         }
475     }
476 
477     function _computePrice(uint _secondsPassed, uint _duration, uint _startingPrice, uint _endingPrice) private pure returns (uint) {
478         if (_secondsPassed >= _duration) {
479             return _endingPrice;
480         } else {
481             int totalPriceChange = int(_endingPrice) - int(_startingPrice);
482             int currentPriceChange = totalPriceChange * int(_secondsPassed) / int(_duration);
483             int currentPrice = int(_startingPrice) + currentPriceChange;
484 
485             return uint(currentPrice);
486         }
487     }
488 }
489 
490 contract BitGallery is BitAuction {
491     using SafeMath for uint;
492 
493     string public infoMessage;
494 
495     event TokenSold(uint tokenId, uint price, address from, address to);
496     event NewToken(uint tokenId, string metadata);
497 
498     function BitGallery() public {
499         setAuctionDurationRules(24 hours, 6 days, 3);
500 
501         setMessage("Our web site is www.bitgallery.co");                          
502     }
503 
504     function() public payable {}
505 
506     function addArt(string _keyData, uint _basePrice) public onlyOwner {
507         return addArtTo(address(this), _keyData, _basePrice);
508     }
509 
510     function addArtTo(address _owner, string _keyData, uint _basePrice) public onlyOwner {
511         require(_basePrice >= 1 finney);
512         
513         Art memory _art = Art({
514             data: keccak256(_keyData)
515         });
516 
517         uint tokenId = arts.push(_art) - 1;
518         NewToken(tokenId, _keyData);
519         _mint(_owner, tokenId);
520         _createNewTokenAuction(tokenId, _basePrice);
521     }
522 
523     function artExists(string _keydata) public view returns (bool) {
524         for (uint i = 0; i < totalSupply(); i++) {
525             if (arts[i].data == keccak256(_keydata)) {
526                 return true;
527             }
528         }
529 
530         return false;
531     }
532 
533     function fullDataOf(uint _tokenId) public view returns (
534         uint basePrice,
535         uint64 time1,
536         uint64 time2,
537         uint8 pct1,
538         uint8 pct2,
539         uint8 discount,
540         uint currentPrice,
541         bool _canPurchase,
542         address owner
543     ) {
544         Auction storage auction = tokenAuction[_tokenId];
545         basePrice = auction.basePrice;
546         time1 = auction.time1;
547         time2 = auction.time2;
548         pct1 = auction.pct1;
549         pct2 = auction.pct2;
550         discount = auction.discount;
551         currentPrice = priceOf(_tokenId);
552         _canPurchase = canPurchase(_tokenId);
553         owner = ownerOf(_tokenId);
554     }
555 
556     function payout(address _to) public onlyOwner {
557         require(_to != address(this));
558         
559         if (_to == address(0)) { 
560             _to = msg.sender;
561         }
562 
563         _to.transfer(this.balance);
564     }
565 
566     function purchase(uint _tokenId) public payable {
567         Auction storage auction = tokenAuction[_tokenId];
568         require(now >= auction.time1);
569         uint price = _currentPrice(auction);
570         require(msg.value >= price);
571 
572         uint payment = uint((price * (100 - _auctionFee)) / 100);
573         uint purchaseExcess = msg.value - price;
574         _createStandartAuction(_tokenId, price);
575 
576         address from = ownerOf(_tokenId);
577         address to = msg.sender;
578         _transfer(from, to, _tokenId);
579 
580         if (from != address(this)) {
581             from.transfer(payment);
582         }
583 
584         TokenSold(_tokenId, price, from, to);
585         msg.sender.transfer(purchaseExcess);
586     }
587 
588     function setMessage(string _message) public onlyOwner {        
589         infoMessage = _message;
590     }
591 }