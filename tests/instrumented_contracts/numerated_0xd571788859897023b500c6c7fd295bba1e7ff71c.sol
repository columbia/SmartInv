1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8     // Required methods
9     function approve(address _to, uint256 _tokenId) public;
10     function balanceOf(address _owner) public view returns (uint256 balance);
11     function implementsERC721() public pure returns (bool);
12     function ownerOf(uint256 _tokenId) public view returns (address addr);
13     function takeOwnership(uint256 _tokenId) public;
14     function totalSupply() public view returns (uint256 total);
15     function transferFrom(address _from, address _to, uint256 _tokenId) public;
16     function transfer(address _to, uint256 _tokenId) public;
17 
18     event Transfer(address indexed from, address indexed to, uint256 tokenId);
19     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
20 
21     // Optional
22     // function name() public view returns (string name);
23     // function symbol() public view returns (string symbol);
24     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
25     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
26 }
27 
28 
29 contract SportStarToken is ERC721 {
30 
31     // ***** EVENTS
32 
33     // @dev Transfer event as defined in current draft of ERC721.
34     //  ownership is assigned, including births.
35     event Transfer(address from, address to, uint256 tokenId);
36 
37 
38 
39     // ***** STORAGE
40 
41     // @dev A mapping from token IDs to the address that owns them. All tokens have
42     //  some valid owner address.
43     mapping (uint256 => address) public tokenIndexToOwner;
44 
45     // @dev A mapping from owner address to count of tokens that address owns.
46     //  Used internally inside balanceOf() to resolve ownership count.
47     mapping (address => uint256) private ownershipTokenCount;
48 
49     // @dev A mapping from TokenIDs to an address that has been approved to call
50     //  transferFrom(). Each Token can only have one approved address for transfer
51     //  at any time. A zero value means no approval is outstanding.
52     mapping (uint256 => address) public tokenIndexToApproved;
53 
54     // Additional token data
55     mapping (uint256 => bytes32) public tokenIndexToData;
56 
57     address public ceoAddress;
58     address public masterContractAddress;
59 
60     uint256 public promoCreatedCount;
61 
62 
63 
64     // ***** DATATYPES
65 
66     struct Token {
67         string name;
68     }
69 
70     Token[] private tokens;
71 
72 
73 
74     // ***** ACCESS MODIFIERS
75 
76     modifier onlyCEO() {
77         require(msg.sender == ceoAddress);
78         _;
79     }
80 
81     modifier onlyMasterContract() {
82         require(msg.sender == masterContractAddress);
83         _;
84     }
85 
86 
87 
88     // ***** CONSTRUCTOR
89 
90     function SportStarToken() public {
91         ceoAddress = msg.sender;
92     }
93 
94 
95 
96     // ***** PRIVILEGES SETTING FUNCTIONS
97 
98     function setCEO(address _newCEO) public onlyCEO {
99         require(_newCEO != address(0));
100 
101         ceoAddress = _newCEO;
102     }
103 
104     function setMasterContract(address _newMasterContract) public onlyCEO {
105         require(_newMasterContract != address(0));
106 
107         masterContractAddress = _newMasterContract;
108     }
109 
110 
111 
112     // ***** PUBLIC FUNCTIONS
113 
114     // @notice Returns all the relevant information about a specific token.
115     // @param _tokenId The tokenId of the token of interest.
116     function getToken(uint256 _tokenId) public view returns (
117         string tokenName,
118         address owner
119     ) {
120         Token storage token = tokens[_tokenId];
121         tokenName = token.name;
122         owner = tokenIndexToOwner[_tokenId];
123     }
124 
125     // @param _owner The owner whose sport star tokens we are interested in.
126     // @dev This method MUST NEVER be called by smart contract code. First, it's fairly
127     //  expensive (it walks the entire Tokens array looking for tokens belonging to owner),
128     //  but it also returns a dynamic array, which is only supported for web3 calls, and
129     //  not contract-to-contract calls.
130     function tokensOfOwner(address _owner) public view returns (uint256[] ownerTokens) {
131         uint256 tokenCount = balanceOf(_owner);
132         if (tokenCount == 0) {
133             // Return an empty array
134             return new uint256[](0);
135         } else {
136             uint256[] memory result = new uint256[](tokenCount);
137             uint256 totalTokens = totalSupply();
138             uint256 resultIndex = 0;
139 
140             uint256 tokenId;
141             for (tokenId = 0; tokenId <= totalTokens; tokenId++) {
142                 if (tokenIndexToOwner[tokenId] == _owner) {
143                     result[resultIndex] = tokenId;
144                     resultIndex++;
145                 }
146             }
147             return result;
148         }
149     }
150 
151     function getTokenData(uint256 _tokenId) public view returns (bytes32 tokenData) {
152         return tokenIndexToData[_tokenId];
153     }
154 
155 
156 
157     // ***** ERC-721 FUNCTIONS
158 
159     // @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
160     // @param _to The address to be granted transfer approval. Pass address(0) to
161     //  clear all approvals.
162     // @param _tokenId The ID of the Token that can be transferred if this call succeeds.
163     function approve(address _to, uint256 _tokenId) public {
164         // Caller must own token.
165         require(_owns(msg.sender, _tokenId));
166 
167         tokenIndexToApproved[_tokenId] = _to;
168 
169         Approval(msg.sender, _to, _tokenId);
170     }
171 
172     // For querying balance of a particular account
173     // @param _owner The address for balance query
174     function balanceOf(address _owner) public view returns (uint256 balance) {
175         return ownershipTokenCount[_owner];
176     }
177 
178     function name() public pure returns (string) {
179         return "CryptoSportStars";
180     }
181 
182     function symbol() public pure returns (string) {
183         return "SportStarToken";
184     }
185 
186     function implementsERC721() public pure returns (bool) {
187         return true;
188     }
189 
190     // For querying owner of token
191     // @param _tokenId The tokenID for owner inquiry
192     function ownerOf(uint256 _tokenId) public view returns (address owner)
193     {
194         owner = tokenIndexToOwner[_tokenId];
195         require(owner != address(0));
196     }
197 
198     // @notice Allow pre-approved user to take ownership of a token
199     // @param _tokenId The ID of the Token that can be transferred if this call succeeds.
200     function takeOwnership(uint256 _tokenId) public {
201         address newOwner = msg.sender;
202         address oldOwner = tokenIndexToOwner[_tokenId];
203 
204         // Safety check to prevent against an unexpected 0x0 default.
205         require(_addressNotNull(newOwner));
206 
207         // Making sure transfer is approved
208         require(_approved(newOwner, _tokenId));
209 
210         _transfer(oldOwner, newOwner, _tokenId);
211     }
212 
213     // For querying totalSupply of token
214     function totalSupply() public view returns (uint256 total) {
215         return tokens.length;
216     }
217 
218     // Owner initates the transfer of the token to another account
219     // @param _to The address for the token to be transferred to.
220     // @param _tokenId The ID of the Token that can be transferred if this call succeeds.
221     function transfer(address _to, uint256 _tokenId) public {
222         require(_owns(msg.sender, _tokenId));
223         require(_addressNotNull(_to));
224 
225         _transfer(msg.sender, _to, _tokenId);
226     }
227 
228     // Third-party initiates transfer of token from address _from to address _to
229     // @param _from The address for the token to be transferred from.
230     // @param _to The address for the token to be transferred to.
231     // @param _tokenId The ID of the Token that can be transferred if this call succeeds.
232     function transferFrom(address _from, address _to, uint256 _tokenId) public {
233         require(_owns(_from, _tokenId));
234         require(_approved(_to, _tokenId));
235         require(_addressNotNull(_to));
236 
237         _transfer(_from, _to, _tokenId);
238     }
239 
240 
241 
242     // ONLY MASTER CONTRACT FUNCTIONS
243 
244     function createToken(string _name, address _owner) public onlyMasterContract returns (uint256 _tokenId) {
245         return _createToken(_name, _owner);
246     }
247 
248     function updateOwner(address _from, address _to, uint256 _tokenId) public onlyMasterContract {
249         _transfer(_from, _to, _tokenId);
250     }
251 
252     function setTokenData(uint256 _tokenId, bytes32 tokenData) public onlyMasterContract {
253         tokenIndexToData[_tokenId] = tokenData;
254     }
255 
256 
257 
258     // PRIVATE FUNCTIONS
259 
260     // Safety check on _to address to prevent against an unexpected 0x0 default.
261     function _addressNotNull(address _to) private pure returns (bool) {
262         return _to != address(0);
263     }
264 
265     // For checking approval of transfer for address _to
266     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
267         return tokenIndexToApproved[_tokenId] == _to;
268     }
269 
270     // For creating Token
271     function _createToken(string _name, address _owner) private returns (uint256 _tokenId) {
272         Token memory _token = Token({
273             name: _name
274             });
275         uint256 newTokenId = tokens.push(_token) - 1;
276 
277         // It's probably never going to happen, 4 billion tokens are A LOT, but
278         // let's just be 100% sure we never let this happen.
279         require(newTokenId == uint256(uint32(newTokenId)));
280 
281         // This will assign ownership, and also emit the Transfer event as
282         // per ERC721 draft
283         _transfer(address(0), _owner, newTokenId);
284 
285         return newTokenId;
286     }
287 
288     // Check for token ownership
289     function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
290         return claimant == tokenIndexToOwner[_tokenId];
291     }
292 
293     // @dev Assigns ownership of a specific Token to an address.
294     function _transfer(address _from, address _to, uint256 _tokenId) private {
295         // Since the number of tokens is capped to 2^32 we can't overflow this
296         ownershipTokenCount[_to]++;
297         //transfer ownership
298         tokenIndexToOwner[_tokenId] = _to;
299 
300         // When creating new tokens _from is 0x0, but we can't account that address.
301         if (_from != address(0)) {
302             ownershipTokenCount[_from]--;
303             // clear any previously approved ownership exchange
304             delete tokenIndexToApproved[_tokenId];
305         }
306 
307         // Emit the transfer event.
308         Transfer(_from, _to, _tokenId);
309     }
310 }
311 
312 
313 
314 contract SportStarMaster {
315 
316     // ***** EVENTS ***/
317 
318     // @dev The Birth event is fired whenever a new token comes into existence.
319     event Birth(uint256 tokenId, string name, address owner);
320 
321     // @dev The TokenSold event is fired whenever a token is sold.
322     event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner);
323 
324     // @dev Transfer event as defined in current draft of ERC721.
325     //  ownership is assigned, including births.
326     event Transfer(address from, address to, uint256 tokenId);
327 
328 
329 
330     // ***** CONSTANTS ***/
331 
332     uint256 private startingPrice = 0.001 ether;
333     uint256 private firstStepLimit = 0.053613 ether;
334     uint256 private secondStepLimit = 0.564957 ether;
335 
336 
337 
338     // ***** STORAGE ***/
339 
340     // @dev A mapping from TokenIDs to the price of the token.
341     mapping(uint256 => uint256) private tokenIndexToPrice;
342 
343     // The addresses of the accounts (or contracts) that can execute actions within each roles.
344     address public ceoAddress;
345     address public cooAddress;
346 
347     // The address of tokens contract
348     SportStarToken public tokensContract;
349 
350     uint256 public promoCreatedCount;
351 
352 
353     uint256 private increaseLimit1 = 0.05 ether;
354     uint256 private increaseLimit2 = 0.5 ether;
355     uint256 private increaseLimit3 = 2.0 ether;
356     uint256 private increaseLimit4 = 5.0 ether;
357 
358 
359 
360     // ***** ACCESS MODIFIERS ***/
361 
362     // @dev Access modifier for CEO-only functionality
363     modifier onlyCEO() {
364         require(msg.sender == ceoAddress);
365         _;
366     }
367 
368     // @dev Access modifier for COO-only functionality
369     modifier onlyCOO() {
370         require(msg.sender == cooAddress);
371         _;
372     }
373 
374     // Access modifier for contract owner only functionality
375     modifier onlyCLevel() {
376         require(
377             msg.sender == ceoAddress ||
378             msg.sender == cooAddress
379         );
380         _;
381     }
382 
383 
384 
385     // ***** CONSTRUCTOR ***/
386 
387     function SportStarMaster() public {
388         ceoAddress = msg.sender;
389         cooAddress = msg.sender;
390 
391         //Old prices
392         tokenIndexToPrice[0]=198056585936481135;
393         tokenIndexToPrice[1]=198056585936481135;
394         tokenIndexToPrice[2]=198056585936481135;
395         tokenIndexToPrice[3]=76833314470700771;
396         tokenIndexToPrice[4]=76833314470700771;
397         tokenIndexToPrice[5]=76833314470700771;
398         tokenIndexToPrice[6]=76833314470700771;
399         tokenIndexToPrice[7]=76833314470700771;
400         tokenIndexToPrice[8]=76833314470700771;
401         tokenIndexToPrice[9]=76833314470700771;
402         tokenIndexToPrice[10]=76833314470700771;
403         tokenIndexToPrice[11]=76833314470700771;
404         tokenIndexToPrice[12]=76833314470700771;
405         tokenIndexToPrice[13]=76833314470700771;
406         tokenIndexToPrice[14]=37264157518289874;
407         tokenIndexToPrice[15]=76833314470700771;
408         tokenIndexToPrice[16]=144447284479990001;
409         tokenIndexToPrice[17]=144447284479990001;
410         tokenIndexToPrice[18]=37264157518289874;
411         tokenIndexToPrice[19]=76833314470700771;
412         tokenIndexToPrice[20]=37264157518289874;
413         tokenIndexToPrice[21]=76833314470700771;
414         tokenIndexToPrice[22]=105348771387661881;
415         tokenIndexToPrice[23]=144447284479990001;
416         tokenIndexToPrice[24]=105348771387661881;
417         tokenIndexToPrice[25]=37264157518289874;
418         tokenIndexToPrice[26]=37264157518289874;
419         tokenIndexToPrice[27]=37264157518289874;
420         tokenIndexToPrice[28]=76833314470700771;
421         tokenIndexToPrice[29]=105348771387661881;
422         tokenIndexToPrice[30]=76833314470700771;
423         tokenIndexToPrice[31]=37264157518289874;
424         tokenIndexToPrice[32]=76833314470700771;
425         tokenIndexToPrice[33]=37264157518289874;
426         tokenIndexToPrice[34]=76833314470700771;
427         tokenIndexToPrice[35]=37264157518289874;
428         tokenIndexToPrice[36]=37264157518289874;
429         tokenIndexToPrice[37]=76833314470700771;
430         tokenIndexToPrice[38]=76833314470700771;
431         tokenIndexToPrice[39]=37264157518289874;
432         tokenIndexToPrice[40]=37264157518289874;
433         tokenIndexToPrice[41]=37264157518289874;
434         tokenIndexToPrice[42]=76833314470700771;
435         tokenIndexToPrice[43]=37264157518289874;
436         tokenIndexToPrice[44]=37264157518289874;
437         tokenIndexToPrice[45]=76833314470700771;
438         tokenIndexToPrice[46]=37264157518289874;
439         tokenIndexToPrice[47]=37264157518289874;
440         tokenIndexToPrice[48]=76833314470700771;
441     }
442 
443 
444     function setTokensContract(address _newTokensContract) public onlyCEO {
445         require(_newTokensContract != address(0));
446 
447         tokensContract = SportStarToken(_newTokensContract);
448     }
449 
450 
451 
452     // ***** PRIVILEGES SETTING FUNCTIONS
453 
454     function setCEO(address _newCEO) public onlyCEO {
455         require(_newCEO != address(0));
456 
457         ceoAddress = _newCEO;
458     }
459 
460     function setCOO(address _newCOO) public onlyCEO {
461         require(_newCOO != address(0));
462 
463         cooAddress = _newCOO;
464     }
465 
466 
467 
468     // ***** PUBLIC FUNCTIONS ***/
469     function getTokenInfo(uint256 _tokenId) public view returns (
470         address owner,
471         uint256 price,
472         bytes32 tokenData
473     ) {
474         owner = tokensContract.ownerOf(_tokenId);
475         price = tokenIndexToPrice[_tokenId];
476         tokenData = tokensContract.getTokenData(_tokenId);
477     }
478 
479     // @dev Creates a new promo Token with the given name, with given _price and assignes it to an address.
480     function createPromoToken(address _owner, string _name, uint256 _price) public onlyCOO {
481         address tokenOwner = _owner;
482         if (tokenOwner == address(0)) {
483             tokenOwner = cooAddress;
484         }
485 
486         if (_price <= 0) {
487             _price = startingPrice;
488         }
489 
490         promoCreatedCount++;
491         uint256 newTokenId = tokensContract.createToken(_name, tokenOwner);
492         tokenIndexToPrice[newTokenId] = _price;
493 
494         Birth(newTokenId, _name, _owner);
495     }
496 
497     // @dev Creates a new Token with the given name.
498     function createContractToken(string _name) public onlyCOO {
499         uint256 newTokenId = tokensContract.createToken(_name, address(this));
500         tokenIndexToPrice[newTokenId] = startingPrice;
501 
502         Birth(newTokenId, _name, address(this));
503     }
504 
505     function createContractTokenWithPrice(string _name, uint256 _price) public onlyCOO {
506         uint256 newTokenId = tokensContract.createToken(_name, address(this));
507         tokenIndexToPrice[newTokenId] = _price;
508 
509         Birth(newTokenId, _name, address(this));
510     }
511 
512     function setGamblingFee(uint256 _tokenId, uint256 _fee) public {
513         require(msg.sender == tokensContract.ownerOf(_tokenId));
514         require(_fee >= 0 && _fee <= 100);
515 
516         bytes32 tokenData = byte(_fee);
517         tokensContract.setTokenData(_tokenId, tokenData);
518     }
519 
520     // Allows someone to send ether and obtain the token
521     function purchase(uint256 _tokenId) public payable {
522         address oldOwner = tokensContract.ownerOf(_tokenId);
523         address newOwner = msg.sender;
524 
525         uint256 sellingPrice = tokenIndexToPrice[_tokenId];
526 
527         // Making sure token owner is not sending to self
528         require(oldOwner != newOwner);
529 
530         // Safety check to prevent against an unexpected 0x0 default.
531         require(_addressNotNull(newOwner));
532 
533         // Making sure sent amount is greater than or equal to the sellingPrice
534         require(msg.value >= sellingPrice);
535 
536         uint256 devCut = calculateDevCut(sellingPrice);
537         uint256 payment = SafeMath.sub(sellingPrice, devCut);
538         uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
539 
540         tokenIndexToPrice[_tokenId] = calculateNextPrice(sellingPrice);
541 
542         tokensContract.updateOwner(oldOwner, newOwner, _tokenId);
543 
544         // Pay previous tokenOwner if owner is not contract
545         if (oldOwner != address(this)) {
546             oldOwner.transfer(payment);
547         }
548 
549         TokenSold(_tokenId, sellingPrice, tokenIndexToPrice[_tokenId], oldOwner, newOwner);
550 
551         msg.sender.transfer(purchaseExcess);
552     }
553 
554     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
555         return tokenIndexToPrice[_tokenId];
556     }
557 
558     function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
559         if (_price < increaseLimit1) {
560             return SafeMath.div(SafeMath.mul(_price, 3), 100); // 3%
561         } else if (_price < increaseLimit2) {
562             return SafeMath.div(SafeMath.mul(_price, 3), 100); // 3%
563         } else if (_price < increaseLimit3) {
564             return SafeMath.div(SafeMath.mul(_price, 3), 100); // 3%
565         } else if (_price < increaseLimit4) {
566             return SafeMath.div(SafeMath.mul(_price, 3), 100); // 3%
567         } else {
568             return SafeMath.div(SafeMath.mul(_price, 2), 100); // 2%
569         }
570     }
571 
572     function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
573         if (_price < increaseLimit1) {
574             return SafeMath.div(SafeMath.mul(_price, 200), 97);
575         } else if (_price < increaseLimit2) {
576             return SafeMath.div(SafeMath.mul(_price, 133), 97);
577         } else if (_price < increaseLimit3) {
578             return SafeMath.div(SafeMath.mul(_price, 125), 97);
579         } else if (_price < increaseLimit4) {
580             return SafeMath.div(SafeMath.mul(_price, 115), 97);
581         } else {
582             return SafeMath.div(SafeMath.mul(_price, 113), 98);
583         }
584     }
585 
586     function payout(address _to) public onlyCEO {
587         if (_to == address(0)) {
588             ceoAddress.transfer(this.balance);
589         } else {
590             _to.transfer(this.balance);
591         }
592     }
593 
594 
595 
596     // PRIVATE FUNCTIONS
597 
598     // Safety check on _to address to prevent against an unexpected 0x0 default.
599     function _addressNotNull(address _to) private pure returns (bool) {
600         return _to != address(0);
601     }
602 }
603 
604 
605 
606 library SafeMath {
607 
608     /**
609     * @dev Multiplies two numbers, throws on overflow.
610     */
611     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
612         if (a == 0) {
613             return 0;
614         }
615         uint256 c = a * b;
616         assert(c / a == b);
617         return c;
618     }
619 
620     /**
621     * @dev Integer division of two numbers, truncating the quotient.
622     */
623     function div(uint256 a, uint256 b) internal pure returns (uint256) {
624         // assert(b > 0); // Solidity automatically throws when dividing by 0
625         uint256 c = a / b;
626         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
627         return c;
628     }
629 
630     /**
631     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
632     */
633     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
634         assert(b <= a);
635         return a - b;
636     }
637 
638     /**
639     * @dev Adds two numbers, throws on overflow.
640     */
641     function add(uint256 a, uint256 b) internal pure returns (uint256) {
642         uint256 c = a + b;
643         assert(c >= a);
644         return c;
645     }
646 }